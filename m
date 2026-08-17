Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F61C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B006B00C1; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D4E6B00C2; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83516B00C3; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE276B00C1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C92940711
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:05 +0000 (UTC)
X-FDA: 85110726372.11.B6AFA58
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2339780009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U6Ho1Vff;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVg4/TZVG9ztqc574oLKdjAEtEFRQxE/LsLX/hVOog0=;
	b=ELSKac3idzcOFE+HRdiJUoRPK8nSFTUjhfMtDAmNkc8GFmonm0miL4p90Iw5VApLlK3ATT
	nIMk7621WfgSDllxXhwvbO1peXF/E1hsoKHCA5fKUZ+pzizrHKc7cQJ0UBcuq6anMCmUg7
	qa2Fi+cQjSty9dXzuzPHg9QQN4it9Xg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U6Ho1Vff;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970584;
	b=VQfH6Rc+hC212cdp6FdyK1cuFgs74zRP4zcMf3rc4ToORf0WVTAjstE5TsjO6KfpGe2nZC
	9Msly8TZHAWMq7L6YV1xNWebYshahxs8+oYaL2QHYNbYsR0M0KWDmJ7CGy00dpt/kV90Bh
	Iq6uG4FhC9JtPEqTz0El/nFaAL60rzY=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c1c26d7e951so518784866b.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786970583; x=1787575383; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UVg4/TZVG9ztqc574oLKdjAEtEFRQxE/LsLX/hVOog0=;
        b=U6Ho1VffrPk+cZtNbMasmuNuO38jwPk6UYfzBMqRBAxxieKNOFASuFxfUG5de5R96N
         U0t0mwBxoblWK1qr/ItJpqx+sCNYceul+UVn36CoKf7msAJmOO+62n1oBTZUBwi2Yu/6
         APvmZZUABRZXdiTohHE5OTl4oRbTherLzrkRi6ekxQEJGdWWdnR4EG6PoStJjBAimTlo
         m3zc33OSj537RDrjYPuqLqxCq8Fao5Q08oXt9yavDF+0GHJm5jwjp6YKY67FlRL4vbWG
         K+jWEE3zq3uuph0UAmr2IMF822GpBAEMWwxawJN6ITxF40UrjzyN6ZKHiQWBz4IC1DVm
         SoLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970583; x=1787575383;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UVg4/TZVG9ztqc574oLKdjAEtEFRQxE/LsLX/hVOog0=;
        b=q6Z7VRIHLoiOW5Bzz7egWwSFAXYpaou3Nf1eveoZEUKwUO5O7b9/fYxPBJfXegaPYS
         gKJAeSZ36bHIxuvaKCyhtOZw1r3Vc+z0Ftm3El8nFAAiVlSg1VMskcBBHfVw7dfTfEZT
         PpAgqO4Fn9gacTI31E0HvwkovJFYne2uY3iGzN+DJqbhYPuw+Y9dU+1V39RvRczA4R0m
         YURQ2XyBBeQXqbvyoHmhja1KN+aOD02uvZe4crpNePNrmu1w3246qE83FtpAd8qqoThg
         JijQcJ8sR71FYXFSgvpbgIlROpkApFYoDIF2+BLgHPo7y+i4fTkpcyX+otEF6uyb/eXx
         Ywkg==
X-Gm-Message-State: AOJu0Yy0lBPWL+0uhN5EMOq4ijM5/Z7cBMQesxwUzcXzvMQAqhnPuFXL
	3Ag3/Deb3zIIIJAFJp8ZTDw3izQ5PUCMIEtenY0yqldIohIxKbUNkv1/
X-Gm-Gg: AR+sD12HrA46Udw/mbXCqC9/M5BgMnWa42ekCrWTOwyK6p6OSBcr7iSL/8uAie1Gx3T
	w6y1HKAbvkPoP8WxkGq6wGdVtjCjOcK1O+40x3tqCGH9iqndGMqDdPv17l02xnqUiuOiM/TeGD6
	hqlmcHzADBbCu/pbbTONj5Ii4RYmVSXkRaiXbURMTHwA4TK3HJ7T864aR7AtV3GHA8MtFtBX6B3
	Wgk4gJ/D0sb/Yx4QNYj12cjFObwqd1L5VaZ/8/QaadbR+J4h+6ZjlaOU6fI64kzj0tF8Sdm7La5
	gllzvWSWdEhHoOhukJ+ZnSBCKH6JW7EZVLfb8hMMkV4hLwTkdnFcMvV0oJo2rsd+fMGfjHgBrB4
	bjeq0aSeungw/SyUCRjVG2MubpQXNFphSZz7MKcaAz0OTUdOBVkRxEUgmiuwDG6FlMoCI7G/RLK
	P+xnlvxud3RODyX0hhyA4K9uDVBK/xWn5xNb4=
