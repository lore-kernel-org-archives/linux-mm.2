Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1473C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC056B0120; Wed, 23 Jul 2025 10:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89CB56B0121; Wed, 23 Jul 2025 10:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B568E0002; Wed, 23 Jul 2025 10:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2736B0120
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43EA51A074B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:38 +0000 (UTC)
X-FDA: 83695808196.13.F52C77F
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 79A7E100005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=SiYQIV7i;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282056; a=rsa-sha256;
	cv=none;
	b=5aesc5atbPtCkgldOptI2iwJH+6E3taSry05ZUNwfs9y6gbBb7V2iYw9ZgGrbE1WBm7Bs4
	2iw50fPN5ZGyamGV94ECgrjOeGLwWg66ZKm/48hmyljqpkFBsNI8p4AYKDswuR0WLlwJfV
	QE9GtCnbv4HDP4NODl8mcRvHef1WPUk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=SiYQIV7i;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZJDnzlkjFdal2Rjq5d+u9z1RQAbXbOPFvsyuVPVQrw=;
	b=jg1WCqcBPtIt/uipTUaM363jNAZ56gS66sld0fHhbYa6lOOSmIc3IwayhT3vjgx0PemcFI
	cG/n72s8SdAdwNyPlM5nJLrqmFEO8jR2WKGIL8iJ0m3ttDgSq9yVBO4qqegCJApUHQqcf0
	l1Mxcje18EdXgioP9m9SThS6QIwtTDg=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71967cd1072so41662847b3.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282055; x=1753886855; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ZJDnzlkjFdal2Rjq5d+u9z1RQAbXbOPFvsyuVPVQrw=;
        b=SiYQIV7ieQ56vz/PynSYTKSp2Uh0w56/j2EoRutvPgI5LNOTy29S8Fb8yQre6hm5lY
         xajTdbtfgAd2YqoN+imIXlrS8ztf6wCrqvU281pjcgYFuNfcV1DEsgiYIkspzXxhCmN2
         1JxtOv5Wp1Wr3U4+4/ZrxHJemAM0QZBKzdv1IozIz1Y7XTyHcdtmSByI9FaNNP1ah0Pk
         D5YVihViorM5oi11+efTbCkVKPKdQ0QFfke42vlig3oiaBZ7ONqXO3GN/ZhAoubYBtaj
         gjNKqqhxkP3JFLgJ/6pZlCNYksGVtoSKGm0ZHHBF5nvbhz7PjCh/m/S/UY1WHQFj2aVI
         lafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282055; x=1753886855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ZJDnzlkjFdal2Rjq5d+u9z1RQAbXbOPFvsyuVPVQrw=;
        b=kNfBwyYWW8IIVM9GtDtLOD82i0EcE52aAnL4ieXF11Q2njdo14HrR2O0t/ryuvYJLU
         PC23+9BobhE1FyKLnfkKUw75cEhAwZQwgK16kn/AEyy8mvBTKLzchLrHTMgBNzOcZit3
         5egiKK7Xdoltn3aQtQT4MghAduG9o+w60lSEL1YJaWZ8Q7X1ILXZRdkjerkVNvS5+0p7
         JWBzKATNyPUHzZADsoeGEy+1sty5GJPAXRbLjq4kKZTi/D1zTkg4K60mfyZGaiM9kcCV
         jsNIvm2C0Kv71pJqNY/5Eb1KbWiwJ/Eqwsbfc2SAvooxPSFErO9mXV6dodFJb7EEbAlk
         S2xQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcoJNShm1hGrqKvAMblsvlqt9qmkxaY8/Ahbq40ZP8qMcIe/RcP4gmwQZfpJKqGDSUmBs2uDsllQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3+HLkbX0yYBW8ORY4Vvyvt3mA0tc2rBTIe+xKi1cOmXl/IWEd
	ihxcGoYuwxJouloZf1uBNqc4iNYLokzh5/ZRULX2EiwhQ38+I8ZU25gdkp7rSb6/oUA=
