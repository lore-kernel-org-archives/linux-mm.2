Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25077CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 18:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7EF8E013A; Thu, 18 Sep 2025 14:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57FAE8E00F6; Thu, 18 Sep 2025 14:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46E698E013A; Thu, 18 Sep 2025 14:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 347E88E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:47:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7C748567D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:47:27 +0000 (UTC)
X-FDA: 83903254134.21.18760A7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id AA2421A0011
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:47:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AatbnSqr;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758221245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNQzvgnQbSA8tlqdWTO8IttaK+7+232U4FFvzldgRb8=;
	b=DcD0tcI7bfx+6AWMXBwLyYxcvgHhJ0oqtNCm8gnKvoDvg8O5nlrgkvy2x8r+/Z5TMj1n6r
	tnhCoQmtwcEPUIDVj+rP46msJgA4v+gfqEc7o1aIxT2f1HC+bhqFCk1szAf7aoXVOxE7yp
	aJHMUcAvhyP6gI5S52e4Vk40gDAukT8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758221245; a=rsa-sha256;
	cv=none;
	b=leLLctPMPr8PG1BwAEXW5rjiUjX3ZpEfWH1cPDyhUysn4hLP1QT6/3ZC1va5T/0Qp5q9QY
	F5wt2dkiIt9NQdArx8WiN5l1YbXH0/Vy536lVQ5vTYiZrDIOSgj09sxQNT50vx1xjoijNo
	PKLF9mM/gl2c8Td1sl4yIOzL6WDeLig=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AatbnSqr;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758221243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MNQzvgnQbSA8tlqdWTO8IttaK+7+232U4FFvzldgRb8=;
	b=AatbnSqr5Tq0R3uKT62sMjetgeIjbg2tYVyoMykEf0afZ3sFpyfhedkelakPK2TAmueGcD
	wDCOLU5SxiS3vAnD812mJ77iYU7Z3QaxBGC+D80kijF0ky+Cna864UeMvonKBO7ETuneIE
	jTQyqhu+HfiWbosibdt9EA91TOFp2rU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-zKwf8uwyOUeT8FLwhfTgxg-1; Thu, 18 Sep 2025 14:47:21 -0400
X-MC-Unique: zKwf8uwyOUeT8FLwhfTgxg-1
X-Mimecast-MFC-AGG-ID: zKwf8uwyOUeT8FLwhfTgxg_1758221241
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45f2b0eba08so7893415e9.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:47:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758221240; x=1758826040;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MNQzvgnQbSA8tlqdWTO8IttaK+7+232U4FFvzldgRb8=;
        b=Ze/K8AoYlyYfWcieLi7/33uc83t2QeRx761j6Zu/KtrHVWzcpGJ7bg9+9F17MMphXA
         JkGc9l7KKpaVsbHNCdtznmVwVobkahLm7CVQRIaidOoND4VFCk/h8Kfby35AUO507pdD
         AqfemefmWLntAjZ8DRavr1nSMaGsdR0H1Rjj5Ty/40o/rZklEt0Mm1Bba2sLvYnew0rE
         LY1YoYHIHKpd0mo2HtAwFJ0Rp3kNdjWHXr5xvRpgE+hEBu2wDd8SBR6gARMQgvvB9Sxa
         7OOv8S68lCiBAia2s+XuyxVHYGClLAMZp2jnxhDjzK/hYSAYCTRvSrxzbVtbfh9qAECR
         LG2w==
X-Forwarded-Encrypted: i=1; AJvYcCU4LG0E9MaHrZPTSbMg8g8ukEtD8Ed09lT8UIrQ10UdDZQ/hyoJAa1hTYdPKCa1ea3szdzxtH9PXQ==@kvack.org
X-Gm-Message-State: AOJu0Yzot1ZqE37cxvedVWZZ9zBs9gzoSEqZmeEHwuyXwzLFFU5cF8zG
	e6+EMEl8PUst1OV5ftJvmn7W/Bqcv4FDlqovvAYStnYDXm49QigyS0VZHdfLD9RQd4gIIAPrkTk
	SRrCoVKTGGa4B6EYikeN7OeaRVlA0RkR9HffZK5rVvYa2e0su0TRN
