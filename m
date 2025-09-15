Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD61ACAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265BE8E0015; Mon, 15 Sep 2025 07:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D9F8E0001; Mon, 15 Sep 2025 07:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1535B8E0015; Mon, 15 Sep 2025 07:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 031818E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:08:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABE3C1605C3
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:08:17 +0000 (UTC)
X-FDA: 83891210634.20.EDB151F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 50A3D1C0013
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:08:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JNnk92dY;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757934495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vO5Sx3qikY9rqKll7zfCyBLKJ3aOWWhA1Eq3H6Wln0s=;
	b=XuaBiuBiZuwJKznkgpv1X6bLKz4a4wZItKjDOGtu3DHWEacV6S7s88lrNYmcqx416QI0OC
	v/1VBQGBM3pNuBR64gx0wwr2+qHRF0zE33fh23Q3gqFLqMk30qZ83yuvvN8+rmpR5P2P8t
	bSGuYpCJlFQuWF9ae0orpkyCO1F/ivU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757934495; a=rsa-sha256;
	cv=none;
	b=4vCWx/gbZ09pB9/NPGTjWkkCGs+4jCVIgxEk/ly/C4meJjfeMHMAi5F6OSHw/BsKP3qQlg
	UqIaA59aI6MPNv1ctSSDCsh35XYl22JGw1KGJGBhRG6PahZ+YDiqz/yL4BZYw3nTYkK7gY
	7/ZOzm1DEvaxEQYnL6miVQO/bASxcDU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JNnk92dY;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757934494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vO5Sx3qikY9rqKll7zfCyBLKJ3aOWWhA1Eq3H6Wln0s=;
	b=JNnk92dYFgJElfnBnBeOarj2oQ0UzcK0+/DxveeopGkgov5szKGd88afkl9y72I9QxoDH5
	3jIojxLhjFS7u3DxftlXEP9f3Jz9MBhhBcK1348gU+lNf7hX8mk1gI8NwnmtEDjihIGG/6
	p0ReQ8TQuuj7js+bBueP8KBNgF68pug=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-PdsB9k_CM_qfZogJVLGqfg-1; Mon, 15 Sep 2025 07:08:13 -0400
X-MC-Unique: PdsB9k_CM_qfZogJVLGqfg-1
X-Mimecast-MFC-AGG-ID: PdsB9k_CM_qfZogJVLGqfg_1757934492
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ebbbd9a430so224245f8f.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757934492; x=1758539292;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vO5Sx3qikY9rqKll7zfCyBLKJ3aOWWhA1Eq3H6Wln0s=;
        b=WnqNM7zy8JcRVn/PsLYyASFMLQLEIN5K2jFCIx4g+DpWYSyWWmdUfv83u4vH/CCko0
         Qbn3WTr56G/urF/cmZ0u/whznsec8Ut1C8/lkXZWRiSPajfiaz62WxOnnuRyXzLPWvpt
         5l6QdpH7hdxjiLMa1q4w/+7D+XCQ9evlkf/fHwAESaZagd3Y7Z96ZEBTT9lftlhWCPFf
         xm5r6QIij7PklXxPr9M5f0tatMKStgCz+66YdTV94/CgcV9rWrByvPxkwLq6ybyqsPzb
         KDhy3YHA+vfdJqOg19OgnTW3ZNDU1aH4yU+KW6zkwQhIsMcBMlBKV3ZH1nle0Km/3X2Y
         Cn1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVK+oH5WXzvFzr9V9KbrbkbQGJgDzklXwkTHz/ZyXVJ4X6dHg7xuJpwfw2CC3HT52ee+ypI9T9S4w==@kvack.org
X-Gm-Message-State: AOJu0YwpQ6ssyyWeyqbr0/gcaiHtVnbnM2YI3CEGp9uaLSehRMx4dQfL
	fTFIpmKwy/kVYMvhRzVlxAtS8iWbIjDUuEKQnruvj/BPZijGoQcWBR1MDw8MYJ6r+oGQYVfOntU
	JDNMaUli65AdOJEj0//dZZRdxh1hYLZYgXZZk1PWzHyV9l7NYDvIc
