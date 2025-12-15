Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DFD4D5B86F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BD956B008C; Mon, 15 Dec 2025 16:17:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E576B0092; Mon, 15 Dec 2025 16:17:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E74B6B0093; Mon, 15 Dec 2025 16:17:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5116B008C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE9B9588B3
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:15 +0000 (UTC)
X-FDA: 84222966030.13.4ED48BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1EE6A120013
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fXREHl3G;
	spf=pass (imf29.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBWmZRlwxYLUkN3nMvZH7vuWHOobDOQMbI5q/HfKJHo=;
	b=DeAFTGYs/v2cuUwk/bc4ehQ4QLg4BSMs5dXkQsjAmhg0ktPKlNxLRbtDotPhkKTW1F82l0
	08+wErFxDb3eZEffv+0T4ikqYSYAVgbi8WBI0ybGV37DTNf2bXUBLcxlpQI9ZyjYVv3xCg
	pWXhzuBiVyiZhjZQW/dRADWhr/yQ0hQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fXREHl3G;
	spf=pass (imf29.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833434; a=rsa-sha256;
	cv=none;
	b=5uXSrED5Ba+tAQvBtU2nyc6xfvCCPkhPsePBz8Vax9xZAerzEsh7OIgxhS+N6zOHojZLF0
	olq+ElM3NieISoHv7tRpw18oGSFfwrpSFuRx0GxomxpczBtnnMhBy+81UT1gOzM6PO+oTj
	Xp0Nb9tv1/mlCaMMutEa8Om0QjLC/a0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uBWmZRlwxYLUkN3nMvZH7vuWHOobDOQMbI5q/HfKJHo=;
	b=fXREHl3GykYDZ1TEMapESDezg7fiPECAk/ye0lHJaUtLYlAtJuyXRUQthGdbW3AG9nyLjC
	4asA7qINbwA5v1tX/xxkuelWcnyW1d8D2DzieY9dup6w80UyHDMqk1l5GIVt40IbyBYCHe
	k5mSczrmQVnvoU0tMn/ISjzKk54MhjQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-407-KOGv_7rUOSSmqMJug95OxA-1; Mon,
 15 Dec 2025 16:17:10 -0500
X-MC-Unique: KOGv_7rUOSSmqMJug95OxA-1
X-Mimecast-MFC-AGG-ID: KOGv_7rUOSSmqMJug95OxA_1765833429
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A19AD1956061;
	Mon, 15 Dec 2025 21:17:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 798AB1955F21;
	Mon, 15 Dec 2025 21:17:07 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 02/11] mm: introduce pgtable_has_pmd_leaves()
Date: Mon, 15 Dec 2025 16:16:44 -0500
Message-ID: <49e5272a3fb756d1ffee0e4308bc9fa42fcdb81e.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam02
X-Stat-Signature: fkhusy97w8w3x916frpow3186f8zxaji
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EE6A120013
X-HE-Tag: 1765833433-441163
X-HE-Meta: U2FsdGVkX19q9CKFTiIMqzz68niyV7gz69ADJj1RDqUnlt6zau3R4t33sntlQD89oebamIhIrTEmPo1peojQOysX5LqYqqir70ZOSl40a2GitR6R4nWKDbE7qRS3xf7rmK3rb8nNpu2rsN0IYPZSxRfgjQttstqbYy7O/NDrUxi/KtEX9aU+75bIk9BhWun4qYcQKjiuaEuO5Gc5hvBbz1Pi5oYzw5pMzb1SJFZNJWGAq5t0S1xTeokUoqB/kGGYDEsWOvkGFOpDbUP5gVZNBy99zjqcfBAdUXJpN8ZYg/z6BRJfR2s3iHw+00K1SBGikkpYCg+eUEcOHpS1BHG8+3Yp3+sCBQAtaPOmpkALdnAayw3pjGsJboUau9BhqVVcyRL+FBsuHsCZHQ/v1IKqLChU3SBY28WUdyS45IyeLN2+lgDvW+HadcJZSl/Mwzq302DoKTblfQfXpgMK66e70r/x0xzu9N3wjt0z4Oi7vOW6pPY/qii/K6vlMDdmqX4kGvzqo/CPbWvLYHodxeJkhVtqRCRwzvsyLPC0nwYVYeLfH5pNcJriw5apD3LDhvMY2H1BMH3ju4e5OeUoHnf/hgOE+lNRVgxReCq9/HHqgi2P0UgNc3Cvzj14Ih6IiMjh4LxRoKhBsM5gmGBpzrieYoTZchMMF9OCWudr4wTOOhFHQNPPGlhqHf4vHksHUBDpbLqiiYsogEAT8Um/5EZjiGfhf+DO+ArNI98Si4sarigqqzJkyQZXWvEpXs2Uyv5w8XYVYVy15SiRfn8K1S+nMUlmKTP8TBxii9CXGNnUGqRovqANUPyoirGujvi3slmTLciIuGJ3bvAO0DTd6162Q3N2p2/WxjgxLfbsQMPGPscD65+vzyrMcog+N6BrCdxVE8BemPBOPgs5DzAsJg46+TSzr2VYC52z39IimB9Y1hKcNZMaDV1x3Vh19Vj94xW3j7V6jIEa5wu/0HyzEL9
 CbvDkD3E
 isLkrMpykWAWNgtr8etkNBv/0Cojbu4OSFqDZQpHwD9eqJ3ZXp65WLTAbUFkhvREM9UPbPool04lYlA54Bb4Qy3G/4rjta+uOII/WvrFrwbn7l3xnQ1WWSSPpaZLVA4e4Hl/GLxkgYPYevYwEoJemmMtsKLojrAnkZjsxBEor+wTbi32BsvIKeka+Zbrdcv3fZ1coge6V38FwgZGEflIxM00vjzPacuCsulYNBr+Hgm0QaG4kF/vKBG94CV4Y/ifT0aobGcYYoGsczGFDS118lVEfS9yOKriZk/x7Vc6tSnTKHMfz5ueg7y9zfOZYcj47PoVG52807Vs5ibaL66WuXos58roVYYncHhCiV/pYFCZ8fjAOLyVACTEeQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, we have two helpers that check for PMD-sized pages but have
different names and slightly different semantics:

- has_transparent_hugepages(): the name suggests it checks if THP is
  enabled, but it actually checks if the CPU supports PMD-sized pages.
  It may perform a hardware check, so it can't be used in fast paths

- thp_disabled_by_hw(): the name suggests it checks if THP is disabled
  by the hardware, but it just returns a cached value acquired with
  has_transparent_hugepages(). This way, this helper can be called from
  fast paths

This commit introduces a new helper called pgtable_has_pmd_leaves()
which is intended to replace both has_transparent_hugepages() and
thp_disable_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
it returns true if the CPU supports PMD-sized pages and false otherwise.
It always returns a cached value, so it can be used in fast paths.

The new helper requires an initialization step that needs to be
performed very early during boot because there are
pgtable_has_pmd_leaves() users that want to call it from __setup()
handlers. This initialization is performed by init_arch_has_pmd_leaves(),
called early from start_kernel().

The next commits will convert users of both has_transparent_hugepages()
and thp_disabled_by_hw() to pgtable_has_pmd_leaves().

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/pgtable.h | 7 +++++++
 init/main.c             | 1 +
 mm/memory.c             | 8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 652f287c1ef6..6733f90a1da4 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2017,6 +2017,13 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
+extern bool __arch_has_pmd_leaves;
+static inline bool pgtable_has_pmd_leaves(void)
+{
+	return __arch_has_pmd_leaves;
+}
+void __init init_arch_has_pmd_leaves(void);
+
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
diff --git a/init/main.c b/init/main.c
index b84818ad9685..ad1209fffcde 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1036,6 +1036,7 @@ void start_kernel(void)
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 	early_numa_node_init();
 	boot_cpu_hotplug_init();
+	init_arch_has_pmd_leaves();
 
 	print_kernel_cmdline(saved_command_line);
 	/* parameters may set static keys */
diff --git a/mm/memory.c b/mm/memory.c
index 2a55edc48a65..79bd59d5243f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -177,6 +177,14 @@ static int __init init_zero_pfn(void)
 }
 early_initcall(init_zero_pfn);
 
+bool __arch_has_pmd_leaves __read_mostly;
+EXPORT_SYMBOL(__arch_has_pmd_leaves);
+
+void __init init_arch_has_pmd_leaves(void)
+{
+	__arch_has_pmd_leaves = has_transparent_hugepage();
+}
+
 void mm_trace_rss_stat(struct mm_struct *mm, int member)
 {
 	trace_rss_stat(mm, member);
-- 
2.52.0


