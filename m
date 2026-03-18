Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B7F0103E198
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFFB6B0278; Wed, 18 Mar 2026 11:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1446B027A; Wed, 18 Mar 2026 11:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C75E6B027B; Wed, 18 Mar 2026 11:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C09E6B0278
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:37:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE96913BAC6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:37:36 +0000 (UTC)
X-FDA: 84559588512.26.1E62BA2
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 08AC4180013
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:37:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MBTgv+Cu;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773848255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tflDPbUGjZZhe/6e51jUzBoNjciN30vErFCN5iuJYMw=;
	b=sbtGq9W7jdT7HUL7vxPSj1sKmlZsdRf17Cxnc7PAknMYFsILw+pmhFXHiwWOkamflm+pu6
	jvV7EsV7/iHL42A8yF0n0Ujf7IIIIGuI5kaftxeWQ+I1CBUVQR4I2N3yhYkvuGpxVhlBJE
	fijuzIydwTLBE0qYJeGbxfvb6a6KmQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773848255; a=rsa-sha256;
	cv=none;
	b=JxeKFm8GYCl83CZlkRNCmvsoVLvziy2O/F22CmzH+q7mTa3lWM7jPHyxnJL5WgRP9VdFFK
	gKacvBLvnA0U+NaHhxEgR//RM3qw9/6G5Etbv7ybtQ31WKWB4575jooorYSivCRSaWbWw0
	4YY81I+DhkswBMdpEAG+WuGtZTuJrCs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MBTgv+Cu;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ad4d639db3so34199095ad.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773848254; x=1774453054; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tflDPbUGjZZhe/6e51jUzBoNjciN30vErFCN5iuJYMw=;
        b=MBTgv+CuubrD8knQ9MZ9e5DIoZWgj2rTtvt7rVvhU5PXQ5LePKCLg5Rq+jsuGbRB1r
         hb4MnqYgoimHrem5XaV+2/elkt/Q3AAwy9t30g1aqGlnvEzegv4mDlRjtNrU4ZRJpzvy
         kKd1YOFrJAvaayQAPypkMqj7Uz0OAFkagEZJVA2c/UgZ0IeNw5U6IlhQqyyeUSEfL2o5
         CdcQo0XZX8yXsVRXWsPBi+p2pYjjzuM3aoiNQFysZty3aLIJHgi4Ym2sVaW22oreFMRi
         Ysw/nCOE38qLoqX35ekBolrzbWuMJ5991eBRjpjzOkb7ZtVm3S6ufH7s55UXab2gZdyR
         ONqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773848254; x=1774453054;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tflDPbUGjZZhe/6e51jUzBoNjciN30vErFCN5iuJYMw=;
        b=NWPmPc75IKwEQ7bK9LVlyRXD0dHmuV2716c8wOJVvUJaerxUStustPrFtte7RKLiDb
         x3th2rOR/4KRWZJvPCVWsdGPLoH+xHEQwKZk8tVbPkDf8RPAEctqUdVbS7Ng1HQQWoAP
         4SxLAS0Ken0hhFbMma/Vdj64ffa1jmOINwIE76+R2mogqBJyyPILW3bbtOA96af+Nudv
         SzIStB7bB89CTKzx2Tab81UnLt8RFwN55/wgaOSxnJuWJUaZCe7CGb3CAR3w0OnbKjkk
         x+t6XIn1GnE8wwdV0yaKziQmvF7mDPGtdc/eqjkUCs8w9KAW5vtlAx9m1MNVNR87V2ut
         cjWw==
X-Forwarded-Encrypted: i=1; AJvYcCUlt/ncmwOJ5nq0fiRN9PT73hhLibe4wLMqCsFqH2AYAjBrF7YksXDtluaSuY6q/D8FUxXFD38yBw==@kvack.org
X-Gm-Message-State: AOJu0YxqWKUt01FpIHRdPNi/S/FVoEDdeVD6X9pcGLS3pCANDJ0We8cS
	/k5PD6ZQt2tXajBcOXZHoyOnwMkBB89NJmI7mxvDy3mGUsvr+Jw7rH4t
