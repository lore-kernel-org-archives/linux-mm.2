Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6702BCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 03:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC538E008F; Mon, 25 Aug 2025 23:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B508E0090; Mon, 25 Aug 2025 23:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1897E8E0091; Mon, 25 Aug 2025 23:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0080C8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:36:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A066B9E10
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:36:35 +0000 (UTC)
X-FDA: 83817496350.17.1918312
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF1C4C000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:36:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756179392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=YzvNlOmUI6wjvR7/OKOhOTnnrM9QDlI0WnWtOEkcJnU=;
	b=VJr3dVyLRrP9MKGF8ZDqvq1qVEHwWvgt5vSQzWCIqz6joAO5ug4pD0BMf0+DxHGZ+J7re+
	wSimvtIlBrKB5JRXuEt1kRpRMboXvdeRYZll2RauEFTXA2Dd0uAzVQGiMPr11cVInxQMz2
	L8nHt695Dq8ZgbPwG+z/g8ow0ROpnJY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756179392; a=rsa-sha256;
	cv=none;
	b=QYmsXbwnMnQ4ahDRr34HMfQYrZZWI+NlXgRng/z4Oa4nkIJmGlBvURTpG6LSiGQQ70ZIEt
	epi3eDvmrY4Of9P+4enCRmdtBQd0D4VIyMwlKhEZJEdkE65jQgCNkUzmteAnbgzIhJFrC+
	+wXUjPpvbngEaFbfUm2eYMUhZMwnt7g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c9tY804Frz1R9BL;
	Tue, 26 Aug 2025 11:33:32 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id ACCB5140296;
	Tue, 26 Aug 2025 11:36:27 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 Aug
 2025 11:36:27 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH 0/2] mm/damon: void divide-by-zero in DAMON module's parameters application
Date: Tue, 26 Aug 2025 11:36:51 +0800
Message-ID: <20250826033653.1208227-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF1C4C000B
X-Stat-Signature: eefbj4z6o3bc1rhmueuyrnzchifwxmkx
X-HE-Tag: 1756179391-287083
X-HE-Meta: U2FsdGVkX18SaY7/pkKzRuhCuW2NQNnwFS7EOiOsA4ZiDnpqNgxUitjeLLCHUFYXUkROCFV1tvT6IIqccdbH/HwBJE6/Mb2gfcXeeOSFTEbRZKzJLtFofqwJeTGVxzqN3EuGohc+WHpIfwmfmvZCub//l+BxvInRHbOmm/TXbvRVxLIxAk3k0ubeGvbYBOZPqTMWyCNt/ejebvyJJww3pj5J7Q4oAUpoF/HPFoBpTgIU2y41GI/hp6i+hS+H2HfU13qJOc8IYQB2gzzDl2DLyKZdSWO04ARq5f6vc+7wvXpYXm2bSAlMULrbPKfRUior583zvxGU+QzV/cvEffTV84N9FoRYJGzsLl0EXAs7en8lJ8PEr0QW8dR7DPGbTKVNGj3jx336oaESAgmWQ5l7lbJwBfveOexds7l6gzDK4mqCqQ1WmGq9wFthAsVjJN14PeaWJWJnXt5jOrHWjZWUpMVjJoXtEqFsRNwDYX8cjsA5zrdMdns5FeNaVafu6eS+CWr9CyhEkyeQrfUpA4tyWPAulwqrTwGD9W+NpQeej7tcH8y15aPifAmc0muPN9uDib5c2LYH8yNA6rSPNzMabeQgzDg56qN03OpE90/x8GpW+BVHH68Th1ENRNctcxxBL8gN6rGzFcM8VOS2NLiTTyLevYlx0VNsLc9Vf1sKrKiqqpxpjKBQlnXL8RRThWDEb3BugjV9y037d9iY/VV94ZvtuXuyfpLV0kxkLGYSc3h5pZ6dTZuSBg0zuC66adJxmDbE7tkfVjJ7zMa0w2gv0FIw6qu4a+A4GVebW/DGW7YDB5k/hVtIn4ly5bPoTfe1cq+YX2DVOaPvPMW7NJ0l5TMvGwe6UQrAdsLEWtiF0jYS5NyZ8hO9ly3yFBvRDbg4iXJfBiu3NVzUqxRkJSLC4ZFXLx4Z8D5koUPc7ebLNvEPNYYEZfL/dItYvEjg1YIG2nSbL1EjBGzNqmGOw65
 bTEahEK1
 fumcQHIUCLl5xn7E1GyEiiDB/Oj61Nh5MPyNwXsXL0Xb9uqUJLmGxG2rLXP51x7F+/BYKKu0UpNYqE6i1Z2Q6yCHs8p6fqrS3f3Kmu28eWRIupMoPmvzHpTrWBXq1KoYhpAYRYfnrJLo5QJVl+1Lxql3GFiwiHE8EiRCM4j5Lvm2mhQs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON's RECLAIM or LRU_SORT modules perform no validation on
user-configured parameters during application, which may lead
to division-by-zero errors.

Avoid the divide-by-zero by adding validation checks when DAMON
modules attempt to apply the parameters.

Quanmin Yan (2):
  mm/damon/lru_sort: avoid divide-by-zero in
    damon_lru_sort_apply_parameters()
  mm/damon/reclaim: avoid divide-by-zero in
    damon_reclaim_apply_parameters()

 mm/damon/lru_sort.c | 5 +++++
 mm/damon/reclaim.c  | 5 +++++
 2 files changed, 10 insertions(+)

-- 
2.43.0


