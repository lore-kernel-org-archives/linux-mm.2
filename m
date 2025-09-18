Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20788CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 22:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80B088E0147; Thu, 18 Sep 2025 18:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DFCF8E013E; Thu, 18 Sep 2025 18:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE518E013E; Thu, 18 Sep 2025 18:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 536D78E013E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:26:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1176E13A336
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:36 +0000 (UTC)
X-FDA: 83903806392.28.807CAD7
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2317440007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BscatIA2;
	spf=pass (imf12.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758234394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwRb7SzhfZg7neWGwUqJxva5Q/Tf1fgxJiUlDnCKY6o=;
	b=8gutqZyuFR7vBAzx2lx/tRRNc3Z4pvw0fiyrMK3P0nfEazk1yDeYW/o9hx3ph2Ehyfn6b7
	4Bnq9lKSRwm53R0MDdfOfZHK4K4ne1mWSx9tIGxQUj+s+YkLntQwiJOVuVRTh5Lyxf6pd7
	Mp70MXWWZN+KDElb3ABkKHXBPWpZcDA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BscatIA2;
	spf=pass (imf12.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758234394; a=rsa-sha256;
	cv=none;
	b=G6FL986YQK0VK8s5zv/q6hdsyG7YfJHBfgXNWsImmm60vSmIr4ilqmXjXMbCS5G3xPG/dS
	GqAWNoJllg913LVGu/GpN+QJFEkNBi825qcXyCDtezi6Sw4UkwlYdQX4vm2HW7L/9kkwY6
	wh9OFWWZi6iOdw/PF2NhlLF4hwKvufY=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7704f3c46ceso1436163b3a.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758234393; x=1758839193; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BwRb7SzhfZg7neWGwUqJxva5Q/Tf1fgxJiUlDnCKY6o=;
        b=BscatIA2pltjmXKAW/UUgI7q3WgYPCPxDAxfudAzvHYRtNBcP7SvpvWRql94k2lMfC
         1urh8Y+T9d9mNTD8Q2Y53hHqucK8GMpIsutJrPSrs5o/XOn38+3/T/54/HhmcBvLYe4D
         uufqMTRe7mb8jAm6LMOy+6iNhNxBs4iPkbabxITVgN26JRn68iw1nyE7iOnlmNA3OGEu
         CCnN/rV62aIDX58k5g9Xe+Zc6Bv5TvNzszJdJ3YSPN9gaIbBegsULqP16C/5tPvZ/ouU
         Zv5S5HrrvlXP5eGEZ3svQ0Ws7yVLpSNXVogWuEgs9PJo76Lmm3z+cMC/+4vzcqWVm1et
         rNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758234393; x=1758839193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BwRb7SzhfZg7neWGwUqJxva5Q/Tf1fgxJiUlDnCKY6o=;
        b=wLkd8VLHLf1BQS7EsvtPOopHJTUsyCjHsyoipXplde5e70dzVdKuoT0qBve+xRzKv+
         VkUpAOqsPKUHqEaOR0sVxzqK2fcob8XN5PPw1QvL5oUNOWMp8p7Z75hFW//XqJ1SpC7H
         asrxXWLcLSmbyLF1gBgMNh7CsEMaVUo2LciBJhB/dgmgJTbMRUpYkbeBeJ8gKH1ogoHB
         /OelwQz3SCwm/Vrn5ysM6TtUB93V7bXxMnZlgNy+S//m26VaV1Av0/tHZd+2+0AuzXgu
         nbw7wJKn1GBE3R0qaHR1dLSNQnj8nmcx32JhWOND4m+0q+69nZhdeYOjWom7UKdrOPzf
         id3w==
X-Forwarded-Encrypted: i=1; AJvYcCVONWEZ7r/S/JRjSeGhN4X87ihzcyfCLWvv/TmsAkXy+wdvHR/1pRM11VhnpZbAY6tuF1b8QXz4ow==@kvack.org
X-Gm-Message-State: AOJu0YwBRL83pqmO6ubKGFnNVII/AvbeYoL/Fxu7b13bKLwHCEsDi81b
	HaDkTQAtFKO2RbRs04R2wBNvrxRMEf96a87wmcwmXowOqZS/ZDHtCNJH
X-Gm-Gg: ASbGnctuJ3m9s4CG+i1Lx6c9xkirYuBhW9C6cH+6H746pE8HAc74JW5OY5s/Bebt0Bd
	KzkZQIn3fOOb/A8fg+cx3upkFNyuVaf8rKUd2mMa8ujKYXp/mBFnZS9W09ko+XtcUPT3u9jc2ev
	W0H8O/5wYTWVCPLyHGJ2ZFojxopDNauLawFamtN7/+3hgIcAHlMkv6YL/ezTGyITAq/6+ydt1yi
	dMB/mqccIIZy+f9CI9fI73DBwDmMf73vfv2h9kpvR6wk4ynXFrzm4GN6QgiGLp+F52nBVZjVIya
	aqRfqbpLnpStiSs0lcL2nrIT8SUJIY551HAP5HUeQ4vc3KdQ/jK16eQCSvV2dpurjqkP7JRynLi
	3kUZqAN6kjD2RH/lIJ70GfAeQgCJy6zwkMIkSkzP1/gNyMHk=
X-Google-Smtp-Source: AGHT+IENSD4FSp5oCJNvN+B+S7Ehm9laSk+STvS8UEs+QD3NwWg6ip8ENfOjlvBCKPM94MRsd6BQ9g==
X-Received: by 2002:a05:6a00:139a:b0:772:7ddd:3fe0 with SMTP id d2e1a72fcca58-77e4d03267emr1101959b3a.2.1758234392993;
        Thu, 18 Sep 2025 15:26:32 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:c5c1:2e33:6cf2:beed])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77e5fe6de75sm407542b3a.19.2025.09.18.15.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 15:26:32 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch 7/7] kexec: Add /proc/multikernel interface for kimage tracking
