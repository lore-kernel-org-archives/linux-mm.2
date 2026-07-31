Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE05C55172
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321F66B0092; Fri, 31 Jul 2026 17:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9226B0093; Fri, 31 Jul 2026 17:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C11B6B0095; Fri, 31 Jul 2026 17:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCC466B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:53:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65CDCA018E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:53:25 +0000 (UTC)
X-FDA: 85050423570.28.658D827
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf24.hostedemail.com (Postfix) with ESMTP id 90242180007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:53:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="McMi0g/m";
	spf=pass (imf24.hostedemail.com: domain of 3UhltagoKCJM8B3xAB01883BB381.zB985AHK-997Ixz7.BE3@flex--loganodell.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3UhltagoKCJM8B3xAB01883BB381.zB985AHK-997Ixz7.BE3@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785534803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFbpBG3BWtAJOPPgNm/eX/59dGOWD3hR8l2ysdNLveY=;
	b=6ypV71n5t5q/sjbNHPuQ95xbrBFQgzobIqQVw/XWXY/DG+cVwkq3f3MhK06RBk+/L9+Q9M
	AxZhbKeWiBps3GUF0zJJJJRUsrfcROC4cRglV8rq7Gfkk+3Nh5N30uoc/M3qpLA6EmAIgb
	Z+Jm5pV89DP0uq8bR+9KqDdTmQTt2FA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785534803;
	b=ENFgyWQ8WkKm8XKu185Axgf5A89LqHv2m+CdcHqMw6M7Rnp5Kd33EVd/twm7YzdkUBdSwO
	mRiKxPND85BaER6VSDQtg86dFJiIlLp14gc31jzVqP0tLt8GqCwp2IA96YEkhjTyAoNP8l
	o4zR9OOAmnhB0hviADsD2zo1KWcoApY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="McMi0g/m";
	spf=pass (imf24.hostedemail.com: domain of 3UhltagoKCJM8B3xAB01883BB381.zB985AHK-997Ixz7.BE3@flex--loganodell.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3UhltagoKCJM8B3xAB01883BB381.zB985AHK-997Ixz7.BE3@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb4bd11ddf8so1589134a12.3
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785534802; x=1786139602; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pFbpBG3BWtAJOPPgNm/eX/59dGOWD3hR8l2ysdNLveY=;
        b=McMi0g/mjTR1A+crgJWoGIKlPnrgwqeY4qaTBM4Ab4OM+bhY6GW/oTBc5iVeUzfOa6
         oN/7l2+s85y8c7qd2N+wWNmHkDjaznKNmF+B2b4DWIFXFvwUOeMueBrY2DXW7c5N41T7
         Ex2xGc/udiyinTkrgBr3klr+SaJKothqzF0cPXyRjQGUFTDpm5oR+ScafvVFLNTn3QgE
         ZTz0AokgREqiEHSuNwUFb/2mVuRg2edZl33fJOAKpSjCg7KYP9b01E4iFCrPrg/f43mg
         0BHboE7T9d+eHH7SGP+9vmLRPHdyNf42sEOpwJ1Mwns4rDNFnUXk2Flfo4up+mssK/Y2
         P9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534802; x=1786139602;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pFbpBG3BWtAJOPPgNm/eX/59dGOWD3hR8l2ysdNLveY=;
        b=BzwnO8H9PV6vAO/ca/GKQEW5A563GLHg4pVzKRr+P/xCoUidbHtxPR4ElwyGzEijIC
         Qh5gGem+qaI76LrJiZ2WyiU96L4x95hy8K2WbWYcmYWAygi+Q4LOkoPU955LkaDT2Zo7
         Ua3evVOLv4VQf2rzoriwdclSiEjrX0cWVckgMGj+DjqQ/BV+PG/yuzbLEqYTzRpeHGqo
         7WwoXtXVLaoE7OhJ8um9gF0MSB8kFLlaeV1lb7DwzltAwQ5DUtu7VqWfWhTEjNS/jZa3
         llIO8GUQrT/XrfjQteZ4Q8Uiosv4V9WVFYxs//EoD7qdls9rA6JB7RQ8OrN5gRR1APra
         ZNuw==
X-Forwarded-Encrypted: i=1; AHgh+Rokmn6MFtz6x+cojhk4le1EJ7zYqKbQNXi4nvrx/rgvMNWIfp2xMEe2FUJprrs/DKvcafuUv13G7Q==@kvack.org
X-Gm-Message-State: AOJu0YysHqXkSUjwwU/P3sBJ79kuv8BhOjQKmMql3vw5qkyBk7bQzDmI
	0pK5gt8tT8P7g/kobdKkJOwPLOUn0dkGCOTU+e3zIoEwkmy57HjmkteJ32Ga5cS0QVziq8frHyG
	ItCdqmF0mGHb34sVngguf6A==
X-Received: from dycjx24.prod.google.com ([2002:a05:7300:fd18:b0:311:1ea1:d67])
 (user=loganodell job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:e082:b0:3b3:bf95:f7e3 with SMTP id adf61e73a8af0-3c92a89cb5dmr1207283637.43.1785534802213;
 Fri, 31 Jul 2026 14:53:22 -0700 (PDT)
Date: Fri, 31 Jul 2026 14:52:22 -0700
In-Reply-To: <20260731215224.831696-1-loganodell@google.com>
Mime-Version: 1.0
References: <20260731215224.831696-1-loganodell@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731215224.831696-3-loganodell@google.com>
Subject: [RFC PATCH 2/4] kho: Add support for multiple versions in subtrees
From: Logan Odell <loganodell@google.com>
To: graf@amazon.com, rppt@kernel.org, pasha.tatashin@soleen.com
Cc: pratyush@kernel.org, akpm@linux-foundation.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Logan Odell <loganodell@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 90242180007
X-Stat-Signature: pprsx43cn78wrfzdi51i88bg8woiosd4
X-Rspam-User: 
X-HE-Tag: 1785534803-667215
X-HE-Meta: U2FsdGVkX18c5iex5JysV5b1YQJD5bnNR2se1wAHn8KaHrmkdE4NMCDOkMM3hXeVSxT/caORdCV5GvBs4iB/8RTbouzdjrsGV6TU6o3w2cSMKmvMsSnM9cvxzNEsOpmR2mrAv1Eyx9UU453M9B9DBbd9jk3pCzvoS3F/ITzrjngn/MdyTxdKdIt5pyH1QA4/8lhmQWvaQZadR02M6YyqruHKTVX/bUWRqZfwE38+v0ojiz3LCX4T1Bgtl3dnsMBGKMiuID6PkzR86mwxnRb5KZl4u0qoyptoXOjX29swan3pzlRhFK5HLVFMr4xcVdxDdScJ3/mzUmkuNg/3FrUE70tL9gZx+jH1SSEkuXz6ClG6uCh+l99an4EMnrOq6fuhOgPHycAmp0JQfJ22p8JL5AT9ePv7VrCVkrAJqpVmoNU42pUgi/9NeAallRRQxQ2wKdAqxXFyAZEuMk6vXFDrEioV0Xr730CERqHFtjefKCdSiWq8f/oQT7waQ8bflCiawZ4uVHkDtxd3ksOA8bhrcvIs7YKcrcx+48o3fRddnnscNBCkpSLyGMbCELGdZyp+1H8RymlWQT/VdJwfIVN8kH+q391RByMPVKOuEaMfYaSZxS+pcFsu47Xu6xfhv23G4rSI/E44yCo1YQIMVGTx/pOruUqU9NitehP8e9h72P2YbZUMAe2kMQ4f1WYdimQXB8KPU/8z9+HQun1zqqPBbM5BTc7iXdOpOU+p0ftvJtPYDQfvrU2tWNUcsCbbzphdxFGg9AVX6oAnD+M1Xo2GkyxjaQHIInFq/kX0gD1/lmks10QU+kyNhfndgoGfAuTVxiksxTdCKeelbSALbdOl6+Vn8yTV0GDsRJ0Rl/pF1CerBB6BMW845KlBG95JoO2WWKa03eHtDVlB/QqfgB3c5R6s5gWsGFxXZYCfWTNAz8rCHVA6U8E4jwFtL0gsR+9B33Cp1zQi2O+DC/wVBFg
 cnLhtdw1
 wgNeMgF5LfGdgM+ELFsUBzYGokUIZGuUxMityj2Hg33qr6Q26hH7fvL/Y01rZoImgH5oTsEUavX98J1136mNJfkC5PdU5zbT0MCjF9bK3xui0F6cqSDNklNL+vh6tsB+wLnvNyQF8Cxya9DPqawEKKHzZoAxuRktI75P/hQI+/KJ3YOCwCTD0qBXerztCWmn0kRC4eaHgWLgIsALXAncEZWIc1az342OMqbXmGuLnkLfR6Afw7n/sRlr7eTkjQtIivZmp0VF11+Mzc+odHKRH4YglXDF/FFKAwxLICRxgNxPXPU8oKfgDNooSzSLllD2K5Rr2ooqY11mPhbFXTByru6jA5ni22TTciVR1SCMBHZPlmUvzZwdpgmIVDETbqeJULQyqd9eEwvtQLEUW/HLJ8fhwYQNjOHV4K6pTJJ6BtSHuwhu6RMnTE2oYRazC27dRb9mOQ/aqbvD8tZFyIimBHTi0BrnjRmVP0GzzeCe/keODgSfWit/42aVcJjZUn+DoTlv1fexr4yNr4QSRzAgD26PaxjnJJ4jNxt7WYVOFxgXGEkdZ4t8od3U84AjXdzczr6V+FgwR2KgpxQLp3DxQ/J54OAmLhEEz3mmg1bJL12d+vxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add explicit version support to KHO by creating subnodes with
the version number. The first caller to kho_add_subtree_version will
create the parent node and versioned subnode. Subsequent calls with a
different version will add more subnodes with the version as the name.
Remove is updated to handle cleanup when the final version is removed.

Example Tree:

       / (Root Node)
       =E2=94=9C=E2=94=80=E2=94=80 compatible =3D "kho-v1"
       =E2=94=9C=E2=94=80=E2=94=80 preserved-memory-map =3D <0xphys_map>
       =E2=94=9C=E2=94=80=E2=94=80 some_legacy_node (Legacy Node)
       =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xphys_l=
egacy>
       =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_legacy=
>
       =E2=94=94=E2=94=80=E2=94=80 LUO (Versioned Parent Node)
           =E2=94=9C=E2=94=80=E2=94=80 1 (Version 1 Node)
           =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xph=
ys_luo_v1>
           =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_lu=
o_v1>
           =E2=94=94=E2=94=80=E2=94=80 2 (Version 2 Node)
               =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xphys_luo_v=
2>
               =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_luo_v2>

Signed-off-by: Logan Odell <loganodell@google.com>
---
 include/linux/kexec_handover.h         |  14 ++
 include/linux/kho/abi/kexec_handover.h |  16 ++
 kernel/liveupdate/kexec_handover.c     | 215 ++++++++++++++++++++++++-
 3 files changed, 237 insertions(+), 8 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.=
h
index ac4129d1d741..1d47ab76b02b 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -33,8 +33,11 @@ struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *fdt);
+int kho_add_subtree_version(const char *name, int version, void *fdt);
 void kho_remove_subtree(void *fdt);
+void kho_remove_subtree_version(const char *name, int version, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
+int kho_retrieve_subtree_version(const char *name, int version, phys_addr_=
t *phys);
=20
 void kho_memory_init(void);
=20
@@ -102,13 +105,24 @@ static inline int kho_add_subtree(const char *name, v=
oid *fdt)
 	return -EOPNOTSUPP;
 }
=20
+static inline int kho_add_subtree_version(const char *name, int version, v=
oid *fdt)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void kho_remove_subtree(void *fdt) { }
+static inline void kho_remove_subtree_version(const char *name, int versio=
n, void *fdt) { }
=20
 static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys=
)
 {
 	return -EOPNOTSUPP;
 }
=20
+static inline int kho_retrieve_subtree_version(const char *name, int versi=
on, phys_addr_t *phys)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void kho_memory_init(void) { }
=20
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi=
/kexec_handover.h
index 2201a0d2c159..55acb73b1d27 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -73,6 +73,22 @@
  *
  *       Physical address pointing to a subnode FDT blob that is also
  *       being preserved.
+ *
+ *   Versioned Subnodes (<subnode-name-N>):
+ *     Alternatively, a subnode can group multiple versions of the same
+ *     data. In this case, the subnode <subnode-name-N> does not contain
+ *     an 'fdt' property directly. Instead, it contains child nodes named
+ *     after the version number (e.g., '1', '2'), which in turn contain
+ *     the 'fdt' property.
+ *
+ *     <subnode-name-N> {
+ *         <version-1> {
+ *             fdt =3D <0x...>;
+ *         };
+ *         <version-2> {
+ *             fdt =3D <0x...>;
+ *         };
+ *     };
  */
=20
 /* The compatible string for the KHO FDT root node. */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_h=
andover.c
index 29a05cec2625..6dc7c328a6e2 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/page-isolation.h>
+#include <linux/slab.h>
 #include <linux/unaligned.h>
 #include <linux/vmalloc.h>
=20
@@ -722,15 +723,31 @@ static void __init kho_reserve_scratch(void)
 	kho_enable =3D false;
 }
