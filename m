Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B64A606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=OS0pozqz
Received: by kanga.kvack.org (Postfix)
	id DE5756B062D; Fri, 13 Nov 2026 03:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBCA46B062E; Fri, 13 Nov 2026 03:51:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD2696B062F; Fri, 13 Nov 2026 03:51:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 974A06B062D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:51:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D2ACA7EC0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:51 +0000 (UTC)
X-FDA: 85429478022.13.B02A93C
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4B8C1140003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=OS0pozqz;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.131 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559909;
	b=AM46VZUkqCqBS9fvKdOWg/O3LlfLgOXb6DSf1+Qag3JhLkfXP5K4x/Z8KU3tDWt18qv+x9
	jOuqK4onpOYi/qMpGFx/drdAU+Tb66LJPfP8AAdiAcQ/YsrDLO8xODgk2dcBLWkxLrlkmE
	YZ6HoCAeXcHPVHC4jyEXEThiC7MbvA8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYzK3//iA/GrlqyqFKm7zb2MSKDdJnrLMa2XfcjD5wg=;
	b=6WGh0mNxCrFfFMqH1Y6Ow4EdWlVHKPeYFu8wMxN+xHaxDx0dvyQmJvUSIM2jn8yOMC9rBS
	md9x9+pejpb5vGdl5YoQyvatX74O67u7+OiWiB1Lv1asNJjVzqUmDIw19YPRRtWYhrwzaE
	+FCTeGEpgd9zgXbYoJczxr4DR+J43dw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=OS0pozqz;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.131 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3adc0ac3566so193369a91.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559908; x=1795164708; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lYzK3//iA/GrlqyqFKm7zb2MSKDdJnrLMa2XfcjD5wg=;
        b=OS0pozqzfgr3nSpvyeR8tH+dRmxrFeJiT0PHwUQcbgpqgrSN8BrcKalzUwgbeZxmQz
         W2yCxVW04CdYvR8Wd7j0EfxzoKDcqj//Rjg1yj5VdfQxqq7UtqNYT+qgNF2yk1ynPR3K
         iFuE9yDd+nHe+eEx0JgDKlT6oxY726d8sMdOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559908; x=1795164708;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lYzK3//iA/GrlqyqFKm7zb2MSKDdJnrLMa2XfcjD5wg=;
        b=VeET7QJWsNrDqt1ERKzPjZfVKrLtRmPDhIcIP9okZ1iMD+hQmJ+S7eyIVyZOIo4v11
         jSWiCMWpFK8/tU6CEDc9D0RuGL/UloPSz6pQmT/kk7r+9U6w2ybttODUO1ey+zLrhp55
         fdW+Ahd/HhNuH/4GM0hEd7aro1UdypY6YqXmIVAIslcki6W2wmZGItFxj/rKeP1yWl5x
         ZNpOKlkltEmUsI4yEPUSfs29lP30hI3x0VoTH7eZA1rnZQLI0ZDJLEUGvM02dI7rRms3
         XMyKO0OQq0re0XQgsGf04XpqmfQGxRE5na4pkUHMpJLU8R6hM5ywZZFhKHtFrrp6ipRV
         eYzg==
X-Forwarded-Encrypted: i=1; AL+hErHPd6vWXwnUZfHq6tLIw8B2QVfsJgR0yidqxFVI6l9Ya+fSh7zDZkMQH+2+3RufXis773squfPk5A==@kvack.org
X-Gm-Message-State: APuU4Z/UJ2kp9+w8uiP2alBHrV4lVPHWLg947jtASRxTI8/L1gcVphCd
	pCTM+9xw5xPvPT3gD8I423YXnSXgwb2Ck8dt9L3RAVyXyO/JrRn/3uVTwB+r4rKi6rw=
X-Gm-Gg: AYBFou1eZDsx6bknxqF6MVFtixV3Gj3efUy+y4eeCKLB1YHQ6VwvUlPPGpjJxx8+aCX
	xmzU4+To8wvR6fhpib9V4qtmD+Iu4u31BlgQNrQIs5XkGZbuT/TBWcg09pM3ZewSUFbAiY4q9KO
	UDsnATApKBX/Rn434zZcFtHVcpvbcJTIsA7lKInqIGyX3kQtHrrhZhwl6wrbxrI/4FYnabXN2jr
	1Pt0ZZtgjdYDzQcPtKguZ5eQtErmpp/IXDn0HfsP9aqjZPZHJibO762XeCK0vw1mglQjao1+2p1
	+Es4MCtK/6bL1hd2P8JP5PJ4m2sDSSzClYoiOXkpp5VJk3u/H2Xix8Oif0duBGaBBy+cqEa0c9v
	NfjFZ6m7xz1GDUyzNg5fMcfxdVjoO8rit+FoYALsgsWY+gJ6o/3wCj5sEJFsugTg2RKHu1wZd0W
	SPEkQ02PSz7/REwx0Iqh8sMGLXebQIvEmVSAYhdmZMAbgGfmlgCP6ouoHBulLmOluNa8aUKj2+H
	IeShFbRPYQEG82BOXrSglvEOCi+Dt9DyxYKnFb4HDPQ/NJEfC0HJyzRQDbi/WzSnXzpNJWSUUPx
	hXphnK4CYJh/+6UlKS9EcC70h4haprXBUN6TaROcyUAW/bu36GRPUYq5sgV5H16016J1mA2iNpu
	Dxh8BKAOUzl4hPhPuVXsTZlHV2kRj1iho/BCY/gDsEQnjNoM1YNn/ZjJEicNtl3Go288HXPj00r
	MTQ6ZvAu7g9SnNnV6i+dLsBxNusPRD90BgJmaBluhmB8diiOlqBgsmwSA5c9ERh14/wTe3N/Asz
	ve9+sfk