X-Gm-Gg: ASbGncvhffjFiArycIU/W8CfUyyWQmHhSf/G3JDco8xXlaFLMrBZi98QA4umM9LSJrU
	n+97kdtWX0us5yDIWzpHEk/ma1mtszWeefMG5zYAuiSVvlj0tmXQR115ww5eEvvNzvXWRdhbHsz
	9WOc0q8iTehIxrEtq0JYfv88uef5zGwdmjajGkn4Wz9ERVScgqytRcHvRo5+6n+Q7GFo0isn326
	1KnEUQKhnyW/BpWolQbBxvjBNOA/T/l4dAM2dRfKWYsHaquXCmgSqHl/pje7mhCTzxgNbMKDqpS
	7u2iq585BUyCOSEKdYVYYIFy72ZE4HMvdVznmmMbWUUyemcOpb6iPgw9fS9F2J+qfE2k/s6fAUn
	LC4WyI+ThaMom27VpWWxa6a3yVXQ/PcFFdgFBA0IzZ9zXQHbgYCl4ZMf6h12/8eb3b0c=
X-Received: by 2002:a05:6000:2307:b0:3e3:e7a0:1fec with SMTP id ffacd0b85a97d-3e7657924f5mr9180917f8f.16.1757934492261;
        Mon, 15 Sep 2025 04:08:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGctyRyrIadbxrhHerFpu4jtEM0UPvEhLZCrLT5sa+2qupDmvbeVcrVDByB23FbmDYJzWxMRQ==
X-Received: by 2002:a05:6000:2307:b0:3e3:e7a0:1fec with SMTP id ffacd0b85a97d-3e7657924f5mr9180891f8f.16.1757934491798;
        Mon, 15 Sep 2025 04:08:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0153fbd5sm91804875e9.5.2025.09.15.04.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 04:08:11 -0700 (PDT)
Message-ID: <8c51da7a-7370-4678-96a3-7cd6eaf0db62@redhat.com>
Date: Mon, 15 Sep 2025 13:08:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm: add spurious fault fixing support for huge
 pmd
To: Huang Ying <ying.huang@linux.alibaba.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
 <20250915032946.33203-2-ying.huang@linux.alibaba.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915032946.33203-2-ying.huang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tpxWTtaaA5iJAonL3eU2-_wf0RWZ69HTR-o3ZyZEUTs_1757934492
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 50A3D1C0013
X-Stat-Signature: 1td8ymbbgem7h58sr334x5ngd4yr7uwe
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757934495-615499
X-HE-Meta: U2FsdGVkX1/drItatvaNBkyu3ZLdFUeTU4YC3io7r//0u3tbnNtlaoB6qktREmfzRLkyBdDR1jT2WTBSaWLrwpUklJTqminQqvXfS+3EH+xQUurFP1CkG4/ZOVST9u7iQxUehI2+Ig9GYOGvU5tf4pjr1Gm+TvQDT/egdKbVQHIf2BkPC1PL+M5J5ga8INnIh1n/L1EXRkGuClzTsss9weXtJwONgOVTxrTwTHqxxCFDLn23kMtmbOzx+cKaAfLYh/DFrtcQflh+k98ZVphlJVPFMKv75yY1vCuT6E0IeBohUb+4yzymSVlLurroTfvMVc/rD42McwI3fFwEmDAn8flxd6c6uN/P3Qcmry/yOLmtBBroow2A1lQRze4TTVDjXzDMcJfOHM6+m/mvaZRnc0GtEagQ3dli5DQ3W33D5bA1fkT07Qnbj5PO3/9DX+BG0zlviDZbwUlIJKgWAb1pOHjf7Ojw7VAE7GiIsBJxH8GvUzraHRrxp94RxyEK3tVOB3p10NKo+f5MhdS+97AlSiGQx5gJZ7eUsy+jokvvrlH17hTiyql1CN9MoxS3ewcjZ2LGdoty1lTlYIZa5J03aZTI5uZBHXow1EhqxGfJaanZdtcjHgbiaW5TXKao8fTFtSzDRUdwh49Em2B8uq/q7Xao43MYeUw809V+5CW+q0jG9KenwUB3uDoJMItioYhw6eggaF8FdL2efp3Tfbp+Bq6wmZAnGYHPS5ISc8c6zHT5F/PKpDhkpt4fUN/3CtABW0JSW48WDvAvPoWSLxbn34R4+GeWvOmcnovt+DBihLtJcjLqmkePrgTGRG65sTOLHidZTNhLhuy1SexomuUG82hW2bdu+ZSu6RcBBvFXAKJQte6cS8EJdWMhv3h/p2vJMW8MX61ExLM8k39OSG7PNl8/tZ1h1iCSMrWnq+Kp3H9zujMQieo7nBPvVi+hD005fH/YSX1zkJ7VVB+V+Fo
 D3h9uepV
 oIkWZvHPI29hAHKxYe0peQlu7j0msbdrA9nqwa+DfyStBkztYkxZdTYRhv1994XgXFdeqCdZVggoe7JxsBUMDAAzyVPeMynndYQDxh3iCRwIl1dnsfzdnMSdRJXVhvO5lKn6bWfFh6NeRX0Mb6vtpTAJIk6x9fu+sK4K/BcF4QZ6Y1thKMQOH+sEuASURTazkRqwFr3dKbJmw5zmrVMetmU7aaPU19PSVmmfT3QTb8kBULCoNH3sdN6DslBuXXXTWPV+Zvr3b/IIpPO4LWOWmCSxzqI63c3xxqyI7/dWvLoGEbrQVjEQdS9590xKfQVJF+0LOehVkOrb28Dov9mJ8Dq1ovaqN+JspMpXuzM5gUy5SrHKfUO10/VmWKCAHIGE74GymjT6neIBXW0ndd7Mb6if9do13z/Vl+CdLVdHSJdfLH0t7cDGK368gHkbkJIJfjymi1+jfcbiJmI+AR+6G5X79ydbQVQRDCFPCa/phvVNUw+EVW+zSwfh1Im0SaHGQuTt8nvxbyIEIPcyV+EYxzi+Z9Ylb//rlaMExoLW9lRbOKUSP+PYvdNdyGTjZG/UGTlDxfQVEzHR9x/nRhIRGfMNOLQ6Z2qRSi+aA2I3JvXtrIeb9VTQQW6e+IpU3tJCqREGuXaKSC8J1XzpjLxVcRXlGz3hI4L+zlf5a+Yyx66DcNVgG3jwqqCesIO7EG0bPRIQILjtCkBm5iLbxL36seD/7EoHm/qWkre6etctfUKb1YTfW82EVob5qsvcUXtUpNvBWJEQ/RNKETvoZ8ntXHu9buRK9F87166KmDKWAn02vtuPEJvbsUYb31MThuXqfZQ42Hf8nhH0boAKUvujTL7hAeNWqbDXnv2q+ZDi204BWETGtCg8iT6eb3YEJwvm/gpAxc7B8AUmxA1mOZQfZ9s1E4ibKMkJsptI5ZPt2dbknfRqUQJt2hgUereutr9f/mFLk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 05:29, Huang Ying wrote:
> In the current kernel, there is spurious fault fixing support for pte,
> but not for huge pmd because no architectures need it. But in the
> next patch in the series, we will change the write protection fault
> handling logic on arm64, so that some stale huge pmd entries may
> remain in the TLB. These entries need to be flushed via the huge pmd
> spurious fault fixing mechanism.
> 
> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Yang Shi <yang@os.amperecomputing.com>
> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Yicong Yang <yangyicong@hisilicon.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---

[...]

>   
>   int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> @@ -1857,7 +1861,20 @@ void huge_pmd_set_accessed(struct vm_fault *vmf)
>   	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd)))
>   		goto unlock;
>   
> -	touch_pmd(vmf->vma, vmf->address, vmf->pmd, write);
> +	if (!touch_pmd(vmf->vma, vmf->address, vmf->pmd, write)) {
> +		/* Skip spurious TLB flush for retried page fault */
> +		if (vmf->flags & FAULT_FLAG_TRIED)
> +			goto unlock;
> +		/*
> +		 * This is needed only for protection faults but the arch code
> +		 * is not yet telling us if this is a protection fault or not.
> +		 * This still avoids useless tlb flushes for .text page faults
> +		 * with threads.
> +		 */

Can we instead just remove these comments and simplly say "see 
handle_pte_fault()"

> +		if (vmf->flags & FAULT_FLAG_WRITE)
> +			flush_tlb_fix_spurious_fault_pmd(vmf->vma, vmf->address,
> +							 vmf->pmd);
> +	}

Okay, In the PTE case, we call flush_tlb_fix_spurious_fault() during 
write faults if ptep_set_access_flags() returned "0".

You are calling flush_tlb_fix_spurious_fault_pmd() during a write fault 
when pmdp_set_access_flags() returned "0" as well.

In general, LGTM, but I would just let touch_pmd() return the value of 
pmdp_set_access_flags() instead and add a quick comment for touch_pmd() 
what the return value means.

-- 
Cheers

David / dhildenb


