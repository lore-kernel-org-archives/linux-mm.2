Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E6D2CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237076B00A0; Wed, 27 May 2026 07:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7B16B00A1; Wed, 27 May 2026 07:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF8F6B00A2; Wed, 27 May 2026 07:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1BD56B00A0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B604B1A0586
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:10 +0000 (UTC)
X-FDA: 84812925540.06.8256C0E
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8324AC0007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="d/GWnyKh";
	spf=pass (imf28.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/70JID062V814TY2TOyw8EA5k2YWRj4Olo6OZJNrik=;
	b=JzYmXxixKHlloTDPX7LvG1R7+Ly8fL7LT46LlozqdqVgslly/GfEtC2xvomauLtyMtM6+K
	LH0wMmmd9y4Rz4E3XbnNC8n9NeTuzI+t0iTFewPoChgroPoGxMdViKVpQgxhMXsYvMOZds
	poOAVf9GzpvCYjhxrXujfYp96G5KuzM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="d/GWnyKh";
	spf=pass (imf28.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880089; a=rsa-sha256;
	cv=none;
	b=4Q39yumCVORNUxTHlKiZK39n99n1qAy8idlQTgrx2LqhDhFaWzbZgCrTeKWyeuwD+m5SUp
	eWBHe0CQtDYvh+8qzDLEZvMVPoaVW1Utol7EzIaRFvtc76iqQbeknw3XfvP0v8WQVUGk0M
	KFBngUHhphAhsLfDjlT6T0IWFGbmscI=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=q/70JID062V814TY2TOyw8EA5k2YWRj4Olo6OZJNrik=;
	b=d/GWnyKhP5OdN/FwoZeN58jllQS4j1OQ9Opo/3nlNKj09J/EjFx9D5jk0CvFygD3nYmcdbfbp
	rCI6J2aiagXzUJlZApf+pFo0AMnJgoLif70IBWoHv3Wl5EA1H/AHwuhSuappH6oOZxlRXMsTTnK
	kMH6ECTvISsLQzWBCPTWAFo=
Received: from TW002-1.hihonor.com (unknown [10.72.0.137])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gQRdj3h0vzYl1Gk;
	Wed, 27 May 2026 19:06:49 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW002-1.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:04 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:03 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 15/15] mm: enable CONFIG_ANON_VMA_LAZY on arm64 and x86_64
Date: Wed, 27 May 2026 19:01:47 +0800
Message-ID: <20260527110147.17815-16-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Stat-Signature: sth8w3etyd7atuaj67sa1wzekyg54qhb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8324AC0007
X-HE-Tag: 1779880088-31517
X-HE-Meta: U2FsdGVkX19BLAl4bTAkR72v+RWSrCyV+urWq0Aatzh+4j70bu9+uQxOiA6jXvYT5UtC3BWgNwmnHRruwXnyuZQrctOIzHEsP1W9W4QjQ1F+C/hkNeul5Q778v8TgfeIXjTsPhNdrFTAg4YS4U+QyDuPyo5138l0qgQsViontOzjZY1i/WE2NFsU/MG/3nUMa4xy3TJTws2zVE7GmYtuod+36E9kZBZ5d5lug1DgRbVUxiOQ/F+UBEO4i3c53dvsssCk1XsFvum0YCXjCqZQMaTRyfkvddl9b57M8/urQCo1Aak1vljuq0Zh2JlTK9zQ8bxR/HKsvobu91/HvshaKOm9tgtsbUwvd4bz6eFauF/OsQsy70cGKdldgkxDjnO27fy+Gm1eEe0HCj40/fljOlxnbCc1Oc2r/HremYxqwcbaDqCaeAr1mO6+H6+APrH7yQ0uNn9cIqGkEQHYLsyQUiA9Oj4QaBs8a4Ld+MeFQzdrddF7Bm/1b6CZ/Gt2saUwW340+q77ltpWKvDWZhXUrfPtR7jT0sJlQBhdmNiG5rwZTKkal30ayhMRE+fxRN7R/eUmARqxCRxhZJ+Zm1l76Gh5N9LMOwuYql4z8ESiqzAKwn5sO/JosHvHjoXt1nDUt9tO/ond19WbJuWeam37W2uuA3QBMAJzcVAttjYJvhmHAc7H0py1M2w+tDpAvWLlh43N45/4qDo1VJPJ/LsxEsJln8e6fNpO6ChjntJV+++ov/EyQxsJlnbG5FxEvP/WpxAviba98+ROAQZOEsV6zRWsMtDu5h8xlLkBAD4z9dLjXjtZStFbC17rJmFaXSrGXcrfBAH7q6e6YAMp+Lslio+6qsHwcjSyPvBWR1QTz7UkIjIKiBB2siL3MXzG1jHOVcT+suLLOnkUvU7/kfpqZsD9zWknUA5PfRA3NXqzZpVa9TRlMf6o+aOjHwekQGqBC2gd6ZrlPwawomuwhHQ
 PvnpmK4y
 nzoW26SJ16yv2luUURDpW4MZYuixJsT9zCumBS6RAXE9ZCfEN4+BcAWCdo3jCuYm7cGr/zCaQgWqRBT6Oc+oKOBbGnAmWIAez4mskyg0DHpgcCt/Rs1ALl3PokX1G9vMGITW7ij9a6+oyj9p/4iAqleuzDCBdd87xSKn425/lAX5ZO3FN8USggZgqsWv0t8vXyo8QI8soiXhU4TI8hZWidVotBPUE4F0xDSyqjWgUCx88jUGf5twsHBe3QA3xX6B9puJJlUpZBTJEw0VHuIYN4OMuNxnt8qeMR2zgrARZeEqXhx4QZCQAI3O6h8OyJJMQzlI09oJZDJSxDcA4cm8CODxcXKDVCKPY9+awOj8djEcFDDOqQee6+TnqIRDJTCjtyGNx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All prerequisites are in place, so enable CONFIG_ANON_VMA_LAZY for
arm64 and x86_64.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 arch/arm64/Kconfig | 1 +
 arch/x86/Kconfig   | 1 +
 mm/rmap.c          | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943..9517883f0aaf 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -81,6 +81,7 @@ config ARM64
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
+	select ARCH_SUPPORTS_ANON_VMA_LAZY
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SCHED_SMT
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f3f7cb01d69d..cc3430eaa7b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86_64
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_PER_VMA_LOCK
+	select ARCH_SUPPORTS_ANON_VMA_LAZY
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_SOFT_DIRTY
 	select MODULES_USE_ELF_RELA
diff --git a/mm/rmap.c b/mm/rmap.c
index e14509b47412..77e2ab95671a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -168,7 +168,7 @@ static struct kmem_cache *anon_vma_chain_cachep;
  *        covering both regular anon_vma and lazy anon_vma mappings.
  */
 
-bool anon_vma_lazy_enable;
+bool anon_vma_lazy_enable = true;
 #endif
 
 static inline struct anon_vma *anon_vma_alloc(void)
-- 
2.17.1


