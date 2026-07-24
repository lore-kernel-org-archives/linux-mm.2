Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D937C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A546B0096; Thu, 23 Jul 2026 23:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EDE6B0098; Thu, 23 Jul 2026 23:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B47A6B0099; Thu, 23 Jul 2026 23:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C03A6B0096
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:35:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6E7E12026A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:42 +0000 (UTC)
X-FDA: 85022255724.28.508776B
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1993A120002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCt2pQrU;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784864141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLiqeUO9mMdZaSq28GFh6cxKKnMxg3tJr/8P87fRsfA=;
	b=WnJAyHKveJD5G/Lj7yacHvfxaHw/IbWTvWfW+9TXqq+vHHZPFGWv4bKRC7K7ccgsINJjIt
	/TOFz/imivPbmMx5dKAXALJ+7iTsWrGrotHlRnHslBsJEA5AcTZQPPQJ7frkAvJLDDZFkA
	awVtMgZg/APS01E848YShRwSxTRRFn8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784864141;
	b=D9JCYakXjj0oqzJJulQwCG3TD+K81Ttuleo2bITJrQvUhg28HhWDHBISHkSDasNLkIpuQK
	yzf+6U0qV/AZD8S1EcVAV3rMcVqFHZ/k8O430sBjtRJKzKqxH6sOELs5UdWMUzvTOe1SWv
	zd+vyAcRQN0U7eJHtPhxKgoVPRyvClE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCt2pQrU;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784864139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WLiqeUO9mMdZaSq28GFh6cxKKnMxg3tJr/8P87fRsfA=;
	b=GCt2pQrUbTmlx4yVyXFH0ASsg5aUHlJANAs8N6XYiWBfYc5YINhgO+VbnhZO78q0mlCUGn
	HWExiZoribs5RgKZz61QHFHBq8m1iGTdhqdkxSZmxuSjn8xvP+3wdZgz2nfr+gn8x0amia
	30wqs0QB1AXUKCUcM6ZbyceAhEN7SIU=
From: Ridong <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Zhongkun He <hezhongkun.hzk@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH -v4 2/4] mm: vmscan: propagate real error code from per-node proactive reclaim
Date: Fri, 24 Jul 2026 11:34:33 +0800
Message-Id: <20260724033435.2573323-3-ridong.chen@linux.dev>
In-Reply-To: <20260724033435.2573323-1-ridong.chen@linux.dev>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1993A120002
X-Stat-Signature: z5mqdxri9xd8nc5xcyzg4kqau5x9e7ud
X-Rspam-User: 
X-HE-Tag: 1784864140-301052
X-HE-Meta: U2FsdGVkX18NWcFFSkMk6YNt69QEAc/rq77qqX1VMvvw2Q4x+3ilml4FCG9rSITWa90a/Gvy41m06lCWum02ZeBa8ZNqfcn6ry51c7e/B3wneUkz56kIf+FN3WoO/L13B0Wj1UF4IrBJHXUuBCVYYlaK1Fyt/1pRfj9H8e4uKpp052KN2NbuBWO/x0McmnJ9k1NLVdsjgOiRPeHL/YT+6RPQWAypu/riRG5QF2ISpNfN4NmHATmRiJbnFnkpqj8Qq0mLMdT5+5tbptF1apwVju4Kn1fa8K3DwfD7SgPz1o1NJB5uX0kfEMdi54+x8F1F4QoUhaF5kM3aKrU4TLSA6a/ZVNvh627lSD6ickFcuU6AECmqK01KrXnZeIhXIWSyqP5EaV+Li7nQp4BlkWZxmKLmtvPEDtm4LjDxurrnMKFOsw9MZCWgumaY6Au4GTTewv2SohKgcO8/gSJMTlZFdnpegC8eN99kOX2Qmko9Df+/rCyI5XKIXnm34IbX0rD5fDqU/g136P4zufSur1h+trCxll2B3WNKa6rldKn9pPwxW79+VWSSw4rkyUbAQbgWLuSlZmRwiGM6llGm5fB6wUwGzcspwHXX13F1e6EOZuGRxWwkgNZsnv2n5WPxMg9DKNEivd24lWKdJPE9IMLloRYzmsvCVm8hhLk0wPnwSbRB6G+ohQb2fsREPiObu9WxL/fOBp1NiC4CdkIVtv9w+MdRtIghII+48CG7ccKVksVCAqpdSSJFJsvYl+SSNfKCxnWrseQG2koc2yl1vSI7m8jiM3Hv3FBUawzXQmb2HzfMHlJ4iJYJbrsE7pwByaeThdrg/454jNX6T4JvUFivcAKN1tZ+XP/Q3hMqug/xJ/j+mmhSctxTasr8pS/MRaOBS8goH8kJ6YGfOBRSaBzDTiTYMj1wH4M00+KkioBfLaB8aKKMvdd82hT3O815a1iiRlTMmnhkbplP2/czs6A
 KfpZ12Hf
 yiidDTf6BAoRbKA4JLCX1uITSkiiQUduYWUkKEAp5iHWt79O1OPBArF0JobADZu3Gpo0MBz87gjam3PUgH78uuy5HIrdVMuo6ZBkb3MBx01Bv4tBZCsbeZZuoOJaduu1vBtJGzrDRfWfDrlgtdGoXqZM9/PNRCebN6xh+MO1CRp4e1Crc9PU3hC6G1VNLGeu95FQIP5JYAQSSvhG2HJldjEw1YPmyVT7AfZSf+0qWcNJ7M4afaWn2gfKWSIG3BxJ8pxziaN4lwfaZgL53FykNg0kCEND58D9MnwVuGNsIgsWbvpyoK1zYHNUiag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

It has been observed that per-node proactive reclaim always returns
-EAGAIN when any error occurs. As discussed in the mailing list [1],
the interface should distinguish between cases where no reclaimable
memory is left and where another entity is concurrently using the
same interface. Propagate the real error code, consistent with how
memcg proactive reclaim handles errors.

[1] https://lore.kernel.org/all/20250717235604.2atyx2aobwowpge3@offworld/T/#m3514718be82a31b05726a49da9b61fbfc69a589e

Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2c689682b952..4b62d6304c49 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -8023,7 +8023,7 @@ static ssize_t reclaim_store(struct device *dev,
 	int ret, nid = dev->id;
 
 	ret = user_proactive_reclaim((char *)buf, NULL, NODE_DATA(nid));
-	return ret ? -EAGAIN : count;
+	return ret ? ret : count;
 }
 
 static DEVICE_ATTR_WO(reclaim);
-- 
2.34.1


