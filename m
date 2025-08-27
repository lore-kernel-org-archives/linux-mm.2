Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F12CA0FF7
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 20:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D30406B0031; Wed, 27 Aug 2025 16:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D069E6B0032; Wed, 27 Aug 2025 16:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C326B0062; Wed, 27 Aug 2025 16:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B259F6B0031
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:30:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BAC05B8BE
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:30:01 +0000 (UTC)
X-FDA: 83823679002.27.05CDCA9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB79CC000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:29:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c2c+kvHH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756326599; a=rsa-sha256;
	cv=none;
	b=hkuY6vaIqmmXYhd95GCVqVsheJ/OvNjIHTS6OB7wihk8dtgWOiHWKLnm7jKvtPlQQsrrE8
	ncR5IaT+vrb/4T95casTXC7ZBfdj54DFDqNeCw4iAPGbB/jBgLzFcgp4fPQ+WdApmWxpuG
	FerFd2TEwBCajjhmvl21cG1gGvs2lY8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c2c+kvHH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756326599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzokQis5ZL6qsKctP4Xs3z1Gldk6SHQ/UBTYZ2qmTrY=;
	b=2VKHfXifdchK0I4z+ZvrKXfgp1RbBUvk37kPbE/dtz0yul+OdgLEoZYNaLDHxhqKkxeLhI
	CvxEKzOapjlu3+5GJWanbAnWpZUW/DfNgHNk+A4YGIEoNSvG6bCf2eKcYDkwtj2LqZOOcW
	FFVf6IsZ8wF3eoeKiUDUCOTcArMutI0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756326598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PzokQis5ZL6qsKctP4Xs3z1Gldk6SHQ/UBTYZ2qmTrY=;
	b=c2c+kvHHPKIdt98+pGn+SXDMvMuo2AwPtKWZ+M+nIrj2rWmG06sbDDaQE2jhc8zwvv0RdQ
	EXCGQUTciysmddrzI1t9xyfMQLMxQSeTMXW+63gaQLD4P6Xc2tmp6T0tf70Z8fg/t0Vajj
	HlaR/fcnd/kJoFvIimE6VuA0ggqgL8I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-haQTeJmWNuas3Zas08oYJQ-1; Wed, 27 Aug 2025 16:29:56 -0400
X-MC-Unique: haQTeJmWNuas3Zas08oYJQ-1
X-Mimecast-MFC-AGG-ID: haQTeJmWNuas3Zas08oYJQ_1756326595
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0cb0aaso1130835e9.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:29:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756326595; x=1756931395;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PzokQis5ZL6qsKctP4Xs3z1Gldk6SHQ/UBTYZ2qmTrY=;
        b=jYull0TvPVma2IAD5+vleolhN3YrvJlhrVYOMLD3kYUemPQzVpJ/648zxTx4uHFtQV
         /Nju/iTjxsYlxotyInE9FialXm3KSihj7daOD90NCDR0MnvPsdlDMrZxwL6e3obmNxTx
         aoT0uAIGG+ijU0EGXMjUp8yZKoKCHpHEGJVsncOIntiKQHFhFSq/vYFuAc+fScRMAbNg
         FYfKRwe0/OlyXnsf0T/o5g2aIqpka4QoYfWiz4IVNTHTvfHYAbQ2NMY5TUY0a8hZgyo5
         bNMf0HUnDjPJhmY1KPywZOjcnJH694eAYhFpIbiEbYKtnZfI5G+lwbmBsL2QdLHFthX6
         FRoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsGbW1xgpcwOwMeWCYsgQgroLgt/9PtgH2jSulSI62R1PwHf3ppOO1Qjh7akbUcgnmQAFuVLCjMA==@kvack.org
X-Gm-Message-State: AOJu0YwccgipOjtoRb5CSheZ295hJRkVXIJAuo+q8ojUy6b6osg/W+Fu
	9oyy8PEr5ooL/U4woVbrjzFHTKSKCMVK/evTFC/WyPCHotBqirgoW21JnYZkyXUJ9YFoiG/+/gD
	oJjPeHmGJRHrpyddBqqFH4p1pFGPpjPbX3q+1gBS1thfLeBuXhHZE
X-Gm-Gg: ASbGncv/c1Ct+yOwRBsKspDYNje4fGflLjQezMUj2bdGS0uiA9GRlxTfbqE8N0JuR3N
	mVu1FBoRzESw7vtHFhp6bCJsL/BylsNH4xSGaCuW/5+xQRVQvJf8Z+JbpIr8AURYhwRQ4V11Vy9
	nS55hlZU+o2W/NqLglluIWab+3WarRgT/Nx5sb92hThQmgyLa4YuFNYZLKZbhEC21C7ghhN1WQY
	p20XxiVOJtqdL3vYr4hhVKKwaFTBWQNgxy9+4E567sYCG2jBs44vuD4i9Al6QmIwwWCinpc5T3A
	2yF9g622val8qFgfMjt9yIBQDolFrDXNDIQBw3twB8aC4LiiBDBkU6IeBme+gNYG9sGNK6WmUEW
	POWJht/dcTFa/vneP+Py/RiuflWn5JTJfasx6IuvyoXadryC+O2dFA4ImXHT7uGXC9Cw=
X-Received: by 2002:a05:600c:c87:b0:459:dd34:52fb with SMTP id 5b1f17b1804b1-45b5179ebb2mr190291845e9.12.1756326595151;
        Wed, 27 Aug 2025 13:29:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRZbz0F38PgQXgnCEw95o1suaGM69HCqab1SOSSbvnFH7ZiXZ+shWII8MvVCiecn8ZaBeb2g==