X-Gm-Gg: ATEYQzz80La/tSMBRAeAuXCVfmgLcdhxecu5NxOadW957JXMax5qzvWu4Iqrll56rWM
	LuMD2uqFtsJUa+PLr+pE31dUENoFvYgHGuE71Hdr4rHuRs2lXU8ibrH+SAecrK4unpCNaOJXQDn
	hlbV2g0XD81y18nHFI5nn3UAvgfCnnrGDC3ATQomvKVhZgI9YzgcL3d5PvruCJDYRQfjHiT6zPQ
	B7qdjqHCxLOCWQtnM/zWL2We8GF0m8+4IqAJnnR/kEsD4593dssXC0+2K5zDmxiZo5MVwRAZ5ym
	uHSZoz+SojK1aUkDHxxRWTyWSeXQUu6xaeEMZfJaDK7yjoQ+346tAVx2/OLh41vUadhDLcpuybl
	4J5f0ZyUAt6b2wCyi4TwsbmJfAuqCA4mWaOTNjdFytYCqLMkBBMQBWxe9WSmlWy940TKA/P8Blw
	nZn8yq4yNDKo+cUAfJAv1zt5K6KtE=
X-Received: by 2002:a17:903:18b:b0:2ae:504c:ae8a with SMTP id d9443c01a7336-2b06e3262bamr37279345ad.16.1773848253777;
        Wed, 18 Mar 2026 08:37:33 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e60493asm30693865ad.59.2026.03.18.08.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 08:37:33 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [Question] mm/damon: min_nr_regions constraint and inconsistent error handling
Date: Wed, 18 Mar 2026 23:37:31 +0800
Message-ID: <20260318153731.97470-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 08AC4180013
X-Stat-Signature: qasuaozo4gw6q8sn3iymxxies7akzbez
X-Rspam-User: 
X-HE-Tag: 1773848254-532079
X-HE-Meta: U2FsdGVkX1/rz4r4bPGE/YpGV4RGkIwS3QLMQ9BvzxMHkt+8na8mfwfKUQeqyRGoB2fCIs56Cq+y7zF7h1MXXl71cKvcFNmtgTJi0arztloBAG01BgpqsQ6SMgTA9G/3/uDtH21sZux7kO3BgwrP4jFZeg2dQszGHpNBz6QdcLgWGfmgHbZgLNgKTFL2jyh+s+y1NmtwFy8N3JkpWYJqmWXg/fGs+6ZXd/tN6hoX23ITZYKx3vvJ2y/tAmRJ74joaG047UtlcUPU4uE1HA18zzuQNcVV4zZoMSlAyPsO88oaoqKEL2045lKquNkm1h0gyYFr74ZnjxpXw8f+72x3871vbgIXQCEgJtt7IOPzLdI6Yo207XGG27rYGL+ji2SNinpJtq22tichJ4xUGEkKlqtO7G5BzqRyuWxHf7U9e2YjBElxaNAEJx/Mz3C1TOQhh8QapaEEoCtQhet5/3yfij+EKtKT4+wwWNBtQY+1oaoxkml7/NrU/gz9ELYUrjyLA/4FBkNBzfhttx5nGHTLGLxdvSFAFAu4Y6PDqc8xgucc1dfhZhts63P+ZYLA0M+z9k3sQ4fzeS1tv6hiiy1gEaq3JEaDPhyaj1Xqz7hKAEwOco0Lx9++rE0GAdK2X4govsJvZgSRiiQwvL2+bW8zx8mcz3Rjyu6I0gUfjY7HPRkT29RrVlp6g+GoylEDPrUISxj6+GOuNGxK7j9cxfPWeNyYTxYuEYLm+GuFJIV1YIx/pYqhozJ05XM1hJdmbHm3hBNAfVNpi4/vSp0pRPlJ48eXjBFicg82pxX1aK81irqUJV3qBDBi7ASl65L5SUqlqec9+w3IPFXMn2Vh/1ypnRJu74UTi3lgjAsG1BDaXtSdK0lodF3eJBmbSRxywnsb9CVnbfCFhr758mAcLo/7NSNRYL1S+D2tmNILX+/5AhYshAt3ad9kfWk3Muz/b/kXA7QjA41vvUGAiQ9GVql
 5c67+jue
 sukH96+5dKl+zYOP1sXhjbIhYcIhft7EkCjn+7RsBnny+gNTFfUp1XRowzvHIr/z/MSir3DuqjQcNXB7hcdn2T61hSTvd5flUNPNQpmUB9HugJ+C9TmJmpZhTOIbT4FBwCP3EdeBqppYyMRlJLZYQaR56EOA4bzg94wCkqkbnhLqXehy9qSVoJ+Ya9p+lrDcqiYzWsY0r60wb07Vi0j4mQoWAJnIA8sF2zWW41avmH8uCyZl+dmz6Ez/HqJ02EK/s4YXLbGvnDK0WOlfqqS1SVb5p5G7qXjiGXaDvq5gRJWKcIY+oi9EI2HYB3anhcjwkuohkwNJaAu/U3vDt4g1BTGu03Ru+iMnrr9s1qpSwEz0EVW76zpqq0cTirEavx1yXTPuzTUzRLaHuYSvxd8+KgMg5A1kJzlWFZY/R0quRvNv2hOssy71cmAgnERR9AB8Ti5515QrmiJqWnUSiGCZ2IDjQXbamXFoebTSlzzZpe3Ce83yxn/r2+5/RIlrCDuQCVVg/t1XWTC92ysPF306xylChQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

