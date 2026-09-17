Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEEBC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 00:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48ED76B008C; Wed, 16 Sep 2026 20:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F1C6B0092; Wed, 16 Sep 2026 20:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365B86B0093; Wed, 16 Sep 2026 20:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02C626B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:36:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B97D1201BD
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:36:06 +0000 (UTC)
X-FDA: 85221387132.30.A64AD83
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4C361120006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:36:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UJNvaE0Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UJNvaE0Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789605364;
	b=6vGqeSZHrbFFe1NtfyoJhHa63ZuUiwijF7ugV7uUx2pILnypRHlqcp0/VTM4LKTBwe6P9z
	Tzde8vYVi08rmvczLFGoba/DaLrY9Ij5xtnZeb5QYBduk6piobbJ3729FmbuBNXK9oJllO
	/UCrj1mFnlDH4d4fY5pHYDg5P28rUxQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789605364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SZOEiF1GstbodCCQqhjQU6Va5Mh92J9eROCVHW7eeM=;
	b=wO4uCYlOWNqA6u6OTufAvg9Gf26bdj6Yyiqnc+fxg7bTFV5Okh2DMhsXVPpVedyTHBv3K0
	M2guvsOhM2+KD6GPM0adT2lqcfT8tJCTRNAmHtDkIHGNbP3Mo1c91SyT9zulluSZowEqIZ
	0AUbboJed2hMTDMpFxILh1GzzMOCnI4=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so230118a91.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789605363; x=1790210163; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+SZOEiF1GstbodCCQqhjQU6Va5Mh92J9eROCVHW7eeM=;
        b=UJNvaE0ZTp1GTKIFrEBxUaHjV1RQ2GhavLi+uQkvYFZ8iMzfr77vpDHJtUUJMwt1TK
         5d2O3/gcoPa1HM80NKGOLX2UCX0V47tMLh/McfYNN9Jhbs7t8Mq9HNX3vRpP52xxtTjO
         U1RkudhX9AT/ua1yURhC4pYYkOlpSGcABajwae1Xakvs+GS6RT8itfEtZiqqmpRW0mwU
         WW7DzxRi+Iol8Mu7wnlpz09d+bCzK93Cbsz+d7IveBhTRwlIzqGnwn/h0WMq3T97e7mO
         XAdBEe/3JV1eF/7GVDZ8Pe84Q/mkYhBrwKw4PIDq/JU+IC7nfzlnh5ckPO9s7gl/lN2R
         nZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789605363; x=1790210163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+SZOEiF1GstbodCCQqhjQU6Va5Mh92J9eROCVHW7eeM=;
        b=kj5MXSiuRFz32bwEiEo7C5Elg08uMhy/AOp3q6AjZVB5UH1u2uBYB6SAtre2qR2zg+
         VSffL3l20PFPGWKOYYerWTBEY29FW7a5Ar/lNvLJAgXcy0ldoAfiyyHvS8K+QXY39dS2
         alvze6BzWV70IkGapb/wFu6YKGA7aiKDJ4JCxqfCysTENKq8NJZW6LTfkSpXxVqKSYNJ
         3qS9P1K3FEn9zK8oGJZaFNTIEjU/OkVHAbGPrihrM8090sUxZneZPWhvBrMC/eh5fVjj
         y1BxeMP/0tWb3AbtE2Sen5Rv6BWjRtR/KDODT9rUZnSjSIf0wx0gxKZdqqJ25gnT7u40
         NSnA==
X-Forwarded-Encrypted: i=1; AKwUvBwQc/4ESglJbqo/8DpOpmZu7gdXhoxZnseC32R1kP321El+njqLUruNhA0RzEjMAOjyEPD9BEEGZQ==@kvack.org
X-Gm-Message-State: AFuF++mccj04mmQQW3uMHtx+/v2FAKRJQGyaKDT5R9+BGvJ+fWSpcobc
	WhJcyJHEAuBbod02hDK7IsrfsaC2GLCER71xfp8wIvRMsoWb+0nmGA6OyzWcKWD2sg==
