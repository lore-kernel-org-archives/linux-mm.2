Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2C2C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B456B0093; Thu, 10 Sep 2026 08:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B396B0095; Thu, 10 Sep 2026 08:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C6316B0099; Thu, 10 Sep 2026 08:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC9006B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:36:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DE6A12048F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:36:01 +0000 (UTC)
X-FDA: 85197799722.24.26A37E1
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4B73140003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:35:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TA8iln5R;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789043759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUcB09PFC7E1dl7mQERlG3UF/QS7evqNtPuHr0acvE0=;
	b=tmtGThMHVhSRirGvqZzaUai1oviEo29NnyUBeFLb9+1ZdCmarRAaCXxt1bymYOcb4l7Hah
	Ym/2z1SKVHe4yLdQWNXRoz/Hr8P45qNOaINHd/R/zEMkWgO5XZ04zati1eLhbjfTxU0zsr
	Opmmx8aUbeeGtCfWOqZmnWNg/fYMSl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789043759;
	b=eqv1bD3FwwZhUZvPamZONcOI9YqT2KJYQHrQSaVJReIFAKcsN6WjWFfstARWNiXZRO0G2t
	QMqLXjChLd4Sgg/ek4cxqaMQT5qFkTEN44rGiTQFHWxI+b5HOeYS4XoCKw1m4RUH2MTBhU
	TFrYefkOLsbNP1f+Xfg7JdWAltLZzag=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TA8iln5R;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MUcB09PFC7E1dl7mQERlG3UF/QS7evqNtPuHr0acvE0=;
	b=TA8iln5RrzUxcXuEnGcrNVsJ8S/HeRe4I7FI9rzBcPDfDWedAt091Zj29VE28Q4HaCZBU3Sdp
	Q8IEE/ep4f7IEZPYKjQ25+TIxZmU+s/wPtLyQInYSIHspe4PDcYglJ/SD5I8QAFD017uabTM0CJ
	jS5mDYZZrPk5eVO46f4mRc8=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hgcLy03BXz1prNF;
	Thu, 10 Sep 2026 20:24:58 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 93E834057F;
	Thu, 10 Sep 2026 20:35:54 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 20:35:54 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Chengming Zhou <chengming.zhou@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Nhat Pham
	<nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v3 3/3] mm: zswap: reuse zswap_invalidate() in zswap_store()
Date: Thu, 10 Sep 2026 20:35:44 +0800
Message-ID: <20260910123544.818146-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910123544.818146-1-wangkefeng.wang@huawei.com>
References: <20260910123544.818146-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kocmjmaah117yz7f19mnjns4xtnk98oy
X-Rspamd-Queue-Id: 4B73140003
X-HE-Tag: 1789043759-479959
X-HE-Meta: U2FsdGVkX19SelFuF/kYbllmomYE3dDiZ9W6jQAKu+s+gOr8NHv4IS++yzy3ZT0YWE4LgdeVPTzZJVKG8h42UfpZ+NvBv1DRGd3f0oomaBdLuhm2JBMjP/IDS3eBLMr8ajRxO0KtVj3nXWpbjKIbp9ynY77mdBn1m80+mqmCx6AmaXisdH18lhVhsCwk9ZqOTnq+ZOY7XMiY3HkQsCsL3poVW7B5ibeeSV0YxrZfagvbFM2hITWw8ztz62gIF19wYRsF+XONraqDuXfAJ5dcxwR/6lr93vskKxDzzHiLliS4+dx3bAZtJDXAawD9Dcmf2Wve8jMEBX8jctUufxPO2FVAW8gN80uG5PPVi2vFOLpMOGbEhoWI2d+0Wvo/eNfHYlEtLFLgEto6gZnZU1jVEaILRuoy82FA16iCBK+/m4p4qHDt5/ic2QBl9Gto2ivBp6KKDdFW2g3CQmNKVZAMhX9RVBYRXAOnRLQbWNF+RPLmA56CsKOvRcj0l5ne1CRJ69iTmrifqN7IwRUms8NdTkMon56wUmyKnMY2TVc6tmhgE4PrNbiI0f7p+4qnnqvmTATQrVZw9LRPfwn2v4oBlyS7mkpLDBWVi5gUYPMv42xxzh3eIPs55dJCFq6syLeUFKQ3yFqoGx7RhZsp/Qu367lqIes63h6RanB08gGRGfmwDJ8HVCdd6g23ljN4VdTO7DJQ5x5E/pKLGQZvyetOQ49dvuxPg0dyE36fkeG3OARwQAn+I18TPSAngUdiWVgMnGWep/S864VoilNic2hJgrQ73TSZAe+i8Lb3rSMM5GvV8dt3te2GsamPYWSuHyuijtIagmrxhp5wle/kTo4v9IpSj9pPrAc4vUzFIocoLcwdPoxoNMkf4UaecCSXA6qLgk9suwsOSxB3Gi6A/h0CohA39VyZTm01kxmixmQs/wAkXh5rlwbZsngddTBH5sD7KOwNfY1jLDI1TpYlYkS
 k/bQDLZa
 n7BCWTy3KyGcnOJRpYgUx8VzuzY3AYx7R3OgjRBNVEge4BwJVpQNqaGC8B5KlgS+NKdH6TzefG4rM5vznXjUgwchr3nSpbvaTkINR8wkZtLLRjevrWjRLVkO1b77MkKSNCK2G4d+nDpbIegXl8l+LHx5w07HCGH7gBlTeaXoo5RERMQFmzh+1fs3V9f1ADrIPNPrE5nZByQreJ+cUDEpoXYrHtVOgMxBt1o4b2a0YIqjvgzHDT00YnzshTriMxKuOsAIvMVdbp5Uh4hLUQ9Wax5qQ3aS/xCRiXGhzwVCZ9+ll55lTNUHRZJAG9PRZTn2g3pV1btCC1RmD4wfPnNjq70yVuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reuse zswap_invalidate() in zswap_store() check_old path. Its
zswap_never_enabled() and xa_empty() guards avoid redundant xarray
lookups and deduplicate the per-slot free logic.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/zswap.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 132e97748ed2..e6edbaf97f0d 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1546,19 +1546,8 @@ bool zswap_store(struct folio *folio)
 	 * offsets corresponding to each page of the folio. Otherwise,
 	 * writeback could overwrite the new data in the swapfile.
 	 */
-	if (!ret) {
-		unsigned type = swp_type(swp);
-		pgoff_t offset = swp_offset(swp);
-		struct zswap_entry *entry;
-		struct xarray *tree;
-
-		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
-			if (entry)
-				zswap_entry_free(entry);
-		}
-	}
+	if (!ret)
+		zswap_invalidate(swp_type(swp), swp_offset(swp), nr_pages);
 
 	return ret;
 }
-- 
2.55.0