=20
+static int fdt_err_to_errno(int fdt_err)
+{
+	switch (fdt_err) {
+	case 0:
+		return 0;
+	case -FDT_ERR_NOSPACE:
+		return -ENOSPC;
+	case -FDT_ERR_EXISTS:
+		return -EEXIST;
+	case -FDT_ERR_NOTFOUND:
+		return -ENOENT;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int kho_add_subtree_node(const char *name, void *root_fdt, void *fd=
t, int off)
 {
 	int err;
-	phys_addr_t phys =3D virt_to_phys(fdt);
+	u64 phys =3D virt_to_phys(fdt);
=20
 	err =3D fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME,
 			  &phys, sizeof(phys));
 	if (err)
-		return err;
+		return fdt_err_to_errno(err);
=20
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
=20
@@ -762,12 +779,11 @@ int kho_add_subtree(const char *name, void *fdt)
=20
 	fdt_err =3D fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
 	if (fdt_err < 0)
-		return err;
+		return fdt_err_to_errno(fdt_err);
=20
 	off =3D fdt_add_subnode(root_fdt, 0, name);
 	if (off < 0) {
-		if (off =3D=3D -FDT_ERR_EXISTS)
-			err =3D -EEXIST;
+		err =3D fdt_err_to_errno(off);
 		goto out_pack;
 	}
=20
@@ -780,6 +796,93 @@ int kho_add_subtree(const char *name, void *fdt)
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
=20
+/**
+ * kho_add_subtree_version - record physical address of a sub FDT in KHO r=
oot tree with version.
+ * @name: name of the sub tree group.
+ * @version: version of the sub tree.
+ * @fdt: the sub tree blob.
+ *
+ * Finds or creates a child node named @name in KHO root FDT, and then
+ * creates a child node named @version under @name, and records
+ * the physical address of @fdt there.
+ *
+ * A debugfs blob entry is also created at
+ * ``/sys/kernel/debug/kho/out/sub_fdts/@name-@version`` when kernel is co=
nfigured with
+ * CONFIG_KEXEC_HANDOVER_DEBUGFS
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_add_subtree_version(const char *name, int version, void *fdt)
+{
+	void *root_fdt =3D kho_out.fdt;
+	int err =3D -ENOMEM;
+	int off, sub_off, fdt_err;
+	char version_str[12];
+	char *dbg_name =3D NULL;
+	bool created_parent =3D false;
+
+	mutex_lock(&kho_out.lock);
+
+	fdt_err =3D fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
+	if (fdt_err < 0) {
+		err =3D fdt_err_to_errno(fdt_err);
+		goto out;
+	}
+
+	off =3D fdt_subnode_offset(root_fdt, 0, name);
+	if (off =3D=3D -FDT_ERR_NOTFOUND) {
+		off =3D fdt_add_subnode(root_fdt, 0, name);
+		if (off < 0) {
+			err =3D fdt_err_to_errno(off);
+			goto out_pack;
+		}
+		created_parent =3D true;
+	} else if (off < 0) {
+		err =3D fdt_err_to_errno(off);
+		goto out_pack;
+	}
+
+	snprintf(version_str, sizeof(version_str), "%d", version);
+	sub_off =3D fdt_add_subnode(root_fdt, off, version_str);
+	if (sub_off < 0) {
+		err =3D fdt_err_to_errno(sub_off);
+		goto err_del_parent;
+	}
+
+	dbg_name =3D kasprintf(GFP_KERNEL, "%s-%s", name, version_str);
+	if (!dbg_name) {
+		err =3D -ENOMEM;
+		goto err_del_subnode;
+	}
+
+	err =3D kho_add_subtree_node(dbg_name, root_fdt, fdt, sub_off);
+	if (err)
+		goto err_free_dbg_name;
+
+	kfree(dbg_name);
+
+out_pack:
+	fdt_pack(root_fdt);
+out:
+	mutex_unlock(&kho_out.lock);
+	return err;
+
+err_free_dbg_name:
+	kfree(dbg_name);
+err_del_subnode:
+	if (created_parent)
+		fdt_del_node(root_fdt, off);
+	else
+		fdt_del_node(root_fdt, sub_off);
+	goto out_pack;
+
+err_del_parent:
+	if (created_parent)
+		fdt_del_node(root_fdt, off);
+	goto out_pack;
+}
+EXPORT_SYMBOL_GPL(kho_add_subtree_version);
+
 void kho_remove_subtree(void *fdt)
 {
 	phys_addr_t target_phys =3D virt_to_phys(fdt);
@@ -799,10 +902,10 @@ void kho_remove_subtree(void *fdt)
 		int len;
=20
 		val =3D fdt_getprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME, &len);
-		if (!val || len !=3D sizeof(phys_addr_t))
+		if (!val || len !=3D sizeof(*val))
 			continue;
=20
-		if ((phys_addr_t)*val =3D=3D target_phys) {
+		if ((phys_addr_t)get_unaligned(val) =3D=3D target_phys) {
 			fdt_del_node(root_fdt, off);
 			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
 			break;
@@ -813,6 +916,59 @@ void kho_remove_subtree(void *fdt)
 }
 EXPORT_SYMBOL_GPL(kho_remove_subtree);
=20
+/**
+ * kho_remove_subtree_version - remove a versioned sub FDT from KHO root t=
ree.
+ * @name: name of the sub tree group.
+ * @version: version of the sub tree.
+ * @fdt: the sub tree blob to remove.
+ *
+ * Removes the @version subnode under @name node and its associated debugf=
s entry.
+ * If @name node becomes empty, it is also removed.
+ */
+void kho_remove_subtree_version(const char *name, int version, void *fdt)
+{
+	phys_addr_t target_phys =3D virt_to_phys(fdt);
+	void *root_fdt =3D kho_out.fdt;
+	int off, sub_off;
+	int err;
+	char version_str[12];
+
+	mutex_lock(&kho_out.lock);
+
+	err =3D fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
+	if (err < 0)
+		goto out;
+
+	off =3D fdt_subnode_offset(root_fdt, 0, name);
+	if (off < 0)
+		goto out_pack;
+
+	snprintf(version_str, sizeof(version_str), "%d", version);
+	sub_off =3D fdt_subnode_offset(root_fdt, off, version_str);
+	if (sub_off < 0)
+		goto out_pack;
+
+	{
+		const u64 *val;
+		int len;
+
+		val =3D fdt_getprop(root_fdt, sub_off, KHO_FDT_SUB_TREE_PROP_NAME, &len)=
;
+		if (val && len =3D=3D sizeof(*val) && (phys_addr_t)get_unaligned(val) =
=3D=3D target_phys) {
+			fdt_del_node(root_fdt, sub_off);
+			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
+
+			if (fdt_first_subnode(root_fdt, off) =3D=3D -FDT_ERR_NOTFOUND)
+				fdt_del_node(root_fdt, off);
+		}
+	}
+
+out_pack:
+	fdt_pack(root_fdt);
+out:
+	mutex_unlock(&kho_out.lock);
+}
+EXPORT_SYMBOL_GPL(kho_remove_subtree_version);
+
 /**
  * kho_preserve_folio - preserve a folio across kexec.
  * @folio: folio to preserve.
@@ -1336,12 +1492,55 @@ int kho_retrieve_subtree(const char *name, phys_add=
r_t *phys)
 	if (!val || len !=3D sizeof(*val))
 		return -EINVAL;
=20
-	*phys =3D (phys_addr_t)*val;
+	*phys =3D (phys_addr_t)get_unaligned(val);
=20
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
=20
+/**
+ * kho_retrieve_subtree_version - retrieve a preserved versioned sub FDT.
+ * @name: the name of the sub FDT group passed to kho_add_subtree_version(=
).
+ * @version: the version of the sub FDT.
+ * @phys: if found, the physical address of the sub FDT is stored in @phys=
.
+ *
+ * Retrieve a preserved sub FDT named @version under @name and store its
+ * physical address in @phys.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_retrieve_subtree_version(const char *name, int version, phys_addr_=
t *phys)
+{
+	const void *fdt =3D kho_get_fdt();
+	const u64 *val;
+	int offset, sub_offset, len;
+	char version_str[12];
+
+	if (!fdt)
+		return -ENOENT;
+
+	if (!phys)
+		return -EINVAL;
+
+	offset =3D fdt_subnode_offset(fdt, 0, name);
+	if (offset < 0)
+		return -ENOENT;
+
+	snprintf(version_str, sizeof(version_str), "%d", version);
+	sub_offset =3D fdt_subnode_offset(fdt, offset, version_str);
+	if (sub_offset < 0)
+		return -ENOENT;
+
+	val =3D fdt_getprop(fdt, sub_offset, KHO_FDT_SUB_TREE_PROP_NAME, &len);
+	if (!val || len !=3D sizeof(*val))
+		return -EINVAL;
+
+	*phys =3D (phys_addr_t)get_unaligned(val);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_retrieve_subtree_version);
+
 static __init int kho_out_fdt_setup(void)
 {
 	void *root =3D kho_out.fdt;
--=20
2.55.0.508.g3f0d502094-goog


