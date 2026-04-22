Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0487F94CDC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBEE26B0088; Wed, 22 Apr 2026 04:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F726B008A; Wed, 22 Apr 2026 04:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DE96B008C; Wed, 22 Apr 2026 04:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFF046B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:14:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 640AF13C848
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:14:48 +0000 (UTC)
X-FDA: 84685480656.22.FE20A77
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id CF2F540008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:14:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WxCk5+DN;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776845686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Bl8Z+WQHqHX+qQjnRU0ICkmrP9C1SwKb8blByh5RwmA=;
	b=DpIpvU3W17w+l02cbK6KGSsItieETGeyXvr1ikHdC3vv0Rua6jTBqjDBW5EjfnxygRAGIP
	1WQw+2sUSYfdoQKJzaAycnq5oNWNqCRD96uTTIjYD2upSEMwZMqk0GMpqXvxnVTtK1f+3v
	XtVoI2zQEiMRLogf4ReNSl61xMXaQ7A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WxCk5+DN;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776845686; a=rsa-sha256;
	cv=none;
	b=lfOe4zCpxZRqyKNZHJWswZyhPzTaSlaZhI5AYcam09ODtc1Dq2EVeYQ0r2WRNRrxSse3Ah
	56eenmra96ArL3KzwRjbSufO4LPaSqG9Cr0rKtaEYN/o0GRjkTdWPw2GjfOC1NpxtvD7yC
	cAdf7QrG+5zdPa3pqkd2x3ZJPIMA9y8=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82748257f5fso3304295b3a.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776845684; x=1777450484; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bl8Z+WQHqHX+qQjnRU0ICkmrP9C1SwKb8blByh5RwmA=;
        b=WxCk5+DNroGo/Lyscdqv27ZkreVsDvuKFvSnPdK94zWX+GIxhHsUVDyuIhlJb47nLy
         S3nnszTt0CIFlvgybyYRSVp8WRul9fW8B+OC4k/KAPDCQaToeU81YPMr05P4Ihow29lQ
         Ipg6/33MWzc2d6aDIuSOoVKYoD5DBOPe2fJ3He+seCcs4LkwitBAwm8bij3T3DZjAVGp
         RUDfDNnydNWa2wLW64t5zJU5jD3JfMIIe2DFXqJt0TaJN9H+YuYd7gMbiLn4b4fhEbB9
         1YskYdzvn0CVnkwPJ4U9z08n5bGh9bCOirEg6x3SsCcVqMITsvesHY8m9P337SywfxY5
         IRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776845684; x=1777450484;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bl8Z+WQHqHX+qQjnRU0ICkmrP9C1SwKb8blByh5RwmA=;
        b=itU6XlarubYPJf0nj76V6CtyCdBzp8IVYYef5oPKBe+oyZW09ev3r2JIt1RW5zQuoD
         /RYFNm1yiBPFTZDA4MDnhnZ5WcGks1zTeih5ecnWn66Ss6q2eiIbVCrArLHAw4I1cMnk
         QJXi+1e1OWxBI6wsAU6w2mxV12UA/7+KVdByl2gZZl5ZocNjOKigGmxzF+PyAV59Oaxp
         pl7jyl2udvw294aottbaXIwpy3jzaqJeT/Whz3ZKQJ8PGI77b++mpAi0kIDa90fYk7A3
         3BKp5Q3DdkPl11iRM/16ZlJ7et9Ig+VkCluhaBrytqBEhDDFe9Dx5ZWYlFg474sCmUKs
         uhlg==
X-Forwarded-Encrypted: i=1; AFNElJ+CKtz2IiBOeZdR/ff3T+Iueyv74Sfxhv6T39+OGWt/y6UHmaVjXOEqeiMRo7f6DOn3aApJGm2Njw==@kvack.org
X-Gm-Message-State: AOJu0Yzx2TAwk99LFBdT979hZ0KCS6k3uZB2IBxppjLazl9oqnGSXEWl
	ms95fu2zfuB/2HspZpqDNHZ7j7rziq61hfbpuvmnLJLdX7WV57nefqKXcj0W2fOqVME=
X-Gm-Gg: AeBDiev94W2IZwD56hg6AA3WgDowe492Zs4q0FAwCffEj/mYzPHU+LQLAB5WWOoeuCI
	3uAwVrStIHyE/3j8+Rl7H2w+/9czbWkyvqYAp19wTjmrPFHGrQjg0Au9I+vff6ydSneyrkwmnLx
	5te+NgunOEwAC7MXIevQifnYeM6NOsNJQ2gGCTLV+dyy1L0eQ0/mqz1fJlBneVINguDhK54kUTq
	+fIeXd4uOTPh6gtIyXZ69kc8Pi8SuLwi4OEZok20NZUKJPeqpop8r9PLV/FwiVq38E7kUiGbsZz
	GlQZmVodMY4HCgBC2TCcIaVXPSiOvqj4+a0uRg/TwIe2vegPTVr+r7EwQLDeEayodgvtlu6YjA1
	7tJbpDzmrFR/uz4mvPnL95+subkxQrFrwC2nXo87YZ3/W6yJR542ZryOTvRvVL2tpK9rwbBH9Kg
	Ko67ESU5A+jkJZbxzT1+2+5A6J4dDS
X-Received: by 2002:a05:6a00:a254:b0:82f:6d4a:df3e with SMTP id d2e1a72fcca58-82f8b32d44emr16671789b3a.5.1776845684472;
        Wed, 22 Apr 2026 01:14:44 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec0307esm16522874b3a.53.2026.04.22.01.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:14:43 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] mm: Fix vmemmap optimization accounting and initialization
