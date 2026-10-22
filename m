Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FF260A6F6B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UHeEfOjd
Received: by kanga.kvack.org (Postfix)
	id 39F2B6B0A28; Thu, 22 Oct 2026 19:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC906B0A29; Thu, 22 Oct 2026 19:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2EE6B0A2A; Thu, 22 Oct 2026 19:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E45876B0A28
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:27:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93A161A0354
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:54 +0000 (UTC)
X-FDA: 85351852068.07.CD2A647
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7DBE820002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHeEfOjd;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711672;
	b=DJ2IiniXeaIQhOt4iQqs69L8l9w0YpOcasUaAWgRuEqbYwKmel+QLM3ocxvTkEAGDodpWS
	TaJAkc4DxysRTZb9Q9WakxdiN0R2q2N/JBoRv44m9CEMutbD+nxqPDCSur7La72iAvpyzY
	tthfvdxcpGPG89cNIpdLn9sniqk6RiM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHeEfOjd;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711672;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ISy2WsvQvNk1sV0mU5gPsd/VQEhvtewcEmpW1TLtd8=;
	b=x5sd/npVaw1L/1Tm0gN7Bw78QLl4Gn2SfDIiJksuH7wa3t/AyDfGRsdUEEfeLYay0wbQBT
	2FxmFZprjaVo2J8MoWYMdXiWlSXAQuAhWQDV0eI5JmxQFa5T3cavzOTfNNPPBJySrrxvKo
	WH5uPXe84B9Ti5wNHTzaLn+Bl/gx+Sg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D464960AAE;
	Thu, 22 Oct 2026 23:27:51 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711671;
	b=dePsz3JxF4RJH28yw6Rdm5inXHOxP6kwo1W26Fsjn4Tttfx6SmAUPum+Ukqkz74f2/xd
	 YnkhpAp9318Y6+RtkcHByT7pzc5EleB3XGMm0KQRbLfcAc7n5n0Ma6EunjyvRVxKqVgMa
	 gBKl2BSN6w8fjPjZzlFsefJPMY1t9C+bbxGsnuq/Sf0Gbp+Xv1jDmMIJAord0wUxOWZhD
	 WaZZP41bki687yn5+2lHVVpp2N+kCEOhmWvGhRBSWMN9+R/vbJIJu6o9xbvfsXHhRQl4z
	 ntKJFnjxNRN/k8uQZvfNZnvJOokJfKA5EzKJVsFFSB8aHlgZGyDOQzLnB9XUTbTmhMA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711671;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6ISy2WsvQvNk1sV0mU5gPsd/VQEhvtewcEmpW1TLtd8=;
	b=r0S7r7Zj6ecmWLFHPZgEfy47fdhjiB3vTDaI0mTP8bpHmtNh0okvcLqLqRbGpSHCXd1z
	 mVgCZD7U2Elfx/DAl5fCbzXBXY4Bdy7d66tWdCWZMotE8MdDiDWbJndPfD7MrCW1ExnYg
	 NhPzRp8oHm6o3O3zuiEthsxTbDOF58NZ3aVLqwt8kgmFS0p1ObqSSLdMDUeprr9eZe1zg
	 aCNHIfx72d3/sJkpXQEVrjT/uM0wVsyZT6J7b0f/VoBGho9U2ilxB81xZfSMe4hDrQyjf
	 OL1k+VVsNuVNFQyweHrtFW0FgHdq+fbdLAXTE/q25LGHFdXzcADUawAesAyZKoSz7nA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 113931F031E2;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711671;
	bh=6ISy2WsvQvNk1sV0mU5gPsd/VQEhvtewcEmpW1TLtd8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UHeEfOjddIIbLsCmfRmyHOLnniIuXPKJoexYEgOoq534AUfB1zPYUlzm4qWGFkZHk
	 JYpdhdXDDHUWHLeYqjlJ72xSuRm28TspPalts0vMyD6CRROvxnbVGuBoN8jkfPWEIG
	 ybui5XwNjKtiMib2g0Q8h2J3EdvGlzc9IvkAL4EToD/ELRmsqh0GtKYEtqGT7xYOwI
	 cdz/An3NXt2dc23g2GxkcHgQPC4kqrxCVmtdPmctsBYGTu/K2/4lScrL4aRTMXBAaz
	 FOmUFcodONF6P40LiDx6wrmR+keck7CkNINXWOKUN8T9Byy5RB93jJ2ed0QoyV8MUv
	 5SgqmgmQyMZBA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4EF8142043;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:34 -0700
