Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3506D1BDDE
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 21:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7AB76B000E; Wed,  3 Dec 2025 16:02:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51A16B0024; Wed,  3 Dec 2025 16:02:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67DC6B0028; Wed,  3 Dec 2025 16:02:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C38316B000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:02:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E897AC0761
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 21:02:26 +0000 (UTC)
X-FDA: 84179383092.21.6263FEA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2694DC001E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 21:02:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KEtlbCLW;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764795744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wh68DuFmuCTpixNQpqPfNYRlyM5f+TpOLFbygDNv8C0=;
	b=IzrC6RI8YcU2DlyCdCBGXotlaj8OmXOs/vjx9UpDMUfBMyPc+ZSkX6ON/CELw49l+3VT3N
	bxtcNPla+sIq4pF5lWHZ8H6G1RBF5s34V/7cOG8jOTR4ElfitbR7f6Mwz1tbtnrGwUp0KV
	ddypiMSK1vjdYAVC1YyeQnknvQ90Tqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764795744; a=rsa-sha256;
	cv=none;
	b=3FwNRk6OfnK5ConzPVdfTtszw+569eeCo9PtgmXEtQMeBr1/XTkFc8XokOHTUwSKypW61G
	i2vRIY0Ui0CcHeqTSje+gGnvQ2pkByjnAKE6z432pV0bz4qCwMxZlXpZEBeMeRULcKAqoZ
	e1EBqL9y1pQ8bsCxNvRnYCpC/U7x5nY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KEtlbCLW;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764795743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wh68DuFmuCTpixNQpqPfNYRlyM5f+TpOLFbygDNv8C0=;
	b=KEtlbCLWOhw+HzhyxCW63azQ4Z/VuOoyqWumm2iWnmptYElmiFVT7mCFt/WwJs2HowFfuc
	AWJIAljDd29HoupDxF6WEKlOkRzQEB0u4FpLDD6wdiwk5Wp2I2Vt8zzgmmGVe508XCHdVV
	xwCZ88mzL2KS9M2V51Y/wj/GjjWr/ZA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-Vam40dSgPXW66TIUFvKoSw-1; Wed, 03 Dec 2025 16:02:22 -0500
X-MC-Unique: Vam40dSgPXW66TIUFvKoSw-1
X-Mimecast-MFC-AGG-ID: Vam40dSgPXW66TIUFvKoSw_1764795740
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ee04f4c632so3410601cf.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 13:02:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764795740; x=1765400540;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wh68DuFmuCTpixNQpqPfNYRlyM5f+TpOLFbygDNv8C0=;
        b=KhbmsPtsFSUqnsZ6Z/pCtV8IiBa5AJczexTX8sknmcbV/1+ESqWuuhn4dMN5iky24S
         lxlpBJWE1ZqkDjHbd4Z2x196Bfava/+swApuQaqwH1OdCauz09QwfQPFYzSJgrm2S73M
         EeE88slkE8/Q9xFPcuFa5qDZy5vEPn1QljydGtzqiXITd2k4pYtvg102Dp7HKaLQ5lil
         lJ3q4iaC0eMq8w60aMTR0YaVs9alfXd15qU6KSjct9qS6EJI+wdy1pODl8z9EpjwFPis
         tgdb+RECWeH40Fc2RZ9PjvmfGOu7akCi12F4GgelarNfREVKOb3dqg2WUvCITLtHsy3b
         4gsg==
X-Forwarded-Encrypted: i=1; AJvYcCVFpSSlF8zrjz46DEGlXgQxWnfpa9Wm7v3fJNXhnVjT3OymFOnlSyYiuTv/1+27sp/YwNvTDIaWMA==@kvack.org
X-Gm-Message-State: AOJu0YwP9ihyqeO3G557Hx5Xn2QwIjaVRJwVTnOhk4E+bESVHysJdwIr
	XRpneMt1pBfCSLcfa/tNF7OPuencO/5/u65vnc7K1NXYi41WdVDLiEck1ewRxiH5Hr2qrWa2nl6
	XAVujt1HCiHGD6vqVl23ZB25zUqd54vnHlUCnEoGhWIiV0+oiCXd/
