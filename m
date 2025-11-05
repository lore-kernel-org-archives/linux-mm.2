Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72110CCFA1F
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE048E0029; Wed,  5 Nov 2025 16:07:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E5F8E0002; Wed,  5 Nov 2025 16:07:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8ED48E0029; Wed,  5 Nov 2025 16:07:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A2C0F8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:07:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 686004B353
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:22 +0000 (UTC)
X-FDA: 84077789124.11.FDF6DC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D85771C0011
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TIAbm/F3";
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9uIEvkay1m9FXLKL6nNfa5AWTjTifx45z4KghX3hjOY=;
	b=bIMxvGsG6uwJ9+WsDQYlslX6FqkK6oYbD92D5DoBCL9ui0gOiOYoAisXJxZtkCpTdFeGZ7
	q2J2fmLePykslV4BEA9rzcLJE+w7w85CG36d4yoUOmQSqA3Qsr5Azuu+2YfKPEo5hVwL8d
	/OO8/2HrfBF0VnQE6bsHhOCMPRPsqEE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TIAbm/F3";
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376840; a=rsa-sha256;
	cv=none;
	b=oLXu7pYVY3CZFlga+qK8zKXblPq2IG5h09v3bliJ72Dl8IUexDYzMQKL8+E6vACXC37xc8
	IZf2GJLLzObiPiHRTspsbcikAXm03DX9Uj9bWtEyV4QN9cSOQzdnunmI9XW9WBmr956KA6
	zJnsu6rloQbr/XmjbSBAzkVIsUbRhPU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C71960220;
	Wed,  5 Nov 2025 21:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798D5C116D0;
	Wed,  5 Nov 2025 21:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376840;
	bh=Rz519K4RzNFN9C7FTifkrc2s4js15D9og5elk9stWlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIAbm/F3lkoEFLNp3ZLWekoviyl6iWh5KqGoC3jN5pAXOi5L/sWwbTneX1Sd1f2Kl
	 7zL5xqMjp906phdgY3w8G4Loes9IQaHO6Jg1QGxIqMQsUXfkKAHhFb1mPBnHUnse7X
	 h2mJe/zjqzeSRH2cgUsMRXuxYaohkVkO/lgKbv6DBati8qhfwhtKaoi7hBjPHR4dMv
	 8b9ApEnTcxqi22/RVPbXSqTskMNkQjcdP1Pb7XbijRLMlZfhJpdGLk1g9A53gP9snv
	 vGCzTSX8nxacEQ8fa/P2hESWu04ejojFuxjWPxaXBvPpcyAYLwEkBrNtfCM7qw2bfC
	 Dnzv5/9V3vOew==
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
Subject: [PATCH 25/31] sched: Switch the fallback task allowed cpumask to HK_TYPE_DOMAIN
Date: Wed,  5 Nov 2025 22:03:41 +0100
Message-ID: <20251105210348.35256-26-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D85771C0011
X-Stat-Signature: 16y3zh55yo6z679u597ey6tmt1nhkyb4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762376840-867820
X-HE-Meta: U2FsdGVkX19TT7JAwy4t8CLcCZ4NrE1YjkpuwV1KThI0vUNUVLWV2Vp0Ogyf7+xRCfQhRM6rmQF1fSK8RMQWAjvL4+LVi4wOBfULBEqemD95qmsfGaWQwuQ2DeeuTuJjIlorDFxmKQ1Pg3cKT+o7UACVxoSIAzkpyat8vHez7kUbS0hNSUgBH9PCGKYWiFNpb++GsuGXK7UgBPzjngzXyEsPIBB4jxQqPr3TQCXCw/re/kpUJdYb4yoQpkYk5vmqX77Z0lDj8ocsLevmg5w4ljL7awZGWTF3CXy8saC7HgqeQkyPi0fvSjL3fx9Uqc+pPhARJlU/0SpWlby9dgzNglu+bjCZTwty9hnsyRJiznxVj78Aua2lHHuSqXcAAvHrojUNheN2VOFWbWhGA1EoAZcJvKk1Ccb3yVjOQkNrI3AmFgoP/YTxs6fKvUWoqtDX6OOFqjuoO13d4QHE2osPw7b2lcBbo107DErEynx3gZeYahUoAJS2+kge2pw994rVQ/sLEvGoqKPd34WAZcyuHp5gzdPAtgY8XniJgWYRAO/ZuZwoM62xT2qG6mrYyOlleF0TNxsuGc6pwr2ig/DjZUY3RAS0L5YFaO3XPSp9f7odz3Crkzr1XNqBnWdWEUUAN0neC+7CzLwE6PjyRw9hBgP/CQgWIR79KxZibZzZP8LB7C4fBB35+f2adQJR2dqi9MxI8I3hZlQBj45Zr9U23SxXhU57EXEV6r5ypo52Lmsk383RaVTCNBUbrgd/3e5fCD932s+ITfysL+odt8hrIZaZl6NF6VSqZ4kLwbXkDd+JVkif4PoezTk+3VjUqTltPuSBOtnS4GCiWb5ezap7xmTef6Z4odEd/H5WeIxyZbDYKiz0r7VwXHT+iVctc7ZfCuSf3qDcZPNeLyjfFxD1r8hRbgl4TP9+2Gm3vOWT741uGzUhYTvoyJ5Fn1vyxYyeHhmpH8bNT69MwLctThd
 KKQUwa+p
 xv4j+U7pNF2Fzo4ST4o3xQEL+hRhBPfdYPpibLr3CEHZLwSxRmdORMk974+I5Krcu24ooAe04a1cidcOHCLmzxm1ADsbWSDiFFX/MSoLYIarp2hpFbFgvzh4MDzIokNv7VkthG2JAsVCT2T4lcI6i/kkfXc/zzhzOYpxjWGKYrWSxthMUqQz3BewbFwhnymjsJ/j2TOREB9yA6dBES3st/v5yP+7IO4Gi0VmpMjSyreoG9IX6u0ju3Umd/9ZAZoAAul7wHMVGiJYeh649Whb9uNtBnLaoVXkzA1aemTCpi4idSK2uxgNoHlUSfOnE/7F55ZbU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tasks that have all their allowed CPUs offline don't want their affinity
to fallback on either nohz_full CPUs or on domain isolated CPUs. And
since nohz_full implies domain isolation, checking the latter is enough
to verify both.

Therefore exclude domain isolation from fallback task affinity.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/mmu_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmu_context.h b/include/linux/mmu_context.h
index ac01dc4eb2ce..ed3dd0f3fe19 100644
--- a/include/linux/mmu_context.h
+++ b/include/linux/mmu_context.h
@@ -24,7 +24,7 @@ static inline void leave_mm(void) { }
 #ifndef task_cpu_possible_mask
 # define task_cpu_possible_mask(p)	cpu_possible_mask
 # define task_cpu_possible(cpu, p)	true
-# define task_cpu_fallback_mask(p)	housekeeping_cpumask(HK_TYPE_TICK)
+# define task_cpu_fallback_mask(p)	housekeeping_cpumask(HK_TYPE_DOMAIN)
 #else
 # define task_cpu_possible(cpu, p)	cpumask_test_cpu((cpu), task_cpu_possible_mask(p))
 #endif
-- 
2.51.0


