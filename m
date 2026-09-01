Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA5D1C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E416B00AC; Tue,  1 Sep 2026 02:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36E86B00AD; Tue,  1 Sep 2026 02:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72E56B00AF; Tue,  1 Sep 2026 02:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B741A6B00AC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:59:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40AA4402DE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:59:05 +0000 (UTC)
X-FDA: 85164291450.12.FB3B84B
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 68B5340009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:59:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eD4FeJbj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788245943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agpKfLahOgIlbtuVqPJI+pV+aaacYEptBf9ONahRpL4=;
	b=q1CabpVkDMwLnW3oF8CWpUOHwAkch1t2btYu/jIURD9Acr2B6cKXG0KxzQlyZZFHCK3rqC
	lzvNkkWUUS1NguQfz5cT7jEeRhKXOVgj/UjlZ0F/Dr1v/GwjP9ZQrd2Ro9M9hBxHgfEJJX
	eN7pmW1tAENEVe66Kxyy242QzF0ZGx8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eD4FeJbj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788245943;
	b=tRTGYj+b68BV0BRZ6xsPa7EyDlvVro/HjTqsGVN0DvKZLlX2nPbdhYdq1tgPZ1r0uZLlaG
	slWOWAQ+YHNB2wrPNVbSLRxu9msHR1864PA2dhVGNQqxFxYTFILsZHeXMnd8vUH+zLiNkU
	PItE1FRTkG+MWFU5lxjqR42Oep+KTj4=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso3429554b3a.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788245942; x=1788850742; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=agpKfLahOgIlbtuVqPJI+pV+aaacYEptBf9ONahRpL4=;
        b=eD4FeJbjMKCoAEV2UhEj1ASTYQSKi7g0kj8mulZgOM3T4lzDfR+3FRTgEhFHWKgzfk
         77s2oRiAJPPs+y/G5Thq3XIRDxqjI7wjVdE7npcL15eTsPhOaHU2hHxemKJeDXROwxB+
         Xl7dEcDqF5hm6DDnFIf8j9DUonmFtlM2JIAuDiNVurFCmIAmdVbUh4g/lgR6so4/Ti6D
         kTXRqncosYIQHbTr1pB62ibjyerflT3VNCBizXQawCqocxl7hHIi8y0OctlQzkH/y/TM
         BBq3oSPSMRhgVg8ywFoFVBiAa4fABdgaarxnbSYy1JOpOJNU7m3X65uQYS+2MgRrFr4C
         Q1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788245942; x=1788850742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=agpKfLahOgIlbtuVqPJI+pV+aaacYEptBf9ONahRpL4=;
        b=KAupKm0Uv64j7aOhmDhgbmaT3uTfTk2Oya2YeIGtqljtw77eCsK3FGl7HBpnL9VKOF
         Rr97MEa0+umTD3OuTRwDfMQtGygcLYoB78gK60gZEopHJ/X7JDLcoQ1aB3PVBunH9gJY
         nbLqOJQ/B5oImnI5bNMSNEBOx/uFFba5MTxRMf2wmF2WMIkyAEbKsPfE21PkFEUYfk3b
         A8QVnkNA8wBtpIZvoTt2ruh4AJT6pc1+wqtVhzhg+q/zpIsBvx12d5VpJCkI3yfZjX56
         /LCypEPK6sJF3VL6RlL8ACyM3RF7gFb9sw3c7vertxLdtCtpdxRHCkHRqs6Uxmxd4f0F
         tRyQ==
X-Forwarded-Encrypted: i=1; AHgh+RqWQC7clQoYhdygJiHTs9ojaZGLLpRKcsKCMuZMjVgHlY7PKEJFvhGZsYjovZ/flpnzmtGboSnvhg==@kvack.org
X-Gm-Message-State: AFuF++kH7KQQeYpKA6pdl+jMl6TTCj+dT9MsfVa4etDjYaDlFumaZDk+
	JmoQ1fo2CqF6HXW0ivhvi5AXSrAsc8Bpi1Nkffm8RxI9rjZhz8UNSh8Un70O3xtJ
X-Gm-Gg: AR+sD13Dh5YCPEf5qyjQo8Tc2GuAtRLoaLENqMi5bJiZIeiRiFk6iqfKSopZBLMuUmY
	r6BXD+bam5Ys84gxaelbhWcKFb9hQKc4PEukBj1LVVPRBPtC8MPGVRh7t2//WflOVXhdRpzm+ND
	d+fSGqeFMKMSrbFN5l7wkWRz4jC61klmYDCM3w3lkYruPRaPKHJAybIH3qvZ2qm/yaITs5FVvxD
	lsmAChCRJb87mf5QcPOC+1gKF9vkwjB5BOyqeEZEnsnKL8V5pdOEbdedhQd1yC1H+hirJy+2+c1
	rfNdRX7Gu//5dig5/nfGqSEb7cpQ1hyHhVW3Xn0Le9pfvAvQbwLob7Pq9x0pvPRxNTmWzGtGfJq
	+kFLIOqZ8I+8VriQ/ZCL9onZrR4nx5MbC3K3KhxuNigFs5GAw56nJhW7+0rtIRuxNFApOzUwKhI
	Wwa2MzEEiMm+NmIPfkaoKqttyWzVZuBKXBGlFbd+A9hnPhV/hW7up1O3z6ilUAajGKq52IgxbNb
	vNArqhZUdzIoCxRPe6O+x02CsclhDEJjqKnBnQ=
X-Received: by 2002:a05:6a00:a01:b0:845:ce5f:c926 with SMTP id d2e1a72fcca58-85b59593e6dmr8525461b3a.1.1788245942189;
        Mon, 31 Aug 2026 23:59:02 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85be5ca747csm604072b3a.5.2026.08.31.23.58.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 23:59:01 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Tue,  1 Sep 2026 14:58:35 +0800