X-Received: by 2002:a05:600c:c87:b0:459:dd34:52fb with SMTP id 5b1f17b1804b1-45b5179ebb2mr190291705e9.12.1756326594730;
        Wed, 27 Aug 2025 13:29:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:d000:d4e1:a22e:7d95:bb63? (p200300d82f1fd000d4e1a22e7d95bb63.dip0.t-ipconnect.de. [2003:d8:2f1f:d000:d4e1:a22e:7d95:bb63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b79799c81sm1683715e9.4.2025.08.27.13.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 13:29:54 -0700 (PDT)
Message-ID: <5cdd07b4-f924-4207-a8cf-09b4fc26d3d7@redhat.com>
Date: Wed, 27 Aug 2025 22:29:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 07/11] mm/thp: add split during migration support
To: Balbir Singh <balbirs@nvidia.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-8-balbirs@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250812024036.690064-8-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lzlSNgF98qTm3XYOGiZUXWa6K_MegcTuNgc4qihIuP0_1756326595
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: CB79CC000D
X-Stat-Signature: wm7rwtbnm4ems1hbp6tppazoobyiuqog
X-HE-Tag: 1756326598-460226
X-HE-Meta: U2FsdGVkX18dezEm+dZybR7hSR8yHW6x14Vor+4RvkIfjN0dBrLu7sYON85SDDprF3xEdhqcHPXyD1yf4f3IFOF3Lg7sU1rXk3hLMatmGlGsiw6X62D/MLtOHcp57GXpvqvwiCJxmRpZjvKwNv1uWA3i/jDuRKuka4MNWbkYN353DF2B6/kg6cgf/y9+ipmeUuHTEE+vsUHRn+CKtrvEFCPh0ci4dixQiRA3rv4xZNl4l0yZSmnpLdz8A5ttXJtwd7JfGOtED8+cZheLlnwNKw3iwX/Jkmb+hGKYffiujUBrgFT1MGsGGm/8/yVqIgqtFJMotZAS7MPVsouYTuOrfcjLK2MlIjy7MzRP/tvpgI8jLryWsi90XonktdknYsCSIuvUlcwIkZ6LSCe2ZlFn274KhdRWO9aPNtY0zr2SPnLk0q3LVZjkRl5JKVTNr6PKul296V4aJtWTTxDvu8uu9ZPHGj8KK8/ty1FdWs1WB/Fw1xehZjIZUvz4Jh1RmbOl12G15+0pmf5XWOzhNxdi4WiNgcQKkfYAjNyzQ8/+G8cluEdmvPIwqQHYkcDF1L4cqzwbZoRATgbv4p+40NmYZBinE1ZA6J31S9/EarGll/G9bznCL/g68TCHLmFP1Fl6BWAfjUlmP1CFXzzw2/hrvAmpKtUZL/V2EpNKRZ4kZFsSi1vLhKXommj8yb401r624K0G+Uf2EhyKnNtuf8TTXv7xUw9wVX40MxZULSl78GDBkBAn9H12/qByLgXYrPkiXtAoPnemdvdEfCrmH6w8mkos5m7br/3M/tsiiDQeQy3otlO8D2YcTmraj/nTOD5OItaOi3cVCg5CBbiMJ9N1gvAMhj+4eNgCaPWvZ4xYH5+8S3UwpQ1AnikjNjFIyapZaXSHSt/XsUewJBEH3dpE7QGv4STFwt5q0ldFKLc6iSf6iDOa/Zww7T08GaYIv5S6ZTYYqNrjyG02jQcipXD
 Ezh331kS
 c/EWBEqyVnba9RKH2ohRt+PdWPtFIMPaBSBpCNSImebZe4Zc7c3Z8IOF9rybyHzhQJeYaDCYmJcsSPbLGMXThUrSdk8I9KHdQU1Q4k3g3HaMo76jDA6lqzToDcujf1fK2sSelRrETieSA1yW3FuyhJH0KbNAZX5tQMSmsKJba5b6x6fT/AbQrf3wgxPP+HWUEMmHZg82xQM5+sAnwZLou6u7cGzBje9pmsxU01Mm30d7X/nWbkXpKmMbARyQ2sIQXu37JCYStGiXmadBPsqhrgH6Pw+UENA/Txwqqn3b0Luk9xJWBt9PU1461U8ItKZStGU8gwBdg2wjpHu5vrmJIvnEQ0tVe6euBtk7Ltj8d4Jx1tb6qOCv9Rh4HpYbK7Ldc1DzreXOqrNMrzu0sacqi5cQ3nJmY97Uhr384CW/FeJpRMjzwBiM/o5eos5T0NbtgEAWMl45Bl1KXSknYFjvA6dKTlKvw3wYM9vqhAvHSMnIS5jQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 04:40, Balbir Singh wrote:
> Support splitting pages during THP zone device migration as needed.
> The common case that arises is that after setup, during migrate
> the destination might not be able to allocate MIGRATE_PFN_COMPOUND
> pages.
> 
> Add a new routine migrate_vma_split_pages() to support the splitting
> of already isolated pages. The pages being migrated are already unmapped
> and marked for migration during setup (via unmap). folio_split() and
> __split_unmapped_folio() take additional isolated arguments, to avoid
> unmapping and remaping these pages and unlocking/putting the folio.

No detailed review, just a high-level comment: please take better care 
of crafting your patch subjects.

This should probably be

mm/migrate_device: support splitting device folios during migration

-- 
Cheers

David / dhildenb


