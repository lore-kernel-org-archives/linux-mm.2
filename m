Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD4ACAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE586280031; Thu, 18 Sep 2025 09:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBCF48E0093; Thu, 18 Sep 2025 09:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFAA9280031; Thu, 18 Sep 2025 09:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CFD1B8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:09:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8537B1A01CA
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:09:51 +0000 (UTC)
X-FDA: 83902403382.17.6AC848F
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id C2FFAC0010
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:09:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zTX6KrkY;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=tdOkm30R;
	spf=pass (imf28.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758200990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0J+w7XlEgDChzOKAEy+PX0pTTOKKOEyFY5Vzd9kDbSY=;
	b=cNbsmdkEQKHKh2vejILoYNuZc8Cwvz4NSkboqvHF2+BezEx3BooYTkOPDkcjwbQs4j6iNP
	BI2prsN2uB8qYNKvkGu152R0Z1sl185eW6kKacNsiAsH2CFQ2B83GKenzzj5ZRhWuQmJyq
	6e4QAId5/rtcXD1DHkJVxKHp3dSX3Mw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zTX6KrkY;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=tdOkm30R;
	spf=pass (imf28.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758200990; a=rsa-sha256;
	cv=none;
	b=f0j7VtUEmRgRYckJS4jNISLjFm0t1TNm2RW+8LCWxuSvrQvd2+vMX4/qxb83shurtAsqvF
	04/s18OEnh8l9BvuqS2CSchL2DApzDl/+noABelHONCHJKpY/GA4CRG3T2+fQ/jagk75zz
	ifhn0cUKZAXlyj+mmF7RlZc1E1eOfnQ=
Date: Thu, 18 Sep 2025 15:09:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758200987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0J+w7XlEgDChzOKAEy+PX0pTTOKKOEyFY5Vzd9kDbSY=;
	b=zTX6KrkYmVroC46eQBs3JS5bEyH8szRWeWSvGOPCS91GmIK/n8BTlP/39L082XQ7+2bRgu
	tBCITLfJ89+m5XCmKBpl0L1R4/zCwGnNa7KDSe0Cxwwgto/zhhO3OsOQ5ZE5ci9Ed5sRIo
	R5eyi5pdeMxlgLKNZMzDbM0dwQRRbv1licZtdsTbhWHwinj5DEkTnjzXN5geCN3L8u7ifg
	oUxwfaCLfGIjg5HJDAxOFdG1mereO6jZGQ1D4C3ywdoWJx33GzoHS7q/LYEO+SCjd8aegJ
	A36gcub6kEP7n5ou5foc6cXbKyfAoskNiiAX2LJxi00URilmx05eBMPXcGunMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758200987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0J+w7XlEgDChzOKAEy+PX0pTTOKKOEyFY5Vzd9kDbSY=;
	b=tdOkm30Rs9bK/JvdJRMJpwNr3FGqtWbyjXpEQeZSi+EXIHZA6mWA82YEhYGLuIt3vVXwzo
	VX6Zt1sm+LzjNQAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vlastimil Babka <vbabka@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>
Cc: syzbot <syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com>,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com,
	juri.lelli@redhat.com, kees@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com,
	mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
	rppt@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
	vincent.guittot@linaro.org, vschneid@redhat.com
Subject: [PATCH] futex: Use correct exit on failure from
 futex_hash_allocate_default()
Message-ID: <20250918130945.-7SIRk8Z@linutronix.de>
References: <68cb1cbd.050a0220.2ff435.0599.GAE@google.com>
 <867144d3-b05e-4ce2-8bb6-da01e10fbd73@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <867144d3-b05e-4ce2-8bb6-da01e10fbd73@suse.cz>
X-Rspamd-Queue-Id: C2FFAC0010
X-Stat-Signature: ut358kxk7qm6ihzc7oxjnxu7rsn4dk6a
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758200989-320257
X-HE-Meta: U2FsdGVkX19EgZPAts7RgdVOdAIE2D3y0n5kthWSyBz6v1e3ZkKj8i+mfp80Kwya2pBaE6GioEsjTftoQEQbhmHm80y8bZn5W+vMhUkZsxoGBOf8OK2Lc32vymbo7MRV5xgKNKxLLTwpSDO0RnRctqFNedJLZmyAh4wsSVfgVUXBpdy5od3cUGgxRiO0VT1GBHszv1E48mUYmsgYRA7Y0NHNZw8PXrtsybfbs9RxSNKMuhcdTO3Pwv0H6fO5q3MmaNXL0Swmd5u+ZDS0JtxeYREprRylm3eWp4KQaqYWdFyYVQb7el1XH3XKBAALWY7tgpQNkWA66/o86oZw1fsXBz6BRfkv8AOhQAzUg8pAzxAG6xGunuC4Eww+4D21P81BryKL3AYusZdLqybuCuk3T+K/py87SFHXvmsfOZ4ifacnXJyvgJ+pX1pkfltfQYHkf65IcpdOk1tMDCcg+Uo7TmLC55/YfDH8yycPd0VUuzdPpLnMRx3rxcKB915V6TlMMxYLuPfi+mlTbWvdYslLIrB1Jr8XcQrkd8zZOVD8IUcVBTFbVPT8rNv9XbzlHlCS2X1Y4yaKoZ0g/akPbq3YHsRbSJHoQzTkUQ66SFKJNWwBpckGbtDus5VyTt25lbaY2iOHOv7pq8kB6eypT4mC7+xIfQb2t451iCvwFHfUCdL7qcc07z7Osa3GRPA5ltMII+VQBsmotKAsToDQjaAF8VkeeHMH3PcA8cECFSJSPmBB1PBbHTeUdnuKJqoCklOpGV4jT9j/ahNY9qlwYlsi5jJ6w12KziDP+7iTeT1lctyqk625xnK2AQBze/TfV0c8QArAdfR2jUm0/8QW5JIxRJzyD1dm4KGESg6GneF3U0hd+hUAkoUIdiSYPFs4LSEbwXcXujn7irzwuGWlq83PRQPjsfP5zkt04DzBP3rL41ZJA0VLmqrQFanLHHpeCSK2+S95vYbbW2ycP20Cxac
 i9ucOJr9
 QWSfS5QUZG5h0z6hYLpc4hyTPmz+Gin4Df4JYlSEzjqalS5R/35Hn+5qMN6UatkgGxqr0j1SMk03jBNsvg+piLpwX/1qRghyqxahYvcUi4VNRL2ShbbfjbsyT7AzK5UmAHMeb4fOAmRvQaPDut4xOTqJmn2QQRJPpp1jz+kHLkbM5oWoTNZ16TmddWArAPOskOqJ8nCfWsVqja6Rf2kxT2/g5h/NCeA2Km8NSR86iqK2PqoocN8S7EAAzAptjXWN/oPYI+TJHfFGYnhSYDuDh/0wqDFmTxcPMgPkdQkUhEGcb8X/ht2wJQZPLPHgykj8z6yfO3NXS5/zHkbq9khlfPvdOpEluhvozf8YZMu9sd0dkTxqhzeQYf7x8d7aXittpR5HwCQc46GjlLwXyd/G8HruQ+/4yw/723dwsUjMfG26fFMJ8krjU7+frbbUWr7TlDEL7f2fZdgcSuQkJ1hvWQtAo7VkJRDkkAzOfLEz3Ap58MMQbkblb3XzEAPxt2u31rwzO1KOjwA3T3L8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_process() uses the wrong error exit path from
futex_hash_allocate_default().
After exiting from futex_hash_allocate_default(), neither tasklist_lock
nor siglock has been acquired. The exit label bad_fork_core_free unlocks
both of these locks which is wrong.

The previous label, bad_fork_cancel_cgroup, is the correct exit.
sched_cgroup_fork() did not allocate any resources that need to freed.

Use bad_fork_cancel_cgroup on error exit from
futex_hash_allocate_default().

Fixes: 7c4f75a21f636 ("futex: Allow automatic allocation of process wide futex hash")
Reported-by: syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68cb1cbd.050a0220.2ff435.0599.GAE@google.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

That private-futex code was marked BROKEN in v6.16 and re-enabled in
v6.17. It could use
  56180dd20c19e ("futex: Use RCU-based per-CPU reference counting instead of rcuref_t")

as Fixes: instead to avoid backporting to v6.16.

 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index c4ada32598bd5..6ca8689a83b5b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2295,7 +2295,7 @@ __latent_entropy struct task_struct *copy_process(
 	if (need_futex_hash_allocate_default(clone_flags)) {
 		retval = futex_hash_allocate_default();
 		if (retval)
-			goto bad_fork_core_free;
+			goto bad_fork_cancel_cgroup;
 		/*
 		 * If we fail beyond this point we don't free the allocated
 		 * futex hash map. We assume that another thread will be created
-- 
2.51.0


