Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A70CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013BB6B00E1; Wed, 27 May 2026 10:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F073B6B00E2; Wed, 27 May 2026 10:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44206B00E3; Wed, 27 May 2026 10:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D55B86B00E1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:06:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9AB98E756
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:06:50 +0000 (UTC)
X-FDA: 84813375780.15.F33A8ED
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id E2C75100014
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:06:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QEgjkc8Z;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grLDsIqWV1YHU9+uNN+g0k8WBJT1n49B8J5hsZ/KNBM=;
	b=bUw+6jfnWsxYwrag4L3zOHWSU6EefwB0l6dlLNIsAr+2CK0LgEQJaUr7rzD/JzvFSaUSes
	Z0F3EBKVQNYd+rCwVsVSpRRnhV9+kaF3hwJ+vjnLCiuMskRI8tXWS/PTQqm7qf3IJwTuDu
	kqcDMqcO1oM/XhC3I2wiKfewwHPpgzk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QEgjkc8Z;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890808; a=rsa-sha256;
	cv=none;
	b=o8U8C2wtzeUtFVEe4qAk5DthUBr7eyfr/3GZsPFNxH26K5QCYf7EHXn2EObl8RdgVY57TE
	rfYmKdW6rvtntFjOnlia8mOj0NAlZ/Jcql30BgTmyQrL4aL3fi6SaU+SIpNKWeMrOfaquB
	vHkEz3JTeYnXJSbGhMBr69B5FOiAP4I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=grLDsIqWV1YHU9+uNN+g0k8WBJT1n49B8J5hsZ/KNBM=; b=QEgjkc8ZiHM0a65uX8TFwr0ni3
	0VWPsqHr237btqTgnn0azc/epmWYgkd2lC+4KG/Lqs5Q+foW+/8BlZc7+4EBg1hvUAiEVTz11298L
	nND5hSsWnlSTzfzkPOXpYgoJZyJB2LRi/QLYf3q1ej71q2fd8mB8N49iSG9O6aq3r77nhM/vHZoW+
	DTmP4aTR4Up2viHeZawCjyt2Hy1NND+1md40acVax581K8QqtgXILaXo8bMzTaBrd+YbBsWIt/zqq
	xgG5ITpkw57emP87MzsX7XHiVcomYS/axDADRCTQHTQxnTRXoLXvSx/Fg8NYA7IbL93BRb8lX9VIB
	mhHvq0ow==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wSEuA-003DTD-2w;
	Wed, 27 May 2026 14:06:43 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 27 May 2026 07:06:16 -0700
Subject: [PATCH v8 3/6] mm/memory-failure: report MF_MSG_KERNEL for
 unrecoverable kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260527-ecc_panic-v8-3-9ea0cfa16bb0@debian.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
