Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02131FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 457316B009B; Fri, 24 Apr 2026 15:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DFD6B009D; Fri, 24 Apr 2026 15:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CEE16B009E; Fri, 24 Apr 2026 15:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1825C6B009B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:16:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE5BA12028D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:58 +0000 (UTC)
X-FDA: 84694406916.11.4C2A9ED
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id 123741C0010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PTqHSIVb;
	spf=pass (imf20.hostedemail.com: domain of 3p8HraQgKCDAefQhQZePSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--stevensd.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3p8HraQgKCDAefQhQZePSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLdDN0AHHw4MrI7CUBGciac9s6fN21aSVhtjr+LOvQ0=;
	b=ntRvcWP+s8J3A38gbE5ORNyNjInrCiIsQqfGcSci6qHSdN5VwUfdeNAJqGzeIrHidxk6fl
	2IvvecXhr8EDLdFH+cT7fweXSQ+iFi9oWzat12Ig8+R0TCijul4AF8P+QzMZIhPxiiGty+
	dCQys4Lc8txgFWnv0Ed/KaWs/XtNZXE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PTqHSIVb;
	spf=pass (imf20.hostedemail.com: domain of 3p8HraQgKCDAefQhQZePSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--stevensd.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3p8HraQgKCDAefQhQZePSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058217; a=rsa-sha256;
	cv=none;
	b=SxQ+mV+JpoW9lugVl4dsROnU562TY4ZMQwEVXEtmYJLBfcEa+e6utRAh+HsaUTYQkPpX8k
	vW04X3BU+KlCm7ZQkR7ajSMRuQ6NDFLaNQM0FzUDOX3RGWjs+KNPOeG4B/POiZ/QSvOCw0
	8eEPZ2C5SAL2M+U/BFK07pTaCkFn37s=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2bdf75bc88fso10618689eec.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058216; x=1777663016; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MLdDN0AHHw4MrI7CUBGciac9s6fN21aSVhtjr+LOvQ0=;
        b=PTqHSIVbvQLoN2KeP+vVO4U2HLAdeM3H7IdnwuEGuO9tiRsRUSjkCc33ZDHoA7aCa5
         0HiX3zHpPKYs4hElmF46/jyN1Py88sQlHnc4Pa4N7n1Hmecw3YKbGIJZNQTbA24u0glT
         porVq3mYyGch9I5q/bezUpHMhInNbN6EKZskLCtn1bZzKtUgPa+F3RV5FjhkGirKu5kH
         aaqWbnTKBkWg8mBtOdo10O7PO4k/zAKLBXjzryOhhMRM11Gxcy2UyrtlJXfm374kvDMi
         JtVs3fjctgD3ZZCgrFMnCocOieAbnuPC+nScWXTafetivdfAN8qdbX4NkmzspZ7+TJ8L
         2RMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058216; x=1777663016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MLdDN0AHHw4MrI7CUBGciac9s6fN21aSVhtjr+LOvQ0=;
        b=pw/xhD1++Xew1OOeM9oialN+wHJmnNfWz6Ms2MNE8jQt5Zyw5yes9UsSeWv39t8Lq+
         EMTXHjfUbCZQ73y4DACAxnZXea9jGtjzvMuoTurq2uunfODczQ8p18u1obihBHOU/fCn
         /rdlAM6zo0st/P5IKVPdjHOM4KYqdkcW71AWOdaaq8QJBeIRvHEx8gO+N+qJoK3pJS+J
         dfH3g584lsok3WCMD/srfA7HUQwdp9ngwCPzfQC/GuHEbsB0tO2aWS7j1ASUKoJU8OaI
         KegjAc4MjhSeiRruPSEsmLfVN2+2OaYo6Uf2ESZmnaD3cjLkGc31YKaWxXjr9A6fQ+Gr
         gNKQ==
X-Forwarded-Encrypted: i=1; AFNElJ8gGrcnrJhXAJ1IzIJf3MsPlkXwOrYBn4cWzObD4Vj3T2rjw47I7ky71X0J/a6pxFK+tVs1A7Zy7A==@kvack.org
X-Gm-Message-State: AOJu0Yx+2zGzj1Fkrh9rRcXimClitFC5b8SKboGmwbLY54Kz/DD5Oext
	uaLlVE6JGmcQUVkM6rD08NDFYV/HQBli5+bKFRZzCgnw9EJIRVJLmThVUYx6GSrJAGfe7K377Op
	uHvn8VPGhYFEoTw==
X-Received: from dycoz1.prod.google.com ([2002:a05:7301:fc81:b0:2d9:1564:c80c])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:7495:b0:2df:71f0:e5b3 with SMTP id 5a478bee46e88-2e478c1ef91mr17887668eec.20.1777058215502;
 Fri, 24 Apr 2026 12:16:55 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:47 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-5-stevensd@google.com>
Subject: [PATCH v2 04/13] fork: separate vmap stack allocation and free calls
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: d1h71i6xsd4s8n4r973m31kdaq5qea7p
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 123741C0010
X-Rspam-User: 
X-HE-Tag: 1777058216-145776
X-HE-Meta: U2FsdGVkX19uQmBzlFhjtfF0mVAl3hzBvv0rkurubIpHzCP5FQSkmkcbEF076XwJN/G3JH1/qpahkesRi2HYfVqM2B3Br3wdIregXj6uOXibcZiIwUVG7F9EyA62DTaEh/T2kG9vWZcxTqHugUdv/fKbTnYp1n0no3sIfdKAEakIJlpxvLD9kR8tnfzDLOcu/lQZ/gqQzWC1Q0jdYf/RSl6qbmRbuP/boEcq+2MH56d+44pm1QhXWm1bq9j3YNWxXrd/Hfd6FMxX8Ngk+p3HnyCUHq9tItZkhY86qPIj8uymc/jJl56kdqv0kFiYk/Ls6Cjb8qhVWyFl3Qo3cGyaDJEB+geJB1gfZTCJrhw4lheKdssIiKQ04jUBIyg3z7J9EqgZG2BmBk2Rock+rizSEnh7GFeAF1FsqZcxak9b1G84vhvo7T6gdUaI3Kaz6GCgK9bDrtsACf5eAYnQqmawiIzHTUqSAYAojsa4/vKMn3HSwXiW9jTS4P1bF+3Ielps23noGf2rlUKM0pwCgy2n95A4PJ2oD2s2FujNOKNCDtp+jC7+aEKySqAcPn7/zrYzwxSZOSAnXeDwwjqieErvS58wD4iGeSZQNfGQKyhHTt4OLpJjyRRi1IfwO/wRF7Wc8g+/u5dfZFgGPj1nsWYr7ss5JU6ZLJxk3fmMOd3X/JbFVxiOimQgsOMCqiKtOXKg0zj+ct1NpXZNLGAo+fg0AcZTOzJuL4QM7o2OWyGRnCQLoR11lrnk8n6qKQ9w46eon5mX0WhCBRTKAzH38cYZCjHpH4mFw6N2yeAdHzNyxyoc7qcxS2g9+Cahl0iRO3TFQ9eWKXIKd0RI11oJSCNW18fBTUHciDWxkoRNvWcs8ynanYmg5YKQmtLsGlMkXPEDxhsNvt12XeO6AkuHPldjpaADx2U3vYSa7zDmf2ZNZ7v/GxE2UFK6UX1UVMEV0Rc2Bzvq7Rm7yPBiWHqYg2X
 TEnkFAET
 XC8KVZtQBzuv1PdKLo1Q0DnO9caQnlegrE3e9MjeVQ32/7IMcnAiN4pQQZ8P/6xWKEKXnb61ljFtcw/pftllhdBNtuovZBd+f8QWGGpDgXI8E6fBSaI9jZib0YvFzx808YhzTEdc4J25ZC2pM8nySSRb3naSoFP8Vuqd0t+vkxdBBVXtKr3rf6cUDH2KKZCHMuqw1ca4HY2LymcTZaaaXv5B9nbAhzBP9/5AAQpY+05wW/t35erTasCQppaCMPINOC0GZ8f7sFMIHF8aSXZC/KYAagADh5hHW96KwEB24oW0LOFfHGyp2qcaY9LS8oQZnwMXpMam1q3MbcH10fQexYrjG7NxLiOq6SbcurV77nVB8YTvp3i6bip9NeMX+zF+HvLCeiR/Yi6HcwkD5A6GmcmSqKeNIkZ87mCdQe27AeEOInmorqnGjKexA553WoSxZ0TlAm4tcKaCNSIvFt1kPM277tjcfMqbx0oanidGWDQaQvoz4dl1Nq3fd1HIVrw62x1Q+Q47M5/bfETYFNx8yXV4AQPicXuMWFcLqjn+5x+GtV4u2lYOK8KMGne0aWNJBI35llW9fxUytHjQ0Igvt8WvvqDwL6JcpYHtU8U68rK+cbSj++V+Aq841AsukPktKAdbu84M11bo1gPPM4ej2zZLQRw30KdfeXJyEbE7qjavqjT0JSwzxKTkjqqztGBROOguLRiGJ3cDBp2qz3u4tR/vzThMVnkEp90uw1HEzo367YYyjpHmwy1rrvmqYp9Xcattf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

In preparation for the dynamic stacks, separate out the
__vmalloc_node_range and vfree calls from the vmap based stack
allocations. The dynamic stacks will use their own variants of these
functions.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[Fix a bug in original patch: free_vmap_stack(vm_area->addr)]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[Add missing free_vmap_stack conversion, fix typos, rebase]
Signed-off-by: David Stevens <stevensd@google.com>
---
 kernel/fork.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 72c081db492c..8bf32815f422 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -269,6 +269,21 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 	return false;
 }
 
+static inline struct vm_struct *alloc_vmap_stack(int node)
+{
+	void *stack;
+
+	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN, GFP_VMAP_STACK,
+			       node, __builtin_return_address(0));
+
+	return stack ? find_vm_area(stack) : NULL;
+}
+
+static inline void free_vmap_stack(struct vm_struct *vm_area)
+{
+	vfree(vm_area->addr);
+}
+
 static void thread_stack_free_rcu(struct rcu_head *rh)
 {
 	struct vm_stack *vm_stack = container_of(rh, struct vm_stack, rcu);
@@ -277,7 +292,7 @@ static void thread_stack_free_rcu(struct rcu_head *rh)
 	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
 		return;
 
-	vfree(vm_area->addr);
+	free_vmap_stack(vm_area);
 }
 
 static void thread_stack_delayed_free(struct task_struct *tsk)
