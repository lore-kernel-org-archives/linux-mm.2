Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D24FCCCD1AA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 16:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B3D78E0018; Mon, 20 Oct 2025 12:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EEF08E0002; Mon, 20 Oct 2025 12:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569C68E0018; Mon, 20 Oct 2025 12:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A03D8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:31:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F28E286242
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:31:06 +0000 (UTC)
X-FDA: 84019032132.19.F77170B
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id 060B318001E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:31:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="e sxEoVP";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=EgFwTQ1k;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760977865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Xy6EWOYD4UAz4zp+o+bvixxHmLQtxXlubeiPFw8ss4=;
	b=K+PIei1Vrydvx9xwO9kQ1bQ1yD/HEXQ888bzVqieHMzrDU0o4HiTnIQzoxRhgFxejJiD++
	uezinMROp6Y3MVamkeKXW/4qKSvvXjboIYG/AgdH8yTmBgzNrgKe9BXZNzAssCSPO4dOCq
	elHETUUiXiXGh76mCmJmuIlaieYEon4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="e sxEoVP";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=EgFwTQ1k;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760977865; a=rsa-sha256;
	cv=none;
	b=jnTk/tGWSOojtriZ4sUfNNm7vpsoYlwRrwOjO0xIAiXb6SGvP4TU2D+mrioukEw/u+nnuN
	/md1dl1EDKWUuS9Qnl1KCQysP9CaVouARN54kw8AZr/gUWiF8wJCCYlkOXwRRxVge48KFA
	JtleJNuMdYaPeyTsJHj0sAfg6pM+j7w=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailflow.phl.internal (Postfix) with ESMTP id 75CC913803F9;
	Mon, 20 Oct 2025 12:31:04 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 20 Oct 2025 12:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1760977864; x=
	1760985064; bh=2Xy6EWOYD4UAz4zp+o+bvixxHmLQtxXlubeiPFw8ss4=; b=e
	sxEoVPSi2W1xtgJsouEe7y43NaYbWy5g3RqjYy7jDiU3mA7vupLMXbQL3rGi5EfL
	oveSQMr0pBDuv4oDdKZUm45zBtVdH4x6SSRU0YHcB/UnX/PS4kDL+xaSPKmhYi1u
	aUmuhsMN1kVohnLm/cNGHaR9vXwcOi8WGV65OGg3TLvFFI220PXODyf8UxYHRuf9
	08OfFoZp/R/+3b+9crIcqRjlVjcsrRFjbAmDVMreYAy41cBTheaj2XDLE9Z9wyvu
	SCrxShTK/R+qXm5B9LpO1LP5LZoM+Tdy/qXFFgKltPuAVh7i18P2Slt1BLu133aU
	ak6Q3AIjVCzW/PwguYHWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1760977864; x=1760985064; bh=2
	Xy6EWOYD4UAz4zp+o+bvixxHmLQtxXlubeiPFw8ss4=; b=EgFwTQ1kLDHGiZBlb
	ckemRhyM0BSQsYXaWcaeP0uCapsne3I7LBJ6yQX8UeTwvsv1eMweYYhYtIKexLvK
	JLYUo9fPUkOCd/MauKukJFadCfoxtzibqUmYuW4dniGolPn8d62LNna1ZIVzHENp
	mfFySM5EqY8Yv8TJYg06XzGR4CRFiRXO+m03cz3I+S0JuKHFS29yHeI6W2tRwWiY
	KlbX09DNAeU8IoExV9q1k0ppN7aP8FbqPMw0uefnE5Yh+zEsXdTowZ8e3fI+OdS2
	7kvnIW2hoZS5eD8VESkAP+iOH5ePhgCnqPUkR//JuudbyKBh3QQSggoBTCdKc8Ez
	orGHg==
X-ME-Sender: <xms:yGP2aMs-4DWXLytnXZ2S-1Yo13Ckf_VESJWNssW56aK9bs0HWR9BEA>
    <xme:yGP2aGp1QWzhw9KodSo5tZJJPQ0o1xeEtkGcTcqqLXg1qi98gKPn97EX8ig7JpSyd
    EjBHgks4aOXKBbq5GqDiZm9x7z3bW_phxal4tSMW8XxztGjXCUjoMxU>
