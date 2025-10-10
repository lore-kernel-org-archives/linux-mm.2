Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E4BCCD18A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76BE8E003F; Fri, 10 Oct 2025 11:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB778E002C; Fri, 10 Oct 2025 11:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1308E003F; Fri, 10 Oct 2025 11:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 510858E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:47:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 123111403AC
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:47:38 +0000 (UTC)
X-FDA: 83982634596.11.80C775B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id C0A76140008
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:47:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BV5scgNn;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYxcb8Ei/Xcr+4iQKa4We4Vrj2RcYDCtpxX0z6XF/kU=;
	b=IpmIlBHXm0Uv31+WqzoIjDSYLFcY7B+wnbU+GEuMyo7035tYFl2Uk8YbC7oT4073ZpCEIE
	jH1ztc6y03DLiqwo0gcXmBEiRx5lHhNdp3+ybxoEF6mbIj4UWeytobp8crV90pL64QgawY
	zaqglSguhp20tnCQKtEtYBL0ifyR2U8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BV5scgNn;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111255; a=rsa-sha256;
	cv=none;
	b=fkNrxxrXDAnpRknLJ393c+zyYtJz/apX454OfYNeAey9p1v42d4JVFq05eJboPw6Sf51ze
	HbiS+iPiFcy0GrPBejUjnHOep/Ph3ZtWSclsTbdcFzbvegtUZ4rfSNQQtGBrnAVKE26Q7+
	lQFZaRnHJUQBhZu7z4pQGhyg5RIh3U8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FYxcb8Ei/Xcr+4iQKa4We4Vrj2RcYDCtpxX0z6XF/kU=;
	b=BV5scgNnvMb7PrM6rvQbaI1Px6eztLmLo2eBEX2UrQApBRfacCP8WmzTSPtaT5KOic+sA2
	6FeNbkumaKd0Q9ZE0Jt1491IUnhwwSnlqFEYyL5wzH9bNhwqio/vAj3LaQS36SGRovipzQ
	BYVnB6/OEPshZ3LTXJvj56QajhDeeBA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-JHO1MmSaPrmBpa2IF2pdhg-1; Fri, 10 Oct 2025 11:47:32 -0400
X-MC-Unique: JHO1MmSaPrmBpa2IF2pdhg-1
X-Mimecast-MFC-AGG-ID: JHO1MmSaPrmBpa2IF2pdhg_1760111251
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3fba0d9eb87so1230828f8f.0
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:47:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760111251; x=1760716051;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FYxcb8Ei/Xcr+4iQKa4We4Vrj2RcYDCtpxX0z6XF/kU=;
        b=lnvIf0lTH8O74eg8oGd02A88XVGQfLgV/bwUQLkZvKpj3y/v8cUuqzhNqXm1EYzZpm
         l/UGRxggg7OCmPZYbbAG6fiXEQaEJydeOO07NenvdoBNPC1Ka2RGWi+e3+BkdCqxdLdw
         wStW3qL+gNTdrxSWRURSVEJhlKV0P3mSiUTQz8OsbEyOMQ9iyDKFCW7Ck8raR5jcwN3F
         LiLh05uyfnCW9xtCJAz9IbgZrzIQp7irUTnDoBirKWhArlapaan8S61zdycwBXD/A2F/
         DAXbANU/5JBMXr/PAH4QBArVZcpDE+KrAeRHPq/R/Qn4Vx3q9iTL4ZE8tpnOkv1iAwRy
         tAmg==
X-Forwarded-Encrypted: i=1; AJvYcCVBl8/UUanPztp31p42wNI/eKnwvJtHJzh1RYyFlea8NPC5VWSIgjT2OyN8T4hawuGlAS3iqw646g==@kvack.org
X-Gm-Message-State: AOJu0Yz+IcosurFr0vFRTJ2Zq03i+2MYZbCh3Mmugjdj4D9Q1KjWwsDK
	7KVoTLe+0UTL/7gSdxUM2z6d9kFKwgiFzacN/pSokUghmoGsEBopURw3ScpjhiYuiGc8iRjwMHs
	iRFUur8DCdybPSX2LHELgAYQ7IZSOwdxIWnfM9wLeGuTCLQPhxnN4
X-Gm-Gg: ASbGnculDKcw/ZXanNhXSeI5STgooCEinu4zFtZqHxtVEO2kZ2zqlzBbQBKicTWIKSk
	7+cXEzyD3VKXr38eTDmv3ddfU7ggokNuQUI96bZ6phaR0iAYjN10M/iyf8egVZfX+SiJr99GSao
	Ipp/Su9QVqNVprnathdetqCAW4OcWfwp/h4fINvAIYbO9ifzX94Rnm3RqYP0HKGpvYhkNfk19VF
	Gs7joRScAquKMY/wULGLTlARjMCEDBZTAqjuEW50kCB04pblkEnPh67vAwGQhv2l67U3ujht2rZ
	8cl+/6aojsMNioZxGzplJUBBvJLqeiaexj3O9/EYNadhzXXYbZ9EwlHQlrqORw/GfTk6xgIeTNI
	uvmc=
X-Received: by 2002:a05:6000:4313:b0:3ea:6680:8fb5 with SMTP id ffacd0b85a97d-42666ab29d5mr6668200f8f.2.1760111250788;
        Fri, 10 Oct 2025 08:47:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHqhMbEUgBI/Iv97iNeHuLMcRgPyI5xUWfi2ZMDm/sSHI/GStcIbfl5wXKZP1H533gyi729Q==
