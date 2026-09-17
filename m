Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A1ADC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 08:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2886B0093; Thu, 17 Sep 2026 04:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB9F6B0095; Thu, 17 Sep 2026 04:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1C06B0096; Thu, 17 Sep 2026 04:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0F66B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:43:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE37040286
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:43:32 +0000 (UTC)
X-FDA: 85222615464.18.F7E939C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5C601C0007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:43:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZ1Nv4E5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZ1Nv4E5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789634611;
	b=GS/z7NhAhDHLtNtcyjZArCMbDF/ju9pQciWDf3EyhWHYUEnomZZKvFdk1UmWlQRwonFt4T
	viCx1Fj4i4nNDXZ5i5j4ByVk/ZPVKES2TAC9JvvMQX6SXjd7rCA6lkZS4NBFk1Api9mijW
	CNne37G9CXXoBee1TQXXZx7IHR86aVw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789634611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZdjSMK1O73M0g/SKYTQXMO6bB6h5wxyUE1M5wazgR0=;
	b=8c7gogmJb9uMAfH0Kc/7bv2YIrKjcx3gajQSN1W5c4o7/+4RbSdcBUUDJlopQ4RH/aLIyj
	N5PkMwfABFAxISf5EEJeGZbvcC/xqWeeP48byaAwqrKGKs0VlGsMt6adxYJ+lqv29qwCBI
	1YHxjjj4GyCDvMdYj80i73SfFZ1E3gg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E254417BB;
	Thu, 17 Sep 2026 08:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505C11F000FF;
	Thu, 17 Sep 2026 08:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789634610;
	bh=AZdjSMK1O73M0g/SKYTQXMO6bB6h5wxyUE1M5wazgR0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=cZ1Nv4E5M8ZqvrssciqIPmbcB5tnUu3LISQlyC31sZV4aLmai4oBlDr0ZCMJJtt3O
	 Zwzp39lzTFzX94viFolQ+w6JHMMxiVd3yt/YwuJl15kd1pa3Y2XK36Uioz915XaIXy
	 ADNAu+j61uQXJJogMbTMssodfeJEbzWjPHIaBa0SP5qkL8Okggq7YiVnjEXf6ZItyq
	 KkS71wjnsZDMh+iXkUo4auLw3X08RPkjSfXECNvtxinNP60v6cSskmcff8CQujWKl3
	 WneAAh86Egy/phHyKYiGLo7lDuLPDfJ/qM2sax0hm/rPW3almwiNYYRM1OPwo03Lhf
	 fD+pONFOrnWCQ==
Message-ID: <e988b0e8-3ee9-45ed-9d34-7b73d86d9cfd@kernel.org>
Date: Thu, 17 Sep 2026 10:43:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Yuan-Hao Hsu <aa9736195201@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Aristeu Rozanski <aris@ruivo.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260917083747.786-1-aa9736195201@gmail.com>
 <f8f6d553-d818-4cc6-a1a1-a9c9149a17e9@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f8f6d553-d818-4cc6-a1a1-a9c9149a17e9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D5C601C0007
X-Stat-Signature: p1tthsdreriiiejxdqdkq318jmg4yjot
X-Rspamd-Server: rspam01
X-HE-Tag: 1789634610-119976
X-HE-Meta: U2FsdGVkX19S9J9xNqRWT76MkFIIXrfd99R2MEbhNC5xRa2+aoEHKvLdY3Ssq53Q3qsw55Y2uFAMDAPLMf+Jp5lUqrfQXvqx6j1PiMh66VtEPtFuxBXXLsbB7VuLD0CiqNIB8sEI8iL2ntFb0blG95N9ROLJ7JeQ6+y90c6sP9pImma7vW9EP9MsEeBdLoqr7TPxMffFpp4pBGsgOKBcDGA9ApvCFvGVbhX5bu4KEJsNQsZ25Hn8GXhPzS/PTmi6gdIf8C630c1iNCG4UiTRj+BDc2hHN9cNENW0koxVSukXXyLpQfy5xlLee0wRp8PdlK9GCb6AQfsZcMYscUfZtyQ3uL4J9gJshVz7dvNf0oZEWOQ9aQRt5bzr8+YzvH+ljAGMPk0ugd77KTt9mnivT76iQrCClk6AJywoEEHrJRK/XVLs4N537rcNS/oiMNk6ih+Qxpy1JBjD22SsVAvEZmD5xPFSpp9m1Ke2UEuhgupcQ44mrQz7AN93JzyB8YZstJ1m41MDroroowh732N6lc6aWpIZXihcP4ULWBtH8olFk+6YYEPjzdP0JH/Hq4+DFvRbUS9op+8wYZwTCFGeTL6/Mnmu3HZqz4zGJMUBDytpjIYlW1hYS3U7MuUC6uYAHzpgPn4fRJmnZNkmS5f/6GQ6DC5+IXhO4d8B3UOpCS00pKWh0hdjZrc2I64JEsVPyZKzhQVqoq87cqDGzfM+5YdRZ9YLt8wxx4HUzmZocpkj+WXbQORTQ+9V+hn5WhPOP5g9Ck/YlhFLIZJFRm0uvTdwe0X1X7HBakc1qly99tmvUYBCOFvbHW7ndYYqU6XZ+jMVhSReWf5pfcTtX5iNuQeTjPkThTaToPScm2mvCHzdw6OQNFDVpjwdiokpJI18suWJFCCossWVfbo2igiX0TwUJ4AnLaLCFi+cbyl2mWXofJJKkn0XtMpWl+zLItN7j6re59ulEfg226O29r5
 61VxpkaD
 BhFcN5NpDVckKRq/nK2lPgsznCqd6JHPaDdoGr9e/i1gjBXiO5FFveayOg/7dvXD+yNadAzJWhZt6Hvdw9b+ObaB23UjSjhdzza+6FccmzN+YikyH0Wun+73gW7LkzRenpCsS+TTjs5pvLvasJ35vmviSAnZPVi3L+sFRBQ7EsVtrU2fcosyIG71NBnMnLOmbdTnaEKC94BWhvGTgVeC5FQGLlfAW2WuXt41An92QhkSB8HqqUQxgYOQRAy9scLBafFbD7T6RW3CmihOvRhBLgcNb2eLD2LiQUxJPPFocjYMRfZFzHxIFmdgqvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 10:42, David Hildenbrand (Arm) wrote:
