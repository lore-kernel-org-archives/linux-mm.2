Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C20ACEBF88
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2D28E0020; Sat, 15 Nov 2025 18:34:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3F08E0007; Sat, 15 Nov 2025 18:34:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F66B8E0020; Sat, 15 Nov 2025 18:34:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3FF98E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7BED1A0866
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:46 +0000 (UTC)
X-FDA: 84114448572.22.736E704
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id E453A4000D
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BOGAy91u;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjp2i+yn5YhJt0E9Cm6hXiIeiW1VzlvDXGR3nMqDfIY=;
	b=x3Vh0uNPLhRG76cQh2YVkxleT1QDGMj65rZD+2x8tPmp5o76OglXIjmgRuGABYPyIoa5MY
	0Bm5opo/R7Vl2UCNWdm+ueM8LZfKSRZ1U9w2Vz5dgF7Edllu12zfzQx18CfMLHvcI3wSwr
	bfpDXmPNeWlT6BtQT2hvacFuuZPRAlA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249684; a=rsa-sha256;
	cv=none;
	b=Wq9Wl3B0a7en9ptlD24gae05Gg4QU8wPgRLhlf8ZVugwKseqFdrW9lQJQD1Zv9cMOa8Pnk
	U4vfY+XLpZGxSQCMeYiEllhPDBGjEH4PeLY+rOoQkP1SRoYTsalzcMyd7Pzcj305/PQxig
	bdqG+QiV8BVDR2yjFy66E+yBOXpshY4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BOGAy91u;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-640f2c9cc72so2325794d50.3
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249684; x=1763854484; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rjp2i+yn5YhJt0E9Cm6hXiIeiW1VzlvDXGR3nMqDfIY=;
        b=BOGAy91uZmQXzW/5EvmqXCkKdp2GdakvOYTaFSS/lEYkOCyHfLk+2vdQHcSsJ4BtKr
         4NmWrqcYkQ83eCht8DSFPuq/QhcLFn01rZrTbch+oYHk+jfkJvNCcA9uewzSQHwyRxth
         6Y3xWrrMyvmS2VWdz/MGqd0c476cqBqFzcO/3V1Xyq9qImXt9LocYNdR+w4shNtQwnOp
         Lg2u0lKtrIqf7dGkwsExhUCNGiJhMEwHbLJm/tVZ8akU4/VFJeoc0BFGFcDQVeR73PX3
         kPOE86WjBoc8FExM4vve1niruCX4zT956D1S3fk0UQ0We78XlM5M1PTFa049+F0TechU
         cnZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249684; x=1763854484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rjp2i+yn5YhJt0E9Cm6hXiIeiW1VzlvDXGR3nMqDfIY=;
        b=EHHwA6XI5+5mw8ADxzV1Az45oLkhiTIi9u+XVmEeTTZVOz24OqPrk2WkG0Z7q/TzO1
         78qXetxhWxSQv8x2Yv6lRBDMsWAMQAUu+ibmt1gw4Ozdpx7YOf/4GgHKu83b6CImOklW
         wo9Blb48cq8bj5HPaJJcFzVBbQcPKOpjXp5PRW0otgAvQvsk5xqh+y9aOu7c7KmYOtm+
         DZwkqjqlvMYBShPuA9K0lxKQ+72Brd6F5aiv0JEIwU8zZtZEWyX2L18ZlpaghlrT2JI/
         5llI+PNKhaOMT6KRRGKdRYYeo0m/8tiDiOg2ekWJcIl7KLVip72+iX4ZpxBOm6NevdTD
         lC4w==
X-Forwarded-Encrypted: i=1; AJvYcCUCMWSHidJYIQHpVcRAOsIQuxfEOvek+X7xbeSNc8fF/Vze4UvjVvgLyI89iY56OvkRpb1q3Q16gA==@kvack.org
X-Gm-Message-State: AOJu0YyyUA4ig/DpdvL6TphkKoq0v7V+cKjdYqcSzC+e7PVi18TBHOgW
	cKOZUFkWWK3jsiOGdaq2daTlYSGXuV4tBv2M5LY8q48DJnw6UdrMlbkn9Ia31kS/L7c=
X-Gm-Gg: ASbGnct0fYYzjzhOrY9M4btGeddGCOvNFKN632H/EPkVK7FI+Xy6MfJiIpG0BizoO52
	VqVmGG3cgxsbHiHjo1vuTxuG5Ish4mbaQb8Vs6t+tOL1VR452i89zqcT47z29EC/pHrhIPAh+A/
	6PWR2OAHyBjKYWA5g2Y3NXdiLT1boCU1tFJB5b/No9xCXtaAu6Uez8tuSWeJkGBcYgQaYlNYeVF
	QfP7mDdDh+FZCsibjDQqmJMOQJ8UJbsp6J/ljvEc/3mfqdJYZyZXtO1G60OzmODGtThJ0LlgGW7
	1Qc6Oz4FgTc3GYgEiXbYkYmeVKR9mRwwrd9nuY3MSCb3dnzqRJkxXRW3qTnQOHdjc0/YrtlBhgd
	t4Ob9Y0WRz0g9Rb3dTkT2haLdYJB74m2jBWUqhYfe3URSZe7X3ClWQpXWwA8oxjDYiyqGe9G18f
	m6+066LqE5uk1yjsrp7LYBDgRic1Ncdmka+EKfL7cZaUqyC2KfUrVByGgU6FV7ukXeY2vkGbHq0
	pyhqIM=
