Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E03D7C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34F76B009B; Sun, 30 Aug 2026 06:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4EE6B009D; Sun, 30 Aug 2026 06:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AD996B009E; Sun, 30 Aug 2026 06:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 683696B009B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0221C1C191A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:54 +0000 (UTC)
X-FDA: 85157575188.08.682BA2A
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 999B020005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cKmK2c99;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=RwFpnhjC;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788086031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/juGQBpeXjCCGF/Jvctg7hi+/3D3O4YYez7MG8kxSg=;
	b=Pq07rNNtsFsc02m2lB56QjDUpmAoOliwiGnAF1LZGyPN4ilG5Uxj6xnUr9j+1BztMUanGe
	xdDZA0DWIhdRmsUvMlPjxcsA5ftYZXQFMjWX1MWAC3d3PMRIIKHFIKkD9i3tgF9cZQlM0L
	53yhowa1J8j/rGAenteJ1cZ0lHmmSxc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788086031;
	b=pUFcyvzXrpOX6Gn+j7iPygvQrtZroAjLO8oX490pKctBhKeYlGkv9+HKkU8USp/YCTTdZQ
	Zx3JMG13fJCUuXz2TW7hOCoEFZSCuMkz4lKBoYe7OBShnRD2VAXgMzz4ft1pHY6UQK3qvV
	BR1lkWKH229OqMJIl8nkTmRwc5dmW+o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cKmK2c99;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=RwFpnhjC;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67U9g5CZ3316500
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=d/ju
	GQBpeXjCCGF/Jvctg7hi+/3D3O4YYez7MG8kxSg=; b=cKmK2c99kpyD+CJhbslW
	GMsg+zFJGL562rbCixAhuoRwdYIq03wDGvBbBM9J1p0jYDWKQ1g0PrjMtqhBjkFR
	33TsmiHjgLnr6pTYATMl/D7HZaJmezrPekZBWtvI59TQ2KlALpsBGmWzhfKUvCBS
	dMsyt6+FSNlsYqRCbKwHckJ2LcX1voJO6gtqeBmlP7InxyM02490+dqbsbAcg2zi
	jGVHdtSdlizrUDhXZ4A7FzNK7/3eCq8Trv+7ZSm5awSjCCjLMeAlPr3hhy+wi/+B
	8cbshrKJKSvDm8F9vlABeI9FbQZ9n/beZzBoiegg7MNaG/+ykkk0orXyyVpkfMXX
	5g==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbrhq5148-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:50 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52fc3bff8bdso36261991cf.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788086030; x=1788690830; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d/juGQBpeXjCCGF/Jvctg7hi+/3D3O4YYez7MG8kxSg=;
        b=RwFpnhjCqC52hZxwPjGAdMIBcfrpNp/tp9VZv76U26MLgwbZpHaAJUX5YZcSX+NP89
         2stJterZlBnMpDykgdAMs58G9NcbyAWwpuDmEYGH2BNOymO4qay8pWOVkAi2JCfwIs83
         2gFHG3WxTnul6mkf+WdCrHli9CSacWyE/vGOgpHu2BGi7rVBoPFpo0U+CGo2CWsAk/Gc
         4c4umjyFZfBtwqlTY4n6OhskIZiN5WewSEO38OZ4xmrt0dPgFmNyrVxHgxi6r2ZuLFQT
         L90Z2CgtV1iftIP3VEyO5xRO5Hur1SuzseOMww0BTNzmj42lCtxFOvMmVToezBLiHhe5
         B7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788086030; x=1788690830;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d/juGQBpeXjCCGF/Jvctg7hi+/3D3O4YYez7MG8kxSg=;
        b=H5Z7F2mz6cW007d/P+xvnobLmjySk/3WhoMRWk2A9I6eqXYuHGEwyT9fzYyW5rnBJ1
         3P9DoUySdLvfWcv5qJJ5V4scOWBSk8avxZ1t8mr+581IjdUAcZ18GR18ZdtuVeGKvleK
         9n9MJkld9L22gEq7E7RGvi81tGbCzeIEcxri5/cMagV3qHLfJVJezuvCFVBoh76YxlDm
         e1ojcVVtNlErWSyJyV6JLFtqe2ExnPbRisgZzsSSbzonwTPgw7lgBWU9piVRZXW51nwr
         dYaOdV06YC6qScAEVVHhwrO7tgo24v/5KdG1zo+6oYJ4woz75Rv/ib2FZ8m63qnT5loY
         +baA==
X-Gm-Message-State: AFuF++kHIGx7LYo23rREaVC0Ulq2KPEDs+wtvkkBPmAkxVK3lQMpWvIv
	w1dREU1LuBp9YvFB2KY1FlYCop0SnM7I+h0PjBMjkgoYEBjyA5EzM68HAOHOFoCh7Fglits92Vx
	5aymbKjKZsx5fpc3sj8bTohPm4OF7bRQnQjyGYNJt3c+cSpri
