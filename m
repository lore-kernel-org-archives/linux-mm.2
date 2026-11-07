Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9301C606D81B
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=go0ddtNk
Received: by kanga.kvack.org (Postfix)
	id 821376B05B0; Fri,  6 Nov 2026 19:36:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3066B05B1; Fri,  6 Nov 2026 19:36:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0D26B05B2; Fri,  6 Nov 2026 19:36:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 408E66B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:36:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3B9A1A0210
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
X-FDA: 85406458074.26.FD589B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C3B180002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=go0ddtNk;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011815;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEFuudziwFSmGmTiu8EshfO7Ouxi+ckFIzuMTnn97HE=;
	b=JnXE4rnOVinJwn0cLZl6Ft3Kcrt21UjJMFCWLRPzLiwBhkqkgTGxRcRWaBXaZh9FDw6C/i
	hFPpudXJqQDrJZ4zIfpFiIm45RJqgjYLar6Z54tKeo61QqSo2Mju0tEbkwUkW5Mkf2lNP1
	UtK/OFoEOz2hYTlAWhQLQwswdA6c7gg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011815;
	b=f3qiZ9+/HUnUvC5khJHICDm6EJlJnT9+195Co1qQMJJZNa08zRjO8WtfaMPOAAMFjlxYSW
	jihaNaSvcitpqPFx4vECbWiyneCmHlNigkJ6z7WmQuxOokKii7ym0ib6gijqO2FYKQi58G
	VRB4eQ1Pp72Cn6zRDQmH/3Wh9nKQQqE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=go0ddtNk;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD14B4195E;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011814;
	b=sj3bO13uiJkgEDulNlXy/ux9ViLjXO+HPdg9em6EVKm0Iu82sEXOBSfCApOZc998lxqN
	 RMFS0IQLqr0N4/n0MZ3tu/xktY9olsn3IuZ5KcLQlr5ha+9QtvnWyO1q/2pGRSSzlMkSr
	 SreXShbV13UhSVWl5v06aVAfnswPvTni8qsENsDPO/ccHqjDSTq13l2r4aKPDAAUSg28R
	 mWfIuvNEmrjnJezWcxhMGUHuWyvjHlNu9YeWq64tcQ0ROgHmdk+HyqkW+S7t/bVnaThoe
	 z5bvhpPDorsqeZM8fi5b6whvIlrZaXzWkQFt0jxIpXWWL5LvDRLosfnkJ0Uqq+GdrRQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011814;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bEFuudziwFSmGmTiu8EshfO7Ouxi+ckFIzuMTnn97HE=;
	b=rguQEmboefWoUDAgqOpTNh6UUestJC9plg5ON/SpuVZwP4wddCAp3tpdLSAr4CaPfsgG
	 CMUEbW4A+WZLtCE6bcFR2eE/o9zthvC9YiVHdCnVv5MoYHfaAq4SJuKs4ZVyFw9h5RvDg
	 n4ygVX/uLtf8V/XUOfXOxyrsDCH9yLqNHeKJut42okwtet3mPKyk9fP4bwUe/MqyKIvOe
	 +T2iaSEoFMPbIwbOkZGA8wnNEYdt0Kx2CmC9kSg4bkVC+2ld3DwVYxfO3zooFdVrk+iHT
	 M0Wy/Q1stBEXWsd6pao+YBVXCpJ8BreQ4LlX4zpoqOT9QJYQEr/ARCLE3/f+TMMRSgw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 558EE1F008A2;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011814;
	bh=bEFuudziwFSmGmTiu8EshfO7Ouxi+ckFIzuMTnn97HE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=go0ddtNkzCV2U67JeVoRLFde0SDi29opIr8EGCo6XcYH7Dbs/0m+wpupMvakXqthE
	 SF4TjHaTMADi2Caf62drH859H+H6S4kdHpeHoGdIhf+W6IT0Y+uWb3K5Y+CkbW49Je
	 Ko9DnjHW5oUMUIpAHTpc+qbRC5yQjfPQx2mDk4dCYb0jK0sZbo/oxTY1sLoNxiIwA4
	 EOoSlgptNRjkyFiNFLE7MQ3OIKifomPJyb0Eqv7/VQPX5dIZgTZWHYhyrvRGPJL7Is
	 uFqzoi7Jc+VUxoaNzuIKJOIrDKb9vENFnyLL0Ci3fjeMpQZqtehgZjXBionEMfkyvn
	 qZsu+8a377yvQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CFEC94791D;
	Sat,  7 Nov 2026 00:36:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:36 -0800
Subject: [PATCH RFC v3 02/88] KVM: guest_memfd: Route folio allocation
 through native provider operations
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-2-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=6480;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=bisyKn0RgaRZ0PVB2Mv7Pnld9GN7IV0HnU91kmdFLiQ=;
 b=gq6xO1p0AW6HJ3a3hco1/15XJuwF8ZjJ6hMogM8wPoSZT5ideRsVOcsBUoit0RKHaoeSkjrj9
 x79iD7DGzB/BxddlQ+r7/EdRnP+zfTYvaH2ez3FpXBJB2NJoqqgzTeQ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9C3B180002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: prnf6n47guzzmnuap8yt9rsydbm1gr86
