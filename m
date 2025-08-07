Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB31C87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302DF6B00B8; Wed,  6 Aug 2025 21:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3516B00B9; Wed,  6 Aug 2025 21:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AF66B00BA; Wed,  6 Aug 2025 21:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0412D6B00B8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0B961367B0
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:29 +0000 (UTC)
X-FDA: 83748269178.21.D15BCB1
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id E869A40003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dfHsPlBX;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQny4bvpzR8mZbBN1/IVSyxQ9U+JDItGyGw2v+12Jn8=;
	b=iHarYsacx5TIyDk8el/ATg3InBqyCgds5UpEO2ZLGuhk9HonyoNCVey5kQbuRpuSJYUl7u
	Gdcg3h1m6fmoYSCrHbEsNsIWIzJGpRLs3zjEyCiIuQBdiL6NlqfIF80P4OxopHzSNF7lpc
	CwH5dG238m8W/pwF/vlRuhy6v+40xR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531128; a=rsa-sha256;
	cv=none;
	b=Cs6hz4A39upr2fSehqlGhHZwCHFXQTiBYGoy+D0eUXMQ3WrckEl2h2Ep9byRKo+UMjKDNl
	w8jC3dv+02ozu4xsF/FMR4Fl7Gzjw6exFcZFvxmr3QOoXLZ1jWwYQ17o3spcjs2KF/6QWT
	4y7r0CSo1p3D6A7D9wp5N24bT5JXaMc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dfHsPlBX;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b075cd3cdbso8612271cf.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531127; x=1755135927; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQny4bvpzR8mZbBN1/IVSyxQ9U+JDItGyGw2v+12Jn8=;
        b=dfHsPlBXb1FRyFRxxPr+kwofmyrWPe8NWKgf7q7pY5qduEvriz4bCCwG+Vsc4X8W5s
         MegfEK6qtwcAdcY90FrrL5SjMQiJ2cV+vFKNYDiWo3Z4HCIG34Ybl7vry/L12jSb5cR3
         oj6977yXbqPOnbwnRr1f0pyk2di9AKybGybRbKrdCvAuWlxOnY+m7OfsufzDzxDJatEq
         LIPEvgFLP2GLPwq7SZR7yTWfc2wBqbSCo17OaVwXIzZuw13Lbg3J7G7XzuV8mCOn5+Sd
         K6da5P07OaymddHvjkUBRyTHxZ09VlbjI48N52qBRC8PQOFZtS6EO5G418mrJiLWYVnq
         OGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531127; x=1755135927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jQny4bvpzR8mZbBN1/IVSyxQ9U+JDItGyGw2v+12Jn8=;
        b=PTGFl7gokD9xh1+Ath+1jAQvUGdjb+N0s2BNDsF+zf2aEMPogq9aZa1q58G7GAJE1C
         3nJql55L715/mnit9x6bbQh61R1MdD1y1NKrYSoZGH4MVRqZ7zbS8nnn0q/92tJunPpq
         1TD9gGQT5rdakDth9AdeF27fBPjllwYsZDICnJp1dRg7In940SGtLeHfY9oT2i7DhtEg
         29kEMPEg+rdk0dRHoPBOmIktAmCC2rBCLZigQp0stJGhqZ3XUftEZjBmkK89Lltw2VUJ
         PsURorBMAORcy7XtW/XmwE8ssjqn4QpcA+4Ed3FSc7HsDXK3UFjVWrnVKfr2h/SC2UgH
         r8zw==
X-Forwarded-Encrypted: i=1; AJvYcCXTgdFFlBa/Wqmt4IiI28jeyJEl83Vs5vqqtrhr2BRXLmZZydPu8pXNERlm8zHGV7sgnuspquIEfw==@kvack.org
X-Gm-Message-State: AOJu0YzuRCPjV+kCdxsyGwCiKXlIFH4xWbFpO6Fb5+Uqd4GJrBAxLFYN
	sk11b752pw29LvL5jYYpzUjeLmWfPEaundiMMlPZOe6KptGuAtQ3UGHsQVKuZ0Qgl0Y=
X-Gm-Gg: ASbGncuRkddNMApZURuxv7QolqIznb1OoZVNrf9ghYeGRFOHCjvSGZ72whXhDoF3KC9
	WPqgT7ycZ1h8ZbzyTXFRTrx+r9g3ZJs3qjn7257jwAhWeFIc09IXUhIq8HmEUwWLaKi5IonFhPC
	CCLJ+A8yAvy5CG+KfHmYEa+of2lHS9X+PYkW06XOznMAwBPmhqJlrsRSQQEm6/tLsgD5NNH1sy0
	pWCo0/KG92cXoq+3AkOKUkRy3Z8iSSoO2L/pgJ6trb3vEA+EO0PtoTTdLmUzgI5DeRYqdQZ+Iyl
	g1yFIm7yyv0WvkxEsDSlqbcVyRM2d+t4Iix+x/w67R4AFJXem93kZuSnum+2bJzt0r00TfOn957
	+oOkUbgDCffrrmS1FAtis0Gi//C67m/9odrgenLcDzPwlABDBuOt+h0S9qdcpIUCooV6nrMwFK7
	oaG3L9jvI34WXl
