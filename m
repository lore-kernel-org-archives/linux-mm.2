Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B1EF4484C
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 457EC6B00B7; Fri, 10 Apr 2026 08:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408886B00B9; Fri, 10 Apr 2026 08:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D14B6B00BA; Fri, 10 Apr 2026 08:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17EAD6B00B7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9CAF1A0527
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:57 +0000 (UTC)
X-FDA: 84642552834.22.454B5BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2553240003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jdPhw8GN;
	spf=pass (imf01.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=UDyKTHGnMCmYbgJ8T4kKNARn1fh97FJoB2dW0qVXMMM=;
	b=ClnmEh6UOf3ENl95cf7syM04utKXBjkgaEb14C442DCyrvHyOWjGdL+XzP7Z+qbX3Y/9hx
	wGfhLnnQqGU428kxq6hgjjwQbl7oDqjYBFg6xJVmuD1sE0BUY5eiTpAaOwwsrJ91e34jHj
	v5HZTWKmsyJZMNTdwQRqNeeffvlI0j0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jdPhw8GN;
	spf=pass (imf01.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823596; a=rsa-sha256;
	cv=none;
	b=TjMMb84mh8HjfotbYwsQhEb2gyWf6kh/S6mtOaYfbmK5mM+YW07n7L27jZjiHSApRoS6Ub
	l7dUDXtPj+RInnsz6q+gURx6fIZPTmnSmi41eSWnxA8wcElydDhsGo+qfmHrriJPNEbFqp
	I/wQ8ZPBw9hpmXHy/fNHcrua5BN0Xts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B39F41A7C;
	Fri, 10 Apr 2026 12:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B407C2BC87;
	Fri, 10 Apr 2026 12:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823595;
	bh=QF8xu2w1ekYQn9h8hXu1i+73iAYxDniq8hK08qkXVok=;
	h=Date:From:To:Cc:Subject:References:From;
	b=jdPhw8GNcCbidbYQHfvNnynlBMQ6C8yak4JEVkjtLiGZL97Y3Kg6hDMEq3+pAZn9l
	 eebAKa8zdYjNIUhQRVD9BnFcdpgh+r9+oY8nCOOBP3TXDWg59J0yEe49bjDh/j5GY1
	 J/+Mrsj5Z9JlM/AmirqGD8HvbUDB7O2+WSvwYb2Dt2w8mdLS3mlRSvEUCA//cm+I50
	 T3lnhTwlF7Ll8vkIeV4joWfasbaLJDpe8kQqwYnenbDJtbX6i3a/y8coaGgKPKMk+y
	 /Al4CmKTrbd6SuhGXm70yx904ODj2E0CWQ5/8mFozaTW1DKtHUVqiCNDO1sI7Gfirg
	 PX6BMdDjfEFyw==
Date: Fri, 10 Apr 2026 14:19:52 +0200
Message-ID: <20260410120318.727211419@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
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
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
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
Subject: [patch 17/38] ext4: Replace get_cycles() usage with ktime_get()
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2553240003
X-Stat-Signature: hqjcie8nrj9dki3hhp9k1fgnxhacsnqt
X-Rspam-User: 
X-HE-Tag: 1775823595-463973
X-HE-Meta: U2FsdGVkX19Yk2+OTIvW2hboN3ATBZH6t8oZQs/kn70FOGlarDmi3Jg0mxTJsDkXkvxGKsgO8/2mGIiWepkK646DD8D/4qJ2+qICEIR3Sfia/rgv8t26NuQrtVMIIKFOQbQZpByNlkmXUqalclzcgzGhNZwECGmFS8XT4sm6+xzcNEqwib4WiWsCBl8nsDfF5Qjc4FiYd6LNkxV4N1biRtT3v0RN0Hr1l7Vfg8g22dO8DBHTYwnbMTt5ZfHkITckeHown18JVKRptzCiYOF2C9tL/bQA1glHeUSCGa+3UI9SBUZS8O2LCaXdBC9MnipaCrUYW7K1ZTaQF3xonO6QEEY0w5i+V/7LEZYCLzXB5AsfT8m/hPaHqs9cwFiUpkNGwO5iRr4cJygkB47J9Hbfqjz5xP5zvMKbFlRpZW+UptgDzpRJhOOq51s6deINW5DoILl2u/v9+c2YVTEo6WWkn6NEwJy5S2gtIfOnqHJP7WH/roWL0Jtvq4ApaKeFvEHSQh/jMHv65YEFVyKviJwbEEY06nQ2O6/XEFx7JALvyoIDtT0ojNE0hFYCMkYQtotD+XgH3R6z67nEI/R4hYsee6dkWWo+Sb61aRlk7809zSv2UFbS+NrJ86sB+p5y99Mjdc0nfTMMA5rIcn4POIusj/6rCCk7ADFf1qNiBbRukNFA0Q4TzKWeYCi4BDb0GCMofsNsep7DizEnMUBb58bW2nJc3wFyWwp+1bZSSiE++q+7ouqBLVcsmT1mTyl2TKT5g7gbDokQbgg8anv6bDsI33dvTskBZt7JlfKW/1flAlT5eEDxqYFpmoi8EUupnpmvW0q06FDls0/MiAaq97QWyNvVenI1KCe+TpWmcAFJYtUmPYFCyAG2gSrGOkbCS0V/qiVMzwEUwf8s0plIS4rRMnII9/49YSIdad89Fi2UoDGjmGqHgdptj3ss4RMbMMiUY+k0qdGcSvdAFgUdi65
 +6tUipqs
 NLvxTiBhm97wx1fXzgKVspgFJAfUWBMh2MWqX7pDkoNbVt8kyEQW9ZHGreFY5ZVGWzdluiJPKkybyTykivT1aDW/HcqH2YsfG7AwEqmEc1q4Oq1hp4w1Mm2P15+mGdQySg9TTv0cKNnYNRExJJ/xBoctwyQhZ9Kx1pvrPdpHTWdvOYDE7mvd75tybWO7ckzAsPbcuABYJLcFvLXWGeYDN9RwP8Mqutv/zK3pelyeI2wW2Px05B8TygP1CIY5B50HXYOwaZeJvI0p7yiFIqv8B4o1saAj+NNC2QB+o+m2OVI4VOjs8OHeXveLDRrJS4AcZWZL9z0aRQMgyIHgYDG0MkOBvWue8jb1NoT1OrBl8a4K8QJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_cycles() is not guaranteed to be functional on all systems/platforms
and the values returned are unitless and not easy to map to something
useful.

Use ktime_get() instead, which provides nanosecond timestamps and is
functional everywhere.

This is part of a larger effort to limit get_cycles() usage to low level
architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/mballoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1289,7 +1289,7 @@ void ext4_mb_generate_buddy(struct super
 	ext4_grpblk_t len;
 	unsigned free = 0;
 	unsigned fragments = 0;
-	unsigned long long period = get_cycles();
+	ktime_t period = ktime_get();
 
 	/* initialize buddy from bitmap which is aggregation
 	 * of on-disk bitmap and preallocations */
@@ -1328,7 +1328,7 @@ void ext4_mb_generate_buddy(struct super
 
 	clear_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
 
-	period = get_cycles() - period;
+	period = ktime_get() - period;
 	atomic_inc(&sbi->s_mb_buddies_generated);
 	atomic64_add(period, &sbi->s_mb_generation_time);
 }


