Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7EA6CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4DF8E003F; Mon, 10 Nov 2025 11:37:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD0A8E0003; Mon, 10 Nov 2025 11:37:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDAF8E003F; Mon, 10 Nov 2025 11:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DDFD78E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A979C1DFD41
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:11 +0000 (UTC)
X-FDA: 84095252262.07.07D6734
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id CF11B10000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d1ZLO6ET;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDpE0CvbPiS95CD/e7bDhFl1FHfdcNhWeVLe6GjR39g=;
	b=bxvehK4bWEIa79qLT8Tb+gztLlVGExrEwZAInHB70tH7/BxQZCvhOb0oqjqxxQ9DyKLBP9
	sSz1YAl9D5T3JKbQIYzJJX0J07CrzPYk3ruSlJ0l14YmVHh34jJs7CLGxciHa1HHfK3kLB
	s4NAEovmk5/WxvYiXtcHpkp8z7sEU/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792629; a=rsa-sha256;
	cv=none;
	b=PRKmhHSHzlfcvD1dk9qXwfjcokVPbpTjtX4YZps+P7kn6LlStAGgZD1hZV13y5enVrHcct
	AN9qG0BtacyTx1MHKFYCfl+NndlkLsYK5p2xUstTJHtuUBkQmCvBb1OIHMbfw/IshYBB6z
	k7fUmfPt+KpNAuJhrue/Yxo1mWvb6zQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d1ZLO6ET;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-34101107cc8so2621058a91.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792629; x=1763397429; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RDpE0CvbPiS95CD/e7bDhFl1FHfdcNhWeVLe6GjR39g=;
        b=d1ZLO6ETgL9YzVH0jdFLO0KrGXVg6ZTeBefDIXi0ZtUo4WAdAMdMAmDS2hOlo1r20K
         9aq5yQstNITTvV4OpSl3fm9MXAgPQxiSBfmOjMW9SFua6QUJcmnJwawrFfVDI3iKhNOO
         dy6ssNMxLMDY40IQ2DNl01cXqxrq/XBihVmHlAlHcYCI5KoI/BuuJ2WwQq2DhurlpI/Q
         VL4IxTne4+Ewt/QvkduKD8zqmSYi3k3kPnkqJp1JFXcT3++KhZ5yEVQbWCiTQsxpGvpp
         uJaZrZBk47qbJr8sjIO299pOaW4WOTa8ZbE3ZQq8IziXceasrrbT8VeVvfBdI0RZ1Dq1
         8ajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792629; x=1763397429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RDpE0CvbPiS95CD/e7bDhFl1FHfdcNhWeVLe6GjR39g=;
        b=bj9k0aemYOKL5L4jGkACG0vlAe+fW36g0cCEFCRxXjHwv/UYhQ5k5LJIO3lrf4gRPy
         nNeWNk+mnbsemCL/aNv1j5YYD0brOeUXL2vTieuSSclmw6TrFypCbaAt+eJ7laisNz0i
         wYEd2TSqydIGg6yQfFtRV75IT3TAcs9gi19bkGB/5H2AvMPtDjlXcUrP5rkJhOy45IKJ
         zXOcFdjcV8ZfQulYIqNsYPsiMxQWKWGqW0PBReo7kgH3NzmDhFANsolqtAZoq0XCMmMI
         RjEEaYynf1dD4d/dJ4MXk0bbT5uQyr1K/Ti/hwLhuN/YhiGfrADGhD4Pf71o+ytVbQ5T
         ZzJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRy5gIIr7gpPfQtGSTSu9RK7pAEUzlQ3k9CIh79L2AnA3ykcGtpmgmAjcKX9elht/2q9ovwi9HtQ==@kvack.org
X-Gm-Message-State: AOJu0YxEGloyPCjbXXywAP2n+AryRg0pU68MoK+2+VC4GmmewZ+FDYn8
	p31XIvYoPZWA6DdysICUjP3WaNbzSUYRo+PmajmneLd3xayd5Yq8x5Fv
X-Gm-Gg: ASbGncu4NA1xHfd40xAHk5yxq7bX1HvIHLAC17TkUa8cFs6V7S1HcSFCySM3dXr/nr/
	GZxW0TTkq3SKV4deMne5//NIg6uP2ZGx94GpxdKIspKPLfQPbBi102+XNmrSVX04NScYBb+hHj4
	SUN4XlVXiBdUoSzOoUxnbUbgjCuTe5aVK5cr7Y5dRl6bMcsKeqrj5s5S+TVHLNUaOEVaxKtuNWC
	qdlu7zQYO1kPXGj4994JzfWg4mutu6s0d12PS7VWG6+3ttgrTFiEfoQ8xonb1izN+BlQVNVxkUN
	SgBOouRnrtaFbMVYwlrONj3HNBLLX7QBvaM6coDiP9LiCpBH0ioTMHuE4D9JDwOFmSo6x47pvSZ
	vI6lhkJSqx3YuKaFF0rOngMLcab+1z8C+MZMT1wpNmVUsAWDr/lUdgtY0+Ys/YvJN3i4YhM353Q
	sAj3TYik4Nwiqg8ZxwWtZGrQ==
