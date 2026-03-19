Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99774109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC4B6B053C; Thu, 19 Mar 2026 12:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D1F6B053E; Thu, 19 Mar 2026 12:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87D86B053F; Thu, 19 Mar 2026 12:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA9FD6B053C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:16:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B44213B4DA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:16:38 +0000 (UTC)
X-FDA: 84563315676.19.8959D3A
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3F37F180002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:16:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=DdSdJfUj;
	spf=pass (imf24.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dPrb+TYBDZVJbSRBjlvAnKVUGBeTBCp2VVxNmhYsqJ4=;
	b=2i9QMeJapJo8HriubS9p6FWwESvqA+/sIFboypq4aT70Y0hUQ/mccJd1/KuWqZZexLidrr
	uzQ+SDsxwbkQSRFpf1cNsslkxjyyaTQ0eQBf7bZGYwxoGXib+UUhmA1laW+xFDdBL5AUUp
	DCSzgTlsoUMBcC1vqq6EyAtRDlCChVc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773936996; a=rsa-sha256;
	cv=pass;
	b=8KRdnjRqQIuWS0s6BYWdI+f0FEz1P0vqha+ODLYnZ/RiATnZNobdSX2Uv1hIVNgIfKgkIR
	ORoDb8iwSAqcz/Ykk3off8OyDSKu3EYIt1gsk1SrZ0PTi/30wtveWvIkz/RuKEv5xrOOE/
	gKSJJX2os3JIRAKlirr/BjoB/Xxa/OY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=DdSdJfUj;
	spf=pass (imf24.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1773936985; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=amV9TiO2C9jeq2Cl0PtgI/iq6nSi8Ohbslo40WW1g+U9EsqsnklPGiq75D9NoCmoa3iliOXwwLapkeZ2wc7R5t5twe3P5yXKuaCCL5SgJgiWwEHQIslOO35WWlX2i1pIykIx/34WCtzIrcQITjJ6LYjzQtG4DNBA/0opKNbEZ88=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773936985; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=dPrb+TYBDZVJbSRBjlvAnKVUGBeTBCp2VVxNmhYsqJ4=; 
	b=UG3jQmgH3LF32z+NV2QoW5arMVSA7jLSkcNa/Y1LSX0glTVxCXNPeJoF7iryOT68ABsep6yg3vg9CzFs5DmX4ShKC4g20UILJzYbPIwmAo/0DGHljEisk3Mf3yyFCMK7rh0VM3FpNwH987StfhIQvanWJNba2x1kwii3wLnmgzE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773936985;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=dPrb+TYBDZVJbSRBjlvAnKVUGBeTBCp2VVxNmhYsqJ4=;
	b=DdSdJfUjf5GMUpvKPRm5doYHYkX4ZRj+kam0m2FGyZfXjSrYaC/eVpFbx4xQVZWV
	I4/sbGOxnDbuz4SmSXUGGEZh38cu6xdB6u9228rxT5GH8+WNyT+15QK0+g2x8/PMXzH
	3DADWReK25IKX/p/hlPFCYI6X3eeKqAu4iY7yjY8=
Received: by mx.zoho.eu with SMTPS id 1773936981832341.19770997106184;
	Thu, 19 Mar 2026 17:16:21 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 0/2] mm/damon/reclaim: fix addr_unit validation and age truncation
Date: Thu, 19 Mar 2026 16:16:18 +0000
Message-Id: <20260319161620.189392-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3F37F180002
X-Stat-Signature: 1w3zb447syuth8jfm7fxf3da1pby4eb6
X-Rspam-User: 
X-HE-Tag: 1773936995-993203
X-HE-Meta: U2FsdGVkX18qq3/kTwl8U8et2nqKyLPNvdHS5+h5PAygXilZ1dfcHCCQUiz7OhpGf6Fb/Kf3xperNNxbNRl3NlgfT0IEKenFIbVkgCwRu2eQ203sf8QqUNpxuZ0w5KtKB4tPr6FwVoPVi2QWCKlPIjI/9SQ6M7rOVkw5ktqoalZ7Zd+gA4+kl4mPb8zwUaKdd3LbZJACDUv95boj7h8RbeIAGbQT3lNj3xT4fvU26M9ExE8tAhn9UwT0hhX6LxDFk9v44HVoII0DURiMShnK7tIDS8yPBckScbrlwi4ikIPO/3GN16fcI5YP47Wv9U+DMnpuH5/j3npXGMNO8oEHR7YADWH5b4BmPTX2xWZgDBRa9z9lDqL/PaU+L8LAKfh9R/cyHE5863y9yTwMkUTUJSmCkQdeA1ku9axZdWXZCUugPX0EmzZug/oWXbMd1kb3/AKQF6wFU1GM/MZDnqJIl9x1rzKggV2I83N2AQITl8P0Y+8LrAdpRfbKs84/Ji7RRCvMt5mkP9aQnpSFe43aYkjLbKHo9zZZyqM1EUaSpsXOV+y4JjZXzAsoI3HmV/0O4JV9D9yqKmQ5uwiSotPmJ/sjSEGU7+e1pc3SIlTCN6avc6Jnayv38A9DvvZ5ermeXWDIcn4AEB9pnsfr8P8DWxDVl0EeTD9Z78dWQ0sk+ViHoD/Ua75U+WGIALKo4wejm9KkG4bCxTLsOWnMeVkT/RppGuNbO5VLAGnI0ZuOZGG9jimglUdIq1zo0VjbXgo/jIa73T7QbJX1eGMELjc/wmqhZ1HS+CU/khA39cJdiEpV/ovqX0PAOa+6NnATjCapac1p99jdDMoIkGNaGQUpIVisp/XWx/6jNSP9QPVI7jSw0eTTSZ4SmcTokrA8U9amStqjLFC+cXDr6UL+m2Qi6dKjObAdcfQxRGbaSa61VEdFKYj5Ki2JeZoU/+E4QEb6JCTTeJN9G4VCa647t+d
 Z0xXldUv
 1B2WrUkEAQVvIHXGQqjh87Ft2qIE8WwNoQKrW6eXg4NCy4WVzilbE3U40YcVzzbGUNJMP1axKd+jFIcimsf6QNmq0zotVqmZSap62KBkntHWu6QC3r/Ny9R1DGz3sMPjrNWGWmSl9Boor36Tn2qYex1YqJJC76vNdnm1IWrMn36O57UE3LDMl74VmMwO8uEwr5/Dbrhy1XfrKnEYM0LEyuPy1fIByg2WOj9cuJrYCNtzX/ZltSevbZjUkB6MPl656EvQFW+nQPPG6KdtCuY7rftFGuQFfKEr4qVlNM780jQeHFhMFjUyizpbyrVWjsGtSt8xXhsCnXSfqJUjOkFgzyIaSICf96zhQlyDk4BUTm+djodwpf7uiAul+qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two small fixes for mm/damon/reclaim.c:

Patch 1 rejects non-power-of-2 addr_unit values in the store function.
Without this, DAMON_MIN_REGION_SZ / addr_unit produces a non-power-of-2
min_region_sz that causes undefined behavior in ALIGN() before
damon_commit_ctx() gets a chance to reject it.  Note that
mm/damon/lru_sort.c has the same pattern and likely needs a similar fix.

Patch 2 clamps the min_age / aggr_interval result to UINT_MAX to prevent
silent truncation when assigning to the unsigned int min_age_region field.

Josh Law (2):
  mm/damon/reclaim: reject non-power-of-2 addr_unit
  mm/damon/reclaim: fix min_age_region truncation from unsigned long to
    unsigned int

 mm/damon/reclaim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.34.1


