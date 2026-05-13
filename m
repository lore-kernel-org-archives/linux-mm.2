Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EFEDCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85ECC6B00CE; Wed, 13 May 2026 11:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835816B00CF; Wed, 13 May 2026 11:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725266B00D0; Wed, 13 May 2026 11:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 612016B00CE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:40:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F24A8C03BC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:40:19 +0000 (UTC)
X-FDA: 84762808158.01.5554AAA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id 29AA014000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:40:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=O9sZlQ9a;
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yo5moT3K4RpqkylqFLjVVxqWs465kOdC70qipcIzXnI=;
	b=LzYIlaudv/sZRkwq+jBhTwvZab0FMYDdPW0xtCFXzYbZmwObEd7OlXVsD+yxmKeKSu7KdS
	SictqLnSMzs2y/W9tAKzhWI9OU9L00Kp8fAR9pq521d+p/2al+Kh+lBBHhHJZXv1PCsqzy
	dUhu7WUpFS7Xha/PyQj1A+i3DJWGdhU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=O9sZlQ9a;
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686818; a=rsa-sha256;
	cv=none;
	b=PD2x9pYP8ocxVI2S2HkZu8k0OzaNlnhE5xu1OuKiNSv+oV+M8Bv47xvRZ3qex2PCjI7JdD
	MZF2f6kWTYN13a8se/vEad0Qji2bRYxcsEvzCsAXJwtq3JWFvi/nGflBNeBr3VyU6M9O2Y
	kxkjsQuVQivME5M/qGW3O3YKiOff8u4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=yo5moT3K4RpqkylqFLjVVxqWs465kOdC70qipcIzXnI=; b=O9sZlQ9azTvfUm7b8bKLLMNJWT
	xk1F/+Lmxx2BqwHsozEVS96HqrduyL17Uaai1UOk4H2V9MmxwAkFJTC0Mz/FI+tGBM3MIDVI0WmGb
	/HW7YvBGL9aJS88lQkGtIsQr8hX8EXeZBFXn9C7KwBs8UW41ze5xW0i0paVYjWJ85QbpY0T+57qal
	vTbp88TEqw1n7rlRAs35e2evM+AXjKgK/7vAfVFO1Q0+EHQi5vUKgLqkub5GSB0KMn8Ih45g6aFh6
	feGxEfD2Gx8wPFDza7tn1xHKfzhSomL+nKnRpSZnsrzxbWErnUXxkEIlUZqMQI7KsRXN5zUfYkLsP
	fCu3P4aw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNBgz-003GV1-1x;
	Wed, 13 May 2026 15:40:13 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 13 May 2026 08:39:36 -0700
Subject: [PATCH v7 5/6] mm/memory-failure: add panic option for
 unrecoverable pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260513-ecc_panic-v7-5-be2e578e61da@debian.org>
References: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
In-Reply-To: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3146; i=leitao@debian.org;
 h=from:subject:message-id; bh=EISKEKQL/arGKTsQc3TDmWSm6ryILYJXr+CWei0yzkc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqBJs7DfvuLYry1wILZQ0ew8fmFkKspjfR7M6EI
 jqtdKJQIZ+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCagSbOwAKCRA1o5Of/Hh3
 beuHEACt6DukNUmgQVKYBNq+OfLW5GsCTVzJZnCXllda8MwjZRrSLfiM2ceU7E5Mon0UvWO9Qmr
 txFKpjc5EZmbrVDHNJ6OATvGhLuL7RnQc2EhYkVoaTKiOINEe7E/6WZJqBOc+S2BWYwa4CCaR1V
 sR47IhcuaHdxi0T2HUmcEmHCEjBzqzWpy0YdaRhlwYAcl2iRVMe+SDhYY9TABAVSmYKwyL002M3
 ZQUYyXo95+N7OYPBX1mlUPaHKX0yQMZSjvKREORFQDHcUaCHu0g+845EQhyerWrvUq3fEBTSd7c
 pfrPHIfI0npXFap+hDPen+onIrFuOAm6KXLCl4Bxn1KB5vQu5FSZdpDl1DW+ZorDfnzH7612FwM
 Ur33PyyT555mrCufgXPts1qLwMCRzkFouy2aDzvgA+TvfOxjQF12a7A59aifLA8nsGVXXWeJKMo
 wjh8l6CF23SvzXSGN99elGaKYNbmF9JfdaeTJaLI9lZGoGs2NTogZ6mSblYNlVv1P8YBOLaGrsq
 7JG8jt3Tcds4DxFtyy4Ns7pWoIdz7oWH2bEtudH5hzC+qBVq4nDqeARq5kZKvhFuSZ7NDTgSLqC
 jUcxkOWE9n/UM6cxToWU+bHm1gDKUTnZ0OXb/YkYo/GaZDhuI8aApkpMMSd5F4gJJCBR0gtUtJS
 X7MNRlTPzEbVhmw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: 3jt87pnuyxzc8sx1t87ds6abjxfmpwj8
