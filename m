Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B32BCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7726B00C5; Tue, 26 May 2026 10:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE746B00CB; Tue, 26 May 2026 10:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C41B6B00CC; Tue, 26 May 2026 10:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59E506B00C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:38:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E76916124E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:38:20 +0000 (UTC)
X-FDA: 84809826360.13.A2DD13E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8695CC0004
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:38:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yv56yAdz;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779806297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPQhCilg9SmO+pAp9s9UTV9o3JLL/USiBgpYdpXlb7w=;
	b=dzNsEgzfxoBhIjQLOHz5jOIRhh4qxm1YZL2X2ywoVPmZjwUhg8FWLGu7JkH8JhlhpMvkWV
	pMxGpNjQ8K5Vo7AHEgK7/YwkpPRYRNTCjcELpRR6Tzp7PjJ03XKbRITGWgqPSXVHzg4lFo
	ZOuQetP1uQoHRWypE3ljVpFe97s3iHU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yv56yAdz;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779806297; a=rsa-sha256;
	cv=none;
	b=xqz3XHH7Q3XUSemRjE+MbdH1SfCi6ToGsgG0/Cv5wicaiwbTSRSVK9FXc7bf3tkcAcDKAz
	aiU5WCS7wMq7nRf3bHKAwVAEWzIbsYevqV2zp2ImYFE4hcmE4V5uw6NLt3WUhlqN+fwsPY
	P6r16Tn4E4bxA36SHv9QA9prxnvGzOs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779806296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CPQhCilg9SmO+pAp9s9UTV9o3JLL/USiBgpYdpXlb7w=;
	b=Yv56yAdzpjrWYV5Xl775+CIRHObQsix57xFZT/GULl8ki1Bm+M0ZCNPes2ChrG774hOHX0
	vB3vb+bsKDTCJrWuhfD5IK6UVe183DMXL9iKxrWXyAHREBrVWVCHvbsBO1MzxVnrf4sC6V
	0xObFByFClRFgo4fLDPZ9H7HD9BS7DA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-MtIpynDDMxiPRy1TRu_N5w-1; Tue, 26 May 2026 10:38:14 -0400
X-MC-Unique: MtIpynDDMxiPRy1TRu_N5w-1
X-Mimecast-MFC-AGG-ID: MtIpynDDMxiPRy1TRu_N5w_1779806293
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44d79da8cf7so8030070f8f.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 07:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779806293; x=1780411093;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CPQhCilg9SmO+pAp9s9UTV9o3JLL/USiBgpYdpXlb7w=;
        b=CJzZpSDZvnDT9lmX6yaV7Bddy9OeXuAv20rUH1fgyH1NcHAcTuK0bLJElDM4AObxcF
         GtEpLa1wLh2wNwFuPEsfTuyta6vyKeFI4VKcO0nvDngyDwsFoA8lASXz+q6e4Cnivlou
         dWATTZnMvOmxHbxSuT7/TGRnBu632DG9Tix5vcVhGrY/SttsJlgnG1Z5hHy93rN3rtfR
         QW4gE8hjApSSR6bWIjHlQ24C9wFWA/HQH/absG//9ws+Qxr6mHsv3MVk8T2Aeb0HjNqr
         JUgtIP3tyFJWyvHd3wSlmMQtcB3biooAz4G+yjGi0HWNHfYrC8hhsZlSnLWhohxQOk2u
         3ojQ==
X-Forwarded-Encrypted: i=1; AFNElJ+JtUJ6Ax3j2hdK03j77v6OIr95v8d/CQDxpsPQA5XZ3thvYRBNf4ghYoDCzDus/DiFCOq2VQARgg==@kvack.org
X-Gm-Message-State: AOJu0Yy3LvVWThb162ACIqPq5vjFm0Aj2EtU8d/AflbYaCo5s3FnyIw6
	O06e2MmedY4CLTtkEQ3hX5dyfltAI587GK7TjUPYxubld/qXjLoFi58sOl2RHphQH94aZiqRHf6
	KXqZi+v47ZwEEOG/f65lB9Xs71nar+aCevlGjrLQnACG5v/QQT71t
