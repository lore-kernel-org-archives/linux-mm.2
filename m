Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3780CC98311
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E996B008C; Wed, 23 Sep 2026 18:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFB56B0093; Wed, 23 Sep 2026 18:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8976B0095; Wed, 23 Sep 2026 18:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9E696B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:44:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46B091C0E07
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:44:27 +0000 (UTC)
X-FDA: 85246507374.05.2031105
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id AF22020002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:44:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i6SWVv8J;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790203465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nQ+hBf6qVec8z+IXo2hdLde0/quAUf4P/g17WYv1iw=;
	b=Aq8WABniSey6bUC1rQipN9WryJNrr0t9UX5kq2nMbHlr6t93JxStFz63Qg/AcfCEdSXOCn
	kmz1h4Etk93EFUyB0tn9CMmdCNhGs0/skt96DGuKIBcwoK78KOw7DiU8dCeQMfwxmHEoYR
	a3TpjqmrP8nCXv3n6tkGwC7668Fctyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790203465;
	b=sIUOV96qLmfGUHRRglNMwGZJYliCy2lz1da1EiX0a1AB8dfkZRpukpY4BIAKy7RPus63AS
	PJG7mS1l3BmzKtXmIOhGSP4hA5YOv97mU+vEIt/lP+qz/vigi1eiAIqJ9cfRWd4s0PNOi2
	X1YYS8GDlg3nJ0vl4WyuEQQl2zZ7ddU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i6SWVv8J;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5695560216;
	Wed, 23 Sep 2026 22:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D4C1F000FF;
	Wed, 23 Sep 2026 22:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790203465;
	bh=5nQ+hBf6qVec8z+IXo2hdLde0/quAUf4P/g17WYv1iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6SWVv8JLcwPyjTj/ZDmJk2VviUSkDwPsJXxoiR+68IM0XkG2b/fK11NvvSzU1pUr
	 1QY4Nv5LrjQFn+aUKbtb0oehm0nI8M4hQNRrQSnb8f8Vk+4Nwg61O4TVn/5bfO7kDG
	 WRJgBF0aN5ghNfbptXbCvvvM/IHl2/k3bBVfQ699CFcZgTxhuMoaxWde76uHDTD1AJ
	 esysnoUGA8ha6czLuP7V5/2FL0G7zB6+NtUSaKQ3nVu9yEO/Hgi0kQpXMymT0AF2xx
	 a4L+ue7xBokmi5+T5BLMctK8w6q7SJ7KjPf+fDarlrpngQ2DmuhEyTyjGKQyUoeMR1
	 gbdRrYSdIIc0Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/6] shmem: add tmpfs_create_mount() to create tmpfs mounts internally
