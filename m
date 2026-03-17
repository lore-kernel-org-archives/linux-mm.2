Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A414FED9EC
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F96A6B008C; Tue, 17 Mar 2026 12:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583666B0092; Tue, 17 Mar 2026 12:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424796B0095; Tue, 17 Mar 2026 12:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23A956B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:11:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1D1713A373
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:11:03 +0000 (UTC)
X-FDA: 84556044006.15.300C600
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id D3D1E140012
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:11:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=b5eay61N
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773763862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nzuz22HJlpi5hM3GMMNGDuF/FPshFhM/ibIt8PNUdHM=;
	b=aHrNTb+vGe0tWgbbjxDEZ8zFd8qkDGSFxCkYrhMIZFmjgtYuU56S6XGm0FVlACQy04xGhb
	u+Dbrj8m8D4VWbXg0vUmGq5OoBO+O9naCDtWsZCgK5oV/rYCHHTHQk502eJpHoAQ3eqboF
	6cK0puuo3qMddw2Ew7Xn2O5Fq7D22E8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=b5eay61N;
	spf=none (imf26.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773763862; a=rsa-sha256;
	cv=none;
	b=jmBXTdKmF87K57IMHe25+7HTYno2TayVDToIX8UQHTWCbQcJuWye/SHoXMyDLZpqqsTtnn
	zPgIKJlaBXc8E7hWXcqLhGRHhqGlPtp9QSHKja3EN+U0UgEDO4hh7GBxMKYisTvVbEUrJD
	QkDL0EMtVtC9V7wAbXD7a1ZR+oJXPu8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Nzuz22HJlpi5hM3GMMNGDuF/FPshFhM/ibIt8PNUdHM=; b=b5eay61NUmMmAob36DsZbL+iTZ
	1yKb/qHzVdFH4UP8cL02l++bSWo35OlEvu4H26fErlyaH6lrNIVdK7ypxj4rNCPgAA2WL0TqPXWsk
	QJxtwgId2C8tDRmn6CgQibs4FsggS+yo6VJ1tHZqy4Dub73T4wy7rlbhnKHaOAU8iqD7IxPD5IIx9
	wTSSf8ZDoFOzkLn3zlU9+YwrdwBBvCA+zarShmQ8YWxuPj2lxlnzWz3W3a7HRTrC8GWK6JkQyUybB
	hJkxMvsLJT79+2WND/bvgvgU2cHwlCKceiCGiJcPZM9PiwkJFQbIU/cxW2lUHNzpSrEmcmTPo+/V2
	PIcTzANw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w2X0M-0030DI-MU; Tue, 17 Mar 2026 16:10:49 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 17 Mar 2026 08:33:59 -0700
Subject: [PATCH v7 4/4] mm: ratelimit min_free_kbytes adjustment messages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-thp_logs-v7-4-31eb98fa5a8b@debian.org>
References: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
In-Reply-To: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2046; i=leitao@debian.org;
 h=from:subject:message-id; bh=ve+lNwoqDQSYspSHS5OWSYYUOfQw+Gl9hm3vxR11Gs4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpuXzroH5aB8XBfzM5dWLCNGjcXcgYnmHfGDSMH
 3PTPikV4bqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabl86wAKCRA1o5Of/Hh3
 bQ7ZD/9ZwqiZ3XSJ7Pw+NydgDOfCXjfOGMORk3H+U3xVFmlgowPcozGIvatUbinks9si7c8WJWd
 +Ucth2ssTs+9xbhK0mR8ybsc5Cy6309+JNiqm74LBDfFIfGZ0lipVIAkR2Gajs2tswPyvBPx3YJ
 SMMVHwqVLki6JZgomnsspKgCBQY5sOYwZ1BdAy3Dw8XLKM1cmlexbenH2SdieiWw7WDzfJrUTrI
 kRA5AySY9vKUoM8uCDaiRIIInwKQiP3y4cI/+1UXkQ4IUPaZ7IrkfZoxBXfn/uEwarpdEN2mRbE
 9CahN7R3+gcQNIEbK5ln0njHGVK1AYqTsTvae7DJTktWX3VI6asrUOzsZXt455bsQvCc671tIZV
 23OFigoFASibsguFSG0JJHDPnYuuBbKKr/j6XskJd4hr0yo4UzzLHPq/zNmLQ7j8mXifLt0zR1k
 vej9TWsFiEtCvBMFAwOYZgDaejpckfZEpw/hpeg6EItdNOLol1sIdAz/5GZG7yfKeROiKonmec6
 qC9GTp4zKPgcLYKTFO0JI8eG7BAuKih7eSGMOpubX2KZ59+WGSmRVI1CZgC/veHdbwi54D5lnT5
 aPhd/YUVvMcwkM47s6POfyWO5k0SrsALvDtOXb0d9z3D4c9zq7SRDRYI2CWq84K52rAZGMB7Bt+
 Jy1k4o/zDV3pEzg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: D3D1E140012
X-Stat-Signature: 5fdm5i8zwj5m6ctjrbd8gic54y3pmwrx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773763861-819681
X-HE-Meta: U2FsdGVkX190k3fSRhfnrkvWJx775ss7efSxdKcky6wbx8kLS46BncikDpCG6BFAnrncNv8fhEq4Da+WozDJ2ko0paFxTgazh3iy8mnRT4UJWTC6l8xBpowSLn4ORSamXdpO4whV+DhaghTMLt9S8RkOvEQkYhlQS9inym47tQQIi7sOro7waV+Hflxh8hH+dEMvtQjp8y4rwe5sZ2eTHgRGIOSzivbT0yebzl5ZTi/jBYMeOyVAn9rSUmUY6EjiFKlpIiTA5fYp1rJfUe+uuMhMsNhsPFZaqYFxMAN005UTii3UYRLkWp8dvfMuk724f6O/L2b2QFAZzNj7I+eaoDj21aDH99gIVIT2UYZpDdskETJT8PHv9yGeZlD3SvDxw1EzN8b4NenoZ4CLG5LctBju72gfn0217zRq8SFWD4OGotqk71y3aVKR/N1Eb22byUtbvUsqxpSTHzt9Io9MQmpMk3xxuVN3E3c8F6TjerhtDoNDgCtp2KVp3IJUs89oB8CjWAUbA4wV1uYbGMEfhxXu9gxGcdlCtA6xYBs7E2baTPUmM1moPEXw+nyhfHWI6VGu1uP3YLBrxfL1elr7CjZgkHeWpXdysNb2xaEU7nxVfq4c1M7otEZBCVBD7wdSEldkm5l7G/1ginlh4KJYDgnsRQgwa93yCXNl1jv/KbJap9fqgtG/BDCS+AoHgM4+15+G45nJis0Xk/CfhxUtfaCoYzvPypvx9dfavFHidXQBnySsSZjaKH1ywnJQsPgNZJ9dq6MVzUodMTiWZwsGu/Fm2eL6YPtNgOCDHruYbRUD1qB1o1T3yGF6VCTBoO8KYpnLp2yoiK9bF2G4FWL1lbCX6H5X63LS3BJjjtfMoZqR3cpCW7sKvqXwFVgy/EM75bkCWYJTxbUF4YVZXz/JlPigQutZcWf9mZF3dy5UUd3AiQjHL4hU5bi/0JXRlD892EEi6kx3cZaQXuTQMem
 ZcQgVgHV
 pEs1ao7pxZzQGWS+bOJwr8GSpZ4uN0xFtVtqE81DhOPakTrCfX6aLiF8rNLvWrePO9Gb7aaoVqSMd/n2PDa2uoy1TqWuGJVX4NqCCjFBa35or6mL9jyPjKXCM0KFy1UMCYAd8v2bC+HY9+pNSerX9kzfOUYTgqlXoWvhCRsHpCrIcMQSgU+y5j6kCaKF82nSi8uXqmyUxPv2QN8aKoIyTX6fZvxdZDB4Q1zf5WA5TmmCHl3DrPHt5yS31MHecqlkA1JZr6kRLLmxCYTofzkFDP5oecw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "raising min_free_kbytes" pr_info message in
set_recommended_min_free_kbytes() and the "min_free_kbytes is not
updated to" pr_warn in calculate_min_free_kbytes() can spam the
kernel log when called repeatedly.

Switch the pr_info in set_recommended_min_free_kbytes() and the
pr_warn in calculate_min_free_kbytes() to their _ratelimited variants
to prevent the log spam for this message.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/khugepaged.c | 4 ++--
 mm/page_alloc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 56a41c21b44c9..d44d463ccfd3e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2671,8 +2671,8 @@ void set_recommended_min_free_kbytes(void)
 
 	if (recommended_min > min_free_kbytes) {
 		if (user_min_free_kbytes >= 0)
-			pr_info("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
-				min_free_kbytes, recommended_min);
+			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
+					    min_free_kbytes, recommended_min);
 
 		min_free_kbytes = recommended_min;
 	}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554ed..c840c886807bf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6553,8 +6553,8 @@ void calculate_min_free_kbytes(void)
 	if (new_min_free_kbytes > user_min_free_kbytes)
 		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
 	else
-		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
-				new_min_free_kbytes, user_min_free_kbytes);
+		pr_warn_ratelimited("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
+				    new_min_free_kbytes, user_min_free_kbytes);
 
 }
 

-- 
2.52.0


