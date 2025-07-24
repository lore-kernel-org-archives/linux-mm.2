Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C78EC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC486B0117; Thu, 24 Jul 2025 05:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BEE66B0118; Thu, 24 Jul 2025 05:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB54D6B0119; Thu, 24 Jul 2025 05:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D26466B0117
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:11:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93DAE1104ED
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:11:01 +0000 (UTC)
X-FDA: 83698588722.03.0E284E8
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf19.hostedemail.com (Postfix) with ESMTP id 76D5D1A0006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:10:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753348260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XvFRDbjQ2wBt5L3o1pcFZxp3V9YFlhNnK/5s2/vbHM=;
	b=T17jqHtSXZA0jGFrnLYfk6sILvZUxe9KjLEDwwR1k7fbIryAEwm9z28k83MouQCSOUZanN
	gpgxqGwpoPqPkOKtgl/UYzRiow4wmhuJ4/AmpbuO7RXzdqXkZXB+AUJL0cR4eI0/057BmZ
	v2PqrQlbkyBc61ZyIhlZBHx9qYtOuB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753348260; a=rsa-sha256;
	cv=none;
	b=1ueVBMr1d7922rlcTSg+jgdQkqG3PZabbWtj/y4i2UqKZhXADsuJeUeFhX3+ACWf3la74V
	pyq48JBjvRaphXnaAtBlCqmvBAH+LWCcYqDNAmxJTQq+TNkR2z0kpm1KyZ8yI1vHkDQEZE
	lZlIWgOjlvcLm09tVJiWy+s3mTshq0A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bnlY54VtCz2RVrc;
	Thu, 24 Jul 2025 17:08:41 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 31D9D18001B;
	Thu, 24 Jul 2025 17:10:56 +0800 (CST)
Received: from huawei.com (10.175.124.71) by kwepemo200002.china.huawei.com
 (7.202.195.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 24 Jul
 2025 17:10:54 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>, <dev.jain@arm.com>,
	<catalin.marinas@arm.com>, <lorenzo.stoakes@oracle.com>,
	<thiago.bauermann@linaro.org>, <superman.xpt@gmail.com>,
	<christophe.leroy@csgroup.eu>, <brahmajit.xyz@gmail.com>,
	<andrii@kernel.org>, <avagin@gmail.com>, <baolin.wang@linux.alibaba.com>,
	<ryan.roberts@arm.com>, <hughd@google.com>, <rientjes@google.com>,
	<mhocko@suse.com>, <joern@logfs.org>
CC: <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 3/3] mm/mincore: hold PTL in mincore_hugetlb
Date: Thu, 24 Jul 2025 17:09:58 +0800
Message-ID: <20250724090958.455887-4-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724090958.455887-1-tujinjiang@huawei.com>
References: <20250724090958.455887-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 76D5D1A0006
X-Stat-Signature: xi6o47a76wicdsqmgjhfn7kd8cwmh7hp
X-Rspam-User: 
X-HE-Tag: 1753348259-918227
X-HE-Meta: U2FsdGVkX19rafGFgYn+QHIVPvnIJumf3bckbVxIAzxIp2JRcOYrjmUG4C89yzecAMqbs/lvQUor1cUb0uVgc1+OhXhpY26BC2WgjHBidek1ySGnKddcOslILkT2kArlaqq0AN614G4jUDbY16/lYxi5+oij2vShsR/iXQOdtcqDju5N7rWfcsOb6C40sKu5VhS8YUnyYT4MOJfqp1f+thrZ3uRZhcX3wr+EoUVLL0o+qFWVjzTQwtpKoXApd4TDegL0Jr/R+CPGElKog6NrUqKe5NBF64fH29qDXpxqdp85UWtSTVDZhMjKXbPQHPN+lDc0dR/Piek48Yv+dyM3cDyNb9dk56m2Ld+UbZdG/9E+4YUaWrpdVmdSZ4AneSZRLo9Mlp/tIgqEreglZrKE9WTgwGW2PPjRvFjY3kpnBhUcUgHWHZdqf+9drhDpf79a4x0JibuHEFqKnAFaIXtqwJ0qpbAOwHhzbb80zOJlT/+Pi1gRFrIDSZuJoamiDrTTjEM84EDc5WwszoyHyPYA1vBAh3C+9H0GfTPDldodPWPaRQlKdHd0rJuIe3IYTC4KWadU+r5Lr5moZfKtk8ldfZhDBRGscKwwNIHpzcyF4/tATaN/DRWT2wEaxw6o0MgW41AjNg4hoXtlyqx7sHsG//5m6i9SQC6Zip3/BbUxsWUtcvTL/7Nv9WAxkBrcQmwib1uJJI0oR1/jo0KGTNs/EHR3eyzZKn1Wi5+b6iNFCfdo81UsTEwx1zVW9/SMhn3cTeRBtXRgl0+zzC+e3u/1hhEPqXBenqz1lYo8jekJeaZsBBNF7l9cYRXl8x7DUEfShjs9jOJ+mxERDBIyNlN7pkt8HIVUjY5qbiLsN86Nc+WCZfJTCg7ueMcjG7HNMMeG194THQUihIRvVY1Q4/QXblHYd+SynvVHp5R3YShpSbmRjqL3wk9yNf8DVx7TNaOgDiGRcLBkuB015q5R+p9
 q08W1kL5
 T41TLsloOUvHQtfpvjEo1ge43ZzDUFyzFmiR3R0EsjE6QYAng3YbvKnmCxk1k98WdPP62EkNvBPfNJKI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hold PTL in mincore_hugetlb() to avoid operating on stale page, as
mincore_pte_range() have done.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 mm/mincore.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/mincore.c b/mm/mincore.c
index 42d6c9c8da86..10dabefc3acc 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -29,7 +29,9 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 #ifdef CONFIG_HUGETLB_PAGE
 	unsigned char present;
 	unsigned char *vec = walk->private;
+	spinlock_t *ptl;
 
+	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
 	/*
 	 * Hugepages under user process are always in RAM and never
 	 * swapped out, but theoretically it needs to be checked.
@@ -38,6 +40,7 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 	for (; addr != end; vec++, addr += PAGE_SIZE)
 		*vec = present;
 	walk->private = vec;
+	spin_unlock(ptl);
 #else
 	BUG();
 #endif
-- 
2.43.0


