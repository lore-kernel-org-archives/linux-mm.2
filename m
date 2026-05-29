Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E2BCD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 00:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919B36B0005; Thu, 28 May 2026 20:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0736B0088; Thu, 28 May 2026 20:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DEF66B008C; Thu, 28 May 2026 20:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE916B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:01:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 075081A0B48
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:01:18 +0000 (UTC)
X-FDA: 84818502636.15.BA97F4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6D1D312000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:01:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fPK4lzw5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780012876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CK6rWCS8LFvFBXjfIvuhhFhQ6PGQWXZdEx0+rj0MOdk=;
	b=SGNNtgPn05FDKkUYvSv4a7yOMlnS5b5VN/4v4gCmA0InHhd7UU3GhFrxW290Swit8CoQCz
	WQavfvvXXJYJuKCXNCpyALfC7ls6H2XmXe3d0FV4wPH4OGrpj8xYiUfGRy5AttG8e3m27n
	yn/KiNdTNci1pCSmJ1zsGFx19ahEDxQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fPK4lzw5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780012876; a=rsa-sha256;
	cv=none;
	b=qfVviyGai8qQGtBOjxFIgvDMo/bwbWQGPV69mtUNXNKsRWDQRkvVICR0bZ32BtCfG3B24f
	uxRWgjpO8OolBRXa7wo1H/aajQ6qY+yZbNVjqjmLZnPqBD/U6UjVjFnreHVDKaJANyTsJQ
	VK4wzd7O8st6rZbjCU5lN8sMd3B//dA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D77136022B;
	Fri, 29 May 2026 00:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF281F00A3E;
	Fri, 29 May 2026 00:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780012875;
	bh=CK6rWCS8LFvFBXjfIvuhhFhQ6PGQWXZdEx0+rj0MOdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fPK4lzw5k7IzIyNZpg+Qt+0FuVA88Hrx6vLXTH50CRMamVCLc5aY9RMKTq6dzEFCY
	 lvAoE0Rey1ZVJs/Bfegtwbc6ZTodQOniz44JS4A9BnSGs1EdaVGri0W0ms5LSvFvD9
	 3d1X7Riy+QEXVIL6UYHpPGSSp4WSwaL3m2lqBlN8ZH5gFPZPVMrrooj4KgpGg630Zp
	 5BEsb1gmfsZT8yRzOxxfyKjRoaaSd7WA8eOvlC9p+TmJR+qpOw761exZbPiN1ZAPQF
	 3wrkaDXV4WQ/iEsCezgxV/llqDGlXaNA2aQgWvEk4+SvlWuCmZpYqPQoLloEfr5fFP
	 EhGE7Sp1RRF9g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/reclaim: handle ctx allocation failure
Date: Thu, 28 May 2026 17:01:02 -0700
Message-ID: <20260529000104.7006-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260529000104.7006-1-sj@kernel.org>
References: <20260529000104.7006-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D1D312000C
X-Stat-Signature: ozwd7pa3fnqk4po1xbf8ffjpezj5tp11
X-Rspam-User: 
X-HE-Tag: 1780012876-592721
X-HE-Meta: U2FsdGVkX18nx1YZHGZHZ65sn74JxqiAdlHBNoMAA3Kw3Jtx4WW0WWIpu9gYo4Bwm1Ket36+Mf8IobW5qh0iBLfeWAnhPIDWezSjPblO3Lj7O65qr3ThDRVEkcKyYlr4fDIq3cmpnWJRlY1r9OoLhuKWRi9XCxtQn7FKivdAGqPfPK6SC3IhDfzepx4uDNTiJKc+NpquXrqctOoIzcyf8HkLdSKychmYDP4P7VJ7vkjNURP0V6/X8TUYyp1w6wsmueJjw2UXQ1Pg2eRhi8uw4wL5uF1GMhXjTcM5KV/q3TmglDsOQLmAJD3NnPSOQPwA+KHjv0Hew01g9Cl2noQCU1bV4QGWNgOmaCxhKsoqjt7ar144iIY6qZ+98crC2+89mAjNzuwYR2fomk2uW6tKADe67iQD3Bdc9ZqJKuP9b5opKYvvD/hrwCQ70N+jF6OY8rhgI+S70mEy0i0Q7pAP8bzndHkBu53k462pHLSuvodYmp4DMopr9FhHygx7cskitGmsgRpM0+UKHe/r5keG5+c7hCk+t8Lm9MYHYwX8Tb5rTQjQ+mXtfhiBjWJ2lRrAobnHMVBm6Rm1BLzQqhkVTEZ7y94/Gry9dkm+5gcfxv0yFTL0VKEVQGeOJOd1oN/hRjlbkZBn4pWWry1e9Sbp9NEgJdF39QRbTDfETucsJQSWgh8rlqegoK+UtGtpQmOIj9qUk661h+JJB3fnoRdXv+7ymJlFcyHijGQ3N+zoeUN6vQDkHLZ8/WEL+yeCa8RVlgWcjN/XmuTdUa+RMxB9Wn2KY2Kn76FYEGS+PDIv5TNCkVoZINN8d8cefvMG2w4uFyBFhYPw8G2vIu1e3iFEf887hC9XpejNuiWvhTujZo9fwPwNNfefiSOu81QWhCZwS+UQL5bXLZyQ5S7fMWawjeuPVpOVruD1FY31Q7YU6mllomcL+JftxXTa3bincbgVgI9BflmIT7niuyfTQCd
 OxwQ21aW
 EfF6plVreVXeaihZzmBcPh7Q47AWl56u8quPKf0RFvXVdTrAtAgIrzbjH45bwrVS7bJS/8yAFgN7I1oorElnhv5vgyIhmhmPBBDdtqzdUBHfosSkXv30ZDngI0IEFxSO6YkYS5ESxO+z/vqIW4P/yI5tIjYw2WSG3oWGl921o26lGpic3exID278wVxmIL8AElRZI2YL5u5Iq6aKvqNdh7JjIxVt3kSPDqEpMh2GfBsCbMPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM allocates the damon_ctx object for its kdamond in its init
function.  damon_reclaim_enabled_store() wrongly assumes the allocation
will always succeed once tried.  If the damon_ctx allocation was failed,
therefore, code execution reaches to damon_commit_ctx() while 'ctx' is
NULL.  As a result, it dereferences the NULL 'ctx' pointer.  Avoid the
NULL dereference by returning -ENOMEM if 'ctx' is NULL.

Fixes: 3f7a914ab9a5 ("mm/damon/reclaim: use damon_initialized()")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index ed446d00ef1cf..ce4499cf4b8b0 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -399,6 +399,10 @@ static int damon_reclaim_enabled_store(const char *val,
 	if (!damon_initialized())
 		return 0;
 
+	/* damon_modules_new_paddr_ctx_target() in the init function failed. */
+	if (!ctx)
+		return -ENOMEM;
+
 	return damon_reclaim_turn(enabled);
 }
 
-- 
2.47.3

