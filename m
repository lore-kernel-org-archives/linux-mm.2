Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BB3C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2893B6B0093; Tue,  8 Sep 2026 09:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2396C6B0098; Tue,  8 Sep 2026 09:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128886B0099; Tue,  8 Sep 2026 09:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA65C6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:28:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A7E71A06FE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:28:28 +0000 (UTC)
X-FDA: 85190674296.26.4E6C8CB
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf22.hostedemail.com (Postfix) with ESMTP id 59D52C0008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:28:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=eRzvCtnI;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=JC68X4HO;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788874106;
	b=yk3v4HFHR+6syEZNtsK9LElOFrgsOV4kXMsVka6RodPgAPQ8hF3AFHGGND3dZ9r3lP4Tab
	+7Y4extfScOEJzKBL4yZI4q3tjGIJ9Y9dSi27DDudxwPaaLCzm54QxdEAepDeIyr5tVkqy
	FcsL8JZP8p4Y/F54Z1u1/DtIJFhPyLI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=eRzvCtnI;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=JC68X4HO;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788874106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XRGPzws2sb+9IlW6HXf+MYksDpUmRu+6YrbXkwnjRR4=;
	b=0A/Ux8/dcDfBmEgaHTOcMKZsf2jPXPTm0dZfHww+/IJCsLmQWCnk4u65iifB1jg238HeFU
	Xm6Y6oW97VxZf04lQtOAyokSNOLemQOgqZe/NnR3nOYMU7/vLQSTnqRs4QTVIvbvRBy9Dz
	aMx3LSQWpruxjraq91AVp2rE1HPRKik=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id D6A67EC011C;
	Tue,  8 Sep 2026 09:28:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 08 Sep 2026 09:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1788874105; x=1788960505; bh=XRGPzws2sb
	+9IlW6HXf+MYksDpUmRu+6YrbXkwnjRR4=; b=eRzvCtnIT9WujyoUL86zSn0Iiu
	+jtlY65TKWG6j8D1S1gxW4Cw7mFn+hVNMri9+i3yndrEzfLTmrX3bX6HVTGf9ekN
	MyKtYLHA1mPifWp7wUxfu7xV046blBlKgVYIFk958pA8wYSZGt1J462l6ag/kdpm
	aAdeQIszxfs7tYMd6nM5mz3xFZGslPzbRQ+hfxIVT2m0fpVCARY4zKJqT9aw2OnL
	lUaeBLDAj/rjeWjKNW+l4mans+y+BkZDlP071NMpYEcJry6oPk9oRoc2keUF/Q8I
	dstCCj8ASNZ+cfYz+ttOWPFbu/iql51DhasrbEVFCQUFAmHon8qvxvvWDCrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788874105; x=1788960505; bh=XRGPzws2sb+9IlW6HXf+MYksDpUmRu+6Yrb
	XkwnjRR4=; b=JC68X4HOREoHolGlVwW95c6JK8RhKM9016RYWlO5K2MBkcHHcmN
	J8R43kK9GWsapIiVnMJRLFFVSzcKJpMe6QnKzs1BARH5TQeiNh4EKE5lI49vTbTB
	hOdT6y3nDBsrXOAmsCcs9aqg4x1XY95rhpSMhKoMW1cLS/AFtAqCZoZBhGv7LKBK
	V7snfJoT8BZDNeEeYPEBnQ1BePnjatFosf1XpwxhyvzMIwG4bGPMN+Z21PTAqIwb
	kE6Mj4vWdsHbwsx0IPRPJ0c4s2C1if9Zbcr7JPTtKhjT3iTwr+NlN2wVLnnpOASY
	PLzA0ULPIy5D58Od8ggAGM4+A4ZXCshY5jQ==
X-ME-Sender: <xms:eA2gauWIoOm-BxH17nKhSbmBnKdY1YLJJULHzvPYR72cF5mUKSW6jw>
    <xme:eA2gao_x5tDUx0VnqLHgX7raPwOX6PpxBvDLsXU4ksOEPpDeVy1ohrZrQ7mzI7rsH
    Iuevm8O_zLKaV0wrYGZFb5NwW3GWMBCEVdZxmvtk0d-d980O8IbFoAwhA>
