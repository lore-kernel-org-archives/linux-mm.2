Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F14C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE6E8E00C5; Tue, 12 Aug 2025 01:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6638E00BE; Tue, 12 Aug 2025 01:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDBBB8E00C5; Tue, 12 Aug 2025 01:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD3BE8E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:36:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 389BE160159
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:36:01 +0000 (UTC)
X-FDA: 83766994122.02.50F522E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id AEEAE4000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:35:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J9NTYfxx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754976959; a=rsa-sha256;
	cv=none;
	b=0rfYOjZXDog8WujU6vCc1jJP8mepEwknSB4pIB8V7hwbxLOFo2zWI8zvF5mkAlQiKZ6bXC
	CmSPuxXkp7GKdQISSaVbIswVnyIHlzuzw1DRR+sdV9gheFMW/VEg5uYkIN5IX0+pGoNA57
	HLOFp8FlPt2QalwD8bgRD49KzXE5Y2w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J9NTYfxx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754976959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HK1aGMXOxQraZ3WR6/QuCjAtP/UzwHLH972ALD6RPk=;
	b=Mt8tGD/qk7DZjVugP43WVc8ISiy6li3b+Jq8TSbyglIaiQwen7uz/WI7yC/s899Ymi2HeY
	fxtWiD+Y8c+PDt5Pmkq4KEMdeVVKEDqePjwOtnSmMPlE1z6RO50f0NPSegSLe4dLShlxru
	DwsbWGdKKYqJvkVMkE43sLAqCJDIaEg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754976958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+HK1aGMXOxQraZ3WR6/QuCjAtP/UzwHLH972ALD6RPk=;
	b=J9NTYfxxp4hQqdT9jKGgMlhGUiab9vizGo/euS4BCNQ0iP5XPBpxFKiO6DYmTHGvh4mVNr
	UQBmpiJlEJhlKXJQ8HBSMWLEUKEpcC0tzxDb4znAjq6Oa1I4AWG/0Zxpp4ueYtRZiQ6d1o
	tphIirDPVByIN6KgCREmHQXpHrjIlgk=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-1ppxU1iDN2OEq5GQXNET4A-1; Tue, 12 Aug 2025 01:35:53 -0400
X-MC-Unique: 1ppxU1iDN2OEq5GQXNET4A-1
X-Mimecast-MFC-AGG-ID: 1ppxU1iDN2OEq5GQXNET4A_1754976952
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55b861d06d4so1996169e87.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 22:35:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754976952; x=1755581752;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+HK1aGMXOxQraZ3WR6/QuCjAtP/UzwHLH972ALD6RPk=;
        b=a1bjumMMFOOWSf+/+HMaMJKTiAoJgl2nuNBZUghxh5W/LzblKePUZtHW//lhGm62ok
         I6LnQiqe60Yd1zFyfYmDZh8RNBR2klFL4LzSCgWabH3rDFHEVGPxcFNaXSgOFBvLo8rw
         nbpRrLt/wsjwTOZY/kJL3sGOHmUwEoRvrp9D2GZRQCN6H00sffoOyqVaZpQPHsaN47vZ
         132oT5u79if5Q08nxC7AiJOfMfWq76HnbCbwSzBId8xtuBasB678q0uacIncRyYXTQXO
         a0AulAEWy+XHPvdfGvgDEwoZT1P2ckytKQWdWA/cPDOlii+kcNvGWE6RhHWdj5qJKZBO
         Dsrw==
X-Forwarded-Encrypted: i=1; AJvYcCXMVqST5zFC2odouaWXqmYVDgrMByuQNzFPlAVzRZwGfZL7T/Dqw6j6e+iKJwrQy7+Jw5CWuOCRGg==@kvack.org
X-Gm-Message-State: AOJu0YwUqV+INpIcqsV1PbGkrNTtAqZVzm6v6jlVRmsjQ0LTBKUM+fOb
	itm0olhF5Mm377ZWES6+oV0Z2W1dToRsZimu7OJGL4ubl1fZpWT0tP1LpGy3B6NGWzBmEbQn4z1
	qUueOmQLm2PH+bTheTvqnR6IjC/34HJIl5X/dU6eMVBGf+fFvRB0=
