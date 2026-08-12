Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF3E1C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0B4F6B00BD; Wed, 12 Aug 2026 05:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC6B6B00BF; Wed, 12 Aug 2026 05:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4466B00C0; Wed, 12 Aug 2026 05:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77A336B00BD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:18:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F32FE1A0106
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:18:53 +0000 (UTC)
X-FDA: 85092067746.19.D7D895A
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf23.hostedemail.com (Postfix) with ESMTP id 24F42140006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:18:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BWThciDu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786526331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FfJ5nAyyp3uAf1i1mDP7ix0yMVKhktD7PymhKvowdmk=;
	b=G7Tm2e1IwQd1xe/shPi0Q/Y3bc7iqo7Jc0NgeD6VY7+JC5pedSBlxVHAn2/kNPRwXSJVWB
	BkdbyA+5jKBgDtAsCn3oI3G2VdHfx11SZyri9HoRguOujDHO1/LrBQIO7oQg+PqrmE5P6W
	rwUsrW0n53mEgWqiqg/afX37Vlgu5/w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BWThciDu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786526331;
	b=3TdYxt180y+WnZ5hDvxjJYsaGgXnpfneG2ICnvLHbeIm+xMeVEUgK3Ne/dwY5QljV5fX5N
	yo/d2B02289vCW7PfwZPn/JxkCzZB7xahYX9k+CumsDyNQp4hSRh9zTnjOHnXAkbH5FXVJ
	PlZ0GY/IsR/8s3UOLDEYjLXcGvpLJws=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FfJ5nAyyp3uAf1i1mDP7ix0yMVKhktD7PymhKvowdmk=;
	b=BWThciDuZL39Kr3k4Repy9byHSsEFtIsDQbspS4kgW9CVTJCKluwmbYtGvVrlTkijwxZtrk4f
	dZfXzvKQ01VfRC57JIBtmZgB1x/uJHbweVIy/xBrCs2IwmBpl5RjifVcJ5gZG/QWbEYWKvMbR3w
	0QMqOcLMR4CrmGk48vddvAs=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hKjN62CLDz1T4Fq;
	Wed, 12 Aug 2026 17:08:54 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id A48542DBF7;
	Wed, 12 Aug 2026 17:18:44 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 12 Aug 2026 17:18:43 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <linmiaohe@huawei.com>,
	<ziy@nvidia.com>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<rakie.kim@sk.com>, <byungchul@sk.com>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <nao.horiguchi@gmail.com>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <gourry@gourry.net>,
	<tony.luck@intel.com>, <bp@alien8.de>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, Xie Yuanbin
	<xieyuanbin1@huawei.com>
Subject: [PATCH] mm/Kconfig: allow user to select MIGRATION if MEMORY_FAILURE is enabled
Date: Wed, 12 Aug 2026 17:16:44 +0800
Message-ID: <20260812091644.224299-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Stat-Signature: xbgbmn6qwsr7ps94cohq98aitbsseu9d
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 24F42140006
X-HE-Tag: 1786526330-846679
X-HE-Meta: U2FsdGVkX1+O2HvJ3HQQRIvf74C180clvV7qVTEDzjiqMP8n7wxh6tQ5T15yUd4YptdrH8mZ6VnLwTmOX1zZ/917hy0Z/CHLo0vNuK/DJUpsJk7hyWX5tahkBy96NhCCkbL3pfOwETIAVjsLolHCndlqwOE6JLLdTcaBeqHUmsc/OGWn3J65RfCY1+IjEwJyfS8VTNzBa4nB/r17FqiLopPB8mQX9wJWKtbOSCyRoHJm93L+N362oZFdsskw8rb9CPY2QY+0yjNHcjTkWIAOkg+f+r7EBL5WVuSmNTax+tQZsCbwIgSdf5hHTHYV2pHagIjGWs36HZbVTItCUfncfBcXCuPypaWn5hOYDuLPmNZbMkhgJ0E9CnVdNLO3yWXdxn+/EmWe6pELRVBq7+bxTWi+sRyNHjTzwPMMmRLkvX+PMgtC12354zkNUiOtgmTF3ex0ayc4XIhwI7GsxqXL0kTKZH46mIhMlMAuKr1mQhipCBHFHSwVyl16I+azBLkFdWoUxA2BI/cTFW74DlSQkwxzLLOFjSTs3T2PZSgQ5gmACipZ5ZT5ChJ38W8Iti1/O3Ej8TfHzLIs3MTfGF0rNHyiwutxEO4mVVoHjjZBItWABqvOqbGjaVYtzGPWjI5+Nz0hYE98WUexJBLlESIep7bWPdp5GwXBAyQaFPr1Gc7MXC2UMrNWD9EEES/DtwmabcJao1gPGsRiCtyiLm38rDpgE0ZD3wQVOOWoYVB3SZH/VMK3QJBUuoa3nE4mi703j9jcYakw1tcOcl/7C//q0Lc0YMZfLwyJo1mTGc93syCgIdyNibqNa2fH8gdkx9MBSN4RPaoVtFB3T+n6yZxcQNzHHtgCfv2fX9R2muwf/01+4KCvVWVU9QZUQdgvv39pWNHZolFmhY+NLN7U3nKWd6oVfBKHEL/Aqev9emjJvFVNI8QqfvhO/w4v2gsP87UBnYYcrWUfUY3dbIPpCoG
 vMLCDLmG
 K6woLO1zTulfhIKAwjNVtYKJkTXO2B5/ucg0BGguhsADKXOKv2T8BizVm97bqHM4Nzqc8uuFgeDI93N0Rpdx60CIkPgWiMja4nnCeGxyFiUSNbS1wkn4i2EN3QEmpvCThqI3RCDBXkwR80GePUBFwp92/sW2mybe9wcVy0xl4Trn4XqzOkTXBmACsWZbYNH93tgzlq7a/2+UAlA5Ievqn0ANfj7AGHDuqH+NNvIOetrH70BWweCnWTS4frJKvnmiZtCoJoGltQAiBTnekEXANifOCKGfuTGfu0MeUHAWl36WWX64aTWhLmYS09kA1brZ1s2MwxBvC2v8rKYopGCrzF7IONo5Dm+PyEod80lzjXk5ZUR/zUrOJOkEkSSkC9iRCF0FXbiwb+/1CEtz433QSDc82+MTIQiuw86P2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, memory-failure can be enabled without migration. However,
migration cannot be selected by user when memory-failure is enabled.

Migration is very useful for soft_offline_page(), which may be triggered
by correctable memory errors. Most of the anonymous or file-mapping
faulty pages can be migrated to other healthy pages.

Allow user to select MIGRATION if MEMORY_FAILURE is enabled.
Also, select MIGRATION by default if MEMORY_FAILURE is enabled.

Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
---
 mm/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 8a24c130d008..b4c217383b51 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -682,7 +682,8 @@ config NUMA_MIGRATION
 	  demotion for memory tiering.
 
 config MIGRATION
-	bool
+	bool "Enable page migration" if MEMORY_FAILURE	
+	default y if MEMORY_FAILURE
 	depends on MMU
 
 config DEVICE_MIGRATION
-- 
2.55.0


