Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C4ECCA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5498E0006; Fri,  5 Sep 2025 09:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E6B6B000D; Fri,  5 Sep 2025 09:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3798E0006; Fri,  5 Sep 2025 09:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A84486B000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:13:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D18F1601CE
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:13:19 +0000 (UTC)
X-FDA: 83855237718.01.F3D9B74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B991540004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:13:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGNTu275;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757077997; a=rsa-sha256;
	cv=none;
	b=A0PK9Hf962epo4ph7ekBtuJcRd/4Ox4JL4epkwOJqbvTALYneIM7xSkf4CV7fhE6g+dMIy
	9XlWAccjqYs3Q17JxZ/jASIlRx1iH1rAbzge+lPDfGWFaesHPfeDZI98YX+StY0ivf1BHV
	TeIbtjPQvpI6sUvJF3MpmtNpaf84gWE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGNTu275;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757077997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/NFMtx4Yhan7qfaUDRumI5vWdHH79NVYyphQT29qf0=;
	b=vZFWEXlMAGYd6fn42wosbZAlPjjA6gP6j4OMR+Wn5nD5R/8MfdLIv2GUW7LQAbHlNFS3yg
	mMGTChfzZo7Abvy2EeGCvG5v7LgEFRvyaWf+hfyibLFeEbctkk9pc2k7fibJpmgbwbGnd9
	wjqzqf+EoiIzrgn9BaijjS+OiI/5XjE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7BDA43E60;
	Fri,  5 Sep 2025 13:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9438FC4CEF5;
	Fri,  5 Sep 2025 13:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757077996;
	bh=C3NlxNYz6bfCABhEIee3Vq9GbnEKAONZKNFONpPiN3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGNTu275tZdPUVoHbM/gsRDrY9R4cZS7yNP3f5xFXFJckXDeUDoGcHBVQPqzUEybo
	 p01bpMPmeOFwRV3EFf/vTUyWrR5NT+FphaDifK39Z+ICtA8qx9tjBE7C+8B2gSNAa6
	 /jK445o7hQMS3xvSr+1Kb7Kq+ic17FFSXiHpOcFILLy29BXGrV0VT+UneZgLb+VcaX
	 SmggdGs5SQqC9fO/duwxz6wP9726EJzbjmG4KYyIf+8ew9eKQGYn48RN0M4vjudfxa
	 JTt3Xo97JetPuAa9Ztc+z8clkMInxubohu0XAU4VbSXZ53NrepwMbHL5EuhUD0Xn8y
	 b5bj4d7GC/5qw==
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
Date: Fri,  5 Sep 2025 16:13:02 +0300
Message-ID: <20250905131302.3595582-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250905131302.3595582-1-rppt@kernel.org>
References: <20250905131302.3595582-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B991540004
X-Stat-Signature: 3ahkaemzzib9cfx4wzd3djwz1xp51z5z
X-Rspam-User: 
X-HE-Tag: 1757077997-478450
X-HE-Meta: U2FsdGVkX1+sFfgCWkOjFhNZqYj6wurPY1rYn+pSR3rcNG4rJEbCiEwujd6yClc0vl68QzyqvbbPwDV1e5e0XOv5hnms6+mS+nAkRUx5U51BD/9jKyR0FlT1A0Hxwr/uFMOx1PlGoznuSg1pOZvFc3dZ8h8eW7uhqz1mc7MqRFZOo3Pt7NH1Y0oeniLiaa03NR3SeiUvQ/xLFOe6g6764ZUHVmOs1H743iuOYu2bQ0q8cXQD6O64uZlsK2roNxRF1FfifFloUnuXsXvUvz3iqjXe+Lm44yhG7oMAvSUpDH7w+a7oOa0NmG9BHtSAOHz92QgoassB/59c+4RvIX5AQWehRdbGdYdN+vi9AzFWFRSCRcEBojU4OaOVn+7NSrUZJdiUB+axeN50Idcn1eqFWBtrNlAbr9fiWXaWoTZqBFhCvEfDyZDPLZHzDKi0dsLW5zaYjpPTd301u8yneCLepOOsgQEDIX+FNpQco57ePPr/8p02K/gb7ZYCWCm9YYlJjTdarats0CjPk2+JX1DOi37V35HMFq7sHfC7GS0Bsn91lrL4YswKdeWDq3P3q7VIT1AHSJo89qPjBz5ppDWcnBAx3sM54q2GQx3Uo60hUniMUJc2BP3wVfuAbWuWdVI27OOxbXL/M3xscCW2wOFkD5rsb/bpnyJpaBK3ssvA5rcwbx+RybMk/DpZxWBdK3QNCVRosnme1RixxsGbkAflqCmDbakFLTOgJ43BzOK80yGOtPhXqDy5uk2rTyAIKhg7A+vcUU9o5vcT5HuGNOHhN+f/w/emES9z7QNoTap9Z2bVotId+SlKlHcuXWJIjDUHk79TrXYqcCg2lTIar76lgqeFcict6TbQqQmO2nmVPyDo31ZyAIc2wFIDVQXGCyxVkFGgD4Jtfb5WMo9gCcX5ulk3bQ1UNMRR1uWV4K5WlziGrX5Z916iAK0i75MHVlrSFx1fkvtjy7QlpVQzy9o
 nEmtJDcF
 HIwQaQ/diwJoFEw9Vfmb1jWqbVtcOW6N6oyu9Yykq1KwLVLpVRh+AVMTjj2iahaHUXTBqvFXJMIbNgV8Wq+TFNUDn8Sl78wbFDkoSOb/6FF8eRMrdHb+iQfF2vD0hbD4DKE1gylsrdJRCpFk25XkITFBvyYqtYU/yb30WmoXDBTK/S6hVH/DDd10WIj4Ofjqg6aEw9yfotceKwuoDzWC/dX469sGfW4zGy5ZWnIEyOwp554iqEKUdakGPjjIOg4en1Bd4k1E3L7PuCMfL7Kf8rZpj8A==
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