X-Gm-Gg: AR+sD13W/v/Qem0sHDrX/N0mByQ/dYXj3ilr3U8U7oDykHWo0MRJsq+spdkw8YhY+T4
	PTJ8ja8wBazLom//b1lRBnc7iMg/LAsC+s2XJnP29jlxNkn3Uz2FyOWVL1e17YCCX8cNJb7Oi3Q
	kjIGMTDXnFEihkQhLsjVRVobsIuI3Dfja6/lewi0wsfTKi1z+/g1i/Xs7kSwn+gFlI/quBqCXPa
	FbiAcPdH7GP9870OII4VVkSs2yRvEYhVfBiclPReMn1skYcC2wVgim2JfxPDhEdYy2yp1iR6Ak6
	igtf1F5alfbbxKVzU6b02HORCWZWQiqpeYmTOAQ6mpJzWgGLXS3ekuwTL0ullbO5W4H12iaJJqs
	VNtp3QnCPQ2iE17e/IrmwEEQdymYm6AR13P9+G2EVpQ==
X-Received: by 2002:ac8:59c1:0:b0:52f:ab8f:43d9 with SMTP id d75a77b69052e-52fb95e7d48mr208988171cf.22.1788086029991;
        Sun, 30 Aug 2026 03:33:49 -0700 (PDT)
X-Received: by 2002:ac8:59c1:0:b0:52f:ab8f:43d9 with SMTP id d75a77b69052e-52fb95e7d48mr208987841cf.22.1788086029567;
        Sun, 30 Aug 2026 03:33:49 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccf5a580esm69304005e9.3.2026.08.30.03.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 03:33:48 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 30 Aug 2026 06:32:28 -0400
Subject: [PATCH 6/8] arm64: mte: make mte_save_tags() and
 mte_restore_tags() static
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-folio_swap_entry-v1-6-7786b52acbc8@columbia.edu>
References: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
In-Reply-To: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788085997; l=1787;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=JMnLiPjPeuQ8XHbUf4RdPN6u8wF8V4jepqQl+nANMew=;
 b=684WpVyyjKGNjL08aBqlBsLxRU6keghtlyIRd3w2GLSP2VrXOpyQi8zFCsDv7pRQmdsJ7w7hX
 cAobQWSyjSRD38U65oQjH5X6lhPqAu4kzOdCs2baVilseYiezKm4jlG
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX5fdvdO3fe3mm
 J95VPolW1paYpEaeeSiH2y0usYQwcbMAnpuAigKToX9NCAbUYRPY7xaeSb851SuJS4mB5kizvnH
 6HXCL4QzyBw7yN0sQhihvNS+QuyxpNJXltPc9IPhqjXTOKWUSgWtuY6tW11OTI5+98We5qmnO46
 NpgdNDzJj4MRLZPoDq0EP5vldGRAw8JVQU1TqKMrWofzspQu4TnRDfkuMOkCVq3hFnbxFjma2EC
 ODf3VNhC+WcHNKwfQFxh2KVULlHbe6sEGxmVk0GjNrFcr+apsWvChkrK9rgZni94Wl/EVT3QqhP
 FZc269TPoz1x7hbsmvRwVm6/d9WsjTpOrV1WLHD/5K/TD4Wt/aQg4Cyflznm50TrUOo1VTOvpD4
 JYauoRKqtRe2MpqRZdWhGxWDAG7Uk1zExBcggB3/XVoERuMCzmRA9o6MATWsEaFImjP/R30xfZb
 nQQCGPxx7f19VGgdV4g==
