Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FAC5C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8076B012F; Wed, 23 Jul 2025 10:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172AD6B0130; Wed, 23 Jul 2025 10:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D6D6B0131; Wed, 23 Jul 2025 10:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE2E46B012F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0F12112EA7
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:50 +0000 (UTC)
X-FDA: 83695808700.03.0A48695
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id DEC4F20008
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=hNOoxYof;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282068; a=rsa-sha256;
	cv=none;
	b=RBhOspseS76CAb2tkUn3GjV5+Tmpq7tfDb5MHr6QuNxhRNvuzZy9DbzUmXW4FKpGY1/J+G
	EQe6rAnOsR/4pvHWRRUYK1sBMBki8QUiIyKL0Ai1FOi8VBbSmQcguo9dfjWrko/2zx4y4D
	m7cznzVdzZ7eeIS1qBwmrrac9PcIPPk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=hNOoxYof;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=po25YEPvXRrTuFLL1nDXhv73SfufZ4T7e/xtjD+elU8=;
	b=V6gc7Qgc4THiGS8CUUQsDmtZE0JcD2nOs+N9kIx3LtfJSiFmvEGMvp7n1yJvsCd5Cna2wS
	DM1dFcgHaDHRcQSe94tJnjZIpigQJ6zb5ZqLI/1dCinazOTVw20i+WenKxbTGJ2OAHpFyp
	mDUGUNnm1hCIwyBQQQfR0uwFSjZtsGQ=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-70e3e0415a7so269107b3.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282068; x=1753886868; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=po25YEPvXRrTuFLL1nDXhv73SfufZ4T7e/xtjD+elU8=;
        b=hNOoxYof1C3efcJgsoIvYwVG4OapVeONxvCs/aqnd4OlAEWuY4Wx7V3yZOLdLJXl4G
         gcPNXGir5X5/OWZXBnH4Gzf0Xcu6MpROkqlw702mSpGKuEJl4ikENoll1WX3uU29I7JY
         B3G4KpDaEq+I+ZNqtNwD/vzJ3PPoj3+8+Ua6/jaAcnnhjlqfB/FV8V2HMeYLuqpR74WH
         kUtQCs0n75yN594kNXKiLqWs57pgFXYHjEuhK5wEZMWrFH/VovwOiuMBLTldglPzjBUU
         M+HKq2zTIlNz/nIZZ8sGpaa7uY2VxYsCK1Q+HPX6ILLFhLNT3+IBMPtbcC2wGjOpPLP8
         HqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282068; x=1753886868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=po25YEPvXRrTuFLL1nDXhv73SfufZ4T7e/xtjD+elU8=;
        b=uWYhdGe5kSKVfL0GMBeW6gLcGskATGahgclO05EVIxbSJeJaqjY3h5BAa4wz4N56E7
         Tt+aSFnGXkPJFMhOX3mnKSuTSjccOKTXhTAEBZ6A50lB7pIcUtzKX+PLmus9bOYP7KgT
         Qjn2toEsgo6ddrau14AvYzhKyZo7SD3KV/pM1rGlg7eb52C5bg7mY5ShKkdEkJOzOHAt
         i5H0Ty4i9WBEOgGNcZpCQ6XKXzgUYwlKBeUtnTriWL9sbaIxPmofKoLedGaAUY73QFaY
         IWCYauNPbggBUDnjokPbwvqebGJ2TK1IWLSW46kHPkyHtQqKNBkXMu3jH7/Vg/wW7a2x
         F6uA==
X-Forwarded-Encrypted: i=1; AJvYcCXY0Gvdcx2/bocEwmr2VYf1jtDBr+s/e9VBbRRBxq1qhUZMXzghP0N5lMV2qA3v/Vs4bbTlYz4fFA==@kvack.org
X-Gm-Message-State: AOJu0YyTIo0UHjioFIY+QVZ7k8Zj1jiOu4iHe5UdLIBZPAWXatywtIFI
	0lifLGnOMIPFryPDy7D1yqziUQvyPamE09nkXPEJZjqvCXG7GUVPGyljfTTpSI5B4LQ=
X-Gm-Gg: ASbGnctdi0e0CdoF3Vr1p4B7DB/J2/bRVo2nWh93gvVLGZncknaONOfX7Mr65qGefh7
	Ig6pbB/nbRVkTbAjGrneT5ZaxZ4EXvZ6xSQjJShNx+siFqSpeHrb8WRS6/bLtyjkilr/xHB64JE
	IFS2TX0vRtKBcSUwrDQv7mhXVZgXYQB5e+2LWUt7Cg9U0DGuqEJKdfeKVMYOoX+FD9NydLNvN4W
	X1gFseqLcuXXpqPOHADq12YIgZ0ltkUuD9ImKEfUlPoiOdH1JBmY8jq2NhA6zbnOzF1PkzBGbTp
	0ucJuwyOhZJDoW5oT0ATUvYSkISKTn7a6dJnCgft7117wrbBcU2LCI1O2lH0YlKugX+czR5icxy
	qnMZQAFBAZ2PiRAbhkH4WbB/HeaTGgFE/0R0LMMDFhMHuKb8Y/ZRv/eYBn1MY16hYo+qnuAvINC
	dt8Qt2QYRARGcwug==
X-Google-Smtp-Source: AGHT+IHUEvrhwYQb+PkqEHsQ9NVaBJx/HXsqV9Ci/9SKu6SQ4+1qmUQGxK2puIL8Ml0NTVfy05s2Ig==
X-Received: by 2002:a05:690c:620c:b0:713:fe84:6f96 with SMTP id 00721157ae682-719a0b8f1fbmr86322747b3.14.1753282067864;
        Wed, 23 Jul 2025 07:47:47 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:46 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
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
	zhangguopeng@kylinos.cn,
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
	witu@nvidia.com
