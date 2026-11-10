Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BAAC606A8A4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=faMHSEj8
Received: by kanga.kvack.org (Postfix)
	id 53B496B00EF; Tue, 10 Nov 2026 15:33:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513116B05B0; Tue, 10 Nov 2026 15:33:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4020A6B05B1; Tue, 10 Nov 2026 15:33:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11C4B6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:33:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8987E1A09CA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:33:28 +0000 (UTC)
X-FDA: 85420359696.19.D45EAF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C05A4100005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:33:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=faMHSEj8;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HNkHh8576R9yenj6hZR3ukTbtfxm+sK5xBh0AHQFgqo=;
	b=khqF+fV3UXodeTwBNLve1TxD9PYYbAdqZLIoQSDu5uxo46Lf2IXhYLx88EvSKi4Qkz17b4
	I8/hCfrIQAS2hZbFp82qAX+JdHkRPrCmGtOCsGwuqCj8YOhf0XywtOtXkl8nM/v2xJ9GWl
	RO711M7MCNHLGiwdFePOeeczvXca3Uc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342806;
	b=PkggXHsZW/NWDpmwgQpLRxiQ+o+M4v/bkjyo8ySflWVzo92gM/lh3dY7uWrwyTc+wdq7iR
	CxpL155Z6qQYeXf6ZXzG0Etx/sWLTcSwbs/Cs/BK9DUHy/P2oKXDyFJ4FYuEwh4v0OkUMA
	AZ3qgenKK/aTt8d5clIrlfNJpsfUrZU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=faMHSEj8;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48BBF62FD1;
	Tue, 10 Nov 2026 20:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D423A1F008A1;
	Tue, 10 Nov 2026 20:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342806;
	bh=HNkHh8576R9yenj6hZR3ukTbtfxm+sK5xBh0AHQFgqo=;
	h=From:Date:Subject:To:Cc;
	b=faMHSEj8UOEq56lelMECdxXPosfoDrSmgupOG1ETLfm4s/3RSRQbWnwEO2YuWM/7o
	 dmvKVtzQ6CUh3/qK0bKxwIxZ4CxZnXNghLCj/+N5VKaXGQ+S6vb48mZc+rCQaovFzA
	 fKHHKewXX3EiL693xJoDj4nixSbxG+ILn5SFAPqTt6yCBbW2M9pj8sJvfQkDwrknjN
	 lqKgQ1wb5erbceCc9bmLoWvqgj0SOf0MZ4iPOqdaZ8BHNYWRLB0jIBXJEqO2dmIsoh
	 w7r1dGCWLtOSxfhnYv7h5R7wm+yc8RMvKwInddNOaWkifRhKkkT2xfUXMGCOBJ+svQ
	 r/GWXEbl0wTOQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 10 Nov 2026 21:33:12 +0100
Subject: [PATCH RFC] mm/filemap: fix lseek() skipping a new large folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-lseek_hole-v1-1-c089c960b846@kernel.org>
X-B4-Tracking: v=1; b=H4sIAId/82oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQ0MD3Zzi1NTs+Iz8nFRdk0TL1CQTU4MUE3NjJaCGgqLUtMwKsGHRSkF
 uzkqxEMHi0qSs1OQSkDFKtbUAZorfanMAAAA=
X-Change-ID: 20261110-lseek_hole-4a9eb450d473
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 William Kucharski <william.kucharski@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4173; i=david@kernel.org;
 h=from:subject:message-id; bh=X++bvNWUrEFTrfv+bufHFUKamza572buPbl4/CTqBK0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI+1/cxbPvE+j1D/eEZu9grzhmFD/alMGdsl37QLiJZ/
 KjVd+6ljlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDaEi1MAJiJ5heF/+M5Zfhv1b05LfcKm
 d/eLrM6M5ByjxT+W6nftT4teeoCnm5HhqOm8SHsngVql4xs2W/y/IaU0Sdjs8xGZ5Obpdtsagrz
 4AQ==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: arw5u5d9379347wo6gh4cxuxzkyjg8bh
