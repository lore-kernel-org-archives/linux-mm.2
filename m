Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 433AFCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2DC58E0023; Wed,  5 Nov 2025 16:06:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05438E0002; Wed,  5 Nov 2025 16:06:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C4D8E0023; Wed,  5 Nov 2025 16:06:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA938E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:06:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FE59140466
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:35 +0000 (UTC)
X-FDA: 84077787150.20.860D20D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9CD308001E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WPMVl7Uv;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ix6cTrI12x/DWHKCw9azBbhzrRj4SPpFUjDhf1tp3cg=;
	b=WV1vP2E/qkCh+0UhoEyJpdZmz/vx3IWd07OtiQ5Wjnayk9R98NyjXl0JvOb/146vVf4nLT
	uBeGXALD5ZkWa60/qFRrHmCW6Fg4KG/bO2RvgKts3iXeU1ZTa1IBtUrSrMMSG5uGuHE07y
	HwDRPKgBamQe/+0ZtdUaAEyAKobw6hE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WPMVl7Uv;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376793; a=rsa-sha256;
	cv=none;
	b=Yqm8pmQO6UVP4iWkUw4xlSBNGMc+JtcffyFNrYr6S/tQLv9RTIXkuvApCUnvQUbvb9wphl
	N/w7kVvu69FJS2LPKOM7wSj0dyyL2U31q6ojISYaJEBvv8l+wFD3PHScbkT0DM+gp5woZN
	kq5lUDhUcusUHWOAOKqWyy6vlF4RaRc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD30344812;
	Wed,  5 Nov 2025 21:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F01FC4CEF5;
	Wed,  5 Nov 2025 21:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376792;
	bh=/4qlBV0o6wHpMCHv+PGJIH0/5p5VMnEM2VldkFFk/hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPMVl7UvVPMRPQhKg2eY/RDKFC1vZcXdD08AGo6Qq/JtNgo8kPbs91s/W0brc+V5w
	 YScVpXtDvf96TJiGbbd3qjQihx33QG/l0iLxhIfzXvXPIv/C6GBZcpUsAOA5/LUs1n
	 oaHLFsM5/jX9GEIO4TEpslLn6l3LkI9tBTlpdE50e1TEqi8N11MwGL1neMCwf138kP
	 PlCf+SEUHcmKj9utkNTtcf5yDLRO3jFxTVgZtfFtvRXo7um6DMx6SJcAdriB6p90Nq
	 yLFLyG0eKaF2fF2W+V+aALv1nrBq3tM7L8gCnFVt09OqEynVIJmKSvNgTQpXOuXEU1
	 1rE/ac7aW9QzQ==
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
Subject: [PATCH 19/31] sched/isolation: Remove HK_TYPE_TICK test from cpu_is_isolated()
Date: Wed,  5 Nov 2025 22:03:35 +0100
Message-ID: <20251105210348.35256-20-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9CD308001E
X-Stat-Signature: s39p3zse3tg6sa6f4tbnoyongcnch1f6
X-Rspam-User: 
X-HE-Tag: 1762376793-494567
X-HE-Meta: U2FsdGVkX1/+XXAx9LmLm5orAEHsgaT16kFf9Qls2VU9KiQTONDIJxCA3tDqJuc6Bd2HlkCuj6Pa0h2YUXGV7OWIl/cRJ6Hlqj+VSbA/dh03csgcPqm92qhh6xfu819RgJ/l2lv6YypE8BeyZi61DR+6ENslN/zfXsJTPHTOzaYxnAaHL+03rtnEyuKIYfYzpR+HvtjfS2M8+UY32IKxVJ9AQBfLILgYaAc8+N2mJ1TIAVetSa3JIr+QMwQQ0hinyMjlaO8yGdNajArJTPDvRv9dsWE+mqd4DGp0/fGCKBO4M2D9XqL2Z4kq0TFDdVEpYehMMGKxX6/EUuCNDCF1CQMkKPmCLQ6L4FvTUusG/p43gpUefSmYZWT4vIscWmLDxG6L8aPu195D11oWNvVlW0dUv2JtyOUU70Np0vxKlKNx1Cvi5mPPZ+1Cs9UXJ6ddPjKPd+osK5g7JLTXu4CrC5NBjtzmk12vIwsCEJDsmgwOgZSRHlU4xu3olPiVs23VJD7hU6nIOysWEW+QxMGi/GGJsVzpVjBteP1Zuukb2HhyaTDTkP7VrpUQqSHOvcRA7Z0WZtBnL5mLFdMIe/S6MVCqS10IFVyU+n1hK4c2dsDzz1OO+YSg0R7+9FMnZUxVu5B9m9sU5e9g6MwCNYz5+dfek+alLE3OitKhZheonwqdJcJtwR9hMtYtNR/rQLqEfYbKfWgeOOApNQRYkiATETujWRHtd2QRrCuBOMB0WNHJNy8gKWiWU38oTv4lNGYNV3ChmTYh4rSbe8+ZQvnt1JL25pmKZ2WLEUbVJ90wHg4eVff0oUNVmWVTjyxbUGpou0OldumTyEW7/BC4clzNonoxopZniu5rWZWPmSgyGYXt2lF5+MWzUYqIdkTt4JP5Ao4+j1RAdeSa289TQiY/zjikukYfplyK9IFpr5h2LflIg6LXLOlOWMHe2HysCvHQ48DnaCHD9WpIrQ7xvZ3
 am7PbzyH
 HPjex2nb3VGrjn34uwRNpirgvGBYI+pzUopTsm0HqnoXnk8auqsvNvIQfbD7YQQTUOVuOLAJSraAChMtbABPeplz0HsgVq6dTBBrLSXu0dF5i8Y9gT6gnYqQUSL8ENqINCSn4efwPGcerjC5SGmHsPiDe4fbYu/24MojNB7Ir86C5mdcjWztLNKGOT/UU7DoYW2PANG7G5qAoGl3lHzN82Qleg+9ODdFq+StslbNEqEJxbqKjQgJFMLQjSFRbUpgQ7bRNQG5UVpr3tGwHP5RYY5+D12Scewvv3xffpm5hXGaUKTEkp2T9FY4fkYS++wZqBVtO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It doesn't make sense to use nohz_full without also isolating the
related CPUs from the domain topology, either through the use of
isolcpus= or cpuset isolated partitions.

And now HK_TYPE_DOMAIN includes all kinds of domain isolated CPUs.

This means that HK_TYPE_KERNEL_NOISE (of which HK_TYPE_TICK is only an
alias) should always be a subset of HK_TYPE_DOMAIN.

Therefore if a CPU is not HK_TYPE_DOMAIN, it shouldn't be
HK_TYPE_KERNEL_NOISE either. Testing the former is then enough.

Simplify cpu_is_isolated() accordingly.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/sched/isolation.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index a127629adb32..a24acefacf9f 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -82,8 +82,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 
 static inline bool cpu_is_isolated(int cpu)
 {
-	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
-	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
+	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN);
 }
 
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.51.0


