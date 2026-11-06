Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00DD46082BD0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BtSVML7Y
Received: by kanga.kvack.org (Postfix)
	id 284E46B05B0; Fri,  6 Nov 2026 04:38:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2341D6B05B1; Fri,  6 Nov 2026 04:38:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173E36B05B3; Fri,  6 Nov 2026 04:38:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBA826B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:38:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2FD8160D19
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:38:37 +0000 (UTC)
X-FDA: 85404194274.12.FE3BD0A
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf25.hostedemail.com (Postfix) with ESMTP id EE085A0008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:38:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BtSVML7Y;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793957916;
	b=jbU10GpmO7rIxHIE+oWCV5Yi9x2aUUQB5W70XIOK/3ctqbDWh5LYA8AdRIPNQxCgwy0bDH
	DMk/mj04pyIkIm99qEodyJtuQiOk8+MWwX71voVbaJktVvUc3P2n+eTcSWgqouek3lPWu3
	nQZHtngUyN1dSD5k5431v2zvcYRwqaM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BtSVML7Y;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793957916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Okh68OdrFDN3h8R03ZH0j5Qf8O4M3e/BJYn/3wgqhSg=;
	b=o92yDWrdai2hVyDC0IoiQzfZoMiL8ZFHi4scilKIMz5detuLNlrEPUD07fI9NXylEltpb+
	9rv/6qvKKgheAMMfHFvGpUMI+6CnaZtTGKeAkaWzQpFcvUZ5LItGFS3fzIC6AhB2V0AMgU
	ZmQ3HhVyL8VEpNqNkwKo226oUopgVFA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793957911; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Okh68OdrFDN3h8R03ZH0j5Qf8O4M3e/BJYn/3wgqhSg=;
	b=BtSVML7Yv37aY/uo50y0+FrMM8kzorL0HFphLvrahoZTSEFqYQorSsT+61C+BQMFoVySkZRpyLZsOXQ75KTMf3OLXCRdkKIXwoYfpDAF7Gshh5HTjO+mqYRAl9/xS0HxRyCPmNr08JkjhuchIZ6w06YYyCpiIydA9mAwt2iZ0Tw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEBNJzV_1793957908;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEBNJzV_1793957908 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 17:38:29 +0800
