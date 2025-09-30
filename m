Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE39CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E44F8E0027; Mon, 29 Sep 2025 22:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6942E8E0002; Mon, 29 Sep 2025 22:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C928E0027; Mon, 29 Sep 2025 22:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 403B98E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:44:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D70C11605AC
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:53 +0000 (UTC)
X-FDA: 83944374066.05.6B6D56A
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 03C9810000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mu6SwbwO;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tH9NPPXYzjzWmBeV5TNMSRB6I94mkI1pmHDAIM87ayY=;
	b=NaWKTDwgRKcRm5Nu4A+nabptX6PrP6xiNLcj03PKnY+xpo59zVebeOs24IF9xJFzkxPHfw
	v8+uNSAk0q2zCgmyRVETzuA0Dt+uDgUY/Ajbd84M6etsp1mgMrUy05Zgb+8RR2IO5fcT0e
	oJ7QPuZpfM9zNiQY/hZMmkypL/RtpPc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200292; a=rsa-sha256;
	cv=none;
	b=AUAOQ9mg28kbWiXZBpYTdrj8L8Y5t4RxY00iW6m5EVnvqnS6VfYD3GX8clv1ZB3W8u9zQG
	+yELfx4+zwCrfAm7yzd1flhsbQHpmhSRjcOPdtVJWEWdDKRKECCTAu+X4AGXrKWNS4ci4q
	lMLcuUbFZ+99wTg63cbf3YyY8qVxe2I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mu6SwbwO;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-330a4d4359bso4899674a91.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200291; x=1759805091; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tH9NPPXYzjzWmBeV5TNMSRB6I94mkI1pmHDAIM87ayY=;
        b=Mu6SwbwO/48dAxKNbVxarBIzbAebCKPUos73N4HY0+a1Zx7MsdKKuNAKoHWAGMX7YP
         8nEg1AJKt0MguMaNg9Azj8OLlq56NeJMH5MO9BymVh1sLaIJ9ZiPQ1fvAMJs6u70oxPS
         Nk3iTvIFqSRi/JeMIhIXdESuTiCoryRpdUvi0/l5tHY+9hfTGuWKf5vp91+aRGR/YwmQ
         p+T757SAqQYeEi7adlRoqNnn6u1Ypk3DqZZcCc4iDo/NuaCMp1iklNqCoO+ngydt2wl9
         iRMMR8ieaVEAkFtg4nu5Gb2FpeCGYLh+BnQC1XScLCFWfTn8eRobu69VEtCfZoVIv+8U
         /zhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200291; x=1759805091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tH9NPPXYzjzWmBeV5TNMSRB6I94mkI1pmHDAIM87ayY=;
        b=pBuaQ/cmtb/VZ1ozQQ1Dza6xWAv7rbtHmBZCSTlFKHwr5wd4o+dekmetVALLdtdsur
         BysKKLaoNS5cAj5gWJmjIMeBSppXqhIkOfEcg5kFUpAdp/6bmhxAY5SRFDipKnSnOFkx
         /E5oUDbg76Qg4zs1Q/EziDmLmjH8GryUrieyAxdpYC3hZXRlwpXsTq+VNY0JgXOBf1qb
         imHbkAFCVNmq8v/IfCHRWAhOpF1Oxywltdq9WlUBiVAFpZRtxbN5ytcvblFt91fzvXtV
         lMREre5ecD7YqdkTMCGxwT4ewvO/qkcQyfznRrSCiHoTMVqukqWhLAChY9pcpPrLb4Ym
         vVkA==
X-Forwarded-Encrypted: i=1; AJvYcCXsH5eY7lXITmBWzdcTKMKzxwnWgvaZEd40Wnt1QCBVsVLg1fug9l+vopyYmC11cBGi2UXApCtaAw==@kvack.org
X-Gm-Message-State: AOJu0YwXwQ0ct9N1aOHbXoYF2PnrNnVZl2EGYQc24xYiMY5KCwDpbT68
	Dmx1zASG4hNU3AiAmRf9Wj3wxWX/hBCGuj2VxlDAeRjGY4ysZQr0PwjL
X-Gm-Gg: ASbGncvVdnZjMrC8ub+NkeEhWwiIAEgsYye5zTUr6WRYDpdFeNY03/qeu4/fAA5fJAL
	kF15CRfKVznfony959hnBZ1cjiDjTVwhKI3w6RNGMK1eiiMGum5ogLSAe/iEPe7tMTc5oL1lJVh
	ethdeNZrleKHtsqUXpoPxwqRVJ1Suhf6HrtcYs1yOo6o1OK5Q29pb6VewfjuNoJ6GZToWOeqGhn
	qSlqIRXlKUa/Y02aMoh0NpW278z6xozxHLs3nE347dAZj0yUOk1/ESEuZ3blufUFr/byQcDM2ie
	q2PjL/R3cHaOMtyT555eNQCjILAhzhp7yP6UT57g1nxsqwFvvct6+6HUMumjVJB+xojfOCK17eO
	Vl6zaEDrTcjzTvR3j5/CwudY8XuwHVyJmVMoIXftEkwWfmllYi9Z1Uw6YCi/2sdzOGB3VXtoyfU
	v/
