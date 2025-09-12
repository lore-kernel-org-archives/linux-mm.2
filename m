Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3B6CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC9F8E0024; Fri, 12 Sep 2025 06:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94418E0005; Fri, 12 Sep 2025 06:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CE58E0024; Fri, 12 Sep 2025 06:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFED88E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86DCD86D45
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:29 +0000 (UTC)
X-FDA: 83880183618.03.8445AE9
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id A5A8410000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EOtpSRKq;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Btw7JeEHjCHi0fmk72XeSdeksiIjhqX1c6woWjS/nBg=;
	b=CqRjz7XkAlQ3p1jwBDpnjem7LVJq+pcLa+9HbCap4U8pA9rOuiiEQPkst3swtYy6ZC10wI
	7Y8D0z6ggg7e746oQp/BYklttfrZ23iGY9svsUcfpCquOET5cgyleSTLXZgOSse1fP1sNx
	Uik9YDmVVZRTrgzhPG1gTYwsAXjYkWg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671947; a=rsa-sha256;
	cv=none;
	b=Rvr5+gTth/+duJs7+UugwSAyG66j39kIpiBtE0ixEl0ohj7wYaPvuJZI1KKqVM2F+ZnTLo
	8C1XmhsxypQeuDes3Zc10ITzPPngfUXsQl80vVqZoaaeo6aVyasbZPES1N+2e61DpZv4vX
	LLtJ9iiP0yYTd9yyYm9Wn5mTgNMVFzs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EOtpSRKq;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-32df1321879so198204a91.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671946; x=1758276746; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Btw7JeEHjCHi0fmk72XeSdeksiIjhqX1c6woWjS/nBg=;
        b=EOtpSRKqw1wQT4UNB5Uu5BJoR4EROcjVyfCyTUnqGCGgGV/jxkdu/6EkD82924yuGS
         LC/M9uG3F3aRXngOcklTN594diIMRJ89uc0yJG97j1w4svB6lg52F8Giji+GLy7h5vK7
         ekPcyzHclUmNe5F9jVGkIaDAygsJGzvXsf/SKj6B9HZfFNckXOE5gtf20lXh9LY4BXNf
         9Fwuo02cseqzABaIJ53Il5BGVA+/q7FZrNHyPCyfwjdrYxhXJvva4hAkmIGx6dkI4uTn
         OzhX0tpeplSdVS7A1D7yCdLL0rD9+urAlfYSpg+tFX5AwPjZNdhEp0fPek/54VOvD3Nv
         X2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671946; x=1758276746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Btw7JeEHjCHi0fmk72XeSdeksiIjhqX1c6woWjS/nBg=;
        b=SY4uZ+kSCk2MWirY4eqvebp7pfj/GKIpbBPOEnA5hOTuP9I3tIi4gQORehkJWOiu0d
         Yp6dnpEoVYfsqvtnDsZb0BcVBkQWOquuZGN8rU40DIXfiuwZqt2d1nz9ucjueUsSBVD9
         0zCqaiTsd7GKDRagzOp1Lq8jzAA4FtCMsGQ0zDgwPJmf5u0iN+JO8yb+/iRj8Os4eeql
         NCwT1wQwh3GQ9UM43J0ZiyjndVQokL04QhsZpvZThqBCJJ+Ie1JmgluQ1vKUNdfrnHks
         tbrl4i/iGaixXqP0XtDNPB4yDuwIGM2MHBS37uMtT2VKGgIrK9zIBunPOq5kz84nRPO0
         1+yg==
X-Forwarded-Encrypted: i=1; AJvYcCWne2tS/IDsqMltmUbtJcTO6WlDfDTpPQ3FY/GyMiJlnEU+Jdz07uXk/+hgIiEcxKs553k/xOoLAQ==@kvack.org
X-Gm-Message-State: AOJu0YyD/ZnbtDYVeGoRjbhRdL+RceHmoEkqwaN9VsX7syLE9sR8+V0D
	kYlkm93u00/m03KuoT75PiyVeZusNyZXyhg7cfTIkjsFsujBZlv2kvhY
X-Gm-Gg: ASbGncvHxpJGCoOEhaPs1xyXqgGbJfB5FZFPIS40piCF4oAsmB1h6BrUwkp7cxHHFLc
	RBiDky8H77iTkecFrIjEHk0H98oha/kwGXECh1O4ouJLoKwZSNOYYa3lMiW0Kbbxe0vWQFdRWQM
	KSxA5csHTy9RWdT7GXYTaLWTAIr2B3OCJRnAMTDTCskft08/SpOnZ2HsGW8ptapbT5mJblnMqef
	oT8bASecmEFGcyL7WtluhhxAG69YCgqZIml2/KJpgDYG9KKiUxX0/DLlevotFFDQ3fF++DeH1mr
	69/CcZHAHB/HvJcP64nhh39uesCaBIL1rfGnRo5Nywu3gHIQKNSgwv/hiPSu+KN9n/aWYH1I55w
	W5qljH9WlT/xcdL6pS0FFuUDBnzZzDImb4PfQGhjmaKaw8xjaug==
X-Google-Smtp-Source: AGHT+IE+sH0wcZG9HaKcll5QXaOw6VOwT34jJJKFyIXbetNwLJVfpmHy9Irzue+96yqtkUewE0lXYQ==
X-Received: by 2002:a17:90b:534e:b0:32b:df0e:928f with SMTP id 98e67ed59e1d1-32de4fb9a28mr2940174a91.37.1757671946347;
        Fri, 12 Sep 2025 03:12:26 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607a48c19sm4972892b3a.36.2025.09.12.03.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:25 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
