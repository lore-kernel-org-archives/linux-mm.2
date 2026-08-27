Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1E4DC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECB1E6B00A0; Thu, 27 Aug 2026 19:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55416B00A1; Thu, 27 Aug 2026 19:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91BB6B00A2; Thu, 27 Aug 2026 19:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE006B00A0
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A02912021E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:39 +0000 (UTC)
X-FDA: 85148648718.16.42B36C8
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7339220005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aHGYT+9c;
	spf=pass (imf03.hostedemail.com: domain of 318iQaggKCAg01m3mv0lowwotm.kwutqv25-uus3iks.wzo@flex--stevensd.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=318iQaggKCAg01m3mv0lowwotm.kwutqv25-uus3iks.wzo@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THehtAVXPzXeOISNI+hN8Wh32bn5y3s9ZVH/HPQs5Ig=;
	b=mc+aq5IRqP2jIQ6KOyYudklqmhYSm6wji7L4FqUpbjlF8sNMeiec3oTuzz+UzhLA5M603/
	evAU+owectUbafkEekcq1QKG74K9r/qIOJLz2mUEePT60kxvTVK6QRq0sJCB/AhgF/mGt9
	Yz8k6inNTeULrFiYLkJwPGcyk8ttuXE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aHGYT+9c;
	spf=pass (imf03.hostedemail.com: domain of 318iQaggKCAg01m3mv0lowwotm.kwutqv25-uus3iks.wzo@flex--stevensd.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=318iQaggKCAg01m3mv0lowwotm.kwutqv25-uus3iks.wzo@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873497;
	b=qb6ZQEg3mfZMaZclHC8tCtPTK3NjM0KrZ1NsouslA+fgPcKO9wLjxzN+XJktvrhOgtNehl
	0KBdEysmLRkyfHApz+9GNZ+jf/Cx0ZquBMObCxBDwQUpUD1xutXh/giA3tBP+wKCZSFy0y
	Cx8qMtMCZnDiGFGnpnoYIq3BHDqObPw=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso806942a91.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787873496; x=1788478296; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=THehtAVXPzXeOISNI+hN8Wh32bn5y3s9ZVH/HPQs5Ig=;
        b=aHGYT+9cjrXaD0YnkhCm+kpCvuaEjCcmh5iNgXH10NUqljX47YU2USK157VWz1EDzr
         niW4zQmiWxZ+sU0+Kn6k0ETBI7a0jOaiqk11AFvkJro8OaY1N7xNx0lYeGCZ3qz6HiIF
         A2gewib4BtNs0/yT2x2An5yBJJLQkxQ7VUcuYCZmneH6bfalNGDEnNL6rKM2TwCBut2+
         zWn3H6HTRrAEndIlT0uojxR/JRc/WoJPMu5WoaHD6IaaezxH+Q8crBH1yqfwRI7WMJ7P
         WE6164pIhy7OQSQ16Df3sQf72C+dWWZu+k7WB4BNvATWgghiRvTxprwtcC/emHTO8x3V
         xGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873496; x=1788478296;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=THehtAVXPzXeOISNI+hN8Wh32bn5y3s9ZVH/HPQs5Ig=;
        b=qCM9/fJSp3wKT4lr8ZRSujc39XyZ8Q34JYQfVcUVJZhWC/R02DqkAhYJh/j3VpgDDb
         k3620hx2J1wbqoZAJFwO8+qgb0gCAK/xdvMcAm0JOVZShpdfd0X5UjcB9OEso2oIY6x6
         /WRFgP57N3TeEu0ytWznm7h0W5oomeEFhoHyJayggQ0AaKFboJ4diLU7bO+OpmTboXz2
         IWGiYMtl5OGA3ueseBki9ABZSO2Aed+f7NM+BWTNDLtTy3odeuRZH3gSPNKzEpaZA68u
         Yi0f9fy9gwFafhjk1rq3jHbPxNKEA6o7sLPo/b7DZg356od3/sw0trEspeP+r6qxcxoa
         TysA==
X-Forwarded-Encrypted: i=1; AHgh+Rp7j5KEwo6COrpF+YAM1mHZJco5zP6HLMfHaQ3oVGi2jNDsARMBA+gPbNRZL8JZaEryibV9sWr71g==@kvack.org
X-Gm-Message-State: AFuF++kK3KLRQQjsaFH+ZCh60/s37P8p+weDZIv/pLiRl1VmhMbrpAZr
	3Wj3OHY1vPuPJDX79HivbwKzV9n7i00pAW7Lm/pI4X8yk4fajMsJVOriec8fqOai1tSz8xq7O3C
	0OGQcB6tXT4hhFQ==
X-Received: from dlbsj13.prod.google.com ([2002:a05:7022:f90d:b0:139:d9c7:3cf4])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2c88:b0:396:b98b:a3c2 with SMTP id 98e67ed59e1d1-396d0f52a0amr5303479a91.8.1787873495813;
 Thu, 27 Aug 2026 16:31:35 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:29:48 -0700
In-Reply-To: <20260827232948.2520558-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260827232948.2520558-11-stevensd@google.com>
Subject: [RFC 10/10] arm64: Enable reclaimable stacks
From: David Stevens <stevensd@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gqabx61eafwii466qhokezpbrynst49t
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7339220005
X-Rspam-User: 
X-HE-Tag: 1787873497-420069
X-HE-Meta: U2FsdGVkX1946UDUCv50RXJx/iAqxYQ2doIbytSBhIoHtAc1w+QCtqltq00duErNi+lEa41WcmQHJ35D8iV/G9MVdJ+kw/MxJNEgfXwDMAf3FPkR2+2uBIHtiWbk19BN6n35qPXbJezx5uETii3YSqCyED8eBAFJ6LHM56y5xTdUCMEe8fx/jtmDS02aqvSO4rdQ+SzEyVjC5Vm1HYvwGPObJmiG5yLPczuz4Pah4tXguPXRp5rZ8WwHLliyRpvPhsLcP/s7SdTSmXUXNFpQDROb3N1O1OaMcEJEc8UTHgmg98lYUghS4W+w+pXoDj+rKfHn9gTFT2tsMhDxLbe2NqYvlsgUdk8gOSaQ+S1cTHvRmQxLA0dcpk77NQO16Le9JVQGKV9cKNf5TcIrJsEOQ/8aJMeuytIJoWAs8mgoNy2AoqN5vssC5u1NmD/470/1j+1aLnjJrWsIEhlWm7qmAqwuuUhcpHXZHdZttJDdS7lALLulTaSNnynP0Vb85N5x7LMCbnhq/TtF5vBrc3pBL76FyXIZmrhr+o9Wvo/GxhT5mL8mAuh1PCnykJofthD0ve539CSCzFVYWNi1xABHVum5FP1hR9c5SgZbwFMtT6+19Uym656y6S/2JAOn8b8+77Ovpax4zTon+SOKVvVy8o1qYa92kWu+vvqJwdOJvOeV+nycaKocMKqpaJogzrTUuw/jOEZrrx+eDn9VMFadURiHG63VF6XN9m1eIuA7hhz5zTDsN5jD2kv3hvDTSG0FiQEK+sSBudra8aWgxxJr9Lkc0HBrMcysiaq1E/HXBaF2FqXFMGhYkGHBCbz7FAPFBVQ3qHQeJ/7KEoMZ/WtnIO7CxfxHtei4ZR7A3BYitsVNB62ynHYj3hBP7+vbwB7XeFgzCBxxrfGc8FpWcnLQSmRJLpgDLTlGaWLRA41qUrseA7TPZEcBP7qUCvAyaffOWXh789Can4xqt5Qa6A4
 NIhwZtui
 uNF0kLgWScNcSy6ilp9yoP03ziofukp0jDlKnw5UwVYeNyTT8iGT5HqaYMAx3zd6Z2NSS63Y8+9sNFAK1EPduo3XHVWjqKNYA/Pd1d48uuu4jKJ9KBEe/keASouujuDbP/uRz2w45BYmK8lSGW9sJOOYntBKmxTIsPYhZ38EddRSvK1WIK/Qccd7mwBkPjUU8LZWHolnY9EqzqtZCdOh4PpzQ2u1joYUVWV5YHIurELyNSa2p5yfvEGOs0Z2q+At9kPGah/qNMsSaA9yrYF8CmqtP8ZsYF/IWM3cusxgalWmqvGtlN6KAYxluL9ql/WmzvlLrkzE0WXkU2PBY2LbOglWT6YZkAnK4vQmvB21oRDRMx+EjtWfGEjfjqt3eH+BUBD2lp3UqRfhTK+dV5fjV6QiZsYpiF4PMzPgVuW9Pnouav8KhB9JBu2Lpl3/CBVFdXKd2Crt4D6qdIujoh8Jenctr9mguQa523SL2GhaReeBcT6qUIZPGeRJW3PeacsmQgkP+56B1CcLbnvP+7AZDZE2Pj90FMqJY8RB3ZA4UqyuZALB7k4LX5M3VrtPseaaCiOHCIkbsQ8d1rGnNkTfuKbRsOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement top_of_blocked_task_stack() to get the stack pointer out of
a thread_struct and enable HAVE_ARCH_RECLAIMABLE_STACK.

Signed-off-by: David Stevens <stevensd@google.com>
---
 arch/arm64/Kconfig                 | 1 +
 arch/arm64/include/asm/processor.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919..262a4fddce19 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -173,6 +173,7 @@ config ARM64
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_VMAP_STACK
+	select HAVE_ARCH_RECLAIMABLE_STACK
 	select HAVE_ARM_SMCCC
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_EBPF_JIT
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index c2a627f39314..f5a550835c94 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -204,6 +204,11 @@ struct thread_struct {
 #endif
 };
 
+static inline unsigned long top_of_blocked_task_stack(struct thread_struct *thread)
+{
+	return thread->cpu_context.sp;
+}
+
 static inline unsigned int thread_get_vl(struct thread_struct *thread,
 					 enum vec_type type)
 {
-- 
2.55.0.897.gb25b4bd76c-goog