X-Gm-Gg: ASbGncuHv6/JtacWe2zCHkkFgxFCw3pteM5rGcN8pDhm7TaS9+q0fSOvagWRE2SHNOD
	Fhqs8+/rywIenJldi5F7WiAPzUum02QsfcOlFcICHYNLbhBZr+rD7x51JCodWcexgnK/K6IYUM/
	8kiJD+/Adi9WFHCDU34S6tRvziUJzP6qok2noPT6F3qzxXGPGdwYrEcHY42hjaLBEL+EymNxATj
	5spRYA3xeV/OybymyqgWOrmSPZHmHLjq288KCVGULFFW4XdaF6cA8/ihxGPTPvLtXtcC9DyuuXE
	tcplnznnaX113Z/VGnu8qkKfZ1qoW2bQ0E15e082z9XaEbIgReeNRLPEGhdOJMa4csBFZojIFlA
	N77rJzsRpG3A80W9I/IJqBwvkgsttRPRhr0nSiSuaqUJmebSgUXSdc+1dkC1RDIqaIoys
X-Received: by 2002:a05:600c:4593:b0:459:d5d1:d602 with SMTP id 5b1f17b1804b1-467e75ea97dmr2719615e9.3.1758221240520;
        Thu, 18 Sep 2025 11:47:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDcj8kHpB0IfY8PipfESjfPatuuZxWzXNEjI5VDUDbjx2iFOuHzJgVkJRxVolHueJd5G4T5w==
X-Received: by 2002:a05:600c:4593:b0:459:d5d1:d602 with SMTP id 5b1f17b1804b1-467e75ea97dmr2719405e9.3.1758221240087;
        Thu, 18 Sep 2025 11:47:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee073f4750sm4548197f8f.11.2025.09.18.11.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 11:47:19 -0700 (PDT)
Message-ID: <a696c734-9f88-4d6f-a852-013071a2dd2a@redhat.com>
Date: Thu, 18 Sep 2025 20:47:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, kirill@shutemov.name,
 hughd@google.com, mpenttil@redhat.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250918050431.36855-3-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mEKchGSPIOc7adJC3CaIEvz2di48MSPlw3OV5mYRL9Q_1758221241
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA2421A0011
X-Stat-Signature: 4urrakrezmqmpe4e5xj3ksm3cj36pgst
X-Rspam-User: 
X-HE-Tag: 1758221243-897329
X-HE-Meta: U2FsdGVkX1/mRCKxeUfWaD6OsWn3HPO7s2OEHIMFuH6RI9uT3XAlcHA9qg+h5hacuGcYftF1jR0jnlY+xUJ9j4r0kMkuUjmCIA69ITHfI4uExfzkSbLwChfN7IAqgcvIOWE10RV2SUvywTXPTk+JyALNnDqjnzbdYjbGlyTs3cbvyZBqaExbCLlvg8fhEhmV1i2Lf3utwMN4r5wies6nLIGwlY1B+MFHe5D2+sHLJA9hV3llZUjoxKAs8YcDe3V8bL/AL+PSnDs1yvO3P2Pb0/gW2QLxY3BANLZ6AYhRpTNc0ebj82qtwQmlN1SRcnf+0ex238QtvtBQt9cnLJ0+0fPhyd5eQxJLNdXaKfSiycHpod8UuInuMDekakA4FZ/qGGFekXpgCGDGDK/EQ+FXAy+0/LWa9gS+MtXWK1KPg1qtcE1xPJ97F+JcdEHP+87onwwzaSzBUbYU0gntrcREh1u1A9uSZHOHcX0QwWyvYyGXcDl8OC2zlsVB8WV6zKKUB9yjPyC2LGZqypS6cAjAr1iIKUojQULJfFa0GK7Ugjdp4ENn51+AswBy64YfB0pIw2jIuOhk2TTiMK/hEcoxkQg0vtA9+I+aKqG+i6CoQDfkn3Wn8B6aidMdu7yMxzzE0f/66bvZcZNeE1LVKkOUeIcTO4Qb9XVNq23ZardtIZbWyYK13Y2agyNSUot3Evm3lZQGxwSZ4HEDWWW+2kUmMe4bbcy65HKf7Vu1et2B3sAR6aFPjgW7MeY2mPCYDl3SsjJLulJokYnJSM9yB1W9MoSQ3+peKwpRsIy0mgYZ90pe5rGjDcR9BYgUwHqqwYvqJTKgxxuI9FdvX+VfGkGB6FClrt8Apa7XJQg7+EdQaOfaX8nQGHfqTyP6VdhWpnDbSSJpvFRiAVYiBabsJHg/2vajSWlgSB82PQCghNOSp6YHco1+pTVNdLmTUiPUbo/zuOuMd3vE4rO3Uj3GJDi
 H68LO54Y
 qTDKLfo8WaYxy5+C7hln5crFyM4sd4k5Z5Npq/XoQ408h0f7AvbSOjBsIa6d3nBC5umj5bKHLJdqAt+vBk/tLGdxCGWo5+ttJcXxzhDhHuXJgsS3qpIoUKYnK3qopOQG83CLgK2Mv3AsQeqR7w+8D9ukTyD9I4ry951/dfbOp2DTsGbSo0bnsWVKUj8MDnaOvmsF//rOnAsSKr2EPohRvnM1jn7f94xb/dU6aLiiAcq3t2+R/3kAqjN4baXpquJjmBI2PjmhJzUrRNzX8Ay+Q92SqrqQ/B7RCmRyJ33boV3pIkinRoPu8mW/kesEZDtMib29MIkkYLosQwLpI6MmZ17BjdnyKruv1rMdU3Dj+47ItaCQGk+0a1NE7+RKxDswVtPU+R4m9YQOOqHXNT+991eIN6s8vWwsY3FTSUQTd6nKvduMiyzMSJSzy/VBH5m8oN4yb1PdygdcsoSb73HIt8+P96RuErBCGgJkkUChRKzkz8fs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 07:04, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
