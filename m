Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F9BECCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6535E8E001B; Fri,  7 Nov 2025 16:06:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD828E001A; Fri,  7 Nov 2025 16:06:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430178E001B; Fri,  7 Nov 2025 16:06:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8DA8E001A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF59912CE1B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:03 +0000 (UTC)
X-FDA: 84085043406.10.1803AED
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 22D8114000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bY6cY+nt;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7B04/0h/Qcfyqc4t6CaWgs850ouGgVZlycEHNrf/bt4=;
	b=xhu3/YinGe4dZNeujWnD+dBRLIYlSKQlibD/00/qfFQYQ3KWknEQfoOXPhPTJgNlaes/QS
	YZXxPKVJIQb2jjUDvaEBUOcPZl76URcvxgcpd3guoRybq0HlmOzRFlOGrsnDmfqtdq4GAW
	QoWXzXsn//4VXpier13+6PTTejYBKsI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549562; a=rsa-sha256;
	cv=none;
	b=yNCDy60lMTztATBjdaCjf+x05vCxkGvpgJe8PMNpdKbW6IbYkg7khOOg1rbrMOO1TJXkuB
	q/dFF/nhNSwOofBDjM5RHoWMPXYd6cs/Q0VQLRo5py2wCnDd1ClhaLfa9v8F81LjVWACf4
	xXaJXwgcNiY2EpPAz+smruK/OFabBP8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bY6cY+nt;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7866aca9ff4so14646127b3.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549561; x=1763154361; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7B04/0h/Qcfyqc4t6CaWgs850ouGgVZlycEHNrf/bt4=;
        b=bY6cY+ntQEs8DQaEeil8T5sSlSkWErKDuoFuG8tr0vKKmTtdCArVXHW01dLUkluSqg
         Pb5kMpE0A16mFjh06KNlJSrV7ssR9rUl4n6VVJXLhilmGQrFZ7NxZ6ecGeVmRU9HDUDj
         8A7Jzk5f//lPSUy70om3x1WTJNADvDtK6kvm0KgDOmN7Au21hyeNCZ9Ron+8kRm5Sqz6
         Cx0pIF64YZ7WHe8v1SLOLS108g3cj693NbvgoMhQrVUl98bBaw/zS5NiLJ4GcGp50CJO
         r15UNOsGhaepcIZBcOP94+1rGmUq+GF6Z250TO5ocxADzslwkSJJ738BZMcMQNz48hfe
         vEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549561; x=1763154361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7B04/0h/Qcfyqc4t6CaWgs850ouGgVZlycEHNrf/bt4=;
        b=Jeo88mO3CxSQv0v1RZT5tBY8eMFE/Mtrw/HoaneZ/6QooWswTTcxeX5eF3uPdZiobD
         f+jCw9KiUmH8PqaqJk98jLeBwOQ772VyKk04WDD5P9Ad0zPTOk44MCVlUgqrcvBVzsFo
         EiBxPvp5P/53xbXDHCs5ew3/QcNv6vjtQcSoUfuJymmQGle2BjggwEIOjFG2Y5jYOcXD
         wuIvGYlcIVM/sTvZLna4POudgyIIEIkviX1VbfkKNnKe9aTsjK1kv3u42ObJl7gS+1Lb
         pyaM5JRsP8gQjSh6icRIFnjHYAsTcUx0jc2eOuktMnMTnH3lQi9K7Jwuqft8SHjgtv4X
         MHog==
X-Forwarded-Encrypted: i=1; AJvYcCVjt7quyiryAlWUOV7SYric/GeEwBWFnB4gMiYQdzhSF109wil45bFlmNuOsoZwlDwgIBKs+fnunA==@kvack.org
X-Gm-Message-State: AOJu0Yy5h4em9ICD0jFlzfGuzFKms24N9+Nh8OLGAEShEVJHkSXOyf1J
	kCKS1h0kUWriH+PeuMZYH2GpVtzGqeaJruPc6hLm3Skiz2PrrrRNN6dsIbxu342VG/U=
X-Gm-Gg: ASbGncuocKexAC0nW8+UIStMPLF2RUPJ7ZV7X4ikdLgoyL2J8/mFQ7viHXoiY8S1zDR
	4UmmeyY9E8PH+O8PPWIYGuTZTNKfThWJBazv4a/q9fka7Dqw/IjlmDdn4mo3U+Sn5Pho3jEVQ8s
	nlifak7zRDM/LUb1gDZsE/ogG3609L1MRBH10ahypIUknESc38dngVAKP14qyuiu3ClfD6Bg+It
	rcvS+j0xEy4TXiwxDCL7yjGpCLjGpaJDjwPBishR6G1RQvuYwT9LzCceKrEZioDnRHdC1Fw3Ji1
	55Hj4tPbIy8VXeapiCS/WejVSMDkSEP8Cs27e9UXfNG6JnJN58TQTUy8dUfJFqrHRqQimRHt6jD
	1nqvoa8D77DthF/2KKFg1YEC3yKxtdEorjyXC7KdZtno/r+RiC7JgFSFFwc5eSmnSMxVhn8IFA7
	3C3BwI25ptyyXZEGfaLWnHfhAWXROwj1QGiC+fxTP4Ak2z/wgklrXs8a7qywkQcQLFik988d3DZ
	djYrjOGUpfg
