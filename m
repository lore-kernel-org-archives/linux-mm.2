Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA1DC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D00B6B00D8; Mon, 20 Jul 2026 15:36:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459D66B00DA; Mon, 20 Jul 2026 15:36:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA086B00DB; Mon, 20 Jul 2026 15:36:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F067E6B00D8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:36:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7010BA086E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:13 +0000 (UTC)
X-FDA: 85010161026.14.7702AD1
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id B797010000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cHJy9cH6;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agF9dzqU876M91BxnILPGKGHMrmtsRIzpFbV5gzpkC4=;
	b=UYwLxnlGdIUsuEl/j35Kz2835Bmq3luEnzVQs7FE5GXeMYjqYTPCoELL/zww1RYWKAVvE2
	BJi9NASIWnVvbj7APrl15XcNZFhMSObbmEfJ5lHjpkcuT2uLIN/Nx9qXLdxAdqWQzJOgZG
	+OPBv3RPka22rLMqml0HVtDqs5d67Og=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576171;
	b=zbkKX37T9w7K6U928Uh4IQw2WNR2IFAMpsiE4693IM+utXGxBYKVj3+xkEYc6LFBIpDL9X
	D1aSKXmQbsmPE5+CPQ0mLRp5uDdY7rquXC8PUW0dxUzhhIdUB/kcVPAHU469qujk/gItp6
	YgWQlAPXQEmmSLd3VHjtqGPPeRfeypc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cHJy9cH6;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92c7a0a701aso819478785a.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576171; x=1785180971; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=agF9dzqU876M91BxnILPGKGHMrmtsRIzpFbV5gzpkC4=;
        b=cHJy9cH6PZHbkPPmLHrs7UjMlC0xFdak1ueDtbJnACpFgBBmt7z8J0nk1SrCX/WIlb
         OOWyu8oeXfGV8aXFZOxwrlCKXHGj36KeEA6qICmiieXEB3gQz5Nt7HB6rI1jErC6Nq6M
         S2iQZGNBtUc35ITjbJ9MZ9oSmce+l82FlKI4cwxmU/Ly8KrF6fwufgCt43nSrXKYikW2
         fcJKFd88F38+AHNGUibDceqY2Lb/UMpKdzZnbqEaUCIU/ZBm7fWUDMz2BdXCxSmQ4hmv
         RjOFsFyforNX1D97qrg1lmbY68Ej/fsqklDLo9HEwbVKzUUhiLbJPKjbMR4uEWVL2Dxf
         ZCDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576171; x=1785180971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=agF9dzqU876M91BxnILPGKGHMrmtsRIzpFbV5gzpkC4=;
        b=cJCK2KtlK0kB3Na+jqOWvBVbvyXhuRdCHXot8baOMeXxnfUwak2RtjCUzP1NwCA7uP
         FiqCoBVwQ7Sos6yXayFlGWdhkn+DPmgwMAw+4pvZgh7l4818UYuIhEXVssltrMqcs/BV
         j/dwy8Fm2CLvQmpEXFd4xgjXjkWl+8uiHPQPGGczRW8cYm373UNgZLzAfEjcjQi9vpF1
         tkOE0pC0ZTzb0S/4NbVRjK3fXrwDkSdkvEGH4b9YtbWBYHUayy3nn0a5pgxomopeS0i0
         2reeuh8/PRa64htQSUuqGWTsx7sktXYyhOa4NBZ91AaFF6ka55PaE1hKSp0mmMc8Aavr
         OfsA==
X-Gm-Message-State: AOJu0YwFoaMu4ckGRKCxhCUproix2chy7rtxpj3/JRQ+WAQJazGDTJ1y
	BgZpLy2NoeRD1P49U0muX1fTW+nIaHdpQ8z6SgMzUDGfTPKxzLjTbyJ12rEaQQOhjM0ywWAnJDY
	QgZYP