X-Gm-Gg: AYBFou0fwdD3IcOVAiD6gjFPdF7rMQPc6ONxPdMKIZFrBsKauGBPTVrakIr3IkjAAVI
	mWfObJuio8ovvTVq3YcjXrQniU5yjMT1I7eYzBYQpIYdXwmoYvIkwJ+OLoNBEqCsbDdzBf2DMyN
	EWaDFpXtasYrFItj9C3IcZngSENcARmPslpv+i1t3qhsMcI5pl+gjtu+QBNVuHhdi4H/N3MOiP5
	NsnPAfOvPGPH7c7rpk+WUweha/lQdfDnQCFAxGXxcjixAWsWd7ddjPmwOrFToR8damgxUbbZipE
	R4OyzRzrnohsryWHHFIJXg3hbY8r6vTCWMeJVJiCYzWzkfWvFOn2bM4Qbh+VeweVArJR27j8H8V
	wslnebOKfus/NKPnQexV+3c2O4+ZJbtfVeVnCOJ+tdNuY5o8nUiM4eWhLWTG9Zas7q9n2Nk+73x
	Fr9DryM1zLQodSuC+rdI85nWYlS3WkztUyKFijGZlgIkTZC5EUtpTV0FOLqLjoJGtsmFeRpVoGg
	DyZPHL4r26P3rNWMocMV61eDcM=
X-Received: by 2002:a17:90b:2585:b0:39d:f351:8f0c with SMTP id 98e67ed59e1d1-39e1e48b580mr10065782a91.13.1789605363080;
        Wed, 16 Sep 2026 17:36:03 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:3990:d106:a51f:be7c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e36115cc8sm1722374a91.3.2026.09.16.17.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 17:36:02 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v1 1/2] mm/damon/core: charge only the part of a region the filter left
