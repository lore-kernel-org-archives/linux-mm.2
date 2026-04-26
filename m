Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FBEFF8862
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 23:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896DE6B008C; Sun, 26 Apr 2026 19:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F366B0092; Sun, 26 Apr 2026 19:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A396B0093; Sun, 26 Apr 2026 19:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 345C76B008C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:16:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45E6D1A0660
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:16:32 +0000 (UTC)
X-FDA: 84702268224.28.BD8CE31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A28FB80008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:16:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dknh61j3;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777245390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uGPHKFWK+ttxdFOHdSTqQ0bxRteWejt8tiN3ptKLKIs=;
	b=YJDAroNOrj3XZPdsLijz/wA29bhM6DcaWUWx9Eq02lm2hqbpb7LmwC1AaFtsbx4nLlz6DE
	/4DuKTri/+Vx4ZtgxEEgRi6fpbMV4eXezSRGAWFx0PpC7VAzxffnu3e22CLmFJpJW2K6Ow
	RN5QmV89ADRA7QdSW5byG9X5rF1kIJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777245390; a=rsa-sha256;
	cv=none;
	b=cWNHPcH+A6/YbuiNucXa6Q+kty+6f6Jk+Vr2I82hWgNDI8x1K4kEuXzjKY+n1kWgkh9TfF
	XAGX6t6QLSAURyqcuyXKug7QZOrVwGo5FqFT9y1FtotIYNgaj/nJIzGxedQkmXsCuOAHuD
	X6/b6lWyXyttkslhZoilQCurcmmVACc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dknh61j3;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2663360154;
	Sun, 26 Apr 2026 23:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B893C2BCAF;
	Sun, 26 Apr 2026 23:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777245389;
	bh=+A1Q9/vaJ9DZib9IiWJOGNTEVd+yWzZrZB7cjC5LjW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dknh61j3XU4h0Xyj+9G0SVVqUrsb9CIH7gsKngAvzMnrOWWDQnAwuPrKuGmP/94nl
	 I9zX28PkLWQO3+RHgrz6pRwjJp5smXBnaU01J/bIN8rr1iknaxT7TuDSGEdORE2Y0V
	 7fVsB7BPCJUSrpy0p0wmnwj4uyuesgi+gR1TwS1GdDIWhJd6jDOJfVqN1UcSnPR0ac
	 lSOg9lRR+OIZk26UmKu4jeSYBIBuF5c8NdfWNa5cdbBS084+QcrPv1sllgdZy8dTnY
	 J9WBN0yH4MHNN9k/0XYSJp5tl/by0yrhBB7g/ki8/0xjHzdzSXN+zkWoVrvfHzQQ/W
	 +I2M6qYF7sa2A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cheng-Han Wu <hank20010209@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/4] Docs/admin-guide/mm/damon: fix 'parametrs' typo
Date: Sun, 26 Apr 2026 16:16:15 -0700
Message-ID: <20260426231619.107231-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426231619.107231-1-sj@kernel.org>
References: <20260426231619.107231-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A28FB80008
X-Stat-Signature: oc4n8bgq6pgtzdi6wy9p13mioc35i596
X-Rspam-User: 
X-HE-Tag: 1777245390-469516
X-HE-Meta: U2FsdGVkX18gZe1tMFtNnWxpIRzGQ11r/wXKpt5GaC+qFNW8NbxtC6/mE8uiHriWoRYUmn1R8cGIqrvvw4QxDEMPPCfQ1sTomejrMwOaZ6MW12WFr8lzBtl+sF3JItYMZ+9I0VJhsfGwpNVq5qyD9p1PvuRnAjVLuWK2KTy2vCJkgSfhC6UAT237T7ndoTVvb7vLJCBtVV8nQ+NS92INBFn06aBiiXRLhIMLbx9DUSFmPRmVmWl1awcqpH5TeL5B2iLf65czMW68F88jxWl/L+YWryFvfMPePoe4Xpx89q1FsTRBCgOKjcnO+hsEdN4cHIkgGdVVMPyJlKFNNdo1ViNZW02MMnmIMuWvO5GMOBKmFw3GaG9dayqrhMzQI8fWG2S+ug1J0uretFkdR3AG0f9Pxr9aKFtozbbExhSTKO2XUkczo4PPMuLkxXZimtXAwgOyUN1HVCMi5/3fYCbDX5kYKMhAWPN9CUw+t/CBggtC/8EhMT0swMKBXyrslC0pCf4uFxxf3mK4rd6N0yMBmjHpHqo1VayQ3+l6XMp2d132AGzCgZMwQJkhrSG36eD1PKa+e5YWFXVqEoripX2oRxQasnFQa0CBpFdXJDTJexTbzBYKyM2fGnWksffkJ+WQ3lPSakeiSwvupGwnIbSaSM+8UpnnCDoGPkYoMHR0apmHydkGAW2hemcqlYRUfratiRuy8GtR8FDxAl4LJOmZQHZpjqnvRElHh3qmVRDV3J6/7m43LcH8rVaZekiMOsDvdHDxayiBnjko/rsEBIeO0PmG4fIYBdRmVS8SQ8jxQRjShHFFfAtoXuw0aULC237qlgeIkkr3jvmLX1s9Z4Hi9DhNdOCmQgOVA/u1GWTlyrVe0I8rLQ2slm+2aGhRsPB/WrQ5DtYJSTU393Ccn1RE0efiquSr2BhcQKxOZEbfYoHnEFdUoPxhDJzaE+1sKtOBDAh8ycd636513dSk/Sy
 x0gPz1pL
 bC/WjJGVRXhwiLlypTvfOVWY2JE+d3ryW0P9cSOHNZ8KiQ3sBmLBytRez4BoSrtr4Qi/XiCeCEWMWs5toKedIxqjnbs265qP1zABxhit7KIDaFua2C5VO9KUyRTU3My805phuU+pJGaIzksK37JoFFdQRbBNFCOyJhou43CdToLiZKMVzte3sJ5wQbbwFminUeva7Kvx/mEKyQS2FNJqTHacThy3ynNjnwCxvqo6viC0lwNhZ0komzrt3W8RfGPPX6sMW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cheng-Han Wu <hank20010209@gmail.com>

Fix the misspelling of "parametrs" as "parameters" in
reclaim.rst and lru_sort.rst.

Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
(https://lore.kernel.org/20260324144851.12883-1-hank20010209@gmail.com)
- Rebase to latest mm-new.

 Documentation/admin-guide/mm/damon/lru_sort.rst | 2 +-
 Documentation/admin-guide/mm/damon/reclaim.rst  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 14cc6b2db8973..25e2f042a383f 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -75,7 +75,7 @@ Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_LRU_SORT is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index d7a0225b49508..01a34c215b66f 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -67,7 +67,7 @@ Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_RECLAIM is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
-- 
2.47.3

