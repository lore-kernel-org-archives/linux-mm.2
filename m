Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D51C624D9
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3A756B008C; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC39F6B0095; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3426B0096; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 886456B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 209D0A306B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:05 +0000 (UTC)
X-FDA: 85168872810.07.2E07EED
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3CDAC14000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="mw4c/0xt";
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysZbMcSHTTzwuIanrUUU6kasifEXs9ieZAuSRi3i5b8=;
	b=cvEeGpUUmM7MfMmT7DswL3lwSaBEJYA8tpr+twn5frCw15bQgdsnaGx/0IRmrd+R9VCcVz
	zUL1sGAnCIVHf1bwTMEjwWOMUCzwcO9vFbF1Kghgh8ag9XykN0SbjmA4sE9vFydboBKy6u
	Iell75VcAxscFJWuTY5JyBU7Krm8h7E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="mw4c/0xt";
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355023;
	b=pbBgOVJWkOhbU8M+IMpXEbtykaX8VX/5T8hTwMZCHlJNaLsT79ZN/EoEnWtOc5F9CHgZd3
	HJq8g9UefjI8ksIh9vFI0wWBLU9PqbXqY0/HIM21Pm7tdW5cAIpwU8cwIAZoNuY9/Z0vGh
	pCVYSsjP1XOwPgb62DoTm+G8eEaMvyY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ysZbMcSHTTzwuIanrUUU6kasifEXs9ieZAuSRi3i5b8=;
	b=mw4c/0xtanmWd0QxLrju3Xztcdo7XZF0X2hkxOoQgxfwaKUn6tAlOoKJkZUSwlRvdVMwiRtSF
	RrVNqdP5C9qZVKF3UgdGBuF0ZuabhGmBs+LBxg+fDrrWYFvP6qlNNHw5F5HsWYSaf3FlLv7uepA
	C97OE8HihM640DhopBVYge8=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hZjdb5PRKz12LGW;
	Wed,  2 Sep 2026 21:05:39 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id ECAED40579;
	Wed,  2 Sep 2026 21:16:55 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 2 Sep
 2026 21:16:55 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 1/4] xfs: remove dead kswapd flag inheritance from btree split worker