X-Rspam-User: 
X-HE-Tag: 1794011815-899316
X-HE-Meta: U2FsdGVkX19FVryPXA2RjRnlbfZ6tV2U3qD8YSCTe872sR8lPVp24ryEDgYNPo2YTI6lzVPgtBqeSl0mfOs/Yh+paVLlUS6t5fQn6mgHp3CNsM8xDbFVFm5tvtNwFTUdV9quf0p2CKwG3Oj2J6vpB8BHjDRlFvuFK9i/q/qsXCKt9eKDQNWw2uyWlyc5zxfkr1RLBLpRI/LPuLeO++4TrMptfJcNFXBX369I3Qt3VPgaXpUEW7Rrv0ZWUeBQmJ7rGJ3x2hkuukKFviFCy0r2R9n4oyD/tI5eV0maz+K/Q4XseKPfGl8E15kYpk9nL2MYHSccI9QkKx1v5Yr6kLmDA3KBcYZe1mSrHuMYpz6aR7O27DwCp9al3ZqmMsycQewnu1QwCLSdey6chINA1yGj6fUO5uXPn1Rr1IEiifhdFPQyQ5S3QMMknmnX0hJBC3pIZfoGOLvYY04gTbBy4hmqwbtgXFZjrMqfb1NE158ECmiLbEqhNyEVzD3G3YrHosRE8uPWlENOK3X0manpRghVdIRoX8h6U+2VxhEGSpXZG9FBlD7H4lPdge2xdm/8r9sTGdXMa8f9guuLfLMmrfS4MPzw+yvg98B/lsV3O7TBeL+WAwmcTH3XDL+yw6tknksv1SdfH3HoJy+zOLnbxSHQ6YroD4++HgJ0F/5lnbM9p9RDjMnVbzz4ofEOxsa+2Pjm8sjA8d/CtFjwOIYEAmSwfIL0zV98r79EIpH6lrvx+qVQmJIFQtPpi4kQuMoxXe9OdxrwLEACjaAUjhGBcXsDEEBSjycxzGJlafjSbdr3u1VdvgJ2R703Kvd5qT0sIEEhukcKwYTP/ierkxlJt+A/wz42CamkKhG9Ehjr0S/nQVi1tf+UlAlcHMqa1Ewcuxuv49+eY2rc4xXeMUYVRHdKBO/7VW5fUHb/X/NtRRCa6Yc77hN9Fa9cwdtaVsU/AiPnUzRpIJpvcaboRUKlHEP
 woIHQaQ9
 wxCi/Q4gQ4+c2d7QYvSUAO0DFXxO1juj/kgJ3Zmm+Wg576/j2JEXxcgAO4HaDcCVqxdiK6s5QK2ghzL7rMWYMCnfY0FfBa2ANyUHaaKNeV5UJAHoC3tcCSVHvRBfaqrZuW6pgpOkAzPAGx8nb5668QRxkYUB96RybQH8QP2vCCG/xUSYd9r2wX9oPuaxVy8VKnH3w0U9J7LwNQDWzPmU1JztWD8L6naZLJaYKN2CsQgc4KDCVrT/UrU7+ssBFuB43YaXpkpdnf9OQeuNm2zpBNOUHn7X1LFGUxbbCMmGtpBsMDMFa1mU8p/nXpeWCM6DG0pC1B9nwlPEmPptFy31LlLOFUlpmdYDCZlr2TjsZthW3jsP5Zvl+WlS3X/VQxN4pDAfieYaCz5HvM6e56kdWkJ5uMNbD2+OKfYo/ru65Pw1dRRg8FivyGkdOd6OUTYdwtCFAGW8e/OrJNJ0P1Mr8kaVsr/FEHS6GzumD3iyHr8m4YnjHBSMsxetUC2hn4Kz2WUULCUpsyMX+uu156h5NayiuXQgXwvQqqs5NSuAQq+ps3XPBPwkGLQDq7hfkRE1vE4p1siUknNfYxKa/8Z9fUCShpRp6SO00e9rdGWEdU6CjtGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Conceptually refactor the buddy allocator providing guest_memfd with
order-0 folios as the native provider.

Define operations with an alloc_folio callback for the native provider,
which still uses filemap_alloc_folio to allocate folios as before. Also
define the attach callback to establish provider context. Route folio
allocation in the get-folio path through provider ops, and set up the
native provider during creation using a sentinel fd and attach.

Attach the provider only after the entire inode and pseudo-file have been
initialized. Exposing the inode to external providers before allocating the
file or populating the file list risks race conditions and use-after-free
bugs if an external provider immediately triggers operations on the
guest_memfd inode.

Now that the inode is exposed for other providers, add a write barrier to
commit everything in the inode before the provider (and other racing
provider threads) gets to use the gmem inode.

Expose provider operations so external providers across the kernel can
implement them.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/guest_memfd.h | 28 +++++++++++++++
 virt/kvm/guest_memfd.c      | 86 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 110 insertions(+), 4 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
