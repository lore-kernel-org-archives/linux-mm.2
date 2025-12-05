Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 068BDD3748F
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271446B02D2; Fri,  5 Dec 2025 14:44:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F1E6B02D4; Fri,  5 Dec 2025 14:44:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB696B02D5; Fri,  5 Dec 2025 14:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4D366B02D2
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A24D487813
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:13 +0000 (UTC)
X-FDA: 84186443586.20.FFAE9BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9479D4000C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kl8VTnLQ;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hbYeoWk2VhN10FwCdrKatDYEgBulLthK5tu5SS/SIc=;
	b=MjFXJRmL0QxIaTlaKyQwG2lPcMLV6Atwcmjz//OGJ0ae1BqPiOlK9pCU8c11dIEtUUMkvQ
	yEvZEp6sbTyo/YthnJgW4QR9TIaTqSv6LKKYMhCeFoVOOXisX39/1e/4L4StdtbcmWfuqp
	79iIgoS/PAdtaYUoBTdSEqfuY0X5P4U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kl8VTnLQ;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963851; a=rsa-sha256;
	cv=none;
	b=DJpPMu9+p9iOoSZERzS6Cc8JiaeO50YXj0wHflk5s/fquad9SUIWTmxsfgCvitzhjCq88a
	bHu8aySjw4gj2Aw+V/lB4w3U1gWa8Tc2Qr+LQNKRcCTa0APO4G9GkNYI0iAGbI/p5CJnMm
	EH3bps/PIqjVAOIUQ95/NoN85dxRsRc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56A814333C;
	Fri,  5 Dec 2025 19:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD04C116B1;
	Fri,  5 Dec 2025 19:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963851;
	bh=e3wrkcKXK7At84UNMrZ9gGBzqGquM8K+OStBHfBuTTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kl8VTnLQf1CWis52kXFpH9Tk3Fb88PBP53VJFp6pMHlJH2GBB/DQdaE2v7wRnTXNe
	 47c64EZg3f82AC28dHXx8hyH8rIa+GHLmTpriimcwx2/ZJDAMf4T1j57QSfTJqiMsZ
	 MdzhtX/7wA7T/J/Q/2VgSjV15EKVUYWJ4AO1kKX4cr9KDebNt2I8RJm/E5qZ+oSQ0l
	 Iy9ZD2UcOXdW50CvOM/jqsp/SoX75Qu8NBhRGYv1Xnl0O0c6p6R8Rw0eqLS6exIOf+
	 OTvgQgHByDjl1VQ8kdA/JSJ6NHydxSwR1H4+LPJ6If/PzzNenmBvHsjbCFweT8lqMm
	 a0m2I0qkVO/mw==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0C816F40070;
	Fri,  5 Dec 2025 14:44:10 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 05 Dec 2025 14:44:10 -0500
X-ME-Sender: <xms:CTYzad8sb67eQBQx-cZwL4F43ilnP2bfV7OU2er13Ily2pEVUPWOAA>
    <xme:CTYzaTEMVUmrLUxSSgKVvlbLXgxHtP1JuS3zPsIkl24IqWOmzgTNYqIjWjKBHbG-l
    P9c7f_owcS8IZL2AfLeGweo8FP9maxwzYmM_pxtFTGH1_z8SCYqFNg0>
X-ME-Received: <xmr:CTYzaUT2DPl5815X4J_4uftIYP1ElgNHhb6HMyBJ06ztmyaECiNJkegoRctWvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdevnecu
    vehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmh
    hutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpd
    hrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghk
    rgesshhushgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorh
    grtghlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:CTYzaZupbLLz3jgKuYSwQgA4yl95OHAW-hzzSJGKdaczvBBPluE7Cg>
    <xmx:CjYzaZCCL3OPOCUZ4PQyE3DCOH51OeGX5KCqfhza45XXHN1yeb5afw>
    <xmx:CjYzaedUKwwllE6-6__bGegO4IBvawXgiN1dclM0hCe9GF7FmPZQ9g>
    <xmx:CjYzaZoCnmU5yVdjivnwZThyZ0GkmN3XYMhTRUwWqkDHj-VKOyy0tA>
    <xmx:CjYzaa6vS1FfMoHWf7gzcM9rHXuA4inT2hDnhmD82q1mmUsk5kNyRVHW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:44:09 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Usama Arif <usamaarif642@gmail.com>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 10/11] mm: Remove the branch from compound_head()
