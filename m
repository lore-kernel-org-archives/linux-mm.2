Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58CB0CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 05:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6768E0007; Sun, 21 Sep 2025 01:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76958E0001; Sun, 21 Sep 2025 01:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E538E0007; Sun, 21 Sep 2025 01:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 803E48E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 01:45:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AAA058122
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:45:23 +0000 (UTC)
X-FDA: 83912169726.27.063D8B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 921EAA0006
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:45:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TBGP/GUI";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758433521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltVTmdN8kJbSge5Xrl5tHwX3yRThU8TnDD9Pw/0APNY=;
	b=BRHa6/82vb+9jPRAbH2+v1zWLWftcUTQuCfET47jIvL8yw6pkFYaz7Bdd/gy1PXdCpr2EH
	WjxCtivP7YLrz+XZhlKCAI+aorCjA1hNgntLnYIUvm6BYToP/OAQIPY9gXMqTBXWiu5CIh
	VWbB9SoN50vTwJtw8T4YaZiP7Jk7Plw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TBGP/GUI";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758433521; a=rsa-sha256;
	cv=none;
	b=JATCXo970d1npN1/QOhubZBtBhAr9q88Nc0vaGh1r2S41wXRh4Pz+Mf+aJx2QypHwNHWNt
	MRhJuNwE6BBtPP6zP0p/4btnxSRWaC0hG/wO4f0RLlIJCckk7jGOOCojQRU4FyJtjzXT+1
	OUlVq+G+EMPmjRt/kfoiXXTwLd1/lWU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6DDE40251;
	Sun, 21 Sep 2025 05:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C06C4CEE7;
	Sun, 21 Sep 2025 05:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758433520;
	bh=2ElMcd0eKP7FDlwP4eCezro2fZ4qxvCn6nBIpUc/YyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBGP/GUIZ8NU7qzknyJtB8/KV50lutfqTQbg/GHLvAnVGJryTEWSAxOwN6KBjQzDo
	 f5LFFpjrv4nkCXfT69YMg2u4ApYlL7rGv9RqSQXV2WRD2ypg60rEZhX09gkPygeD6Z
	 piCT477rBl6tQFGZfMN4JENiCws06vVYPkyl875WnraoS+MkIk02db6x45XTqjUQKH
	 1pgCyaIhWi2/IiaEy1SmeLBnHmE5OpxG2Crf31xBmojIFUsaiBUp7O9hN2owtoYtfU
	 fUNuz1p9ANpLZZNElM4+JLksRU9h+SJdkgRFtJLajgXNWnC9+EtrKUskOlfR4J8x0U
	 cvpdx+8AIAZoQ==
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
Subject: [PATCH v5 4/4] lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt
Date: Sun, 21 Sep 2025 08:44:58 +0300
Message-ID: <20250921054458.4043761-5-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250921054458.4043761-1-rppt@kernel.org>
References: <20250921054458.4043761-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 921EAA0006
X-Rspamd-Server: rspam05
X-Stat-Signature: mekj1yobm9myknm4cyjzegffb8irktjs
X-Rspam-User: 
X-HE-Tag: 1758433521-311741
X-HE-Meta: U2FsdGVkX18keYq2Wd6XvjSjwphOf4tPg+xDhXoqRiLJr0AOTSA43d9RW6GXNqtjMk6y4ngfO+WzEqZZCg1hl8cBUsVO5QTViF7ZQJHHoaoKMu+WgbgZxbzcJ6ozaTZw3mAJjUdxAvvlgXgFdXfN/bQn3S87jVsH8aIvJnIWWiJ8o4rQMNODpPveZzlxudjuHRTty0v/nz1W36my6PmauTzUkMdS6a60QbWae0OTs+1o9t9BTfjgDpatC/o64vSSwZWRzKe0Jiw4noumm2wLXx1ioEAjaGvjFjPRUT/TnL2JVaVU+Qu7aY7evYA4xrBos6hB7/mCOUvH0igGir4rHg/l4T/tgfRUxx1Jn7HyM80NTYFNSdAWNRHF3fjN2bXu6PBAh9eObyy2KjtXh+bd/qXBPnIQbUy91fn1N8oSu1NU+XCliiPfsuu8qGea3eFGnf4yJ9B2Hf/VVAimbdN+HDKVCzDa0msFuvmhwsdDuVmzD+iGzWOOVlNctOMOZGJLhAOzLStToszI1+3y5WAZ/fpYvRbwXAH2HxD3MpsVxdeLEMh+6AWlWG9Cul6XtDj8BZtJFVt2+ClYE/AgMgxDEFgR+wcYrhmfOys6xndK/VsKpeTR+pDRoGJrGgabqEd+NHZR4vQHczi44TeiNLYSQfBzrx6MF9vlBSU6P1yeK9smhQZsu/jMzVaK9Y6HkBm518W/BpG2Vx4akSz49S6LvSIuWOzFfjAERhXFmRsW4mMnHZkCO0MP8hNzyfQUWalOeKTOmH0k6MrkO+kueXdW2nbQeJ58aaZUf31OYoIlJ+hALXJBc6JN8SRiXQakZUUYUGayDKvnyrDaA6UMR72156jctehEM6ROavJQviG3pwIucQD4BlLCV9PNQkPFwqcZm5EKtWBpwRlxvE5UJrD7gsCbt1KG/VumRorNeLDLI8DQtBpT/IqvMCEyG0Q7gmcM+T1r7U0sUeEMYj+fbux
 rgKEwd1I
 CTAX+7mMT6ifyEzwf8aFqJOypTyvcsOUyRRhY0ugtdNr98Z7eWk62QfFB+wNdjFRGbKn7udBriQcMPKy1rX0lJzpS2nQTZUV+QXGGoXs/qrCrFEKman5WdmjXCw1ux2ZwDWPvPyonHkw36bVMfaCu/nKIZpCAAx4uInYt+aR9PPPoKDmI/CQkfHSEZZYB2BTPrEOMb7guIfC0iHBdmKBjm0jLeGGqMTLEwGTnuZwoQjCYYXdl1zF2cmZCM+CLHMtJCLAYLScnHi+doUOrbNiJrF+FNQ==
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
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 lib/test_kho.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index fe8504e3407b..60cd899ea745 100644
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
+	struct kho_vmalloc folios_info_phys;
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
 
@@ -209,8 +218,9 @@ static int kho_test_save(void)
 
 static int kho_test_restore_data(const void *fdt, int node)
 {
+	const struct kho_vmalloc *folios_info_phys;
 	const unsigned int *nr_folios;
-	const phys_addr_t *folios_info;
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
+	folios_info = kho_restore_vmalloc(folios_info_phys);
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


