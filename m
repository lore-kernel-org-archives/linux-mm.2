Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CDC4F36BAB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 04:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EC06B008A; Fri, 10 Apr 2026 00:43:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835CA6B008C; Fri, 10 Apr 2026 00:43:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C0A6B0092; Fri, 10 Apr 2026 00:43:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 611836B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:43:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E285E2B8E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:43:20 +0000 (UTC)
X-FDA: 84641402160.28.F0196BE
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 43F67180003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:43:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RNjnqDu1;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775796198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBXWLvahdu/HVwF/Faib/MOJG0gD/Btl4TI2BjLmBLY=;
	b=kF3A7nnSZj1pbxyBJLL0+mgNWiLqbjKKqjMT5f6kU0cxtvmaxMBXU5sBgqUHVtCPmcbsUg
	rS/zhqnmOsDJuk+JWgbvinantG+J5lTuq74MwWO15t21clLdvirOsse9XT0rV3fPILWtuy
	xA3Acr1z9C1aM/Q7nWlwe/j1ezuxBIM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RNjnqDu1;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775796198; a=rsa-sha256;
	cv=none;
	b=GITbsxorhNa4FM0g864lXdrVsveJgHK2gxgWj97bvKRmulaYQ4GfIpVFJVsuaDP+Vz/0gK
	iKX3hh1rmqebWa32O0QwyimpV9j9bnKql+Ir0hMs+VHn80Ryyi0MTgyZKI79vNN0Xfaqb8
	VFBKrBZGUFpV4v3SvEhtX58FDp8HAww=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82a893d289bso815406b3a.0
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 21:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775796197; x=1776400997; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jBXWLvahdu/HVwF/Faib/MOJG0gD/Btl4TI2BjLmBLY=;
        b=RNjnqDu1Xm0rv0DiBiHfv5+48bZbfQdMbeRaMF3cT5GVnJlE2uAohuShJVXpAtIbO2
         bXd4Kp+25RJ0NWLGwgEwosKJ4uQzloeo+oZr7+t6sckmENiGW4HEFOtzEdyyzuK/TThV
         l1NSXCKZHpa12vdAKGAwF2ouPZyRhFhykPNbc4/kQfbN0k6ezSsaBdBXHJMIxfaZ++ds
         c2CrSCQbmrlDh4D4/rgZuAA4+q6fRH+NJLNqxTH8Bggy/OExBMl7adsXS8wZ3LkxW0XA
         6nX+FGdveMcPfjLmuO7qTBLnl6tDyOyi0WwnvkSL1ROsVhwX62P3U7VvCgJXjVGxARy0
         S2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775796197; x=1776400997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jBXWLvahdu/HVwF/Faib/MOJG0gD/Btl4TI2BjLmBLY=;
        b=TkFRJ79JGzF31rV6+0wdIvb+UfyiiyD+/cPdJWKm6Raa1AQv12Cgjnl9RIdcML0fdM
         mfSNBTPcDhdomNs7MW1YafnUPvq4GdcOZ4U9m91Q7+O9QsjMCumPvYlGSgMTPojywbTo
         LlUgppCkx2TFUsfo6hesu3SCZtZDkiYdm6PzZwAhrWpLnflXe/miNu37ZvVq7cR34uhh
         Qf4f32udFPJAx91oMkSOnTIy9eSlSHepysR1j6SPtU+1RjIXJO6sHI3roTSEEAEd+z9G
         GSBtGilyE71ohqFl3GmgGJbwEnTvt5X0pG7oGJLXmCuoAA4NQUUKg4AVp3pue2xC5JDg
         BhVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKQxYofm0l9QlzjseHN051t2Loo7yMLHUrN9I1jZlNcWPCSVbOgPur+tyXQYkyo278NiM+HFtgmA==@kvack.org
X-Gm-Message-State: AOJu0Yyv/WrjSITfhVBOVFnikcHHpjSSW9Okoanko/QcBBK97zwy2Y0a
	NLFn9BrLq/hA1LnLVLOcS/2L4KZnTtjgFljGOoOe0POAjizyFZee6L0N
X-Gm-Gg: AeBDiesBioJ4MmJnyCpuVS6Tx/u35lLBEU8DNOKaXJvXHg1TAffiTKBV50YGE35Rw4g
	uS0TUCs7UjD0c2S2FHa734I7mjknHWKrrvoAaRaHxOe/pMPFrHIYygu81IlvaK1y6ptTzAgsCcK
	naD1ddf7S9B4qd7p17nKsGB5NUQo+MWe6lJMrn1sjsG3uU2sFzbVjHIJ2V7hQtxvQoub6+1bKvw
	VuNfOIUfYm+lduPbosnkPf7jMuYIQWP+4vQ9njDYE5NTc/zzPxjcQYE49dXskUZdHFKw53be+Mg
	deJ5Ng2ShB4F/fSbI90Yq1OhwK0Nsa5oMncBSFiR6NVctPqZB/R0pICBLePgnupNeaEK6Nw3zhK
	v0b+HaQCKc9FhZfOEYQcvqjifsP+AeKAcbi2+9f0rHUqXqZc/eo2d8pQqFdgbJ8PQbygDcE8Xt5
	5urREte1mzSR7PJizfllRlEBQQWrU=
