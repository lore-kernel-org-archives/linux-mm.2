Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83258C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97E56B00A4; Tue, 14 Jul 2026 08:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3196B00A5; Tue, 14 Jul 2026 08:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC20D6B00A6; Tue, 14 Jul 2026 08:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B11D6B00A4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:24:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 185F1C03A0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:24:04 +0000 (UTC)
X-FDA: 84987299208.27.373E1CF
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf04.hostedemail.com (Postfix) with ESMTP id 347D84000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:24:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g 9YR9zB";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=fdytN4SX;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6UpTAWsFeahWyNfDB0LFkzQxhy7tot31XOnv4oxF9c=;
	b=niF67KkRu1ZBfib/dsyB5WZGJZao/oZdRe5vWGeI95jHL761Z9zjD42LMxwohsUtn6SrK1
	/i3u60F8a/fMkxAMLHpZBzhkzSxNVwQAiqDLRBEa7NFRpb12ywEm8MIwkd7v32+p1dPaen
	7Y8rECkJE5LLY0Wfkc+he/Rppej5p3c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g 9YR9zB";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=fdytN4SX;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031842;
	b=59G3vabOYZbdm53MLcyV79tOdDR/7pTomAU3vmpTsoZ53ec91mPnP3RH41HOQuVLGjV3kF
	cXdcvxRf+/iV9e0vJYdHnU27KYWeJxr5P2zM7IyCOsmNPA67IpiQBFmwbyUVTO+66MLnR+
	AikiDA4URgQjqekHRT30K1hb4Uhjweg=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 225607A00D1;
	Tue, 14 Jul 2026 08:24:01 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Tue, 14 Jul 2026 08:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784031840; x=
	1784118240; bh=C6UpTAWsFeahWyNfDB0LFkzQxhy7tot31XOnv4oxF9c=; b=g
	9YR9zBoUn5vEZwn7jAqvVGjWyvZBcAsJ2siLRMaqe8pZR+MYZf9Kppdf89eY/S7B
	r3geHXxegLzSGDnwRvXfbsHCC+N+3wF/4zloSVmpbm2sgFoTuwdmrY2HXyk0EM7j
	SWo7ID+WfNzovr1xOxfPbsKLgnQgf6XimZXb6ux1/xO0m3ZloaMPRZnXnmCN6IUi
	e7BET5E/7J1YAMkFb3ot8FOjByO6P/DZPdCivL3WhmW5pbtAFgMIu/GB6h0hOk8q
	d+zNvrNCz3VqSLy6qEZT1MyAKOkHjrh+j9MmQW+gKR1DMVAu1YZR8Y76h1mPbyf/
	L45BpiXG2fXteIKlyZldA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1784031840; x=1784118240; bh=C
	6UpTAWsFeahWyNfDB0LFkzQxhy7tot31XOnv4oxF9c=; b=fdytN4SXJWjR1ZNB0
	aaWnKvfT0TtVekmQic/lRZSRr/j+4AUzjkBrFmP74MCK+BunoL5cIj4/uru0oFMr
	cGYsFIIOaBJl413nAoEHy3vu2ZNY/r2thAYS7qaP2icbq2fWDsnsQF/TlqZMdKGa
	QPvNq20GJND4zB3cyWPOJV9CdsAwcYkE+TKApbWkxDoGeYiVE9uFBcjotiKDFiDi
	hWXDrNllz6ZK7t0dYPej6ksybAEwC/ZxfX6irmtiCk/iKsVYb7O1ovp5rfi1mykL
	KwQKMFKPxJy4PoWM4OQ76Qirdd9u6NgXgmxjl9c1YkNyMILPDEYtS8REB/CCJXuF
	9wyNQ==
X-ME-Sender: <xms:YCpWaq3wRKc899haY8NwVpMZnu2rMaTOQ-tEkpl3x9uhMy8gQFkBGA>
    <xme:YCpWaud-LHBiw1P4sx9KvPIvOOkt-tdd3TxRncRSCE4NfgN8OktTURizGzCUcswn7
    zR3hejaWCqVxPLsX4_7OLQXmA0yybDcNNAuZCDyI-NishhQlBgsHEae>