X-Gm-Gg: ASbGncuWfKVC4KvwgSAkD8xnvTFPVv3MeLmFN2ftQnsyEOn/cnrScBGpPeBpUWKY9Gg
	vTc75Koo6ABhvu4UsHY+r4qxrlgcAqitJYNDIYfQRpVsR6N3LsOHO1zCUZdiRanH5UZeNR+HOIw
	vW97n6vWSn19MAa+zP0EVodO5JbVK8sIdjRGECWtBMTTgg61AiMG68NdUDZ9/vHRaO9clgh4pg0
	DQRoeWl0G1IHQ792D+eCMkasRU996yeaiLAG9EnZCLvoK4NCwxEmcgGEX6WqAAMhDvSEXox/zHz
	8yRpTm9UBOJc9ZB+iMPFoiaApdO4xwAWV9negGk8oQ5dRFY5bxIBzGo7OF15udX090+Lufi2IOT
	JGlJnXAOicCcYxmcYMA==
X-Received: by 2002:ac8:5916:0:b0:4ee:49b8:fb7f with SMTP id d75a77b69052e-4f01767ea57mr52095211cf.58.1764795740374;
        Wed, 03 Dec 2025 13:02:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHTpqaTiqS+C1vNo/L4t/xM/bulVqn8SjD+/i4c5bpbIFGDFtHnpdO6/T7V6iwwIIk5Hbfq+Q==
X-Received: by 2002:ac8:5916:0:b0:4ee:49b8:fb7f with SMTP id d75a77b69052e-4f01767ea57mr52093951cf.58.1764795739759;
        Wed, 03 Dec 2025 13:02:19 -0800 (PST)
Received: from ?IPV6:2601:282:1c83:9aa0::72b3? ([2601:282:1c83:9aa0::72b3])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b4aed6sm139789696d6.37.2025.12.03.13.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 13:02:18 -0800 (PST)
Message-ID: <b9f49744-932e-45ed-abd3-a9dcf6458b17@redhat.com>
Date: Wed, 3 Dec 2025 14:02:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 mm-new 07/16] khugepaged: introduce
 collapse_max_ptes_none helper function
