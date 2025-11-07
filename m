Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4782BCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8019B8E000D; Fri,  7 Nov 2025 16:06:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B308E001A; Fri,  7 Nov 2025 16:06:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6027D8E000D; Fri,  7 Nov 2025 16:06:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2D28E000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CC0613B6CB
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:02 +0000 (UTC)
X-FDA: 84085043364.12.7CF865F
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3AD2614000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="EW6FLm/O";
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBi03kAb5JgjRparbbJCSt/bY+/4eC+JKPe6vY7ZjAQ=;
	b=XcVsC0WPtM+9LIeNnSxHj35nAImueKZrVRLM1Au+H5uqg4y+N8dz0Be+TraU16gKmFyH8s
	Q4MQUg+Kjsx2sMOYj4CK2niCOftYrWKgsE2IEDfFPiK6UM8fslf60tGpuCTqUlfhn+hoMQ
	EKvdMdqXHJonOIvLg295QTeDhlYXbvs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="EW6FLm/O";
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549560; a=rsa-sha256;
	cv=none;
	b=qhO4O2TdrvQohpOYK3LEyo5ExCbPA1HJTUIEe0U3arKuYXyWBUALk6QGnE+doHK8szqsKq
	apRzqqFYLiqHa4hVBkulcIwPsLrEY3f416gq37yVsrgXoO4TToyqL6TDvnfg8ysAYdhCtH
	o1WigQ/Q477lZp8lOIM19WIJSJ4wzQM=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-787be077127so14126077b3.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549559; x=1763154359; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pBi03kAb5JgjRparbbJCSt/bY+/4eC+JKPe6vY7ZjAQ=;
        b=EW6FLm/O+KytBEHYnqFkN1g2LwAQi5Azq79tnrZvm4b/DoU4MzR20ONcIEbqI17VnN
         Q6IXSpCt7suE0WW7aX15Jl88bptdef5UNWaHYHEih9GrkAmVCJnF+qURZwFwWDWeWcUr
         kdCYMs1/xJOsQttt3Goda82uIhzM8jt8xLXL/Dd9uC7AVtYpoL5SWVMsR2+Mlwnq7Bcs
         ih4D2fx9A2TafpHaVw7ncQpnVtgNibmTIcs1mUvuttdyrvnXPwVCdAA+3qNaokRrCklQ
         8FAXwE3PmAcCBlotVUuzm4T2HCc45Y8YBCUFgfuj5nDTdAlLo64zLaMf4bZctKBG+lGV
         z2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549559; x=1763154359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pBi03kAb5JgjRparbbJCSt/bY+/4eC+JKPe6vY7ZjAQ=;
        b=qgsDoeTXlY4sSMiClqhu7cokl6P/rfIavz1gdla24TKbf0LMsCI3e8PH5kiK44Yg0r
         +pSqav1oWnV9xd1BEeE5EMC7FO3MTY/VNi8iE5txEw4KYJ9nemfAxxqy7HCl5aqxNvvC
         9d75DgNqhhKrOD0qHVf79eL9f4y5sZDuKSxe0nkodI5ZXeUp4JzYg4IAb4Gx2/NUynUm
         n4y2ao/AUn2hjTJxFB9hVUUcY02lm1/ofysSF+4PK6zruV2UDpFoeyPoopOwVvy+PwG1
         dRNoLYUCtYR1w38W21WhtpNu+S0MGAX2lafBUERsJ7RTDVzTd/C98efDVpINLp311nRA
         SqgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWk0xNEXGZoBgaFuPoL54ueb+x6s6YiltXTYsxo5yzMOaR7OXnqTYPKqnJVUXZ16sWCHcPpST+t9w==@kvack.org
X-Gm-Message-State: AOJu0YzVC45rwGQ3SjQLycsmzPHImRahRu4mWQu0qu0+EEkvQymqx5Xs
	uf2nfW2H52L35eIk2BbiMDDSeWWOtNPvr4JfHg1sPScvkT0/eGWR7wJyYLOXfzm/S3o=
X-Gm-Gg: ASbGncsvYP57lFmVxZOeVY+j2m1mTTpbN9ozHcvkhfFkUVQxtMsfYNo0SzsjIwv0le2
	a7jpIOZiILKoo4CVRoLxPApO+22KZmec2Zj7w/Pf442O0Jw2E/agHGirDMFy4RQ5IOgvBZN0f5T
	VJVOCMhFsfYqIAU37BOWfqWKWzA+kd0vi1zKOq1sgQz3e6DI1bhrQaWnutlHAad17JIDAeQozCL
	Zun94YA483sigbyQ7etCSTfICeSQTXBcKDgPsC5T7Eh/rp4O/Wrs5Fq9ZHKmAtNXYp5mSOKqIB9
	5DzGxsK9QFWfovAvCSVrmH0sX4aOpxiJilFl7SqKMo+XPAJ6moaWLCW57TrZMM0APoGAB7ObPLu
	eXXQZy9pXqXWH62zq2GIpMCQMNT3WMadnsJS9iKUrxuYwZ+DC/1LWHJNFbALgLQnj6o8YDtAT1x
	5rxUz6PfsRl7P5yT1cDgIQ0jJ58/4gz1RahXBHqI8dzK9rnfT162DAxgEq7wvqr3GYdY8KylVvB
	g==
