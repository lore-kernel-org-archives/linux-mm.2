Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C62B3CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5288E000E; Wed,  3 Sep 2025 20:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254CD8E0003; Wed,  3 Sep 2025 20:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D878E000E; Wed,  3 Sep 2025 20:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F012A8E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:22:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B905A86801
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:18 +0000 (UTC)
X-FDA: 83849665956.11.41B9A87
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29D97A0012
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IAYtpMEm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945336; a=rsa-sha256;
	cv=none;
	b=7kLDuM8VEgwm3Gs6QKwBLMNV+0cgXaiyn/DlHA2ks1OdBs5Htn//r3m0Sp72YK6oq753qP
	5ZAAygsm65n8NEJlNLRKO7WwaDtE9NlK0djBIGeJm5QiiaOV/15ymR4l0A2sbc/pZaef48
	z8jmBi0Hd75rUGEbmNnyQR9SDdZbaBw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IAYtpMEm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVjzrm6vJvhOYeF4QMjv0eGIgiL9m2bJu49WtrTbuMs=;
	b=i/Yzk98wb2TO2THUAClW1w8Nl25uCOxmy6spDNXFN1aIttAp8rWfM/e+iwQhKsJ0MDggH9
	PuGfK/n7eiayH5011nhvUHxmC1XHBAU10jI0sGvkukrggldkiS1+dGoBiPhHw/onyATgUB
	ana4Nwt1s8LB7fHPvTtmJyDlfi2i5tM=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-77246079bc9so528880b3a.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945335; x=1757550135; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVjzrm6vJvhOYeF4QMjv0eGIgiL9m2bJu49WtrTbuMs=;
        b=IAYtpMEmTZ4sPJKGLzMWtVELkb8xvWdHe2REY6BmmEDMJw2UepiuOfz2umUYcJGsbR
         d5Vmv+H2DvXc4EqTCMjPyzFmEoqaLVJV30hRAR/MRNBxGxz/ZTouahpLbEfs5xxnETDG
         c9HJ3Is6YK9lSG9qs/aZjRNUwOX8U9TQbFekejBoDUl1qIzas+40YzC5AE/F9JNt2C24
         R0X/H7jACSYtUOTHYCaNLucHJxZzQ3DZXN+Jx91q5uvJWF/DlIxunH3BRfyQxpsnODLp
         9NDBBV1Fuy/3eeFf+TLxQwWS9NX/mTZ4U86mBieH+WSAuTTRreHKV7IiiVJgNIX0OETr
         6uEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945335; x=1757550135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVjzrm6vJvhOYeF4QMjv0eGIgiL9m2bJu49WtrTbuMs=;
        b=Q8XSniPOrZR3vwvU1dq2iCQKqItwQK5keOaS6PJyVF8XeFCMruz6901/hO+1kpdqEI
         WDzbKB/tPsTbkRhEWOSl+BMR1pFPxII9M84Ewo+6mBd7x2PyXH5sOUFm9G4JroO0ms4n
         BigW4nvpN7cwMEJEq2gk8F40ljx28odxFYh4UZ8yNvBWv33r2xnJztnOm9D9fXQQWPtv
         bbiVz4H30i6FLdVxlvrcXPdw1v8nLk5hKfCWZ38m55mYKHew3/mfABcqfHq2EmvxWUUm
         db2Ol6p/q6mNVLWx4kTyxeUU/UYAzU9cF2zE/QXceC/T7PMTZQEUMDutUyYq47hlNevP
         qO7w==
X-Forwarded-Encrypted: i=1; AJvYcCW8EWmIl2AyWZY972EbJd8rZ9u7l2r5+GFpTTFTtmziMeYKX7MJEzZBmzdc9Wt20COMIrnAAInKbw==@kvack.org
X-Gm-Message-State: AOJu0YwX3vCWhMoc8DAUDGtfwvyFWquuJj7NcTEsV3SxCTtD+nPpxQRj
	U3Pv2vnE+qatbGXqsUv4PiSTP3RWdtdNbaCeXz5RH0bea4Mt+Qe8RsFo
X-Gm-Gg: ASbGnctAINt+ykRu7RKHGghokJeCV4aC8WYUl8DtlER0Yz3IrtH8dhy1CdIMlByOKBa
	CUE03LBOva5dK3/TR4ZKYksAt3HT2GdtTytxyEdosggrhI+YMo7kkoaqGeZyh0gxFVf/3/yAIPS
	Iwk4+u52o9pZNxXJCPebhCO/NWv+IZ/ZhH/SxsrPpq5AwIoEkItxQCLcDIdvlbQvAqFShVEtD1T
	L8mfULr2fQPPqkj66UPMj1VW2v56k/617uXlt9tsCXfo7GPWfYOBuER/Y0PfvLqLxdPhbjOsVXz
	Yqg2BjHGpLoabVLFRgeNjxJMBGaFUZq3Dz02mzMeBYEVxoePdGet+VwSsDXMaoJn+wapbKcf63U
	2MAD3ZZ2xu93zkjv/GRzRV26kB8fvl+W9/8xJL0qGv0lyg5hA4AXN
