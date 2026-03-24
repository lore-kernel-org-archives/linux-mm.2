Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BAEEF54AB3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D2B6B0088; Tue, 24 Mar 2026 09:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C326F6B0089; Tue, 24 Mar 2026 09:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4AFA6B008A; Tue, 24 Mar 2026 09:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4F3B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:26:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 476B9BF735
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:26:56 +0000 (UTC)
X-FDA: 84581032032.19.1DA4897
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57ED440017
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:26:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qz9/LE2J";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774358814; a=rsa-sha256;
	cv=none;
	b=ohowfF4he5NItZZ0qEXV/4yLbt0WxgO/rdEgxzQBDmINmPBOWCnHjFwlUOLquvwlbXSFSk
	zl4W0Wb1Qfnu4/g2uXEMYZjQ2kId4XA8j5xP7Ldc99TiHHDjm/Fw/vXoHjpZ8YDit0YRFd
	5ECyPKkK9ZybSe3RQmMuW9P2ytjd5eM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qz9/LE2J";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774358814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGW3oZnlWDMssFiT2FJNVXXub1CzFVucAsTwaXwtzc8=;
	b=NHqCX2rWOIV2iAzurkgtn7gRQlZFUOnGF86LuNBTfBt/SHXikJygeconRuLNvhncTZ/LlO
	Q8lrGDYo3W2hf8bpsv7b4Gj/oJXbs0zGBBeaBbo0LcEliBcWAjoQ+DH2Y5iWpriNIyRVZk
	ezHHifxX4jayuFiqd9L6vYk49Sakvn4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76496153B;
	Tue, 24 Mar 2026 06:26:47 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2EE9B3FAF5;
	Tue, 24 Mar 2026 06:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774358813; bh=6NeQ5I/ff6UfPXauvKRLpzI5NjSjxiyGIQia/li5NEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qz9/LE2JSIbVqazwJDD5xbnrNC8yrlPETODw0hoy5dMfyizDqY+VzFRYSDYSH/CKK
	 /c9GnUSEMsxDYg+JwKJvfdE3F6zZf3HzVb5xugM3CNuCzTEyDWJOiPTXlZP3CT4dzm
	 Fj5EDqeQR83LSB8bdK9Sen3d8QclJAhA7SuLh9v8=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 1/3] vmalloc: add __GFP_SKIP_KASAN support
