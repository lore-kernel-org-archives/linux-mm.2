Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E4FD60A2613
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=HpIiIPwp
Received: by kanga.kvack.org (Postfix)
	id AFFB36B05F3; Tue, 27 Oct 2026 03:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB04D6B05F5; Tue, 27 Oct 2026 03:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EEA66B05F6; Tue, 27 Oct 2026 03:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ED9F6B05F3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:35:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 096DB140928
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:35:56 +0000 (UTC)
X-FDA: 85367597112.05.CB753E7
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 309A8180004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:35:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HpIiIPwp;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf24.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAleu3PFDaaloUL3fp9TR8UUZq+CL8OXKyhY9njoszw=;
	b=mytJ5hLsXD3RfJT1/EulCwErpq4V5fl350HC20lX7TgwoUeX//9Kf9Y68SMZI8hnIZ2y6l
	AVL5vvHBABT1sQYdD49kWwwyisHVgeiXVB1twQYMhOrAWe1YHV3yFllhsuE4622ECqvnVe
	IAaBv1H/MHImMU0U2dWWE7+T2Gad8XA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HpIiIPwp;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf24.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086554;
	b=I9jkqPQOcZlPir7Ivm6Es9O0aJdJlgkzSfsYlle4tLbbREHh2UPGv+GbQLj8bMODyHS7hd
	epF6ETGYoG+kVZBr4kwY6MzCroLuz6ituNKm504LvnucTdY5BPW2mgX0N8WaUWLHnu1AvI
	6H+puTw6djwRDkVwtKYwPQ4KY2iiloM=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so2528867a12.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793086553; x=1793691353; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=aAleu3PFDaaloUL3fp9TR8UUZq+CL8OXKyhY9njoszw=;
        b=HpIiIPwpWDVvm0Bx7t/liMROfT8DuYAO3yn4xVHY1axh1RW/poEHO7V7RkBf1ACrp+
         jrTuhC0uIuf5wTQLPRIIxr9wlAlAE97t4c9xOTL701KAzDg74f4sIZM7qLB5ppvAmGOl
         cZcCLqw0t1Ol+sSeepvQ+RwWDfc6otGygrtBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793086553; x=1793691353;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aAleu3PFDaaloUL3fp9TR8UUZq+CL8OXKyhY9njoszw=;
        b=iKwEgQVNlc65KoDBIR6v6sgxHSCMLhAaXlfb0mmoTr8Qf+ZrS8T5EUpHyCS65B1NHt
         Y5zcu4VYlymPqjpceJeY2Z89fF2eUawyXFTlIQvQ6VZHx+5rCugCxYlWd+N4jfgM3LvB
         evtGnrGwnqEN8KNniuI6tBeMRpLib9qnjPdgrWeRA5HR1eFGzd/LMBg3X8cnY7eGze9f
         vE3ldtz2k1e6H1kp0xdrsMowzKRh9uIm9zz5JhsA+6f2tyiNQeRmtfczJKUGj3gPEV3A
         /zRVEgf8NmlsunGcVV8V5Q65CqXxbccBaFL8rav1amh655WuYgh77lpag3wMx/r3KJ/2
         xHrQ==
X-Forwarded-Encrypted: i=1; AKwUvBwtSewNiuKlIYUOXqcZJi4Ab/aJK3+1Rc4uV/WiZI+4y+SNE24P8V4XW9D6CZoq05E/RmEy2SkVRA==@kvack.org
X-Gm-Message-State: AFq9FYJoCoWZ96a9vbgYaDAjOj8OuGpx9XShJ/StPvIOtumbHi3ORGCd
	2InxcqVB/2BT4VCuU371YbGoG4U8qphCgEXQ0Jq19NcwTqXnYAafCQvVInyoYgII3W8=
