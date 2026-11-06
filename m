Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4E8606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940E46B05B3; Fri,  6 Nov 2026 05:42:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918756B05B4; Fri,  6 Nov 2026 05:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8544A6B05B5; Fri,  6 Nov 2026 05:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61A4A6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:42:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 01AF4160CC3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:42:11 +0000 (UTC)
X-FDA: 85404354504.28.ECB7B08
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf18.hostedemail.com (Postfix) with ESMTP id 39B1D1C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:42:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793961730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y9kFrNqpqE15U9jIYdrxg+czSD6JG0cMxUhVLzPeOPE=;
	b=t3xZPihrXaCQyQ7HMzgvnGNzIgFZECLpB2flF1+Vl74PA3quvkL+aLhK6O2rHKuy9zVe3E
	ACNOWzclPOSzxzRpu6sba3AfDUCusW8Rg980MN8zC8FhscHIBvczxeKCNhpfmoW+ikk9bm
	mXZLV/95Tz7Y4NZ0dJoIX1hSTs+i1Vg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793961730;
	b=esIkCFt7UktGgRegeTkW3DuKd/iD7rCddVCEz8LBYyj9CFBC83fszS2A9DaagZVfT+zQ4h
	w7AAmbVH6J1wOrLi0+IclRoJwoMStMTdqbydZmZh9xYGuSlkIbrdth4MszA3Orn/ouKPvF
	Zz0FxAGT9mq73fUhDXu4h6uO0ccgFyY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CF4B168BEB; Fri,  6 Nov 2026 11:42:05 +0100 (CET)
Date: Fri, 6 Nov 2026 11:42:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
	hch@lst.de, Anuj Gupta <anuj1072538@gmail.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
Subject: Re: [RFC 2/6] mm/filemap: refuse dmabuf iterators in the generic
 read/write copy paths
Message-ID: <20261106104205.GB5668@lst.de>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev> <20261105065847.196540-3-mengmeng.zhao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105065847.196540-3-mengmeng.zhao@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: yax685ctfxb3acrejop4kb38yxhuq3c5
X-Rspamd-Queue-Id: 39B1D1C0006
X-Rspam-User: 
X-HE-Tag: 1793961730-847802
X-HE-Meta: U2FsdGVkX18d8jAYIkHBGEbhxTvarxk4rfvvCwtV7cZMbpt1YOriT092Dq/PqUZHp2R9AnbWnnLQUEg95VqdBSHp1WvpGj2T9bGE9huYZ2kUtOXtH3huclV7MohFjvRP5WLDxrHsQk6E7PqzVqGvVtgL3lg4wrEpy0JuBdp/aftjAo8J7MC9BvrzQ9V5hAbMMSmuAMHoX2mKUzkAJuRdveO/0q88WXDi4wHxVzvk99mngPMDcj8pp7/jHZOhgs3Cob/ICP3ubicIiLI+C2i+7f9ZLWDERW/VgYUT8MQMau/x+q4IIy0ji49yORfUSb4Lef7zY82ZehMDH3w3ILoUgdSfgASkxO0DHQQUnTs1wUPtxDhwW4s7rzJGtg93H35+Kbkinoy7zZo1qddNWiq93ZRxfR7SAJTZoXgo52iadYLOo1hSU2Z2HK5KN3iC6G0tx2rPE7wviDfDjN0gaUYIbKXw5MJ41nXHCZ/acXXiZBJ06PLlMPvhiP7HYnv0H8PLlKAKj+pCpgT+A6anvLsODbwutDPBXnTk8DLDvyFeJp4CgbAd3bGNFTrrjocyB1jNQmjKwBuH1qEeQ23TB9KnNYBkIY8aoTRm5DuS3Mx92nvTOrsiZdzdNoo2RYlOtu9YItQUI8iThuFip7gwBiGGQTZXzJmK2iieIb/D3feACEFhPqFeZesLkjfIHdbLr8I0Xjh0JDWTBLCze6eM4ISlCquHcgapy78jQf2WV0Y7ndFoclenLpwkwSQ8rOJe0qt13R3ztCkfh0m/Ci9D8N6vmsad4ZWzsRUYgIkIyEaK4sWtD84qjlB30pXcqvv89/JVyclOcCfPnVBjjcoy6bT1fGxomPp2G4XkKO0JkP9geSGe5fW5ARIsa7xE1KeG/SZwTgwqlarYwk+cM6C9qNL3m5AXI6OfugWa2E5v9UdKIpc0DgdIIY/BeUmO0fFuWLdGiK8WX67+MH69qH8QM9z
 ls6f1i3d
 aDbBCUBhRaX+mc6VR7JpwMDSASHrSASnl1KRk1oDtYeKczZauSag2NpijpZPgk6yoF+CUPbgTyZnm1p4yKyKJuierc5Mamcg8GVouaB63e/C1MMaa6DWMvtU4rsvP6kC0KaFZTw1cX85j6dEzFt2CpdHmuzdIPrEnwFwKLSAmSbnIeqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 02:58:43PM +0800, Mengmeng Zhao wrote:
> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> 
> The generic copy helpers cannot touch device memory.

Which generic copy helpers?  This doesn't seem to touch copy_file_range
at all.

> Refuse a
> dmabuf iterator in generic_perform_write() and the filemap_read()
> fallback while keeping any direct-I/O progress, and report a busy
> folio from generic_file_direct_write() as -EAGAIN instead of asking
> for the buffered fallback such an iterator cannot take.

I suspect the fallback code in the callers might be a better stop
for this.


