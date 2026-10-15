Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F105CC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 02:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F6F6B008A; Wed, 14 Oct 2026 22:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877046B008C; Wed, 14 Oct 2026 22:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C756B0092; Wed, 14 Oct 2026 22:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9796B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:53:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF3E840804
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:53:50 +0000 (UTC)
X-FDA: 85323340620.02.B3361AC
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 03286140006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:53:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CLZOMKnK;
	spf=pass (imf26.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=skunkolee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792032829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0jwQSa7/KFwBhQ0eU8j/tY9IdNhu+VSiabnKKJdx54=;
	b=03r7K8pl/dVOyJbn5kcUFmW4/kMn75WA2JWAxE4CExO4dVcyAfakC7wezBVSPk190+4VXh
	VqxH9VVp5Mz6rUnTx4DM+OWc+AbzK/OIT+3vPoIkVCegFl/UnDWx9BaPYTTTgIC4YSE5a/
	+icIFBI2kMgrrrTWH1PNiDyltWrWbeU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792032829;
	b=EpW8J7V3MSuK2AH/kIDPDNn0X7DoTNq/4p006ThR1NHSSoJU3gPRpfntLSLLvNvFgp/E5k
	RqCtmWohEsp9sRLNj0EB00Qu5HKI74CPhXRQNx7zJL4MBHIH+5wQY545jB4sQLzgc5hPaL
	jan3GTwT6Q/VKhAxicDlkS8undrMVMg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CLZOMKnK;
	spf=pass (imf26.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=skunkolee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-89d6bd67045so1172832b3a.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792032828; x=1792637628; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X0jwQSa7/KFwBhQ0eU8j/tY9IdNhu+VSiabnKKJdx54=;
        b=CLZOMKnKk0jYTAEUqBvADtLlc4Euh6d9ReEUe+dJfwlIRbWKpJEvNKw11OCgZtK/vR
         1wBuxafppq1HLyYC2JlOE7Dq17ZMULyFMH+dY/21CmB5oMUZuCGKbwq1edfUIJydzj+V
         gai1wgs4oNXysuSSs1i7XN9moK7oJbugr7NF640pOy7ZG9hk2tXLh9zL9AO5gh8MtFhr
         P7vvUxDCpAbf7eRVMfnymrdb4FgW0niXWSvPkRsKrtnymq9nz8D8EDQWCO1a0pCk2NHP
         Fk60oOM66ByOmFZ0hQ/al7qLLRvGk8SvAfjnhp1ifS6n2O1Rqe4c6Nmtzoxeqz4ZagU2
         WQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792032828; x=1792637628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X0jwQSa7/KFwBhQ0eU8j/tY9IdNhu+VSiabnKKJdx54=;
        b=J3GkvSXlXaRXGg/AQjebYdP6gOgfQke0bu6alEG0wEK24KYb/F9p1yZzIoiidfJM9s
         gUODN72NkaieX9Ctpbz5Emk03DSFWBK03rfBv8v6Yh5nUJq7GT6Dz3+c1WtpQgaHSKgE
         p+MBYYo3Yn0tjLrvbk4qhkbZMeYFNbgc0LgI/O0A9IdLpGjElZSF5LHuAw1aljNRAbjT
         ahS6wqa2pokm7DLECgdoqUG2NPrzIN0cR+bOo1CoiFU55HmjRx/0dbccySmQBUA3BQ6+
         ShFCwekDMYjDPT0EhlHNoP88KZnLIycoUJnVjExGO+tWQmZB2hyxLi3OLYjSBa/hdymE
         vZyw==
X-Forwarded-Encrypted: i=1; AKwUvBwk2pq7taYQi3N5qt8iKiB+vf7QNMNv2SY6rcuJmAfWAgkZRzBXpUorEK+zDB6BfruQtcGbTsuTlA==@kvack.org
X-Gm-Message-State: AFq9FYK4EMQGJJA5KZlm3OSCaa6Zl051IOCmH4xdBTq97JzPA93MJEpG
	tNIVAAGJTcOmBErgTe17lelaRk526YaL2B0FBaJqePgzG5L2ZKuxpmEu
X-Gm-Gg: AYBFou3qvWSdg4r0znCKMp5rZtdJ2Rp/lCYrN7bDlWIco0l8YsVCWgMi/q+Grp5nz9I
	lbFiUoxtrgdJD1h+bUFWDHmWAgChzIEeYH/R0sQwFUIK/P1pmMNkLjIu0G9HLi4OIgYAiBJmOBL
	jQr3ojmQsWxAZO9DFrMiwuWPSHxxAiBcFyhTxftUk16WsRwH/lJmPnPM+zY/zMPPWKH/93y0Hiy
	u6l8WVG6Om0vhC9cgdxqyv87u3LBn1l5AuKXWBjor8miORpcDeaKrVGMvKvoP84t/k1GyCThEn0
	xJqR760HaApYUwmNCR2hds5hTcWUg6Ti20vzO9qaeFnH9ZLonAzxTDl3QBJzi5PRwuEAWHL4UOS
	BCK3kUHlvLKPp/9YKZuQbf3/etu9QLJPNrY6l0ehZaU9b56GrmDTrJdE0bgWJDCgDbzVLPxZwRK
	cpMeNyVxzTmaWBDfGemnXyDQJlAjMWsUR9cW5+WkKfO/QoNL5YGBliAAGTBUurMJ+1cs5Lg7ASc
	im0JlBIcB0qbTPx+gHU4M4jWiksguLNoGesb2HM4iDBBrtRebFOMn9N+kT2Ckcv
X-Received: by 2002:a05:6a00:c4c6:b0:88b:7e32:d91 with SMTP id d2e1a72fcca58-897d316cdbfmr7112036b3a.6.1792032827798;
        Wed, 14 Oct 2026 19:53:47 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::a891])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89d802d10besm1706735b3a.28.2026.10.14.19.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:53:47 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	fvdl@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/cma: fix list_insert_sorted() ordering