X-Received: by 2002:a17:90b:584c:b0:3a4:b8dd:1447 with SMTP id 98e67ed59e1d1-3b1b0b5f9a7mr1634952a91.34.1794559907971;
        Fri, 13 Nov 2026 00:51:47 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d35ac2sm8778891a91.17.2026.11.13.00.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:51:46 -0800 (PST)
Date: Fri, 13 Nov 2026 00:51:41 -0800
Message-ID: <9a4caff0336c78a7adc746786c81c9c01f89c40b.1794506262.git.chris@chrisdown.name>
In-Reply-To: <cover.1794506262.git.chris@chrisdown.name>
References: <cover.1794506262.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v3 5/6] mm/slab: Support disabling KMALLOC_PARTITION_CACHES at
 boot
To: Vlastimil Babka <vbabka@kernel.org>,
    Harry Yoo <harry@kernel.org>,
    Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
    Christoph Lameter <cl@gentwo.org>,
    David Rientjes <rientjes@google.com>,
    Roman Gushchin <roman.gushchin@linux.dev>,
    Kees Cook <kees@kernel.org>,
    Marco Elver <elver@google.com>,
    GONG Ruiqi <gongruiqi@huaweicloud.com>,
    Jonathan Corbet <corbet@lwn.net>,
    linux-mm@kvack.org,
    linux-hardening@vger.kernel.org,
    linux-doc@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Queue-Id: 4B8C1140003
X-Rspamd-Server: rspam12
X-Stat-Signature: zb7xq6gx9npj18hjm5j3z5scfcjiy3mo
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794559909-356972
X-HE-Meta: U2FsdGVkX1+GAe6clPvcMigwfODF/zupOCniJQG1xT5WAgW2C/kVFrLL8vrbR3l+ehpMPbgZ3uXWmpd04cJY9lf6S14teXUX4n0qMbip5wYsbp2Y/GLL3Du/OM/PXR2WFZlVzsnpnt78Q9JyXeYqzzHq3Sz9TWIJ1TkyoSNPeN3UYIUUOS9/5iB3bgQLCGgw69mBl7+9YO8AYiDq0j7Kh5ath8tZyH5dIXLwNA2wxUGekKkZNOLSQ7EFhUYr4fsRQmiSGQYoGLES7KfBUl/0nZ5Xb44OhFcqyZOicAwvecFM54eZlG2O+fNA8N8OXDd2M0350C7MBtuhA1E/Ggh4BxMYeIXY5ameZjuks7MleYBVsGniHeZzQxSRceuCGDiCE9hKyYabh3IiPOxpiBaFdMhtMnfrwBk/uMlIhKfo+yPDJkk+iFTbtO3DpVY4LSDe31ewxt4v1FCV5NMyX6ZNRYHU8rcsvPDW13VUpyxllcidq3vBTOmXdAIDCJbtb0iOuCN9NrFh4KUx1ckqgn1gmhXKO0qTSZDle6PhEaqB0VbSg2ZM1WcBprR1MpzVvs5ekcANzk+bLE6jNhPEuDvmd9SQUz42EkylLII9M0g//RbF9yHb4wV8rlTI/kORzizRUWsyNmC4IMuGpjK0L0ujnUY4iL0JwahDsh85i8F4rUzfDH94MI+ehXnM+eONz52TK3Pw3nbM5jO4ac0I9F7YeN6xrFBQl6WDlWrY9FG1LqZhhhNRzd7AN9n0byzNxbA1c8nlRf1crwVCKsdJaREZnxZGh6/Rpj3FPvatlvyMYfD01ymgvEuzsqrVW1wCx+6IbY4LbFgHBm60AXmXHhE9+LTQoGqqYdDg6qkXrZMrRB/KnImp72GhIHDWDy4y/GjNi35/fPYL1KpJSxd0oupxVvHp3Itxym8EHMOZ3uZ1n+O8C5grKwZHdh2621q+akVFrFoPPeXDhtT0t41hnep
 PIPVv/I5
 tostckeoWjdXse+WysDlaNSZ0+43LGko7F1hlnGHiH+IJsvu++2FAX1TkpJJZwqeilWQcOKajtKoYUQmLTxOxFslEYLnFjX0ElcXoRaxAW4ofI6BXbW/kZxZBDtCsULteOs3LIUFO6IzblJxrvlYZbvd8lVVMeLVs9ItV8drIi/Z2t2j1UZun0dzDq43X/fi1SG81UwkTKbjjgSZzWeQVUqOp1dUvwbMrQXTkjIA5kfodLgIy7pHvkUeXxK6N/n2byQQR+nbpGQMZRBRyU3SPkp3CxlEx/1XoYM58bKRnt3P97OtPsMfnEoZHYHLU1Rx3wCBEB3Xa5LOlZ2NBZfNNe6EQq5GqEFkQ067QjJgsAMuN5YpBUIwIR/yRdhF5CqRC/uCf0d2SP2GeERO8jIH378DJpnZWfA+eONjoBNnBIucKRb8c63G6XSbkFMpJg3F9P47da62uCerQZfcKnTFeT9Ab8+NXK0XhZauYCXJi5pjMfxRASslKXMsqf7VahMiLNSK3HNZmhRC3Cpj2dwbiRbH17OfgUj0qPf+i3ux0kwZQdWYL9j98eK14pMXapgHVNPMmRyi37pxkiFqfiaBeSThtgwPFqf7cSOmeGyHypoHOjazsB3vKlwGc+6ZXM/ZS2Zh7FlBnlDVzPqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KMALLOC_PARTITION_CACHES creates several copies of each normal kmalloc
