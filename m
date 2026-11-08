Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28545606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 06:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340226B05B0; Sun,  8 Nov 2026 01:27:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F27F6B05B1; Sun,  8 Nov 2026 01:27:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207EE6B05B2; Sun,  8 Nov 2026 01:27:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3B466B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 01:27:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7972E1C3C56
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:27:28 +0000 (UTC)
X-FDA: 85410970176.05.91995B8
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id D301620003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:27:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf13.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794119246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pSY+VxPFlCMt//V68AJbYH6L3nbsVs9zToOlbvaVAWQ=;
	b=HF7YGqf9hSoLdnOZe5B6H38DE5aRBT5qK86FY+ns2vwp3rrkwS1lx9XJrbnejuaqDvKqXT
	gB5Y3GgnEgv+rsmIAd/vV3RRhJUYThmJI0zE2UVzbCP8+d4UjB4FhKI5xPy7FHnXd7av8b
	DDuUL+bYh1azvl8ZrpXmzpDLK5IB5BE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794119246;
	b=TG0M+SNzoVylbdYX/Z7qBsJ88DDBVDA/BI1TTmikXdaxnxj5OvOPZRDbdD9yFKOoNFITb2
	a2RU0DeAHHK26DgU1mj6lON8ani7rmoUx8vVKJ5y49WiVyDAHzcj/wgv+VykF92+EZV3hg
	GFWvsKNTIAqzXJ0lUJ4ckzKSt11dg8o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf13.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jMjd60Y6sz5BNS0;
	Sun, 08 Nov 2026 14:27:22 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6A86RF1u056768;
	Sun, 8 Nov 2026 14:27:15 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 8 Nov 2026 14:27:17 +0800 (CST)
X-Zmail-TransId: 2af96af016453fa-26b09
X-Mailer: Zmail v1.0
Message-ID: <20261108142717400jIBOCPqLH4K8NFVss_YdS@zte.com.cn>
In-Reply-To: <bc095bd8-ee9f-4bab-8333-8f2333b2590a@kernel.org>
References: 20261107213856462Jx8pIdgdtLvPLfOFTwV4X@zte.com.cn,DMP795RB75PQ.1XIZ1QUJ51Y0H@nvidia.com,bc095bd8-ee9f-4bab-8333-8f2333b2590a@kernel.org
Date: Sun, 8 Nov 2026 14:27:17 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <linux-mm@kvack.org>, <ziy@nvidia.com>,
        <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
        <byungchul@sk.com>, <gourry@gourry.net>,
        <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vbWlncmF0ZTogZml4IHNvZnRsb2NrdXAgaW4gZG9fcGFnZXNfbW92ZSgpIHdpdGggaHVnZSBwYWdlIGFycmF5cw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A86RF1u056768
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 08 Nov 2026 14:27:22 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF0164A.000/4jMjd60Y6sz5BNS0
X-Stat-Signature: 5wf7e7q8r1guuwany6zuqkcmq4h1qtuo
X-Rspamd-Queue-Id: D301620003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794119245-966
X-HE-Meta: U2FsdGVkX19ZXbPkzNZz8TApWsY809c1sCtqpfxLY04NUuKUrtLs2pRWbVfLHsTo6ou4VQnx68sh2pw5hEs/T3Q42OemOLegedVSaxMmYmsUWWGGcv4qdAuAnyLMFBkVBxhyGdUORjaTdZML80k5UqaI1IRcnIALb1/REgWjPiF0/g/T1n5crj2wjpIyryfI6nCYIy9+HXwym28dKZCTMiGcSnKS/WBNcB6Ahvh6sxAt2HA00U+Mxwr7GHqtb9df1mK7r79fdkn3IvYPvM7DILNnPRn36BFzHsODgkq3nIs0nQJXLfaXkzkIovcdLlMpkZZCSnoGazsaBt1A9Sl5rEiSsf7qxuzTPjudHkmElE6PjVKOpKN8h6GKBeAXIAnV1gxmD+IGwR6EBotKGn5ImcJ0i+6bgGrF8h/5V7immTJSmIOrfChg3nwQv9pjO+6s8LooH/+8Bo3lBzaIKcuwxyVKGixH4eHpepuEu5V+ULwRdaGuDTfcNIM/mvBZZRP+scW6ra2prq6M3ofgbEwKAnZFv4TbgWd/KgHn64cV9sFv4oAgvpHE/arC8lZjiFW6RqrWdwOyli3vpthhBbqqJjo1UyE5grPBRmQNaJkKYwxXWPemFClNw/Xugw/O8++Yy5c+kdTsXdb84rfAzjGUvrUYxu5DxqILHYubpnL+3IUMUGmydZ+lAzZ5rwa/RARSZNxZtPjzQX9BqU34Z/EPojx+a87W1neWO1XTu9o/IIaZ2nhQnkIf8Xrn1qFqu6+9WydRlOFOyP47VHVW0mC3oRtbmNQtNR32WwEBGbHrd2QWZzq3BL2hrzK0sD9ZW9YmL81zdxJ+dKFEleVa16qVE9rNZfy7quUFv5GDC28acuQ7J+wE1PKz0LR/4RCrOnYrpQh0D+2+9lAK6iv2+EdJfZKSQg/1VGb+0vmOTqkHiLFVJOl3eSK2FXyaxgEvRmphTf5cbE+p2lXM3dF7uoQ
 1EqicoV1
 Ut5jCeBg9xv1Vuk5zyvlxk28HZ/qxoPGbwikhWNPEXouqn4js0HbpYLoeSr8hWOrWYnWyjtPfvKSyzsRLMaW66idBxLdvxiOgAkyOs+T9KPmJLIyG6WOSlNYNRpXr3F3Nyp/dqMqCTPjrZ7zlYnsyTuEQLism9dB3bUgibRvy0oVF0Ce5YEI4j+GnU5i37xpqeGmrkz4ZQtk/+ujgsqoT4j0Rlmn2e8m9CSDdfz2qVcynNGadhePE11JvfW8Pjo1XBZGS+EQDdX5zRtPsXGkNbGcXnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 08:11:22PM +0100, David Hildenbrand wrote:
> Right, and I'd like to see an actual reproducer, because we sure have a bunch of
> cond_resched() already in migration code.

The existing cond_resched() calls are in migrate_hugetlbs(),
migrate_folios_move() and migrate_pages_batch().  All three only run when the
pagelist is non-empty, i.e. after add_folio_for_migration() has isolated a
folio.  For an array of addresses that are already on the target node,
add_folio_for_migration() returns 0, the folio is never queued, and
move_pages_and_store_status() returns at its list_empty() check.  The loop
body (two get_user(), mmap_read_lock()/unlock(), folio walk, put_user())
therefore runs without a voluntary preemption point on PREEMPT_NONE.

I reproduced it on 6.6.60, x86_64, CONFIG_PREEMPT_NONE=y, CONFIG_NUMA=y,
under QEMU TCG (no KVM, 2 vCPUs, 3 GiB; I do not have a bare-metal
machine that can still select PREEMPT_NONE).  move_pages() with 50 million
entries pointing at one page, all already on node 0, keeps CPU#1 in
kernel_move_pages() for 42.9 s and trips the watchdog:

  watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [init:1]
  RIP: 0010:kernel_move_pages+0x424/0x820
  Call Trace:
   <IRQ>
   ? watchdog_timer_fn+0x1ad/0x210
   </IRQ>
   <TASK>
   ? kernel_move_pages+0x424/0x820
   __x64_sys_move_pages+0x24/0x30
   entry_SYSCALL_64_after_hwframe+0x78/0xe2

(do_pages_move() is inlined into kernel_move_pages() in this build; it is
followed by an rcu_sched self-detected stall on the same CPU.)

With this patch applied to the same tree and the same initramfs, the same
50M-entry call completes in 44.3 s with no softlockup and no RCU stall
(ret=0, all status entries 0).

The 10M figure in the v1 changelog is from the do_pages_stat() report (6.6-based
arm64 with KASAN and function tracing).  Without that instrumentation this
TCG guest needs about 50M entries to stay in the loop for 20 s; 10M finishes
in 8.5 s here.  Same code path, only the machine speed and instrumentation
differ.

I will send a v2 that only describes this reproduction in the changelog and
keeps the code as is, the same treatment 8e934ab44389 got for do_pages_stat().
If you would rather not carry this in mm at all, say so and I will withdraw
it; a stable-only submission would also fit the reachability.

Thanks,
Shao

