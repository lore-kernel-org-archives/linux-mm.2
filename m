Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8521AEEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAEC66B00A1; Thu,  1 Jan 2026 17:17:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8CEB6B00C2; Thu,  1 Jan 2026 17:17:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4D06B00C3; Thu,  1 Jan 2026 17:17:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBFA86B00A1
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:17:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A64759106E
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:56 +0000 (UTC)
X-FDA: 84284808552.07.E229F3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1CE5CA0008
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k3tzAh1q;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305875; a=rsa-sha256;
	cv=none;
	b=hrHq8FhNieb4S6KS9DBV39tTGu0L7o8lgJxft4Ge0MKgKkn/GafWPWawgqwvXwgbDQeQmp
	WR1FrtdPHZOlYQ+MMd+45fv/qYP6+sNY/V/r5bSUO9sk4nenzIzRWiBVh+fNlXuQi2RtY0
	B7vXwYnSBDGL8SPnTEkywkE61lOPFDg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k3tzAh1q;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/H7Gz//2W7YxEQDiG5Fn2sVeSOYBxF3U1J+XksfESs=;
	b=66PIavxxs8iFeZNuax5WCx+f4CuNkOWg1AHiDC5jifg/g2Ti+FKOrijEKBTh9kfx9496m5
	w1fSC4bS5gZudln/slHbykR5+if8R88Th5KvNhI7MX6vIYZ8PTlpHNBS9dDMTqlpMN+e26
	JsL9DZ3nkh/4sHS1xWvZR/jl+Vz4O/c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BE15600B0;
	Thu,  1 Jan 2026 22:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696F1C4CEF7;
	Thu,  1 Jan 2026 22:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305874;
	bh=OKxr66AuTYpmtINGeWatnOeeLWTfC6xUU/wfI1fZOeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3tzAh1qqBzEdJr7W13PBSjlKJJ2OZj+v1bk3WgK5Y/gMgiJhnOqkbzrE4d5fNn6r
	 3ihlWEqcfPQ/esrNTdCUpshwQlHu06VG7Fg8ddHxFPeJyiGDYP6VsaEe7AtkYGFNID
	 7bW3zS0Mk2L74PT+vdla6Mz6/0qfIdMkfBICDBxermqoh+GzMfbu/cvTlTD1Um7KNG
	 qADGnv9N68YVfnTeHvZRAP+S2Gd2w3P6I51mCUa2XTbkMdiLCDF9BPwbcddsZ2ehdj
	 ZdhkVDdGYr4dZ1sqs2Pe0ofLfYQE9v4eJ/Tk1J3wPU7EWgXsmp45dISB+MYVn2h/GZ
	 vonDrbTOK4C9w==
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
Subject: [PATCH 27/33] kthread: Rely on HK_TYPE_DOMAIN for preferred affinity management
Date: Thu,  1 Jan 2026 23:13:52 +0100
Message-ID: <20260101221359.22298-28-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CE5CA0008
X-Rspamd-Server: rspam04
X-Stat-Signature: ckdha6s8i9f4a74nijueqn5iz1db3wio
X-HE-Tag: 1767305874-311805
X-HE-Meta: U2FsdGVkX1+ZTJOjC+cXFY/HqzMD8pZ8udFK4maG9G6Jj3J13v2kw7ciIp0eBGBPRZcvEeSKuGO4JGd2nQs4OCNvH4c+hRoHK+3cDJuFTuWfcPmghJNkLiQTj0uWMx5MFKLRNBbnbRnOG+U2UWDIyLLZ5PjOgaO4cKgJVPlfI1H2lUfHUtAmGiWwPuqNuVRKS4I9dH9FtJmJt8rkJMamAhDmVVn6O7aJ33FoSfn/NJmJLcidruLRtEzkwaoljQC9EEKB+KeK9kKVV9V591Cxcgl/wiwRkCSzCdm/e7SdEpczjDQy7hkNc2+aGQU8PsYlK2kGmMt6E+xLMNSYwIRlWLs3eIoJW2ZQn58eb/uB8pIBA9gdDRe4gx0xune2b0h9zhzqXsKmVacJLp26jayeUjjOWsaB4DWoUd8dLyzbw6ywZBXA3IjcveYXw1QnU2xasnT1EX0wdp58mlF+91wFTfOt9FtdmaK55zXNx+yVtjN2WcoMkUMtdkel0zosqfPB7XG65QxulLjElqrxItRQK6Q25L/eHQbJqi/xNSf5N2u7WjWfl9EgIsmiOE2daJ/wY1jeGb5y2DPNz7yLltD0fk/5TMtKS/9eM1O5mJrqWIYmJJ0UdrvKpeA0GfbVG0DJ2QDKUKFcuHaWfzdHunMqzXxYdmuQT6XPBqC0RvrXaThDou/WzG6wdrKrKgvcl097UqpzPB+thq52C3zPYUr1AjyqYvtPc040ZqunDUwOz5n2R3NE053hHLNIInQ4X6zBfLHeKU+mdCxAzeprWOP53rchA8cUz+FQ2LfQHdIjYFla6x80N8SxyR3M9r0DHE4VFafvBca6mWLjTIq12GUOq3+CMOma+csIN1MFuOUdoh64XJsT8YvwTbO27nB2/yY5vNdgK9iwZZ+1G6U7x1jGVuRv1mFKu4pEtwFwr/Iv75UbSPd7YADnaiAYfdVg7F9viy9NLsbk9vdyvI43HDe
 tsf++/H9
 rQ0cPM3VskaxuyNfygJxhB/iFqiNSV9MLo/BVsSVRhR6+JkPBA11Sb38y1BcGNPQa2/Z0JmyLbXzJ929eG01uOb8np5fvCCzzpOpmGb9WQ9in1cOHa2xriUF08ecplQLC/EstPohaNJVSPgNsfycpC+ZU97cR/s+1Abe0lm6OcEy8lzwsgXKyXBwRLle8N8vFwJzsibH7jEdn1zUWrkAUIXdeVj1h0cvrkNjMB5tzHw6jCynqNgkfctJY6T1HVNmDcj4HnWOl81Sp+bRQRPlquecn1HLNG1ayNYdUHS5H1+IQfLHhXcIgK/mEgA==
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
Reviewed-by: Waiman Long <longman@redhat.com>
---
 kernel/kthread.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 85ccf5bb17c9..968fa5868d21 100644
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
2.51.1


