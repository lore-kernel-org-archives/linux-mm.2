Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A77D59D6F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 16:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D7F6B0007; Fri, 12 Dec 2025 11:18:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7A846B0008; Fri, 12 Dec 2025 11:18:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2F16B000A; Fri, 12 Dec 2025 11:18:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2AF36B0007
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 11:18:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37F9412DA5
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 16:18:48 +0000 (UTC)
X-FDA: 84211327536.11.3DC03B7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 78B138000A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 16:18:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765556326; a=rsa-sha256;
	cv=none;
	b=1Xw8A432QI5U9sMJyul9DrWmq686RSKyhmySbkq3gSNFrE/PnAAr4xnYFIh3dulokyUByo
	Rvyl5u8tdZuMvx1oKbcOcM8JyQ4xiSN5fL9QTnsjdTZyFcJokm3VKpVvN+gB6iW/KGvjs6
	G4IJ/Q8HBgFo9IjTH9fJo6IWxa3Uus4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765556326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WB/C4viEJRinoW44cZi9L9bpWk3eba8RVvj/5TeO/g=;
	b=bGbB18472uXJcgBaAlzi8VrGoNYhYAsKs+OIptXtux/LlHZICDxKUsUVPu7Eqh+UCZeVvS
	FXBpiP+MH4VfpETMHdh1VjPOFiSs/ZZqpaWk4qSDAO9/xTFodSJUn5WNiZW1e+zjQuMXFV
	Zt0v4iIiblRDPg94bWRG604q97r6QIc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EFB11575;
	Fri, 12 Dec 2025 08:18:38 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 585873F762;
	Fri, 12 Dec 2025 08:18:40 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	kevin.brodsky@arm.com,
	dev.jain@arm.com,
	yang@os.amperecomputing.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH 1/2] mm: introduce pagetable_alloc_nolock()
Date: Fri, 12 Dec 2025 16:18:31 +0000
Message-Id: <20251212161832.2067134-2-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251212161832.2067134-1-yeoreum.yun@arm.com>
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 78B138000A
X-Stat-Signature: xqdpj8e47igjwe7htbhsinwha3pnzy4y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765556326-907189
X-HE-Meta: U2FsdGVkX19OmlC20VXj8TW84hyjwOQAsbo8nYaB5t9yplM2/bg9o0vOZ3J/V8zf/Gcegscz0rPvgFGtcteCKjDoXCy3wHXgM6oktSaHjeT/9IY6vdSdn4OANd5x3WW4yjM1xjlLqTI2LgVndpOgKIt+JCpMjTGPB3ogqo7IoWfzgdKbJYGYkDH9UxF+nptqEwUI2885sGWWoX87AqibZld411F0+2BVCF7PAOX2hlRvIyGBAMlYJRAkfiUZmp30sKaGpd18GIg7UkSqc0z3vbOO+OjZPqUj57xBRaDAYQfXYfGRXmBmqVNPcmJp9SrpIClsUwQ2i9jXqvwQ1zCKSJ25bH9qaNeA+TNMnTmDeieOyhx6zO2IbbDQpRhcnFeIA7YWZGy3iizc4ZJuTOO53+79m9dG/+PIZtCj0zsGTC/PwGMxK8H+SN2Qx5SOSnfvmMQNtvBTbDD++6M2uotPgqS2mBS4hOswkz8mU13ZIOGyIUPjl3CFAyCXiL/dVkkMuV8q0o6yRudi3JvKEqpZtpICVBseofANtsaNWpeL7ZwODiuN3rWAbBKH6eH19paHSGZO8tE4LRsv7TGpE9H6932FCcAKr5hsOCNBbChuiMVzr7laIzAdlm6gktOqoS6/bujAVVnKfz6/ndnQiJKvW9TNJi1ErL37bP+sHqd3WmYYziXi9o0XXwA7t/ha9S725c4jBV9hhP/ybozJ+g4DyyYp2UwyO9wjjQWtwgyP0LWEp904vrxdUsoPwQdPVZNgew940q+W5h0RsS2eRgiTDSFKXYRQzftObE7ky9H4VFkHD5ynWDNX/QDUmLXgYb6zLN1xnKNuYmOSfYYYvN+khmk5W2/Kdwbyk5qOHhmJFKGOMf2RMS7PKZBZxLid7czxC9UVJe39+4X4/rw3SwWCozj6kbtZOp4DdQarYPwxOoGs62jvKPuo4dRoUIQzlpgSKVgHnGAaFAW2svxDmQa
 s9BJAr9l
 /nMmnh7Losqeyn50+u7SX+13aiqSZya28B+ubdbq6Iqs7syLqDLiBRzHymEqc/kA+46FSYSUVdPVQmbYxDid5EIahzltzcQktMorI3AvhWpTeot/DhJs+ViQ8Jun5TVK9SFDhUMIqeXR0asYdbfMmFAGK/W1xf4gHZa65yDTbjlyF9sjGtvqRxQxIdoaqHtp5rrPiS0v9oC9lyKeU9xP7kX5fwQo7Zzb28ttdQpawlHOaLjfFQitUzNRBDmu6DwUQIINFzwEGPA+0JXG9I2YwY3/LyTpwEZcYISPIuTueUCfpbxFlBHTgxIXkuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some architectures invoke pagetable_alloc() with preemption disabled
