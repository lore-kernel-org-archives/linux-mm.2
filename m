Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E27CD583B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D00E6B009F; Wed,  7 Jan 2026 06:34:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DB86B00A0; Wed,  7 Jan 2026 06:34:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4986B00A1; Wed,  7 Jan 2026 06:34:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9B16B009F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:34:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EAD158344
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:34:25 +0000 (UTC)
X-FDA: 84304959690.05.BC0EF4D
Received: from sg-1-101.ptr.blmpb.com (sg-1-101.ptr.blmpb.com [118.26.132.101])
	by imf10.hostedemail.com (Postfix) with ESMTP id D82E3C000F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:34:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dSNIvTeq;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767785663; a=rsa-sha256;
	cv=none;
	b=AVvvi2KynOiIHIp3mqz5ZdRPa4MbBEENxGyA7g+IvewnSqwxInJnPf9jSIBWEMvDq0Ezeb
	g6omFa5oZ/zz6GBztblii89hTe2vMvIyafnqa+QaNXKZJU4jSWk0YZT9ugPlr6rWwaQIme
	eaWorogofQv9hGCsxZvrRTDMwFh5FHw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dSNIvTeq;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767785663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQGsuo+iA51rKHReFsoIiKz498AYBUnjfg0gVNCR4mw=;
	b=AKy3HqZ3ly5p6dPkxIQN7TPTY2D6rBxTzQy1v0tAJc9F5uE4FxaQr7pm3YXQx/wTUHN/5l
	7406RuSdNK77UwwwokbUUGN4u16O6ZKyCCVY3EcX+dhMQlwSKIceAKZxHwtN07uDSAqBah
	Ld/Q7kxIS5wJ//IgAw6DmX2Ea+HWcqo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767785656; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=pQGsuo+iA51rKHReFsoIiKz498AYBUnjfg0gVNCR4mw=;
 b=dSNIvTeqojGMFDN8IC8DMsdhS9EEmH2X0jq3KlLwWu6X6qMZZ5Sd4aRqcwxPZrjulQDdSs
 DaHfm2fMpvJahZhqz2+xtXHwNkO+7LbrtKEtgNulKDIiFJtnjw6/pa+PsC0OJKR0xSuIiy
 upumWCdoFpLJky9kx1TskoDENnpHIQ9sLyNynyBvqXF8lQcmK7a4afuVnjiGDHsEX8IXsi
 RAETEey2pViXlddvwMKUL/30oQD0sP4xss0SygzEs7HMRhSsXUIJSlStbBcY9q6vHR2lUv
 ZYhC1PU90pPgd092DDUNaqKPfdse44n2QfEx7whshrVzq0dmsrbIVFouX4vOng==
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
Date: Wed,  7 Jan 2026 19:31:30 +0800
In-Reply-To: <20260107113130.37231-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v2 8/8] mm/hugetlb: limit event generation frequency of function do_zero_free_notify()
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+2695e44b7+ae423f+kvack.org+lizhe.67@bytedance.com>
Message-Id: <20260107113130.37231-9-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: D82E3C000F
X-Rspamd-Server: rspam10
X-Stat-Signature: pijqr4rfiz6rahr1rcze3rxfmhbo4mes
X-HE-Tag: 1767785662-100560
X-HE-Meta: U2FsdGVkX18ZPkhvBNWLlme4XoJlUMpgAS2onVs8skrCC7Z2/3Rucd6YR/O4ntywHsDzsuw5tqMymlWJUvaHEykRmxK3MdBN/+VynotKiK5OfGa+Kh62vPb0Vh8YjH31VOGt0bSpjAeEVoNEJxbe5WSvpAdRUAXrc0yP8UPhpmU0/hb/x/WTnHJ7E/fVNV1qwsuIDNCd5F4YILmsz95wVmOLsUjMxm/gquQBvpTCKCqsN1/5rCY6wJjJUjRJIjQw7rK9VMN8LT2ZFXMSXXK/uLIHdgtV/LTUUhYD70vF65H79x1PkZS360RsgL5rfjf8unR3yF6Fhf3P+F6xxABSpAeWMle0okPSylfe3Gwenf4FSInIgSsaHFhcnNJWvTZZFNxpnwi8GLnhQ8BZ86AF2EQBlI4Zzrbk9NpRdn4vlFDR7G2Ls+h51zXkwgwnGiC8uahC6VJTgyJYaHcj85jYDcfErC/6eFy7dMIaEfO591UoUk0b2Mrvk9KoYRCwDvDaNYayAQ6KK26Fw7Ez12Q3ZKP8T28/ItKYiTGNhR3BKVWrWCLvZQBKRKgFreqzlxzBiVuR1eNUIq9kZI7t8GSEiZGag1uC7WuH3OeydbNBbP8rkMtO9CIa8bkKpl/t1kpgMY+1QKcARiBQ8xXSseyRHzCfDRdLHJVQtzpX51GiV7zZKogSeEENTp859fa55JkSHsGmwG+JdIUT9m4ONn4exEXV+rS0QZLEDkxxqhPCkXP2A9ISTysSww3KIVGK+hmO0oqbTQ++N1TduUnKoP9cO5v2ZknfHso2DQfOU09VNNt0QTfoqJxHN4dPMoYw/oxO+4FYcCxZLvAzzErIZKvgIhyltiFj3XTLMn4y96+Yhx7sEEILTaDPgC4uJUsH9xhZW1dranhZkK/BC9xOvArLuqLgPNUpyvdb5Mn6U+pFDFUKWLj6kDNjLRhSH15+FzZBEn8b2SWPJG3KJlFPcxY
 rmj5/Uos
 PIm7kipNEosGU7HY9NVa0eNtMEaHMmsMwaY9+5afeSDQGD9rwnfipZ/5S3KPuUIBxN5bvh1w0w44THkWBE0MsOsugMPvg4MtgFiPpZuZLk2JfEhdHTRzzkpFKXtbpV2RwFlqdCU8Sh7TuQbhWwPPiXF63hgTJWXPOMpbPrSyeLIZjp708EYyGVn6TGQZTXbFLpDqXlYQ15hO63jV/HBnWKfovNRmMlJqfQDzy7F05dgmKPWpeOcWlH+1/w2B4PexjV6/LEzjk67VjO4eMJJm1VZYn4524bTTauARP+OWWjPa13e8inUm4tjAFuLJB1+L7qXv0A8A1HuQz6O/k1onJNx2b07iuqKzXJ10oVc8qpmAzM9zjfCeq7fkqdo39RNvDCtYg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Throttling notifications reduces the number of scheduling notify_work
