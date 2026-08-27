Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83161C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A9D6B0096; Thu, 27 Aug 2026 05:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC0B6B0098; Thu, 27 Aug 2026 05:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710E86B0099; Thu, 27 Aug 2026 05:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE6C6B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:18:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A966CA0372
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:18:39 +0000 (UTC)
X-FDA: 85146499158.08.DA8C729
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	by imf10.hostedemail.com (Postfix) with ESMTP id A8F28C0004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:18:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gW6CCbBi;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787822318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gQfH1ZAn9qvc0kD2895Ijzw9Re20623cupWQo/8nrxU=;
	b=gmd7r69XKCmQrN0BSx/Q+Hien8p5S6VhhNHQwXvnAZjHRJG9ezAtDOBZK5NVA4mdY6JxF9
	Mpi7d3MGmZWywU8BaAMItxM+WuMSFE+0FGkufXPD/gc0yTmHqRSoWTqDg/it44GFTlsVkr
	IvF4QQVULnbqRMhj1tBtqR0+xFO+aso=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787822318;
	b=YqdxCLbd/SLIIokQSscCJeFKdzvg67qpAYFaMRItIB/BZDcYnh5Ka1EhGXG2I5jvaq9vL9
	wLPJzSL0lQWbPn3uygIt1RG0OmLYh8IJxJBVtmGQOB+7Z6SmUN2985Q6f8UQ/huZmXeUnn
	jlIznAHOH9ZAaAxUIV7Spif2nkEPnsk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gW6CCbBi;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=geZOW1WODXXVi+0e58r8VoYK2l317YOTRPYNa/62Gi0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787822316; v=1; x=1788427116;
 b=gW6CCbBiyjVh9Qp4y0feZ2bOqcX6iQ3ILUlfboAWZ4qdUvgXTiPMTdpjB6YoxFF+qC4Ub/dF
 CaB4u3ztZlDRmDTWuoXdboKUBmWmtAbSGD544cIx8y0v3R6Qzp5hLeFoMjgxM/Y7bEh3ewABewJ
 lU6RRiTJw9oicYbKjBM0crUo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 75b3eba5054843c9;
	Thu, 27 Aug 2026 09:18:36 +0000
X-Mizu-Trace-ID: 75b3eba5054843c9
X-Migadu-Flow: FLOW_OUT
From: Hao Li <hao.li@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH] mm: memcontrol: treat disabled memcg as kmem accounting disabled
Date: Thu, 27 Aug 2026 17:17:50 +0800
Message-ID: <20260827091813.22327-1-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6u9x7im8sj7fdm6xr7p7gpod9ehksibn
X-Rspamd-Queue-Id: A8F28C0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787822317-40037
X-HE-Meta: U2FsdGVkX18D8jHiMcfRIpHLbZCiSfqjCoCb8db49o3sgQ5JmvA9nOP6zJZmTo4gLDTXmJiQE3lFr6iqWGRyJJELxutTAJoqkV7wo452kvDPpfqZksNKF2SSOYrx3fv7+BCsGWgDNLV32T+187dBm3tSK+rv+25mnlASemPb5LB1qXcLQHkMgr+uQVdbbGnYYNku1mM4Dp6rIepk1v4gZYRZKqgrrLe+ic42AmN1tFbuMOdghbnE9OVWQtOlD3c8PchgycxnEvaYxOtOrXycNG+ND/TOFYS02prtPzHb1uak73O3RZA2mQFjo9dfbLdesnMfsovGR2u9WUdViUs5dTEAt52pYcuqANe2BsKKnFHiybpmOZ6ou48bKKRt4yHyl0lUoxlvlIJHES8LIuU9Y6K3pn4cZogzUkmktmxVmz2JY+GZ2Le/ar8vah2wRwIvZ7ZY9UhYiPz3RgoxXTvWqLQXDYPxDy5Ur1mS+pI3zHHrrpL7Ia2tJzh6HSXot2tk1VHAVo908zZULMqyMzxhlxum3W/P7qFo0WlX5GxKM7JziPeqH0tpBYPzRFm8IzKGa91JhQVj9574kivQgimQlSQFRChGb/4v90ZxSTPeXQsNIWRWmgb5cTrUHxoaxc7ZUOVbCbL0BFuvh+IvVBr3A3nR8eiQbFrwzp3xLaUeKNaIVeqS/N82HUgRVTWyLD60rCGQYMqEMWyR/GvEyNLw7BL0H3wDanzxLyBmBuLOHD9Sz8HQ5As/f3rmUV76eUsSrUaPp721cNxSFB1TffBitFEcsf/cnpGoG+IEfFyoB/MsMEe5bcJM7Z9+VPeSa6/YCSlJKnu3RkPo8xP21aR6cd6mY2EBnRO4UdvmcezRnxy/e1i5mlGwsLkMh1D1ksDCG9ncEayNvgq1o1/dgxKax6KHS5Qes2ayIJno5VZTNNdcNPBXwvRgK/YmVezAQObfTCwnPHH6lRQqzBeiv3o
 LQ5Jxs2j
 nd164/7pyOyi1+ZZm5LaBCG0FUws/VStEMncKkVTjvhNp4GcRdOmPVKIUOEK93OfmmVM7soWqkXrXk4xrQiauncTP1zLYL2lSQR4OXCv/dT+DK3IT7J5Vyf3bc2XM0dzlFQ9gBegjJ9tIGItdybBRAnKd5ivRN09bwtmNsFOpHgKJQApLJaD0q57mUfgvdA8snknkOZpf/ZC6l2v+Eo5rX4dTlmek4kFI64Tj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_kmem_disabled() currently only checks whether the
"cgroup.memory=nokmem" option is specified. However, kmem accounting is
also unavailable when memcg itself is disabled.

Check both conditions to ensure the function accurately reflects the
kmem accounting state.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ebceade4021..b28f6165c354 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -132,7 +132,7 @@ static DEFINE_SPINLOCK(objcg_lock);
 
 bool mem_cgroup_kmem_disabled(void)
 {
-	return cgroup_memory_nokmem;
+	return cgroup_memory_nokmem || mem_cgroup_disabled();
 }
 
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
-- 
2.54.0


