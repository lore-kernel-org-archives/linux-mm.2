Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44110FF8851
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15666B008C; Fri, 24 Apr 2026 17:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC436B0092; Fri, 24 Apr 2026 17:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902936B0093; Fri, 24 Apr 2026 17:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81EFE6B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:13:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24F08120132
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:38 +0000 (UTC)
X-FDA: 84694700916.03.AD014E8
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48B1C18000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IgBdiRO5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065216; a=rsa-sha256;
	cv=none;
	b=Zgi8EVvsd2i3eM50LcWkIVPYNd8Smd1FsDfzv1+4QvM1k6Mw5IGhUA296n2Sk+wLIFsM5E
	bTy+d5TSE7gkmp9n5dSomIe0WYOZDxi38uUa4BLVH9F0NCP2YgC4Qw/VW3fVF/uXt3Wad+
	Jw73KTea1f981vQPBEfyN1nFw3jrEMI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IgBdiRO5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTAGPteg+C41GDghxdfX+CinkzFS5bGpJnmRmtrlucU=;
	b=oiGMD9fxDLuQC04aeBvle2O3pBB99BUrHVSTSYyul4Ki4n6ZnkzRcQltBm4mBXWOacTDkZ
	Md04Sof4fVkyqTFe/PGgRtYwUok/K2orae2mHsAH5sjmIvWShbvGPccFMQNHf70dlUPH+i
	xjFAEGxRQ96bWHV29O+Vlga693LuXiM=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d7e23defbso4990809f8f.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777065215; x=1777670015; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xTAGPteg+C41GDghxdfX+CinkzFS5bGpJnmRmtrlucU=;
        b=IgBdiRO5z7mFBuFX0NvsCCUK+AxxpjLU5uVzbmPuMgICqeij3NfPjEPZ85JK08vQD+
         ws5EPa6KUVlBHCfik4TQoyneS/HFT3f3G3GNUDisHwR6uoUW8bzHPyphscjAUHCyyZVD
         OIXOTEYvKLyMMDztUr0lKBFRECftJwmvWc2v6pe/XFFGF8uJsyB5iFjvaOvUtE8eF0F2
         zvqiaOf4/ju6OGdlB1K8bmuayF6Va23xwyZeM7os0pb68qzLmTveis8yryoSeMTmXHGK
         wzmJQLdNQ3QR0AgUQbqA9uEATmH1wamqaN7QUa4z8awrxRyhYog7H23PNOnSI4Xx0Cn1
         6+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777065215; x=1777670015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xTAGPteg+C41GDghxdfX+CinkzFS5bGpJnmRmtrlucU=;
        b=hZxPcxe7sZ/Pgl8rA0j1nB7OLk1y9CYkXwIbjhc8crXp7rCWREl8iQFn0cGeNsZ3zv
         XeT9ugA/EbYUJ18wNmPqYyfmUWTGtUM/Z39mM+4Z4lCFARu6Cbfd9J988f+b0T2tZqNL
         YEbqv8tS7CVCXOGMzsQIytgh7wtAFpKXCkWTKSMhqEIFJPC9uoZiX/vWzciKJ8+zNQ2G
         e1yunuYZ+uEk4kfAyi6ZKwEnikxVLJOOj8k5PXu+ttnnCIBB0RVdMAx+ZU/uwu/Q+9xE
         A8LVQ8bpBX4R23lrr8PCIyD84DPq7yAAzQ/x+mEUFZkXTZEZYb0SvO+yWC1NS14GZOqA
         mDJw==
X-Gm-Message-State: AOJu0YwYBt9xO61ZHarb04b/Hkx7iXdCwVRIzeRulgafKPTGDObmv7zO
	3jr0dO30+MrmKpMjYv+H5LklAwoHPM0bmvv8pUY3PvI3CoI5WSVTcfGT