X-Google-Smtp-Source: AGHT+IGF4+/4J86N/nzQZyRsPJ7pMtknxLR4bnE8JC68ZkTL3I3E4I5rinqYLEhJi2wbGwCzdCJ5TQ==
X-Received: by 2002:a05:690c:55c5:b0:784:8153:c604 with SMTP id 00721157ae682-787d53ba2bemr6446727b3.31.1762549561166;
        Fri, 07 Nov 2025 13:06:01 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:06:00 -0800 (PST)
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
Subject: [PATCH v5 15/22] mm: shmem: export some functions to internal.h
Date: Fri,  7 Nov 2025 16:03:13 -0500
Message-ID: <20251107210526.257742-16-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 22D8114000B
X-Stat-Signature: oj8eyf7ztibwagzyj8auitnoa79x5uyh
X-Rspam-User: 
X-HE-Tag: 1762549561-832146
X-HE-Meta: U2FsdGVkX1/XIEukVAPxaYpfNIrKORzUrwoVeagwESgXi/560l6mSxGnjWQGQRhGRrc9odPcCyKJ+T91TSH9jaXfvlX85eOUJ1jJ0yv7IYdahDT9V9jfZPEbjJ0ImNglO1Bzr3LOIPrn9KxWEHDrjwdUFysI8iTWN7LvStGeOrAT3uscOoKJghV+s9Bp7/7OOmBplmMzwO0UfZWbEl3izYja4sXgEwsr6Q5b+L0KRzpPkfWyzyCOP//Ivxtavy0XdE5+mvUjFwo5BcUYVxpj3PpoSqq2pPMBfhnZNlT7UbzJSfAj/2UkYdGhOG8cLtWhUqMiuQn7jNW6snrkvo3bbcivqb07fwTT9zKJ1iCa7PfnNDG57uaUWSHvwZiZIajGqTFkKWbW0LVa7uSidyZhpqeu1xnG9FFbyi6ZZ5D2vuW9JcC/WHsGxDj6K+kSXrCAuLa8p+BCYEbB2YTxLVmYoA1MVrgsTkAtuZDuK8CHjn20QomB39izvnGxCqhIHOB9MOp5wStf0o8hs53FBrnB7RI7HkSfA0nFT/D7jhij1t+5VsAJAK7RCaEgaDQRa1cLl6zZAOFTFvfteC6SLHUnO+Fanu1nX3NC+Gfh46W6OhvoNBVAqVjs5SdK7LsApPwEJ3zGXuqLRScDGy6LZ93NeIlSAZtrB9SIHGcowy64mKtMBEQbP7FvG0VsHhgJ6dzl4UgopgGkYpL9Nww2oFvWrv/xbTL7DxsXHyy2yHJwT1OI5PBoPzF3vVCOFqr+uuDOJhgZObzbQwF7Hu9ToDIPPmeape95jm92/aX3WaARHDUhsqUFhCOLwcssViipeDjg9CPSBrRUYyXwBviA31g0mMa878DPvQUTNgBAlRz9EiytEMwiTnakTfJgKcjftd2rF5iVZg/oTMq0eA78TEMrW7a4pFbjn2E8inZM3KGmJlVSVxik14BehsE31Z+2eCinFyijeUo3pDM4rFPWtF7
 WwvErx61
 QSErt04fauNLCaprXzKWEsuGbuHDgW6RPK2OFmSio4PiK/Liz7JembHVhHmYdzE2jRRiAoLeVRkhdVQqYzOMqTBZBcZJ6MAuRakhstmr5c4MqBaz9sZlQLnkwkF/xMMBbAmwM7UUScUU75mzktVRnivjOpSsG6hte5bysWGg85Yo/hZW6iuzPv9x7RbmBJq3lILfOx+/z+066dBACj4uvussN04voygSa/w0foNNECicQAm/nWxRaUUvSTmFI0cNKithz0ZD/R2cAFj71VsVIF9DKNOXK/mcBc8lMBSXWcYcfXzolpYp/HMHJkat8B7n4BSw1ahDugqRAuS6HLT8wxIaMSRiYnkTq7teZ+TxWCCSnqw3HKmN0n7FfLNcQmjOpQ3L3w7bgle7+oa7PVxSu8Pg5m2oEdlEKvfTo8DziBpWtscLZXMeCTeYnZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

shmem_inode_acct_blocks(), shmem_recalc_inode(), and
shmem_add_to_page_cache() are used by shmem_alloc_and_add_folio(). This
functionality will also be used in the future by Live Update
Orchestrator (LUO) to recreate memfd files after a live update.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/internal.h |  6 ++++++
 mm/shmem.c    | 10 +++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0af87f6c2889..3f957e86f43f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1585,6 +1585,12 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
 
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp);
+int shmem_inode_acct_blocks(struct inode *inode, long pages);
+bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
+
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
 			struct shrinker *shrinker, const char *fmt, va_list ap)
diff --git a/mm/shmem.c b/mm/shmem.c
index 2e3cb0424a1f..c3ed2dcd17f8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -219,7 +219,7 @@ static inline void shmem_unacct_blocks(unsigned long flags, long pages)
 		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
 }
 
-static int shmem_inode_acct_blocks(struct inode *inode, long pages)
+int shmem_inode_acct_blocks(struct inode *inode, long pages)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
@@ -435,7 +435,7 @@ static void shmem_free_inode(struct super_block *sb, size_t freed_ispace)
  *
  * Return: true if swapped was incremented from 0, for shmem_writeout().
  */
-static bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
+bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	bool first_swapped = false;
@@ -890,9 +890,9 @@ static void shmem_update_stats(struct folio *folio, int nr_pages)
 /*
  * Somewhat like filemap_add_folio, but error if expected item has gone.
  */
-static int shmem_add_to_page_cache(struct folio *folio,
-				   struct address_space *mapping,
-				   pgoff_t index, void *expected, gfp_t gfp)
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
 	unsigned long nr = folio_nr_pages(folio);
-- 
2.51.2.1041.gc1ab5b90ca-goog


