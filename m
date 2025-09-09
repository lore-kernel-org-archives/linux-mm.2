Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3872CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216E78E001B; Tue,  9 Sep 2025 10:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0D28E0003; Tue,  9 Sep 2025 10:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0693A8E001B; Tue,  9 Sep 2025 10:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA67F8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:44:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DE2111A506
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:44:49 +0000 (UTC)
X-FDA: 83869983498.06.05105BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE6C1C0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:44:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5MFgw81;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429088; a=rsa-sha256;
	cv=none;
	b=r93NzpfhTopDJKzWYs7yPyVI2CLoOj6wq5Z2G+lJNI0qFXwC6eLPyOUc7iycA8KUe/QR9f
	iggKyC9ysnM48Q4329J/oB7Ecgs2ruREDnQ4/7xbVP/md8pvm9e9Ms6d9ALmvr08rGOWcC
	mlXzgafyoWT1heJLrp73wCM2g2933QI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5MFgw81;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPGNTWcfTMCf7LM5UsEIAfkz8s4zcbBDjcuDh5GLSao=;
	b=Da8QBdczOtabtVpd4AoaelxVifTagdUEGeGldO8UEzZpQTWF20H9YKyI9UQXZwQXJ6VilD
	5CCkBs1YJ8U/m00RxAR5YYdlkmss+ax+kgTnkgv1u4ldxj8NAmL+acgylYoZHkM/duMXSg
	Jtq3o6iXjzGCRrx572r4k08LA9I8nIY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE08244D1B;
	Tue,  9 Sep 2025 14:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB53FC4CEF7;
	Tue,  9 Sep 2025 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757429086;
	bh=5rpwGu8/al+jSPVVDiN+aC7cVtsur+Qn+e55fU0YUFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5MFgw81ctwGvYwePgn0tk5D0dAPf1flnsty/cI4NL15pvNkly5f8OUHdx9B9NQgf
	 WZkofDjZ9wOKpW0h5ohIT89geDptp4SKbq7w9YRCuPU8NxKrYxIsLAtFxDzgdC+RIe
	 AnSgoxvyjnsn2jVvpvy2Tn/DXkjKYhcFjRaRC60S9rdwSO7H/cbFpzkOVyZanvL4QQ
	 fQV8/JgmbtLt6mz2D39P+y2IM65bbjWQ4kn7wwKDq6Q/OA42Za2LuhQyHmjSieIUr6
	 vbJ1HMhsZeme3QsIhuwq2edA+jBSUjkQq4fJ9GZF0FojJgMBKRoGqZjcAAFTUcmAa7
	 /MNRrfJy5mnrw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/4] lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt
Date: Tue,  9 Sep 2025 16:44:24 +0200
Message-ID: <20250909144426.33274-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909144426.33274-1-pratyush@kernel.org>
References: <20250909144426.33274-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE6C1C0016
X-Stat-Signature: kyi17asojxp45kqsystdrsrzesc3mwt6
X-Rspam-User: 
X-HE-Tag: 1757429087-530265
X-HE-Meta: U2FsdGVkX19t7POcrZlDJ6R+j9jlWlCOWmrgtPHKj24u/lEmk0cSwyrdPAu1z82ipvB+15jXpMQaQUZhTtoTDumY/99FFTjcM57H3/Do029qzbdPsMwf9yvv2fneiMq01KOM+NjXgqWYPMFUciBjSOa0lbxgDDAPhhhOAkaYT2Myh5viYjSxojIEMMaCj2huzWZBJFXpc8L8hsVupW2AS8ivBOx7rbH5LMYTg7fsrDLBulXRbxr3kdD/es2lz39X42npLVian4Uh7V50Dw1UuyxpOZsYOk0wPVzL+X1V/hVzpKLopVgL2GLFNpQSfvSNca6M+1WpVRFwGGJKba1XEjC9Aww1YXDjOdYi0XqSXaETwY+U9QPa2Vq3PlUNaij/9sehDbcs+RvVN6VsZ0+pS5uxgHpORl7PC3pDV1KylXPGT6wTkcNtN4FWZsL0PdJL4dBmZFuiLSF6m04RWiKaMzteSRUMSumC6pbbLQfzXHZ4qvNR24G7ucgYGPFF/Id6R+IXUxQ1oWs7hWzzaG2T6YkZVfiGtza82moh1VOeyLiNBwrUBvi4GIRqmmSsIPH376n6+T5hLBzxI6FYKrqZv9Z/s8KQQ62Ixjkr+LK7ntfza1Z2WLZLQN4hhleAMTXxQwv1ApHu+TzCibEKLVkUD/3trzGi48bwKO/zcy+nm+PdL26XaToECGkaeoVePtzjOcxkSBg+dfK2aNG67I3sMUk9UvfoufIULkZkxu9bdvmm3jMnDGpCPMt9kzrLitp28ppIWei7jAXT1u8gxDcZkyO0wnBfTZuqIZBLGDxdbyhgVsDZ3eoR7M5AtHtMNy4VgFBOsSCZuhrrm4GQmayRJdI82qyZwP5YIeoY3KJ+X/QXnerYVOEhnWQQUdtGcgHSXhRv0sFGeNV1squb+K5lJTo+CVNRoeEqaHtZ5AmDI3hOvnM86xazVkVCZRu+P+ipFmxILnoAnC6lQYf9T+U
 9eI8ronS
 m98u8xBZNH1sgUS+NLamnDPj2Dcalbk6X9U+Jlv3eDd2lDDRUwwcaEd9Wqow48qpPptTj3vgLpR++SfDd+UJ9W4j8YxucfvR8YWCfwAmvH3ROF/MCFUb/gi69k0V8WsayUwApqzssxyr5SSUOs7pZ48kVNUh0J5Lx4TSV+BT3eWTEz4Ar5VN7WikUy6o2kZG0/h8qv74MG6L5Jl9cdjychP1OAkN4QduqnN95Oz4nVUdZioqS7+vMDG/xkfm4GprerANAb20tkEGDeemzwEY6fUzSZQ==
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
[pratyush@kernel.org: use the KHO-array version of kho_restore_vmalloc()]
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 lib/test_kho.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index c2eb899c3b456..3f4cb39cd917e 100644
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
@@ -67,14 +68,18 @@ static struct notifier_block kho_test_nb = {
 
 static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 {
+	struct kho_vmalloc folios_info_preservation = {};
 	phys_addr_t *folios_info __free(kvfree) = NULL;
 	int err = 0;
 
-	folios_info = kvmalloc_array(state->nr_folios, sizeof(*folios_info),
-				     GFP_KERNEL);
+	folios_info = vmalloc_array(state->nr_folios, sizeof(*folios_info));
 	if (!folios_info)
 		return -ENOMEM;
 
+	err = kho_preserve_vmalloc(folios_info, &folios_info_preservation);
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
+	err |= fdt_property(fdt, "folios_info", &folios_info_preservation,
+			    sizeof(folios_info_preservation));
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
+	const struct kho_vmalloc *folios_info_preservation;
+	phys_addr_t *folios_info;
 	const __wsum *old_csum;
 	__wsum csum = 0;
 	int len;
@@ -212,8 +221,12 @@ static int kho_test_restore_data(const void *fdt, int node)
 	if (!old_csum || len != sizeof(*old_csum))
 		return -EINVAL;
 
-	folios_info = fdt_getprop(fdt, node, "folios_info", &len);
-	if (!folios_info || len != sizeof(*folios_info) * *nr_folios)
+	folios_info_preservation = fdt_getprop(fdt, node, "folios_info", &len);
+	if (!folios_info_preservation || len != sizeof(*folios_info_preservation))
+		return -EINVAL;
+
+	folios_info = kho_restore_vmalloc((struct kho_vmalloc *)folios_info_preservation);
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
2.47.3


