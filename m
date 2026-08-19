Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27EEFC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 13:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246CE6B008A; Wed, 19 Aug 2026 09:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7726B008C; Wed, 19 Aug 2026 09:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D016B0098; Wed, 19 Aug 2026 09:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DED276B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:22:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67C6612059C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:22:33 +0000 (UTC)
X-FDA: 85118083386.09.8063153
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id B73AF80002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:22:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787145751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3M+3DdHPbyDaZ4YNod8MoWdLKJg86jADgYRLiFGyz4A=;
	b=7+c+rXbNXQXmARVOrV5vD3IhSYsloTrLR8Qq2koVlOBk/YCRjBLZAhrnJdQVJr6DsJs+9h
	qLKQPRAfe/X7FP/k/oXtZOWU17zPlrG5BwgiQbn84OCmplLiLZfmzBlICmIB5oySC9gJ/L
	xWItHkB+yLHUB4gFgwPLHdIAFsrJhiw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787145751;
	b=KYlMvSKRRk3atutT1WEczyurwlxWi2CVaGcF7G0G/cHpQnLYSRlP2eGm6pK9N7H8rXJup5
	Pnyg1hk/HWfQs7G5Jh+NZq1ydwcoQ1AdrsibslewK/97gsAyD6ZCmdWZIR66rkCdM+VWUh
	N0Ieu0j6+crm5qbb3ut8hg+SPGp6IOs=
X-UUID: 011ad8569bd111f19a56ed5b684f684d-20260819
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d9e7c4d5-9b1d-4595-9b93-d731a7ebd762,IP:0,U
	RL:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:11e6ee3dfcb512015faf57493ec09a9a,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|123|136|850|865|898,TC:nil,Content:0|
	15|50,EDM:2|44|-100,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_EDM_RNO,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 011ad8569bd111f19a56ed5b684f684d-20260819
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 982613573; Wed, 19 Aug 2026 21:22:19 +0800
From: liuqiqi@kylinos.cn
To: joshua.hahnjy@gmail.com
Cc: Qiqi Liu <liuqiqi@kylinos.cn>,
	mhocko@suse.com,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory accounting and control
Date: Wed, 19 Aug 2026 21:22:11 +0800
Message-Id: <20260819132211.366064-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260818154954.805958-1-joshua.hahnjy@gmail.com>
References: <20260818154954.805958-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B73AF80002
X-Rspamd-Server: rspam07
X-Stat-Signature: 1z7p5x4gxfdgyznx6qx6mbxrofp7o4rc
X-HE-Tag: 1787145749-545783
X-HE-Meta: U2FsdGVkX18UE0a3kLgGZQS5gL5jWkzP8y/Q582xtog7JAjgpg+YgbROAxx/rX2+Oi2ui0dbKPA2jc8t+P2AENROltXp3uuvvQzb5nibe+AS4ulKSzCd0xIUU6KACbnZk6M2gca0qFBZdUoXqRdM/xX9LLfLhNirH0g7IC46VLPMLtRYd4uSPHPPOPpzPtmAj7LutkC6vS9MJ+3fry+9FG0Jh4zHXSQL2Y2rWiZTJxuZjaIyLek9ZfrHjCzXfeW4H4ggbduZl5YMXKFXkZcqI/9LKi0VN45aBEkCekdsdx62ZrfiJfdaufhRTeS+63ypO5cYce2BJxQwZXLVb+WLkSjbKgzb50Yg+keN/ZWybXtR0xZ0DcnuvVS6liEVSRJHwysSL9lTPiccJfsDpthv92SwHGYIBy9sgw45sJXmP43jaeeXiwEdcrcn+QcFhApNB7NssBaA3z12nBjALJAC7fg0NKbmsGiJ03YMPPByjct8f0TkBsXGxcSGV8o0b+z7mhaj9/yGwmqNyEcArf8RbIdfMsYIkKWpoG4+DCafzdjXOXkc91SlCyMcqE947l/+OY7SFq/hNZ1EShRIi7fy+RAcQcySuuCjykRIAPHcN8q9O+V776fBZl7xzftCAf6niHs97DovosPdGQIimtrTik5hJKTmDu/eur1rY9EArH3cawW15eDoBqUPzqhcrQKE5ASh07jZve+arx90867yYawU1iJ8FaTO1OFPvAVs+mLNVNnweuWv2UEeO/kAcMUI/qd3AAXpsYrRuDnJu6d4KL7FcFqyDfCT/ENQV8CXkc3mDNsPD/GQyvjTlZZ5bSXzXS8ks0asa4CMH4Q9HNbiA2sJKOan8iDhseNdHYwLLducIMyyk/5llDzkRBLhhiwL6wl/9Agg2VJ0m+gRkzbim9UfOkyYurTHrjCPWP6IYCHHgWJ2J3BFEjFep68QfMnWCc8aUNBGFwXLjfsOW9c
 mx5IMmEl
 Ic2b+U6qB9RogTxen4OE60IsNxZI2xYrigyJVOGhnEvgFyVdCHZwDrP1xbe5/1rwNvYrAtKiiNlccr3fwb88Zun7C2QaA+ZuJuWYO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiqi Liu <liuqiqi@kylinos.cn>

