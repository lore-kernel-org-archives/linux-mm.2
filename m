Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A8DF4484C
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5B76B00B9; Fri, 10 Apr 2026 08:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA65A6B00BB; Fri, 10 Apr 2026 08:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20076B00BC; Fri, 10 Apr 2026 08:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB30F6B00B9
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D2D78BCE8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:02 +0000 (UTC)
X-FDA: 84642553044.22.8FC70F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C07051A0007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dAmn2yz6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823600; a=rsa-sha256;
	cv=none;
	b=C3FcZGGUhXTW5O6lTIlZo2FMnnplrxosGXiW5RNDPrpRV9NeSZmWn2fnu1p7FL9ncTNyc9
	njm+Map42NORkE2TZcK1QXJhY3UBVkVGYND4Ymc+4wCtUOQq2KpzLSbgTpcgWMR/3qhlOj
	prblRWqupfCbajGshWOj8W7gkF6cDe0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dAmn2yz6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=K4NT27D0mqg0VfaBgETboxq8yA7MxcA9Ab7uPnykYS8=;
	b=uoUu0YgHTBnIrYUXnd1Bt8OxpdWJBCVXzp1oJeFQcORhQKtYRtqTagOXt9VwCDfVP03VTO
	vqbjOKnYM1a1uziM4xOifV2vSWoqdY8VOVvzzXenU1TcCyAS33NpD2Iq4iCNkuhd2cJ+MH
	Sr/ugcaTSN3Ltqs29fRAEdGXwvmD0uM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 460E06132D;
	Fri, 10 Apr 2026 12:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25608C2BC87;
	Fri, 10 Apr 2026 12:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823599;
	bh=p4ShM3O0GBFCP2qPjb6zSxh+Ha5oLOtvBK8/RtfAnVs=;
	h=Date:From:To:Cc:Subject:References:From;
	b=dAmn2yz62WI0i12fcQ9F03BvOYg2+eAhjig+X04BVmpX8c9M01sHZgZEu1rVRhWki
	 aMBfoGnUl9WpMMqLWFryj6yJQ9lwTCD1i0oDG/S5mN25bXyGqKT30GrztgQQ3rav4T
	 BmbqmYb8KPxXW6sSQ9CXXe5EvhipWJeX23ghk7uDybakuO9EcTg4cMG5iBSrRe/GPa
	 tJ33MSKa5EFjbZHZi72K/jby5Pm2bPWRte8ZG3Zb5p2f71WeXeB85PUV24dYQuwkS9
	 ZuUw9oOAlqL+roK/1FBLE3TIhiCqSUqlbqWXBE/GwV9uTSEnFXIo6OPA+8wwtYtllu
	 kFOMRP9PboEEQ==
