Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C27ECC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2307C6B0096; Tue, 13 Oct 2026 23:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2426B0098; Tue, 13 Oct 2026 23:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0829A6B0099; Tue, 13 Oct 2026 23:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0D216B0096
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:13:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5F66C03FD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:13:18 +0000 (UTC)
X-FDA: 85319760876.18.5BFA420
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0114F40008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:13:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ceTdZkww;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of 18766350203@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=18766350203@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791947597;
	b=Rbg1KCo65GVraoy2HytFdOLQ0W5GHQJ+Y93dG5cFJFkvBBYKyJa7Ktwneovm0Uzqfbm5AQ
	FMHsFSwSnSbU795X6uzPnZBrcckJRdKhwm+xKOM+2eEBXBBFkBxnynzi0R+q0qEPH/WhIu
	x07aTFM/lel7CEloGf0elStDoUhtcko=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ceTdZkww;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of 18766350203@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=18766350203@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791947597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNAZxCmxIUrBQNH+jBMXGiGkCNOioyZYJCxs8qQKSc0=;
	b=M0JmpxWpzKPewUg1Y8z2C0igQvbowVw3rG17C6YRQ9rvnu3S/BB1IrROL6ciNUMZgfgSWM
	7mVwIoLc5zZpXGLxpVSSHr+ifAw6i+lEEnMHC1cr7E7I0oOiN53QA6MTCCQFQrdr4ftHAv
	5usNNKVon9d24MHDdRM+bzuephQ7r+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=NN
	AZxCmxIUrBQNH+jBMXGiGkCNOioyZYJCxs8qQKSc0=; b=ceTdZkwwPKbATCBAoC
	T8Bp2td55y4BpKEJkbjXRJT9PZRvhgHwquIrQ+TMg1KiMZ1qGncndpXrDQ1M1BEz
	grQHsIC+JFDUf/Z2ACkK+IR1y7AGfjs52zlChFOdxRcctHMp4cs2M6HvtYvmrqkm
	CVN04JDIJKmCKZXn9ouNtz57o=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD330I_885q6IC7Eg--.21712S4;
	Wed, 14 Oct 2026 11:13:07 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/memfd_luo: release preserved folios when retrieve fails
Date: Wed, 14 Oct 2026 11:12:54 +0800
Message-ID: <20261014031254.432582-3-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014031254.432582-1-18766350203@163.com>
References: <20261014031254.432582-1-18766350203@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD330I_885q6IC7Eg--.21712S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3XF1xuFWxCF4kJF1fAr43Wrg_yoW7uFWUpF
	W5Gwn8Kr48KF4fA397ZF4jv34F93yfAFy5WFWxW3s7A3W5Xr17W3Z0v34DuFW5GrWDGFyx
	Xw4YkryUZFy5Z37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jysjUUUUUU=
X-Originating-IP: [2408:8418:c22:8000:1bbd:2550:438b:167e]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC9QNbI2rO80NDAgAA3b
X-Stat-Signature: jgxa5mr9zypocknw96wdknxjydbowud4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0114F40008
X-HE-Tag: 1791947595-108604
X-HE-Meta: U2FsdGVkX19FRh5PaFHSs6gPEqriw4BKhmw7NM9+3k83SVg3/bDXeG19tz2NvubqfSDawgHWX6cT+oHi5RjGZDA6C8lXBp9R1htrF27Fnw9WC71nXHxT8YLPxuCwPtcuEmoqNdLMxWDtlrinXZno6JRrH5iWUk15pHZf7a4Uuib3Iudl/MJCYY7kOZDyb85n3LPB0ZirU79yEd82M743ZZodgh5Ntci7y0c1vV/awsVlPuEBSfvpTj+V7gHkbFwCY3wsTxVrqrPTKlJnP3ZM2gq1g9v3LAC4V5FOQJ/9F2QH8/5wutYg7+uG3IWo3ErEUcJK5Xx/s4kMO2ksDqu6bQqrmEAhIi8x1M7WVfBMLUUvlYafL2jeVAU5/Dr3X7bygt4jGBJAG0X5d2IGWGI5/nxun5IynRFc5QR7uuUiy8IqwYPves6FTJ/SUqbRCkhCRNLJZGIa1ailRL0307Ipw80sum7bK/iSlTOzfgnDYOl8m6VCWWRIWQ8ECXwq4nVYRYuhipOl9AvbXrwRP8WqKMwuvmQwQ86XAKi9ri/EC5nGwtmP8IDI9zuIYJgWdJP/NReGfzw/mWymuBX6vIMGeiCuxqBHmNMA4ZfxzkVuZF8opvo4QMymxYx0Y6Ix7Jp7OLviX8hOXiKhGZc8M8BA7bpcnDUHCGdkX4vXVzW8FKqjLoaqP1i1gSaA6i4Z+mXyeN48LjLgjGPO5bEYnZxnhSl4T+waa4pxpBIlQp/lLCVkmIyRNbsgwbI4558uuMjm1jT7IdOyC7L5vHSAJNYuXGPF48KpNbN36OrtG7qrgRFZ6VZFdbzNKRzWvCAq/av6UeIcmCb1tCpKfZM2VZSMD7ylcRh3vpH4dCYqcoIg58TPV2gprwhRrVQiKfl9q1coCwPEjOx8WxxEiLoAb8F3umCRA3orai7jjUGpNWk2QlfXf2WqjRyqqhOdNmopsTa5MDZqjIUThbkshAIR7uK
 kN4aIJnm
 spKgqfW4XIxrRUksthgBbYytYh6rPIxI3TEb6rrx9x6ZH1am84nNzQHFai2+36sOL2y/dRhmujmTVGze2xCTJCrXsWOv6NwsFPkXUzyIQhADEGdqA8ovgsiHkxGF3V+DQ7+zEJIvw1nWK834dGrOOBfaLcZH0mXbjD6pSVG/Z3vggwRnceuzZV/b2jad8nlxS7h0v9J5I34ZFMee4DQymsLmFHGAO1XoPif105QkM9XMFMiHVKuqG1b5kJ+pRl0EkhkWZKo2vUzZAIun5oQtrUbMHk1P3JShcSyo0Vy3QrAzCpT7VTiYeiAfy93qcAmuYihXniL4CPDb8ikb8yvhoSoTc53uGZ4IkExGKT2nXYeCpRdkV2Zll2TubbP7vhO9kkBBS
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
index 6fa086fe809b..e7dbb81e75a3 100644
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


