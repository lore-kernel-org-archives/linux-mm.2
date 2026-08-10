Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B35C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CA76B008A; Mon, 10 Aug 2026 06:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DD56B008C; Mon, 10 Aug 2026 06:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022BC6B0092; Mon, 10 Aug 2026 06:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D62AB6B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:01:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3631406D9
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:01:07 +0000 (UTC)
X-FDA: 85084916574.01.F86D7CD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 09595160012
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:01:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="dwjz6/dr";
	spf=pass (imf08.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786356066;
	b=y3cbrMoWGJAtGxRxbrw53Pd6WYRafOc6x/ZrT6wNk/MESO1PD5j0FMaMRFPCGxnYNKyMp7
	WXhrB0uQ1DRN4wvy4sDLmuZpcmx6f3iOpi/ltIBm4AmgAbIzjlN7WN0fDhw5DSonkn2BGi
	9+Tuuh3K+a41XC+uW1t3/Xt8Yc3N9C4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="dwjz6/dr";
	spf=pass (imf08.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786356066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/3olvZ9OU5OtT3hTQR+ZrKkdBFXH3u9o+ZOdpAud8s=;
	b=pzAgA0FZdcF9tecU0yr4BnvjjUa9l+YvS9p5UCiGpg2ddsxtZbHVAQMyucZwuBCOTinDzd
	/lDU64wHNMI0ZEHqcRj037E6JdQIhoBq1l47VznyzJfPDvRX8ZW3f8L0zhS5Oi6SL8wS7S
	Y6ssLu8nE8iyKMdasOPiL1njGb6VDPk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=X/3olvZ9OU5OtT3hTQR+ZrKkdBFXH3u9o+ZOdpAud8s=; b=dwjz6/drwiKj8uRgpsTyHLTebJ
	Ut24XTdsgtrQ9SRHOWJ9ZtiG63PMR/JHgRn+SBSTbEBf7UrUnYKYFya7VKq0Y3Uy5XK3xOxAU8PE+
	dCNZptpIHT4X53HzWDKk/cqY8k6Vp+9HbS2CvN0sh/U8LPYlBEZ0VOqhegHn3LjWP4k3wRmB3oGd+
	mRfanpKdH6jdb6/9zGdc2RHgXVRiak2wADtbef2i3O68I3Gm/JzPVJEQBouwqMU9Oe09ixKlVZ8nr
	UYrhadHJ2Gb/+6R3KM3PZGQe29VkL8vFFPzIh1KM8cmsYPcWX42QF2QWTC7XKlPbnu40VDjyMvqWT
	cFIeuaXA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wtMoW-002fXZ-1C;
	Mon, 10 Aug 2026 10:01:00 +0000
Date: Mon, 10 Aug 2026 03:00:56 -0700
From: Breno Leitao <leitao@debian.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <anmhBp_hmvSsLqEa@gmail.com>
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
 <amCT9QEgJRsLIb_y@gmail.com>
 <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
 <amM1xUOhcpGpqIpe@gmail.com>
 <39c90e82-f785-4b47-9571-dd4b1339d685@paulmck-laptop>
 <amdWVTs0WKOxguxP@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amdWVTs0WKOxguxP@gmail.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 09595160012
X-Stat-Signature: z6qbeosr1g7bxgb3wghreow3qme7u93e
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786356065-87060
X-HE-Meta: U2FsdGVkX1/HXTismlCqPq/rggNFXGQeuZgcgzRZgI7/L2w9XpmSpI3wdqDNqAQnB9DLXD4GPg5PHOau6Om1mAP5os6MWtOwv4Zm95N6n1f9NLyfAoMrC2WcM3HBycNdZUvuh5O76Du6p+TdwLDpkaJOzRAI0MfjbzDmZCa/RBb7em2bbnbGFflQbMnD5nfx8KMj7isQ06hLVJn/1HU+g6/c6Z9T1+uWl0V8W0hektLeaU9J6dNOBQW4eNnMOvXTEcscZam6xZ7Sd/gc9q4f3P32FcHk2div3aD1hjOYUWvmR+sbdqBhS35auZ0Dos/E1xV9BJ6g0ser3Vilx6zxHkNgF3QTiBxlsNWtJLvBsH4Z5E43n521qDiSjRLKKUf/cmNdxVxfj687A0J68MkNZzRZTa4NMvhdrJyvnRikznGjhs/CV/xZphWaSJQQ8BSaRloyQKxy8dFzDJFIg3EofNl9I+T6O/7QZauGOPwBNxuTzdlImcG71Tk6ff6cZraVZe6C2xnRbxsOwdachLyWmZs1UsfXpo3bkSC43IcovE4H9E/NW/XefkWve4B5l5JKcUYI40OXAMQdSPfIVhHdytrBBiuTgWShIRxtkotevPUSVlXPouXBV0EcWYvYkVc0GJSQR6VJgMgavXLZjobEg/VDOS5WO3FfSGXQOEsjjdLBl9hF3dbop3FtHxgyRx9ioSaWUc8t3LWOt5DxymamfbjDIxdY8WrOZ8ek2qyWu8rliYGnQGdbW83M01gMvEVRWFND+TJUiAfSpL9ltsa6H2dnXhoNaIuYmnaAHNM96OxQK5zwSoqtbIop4gfG/Z/IqZZpMK4aJ7MteOG1B2YUdUL7/QxysM9DF07aRWGE44CO6OCvQlqX1dL06EFTC7y6vOVR5lfwOK+m1I+rnyT7c2lhKnIJGiz6hmX7TDUlMiHkYk48HPmDNMLyLtaoec1kDqOQDMGR2TmHn5NhmNp
 7H92m5Nu
 +ikDK10Y/CtfBTGUV/+dGIoTyWbRkF4nMVc7GE29grGmPR1aRrmTZB4jdYBEph4VXWrUfyAUg3083rLV2p4afo3xkThHKLOUVgP181UF/EXKa4h5d3G8l1VeKyJpP3tnFO17DhDh3IF1rQVDDydNC+VzAYYsANKLPTLHF7EP24uSc8z3A2alCThuzlYWmxmgnuYtqFjbxT+7IbvIse6WWK47fqeHsYyj9115Dj8o7kWgeeZ3RlY5cpmb6KXI8t1R6CWStdUd2NBwc9H6xuggfR0oqHuXBJfVsAlW9dC2kvdm72w14Eshh0dyvhrAHBW4slssRT5R1V4d1xvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 06:04:37AM -0700, Breno Leitao wrote:
> I found 3 different cases on Meta fleet, where rcu task stalls show up:
> 
> 1) kmemleak -> This patch solves it
> 2) KVM / kcompactd
>   * Holdout: kcompactd0 (pid 1216), state:R, nvcsw frozen at
>      716336/716336 across three reports 10 min apart (stuck ≥20 min in
>      one compaction pass)
>   * This is coming from: migrate_pages ->
>     kvm_mmu_notifier_invalidate_range_start ->
> 	   tdp_mmu_next_root -> tdp_mmu_zap_leafs
> 
> 3) Nvidia driver
>   * stuck in nv_procfs_read_lock_params

I've found an additional one:

4) While shrinking in reclaim:

   INFO: rcu_tasks detected stalls on tasks:
	0000000088620d09: .. nvcsw: 6735/6735 holdout: 1 idle_cpu: -1/8
	task:GlobalCPUThread state:R  running task  pid:2552016 tgid:2524552
  Call Trace:
   shrink_lruvec
   mem_cgroup_iter
   shrink_node

I've proposing promoting cond_resched() to cond_resched_tasks_rcu_qs():
https://lore.kernel.org/all/20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org/

