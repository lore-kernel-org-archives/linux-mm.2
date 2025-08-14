Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D86CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4E590010F; Thu, 14 Aug 2025 04:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79588900088; Thu, 14 Aug 2025 04:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2B290010F; Thu, 14 Aug 2025 04:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5654F900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:30:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2791D117976
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:30:08 +0000 (UTC)
X-FDA: 83774690496.09.944008B
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4D2F38000B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:30:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf30.hostedemail.com: domain of lirongqing@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755160206; a=rsa-sha256;
	cv=none;
	b=P0lDJDvjq2ie8wTQRYONSaFkMyaWaE7rzXaIwyi0GeETBD7DtB0UiCSF55JeXbav4oAG1K
	NTuKcojmgVuNEoYQISeHoDNA4x80CxOCF/pROQ4fm97JDoo3fZbOgZrWsGpvFekuVx44iC
	f1ogufcQKyO5XUZE28G6OFlJX0CRli0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf30.hostedemail.com: domain of lirongqing@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755160206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=bwnhjEkjxcCo498CxFtdgm0mALdZDkTRxk0wTgi/laQ=;
	b=HIudLE+33aPs39Srjq8a+t23G7q28KekNKHY5+zaCoFGilJYpWvG3MZU2UoiKtuMPIrNXV
	+lM8p9CXOIXeb4ehEzjK6SF4C75CfzH8kGK2P/j5AIUqs/NWKkQQNkVeb6bBEctqz0LINm
	lR5A20Vro4LfmBISuVBozCLO0CX+llE=
From: lirongqing <lirongqing@baidu.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0
Date: Thu, 14 Aug 2025 16:29:50 +0800
Message-ID: <20250814082950.2888-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjkjy-exc8.internal.baidu.com (172.31.50.52) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D2F38000B
X-Stat-Signature: 5n8rxyrc15hpbzjhcrqwhyury7grytoz
X-HE-Tag: 1755160204-715723
X-HE-Meta: U2FsdGVkX18ZCK+kpWeu78SICpz4LOkTn29hf9dwlU20wyZ2h05yafNxLTeWvanU0XetQ5rN6M/SRZzItT+G08uaZNmWm2lleJUQ7EqrB0B7GwUo93RRY01jQZZ73y/oxwT2Zs7ZmdX08DGzLivPh2dcyDiLXkLKNdk5fN/5z72Mv1q35QZwOPr6WNFsN7uGb44ejQpSL9NyJs/IXoax2MjMZO/OeU2eYiJhfL4vAlRXVsFtjlBo6e4/oKKX+yq3i8uSx6W78HGSxZPrZsqFIDVmMhX/GrmL6Az1EPIYyMJhAnbuIAOP8gUcZqrLVGIulhvSSmjCV2kxhKxyQiARI4QOWfeG+rpQTFi3z6Y1Kt8zByknBeacnuJF90S/aEh5TP+U8xk7UvrVkmZ2OYCxHS+FOA0FtT8NyAKj5iGP3JSG0K13Zmder5SVfsilxcoGFciHvM0+vMZuZJvLFgjWumGbb1GYggrr6iMLeuoTAWV1asWqM5QNzfDELvudqjMGA6yNwhnibEnHvURm4JAXz5HNP9cJehEPy/KeZa5hLSzf61P4JHYzwMftMDHIjXrsCGusLwEXh/flk+HE3vvGQ9uKh75iCJwv8bXZlWs3mT+eUbKmuxUMabmBnWzPpZTipgxotP0LW+eUZ17XrsTLPyLPRAhnAz3t4AugN4TqeU/EAO6Yo8aKSxB8+8B/BSVRyJL6+EUoR4rohIwi97bPlaQckvY2aeCusIw/y6lu1+e5DkPdqKY9PVhiF1pG5037N8C2z2agDaYlkyxrVNm2MNr3HYi2ymoJzYLcO6N/DRz1d6ZK+XlG88NltH14CMEfGKmj3PnqJl7Wi1vcwKLSnRprgQAWRVwi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000007, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

Optimize hugetlb_pages_alloc_boot() to return immediately when
max_huge_pages is 0, saving cycles when hugepages aren't configured
in the kernel command line.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 mm/hugetlb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b..514fab5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3654,6 +3654,9 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 		return;
 	}
 
+	if (!h->max_huge_pages)
+		return;
+
 	/* do node specific alloc */
 	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
 		return;
-- 
2.9.4


