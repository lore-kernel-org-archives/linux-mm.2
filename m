Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2BACA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9564C6B0095; Fri,  9 Oct 2026 03:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906EB6B0096; Fri,  9 Oct 2026 03:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF3E6B0098; Fri,  9 Oct 2026 03:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5790B6B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1B74801FB
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:18 +0000 (UTC)
X-FDA: 85302219156.05.5264A1D
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0F37D80006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=BbH8PmX9;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qqaDqlHOxiclNmLEKxsRSXPU6/mDau3uowC+V/RF6g=;
	b=DKJeSGx7nno4SWVZz3UgKeH6sVtWGXBOm1H1D97fo5SdICNSRkI10x7yiWD3CIVGwQw9fs
	bEVcihcnNVRIEfhFW1mic773ZjF9fBv5wlH9aLfZSwmIAHp49DIXG+MpQgRY57s5RQD2OP
	s8rVHmTiYu5M2kE9OU+fZoeT3akZidE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529937;
	b=I4VqqxnNEJxjY8RYuajBql2Nhwy3lVierX3y1wyqhrHfVMTBEmUmW/OJyRWvG5m1y/LYK9
	OBD2skQCdSAvxLmEUz+8MnqGBLNS9/VsExl+6ip/5lpZ0CuLdPmtG0zBYd47dYrU1VloSx
	gKwjFijxTBngnoffVFWqyBZa0PPnRgU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=BbH8PmX9;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e61f017091so12940795ad.1
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529936; x=1792134736; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8qqaDqlHOxiclNmLEKxsRSXPU6/mDau3uowC+V/RF6g=;
        b=BbH8PmX9KzxzKLdYfoX3suNn8oHD2kKtUwH9bPWzk/qLBYrAeBznE4NsQf/4h9ED7d
         20HrbFLw3pDZjc+4Gf6lsVxQxgcylRljTtKmJFt+jrz7fH9C/czChTq1cHg+w/tUUpkW
         KtOOD7o8jVYmubwusTuUbcnj6OazPLLnz6dW4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529936; x=1792134736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8qqaDqlHOxiclNmLEKxsRSXPU6/mDau3uowC+V/RF6g=;
        b=nM5dVr2lAOJiGBChILUZ2kVH4X21aiHnqETg5jLKw1m8x1QH5L4rUOnoL2UYVPS2Na
         K9eq508C5F1KDxeiI4gzfE2oub8t2cciNQvA4YgEIfNrzjE4HAlNH5imIOBqIqXRt9DH
         tOgyT8WHgJz1g3T+xx/rZ4If6HDrPI/3PZ6Nzuq9fTdOEWBZyXNkrJENFSNv4heSBquE
         BpymJxEUL5KxAjujOUiMGkf9LRB0S554imAugpJCvfL0BA5m88FV/cXb6czId/URRvyW
         behg1o+mSTMXaG6KkjdTfIxlvVYx3EErcZqghr6kjpdI9qmqs1soJ0YaeuBKftkQPSlg
         QmqQ==
X-Forwarded-Encrypted: i=1; AKwUvBxPFqU2TuZJuADnUIWIdRlUV7wSNjmrfnFCJpcrcjlVWGKU1PM/u++YthfIBQivQ3MQ2CRv+94OpQ==@kvack.org
X-Gm-Message-State: AFq9FYKJPaPhpfPC8ZJoYuo96AOE7XEnou7qA4BgHpjG4IAXIpcvjSkI
	adO1cmR7mha1J0Q5Xm6yP1sFkuQOuSXvp++lNUnvJl8NjpdtkfNynqrXQCorwuJVeK5UDBrQ7t6
	WqSA=
X-Gm-Gg: AYBFou2SlEka1RK53QdOPGHO64RNUlAh3bishTu4X++uyw7BDSe+T8a/VyMtZygXPgj
	hoAyK42OxSlalA8scdhw+eiyjBGTriItaxDmr1mwYvfU83KWgH6pNOLhu5Ti9ZtTv6fgUR2l4Rt
	lInehWftEmwZCdHb580M6fellNSdSgSsQPShnovgOumNYXIo6rQxmqQI9kDxPT/Vkp0O7HbVsI9
	zG3ZszEz4OGiTsvQHbmBzcCjNxl9Pr4vdnFA3J8d0Ru0NfoTKVn5PDd+onwBPyJKseC0zQhAmLO
	o9dG9uhQ8qgG+PQVUobDSwy5W35afjvCrt6RFd/F21GJlOalxCA0DFEQVtayH9TR1ek5zpx2+Yk
	FR6wtCd6xkO9a8HoBvSBLhX6O5nxmDSJZc+X3CRWEO7R8UL6Qf/xD7hYoNtziCgPmiPFCFyPRsV
	trFeb05bBGowrEHmx3nGSGYWURob5A1mGQJoL2uDE9IGpxqievRqlWmjOuCY8jFDDeZ9FlnGSyr
	kLj8bo4l5TWevqYFhvGRTJ3V+FAQnNL9rFiQdVLx4zOS3NujrZ0aq6hsbzpHxw=
