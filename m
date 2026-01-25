Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41BB8E63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3BD6B009F; Sun, 25 Jan 2026 17:50:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DFB6B00A3; Sun, 25 Jan 2026 17:50:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C45B6B00C5; Sun, 25 Jan 2026 17:50:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8CAF76B009F
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:50:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 506FCC2060
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:50:07 +0000 (UTC)
X-FDA: 84371980854.02.94B98D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 984EC40005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:50:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=szmnbFCF;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBAU+1vA8rYiXSwMqWR24rkIwYymM7IYjgceDiaW7xQ=;
	b=g/koi4zlNLFLQAU59b1jp6YDgyvfeO9AAT6aqYcND5kbbbPYZRjEobbHDvZqRAp7zr15uD
	daTPZZBijKxcL62t0RX2TLBJ/IVxwfemAIlw954SJPwywDUSvJ5R9lKuFrIY/JCq4mLski
	mrCHkyr+uPatcAddYe28BQXzULhjw9I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=szmnbFCF;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381405; a=rsa-sha256;
	cv=none;
	b=damecRX4meBDV6ulDxFQqjoyylFmTalslDw6cFOyc5agNEJ/M6KvreHaxYyGqEzbQlVnHz
	tF9MO45W8RNEEGTYoFwdatoR9S0YwEL4wbQWmEtXE3ivI/bBq/uDcfld19Im1VcLWB1lSe
	KgkJLnO7eoN5s45G3bjfT4jY3ljSrwI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0BC240534;
	Sun, 25 Jan 2026 22:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6663EC4CEF1;
	Sun, 25 Jan 2026 22:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381404;
	bh=cybpUb9IFSrtSEn6CVNh90w6y5FCshbAQhcAn4rc9bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szmnbFCF+vyRguPs+qTjhgn0jgwAxnTgIPrBfdW/GdN/D7mcBxVuZHNNiCj3DokE+
	 8u2aqDutKHZoWAe9XmC3IYWWqKSGUc/71rTf+st24SadAtLG/5tVE/jHMtduy4FUkz
	 SUAJb8ld4SDph1t42LM8gIYOi58uwgPrAnn5YD3a1P8uxg9qB72/8ZQGGOIi74olWd
	 CFCrf6sohYmd90ny+Aju0E7DCjeBioTCp58AJPJYv8B1r5e24LmqFQ57VDbkaj4U1B
	 ROdap0VewRCNie09oE4Flv5Uo1LqjdEi7bFQzZQH0fJGsTjtkrDTq829RCaRtYO8AD
	 d3bzLzh17qang==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 31/33] kthread: Comment on the purpose and placement of kthread_affine_node() call
Date: Sun, 25 Jan 2026 23:45:38 +0100
Message-ID: <20260125224541.50226-32-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 984EC40005
X-Rspamd-Server: rspam07
X-Stat-Signature: xcorpcmn7aetf7zcb3ggbpmn8hmjtg3f
X-HE-Tag: 1769381405-766934
X-HE-Meta: U2FsdGVkX1/agr+unT1aOISKmKyP6OtHkT+BWq1IuMIoMyfj+RLXhQ0DDkjqqUHWtHRgRQYX1uTbZejFzgpFUrYRkMhWStX6uYcLZ34vpUeGiD8adKaopyMvBkvOeQi0aZ2WqO0FtQksBUHl7zbbIhXM1DPuSVNZ/X/WWcgfmQy77UTvIku01aKfG1iYmSmvKx6EQ2xHlSLTQIQdtqqvJ+wIclL4eKxM7iSQkVMBGt/mONwkkEeG4IqAHXNw/D7O0d8gtsyMjdp07c8njBGPuMWZVjRLmNFC/CKiRa6Q5fl0xwj4T6ZfB+0RWHe2DS7aHtyiS8yxKaszN963cUEQdiOjcTUGNPB66Obc47AOtc7GOMTwmG4qgkFENpI6vs61JHS/lp47cFGerAyrjBWcdM0Kl0wyZKlZ5wvyy+1UqfJk5c6HSBcBWdnvsCQ7inyPNoqMjXzmYnl5AxtT60FzCYHxP3x6yWuK7ynw4scOdwuUflKUwtXAAzCWX2VjWG3gttU2y7iP9xYhr3tbAWwzLDLFRThmmpSx+/HMcHbMvinBplEkIQ0MW6slZFidN3B9JWypi774qi9BDV7zOX95CFKCOfAYBJ3HdHpt6yvAqN19ncDkKZM/kPTx/m6vme9XavKBL6TJ3RYMeu7Bqu/9s4Uo7qcVzCdrtQVyPn7FUHFu3nHfv6oczKQMDjV8g/kSJXxFuzalfSQTfkp/h7W5aUhn1haHDzN8zZNmHZzAJf0CCpZcf4rJx5Aep/rVOxv9f6P4flvphK/Lwh+mpeVA+VRic7BB/QN1UCMrBUMZmMozjzk+nh6tdCVcDS960HLBzXzRrlZckTbggR21Ujh8+RwO8gKRa1ay1EwaCkTcfsmjtZQGROHoZIdActTI3NI4czNhMP2wyHwK9uqaqzVS6KVuhY9S0PTp4O0MSXHwqmo41L+HI8pOWCTTZYBRpCm8ivu85fWojnmtX8ezsuL
 IH6IRIkm
 sQC94N5uy3me1M2pxiuFKSoo2VIYN4OSxmKlDNVH6WBSD3ib9iZU0dQeFIrwCeW3vpsbrnFfCGCXiJ9Q+ov2pJRBEL1RVOMclDtFziedIj790BdovxwERJ0gAh+mF4e9gud+kw+ePd+Oizs6cMo8z8I95qa3mqjybt4N+h253Z3ItQsI8kwq5XZ5uapYlWpVE3Mik3XsTQ+ML/6SBuJ+RVS+Eb9GOHCmhaFyl2xJ5/W7YfG2YiKAI+EUrxgjCgjRl21cQ7O8cFbP6KeEP8GLm+ERX5BTm0rS2RZyOtrq30Z4fGZVgC5Y5oHhdx7mhCGL6VksewSMxt6oeKwtVy8uXYbnvcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It may not appear obvious why kthread_affine_node() is not called before
the kthread creation completion instead of after the first wake-up.

The reason is that kthread_affine_node() applies a default affinity
behaviour that only takes place if no affinity preference have already
been passed by the kthread creation call site.

Add a comment to clarify that.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 03008154249c..51f419139dea 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -453,6 +453,10 @@ static int kthread(void *_create)
 
 	self->started = 1;
 
+	/*
+	 * Apply default node affinity if no call to kthread_bind[_mask]() nor
+	 * kthread_affine_preferred() was issued before the first wake-up.
+	 */
 	if (!(current->flags & PF_NO_SETAFFINITY) && !self->preferred_affinity)
 		kthread_affine_node();
 
-- 
2.51.1