new file mode 100644
index 0000000000000..218de509769c1
--- /dev/null
+++ b/include/linux/guest_memfd.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_GUEST_MEMFD_H
+#define _LINUX_GUEST_MEMFD_H
+
+#include <linux/types.h>
+
+struct file;
+struct folio;
+struct inode;
+struct mempolicy;
+
+/**
+ * struct guest_memfd_provider_operations - Operations for external memory providers
+ * @attach: Attach to a resource file, perform filesystem-specific validation,
+ *          and return an opaque provider context.
+ * @alloc_folio: Allocate an uninserted folio for a given index and NUMA policy.
+ *               Must return a pointer to a struct folio on success, or an
+ *               ERR_PTR() error code on failure. Must never return NULL.
+ *
+ * Used by filesystems and device drivers that provide memory for guest_memfd.
+ */
+struct guest_memfd_provider_operations {
+	void *(*attach)(struct inode *gmem_inode, struct file *resource_file);
+	struct folio *(*alloc_folio)(void *provider, pgoff_t index,
+				     struct mempolicy *mpol);
+};
+
+#endif /* _LINUX_GUEST_MEMFD_H */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f865fa0e46840..545c3e646e9c1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -3,6 +3,7 @@
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
 #include <linux/fs.h>
+#include <linux/guest_memfd.h>
 #include <linux/kvm_host.h>
 #include <linux/maple_tree.h>
 #include <linux/mempolicy.h>
@@ -35,6 +36,9 @@ struct gmem_inode {
 	struct inode vfs_inode;
 	struct list_head gmem_file_list;
 
+	void *provider;
+	const struct guest_memfd_provider_operations *provider_ops;
+
 	u64 flags;
 	/*
 	 * Every index in this inode, whether memory is populated or
@@ -50,6 +54,65 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
+static void *gmem_native_attach(struct inode *gmem_inode,
+				struct file *resource_file)
+{
+	return GMEM_I(gmem_inode);
+}
+
+static struct folio *gmem_native_alloc_folio(void *provider, pgoff_t index,
+					     struct mempolicy *mpol)
+{
+	struct gmem_inode *gi = provider;
+	struct folio *folio;
+	gfp_t gfp;
+
+	gfp = mapping_gfp_mask(gi->vfs_inode.i_mapping);
+	folio = filemap_alloc_folio(gfp, 0, mpol);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	return folio;
+}
+
+static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
+	.attach = gmem_native_attach,
+	.alloc_folio = gmem_native_alloc_folio,
+};
+
+#define GMEM_RESOURCE_FD_NATIVE (-1)
+
+static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
+{
+	const struct guest_memfd_provider_operations *ops = NULL;
+	struct file *resource_file = NULL;
+	void *provider;
+
+	if (resource_fd == GMEM_RESOURCE_FD_NATIVE)
+		ops = &gmem_native_provider_ops;
+	else
+		return -EOPNOTSUPP;
+
+	provider = ops->attach(inode, resource_file);
+	if (IS_ERR(provider))
+		return PTR_ERR(provider);
+
+	GMEM_I(inode)->provider = provider;
+	GMEM_I(inode)->provider_ops = ops;
+
+	return 0;
+}
+
+static struct folio *gmem_provider_alloc_folio(struct gmem_inode *gi,
+					       pgoff_t index,
+					       struct mempolicy *mpol)
+{
+	if (gi->provider_ops && gi->provider_ops->alloc_folio)
+		return gi->provider_ops->alloc_folio(gi->provider, index, mpol);
+
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 #define kvm_gmem_for_each_file(f, inode) \
 	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
 
@@ -143,11 +206,10 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 		return folio;
 
 	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
-	folio = filemap_alloc_folio(mapping_gfp_mask(inode->i_mapping), 0,
-				    policy);
+	folio = gmem_provider_alloc_folio(GMEM_I(inode), index, policy);
 	mpol_cond_put(policy);
-	if (!folio)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(folio))
+		return folio;
 
 	r = filemap_add_folio(inode->i_mapping, folio, index, GFP_KERNEL);
 	if (r) {
@@ -996,6 +1058,20 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	xa_init(&f->bindings);
 	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
 
+	/*
+	 * Ensure all inode and file initialization (such as gmem_file_list and
+	 * bindings) is globally visible before exposing the inode to the
+	 * provider in ->attach().
+	 */
+	smp_wmb();
+
+	err = kvm_gmem_attach_resource(inode, GMEM_RESOURCE_FD_NATIVE);
+	if (err) {
+		fput(file);
+		put_unused_fd(fd);
+		return err;
+	}
+
 	fd_install(fd, file);
 	return fd;
 
@@ -1355,6 +1431,8 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	mt_init_flags(&gi->attributes, MT_FLAGS_LOCK_EXTERN | MT_FLAGS_USE_RCU);
 
 	gi->flags = 0;
+	gi->provider = NULL;
+	gi->provider_ops = NULL;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }

-- 
2.56.0.455.g6c5a503b38-goog



