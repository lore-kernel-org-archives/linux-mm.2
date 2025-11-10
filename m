Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B637CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649A28E000B; Mon, 10 Nov 2025 03:19:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621548E0002; Mon, 10 Nov 2025 03:19:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55EBE8E000B; Mon, 10 Nov 2025 03:19:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40BA38E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:19:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C668B13C279
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:19:08 +0000 (UTC)
X-FDA: 84093997176.22.42B969F
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 13C9440007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:19:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B0dyRP4z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762762747; a=rsa-sha256;
	cv=none;
	b=8CvbmBr8p15IKikgP7KAbEqq0c1C4QGDvsGgCarb20vYuZ+frMoz/nmQDXDyovEDgXdvIr
	adh4QudAVgeWgqPzzQJZLTCfmE4BjTedMjysLvC5vhqrPQuaKfg7duIM95FtWfnzm77JIP
	dCllTa5p5k8G739B2gupqO5tS/tWg3I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B0dyRP4z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762762747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORWbg/QZ7k/YwOw+EM9hdfo/jfLOQNj4xWZcq69g5Tk=;
	b=NFtOsZUW3CAdewPAOuytURR1aUloQSiwTPoOwqRM217pwgUrA5jb31VzsqFLzLBFoQcvv7
	WXgoaPzfL+AhSo28J1BMmqh8GRkd8CxwGbb8QzuvQDfbbMWtz3AUiqvnqtCKeDBimbGmZC
	YKjl1DEbckEyYLEBCh9HfMhPyDIwZ7I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762762745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORWbg/QZ7k/YwOw+EM9hdfo/jfLOQNj4xWZcq69g5Tk=;
	b=B0dyRP4z53AScVJIQQmak2yHxuvAoCqppuID0nCCzRLNQ3fqvFkNRprnpcyaTpTQduw/+/
	FOm4LjRTjuekPdcyqEW4mleUB+0Hht2sTsI2i+NABPoC7Vka/dPageeuilVHLSSJ5YORUA
	g3v99icWRon3eRLlxefji7Ua3uW17fk=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org,
	richard.weiyang@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 1/4] mm: thp: replace folio_memcg() with folio_memcg_charged()
Date: Mon, 10 Nov 2025 16:17:55 +0800
Message-ID: <56624d537520e33e5a6b3755238b3dfb959a52ee.1762762324.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1762762324.git.zhengqi.arch@bytedance.com>
References: <cover.1762762324.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 13C9440007
X-Stat-Signature: 5t95dq8jybxtx65qb5tknb4kg3jfuueq
X-HE-Tag: 1762762746-169039
X-HE-Meta: U2FsdGVkX1+Pt1xLBRGYjMKwcgquvL2Cq76oSJoydjGgC6X9Cmosivg9X9KPpVTDhaZrH8rEK7UdjdMMOuUPpdtxfTGXKDFAGi9A0hIPmxjXGVNjr8s6Cq9VRMSvqKraHHmrQbFB53232kG0J1M0BsSoQMioi/ZT1yY1qOBnP0cNUSSIOglMhW2IBBwPUIgcQshJxwLMLohVp9OdMq/Je+KHUy3y3y/6UxczAQCqZ9u9Vkilvg/TicIdeHVJZzPE58gGT0uw01839OWpWzU66PKZyz+7A5jbtSM2+3II9n8XjIUwgwcGxZ3+eLFQvYdqj38wWcNuhCkm0qGJKXZ4I8bqCEBjDukTNwqypiWoTMf96n571tDujOPhYvyjEo2qv5ky0eXNP/R2fTSx2mChCussvD02do9uyEpePROImLXWopx6HIrrxTGk8sW3WVoM4napOJ7P6nZ9Y6IuNMbS5uHQSWwGfF8GW6QTVzlCLJ9AIvbOAipRmQtu3ilDHfWNvGPPp1i0nqovxoCJPSI6QmnUO9wBKgJnl/g7ylwyj4/xEQ0TfNogHWDl33cp9fyMLfPpvg8Nle0esE+z+E7sbF2v0XHfBnhKjIrKtSME16X9LefVFKf4B8TjcbjhBfBPxz758WT0HhKdiUWU8fH00+nOtbgAODnHIerSLXC30yurhkIvvwmQBf/iD5s+XSRLVLiTXOJtmFwzsRbuBJWKbKYZ0kX4nF8XcZZXT+/bHpk2nl3DlKN/K1JuGR3p3Gd4k5sqPbyEcI4lYXKJwnYS7Wj5HjjymZxlfU+7G+skqbnrbhATQBrK9kKFW2kimLzogKQAzowCFFCw7zyl7VXoQU2i726B+7hybCS1SMT5hadTjqmh9v/DYhZGQkhLZx+TR7lvUla/D/ngECHA9T4WjwBgu/hcg/PqbLj7mAI5s68D57hGRKa2xs5UThyjZe0oeZ/Ak4xSDlAtBTxBRUb
 sDZf4R+4
 eamjOQPsM0LwNn9J2c8zKIPclnxI3F2HxAKWUz8a1pdRWsfW/PbkQXHYba3ePPB8wYkVljsMgDOBMirLBNYejbt1E0EDVLDl7kZewWuLubGoCU3R8wX4ipZDo7xrhBH/JmpI86cc/9JvaumV/AdDHeZPwtRFP0csHzkJC2NsdwHM/GOwLzoQnlT5yFzfhgs0/App+us3PGnXYNL7g9FcOEzqF2UGgxmZ+BzDbingONRH7fNiCOm8VHZUEa3LQ9a9pMqEy5KhF9OnE9JaXAoAA/XvfkQsxqdwndPcwScwC9V421QHfvsVZ781Ki+sUkD6lx0w2ffbZ/avESIPV2RfNwnll4+dOvtjzMwsN9qEljXgB1Xbz/iNYLt4XZs6Gf3+tCdR18vYarJfegEPDcExfTX2l2JRYabk5hfmgt/69Z3o/kt2lSDUTl5t/bbij0gIFBxeg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

folio_memcg_charged() is intended for use when the user is unconcerned
about the returned memcg pointer. It is more efficient than folio_memcg().
Therefore, replace folio_memcg() with folio_memcg_charged().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 949250932bb41..84ef014b2c11f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4140,7 +4140,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	bool unqueued = false;
 
 	WARN_ON_ONCE(folio_ref_count(folio));
-	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg(folio));
+	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
 	ds_queue = get_deferred_split_queue(folio);
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-- 
2.20.1


