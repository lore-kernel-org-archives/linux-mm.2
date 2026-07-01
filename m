Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E20DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA3A6B00AC; Wed,  1 Jul 2026 10:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5246B00AF; Wed,  1 Jul 2026 10:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B4B6B00B1; Wed,  1 Jul 2026 10:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5066B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:41:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A67761C32E0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:58 +0000 (UTC)
X-FDA: 84940472316.17.B0FAA98
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf08.hostedemail.com (Postfix) with ESMTP id B50F0160011
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tFxfCfxo;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782916917;
	b=nSQ4aPwS0ToXwHVU+fCTDz/mQO6KQ/+rpVgZR51407GqWPM6JK5+A60620ndaTPGFMlfeM
	plg410S56RW+BIMHmZ9jlPpu7MIpvOkbL7DbU2dmnpqPX5iLNSkD1ah/5b06RmNpq0QHk8
	b4y96QGcNzGyYC3THRqCGe1S44frk3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782916916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXT0BXeN52unYGLTKHtB0FksmYHnKb/7cFKsRIfO4AY=;
	b=yow1Zrkmq3pFicHjTwpymZmu257c/KA1JcSaKGZEkzbvqzcgTaO/Cuo6KpQYokn4UcsTAh
	spbBkUZoBYdp8sBfS6rLXD54RXN5fxAvBvYFJQ839Iz8vw8huBtjC2oIkP2TKecTmGmiq9
	HlJCz8DtC8HawBbHSlRMrU2/UWa3pkE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tFxfCfxo;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QXT0BXeN52unYGLTKHtB0FksmYHnKb/7cFKsRIfO4AY=;
	b=tFxfCfxo6ZIhEAKej5jBTqKDuQEGacBD3ZFHece2IX5rMD9AFNxmeHu8Vd5447r/fEIx43fpH
	AVFC7omNxvu4T3/sDGmSFBOeOsDlAQBFIVUb6df1RNmjVe7wTJ411sbmLG/gYg/hCk6LDeLKdTA
	/P7M2QWr6oKuNEitC8MMIrA=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gr2Xy0XJFzLm4j;
	Wed,  1 Jul 2026 22:32:34 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E318F4057C;
	Wed,  1 Jul 2026 22:41:43 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 1 Jul 2026 22:41:43 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH mm-new 5/5] mm: mincore: improve mincore_hugetlb()
Date: Wed, 1 Jul 2026 22:40:47 +0800
Message-ID: <20260701144047.3786939-6-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
References: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: fhjfp58g38htun6sc9q86pftc1e1t443
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B50F0160011
X-HE-Tag: 1782916916-701736
X-HE-Meta: U2FsdGVkX1/S/eeTLo4Bx9z4jdfGF78GWbfLe8vMASxQj0UseK40cOP94NnMqwbHb+x+ivZ6KI+bVMjPVFgH4P1LcfXqmMN6eNakdxy8aWVBANKdOjh/caKpOrY7H/X1LW7XbLlDNDBWn62jlyb8M01f+EHK+aHCOrir7zRAaCU2Z8okPcGe7G95bXmypbHepJti5PvEObvVVnwnsO2S6MsVr+dpaCKP6/Pkt2aF7i20EAskOO92OgKYUbsq7sk4/bYFEuzPBhfe1W4UvT5Mjpj10Zq685eJz17ERNlopzxlcDGnMKe/E48YbWcS5hPGargneU3hjNWezB6pLFLc+JnwtTL7SJvKhF/e/FFk8OkUyrgb2pA0tricGSUn/jPt9VNrKsBuxD19E092WbMkRM00rW7Ns59C1SWbM5QERUqrzNolPBhQp11wA24aAG8lciVEejFRLho3qFWEYremyhcuvhsKrgObiHD8uBtBMV9Bg1z1Ze5sPhtqZMIFhFzNjBlODDY1HUsRiksaQ5OFjdYJ+lxaNY5YopJrCiATvAgEgP+cELmjALd3ENKuX7RNJhF/tDLwDQ3ij7rzvqxLAOSoa9s9JWP/8MIycWk7f8k3s8hmwo4bbo9Ar4VQYx36kf2BACF9DFFu9v1mdm9lLRpcNp9IX6NpRZ2RE5KfaCB7f/dLSDPR6PJOYg9K4dCcNUzLEPpXMJ09N4MiYwS3cCZTVyuFrTUHI/LfHR/KcE/rGrO6gTqJy4ZeLnTGBYv0R19/LCKdHQHM4PeBCv/zNOCGhGoaHp1BtPFlKyQ6ln026NrkLv/23iJTPA45hur1VyCZkUIKxVStEunm+BNtpFh1UAVCO7epfmSA+Am4fqTH+8tf7QFC5TftuOBD4ivL7nxbIdzvZNbwpIqKnB4DTQ2+5QUFZxVkX5k/0fiYGq8b+S6gFxE79SyBbuJpnshon5whIFnD/Dwl4dK5R2Y
 UYmkWlAg
 7crw42V0hyqKAol85m3eedfD52+miPk9Ppm1jhRZckmA7b9rK+bDWwJXUCjbqDP3cHDi2JCxK4sCmOB3TpkoMHJ9Dcro5gVOXX/CQ11ywIxhIdiBlbQA1HlvBllZYAUPob/PIwXKMT/6+bW+71VRmyG1eysndlfOurdGP39ZYvCVgBn9YQm9E3xAqRox6Nh+yGVzMSHA0vL7pl+VSq1hkcOnBxpLCWkNC1QFHY4mF/RgCHcWTsi7znDasrhlVEPW+Ios+ScQVMVn1HJP9pi+QS6xU3b3PdsUpHt1XdK72WLmetG5dOAslTsVXpUJrgqQaDRyJjr6BGU/muZ93lPaWcjINXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The walk_hugetlb_range() always passes a non-NULL pte, so remove the   
dead NULL check. Replace the per-page iteration loop with memset() 
for better performance. 

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 1c72cc3ac87b..1a2568734e34 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -29,30 +29,17 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	unsigned char present;
+	unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	unsigned char *vec = walk->private;
+	unsigned char present;
 	spinlock_t *ptl;
+	pte_t ptep;
 
 	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
-
-	/*
-	 * Hugepages under user process are always in RAM and never
-	 * swapped out, but theoretically it needs to be checked.
-	 */
-	if (!pte) {
-		present = 0;
-	} else {
-		const pte_t ptep = huge_ptep_get(walk->mm, addr, pte);
-
-		if (huge_pte_none(ptep) || pte_is_marker(ptep))
-			present = 0;
-		else
-			present = 1;
-	}
-
-	for (; addr != end; vec++, addr += PAGE_SIZE)
-		*vec = present;
-	walk->private = vec;
+	ptep = huge_ptep_get(walk->mm, addr, pte);
+	present = !(huge_pte_none(ptep) || pte_is_marker(ptep));
+	memset(vec, present, nr);
+	walk->private += nr;
 	spin_unlock(ptl);
 #else
 	BUG();
-- 
2.27.0


