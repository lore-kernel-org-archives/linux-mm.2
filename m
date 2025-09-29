Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8D0CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A5F8E001E; Sun, 28 Sep 2025 21:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2528E0006; Sun, 28 Sep 2025 21:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5868E001E; Sun, 28 Sep 2025 21:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D079A8E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B881140208
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:47 +0000 (UTC)
X-FDA: 83940493014.07.43EC8F9
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 97C08120008
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WRjzCpIT;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5jod2izHbVl6GoMuI25PsEFlFJNITXcz8AeEB8I3yk=;
	b=7BW07Aewh0MwfoimZ+T75AP0Ioi9PhFCDq54dBWbSjK2rPeEcqXWsjdOFNq//El11/5h9R
	6xcT5L8iRVATWNVxMQxcB0aRbBufE0haj15pbqbdevWfU7szofQBOlE/GBTZdc1h69DoZI
	i4m22jMT84Eo9D28/2z0Py7s5vZy/zA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107885; a=rsa-sha256;
	cv=none;
	b=vRLU5q6ZHNm8BQ/uSkqW094cJ4vUVwZ9gGTTxwIOnz2i5JR+KVUTLPC06K2A8ruy1+Idbp
	PhAMw4HlrZIRaLOKQLl4C0H7++Mf+tCjyz4NQyZq2E4I3c5NAfp3ksx+m2c2Xj5EiyttXL
	AA80BwQK/iTLgKCB4nXw/k1JbMvnOJo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WRjzCpIT;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-86278558cdeso281518385a.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107885; x=1759712685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a5jod2izHbVl6GoMuI25PsEFlFJNITXcz8AeEB8I3yk=;
        b=WRjzCpITJ46yrV1tiFf/Vr7mFBvti+4HOWPJthHltLVBseXizun+gBnOfCOIU4euBI
         C8lXuPWQNOXWwzw9lEOo1imrJNZJk1ax4keHsq7jzRtAGAR6scVWLNy6WjB8gsX4oluC
         F0ggqZOlAcTlPHMnDtCKbN+SS3lZNSXPi6X4ufZ+pH3X8gFlNxn3ksMO+XiWmjNtz8Wv
         kPLcuLKMXbtr06xKUPNGIdLXlLRyA0kKzYhzgR3j/UwPDNF+41gHc2lvH7Rd9MfdOnRV
         g6LsySJq3wxikZUDlP+M7mEjrn1B99xF7JPjPXPolaaZ+Z/FmaSFHoj2tGJBSzKfnKkU
         IbBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107885; x=1759712685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a5jod2izHbVl6GoMuI25PsEFlFJNITXcz8AeEB8I3yk=;
        b=hq4teoUzmhdkAnftyz8LqxRKfiWRWvkdYj3xt+eSuucZf1v/yc1S7Y3sSERXMo8b9H
         6X0vwJ8Tg7rB/Q954IuLhzObUh+uNKOfEEfR0t340Z6BSzFXfw/p8/i7YN+j8G3sE6nU
         BOc+jsm3bfRpYH7jKKz8lvNnSAakLCuJIlwm/Tsu1dgLyZf1VH1B4oT9bO7oS1UBppxO
         OgxXh17IwULSClRGEAHrQMiePx+9pH1HKkRL2FXItKj362Od2rgzrniEZTu28Tl0WhPQ
         BqnnQMwgpDjyGErg9l60Q54V+eU/ymkl9kOhjAAuyAJ5JY8tZYyBNLxu7+9Mv38EU4Fz
         Ad7A==
X-Forwarded-Encrypted: i=1; AJvYcCXhj9plQw81TF78XykdUgCMwwddFmjviO3TrQIDR7tlJHF4yal35h9eeiFqXYC0bBmxQTIQZq8n1g==@kvack.org
X-Gm-Message-State: AOJu0Yx2vXruw35X7En6W0W6mkrJ1L9T2ATvJn8aviq3zMcF1TY4lL14
	oRhSQc14Zt4sSmq0gsHk/KIrXCniFjlyLJgLtnvEjO0q9S+5iUFaVQGU+rMmHxUtNCM=
X-Gm-Gg: ASbGncsx/NaXKh4QgugTm2JQQctHH6RvURy2x9Wr8NC4UweD54sZfgTgmMJvAVGADKH
	tAM2+AbueLNV7iBFIL/RoA0DfCXra/GNTw+rL7W6bHCOeydgQ6kJlV67+z+9P1J7ytWaCvfMj6u
	13/BHRYweiHibxzbpS7rbGi5dJ9IjYqm7FJAtGrK7MdTG5MOBfbxUAqkMj4jWjpt3YJH9YdQwrX
	ZB0Z07/i6W9KDzwIcArMviZy4ihegJZtFkQM/ZXdnXcuVzaEvGG4NychRBITDfWaRNTw9wtg9lp
	o2pIVGWvCes7QVz94lbAVs4BKGGgrah4k4GmhVejJ9mAjTeBe07/L5CNveyPxpEbvC9AR2YRL5v
	4/KhmqZusdg1aImuosYCnUMeGCTrTl7kHJcp52G43f4+CO6AlvSodULU8nfG0y8VuMhRGb99rhu
	3yjNBDug4=
