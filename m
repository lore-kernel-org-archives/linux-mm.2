Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31626CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40F206B00A1; Mon, 22 Jun 2026 06:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC866B00A2; Mon, 22 Jun 2026 06:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA546B00A3; Mon, 22 Jun 2026 06:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2B226B00A1
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:02:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6486C166FE0
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:02:00 +0000 (UTC)
X-FDA: 84907107600.04.E572817
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8B3C118000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=goDaQIqx;
	spf=pass (imf06.hostedemail.com: domain of 3FAg5aggKCGEI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3FAg5aggKCGEI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122518;
	b=earHgb7NDdXcCGAfdOwEMga3+pUf1nf2l/VYX60YP+OZC64oCHiCzV9rLnkCIwYYN4kV/U
	EUAyjIIpUBQ3IbejqyKYGrRmA9F/8/iRgqNyy5OyKdXdMFimdprJjHtjV7qtjr/4OML5PB
	bPCao2gSNMO7A7i9yH/cFt7x31hK+ng=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=goDaQIqx;
	spf=pass (imf06.hostedemail.com: domain of 3FAg5aggKCGEI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3FAg5aggKCGEI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AO5lqlMnd9mItpXQ83kdKJUoYx9mwrmKGw5gn5aBMIM=;
	b=A5Ui0QT2zKAz1Dov+Z2PiDCZReIpJIih030hlr1AQTfP4hLHkhimgT9N0wx455bZqXtZgD
	y8XsJncauV+UWWTON/O44tKtfge5ejggi23mz+cMQlfUiCx1IcFtD5B9Ek6SasKNmmHjYE
	hbK/JwbbxywGkfezhPc/dWAgWKatl/E=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490afe64f26so17227145e9.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122517; x=1782727317; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AO5lqlMnd9mItpXQ83kdKJUoYx9mwrmKGw5gn5aBMIM=;
        b=goDaQIqxkFYfNtaKHwfGi7TJL4TAX3hG7vy3ZBWH7CRfTGSvGF6I2DudSX32AP2jtk
         dTNbqcZHaWIkWLeoSfAkK9SRt7ACvZORSa/4v7buoDc9fVJygLg20qTfcncrkPg01XlG
         5Asz2HhmLFo8ebiXTJ38ERXUjx7Vtf/2M4Fi175N//S2zflEGcKRBkKJx/Du8qfPeWVy
         vOc6KLxevRfVMbnl5TYSA3QvnRGfMvbQLvW0/SnPaFrjethfGYzYPwWjs0yq8Vu2qpyL
         QQyE4R+AojV7hf3n4gXmgbsaRVpWzn13VBifb88stjnpAKWnmnGv8qv5L7qqMffQ1H0n
         5Zuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122517; x=1782727317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AO5lqlMnd9mItpXQ83kdKJUoYx9mwrmKGw5gn5aBMIM=;
        b=Rij1VrRPNn/go/0J/aM16JzUubCJ3QYoYvHnTIxjU5ic7PYlUIt0qBJCrG57WouG55
         CsfIMa/tc2Jl6/t/C3RcPh2gm30u/h4uy7A+n2PxUPTXYWbY9lhHPhWXK2ysUXCBcoF8
         iGH4NcCgMTwDtptqPXsW7bamD2G0VsNbsB32f6YwyEXD1PkJEq10XiT9e+MNQyIG2X0O
         nxlOukUvDebPGYjhTktjDNEaH8Jntgyx2rLMDVId4uDk9fSXK2KIt8OFL0S9VrrtjA+Z
         kP8Cmq2r9t9VTIY1HzAH3IPkI/Tjux9i84ZttB6OwIKICWnO262NgOsA4eKiy/4FQHSQ
         1bCQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ZC+9+9nBRHqFQ4acgfp9yPuW8E7UEtw7nRkS7P1DycLe0CtQ9OEm2MC8aeLkhtQLm5ZnTimaSAg==@kvack.org
X-Gm-Message-State: AOJu0Yzq5M0oXSJ21tHswb+HfWTsi37zzsyo67jxBTJlTUB3cf3Dr3xP
	uaX6QA6lHi9lS6xqVs0TR+DWVAl/KEPkZGN1nsCzcX2FTy0/QfXdhzWd778I+/4tRkRfCSZ9j7Q
	nymFM2cLkrBA1+g==
X-Received: from wmbjt3.prod.google.com ([2002:a05:600c:5683:b0:490:b6a8:96fa])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:4448:20b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-49240a09f71mr144939135e9.6.1782122516674;
 Mon, 22 Jun 2026 03:01:56 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:38 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-11-31f31367d420@google.com>
Subject: [PATCH v2 11/13] alloc_tag: Move to mm/
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 7ktcjmuuqasxmm6gd67t3bpiwoj36u8d
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8B3C118000A
X-HE-Tag: 1782122518-610447
X-HE-Meta: U2FsdGVkX1934m/FtEwl+DB+FlUh7YZGvY9anr/GMLOuCSYnXlFkAbpERawz9Ujkw6oY+HoGaL7MQoGB32tVqqITeIEdXSyAd/NCYZCsdgRECXDeU9SWZhFKQuRZj/iJWDOKBDsQfUf9j9GNjfHfKcBmLDsreXT9/SqcEnsOILU8S8NvlfXfqILFBIg3oOgCzixgidssIosd3N/LPa3hYZCE1uN/jLAGj2GpHwaZZhVXpSEp293i1/m681qMWmV9ZXaTzTytNlvDngux19TWlhDBV1MP98+NQFwRAhPjEQ3LNkx9H5NYHCxKhPv82aYRUXOWmblLMisDNxiSC3KgGcdEowjX2E4L1ddUiklmaRjTv6tx1ftmzGLU8wAVz1M/2tscWbevjyr7pFHdLsq+bNilWLwBvIDvcIYUUDtnIMDLTpv57fl23yoC4fnPoKlvv25/kEl3QayXqDIBnFhf/VHMsj7wKG5c/br+ryRBiQs3eGZocSSIZ5acfIa+ABtoimOEHe5e2aY/X9G6xVo1kHUdShJBlKJkawlGLSFDv7/xDoduiXnLy4dAQENsMbLeCzm0Xt2DkzUYjeu7CcpvXs0LmmVxPuumolSo6cP/+bdzuLuBEYLEJ70gsdaX044g52hpJUFPM7n3Ck/TtdSjDDCWM61ZGzoNxvDNVX3rM8buR6y2oNp1RWR1PAWkbaX+swRXuHTFeytJlUwcTyUcCYzEPV/6kvF6qMpxaYUk0uo16rJf3GvT46vMmH4pJPMYO2AIWSOBpNNPp7wzEfh3Xr5I2KK2mQpowTeQc3OgtGEENV2vfjOPOhg50Se1kvXxk3/OG60fadA9a12+WhL8xsJTUYWmlAeqwDu+5NOM/WxSmJBcqTkXkk7t4tTHlOG4FpY0fB25uKh6bFPf2tYyPodPryJBmQQtwSdk4l/pmdW3DHvaeiUAKZp92J03hp38m6lranP3x77IwVYC+j4
 VW4izlPt
 xFlR3fQc8vCgGYFDDHzI+TQs+bbLLYKPzQd9+OJyquO0PpaQcbv0AGICYYCzKzQJVlArFdxYfJ0bJ+f1ZxpIy3lJZhZMX0QoNW6JPHPvFb0KLjdmdEXARjpNIVkptwrMlSPePtD2xyH3NT51RyZn12AINPri46HQjJ4Uw8ybDMq+HCtNZLxpBWEtA2x/aa1OoMk2V4zX5hRaUmC0lHTvdgwfagIWTzqhUNnWWJmAIdZX3el5x7SO8/kWfzIOFMaW62iiD79ZvIQuXtdy96C6YMUenUK3MEeHWDasuZ7tStYEMPokxJtxiPZdCofDWUN7SwQQs636SowDW3f2E/zDkc4pcBQDC+wyoTgPkpQT2bGHDYXdmsSzjiKJDpt4a5Q3ZXqnPR3erWrZ+gAQNbt4GkYDfaPTIQx6RqejYaidgdY8+hau21f6mxs3nJ5izx6WGyWtTS2YxShrGYDcKGZba5dhamVxq4w6OmBeLYXLoXqzRTzHPE3VEOi1RYhCASZkNwFOh3uMEUMXqhYxbXsGxxzABsqpivbFNpy0Whi83Si9MvB7IIvaxzHqOraAWucSADKygnHHOjA1bsiEP8/lz1c2nH6pLu1MeaQaeunz27JE0PIbni/FSXuKCghHP1dAGkeWPUJm4oWlv5iEkMB16S5lQ2P9cM0LrEBZ1IPjYtGEakNlt5IY+1iZeM8Dj71biTT0h63onGL7RZMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is logically mm code. Moving to mm/ allows access to mm/internal.h

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 MAINTAINERS             | 2 +-
 lib/Makefile            | 1 -
 mm/Makefile             | 1 +
 {lib => mm}/alloc_tag.c | 0
 4 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 65bd4328fe056..5d426b79b8fe7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16713,7 +16713,7 @@ S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
 F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
-F:	lib/alloc_tag.c
+F:	mm/alloc_tag.c
 
 MEMORY CONTROLLER DRIVERS
 M:	Krzysztof Kozlowski <krzk@kernel.org>
diff --git a/lib/Makefile b/lib/Makefile
index f33a24bf1c19a..44f6538533a97 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -197,7 +197,6 @@ obj-$(CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT) += \
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 
 obj-$(CONFIG_CODE_TAGGING) += codetag.o
-obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061c..4fc713867b9bd 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
diff --git a/lib/alloc_tag.c b/mm/alloc_tag.c
similarity index 100%
rename from lib/alloc_tag.c
rename to mm/alloc_tag.c

-- 
2.54.0