X-Gm-Gg: Acq92OHUq+qORF93DWbv0pJY9C/IhDAdKmxcmDUva9liqhkL4I/9zLk8/7sjtak2I/w
	UUuW5c5ZekkA+OLhLgYc0Ebaq0pEIagoqO6UoLGIdfn/DGpI/PVFznDG2WEF9Zef11goaEV59rq
	r4eW4LeV2Hdfu3E1ZqNXa9/ESg+9QeNTrVd+1jlas0EPtGgk5YniVjhC8CyDn9DC1nuOwSfDecB
	M1hP5OnhSGClA/qRUASf98hasSlVyNhP7iE31axsFcOxzvLIAKC3VeyFBsrsKYY4PIBxFmzLJbv
	Qxu57Gg+PlTP/Ju4w8jb2ukuzOAAyqDPjGYJJ7edFYp7/6/KldEsKm5V6AkW2G6qwLBA4JrsI9L
	OkyLGIQs0DaebI/wJXXWe2Zk=
X-Received: by 2002:a05:6000:29d3:b0:45c:1c89:b1c6 with SMTP id ffacd0b85a97d-45eb38bb149mr23274049f8f.33.1779806292851;
        Tue, 26 May 2026 07:38:12 -0700 (PDT)
X-Received: by 2002:a05:6000:29d3:b0:45c:1c89:b1c6 with SMTP id ffacd0b85a97d-45eb38bb149mr23273969f8f.33.1779806292197;
        Tue, 26 May 2026 07:38:12 -0700 (PDT)
