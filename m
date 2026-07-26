Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A802C531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105376B0088; Sun, 26 Jul 2026 13:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0671E6B0095; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF676B0088; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB2816B008A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23EC412056D
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
X-FDA: 85031640414.15.7A532B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 727FC140003
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWrEly58;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZDCgXboPWDjpqLBgpT6yf0F7vtlbLEb3w3NI8ROd0U=;
	b=JxX9EYqbfjGrkv7v+aFpRshHLYsw5+4tOp106AFZ9GKpFylGsMJJPsHt7qEadEHtKJzL+x
	8h5vi32L7GiPy1scIOHVMHXQ+yLT+zBm5Yfav3ZO6T5HrEVuf0UG/+GaUUquAuS0rKcuig
	pxLvK8bzOoJIZ7sGQ3/QotlD8eBvpWA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWrEly58;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087585;
	b=OzSOtAqXr0BgmVkUKQ41z2fE4dsUptQ1Vc/y6WzbPTV1JtirObAWH7Yj5surZJwkK9zbIU
	RCH6RKomimdJCl4EPg0h232q8+idKi+HNu+7TIRTNA94NSLz+T+H7wT+AbUV9chBFh/4L0
	xQWKRlnjR40gv1Se5Yw/tFKICM+DpWE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8981F43FDF
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE541F00ACF;
	Sun, 26 Jul 2026 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087584;
	bh=GZDCgXboPWDjpqLBgpT6yf0F7vtlbLEb3w3NI8ROd0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWrEly58rKaHpWNIwKG6oHI0iMSBdjKmcvQ7s2AO2mgAT2VPnt2aRsdPZ06XJ9ZTO
	 dfZ9wlvzM6m161Q2rKE5nDFk/9GMRVDmRn6TA4l9H4qkrMpVmcjTfM6PGtVDBgeMFK
	 Q7lVEVWyJG0JHFPsBak0pAnGnrG3l+ewup7lmZOWAW0nNDoxF3BsVNobl3YpX0wAkP
	 z5blZPRWmTHaPJhZJWoJWHEyDXJTr+eQO6yZrslUUHPgoU24ts5U7sLOrX9ZTJMd/j
	 CD/Vj3doqmcYVvBtqX1tCQGn6CH1cCn+lZG+IODny99luBvDhFiTSeHYVLuSQSbtRU
	 ObHfM+KZwuHCA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 01/17] mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
Date: Sun, 26 Jul 2026 10:39:17 -0700
Message-ID: <20260726173935.94046-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 727FC140003
X-Rspamd-Server: rspam01
X-Stat-Signature: 7dbodoc8dzs9d7aixa69trs61pzqhwx1
X-HE-Tag: 1785087585-322565
X-HE-Meta: U2FsdGVkX18O7I+upXmYonzNbv5JjdtQ1I1IL3Fap/nhr4WXnrt6eg6tZw8fxzEe9Q+ujWOzJF6y9msiqXgPWX63Pblzf9v/ht9johz961YuvJbk3fRaH2dBj9OXUgcqm6Tc71cZbUZ5qBcief8kjGhuf136wGlVnwtLoQruepDH75Y0/aWS3uLEPClR5UFsNzLwiQDukPt89qBO+zNtih/9Ys08GWsV66pMOKCJ0/obmM9Jnoo20JOK61dCKBhpN4Yx3E96AbW9zww8RbezfpkLFoNfIj2OJ+1K1KNpTh8xAeyMPOWJ6x/v4PtYIVl/wJiyHesO9Fz2CbAH3qPPY/RTMLuX5bYFTfG8sWrhhIq1pEV9TMq0wfclRMBdXGOAOpCNVgYH4m/4tn4m3DSlIz0ESHI2F+FNy5xiiyA+N1ZLTn2BTDvyth1AiL/Yaa/6tOfuDIO9ZspbtK3tSLIr4Igtwht6NibHy9cW3h2rVMSTC5T3U+/OV/+3XvTZR4nVDoQByTooWqJg7FfIghYzNYR4QPEwVnr9VTR+LhdS5CEtCsIUVoMcLuot/uRvC9vsNlfe9pe3ORkL00Oa1mFyfOFovHjId4moBymq/dLpkDaCGBz9cnmy+vVEv4wh78ikiGWVdxQTYhr156WEqZaGCvtJM1SMTWiMMQ7ONU76WusxdxTzEHt0Py3fHRF/vI3JFEJV7i5pNn8WF7TCCfyClAFvxm+ALWhXKiiFrcoalSW323zYgvQMS3UKlj7Sz7XdY8WjbaWvUiuFtM2gHOAq7yfGR6FfOoGmiGa+xklWz22HycFSIC4UNEKgE6RLl01zMGH1skXrWLb2QO9Sgo7wfc/ZEoWHt7oerzXERnIfQeh9ypp6ogbNDzFuIrpDjZyu5Ejwgr7YOotokRDVSQs/lJdo3njHcfyp1c3BS1/Hnsbe370kpZmAOov4vm9OBsTQHaDEWi0Yqz5HDnzMfjN
 incknRcK
 a94IDFSQ08zqcEq2ZoqU6yRw9PskxDA2xo2jyEMVlUslI3mkpphJXqm8Ib4pngmiJXMpvVka4m7QcoSBQ0geNZVMKVaAF4J5Nkhhffly924RCoeDBwWL0+tRnN9wR5o0KDGlzKHZf5/QD/AtVYKcCxd8CziVl+AO1spy5w0QdxXjAKEpdtBztVucOg8qRL7pykojNqs94mDVXsvfvoyXiVarzU0h2QKO7J4wT46I1MZgXJejoYQZOGMLWC/+TmgDKdOIOc1W5BYg8TtYmyQi9Mi+bFrk6hvrwTScAtqAufxKGHP0/WJPFM9zVHvIsih0QNbSvwGXcectZajloByAxY+zwwAEJg98+s1We
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON filter type, pgidle_unset.  It will match pages
that have their PG_Idle flag unset, or the page table accessed bit set.
In other words, it says if the page is accessed.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 8ad6ef2e063de..cee4b74761081 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -744,12 +744,14 @@ struct damon_intervals_goal {
 /**
  * enum damon_filter_type - Type of &struct damon_filter
  *
- * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
- * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
+	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 };
 
 /**
-- 
2.47.3