X-ME-Received: <xmr:YCpWasJRoKfhVK5Gl7bfHp5v-04JDi0CmjElMpiN7n93hCOWuW5yZ-FD2mTXqQ>
X-ME-Proxy-Cause: dmFkZTFMICEClsb7Ov+fedgnp0pMqXO1FfBD0xvZZ/V6P433GtqExWJyu3GARbG0/r6UJr
    Vf8nlq0lv2eCRUGCgAvBzEv5gE9KqzX1y7uFCtcvkB+wk1F+H1pzvrmeq3ImlGsBni87oI
    /YJqxi0JFt3vGMbm+u361lX7c8CBMgJ1ybWe2KN/ei2Wm5Kh7AGZP5ET8MkAeVDldf1ZFf
    llAd1ziCU3FyBV8QCjXQzkJyi8QMxgwqv8RzxuHH/6PIE1w8t3MzGVjuBE4OT1E4WpjGBL
    sxvt+r+K97QKtnJqN3sNNbSNEnM+m+h8tV+Tsxrhb/vhMT9muSuzm8yJyy59nX9YgO4xIq
    8JvdPz/A34dtAVWALsPwuK97tFYQYhFp31kZEmmjGJuUeXCBI0m5Nch6OUvWOayLWsgRLa
    RlK4JV4IxXE0M156J79JjPDgKLEZ8XL/Pnj4F9uusy/yXm9x+b0yKaHyTAM8rOdTTwEM2i
    t1mM9c3kiVCYVnmjx5mAMa7GIMwyolnyOc0kyYLdz/E4TC15j2XNgwPPtLe9Xwsyh1l+//
    wx9INC2DX85BZSsUGZ3PBYm5BExagwj+/YGLPfSGOx9n3dbq7VcZfCRu4+t4FnCZFVZ8wc
    fN0KoejQLe9WN7WKDzoGXJNXotrnj7V9ZhYnPY2ZLuhavKHQasNMJPZSHg0A
X-ME-Proxy: <xmx:YCpWakHShQehsrzSefI3No93NmvyC3TNfZDfAMPgdUpSxbZw-yTvMw>
    <xmx:YCpWaj71crYQ6tcgjVcogeiuAvQ9MwZCqPFcB_vY9RA3DkH3lQIB-A>
    <xmx:YCpWav18U-UuelyVt37JdTTGjXqtz9ZBTZrrJuJu-E7EnT6SFi2RXg>
    <xmx:YCpWavjXAvjptM2klsOb8WWh22xxxWQtXT-or1ub-XhBVbcBxsG2NA>
    <xmx:YCpWaq0yMuyrhAltEXFRvu_tLB0Kd_8jVqjdqXd1IAzphns0I38xeCCA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 08:24:00 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Hao Zhang <zhanghao1@kylinos.cn>,
	Hao Zhang <hao_zhang_kdev@163.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v2 5/5] mm/huge_memory: fold split_folio_to_list_to_order() into split_folio_to_order()