X-Rspamd-Queue-Id: 29AA014000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778686817-86160
X-HE-Meta: U2FsdGVkX18AlPtuSxHGR1gFTavDRp7iSHHVl/GUbk6SP3W8TAFFc5S/hAh6u2Cgs/DZ5DdwzFKg/XKMD69UPHqNx2WtAfgA85vfHLM9h9qAbxVlvgEGO4C9NjdolqANLqBp7hTepru+uR0/E1pu2fmfCjktlsITuuUDpVMaQoaexMka9pzwxbonVnE/7YS/QJUaB3R0kj65n+63jDSz6IhcZU6Ra6BcxAL/ljn6p3vz1+M43LVJbE+kr4jS87YjsoQEVOcANFl9FO28Dx4sejoaK/sfniJo69Yi9y9LMoDmmr2bbJccPfR8V1f1K2d5lIco7DrviBhj+T+eprBvglBtW20Hin/mEubNXK1imF5YWe6YsrT2fA9uj2OQH61SazHcodtyUGEoO1JJWj9xJPqFQ4DnMdrdECYMBTUoK1DdUUFewbOHB4w9/JZ5FCVx6BS8eOAfbiUkk8MeLypT0lS8yjp2MV1QvJL6OYbNzzBwM65rZjLjeEGmRnWqqLlpCnI+Y5VghTTA/hk/UaumjAo3PQowSig+TGF8rUgqO4zW8226BBLO87AKce1XdW6wKeegzNG/7rZHudLIh5fEFmQPk7AwkhnkFzn7KFkbNAR/VxKdiaSkSl06sBudnhV102SdOiT52aTs8SdBc68Cws+dO98kKIT+8cyLtWJ3OAXIdA8bP0Rh0rWN1s9j2s7ZprTpegfUBqKoqiZnaqcB8cGLIYP/Du7Rz0PNj1Z+pGE/NLqwDO1kgNgGb8pZoB7JDoYG8EC+11N0glFPukpK2xBKKesHfi0m1JP0dmdGlvQrRPSoic2MbR2HraZKWMCeMy8T/2pqWVXztjkmG4usmlyn/HhEnJIFKtkKwbfn12+0LsS8iqFhtBXR0pxGH41d/EHAERaUK/ZGrHXwxmKsXyX2vwkwc0ZXDI2A7l/2ry1y/DzFn55YMWJzN6KcOKFNHTvIdk15IY4foMcwbsP
 9ZfZvlrj
 tQgz8bfmgejr8ZKG4WJw3X//A1++9lRCCB5jDXN418V7Ay7CZYLiYdOz4oUfC8irGMZ94I1yvzIC9djD7oLE5ytD40ONszwCNaqowg0Gly3oHgtpoKGUHIQK96d1TDLp0Z7owKRRZnOAdgLHGKDLuiKXYf5mcc4SXoN58VNQuNJcJBfEH9Yj6phmJIBAZVZTmKRFGQRO/sVuAKHPaPrUGR0bRFGX9hVqZEnUoa4t29iWXKOZ+RFASz9W9tV/Xr4vhuSGfGah4721rWrC5V1PRS1utonTIUHhTGihD1YaSU6cF0k0FeJbxaylQrysvKpUiUCUk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sysctl panic_on_unrecoverable_memory_failure that triggers a
kernel panic when memory_failure() encounters pages that cannot be
recovered.  This provides a clean crash with useful debug information
rather than allowing silent data corruption or a delayed crash at an
unrelated code path.

Panic eligibility is intentionally narrow: only MF_MSG_KERNEL with
result == MF_IGNORED panics.  After the previous patch, MF_MSG_KERNEL
covers PG_reserved pages and the kernel-owned pages promoted from
get_hwpoison_page() via -ENOTRECOVERABLE (slab, vmalloc, page tables,
kernel stacks, ...).

All other action types are excluded:

- MF_MSG_GET_HWPOISON and MF_MSG_KERNEL_HIGH_ORDER can be reached by
  transient refcount races with the page allocator (an in-flight buddy
  allocation has refcount 0 and is no longer on the buddy free list,
  briefly), and panicking on them would risk killing the box for what
  is actually a recoverable userspace page.

- MF_MSG_UNKNOWN means identify_page_state() could not classify the
  page; that is precisely the wrong basis for a panic decision.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8ba3df21d1270..cb2965c0ec0b4 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly = false;
@@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "panic_on_unrecoverable_memory_failure",
+		.data		= &sysctl_panic_on_unrecoverable_mf,
+		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	}
 };
 
@@ -1267,6 +1278,15 @@ static void update_per_node_mf_stats(unsigned long pfn,
 	++mf_stats->total;
 }
 
+static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
+				      enum mf_result result)
+{
+	if (!sysctl_panic_on_unrecoverable_mf || result != MF_IGNORED)
+		return false;
+
+	return type == MF_MSG_KERNEL;
+}
+
 /*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
@@ -1284,6 +1304,9 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
+	if (panic_on_unrecoverable_mf(type, result))
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 

-- 
2.53.0-Meta


