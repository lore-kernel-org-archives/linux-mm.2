Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84CD2C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820966B0098; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA216B0095; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699F06B009B; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30F756B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB8091A013F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:06 +0000 (UTC)
X-FDA: 85161731172.11.10859F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 07327A001F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TGzATSIN;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788184985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSTjwnDV8A+NiGPVQu+FC6bukzN4Edj/bjp5VqLzRxU=;
	b=qr4R0nsRUm3+5a+uVFj2QaZC/Py6lVp5WMOYGESsxzEknwJicKC+W7g/zr8NDN9+qb5lgI
	NZMKtEa1zdCREnNKHtuRISWogZBfvDHWmA/gzcTTkPtjdFbqY/oyhCoilm7FlOu848PNSu
	f3LQhaFBLmhnd0pqVFUPNjCuLrBmeno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788184985;
	b=dGnyPXFkw8PPT9ZtpHV1fTZ6r4IYPd+QJXDIJKiIbjbcS/qLhCVVV2cUBspNSuqxQBVDjH
	XxbfXMnI8tPMoTU1u5KJ7ifKauX34V61HRzJjiJ8Taod07Xio9z0A2XwZUsnnXxLaGsRcx
	FIEqDAcGUoSGLH76iEUeYRjtOUhL9Cc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TGzATSIN;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3206B42A8A;
	Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E201F00ACF;
	Mon, 31 Aug 2026 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184984;
	bh=nSTjwnDV8A+NiGPVQu+FC6bukzN4Edj/bjp5VqLzRxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGzATSINz42tKbEmPPTcS4J9tASvuhG6q2ioTy7mYUo2FOsQA+bY3ccQjSzWis/QN
	 QMqkOCwDM5mJRH1zLaR421tWxE1piSSa1KRtVKWamXiwOzmoitvQnfWHvW+dl/DYA9
	 75rR7U7JuWkaK55dlUNdvknDGqIDpIUPTvVVnZJllJ5v0FI6IDWa8xWeQn9kDr7Q5v
	 otERl2mpbErQaw/3QwaR2o64E5Z0ZzJ5KYuqTbM+lgGUQ9fqY7XgFZcF3/pDQjrCaF
	 TlVkTEHyEuZ2hhpTttLuv9uK2OR5eWtZVA5uk8LTaGf2kOnSGkilVygLGQ+z5MjqZg
	 x1hdN0POOUXcQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 4/8] mm/damon/vaddr: respect folio end for DAMOS_STAT
Date: Mon, 31 Aug 2026 07:02:43 -0700
Message-ID: <20260831140254.72004-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831140254.72004-1-sj@kernel.org>
References: <20260831140254.72004-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 07327A001F
X-Stat-Signature: x5qyd1x9i6589xn85r8qjiqi7pqfpzrb
X-HE-Tag: 1788184984-768244
X-HE-Meta: U2FsdGVkX19NfZjxtTF0/LrwB3NbiyfopG3G5X+2FCFrgPNModBh2m7RaoUFglVau90bG6hM/Y7FF8lqtSAvMhhbDQ+Kj555sNv+Zq0jhK87+uAJ5TbT4/mQa26bX2fyOm7eG05JBHGoUfkjOb2m572hFDymo8Y/1rUs5neWQcoIDCXd5x0nzvkuFQafKfotPTnSqvLmsjuwY5RBCxHFdERUuOH/BIeKsO7OZ9zEscB8qd72PDRh6pWAQezALdEX0TdqNTU9bgjKJzQjB7zrrTPA9VFcj4gXWrhqEV2zVgyYFDxLlWn2QjLJ12/d8FPRM5XMm/EUuTS6yftNV7GioJ7R1Sl9MRws4umn10IvnO43OV0v/BV2H4Mh24+mMXQ8VbE4atpGi6fu4suecPMgNyk8ZBDZ+D7hcQHB0EJCDTMTHKayjKiMNic1wumKVaZSYLmaVN5NU0IcMoSRuAnW9nYQJD/LryXpdyD5TxCGBtxiwRUXgcldO13oDf/cjZYF9fciK0XU0EKEs0TZZfeDMpxh0S0a/kppR6YFaMMMV5pU8BAtW4nZT3Jo5uMcxagaV2sNNAeg9a/zbD3xlSgzrj5qKxIDvPq5ehRRWJmmXlmP14ZJfG0WK67HSXAIW4S7Ak1OV84Ns4QKWDaM8Ca2XSQgkLnRLtxPzyiXGJdFJm86R76Ah3xjMxZt7mNcFcBL9qMoqhYRrPtSkqUoqQbjJvPl4XKEHoCypFtOBMSJrrHK0XJimGQ3XsRquCZRm64uqPSJa32qE5B1AR1EzTUfde8fCtWU8nNCiiy8yOln+u/JEg6OsYC/M5diy79G2M1hzNxe7MvAgAUxPYlcmwEMaZmEHHikZ6gvH6N1DqkmuaY21qN95QEutoQ2tL4uGoh7tLEGlS0BStJe8mMZxT3wF5Jmigpf9anhiA1aocIu2YFbCy4k1dIai6ERRcnu6TmuEyLBnvMN3UrU5wN67MC
 elxbo3UW
 XFIb/EUqdceQCo/trRV4JbagtLm9tdCP0nWH9clx7pPqZRHd2WCHqmfX03+ITCf96QP5M9IpN1SJExZ+XA5TxCQRO5o807sch1f/P1l94/92hvQWq1Cqi59e+FCzTSM4ANadA2bwLp2HaMn5SCUPolx0xrAyQZNUy3LJ+j5b6bGEZm8HbJ4lWlAXLd+uwPqLfbQHB3k4vcnvSItCaejfXZxg8iCC0I1leLK3RhIQ7bZS5wyisvLquGLTZ84QXNGGniplCr/Qw7/mG6dH1tTWzntvJtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For applying DAMOS_STAT action to a region, DAMON virtual address space
operation set (vaddr) calls walk_page_range[_vma]() for the region.  The
pmd walk entry function, namely damon_va_stat_pmd_entry(), applies DAMOS
filters to folios of addresses of the region in the pmd.  It starts from
the walking address and advances the address by the size of the folio of
the address until it goes out of the pmd or the region.

Let's suppose it is for the first pmd of the region, and the region
start address is in the middle of a large folio.  Also, the next folios
are small.  Then, some of the next folios could be skipped.  Fix the
issue by advancing the address to exactly the start address of the next
folio.

The user impact is that the DAMOS_STAT-based page level monitoring
results become inaccurate.  Since the page level monitoring is supposed
to provide relatively high precision, this is definitely a problem.  It
is arguably not critical since it is only monitoring quality
degradation.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org

Fixes: 63f39737d1e3 ("mm/damon/vaddr: support stat-purpose DAMOS filters")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 0648400b2d65b..4b0b5edf67952 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -831,6 +831,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -844,7 +846,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 
 		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
 			*sz_filter_passed += folio_size(folio);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 		s->last_applied = folio;
 	}
 	pte_unmap_unlock(start_pte, ptl);
-- 
2.47.3

