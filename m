Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E731606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=B8xZ54cB
Received: by kanga.kvack.org (Postfix)
	id 7CC1C6B05F7; Tue, 27 Oct 2026 03:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3906B05F9; Tue, 27 Oct 2026 03:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DFBB6B05FA; Tue, 27 Oct 2026 03:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44D186B05F7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:36:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3737120972
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:36:07 +0000 (UTC)
X-FDA: 85367597574.02.B088719
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id DFFFA140005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:36:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=B8xZ54cB;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.169 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TeuNf51TxMDPa7xvpxS6POY5MbCscFG1kBCUI4jUNC8=;
	b=I4q7VU3OBTnsC/A0e3JbrDI+Zwowk3Bd3+iYZEUItwdP0wBV1AdmHwXeSs8WwoAVhFTd1f
	IzhmZ2QFz8pRBWomKMYDOwE46kRjBTmv3ZyqFsSNq2OTgpc6JVAEDJ4D60jCr+3ht7BkuA
	LxpD3FEfZ5wbfSJ9cPP3y9E3UpSAphc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=B8xZ54cB;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.169 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086565;
	b=ILVGmhNdnNmhwSqiZoIXxvfRYb3xBKpMbavqHFstx2MJQs+KIzDwBFR/9/7Hp/FSCRpPTf
	9eK+7RLI3hGmJ/O2Q7cUtcO+1byDOkH5zDj0vatg4hyw41Uftt4HHWzCkZipohHe3T0kc5
	diBc/5lJSff+tctBFtIqHsPdwwNb/4A=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e9e53d011eso26473435ad.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793086565; x=1793691365; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TeuNf51TxMDPa7xvpxS6POY5MbCscFG1kBCUI4jUNC8=;
        b=B8xZ54cBQX/IfBY8tHaogP1PDk7FNtr6SAr15AAl3CKnqy2fU3eQNDf0r/s71ILppv
         B/CifMcEtAICPBxXyxpmf82NuNJ6PSVQ9Jg82qjUv/Rm6zODySBmI3Uvvio5JHF3U0kE
         +JtCb1WwwMpb8/YJWIwV1WSTOOG+yTv24Sd8A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793086565; x=1793691365;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TeuNf51TxMDPa7xvpxS6POY5MbCscFG1kBCUI4jUNC8=;
        b=WedGTi1iYuSuzP18I9SMRLlfg4OQfHoVUvKoeef8M2/ylTZLNB8YtF4uJPcZq4fA36
         TUCN+aKYANjqGXRgPapw7zIsQmtCRNtOj301e8xPTS+SmALtjYU6rpnk0VEeih7HjSwZ
         p8OuOQMs3v7klZ6zofv1pmVFTxd/N2qWQjsnnQ6GnfRhh/zemB0jdCzRwY6QjNAtXJIh
         PhD9LGKx8O0okQu8r20gTJhSBF7OziqEbDPoRKbD9WukCewdTEOw9HBx80R7gw9Lf+m8
         2ukB1/TGSHmOGeASqDRT2K4aNXSxwY2cQpXojx2eeHvPmgoGtP1T4nhJGOY5ThwqpNJ2
         4a/g==
X-Forwarded-Encrypted: i=1; AKwUvBwO/oLbss4PaUdciSCWpBvksTKCEUJn2uZEYwHBBUWuFcM1GKWPmg6tFVaXiN1yw/oa1zWZfohIew==@kvack.org
X-Gm-Message-State: AFq9FYJ2Cg20QNXYlYbAHlBWRLHXk53C9yLoOb/CScNtC6PVtl6h6UnT
	3/NesIX7SpEkh5z3Jk1HQ6paeBIevi4TWt0uqalMOiDEoklPHBtADxM0N5tJJKg0kGk=