Date: Thu, 18 Sep 2025 15:26:06 -0700
Message-Id: <20250918222607.186488-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2317440007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: njf8jr35ok395zwseygmwe6qqf8d9huj
X-HE-Tag: 1758234393-212488
X-HE-Meta: U2FsdGVkX1+jkRU1Gu3nFLFR6aReQkIGGyqf7bqMIdF3ImpWII81Uk5XbVl+vPLhCxPEwe6CYTsZYZm/YigD16HSqmtNIg16ecdtLPg7wh2Rjce26nPlYTfXQzWe/si+mLfCJJqLKdXIB3WTqiz3IdlFqwIMgG4vpkXT2/FVp3853xKA+7FoJkz/+IZMUJ1qqvkeZGn6jbRnw+k66KMwvD3Ze2hMY6oZ05HEicfMbQiw1ncWbaKlg6ObbLZyvfFSBJ8BFq1Chs/TpP99BdOztQ79ZVUhDDAzkA1pyS0easHC5xCTO8InWPrAT9czgpIsVWUt5wxmuXkSb0xenbC1R+CxMF4W7d9gnke39pbvA98jFIAVvIO83c+fVzspbSsmW9iLuoEIwoVvF4YiMwahObiKLxf0/XiCGNbEs04KpYDbeKigYy8WsznTTVL5O9npwgPsexnB58WurEu9+z0pD9dNkXKdse72T+wv2e4wz/evnf4Of6lkNYhdT8e9C+T/q9IlNAD6UbnMx0SP5/QeKSyxxmflI36MfGXjcBvWG+bFfHKi3I/QDpJQtJXqpJ1ua1BVYOKRs3/Cn6kxLe0h+v9+yfv1KrhjkXm6N705PkEhfvKrd8exSinmY9aShSsuBWo67aN3PerHcnA55tsAyI3FPXCjbjs5XVU2j1ZI1E2qy2XZYMDnHGAX6iwmqCC7ZDZXCemm9LfG07vpPrpInDTjtI4xV8oizPAnEWfaFq6OUSEJaxDdp18ClNOsq/KeZpwl7EOEBVAJFhsibWENdY0wXofsv5af4xkALp5CGpvpHT2LYvhMndJmYWqvmEO+EmLngBE3SF4PO7Zz/mmFkNrK7u9yYRVly4d2Rr0QPP1Ubd/JTX7zlPBTIxZrlVDAa06+62PH/6IDh6lojTV2C3OdmCWLnGVl2FdfLxoLeZbatb5yPXjeGZH0UCwXGZhiwJvU/sw9Gh8cyT3yz5D
 OW/R1CVC
 3SY2hwIhCSrqopQU0F8h5DH8R2IPvarSPBsNYjxMf/8xlAJAlm4NpsbUF3XOGh3hdxk7YXfHLQBwGNuk6bs2q73yWL3v5LmBU5rnKma8LZwMbumWfKxIEyZ8AsLGxmwm/qKV9tWTm6joiflCjoUXiaSfDZMrJh8M6kzb/HGtFMrdyx9QtzEGwDs8II1a7A8zMtxs0otHxNGSIoIog6urrZFQNrZf+ALd6hHMVM7N/HfJ1mTHf9Z+1cJjw8z74vJzJZqKytEbf0X83N9Mtant2suDxWQo5aoilLevQr0Lql9pN6G4vPdK+yUres5/XJKwCgx5wiTh8yXaJHOXbMICmPwc+n2Tt6hQQKb2bMorL5HzQtLj8HT7mARkC1AkW3SkiuSBJrKT8yH/bU4PV9MhRX+bZ42T6PoExLqL+Rh1js2kJ18LqozZoEC72zbq7KsqXzS9oB72iFo4TCScYE8V8fKRtiQcIQfwXEuv2vt5hoUtoTtHrx2REDKaKmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Add a dedicated /proc/multikernel file to provide read-only access to