X-Google-Smtp-Source: AGHT+IHLWcFC7W3aH7MtEyBpRAAfyoGWF1TXnIybIjXPJD9gYvIPg0ozGaDjCXeoqvDbHEVRJoG18g==
X-Received: by 2002:a17:902:d481:b0:295:9b73:b15c with SMTP id d9443c01a7336-297e56f9c21mr125602655ad.42.1762792628683;
        Mon, 10 Nov 2025 08:37:08 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29650c5ce87sm150073335ad.29.2025.11.10.08.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:08 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v8 06/27] mm/ksw: add singleton debugfs interface
Date: Tue, 11 Nov 2025 00:36:01 +0800
Message-ID: <20251110163634.3686676-7-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uwmoxgti9ckfoa5fe7d969fb8qm4omwx
X-Rspam-User: 
X-Rspamd-Queue-Id: CF11B10000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1762792629-237500
X-HE-Meta: U2FsdGVkX18y5uTAbVSStjSalAqugiWN4XcMjVTzkcBycijcZY5Jr/kfmO5z1Tx7xzC6UZfNdoOKAN8zsetv3OHIsmO4dDRS7blTztcm99EM2SoXe5liPed1ssdj4hqZ5tkQof/xQnTSBlcyNYsW5l8ARc+FyVdoftneg5qLKErTVvQI2FwCTCa4NXUWAwjHiM4iNE9qxKtQIoMnH+wbvH3OhXF9WrIU8jMdcAQuVmT+44mlfFAecCAAxvOdjLIGYtuYYPxmUg7J0Ai/8UUWsEOXGggoJ2nRc4k86GS84c3qjAur7KhZ1aDWmg2+VEcWLRps1P8slEt8347wyGXnMNWhaVUrtxKMXEk3n5Qf+O6n6LunLUKhV4/B5QQYwxFpKYBF7nPNoxC4R47Jx3JQE8o2d0wbWEcBg4zNc1jszLmwhjb3yyrV8XM3tGDq2zIC86imwQX9i3OCQpcCM56irxbmS9aCHvb/2OahkFUIfwoeJCD6dC5UVxBZS+l6gDUjrfuWCBszyQk2ri2wTctzOY7vn6s/mfw8cw3YjtAgERhOOZ09IuWXpSGMv5lQapYCf47xlk8A60xN6bEV+Pz2zZVx6LLaWoC2KLyRrRlBsCfGUTnf9+X+2U8/uZSnLNSjtkWp6UGII6XkbFlGpiyPf2jnbH6p/k6FQ24f94kngisASnj6FW1S9Vwo63C9aNdIdbZZbBncN7A1t0G2bi4aStvcJtUODzQ7PmdlVTOSn3rhGjpL8y6PUILBzlVtZWCswzgxfUx4ltinEMwjA7LPOcmrqVtuESxvKAtWlCEzzEJVZWic0mRHfCuCBnvvkBxIc1BxKDJ4k7sUlnuHN3Zeb0XiSUKkNYtBbxcf6R3WZio+dxio0y9P8kCt9mvDv6X65bu+BVkAO/kY3V3XPqVMCddnzm6UjTznNtyk8VEqL3ZbswJB7es1XFhFu/Ep1cxHah4GtBEcp+/OdzhaBJM
 8rFF6PdV
 KYwww7Z2f99iMFNYiNe6O6Ytr9NWL3epXcWS7p2xhrPovUVUIkzwPhu/j0CG+xoIpQtr343hfkwab47WNdLK2RD/1A/a7qZyr27iAhBvDlcV6jsdYeNmy7OXJ/6Ey8VHBXYe5ffdaSSmA5OVmsdLj2uPFquEfKf8SqgFcOTFNj56K2BezpgjdPpOaGCfL0+tPaB1zRZ0Vy2Xfvj9KJjix+s6cN4F3NntChveGfe+SJcB/5Y9XKAxf7fuzDpek3W3b/uj1wKuRwsETduE4wzRbCo8y06l0XtUC6Py54N1t8XmjH8EO2Qo9do1HpfULuWpc2hnOinsRGmBX3fdjZc/Bw9L3och1g2ZuNndeAQe4CaxXsZ0AbFw11FCL2MLTbloxkPf07Oae2fZKbcrldEgXzZQkzc1r1PZ1CcUvNjUEKaN+r1IBXKC4lmx5Otog2MV/fXANLsNPyL/ijmPpoMvN1Zkce4UtPUj593mpt6qfQPYBtJpIxLYNxLnteo6YBAtaajWUHsufpH7k+c3Wmw3mQn3pjC+paVUBLJcmI6pITjEOOziascUb5aGTDhnXJl9ZNCAVn7b6pXc4c1guu4N2x259OaAQJwdlzzyhuvbLZEn8EZmbBMCJ2SrXFFb2KzJ+YGen
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide the debugfs config file to read or update the configuration.
Only a single process can open this file at a time, enforced using atomic
config_file_busy, to prevent concurrent access.

