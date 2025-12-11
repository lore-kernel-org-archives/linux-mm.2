Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46670D3E793
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 05:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F71B6B0007; Thu, 11 Dec 2025 00:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F646B0008; Thu, 11 Dec 2025 00:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846936B000A; Thu, 11 Dec 2025 00:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8396B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:41:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F16798AF5C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:41:17 +0000 (UTC)
X-FDA: 84206092194.14.ED1024A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id BD455C0008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:41:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LfrdNDRS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0EALqYV0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2Tq+rJ79;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=404DSq8H;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765431676; a=rsa-sha256;
	cv=none;
	b=P3fmVCiXsA7Frbza1L2MZ8USHOX3SSFy642LebxkPl3L1B7lerIFh0znbyLEocjAIW2Ewy
	l7VZfaYTuyYWydVef9oSj17nH2p8d0SPPUEeP+t6ojth12eyjoka5WuRGEuiYlUdS2vsJA
	kmikfGZtdhG/OsPSlGHy4N3DY2J/MY4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LfrdNDRS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0EALqYV0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2Tq+rJ79;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=404DSq8H;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765431676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=du9Vw+WqFZYX8WYrnsA4KjpWmVFOAiC43jEmgEbVbFY=;
	b=HyCATikewXQ5kADECbgUb0EmQMk1FbeFSrvAQJjC0poxpfVI/J079zE9zen7t0DFRE6/va
	W7/XKZ/FIF7hC5xbQmMsnPO0oKCbmkjvWgqt/vBYf9DVCT/4xUSidRoHzJeVp6m7aTcHJp
	0Z1GDp50wGm6pCdfGefVs27PsJ2jk/U=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 15953336DB;
	Thu, 11 Dec 2025 05:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765431674; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=du9Vw+WqFZYX8WYrnsA4KjpWmVFOAiC43jEmgEbVbFY=;
	b=LfrdNDRSDzEjVZQwVgCrlhGuwjLBpbslVk0U//lXUx6GnslouBf2CAT8KLlB8Zyi88dkHN
	YOUnj4EGu4S9/5tjeZE9lFQize7+fTlWyTSONIZIXSfQBBplyD3dV1G0U63Qcv+MQSXZBI
	KufPLQmLyJILZY8/FYi1zERwtqKhqmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765431674;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=du9Vw+WqFZYX8WYrnsA4KjpWmVFOAiC43jEmgEbVbFY=;
	b=0EALqYV05VlztcABwHmdHIix8Cg7/M4snqUNUKziLo8Uf12sD+r8L5HvLHCwV4uIvR0zUw
	72Hr+Ho/+THJH3AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765431673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=du9Vw+WqFZYX8WYrnsA4KjpWmVFOAiC43jEmgEbVbFY=;
	b=2Tq+rJ79md/OZ353tMg6n2dQDSTYVJ9HXa4Ja7UH+jpTPqbJnAXK4w7ns0MCnxwdrtcDud
	xUW1Std72qszdujnExTNuFwmyDLUCWsmzVF9QtbZL1kYdCbKmweDiGVm8pEhAVuGWebje+
	e2bLZn2o2yj3XHS88+ZlXfCbhg2ANIg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765431673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=du9Vw+WqFZYX8WYrnsA4KjpWmVFOAiC43jEmgEbVbFY=;
	b=404DSq8HQoDnXLGc6XlgUdvk4NJrKB+UIvumgQz1rWjXIsC8Bjtxew6i2DMaEhWlShwFAb
	ccVT9TTxjpOMpvBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D611F3EA63;
	Thu, 11 Dec 2025 05:41:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cnNVMXdZOmnRMQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 11 Dec 2025 05:41:11 +0000
Date: Thu, 11 Dec 2025 06:41:10 +0100
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Liu Shixin <liushixin2@huawei.com>
Subject: Re: [PATCH v1 2/4] mm/hugetlb: fix two comments related to
 huge_pmd_unshare()
Message-ID: <aTpZdhXljlYcnek7@localhost.localdomain>
References: <20251205213558.2980480-1-david@kernel.org>
 <20251205213558.2980480-3-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205213558.2980480-3-david@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: 4peir4cx3q3w4ax4sqqeafbge8hbngpw
