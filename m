Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F301606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=lAfq26yC
Received: by kanga.kvack.org (Postfix)
	id 34AB96B05BC; Mon, 23 Nov 2026 14:56:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC9B6B05BF; Mon, 23 Nov 2026 14:56:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3916B05C0; Mon, 23 Nov 2026 14:56:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E75F36B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DA2E1A09B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:30 +0000 (UTC)
X-FDA: 85467440940.03.DE28C3D
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0069612000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="lAfq26 y";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463789;
	b=7Ty9ITgCCtkhFz7QkBmSlhJaj79Q7gBAuO3Ssq/QKs7x0z6C1C3rxwiBhmZU1+LEXNSOuH
	qZX7sB1DE4BRKjXsIfOFbeetxeh6XLJTTsph/s1zXhz/Th8AppXu4s166aQvFh+SL7uK4A
	ykD7rtpXfWP/37U9qmfzrB35dszMTVU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIdriMJqvNi8Sms/WZB3l4qxJPg/qzey4m5IhEpr/rA=;
	b=C5RYYy6b60nNR3tfOXeB/ljtuTUOkXL92oik0Y8HK7Gw58gjYc90/aJ9oSjy17MDU97mjO
	F91gBpLQVNjUglJyZME7f5YMQ5t3TDsuOXNkXUqXUVXD5ytJkFNyLpjdxz8XMCde+njbr2
	QQt5pakJz6DDg6b1Yt//b8ydq5bP9iA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="lAfq26 y";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=FIdriMJqvNi8Sms/WZB3l4qxJPg/qzey4m5IhEpr/rA=; b=lAfq26
	yCLesStGS1Da8QiWVoFQx7z2GofwOGGAdcZFuVH3KpQb0KJlcM2KQQr2NHgjFqrzfXsslrYYvYoNS
	zGnJF6RqKpI7ED0DiP1Vgf/yT/eWsmvzAPrOQr0y0oTOw5ZAVOV+etuWGzry9K+mGkqKHcLzv9oR2
	SI4tZPrK21c10BjhTj31f88xs9qDsX5pQpWHLgqwUP1Dx1J386vebspdL2IgMPcj1TiqoY/oN9tMB
	7ouK6H89vDnLumiApdqNKzeeCWjtY7btqnt/7wrBu3wXMgyiXY+7JW//hl9V1p0TnT9AmLfLg2uK1
	dOjeOhgL2TJFfgX9YZLAOa4K1XSQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xVa99-00000006IU7-2C0i;
	Mon, 23 Nov 2026 19:56:15 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Peter Xu <peterx@redhat.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 9/9] mm/gup: unshare-check every page of a pte batch
Date: Mon, 23 Nov 2026 14:56:09 -0500
Message-ID: <20261123195609.4115244-10-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261123195609.4115244-1-riel@surriel.com>
References: <20261123195609.4115244-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 7irnaeeutieoby3jknfhyiopt7amgxqz
X-Rspamd-Queue-Id: 0069612000D
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795463788-45317
X-HE-Meta: U2FsdGVkX1+ua+5oxnujntcnXYBiWr4KOisrxl3fwoqDyr0MXg8ND/sU/FRXJqMTZGIYqU1THOcDMy/fmbV20E+gwwfMZqc3a+YhFEUFb4gbwgVJS4ERgb49UTnpJta7+j22a17fYy82ev7yvoPq1YJUl88LAc8A959st8jYgJeXXNTCW5o6sjf1VFClqtuLE+gyDJMzud1O7LAxG4DqErJdul7kYhEr3uZvTNUc24XBmzKXsf+JtsLjt1SOUmVYwY9NtwvXDakiogyI0aw/o3cNDiPC8fqVS1qe60EOOEbtuw5qf4Og72N4h3N7AkVjv3jWw5xvTtZeV+5d9ZZMdMz8sBKYCaeLpSYG8W9rIIrU7EHRpCnSnVfSl/hC4g0Y3KrquEvV211FI4aDSDzhOdfz2Tq883uiCYnijbQ2HfCsY41TsnfjHQHOqFieey/1ZX0Jvcxndu/8hCYRiCfYZ3mU/0BJfqIM9yxuPPlOmRtCHhb6kWVrIx/y6o830TVwg/hBkptNky9ONDIF8QYGipUthuz74C2NEgQQyN8X3K9HnJsB5sIRgaiK9gblzB4RuMtHF3KG+A4qBO908SpVZH41w0J6j5XM7rc5x5UbrtVOsvOlmnMdoGWEac1JPfr9lxAnA1sV3imeeBHy0op7Nk9nXwu+T4BJaMkBznuji+1s6qJzfHxHUed09P7M2HFidP1VsvJPsXNR2863JDDbSunRSsB2n3+hVeoHVdLUNXG9wVpfL+SCbaDBaJ8j69FcwIq2wLpi9SLtQufeeLcraIRIW7tnzOgYF6t6ccQqs63t9w1VsjJZ63JvS4f8ScltA8PJcriczKsW2OctTxOXWXHYbBVe4jE/aQe/fsfO5bJeM2A+kUq73tk9sSJVvMTLUgv0/3LMeVIDeFwSz0dBFD3pxqtRRIGAFmauOilkaOT3D38caca0UE8aejH/VZciKMsrZemDEcKd4Tc5a1I
 krzEM7XL
 lw5hkRGgPlXWZ2WYCtKeaGIPY+youIB4v4rraKG3nJCPkMkv29KcNDdeZLz3eiSYTy43v3WGILVz/pTIfarnvH7opZ09/UgmZVOXgDbzAE1k8THQbOdtg0mRgn4SFiGLYgFKh2pk+mVaN4LQ/xi7dffoI9WZTX/Gne/XRx2uZfQWnvPj37W675DMZbvHbyItJyc0oxWsk+EeNkq+/XhTX7azy4ZkMjz2pPaAfWi74o7zGwZX8wI/5c8z2dv3i/MYV+oCavNgMd2KjnToTBgdcGloSMHh3PMRV9wM1eFBd1xfgnp85DZKjnmPYksEqpNgowpqKanBgHxS8sjzQRzSFMoowD039tCZfeKnNu3YdIZkTUL1HXTIGupJJbSZkwL5yL0xJKf67hzD5V7gESZzB/caYtzEEQAlWA5L8REw2b/8RQrf2nN695WuTd+HTBs7/vs2M4BDdPZEZmv4NfJqjKKjSwLwlMmW5Ldxin8Mbf7fzXgXxYFg+ERARow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A slow GUP write pin over a PTE batch can hand back pages that a later
