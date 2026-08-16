Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F00C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE656B086D; Sun, 16 Aug 2026 18:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4F56B086F; Sun, 16 Aug 2026 18:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDAFE6B0870; Sun, 16 Aug 2026 18:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0B86B086D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2AABC1A060E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:54 +0000 (UTC)
X-FDA: 85108619148.24.9F536E6
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2C91818000C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="j LMSO2l";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AN+XvE2s;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4W786WotZ/WyKgbYqzGFWEVUdrtVlmGMAxyFOyzC0s=;
	b=qQJIVLrLkzzxjZ1gSStCmgH8XgJ1SoD6L2ixoPecJXTl3DCU/GecAmOMFllxDbBV1pPPMh
	eNIp1zUsXswmLCo6uiuyKjx3ijeE3vqEU1cuFtChddOK+jTCvVtBLEa7nnnXpeaRYWWAZD
	gcsoKggdoqa8NSofIxhK3ReyuYhza9U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920412;
	b=H2EGE0RDwMJf7t+BRWD6QcE6xh2rtP3zMeemr/NzixTE1kOnkH9I8KuOoBR5Z0tRZY04Pu
	U/Xy6VxjTFPFXhx+Wpc26nY/97Lar55r1iI+MpeKtOTgCJPsOq4YUG9laSVZ20n+ZT9Ok8
	FsZ8bj+zeVjXAvbV0p18rjACPjW1Ogs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="j LMSO2l";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AN+XvE2s;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BC4A214000F8;
	Sun, 16 Aug 2026 18:46:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:46:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920411; x=
	1787006811; bh=R4W786WotZ/WyKgbYqzGFWEVUdrtVlmGMAxyFOyzC0s=; b=j
	LMSO2l2Tkn4IFDjiBFITPmcvC6gilrwaaIUKad64wuKspAqfgKmPLxgHAtwpa0hd
	Cowwi8p0wmo+w5zBptY8Ar+2SYh6//rz9dekEMx4YM1ZaVOriFY3an9e9pymOv+1
	YofpPsXPcvoYHiOzqZWKpKup6k/TZkYlYUaNCacAi8LxUdpP84uzZCGZrkr+0mAd
	R0Tpi0EsdDPp+GtcEbsqHxPGWXADj/Hevv9aOrFShhPfPkhfBhzdpm0Vd5HdTI/4
	K9WAEMZMBV2TOqaPEKjVHO3x2pLVEqMrKyZKOdr3KPoPezK+jKFoMzHLT9jRv4gD
	bHzZ2gjchcdyi3WtcFZWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920411; x=1787006811; bh=R
	4W786WotZ/WyKgbYqzGFWEVUdrtVlmGMAxyFOyzC0s=; b=AN+XvE2soozc02UQ6
	wFmVllwTbQ5Hiyh809UHjROYJ/bfJWm0R+R1YrJ6BMm1fga1TsbOfKwzaMdWKko4
	GmFoiO1TDchv7Gaoi7vs/pE+GqZKxfdE3ZAkzxZh2HWUjleFBFkBqYQcEdGSKJXg
	qhhaIHDp4B/RE+5pid3tGDoMxXtqwW/4drWZ90ZiIvDFthbkSjAH8kybytaO2mTG
	aGqQg01TnMpLOtoV4fY/qTjS6OPwALS7iCEccaVQ1Wlf68hGyCAEW6lyO0CEjGCc
	cQjpQNncbF3uVOUbTvHYDwk1TX/R5KYv+zCq3gc4cmZagzB5xnLGenLWzaQYQfTE
	GU4BA==
X-ME-Sender: <xms:2z2CanFEDxIrpO-1GXqx2wHMSV_nIfb0du0Z7HhRcyZs3SwH4H0bXw>
    <xme:2z2CaprfnEhM_5TxSP4fo-E_rqi6zMdmRQFEOEXgdV3O-Zh1Ed18zr9AMHrmjNOP0
    Jt3vjSKRuaME6HdkhsC7EyYFn38e7YPqGTmUwXrIgBnHCdQXMTxDs4Q>