X-ME-Received: <xmr:eA2gauYMm5w9DcLDOR2rQjw9LmFjih9jTSEM8UQCqruMQw_AFrgedOwSzLs>
X-ME-Proxy-Cause: dmFkZTFeNeMAsfC7S2yyN61sBWuwFqP6BekvQP3VemALp0/A7/88H6JQR+d7jV5Lg7u9uQ
    PDn7I1Wo6qn/TFhatIEJH0B/epMmDLlvS5YxrZwCbDsjWEABLRnUDNVkwMQrZfQZGLJzzb
    2ruAMIub5nUM8aRUsSZru2LzMu0kqf/aNAG243THYtV18G1C4XAxUMbFY2wuvSE7mEaPcc
    anq0IKqBKTIUjUqYmQFMmmUhhYBUGDgm3c6GbxuZmdNRBKo52hbAfhsvZhpFJriV2TERk3
    TU/JoUd+zwFxALYvoXobOt3jAyX9TC8x04xDgJ0yQoKmx3V7XWHi5qoYYfZjKtKaNzPTOA
    9bQPQQz/KfM3zA0zLBzuuxtIspn87uVdhGA7qxiFCnMkH2e/xzVUxKHoxfJ2cuJ07CyeIK
    NxHRBm3tNPc1SR8ZARock0ll/AK5nLhz3aVSdA3EIU129Qe+qbfa/J2Wmp1TFUo8P2DxZP
    2Bp9XcDrkTvg2+vDKHVtWx5eb/qsSK7FxkK6ua3GRLuHfb86GcAbVycQ3BZlaXkAP9vCf8
    WP0UulaZtFCyeYKL6BxbSq3/I9U675b4JnO6S4OE/eEUgduK/xf3TBxR4deTqIpCzuR3pp
    cuucGaTXntGJutUKB8HuWGrfC5mrj20x3w53lyoVtRAWbRpu0bEqWNbwo2FA
X-ME-Proxy: <xmx:eA2gaoe4_hNzTq9FNulk5EqsRd59-rb0HTf2E5vw0yi5CwxcvwDKOg>
    <xmx:eA2gagr9e5UjuG4yuIPhb3JBFNledu3yHsZHaII6UXi74EN6aSgpjw>
    <xmx:eA2ganBtaMbB0nLPrZ0u232MJVie4wIy_SwPQifgfZxQT3Myu5BLNA>
    <xmx:eA2gamVGw86l5pzMku1SsCU6ktKuD4UD2snWQZcQxAUNttASl-KemA>
    <xmx:eQ2gaiP-g920ppcxJH2BmuAMMUobh-1INqKnfuLIRltdm4m48Ww5Labu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 09:28:23 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Balbir Singh <balbirs@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Hugh Dickins <hughd@google.com>,
	Gladyshev Ilya <ilya.gladyshev@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v2] mm/huge_memory: add folio_reset_partially_mapped()
Date: Tue,  8 Sep 2026 14:28:21 +0100
Message-ID: <20260908132821.1517475-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 59D52C0008
X-Stat-Signature: 8t4rcpabwwwc1o8g5jimkugjehtn8jtj
X-HE-Tag: 1788874106-368084
X-HE-Meta: U2FsdGVkX18qZyxg7TICyRskoUfd75yHbvr29S+9/+/2XY2oXL6wyJ2+mZH3FXA9uKJ1XPFx3khJ4W/i5kzKnh27pFsRbYnjbHI2uM0LfXhFa1bj3LAoUzcw2XxAItQ6kt5oOSFjLK9M70usyhAUHNjibA1l3P+XyHY5FVnb6dU4mjSjhN57I4ciRPlU67CbkW+Pc8wUyg0YOwnDEZK42sLf+W1FpclqyimLGEA2jF5HYke3EnXPavzFPGOChPkg/xu9g6HFMpfUDMeVBm/H5CkhLWSWJ2+gV3KdAJ9n8qOsHVroKpEQlAcnw29IuCyfyr/hJqmnpfrlL0+IqBtcQ0tecxrPpPJXe4SlFcLua0/4w23xuSGB1Uk2w4MaLpkhh1kNr+rvUZsDMpgrrYsETb2mwb2RbOPAs2F0tabQUqBDf/fdDj3MmLAVD967WCpacoKWoZ6u5YCjCb3qpYVMGAPM+q7DKa8q1jxwCzZzrTiL9T2/6jsWPeVr9Av4EjfcGHCkpnWwQlJ8gC9FL4mHom8ABKMf8atb5seaRnChmNHoXgU5XRssqoVeaweGzsh9ewmakrty6hvHNR7h+Gh2BPuxx5yTY0Dlgp0c1oO0uoIPvF3vIWoouYkv7Wd1cLxGlE3vtb/C5xW4tKtziFiZCmuX58AEA9p9FzJlSlwEe79XU/7rlmZo4+asdguhas4cPE0rYj9NSSqIqnaCGcqTeSFYxrb+BNlc2cYbOlo8locDSs939nFPXRTLOnNw9gT+TOY9oZRe8DbsSunEPNUXsoaDtxMTPdPy+2tbhXunlkMRYmYulF6zRuVtiM2KsMpxUkaKn5W3qnQPss+CNaDz3W8TchCfkvL1CQp6o8xGYR/GCs6gj1OeLDaucyfxYANcjRbdUO36fD8CPgq1iBMllhVoez473Hewg+Wh93c0VCN/ScUNlx9LFyhUsgQDsxa53CQiYynfjNmuFAokHfs
 hVgoL7B4
 1DXdOW8kPb8CrAa2S74UT+xpX5hWZ9uEif2JuTWLVXchuU9SM4glG70x9DG6yxII1tkrOyH/WwC/uNzJnTsi0HlGcH0EnDF0YZWSSKoUJVOIN9+LUINHKmAvoGmcmQoM57KGfT8zZg3940dYZmq+yBqvG+YpfTCKYyHu88Rrc2Ffnk5IDLU0vTXBXyVe/vo92F6E5AilWTykmTChVZkroQCUFuaOUMhmgQFFmZdbi2c73Mo/PFj5R/eXDZCXXQ6Q52irncAooYH7QMt9SyqSwu6P06edh98IQO9PnKeXFVNhCCB5G5FUPRz95JME12+bxTFw1B5EsmnKWhogZIJJQ2iAkv7mEXPdEyEJN6bd/2cgg9ybz52irT/aMhzcTgWK5lBLggXXEXfG1sBHxite25xXHlgoGOBmD+q/d2j1hlh/kS4pNpwtrfab74eY8NbXwBg2jO5l+DBAIJ31UWrXZTk2n32G4WmWcmgePW24/6PMTgejeTxtHUPbvuX0xGaJSuYl80+pejbZS8dLEBNdg9axqXAKZXRXo8e16
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

