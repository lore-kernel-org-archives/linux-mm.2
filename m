Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75982FF60F4
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8EA16B008C; Tue, 31 Mar 2026 14:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65CC6B0095; Tue, 31 Mar 2026 14:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2F16B0096; Tue, 31 Mar 2026 14:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC46F6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:34:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77B511B7728
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:34:08 +0000 (UTC)
X-FDA: 84607207776.16.D8EEDBF
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id AEAAD12000C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:34:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D3+H70NV;
	spf=pass (imf29.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D3+H70NV;
	spf=pass (imf29.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774982046; a=rsa-sha256;
	cv=none;
	b=cI1Y/N7JdqiNKewLawkgWkUBluIgnXJjChtXZHi2fi3oIJiZFgEDdsv7O6pfky2eMqGfD4
	OKuLKI3LuBKcuFgK0uqLy9AFJ3ArqPHQpxVfhoQwYEDUEvo1g0nX8xUclrp7sEuz5/FghL
	H3LAf/f30NlB1tCQLNb0BR4InE+6Kq4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774982046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pi+/aLk98y1Fjh0c3aLsh+cUIgd41dFwurTnFFIPGd4=;
	b=IkK/s7CdOPz6uZSOUhxU02PxEkT6Ed6V9R3Q4dZuESkdTrzfNPIPeNtYCj6w4mKNz7W+0o
	L+vptlyv+RN2dUgfRsGw/9xE+rW5rrP+4VKHVuqi1cQBDrhkvhmotDgql8VumAqLUKJ+S7
	W3CGQg1aj1khjYTFCkGyzpWyYyFGzWY=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12a74039dc6so4855409c88.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774982045; x=1775586845; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pi+/aLk98y1Fjh0c3aLsh+cUIgd41dFwurTnFFIPGd4=;
        b=D3+H70NVbelhTACa+XvzzJHFeETiPFrGjhu2FukxStxXCzYRFfxjquyhmycQ5nMm0E
         7fMzJZB+Qmd7jxqViQ5PQwDQaR/xs/zgD8wXcUjAnJZnHqjZVwAQiJhyBN6ahGsjEY2k
         2J8SVNy/9hBBhmDAvMxtOsdEORrolZwpiVUsZ4azsOfBbffs8c/oOwFlDwz5xYcWF1xW
         KbNNd06S2pNqyIcCcdfaw/vTj8PIf4j5SzTRzcxzUa0VNKaM8EzIAhDqY2gVn8NYRzEG
         SVBTmhSZxWI8JC9zRXglC2NJ1Xy6aqgyFSfjJ+YFT4kFYOaLAkR1NJS5CkDbFmUY9tSx
         clRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774982045; x=1775586845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pi+/aLk98y1Fjh0c3aLsh+cUIgd41dFwurTnFFIPGd4=;
        b=Dc18YmVEIViOECBOnstkX2P7/4ALbOa8ZGr3A4DzbrCdtvaafY6vxsyxXVOzy52A60
         NVua2yokmi//ZZiyIhg+QUTmZ+BJf1zh+82f3HPn2zfkeJdoVh3OM730VAbpWf2gA3VF
         rWM/w6FXBTddwPx8PDIBabVozBeV8Y6YKqLXEkl8Dl6OuDQ57PEUEU+tXQbJuRUSDiEs
         2OjzlbBxk9Rm2AKSo4/UdJ2Ppn8qH5FOaog2BR9t5VOgPd7GK2cDPWNR3+rzcZF15St9
         wwoKaC+6T0WrkHfimK8nmprQA/q/6wGWOSnyEOw1nlr3P9YQkdd4XyeStDVqB1wET0mD
         fx+g==
X-Forwarded-Encrypted: i=1; AJvYcCXCbK+eR3UiLfnWolfPiHonIxoIyn5u8I3lN05prQwNkjc+aoJmaQtg0z+VZXL+EHXs6Z8SBOgCbw==@kvack.org
X-Gm-Message-State: AOJu0YxH4KurVy4PK7ijaFxGselFpZ7mNa3DEh1V6MMygFvIdk3Yq7C0
	ZXs+h5u6VQMslyDWcG5HF+qMeiDJy1agXka++BTg70WSAqtKHkJ0t2pv
X-Gm-Gg: ATEYQzxRcTFk3oe7AhEtPyQwPSiHqgae5PxZCLAMRL2IhOT403PGMksWXe2l3DsxVya
	7ERJxhIJMN18f9oZ4/EYnAn7s8vvym/HaDHNFr7XcqPlNue4SfFhDAtzt0r3Z3OBaEcE22On39X
	8OJ4WY2oO1TQxkwVdb6ABNbfjV/1uqcxxK3eUv+C4N1EVxWUdbFDcwUKc+QAbhp92JhHM9NyQsJ
	ZDCcPmszqvod9W+FHisEZjpwCxyey1s00FBxwVFKMHjTLbgHYxiP26DxEF4bivXoYsJvwVhLe71
	vk8D4lRu4P8yUsp2+gjAdiN9fQHpQ/aoxEtPspY45pOnDQgGA9dqaDvsnHHIE/GNZTWc4jo+85Z
	U5v82tI6VZrgAmayP6ZWvP8p+qA+t7LFsOQv5aK4dElYVRv8nn7SA3kWm1zaNyv0QkOyF/VbDXX
	jr2mBMPeC/u44Ew6Dl5H60S3piAaMi3fpKf5Xi3w==
X-Received: by 2002:a05:7022:11c:b0:128:d39a:b141 with SMTP id a92af1059eb24-12be655e029mr334634c88.17.1774982045167;
        Tue, 31 Mar 2026 11:34:05 -0700 (PDT)
Received: from penguin.lxd ([2601:647:6400:3ec0:216:3eff:fecd:e4ef])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ac4a0fa8dsm7961271c88.15.2026.03.31.11.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 11:34:04 -0700 (PDT)
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
Subject: [PATCH v3 0/2] zswap pool per-CPU acomp_ctx simplifications
Date: Tue, 31 Mar 2026 11:33:49 -0700
Message-Id: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AEAAD12000C
X-Stat-Signature: hufo5rstpu1w6pdujbs7gtzw4c9yuz61
X-Rspam-User: 
X-HE-Tag: 1774982046-440294
X-HE-Meta: U2FsdGVkX19XoyNC7G8g9Td9GX4854YBN98zHvFtJMBsBUgrQmhHyLMSyjJQFOrTQGBLLOuyM7FzQNnxIl4Q+qcoPn4+tkuY4V68O9hJFjWPWP2bsxGqwHPeRxMbmbMxE1r5kfeCkUL7uq7BqKhmaLdF+Zig5FVyZqjxS7symaOvS5xuuq0xQMqs5pilHvNwXe3kkfTYoeCzGKIaCO973uwu/iYF7t9scuDUgEuIVJkDuiL0DnRfQWgvh1EuiyiTt7ZFusXteUWVptuu5e0b+XYh1fwAbknTZDC1kw1kTNf3DKHEcKYNJHae/DvIUpgmN+N23/rwJ0w8pN2Y3JG4q68bpvpxevkMZYnWOB9AlqYIwLxIFCQ5rC+Fsh0Jh4z9w86X4ZNf9vtecJ0ZcEo9K67+yrEouQ60XvBlo6HdWjwKS8Jcq7nlUygm4j95jTPIBazT4L7eqfKg/H5SOOr7vdmvQQsIQm+4vf4rcYkDU1aAXNbFaDybNrO9JRp1I+EkBfFuisT/8e5H8RUYDQnZu+RXl8liaPgz4tBBELOSOmxBtGY6raYIpPQ3MHEjK8w2aJRMwD/xhSn9XDUhScGXrgWDLt4BzSJvbk9y1WEXcHcXJRhRkeTKT3BBg6hNeNDDGZxRZgJ8OmODuLagPR+m6QQ+pWEdzDmy+2HYtOPdzPuoNaifQoHkWRuTbTIMCg0Qzt68cq4G9jE7T4CWG7upzCBTIsBnzp5m+aLy252l4tFiYBtksugwptlAnyMXXa8jj5l9qfYCXfqRC0CnoX3cioFIHKC3RMO0snwhWeVmRdtiCQKSHE1i6mtY/NX7d/HXfqx9wDaRyPU0aOXaS3xjD+TrrQIIaspUNO1o505yPThv2ABz2/GYaqqPqEzi+2uOvbhh8Z/U77vflNs0JPpSLVbi9Ws6XN95D+Kp3oE/0xYftfMtvI4sCG7ZzXkUHMOIxt7kRXIa/tqVr/ZPmC0
 N4WXd2b3
 ptw2xNunIxMrrrQ0NPWH6gG3wr8pyxWAD9gOP65k00m8ju3KHrSnRHV0sPLzAUu3lbFQ3x+UF7loOZlzidYjL1OoN5CK1v3D+qBBWphFWk3lXAbp10P5f+ZfZK1Aq6vt6tw40862oSfnvzFeRFR3plBogVD83A2qK2KPlPOCN9GAU6cAYXcgIk5TDzWl2WVo84jdwOTYrxMBxzR+G+ZWkWLnpvNUPB8pGLzRZGh+1TJREoEUixU45BPNOTf0DOTTzcn1jWv92gmNcsspSuo+X7De/NufRUoTUtppG4hoiGHWF1qBVJe3ASaEn8Obah+ldLgiVgRiw75UMLbwUx4CLzQB8spemrWn31grXU1hUX1JZYwAUkgpmaHu6QDnvaACLUyFtiUwiXX71D2JTG/PUd04pECjGIY01Em/IHHgzVu1yvqQ12Rf2Y9HM+FjROdjSHR/MgZ6vUEfVX/IQ6NvXiXwj4sksV+kYGcUn+8qFBxqh2HjIMuyf9bMPcA==
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

Changes since v2:
=================
1) Rebased to mm-unstable as of 3-31-2026 (commit 24e341657c28).
2) Collected Acks.

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


