Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B41D3C4450A
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 18:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A16D6B007B; Sat, 18 Jul 2026 14:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351296B0088; Sat, 18 Jul 2026 14:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2674B6B008A; Sat, 18 Jul 2026 14:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA6796B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:01:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65C32A0AF1
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 18:01:43 +0000 (UTC)
X-FDA: 85002665286.26.B3B3CB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E6B2C80009
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 18:01:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QiceMZQP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784397701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2IbAUH8vvEqTVq3Kv7LkPD2EJ8inp4L5kOOT6/GvUrE=;
	b=reepVagyCK4rQB/3ffEhrV6aoVNLhJMeJe+K7WX9ySIYWUhIeejVwag5lV6E+ZD1mgYdbk
	3HYsvoBy/ySe5jfd838R4hwV2K/7LCMdkE5wyEr9vn9M0nfU0bhB2aIJNU3EHkoWkc5lOD
	sUAxryGXOlY/CB3LRaH4XOfv0Ma1nzU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QiceMZQP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784397701;
	b=yfeyFg6Dph1zP1GeFynAKvU+9RiM3kfeDPe6NZVlTbxQs0IQIZ6YliS0pQgKqJxCPbSauy
	Q5AyBQtmcWKhUW9jQt4rBiRu+1yIxnc1SP0fuZfq4gGhR9fe0a6VNqbb/0EyfssE0X6i9V
	svHr7RaogyHbp9vmQq30kXwoXcsBHDg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 394B960018;
	Sat, 18 Jul 2026 18:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B84B1F000E9;
	Sat, 18 Jul 2026 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784397700;
	bh=2IbAUH8vvEqTVq3Kv7LkPD2EJ8inp4L5kOOT6/GvUrE=;
	h=From:To:Cc:Subject:Date;
	b=QiceMZQPi9XoLF95Aj9MzE0I9PycT+95RnRuaYLQzb+nVf9k9Xy/MJ8iZjJ4mUuA+
	 5LDAo3/7kkrubpepXObYOlvKOgRGZ6Uq/RIuNDm3p4q+s6A7sABfqYzIIOp557Ggsu
	 UZKKDRVM7KwNz5J228ffT8BToaEng4gvbgmtyMEJExXGHfwKsnuAGbgNGDIIXsEtZC
	 BeoSzHmCdISCvrDaueuGc+Ntiq2TtN4GlC668ez/hu1tYkfZf9F+kTDVz5ypIia85q
	 1vV3Dn2XqiFdqz6gGJzW+YuoQtPX53t+pTzb8wfTUPRkCCFf4ZUoFic+5Jyoqt8fWD
	 3OmPHdRfUSTpg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/ops-common: use nr_accesses moving sum for quota score
Date: Sat, 18 Jul 2026 11:01:18 -0700
Message-ID: <20260718180121.94759-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E6B2C80009
X-Stat-Signature: jestpq49z3d4fokkb6gxrydrrspd4ic7
X-HE-Tag: 1784397701-577049
X-HE-Meta: U2FsdGVkX1/5PBjJOK2y+w1g6269CJ3NuuRecrAGYQtrUeKOvybQ/b2Fq8iL+u08tC+9jjRuEXuzX/AhGXsGaZ9jzHSaB4bonBKGf4RtrNVmcVTJnDB/4zQoayA0rcBcEumgm7Nl91n2qqdW723c41/CsVycsSLRLeKbpoZsf50PCrHWhxJ9j9UBLOhuf6RhJzSFyoU4ItnCl/LSv7aqcgS5E/XT0RQmHGE+k4krhVCDTdbnjsqHX5F9QYV3md+Eh3JJaS+JX/tK4+zh1P5j/iSMCR4yJ1O3YIY30O4bkwGq3/LVH8fe5FWmn+zYrzCK0esyMx1CeTugzCJYURg35z7qCN2S43dWLoRFm6rnUl0Cz7HIFn8fiCont8X4ys/sD79ut3gY69KFuLTg/mZx8qAD3FozdYBUIE/3RWIWqRsUKNQ/HeHsPPZVdXonvcZ8BsUsuUKYWyUiiu6DsLwMCKqTXwBDsaPC0aRmOpa/ewAuIGsY1GRYri6LNkJotBoFK/+NUTtj3GdyOv+kcce/b/1Crd0NrAYEMAgDkgKYMTpFFcKSXpvUcXxOkWy4pbUUOcZaB1YUpj3/Gjnrnc1cxZ9QAucmTyDzus5On2z89Nzm+B1iSNhke0lgZyc82uOE6shU/kJgQoTXGzUZTrc5pnz8AmevXqXK5yUH//Nf9u5R3DgzJgihR3SZAqGLES7EWL7GoNKj1zVfd0UAzk3BG9Z2LXNGE5G4M1KVdbgrBe3yjVVFVhIIJYfHhKZXPe8VISJA0dfGEhKyUGP/qRRH5VzyjOOsV22BudEt+6PAPqCs1rz6SjiSWGXjuzFYvL0wbuLkKn7mMIon+l4JVfhFE5/I1pejSgH2PJmGJPVVYHR/ODDBoFOFZem9TmABMUfMrId0NBhpgZJXmkIhamV/YWt6lIeZ41gLiD02ETKfEt1jXNE9N10qDKadVoIAbrsVvvqfj8AF/grfqeELPf+
 3wI4Tg11
 gb3gG3HuUGQXg8aM94HcJOhvV7SLGe8zaJkf+cEfKMuaEvDtT4oVhgVFauVrkNlOyuzFgjbCFGgb3eV5eRT+k97RQZf9/HvtOuFhBRaajwSN6AS4cplzpMbLJVETFzxwLLO8SM7TNyXJ9fhdXV2P5G2NRrfeS2Zx4kCAhgCWeUcUN3r1DsmzNJiFN+A+/Ldk0ONqXYM14Q1vx6ft92A45fK3juKn7Q9gSez0CYLjS8EAj4QPxoEyCRzd7UgfA3lK5zUpQvBhDpghUMXVTiL2pyhqvog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 42f994b71404 ("mm/damon/core: implement scheme-specific
apply interval"), DAMOS scheme can be applied at any time.  At that
time, nr_accesses may not be fully aggregated.  But the quota
prioritization score is calculated using the not fully aggregated count.
As a result, the performance of DAMOS could be degraded.  Fix by using
damon_nr_accesses_mvsum() instead.

The user impact is suboptimum DAMOS performance under certain setups.
The issue was there from the beginning of the setup availability.  Hence
it was the baseline for the setup.  Probably that's why people didn't
notice the suboptimality so far.

Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Cc: <stable@vger.kernel.org> # 6.7.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Given the user impact, this is not an urgent hotfix in my opinion.  This
is rather a good improvement that is better to eventually be merged into
stable kernels, though.

 mm/damon/ops-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index de9a104e88321..e59f77eca83b2 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -111,8 +111,9 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	unsigned int age_weight = s->quota.weight_age;
 	int hotness;
 
-	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
-		damon_nr_samples_per_aggr(&c->attrs);
+	freq_subscore = mult_frac(damon_nr_accesses_mvsum(r, c),
+			DAMON_MAX_SUBSCORE,
+			damon_nr_samples_per_aggr(&c->attrs));
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	if (age_in_sec)

base-commit: 6f1af14da2daf85f73375ffcabcf82255970e2b5
-- 
2.47.3

