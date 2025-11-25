Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B470CD0EE0E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DA396B0032; Tue, 25 Nov 2025 11:59:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18AB46B007B; Tue, 25 Nov 2025 11:59:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004DB6B0088; Tue, 25 Nov 2025 11:59:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC5326B0032
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E56413A720
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:31 +0000 (UTC)
X-FDA: 84149740542.30.CB44F7F
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id B30AD140011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wq1bjI5X;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089969; a=rsa-sha256;
	cv=none;
	b=YIuTPsaiqDnbPHF6btZdpmoNG81LRKkmsYEW+pwUq7DPwe80tk+PeZxcrlT2I20UGlqbHr
	j6pxVkd6Vc1tNyZJeFaNGcgsLbUQ3gkSrZtsmRyixZr4WPbdNZIK6vqNb9+HNJFBbhiNWF
	UNF4eeUTjfaTvTcLmRGiST4UJ5ZLF5c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wq1bjI5X;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLwSseklhA0qKOMy2cW44bpZPsfi2vW7qm+LuafppIg=;
	b=EnFgUK2dURbfTpTZKTLkT0y71teB8/boKgsyzUHl+1dJIg4v8NkxwWuWs19tentYniFQFe
	+fMqWivIixxA3VTi4Unnws43B/bNipg4aNVt7ryc1zb5Isnxm3nj2r8TvJqlTY6/hgn1gs
	HNM4cWIueN8yp73QzG0T3h3rqAtfbCM=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-78aa642f306so24805187b3.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089969; x=1764694769; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rLwSseklhA0qKOMy2cW44bpZPsfi2vW7qm+LuafppIg=;
        b=Wq1bjI5XVgRiVL0dxE/4UgOvwxnhl4WJ/+RemRZV808TrTjtbqgYbdKt2SESN+uiDU
         tfc8XerocK1riqIRh7JzyQABt4Sr5Ws46UBg3L04/xQhcrQQCJs7BnqCjHSXFbE4DVL4
         bd5tJlYUmGM6hXpRg11oezH1g5iv8A6rxCanU7t6tYV2+PE4nE133TV2MaVl1PL8vWkC
         dz8xD/r66BnqoqYdmtYmA25SYckmQeXWq7YwIqJw1D8ochCZLZrpkQpCqf1yspEbNFjX
         bbTyLQ/ugvC9yICnGvvj9SxG06ahDRN+HP1+4Oo5SzP1v0iboXkaV/uhYeCYKMfoUpZq
         aCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089969; x=1764694769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rLwSseklhA0qKOMy2cW44bpZPsfi2vW7qm+LuafppIg=;
        b=jG4OnmRufwo3Q5p0E/NfJccnyWWbppr9xs9pDqZbhwauAD4jAZUqHz/euTgQy0BFaV
         I2WhdsMMfMluHCGO4Usip5PWVvyR0z7KiqKQc6JCGbGUzZKgh51Tk1sEe4OUoun7H5tx
         UczSc/qIvcbCoKXsZJfSuQ9N3XkrsXg7jHPdsGktFtA9tsj2Ba2hub3Tew1ShgrlHpmO
         Q0I8pGysLllKFjGO9XNKFGxmw1a15dUYbXlM25l5McG06g0dvc6m1FBqqEkQG//SFdlj
         VgEinBd83EWG5rJw3Mxv8x7y4ga2GztoqYvfAC5A+QnFg6BZLwdJ4bAckTVrORMMdlfg
         KXgw==
X-Forwarded-Encrypted: i=1; AJvYcCXSxPjVuMJfcnX95QNv9z4GJXDutffgFiLtCqt2L13mXLKie9rL/51lZBBAJlcJfdToiUTu7sIYAg==@kvack.org
X-Gm-Message-State: AOJu0YyTmVZR6RqihlzjoEl+vefQAspy/+cfQPlp7Wv4rcHB0ieN8u0s
	+TJQ+VIvw4CAO+FFamtQBr3xNihu5EO3U6jePWMQ8hv12OtiSCa1/6ZUPTHu4vM6FjQ=
