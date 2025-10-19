Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1EECCD1A7
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7C88E0012; Sun, 19 Oct 2025 02:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2520D8E0002; Sun, 19 Oct 2025 02:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F23A8E0012; Sun, 19 Oct 2025 02:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2D7A8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEA4E140579
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:15 +0000 (UTC)
X-FDA: 84013856430.08.088A2DE
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1830D180006
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=njSEUG0h;
	spf=pass (imf16.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pa/MsfNPB6bG2GsTxSNKTLsrafwlRF2VsAPzt2eBf8E=;
	b=mR2Gv5+nXU0waDLx9mDXjZj3NXhPEWv9KbA8fGJ8760W91/iQpJ/CUNJTHVzh8zfXUe89U
	ave3ewUXs3WDxP7SX/Gma6aAhPIVCP0RefAJIjyp5FxbiW1p5IlydgEMX4u47gqr3rqdrJ
	bJvds4TBmbsm3Rb55NIF+iT0vO0cnWU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=njSEUG0h;
	spf=pass (imf16.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854634; a=rsa-sha256;
	cv=none;
	b=ECWuOwFEHsqvVZ2GiMD+HS/v3IM1DHlCWP0Mbnnm2alvK41Qg1DG8SkB2bwh8YDAUcS6n0
	8bsm0lcPcO+vdceUVQlxHJBYN0csnO+F9L8MPDOfXG7dKMxM+603Vr5II0SXZ/X0nU26pE
	/q8eIDJQKRa8zlbJNhhdCRSKXPRBkAs=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-339c9bf3492so4088729a91.2
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854633; x=1761459433; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pa/MsfNPB6bG2GsTxSNKTLsrafwlRF2VsAPzt2eBf8E=;
        b=njSEUG0hHakIO6Fg+h5iWKtljD9Am1h7j8Zoz8tU+TDBHqJS1F2nKDUST3o5NKem09
         /PI4k81FoMiaKFzC7yVVldQab2cVtVlLrerDsqnih2XL9Z1UuzSVA0u5dpqbMWP9i9/u
         pcg8VAsz99Un+0KQJ7UC9RCkNq70UBXka/WH9H7LujNQSRE3PTquh/qEKoeqOaGA/gQA
         WBxOoQuDUpwxq/RjYFR0jmFmautA4sah4wWPRu80Shmk0fA+PIofrj7WjptNkJ7+v7C+
         rA8HQMic7hWhbD8Mcyv8JcLJYo0Ad8KZq0cX158Tl5Eq9eXJNhMcpyl85IawvHajVSST
         5gbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854633; x=1761459433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pa/MsfNPB6bG2GsTxSNKTLsrafwlRF2VsAPzt2eBf8E=;
        b=a1NQoBDy4tiwNyricaoRANVj86aP3G9eRukieLtPrN7BPRkBjV8131Sd2y64Yks5Gs
         KsIBJEjnfaBBv2NLlNNZMOMryl3AolSKzWT6tn+EQdU9Ux65dgrpnhFUzSTKgn4pqxeY
         DgMXLD6fj1/X7DgjPfY9i8pOZqJVIMjbd964PAZzHTBAlh2TPgOlmVHJ/t43S0v6dB98
         gs/odwccGL31+XvqXmj2N1M0NUulUhHHsub3ApKa+wv7Aymw9fYI6VAjTjS9QwD868t8
         /ZECVCrSK+zzwKsf7VIjDFD+lmiiq2DMEB4vdM1rrVubDQ41ysEWc3UUDZggT7eSWG00
         mkjg==
X-Forwarded-Encrypted: i=1; AJvYcCV54r25GYlHM+avJFZXGFUZACaTG9pPL087HXP2JbI0WEp2UOqgBzSiN/N7PEkCKBY3sRZ3tgQVjw==@kvack.org
X-Gm-Message-State: AOJu0YzaK0wmb4ilQHizeN6BzqWHrSf6KiEbfvYU/IltQo6hvW20BSZB
	VlOvYS2811mq/H60NRMhMcxjprIwwNslVY2iV/IB4Z614gzkke324Vgf
X-Gm-Gg: ASbGncvvEg1X7PMqTfzxKZtUOigtZZwb4BQQfOQuLNDYXH/9uS7Ri2iWNQ5Um0Puhpl
	4LnuEQC2HOlPh9HAj7+4zphQK0oZ6HJTHTcpB3loZdkxptT8A2LOAC66gMU/ctqc9h+6nwwRTBq
	CYMWgkRdbRYW8Q6Cz6XocTzrTjrjt6SXrZDjssfyzjf5WM4myluSIamT5b/zM2qMU040vx952Qx
	alfMnf2w2+LNVx3+x8c9RuY2iq67GTpgjiexg4GDxh8kXhdXK+GTVF2mop//5OwO57vXRpWnBsv
	Rh6jU3UKfibGxL9vkH32OrbYP3uZUxT0kRbS/iliOMLamZZXHLFjzr3nCu0JUeA2kYrWadWAyDc
	CMs8XNzGahfVkS+aaNeEcqQK3xMwUPvZcPUIU2jKbh0v6xXVAyxVhvjiP3KwvvatOP90h7KSI45
	zyZHO4ajZO2fWcrms=
X-Google-Smtp-Source: AGHT+IEcU9YEdbUoIaZ58UmrsaoQiSd0FUGy1FLPQQWXoQbBycgCM+6raP4xZnOBinCzMBaBjeximQ==
X-Received: by 2002:a17:90b:2ec7:b0:33b:6650:57c3 with SMTP id 98e67ed59e1d1-33bcf8ec60dmr11689870a91.21.1760854632902;
        Sat, 18 Oct 2025 23:17:12 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:17:12 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 11/16] kexec: Add /proc/kimage interface for kimage tracking
Date: Sat, 18 Oct 2025 23:16:25 -0700
Message-Id: <20251019061631.2235405-12-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1830D180006
X-Stat-Signature: cciwwpi4wcxkak1xpj319rrtwgy7tm7n
X-Rspam-User: 
X-HE-Tag: 1760854633-330163
X-HE-Meta: U2FsdGVkX18UmUkzV4fZG4F+e7KofGGKMntDhegP7Fy3dhbE88Y06XNbcu/FqIDgpE58opdQ8bibBMlsRVwbBt19bLDGlv0JkmWm/E44ikZZy0/xeQafl1ic2UrSS/KbRX+zVMlikIsfwJu7ZaXI8sguZoTrzSgWrnF4qmlA9QL5HugQdtw8OWKJiA9HUL4OqA8UOylsWxuDcC4j/L3VnZu8SSooK5p25Ew0EzK+TtiPhh/NA7KM2xbB9a7kozMLC9UFJvh0WgYfzYgYuNGWi2E+sre+Ebqcx5okTrS87Q46pOLgQbf6BEb6d4DSWJJXF25kYBQh6cdIzXhM1MzaTQbfbvRbDIL88H2/+sXj37W35sy4dJrruseqEitcGjMIgvb3+/6S39DT9WDr3oPrqmg+wGUgv5Uv9+TCjKAY6s2H6vkGH+55HXjlSpYdPEiXjTm4PVNa7OApWmZ7VxEq+3aPgjHL7sW6llTwhZhapcihQ3pRQU67utFmtg0f2wu9ckpqKV6TtEhUm6vXD4Cs5pA93QarS4qiq7uxFbdJ4quw0SN73RpDnpdfrwS1mDCRhVzRbjmq3NeVPkiYza4sD4hRX1lFNYa5I3qs5Dt6xMDigqCerGG2I2CITqx5eAJH2dkZrLWo1xYFYcms6WZqbOyJNIGzqP+cb0ijiv9lLVLvBS8fGyrnxPB7A+xEEwW1KRXCDcuv0bk/sLnk8REUA/698JVijerif2szq90mUPCWRILzUMcD80/kMfg0iui7ITRjx6ifnCo501eQ0cuwi02p1y8P/imQ3qJbvW6rRo+hi7KWdwA/e7YzndSIYbyrporJ78Q7l3MBz19dGIcQ7qWORATi0Ln69x3t0wkWspXpC8sTR+EdxzhP6+6OyrynhTry036hcYjECfXADk4pDGDzJQFzzcCc6gvbk0jHvgQk9F1gwaTyqHK4AFQa59CC5jKrfaeh+sSBdasV+K/
 sGYOOd5a
 uOCyTZogNAbZ4WwKUh9sZMrLAD/V4HE9HW0pn7aEH+V5don36QAlOX0yR3T5ikXJWUYpj92ZYGN0fczTG8BvDpUKLFefQetPXsPCmgryVQQf0P3hopxA/1iqk8ZD1xXLAwFhB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Add a dedicated /proc/kimage file to provide read-only access to
all loaded kernel images in the system, for both regular kexec kernel
images and multikernel images.

The interface displays kernel images in a tabular format showing:
- Type: kexec type (default, crash, multikernel)
- Start Address: entry point in hexadecimal format
- Segments: number of memory segments

This interface is particularly useful for inspecting kimages, debugging
kexec, and verifying that kernel images are loaded correctly.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 kernel/kexec_core.c | 63 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index ed5c97b4531e..7db755e64dd6 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -13,6 +13,8 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/kexec.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
@@ -1214,6 +1216,52 @@ struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
 static int kexec_load_disabled;
 
+/*
+ * Proc interface for /proc/kimage
+ */
+static int kimage_proc_show(struct seq_file *m, void *v)
+{
+	struct kimage *image;
+	const char *type_names[] = {
+		[KEXEC_TYPE_DEFAULT] = "default",
+		[KEXEC_TYPE_CRASH] = "crash",
+		[KEXEC_TYPE_MULTIKERNEL] = "multikernel"
+	};
+
+	seq_printf(m, "MK_ID  Type        Start Address   Segments\n");
+	seq_printf(m, "-----  ----------  --------------  --------\n");
+
+	kimage_list_lock();
+	if (list_empty(&kexec_image_list)) {
+		seq_printf(m, "No kimages loaded\n");
+	} else {
+		list_for_each_entry(image, &kexec_image_list, list) {
+			const char *type_name = "unknown";
+
+			if (image->type < ARRAY_SIZE(type_names) && type_names[image->type])
+				type_name = type_names[image->type];
+
+			seq_printf(m, "%5d  %-10s  0x%012lx  %8lu\n",
+				   image->mk_id, type_name, image->start, image->nr_segments);
+		}
+	}
+	kimage_list_unlock();
+
+	return 0;
+}
+
+static int kimage_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, kimage_proc_show, NULL);
+}
+
+static const struct proc_ops kimage_proc_ops = {
+	.proc_open	= kimage_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+};
+
 #ifdef CONFIG_SYSCTL
 static int kexec_limit_handler(const struct ctl_table *table, int write,
 			       void *buffer, size_t *lenp, loff_t *ppos)
@@ -1285,6 +1333,21 @@ static int __init kexec_core_sysctl_init(void)
 late_initcall(kexec_core_sysctl_init);
 #endif
 
+static int __init kimage_proc_init(void)
+{
+	struct proc_dir_entry *entry;
+
+	entry = proc_create("kimage", 0444, NULL, &kimage_proc_ops);
+	if (!entry) {
+		pr_err("Failed to create /proc/kimage\n");
+		return -ENOMEM;
+	}
+
+	pr_debug("Created /proc/kimage interface\n");
+	return 0;
+}
+late_initcall(kimage_proc_init);
+
 bool kexec_load_permitted(int kexec_image_type)
 {
 	struct kexec_load_limit *limit;
-- 
2.34.1