X-Gm-Gg: AeBDietRgxa6bLipHPBceD8kc33THnD2sWzC9ovcIK23/nH1OK58nAECI0yN6K7O3iB
	n8Oz9ND/+8v35uBgGsTnK7u8oSfwfQUWKKliesh2AtnlF8sSHfxuLGRD2X+keOZwHGYNSK9HDGY
	BCfcU4wXUTdXETzOULz9KrG3M0R/7rhuMMKBdJYcU3fKQpVrNLb2wFA/hKBnI7MTWTEK/eAAv1R
	9BJ1bZeaxMJTN1yPvF0MjY5YztJH6mjiY/KB7ee46k2Nkx54ol3A3xtqOEk7HZ+HrrZ7jQnYbvb
	HGu6EZOA27c3+pGatdegdaOMtKtSXuQrZdqlk1eBiZBZr+mJJPaA/5Mpv8Ew5yRMdf8sh2ZkDpC
	eha1gsdjDL7Mx9XL9t2KoMTk4jKYK/VXZ9dv2PzXNwZQk3kIhLOQladCKf1kJ+SGRNynxJ09Y/h
	YZVucMcD+MUYU6nLWDaf9HMaA1zBi7Iw==
X-Received: by 2002:a05:6000:2082:b0:441:1c18:f779 with SMTP id ffacd0b85a97d-4411c18f7c5mr32364551f8f.37.1777065214727;
        Fri, 24 Apr 2026 14:13:34 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm63845677f8f.3.2026.04.24.14.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:13:34 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	avagin@gmail.com,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH v1 2/9] mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
Date: Sat, 25 Apr 2026 00:12:36 +0300
Message-ID: <20260424211315.1072123-3-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 49p4crbkot9uic9uupws1qxb3doggos9
X-Rspam-User: 
X-Rspamd-Queue-Id: 48B1C18000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1777065216-449089
X-HE-Meta: U2FsdGVkX19KiwyqBUlNkK+TPlWhzqWXW/gaRsM+eUlYXDi5NHh292SSBETlFnIG0qhszDBrSHrpx9EmB74R0GzKvDcG3PrO07vja5DDIfqn8YdXHmWofp+gmhu93RDJjU9c8qdMW0izlPC/8ndgiCAsx3mXirAyzXvz+vZLB8U5M1jE638zQMv9+npWWfjBuSUaXn9p54rPLfdyWggvsRgmOa49jIpir8FdwlyE1xHbfxo64lqnKhNoDOH91tQBkNKAwrKX/ZEwgGGJyMUA+vhxLKa5G5co4rUqkGMZFcUzXzn0esqRzOcR90miraWcFUXAe/hRm2Oiu1D5MW2Yg0evqIEpRqEfhMgVsPPQWa2LtG3R/Wt4oZDwDvXUcSav/qFFfAcZ6zTI+yc2pgdy+CARHGjrxXKZhaOLhTlJpnUcpGNCcQiWPj3i4Ja3S+CYsKE7+IZLdUydA7oxQfk2pPy/qWcNmHxAClWrbgLECeE7PVF/9C0cHN5KWh5DhLK9eHpzoOfOKHbCkbnGOsNgSzIOhOSIt7pvITu8euSGxXG4Vb3Ypc/jNEGKbjXm5+Z71U6IC38sVbRvDvyNLeeTcefoYuPTyRe6GKAX/6wot87hiRS+nWt7GK5hXT1w8Io+wY0RT7kCkpQnvN2Q9fTqpfnQ5RFygpPN5YF9ZnCGHLds2EpsN1Er+bA7QMI1FeI+GPL+9IvHVj6HvN725ZBKdTv/aDGv9rF/l+n9MEj+/qiVceVdHdL7MbIE0jF9mwplHDt3Nu6gr964GxXnzKG3ppmv9tSbqIkK0dgIe5PHSiF6+ulllnlUHGH4pYgFSMqZ0/qvCxHKBn18HYB6Xag/qdB8UL9YF4bhy64DMk0hk5aoZS2j+zxdtkeG45EWt8hxIkcgQxgiVbMYRiXjlIOQvtSC/uRI+TQPmSeqG6mASyY3al5/4E6luTnZv5BwsnkLZlBPo6bpSVbSG+hHs3b
 NjSwmihf
 TfBm8xGVHuI8q9BKmhJ/s43aHXuKqkur/jlf+dCkatQHygFSs7HVIX+N4JCs3nWggrSPBG/HWx6xcX6ZskJR2hWE11UVszqW8UIfs1ZQWzoccETkX9bj6Fgjukci5AyswOZb7pZ1jvwH9DOLNxGwR/emdSZPfhHGMZAbd3I3bqk0/vgKKb0EGEp3ShvYisSgEpr9s960QJaPpvK9npkGgy5PnnerpPdOfGQL3DnVyDGuKPsF8aAXL2j8i4QgFG2uaLiI193InarqVKnP2hwa3jiK32ZNj1nh/ktoZpHLErl2d3/OOYlFppwfig5wP/iK7d+LVwSGWNceEEQfNkX+mk2hWDUuTEkwzhno2h8iwu4W7NLqnG8wFF7+rSYYXNf+I75TH0vg2R5vTOBesEBl5Oe+ykAVxkpMuqZZv0YeBPLhezou7brYJzsNzw3KdHTsnb4lFrxdcn8TCS/4ukcY9bqNO5O458AMFfDUoyFvi9a+PgacymLrmimQO9N98goF4hU6iHeHjHiiqsTKdK6J3tdlBQcjYmcndak2zstqqE2EFRQUnDDo5QVeS+ejP4Xd5TvmDikcL1S6lhqzgvfMpYeaLeM5EioUhddA8fQAQ3rnuvb7x3JS1MjXQ3Fu686dRrvxfLsCfc6dEpd/JEeW+3GXuhThn764PXr6eatFoitIICXT5ZXnebIn4qm5iqnoZfNg0gWvjIfBoDZZrHiYkx8IobA3trUTekpILp965lPncQqkAK16xa+1r8Jq9vvvTujspl28G5fCAX8Rl8Zm+Cy3uJfqZcDq42kM5YOeGgpwv3glL0f3j7LM+iz5FVEjaT3y0oUfDlc2JwgAG4TOb1dggEdyVT3C4EFe5gqeXHSvAua3lAIcNSm9imfS4kQWpi2d9ZQQPdgwIpRP0jxCRXCZBBMLBzgx/dx/b+1Ns/fgfJC7iaJzkYa7icECTp/zwsM74jz+9impSLn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

