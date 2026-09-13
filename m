Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF964C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A489C6B0098; Sun, 13 Sep 2026 13:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A217B6B0099; Sun, 13 Sep 2026 13:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E276B009B; Sun, 13 Sep 2026 13:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0EC16B0098
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:11:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D9E1C08A6
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:46 +0000 (UTC)
X-FDA: 85209381012.23.F4E3782
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7507080003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=grjHdB5J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319504;
	b=N8i6tmC9jykkSuNtRNyoU0IP4NVWVFj238J8Q6nmNm2h5RXn0vweS7JESMWrkJS0nxJe9K
	BX+/PMN4KS0cqnkUoqS6SFI/qageTurUYWPUMw2ps5ZblLlF9GEkBNfll+O9cFX5zzKA01
	ATt2nHhgPVZH5eEwWw4EMsxCQN99EfU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=grjHdB5J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gmq/rX+sVM9Hs+BxObGYka5NbSCER5H2QYTBCAxyvwk=;
	b=TR1Oz60G2xXr0yENiEtGln9Npvedrx78L+1EKIA/dzhUbdXyo64THYLZ0m4z1EwUruZ8TI
	+v2M6g2rl3wi0WWiiEpfBPJpBan9+PJ7eJvkfQDsM2UPSSefXy5Z0ZzXvYyYd6YaVsYIwf
	g6T8dhdMK9NHS4cLzswtRO7EGY83ylo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8BF54493D;
	Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F431F0089B;
	Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319503;
	bh=Gmq/rX+sVM9Hs+BxObGYka5NbSCER5H2QYTBCAxyvwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grjHdB5JfSV2S4KoV2DSG4jMiq0joP+rFzG0kUDEkqoe2qnjvkezksPoFAR0VQ4F+
	 7MHIEqYiUD29o/RdHRBk4hDizlFMTIR1y8At9bnv1fzjobBrG4ksf5SkpXRyD/QTDi
	 t30d4OqTbr623uGPYSY4AkHnAdpoJAjN9GP3iA585BITW2qfUTvGyxXVNBXzm6/69M
	 ILGigpq6yNpquSS4LLqVmn70/ikuRUKSaxCWNzFItZt6YU7PEhpAY//MdUnxkoZ38B
	 hfOvqmAthmwIkaQ9Fq4b8BokXBzbOYjmKng0L9Sz6ta4UyCpTXCbW7ZnF/KVoGLfXi
	 VIRkJDccJkdUA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/8] mm/damon/sysfs: support hugepage_size probe filter
Date: Sun, 13 Sep 2026 10:11:27 -0700
Message-ID: <20260913171133.102366-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171133.102366-1-sj@kernel.org>
References: <20260913171133.102366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7507080003
X-Stat-Signature: t7minq5toj7zm1dpb4fdmfngt1i5kuf1
X-HE-Tag: 1789319504-794174
X-HE-Meta: U2FsdGVkX1+dCq9lAIYWbitdJMEk4+7twFdOia1ZNIX9FJtcuIXOGKWE/dC/rIg1f9D/wuLSLh4jXro7iOosPv89/1d8Zcqsm7uKni14Taox4EMiLJHPjGcEG/vmp5Ls/smeMLe6Ek9Hy5sPz0yEztdziud3zlxdN9KEm3wu4BaKCZd/w0vjCcEs98sADGLG8biqCT58HWU/j8G2j1qoUlLhQZJLJj8XHrvxImljXx9CeCOBo9t5TAtadM7tj54HeXl5fbRUQ0DULAKJoibxO74spN3DfdAdvWn59gtCnlzEOZYec54fFZGJSe9HzNw88STMhV6k7thuMmTKQmGotG0VE18Na04eC8zZQtVZXnEcdXd7r9g1BrYJjSO27gkBGqy+oC06kK5/xX6x5Yq79ssJfSc03EtQJBSMPm6iwGT41PVSsBzWH7eflTRwdB3TCWswvi6i5Hdz1aQ5cy2jhRuKtWc3F7ALPwaPujmlpxS8kPyV1UcDKX5ozR0b8NakscqXWNjdzC0Jtdb9AoKtHwmPjqV4S4PF9f4CX9UYLe1frAs1jxjsg4aVEvsJwEmVCE8WpREuCupvMvJ/OK987SDbmpAPq1qk45U23IP13uhS1RdzeQ3l2OFUDj48LMdv0udts00U0GGAh0Dh8rHhiJcXvUM9ogxGd37NuLNfJNDNfNvAlNz+FYNyrGnF48aW8Vd7lVVAOqh3jxnmGdRlGp3W9i+mXw+sI6/MXZHMcF69fCcaWWxWM6a2yLHcVUQnXiqdfffM5pXsaoatvqWuKiBqPAHboZhSTKzwMhZ2ZNquX30hJ9SQu88hDgGxd22aieIAjjTGR2N2E/Zb8KKjwaIduUwQ5mkqVGVoc8nrguIBjpG7U+Uz/L870D/bTtkcO6lAgjsq+ElwhaNfSvdl1+vqDpp7mFxTHN5URr9ZZzVPKFA9XqUE0yja8jZipLeabuEujrxuwY76vZuSXua
 7TckXBbX
 1TVsEqXHk/ABdHp26+dbGEwvIkw3AtvIvACNIKfuGb3w5mkGOqdbGxw2gIJbQjnL5jwu4AGzk7xamwxtwvVAlWCRv/5GqisvSxMNe11ZWvg+UFCSzU7rTkagBn5pHu5VAGf9e/7QZEkE4i1BWZ6wBqX3RsvT5BA60Ql6wJ1kOOv4PagvZzFIfYLRsCQ7a/KP5NKrbILY1mYAgtEbnpFAB7d23sLdge7IahViTNxWvFWUaDy5CiIq7pPUgxz/TJpa5YOka5C7G9IUzIJ85wmvwK0cofA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to support hugepage_size probe filter.
Allows hugepage_size user string input to the filter type file.  Pass
the size range argument that users set via min/max files under the probe
filter directory to the DAMON core.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 8e8d89b8ed981..43519afb9eb7f 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1007,6 +1007,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_PGIDLE_SET,
 		.name = "pgidle_set",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
+		.name = "hugepage_size",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2273,6 +2277,9 @@ static int damon_sysfs_set_filters(struct damon_probe *probe,
 				damon_destroy_filter(filter);
 				return err;
 			}
+		} else if (filter->type == DAMON_FILTER_TYPE_HUGEPAGE_SIZE) {
+			filter->range_min = sys_filter->range_min;
+			filter->range_max = sys_filter->range_max;
 		}
 		damon_add_filter(probe, filter);
 	}
-- 
2.47.3