cache and spreads allocations across them. That costs a fair bit of
memory: Harry measured about 18 MiB more slab memory after boot on a 64
CPU, 64 GiB VM, mostly from under-used slabs [1]. Like SLAB_BUCKETS, it
can only be chosen at build time.

Add a kmalloc_partition= early parameter, enabled by default on kernels
built with CONFIG_KMALLOC_PARTITION_CACHES=y. When it's off, the copies
alias the normal caches rather than being created.

Let's leave kmalloc_type() unchanged since each index simply resolves to
the same cache when partitioning is off.

Link: https://lore.kernel.org/r/179312451613.474906.1475329637924619088@kernel.org [1]
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../admin-guide/kernel-parameters.txt         |  7 ++++++
 mm/Kconfig                                    |  5 ++++
 mm/slab_common.c                              | 23 +++++++++++++++----
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index c27bbe205051..91caeef33c3a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3045,6 +3045,13 @@ Kernel parameters
 			Configure the RouterBoard 532 series on-chip
 			Ethernet adapter MAC address.
 
+	kmalloc_partition= [MM,EARLY]
+			Format: <bool>
+			Enable or disable kmalloc cache partitioning on
+			kernels built with CONFIG_KMALLOC_PARTITION_CACHES=y.
+			Ignored without that option.
+			Default: on.
+
 	kmemleak=	[KNL,EARLY] Boot-time kmemleak enable/disable
 			Valid arguments: on, off
 			Default: on
diff --git a/mm/Kconfig b/mm/Kconfig
index e602ebabd6e4..5bb6e33fab49 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -266,6 +266,11 @@ config KMALLOC_PARTITION_CACHES
 	  limited degree of memory and CPU overhead that relates to hardware
 	  and system workload.
 
+	  The partitioning can be disabled at boot with the
+	  "kmalloc_partition=0" kernel parameter, in which case the copies
+	  are not created and all normal kmalloc allocations use the
+	  regular kmalloc caches.
+
 choice
 	prompt "Partitioned slab cache mode"
 	depends on KMALLOC_PARTITION_CACHES
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 5575706b8938..20b066d61703 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -781,6 +781,17 @@ unsigned long random_kmalloc_seed __ro_after_init;
 EXPORT_SYMBOL(random_kmalloc_seed);
 #endif
 
+static bool kmalloc_partition_enabled __ro_after_init =
+	IS_ENABLED(CONFIG_KMALLOC_PARTITION_CACHES);
+
+static int __init setup_kmalloc_partition(char *str)
+{
+	if (!IS_ENABLED(CONFIG_KMALLOC_PARTITION_CACHES))
+		return 0;
+	return kstrtobool(str, &kmalloc_partition_enabled);
+}
+early_param("kmalloc_partition", setup_kmalloc_partition);
+
 /*
  * Conversion table for small slabs sizes / 8 to the index in the
  * kmalloc array. This is necessary for slabs < 192 since we have non power
@@ -1012,10 +1023,14 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 		flags |= SLAB_CACHE_DMA;
 	}
 
-#ifdef CONFIG_KMALLOC_PARTITION_CACHES
-	if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END)
-		flags |= SLAB_NO_MERGE;
-#endif
+	if (kmalloc_partition_enabled) {
+		if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END)
+			flags |= SLAB_NO_MERGE;
+	} else if (type > KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END) {
+		/* Use the normal caches, which have already been created. */
+		kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
+		return;
+	}
 
 	/*
 	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and not
-- 
2.56.1


