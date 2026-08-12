Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 941FAC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8106A6B00B7; Wed, 12 Aug 2026 05:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7D86B00C1; Wed, 12 Aug 2026 05:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700CE6B00C4; Wed, 12 Aug 2026 05:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD686B00B7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:29:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D223A12012F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:29:22 +0000 (UTC)
X-FDA: 85092094164.01.FC14467
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5D52440005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:29:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Xe5mp+T0;
	spf=pass (imf11.hostedemail.com: domain of liuqiangneo@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786526961;
	b=ojWNx8AcFUnXfWEXpzlE96vnph/ydSGTJqTdNlIjQbNnXh+9SrjFyIqZlOPXuloAJ2OPIS
	HKiKHzWAG7LxNsa0FeAQ0h1raXRZLHhbpteNvq8sJmY20OuleHG18D4RJwoEvyxTjXIDQf
	SnlNoC3VgVHroEu9jIXO1HbMPQFSleI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Xe5mp+T0;
	spf=pass (imf11.hostedemail.com: domain of liuqiangneo@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786526961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hX48ssPHsQP8j8lGLGLWAzja1k4ufXko/jDU3I4YxOM=;
	b=l58/YrMaIrAlMkG1Ni506MEijwwIfHO4X8gv19zbdxi6dHvJcJ+hiVd0a6AdhaoPRsUga9
	y82HaJOiUUtKQ5LaWneLNCyoYDDKauere2B479eTDxk/DmLA2H/ekupeiqeQI92p+17DFb
	j90SXd8w6vJgbatCqj6gnhFaSvd6nEk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=hX
	48ssPHsQP8j8lGLGLWAzja1k4ufXko/jDU3I4YxOM=; b=Xe5mp+T0V8EYB8CvJM
	EH1oPzKX+ap2MBHXsZjhAyzP/tDTtZ9WzF9yE8lWCwTz+j2dJ2XkKw+extGP+nHj
	sq3UTCxgvBh3dKjdCrbCo1NveMhV/TyFI2tkOyUbi7punJa2LgblOaci6afFP7M7
	2P8uGwt6S9DK4ExPVXOAooMD8=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wAXa1DbPHxqXVIaPQ--.57380S2;
	Wed, 12 Aug 2026 17:29:00 +0800 (CST)
From: liuqiangneo@163.com
To: akpm@linux-foundation.org,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH v2] lib/test_hmm: fix garbage pfn and wrong direction in devmem fault debug
Date: Wed, 12 Aug 2026 17:28:56 +0800
Message-ID: <20260812092856.55296-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXa1DbPHxqXVIaPQ--.57380S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrtr47GFyUWF1UXw45CFW5GFg_yoW8Jry7pr
	48JF47K398X3W3WFW0kFs0y3WrW3Z5AFZ3CFWDC34rZay5XFyFv395Kry0vwnIqw48ta4f
	ZF48tF4UZF1qkaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jOPEfUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC4BwAYWp8PNyyLQAA30
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D52440005
X-Stat-Signature: b86pdam96q7y799wpi4s6fijz8fcim8r
X-HE-Tag: 1786526959-588868
X-HE-Meta: U2FsdGVkX19bi/3HuNKqYuf6dSCqqaDdNhb7uQwyr+7KH78ZJrctJw8IJGiHf3wETXYTXqYkXFTca9zmMmkaH7zGgk2NnKQJxtyCnZ6QC1fCAo8UHmMdFQBh5+sa2xUUjRsv/lThC2ed9EC0qNnsnNeIY+IO9jwYSBi4Ozmzd1qyVxVYf+WydikiekDh2oLGVx/cOaO9Lj+mjSEAP+Bj4VtxJI3RJOiC1c3vgWk/SQ0mcHs6CXjd5OCHwQvNt6deCYKOnryqBHGM3AcY7MeobQL/wMHSaNBxk1qDGE5QTKoG7ihJjOawZVM8PnE+TX8wCdKIelJxMSsvWBSUAYJLMyfPuBtaygCOnVZbmHifxh+22TSopKaoiZf7BVJqGQgoChXx9hKQNnSEaHNNOzCIFBYoGQ7QV+VhoKKTQ8Lj32bcJuiCUMXlRm5NcHekEER4rNQOrAygZ8uUu0SzRV+uy3PUMBeLDSoTAMuOCI53uCLYozG3Rz7LousIZssI27nFnZ05ziFbYV5B+ADWbJiGWf42UMO5aIRamgxGhFJ2wU4wnAvhjQ4u9DLV/QEaw4NEjqShYwKko77LJ4cQ0VU6NayjeoNk33nQqay0b/uZ3qCsRQxT9jHbwInjQWf25Vk18RkQhiGtjRD0DLcLVx5W/eYeSFNGg/XXMaCE+FByQWlhuFEZEQr+8rVXaI8QbnWMYIuiBuOZHKsTbD+tmGrRxLzB70aq3sHPYkRvDa8cdej39ZpYaJP9C7K0PgwtT4dgK+WCfxGLqF+l533oqQlgxmI9KQNZvD99/pJAYnvu8s1y3yzVf2kYfLxX6wq82sr4PdMxDoTQdzlq4vnrkVkVFGDrAld7AVi1S4hEf1h+b8qjU8IWNYAKwE+A6DFCtAucGk3zmATEqLy2HbNl1Bw9qdShwcilCslhaotDrkg3Hrw6DxF868S3bMEai6A3Es6/HvWp5SZfwLOKt3KOvSc
 odZdA9JA
 4CMDDTDPSBIdshrREiVuHaMaSJea3Sy7tSVaIXP8Boj3haS7JosHlwtbzc9Ie7weMFR28YIuKvvrwgRHwDAGp4fHDFP+rvya9LwuYiovcvV435L5wIfhHmItZqq8VvkMzAoTh+f3yfhT4zDg4kYWIIiaQRMRG3ehtGj1GCaHTbl+/U9+JqLzeBrIas8zhwclopRm2TZc4BfbWXH4XAIryTHspZcd2f7ykoUVqZgnVLUemHUIRUS3a9fu6tipBb/FkxxDYBCRsmcyXfLiPjvgnES9gu1bo+ENHf/PkCkyBBay+a6KDPWe1Lta94VtRbVcSnkJvYEi5hdsdJfWt2APG4Ihdf0f3zSCkeaOU2U1M5IyDi8ZNU7KmouB5rfQs1bjx6TMCqje2Au58h/mz24uc+xiW+ZbZ9EJcK+TBcavGguzUuaHgio2Yje2lvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiang Liu <liuqiang@kylinos.cn>

Move pr_debug() inside the `if (dpage)` block to avoid
printing garbage pfn for NULL dpage, and correct the
direction label from "sys to dev" to "dev to sys".

Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
v1->v2:
- Rebase from mm-everything to mm-new.
- Change commit message.

Link to v1:
https://lore.kernel.org/all/20260811092256.102101-1-liuqiangneo@163.com/
---
 lib/test_hmm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 6205fb313bd0..7c4d10eae6fe 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1151,10 +1151,9 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 		if (!dpage && !order)
 			return VM_FAULT_OOM;
 
-		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
-				page_to_pfn(spage), page_to_pfn(dpage));
-
 		if (dpage) {
+			pr_debug("migrating from dev to sys pfn src: 0x%lx pfn dst: 0x%lx\n",
+					page_to_pfn(spage), page_to_pfn(dpage));
 			lock_page(dpage);
 			*dst |= migrate_pfn(page_to_pfn(dpage));
 		}
-- 
2.43.0


No virus found
		Checked by Hillstone Network AntiVirus