Date: Tue, 14 Jul 2026 13:23:44 +0100
Message-ID: <20260714122344.351895-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714122344.351895-1-kirill@shutemov.name>
References: <20260714122344.351895-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 347D84000F
X-Stat-Signature: o6mwujin53emft48qf6tkg8wpfdgfdst
X-HE-Tag: 1784031842-442287
X-HE-Meta: U2FsdGVkX1/ypZg1XDGWwW7VHXmghOtDf3AOCrEYbPtwUzDgXDDGGUswnHiBx4GFl6w6v2aoeUiqYPc35qDL+xOLEkLXApmzezGHbel7/W5dW1nTiPMC0c9CDFPkb4lZhUvZ+EjTnSQRyEdbsA/cntRHr+M9krhiwt/gXCpikZcC+GSoWSC+PuEVznasEkBIwTp087hGbXWumatSA0H+ak2jCvwDJk2WfWxbMCwa3OQ2EU6/W/+NspRiBIDbgnnps579+FBZ63flkPBGbtlcGyzuzLlxS8K/Rns+g0oj6uMaxYX7LMe0V2ATc4pV/gKBr8/HYQhGX+BXFjfDaD5YWU0+jDtD+khBOw2mJphLEif7w1y2BUe3sblVP9tQL2+qVoqnsCMTrbJ6V0ABILEb55OqdrFbI9c+E0OtW86HtW77rPCx+2cDbA0+JBv/s3ekut+UvX/63spc+Zk4Q57wUeU+6hgWG5rj8lGzSi84sHkuLBaFBoG6QkXeNGMX3kTxsHwayDa5300vl/UNoz4wWH7EaDmldj21YxeRbZ7RD4HlE6k8/1crAk1FygTVitKSnFEu2BgFaqetKbTK1bPB9jeAJtjazbRP/1UqFEF5xbsGGzfERv2SsMK8XVSlu4A6lMeeW1PtPDa9KBLffh2+DNSFjBRYZ3Ba1rRIa6bqHG7j2OKr7EBVgME3fle0DbQ2rZLPRfZqEyzO5bkl0JJL7dlxC3nD3PNI027dCnG2m88zSyOV+f2L3cVmSEmsUXRaOoWDQAuGPxrBE54XgApApXlh/aPoAnm6i8Vhh+4lYQtwykC5jscInb605cUXOmwnZBBBXNE3EFQkyXp8H2wSxd7ZJzCmmW1fiw+XHKbD1rgH0+ga/Y1jXWSeIiji2A4xSUiNC18yIRrNEri8QIDGJ7+eKxP3RGU103UB9pF5iN6eOdvDr6E5RskxNEbIwhHP1GfhLIQWPMflqdpm4kZ
 eHD56i2S
 egdiv+VyUwEPIwwHfuj7ITw4ZRkqGR20Ns/MgYi79MafcufHtPw8NnSA9ruuGCiFcAp+7wZ7S8T9aGY1Qz2hS/ZiXJSpqgKZ8/sf9O/iwqAFxlr5PkfOmxri72igjJC4F23iJtT2AEat3T++1uT0tuJmt+1VQOgw51HyoxU5APxo6XAtIdzRwW8ElT3oskN3WTUu+P0f3t/lEOSKUjW4KH+q81G5jlPw9zYozVEjyyHmcWYgA/1ju1y4zFeRgOusU0FhbzKeUa5LZF7Ah0WCvWuiPtFxmRXjnyNp+jkBrCCWogMEZCuPkMbTY5Vy35BI0Ztoqmz9oCidCoaezNZmbTRlm5OK48nc6i5kghS3vTxE78EzdW2PwN2T5glovFBEq7F4aGPQEuerEAUq2H0gX2+S1CZLr3TpgDzrnRZbOs+yEjxIoHnSG+CPSZNEUWzOjUvKJ4Ow1PMePKNS+1NBzBsaw8kJV4Kx00qeQsJufKNutvwCxcUMoz4Y2W2uMtOYJ3ShJnea03sX9cQAWWE4CyRRg2YWzcQxDd+ixE0sxz4oiAHRLPOrDRbB56sI55Ut5PWvN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

split_folio_to_list_to_order() had no direct callers; its only user was
split_folio_to_order(), which always passed a NULL list.  Fold it into
split_folio_to_order() and call split_huge_page_to_list_to_order()
directly.

No functional change.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/huge_mm.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a38db095b5bd..8a10a886e62a 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -783,15 +783,9 @@ static inline bool is_pmd_order(unsigned int order)
 	return order == HPAGE_PMD_ORDER;
 }
 
-static inline int split_folio_to_list_to_order(struct folio *folio,
-		struct list_head *list, int new_order)
-{
-	return split_huge_page_to_list_to_order(&folio->page, list, new_order);
-}
-
 static inline int split_folio_to_order(struct folio *folio, int new_order)
 {
-	return split_folio_to_list_to_order(folio, NULL, new_order);
+	return split_huge_page_to_list_to_order(&folio->page, NULL, new_order);
 }
 
 /**
-- 
2.54.0


