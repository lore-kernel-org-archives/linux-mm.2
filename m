Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B5FEEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB656B00CC; Thu,  1 Jan 2026 17:18:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F556B00CE; Thu,  1 Jan 2026 17:18:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082786B00CF; Thu,  1 Jan 2026 17:18:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA9566B00CC
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:18:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B15DD161758
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:30 +0000 (UTC)
X-FDA: 84284809980.21.6BF95EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3865B180006
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dKs4cuyy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305909; a=rsa-sha256;
	cv=none;
	b=16yRiNxG5WFoMTd7W/FSpO3FCzrC0aG4bZGWpt6V0LC60BjjC/HTvsDzweEsZ49nlYm/mp
	AOatMnHxU6B7j9anWlk56T+F7OsswQiMzPYWJY/uskHRQ3UrGK43LVqNdrw6382fC7XIin
	ifMs2Ibv6XFk2ioy4qKhe9VdUJaQmrk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dKs4cuyy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBAU+1vA8rYiXSwMqWR24rkIwYymM7IYjgceDiaW7xQ=;
	b=ITZV6vbvWr8Wn+qyqBZVBioIBxjezI1wMa9jmlnCn896+KpJn+HDUQRp1EDN3vjECPP8ei
	+8dcha7EEQ4TRDN9NeS7jUNgbp4kDn2SKcYdi5+SVN/pndQn/4enYkk8NqyoEJjc4uvm3W
	1kv1bdPPL4MNNBa0e7bh39VJ8i5eejE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACB7160054;
	Thu,  1 Jan 2026 22:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D778C116D0;
	Thu,  1 Jan 2026 22:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305908;
	bh=cybpUb9IFSrtSEn6CVNh90w6y5FCshbAQhcAn4rc9bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKs4cuyySogigb0CHjJKGicPzpmLF3keWilFbSY06Spy+118Ks90hsSQopL0I2Tta
	 q1YIw8IVK6zIb/FMBQTyTlKkDfWyqj99/pfnp+rHWMmCIaHcamT5K8hKvVKo2tWaVm
	 yuztN+96UASFPFnQGpTrLz3e9cskLBvUVKU2+txdPLfzlb8uQjnAxFbkcwFlhi4gqG
	 LTn8i3HR2EvRis7KMpwBAV8hJH6PqsY1+Wgs7bzHTTjJj9ZLdM4p6Pna/QNZmQMZFA
	 jF8uZmWY6brNA7sO54ERxDBPuY404ON4ub7VEwh7/HPb4ekacbIzK17ccHCt/eAV2a
	 1shCNQ4Ws5SvQ==
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
Date: Thu,  1 Jan 2026 23:13:56 +0100
Message-ID: <20260101221359.22298-32-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3865B180006
X-Stat-Signature: jz137hak8hc4y366uhmsefyf6zkufj6h
X-Rspam-User: 
X-HE-Tag: 1767305909-577833
X-HE-Meta: U2FsdGVkX193ae2T8++63MMis9sDilVlR1MZCo81+yXUT0SZHGhjI1eRxcVtCgoU6tb3xst8s106Gc7r8OeY+yCTgYSsjugQ3lCLGIbJAu86rrqar4McU7G0K6G0DbY9Cf1HBoXWCZ/5LN4yHrX+dFceuEm6TtYqYeMqYxoubqNm1Lm3CVkDrn20uTwFsrZ41vBWwVj3Y7EpQUSovbt3A6w3nlZYjyENBc7CPeK7Wy1oZ+WejVVsKEiS0kMeX8vVZSh0y8ztibFxNPuXaKB2uUDrZYhrLBXfUiZ/NZAT3aIZh5H/jzqgJSlbPjtr0E+4QVw1k1SnJyTozvqynj9Y8mo9VMcq0IUZVFUvF1WEgxgwF4tPPif1qh9Ls09ESZAR0X7VUSCTaX8yGcF0oGB6TzrRafV/Zp6elpO0Wupkoz+Ky3r88gZxj+hLlBOEKl+IPJLclWbtfYjV3mP6oY90++NXEgXCcZMb4c1tBtO1ZOqHQRXM+sxQ0Zkt5IBUTFDhv3aipPXnPNaRx5PPDnpky6WcyDxfRK23E7mkr6XuZgZJ8thMeyB8Q3a0/S8PtBnq5UemZMViouMy5mDrttmdAQf1jYWZcN0UtCB5pFrxTYKEtr1mUxulBgZ2mkzI6AJfNuo8S0R4x9Ieb1nAdg+5D5dZT45eJepkKR2rvHiAPOgC308bPY7gqin9Q3EiEYHjjVXdSGtngEf4SPNZ/PmT80itJJREH+wDHCxobw0dOHZAxpZ7gFJ2uqQaU+tAevapaMKXvmSHkJF3AuFnx5Z50l+5n4GRrtw0/jhZogoLrqp70yyOm56yd6TJQtkfRLWDlko7FpjCJSolY3nbN9mNvHO31riHZ46nceCYQ/cUFjhkKbLgEqt08BOzvLFmPii4woXky1Ty7oEtt0IiawR76xNnitYLIpsPF8pkR2+LbtsVDbnjwoxwPHW1uTW+8PopO+40aSFhXB/Slhk0DtW
 XHduivWK
 tOeSvx4CMI3goS14QKFnWS+FixvDSRYVp+qccnvYVMx0sUcDPZjPaCpJ+gLzDRHwg/+sZ9rRNtWidOi/pYGmL4OggrAz/V+jABP2MkgD5buPkzFfmOygymWJ0z19fux1ri39H+l2OJ+An/LbSgMN96suhRqhLUZnMkPKC67n7PzUPCJ6O4PczPjIar+F3O4+vSs46eEC1+gE2H2r3BQ5gw4efYs4G9EJYutWG1ZwWf7ZiSbr7r+fsDr86lmysZZiDC9/x3gMuG/zC8uiQPb3qH8aeYwZMO7Cqe+TyHM1fuBXifljV4ui8DN9KrNmEUohFBBZpvEBBHRzNaVs8YdVVv+RVmw==
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


