Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 731CFC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 18:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E236F6B0005; Sat, 27 Jun 2026 14:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4D96B0088; Sat, 27 Jun 2026 14:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA466B008A; Sat, 27 Jun 2026 14:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A69F46B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 14:05:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A61B1A01F9
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 18:05:46 +0000 (UTC)
X-FDA: 84926470692.01.307700E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3FCD84000A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 18:05:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="sM0/6iFI";
	spf=pass (imf12.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782583544;
	b=zVfGXA6qvdRVheLOBPlhl92YNFRvvK6J5+JkvHjsz04b4U9eyHK1ZGh3f0JwKPRK5zeAkZ
	JYfKJOTMcctampBS2VFtVa2AaRsBlzAU5YdnUWTp7jJXgJo/7n3o2cXxAav+o7j6DglG/B
	dRFE1AUOvmZjREW5Wf6nJSbytWqp0nk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782583544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2uYEpyqVz1KpeR16cAXx1a1Cm6iq2umu7tBDggjjrWQ=;
	b=UZ/684dztPfXQHinb+r0ODZhHl5lYaGFJJDo19xWM+NmnJdJPpG8rR0vFOo+WZIztfJQVi
	JH8Ru+MR9RQDwlfLCX2PXPhYs1hMTUmAxB6W4hY92S+0rgaTbNmKNATqnPxlNR+z7cXF/a
	Z4sIzR+FkP5QkLf+na8vTI0sr71/wJM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="sM0/6iFI";
	spf=pass (imf12.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
	bh=2uYEpyqVz1KpeR16cAXx1a1Cm6iq2umu7tBDggjjrWQ=; b=sM0/6iFIF2eh297kaZ/SR2rwnx
	jjLQF+pSNgETkG/t953bmsrRGYVBaviNKgOe5mWb476nr/Qu+cmyPK4CFeKhKrBjiop/8qFTDXGgt
	4KEYGruHNehNtHcaPFNVDtpAnd6BGqYt4ifHspkkieaveDXjL1Smd+5qVIn2NZ3yH9/lSs2cZMfPi
	28pJvqcYU7bTDc3agqD/pr1PuV1mxJOFGJA3xpa6O5EqvKzfytwEM0F6zSWeU54eqm6j3u09tRRAv
	oYsx4D905RWVVJEYnUTYzeCTcJqZDdkAM/u5bP0xcS27XvjfDmWRkc+uBLvXVi1KjmlDpJXhAJB6I
	E7ADlaWA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wdXPO-0000000Ch6S-1U1S;
	Sat, 27 Jun 2026 18:05:38 +0000
Message-ID: <3975aa5f-a959-41da-a312-36c1ab67120f@infradead.org>
Date: Sat, 27 Jun 2026 11:05:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: Fix brackets
To: Manuel Ebner <manuelebner@mailbox.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Shakeel Butt
 <shakeel.butt@linux.dev>,
 "open list:HMM - Heterogeneous Memory Management" <linux-mm@kvack.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260627093258.31265-2-manuelebner@mailbox.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260627093258.31265-2-manuelebner@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3FCD84000A
X-Stat-Signature: eng78s3qm44h88otdfzbnbzk81hgsfzc
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782583543-718635
X-HE-Meta: U2FsdGVkX18NAAzGz8MPZ2mMVSr9ky80xRhc/ZzTudlWQgipH2R0XVydbXRxoJcdV2eM4Eh4/lbi/3gShUpigU2JiJWCQicaoQSLFzulEsWuPZJ7ladrbnZ7zn2zA4dyOgcngvskx1+hW8FkA3ME7RqYiQQDkqBZb8TytMRlkGmIx0ELphTzji7YgP0R5r2biIB15PLTjk6XbY5DA7Ss6D40D580D0OGIXgFf9eKTGfC5Gjnc1FmRomgGeqJ2horzZ5fzmrc/UPr6o+mkHSj3qTHZfg842jX+AWIoaonZVXBculmWNJhNK7olalh1eg+Xv4aHNX9xHYsuZ8X3oc4PXWVHNRS+ljGqwEaNwHKfKothcM3Uayqo31snQ5NX/J4JY1q7PVQRYT6t1nDmwztBj5pn2e1ekPxAdGRgxrK3/Y5OEYNwsazdpW6/r9vYvsEJFn1uFF1ivcw1FbepNGgt/QHRwLt9bPk+a+UXcHHA3hYupof3WcdfPdNM19NOPeWP8f0oXODRJhEezaXnLjlD/aAXJ4K2h5jdNRuB0J0LeABy6vijvvYfE70ernEy0DBjbMzOfV33/zBXqi++rmsQLJOfhFi4WB+vqzgGt1TftGR5sMRBUQKOnjOCAKzdJQGeTU+xNwHa83csBfPQ93nvP8BwoT5zSSGndStIKoxrZJslVZB+dMGWBzESa3oeC3BxSx45EKtKcmkw8YzWjbi+xbX/+QUCMK7brVocGhaO20MvVizc6dUQ8oSTjXkyfSts2DSsLc3GwbZXrJzjs67KPFeJWIgsyxOvr8qgxYPrEQkxwjNH9fz47ZHiJpT6EzibgF0cCL4CSfGhjXQRomgQE7oh8FcKSRZBZDB2R14Vk7unMH0+/ut30dwFKLF5P6xOOa6Px080ebtNzzyjgKve/3oq4BVWMaM3taJY68qf5cBmQroK++VannurmsqftR3gotiVNrzBWqJyb8xwEF
 lCgTfrIW
 +T+LthaxwlgRXjM5tqJLHaObKAjgLZ2T97kl/6ViE8qIHeSckQAU5ZdO9IWTO2oGCi7SshouDkBo5CdRsmKbZ0SxL1FWCy4gVusic+oosUcuvvD09Ka9V57RIwGxeu+7L5DPugF7CtbbrhgMeyEMiFW50HzS3LnLtJxtncbzoTihs5Pq1vQv+oiTGUEEfSPcLn3/O1UXsEftfm/OgOlbsD1y+Y3Se2htTgNAxYdbepidnYbFAM91lWDiDCzyj8JoreKbrOlUQenzR9I3VjY/i8OwCXODVPTHlFQNOyBNtXLB2YyQ+TD7hW1h2Ba8rplHj06LGlmaLWo9J1BqiZzqeZBZharKkpVLDO3JPatSgd2kbKfvY4L2Oa2hRB05r4yDelkYmCYreLW6Io5crVV5mN8EE8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/27/26 2:32 AM, Manuel Ebner wrote:
> Remove unnecessary ')' and missing '('.
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/mm/hmm.rst           | 4 ++--
>  Documentation/mm/process_addrs.rst | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
> index 7d61b7a8b65b..54c461e7a143 100644
> --- a/Documentation/mm/hmm.rst
> +++ b/Documentation/mm/hmm.rst
> @@ -191,7 +191,7 @@ like a CPU page fault. The usage pattern is::
>        mmap_read_unlock(mm);
>  
>        take_lock(driver->update);
> -      if (mmu_interval_read_retry(&ni, range.notifier_seq) {
> +      if (mmu_interval_read_retry(&ni, range.notifier_seq)) {
>            release_lock(driver->update);
>            goto again;
>        }
> @@ -316,7 +316,7 @@ between device driver specific code and shared common code:
>     system memory and device private memory.
>  
>     One of the first steps migrate_vma_setup() does is to invalidate other
> -   device's MMUs with the ``mmu_notifier_invalidate_range_start(()`` and
> +   device's MMUs with the ``mmu_notifier_invalidate_range_start()`` and
>     ``mmu_notifier_invalidate_range_end()`` calls around the page table
>     walks to fill in the ``args->src`` array with PFNs to be migrated.
>     The ``invalidate_range_start()`` callback is passed a
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> index 851680ead45f..b391502fbfd6 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -724,7 +724,7 @@ the zap and the invocation of :c:func:`!free_pgtables`.
>  
>  Since it is assumed that all such steps have been taken, page table entries are
>  cleared without page table locks (in the :c:func:`!pgd_clear`, :c:func:`!p4d_clear`,
> -:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions.
> +:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions).
>  
>  .. note:: It is possible for leaf page tables to be torn down independent of
>            the page tables above it as is done by

-- 
~Randy

