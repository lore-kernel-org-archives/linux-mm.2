Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15DA9EEF300
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 05:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FE26B008C; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326D16B008A; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229186B0093; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6506B008A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8ACAE1B8A4A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:29 +0000 (UTC)
X-FDA: 84510906858.18.601BBE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0039B4000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EV78gkF0;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772689168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4meiMGwYvCF+Q/G7tmBV4Lx1Nc/bHu8ccrUbbl0TcE=;
	b=EZ18EebyyTogOfFwqVt8Efu19vHcvBd30r+mh13KIF2AHp7N/thsI27mNoCbreKMnSi95Z
	Xt9Q8SFOuh7XonDfKMPsJFa60qnXSwkDdxqiaWYDb8MoLD5pSeDI8oJ12QOxVVPUcj5f/h
	kFai21lf/hY28hjl62Jcj8qdE8QDId4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EV78gkF0;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772689168; a=rsa-sha256;
	cv=none;
	b=nZJ5q8EKr9hJmT0dXx8bJwvCeMIP9Tnkf5+rcdSSrJm9TVRsZPC75pYH+l9+8tVOd/+g07
	r31v3CdPcrOBg53IgZb6f3f0CUqKxhKC8RhdkTBEe89M7ko3kmyAznd95XMOr8T+evwJlL
	GzdvoMv6rbG6lteLXn9B6t6rhOlIyUU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31F3D61340;
	Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C138EC2BC9E;
	Thu,  5 Mar 2026 05:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772689166;
	bh=bVVliIOg8qhYd2P4htNiq3HDElr+pou2NiqB1WgEprY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EV78gkF0MgLzcm2fqzlweoxGrUfkuJ7etBaw1Dbu57ttNfmS/snYwef6oboti0hA+
	 AXNRLPLVMVvtzKGAKsEdkV75nLk/WjIuLytyXM6916kykgeMk1xfZkPsDVcqlQYiUU
	 +u+PlWwDwhVg+M+3yiPXFvxCi2P+IdUPotWzQFPoMPoa0tbPNjPZr0pmVy+uPuCfEQ
	 efHhwVMBycjy7ltHgnnN0hJ5Q3Vk/GFqutOjI2GQU7eQCxnABFL6yyQRGKH5l81R8P
	 RtQkCHc9KJj7NSfpy/wihuWBvjLJIR37f7U+o8Cj1oRiTT3i3Bn8TOykWC5HKeS3/1
	 MvkZI423te5xA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/5] mm/damon/core: fix wrong end address assignment on walk_system_ram()
Date: Wed,  4 Mar 2026 21:39:13 -0800
Message-ID: <20260305053918.83786-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305053918.83786-1-sj@kernel.org>
References: <20260305053918.83786-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0039B4000B
X-Rspamd-Server: rspam07
X-Stat-Signature: sm6w7ynqr3gw6t56zygywi7k41zkz4o1
X-Rspam-User: 
X-HE-Tag: 1772689167-851338
X-HE-Meta: U2FsdGVkX19pND+ayqHJQgezp682ZYf1kf1GcVipVniCMcplqGz3rZcdNSu4FfxGsEIBICMxHCJsjLy3z51mTM8a//xzfC8dGx6RGVH7fnQEyhuZ0qXnNmK+x7/ql3cKj96vgZkwfrll8GN7NpxL2101GJFrDwgI5CGn4U001xKgXBF4+CMp67L/wUfo9AMWEZTF9M/e2gZPnlKcBs51Fb/HCaZ5MTL1aDJj6AIzHYCt0rRYZldMh5ZtdeCfC51EZXI4wJqUHO20kpU0CkwxpEMRqRKmAD2Ew1DOFNt0RpPo/X5wUOVM1xkHyO15IaDmOhtGKSChbYN9T9Z6eWRBud2owWzm0m/i0HNedJKhgPw0cxpgOZGq0xh1CdLT4pjwz65rsfs5osry3DhNh2c7pchhR1pqEwTMv56wSkBF9CM+KaNSvV27gaJbow4tX+A3XW1JdOmOmPTslZzvO0QiY/ilTD4P0CLAJy08zbEHMSohUDFnSxMTcmEUxDQoxBOUsZzkIsoOgScxylWStMP97YZ9g9WgkyRQz0gjMaD9otxvMwGOupP3hmP0r6ddN31dsodd6W6SNxN8vDvTnfP6n7EEsVakD/pFQdOVW26j9eT6+wCap5Fi5gXtZRxZ95aQWGj4JHWT7ORWORSwpiCYgzWo5DaKWsVJrSJT6SSUhq6etS852iWnLl/MMtBRYmTJd5wir/8Xb2D4kG2Xax/1umm47vrlQnKiqg3X5nx72Nbz8BhPoj0QhIdah74IVdpxN3iubiFVLeNpZs+/PUUtSXooBcc6Pc51GaC/pz4F4bUDG445K3JS4UPpkk7CYdgyXeMa0NpB2XQ7IdzShYgvW9l2DoombQEQHOArmAfXqlrbXWOgmDUAjndRZOCmWB2Co2s8+FCZIcCg0Uyy61llxlV0qv8bwRhUe7fJYHWn+WkOW2oGqSPxEVuBrDiCZSgEbxhEA6AeooMRng3Mj1d
 G/JakGWi
 l0n2wVC5+0yEm2nunBHZl/PVp9Z0Nu+Pfx9SxpZFSa1gT/qeuxyqmae4ZG0EaHvPt3pfjSK33m0sHELHGS468L/VXTSnfCw4WcVEoVimTnrGDXHiZOkA7stbiqwpRGcAmG1EnjnF4CnEtK+z5sKcLPu3FufGLw+6QKpXp0H7ATJg4gsTV6TYH6uhm4JY09R5pV6g5VZmLkIW967N65u0IghYI4KRm+5uxjcHCIIH4CJ4JElSylRiohnuK20NT8m+ImaRsKXwSubpN1h8z9sbsBO1WTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'struct damon_addr_range' and 'struct resource' represent different
types of address ranges.  'damon_addr_range' is for end-open ranges
([start, end)).  'resource' is for fully-closed ranges ([start, end]).
But walk_system_ram() is assigning resource->end to
damon_addr_range->end without the inclusiveness adjustment.  As a
result, the function returns an address range that is same as the
expected one, but missing the last one byte.

The function is being used to find and set the biggest system ram as the
default monitoring target for DAMON_RECLAIM and DAMON_LRU_SORT.  Missing
the last byte of the big range shouldn't be a real problem for the real
use cases.  That said, the loss is definitely an unintended behavior.
Do the correct adjustment.

Fixes: 43b0536cb471 ("mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index de38f2356b72b..db388d05cac3f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3056,7 +3056,7 @@ static int walk_system_ram(struct resource *res, void *arg)
 
 	if (a->end - a->start < resource_size(res)) {
 		a->start = res->start;
-		a->end = res->end;
+		a->end = res->end + 1;
 	}
 	return 0;
 }
-- 
2.47.3

