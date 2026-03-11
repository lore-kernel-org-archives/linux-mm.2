Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE701125892
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6A86B0089; Wed, 11 Mar 2026 15:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E3F6B008A; Wed, 11 Mar 2026 15:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108516B008C; Wed, 11 Mar 2026 15:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F086C6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:51:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A40D1603D4
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:51:58 +0000 (UTC)
X-FDA: 84534827916.10.B7FC595
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8F941140007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:51:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i9LXnR+R;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZdSVXkR6xOKSFPXSWZwyldzzATjLCewLPLvELCw7LY=;
	b=CtTB4c4YxhT0eSCkj5GMU9g3gNqZGot5V2t1SJtJ9IfmOc4aeaMad4AGH2sLj875Wzwye9
	lIHLbp8VMprodpqbiAHihSkIa8jS4MvCu5b5LSPEpm9dZnc+e0/hDpLOXHQ81OQhC4KyiX
	/ycqujMZqU479M7ttBeItMMisDbfNok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258716; a=rsa-sha256;
	cv=none;
	b=hufs3eMj1bbSPV462s6pC82qizFfikxd2DsqMd+tpgnceyl60bEL0OcN0V/LkkbDlaVjEg
	ZGG2S9B1Wvj7Of1FcL0QC4wwpOb4iu+mdcNW9o21Ib/5UvfM8PTWpXguRaO49Wi4w8D+7m
	FwsFotLdBKWayyQr/xMu4yxYc8vfekg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i9LXnR+R;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-404254ffe8aso204014fac.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258715; x=1773863515; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZdSVXkR6xOKSFPXSWZwyldzzATjLCewLPLvELCw7LY=;
        b=i9LXnR+RyoR1NUprwYZQrUEPnI7KZ4xVwZCAyzyyFXipe79iitJo/AdxqEZKr5m9HH
         lTKhWwlCNO1FThN/lSbvl3E9s6+cVouCYxsUpC5ktvlEkhVr+SP+hSPQgleWDkGK22IJ
         L/mqAM3FwPIDzMOqA35F+5bneWVWxHkqPRC/Apt4R5bPlhsvB9yfjOJCMngR1GNF77ky
         zE9SkbIBpSyy/0xNErBkCyPvtPWWNOy0dxtaEZjEoPcHyAGpE3iZyZe6kaTX6zOSET0F
         hCTb6Endn9c/zOhvAytNnHmpBvRhRoajCopCVtUVacbQi+QPYubm5wmHT/kBjlmP/RdC
         ffZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258715; x=1773863515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FZdSVXkR6xOKSFPXSWZwyldzzATjLCewLPLvELCw7LY=;
        b=ZsEDGTrFJnE8SLG4510Sq8sCJZtTvoh49veJtrNGiyLTY3vhvsfTXYn3Ly6/NqPLHu
         olmuwLwrjbHppskhdOljFtIJXpd9J0cpnKs/eRj42nz6/MQ4cJn4UBnm5TxInwMaMlP9
         sc/NTD2HWfq9PaCVMTvK3nXmExfhK94JzeUVqjtXWMIAq+M4yBEoMwZvdkOu+lOiCh6F
         HhRNKZ7+LQQZzpSEjOtS4NHVel+r5wESxfV1X46w2H38TPFTn4dZ9OkJdUNKRgIORP6C
         0ldt8OHpDK+cnGjCRCr17cKz7rAJUF6q1JTrOKTWYuFEDpRF2Mmuh1kUFKevrpR2j4m2
         WvTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXchAi/9FiEu3mI3BdkG68YE4RXH5ZYaA9k1Wj5rQ0T5mI+u/YrPT0ptpXrToxZXaHbWgH2BeQUtQ==@kvack.org
X-Gm-Message-State: AOJu0YwxGGalvyKWjC6MHeIuwsNtL4ORsxjmWEhIlG8tgYo24NyYhNGe
	TY5DC4VWqPO9qCG/hOBEQtPigh4+/MmQiF9f0qt18/0lhf0RXDo/rJks
X-Gm-Gg: ATEYQzwma7pmNuH8lTdklsJI+IlM/49GOyD95UWDbrvfhliZ711qPO58QNpecgASCqF
	K7YMQm1MXJOkrBLhSTrTi434ZfEM136w3EO55dWEfd/DMNsl+SM5i53QxYdisoUBTDYuGRZbHOL
	S5CQoJ6y4cTgk0nNjdcSn31GkT3lux6BsO2EPzbrORXB9t0SdCm4Vi7NQXhJFEuYJbH5x59+h7t
	MxPaYsK0b2IR98UO4bmUiP54babmtUzzbb1kwJj9woD+DIehYnx1EfWtxoXHrSVlYsSjvNwh/O/
	l/W0pmzy3Iob8ascwzTfuSms10FihJXgwjkyxsMEk0YbSPx1gZmhZDNh42iHUZz02rEUiwfM0Ph
	Aptydrfx7QoARdAIwd+TMNbKPYGKgYzV38jRqyxiSkzSZK1PMUW7qJ6OYsJDEqPPIch7G2j6Re6
	FzxOmCBZG5EcxRrhF+sDF6eZIIcyEZiZWP
