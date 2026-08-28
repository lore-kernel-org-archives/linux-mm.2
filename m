Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F99FC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943126B0096; Fri, 28 Aug 2026 05:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919FC6B0098; Fri, 28 Aug 2026 05:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830476B0099; Fri, 28 Aug 2026 05:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 671206B0096
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:25:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF63440266
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:25:10 +0000 (UTC)
X-FDA: 85150144380.26.4AC7587
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	by imf23.hostedemail.com (Postfix) with ESMTP id D8E5C140009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:25:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S9ChDKaL;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787909109;
	b=irrd+s1pLaXIiGEZvNd5B8fjDT5PPbAoeVk9yZqpb5btkKyfE/mfmVK66e5RY4SfoZTSzk
	16UzMGZBty3eSXf97C2WFbw6NUunp7AsZOvOfbrCQ1rlPPdBxOPhNh4g0CLrJikffletAj
	odZfX+zWtxICIrl7Qe/4kDbzzqezcns=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S9ChDKaL;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787909109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npBYA3khn5BUGAS8kGiA7fGPLj8BCUmEJ7r44dYwGPs=;
	b=GwgXlC7WtbxvLM8Kzwy3buas8D3kGjSeCUdlUF6gqeouuI+0IvP69V8GyYhH/kcrOFl5g8
	vz7i3RQvbfeBEe80haUwnt+/2//T493JtwPBN+/OgEe4nFVVw/B3aPqVhqCc91FGoraX+r
	VOCfAm3vJ3ZA2un3LD9URbEjOVwDR1g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dBqn/fwXS6Yqu7+OeooRTuVzLOlPePdPqVBD4zdNuTA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787909107; v=1; x=1788513907;
 b=S9ChDKaLDw1RrTJFJfcqJNeTpafUMPONVvbaQW8JqDshbUn0LnQJnL6RgjNKr8Q28oSO42RH
 oIOmhPqXy1J60mbKDF+3BJIHk3ZR/AigbVTa+TlmkrewN5JVFuvc41K+K6B8C4FsVfdpUIlwNN/
 noG+AmmaXTB9yQ7GDxneWt6s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 770e0ca2d72166ed;
	Fri, 28 Aug 2026 09:25:07 +0000
