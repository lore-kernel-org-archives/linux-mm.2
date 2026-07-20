Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8F6C4452B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0B46B0098; Mon, 20 Jul 2026 08:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8236B0099; Mon, 20 Jul 2026 08:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6FF6B009B; Mon, 20 Jul 2026 08:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0177C6B0098
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:01:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 761231C009F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:01:50 +0000 (UTC)
X-FDA: 85009015980.23.DCE87A1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id D1F7C1A0013
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:01:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=SGkHzx+b;
	spf=pass (imf19.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784548908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/YQPAgOQrSG3+15c/29ezD+K1P4Be7L3Rah6eZxjWc=;
	b=rsKKUv8SkDzD/jT3Q/ikFCdZntlPvSbVxXpMFfVgdLvr3ao5qc+S4omQwoOtCqs83+iD6B
	DKl9wEMIIe5OLQ+Pj3onQcEaMMPHD7DhxF+YPm9UxAmKoqrC3aqG7LltImNtvECiHX5d44
	365mzkWorJXNeOiBctFwkdOUCgB/Y6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784548908;
	b=N/iLctyqdei9jAN816rD8o8hedYzCcRjY0gP6tq9+nj10eAcQr+mMqRknPb5Ifqmvx+PoW
	lMqZNOgfXSb0mhwaXT7xmts9NMrLvqSKJ1KfQ2YgY/OkNBxNO/Bxi6eQCd4gfD5z8OLxta
	ocKJYx33iojF1HyL51+B1BuF2QA/MQI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=SGkHzx+b;
	spf=pass (imf19.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=e/YQPAgOQrSG3+15c/29ezD+K1P4Be7L3Rah6eZxjWc=;
	b=SGkHzx+bvAljk7vLYPDLYWTY4AOlUJMnF4SxiBBhsMs+N1EGfkuJHrhuX6BK8GCMbieshH7jK
	MXy49TjA8IS8HSv8n4PsRWpp38+49jqt5DxMNGGBnHeBC0/DtJqc5E6CTr2H7MgRD8OJE/DiuP6
	Pr5Eq4Xzngm19FJexNco4Tk=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h3fHj6HJVzHnH4x;
	Mon, 20 Jul 2026 20:01:21 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D8BD40571;
	Mon, 20 Jul 2026 20:01:44 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Jul 2026 15:01:43 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/3] mm/damon/sysfs: support hugepage_mem_bp quota goal metric
Date: Mon, 20 Jul 2026 12:01:39 +0000
Message-ID: <20260720120140.881468-3-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260720120140.881468-1-gutierrez.asier@huawei-partners.com>
References: <20260720120140.881468-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: D1F7C1A0013
X-Stat-Signature: 17ats6kqww6qo57tmmwc6u5qyai77978
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784548906-238840
X-HE-Meta: U2FsdGVkX18d/tvn9fFS+gk7Z8xSk7IQ92ADw7FqotFo3WQhzzWNFiaJkjqEW+4SJvi0BH7O71cSHyzMDbbaVyt0Cp3tyYD8iULNNF+25WqNPsFFhJsYPHi4gNb15TQACJ+8ZJTe9IqVzBpNUVzM7ZZiwOGM+sllAM1mXCi4RJqEFQdIhVMYW9m4a+eXNiw2GXHn8y/6lQGxr7DiH9HDn6tdQjrnP4d55uQy3g2GBva2dfZXIlqL6noGzM8VzP3Y1pKNUQekakMvCOajtaSqkvCOb3h5WRwuBnOvugz9jNfT88ExM9Y2I1G5VwbFHXb8rmHx3JL235edNtGaOuRYElgoQcXukSkZ15w+sYGbzRR+Ta11pdI+v4LEoEWqhCP+MhrME5H/5VslTAVOm4E5D7kvx0qaKXCjn+7vN5lR3TQFgdcHhfGlcpRTMxSlbCqRze5tbUBZrFa+7hn51kh4WxNqVN+zGfh7kiCMUR9OLYNgZg4M63A+fp2E7CEQi2C9hSmWh0jasNaTIHNi1QD7uiM9JH2wlWqeTgeXkun8462c4Bdlf5HfCSJYKIEElL/ZiQ0hrTSgE4IsJsfMttMB/sJhUTHEO3AQMWaufi1BDFyaZo/DxtaIYP/10TwQ3vSPWD/lwIHlZpt6+S/vJSznilzIL+Rkb4TSO1c7vGTheCSbDxRpl6+QR8lb8HEkwi4b6YCxeCY/lbxqH3DITC7wmGBwm3WUBy5jSdiZLF+Vv7WtcxqBZRLTB8YoAC9CgP2YXtblNKzJA/FVbHhfVQYxqrgA0uMVpodUMlqwV57SEPzEigkJdl/ey2bXp5Jarmfju27Z2ezZaj/oAmb5H+le12V3z+zjS/m8jE4WgZIfQBS+bglApUAKeqAc/1GlnRI3YHrBmxT7Q6dDuNZWQ6WONtRSU4H2VSbCjTuqIgtq2z09Lek5DyMkaq1DtYLK4p2FaWHo6MSLiw/EYENP45H
 8Mqfmaaf
 9djftuKrSllsqNF8SwF/9Bp5jXkAm/UNsNMbx3vOIp9G1jMTrgi+zKNmJ5e6JhFFpij7sBR4Cv/taezUjRVjrU4HJb4Wc5A4W0tBSirbcCJBb4VhOoLNS8I/+4MJh8ZVbLy7lVJA/e2f/Qy4gtAhSqTYmzcLWB518xl5gP4eE3YaYyISei+8y0G6Uc5iKFgyOhxpomc2RNRq7MAqShJQHQROeUP2WYz+1blPhPcP+03KT/+95UBX4VFTBqJW0PeN6a8tB5pKrE8XMLCyzf8vYwPxHONwxhgZVhmmV/Nx8AOkrxrBbBBKxU3au9NxGeO2W2LiDhQjdNddTdmfB4ZuHgCHLnua5rbKOL+zlJyTuoFXG0gbGvvi1SWcXP/yIjHRxzR+zIYcu8mQeltBEkVXT/8/R7e2dR0k2k0LqNKbJiwmIPTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

DAMOS has a new autotune policy metric: DAMOS_QUOTA_HUGEPAGE_MEM_BP.
This patch exposes DAMOS_QUOTA_HUGEPAGE_MEM_BP through sysfs.

Add the "hugepage_mem_bp" to the sysfs-schemes interface.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 32f495a96b17..d9b81d7b5910 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1269,6 +1269,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
 		.name = "node_eligible_mem_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_HUGEPAGE_MEM_BP,
+		.name = "hugepage_mem_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
-- 
2.43.0


