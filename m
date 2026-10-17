Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 987A0CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 18:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890B26B0088; Sat, 17 Oct 2026 14:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868096B0092; Sat, 17 Oct 2026 14:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8216B0099; Sat, 17 Oct 2026 14:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33C8C6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:55:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A5281C36E9
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:55:04 +0000 (UTC)
X-FDA: 85333020528.12.3A75B8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 67087140004
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:55:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lt2f4VAq;
	spf=pass (imf23.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792263302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKxpaQfh387ep6bwtRUlH/CimaMVl6PpvksVwuLcWUk=;
	b=p3KO1m3Aho2nIq2ONEIUMb+lMUHfqUELW755RjyJb+VhswTzLK0QAQLp7c9qTqHKbX2/EH
	PmaGfqvCi+Jcsk5QQcSwlQXwYOeaZmvOU8Uxn1AkqY/7EaKFlpIzc5Ouo6vNjaQtVA1KCb
	DBFWp0bbI7mXmVYWvI9/AsEzg1L9yQg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792263302;
	b=zGrqO9Q8DgNJeG4ykHKFV6ZYDu+96eLWp6/vnNhMCCZHmViW4DaJajNYw3+xYDKuETsOM2
	/6WRaOuHfo0gJmtZ6me0x7UxTNS6Ys87/fVXcu1/3i4yO2h1MilbJIQm9gVyCtJSmTb3Gs
	jzZJXoMb2tenzbjHaysSwt9eVsbfc0s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lt2f4VAq;
	spf=pass (imf23.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A35284478A;
	Sat, 17 Oct 2026 18:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544701F000C5;
	Sat, 17 Oct 2026 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792263301;
	bh=cKxpaQfh387ep6bwtRUlH/CimaMVl6PpvksVwuLcWUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lt2f4VAqT4wGUjU5xZg71nJ5FKO1ZqMxYrtzylD/VIvyqYQyGjqTVFqYjGw6ED1cP
	 9SldIG/QtoVx4TbU3PA7vlOkcbkxfZWFWeSt89oR8nj7+e0CeKrnchzy6Q4V6mwk8r
	 HuT5auXhxbgWsf/VUQOIPPZQ/a2phzDt7nhY1xuIOy7fU8snI5alohrD9Los093ypa
	 FQijii2eD4BBwy19St7b4zTZ7gj15fjY4ulXNcsmLuvvdEk1fH3u3kxSHmokcyxzar
	 ayCxEWOgQCykTZVB/iWvme8XN4EHliG5r+Plt2VYozlyfGLSC+cfQWDWsX6Henu2dk
	 Ahn2rO5DQUQug==
Date: Sat, 17 Oct 2026 14:55:00 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org
Subject: [PATCH v4 11/10] NFSD: mark a shared boundary page only once the
 other WRITE has written it
Message-ID: <atPEhOdHqV7momDw@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 67087140004
X-Stat-Signature: 4kfo56dbur5jo93wjpazxt6mker5sxyh
X-Rspamd-Server: rspam05
X-HE-Tag: 1792263302-419991
X-HE-Meta: U2FsdGVkX18PZeUo7IzcSfVmmugUOc8UsA2d/QGTHpoNL6SXdMcatP1Qsb5trbIQGE7rolcgn1cNKCGCD7qrBdnr+nNDe/rpy1Tf8b9Ktej5aOCGK3FSHAdiyfvTWpZHo27rf1ioAE8gZ7Mz+gI4IF5op06/9Ce8nv4lxggwZaiWCW1H4tHyC8S5sY4iGKdbtymh0TKf8ouz9Z3bRlHeJ2otzwkwva3kPtcTmAcCOz9equ3uDdnvXR5MlDlLZnxrXWgg6c66yuYpqubNWJ7DrOdxA4d0rC1S2TwC5195KlXklwmQw+r0TTOVh8J9yEi3g1uNSeuAuMOPwBTzyCE1HCelLs9IbSPhggd0KAsNlWgdp4dpcdubeXN04aVBMhbvs2DPpTGFCzZAJGZge5ciUTIRAGCCllaWd0GWJKE85bkelcwkZyJ3xxxkwD7PDA+Qn8uysu8oDMxnQ0wUunXAzy6GQGqikSZDBA9t5majieQd31TGkZ2SRgJwfsCX+K3rRJ+/s5CjcFpbMZNVzxT1gqm9RHjZLhQw82Cvjz5tLXXRQce5D+6b+2svQRQC5nZzY4CGoAV8N5sZRJfESBbDdp2rla77n+F+558kL04QHJyoAL91XaYarWDzIBawfxLnXR2DJSexRpqtRMogb9/e8EyJJCxICemzyRQdLKH/rWUn5/D+pFnY6voQGK2SefYC44YIzkSb48lDx4RetYsSKo5sRAQZfwz6tn057OwI94Cjt/GIsYQeOWd9A1H/13ALHMTelrsRLR/Kfs0fi9pq6/qcSSjdPgqN0vvcbP3JaELyVICc80u5Ek4/AxPKtsduhmpgL0OPxUMe1ACz3uKSDYVj9rhLcFp6ldfFVsNRtD/FPO5MHeNT0+VBdEJS3utl8TaRFEpj072clk4/EeJltsfxT7SyAoyy0wO7aU7ffbBijSb++aSyk6GJYFujLOa/UsL/ysLSL2bQde38RIa
 GGRrryiD
 VqQG3arYMp/wzntBn6q7ZWdHpKc5s4GU4g4knDgSrbC+/RM609W60SNHabWogRbFW+MXJI9aILJT7iS3ukGYIDV6/SCPL0vbO3bUtWVMrovls++B+8Ewqxc6ldldyMkFqnpjzg9D493g7KTJJAn6w8rpjOoxngwCkLB18OIU7dw4jr8IfMySksNY23O5VpfDKacprlmMD3zAPbVxJZ8/eoGR0FDkQQt/EoTcKE46a/bX+NLujJe0oRUElz/dOmC5t7MyBby27uTQ7fxrDLBcAPGBvSZoDeoRNZpezn3t2UwZHUlr30H+9E2zAFhcUfFiH9OYT59jzJSy98KM6v4tywqACW0pauI9wv9RC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[incremental fix to v4's 9/10 which will be folded into it for v5]

nfsd_write_dio_boundary_claim() treats finding the shared page already in
the page cache (-EEXIST) as "this WRITE is the second of the two", and the
second marks the page drop-behind once its own segment is written.  But a
folio already there says only that the other WRITE has claimed the page,
not that it has written its part.  WRITEs that arrive together -- the RPCs
of one O_DIRECT write larger than the client's wsize, which the client
sends at the same time -- both claim before either writes, so the "second"
can mark the page, and have it dropped, before the other WRITE's data is
in it.  That WRITE then reads the page back from the device.

Treat the page as written by the other WRITE only if its folio is uptodate
when this WRITE finds it: an empty claimed folio becomes uptodate only once
a write fills it.  When it is not, neither WRITE marks the page, and it is
an ordinary cached page.  It is written back like any dirty page, by the
WRITE's fsync, the client's COMMIT or the flusher, but that writeback does
not drop it, since only a drop-behind folio is dropped, and it is not
counted as DONTCACHE dirty, so it does not wake the DONTCACHE writeback
kick.  It stays in the page cache, clean and reclaimable, until reclaim,
truncate or a later direct write over it removes it: one cached page per
concurrent pair instead of a device read.

Measured with 32 interleaved writers of 47008-byte records, NFSD DIRECT,
4 KiB pages, device reads per WRITE before and after this change:

  WRITEs per record      halves arrive     client      before   after
  1 x 47008              -                 FILE_SYNC   0.0102   0.0014
  32768 + 14240          one, then other   FILE_SYNC   0.0021   0.0011
  32768 + 14240          together          FILE_SYNC   0.0401   0.0030
  32768 + 14240          together          UNSTABLE    0.0944   0.0082

In the concurrent cases 90% (FILE_SYNC) and 95% (UNSTABLE) of the pages
read back before the change were the page where a record's two WRITEs
meet.  After it, 14993 (FILE_SYNC) and 22549 (UNSTABLE) of the 90615
boundary pages, 59 and 88 MiB of the 2 GiB written, were still cached at
the end of the run, against 484 and 403 before; with
direct_misaligned_dontcache=N every boundary page stays cached.

Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 fs/nfsd/vfs.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index e30c50b9b518..424fa3b05705 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1330,9 +1330,22 @@ nfsd_write_dio_seg_init(struct nfsd_write_dio_seg *segment,
  * DONTCACHE write marks only a folio it allocates, so neither WRITE marks
  * this one and no writeback drops it before the other WRITE has written it.
  *
- * Return: true if a folio was already there.  This WRITE is then the
- * second of the two and calls nfsd_write_dio_boundary_complete() after
- * writing the page.
+ * A folio already there says only that the other WRITE has claimed the page,
+ * not that it has written its part.  Two WRITEs that arrive together -- the
+ * RPCs of one O_DIRECT write larger than the client's wsize -- both claim the
+ * page before either writes, and a page marked now would be dropped before
+ * the other WRITE's data is in it.  This WRITE completes the page only if the
+ * folio is uptodate, which an empty claimed folio becomes only once a write
+ * fills it.  Otherwise neither WRITE marks the page, and it is an ordinary
+ * cached page: written back by the WRITE's fsync, the client's COMMIT or the
+ * flusher like any dirty page, but not dropped by that writeback, which drops
+ * only a drop-behind folio, and not counted as DONTCACHE dirty, so it does
+ * not wake the DONTCACHE writeback kick.  It leaves the page cache when
+ * reclaim, truncate or a later direct write over it removes it.
+ *
+ * Return: true if the other WRITE has already written the page.  This WRITE
+ * is then the second of the two and calls nfsd_write_dio_boundary_complete()
+ * after writing the page.
  */
 static bool
 nfsd_write_dio_boundary_claim(struct file *file, loff_t pos)
@@ -1354,7 +1367,16 @@ nfsd_write_dio_boundary_claim(struct file *file, loff_t pos)
 	if (!err)
 		folio_unlock(folio);
 	folio_put(folio);
-	return err == -EEXIST;
+	if (err != -EEXIST)
+		return false;
+
+	/* FGP_DONTCACHE: a plain lookup would clear a drop-behind mark. */
+	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT, FGP_DONTCACHE, 0);
+	if (IS_ERR(folio))
+		return false;
+	err = folio_test_uptodate(folio);
+	folio_put(folio);
+	return err;
 }
 
 /*
-- 
2.52.0