ksw_get_config() exposes the configuration pointer as const.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 include/linux/kstackwatch.h |   3 ++
 mm/kstackwatch/kernel.c     | 103 ++++++++++++++++++++++++++++++++++--
 2 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/include/linux/kstackwatch.h b/include/linux/kstackwatch.h
index dd00c4c8922e..ada5ac64190c 100644
--- a/include/linux/kstackwatch.h
+++ b/include/linux/kstackwatch.h
@@ -35,4 +35,7 @@ struct ksw_config {
 	char *user_input;
 };
 
+// singleton, only modified in kernel.c
+const struct ksw_config *ksw_get_config(void);
+
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 50104e78cf3d..87fef139f494 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,13 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/debugfs.h>
 #include <linux/kstackwatch.h>
 #include <linux/kstrtox.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 
+static atomic_t dbgfs_config_busy = ATOMIC_INIT(0);
 static struct ksw_config *ksw_config;
+static struct dentry *dbgfs_config;
+static struct dentry *dbgfs_dir;
 
 struct param_map {
 	const char *name;       /* long name */
@@ -76,7 +81,7 @@ static int ksw_parse_param(struct ksw_config *config, const char *key,
  * - sp_offset  |so (u16) : offset from stack pointer at func_offset
  * - watch_len  |wl (u16) : watch length (1,2,4,8)
  */
-static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
+static int ksw_parse_config(char *buf, struct ksw_config *config)
 {
 	char *part, *key, *val;
 	int ret;
@@ -111,18 +116,110 @@ static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
 	return 0;
 }
 
+static ssize_t ksw_dbgfs_read(struct file *file, char __user *buf, size_t count,
+			      loff_t *ppos)
+{
+	return simple_read_from_buffer(buf, count, ppos, ksw_config->user_input,
+		ksw_config->user_input ? strlen(ksw_config->user_input) : 0);
+}
+
+static ssize_t ksw_dbgfs_write(struct file *file, const char __user *buffer,
+			       size_t count, loff_t *ppos)
+{
+	char input[MAX_CONFIG_STR_LEN];
+	int ret;
+
+	if (count == 0 || count >= sizeof(input))
+		return -EINVAL;
+
+	if (copy_from_user(input, buffer, count))
+		return -EFAULT;
+
+	input[count] = '\0';
+	strim(input);
+
+	if (!strlen(input)) {
+		pr_info("config cleared\n");
+		return count;
+	}
+
+	ret = ksw_parse_config(input, ksw_config);
+	if (ret) {
+		pr_err("Failed to parse config %d\n", ret);
+		return ret;
+	}
+
+	return count;
+}
+
+static int ksw_dbgfs_open(struct inode *inode, struct file *file)
+{
+	if (atomic_cmpxchg(&dbgfs_config_busy, 0, 1))
+		return -EBUSY;
+	return 0;
+}
+
+static int ksw_dbgfs_release(struct inode *inode, struct file *file)
+{
+	atomic_set(&dbgfs_config_busy, 0);
+	return 0;
+}
+
+static const struct file_operations kstackwatch_fops = {
+	.owner = THIS_MODULE,
+	.open = ksw_dbgfs_open,
+	.read = ksw_dbgfs_read,
+	.write = ksw_dbgfs_write,
+	.release = ksw_dbgfs_release,
+	.llseek = default_llseek,
+};
+
+const struct ksw_config *ksw_get_config(void)
+{
+	return ksw_config;
+}
+
 static int __init kstackwatch_init(void)
 {
+	int ret = 0;
+
 	ksw_config = kzalloc(sizeof(*ksw_config), GFP_KERNEL);
-	if (!ksw_config)
-		return -ENOMEM;
+	if (!ksw_config) {
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	dbgfs_dir = debugfs_create_dir("kstackwatch", NULL);
+	if (!dbgfs_dir) {
+		ret = -ENOMEM;
+		goto err_dir;
+	}
+
+	dbgfs_config = debugfs_create_file("config", 0600, dbgfs_dir, NULL,
+				       &kstackwatch_fops);
+	if (!dbgfs_config) {
+		ret = -ENOMEM;
+		goto err_file;
+	}
 
 	pr_info("module loaded\n");
 	return 0;
+
+err_file:
+	debugfs_remove_recursive(dbgfs_dir);
+	dbgfs_dir = NULL;
+err_dir:
+	kfree(ksw_config);
+	ksw_config = NULL;
+err_alloc:
+	return ret;
 }
 
 static void __exit kstackwatch_exit(void)
 {
+	debugfs_remove_recursive(dbgfs_dir);
+	kfree(ksw_config->func_name);
+	kfree(ksw_config->user_input);
 	kfree(ksw_config);
 
 	pr_info("module unloaded\n");
-- 
2.43.0