Date: Fri,  5 Dec 2025 19:43:46 +0000
Message-ID: <20251205194351.1646318-11-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: krfqgedgu7dk8dk9xdu7sz87jjaqxx5b
X-Rspamd-Queue-Id: 9479D4000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764963851-296721
X-HE-Meta: U2FsdGVkX18pkiVYUkzXJOg0c5CgPgtY+M7RFQ+vujBqPHp0DVX+Yrzkfa71C3mrmGpAJEQ6hLoI5y3TLfRCQhNwnCWqJZvyuMcUTHBP4XsKIvDijUxeRwn9ZyYjyQYP0NPSlmgtmFXFGUlGtCNxDYAyDqavVQvFqgh5nhkRr+RuzSOS1dDyWHcR2ddtgg3ah4deYpoVmPgZI5dDyVgL2BpZE8cbPDtVhupeeCrt0Co2aDQ17fMS017JUxd7CQVAt/8vhKL2ppiiFMW2D5WrlsXUnkmhmc5Mh84eAshMxfxmZbOUEd5hUh9lcp1vPs1ZYVaIDkdhOHAENA7DqT/B+CH+shslUIgwu2X56F6RMpfBhvPOvo7PKnz9ltZlbx5MYAc58il8oUcZ7+qcn4/tIAfcfu1fm/nWWW9CsFnDnl1G16CJF+G7SnV9R4KWAHsQo24L/DoyADbIH1OiljcB3vG2r02LmSZhe+3SFEb1zQFDNPz5V2ywOcnBJ99te3npZFPZmaO51yxzjKKyxrvjOfFETFtOm3Y908qWG8axoHrc7apPscdXNFwKb47S26kUvPvfo7l2wH2/xVN802akRSXmuUb8LDQS3UdWTISfxTqlz3qTYPUAK+YTsiTocLZE77QV71cLnFaJ29LWxg+lqlVKvCZIJGhplx0ueaH8wLfoj//MAWu97snWYwgHxysZ2K8k28XiKK7hWDzEsmKHOWixsgAeRIEt1Ykr9k+IPC2Zt8Dp8ZWFwEs725wsnlB2BAV5rpiJCX8LUOyWCTuiTKzxri9QGW1WuBMaCWvs3u1yQh5thnknVO5h3T8+/oV+RBkiPC4bFpfSCwm2Pcc4lBJGZ9AHfCJVHE1EvKh2iV50UQtkZS5CFTFSz55K0UDtjcSkVKqCKK9g1b2yy9qSbvx4i3FDDkFZdIdmDec8lJnJ44AF/veEwB/uO08K1Jbb5vZ+I3DS98tsSp8ITXX
 NXzOshPv
 o0mi0PQozaW24wYXFdMRs/F5ASeEyZWZLwrxY3w+p2fIANAlB6Pe+TLTMeL4b2fQ/J3xPL64HYPikQDBvvKbJKOCfCU5FD6hglNWkSiEFovmxfzdkQDNjbmRd1AYeSt07pOrxFy9vRrDKjNzabWsfJUFmQaXkc3/Qthv3Qvs4/89jo8e2fAqX5MKE651KD5h9rFIuV5W1PqO9SSDWaFD664QRriOHLiSck84OcByhBncjPnG+lxSVp4S3WRc80fcwcobF9h07DYV2WKXclQv53oO5c7FRYN6hnWIMjI/qX7f5x9uk0gT0do0XSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The compound_head() function is a hot path. For example, the zap path
calls it for every leaf page table entry.

Rewrite the helper function in a branchless manner to eliminate the risk
of CPU branch misprediction.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/page-flags.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 02a851ab7f5e..01d9893c4bd8 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -201,17 +201,15 @@ enum pageflags {
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
+	unsigned long mask;
+
+	if (!is_power_of_2(sizeof(struct page))) {
+		/* Bit 0 encodes PageTail() */
+		if (info & 1)
+			return info - 1;
 
-	/* Bit 0 encodes PageTail() */
-	if (!(info & 1))
 		return (unsigned long)page;
-
-	/*
-	 * If the size of struct page is not power-of-2, the rest if
-	 * compound_info is the pointer to the head page.
-	 */
-	if (!is_power_of_2(sizeof(struct page)))
-		return info - 1;
+	}
 
 	/*
 	 * If the size of struct page is power-of-2 it is set the rest of
@@ -219,8 +217,17 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 	 * page to the head page.
 	 *
 	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 *
+	 * Let's do it in a branchless manner.
 	 */
-	return (unsigned long)page & info;
+
+	/* Non-tail: -1UL, Tail: 0 */
+	mask = (info & 1) - 1;
+
+	/* Non-tail: -1UL, Tail: info */
+	mask |= info;
+
+	return (unsigned long)page & mask;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
-- 
2.51.2


