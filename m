Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1309860A3829
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=u+t5N4jL
Received: by kanga.kvack.org (Postfix)
	id 0C6C06B05FB; Tue, 27 Oct 2026 03:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077B16B05FD; Tue, 27 Oct 2026 03:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6D56B05FE; Tue, 27 Oct 2026 03:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C258C6B05FB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:36:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 459681606E5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:36:18 +0000 (UTC)
X-FDA: 85367598036.08.326CB10
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6B06F1A000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:36:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=u+t5N4jL;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOacexIKHraWCg9yl1hlssxWGivRL2xIzkUcida+0nw=;
	b=gJaaDdX7k1JOmgg2oK/h9zZdMLDMrQDsC+ckPW0m5qfHzScgsbhUVB+ZiSzMKaUylddjqN
	988qshDmcu4ARyxd1+5SCfw/c+pJ13/Hpmf14YSoPF+ahQrPPa4V1o8uKrU5ABupB0w9d8
	UEt4gMihFHC5oYxYMu1vAFPNoGbssCY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=u+t5N4jL;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086576;
	b=S4A+p0wpP4zDXRK5moyf3MzyjB7rAZHHiCc45D59b6afV06KqfkG/KeK6/X5Y3/U8P0NyY
	2mcvDn+n5dbWrIts14iGNxuhhAwQ2Bd0IHmIV7MMYtImJYJWjpWsvHb4Y8Us3pRnKKhpqM
	tTW11X6LGV+PSwv4pE7hWBAgl8mt690=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdac6d19ddaso586256a12.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793086575; x=1793691375; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=dOacexIKHraWCg9yl1hlssxWGivRL2xIzkUcida+0nw=;
        b=u+t5N4jL0+NKi5SFpahm01xFrcx3mxQvFA69bjJaNztlnjIAPJLtrAdRTk5QtP5HK0
         MbSSyYOtBDxT2X/q4116MtVpmopcfFPfrKJw6mjXpTkOw86XRePj4+5AcazUIJTar0u/
         6KKHSfHRepxV4fqDRz5Mn65KEJxt/rIf5k5r0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793086575; x=1793691375;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dOacexIKHraWCg9yl1hlssxWGivRL2xIzkUcida+0nw=;
        b=BSJVS+ecOggsINftVR+MjtyU3N9yKnNH7S6RfW0wozPSM31Gr5lx9raa5vcPj2cvfI
         +VJLQlVc8E9SJ6CTz8pc5rz9XUHtDhkbJoXQKqpAhzlUI1Fw3n2NAHqOS6UiWmXwgLwI
         sUKmiFeLhySl0LiQYodVXOwMAQRyqRyaGvMDGkaLVHW/ZLdd6HjMwgpFwQ3Zy67CuVsL
         EpK1uvduvSIWyqwcTwtJPMUD8mA6Eoe31CagH0V4A6EPc+jkpQOZJZUPefYdssePOH9b
         GdPNBgxOBK+mLBFGumEK92i5tiY7ROghl7hTA6zPryAGjsTsMpvzbSCsmwv65CYD4l0q
         Wn+g==
X-Forwarded-Encrypted: i=1; AKwUvByu6Yz/9EAoJb6fSL2fdL6f6XmWSnZRD+Ab8FY6RH919CUJ2agWbZBYtMsndmXdWIW5uuJM4BAy2Q==@kvack.org
X-Gm-Message-State: AFq9FYJAJCyfCVay3HMfmz34IVAVBc8UK8MMNdL89MCdzDne1MREXjiA
	eTw2+yV0rlQHmqKivwxW5vLmbQDsELgyULCE6etpK7LrmYUdo761iClVNLCAED6FFP0=
X-Gm-Gg: AYBFou3GPiaEPG7cH38xunbYEyr5NNOPgtZw2FV3AN5MITN9AcZPkO+h78CCBQpd9jg
	m8spG4iVFBOB4bPFqXTQ6B2xW2vOOraNK20AbEAyp9lzaNFZb8IPtpUZao/Nrrp9gJT0rsxi2Dm
	nEI5i8gkJmBXdtUHeUcJlSh7+uH5roPwJyiRZmrul9XRDnDGvgoUcjLCctrb8gzFKQnOVLLqcsV
	JZt48960FE+KT85M751M9huqiUQHUPQU7N5dbrC1x0WOLX/P9pBKBYQCO+QJowBvPPUc0DB/lAE
	vVBzHtIo1UL84SWGNfxXYgZBZ4bQRnrjwqLOJYF4XdyZ1CWwSKt8QKtsuVvlsMi9W8Mx6LiWNaX
	LPbkuNZBGD80xUqLT8WLamukbVsC9luymznMznRf9ZQ9JBg2+4Oay1Njw+rGcdea7RDofV6WEVz
	+cjJj/hfcWn9qssiQ9HeCUjH+BEUDY720VYoNbIGJMnRgWGeJHH0ZvbMGl4Qh2T2NsYWnnMti/a
	lHGFEEswcIxPgT5dZcvFAsSweGFdLH1r5H4+otzQ9ZEvRQD1dUL9JnME97Ryb4TpOwYa2nkS2xd
	WsItA63UJ6QEGeKiwI3gRqE2L5M3434Wrr0951N+yqpRNL5N0muu+LqhcpPVxuGMz1amKtOG0kk
	367axFGLOsm5l25N2HnteXlg=
