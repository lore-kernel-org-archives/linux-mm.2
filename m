Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93FEDCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA42D8E0005; Wed, 22 Oct 2025 16:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54518E0003; Wed, 22 Oct 2025 16:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BF28E0005; Wed, 22 Oct 2025 16:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC1D58E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:24:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64F48BC18D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:24:14 +0000 (UTC)
X-FDA: 84026877228.18.366913D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id E42DC80007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:24:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DmeV+p7c;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761164652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8sawOIoUzZEu0j8xgE4SlyrEgF5lTOfUde0v0D4Y48=;
	b=q5o0VbgUD2fsDyANYOcdlncfbUNcd0dDGfLRQV8UmYwFS3gtUCCrdi4Ym9knHqlUp+/ln4
	DHFUJ9gShhLmm8U2Z46WhuXuPryeBOcWHOttCar2rX6Ab0nARbCnyC37RcZ18s+GmoAl+k
	N2SaSOzMRfL8KOP2YgwnECV4C7eSnpQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DmeV+p7c;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761164652; a=rsa-sha256;
	cv=none;
	b=MSi6/gAaycgUrYzZHL+lndCW90vnm07Lal+UzQgMSK/vaN2IrTMzAAlf2A47Amt/uaULtl
	aMMTEd9lyz57nRzgMiqliqYFLbrYFRX6ISTCSB3uJhRuBw3OF7mxowmHhHRjUgfF377LfD
	NWxSqCcI0R4SSLae4MoZQ4fsLcaOC/I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761164651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=e8sawOIoUzZEu0j8xgE4SlyrEgF5lTOfUde0v0D4Y48=;
	b=DmeV+p7cvw1RLG8Q3k1c4Wvu5ImXUxEiblqBS4rpXw7xAcnLWvk0aI/Eu4ThZ3z2V10f2H
	7ms8uBjmz370Q74uiBDT4SDsfp5Et72csb9AfsYThgS2NrZicccY/OzDo7Tthsym3aMRKK
	56xgpMgcMHeuTbw8BbKNKowsPKFU0go=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-awqQ8athNQ6E_8izoXTgpA-1; Wed, 22 Oct 2025 16:24:09 -0400
X-MC-Unique: awqQ8athNQ6E_8izoXTgpA-1
X-Mimecast-MFC-AGG-ID: awqQ8athNQ6E_8izoXTgpA_1761164649
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-475c422fd70so97425e9.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:24:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761164649; x=1761769449;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e8sawOIoUzZEu0j8xgE4SlyrEgF5lTOfUde0v0D4Y48=;
        b=lNhEJqJ5fVHyPZFH7bXkWRsHTU2J/76YeslqjpbiJkQm5VvkinqOBkzYlLc40sSi4z
         no5097fHoThWYzhgSwiqAhvZ4MbgWnLw7NoFKq25nqt8pP45YwhEJS/6F0IFQSitTugW
         83oOALdoLDntop186zOPpeQLHlEDffa91JeK3UqhvCf2a1H60fctux4cH852DiyVtULk
         qciHOOBzi4PtztXvsBNqKthpLY/+U9KQT0vaTNqZtZAYBDnsGr26XS3X7hDVdIuDWwgR
         JXNcGx6AEVNd7DieK5G9MebQFM+KGwhjSugudbGsFgOxUB7qMxX6+q4DXyBRygMCnaY3
         YroA==
X-Gm-Message-State: AOJu0YyPXQboxeaJ3yfMw7NiIdGW1NeJu9gtj4Nuk6a2awkEp4Frirbh
	SSCw2NjvGRon6UiIGIF+1obL5RdEV6ZDg4iMqrhQP+DwtU6tI+7sdp+uf/JsVcLG9wLqJnKp7Xs
	AHkez6wNPwdCzJABFBSUHS/Yo7jm0SUjuA3JPJycj7FD41Dxa28txGTBsmlVB
X-Gm-Gg: ASbGncsxrwQd25UvM9gKGgby91Id5c/RaX4+Qp7ZfHwQIOD6jSbBceRGCEVd/lP5ivq
	ERUWK8VVFT78gjg7jDOJIs2nbo/XqAcAHiTHxjQ7HcLS+/54llwuviKkJ0WUTeoMhIfPs2w6Wsz
	PAjFe7MyrURpeJ74ys2eDjmoWh9g0s1WkKhU3Q2CePEFDrLPBFidae7uPncRcqIMj7w2fAINEmr
	q+kRe87339mm1+Io++bARsm4g/VXTyT0YcklNTAIqkbl8vxx633dhP/OH60GS7vfcC93AjLk0XI
	lV0wLs31vZXFon9O6zIDgc6OpTV4zruaylkTurbMwu8v0SHOgHzCh2vQD/7pHo5Q0pT7awf2zLH
	JHFX4CIujmFHiAqly70L70ANSJgTsi96RVZFPnc0ml16RAagCDr0jWTWnVtol47bRL6+XT0itUZ
	qXK/lSLthGeYFc0DL+MX1/Mgh8Z1Q=