Message-ID: <20260901065847.42869-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831144732.80910-2-sj@kernel.org>
References: <20260831144732.80910-1-sj@kernel.org> <20260831144732.80910-2-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1hranzgcda5wk1jr9ms1wekurfshe5ga
X-Rspamd-Queue-Id: 68B5340009
X-HE-Tag: 1788245943-48951
X-HE-Meta: U2FsdGVkX1+vU770aEJtOtWtpyu+EtPiP+3qqM6sGdYbWEgh8oo8c800pfJCP+Nhin7txT1U+LZcUy0C8OUVgJ/TAcWzTiD6mGKrbR7YRDmcxCgWQDtSGcgyKbE2j76TM7TyW1gSdbxvBxgrWkdGHabyAUgJdW6owyomzMFld1Z44+gwFCGfGmnAIReLgHUN48nU2V1VXZpZd4DKQjdNFSBFRHSsdpz+R1hGKpSFNuVaYPpn+waL+behZqNI19pw6TcWxUc5xGEWkn0BVot7KRcrB8H6bdf1NwMES7pFrh83C17T5LclFCifIQbvMDYgW2I+aPkcA+u+USllnoeaxW16hoMkWf2/Rf9UI7CqSzUs4CY+jmTZpVzTlNpuq2ce2tYWJrCyeBGRmfB91Elrt/XPw7tEeEw6Xx25gjXYz6g5H8gN7WcUH4Fe/hYbxabzIx6Hvy0Q0e99vMHUfomP40dIV5ZkglPMmZylFxF2050LqceY1W8ScgzCHuej1FQRoPaP2eR97v8/pSKCMmukAVdoo7j6G/TDRfJflI/0h6RW1UigF9UOD/CTDvjHTsW3akObdRJi9oPrwB46gpKqLrlC4ZBPKjJ0czNVQ8smjQbg+g5wqfuFSRWH2hXb2SRdg3zzXj+nBqEKEevqL4MkCTfRdWliL7/nnBW++QeCJyrcZP6qmyYgQCvcE7sm54T+l/Es3Br7nLThyCLVrSAG0dkGeJsIGRTmTwoeIxAXmJq4t/0FvAuQx7wUq5iZDTEouY0+/vUUqyjo4qWEyVn016+Grc2WG3f0VgFSvj//ZP+3f6omEvN6VjyIbEpnZBHAi4CfhyMr3aDscdcD6U96Ntq2BUz3WvDSRZpXzNuoCTvXIQ5eZ5IYHDvH+HyvxpBEIDfRnW4Q7SUNPehms76zZJyHt7XCjyo0BRtStBdoeTA3Da6KvCmMC9SRV40meUUOM3HFU0bmGQkEUQF8TiG
 Z4w6sE0o
 7PrqUKD71b3WgR/YcGyCoLtWTZ5KMafHR+OB3G159bUHRzk+MZhoOlC7jS/UvEmeO48q841GAn4HTfnoItA+fKzlA77kb7v5UxHjJRRO2Biwy0SKKiMQexNZX8JxjHPvFAHRTM2x65zShgPfkKHHlBPij5dn1/Nt8UXbQP2TTovVTMvUpSQsatpzwsTOeAY02BoX9YU18EgGm0i690IKpYxFus50zqCe/x/kqoTdMVnDaAcZJRbmcIfTT7V/N6AkWH/s4palC9FAJx6h4EkKHH3Regzs99FYwm2kWCKttXZSuUbzSEwAb+1O1rnbbCsjMM6Cw0e9My7IDmwPE5XbuOEXjwN/78xVxV0sFobEMbmmyKNahmqcZxvnJOC9jmZLhWUeKnRoftgtri/XguH3QxZXUicGkCj05TeErS8A3hFaHhk20p9PqGDBBIPMbUr5rtuREewf26WD3TS4U+WIHiYyeD9lJffSZFyG1JK3Z+img1YxL8PCGTinFNXoDmtzE/0Fd9buofAo5q6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ and Asier,

Thanks for working on this and for providing the server results.  I have two
questions about what hugepage_mem_bp is intended to represent.

> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP auto tuning. Add a new DAMOS quota
> goal metric to measure the amount of huge page consumption to total
> memory consumption ratio.

First, NR_ANON_THPS tracks anonymous PMD mappings, while NR_SHMEM_THPS and
NR_FILE_THPS track PMD-mappable page-cache folios.  Therefore, splitting only
an anonymous PMD mapping can change hugepage_mem_bp without physically
splitting the folio.  Is the intended metric PMD-mapped memory or physical
large-folio memory?  Clarifying this and adding a mapping-only test may help.

Second, the metric is global while a DAMOS scheme can target one process.
THPs from other processes or NUMA nodes can satisfy the target or dilute the
monitored process's changes.  Is this intentional?  If so, documenting the
scope and testing a background THP workload may be useful.

The temporal results approach the 10% and 25% targets, while the consistent
results overshoot the 10% target to about 20% and 45%.  I would describe this
as control-response data.  TPS, latency, TLB, fragmentation and collapse CPU
data could further show the workload benefit and cost.

If I have misunderstood any of this, please feel free to ignore these
comments and correct me.

The enum, quota-goal wiring and sysfs exposure otherwise look consistent with
the existing DAMOS autotuning framework.  I consider the points above
follow-up questions about semantics and evaluation, rather than blockers for
this series.

For the series:

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Please feel free to Cc me on related follow-up patches.  I am happy to help
review the code.  Besides my own DAMON work, I have recently been reviewing
and learning from other DAMON and MM work, and I would be glad to continue.

Thanks,
Lian

Sent using hkml (https://github.com/sjp38/hackermail)