X-Google-Smtp-Source: AGHT+IEqQqw8FjtFSAai2c9iP1dDJFDaXC1XcmhVkOppI5F0MwDFeehYvZcQ8y1up6QBmlqTCYD2LA==
X-Received: by 2002:a05:690c:7408:b0:787:d456:2e62 with SMTP id 00721157ae682-78929ed2da6mr132263187b3.33.1763249683921;
        Sat, 15 Nov 2025 15:34:43 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:43 -0800 (PST)
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
Subject: [PATCH v6 12/20] mm: shmem: allow freezing inode mapping
Date: Sat, 15 Nov 2025 18:33:58 -0500
Message-ID: <20251115233409.768044-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 44jomoxa8fgyshb7s41fmo8phxyuqrgo
X-Rspam-User: 
X-Rspamd-Queue-Id: E453A4000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1763249684-19201
X-HE-Meta: U2FsdGVkX1/Q8Pyjl1TxgySz30Bm7aup+DEZQ0YmC6cb3IaNsOrzxWSao5zACk1hOyBMGk4S9EFi+7K/GywJf1kQK06cKskEV/k4EUgPhR+mKqUfk7MisX+dOrWtMiBqnK/+J2aVcxLtvArp/uWQpJWsig3eajnqPXfdrBNZKxdKBm9SH6RhpVD6tXBEiEGGcdxS76+5cW585VOuMr31S2ghM1TOoUD/UHeRm4Xdl6P8VHQOEBVobYGUXI6/Ns9k+82Gp6V7Apl9jdAqOq1Mu6sDPFMfBp5IxXWjvCVLNiAZRYFHxvGAWHep8emiyRRuSkvRaICtf3sGpV+7GwIu+HKSEsvLXXwloXvdONUhtyL/MHk3GGQofXwUv+e6XQjNvhU+hix7fq3DYi3GdsPooNJfeDlCGFjsyvhVgDUvJX6S56xKuNWlhxoFK7MKzR4H9u+p/vspW2tnLrPuKz5A9qLjGpdmczdppOU2drIiHBTuEpddKxcvGVq/82Od2DOc/QxUKUiyqWs/y5oLC9MO4G2MC7459J0m5o7UW+LjVxDu83/9tQHXjtkhoP82dQWIjErr2QSw88J4Y4C0lyzTVSqrh56a97OPP/6fZ7tFsoy0j6o+5sgxH+lP4jB+kzKAfpeyvEYLlcxZCtI1UZu180Y5CJxaAjDl2/EWZVQl0+sOHQRCT6AdbcFs6KwCl8Gh48AHO/aypY1FPNffjuLlKnvUEDMepyBUQoqNuA8roJpPZMO6luBGlRpnNHryVJo1TZOvp9UkGOFFrm17zGTo6SNTfS+WjATdqVtwuyL7HT6TrODqAPoEU9waNVBTkkKug9FX/zHSfTAG8jfIfV+q5si1QFcnnIBnwyGl4vEvDg6w49rmvA6gZN1VYjU3Qn7gDgL6rV1Br/LHXYNleuZIrj+ts4Izdh5NhAwM5QXV8tq8uMnuktP0Y5OPIj1D3mLw4i5MGF+ospXSYwBI3MS
 jJsth0E4
 uMXYwEV+8scMTp6SIS9XhYniawNQuX7KT8bL6oMuacKM6cByWGxBVBMTp/xGN/WOseY6KqSdQwqoFyRNLKlickG7prL7DPK8qEAV/d8gV6X8Ar1HuKbU3Cle4qS9K6rKfDwj9SJ+zsqWc7atJq752kqlqPCNjwYNLqKnKs8dlPD04bZWt9xqpX8QcB54bQukD5rozConDFHVxiJ/M3jvVujHxZiFT4yAK0KjBIVboHV0W8w0eCO3o5J/lBVHh96CTbENttZ7AXPXRzeAgrO9Fq0swWRd8pp7/guyflgW51YAfAGyBC8THpJrKdAeeRNN4oycU3BsbjhI3mYoU3nE1lvaPvDcgRbwav8abuMC9TvxM93ROEcJaac5YUGJmL8/3uwdIj3w//vo58YY=
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
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/shmem_fs.h | 17 +++++++++++++++++
 mm/shmem.c               | 12 +++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 650874b400b5..a9f5db472a39 100644
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
index 1d5036dec08a..05c3db840257 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1292,7 +1292,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 		loff_t newsize = attr->ia_size;
 
 		/* protected by i_rwsem */
-		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
+		if ((info->flags & SHMEM_F_MAPPING_FROZEN) ||
+		    (newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
 
@@ -3289,6 +3290,10 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 			return -EPERM;
 	}
 
+	if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
+		     pos + len > inode->i_size))
+		return -EPERM;
+
 	ret = shmem_get_folio(inode, index, pos + len, &folio, SGP_WRITE);
 	if (ret)
 		return ret;
@@ -3662,6 +3667,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
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
2.52.0.rc1.455.g30608eb744-goog