Message-ID: <a6333eb2-d51f-4947-bde6-f61ef52efb69@linux.alibaba.com>
Date: Fri, 6 Nov 2026 17:38:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fpinfcrufuwty79to6wjbnko6sc8pufw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE085A0008
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793957913-756338
X-HE-Meta: U2FsdGVkX18koCwuclhjEbFIVaYS4oroIhD5r+MEuyjlrbhASjsk4xlamHCI7sVhskjw/73Ul+r41T0ntiqVJuNmDqnjZCaKgW6oH8OOWEwFKWaVnG9Kd1AShvMhvD8by2WF/Xf7YDwp1qKw3sBXxmb+M/YOLx4TnxDSQw48iZpula4YoSjtgE0oP1adf6NPngY+so5LXzOqCW/fos8VZkmFtJ7cEug5SIrvGhmXgMcUHIYZBfip9EAKSpyU3D2NN6rXKoxhN8N3u0+lyvROuoH7E5ZVGU0hJlTjuw93JxFIuvi2MfuDDMMjtJPl4bF292IZpuLzDWjrB/M3ZoQHt9HIUvPwTNo254O2VQcrqd77qr6s1oImPK4p1MCy6j91l5oX8LGfPps/OXy0eEQEXHcD1HdHDqjwB6XGGfHZf6S9I9DtfL1szYuqCj5i0d8e2jWjRbSPI05ycEZk+Iz+qB368Ei9tDudYackDKT8oprKifyeW5ejR4pAMaxDP27Md9186rlUKlbHDt02sfT15ips5/ybDAcMSr57fmYQGdD61F2K5T+vUxJlV9sxgzTIiS2yaOKBQlvtK4G9GDvKvd5Oq6sMj5x3O2l+ycGwhWjOtcmr0xSwzOGee5QxYablr3F+6oO3Y3bRVJ0d6YZTNMp92uNDhTMP8TV6oeMdFAsTPxTBIEg7urYEPOLA5B4LAwQqhisVQB5pzTLJ7l+BplvFF+G9QsKVTVJ+kqrCmx/vkQT7ZHVOX/6Br5hkBuqHQtOfp+FfTp73qLBcb0yX/SuZeZCYych7EaIb9/ubxy3rRe5mWNLDEH5EI4Smqr81ttNTYrlKaSImZj3GyL44AHDJkH3+u46WSlXHEP+snF6aj85u7Rb8bWNGMkHiY0ShHyvJhyrr2KYEAXynNX3Aat2k0wBQTb6c/17o3Ioktuz0Gm1UBgZsme46pRqsNN1hDR7bMRfG+E35YHeD+1I
 JmJ9ORPP
 9EjeBLzbWGcDHr7OK1VCsbxJKiYnrUaXraU3NPYGuyoC5PJ1yyhYRhem/i7JaPmDAmW1lAKAhjYupiwklXJtvBz12wdkJscNmrvZVxhK5EdaMcFwptT2VFfcpkEOy3SfdyZjPWWthdYgAB14C57CaZCrShlAAFSfZ1QItqU6uD0vFuUf7f+tV2QuIzrWJ1boFaZnawchcmh22QFVDOoKwBYTjvv4aTUlAjqwKBrIbiIE5UoP2t/oPVCsLeHCdg4UMyjRgeveuaJIo6UUo0igByf+ZLkBnyGkLvn5ycYiZ3vf3mNeL3TqE5xgXP9JYkrPL7BiAvlb+tDjCZoYewuAy1j9kpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 4:57 AM, Lorenzo Stoakes (ARM) wrote:
> khugepaged walks an mm's VMAs under the mmap read lock in
> collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
> them if encountered.
> 
> It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
> when these are encountered, however only checking this budget once an
> eligible PMD-spanning VMA is encountered.
> 
> It can therefore hold the mmap read lock for a long time if there are a
> large number of ineligible VMAs present in an mm, over which time no mmap
> write locks (and thus no VMA write locks) can be acquired.
> 
> Address this by checking whether the mmap lock is contended after every
> KHUGEPAGED_MAX_VMA_SCAN_BATCH VMAs walked, that is a quarter of the
> pages_to_scan budget, and if so dropping and re-acquiring the mmap read
> lock before resuming the walk from the per-mm cursor.
> 
> As the walk is resumed from the cursor rather than the VMA that was current
> when the lock was dropped, the cursor must never move backwards. A VMA
> ending at the top of the address space causes ALIGN() to wrap the cursor to
> zero, so treat such a VMA as the last in the mm rather than skipping past
> it.
> 
> This was tested locally with ~1M ineligible VMAs mapped ahead of a
> collapsible region of memory, and resulted in a reduced mmap_lock hold time
> of 170us down from 95ms.
> 
> This was also observed to reduce mmap_lock stalls in concurrent threads of
> a similar duration. Note that a reader re-acquiring the lock can currently
> steal it from a writer that is queued but not yet running, so the full
> benefit to writers depends on the separate rwsem change at [0].
> 
> Local measurements indicated no change for ordinary use cases, so this is
> all upside.
> 
> This work came out of investigations into mmap stalls when getting latency
> numbers for an unrelated patch series.
> 
> [0]: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

[snip]

>   		if (!collapse_possible_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
> -			/* Unable to collapse, skip to the next candidate. */
> -			mm_slot->address = ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> +			const unsigned long next =
> +				ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> +
>   			cc->progress++;
> +			/* Check for overflow. */
> +			if (unlikely(next < vma->vm_end)) {
> +				vma = NULL;
> +				break;
> +			}
> +			/* Unable to collapse, skip to the next candidate. */
> +			mm_slot->address = next;
>   			continue;
>   		}

IMO, these changes seem to belong in patch 2?