X-Google-Smtp-Source: AGHT+IFVE9O//P1+ssBUOG8eBG1xptc20Z1rkKT0r8Peul+CYAeELZZLuPAbA8MMh6puLAlFfjJIyA==
X-Received: by 2002:a17:90b:3ece:b0:32b:6145:fa63 with SMTP id 98e67ed59e1d1-3342a216f73mr19097573a91.4.1759200290701;
        Mon, 29 Sep 2025 19:44:50 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3341be38382sm18526671a91.25.2025.09.29.19.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:44:50 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
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
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v6 06/23] mm/ksw: add singleton debugfs interface
Date: Tue, 30 Sep 2025 10:43:27 +0800
Message-ID: <20250930024402.1043776-7-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u5xmn3iybxofhjaxpzwqzfwd8z9a9tt7
X-Rspam-User: 
X-Rspamd-Queue-Id: 03C9810000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1759200291-965227
X-HE-Meta: U2FsdGVkX18xuwwtpCDafz0HNPOyoRq8m+T3HKb9ei+XkQMfl/IK6itxk7rw8XuKm5tTC0XStj+oQeh1Yl/zXln04H/I7otPDWLohyjR0YrOjfnH8I/SY7fZzZsyYk1WENwmHRZ1DPH7tfdnt605d8psPiROSJB6Qz+YDmLcFpXzw01UXntTgqMIi4rSpvxBrzNRTRFkBo5QKSPDlJYXUX7NIbkQ0T7Ytww3CwD2nZe9Ftturdwtk7GwBMwwlLreFclavZwc99u5ZnJZ6ePVmUhSAr/6FHsTqisyNhKHddQoahKFUvCTItTrnxNEixHJnDTG3SAd29a5Ng8tNm3HX22Sp1JQrQC50lE5D/+lz8lj0zwaWuwg9hSEYrcIde6P8qghSi/ufapqhtwBWkORX4WwQRVG0Jh75geZfrsOLU1l7qMWul+XwWZGn8z+zZ3X0DSJxHymKrX20ZA3+q4xTFlQa29/0mnpxpymZQZixQjnEFeZfh6YYQsXFmT4+HPMgpseOs9ZGa2kr2LAz1m8G32qEHXu1+slEDVcO3J8+lgszdYu5aINapCSjnRbJatsMi9O5QeQ5bBHgv8z/W0HLYNFV1FvPO7KMz8uMs5R/7E7WVJjDj8Dq8odPI05LoSqqyWaeW+Vjmny9cIMkVDaZ6fCa0BHmOhDoVCikRy1kghZ3ltzqgeZR9WqDrWrPEmDI21AvP0p80rxyovjE/icaRXwz0cz6Wo9umdr/vz0eU/9DpWa1DE1DZ6IFYJTOq0Vx8cjEaL3kouuko1k0mQ9wVOq9pCDrSM9WZZDPNxMKsyJPVnNnHJmNYgoL+dP7RtNBxoGYhSh30iPYawcUk61a44kYURWmmZ88HFOMPZT3A4ZwX1R4OEtLLR6RcmgCi581mWyvYkhefzSsIFGThvqaudelZJ/0iGnizZDj7UqNh0XlDifo/mOUloDcAWGju2jElUn5Oj95MjBUgeSgnj
 BwkHg/K5
 2XDonw+npJX71RqJgZnDA46AI5UfkQTDSeC0R6KUs9t/5GnWG2CX+EPcxjeVJOxfwMcyFAL3Zxx2IwY8yx4xYmq8/vR4Ic7byPFMj8bTAuXKeIJfznmImXxPhE4hW1GPR0Gvyp/u+txkLnf6Jvhi67zVvslkMA+xO1+htWLBatkGUukeEgEM30YEm8NEcycH5jzfJ86AZuD++hawjmqVt3U3bOQz2wWQDPqUWmENcQ1b2RZhZnifeO15VzQXN4OpBYgIyxIeJkUz6KFJUoumL+wnenqaeUQXqRIRqHbUdqCX3S3Mj32mlAH/w54bPk+b73Xsl58vGGqD4EA4f1eAf1EUTBAeR+B8otPzDyclyRYH4E7a48K2qiarWi4DpvlTVcauVrEfurKwd2Rr0tQwGeWKb04cgpng/KoQJnFr32fwLoBkt7TKwyhaHweyBmFGSWih3zUXQ5XFrfO7Ji368bbqXk6AUPHorVpEp3x4bEgyq9LbCBSj7CDnMoJEjtS1xgJmDex6rEsGvq5Frin2y6X8g/8+mJKEczhAzff/zR2Mu4d9wuk1IcnTEHY4yh88BNeOI7ku8ebT0lwRgHfFgUmEspw==
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
 mm/kstackwatch/kernel.c      | 104 +++++++++++++++++++++++++++++++++--
 mm/kstackwatch/kstackwatch.h |   3 +
 2 files changed, 103 insertions(+), 4 deletions(-)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 3b7009033dd4..898ebb2966fe 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,13 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/debugfs.h>
 #include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 
 #include "kstackwatch.h"
 
+static atomic_t dbgfs_config_busy = ATOMIC_INIT(0);
 static struct ksw_config *ksw_config;
+static struct dentry *dbgfs_config;
+static struct dentry *dbgfs_dir;
 
 struct param_map {
 	const char *name;       /* long name */
@@ -74,7 +79,7 @@ static int ksw_parse_param(struct ksw_config *config, const char *key,
  * - sp_offset  |so (u16) : offset from stack pointer at func_offset
  * - watch_len  |wl (u16) : watch length (1,2,4,8)
  */
-static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
+static int ksw_parse_config(char *buf, struct ksw_config *config)
 {
 	char *part, *key, *val;
 	int ret;
@@ -109,20 +114,111 @@ static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
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
-
 	pr_info("module unloaded\n");
 }
 
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index a7bad207f863..983125d5cf18 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -29,4 +29,7 @@ struct ksw_config {
 	char *user_input;
 };
 
+// singleton, only modified in kernel.c
+const struct ksw_config *ksw_get_config(void);
+
 #endif /* _KSTACKWATCH_H */
-- 
2.43.0