__folio_unqueue_deferred_split() and __folio_freeze_and_split_unmapped()
both clear PG_partially_mapped and take the folio out of
MTHP_STAT_NR_ANON_PARTIALLY_MAPPED with the same five lines.

Move the block into folio_reset_partially_mapped() and call it from both
places.

The helper asserts what both callers rely on: the folio is frozen, so
deferred_split_folio() cannot set the flag again under it, and the folio
is already off the deferred split queue. The list check sits behind the
flag test because order-1 folios have no _deferred_list.

folio_order() is safe to use at this point in the split process: it
still shows the pre-split order.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
v2:
 - Comment that the folio must be frozen above the refcount assert
   (Lorenzo)
 - Assisted-by tag in the format coding-assistants.rst asks for (Lorenzo)
 - Collect tags
 - Cc Ilya Gladyshev, whose refcount series would be the home for a
   folio_is_frozen()

 mm/huge_memory.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dd66c6ad5af1..fae959633279 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3972,6 +3972,25 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
+static void folio_reset_partially_mapped(struct folio *folio)
+{
+	/* Folio must be frozen. */
+	VM_WARN_ON_FOLIO(folio_ref_count(folio), folio);
+
+	if (!folio_test_partially_mapped(folio))
+		return;
+
+	/*
+	 * Order-1 folios have no _deferred_list. The flag is only ever set
+	 * on folios that do, so the list can be checked after the flag.
+	 */
+	VM_WARN_ON_FOLIO(!list_empty(&folio->_deferred_list), folio);
+
+	folio_clear_partially_mapped(folio);
+	mod_mthp_stat(folio_order(folio),
+		      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+}
+
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
 					     struct page *split_at, struct xa_state *xas,
 					     struct address_space *mapping, bool do_lru,
@@ -3980,7 +3999,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
-	int old_order = folio_order(folio);
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
@@ -3998,11 +4016,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		 * leaves PG_partially_mapped set.
 		 * Clear it here: the flag does not survive the split.
 		 */
-		if (folio_test_partially_mapped(folio)) {
-			folio_clear_partially_mapped(folio);
-			mod_mthp_stat(old_order,
-				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-		}
+		folio_reset_partially_mapped(folio);
 
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
@@ -4516,11 +4530,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	memcg = folio_memcg(folio);
 	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, &memcg, &flags);
 	if (__list_lru_del(&deferred_split_lru, lru, &folio->_deferred_list, nid)) {
-		if (folio_test_partially_mapped(folio)) {
-			folio_clear_partially_mapped(folio);
-			mod_mthp_stat(folio_order(folio),
-				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-		}
+		folio_reset_partially_mapped(folio);
 		unqueued = true;
 	}
 	list_lru_unlock_irqrestore(lru, &flags);

base-commit: e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
-- 
2.54.0