X-Google-Smtp-Source: AGHT+IHcWK3+r2DO1mFFWuWSG7txN7iCjmZaeFDLs8Xu4WrTbTEg8yxHdhQIyiKJ1YNZRSeC44Oztw==
X-Received: by 2002:a05:620a:618b:b0:85c:809:3f10 with SMTP id af79cd13be357-85c080943d0mr1326429385a.26.1759107884637;
        Sun, 28 Sep 2025 18:04:44 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:44 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 22/30] mm: shmem: allow freezing inode mapping
Date: Mon, 29 Sep 2025 01:03:13 +0000
Message-ID: <20250929010321.3462457-23-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6czmtwxfwzg4gjkees78ceidzmy7a15o
X-Rspamd-Queue-Id: 97C08120008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759107885-755269
X-HE-Meta: U2FsdGVkX18FRC9ozqGx8vcOLjQuPkx9GUc13mOJO91xMnbfld6ZFbFhWR99rqtkWzAPz5cx0vHF5JNpCP0X1ftOYQg94OvUCSQ0EfZz2DwZ7Ky17iGKscz3SfjPKLibzN+WFzri1MeL7kReP4YigTX9Zb1+Q6RC686rkyKm2xYfdpiws65N/DQK9ITtHCw38ZJepug8hhwPkBrfUhHI4uHTNTFHRF2nVj9SGprKa82q6yVCiBwy6fey3ui4Ct3dSwUSa8jy816LcXpRkD58SSNdwGj4qqgkqfACif9OdxnY3hWIGXYpANLBKIpNbxaux4TqiG8EICBp+Sis9lrL9i6APEfFn/tazx0YsC5Xu5S8dzLvcEOC6HiaR5EunEbZGMoY2kHr48Vi1u8tkdWxmgpC7qRSF3PRUBZRp28r02E36Cg9HLcBoR82HE9ARoyT3VklECmAN7PbtcDRMRoyrVgsoHQTdzH4YXtgqh+y1uSsI9bsDJGfrbej83nMUVAjTYt4OECNtQMmHebmIDXgjcUW75ywevLUmVSbtjW5bm+WcOqaw6QriloWVSb0OpmAKg2W+8OAhRPEV4Z1YF06AMKkEoleCH/iY+0lC0didYSiPAPe7kiKfTZx1AxoRHZ6r73o3zMkkKJO+3jGIrfR6wN9oqHDVYwbIiWUh0Fe4rtLjVXlrTFVwdAqgAfZN9/HWnpx6AXe7n9gY6KnHbMZNr6RbJvasOXy8z17e3tTH/jQHBpNUESGIWRigf2kAT5StnyFq9Bi0CzOzU0X8reo9zrxSw607gJhPeVUXayCRtqcOm+NwMCqs5bEGG29QUvYAhpROR3km0Qbu1akJd9D7XaINTHE7v7FVfce0fm45+1nL0jL1nOa7lZGAIIXThOYhPUe/Ea8E/LzNWuw8aytqJm65QNKAmsQHCtFykkzAS31d/ty+UJOejB8phw8+9i9XS8msooHtooEfJj2V7X
 aWkUZ5vq
 04n7ZQOZ6XiYasinwiikchBXA++6RQWKid+Zaodms44ZMR1xaC4USYY52WIg3Tsy7PgyouwIzOztnsJ+qwv91OaWzQzIKXZ/tafsFVxVdZtpO/jz19KV3RfHSDA6pGCsJ7G28amr5PJ8+7CSBjHN3/aevSEN44/xq5co8PoWHdmCQuiBXI7xCH6xsBL4+gLgo2vsZh/qX6uu0QzqAimuUO5QMni8tZNnLjzqGufZYgXO5+owNiJ55qMRbBG2YVN1NPIg4XEWSCPvpPxV10tpwDgzXz65NMziTLi3SDoHO7z0hbWpxsWCiWgF+MfwaPb5ZS5VEE2TGM7BHVKR1vuuHqdCHWvkf7iTkZsUShv1E5h5/SEzenbf8WrHCWrCrHU9izKFkxyC7WsqNxqZBDjyhC5X6CA==
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
index ce3b912f62da..bd7d9afe5a27 100644
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
 
@@ -3287,6 +3288,10 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 			return -EPERM;
 	}
 
+	if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
+		     pos + len > inode->i_size))
+		return -EPERM;
+
 	ret = shmem_get_folio(inode, index, pos + len, &folio, SGP_WRITE);
 	if (ret)
 		return ret;
@@ -3660,6 +3665,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
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
2.51.0.536.g15c5d4f767-goog