X-Received: by 2002:a17:90b:48cb:b0:3ab:1b19:78ed with SMTP id 98e67ed59e1d1-3adea9dca32mr7453567a91.21.1793086575392;
        Tue, 27 Oct 2026 00:36:15 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae40472ed9sm2570983a91.16.2026.10.27.00.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:36:14 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:36:10 +0800
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
Subject: [PATCH 7/8] mm/slab: Support disabling KMALLOC_PARTITION_CACHES at
 boot
Message-ID: <1b07254587060aea4bb296ceb10f80e09b46e95a.1793086056.git.chris@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793086056.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: 6B06F1A000A
X-Stat-Signature: n4w6watiyfor7iyeg4hsmgobzspwfyuw
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793086576-833637
X-HE-Meta: U2FsdGVkX18AkoVlbYB0q7TX3XpcSh4CXN/Nk5Ysu898oyh3jCenRB5XBoYYu+2807nCys3bFIReqm4hlt1rPn40/ZvP+wcmn5Yv7JTk5004YmNXaC9x6PUgDXZdn4paRqtNK9lLRiBMOvvSZo7R75R1SMA9Michlbhh32EVOuxEuYm9YrbsElk+QYPy56VwyObWldWCAEI2b9/GNW/M31/0Bj9WgaGT0ySE4szM0ivi/Bu5CLpoCeRzDMxIVrv0oazDVaeba8CPaCDJHw3hx+WInjZrTiAxDcQIrA0lZPievtup8ITWWiQL6QfuqZiCGoiCC2W70P9i8DIOGjetRo51zyf8pYSWE5T8/upLnrKVBx4d3orebZyk04lcnMvI0hsRGz/VySEynI8gn5X8LWu7J4w2kcCM1F4Q9PSByq4Iy5nbqcS2RtRBpNHlnJm4qiuDDloZM6sHs4VNwu+WRgr7e8Bg/XFJEkIKxpDKCSg6ZLowJ4iYCKLFksxbljj+LHdtqfcZyCkOx8Nbmfuh6rUG3Z50tlBbimMOOGzan1LaGkYZ9feXI3X6BSWi7JBfPlXIiLepF/l6YrOY949dWcq+GqE4IrvvenGBff4RRHeBTtO7FYOSUKMBLtQw/9jRyPhDrjekAOdRzAW+7E8k4N9fmAJ5e3qLTNg3Tw9NTeDM4vgmX82mmfaZ5iagShKz2f1/N5RGQ8JUXN8b6f65/V30cmPIIV1iAEb93yMtROpazw9CSr5KxL1ijpsmRMl/OYrJuLoriysXhCBQwp0we8gD2qrfzqWtcEgLcc+eUcudy3JC6sGy0Ti3tZiBaqb/ZbE2gTwPk9irVsMbchaFXaKL+uVyCPInwOHkeefl9NF3mA5Xtp1NguunNRvQzNqHMkHiRoTAyHt9qvl6PB+a07BqXtGKdkokjoHzOP24zvr0Z71vYVAak0JDQjxRooYMWXB/Tf2XWy/wQgxvYYw
 /QqXZRqY
 jMAcH6N/cCLX5+zlEprR58kHXcVmC4z3vmdpzJNlc64pYTN8//1f2Mx5PK1roXx7P/6oGMJfTq33ADZCjoUouJ/5zxFZB4CFcLuAAVGy79gG8RuIcZnmztdA8oIbtsgp7JcXpZ/AW/x2cxOlazEbpY/+B1yLca2VX461/u+QaaLymqxZyGEJKrPmNA04b5zW/H4ZVl+vQUX1bfesu+yWrxpIDhgkKKX0HIXKYG/fa1JWX7jLlxNkTMlTzq2CoD2Py/YMT+bTn8mJMofiPoJOLr27yZ56OnkYsdEacofI11lIciePn5tRfwyY8udgZ0Jl8HkeJH1Ab63cvYWRiZehvzV0ZpAPbO7DJYGjn2rRzREfyoOptS86To/i/N+EmKGedaKMQTHUrJvm3CuoxyIpY8pZmpKOjDxRaZLB+7RZt4SbSeNK7ALlJuO7qMB43Squ8IVYzgCfBzbdknehi7uDQkZSewbvsRtmW9YkWCOlrHjUweftPfVs9++p8K3ktKsOtzNtZ5psQQmZObHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a kmalloc_partition= early parameter, enabled by default on kernels
built with CONFIG_KMALLOC_PARTITION_CACHES=y.

Let's leave kmalloc_type() unchanged since each index simply resolves to
the same cache when partitioning is off.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../admin-guide/kernel-parameters.txt         |  7 +++++++
 mm/Kconfig                                    |  5 +++++
 mm/slab_common.c                              | 19 ++++++++++++++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 20710d6ccd1f..9752bd2aaa72 100644
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
index ebdf14a87c71..12fbd7075705 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -270,6 +270,11 @@ config KMALLOC_PARTITION_CACHES
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