X-ME-Received: <xmr:yGP2aMSyywhNkWdmsGcFDlpRfot8c53DBWTnYzZMnJIWNnYW6IXbXwMYKspHIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufeekfedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepgeevhedtgfdvhfdugeffueduvdegveejhfevveeghfdvveeiveet
    iedvheejhfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfoh
    hunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:yGP2aLY80JtbkhfCLa7gysiKzMzZstZ4Gd8lnD90oueAIz1FnOuy6Q>
    <xmx:yGP2aN5Cv6DbkDPeL7T-imR9aTx28o88AwwBhmMYhcwuJJxrFRQEyA>
    <xmx:yGP2aGeTPDbbAoet1vGSuCnQzNVKaNFw8b3MizFI_OrxI2LdZb1vCA>
    <xmx:yGP2aEfpJ4fx0si0VxpU6fPTSHjzfqoRyKoQTQS8p0vOQ6Hlw4bYWA>
    <xmx:yGP2aDQZc_smkf6P_rPDwMqi6pQvtRnNiyw8tiaYTfJ34xxUDKCjBrvx>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Oct 2025 12:31:03 -0400 (EDT)
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
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 2/2] mm/truncate: Unmap large folio on split failure
Date: Mon, 20 Oct 2025 17:30:54 +0100
Message-ID: <20251020163054.1063646-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251020163054.1063646-1-kirill@shutemov.name>
References: <20251020163054.1063646-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sp1xfcz89d96bxzht3eebkg6zm1xh637
X-Rspamd-Queue-Id: 060B318001E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760977864-695068
X-HE-Meta: U2FsdGVkX1+tQbG04hR+wriLakv8TM4mjr+D8QtQRflLAvRMu9MaetWx0RElnJiC98wQcnR0UrW6mksWtf/d/DDHLpkh6JJkOJZaTVs6MH25dzdjYZega04Vuhlr6QsOWAUUkMH5rxVyIwq4hR6f5MNPVwIkHD69gPoj/h1K1boND0i2v83o/HFBUn71xETSurfPiYTHPXMSUzDGhyJchhotfU5wbFkwZl4scyzcyCdkNcRR6lfUFLNabT0xRiiaLAZUXRcupo6gUxnUsGkm2HhNLWqnoVos3tcteYYZgSd1uqzdhvsiU48PcgrrUIbsa+iYWBmbNMJ+SytYW/Ziw1Yy1mD/8YqBEVrU3W2TWqzgAcKiBeLuh8Day+BwLQsqTsHfpFN/of9KF0CpsLklYlVYz884HGCZqVrv3G4N3pbtBugpNZonOA2udgYTnejInHE98J27h/cAMXUi5Rzdi9KNYl1BdfiidqITJkGmHl0b4+O1ZxQd/YKSFS2AcK5e2GEr39bt8dtiwbiH5nRNdb6BEPy/y9z9J7yJreK7vH2x2I8PzW+HGR0+1YjaTrTkBO7ejK+pRwRwV5w3Qdde+JC53NBUCNHCSlx/zfqP3s67Uz1oyMChSCZA2anOWC6NI95mIdY7LvMURgQNjuNMgKyxUUoXVrbNqypcvolqDHPLwPOU0quLKMcsEiGVu9mSniSGLsv+7ktAcOeyawmDg96wLlsKVJ0BWkZ7zyL1f9Ih1FPppBtDSq/ytgnH6ldImL02fextuM6xJScE1OMSXaJn5QUrcB1mhX2mXqKvYI1Hu6Lb7ydpdF1tGJEmGzFnJ+0e38FuT7hT9qv7Em9+98OdKuibgYqFf3kPF0iud7CdM6xfr+YI+DSMnkLVgq+IycEQWjYQqiZB32fNY9nGsCOjzsEdbrRTBzYd5s7tR0hLnWbM601S+uDSqs6cYxPXpmfOJaR3LyMMPc3RMuk
 67mYrrFB
 pLzaJW9cdS1GMoqt7UCXWnau76leHcAyUHGnwqPZQEu0flD08JgTyZdJ+Fagqx8ixQn3/IhBaWptM8To28k1k3oz3sfq5eVEXmovC78EOf+cNGNd/f7XoCotcOnDFsw9sTC3FOS/AOI3sxZna3EnA0qVayocVnbLF2SOk/ejlNjTyVTC+az9weZ87sy/aL+uD4czzDUHYOGFTOK3Jc6iQFWy7xWsThV2SOtE+TNRI4hYEjHj98isGE6uTx3vlH7pI5A103peOSxmFST5E/gINKacBvdzHfW/C7oFbIGvYG3/JOua7b4dnzqBRuhQMq1jiM30t9zGPDXuDPBwZdi/996gFTvsf8qGEP38AVd5fYT0jP4zMToNhvhri4PHQM0mZu646eNtfu/NXnnGGapMjMbvH/pU+2+cBrIR5
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

Not-yet-signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/truncate.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 91eb92a5ce4f..cdb698b5f7fa 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -177,6 +177,28 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
 	return 0;
 }
 
+static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at)
+{
+	enum ttu_flags ttu_flags =
+		TTU_RMAP_LOCKED |
+		TTU_SYNC |
+		TTU_BATCH_FLUSH |
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
+	if (ret)
+		try_to_unmap(folio, ttu_flags);
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
@@ -249,12 +271,13 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 			goto out;
 
 		/*
+		 * Split the folio.
+		 *
 		 * make sure folio2 is large and does not change its mapping.
-		 * Its split result does not matter here.
 		 */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split(folio2, split_at2, NULL);
+			try_folio_split_or_unmap(folio2, split_at2);
 
 		folio_unlock(folio2);
 out:
-- 
2.50.1


