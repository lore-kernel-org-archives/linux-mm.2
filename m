Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B251B606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lUDBEP95
Received: by kanga.kvack.org (Postfix)
	id 60DF96B05C3; Tue, 10 Nov 2026 00:02:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE3C6B05C4; Tue, 10 Nov 2026 00:02:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F2C6B05C5; Tue, 10 Nov 2026 00:02:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 199E56B05C3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90C421208A4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:21 +0000 (UTC)
X-FDA: 85418013282.17.AC1DE58
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF971C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lUDBEP95;
	spf=pass (imf22.hostedemail.com: domain of 3WqXyagkKCM0CtAD6Bt0Dz77z4x.v75416DG-553Etv3.7Az@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3WqXyagkKCM0CtAD6Bt0Dz77z4x.v75416DG-553Etv3.7Az@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286939;
	b=O8tXmzpSujAyxKbCGMja0xgmQuVhC3n4LMhRboIMQp6risiS9QnG37uY/2NiHqZaWC0lEt
	9wZrkiYNsQFVbEgUCCmvsaF0Gm9e6ttsLZf8hgJjUTp8zZAJpeQW8JlDm0OOGPDJD03dcu
	QPUvDiKU0U/irLY+suMXGgGtHe1smtE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lUDBEP95;
	spf=pass (imf22.hostedemail.com: domain of 3WqXyagkKCM0CtAD6Bt0Dz77z4x.v75416DG-553Etv3.7Az@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3WqXyagkKCM0CtAD6Bt0Dz77z4x.v75416DG-553Etv3.7Az@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jomqh3EBPc599hlxv7mE3jDDZh0m6vOE0Julqd7EtAs=;
	b=Bldg73WMhl0CFkcB/KqXMiotwtmYYyqJRRYrUXfX57rzRo2Bqy2XyYajQ8QWc5bGLxrlO3
	I9SKmggVHOqXD5snkNRHpzf6kpFup2nh6vnrnw4f4EjATXMM1V1uxljLqF/rKjFlURC2e3
	15Qup0Pa+hQG+3sU1wIf1DMEbmIw8Sc=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c40285df2a0so96845166b.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286938; x=1794891738; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jomqh3EBPc599hlxv7mE3jDDZh0m6vOE0Julqd7EtAs=;
        b=lUDBEP95OzOcPrKi+rRqnu9tocWAxLyW1If12ZtygOtd7/25aNS4jLVknwOX8st1e+
         wm2fbHAb7qm9xs354YRvNZrtm1YqwqyJvQzkT3xHBaM6EpomDzkJU1dzq/9DymZVWcaP
         9++PbBZ6FGFN5rV+MpkkSlFNnJHwgz446ImJND/M6pKLW8omrH2MaK5NkR2R1SCMfnCc
         vwnr+N9dvdXvEed3ZtzFFnq4UPQC1aC1zoJXvQ7pjETgLXwqBwI6MOdfiipIvATAynmQ
         P6Akb5qpVr1U6Z9Gu+yUuqcw+rxeEBcLBgVdAK3mJ4FfFeiBVJmfgnDhPWxEuB60n2bO
         Hnlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286938; x=1794891738;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jomqh3EBPc599hlxv7mE3jDDZh0m6vOE0Julqd7EtAs=;
        b=udo8j+ZzaGiD2tnYB7t/VFG5GiNzSQvhRLdYnXOfgQ4xjeiT15ZkaTh9oLI0fOTmu5
         lkxXI56XBzgiRIYPdwDKM0Mlq3+CQYA0FnO3o8o/Y9eD4ETesv/UI8Nk5VGrHvvZO+s8
         rGNoSrrmLpteZ+V6nPPSvd5FoRx+N4uxsxFIvdwnfstLLgVdQw8ky4B0MXuSfzc4xE1R
         EJLVgj2UHwpy2R60YDLgo2YSZDyI0zMSz1rhfxa66LUknVKMTkrMwdy9KkpwdOtyp6PO
         gRouA/lcHqOc3rKrKRy24HIoA55KjO0lK3Pq7TH3ECIFor+C/7GmYflysQ2LLWkl0Chw
         npQQ==
X-Forwarded-Encrypted: i=1; AL+hErHDDSsRwHUmjzbazXFmpGnmn6SI4Zw1ox/W8xvlvep4WgVhbvRTBVsIOvPLJEmGMvO+tS58iQq6mA==@kvack.org
X-Gm-Message-State: APuU4Z+LTz5x04N8hEmlh9voU7213za3EYr0viwuUXZnBXLCu/oeLHYT
	FihEGyESyugjuM+zDxb1Td2jDAbHxpc7sI3py8pnkcxwd2pzRsAQI8auf3nT1kyJcTzoi2/Fmmi
	G7KMnjFrJ3mkWOFoFPg==
X-Received: from edzg2.prod.google.com ([2002:a05:6402:902:b0:6b5:8540:2bf])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d8f:b0:c48:a838:c16d with SMTP id a640c23a62f3a-c5049629dbbmr100182566b.30.1794286938072;
 Mon, 09 Nov 2026 21:02:18 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:55 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-13-tarunsahu@google.com>
Subject: [PATCH v4 12/19] liveupdate: Add feature header to struct luo_file_ser
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: knurqkf315p4ugoy9mfpgyxwsfoiatoy
X-Rspamd-Queue-Id: CF971C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286939-111843
X-HE-Meta: U2FsdGVkX19o/kJL8UOSGkfh82TonMHuAOBR4VlmrJRqKg8xV526CDhbzsYYfloilFQ4Ksv1AKvANvNLu2ZMu7s7M9GI7Nq6Dezz09YAH7xdvLlflE7YwDydwTQGxNQeTRhA3e0TV5IBc9NdXTGDC5HWLyS3CFuzmyzTbaRL1x9BPg0PJ00G+yIfJ1LR91Et5WPTTPRD6HvH9QMG1LZXcbkspnLzOCk7tqK0XbiCagG2h8svY2uWM2VR/24BVKyNvl/icLWymOyvp+RTqny7+qAMpCP4fdOSAoVezi6HYslqpILosi+YOkYKcnCEZVzhS0fUae5LOHHs0yl0EhOVfRyWVDXfrCDaINcUbE8RoVLpPKy67/go3n7mCzXyXP0eH3RQAQQLCAnU9N0IlHyTXMIj62t5gGF/nWzB49F99jwWI6zc8nc6jTBafzQW/K7UFkS5S99KKLQBUvW+G/3a1wFfMGlxZZSmgSa4jrD1crgnY/W13A7JCnDzZMXw1E8B4Y6FbIP3+Z4kb4dYjDA1FOvKlN+1hUJdouLAgZ/M8R2Ezn1K2H/6cFzsREARt1+kb2SnmW1dT/RJvsRmjHoCjbJzduFCRKVwEXxjcP3cipAbOkPFWxLhbNVrjrcFYLJ64/UaJKxUaWu7yiMjI71p5TtzB7EstyuJ640TbxVRytzY5jiscAk3SxJxSttPjnkYZ4L2dQ9I4JoZ+aKQ0Cm66YmJz/hsw3tNDtI2koMKWAzwdcdF+1e/iZOtrsX5dUHPPwQev5fv7yLjleRayZ8l1FIqUVtD8gxkch4bbfnjYAHktUSemKwdW/6S4W7oCS7lhvQjiSZwxZEoOQ5i3cWZsx7K6pDuPyiJn8zVowXrp9VBvJvdrqbd36uIhd8GggnrTvmQR/xhDZVSofQC2Ou5Umvyxmz+A7GAx2ok4ELJRA0UM9jOGXK3W4sdPuSgoDiK1wWJWqvDIVdJF5KhOyo
 kX26dsGV
 f2uAsgNMy8WJe9FKyqMBhfenJaSsPGbSKmkxugRKpsrfxf9P5dGY3TSHe1Agqayws394+B7316m0XTdmMZ6tZrKkB+dLiYPlrASlBWWYBvQPbteNT5B0JVcNmtDZSGqZRPgh+BNRbGyWcgOAFfDQPc3sfFCgU5GDxYWe5tb+Wp+eSjL+JNXfKdj5Px4xQ8CI8f3mlGhSaNREGt+tKYf6lXj7QVdeqzk8sRr84QPg0TzEh/9fJ3SUMYuG7C6NPCR+coB4V0ujJI9fdn0DElz6qhBTyfGWMSwZHpr2xZLVSbyu393LF5wcMVard+GyF9HdroE3aOFxFA4Tillks5sC0TUnCm26oqhpDi2V40A80zVV3jocQrfGsJUXMkt/PiGej7avB2i+t2e+VghVLssFzsWqNX8Jyj8MPio3YmMpDpB0Rt12cxiBvSknyzZBIdEAMH17BdL+4CEbI4vFHuSRXf/WNn4ZoiLC+1GsV1kH7er3eLS6a0GzmAkrPVpt2gqCDcBTSCa4OdzcjRcpOI+Wmz1DRqPVN6HDJ5iErvfebUiqiru8XDrBEVUzOrmlXK8yn3YOlJyfv4Sldm77q4zAc/Oy7JQGLVgJUdm4bF3VJFqH9OcoyKhbRDV9BiVIIDQ7u/Lh239Ud8q1VYzYm83rjvcfmTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Precede each serialized file entry in a LUO file set KHO block set with
struct kho_ser_hdr via DECLARE_KHO_SER so future per-file metadata
features can append fields to struct luo_file_ser without breaking
compatibility between adjacent kernels.

Initialize file set block sets with kho_ser_size(luo_file_ser), initialize
each entry feature header in luo_file_freeze(), and validate the incoming
feature header in luo_file_deserialize_one() before accessing the struct
luo_file_ser payload.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h  |  6 +++---
 kernel/liveupdate/luo_file.c | 26 +++++++++++++++++++-------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index bd19211c64e1..38b4658183a2 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -92,6 +92,8 @@ DECLARE_KHO_SER(luo_ser, 24, 0, 0);
  * @compatible:  File handler compatible string.
  * @data:        Private data
  * @token:       User provided token for this file
+ *
+ * Preceded by &struct kho_ser_hdr.
  */
 struct luo_file_ser {
 	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
@@ -99,9 +101,7 @@ struct luo_file_ser {
 	u64 token;
 };
 
-static_assert(sizeof(struct luo_file_ser) == 64);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct luo_file_ser) == 8);
+DECLARE_KHO_SER(luo_file_ser, 64, 0, 0);
 
 /**
  * struct luo_file_set_ser - Represents the serialized metadata for file set
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 02d09a80d785..2da327f8bdae 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -486,10 +486,12 @@ int luo_file_freeze(struct luo_file_set *file_set,
 	kho_block_set_it_init(&it, &file_set->block_set);
 
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
-		struct luo_file_ser *file_ser = kho_block_set_it_reserve_entry(&it);
+		DECLARE_KHO_SER_HDR(luo_file_ser, *fhdr) =
+			kho_block_set_it_reserve_entry(&it);
+		struct luo_file_ser *file_ser;
 
 		/* This should not fail normally as blocks were pre-allocated */
-		if (WARN_ON_ONCE(!file_ser)) {
+		if (WARN_ON_ONCE(!fhdr)) {
 			err = -ENOSPC;
 			goto err_unfreeze;
 		}
@@ -502,6 +504,8 @@ int luo_file_freeze(struct luo_file_set *file_set,
 			goto err_unfreeze;
 		}
 
+		kho_ser_init(fhdr, luo_file_ser);
+		file_ser = kho_ser_payload(fhdr, luo_file_ser);
 		strscpy(file_ser->compatible, luo_file->fh->compatible,
 			sizeof(file_ser->compatible));
 		file_ser->data = luo_file->serialized_data;
@@ -742,11 +746,19 @@ int luo_file_finish(struct luo_file_set *file_set)
 }
 
 static int luo_file_deserialize_one(struct luo_file_set *file_set,
-				    struct luo_file_ser *ser)
+				    DECLARE_KHO_SER_HDR(luo_file_ser, *fhdr))
 {
 	struct liveupdate_file_handler *fh;
 	bool handler_found = false;
+	struct luo_file_ser *ser;
 	struct luo_file *luo_file;
+	int err;
+
+	err = kho_ser_validate(fhdr, luo_file_ser);
+	if (err)
+		return err;
+
+	ser = kho_ser_payload(fhdr, luo_file_ser);
 
 	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
@@ -810,7 +822,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 			 DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr))
 {
 	struct luo_file_set_ser *file_set_ser;
-	struct luo_file_ser *file_ser;
+	DECLARE_KHO_SER_HDR(luo_file_ser, *fhdr);
 	struct kho_block_set_it it;
 	int err;
 
@@ -848,8 +860,8 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	 * reliably reset devices and reclaim memory.
 	 */
 	kho_block_set_it_init(&it, &file_set->block_set);
-	while ((file_ser = kho_block_set_it_read_entry(&it))) {
-		err = luo_file_deserialize_one(file_set, file_ser);
+	while ((fhdr = kho_block_set_it_read_entry(&it))) {
+		err = luo_file_deserialize_one(file_set, fhdr);
 		if (err)
 			goto err_destroy_blocks;
 		file_set->count++;
@@ -883,7 +895,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 void luo_file_set_init(struct luo_file_set *file_set)
 {
 	INIT_LIST_HEAD(&file_set->files_list);
-	kho_block_set_init(&file_set->block_set, sizeof(struct luo_file_ser));
+	kho_block_set_init(&file_set->block_set, kho_ser_size(luo_file_ser));
 }
 
 void luo_file_set_destroy(struct luo_file_set *file_set)
-- 
2.56.0.506.g506a7eabc5-goog


