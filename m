Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E4BCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304888E002D; Wed,  5 Nov 2025 16:07:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBD38E0002; Wed,  5 Nov 2025 16:07:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1E68E002D; Wed,  5 Nov 2025 16:07:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F48B8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:07:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD4995916B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:53 +0000 (UTC)
X-FDA: 84077790426.03.69C4911
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40AB8C000F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uqBh1peA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376872; a=rsa-sha256;
	cv=none;
	b=4kt5qjBRCfIf+lUPXwb2lPF+vRFX7wjooSEIdtvvQtcjodfUgkcnlYr6zSAmiR2/4epA4/
	AG82c+O7J1mXdsGAJZlN8EUoNNT+PbqBi133Z9F+StWt2wQV5n0ngnj2Q20T0wVNI0ZrKR
	5cnhZBaR1xTeBVbOtGl7SeOGD9Szjm4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uqBh1peA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8fhvEoEt0tjcERWsEExVHDVeWMefORFMihOatSLeuc=;
	b=tD/c12Ki5Db5+GPkLgOm0IGW7Ooq6pEwlLqDfPJqLdTV7KaR5umicpP6wCArXQ+WlquUo4
	9NdDir/Gm9AgOA2ftLqvZRiPNgQvohGTlcUY6Jfd3CJHJaGEgT40uJzDlQTptlTsYdFWLV
	LJzNSMtUOCy2HiCbUPA3s+gAqBC4i7s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 534AC40898;
	Wed,  5 Nov 2025 21:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAB4C4CEF5;
	Wed,  5 Nov 2025 21:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376871;
	bh=ZcOaIdyFvlxFsz4x9bV8dX/urbiaQ2dIYf+IOrGWyKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqBh1peA3OwqS5304aC8e215GChgjNQ+xz8WZIQjvhmtUS6f7nqh/RdQVeNQ2M1h0
	 N9H3k5WiLHpEb6YnuD/MWiQNlkqvtuYe7W0HDhMHx5X8eNFG6DBGHNKHlJoU2BaZ3M
	 rY4SVKr9xZY+z9hsVZG9KG/MPb2rofpyd5Vsybfo7AU5hqZEdZTrlKKYfGBaIM7drb
	 2RHucdD91Kljr+Sb2WKdMpyTxwAtuFcHF2KllXdzXz5owrbsFGBYFYh+LObYkRbxKp
	 6VQgFGT1HY05dsL5fIdD8y7aTR9kXshC2UmQ59+mAygTcfny0kDhWu6JYvJ0+oQUt1
	 C3W1zYUxNI9Ng==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: [PATCH 29/31] kthread: Comment on the purpose and placement of kthread_affine_node() call
Date: Wed,  5 Nov 2025 22:03:45 +0100
Message-ID: <20251105210348.35256-30-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40AB8C000F
X-Stat-Signature: udkczn1egw4two8ufhjukt9wdbwcs46m
X-HE-Tag: 1762376872-69951
X-HE-Meta: U2FsdGVkX1/21fXBGtndUj3qQFZKtNmqWUGZdB0Xc8ldv76/xo3sTJHZwot3eDRG+8tObQvtzTyrE53OJ3N8px/xxe1KwzaZkb6aF2/iq02/+OC6ocVOe4aHHvVoyGaYPGbFnqadda7qTwNpmUw2Vnu/D/RFhxgL3gTdTUCVWWgIM0B3kgCxFYh/xLMg9pwFrIRv9lgNKWfAjzC4xQex5zjdpnOaakLLTtUSC1ZCXw1iRqv597EHPUZfweHyy4SpjwR0YAeKMVWHlHXyML9xK44ZIMsXnEkRBLRQrNzqeEHcyIto8mqVHd1Yecr8BkfKVUMgaOusLLJk47TZgxqErvLYoeY9yYj9it/zaQSC9ZH2SP7c+L6qSTw4JuJMach5B7V1Sqy1lW+X2ivvwydHXdAjo9Wmw8SNFoqHoVViontK0kYuv0qT5n4fZDSx90cUdCT0MxpPS61f8RCa3/l9vj7xc1Irgs7zjZafxgnrQOjlFi/GeCbWKTh8MaI7ndiEK1wPvp0IKKL2k/Vy35zPL4RI/i+wwL5qU8Rz4RMLaoybGLuktayVFJZvE+wqAeChykGmZ5eOdWVxOaxl+6WvVG6rF31fiLS+fxtMmgRNwx7BOI1tvZr2R7wUPaztRfqqg0GD1GaXn2GO5jNmvGTcZuIL0JRez8b6QxBg88luYdIiyuMcJO9ai1WnjbDfHhogqIsbDBaMRfSxbMSbRsAqPXO2RGNKI+x5d7lV3N2BGHxn0DPBSXzSyhJMFqKLMgPRfuW4Enl8qbwi2PIryFRcnE7nFUnCLxUtSnA50ve5klRTZuRTX1wnrf4a/PNNj4UgXFzNZ8UrTD45VmDkkVm4VYWeeImjwfOj+/oaYoWuZApDxukZa5Nf1TJuTn99dYrwvcPfPGh8PJ9e/r7ERgMroZjI3nud4isHAXZGHQaRXHN0dnpQ/Os2qkMhsMEQ2wBQN2DTG/UslqqnEuSqdjV
 Beeu+wsd
 /QuMxgwDT9fJcCF4=
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
index f535d4e66a71..e38ff9b943cf 100644
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
2.51.0


