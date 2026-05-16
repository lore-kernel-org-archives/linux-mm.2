Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77597CD4F3D
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 21:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9DE6B0093; Sat, 16 May 2026 17:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F326B0096; Sat, 16 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36086B0098; Sat, 16 May 2026 17:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D1A946B0093
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:04:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F2A61C0325
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:15 +0000 (UTC)
X-FDA: 84774510870.02.8FF0106
Received: from mail-yw1-f194.google.com (mail-yw1-f194.google.com [209.85.128.194])
	by imf13.hostedemail.com (Postfix) with ESMTP id 96E3D2000A
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zqgv2zi6;
	spf=pass (imf13.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778965453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGoieryUDtogh5w/DQ0mDHeFWPd+g3z7hodtgl9YwHU=;
	b=ft4tqEc5lJDUWxW9l1ZfmZ7DbOTyQkUFMGEBI3qTrcIYD388K9+18yVw2/wB7e35K8IGyM
	HHHqloUWEB69XGVvfSXWTLi0ev1Dru8f+hj2UZUZV09dtILsceibitLK5gpqT3DxaN2YU9
	1309lUR+z8nW2/iKcCfs8rNLX3C23bk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zqgv2zi6;
	spf=pass (imf13.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778965453; a=rsa-sha256;
	cv=none;
	b=uRopT5GIGbwZT7gNx96tyLDUV+YFWEPPnaW372QxkQZZ3JY4uZ6xjiYpO6R6uaqlV+7i6h
	3gLvKfaznNU0pbtOedldJjgzuqpm9uBZGdg9o/pjKwyrO8ZmwDdaZ0WND2KA0qZkiYcBR0
	TaDqTBmxtuEQ2mrvsGB6nUlnCEdPH0Y=
Received: by mail-yw1-f194.google.com with SMTP id 00721157ae682-7bb0d18c7f9so4156007b3.0
        for <linux-mm@kvack.org>; Sat, 16 May 2026 14:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778965453; x=1779570253; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGoieryUDtogh5w/DQ0mDHeFWPd+g3z7hodtgl9YwHU=;
        b=Zqgv2zi66r3ToBHSDw0lWPu9l67JcjtVoNFdj67kQ5zwncIqsneQiTPw3jVOPyqIGm
         JMgOMtcTMkdCVUizmblA0n3txTCKCK99A6r2GlwMJIpD1H4XL1Zsyo1kWgqFK0mxkMvl
         pc0Jex0HUbniWBweYPBuf0T6s0dSSowYmtA7XI9+tUYgG5vgxjc9NEc/AMe85yzMuNGl
         4Gcsr6rWCSZJjtUryZy+9iQXy+s4c+cSwipEt6sMVvW6JBDZfKCo/5C/tq1MRF7sanQf
         6ib4rmSV5jQRm7ZXDICpZ0Mn6DfjP1AT+HjXTZGHlr4xoeuusrvH7LHi1ZttxYfS9Zsb
         GcXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778965453; x=1779570253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fGoieryUDtogh5w/DQ0mDHeFWPd+g3z7hodtgl9YwHU=;
        b=gexYTYgsLZD7gvxMX/OwTYmMzz5DHELenCVNkRWR/8JiDbl3ZBQTLA+VB168Apo4o6
         5X+/t+ap5gzN6Xc+grvl50K5nCqcJYo4FzjbEX3s3e4llphoPbWVKp2P8Gbn8K3nGyAZ
         E2XYoCvIjYL8o3C/AUFttTh20kLVlTadw7DgX/knuLbaqlqqVzdVa9AptZSG2Iz+8N3L
         8tJ23WNf5vvTp6MummVrom25aafvpwX+IlEG8ARvOhzNg1ub2nNUnUCSryCijTYQ6Yvi
         l7c1eIN5vml/U13EyEDr+wpPncDZEL5a1t6nDcdz5lh4KA/Ygp2FjGLJbGY8YDCPcHk9
         gSmw==
X-Forwarded-Encrypted: i=1; AFNElJ/HMZMOt7/o3gPeuP91zYFtDZxnekzgMOEP/Z4HgR5V9TzSjr8qfnECShYCqbVFnP1Hz6koqwInHA==@kvack.org
X-Gm-Message-State: AOJu0YzmFW5OhEbk8jJghAH0mvo078CpAz8dMqsaJNyOTBT27IXPrD7q
	WXlx98uT4DQvUXvaIYGmryenJe5CLhkpb6KyFpUxXr6Gn4s28ADCBTM=
X-Gm-Gg: Acq92OEz+fygK8H+SmgWPduj64HJyDXLZOeYuJYqlaOZWTDeqlv2YHGEhSMza7aSmZy
	VDxvbclzQKAsITy85ZOsPLLdBkFR7TJ1ijyEzsZJY/sSVPHT8QLGqErNnRP+bUE8aWH4nrMNo6S
	HY2gFgccvkEa+WZPPX7fL/ckIboIsHYZm2u3Ze9rvVMdkxzPWfsbEPgUhUgGAjdLmk81TDCHf3h
	Fd8fwBkHyr6pszmUJJTLOaVKxNbXV1ffbpLNVLxNy+PU71brB1YQ8P/mLgYXisMzGjfmZU3Ci0U
	qY0JT9rO76AI2gR8PEPs3KMwiG1oGsrtVc/StdvGM5jJq3Upe0yvJ1cCSKR+2WfKCnbdr7qFtx3
	lnOXvCtTP4yHe/EPgygdAkPigSU8i0zEuOJuTC7kG0/hhKjM0qMcIL8JltKR6VaFuWHenRYpwuc
	xFLdOCYD8GScrhp81WVKnEP9wyHynP6Pk6cIGjW3ZN5gjXu8wY0NXAFuwTnjnORKdo/RDxU840N
	A==
X-Received: by 2002:a05:690c:e4d7:b0:7a0:4146:6eda with SMTP id 00721157ae682-7c959b8ebabmr94328007b3.20.1778965452710;
        Sat, 16 May 2026 14:04:12 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f55bca95sm47468617b3.39.2026.05.16.14.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 14:04:11 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 5/5] mm/damon/paddr: add time budget to migration page walk
Date: Sat, 16 May 2026 14:03:57 -0700
Message-ID: <20260516210357.2247-6-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516210357.2247-1-ravis.opensrc@gmail.com>
References: <20260516210357.2247-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 96E3D2000A
X-Rspam-User: 
X-Stat-Signature: tht719r739pgn944wc3isuf9j3x5tyy1
X-HE-Tag: 1778965453-916846
X-HE-Meta: U2FsdGVkX19htxzt1EgdOpkcTQnwtZ1xZsFMjaLwsFfPuQW/6LnMANmAxXa+Tjxvtk/EFwTGUUjWB3ft1Qjqbu7wVWRQz78999RlFUxm4RVq2IjXTL+qftoFt/8e1FmXMvWcBhQJRp1vPHmFj17obFvRhrGXz4YKzznMKNTLNithEvWmNAe29R+cJyn4gcV39CaGSLrDeQAVEn7H8aAq2fZFmQU9Rx44nrgtsUxvU3BAecEwF4PFMgRuO6zdtjfd8S6Yj+xVnCJ0TFtRCJen2bEX2QENm7bU5jZD0I5qbIg+YTi+QKf3pzZsqcCoOXxD0ROuyW/ZDbQaWjVDThyGyBRusMF0wss1O/sj9hK1MJZPJ6UgAPjnji9HQuOcuLFrFpAyDnWVO08UOXp/zR5LxL8crbP5QMVv1RjhcuqTii0jSovMzZxSazeKdwTDO9+edXAReAoN6zUl33I+4mRCn7NfLaZWXOlTHqFTmNWS/g9kdDeJiPqxwXZO0vVGdFTpiaUrpk2+e1hqVoI42NOcrvgYszmDQm2Tv88tftVGqhSNHqqrI4omabYC/3iO5pNIRgtGYdzBV5W7PNmnl+bKDEopWvx/EvKvWRCUYAIejdVJWKXfVWlTh5umqk76ni4gMp8fTvehyVDfKzZ6P3xj2n0PC6YrhdSZSthyu1Bw+43n0KbLrTQ9cg1+JgivIP9iN0WpSSzWFnq9xQQArhFlFwvOSxrrEW5vhKUrYUdnq4/d1aoRMsLuxGIX4nZ+gRh9SsMk73kKnKD2/eZthw4PR/82T0hScG8+KV/Od5jpmHzVcOg1xnyy1luAw5SjYgUvhzumZA28Biy/SQ0EMyWlOoKvq4m563nmb/Te37lyvwvWDcB/Iii6ZDI1jo08Pnh9eyjTrngWUf3lte6TCS86MGFLgoMZPjvTxFehMPkyLH+IY3IPgR7O4hlsQ0lrnfm9p5epR+cOODroLu6JdxY
 YWMB7A4t
 lMNf1Se2PNZzUkLfuohxWox1Qbn0aJqbrFSghTGUmrLqPdnj9Vrb+8Zc11IOKSiH9w05RfpF/Fw41PF4ComI/HMcfPjMoj9EcP3TPN/mgxQ6XP3rNwStnRRdHNPbQHA4Yf6KN8IbnjPilEnFb3o+5ZsOy/Omvt5ilIG5nx2Kt9K/Irs+XctgA+GQ041ZpohKECPY0YlSD5SA7lZfMLD68mmD8ZpVX8Kchn4MPI0z6XZy+BAgaXScphvEB7PWsqTbb+y0b6ALalRyCP+RN32NnmwkLgRPw1IsEuIKBDFxZENLNsQOBBcUbyBoipezmfXPzFK/kGNwaT5f3NqTRiEDPWrjSPfE7cbZKavivFj+naskCZptxp38USDOLQ+A3izYJjtYeH6/jDjjaShQcGGGK7rzRDp6G5JRBOofwuIAa23Jphphifum0e+pRRhoD3PCxzQnOpA+n/Ys2roulk1IHaIwqy8Acjj5UgFeuhVOaaxfR6a4RNFrzzLS0y/cvjuiUEZRPM8r/AGn+xt5AePSKaZ61cX5q+vD57GqQxJeXmJYoYVlteubIoinvaCjLSVN/cu/VhdD505WStvnJkMLi42nSniOBkK1ZlOA4eSKSAB5p90MfcS+fYtzupV/Juawr0F+jPDPEjBYroiaQocuo2B5W60eAhMNkO5Oc2ZKHqPCGpJvDm7FjrlTU5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On populated physical address ranges the pageblock skip optimization
alone is insufficient — most pageblocks contain at least one allocated
page, so the walk still iterates millions of PFNs.

Add a 100ms wall-clock time budget to damon_pa_migrate().  Once the
deadline is reached, the walk breaks out and migrates whatever folios
have been collected so far.

The time check is amortized by only calling ktime_get() every 4096
pages (~16MB of address space), adding negligible overhead to the
fast path.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/paddr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e844c990987b9..a2565287bc10f 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -14,6 +14,7 @@
 #include <linux/swap.h>
 #include <linux/memory-tiers.h>
 #include <linux/mm_inline.h>
+#include <linux/ktime.h>
 
 #include "../internal.h"
 #include "ops-common.h"
@@ -254,6 +255,14 @@ static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
 	return damon_pa_de_activate(r, addr_unit, s, false, sz_filter_passed);
 }
 