Date: Wed, 14 Oct 2026 20:53:40 -0600
Message-ID: <55118c45ec8251d7be2eaab87d9c0af4b8513161.1792032699.git.skunkolee@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792032699.git.skunkolee@gmail.com>
References: <cover.1792032699.git.skunkolee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03286140006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: y6mw17czmo6157wssotx7p796fi5jqs3
X-HE-Tag: 1792032828-913469
X-HE-Meta: U2FsdGVkX1/VMyzDBDubN+UBGCtyRKRDQ2FPsyXOag5DoB00BSjuYMNhKENagOeMiQn5/2etPiJgGHhEvc0f97pdz85rVP1xJ3DmxvOzC6aqPl1SV9eF/EOfgTIIs8tyliT4hVWYpvcigz7J/tJHZM4WbDFHE068MQH1q/M20Aix5kMTY8djcH47cSYGZw3ZcIOlQDipx4bBVpGzSixYU6aWehMS1L4gSkAKB4K6gC7ati4YgYUggDHWopaO4AfqjAXSp11n+56OB+eFEpP77nH8aij9eyWD6aI/UdFUadAnr6TlrPuNiaobrk/R7ZYiHeyVFVCo44AgKIHJTkt66La//j0Pu4gwjBX9b1VGibYZcv4oukzB3vfDG6kCwfCIRckqV8XkW2IVJutXI6R5ROl20hWmKuHO70GEeTVleF9VF/WR1oAwvzJXdrKR2inC4m+RJiPwiprANYPf/Lel3VpFQX443BsnicMCtxuXMmvsHhJFRX9hic/qDSfLsK4/W2FuzMakK7CC3ReQFxwRlr4LT7m06JW5tpdK67iNa/pzB1U3kamirAvRODiO0OKFCHA5pmRIV4oIuP3bDwF1DdWyXGI+cyhKVZN2lSPu93eAJ8PnREfJBDQFp9VrJCdYlKy2AHDHS1MMUst23j7HqBB10n+2e5GRepz5773GM64cov8ChZ3GRs82fvaipRmhewamkVwTwbSsxgxU5GxafMdPoi3JxJ79lkZrE0MgDo8ZSt9vm5Nte2zyih5ntfmeIniQhO7GPgaorBM+VwXtTW2z18mzXeqCvfA7B3zOcFVTfs0EtbIVCufO0+AjLvqbv2AfJbNUozEHIwxjZQV0LjatVrB9cNt1LaJnb9+7YV7ABKq1Qtfc0GBYG0OSd1MX+jfU3lP2+wb8EI2eqtiNSOUM4V4MXLQho3XInfGbS/sLXfFFr6vvinObfkwbMFZ+E7l+IK72V+G9/XuF2TN
 oPiPE/CI
 ZS6pAh60mUHdgq3dMVRfeMrorzs7IX9KSHvDF5PnDAxp/PknubCG37R6hsU6Gg/tdQjW5O33GWdzrY/aVpRh13WtTz/8ENEUNUVpMWZL8ZCvbBh8+BlcMoBTeeuf50X019aAfol57ubl+PZ2/M0enRhcBv6CSYao6hgu/EiTTeVHegMxq3h7sfGUUYKglyFJS6pz+eiF1+WpIoqXruiU+8+d4IWLDEpK9+6+KEHQxNhqxxF2dX3aT+rJXjEdgXUVwxqo/K44/nf70frOqnKYIvaVfIjTZgRNx33jmtDAL6CU7ZgiaIcK8aer17J9DtaeBmJTvQBBsQzoJGpV4P0+NUdbxV4tG38IWsdr30Sibm8WC6oeOYhOzNbEndCWYG4xvVlyHQq407nNOOyswhH/UrfYfdambil2p09S7HAYRTtI/aG8NYs+iQP6xDc8xdnso7Fhgix/ukJ1dJ1qNTO8cMKz+X586D7FHip31XZfyxMbR2qvifPAxXriwsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cma_declare_contiguous_multi() uses list_insert_sorted() to keep its