X-Gm-Gg: AfdE7cnIEjzQ9suyfboYbX3+wtNjtx5V6hIcAVg0LqKaG4+QRWk9+cVZtBPW0BH/Fdh
	BIah4PJL4PIiy46nQr57plzK7qwX3TatKWxoHpmqbrvJM7pRklL1U5vYuwu0C+pUFcxrdBAxTId
	yBNieozTb9XUgs5CHLOXQuRGC7fhZYEhEQKrPaaLp6v7DggV0ASSU1E6xsec6iSfF+8gL9zM1tg
	ibxrhTlRqONXNGkGyzO8/RcjyLABLhW5Xbp8Mc1UU6nKH4MfoVWrSAdwAf76j94dvzlYOIxkjRZ
	aSVhQnsszPBXCcKJr6z/j7peA5QzmdnmgyKTVhxOLBtRDzYORpHeRANNOTst3yELHbkm7pATtD4
	Wx3CMV+VWT8OxyTC+Uecw2hNV9sbBbKSIH+T8mNXPgX61XbNwsJx9lU2zCpdmAAmZbBmDDfLjZ3
	Co9ZoN2Kq4kdixhYHtR9JjGouTE8M+sAd9dnwxW9/49dwBdKsbXWAsFWU8rJecQyXIKxDByx9Vw
	A==
X-Received: by 2002:a05:620a:4082:b0:92e:59b0:df08 with SMTP id af79cd13be357-930b3ec7086mr1655803085a.3.1784576170762;
        Mon, 20 Jul 2026 12:36:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:36:10 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 35/36] KVM: guest_memfd: bind backing memory to a NUMA node at creation
Date: Mon, 20 Jul 2026 15:34:29 -0400
Message-ID: <20260720193431.3841992-36-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B797010000D
X-Stat-Signature: ygd34rpjpb6nxdndxodefsrbdqr4xb48
X-HE-Tag: 1784576171-270841
X-HE-Meta: U2FsdGVkX18wkbm1o3jFFZB16WBwUl8z/69EAdENy4eSNwIfNmwnwTMErChSCHYcFyH5wNGE7cpeUK+qpLhW2ccexUy+VoBrQLuw1xzV36U0mlffnSouPj3q8/wqLcJA8XskN3zwpT8TbNBYv87xnyorgboDkHtjKIoNcTVi2psgiuvWhmjcyKgOGu9qVkV+adnRhgtFu/CS+Dh5XRDx1Yj1r2umLWLLHacadUMySEf0iLNndwCUkkg22eTUt99JXudvQS7q+vxw/gLSZywmQjLT+u7T5LOGEzg/EX2pqmKyW62zw5aYiaEa2EtHsuFgbNX8N6hWsk3bOqUT0UdsVsR9eBTL51MSgZpW1ZrV0vDWRtrQUjvm0TxIbtmCVBeAJvxxtXe/UcN811ejH/FqlekSMyo0WaI5YGvu+AwhbX4Kpg0WuyudcKgBaXS4rZxWa445NC9xgW2oDltnoePtLKRpCGC1XNL8a3gOU3PHbLxbMezetCheOsKGrvl/kPihAUqibhc6DqjPhpNMoJ+MwvF/0C+ho6bKCAQ9CWLng+16g9B75jgEsjvYxoThIzkRVzFDDN2NLz3iOIUyeEZ0RimLB4Q14tn0CIX1IGuiLBWqNYt8wumxBErFwmJgqY8Aa+BSDYXcJySi4pABHw/VfFgG09KkxrmEdhA795700mPfHzDyrbQ7CVKyYo3EGQN+EQrvXuta8/Z9APBHp+Btd76cfLN4k/lKlunw4b4qwUJPkiRL3E7TuMki4FYhgvQnU0cQ+DkbIXysYf7VXDKFlgIltypWv5qwBBWCMt1ZDyDuzhYmamqVRvktyiwxJq31ra/GdwAIj3wP/8I3sJ9VMKMlTh1ywWMw/I14G9K7nalMsijtH7hAXDzXTSh8W4sMNcYYiLlRC0GjoZRLtAq/6jN0uKW1UCmhXhLWiEkRWEEsfFk9DpKAIdGAuRqOs0plMOss9dhWBAqIm9diLG2
 otUuo1Le
 vD5x43DZTDTaZr1A+ooQHbzh0H9/jRpZ+XbVBTPBcLchcbZhC4NzPgHhkMMoRDVHssTswqH+BaPwtjzS6Ytrnn1Okt5ZZEw50omUMQiSUO3HsUpR7jINfHGLsnBVPr+WRzXaB98SS3Gfqva3uc80GKPiyt4mBpCYvA26PjHCJoDa7DHVGmBhpmgEXPXF3FxvQnYfnAR6Ul+EscCqhzcEio9OKGQDGYtFaO95ZjqjhmV+Z06Z4poQHsEZB81yiVxqwGQneoRjrKuNUSBSh34bQuoF0R65goXHJSpyy1PGiy8zCpG1qdalTCeOdvQrR9gekledE8ItSOo9AXBNPa+R7rQpr4TaQjAfc/MbfXVipnvfIN/5Zx1uVCWRNfzXQJIbbrkKH/IQafSuJ/2H6aFHvdhh27hHeWYZ9gcfkFmjI9naDYyYoKoObhDdjWvgzoZHQ+/UK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd presently allocates its page-cache folios through a
