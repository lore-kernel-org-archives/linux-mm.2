Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F00EC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4086B0101; Thu, 16 Jul 2026 10:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3758C6B0102; Thu, 16 Jul 2026 10:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263D66B0103; Thu, 16 Jul 2026 10:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1FD66B0101
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:57:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9EBF40111
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:21:49 +0000 (UTC)
X-FDA: 84994399938.10.E23C61F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EEF9F4000B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:21:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=htqNAfT2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784200908;
	b=eKrDVqXDmEf0aaTHXJSnpE4hGGPD0L29LUtwySOUVtg7hgNtygtp11tJdtQeELgdcHiiPC
	ZZCCdqdOUHOkSiZHbGOCUwmgnyTOvxmGgYr9qfbke1SSfjdLMj9ml6Skpr5zZo0z3L5/kL
	NBmBIKNASaL/pbMXCaNGtAeHL9I8Nig=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=htqNAfT2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784200908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jW9Bml3oYmUGAOmKPLAJ2CnP/L0HuV5RHmyp2e90SIc=;
	b=4OCP1oJdggxsokHAEdyVGIvOMYyhGn0/QX13F8qeo5umXvUr0VbXYG0jsgggVscx52FrUw
	SojpfMEBWajASE1qc+8YHZ8shDDIAsXYPerSIy//qTMqY5g+Iut9mGiAgWwF39KTjBvGjV
	LwRhRFn7LVel733VacTUO3OAl0llgvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B093B40AF7;
	Thu, 16 Jul 2026 11:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC891F000E9;
	Thu, 16 Jul 2026 11:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784200905;
	bh=jW9Bml3oYmUGAOmKPLAJ2CnP/L0HuV5RHmyp2e90SIc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=htqNAfT2yuc/+HqsQQgqkOeo3B5rAr9UM8Ovms/+FzWEnHs1gXx60lGZ5KC9gpnlK
	 L+/KxPrqScYi6x81ENHVw9cNphhIEtcljCFw7EVh4iMPP1SotWfLCPN2x9ZEVtEqXO
	 IdI+XGELqaL7cQi9Vx2HBT7cDSBgFG3FtFNpQmjIKMFfibqvfkaQxj7q1QaB9zprkb
	 DSYyJZinKVHCOjjDPAMaG4HgW/XaHJkyMW9tMklhv5IbEr/AtslVVoZCi30NCdAs/x
	 EZcK0B5LpQBC4SESt8DUUbjeBCsw9onw8x6EAYSEgHQOIYaOpZsPJayKJUcO9qG4Dl
	 xEpoIyuE/NGiw==
Message-ID: <ee67ea61-a9ab-4d7d-a090-0297c4382a26@kernel.org>
Date: Thu, 16 Jul 2026 13:21:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] fs/proc/task_mmu: fix PAGEMAP_SCAN written state
 for PMD holes
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org
Cc: usama.anjum@arm.com, peterx@redhat.com, liam@infradead.org,
 ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, zenghui.yu@linux.dev,
 shuah@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 stable@vger.kernel.org, kernel-team@meta.com
References: <20260715144234.442721-1-kirill@shutemov.name>
 <20260715144234.442721-2-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715144234.442721-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EEF9F4000B