X-Google-Smtp-Source: AGHT+IHi/o/IAm0vynFn2e/IsWAicKmyi78tP6aMpCX3iR0UzR1wOUQxX5ciC3ig3wFrcV6Iy1bIqQ==
X-Received: by 2002:a05:6a20:7484:b0:243:9312:4fb4 with SMTP id adf61e73a8af0-243d6f86b99mr26405251637.52.1756945334920;
        Wed, 03 Sep 2025 17:22:14 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:22:14 -0700 (PDT)
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
Subject: [PATCH v2 03/18] mm/ksw: add /proc/kstackwatch interface
Date: Thu,  4 Sep 2025 08:21:00 +0800
Message-ID: <20250904002126.1514566-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 29D97A0012
X-Stat-Signature: x4ie7bmhuysax7xz3f5ao9tism8pghs8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756945335-81075
X-HE-Meta: U2FsdGVkX1/Zo30CgtqHPTDUhP/HX2NxsQxWmblF43N5JJNyORWfQls1PqjUU1VA0a/upLHjKkyl3zs2SbrcY3Rl9tE70CGX6DVcQ2z65IaOxhftAzBIOaDdkiXv2aUoPjlZhCbIBKzfL8mVkYGopbQYiF1EA4pNgXRL8ywUqfgD+d6k2z/4XHNNJE3Xjwa6yvVdh+YtP/ac41/08MnNifu4dNinPrrFGN40IB1PkCes1gD2pYLHzfdpTdIClOzulG62aH1x1MQdGtvBkkUHvR1AhoI9tlZVBWcXIQW97dMntCcFlMgIif5ab/oBoGZf7iFlDZTIG6wsrlkv/3UdSnatPIobVJejiy9CYamF+c7McROLiV4Ec/d9MtkTX8orA8YoUWe0NaJJDOHXC+8wIyyfreI4m7WEpGr5OEBIFShcBrmYWbJk1V6vxtXSN3yVpSduJM/zxpGiRHO8ND1mqmh+MviOiO2vrvaB5c5PjjEZVzkhnOBgZw9stm0CNtZgyzSSoFCGpWhPPr76D+NUMhSTfJy4wTXklDTIPGXQbGwdLTGov9NwSM4a2veizNMb2GyzQQ1f5qA40rXeXRGgE+KUOuVgesZJ0fGn8gc9VL5ucAV6RadG4z5fCYJVLqC7qRpM4TciwyrUa4+Av121CI23lCVgGmQtpcCNF+K/coRV8QtaDBHfz/F78/tCdLW+oRNlbQ2fZl1UWVeQUTTU8mlpUBMP2JPRb/l+b0uCAYK4ZfZgga3YQKHnbMPfUF8PXNoN02Mh1WsXQ9rV/xImoSITlb7RrJ97/rHJA7kEi/t/qENOIHnu2GSOA40W0ORtHBF7uEMmiiM+bjyroeqyRpxc/qWe4/FfzoawnH8cdu8P58YdwLc50mRewi53asc0dM/n8vZWosm8FbTBzLep68GqA+mB8KRqscATx2Mp0wYoVM3/emvqeqs/Ujix0SKD0HRTYLwoKKIMNxiI0rd
 fGbbgdRu
 XGPHr/bi4FGwg7Y8hHQQD1EYRvwXiiGQpIT6xaUDlOqqGv/z3AGmSCMIxu2yuaZYdu7yPb6d40tdD3+wuJHX36k1xHPIMaOKz0tq2+K14B5LKMuYO+nfihXAYr5J86bO4LhvsXRHoldS4Z5tDviLMUm52f5DzBBYpp0U/P3FjLcWF2Tf6EEd7J+BkUXxhHbb/N1mYdut8OUaRu7C2jZd871Jn4/RtVGpDP0UQ4YQAL1TQ4NrxgRQOqNJ70cdr8UOYZyWkSSDGWlq4qSMqBrGFvrgUN182HvXw7LSPVlZnoTaD1LkwpjVJ9ePJEvRI5phU/j4RIdGGJsb0R43lfHHvKtxmsuyKnPGeIMHzEs/UjhlkL/pe02D56xLzqVF43Vewv5cH9hi0F1KTh5SgpmHsIK+TMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide the /proc/kstackwatch file to read or update the KSW configuration.
Writing a valid config string starts watching; empty input stops watching.
Invalid input stops watching and reports an error.

