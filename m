Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A3DFB5EA0
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 01:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188C46B0088; Mon, 16 Mar 2026 21:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139306B0089; Mon, 16 Mar 2026 21:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050496B008A; Mon, 16 Mar 2026 21:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E149C6B0088
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:48:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 515C18B89F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:48:22 +0000 (UTC)
X-FDA: 84553870044.14.3090884
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7DDD514000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:48:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZAbtazin;
	spf=pass (imf09.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773712100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gJgt6Rfcb20kFAH/VM/j13KrTjlMfdecp1AACkp2FcQ=;
	b=kwhpDs2pZ63ynF9j/lAkhn+YLBDIPygZiMVQg57B2KhJ51evclWiINoNj+D0ImbJEimv0L
	p0IjxGWRLjRwKMunIJ307173O7CXfeIuBH3gfGKw9gnA1/TjldSaoSCiichBI6h7x5d/z/
	sR9h+7D5vdzkXDe2MVydh3G/+5PaFP8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZAbtazin;
	spf=pass (imf09.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773712100; a=rsa-sha256;
	cv=none;
	b=4b1GMkFywCAwPouh/qldAaji8SFnhtM22PrlpXDX3FfDpUW+iau54o2akicU/RydXbumNi
	3V0l97dTOZWROjuhEKGk0wgBFKcI8szLzI84fvh0D/61dyIZv6upBbjSf6bwgnI6bqK1QN
	SDisxJtS5TCnkoQcosVIbzWPZ+cBcHI=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2bea8a1c040so3176781eec.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773712099; x=1774316899; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gJgt6Rfcb20kFAH/VM/j13KrTjlMfdecp1AACkp2FcQ=;
        b=ZAbtazinFFni3W9P86DhSPBAcKcf7zGmXXySNqK0zD3a+OEZFk5f4qiEuxvVvN338Z
         bBgjZawxObPxc6kEMQQEyTJB1CQt6DPxkA4CTqm2Y4Q8cEzJgMRF77skldyGKS1hoykb
         huE726wXWCkNzvjHkTavER/wSct/OywH0ozIFiWwh6p/1FHY4IqGNMqjvREp9x0G8pbH
         YHZWebH3ddmATPPGfVAOsecOYMpBicvKezYuXDoEIduSzVcG7eyk91j711lyS1VFUS8f
         n3jIt/SPxfz68GCReJFJsqncA6JDJXqk9YUmh2XQwrHPNiNz1igsZXUtVk5SsXjcKDcQ
         yVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773712099; x=1774316899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJgt6Rfcb20kFAH/VM/j13KrTjlMfdecp1AACkp2FcQ=;
        b=bEtnrYKQxb1gOAyy6bIKEnp6vYb1iD2ICdU8z7p2fwHYuMusjowlG7u/Djj8gLIdcE
         3qsrhaACGr9HPsqinMSwQw13zXSWtf9G5E05eYxg0ti6g7aELCm/GS/WTWrlT/o30h2n
         rwFIK1gEaZdIE2fpfVH5RzeuJQGAYiNc04mYWyHB82bc0un5q1NXZycKmQPdIOP26gQR
         qQV+cA5Eq/qD/WUAl7ohTX+QSp/2FwXZ2cErEBeOgtOQO39SgYUsFUw08Tr0gP0tbHzj
         +5uBDaA5r85GnRrW4IBif1TqBZNpxmOpmpwJFoOgHILz5pHq1E+b2NCdsTpBZCZtLQv2
         fIsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcyt8QuPRpNEJOq7bg8/xhgzoQd2CmuCdJxuA/N/6Qq91AVTSn2141kpNG8lcYsaEecMm1J+39eQ==@kvack.org
X-Gm-Message-State: AOJu0Yyg6kstVTSR6EKXeAQZ/s4BjlXUEVbEtAJ0FGygbZC+Aurlp9a/
	WcDRKGaDoJG9Mg0l0LhcJdnH5EYmh5tEa5wOJ3CYk9sBWkiOmSCoLq7uJIiA6xVbyMs=
X-Gm-Gg: ATEYQzy/8K739AsUM5jYriSyoLGbVtaRytgK2ovS44gtDVEhxpCPO2xW7hlI9Hv5A9r
	5ZG3FLeqIyIbRZSeEPr6E5VAQWF6RdmM4WMigpYJkUnQwu/Wm3lgntEmuqTEuRF2ctFgQLsJ8i/
	Ji++rwgnfbecdQHVkc9gxbr2zcdE4+X1WZgF07dCVMKqjfl8oV6ZYNxSc9HgXWO8JlJ0V5GAFVf
	Bm7cuB8yPkQyQJBFJd855jpnMASTkWA0KJIJ6tPbAXLY63ctFV5DcnH5oFF/iaESagMWh30Oa9G
	aQzKT9z+6Sx+lUFFgK7fCYb2pmjS8zY8IJSJgBsY6ctY0tx5f5FO2ybgc+OH28hAYGl5aAXxu8u
	8RqVeyn8t+XqzhcfuA6PYO2ujo93wt7gZi0ysB90de/hbrVaWRCHdQUaDEhY4VjnSik1FRH1gu2
	Tc4poY4bbYp3g1mxcjlEJr89MLOIMtuvRaPDuLRA==
X-Received: by 2002:a05:7300:6ca0:b0:2b7:b7e7:9025 with SMTP id 5a478bee46e88-2bea55032f8mr6673539eec.31.1773712099126;
        Mon, 16 Mar 2026 18:48:19 -0700 (PDT)
Received: from penguin.lxd ([2601:647:6400:3ec0:216:3eff:fecd:e4ef])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab3a12e2sm17931130eec.2.2026.03.16.18.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 18:48:18 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	kanchanapsridhar2026@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	senozhatsky@chromium.org
Subject: [PATCH v2 0/2] zswap pool per-CPU acomp_ctx simplifications
Date: Mon, 16 Mar 2026 18:48:00 -0700
Message-Id: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DDD514000A
X-Rspamd-Server: rspam07
X-Stat-Signature: cjqd5eubxw4kdtx3wkcwbcsqqc1nfaui
X-Rspam-User: 
X-HE-Tag: 1773712100-859065
X-HE-Meta: U2FsdGVkX1+DO5t2rl4nZrvYHWbdTM1NcCSL/5UEynWrlvwHo9K1aaXjL+xHvi7cueqO2+uVpnwJ09Vxy5Uu8Ty+HWScjQY09ZuyS6+ovO7fCMHq5YzX/XC3f9VBt8LFaV9DWcyARtIkPyZ4TddU7t/gFzx3ARD4NpkUb5yEcYpRMq6SSJmu+J+fWQ6we/IRwZ7NQr63oIj5q8hANd4omyRMmtyFi/VLFg1IeIKaUGvzlHz3A2uWA0rimY7Nj+tFPQoOjsDR5m3j6+dwQeuzC5SHiogxIraWy/jLhexFUY3XRR+g8Ln/PU+5wZ2/ghzxJL2kACL4jytHsnuirtTLaEg7i/G32NSbB98xq93iL17KRuAv0NpyGJj7yUvUMmpktvSlo2gQqfqX1cJDUhbj5AXUz8l7zKqPn9MJkhTaaw8Y+fnuGREoqS/rsDN8M9x6VPGoa66zoui72EJ2iLvM98JwzGLF/SoCpbvqwr6fN43kgsA4Xxt76AnmMBSWYVcXXC0K3Vtrm07u2u/O+JNzqNhu8wbd2LYLBi37J+Kgzd2OS/aM0URsOUb05kmqsf56zf/dn7UemwSzsPgcv7bl6Y6lgfigbpH4mV1ZYsJxYjjgmeHg/SRnPEHbZWbtdcJvq/Gt5twGgSvzKTlRt2DLrZKhV9JD2jvVccpXpt8j5RMCK6BxYkY6hCwL43XvryF/UTkbLvt2HlTVCyczZVvSzFanaIGk8A+Xn72Culv3DdgSMNt7ZDJzuvk6yqgOfXNiz2YFZ0IMv5SRmYRy6r+L5Myb0cH5JWJMc+spcFsOyAp86yuvcaJQjyohNOpagBL1/gsb9B3bsKEY/VKVz2Zu0HEdOs3RWyQPVw6Oi306cZeiOy4BH54cVf7JOLhbFl9bI2y/IhxPM01//cHx6kueG5EHmAWQ048EI+4nR3mJcb4M3uasVmTct96EPIvIFNsi1iy59IdWg7dyGf34ExX
 8GWlP3VB
 7A6V7B71WDws4DY6/Qa91YkwKAQFBK6vFUHlattv3AqR8XO0OqAxMYPAw0xzNddg1hWgTHISiw7oSf7U/UmHBQFVNQDf900iJMaiwe+NP7VseXw83SXcRLdCNdtM/IGeYkYFFQCgdmHMATnp8ZUQ/0ZIGDma3dIvyICd5wmLz3K9xkl+q5pXgZHXsghuV3YN8R6G7r35+3XvuYAOR5ru25lVGXzJN2hDCgGeiLTiKRXqogluCT7/jsNGYlOc49hnY17eIWdVODlv4Hb8nYhaDKtBKGwPnydHpZ66zvZLQuz4JQW0YJvujunSA3yPiNehonZgAlqOAhlycDDMijISpPKdjI+3HacLDwb/8oxew6tMH2qSkTnoOOjZlz65LZSrJuEBrpd8zpqdHZrv8+57sI0H6+VeVH4VaPOvKw6SYUvTJjQHbH4guqUcnetRpYBPIt98t7H1qtVymCuNObJ58FjPCJEWhtDGyWW5bpdia988HbTSVpR0CDNm9e+9qf0yTR1yn3/rdAixR74WHtJnKRH08IUKIlvAHXdPMzuC0xKWHZ8Da2bXWz62CimAa+tnK3w/JiNpFgC4ue+/PJ9fvfXibzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset first removes redundant checks on the acomp_ctx and its
"req" member in zswap_cpu_comp_dead().

Next, it persists the zswap pool's per-CPU acomp_ctx resources to
last until the pool is destroyed. It then simplifies the per-CPU
acomp_ctx mutex locking in zswap_compress()/zswap_decompress().

Code comments added after allocation and before checking to deallocate
the per-CPU acomp_ctx's members, based on expected crypto API return
values and zswap changes this patchset makes.

Patch 2 is an independent submission of patch 23 from [1], to
facilitate merging.

[1]: https://patchwork.kernel.org/project/linux-mm/list/?series=1046677

Changes since v1:
=================
1) Made the changes to eliminate redundant checks on
   acomp_ctx/acomp_ctx->req in zswap_cpu_comp_dead(), per Yosry.
2) Renamed acomp_ctx_dealloc() to acomp_ctx_free(), per Yosry.
3) Incorporated suggestions from Yosry and Sashiko to reset the
   acomp_ctx's members to NULL after freeing them, to prevent UAF and
   double free issues.
4) Replaced v1's patch 2 with v2's patch 1.


Kanchana P. Sridhar (2):
  mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
  mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.

 mm/zswap.c | 182 +++++++++++++++++++++++++----------------------------
 1 file changed, 85 insertions(+), 97 deletions(-)

-- 
2.39.5


