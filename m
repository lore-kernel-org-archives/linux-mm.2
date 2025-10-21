Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7196CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 06:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 205D88E0007; Tue, 21 Oct 2025 02:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168558E0002; Tue, 21 Oct 2025 02:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008D58E0007; Tue, 21 Oct 2025 02:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E369D8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:35:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D2C3140403
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:35:21 +0000 (UTC)
X-FDA: 84021159642.01.572C11A
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf11.hostedemail.com (Postfix) with ESMTP id 84D9940004
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:35:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q XCCh+w";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=xFp2uNtT;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761028519; a=rsa-sha256;
	cv=none;
	b=zi/92aeXmhwAZPVgG7ZmQb+bBEUqToZxjhE9RJQbPH7NnzFkzOyo3yzxnCFFdTdpYtj88A
	CGF/fJrPJ/eINHS+cF51OSFWCb+EJy/0W1BK0gWQ2YNwhrQLHd3Hv9p1KoSNR+1Zl4py7j
	W37vox83UM3bRZPLRJzlYP+DwquNEt4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q XCCh+w";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=xFp2uNtT;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761028519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kouMDpsaKBTceLHHuEwo+6TiQxOHciskzTrX3DfsJ3o=;
	b=duws0WKs/b8ZVfG4ZhaAcbGrr/chPejFt3Lby08+9m92xFBhK7voepzPYbvPFOjiMNyKXJ
	+QMbshXchJ/8eR5MJTsY3qaJjvfS8+/7hXbCarFSZOuQHnlGrCsAivwl54r4MH9UpRrBfH
	ywyOHYFApZj1Fv+H+EQmNccVEmTskwA=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 5BAD31300B96;
	Tue, 21 Oct 2025 02:35:18 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 21 Oct 2025 02:35:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761028518; x=
	1761035718; bh=kouMDpsaKBTceLHHuEwo+6TiQxOHciskzTrX3DfsJ3o=; b=Q
	XCCh+wlD3svjomR7bq/ZXyKCTAllt0sB6rnGPRh6WbpAUaLqYqn7grdgZDhn6okE
	bwew6ngIvP8YShoHzhnu5JgSDdbpSs5ffGwKkWv2aa/miiJtrq+Vu+Ohkbmf47IC
	17As1WXT+KUkyeSVNIB1oKijJLKzMFaXZWLEEVn+1nYH2DiBcEdJfYPtOz2k0q6I
	PdjT+1UuD7Y6OfR4EIZSlwC1A6Iv5+IwHm9TjZ+j0iKxSuA+HgMni92AeOOLC+LB
	mAJTJeXI13/CL1vg2g9jBlc+gQwgPJ1Wz08Lm7rGN+7wYnUKNBB398QywOlHlvtk
	RyZUcjDvnws1sIOdrtpVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1761028518; x=1761035718; bh=k
	ouMDpsaKBTceLHHuEwo+6TiQxOHciskzTrX3DfsJ3o=; b=xFp2uNtTRo2P0y3Ox
	MfRvo7pja/nXrVqr6GeQqZ6u6LKRlHRTVoChkL8TncaavvtNonkDt7jyVAj1EA79
	rgzFCGrMQUbzyPhdxis8JVuTQvCMPoeN8ly8hzUDYuiDCdB46WCOQacRdL4mEg4r
	1sNgCG8Zlh9llLxFj6iglEi/jnnrHfgQXEPZ6l2uSLMkyrjZbL/IRzgtjp31b/zo
	oZ7GZgbN5ATWKMYKxUobrRkwr+Esv8uqewKGLaKWjOaLDY01Gdrkx0K0NTlYVgvC
	THXbgSalMTvkW5+POLb5oAQjVi0NlAVc4zSN+lw4V/fl8cB37mG7fjd7aw0H1gZZ
	tc3Yw==
X-ME-Sender: <xms:pSn3aHyVwJ3duZ9SATxnHz8siDK50UyVPwck5MkjbGH7NJlht6KQoQ>
    <xme:pSn3aMdk1Z3ihI-LiHOzD2EyJiog1ReQZrKiooyvbOCvR4igvIhmvYuoXrYakiCfN
    RwkAGldnBrMfnsUBlTUJxKWEjGZ0n51WtGloaTM_1-y7oaf5VENcsrt>
