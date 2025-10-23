Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 847E9CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 09:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11E98E0011; Thu, 23 Oct 2025 05:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2318E0002; Thu, 23 Oct 2025 05:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8AAF8E0011; Thu, 23 Oct 2025 05:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B28078E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:33:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C41488F47
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:33:05 +0000 (UTC)
X-FDA: 84028865130.02.A3D9F93
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf04.hostedemail.com (Postfix) with ESMTP id 62B614000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:33:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="c Fhzcu2";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=LCM9trZC;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761211983; a=rsa-sha256;
	cv=none;
	b=uIUncQ3iiTgf3r4ZzXZBTqzDv+0UjbcWPDrKBS61hjqecdLgGbqjCYGZl+eOtFtbonHnxl
	k80S14OCYYwYy0vNIqC5IVN5clhdtxZSfbIGU27uh2W9QKLPk6kpfdSvU6QMDv4BqpC6Gz
	zZfN4/qgJ5HOoZyCA0TLNVRzNaoWIVM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="c Fhzcu2";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=LCM9trZC;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761211983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ok4mnq2NNACQ1V+S0uDNcBIlKAcl6TkUg957YVuWVaA=;
	b=ftpVUbRWpa1u10eh2f9Bo+GkRmDoOX/nMnp8QJ+wamWgvkQiHnpqnc7rJXaw0Ijjno6XyZ
	qS/YzXOCx/VRMjcr9aP+WDqyx2tuu3FvItA7oDZvlNxnx1yZwMpwwrBG9oPu7tpVdYHhTH
	u/ZJdRmJzAbGkOQe7Sr17s/EyDlpZjQ=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 34F5313000E6;
	Thu, 23 Oct 2025 05:33:02 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 23 Oct 2025 05:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761211982; x=
	1761219182; bh=ok4mnq2NNACQ1V+S0uDNcBIlKAcl6TkUg957YVuWVaA=; b=c
	Fhzcu2XHPlMJIp+8ynL1IL70VNFTbVzhZgJNsRhgvKmGfujCLVHXuB+U+cY3EFhk
	ciRMd1AJBh7a6Kgt5y2yizbKmQ1b7wJ9Vv5ERMQ4s+G71KaXczSyTAOSr4LyPs12
	F6AohsGhU43C75T9lG7NLL3i45uT74mzoXGAdxgoiwFr4+JjMx1t+aCT1mBh44YI
	gy0NPSUUxLvudWyM9blszLhFKAn/GTr2AKIBsPhz6VxOrc485LAEBL2CvJkLT3gF
	Ac2TeUZB09sNfI18taQLvSZHdTP572oj6pQwf9SyaOC5sHHUjb1OOqd6++aAu9I6
	NEIIrfqIRUXPjS8x98HWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1761211982; x=1761219182; bh=o
	k4mnq2NNACQ1V+S0uDNcBIlKAcl6TkUg957YVuWVaA=; b=LCM9trZCurcWKdisH
	LkfAhVdG6vi7pZmV3manZ/m1fb4C+qTEhxF93nz9PI9eWs3icpnsKZ8u8ZsiXPc2
	GLgPUSS6hhjRC8KKpNZAbUM5cA4eqrMPK+EZeOnX7RtSj5Xyx6hzKZ0TMURMVlKc
	HWY5XAW2DLuQI5vySlw8nHnPRPlsbrxEZ3S2UwTGv7qlttmtB2sxVAAlhjTZ5oX1
	gignm0S3ePoClflysHCyAtBei5lpPim5hTTRD3Dqq+cUbzR1TIKmO3La+W31InZQ
	eLFrxihQ89YSkYBRfMSPUg8rjW6sy0Jkt3ayCq5sVNqdkALGgf68f9scDCQbkrT0
	Vy4KQ==
X-ME-Sender: <xms:Tfb5aMmyHFljBnsb3T2W25zar78VSSV4KWibHv4HCUUasEl_0CFZrg>
    <xme:Tfb5aAupddsLE8U8p1qCL9UMl-nOE39MZbcDbiriDac_N2T9NxKdmWpJ7Cev42B-L
    ilf2htyRPGOkTEn-lCAB54TMMl4cMjTSYsuSx-V_LO39rN4iY2prM0>
X-ME-Received: <xmr:Tfb5aIPsSN9UugIv3MurODpcwgqgxsyX0j1bXX1_yUiEvtAniegtq1NvWZZdpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeeiudduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepgeevhedtgfdvhfdugeffueduvdegveejhfevveeghfdvveeiveet
    iedvheejhfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    fedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfoh
    hunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:Tfb5aKo18UVhomkB2aK9sNqjotI7KT9fxU3Zf4ai2P_RtBX7uoXrmA>
    <xmx:Tfb5aJ_u6v5qW2M6wnTuOrPhfZIe-TQITOg0uwfxBQUPaPx4-l8jhw>
    <xmx:Tfb5aBq7KEciwv1RRBzv0Ez_k1lMiZ2FGqmzI-WTy-IEijjbuTUdNA>
    <xmx:Tfb5aPhFJjVqMhzMckii8yRXzqZUkW0GYtOHZo-bTcgBJPtnEBF5EQ>
    <xmx:Tvb5aPkcE7oDWD3GX-VIMa2dEWn5uNDjZMvEAEb0jt9WFdtzHtnhyM4O>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Oct 2025 05:33:01 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
