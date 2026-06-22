Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BC2CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 21:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F616B0088; Mon, 22 Jun 2026 17:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9966B008A; Mon, 22 Jun 2026 17:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A929D6B008C; Mon, 22 Jun 2026 17:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77F4D6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:57:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6FF6402FA
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:57:58 +0000 (UTC)
X-FDA: 84908911836.02.A06E0AB
Received: from cae.in-ulm.de (cae.in-ulm.de [217.10.14.231])
	by imf10.hostedemail.com (Postfix) with ESMTP id DA562C0009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:57:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of lk@c--e.de designates 217.10.14.231 as permitted sender) smtp.mailfrom=lk@c--e.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782165477;
	b=iv0ukTPxDcJzBZ+y98hmkg60NBTUFzydnDne/blxcJVN0tRHJ7wPzL8Ggg43wqLyvm0nh6
	bpmoDMxh3rohEcGaQT9uUDkJlRzvQ6MZ3WO3ZeHRCXAG5oc2Qj+ioN1uoSy3GA7zCOqvLh
	k1G8NfTwzcOkGXh5z5O9c71vQbvtoZw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782165477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=eUeG+DLdnxGpD2IPsWHN9Slrx+HrHbg3Z4NQp3a9bv8=;
	b=DJ4adxkqTldR+Th98WMzGj00bDGyijSZlYVDrLpm4ZAZmby8sfmgTLIkZn/r1e20E3F7Af
	hew1P0x/pucBM6xWf4rcmxgZaJoKbTm8Xx/QSL78/Mgty0L5P3mBy7N7nkEdAbnTrbxfq7
	+eAodlohC4zN4LxTeF7PU+/V99ml75I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of lk@c--e.de designates 217.10.14.231 as permitted sender) smtp.mailfrom=lk@c--e.de;
	dmarc=none
Received: by cae.in-ulm.de (Postfix, from userid 1000)
	id 3B08F140033; Mon, 22 Jun 2026 23:57:54 +0200 (CEST)
From: "Christian A. Ehrhardt" <lk@c--e.de>
To: dri-devel@lists.freedesktop.org
Cc: "Christian A. Ehrhardt" <lk@c--e.de>,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] drm/shmem_helper: Check VMA boundaries for PMD mappings
Date: Mon, 22 Jun 2026 23:57:17 +0200
Message-Id: <20260622215718.1532689-1-lk@c--e.de>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5yacn668khezaeinf1pm3rgpabx64dmz
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA562C0009
X-HE-Tag: 1782165476-101457
X-HE-Meta: U2FsdGVkX1+o8bSntnoNjw6/W5wdPP45LqAA8ZW6rtiN7WIUA3GB+2PLaEAwu010XN10z1IHtKJAppENWtwYZQz8hVVWI42Sm5gKl0q5IkK+9JCdOznXXj4cUpQqUR+zH/iEf5HAcWJL0jXtZFs7noHKV4HcB2x+3f4gLohVZrTlxOkUGizkIEepwZCQ5yGyRTUqfB1McecLLQlk3tpsCHqV7dg8zeLX8bv4fdxvXgkRkSC33KOI5Jg0HUHncFN+EsPUY08AyJ/RJ0enzsFclchT1JUvIL5ho0npQdUt781DxT6BhFOynKPZfMimiSpkRThpO40IUEcZtlTqBjDyEUm/hB9dt0uPB41KP6n59efYdsNTAfnb6tylIyspWmjNLWAoaj/CxWwczBm2ocHDuIgCEBEWMSqF00XiZ3ZgKSOFriATadggJQOaGn/4S7LMdcifZWayFZqWQ1busZc6d79H1nLYwz3A56/N8n/WeNdqehLegyKLZjPdfboa0zbxMNJxyN2r07TEo7Ks/ZUxBNpg3uYdiShtLosta+h48Ngct7lL0mGo/hqyiiuMQy65v0975zvkWZSOcFs70jpsOTLeoK5kenc+uxFeQiLbfL4CblKH9u2i+a1QL0ktfQ7iW3K99X6U4S6/h0MjkfGM6XpnFgCous7DA7FVMWdxemMUvuAjf+cLDKEqDGCsnVo7Fg0ikJN79Tv7e3uC08Ge6eh6lcgPOrSF3VZpmXSe2Y5nfbFgXHGPQujf9cwnKzskaW/URD9yDkix4UO9jBm8q4MaCkr9AJwj7Zs7CHEepeD/Ab6U/tr2vm1wzAsazwN1kIbf60LdX5KOS5nZUc5G2HNaVs3PshM2pT9oOQ5atK+KXOyABMs+28F/4F4kRtfLpK9KC1zO2Yf6j6qI4YrgdrAUwOd36zFIU+3TGHqv9lpRC0IgGWYnf/GzBW9VP4FBs/EA0xcr73Pe1UkLZbc
 FbgMLGMg
 cr6dbZgm0cHXst4ZXWvXjloyJMyN2NGFNozWZi9NPpIUnS84ldPpWRLsYKtCEiuehAWDCWmhdHlYQdlj7Nr9Te2AT3/EuwoGFt282dbXxVr7x60EdcspdbsD1F2X56F3OEvOZFfqXbxbfPfGIhN0yuUIawwC0H0Bqn59gxb5vzE6fYE3ADxZV6j/h+zSwybSq+1KV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the ->huge_fault handler do not install a PMD huge page
mapping if the huge page exceeds the boundaries of the VMA.

All other ->huge_fault handlers have similar checks and the
resulting mapping will trigger a VM_BUG_ON_VMA() if it ever
reaches copy_pmd_range().

Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: stable@vger.kernel.org
Fixes: fc3bbf34e643 ("drm/shmem-helper: Fix huge page mapping in fault handler")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index c989459eb215..00807039f8d7 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -597,9 +597,13 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 	} else if (order == PMD_ORDER) {
 		unsigned long paddr = pfn << PAGE_SHIFT;
+		struct vm_area_struct *vma = vmf->vma;
+		unsigned long start = ALIGN_DOWN(vmf->address, PMD_SIZE);
+		unsigned long end = start + PMD_SIZE;
+		bool in_range = vma->vm_start <= start && end <= vma->vm_end;
 		bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
 
-		if (aligned &&
+		if (aligned && in_range &&
 		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
 			vm_fault_t ret;
 
-- 
2.43.0


