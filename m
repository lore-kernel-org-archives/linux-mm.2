Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C3DC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC166B00D3; Wed,  5 Aug 2026 21:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6936B00D2; Wed,  5 Aug 2026 21:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396D16B00D4; Wed,  5 Aug 2026 21:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA7866B00D1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:13:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCD7BC0628
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:13:20 +0000 (UTC)
X-FDA: 85069071360.29.54A34C2
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf27.hostedemail.com (Postfix) with ESMTP id 33C4940006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:13:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZU5OHBlT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3rd9zagcKCJY9O4I20I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jyescas.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3rd9zagcKCJY9O4I20I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jyescas.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ajsYv+gmd5fyZphFvjsg6YH/0Wja+j7l623iMcGCo0=;
	b=KRIvuh+r5mYB9yyHMOs+6ReVGICMQeTRG/QYKZiIjgDbKFI8irpqShvE2EQWacOfk9p5yX
	S2TVTY0Ps36klSwIhB8luJs83DIckK2TJT8Ud5xdPN/ZtZdwZrasSTeMdmGgFhVZtSKWDH
	Bc66uiPC28tH35uDQNFBRAFXDmUZL5I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZU5OHBlT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3rd9zagcKCJY9O4I20I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jyescas.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3rd9zagcKCJY9O4I20I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jyescas.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978799;
	b=CWFAHPFR2Tj6T4oynVn4CIVDfjydd2TX1tmHyxsuq9ivV18xZBYM/R1LH6po5UcqpXovlg
	bk7zooCnQ7qQOboXfeIs5Cy0HQmln+shYlQgo2EzVxrRcNQ78DXeV7XQ2XxWPaho5avk2g
	VyigG3zlEQmJb7J8CsYNcQj8UO3kswg=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb5cc1e13f8so1838976a12.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978798; x=1786583598; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5ajsYv+gmd5fyZphFvjsg6YH/0Wja+j7l623iMcGCo0=;
        b=ZU5OHBlTIcAALPGGL9nUZZucgpfnMFn77RRkasuWgTML73xIAwhsDvjHA7YF4LdFAx
         xv9oEce7Mr1+Msy9R+bqxMIsyN1e6aqPwC1lAW8U5FsDPiAfsLSyTSVFMAPTlEIWjUeJ
         bBeYIdJZh7B3W2XyDVAtWKJyDQ84TgYQV9HqB0rfCReoXsNdir590rOIR6vj21CZ95lK
         W1hJfY7lbUMjURoD0RBuc4lziiE4t9YDKHG6wf3j2qFPxjFdKnwqGbWdgFZL6AdlgJLI
         K8BV0jQJxcmen/pgUq81EviUkH2kI2WmQ3Q18o2LqRGeOAL4dBErxFWexcoLODPCODjr
         Hi0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978798; x=1786583598;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5ajsYv+gmd5fyZphFvjsg6YH/0Wja+j7l623iMcGCo0=;
        b=UNTuCQhwEM7x4e/rgjNtdkF/BNPDd5z4sv7d42tSM6U4OuGctLC16r3BWBajrabkwr
         5lyu4iJIIzhuRAtB6IkwyjPnA2kb1MomE5i8BJq+bzX99mBNohOPxs5xeTMPzmD0CPNA
         dsCGsNL1z8oSmP2kAPIDYKBtGr+oGX+pgXE8u9LP7r/PQcmsKLvEQLuUPq8P5AdPgy/U
         6U6MVsVFKE+jR0G5BXSClBT9uYrpZ1C1q9IfdjpVJ2/I+xRKVDnT0akYENjhvmjRMdRz
         UFJX0WVCjPihi+ZtI2yl5gL/vrBalLd1UgmZmyTc7/J4URC3G95D1umklOCUSKgzMl4p
         Q62g==
X-Forwarded-Encrypted: i=1; AHgh+Rqop3YJQh3+56XwCYEwI90qkgho8R9dhMp+TLAJBmr4hHpvzAyVWw6HY9zCaorGOkpSaQ2kjeAZcw==@kvack.org
X-Gm-Message-State: AOJu0YxnfVXrT4Qu/T9AqB5HcH3HSzT9Hn9YIHZtc9u11l5sRjhRKrRN
	Mr9dPqSmUOu0o0iYdPs5FfNrYtTdS2u9kK05UUrZu6mLVDRHm6On44FLt9ckcUCwbZ4jz2fJTfn
	axON9En2E8w==
X-Received: from dybrq40.prod.google.com ([2002:a05:7301:46a8:b0:313:f718:830f])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:2213:b0:3c0:b943:f984
 with SMTP id adf61e73a8af0-3cb85df1920mr13380500637.3.1785978797726; Wed, 05
 Aug 2026 18:13:17 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:16 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-16-jyescas@google.com>
