Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE65CD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167286B0005; Thu, 11 Jun 2026 23:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117896B0092; Thu, 11 Jun 2026 23:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02D676B0093; Thu, 11 Jun 2026 23:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E27F66B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:16:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6A9D1C2286
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:16:16 +0000 (UTC)
X-FDA: 84869797152.12.6E56232
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf26.hostedemail.com (Postfix) with ESMTP id E9EC3140004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:16:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xx9XYhMp;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781234175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4xgDk90vxqb8XarhjHuqrDXk08OYdv+zHxOLhLCQ3Y=;
	b=oImB/SfMZ9sWk0fRXqCYyFP4ElBgMytvVgUKRQgiY4C9mr682ZQiulOebVFYaOKTiAta/R
	IsRoU9pMFKwptTG4LxH8kDBu67m3fsh9EVpvEIyL0Zbl+PK/q3+WFvugmJgvPUYUQ5pf0z
	SvL9v8o3qttjQFBjaUD+x15+gtOgWc4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xx9XYhMp;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781234175;
	b=Dl1pgIjrTyxCduBwP/AhgBLOSwlxDSjOevO2EFov+NK6oTym+YrUPH7N2CN72YeN+X/s8o
	QfjsJ5hBCvMW2K+eC9cCpHg+4noUT+dkrq/K2ccFC91+FOjfCUFiVtF/6q63u3xX1so/7t
	I5yJIuo065VnfI2qvdV3shC/Cfk2R9o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781234173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v4xgDk90vxqb8XarhjHuqrDXk08OYdv+zHxOLhLCQ3Y=;
	b=Xx9XYhMpwYMwxA5cUtqpoJgWsfjFRt+255joY5b8hbqfOz6vyjR2t29+5mxL+FlTpSGAiB
	aXCNeXlZh6gzcp7udtmxDXpCtf5XgqS4V7SPPLO8Chj+ztarqcZgZrERtYNIuUn3q6ArUC
	G883H5IlHOXLXqKP+tBwoW+J0EmTMkg=
From: Lance Yang <lance.yang@linux.dev>
To: leitao@debian.org
Cc: catalin.marinas@arm.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	sj@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH RFC] mm/kmemleak: avoid soft lockup when scanning task stacks
Date: Fri, 12 Jun 2026 11:16:05 +0800
Message-Id: <20260612031605.58235-1-lance.yang@linux.dev>
In-Reply-To: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
References: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E9EC3140004
X-Stat-Signature: pfjagpjo3u4xptkwp3jwbbc66a5yu6cr
X-Rspam-User: 
X-HE-Tag: 1781234174-94775
X-HE-Meta: U2FsdGVkX1/6giPRw/UZVAziFeZnxIU5qlCUW9IH+2TDnqOx7UKRfWXFLDDr0SNc/1LxbDUjYkZuJQr16iR2SpbKOjXE7xm5hvnm5GyG7tvkvwtx1jpAa8NoqrpGe5Yxu8aWLWQG90rnpoqSNV5dYL3hMHAXw8mlKY6tdx1w1J9GkGkVIg0/4DQXdO9uVKJMYnIJXhitAo81zKTKBZfLdYAdVwMCYUT1o7bQTVbNdZukaKEqisiaZNAuUK51Km0j45sjxy95dp7EI4xllIx4U0v2Ol5rRWzA6y7quIxEQmIOsw9lQJlS74ingMnd67mzdl0BNV1WuaU740c9ogPBx1P/2j4wmi4cc1SOv65vEJ2SnixSSz/7lOSjS+jL7cq3zuehWzYImk8azAMJfz/3+VbhpzcXdo+oA071cJnG6dvljBuEpybwDF4rSNuYHQOEtRmaRyXtodx3a8qItHrFgO0FkRB6AavLZeM2Y8Dn7BXXfdfn92/DIk5YDnNRWHOkTMIG+UmYkXuSolOaRS19pzs+NBcxP8bdvEITGZmsvamj+Ol1x8htbgHy4Vb7YHwBkJivIh4vKei3aAN9+oxiFkkCYidK0fK6+3DsYp86L/3Z9RLCC5vvrYca0gzOR2utuPJEkEwvgEhiqVvlT5NhWiu2z/A5fHyoO58E/xlD0Il5OQWLTV9pcEWuabccraB7LEnSm6/OjXqDCEosqc2JdCvmQmboFcosrKRvd1yenSgH8vuJNbQCZFtMAcjo+b2kTCuZr/bcMex+7eDhrAMPVyyBRWTnkhfian3Qo8y9Quw3XxaC6Xfl8Aq6msbKzW8zkTTua0JyJ4grrLO/VnmsmYT28CuDKHDGusuyymMwcFH9nq0JlNlXDvInoxrs4b0LQwS0n+VC24k16+EkX/FOkkL5XsWY/pZB5UQvM3YfvR+X9R28qFjJdRmo1HiQiUmAS0nNpM9UMwcDt7d4bAB
 Njm0Lkww
 YxrKDWlrBXHAtM5oyCvjauGEt1DVR7qg8EZ5dA5QaFv1E7zxg+zPoSUP+YFETh2ay3LWCzOZXcBMKMmkHaqRZHXhC5jdBs50sfeWb+yL88eQAhwbn+x/DEGA7AxTtqqTgcJE6y1VzQSm4R3RKWpD6o+N7FNZjRRO5LdRSNuNUuIkrNn5yI63wdpllNyR4ie/bcnFStCGTi2+D0uu7xJJlAC8RiOxdb6WDhZdlRmwWrsE9V9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jun 11, 2026 at 05:45:00AM -0700, Breno Leitao wrote:
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

Neat, good catch!

>A cond_resched() cannot be added directly: the loop runs inside an RCU
>read-side critical section.
>
>Split the scan in two parts:
>
>1) get the list of tasks (with RCU read lock) in an array
>2) run scan_block() for the tasks (with cond_reschd()).
>
>Is it a sane approach?

Why not use the kernel/hung_task.c pattern here? Seems simpler, with no
extra task-array allocation ;)

>Signed-off-by: Breno Leitao <leitao@debian.org>
>---

Could break RCU only when resched is needed. Pin the current cursors,
drop RCU, cond_resched(), take RCU again, and continue only if the
cursors are still alive ;)

If either cursor died while RCU was droped, stopping this scan round
should be fine, IMHO.

---8<---
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7c7ba17ce7af..1062d9545054 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1695,6 +1695,26 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	put_object(object);
 }

+static bool kmemleak_stack_scan_break(struct task_struct *g,
+				      struct task_struct *p)
+{
+	bool can_cont;
+
+	get_task_struct(g);
+	get_task_struct(p);
+
+	rcu_read_unlock();
+	cond_resched();
+	rcu_read_lock();
+
+	can_cont = pid_alive(g) && pid_alive(p);
+
+	put_task_struct(p);
+	put_task_struct(g);
+
+	return can_cont;
+}
+
 /*
  * Print one leak inline. The hex dump is gated on OBJECT_ALLOCATED so it
  * does not touch user memory that was freed concurrently; the rest of the
@@ -1894,7 +1914,10 @@ static void kmemleak_scan(void)
 				scan_block(stack, stack + THREAD_SIZE, NULL);
 				put_task_stack(p);
 			}
+			if (need_resched() && !kmemleak_stack_scan_break(g, p))
+				goto unlock;
 		}
+unlock:
 		rcu_read_unlock();
 	}
---

Not tested, though, feel free to grab it if looks sane :)

[...]

Cheers, Lance

