Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0333DC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34E996B009B; Tue, 15 Sep 2026 10:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28A0F6B009D; Tue, 15 Sep 2026 10:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152116B009F; Tue, 15 Sep 2026 10:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAF3F6B009D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF17912046E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:10 +0000 (UTC)
X-FDA: 85216241460.08.04C7709
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E98380003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IKTfjrvb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IKTfjrvb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482849;
	b=DyuYz9LHF0Hf51fRZ9maEB70pKzdw5ad0kMBKwOsRmRkT1Hlu3edALecMD2q/vkSwED01L
	radxbxaESdfq7BXCorUVlBcO+uAHrKGOlaL5ZZXGrnxXz5/KW1SNFZrxPNKPeRs5w1mi+J
	6puopVA3VXOIA/260N1CRUmT6G2sJMU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gmq/rX+sVM9Hs+BxObGYka5NbSCER5H2QYTBCAxyvwk=;
	b=CuCR+0kgNTVmFQKq2BNFERWOu1SC8gS/7LdAqaSuLZcxocdq3hcwa9FKo/U7MtOkh+9isl
	/vRDFJ2t1o7pLJebbBhanuOb60vfkuBUV/j0mfXZNQmRruaINFmCkFgupeVA/FxOSD/o0i
	llF8sxY/gMUji9S7Z5Z6rm1RJevu+7k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0826C600C8;
	Tue, 15 Sep 2026 14:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C02F1F0089C;
	Tue, 15 Sep 2026 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482848;
	bh=Gmq/rX+sVM9Hs+BxObGYka5NbSCER5H2QYTBCAxyvwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKTfjrvblH1XAFUn2DjPAqJOUKpweJegz/oaoeuPnAb1YEh/1NPFZV+zp8yF7an9v
	 upCA7m6JMQQSaY0IyOiGHkKeAmVmp/illE1BkjKz5QkNGofmZdbdNcN5ythcp43cLQ
	 eUk0zpBFHAiFtnNwS+kmJ4AD5sZTpb6lQLqPmSOLDic1MYof6fLjIhQGVnUnno9E46
	 /rhr6AzaKVFx4oRc3o5rVBkPm1w+8fMdLO1p4Ruw0m/IAi8ztHUJMtGgE+/UILgj6F
	 YEGbY372kdAxW75yeVzVD5U/SO7diUak6zDkMiNu3mAliSybM/f/mP9Fkm3E8FHa9N
	 OYxmEhPjvDOcQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] mm/damon/sysfs: support hugepage_size probe filter
Date: Tue, 15 Sep 2026 07:33:54 -0700
Message-ID: <20260915143359.91472-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915143359.91472-1-sj@kernel.org>
References: <20260915143359.91472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E98380003
X-Stat-Signature: odnbxz4efcpauedfwkz54cp799ksdawq
X-Rspamd-Server: rspam01
X-HE-Tag: 1789482849-977290
X-HE-Meta: U2FsdGVkX1+tfsR7TSL0v2h0+uE5KwBBM457My2tuWCPA+sDWmZRw30odTzi1mZ1ylSzLQTg6KDHy5mkBXnAtMn07nmsHeQJHuuqnyozcUt7Nbv5zSdB+gDD5AXcIrEw7ycwf31qvIZVA4lp2IpGalPKnL3ZKV1vps+aEUkUDDOmxQy3iwWMr5hIcbfBEyBMc355aTR+3h9NYLT2K8gx3i+OyRgZedkxxnLosTU6kRV+klBzXA+LgPW2QLjb/pSo2c81FXBHbUpxQgPS7pIiHJnqZX5Y8Cn1anf0w7/WlETBfY24SQcfF/GZU906ao1/Z9jU4Rf8zR9L5woXJ/te9lyKPKNC9TGaFjRWyArcz4TjIzz6JkjCfYi7r95ayH23vtUV0m9xgC9E3h10pHfrmbHzKaOap8cw/S++D/W13OoepaO3wqRc18mIEGcrpXIn0+ietNfphvWmzBbCW3gdmWNV8NavX9vvOh6nRdHoK7ZFwo+60kkY6ERGRv96SsX8gL+XGrnGRTnZ8bZEIjFj0uj8T1hJuiKZP63T+L7ECWE3Zc4J9VW7LddIPdTE9A00XYPCr1AqkEo5tAVfhYGgNZ8GEfHZ0Z8ltgQHazxwEO8nTnfQlgUIu9r+4+q7Np3eB3vZDPNDg+qqjLCw6nrffN3TIbszJ2dJ2eoR+wTSTuzq6FVYYHa43WOjo79vq0d/4o/s7iMR6JN1z7+CidrMx/UFAFZZdckkVG0Y1P4c8MprYL1Y2WuX/d5HecUcly5mt85S6Xuo2l2/m6bsnvwApgiuKgjZe5t5gRbBQWPXwA0MrbyGFy2IKLeMeYx/3z6gUKB0brMlqlswbkYsxAuckeE13KMEB8LjCg93MswkpkZg15+LtKhb1l0JRpxVbPTXPjtm2qzPUv1TYuLA/lsKVlERTXLSsauM5PISeqLGS8OHErgdaJomhu8BTenFaxLgToewUH7+V31pxIKMMCV
 aN+eY9rw
 hwzyVZjMgBsIiX7xUXMv+PY99xrVb7M18d8qEQ3M0ZbG3BvWlCuH5+BhJ7SGEAkOX4wNfMXJ9YY6Sr3vdUikEDczeVAjIL79Yc5MnFOae4vUzoSEXyMTWRmwQvsv7S3hThZD0JU8ymXHWBoBeVoJ8Jvy2oOhFaIgGGJU1HrKlUPC9ksMrx9aGh1GqKxl2ZSNPtZnDxQNxuMrzaU03Oqi0HBoPuTvw/tlP9JdU7DtoxnjWGfTnxcHmfuAtFGnQ9hm9UnrbkivRoQE7xCos+sUz7jq5AqN1HpkdlTxEHLCcVVfl4OE7CGE/qytQIfIoqJ05rZZ3YK+4/PcDgijQG24vzc9eUUb6KztZ+I2YpQuNNIJDR0k=
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

