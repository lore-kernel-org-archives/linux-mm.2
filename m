Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6BEC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 19:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244636B0096; Fri, 28 Aug 2026 15:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B146B0098; Fri, 28 Aug 2026 15:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 158ED6B0099; Fri, 28 Aug 2026 15:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9C576B0096
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:17:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7724FC0531
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:17:13 +0000 (UTC)
X-FDA: 85151636346.20.A14F04F
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf17.hostedemail.com (Postfix) with ESMTP id A2C8D4000F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:17:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787944631;
	b=NEvGFTQLk4ML5WdIrxagzYkPW1xcmn1Je++ntdrm1E9ExgIQvvMZ79C0QrS4g8a72FXfe3
	0DNH6aiW4wN6P9Lu9m/AHe0J3xNAzRGqMffUUPI1fC3YaFDjqMSbu2O/4vGWrVpwGHCPFN
	eteo4hEQ62GaiZuGeEdthl3z2APOKfg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787944631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0RDwr71FlsrAMrAAlqln64IM9QGsxwXWA77DtZDfZwQ=;
	b=WFf4KCXfwmI1DTvYTOIzwS+fwJ+1ma343ofonBNCCNaOORmCymRu14LO+jKy9k9R40Trqn
	RjD3BJqeDxllcj04rp/surVvRJ5JRIUivfHUVdqyAG4NHtWpSWRGBT5jClq0Xe7stNw2m5
	0OLjM61tFL4KZqCyvl2ynjDh8xEUF4s=
Received: from omf05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C52951A053F;
	Fri, 28 Aug 2026 19:17:06 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id C3E9F20011;
	Fri, 28 Aug 2026 19:16:57 +0000 (UTC)
Date: Fri, 28 Aug 2026 15:17:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, David Stevens
 <stevensd@google.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin"
 <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin Schneider
 <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, Uladzislau
 Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook
 <kees@kernel.org>, Clark Williams <clrkwllms@kernel.org>,
 suleiman@google.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260828151747.20035d50@gandalf.local.home>
In-Reply-To: <20260828151313.5c4a5e4b@gandalf.local.home>
References: <20260827232948.2520558-1-stevensd@google.com>
	<20260827232948.2520558-7-stevensd@google.com>
	<20260828133620._x2XfJR_@linutronix.de>
	<20260828135947.GU776954@noisy.programming.kicks-ass.net>
	<20260828151018.HnR9xV1N@linutronix.de>
	<20260828150836.2d5b378c@gandalf.local.home>
	<20260828151313.5c4a5e4b@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/FRCRqi3s+JC4roW7NUQua3g10tn9P4XM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=0RDwr71FlsrAMrAAlqln64IM9QGsxwXWA77DtZDfZwQ=; b=gAZTVjGDveN8fhsH4aJV2blL0f0S/QpEEvr3BQpYaHupiEQdLMD69nFOfdLEk1spL0/g6lXtTnfNyIqHZGTSM2GCgE4DvzYvzij8bAWlZRrSpkm67+yI+NJTg387b0JmME/jtx2tEqWIUYUrCD2W7DFVoX4NatssuHtJiesq2nE=
