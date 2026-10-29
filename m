Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DE3606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=xZwYscFl
Received: by kanga.kvack.org (Postfix)
	id 95AA66B05B9; Thu, 29 Oct 2026 02:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C6F6B05BA; Thu, 29 Oct 2026 02:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FD026B05BB; Thu, 29 Oct 2026 02:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 450356B05B9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:08:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15084A7C06
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:08:34 +0000 (UTC)
X-FDA: 85374634548.01.8A44D75
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3B36CC0004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:08:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=xZwYscFl;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf28.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.44 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIl6fbfmDXkFv/6QB6yZBSNCnJVQUdZCsXNNMxV+Aus=;
	b=y/wRmHEVhGJ0vIjmSP5dKOj0cgtereFa6EeoNgsOiAscLtAKmIILGl4/9kvS1VcXXv+Y1K
	08yVsj7d24f5P1BguY1tvB4quSSxv7QvlXc5CltpIi9e23ayZGMo57D2qn96XlD+V0CqD4
	RapEvHLNLqZOlBnzM7afAULen+mfIlU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=xZwYscFl;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf28.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.44 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793254112;
	b=tzjNWWo9k1vV3bAs1tx75G9eNczCOUKP7FxeuuDUbBtMZeTLqE6N8roiU2+qtqWa64F376
	5MVGtWgzCnHvsd1NOvsAYhiRSh28vX3ZhaBGKODiTrega4a34KvSV0J6eOBNfqGnfFeSqn
	C1/HFPofe5k+2136gPKuOlPcy/aAY8A=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3adc4590de4so1507174a91.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793254111; x=1793858911; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AIl6fbfmDXkFv/6QB6yZBSNCnJVQUdZCsXNNMxV+Aus=;
        b=xZwYscFlO0hkO41r3FCiWrMSE6+DX846asX5j7LXUroq7ONqKaSmN0sdc4q9xFrkmj
         zSH15sA0EEs5jRAJjMY2C5i5IWT0RyyNrYoPCJJVZtJYBD5O74MjyM2rwIzCs9Kf3aYv
         HQ/OnJrCxp81wKiMjLKvHZJOy6vA91cvtGu9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254111; x=1793858911;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AIl6fbfmDXkFv/6QB6yZBSNCnJVQUdZCsXNNMxV+Aus=;
        b=X1ItrR+JO7Pi1SbEPwJUDbCnklsUwXbr/hSMZkx4oX839K0hlqwgbTg+BIj05H4vl4
         40Tz6Bbmn3+wUfGV5a1ag6tCOppBlxRxQAcMjmNyC+a7cG3PLfW6DxwdKdu9aShIJYVX
         rqtsWz6iCSjo/U2MLuQTKL3fnSZtKOfVlcmf+cwHf+E/vfqIFX9DWO5LT7kdZtXgytUd
         N57/U8E+l4H0rneZdNjZ09HJrKC7TThXuvCrsiXgVQ/UB4Hy9cOcs+oltHBIawEQLs13
         N+wzbUyb6cB3+llRDoqNLuTQ3cLmI8GmBloVznHZmiFhilsehec5NnWoEzZ8BO1SswFD
         to+w==
X-Forwarded-Encrypted: i=1; AKwUvBzqacKPAxxTdvGN/k+y8IZ4uCPk6Ocv+HQ0dXJqcRqBLQry71hpzCBi5DxWGYW24tSHLbnCZNNSqw==@kvack.org
X-Gm-Message-State: AFq9FYLN+cDGpsbSam9NzuQ6QZOY096DFPNrP61x865jd7SvF8uEp3pJ
	dq2m6DzhGukMJXgc+eWgb/dnjI9fPXU1HPWqI7nTk0ndOtxIULLS0EnYa2IHACQBxxA=
X-Gm-Gg: AYBFou0Q5XPQf8LyO2+051g3tPCNILf7NYGNi0q0RmC2UoHZvFU7r77cLl9OzB1zgB4
	wTmG3W/uaXMvcxVrTc7kVJZYSpnfzalSpqwgNR5Jymw/zZKTE7L9lgiPJIUYLYg301zyMaGRhyn
	IFDqWn2T/QI/PnU6L42S6xBGACt4PCXMk/mZuati/cCb19qilaV6JqtWLd+bKH0Kz1OSMVXOQm5
	jZP6SN7rHAxwWgYdJQvlho4mzpS1U+7wWC1E3VS32+lVrglKWppNqjcZk7tqz1kxR5Tl2zDIPIw
	zfOnxGP1tgLaFatgQSf8fduakb4GSBeo0xVuzbCEyaeuqOncirmNlhA2HIadePpGS2ALLA/uz+a
	3QWScwASK9hl/mJiuwKSz9WlUU6h7Dzey2Ld/zWNShHqeMR7R07x9EfhyyDwTuXU7w3N2HYJSiV
	e2AK9kFD+37eEFlwGg29YYObtl5n87ODVIdWpb4C6dWAjIHB7GDGyd9Cub5Z8A5vN+Urbs1Noyy
	lzOz0lbsj9Fegd1UtrPmX5DNMSlUdlEUPvp9THInuYsWM73iP7XiKF/vxS0Cyt9uEQ0+PQJUXyB
	L6qX9rats49+xpi33LVGBTKRWGu03tMvbJb7FnCSIGkZUdGgFSVK3xxwQW8u33v+cQC4avNuTNh
	jzRSIv1O9G5+XfdAQ98vmdt7aTaMaagsFRipzVaihl6+E9rDghLzy0y6UrB8/NldY6iRnmxMo
