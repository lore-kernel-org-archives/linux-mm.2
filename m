Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EA9CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 07:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD978E00EB; Tue, 12 Aug 2025 03:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195458E00EA; Tue, 12 Aug 2025 03:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D798E00EA; Tue, 12 Aug 2025 03:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E84BC8E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:11:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C432115A03
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:11:02 +0000 (UTC)
X-FDA: 83767233564.19.255BBF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 12B0040008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:11:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bOP7mj6e;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754982661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncZ6BoUnMMhMD4KD+ibq2ZjvwhOhRVxTWEnCeeLQFVM=;
	b=nhrWvQr+/6sutpN8JPmDc4879tTNwbjzMgyPV+vqKYKXhk9pccmoyoTQvRE2bL1gEndL0B
	CPaYhPvaDwjyncj+CahDUM35V435PXjTqYpZS3mVeqLD/ew9B5lJ+rHYVfluHG5bsLEqA/
	TucrvPPzcexlGI+l2tDsaUhZ3IvxIgk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bOP7mj6e;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754982661; a=rsa-sha256;
	cv=none;
	b=Rjjx72mLlq2cbNMAuyNoHlySjytQvIkGp1z8VyDJubd1xU1pir9zvsHbKeS/MSSl55tQUN
	hXSXviKA5JTI8NIw4gDnclVVpXCTidDrJfPy+WyyIO8W+tjh8QrvOCPXKLvkjWwmeZGh9s
	nIlgGNow9K0Gd3JmeFOlat9toSwMZ0o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A7996020B;
	Tue, 12 Aug 2025 07:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93824C4CEF0;
	Tue, 12 Aug 2025 07:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754982659;
	bh=obdOWxAf7RFXJ2IB/8yF3uqWcTZG9h0+RKS1zCQ9UP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bOP7mj6eg5jHCROEXjruEK4HythPameWSjzlj+oPPo0hvojrO1/WpDET+iDJD8mse
	 KWNqhP+95GM3HcOpwiBQrg8bcqV4h0tpe33J/q+TzIeNJOve1CzVPrSSHwSyJM8aZP
	 rD06s4wj3xZHNTOAJCdM4vQX9Nx0KTARmDerFL/6zR50yZoego+DTMzeRoKemji4XV
	 2bCb7oe2dq66FfEFvmgZDr0Eo87+Tbic6F1Y7+cZP3oK4DvqnAVjxIs3X+BOafmh91
	 RIe86BWh3X9LUkIID21z78uX4CqkNTDv0X9RC34ZmS2Tw9VHTfNa457rnxxNr2ZlRz
	 B2l5/ACkHxiow==
From: Chris Li <chrisl@kernel.org>
Date: Tue, 12 Aug 2025 00:10:59 -0700
Subject: [PATCH v3 2/2] mm: swap.h: Remove deleted field from comments
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-swap-scan-list-v3-2-6d73504d267b@kernel.org>
References: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org>
In-Reply-To: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 12B0040008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: sfb1qdipswgeqqzic8atoeb3k64wk5qp
X-HE-Tag: 1754982660-10583
X-HE-Meta: U2FsdGVkX19VpjGMG/6TH/Qh/4Nr1PokvKY7jxMRgEjXBKq4JCBFM1ajQq00SuFoXL026pYMcaG0Erec5RjDZ3evVQb9Qu8P/zjnexWuujjy9HihsSADSvGvyC3db17fD3nRVmo5X7g0MrpY6DLvf6Qu6rHpYyVDVBjtzNJ9APVUqdZ/zntixmSKm8tA/rLX3DNCY08k7HHSAlBK+JhjYtm5cMAOddZJnxHzfT1Hvs2/aqbuA7YMssFeSu8JuAU0BelWKLNdPZ7m5vQjl2nyqIdxU6E7rZZB3yMVTHKpCuS5dVwdDEZXtgKz8Jdt0g3jI9biUDsbyISZMEPtdDmMtWDDp32AOOqqZbMRgQEECgYLMXPB367YIwUjR7ZVOR+NoDr7F0g8csPXMaFUp71b3ss517gC13iK99Qmm371FE8OQY0Z12crKtH+21uaGFAy/afjCXKSlz/M+VLXUW2yp4XSwDaYPObxoK9h4+jRo3Qv4QGgyCjPn8vglImjbZlBfBddhqJIGq5jaFl6SFOeehf6KqNPQUNdfX09LLXmcZdkdZ++GxAyODIqC/C4X/yKT5j6/z8gb4YSjuccO/7OJpXHxVqhs//B/RISkp6XsBGr8Hyd+3NTvLPwNsaiIi9AYeYC3Rhdtu+J/AZl2k61ROvBwHoS+W0YoUnuJw0vyYc8pqdYt2Nua3+XpEcBn8bPRaRo4X6mr61JTJepsZyFmgz2Pnewz8Up4QRl/8iutUeCQ7X2HODsf/u/BqU7JdoBFJwopBfhZPr+UpAU7AdWxRXjYe2wU//olXjDywdRXMAG5+ReLBIPmfrC37JRWSE+eawd9hpENcsq0YpjypvKQmf1lM/amVygea01fJcm3yGfFGV0j/ijk43Xhbih7qXWUHHbX+2D4y3dLEkHhoPZtnY+8vpFveRXs5CO3Ck338u/KMR0fWyq8ENZXUKWbBXcRyjFd9gFaQpnDjhpkFx
 bxpVzSbm
 Gre+nzDWMJM748b38w7aUVvLFNi6m6AB1H1+AK/hdMClDihPLf282zqDBsOJkwwStmR7jzIm1spAezVsPAvaFpgvmV81KkXaPgtZLISIn4pE4dN7uPc+/wy5LA9X2kZAjpxJCcHU9ipCZ15QdrhJS4dReUPGrTtC3XzvgWNtugLvQgvLPTOoKtsSzklNHygQNbWvRuce3RsRUjoXZaEDGWGEd/uVjYt9DAcMzRww5QsG93oP2usz7PBA2WA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment for struct swap_info_struct.lock incorrectly mentions fields
that have already been deleted from the structure.

Updates the comments to accurately reflect the current struct
swap_info_struct.

There is no functional change.

Signed-off-by: Chris Li <chrisl@kernel.org>
---
 include/linux/swap.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a060d102e0d1..c2da85cb7fe7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -320,11 +320,8 @@ struct swap_info_struct {
 	struct completion comp;		/* seldom referenced */
 	spinlock_t lock;		/*
 					 * protect map scan related fields like
-					 * swap_map, lowest_bit, highest_bit,
-					 * inuse_pages, cluster_next,
-					 * cluster_nr, lowest_alloc,
-					 * highest_alloc, free/discard cluster
-					 * list. other fields are only changed
+					 * swap_map, inuse_pages and all cluster
+					 * lists. other fields are only changed
 					 * at swapon/swapoff, so are protected
 					 * by swap_lock. changing flags need
 					 * hold this lock and swap_lock. If

-- 
2.43.0


