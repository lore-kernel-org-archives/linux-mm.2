Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E08104BED0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24796B0089; Wed, 11 Mar 2026 06:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4B36B008C; Wed, 11 Mar 2026 06:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB29A6B0092; Wed, 11 Mar 2026 06:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8934C6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:19:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36B20BABF7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:19:30 +0000 (UTC)
X-FDA: 84533385300.15.574AA29
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 807B940006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:19:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ct00CbYK
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773224368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXIH1tXdZIJ5fkYaX4jFP9QBJPuyNx5b18M8eLitWko=;
	b=uqIYnAl2qaBS086tDnd5rm+zngqA4O/i6vnYBFV4k8tp58rNSX5JTD4kUPusMWJQhpi7/X
	eyMBm+uIzkak+BN3veu+o9breeQp0wfS5NP4GACZVe5zhBOPnoCcjIPpsy9/w5NTT9r19X
	+OzYSjzTOoumztIxhZ6bALGeyB1xYvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773224368; a=rsa-sha256;
	cv=none;
	b=eG7Mhiy6pb58AQNB65IHe1LLi+W3PrBekl0AF1JT6nBj+x0DKdTrTXV26YWWdEmZrwBoHk
	HR4g8Yq/t+jONMubKsq1ABIVnsXTlCSois0hYjsurR5twYTlv+VmYrqIuv0wQ/56ueEJyd
	XK03iYs5aNO07SF35muzkPJlo6rXjX8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ct00CbYK;
	spf=none (imf07.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=iXIH1tXdZIJ5fkYaX4jFP9QBJPuyNx5b18M8eLitWko=; b=Ct00CbYKQ4ArbbYHoJFb8srJY6
	8uJg9eW8MaHNoZQGgyfvKTr/hxqtJ/MxcLk0/PhLqpS9kmIIcy7DCC4sfKbOtZqmCY+7EkaAeObJt
	eVrrOBb0DOhVhksSXK4XF7oPQJtpxoG9i6WL19X4oyK9Voz/hauRsuQGJuAcVkaiu96fzSRJncGFw
	RcLA73jaAMf5WcYYRqY5f+TfMyzCaRRs254uzTZ0AtOrdH6YuymdCP48C/YsAgfk/Pj1m0RSVTOYv
	LzKYkXpyeZt0CW5ViHic3zV3SuvvzSI9k5DxhqAHX0Hhxj6ZffxvjQW/bcEihYd1vUHTewH6JbwRl
	T+vS749A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0Ger-003hKV-Gw; Wed, 11 Mar 2026 10:19:17 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 11 Mar 2026 03:17:47 -0700
Subject: [PATCH v6 1/4] mm: khugepaged: export
 set_recommended_min_free_kbytes()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-thp_logs-v6-1-421e30d881e0@debian.org>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
In-Reply-To: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1398; i=leitao@debian.org;
 h=from:subject:message-id; bh=lZahW99RTlxb5nSjc6Dzfk6SVjr8wXe8geyfqZrys/g=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsUGYdXYLlTfdS24x4Ijnmy1lzO7mh4g8bO913
 JPJ20/U5aaJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabFBmAAKCRA1o5Of/Hh3
 beMxEACJHeqxWGPfoHsKTtYydXn+xUc2IzPH9U0E7Coj9mxC1hXG0bAsEqptbp7IlygxSMfBZs5
 cguRNroZvDK2zbBxYlxUmqkzX/dy8AKf1d6WGHB4OnXcam8+AS+TaQu2OfoF4SQuIOrtf9GGFvV
 974GdlxU0PhmTTJP/g0ZtxGpq8Fp1Gn+UjVpeEMBT8JOsmh2Ib0uLSstDextCYqMJ28XV/z4Jfr
 za0Q4IiqGVo/RtiWcmOjJWwViSuFaMreQWTnRUDTUFwGhKfg20x0z4z0kbk0mdJoIdyd7peoUez
 guRmThRVtWGi6EV0MyufH3/gzObG5/cgbCkUMwpG/gXAnkOy3aScRzxRVFH5Ux8On0Y5fY/M3ns
 +0CVZtyKZaV4JSFxurxFdEBaG1kih2lSkmFm9td2o0R6iJwZ9Jd7dWve7AaMk2MhY6WUGos2zFW
 NzxNH0jP4tm7R9rk70/qKfaGuZo7Bj95aVIb3C6o42OEc4Z4PRPaxCwYstlM+52nvL4b6PjuYQV
 JGDNQIVoL0YBYLQnSRjUfE52VnbRveYlD89Zqm//G0eyS+1Hopj5t9YfLLdGF9vtfj0koR50xqW
 fngb8dJmcJF0evXumurpgMt4A7yDR2QoJ//AHD8G9CKzAPIFl2F9H4S1dM7tW77d6tmYnHiNDzd
 xQcXTu8CpjIDwSA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: fddcfcyuakrizz8t83yjhzuaab9w1hd9
X-Rspam-User: 
X-Rspamd-Queue-Id: 807B940006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773224368-656222
X-HE-Meta: U2FsdGVkX19xtKAmujHL+Ki8WTwDnCdQRZLEae4YSbk1Pk9xPXLpt4yBbRB72G+cUxpwQyaBAYp9INWtnzDHAq684NIoqUR7WEfgBqLUFViaEG0bBTozaYR4RhP2a3AmdFx9H7jzLoJ69V7M2llWz35C+JbWktv8GSwl0q0l3NEJYNYaT727ekxZdVfdoxTVjPSIJkK23MAaNCtUQjqlFjsZkEuqd3mTTJ8baPQG/eocQlvZXNO8SwSwYFy4dqMrq8Bb8CbF7xrkfJrQV583BF+5pfpmus+HL8/qXXzw+bnHqRkXwRRvBD2CHrZEFGmHfymPF26lov4dpYnZQ551US6paDMxHkWqgKUwBMPh5FUP05lJkpWTpQhjakYsw0Rz62ZEi+xx2TNDbWyxNurWtbzTC75FYGNN96xDExw/3L3lxg6gjglYAKZ5j8BClDkSNaoNXbUL7ZgSEjmQotpQ9JHh8dnRSax9w1Y3NCZUHMuSjjPwGDmEq6KnSQD5spFEXvvbZ4SgaqW1h/IG971hKw7FweRzLiiwW81kIHEfkWW2Lz7KtBkZ7HXpmF4tJ2lj2ikqbX3KyCKAsUhegnhVdIvbjHzY3vqnBmt1wizkgTRlP9LaTbqde+fFA2A8odGbF5To0a0bTocWXNrYt2+pyq2hltVtRsnqZCAYC3ZftlE13D63Iis7ot1rg/XrSIcaeVm6d2WKSys9WJjeD0+Yph+qWZg0zpXh0A7LOP545IojykMUZKaMXba/i5JP/cNGj5JbrT1byMKG8YZ7RTlfTU46vlQmSP6/06a8IQepE6nKaAGfHVh+LrDAuzeBAd65w1G+chiStKJnWukbJi01ZxmRATL1jSq/4T0kDF1oZaZ2DenDzVJLSXYQcaoLXZGB/LRgrQL7TB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make set_recommended_min_free_kbytes() callable from outside
khugepaged.c by removing the static qualifier and adding a
declaration in mm/internal.h.

This allows callers that change THP settings to recalculate
watermarks without going through start_stop_khugepaged().

Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/internal.h   | 5 +++++
 mm/khugepaged.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d99..7bd768e367793 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -623,6 +623,11 @@ int user_proactive_reclaim(char *buf,
  */
 pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 
+/*
+ * in mm/khugepaged.c
+ */
+void set_recommended_min_free_kbytes(void);
+
 /*
  * in mm/page_alloc.c
  */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1dd3cfca610db..56a41c21b44c9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2630,7 +2630,7 @@ static int khugepaged(void *none)
 	return 0;
 }
 
-static void set_recommended_min_free_kbytes(void)
+void set_recommended_min_free_kbytes(void)
 {
 	struct zone *zone;
 	int nr_zones = 0;

-- 
2.52.0