Date: Wed, 2 Sep 2026 21:16:50 +0800
Message-ID: <20260902131653.1338227-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Stat-Signature: iizqa3oiw3m5gf4qj4hge949qkr8f9dt
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3CDAC14000C
X-Rspam-User: 
X-HE-Tag: 1788355022-109264
X-HE-Meta: U2FsdGVkX18zvJTSPrpsWnLiFgcLQpuH+NbmmXwMBshkuVaQn+KsOEp9qRwBaZWFvpgbL/e7jXTkbHWbsqgkSPr7KZTF3WmWp8u/D5FBkXkfMU0hIpRLivPv7ZtDVROblKkcaOGN8mLORsfHvyHNksgn/BJYMBE+lStM58pnHhktw5JPuGR9N8b5NT/U3KGdtV9kCG1aBpe8a+AAz2DY22UJL1vg4plizcEPaF+coJMxEaQT1rzZmUtcfISsi+DsG74mApCW/3MJ3Tk96TFe/ZzyG9pxgMp3KtLzToZ7hokAOsuimoVgUlmKrPLoP98RRqxhywwJOqvg4E9V0ogUKWMiykowRcwl6jGcJEehkmN6Es6Ysboiha7e2sONPh2+B7oJ5650+UJDLBFcQGU6jRvK3lTp8xp1nHQ8VzOYt15WvVtKBRAuUOq9YKWJaBoHEcSUom30Iz7CrlotsbVVkAX9H+W/QO0PkMlq7bASnkutVi+KKX1nSkacctsi3lnI5Sy11WMoAClaTB2L843x/kg9jCbhMujsjlUE6IjH6M5Qf9IU7t5dOuUEpqYOskv9Gn9yCu1fjGkqwh5QE/rErca8ztcV2DadZGIZ7uETrNtoynsz4/dnEBsB2WWE0kv61zOqfsjfNPoQWfE9PdEUiKXgkPJA6xWsEHhtHd9+YiL1CaLwmz1RuBaePH5tcslrvZSH42vaI3iE0nb5T5R7xyzNBcqamOwFlTb2GQXITpQhcS0FChr4kmIb3WIe9R0VQw7MY7CB4gcFXrpM2zbAeQrTefac+5xNNKFxN6eKEG+r1MhUCZc1GBsywBJSNzRVFFzJcZylNffPPhXxlVgdCzu4w2I3HhYN8HMLi9ti28j64iKwMHAQvoTo+6jgyw7m19nnIR4+q1jcr3mdfszziQ+iDmKsNIVLjHBkERDX+Ud+9kDPoONrB576Rp8JTVniwgJjpkP5oPXxTIu/wFt
 1YfDgnOV
 rmoe2sCEWRsXhQHi3faG3sZpAapUSQsRzvRbhFknIJdOJirujxdWKhL91/x62a6x22gt8XqCTszLwCwoV8O793YmMoQaOcnK4BbO8cs6M1r3BRRFWzsPDTfFQsOMj2IXQSkUj0DkFIcIts1pUctpnuTCI7yYBO/GFiN5/I7KOFDl+eo/BtL+3foOJIUJmBMpNAgvfH2L+V7kJ1ptIdpS1pmhjFWgdIQZMNfI+Bhu6ak6aEaR7xeEBSXh50jE10IMNQjQz52QjjEeJO1iH4akT61vzg2QmJZ08xIjUIxay3Mm2Vm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1f6d64829db7 ("xfs: block allocation work needs to be kswapd
aware") added PF_MEMALLOC | PF_KSWAPD inheritance to
xfs_btree_split_worker() so that block allocation offloaded from
kswapd to a workqueue thread could access emergency memory reserves
and avoid reclaim throttling.

pageout() no longer calls ->writepage() for filesystem folios -- it
returns PAGE_ACTIVATE for non-shmem, non-anon pages.  kswapd therefore
never enters XFS writeback and cannot reach btree split.  The only
path that offloads btree splits is unwritten extent conversion at IO
completion (xfs_end_io -> xfs_iomap_write_unwritten), which runs in
a workqueue context where current_is_kswapd() is always false.

Let's remove the dead kswapd flag and related codes.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 fs/xfs/libxfs/xfs_btree.c | 18 +-----------------
 fs/xfs/xfs_platform.h     |  4 ----
 2 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 60ef7f08b1d3..6738d9d1511b 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2994,7 +2994,6 @@ struct xfs_btree_split_args {
 	struct xfs_btree_cur	**curp;
 	int			*stat;		/* success/failure */
 	int			result;
-	bool			kswapd;	/* allocation in kswapd context */
 	struct completion	*done;
 	struct work_struct	work;
 };
@@ -3008,33 +3007,18 @@ xfs_btree_split_worker(
 {
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
-	unsigned long		pflags;
-	unsigned long		new_pflags = 0;
-
-	/*
-	 * we are in a transaction context here, but may also be doing work
-	 * in kswapd context, and hence we may need to inherit that state
-	 * temporarily to ensure that we don't block waiting for memory reclaim
-	 * in any way.
-	 */
-	if (args->kswapd)
-		new_pflags |= PF_MEMALLOC | PF_KSWAPD;
-
-	current_set_flags_nested(&pflags, new_pflags);
 	xfs_trans_set_context(args->cur->bc_tp);
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
 
 	xfs_trans_clear_context(args->cur->bc_tp);
-	current_restore_flags_nested(&pflags, new_pflags);
 
 	/*
 	 * Do not access args after complete() has run here. We don't own args
 	 * and the owner may run and free args before we return here.
 	 */
 	complete(args->done);
-
 }
 
 /*
@@ -3078,7 +3062,7 @@ xfs_btree_split(
 	args.curp = curp;
 	args.stat = stat;
 	args.done = &done;
-	args.kswapd = current_is_kswapd();
+
 	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
 	queue_work(xfs_alloc_wq, &args.work);
 	wait_for_completion(&done);
diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index 5d542e95fe44..a49fa159894d 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -115,10 +115,6 @@ typedef __u32			xfs_nlink_t;
 #define xfs_blockgc_secs	xfs_params.blockgc_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
-#define current_set_flags_nested(sp, f)		\
-		(*(sp) = current->flags, current->flags |= (f))
-#define current_restore_flags_nested(sp, f)	\
-		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
 
 #define NBBY		8		/* number of bits per byte */
 
-- 
2.55.0