> lightweight guard regions.
> 
> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
> encountering such a range.
> 
> MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
> the special marker in __collapse_huge_page_swapin().
> 
> hpage_collapse_scan_pmd()
>   `- collapse_huge_page()
>       `- __collapse_huge_page_swapin() -> fails!
> 
> khugepaged's behavior is slightly different due to its max_ptes_swap limit
> (default 64). It won't fail as deep, but it will still needlessly scan up
> to 64 swap entries before bailing out.
> 
> IMHO, we can and should detect this much earlier.
> 
> This patch adds a check directly inside the PTE scan loop. If a guard
> marker is found, the scan is aborted immediately with SCAN_PTE_NON_PRESENT,
> avoiding wasted work.
> 
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   mm/khugepaged.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9ed1af2b5c38..70ebfc7c1f3e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   					result = SCAN_PTE_UFFD_WP;
>   					goto out_unmap;
>   				}
> +				/*
> +				 * Guard PTE markers are installed by
> +				 * MADV_GUARD_INSTALL. Any collapse path must
> +				 * not touch them, so abort the scan immediately
> +				 * if one is found.
> +				 */
> +				if (is_guard_pte_marker(pteval)) {
> +					result = SCAN_PTE_NON_PRESENT;
> +					goto out_unmap;
> +				}

Thinking about it, this is interesting.

Essentially we track any non-swap swap entries towards khugepaged_max_ptes_swap, which is rather weird.

I think we might also run into migration entries here and hwpoison entries?

So what about just generalizing this:

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index af5f5c80fe4ed..28f1f4bf0e0a8 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1293,7 +1293,24 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
         for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
              _pte++, _address += PAGE_SIZE) {
                 pte_t pteval = ptep_get(_pte);
-               if (is_swap_pte(pteval)) {
+
+               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+                       ++none_or_zero;
+                       if (!userfaultfd_armed(vma) &&
+                           (!cc->is_khugepaged ||
+                            none_or_zero <= khugepaged_max_ptes_none)) {
+                               continue;
+                       } else {
+                               result = SCAN_EXCEED_NONE_PTE;
+                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+                               goto out_unmap;
+                       }
+               } else if (!pte_present(pteval)) {
+                       if (non_swap_entry(pte_to_swp_entry(pteval))) {
+                               result = SCAN_PTE_NON_PRESENT;
+                               goto out_unmap;
+                       }
+
                         ++unmapped;
                         if (!cc->is_khugepaged ||
                             unmapped <= khugepaged_max_ptes_swap) {
@@ -1313,18 +1330,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
                                 goto out_unmap;
                         }
                 }
-               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-                       ++none_or_zero;
-                       if (!userfaultfd_armed(vma) &&
-                           (!cc->is_khugepaged ||
-                            none_or_zero <= khugepaged_max_ptes_none)) {
-                               continue;
-                       } else {
-                               result = SCAN_EXCEED_NONE_PTE;
-                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-                               goto out_unmap;
-                       }
-               }
+
                 if (pte_uffd_wp(pteval)) {
                         /*
                          * Don't collapse the page if any of the small


With that, the function flow looks more similar to __collapse_huge_page_isolate(),
except that we handle swap entries in there now.


And with that in place, couldn't we factor out a huge chunk of both scanning
functions into some helper (passing whether swap entries are allowed or not?).

Yes, I know, refactoring khugepaged, crazy idea.

-- 
Cheers

David / dhildenb