Subject: [PATCH RFC v2 02/50] KVM: guest_memfd: Route folio allocation
 through native provider operations
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-2-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711664; l=6480;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/6ChK+dhNyFC5epULer4MMTl5heO+eaQ0hyuSzmx3Fo=;
 b=za/ALoHb/ybC9kgi6o2avnw/xTRhb+35RtnrYcvmZnrWvKtTjSZTkiZbEU0bys25KYfAoQfI6
 RPM9vxjHJ70CI2szG/reUm3EdeeRow6j6qo08Wm3qQ7SAt8dhK26dXk
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: czq6p85bz7xae6yybgxhzh7i1ioh4urj
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7DBE820002
X-Rspam-User: 
X-HE-Tag: 1792711672-163730
X-HE-Meta: U2FsdGVkX1+3jJpmbGsard6MF13xuoqaCytajgDFwytcbn78Q+Th7/uIecKHo5jRnePSpElNmv8iqs6Xaf34qTPLToxIQP3MttnXvpImzGhDWn8fzwXXdphSKPq6B4/Jxf0oIonUgbtg0V/9ohv0R4GnvxeaUGzrK67jAhzwrM5OF97quQcVM1q1SekKuawowVNeuTDhcB0maIBFkNBbxP8k6W+8d9PZL6EzTKn7DRZVbak36h34vNkYUkGSQcKHeO4ZuaCI64Ca7DKiy+w9tBdERMucKOQb4KO3CKC5FrAB/He9Cl29jjuI35KfKjyx5hh/N+fV3zHrbHp9i11zw3UiSBq3eLkrRx9dU1e2fzzIdG3Zl1GL2ObUsdKPeSEE2eDojEZHKyHhrr6rccslU4MtMKi2Vbrrq2uUTx48r8ZIX70bdEC1NogL3pUqxDy+0RLQFdaoC2O3hJSubOdZeAv4a5JvGLjUO27ozoYBQO807qAHU6Ndck1Yd2/Jw7+uO1asWGtkJhsQz4MX56yK75noou+/tRuWcbmbKxWaSDpAw+OJVVT4bCtETzIHKi2VZRNPnCedeWIvgMCmL5YAcoGYXBSHdGnYWrKOkg6fkdIr/2rquDpAZf716TEcjPvVyXmOYJsIhqUFHWIFT6iffZoSBbzazOWvwJ4vpGG2OXAnFrP2EF5PCdfe/wujkRGs7omTR3YyuBEeMNa/7w6KZePiKxoyV6jRbg5a+gJ/8dwFb88xB+eTXWWXy+knzYZmmIJA7hUmrQcxTxHqKBR3CUayiZwK5IAldDuYHfOmSY9P4lRNVOLW212N96f+stf+SMpxOkOZNJ2s2ofLOMs8WeLR4ETcF4GEat1b3YRPmdlBPl9ULZ+JURp8F/W85Vi/eqc8EtltCSOb6G289k0o1drce+cCvYB3LK4YKW6zFJwRsRCgC0RnFIff5rkUIVDAGzBmDquw2YLa03PESVh
 MkAgKB3O
 jIRP40ZDKwSUFGQHwCI6wHSA6XjhDV53ezl64wvqofjpOlOwjuEG0yt588Zbmw4qodYzmB8OQwLHxbJbYDPMI3971RXhrThwtdE2ESKWOuZuU4Hv556O7pUbjs3iebh1dauh7m52zFgjuWFFpEdex9l24HZaJdf+v8JoTgkyiLyNdsw6tsN1vx/T9EvhSHxK3eTrpnzF92sqjmmAovs3rCq2BXfBtaBoa0nqF38mxn4v3ci6dKcto68uwZ7NMxllN92YF4Zqp1pX2QGpQ2/gGzlUsOwR7Q8xOWp3Js9WBQD6zLqAmqTz+rw5pzpRM5BnYZd0yH4987rKN9CBODqf7SjLo9aFosVhT7dgBHwM9x9LS6qfDDleHhaasIAk2r4GmOMdlRHmzhWxiakYU7I2N64cjRcFX9hCCuwy6h3oD+CoD/GFYg0JuG7W8jpFX/7btQrmja6wczbkNrztwNwJnsf0BInt4zsgBuVQbxf6R9u0WxdVSzlIxesiV5esuV7oQyXTdBJNTTChPsice7kUxXMhawQubuFR3hksJzMx9/cx/klyTguOSTI4r5agoYnLPHiAg+igXfl8vVV+OTdGqA5gpVAm4vVTyAmBt
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
2.56.0.257.gf7497c7d27-goog