candidate ranges sorted by size, largest first (revsizecmp()), and by
base address, lowest first (basecmp()). Both comparators return true
when the first argument sorts before the second.

The helper stops at the first existing entry for which cmp(entry, new)
is true and inserts the new range before it, which is the reverse of
what is needed. If no entry matches, mlp is left pointing at the last
entry and the new range is inserted before it instead of being
appended. With revsizecmp(), inserting sizes 1 2 3 4 yields 2 3 4 1
and inserting 4 3 2 1 yields 1 2 3 4. The first range inserted stays
at the tail until it is evicted.

The caller relies on list_last_entry() being the smallest recorded
range when deciding whether to skip or replace a candidate, and on
walking the list largest first when picking the final ranges. With the
list misordered, a candidate larger than some recorded ranges can be
skipped because it is smaller than the first range found, so the
function can fail or reserve less than requested where a valid layout
exists. For example, free ranges of 4G, 7 x 1G and 2G, in address
order, with a request of 12G: the 2G range is dropped instead of
replacing a 1G one.

Insert before the first entry the new range sorts before, and append
when there is none.

Found by code inspection with the help of an LLM. No kernel-level
reproducer was produced and this was not tested on hardware or in a
booted kernel. The example above comes from a userspace copy of the
helper and the selection loop, written from the source.

Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Cc: <stable@vger.kernel.org> # 6.15+
Assisted-by: LLM
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
 mm/cma.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index a10ea37a261d..527b2d894f3e 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -348,16 +348,12 @@ static void __init list_insert_sorted(
 	struct list_head *mp;
 	struct cma_init_memrange *mlp;
 
-	if (list_empty(ranges))
-		list_add(&mrp->list, ranges);
-	else {
-		list_for_each(mp, ranges) {
-			mlp = list_entry(mp, struct cma_init_memrange, list);
-			if (cmp(mlp, mrp))
-				break;
-		}
-		__list_add(&mrp->list, mlp->list.prev, &mlp->list);
+	list_for_each(mp, ranges) {
+		mlp = list_entry(mp, struct cma_init_memrange, list);
+		if (cmp(mrp, mlp))
+			break;
 	}
+	list_add_tail(&mrp->list, mp);
 }
 
 static int __init cma_fixed_reserve(phys_addr_t base, phys_addr_t size)
-- 
2.56.0


