Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1592ECCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 08:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FED68E0011; Tue,  7 Oct 2025 04:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6468E0005; Tue,  7 Oct 2025 04:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5278E0011; Tue,  7 Oct 2025 04:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 469338E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:53:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DBEE713BC0F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:53:10 +0000 (UTC)
X-FDA: 83970703740.19.6A90461
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 84D8C140002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:53:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EiupYzBr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759827188; a=rsa-sha256;
	cv=none;
	b=IXB8KxNsfEgkH08lbO0zwKWMj152VPWInSQf1xxxPskgtewG8Ezop516XrAFRSEEcsZSqM
	vZphK0v5PI3Pwt1cG56N/3ukZ9h39jyDr8I0nC2jN2sLW6xs5sw4Q0I7vnmBxFWHzARytB
	vPSE28H4dDVdIqaR4V8njN/WcL2NdeU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EiupYzBr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759827188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQnfZv3MqfOL8xNCFAdztN1dRTAw85mhvh6steHZAEY=;
	b=UVQKZMhFMyxX0Yrdf+XTiNw/E68KUSTzX4XouCxzTKfE3lrQyZqrh09Xb0QxYux0MLkpdE
	2HGNO0vjv2icT5H90oD0DN0pvxKSQ7AZ7wPv/Nq7SRftKTZ1sQhUetC4H3qo/IvhRa2HE9
	RiPXm4eB/zBQVpf9d88h61mA+WB5CL8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759827187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nQnfZv3MqfOL8xNCFAdztN1dRTAw85mhvh6steHZAEY=;
	b=EiupYzBrKUAe4RicOUeroSFCMCpq48zAzl2B6BUCN52vJbFx5BHyMNvD3zZrb5O21nrHj5
	QqS2NIutAgQlLOliY8sjO/IZ4lvJXowkLDcaw3hvVSKa9EfjhKvIlHXnDALaCYE8xthu8s
	Z2G+Ixi3d8V7k0Ipxr8iM/E208vVn9Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-aCznXR1xMRS3cTLSOYmfJA-1; Tue, 07 Oct 2025 04:53:06 -0400
X-MC-Unique: aCznXR1xMRS3cTLSOYmfJA-1
X-Mimecast-MFC-AGG-ID: aCznXR1xMRS3cTLSOYmfJA_1759827184
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e3dcb36a1so34972995e9.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 01:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759827184; x=1760431984;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nQnfZv3MqfOL8xNCFAdztN1dRTAw85mhvh6steHZAEY=;
        b=jJZYoTuUAWG2r7vT9mU/SVg5EoZGL5PPwzjd8AHwRN+PVzI4eCBGPXNGDWbOlKJeWm
         71kvRdUdMvGOJvQkRQg3XTrXnSVoIWHs2OqZ9xyhwycIE9uK96L3cbrZsPrZPwH1oItq
         s396EGg8x1DkUE5iesgC+M2P1spcC63dGOtz3/bBZOmO5Pclg54BrKrcLNN0+OZ7fUAx
         SjKN/XyHVNDRTcJgCHIZ78MpiBvOC3bJm8HIF53opT7W5qL4uA0XLXtN53/sWfMed4LV
         nwMbvETfo6QCQ5KuSQjV7L84TWTRbmMPOoff6WbwlvLXqrjzS5il9Q/QaQV75IPJfZEZ
         VkIA==
X-Gm-Message-State: AOJu0YzVuKuq1pkMoI9eCe1L69ok/l2mHUmJfzAcui1vAdFjCH+RXgC+
	X1fK1EhCyE54wIUDO34q+y2pBqDTZgpJ7bkgOMyKSkI8oogHA9TCXX8j2jUz9xfpgK3sWDPArZE
	iuSV2C3JFPehGkuHbbIL/u7dpcWW9wsTqXOfzPpk6GM+GVXHJ2CiD
X-Gm-Gg: ASbGnctSqclj1NEGNdXnTqp496p6wV+lW8fTV9WZWMtfB5XimgY1C6TegYiFGYmEyz+
	qTp/cJd5bp8ne7FUyfjxfix2RjG0cDM8031wungSbI+6iRVuXaeTgRnX93iuOewADomAinDW5sg
	295vb0/Tz2fVdu17WnJuLTZN2svRMHXqOXGpvFNjGLeayOGBP5ZAIl41P6Hqj3evN/6dVsLBYVy
	d2I3rVdtLB3DF8kxrkxvCtwNAXikG2H8uOMWs7nZzo8bn0rJ8KRRo46K3Dfz69T/mhEk7iLuZci
	mECjGxjPIpt4ruk02Srk+ujr+Eo3gBBGCGwL2KYqO3v2ps8/KAbx0oKVE3hl3xta1J4apahce+H
	+tsS0jjRZ
X-Received: by 2002:a05:600c:37cd:b0:46e:23d3:6413 with SMTP id 5b1f17b1804b1-46e710b23cfmr107833675e9.0.1759827184251;
        Tue, 07 Oct 2025 01:53:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbMKjNOcASO90HkvmNFGoFGdmM+wYBav7KkP0ifps16V5XhE8HI+rVR9QvaoCVwsi7tVjAKQ==
X-Received: by 2002:a05:600c:37cd:b0:46e:23d3:6413 with SMTP id 5b1f17b1804b1-46e710b23cfmr107833525e9.0.1759827183838;
        Tue, 07 Oct 2025 01:53:03 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa2cda9ffsm14417495e9.0.2025.10.07.01.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 01:53:03 -0700 (PDT)