> On 9/17/26 10:37, Yuan-Hao Hsu wrote:
>> GUP-fast grabs a PTE-mapped large folio one page at a time.  Every PTE
>> costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
>> atomic, a full barrier and a node stat update for FOLL_PIN), a
>> gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB mTHP
>> pays sixteen of each and a PTE-mapped 2 MB THP pays 512.  The PMD and
>> PUD leaf paths already take the whole range with one
>> try_grab_folio_fast() call, and the slow path is getting the same
>> treatment for PTEs in Rik's follow_page_mask() series.
>>
>> The users are the hot ones: iov_iter_extract_user_pages() pins every
>> O_DIRECT buffer through pin_user_pages_fast(), io_uring registers its
>> buffers through it, and so does RDMA memory registration.  With mTHP
>> those buffers are PTE-mapped large folios.
>>
>> After the head page has been grabbed and verified as before, extend the
>> run to the following PTEs that map the next pages of the same folio
>> with the same protection bits, take the remaining references for the
>> run with try_grab_folio(), and fill pages[] from the run.  The PTEs of
>> the run are read while the reference on the folio is held, so the folio
>> can neither be freed nor split underneath the scan; a THP collapse can
>> still detach the page table, so the pmd is checked again after the run
>> is grabbed and the run is dropped if it changed, leaving the next
>> iteration to hit the existing pmd check and bail out.  A read-only run
>> of an anonymous folio stops at the first page that gup_must_unshare()
>> rejects, so the per-page exclusivity guarantee for FOLL_PIN is kept.
>>
>> folio_pte_batch_flags() does the scan.  It reads the entries with
>> ptep_get(), which is not safe without the page table lock on
>> CONFIG_GUP_GET_PXX_LOW_HIGH (x86 PAE, mips32, sh) or with arm64 contpte,
>> and GUP-fast reads every PTE with ptep_get_lockless() for that reason.
>> Add FPB_LOCKLESS to make the helper do the same; it is inlined per call
>> site, so the other callers do not change.
>>
>> The order-0 path keeps its instruction sequence.  The folio flags are
>> tested before folio_set_referenced() on purpose: a load of the flags
>> right after that locked instruction cost about 25% on order-0 pages in
>> the gup_test benchmark below, and reading them first brings that path
>> back to the baseline.
>>
>> gup_test ioctl over a 256 MB anonymous region, FOLL_WRITE, 65536 pages
>> per call, median of 15 runs, two baseline boots / one patched boot, on
>> an x86-64 VM:
>>
>>                        get_user_pages_fast()   pin_user_pages_fast()
>>                        before       after      before       after
>>   4 kB pages           849/789 us   783 us     1174/1138 us 1094 us
>>   64 kB mTHP           812/811 us   126 us     1215/1113 us  188 us
>>   1 MB mTHP            799/774 us    59 us     1185/1077 us   64 us
>>   2 MB THP, PTE-mapped 803/786 us    57 us     1159/1120 us   58 us
>>   2 MB THP, PMD-mapped  42/40 us     40 us       46/41 us     42 us
>>
>> fio O_DIRECT randread of a null_blk device (CPU bound) with the I/O
>> buffer in 64 kB mTHP, median of 15 five-second runs:
>>
>>   bs=1M psync                 126.2/125.6 GB/s  ->  220.6 GB/s
>>   bs=1M io_uring, iodepth 16   71.2/71.6 GB/s   ->  112.1 GB/s
>>   bs=64k io_uring, iodepth 16  50.2/50.7 GB/s   ->   60.1 GB/s
>>
>> IORING_REGISTER_BUFFERS of 1 GB, median of 15:
>>
>>   64 kB mTHP           6179/5998 us  ->  1599 us
>>   1 MB mTHP            5790/5801 us  ->   893 us
>>   4 kB pages           7173/6741 us  ->  6763 us
>>
> 
> I think Rik was already working on this and sent some patches. Anyhow, there is
> quite some GUP review backlog I have t go through, so this will have to wait.
> 

Ah, no, Rik looked at GUP not GUP-fast. So I'll have a look but it will take a
while.

-- 
Cheers,

David

