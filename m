Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA982606A336
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fU4+0THl
Received: by kanga.kvack.org (Postfix)
	id 265796B05CA; Tue, 10 Nov 2026 00:02:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215076B05CB; Tue, 10 Nov 2026 00:02:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B54D6B05CD; Tue, 10 Nov 2026 00:02:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE87F6B05CA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67347A84A6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:27 +0000 (UTC)
X-FDA: 85418013534.14.840818A
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf17.hostedemail.com (Postfix) with ESMTP id A76B440002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fU4+0THl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3YKXyagkKCNMIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3YKXyagkKCNMIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgBCpjKfzBqNZpJUjcpaoZF5kynIHAd0/p/NXGzkOjc=;
	b=A+sW99fWPs39qE0+BuBJZRMLcYroCtXHB+S9zrOCccDph0fNwzDFCKn8oL/ZFbqps+NylD
	KVHaXADVG39OW7qIWupgTYFTZakZsEZ7EZdkPpbTk7QWF6ARvzEZ5kvbneVmfOEBgLoE2j
	7YxOfrTMZs8HxKRkktbE1MteZfZ8nU0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fU4+0THl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3YKXyagkKCNMIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3YKXyagkKCNMIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286945;
	b=IzxzxS1UhwneaiTT8cNSf3SqAq1qKDsjDIUkY3JzbFEi9JU1aGYBeunNruVE3EWzLIgLoM
	UcvTkWDr99bTXdap7jRTtBclPsVFg50dz4HjPwE8/JjfU8RsC8kJhvULAi4W3E6QT2XXWv
	7lYhv7SKiaHWZIK+HNEbpAt5blYk2iI=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b76329afcdso43494a12.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286944; x=1794891744; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CgBCpjKfzBqNZpJUjcpaoZF5kynIHAd0/p/NXGzkOjc=;
        b=fU4+0THlJbMe5BvYH+JqKQv3Xk7k8jnMnrcBP/eoUBpYEpTCPWmojKuhu7c59JpoRA
         1uzhCgn9OgIibZc3Fr/Q4apU30c29N/QtpBxOm6a0Gg6H1lRTzdb58k2LvpotebcU2nT
         699bfWJwkzd2+WWafFPFtRYELGVGBz6Kp79TouM837nGfGveOpOAgr+mDLumkwjrBzvv
         QbruaWw2O/2hEDMUVGmJ1l+xNEZLubcO1M7gaKQwz7pVS0lqLY8npJ+INujz8dK5v1TB
         fEwq/h8qEDlIfpkTzbNw8K+rIMkr7kh9yaEmInlr8GROyPq0CxhhZhQqGZX7jpkGJ5U3
         2VUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286944; x=1794891744;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CgBCpjKfzBqNZpJUjcpaoZF5kynIHAd0/p/NXGzkOjc=;
        b=vB7+/9+yiblm7fJuZyMqxIIQBzRZVT7Q0fs/NkyHsVQbUQf1BtiJD5A42OGlP1fq59
         Bfj7GMAZ0mcWBhsg/6juaE+j45iEc6+W+jyFTgNDTPzbx57fNjTB3wJBUptlhNiVd6hK
         1HZpzx9RnpyqbCKHVLD0HM2wOrFTn4YybHzaUbzQZJJTWuGbqci1iba18E7Rf/On7Cqw
         un/tPKiF264doRdw6HZgCVhsZT3RI+FyHt+ahEgRYDx4ixGyI00JNmpWx5CLbLKD21VN
         +LpHic8CWirCuXfyruz1M7k+tUm3V5fpLtiPZv3FkQ3NiHiE8kQ0ClqivJ/TSvoGltqz
         gDkw==
X-Forwarded-Encrypted: i=1; AL+hErH7lx2wjOcmOiJ7/pSvclR8yOjNGGWEERMOoeIIBNqIcEatADJmsm3nCaLk+ccw4sVQzHVF0cWTdA==@kvack.org
X-Gm-Message-State: APuU4Z9Q4VjhuwMEUX6IeJaEAqwK8SEh0FEnW9FlcCwTg7aWJF4kBCiq
	O9tqsSbp1+RpF2zy0vA+vD/UHddmgESvqfRRqtVOwe8YhF5hsyP6cDoUDYTsgCevEUlhjRHlPcP
	xtj83Om3ZZvEQsoDp8A==
