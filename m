Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 063FCCAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 10:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247138E0028; Mon, 29 Sep 2025 06:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21EE58E0002; Mon, 29 Sep 2025 06:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7428E0028; Mon, 29 Sep 2025 06:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EFA018E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:29:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2EC21199A9
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:29:42 +0000 (UTC)
X-FDA: 83941916604.14.B1BC18B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3903D4000F
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:29:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wid7aqin;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759141780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXWt4HHulcMFjL1Aq+0YxiHfHwYLE0hFtn8pXo5MFNg=;
	b=IYJZfoOv9/iLyOBuFJfcZKNF/l0U88z0AqLthQS19fU4hdlkSkMWf0H8aKfTKFNXemcuRN
	zvKiyIRINGfA3fiI2FjSHgacJ2coIGT7zcjXei2wu8TO0tB9eAj+JGMVqZZs2pmuG2m7e+
	yxGbD0pmyPkM5IleIvpojNEp0QTCNSQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759141780; a=rsa-sha256;
	cv=none;
	b=BCr9OONdZ+uDc7H6qDj+jufhsAg7hg19mFGDYL9n3g41b9j+sgD1sDXFPATt3is+UdZPGT
	RHM/jL1ekhUPVvtxDdYb4XVEaXSQrwYBh6BgJGE5XqzNTD2Syha6Iow+bzDbeJxB9fGyfW
	AL94XfWKLuFjeErxNrkmGmM0j7aduNE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wid7aqin;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759141779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WXWt4HHulcMFjL1Aq+0YxiHfHwYLE0hFtn8pXo5MFNg=;
	b=Wid7aqinmg2iLXj3HURYCA7PZkqnly0f09e0aUuZ4Krwl7ma3Jq6yORHxKSyMJxPSKrtrU
	IKS/larvDdwcJvzR7M2XzB0lr8ovpj9rsTm6LB4amGaPF3AVPrdEIrHnWb65QmzbmVXia9
	uhGfyCRPrOLDwbpGmYMTn9/9xR7CpWI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-JAAolGJJPialFAqUeswjHw-1; Mon, 29 Sep 2025 06:29:37 -0400
X-MC-Unique: JAAolGJJPialFAqUeswjHw-1
X-Mimecast-MFC-AGG-ID: JAAolGJJPialFAqUeswjHw_1759141776
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ef21d77d2eso2382895f8f.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:29:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759141776; x=1759746576;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXWt4HHulcMFjL1Aq+0YxiHfHwYLE0hFtn8pXo5MFNg=;
        b=P0BYEMbOvFCF0ObmDJ8QejXWlw7Xr9PmK9Vo28YsoZ/mWmGp08vPv9tgiIR9YBRiQf
         T2NV+HZg6m1sqgSQx9qvA8UZTF7Z4uoVk+eHShWmlgWGg04mF7fSCk/h5dfCPKjC59AL
         rnEIEPzFLmBplLvJOdqY7Q6B/HX/htywl8XtEEwSnxVDlZOsEk6jd/QksyiZOxiCrujk
         +gyn3Yf3e53L65Sl2eANwHb2UcM8WqdzCuL8shtF7QhhIfXh4jBh42ljGChwmWqQDJk6
         cWX2tDRD6knzc0HqDHaVZxz7OKP9aYwo7Bk9nKddqtZd5/cy3q+vl0Xfs7HAYJXnuiGr
         h/iA==
X-Forwarded-Encrypted: i=1; AJvYcCX8UXneKb+gdzAOKwN5fWKSTM9Q7jxFjMKeqEPyytZb7rTKmrCHveEUDIcJDWPsWFlSaLfliZlfuQ==@kvack.org
X-Gm-Message-State: AOJu0YyKBF68q6mGWyT5lQft9WFdm2vnRSk6ntesWtzeXgcCa48fKH7B
	PWRgJAgiZQuMHL8oE5uQ8SjJZ8+Ur2X+iDhfQMwzokvgcU7rKMyvptLZIevXU6YxyZzlql74YK/
	akqKtAR37sPqnYvp4jo1b0FaD8ocONDhT8O9JG5Z7ydgPIYXVxQpim1ohyUFY05M=
