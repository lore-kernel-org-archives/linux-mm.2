Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1785EF3C266
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FEBF6B0093; Mon,  9 Mar 2026 09:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC636B0095; Mon,  9 Mar 2026 09:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED006B0096; Mon,  9 Mar 2026 09:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA7A6B0093
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:42:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 078C5C0AED
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:41 +0000 (UTC)
X-FDA: 84526639722.22.5A1853C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2ACEB8001D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=dDG+1siO
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ki42cLPnp8Qeyh0kILceJ+Cv5Lvk3JbK3h54C1+Mwj8=;
	b=Iwl267QMEk4pNyFEYScIY5cmkSPTn/V/NZGpD1ujGULi/YvnvnF25PRfXUC0HR3hx7xAZt
	pR4eU4g+J8a9h8P4WJ2/Lr77E2S/LC6EOwfUJN5GR7Ts8zCkEezcwxQAssiLQAKzZK3QIO
	+5HirAZdH8KicL9AVcY1mt/tbAgJQk4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063759; a=rsa-sha256;
	cv=none;
	b=DRnuH8kTUTFjw+rcTkiP80uoGyOKqHTjliQ1d2DpbzuyHY/QFrkmKxP08fs2cwDdLp2TSK
	mw6NGoxxPUHrtRLivAxun2W36Q9Nc7g9Eh1KNWMSqqCUtYtTWyku/8/cST2PE0XWLaXYBn
	URVBr3Y37UzV4IMVZPnmy9pDgjCuMPM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=dDG+1siO;
	spf=none (imf30.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Ki42cLPnp8Qeyh0kILceJ+Cv5Lvk3JbK3h54C1+Mwj8=; b=dDG+1siO5bIqzBPb12wlG3NvS5
	EN79ITNUuMRYWb1u/3APu6BeWNKyTmA6hToFHqiHqlkdiRKIA9vIrtstl2+uBPp6ulVEXPpHIY8S+
	/qPvP4qh9R+kZxaNl4rFrhkU83Nxe5JPXoNHmSYP96GQfkng196aUNuNdDxm1mK8+5+Y15RgAjmud
	tmX9OHDK9qsmmC/NOlJliGldXPzZ5sFU2q578//Lo06FbVEOh2aJ9xaWuGi4pzMMviTq09uIs7/mN
	oj2A4LlDnp2AqxBzyRMT+39n4fJOunQF+VSc8FjsK8f/S0NZeXOxCePsuZ5IsPMoJgEhsFOa0Ao48
	Bg65Ng3w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzasS-002G3r-Hy; Mon, 09 Mar 2026 13:42:32 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 09 Mar 2026 06:41:47 -0700
Subject: [PATCH v8 4/6] kho: fix kho_in_debugfs_init() to handle non-FDT
 blobs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-kho-v8-4-c3abcf4ac750@debian.org>
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
In-Reply-To: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2751; i=leitao@debian.org;
 h=from:subject:message-id; bh=pgo9Bbif/Iq2LY22Zf8vKl/gIhQNmdeP3CUxMaHZ9Dw=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprs4yoKfrHmBJbEuCrYV9rdiomUpCNqeGUD49s
 JR++cG0exWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa7OMgAKCRA1o5Of/Hh3
 bQWLD/98p0l+FcT2BDdyTKmRTYD8ikYqEE7RChHTT4zoIMfKc1BwA+xtvZUUAVJXhXqdxUS4s79
 0uGsW8iYers5S5MQIn79gWL44duPHmAIANIZlzBe7WE1lV7JYculVbw67zBpCKv8MZcRrDmJoHx
 GXw4uVdTrXe/EXgvJlAmNEfmamGKe0nLq93P9LRUcKsgVgTKW71hQBlvxv5XP8MZfaoU9swIWc3
 2PpJHC+cXA3+rEbXG1KVzM+eVyT7MPLMhuTKKdfbFyyAT9tPZ9UkiMpJKtVbgueuLN7KpWHhohR
 wd7sj7uHsMfWsL2bQtpf888+xZYLqRGvqn8ioA3lb/KGw4l8DVoXzqazDibQ0w1X/3+aiop5AY1
 KWBQ+FZnaQEFlmCT5lfX4fdDOyCFB4AI1OSlCS6hEiOUvRtV5RZ3s10bhyBx9CnPAoH2f06ci/G
 g0Z3LvvdcOCNz1lcOodOu0cQkFRmUL8LmD4wEmRybFtMps5ZPVVax00gYgv+kjZEMUvWBpht5jG
 kVMFwn0VVfXGiSgMrTOIO/BVvgu0CHkibLtrXdCMSru24HseBgV62fjTDdmyFEPfQ0W1L6oUFV9
 rI+y+a4L7i2QX/SaGirRr5UdNjaw2HaQeX60PK6zOS/K9JBcmIV5R9PfadMTGQXO4KJuIEoU0D9
 Nc+zunbNNdsk26Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: a1a54bu5bu44nphcpzadka44ayt3jdnz
X-Rspamd-Queue-Id: 2ACEB8001D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773063758-307173
X-HE-Meta: U2FsdGVkX1/TaxICfrHOm9V2/WJMrzTd6nEu/J71Gn4SlnynHPsHe8A71bSIg6LNEmyAsVihvIRImoh6lLEc42LCjOwpp+UsbdcvIdfm2mfxMLP9yWJWN+2AmRgT/S5Osn8/+iHbo89Fb5BPBtURB3KSwjvjjlzNfMm4qAAQ5eJgAGFxDaUO6iaaUben5OYxRDEMkYrQ9vydctj2S/AR4HMLt3zkv8aNWsf0nZZgP2UpVhjTz09x+zPfTqWUoENgcPRfj7uRSFB/G/4lDBrHuiyhir7rWQDquoZr/vkq3KclSBDqpMt8OKYFSyZSAAFls9fVIvq1Qkvhjh+/YMINw0657C79kdeb4NnPZ32owWu/bBTQREj9tU2fgzkhnkvadUh3djfF4jSHnuL7pBfbiCjdRa8JcsEsUvYJHFXsjzHNK+GOYlU9W764k7qmxnl05UeinhMrPdWGJx8jhiqzG71o2SxRf+VZnxASolJZ/iVRj2BdTthrjN84Ym4zMCye/DwGStI5Yv0wAkobQWoapdKuUytJqWn+UMijqrXRv7chFaoG4VdRMKWW50LZ2/b2byKwBOJcY3id+u5pC719NsZGB5Yn0cFdXuG6IEsV6uR4Wi37Wy42KdxeIwCDBRd+ICxDX2iBd9BQrGhukXB6N2FiNX40x61Z6JBHrCyvRfQlYlkMLw9JOH73JB2cJIG8W7HL3OAUEjMGHQ8eR6Y4qlR6PrNNGZiySDJ/6bUl7uOdK+16pcue+Cq6fiBMEAWLOWvwzQTaNBaFNZoV1MsOELKFFFEpP+rGWE+MI0ZFuWW/pnA4OFxuX1z6dqYmOOk4Z2FLDLC6FlSS4UX9k6HPDi8ncBWD4Q81aVGgqy0Tab9iFZCmkRoZ72Mbz5IXpWt+TZREhJPDF0vfSYlipJdXU1ETEwXXlJifMyAY41w2euPu60YOF8RoxBT8eUD71lO8aVUEb+wLMOel5arxKAL
 23SF6Xk8
 EEvVV7ddipDdopShuwi8+tCnpGPuCED1ADpYuGwab8NlA1Qqq9+FP44kpH4djEJF5vTPNyDvV/JhlTrLP1D6Jm75d48pwnsjKlp0x106zdMU5844aHvBBGO2MXmnPxD7P7RqfEKXuCzu/57YDIreNu0JZpnVbAUlwgcnu2kqGyCmRGhPuzU3+j9yrwFm0RHyG/4LtbiaZ0OfDRNHcP8NDhwce4nRTo0U5Zd5fpndFhsVYN74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_in_debugfs_init() has two problems when displaying incoming
sub-blobs in debugfs:

1. It uses the hardcoded property name "fdt" instead of
   KHO_SUB_TREE_PROP_NAME ("preserved-data"), so it never finds
   subtrees stored by the current kho_add_subtree().

2. It calls fdt_totalsize() to determine blob sizes, which assumes
   all blobs are FDTs. This breaks for non-FDT blobs like struct
   kho_kexec_metadata.

Fix both issues by using KHO_SUB_TREE_PROP_NAME to find subtrees
and reading the "blob-size" property from the FDT (persisted by
kho_add_subtree()) instead of calling fdt_totalsize().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/liveupdate/kexec_handover_debugfs.c | 34 ++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 7a100f2bf3947..257ee8a52be66 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/libfdt.h>
 #include <linux/mm.h>
+#include <linux/kho/abi/kexec_handover.h>
 #include "kexec_handover_internal.h"
 
 static struct dentry *debugfs_root;
@@ -121,23 +122,34 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 	fdt_for_each_subnode(child, fdt, 0) {
 		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
-		const u64 *fdt_phys;
-		void *sub_fdt;
+		const u64 *blob_phys;
+		const u64 *blob_size;
+		void *blob;
 
-		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
-		if (!fdt_phys)
+		blob_phys = fdt_getprop(fdt, child,
+					KHO_SUB_TREE_PROP_NAME, &len);
+		if (!blob_phys)
 			continue;
-		if (len != sizeof(*fdt_phys)) {
-			pr_warn("node %s prop fdt has invalid length: %d\n",
-				name, len);
+		if (len != sizeof(*blob_phys)) {
+			pr_warn("node %s prop %s has invalid length: %d\n",
+				name, KHO_SUB_TREE_PROP_NAME, len);
 			continue;
 		}
-		sub_fdt = phys_to_virt(*fdt_phys);
+
+		blob_size = fdt_getprop(fdt, child,
+					KHO_SUB_TREE_SIZE_PROP_NAME, &len);
+		if (!blob_size || len != sizeof(*blob_size)) {
+			pr_warn("node %s missing or invalid %s property\n",
+				name, KHO_SUB_TREE_SIZE_PROP_NAME);
+			continue;
+		}
+
+		blob = phys_to_virt(*blob_phys);
 		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
-					     sub_fdt, fdt_totalsize(sub_fdt));
+					     blob, *blob_size);
 		if (err) {
-			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
-				ERR_PTR(err));
+			pr_warn("failed to add blob %s to debugfs: %pe\n",
+				name, ERR_PTR(err));
 			continue;
 		}
 	}

-- 
2.47.3