@@ -304,7 +319,7 @@ static int free_vm_stack_cache(unsigned int cpu)
 		if (!vm_area)
 			continue;
 
-		vfree(vm_area->addr);
+		free_vmap_stack(vm_area);
 		cached_vm_stack_areas[i] = NULL;
 	}
 
@@ -333,41 +348,35 @@ static int memcg_charge_kernel_stack(struct vm_struct *vm_area)
 static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
 	struct vm_struct *vm_area;
-	void *stack;
 
 	vm_area = alloc_thread_stack_node_from_cache(tsk, node);
 	if (vm_area) {
 		unsigned long memset_offset = 0;
 
 		if (memcg_charge_kernel_stack(vm_area)) {
-			vfree(vm_area->addr);
+			free_vmap_stack(vm_area);
 			return -ENOMEM;
 		}
 
 		/* Reset stack metadata. */
 		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
-
-		stack = kasan_reset_tag(vm_area->addr);
+		tsk->stack = kasan_reset_tag(vm_area->addr);
 
 		/* Clear stale pointers from reused stack. */
 		if (!IS_ENABLED(CONFIG_STACK_GROWSUP))
 			memset_offset = THREAD_SIZE - vm_area->nr_pages * PAGE_SIZE;
-		memset(stack + memset_offset, 0, vm_area->nr_pages * PAGE_SIZE);
+		memset(tsk->stack + memset_offset, 0, vm_area->nr_pages * PAGE_SIZE);
 
 		tsk->stack_vm_area = vm_area;
-		tsk->stack = stack;
 		return 0;
 	}
 
-	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN,
-				     GFP_VMAP_STACK,
-				     node, __builtin_return_address(0));
-	if (!stack)
+	vm_area = alloc_vmap_stack(node);
+	if (!vm_area)
 		return -ENOMEM;
 
-	vm_area = find_vm_area(stack);
 	if (memcg_charge_kernel_stack(vm_area)) {
-		vfree(stack);
+		free_vmap_stack(vm_area);
 		return -ENOMEM;
 	}
 	/*
@@ -376,8 +385,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 	 * so cache the vm_struct.
 	 */
 	tsk->stack_vm_area = vm_area;
-	stack = kasan_reset_tag(stack);
-	tsk->stack = stack;
+	tsk->stack = kasan_reset_tag(vm_area->addr);
 	return 0;
 }
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