X-HE-Meta: U2FsdGVkX1+ViF3OvOgaM5ssQLR7tn0uySWJaFHYtcXWZ21cz7nnxMRW6iHpDWrp6Htrs0cIkgW4SbBQGFpZUf1ROkYnZEWGOtcWKXjDukDAh5xQHzSUkPxJbyaumnTpSqP3YXkkCipkNohafMlloaOqbdI5ACVjC77j7iGbrpU8lCltcFJhtONUqXBCJpw9eTajIr0/aLHn6NisdoeErwIxVK/oB2Np5iYGqcWQEGRVIxOt9i1N8E1VkhWj8uFuSoYqfpNN0eEmhPs7aE8vmz2WPbGl+v4Ry92BAG7LkkOQAqWIZjLFKEu432FqDcWspoc2zzLFnstcV5vVdG65ka7IObsOxeMhd+5KlkygWN4xwraefOr4pQuVKgzS9Rrd
X-Rspam-User: 
X-Stat-Signature: j65tfsnn7wb96ijjjfomjeapo6aro4m7
X-HE-Tag-Orig: 1787944617-357454
X-Rspamd-Queue-Id: A2C8D4000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1787944631-539276
X-HE-Meta: U2FsdGVkX18Cm8T5/tzLKsDZileIfLExKXZvW19h4/eTVbTpopOzDWbiZot4k7qT6N7wug1ZzPMQV7mzmUNBL1GJ8BSEuTL5QwjZHOXDFCp3CU6/vyjx+Kc54wJoE1eZ53GGwpZ+HdehVgsspS19OescnIYwtq4Zq9lyQI2QVfxzspvLbvn/xbn5aj+Qx3/oxoyD3CYyyPhaywSER9IqG/I61xJ0qUZUeT8xvhKbaVuVSLZe8212JJY+HHJnsw1Ev1EbKVs82ghpUdzRI8hGVoqQ0r1br9Sg0k3gcmue9w4nuklui4tj7ZM17qTJTYFFLoUJUG3HIYKCGN1DO4/JTmDViCGQox7/JXZ4sWyk8O4HR99a/4shagedXu6ZicBb1W2qgEVVW9TvQgrrH0O2oc0ThssClkZlWo7OnD06MV9sML9i7kBLYZQoy1Ibqn9dwpDhVPFeErY6eeJvl+dZQi9K0kKLx/dUO58xrw/h8u+eiuGtBY1I7zE1HSa/K8une8JricNunqsZrzQQWk0PPoIORowLLu5LAJtCUAMk7t8u6HCJ9/nsXwpQNrpL2IfCQH0LdEatet0SMOvN09IgFylKqBoZpnO54HmS3B7pBmIiEUozItiOm+8WoHbhesYCkN0X8pgoPeSmFesQB00Eh56KQeid0arTa3kUNtdNqvodsERon67FB+CFQGY7h+ZPxRDmpw85iTClDZk8Kv8S3KCHp8YmFTbeExRosi+ifL0pFal2FCcy+xZH8AomnLTBQ/beIPs1mr2jh5K2k2Y2i0hNjrWeloQqc1CkmEjwVUF9GMnG55+eODft7RR0mcIEWDqin2HxxK/qs+jzZ/bz4C3PG9ZxoeMoRYa2Zf3Eavyquygk0nThF1LncisdG0WcDh78h1HZeDe/AwASJ/iR6T8ZhXFRnyvIrsDbS1IbKCnP573HPuMnmYstTLWZXdRgMaIcg7aLf7IKeiWogLQ
 xj8SuvQ0
 c4WEeDiYTAX1p6mRDoPB49gadblpE19P90GlwCdTXRpiUHzkx/Vo9OcfYtafHfYdvzr5R18Ract7Mcu4E2AVNLdsADiJU1APXfyc5seIsN6jF3k0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 15:13:13 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> If one worries about stack size, they may want to turn off
> CONFIG_RANDOMIZE_KSTACK_OFFSET as I see some big numbers for do_syscall_64()

And the scheduler has some heavy stack usage here!

  # trace-cmd stack
(stack tracer running)
        Depth    Size   Location    (31 entries)
        -----    ----   --------
  0)     8120      48   __msecs_to_jiffies+0x9/0x30
  1)     8072     104   update_group_capacity+0x94/0x960
  2)     7968     528   update_sd_lb_stats.constprop.0+0x426/0x39b0
  3)     7440     424   sched_balance_find_src_group+0x8f/0x1150
  4)     7016     552   sched_balance_rq+0x934/0x4130
  5)     6464     408   pick_task_fair+0xa71/0x1fe0
  6)     6056     496   __schedule+0x628/0x76f0
  7)     5560      32   schedule+0xde/0x2c0
  8)     5528      32   io_schedule+0x8c/0x100
  9)     5496     256   rq_qos_wait+0x12b/0x230
 10)     5240     136   wbt_wait+0x150/0x260
 11)     5104      40   __rq_qos_throttle+0x51/0xa0
 12)     5064     304   blk_mq_submit_bio+0xc40/0x28e0
 13)     4760     240   submit_bio_noacct_nocheck+0x410/0xb30
 14)     4520      40   ext4_io_submit+0xca/0x1a0
 15)     4480     144   ext4_bio_write_folio+0x5e2/0x1470
 16)     4336      96   mpage_process_page_bufs+0x392/0x700
 17)     4240     616   mpage_prepare_extent_to_map+0xaae/0x1120
 18)     3624     480   ext4_do_writepages+0x971/0x37f0
 19)     3144     312   ext4_writepages+0x2d2/0x610
 20)     2832     152   do_writepages+0x21e/0x560
 21)     2680     184   __writeback_single_inode+0x119/0x1240
 22)     2496     752   writeback_sb_inodes+0x67d/0x17b0
 23)     1744     168   __writeback_inodes_wb+0xf2/0x270
 24)     1576     304   wb_writeback+0x63e/0x890
 25)     1272     320   wb_workfn+0x844/0xca0
 26)      952     360   process_one_work+0x8b4/0x15d0
 27)      592     176   worker_thread+0x5d3/0xfb0
 28)      416      64   kthread+0x33c/0x420
 29)      352     160   ret_from_fork+0x65c/0x9e0
 30)      192     192   ret_from_fork_asm+0x1a/0x30

Note, I'm running this on my server. That is, this is a production machine.

-- Steve

