Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3873CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 06:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450948E00E7; Tue, 12 Aug 2025 02:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9B38E00E4; Tue, 12 Aug 2025 02:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27AA38E00E7; Tue, 12 Aug 2025 02:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3BD8E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:37:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 974FE1156A8
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:37:24 +0000 (UTC)
X-FDA: 83767148808.15.8325CB4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id F01644000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:37:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hRqolI7M;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754980642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYlPhAxHPbIiKQ+onLP18X95rM8NK7n/QL8pKb4oNjI=;
	b=PMwBBMEFDX3xWEU8M7R3211EZO72P3FkLVKSX9Vq/qrmhJkZfSNrXqUtng1M4CVo0J8mtv
	VfWFoGoOKAdiT7h10KRpaHBmYzgHvEy40r2cPtfC8HGOsoFivdXmq5ReSZYGi3+ewf+yWF
	/h5DbrCjsWHtmCkpH+XtHN3icTuw970=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hRqolI7M;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754980642; a=rsa-sha256;
	cv=none;
	b=XaK3Vxlyyoppl0Chg90tlhaGTQXlhdmgDeQNnzr7JlCliI6itLDm/aV9uOPonBIZSI4Ww0
	II/HS1CwMISB7k1pbsnq2D1fHkeuyS2KDtS8gHyRSwcv3qiNqQkfyGO+lEkzBdRmqLhx9n
	8oWdIWy25o/jaK1Ln2OayGPyrthP8sY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754980641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kYlPhAxHPbIiKQ+onLP18X95rM8NK7n/QL8pKb4oNjI=;
	b=hRqolI7MYhtt89J36fYNnL4qKTpco/bQYLnDlYleWSZm8kOsY+IJ8/m+/o9lPE5gfkRDKP
	Pqkn0/qDvOEDEQPFtpelyjXGHIAHAJd0cSqVUkn9EkBPs5/QNtIuXt2TB4EPkY6PQy+8u8
	AMYQKgK/X7nB8HI9gQwdl8XZHEV6TZo=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-tQvBi3w3NS23GA545hHa0g-1; Tue, 12 Aug 2025 02:37:18 -0400
X-MC-Unique: tQvBi3w3NS23GA545hHa0g-1
X-Mimecast-MFC-AGG-ID: tQvBi3w3NS23GA545hHa0g_1754980637
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-55ba635f0ccso1182366e87.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754980636; x=1755585436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kYlPhAxHPbIiKQ+onLP18X95rM8NK7n/QL8pKb4oNjI=;
        b=O9OS6f4WQ33kfWlJKD4N3UkGbG4RV9tpe+0fSgfF3o5MdnyQumIssXspVTgBrSP7NC
         mFX5Z1rsj1T8WwTXFyzEXcPdrwuKTDqnJc5VEXNTG8eEsiJRAOtY91GjZ2sVnWx08R8q
         GICeYZMal7f7Ossodxn8p/Vy6urOJPh8fsLTxezxg62qic1FcIgpUSBg3+9KDv3vZs9H
         VQ093ov83EPzfSJKX/XaP84Zdeh9EwS3AJehBb52i6u8A2n5XQamra5Iz44biGWaXXf5
         IkXea0PUw+Uaq2dzb9+dy/H9WP2a8TzL7WDRBw/EF3L59wRreZaio/5F0vpSt7nY5frJ
         OrJg==
X-Forwarded-Encrypted: i=1; AJvYcCW5TOOaNeeGYF3aX0000LyUTVKLYx879FPGBDrCb23+uf03h+rzAH+mlbbW/rvCU9cy88qr7AOxSA==@kvack.org
X-Gm-Message-State: AOJu0Yyr4/ispHYDS+WhCAx+WazUbHEArdh0yY8QIWE9WpZVnktZ0WGG
	cK5KDZ42AY1zmu9er3oKtKcTVwxkXnOQBuT3GETwlbzF6iDE+lyGf9mDlFIgBoIJU+k1eyLvrwm
	ilK5q+Z9WtUY9FBYl88eYWTBe1RGbWcBhUM43+EgOQVEtQVWFMu4=