Date: Fri, 10 Apr 2026 14:19:56 +0200
Message-ID: <20260410120318.794680738@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 linux-mm@kvack.org,
 Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 18/38] lib/tests: Replace get_cycles() with ktime_get()
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: yqph85awk8x13831fi3gurnjk53idot9
X-Rspamd-Queue-Id: C07051A0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775823600-274750
X-HE-Meta: U2FsdGVkX18EGHEQicQoOW+11TWNxqogpJEpqswK9tuxD2onvK6iqeVuZORwgBo7wU1Syf6h5OBRCee2/3BS2/04wGTJVbxd5YdCP4Gz5n0+VW9x4s1vdRzCWQr+RFfLwUsKoljVI+lTyztQ6CtMSKDHfD3mbkKtOhrCpxGFfouktiaqPnA0v8ReJPK7bRGa2OsLjvZZoi28l2yyb6sEroITeHKNhnR89SxcUAoTKmrw13EfpZ4E85thsZk+MeTL9CRqGt1p9FNL5XLe4CRIKxx7a5wPYq/t5Fey77ksPdFKFQ2pByAbVXW71BDjRlO2v1JHCbMplYhhaed7sWWWXLvO7BBr4veQW1HZjsMrT7JcSrUwUZMYp3Jv45YJCs9r55FNaZr2NZtRViAbVR7UVS2bHUCNvAzW3xfSs/h9YgAtdl4oYxDLe/mmMSSRJxd2HDwx7WsqUvS3yTLUSoXNU7UdOJhmO94E3UYoNDf6D3RzdDbtfXVmn2K1aIbMFU15XqXogFSLkIpQUZ0mJMkX6btQ/7/4v6yyVtbYvektbLfZ+3DcEo5n9793+7rnSY5+uTbiNU2l+RHjEs+1nuAiKcHTkKuBYwIpvqwdjDXTVkT4o/Q4xNaTArOUjopzvhR4vRw2Jqz/wx37ouw3QYgvyC+elQi5EjbJdRHZKFiq1sv53qrFgx/Rcrhvf0mC3qzbNyPayWm16evFtmn0zNOsc4Acbf8IlCORYKc0gU2albO3v0N2+zj0tz5aMWfbrZ23ZXTSY8ogn4vdoa7L/hdpktTf3pl0SMVmb4BFtILyO/huqdZLLDhF1USQrlOUeDxOHiPQDqNiQN/ucqe1rNWt3XaJ8socwWDVrFValJuf80zNYjIe/e04Zx1vnWxqkCoOpbfmbUQlpx7GJKUS1eXzf+hE9U/PZAhEw52ASjj9+80JnhQCzSSgDyzM3kuZ6wvd8IEqClBI7SEwKrDlAm5
 6JGrGkOf
 8LWoEnD2Zql22xcLF5WdOxqpTNFKPLYUfDPKtNVSeSfYoaZqx4H170hpquHXXYDw6Aw8DVbNq3x4/OnIYjkXv9f+j81eyl+Pt8yJ9wfJJNoN2wc+sd+zvnrYScbvg8jPuEiQnvqv4h3EKWambTSmU3QnKSAd1FrxD+PnUaBbjxlXfRDJeDtruAaGOor1a7wEaN6sRSS8AiBO3dqZ6FJhxrdC2/mh3pzI+RozdMm65MGNplQDU3FdYVbx9tBHMClhNRp6k77AfpiXFUKowNBkBeK2Vin3NT75H2P1AtkQsVElE8mg6JLbmYG3vbPZYNjdupaAFQvhi3hOMgewNSqJIi2+2Ltx3g/dFPiUAAcTuA6ImLAE+oNTnh03ZXu01PJDlotFbkZYUoIkqMxuGYokazt72zHEouKGoN6luTCq6uNeCA1r+HAwPCeJ5zVS5cTghu5q613pSZ2M4dSQrFvDziSN3RB14ty0947zy9es1rl7qGFqgMKBsavlXfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_cycles() is the historical access to a fine grained time source, but it
is a suboptimal choice for two reasons:

   - get_cycles() is not guaranteed to be supported and functional on all
     systems/platforms. If not supported or not functional it returns 0,
     which makes benchmarking moot.

   - get_cycles() returns the raw counter value of whatever the
     architecture platform provides. The original x86 Time Stamp Counter
     (TSC) was despite its name tied to the actual CPU core frequency.
     That's not longer the case. So the counter value is only meaningful
     when the CPU operates at the same frequency as the TSC or the value is
     adjusted to the actual CPU frequency. Other architectures and
     platforms provide similar disjunct counters via get_cycles(), so the
     result is operations per BOGO-cycles, which is not really meaningful.

Use ktime_get() instead which provides nanosecond timestamps with the
granularity of the underlying hardware counter, which is not different to
the variety of get_cycles() implementations.

This provides at least understandable metrics, i.e. operations/nanoseconds,
and is available on all platforms. As with get_cycles() the result might
have to be put into relation with the CPU operating frequency, but that's
not any different.

This is part of a larger effort to remove get_cycles() usage from
non-architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org
---
 lib/interval_tree_test.c |   16 ++++++++--------
 lib/rbtree_test.c        |   46 +++++++++++++++++++++++-----------------------
 lib/test_vmalloc.c       |   10 +++++-----
 3 files changed, 36 insertions(+), 36 deletions(-)