Message-ID: <b11adc05-4bd2-4b9f-a0e1-fa64efa9cb34@redhat.com>
Date: Tue, 7 Oct 2025 10:53:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org, Usama Arif <usamaarif642@gmail.com>,
 Matthew Wilcox <willy@infradead.org>
References: <20251007005022.24413-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251007005022.24413-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JtoVmgY3eNfpdn8rpFzFDNqH8cum1ggMYka4cvQwNoE_1759827184
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n8ory1z1mqh3qcucsof78er8fqhym8cx
X-Rspamd-Queue-Id: 84D8C140002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759827188-458277
X-HE-Meta: U2FsdGVkX1+SgwdktktftSNTzscVZTRRMNgrAFyU1bo6FSQ18vEkh5yznQdd7n105S2MQ3h8/9FUVY9X7fWus9OkHRXXqfd8l284wkxN+OLWogTyjb4M5PfXro9z1SBjWlt1uYjxzaOzMQzGAO64VDi/dhI/ZyOgZH/XluPaZyoIr53Gy4gXyG1YDAqCq/rcOUd3wMdFKw1j5Xym5IRle5vKj0kuJeNjgBaeHmvA0/wE68eoXp/1/UQ9rEJEnxNB+W2yvPHfwUFK1hKtcm6dIU3DNCG1WKWGcYB98RIFyzS1GmqG7gYJSO5FPzzJcHBE2zIgzJTuoD6gA1fLx1CwURE4Ai6tXf5A3o0TPTPOCS+LCP+Y7lFUYeiGpx//1XSxgvp6WiqWApXYi4+1GgAsrCREdTDODGmUuvNe3yskaanQUFtEpnMflCSTTFz001RYdjGAhsO9GBmZwMY+NZV/vYaO2+NvjcESC8S5f6rYRyV1ZDwn/x9O49uZQfM0RL0Lerun2EYUTZp2cgl3XfPM45ZzdM2In63sxde738cxfPmxhabCZeCIgR8UaaUHd1kk3QAKUWjyFrTW+HD1DEPjqCJW6kooPxUkCC+h+B3n3qRmQmArLDMIFRFwABIyM+tdp2M5vG+OiE/Ac+4y5dQ1JwgdgOtErMkxKbVTAwA2b5ny2iBTlF2E6hqiSrkWWrztK98RHle46ATRXFctLdNROZK/BhytnejGv8k46Qy04PhYppCM/xOEuI6meKir4FnBzKPW5sb3xKv/3DIICrr1zbnWzV4DhBppukefTgDiuyv74jqmYvVKKVDDgB48N/dg4z1onSthER9lCVBevz2hw8emLh2o+lqvOoPg5tJ7WTL9hdLYPXI2dpG9ETY5zc+zBFInOTsyl8lypw+E3kY/e7UtYDWTx73vLbN1yX0VHHw83BhprltqVrgI4y3xZdE7RftmFRyqht633BV8hbR
 R90U1Xys
 /aHInw9bHnZfDJLD3CcvWvMRTlbi2CFtM0KiKzqFuMU08F3TnD5Ijh3EdUis5ucnY/MFCTKjG+lkcg2DxVX3afjY2X6b1S2JhJakWGQd4zw7sHZuvOyonWvFm4c+Ccry1LaivDNmvU5D2dhr4ekUbhBd6lWocYk5ZkeDatkNrFvd7Nksql3A6DdT71zYs9FL2shHT5ONuUsx6mkySdaTOHVs6ZAp/v+xgL9zxLAFcmYRfkk40s6ToMYgbwhX0qftDOYxYQParpknoz/2UPjrBCz2A/hZpGsMii4cMaYk/AR/BJDavXe6lQShQ4beVc48VT/WyxCrG2tiNgpkd9V0BdLGQNzUearX42VQqz6OOBV8i8Z6no/yIDo6yY/gg6jsBIe1B5DMb2vctrd9eR9wMKKaXb5IXE86SIspgx9Qq2Txrbqb8GlPknEeR3MF2Bh+LTdl8OIjfv5402PjIRbLDF51yiQhfeN7X7VwEa/wSztiUSBtbCyXYq0nnMvFkKrEo8RUijEx0nRQeLIJhquz/qhMPgMdpxsmIc7QxIPn7o7mgab+ppQjTwkQb+ETA3koPKqM9WAeBc7bX4EaD3e76U01kuZiH0ZF4NiQKEGklTUGM6MY6eVf3BARBduYWAquBd2UMJSL7UTTgjWsLKKIPqR/0wQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.10.25 02:50, Wei Yang wrote:
> Currently we install pmd folio with map_anon_folio_pmd() in
> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
> collapse_huge_page(), it is done with identical code except statistics
> adjustment.
> 
> Unify the process with map_anon_folio_pmd() to install pmd folio. Split
> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
> in page fault or not respectively.
> 
> No functional change is intended.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> 
> ---
> v2:
>    * split to map_anon_folio_pmd_[no]pf() suggested by Matthew
> ---
>   include/linux/huge_mm.h |  6 ++++++
>   mm/huge_memory.c        | 14 ++++++++++----
>   mm/khugepaged.c         |  9 +--------
>   3 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index e3ed008a076a..277ade3b7640 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -539,6 +539,8 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>   			   pmd_t *pmd, bool freeze);
>   bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>   			   pmd_t *pmdp, struct folio *folio);
> +void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr);
>   
>   #else /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> @@ -629,6 +631,10 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>   	return false;
>   }
>   
> +void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
> +		struct vm_area_struct *vma, unsigned long haddr)
> +{}

static inline void ...

And as Lance mentioned, put {} on separate lines.

Nothing else jumped at me, thanks!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