Allocate a ksw_config struct on module init and free it on exit.
Manage watching state with ksw_start_watching() and ksw_stop_watching().

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c | 140 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 4a6dc49449fe..95ade95abde1 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -1,7 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/kstrtox.h>
 #include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 
 #include "kstackwatch.h"
 
@@ -9,6 +12,29 @@ MODULE_AUTHOR("Jinchao Wang");
 MODULE_DESCRIPTION("Kernel Stack Watch");
 MODULE_LICENSE("GPL");
 
+struct ksw_config *ksw_config;
+bool watching_active;
+
+bool panic_on_catch;
+module_param(panic_on_catch, bool, 0644);
+MODULE_PARM_DESC(panic_on_catch,
+		 "Trigger a kernel panic immediately on corruption catch");
+
+static int ksw_start_watching(void)
+{
+	watching_active = true;
+
+	pr_info("KSW: start watching %s\n", ksw_config->config_str);
+	return 0;
+}
+
+static void ksw_stop_watching(void)
+{
+	watching_active = false;
+
+	pr_info("KSW: stop watching %s\n", ksw_config->config_str);
+}
+
 /*
  * Format of the configuration string:
  *    function+ip_offset[+depth] [local_var_offset:local_var_len]
@@ -74,8 +100,114 @@ static int ksw_parse_config(char *buf, struct ksw_config *config)
 	return 0;
 }
 
+/**
+ * kstackwatch_proc_write - Handle writes to the /proc/kstackwatch file
+ * @file: file struct for the proc entry
+ * @buffer: user-space buffer containing the command string
+ * @count: the number of bytes from the user-space buffer
+ * @pos: file offset
+ *
+ * This function processes user input to control the kernel stack watcher
+ * Before attempting to process any new configuration. It handles three
+ * cases based on the input string, In all three cases, the system will
+ * clear its state first, with subsequent actions determined by the input:
+ *
+ * 1. An empty or whitespace-only string
+ *    Return a success code
+ *
+ * 2. An invalid configuration string
+ *    Return a error code
+ *
+ * 3. A valid configuration string
+ *    Start a new stack watch, return a success code
+ *
+ * Return: The number of bytes successfully processed on success,
+ * or a negative error code on failure.
+ */
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
+	if (watching_active)
+		ksw_stop_watching();
+	memset(ksw_config, 0, sizeof(*ksw_config));
+
+	input[count] = '\0';
+	strim(input);
+
+	/* case 1 */
+	if (!strlen(input)) {
+		pr_info("KSW: config cleared\n");
+		return count;
+	}
+
+	ret = ksw_parse_config(input, ksw_config);
+	if (ret) {
+		/* case 2 */
+		pr_err("KSW: Failed to parse config %d\n", ret);
+		return ret;
+	}
+
+	/* case 3 */
+	ret = ksw_start_watching();
+	if (ret) {
+		pr_err("KSW: Failed to start watching with %d\n", ret);
+		return ret;
+	}
+
+	return count;
+}
+
+static int kstackwatch_proc_show(struct seq_file *m, void *v)
+{
+	if (watching_active) {
+		seq_printf(m, "%s\n", ksw_config->config_str);
+	} else {
+		seq_puts(m, "not watching\n");
+		seq_puts(m, "\nusage:\n");
+		seq_puts(
+			m,
+			" echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");
+		seq_puts(m, "  Watch the canary without the local var part.");
+	}
+
+	return 0;
+}
+
+static int kstackwatch_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, kstackwatch_proc_show, NULL);
+}
+
+static const struct proc_ops kstackwatch_proc_ops = {
+	.proc_open = kstackwatch_proc_open,
+	.proc_read = seq_read,
+	.proc_write = kstackwatch_proc_write,
+	.proc_lseek = seq_lseek,
+	.proc_release = single_release,
+};
+
 static int __init kstackwatch_init(void)
 {
+	ksw_config = kmalloc(sizeof(*ksw_config), GFP_KERNEL);
+	if (!ksw_config)
+		return -ENOMEM;
+
+	/* Create proc interface */
+	if (!proc_create("kstackwatch", 0644, NULL, &kstackwatch_proc_ops)) {
+		pr_err("KSW: create proc kstackwatch fail");
+		return -ENOMEM;
+	}
+
 	pr_info("KSW: module loaded\n");
 	pr_info("KSW: usage:\n");
 	pr_info("KSW: echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");
@@ -85,6 +217,14 @@ static int __init kstackwatch_init(void)
 
 static void __exit kstackwatch_exit(void)
 {
+	/* Cleanup active watching */
+	if (watching_active)
+		ksw_stop_watching();
+
+	/* Remove proc interface */
+	remove_proc_entry("kstackwatch", NULL);
+	kfree(ksw_config);
+
 	pr_info("KSW: Module unloaded\n");
 }
 
-- 
2.43.0