Date: Thu, 24 Sep 2026 00:44:01 +0200
Message-ID: <20260923224408.3745689-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.rc1.310.g51773c2048-goog
In-Reply-To: <20260923224408.3745689-1-pratyush@kernel.org>
References: <20260923224408.3745689-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tn9fcuuz4ohwzuwa5m8jgh1cihqnug3g
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AF22020002
X-HE-Tag: 1790203465-608842
X-HE-Meta: U2FsdGVkX1/5jATef47xd8D7GP3EXlCKiPxMH6Dl8zTL7dcvvORTUH+B9yYWAWq/IbjGlG1bHzUKQlfaAG+0qBMkEd8ASAw11Egdnn0WMkya9dzZh+We+WzUdIXiwx+Ws6A7PtYIdhfc/4VyN09i5NYd5X/AQVfz7BhUHLv9zS/OVYgtlEz9+00IC/sINrHekg3YdpjMst52HoGQuv5nGj3gMvCNOqwEYEU235wkkD+4lf2Zr/HQJBuAU4LsRaXHGasXEgzYNoYBr00AEVht6Cd4XfLTCYM4hedtWpVXI7wsL1BjsIi2AeKjTKftlNgrRf1CzBjdzBBdVy55fbBjh4RY49AMZRwuBKSqb8iS+yCQNyNgzbMBy8yerBhSLtFw3cEDtk4gGZLZoU5TmeApGX+c4qqXM++XCOwnca6mnGH/OKtu+Qv3i+6IvEtFDNwQctJj+VIpeaI8WCNdOt94YUrAlCJ/H4qo1IQquTpFbV91MLB7NrsJOtfJGjZsEeoFJe3UyB5azB1DedrZ+loy3tBiAJka0HJT/R8hEmhVbxIem7NCh+MqWcdNoFJlJAsND5278OWN90YQscSiP+gTsvsIFSHKv51Nq/j5HZE1QOClqx97bfKQ9Z7x1K+V77mOx2ZoCB3smVxxymjTO5gL9IP0aEu3CzlQlMgvAmGcwH9q9McMD3H9g/tQE98kI0oBb0HPKMWQ2fAXtZW9dU/NwEcTRt43nSQdrLcbiLtYb3hq306JzOZBcRuzHUMN3b7Xym4aPfEoLFk85YMSrJyi2ZgEveYQNhtljYuzRQu/G2MHkNE6wnKK+3f4SU6GUD69A0+YviU+TiFLvMCrdWIYuLq8bsq0P3gioimXlIe9pe0A3rLhG9glwmmFfO0aqmA4VW4V4bIn8ZSRT5Oy3Zn2Kfjor/1HlD98e+M7I6BfK7ZS2koKtZLjcIKAQLusT2SyZtC6Wy1UjhnIOcw9Bfp
 hGCHDQsW
 ViKEmEU/PcXxjNIo1HR4tDH8BfZErJGS80XW1WUZFStYy8MyYP6tleEFknIwYwsVTQhzxha4F6ALg7JvN5ByJOy/mZnzsjBNfmUbcRj4OyQbzquGIKRFzGZUBlyy+vNH22BH6F85Ar0F6kMWrxiTYqvmKYuqEWA1+1hneBFRev9MmrXB4lb6Kd7p1EEjxnHqQLqE5Yp53fbLnh11xJRw6Gdrbk8HMaujtu4KZObZ4SQatTQH+z0AmDtiuIlAq7BToOfvrNVWley4fG+IpVh9JHweVLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Upcoming commits will add support for preserving a tmpfs mount via LUO.
While the retrieve logic can create the mount by constructing an options
string from its preserved data, it is simpler to let it directly pass
the parameters.

tmpfs_create_mount() allows creating a mount with the specified
max_blocks and mode. The function only takes max_blocks and mode for now
because that is all the tmpfs preservation will use. All other values
are left to their defaults.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/internal.h |  1 +
 mm/shmem.c    | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..d82c92c8fddd 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1436,6 +1436,7 @@ int shmem_add_to_page_cache(struct folio *folio,
 			    pgoff_t index, void *expected, gfp_t gfp);
 int shmem_inode_acct_blocks(struct inode *inode, long pages);
 bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
+struct vfsmount *tmpfs_create_mount(unsigned long max_blocks, umode_t mode);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..8660405b6ab8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5313,6 +5313,44 @@ static struct file_system_type shmem_fs_type = {
 	.fs_flags	= FS_USERNS_MOUNT | FS_ALLOW_IDMAP | FS_MGTIME,
 };
 
+/**
+ * tmpfs_create_mount - Create a new tmpfs instance from explicit parameters.
+ * @max_blocks: Block limit of the filesystem, in PAGE_SIZE units, as held by
+ *              shmem_sb_info::max_blocks.
+ * @mode:       Mode of the root directory.
+ *
+ * Creates a new tmpfs superblock and returns a mount for it. Everything not
+ * named above is left at its default.
+ *
+ * The returned mount belongs to no mount namespace and is owned by the caller,
+ * who must either mntput() it or hand it to something that takes it over.
+ *
+ * Return: the new mount, or an ERR_PTR.
+ */
+struct vfsmount *tmpfs_create_mount(unsigned long max_blocks, umode_t mode)
+{
+	struct shmem_options *ctx;
+	struct fs_context *fc;
+	struct vfsmount *mnt;
+
+	if (!IS_ENABLED(CONFIG_TMPFS))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	fc = fs_context_for_mount(&shmem_fs_type, 0);
+	if (IS_ERR(fc))
+		return ERR_CAST(fc);
+
+	ctx = fc->fs_private;
+	ctx->blocks = max_blocks;
+	ctx->seen |= SHMEM_SEEN_BLOCKS;
+	ctx->mode = mode;
+
+	mnt = fc_mount(fc);
+	put_fs_context(fc);
+
+	return mnt;
+}
+
 #if defined(CONFIG_SYSFS) && defined(CONFIG_TMPFS)
 
 #define __INIT_KOBJ_ATTR(_name, _mode, _show, _store)			\
-- 
2.56.0.rc1.310.g51773c2048-goog