Date: Wed, 22 Apr 2026 16:14:15 +0800
Message-Id: <20260422081420.4009847-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF2F540008
X-Stat-Signature: jrh3113pey79kzb9kswj3mckyw4cjuxh
X-Rspam-User: 
X-HE-Tag: 1776845685-391821
X-HE-Meta: U2FsdGVkX1+IoQoX9ijyRrVl2LtgbsUPIht6nhjLhfhsU0WudTqohkYTf3KMw/ihvFk3AZSwWOCA71zlyfwy3ZCUzwaQeDpoTKE2uLRfQDX1FA1olk0E6PJJzpbms5+BJApOjK4R1Td29Tg4gx1c0Gl+ZKSfm8Bqt5jIlETFKjH6VOCW/RpToaJPmuR9fdi3RcXSi6R+pcZoYiBnwPvKIpAMvXT/KIGBTninqSFuhBTQaehkRyvE/av681P6vyHpQgjf7vbrP0ekSAD5WG6COROOrFzP1kmPj31UmJtQluKOXBs1GtTfow7tka4/cII9KsSJYM1Jf58RXFzlwzJAM78rzfU5B9NFE27cwUMUvZHZ/1yViRKkjldkYTIoZE/BlD+0PpFkjXmzWF3FO99a6+kV42KhEnm+tDXJcbXuyK7k1x9dAKld6zJfFqAVQMDjnd+HV59N+rAwqImA2RnOAibHZ6H5OS7PgBRIPQb4bBR2LwG1m8/uZtnGiK9DATYZAgzQgBGUyBtEYkljse0fF/BBF+olgYvRTK87xop5Lz18OhEZdRrtf975n6Oxc7EdtTqHHr/YO80499l8jaJbCt7dhH3JcCjm1J+xObQJkjCsQtPOAccNQ1VoS7+taD3mGwe48A+rmcYsXMCxAx9d8wMfygGYN4s7Ubhojv79JrJt0bNiTJ7ruhsCdtBN8/5SBcud6KNxrINkLdhqS777LDWAQY0obIbrt1beMwCXbyv8nVNvooj2xeYmH4s+r0WipmFWY7MkbOpgRkPx51/T3vGqeEQPGfrG8ikST9gCGfp6hlCTIOWKgKj2PoCr6tAHdQi42B0Jrkm81WoxxYK2Q/A7OSONvzzse+bb7BvRba8o42uETnTkxYWx38z3IoDDCmY7wYd7S0iEgIMlvL0vDVFmIAgVorTQfnZ5oM3SMq1kddEbNVrMYxwmR03Sp8eONnBB0A3iT5wxpLrkcYK
 CTnOoLQx
 ltEUdPjopnHhgHcC06DaTCsKn8lZVi1BCUgJOYBH1tCuRXWt9Ra6NTGs2MIzxQ9Akb0jEbUXhwTzvuo/S4UR5u3wOucBb4CrBUUbqLtTOA0lZWltgCszUQ9IV3WjDDodfCe8LqEALEcxZh/KrVJ697295eSmS7D4uB9sQiyW73fn+lwVDusFdQygrgNr/Rxn7UXnz1qPajRG+bwQgOjaaKZTm7ZoNuVIycLp1HthdmI5hCaM5wB+Ef5E+fapqWXgw+l5QQhAhsb0qNsrBWXoDlJmDjdV11I2iOXVfGmxO+zURZ+LVij8VYfcNeXaF/g90e25juYOtUVx46eI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The series fixes several bugs in vmemmap optimization, mainly around
incorrect page accounting and memmap initialization in DAX and memory
hotplug paths. It also fixes pageblock migratetype initialization and
struct page initialization for ZONE_DEVICE compound pages.

The first three patches fix vmemmap accounting issues. The first patch
fixes an accounting underflow in the section activation failure path.
The second patch passes pgmap through memory deactivation paths so the
teardown side can determine whether vmemmap optimization was in effect.
The third patch uses that information to account the optimized DAX
vmemmap size correctly.

The last two patches fix initialization issues in mm/mm_init. One makes
sure all pageblocks in ZONE_DEVICE compound pages get their migratetype
initialized. The other fixes a case where DAX memory hotplug reuses an
unoptimized early-section memmap while compound_nr_pages() still assumes
vmemmap optimization, leaving tail struct pages uninitialized.

v3 -> v4:
- Collect Acked-by and Reviewed-by tags from Oscar Salvador.
- Fix the build issue reported by Sashiko.
- Add a fix for uninitialized struct pages for ZONE_DEVICE, based on
  analysis from Sashiko and verified locally.

Muchun Song (5):
  mm/sparse-vmemmap: Fix vmemmap accounting underflow
  mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
  mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
  mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
  mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE

 arch/arm64/mm/mmu.c            |  5 +--
 arch/loongarch/mm/init.c       |  5 +--
 arch/powerpc/mm/mem.c          |  5 +--
 arch/riscv/mm/init.c           |  5 +--
 arch/s390/mm/init.c            |  5 +--
 arch/x86/mm/init_64.c          |  5 +--
 include/linux/memory_hotplug.h |  8 +++--
 mm/memory_hotplug.c            | 13 ++++----
 mm/memremap.c                  |  4 +--
 mm/mm_init.c                   | 58 +++++++++++++++++++++++-----------
 mm/sparse-vmemmap.c            | 56 ++++++++++++++++++++++++--------
 11 files changed, 114 insertions(+), 55 deletions(-)

-- 
2.20.1


