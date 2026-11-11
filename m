Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55941606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ij02aUM3
Received: by kanga.kvack.org (Postfix)
	id 846D96B05BB; Tue, 10 Nov 2026 19:24:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F83F6B05BC; Tue, 10 Nov 2026 19:24:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70EA76B05BD; Tue, 10 Nov 2026 19:24:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC166B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4A0BA761B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:21 +0000 (UTC)
X-FDA: 85420941522.05.6CC7CA3
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf06.hostedemail.com (Postfix) with ESMTP id 19FCD180002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ij02aUM3;
	spf=pass (imf06.hostedemail.com: domain of 3s7XzaggKCEwr0o7zoqyu22uzs.q20zw18B-00y9oqy.25u@flex--dmatlack.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3s7XzaggKCEwr0o7zoqyu22uzs.q20zw18B-00y9oqy.25u@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356660;
	b=OE3MSiNo2c4ppLcwDzudkzquz+cMhlbmrKdDGFtC7to4dEIQbWozqQAvX9Qk+jKMimWxfa
	zO0mxfyXgEq+mAuIThghQ9uOzMjtcqpA52ON8bqNMZGNOEPIvtgoSGJBqtoA+KTw5E8+OA
	3V1qNxq29rHbljPGr5djcM9CNZhSo6g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ij02aUM3;
	spf=pass (imf06.hostedemail.com: domain of 3s7XzaggKCEwr0o7zoqyu22uzs.q20zw18B-00y9oqy.25u@flex--dmatlack.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3s7XzaggKCEwr0o7zoqyu22uzs.q20zw18B-00y9oqy.25u@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbpaElakptIh2hFwmXWUs/sq4k+QmnD2y26Qhgoo1AI=;
	b=yZsbqtvkTKBy8raFmCD4uPlnwTH+gA/uLG8sJeXkvofOVTeWX06JlBO0CM/FgSQLp8iNIw
	gDg2pM/yJap9N9cOvgaut4PKr/Ma/DI3Z7SLl8VFIPRAZDkxncVK6meHFrWmZ8oeWqXDr2
	ckvy0N+Qx8WIWvV65lhwBOQO5YNPg1I=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-82315dbce25so1739111a34.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356659; x=1794961459; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vbpaElakptIh2hFwmXWUs/sq4k+QmnD2y26Qhgoo1AI=;
        b=Ij02aUM3fhhTHn0hcc/1cR3Xe6VOHF7t0ex8odTsbgqrAn2+NINkorjd9s8pdd2iOY
         W+mRnYlPTyebXaZ6SsyWVk8eEaKEYYLmzLxLfdBkCvj+twRC87oM04jOhm7d5eRDoRz0
         KbzyzbUEQ3yuoxCHj4dJfFQ2ym8dot9hqnTDMhNgeguFpgYUiuOujlNzedynvHgI6qTc
         4N93ElGwdAPhDLydCP8vYnLNFuMeG8EQpOqtEA5Fi/pRwPS1HV9EXtT/n0tLK/pNeQ6w
         KjesglrgzuGQvKtSoz7tnDE6Fhtl2g6C+kfjqbCBmZYGKcPInIJHSDVcE/isDBpmr5dF
         sXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356659; x=1794961459;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vbpaElakptIh2hFwmXWUs/sq4k+QmnD2y26Qhgoo1AI=;
        b=sK7JNwnX7u+pMmH0HISz17xi3PlU92ypH1ZIZm+/MDAviOJoyYWehlUNDGXfXbI12V
         wU4wVMfGLMuI5T9aZQeuWWlsBWlIlBi0O/+nlY5DJBV2iWFDVjPln9gKG/taL0UcX4jc
         H+gB9EmHv8Nu5fHPGD+8Xmc6ZzG1gH6us9dLZsFP+W5HRi7wy2sX9MwUqBqLq/NKM2Tt
         1dxrAa+9JaDByjtPEMuqhZSAGfLviVTPsC77I+y430O/aYIxzY9kShZgHws1vF5aigdZ
         BE+5mXe1dFkYNt23ZFZ2L8kGGOejRaVEmeh6c9i3f34x01EtFqBlrXjB7NRJYBxYJjGM
         638w==
X-Forwarded-Encrypted: i=1; AL+hErHHOkd7XUW20z/8yTw13w9ng15cepbGkTWSHdKkwk++gpKUg/2Ai95krUcpn0vyI7Zy2WhMlbBk+A==@kvack.org
X-Gm-Message-State: APuU4Z8Sq5kLGXxL0O7LXxcKRpiChKJpjUQXQd9S79doxqWVFT5KaC8x
	kWM/4iaJEBBh6yRS236LmDikaxtw5xrJmabFRHUcIUOsHbgEEHvfO7Tft0bufd1PgW1pky+XD63
	hZMjr0OGzxdk7ug==
X-Received: from ilben19-n1.prod.google.com ([2002:a05:6e02:5113:10b0:524:c21c:a8de])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:19a8:b0:539:596f:6623 with SMTP id 5614622812f47-56b98228b8bmr731061b6e.64.1794356659004;
 Tue, 10 Nov 2026 16:24:19 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:47 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-10-dmatlack@google.com>
Subject: [PATCH v4 09/19] mm/shmem_luo: Leave freeing the preserved state to finish()
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: aiam3orbsx6zyxg68p5zcw6h6r3fkhc3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19FCD180002
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794356659-671206
X-HE-Meta: U2FsdGVkX1/64p9RRP2Bh4vYEtYhc/P8sMopggJqt7R5KsBgOdPklA5huhJIcaDSdHuwb5tMU4gQyK8XvrBYbV0PSbtlBCSiv8Eqn1bZooCVZ5jNmVt6ng2QBaaOY35U8Ws588wHTxnJqZd3Tjr1c6lHxi9wbLkz5G+5TU9PxvHm1pDodeydG82s+CFgyph9CN1uPYA5+yx7zzK7j90k4rOUMESWcv1oNDyLzwU8rOMZG08yOnkwXLd0hnjaZS167t78GTNGpuehwwcQ9cXl7OZFq3wFWXOtL4doocq7m7E6ESVL+NLjXV7ki8wUHnbhTglVwOmbI+3F1KcFxPOZif8mU5rCseYQ1UBtP2ac616scEaonhd5hWfSd3JpFLrSgfJSszX7e+XbatzxAmmG8A6f8sCK5HLOK/z7n6AA79Dg3H5ZXVT+Jp7SenXCFr774YBIn2/NfXMUdbO73GEPvtZznBBrvkiTON/4TQ8sakiYJqcMWzAXpreqs4KNhOiuuhZpcOZGzBs9ZbP17MmsBSghhmWqDsegQKwRjyOx1AMC1rroWAjRTmCKw96DL5Nia6B6Byapa8fCZzOE07KbTRSEqY/6edC52ax8uvrolBacgtqGLrjmOnchijQLBypum1UFJ5bFWGgCxykyIa/YG8taABXlOEN4Tc80HUT2yjbwwgihYINeL2TCWh2oBDp5Gi70kBe3GBCGKcMFJbSE2c3q8ve4RAOD7Bt16KX/G/+AUJZhKm1aWRvKmEkRTLf2GKer2Pu/9wfF+A5gR2h3gRq44unB+1+dLeR8wBRFBgWPbV3NC1o65p6oK2OTlV+BmNrn83LQwxZ+ZmOxq6U7qZENuKxNLDQWXqBnBJN6cQ/SLZlBDm9JTrA/b5TkuJLKkKj1T/Z7sxrZemeD61k6d+M3r7t8nwUF2aEr0CKVO4oCLq3Tq+pzLTqjF28HKaKr61xYJNg4Entlgojhynm
 6zTHMAwi
 O/f0tLowyfC/rUBew4SXElR3tvWc1x9EJX7TUZWhwviV6tvJQPUh/Zpz0NFamMTsD+JnzQlgtC/4gtUBp4vXcU4yFmM0H2ENhynCozovjOEAvNK4EaQVWON4fvfUXHiyfBXxEfRMdq3e8dxwMlnZgC1tqZhfcUkQGq+pKSXUkdOeD1QhAQ0qA2ge1PJ+20gxOWWOx96025RCfHFZhIMpMsS00gb5vWou/WB5b2KA4eNdsEdJ5cMZfPdTBmOK52tREDyTLLiuKeW03NTz87L343a2E39/tqHtBVsCFBGoBpSDSqkundSc9b+naxKFA/xvCin1jVektD9VyfC3NUxwXr2Gxeyp4/5Bb0fEvMZ1HyCbxUquUYrZ3o8nABjK4Xj2NU2L6sURr+RIXWhxM2KyPLO6px5xyafdb1U5IMqZ5Mx2/vi1V/Hscl+kDYCsht3I4p4LZmlIuclsBN/Fq3KcBAg8ezGAraADohAkeP1rb4LRXOuKrdLEVzZW/spgg+z7Zg3pH7N1f1f65kA5iO7QNO5/q5oDrs6dhJoc8EaYdcCimzUjWwB0AX62SujKTGo7KbwzJrNzI31U4Ips544mEeJNoxyL7Yl36jbru9CGio5y+vyOtFJdBWb0xSYJFLH1MupgPND8Hhq1nZSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Don't free the serialized state in shmem_luo_retrieve(), whether the
retrieve succeeds or fails, and let finish() free whatever is left of
the preserved state of every file. Once retrieve() has restored the
folios, it sets nr_folios in the serialized state to 0, so that
finish() only frees the rest.

This fixes leaking the preserved folios when the retrieve fails before
it restores them, e.g. because the file has seals that this kernel
doesn't support, or because memfd_alloc_file() fails. The retrieve freed
the serialized state but not the folios, and finish() then skipped the
file because its retrieve had failed, so the folios were never freed.

Preserved folios may also be in use until the session is finished, e.g.
by a device that was preserved with DMA mappings of them, so they must
not be freed before finish().

Fixes: f85b1c6af5bc ("liveupdate: luo_file: remember retrieve() status")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 mm/shmem_luo.c | 64 +++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index e747a0442295..b48d7f460493 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -390,13 +390,10 @@ static void shmem_luo_finish(struct liveupdate_file_op_args *args)
 	struct shmem_luo_ser *ser;
 
 	/*
-	 * If retrieve was successful, nothing to do. If it failed, retrieve()
-	 * already cleaned up everything it could. So nothing to do there
-	 * either. Only need to clean up when retrieve was not called.
+	 * Preserved folios may be in use until the session is finished, so
+	 * retrieve() leaves freeing the preserved state to finish(), whether it
+	 * succeeds or not.
 	 */
-	if (args->retrieve_status)
-		return;
-
 	ser = phys_to_virt(args->serialized_data);
 	if (!ser)
 		return;
@@ -515,9 +512,34 @@ static int shmem_luo_retrieve_folios(struct file *file,
 	return err;
 }
 
-static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
+/*
+ * Restore the preserved folios into @file. This consumes them even if it fails,
+ * since they are then either in @file or freed, so make sure finish() doesn't
+ * free them again.
+ */
+static int shmem_luo_restore_folios(struct file *file,
+				    struct shmem_luo_ser *ser)
 {
 	struct shmem_luo_folio_ser *folios_ser;
+	u64 nr_folios = ser->nr_folios;
+	int err;
+
+	if (!nr_folios)
+		return 0;
+
+	ser->nr_folios = 0;
+
+	folios_ser = kho_restore_vmalloc(&ser->folios);
+	if (!folios_ser)
+		return -EINVAL;
+
+	err = shmem_luo_retrieve_folios(file, folios_ser, nr_folios);
+	vfree(folios_ser);
+	return err;
+}
+
+static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
+{
 	struct shmem_luo_ser *ser;
 	struct file *file;
 	int err;
@@ -527,10 +549,8 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 		return -EINVAL;
 
 	/* Make sure the file only has seals supported by this version. */
-	if (ser->seals & ~SHMEM_LUO_ALL_SEALS) {
-		err = -EOPNOTSUPP;
-		goto free_ser;
-	}
+	if (ser->seals & ~SHMEM_LUO_ALL_SEALS)
+		return -EOPNOTSUPP;
 
 	/*
 	 * The seals are preserved. Allow sealing here so they can be added
@@ -539,8 +559,7 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
-		err = PTR_ERR(file);
-		goto free_ser;
+		return PTR_ERR(file);
 	}
 
 	err = memfd_add_seals(file, ser->seals);
@@ -552,28 +571,15 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	i_size_write(file_inode(file), ser->size);
 
-	if (ser->nr_folios) {
-		folios_ser = kho_restore_vmalloc(&ser->folios);
-		if (!folios_ser) {
-			err = -EINVAL;
-			goto put_file;
-		}
-
-		err = shmem_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
-		vfree(folios_ser);
-		if (err)
-			goto put_file;
-	}
+	err = shmem_luo_restore_folios(file, ser);
+	if (err)
+		goto put_file;
 
 	args->file = file;
-	kho_restore_free(ser);
-
 	return 0;
 
 put_file:
 	fput(file);
-free_ser:
-	kho_restore_free(ser);
 	return err;
 }
 
-- 
2.56.0.542.g3ef89b7020-goog