X-ME-Received: <xmr:2z2CalOIdebOqG4ps6NCa7bQ0_u-GZABzSHNhFWUUsPzJbCaJGPSguqMRBU>
X-ME-Proxy-Cause: dmFkZTGU6CsvhMdBtF1sno4coJRY9LqZz27w5X62/KcvcmaHPoOW0E1BwYMGQvImxADkeF
    Vrd/NWvQclh95CfVK4mxB+x5IwibSBkynFlxvp5GF5/z4jepOu57IyLHUvB8DzXymwpMun
    cyoWwWLP4hjAaD7bSTsoDmYKe03ryBERSg0IuR8ZqJolHrsaFnqWf5mL2byVsL9qLL9zPI
    9yLFlvwwZlCiJbT4IVFlRVV/9A2lZNuDFrGWvpQWw3cjqX9EcFrpnMQcn/0MdQygQWXSYC
    yXHZy2pRvgBssh5qObsL1GM1XSEE6m2uHX2m5CwJlvTSIfOodU1appS1XFI/CBVlhtQ7Uq
    ItwriLCF+51TbxcwytB+TuK/breu65MYkkuLOzLs+ujqeaqn/pevMWVPqxiCoRFuWTt1yI
    TxkkSazc/sdb4Gg8JwC+VYHvOTdGOHidP4yQvZ0WzHzRxfXn3JCvWJI5/w7HnYISzKfmf4
    lx2xOWgTIQD4t8lfY1ZHKlwyJBrXBk7m1l4H44gDmSDmr01V9EJgxP9vje8PjesT29WW9U
    Wn1swMWva1/FrKKdWnLsKPlXMe2VAw53yMdNbCjFGXO01sPl+lPJIorm93GO0kVZaGXukD
    Y0IOMQTB7hYFxrqc7rQT1O08VIOytVqdHlzChlJ5Y0HyJoZFd8c5dXbdQXxg
X-ME-Proxy: <xmx:2z2CahqAljzrfNM_UH7fc9C4to-TL2lALgfqWmti3KzuuBiRCQhNYg>
    <xmx:2z2CajkohaZk1YHK0aMPQyIQ67FcNrj4qGlrCqhIRQggPvs2NVthkw>
    <xmx:2z2Capx0Yhu117OnSDjF06gvGO_oJi7i6zwFeLNTcM15wpcXle6quA>
    <xmx:2z2Cah0jSEKwYJFuMH1YIZseva-ZDSrqF7FZPGAKPhUuTQI7NWtSdQ>
    <xmx:2z2CajYP-3lG2FKhX9WkUeRBzFrVwLoHE7TXuFtPCyFSlE7NLpL2AfGm>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:51 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 17/57] mm/collapse: copy the sources into the destinations
Date: Sun, 16 Aug 2026 23:45:29 +0100
Message-ID: <20260816224609.308019-18-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: b7ie1uuwiyp3tepd6n7jchcpspg9t9h1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C91818000C
X-HE-Tag: 1786920412-944789
X-HE-Meta: U2FsdGVkX18rZySIKn1WWEWJGc+6k4SltjDTov3AEIkD45c45nLtWI9+tW891HSGZ2pSKqRlCZdkibk1LMmdGOhCEBEOLKClycn6ap0vejjyzxKzLz2Xvk+mzmKZhoMpObrYPYY9yOypC4BK/QjN8DlGQpDHAlBIFolxGQTWevki9lFY26w/w5nRdGha4u23NqSdOUaAW8fsuKEp7ismQ/6+oxhNurL3ygoGuD/RX7qIlkZdZAj1Tt7yKe+YN6e4bQW7MScMR2vVq6r74w0mE26yFRAhU2CoOvNXxB16mJs9I57P9Gjv4co+6geV3uD98kq+YMWVSP07Cjwur6UPJN4ecrVl0DOgAa19ppCukrbJLGewROQV5ilcJAhgSCzF2qND6EaiutZ3+53Mtf0HpYJRprxq3elRpoxGuitQF8W8EKEIULryAnrzVlA6GH3vfxAG8scdURxscpuRD2zuMZCaM4mkxz9uL7n1IU6522WUyV/g7MS9Mvja3G+M2p2hzYFSUy2vIjBXd5mWI5+uYtrA57Evy/ilOIAAxFp9Om6dHVeItYy2iMLenutfYfHzgZS9/GzbTCKIEPjhiKqIgIQIUzPqwg5Z3SPAa++QLf/Wq8qdYWgRbpTsvl64S4gO12LyC/Y9V5NUUhMnzJF4KZX5XDye7ljkGMA3D9AsmgcvJXU9JarlABhZShPMUMwt/qPW3sLdC5tWqNZt0crMIvccCvHZIOLofFE5JWm8OIygUqiMhlplTN5Em20P1WgzLL+9I+J7MfKyKgM3C5uHAWLMNqyLEAvI/pvpJyXDc7M7/meSKi+CF5n3MAY3GvDsQbbLrxIugVssxnhFXxyg552LkTNxdarEKqGAFKL4d1DsIcI+qi3cmbbiuWubtc5SaCxpY5cO7ViJDTwn6u9r6cJ2MyW+SNGqcMvyPowF9MpA/BIqWPy7siY7P6zI9Q0sxcI1gFxkL9Zdkgz+tdB
 zENiFNYh
 u63+w237p1bsuPB6HHfdO7YaV8eyTdx/AkR78/L4H3MbiduEBBzdcoi3OtXdr9ZaNqG7r86M2G3kh3S2AxMZFCfTRjVm06ckyaFkotfpK2UXIoKpacyzuYcZPYsPUD0yHu9J4IQLAJ8Zp69XbX1G3pDlIC6eOqLysIPBfKSJvHgWZVEbelsiXT94+kLz6NPnjUhzh2m4h3lodJo9dx/D2XZRr/uteFGPMjDoAwkOYY+9NUODDC3QA77lTl7YO0if3wfQ440hmOAypR/9+9viK0AHJ0sXojfRUhxq8oTxHRGPTUzs/KnxlR/p3oK2Ts81TpT3DxQHKs2y0045veALvYy4vAHCt4tHICE5lCXgh8KTQ6fr5HhERvHZVzhqxl4ri11OVuxp5ZA4Zc4VESSdgLzovg2K4BI/0dKLZJbvEeMaXV0DWsQpXrT7dKsukAdNSIVRpmr356eVpsbtPRoRd+v5fyK2DMInDHKNxk8LpSalDH64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Fill in the copy.  For each candidate that both froze and has a
