Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08DBECCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC918E00FE; Tue, 14 Oct 2025 08:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CA88E000D; Tue, 14 Oct 2025 08:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B328E00FE; Tue, 14 Oct 2025 08:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30D458E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:11:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEBE1C08E3
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:28 +0000 (UTC)
X-FDA: 83996605056.16.E918A13
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7138BA0002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=HU1owRtt;
	spf=pass (imf15.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443887; a=rsa-sha256;
	cv=none;
	b=SOHeIcGzPpHR6fyzUy9lLFLFo6qI7bcWqNm1xTrVHRQmXhP1+OOAtHlf8proROfB71akYP
	6y67JZeAC4vj6A+t+TVXIpAP/0nR8O0o9d6AfiDHWOd7Fw4EaWlyMI0EmXTP7ikV6A5cJO
	vr51WtZB+9BP9LIalC9ncWxacEnn4UA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=HU1owRtt;
	spf=pass (imf15.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwBpUXQfG7i2fALdF6f1q8XsBcwMf2eGmUyV9zrLQHw=;
	b=3BmR9A57bvEc/+qBT2WjBK+Cl/c6SUSP9OV5yREVlaWN8YZoB6dM0XbACc3lhswgmJ1Kvy
	8BLoD3bFewBNoul+AkrTHfZt6GgM1I6t4J4NKn1HzKufqpExkOcLymHALYJ1DHrjTvO/sB
	X7hYZMhHiZoMYZcNyHFlc7QUXpAEU5Q=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251014121124epoutp0382551e9b8fb6e304702a5618dd5ed5cc~uWmKzhCfY0713707137epoutp03g
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251014121124epoutp0382551e9b8fb6e304702a5618dd5ed5cc~uWmKzhCfY0713707137epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443884;
	bh=dwBpUXQfG7i2fALdF6f1q8XsBcwMf2eGmUyV9zrLQHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HU1owRttA0sQRI1Z9TN9qM1ddUI4JJUFuaaQzl2wcJbmMM5rTkBDDZ0WzFIKMxaAA
	 lI7GVfJew83fPS3YuYz7LV8eeCqvzI/jXQ+gvJ3c86LtMJFJmokaLIg8Z3HghP5TQW
	 m569xP+4XDE2j2xY3S6/UNvzDpn6pRUL9ISvshKE=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251014121123epcas5p1330df23fc6e704bfe3dacd803c760035~uWmKOQOu51962519625epcas5p1O;
	Tue, 14 Oct 2025 12:11:23 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cmCk256b3z6B9m5; Tue, 14 Oct
	2025 12:11:22 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251014121122epcas5p3a01a79d090c3cca8caaf78c0f411e4c4~uWmIzFnPN0753207532epcas5p3L;
	Tue, 14 Oct 2025 12:11:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121118epsmtip14e669bdfec98f1f53a760340393d0778~uWmE96OG51256112561epsmtip1K;
	Tue, 14 Oct 2025 12:11:17 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, wangyufei@vivo.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	gost.dev@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v2 13/16] writeback: configure the num of writeback contexts
 between 0 and number of online cpus
Date: Tue, 14 Oct 2025 17:38:42 +0530
Message-Id: <20251014120845.2361-14-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121122epcas5p3a01a79d090c3cca8caaf78c0f411e4c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121122epcas5p3a01a79d090c3cca8caaf78c0f411e4c4
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121122epcas5p3a01a79d090c3cca8caaf78c0f411e4c4@epcas5p3.samsung.com>
X-Rspam-User: 
X-Stat-Signature: m74n7ata91s14yt8e4gh6dc35ctcxxrt
X-Rspamd-Queue-Id: 7138BA0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760443886-208726
X-HE-Meta: U2FsdGVkX1/wxoTOxjqYlzGSOxvGQCKUGSri+QYEjEfGgf6Lhm3bMOWJnFayBi3Yhy3B5aprcMaVTAbwCuJe5PLG0XFbLEeY4nqbbe6r41cZm3Iz73kPOZXsfCnHGtf7s99MHKhSaJy2394uthBc2fbAbwaQBHbDWhekgYciNdR/3FANYEZsmhyTg6+yGGfgjegZWyfgGJDBCLlQr9Y1DC/wSLhWb0o99AKI3Jkob4y+tdNNeRIJlrwShNuNw22lg1CD94BB442VLrSoaLqcJAJeAv8m/Ry50ph3Z+ztq3hIpjTYpIZ/iuyOQjk7LRuIdcw/9NRoTmkWB/to1Bx2Skp1JuPJDpGi475KZ8UnNaMh4B9H0ZG1rodpBRdgHINpphdWTl8aIfRYGQwYaUJMRK/q7kyqF8N2/1aUqdDS8BkrOVme0mBGkMvR70JZuqUahh1O5FQCrxkE2mr9cGdF4n6gRwrsg/Zay19j3YnQFvUwoJX26XX99134wdRYIcJ2wCPsNHJygMuc6wVkdj3B5vZFIpzOOH307oz0xCZcCfLX4Fsioaovk/4cM2T0Do+6xifKpplCvDwufS7aDTHr4fSQNMxCPy2+IuQ5cP5YM2yoebNimcPzeXW+E1+9wNgKWnt9MSN2uW+21j1Id3SEc9i10MbW2G8L4PpqWKi5tQclScwyjLdsIa+9BeI/ger1HhEvOuId7KUJORuan/jcofB/qz+3/no7Vr2KfBTop3cXXt1CF0LKo9p9p8GUqm3ysjL4HDJTmPtlvrbDY6kI0iuxKJBwA3C96uQVL5ir/JuXLIQQRNIN8UwfcvocmQFbD2yGr23EexmD7oXhBg1815U0BQwCMJBcG0RSyKsi3Ucf/O7132HTHeWAW4KX8T8USF/L9RJQArH1upJhLBpJ7QCBZiOIdX6/lrEncvRnESGRF7sNF1KEARF0tocK7H+g/Y7HuNGv2gjt5WhZPJL
 789cucR7
 u+YLER0UBz6gMDphsMrdl6TO7hDhrJ8P2pavbaXeoGIGz/WqZT106s7Ay1teSke+wVo1ap2LIvV8H+TrEl2fOBZ74Yc3T/9rhKSVM3fikiMI56MmQM6AOHTkac5hNottAMcuvB7BJ6W1TUJQbuF20OzI35IhOhltg8W1/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The number of writeback contexts can be configured, with a valid range
between 0 and the number of online CPUs. Inodes are then distributed
across these contexts, enabling parallel writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0a772d984ecf..0a3204a3a3a3 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1046,6 +1046,12 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100 * BDI_RATIO_SCALE;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
+
+	/*
+	 * User can configure nr_wb_ctx using the newly introduced sysfs knob.
+	 * echo N > /sys/class/bdi/<maj>:<min>/nwritebacks
+	 * Filesystem can also increase same during mount.
+	 */
 	bdi->nr_wb_ctx = 1;
 	bdi->wb_ctx = kcalloc(bdi->nr_wb_ctx,
 				  sizeof(struct bdi_writeback_ctx *),
-- 
2.25.1


