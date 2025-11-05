Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6657ACCFA1A
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53578E0028; Wed,  5 Nov 2025 16:07:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2AC48E0002; Wed,  5 Nov 2025 16:07:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F608E0028; Wed,  5 Nov 2025 16:07:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A259B8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:07:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72FD712A8F1
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:14 +0000 (UTC)
X-FDA: 84077788788.23.F7718E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D16F240018
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=szIDSeRI;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oF7ozQRct3Nq0s64sNrymtQh/CRoO7RSd6PJ/aLRJds=;
	b=bOxumTPeqCQK65G1bai325mWrY3eSkXqrc20OCxEjU4f3OCCfU1n4BsCO6nam2csI0AhEb
	/GQzeMYl3GqL/3W1YdsMlr39UAYBoaTfYp+lW37l5Z3tbK6GIAZdo69AOMzzhG8EgU6DTG
	Wxt3m1z64gPW9qgnxcNDPIL4sDSw7Q4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=szIDSeRI;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376832; a=rsa-sha256;
	cv=none;
	b=l1KgNFi2/URm3Ki8myQHFDgpyOhmV2vKrtucK5iXAUmEcwgoLICHOyIAhfpTG27SkYaWM1
	1ydITag9f07xsD45k+g3uPRBOTAGkQR8eoYhsTXlQER3Fo+EDwY+hTRHkGv6lIvhomtI77
	OR7sFeUyHSzkzjyyBPLNcwwQNoSZ6hA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60197601F1;
	Wed,  5 Nov 2025 21:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81075C4CEF5;
	Wed,  5 Nov 2025 21:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376832;
	bh=J6j4zsULKpjy2xGkRdPN0GqxRFQVWDdmCEJclS8fknA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szIDSeRICvuPVa22uckyIj7tLtbwryeVGfvVRmV5zDtNt+6NVBCBqBwYblGbDqHv6
	 WQdkxwLPuV6izEzNadmWY/Cp9t5y4JB4wOFuPfAabLsKAgXFvGeFbrrhzqeNduk8ES
	 yUOiqND2LZGDY74RENtGR/Bq7PP6DayV2rI64BjaalSyI4LE4lkSiJrfizlKFn1Emx
	 uvFPUHCmqtSHSOY5v+/BkFDW/Z0kokfN1Y/al6wn7QE3P1GrD20T3kbhNhdCZ3GLRg
	 rZ7BiZ/qbZ2XKuvtAYnPwl0IiJ1OfTlvfENurtuaeb+8HQO0rRM7YpPG6V6BEzxd/v
	 N3mdEa+6d4mDw==
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
Subject: [PATCH 24/31] kthread: Rely on HK_TYPE_DOMAIN for preferred affinity management
Date: Wed,  5 Nov 2025 22:03:40 +0100
Message-ID: <20251105210348.35256-25-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D16F240018
X-Stat-Signature: 8qnjw1ok1fmz9hdzuayh1dow5jdwpxfu
X-Rspam-User: 
X-HE-Tag: 1762376832-887485
X-HE-Meta: U2FsdGVkX1+vu3s3aXKbFUK7RUnmbUkaAA2xJbBAboKRkXZZRJF7Hnfc5WAXMaSXip3/Ps7R3N14L1aiGD02z/hZsdQXfNxT98hCTnYxAHEcpqRg1w0pTQVreUUWPOBQcb9kSzuv7SkrYO6ZLAZJoyyrlYhnWr/N0kB8uei78oifQIgrP6AyYydRwJLhyKi0rc//BqUosPO0Opy2DnF/OhpTdCLXXroC9sxflL9/AAegSB35eTdCvMeZjgMh+CZuE/inGod3pwO/444M63ZSKiwBnEOapB/fteNbuHjMnILN+lPlUyLbqZZ3onzKqxKdQXW3g2Cz1eXTf+C3F0jASoXF4XR3uJ83Yn4mMZdCHQM9iZejfAzsBDezQnEJi+o49woNB2n72Ra36JyNQw+pZTBezMC2EDBx9htvFjuv78FSvV3FFZOcYfB5mGqaoI5RhrR1iUvfVEf0jCdvP7mIUtrIapqTt6tSkpj5IfsbQkhnMISSNsQMlTRd9mxxDhpHTu7KNWVyLKCZD70uCmchenimdQ9BOKu9KrMa+A3GkE9LXAOaT6Kzi0zDyYZ+MCcXVQnNrbXdif5O/69ItVJYHO+ucjVB8rHjtGdrwnlBc93BBxmDqsY1Di31queQNBIymKvS3FmXOtn9g6cOAkFMeRsyLPq3oG1nVTK61ko4FzJayXCm2eHntyMRnlXt3oWHZ7OXEyjQLCaPZrGbVouIxyD/cB4txdpQC3EOC4qBQQAiozbGRB4Wv5hPquc9aRD/wcAYNbFRVvGUb0vygYNwGsqFETXDvrYWnyr2vBrJEHhZmkHaexrSl5jqEK12wZTzA9sy4c0n2hivcbAtPE6D/Pc+wS3wbUpQi/HUNlmEckteMHnBTCeJv60qqRENn3X29gJtiZp+r9VHUuGwJ4EJmonBx2DP8+5RYBMsSch12B8cFrXpNm8XNAgEzpk1mjSqNby12bqaM8Ls+jmqdLQ
 oAEDOQPX
 NyfIQc89Z64iZlXDBPet1oFK8Ti+yy6F6p6KrLgTj2qAEFSB1xeEuHfYfWqcx3f1rco6cea2lMw59r4kZbLjmFpoclzdraAszmhsHrZ1b3NMBz+5yO82PL1eJt++f6+is6K8GGm+Up6ed4M39h8vJiG6ZGk3m1rfN09W8lxFytx+I/htwuN5fO2gm2QU5c+D22EhMJx5MdixHQ/yT6rFWDzF0W8XF90r3bHn08vXdxyM4n7+fRYo1gc5E56j+bE7Qk+vymU5gnfyDS6SBVbW3NutzzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unbound kthreads want to run neither on nohz_full CPUs nor on domain
isolated CPUs. And since nohz_full implies domain isolation, checking
the latter is enough to verify both.

Therefore exclude kthreads from domain isolation.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 86abfbc21bb0..69d70baceba2 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -362,18 +362,20 @@ static void kthread_fetch_affinity(struct kthread *kthread, struct cpumask *cpum
 {
 	const struct cpumask *pref;
 
+	guard(rcu)();
+
 	if (kthread->preferred_affinity) {
 		pref = kthread->preferred_affinity;
 	} else {
 		if (kthread->node == NUMA_NO_NODE)
-			pref = housekeeping_cpumask(HK_TYPE_KTHREAD);
+			pref = housekeeping_cpumask(HK_TYPE_DOMAIN);
 		else
 			pref = cpumask_of_node(kthread->node);
 	}
 
-	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_KTHREAD));
+	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_DOMAIN));
 	if (cpumask_empty(cpumask))
-		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_KTHREAD));
+		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
 }
 
 static void kthread_affine_node(void)
-- 
2.51.0


