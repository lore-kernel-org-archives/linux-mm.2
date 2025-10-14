Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C18A8CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2633B8E013D; Tue, 14 Oct 2025 10:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213528E010A; Tue, 14 Oct 2025 10:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB888E013D; Tue, 14 Oct 2025 10:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E9FE28E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:58:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3A5011B114
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:58:51 +0000 (UTC)
X-FDA: 83997026862.28.4C33956
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A1A24001C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:58:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gLO7rds4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760453929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYVbINRSmFk2th/S/4+k/CpnsMJciemy/4mjE5VYBng=;
	b=5qZUiKmLl7JGS74cVnsLsF3j+RS8KhVLyt08Bh8g2yInDP/J69qDlHS/Zz/CxXDXA24IsG
	gCImJh4KGFQJAUowykS/JHKSlz6huDK2Q1QdeMFh/vUkuRC/ghD3AcwjT9ZeMoACHQtV2N
	HLYpsyBRgtGCl9NwdErwtUROzbou5No=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760453929; a=rsa-sha256;
	cv=none;
	b=n11Q4b00O68ffWWto1Edmug/VR0KzFLryJD7rHv9eRO9EpcLAOmDjiNELsRT9Gc6NyRXJG
	iavurBXJni1+38JWQaJKpar+sjKqsLJe2qvW3M1qIu2mO7w/EmDLePxaH1c0r/BwWyLvCS
	ZnGXIREd5Acwe9IhAA1odgjIYHrpd+Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gLO7rds4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760453928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AYVbINRSmFk2th/S/4+k/CpnsMJciemy/4mjE5VYBng=;
	b=gLO7rds4P1DT5e9vFNGD5mS7dTT2hdBTjPH7tYEp/YVo6EqBrMDrdqMCXIcgZ1ynwV62zp
	gJRJ2/jsclRKjmnFIm2UUzJIrsa0aEmfnyTFqB08ixdrwhjgWK4JHsUSIHn3qn8GdQaZ6o
	NICgjVqe7jow/i3wOotQOGv7D0MmRTA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-L2rJhz3cPT-vB953rr1wdg-1; Tue, 14 Oct 2025 10:58:47 -0400
X-MC-Unique: L2rJhz3cPT-vB953rr1wdg-1
X-Mimecast-MFC-AGG-ID: L2rJhz3cPT-vB953rr1wdg_1760453926
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46fb328a60eso17984855e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:58:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760453926; x=1761058726;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AYVbINRSmFk2th/S/4+k/CpnsMJciemy/4mjE5VYBng=;
        b=a1rqo7+XkGHMI1x9r5GaYHb3tPHsNeEELUcNzRClHcbjEY821aqdkyMt+Ztx3ZH+7h
         vOiqB+K/12xgfESbPJMLEBlVKsiRMZQYECdG3+Iqjpamq6XDBfiUqyTWlg9KdlbrNj0Z
         4wkUXfU/43KohXBNn6YkBf2hhYC9gz+GineyFuISyNHKVzchMEygFDVQw0ktVHegeREb
         JZKUaoTbjFzzlJOVJWzFyGpD8Qd/nMAZ+BNL39FXUDDeRiePfpv+fu02TzjR5aJok565
         SmiDentlkdGdtmJUl9e6VkYOnZcfCszyt7x/yaXDafxFtuJxrknsIwb0gsm3ujhrWcQ+
         wE/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVFTLCmaJLhYL1LhhHuCWNRzd7QoP7/3UC21M6r6kHh3qx8nFR6Q4PlPxp8pqMlg7mpOgpWd5+P4w==@kvack.org
X-Gm-Message-State: AOJu0YziZUDhboYM+I8+IgruuWY/onBpSOhpOHL6vIb+G14KR8XjfX1c
	NmFdXI9btC87ZEJ7HPT+dEW3bz3ljYFl4E189DkrTYb0Y4+XF1+o+M1NJboDaNUgRvlkCpuVU2B
	H+KWC0lOclnO5BZm3vtUVnEFbVc8SoiGOyx4ZWVXk9X49Bgt6vhQM
X-Gm-Gg: ASbGncu0FlmwH/CM12lz80dDHG8k0Jb6TI+GY9AVoF9pw15VePUsMhf9rkajioezFQC
	FrmVtHaXG7wvarGqYgaJrxfIeA2uHJpY30oXpuZMAjyNNNGfkLffFwYbnY5gxerLreCSaiv4Jg/
	PwyRJqQqkOwTE5KmiMHWK8Wevexx9Rdn0BFG7Vd4VAhrXSLdVrvumruAC259Lrc0iZTPf1NqFe6
	Yn9olSZCjgGZIFRGSBesaz/+xSZnv45fNJ06odbLW+EgDg+wjsgik8dXCahtibw0MVaROd9F5XD
	vI+Db61+SdOLIKnsddTilMRH5jOHkUC+BvoqkrgwYbPVspxwUP/rU1YzKAiI2RkSSzcz1FuxEA=
	=
X-Received: by 2002:a05:600c:4688:b0:45c:b540:763d with SMTP id 5b1f17b1804b1-46fa9b18258mr188890515e9.33.1760453926218;
        Tue, 14 Oct 2025 07:58:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8kReNouh/FMllDhZL1/LjU5H2+MzwpSXXqIoRDT/EXSsokN8bUOOMTMa3S5ppFayGgVWyaA==
X-Received: by 2002:a05:600c:4688:b0:45c:b540:763d with SMTP id 5b1f17b1804b1-46fa9b18258mr188890205e9.33.1760453925803;
        Tue, 14 Oct 2025 07:58:45 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e13b6sm24159844f8f.44.2025.10.14.07.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 07:58:45 -0700 (PDT)