X-Rspam-User: 
X-Rspamd-Queue-Id: BD455C0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1765431675-183519
X-HE-Meta: U2FsdGVkX19Vq1711B4KUQ8qX1FldkwDU3mdTKRWndTFrvp7K7giLvsJOcwVlnBGU/37GzAsbRNWmsjILIMHc71R84j+jclwPUORgMh6VLrJYt8rM9FLPQGaXYoIZzfHvkzi/igHiUM/naB87ZQxZomVKoH3y4xYgrkfbfZXLP7qSUY298W9497znGzSCEA8P5sV+YvLAwQ6YM/+ZR6DCK6kCKaNosxoD7s1IIWETSwnIZWtXo9hj61THJ6rnvCRKOLOgvQwPW8lbNrHR9a91CerzLHQ9wvd0BGdPWvnRtbNLiOKWPt2LqzzNMOltxMrBJZr309ZmgG4Zrq9Yt2NtyR4Z/erBWOKPtJbFEgpAJ0/3WRJqzaEG2zfQ9XdI9tydzSmNjAtMhLYR8qeY3s8a3fMDjSwTe3i5gsLxtnuwyPai203f76rWZB63jI1Zdbh2c92SwHYSkRcdvpMAdeDkza3VQY3hAWGMY37Gs6bkS2RRJnqmf+Qfaw1CESi4VMHVMft1IPi+QeTXghVYPiQr7n9uAz6GewQyqn6wgIn9V39YNn0zT6bh5D2PF4Q7WKo4lDcqfT9EMzHrLiat1INUorbSPr+SWHRopjBiQ13P8OxIh3vB0rcojwVY+flMGRcC4vZVkrnz6ChavwpLWHQInV9ZMuWnq+QU02IpWQLRlYlWsuSB4VS/UTkz7y8vnI6Hl9lP9m6vMQ39aOrd6UMWNcxcTZlkC4NhJEVcc4qegNuG7/wIyVLM7dwzmtow8nvrhbRfP31dQVHJR23OLn/fFlOlJX2FUmlAZBlTg1OrDKfrCstda8WFUUcpvOlwGubRgsWVDNkiaai2Xkj6kZ8SsVL1pJOmROqcrvtTnfrGI0HkIOd9GGoAkYkJydZYdRhzBUHkQqSxE/iU+zMib61GGlJbrI8LYjJ4INV/AxOl31OmI676i8hQq/JHhuExm9NDka3bl1iMubFf2ErvI2
 6Pzv4z7F
 RurzwR7z59cOrO1VEO3LE/AOamKpOReVGgHG8YztNrZx3FvWvj+uqCCk10idP22oykXKBCr7DfMkfRCu19jzW7CfktUZPpsp9VtwJePzN+FxrgRE+4vXu9/j/2YXdEjmrzxeLgVHAjam8f8v1XicDVvkAYO4WrLQLTW3Tr0FY3t7XlCYUpkLXZcb17hVusQg1gTj5ddsd5DjuC7dSVIqd1qQd4rJy8sK8iFgl7UEjW+9xM2bd+M9Z2SV9PcNt2UwKHbPZdxn1mQmBqqo0d45NaeUxFuyOhaY4K6aY+XgAH2mgIbt/+Oz65fctebd/SgbpLXBKCVbXXPL6TbxloaDI9s1hS9HiCGZp2Pw7IKkpV9Gw6kaHn3i7IvnQdicSjVWE4tTlD08wEQjbIApNjt6Kn2dEf0c77H1dMYapQ06c8q0hqtHaqlRy9DixYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 10:35:56PM +0100, David Hildenbrand (Red Hat) wrote:
> Ever since we stopped using the page count to detect shared PMD
> page tables, these comments are outdated.
> 
> The only reason we have to flush the TLB early is because once we drop
> the i_mmap_rwsem, the previously shared page table could get freed (to
> then get reallocated and used for other purpose). So we really have to
> flush the TLB before that could happen.
> 
> So let's simplify the comments a bit.
> 
> The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
> part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
> correctly after huge_pmd_unshare") was confusing: sure it is recorded
> in the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do
> anything. So let's drop that comment while at it as well.
> 
> We'll centralize these comments in a single helper as we rework the code
> next.
> 
> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
> Cc: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