X-Gm-Gg: ASbGncvuTJGVUA0DJy5QecNA2JsoR/anJgipPYxxHtyUQQY4xJsRtUhjuTxf05ppa/1
	A/jSWpXvj5TnrsWKX+U0zfFaAvjaMGt6Qbzt6tPL99dBJB3ARNlVG1+6FT/MgcGQ7CHXmSoESn+
	ll3fHZ7CaGzk1znhYqHV/DOVeTjm2gnkjnhjmw1VgAV4efbJ/Y7rUndPbHU3QlY1zW16xW2+gQE
	qLOgkmWEE9rxmlMp4flPZrildiZbHXA5xx2zkFZf2ZLHwgMvwrE9Kdc66kiI9/uWrIDs9x5+1PY
	ASGz+Qzj6Ov7H7wQOlkNizysGe+J6uWICa3Gc2xvndwPAEDQdngUG8Pp6d+kQpXq9Q==
X-Received: by 2002:a05:6512:1251:b0:55b:96e4:11b5 with SMTP id 2adb3069b0e04-55cd757e083mr523953e87.1.1754980636423;
        Mon, 11 Aug 2025 23:37:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXNE2K2pUXmPGN4LQTjJKHSKCjNyEZFrkeCGn38L7Ho/GPlO7/vj+aA2yfKh3KUDZCVTWeJQ==
X-Received: by 2002:a05:6512:1251:b0:55b:96e4:11b5 with SMTP id 2adb3069b0e04-55cd757e083mr523930e87.1.1754980635871;
        Mon, 11 Aug 2025 23:37:15 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88cb7c4dsm4717429e87.170.2025.08.11.23.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 23:37:15 -0700 (PDT)
