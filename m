Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2FF3103A9BD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66EDD6B0099; Wed, 25 Mar 2026 10:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6462A6B009B; Wed, 25 Mar 2026 10:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584056B009D; Wed, 25 Mar 2026 10:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47B9B6B0099
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:14:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEEC8140921
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:14:45 +0000 (UTC)
X-FDA: 84584781330.30.C74D6AD
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2D31214000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:14:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IfW4H6mh;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfBsoDL0TdJCX01wAdt/UD4xIx2OOwlMqUeevckOt8M=;
	b=4//yjFLhmtOJUi2uCWSeJcNayV00gTQuAd76TQp80yXZPURA2LaiEGg4Sh4ddDseum8wte
	JNR/bnYBvtXniG9E70NNwAiY1nLDaRuWwrFNULTcCeiMgOmsr44r50eQ76Ks0Wun0odeXQ
	Syz4KvM5uEuBk+SLgORwpUeqXsG7q6g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IfW4H6mh;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448084; a=rsa-sha256;
	cv=none;
	b=Na+MW/tn6K0j2a9XP2SWYOEoIt1swWIhZsHoxQzGHUrqg83JwfoyBUWcbTsCyqMRONf6fs
	Vxu3cxO+A05Dqa5KiOuOmJHIx9S6Wmx9MaHu85cCMnZpH1FrkWpBeHo9HwTEB4EZG0lvKG
	I6ChJrVaJAn+iHdTKkCxuR3YcGMW5a0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774448082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GfBsoDL0TdJCX01wAdt/UD4xIx2OOwlMqUeevckOt8M=;
	b=IfW4H6mhNJCubVgaXAbZu9//dP2m8TqmdlOA07BDlu2eFkZzJDy4Z89jxVfVbR/1/gMIl9
	zCYGnGFEchRelxAFRAOxy44bDZK5T6Ehs3pLozBWFivDbUClgmIWGyFoa6McxTimHmRfMc
	Ud3mYvlHZBeL6mnT4hpLIGoiLDdSTDU=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH v2 4/4] mm: memcontrol: fix unexpected massive positive number in memcg_state_val_in_pages()
Date: Wed, 25 Mar 2026 22:13:25 +0800
Message-ID: <e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1774447069.git.zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 6hzu4iqtzqbfznqzfoehbm7iyzgkb3uu
X-Rspamd-Queue-Id: 2D31214000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1774448083-347304
X-HE-Meta: U2FsdGVkX19YzOEwP3wxM4cnpGqdP6EVnHqCRMb0CvZczV81q4fVPrpm2jcOhWhrI4KaKRdQm0uCJjduhcElIpc0JJb1g7iGbKhaP/2RBHewIKQPTZXu9o1LSJgIMFVm+2guRGyhYhPxdbDpCopUhUYtKlRSwPNv8zefmQL44dQM7/B+E7JcpONFV1EftuZPCmmG+9xuBKWFCNUojAGGxs7U5HqdAcExjlCJZNY1UhElnEm33Dg1XQYV+y11GB70leGnv21/TMA3VEtGnJ8J5G0i1livL+EU5qugSQlGb13sjKuMhzYAEN94VKiZfAavxuQAY59/3Ldzi8wNkNbkrJlcVOBGkJXRv6j6AgST56tJZdgk81OnvEnS/dL3mepZalll5CK0/O6Yr2olSV+E8b59CuPLjkRtD6OPOyFv8YqxWC122TPcMtGBegNErDt0gLx+dUXZp6NsEy+MM9BmwyW9pu8O+40EEBpwAyvkVNBVsmtvgvx7JW7Y3BQSTKte3oM38GIpcWKwCAubiN2My7kx87YYvxA49ma83FFCiLTgR3Oea+qjNz4rOoT4cxhLBvdIahSuObcgKgvDUYbuiOG3HZlat/M6eOni7mlNDgxhf1Jm+pzgWq9+Yoo3bBgo/eJgcYY5fkLxLQt2eSHtvFnyznwLwtcfFf9fKBhZR+/oqLroRGZtT12lCMPqK8a9R1UfdiBFM34zcoIe7pgVVJGaj6zYUwuhQRhUK0z3ggOZL4naokOw5LrO3ptatxR2lsNdRzX1wNSPlcUz1OHiciEs40pI9UXNlJ/0BY8bPj+6RVw7/7ds6zqs8sEvCbtgfFBZXGp5UsDhpeA+UZ9wwp5+RqSWBNBR5MdXke30NkNHtdQSoRwRfk1OcA+0A+By4NNNph/sfRuGZBUf6Kz/BKtJGElGQcMs8o+ZzwM2MsGwNiTEht/HjAp0ZTM5YeasNrnQa6iotn0DT9mCDSQ
 LJhbR0E2
 eJ75jzanoQw68hJTnBP5aUFpDf6hvyFZ9rSsCJ1Dfnnv8JvGWgntH/aE6cOLYRfxJnda8fQai6N2/XuHSFdxNDqxjFGE4CRjyYxCimdklnEvhF6okh0DUGnm+jCRdpJaJqNjXUG5Y4Bt0+PDPO4A77KpIph/zw2FrIXLU6YjfX2Dl0SGVaJP5cRguHU7YpETnNlfk9Llet6lrQyVU/EBQgMLU+FxEs99KMaUHD1s1SiRMv8FZWO/Y2L0vKsq5fFl83Neo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

In memcg_state_val_in_pages(), if the passed val is negative, the
expression val * unit / PAGE_SIZE could be implicitly converted to a
massive positive number when compared with 1UL in the max() macro.
This leads to returning an incorrect massive positive value.

Fix this by using abs(val) to calculate the magnitude first, and then
restoring the sign of the value before returning the result. Additionally,
use mult_frac() to prevent potential overflow during the multiplication of
val and unit.

Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/memcontrol.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 04076a139dbe3..0c249255ebefb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -787,11 +787,14 @@ static int memcg_page_state_unit(int item);
 static long memcg_state_val_in_pages(int idx, long val)
 {
 	int unit = memcg_page_state_unit(idx);
+	long res;
 
 	if (!val || unit == PAGE_SIZE)
 		return val;
-	else
-		return max(val * unit / PAGE_SIZE, 1UL);
+
+	res = max(mult_frac(abs(val), unit, PAGE_SIZE), 1UL);
+
+	return val < 0 ? -res : res;
 }
 
 #ifdef CONFIG_MEMCG_V1
-- 
2.20.1