Subject: [PATCH v4 06/21] mm/ksw: add singleton /proc/kstackwatch interface
Date: Fri, 12 Sep 2025 18:11:16 +0800
Message-ID: <20250912101145.465708-7-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A5A8410000E
X-Stat-Signature: hr51zsegas7ms3w8km61zg448fthdomp
X-Rspam-User: 
X-HE-Tag: 1757671947-104047
X-HE-Meta: U2FsdGVkX19GolECr0DOfEkJQQXdi+mq1vNge6TtYQaF4BsstXSPFz7SG7VTJTuyJHwbyUOtFcddNVG79l880d/KRZ4/0JDtJYS91sXg9EILxEebOxqAC5J2YfI4Qg2yRi3B/etvWzFMUyyOOJPJyASYBtl9tGkMYus5B8a23ZD5e2mhRIQjjX8ck2z0aM6okmb5jtVee9EisuB6XwXAZQ8EByfJZB/jkBmzlRKZtb8euuX9ciDSN6aaGtkY8gONZgqZGa8/Vrboh2MrG2/R9A2pK646vf1MVXjs75FjyLvuXSqeAVbDcktG65F5bu0tVIXOQ99s2S53r3pkw+kk41fqxM16wiiNtAWOMjNz3OcSUJYAs1oVSUdEIzigOOCHUlswhCENVVb3ZRKTx90JFziG0aQufpKljWbejlqppwWTEFQ+YQgQRCq5t7/N+GBWDOa7Jfu5b2EB3Bnr8mQCmh++Zo2UoQGhV6L/8k4LLsF696fn0RxQeZxKf3pvwtcpyMFwF8b6Aq0fmtCmCaO9WaNyOANCau8XTPOu8PHqM8ZJqGFvxxZ7FaUa3WN4llFYrtgnuR7oQH3GIXbP8SGunySnUqk98JblVfX1iXwYZIzkir2tzgGOuIlPZPy3cZKn0ZOUc2RH21maVF86ECEF34Cmua7BOobAZOldisyv1pFOzsSMAH0UgC0xPTg9pLZ4QBHxjS4ywmsVHXmRa0Vc/GUDLi06WbLRGyacFnL+uVE79LCd7JNfvuC4P4tVeYF0DIjg3r26GoYHwSwfou16OhHr4FlvW6LmFh8FeWczNLO7w70MBildhujqam6tBMNKF4BwXlX52ANNmHCDof0ZVO+FrAeAPVeO3eFvcK6xxNZysLJyn7LzaWv7QRmk4B5Rg5E239a82ytNtu1ZNxTGPMgKFINtxPsuVYUJ8UkwARglLXBOShLBH38rx4nb3QKf8mm0f8V/akh72vF6BK8
 DWpcH/Ax
 yzMMqq+lqz5aOmFLKgTqaFFlW0flJmDUJHktIacTnPknU5thW2sGzif/IRADjIYgBazwG8kT8/cgSpbSrVfo+UyG/+7Xuyedt4wqC1kN6+GQREj6z3hKjDmn+RGE6uNi/JMEzH/Bw7x+LZfxLh8AZCc+8T3qeBeBzUrstBLWSrwJnnAASyIFSnGZnDH5wBJYVN33nOE3f6f5wWENWVta0GIWOUrJ5fXybwTLG2meYvoiSMlq1ifJ5yqFRxTmSrCgdEo4oWyDvc5mQZbJFvnrcZ8U/kz1TcV2h6/c6QsG4TBtwy5t81yFMPiriIgt/lQHNK6Dsjkn9zDQYjfewz4k9zM6c3dp/48SBzZF5AuWLfpPxGoef1Kb76x/e5RaogeBz6dXUxe7dPEArqDj455Uzvxos6tDAqq7dyqel83AN7NjRth+1sN8aT5GZTASKvpM1yYpqGV8hNKsQwqDHL+7xqwBJEFCDnMlquEF7aBEFlJ2uaTeu2WteJ0jpndyVuWAS9AFiA61ISh8JHTGFHEeE+8d7JcKs0dF10MK/cAYsqC1JWBhpb93Ohry8kn8CAntLp4TtvMKTq25uGQP9UOLNI7aUj5NIikLyQiqifTmiY4ErlIVslqfDD4YAdmcXunIfaKfx
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
 mm/kstackwatch/kernel.c      | 75 +++++++++++++++++++++++++++++++++++-
 mm/kstackwatch/kstackwatch.h |  3 ++
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 1502795e02af..8e1dca45003e 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -3,7 +3,10 @@
 
 #include <linux/kstrtox.h>
 #include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 
 #include "kstackwatch.h"
 
@@ -12,6 +15,7 @@ MODULE_DESCRIPTION("Kernel Stack Watch");
 MODULE_LICENSE("GPL");
 
 static struct ksw_config *ksw_config;
+static atomic_t config_file_busy = ATOMIC_INIT(0);
 
 /*
  * Format of the configuration string:
@@ -23,7 +27,7 @@ static struct ksw_config *ksw_config;
  * - local_var_offset : offset from the stack pointer at function+ip_offset
  * - local_var_len    : length of the local variable(1,2,4,8)
  */
-static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
+static int ksw_parse_config(char *buf, struct ksw_config *config)
 {
 	char *func_part, *local_var_part = NULL;
 	char *token;
@@ -92,18 +96,87 @@ static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
 	return -EINVAL;
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
+	seq_printf(m, "%s\n", ksw_config->config_str);
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
 	kfree(ksw_config);
 
 	pr_info("module unloaded\n");
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 7c595c5c24d1..277b192f80fa 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -35,4 +35,7 @@ struct ksw_config {
 	char config_str[MAX_CONFIG_STR_LEN];
 };
 
+// singleton, only modified in kernel.c
+const struct ksw_config *ksw_get_config(void);
+
 #endif /* _KSTACKWATCH_H */
-- 
2.43.0


