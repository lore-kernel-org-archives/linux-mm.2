Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A4D2CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714918E0017; Wed,  3 Sep 2025 20:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C4A98E0003; Wed,  3 Sep 2025 20:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58CDF8E0017; Wed,  3 Sep 2025 20:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44F078E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:23:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EBAFC0964
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:31 +0000 (UTC)
X-FDA: 83849669022.23.1AB9E1F
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2BF8E140005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FnoGJZZ3;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945409; a=rsa-sha256;
	cv=none;
	b=sq4Gx7Hs6OoaSJvUcChu7k0CkrQzoLm9+GdEFyUlo0g7AudmTmnWbSRSlwHFQloq8CFpeK
	Y1ryUyhK8wPczqiLwUSYexZpIHhZvTHgePVQ8Ntz/zPN83e6JOFOPeWmae+I3ZQOySnqda
	qVpahMcPmcP36txxK/Cg/WTKtP+AsNE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FnoGJZZ3;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7709ieFUlS+2MrC1zNfTfKDbThJkcQv3sQ/PEEU3R8=;
	b=gDMeoOQB457gIsyjP5Xj+FAqMvjOLevzXRFvodu1LqkgZ5+C37cxGMJ17F+2LNQfShQDEp
	gpdhAS8tX57tdhmxRipsx7GHwCfXXn07t6sCMfQjN+ElfX5aS1uTQOvZ6iGRaL9YRPMGJy
	Baf9SPYdYcZp52Yb3h3vahRO2OVmJOE=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77256e75eacso482641b3a.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945408; x=1757550208; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7709ieFUlS+2MrC1zNfTfKDbThJkcQv3sQ/PEEU3R8=;
        b=FnoGJZZ3AcB1+cNbBInpJdiqSLjz1ZVR8lSl8fO2ycUjFCoi/1Mkd2EQYAoyueE7OV
         FUWJ9/wK7mD1BysTgtbDzWLyhH9P8PYBIx/2zkkdSteJBFDSNq2sAX0J6JOFee5aBQQL
         f/TMyxJmB9ts1Cc0Qu/rG4jCZu3TVMB2UrCmMTaB2YMR1kCE5qRS6UYJ1+o4XBINX0Vf
         BudCkl1ok4UQeFGGKMZrTuNPvK50RKBEK5X9HiCDSJjzWnWOJX7/aYQwcA0La7ZkmNuf
         ICjo/bwt0ArP/ty47ZEZ/1n957ZFbF9xv2PavWmn48Jc/LajFrC9qsCNbVttYFFXLniH
         Hm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945408; x=1757550208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y7709ieFUlS+2MrC1zNfTfKDbThJkcQv3sQ/PEEU3R8=;
        b=DUUSriEBsikQ6070O2oEBIzgmZLMw1RfibpdIsorCRCggBFBVVrYCiyESiaGPWCD8I
         T1SHfnBip7Mr+MYNI9IrTq6lTX/w+6yj/rM7pERlWdpvmyviDClagmrbneSIobVGD3z2
         SR+dLAUuT8xD7Ob3ZCnIjqlyqNtQukfUtC/wRrWYyy+KWYu2VTW7Ein3miuFwvZ00i7L
         q9JiE1+yov1Q1/NbZhExYHPHBfBDqPXMtOKd/1Mej6RutUF3NTChyIq880CZb/JBoRrQ
         pOGydHZOb3lfQq9HFNydmzMHWDxzpVUFQ/FjdOXzLsGcwMbu3UVcGgeJmSAebjMutdD8
         3gUA==
X-Forwarded-Encrypted: i=1; AJvYcCXc0JmBLEi1pVeInYenCjgeJGZiiR3QyJLH6gpIuQH8kdMkGiJdk0bZ+IziOJEp9kEuGtUm1B30LQ==@kvack.org
X-Gm-Message-State: AOJu0Yz2ZZAeCgq79VaAo3qGXXWNBP4jMMZuf1Hkg3sh4KQ7i1SCPflf
	WLuQEx4g4L32Gnm/oXXgB2wgEHI7GIIjIIsufcZoyOlXRK3cvSVMz2fX
X-Gm-Gg: ASbGncv3Za1HP6I8YGLErzzInaktidMclpIKTY1OVMlRvp82DADGpxgKg3WwywKvGXs
	zEUEjy6G/G4ocEWqA9EEe6RTD2MiWWLDHk1dmvrj92efDAXqBzZErblR0Ym6BCN45Kvf1X4muPk
	RSU/IDZcjj4vZbWQXgzRmIbdabiJLltTs8Tkd0N2ZNScYBUxEBzO1EzYhCKX4RgHwEJ9nhe0O6d
	KklZqgcVoj34R+dFEiFARKGB2oH/mQQF8sW+MoYdQLGt9xKruS0uueOEf77l+gY5J7sF/sFjT8/
	eaGaUd2hB4j//u4zawBp650dhzi1cle1soHu6EgdkpqsV2JDqcvOY/bdg7LnCud9pIqnC1nDNqM
	4hdA8FBnnN+i/Mldb94W9DmC6xK9KTMweV8hJZj6TG7Jl2xiouGdO
X-Google-Smtp-Source: AGHT+IHhppPhCunvFzVZDYZ67D6HMJaD+bYACrgmc8Txd1zbRbMjBjJcCjKS/dJR/OMmvBRDlXJzhw==
X-Received: by 2002:a05:6a21:6daa:b0:243:d5ab:d1fc with SMTP id adf61e73a8af0-243d6dd7a45mr24329846637.7.1756945407888;
        Wed, 03 Sep 2025 17:23:27 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:23:27 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 11/18] mm/ksw: coordinate watch and stack for full functionality