X-Received: by 2002:a17:907:db03:b0:c1c:3b06:ed1b with SMTP id a640c23a62f3a-c212aa3c3b9mr1120204166b.22.1786970582701;
        Mon, 17 Aug 2026 05:43:02 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:3861:1e5a::306:a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217feb99d4sm52626266b.22.2026.08.17.05.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:43:02 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Mon, 17 Aug 2026 13:42:43 +0100
Subject: [PATCH RFC 3/9] mm/page_owner: preserve accounting with countable
 stack depot records
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-stackdepot-trie-v1-3-53870ca1651b@cloudflare.com>
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
In-Reply-To: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: mfiazph8j1k5iu5s5zpnk8zg988om7sx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2339780009
X-HE-Tag: 1786970583-473457
X-HE-Meta: U2FsdGVkX18Gy7rj/s5ZC7mEfszT9WnwC1iXGu0T/CWK+e9ywZ80A0OPjd9sWGh492pQkuRRveB+neFieqWnWfR27Xe3aKzPi2dG+CT44lE8z6oNhoLyy79N1GSfPuMYJB/ocFozXJzcBNcFUYWZZQcctqncbGQVchKWW0j0mB7ERNLpa6FDYFKMg1ybVcUSCwIWEdebniSgWQc3Jmiohbl5nfb6oyex3IwFocD/VlR1mwkJVeg3rX3owtnsPp0wwUR2US8v6HvH0hld1E5qCriXTLxQQSoGTAZulJ7c5BAmlntkQE3SYLA0TVJO8tQwqkc6tsvybAXm0soqfaQSr0xSYHwIMGMgU++ASWqSaionM6EtyBmj3ZQj3zz0hvT0pOHbBeNkB+1FbsFxncrIWiSt0yjwYcK0xDQCd8/e8gsnxXeLlA1t+QLXVDgLIkl2KRRvCdVI1PrYibUFl2rNFRlwOBDO95Eme+Sbwq8KeZx4xpd6BRS9F8QWeM5YWnpCOEN3R5kxBB6o8IQv+w83RikBmdfrBZ3KhFRPLWpKmo3PpcV10bo/SmbGaRfJZq69Wde2jYVoP8o9/0/b9mVOru8z6d6rjSUayIomP8ypF6v1MAjqI4XroB2a8BEWQT0vRQzqgm7akz8f8cTyJBfFQiiSDnk88JUYio39yW6TTuhNh7/wYvAGjNacGL/4i3wD+s310vAmp6oN3MYylZCe8h8+PbV2UNJdaaKr+eVXIS+fDUbGy8H0hQafFda3duLZHuG7IlkRu0D/ZxtXYAI0XxdtQQ84XfKHdLls/flDL+FJzuzx5Mj0CY07QYcq+/uEisj7enqE6N87aQ/T3jt/4yatbV6lX6FikTDRggbIFDHQo5TTHtdaTd2mBNmv0lE9qu6czR56s1qYCpVgMc3PsHNMonhvoN8WmC9luNYkgMLsApG8dI+R8DGnL8tjceRy51oWnQdKIuBgNqB7XWc
 b1gle1ti
 Qy72ZDxSV6AzcGS4n55GmU2SKjsDk3NS98ELUnmWzJVYpnT6b3CLg2Z8mg32qirIkHWy6YazxrctUbShgXQp4HKlpy7e1Extdj7yITZDymBvFa5RGkrp1IPIlb/UZ9J082rmB04odJ/E22zaHI8kJt+AKiCqDY3YLRMz5liJqjlgePe4aXiIb5O6PBJgHqOAJkmjo6cW7mutLyqOeruRpcB1wJf9yWVRa81bYdcYs3Fc422rCvi0wcRQa4CjtgTVAmPe6BiGrjq0bvvkdbbI/yr4pLMRUpkuCRdv9BikRB4/CRhbLbo/O1gzF1xh3TMS2N8gQDDpsiS5198g7B5cCczut2dP7qDTf+JVnm/NnXtpNMwGEX3BXP3mNivD1hdckEdNUArlR4wcsVfbObwFgLGWaPtbIVfN2oBzl3Ohp3R7x1oYEkNQ2fvV5SAxjQ2SUbUC3G7MblL/vYyDNMWYreL/i3UdjgyO4oRTBXVlNy5wp6QMb24697rZBaEjSXj1ex8W6hGeq9Xr3ggdYk55kAPxQgA78wwFXWmsI1XxbQPqVmg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

