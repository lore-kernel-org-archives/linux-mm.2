Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E254CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F6D8E0006; Thu,  6 Nov 2025 16:05:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5169F8E0002; Thu,  6 Nov 2025 16:05:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453A78E0006; Thu,  6 Nov 2025 16:05:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33BFA8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:05:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D61F9B7848
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:05:49 +0000 (UTC)
X-FDA: 84081414018.14.2B74BA2
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id E784F4000D
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:05:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GVD3p/Jv";
	spf=pass (imf04.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762463148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q413bhrhJwOAVLfpt+EjMm9+VisP6PJcOIixFAEVSFA=;
	b=W3zfHll/ZMUPoWz2CCrkG2ki4YZRHAMBQNUl6ZreU9CKy9q3yAa2lswl6fo4siyelD/6r/
	QQIPAf024ZxAfeSm2rLDNMUwOeV2AW8v8VbHjm9OfUgCoNrlDDKqQeJr37oi7Oqlm2kSAr
	xx9FhXT1eqh/n9OACBZqox+d44r5dyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762463148; a=rsa-sha256;
	cv=none;
	b=IMLq2XYBp9eakayx4qHKr+LcSYwCLALwkSVCrN3jngRduZ0vXPhBCy+jGsmVRQoEqVsFr7
	3l7XouwVxtaHcCab0G1dF9JYsC5saP+jvWiFUldPGPEPOxm4R6Z6KJZZleUzJIBspwrmjo
	v0ivVGkHkdToe/TaP/sn9lW9aI/6KT8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GVD3p/Jv";
	spf=pass (imf04.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ee15b5435bso43800f8f.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 13:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762463146; x=1763067946; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q413bhrhJwOAVLfpt+EjMm9+VisP6PJcOIixFAEVSFA=;
        b=GVD3p/Jvd1nY1MM6MmabaI6muJNNsQI77wYiK4+esIKHtNrbZID3DrSFkMsSSuvXHW
         qDqcGY8hNmZOpvO1eHO8lApXEZ4D6KGg+L1aRZg+KiuVqkrlPERxvdARxWSRwIRVMyOZ
         QWR5WaOU8wU3pxmSVoqII8zf+wDvdiNilr33EovpaY0SHHlweGhPtJqzSV4/gAw2IvEy
         nrdq8oRxD8qnU8VVhbON+cW4Ubw2IgFKhQ2XCmGykZ8yH5a9XvFLnxKmdtFtXE/0Zopi
         B0ZRHvyVdThhL7n94tDUI7b47ujfVlvpMhDR/dcjE4IT9n6WMj9VxDwi3Ex9OFiX2NPu
         yRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762463146; x=1763067946;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q413bhrhJwOAVLfpt+EjMm9+VisP6PJcOIixFAEVSFA=;
        b=D31G+L+9a9CiIfR7pae5ZSDVmBteitXoGtU/AKdbOzDkgCjopdObYKxuz0T6Y3SshE
         ChR5vhdGFIJkJ4NGNTiC0SVH4MpuK5/0TEk8uhmazUSI/Xh+3VlbqmYaC1R04xaCHYCm
         EvnOg7m7AkswTYR5buDCAHunr0Bif2yp3Qtk7DczzQE4KtzaB0WpP711oRKbjazEVfi5
         3Ay3gGYGU+krM3MwjkwuYlhingNXgWg/XyLD9Qb+5JOQHM25m2sI2o0ZyhM1etmILWhn
         W+N6e8jpgvjpuMmoH2K4uJ8xOMoJJF21wOxeQN0L5l2Xvn+chMgulysbuIn9ZEPf3iRV
         us+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzKo7fJTqno4/5LJAhJK7XZXjuukL7EtJVChgEP7UTcgAlCmYrxjiMzNJ9RR5WpIzUdPmqvi1iMQ==@kvack.org
X-Gm-Message-State: AOJu0YzXH7L6gvRsn9EoZlhS2x0Y7g2pTgW6oK7bO17h6MH9xUhvpJX0
	pnLpiF7B398OiDewtiv0FzylUKppYLBj0pFQNLejAc7sJFNgeR3vrpF8
X-Gm-Gg: ASbGncvnsCHXvd41uKlxMeBElqVdav1t8Ah2X3PvrYQO/EjS5VyImOpNem4HSOaQ/PZ
	D5xIGy0jXZykUmT2pAmksenbfgA/lnoe9MAEAC8IUm3YSus9NgGCHO7lzg1LiqAJRnpdaL7Dmx0
	EZzLIbYaLjeWBamOeBhf5OyKjztSJ4uN6TNRFV6rHOrkJqk/3PWfT+9sJvzY2GPWc3SxuwT0Jvq
	QEUaNketT10io4u4QaAn/TPC1l/yWjumQPCwq/qgGqhxHkR+dZx5m2Sz7orl7IADklxrqpceaMX
	yim93y1rAq4RXwtxHL8H2RkMmTBiT26EHfvNYt5gaMLmJNHrxUNSU1Rj+MUFPqTGw6mc6OyfgtJ
	rvZoItgLOxyTiamZyhggmjdbS5Prs4+X/Y7HaRggQkrPcRt6RDrnG2zZ8TeuJTofeaQeW5Fg8oQ
	fOULYii3zE6Ix8kEz9IiWWhJ5mVJuU3LQsETuiukw=
X-Google-Smtp-Source: AGHT+IEbAWZGXC2i989InvZLZeR310/TSzIZgHH8Ye/jSaLz4FLCazBpkgnlp2Vx7xAT+bFkyoZqJw==
X-Received: by 2002:a05:6000:430d:b0:429:ca7f:8d73 with SMTP id ffacd0b85a97d-42adce35cbamr566921f8f.26.1762463145942;
        Thu, 06 Nov 2025 13:05:45 -0800 (PST)
Received: from [192.168.3.141] (p4ff1feb5.dip0.t-ipconnect.de. [79.241.254.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42abe62b1e3sm1217619f8f.4.2025.11.06.13.05.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 13:05:45 -0800 (PST)
Message-ID: <77a54f63-f5da-42a2-b24d-5c8a0f41d1e6@gmail.com>
Date: Thu, 6 Nov 2025 22:05:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, zokeefe@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
 <8bc796e2-f652-4c12-a347-7b778ae7f899@arm.com>
 <ozkb6mcxuymlz7tm4vcnqf266gd4ruiik2zal2koo5ffprgxfk@35godtyix2cf>
 <43a8c8a6-388b-4c73-9a62-ee57dfb9ba5a@lucifer.local>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <43a8c8a6-388b-4c73-9a62-ee57dfb9ba5a@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E784F4000D
X-Stat-Signature: geqasc5t6rx4iz6sheixzo6tg4tetbso
X-Rspam-User: 
X-HE-Tag: 1762463147-504519
X-HE-Meta: U2FsdGVkX18lVh0UUgGUCbx63KzSKtneKjtlHX9q6iiD3gfOA1pQoKLkMrZXrVCy09+ZNl8nVwG4IuHApkeB+Ccxh9oVIHQZq7LIgfSxjlKlJV4pMsVeNXUj68mQyvd9JP8fk0pTSVQaN6FGwKnZwhxaWJhvkC+WRmmcYwAEW4J1bBJ32ukbjeBEs+slFHrdU8TwEL2uxNcvxFKqdY0pSIdq0ittIEXEP+yDFW4lUYH2cfRXB31/azJkwiTfdQRMBcy1rZohNYWcf7Wg1fWhLFFgswCw+lc9DJvqe0VyloIjEvKEGR/RMt5/7U8UoXLaVSYWM5LT6Du16qXlid0qCNRNjwhRxFsdkI0kXXVMkaiBk6elELlqwabhG0/SG/FAHm6cc1nohyXtZVASD2xR93ZRvLetwv3l8jFbtO0Y+U04UhL4RU86vyNzT/5hwjpodf49BdTaiKRR10jtyY7QK3Wo2rm1cNAAMNA6WQ0Dixk56fMuALl6lVoUq6EAU+5CCfEv4hOZv/nrOl0rYOAK2kRdkmySRFGvrlEcpzVtAZ/IdxpsAf1cvjGQPbaAbScUEKu8Z+4HVowYfH3NJEAqhfTtCrF+E9LrNvNcV9IhuxqWxDS1Qe51fSLTB+v0sJsMy/JpiiWDdhqvnPSYu1iFt6CQ+1BycSwq66qHZWFjfppMTCibB1RYiIZ3KfJsaI6cDswXoFXsPBhfOPNxBkXEIT9uymKUTelVHf+473GV64orrZU4B2QbWHjlcJSN0jLSLAWmICxj4lxG5/amykRFwKK22hVlN5v8Aah1N98/mUCIxf9nKLBNALfoVZYn94XgzTOOZWjyRjRbvrLvyh9biY2hYjFGUkQiihbUyYUxRlu6mSCqd7wmPfFjYxcmDo4nd3xLjgOWJtW03mPobc9GK3nVcClWAvarewqHaU15y6rcKUQRHF86y4+IF2OgtgdnQbjkzLG9oIznGUMAuH9
 xRhRoty5
 TDXjqXiROMXuRXxf+6xJuqKbcrOFoJ6h0Dn9QYODXDpYHFp2mTa9c3LsTmOx80BnIRLV6EI8zYuJEgh65L9IT1uyC2WsS+ZpxzZxzhiVePOD3ixw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 18:17, Lorenzo Stoakes wrote:
> On Thu, Nov 06, 2025 at 11:55:05AM -0500, Liam R. Howlett wrote:
>> * Ryan Roberts <ryan.roberts@arm.com> [251106 11:33]:
>>> On 06/11/2025 12:16, Garg, Shivank wrote:
>>>> Hi All,
>>>>
>>>> I've been investigating an issue with madvise(MADV_COLLAPSE) for TEXT pages
>>>> when CONFIG_READ_ONLY_THP_FOR_FS=y is enabled, and would like to discuss the
>>>> current behavior and improvements.
>>>>
>>>> Problem:
>>>> When attempting to collapse read-only file-backed TEXT sections into THPs
>>>> using madvise(MADV_COLLAPSE), the operation fails with EINVAL if the pages
>>>> are marked dirty.
>>>> madvise(aligned_start, aligned_size, MADV_COLLAPSE) -> returns -1 and errno = -22
>>>>
>>>> Subsequent calls to madvise(MADV_COLLAPSE) succeed because the first madvise
>>>> attempt triggers filemap_flush() which initiates async writeback of the dirty folios.
>>>>
>>>> Root Cause:
>>>> The failure occurs in mm/khugepaged.c:collapse_file():
>>>> } else if (folio_test_dirty(folio)) {
>>>>      /*
>>>>       * khugepaged only works on read-only fd,
>>>>       * so this page is dirty because it hasn't
>>>>       * been flushed since first write. There
>>>>       * won't be new dirty pages.
>>>>       *
>>>>       * Trigger async flush here and hope the
>>>>       * writeback is done when khugepaged
>>>>       * revisits this page.
>>>>       */
>>>>      xas_unlock_irq(&xas);
>>>>      filemap_flush(mapping);
>>>>      result = SCAN_FAIL;
>>>>      goto xa_unlocked;
>>>> }
>>>>
>>>> Why the text pages are dirty?
>>>
>>> This is the real question to to answer, I think...
>>
>> Agree with Ryan here, let's stop things from being marked dirty if they
>> are not.
> 
> Hmm I wonder if we have some broken assumptions in khugepaged for MAP_PRIVATE
> mappings.
> 
> collapse_single_pmd()
> -> collapse_scan_file() if not vma_is_anonymous() (it won't be)
> -> collapse_file()
> -> the snippet above.
> 
> But that could be running on an anon folio...
> 
> Yup given it's CONFIG_READY_ONLY_THP_FOR_FS that is strange. We are confounding
> expectations here surely?
> 
> Presumably it's because these are MAP_PRIVATE mappings, so this is an anon folio
> but then collapse_file() goes into the snippet above and gets very confused.
> 
> Do we need to add a folio_test_anon() here?
> 
> Unless I'm missing something... (very possible, am only glancing over the code
> here)

collapse_file() operates exclusively on the pagecache.

I think we only start working on the actual page tables when calling
retract_page_tables().

In there, we have this code, when iterating over page tables belonging
to the mapping:

		/*
		 * The lock of new_folio is still held, we will be blocked in
		 * the page fault path, which prevents the pte entries from
		 * being set again. So even though the old empty PTE page may be
		 * concurrently freed and a new PTE page is filled into the pmd
		 * entry, it is still empty and can be removed.
		 *
		 * So here we only need to recheck if the state of pmd entry
		 * still meets our requirements, rather than checking pmd_same()
		 * like elsewhere.
		 */
		if (check_pmd_state(pmd) != SCAN_SUCCEED)
			goto drop_pml;
		ptl = pte_lockptr(mm, pmd);
		if (ptl != pml)
			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);

		/*
		 * Huge page lock is still held, so normally the page table
		 * must remain empty; and we have already skipped anon_vma
		 * and userfaultfd_wp() vmas.  But since the mmap_lock is not
		 * held, it is still possible for a racing userfaultfd_ioctl()
		 * to have inserted ptes or markers.  Now that we hold ptlock,
		 * repeating the anon_vma check protects from one category,
		 * and repeating the userfaultfd_wp() check from another.
		 */
		if (likely(!vma->anon_vma && !userfaultfd_wp(vma))) {
			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
			pmdp_get_lockless_sync();
			success = true;
		}

Given !vma->anon_vma, we cannot have anon folios in there.

Given !userfaultfd_wp(vma), we cannot have uffd-wp markers in there.

Given that all folios in the range we are collapsing where unmapped, we cannot have
them mapped there.

So the conclusion is that the page table must be empty and can be removed.


Could guard markers be in there?