(e.g., arm64’s linear_map_split_to_ptes()).

Under PREEMPT_RT, calling pagetable_alloc() with
preemption disabled is not allowed, because it may acquire
a spin lock that becomes sleepable on RT, potentially
causing a sleep during page allocation.

To address this, introduce a pagetable_alloc_nolock() API and
permit two additional GFP flags for alloc_pages_nolock() — __GFP_HIGH and __GFP_ZERO.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/linux/mm.h   | 18 ++++++++++++++++++
 kernel/bpf/stream.c  |  2 +-
 kernel/bpf/syscall.c |  2 +-
 mm/page_alloc.c      | 10 +++-------
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..11a27f60838b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2990,6 +2990,24 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
 }
 #define pagetable_alloc(...)	alloc_hooks(pagetable_alloc_noprof(__VA_ARGS__))
 
+/**
+ * pagetable_alloc_nolock - opportunistic reetentrant pagetables allocation
+ *                          from any context
+ * @gfp:    GFP flags. Only __GFP_ZERO, __GFP_HIGH, __GFP_ACCOUNT allowed.
+ * @order:  desired pagetable order
+ *
+ * opportunistic reetentrant version of pagetable_alloc().
+ *
+ * Return: The ptdesc describing the allocated page tables.
+ */
+static inline struct ptdesc *pagetable_alloc_nolock_noprof(gfp_t gfp, unsigned int order)
+{
+	struct page *page = alloc_pages_nolock_noprof(gfp, NUMA_NO_NODE, order);
+
+	return page_ptdesc(page);
+}
+#define pagetable_alloc_nolock(...)	alloc_hooks(pagetable_alloc_nolock_noprof(__VA_ARGS__))
+
 /**
  * pagetable_free - Free pagetables
  * @pt:	The page table descriptor
diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index ff16c631951b..3c80c8007d91 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -83,7 +83,7 @@ static struct bpf_stream_page *bpf_stream_page_replace(void)
 	struct bpf_stream_page *stream_page, *old_stream_page;
 	struct page *page;
 
-	page = alloc_pages_nolock(/* Don't account */ 0, NUMA_NO_NODE, 0);
+	page = alloc_pages_nolock(/* Don't account */ __GFP_ZERO, NUMA_NO_NODE, 0);
 	if (!page)
 		return NULL;
 	stream_page = page_address(page);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8a129746bd6c..cbc0f8d0c18b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -598,7 +598,7 @@ static bool can_alloc_pages(void)
 static struct page *__bpf_alloc_page(int nid)
 {
 	if (!can_alloc_pages())
-		return alloc_pages_nolock(__GFP_ACCOUNT, nid, 0);
+		return alloc_pages_nolock(__GFP_ZERO | __GFP_ACCOUNT, nid, 0);
 
 	return alloc_pages_node(nid,
 				GFP_KERNEL | __GFP_ZERO | __GFP_ACCOUNT
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ed82ee55e66a..88a920dc1e9a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7542,21 +7542,17 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 * various contexts. We cannot use printk_deferred_enter() to mitigate,
 	 * since the running context is unknown.
 	 *
-	 * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
-	 * is safe in any context. Also zeroing the page is mandatory for
-	 * BPF use cases.
-	 *
 	 * Though __GFP_NOMEMALLOC is not checked in the code path below,
 	 * specify it here to highlight that alloc_pages_nolock()
 	 * doesn't want to deplete reserves.
 	 */
-	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
+	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
 	unsigned int alloc_flags = ALLOC_TRYLOCK;
 	struct alloc_context ac = { };
 	struct page *page;
 
-	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
+	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_HIGH | __GFP_ZERO | __GFP_ACCOUNT));
 	/*
 	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
 	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
@@ -7602,7 +7598,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 }
 /**
  * alloc_pages_nolock - opportunistic reentrant allocation from any context
- * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
+ * @gfp_flags: GFP flags. Only __GFP_ZERO, __GFP_HIGH, __GFP_ACCOUNT allowed.
  * @nid: node to allocate from
  * @order: allocation order size
  *
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


