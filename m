Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2431C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994D06B008C; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B336B0088; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE5E6B0093; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 504436B008A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93CB1A0732
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:55:27 +0000 (UTC)
X-FDA: 85007790294.15.A52DA75
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5826D180003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:55:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mEbcGjfe;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784519726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZgzSDGSYwshJBMY2Q9+7FwyqzkGbERSOn9ppxGLEYEk=;
	b=JtX6u6AbrP0eYerbZmxD1uQUA8IfngfuSiZ09TzUrPt9fnhYkX49eab8Ljbrsu4P4XrZJ7
	OaHnh2MkKIcyONC9yf6aKlgx7FiJKUSoQmWw3RUGLWVu0pVZeJrSrM8fKMIv++qB/23SCa
	IAW0liO9ADNvrf5lw+ZTmpFUBFL5mw4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mEbcGjfe;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784519726;
	b=3kzgUcRCEoUx+DFKOtlRjPB9JTd/Y4yB+StryyeZJR1n4ffWbhY4HXNysQ8N8Np0jJJuUG
	FjEBUsGWfiQKgLsd2KHqYm7pt6dGOXekRkuXkRkKl+bzAH0EM4z4mVr8/oOhAaDoV3AheU
	3ozO08WO2pkNX2TqCEjI79vp7+JKiZA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZgzSDGSYwshJBMY2Q9+7FwyqzkGbERSOn9ppxGLEYEk=;
	b=mEbcGjfe+IAXojyBOzEGW70Qc2Ti4Ki0bZ7fK3RlyRMBpRcOvdMHVV8/BntTt2bKudA7yvkFt
	pMXZi4GSCNJGe78ofK/kwLq2FTtIZhpF12VMg1s9EIxWCSC8dYnwmpnn1yZ/HrNOjgkiOFtX7EZ
	+T4MhyrivjCFY00fHO6jh4g=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h3RHv3mPYznTbJ;
	Mon, 20 Jul 2026 11:45:47 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C3D24057A;
	Mon, 20 Jul 2026 11:55:20 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Jul
 2026 11:55:19 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
	<svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 0/3] cleanup for stable_page_flags()
Date: Mon, 20 Jul 2026 11:30:18 +0800
Message-ID: <20260720033021.4091944-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: ya1micwkh13spemh8chdw48htprwgmgt
X-Rspamd-Queue-Id: 5826D180003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784519724-211554
X-HE-Meta: U2FsdGVkX18T+EEOayo7in4YIf+cTIFtD+sbA7vpZn+5EvYTljG1FgnJ7F5r2teJxNOFfvhhxgRZvokEI7JP9x16Xbr2xBUyHj1d1jrUbyDg6eBNcMR/+RbCtuWVXCSdRI1e5LdTmVnuV10tQdkL9h0qH7DDjaeEIkOItvFtCFn6LVTRLWGsTD/RFJBSDU5TwHJ02ysPjDxcpjHyY+gOpk5TNf2ANXqmmtkUcVxdzeSA45qfIxQMbFYDWcDpCsvaNziw/vPmmdq4Bi4E7rkX1Zo2apLf61jC7CH2A0Qr/Bahp0lMvbpI7coZ9fJqUABcnwZ6C27TQ1walKrclITlHFwk7IgzkJk+8JX34PDZ1rxcNuUL0c+LDDUGsPFlQNjRqjCEBZ2ahU2wr1nhL7ObO6ZOr+IbyMqtTqjxnckEH/d59goOd3+PB1mvbeJIvHtNl1QOWDKxcSyspGmRs4vMxbMEDwK2cBw3Ugx0lH8APfV0m6thgKX2HabmtnC2fkYfxW5pcKhjj3EK85GBeotNoY4YvF+v4cKvVgm9GIhzth570I3aM/DDgI3j2ORA05hoOk4qz8Q0XxHT1YqFe7qKpM92lbVzHsoKhRUUHi0OcASrVw76zeqt9mQr+B/h2QoXTBscJftKfMgYX6K8D/Gq2bm6LPGHrRfmgS9BLVP73V1BOWZkGjYVImbyv5wEMHcT27EKq9Md6YMGH60lxhQSJPyExtF76cOjzGf2nPfqcmz7a6SedYVsQxfFrEAoUtlnk6x8JnH72YShQ+Y3UvkT4zAlHEKiZjis2iNWsG6RHDF1iLOCtjd9yfLfVEY6wNlSvfZVyxBjucrpCCo4ui2tJSX3PW/j9S2pxFHP3b1ol2hyoyQitwWsVLuaqAg1ksfbUzIfAV9d6E6Whqoy8JJ4h7P/Jr9c0vqMUXx3GfONrZ/hMSJSsZE4wuO7cyKR8NzXxePlCx229oMyiRiLoEj
 eQdqcdmF
 VsPiSPyACYdQVKd9ekF93s6xoWS0hw8e7aAfdJHjq1w8OC2aM5Pzv/1/jfBBXZoQmMzUODH6fOIKQKbgWKYFovSRHsfk268c9AdV5LX1bmiPUqpyJoTagcqvPS6g6XgBxVtJ6c/bEVIIMfMZ3WB6z9oMUTa/N7rlp8JglAr7QkltCQ+2n3cpEIGa1+YuKFJB+1BniOI60mdUdKuCXmHUocmmcCBXazHySk6/EhrtWHBP8gklVL81/RL0rVABhdrPG2YwGCW3ewxWjmCwYZKtFbja8Y/4P8sfsBDx/1JSUIY3xlt1q3M2coC9+huoxp7yRvhLbhyAtyuutTEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series cleans up stable_page_flags(), see the details in the commit
message.

Changes since v1:
 * add missing "1 << KPF_*" covertions for patch 1
 * collect Acked-by for patch 1
 * only convert folio-specific flags to folio_test_*() helpers
 * move KPF_IDLE cleanup to a separate patch

Jinjiang Tu (3):
  fs: stable_page_flags(): use BIT_ULL() for KPF flags
  fs: stable_page_flags(): use folio_test_*() helpers
  fs: stable_page_flags(): simplify KPF_IDLE handling

 fs/proc/page.c | 56 +++++++++++++++++++++-----------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

-- 
2.43.0