X-Rspam-User: 
X-Stat-Signature: uwdk56hrm87ijabwrjf9397s7o8b1hpm
X-Rspamd-Server: rspam03
X-HE-Tag: 1784200907-651825
X-HE-Meta: U2FsdGVkX19zOzyxsWmC1VNc311Ln4NoX4T6lz91tW632Wr6Trswsbnk36KVtgr/7UekRDHkjYHqUm3V2xHfxRFyE+1NwZh90uITv/3KQ9PJta0bgolbMXmwOC0QTB12QgrKLxpKaJyiP8jkCY3l6YnpNiV6/dlkw/4iB4PEHGME4jck87BJ35+V1xsTJy5Re+0PvnUiNfFiwAonNkfCv7lR1yhaOqFGHayD3doKHd7Zjx8L+dZfN74Ok5jPl37sOlxv16JcFZkZ7qg3/v4ddC9wXmdJNVJSHIabnGpg4HtO77bVWqn7PgiAoO3o2yLREue0qOsa/g3/AHNY+CPCv70q8bWKIUTGLmTJe17dsXPZV6AOMJ0ToxGDL32kf6Y6qjiCrJ8mIM5qmzWjNelX6kUjaZ+7/5o5NjBEDyOdqLEtImH2zRjDtGsm8sywdaGcNKMnTFpa9asbwmsdiBv9LnaQVPgjAA52N/4wD6pjzz4Ne3gbE1fADm3mgaBT7pO6/fwZ6K0S1LxwAG3uYTr1B1ToouxiKjmrQsSeWXp0I17uExrxdHY7ZihWATvLd9D+NEwFqMbPbmCmzS1xg6Z5xJ0oXkV6hyrHLtfngkbffc6MO8khHbHFmGbQkrgqy5ZSxJUYr5KQEjgxY7ST1qwOZye4gI6iTLRhxsZMrc2/6UB+7jcM25+EB025tPIXd0Z2Vaa4XOUxkVg92K5vy3S7thz+HZTkH6GEb0UN2g2AgD3iPMJgljUClUVNHKzFtI1spFRAJgCMseYpNvYkEOTNCkPsVHVnKGoRIctRCGbf8PfWbig5IScCtoXmrnfRBwFI9gIWIJqtdMBeYerudNL2gL4ZFjTkQdD7DRspFWtfDgnuuMnCk/SGWjkYZ6g+J5Kgx1sraVlYJfSejUBmwkQT+1jW96pKWaPNHjnGtQ0eYfoCAQ0MqfmJv0glwQVgoLsFRMWa+EoHJ/KGuCYojLK
 kdpiGYaM
 kI/orPUWWw971YDV4d9cWSKdtUZwpEoAiFLTrmSDJrkaKhBlpGydZJm1yWMPOOj1lZiCSXVAqpN8NiRNbFOY3N0htU0AD+fnp20jGPg9CyhQuFDdoboNGxY11/OX1pj7JJKLJHsVSpnimeXVERzSvVvRf6lx1HrfL792kgTKEVFB8/T25O92q4Z+4KrSynN4BtkLuLTspFKsNKSd3Q23XDiQktd3/kmw+CTcnTpUiPjDxXYtawm/3qP4PoKVPBKqtMQ53x5rSVSxpGf8JwQEXuRl4QtLve3aoV4TudtmfpPk2m56JXcwUDYGmD+rp38/UJYdZlG4BAIE73drGnSjPswTw8Cf55nOidAEyngVt32ld2k1iXDYw0D2DSu4vrNq/9MAc//yhmvCR+kMLqZuSWuXwdTS9MAqT16H5DLA0r2VhdLSrHXKX+t6K1kFDmc06CVH82TOzyHvaPT5rlf8RTTC3+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 16:42, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written, but
> a range with no page table at all -- a PMD hole -- is skipped:
> pagemap_scan_pte_hole() tests p->cur_vma_category, which never carries
> PAGE_IS_WRITTEN, so the hole is neither reported nor (under
> PM_SCAN_WP_MATCHING) armed.
> 
> In a uffd-wp VMA, WP_UNPOPULATED installs uffd-wp markers when protecting
> a range, allocating page tables as needed, so an unpopulated slot is
> treated as written -- see the pte_none() handling in
> pagemap_page_category(). A missing marker therefore means the range was
> zapped, e.g. via MADV_DONTNEED. This applies to anon and shmem VMAs.
> 
> An anonymous THP is write-protected in place as a huge PMD, so a
> full-PMD MADV_DONTNEED clears it to pmd_none -- a hole with no page table
> -- and pagemap_scan_pte_hole() misses it. For a MAP_PRIVATE|MAP_ANON
> mapping MADV_DONTNEED has fill-with-zeros semantics, so a write-tracking
> checkpoint/migration tool (e.g. CRIU) treats the range as unchanged and
> keeps its previous contents; after restore or live migration the process
> reads stale data instead of zeroes -- data corruption.
> 
> Report a hole in a non-hugetlb uffd-wp VMA as written, matching the
> pte_none handling in pagemap_page_category(); the existing
> PM_SCAN_WP_MATCHING path then arms it via uffd_wp_range().
> 
> hugetlb is excluded: pagemap_hugetlb_category() reports an empty hugetlb
> entry (huge_pte_none) as not-written, unlike pagemap_page_category(),
> which reports pte_none as written. pagemap_scan_pte_hole() fires for a
> hugetlb slot only when it has no page table; keeping that not-written
> matches how an allocated-but-empty hugetlb entry reads, so the hole and
> the empty-entry cases agree within the VMA.
> 
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260707151349.92143-1-kirill@shutemov.name
> Fixes: 2bad466cc9d9 ("mm/uffd: UFFD_FEATURE_WP_UNPOPULATED")
> Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-fable-5
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