X-Received: by 2002:a05:600c:a214:b0:471:ff3:a7fe with SMTP id 5b1f17b1804b1-471179123b8mr111828625e9.19.1761164648655;
        Wed, 22 Oct 2025 13:24:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpQTWNDB51Ac84akYrEZaSTOvtME/UTFQj59Tk6U86I4y+KK2TQ/veXOE6MjAMBRZ39kUedA==
X-Received: by 2002:a05:600c:a214:b0:471:ff3:a7fe with SMTP id 5b1f17b1804b1-471179123b8mr111828545e9.19.1761164648253;
        Wed, 22 Oct 2025 13:24:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47494b22536sm43813825e9.5.2025.10.22.13.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 13:24:07 -0700 (PDT)
Message-ID: <0a121e1b-e238-4a75-b431-7c5a23c70f45@redhat.com>
Date: Wed, 22 Oct 2025 22:24:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma()
 tests
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
References: <20251022032951.3498553-1-anshuman.khandual@arm.com>
 <87ecqve6gg.fsf@DESKTOP-5N7EMDA>
 <b5a1b52c-75ef-4915-a254-a502b9f78eeb@arm.com>
 <87o6pzbbks.fsf@DESKTOP-5N7EMDA>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <87o6pzbbks.fsf@DESKTOP-5N7EMDA>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O6DeZqi3eIlTkoxdQVgWv3_7IuQ4ttRq2kFRxqQkShs_1761164649
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E42DC80007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: aqykwre6tuz4xtoorgwant914xg79xjx
X-HE-Tag: 1761164651-668558
X-HE-Meta: U2FsdGVkX1/ZrZkpYi+u1hO6RLaRxUbQ4PtrEjV2DDIdDnKsUe/ZTBGqIFnAFUxaCcYITmW+d4YFgl7R9L1dr30w2cXxDk7z0AN6YlO/3Pce6LE0vrWUkp89OvD8Hnaxk3iZQf9CwAxxUfM0PC5rFqO3hjZ3Dp/YfbhitOikT4im40GDE0wXiv1SXEltffpTiRP1l7DNHOVhuwwxm0UudO2po5JBpRT3nG0ccrB4HTEBBEYdFnZ8fEgs+jX94wmFtnYBqA7ZE5t1PV7N2tFVrQK5Ea8Igm92M9stGl3yDWrmN0rCyuZLvBvyRIlZESkY8hxzM/2sC6lJAhmw47IYR8wANtz1RZNTDwC3TYEBebV9LLl98P0CLT+oHfGwgw3BzIOeqCxTVfQw5JVgUH01jG5btdHEXPmz+JYG62xFtiCHSFHHlG7ZJWQHQvDNi8AU7yBkH6OkBNRziPVYbRGADuRa4qV1G4dA2lsdH0vxX5TgB5Df6pb1HvtpIpDcXBXVv238ZG6R4Ch/w64YaYFieZ92dcu7H/FZ5rdjTljrJ20vakC3d7IsjJWqGQpGRwEBVTkIM1f6td//MpcwCIcnOAhNFs5ipDdedNErqNFGABufHDTXfQQMqGDa5gjObU3TUtgPQX4MjnEZ8V0h+TyH/SacSU+BC4Xk1qff3KXjR8J0Ou5eibAGevJJifJNoTE0+sk/2B2QJ03CeDOuE7nZZLxO9IHOcjP1nSHMcCy0bHqadT1+G7K2LhAGlF+jKh4xlLS8H3O9PQ3a/vQVmnw9tprSq23J19Ghg+7yJlGzXhMroAIvcbVI2EjXN7JxqOvyxhVdgNo4OFU3YJnFEYQuZqHbSVXSjMWzTVvxx68xgbpEst5Rz8QMVBW+FhOC4SpknfEB3w1JffD5TxTj9YUPJC+U59nQUP4JtgZle2/yk31HkLIomaPdNvv037mHXuzwtwIz9ldrhQgVrGdKz02
 i3R0TKFj
 S227EyTUUPLd24MNNTC1MLEmcBMffPCmjY4/niJ0a61yLLdFa/aDgkqIC2V4muM/cvwczBvTs16C326NrmaH0juh4IzVa8Wd84AGsZjhoMUrk1/sIWRDdS6bi8MWxDUZ/YTRS0IS1a00l7/gNk4AhyIjoSPbK/61PTzmxq2NALYYKdxq0rbVMjb5x31UHueOZ3GLzaXkS+FO89FPKYBNuVQl25mo3MBmELIazrCHJxHckG6eFRC9Mls0sA3Twlx6yL1c84AjKSnOkEBIuXmwjuURL5lRdg5gr4Z6ctfUIgswfSK/GOVU6EqhUFsSf1OKUeMz8rxkyga53gSxpBrlWACbLRGZb2UHz+SRqYoIx1R5eLjeEiEpQXkMvqdGTVNYL0/6ZiNrCYTeU/s5wsfFSTr64r+Zx5oopMSBcgM4t6vgFYiHQ3ilAF03eACE74RsdFU+UM0mRBt+RSOzt2sEEc75dR7HbR0IvvrWeMg2hCU4Iu71Uer6N3OAVWxAXCCNDvd8/xGOKq347eWMa/hLJath/y0ZE1gef/BJsstPHpxwHtfOlzMvRTNZ2I7opPrQw70RSgxeIfqejrCwCEJaHT7m+ltyfM5FMBGVc6Zzh5L+Vz8xGtkclMbAMsIuGwh23Hk9qOITL5PQd/4aQ9eIR94+oCUYjop845kX5zB+fZMfsfWQtZlvleE9GTx5aU+HL9D6/jWBp+fCELQDagwBs42XjwNwzpxcoUsf5UWX0kpeSQAVOVeKfsjlbYGEre5aVIjCoX1kSD+ihU5jiy8UBVmciKE4V0rCrTxye9eijtypzMEU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 10:11, Huang, Ying wrote:
> Anshuman Khandual <anshuman.khandual@arm.com> writes:
> 
>> On 22/10/25 1:03 PM, Huang, Ying wrote:
>>> Anshuman Khandual <anshuman.khandual@arm.com> writes:
>>>
>>>> Add some [pte|pmd]_mkwrite_novma() relevant tests.
>>>>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Huang Ying <ying.huang@linux.alibaba.com>
>>>> Cc: linux-mm@kvack.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
>>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>> ---
>>>> These tests clear on arm64 platform after the following recent patch.
>>>>
>>>> https://lore.kernel.org/all/20251015023712.46598-1-ying.huang@linux.alibaba.com/
>>>>
>>>> Changes in V2:
>>>>
>>>> - Added a new test combination per Huang
>>>>
>>>> Changes in V1:
>>>>
>>>> https://lore.kernel.org/all/20251021024424.2390325-1-anshuman.khandual@arm.com/
>>>>
>>>>   mm/debug_vm_pgtable.c | 12 ++++++++++++
>>>>   1 file changed, 12 insertions(+)
>>>>
>>>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>>>> index 830107b6dd08..def344bb4a32 100644
>>>> --- a/mm/debug_vm_pgtable.c
>>>> +++ b/mm/debug_vm_pgtable.c
>>>> @@ -102,6 +102,12 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>>>>   	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>>>>   	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
>>>>   	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
>>>> +
>>>> +	WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));
>>>> +	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
>>>> +	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
>>>
>>> Why do you use
>>>
>>> pte_mkwrite_novma(pte)
>>>
>>> instead of
>>>
>>> pte_mkwrite(pte, args->vma)
>> Just wanted to have more coverage for pte_mkwrite_novma() helper which was missing
>> till now in this test. But just wondering is there a specific reason for replacing
>> this with pte_mkwrite() helper instead here ? Also we could probably add tests for
>> both these helper variations if that is preferred.
> 
> IIUC, pte_mkwrite() is a more formal interface.  pte_mkwrite_novma() is
> used to implement pte_mkwrite().  So, IMHO, we should use the more
> formal pte_mkwrite() interface if possible.

pte_mkwrite() does different things based on VMA flags on some archs 
(e.g., x86). So to test the "interesting" stuff one would have to craft 
a special VMA.

Without any special flags pte_mkwrite() really is just pte_mkwrite_novma().

-- 
Cheers

David / dhildenb