X-Gm-Gg: ASbGncvDIUv4EQEhXLt1pHDSbEtQUwDeY43/WRKpkaWUYQdgNiAxnJ/Oc50tg84zYGT
	BtPJ/T1JWrPpX1SelwNicx66LBiiCykkUwfSn6DWfIM3M2Gj8TVgO2JAEuRq0QwHdybvHxh4jNl
	bIl2VktV/u7ZIsAmMaIsEYSGPTWHYl30Hn25rFT//pyRonQAgvzZig7kzhWxqUSTD5d0u0V5kT0
	NdUXbyMUqqe3ew9sJrYclLx5MwHUGSWaR+AOdgakDHu4FejSRpA8ZNs7GOjI9LoP95uJKiALotW
	5W4cc6abU1aMy+8uoZGJRZuyKDW14QUlM8iarbXiJp7q2CGSgsYZkiMXqGEvhbxKN3ND/jAdOrB
	I7GRdIL1+Ruh3wAHARlHoJgrhkM47ZlHS55xFW/uLlyIgZ933UAHt9lTv5hcnzhh2cFf5muquqA
	b5TbXdvMVtKRPKlw==
X-Google-Smtp-Source: AGHT+IHlIrN5M9MAslsUdLs3lHTAX0ZWx0BjoPEfQHGEOchWYmIsSv7ekgCGt5Hg7CwZYoZ1gLsHVQ==
X-Received: by 2002:a05:690c:3804:b0:70e:7638:a3a9 with SMTP id 00721157ae682-719b4200595mr38740617b3.18.1753282055367;
        Wed, 23 Jul 2025 07:47:35 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:34 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v2 20/32] kho: move kho debugfs directory to liveupdate
Date: Wed, 23 Jul 2025 14:46:33 +0000
Message-ID: <20250723144649.1696299-21-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79A7E100005
X-Stat-Signature: ecm78zineibk4wd3z3n7pnhgo7dgawx6
X-HE-Tag: 1753282056-157183
X-HE-Meta: U2FsdGVkX1/l/JgD1PhQwYkgdk9fb4V8HgfBialFbwC4A7JoHU/XoWJXAD2aatsn7TdYHq77nQKUNVgowO+NB4kAHfiyQ3uc53B0oO+X1NHh/DsLDir54IoLdN4AQBZr10dc/D7785o5B6bnQJva8vBBv3jvcIyc1hWDm1zBEcQt5igcgb2eF5ryTk9UZANKSrO0PrJzrFCGYbPGfDzE4pUAe/Ho257PvGmQH+D2RzM7KA0P1w0mlBQ9DkTzhck5cGnXuL+4fwbcLXmIp7tTR83OfpH17hvgq1z0LoJsTcq0sPdmDPyRiyN0LGbUXfw2KK9JVwM3XPpR7XRx6wjWxY5DBun5O4VvrWqGQ40ETZqlQdI+F8At7ktylmQwfSi3jyau+Zko1ORn0+MOL3ZTf66PaGarTYbVm8b9UE8slAsxPXBDT8BT5BmKBZjjwOU5jKNEvIKuzqzwA7bPv+mCawgAtpGLdW5W3EjyCmzV5H3TtxErINPdePJL5wGMM/k5GTx9xjbf7+SoWz8IZOAKOUjRXVi+MAEAG94b9Y1BrMScnJ8LD1V3jtJkZ2LR64+XAKEsZhb8o2RgFvjCIIHrM+nxus3x1YfHd1jNRjYB2wRI89VBT4tGkVAG/ljxPzpaQqwdO9NE44cJaT8i0NW3CX+N6QjDM/XCSgbra3yrQlxk27NiIdpLOThSJzWYz0wV4xebIT39wc6ia51V0WlPfCQ/0EQxVQEIdRHeKP8ikdZFfrygM9JVzKmtXjmNqx2gkNenJlqP3sGhw21ZCJA8Ows887lOhymPInDwErSRHy/R+xwo/34wFajSlqFwNMcSWUa7T/Y+Gkij2pocOrpSjblDF1jYBBbkbl+UPbPld6pFvwPC+2yopiHZztL5xWMu0p/+9aE1aYW4wwkpGJV5JiW3ENAD0VQF7AbGoOHACMuaCtarXlIyYSvmIgJJuP6jJgHiSxK+o8cwKi5Pwel
 NzDFp419
 x21f7OOKM0Ms/WgS4hWntF9i6OKyQLatsQSiQIIngt3Nxaz6KKWAVUAF0svQ0Zt+kQKH+vV+KI6vkeJn90eq3K0cvMrwI0Rxmme+z5KeqHkKSrRniIxqJbY9Ta7S8hxuftid14VX2tbzSsWm/v0/2O1nLg+skKwbjAsvki/UvSew2CAZp3zXxixYlDjZSxTnkgXtCpjNJI/RqePv/QcsgaNsQcC+YnDKdyw2NI+Yl+quHGLx6IPQVSp0Ar03jxOdZgKuAbVShZtcSZSMtMkuoEHTK94ghX5byyYi7e58B0jw2KMWVh995mDduuZZs0hBD8K6IOQTQJFLKIeT7kxjSoR/AGgwBP/+gFSecU0Vlytu9rqjzmsh3nA4hAI3x33ljkmh2W9dlNf3szTRLTMWxQjCo+0qWdctrtL5+jD7f1R4sM0tFPiHREWZxmocEc9rGWJsUO0JyZwubHWRWuDY+ccSNyMfn53ilbQRQehUz35rYlgISLCQ9mKECxMNXIkJZFaP/Wf/KH3ZTZILqQYgsrIUbZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now, that LUO and KHO both live under kernel/liveupdate, it makes
