Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569CEE63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1256B00BE; Sun, 25 Jan 2026 17:49:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8926B00C2; Sun, 25 Jan 2026 17:49:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6C76B00C3; Sun, 25 Jan 2026 17:49:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99DFE6B00BE
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:49:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62C6113B2FC
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:34 +0000 (UTC)
X-FDA: 84371979468.05.281B5C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3235A0003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d70jxwgb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381372; a=rsa-sha256;
	cv=none;
	b=ZvpOt+YzhQBaREc73Xa9ojhGA4BkvqGgSh8LNo13teEpGxzBIxGBoNjSL50T5+87GFme8z
	g65tOKDKEtd4YJ784wWkHJJO6xx8wnEuVxDWfS9KhjgQ2lO8N4+D1XR+/Vyso5I1A1Ynie
	2N/mKnr/OTsDf0dLff0MWmrgw6JoBqQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d70jxwgb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/H7Gz//2W7YxEQDiG5Fn2sVeSOYBxF3U1J+XksfESs=;
	b=XdbV9tDuPWuGbLN5rZueQtq/CCqRfTNMM2/kWyESuLHps3FIE27Mfx5gS+AyGRGCenrmt9
	zgm64zwXu+zjoK1jsaZyTMOggKNsVkOpzYzRZrVweT0j6S0hJafSwJy4AEdYCaA++bVAxd
	udC2U9b6nynSLVUP7oYBVQlV5Sm3bU0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E062940534;
	Sun, 25 Jan 2026 22:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305D3C4AF09;
	Sun, 25 Jan 2026 22:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381371;
	bh=OKxr66AuTYpmtINGeWatnOeeLWTfC6xUU/wfI1fZOeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d70jxwgbF/CNKBtHpaDvSsHZFYSPWkBvVnaAo4Av7c4PHeWTyYMkUFCWk1jjxGKNg
	 ixqOpT8qvOYKSjtsZSCMAxfq7drEFvjvij9M7sOtf0wWj+Pkq1eQNV9zAPnH2LLJ46
	 U6kk8bKaPMuJWDxKBXAF79yPSO65UoKLNwQx9uXrJSiRc7H0bx78/0545kNWuHswIp
	 S4GznnYh2O52k0q8L/eji+euYnCkrI0H2+gU/UbY7iY7yHVhxStXJ4Nf3l8V8yA0hF
	 ZIkhMGFhYHD8fmUu1Q2R3M0YoaEAcVq1tLFbqt3BP9IobTzV3xnL9TVhgs2t81yeWW
	 nwPYM711OQw3w==
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
Date: Sun, 25 Jan 2026 23:45:34 +0100
Message-ID: <20260125224541.50226-28-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B3235A0003
X-Stat-Signature: c8pro3feqcc9uw4kdox1yxzq5wcins86
X-HE-Tag: 1769381372-460701
X-HE-Meta: U2FsdGVkX1/wNmLXNiNiyF7SXdd9bMo4aCLuqWRYXlljUS8f+hNhrr/O5eQqS2j2NfYBe6+BjKhuJhfoOj5WjlGeHrbjVsyZMXymtQV33ykgFWRxaVDqgHjWPszDtGCnb57U06hr7qNbmFI61Gw18G0jB0Kih13JCCwttbqtkRpoAWVRAqKtYSUXZ3MsLQwiT2CdmE5ZZzQS1MaQr8t1OczbozK3nh5kjJABTIwW+I2WtqP/o03P1ixQUD45jYt81BI1ox2aNYtm4bFdajwp6HcNbYb9KVdXID17ggwVfT5MUvyuuEAfrDmoMWzlv3kazz4YiwxtOzdDDD9Ozf1nSe8BN57olCt3sCefrTTxIR709ZrBK3PC5+OUuWAckaVXLUMyCdOQr8qgoYbspMZoVkdaQn2xCNKh8E8FyFWUeswxDEJSNrXcRU2omU83vabLuxlx1rBhgqvi1DKmGnEd4+nz8TwPP92YIPv0NRfTl3sAJ6q9GOsPZGKC6po40Msq3LPwVgB9dG5+yOX4y9D0hLuuu/tgBsFpQqX+BHXc4PE+52sztCO8Afu/T72kWgnTQJbxXBRVt6EWd64huNjEQYluga3mL8iIhE99yQGbEq3ianEX/wcEG/LluTY8wEeghzdCg0ekASARGmVKmHmZlHHqCrD2djXVrjAM/LF5roxx2F2VYqzr8C0LOSdmbGaJIHffc7DWrN8nSN7Wy8eRmro0uRPncdyTgtUY8bnSdvE7H9GwTjPPbDwHApINVSeeIztcjk1OX4vhxZGlmJos064VczC+SlRvcmqpjTGKWos5mbjB4g41da+/5xodoG/omfpDo2oasN7O3c3MfMKNAklmG6/bF9W8R0LfdMeE6IkAqwc0gZlr46KXVNJSVUy3mM80/PHZBwQuSdD6vFCNQ7DwwoNXmsazjC0gwKIe80ADEaH2++egcj32vFxnvLNRw4EvHsRGTcKJkSNdTZU
 gsKzmlpJ
 XTynOvVQo3ViD6WzXH5fuudQNIz6hoFLg+le4BlnU1zlc5uVSMv0D234v8fRftvirEOAZn2GblDxSdbslR/QM2AaUZ+BgbM9aUo3t9N0/L+df2SKEmxRaJ5cll43TPgrpBO0w/22EwLOAQoKrfsD/0z5njQCyfBJaa0u6B4h247d3G91qJqV3qSw+WkqXXZCGIDN4XAoyF1mn4DqqFxN56K+gUjBppsAMkRHJDFQ2UhOryLnQA0MILS4UZSZ3v+2b4h7QaVgZioAbaEDfdT9/4dS5MJwJb+5kJQUYFMoKPmg6axi7pyeEcxJ7cA==
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


