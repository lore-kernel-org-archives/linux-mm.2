Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89590606A333
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jWoauCfG
Received: by kanga.kvack.org (Postfix)
	id AE5BA6B05CF; Tue,  3 Nov 2026 03:01:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94B36B05D0; Tue,  3 Nov 2026 03:01:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D22E6B05D1; Tue,  3 Nov 2026 03:01:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80B116B05CF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:01:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 134EA120326
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:31 +0000 (UTC)
X-FDA: 85393063182.09.98EFBB5
Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3F97A0010
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jWoauCfG;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avBDojeTtqVdC12fvsBVa2erBplXlUMS7WzAD6rXRAg=;
	b=eYZjAm08yxyiW1AABmd/lmQr2qYStoULIU6AsjXId2HGYuWXSXMtMjDTPF0AMr3NlcjOUU
	JfaDRBdhh1ercm48C6fyQbvOoMkfH81p579P8Mxg6WpZVFr6R281+Hl+3HFoKn5wAGkkj2
	EzVip+8LtEyxg0mQEblMy475QIFVG1w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692888;
	b=e4q0RHJl3hE3yTPPMVYKoy0Shfr3dUg+gxouN3Uq4YdEyMdD6cE2kbNTbWoo8JkSLqbOSE
	IOEVZPh1ZOi0SHLQP3MNxDjLfqCkv4z/bmsjx43uYl/XNzo4daGGsD6eFRHwIpQDy28zHk
	BQGzCfiJm0i88NwPf1ZlpePkd6G+qqE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jWoauCfG;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PWiNWmetA1DkyT9l9rdGAugffi5Wf5dqd79+o7YbD5c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793692885; v=1; x=1794297685;
 b=jWoauCfGTO+gIny/5CNf5uG05lZ92YPtEogZpqH/yyrXY+mQnsDxi5XzvjDt7Age/HM+1BQR
 ZD80ADAroBsKP1RERYY+NV/PQiLrO9vx8H4KGgZ89TGve7rAkbGIgLlPFg5FKyXALTnmznIsbuz
 PBVM6IukCnCVdd9Dr4f/EX7k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cc10530678a8dbff;
	Tue, 03 Nov 2026 08:01:25 +0000
X-Mizu-Trace-ID: cc10530678a8dbff
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 1/4] x86: hugetlb: disable default CMA reservations on 32-bit kernel
Date: Tue,  3 Nov 2026 16:01:04 +0800
Message-ID: <61eee83da19a87337e68a7747fc0b89ee5d0393b.1793692578.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1793692578.git.zhengqi.arch@bytedance.com>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sw5xemeu8mu5k1ucxn3i3udbkfkxukjg
X-Rspamd-Queue-Id: E3F97A0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793692887-522062
X-HE-Meta: U2FsdGVkX199m7SC42Puj25cJhuwqQo0mFkZ1XtrH9e+N5LQ4uM+/ELifmBLT9WiieqY5BXqzWG99jFufGx/sVfXBvdjI2RtzyAEzhE+bhSuu18wUoQGLIubsYYVFOdcEtxlQiW9tgZk5ZPhrXCWJxigUBcRnfZ+ZwAszzrFW/9bHnSfifI/QjTrGe0qLif+Q+81gEh0bKu4tuBWmfOw0JMHpBIxyeDpIG81vHcGKPNBg1JQkemFe7k5WRMMbwTMCGVmG81Kgg04whc1EewG868ZEjfLBXisF5s84VgSDHCaFhZXLDL8IAGuup1ElCDQNnPfsjrlQgICEyLwr6BvXPhU52ZGHZJhnwrv+8+//tfblYEYlLGiVcMVRV5Qu0q5Ezax9NX3eYuO0c0nZ1qgijp+ktrh69Fk2RteJZQxv/KyjKNollUy7Tm7tmVmF7LTQbIyd1ObGm+tl0hhxKmbY0RDl8VLt7vLuGACXyaMhfqeTxjHweEfcIVI0gltHxq56WaYUe5Mzr6YeSYTE/cM0XhZ5ibcM1MyKMazvp2mwb7xOl8Wmc6P0PEocT1lxPidb49doUctGFlWnMl0vyf8kMZowC9SQz/C0jkLTQ6va2iGNsAVG9M/IdLx/wHAFPU/tott3j5Po3GkIwMVUd4fEgHfjRZ8JebEs1Tx2BpEN1TuQHILg479oy8AoFCtMQcD0nbEgdl1A18viHZ7y99mHr2zkdWGjBvnbnk3PIASohFRIJfK9m2em7pyXCLfx80ZxClCqeMDdXdUngnGiL6f0PTtq0No1ksh+RxtwxHiRU7jqLrpyQHX6FpA6yTMfbHjrwWyVCIzJdqrzE/+Rwq54xzcw9JTmqwrZd2gtfJQCGuDf5kNgbrkyhtfKrVa+m+2/rSz1it9XPp6o/pAlyRQ3EDRPFgiQ4eCrYvqTxWy6VXBLWs3PHKuSuaY6guE0BYJlISCx6RreufHedZuSKc
 xqcqQy/j
 VMXsswu2e3evSop0ucb4YsP+AYU87Xmfo78hU6FqE8hDbnljjmDKjcypSzeYnwHHRLBSgEghbXplY92SteZutTC6njOe8/qwBmPaQDUnokfkFfWlUU32nrYv48lKU2/HhOefFmispzmzK3b17fDf1Zplvmvi5xtuC8dUmeOYe9I0+ibNoFrEoGQ7IWEwWEhp4vFhqIVLbpAQDrnfsfQ8qVI6VtZh65me0aASo/loHc8mC4nk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

A 32-bit x86 kernel can run on a 64-bit-capable CPU advertising GBPAGES.
arch_hugetlb_cma_order() checks only this feature and returns a nonzero
order, although gigantic HugeTLB support on x86 requires CONFIG_X86_64.
Specifying hugetlb_cma= can therefore reserve a CMA area that cannot
serve the intended gigantic HugeTLB allocations.

On non-PAE kernels, the folded PUD_SHIFT yields a 4 MiB order, which is
equal to MAX_PAGE_ORDER. With CONFIG_DEBUG_VM enabled, this triggers the
VM_WARN_ON(order <= MAX_PAGE_ORDER) check in hugetlb_cma_reserve(),
warning that hugetlb_cma is attempting to reserve a non-gigantic order.

Require CONFIG_X86_64 as well as GBPAGES when selecting the default CMA
order to avoid these ineffective reservations.

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Cc: stable@vger.kernel.org
Cc: x86@kernel.org
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 arch/x86/mm/hugetlbpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 3b26621c91286..70726a99ede7b 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -45,7 +45,7 @@ arch_initcall(gigantic_pages_init);
 
 unsigned int __init arch_hugetlb_cma_order(void)
 {
-	if (boot_cpu_has(X86_FEATURE_GBPAGES))
+	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_GBPAGES))
 		return PUD_SHIFT - PAGE_SHIFT;
 
 	return 0;
-- 
2.54.0


