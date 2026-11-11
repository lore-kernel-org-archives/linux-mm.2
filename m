Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B360F606A89D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CrJBR+If
Received: by kanga.kvack.org (Postfix)
	id C493C6B05EF; Wed, 11 Nov 2026 18:27:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20E16B05F0; Wed, 11 Nov 2026 18:27:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E086B05F1; Wed, 11 Nov 2026 18:27:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96D1E6B05EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:27:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 388A540403
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:21 +0000 (UTC)
X-FDA: 85424426682.20.E21C037
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 875E840011
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CrJBR+If;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439639;
	b=gMlGOBygC/LiEpOTOL1YF4HGqpr+fUmEQabr05Ryby9nbaOVPqsGQ0O+ZbjSJ5b5rBxIHh
	65SgmkR7E9wMIBuccCX0Eeezk34gtxBKoBxKdObviX0Cgp+RT1NbJev65QyKUeFFT3sT6V
	vRabpdS3l0bWBsaJ78zb5QWlZMbjfFw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CrJBR+If;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sz+akw3wpRLgZUlPI2FoNb4TEGhdSTFiLZleLq7ib24=;
	b=oIPqKB2o6knt6sDzUxK/jmqEmS8nGtuW17iBjbJASbeV+Bh63p96pGbWKlKl2+MnHzTV6q
	DgkT9dHwtaxF/3yU0rYl2AOqNoOfQOAb/fxL/mqYSoNUQwTDC9ctDOkiIeRIXcM2dlYBYl
	VD28wWnft64esoIREX4fd+1BXWrTJZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D842E4051F;
	Wed, 11 Nov 2026 23:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C6C1F00A09;
	Wed, 11 Nov 2026 23:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439638;
	bh=Sz+akw3wpRLgZUlPI2FoNb4TEGhdSTFiLZleLq7ib24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrJBR+IfaqoyJNKdiShU+ukvgr5AzAPtScOFfDV3LMtgKdH/z91frdPGeNlFOl9CU
	 W1tVXZv9mF8cyKGslV4MuftKxocEVdH6+HpLBhqimecDB5SESeUJ/Eu3FqPYVZlOS/
	 ubrgq+nH9EtIPP5BDkwMvtwWQk9pq2iukmv5Ndd+x2YddhaIJdqNA06uZvkkJHxqtS
	 gBYvdO+kFNGBgujvuacy7FIYZyeExvxaRJgMoTVXxlgf66+3IuA7OqgqMwDPmJ8444
	 fG3xW3uewZ8dBA4IYizJr/3VBTho09J3y24rUh4q+7hG6KlQXI4WfZKNLjWe6ifJRn
	 4w2Aez6EAP7lQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v7 13/16] mm/mglru: Reduce LRU lock contention by shrinking folio batches in inc_min_seq
Date: Thu, 12 Nov 2026 07:26:00 +0800
Message-Id: <20261111232603.9934-14-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: igkxgsx5epbb7udybo5jgbdtm5te8kn8
X-Rspamd-Queue-Id: 875E840011
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439639-730657
X-HE-Meta: U2FsdGVkX19Lonq1pUIRpOEjCZtHzDwuGruFLxvYLsTpvo3uO/gZdGS80y+ZDImhNJz0b09SgQ3AYw0yOxb6vdgKSRhVTsNRhFSeMn2kzTaNQ7ga/mGcpxsWJRYmUG5+ptsBvzYhoPZp3Zv4Idwmxth9kveWSmucW0ajfBUqSqpAvBQnkpT7iMXk35855nmglFjIPWfibcHfrs3JdtpSYZbjxTMqYpioTVC3SteeI5tVCrSiEWQPscCX2iVaF9w5lmX05J8fgySmqySSL52djPEy3tHQDvFbTbHqqO0bnee6yejOQKLQHirriS02u5Euq2pif20R4frYFT3eEmxJJMWc5+a1ReE9y45A0sXi3GNf65DEyMLrXSQUVg7MERbK9YLawNmMsDBRq8n9Pea8/Lq2TVSimnnCHMVg7L5fWmGHV2mVVMz5U/p1iqZE5M9aUvNemuhWUTBitYDSPuZuJJZlxVOL8TxcMzBISe+3GW9XvtMpi8nKk5zw4FUXzTHKL+C5kFRCHvMFI1/uxuwOtbFG1R1vRV9FQHuexaON74lNjpcFyVRTSrkJvvsjwvJMKJYf5qqCmnQHME91HAAWz2q7j2X446ql/2yIw9mrYY2Rf+wPXOr2Z1lm4nAXJKxqqtlRmm1PVD9L1iHjX1qWcBkiCv4GmY1KC6hnnjMx81N+KuHJ/Bk7zAExxUv0QMVHx5aE8FIjss0a0bKgk1xgLaL64iqSJC3+EDJAb6I1Pdgi/MaCFM4zWKfdpOuYJyoXKY44Sug2Ti6GInq3SVTWiNZ9fxE4LXLwt2wLaOA/8kM36/jltRDVyD/vP7+iqEjWchQ8/8Do9ivmEPhiC6CRKh/+3dFW+I8EPrFjGf3DSx3ET1abEAQQhH6lqwOEiEn3RbFL6/Z7Qhv3yqLuuPbOsPUCVW/JDfatwk5CuXWw7I/W9hC5uuvjsxFE2vzOvsI2UmgzYmBmUYPTlut9z06
 qn8SAMU8
 6KyVGUpoWIgjNVaC4/egSP5Gp24TsRTP2S/o0sMtA0t1W+auEzMmxKJ8Eg7NuTzoCRGvDsGW+fbcbFla3vk4yZL7ZXMwa1Ej4oZ/pa1zrInFYFDPlRm9XUARidEow89pg+1An+jxuNUBGZm/iWokdjH5zex5chsVKT300GaqUChsN8VeEesb+6JkbDunLkCwaVBAPzXGSfDOTvsA7aBNVI6gjtYPUFASEwHDUYAc9uyqH7m4RMnhWh4iUkqHsRBJinGia5XPJdPqfgeU55yWUiK32HMlk2IqotHGQXrNyWH3Yp7NhlZR8+KoAkiPynUHb5crcZUlDsRWhMobbvl2KV50QFBIlity0TpPzIJY+10CKVtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reduce the number of folios moved from the oldest generation to the
second-oldest generation in each batch. This shortens the time the
lruvec lock is held, allowing concurrent LRU operations to make
progress and significantly reducing LRU lock contention.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7a48b82ea4c1..6315edf50376 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3911,7 +3911,7 @@ static inline void flush_lru_batch(struct list_head *head, struct list_head **ba
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-- 
2.34.1