From: Nico Pache <npache@redhat.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-8-npache@redhat.com>
In-Reply-To: <20251201174627.23295-8-npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: utWPdt8exxvv9mchk_InGTy1bRiOLxh40nHIhLyKMKo_1764795740
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-ZM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2694DC001E
X-Stat-Signature: rcginhqx7iooak687jdq7mtmpthrg13w
X-HE-Tag: 1764795743-15271
X-HE-Meta: U2FsdGVkX1+FIPXKptTZ2KPbd/mh5Ipb93Pr6Q8WD8lQsAYxhDsHJQCV2n0wc4oS997tF0Eui40jy6SBAWAa025SfAXi4KSA1CjNSpvncXpZEj8yuZpYt+WRrVcywjCu4tupAx1h+zSDwJirm/kyKbkWuyKn73ec1j/BS8mcqLFgV5Cz4M7SLnvxN0AMcVI3bhEant+LC38BA+wayuOxNaIAKCcdaQJWyGqLbXDMbRs/KumLyJcc/qXlodUtOn9KDbyeGPMwfMB3VXCOTDUKWElE7NP84ZSJV1MHEXtk6EdfYCsahMj5aKn4tXrIFp2CO/okf8uk1Bzkp80m7xhI4fQMbkfRfOz0jHGYifRxXI+prXwBMfNriR/cLkflARJOeSebtPsOngX57EyWMiXefGqGMcnamJIxnYIFmozety2PIJezMWz8xMOdGninjU6bsIMZO/lqbMCaoVyRyR9YVo9ghY3aXyb5QVakrUEtP9MFZ4vxTSmNU+bsbSWWQsuk61T3lAs3cSMMCyFdzX1mpcu8N16xuS7UADSHpTxoBBih1m0j3uRE02OB7+yMIfhNGD1WJ0597OqDNQrGYD/PRz90SoLL5rLIsNBZkQjDh+SWITUmXxHO/rrivU+Kno0gHdwwqbn9F3VmphNhLiKjuGNqIK9/jKMMPMj1XCJUKCXfITSe0uCxpMNRaZvG4nxhbs5etsV+7t3WyTF+QnQUuqumGRvOvh+5LRKbtNDdOPg5eTgTRTfk9pq736xhBRfGPvZ2hgMqdvfc8PHRSrEVnSzmnn83F2U8wAZtFOoJG8X59YEL9LAlh00CoPGMPv8MRBdgPoFfTxqM2pkTH4zw2y8NdtstgqL/0Cd/qSeol34dAsduUVYp6ndV1uLMp/sGHvIr1DNLvBfJB7srvOo8N/RZLFRecbWcWvXMV7pxNRWknvck3sosa+2M91zIUhmh4ol5xszGBWOM7GUZm7n
 /MqY0Spb
 VGWMDhVctSoB1JKedymoLDXa4Xd6UGlU85oz9xK4N19QLF90kC1I4qgMcboeEbV8d0iDYzPieCuGMA5oh+T5QN5U5o4JtBDIfBVdypo092PS+Vpp6Ikb5BISxjzE+noaoKN+w2WHLZ1CnLYDboeg/Udr9tYmRtG+z1p1jOyad6FQ7opo3xk/Jl+x5BfsAFbYAqs97MJU1USxmoaevctX0STfbiig2zTvWBJzB89IxA7FRB96v31ST1LaUt8SHcHuA0pA9t2lr2PXHcC9v0CiauX3hdZjDal96WH4ndtrjMvDgGYXp9bIZhzqRjfHK6Oci/xG8DuMkzd1z9rvyOwyGhdPL8A1UAN+aG1XYhL7h1HoCfEQLVwkWRoUzoHRkghqUDbUEGMc/ftnCp0t04rnXmFe6awQyCCmsXzdSkRa9p6Ny6BLP5unRgOskJjW4vA3HILsxfLh0s690V/GapElCi1gpZ5hoDkKxRu4Cydu3benHul6o5vhMhwHyLnSBSnOk/l1x+8REjWABJXep6JvuQswAcVGujsFfiUTopLr0piZPsiWqqv3KXOWqwbn6xTn+c5y+0OhOn9/q14eQKbNpJvijDq0/9IZxvKcbBVbB51Z2Sv5lbfpZzMt3HAJU6J9KwidNfRNSXP4mFqn6AMuk/VYmI8IDqKHS7m0g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

The bot has reported a potential uninitialized use of a variable.

Can you please squash the following fixup to this commit.

Thank you,
Nico

----8<----

From 846f79d91a25ebad76cbab3690ae315cfe3cf278 Mon Sep 17 00:00:00 2001
From: Nico Pache <npache@redhat.com>
Date: Wed, 3 Dec 2025 13:42:18 -0700
Subject: [PATCH] khugepaged: fixup unintialized _pte variable

There is a potential use of an uninitialized variable after
`khugepaged: introduce collapse_max_ptes_none helper function`

Andrew can you please append this to Patch 7 of my series

as reported by the kernel test robot
>> mm/khugepaged.c:593:6: warning: variable '_pte' is used uninitialized
whenever 'if' condition is true [-Wsometimes-uninitialized]
593 | if (max_ptes_none == -EINVAL)
| ^~~~~~~~~~~~~~~~~~~~~~~~
mm/khugepaged.c:724:25: note: uninitialized use occurs here
724 | release_pte_pages(pte, _pte, compound_pagelist);
| ^~~~
mm/khugepaged.c:593:2: note: remove the 'if' if its condition is always false
593 | if (max_ptes_none == -EINVAL)
| ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
594 | goto out;
| ~~~~~~~~
mm/khugepaged.c:588:13: note: initialize the variable '_pte' to silence this warning
588 | pte_t *_pte;
| ^
| = NULL
1 warning generated.