--- a/lib/interval_tree_test.c
+++ b/lib/interval_tree_test.c
@@ -65,13 +65,13 @@ static void init(void)
 static int basic_check(void)
 {
 	int i, j;
-	cycles_t time1, time2, time;
+	ktime_t time1, time2, time;
 
 	printk(KERN_ALERT "interval tree insert/remove");
 
 	init();
 
-	time1 = get_cycles();
+	time1 = ktime_get();
 
 	for (i = 0; i < perf_loops; i++) {
 		for (j = 0; j < nnodes; j++)
@@ -80,11 +80,11 @@ static int basic_check(void)
 			interval_tree_remove(nodes + j, &root);
 	}
 
-	time2 = get_cycles();
+	time2 = ktime_get();
 	time = time2 - time1;
 
 	time = div_u64(time, perf_loops);
-	printk(" -> %llu cycles\n", (unsigned long long)time);
+	printk(" -> %llu nsecs\n", (unsigned long long)time);
 
 	return 0;
 }
@@ -93,7 +93,7 @@ static int search_check(void)
 {
 	int i, j;
 	unsigned long results;
-	cycles_t time1, time2, time;
+	ktime_t time1, time2, time;
 
 	printk(KERN_ALERT "interval tree search");
 
@@ -102,7 +102,7 @@ static int search_check(void)
 	for (j = 0; j < nnodes; j++)
 		interval_tree_insert(nodes + j, &root);
 
-	time1 = get_cycles();
+	time1 = ktime_get();
 
 	results = 0;
 	for (i = 0; i < search_loops; i++)
@@ -113,12 +113,12 @@ static int search_check(void)
 			results += search(&root, start, last);
 		}
 
-	time2 = get_cycles();
+	time2 = ktime_get();
 	time = time2 - time1;
 
 	time = div_u64(time, search_loops);
 	results = div_u64(results, search_loops);
