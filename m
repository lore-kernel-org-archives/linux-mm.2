Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A7C2CAC5B3
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01D0F8E0011; Wed, 24 Sep 2025 07:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36F88E0001; Wed, 24 Sep 2025 07:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E264C8E0011; Wed, 24 Sep 2025 07:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD6408E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:51:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75DAF1DFE53
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:59 +0000 (UTC)
X-FDA: 83923979958.25.9B22E2F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 913AFC0003
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T7XEKp+/";
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=chAO9GOTMxCV8ZHg6BsIF9VuSBV9TkSRS16Il152ztM=;
	b=PpS8WzHY3PFYCLqH5gjMRal7nV4tsVRKaPxZ1EeVwO0UhUIQ2tE3TmIoPo8QJxaTbS3BRy
	cnP/u3pGObQOiz4BIHOvyct6/JpNtGimMvgJTbhmATfA4gyEjmoufPv+fgtaQi9Batzdvr
	FtlWwgC1cqdOdkR+FqcjMnBkF9g1Znk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T7XEKp+/";
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714717; a=rsa-sha256;
	cv=none;
	b=v2jIHsEHtfV4X4q1J1aLtN67Hz6c9OAkcSPfipvhZZ1qZ9DS8E8O+i2ti5FSAyDpp0uMXR
	9jHSfBOqNlCPhF9BJ490O7mf/EWO/TMd9F684G5a9DO6kcO9PscD7v1YWNFc/HGqbq8Kbn
	puFXZ5T9kaX3rnn/DV1TlBJEz2vToGw=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-279e2554b5fso8209145ad.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714716; x=1759319516; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=chAO9GOTMxCV8ZHg6BsIF9VuSBV9TkSRS16Il152ztM=;
        b=T7XEKp+/ZQgsaYEluT6pMQl2bAcaIgzf40HaWeTLFNkCTYZnc189RzdXEZAOVUhlpJ
         CVD1JMptiADjuMriZXuLWq3F3LngA9O37Rvds1vHkvLmtnNcnc/H2PSiId6OFNK23vCQ
         A//4OQ6ay9Vn3QiiW8Szk4+T/2wfYLuQIFiVFeseP95pgtATD3h1V4lo58Em1nwlGrHV
         elY70BuidhrV5C1I3t3JhUePxiJpcz+hpa4DomOAs/g1s1X5Q4c6vadTXYvSCPNZ7xNf
         I8+EYRJtOoQpWGPuqGTkGIkz7dAwt/8+AQ3ZKAAHWIebcrrhao9U8SupTqg3lvbAP84K
         Ie/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714716; x=1759319516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=chAO9GOTMxCV8ZHg6BsIF9VuSBV9TkSRS16Il152ztM=;
        b=GTJvtiz2RydAcgiT//GkjcWjhUfttxbYPWM2QlNhSelbOA5pT7uIcYyUpMqxVrwV+Q
         MbdnENKguii2UtM3rG0az3VqkmqFxjIFb8yIn3vWpPQYv0yADtgUyj/XfgO8YuhMYRpf
         mGN0VuiYWxnGHdJyJ8bISCN1KYYVclzWVvv5ooHKS/1c7hCo764NiGP/UXD+07OznvyI
         62jhDGo3txcugZ4/NCDN+Tqwj6h2QLgyxVG+n9UJntJ+Naf0KVOAx2/fCwamLWKtWSdY
         Eg5jk1lu1pWniEee0q0fpJpwsgjJmJ39nG0yGZpeFTCwO1RvntQPBq2cyZXsxWAg7HSG
         /alw==
X-Forwarded-Encrypted: i=1; AJvYcCXWKzTHqe8rhZxJwoDHclWN6w1uKRg+VDGeFLkN07bO6GNsJ3Py7xRZdBUqbdppXBYngBd1lojQDg==@kvack.org
X-Gm-Message-State: AOJu0YxXXPkTTx9C1KinMeFfhgcURMtp4MmA61pCkaiwNTNDJuL5ciNY
	lbgw4r7M1H5VEzR5JeMmiB8V+WxyllWqigYbJnwYtdTMk1dAdBQMyOq9
