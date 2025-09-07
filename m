Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC660CA1017
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 07:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442768E000B; Sun,  7 Sep 2025 03:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CAFB8E0001; Sun,  7 Sep 2025 03:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2932B8E000B; Sun,  7 Sep 2025 03:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBA78E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 03:00:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC408BAFC0
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:49 +0000 (UTC)
X-FDA: 83861556618.30.5B5CA0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 178ECC000C
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HEZKwHsm;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757228448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qgDGmceY/oaPOGxDvJaE0QSmLhbdFfG6qh4SKtUo6k=;
	b=MYiPc8Uad1s/3Akbb1R4ZNalrFkt7xHDhcN+CAiV9AH59aZHaDlbu9JsNSGOCo21QYTKy7
	chFEl8WN2UW3SkNnkwLkm6UYNpuBqeTbjdkNPo1rMhp3hl6WfiA8Ztq9OTGpr0VD82qM47
	uSDHMhVDn86UPERJOPQBiKQt6YMP7Vs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HEZKwHsm;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757228448; a=rsa-sha256;
	cv=none;
	b=S4W8EV+9MJWuFAq+hvGLl0ZZy/xjhEhupwNJJPsxh241SSPuw23UGVaVXf3j1o9+RWcRFE
	pJRywr9+MrSrQTjrJSKr+8Z8GlrE39ROGKd/DtTMnPCnYyJCMrXXu1jqPbHdieBkrZJjPP
	gXA/Xs9EDUeBpfeoT4f6xhWWpzAuy8I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D34643BFC;
	Sun,  7 Sep 2025 07:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ADDC4CEFB;
	Sun,  7 Sep 2025 07:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757228447;
	bh=S6cq5Fd+Tt7edEdfLD7ze+ZKtAEEGtzWPj0q1zSXPO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEZKwHsmg+QtBW5UFiuYs26fucUIr6wGXLeddggrTHC9Qgqatmc8T374QZ/+Eg7eN
	 3Cp2tnZpsbMiwBTqNfFboEAuvBqaFsEi2cwjiokLUKJf+eiR/hyZKhyERzjaRZiqKO
	 qWcUlZigxroFfPXhC2aRs9Liyf/KGq+idNdgxbi4uUL7csesh9HXkeB1uckoUz3h3N
	 oXUjzf1vww1oWvfB9l4KyHTe1abGjyAtQxaTXgFwnA3jM3KpdfipijBM6BFPCW5uo0
	 Asp36UxHGNj9ZisfH32xiFhzIDbj06EjDDQfURoMxacHCdyPXEaApf5f8glSSLDeCf
	 Lsnk/dTM0xRVg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt
Date: Sun,  7 Sep 2025 10:00:22 +0300
Message-ID: <20250907070022.2177974-6-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250907070022.2177974-1-rppt@kernel.org>
References: <20250907070022.2177974-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 178ECC000C
X-Stat-Signature: gtyw6ssokkys9dhmex5zbn5d8ekdk9qg
X-Rspam-User: 
X-HE-Tag: 1757228447-838509
X-HE-Meta: U2FsdGVkX1+JSqmzDA3d97secCo9pW+WkDguNfNuZsEhPxq7P8GsWsErEnfqnXWn2NVtaYQcbN0w4UcxKLel1bazHkiwdnIZXIkumgcBII81uzfDxF3JpALOg7Gczb6zDunmfvBMytNVB3MPt8NXTDPb6ySBdTc8Y8e6lGr5tF8EAlBNwQPv9MMEcZKgjJqi/P/Dh1pfm6YtmDjzZMbiN4bjWKHHM8HojPLZg2fDvNqws/T3h0TerztkH2ZNSN1Mk9at8jT/pXAq4AQ4A6Y+y1tEsSnLXIl0qrlGfJfvofsVUhHblxM4kWdNqUh9TdFQ70Bv91o223JSUQUhelbjhthMBRdsAyF4fo4IRJL9fCYKsLxhkhzTQT6yx7vFH9usbe8nCbH8Ie6pP9vayUBSRtoWUu/93Io5tMbBsxP6mlmBWcGp/egQ3d4OmnbHiL/Y5ATBleSilOI4R6NKFL/3I00J2Xdu4EuRpd/tQ//rcH3FCJRZevPlUiDEqv9DDZ/VbBJ3Ua2rOfXKBzyJDLnGRXRWKb8gyLSt4CGy+L2C1EvlwJ4+UnLAcVEdCdqc9aGvfLwAZFzjxJUx4cKSZ84rSEg/kHgffR1uIkVbPepg51gP9au65Pr4sg1h+JSA1FNPjUC+ENBg497WaRengjjS1yhV7SCFp4kmApCBooS20qnaF3KAhSUwCrUp2yR/Dp41W3/RuxXHr/93P/mhGUREera2bNTzFrzDkAyWq8WB38AfEqZrstihixV1CfrH2D70zspQf0D0JNyYvTt1LSqd1HJ9shfe3rHP3NuLwBS+bbxBgdibsQmbk3EXAR6BN7vU76O81F4B+6g6xLLh0A4GADErQIIrRC0psVM2uUAo4blpqMdx02K7yVNTmHM2Skw871++hWVDtIONWICRQcf9yGyVrvJ4544wgw75EKFjlvj/qYcvyou0J3ayGfMvnYpkW8/guG5LinVj7g/ShXb
 ppi71OyK
 UxbF2CSdrmPvJQZLEQBcgCEEQO2Befk8g3O4VT24NMKlw1dVMC1Rme1mdVWwCuEhBf6h0F5uVxCGJBaM9yMO/9DBpRjOkpetPE+OXfX0onZK0Zz8syT06f0cCt5I5lQp4ehrpCckkPvZ7utSXYq/zmtEh1FRcs1U0pakXvqcMPH5+X7GIp7/Uk4oDaBenZVvKrnpTwK+hiOJvuKXKsR783P7KJ/H1/Q67uV1pjebfqIuOnwy1PurmSDEKChqk9h87Sd2aysytQFp6te4mEoUV4xMHkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

