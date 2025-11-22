Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A72F7CFD312
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1E76B0089; Sat, 22 Nov 2025 17:24:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A26E6B008A; Sat, 22 Nov 2025 17:24:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143A56B008C; Sat, 22 Nov 2025 17:24:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE4D26B0089
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB8FF1A02D7
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:21 +0000 (UTC)
X-FDA: 84139672722.22.CE9D60D
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id DDFB540002
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="iI3bo/4V";
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VQkksdHZruPlACBWK27dtPpnM3dj37TPMUXRxmVJ+A=;
	b=XKesgS+CrTTqZjJv4+Grltou5GTTKj6o2BHcQb311Gy2VKDimu/V8pfYhaththOnfcXI/Y
	BGoIlKENh39Wu+dfVWaPHewXxgrzfKITjhq5+pmjZQA8n2G0I3EhA6WhYtzEww1z7O8O+6
	ENSfltTl2JDfX0MmDONwl7c75OjJNIE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="iI3bo/4V";
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850259; a=rsa-sha256;
	cv=none;
	b=XqzpShNW+FRQcYVMMm7OBtKbjlE6Z5H0VOgpmUadDVFsgESUwluWcsoUrgVd1nIVk7gYnl
	Ov8C9hN4yvOJSZt+7A0KXIsdFQBU5JUhyW3VRSZMn7mV/JcJ2hw0jwdmQQoswIZjl5rbDX
	RbcjSjHE+57P63j/XTn3FvUAYbADs5Y=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7866bca6765so27781637b3.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850259; x=1764455059; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+VQkksdHZruPlACBWK27dtPpnM3dj37TPMUXRxmVJ+A=;
        b=iI3bo/4V5dnIe1JxQanp5IiFxvHGbr4967xDbP6pJ+FCcMe4h4rxNPqDCO+tsRfXZL
         nBJgXpGJayJRW1j0Yo746iojalJ1UvynzMGNMnj3+NJQ8l9OVfp+mvwvurQt1U4Jr36L
         EZCaEOzsChC45KZhnmWQ+ii9DhFGIOJqRvn1aAV6K5dogr+kN26AAdBzsHf/qoa94AMZ
         N8x8TBE21XgvjZ4GzE3yPSecnxeM/QJt0UZELNjt/5HtiZbYXCY9bTCAEucIGbCpbVYd
         ukTeUniob0XAqX+PXTRjYsYdRMCXDZxDejUhhRYIBdoDaaX+X10h6cSw+/rZpllTIwxq
         3szg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850259; x=1764455059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+VQkksdHZruPlACBWK27dtPpnM3dj37TPMUXRxmVJ+A=;
        b=O7M/ASTVNLN8YwG5kP7nOTtbH2yZX3ohVMkEAoJYyf4yBN0ddmlSYbOGsp+Mumrrka
         O2ZctUAtM+VnfbI+CYQI13nIakpdPK3x85wU/B/n9qbWlK6BaQvzEQiEaZ78ecsOdQJN
         /cfmkcId2TG4qv+AcenJV8D+hKRPdZn8aGvn6AVYv6E25J/8UW39yp3AWTkoEcDQIOZg
         X39jJ6WrtxRlqhYHcNjSXpLp/jMhgvaYFOFPDME8QqMBvQsX+ovtuJolj/2KtHC9h4az
         Lf8gMeZiyQZJZ9D0ankTLBYos/9QoGq/qENI5pOsrb3owtFW6kNpz/m5hRme/jQIhsra
         6DPg==
X-Forwarded-Encrypted: i=1; AJvYcCVNJieXHKFaARazxeidq1e1UHi+B9YjGpaW98xbThdXCPOhRZuaE4/4GYA/PDQkjsj94uo6WboPkg==@kvack.org
X-Gm-Message-State: AOJu0Yxl719wiFDX3CblFA85KdH+UOcEC4So7Z4DGdHp4F0vaV3buQdJ
	tAWO+mfuoqC624kfQbqS4H1492ZCSZtmfh1QFpCmUIwzxGKvOmIdXtKOdWY2vsi7lSc=
X-Gm-Gg: ASbGncsYH/RCxa4ic+dTIdSIJ8JwFyLPJV/VWwDYWcHi7NiWhfJUMYwVVMkLwnWLw1l
	RRacvGz9Bag4NB6MFBLVMURuD2j7Y3n9CQlCzGTa4SY4b4tSeqa8X+f+6HMtsXtSP4xROAwW9XD
	C4bIuu2xgvrTM+tnSFDnFT0jJEeIR32dey1o/XlUUlnGZcN2ykAKcN7ypHjSfBsZYMqTxqqfDMe
	tJtm9hyqS2f987ZnQt0M+KcK0tuFjiZUdsf7vM21srW/x0hRMfde/t+O1haApjowNfml76genQn
	vdOmT1GIkx5ygzqLrjc8iuptF7jZMRs9nAb5oDT9Li7gx8FtDdoBZhn8o8vN3CGdtrQsubR4OAX
	u5mnQafJWcYxCho8Hl8AilOH1tCZCjk9538/taS7a79M3VEnq1Yx804a3BKzaOlXkhuVDc9Ue5O
	oHxAgYoA8RXQXIhjG27XPOg1GPJmt3HlcLV6bIFvJ4MbyHwJV/C3RzzKmwNapfxkNZh1PxgHMWG
	XZ0Z+c=
