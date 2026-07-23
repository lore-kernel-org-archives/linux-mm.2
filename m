Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EBE5C4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 04:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748086B00BA; Thu, 23 Jul 2026 00:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7E46B00BB; Thu, 23 Jul 2026 00:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6352C6B00BC; Thu, 23 Jul 2026 00:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E81366B00BA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:57:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EB6A1C080E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:57:57 +0000 (UTC)
X-FDA: 85018834194.25.DEC5C23
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf25.hostedemail.com (Postfix) with ESMTP id C0054A000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:57:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qZ8jpXD9;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784782675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLiqeUO9mMdZaSq28GFh6cxKKnMxg3tJr/8P87fRsfA=;
	b=RVRsunuBkXm16r3yBrtPjWahtllvPhk30dSvTJW4D0VlFk+VjKVTQxFMc3U+HDmAmTUcI5
	Eh9VMlP8UiPmbNK1fzgWXo3laalkYs/h1RRv8EYdVWoWJpe3VVb2ytq6tJn/DMdxgAwvnP
	Y3i2FJEpCCwS1HoO+HUYJ4H+Q8tQcwQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qZ8jpXD9;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784782676;
	b=js7AdZq62QOqGOhuDs6IRF8r4YuQDyhOPJaDZyrdfQbUyJne/oHlIRZ/Clqbr9DChuEJ5M
	ijRMWvz7Z4gcUiEBz/mjPEeyS/a3PV+K3zcJ+FWYENq4SIfIDNAB5j1oWYbAy2FdaAql35
	YfUJC7abrq0PvDPMEa1UObf+137uR0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784782674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WLiqeUO9mMdZaSq28GFh6cxKKnMxg3tJr/8P87fRsfA=;
	b=qZ8jpXD9Z/jiKzsINhUHsr9GRrPLHvZDhSSdFCyPpq39qCSswGPIY/vbjTFRxB63umQj0X
	eP/zls4gT9lgtuJb9rkufCjPnF5bbDeJMpJfqLzf8zWvV1IYen2aDuRCBzjrE1AycRy/Kx
	TS+ADgWXFrKBTwRmrrIMr9+IxT+Lwek=
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
Subject: [PATCH v3 2/4] mm: vmscan: propagate real error code from per-node proactive reclaim
Date: Thu, 23 Jul 2026 12:57:16 +0800
Message-Id: <20260723045718.2052070-3-ridong.chen@linux.dev>
In-Reply-To: <20260723045718.2052070-1-ridong.chen@linux.dev>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C0054A000C
X-Rspam-User: 
X-Stat-Signature: aa1a3ah1m1qmbqah67ndrtpeuhii6116
X-Rspamd-Server: rspam04
X-HE-Tag: 1784782675-611808
X-HE-Meta: U2FsdGVkX1/eTDviNohjerESwSPX2DwR1SwSggYPMzRAOZA+eEuRmeC8iODgV7teTR1NRfab8pyxFx+aaGv50zUG10Phfdouo7QnGrAcXb3ShjZ1r5nrzGvo2OSXi7S4RXBiafLUhNxi6UtIDUR+0dKuQ6jXEWH7CJQDGfVYFtZu0rH9PLxRpyGOxz921Gt1L4rt1CylJThWrHhWGBYAseAz7mo1bAN7YDACBAtj9GrTNMAsSdbRvg5C2BP8kgNKOCUJyaVk3EjFXdlGu5oGUFdLejMHy83gyoEHjcteKp5PHiH4Vmfl9huxwftJiKo3WG66EmqekZTNJkRFy22Ulq9icvdH1c0W0GogpyAGS/wXtu3fcW3LenLoBde9XKDJkt3Hf6s28xalLdI1G/Yl/c5g0Yc0fPW+N0yKPutIsBLSXvvqmYUSlb70nWS+jjSM92QKdXOMBbYemEWVcN/VEe/RrYLkrepIPCDPXPzEFUhtS46ry5iddTtFhxFOI/9JDCtK+EQfGdbxqopYaWVq4YKssmNKjtGV3VX1/DCf/4oOaV3rV8k+EImIv5YqUa11oT58s6vwqI4S9yNpOWFpZ+SQwouoYpdFjVkZRMuQQL/L0lHOZZrksr4KjxUmEfOGzRvWwWpZX7kvgyje3q/Pv8+V8YhID1i25zgO/aPKs+C89onuNKWE1sJ7arlagTiYjLMBbZtldYqEw/E2Kapb8OHQOQdMLwnlOZms3CjHgtQfh6KycvT9zcToLq4whgLGza5q9kXKejpaQITci7Z4hliHU0LPn7mF6fI7/4SJxCJnETKgk3UMpmphWEvdmTrdbO12BlV+Sbzt1H+VsdhYn5Ggoal4+Vj6iZ4HFOfzoLut5O3mmCe1s3Agz7TMe09WVnrr4ZrsvbaRVvig8dQ/8nHlEgGYc53mN67NqT20V9qBwRK2CySEkOwSX4UrlXR5Fy36kAQfg3qGl0zwbhg
 e7pYIAGJ
 +3WX8qLIGaijtU93pw3MoMHyREk1Z5aI/L1DQogHEEf4NB89Spf8OUeapAHLht6ywUc0oaw1DAOT0i7QSkUFD2SMDXEMBIzDVqVW2RJ+fwDF7918urntJnrFk8E5PEM36dl0RKgzKJNpfCdfIq7KQRj5l4svcV7XKjm2C4eZhAWW5UFuI/W2Vcwn2nbb66hwZwwZ/J2fctBVnKyGs2Bhlivbc3OBd1em/vAEwCJXX+BRL7oTPTaco4YwZy1nW+jEdahzI9IrmV/XxTn53iFPoRIZYd5j8l1mV4tqC3jXiBM2tlI4mdspYGZLwww==
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


