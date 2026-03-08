Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A919DF55102
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 11:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E12C6B0089; Sun,  8 Mar 2026 07:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B846B008A; Sun,  8 Mar 2026 07:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B88D6B008C; Sun,  8 Mar 2026 07:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F09996B0089
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 07:04:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A34E4C35AF
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 11:04:13 +0000 (UTC)
X-FDA: 84522611586.13.95CCAEB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1663440003
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 11:04:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772967852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Er5cat7IeSsScdTn0K/gJbSyeUdZl6C/O0hkcgq7XkI=;
	b=sVhZkPFXeUjj67flzRFuG/cpyWqcpqA6Qqnsjxy4p7s41puDpJR5XRClUwheYwBytotcX/
	vISZXZi9IK9kNF35qLahMEhj//BG0PRnM1ULm1Dx6o8aW/MAP3gBvKgx7RKGdo4GFA+M7u
	+fkv3e9VGxqdbcjoZOAGMTxrF8W5tvY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772967852; a=rsa-sha256;
	cv=none;
	b=8dELpkTOysUCvpuQowtw5ysZinolqhiSPdJmJJa3SrM32YcxwvVQy/+IOHd2/pbCMBGXJo
	r024+tbOxL4s/Isg4VX44TOEcan5pEhqzNmMKYBXAc/Qrk0kkIeGhYlgfAjkf4Nv5sGQtk
	yJplOiZRoCuXfrcLFezKjICIAuQg9V8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFA891570;
	Sun,  8 Mar 2026 04:04:04 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A63E23F836;
	Sun,  8 Mar 2026 04:04:08 -0700 (PDT)
Date: Sun, 8 Mar 2026 11:04:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Qing Wang <wangqing7171@gmail.com>, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, chao@kernel.org, jaegeuk@kernel.org,
	jannh@google.com, linkinjeon@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, pfalcato@suse.de,
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz, Hao Li <hao.li@linux.dev>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <aa1XpnY0TRvDGf4i@arm.com>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
 <20260302034102.3145719-1-wangqing7171@gmail.com>
 <20df8dd1-a32c-489d-8345-085d424a2f12@kernel.org>
 <aaeLT8mnMMj_kPJc@hyeyoo>
 <925a916a-6dfb-48c0-985c-0bdfb96ebd26@kernel.org>
 <aassZV5PjgFx8dSI@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aassZV5PjgFx8dSI@arm.com>
X-Rspamd-Queue-Id: 1663440003
X-Stat-Signature: 7z1bo9typux55b3cpua9krcp15pkree3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772967851-163636
X-HE-Meta: U2FsdGVkX19Pogcj89iExru37rOpqyMhl+mJKZ/1YCPaIrVNS0OiDMU4yzJlR+GEOW7tvsri6Krl1u6Nn4FnXiR9UITRJ2ln41YQJtYUDE1sxi1x4yDL32kVUZbsd4IBMpPNPVcNu0MDmksEQvH1OFoTosf/EktAArAywp7xNDho2nHZaqMUFNWY6DF3CG1naCr+uIrGoWSp+tq64Onyeikxzc1mgzOcWqHQdn3oUVCFMbS2WKQsmH4KJlHQu34lGOjHWK4qXKIdKg43KkgVwnBttFm2GDAliyK4IE4x+PajOTAkTZO9YK4tmxuqm7zj2nchxWIOBe3nfuiNRll2ccCnV5JWlHlXnFkNyEfaIETR9q8LbQ19aJMGdNYC/a8s9W/UTjaUd2fSeMhOpInxMh6nSCnBaEOzBGbAxIrn7Wrnvj9MOojIvjATwTIpq0pfUI0YMHe+ogXMGwRkYnsBIXpd6Kf6gn3N4VtrCgvFmLpqfLJKxQETQYHwEDTOhmVMj/D0dx/1R3kLiJb+zXxa8r1GCh5KtSoIsxkfFVEnIO47B5xtdmEhZm8BPURShXhMyV6R9l9FKwRN/ZEl3Yheelun6nu2QJ7rV8TaVOIABpNr7NqoHhFObRWg4tg/ol6MT/pIsk3O/vfobklRimTvWyVdy4ZKMs0Y4guXsrkTE/HgxqxVlcfty+yxiLpK7miCfr4sFUoEdx/p8tB5ozflHmAoGxZ183OLbzH0lddaoLGTQs9kMl6EUdhIbUK1N1lrxeKjtJLJ5mt7JeL3wikCxRNoUEIDi/pHo2haRp9C+fO7QvRXjMoeEPpAHoZHiA7RroJ6tRYnwbYtVDSkpz5LQWV5n+neq4kRTPiEkc5kTBUPdq0j4GZorZVhV1E7iULKby/w3yjTrCC/2R9dCq3uUwyr+BkRARrQ2QLJriB7YpX1Cfs7OpCxhS/Qp0/aSE7LrNUCyAYtxHQfl2c7cgj
 LKyBgHnZ
 VelCOEioH+KuEoTYpaX9tqmPgJnI2dL2elF9MPOIR8Z2YD1J4QrCg7MoIxXLUAiyxlWPdYzK/uzpcnRL8yTY6SCnAZVf5vH+9hXaSQLeG66/yN5p61R+QHWadNYbdUwZDzhDcIkkM29ywM6iGBLGbwBuFjsFK2z7mb6qfA8t6MMalTaHUyNpxEa/kmQ0u/lTxJxtHHxLs0R+6Vb3bQH7fyPJzebVrkNiNpgp683+CFpuvmO3svyMDd+KymZ8NpHwHEGzh6ZPnTSR1OavhjxNudUrM7Vgx6YqJydA9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..73f4668d870d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1954,8 +1954,14 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr)) {
+		/*
+		 * The object is now queued for deferred freeing via an RCU
+		 * sheaf. Tell kmemleak to ignore it.
+		 */
+		kmemleak_ignore(ptr);
 		return;
+	}
 
 	// Queue the object but don't yet schedule the batch.
 	if (debug_rcu_head_queue(ptr)) {

