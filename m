Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5628FC4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5266B009F; Sat, 18 Jul 2026 05:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C7A6B00A0; Sat, 18 Jul 2026 05:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395D66B00A2; Sat, 18 Jul 2026 05:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14E736B009F
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:54:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FE40A0361
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:54:22 +0000 (UTC)
X-FDA: 85001437164.24.CBA05D6
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id D305A14000A
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:54:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dcdhmu96;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784368460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3ltDvom3/qAw8FbUiS3p4apXbK6gN1G2ur4K5UNTpA=;
	b=aP2eUMTlrTtUkSrvImIxL4mAOQiAPyl7/DKeF0CTv7XpGfPuWXdVET640JOW5aUQmP8AxP
	sA1R+KjHJvC+9VW4be3LvAjnoYL1dVwXOIMHEVaKKEPc6H/awAbNWAKDfOaatbd+LTBMwd
	GaR0pJ5KRNB/VrW1NzENey3KyCFinAg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dcdhmu96;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784368460;
	b=cEONvTKJpnfeYiN4Os7UaUzc9l26rUdAPJ/SsBMSYn+ds396f5Z+2njDZxQTLSw0odQOT7
	LTrAdchEj2y7nmxTSuM0cUQUqLvY3rGeUe1C1B2/CmQlxgo1JkI+k6FAt1Uepw1hFQ1iWf
	5yAcP3J3Hah0IUvV7iO5FJrPEWflSCI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784368459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x3ltDvom3/qAw8FbUiS3p4apXbK6gN1G2ur4K5UNTpA=;
	b=dcdhmu96Qo8lUZA4Nqrn4+MdC0HqrZoWIpF8V4mR4juUWJXtbnXjebaQ34mUNoFJcz2VsB
	m9wmvCYR4Hrkh5fWtlsNOt7eyV4CG1L2CJ7FVqEBY4bSEXRbLzpyChRw4V7Um1ZregR+JQ
	Y/fOp/x2m+X7tk6YsmTUXM2DP2drA0U=
From: Ridong Chen <ridong.chen@linux.dev>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hezhongkun.hzk@bytedance.com,
	muchun.song@linux.dev,
	dave@stgolabs.net,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ridong.chen@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 2/4] mm: vmscan: propagate real error code from per-node proactive reclaim
Date: Sat, 18 Jul 2026 17:52:49 +0800
Message-ID: <20260718095251.82937-3-ridong.chen@linux.dev>
In-Reply-To: <20260718095251.82937-1-ridong.chen@linux.dev>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D305A14000A
X-Stat-Signature: uw6otn8koi56rfpwc5pztb1ugur53j6p
X-HE-Tag: 1784368460-89696
X-HE-Meta: U2FsdGVkX19sbFS1S8XJG+DxAfTqaoun+PZJxtI8CmquUHnzBzJ1sWkr7G49lMNKH64Yvl+b+HXQnjxWZdt4nDZ+d5VPXNPispRIIPljO7ns7I4T7MFxPRgrqe+pEnOvg9a4/KYzYLLOaP6AFUav0bnEEQaYf6UCpsJ4gpBC3YjBNcGJmpFwoXDQOd3B2iwtMsgtG/GAgQsVb8PR1JK/ybvvNZQFbnFq146U+jNPheyzwBQl0SUD3sE65dhcBn8I+RtgaRu2nYWSBnM7FTo9+/QiR8Oz58qR/lezfNtKD2hNLlt2lSbv2g3IfZDSTuDAus513oFP/k77ti/nGMCouXkrBRAa4TmbXHHPIlmhr9u8GpR6hkhs40Su1jWCX4qJ6rPavPGi22IDb7FG4pYj9Dlv/pbSU1SgOqfb006771nJdk156EPTNd4HrTBx34DsPzd96fD2RBhZn1RZ+Wo3/HJZbeKpXq3w81sENNQExwDTK72Cx8RyMhDpyRPLpZf1i0wNC7CFD8Hx0eEvRshEOmOa5HC4cZzz1VqXXjswN2Rtj8M4Vdp0fcr/ieyxNgYYXzYtThKpPVeFVhkbINWXtYmJUm9w1Jj1GOndrz4tc0kX/Rygra02gXMC5EJ4Po8LJhIZIjk1gShzXoposlEecxUcLrKG0fzTM3cuzBiNOfdxyF3yXa1kQMARTuQNC460gBNMl3qT2PzdClDK3++dwEvvyQwLx/TQPKJB//p9mqjoWhA4djWfa9ZqDXTHXMl4WZOZwN5lxqbRr3L++ZMusEQkwM1LUVt0dCcLyaAaxkspAzLMm2MLxPGA9BEzctGt595/rK+yD1DjXgycF3TYdXihaS4FBs81mn0L/LsA1GruBoCO0iaPrkfoifiezDmQ2mIMvByU1N4DCt5CTFJMM37pnpoEuc/jU6gSBJ4jZPkn31t03+Kovx9Ii3JTadER+NEyHxjBFPzva7DlNYv
 bg1vAWmk
 dpjkOGENxLWBpikNcVTWgepKHeXb1fFoIzZGdX6L4gKATsDdK8ddjaz6IdnzB/7Ay5O7CTL8ZXBA7iZOfcJhI5jc0AjVyHXWFUAK86MVt2zpB+iM60Jwqt7xjeA3xoTVoQtX2DTEf/1P0Z62ieU3Xl8ZndvakJ2b9CG0g/Z8MCfMbooZvjjnxLTYYq5xEtnfRqiJbiQA2PJj/nFtF4C7HXTTNXPSbGiNLa5/RER6dli2PkM8U5Isp+akbluDi2RqjObndLDrem1cqKrBbxJ1+rjjPX2ID5ghtoj1GjtQtf3OmzLIgryhLJZi/Ig==
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
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d6b383d96a0c..cfe4556c96d7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -8017,7 +8017,7 @@ static ssize_t reclaim_store(struct device *dev,
 	int ret, nid = dev->id;
 
 	ret = user_proactive_reclaim((char *)buf, NULL, NODE_DATA(nid));
-	return ret ? -EAGAIN : count;
+	return ret ? ret : count;
 }
 
 static DEVICE_ATTR_WO(reclaim);
-- 
2.43.0


