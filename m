Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 400B7CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32C36B0093; Thu, 18 Jun 2026 13:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07D06B0095; Thu, 18 Jun 2026 13:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC8C6B0096; Thu, 18 Jun 2026 13:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F8516B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:36:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECDDE165918
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:45 +0000 (UTC)
X-FDA: 84893738370.20.1CBE2BD
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 273FFA0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qHMW3kDn;
	spf=pass (imf15.hostedemail.com: domain of 3qiw0ag0KCC0JKQRbQNTKJYJcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--abhishekbapat.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3qiw0ag0KCC0JKQRbQNTKJYJcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781804204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HvIid687XPWlqwQBXwULFWBBKUy8bJsEI/wYE9guJc=;
	b=p3wlFmrB8TZ+gV06BrcdDmHE3vp/1ylvIfvcpTi4chAc//3L0YujecxhOsRCzyot34vjJp
	+B10T4oGRywxsq/uf7Alz390fH03xCk3/9yu5ivgUI8rr005X5E82DEX8SD+05VqaoEMJy
	hF0Br758HLAlRUoWqh0AqpB/kOWIj3k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qHMW3kDn;
	spf=pass (imf15.hostedemail.com: domain of 3qiw0ag0KCC0JKQRbQNTKJYJcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--abhishekbapat.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3qiw0ag0KCC0JKQRbQNTKJYJcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781804204;
	b=S71NeZVqITwTt2f+o5MguMKN1ibT9hzncDFse9LsPo/M+qT/DS5xsZ6F2RQs/3PVxME16d
	FT/WeKXgFxitlz8CsuoKDstbPyCfEYo+dHo3e1zlfKw3xZTacqGp5RMg6PREag4lQ6IEX/
	gE2UQO8fZf0/Wpsx41mW2lJckmPSiKc=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-138156c0492so4336192c88.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781804203; x=1782409003; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2HvIid687XPWlqwQBXwULFWBBKUy8bJsEI/wYE9guJc=;
        b=qHMW3kDn9MqzNiDbXjvkflc6z/kmama6M/MxLo7cOe0fEfrEei9dJ3H1arljyfRaqj
         UiK1Vz3YfWSWrfbnrvR3lhYFTOgMghhxRr4/uFhxHZT1ROGY0XiygebxyoGZGBXAXJ8Z
         wWIgBtKxhKvXvG00YP36oz9qsdHIV8FyDV7wg3jH+7ZeZg6z1qpqe09pvhwsPAT5gNAL
         TCEoBeNaCU0/1rFC4gsZHWcv51noA0V7xKP/2t8BOdZQRyxSA4uisgkERGd8ySWZ/Vlm
         bWG2PwMdc1E0tcwfX1y59CnYgxpa+HobSoxj+LM+TWlQ40HL7AuggZGiRuhiWS+HzxS0
         ruCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781804203; x=1782409003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2HvIid687XPWlqwQBXwULFWBBKUy8bJsEI/wYE9guJc=;
        b=ZTqpmgUpXcfmFOq9Rg8dhMpqkkrveNRFYBHdaBnQHHiEjYjt5lBzYAeCine9QsmXuE
         ki5KMvw0eYaWN7OTrCJ0bxjvU+X8nG+fT5joNANvL9JUFc9Lqw8VxEhAfzm119P/4DGK
         IBwi6ykSytAbGJbHfuEPZ/ZvaAInADU6P5Zcsi5tcLEsJa5JYYaoWE+x6l7LmjIGblkc
         Ekyf/tL6SoeVySr5dQIlj3OV1vTcCtz7sY/HpIWIiS3SPThAtVP6YZGEbW9zNmVhdD+y
         ZWCNgCNufk5buIX1XF78CwZ0GXlcB4aE9jfLQ4bcmx/7pzXQAlUEwvzoJNMzW5VQyyDG
         l1EA==
X-Forwarded-Encrypted: i=1; AFNElJ+DWIFdAr6aYphYWjf7WW5kNGkQ0MkdaNqXD7vkSlhiLOxmc8PqlTrEF/CrV8iI7ooDzCbZoaYR7A==@kvack.org
X-Gm-Message-State: AOJu0YxoBhXehmPASa1KBIuW4Sm3BVFtIJrlvMQedEZZRCKYTn2vFV/v
	x8/xkqijX5Nr2oFKJor33IOWDvw+RmaC/kH5Bj1iAztt4488MHWACBPcKOudvrT1Nixj2iouS03
	xESrQEAlfdImRU9VIiXAtD4MRHklM7uwebQ==
X-Received: from dlbqd13.prod.google.com ([2002:a05:7023:b0d:b0:137:e7d3:1490])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:688a:b0:138:2f96:dc0d with SMTP id a92af1059eb24-139a20faaf9mr460012c88.9.1781804202465;
 Thu, 18 Jun 2026 10:36:42 -0700 (PDT)
Date: Thu, 18 Jun 2026 17:36:33 +0000
In-Reply-To: <cover.1781803482.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781803482.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <bf5b4b584f01b35d8b8193fe45b55de252d102bd.1781803482.git.abhishekbapat@google.com>
Subject: [PATCH v6 4/6] alloc_tag: add accuracy based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 273FFA0005
X-Stat-Signature: mconxmzxbnxbiyqig67h6qxwwtjjz3hm
X-HE-Tag: 1781804203-85228
X-HE-Meta: U2FsdGVkX192FOiA9tZ4R7Z+wZsZmWtDe/9+a6JYtGN6lH83poP6fXP1B6tzWVEHpnZvoG5GcQk8HPWQ9UY30hXdRULTIwmMbZ8VTf/XDozAxcQUr0IcKyaL8+aAyKrfjoNO11wdXBb8xyrx36mh7t3qjw7TJ7kxBeqw161O8dUGjV1eiv/loSL1AYvjhqkFYzFUSzTtOLhe3zQQZ6/ai3XUEWDOdD9QY/jMmewr8IM4itGse9jhuev5TSl+MxJSI4HVFtkiLgP69copFeP+6dUrnrnl5IUosDVp5QkPbBnNjYI8RECJYaSNoWZ3bpASPf05qFI5d6PjZTsAeeiu1t9oy2C8FWsjOIiLwKiRXEN9/L+f0KvzZmyyu6t/TWKa29WODVpsn1X9iKX8x+w3XO63tXgAArS4ruC7BfDEjKJDCDuSNNJCnQYl3CVqd/ICMznLhPaCLNUDTf4SKrjr5U3lnuC0FRHOuJWQJfRJAyQT6IopPezE0PN8TCX0DlDCyTLU83rEnlSXRqW4I/I6U0K+gmdP1GKHDVtLo3wd+54tf2Sm5P9yKKiog1lx6xpvj/X0OEIWvwOQ9R/pqCwVnYTEbvz1vItLHjNlDUhRr+AuYVIM3eXB90JQXFLEWIM7JGp84G+Puia4TwdNHlGwH8ZgNVOlzpkJ4z+pcMzBJfEfKdGgHf1EaFs+zihqPjhKye0uyiO8BmzbaqKIHc1FP7tE/yWlcd1Jj6MQkydJDtejUHmjAVN99pbr/HKqNSwXUAVZPM/n2QxpRNJIWcpi1VUDXcID8hMKUiRj+qxqDXRDB2W/X6YK/NImIBuNMEVZ+J1aK9SYcsdshPlIO5sare4vq6hNoWKj2x4Pbr3Gjh0iu5vLYYC/WekgNeTaJQjjIeuVhlfPu5ShjZOMyA2YINalJI1mp5D5xZ4SpxScVm16kmuWGrv5HqQgtWzppgFaaCgh4QkzKVCjRZG3rwq
 TQHNUe3Z
 Zw4CEowFyJTMSxotg5a7Ds9JXy9Y2K6VnN4x2xQAqyK7SbA09w4Lmjlhmts7kNWxQD/rlGuW8uiYJZVVsw1SeRH8mZOayfJdjjNqoD1Mky6mktorxiR1ZY1gILdKKnt0DNxNRzkKFIUKWfxEO+INhoVujfEfKEixFMoatLXbD0bSNU5EQt4vcpkRqwbVk9WV1/OyF6MHzT8yk7Vd/4M955p/AYub/anPYfTKXy4DaELRUJO7Eu4hGvGeNNLWtQ5muP+tmsJVwTBBYlBBqpczzcWC9rWa+f6epbC21kdqU2YB7i8h54KHGzg3s8loA8r3pfNuPLFs7NONPQT/a2QVmjP3NTgk/J03cKVOoXSn/m4tePTYMXTEiG7TkLXsqQ4mwXA3lDOodKrwOYhNCGS25/hW/II2g2dMzfMRGbdY8/0Nd7uynncbKWrWiPJ0+4V92U2VhWMkl1yGdQc8JkDy8onF3J4EXfBI1XZxWHwXLCMjnv06OFsM0idol9pJLEXMuTSPEy56Fd2zVHoQwswwgqYIF7nNuxhJC5uuOiHPxI0tg08+zakDmj9OodfzfhWftB8GaraYkT5HZqTSltmbwnx3MS0If2hBWRnAPvlQ0ZEnZ3TriOo4HzznNggsWFO0a/WG0vtOL1GKaXlXp5w7Lz+itexcIhpNFa5tR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their accuracy.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---
 include/uapi/linux/alloc_tag.h | 4 ++++
 lib/alloc_tag.c                | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 0de5fc180790..270f693b1822 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -31,6 +31,8 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
+	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
+	__u64 inaccurate;
 };
 
 /* The alignment ensures 32-bit compatible interfaces are not broken */
@@ -50,6 +52,7 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
+	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
 	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
@@ -59,6 +62,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ad33d63ef7b4..32ac0674d8bf 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 			   struct alloc_tag_counters *counters,
 			   bool *fetched_counters)
 {
+	bool inaccurate;
+
 	if (!filter || !filter->mask)
 		return true;
 
@@ -274,6 +276,12 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
+		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		if (inaccurate != !!(filter->fields.inaccurate))
+			return false;
+	}
+
 	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
 		if (!*fetched_counters) {
 			*counters = allocinfo_prefetch_counters(ct);
-- 
2.55.0.rc0.786.g65d90a0328-goog


