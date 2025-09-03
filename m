Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E9CCA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 06:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDE58E0008; Wed,  3 Sep 2025 02:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796C88E0001; Wed,  3 Sep 2025 02:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CE38E0008; Wed,  3 Sep 2025 02:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5496E8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:30:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1792659671
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:30:36 +0000 (UTC)
X-FDA: 83846965272.14.06273ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 57DC4140008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:30:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aC+N1oXw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756881034; a=rsa-sha256;
	cv=none;
	b=44k8YY5ilpEUOS2c/a+kT5xeo9r1wsvaGgJ6xQx9D1LTeBOeXP5ds7Yw7Xs95NdOv69SQr
	WtvJiKsr3niHJqTyGQUxBzLuT12mQazuJkkiVm3kwtIcHPQ5cm89SPn9+pZETjYzTfgWPm
	bbOrDYKGXecTCQ4UcmxXjQ4gp05xhjQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aC+N1oXw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756881034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/NFMtx4Yhan7qfaUDRumI5vWdHH79NVYyphQT29qf0=;
	b=L6dHsrSet0gy9oPo/6vpgyICd9TWZfgr4+ZmTOUFnWcrtxNbWQyTRiZQsuxH2aaNcEMVv9
	0RXJ2uL0sV6WHrDuzQrOqspDZnTC7rL0DO3LT5h0Q4P/+EZSR36HUeTkUIj1ZfPQmxUId+
	fR0DbGtCOZpZT+3pDfCvehurE7+9MG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 028AA44BE4;
	Wed,  3 Sep 2025 06:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B792CC4CEF0;
	Wed,  3 Sep 2025 06:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756881032;
	bh=C3NlxNYz6bfCABhEIee3Vq9GbnEKAONZKNFONpPiN3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aC+N1oXwxBgKXwGUcqK/EB5vl94l2OaSNEWh5MVcKe9/E3ZEaR3Il3xvniELhXC/u
	 QEjwv5BvLPs/0LpPZgTeF9956fEiZqkVkJH1CteKyNspczWHXrTsgbwdSqpVSW7y3a
	 bjV4uwAzs5j3qtLiKFRj36ghUYj4cbpmvKNvJwjfPg3Gc2t600hWq/Zw42Zd6u1Vow
	 gPAObDgd8sIX6fQ95Fa2bXboBlxUlAUAR/q0sZ1FN088T0nnV3BFvMMv1XeM4kKNfR
	 DkTEZ0nX/vogWZzUXpbt7gdX7X7Hlm9WfJSpdtksE5qf5hUiDk92XCB/enYUB7ESzO
	 jtNDZKFvGUnIw==
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
Subject: [PATCH 2/2] lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt
Date: Wed,  3 Sep 2025 09:30:18 +0300
Message-ID: <20250903063018.3346652-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250903063018.3346652-1-rppt@kernel.org>
References: <20250903063018.3346652-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 57DC4140008
X-Stat-Signature: iwzsj84x4ub84zkxe8tz6p996ifgwbj3
X-HE-Tag: 1756881034-120826
X-HE-Meta: U2FsdGVkX19HFEgmdPmFTLg2ns8ehTpRiWqzYCMZY9Zg2SNXJMiSXFDFjsGJLp2txkLX/ZzQr03U1kZSerp4/4ey664eNCAJlqe/V52vNSGdIcoP1FPeSEsNhPvqu8532GqtBGS+CmTUlg8ZuSV8KXdnWmNGJj0AP0pfWVv/H5xBUH+uJ19My07gI3MG+o3jRokzD9pYYrGP1Xtn6j8Efx7o5/JJC2T9zb4ToR8OcrsjHo/NzD6y7ONMg8hgjut/DTHrQDCZjrEz+rhpGOSvwnjZXCugdqtN+PHWCyxezUj+AwHrURq8xz3n+oc4ZwmQTY2gqmf2cka73LxG/H/PGrH8koV/1lHB1QysJNkZd9ZevmqNDZcc/hAWYpbuoIBpEqvUvJCVjM1kAyTfTw9P6bysABnn6zfCTQyWKAb8fI9jp2V+z+9AH6z3ti5y2MBRHyLxeZVdjOmkCex+svWWd9TVR0RfGX3bx4e3WCca1QvVp3Nk12b3mpzn+Opvg2+hjcHIMi1FIi2qBGe9yAXZBjcIstsjxVZguyZpcK/bz+fiqXP+Mr2z0+NiYeR1SQIfzJrEDXzAHEopcS//lJYJeEv2oroZqnS6FIgFl+idriUMqSshY0qsftRqAzSedjEZZrBjVGBB7yhSuR2tXNlRdvFklM4BPoIEgTnIK+BKCz6FY7ahSvVRb6N43+xR70XbxzSYQACKNFF0UZ3mUuYxRUBYoCnuNLanDcjf6Wyn4SN3/JR5kACBLITSjSQ+c7dzLOSBcJdiW4pNfcS86fXOomTpYYn9mB6E2M5eeMztjp8vtzcj/itvGI+9uGSbBHzdOK29YQ5cydx+4iMXKQXVbQbqwNw0gdPGN6ANqHzzTnXMbqcu6GSslh/7NMbURzn3boLx+iEAdBtSLicAFFFo7XbsF7REOkHIW/aEgJl45bgGH14YCCeilWNG+LaH8wflb4rQh+0sgM9KxDuJDoU
 Y20+xv39
 TaC5Rr1CperPBuaiPZG7DInGIBgSB8HUR6CeHkijETwzW3j8oRrszBCbxrUPX1MfjMYkWDIizRWxx5eMiJL3n9nRHCsHnGqHJ+oMSM+UdykGskNI50BPOUL2A+o0MjPR1XJdddAK+XNmLwbt0XFqNqv4+tk+NpBHy5vcy1bjUWt9k2x61kBQfSlSJlyi5c9/Ov1pi5Aw234EPJ4XaFtN3FZ82UEK4eSPeQFlg0vevjRkvI2D8jGBBUQ8O78SFApbjX8LC6KD1HgHK2PBJXln20EBPHw==
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