X-Gm-Gg: ASbGnctqhbFd6AmGtxXfZOpqaNWMWYqa9jrQOKZAebsdCUmHwXm2jhIMxJzOr4T1Orz
	KEvR3HbaO7rNWm1aBUgxGsguLMUce9h2ul9jdctXVdGS/iLIF1gehvq1QzRtRY7gHDRs7PbPUw5
	+iEsiIE4/N1fJKpuZcdsq6PILPZwwg6/73tkvGEUCyZd0lfEEuBquSWIn7E1Rpd5gr2bREoZBF6
	j+5lDe/1okc3Cek2E5XSmk/50E5gN4G+6mE3S8jtlvGcG285s9vHAp6AL3rnD2oaRJGebZuDmYS
	/U2XBQlhm0t4Zip3MmzuO3CposRYYfQO5YUtOlwYa4nUxsfEFacjxLFGqBLa6hQneB2vVjX/fUS
	cAmUx3Yi837ToLZtOX2gPdBTiFJqHhscfTvwLj3jF+wto2IvimmgPXd6bJJjTcHrR/n61n8CnKJ
	1/ZBNY+qPs0hkzOmQ3u4x5n6BRmKG1dF2SEb5cliq4gVSwGkesv7t577SD37BA7Xtedm4HqRj5j
	iY=
X-Google-Smtp-Source: AGHT+IHyOGiEIWn7K/FqPN8HAm8rR5ND4rL8A082/WWeW+u5rZ2m5KAWzpxwpgtD4aV75ucYKtS3TQ==
X-Received: by 2002:a05:690c:4b08:b0:788:1086:8834 with SMTP id 00721157ae682-78ab6d811b4mr30671357b3.12.1764089968779;
        Tue, 25 Nov 2025 08:59:28 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:28 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v8 11/18] mm: shmem: allow freezing inode mapping
Date: Tue, 25 Nov 2025 11:58:41 -0500
Message-ID: <20251125165850.3389713-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B30AD140011
X-Stat-Signature: md7agkpg8ynodwsmom186xg9fakxbj5z
X-Rspam-User: 
X-HE-Tag: 1764089969-154222
X-HE-Meta: U2FsdGVkX1+1NHv4e54IXn/GJigjP6hi2Dst4RrSAAieYITEgVNE+cvAG1V55u4CfZoUNMR3Vrle94mYNEOH5DLJRukscHdZXLBtWWpz9ET6xNXKu5dLFYpCseLaRpTK8wIsUpmp8l5wydAlJKxqvdbxfYrALIwZMhrwJTOEnlZzF4K24FOFpY/4KCScjBjvKXORbHa+KaX6diazPAZWvtzg7jV+EghaxJ2uJe9dg35nkvbAcryGISBDxGv0klqCAZK8DXuNmVC40ebIfC27eW2asHRe+CvOcQnkuq8ZsJ4pLpDD5mdV1Eo9pQgFq1J9FAB5CSmMp4uqioBBBkh6m3XK7+t+EyIOCBHoYKp7euGltt2F5japv3iI+ZgVjgaRhqXT2KZBIyzFMrXLPKymF2Ch0kReO0INQV5tKakK8wqeVii1Ads4BVDyPNhzNlvmVkiRBl3ZRa3sohMb9KZfR8TRhN/8LlOZddohsxLwdN1ILBuMEnZmFBgPrvqgAEvSfJ3aPUFb+ODRdTDRX+WKSe0qEiqU12PmdHLGn/bvcgnhy7g2BJbA1S//HpDOxxQRNelq6LXJZQIbCa5odA2NXIEZmoMtWrpNnnEAICUd9NoI/Jb+5LpbrzwvcqECZvdYugfyMseFwl769IeVRS7oUigril06Xtvwo0gsxjuHPh6hbCCKdig2SQ6fsaNPqDNVAbrHJ6+MG8LmX3+vMniftMa/M+BsaOMWQz9B5vt1DwgS+wZobfeBzkZ3tpE2zRps7N74CrKa9IuMn3NEYTvAV2jekoHkKI581UsVUAhapemqAYW9TrOzAAEBOiGLD+oWhKSLZnCGOxCF0SCH2tLnFKcTKW6qvoJzSjazj1hQCvffiOUmkuG8qNJpWNOqO7OCnaBTRvG92yoiZ/gtunHu/78TSUfEtna7G0kTmZKemo6QJOjjtA3I/7yGu8ZxBaTwIDzGjLmwZGE4GbEU+Aj
 uVeItcvr
 /PNMK2YYPRT42lhD/zafEaU5T4m+mwXFAxCCqux9Ye9/506pq8UZd52VQCMDKC+FoapemuGs0xLwXpzWBKkJQEfunrf1LNCHdpLOAm2SihA/i8w69n+mL/fD+ztHB9r8/KfxyxJ2Jp0IxQUxJvVsS4xw6gcjBG0rTlEa6AJCEaUZpk+Wfhn8Wl6zMOOP7z2rEaJUEwMHC8x87Sbbz1Voi6HsDlrB6iJXzaYGEUanhLzqXotfQDx0CuFna9VqRQ8QFn8XzKWATSomjFFI5i7phngpXjITjzoPt0mu1vDzdXzo5rXLalBIgGp2U4Gcwa6k4eTjk53CkHQYBgF9Jre0N7Owh2zb4z/hS22pMUg1ZjWfq6bIa0u5hjFsx2vzMUeTHTvhfqRR6ufUzGXFLmKPusRkd0d80JFqie/R8oGd7nSZTxAk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

