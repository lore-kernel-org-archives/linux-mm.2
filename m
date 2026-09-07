Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ACD1C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909496B008A; Mon,  7 Sep 2026 14:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0B56B008C; Mon,  7 Sep 2026 14:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F65F6B0092; Mon,  7 Sep 2026 14:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCBB6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:33:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC7574028C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:33:49 +0000 (UTC)
X-FDA: 85187814978.24.F54DFE4
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf27.hostedemail.com (Postfix) with ESMTP id 15A2240006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:33:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=bBtFq1qE;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="hYl/dw46";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788806028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BXtFYHJPAKf7ySUW3H9RvkuC80wSwao0DDfxfWpC290=;
	b=reJKebfVwnVfdfo2gY/t8Zi3HvPzsS5eIh4fXqNgDb9pannmiLDE0srl0timIb3jSPmMq/
	5XtqsbqR6lja/KKVvJN5EoE/WUvsTaBSnf4hrIzpUPivNpJDROLifZVrZT91hzzacN8UTO
	JURx03s1wGyqUwNO6RhW/YWO1r6tbno=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=bBtFq1qE;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="hYl/dw46";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788806028;
	b=A/5iOOzEA+cPH7DJhmOqLltOAqr5IdAN7oYn4VylIeX5OIINteh3P2TUfld5vLs9lBpYgb
	DWuVnm14+c9M0F9cKOmVBuCPzcdopidsZUDVeOdrEv1w5f6ZWcXiHN674lbXdnM0a5aA7s
	QwJn9aKgoZnU1SUvQlaQ1o57Al1PxeQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CC7F27A0096;
	Mon,  7 Sep 2026 14:33:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 07 Sep 2026 14:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1788806026; x=1788892426; bh=BXtFYHJPAK
	f7ySUW3H9RvkuC80wSwao0DDfxfWpC290=; b=bBtFq1qEPlbUh7PdgXvR4k9Ic5
	12H+YJWYrwFahJdTX2YAqCGYG/GvzypDugTok+bFEuhwU1s1906Ny3AIv2q5d7C2
	PvUynxt8CguhPQSwpWufHxWazxBW0Rm62byks93U4CxVIf/SCtK/SAP82M4xwYbc
	DhAvB/MelmhmTXmG33oKDvM/0EuYZEe4gjDqbs8e/ItcCYZATbz8XTZbNiJA8UL3
	870fIIEuh7Hig1+pKZCh4RaaPuVoMPqNnPut5SoctRWeGmy0fUFZAA38LaYcN2q4
	7BUfzZ2fxnEe4R3Yfm6+rgO8sHZCMtr5hM+gmQ9WP+bLEA+g2XbyroC4123w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788806026; x=1788892426; bh=BXtFYHJPAKf7ySUW3H9RvkuC80wSwao0DDf
	xfWpC290=; b=hYl/dw46E9CNgxkp4DO9C3pI3k2WifzwuiFZ9EM6y7JU+yg0PN2
	n8mXEnnAk8c+mJZR2Enwcz62VRIny++P5cpR15hvoF39XVJHFzAz50K1zardOjA+
	7iY+tguykZA1BEE+QkK3pO9f5TlGXlFQdlUIHiaVjIeOMCWEWKzplWrNceyjc7vo
	Tz+zdUVje28UBqb3Cp297CN5Me8lkyR8bZLmDS0Og5IL0Swu5aEVFBxBrIKKv3Yp
	ElQSdXv4zwkKO4ZepQPNemyiBFvmXc1uNOohhDQtZ6lAREkJE8mRXUFbm84Nxnyv
	SZQF09u+CgMYqVmupKKqnuvcQu+f7USb4mg==
X-ME-Sender: <xms:iQOfaqT-O7TraHAT43xDGd_j2-wdE2vuRzzrRfT9heOBLGYQpZmWXg>
    <xme:iQOfavD7OMCIjdX8uHkKzVZ-BNQje7uzB-8OIqVaYnYtw9ZmCaV9yklSFWuFBmWeZ
    dg9omhVcG6MJPDeEyQttDB66N3troxpOV_8DnPaoalTr-VNUSyUNnop>
X-ME-Received: <xmr:iQOfaqrZO4Z7BJCulYQT6TrG60HiZlzFRDXyy8a0K6RmhQCnb71PaKsiOkY>
X-ME-Proxy-Cause: dmFkZTGqQC2Jf5uTmbrZ9IHMpLKMHTwTf8vZgahv+dbqM86a7GIADhyzyBKn+8z30hGxYi
    JdDYvnWJ1aShMrgwyCTEnmGqMb6tYFf750DVdCmSYTFOLx+Tr1yyG804g5VwXxu336yI6l
    6zVycKw68iUkXrefSacpJZvyFqpqN/zm7t3kC7vP4Q0H+B0U5TcLwi3Kb5oTxqwASil8yR
    yPsRAGvocXU2rV25Q6e2Zq2n+VpPsGujc/6lxq2CTx4orAXd34KmW5x0fBxGrwQoGpVG8d
    vq7W7xjZcTSZysP0Gwt5lGEw2lw7jGloKTLphiy6JNtlttF/KQb46faFXQDeP5KgdBeCn6
    70x7HItBLj+zqtRIJ8W/FRQu3zx+HeJdagMUVLQhLfG7esTNc9Uj0E97K/T+cG2u7KPu9z
    tDob6FASpCXCFDIavXHZugbOWHarPWT37AEabf6QgnweU87KCWMrmuWHG+kisA+F1la/QS
    LpFd7GAV3g7eybbOVOqRqLG3yLoUwdpFTNBixqEr4C0whuO7rPQQUkwHUFSaeZE4/iQ+Pf
    a+bOzP89N13YqRE7Ysf83Au4Fk2zxwapCi/uEEoKu7Y8+t3sw79xwnO8dXcAvofGGGrsxr
    /S3gyqKGeYXVRWuZ7hOb0OGyJ/LyC+e272N2k/VWtxLHA7Brlny4IKkToTug