-	printk(" -> %llu cycles (%lu results)\n",
+	printk(" -> %llu nsecs (%lu results)\n",
 	       (unsigned long long)time, results);
 
 	for (j = 0; j < nnodes; j++)
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -243,14 +243,14 @@ static void check_augmented(int nr_nodes
 static int basic_check(void)
 {
 	int i, j;
-	cycles_t time1, time2, time;
+	ktime_t time1, time2, time;
 	struct rb_node *node;
 
 	printk(KERN_ALERT "rbtree testing");
 
 	init();
 
-	time1 = get_cycles();
+	time1 = ktime_get();
 
 	for (i = 0; i < perf_loops; i++) {
 		for (j = 0; j < nnodes; j++)
@@ -259,14 +259,14 @@ static int basic_check(void)
 			erase(nodes + j, &root);
 	}
 
-	time2 = get_cycles();
+	time2 = ktime_get();
 	time = time2 - time1;
 
 	time = div_u64(time, perf_loops);
-	printk(" -> test 1 (latency of nnodes insert+delete): %llu cycles\n",
+	printk(" -> test 1 (latency of nnodes insert+delete): %llu nsecs\n",
 	       (unsigned long long)time);
 
-	time1 = get_cycles();
+	time1 = ktime_get();
 
 	for (i = 0; i < perf_loops; i++) {
 		for (j = 0; j < nnodes; j++)
@@ -275,52 +275,52 @@ static int basic_check(void)
 			erase_cached(nodes + j, &root);
 	}
 
-	time2 = get_cycles();
+	time2 = ktime_get();
 	time = time2 - time1;
 
 	time = div_u64(time, perf_loops);
-	printk(" -> test 2 (latency of nnodes cached insert+delete): %llu cycles\n",
+	printk(" -> test 2 (latency of nnodes cached insert+delete): %llu nsecs\n",
 	       (unsigned long long)time);
 
 	for (i = 0; i < nnodes; i++)
 		insert(nodes + i, &root);
 
-	time1 = get_cycles();
+	time1 = ktime_get();
 
 	for (i = 0; i < perf_loops; i++) {
 		for (node = rb_first(&root.rb_root); node; node = rb_next(node))
 			;
 	}
 
-	time2 = get_cycles();
+	time2 = ktime_get();
 	time = time2 - time1;
 
 	time = div_u64(time, perf_loops);
-	printk(" -> test 3 (latency of inorder traversal): %llu cycles\n",
+	printk(" -> test 3 (latency of inorder traversal): %llu nsecs\n",
 	       (unsigned long long)time);
 
-	time1 = get_cycles();
+	time1 = ktime_get();
 
 	for (i = 0; i < perf_loops; i++)
 		node = rb_first(&root.rb_root);
 
-	time2 = get_cycles();
+	time2 = ktime_get();
 	time = time2 - time1;
 
 	time = div_u64(time, perf_loops);
 	printk(" -> test 4 (latency to fetch first node)\n");
-	printk("        non-cached: %llu cycles\n", (unsigned long long)time);
+	printk("        non-cached: %llu nsecs\n", (unsigned long long)time);
 
-	time1 = get_cycles();
+	time1 = ktime_get();
 
 	for (i = 0; i < perf_loops; i++)
 		node = rb_first_cached(&root);
 
-	time2 = get_cycles();
+	time2 = ktime_get();
 	time = time2 - time1;
 
 	time = div_u64(time, perf_loops);
-	printk("        cached: %llu cycles\n", (unsigned long long)time);
+	printk("        cached: %llu nsecs\n", (unsigned long long)time);
 
 	for (i = 0; i < nnodes; i++)
 		erase(nodes + i, &root);
@@ -345,13 +345,13 @@ static int basic_check(void)
 static int augmented_check(void)
 {
 	int i, j;
-	cycles_t time1, time2, time;
+	ktime_t time1, time2, time;
 
 	printk(KERN_ALERT "augmented rbtree testing");
 
 	init();
 
-	time1 = get_cycles();
+	time1 = ktime_get();
 
 	for (i = 0; i < perf_loops; i++) {
 		for (j = 0; j < nnodes; j++)
@@ -360,13 +360,13 @@ static int augmented_check(void)
 			erase_augmented(nodes + j, &root);
 	}
 
-	time2 = get_cycles();
+	time2 = ktime_get();
 	time = time2 - time1;
 
 	time = div_u64(time, perf_loops);
-	printk(" -> test 1 (latency of nnodes insert+delete): %llu cycles\n", (unsigned long long)time);
+	printk(" -> test 1 (latency of nnodes insert+delete): %llu nsecs\n", (unsigned long long)time);
 
-	time1 = get_cycles();
+	time1 = ktime_get();
 
 	for (i = 0; i < perf_loops; i++) {
 		for (j = 0; j < nnodes; j++)
@@ -375,11 +375,11 @@ static int augmented_check(void)
 			erase_augmented_cached(nodes + j, &root);
 	}
 
-	time2 = get_cycles();
+	time2 = ktime_get();
 	time = time2 - time1;
 
 	time = div_u64(time, perf_loops);
-	printk(" -> test 2 (latency of nnodes cached insert+delete): %llu cycles\n", (unsigned long long)time);
+	printk(" -> test 2 (latency of nnodes cached insert+delete): %llu nsecs\n", (unsigned long long)time);
 
 	for (i = 0; i < check_loops; i++) {
 		init();
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -454,8 +454,8 @@ static struct test_driver {
 	struct task_struct *task;
 	struct test_case_data data[ARRAY_SIZE(test_case_array)];
 
-	unsigned long start;
-	unsigned long stop;
+	ktime_t start;
+	ktime_t stop;
 } *tdriver;
 
 static void shuffle_array(int *arr, int n)
@@ -490,7 +490,7 @@ static int test_func(void *private)
 	 */
 	synchronize_srcu(&prepare_for_test_srcu);
 
-	t->start = get_cycles();
+	t->start = ktime_get();
 	for (i = 0; i < ARRAY_SIZE(test_case_array); i++) {
 		index = random_array[i];
 
@@ -519,7 +519,7 @@ static int test_func(void *private)
 
 		t->data[index].time = delta;
 	}
-	t->stop = get_cycles();
+	t->stop = ktime_get();
 	test_report_one_done();
 
 	/*
@@ -619,7 +619,7 @@ static void do_concurrent_test(void)
 				t->data[j].time);
 		}
 
-		pr_info("All test took worker%d=%lu cycles\n",
+		pr_info("All test took worker%d=%lld nsecs\n",
 			i, t->stop - t->start);
 	}
 


