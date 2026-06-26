Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7B41C43211
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34E3F6B00D4; Fri, 26 Jun 2026 11:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF146B00D6; Fri, 26 Jun 2026 11:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDC06B00D7; Fri, 26 Jun 2026 11:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC00A6B00D4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:34:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A160A04D8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:34:03 +0000 (UTC)
X-FDA: 84922459566.01.6E9F8BD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8A2921C0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:34:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=R+ElvguU;
	spf=pass (imf20.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782488041;
	b=iHOLvOALO+1gEbn82u3pscOFcP+o/l2WSdaCBN4QqXNimfVw+ImZ0QTCrzbjv9x1yCWOSW
	6WvN4TJezAnyl31tNIfDpw1uMfdrxyYdAVjBTsNM/0rOL1zhwoFAEGjvKk6stNkUZytwWC
	35LnSeZH5/DemBibqeureTbAdcVOHEk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782488041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cGsV/GIb69F9aFisOiw65pvcyGs/UN2j5N9RMecrnA=;
	b=IlqHhk7vipEoAJh1/ladIwXvlmkXRhYSErAK6SU9jJFjCzfLvcK5Z2g02AcUTbhRbjX7Y0
	YHwpzZzgIp83xodNC53oIGCg65waA2L0/8pm8AC18rK/C9HTNNJEYmayX6xahHLEzopTAR
	OhgWrnro1B4enMjDBalDaGSwCHywZMw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=R+ElvguU;
	spf=pass (imf20.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=5cGsV/GIb69F9aFisOiw65pvcyGs/UN2j5N9RMecrnA=; b=R+ElvguUazaRsX5LZ/Iv2jENMg
	U04nTy7B1v/7/h/4v3SAz55boZ4zWs433Mwb1yP7Rq7pNT+ZQhx3N4AM8BBmx1WKmZRciHhXUaorg
	RixBzuXWhImd3MEEEI9PZnyB992D/nXxg79UvXBcODlF7XJebhjVjCDame6vvL3G2dg89rfZ2YXNH
	rBHHfiZt/JsMT2BU7a/nMgXrZQ5lPe0BikY8j2hjeejwc72YZSh426CKF4ahgmqYCyhYDWTU9w56r
	w1gp/2LIvUr+BG8acEoHYpW9YJmaClw+L+1c/LE06h92pJuEsGLm/YAsw/atAxX301T0HH8i4CdeI
	b/HK6/MQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd8Yu-00448L-1C;
	Fri, 26 Jun 2026 15:33:48 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 26 Jun 2026 08:33:17 -0700
Subject: [PATCH v10 3/6] mm/memory-failure: report MF_MSG_KERNEL for
 unrecoverable kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-ecc_panic-v10-3-6dacb8ad024d@debian.org>
References: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
In-Reply-To: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2455; i=leitao@debian.org;
 h=from:subject:message-id; bh=s2QW9XqvL8WjZfXefwNoMxA+bTjAbl8h4pWt6UPLNg0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqPpvEksQl12A/z+cCFlT5a56cpPKQDQtLbk7w0
 4d+6v+0RMKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaj6bxAAKCRA1o5Of/Hh3
 bVNiD/9SX076q5vGZiW2lgbbjfY+ggMk1c05Mw+nXFbi34vQfYN4L7EoW3mQlkCxzJ9hkpMH2dv
 DCNd6XPue6dY11w2akyjJlOzjYZnyHIDEVPyTiGGHF6emB653b1gp9+wySSJ2G1erY5nLomjTmS
 dUzE4zvj52+venVYza+suoJzQ0O1Nn9alK4mKE71ANHiTne6EFJ+Qh69GeWPqBF8zwn/YmwPetV
 WBjZRpkoyePndEOpCo+lzWHJum0L13HyCyvDXoesiU2KLtiBI+r2t4Jqp/OfBUapm0teEZMe530
 8/KuNwiE8GfaRiWiwNuZfdSkAO7VkAvR9AUiTCozpRFTZm4UBwLQg5Cxyf5MmR7sqaXB7IEG7ND
 OB7+BvywXxhMTpVldg1nXylQKh53mqAmlF6AFssI89QI4ApwleJwYgzTxB2C30pua3BcHKpJXyE
 F3Y97D8F1hjl9DmQeXQpYF0mYhAQrsrcbk+o8Ceus4UGMtZAqJz9Nol2xf1SWFAmfgx6zVbRVC5
 WWKsxE5WFuSqHgIyNkOQtKDcpalT/gdJFKfK2OzpiTAnr6eJmQpxtE/0ZiVLrShTQVV+Wl6vIfJ
 PBlxTTYC1chaBsTz4D311WVkG53ml3azBEXdBNBOb+mjX9CKwNVssQRt6t+jb7i7qpfnXorkoMT
 NF4BubXxohc5JcQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: o17461rft4e5toikpg8izjtdeozriimn
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A2921C0005
X-Rspamd-Server: rspam02
X-HE-Tag: 1782488041-231161
X-HE-Meta: U2FsdGVkX1+c9IfVHb/BDC1zYHhz3IfO1ETGB2TUqv7qR67Cgp30t7Ekh3hxvI+wP3cZb60/Zm4j0lQ4OHwZcMIYWD5xouk7Hffcf7t6uWHAKrktnxIKfikULmFfxgg6U85GIknjtTwJ+tJl3mGp60AQWywl5z4BRafTl19JagcvKzqEtgWtiCpAkytlbqgc1gz4i3XUkMPuGaox1hM9E2xkM0d10wFisRxhiMZF87Ujb5/o90/vty7Qr+4OBKpjqDf8tQQg47qEalUZktuadDOHy3As3STQYxjkAMQD5quZeg/rq0JLBWGEn23+e+FycTz4+jEObpC+535j2z74ZMvfsahoYOg1RHp5Jz5nGQntpqZbZtFHbT6QE6ur6zq0mWtkbbXW/maOFeeG8U+APrwmHxXOc/bwY8QsNp5G6Py85LVAw77m1/TVXi8wTpEJrwqjyyEM3oNTwZe9lHXGKL6Xn1Zi6Yprx6gb4Efnsp6BwrBDZe2U4eAKqL7i6euOpCl9MFS361kpCAGshwxYMSBTvsnjSv/KFvEknCgjl5nqxPf68+/2LgJSsYOr9pj2poa9OG1wCYEjuwtdjkoA+d9K5I/OUP1vWAdF1MpZRDBKlIYQdUL5fBK/b78pyLrqM2DkIknUIdI9wfbLld4MzGublUldWXXWAxPKdMcbFRbWQkI2NmGWrZPMVDMgpC8HAO9gYXJBldI0/mNNMqhmUiLwfESaiAcYr8i6B+riatHS3h8FkIcJm4lFQ0NqibPQqbzzAKomqQ16dzzrzW3ZspI9C5kbsbEYoCNILV4Rm8i40/E/2zPTJmjVJ0r/nHvrYTG4hbbZ7BgLp1kI3TMOEw3UsPQP6VfYngvzd5T+faWfX+k/IdCXlGdwaMbkhCOpXSNfvSY4b3M0gvgwTQEe9P8D+Mp1wom9euklarHzwSidn/P5VI0YKzx5Q/j90SdCeSlDZNmzjM/CXxX7PGu
 0N7ed7wb
 XJIzzt+zexVywdODzQl9Zz9B1PjU0biyNLktrYffT5bQPS7mleybjFNtz109kTJaZDeExYR/CGHmDlIZC/btcjG7/gIdw9/e857Frvob8OGsVaDMwEt/rq54RN2W5BYMAOqSgg8wp5Pp1ca833B149S9gLYN6skwKL4jKqKkhP/LKqtvCj6pE7woc9xppCuAGBz0j665Q19HPa2jZkGTMnfj0iSbxdoi6M8ep2SGBBIXuUPtHL48ONrses5TtaYErpA+6a2WqvbPL1K9rL1qJXanXK+BojEFgu4vXoJY3hOsOxMEZYeatErZfBeNwIfShLkLGo4pZEGRv/1L9rtA6RjTL5ia/Sbtw7eHovQm0G09Iq0IDbilwApmSqq6KqnoOcAqPkwT7aRXrzMqTX7Gz0E/yO91t9LFtoIYQCUaDAWefzSbv0CSce/Y6aePrKP4vLwAs93uwoNep4IA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous patch teaches get_any_page() to return -ENOTRECOVERABLE
for stable unhandlable kernel pages (PG_reserved, slab, page tables,
large-kmalloc).  memory_failure() still folds every negative return
into MF_MSG_GET_HWPOISON, so callers that want to react to the
unrecoverable cases (a panic option, smarter logging) cannot tell
them apart from transient page-allocator races.

Turn the post-call branch into a switch over the get_hwpoison_page()
return code: map -ENOTRECOVERABLE to MF_MSG_KERNEL and any other
negative return to MF_MSG_GET_HWPOISON.  case 0 keeps the existing
free-buddy / kernel-high-order handling and case 1 falls through to
the rest of memory_failure() unchanged.

The MF_MSG_KERNEL label and tracepoint string are kept as
"reserved kernel page" to avoid breaking userspace tools that match
on those literals; the enum value still adequately tags the failure
even though it now also covers slab, page tables and large-kmalloc
pages.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d08fbd0d8c39f..8e2aa2fafc14e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2434,7 +2434,8 @@ int memory_failure(unsigned long pfn, int flags)
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
 	res = get_hwpoison_page(p, flags);
-	if (!res) {
+	switch (res) {
+	case 0:
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -2453,7 +2454,19 @@ int memory_failure(unsigned long pfn, int flags)
 			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 		}
 		goto unlock_mutex;
-	} else if (res < 0) {
+	case 1:
+		/* Got a refcount on a handlable page. */
+		break;
+	case -ENOTRECOVERABLE:
+		/*
+		 * Stable unhandlable kernel-owned page (PG_reserved,
+		 * slab, page tables, large-kmalloc).
+		 * No recovery possible.
+		 */
+		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		goto unlock_mutex;
+	default:
+		/* Transient lifecycle race with the page allocator. */
 		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 		goto unlock_mutex;
 	}

-- 
2.53.0-Meta


