Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25833CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0AA6B0096; Tue, 13 Oct 2026 23:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560676B009B; Tue, 13 Oct 2026 23:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27BC96B0099; Tue, 13 Oct 2026 23:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4BB86B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:52:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59B06160422
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:52:53 +0000 (UTC)
X-FDA: 85319860626.12.8E28C47
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id CF0D6100005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:52:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=iUMPATF1;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf05.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=18766350203@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791949971;
	b=jkWZJZa8KfMSDC9P8C1EqhrF87FeyaD35cN+xjEY2yjNPmK9ukqbCu9qFoPLStsMwuspf6
	kfiX4mLFngOsYL7RX8gNZQGpeeP2qzNlUzw9vkzz6l2LXZcXN/Yepz6tpIGwNhkd6WUkg0
	aaeyxLjyrnhtAn7wgrzAgoSQACbQVOQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=iUMPATF1;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf05.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=18766350203@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791949971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcEsOUGr21bCUTpVOPyzctLEnKTSYTY97CZFKgs4Ic4=;
	b=hixLqkCvYD69/Me9Ma4pPFdWVlXvyMaYeBWz95XHCDk+nt9mXASMvN7ELQ0E/0/rHDHvpy
	/VTLtyJSjeiYNpFcdCs4s/zEcHV3IFArI7mniJr7Fu/HCv/4NSa7ms1TspVuMrzZ6bx7OA
	0suSAAn5Hy+lMKAiYmWAu9e6sKUkDhk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Qc
	EsOUGr21bCUTpVOPyzctLEnKTSYTY97CZFKgs4Ic4=; b=iUMPATF1Fun5xKiepj
	kDdtAGw+EJQpDrOZxQhdsrliaxSvtlj1Rm19PBZa2hsFIIxIFwZhI/wzI+9j33lK
	ZiNt7VbStip8JNHhaRqkO3RyhiNjpY1XdmpPI36vEHBTQfn6hUAolOaTjQiCVkr+
	Mi8kGtzE+RahZgdXgIVayAMM4=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgBncnaF_M5qUtfjEQ--.37990S5;
	Wed, 14 Oct 2026 11:52:42 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] mm/memfd_luo: release preserved folios when retrieve fails
Date: Wed, 14 Oct 2026 11:52:28 +0800
Message-ID: <20261014035228.473825-4-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014035228.473825-1-18766350203@163.com>
References: <20261014035228.473825-1-18766350203@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgBncnaF_M5qUtfjEQ--.37990S5
X-Coremail-Antispam: 1Uf129KBjvJXoW3XF1xuFWxCF4kJF1fAr43Wrg_yoW7uFWUpF
	W5Gwn8KrW8KF4fA397Za1jv34F93yfAFy5WFW7W3s7A3W5Xr17W3Z0v34DuFW5GrWDGFyx
	Xw4YkryUZFy5Z37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jLl19UUUUU=
X-Originating-IP: [2408:8418:c22:8000:1bbd:2550:438b:167e]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC0wuvd2rO-ItS4QAA3g
X-Stat-Signature: nyebda8n6f1ed6s4cxt9uxphhnon1szt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CF0D6100005
X-HE-Tag: 1791949969-147660
X-HE-Meta: U2FsdGVkX18wq683HWoaBHf/92qhoWLK4s2SS9pMlXIpn4TDAWkA2ADO4Hui1ffKugeP/eIHqd2Asok34bOg4jdZPLAnhO3NX3XnldqjUK7pcWadjejpUFwLGlHzbchyKhKkYneOO6two3aru2D999AQH1MBTg9EuyS/gANB3aarKw2mFnlNa+XSAmWO5d07nCx1zz2jW3pfHFfBOoHIfxtf7WTT1geexBKQRMI/RfaVCilAywJeHI9jfFylnUGnhGAJtsmg8OpsAIab3LNmb3BkrVqBsQPU9aLU5aMZCGp0bUCWNVr9OhU7tN6+qI3rYLnde9esVxUvUvS7YtQJoxOpSOVkwYVQVmQIxL3sv9sjI6ZqTAnUHP7PUuuFdhQ0fSTXaGlLEIbZXjx0f3iThnqKkPuHTMRna6H6oY2TJQWu1dIcUzv261MTmp/Svceb1NEyHQP4fbuZr9LVa0IJVrbwDOYzCEUlWpAoINUx03xyXtBy5FpijBRek9yvZBr6kPhg0/aqxbWjSVrVkEBRGW2upyKFr/whqI2vZb5t7HGAdMuRRw4Yllhh1rIpRg6ZaCnGUQO6n9WxaytrreW+gzbA4Z+PZGyE2KofjS3etQl7yw+F7pcbkv+uvMzBtpqM52fuVi9QtPy+P4qgxDyfuHXgDkmhjNrG6hJYO+5ow+07L0StCqbDJWJhxkmLEL4UE5cU9Hoye+iwcviO1+BMNOasSqZcGvLl66VcaP8+OH9m/cOsJQM/n27kl86N1dSVszLgXeJf/b6u33MB8a7Q0tTqWSOWchg2C8MWEgaXjiviBsev/iR0RAl3Jewo5XD+9gJIaWBDth2MTWyx0EVOPE4Cxp9kpoOPJosDGoBRGYI8v3vhd0DE2pYSA6m4FXeDB4Iq0WbzukCSKUU5XyH0gECsYz95JejzjAAo9jTV3rNTMVgKhY6b26EKKmZRNpnKsjf3wAhva7GzcHHIq7S
 spDpcqwt
 9ANr0EzB6ur6RJBm/iUC0fUbVOYQWredw3SXtS/MN5QxWt6zCwrW3rK8tZyH7sdr9iPpkLWm2YiRZ1f3FqhcRwlxoqyqaePWCl62ZuoF43yu6KxwjuXzEmvLHmblKL+BYV4JQ1KeJ7dR7jGp7oo0XKgdxpZKW85dn1vFXzKu4S58wupv7xTnC8NqCcuOY6rEIZFzoFtCSLnJpk5pfopjsxXp0dKohHGihpqac5OBbnqUGxat4w8mNgexLt00NudO0i+anRftJwMTLngZbBrF4oUY8xaIU9bLZ6ItBRv5JivYSSX3QtC7chRwbKbiaZ+KC7MFOM0ghz6RxA294DXW2onOsJ20fQAF2ve/6+CCov5Hqa5C5DDHI+DoXHTXmC5Zoyf+3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