X-Google-Smtp-Source: AGHT+IFvV3+5IXCVVP1oSyL2wYtEL/hA9DOLsYTa2a++REZ5p3m7io8YuDgIHUbUDCoA/rChPi/5eg==
X-Received: by 2002:a05:690c:2781:b0:789:507d:6046 with SMTP id 00721157ae682-78a8b54d78dmr49374877b3.51.1763850258886;
        Sat, 22 Nov 2025 14:24:18 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:18 -0800 (PST)
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
Subject: [PATCH v7 11/22] mm: shmem: allow freezing inode mapping
Date: Sat, 22 Nov 2025 17:23:38 -0500
Message-ID: <20251122222351.1059049-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DDFB540002
X-Stat-Signature: 4a46hrd773pbym67hdcax14yj1rpmyne
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763850259-45279
X-HE-Meta: U2FsdGVkX18J/fiLCKWlRezDGlEiuy9BxWQUzSFgJgKG6w4yFDNNDFRsYlmqoBkcD/SFPUzNPnor6RnXbtlvBh+xQMShSCvoEiOYDlBoavp4GnniYJnjgvNvAU95KO0Vb3+b/t0pLqUSo7xtgpx4ap1R6cZDwZT4eFiJN0lVcZQZBcvmlnuCv3WLF34G2Ylye2B/FfeSt8TqDZesm9TP1GVyUsDM2mtjLIHJC/QW/+p401+n1NNoujpDM0I1wWoCzivFTH9sQVc7ajWke7uTVPCyeLMWJbCiN+3SstVRhDMG5VZP+/TO51Nbj07fO/4BCcC0m8i0LJErYIpGJuaKKX2alM/NGO6KbbZQ8eRM90X6SdPGKQbnCLN00LfG39qY0se8dd27zwFb29q2D4mN1l42rQ67nWKf39rdhKxfiXjlFv1yN5b1jvczmzooAG168vKE8bCeqAJGi1ATQWrvvNdKxXblxeSCLeEVsYVTaYvl/s2edTmO3OWUOX/80BU1ByukdViRai9Bu7vL2mNsz2pQV2hdZleTg1vWeuyAXEczZda+7UZlV2v/6J2GRN/tODK/n5JKP7WB+3PpBF1ICA8zhR4v1+G18GYBnSuQaiLxEf9bGshe294DF6Vb5AAA4zC56w62izEQPUqyzgCDI76Fwd2T/yLqfdu8KiWHZG8VGpjTu2ORJrwXjaYPWNxNGGr4mjO+i5g4v2MTudw4XGKZVZ8epUQRG/JOi7uDy+OmPQJahQpv7nx/aO31qxJBbzYzRoarQFg7b4frdaSYI4Ak817K8FX1Iwq/hR+CwuF3wM2NP4ev6XfOjbt5IOk9Cf/vzbHk9KH58VyDbsirO6g2U66UdOvsm2jeNHgkfh2G7gl/TJshh7QZNdQy7ecODA71Upe9/VJasOZ24JYX9Vm3wyZQLrZZtn6f51KLGtMTrnpXvXc8gdJ1uuNGXgXO9qJ4xenrKifp9p828YC
 4yQt6nDI
 C1pu42Fo2uN31oBcLztQIv9z+yeKGf+MP1M4ZBAZbbHEQz+EsJIh7Hdum+hCfMREyslNThgPzslcNIQWnTVIAJvXz7wuFWhZ0DubX7wTF0vNaPZ4J9iJNqz3VEduCywUbXi2j+myTayYdI1BHOmHCZiIbNEb8NzUE+TaDBUEY5E8ohxoEA89AoxmW8p1Ok0P3amsgYl9yJweMFB+urTdFDiNqPnoZ+Vvt4C03p8eev/bFSEsKkXlYuPEL7+REOLs8Ok6IO+YbaXCoo4Hy0jG8KL1JolE+JwnGd1vjLJzvWT7Zpx/yRcmmLBOnQIynjRDLU2TIywgHp0gNLAZNYI4cYXl2wSsACzaRO/H76GXLWaSAhqdxEKAjQvwQOx05Bb0tZch2ohY3zEdZqaNGvZZlOrVHXMqVx7CMtZRmjQxr+TtH5eXwVzquuduibg==
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
---
 include/linux/shmem_fs.h | 17 +++++++++++++++++
 mm/shmem.c               | 19 ++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

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
index 1d5036dec08a..cb74a5d202ac 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1292,9 +1292,13 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 		loff_t newsize = attr->ia_size;
 
 		/* protected by i_rwsem */
-		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
-		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
-			return -EPERM;
+		if (newsize != oldsize) {
+			if (info->flags & SHMEM_F_MAPPING_FROZEN)
+				return -EPERM;
+			if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
+			    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
+				return -EPERM;
+		}
 
 		if (newsize != oldsize) {
 			error = shmem_reacct_size(SHMEM_I(inode)->flags,
@@ -3289,6 +3293,10 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 			return -EPERM;
 	}
 
+	if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
+		     pos + len > inode->i_size))
+		return -EPERM;
+
 	ret = shmem_get_folio(inode, index, pos + len, &folio, SGP_WRITE);
 	if (ret)
 		return ret;
@@ -3662,6 +3670,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
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
2.52.0.rc2.455.g230fcf2819-goog