X-Received: by 2002:a05:6a00:b908:b0:82c:6da7:2d3d with SMTP id d2e1a72fcca58-82f0c250a31mr2001305b3a.11.1775796196784;
        Thu, 09 Apr 2026 21:43:16 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c30e7besm1200109b3a.5.2026.04.09.21.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 21:43:16 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 12:42:58 +0800
Message-ID: <20260410044259.95877-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410044259.95877-1-aethernet65535@gmail.com>
References: <20260410044259.95877-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43F67180003
X-Stat-Signature: p3154zckwoxrtqjsigj8aem6m9r3xhce
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775796198-126913
X-HE-Meta: U2FsdGVkX19SadPJintE4AXwGkmtrcfLxyjq9iEP/QijZFUyY6luJa+sLbr4johv7/VEghjsKwmLBQ7/FMcmrwmnsDkXb26Jp+n9JN4QmZvaVgTqjH4twRW2ZBD4qPw4SfKWd4STfbh/HmyaZcw6b0RGkVZziTCPqpUVtF5kP0MODGPuWf2watdKjTsC5G48sakngCa0r4DZXAu1wIE13p0q0MHCyfko6sXu4ymiS5NItJsRDXu80sPcdgutxlvJRHOkmG/GYlAkp4pIZo307LDGFxRN1Lz9nCxLQYp7eBclgzLefAXB0eOpOZQf+gTWkQasLlMrzk26vKQInatRCiFo8ct5Gtwaqf/wnuHimPfyYyClLAq7DLd8ii2J91jFsHqkJpnjs22v6uKMoHgGdTGxxxm0cD51MmuILxu6SW2rfojhawX3qniKrcRxyH7/yrr9V3TuomZ7WNp1I2wuDqfmPqoXan/WzT8tWjIf1dhJ5A7h7KeDfZq1pOtONmCv9n7zoNIkiZbKWa4/Tej95VkyQ4Pfp4y9rMOIYngGni0Fn5A3nQKTyN6IiJ8L8zOPB1fQGniPCJ/fwXRYDiYoT2DMbouo0N+MGc3m2vqet2I062JABOuHZrw7q3FtYoI4yBfqYePi3onNlyORG5Vw4s2T9txIcRfTeS/zktTlR/+n+HDPy0tp79P/y78EljJrhL6AFdmqfQGUBkGO/S52WUTEmU/hJPEJrYqGg8NZ8Eshz2T4YQl2tWlZeG3swCUJWO8dsQBbVedsht8cUMF9Br0svedAdDpZtvUa3lC33c1Lyjxz5ttFmEGWbgmqV66qcjFRWavnS9x3VVTIslyFdKcmdc9wTZ4y5o5+ceNzHJb3HW56L1fM/QhyYuWO//q+S0IJ/i4vKnvYP/PMFhy5vU14D5XW1V6ThjWM4yeQty9NTOFCxwLHMoon9sAOhcZilX0bwSyLsSqzOoTC9B8
 kg+z7AGW
 1clljWfJHMuF3HA/OcTFTN+ErfI0UAu3Xo0/mBiXVA5IuNgGphN1KFQAlt8EXxEXEClv2uwVyhCdMQNsH5ExjEJH3tIiEm3u5ptYayov/G8c7AfZ6KpFmEWIM70ukRllv2yljf2Ax5tEDvSUNBqYj7U2huHKDIi5PZlg+d/wkJP7hDY1sC8Saa1vR7E1T6L3o7lyNJ/0FAmconDILffSX/9vzX03ueKWpel/m4TNxxpn69a+NJL2e55NxfZbj6YsVm3ak534/0ErEm3lyMzqi/5MmdFCtVxKjwqLdF73ARYpDXQaq5b3OaBRwVRy9ALnv00HX3SZtD88VQOvNIUenmfxvNYKB9limdCvA2Hqwcn2SROvkpIM1qN9JwobxCKYPVGDk2Fdt355JrN0quCAiWo1QjSrwqxktsaH7Uiirjyp+ZgLy/uq+buscAM9Bdx2xsF/9/7Nuj43dCdkII6vT6UiJyrxwi06L1J2ZGnL3pyGfecU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
When a user sets an invalid 'addr_unit' (e.g., 3) via
DAMON_LRU_SORT, 'min_region_sz' becomes a non-power-of-2
value. This value eventually reaches damon_commit_ctx(), which does:

    dst->maybe_corrupted = true;
    if (!is_power_of_2(src->min_region_sz))
        return -EINVAL;

Although -EINVAL is returned, 'maybe_corrupted' is already set. The
running kdamond observers this flag and terminates unexpectedly.

"Unexpected termination" here means the kdamond exits without any user
request (e.g., not by writing 'N' to 'enabled').

User Impact
===========
Once kdamond terminates this way, it cannot be restarted via sysfs
because:

1. DAMON_LRU_SORT is built into the kernel, so it cannot be unloaded and
   reloaded at runtime.
2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
   Writing 'Y' does nothing, as 'enabled' is already Y.

Reproduction
============
1. Enable DAMON_LRU_SORT
2. Set addr_unit=3
3. Commit inputs via 'commit_inputs'
4. Observe kdamond termination

Solution
========
Add an early validation in damon_lru_sort_apply_parameters() to check
'min_region_sz' before any state change occurs. If it is non-power-of-2,
return -EINVAL immediately, preventing 'maybe_corrupted' from being set.

Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/lru_sort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..3fd176ef9d9c 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -294,6 +294,11 @@ static int damon_lru_sort_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0