Message-ID: <313d2c86-d13e-4f79-b977-81a43d685cf6@redhat.com>
Date: Tue, 14 Oct 2025 16:58:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge
 pmd
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-2-ying.huang@linux.alibaba.com>
 <4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
 <2861a35d-4f8e-4ee1-bd11-b915580c9ce3@redhat.com>
 <86bb70dd-2602-48f3-a683-5ec62b37fd46@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <86bb70dd-2602-48f3-a683-5ec62b37fd46@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sXWLnfzHSu8LL2yZJc15QU_s1DA2Y_RvKeGneiuKO58_1760453926
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A1A24001C
X-Rspamd-Server: rspam02
X-Stat-Signature: awnoaofpyjefqqqyi3rrtszujzywq6ij
X-HE-Tag: 1760453928-888964
X-HE-Meta: U2FsdGVkX1/sqZmsoP3A+Xd7/FaRm3IWGNad2f6aAkjGujzrp32gWDmbignBIm99pqm72/0ViB9SPVZAJHSWMt8quVQ2qT67vWnbCLCPI5C5eRS5pndMmLwSlbEMKv/sN6cL1QvNjEV7tfuJCe/0kS2Lv3xL8D8ugT8RTN13E6inzZsR57W0p6sMTi6zRCY2un8OYxDIMaiqKvAgSWhFD/3kKLm0RizslLys5KJ2l+nl59DwlvSY1X5YtfbO3QwZA/fqaTSos9mu+YFqAVee9mAuYarkrZ6bmLsbM3nls+EGAmICvx0PPuRiaLsDc4fIF9Rsz+Fjqe+A1K/7jr8rfOBNFZAj5friY1qshutab5mpfc9XiD+vzz3jpxUr0t+sqdo86degwDQ1P+tT2jXiEllX+SEOaLSqJooOiQh3HcBUvB02NBjK0mxmKZ2fU9CTZNq4bcUhUcgHqnegT52/5VfkzDfl5Km75GN+qsvUirC34IzLcqtJK1KcK8X/nd/OBfTidxc7E/3vlJ+Zwn8WShqfPcFPGO/OrYyDnxBXm7fdi7A3H1bL4baohSn6Iahqfe3TAh7FLeSg8fBg+nWxssYZku/QfXENWgHBN3NdB7JWTfjgwsgQVFbvJKLpp8+0nkGWTpx3SN/f+M50IzQRnjWQ1SPYBYD6ittq0yKpH7/7oJblNbtczxTFo+BayqhRGJ13uLg4dnaGN02HamZJ57GTklq/ct4HO4WjdHHXkqGBapQi5BaQkcNGC8CWrdVplcStDgWc4Go7PA8yx4yFPLbcuY0pBFb9vGTt9FeNN+iyIrvzAjD3y/kxhmzuqg/RdzLmQGdljvB+CnLvCzfib7rqnCdk4/5mMhjCKNAfEccY71WSc5yVf8o9HhBgK3kQFJSKdoh+tr0C8S6czlAKkDumDoqwTiF8W7+hfH4arbK0a9nDtH9KEPLaycxnVXlRtpBAIJV7zWWF7riIb5P
 /2EVj94f
 nsRx7haFKbBOkndUjpAmBcCROzTKLE28lVH3Bde89bcHl15P1QlyHFa4o51G8NEcGSMK1SPO4u1uperLWfEtA1/cFVPb3Vi1gsyBb0rbBQKWsPr/MbfoFJ2BLZHChZ6el81y7StQRv3+Vn1woTAi1q8uTcqals2bFxlQtUl1F3N4ShXOiz1hMd60R5IXbejVEkDTnL24g2uXSJ/IOzAcikZ8ombPunsclL2aRge1s3Rt7pvlfrb0/VwsmdskbssccxpK1vZwXqxe/gDsRFN7rRQV0oki7kvSc2VqKMqmImHjY4YagBfTpJNzieMe7ytDRv4sOXeVZDycqUzkXeBHImkAOKZRvJ9bZwN/03qkKW0DwqeuXUBK/vg8AI9B3FoiCPoapK7X7PySRIMO/RnLtIHkUlHI+hPjMVw3yxIb9J0CktvA6PJaowO/ozJ4FskhLDMzsEDnjJg9hr4pGFelpWnuUtwclEgo15BjYz+0og7DSoCeNdz+bPfsjAlopLNtcgcTJjRcEorVMl+s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 16:49, Lorenzo Stoakes wrote:
> On Tue, Oct 14, 2025 at 04:38:05PM +0200, David Hildenbrand wrote:
>>
>>>
>>> 		/* Skip spurious TLB flush for retried page fault */
>>> 		if (vmf->flags & FAULT_FLAG_TRIED)
>>> 			goto unlock;
>>> 		/*
>>> 		 * This is needed only for protection faults but the arch code
>>> 		 * is not yet telling us if this is a protection fault or not.
>>> 		 * This still avoids useless tlb flushes for .text page faults
>>> 		 * with threads.
>>> 		 */
>>> 		if (vmf->flags & FAULT_FLAG_WRITE)
>>> 			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address,
>>> 						     vmf->pte);
>>>
>>>
>>> So I don't see why it's so egregious to have the equivalent here, or actually
>>> ideally to abstract the code entirely.
>>
>> Let's definitely not duplicate such comments whereby one instance will end
>> up bitrotting.
> 
> We're duplicating the code in two places, how would that bitrot happen exactly?

Often we adjust/fix comments to make scenarios/conditions clearer or 
extend them to cover some new conditions.

So even without any code changes people will just ignore to update other 
comments.

Code you can at least test with the hope to find inconsistencies.

So copying rather large comments is usually never the answer :)

Well, just like copying larger chunks of code, agreed.

-- 
Cheers

David / dhildenb


