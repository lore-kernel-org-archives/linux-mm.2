Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E0CC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDDF46B00AF; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC0E6B00B1; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42C86B00B0; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75FF96B00AF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D54A5120477
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:44 +0000 (UTC)
X-FDA: 85198068648.11.A17AC4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 45DE718000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gXpoOmrU;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EEU3ekWc3qyXmh8drgRUKtX2xzp7GdjGEtLM6CGh4Y=;
	b=4AbU15xffMx700nrq5XGndYQ26i2bNV1tLzqN724TZjZFs1iOguayNf9M8yBiozfYaZcaS
	lysQMKab4xZ7UoYV6i7AchJnjWpx55XSMFtCCOL5kBMBOybwoDgrhX4N177gd0nrR+XVxr
	9mpI0qiya894q9uO4bL2C1SYISIKjrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050163;
	b=xuwzsxHO6p3YqfDM6INQrlszIgTiW/eKnrZ1AMp8hHJpbqyEgZbAcc+ssgCCBD3q1Q8SL5
	5/Stt56yuIHyF0RMP7L91N81SN5cY9OhqWRL3NAPKyXIUAxwUiQF1GDU6EeyOITYNaEwVf
	P4DykIk2zJtPh+zUY9ryWlo5phmT6Mk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gXpoOmrU;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FEA643272;
	Thu, 10 Sep 2026 14:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4DA1F0089B;
	Thu, 10 Sep 2026 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050162;
	bh=2EEU3ekWc3qyXmh8drgRUKtX2xzp7GdjGEtLM6CGh4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXpoOmrUUCCHE7ni0HxrzQMMywG2pgvriZVJEqxcveZEV4i8ONWVLtiT3IT87qRN2
	 9qiaHF/6LiZEdowdIvncSyHDFIjsVlcCb3Zagivk2h2o75tGk52pLbBSrGJ4nn6TRs
	 drPSgsanau1MhUODggBEAirCYbpAxlAcuQX6M7Z+4YkWHQxR3kP4ZhWwEZPc0vptu0
	 taRDJX2G6J39PJAU13ZJiQ0LrrRk5eUeto94C803Lev1/5EsZ2VIZYA4xFv6LiTqOh
	 DB3coUG59dYH7foek3iOueUTTdQvceWAZIza6U8BjJYCSJ22EsP6uFk8Mw6K+IAKz2
	 Z9Ya46a8KTPbQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/5] mm/damon/sysfs: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Thu, 10 Sep 2026 07:22:31 -0700
Message-ID: <20260910142234.171562-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910142234.171562-1-sj@kernel.org>
References: <20260910142234.171562-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: p9ypmstmm5i9uzjybdwzkpuk4y86w7zu
X-Rspamd-Queue-Id: 45DE718000A
X-HE-Tag: 1789050163-113906
X-HE-Meta: U2FsdGVkX1+kTJIsgvPLiZ8rmj6TFsHDOlqAaty+CXHc1I3/StJpi+ZJzhrkZTlzecleVANT4I67lidZMK/4ctd/V6eZD39n0MmTGqy2MAlzL2i/Tnkpl/1Rcuok6AwMuolPWno4YsHSud8y2+qoXkwwR/Yc4Rcw6HaNRHR8CoWil0oluwI8ViSMvt5v+0hHdCxkSHE5htKTtyFecg/+Har84kvqlZFbpuc6j7J1RIOM3UutV7Oz9NVseGET2HexHnW7KfWmVfQYCvkax+SNLvtVcCmFw5uOKThCMvi7HkmRByVMQT2/776i/rq5O4i6UawYNpWSkXpZdRaAt5UJCHhSl5+iShFR3bDZkMZJD8Xe9trBxGjDEOnpzJDJibgHXpIxNz3s37qfr6cN6ULDsdXZA60puo1lHJMXeIy4TLV9sVMBGuO3lrP+WHQ87VrEDkrzMp8rqrolpgG/xeDtiQZYB9muvnqm41wH0E7FGqlIcLK1Nm7SUyuiVW2zfmzAIlO+Ty3Kymjq627SVyUGlAiugD9F90TUxssaZdS9ViCD9ojSXui/mr/OD1K+Cfn3g/BdsDdEQa34NHtmT3WyFSMG4a6RRTug5JCvimeuL6RYDlptMz3QGTJyaXpMry2ilQVsCezIuMB+3e8YyAJqANV1wyjwsa4GcUFFGwgyv6mLwqbFLUeUdtmfW9v7rkN3o23Pgda8vw+bCyDXuslPFoRzqnO7UwzNkYa82ZqdUnauNnx550hJBOMhhO0iexHLY/GfoPycSS8Dr90fHeugypVoTLpQJPOr7T3HIbXoLT21KU6VnNeh7GXoQi9Uo4yyM6mWfAKV7bb3KQbr6TEjhJLReF3+3YSrvz5/F6TPML577XXZ/ys2P/uHj6cVvaubcEEkSlrODuUGuN7Z1QRUpmk34sRf0O4HzruIqquEkDxTUAOxlr9AEWynrH7z67mqPUS1S//2i0X08li0/WJ
 vm713Ihc
 RIzJ0cbAzRAhnuIfoItsO+tnuR11SfO+g/n6hfnv5Dj0GPFvQBagM5NwcM7TCHORpemsjgD7urFGsvoHxClOjVlTCzjyX0rqnaT1XDUlsz6wauVA4o7JE8VJNGW7Za/ZlOEEY0c4k5f6Z4w6XB59wPir5f1XTLm88jsWD2APG/+v1wtgaSfstPZofbcympUyK2Y5496SD8tIot+1ki50EQ4nT0L2zj2CJxgY5v9H4a7KCydXZP9uMybG0+Fw4pnzTY4mTUQgs4lmvfCHkCyp78lliCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to let users setup
DAMON_FILTER_TYPE_PGIDLE_SET probe filter.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b576e97cbfdb8..51fa506c879b0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1001,6 +1001,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_PGIDLE_UNSET,
 		.name = "pgidle_unset",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_PGIDLE_SET,
+		.name = "pgidle_set",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