Date: Thu, 23 Oct 2025 10:32:51 +0100
Message-ID: <20251023093251.54146-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251023093251.54146-1-kirill@shutemov.name>
References: <20251023093251.54146-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ait3wukpdfiwmigu887bzqfr988t13gb
X-Rspamd-Queue-Id: 62B614000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761211983-810770
X-HE-Meta: U2FsdGVkX1+7Hg0nktUcbpNorJB+xK8jCoPMzjSkyouICGsG9eJjqTGJefwByDOKGXgaySxA9+MayqPQXwGITPTotv5sTAGnIKnFLBrb8MTsm6YIouX8TlPuoCOzVqxZ/LjAr9AvhTplydmQqCS9StCZMxDzU1Zo655B0TLeKzgeeIi9EpCKy8pHNlm9mQ6kzwSkRZDMtUwyQ2tck6uAtkPL3PawKCp4vpGl8gqVVsCNNwBMLdtEKpqej+2poHqo+NCOIprmVkGV41nyFcdF8ghoiln9EqJn0zSEAIvCyN/a7vRsYf8q7bPj8QOUa0b65tiFIUcMU6ZRRhffgEkzmPAQ3xK5b3mST3PlPPoYZa7zAa+l+4+U+hWdM0Zaztb67SeArvXCkGT7moJBsbEGf+4Tf9uSCIe5ShSK4fURF9jQIvTn8+8kHCEsBjqmKZzsnzz4c83vEQEjrRwODeuTdVkmXyEARO0yXY06U4Q65OTvnUu8dfEcNrLubpp/734ohKeYfWIa6gcPdzZGBF1FkbEJjRMCVzXUJ9HNdD6O95iB9OFR71eYPHsKXOcUyE9DZCI9LJE7HMIBL3oSoGqFJqIE/fAmXaGi74ut3w4bkqEQvNPGjoqvIF+HOLuARzBjgqUI13L18e2OnT1haDYgU+ozsbLInKcRmyloBwsidNEUbtm3EpSbR8sMCMCP41BKStQKEMw07Ha2PGJW5gVuz3R41SwbxcgtVi2vvYeqD28U5K2QxvWnVvHIwikhvYd7bTbYuyURXQXer4BiNrRJ5X5QKhQKoYqLJcBeVh2HJ5HcGUoXSwOblTxITUI4lWa3OmXfRsHUEYSRclhUsLL+k4PjKt4+kjA9GBObNruaT+TofozlEqVYuo1GymmenozPm8ukCsXVxHftdWYe2oRUUSkGUUufa+7ikACvqvstj+kqqK2fPBbq2SMoZWuNTBaeGYjh6596WSYJPYtw+Iv
 1FaC9CXY
 oR7q+LHXla1q2LzM8zmUlJQm4Di0Xylj1vReuoFyd37zd2wR44bDLBZs5OzuVzeKzzkd1Hl8QD1+vP/X3AMiRK9YPhHNpnWORpshArTch9a9b8aN7ghu74kLbYVMknkQsUpcu5RKYMo8dunl7JIm/u1tbkTkV1nfHlRX7lqnD5+xkcce93UhlQe+yMsiRapHds49bMoYgGoo9J+pDXMMu86kOcGRXjY9G/zNcfDPk6dszGJFSkxiYMXynvnJo2rPi2lMTEkBSeAk2VAxA3OMUpcqxjXFuBYfB/Vdj/feUpzKYpqhg4r9BEk6ERe3FGKAo2Kp99+ySQih2QTdJXvLPzRInLMNJemlpeVKnqPgzklm19zpMjvRAUflOCCT+y0MddqjO0+y1BKbZChO7Sak+TqDtmNmHFu1DFcgYitPg4Zx4IhwKuwSPcZcBR+Ia5PU6mBzk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
supposed to generate SIGBUS.

This behavior might not be respected on truncation.

During truncation, the kernel splits a large folio in order to reclaim
memory. As a side effect, it unmaps the folio and destroys PMD mappings
of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
are preserved.

However, if the split fails, PMD mappings are preserved and the user
will not receive SIGBUS on any accesses within the PMD.

Unmap the folio on split failure. It will lead to refault as PTEs and
preserve SIGBUS semantics.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/truncate.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 91eb92a5ce4f..304c383ccbf0 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -177,6 +177,28 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
 	return 0;
 }
 
+static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at)
+{
+	enum ttu_flags ttu_flags =
+		TTU_SYNC |
+		TTU_SPLIT_HUGE_PMD |
+		TTU_IGNORE_MLOCK;
+	int ret;
+
+	ret = try_folio_split(folio, split_at, NULL);
+
+	/*
+	 * If the split fails, unmap the folio, so it will be refaulted
+	 * with PTEs to respect SIGBUS semantics.
+	 */
+	if (ret) {
+		try_to_unmap(folio, ttu_flags);
+		WARN_ON(folio_mapped(folio));
+	}
+
+	return ret;
+}
+
 /*
  * Handle partial folios.  The folio may be entirely within the
  * range if a split has raced with us.  If not, we zero the part of the
@@ -224,7 +246,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		return true;
 
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split(folio, split_at, NULL)) {
+	if (!try_folio_split_or_unmap(folio, split_at)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -248,13 +270,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		if (!folio_trylock(folio2))
 			goto out;
 
-		/*
-		 * make sure folio2 is large and does not change its mapping.
-		 * Its split result does not matter here.
-		 */
+		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split(folio2, split_at2, NULL);
+			try_folio_split_or_unmap(folio2, split_at2);
 
 		folio_unlock(folio2);
 out:
-- 
2.50.1