sense to also move the kho debugfs files to liveupdate/

The old names:
/sys/kernel/debug/kho/out/
/sys/kernel/debug/kho/in/

The new names:
/sys/kernel/debug/liveupdate/kho_out/
/sys/kernel/debug/liveupdate/kho_in/

Also, export the liveupdate_debufs_root, so LUO selftests could use
it as well.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover_debug.c | 11 ++++++-----
 kernel/liveupdate/luo_internal.h         |  4 ++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
index af4bad225630..f06d6cdfeab3 100644
--- a/kernel/liveupdate/kexec_handover_debug.c
+++ b/kernel/liveupdate/kexec_handover_debug.c
@@ -14,8 +14,9 @@
 #include <linux/libfdt.h>
 #include <linux/mm.h>
 #include "kexec_handover_internal.h"
+#include "luo_internal.h"
 
-static struct dentry *debugfs_root;
+struct dentry *liveupdate_debugfs_root;
 
 struct fdt_debugfs {
 	struct list_head list;
@@ -120,7 +121,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("in", debugfs_root);
+	dir = debugfs_create_dir("in", liveupdate_debugfs_root);
 	if (IS_ERR(dir)) {
 		err = PTR_ERR(dir);
 		goto err_out;
@@ -180,7 +181,7 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 	INIT_LIST_HEAD(&dbg->fdt_list);
 
-	dir = debugfs_create_dir("out", debugfs_root);
+	dir = debugfs_create_dir("out", liveupdate_debugfs_root);
 	if (IS_ERR(dir))
 		return -ENOMEM;
 
@@ -214,8 +215,8 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 
 __init int kho_debugfs_init(void)
 {
-	debugfs_root = debugfs_create_dir("kho", NULL);
-	if (IS_ERR(debugfs_root))
+	liveupdate_debugfs_root = debugfs_create_dir("liveupdate", NULL);
+	if (IS_ERR(liveupdate_debugfs_root))
 		return -ENOENT;
 	return 0;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 8fef414e7e3e..fbb9c6642d19 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -40,4 +40,8 @@ void luo_sysfs_notify(void);
 static inline void luo_sysfs_notify(void) {}
 #endif
 
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
+extern struct dentry *liveupdate_debugfs_root;
+#endif
+
 #endif /* _LINUX_LUO_INTERNAL_H */
-- 
2.50.0.727.gbf7dc18ff4-goog