Message-ID: <0e116c7e-d276-418d-a8cd-47cdd9f2d00d@redhat.com>
Date: Tue, 12 Aug 2025 09:37:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 03/11] mm/migrate_device: THP migration of zone device pages
To: Matthew Brost <matthew.brost@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
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
 Francois Dugast <francois.dugast@intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-4-balbirs@nvidia.com>
 <81ca37d5-b1ff-46de-8dcc-b222af350c77@redhat.com>
 <aJrW/JUBhdlL2Kur@lstrano-desk.jf.intel.com>
 <3df6fbed-7587-44f5-bd12-29e59ecde123@redhat.com>
 <aJrgJvmyeg7YuOQY@lstrano-desk.jf.intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <aJrgJvmyeg7YuOQY@lstrano-desk.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 94-ggZxbY1pmGvHsUexvDW-xnyNeWiKWk1bv4H_-I6Q_1754980637
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F01644000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: med9r3oa6dh8ueoeqnbwgojtuh9fterg
X-HE-Tag: 1754980641-703660
X-HE-Meta: U2FsdGVkX18sfa7y3+a8Kjny9Qx8QvE06G78j0ctSFHJFnz/2Zr7r7c3FZqNEnhpvJOFAB7/1WI61xE1AOg3oW0Ykl5htkA/lM6ilZe5Vg0sOEjImpcO3EmxL/ItNBsyMBewf3o0hnkmJEdxwQGt063mL/DaFSW5+GHkGOZqgVyRg7QtbxLjrRur0g4dIdAX7wodF8YcmzkwlacHLX/MM/Clhsfs/4Xs/VvnH3GuoeYuVisWXIa5U3g3tXPs+TzmWWqUrH9UMt2pff3+PXzXyFaxwoi74z2ayMEiwtCRyw44yw8hyaLmv7AfrG4udeOTgmFPrPmGDLKpD91Ks8E1+GhE6lEZCPbOI9GgGDt0/KPXkHFofPYwxFVGE78Ng5WfQN+9FIK6R6sJWzy8ZW4o2JtzaU3VF/7DuDDrAnWKI2RJ9AWYbv9fiLbZOJW9ATFGe9uDpjW1uxyGaaTjmfhv577l9cuHpt7yelztau+Q+Onr+64Ew5J4twkkCBStUwiJxJHPsOcch4J98PpGhisz4MhmlRxE2WMBpTODMYp/Wi0UB9cJ6QpmllTGLyOwruBEv2cMiPjb+SAzjkrhxzovGiSbX5pjFNE5Opa33TwPx33MoT/lDckuQ0IqA5OtqlvuLC3vm2ib3z21tteEHzLF1ZBOY/imYqy7to7go7i2mgAVPLaa8Rm2z/4Q2gmd/VRc22TD8WdzuXKQYTi+YbI8q2TT8p+O/alvWmjGYfpMOSDTxndUApRh9ES7KRaWFDmyk0NgWhnaNHRVjzGWRXDUl3k0reAT2u611z8z4zh+UZ9vLObDz1sjloggI3PmAbSP2nMZgDWyfErnfhVWFjTt6E+/lDMvT+ZfT7eeOXdrz9lab9z6npDLjgYbu1EDSGuaaLHcsM/GY+cjd/2ItpfjtyJUZSlGGu6pL/RiM/hKrFfQSBXvGzjMjq2RPpGrpay4rWN8xRWhyT4MPQ826uU
 RsjDXTGk
 T4yzQSzn4ZOpzgX+Cct/5LN2J85ItjRt5LN+3qpf15rMB8dbFnnC0YVisBpos6kYgAspH4lzBZI9dlaUEn0kgjxmG2zb/eFEa7O72/Agp6/JUP7kNfEA/TPijXSQb+FCFxqVsl6Ur8CxbtP8jKAQgCT8gYsNalgQy8m03yH9k9mKUA16PWRuLuhHg+c9iV2cjWIVKnlbGajvavImSP84dxN5mZnV5zy1FCdzruZkUFPkX4xCQhOz45uq9ZPPyDLJknGaXy4b/SP5rRipJ+CyxyN3pdxW26dSK2esWsBDCPGp9gybnEpWI2cRZ745D3nyHQ8TxKYADtilAluQ1P0zCo8z4YMUNTPMr2zBD09PnB2RlGKYhfBnJAzxK1zKHPqePUmW1cnQBsppdNj4wN0wnphR45QzogGzpnEHqiWdeoVfqN8A18MytfwZWq29033BiEMdc4d3EFkEYOSn7TOiWikXJDEp5e9O7KfJqp0HhR/5GrDaTOT1QpTq2+w4ZYZ1M0C2FP5Mkri6JRbPmAL+g8SL/eEN8UIENeNpPMCqSHlNjKuyzIwZcqKhhluU/a+1GvT4ramcMVXo5zBU+MEx1hsdTvxhfVKi61FF2G3i16Z0PVR23RTY8NRymBZEjk5OftLJOkEeraonf0qtLGXD5Kno/nwxhBlxqG08nRnBqblEmR1+h29v0Y77oWa3ZkYTG7Hp3JBd0VSUOLnAs3YH5by4a9cn+sc5QeYGhdjQzvvNoUR2HuCgyHcf9G7SwV+etxAUbq3PAQIZeMjAqpPJ182JEYfCn/Xg/gy9EYGKXyX3IvDAjdukeCRRbMaBtQBOoJiS5OLFZMh8OT5Ru6HSekx6hh7YMeUiJxAtaRga5UFp5CJ3DY/ltxnO8SQaT69fqM/dJh0jvhoLC4woQ2fPlS4EfbTk8yibiD/s/dLhtmc1akIZBRDY5EosjOgaFh0Qbx5TPLXpw/b4RBrqdZdX2DAu7els3
 VuniJu6/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/25 09:33, Matthew Brost wrote:

> On Tue, Aug 12, 2025 at 09:25:29AM +0300, Mika Penttilä wrote:
>> On 8/12/25 08:54, Matthew Brost wrote:
>>
>>> On Tue, Aug 12, 2025 at 08:35:49AM +0300, Mika Penttilä wrote:
>>>> Hi,
>>>>
>>>> On 8/12/25 05:40, Balbir Singh wrote:
>>>>
>>>>> MIGRATE_VMA_SELECT_COMPOUND will be used to select THP pages during
>>>>> migrate_vma_setup() and MIGRATE_PFN_COMPOUND will make migrating
>>>>> device pages as compound pages during device pfn migration.
>>>>>
>>>>> migrate_device code paths go through the collect, setup
>>>>> and finalize phases of migration.
>>>>>
>>>>> The entries in src and dst arrays passed to these functions still
>>>>> remain at a PAGE_SIZE granularity. When a compound page is passed,
>>>>> the first entry has the PFN along with MIGRATE_PFN_COMPOUND
>>>>> and other flags set (MIGRATE_PFN_MIGRATE, MIGRATE_PFN_VALID), the
>>>>> remaining entries (HPAGE_PMD_NR - 1) are filled with 0's. This
>>>>> representation allows for the compound page to be split into smaller
>>>>> page sizes.
>>>>>
>>>>> migrate_vma_collect_hole(), migrate_vma_collect_pmd() are now THP
>>>>> page aware. Two new helper functions migrate_vma_collect_huge_pmd()
>>>>> and migrate_vma_insert_huge_pmd_page() have been added.
>>>>>
>>>>> migrate_vma_collect_huge_pmd() can collect THP pages, but if for
>>>>> some reason this fails, there is fallback support to split the folio
>>>>> and migrate it.
>>>>>
>>>>> migrate_vma_insert_huge_pmd_page() closely follows the logic of
>>>>> migrate_vma_insert_page()
>>>>>
>>>>> Support for splitting pages as needed for migration will follow in
>>>>> later patches in this series.
>>>>>
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>
>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>> ---
>>>>>  include/linux/migrate.h |   2 +
>>>>>  mm/migrate_device.c     | 457 ++++++++++++++++++++++++++++++++++------
>>>>>  2 files changed, 396 insertions(+), 63 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>>>>> index acadd41e0b5c..d9cef0819f91 100644
>>>>> --- a/include/linux/migrate.h
>>>>> +++ b/include/linux/migrate.h
>>>>> @@ -129,6 +129,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>>>>>  #define MIGRATE_PFN_VALID	(1UL << 0)
>>>>>  #define MIGRATE_PFN_MIGRATE	(1UL << 1)
>>>>>  #define MIGRATE_PFN_WRITE	(1UL << 3)
>>>>> +#define MIGRATE_PFN_COMPOUND	(1UL << 4)
>>>>>  #define MIGRATE_PFN_SHIFT	6
>>>>>  
>>>>>  static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
>>>>> @@ -147,6 +148,7 @@ enum migrate_vma_direction {
>>>>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>>>>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>>>>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>>>>> +	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>>>>>  };
>>>>>  
>>>>>  struct migrate_vma {
>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>> index 0ed337f94fcd..6621bba62710 100644
>>>>> --- a/mm/migrate_device.c
>>>>> +++ b/mm/migrate_device.c
>>>>> @@ -14,6 +14,7 @@
>>>>>  #include <linux/pagewalk.h>
>>>>>  #include <linux/rmap.h>
>>>>>  #include <linux/swapops.h>
>>>>> +#include <asm/pgalloc.h>
>>>>>  #include <asm/tlbflush.h>
>>>>>  #include "internal.h"
>>>>>  
>>>>> @@ -44,6 +45,23 @@ static int migrate_vma_collect_hole(unsigned long start,
>>>>>  	if (!vma_is_anonymous(walk->vma))
>>>>>  		return migrate_vma_collect_skip(start, end, walk);
>>>>>  
>>>>> +	if (thp_migration_supported() &&
>>>>> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>>>>> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>>>>> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>>>>> +		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
>>>>> +						MIGRATE_PFN_COMPOUND;
>>>>> +		migrate->dst[migrate->npages] = 0;
>>>>> +		migrate->npages++;
>>>>> +		migrate->cpages++;
>>>>> +
>>>>> +		/*
>>>>> +		 * Collect the remaining entries as holes, in case we
>>>>> +		 * need to split later
>>>>> +		 */
>>>>> +		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
>>>>> +	}
>>>>> +
>>>>>  	for (addr = start; addr < end; addr += PAGE_SIZE) {
>>>>>  		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
>>>>>  		migrate->dst[migrate->npages] = 0;
>>>>> @@ -54,57 +72,151 @@ static int migrate_vma_collect_hole(unsigned long start,
>>>>>  	return 0;
>>>>>  }
>>>>>  
>>>>> -static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>> -				   unsigned long start,
>>>>> -				   unsigned long end,
>>>>> -				   struct mm_walk *walk)
>>>>> +/**
>>>>> + * migrate_vma_collect_huge_pmd - collect THP pages without splitting the
>>>>> + * folio for device private pages.
>>>>> + * @pmdp: pointer to pmd entry
>>>>> + * @start: start address of the range for migration
>>>>> + * @end: end address of the range for migration
>>>>> + * @walk: mm_walk callback structure
>>>>> + *
>>>>> + * Collect the huge pmd entry at @pmdp for migration and set the
>>>>> + * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
>>>>> + * migration will occur at HPAGE_PMD granularity
>>>>> + */
>>>>> +static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>>>>> +					unsigned long end, struct mm_walk *walk,
>>>>> +					struct folio *fault_folio)
>>>>>  {
>>>>> +	struct mm_struct *mm = walk->mm;
>>>>> +	struct folio *folio;
>>>>>  	struct migrate_vma *migrate = walk->private;
>>>>> -	struct folio *fault_folio = migrate->fault_page ?
>>>>> -		page_folio(migrate->fault_page) : NULL;
>>>>> -	struct vm_area_struct *vma = walk->vma;
>>>>> -	struct mm_struct *mm = vma->vm_mm;
>>>>> -	unsigned long addr = start, unmapped = 0;
>>>>>  	spinlock_t *ptl;
>>>>> -	pte_t *ptep;
>>>>> +	swp_entry_t entry;
>>>>> +	int ret;
>>>>> +	unsigned long write = 0;
>>>>>  
>>>>> -again:
>>>>> -	if (pmd_none(*pmdp))
>>>>> +	ptl = pmd_lock(mm, pmdp);
>>>>> +	if (pmd_none(*pmdp)) {
>>>>> +		spin_unlock(ptl);
>>>>>  		return migrate_vma_collect_hole(start, end, -1, walk);
>>>>> +	}
>>>>>  
>>>>>  	if (pmd_trans_huge(*pmdp)) {
>>>>> -		struct folio *folio;
>>>>> -
>>>>> -		ptl = pmd_lock(mm, pmdp);
>>>>> -		if (unlikely(!pmd_trans_huge(*pmdp))) {
>>>>> +		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
>>>>>  			spin_unlock(ptl);
>>>>> -			goto again;
>>>>> +			return migrate_vma_collect_skip(start, end, walk);
>>>>>  		}
>>>>>  
>>>>>  		folio = pmd_folio(*pmdp);
>>>>>  		if (is_huge_zero_folio(folio)) {
>>>>>  			spin_unlock(ptl);
>>>>> -			split_huge_pmd(vma, pmdp, addr);
>>>>> -		} else {
>>>>> -			int ret;
>>>>> +			return migrate_vma_collect_hole(start, end, -1, walk);
>>>>> +		}
>>>>> +		if (pmd_write(*pmdp))
>>>>> +			write = MIGRATE_PFN_WRITE;
>>>>> +	} else if (!pmd_present(*pmdp)) {
>>>>> +		entry = pmd_to_swp_entry(*pmdp);
>>>>> +		folio = pfn_swap_entry_folio(entry);
>>>>> +
>>>>> +		if (!is_device_private_entry(entry) ||
>>>>> +			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
>>>>> +			(folio->pgmap->owner != migrate->pgmap_owner)) {
>>>>> +			spin_unlock(ptl);
>>>>> +			return migrate_vma_collect_skip(start, end, walk);
>>>>> +		}
>>>>>  
>>>>> -			folio_get(folio);
>>>>> +		if (is_migration_entry(entry)) {
>>>>> +			migration_entry_wait_on_locked(entry, ptl);
>>>>>  			spin_unlock(ptl);
>>>>> -			/* FIXME: we don't expect THP for fault_folio */
>>>>> -			if (WARN_ON_ONCE(fault_folio == folio))
>>>>> -				return migrate_vma_collect_skip(start, end,
>>>>> -								walk);
>>>>> -			if (unlikely(!folio_trylock(folio)))
>>>>> -				return migrate_vma_collect_skip(start, end,
>>>>> -								walk);
>>>>> -			ret = split_folio(folio);
>>>>> -			if (fault_folio != folio)
>>>>> -				folio_unlock(folio);
>>>>> -			folio_put(folio);
>>>>> -			if (ret)
>>>>> -				return migrate_vma_collect_skip(start, end,
>>>>> -								walk);
>>>>> +			return -EAGAIN;
>>>>>  		}
>>>>> +
>>>>> +		if (is_writable_device_private_entry(entry))
>>>>> +			write = MIGRATE_PFN_WRITE;
>>>>> +	} else {
>>>>> +		spin_unlock(ptl);
>>>>> +		return -EAGAIN;
>>>>> +	}
>>>>> +
>>>>> +	folio_get(folio);
>>>>> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
>>>>> +		spin_unlock(ptl);
>>>>> +		folio_put(folio);
>>>>> +		return migrate_vma_collect_skip(start, end, walk);
>>>>> +	}
>>>>> +
>>>>> +	if (thp_migration_supported() &&
>>>>> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>>>>> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>>>>> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>>>>> +
>>>>> +		struct page_vma_mapped_walk pvmw = {
>>>>> +			.ptl = ptl,
>>>>> +			.address = start,
>>>>> +			.pmd = pmdp,
>>>>> +			.vma = walk->vma,
>>>>> +		};
>>>>> +
>>>>> +		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
>>>>> +
>>>>> +		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
>>>>> +						| MIGRATE_PFN_MIGRATE
>>>>> +						| MIGRATE_PFN_COMPOUND;
>>>>> +		migrate->dst[migrate->npages++] = 0;
>>>>> +		migrate->cpages++;
>>>>> +		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
>>>>> +		if (ret) {
>>>>> +			migrate->npages--;
>>>>> +			migrate->cpages--;
>>>>> +			migrate->src[migrate->npages] = 0;
>>>>> +			migrate->dst[migrate->npages] = 0;
>>>>> +			goto fallback;
>>>>> +		}
>>>>> +		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
>>>>> +		spin_unlock(ptl);
>>>>> +		return 0;
>>>>> +	}
>>>>> +
>>>>> +fallback:
>>>>> +	spin_unlock(ptl);
>>>>> +	if (!folio_test_large(folio))
>>>>> +		goto done;
>>>>> +	ret = split_folio(folio);
>>>>> +	if (fault_folio != folio)
>>>>> +		folio_unlock(folio);
>>>>> +	folio_put(folio);
>>>>> +	if (ret)
>>>>> +		return migrate_vma_collect_skip(start, end, walk);
>>>>> +	if (pmd_none(pmdp_get_lockless(pmdp)))
>>>>> +		return migrate_vma_collect_hole(start, end, -1, walk);
>>>>> +
>>>>> +done:
>>>>> +	return -ENOENT;
>>>>> +}
>>>>> +
>>>>> +static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>> +				   unsigned long start,
>>>>> +				   unsigned long end,
>>>>> +				   struct mm_walk *walk)
>>>>> +{
>>>>> +	struct migrate_vma *migrate = walk->private;
>>>>> +	struct vm_area_struct *vma = walk->vma;
>>>>> +	struct mm_struct *mm = vma->vm_mm;
>>>>> +	unsigned long addr = start, unmapped = 0;
>>>>> +	spinlock_t *ptl;
>>>>> +	struct folio *fault_folio = migrate->fault_page ?
>>>>> +		page_folio(migrate->fault_page) : NULL;
>>>>> +	pte_t *ptep;
>>>>> +
>>>>> +again:
>>>>> +	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
>>>>> +		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
>>>>> +
>>>>> +		if (ret == -EAGAIN)
>>>>> +			goto again;
>>>>> +		if (ret == 0)
>>>>> +			return 0;
>>>>>  	}
>>>>>  
>>>>>  	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>>>> @@ -222,8 +334,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>>  			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
>>>>>  		}
>>>>>  
>>>>> -		/* FIXME support THP */
>>>>> -		if (!page || !page->mapping || PageTransCompound(page)) {
>>>>> +		if (!page || !page->mapping) {
>>>>>  			mpfn = 0;
>>>>>  			goto next;
>>>>>  		}
>>>>> @@ -394,14 +505,6 @@ static bool migrate_vma_check_page(struct page *page, struct page *fault_page)
>>>>>  	 */
>>>>>  	int extra = 1 + (page == fault_page);
>>>>>  
>>>>> -	/*
>>>>> -	 * FIXME support THP (transparent huge page), it is bit more complex to
>>>>> -	 * check them than regular pages, because they can be mapped with a pmd
>>>>> -	 * or with a pte (split pte mapping).
>>>>> -	 */
>>>>> -	if (folio_test_large(folio))
>>>>> -		return false;
>>>>> -
>>>> You cannot remove this check unless support normal mTHP folios migrate to device, 
>>>> which I think this series doesn't do, but maybe should?
>>>>
>>> Currently, mTHP should be split upon collection, right? The only way a
>>> THP should be collected is if it directly maps to a PMD. If a THP or
>>> mTHP is found in PTEs (i.e., in migrate_vma_collect_pmd outside of
>>> migrate_vma_collect_huge_pmd), it should be split there. I sent this
>>> logic to Balbir privately, but it appears to have been omitted.
>> I think currently if mTHP is found byte PTEs folio just isn't migrated.
> If this is the fault page, you'd just spin forever. IIRC this how it
> popped in my testing. I'll try to follow up with a fixes patch as I have
> bandwidth.

Uh yes indeed that's a bug!

>
>> Yes maybe they should be just split while collected now. Best would of course
> +1 for now.
>
>> to migrate (like as order-0 pages for device) for not to split all mTHPs.
>> And yes maybe this all controlled by different flag.
>>
> +1 for different flag eventually.
>
> Matt
>
>>> I’m quite sure this missing split is actually an upstream bug, but it
>>> has been suppressed by PMDs being split upon device fault. I have a test
>>> that performs a ton of complete mremap—nonsense no one would normally
>>> do, but which should work—that exposed this. I can rebase on this series
>>> and see if the bug appears, or try the same nonsense without the device
>>> faulting first and splitting the pages, to trigger the bug.
>>>
>>> Matt
>>>
>>>> --Mika
>>>>
>> --Mika
>>