page_owner keeps stable struct stack_record pointers in its stack list.
It uses each record's count with a one-count bias to track live base pages
and reads the stored entries directly. The trie backend provides neither a
flat record layout nor an independent count field.

Add STACK_DEPOT_FLAG_COUNTABLE to keep these records on the hash backend
and deduplicate them separately from all non-countable records. Store the
discriminator in a new u16 flags field and narrow size to u16. This keeps
the record header size unchanged while covering the configured maximum of
256 frames. Do not otherwise split hash-table deduplication: ordinary and
GET saves can continue to share records. Make COUNTABLE mutually exclusive
with GET because the two flags assign incompatible meanings to the record
count. Reject countable records in stack_depot_put() and require COUNTABLE
in __stack_depot_get_stack_record().

Mark both page_owner save sites countable so its existing accounting and
reporting continue to use stable hash records. Extend the KUnit coverage to
verify direct-record access and isolation between countable and
non-countable records.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 include/linux/stackdepot.h   | 14 ++++++++---
 lib/stackdepot.c             | 30 +++++++++++++++++++-----
 lib/tests/stackdepot_kunit.c | 55 ++++++++++++++++++++++++++++++++++++++++++++
 mm/page_owner.c              |  6 +++--
 4 files changed, 94 insertions(+), 11 deletions(-)

diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index 96544fc684a5..788737eb0c4a 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -53,7 +53,8 @@ union handle_parts {
 struct stack_record {
 	struct list_head hash_list;	/* Links in the hash table */
 	u32 hash;			/* Hash in hash table */
-	u32 size;			/* Number of stored frames */
+	u16 size;			/* Number of stored frames */
+	u16 flags;
 	union handle_parts handle;	/* Constant after initialization */
 	refcount_t count;
 	union {
@@ -84,8 +85,9 @@ typedef u32 depot_flags_t;
  */
 #define STACK_DEPOT_FLAG_CAN_ALLOC	((depot_flags_t)0x0001)
 #define STACK_DEPOT_FLAG_GET		((depot_flags_t)0x0002)
+#define STACK_DEPOT_FLAG_COUNTABLE	((depot_flags_t)0x0004)
 
-#define STACK_DEPOT_FLAGS_NUM	2
+#define STACK_DEPOT_FLAGS_NUM	3
 #define STACK_DEPOT_FLAGS_MASK	((depot_flags_t)((1 << STACK_DEPOT_FLAGS_NUM) - 1))
 
 /*
@@ -144,6 +146,11 @@ static inline int stack_depot_early_init(void)	{ return 0; }
  * Users of this flag must also call stack_depot_put() when keeping the stack
  * trace is no longer required to avoid overflowing the refcount.
  *
+ * If STACK_DEPOT_FLAG_COUNTABLE is set in @depot_flags, stack depot stores the
+ * stack in hash-backed storage for callers that need direct stack_record count
+ * access. This flag does not imply %STACK_DEPOT_FLAG_CAN_ALLOC and is mutually
+ * exclusive with %STACK_DEPOT_FLAG_GET.
+ *
  * When trie storage is enabled, persistent non-refcounted saves use trie
  * storage. Constrained callers only look up existing stacks; they do not insert
  * a missing stack. Trie failures do not fall back to hash storage.
@@ -190,7 +197,8 @@ depot_stack_handle_t stack_depot_save(unsigned long *entries,
  *
  * @handle: Stack depot handle
  *
- * This function is only for internal purposes.
+ * This function is only for internal purposes. @handle must have been saved
+ * with %STACK_DEPOT_FLAG_COUNTABLE.
  *
  * Return: Returns a pointer to a stack_record struct
  */
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 0278b7a013f1..1e5b9fc44618 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -2,10 +2,11 @@
 /*
  * Stack depot - a stack trace storage that avoids duplication.
  *
- * Internally, stack depot has two storage backends. Refcounted entries use the
- * legacy hash table with contiguous stack records in stack pools. Persistent
- * non-refcounted entries can use trie storage when enabled; trie nodes share
- * common frame prefixes and are published through RCU children containers.
+ * Internally, stack depot has two storage backends. Refcounted entries and
+ * callers that request STACK_DEPOT_FLAG_COUNTABLE use the legacy hash table with
+ * contiguous stack records in stack pools. Persistent non-refcounted entries
+ * can use trie storage when enabled; trie nodes share common frame prefixes and
+ * are published through RCU children containers.
  *
  * Author: Alexander Potapenko <glider@google.com>
  * Copyright (C) 2016 Google, Inc.
@@ -1022,6 +1023,7 @@ depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, dep
 	/* Save the stack trace. */
 	stack->hash = hash;
 	stack->size = nr_entries;
+	stack->flags = flags & STACK_DEPOT_FLAG_COUNTABLE;
 	/* stack->handle is already filled in by depot_pop_free_pool(). */
 	memcpy(stack->entries, entries, flex_array_size(stack, entries, nr_entries));
 
@@ -1164,6 +1166,9 @@ static inline struct stack_record *find_stack(struct list_head *bucket,
 	list_for_each_entry_rcu(stack, bucket, hash_list) {
 		if (stack->hash != hash || stack->size != size)
 			continue;
+		/* Page owner countable records have a distinct count lifetime. */
+		if ((stack->flags ^ flags) & STACK_DEPOT_FLAG_COUNTABLE)
+			continue;
 
 		/*
 		 * This may race with depot_free_stack() accessing the freelist
@@ -1267,6 +1272,9 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 
 	if (WARN_ON(depot_flags & ~STACK_DEPOT_FLAGS_MASK))
 		return 0;
+	if (WARN_ON_ONCE((depot_flags & STACK_DEPOT_FLAG_GET) &&
+			 (depot_flags & STACK_DEPOT_FLAG_COUNTABLE)))
+		return 0;
 
 	/*
 	 * If this stack trace is from an interrupt, including anything before
@@ -1281,7 +1289,7 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 	if (unlikely(nr_entries == 0) || stack_depot_disabled)
 		return 0;
 
-	if (!(depot_flags & STACK_DEPOT_FLAG_GET) &&
+	if (!(depot_flags & (STACK_DEPOT_FLAG_GET | STACK_DEPOT_FLAG_COUNTABLE)) &&
 	    static_branch_unlikely(&stack_depot_trie_enabled)) {
 		if (nr_entries > CONFIG_STACKDEPOT_MAX_FRAMES)
 			nr_entries = CONFIG_STACKDEPOT_MAX_FRAMES;
@@ -1374,12 +1382,20 @@ EXPORT_SYMBOL_GPL(stack_depot_save);
 
 struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
 {
+	struct stack_record *stack;
+
 	if (!handle)
 		return NULL;
 	if (WARN_ON_ONCE(stack_depot_handle_is_trie(handle)))
 		return NULL;
 
-	return depot_fetch_stack(handle);
+	stack = depot_fetch_stack(handle);
+	if (!stack)
+		return NULL;
+	if (WARN_ON_ONCE(!(stack->flags & STACK_DEPOT_FLAG_COUNTABLE)))
+		return NULL;
+
+	return stack;
 }
 
 static void frame_run_init(const unsigned long *entries,
@@ -2136,6 +2152,8 @@ void stack_depot_put(depot_stack_handle_t handle)
 	if (WARN(!stack, "corrupt handle or unbalanced stack_depot_put()"))
 		return;
 
+	if (WARN_ON_ONCE(stack->flags & STACK_DEPOT_FLAG_COUNTABLE))
+		return;
 	if (refcount_dec_and_test(&stack->count))
 		depot_free_stack(stack);
 }
diff --git a/lib/tests/stackdepot_kunit.c b/lib/tests/stackdepot_kunit.c
index 75fa16268c0b..be14cae98fcf 100644
--- a/lib/tests/stackdepot_kunit.c
+++ b/lib/tests/stackdepot_kunit.c
@@ -167,6 +167,60 @@ static void stackdepot_snprint_public(struct kunit *test)
 	KUNIT_EXPECT_STREQ(test, actual, expected);
 }
 
+static void stackdepot_countable_public(struct kunit *test)
+{
+	unsigned long plain_entries[] = {
+		0x141000UL,
+		0x142000UL,
+		0x143000UL,
+	};
+	unsigned long get_entries[] = {
+		0x151000UL,
+		0x152000UL,
+		0x153000UL,
+	};
+	unsigned long fetched[ARRAY_SIZE(plain_entries)] = {};
+	depot_flags_t countable = STACK_DEPOT_FLAG_CAN_ALLOC |
+				  STACK_DEPOT_FLAG_COUNTABLE;
+	struct stack_record *record;
+	depot_stack_handle_t count_handle;
+	depot_stack_handle_t plain_handle;
+	depot_stack_handle_t get_handle;
+	unsigned int get_nr = ARRAY_SIZE(get_entries);
+	unsigned int plain_nr = ARRAY_SIZE(plain_entries);
+	unsigned int nr_entries;
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+
+	plain_handle = stack_depot_save(plain_entries, plain_nr, GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, plain_handle, (depot_stack_handle_t)0);
+	count_handle = stack_depot_save_flags(plain_entries, plain_nr, GFP_KERNEL,
+					      countable);
+	KUNIT_ASSERT_NE(test, count_handle, (depot_stack_handle_t)0);
+	record = __stack_depot_get_stack_record(count_handle);
+	KUNIT_ASSERT_NOT_NULL(test, record);
+	KUNIT_EXPECT_EQ(test, record->size, (u16)plain_nr);
+	KUNIT_EXPECT_MEMEQ(test, record->entries, plain_entries,
+			   sizeof(plain_entries));
+	nr_entries = stack_depot_fetch_into(count_handle, fetched,
+					    ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries, plain_nr);
+	KUNIT_EXPECT_MEMEQ(test, fetched, plain_entries, sizeof(plain_entries));
+
+	get_handle = stack_depot_save_flags(get_entries, get_nr, GFP_KERNEL,
+					    STACK_DEPOT_FLAG_CAN_ALLOC |
+					    STACK_DEPOT_FLAG_GET);
+	KUNIT_ASSERT_NE(test, get_handle, (depot_stack_handle_t)0);
+	count_handle = stack_depot_save_flags(get_entries, get_nr, GFP_KERNEL,
+					      countable);
+	KUNIT_ASSERT_NE(test, count_handle, (depot_stack_handle_t)0);
+	record = __stack_depot_get_stack_record(count_handle);
+	KUNIT_ASSERT_NOT_NULL(test, record);
+	KUNIT_EXPECT_MEMEQ(test, record->entries, get_entries, sizeof(get_entries));
+
+	stack_depot_put(get_handle);
+}
+
 static void stackdepot_fetch_into_roundtrip(struct kunit *test)
 {
 	unsigned long entries[] = {
@@ -392,6 +446,7 @@ static struct kunit_case stackdepot_test_cases[] = {
 	KUNIT_CASE(stackdepot_trie_max_path_roundtrip),
 	KUNIT_CASE(stackdepot_save_flags_public),
 	KUNIT_CASE(stackdepot_snprint_public),
+	KUNIT_CASE(stackdepot_countable_public),
 	KUNIT_CASE(stackdepot_fetch_into_roundtrip),
 	KUNIT_CASE(stackdepot_fetch_into_rejects_missing_or_short_stack),
 	KUNIT_CASE(stackdepot_trie_topology_roundtrip),
diff --git a/mm/page_owner.c b/mm/page_owner.c
index fbbda7ba914b..af37532729b0 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -119,7 +119,8 @@ static __always_inline depot_stack_handle_t create_dummy_stack(void)
 	unsigned int nr_entries;
 
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
-	return stack_depot_save(entries, nr_entries, GFP_KERNEL);
+	return stack_depot_save_flags(entries, nr_entries, GFP_KERNEL,
+				       STACK_DEPOT_FLAG_CAN_ALLOC | STACK_DEPOT_FLAG_COUNTABLE);
 }
 
 static noinline void register_dummy_stack(void)
@@ -181,7 +182,8 @@ static noinline depot_stack_handle_t save_stack(gfp_t flags)
 
 	set_current_in_page_owner();
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
-	handle = stack_depot_save(entries, nr_entries, flags);
+	handle = stack_depot_save_flags(entries, nr_entries, flags,
+					STACK_DEPOT_FLAG_CAN_ALLOC | STACK_DEPOT_FLAG_COUNTABLE);
 	if (!handle)
 		handle = failure_handle;
 	unset_current_in_page_owner();

-- 
Git-155)