Received: from [192.168.1.144] ([88.147.84.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ed8873a35sm5348322f8f.14.2026.05.26.07.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 07:38:11 -0700 (PDT)
Message-ID: <b5fa19c5-4b3e-40b8-8e78-fc31169a7a79@redhat.com>
Date: Tue, 26 May 2026 08:39:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 04/14] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 akpm@linux-foundation.org
Cc: aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-5-npache@redhat.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260522150009.121603-5-npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: US4cdyoLsHT9tnDUgQWMYWE9p0-vo-hMo_6BkFMTFaw_1779806293
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k5c65dhp3xhiz4agincwzcm1mwny6xt5
X-Rspamd-Queue-Id: 8695CC0004
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779806297-602796
X-HE-Meta: U2FsdGVkX1+A1U7mvDbi5oLzLKvY7oscdnGX7LaH+7lA3kv5iqk72Fi0qVsNRx/5cO1GOnOwAtz98AdHpLy1B9TvKcSzlnQGXTzdQEsDi06f7inSm7LgVIcdmloy8h95lDIuEOn6FU48gpLFbOr55U7Vs0fv3fxAmoG9auOg6HIMyT6kh/JZGl9i5TlsyaGmGI5cnCcY8GbUihi2VmOuG8c9xnsmEIF7yUsloNtuRi7h1u7i1sL8C4OSQE4iSyrPrhIh8hge+XOpmwtG80nzGQ9oAVFJcD5uBywPdaDd1oazO7DJYpA5kW3LYMBPx4OElvGP9Md0Gm2c6Rj+nLiwlEtZohvsEGwb42Tqr1CSh3izjVfwAryy1kCPJGvDpjWGa7WR2HKHkZbBM7GCeFEdPPne4FWMWeHuyj6c1BJAwRNVpQ4FRyQX7NqpyDfKeNNpxcjChoCD+TeLk+MWRLzQSG3Gf+XE5IrCAWZqv/SPT9ymSP2h3dMX0gYnlTyP37Sl8s7o5WAcom6oUy/7SDsr1koKP67Cf705WZS3BcmnKUahftPdkfxl4JJYsviCQqxnJ4w6IAAMR/cgrRB0xrqDQq2nahFEMz85II5Q46GW68hKr4Q7qMVY/YJBPx67qdzQlpzXqTEQWyDtKCeJAQ+wmH1e8Eviji98p1SpFuvHjHvhfIfi58acVTsec7LxmZlmuGtJCG6r8jdgBVFfJVNFWicnRzwFZ9YGrTznK/gXmHCYmqh61qL7Mtabq/DsZhjXOoSfK9iSnCPz2Qrg034kMNoDn2qIa/08MzJRTCOmXRKr87AR43wpGsgQGV9RRtW4/8kqh5Y6EJuO6vX/nZsIgbJdJReoi/DgbrOtsgFRqoON7mOuFvGhX0UlsaPdyhZbBvCD96WN5cIwqt1CBrL5PwzTke2kAWZ1u25ihb05V/2qLLsg+STHZ8Pdyew4XCAIAoTkFTixhWjBp6bBnST
 JMYV7r3F
 I+dT2MtXZNlzh3lhKo8QBqdpKD0mWyqXZYSh1TRkh9SgMx10NBxsbyx+n6HvqKs/q9qBzMy44+JN9f2AwGwkc/Xd69zCFxYr2p4pwW6KeP/XndcqhTj0JS0xNauD8QWHGGkV7N92VqtpjlOmXJo4x9jDyNzuUiKNpIbrr/L/ZyuD81JIJyl2diOlBfpqSkgEeIrRlUe+mYLbPjoT4IBjiU/YRs9diiDOnsLaV8cr4UvTtHf6IVUiJkLJLwLZfv9t2P/FJE4H7roKkXojMFmnh5map/5YHksqmmplIDz4heyT5/N+q0QjkzpD0FLiOlXudrsam6Jn+qqDsTlgjjTwc5hLF4CpfNZK5MQAqdlB7zc3H7cfMbDQdAVVT5ng4OpWiGoSLfNxKv3pdYo340VGZO26gCGjHOM+ZlFEJEgukijiCFUnuaSVcom1CUNLORxG/PxwlI+H3SoLjsgZU7WobHjs5A/Z8pDTkB6xaxVkbkgLURghr1Hdo0WUsl8uS/ZyvtV4UYYctjKbNnyb5WjbGTMFy5BEyX/jjzzaTE5ZYa7xuBe/MUc+kdkv6wgshC8W2PcCVC0MnUN/LTQP9LBcjjzVXSk2FbN3Bbq9bNI8SbvcCDWj250wKjUERUfs3xtaQxMKU1x23pLCg7FtGgua5T/KgWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/22/26 8:59 AM, Nico Pache wrote:
> generalize the order of the __collapse_huge_page_* and collapse_max_*
> functions to support future mTHP collapse.
> 
> The current mechanism for determining collapse with the
> khugepaged_max_ptes_none value is not designed with mTHP in mind. This
> raises a key design issue: if we support user defined max_pte_none values
> (even those scaled by order), a collapse of a lower order can introduces
> an feedback loop, or "creep", when max_ptes_none is set to a value greater
> than HPAGE_PMD_NR / 2. [1]
> 
> With this configuration, a successful collapse to order N will populate
> enough pages to satisfy the collapse condition on order N+1 on the next
> scan. This leads to unnecessary work and memory churn.
> 
> To fix this issue introduce a helper function that will limit mTHP
> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> This effectively supports two modes: [2]
> 
> - max_ptes_none=0: never collapses if it encounters an empty PTE or a PTE
>   that maps the shared zeropage. Consequently, no memory bloat.
> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>   available mTHP order.
> 
> This removes the possibility of "creep", and a warning will be emitted if
> any non-supported max_ptes_none value is configured with mTHP enabled.
> Any intermediate value will default mTHP collapse to max_ptes_none=0.
> 
> mTHP collapse will not honor the khugepaged_max_ptes_shared or
> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
> shared or swapped entry.
> 
> No functional changes in this patch; however it defines future behavior
> for mTHP collapse.

Hi Andrew,

Can you please append the following fixup to this commit.

Changes are described below but are very minor nits!

Thank you!

commit e3985903daa4fa77a27a632c1c2fa4c23aac9ad5
Author: Nico Pache <npache@redhat.com>
Date:   Tue May 26 05:40:03 2026 -0600

    fixup: cleanup collapse_max_ptes_none
    
    make max_ptes_none a const and cleanup the pr_warn_once
    
    Acked-by: David Hildenbrand (arm) <david@kernel.org>
    Signed-off-by: Nico Pache <npache@redhat.com>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e98ba5b15163..4c7e404b0f8d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -360,7 +360,7 @@ static bool pte_none_or_zero(pte_t pte)
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
-	unsigned int max_ptes_none = khugepaged_max_ptes_none;
+	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
 
 	if (vma && userfaultfd_armed(vma))
 		return 0;
@@ -376,14 +376,13 @@ static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 	 */
 	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
-	if (!max_ptes_none)
-		return 0;
 	/*
 	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
 	 * emit a warning and return 0.
 	 */
-	pr_warn_once("mTHP collapse does not support max_ptes_none values"
-		     " other than 0 or %u, defaulting to 0.\n",
+	if (max_ptes_none)
+		pr_warn_once("mTHP collapse does not support max_ptes_none"
+		     " values other than 0 or %u, defaulting to 0.\n",
 		     KHUGEPAGED_MAX_PTES_LIMIT);
 	return 0;
 }


> 
> [1] - https://lore.kernel.org/all/e46ab3ab-a3d7-4fb7-9970-d0704bd5d05a@arm.com
> [2] - https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@redhat.com
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 121 +++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 88 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 116f39518948..e98ba5b15163 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -353,30 +353,52 @@ static bool pte_none_or_zero(pte_t pte)
>   * the shared zeropage for the given collapse operation.
>   * @cc: The collapse control struct
>   * @vma: The vma to check for userfaultfd
> + * @order: The folio order being collapsed to
>   *
>   * Return: Maximum number of empty/shared zeropage PTEs for the collapse operation
>   */
>  static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
> -		struct vm_area_struct *vma)
> +		struct vm_area_struct *vma, unsigned int order)
>  {
> +	unsigned int max_ptes_none = khugepaged_max_ptes_none;
> +
>  	if (vma && userfaultfd_armed(vma))
>  		return 0;
>  	/* for MADV_COLLAPSE, allow any empty/shared zeropage PTEs */
>  	if (!cc->is_khugepaged)
>  		return HPAGE_PMD_NR;
> -	/* For all other cases respect the user defined maximum */
> -	return khugepaged_max_ptes_none;
> +	/* for PMD collapse, respect the user defined maximum */
> +	if (is_pmd_order(order))
> +		return max_ptes_none;
> +	/*
> +	 * for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
> +	 * scale the maximum number of PTEs to the order of the collapse.
> +	 */
> +	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
> +		return (1 << order) - 1;
> +	if (!max_ptes_none)
> +		return 0;
> +	/*
> +	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
> +	 * emit a warning and return 0.
> +	 */
> +	pr_warn_once("mTHP collapse does not support max_ptes_none values"
> +		     " other than 0 or %u, defaulting to 0.\n",
> +		     KHUGEPAGED_MAX_PTES_LIMIT);
> +	return 0;
>  }
>  
>  /**
>   * collapse_max_ptes_shared - Calculate maximum allowed PTEs that map shared
>   * anonymous pages for the given collapse operation.
>   * @cc: The collapse control struct
> + * @order: The folio order being collapsed to
>   *
>   * Return: Maximum number of PTEs that map shared anonymous pages for the
>   * collapse operation
>   */
> -static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
> +static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
> +		unsigned int order)
>  {
>  	/*
>  	 * For MADV_COLLAPSE, do not restrict the number of PTEs that map shared
> @@ -384,6 +406,13 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
>  	 */
>  	if (!cc->is_khugepaged)
>  		return HPAGE_PMD_NR;
> +	/*
> +	 * for mTHP collapse do not allow collapsing anonymous memory pages that
> +	 * are shared between processes.
> +	 */
> +	if (!is_pmd_order(order))
> +		return 0;
> +	/* for PMD collapse, respect the user defined maximum */
>  	return khugepaged_max_ptes_shared;
>  }
>  
> @@ -391,11 +420,13 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
>   * collapse_max_ptes_swap - Calculate the maximum allowed non-present PTEs or the
>   * maximum allowed non-present pagecache entries for the given collapse operation.
>   * @cc: The collapse control struct
> + * @order: The folio order being collapsed to
>   *
>   * Return: Maximum number of non-present PTEs or the maximum allowed non-present
>   * pagecache entries for the collapse operation.
>   */
> -static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
> +static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
> +		unsigned int order)
>  {
>  	/*
>  	 * For MADV_COLLAPSE, do not restrict the number PTEs entries or
> @@ -403,6 +434,10 @@ static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
>  	 */
>  	if (!cc->is_khugepaged)
>  		return HPAGE_PMD_NR;
> +	/* for mTHP collapse do not allow any non-present PTEs or pagecache entries */
> +	if (!is_pmd_order(order))
> +		return 0;
> +	/* for PMD collapse, respect the user defined maximum */
>  	return khugepaged_max_ptes_swap;
>  }
>  
> @@ -596,10 +631,11 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
> -		struct list_head *compound_pagelist)
> +		unsigned int order, struct list_head *compound_pagelist)
>  {
> -	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
> -	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
> +	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
> +	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
> +	const unsigned long nr_pages = 1UL << order;
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr = start_addr;
> @@ -607,7 +643,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	int none_or_zero = 0, shared = 0, referenced = 0;
>  	enum scan_result result = SCAN_FAIL;
>  
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> +	for (_pte = pte; _pte < pte + nr_pages;
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
>  		if (pte_none_or_zero(pteval)) {
> @@ -740,18 +776,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  }
>  
>  static void __collapse_huge_page_copy_succeeded(pte_t *pte,
> -						struct vm_area_struct *vma,
> -						unsigned long address,
> -						spinlock_t *ptl,
> -						struct list_head *compound_pagelist)
> +		struct vm_area_struct *vma, unsigned long address,
> +		spinlock_t *ptl, unsigned int order,
> +		struct list_head *compound_pagelist)
>  {
> -	unsigned long end = address + HPAGE_PMD_SIZE;
> +	const unsigned long nr_pages = 1UL << order;
> +	unsigned long end = address + (PAGE_SIZE << order);
>  	struct folio *src, *tmp;
>  	pte_t pteval;
>  	pte_t *_pte;
>  	unsigned int nr_ptes;
>  
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
> +	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
>  	     address += nr_ptes * PAGE_SIZE) {
>  		nr_ptes = 1;
>  		pteval = ptep_get(_pte);
> @@ -804,11 +840,10 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>  }
>  
>  static void __collapse_huge_page_copy_failed(pte_t *pte,
> -					     pmd_t *pmd,
> -					     pmd_t orig_pmd,
> -					     struct vm_area_struct *vma,
> -					     struct list_head *compound_pagelist)
> +		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> +		unsigned int order, struct list_head *compound_pagelist)
>  {
> +	const unsigned long nr_pages = 1UL << order;
>  	spinlock_t *pmd_ptl;
>  
>  	/*
> @@ -824,7 +859,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>  	 * Release both raw and compound pages isolated
>  	 * in __collapse_huge_page_isolate.
>  	 */
> -	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
> +	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
>  }
>  
>  /*
> @@ -844,16 +879,17 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>   */
>  static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>  		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> -		unsigned long address, spinlock_t *ptl,
> +		unsigned long address, spinlock_t *ptl, unsigned int order,
>  		struct list_head *compound_pagelist)
>  {
> +	const unsigned long nr_pages = 1UL << order;
>  	unsigned int i;
>  	enum scan_result result = SCAN_SUCCEED;
>  
>  	/*
>  	 * Copying pages' contents is subject to memory poison at any iteration.
>  	 */
> -	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +	for (i = 0; i < nr_pages; i++) {
>  		pte_t pteval = ptep_get(pte + i);
>  		struct page *page = folio_page(folio, i);
>  		unsigned long src_addr = address + i * PAGE_SIZE;
> @@ -872,10 +908,10 @@ static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *foli
>  
>  	if (likely(result == SCAN_SUCCEED))
>  		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
> -						    compound_pagelist);
> +						    order, compound_pagelist);
>  	else
>  		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
> -						 compound_pagelist);
> +						 order, compound_pagelist);
>  
>  	return result;
>  }
> @@ -1042,16 +1078,20 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
>   * Bring missing pages in from swap, to complete THP collapse.
>   * Only done if khugepaged_scan_pmd believes it is worthwhile.
>   *
> + * For mTHP orders the function bails on the first swap entry, because
> + * faulting pages back in during collapse could re-populate PTEs that
> + * push a later scan over the threshold for a higher-order collapse.
> + *
>   * Called and returns without pte mapped or spinlocks held.
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
>   */
>  static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
> -		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
> -		int referenced)
> +		struct vm_area_struct *vma, unsigned long start_addr,
> +		pmd_t *pmd, int referenced, unsigned int order)
>  {
>  	int swapped_in = 0;
>  	vm_fault_t ret = 0;
> -	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
> +	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
>  	enum scan_result result;
>  	pte_t *pte = NULL;
>  	spinlock_t *ptl;
> @@ -1083,6 +1123,19 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>  		    pte_present(vmf.orig_pte))
>  			continue;
>  
> +		/*
> +		 * TODO: Support swapin without leading to further mTHP
> +		 * collapses. Currently bringing in new pages via swapin may
> +		 * cause a future higher order collapse on a rescan of the same
> +		 * range.
> +		 */
> +		if (!is_pmd_order(order)) {
> +			pte_unmap(pte);
> +			mmap_read_unlock(mm);
> +			result = SCAN_EXCEED_SWAP_PTE;
> +			goto out;
> +		}
> +
>  		vmf.pte = pte;
>  		vmf.ptl = ptl;
>  		ret = do_swap_page(&vmf);
> @@ -1203,7 +1256,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
>  		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced);
> +						     referenced, HPAGE_PMD_ORDER);
>  		if (result != SCAN_SUCCEED)
>  			goto out_nolock;
>  	}
> @@ -1251,6 +1304,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
>  	if (pte) {
>  		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> +						      HPAGE_PMD_ORDER,
>  						      &compound_pagelist);
>  		spin_unlock(pte_ptl);
>  	} else {
> @@ -1281,6 +1335,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  
>  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
>  					   vma, address, pte_ptl,
> +					   HPAGE_PMD_ORDER,
>  					   &compound_pagelist);
>  	pte_unmap(pte);
>  	if (unlikely(result != SCAN_SUCCEED))
> @@ -1316,9 +1371,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		struct vm_area_struct *vma, unsigned long start_addr,
>  		bool *lock_dropped, struct collapse_control *cc)
>  {
> -	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
> -	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
> -	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
> +	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
> +	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
> +	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
>  	int none_or_zero = 0, shared = 0, referenced = 0;
> @@ -2372,8 +2427,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  		unsigned long addr, struct file *file, pgoff_t start,
>  		struct collapse_control *cc)
>  {
> -	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL);
> -	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
> +	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
> +	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
>  	struct folio *folio = NULL;
>  	struct address_space *mapping = file->f_mapping;
>  	XA_STATE(xas, &mapping->i_pages, start);