This patch adds the ability to atomically set VMA flags with only the mmap
read/VMA read lock held.

As this could be hugely problematic for VMA flags in general given that
all other accesses are non-atomic and serialised by the mmap/VMA locks, we
implement this with a strict allow-list - that is, only designated flags
are allowed to do this.

We make VM_MAYBE_GUARD one of these flags.

Link: https://lkml.kernel.org/r/97e57abed09f2663077ed7a36fb8206e243171a9.1763460113.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 568822502383acd57d7cc1c72ee43932c45a9524)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
---
 include/linux/mm.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f1787efaedc5..a96c99066351 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -501,6 +501,9 @@ extern unsigned int kobjsize(const void *objp);
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+/* These flags can be updated atomically via VMA/mmap read lock. */
+#define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
+
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
 # define VM_ARCH_CLEAR	VM_NONE
@@ -843,6 +846,47 @@ static inline void vm_flags_mod(struct vm_area_struct *vma,
 	__vm_flags_mod(vma, set, clear);
 }
 
+static inline bool __vma_flag_atomic_valid(struct vm_area_struct *vma,
+				       int bit)
+{
+	const vm_flags_t mask = BIT(bit);
+
+	/* Only specific flags are permitted */
+	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
+		return false;
+
+	return true;
+}
+
+/*
+ * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
+ * valid flags are allowed to do this.
+ */
+static inline void vma_flag_set_atomic(struct vm_area_struct *vma, int bit)
+{
+	/* mmap read lock/VMA read lock must be held. */
+	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
+		vma_assert_locked(vma);
+
+	if (__vma_flag_atomic_valid(vma, bit))
+		set_bit(bit, &ACCESS_PRIVATE(vma, __vm_flags));
+}
+
+/*
+ * Test for VMA flag atomically. Requires no locks. Only specific valid flags
+ * are allowed to do this.
+ *
+ * This is necessarily racey, so callers must ensure that serialisation is
+ * achieved through some other means, or that races are permissible.
+ */
+static inline bool vma_flag_test_atomic(struct vm_area_struct *vma, int bit)
+{
+	if (__vma_flag_atomic_valid(vma, bit))
+		return test_bit(bit, &vma->vm_flags);
+
+	return false;
+}
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;
-- 
2.53.0