Date: Thu,  4 Sep 2025 08:21:08 +0800
Message-ID: <20250904002126.1514566-12-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2BF8E140005
X-Stat-Signature: w1makjto8sp8oc1oamsw8rzwjhj6yy99
X-Rspam-User: 
X-HE-Tag: 1756945408-967028
X-HE-Meta: U2FsdGVkX1/7/AtWvk9yJOOGZXmtg5kF5VU8WK0Y0IOjlhq93KM6PkgGLZ4cbYAE7ZlFEqvA7ku9Yep2YtiQeuIZ9ubQ7vlnE8FwIZ/PMGRSzvo8bF7+RIF2COR+9szajc1RNmpNXgtbpHV+3GMCuYvoVZzQw+G6FLnQBb2qMCrbwGBlhVpD6Hxx34xxwqc8qPFvMzeUTqYPSa96WxQWqPhhviqnWORkJlZifzIuZfFJv+LxPb6DHVfsygkn6jGW0KnHVnplFNfOD/NToO4NCWuLknGacyVrMZ2WR3js30IO14swLs6D9ZcAY1iv2yIsLkBcWlP4B/u8qFb/91QdAFbZ06JtEo+N2lmYo9SchX1r/n9fK37IUQIGT2wV1/Hng9vP2eowUYJOntJhE8kFNPxGhc/wXAEjSRSnrIgMuOIinm1LYGD1VoFzhurLvLDD36DzC9GMoMY3Xdeu21HDErBsVgSB6o3HPUqT3oArhsp3dZcu2DF4l11an9qILizmQRCrSpPx8XHgYDtiynv0U3Ysq881MO6XBsOvUqolqnDydAIEWCWpMdQsjvdkJO/qWS3OPotwVUDkrvcr1cIduMGoU1NKGTg+3RuLVqnb/ciKaZJa/YeoBZjLtj25P/POlBKYSQoHOSDpNouoS/mPTkTnlsKHCInfXk2gkNb3WA4C86W8cDTfv8DkyeNMu+sY6laqO1KeuQNJvOZZi/A3r3qpM8/vc/azCcSMJtdlte8VJSGgUUuqiIDwftUpomdzTYanFflcf7telUDskqKgCtSPSKA6LbOyRAvnEZhbyqhPkAkrryHrmuARD/kITmpXajMb+T0tnIScdhR26pUE6hUQz9+YyBzDZPl7xsCkaPIwJk9XBN/r4LPikR/ne7wESc5dt01m4K6TF9bT0Saae/oZPdWW1l8fqL1cuGNvJqKQLmSkEe7o8KRe0PxpR92fzj3XxlO1IFI1SKDnAvF
 AYqQJcnt
 onRWqoTDnurWmpy3cTkLzF8d3s4+6DoPAGQwn/XK+Kmv5thPoSjJWrnIdDZ2HqGAY/sHkr44CC54nneGeunZ6Mu22koPpZpZRKCP8sUsS02W1ncq6zl9NeKwnLXXsnfgquE8afaetWWMm8uerFRCAH6ElcXZQc+92F+8FDCdAxonLodnSG0/aoCBbpZF9kDjB99X8oZz1MBAKZ7a8z7rY27Ffsypcvixx4jIoEVfzMJ8ftRM2OzodTGnKMQUT7rSIZdLe+M8qF6Zh2YGZ8/PbERvMsbPrUpCR1gVxInLqPzCzIk0Jg92Vl/z1uf9ckVGGNq4Nh+MJa2hUOuh7i53Xire+2Z2GD36COD/pGkKSL2CTxujF1O4Gahb/ahxvIRyJfGmVeZ7RvQPq6865nEWAlZTeVHYrt0tAZF1TCfvcyH/Bw1dPpThI/TuTJy+wBplQOEUqCT6ytliQFJS7S0JyDNu30GqHMhs1GekTkwb/UYPrb1GJj+UJbMxWmE2TtUSZmA3V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch connects the watch and stack so that all components function
together.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 95ade95abde1..4c5fbcaddab0 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,10 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/kern_levels.h>
+#include <linux/kernel.h>
 #include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/utsname.h>
 
 #include "kstackwatch.h"
 
@@ -22,6 +25,29 @@ MODULE_PARM_DESC(panic_on_catch,
 
 static int ksw_start_watching(void)
 {
+	int ret;
+
+	if (strlen(ksw_config->function) == 0) {
+		pr_err("KSW: no target function specified\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Watch init will preallocate the HWBP,
+	 * so it must happen before stack init
+	 */
+	ret = ksw_watch_init(ksw_config);
+	if (ret) {
+		pr_err("KSW: ksw_watch_init ret: %d\n", ret);
+		return ret;
+	}
+
+	ret = ksw_stack_init(ksw_config);
+	if (ret) {
+		pr_err("KSW: ksw_stack_init_fprobe ret: %d\n", ret);
+		ksw_watch_exit();
+		return ret;
+	}
 	watching_active = true;
 
 	pr_info("KSW: start watching %s\n", ksw_config->config_str);
@@ -30,6 +56,8 @@ static int ksw_start_watching(void)
 
 static void ksw_stop_watching(void)
 {
+	ksw_stack_exit();
+	ksw_watch_exit();
 	watching_active = false;
 
 	pr_info("KSW: stop watching %s\n", ksw_config->config_str);
-- 
2.43.0