KHO test stores physical addresses of the preserved folios directly in
fdt.
Use kho_preserve_vmalloc() instead of it and kho_restore_vmalloc() to
retrieve the addresses after kexec.

This makes the test more scalable from one side and adds tests coverage
for kho_preserve_vmalloc() from the other.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/test_kho.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index fe8504e3407b..c46f577b6aee 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -32,6 +32,7 @@ module_param(max_mem, long, 0644);
 struct kho_test_state {
 	unsigned int nr_folios;
 	struct folio **folios;
+	phys_addr_t *folios_info;
 	struct folio *fdt;
 	__wsum csum;
 };
@@ -67,18 +68,15 @@ static struct notifier_block kho_test_nb = {
 
 static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 {
-	phys_addr_t *folios_info;
+	phys_addr_t *folios_info __free(kvfree) = NULL;
+	phys_addr_t folios_info_phys;
 	int err = 0;
 
-	err |= fdt_begin_node(fdt, "data");
-	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
-			    sizeof(state->nr_folios));
-	err |= fdt_property_placeholder(fdt, "folios_info",
-					state->nr_folios * sizeof(*folios_info),
-					(void **)&folios_info);
-	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
-	err |= fdt_end_node(fdt);
+	folios_info = vmalloc_array(state->nr_folios, sizeof(*folios_info));
+	if (!folios_info)
+		return -ENOMEM;
 
+	err = kho_preserve_vmalloc(folios_info, &folios_info_phys);
 	if (err)
 		return err;
 
@@ -93,6 +91,17 @@ static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 			break;
 	}
 
+	err |= fdt_begin_node(fdt, "data");
+	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
+			    sizeof(state->nr_folios));
+	err |= fdt_property(fdt, "folios_info", &folios_info_phys,
+			    sizeof(folios_info_phys));
+	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
+	err |= fdt_end_node(fdt);
+
+	if (!err)
+		state->folios_info = no_free_ptr(folios_info);
+
 	return err;
 }
 
@@ -210,7 +219,8 @@ static int kho_test_save(void)
 static int kho_test_restore_data(const void *fdt, int node)
 {
 	const unsigned int *nr_folios;
-	const phys_addr_t *folios_info;
+	const phys_addr_t *folios_info_phys;
+	phys_addr_t *folios_info;
 	const __wsum *old_csum;
 	__wsum csum = 0;
 	int len;
@@ -225,8 +235,12 @@ static int kho_test_restore_data(const void *fdt, int node)
 	if (!old_csum || len != sizeof(*old_csum))
 		return -EINVAL;
 
-	folios_info = fdt_getprop(fdt, node, "folios_info", &len);
-	if (!folios_info || len != sizeof(*folios_info) * *nr_folios)
+	folios_info_phys = fdt_getprop(fdt, node, "folios_info", &len);
+	if (!folios_info_phys || len != sizeof(*folios_info_phys))
+		return -EINVAL;
+
+	folios_info = kho_restore_vmalloc(*folios_info_phys);
+	if (!folios_info)
 		return -EINVAL;
 
 	for (int i = 0; i < *nr_folios; i++) {
@@ -246,6 +260,8 @@ static int kho_test_restore_data(const void *fdt, int node)
 		folio_put(folio);
 	}
 
+	vfree(folios_info);
+
 	if (csum != *old_csum)
 		return -EINVAL;
 
@@ -304,6 +320,7 @@ static void kho_test_cleanup(void)
 		folio_put(kho_test_state.folios[i]);
 
 	kvfree(kho_test_state.folios);
+	vfree(kho_test_state.folios_info);
 	folio_put(kho_test_state.fdt);
 }
 
-- 
2.50.1


