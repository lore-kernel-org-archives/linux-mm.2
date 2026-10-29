Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234B8606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Q/aJSbJX
Received: by kanga.kvack.org (Postfix)
	id 53D576B05BE; Thu, 29 Oct 2026 02:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5158D6B05BF; Thu, 29 Oct 2026 02:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403B56B05C0; Thu, 29 Oct 2026 02:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5C56B05BE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:09:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 916EC4030F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:09:18 +0000 (UTC)
X-FDA: 85374636396.22.7A18DFE
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7E8FC0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:09:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="Q/aJSbJX";
	spf=pass (imf10.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.182 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnENC99p6Lehtk+q2wiObbhSP6H/cGEPWJzdL6TBkdc=;
	b=zLgPFWT1m+6fEifywnBx0iHTujq0It3Zi3Ut9uUi1/9h8vv9Gkv869LGYuVaufdH9Jzipj
	3wUCt7WkB5saqLe+I3LfzSWB905TpgEqiFjw9jA+hF9iBrTerx+7A3HrBIyCrSKuVyMve0
	CmMjDHXtVHaRUszvS7m66KaAm3W1sCw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793254156;
	b=KsCfBKW5QEkZfy0x+nEVv+fBYsmE0rVoDUFELsedMgRoeji7Gjk5r76EG7WG3cr1IT4fQK
	+8tqT6jMS8/6dFGSs3H9MZPL80WphPrp9oscayBdQTZkCz82vELVhzeAeFMu+nnARDG/D2
	DBN1QtZ8otGAeIAnUDVLqTqovqvxV/U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="Q/aJSbJX";
	spf=pass (imf10.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.182 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e946155442so13841345ad.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793254155; x=1793858955; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TnENC99p6Lehtk+q2wiObbhSP6H/cGEPWJzdL6TBkdc=;
        b=Q/aJSbJXbiT1/vnFU3jIUOzIcsPEm0sZmrs9ydCT+pWRfgHP+Oh3TxjQsgWKz/r8nr
         XQz23oPyI+zydoJF9UWmLyFsvrER6RuGXB8LNQUZ5v+Ve5SU5pqH26qnvNDZki73pOYS
         NEMUOMfffUmJXePB2kVrKyHpAw8wjIXT2xz8w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254155; x=1793858955;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TnENC99p6Lehtk+q2wiObbhSP6H/cGEPWJzdL6TBkdc=;
        b=HBbW5xwJ6ifpplj2qB33jUD+Ib1YOoFZHmz3y04ayLC/kbIQDWgc8tojsPs/9OPOND
         xXelJI++j6ExDg4pG3zpj48P3uBZ10uVpEZcy34RWmhrHPL/wJtR6Zhd/xHPiVluhtBx
         XVjC1klUxIKRBfMUZc7PCe9K73vHsjBHJrgw/74pMYWACKS4ApPA3JdJwUOpRrPGylBB
         lEv/A47xeIapZ6ubfe3bsLseU7hxh1qoett/c/q9cJoSLtDuA4Ppy5SZcdWhSDPy9KE/
         qKZ/rOE9iJZH3hYfjsQoNdmBWzk5NdydUx0gnsdbHx2iMq51F/kfKbeiB2Xv8aR+jcuZ
         fSrg==
X-Forwarded-Encrypted: i=1; AKwUvByIwaxAnnGhSsq5GzfnqpPJ78l4jVM1iMpYj5320/N29MoRA4eFCi3g0FFxy8Lz12TWj9ytqP1Llw==@kvack.org
X-Gm-Message-State: AFq9FYLhvMC7+oiAL6qAotBWyEWKMs5NpoVCZ55tGuDWV4VEnc0vqU+/
	rtcOijDX5l92z+2jyeRUvSz73sxIEFrVJH4wNztDBo1P2X+M9j6SXhfi2QYmtKmomCk=
X-Gm-Gg: AYBFou0CqxtScI7nN/Z+N3uMkEI3aELgfnzxiyM5EBPSbB2wF+JExGrkzJxVoTVnPX5
	OP/uU7loC2H10STZw5sWlYrmb7woKpvrN/kSz/fK7eTVYruno5ICqgVFAS6KwicjavNmoXSOtcq
	g7DbUiBEg4GBdxWoswyEQmKkFp9XwTh7pkdMCrfSYAJ8YYgY1npEbGWFsuvKyc6D2tfPGxnS9H2
	82qTkK5LKEsOGegzHWvptJeQxSYKzmMZbQRFdX4zaK5r++uLUTPLqe+uebK8+in2zP530Tvj4kz
	zHi2ajgz9r6FGHVmsB+F8PjwYzHmA4iKDEcCVGotefIAVrHAM/2dNA0k4hNln2IpQ6wu1mwLyOH
	4kuIAFsGMOcOqmEmu8hvWeE/ydPX1cSifZDm0Wh36hA0ImKHDQ6u4HDfVExe+M93oZ0d5O2BmKV
	GVMNbYo4zstCtf1K45pzkznHpQTg7odlKpSqqzsbZDXe5Acf/DosrwaTOXBUq/juxdzcOP1+6Nz
	sZuGArVVOh2ZkpqA6Oxm0OrLUYKAfk6U9D6n2BMCzibkXX0QLAPwe29izX512G264wBN+iCbt6h
	JkeSHi386H7LgRHEP4agpdW1ICZV7RSZW9KyE13qvCTLZwkCHT00jPIE0lNUls+lhyy9gJqw25s
	WpM5ShqPGUeMnRlJFbmlB6St7t+MBEPjWkEzn1Lkt4V5KC9XH+Dv0w2p12SkRtH6ggRlH3x6J
X-Received: by 2002:a17:90b:590d:b0:3ab:2d46:1dd6 with SMTP id 98e67ed59e1d1-3ae57e401aemr3777671a91.4.1793254155497;
        Wed, 28 Oct 2026 23:09:15 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e7fe923sm2789462a91.8.2026.10.28.23.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:09:14 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:09:09 +0800
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
Subject: [PATCH v2 5/6] mm/slab: Support disabling KMALLOC_PARTITION_CACHES
 at boot
Message-ID: <617bbfdce4fb2689c2510f0cd7f9adbb3ab8edfa.1793253633.git.chris@chrisdown.name>
References: <cover.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793253633.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7E8FC0002
X-Stat-Signature: k7kx6d868shex9yrxmntifm7ffnmppy1
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793254156-987045
X-HE-Meta: U2FsdGVkX1/oXYDqChOzlOItybu/AK/W4fRcpYHs3yU3QZzOU1XdnKHBRzD7GQNpNr9OWkMT4KOmtSZD14JnkHzmowHH1VgUxq1wte41GFZkK8cQQOnPNi9dnwlOJBaa7Z3fyqNvOCHd2ua7RivpEaKv2946A095nwgN3/+SsrMZh2TSRVC4KgMe65h91T7/HyAk/Ae29JJ0DyMZvP0ffRenpfff2iIaK6d8B25h99gq2oBs3f7PEsjM2Rg3gj/s++sXzZjYY8mxVSJmAFOZ5r4tgbHo2zxWqUP03NJxdg7ldRatNBMTpSFSPXk5xhVowhw2LrXOghohRPRUMltNRasWeHULpX3/BOCKQr/P0+F9ZUjB3lFcuCeThbrkkWNtxLRQdhqQOgE0ac1sLYqewOmUDrKiYfBAUVp32azYoP3athGkgx5ky+pQGIToH1qublRGdoc2Fk7cyZPqyiRvjwYqRD1qRR8KA3gFXyPvZxs/u9tOicHkqxykPHfkpy0IwscOEUuroh74Zk5cnkzOSuQIPSVblVdnQ66P8p7IZ9CB2WBTIORilpuCht9R8QbNXYtFWqgptr06khDokWvVpAYhLBG/zWZSEHlbDkA2WcoWzFaWZ4oaB4nEQhEiosEYZJo4CgCyE1A7lStVifev7zT8G0aM6nGwUnkgB8g82kPrSEDiENLzjm8k0sbcjo3wxtrLq+tPaExKKfo3imlOxlWAGkyWjuZ8AR8UCx6duQrf76RZ5JZq5f9P2d75ipSSz/sfyEJmIsAbWDb/69/vq4lqPafcuPeF7WIuipz9DK5adIvaJfDzlkGomgfznvWD1fKjdZm16vuAu9875ghqapbVluDG5m25z+PfOxFFyGgU5XlTMLMM7EgCuqOCvGP6RdbmnjpfavBuXdUw1nmQZDJjsrDZP0Gy6QBifdOzj/eOiWlzpfbIUFO0avEVueJjpDxZIdnatjEN4MkcnAH
 X1hbMfZY
 EKodKE32KeMk0fpT8AVgXa2Mpc+d2Rs2anDkrTJb9ZLPofcQbY8pCfWFcuYDotVy1ABbSFiMbAqZNq8VXePa3PWAW/cpzKM5XYToXqY987dPlPOpg+NJC/dQZ1xeVzcL5e7uIy1XGP931IomQDBNZ+arHmU7a4uHAwK/PrzzGmqTCpmi7Zz6k9sXOsAHo63Jfbgo3OXCzgKp2trjjegNw168VnFEplOEv5jNDRM1PdqpzahXPm6jn0Jt3qu6e0pbjjaQbP25u06N5zfEMag5hxKo5IWHzYnx4gEbDAtlcD5mwHkfha5nQBG1pmddPb/fQllXlVGMgpfGnoN5sH7GWjmWT81VPM2TLjDgAcDOY3IxkR97uiUJ87gO9KmpIGr7kWrsrpqmoA97eYCfpIEj/T0OQ8Gs6Qw5oEvkT1Pb22b86lmSFmA9NZZRj89I3AIL5b2J7WXlEEHb2nlYwwnHF3Kabg+cilDZwqqvrSaspDXn6u+RsPzGIo9NlPiwdG5bc/ZpITgMfCwuFdTm9mAyGP+es46DjznYbEoAR
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
 .../admin-guide/kernel-parameters.txt         |  7 +++++++
 mm/Kconfig                                    |  5 +++++
 mm/slab_common.c                              | 19 ++++++++++++++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index de2fd6963a16..6633a553a79c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3054,6 +3054,13 @@ Kernel parameters
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
index 48078c1fd26f..b90b3915fcd5 100644
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
index 9fe48da12010..5391149a2eed 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -781,6 +781,16 @@ unsigned long random_kmalloc_seed __ro_after_init;
 EXPORT_SYMBOL(random_kmalloc_seed);
 #endif
 
+#ifdef CONFIG_KMALLOC_PARTITION_CACHES
+static bool kmalloc_partition_enabled __ro_after_init = true;
+
+static int __init setup_kmalloc_partition(char *str)
+{
+	return kstrtobool(str, &kmalloc_partition_enabled);
+}
+early_param("kmalloc_partition", setup_kmalloc_partition);
+#endif
+
 /*
  * Conversion table for small slabs sizes / 8 to the index in the
  * kmalloc array. This is necessary for slabs < 192 since we have non power
@@ -1013,8 +1023,15 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 	}
 
 #ifdef CONFIG_KMALLOC_PARTITION_CACHES
-	if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END)
+	if (!kmalloc_partition_enabled) {
+		/* Use the normal caches, which have already been created. */
+		if (type > KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END) {
+			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
+			return;
+		}
+	} else if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END) {
 		flags |= SLAB_NO_MERGE;
+	}
 #endif
 
 	/*
-- 
2.54.0


