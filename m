Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D2D3C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16346B00BF; Mon,  6 Jul 2026 08:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6DD6B00C1; Mon,  6 Jul 2026 08:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6856B00C2; Mon,  6 Jul 2026 08:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96E626B00BF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:37:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3A181203A9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:37:42 +0000 (UTC)
X-FDA: 84958303164.29.E4E229F
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf04.hostedemail.com (Postfix) with ESMTP id CC4564000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:37:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YinHWbqZ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783341461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XcjJCQ7WOmAP4qXUsDLNV9IJzWl6RyrThMLDcVOXfcU=;
	b=VqSff6UwI2h78IjBzjJ0FlgSDVlNTkbWBpp07UV0oc4ZLPN/qMEs3Rv9jHC7K10GuJMvUS
	cRABLXXIRTQOdQnYC4gdHeT9KdKdgTvzzfgjcwZEoafZ4HxRASAcK3M0C7QHM/oRinQ9gw
	DsFZyshwEQOdhg9OEi3iuhW34NL4Xmo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YinHWbqZ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783341461;
	b=yN1mZqDHL7zO+omB0/OqENvCCvP6YN2dneNCxinlz1NsIO3zIka7PYrq81yQm0hUVzubSS
	umRil++O5jhBFpopSjuVTuQT7zCl9xIu9loM2xEvrohG9mlF4aXcLdExZGiUQxvFuw9qPZ
	HYAPBsQI1P35C95VllLjPLDSBSCwuX8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XcjJCQ7WOmAP4qXUsDLNV9IJzWl6RyrThMLDcVOXfcU=;
	b=YinHWbqZeRk/dXs+INd3Ti7tLZUCUJnEozuknBbjb7SrB79m2FF+T6qYADJUVvkBhKmia++2g
	SEsSdyYWhf3ZCzmH2vJdwkuMNFchOamLQfedfbvoBMlLbNneAdCooppjvGGqJfXvYGU/k+Q8Dly
	rPI/p/pOOatgoRplLHDvZ4g=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gv3Yb0ccJz1T4Fk;
	Mon,  6 Jul 2026 20:28:35 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 22D6240538;
	Mon,  6 Jul 2026 20:37:33 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 6 Jul
 2026 20:37:32 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
	<ljs@kernel.org>, <vbabka@kernel.org>, <jannh@google.com>,
	<pfalcato@suse.de>, <xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>,
	<linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH] fs/proc/task_mmu: count KSM-placed zero pages in smaps
Date: Mon, 6 Jul 2026 20:13:22 +0800
Message-ID: <20260706121323.1149847-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: CC4564000C
X-Stat-Signature: pry1m9oditgdio7azdi6zn4q9hbsxq1d
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783341458-977104
X-HE-Meta: U2FsdGVkX19Pz7ZZsRKmJzf8kqnciqjb+e8lNl3vWS0/VNhhipqapFFMqJikVEoa6Wx8e/+3PyinUgl1AUV1eaw9Bl8Ewzpu/K45bt3MvJZ5C7IQLPq3Y+CCiblp7hvhNWb3+rtspJyInBVHprWAhRxPhp9pr/Y8ZwzeZGMSNhTzAQtOCRt4b8CfmTKa3Nb06VFZ7cPEmuXafLqH9/ibB9bVC7syoR0qvqdAruWCpkMKp8A7MOdS3AdYceod2WnnC3129Gkoih4+vm8plAh7Z+NpqfeSxnSDQWawOtRcV7wmI69w+BX0Ge+sUHce5aBeSyIRsgWR83eDdZQRuR53iojkY84D1jA01+KNwjLcdcz48Gvk+gpFDSpGtQc9BpVyisjCbtdNLIoZH6R/zqWrjENpbqK1KziEVj99jtqoRke5jB2jSVz2iNLq7+DC4QETXhhtu6P8hhKlK1zIfDjbfx9TvC/gKxgzTh1/skVDWcpumLPjORpFnsb1u8QOTVHlRzxE2VrvJ+ey8VzCOgRfTuYyqOi1oa/Hd2jsQlW1792aoviD2xL9WgZN1mJrRZG4GDvIL2AzmyAb0omCCRQEzt2K/3/5LbKIgkfyWfTLtTEh9cp1uZrNTjtYaKkWwLIJWG1Zjw1UxFTtT9axduYOqb6l3XdOy+MnYe9TvfQCxo6PVmlg5ES7a8O9MVoIeQqLuqhoxR0/A5lqDK2SCayzsZI7EjpMH1OVTHjU7jSX7qS7+Evumin4FWxLdJqCGqQfr7XZD1O10X41awdvphny+2q3kKC2vvn+fet1OKePAeZYUO9qBLPqzdSfC41tmVn7BpgXPY5f/xoZAfIHWIJFDhVfFAVpCUzTFGnooMQ4zmIwEKpIMXl88KG6ApLJ+M8sb7Nf9gayNu7Aio8Nf4Zgfnx4DxE+r0gWwKafb2xQczCGJKG8qNbKrRBWa+YKPoa9fUYFwvD6CQUO4TqMQCN
 jeWl6nGs
 JAOqZp2SbwfrLigDVQHe/X/sXnt8pwo8M0whkHQoYdb67zmPeHUod2srSsNpXGqRSJlw2gCjBsDtAkvc+jt5cTuGx5nlRR2sJCEdDAr1Tzqdej3lS/IV7v+lCjKbtP3dKFI14uv9cyBpabWif/kzS67r7C/aP53Q34BL4gTI3iqL9cCm1ntV5qO5Fn8YL/SM81QjAqlEVBM/K95PxWWJKiB5eFpRs3c6mslTrziDr0cqfKrbe5D7nu37pGNBErrw1cr4fRYqJZBpNWY28BbMoH2PSaGsoyT+b4b1IhFcFjinZxnSXrYL/R2VA5X9plvV5Px9ZmDkxDtBVj1g4wLKSiHoxpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When KSM deduplicates a page to the kernel zero page (i.e. when
/sys/kernel/mm/ksm/use_zero_pages=1), it places a zero PTE with the dirty
bit set. vm_normal_page() returns NULL for such PTEs, so smaps_pte_entry()
bails out before reaching smaps_account() and these pages are never counted
into mss->ksm. As a result /proc/<pid>/smaps and smaps_rollup report a KSM
value of 0 even though the region is fully merged.

Count KSM-placed zero pages directly in smaps_pte_entry() using
is_ksm_zero_pte().

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 fs/proc/task_mmu.c  | 3 +++
 include/linux/ksm.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d32408f7cd5e..3f446e9f59b6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1061,6 +1061,9 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		young = pte_young(ptent);
 		dirty = pte_dirty(ptent);
 		present = true;
+
+		if (is_ksm_zero_pte(ptent))
+			mss->ksm += PAGE_SIZE;
 	} else if (pte_none(ptent)) {
 		smaps_pte_hole_lookup(addr, walk);
 	} else {
diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index d39d0d5483a2..abb41b3b7f4b 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -127,6 +127,8 @@ static inline void ksm_exit(struct mm_struct *mm)
 {
 }
 
+#define is_ksm_zero_pte(pte) false
+
 static inline void ksm_might_unmap_zero_page(struct mm_struct *mm, pte_t pte)
 {
 }
-- 
2.43.0


