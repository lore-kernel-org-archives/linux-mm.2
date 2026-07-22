Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 991DCC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 11:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4BC6B0092; Wed, 22 Jul 2026 07:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986176B0093; Wed, 22 Jul 2026 07:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875CB6B0095; Wed, 22 Jul 2026 07:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6289A6B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:34:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8E0E80158
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:34:00 +0000 (UTC)
X-FDA: 85016203440.23.B53259D
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2B54E40006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:33:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=euqyDzVU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of hank20010209@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=hank20010209@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784720039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtTalQDtKgX2+sfw/36efx5Lj5w8MeFStk5ysuXqYT8=;
	b=dNne1tSlkmTl5T0K4TsIGrh/8eNky9fQnmlS3K0rWCHKld0M4EJ5MUfyOOPyzYUVz5b8Dn
	jzNyGcR0arcYjn18I1+XxAOWc2W38ktyhbfjDZYz3WRx41ZL1KRG562xPZGsARq3YK9z73
	kXhkfMuW5NaivxqDBrKUamvDMrI5W7k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=euqyDzVU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of hank20010209@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=hank20010209@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784720039;
	b=ypK7dFrXP8m5lmKF9rO37iwb0wsxmnsnwfyZeEz19orZoUL6ktpb8buthjJcyT5opzA9aN
	I43zIzGxDHRLjugF8kjHDF01r/nMwbVr1TPmcMnTpmrqTtrCc33X3ehCUk9+X/Gcdf223l
	IsL0S0MMfBOJ/2ggEX/EeDcPkzRyA30=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso5661790a12.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784720038; x=1785324838; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YtTalQDtKgX2+sfw/36efx5Lj5w8MeFStk5ysuXqYT8=;
        b=euqyDzVUo55am1M2ltqCYloupDMwGLwsrdteRNzMj65k6t9iqMZ7+WEpv76qwaOFVQ
         bz2/3CDKvgb5uQyxpw+pFqFD6jZqrqh+EH7f6BDl5UwE5IRladPhkPqADbcrhU+gsOTo
         h0ibOEjDKeX7ve6SlaqaGawD2AE51y45cRvcHB+4Zyd9Oiwg4dQZ2mhPFA9gnOY+cUgp
         KB/OoGyFlv5skONPCEuUZ1Xmq3PqLJegrR/Ln0L+SarWptJd6Y53aA7fwcuypdyPAj/T
         53oNl8/aigVuArBPENGqVK+xJbtXwzZcP3ynEyLm2XK14OUo9jMYpDCAUObZjZdJROZU
         a0Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784720038; x=1785324838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YtTalQDtKgX2+sfw/36efx5Lj5w8MeFStk5ysuXqYT8=;
        b=HE2GEYBnoNQD09YtSxqPfhgJ0lJpAPWh1VSMUxQm/enCITItHNKPNRIkFfYa4okTAN
         ourjyjgJggZwLDzTkUflvWOSbwwZF/a0rkeD3WrPuLF4A7cEm/sGfswMI+alZYSzwT7P
         zzwimXe3kl8nqHp3XnyvRYkvr95epOCg+AI6U68yPlhVl4IElX5tOn/xQr6G0laliyaN
         iuwE403/az0/Lm20om4feOYoiWWyE3qbh3F03d15IJG43cuIJ3xk6OWDC7dL5l1BlSHm
         KFvQlERuh168kE2emiovBL09rQ14oMMJk7OrYpFo7cCqRMUrNUUgdxhs58sAek8numF5
         vzGQ==
X-Forwarded-Encrypted: i=1; AHgh+RqsLyK4CTn+17awdBhuukt9pkbdmlVN4RVep03Y1KU3q15S/tXMPumxSQujzUM1+9HI/9wVubdf9w==@kvack.org
X-Gm-Message-State: AOJu0Yz2yWPAibCzEVASHBK/3gqKld1+Umu/ORlZdKV0EyBZQikcYjQa
	hSlM291N7aaEU2G201pM3VEdV36zYr3lj1jmoCuPvVYdJmIwCbkZLTvF
X-Gm-Gg: AR+sD12CPVg9yLG2rdF2WqsOkRP2bWd8/9bOUIhdayXBOzEKgbrn26vdJRCSEeJSIKO
	nfgKclhXbPbi+uGt6xl61o85NCnixqQ6h28bxHTyggkbcF0QkdgAmiPFM5v3r5wK1ZavJSQjDzr
	d/pEv1OiopcxFF7fyE+bypsrl4DhfPfdhJYeauYsAzIjq7s2weLSmVcYqg148ENt5gRUWj5yhMf
	MrLDF/1Z8PdGAIapZvicrFuBnozfZTIjykchj51ZD8y0HDTmRMnbcSWFJ1rBZg3OJ3gOuzDTFoD
	1SRdlYbDsCFqQb5W/hU12npLrehfanR54n+1bOO8CHlML7GpSClv4QTmb3CPVvEe9z288xaFaAH
	NhFjjYWcrcGGnVh9JjYo8vVMsXVirwgFRk1rUvNyZZcZp3PpHnWZCiEMPac78vL96sqAbAz4SJH
	bAigaNj9yrRBRpsL3Huw==
X-Received: by 2002:a05:6a20:4388:b0:3b3:fc6:622d with SMTP id adf61e73a8af0-3c3ada195d5mr24819669637.38.1784720038040;
        Wed, 22 Jul 2026 04:33:58 -0700 (PDT)