retrieve() only frees the serialization structure on its error paths, but
the folios it describes are still preserved at that point:
memfd_luo_finish() deliberately skips its own cleanup for records whose
retrieve() failed, since it relies on retrieve() to have released them.
The folios and the folio array are therefore never handed back and stay
reserved in the next kernel.

Release them from retrieve() as well, by sharing the cleanup with
memfd_luo_finish().  After the record has been validated, the folio array
is restored before the file is allocated, so a failure from
memfd_alloc_file() or memfd_add_seals() can release the folios directly
instead of allocating memory while already handling a failure; a record
this version does not support is rejected before that and uses the shared
cleanup too.  The folios may only be released while they are still fully
preserved: once memfd_luo_retrieve_folios() has run it has consumed every
folio it touched -- the ones added to the file go away with it, the ones
that could not be added are released in place -- and releasing them a
second time would warn and free memory that is in use.

Two error paths still cannot release the folios: if
kho_restore_vmalloc() fails, the array cannot be walked at all, and that
API is not failure-atomic, so a partial failure cannot be retried either.
Closing those needs a KHO-side fix or an allocation-free discard/iterator
API and is left alone here.

Found by code inspection while extending the preserved record (reported
by Sashiko AI review).

Fixes: f85b1c6af5bc ("liveupdate: luo_file: remember retrieve() status")
Assisted-by: Pi:glm-5.3-flash
Signed-off-by: Haolong Wang <18766350203@163.com>
---
 mm/memfd_luo.c | 78 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 53 insertions(+), 25 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 333502ea3735..f1f07d90f73d 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -467,9 +467,31 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
 	}
 }
 
-static void memfd_luo_finish(struct liveupdate_file_op_args *args)
+/*
+ * Release a preserved record: return its folios to the page allocator and free
+ * the record itself.  Only valid for records whose folios were never handed to
+ * a file -- handing a folio to a file consumes its last reference, and
+ * memfd_luo_discard_folios() would release it a second time.
+ */
+static void memfd_luo_release_ser(struct memfd_luo_ser *ser)
 {
 	struct memfd_luo_folio_ser *folios_ser;
+
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (!folios_ser)
+			goto out;
+
+		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
+		vfree(folios_ser);
+	}
+
+out:
+	kho_restore_free(ser);
+}
+
+static void memfd_luo_finish(struct liveupdate_file_op_args *args)
+{
 	struct memfd_luo_ser *ser;
 
 	/*
@@ -484,17 +506,7 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return;
 
-	if (ser->nr_folios) {
-		folios_ser = kho_restore_vmalloc(&ser->folios);
-		if (!folios_ser)
-			goto out;
-
-		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
-		vfree(folios_ser);
-	}
-
-out:
-	kho_restore_free(ser);
+	memfd_luo_release_ser(ser);
 }
 
 static int memfd_luo_retrieve_folios(struct file *file,
@@ -600,7 +612,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 
 static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 {
-	struct memfd_luo_folio_ser *folios_ser;
+	struct memfd_luo_folio_ser *folios_ser = NULL;
 	struct memfd_luo_ser *ser;
 	struct file *file;
 	umode_t exec_mode;
@@ -614,18 +626,28 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	if ((ser->seals & ~MEMFD_LUO_ALL_SEALS) ||
 	    (ser->flags & ~MEMFD_LUO_ALL_FLAGS)) {
 		err = -EOPNOTSUPP;
-		goto free_ser;
+		goto release_ser;
 	}
 
 	/*
-	 * The seals are preserved. Allow sealing here so they can be added
-	 * later.
+	 * Restore the folio array before allocating the file.  Once this succeeds,
+	 * every later error path can release the preserved folios directly instead
+	 * of allocating memory again while already handling a failure.
 	 */
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (!folios_ser) {
+			/* kho_restore_vmalloc() is not safe to retry after failure. */
+			err = -EINVAL;
+			goto free_ser;
+		}
+	}
+
 	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
 		err = PTR_ERR(file);
-		goto free_ser;
+		goto discard_folios;
 	}
 
 	/*
@@ -648,15 +670,12 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	i_size_write(file_inode(file), ser->size);
 
-	if (ser->nr_folios) {
-		folios_ser = kho_restore_vmalloc(&ser->folios);
-		if (!folios_ser) {
-			err = -EINVAL;
-			goto put_file;
-		}
-
-		err = memfd_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
+	if (folios_ser) {
+		/* retrieve_folios() consumes every preserved data folio. */
+		err = memfd_luo_retrieve_folios(file, folios_ser,
+						ser->nr_folios);
 		vfree(folios_ser);
+		folios_ser = NULL;
 		if (err)
 			goto put_file;
 	}
@@ -668,9 +687,18 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 
 put_file:
 	fput(file);
+discard_folios:
+	if (folios_ser) {
+		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
+		vfree(folios_ser);
+	}
 free_ser:
 	kho_restore_free(ser);
 	return err;
+
+release_ser:
+	memfd_luo_release_ser(ser);
+	return err;
 }
 
 static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
-- 
2.56.0