Signed-off-by: Nico Pache <npache@redhat.com>
---
mm/khugepaged.c | 5 ++---
1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f425238d5d4f..7c7d04d6737e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -585,7 +585,7 @@ static int __collapse_huge_page_isolate(struct
vm_area_struct *vma,
struct page *page = NULL;
struct folio *folio = NULL;
unsigned long addr = start_addr;
- pte_t *_pte;
+ pte_t *_pte = pte;
int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
const unsigned long nr_pages = 1UL << order;
int max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);
@@ -593,8 +593,7 @@ static int __collapse_huge_page_isolate(struct
vm_area_struct *vma,
if (max_ptes_none == -EINVAL)
goto out;
- for (_pte = pte; _pte < pte + nr_pages;
- _pte++, addr += PAGE_SIZE) {
+ for (; _pte < pte + nr_pages; _pte++, addr += PAGE_SIZE) {
pte_t pteval = ptep_get(_pte);
if (pte_none_or_zero(pteval)) {
++none_or_zero;

--
2.52.0

On 12/1/25 10:46 AM, Nico Pache wrote:
> The current mechanism for determining mTHP collapse scales the
> khugepaged_max_ptes_none value based on the target order. This
> introduces an undesirable feedback loop, or "creep", when max_ptes_none
> is set to a value greater than HPAGE_PMD_NR / 2.
> 
> With this configuration, a successful collapse to order N will populate
> enough pages to satisfy the collapse condition on order N+1 on the next
> scan. This leads to unnecessary work and memory churn.
> 
> To fix this issue introduce a helper function that will limit mTHP
> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> This effectively supports two modes:
> 
> - max_ptes_none=0: never introduce new none-pages for mTHP collapse.
> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>   available mTHP order.
> 
> This removes the possiblilty of "creep", while not modifying any uAPI
> expectations. A warning will be emitted if any non-supported
> max_ptes_none value is configured with mTHP enabled.
> 
> The limits can be ignored by passing full_scan=true, this is useful for
> madvise_collapse (which ignores limits), or in the case of
> collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> collapse is available.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8dab49c53128..f425238d5d4f 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -463,6 +463,44 @@ void __khugepaged_enter(struct mm_struct *mm)
>  		wake_up_interruptible(&khugepaged_wait);
>  }
>  
> +/**
> + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
> + * @order: The folio order being collapsed to
> + * @full_scan: Whether this is a full scan (ignore limits)
> + *
> + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
> + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> + *
> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
> + * khugepaged_max_ptes_none value.
> + *
> + * For mTHP collapses, we currently only support khugepaged_max_pte_none values
> + * of 0 or (HPAGE_PMD_NR - 1). Any other value will emit a warning and no mTHP
> + * collapse will be attempted
> + *
> + * Return: Maximum number of empty PTEs allowed for the collapse operation
> + */
> +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
> +{
> +	/* ignore max_ptes_none limits */
> +	if (full_scan)
> +		return HPAGE_PMD_NR - 1;
> +
> +	if (!is_mthp_order(order))
> +		return khugepaged_max_ptes_none;
> +
> +	/* Zero/non-present collapse disabled. */
> +	if (!khugepaged_max_ptes_none)
> +		return 0;
> +
> +	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> +		return (1 << order) - 1;
> +
> +	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %d\n",
> +		      HPAGE_PMD_NR - 1);
> +	return -EINVAL;
> +}
> +
>  void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
> @@ -550,7 +588,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	pte_t *_pte;
>  	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>  	const unsigned long nr_pages = 1UL << order;
> -	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
> +	int max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);
> +
> +	if (max_ptes_none == -EINVAL)
> +		goto out;
>  
>  	for (_pte = pte; _pte < pte + nr_pages;
>  	     _pte++, addr += PAGE_SIZE) {