X-Rspamd-Queue-Id: C05A4100005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794342806-11663
X-HE-Meta: U2FsdGVkX1+TcHSFSXjzdHyUIMC0qGYTQATtGtWy1F4hXqDVkHhALC3ytDy2Qenwy5f/eS5OYzf//HggaGKsAsPQC4AZuO2f2v1SlK9uJxXe76bLn59W/8lgCkmYClWH4qg993FrXQnyeyW8rJ++ajtTqSpUq5qJT5dQDSESrggz4FdP3DVRAUtdOV2ebbdOCdtb1XMQAd2evB7x6ZGXC1wBJpuZhOyZaergf/JR4A4UVVQ3ph7QT0SGiqIW46bPaL5OVdqi1zzO3YUhuEJhOcGI0cIvZbvKAtNAZFYwgo0AIHU81yoCT7HFfj0iQiqxF5xoeNxyGPQtUG+kbbeETFD/idFp88por8q+Y7+I00Xr5/RF3x6A9rIlGXthrNutWItqZusSOiD85xKJAs8S3RzpylgsF7U6A+U9CqJLo1efBML7Y2k+PGKXUq4fWGvNbl3OH2oGJiI4/L/vbeBM4E1Xam3XwmF1Nrfcwjgl2p52e2P+LulpZvBKPFIDr6SyKY/OXniLegfXxMh8RJRuBgk3lwUqDK9pMgikwk7cXCSHNIPxqx5CEYEranFq8SmpbnWo48TND4e7lebmB6W3kKxFnCmalpRLND5zd4H/OOF4f68oTBDQ4Wo63P2lwfvU6rB1mMTG/ZO+0Rj1y6AYi33N/dASnMyQENmrsTCAuQOcIQmMtJpyRiiAI/U+3dmJiGCEYoBkybgoh5JELB/J+HNwdlrj5ciU0B7eX3O+LRYtd0S+NtDveUNiH2LyqFAfGLFIVwShgcJ9rxky9e6rIxSLnQC4rZz1+M1fTZOJGuoeFbHjPYnoALsPvrAw8qP2qBWa2NqN9iTlboMoqDuo0DNbC2Fd9StobiBraISE3537WH1qD7j37hwIUZAiybd45KHaG6Lwn0L8qdSphamGm1lDTxZ79RcHMpW0Yc15qOdFPFzwpqrpqH/toB1lTU2MX9WI3aYTjoui1DiD8sv
 3SZX4KeA
 1zZtb+rVJUhRxZRuRVaJUM4he+0hito7NYdgPmzL6NhSpTP26Xi4IT0HRwDKK/m0GPg7hZpVQvXAKEiVkB7wypHARDac0SGQYi/1cL80oxhNkpNyIZPe3aFskMxsPlsQVOPx41FmXmaChQDvWb+AWFzbp/Y6NIz44YMScdgW5tb++MKmsnUXe+BOuFfHnMxOmXLayEzTBNxInp97u2kwUyS/nortGr/r5NAfSmBvYLOitFT79JWkdN2VT3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mapping_seek_hole_data() walks the page cache under RCU and only calls
xas_set() after entries larger than a page. Between base-page entries,
it continues the walk with xas_find(), which skips sibling entries
to return each multi-index entry only once. If a large folio replaces
small folio entries between iterations, the slot holding the new folio
can lie behind the cursor. Skipping its sibling entries then skips data
that has not yet been examined.

On tmpfs, SEEK_HOLE can then return an offset inside existing data.
SEEK_DATA can skip data after a fallocated page that is not uptodate.

For example, assume a 2 MiB tmpfs file backed by 4 KiB pages on x86-64,
with page index 63 fallocated but not uptodate and all other pages
uptodate. Index 63 occupies the last slot in the old xarray leaf. A
SEEK_DATA starting there can skip that page, then race with collapse of
pages 0-511 into one 2 MiB folio. The next xas_find() moves past the old
leaf and skips the new folio's sibling entries in the parent, returning
-ENXIO instead of finding data at page index 64, or 256 KiB.

The inode lock held by lseek() does not exclude collapse or swapin.

Restarting the xarray walk after every entry fixes this, but increases
SEEK_HOLE time about 24%, when scanning a fully written 1 GiB memfd backed
by base-page folios in an x86-64 microbenchmark.

Instead, use xas_next() for adjacent indices. Restart the lookup from the
root at the requested index if it returns an empty slot or an internal
entry, including a sibling entry. Also restart for nonadjacent indices,
invalid iterator state, or failed folio validation. This avoids skipping
unexamined data without restarting each lookup during base-page scans.

Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
I'll be more than happy if someone of the pagecache folks wants to take
over ;)
---
 mm/filemap.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 648f783454c3..87c583509567 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3233,6 +3233,40 @@ static inline size_t seek_folio_size(struct xa_state *xas, struct folio *folio)
 	return folio_size(folio);
 }
 
+static inline struct folio *seek_get_entry(struct xa_state *xas, pgoff_t index,
+					   pgoff_t max)
+{
+	struct folio *folio;
+
+	if (!xas_valid(xas) || xas->xa_index + 1 != index)
+		goto restart;
+
+	/*
+	 * A lookup within a multi-index entry can leave xa_offset at its
+	 * first slot. Restore the slot corresponding to xa_index before
+	 * advancing.
+	 */
+	xas_advance(xas, xas->xa_index);
+	folio = xas_next(xas);
+
+	/*
+	 * A concurrent collapse can replace the next slot with a sibling entry
+	 * referring back to the slot holding the folio.
+	 */
+	if (!folio || xa_is_internal(folio))
+		goto restart;
+	if (xa_is_value(folio))
+		return folio;
+	if (!folio_try_get(folio))
+		goto restart;
+	if (folio == xas_reload(xas))
+		return folio;
+	folio_put(folio);
+restart:
+	xas_set(xas, index);
+	return find_get_entry(xas, max, XA_PRESENT);
+}
+
 /**
  * mapping_seek_hole_data - Seek for SEEK_DATA / SEEK_HOLE in the page cache.
  * @mapping: Address space to search.
@@ -3263,7 +3297,7 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
 		return -ENXIO;
 
 	rcu_read_lock();
-	while ((folio = find_get_entry(&xas, max, XA_PRESENT))) {
+	while ((folio = seek_get_entry(&xas, start >> PAGE_SHIFT, max))) {
 		loff_t pos = (u64)xas.xa_index << PAGE_SHIFT;
 		size_t seek_size;
 		u64 next;
@@ -3286,8 +3320,6 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
 			goto unlock;
 		if (start >= end)
 			break;
-		if (seek_size > PAGE_SIZE)
-			xas_set(&xas, pos >> PAGE_SHIFT);
 		if (!xa_is_value(folio))
 			folio_put(folio);
 	}

---

base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c

change-id: 20261110-lseek_hole-4a9eb450d473

--

Cheers,

David