X-Received: from edtj4.prod.google.com ([2002:aa7:ca44:0:b0:6b7:3b3e:5148])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:d496:0:b0:6ac:934e:a9ca with SMTP id 4fb4d7f45d1cf-6b755626f5fmr907953a12.0.1794286944079;
 Mon, 09 Nov 2026 21:02:24 -0800 (PST)
Date: Tue, 10 Nov 2026 05:02:00 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-18-tarunsahu@google.com>
Subject: [PATCH v4 17/19] mm: memfd_luo: Add feature header to struct memfd_luo_ser
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A76B440002
X-Stat-Signature: cfmhcg78rstz6jxgsx3qgzqhsqiceftt
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286945-225601
X-HE-Meta: U2FsdGVkX18G7MNudcxsCZojHfhvetrlIiixA+Vyh6hlYZa3jbqmaQMAwGZWR4ZE10RONaP/i2agiMsxxIP98v7GTGCf5zFWoJIBD+hh+tvBdudAwcMRzdp4Vgmw/slYRV/nZ5Uqlbccu0ICZmvO9i/3VvicDVj99n+CIYKylQPcWhh3h7ljuAqhIVzl5w5Caiillu0Ths+1pWnWRHKDSq0ld/ji1O55Wtkhps2qGTbRJMgWOXhcbrB2SpSYKQDimgdTyB4ro0N8J0T2g0TKDNzIK2r7vxEJQvJFfF0FHuKJ2cJNrEgY6zjgO8xAhy/il/lyCRw3l91c5riT+OEy/JU4FxL1gDDTjKZZd5OHydP2OAbzR6+EcgTx1ETu+SYb0cQSCVaieSd0Qa7ochryhs8jsl0Qhkk3nd7JuJPpyd+6Q60zbgAGZUjreU78/b7aJRI52MbutHc7qWd0boUNZcn5MM4Z0kNmcrOZTgWnQNKzUtKbqQ3Xvx7+vfTk8qnFficS4v9HohD9A9RCnUv78UUXoUQyLh6WpmJ37DWCpQYRQBYOHVgHXT08tU7mlcJAk3DtlxJGtXRv/tiHBKM27FdFhMza1NuxnoXVlabAHa8KvYHhi5uBUiXhWWMPKMRFoL6X08CcKXvxfCoT1QQh6fI7r+vdfDFmoZIEaTSIeYBgQ8JGi5AQRtLNptxa3l1uN82wLXxOYcLUmgb6u+PAKxZC02NUXJpofqGHe9D7w6xxzC37R64wdButsarnwPidnmepgWKRDhtIaRRZ7zF2kFbsdRi8Vpfo2LJA4fUWdeVkOEIi7wz537k3cByJyPo3/ZXewxbEVxrd7B6FgS/3AKNfI61ReTQ9Y/n3+xismutdYVy607g7GrKJAk7ZA96js5L6XY1ThYWmso0Gn7VrbzcaK+CUincSqq5zW74wBbVwn70xu6hqMLwlE4dAUfHccxZch/WgbNRBnJJNr3o
 +hiB9xEC
 B+7D/Kj+lTmOuylHcTiNFHU2CusEGXuVASyARVUMHFXBJCIIKHRIqThWh3Wq17InFpmfchzImVcyJbXO9BeIKXIeoa9d+yPs9FpIny5q+02GU3jK17+Q05W26Jjyn5nhftZn9s5+WQp8xgEgatLQlsrfl/CvbZAcUEcBdyS5s55sl1WXdtCOAImgNwiqYskHk5U4Vhahj5S8tugGwvLLxDGFOY1zD3l9WUNqxZ4zakhpoRb6riKKw4Ef+AI1HEVGjPaZyvMginy3rcvVF4JY/Z+c1sVFXRGOVHexxvEqWeEnx9lM+BVjdN0bUl6isSPcLuAbyvVtDs5tLoQgvBXZ3+HxLWEx0C16FAq/W8cFHw6v9uE49CwdWsY2EyLQpv7+AQmQdQGgW8fZIhnvvukkyywVwViBr4wwIlJcuPBYZfcqf81TaUEThVMkgAcIFG4SQvIOKw63E3NRPkS+J1JF9KxJIALUd2Jbc+KGcmrNjTfsr+mhcESjoSXaA21ohFT8VniNGzTWN6KP049p2+MCFA/z/0AMWialrSdeaVNOfZ+7JfmN6tqzaTWQJlSSF5xJGgpGSE7cFrxARId/rTm5sTuk1Afy/iHlzJgI2aiQSexRqf6KPQmwtqDhVO2IfwUYXoqZJeDKTRt3mm+JoWQWq2TeH6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Precede struct memfd_luo_ser with struct kho_ser_hdr using
