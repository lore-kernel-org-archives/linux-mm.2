Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31747CAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C630280005; Wed, 17 Sep 2025 13:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87731280002; Wed, 17 Sep 2025 13:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765DA280005; Wed, 17 Sep 2025 13:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 603F5280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:40:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26FD511AA4F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:40:58 +0000 (UTC)
X-FDA: 83899457796.09.7ED443B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8290140003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:40:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iOltoQiY;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758130856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyMiPACj5fwId4jIr03W23e+KjEOC5OIcVw+R/uLOwg=;
	b=CAgJ/VFO2ZRTX7vXbku5e/pQxWXktJSXyTJhxGTy/ohwJkVI/ovkL4956T3R+RPCY5deZ/
	ZGV1v/AUo5bUIJHIBD3NbTBXjyUkCHEI1sq/2THyR7Z0HKfdKsjNIRhnijG6t01rsDtYup
	nuUjQue5LGuNeLA7xSGLND5R61gSMwU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758130856; a=rsa-sha256;
	cv=none;
	b=trD9j2RGoVNjpfJqtTWuzkos7BeTtuuHyhuPZU7mIH5YE/ygD357/oasT9iAJ9hGkfsq60
	GfZq5c53/PdU5xY2RMl+PcSRWd0m9wnWwSdhe6TRj2rvCFRvecUd+6LcdcZ4snEu116ScW
	rS+MBlMy/O9Tr7W4xLsx3B3kmaOsn5g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iOltoQiY;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E481E6024D;
	Wed, 17 Sep 2025 17:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E146C4CEFA;
	Wed, 17 Sep 2025 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758130855;
	bh=C/FWcnjtqXbXmArF2cJQxrpogJR0iVY010DR1LrFIwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOltoQiY284U3hh2FAqR2YSLRiqan90fIeNrfxWEWrR29HIUddWKZ/avmPxyf4zyD
	 48SuIuMabx2PFhfGtKxw3xLX5yN5DEqSRLY46DPismYxhCr+uVHXdT9h6wZC73xizJ
	 2EccQO9M+RUx3o7svQ/39W44rBZFiTdpV+FOUQKTR4XmGqjI8B3m4HFfFOhU8jCI9W
	 U6dECIYw2T4DZvhsu7ot2HGYrYhT0HTxXaB3kbSYA5t4TAvDuAaUfh+9rcdHUvY7cR
	 0W9RdaJ1bnVhKXdiQ8D7OWCD48DIlzjcmC8dr3jhzyWngx+DLnlkD1R+QfW+UQ3Zp9
	 BqkAomc0Ys5BA==
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
Subject: [PATCH v4 4/4] lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt
Date: Wed, 17 Sep 2025 20:40:33 +0300
Message-ID: <20250917174033.3810435-5-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250917174033.3810435-1-rppt@kernel.org>
References: <20250917174033.3810435-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8290140003
X-Stat-Signature: 8x54mfrff6nr81mr4iczhy3eiqkxemfw
X-Rspam-User: 
X-HE-Tag: 1758130856-213158
X-HE-Meta: U2FsdGVkX1/3I14ydLYCOj8rpx2TH3NArrS4WfDCFrIwugde9fy7UVoEzB8RSLsyDbqq9U2AiO6KKYrY5IyQ/qPjoxPwRWY3EpiRzoEICEp/FmYVz+1czyUIKNE99bMpXogG9JWmzkEVhx7DN8avMtww5u9mkHaTtrdqPJdCIxDz3JIqkMwyvW4nXtZZ9etUz5RdvD2CQJ+ZD4Az6QKXRsZTopaLr1toJxZluQhcEdmv9fgHkmCpx0wB5FpusOyKQ4Gb53epfvlZplWPcIFlKg9XZhovRMV7GRCJ5EmZWei+16A+cXbl4UBrzo2n+Ahzc3XB9yFHjks2MLh1+vGBRCW3rs3e3vldPEjYKoSb0a/feKr+fJYbFPVXzgtgTby+8808vNSPRa4f6nRiwF0+PVomi7GyMGK3NCRMmG8DAxT7OjVKzGCfB2OG16nVCj024vOqXfZqWUFLA4t0kgfGuDmG+4SZVa1dGYIZ2//0eDbT9eu+EE/H/tZPl9zOzOZjiM1QXQBuIdzS3fSt88illQyGWBWFG8w+tXCzphH/XM2LQM0lshZiNy/CMiWem8A8G/PokX4VcCzAUuJ9yZo75x+VWmMwnTRX2T1vu3fHe4W5THXwi5VakAmrLZFcB62ytkU2AuCn+5OZSBazJC2Frjb8WI6EoJRU0D+XdjiZAnawlVx3d/yvByjXLWjDeJXurRtjOZqMjpVni7bZkDrGXN/LYFrcFBgo4NoDS9gPgUo4jKkFyBr2TVXUHLm8FjUrUh7Jl5dQ59kOVE95wInNeZ97nHs6F2KJub9HEJit9WdheXJZV89n3m2PC5KZbjJApZRDdTd6Fv1jgt5XF8XHaXiNpFdzUxBAM7fr8CesIVbf5gHtPwHnB3Xtdm5j8AHuwAudsQ/4Y6t5GSy2ELBbePFZDTkxa7hgQchTsmi1xy8IZ47vmKqETJug9ct1FHV03RoqJ9FhnsFUglcDTvD
 EEGCiQww
 m2gyOTXR8NAfV+P/di0I4RgmpRfB980GQ3aF6Cfwn20lS7we4ctBG3MGwGx5hj34YZrGO67eHng17z+aPI/EGBgodrtnzHdy17ap3CRcVKOMv8OD8NoivSj5uAGPhGUTfn4AnvjsHJdk1yns3o1dKHCaHV0/IlF20fBjrBPsN9eVrrDkU5VhQsHforRxaSChDPe9quBbTfsXmphdvyhSmF0LaEYbiNNvBRDcFb8fHfymTa0d+zaPPqQ4/EOn53za2LjUCYNVhFWA4srFfCxIhJaoAtQ==
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


