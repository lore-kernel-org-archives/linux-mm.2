Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6BF7F55100
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 16:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E226B0005; Sat,  7 Mar 2026 11:08:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBEE6B0088; Sat,  7 Mar 2026 11:08:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADD46B0089; Sat,  7 Mar 2026 11:08:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AF1C6B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 11:08:54 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A514140449
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:08:54 +0000 (UTC)
X-FDA: 84519750588.22.9E5B1C8
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf25.hostedemail.com (Postfix) with ESMTP id 53A76A000A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:08:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eT8VmgpA
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772899732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWwVHwhFxPwZWzEvxtvZzmQI5X0pdoxE0LNq0dsk950=;
	b=r9yxzR+9eHwt/mKmGnQmiaVRvLxZ6r2W6jvAYDAOT4pl80wweugVhclCEc67g9oU7H6U8p
	znlFItsYeS69INfhRBeBnppbEPKeOdoUHoKzWCHM80ux1YIedzH0S6Ouqtg30fOiyMczcN
	Q4NW3oBumAb658DC17Ui2LGiPOA9SC4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eT8VmgpA;
	spf=none (imf25.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772899732; a=rsa-sha256;
	cv=none;
	b=oUK8Tv26RTji8de/JdVKrAR9ok0MpX0DU36umM4S0v6/ov/f2rbKZtLB/+umqXM35gBWmI
	oetHbC1MPTF8wE7Mm3bbcRF7tYhmC2LwhcgFpwiQVXoSjqW62A4vOfZZoEqRLxIMzNj+wj
	2V08DqDeoPJ6w5qREUzO0B5leyTV/HM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=XWwVHwhFxPwZWzEvxtvZzmQI5X0pdoxE0LNq0dsk950=; b=eT8VmgpA4tPqQycYOYqOZCmKTg
	xvFkQUi/k68fZ9amprgPmd2KagoVRiso3gqcaX0K5MUzHJVbHsF0d1cj4Mu7lEWsPgwnjmw4AFNu4
	C/JJZSkv8KzCfQwQGfrI5+odHMLXM7RtSlj9rW4B+7lPwbGo3x9MxrSq3rnEDGTfiu33/qhp8/R82
	1U5G/QETEPtbdbtBnJmUYdcwdru2qIuEKZWWc6Zkd2tVTAptQWGcMqZYXOoalxmTppRrh5h5W/weW
	d6B5kfNFVUoyWBYqoRUNzMS+CA+tJcxd3vKSaiq22GOowlcDW12NGFMlCDclCnmU7hgCmjHcaof47
	tqUl9I0w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyuCj-000nEa-ID; Sat, 07 Mar 2026 16:08:37 +0000
From: Breno Leitao <leitao@debian.org>
Date: Sat, 07 Mar 2026 08:08:05 -0800
Subject: [PATCH v3 1/4] mm: khugepaged: export
 set_recommended_min_free_kbytes()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260307-thp_logs-v3-1-a45d2c8f3685@debian.org>
References: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
In-Reply-To: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1306; i=leitao@debian.org;
 h=from:subject:message-id; bh=nlToZmaB1n6dDw+eMzdYWKgFtlcgYp+PAKEi0NGirZY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprE14+evRyvdKxaDGyxMGTTyJb0VRMtiwTvLeJ
 dIz7YpRrCKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaaxNeAAKCRA1o5Of/Hh3
 bXiED/kBAQZNjkicewFQbE4GK0Mp6mmXS/Bii4ayWO98XHh1pYI+T88J2dgXy99YxBYuXemKaiX
 EcBjcAB8U05WNsV/P0RzS6JDdgXNE+xYvwRcdRumXJ/+Vbp00T9Q5kdtjphg+vuVp1vBHuVS0rk
 E8+CHhTDCIXrN15GMTWp1oCEKKc4uvA4s7dvxM/8BBwBN247Yr9I80jBxTIHRf+k2r9Zu3mo621
 IH2AXs39IPTFIfSDdX/nM1jkdMnG/4hJWudzUSm2HshLuh8DG7DjezLe79WKENgTqTGfT3FEBPK
 pVCWmCZ9bHAIaoea/3gb8YfLOBEc4wcu9ln3bF/jkteEBKl0YGTmwJGK/iZ67MD6BIDvNAj3ZrK
 i5gaJPrWuYgfw9+3yBA6+GpGGUIngORxZ837/Es6y8N4Ugp8wukzn1U4LMXlKtCGBuIbl4fC4M0
 4e3sOlr1Xyftcoj3WEy4zvHFgSSsGkm1x6fsjLrEuzIrSroCaQ1f+hLz/xFA5iawD05WZ76AWpG
 WK0csuGO3E0dN3fVnlOIFftTcWnaZnJK/QysXPU7sH34cZkTcskclBKmkC9LqY+fd1hWQSDL2mm
 nB7SUnoj1G7iIQzA8i9IXIabI1prKjg7ksu1cH+uzH5Sb5O8GARo7xdkffc+ikJE+g2sL6DDWsA
 ieq/WfkLvyv5YXg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 53A76A000A
X-Rspamd-Server: rspam07
X-Stat-Signature: rm6ethsygdydwft6t1m77p6tzcfwyisq
X-Rspam-User: 
X-HE-Tag: 1772899732-536520
X-HE-Meta: U2FsdGVkX1+uqKA3EwiocrEkgsQQrpwqELME/Wccwaoad8cIS+gbRLfw7UvgQOPvwSkxYMmxMsM3X3bU/Ib+6ey8HOiy4VsffcN/0UmInoDLt16ldmngKmhsNIazaATEAMpEO0lJy77ERcdnK8BiKc6TEkupHm9TvdfIxf4X1OVstRHNm16eIPCloylVGrC/HA93Rhz1Ka7H7E2GfCE3vRlED5jCTATgE1dhsHcKPJALRsI2RveGKjtcN9zp8oJKpFtElX0X64znZz+zGaEu0VGgfA6rABt70sR0+lpqXP5S7ld20uWPkUSSjHJ6sD7mbp8f4mk3+vLcdlJIfTcTEw6mrqMT7WrY5G/R/YqJ8KHEEZ32Oo6qgg787/QsM7TFnugL+Kw0+eARSGq//3tfO3iyzpLWOgMcgFLsIU/CcxCqV/WIqU5mJPVpg7wosCFZThMbrvPfAzgF9g4SKu24Q7+LxbeoThc9PCbfZSPvjFA7acoRijbLCh8r+USF+bm6TQkLWK8oQT+0amykeAKzNbGG0iKIDXMXLp3HHk0kuDaEOtzPJcQslEmxNfT9MO4gDdtu0xEW0Whc4Bw9ryRBBnAZEK4lTj4yqx41oqfbANsPkSuKhc2Ipf5S2r6ozsEIEd4MGiZoTj1R4DJUwYPdc9V/f92xFP8k3u5zKbvFidjA0cuYgn0GjzV33KRYwra3OA10MI84zB59k9bJ2cOuVVW1MVMtaj2zMxo8KVrQXKvl3O4jcJ+f5wSt4bV7e7C0Z9iKdwz5IAPZq2uOgv/vL+OL0AgdaapocjwQjDnuFn89ietTV08u85P8nIkSbnehAr4auGLze+XKcTtWcDP7SkzGp951Ki6qsbR6Mg5grVZOZi5CFkkobXbeUZx+RzpN8Xq2+Xux0+bOvnDEPsCPHOas1H6V1H46PhD8n8Pzeffw3YZGOsgEBx7Dj+6w/pcmcF0sUn3DcPEmevgSQq3
 qI2ZwdNQ
 L1bAtbm/S/JtDgGk0/xHDffyuaKO9o9gY+l0ygE/RtRe6bcbcCI6yRCBgX5Sa3vhjuwE6AOoFqtXEUueF9xaZKF+bf3/tNoI313UDwbHwzgZgehp662STSHXsbnQ53zhlK1coKUZW8tUVGsXr2v6Z1gLhy4sQasyxmvRpcBgb5eESJJCneqrTTovUkL+KzgNkxvXO9k2TXMpmZFR6x36CAJ1XW+Feld+ftkdF+BLg0Q7yKyC9Q31FlI2HPMYUWdrQbMt4J3/hoFQ7KGo=
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
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
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
2.47.3