In-Reply-To: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2349; i=leitao@debian.org;
 h=from:subject:message-id; bh=ScD3PYIZI0a0zheAr9zG3EYnPdJ+1Id9YqVY4Vqhi9M=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqFvpbSHPg/Q3Yw/y6hVA3+yUCTI5vOf63OaaDy
 PBtuXI33n2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCahb6WwAKCRA1o5Of/Hh3
 bfXJD/4243i7IKsLyoJqofCvvgKk9Dsh5l+ijiS4/qpYxUtgxCTg9AGQ7dwb6gA1j5ynY2ualvU
 hueGPfZztKfg/yhB6R0A9SzM8tXHXMRqgicNVspCzCvs7MeKkemykMLcT1oudAxIVxwyjrprib3
 SaDs2sTAL3SJA/MRvuTWOOyQiewhmH4vjtlutp9FOHWTfCiO6Zy83C+F4OeQ1827Vspm8ME4eBS
 HM4ZMPyC9+iv1mQS9djCxHdMpnzLSMg7KW2spA342HL9gP3dnFw4KOM2tVrKDA7rpfptTjnqX5K
 Idi3cZ9REl08MWzDB+IDTGEdgsO7ATX2g9iIbnfKiRb8TvIIkEcZKi+GhFyI1FvJfXIr2HDeUcD
 RPC0xxN4mZb5ejFmqdv3tKBwxwo+JUd/RI3NKgXbxoL1qFJYvwEujqb02oyHA2YG9rrvBlCED1a
 p5hjanYu66vGyfWMYAUDSSrbJGyF3wPn0R8EbB2LcXEJhNAGbaFVqQg4EBE1xVKZANHxAEUo5f5
 jqAp6CVyRnBBkn5jcOS5YGUjYoQcuLGjIMD3+fe+oWNBRbsFkbVQWNSp9p+BMLoHz3Vi72bnbIu
 1SKWwuvZVfO/swdzfQ5iF/sQiFIWYuYUWQTQAtnczGshWv1wttb0tLuq8OP+WR7cBmIuE4RQ18D
 UuD/cCh1h76EoYA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: 8rkesmuqiymej11ttcm9ken4qeqnye69
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E2C75100014
X-HE-Tag: 1779890808-930353
X-HE-Meta: U2FsdGVkX1/KWRs9tnHG9Hu/74GvF7gi9d6kF1OKU/LqFMujvATP2XgPGhHJf5sBJ1ljC4BDfUQQ5/F78Ls+HuFV/93h9ZQUNncQ6q9nYxLh9QnoNhRzHI7NaW+Fwqvlxe8TU7pVGcLw/Z4GzO4tsWvIGGTDlgIfAcUY7JopxFuTK+O4cvY94+DEs8uwnhrWtL/WGgYw+865KIaB+un0/6a1+T5vjbLXmrVUGINfZvQnc3qvJmropZUuKSLZnWFDLxgl0TQE4oCAy4Kmyio4KY3wahFDSaNOJlOtQtHR75KbfOZK4LF38v3u/0nTU+GGEm2fA3EgAWz3N3G2sLe25hpzDkTopphCjL/gqTKcY3aVaHd5anjwqDNKBXppfsXL8INCOza8VFAsuKD7C3ykLTWlu4Jiv25AOVNInb/Sh/KrNZlOOxUIG5f0BtetHTFk5AIMEnwhQ0P0L7sBaXHH/L/dQMhsIsrRE+VeyTvU9mSZXyxkZI1DWLmK+sSxCaUcO5YII6cOaSh4sW5p2h47xXfNeZofDEZUdE4+NIwN9MOWu1fkN2MLOaxt7xhsMZwlUg+bEKbGhZiyJ8qWOBaSoOskZshiMxYLf6WRG36jERp58FVfrNronLUlm8Zk3+0VQy9xkMewrZUsvdJU+LSh/d5zp6CRhKNBo2LuEtDpC20JgVEpF12Q7mQ6jy2kzbR9A9tef2KdKfdaVhjzG9PM5Nykqod82Vgc7bbeOgFhsb8/lPIJNpBrsnEBKQedifymeHlkYA2YZQDo2w5NStD1gjMb5qwefsclgA4XFJPCgKvPI8SwNxFr+KcRJEErQD4LknoWPtNJTKDvTBaCqB9hWLHgc64IPnix3JaEWqNN+k7/8hxx554cc7/Z0S+VLLaJhvFyHLFEpGNIXpffFNYuvaK0tVr2KeAEMFTojZZ82gs/SKncLOMWGgtLT3D6Fkm2q7HacHI8jmIwVCUKw/j
 OgVaMT5I
 ZoCs3nxrCygY1itV7pH8arwopUUz/sqW5elpa2SkF8cfWHf1is9w40Q7Yq27box+zZtrm6TO5WwOm+BXVF51TUihlw1dvMYgW83LuO0E437E5Mt2gr23K5+qOfOlxxQZAQbauPgxabcH4wFUnquM5t85liDKraYMKd5e5ceqXws6e3BMzMu6GbdGKahwQJEw8Bq/fOOCqAbFfxWNShFwB6ioN5PuJGLf+A0IIk2jfAgc22gPJSBCvf3KO+P+k2oBMqbRt+F+kuyCAmF/U9r+qJMmAn/Zaa7DPgCGjqV49PU1fxoHzJFrhkBc8CnSYZX2N2ibdliNq8Ae7YnLYMgcqpx7SbhTSXcYevrWEyttx/B8g3W62lKDw0RlV9eK87XOFFJdZpXHkaUpcEmt+wJhicqQQGDeSCriSwsfimjcawcEa5eA=
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
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8f63bdfeff8f..14c0a958638c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2426,7 +2426,8 @@ int memory_failure(unsigned long pfn, int flags)
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
 	res = get_hwpoison_page(p, flags);
-	if (!res) {
+	switch (res) {
+	case 0:
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -2445,7 +2446,19 @@ int memory_failure(unsigned long pfn, int flags)
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
2.54.0