+/* Maximum wall-clock time to spend in a single migration walk (ns) */
+#define DAMON_PA_MIGRATE_BUDGET_NS	(100 * NSEC_PER_MSEC)
+
+/* Check the time budget every 4096 pages (~16MB) to amortize ktime_get(). */
+#define DAMON_PA_MIGRATE_TIME_CHECK_PAGES	4096
+#define DAMON_PA_MIGRATE_TIME_CHECK_MASK	\
+	(DAMON_PA_MIGRATE_TIME_CHECK_PAGES - 1)
+
 static unsigned long damon_pa_migrate(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
@@ -262,6 +271,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 	LIST_HEAD(folio_list);
 	struct folio *folio = NULL;
 	unsigned long pfn;
+	ktime_t deadline = ktime_add_ns(ktime_get(), DAMON_PA_MIGRATE_BUDGET_NS);
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	end = damon_pa_phys_addr(r->ar.end, addr_unit);
@@ -283,6 +293,11 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 			}
 		}
 
+		/* Time budget: keep kdamond responsive on long migration walks. */
+		if (!(pfn & DAMON_PA_MIGRATE_TIME_CHECK_MASK) &&
+		    ktime_after(ktime_get(), deadline))
+			break;
+
 		folio = damon_get_folio(pfn);
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
-- 
2.43.0


