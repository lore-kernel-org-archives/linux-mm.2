Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E45ECD3B7E1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8966B0028; Sat,  6 Dec 2025 18:04:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568B76B0029; Sat,  6 Dec 2025 18:04:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F076B002A; Sat,  6 Dec 2025 18:04:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 358296B0028
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:04:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0245A5276E
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:04:07 +0000 (UTC)
X-FDA: 84190576176.30.86AC569
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 75B7720002
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:04:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PP/6uH1l";
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765062246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsouCjCTK+Xvffe+Utaw9VRxSR5nciNCZ2+1iVBaPZE=;
	b=8RbBzCsS2FF9Fc50cZW39ogSAXzYgYHOI/y389znISUHEKYmSVN8jWpE4f74uGDH3fSv9i
	3Iqf+jA9m9HnIkKNy1qcNLAJQXi4lGs5mFBjLBIUebd5pvQmnma7lutBzmMM/FkJjNXoMD
	udLO+nBKv8Qf8e10ZZzDA9v40m37g/k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765062246; a=rsa-sha256;
	cv=none;
	b=BktRFUgnU04RTvY1dOQfWDxqXaGjItI0JragJFx1GF0V80DH0SlZhdunVgcZpGewhpBLXm
	mNEq/8SVl9YIWYAqFVK/ql17DNMzK1RVDR/60F94hEVfnIE3CoN5KbQGz52uquQUutHang
	sVX6QvKMsyb4b69b5H/YWjvg1L+brUw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PP/6uH1l";
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF62660148;
	Sat,  6 Dec 2025 23:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85669C113D0;
	Sat,  6 Dec 2025 23:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765062245;
	bh=gXncaBYBOs5IUsTyWV7q0US4snXFBOIObGWREdQ9Sns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PP/6uH1lLGKx06Es/lMFIkxEUOdrjqMxQZboNQnpa8XyO/ODoN3HjDooRNgm86nTt
	 S86qplm9dvPcMC+CNcYHMszhOH8tHaNYzLhZi+vaCP58EJwfMCdX9ATQeohFf1BCva
	 oA74WnIF8xgRxjm0Rrop9ODQK0j50sSH/cJeOPb/jWI9GBMwhbc+3V5TyBWoU4Mjj5
	 WxIw3HAmoq1udOQhiDake+op+JCEroNQh2FKK6GPrB6DyGxAkFJUMLi5eBOUZFvFJD
	 n2LaVBSZ4L2nxbcD1wzso1+kTX7ohRFUbtN6dtPzjHubChlbaptgloKgC27OEmAOds
	 Acg2cBDX7hLLg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [RFC PATCH 09/10] mm: hugetlb: allow freezing the inode
Date: Sun,  7 Dec 2025 00:02:19 +0100
Message-ID: <20251206230222.853493-10-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251206230222.853493-1-pratyush@kernel.org>
References: <20251206230222.853493-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 75B7720002
X-Stat-Signature: xakmuuttyzxhdooow9temph93atnj63t
X-Rspam-User: 
X-HE-Tag: 1765062246-129376
X-HE-Meta: U2FsdGVkX1/kXNjotjO2lo5qEJa7MzAIg6m4uJspQ0Lch724dXnEJJP4DrFXXuIljruPkHol7cLOMqUcCGXBzuj3qxccAkKpLBeJDi+p2V1dX1OnnR4fzTQVlck6URfSIeCkzIaBO3wWgjAStWqzfPYf3gsXu0agExsO+XYJEqHWJzl8IOJyfdtRRKZKYEZQGYRCit624p8917pKMWxcsLUJnWLa3yjLeCKuOmUUBgylx40yauZZ9dDa1u4Q4rvDFu4tVwm89C3xbOLrbi0kOFizBZ0IgfBbI3AGI6G6yn8PlhnSkoyaL7Acy2BWZZ5QWb7oo3aaL+2nmlFZZi3Al2UnUbvr7B0AaUStLaERkNPZ9ji4SMenTrnAXXIUkjh/ivC2GkCzRaFZaLQGc5EYAW4MjRY5fSaV2/5tEBmqYBK5YgEZ1I7NjwjODiMBneOcxo+DSLCNt212MFMiixvtozNLClpgGGEEs4iNOcxIGZYi8C/3/WKfWCBRNeR3lPDu8TV0o//kzTFDVSbbG70tOfjNaIJgdHQgxV3EiP5cr2aMwMHaDyV5/BVzg87TvCpk+R+vRjDlgDtsSVySLGWcmhagitY5UCkgoDfNBToqtjbOdc7IxrahDN1TYz00w0D++gZvOF+BtUtJA2VPxL+gZNTuvgSK7vYNY+B4/vzm5tEk6OqvrIMpzMi1qQ+VuQUQF2PaMXcD1ZkvvRuCkOWw/w9Tea2f6k6x7S8rOuwO0HtygqJuGwRej+tWh1DdYXyGmJAeSfUB2Zn6dRGkInZEn6V8ZtsFUe5w7esQSMRTU5WzdpjLmJF+ij9r9A7K0MqAirYLYDWOHlgyCAVVYJWswDSq185QzR70igE62SE0KfgkNQWv9a2Y2NDNE6PIXKbVDRlDo3RxnoTXvsVbITJedj5I0AvQh96oFapFCT7KRzpRA7ZGil+oQwm68S0tWEnxz8QKLiq1hsHK5AqKF4f
 47Y0LuPA
 BB8QcAZzYDD1qJXu7dYFUu6Q0QTmKo9mac6+CfmBqgJyeT+xxmJmwmxHAFovO29ZQyZoXfBaGzTX0YgGclLKXjoW2G35rPGpwuo/r/77l4qED81OeSuyc/0Nc8Gw//kjAzPnQGCHmb7NSy67kSIrkJH5j7Mkml3zzpub64wT+MI6x4fGUlBx2fZdzoMTbbZ6Dy+VQfA0GsNJft03GsmycxywVNobHMe5nDdH21OgZEcOeV4hzN+iG55lb/hdM6o5ezWBomhegrL7jfKY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To prepare a hugetlb inode for live update, its index -> folio mappings