Received: from apt.tailc82bd0.ts.net ([140.123.97.23])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f1c376esm980979a12.29.2026.07.22.04.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 04:33:57 -0700 (PDT)
From: Cheng-Han Wu <hank20010209@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	Cheng-Han Wu <hank20010209@gmail.com>
Subject: [PATCH 2/2] mm/damon/core: remove unused damon_nr_running_ctxs()
Date: Wed, 22 Jul 2026 19:33:38 +0800
Message-ID: <20260722113338.302603-3-hank20010209@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722113338.302603-1-hank20010209@gmail.com>
References: <20260722113338.302603-1-hank20010209@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B54E40006
X-Rspam-User: 
X-Stat-Signature: frod16ez18ehjtnwuohu1cob39odpyfg
X-HE-Tag: 1784720039-383675
X-HE-Meta: U2FsdGVkX19m5tZgYZGVPnLUA+mVwPZjpsZV/3tiSHNnPjawD0XH5iBo1Z1UYQMmmFeXvGBC5Uf71pnaJr/diPjhWTjPAwhlE1WtZ7CPrgbJfHDFvpbSFNx7wagC/4v5Wfq+A8q/kwTYC26CqB78o6PkzsPCJQyFHGlLYm9fVq4pL3vOTCyS93eDwyloA3krRRm2uZeilMNhWVpje+ajULKMQMsp8AoVSK3QG1iuvz30w9h07hR6/KeFrHOZC6Cf3e52QmOXX7Nm9fM5geGnkFSzcH4H71KZRGNAkuEoeIwIUQCRFX+G85Uq/2zDLdRLl045KV11taCbV8UJkYZch/jg3Y2oUR0qHgZr1+3nPktl+dD+K/mryXFw/3908R54YbCn9RAb0MAih7AlSH99VyPtUqlC3tKIAdBMjFETLjcc5LBDIG2OgaxLfEZjBTp/b2N01KM9ot/eh6G66v8BBGRf2qnsXKcANTdnthL6Jgb6RnZU9seqlFr2/ks01gvYPhv/B/Z1j0jPKygGXJbr4O0gXWj10qX7TwDal26GJbu8QlQiHH8YHJsFtX5HoENSfnBbcn8lyWyaDB9trzWUpR3ZOKmmUZQl74nhpHa/HIgM83iGXZJZuZNgALGyxUF1YMlUeVfFrF5NrXyYzca792SP74EA5OUgKDDC9nj4v8g+zoknNge14JzHVro9dJDGxeqep6WSuo+nGIYX/P3CYXvvq2buoGkciY9e2qRW8NTGr6Odybmta4H2x0MyemGOzKFVbxrnkIYL+zUMEj1eVwY3JHwqtgPgaal0nsfJPe03MtSiDm7STaH53NYmNj+z4QgMiH/Ll8ujy4gBZwzwdxecVdkv/m6i0CJBBRiKbnfSSVTvCZW/wIHT/UQtkcfEpSUT8tf0Sr4Z7rIgKsSZJcuF+eoU2xCUipzyExPWA3fLPVzpZ4T+LczS6jOmPIxOlwIq1tQpd2XQN2BUxEf
 haj2gXvo
 q6PmEZt4kWn5Gg6MbmSmbYtjYxxZ4+YFIyYnUmVSVguqAcf1f9JvglnfmzjfK2dpP4ruameNFLuc8JTAjysHZnQrNj68E/urDDbYbzY8SufIO6GZUyseylbwdrizJVAwOTEGQ+8UPm0DI59LSBJ7vk6Vsa+OylwS0VJALW2ZoCvgMgypIzlQ6z0LbUW+DPLmkruNqVCeArm8oGuTRk3t+5S6RibxTYOW6QP3USXGkzxux/nSzxbbwXA4D55MswnC/pSPzUHjcNdn1FYGnZPPUse0kSWWZBFBZoQRWrVTyJx6OKiYIEaoZrmvkQoipz25qREgQ9UHKmzXLwdTaQrZtbRfeqam57U4kYq11mdbg9O5SWfANQKMC+T0laLwLnx4a6jfhlXHdSRWEnVz/fToH5o3of78vTYjmLUZ80vRmih/np/QJzao1bDVo3//gnX1R8WzLJTRmLKtjcyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_running_ctxs() has had no in-tree users since commit
5ec4333b1967 ("mm/damon: remove DAMON debugfs interface") removed
all of its callers.

Remove the unused declaration and definition.

Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
---
 include/linux/damon.h |  1 -
 mm/damon/core.c       | 14 --------------
 2 files changed, 15 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 8e5589ccf50f..50659c9083a9 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1064,7 +1064,6 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs);
 void damon_set_schemes(struct damon_ctx *ctx,
 			struct damos **schemes, ssize_t nr_schemes);
 int damon_commit_ctx(struct damon_ctx *old_ctx, struct damon_ctx *new_ctx);
-int damon_nr_running_ctxs(void);
 bool damon_is_registered_ops(enum damon_ops_id id);
 int damon_register_ops(struct damon_operations *ops);
 int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index da97b2dc39d1..891f851bcbbf 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1847,20 +1847,6 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	return err;
 }
 
-/**
- * damon_nr_running_ctxs() - Return number of currently running contexts.
- */
-int damon_nr_running_ctxs(void)
-{
-	int nr_ctxs;
-
-	mutex_lock(&damon_lock);
-	nr_ctxs = nr_running_ctxs;
-	mutex_unlock(&damon_lock);
-
-	return nr_ctxs;
-}
-
 /* Returns the size upper limit for each monitoring region */
 static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 {
-- 
2.52.0