X-Google-Smtp-Source: AGHT+IF+XOrK+gByf7DQ1+IWSR7ui8MkgfcgK6h+y28DPkokKVkVXPGBOJn/sPaYBxN5KAaR0pxqSw==
X-Received: by 2002:a05:690c:760a:b0:787:cde8:b3d5 with SMTP id 00721157ae682-787d543da03mr6084207b3.52.1762549559282;
        Fri, 07 Nov 2025 13:05:59 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:58 -0800 (PST)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v5 14/22] mm: shmem: allow freezing inode mapping
Date: Fri,  7 Nov 2025 16:03:12 -0500
Message-ID: <20251107210526.257742-15-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3AD2614000B
X-Stat-Signature: jumntswadhgtknmg59potfkjjq66idao
X-Rspam-User: 
X-HE-Tag: 1762549560-397155
X-HE-Meta: U2FsdGVkX1/0vwSLK2azxKPEzQgb2lLlpIpNJXh7ZpkSu7r5Upcysxxen37KT5qtD77XM9d8TVTjHSyjCgl4eOXFYex2Y9Bt9WBCuv9weYU3XsZPHg2YaOGVcogP5szmCzO81WNw0S+H6mPZeTpnL1lpuH14NxocdLE32ZWEQNIMHYQrjxlCOtiMrT5Ii/AUauw8lsR14HNb6cvpoOmEMYjhwbOva3HpilQnRsQx2N0+NqjhOe5hgD1G83WWpswPYqpVakmDVSSl1ZwifaXL1l3sxyG1vO5WM8qMaPN2euS4E2Ce/4BkvJIaysK32fP9vdN9uE8SJmp5iWE1FJ87d9w/aGmh9zSzPox4l32Mf0jzeiJCj5NcHF2wp4GLV4v/haRjSgc+d9avinciEvU3ZJfWWoqtX4znHvzAKVyN9TLoE5DJzrjUivYAGVgUv55yx9TlL9vWdMUT+O5NH8eo8mZjBkD+5MEEKjPKCFIenQ3Tldb0nr3ZxuR7Iq5u6GyNdAzKh+aQ3zwB2D4OcM8nATiLAbuPICFcNURgxp3imhkStImAXOWdK6qzHEqkwHa1MiQ/V7U122Suas1Lw7/W9Jxqlpqf8sbmEjsW76KG/emU54JHrMwvF7SO1uescSUuE89kB8497MHbrlDbqnyg/QCv+fEJu3x4dMfoOq/MX3GP7dnswqjbkbfsMIdXZfP9azpaOJh6w1tkCMUxvSkuhb5VPE6/4U0XcB5RLDZbBcKqjDP9c+DRvT2t2IVAQ6u63vuWnwdMypAB5GAx4GWzfk1YjJDpmxNb9Jiy+eeh7GtbzjZXWrvq9LZoOYQS7w2eQ+zHFxoL0/O2gLtTcTelDV3SuQH97jfNqKlqz20okUZdtQWcxcV573FXm4TY8TbW0e4K/2o+kzPfeDaW34oD8wrsMCN0AqRAInl9Ce/WsNOM9QtWlZADZy6ijjtS3ExvEzbgN93qnzvdN4I18N+
 ytxg2NI6
 YyUfqIL4wZYiTmrumH0F3WmwHNB1NtPNxIiXVetq1Yw3FAuEFD2lg0McvNVx3fs+3Ju9kq0hoZ7k9JP+ee558myVjCp3uy1g0UDV/3SI9oRyaEHd2xsXztrkao8PNJJMiFM1uysOLxs2xqqT5VyXdBswzyogM1OI87k6wpBUK8Fd4YA1TJuNRVyAsdPAwJRnXm9GtVMQdYhia54C3u+jte1e4DY5rwh/jOuG5eQqSu+2kd2mt86mzgkBGmmLMPYt/lyxfTw2yfGrWGK/QYfSgDJBH7fOdaxVc96i2QDjDzcCZT++u6HlufhLrYtr/V0+MyWwA2bOQkmiHnJrmmEezI/uiAskgH7ri/Jm2NBHct8kgegMvujQYHSvzIJuiHlvFquSK8tVAXSLXxU8=
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
index 710b1dd681bf..08f497673b06 100644
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
@@ -187,6 +195,15 @@ static inline bool shmem_file(struct file *file)
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
index 19be8c575647..2e3cb0424a1f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1321,7 +1321,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 		loff_t newsize = attr->ia_size;
 
 		/* protected by i_rwsem */
-		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
+		if ((info->flags & SHMEM_F_MAPPING_FROZEN) ||
+		    (newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
 
@@ -3319,6 +3320,10 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 			return -EPERM;
 	}
 
+	if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
+		     pos + len > inode->i_size))
+		return -EPERM;
+
 	ret = shmem_get_folio(inode, index, pos + len, &folio, SGP_WRITE);
 	if (ret)
 		return ret;
@@ -3692,6 +3697,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
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
2.51.2.1041.gc1ab5b90ca-goog


