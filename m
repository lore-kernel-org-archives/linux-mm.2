Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDC2CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968138E0012; Thu, 28 Aug 2025 03:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0EE8E0001; Thu, 28 Aug 2025 03:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9088E0012; Thu, 28 Aug 2025 03:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 643C08E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 311621A09AF
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:44 +0000 (UTC)
X-FDA: 83825354088.17.8EBB4FC
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5046D1C0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PZaRg3RY;
	spf=pass (imf18.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366482; a=rsa-sha256;
	cv=none;
	b=G1TtPkA3sDtWHSvKOpQqy3Nia14qmg66DzoHwoFRdEWgKT/KpXJo4F4BQ3VeuTrn+6qtCJ
	30OD70ZlYBzJHZP8zyFc0yHs/UxoEnE1bNT9FqW+V/6iULMpg/Vx6yHkdgPBfhB0RjPMDz
	pDAKJcRbPth9RgwxcIZnvMeNJh1+QiE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PZaRg3RY;
	spf=pass (imf18.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dROQY+DQQxgfw8aR1H7lwjWnAl7BOjoXCnJTNltx2NI=;
	b=yuNhKZKanMJIa6KbpA3+RrvROFbGrXRtDeshsS2Jtb33OGDELlxydHMW1fMeYjbAV7hKgE
	wqJ+J2bXVOE2MGEMSlAL40thvs1oj5YfYI3lkNaoLv767PiE+sMO6wWFr/e4W3jGDHvUYB
	VsE3Wg52/Lr9tRYARCD5dlM3JYi9amw=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-77053017462so521914b3a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366481; x=1756971281; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dROQY+DQQxgfw8aR1H7lwjWnAl7BOjoXCnJTNltx2NI=;
        b=PZaRg3RYtbWBLQNB4aVHs6+9aW1tRnaIMYcrQUt9VSUf42pH5137zTChLjAiMdL7h2
         eqawg7ndEKj3qWKroOJRNuQc7iryILEHEcSxMQDbwtVh86qPAzfGMQWJP0FtA8LgNWpK
         RdlkEcZDABRfwLbytcqZWRrPQBJapFP9QISiNCwDveoRG90XskjStL1F9NCG3PQ+Pb24
         HiZEoNA6Vk/3oIedRCex6PBT+tzx9ntJWSTSrsVnj99bqptQWCRID1m2v9IS3kKkmhAF
         kpYzj4lD+2LjWcYjlbVuptnOwj32hYeKpIRkdX15xbdjDBBAQwjl382UWWPfgEg+34RY
         O7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366481; x=1756971281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dROQY+DQQxgfw8aR1H7lwjWnAl7BOjoXCnJTNltx2NI=;
        b=jY6+hg3OYpgMqdDAW+i0FeIbYdQidbSVmdCzPgpwRecTOkZUDMCsXm72rOHoVCxnAp
         rav2C1RKRrwuIvTMwu7FoovuSZdpa/RjMRDv/NzgTUWnAm9/5Y0UCxa+807ercIL7MwM
         26y4H2T9LL5+3pHnD9Qq06NpAwOL4L2S14u/DX0+Duvs2ii+BIJBw96IHM+5A05oYocp
         8yEyE7j62fiS85sEKNJglzvLzLZxjeut3iFnEtsCGdQ+9cBgIaxof11Sq+vtiap6eJzL
         sDE18mVcXx/u8S9OQ/m5+x95t3jtc5DBr23S5YcdttcT/itqy5RpJsysh1+xP/pzj/I+
         Hg5g==
X-Forwarded-Encrypted: i=1; AJvYcCV05EMn+4yjas2rAFyEaBKiCUZTKL7z6onH3WGvOJkoMJ9w1FdaPlRv/T5ozeyZL6+n4PMmIz0sFA==@kvack.org
X-Gm-Message-State: AOJu0Yxt9k8jG30YQHvBwUIKkEHy7TjWXLusxy5i48z/mx2bPI50WHU0
	Vs55h0aYcEZV2sn3g26z7+1F5e0quNbhekL6t8i1PgxGHVlSMxjuY2ZC
X-Gm-Gg: ASbGnctQhGglXsDqq+9cU7qCoGJ+ygnvTaegG3+VFoRHlB306056Kc96iPaWKCX7RVR
	Zlkw6mCh8zBbGxkeu77AhOGWc5BgbIaUDA9VYKtAS/IzQUxVor6rZVZIu68uC8ojF/a3rpK3ZfS
	IGDwwbZHlBb4K7Suc8G8HZGAPy0yxWUNdNJK2QSTgq2oKps2QFszwnCmerFrCBZmW48r1tfaY2K
	h20NbNMBg3cFX1ud6/NZmXt2NNn8+hW8CWSk5/yBXIevDXjQoPZWZW8Uv8YHjcGHdDpHQ/N5Z8E
	/5TeKFYhsw0qksa68zhYtSGOy3e7lixvTg5peSmT+Ig57OcnZbsI/lx2tZiUxMxbX/yZR4nmVHK
	zRd4YXpxQ4l0b/1gZggt4DFHzDvK+bZ6dH3CMrjHP6gAehGFMiw==
X-Google-Smtp-Source: AGHT+IHOzcFsWLv4OBgcDeQy4TpdPl7zO4VoKoUPzbnA5fEUxzCOhCFvpJStWdJxL53EzHY8tsoBbQ==
X-Received: by 2002:a05:6a20:9145:b0:243:9845:4137 with SMTP id adf61e73a8af0-243984542bemr10262081637.26.1756366481086;
        Thu, 28 Aug 2025 00:34:41 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:40 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 09/17] mm/ksw: add per-task recursion depth tracking
Date: Thu, 28 Aug 2025 15:32:42 +0800
Message-ID: <20250828073311.1116593-10-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5046D1C0006
X-Stat-Signature: bhtg6dknnq8t1p6nugxk6jekarajej8y
X-Rspam-User: 
X-HE-Tag: 1756366482-57036
X-HE-Meta: U2FsdGVkX19T9iTJMSAJYsgFZRJUq55aIFAzIuudNxRaIefJk+m6fdOeKk8Ec8pzYTPg3KGxdQ8bcu0AftSRXi4fe9cmSe11pKycXu7cstt04l25RRKkJ7eto6RF5YqpxZAa0XPTyN7YjDueG4Ho+u/e785M9tdc3Me0i9SzhRGDOnYpWzihMgjONcsm9iCDX5CqYygryOtQbxZRZ6cg3WOxiFZ8sEoPXtvOa3podcXv+wpx1KoF0H8oQAbW8JuQxMVILRlYF02eSBKIuPZbo5ImrDUMbZ2dCPT6QQrzCe1Fmz4acEhEf4Lct5rA7LA39OOXxSzJg/xl3olqlLwXBM16HN27+UPq31AmiLtRDdi8eN3bW8DmzcN4qNDFW4mqQT6FdmtR2FiyyVF2N+Rmlq3bhrq8OZlMDRg+BmGXZ1ZDQHvNwquFb8IcP3juRCsbCtTsH+zpDRmn0tFYeAZS3CbYgZFmhEdordxlGHFOBHvKm2iwGqqe4/iqDWad9CvcwpKcvGDIqPZpPc3eIEd4wltvKG9hxnc6u+BuPYQb0nMpD/2tJdoxMZhfo356e4urA8g0AyOCv+4dGGFywcowCaWOwWmZQq1Go37VWwVmoOa5V4QBZTCKZmjFEu+Ys7HGDPuEP23gQdzNqo1QfmKQa+vkUekG8wvBEYhOVfOpIh80X523oxcjLAAul2Dz9EWwCc+/q37cvldrdRpWmjYLkuYaJFU7Amo5gw3uobu+Xes0Ah88PKfSxNLeqThzIdqdFjsL8Up7uG9sLhqK+GID5nMWPZgqOsMIWtXGy48b/pSAEyi/Vn8wA/guAkHiTs/zrTCw1ZvJ+jp2x/zMoxGO1wpxbir6YV5C8ThH7rPAxd1qacBLvTrAN/nP7F8lhIkVEzrqmegmeAJuOxQNIuhTvNjn4miONH9mOZRje0XqbTUBnNqZdkLaKuhbd3gfmou+WBp0Aa6s9p40+zroY86
 NDhq0l4h
 ZYArTBD4LxA9umsBZBscwUAc9V/ie7JpQBNgpog0V71lSz9OKj4o9SHwk4FxfGAdAkWmEYcTn41nxkroLEmxsepqfzGa6SpGwU0XnikRTZ7hrLVDdEGVuP2wC5q94I3xlA7hUH1Tn45p6KYS/aIcRDbztY3hFZEPEuHuomO7disswqmJpfN+2j6NueV5ra0oHlDEvCHs8GNZ4o4QF7Cv+yvMXzUEfI2X+MctBMpUDyhQK5FZfT8gdLSARwpxBZcatPfQxvHNm/qSL6Vo/elstA1wCjn0/OIlHjWS7Cuk6YUFByYR1Cm6QQo4SJ/+8ZU9NV4jaZWtMoKOfnPArM72ysJVFkB8KwYeAl2+7R5jZoPkuY0uliA1S8Dm7IXociMtqqKd0lLpnUdQwEnhBY29zDv4rpON2ISDL6b4cER+PaNpDjnhHQhXDAcbZhfdlhWW2wXwOazvgnA04h5O6na/gl2E4rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement depth tracking for KStackWatch to support stack-level filtering.
Each task's recursive entry depth is stored in a global hash table keyed by
pid:

 - get_recursive_depth()/set_recursive_depth() manage per-task depth
 - reset_recursive_depth() clears all tracked entries
 - entry/exit handlers increment or decrement depth and skip  if the
   current depth does not match the configured depth.

This works even across task scheduling or in interrupt context, since depth
is tracked per-task, ensuring KStackWatch can selectively monitor a
specific recursion level without redundant triggers.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 105 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 2 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 1d9814a58fde..fe4cc1352cb1 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/fprobe.h>
+#include <linux/hashtable.h>
+#include <linux/hash.h>
 #include <linux/interrupt.h>
 #include <linux/kprobes.h>
 #include <linux/percpu.h>
@@ -12,6 +14,81 @@
 
 struct ksw_config *probe_config;
 
+#define DEPTH_HASH_BITS 8
+#define DEPTH_HASH_SIZE BIT(DEPTH_HASH_BITS)
+
+struct depth_entry {
+	pid_t pid;
+	int depth; /* starts from 0 */
+	struct hlist_node node;
+};
+
+static DEFINE_HASHTABLE(depth_hash, DEPTH_HASH_BITS);
+static DEFINE_SPINLOCK(depth_hash_lock);
+
+static int get_recursive_depth(void)
+{
+	struct depth_entry *entry;
+	pid_t pid = current->pid;
+	int depth = 0;
+
+	spin_lock(&depth_hash_lock);
+	hash_for_each_possible(depth_hash, entry, node,
+			       hash_32(pid, DEPTH_HASH_BITS)) {
+		if (entry->pid == pid) {
+			depth = entry->depth;
+			break;
+		}
+	}
+	spin_unlock(&depth_hash_lock);
+	return depth;
+}
+
+static void set_recursive_depth(int depth)
+{
+	struct depth_entry *entry;
+	pid_t pid = current->pid;
+	bool found = false;
+
+	spin_lock(&depth_hash_lock);
+	hash_for_each_possible(depth_hash, entry, node,
+			       hash_32(pid, DEPTH_HASH_BITS)) {
+		if (entry->pid == pid) {
+			entry->depth = depth;
+			found = true;
+			break;
+		}
+	}
+
+	if (!found && depth > 0) {
+		entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+		if (entry) {
+			entry->pid = pid;
+			entry->depth = depth;
+			hash_add(depth_hash, &entry->node,
+				 hash_32(pid, DEPTH_HASH_BITS));
+		}
+	} else if (found && depth == 0) {
+		hash_del(&entry->node);
+		kfree(entry);
+	}
+	spin_unlock(&depth_hash_lock);
+}
+
+static void reset_recursive_depth(void)
+{
+	struct depth_entry *entry;
+	struct hlist_node *tmp;
+	int bkt;
+
+	spin_lock(&depth_hash_lock);
+	hash_for_each_safe(depth_hash, bkt, tmp, entry, node) {
+		hash_del(&entry->node);
+		kfree(entry);
+	}
+	spin_unlock(&depth_hash_lock);
+}
+
 /* Find canary address in current stack frame */
 static unsigned long ksw_stack_find_canary(struct pt_regs *regs)
 {
@@ -122,10 +199,21 @@ static struct fprobe exit_probe_fprobe;
 static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 				    unsigned long flags)
 {
+	int cur_depth;
 	int ret;
 	u64 watch_addr;
 	u64 watch_len;
 
+	cur_depth = get_recursive_depth();
+	set_recursive_depth(cur_depth + 1);
+
+	/* depth start from 0 */
+	if (cur_depth != probe_config->depth) {
+		pr_info("KSW: config_depth:%u cur_depth:%d entry skipping\n",
+			probe_config->depth, cur_depth);
+		return;
+	}
+
 	ret = ksw_stack_prepare_watch(regs, probe_config, &watch_addr,
 				      &watch_len);
 	if (ret) {
@@ -135,8 +223,8 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 
 	ret = ksw_watch_on(watch_addr, watch_len);
 	if (ret) {
-		pr_err("KSW: failed to watch on addr:0x%llx len:%llx %d\n",
-		       watch_addr, watch_len, ret);
+		pr_err("KSW: failed to watch on depth:%d addr:0x%llx len:%llx %d\n",
+		       cur_depth, watch_addr, watch_len, ret);
 		return;
 	}
 }
@@ -145,6 +233,17 @@ static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
 				   unsigned long ret_ip,
 				   struct ftrace_regs *regs, void *data)
 {
+	int cur_depth;
+
+	cur_depth = get_recursive_depth() - 1;
+	set_recursive_depth(cur_depth);
+
+	if (cur_depth != probe_config->depth) {
+		pr_info("KSW: config_depth:%u cur_depth:%d exit skipping\n",
+			probe_config->depth, cur_depth);
+		return;
+	}
+
 	ksw_watch_off();
 }
 
@@ -153,6 +252,8 @@ int ksw_stack_init(struct ksw_config *config)
 	int ret;
 	char *symbuf = NULL;
 
+	reset_recursive_depth();
+
 	/* Setup entry probe */
 	memset(&entry_probe, 0, sizeof(entry_probe));
 	entry_probe.symbol_name = config->function;
-- 
2.43.0