must be serialized. Once the mappings are serialized, they cannot change
since it would cause the serialized data to become inconsistent. This
can be done by pinning the folios to avoid migration, and by making sure
no folios can be added to or removed from the inode.

While mechanisms to pin folios already exist, the only way to stop folios
being added or removed are the grow and shrink file seals.  But file seals
come with their own semantics, one of which is that they can't be removed.
This doesn't work with liveupdate since it can be cancelled or error out,
which would need the seals to be removed and the file's normal
functionality to be restored.

Introduce a frozen flag that indicates this status. It is internal to
hugetlbfs and is not directly exposed to userspace. It functions similar
to F_SEAL_GROW | F_SEAL_SHRINK, but additionally disallows hole
punching, and can be removed.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 fs/hugetlbfs/inode.c    | 14 +++++++++++++-
 include/linux/hugetlb.h |  8 ++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index f42548ee9083..9af0372c7aea 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -673,6 +673,11 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	inode_lock(inode);
 
+	if (info->frozen) {
+		inode_unlock(inode);
+		return -EPERM;
+	}
+
 	/* protected by i_rwsem */
 	if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
 		inode_unlock(inode);
@@ -743,6 +748,11 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 
 	inode_lock(inode);
 
+	if (info->frozen) {
+		error = -EPERM;
+		goto out;
+	}
+
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
 	error = inode_newsize_ok(inode, offset + len);
 	if (error)
@@ -864,7 +874,8 @@ static int hugetlbfs_setattr(struct mnt_idmap *idmap,
 			return -EINVAL;
 		/* protected by i_rwsem */
 		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
-		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
+		    (newsize > oldsize && (info->seals & F_SEAL_GROW)) ||
+		    ((newsize != oldsize) && info->frozen))
 			return -EPERM;
 		hugetlb_vmtruncate(inode, newsize);
 	}
@@ -933,6 +944,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 		simple_inode_init_ts(inode);
 		inode->i_mapping->i_private_data = resv_map;
 		info->seals = F_SEAL_SEAL;
+		info->frozen = false;
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 8e63e46b8e1f..d70a3015c759 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -511,6 +511,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 struct hugetlbfs_inode_info {
 	struct inode vfs_inode;
 	unsigned int seals;
+	bool frozen;
 };
 
 static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
@@ -531,6 +532,13 @@ static inline struct hstate *hstate_inode(struct inode *i)
 {
 	return HUGETLBFS_SB(i->i_sb)->hstate;
 }
+
+/* Must be called with inode lock taken exclusive. */
+static inline void hugetlb_i_freeze(struct inode *inode, bool freeze)
+{
+	HUGETLBFS_I(inode)->frozen = freeze;
+}
+
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			false
-- 
2.43.0


