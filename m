Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46DFACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8508E0011; Tue,  9 Sep 2025 21:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F948E000D; Tue,  9 Sep 2025 21:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847588E0011; Tue,  9 Sep 2025 21:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF458E000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:53:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23DB3C0530
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:53:50 +0000 (UTC)
X-FDA: 83871669420.23.17062DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C02B40002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:53:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qm38kS5C;
	spf=pass (imf04.hostedemail.com: domain of trondmy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=trondmy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757469228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlPggP5tTGhS2CmJunkE+5uWiRmvpLGgjE4sJID4wuo=;
	b=oXEmKomN+0VYkk1cyC3pzZgzXG9UElsvEmr6RWkcLbRNn2YS0ZQyz80N4++oJSoGGkTs/R
	7DIyTfBHix08jhbK0GjBM3ljhG71LhGB+uXS3/HmaAB8KnTrHBclNQMlHIeld/vo9YfV1O
	5xzdzW6dgCTzl/7nUAVWFg+6X+BBGlc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qm38kS5C;
	spf=pass (imf04.hostedemail.com: domain of trondmy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=trondmy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757469228; a=rsa-sha256;
	cv=none;
	b=uBGZ6Q9dXarQsIYYiyrK6g8yz56wCxaW244LJXWWsUv2aXnVyFqE+SS3cfA9Ba44+sjPa+
	qnVUkCRtL4cksLbRulevOp9yEHW1eepjMqGPsxiqjhYuiO3diWGykes8wIke8oLlboWJNc
	8O6/Hmnmeusl7DcXxwMyuruIei4Jamo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2969D60195;
	Wed, 10 Sep 2025 01:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AD5C4CEFA;
	Wed, 10 Sep 2025 01:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757469227;
	bh=pZauyM11CntK8pSkJ8QNRjawZGUOvqDKEEB4FGp7yt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qm38kS5CEu7WlWy48Av+PhBhR8rQluIolDr6OIpi1OqR0lyipqVuBuDP+V0EKeVxj
	 Ln+F53CpxcKikwobc9G8FBsBEQGGZrSZHKFkfLjDmyCXsXH12J8HyWy9o7MhSRR3zP
	 URLCMDRO1fNrU01b+twgFc0knMBy3gylzdXwFZpVVEew89QJlCe4u7WWf/VxXkbbXA
	 l+ihRI2TFweAA1fE7LK2ca87t4PWd5YtGBGULLuV4Zjr6W20hgMSWuJwdwU1giYj+R
	 5BIQkiEpDY5mv6Kz2Sj+i1MHGJqdIOTExtPKNun4DVTJ+whcytpFaa/TB2u50H9uLa
	 AC3tEz/nNX/7A==
From: Trond Myklebust <trondmy@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Anna Schumaker <anna@kernel.org>
Subject: [PATCH v5 3/3] NFS: Enable use of the RWF_DONTCACHE flag on the NFS client
Date: Tue,  9 Sep 2025 21:53:44 -0400
Message-ID: <3c81beb1e2ee8e56a86f0de4598507c8465613fa.1757177140.git.trond.myklebust@hammerspace.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757177140.git.trond.myklebust@hammerspace.com>
References: <cover.1755612705.git.trond.myklebust@hammerspace.com> <cover.1757177140.git.trond.myklebust@hammerspace.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wz5qtf8dxdathrjtoauhjnemco16wc6e
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C02B40002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757469228-115886
X-HE-Meta: U2FsdGVkX19LWnXXtDJba5SHugpR1Uarc8DilO3bAJOfY15uSoMBNd0iaatuO1hYWSAuCkzzD3Cb15rTUGNMxstaJ778SN9ROkYfPn0ZmDKuia6uK/mmyLjxyNcOuedrTntqc6A0F3upRg+5ft5R9HCPrxn7F1S9VKT8SCTGQ0vhBydLezJn9Zz/f5Azf9V73FQoUMxzLdN88TSPqhnKlmpWHSFHb+GpT3NgkqTOVqUBPe1fuXFXKRtjJGZFJZYk9oZ/Kt+UZM2B3LLoKE/Sg1NknyS+3JP6oXtfSXBOw3QoZF88XUU6mMlFlSZJ1zTvn7c8JAgIvJqgNhU8pyzY9oLq4Oz68oJRIJPgb39QhJ83nvAhyJbRjrRAuO3d/iNupEU4PBVUlU8a15bfXmVZFcXS2Z36YtcStrFHiHFpLdn/gE0RVAS61M+KC70TBmwpcIQmaGG1BVHBlO3l3Ett6O1mOGo06ZxHzUmLfq2038Lu6+MlUJZlV5EhfM2ztsgA++vUOT3iU7c9G5xZR1oj3bID5KKmQ5Gc6Ce5Pgwtl2KYMq5XATO7Zq7x1qsFvLrnDCVg9YYVVDUusRXUZz7wbaKqEQk3PaoRRMwQnQjemPjEDkIzEeGj9Rz1Py94G4myHGpY6Lj4nmRvvcIyzB00s3G6NFuVIh2YMShfvZ8MGt5tX9p5bCI8a0fnyvBxy6GPCpnucWsUDVA1kIOUe1sHUECdkPAadEmqVnacJqOSoVSuit6nTpMnyj8IRE187lLOSDnVt+YaaFVe+4LXl7lOHuD21LSh8PcOvnJozsiLuDz4E0PeDYn055U2gvzNxQ5Joxs9HHoJ09iFD2QaLSrOv43tPHR/SyZsk8+W5125xxlmOgsgMgcR9RBGWRWmHgKAL36i1Yfpf//5jHEIxDRDhb/f+7HrRXwZNQXY0JKAhMIrrRVmA3Tw2vh7vYs6G73tkMTcJ+Ps0fqIK1FEznw
 KUnfR9o3
 BLjT9fvHXOF3wct8IWTL8uk8/VQVEWRsTkJQU4+EUMQBU21Mkp2lkWhVTrqM8AJGGhl59akma52ZIAWggDNs7DsQGKfXqrTsT0S/WMGhlyffPHK6VoU9yIvwdv/16A5+wsVvypaDesFQkEenH2sSS8HLKcK0vdQHRs03yeqD32xpsZ402QL/iImXJWFx7bLLPj6ccLGWMdT0+0tgHtxvcSkIeMwR5kTXnR1xchE1pXYIHSiURwAiSfOhwkquqStDUZQgQn/d7e8BC0r8kBHeYF/90mtp/M3y9iVz9wi3qQg3lRfOBvCIOqbQPY5LZfXqTCKy4CRPMCjHBitz+y4VY1Keq4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Trond Myklebust <trond.myklebust@hammerspace.com>

The NFS client needs to defer dropbehind until after any writes to the
folio have been persisted on the server. Since this may be a 2 step
process, use folio_end_writeback_no_dropbehind() to allow release of the
writeback flag, and then call folio_end_dropbehind() once the COMMIT is
done.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
---
 fs/nfs/file.c     | 9 +++++----
 fs/nfs/nfs4file.c | 1 +
 fs/nfs/write.c    | 4 +++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 8059ece82468..9025c93bcaf1 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -361,6 +361,8 @@ static bool nfs_want_read_modify_write(struct file *file, struct folio *folio,
 
 	if (pnfs_ld_read_whole_page(file_inode(file)))
 		return true;
+	if (folio_test_dropbehind(folio))
+		return false;
 	/* Open for reading too? */
 	if (file->f_mode & FMODE_READ)
 		return true;
@@ -380,7 +382,6 @@ static int nfs_write_begin(const struct kiocb *iocb,
 			   loff_t pos, unsigned len, struct folio **foliop,
 			   void **fsdata)
 {
-	fgf_t fgp = FGP_WRITEBEGIN;
 	struct folio *folio;
 	struct file *file = iocb->ki_filp;
 	int once_thru = 0;
@@ -390,10 +391,8 @@ static int nfs_write_begin(const struct kiocb *iocb,
 		file, mapping->host->i_ino, len, (long long) pos);
 	nfs_truncate_last_folio(mapping, i_size_read(mapping->host), pos);
 
-	fgp |= fgf_set_order(len);
 start:
-	folio = __filemap_get_folio(mapping, pos >> PAGE_SHIFT, fgp,
-				    mapping_gfp_mask(mapping));
+	folio = write_begin_get_folio(iocb, mapping, pos >> PAGE_SHIFT, len);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 	*foliop = folio;
@@ -405,6 +404,7 @@ static int nfs_write_begin(const struct kiocb *iocb,
 	} else if (!once_thru &&
 		   nfs_want_read_modify_write(file, folio, pos, len)) {
 		once_thru = 1;
+		folio_clear_dropbehind(folio);
 		ret = nfs_read_folio(file, folio);
 		folio_put(folio);
 		if (!ret)
@@ -949,5 +949,6 @@ const struct file_operations nfs_file_operations = {
 	.splice_write	= iter_file_splice_write,
 	.check_flags	= nfs_check_flags,
 	.setlease	= simple_nosetlease,
+	.fop_flags	= FOP_DONTCACHE,
 };
 EXPORT_SYMBOL_GPL(nfs_file_operations);
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index c9a0d1e420c6..7f43e890d356 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -456,4 +456,5 @@ const struct file_operations nfs4_file_operations = {
 #else
 	.llseek		= nfs_file_llseek,
 #endif
+	.fop_flags	= FOP_DONTCACHE,
 };
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 647c53d1418a..a671de3dda07 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -296,7 +296,7 @@ static void nfs_folio_end_writeback(struct folio *folio)
 {
 	struct nfs_server *nfss = NFS_SERVER(folio->mapping->host);
 
-	folio_end_writeback(folio);
+	folio_end_writeback_no_dropbehind(folio);
 	if (atomic_long_dec_return(&nfss->writeback) <
 	    NFS_CONGESTION_OFF_THRESH) {
 		nfss->write_congested = 0;
@@ -745,6 +745,8 @@ static void nfs_inode_remove_request(struct nfs_page *req)
 			clear_bit(PG_MAPPED, &req->wb_head->wb_flags);
 		}
 		spin_unlock(&mapping->i_private_lock);
+
+		folio_end_dropbehind(folio);
 	}
 	nfs_page_group_unlock(req);
 
-- 
2.51.0