Date: Tue, 24 Mar 2026 13:26:27 +0000
Message-ID: <20260324132631.482520-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324132631.482520-1-usama.anjum@arm.com>
References: <20260324132631.482520-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jhxdq6585npgktgqz3dm33aonqikrw3g
X-Rspamd-Queue-Id: 57ED440017
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774358814-606287
X-HE-Meta: U2FsdGVkX1/SNzVWFh/WgzgLV4K+8BWL/QPNiwuM1FlQ15PxZuYmXf9LyBa5DcluuvSSzuAghjHW/RV3HotGDRq7qRLs+yoN7D57Ye+Mp8NJjV5mC4skV+EaNb9sNblFn/t6+YNfMldoJsLZozkdgCop2iIc2vkHrpcW3NNbwMo51UGvBjXXqg1WslHMXL1kFZyEPwutnofI0rYOFEAIznP8Z5mW6sBn4a+VXrMXLDzhBKzxOtjdtlXnj0FoCMpeYjqt4dxikD+84VNgKQtntJKfUAEsMyUc0SaGZgGxVy49FZQ/1aDkwqRaRS5JWaYY9jLEpib7aAyR1SRrEqc4kp8r34tUKo28LM2Ki+wTqscXR+SpI9COYmLaUcpa9qe0tqH3vUaVMefhbbgSq13gQ6oS/+2WLyPf37BfkCDqPRoUbnvVHffcepGs7Y7XYQluyRnp2LxOhjfS7icVt9miP2RsFpo5fdd424Q6s4D1NHDd/+3w4Navz8L6/XakE+xgHb0SQZwVSceZPVLz3CwtVXyJ3V7lML/pyrCx6PyIMBhbYRw5OS/mP+aphZQ2NBrUS/bgLcOD/1mq3whMgjIZQETVLb/qyTQV8usdZZTNtNpxGypemmqmQuJf5i1Ozs2ILkjZDkTOBONeKj62VRpabTEYBHR+f4IYkpU3CyfHwkSR90zQk3aWIL2VLsbiRL69xHmtsb1ahMhONRwo93NASBfUEWsYKuWvuQS6bMIL1BT6vHu7V9F2JyGz6ftZTrNsOS21BkPp8JE7GyrLdSJoPZOFaV0Rnr5+RedCK3uSNtc3F1dN893QT9iXrkwRl3FFte/EF7GDL55DO4JLqAALihFrRGxjPcUScOzjDpcB2XrcoV2AqwEr998xFuw5CJAO5mGNO12d9lRkgdWvfJ/uXjF/3Ir4p2/+0WOsj+CuxRSwH9vXPl3EyTFteUZ9HzMAqU1TJwoJokYJP2mQvYU
 x6XziBgF
 fREGfq7jOvJtxw3HdySpR3kv66G7O58EZTWVqun967teM6vtWhZaR/m7pdH0z9G47wYdiNLPlLlEMB66ffJnsvjRdVf3grPlis+1fFVk7KqHwovelkX1xYxOvE5flL23hxEcGPhcj3QTaf5Qi/T5S5p51IZN01YPGtejtWx6M6CRovd+sOy6iQlDqYpNeCOpaQvjEqJs0QAICcaR1VB75+9gu22BciRD/z1o6BVRogIPupAO9hFvcjO30mNiVAHKu4LxwBrug0dNq73Q5lCMMLmB9szugHtHdlG3dnDMdQKuEd387pn4E4hFkFJHoXyPHrx920bd0KwcY4t0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For allocations that will be accessed only with match-all pointers
(e.g., kernel stacks), setting tags is wasted work. If the caller
already set __GFP_SKIP_KASAN, don’t skip zeroing the pages and
don’t set KASAN_VMALLOC_PROT_NORMAL so kasan_unpoison_vmalloc()
returns early without tagging.

Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
APIs. So it wasn't being checked. Now its being checked and acted
upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
defined there.

This is a preparatory patch for optimizing kernel stack allocations.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Simplify skip conditions based on the fact that __GFP_SKIP_KASAN
  is zero in non-hw-tags mode.
- Add __GFP_SKIP_KASAN to GFP_VMALLOC_SUPPORTED list of flags
---
 mm/vmalloc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c607307c657a6..69ae205effb46 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				__GFP_NOFAIL | __GFP_ZERO |\
 				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
-				GFP_USER | __GFP_NOLOCKDEP)
+				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
 
 static gfp_t vmalloc_fix_flags(gfp_t flags)
 {
@@ -3980,6 +3980,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
  *
  * %__GFP_NOWARN can be used to suppress failure messages.
  *
+ * %__GFP_SKIP_KASAN can be used to skip poisoning
+ *
  * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
@@ -4041,7 +4043,9 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	 * kasan_unpoison_vmalloc().
 	 */
 	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
-		if (kasan_hw_tags_enabled()) {
+		bool skip_kasan = gfp_mask & __GFP_SKIP_KASAN;
+
+		if (kasan_hw_tags_enabled() && !skip_kasan) {
 			/*
 			 * Modify protection bits to allow tagging.
 			 * This must be done before mapping.
@@ -4057,7 +4061,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		}
 
 		/* Take note that the mapping is PAGE_KERNEL. */
-		kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
+		if (!skip_kasan)
+			kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
 	}
 
 	/* Allocate physical pages and map them into vmalloc space. */
-- 
2.47.3