X-Proofpoint-GUID: fcSnMHlIEsIMd5Pi5Y0mRvEGnbVAmSkd
X-Authority-Analysis: v=2.4 cv=PeDPQChd c=1 sm=1 tr=0 ts=6a94070e cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=f-bboeSTcrnmky8UUdsA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-ORIG-GUID: fcSnMHlIEsIMd5Pi5Y0mRvEGnbVAmSkd
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfXzFjOB/RYpzjS
 ihK1WFQtHV7lcBeYzrkudAC3uAR2dSVkuGhiIOwKDtyvD6bBWTMMV/HuPQ6+QmiLR0mUdWQb449
 VAa/rBekaJGKsXXG/AJcc7MKB6pTsDSacXatMr3mPmCNafYj1NJs
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 impostorscore=10 clxscore=1015 adultscore=0 lowpriorityscore=10 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608300088
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 999B020005
X-Stat-Signature: o95c7uwbdyb8fds3wito7d3qxdc5hzso
X-Rspam-User: 
X-HE-Tag: 1788086031-751103
X-HE-Meta: U2FsdGVkX1+RiJYkkBTeTs12GFiokC3tQbkEk/zR598ZamJ4EOlN+B/hkJ7DqA/ke/fW5m6DRBhLR7m+afOLs8UYEvQhuq152R/Eb90OkykyrTMj3WFgk0xhsAuGGdUdJennffSKwdqx/lSrF/CRG5AFzYb2GkxspPVNasUSxHcZk7TWUZECJj1AZMQ3m6W7gPQu3wxSIbenwR1Ywfo7m5xGmQFbrBNBvaVKHwMYTRjAMm0lBCBUl0BmG8nT1JXIvq+D48sI/4xtX8WJCHTfrksWQAXHAyxAAIhTy4lPBcNPeHYfZx0Fk3InJ5xDhv/kc2gkHyojwUVJuJliuQO2qf2S6a5TnvyA+4l56ToCanKIgCjZ8uX23wcJYS4aHK1mFyOD03K9eWwBcP6N6/8zGRq0uw9wzqtsTZoAawngtyFc9LOGhCiv+WMaXfFpraCAsuUjYnBmkT8ldTenhY1TCExThM11IyEs9j513mW26LgA7+Tpbek9skD7Up93znkww/IuSCYjpJfBEy3S8Nffm163cm2UXm/uOgDCoMLwEu6UOmRB5dWbOwWY3hv/D1T5wYArqa8hJ8U2u+yuAQ4EXKq6swKW+jdAE4s55ED1kM20c4LJflTdp4teMNXT9RRQrZu5wQxw7VY92eTYJsSC926X0/NbKj3tCUslGYlD57v6crPmjyBlRrjrDtddzDuLMCsiS8kX/hYdVqIheIxJbxRChLXXUBKu011BeGHdqxdHN37ODWeHDoVTB1t0ZP2xcBekNQygoTe7C4nDyP1KGdGdWuPQLPAZpD2Hgdi+XAFgEs+d5Pwjo7CdEIRbeNbRBbMm91j19aVPbo39kr9slwLcVTeNHbAZeZq3soKr9KQ889JE7oEXEz1gjjHJ78OaAV1jmQk1wqOsroAAHk6tE/CFMCUOihhpFegUpTudWeuk7xw/JKowcEd1eW0W/t2/mJzp1A9aCv1AxUgvC6o
 Pcuenl1e
 Dfds1PYJvE4rv4NwVPMSX8k0eGHa6Uk8He73R2uqz8U42/dcMW0klXFfJjRFdwA25tnEXKZQH+lhRWqohAishK5DuweCjzGT6tjDYuOmFrDpUVcGuSrhfw+7eSGUmLt2ca+ggRWC+1NDRTpZI+1Z0WVJf7OhGBgZikDNo6lgrfpdwYcY4XDKJLk7YrzKfEhVgQ2Q5+3GDBhiymrS7aaz0JlHs5OfBROAjFw6O4BdIenxLjZw4SZFFoQYEwoul0wXG4rWV5H+WsiAL8ERYPRFYBDPxA0mBdBobWptShoFC9EVBvfWRqO/AOtnStLVBP+GzJBZDeo8lOTBx1+3L4a3o/487lG99zctHYdIKB28AmRtc/hX0loTirSOSssSX51x1akLMPWiW9S87vYzX++WRyM0bbxWj6rbyfTikRuDs2drK7j0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mte_save_tags() and mte_restore_tags() are only used by
arch_prepare_to_swap() and arch_swap_restore() in mteswap.c. Make them
static and remove their declarations from mte.h.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 arch/arm64/include/asm/mte.h | 2 --
 arch/arm64/mm/mteswap.c      | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 7f7b97e09996..83f3b05fc784 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -23,9 +23,7 @@ unsigned long mte_copy_tags_from_user(void *to, const void __user *from,
 				      unsigned long n);
 unsigned long mte_copy_tags_to_user(void __user *to, void *from,
 				    unsigned long n);
-int mte_save_tags(struct page *page);
 void mte_save_page_tags(const void *page_addr, void *tag_storage);
-void mte_restore_tags(swp_entry_t entry, struct page *page);
 void mte_restore_page_tags(void *page_addr, const void *tag_storage);
 void mte_invalidate_tags(int type, pgoff_t offset);
 void mte_invalidate_tags_area(int type);
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index 63e8d72f202a..3c54afc8b758 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -20,7 +20,7 @@ void mte_free_tag_storage(char *storage)
 	kfree(storage);
 }
 
-int mte_save_tags(struct page *page)
+static int mte_save_tags(struct page *page)
 {
 	void *tag_storage, *ret;
 
@@ -47,7 +47,7 @@ int mte_save_tags(struct page *page)
 	return 0;
 }
 
-void mte_restore_tags(swp_entry_t entry, struct page *page)
+static void mte_restore_tags(swp_entry_t entry, struct page *page)
 {
 	void *tags = xa_load(&mte_pages, entry.val);
 

-- 
2.39.5