X-Gm-Gg: ASbGnctbDps5bnuH1/ka216trwms5SEVneljLFX5WoWOw0oYiTLjKRgO5MvclB8mdpr
	1sAPMtOG2+PN5cfOKiH0oNlR7TnR3OobXLWPXZHD/R2BBgrwgRZOQM5zo3V3kjWyefcItf9Ys8c
	aWJDF7IN6YCZsRmtGSWrUjVqxgeQBK9Ef9bNtmvXsn/PKZmHFchQ8gTCX5aXMnjhD+pFBnkUN1t
	5X60l+fZT2owDa5n7ZVZF1jgRB5ukNcbnPHMU+D8JUqvlKZW8/pdd7r8ed36MDz7fVEJkLC2VGI
	CDKCItDWH1QjWW/MrbJRjX/YzZ0HdHo/fd4l8V+EEFu+lVah4h/94RkI4gxFZBMxTg==
X-Received: by 2002:a05:6512:e86:b0:55a:4c3a:b122 with SMTP id 2adb3069b0e04-55cd8c109cdmr541577e87.10.1754976952109;
        Mon, 11 Aug 2025 22:35:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoiBCdQDgAPLdc9mYi2nhz8mzpqDm1DftNE1ohp1+HyEI1M3tjFqiiZy3jbdNo8Jn3YvWg5A==
X-Received: by 2002:a05:6512:e86:b0:55a:4c3a:b122 with SMTP id 2adb3069b0e04-55cd8c109cdmr541555e87.10.1754976951633;
        Mon, 11 Aug 2025 22:35:51 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b9fc2a13csm3565415e87.132.2025.08.11.22.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 22:35:50 -0700 (PDT)
Message-ID: <81ca37d5-b1ff-46de-8dcc-b222af350c77@redhat.com>
Date: Tue, 12 Aug 2025 08:35:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 03/11] mm/migrate_device: THP migration of zone device pages
To: Balbir Singh <balbirs@nvidia.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-4-balbirs@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250812024036.690064-4-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 219YBwVJhwopTG2GFN8ZDlLo3Ks-14eSf3sTBJBrUgY_1754976952
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xcj1uupms4o6gu1qstqm9hbsgeyg55gb
X-Rspam-User: 
X-Rspamd-Queue-Id: AEEAE4000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1754976958-300888
X-HE-Meta: U2FsdGVkX181LCMCSfzFkoUnDjn4aqFK6egPFgOJQaD2V0K3N5BNdEohHnoUAAPewhzM200TtTv06KWdyXRrdVWv1YlBBvyqKKNViF3Nj0oeZwnBOzFxRLVGz9RL6LHIH6hR4VGQ+381c0civKRrRJ5W8OK+lER/eVXzjhAqwwxfnUqO4y7eQvEZ/QMHewmfRIY24JttsahmQ6w1PfOF0S1gClCOPCTAFbxgQyVSasJBATDd3EFVeWw+j85FvqJqFS8uN/lvqGkGpaZ0DHsodOoL2xiyRn5qtQMisYjh/gaP/RRLdngfBPaSsj3eEMg1l/sKL9MSkVPuBcn0zwxvF93UFowm5Ix1WoGC/nhOsoG5V3HCo5pxWdaF6LnlvBbvSs81GQexfsoSCzJ2eOsoRqkQ4DcsQL0x5xYmsc+AU/a0mbCBqjSba9us2XiUXezfRQuupi6UQsdxBicJzY0w5/qLCKpIVWMW1VXhCbVIqcKSQsvSpZEQkowY4j38pfMiSlD90Ox6ASWEAiRc6NR6rImtuqJoNrnRBiTSrEhumXRIsxl2wg3tD25VsU6ZCVlR/+ToeaJpEOeECZ0qSVWL5dMiQ58Y/Kyp4zJKW5TsV+bceAy7/aSjCRpkz5p8WfVhYVbFh0WftK25ewwrNLn0pRpGs/JvNAvbYMas3SDeVrDCXbh5hjqp0Mqw7/DLicz8RwcaJ3q35uUVL9q9XqAJ5O3XQOy8A3oGUoVlip7VWlIKNv0dQFnwaRVDFoOhIP+OC6TCJ9IeVrqciXp67x4FYqS6+sa5lDBoBauCcwjiSvctnyVxlApspcsyKU3ExuL6LFFXqdm+jj0785OQ0S6XAedGANXJCe+11dM9sEjrCyExVOSoimiIgFM6CHcrhZxfYy5Tejlc8tVnjmL71LG6grIoW524jrhszg8RBCQ6TY1hN+4yprKIR2YbmsuNBmjsIjePCvCSmtkCEMqHpCr
 IlFam2Qg
 gJSUAcM/93ggsn5DpNznDBo8LUtdWtKiCXWEhXj0583mEVn/9QdFJZwiowoXfM/FZ1SlsV6jjlMGbXzalCgo9L5ZUG+0ChL+7qAAByZpasmY898HkcvSbgteJEySrpkaY2yHJuMKojif3AYJA8MaMzOMg7oT94XOlGLsPdxnri+sEyNX1i1bT54rVJCuVGe8gsmkHHDJInS5/tVF9yzqd0oiPs4Czi4CiJI44RicX1Xi2skCCdtc+hf2L5C/eL1zFSWKSB6VyZqPgZWuAKVLHFg1WjWpSU/lWEqJTyi9UUyBWL6KYWN1lW7aeHkBc7QPSMeFX24ZPjcOY92vG29ECXdwd6nLcvSvNLp2ejWyXhDhBI12w4OHI/gRcBcv0H1P2VP+lR0y7Mr2Y6lA1CSLMdipjtp52fv6WCCYv5prBugb/+YgTP0TQOwsRZE6xOIvds3cYNBdj/v40gXLN1tmuovX99WJsiHuDR/pCaY5UBbpMIRMN1cRqFuVEvIMu4W8AI2lZmPI3UpEVm32fI5lW6SfRq/9xIe1Ek5pn5Jmxeohj5MJnKmTggF4yUVb4ULxw/8exTfky4toMoRp4r95e77himna+hsffvXntuGZcCgVoJrOYnvw0Brp5H6Lobx8OGMB8CPGesXgAdvzohQGzvXGaqCgLdBYzGFNxwvCCU5W6RXgzZ0bCjpFaQ9le3NzXL01IqnKFYckHeASsgy/X9XU3s4ryHsn/xdA2KBBZKMJQe3QeqaV012e+CfEXg0rs5ix6cWl9RqfEt4DsZpHyKp3KxgRi9CLs3w3zyddzOrFIB1CzwriDe+ZfokjZnA0Q7yNgIAEiNM2keP0SmHMnyLOH1A7Ioy3dOUtoliTwQ/OGqfaKzIwn6R3xuaTxrBIQq6tsQGxTBgY0m3dx4PVfLDz/qfH4uge9SCT6qzoe1+DU9zusJzArWwOA5EEbwQMJEPOuVmV6jLTkEChRlb2YeJQOFfF3
 QukOB6ZG
 TKQaUvzEZvbPMHKyzi4lXzdHx7h/P1S8bS6tx9jvTVJwfY3lMdjeXxvnwqys0YzYb0JYjUxe2vAkZ3D+Koe0L2QM/PXL+K24
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/12/25 05:40, Balbir Singh wrote:

> MIGRATE_VMA_SELECT_COMPOUND will be used to select THP pages during
> migrate_vma_setup() and MIGRATE_PFN_COMPOUND will make migrating
> device pages as compound pages during device pfn migration.
>
> migrate_device code paths go through the collect, setup
> and finalize phases of migration.
>
> The entries in src and dst arrays passed to these functions still
> remain at a PAGE_SIZE granularity. When a compound page is passed,
> the first entry has the PFN along with MIGRATE_PFN_COMPOUND
> and other flags set (MIGRATE_PFN_MIGRATE, MIGRATE_PFN_VALID), the
> remaining entries (HPAGE_PMD_NR - 1) are filled with 0's. This
> representation allows for the compound page to be split into smaller
> page sizes.
>
> migrate_vma_collect_hole(), migrate_vma_collect_pmd() are now THP
> page aware. Two new helper functions migrate_vma_collect_huge_pmd()
> and migrate_vma_insert_huge_pmd_page() have been added.
>
> migrate_vma_collect_huge_pmd() can collect THP pages, but if for
> some reason this fails, there is fallback support to split the folio
> and migrate it.
>
> migrate_vma_insert_huge_pmd_page() closely follows the logic of
> migrate_vma_insert_page()
>
> Support for splitting pages as needed for migration will follow in
> later patches in this series.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  include/linux/migrate.h |   2 +
>  mm/migrate_device.c     | 457 ++++++++++++++++++++++++++++++++++------
>  2 files changed, 396 insertions(+), 63 deletions(-)
>
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index acadd41e0b5c..d9cef0819f91 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -129,6 +129,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>  #define MIGRATE_PFN_VALID	(1UL << 0)
>  #define MIGRATE_PFN_MIGRATE	(1UL << 1)
>  #define MIGRATE_PFN_WRITE	(1UL << 3)
> +#define MIGRATE_PFN_COMPOUND	(1UL << 4)
>  #define MIGRATE_PFN_SHIFT	6
>  
>  static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
> @@ -147,6 +148,7 @@ enum migrate_vma_direction {
>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
> +	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>  };
>  
>  struct migrate_vma {
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 0ed337f94fcd..6621bba62710 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -14,6 +14,7 @@
>  #include <linux/pagewalk.h>
>  #include <linux/rmap.h>
>  #include <linux/swapops.h>
> +#include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>  #include "internal.h"
>  
> @@ -44,6 +45,23 @@ static int migrate_vma_collect_hole(unsigned long start,
>  	if (!vma_is_anonymous(walk->vma))
>  		return migrate_vma_collect_skip(start, end, walk);
>  
> +	if (thp_migration_supported() &&
> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
> +		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
> +						MIGRATE_PFN_COMPOUND;
> +		migrate->dst[migrate->npages] = 0;
> +		migrate->npages++;
> +		migrate->cpages++;
> +
> +		/*
> +		 * Collect the remaining entries as holes, in case we
> +		 * need to split later
> +		 */
> +		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
> +	}
> +
>  	for (addr = start; addr < end; addr += PAGE_SIZE) {
>  		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
>  		migrate->dst[migrate->npages] = 0;
> @@ -54,57 +72,151 @@ static int migrate_vma_collect_hole(unsigned long start,
>  	return 0;
>  }
>  
> -static int migrate_vma_collect_pmd(pmd_t *pmdp,
> -				   unsigned long start,
> -				   unsigned long end,
> -				   struct mm_walk *walk)
> +/**
> + * migrate_vma_collect_huge_pmd - collect THP pages without splitting the
> + * folio for device private pages.
> + * @pmdp: pointer to pmd entry
> + * @start: start address of the range for migration
> + * @end: end address of the range for migration
> + * @walk: mm_walk callback structure
> + *
> + * Collect the huge pmd entry at @pmdp for migration and set the
> + * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
> + * migration will occur at HPAGE_PMD granularity
> + */
> +static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
> +					unsigned long end, struct mm_walk *walk,
> +					struct folio *fault_folio)
>  {
> +	struct mm_struct *mm = walk->mm;
> +	struct folio *folio;
>  	struct migrate_vma *migrate = walk->private;
> -	struct folio *fault_folio = migrate->fault_page ?
> -		page_folio(migrate->fault_page) : NULL;
> -	struct vm_area_struct *vma = walk->vma;
> -	struct mm_struct *mm = vma->vm_mm;
> -	unsigned long addr = start, unmapped = 0;
>  	spinlock_t *ptl;
> -	pte_t *ptep;
> +	swp_entry_t entry;
> +	int ret;
> +	unsigned long write = 0;
>  
> -again:
> -	if (pmd_none(*pmdp))
> +	ptl = pmd_lock(mm, pmdp);
> +	if (pmd_none(*pmdp)) {
> +		spin_unlock(ptl);
>  		return migrate_vma_collect_hole(start, end, -1, walk);
> +	}
>  
>  	if (pmd_trans_huge(*pmdp)) {
> -		struct folio *folio;
> -
> -		ptl = pmd_lock(mm, pmdp);
> -		if (unlikely(!pmd_trans_huge(*pmdp))) {
> +		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
>  			spin_unlock(ptl);
> -			goto again;
> +			return migrate_vma_collect_skip(start, end, walk);
>  		}
>  
>  		folio = pmd_folio(*pmdp);
>  		if (is_huge_zero_folio(folio)) {
>  			spin_unlock(ptl);
> -			split_huge_pmd(vma, pmdp, addr);
> -		} else {
> -			int ret;
> +			return migrate_vma_collect_hole(start, end, -1, walk);
> +		}
> +		if (pmd_write(*pmdp))
> +			write = MIGRATE_PFN_WRITE;
> +	} else if (!pmd_present(*pmdp)) {
> +		entry = pmd_to_swp_entry(*pmdp);
> +		folio = pfn_swap_entry_folio(entry);
> +
> +		if (!is_device_private_entry(entry) ||
> +			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
> +			(folio->pgmap->owner != migrate->pgmap_owner)) {
> +			spin_unlock(ptl);
> +			return migrate_vma_collect_skip(start, end, walk);
> +		}
>  
> -			folio_get(folio);
> +		if (is_migration_entry(entry)) {
> +			migration_entry_wait_on_locked(entry, ptl);
>  			spin_unlock(ptl);
> -			/* FIXME: we don't expect THP for fault_folio */
> -			if (WARN_ON_ONCE(fault_folio == folio))
> -				return migrate_vma_collect_skip(start, end,
> -								walk);
> -			if (unlikely(!folio_trylock(folio)))
> -				return migrate_vma_collect_skip(start, end,
> -								walk);
> -			ret = split_folio(folio);
> -			if (fault_folio != folio)
> -				folio_unlock(folio);
> -			folio_put(folio);
> -			if (ret)
> -				return migrate_vma_collect_skip(start, end,
> -								walk);
> +			return -EAGAIN;
>  		}
> +
> +		if (is_writable_device_private_entry(entry))
> +			write = MIGRATE_PFN_WRITE;
> +	} else {
> +		spin_unlock(ptl);
> +		return -EAGAIN;
> +	}
> +
> +	folio_get(folio);
> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
> +		spin_unlock(ptl);
> +		folio_put(folio);
> +		return migrate_vma_collect_skip(start, end, walk);
> +	}
> +
> +	if (thp_migration_supported() &&
> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
> +
> +		struct page_vma_mapped_walk pvmw = {
> +			.ptl = ptl,
> +			.address = start,
> +			.pmd = pmdp,
> +			.vma = walk->vma,
> +		};
> +
> +		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
> +
> +		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
> +						| MIGRATE_PFN_MIGRATE
> +						| MIGRATE_PFN_COMPOUND;
> +		migrate->dst[migrate->npages++] = 0;
> +		migrate->cpages++;
> +		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
> +		if (ret) {
> +			migrate->npages--;
> +			migrate->cpages--;
> +			migrate->src[migrate->npages] = 0;
> +			migrate->dst[migrate->npages] = 0;
> +			goto fallback;
> +		}
> +		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
> +		spin_unlock(ptl);
> +		return 0;
> +	}
> +
> +fallback:
> +	spin_unlock(ptl);
> +	if (!folio_test_large(folio))
> +		goto done;
> +	ret = split_folio(folio);
> +	if (fault_folio != folio)
> +		folio_unlock(folio);
> +	folio_put(folio);
> +	if (ret)
> +		return migrate_vma_collect_skip(start, end, walk);
> +	if (pmd_none(pmdp_get_lockless(pmdp)))
> +		return migrate_vma_collect_hole(start, end, -1, walk);
> +
> +done:
> +	return -ENOENT;
> +}
> +
> +static int migrate_vma_collect_pmd(pmd_t *pmdp,
> +				   unsigned long start,
> +				   unsigned long end,
> +				   struct mm_walk *walk)
> +{
> +	struct migrate_vma *migrate = walk->private;
> +	struct vm_area_struct *vma = walk->vma;
> +	struct mm_struct *mm = vma->vm_mm;
> +	unsigned long addr = start, unmapped = 0;
> +	spinlock_t *ptl;
> +	struct folio *fault_folio = migrate->fault_page ?
> +		page_folio(migrate->fault_page) : NULL;
> +	pte_t *ptep;
> +
> +again:
> +	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
> +		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
> +
> +		if (ret == -EAGAIN)
> +			goto again;
> +		if (ret == 0)
> +			return 0;
>  	}
>  
>  	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> @@ -222,8 +334,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
>  		}
>  
> -		/* FIXME support THP */
> -		if (!page || !page->mapping || PageTransCompound(page)) {
> +		if (!page || !page->mapping) {
>  			mpfn = 0;
>  			goto next;
>  		}
> @@ -394,14 +505,6 @@ static bool migrate_vma_check_page(struct page *page, struct page *fault_page)
>  	 */
>  	int extra = 1 + (page == fault_page);
>  
> -	/*
> -	 * FIXME support THP (transparent huge page), it is bit more complex to
> -	 * check them than regular pages, because they can be mapped with a pmd
> -	 * or with a pte (split pte mapping).
> -	 */
> -	if (folio_test_large(folio))
> -		return false;
> -

You cannot remove this check unless support normal mTHP folios migrate to device, 
which I think this series doesn't do, but maybe should?

--Mika