X-ME-Proxy: <xmx:iQOfathAlH7BY-TLmTqCoPt8mVaOqIgTOdEVVV_2WK-OydFOrKJiJg>
    <xmx:iQOfanz0zWFgeDVICnJc5EmizxL6_F0B9Wa_C1DKXSH6eDS_KOOBmw>
    <xmx:iQOfarLPq3R1iQRaEMvvDKXA3DCtwjNNu2vfKbk0g_O_KqYg3Nst2Q>
    <xmx:iQOfas1B7eZjGVd8_iYJIcXidTBeOGWg8tNngjVbY_PxD43U5S3Jbw>
    <xmx:igOfasA-HIbX9cUeXjwgv7lo5N9Hqd43vnMiCxwIOpPgkRxDzXZV9yQg>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Sep 2026 14:33:44 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	hannes@cmpxchg.org
Cc: ljs@kernel.org,
	usama.arif@linux.dev,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH] mm/huge_memory: add folio_reset_partially_mapped()
Date: Mon,  7 Sep 2026 19:33:40 +0100
Message-ID: <20260907183340.1446132-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ixzq94shaca7ytqs5748mhruhemzwyzz
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 15A2240006
X-Rspam-User: 
X-HE-Tag: 1788806027-424160
X-HE-Meta: U2FsdGVkX1/hIwAwYYCcg7WVuPDL6bs9S0FWFjfUzvb8YA/n9b4RQrAFN6xyVx4Nb+EGRYuAAGLJlBFUDQFrCM7KwIsqqm/7MpfxurpBIoAZKl7v2pIb0OeRP+2yG5YDgC7KYycGbgGIkD9M/gfRHd990rgj4mBa14CFS7EPT6poYwsGDbhpz4+Ma4xKR6Mv9ryD6F+ht2cGeStIry7DHqFr47Ff3yHzh/m03vcJFWv0bytlJGDX7IpluHOrStgKr+uVR0BFEI+5OA35jeE67WjdoBB9LvT4jWBGuFrZGFGmoQA4rFbn3ncx7SLOqyFSKcb/mafkdRfsqDOaDlRm9iaC+/CQJ6mnhldp0jjxUrb8tPU5R+LlZKCnXWLBmYFh1Hfv7yg6Ln3KWDaQZUjaySLnTZdPQoOLDNc7qdB95GU02ifxquWM3XshAPvxiZbagKmv0zPaSwJgMAWCY7RX6hF86Lp7SzqU2ND4iBmODtfVq59mGEiCHMxmfhewpbP9RLt/utxL3XZlavBK590XimJLWZrdABI6ajpKT/wxVAm4uv5WiEuNZ8pyG1Np3RoOe4obEGFYO3iruJQ+NIawwnMTYVT3HkmFDy/KYvmPBl3y6P+SVRxQnVtoPaXqpGLQM/wJVreqJI8EOiKdAnGDWLwhF0N8ErJEGeXXexqDROfwEMNmtkqnwTYqSU0EoFAIjXo48wglnfpnXdxmlWc6mMzUpHFDnBpjSsVhj/YtMU3bMi40B41UL+JyVlFnmRN069xQPLRZ6unCSW2SLpVYg2rJjL1H88Z5D9/lIyLilDHNvxTA+m10AlB497qV86MZWPtstgAq3UkloQiIiYPOsQay4z6ZF6L9gGhf1hTXQ2EMYh6ejkOpaqouePPRi//TGApvN7xD+YB1B59TIa2s8xi+gUekI7qddempSpVEM0lBF/rZ0m8bjXm4FHqRDgMZqXVrFtzYkfR5Vrikt/H
 V1JfnJlX
 I0QnP2tgU/vTOyow2njt4SIHEMtfhZPCYlnOBSvIvprNxiwfsKRNHspHy+RIgjicVzRePLxmIT194mQVRcrpwb/gnfVqyZYV124rQotVhdbBzKxm3NmoiM+pMvjvpERSv0MWz5D565QVoRRdtzSvPQm2u2KeKs+6pqmEnowXM5/m+uAZpjjeoHv715al+Q5kCh9AIgHQy29cT/RpN2IUiIIghdJAD6sXMP0RWdSM0HFmgtvcO16eQExEcVGy6BrcN4N+pxw+UXZnZjITsIyzLfQz7Wi2gswcCW2WkvrZ4GGI8Snxy/NnCIu1Ehz7NDyidsdgjjyhNLCi3Z+Vwd/olapOMY5R1qUJTefPlnlCwaDiiJ/CjGgLjt3r4CI8S2narRj9jZedHA6nZ5IkAvcH5SBZegW8lrG5tJD3YJRgjWori/LAaghTi7O3nKNi/hoS8VbcP4V+aONA+ywENqlqZDAa5biGL9aNvUrZZRgEOHF6T6XsHVoH9ZBefOA==
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
Assisted-by: Claude-Code:claude-fable-5-1
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/huge_memory.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dd66c6ad5af1..23ef22c2b5db 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3972,6 +3972,24 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
+static void folio_reset_partially_mapped(struct folio *folio)
+{
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
@@ -3980,7 +3998,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
-	int old_order = folio_order(folio);
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
@@ -3998,11 +4015,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
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
@@ -4516,11 +4529,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
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