X-ME-Received: <xmr:pSn3aF0rkl1CVJy9STbeSQUVKvkPPV5NDYOXmLUKle0jOMGXGOY5x949vUKBIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufeelleelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:pSn3aNsLt991mStyAV0HAgJWyIXtq7Kp_lMdmpYRGsLrWdig0p_CJA>
    <xmx:pSn3aJ-zPPQsw54nKraZa_jW03DOnuxF85pX8IWvx2R7GLmR1BTkDA>
    <xmx:pSn3aJT73sUt3Z5xvP8XdmPBGPj5p29zjkRrSoYwrXSuoavZB0jSfQ>
    <xmx:pSn3aHCyYqhXC2Z69UJPa_cLsp_D3g4t7ogYt1ES723cUEXy7UiUSw>
    <xmx:pin3aO3o6sgLVZt7w08b4lGkV3xJRri3v-9zh2GIh6SqIG7GW1FkK4GP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Oct 2025 02:35:16 -0400 (EDT)
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
Date: Tue, 21 Oct 2025 07:35:09 +0100
Message-ID: <20251021063509.1101728-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251021063509.1101728-1-kirill@shutemov.name>
References: <20251021063509.1101728-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: eui5sae9osyoaxjjy5so53ynb5ejndua
X-Rspamd-Queue-Id: 84D9940004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761028519-693134
X-HE-Meta: U2FsdGVkX19WXLFqz2G7J0eDHCnaVSLnXLBfSo2fQOzY/wzvSTchQ4WUVtMCciPVOPuva2jYxWITEzFijjl+FcNxda0dxwIu10fqMLrDhO3gmw6MzrLQnb77ZUl581ttNTkr0ikl2jR3acB00Wm59R24eqScoB8WslGAhMdUw5BfWtSFiN9MNXNRu/hlGaluSTUSGlD3wBVeNifUnMwnBNJAu9mEuZKia2fj5Q/hDw3rQGmLLAjqkEMJmOSqtYlCltTYsl57jpbrzVG51Yd467OHNfqw+YGBkxIYJwf5a/dfGjp+YTDgIwGCuFTlz2HQKRtbdPEWyAV+EnOWcjiO/gEaGvG+0wcoRgmf6p4gweDSDdQ2C7/G9GaV0erHjnVtDenP2jW5PyVq9NjaLEHI62w7l271nPk8xTz9qf7F2/V9IobsxKgKZwmsAPfsh56mstfp5DJFUgcvRGTELn3yPh93gcUJocW4AcnHBvB7TtK5suN9glkBBrlHb66fvRkmeNi/9FZGgGnFVT4kylgvpfEccybehqCzx++ej5AvMHu8t9zHCjoYLCe4PocjDLZ96lW/7/iXzSh0CHkrc56nzDR7Ru7lGxr61EZNhe5p/HGq0GH0CH2G8DQJcJV/y/PiCB1eNBC88CobgxmLSHZ5AiFFo3g0qfSoH6m6YfaHKHBFCPvDOo06Wtz7d/y9xzDCu9n0iH3hp4YnY628RQRmUy9el/cZ34AvEaIyGsmdE98ljOIXq9o9Q/dqorivnfiuBbs5d/puR9175A9W/iLI6PqTd2cMLIOlu4Yl+ar8n9GUfGexpCiriajENSu3D1p66gdSZmLnnCqxJCN3A21Zej0dIB1sqBAigzqRnFKOSgR6Kk5A/pXhXjWmaVHcw/COBn0iDjSXCP2ajLyG5dQYXSrNFaVw2NZ08bJKR8gaIzYbDv0cDAKfDD2Zaom5SEo4EsHscehHQ97lQtFYNmS
 d6T9wnov
 8+Gl/1fMM353oiQYGLA+Vy9i4DSqv3M5rjNUdVNXVrp6V3YDcS07VtUVJFsw8Mh2ICLzigkRPJYhSa63GAUQhT7GRgQ/NhRFNxOUJRI/njFnKeU5ffWwuUtGfdpkt8+ZuGhlUPQwMQaUWi/+dapt5M9vUBGQ/ncTFiD0jg/jkes+rmRCtugfzEWgaLytkaavtlDWypR/BKxs7JCeWs2N4LDIpQftHAA5XEjJEvvHh1rdjTFm/gysz+YTKSfTeW/qsq/alYAZmwfOUR3xS9WFh6qaOc58M/8b92oBOH4GqrpGTupcmM857enRo3Q9XzftZefiMRXc8I+R1QSk3T/LQDg5aBbjKeq9OKfQTYkS3U+Lzj6To/nhdRTtuB7jEwz0JoWn8Kji3kToxGn58YkSNU3LhLNElvUZXsOdX
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