X-Gm-Gg: ASbGncs5oV9jJU+zvw7cCZ6oexbPRfTjDfEOnqTuUOCvGOZ0/GLXlYiT8FgNA9mnNrq
	iiTrE4PMp0XE1LFVSst1+j/zGhGx3TUt0NjUdyJKpBB2c5FwmWYa5qVZAh691aIPKxEaIs3UN+1
	2GhCfdjZ1pzHhsoa3jRIj59njRMWMmG9aXwa/egAseyOz0cZs+ixc13Lb/H7JVVoBUI1j2OS7Fn
	hNnnUu8AgchdQByVu0ccNrwDD4MM1RULGgbEAYHjieqCkz01vqi3QGnURlF6szKy1evB+viuk8+
	hswrr6YCLCZLwTlSpzMqhGKneDtPUxEH6Gw2YteWU2y3vqwId2K+5Fs1fynTL4xP7yngPfOmmmd
	DywjwCCvMCaDnrn6BGvX2gYt0CA==
X-Google-Smtp-Source: AGHT+IFFFBAirf0qABtQMOGn8HizILgeTQ+bDMYj/NiaLIThYCj5lgAdNhjPQRMYiuEyFN0bl+W06w==
X-Received: by 2002:a17:903:19ef:b0:27d:6cb6:f7c2 with SMTP id d9443c01a7336-27ec11ff7d5mr23462095ad.17.1758714716359;
        Wed, 24 Sep 2025 04:51:56 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980179981sm188216855ad.54.2025.09.24.04.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:51:55 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH v5 06/23] mm/ksw: add singleton /proc/kstackwatch interface
Date: Wed, 24 Sep 2025 19:50:49 +0800
Message-ID: <20250924115124.194940-7-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 913AFC0003
X-Stat-Signature: 3hgo7ihfqj4y7sm7eqonzfg3t96j1zch
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758714717-337666
X-HE-Meta: U2FsdGVkX19BjURuacLvPTXZlhWQfB4DT8imVd3/UnCKlKU7PZUmxL3wBKiu54lhfVjWA+V4kg6aQKf1YOPLklwKbUc1jjKMR0e2/a5Z4t+Rdvf4axHrE4m+jo+MhGuMaunNGqNFEvjzSYZC89nlkZdZB1Yvv7GyvFokXaDJ3eBtEBo/U/tPxzP2QzfQIjUb9EJsqY8FDn1xmgsq60tBqbNtWid38FMHYAUCKU9eo2TYs0HZtDd7dF+fVirHSA2bIHlc3e0WX7a9wXzp6B1CT2ZOKabz/KiLA7wM95dMmjCRMXLrJhzVGRE0X11B3RJUGyWwqvMEd8bPHvExBCIcm8y1fSlBCf7divqS9EocXWgcnnwDD2bT16qayElRZSJ/bTAFOkUW2oY/hrMi+VF1NzTMIw9t+y8mtCXIStcSho7FAEo1av4DlLU8+TD6nuNTflSqll4LXGpRwYnW18RrWacUVk19J3Wqu/qL3wFcdwndBIX4Z2T0PpAan492+JQYoMzg+IKCAlF096AoFMH/naiIZtNGb/Dapbi/SCoLe6ZGOK+v+e9dDCd8SbXjNeFBR73+zqSVZwQqzijQBl8kEY7HxrTfLMPU7YsZ0eiKdNQBRgGAOB+BK5NYD6W+UiONu3ori7Sq65/y87XgSeKHPtOapTi4pOvYOIOQnPuhgXH53ZdjBeROhVIF56xIon5axjnUhPVR/NFjVmzH7O2qN4muQYdPC7EvwNax+YFGTq+TVh2V+TLctGeUnX3pyqQKtt6fyf7rb3FpGdpPCZGO7eCwu++Uh9Ea7tCw45tpXfX5rjsELECIqe3eqtHLzvv5GcSs+oe7gdILXjhk/nWFZil7dwv4KTx1Ggb4xe/5+98i0xREwkXmDBfApPq2nDkEtpxBArfdetJBuAzSsC8pEwwv2/dsYSfqoNA9Q8NdtRjPIdZGHifhJ0OHRePCWbNTiALPEIMRPleFpUxfHs2
 BUb+tr+r
 DAo5t4CT3wZxrb+LqRG1aXNcEalHzI7Xzt9y/5YCOyAbD5CAh07mnKy7KyVkKtfW1BLpWV/oHy+D3/cpnEJeFtsAMFKid9XT3dwSorQzd5nMoXvX3KonDQWLgycHjE+M/g/bIUn3S47SO6tK9C/xhdkO3gHrAmRWA9uBZcV0eQI8QijHY3F4kJo3++b8cCJaMrHnAkFOeaPRhkBnZUFqybEy27skn1eUt+qez9IBeeyY8c87UrO6GVhLsOXrYMHOkK8yIF0pXi7qN1W4KXwTuTNdL+j06gWsAyAz8xc1ZytkCvnBPLoWu9yWstOQfpqZ3rgVUmrTvV5KatZqTg/ReV3ELHmh6bUeKqcs6gqw6yK/uAy5nyZqiwZXrsFbOQ9k/Y3D8ovvJ0REKgmOyG5PJVUyQK+rZdISoaLV3VNcL3esrmlOBbtYAwuO4XSizeP/mHKDwckX1omu8X1orr/8Y6/Beyv3S9eFrAnNYCzjoKGeCMWzKrVh12HB1aKcJLT0sAU4Ip3FFOJv4uvJnmDnytSnJUPHsJvUUzQ9P8xKo6O/Rb2G5DsGF0lXO0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide the /proc/kstackwatch file to read or update the configuration.