X-Received: by 2002:a17:90b:264d:b0:3ac:9d83:8856 with SMTP id 98e67ed59e1d1-3ae57e3d6c1mr3582035a91.9.1793254111060;
        Wed, 28 Oct 2026 23:08:31 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e2a703esm2602046a91.0.2026.10.28.23.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:08:30 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:08:25 +0800
From: Chris Down <chris@chrisdown.name>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 3/6] mm/slab: Support disabling SLAB_BUCKETS at boot
Message-ID: <9a68a4d95830352ad3821437c2e22c30a673055b.1793253633.git.chris@chrisdown.name>
References: <cover.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793253633.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: 3B36CC0004
X-Stat-Signature: b1uwnwtpw1hkfoqzxa57ti57jo3x4yze
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793254112-765365
X-HE-Meta: U2FsdGVkX18YEVSgMG4Yl4ftuqt8VjJD0d37jqpEGKOyrAUz1hCyPm5t56FhYWe6N0gMS2VmRaGz18gQb/q6EDdKg5PJkCE6BC/zT7wi28mZf2+jTVNYEvwrLaeo/sp3uaZQVuXffRDzrCgzYr3QkAzT2sV3qBqlY6/AD9/oT4GXw5uNmSqEaoDELI6742drlN+EU52oqS+HToQikElgdPR85CZrH7T+dO+9GjiwBmkeQDxYiOwrT+dPyq50zkU+xFNccGgEo/KCVWyHcyZdclaqtFtQts8RRw4jz6OD+0E2+0gFqcFbZQ3B+aiG4jSuMovCnUSSg7F4cQIK/CT5zVdfDbp2d02Yt56TPbDqjcf1ytrxF07eZMWc4uS0Bj3RP5nNNCskNkPCwxaKJ1csn9m5nDQal7U3TNl5zmeYGNuYrjE1xW8jZICacDNmQoele2UY/TISx1SZNrIP4LYpDZLKCgkJO1eIP87ls21Y8tT8fgVVB2CCKdXj5I0k0/Z2LoR8VXWLb1+md0pDtwUMS1qUuq51+xfuB5f27xYU2gQyAi3WZ4GIC7Lnul50X2QYaAffy3X/o2bTGbBXBiG7QBLxSg5Kz0gXHiTKFiramgSOFzW4i2MEp/YKTiLzKeiF9+3YO18J4uRrCw7C03jrMTCuw8isFOKnjdZ8+szulHqD/zUq+PEe4rYX2X4DM+JdIVEpi4mPdHd3/s/MyM/Yh2NCjUFj8UP4v0D6FeIJjZOX1zXwNUa/OsvZPxx8jNW3b8nCu31DkWfu4Rn6bXM7nK/iSaABAHMpooIcepDZzrL8wT56Ap8jrlqSpbBLX5uPlgFw7+ulkORaDcSULbGoXmajSSokT4WMFmGX8HF83MhFk+kFpTI+fCZ0GJ98S2Pvf3SkDxUH90IbnZLLfkDa1YOzKAPxJXrUYHYP/6hslZamgP0VhORi9RPfIYz7156LOEttTbbXoAAJAMfOeII
 AnjPw++o
 KxFWBVFwyYs2f/X085bs2KkIv3QJr4bxp6r4CTJnbLhOXqtrsicqmeSak13Hh+AIew4yiGDkxD00uP4SJMuxm6sfs3gvBdlvnUFMupmmA2xPwSrqqaZFWKDsyA/vqK5F6BYEWnvViqMAlo+a5vNZaoGBsZXq/i488k5jridaLQT+beTf+uzL7kK3NrZ+76DtN/WmknlQjOog6kPx+gbqfesUDJyadHipVMRvNMnbhlWXRBnrCEHHqRRqztw4D7GIY0bJRadepDc+xvEGWtFcaKYFFk3YCjVKOrXUttc5/8D6tQ8wcA1FqUTx+sAvnI3lfPHr1BFXrCoIJ1Hv4HetxM/+O1eo2Xi9vT2RyhCCTobMaURctxlIi36YZAiPHLzl5BC6CPc5dpegN3pxEJw3ZCPzfzARNiUzkST2DWsz6X3Ru6ddQOmA6Sl3PlvnnAK0inCsCDHLLx1O/A6UqlBLVQo/gEmjanj6XDf0XQgWxbAUV8LtXiejCyV7QPlKOVjq/hkaquY7rxdkppn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SLAB_BUCKETS gives allocations with user-controlled size and contents,
like memdup_user() and msg_msg, their own set of kmalloc caches, at the
cost of the memory for those caches. It can only be chosen at build
time, so hosts which want it and hosts which would rather not pay for it
need separate kernels.

Add a slab_buckets= early parameter, enabled by default on kernels built
with CONFIG_SLAB_BUCKETS=y, so that it can be turned off at boot.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../admin-guide/kernel-parameters.txt         |  8 ++++++
 mm/Kconfig                                    |  4 +++
 mm/slab_common.c                              | 26 +++++++++++++++----
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..de2fd6963a16 100644
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
index 92ff97ff24fb..48078c1fd26f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -231,6 +231,10 @@ config SLAB_BUCKETS
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