Subject: [PATCH v2 26/32] mm: shmem: allow freezing inode mapping
Date: Wed, 23 Jul 2025 14:46:39 +0000
Message-ID: <20250723144649.1696299-27-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DEC4F20008
X-Stat-Signature: 57j5am41x7okmoisyngz8wn5yq9t9w3m
X-Rspam-User: 
X-HE-Tag: 1753282068-985962
X-HE-Meta: U2FsdGVkX1/13BYeMEbEubtXTg7TE0Whx3yzy5xKoi+jwGly9C8cT/zuQrYRWVIzratSVg/k9Z/JutovPirVfC19YnZDGRYzZcjg+YK9OeJCbgny7RORKfpcm7Gw/8EriW+U59P6d50RlvONgez8TnEvdFQn17HsTJbptunGNh3wFFQdzueOroqVEGK8AEHVjbgZeMPBhtM0uq7fsCRYFYuBrKudfn3i1lNjfuASJHHoMH1LiMY0YTdU5G2yAU9EfILZHstRM+ZZMDuKfqO1XdxYvWu6zKep7ddfZKBhnCuYxum+9LB3a2lfjGtKXX6XcPwRkVUWSEfHL0bGBPZjgOEv4alRBDcQvscQLX+XoLEtri8DH+y7iYm3kKrO/bIq6DZAO29mTqitNgUMZMUN8+VcRtWMNTaOcK6bZWIJvyqjebcXUU1OEIJKqCuVtrZNfOyskme2F9sCzEl6W7fZMZ1RRfSs2QpGwaVzI4em1oogBQIsKeIIHNBUc9eLeLOC8i1OcwEZ2JFk4gUVTG6dKF0HdeDBEb0DxLo7Jagx94JkoZ9dE5vTYVCUmYJ3ZFdnsrWzPJ7A58sGl+aLLk8Y64tg0DvPxswkzWf6WboBEra5v5c2JKxCoc/vSL1HdGidngcE4PViOsBB6zkraVut2bks0i5/iz5mOEecpvqNHnLUhYKXWxuFqnF/eLsQvHIwBHQBOBCIUx55jfXDgTJQ6ml2htLgh83epFjbDk4YGfA+3oerlg0dsgd50foGoWhcMkwVa/nLivDendVdJ6N5mAswC7Pdnpp+hXS4ryJcGku56YP0bK4j/GDHEXqISJ43Qe+/sSaXVxe9ttPVPeQYG5dJlfjDJgUnmdeRBkBvFVha5AgVwioGIX8bqmzGF50/a54NnY43zQuB5awC10YRyctIrJqKgeFp2xHEtoc5y7GN7ZdBDs0nzwAKgEs4hA4NYIhloKAzq0hjY4eHlp9
 AhiV8QFs
 Po7qLdTO41+KwB2V4OPuywdbJNlETU0qBdMINBp8XzUZVkC+zBH6RxghXu3odJdk84sn+5a+re8Swq9Qv8kZuxtZPpgaMQPlTBbPAblGLk4gkM2WxtAvKvj0pRVSi5Uax4KqZmSGYP8O1MgRpsApNxq3QXo8oOpG/hbZ61lC5uREUnlsDwx9tn2PzMrLco2YMOOvrbmCT5ZpEdb4/rvLPdV+5KWstZ+muvmW1vORoL/fAQnjt/9ew15F8azdkVBgWxG+6ZpxANg0IGQQZ2H2zAcLMZRYdJ2xwhinahU6zpxSjd7hEvbtT3+/2OSenZIPQzckdhw1wtj3BmDDeazs670yHAqOIZDqaBmfzOVUSkONzNoM/uNJYMqwgGpfwhf/8iJf4ybsX9i0VmF/YMtaICst7BD6idhFBQWGI+5s53L/aRChTuhDop/C4BnGIhgDSnxWovmU2jJLTz1o/8R6HGIG+ySrXId7pth9S7LS0ieP6ue4dvfF9u8SzsVNX4zYLQ9aOX+XXfj6XcwuFCXcI23VbxEdsRQalFfjJ2/xSlKAvwjy7mYJhREQEtmjGeSBLUDyC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

To prepare a shmem inode for live update via the Live Update
Orchestrator (LUO), its index -> folio mappings must be serialized. Once
the mappings are serialized, they cannot change since it would cause the
serialized data to become inconsistent. This can be done by pinning the
folios to avoid migration, and by making sure no folios can be added to
or removed from the inode.

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
Signed-off-by: Pasha Tatashin <pahsa.tatashin@soleen.com>
---
 include/linux/shmem_fs.h | 17 +++++++++++++++++
 mm/shmem.c               | 12 +++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 578a5f3d1935..1dd2aad0986b 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -22,6 +22,14 @@
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
@@ -183,6 +191,15 @@ static inline bool shmem_file(struct file *file)
 	return shmem_mapping(file->f_mapping);
 }
 
+/* Must be called with inode lock taken exclusive. */
+static inline void shmem_i_mapping_freeze(struct inode *inode, bool freeze)
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
index 6eded368d17a..d1e74f59cdba 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1297,7 +1297,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 		loff_t newsize = attr->ia_size;
 
 		/* protected by i_rwsem */
-		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
+		if ((info->flags & SHMEM_F_MAPPING_FROZEN) ||
+		    (newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
 
@@ -3291,6 +3292,10 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
 			return -EPERM;
 	}
 
+	if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
+		     pos + len > inode->i_size))
+		return -EPERM;
+
 	ret = shmem_get_folio(inode, index, pos + len, &folio, SGP_WRITE);
 	if (ret)
 		return ret;
@@ -3664,6 +3669,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
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
2.50.0.727.gbf7dc18ff4-goog


