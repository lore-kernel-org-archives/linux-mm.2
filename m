Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6FBCCD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198856B0096; Fri, 12 Jun 2026 12:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150036B0098; Fri, 12 Jun 2026 12:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F726B0099; Fri, 12 Jun 2026 12:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA6F76B0096
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:52:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AD771C2081
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:52:26 +0000 (UTC)
X-FDA: 84871853892.21.95C40EF
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id ECCCE14000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:52:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BpA+YcXJ;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781283144;
	b=fcBUIF+JchORA1bdlIKHXb5Gmd/8x2K6nTN3KCQkgWjzM+EV/MGI4r1j+1VGH0FuXn4rUU
	DMNVpDJt0GGs/rEJPLDxt54QK+HJg5MqOUEz1s+bDw8DXpV/GRQ73LwWuwHZpOSSvtz84a
	+lAZGGfraFuvuRFLFZs4K/KpZ67gfbU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BpA+YcXJ;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781283144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8j59LeUc679PfGBjvaEMUQyi2RrRwSDjgmSKKRYE6xQ=;
	b=54oPMisC9+T0P1+hc35+jsVzefDXPfIBAdXgbVYb0J0Dk5ocz1LVPMzXrJiH3d1kxVDN8i
	iR0muIzEsJI4aCUzdWp0JEPaqxdyNZx00Udv2ycFjH69ujn4ajnU1oXbrwxbeeAhT5JBc8
	f/UUmBx9zdnyosQsVzWwhVlqbkc/trc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781283141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8j59LeUc679PfGBjvaEMUQyi2RrRwSDjgmSKKRYE6xQ=;
	b=BpA+YcXJqpgshFc9SncDeldaMc6lxkT77ySVoMsNh1cOMS3vB9L6N5FkkbQ8TXVCubchDi
	rWkDIV8dBTUJ6llMIyEjtO+CAqFA1Cj4UlCD1B4tF1SqUNMZyJhrny0bvv6gyLl2Oqmt5Q
	1KR3eeXn/ROyMRquAeT5NawQ/oVH9/E=
From: Lance Yang <lance.yang@linux.dev>
To: leitao@debian.org
Cc: catalin.marinas@arm.com,
	akpm@linux-foundation.org,
	lance.yang@linux.dev,
	dave@stgolabs.net,
	oleg@redhat.com,
	cai@lca.pw,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/kmemleak: avoid soft lockup when scanning task stacks
Date: Sat, 13 Jun 2026 00:52:06 +0800
Message-Id: <20260612165206.93126-1-lance.yang@linux.dev>
In-Reply-To: <20260612-kmemleak-stack-resched-v2-1-53240de79e88@debian.org>
References: <20260612-kmemleak-stack-resched-v2-1-53240de79e88@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: ECCCE14000A
X-Stat-Signature: fxqy6481ch6jf94na5ht9xu4ipiysxuh
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781283143-397355
X-HE-Meta: U2FsdGVkX1/+23/i599dUqICs6LPv2nWrdcbpy3hw/BYXD0UjhQpoH9nH6t+9iaIvpRJMRvvwRDFSIUe5RHccrynvECBjeO2yzVeqQ0YcM+EZUlGI3vdPou0+OFlIxhgNCirCVeM4KXzvXPuT81Av4KDKr/1tzt6KD9iM4iFmC51Bkuiz5aMp/rJUD4SJV9nYf+S+2rzexxl25iWvR2Phbvcmu8C+fBO3QhtkSZyPos7AqEo3P51Il5OHHu3QVTID1VPPSAuiZpJMAYfQ8cncBd5Tn6UctJ0C9EZRveAMGvT+4Euqp2CVESD0pqnMckQzLHjCZ/e6de/aKCBNMLpV0u2kRUw/JX+gOgsTSGJuJWMk8mE0x5rQAMqKNHkFfD76Gxu/YO+VJDecg51h6x9+kbSa5ebXBYcGeYCkUZf8q4U+05o/nfjmfHVr/Xlaa/9PY1fSjCx4RNctjcoJa9oweuKtFIFAWQGeDkctlAVpvIunsXnosPrRLMdLQ4Z47AF8b+8qS/+ZjjaTxtI4AvEYYkHSKjXieKuoVGiwkIuNasf5JDpbxy+IIwTzeTZdELkZem5YaW/297/r/gHA2rooCv/Glz2cFMGYOeYmUlCkzjcORWrwtegwC9iRIP5DHPWvc/Uz5XhTB//avb2FPuXui6JVA8s6ZAbZnSDEujvIO7eAapcY1LkESGph7aji04+sBAAVXR1w3YuFIh8QHplTpFARrdcvPHFqicG1AaQezSL4gn/67Vn4Nu+1sKV0D4hk8w7oiEhmmd8166vj6dsHzmXmMSODEmlrMBlsIgg0E/wZHrzCZD8fOJTCSu8WpxmfLXU0d7aWFL1axsfftrsbuuzbVlhLUTLJyvKXNz5eeYoECSgNofBMGFT/XIz7Hk5fnuSId7Q21hrbOX3ZPAJHH4FHedtKzHsDwjURa4PMhXhDauF1Fd/dohiYVyEfGZmRj1HSrBcGDTGCf1KZfv
 5bHTYTvR
 EiHbGF9lauGgZNqGpGeeaY0iRyRCC+kIvEsNGyEO7o5sMRQuzt+R8GqLYW7hmJFVOexKu1kht1p5rHhxBxa20h1YP4HX1Oj0DZHCNN6u8F5ItiKpfWAOPk737MU8ej7Lcs7ZmUArO2wkBZQZwNqVsfIetp0r3KZXX1OWmq+8Yb4BiIEeATNqrze/rTNigFW0I+KgRbm1HC+Dt8aDaBOk/kmOae+wxGJZwj29Bh3pFJN8vaQa+uB4Z5Lq5JVES4q2gJdIN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 12, 2026 at 08:16:07AM -0700, Breno Leitao wrote:
>kmemleak_scan() walks every thread and scans its kernel stack under a
>single rcu_read_lock() with no reschedule point. On a host with very
>many threads -- amplified by KASAN/lockdep in debug builds -- this loop
>can hog a CPU long enough to trip the soft lockup watchdog:
>
>  watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [kmemleak:537]
>   scan_block
>   kmemleak_scan
>   kmemleak_scan_thread
>   kthread
>
>A cond_resched() cannot be added directly: the loop runs inside an RCU
>read-side critical section.
>
>Borrow the rcu_lock_break() pattern from kernel/hung_task.c: when a
>reschedule is needed, pin the two iteration cursors, drop the RCU read
>lock, cond_resched(), then re-acquire it and continue only if both
>cursors are still hashed.
>
>If a cursor was unhashed while the lock was dropped, the thread list
>cannot be walked further, so the round is aborted. Such a round scans
>only part of the task stacks, which would make live objects look
>unreferenced, so reuse the existing "scan interrupted" path to skip
>reporting; the next full scan reports the real leaks.

TBH, a bit dense to me as written ...

>Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
>Cc: stable@vger.kernel.org
>Signed-off-by: Breno Leitao <leitao@debian.org>
>---
>Changes in v2:
>- Do not create the nasty array, but use the same pattern as
>  kernel/hung_task.c.
>- Link to v1: https://lore.kernel.org/r/20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org
>---
> mm/kmemleak.c | 42 ++++++++++++++++++++++++++++++++++++++++--
> 1 file changed, 40 insertions(+), 2 deletions(-)
>
>diff --git a/mm/kmemleak.c b/mm/kmemleak.c
>index 7c7ba17ce7af0..d88274dc0c605 100644
>--- a/mm/kmemleak.c
>+++ b/mm/kmemleak.c
>@@ -1695,6 +1695,32 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
> 	put_object(object);
> }
> 
>+/*
>+ * Briefly drop the RCU read lock to reschedule during the task stack scan.
>+ * Both cursors are pinned across the gap; return false if either one was
>+ * unhashed meanwhile, so the caller stops this round instead of walking a
>+ * stale list.
>+ */

Personally, looks a bit clunky to me with "gap" and "unhashed" ...

Maybe:

"
Drop RCU long enough to reschedule during task stack scanning. Keep both
cursors alive while RCU is dropped; return false if either cursor can no
longer continue the walk.
"

>+static bool kmemleak_stack_scan_break(struct task_struct *g,
>+				      struct task_struct *p)
>+{
>+	bool can_cont;
>+
>+	get_task_struct(g);
>+	get_task_struct(p);
>+
>+	rcu_read_unlock();
>+	cond_resched();
>+	rcu_read_lock();
>+
>+	can_cont = pid_alive(g) && pid_alive(p);
>+
>+	put_task_struct(p);
>+	put_task_struct(g);
>+
>+	return can_cont;
>+}
>+
> /*
>  * Print one leak inline. The hex dump is gated on OBJECT_ALLOCATED so it
>  * does not touch user memory that was freed concurrently; the rest of the
>@@ -1804,6 +1830,7 @@ static void kmemleak_scan(void)
> 	int __maybe_unused i;
> 	struct xarray dedup;
> 	int new_leaks = 0;
>+	bool aborted = false;
> 
> 	jiffies_last_scan = jiffies;
> 
>@@ -1890,11 +1917,21 @@ static void kmemleak_scan(void)
> 		rcu_read_lock();
> 		for_each_process_thread(g, p) {
> 			void *stack = try_get_task_stack(p);
>+
> 			if (stack) {
> 				scan_block(stack, stack + THREAD_SIZE, NULL);
> 				put_task_stack(p);
> 			}
>+			/*
>+			 * This is an expensive loop, we must to call the
>+			 * scheduler to avoid lockups
>+			 */

need_resched() plus the helper name already says most of it. Maybe just:

"
Break the RCU read-side section before rescheduling.
"

>+			if (need_resched() && !kmemleak_stack_scan_break(g, p)) {
>+				aborted = true;
>+				goto unlock;
>+			}
> 		}
>+unlock:
> 		rcu_read_unlock();
> 	}
> 
>@@ -1937,9 +1974,10 @@ static void kmemleak_scan(void)
> 	scan_gray_list();
> 
> 	/*
>-	 * If scanning was stopped do not report any new unreferenced objects.
>+	 * If scanning was stopped or a stack scan round was aborted, do not
>+	 * report any new unreferenced objects.
> 	 */

Maybe just say "stack root scan was incomplete" here? That's the actual
reason we skip reporting.

"
If scanning was stopped or the stack root scan was incomplete, do not
report any new unreferenced objects.
"

>-	if (scan_should_stop())
>+	if (scan_should_stop() || aborted)
> 		return;
> 
> 	/*
>
>---

Apart from that, feel free to add:

Acked-by: Lance Yang <lance.yang@linux.dev>