Hi all,

Thank you all for your replies. I am not very familiar with the
community's workflow and should have reviewed the mailing list
archives and existing implementations more carefully. I sincerely
apologize for any inconvenience this may have caused.

My work is based on
https://lore.kernel.org/all/20260528134212.240492-1-liuqiqi@kylinos.cn/
aiming to develop memory tiering limits for cgroups. During
development, I referenced Joshua's v2, but failed to notice that
v3 had already been posted when I submitted my series.

I have studied Joshua's v3, and our core mechanisms are largely
consistent. However, there are two differences:

1. Read/write per-tier interface (memory.tier): each cgroup
   tracks its memory usage by tier (e.g., DRAM, CXL), exposed
   via a new memory.tier control file. This file reports
   per-tier usage and accepts per-tier high (soft limit) and
   max (hard limit) settings. By default, these limits are
   automatically derived from memory.high/max based on each
   tier's capacity ratio, but manual overrides are supported,
   allowing administrators to constrain specific tiers on a
   per-cgroup basis.

   Its advantages are:
   - It can express allocations that fixed capacity ratios
     cannot.
   - Latency-sensitive tenants can be given a larger share of
     the fast tier.
   - High-capacity tenants can have their soft limits removed
     for the slow tier.

   Whether or not to constrain a specific tier should be a
   decision made by the administrator on a per-cgroup basis.
   This serves as an answer to Michal's earlier question in
   the thread regarding "do you intend to limit memory
   consumption on particular tier even without an external
   pressure?"

2. Per-tier stock: I have implemented and tested per-tier
   stock -- it batches atomic operations on tier counters from
   per-page to every 32 pages. Joshua's patch (moving the stock
   down to the page_counter level) takes a more generic
   approach, and I believe we should continue with his
   direction here.

Memory hardware is becoming increasingly diverse (DRAM, CXL,
and further remote tiers), and the performance gaps between
tiers are significant. Different workloads have different
requirements -- some demand low latency, while others need
capacity. When the fast tier cannot accommodate the working
sets of all workloads, it should be the administrator's
scheduling decision to determine fast-tier allocations. I
believe tier-aware control is a direction worth pursuing, and
the differences above are where we can contribute.

As Shakeel suggested, and given that Joshua's v3 already
contains the core mechanism, I am dropping my current
standalone patchset. I would like to ask if Joshua would be
willing to collaborate with me on this, treating memory.tier
as an extension to the patch series and proposing it as
follow-up patches based on v3.

PS: I have already subscribed to the mailing list to avoid
such misunderstandings in the future.

Best regards,
Qiqi Liu


