Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17121CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1308E000F; Mon, 20 Oct 2025 09:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577F88E0005; Mon, 20 Oct 2025 09:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E228E000F; Mon, 20 Oct 2025 09:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38E838E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:09:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5763B623D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:09:19 +0000 (UTC)
X-FDA: 84018523638.10.6DB66E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7DDF9140005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:09:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IWTI35dN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760965757; a=rsa-sha256;
	cv=none;
	b=6xdXrdSrgZIUlKCj6bIP5ZObgoQtnCmJR+naCUv9LVnooFPWbPdOo7Jt/QyQPfjbViLlZB
	I9Ao0XNBPohXkbvH70Q364Sm9qVic3zlnDvQQb1k9HeyutqV+m2Z7StKBI/miy5YyRsxZ4
	da/+zJ3HBl/oDJ9W4FM/miExUf7a4oI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IWTI35dN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760965757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rYCzKzzBwAxTE5iquqfwKilNtJf76ab6JCJ79ALXkw=;
	b=xffYLGrMiFMKWElrUjPeuslDGB05/dTK8AQH7EUf8Z8y5rjEgyeIWjszIx4Y7CeN56L63t
	M7sgKDICBoEkQ5GElAUanFRlmyJYMtVzVMVLruoD8CKgZrGqqO+qcIQAxiCJbbWhhA0DA/
	MsiKJ4n7A0/KpgLaPjZAFNn9R2T7J5A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760965756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2rYCzKzzBwAxTE5iquqfwKilNtJf76ab6JCJ79ALXkw=;
	b=IWTI35dNeMxbQT9gWYqOPaxvi4Bv7wivtn6ZwjJp9741AzpjdHfHBDslV3CyCZzD3S8LZB
	T6XPJHJrpoN6BkPp+OAh0Zq6YhJzVo+CiV9fcRBVtAw5kXJ3LO0cr3dtTKyne4BjZ84CSU
	VrltyVlI/aDbpzHqIfOxSO6ZXOo/csE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-DG27gYSJOPausa_DtevG3Q-1; Mon, 20 Oct 2025 09:09:15 -0400
X-MC-Unique: DG27gYSJOPausa_DtevG3Q-1
X-Mimecast-MFC-AGG-ID: DG27gYSJOPausa_DtevG3Q_1760965754
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46fa88b5760so14984725e9.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:09:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760965754; x=1761570554;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2rYCzKzzBwAxTE5iquqfwKilNtJf76ab6JCJ79ALXkw=;
        b=JWfgvBuadA8jZrzcX0lVYIjAslma454XJwONMnIeDlkehZLrgPb7zGSzehGD4nNXUe
         1b9sPgQTBYGO42gPD75X67KBUUN3dOOABSAd7xRi484Cu/eDofrhp+edxK18g0kSGKxp
         LO1xKqqBNH1bewWkix7uUw2sBen+n/wZAz6803D7uTbXTCaOfrMiudbzOrAzC0p0PyAl
         VCqnpfiICQOp4kSG01QhCZKh1sRk1xIYnWqiYYZu91fyBz/xpWbsJw9xv3CKva65wsPD
         awuvgeMUyfxIBk43cfO0RxRwhLiTpZHrLtdDopDscMu23x/M9WPwEjqNiimzM2pQmGf8
         DjWg==
X-Forwarded-Encrypted: i=1; AJvYcCUObkaV93x1Z4sbUmMuqESOaLlaGI/RDHpGHunk0XZHlA5CoQsbvwGkLhFR9Et8C5ekPHROVQeysg==@kvack.org
X-Gm-Message-State: AOJu0Yw3rCERrheUuuNGwK2mNsLzocn3Bsy4Vflozo1NrpzHOkpSEh7R
	hPF2+ziOJ/7BUVWCVCds77S/OvQxPHZy5mHrnDbkQWePA5DMztPUwtOyu+BZj6XbfGT8qVPFBS4
	NbplPdOLcObf8WfX+2G7CkdOH29YZ/J+BBu8UPc5IL+Fb3Nah9bxm32IUGOhI
X-Gm-Gg: ASbGncuFZRFmqN+nlUJe+qC/5MVXCbHUgKV0sbIzD5d0nqlN3MflDObcTGULpXfgcfI
	z8pbc4HAIlPBwpLg3u6dkiR5t/eFLbnvY1+vKKPpB5PVxEWKO/3841JAI4/tmshPbvVAvTGHGvG
	+wAJXAf9pjp09XXyOHIWk8dow0gX0u2rBDlB3zFpcMhmiZO/MA11+537wP1YfN35qhdE7V7mv6J
	+8GOxbWBNlogftvuW2Sz/hSGo58JPtbmLuoBeasOu/WAww2fZ/CBaPkLsVcu/n1LKyenOhLdc3o
	bM64AWios3lpgK0zF2LSvqeqz4AvsagmNzC9xHkWRjgInLqafXtxV3+W9trTiuWr8HnnPiuWnF0
	dr01WYX/bEDKTsYyWQY3uKLfsYwytjpRv3qpjPx7t/x7aSWWn1dL/icArxCc5Hzr6ZBIwOtZq6f
	Jp0DSWC7nmWFxJjX1zSOOdEp7iJZg=