X-Received: by 2002:a05:6000:4313:b0:3ea:6680:8fb5 with SMTP id ffacd0b85a97d-42666ab29d5mr6668179f8f.2.1760111250365;
        Fri, 10 Oct 2025 08:47:30 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5833dcsm4829510f8f.19.2025.10.10.08.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 08:47:29 -0700 (PDT)
Message-ID: <5b494700-a3af-4feb-8c5f-1ca424ad9841@redhat.com>
Date: Fri, 10 Oct 2025 17:47:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] mm: Introduce deferred freeing for kernel page
 tables
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-7-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250919054007.472493-7-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i4IyNc89GJXMWhrWOENySyqiv4M5nlo00Li4Mk1vCJk_1760111251
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C0A76140008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tkptd5tykmzef4py3haws78x76krebnp
X-HE-Tag: 1760111255-606752
X-HE-Meta: U2FsdGVkX1/svfQVBkHXbM+fw7J1JChZMgOl2ORaaXAiuB8ZQBUKUv6ldeO8+QDNHdpWcmGjcWkGg/5dNzC4JUmZb317B22HhzoVuF+SzjTXbelkIXmcj+C+ks8WFnSpQE11bcabj5lxuavOPyN87JV2rLq4r8y/G+aCzPuiLIc4UiEFztHncEG7tHAmgWSRFJV8IMY9gFwtb+k7+KHTCKZNvt10oxBqmSfS7nK+qxZJvJiqSxUGxzy3xm/PuAxOUpps9H/8eG0RPKcJPYhlz1/uE7SC/W7ihOODosY8sUCrupGV1q8wog9jqX4IbQAV6vonz9UvwWfzMeFfZzK4S4G97xVQMU1pxYEWIwAdXvLh5p+KXnBxuf56p2YDiod1Uc+MPRoeekgaWUrLqEhSFenhwsK90A7/UoXGfDNHORhdR70mVTp8lmBGJ4iepuhdjJpS0AsAEu9nXJCJsf2d+48QF2GfSPviatvNobzx0bkdkiiWcAihD7v+3Khb3g5rzkXHQW7RiNLCHpT3AZ1WyC+86AD3PzlkEgRKYqVAW4GDZuiZJwxGD47ONMDC+YrZ+sLNHbqzJJKgU7rcjE0tYosk6DTAuO6b0oRzYVCiybWeAmdkdVnaXeiszNHlDEsbHNIYdmpnHcbH/ExitxV5lp8eu/n0xEH6Hr25LFwMOG37KPGBHeHRRJ39GCryDBKjuu7gjV29gAyab58mXqBv9XHailS7fXXKUzHEiu0c6rd4M0izdkRNeUFNPeuy6MV4mO3OCb4onBrnJaPR4RbjFmwW9fnBUUU59L1hP1wxr1pjbT94dvEtS9RSZ910filszfM1CeAjVzBRP/OdLCLHiH2bjELKuUrGBMktXBVavSpONoGoBzmRZjGtc8iNcyJHNmAkIJE5uTXHxM1/twdgyrGg2VLStu/5j74P2aa6cmPzwzcTKtUwN1i4fPujqw/ISOXK9mt3bIS/Du8r6Px
 8yQXBMA7
 7hbNWX3+1MjW1eE4oMEkwJGWxQdz6bSgUoJ3udCd7U/BUQcPK7vXcgo1AfRYaWfybvxLAVqnPuewzYE6edxBAIcmH9wepFGqgrtY+eWW0YeZTQEdPBqzC2aR7O27Ud4qt5CjEqi5SDTwAd4YzFE8/PmVnINutVyQ1mRNpmVtsuLDlD4enSEaxQLm/UzUf23xBamasHvTdHnRNYhx7JTX74C6jBagtaAdMwJsPMWm/5pTfD6sOAwtPPhMVK0RBruO9EmF2xlPx72J4pW93tzCqcfI7WeN0Qai/WMrsLJH13YGqNmH5SeEnDmU4ctv3FfzBCeoP/54mvsTK0EUycxh2DR4I1b+m78Cjkww8nOCHs8tl33qC98K9TMykX8ZwniqxvvXBxx6eJKqyvq14fem9B017KgJi8/fVvn3wJ9N/x34EGbPWyPu/yLntg/KM12Y/Ek/d+Tbtk8e2G8jz1lm2HmQrA964jKr0riaMDtodqzgejml5CtpkfpQIQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 07:40, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This introduces a conditional asynchronous mechanism, enabled by
> CONFIG_ASYNC_PGTABLE_FREE. When enabled, this mechanism defers the freeing
> of pages that are used as page tables for kernel address mappings. These
> pages are now queued to a work struct instead of being freed immediately.
> 

Okay, I now looked at patch #8 and I think the whole reason of this 
patch is "batch-free page tables to minimize the impact of an expensive 
cross-page table operation" which is a single TLB flush.

> This deferred freeing provides a safe context for a future patch to add

So I would claridy here instead something like

"This deferred freeing allows for batch-freeing of page tables, 
providing a safe context for performing a single expensive operation 
(TLB flush) for a batch of kernel page tables instead of performing that 
expensive operation for each page table."

-- 
Cheers

David / dhildenb