To prepare a shmem inode for live update, its index -> folio mappings
must be serialized. Once the mappings are serialized, they cannot change
since it would cause the serialized data to become inconsistent. This
can be done by pinning the folios to avoid migration, and by making sure
no folios can be added to or removed from the inode.

While mechanisms to pin folios already exist, the only way to stop
folios being added or removed are the grow and shrink file seals. But
file seals come with their own semantics, one of which is that they
can't be removed. This doesn't work with liveupdate since it can be
cancelled or error out, which would need the seals to be removed and the
file's normal functionality to be restored.

Introduce SHMEM_F_MAPPING_FROZEN to indicate this instead. It is
internal to shmem and is not directly exposed to userspace. It functions
similar to F_SEAL_GROW | F_SEAL_SHRINK, but additionally disallows hole
punching, and can be removed.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/shmem_fs.h | 17 +++++++++++++++++
 mm/shmem.c               | 11 +++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 650874b400b5..d34a64eafe60 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -24,6 +24,14 @@ struct swap_iocb;
 #define SHMEM_F_NORESERVE	BIT(0)
 /* Disallow swapping. */
 #define SHMEM_F_LOCKED		BIT(1)
+/*
+ * Disallow growing, shrinking, or hole punching in the inode. Combined with
+ * folio pinning, makes sure the inode's mapping stays fixed.
+ *
+ * In some ways similar to F_SEAL_GROW | F_SEAL_SHRINK, but can be removed and
+ * isn't directly visible to userspace.
+ */
+#define SHMEM_F_MAPPING_FROZEN	BIT(2)
 
 struct shmem_inode_info {
 	spinlock_t		lock;
@@ -186,6 +194,15 @@ static inline bool shmem_file(struct file *file)
 	return shmem_mapping(file->f_mapping);
 }
 
+/* Must be called with inode lock taken exclusive. */
+static inline void shmem_freeze(struct inode *inode, bool freeze)
+{
+	if (freeze)
+		SHMEM_I(inode)->flags |= SHMEM_F_MAPPING_FROZEN;
+	else
+		SHMEM_I(inode)->flags &= ~SHMEM_F_MAPPING_FROZEN;
+}
+
 /*
  * If fallocate(FALLOC_FL_KEEP_SIZE) has been used, there may be pages
  * beyond i_size's notion of EOF, which fallocate has committed to reserving:
diff --git a/mm/shmem.c b/mm/shmem.c
index 1d5036dec08a..786573479360 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1297,6 +1297,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 			return -EPERM;
 
 		if (newsize != oldsize) {
+			if (info->flags & SHMEM_F_MAPPING_FROZEN)
+				return -EPERM;
 			error = shmem_reacct_size(SHMEM_I(inode)->flags,
 					oldsize, newsize);
 			if (error)
@@ -3289,6 +3291,10 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 			return -EPERM;
 	}
 
+	if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
+		     pos + len > inode->i_size))
+		return -EPERM;
+
 	ret = shmem_get_folio(inode, index, pos + len, &folio, SGP_WRITE);
 	if (ret)
 		return ret;
@@ -3662,6 +3668,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
 	inode_lock(inode);
 
+	if (info->flags & SHMEM_F_MAPPING_FROZEN) {
+		error = -EPERM;
+		goto out;
+	}
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		struct address_space *mapping = file->f_mapping;
 		loff_t unmap_start = round_up(offset, PAGE_SIZE);
-- 
2.52.0.460.gd25c4c69ec-goog