X-Gm-Gg: AYBFou3pUhGIJ2gIWU7EMwVwoZWXV7GpcMXPV9KDUwMe/Ns5aMFcewAXvnqfVvy80DH
	gu9lc/gXR7KAwnrFEEsZfBWZkWb3IGaxP1q+0yEods3xmez93EtOCIxe5ovuiX14RTpaY81wMaG
	cxrF8iwng2+41sxcI2crLB68pM6O9Q5fPgYUjVKtINx/YJ3Fsv2z0JePY8pTbzXrBxOdSM4JqGz
	N53d2tDbliOCNgl4xw0DiLib5Yg1Pkr3LLVP0qrvz7pv+itZpGRxjNYx6Jy3SALcxubhJmGkEnL
	iwjdqb4fnR/u0dsjuvYfpugsljndG3mvYZB2vnGU8HDXzWoEgflsh/kkMscYmDrEm1u7NEhowUW
	BGZlD7AIyg7ReSlda+Bip+FRLsjG2N5a/Fw12G2czKhXX6xnpTJNeKJVN336Fyg7dTU3xnNnkTp
	X2oiqkwQfGOHrX4f6BTMR3VCcry+elmepHcI0BxEz6UJk3Rb/OmYKqWBi1FcWtakJr5RBRzFTGK
	r2lWs2ME5u1GBBmdNSQszSlOMtUZnE6TQNfnS9k7aCYZZSTj69bO/NFKnEdf1FAdId5v9TWfMYH
	/I1Qk+5k4a4m3N82LiV0XlJgXy/NUMxha1NJmjd31Uzccnhdo22WEOfsaiV/zZ6n9sQr6uk1rZw
	n8N3aWHdrlzN5t/COgMxlmjo=
X-Received: by 2002:a17:90b:1652:b0:3a7:82ef:bcdd with SMTP id 98e67ed59e1d1-3adead4f65fmr8276505a91.41.1793086553098;
        Tue, 27 Oct 2026 00:35:53 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae406506c2sm2520384a91.14.2026.10.27.00.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:35:52 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:35:49 +0800
From: Chris Down <chris@chrisdown.name>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH 3/8] mm/slub: Support disabling freelist randomisation at boot
Message-ID: <58f32032f0f5f3828322780aca1847f1cd80cef0.1793086056.git.chris@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793086056.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: 309A8180004
X-Stat-Signature: nkdc4xwkuhh54s8hrnm93obdxozjpkzo
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793086554-525573
X-HE-Meta: U2FsdGVkX19kZ/qBKTXLwvFLehJPDOka8oHvgFahFDxMTJOnIkFzgq7qYzGpBkWQdynWUgC2eDX01QCISdHCbsfZq/q1UZa2gRjW9VpooO5Mf2mftcMy1ur+f9/CdqExijd+32c/5JGoa7sgRrWmHnwBnBSWRPqccwIlRrEOOnOecX85nyCOVitzi0d0g92FTu6TrM47SczBr58KJK8tfcri143SG1QmX8RTrkoq09o6l2cx8pJw4sqlP5USmKOIql+Zreik3bYZfOyOhupHlDe5JYSyZt+z6xCXwvu3WTo299Rs0K13QekSL4Y5S4wZjyKkXKjTLD77/TuHYe8/KiPr77O1HpGBJimYfc5jUGAQteahPYQm3A2PGV3G4fcjA4SpzQ4IhtwxoJNukkOywCPCbUJuji1qw+iCxnItlzV9FiGNEbe3uYFj54TZAyIP2gHehZ6U68YzuDjDVsscVLgpk7a73DNFgxVnU4TIvr9L4HXetb/8Rv3SaXNUH6L0jvYyC+IfrDlk7iqihED9QglJNweSwn/stvSu0hEnhs9s8pX7yJSsA9beTDSF7qNbTO1vjmlau9crPBJLm2SKQAFuR77l3aE55dZZQkOW8a6JYqiFX4rC5cFA3oDGYxIVC/8AOUe4cPmm/XMeR+qmKVds1OmDrf8XJyu8LlLzHXlzdLv+lECw6mn7ql8ixCkFaG1ZCiAvv12RDJtwKangz1DNovYMWjRxt761MG0TnupopsZWqEjdWisgZxPY8c4R4j4fYC7aZlfycXiX5l+0LhRyuzhYBMptfHRQB9eo8McnoatcCpBNU9moFadrLDRGydql67bDamsgCGtCCyx+YzexXTeZ47kvFeSz1KtFSqgowHU0m/vVmW9kl2Jc1qh7TZURt6jjhRBW6oe27MBz6IGLrwzpE8X7MQ4jm3fgoEhONWTS2/a/69rAATFlwxPgfpmCRbE8VMs0jbWUcVP
 bqh2gLjH
 TVrMlrVLdEC/TaAcgu3NCn2Oi5mQTf0qUw8ALB+B+rn401betSBau4BqZCQ2j84Jity90bF4Ern34mpYGPqqIyMYZ7CwEwRs+iG6X4ffbbslPmtOiDd22vtg87+JgVVAajMit0a8sM6QEHZRAnrkJPi53nzpUyDnaTtH9m/0TcfeWEC40R5bt/hb0odkEAintdYgVeTsW9r36/ddZsHG4Qq8+ccc74jJz3BInDpaKJ0SwIC4o7I3Z13DQ6gUC8ZyZfvQQMGXwHZFlM1XMbXZAbUbPKb6rAK85Oyrf0rVaCr85P/UdiUh8aVHmj7dy0n/2QY8bY16pHssR/HIpIOSzciFRyoQ+twpwSGoNLCULOJ345YSZ4bQN6J+O2O1juiJnTsRBqKNx6bDwn3mB2F4ut+ebMr4Wayx7AT0Vuh6LPyepkxUAUDZXxAt46ugP9Pq406G4TxIl4DQ/kB/T62ARJ961ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a slab_freelist_random= early parameter, enabled by default on