X-Received: by 2002:a05:6870:a346:b0:3e8:9b72:5cda with SMTP id 586e51a60fabf-41798ee621fmr598211fac.11.1773258715531;
        Wed, 11 Mar 2026 12:51:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e26e2c6sm3145231fac.7.2026.03.11.12.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:51:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 01/11] mm/zsmalloc: Rename zs_object_copy to zs_obj_copy
Date: Wed, 11 Mar 2026 12:51:38 -0700
Message-ID: <20260311195153.4013476-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: g43i6ens4e6fpmjma4kxnzm9rqegmkp6
X-Rspamd-Queue-Id: 8F941140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1773258716-147980
X-HE-Meta: U2FsdGVkX18TW6H13lKCb2OBp91EDicM8NWB4ODX4Uh6AWPdA3hwezjUoNInsEAFjbjYhU+ChU78NAFJJ/QjOenuWHdS3Qjld0LEL4MLOIdyh/7atBWx9+lyiHhOZn4nG/0RA998ObgZ19gmQOcEluhRcJ+R7u1aS6xIOEwKG5RBDRp6BCGFBQgJoNaIe60DpFrtGzceoMqDuXlpX5cJbPqnEkIdD46NY3xNQr9/UusgcWPuNJf4iIfCcgKCm/BVAKZ83CeqWY7Lik51dE5KIjqu/iCtjn4VivXNnL3PQWH/ya7o5WBcdLvcO6TA8Zt6qaxp+5gk8whnfAv7zDpSDMFnuPUQUIAn4HVrj4oOopk2/HDQDzmwtaT9KPdNJlLFhGonTyXswBVw/h5AksMqDikapNP8TMb+VYaNI3fIjR7Z4H2EIFUapblqX3XB63NsyTUF6gVfWA0LRKzpoT2dPuYUxeIrEbCHf0pgYkndvtdNYEZ7JGoM8LI34xsDLzcwRQIYwp3NMndePczygp4T0gORK6KJHpcGIlvNYzI8XcGx9Fr7wWYeLIVVjZzIX/Khp4ngxCzLMu/x6SQ+tqQpp1qUa4eNVvv3DPQuRDVzoeQUg8+njR4m9sGMS9cF2CNkmhqq8lQwhMMYho69/r1KCt8e2o43TuK3zDblJAo3y3buKvbX7bCD+SZE4ekIPvbCpKHZbjuejDSnSCZexqpNxV1kHyBWRGwF8yAGEcTYlqjKR25wUbb5WFGv/PgTVjqm2vRPz+fRTKc3NUhg0gm+ugA3gkqjrU6SmX3g14JRth+U38p2TCE+jUMljzy1i6iu6gWU77Gnx21vGN5FFUxnItMcuLx7Tj6B/H48dk0yDNR3mBmdzLFEglxuQ9FulO0MkKLDAhBplARP1qRF6SdcZtX2nvJ9dEbZbk0rePczicosKLSyVkOWWouFcvnEr8+cvWd+C/Azlux1QHq2dVN
 R49La4Ar
 ek0NKqK0K5EQNFT+YlAEkx3GSV1+xPOF1NjXr7NHVq2y2xpdor90jH27pogrUvKXqrAOjTBbojXhdeDOMgfA/5htHvAv+95SRP/8qBRdEJK863RE1f/M9X9ETtBuvpgtOKuqCUyDF63fLmM5fcES+vW57MG10q8iKuh7975bmR05CdDRSKeRGr2r3ZOkvICQYIC02MsLZsXymbuz4xnl9c6hECPm8jL8p27wsJTuCqlAJpQ9Ays2JAQ9bUNaKsWW6Yqd+GrgRbGNaxqKLcm+7VEDX0s3S3qSYw8p+H2fhK3J5gp5RyZcFhB2bRWgZePittdVH0bXXrBtL+8Mh8jUkmRslS8UTe3sXPV75VRUDgmdaK8Q7zkE0xG+7f4XIg/gJ6/uy2cdcWnOPZ/Dt69Joc103RNHejhSiFhSXTvOEWa+cMDXl9v8j6vAvtbg1fkP63jDV7dAVJmKY+eFOWKnmW2b8H/mhG0By8qVw1Kq2PNSme0wZTJGMLIqvu39bDDT3rBWEFHrpO6bIudOeEITw9OS4j5cfhH8swhgH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All the zsmalloc functions that operate on a zsmalloc object (encoded
location values) are named "zs_obj_xxx", except for zs_object_copy.

Rename zs_object_copy to zs_obj_copy to conform to the pattern.
No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/zsmalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2c1430bf8d57..7a9b8f55d529 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1416,7 +1416,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
-static void zs_object_copy(struct size_class *class, unsigned long dst,
+static void zs_obj_copy(struct size_class *class, unsigned long dst,
 				unsigned long src)
 {
 	struct zpdesc *s_zpdesc, *d_zpdesc;
@@ -1537,7 +1537,7 @@ static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 
 		used_obj = handle_to_obj(handle);
 		free_obj = obj_malloc(pool, dst_zspage, handle);
-		zs_object_copy(class, free_obj, used_obj);
+		zs_obj_copy(class, free_obj, used_obj);
 		obj_idx++;
 		obj_free(class->size, used_obj);
 
-- 
2.52.0