X-Gm-Gg: AYBFou1wKjqZt7rsxFiIdFeGcBGWOH1loGDUwSQsxK/cyDGnvK+rRYon27Gb3NYAKT5
	lTxEF8PYtxHIPbx38tB2wPssIWZTdquOL6Kf8k0PdvqLrdl2v7kG6l1FiexhYmmH0Ld9Tv6SMSO
	JBdvOefCdl32KOJ93q55efp0vweDya+/Fm6PTXB93q936ODwOUorDG7sEWdtIq95LvWxAVr7bPD
	/lwMBDYExpV4Lc+/njRKCjeDaDxGdeo+FdxNpO9rx3vs8yLa2WDUiANnxTF4O8SGSw6mCZssvCy
	ZbBuFQrw1xVO/YAByFRkxBXa/IAo5hDaAlvj019Gh9QS98Z8TA1XJu3Xhn50Y1KQQg+W+av2S6b
	11GM/AMFK1PHgA0H1IoV6hAJZmHVr4Q0R5t8pMc0BNdwJrTDHAqo10MhivLk6o882CWHZJINW6j
	zEOBNxC43yexqPGjaHyK7glD+7pPnME98/OvkggNvarEpTttqEe7Aj+mpd3iAFk3XDOtnLh9w0y
	GXdctOHWfqZacq7a2N1zFxEZXlsqzGIfWWZaDyO5zue9mxa39Z2BSxHbdBy/tvIFvloVlrLd3yl
	8xZJ9g/HTZB/AvS0HD7ooJosn+YiCACenJMlpdZ7htHX8n2be3Jl69ywycscbRgn+YH78ryrtH4
	s6HjYTO3hf5wkRzwg84jUIW8=
X-Received: by 2002:a17:902:cccf:b0:2e3:598:75b8 with SMTP id d9443c01a7336-2ea9c67507bmr74148095ad.27.1793086564825;
        Tue, 27 Oct 2026 00:36:04 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6ce5912sm5015185ad.71.2026.10.27.00.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:36:04 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:35:59 +0800
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
Subject: [PATCH 5/8] mm/slab: Support disabling SLAB_BUCKETS at boot
Message-ID: <11c73e97a9a8a2a532b3637c290657f99dd6a69f.1793086056.git.chris@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793086056.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: DFFFA140005
X-Stat-Signature: 8tsxa65rapewah4o5mgazsk5pfjop9yp
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793086565-306656
X-HE-Meta: U2FsdGVkX19Ro+V6iHCTymg/sG1BE7hjknaIGRdnWgiNMqalNNJcFiL1MR3tIXYRjzOWcV4SEjM8NJHQX0NVAnU27h347kQcSPrNJdU/56RK4JMN9y+i6M7wCc0B8h9o+roZX866RJcYeMx96iqnKv/qpIlRv8ZUlP3EDNgfYTgaMC2QqzDvKrDQJsTGkjUONjuI+9z9NVFA5bh5XtJFHgDYacmSQunJ8e2QXmDAbC4OhXUYfOSLPem06jvv5JPnJ0Veb2ROhHRhPF3j4CXWGW2vZHQPoJJNomcK/Ox5mhMoL9UhLaMSXfnDvm1tDtt71SPMekZwUdX/cEHm3oKvQ6SZ5gRs6qVEOdYGxQl1km5d2GhsROfRvvm9k5CkbA4c0ZRGNUWWCdVs/IgaglpLf+htCnDaJneY6ISM9LiovkNnt0Srn+xrbaHJxISby2YmNTORdYI91TBC2AQjs7GtE8N03d99zhB9chI/+KdlxMciZXNvseFnNeLfvDDaE7zJ5nv7UsD17UeKSTlKyDLQYb3gG4hfpb4vI/m5g1JeX+uSfWCZUiAnF9xMPV5k14R2C6HcjEgQZgAvnXvC/VP7rdHqRcIqfN6JbMVlFlga0cau3iMa/UFQ8wo1ZmsWTw33nrcZNUuAGhGQVUmMLimNYa1at01XxwNQIw+fHUpppyy8F6awJ+/rq2Xz4dWA7SlwzDy1Eab94TFtvxfWhUpVhuqVUzvTbf6+AwAM0hS5L5aHA6YZ8tWAEC8RS1pxQq0dup7acZ/Nt5jNjwCoJT1ioDx+1gspq0QEG3LFezuaHC1aSiALWYDBWGI7FjXpjJC6buESEuQY1rZM/gBTW7w7f55wSuUHKrCL2kZJCgiDhj9kSNyKnL+J9Q12YVzYYDcU028fiNtZdN8lOOkZtraBkIYhy4Quc8iMzkANOxMwUeW7QCBpPUo3CMDy7ve/tKPdZhU3YA3h8ZYn+jy1iMZ
 KcuQSuJ9
 jKnR810bzxnSw+FYybhr1YUDivvFvwX3vKrxybNuV3K3/wpxvotHtAy/MYJrDD6BfKfbpgJXeEb0IT8bcKtWeLW41JOArMLa0TtUo6pTVldI+w+6673pvdIH8UmX4/guuk1txtLciqyhA55tf6EWlGA3r5FYYuWnsQO8bGX+m/TVVKzabet5NqiqOO7GMRjc02l7KqRWZenKKg+/ERrsRI98BXStZHgqkSOYigM2bxCeWW8rLRt36Vw1ky/7ekfjM6UGQig6Z9XSjLR//LS1nGDRTgIHnQq1mzejBtWvdLCroinl6V0paxfQncALzti3AelJVllLioq7PS65tdXgq9Mb/8mrB1uV2xRjxmYUoEnETfruAPB6TGtsyXqSL6cRWCD1iOuG3dbNFzFWEO5RGmKiEXkxeccC+YaBhm9vAHT+MurKX6oQFjiIQ8pygM5tO+9ATj0d4xUd17YestVBlVknadA81ORnuR24h34Zv+8Q5RygRTrCv2uT92EKfDfjT9jxZoiqOVw/cgPI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a slab_buckets= early parameter, enabled by default on kernels built