kernels built with CONFIG_SLAB_FREELIST_RANDOM=y.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 Documentation/admin-guide/kernel-parameters.txt |  7 +++++++
 mm/Kconfig                                      |  3 +++
 mm/slub.c                                       | 16 ++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index ddf2f6fd60be..5c4d784e7786 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7021,6 +7021,13 @@ Kernel parameters
 			without that option.
 			Default: on.
 
+	slab_freelist_random= [MM,EARLY]
+			Format: <bool>
+			Enable or disable slab freelist randomisation on
+			kernels built with CONFIG_SLAB_FREELIST_RANDOM=y.
+			Ignored without that option.
+			Default: on.
+
 	slab_max_order= [MM]
 			Determines the maximum allowed order for slabs.
 			A high setting may cause OOMs due to memory
diff --git a/mm/Kconfig b/mm/Kconfig
index 3ae97fec9946..56c422684b44 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -205,6 +205,9 @@ config SLAB_FREELIST_RANDOM
 	  security feature reduces the predictability of the kernel slab
 	  allocator against heap overflows.
 
+	  The randomisation is enabled by default and can be disabled at
+	  boot with "slab_freelist_random=0".
+
 config SLAB_FREELIST_HARDENED
 	bool "Harden slab freelist metadata"
 	depends on !SLUB_TINY
diff --git a/mm/slub.c b/mm/slub.c
index de4937fcb293..7e9dadda3d10 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3424,12 +3424,23 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 }
 
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
+static bool slab_freelist_random __ro_after_init = true;
+
+static int __init setup_slab_freelist_random(char *str)
+{
+	return kstrtobool(str, &slab_freelist_random);
+}
+early_param("slab_freelist_random", setup_slab_freelist_random);
+
 /* Pre-initialize the random sequence cache */
 static int init_cache_random_seq(struct kmem_cache *s)
 {
 	unsigned int count = oo_objects(s->oo);
 	int err;
 
+	if (!slab_freelist_random)
+		return 0;
+
 	/* Bailout if already initialised */
 	if (s->random_seq)
 		return 0;
@@ -3456,6 +3467,11 @@ static void __init init_freelist_randomization(void)
 {
 	struct kmem_cache *s;
 
+	if (!slab_freelist_random) {
+		pr_info("SLUB: freelist randomisation disabled\n");
+		return;
+	}
+
 	mutex_lock(&slab_mutex);
 
 	list_for_each_entry(s, &slab_caches, list)
-- 
2.54.0