write fault replaces under the pin holder: the process writes to
the copy, the holder keeps the old page:

    pin holder                          process (mm owner)
    pin all 16 for write
      batch passes unchecked
                                        write to a page
                                          fault copies it elsewhere
    read pinned page -> stale

With GUP-fast, FOLL_WRITE | FOLL_PIN can never reach
gup_pages_not_requiring_unshare, but slow GUP can reach it
with a read-only head PTE.

Only pure reads skip the per-page check now; anything else is
vetted page by page, so GUP pins the pages the process owns
exclusively and faults in the rest one by one.

Without this fix, the pin holder can see stale page content,
with it the pin and program address map the same page.

Tested by faulting a 64K mTHP, shaping it (fork+exit, head
write, mprotect read-only), then pinning all 16 with
FOLL_FORCE|FOLL_WRITE: before, the pin takes the whole batch
with no faults but the program's writes can COW the pages
later; with the fix, the pin unshares every page first
and the writes land in place.
---
 mm/gup.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 886a413b8233..ec39e489e131 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -640,11 +640,12 @@ static unsigned long gup_pages_not_requiring_unshare(
 	unsigned int i;
 
 	/*
-	 * FOLL_WRITE is implicitly handled correctly as the page table entry
-	 * has to be writable -- and if it references (part of) an anonymous
-	 * folio, that part is required to be marked exclusive.
+	 * A read-only PTE can map a shared anonymous page. Pinning
+	 * one without unsharing it first leaves the pin holder behind on
+	 * the old page once a later write fault copies it elsewhere.
+	 * Only short term read accesses can skip the per-page check below.
 	 */
-	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
+	if (!(flags & (FOLL_WRITE | FOLL_PIN)))
 		return nr_pages;
 
 	/* folio_test_anon(folio) is stable until folio gets freed. */
@@ -1015,10 +1016,11 @@ static long gup_lookup_pte(struct vm_area_struct *vma, unsigned long address,
  * Return how many PTEs map consecutive pages of the same folio and can be
  * committed as one run. Always at least 1.
  *
- * The write-fault and unshare checks in gup_lookup_pte() are per PTE, but a
- * writable run needs no repeat: a writable anon page is exclusive. A
- * read-only run under FOLL_WRITE or FOLL_PIN does need the per-page check,
- * so it stays one page at a time.
+ * The scan covers PTE bits only; a read-only run is then trimmed to the
+ * leading pages that need no unsharing, so a mixed-exclusivity batch
+ * commits its exclusive prefix and the fault path unshares each
+ * remaining follower in turn. A zero return means even the head page
+ * needs unsharing, and the caller must fault it in instead.
  *
  * @fpb_flags selects the scan: slow GUP merges young/dirty so
  * folio_mark_dirty() sees any dirty PTE in the run; fast GUP scans
-- 
2.56.0