Subject: [RFC PATCH v2 15/16] mm: Create the "free" file to release the
 previously allocated pages
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33C4940006
X-Stat-Signature: kjhaohsw7swr7wmjm6oin7x569gw7zu9
X-Rspam-User: 
X-HE-Tag: 1785978799-599036
X-HE-Meta: U2FsdGVkX19xspafMXqiYUOe5Ii+pCJit5t+WBF1hx+vFugSMjwBuCW7cVQIzh7yQsrMRHyHb2IqpBRvVih3Y0A1tvZ8RG/SyJ3Age4fxqAuNmjQUZ6nu7+AoBfpgMVXP6l+yu0SVSzCuT6FeViFLJFCvTmEGo4JeG5OASUVz/VrTYUeLTyKiEqja7chMQdCWSMHPOaJghL1zVwpg0x/SYDZcF9Lr+/IjifgRLWN69t0eu03GSeafvZMiD1a8ubUjdKaFC6FT/VTcTYOftsORxg2lDJMpZDq0mmwaZIb7RXZwOIAID5ytUI04e2mknf9iiZNZqfSZd4Z/SA2goRqpn6/Nn/PIXb8g/VYLybmnIfg4NTabwP22ohvX13CL7tOChNk6ftndhVIEpd+lkNb24Lnv7nb/8aa7N9Mt24Qn6UU9Riq0e+ReDmiuvQbCh9ll8c7lbH3gRCdGvHrv0NIdvZb0RObra3IzX24hjVImRUQLTLilqO0B2x7BD3FfUqluhJ3TovYGHe0NCen/S6dOEIJLYBMDCDayozxbwJVMxuU18a5wQphqUImXA81nnDO9iQkwRgVFj0HMyBCwgWGaj3EeLzdymLUYGPAcaw/bcCpar2TjoBqWmai4BTAbB6hDuA/DhwaezRjRv11yrQELV+lj4VyX/X5mPQRzJpKnc19RVcHItl1nBzeTiW0MJxacWr0A7Aw8BVoUXo07rLY/UiRUxi9DAQe4eZjZ4PYs7QEqNZ95jBIy7T5urt+k6SpavZM9Qlj/BsS39wgFOQKtHLsOdpSNG2AyLXWrSKvmT2tV9D9Z/HimhLcHkPTupKOkbOZ/CCBxlF6Qjjd69mwOpKbPcu/+x5t7ZKuPc9D36VXn9mAJEOYL0UuevVu1l9nmVJHU2P71sFgHtPVCepgIdkzLNcsip8cJuiEGMoywy3Yt77zgLuk287VEcPXl5Am5gmncLau61JVJwwgIDA
 kRhFiA0H
 FDlgG2v6dNtTTe4vPlC4alLTNawIpLNk2plNLAUlmWQAqv+HdN+FEIjH1JkAbQUCZLLAcC3lb+i+Ab1cDLvmiipLUTJtr/kww1CrZ3PGK7dgw9Bs1abAl4YoEufFhloGspcE0KNoIsqQfDFIbyFYdr8WQ3NQ9pr/YsFejxq9VxSrYjH+CI/ZXne6aaJFixuAcJ8GL/9fM/1EwM5LGZGdnOD9Ij/DaBZPOvwNA7Bet202OQxa6H6QxAb8ghQvq8DHUnf/dgExfOI10oKs5iguMt+O0wOMGWcyJ6Pr2bZIuop0z9wYNufsWxUAosQz4f8T+cRQSMpkZpqriOHgqco1ZbNaCqkg3Rsuy/haNC36Y5kg3JWGD8aG2EL24q2o74E/ZfsPi7DkDlsWOIrFeFC93ME9BDS25SLBi5VKJK4xbiG0Zca4NogWZFgCP3KminZzeU6gdaBpzGYUap33B+UwnqFX8F8imLKmF9giARAIbjxC/akNT0JcwgLvZ9Ho8tG+Vm4hniaM+Cwskx9ulz/bPq2b3yTPalo9NVZ9UjIScDdw8dvq4axNwhjhPhF2Jnj4lAA0sqq38jnIZ9OzmhTyY4tmzADkIFnH9rZID2mRFbkrF69sClcgJOIbsjqpRSyH+9aevdoxXSCx+tvHc74bv+7+8QyTxkJ6fU2j7no5cXej125XHsB9//0CJACuCmInLw+QC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates the "free" file and defines its file_operations
to release the previously allocated pages. To release an allocation,
the user will run:

echo <file name> > /sys/kernel/debug/mm/free

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Set the file permissions to 0200.

 mm/page_alloc_hogger.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index ce53a17ac790..6a6fbb78513a 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -83,6 +83,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/atomic.h>
 #include <linux/errno.h>
 #include <linux/debugfs.h>
 #include <linux/gfp.h>
@@ -331,6 +332,37 @@ static const struct file_operations req_page_alloc_fops = {
 	.write = req_page_alloc_write,
 };
 
+/**
+ * free_page_alloc_write() - free the previously allocated pages.
+ * @file: File where the user is writing.
+ * @ubuf: Contains the name of the file the user wants to delete and have the
+ *       memory associated with that file freed.
+ * @cnt: Size of @ubuf.
+ * @ppos: Current position in the file.
+ */
+static ssize_t free_page_alloc_write(struct file *file,
+				      const char __user *ubuf, size_t cnt,
+				      loff_t *ppos)
+{
+	int ret;
+	unsigned long alloc_id;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &alloc_id);
+	if (ret)
+		return ret;
+
+	ret = free_alloc_helper(alloc_id);
+	if (ret)
+		return ret;
+
+	return cnt;
+}
+
+static const struct file_operations free_page_alloc_fops = {
+	.owner = THIS_MODULE,
+	.write = free_page_alloc_write,
+};
+
 /**
  * create_nr_pages_allocs_file() - Creates the file "nr_pages_allocs".
  *
@@ -503,6 +535,7 @@ static inline int create_nodes_subdirs(struct dentry *mmdir)
 
 static int __init page_alloc_hogger_debugfs_init(void)
 {
+	struct dentry *free_file;
 	int ret;
 
 	req_alloc_cache = kmem_cache_create(
@@ -534,6 +567,13 @@ static int __init page_alloc_hogger_debugfs_init(void)
 	if (ret)
 		goto clean_dir;
 
+	free_file = debugfs_create_file("free", 0200, mmdir, NULL,
+					&free_page_alloc_fops);
+	if (IS_ERR(free_file)) {
+		ret = PTR_ERR(free_file);
+		goto clean_dir;
+	}
+
 	return 0;
 
 clean_dir:
-- 
2.55.0.629.g250fe7f194-goog