Only a single process can open this file at a time, enforced using atomic
config_file_busy, to prevent concurrent access.

ksw_get_config() exposes the configuration pointer as const.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c      | 77 +++++++++++++++++++++++++++++++++++-
 mm/kstackwatch/kstackwatch.h |  3 ++
 2 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 3b7009033dd4..4a06ddadd9c7 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -3,11 +3,15 @@
 
 #include <linux/kstrtox.h>
 #include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 
 #include "kstackwatch.h"
 
 static struct ksw_config *ksw_config;
+static atomic_t config_file_busy = ATOMIC_INIT(0);
 
 struct param_map {
 	const char *name;       /* long name */
@@ -74,7 +78,7 @@ static int ksw_parse_param(struct ksw_config *config, const char *key,
  * - sp_offset  |so (u16) : offset from stack pointer at func_offset
  * - watch_len  |wl (u16) : watch length (1,2,4,8)
  */
-static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
+static int ksw_parse_config(char *buf, struct ksw_config *config)
 {
 	char *part, *key, *val;
 	int ret;
@@ -109,18 +113,89 @@ static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
 	return 0;
 }
 
+static ssize_t kstackwatch_proc_write(struct file *file,
+				      const char __user *buffer, size_t count,
+				      loff_t *pos)
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
+static int kstackwatch_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%s\n", ksw_config->user_input);
+	return 0;
+}
+
+static int kstackwatch_proc_open(struct inode *inode, struct file *file)
+{
+	if (atomic_cmpxchg(&config_file_busy, 0, 1))
+		return -EBUSY;
+
+	return single_open(file, kstackwatch_proc_show, NULL);
+}
+
+static int kstackwatch_proc_release(struct inode *inode, struct file *file)
+{
+	atomic_set(&config_file_busy, 0);
+	return single_release(inode, file);
+}
+
+static const struct proc_ops kstackwatch_proc_ops = {
+	.proc_open = kstackwatch_proc_open,
+	.proc_read = seq_read,
+	.proc_write = kstackwatch_proc_write,
+	.proc_lseek = seq_lseek,
+	.proc_release = kstackwatch_proc_release,
+};
+
+const struct ksw_config *ksw_get_config(void)
+{
+	return ksw_config;
+}
 static int __init kstackwatch_init(void)
 {
 	ksw_config = kzalloc(sizeof(*ksw_config), GFP_KERNEL);
 	if (!ksw_config)
 		return -ENOMEM;
 
+	if (!proc_create("kstackwatch", 0600, NULL, &kstackwatch_proc_ops)) {
+		pr_err("create proc kstackwatch fail");
+		kfree(ksw_config);
+		return -ENOMEM;
+	}
+
 	pr_info("module loaded\n");
 	return 0;
 }
 
 static void __exit kstackwatch_exit(void)
 {
+	remove_proc_entry("kstackwatch", NULL);
+	kfree(ksw_config->func_name);
+	kfree(ksw_config->user_input);
 	kfree(ksw_config);
 
 	pr_info("module unloaded\n");
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