X-Mizu-Trace-ID: 770e0ca2d72166ed
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm/page_counter: avoid integer overflow in effective_protection()
Date: Fri, 28 Aug 2026 17:24:31 +0800
Message-Id: <20260828092432.1257917-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260828092432.1257917-1-ridong.chen@linux.dev>
References: <20260828092432.1257917-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D8E5C140009
X-Stat-Signature: 8t7597h6b6c4ak4cu5m1kc4h4taczmf5
X-Rspam-User: 
X-HE-Tag: 1787909108-798837
X-HE-Meta: U2FsdGVkX1+YmSOowKNihqWdBIwqfJz5wqRRgAkuM5wJWuepi+v6mXBW2wDiL2RZDIUSy2rh1/WPBYVW0X6pePn3aJVRcpbtrr1Gm2mNAaWfrBvf9ag3HfLGLAhhKtWJIVdlEW79VOzTWwqoO4ELStWmdC2F97HX0eBajQ+jvIZpidWy6ELwuMHC1e9JLP5SWhGIv1RwevOysEOS37/U7VCtkkmOuclVq59DjS/Sn+pLMcUZ11TXJIHEwJ5T5APWbZ25Pb4Joxai05LGYapBBw9yE7RTZmX+fbQVuawUVd601PxNabVTO/48d6++Omld85Ja5IBMMWGY5bHIeECG25k5ZhYzX/GxVq21uW0Tgf0ihqdqsHrUifDiiCTd8QCyPtuz7zkzriMfEyadIgF7Mhqmd8MMkklkWL0UyYpyYeqe91E5X2aLMZd3k+uN8+UlTPE7fw7QiYNXBjt6vPYaZz5k++cWYYKFT8BdD+QLOnW9YB4rcITEh3wcxbc8Cq3egOx8stQ3aXoHDcb7wOe/ixpdRb4UJI74zLXc4G0qac7NGCSOdPlUqjR1NdKyxWTGYuEWcUss+uVUnkqrrxnWdPbQMo1QPEnkfDveXrU2Ccgu27uCPiqi/tVI/vKV00XWiwSDq7UUOWt4xCrUhgifNXJGQiuGTJU7ScUWfWXohVNWWP4qVL0wObZNg6mTRzS5v1Ag3/pRzgQTZQnlWFEptbtqAsn69dZ4faV2z2WwaVeH2ACXXsRWeKLEHwq7Vsk5zx8Kht1a342b71cJxpTStjP7tMc/6HPJZdmPNaIuzwe/20vNh2oBkzrEb7v8wN8/17v6KHQqhtdORmiRsHJhvIkGV3m/5ojM3n3zG/XWhOfVkJDRYvqZDbFY2V4YQV34rhHi8xUx74QVr2ppvBMWG8PPAobe8FPaa2f3lwLv9z4nq+/EpKZtTCTPJZf8QMe3BvKFa6C4zymaPN2YclA
 32LYDbxm
 yEr9ezwwgSAfxB+jNOqeTIEuCZMmNA2ljA2N7ZOXW/DxLqMalKaqisXBD9thuSWpFpN4Sb3tvIGI2O+pYaULJWhdI1mXjrI1AFhH9kjEhVCgEQ/trHyqAVDznasZxmqgCbFR3S1blmKtO0DKPctdYMbmzNvYS9u4wlsH7ZhMYyC7MWw5YtKBUCiiMQ6xApfF8y52JienK5snPp65goNgs0hOHLMRb5RvNsyiGybSzcNGJ+Y8JlgOv3vgjUY/zQlWg2Idhy8weiMoVeM1L5IQahceocuBxJp2TVgxd2+VjElf3Z/mAfCsdkjVp1/AIIi7xohLd1Wf+6Rg5YUi3QdLhRNsnOpYrMo6cfjSFTZYN/nMtFVwsd2OugGVAgHY5U/maZSxfCngA//mTjHhq1bwIMnFZeApxIWfRVhJzWpJKEw9XORTUkV9b6Q9jxTgt4ndyqSbXQupV4CoLRnWN+kXkIzt0DXuJ5SKLw2r6WMcTeZnHf40Rs8NP/SoonhM3YCty93o6M0SKr3U1Yu+myZfOFf9zg/uVfB3PMDTnIRLPKExw0bAhITUWpXxPW5ytX/zTbvuNAo1xacJyXxM43Wl5gutQVbIgYBbyp4AW0AtQDuKN/C9jGvQuZSHn9G3+v/VnlzZGdKd+/IlmaTVbM4MJkoDvy4L2rgti1q/YwomSDnROfRgXWcjqipeNvXnILQGVXeX9kA4Z7DqZGw9n0KWfz/Cr3Pr7K+/r3reJgMXKLvST+gbfseWSjoU/JqCLTAaVX+O6cYpelDMdPdw9KYjA3CuCLLryMkBuCcY2f7P/BrD0RcvfacfFWcfNKpakLYpOCT9UFOFtn5GOd0j7XIR8FkF0aqTso17Tt7nDNFDtaFc/xiHgF0JiDnCVZlaYTLKIHlRSySI3/np0ip0eCXCiFCZXEJq5sU4v5GOp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

effective_protection() distributes a parent's protection among its
children with two proportional calculations:

	protected * parent_effective / siblings_protected

and, for recursive protection:

	(parent_effective - siblings_protected) * (usage - protected)
		/ (parent_usage - siblings_protected)

All operands are page counts in unsigned long, and the multiplication is
done at unsigned long width before the division. On systems with >= 16TB
RAM the product can exceed 2^64 and wrap, yielding a bogus effective
protection value and silently breaking memory.min/low enforcement. This
was reported by the sashiko review tool [1].

Use mul_u64_u64_div_u64() for both expressions, which performs the
multiply in a 128-bit intermediate before dividing. The divisors are
non-zero on the paths that reach them: siblings_protected >
parent_effective in the first case and parent_usage > siblings_protected
in the second.

[1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1

Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/page_counter.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..311153b0e002 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -8,6 +8,7 @@
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
@@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
 	 * otherwise get a smaller chunk than what they claimed.
 	 */
 	if (siblings_protected > parent_effective)
-		return protected * parent_effective / siblings_protected;
+		return mul_u64_u64_div_u64(protected, parent_effective,
+					   siblings_protected);
 
 	/*
 	 * Ok, utilized protection of all children is within what the
@@ -399,9 +401,9 @@ static unsigned long effective_protection(unsigned long usage,
 	    usage > protected) {
 		unsigned long unclaimed;
 
-		unclaimed = parent_effective - siblings_protected;
-		unclaimed *= usage - protected;
-		unclaimed /= parent_usage - siblings_protected;
+		unclaimed = mul_u64_u64_div_u64(parent_effective - siblings_protected,
+						usage - protected,
+						parent_usage - siblings_protected);
 
 		ep += unclaimed;
 	}
-- 
2.34.1


