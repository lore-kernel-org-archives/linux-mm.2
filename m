Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B7CCCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 07:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA768E0002; Fri, 17 Oct 2025 03:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35DF8E0027; Fri, 17 Oct 2025 03:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D5E8E0016; Fri, 17 Oct 2025 03:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 699568E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:53:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED5F6160596
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:53:48 +0000 (UTC)
X-FDA: 84006842136.09.1A3855E
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf21.hostedemail.com (Postfix) with ESMTP id 100C11C0004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:53:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hg+PuDHp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760687627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CcbInidATEQDx0TmsZjwQ7ET4Bs8aihoSMbGsPd8THA=;
	b=OikHrXHABdISuQVqTVP3o1NjEUzdOAWuarb7L1Cid2awBVnmq5L3qViPbNiZLLczUby0In
	8z5FnSAb0xZaPCHhDU8/lP5cEJEh5wro2WHToQkxW9Y/9s4IKRGdse8cMcwdMiJoM8hvoj
	kuo0lJmU5eG+5RM63SDJo3x8RecFmPE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760687627; a=rsa-sha256;
	cv=none;
	b=GtXfaWq9i3Ps0Sx1NnA0eTMtZteUsYx7bBnWzj/GKw3ANI/3/DpT1DWeDzP8ByaGN+LzC3
	gH1Cm2ZR2qZeMKtqRa92dU1m+n4ombRi+rilcZ1RYxbCdWa6im4e2mGPUgec4pIRjT+lWG
	1udVB58HPnbgpUt7TnnZiC+JC2M0ogM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hg+PuDHp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760687622; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=CcbInidATEQDx0TmsZjwQ7ET4Bs8aihoSMbGsPd8THA=;
	b=hg+PuDHpTiHlri80s3xUGDC843CjMOgI/WwcWHtlcAdkiuYXMphhLPQrCXCO6/FQeeQwC3g33kBGWFPYIa6j+tdTCIymh/EQVZj6m/5i8wGhslqyjPIlb7QHpPwCvyNfe/TC9v/8lIPd/hpgjYbAuuTroPhNZM5ITNIYKPB83ZQ=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqP7nGd_1760687620 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Oct 2025 15:53:40 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] optimize the logic for handling dirty file folios during reclaim
Date: Fri, 17 Oct 2025 15:53:05 +0800
Message-ID: <cover.1760687075.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 100C11C0004
X-Rspamd-Server: rspam02
X-Stat-Signature: rj5noksjwet1qo83t5wkh3ucmctp9bxh
X-HE-Tag: 1760687624-333680
X-HE-Meta: U2FsdGVkX1/KJDf6InSIEoSxS9gNMH3ZZLozx1Bzw7BFmB51TYlPygOHIqP6QfEGJharo9AvInikNDp7W3n2E1rsHJvDHG0gT7MowjlMmzo1D2ZzVf8ai3MJJWi1+zpNCxEhQe160IbIlqVSMXUJrF2biPYArn8WGyFSUY93xqXXcC8xvmlnYsQ1Oy8j/y6ymbDzgEbpBvqwqD+pWVermCLSM8OnaLwtj3DD56p1m3GA3ZtI95W35yUoG6V4FO5zqclQfNBQPhi0XmTlcYrtmMWYkHIbC0Usvxp+KL6icXRg6vVGNOto1+KyXw4nmhX40vt91wv1rs++JehIU2Hhtjg7DvgFF4qKOBVNSBM21OTytmuj7Nwb4jXtlEvDKWzRdbq4cYhMBW7zGRR+5aGKzG9gb+4KYIliUh0x/5Rig21T/LT8Zb0VHs/BMm/UtWLp1iNQyiJS2XkemxonzbC3SHHOke1yxX33lCjoQ0fljq318Ft/TCIJVwttQVP7UrA5L7uvJan8b+3gXK0EYUH8n7Mha4hM5u+v+1yHk87bHIAC+Akm3osBWi9vvSZMV0n9Dz2Fba0gOoMtVHV+ys7mE8kmuTfj4NjQ5NgcVcfheQWSl+Xt8SAjAEOZOVByEaYP7EzZvYVEfwu1v0zKcSOu01DipMZmoyqBBpk7b7Yy5YLGPTQaOa5es8S7h3IMqtpappDgw7yLc8Y1BAB+FN2eiV1wVZuwA/dI+kVsaowkHe2jpL/My01yyOgIY2t2ceJqegb0tQ+jUlOPSkSVmNmHKxIKCt0v0lU35vnLTDIlM7cOVARnlNQTsfaAhagQIqlq1wswxWqG/3WCfO1SLrBH6X1A0vLEqUXP44fqve3Uvj5dlTqzLU7MH1N6Ol4TYy2XAONFCpzDdrLylje9aa8BR5f7BCFpYNH2zNzMhqgBoZ3YuVExLf0nXEtezBKgTYbId+UwElMnj1pBfUv+sM/
 oHSvHz+f
 Jz9jHnDnfa/4ZIw9WnI2nxBoDokww2f/N0k14tPDCthlakRmsaJZIBrE4iay85KevTWrIWZVH3cLrz0Y9ChYfT/6KEplzbK6hH/c5aHuGapFZxfuLBXdO+8LXcrr+3CnCuce3AsTujrJkPJEhzKRtNVdrZ3tjlN6B2xlNY/AAdoRgmS/kVP1TM0SYaDrZyLDszvHcjDUc1YXxkTsptVK0vA9mZ35UmT5QOx3bbnLc7J447sVQ6eSAPfhd2Yn7Z0RwOb3V9QfPkg6pZBay7vW6/idtAREj0par8koWkjllHOI2R5zrG0yrc2NDUMv5NYauyNNn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we no longer attempt to write back filesystem folios during reclaim,
some logic for handling dirty file folios in the reclaim process also needs
to be updated. Please check the details in each patch.

Changes from v1:
- Fix the folio_test_reclaim() check.
- Rebase on the mm-new branch.

Baolin Wang (2):
  mm: vmscan: filter out the dirty file folios for node_reclaim()
  mm: vmscan: simplify the logic for activating dirty file folios

 include/linux/mmzone.h |  4 ----
 mm/vmscan.c            | 33 ++++++++-------------------------
 2 files changed, 8 insertions(+), 29 deletions(-)

-- 
2.43.7


