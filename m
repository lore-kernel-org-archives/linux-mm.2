Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E807CA1013
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 07:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FBF48E0008; Sun,  7 Sep 2025 03:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC8A8E0001; Sun,  7 Sep 2025 03:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF488E0008; Sun,  7 Sep 2025 03:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8858E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 03:00:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F31921606F6
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:38 +0000 (UTC)
X-FDA: 83861556156.02.5B71B48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41061100009
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+GFJd57;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757228437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/NFMtx4Yhan7qfaUDRumI5vWdHH79NVYyphQT29qf0=;
	b=spmZosj8U7Ii7tjyl703SfZKVYiM4pmxEizs4svLJA2gD1/umhWimbDAbmDN9sWMONeSpA
	sKA6gAhzfSCtGiNJjHQINhPWPXH8e2HVNlUN6cPbiS8ftovSTMHz+hQN29kkbv1tKalb3h
	fYfsjKLMUr/Pgkp+uQ4yGuqhM7NuXH8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+GFJd57;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757228437; a=rsa-sha256;
	cv=none;
	b=SgdyjnrO3soqvwmvCV38QCXNQsc8iK70jpirA+wbdvzHa2ZEfuwH/JccPlaYCUqBnMBznq
	tZH5SM+Li9MC1zHD2qOFIaZm307+7OJuU4RkSzHo7z0yb7gcKfm1oGVE5lljWE6zpgiVgf
	qGQOjV0IusGIbQrBRZv+hPRplpjioBA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BB7743BFC;
	Sun,  7 Sep 2025 07:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB81C4CEF0;
	Sun,  7 Sep 2025 07:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757228436;
	bh=C3NlxNYz6bfCABhEIee3Vq9GbnEKAONZKNFONpPiN3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+GFJd57FHStAx/OTPu1bR/rH7JaPjT7G4TukR1LSAMtHgjk/Qt/7IGGznoGvvkkP
	 ygPeIcefuWpuWlpPgq8eGOt1+9wnFQvUp+3kjEKk+mtrjH+p93VPhhvmaSrTXEt/KY
	 nFszmHwkVUN5lU/ioEXXJTufA+3i49fu8IE/E/cmiwKgNp5WQBg3S8SuWYHDJCeNSm
	 vl8N03RC39N7GrDJAvXIaR9FAIri6XF1nSA7dAX0CZvb5hysuMQH/YkjjAhzHgakje
	 /MIY6t/1rvrlGGUk+bHm76OHvuiGRCHnzFO39I82lMyOnWV84f1iHcH8wgLLD2Ii+I
	 twEkTFHNZoEiw==
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
Subject: [PATCH v2 2/2] lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt
Date: Sun,  7 Sep 2025 10:00:19 +0300
Message-ID: <20250907070022.2177974-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250907070022.2177974-1-rppt@kernel.org>
References: <20250907070022.2177974-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41061100009
X-Stat-Signature: nyxc7fewziyfbitusw33taknp1385d3q
X-Rspam-User: 
X-HE-Tag: 1757228437-753230
X-HE-Meta: U2FsdGVkX19/Ky1TLSKXkAenuwWFMKaxbW0N3EHJkbKUuJbgeUbpVcF5730hLKfLdaHIQe+/TvZFwwjk//n/6Xps3rxvD5bDFh2URZ1W7BxwDMy6VGQBR25b4G+qWC2zRj38RpGjxkZd0n/n0SRDE8LELQc/Hmm5LDLOVVZKskJhbecLBtXIIhOqsto4E7eFAmD3Su5CjjZ4dgzUHVZY9pci5tuea/KtkjNAG81GVw8HgWDR+GT/zhsB6PW5GBlLD8f9qVQhsVIzXGNILGhBDi3VuiPReZm+bSHQ4W6ACFCLe47qbJsdUOO1zujiUNq8ucJ1HG+oqSwyCDRaiultTYDRYyDGRvP6yS0S3ePYSxfL0U4Tb5q1CC2EzBQ5o/XLNmj8UVtVdv3RNgJ9m8ZZO77rj6F9iezeMGIFM0jjIGqmwUI7Jq9CdKxaSqZxZD/ho+7SS8N9MtVtLR8FU/lhBoAlUMt5hKENipdq8BPDn9Awo1MO8QphOd2hmq3NFtFvtsYs8vpJgq43ooz4A0CwaZpxzZjFg6rFTz27arW8QOLfUTWuuse/z8YQwxpFtbGJZt9JOqb34y7Xe2DAq9FX8kpflvQgiparfMyasQ6dbB5VTerBUBgFTGOnj6zrNvRPXW8V6Sl8i2w/svwYmqN6cz5c/g+qx09k0EgeQtN3DCDfQxf9EojanUoR4sMtO9hNpj3LZcFop/A/08m3P7mefBpmKBfL/jH72We0RMabYAjiUUg35LnjNeFFpDUTihdRmvhi4lTh40AZXWXR7UQmLQg7OGYeZuAXDPcoYawvr0OOYY9UXVS6sJPnj7GKe8BK8xbaNW1bqhmcqroRBE/gGJ7vDZgtGPQGSAieZQR51lKoGZRMYTFEOQToien74lUV+Kgqo+daH0IfGmIyi5NEZFUA+MAJ+ifFbDticzvZ7zg9DPbVtPpqGD690MFfaNeHdE9D8+msgnKbx3RXO5x
 xVn/2Eee
 UuTWnJqggSSimFdYnhdu/90gLUzxV4A33t+jMIVsiY16duxKU3ryPHoDgvQGQadC1nU2xFnW+7dT3zumZdHlsesi8CaLon87NVyUtiKB6WPjNmy5ddvOXBeToUhWXHbP70ReA8f5eRs6uY6w5ilV/Ug9PMrvo0e2pUNrMgGp8YeB3h6PHPLorohV3Zlnhne2dqalqFyrnmXoTuaOX/i8YSupeV0CIPDIq/MjJGqztf6cokcKW7BFyrnda8JhCzsgN1Px6MSI8ys2C/ZYXl12N9MxUCg==
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
 lib/test_kho.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index c2eb899c3b45..10045f5979a0 100644
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
@@ -68,13 +69,17 @@ static struct notifier_block kho_test_nb = {
 static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 {
 	phys_addr_t *folios_info __free(kvfree) = NULL;
+	phys_addr_t folios_info_phys;
 	int err = 0;
 
-	folios_info = kvmalloc_array(state->nr_folios, sizeof(*folios_info),
-				     GFP_KERNEL);
+	folios_info = vmalloc_array(state->nr_folios, sizeof(*folios_info));
 	if (!folios_info)
 		return -ENOMEM;
 
+	err = kho_preserve_vmalloc(folios_info, &folios_info_phys);
+	if (err)
+		return err;
+
 	for (int i = 0; i < state->nr_folios; i++) {
 		struct folio *folio = state->folios[i];
 		unsigned int order = folio_order(folio);
@@ -89,11 +94,14 @@ static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 	err |= fdt_begin_node(fdt, "data");
 	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
 			    sizeof(state->nr_folios));
-	err |= fdt_property(fdt, "folios_info", folios_info,
-			    state->nr_folios * sizeof(*folios_info));
+	err |= fdt_property(fdt, "folios_info", &folios_info_phys,
+			    sizeof(folios_info_phys));
 	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
 	err |= fdt_end_node(fdt);
 
+	if (!err)
+		state->folios_info = no_free_ptr(folios_info);
+
 	return err;
 }
 
@@ -197,7 +205,8 @@ static int kho_test_save(void)
 static int kho_test_restore_data(const void *fdt, int node)
 {
 	const unsigned int *nr_folios;
-	const phys_addr_t *folios_info;
+	const phys_addr_t *folios_info_phys;
+	phys_addr_t *folios_info;
 	const __wsum *old_csum;
 	__wsum csum = 0;
 	int len;
@@ -212,8 +221,12 @@ static int kho_test_restore_data(const void *fdt, int node)
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
@@ -233,6 +246,8 @@ static int kho_test_restore_data(const void *fdt, int node)
 		folio_put(folio);
 	}
 
+	vfree(folios_info);
+
 	if (csum != *old_csum)
 		return -EINVAL;
 
@@ -291,6 +306,7 @@ static void kho_test_cleanup(void)
 		folio_put(kho_test_state.folios[i]);
 
 	kvfree(kho_test_state.folios);
+	vfree(kho_test_state.folios_info);
 }
 
 static void __exit kho_test_exit(void)
-- 
2.50.1