TL;DR
=====
1. Why does DAMON require min_nr_regions >= 3? Is there a technical
   rationale?
2. Could we improve error reporting when sysfs parameter validation
   fails? Or document it?
3. [Bug?] DAMON_LRU_SORT doesn't disable itself when commit_inputs fails,
   contrary to documentation.

Details below. Happy to help with patches if helpful.

Details
=======

1. Error feedback for min_nr_regions validation
-----------------------------------------------

While configuring DAMON_LRU_SORT via sysfs, I noticed that setting
'min_nr_regions' to a value < 3 (e.g., 1) succeeds at write time, but
the error only appears later when writing 'Y' to the 'enabled' file,
which returns -EINVAL.

Since multiple parameters (intervals, watermarks, etc.) are often
configured together, a generic -EINVAL at enablement makes it difficult
to identify which specific parameter violated constraints.

Code reference: mm/damon/core.c:damon_set_attrs()

    if (attrs->min_nr_regions < 3)
        return -EINVAL;

Question:
1. What is the design rationale for requiring min_nr_regions >= 3? (eg.,
   algorithmic requirements, sampling accuracy, etc.)
2. Would it be acceptable to improve user feedback? For example:
   - Document this lower bound explicitly in
     Documentation/admin-guide/mm/damon/lru_sort.rst
   - Add pr_warn()/pr_debug() in damon_set_attrs() to log which
     parameter failed validation and why

I believe clearer errors or document would make DAMON tuning more
intuitive for sysadmins and developers.

---

2. Potential inconsistency in DAMON_LRU_SORT error handling
-----------------------------------------------------------

The documentation [1] states:
> "If invalid parameters are found while the re-reading, DAMON_LRU_SORT
 will be disabled."

However, testing on v7.0-rc4 shows that when commit_inputs fails (e.g.,
due to min_nr_regions < 3):
- The 'enabled' parameter remains 'Y'
- The kdamond thread continues running

This behavior may confuse users who expect the module to safely disable
itself upon configuration errors. Should commit_inputs failures trigger
an explicit disable (enabled=N)?

Reproduction steps:
-------------------
VM: virtme-ng 1.40 (x86_64)
Kernel: v7.0-rc4

    cd /sys/module/damon_lru_sort/parameters
    cat enabled 
    N

    # Initial setup - works fine
    echo 65535 > max_nr_regions 
    echo 3 > min_nr_regions 
    echo Y > enabled 
    cat kdamond_pid 
    91

    # Observed behavior:
    echo 1 > min_nr_regions 
    echo Y > commit_inputs 
    cat kdamond_pid 
    91
    cat enabled 
    Y

    # [kdamond.0] still alive
    ps aux | rg "kdamond"
    root        91  0.0  0.0      0     0 ?        I    22:03   0:00 [kdamond.0]

If this is confirmed as unintended behavior, I'd be glad to help
investigate and submit a fix.

---

Thanks for your time reviewing this!

Best regards,
Rui Yan

[1] https://docs.kernel.org/admin-guide/mm/damon/lru_sort.html

[...]