X-Received: by 2002:a17:903:1ac5:b0:2dd:c100:b2cc with SMTP id d9443c01a7336-2e842dfb1f8mr9009035ad.55.1791529935962;
        Fri, 09 Oct 2026 00:12:15 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:15 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 02/11] zram: remove debugfs entry on init failure
Date: Fri,  9 Oct 2026 16:11:25 +0900
Message-ID: <20261009071157.3730698-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261009071157.3730698-1-senozhatsky@chromium.org>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F37D80006
X-Rspam-User: 
X-Stat-Signature: fzwefyika58bx91n3dqswtkm9qcgekgo
X-HE-Tag: 1791529936-280402
X-HE-Meta: U2FsdGVkX199a8f0wF1cCSYH+DfGmV1GoRHyrR11TlFDa7Lb294r7TmIiDtWVhsivWErygTSZ8HyaCK5eAcj/1U83Aav+FyGAP+YesX8Aw3Hz6qCQSgKeIcFlf0X/F/rgIgTdY9b9jRK7bWNbRQ2OUnTUV/MZTUjNQ+vsGaAuJbhTkUQLFYMOsYT3cESXmvndSabuP4rVC7hDYxYpl1HtwLlsbQL5bP8u8GR2H7gWgFIRWZJrvY7f2HGS1QUbRSXogfgnDcEhdD7YnLJtC3xfwz4TAE2fz8d3Ts8WsNaNlIAlP7oDmyi+5QUghKgIkrRTJDS1jncr/TI87E4qIdJXRe2qmBAyiZePD1QB2RQvqL6HP4e9QMEuedPfl9cDM5+XWVOv0RK2vWwVU1e1zKRgSfFxGzXIKDACzTsCodcKtEiFBJJV1T8UyUWrNemjiYrJhE5cQxlCUVxngzocimCYDfKeQNTmmsyWJROMcERLe4RC/OCjnqQ4jqq6wki2Wn+9MbqHQbxWp+ssUi+McDgUpdfAU1xaEZcpiSP24Vp9ZUpFo8dzybxsUCr0YBOOdJGkyYRJwOlhZyIVMrLBRJhwSCKxEnBEF8u4WxfN5zbrkW/vK0ofkvZMs/r3oL4wB2i9o2FJ3V3/KPH3Iopu8fJJK+QKTnagLWkTbzf6836Zennca50jB4rZO51ZvG8T+RJcnhCMjS3fzk1L4Rok/oKuziUU2Bi30oXPq97j+Rx66E5gAVsKd6ACLgN8Slqy3LUjvT87aXXmBab7N58bxMR0rpwoZZ0kB40Ce0aQqtNKMc7pp5Y1TTQHHqmgR4GEQIJDuRInvbmP1WPsdIXnpEXvPawsWfJ+XYUo44E4nx2SLSKup6dxAPMsdTiTvjys+lO23VGpHFVS8fsTOKKivNKBWGZ26CyoSGvsIQcFqmO6glCftq0J4sxOMA6m41LTRjameXSY2qjHyuzMxQa6pq
 u6cR8pOE
 oZOnVdxs2Ig8R4QCBPs+hDt02kJp7TGvLRMVI+4/M8X/aD7NsmOHGtVZswIxcp+jKEpkBWyA1qmvbYexT+/d/9ME4MnAay4yvBG9fEOAJPzvVsF8vr/3t8vX26GfS9khNCrL00I8FSwNk/4ZYDKllqH8uEnlhG8svNSKtCPnmP041cMesxxKZL96t1G/F+QdtbKTP9Pjxabj7YPCLd7Z8JpG/gVBxA2uyts+Bq8WfOAdREAQiLRdSrn0O3ZCUnN7XMow0Y1mAR25LOmopYF776nESJTiJPfwYcxdcP070hvf3KK29RDCWGd4MwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not leak the debugfs entry when zram_init() fails to register
the block device.

Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ab064c84b092..593fa4ae47c4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3297,6 +3297,7 @@ static int __init zram_init(void)
 	if (zram_major <= 0) {
 		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
+		zram_debugfs_destroy();
 		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 		return -EBUSY;
 	}
-- 
2.56.0.385.gd3acb90ef8-goog