X-Gm-Gg: ASbGncuiBYVvPNKe5dkuGb5EfWlcCev4YSyIITXNx31vdRHd8GnUOr3SNvOcUlv0bmX
	EtpeuXbeAVUKHpRb07k0D4unO/y33HWQr7xnMMLHQXyBJDGZvVnoAPj8w/qFGc1ldvQd+Mtw9AW
	8HopJk1zIafHCILPrra1PHECoEJb5WLauzaJOlF8t0v9NWmB0t0qoovLkjO2W0BzDhOyRJk44wH
	iXTtF9j8JSFWPPwy6yOAEQ/Tln+i4ZKM7V62h+wBExjlTrOWfJDq4yK66GDnrekBMHwpk52Rk1m
	61YaxLflgZlov+LUyHudF5nTImMqpFjEqOrYLH6XfixuwlWVtyxeSbmi7Ak3TRxMoC45Yf6skUn
	wSWeQt1wakpQ+doJWz+3mPHA1JUxBLo5W6J9bl1F/sUe16r2IeXSVvicEG6rrSSWMRg==
X-Received: by 2002:a05:6000:2907:b0:3eb:bbd9:9c08 with SMTP id ffacd0b85a97d-40e499acbc1mr14205635f8f.46.1759141776224;
        Mon, 29 Sep 2025 03:29:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpBPmaV6bO3po2pQHWtcJCjnCiYBuNOTjULPKnCP+e6Ia2o8aSMMd4yg5DwnQ5GTdH7hrSzg==
X-Received: by 2002:a05:6000:2907:b0:3eb:bbd9:9c08 with SMTP id ffacd0b85a97d-40e499acbc1mr14205609f8f.46.1759141775809;
        Mon, 29 Sep 2025 03:29:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb017sm17722543f8f.3.2025.09.29.03.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 03:29:35 -0700 (PDT)
Message-ID: <d7012c9c-f4a9-4d49-a921-2cc175f3411d@redhat.com>
Date: Mon, 29 Sep 2025 12:29:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: abort collapse scan on non-swap
 entries
To: Lance Yang <lance.yang@linux.dev>
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com,
 akpm@linux-foundation.org
References: <20250924100207.28332-1-lance.yang@linux.dev>
 <1282de5a-3dce-443d-91d1-111103140973@redhat.com>
 <69621b58-5142-48ea-9dd8-6baed69e50f8@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <69621b58-5142-48ea-9dd8-6baed69e50f8@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nSJoutkJNZxqUeTlIbpJgpSeNMyBMdmLPnRMNoXO134_1759141776
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3903D4000F
X-Stat-Signature: nh7fsbxetggnzneyo9hiy61ggpf8afhd
X-Rspam-User: 
X-HE-Tag: 1759141780-748535
X-HE-Meta: U2FsdGVkX1/neTXkTSShU/vh5fL0fb15OufxT9BQmSuttUWMZVW/Fa0IqbzG/73Qc+CAs4p3OU8MvX4X6mzeS1rDL2/2U+8CCip0t+j0y8MGi4zbZNoUGcz4AUQy/XAdJ2LuYSgws550TDfdQF974CzthZM40pyFQCZxFv+fnY5ZCOdxQmilojg3apZRj7kHO2b6nDjJGG+thE/ehHvqpNfKLtWUd2w7U+0T/2pKAj4ZNfgFzMQWO2v8jcj59tGZ3gwFbiT48RyycKIzAwpXZDl07dNWdBXyMb2ElYH7krvzm4NIzdkLKnKrjri0ThDoO9Wm+e4IFfzluJqeuqDah1Pps8ZcSSVA5y8PJWRdPqsK0rxzDawLT2m6K6UfNaS2RT05hXnvFwOYKBmwHPPc5vaKH6njbm4ZNP0TsQu/EsUSz8IACZ1pcfLL65hxnAxRDPTAtSQQ34HELf/5dNef9r2dYslNrlPdB3bXHvq0E7tr72skuT7TPWk/VtS4uA87nBXAJ0nAPMBJ432M2LlAkWD1lKW18Sb2CEdtjUZCY3kvnq/CxZ5WDNzMJKTL+cc0BBtdT6kjuSDJEJuQiutLHlQoGJKhjz6Qqtn52op5F9hzCIcvRJXqBHupco25iGAEeVGpaiwfpVWyiy8Rhn7R8oRZEMHszj+IhihyRPfhFOxMyd7Nv5LMG81mgQsLXy9Gj1MZgPxXZ+gBjsyMdIFx/WHiHi1IBLi6g1sWiPxdilJj2bJD0x1h6SjkZDzKFLNPpn/oJqVakL8B6Cxy/fu9Dh3RcpaR3gMY8ga5o0YGVCZfVgJk75oAs7+kgJfVxHbEa/sMYArB/hc6Mx9tUclj/qmm00onH9fh0JbrGN925m485CeJvFrcjUgQBzHjhAo31R8Jk1csRvjRhP8THi93Uo46BvuXDJqB8we8dRYwZJalNqPc8eaH3hhKQk/0JWuPx2RGYPtjdieCIUeBjdA
 qW3exB2H
 jxtwmFL39J9U7MNWWz23W6XYdpVkZrtnny4B0J0qrTmbDavKRLjJtY4BepsmrKggPw+rcDe+Nz8YfPy0PkmHYvT6/wwX1LoWeKFQmR15LKCIfrzfi/0cYysFxsG/GdA9hXIosj4aTcLcFVSt4s+G5Z5f8l/bEAipjNcU0rQS2wI2QCE8gJoEKt++fjDN8mBq52JfyKqR8o9nL/tBjmrN1PYJVvTfhLvG2CutpkZPZaf6ucF/5pKuQUioAMEmW5HFnRYai1vLOMNnycbvuey84wWWbstNLF5YNwMzmie2c/32Xzid5dMOB3gkPnC6oNP6F97x9woBiH1bl+UVrK4iazb70H2J8zdiW2tmrJCvV7J9k/5HVIoJSODBAZRxZ9gNqCa9QCok0f8RF7yRg/uSxp4itC8qLP/Y+L9v3g7lD6Mk6OjKSYMhAQbggB47ls9TpHfa/vpzwPotF/479E6DEHSbMCKGDtBNtTCthfrMoG8IIv3s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 13:47, Lance Yang wrote:
> 
> 
> On 2025/9/24 18:10, David Hildenbrand wrote:
>> On 24.09.25 12:02, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> The existing check in hpage_collapse_scan_pmd() is specific to uffd-wp
>>> markers. Other special markers (e.g., GUARD, POISONED) would not be
>>> caught
>>> early, leading to failures deeper in the swap-in logic.
>>>
>>> hpage_collapse_scan_pmd()
>>>    `- collapse_huge_page()
>>>        `- __collapse_huge_page_swapin() -> fails!
>>>
>>> As David suggested[1], this patch skips any such non-swap entries early.
>>> If a special marker is found, the scan is aborted immediately with the
>>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>>> work.
>>
>> Note that I suggested to skip all non-present entries except swap
>> entries, which includes migration entries, hwpoisoned entries etc.
> 
> Oops, I completely misunderstood your suggestion :(
> 
> It should be to handle all special non-present entries (migration,
> hwpoison, markers), not just a specific type of marker ...
> 
> How about this version, which handles all non-swap entries as you
> suggested?
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7ab2d1a42df3..27f432e7f07c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct
> mm_struct *mm,
>           for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>                _pte++, addr += PAGE_SIZE) {
>                   pte_t pteval = ptep_get(_pte);
> -               if (is_swap_pte(pteval)) {
> +               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +                       ++none_or_zero;
> +                       if (!userfaultfd_armed(vma) &&
> +                           (!cc->is_khugepaged ||
> +                            none_or_zero <= khugepaged_max_ptes_none)) {
> +                               continue;
> +                       } else {
> +                               result = SCAN_EXCEED_NONE_PTE;
> +                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +                               goto out_unmap;
> +                       }
> +               } else if (!pte_present(pteval)) {
> +                       if (non_swap_entry(pte_to_swp_entry(pteval))) {
> +                               result = SCAN_PTE_NON_PRESENT;
> +                               goto out_unmap;
> +                       }
> +
>                           ++unmapped;
>                           if (!cc->is_khugepaged ||
>                               unmapped <= khugepaged_max_ptes_swap) {
> @@ -1293,7 +1309,7 @@ static int hpage_collapse_scan_pmd(struct
> mm_struct *mm,
>                                    * enabled swap entries.  Please see
>                                    * comment below for pte_uffd_wp().
>                                    */
> -                               if (pte_swp_uffd_wp_any(pteval)) {
> +                               if (pte_swp_uffd_wp(pteval)) {
>                                           result = SCAN_PTE_UFFD_WP;
>                                           goto out_unmap;
>                                   }
> @@ -1304,18 +1320,6 @@ static int hpage_collapse_scan_pmd(struct
> mm_struct *mm,
>                                   goto out_unmap;
>                           }
>                   }
> -               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> -                       ++none_or_zero;
> -                       if (!userfaultfd_armed(vma) &&
> -                           (!cc->is_khugepaged ||
> -                            none_or_zero <= khugepaged_max_ptes_none)) {
> -                               continue;
> -                       } else {
> -                               result = SCAN_EXCEED_NONE_PTE;
> -                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -                               goto out_unmap;
> -                       }
> -               }
>                   if (pte_uffd_wp(pteval)) {

 From a quick glimpse, this should work. And as raised, we might be able 
to unify later the scanning with the almost-duplicated code when we do 
the second scan.

-- 
Cheers

David / dhildenb


