Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57AE7606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eJm2d3nw
Received: by kanga.kvack.org (Postfix)
	id 27A216B086C; Tue, 27 Oct 2026 13:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251A86B086D; Tue, 27 Oct 2026 13:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1445C6B086E; Tue, 27 Oct 2026 13:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF12D6B086C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:36:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E0F080A65
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:36:08 +0000 (UTC)
X-FDA: 85369109616.29.6387352
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9890B4000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:36:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eJm2d3nw;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793122566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tn+ocp8Z0Pv5iXA3uYeoDAMsUVuEMuroDimQAuxM4E=;
	b=jHrPD0dwQhvpRAYtVyGahkk0wR6b31tObFrlD0blzMJU+8yUWF29PShGnOC1zNAuN4u3z4
	JSfUPqafao+AhEOVMZ+CtgPfBFsHD7P2y2GUIOujXtR65mX1vfRVjhhenuh4rxa3aV3ZIX
	HGIflZ3CXXlclzMDIUKTqkjL8R67bzY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793122566;
	b=Sd2a7Jhp713WmNy4jFgRlHh3LwISX47zDTWptS48uS9DJMT6oj16DXpX+ueReSuCuVbNHW
	hppoU91twWumkZwepgHL1vGRfEVjhaiqVbT4ABD2kYT7/W7G/NDvrnpDpNnm14dtLYcKTE
	pQBJ3ME+L7vQhOQrAYfCNAWODHDPTG8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eJm2d3nw;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7AD743BEE;
	Tue, 27 Oct 2026 17:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B631A1F01825;
	Tue, 27 Oct 2026 17:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793122565;
	bh=7tn+ocp8Z0Pv5iXA3uYeoDAMsUVuEMuroDimQAuxM4E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eJm2d3nwlX8eIZXNWqaL2i7CW0VVze0Ad0V2NfYtR9MZ4ZxW46fjMgelwFfLUWZZU
	 BlysjogYaO4f3rgGGm2l/ebR0XluuHEktbFWLIU8+is917srBP28ecO0+KYfPN/mJx
	 7nQ+0rCZT2mhfguFnz6gZjpDp4II2jvMq0/RsEMm8IKCDPTT9vEa2YN2v/ZPyUaWwY
	 ZFMQ06hyEE+vQLY4DIETxwrfrYq6ZnVczkd5qFpDUQyPxE12D0XQRKEyhamRbNjIhm
	 ZRIEOOZXjl49VJCFM9/rMjbdII6KcaorWO9rqGMznNIOOWHwbdjG9fKQdUfkgxbH+X
	 ZigaJgbrPET8A==
Message-ID: <fcb7b786-53e5-49bb-8505-63eb8bb4e836@kernel.org>
Date: Tue, 27 Oct 2026 18:35:51 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: allow freezing mappings
To: Pratyush Yadav <pratyush@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kexec@lists.infradead.org
References: <20261027173031.763213-1-pratyush@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027173031.763213-1-pratyush@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9890B4000B
X-Stat-Signature: tmtw6yewt3a15wb4t7z3dyuuktnfqzzs
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793122566-223373
X-HE-Meta: U2FsdGVkX19yLPHS4FKQO7Ehe1mWSea+4OASTrldv2BU0cAnPmF1XndtEYzGewAjVCI91x2H17mTO8TaCKHpbgduPwFhg6kOB+EPOw0EchzgSK9sOMQMs2eb8UT29TrhGy27XGBMm06YCukqI2p488z/OyeGgX14uDNrH8rjbM8Y0fqmIDhBGm5sEyEGP1VCHE8VYFCjnRdoePzsntATAYXp03Wi+UEXD/9gchL0iYLUAwnmQXFi8Krk3MIPwoXmACd5RF84y17RuB992ouZY35MA7mYL7EtNPovqCGsCeF/LT9uQ+fOQ+5agRZsuCbLnDXsvFvwp+Pb2V9o02poCmUG8sM1CO4zzVtkxAuB1xqFNWWzWQj2SipzZgGYOtBmXEAaTrHTfLl6FjSNKWM5WyD/OYMApotP6vhbb9ACvdewvukWyz6MJz0UpikTPIuCwz/LMzld4dukPUnLBsH4qKY28jXqIhuVJ7zrGziIoOyiemrZwboPMSZoLLX6Ng3+uiXcCSbLNxDhU6UdWlFEAumkEINHhZEnajwj9HMzz4RkYLUnokh8wRAyFgwpGNQmVv/6xbgTQ+z1eiyF4v/fsIpiAqO9u/j9+RIgOw9pjvoEwhYzElERV+F9YHoMNTqDrGzyj48GRYm/GKDiC5gFTSWU9L7khrjL6ypInVZY19vuobA1Swb6T5uz+jXEgDXgOxd0oCrrtDKVWsneI57gv1SXzgNMUMSTDsW035hOxFYtWt7ekmLWnx77gjkYMYlX/qdmsh14cnyOwGoI39Jn+Gyo/MunPVF7V3Bu+Th03Y9OFkVdGojLX3p/7wmf1MrSDTBNEBQdANTXK2mB2ETLwHncMXYK0XPbkNi1M2s7ni3oLA5GL99iBL3mUCQKeTGaGjlB7pa2DUWXv1u/E+4XDkevC+szRbaVMilwXoKiPZU7FdouD+dOfu9yiD/6TkbvlOU9pMM1X3RtdHQnk15
 s/uK2Hx7
 3W+Yl2xqPyaxyS/18yhnYQZ4ZSLzW3DcanxbjO48KbLBdIyX/V/Kb0vnKCc+ETxPyg2jGWVZdUtgjlht8NlE4pXLG+Xk7QqQk8HR50PQIWl5VugeJzLEc3T4zFj84nFWdxQJH+VhDhFUYDnKznUe+3Z0Km9lIfFVTzDISXLuabtGAknKKddmNmI91UEiz2li3SVA5yg3/XCmqGFGP7ZKTixwJGLC7zZEfZXd1TkiqTulUmvrIjU48yKQqFeqBhhUXeN52hCsgkP6cG5FOpWDavBuZJADbH7Jp5pc6TplXYFWVTl+V2bLd5YyRg/ueW+7wdLPTDho1mmlx6eiMPjCef+1Ij3BOTIML1EY/Aj3/qzuELVFqe0F4hcsRx2nKiDo4sMbo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 18:30, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Hi,

Hi,

we're in the merge windows and focused on fixing things (apparently all of the
kernel). This is not the right time to discuss new changes.

-- 
Cheers,

David