making the mechanism far more efficient when huge numbers of huge
folios are freed in rapid succession.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb_sysfs.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 77e7214a380e..1e3a6983457a 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -341,6 +341,8 @@ static bool hugetlb_sysfs_initialized __ro_after_init;
 struct node_hstate_item {
 	struct kobject *hstate_kobj;
 	struct work_struct notify_work;
+	unsigned long notified_at;
+	spinlock_t notify_lock;
 };
 
 /*
@@ -364,11 +366,30 @@ static void pre_zero_notify_fun(struct work_struct *work)
 	sysfs_notify(item->hstate_kobj, NULL, "zeroable_hugepages");
 }
 
+static void __do_zero_free_notify(struct node_hstate_item *item)
+{
+	unsigned long last;
+	unsigned long next;
+
+#define PRE_ZERO_NOTIFY_MIN_INTV       DIV_ROUND_UP(HZ, 100)
+	spin_lock(&item->notify_lock);
+	last = item->notified_at;
+	next = last + PRE_ZERO_NOTIFY_MIN_INTV;
+	if (time_in_range(jiffies, last, next)) {
+		spin_unlock(&item->notify_lock);
+		return;
+	}
+	item->notified_at = jiffies;
+	spin_unlock(&item->notify_lock);
+
+	schedule_work(&item->notify_work);
+}
+
 void do_zero_free_notify(struct hstate *h, int nid)
 {
 	struct node_hstate *nhs = &node_hstates[nid];
 
-	schedule_work(&nhs->items[hstate_index(h)].notify_work);
+	__do_zero_free_notify(&nhs->items[hstate_index(h)]);
 }
 
 static ssize_t zeroable_hugepages_show(struct kobject *kobj,
@@ -597,6 +618,8 @@ void hugetlb_register_node(struct node *node)
 			break;
 		}
 		INIT_WORK(&item->notify_work, pre_zero_notify_fun);
+		item->notified_at = jiffies;
+		spin_lock_init(&item->notify_lock);
 	}
 }
 
-- 
2.20.1