destination folio, the page mapped at slot k of its window becomes page k
of that folio.  A slot with no source -- a hole, or a zeropage the freeze
cleared -- is zero-filled instead.

Neither condition implies the other.  A reserve before the lock can leave
a folio on a candidate that then fails to freeze, and the provision
inside the window can decline one for a candidate that froze.

Nothing else is carried across: the destination's PTE bits are not
derived from the sources, and the install rebuilds them the way a fault
would.

A machine check reading a source is the only failure the copy can report,
and only where the architecture provides an MC-safe copy.  The candidate
records SCAN_COPY_MC and the install undoes it, that being where the ptl
the undoing needs is held.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/collapse.c b/mm/collapse.c
index cf2b9b3640ae..a3882d897d11 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -1040,6 +1040,46 @@ static void collapse_provision(struct mm_struct *mm,
 static void collapse_copy(struct vm_area_struct *vma,
 			  struct collapse_control *cc)
 {
+	unsigned int i;
+
+	for (i = 0; i < cc->nr_candidates; i++) {
+		struct collapse_candidate *cand = &cc->candidates[i];
+		const unsigned int nr_pages = candidate_nr_pages(cand);
+		unsigned long addr = cand->addr;
+		unsigned int k;
+
+		/* A folio does not imply a freeze: reserve runs before the lock */
+		if (cand->state != CAND_FROZEN)
+			continue;
+
+		/* A freeze does not imply a folio: provision may have declined */
+		if (!cand->new_folio)
+			continue;
+
+		/* Each source lands where its address puts it: slot k, page k */
+		for (k = 0; k < nr_pages; k++, addr += PAGE_SIZE) {
+			struct page *dst = folio_page(cand->new_folio, k);
+			struct page *src;
+
+			/* No source: a hole, or a zeropage the freeze cleared */
+			if (pte_none_or_zero(cand->saved_ptes[k])) {
+				clear_user_highpage(dst, addr);
+				continue;
+			}
+
+			src = pte_page(cand->saved_ptes[k]);
+
+			/*
+			 * A machine check on a source is the only way this
+			 * fails, and the install is what undoes the candidate:
+			 * that is where the ptl the undoing needs is held.
+			 */
+			if (copy_mc_user_highpage(dst, src, addr, vma)) {
+				cand->result = SCAN_COPY_MC;
+				break;
+			}
+		}
+	}
 }
 
 /* Publish each destination folio in place of the sources it replaces */
-- 
2.54.0