Date: Thu, 17 Sep 2026 09:35:52 +0900
Message-ID: <20260917003553.2465523-2-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917003553.2465523-1-donggeunyoo.kernel@gmail.com>
References: <20260917003553.2465523-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C361120006
X-Stat-Signature: 7me81488rdjsakgewf5rzzpesqeopdix
X-Rspamd-Server: rspam01
X-HE-Tag: 1789605364-352810
X-HE-Meta: U2FsdGVkX1/G30zOo46N2dY6c5lzxmj+jA+uxThn+e13CPkrgnRQFoLeK5msD28ZOsnbPXqZNmAMGnpga5nWVSv+LdtazrXCGdNBzOOZaXvQ2ZQ3RnaAHKk6iIbBOOp2KSATHpvN1DgEtkWoMfTENxpRoQ93g/+nasqe0tPpud5y+B0BxwN/b1AUvEuX0oa/e+FAg9AVhAwKvbJVkqRytnhtggc1tL986kko9gqY6E+iV1PU8UgTnW/0Zf8qEeOtEpLYQXse103VkdRTRuU8Qh/2/uZFJw5DmzwuF+ONjd8qjSIlILCpbVEj7bMiAcaPOP48FM3l99TVoYLd8B9H/y2CWCQ4iXEObQRfLVH3xm/6hJVpil7uta9zuGw0mTVuRwoLr6IMZmlZU+JUcLIsX8GqRnpw/Ev9UEZ41Yvh5M8oAyWM6Rg+LPkjGmgVhuzffG5YOKTXgBq4thtVBqD9FrEiCn8v5Ry/FOeXNS1LTLRPg6wTn0JtgBNNzcehwpT1GtHDxvojbq7pKZEE36SyRvCQuoluK/tJhHgjx/S0d12RMLuoFQrpW2fa3EKMPXi+LEvH5ryaBbmMlnIa2fdWD6RvIQHtVsO8UcU1uuqfpMb0nGbsm4/FZ0BtC0QMsFp6zIjf4bqpIr6PQ2Su77ywa84vYdN2chlr3b1M/XGoahGSvtlwNPaq4ttLhZnnLhKK2Rw4c9yY3ggqIGM8ObdZ/8afBKmychRo9dPIgoxXsN9cLLf6MFYlDN+PJEzObeiV8CG/GFw3+tzCJD9Zcoj923R43o2fTIngc89hKdVJCppXcXpGE6koYHCBgiQG/EIus/LymA6ujzRfMd9bAYyCNhZ2qiTzkkxNqPIMEvyrRqomIsLvfItFWK+S8bDYO85yM3Nn5lfP3ev9HG9lLbVs/ZJz+wfi4Pn405KUebs/e/yVtamwBB2iWdV66hdrd8HLPYRzwKAfI5X5P6yMwky
 6yiQqmlD
 bBXGreZ0Qqwp8EryvcYr7h+WVAm2UjsDtLqu7eCDbs9CmVxTv+nh1NRmGsNtyhhxbwajyRMp8CgHA1IHfp4sgJztFdMgbx2vhKhncFGr91mJNg2Pnf6PjpYnPFWEwCCG4/kGq/FwRbblPQa1Zg91WNu2Jp5uWcRuEPs6bZmozMDy2/bHTHwMIB4bzTxxKwqpXGnVztVPMxGMuoj8hir3ExbXyFHLouCr0Y4FrSQwiJz8jOwsf5NvlV1xQoQTNLVcWh2pzmATGI3gmE+l8Sp+RAY3qntBwHHh+e6bxX0+X/H509Q3mS7eDtXmmSeRi/UwD2Znc7NboypNXH0BQAMNH78DCqZAb+QhBhakcIEpNy9HdzCiU0AT3Sn0ehmuqlh/Cdfavj8DbR1H/lsuNiffWR4LXvslIUObZPGBHJVu7nGntIyVnyf9g9pt+IDHG3dlJKLdAhZIYGAnDh7OV1wkSGdYD2v1uCBJ6M1EDc4ej/7CWIsBcEsHxZ2lZDgALzbj3YNSz1J+nLUk0g8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An address range DAMOS filter that partially overlaps a monitoring
region splits the region at the filter boundary, so the scheme action is
applied to only one side of it.  damos_apply_scheme() reads the region
size once on entry, before damos_core_filter_out() performs that split.

The quota charge and the statistics update therefore account for the
region as it was before the trim.  schemes/<S>/stats/sz_tried counts
memory the filter excluded, which Documentation/mm/damon/design.rst says
is not counted as tried, and with quotas/bytes set the excluded part is
charged against the budget, throttling the scheme to a fraction of what
was configured.

Re-read the region size after the core filters have run.

Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
KUnit, mm/damon/tests, x86_64, with patch 2 applied to both trees:

  without patch 1  36/38  damos_test_apply_scheme_filtered_sz and
                          damos_test_apply_scheme_filter_sz_unchanged fail
  with patch 1     38/38

  Expected s->stat.sz_tried == 2 * min_sz, but
      s->stat.sz_tried == 16384 (0x4000)
      2 * min_sz == 8192 (0x2000)

All 15 DAMON selftests pass with the series applied, in a QEMU guest booted
with slab_nomerge and CONFIG_DEBUG_INFO, the latter so drgn could run two of
them.  sysfs_update_schemes_tried_regions_wss_estimation.py and
damos_quota.py are timing sensitive and have each failed intermittently on
both patched and unpatched trees over 15 runs.

One path is not covered by patch 2: the quota split failing at
damon_split_region_at().  A KUnit case cannot make that allocation fail.  The
sibling exit, a quota remainder below one region, is covered and reaches the
same update_stat label.

 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dd4317df42ff..68f1749ded43 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2784,6 +2784,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		}
 		if (damos_core_filter_out(c, t, r, s))
 			return;
+		sz = damon_sz_region(r);
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r, nr_accesses,
 				damon_nr_regions(t), do_trace);
-- 
2.53.0