X-Google-Smtp-Source: AGHT+IFqMT0HUt9lre9uw9F3rpS7vpTxQLIi22l4S1gL4FMPIdcVTcCnIgm3Am+TvXdeRU0xrWJBwQ==
X-Received: by 2002:ad4:5761:0:b0:707:5694:89e4 with SMTP id 6a1803df08f44-709796c75b1mr72234786d6.47.1754531126973;
        Wed, 06 Aug 2025 18:45:26 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:26 -0700 (PDT)
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
Subject: [PATCH v3 27/30] mm: shmem: allow freezing inode mapping
Date: Thu,  7 Aug 2025 01:44:33 +0000
Message-ID: <20250807014442.3829950-28-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eoyekfztd6ifymoqt68uj7gfj8585is9
X-Rspamd-Queue-Id: E869A40003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754531127-300223
X-HE-Meta: U2FsdGVkX18rvYJmdY7RrkIO+KRhmv94XcHggEDbfvQnBTGDNwC65LOFylLLikBHPNo9I2uzAqsOuQElPvmanJ9rUvVJiRryKnUsS3RZqz+KBgFwA7SkBJA7f1TBIlOM50QFCFl4gB1nE2EwOwT9F7opL1WevGxsIQztmgwrkddTAFlaNFhODNfUrQ9SYqYSGZLGvqusklSa0AP9JY0HVn+yyfi8kt+J/GTsOI0bAX2Pzi8s/jZu00GY8nmzVMGhPhCLfHvxJRa+200PHWvWl6fOUVCfgM+s2fq2NOTQTo76byY5Sea1zEOglhTek+uKfXbcWBLzOAi2UX69cmvvLNT6GgYX8Y3vZPskktJuJU3+0ijnxoMF1/Ou5MqB7zfjj0x1K0WD5blUhLq/Lpg22vfBQASUD4PnF8BBQc6Z/vN/U3vm9+fV9Q/ZSDvv89422KsZuFlvP2FC1wASI2nFesPEN5HJIyJFgyTaVoyJdgg5M8QpYlYwv0zI26qOxbYnYoXs5vL118qgvA+TQ5kSULGnMQGB5l8Ccsmgx6jvk5pmK+kmQuXfsQO51ZOYyXfqFgfWZzF3fO/oMR95ySVRmCtWvqRBCV856rW0kz8HRf1CWmoXZUkaWmLKECDn8yIWNM3m7/N91e/Jv6OE/xTENpOgxWb1/prFN1cuFhayCqc/FAMD6Z4rBtSkSpcAHg2hUhiECDzmcmrSMQzqf+fRnOEuKDv9Egz4LYtXPaJhitQ0i11+N1ztrA6sv2RtR98s8QHP9MfIAMFTNBPHXzT8fjyesL7LZ71cJTQQ72Dh+33Q46PQrJjESwP475ca8Q2EscMjQLZIXSiq1OtTaA99On05plO+6vMW3H1JwwzT5dmSEmZc5b5f2Wk7u4sxhm5DFK/GLUHhXtooe2UF7OlXnOfUh29FPIdtveK7wNYod2XS5jBugbjI4ITA+3ewwg3xkoSe3ViagE1izhVIYpp
 9mLPD7hd
 WVIxjn1ccKZflt+MIkgo3v7q5J1k4WOgjlvTEQJDQGslN8IOB2V5kW7fwy3r5YMYetzdpfNOEKvRxk7NJutmqtgGtPPUPbivc8DgnockVClUBaeYBSLfbawreOgHPtjqqU9CZwcQ80tm1SNdf+6toBX+YIpB92bmPA1I7NAuwAyLkeCShyAUblRplcObi+Y9q8rjk1eCU814LraNiZ4B0piAAYacArR2YqdcsymoCP4eaYw2terz7Yv8fV1FDj2s2FHzHpZwA7JICHsyCX91zSOmN8shEI0wrIC+fixyyZrnBRJp6jFzZ1arvacZTK3UG31/1NMRvkc6kvU9ELwcsgWFD6uw9CcqrKT0Z8g6fk1ZGamcYwAjhnEOyEp8vlqbLLiUmnjs7pmeg+ntqDfphZa6z7/GoAbRwPgSolPM22xOvFQKYy0XX81Jsiw==
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
index 923f0da5f6c4..f68fc14f7664 100644
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
index 8e6b3f003da5..ef57e2649a41 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1329,7 +1329,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 		loff_t newsize = attr->ia_size;
 
 		/* protected by i_rwsem */
-		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
+		if ((info->flags & SHMEM_F_MAPPING_FROZEN) ||
+		    (newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
 
@@ -3352,6 +3353,10 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 			return -EPERM;
 	}
 
+	if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
+		     pos + len > inode->i_size))
+		return -EPERM;
+
 	ret = shmem_get_folio(inode, index, pos + len, &folio, SGP_WRITE);
 	if (ret)
 		return ret;
@@ -3725,6 +3730,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
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
2.50.1.565.gc32cd1483b-goog