X-Received: by 2002:a05:600c:4e93:b0:46e:4329:a4d1 with SMTP id 5b1f17b1804b1-4711786d685mr95802185e9.4.1760965754391;
        Mon, 20 Oct 2025 06:09:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmVYUubkTO9s7b5d7DeJq5k5IiP/PPOO5kGT+FYrDfMtbz+9NhXdJt5hZA/1xjynXTyR+1qA==
X-Received: by 2002:a05:600c:4e93:b0:46e:4329:a4d1 with SMTP id 5b1f17b1804b1-4711786d685mr95801985e9.4.1760965754012;
        Mon, 20 Oct 2025 06:09:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471143663afsm229650005e9.0.2025.10.20.06.09.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 06:09:13 -0700 (PDT)
Message-ID: <cc039111-c1a2-497f-87c4-262e18566137@redhat.com>
Date: Mon, 20 Oct 2025 15:09:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u_pfYDKoMUQzMg0z0ttbR1BBlndQAXxwCWyHgCyQiP0_1760965754
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7DDF9140005
X-Stat-Signature: 64urytnxuryx446hhpdtfdf3u4b8cnan
X-HE-Tag: 1760965757-787339
X-HE-Meta: U2FsdGVkX19xQE4frX7JplvKG87W8C25LiIHcQeBEHTur62xOGVOido89gGIxs1dpzB2gfsRQauq3zYUPhtvPFiUcuLAVSu+yUVuxMTZlRiub4YaxC00099FyCD1RSA4XzE/kFJiwNEvreGmFnaHCDuBbMhp6n2ySgLulQ1i0Eu9wXN1VI5kr0JtUTS1S05PthdbOVCSmwzhRsLDiYxKpCOVdHF+DeKcXeynU0MmQvF4fvH5l/hwz4YWPS6YmhVn5UjlC0MLNE77OYDxRYFgNKKyL4Gl48p893GmcCTh3hRPYuy5uHiEPqWNICnJUF5xqIS0HFLJq/Rj5RkdJNHFe9D0aQ9DzjnqSiXO76H/bVeEF/s0f8QIxLLXERZGC0l843BZvgbAQU54cl6lO9tn9/hIR8BCLV4BXN2DuIKJu2wBvuBjoLooLdL5KDVRnfrw0uYGM5b+tokRXm1+bJHw8xWWplRkD2TATXKm8D5y8foiC+OhUbJ7Kfm6N0qxgm1fXkk1lxnGk28H7ruugql5YSGVbIOXFKC+JtWeaQ/ziLB6fWe+wSwoOryAgs1rWv9/CFLBmRXkgSbtXwfrndXbQT7ggWsNE9QBvhCMKb6tz8DmpYv4T2jl8UWF1afvdfsacettQpPxWKPHAHnT/L0xnkpS5FxBVvroTnA8dTtum7Fsu9X6FHhQaosHeCC1sA88W/iL324jHwqU3/uJTPYEFUCu87eXhOowqYoNzJvd0hdLgUO9tYhSohKNneuEVzdlCrCiZHpRDEpPr8z/6fw2TB4LXW+xnEepBSlT+3eNYf+q4hxHcEvAWz2rzniQn3jvWTSDEel6nQKaHtIpUi0rSgBkZ/loVb0GKwygAYzZphy0IGMUEdCnexQeof5XeiXrNGd3X7iyjSh7hiAAHSFCAIXDG4gkQ+NXCgjbrxemWaPaO67PE0h07Iv8AafTO8pZhJCQJJijgmgL07Gc3Vn
 luWj0Aam
 aMWY8ssqHv/XFS4rLUtW+2KzzTxFMXEC4yD0Qh6ZmbOyUF9mE58B7S8OnTG6X1kN/mqopPMvDfDm6knRZdMJDeWLcYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 08:18, Kefeng Wang wrote:
> The prot_numa_skip() naming is not good since it updates the folio
> access time except checking whether to skip prot NUMA, so rename it
> to folio_needs_prot_numa(), and cleanup it a bit, remove ret by
> directly return value instead of goto style, also make it non-static
> function so that it can be reused.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