DECLARE_KHO_SER. Later memfd features can be appended under new
feature indices without breaking compatibility between adjacent kernels.

Allocate both the memfd_luo_ser feature header and the kho_vmalloc
feature header in the same preserved folio. On restore and retrieve,
validate incoming required features before accessing payload fields.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/memfd.h |  7 ++--
 mm/memfd_luo.c                | 67 ++++++++++++++++++++++++-----------
 2 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index b0597c438973..27f8880ee593 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -83,6 +83,8 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  * @nr_folios:   Number of folios in the folios array.
  * @folios_fhdr: Pointer to KHO vmalloc descriptor for the array of
  *               struct memfd_luo_folio_ser.
+ *
+ * Preceded by &struct kho_ser_hdr.
  */
 struct memfd_luo_ser {
 	u64 pos;
@@ -93,9 +95,8 @@ struct memfd_luo_ser {
 	DECLARE_KHOSER_PTR(folios_fhdr, DECLARE_KHO_SER_HDR(kho_vmalloc, *));
 };
 
-static_assert(sizeof(struct memfd_luo_ser) == 40);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct memfd_luo_ser) == 8);
+/* Register memfd_luo_ser with KHO serialization accessors */
+DECLARE_KHO_SER(memfd_luo_ser, 40, 0, 0);
 
 /* The compatibility string for memfd file handler */
 #define MEMFD_LUO_FH_COMPATIBLE	"memfd-v3"
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 74c1ff5877c3..94510f73a606 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -256,16 +256,21 @@ static void memfd_luo_unpreserve_folios(DECLARE_KHO_SER_HDR(kho_vmalloc, *folios
 
 static size_t memfd_luo_ser_size(void)
 {
-	return sizeof(struct memfd_luo_ser) + kho_ser_size(kho_vmalloc);
+	return kho_ser_size(memfd_luo_ser) + kho_ser_size(kho_vmalloc);
 }
 
-static struct memfd_luo_ser *memfd_luo_ser_init(void *mem)
+static struct memfd_luo_ser *
+memfd_luo_ser_init(DECLARE_KHO_SER_HDR(memfd_luo_ser, *fhdr))
 {
 	DECLARE_KHO_SER_HDR(kho_vmalloc, *folios_fhdr);
-	struct memfd_luo_ser *ser = mem;
+	struct memfd_luo_ser *ser;
+
+	kho_ser_init(fhdr, memfd_luo_ser);
+	folios_fhdr = (void *)fhdr + kho_ser_size(memfd_luo_ser);
 
-	folios_fhdr = mem + sizeof(struct memfd_luo_ser);
+	ser = kho_ser_payload(fhdr, memfd_luo_ser);
 	KHOSER_STORE_PTR(ser->folios_fhdr, folios_fhdr);
+
 	return ser;
 }
 
@@ -273,6 +278,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
 	struct memfd_luo_folio_ser *folios_ser;
+	DECLARE_KHO_SER_HDR(memfd_luo_ser, *fhdr);
 	struct memfd_luo_ser *ser;
 	int err = 0, seals;
 	u64 inode_size;
@@ -304,12 +310,12 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	}
 
 	/* Allocate the main serialization structure in preserved memory */
-	ser = kho_alloc_preserve(memfd_luo_ser_size());
-	if (IS_ERR(ser)) {
-		err = PTR_ERR(ser);
+	fhdr = kho_alloc_preserve(memfd_luo_ser_size());
+	if (IS_ERR(fhdr)) {
+		err = PTR_ERR(fhdr);
 		goto err_unlock;
 	}
-	ser = memfd_luo_ser_init(ser);
+	ser = memfd_luo_ser_init(fhdr);
 
 	ser->pos = args->file->f_pos;
 	ser->size = inode_size;
@@ -323,12 +329,12 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	inode_unlock(inode);
 
 	args->private_data = folios_ser;
-	args->serialized_data = virt_to_phys(ser);
+	args->serialized_data = virt_to_phys(fhdr);
 
 	return 0;
 
 err_free_ser:
-	kho_unpreserve_free(ser);
+	kho_unpreserve_free(fhdr);
 err_unlock:
 	shmem_freeze(inode, false);
 	inode_unlock(inode);
@@ -337,12 +343,14 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 
 static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 {
+	DECLARE_KHO_SER_HDR(memfd_luo_ser, *fhdr);
 	struct memfd_luo_ser *ser;
 
 	if (WARN_ON_ONCE(!args->serialized_data))
 		return -EINVAL;
 
-	ser = phys_to_virt(args->serialized_data);
+	fhdr = phys_to_virt(args->serialized_data);
+	ser = kho_ser_payload(fhdr, memfd_luo_ser);
 
 	/*
 	 * The pos might have changed since prepare. Everything else stays the
@@ -356,6 +364,7 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
+	DECLARE_KHO_SER_HDR(memfd_luo_ser, *fhdr);
 	struct memfd_luo_ser *ser;
 
 	if (WARN_ON_ONCE(!args->serialized_data))
@@ -364,13 +373,14 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 	inode_lock(inode);
 	shmem_freeze(inode, false);
 
-	ser = phys_to_virt(args->serialized_data);
+	fhdr = phys_to_virt(args->serialized_data);
+	ser = kho_ser_payload(fhdr, memfd_luo_ser);
 
 	memfd_luo_unpreserve_folios(KHOSER_LOAD_PTR(ser->folios_fhdr),
 				    args->private_data,
 				    ser->nr_folios);
 
-	kho_unpreserve_free(ser);
+	kho_unpreserve_free(fhdr);
 	inode_unlock(inode);
 }
 
@@ -402,6 +412,7 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
 static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 {
 	struct memfd_luo_folio_ser *folios_ser;
+	DECLARE_KHO_SER_HDR(memfd_luo_ser, *fhdr);
 	struct memfd_luo_ser *ser;
 
 	/*
@@ -412,10 +423,16 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (args->retrieve_status)
 		return;
 
-	ser = phys_to_virt(args->serialized_data);
-	if (!ser)
+	if (WARN_ON_ONCE(!args->serialized_data))
 		return;
 
+	fhdr = phys_to_virt(args->serialized_data);
+	if (kho_ser_validate(fhdr, memfd_luo_ser)) {
+		pr_warn("invalid feature header, folios not discarded\n");
+		goto out;
+	}
+
+	ser = kho_ser_payload(fhdr, memfd_luo_ser);
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(KHOSER_LOAD_PTR(ser->folios_fhdr));
 		if (!folios_ser)
@@ -426,7 +443,7 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	}
 
 out:
-	kho_restore_free(ser);
+	kho_restore_free(fhdr);
 }
 
 static int memfd_luo_retrieve_folios(struct file *file,
@@ -533,14 +550,24 @@ static int memfd_luo_retrieve_folios(struct file *file,
 static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 {
 	struct memfd_luo_folio_ser *folios_ser;
+	DECLARE_KHO_SER_HDR(memfd_luo_ser, *fhdr);
 	struct memfd_luo_ser *ser;
 	struct file *file;
 	int err;
 
-	ser = phys_to_virt(args->serialized_data);
-	if (!ser)
+	if (WARN_ON_ONCE(!args->serialized_data))
 		return -EINVAL;
 
+	fhdr = phys_to_virt(args->serialized_data);
+	err = kho_ser_validate(fhdr, memfd_luo_ser);
+	if (err) {
+		pr_err("memfd_luo_ser feature validation failed: %pe\n",
+		       ERR_PTR(err));
+		goto free_ser;
+	}
+
+	ser = kho_ser_payload(fhdr, memfd_luo_ser);
+
 	/* Make sure the file only has seals supported by this version. */
 	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
@@ -581,14 +608,14 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	}
 
 	args->file = file;
-	kho_restore_free(ser);
+	kho_restore_free(fhdr);
 
 	return 0;
 
 put_file:
 	fput(file);
 free_ser:
-	kho_restore_free(ser);
+	kho_restore_free(fhdr);
 	return err;
 }
 
-- 
2.56.0.506.g506a7eabc5-goog