per-inode shared mempolicy (kvm_gmem_get_folio()).

Today that policy can only be set after the fact, via mbind() on
a host mmap of the fd. This requires the fd to be mmap-able and
cannot reach folios that are only ever guest-faulted (no host VMA).

Neither holds for a non-mappable (confidential) guest_memfd.

Add GUEST_MEMFD_FLAG_BIND_NODE.

When set, KVM builds an MPOL_BIND policy for the requested node and
installs it over the whole inode's shared policy, so every folio
is allocated on the requested node with no userspace mbind().

The flag is advertised through KVM_CAP_GUEST_MEMFD_FLAGS only when
CONFIG_NUMA is enabled.

Suggested-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-8
---
 include/linux/kvm_host.h |  3 +++
 include/uapi/linux/kvm.h |  5 ++++-
 virt/kvm/guest_memfd.c   | 39 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab8cfaec82d31..f6448a73d464c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -739,6 +739,9 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
 		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
 
+	if (IS_ENABLED(CONFIG_NUMA))
+		flags |= GUEST_MEMFD_FLAG_BIND_NODE;
+
 	return flags;
 }
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8e..a8ff150e2cbb7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1654,11 +1654,14 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_BIND_NODE	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	__u32 node;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f0e5da4908660..de320df08e0ff 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -456,6 +456,26 @@ static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
 	 */
 	return mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
 }
+
+static int kvm_gmem_bind_node(struct inode *inode, int node)
+{
+	struct mempolicy *pol;
+	int err;
+
+	pol = mpol_bind_node(node);
+	if (IS_ERR(pol))
+		return PTR_ERR(pol);
+
+	err = mpol_set_shared_policy_range(&GMEM_I(inode)->policy, 0,
+					  MAX_LFS_FILESIZE >> PAGE_SHIFT, pol);
+	mpol_put(pol);
+	return err;
+}
+#else
+static int kvm_gmem_bind_node(struct inode *inode, int node)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_NUMA */
 
 static const struct vm_operations_struct kvm_gmem_vm_ops = {
@@ -557,7 +577,7 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return true;
 }
 
-static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
+static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int node)
 {
 	static const char *name = "[kvm-gmem]";
 	struct gmem_file *f;
@@ -598,6 +618,12 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 
 	GMEM_I(inode)->flags = flags;
 
+	if (flags & GUEST_MEMFD_FLAG_BIND_NODE) {
+		err = kvm_gmem_bind_node(inode, node);
+		if (err)
+			goto err_inode;
+	}
+
 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
@@ -630,6 +656,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 {
 	loff_t size = args->size;
 	u64 flags = args->flags;
+	int node = NUMA_NO_NODE;
 
 	if (flags & ~kvm_gmem_get_supported_flags(kvm))
 		return -EINVAL;
@@ -637,7 +664,15 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	if (size <= 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
-	return __kvm_gmem_create(kvm, size, flags);
+	if (flags & GUEST_MEMFD_FLAG_BIND_NODE) {
+		if (args->pad || args->node >= MAX_NUMNODES)
+			return -EINVAL;
+		node = args->node;
+	} else if (args->node || args->pad) {
+		return -EINVAL;
+	}
+
+	return __kvm_gmem_create(kvm, size, flags, node);
 }
 
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-- 
2.53.0-Meta


