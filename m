Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32C56CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8258E002E; Wed,  5 Nov 2025 16:08:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D04E8E0002; Wed,  5 Nov 2025 16:08:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6C58E002E; Wed,  5 Nov 2025 16:08:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BB1D8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:08:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 301CA12C554
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:08:01 +0000 (UTC)
X-FDA: 84077790762.10.F6B3607
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A686F40014
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HCxWOTZX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376879; a=rsa-sha256;
	cv=none;
	b=KNZ4CQV1AmUyQ93NCvDT/nx2lcFnWw00nYnZKHEVclvlpoi/UL0HlEJz0WTGAd8hAWAqdD
	tZANeo5tniVswCvFDth0/VelM7TYq2Ici0CEtTCRo8gDho7st9/oeqQQ5oTSQs/nIBE69E
	+I1sfZLYaAKY9YTBhqFXerwml7JaLrA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HCxWOTZX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0IuDXeqMt1o/KgN3LLvCBk6fnKHY07Zt+5KogqjF0A=;
	b=okOpnkY5SsZsmLpXDt8T0ajXPw67dHeLsxtSwhNU7aWdSKELQS/wz++wmLVFT0HwgUSOVU
	nXwvnrd+Tn81AGL3SRV+gWorqA+SYvzmvYFXhr+Akr02gpubwsYZAs0BQJ70HYxLB1+iZQ
	bfsvRnf7GEIcl+CJgdMwxzdPMeCS5/I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 337DE601F1;
	Wed,  5 Nov 2025 21:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1E3C116B1;
	Wed,  5 Nov 2025 21:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376878;
	bh=VBowzwkKI7sQO6hRH/44BMa4PxA99ppD75DvlCpqKuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCxWOTZXSfmgLOy+8qHyUSsJQbRRrEggtHXYLIpXy1swuMrv2SEYUM8cLQW7kSc4H
	 0Ka2bto9uN0BXbhyNM3r1gLJVYwW3t2rKAXPeI6d3ZnnTZoRFUTmkBveHxO+F8uRmo
	 AXkHlKN4LkLllSCXYkJiBOKHWrRf6CXXYtYu1l6M03U6EEvLzqrMyOOfnSaNsd0vRj
	 h2TmHpzXfc20tUeNa2fzrHLlFE/ggaDYNk1I4h5CwebPAdOaP0ppHyvo465ef4OXCB
	 CyfaCDTcbrZRKcEQW+8KvinCbmGda/odIiBswEOY/el7rbNcbJ1X/NP4oGu/CK60DH
	 oTdnWeUTkDOGg==
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
Subject: [PATCH 30/31] kthread: Document kthread_affine_preferred()
Date: Wed,  5 Nov 2025 22:03:46 +0100
Message-ID: <20251105210348.35256-31-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A686F40014
X-Stat-Signature: a6r3xzbhh754ftc5qq5q1qyqj4yfh5a3
X-Rspam-User: 
X-HE-Tag: 1762376879-275776
X-HE-Meta: U2FsdGVkX19ucDnhMGdDPTwawGyl50TI4hgPqG7GzSKyM+RFNyFEUvLQvcYUEtddodiVAsWFqxbLUHzMxoKEu7epK0GFUyPNxcEvhljWDdCDoD2L8fLdMg+x/As2SFULMvAck9UuonA9dhnL3osEuKYxY0pjI2S0BE1lMicaZEW0FGZeBaPTLcCqrnSRSo71dY3V95ycaIN/ATPLDxemrehlKEPhwJ7HEFjFrCa4uAYseGpdHkcjokcaUMkqUJOoMcKGaEKvFcDoxywk78cgnKvrC+cKeiQlMZcVJuPTQA2DaalWOy+cXSc09goZeifpwnSzJuODXKPFxq4ZPGs4HPiUnpe5VMb9mfE5ukPYaCABIjpPkZRHbENxzjHCqtaEUV6VQm4a3yp3zIZZXOL4iv4fDfnu4ReBZMJ07W34K7xPW0sJTbiExW6IjiwJHqDuFjhQf/oDcoZF62fkx1eYL4TJBjUBgEZzEoNKnK7FfJ+Y6sySLjXj6Igw13pODekL/q92h7WTNjmcKpNXx/hKZDaCedjLwY23SAX2QWq70jOfy811Lta+jNoCXIl6Au1sUYpLNVX9wyb9yqNGGgHwX1DgzB5ZQrpBGGJhzEh/ipY1emnlZdrzkanzCmmt3G1Edj9B0T1gPd0S0zHbYo1Pz8n7Rv4sbJd9WbTOwK5YZeH4RgJug2XyDtZDsP4TMQDQp9DKm9As+4TrI62J2Q/oX6noS5jopJdEuVjJ5uq81a711GelTyG0IEnJZqCOdYQ2CQ97nvtM/wKbxYOvTSu1ltJSpeMcbtzMTo9GUoqQUq5Tt06z3JjKvhjQwT2U+pBXjJbhluV0gd3yzn9syDhW3T/lpyo8p/P95EQQ0Fl6zbOhzvXT82ff/p5m00YkhfJbIzc3tePHcFGQgu5Q/Omnfn2b4XneTzrPggw3yQb+/uhtxiRcvScNndmsVd2PvPv8gQzar7it7yscBplwVKI
 NyOve3kD
 zraT3aZQBRL3VGFwIFQ2K3Xkjj7E3gAOPHcDgOsN1QGYJHZg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The documentation of this new API has been overlooked during its
introduction. Fill the gap.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index e38ff9b943cf..4d0d5dccc9d8 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -858,6 +858,18 @@ int kthreadd(void *unused)
 	return 0;
 }
 
+/**
+ * kthread_affine_preferred - Define a kthread's preferred affinity
+ * @p: thread created by kthread_create().
+ * @mask: preferred mask of CPUs (might not be online, must be possible) for @p
+ *        to run on.
+ *
+ * Similar to kthread_bind_mask() except that the affinity is not a requirement
+ * but rather a preference that can be constrained by CPU isolation or CPU hotplug.
+ * Must be called before the first wakeup of the kthread.
+ *
+ * Returns 0 if the affinity has been applied.
+ */
 int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 {
 	struct kthread *kthread = to_kthread(p);
-- 
2.51.0