all loaded kernel images in the system.

The interface displays kernel images in a tabular format showing:
- Type: kexec type (default, crash, multikernel)
- Start Address: entry point in hexadecimal format
- Segments: number of memory segments

A lot more information needs to be added here, for example a unique kernel
ID allocated for each kimage. For now, let's focus on the design first.

This interface is particularly useful for debugging multikernel setups,
system monitoring, and verifying that kernel images are loaded correctly.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 kernel/kexec_core.c | 63 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 4e489a7031e6..8306c10fc337 100644
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
@@ -1224,6 +1226,52 @@ struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
 static int kexec_load_disabled;
 
+/*
+ * Proc interface for /proc/multikernel
+ */
+static int multikernel_proc_show(struct seq_file *m, void *v)
+{
+	struct kimage *image;
+	const char *type_names[] = {
+		[KEXEC_TYPE_DEFAULT] = "default",
+		[KEXEC_TYPE_CRASH] = "crash",
+		[KEXEC_TYPE_MULTIKERNEL] = "multikernel"
+	};
+
+	seq_printf(m, "Type        Start Address   Segments\n");
+	seq_printf(m, "----------  --------------  --------\n");
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
+			seq_printf(m, "%-10s  0x%012lx  %8lu\n",
+				   type_name, image->start, image->nr_segments);
+		}
+	}
+	kimage_list_unlock();
+
+	return 0;
+}
+
+static int multikernel_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, multikernel_proc_show, NULL);
+}
+
+static const struct proc_ops multikernel_proc_ops = {
+	.proc_open	= multikernel_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+};
+
 #ifdef CONFIG_SYSCTL
 static int kexec_limit_handler(const struct ctl_table *table, int write,
 			       void *buffer, size_t *lenp, loff_t *ppos)
@@ -1295,6 +1343,21 @@ static int __init kexec_core_sysctl_init(void)
 late_initcall(kexec_core_sysctl_init);
 #endif
 
+static int __init multikernel_proc_init(void)
+{
+	struct proc_dir_entry *entry;
+
+	entry = proc_create("multikernel", 0444, NULL, &multikernel_proc_ops);
+	if (!entry) {
+		pr_err("Failed to create /proc/multikernel\n");
+		return -ENOMEM;
+	}
+
+	pr_debug("Created /proc/multikernel interface\n");
+	return 0;
+}
+late_initcall(multikernel_proc_init);
+
 bool kexec_load_permitted(int kexec_image_type)
 {
 	struct kexec_load_limit *limit;
-- 
2.34.1