with CONFIG_SLAB_BUCKETS=y.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../admin-guide/kernel-parameters.txt         |  8 ++++++
 mm/Kconfig                                    |  4 +++
 mm/slab_common.c                              | 26 +++++++++++++++----
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5c4d784e7786..20710d6ccd1f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7001,6 +7001,14 @@ Kernel parameters
 			apic=verbose is specified.
 			Example: apic=debug show_lapic=all
 
+	slab_buckets= [MM,EARLY]
+			Format: <bool>
+			Enable or disable separate kmalloc buckets on kernels
+			built with CONFIG_SLAB_BUCKETS=y. When disabled,
+			allocations use regular kmalloc caches. Ignored
+			without that option.
+			Default: on.
+
 	slab_debug[=options[,slabs][;[options[,slabs]]...]]	[MM]
 			Enabling slab_debug allows one to determine the
 			culprit if slab objects become corrupted. Enabling
diff --git a/mm/Kconfig b/mm/Kconfig
index 56c422684b44..ebdf14a87c71 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -235,6 +235,10 @@ config SLAB_BUCKETS
 	  of extra pages since the bulk of user-controlled allocations
 	  are relatively long-lived.
 
+	  The separate buckets can be disabled at boot with the
+	  "slab_buckets=0" kernel parameter, in which case these
+	  allocations use the regular kmalloc caches.
+
 	  If unsure, say Y.
 
 config SLUB_STATS
diff --git a/mm/slab_common.c b/mm/slab_common.c
index e66c0778ee98..b7a46c368ab1 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -410,6 +410,16 @@ EXPORT_SYMBOL(__kmem_cache_create_args);
 
 static struct kmem_cache *kmem_buckets_cache __ro_after_init;
 
+static bool slab_buckets_enabled __ro_after_init = IS_ENABLED(CONFIG_SLAB_BUCKETS);
+
+#ifdef CONFIG_SLAB_BUCKETS
+static int __init setup_slab_buckets(char *str)
+{
+	return kstrtobool(str, &slab_buckets_enabled);
+}
+early_param("slab_buckets", setup_slab_buckets);
+#endif
+
 /**
  * kmem_buckets_create - Create a set of caches that handle dynamic sized
  *			 allocations via kmem_buckets_alloc()
@@ -424,10 +434,12 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  *
  * Context: Cannot be called within an interrupt, but can be interrupted.
  *
- * Return: a pointer to the cache on success, NULL on failure. When
- * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
- * subsequent calls to kmem_buckets_alloc() will fall back to kmalloc().
- * (i.e. callers only need to check for NULL on failure.)
+ * Return: a pointer to the cache on success, NULL on failure or when the
+ * separate buckets were disabled with the "slab_buckets=0" boot parameter.
+ * When CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned. In all
+ * of these cases subsequent calls to kmem_buckets_alloc() with the returned
+ * value fall back to kmalloc(), so callers that can live without separate
+ * buckets do not need to check the return value.
  */
 kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 				  unsigned int useroffset,
@@ -448,6 +460,10 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
 		return ZERO_SIZE_PTR;
 
+	/* NULL makes kmalloc_slab() use the regular kmalloc caches. */
+	if (!slab_buckets_enabled)
+		return NULL;
+
 	if (WARN_ON(!kmem_buckets_cache))
 		return NULL;
 
@@ -1059,7 +1075,7 @@ void __init create_kmalloc_caches(void)
 	/* Kmalloc array is now usable */
 	slab_state = UP;
 
-	if (IS_ENABLED(CONFIG_SLAB_BUCKETS))
+	if (IS_ENABLED(CONFIG_SLAB_BUCKETS) && slab_buckets_enabled)
 		kmem_buckets_cache = kmem_cache_create("kmalloc_buckets",
 						       sizeof(kmem_buckets),
 						       0, SLAB_NO_MERGE, NULL);
-- 
2.54.0


