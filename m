Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02991606A325
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 12:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299A26B05B4; Thu, 29 Oct 2026 08:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271136B05B5; Thu, 29 Oct 2026 08:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160F86B05B6; Thu, 29 Oct 2026 08:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE1F16B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:17:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 870DA1C395B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:17:18 +0000 (UTC)
X-FDA: 85375563756.06.3F4328A
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9C201C000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:17:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793276236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rdj4FDEy6WzQ7Loxo6AfInFROqOgDeI/IwQhhy4RHXE=;
	b=R+X1rW8R5h7JZieGsugEq5Xzyo0gRUgA3pyJwmrEP0g/WwtyAcpTuTnl+p1MAn9KFIbx4V
	Wl4r8zvjkzu/qdYZAoVsu7vLqfA2PlWvzTbxPFqjR1Ot80izc+iUg0oinz0E5FK7cRQBeC
	NXkNDoBGYrMclKuClCYF0qti1ZYw0G8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793276236;
	b=YjYg3FeIXVKjp2b5WU3toyZKRBd+++ODWrHcDyb+VawkJVRrM8TcJ+GQ9HKq3HMjRKJp2u
	vpMsHx92LI4HUkPn5BWm9IH6dmhIzwrO8K28moHe4scVVh7lDySQYZ3F0fpgDPkzbN5OQb
	j1VONC69/FqI38pWKjV9webfGbfd1+8=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6026368BEB; Thu, 29 Oct 2026 13:17:11 +0100 (CET)
Date: Thu, 29 Oct 2026 13:17:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Salvatore Dipietro <dipiets@amazon.it>,
	hannes@cmpxchg.org, abuehaze@amazon.com, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
	david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, matt@readmodwrite.com, mhocko@suse.com,
	ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
	surenb@google.com, vbabka@kernel.org, willy@infradead.org,
	ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <20261029121710.GB24651@lst.de>
References: <arFBr22V60BMmVpl@cmpxchg.org> <20261027150002.318916-1-dipiets@amazon.it> <20261028144148.GA14023@lst.de> <20261028225517.75e13881be22461a8c94e07d@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028225517.75e13881be22461a8c94e07d@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C201C000D
X-Stat-Signature: uhm6yf7gb5zfmcnwidzdpxnwq8sxyqch
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793276236-932924
X-HE-Meta: U2FsdGVkX18FFeTtHBEZs9N4ej6EmL2RlE142UCnZCx0wI/AnqZRfTzwKKPycdeEd/C3GtNqWEV+rQrWasyAabJ6aLBUzyU7mtHv5N7GVBILsXRczpf7E5T9p4rjQL0CDvVMhE7s/h9OVuukIG8jn8AMGOhFFBVfOcyq9w+h6Quznqh7jgLU/xlz4Be8rB+Fp7vDxjUhEAC9gd6bJFXNu02T7I1VUuobvbddrIkszBQPFwku6ujqiNd+g695DBoXeLPQFQx6nMM5EoDj5QHVB1nu7HX1G8y1fgEi1nTmp54EN6bfJZMDJC4LxSBOypnPjKA1OxF/ao5JOBnm41F1SBfkUbi5EY9ghJxKbHMLfuujBS5qLPLQ5qpDhTlB+atG/Ij80ZWj8kWo2k8IxlQY2UhP6OmcBOxCdTvKcgOyQVgJvjSUdhKmi9xUZLxgPomxAW9dTmsk0Kyj63qDEMQqP7vGG6D3nSIPwqcw6VaXQp8Foa4PClDT4SVN5QBhj4cwDZy//H1Bol5gBl/KiSIgX5yO2VH6Onsj+d4MMnaENgiWpItEsBwTit2lr9gkIhw8XdjQ75udc+m5K8yNQckyMjyTdNKrYY4nXriMEE3wfaHtsDVsM8HRbAC9lPY/zVwk592euCmuV8wQFi15qlCDzWFN94KLL31RYmndCt7qtHqJbFkNYie6wzeWrvrFLS6xyKYSF7ACZ50E2O64flaPB4a68+D0I4hk/SQrERppVjdgbjRR6HNt3kqZQ3Bsn3g4GEPt/cnMdaoKvj3ol0XkiMcITq2cRJaB7Q/9o33JHjncbbC6nqwJCdE9t8gzIQl0bPVhIwbhrjZKMYaH9Vk2eZhFtm3IIt9V/Qpw5nKtKBa5LB516kKtkvpywsWA3RyT2ThcbTHyV5QCimgOKFGI4qNnAv/MSr9jOmmbyc32MILL3bq81admLawLDNKkRwUUEcPg1bBbtuS1cPa+35G
 67Bb9OMm
 CWcf1BJBVc1bRA7yuBPW9MtekG2lPmDD0bc4BVJMaIOPvmo1eRMAt5IvA2k/kcUJ/zLKprLCjX3pIbswiDVuhUS2Fobts5od2+swfSP3GB+R/tKbpC9PUo74QJafoJ0xG1zATXcts8OAGwBdlcY12BzGwoE1PLe0MuEzBnP8N0fTSuMCxBJqG/oUBraVWUdsY2lUqIneebm0/OvtDTTqxWIq9UjANYGeiXh5AxAQc/AKMXRyhs2Ba4/PBjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:55:17PM -0700, Andrew Morton wrote:
> > It would be really important to get some fix for this into 7.3.
> > We can still perfect it later.
> 
> What is "this"?  You're referring to the performance regression which
> Salvatore's "mm/page_alloc: avoid direct reclaim and compaction for
> costly __GFP_NORETRY allocations" addresses?

As in I don't really care how the xfs/iomap performance issue gets fixed,
I just want it fixed yesterday.


