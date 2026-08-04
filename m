Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60BCAC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425BE6B0120; Tue,  4 Aug 2026 10:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD166B0122; Tue,  4 Aug 2026 10:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A706B0124; Tue,  4 Aug 2026 10:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6EA66B0120
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:49:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9311480134
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:21:07 +0000 (UTC)
X-FDA: 85063496574.27.930C5DC
Received: from out-163.mta1.migadu.com (out-163.mta1.migadu.com [95.215.58.163])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE8A618000D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:21:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TGkVHhF8;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.163 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785846066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2sUfUtBlTrxznqbjUXb2OOf/gmZXR4ctuPKgvPoVXf0=;
	b=lcgCJ1xMrldjDps21kYvI2iPopkwAyosFK7uIMh0TljdZwVdyuFQiaJXMzRREigJ+ZP7yT
	7ahdag8+0HbEbPI7yh8IuFLlSMno/SQ+iaXp33Qq5F+UYKYOES0pmpmCNypOnIsOvNHzAe
	Mp43b5nZFMueMqGDHDjIQV/8HpAI4i8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TGkVHhF8;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.163 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785846066;
	b=8poZj5qWzrZZZkadFvM5OA9iwum43xHo2xe+TU1PWj+ypjQmW1y//OPJfPz6zL6eLddmkt
	VOPHIduFs5xJM6plYIEAoOddx6HNoHrT/YXTfkcesXZKBg4tezp/XcPgPPUimuB3ZoTOnR
	hh78TyyE+7USvtWgjt65h5/L4zyLym8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785846062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2sUfUtBlTrxznqbjUXb2OOf/gmZXR4ctuPKgvPoVXf0=;
	b=TGkVHhF8YYdSRTNBqyi/ZBaxf+Ijgcmu0ex0JOCEKNtRbQn+dIAwivlGIyX6KFGkvqeAnR
	AjHauDvs3Kzm/TUa6pi/7E79wDikBv1tyzMwlLRjkOrWQelV0rajHHggD2M7ky2Xr6UJHL
	M4lVUITZibvR6Zmv5tlYC8B7oCq/rXM=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Ge <hao.ge@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Abhishek Bapat <abhishekbapat@google.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] alloc_tag: fix undetected compressed tag overflow when profiling is disabled
Date: Tue,  4 Aug 2026 20:20:38 +0800
Message-Id: <20260804122038.190270-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CE8A618000D
X-Stat-Signature: kq4honzt44yqam91ycumtwoux6gangkf
X-HE-Tag: 1785846065-800370
X-HE-Meta: U2FsdGVkX19F4+juTLFUdjzr46t2t9EpzvDrw6UuPEsatPBlZFULnkNA4JKQ2tLTpqKP7m6ol0WXgOS7xQfeygXwdXQWJDYBCTQ8ppxCWdpu2DaIi/KU2RDKkPK6QxNwtlf01/H4bubcdGl4b/jTAbWBVejuz5OtOtV9MM1KUUZv4KaBPAIVDOdyvBKT83YsjBwQxIHhosYaTdMd+SIS9CMACPvstRzPgb7bQzfSzycsc6GYxr0YDRFYwoxRfY+DzSrdtn3tMWkpxgOS6QyHhGcRlo1lmxH50IZPT9lBGKI8yNhj/Jz0qDSzKHNsLcimSOwlJP1TsYL/Tainv2ym2ofO7uT669IZI8hAhJcBd84Z4H0U7U8TcLRX1FbwLa/jldqCcK5SW903b/GToW0Q6WyjTqi7t7yl/5J5FFLIgaB+SbuOrtXOy9HWWh4ax/mngs/Z5Sn6v+LrBF4MdmEAPAPw0vull/vk2smKUyKbUFTNOwPsvgJw2F3xbM5GESvsqPeyMYtdMqkvFueIHcotGoqfgenDjpuiPWF/6w/Mk57hB3cqFQ1vKTvms2UBk0jGv2Q2zb353mMSqAyBGV2Vj2lbuCvMMQpERWlvpNVBUCilwi214k6IA7TFKRhWzVFyycdCshwedRdJhmjVJW0rsNFnmvgJ+RSmIAIA3ntp6FVQZRbLigcclepb5DJz7rV5kY404QDB++4cp4MLvVZxjVCOpLiJp4WLOARv0P7LpomkoXWpKxDQZw6I5JMR1HuSLhGGJHBQGBiaLSdE55Y5wIuKl4GRZ/MXo9164iWDgpmwduKqV0a0VRv3nFGFrA5VlStMuY1u50Iy+Uw3B0X641TwzypojhVEvIqoCz3aew+rBJzN5rqOKSlOnLbKavQ8Pzxus+9iuKQiZGO/gNoKHkQceGTnknu5JCRuRoqnXNg5ctFUVRUWckTZA3H5H2qxSwAt5eC/5ihHokt6KPa
 ETAjlTOE
 wwTpmrBE83PJqDktlphprRgekzIHOKBwVtFVzYth9r5ByzHugx8ADT0EIvIOmdLpSJy0/g9Y+6QNBsKjILhaHhLRLG3SX2NrnqcUm7ax54vHfEn8ugilNGOV8O3CPQjDw4Ev3sCDrdDveQ8DER37yewcBAm4EZ7AYzcVSQpIweanb91e66McW+p14p8VvnoTa7KVmZSbztJhsz/UEqWvrGFfDQ39fbiYk6JwcbNs7+VoQY7Y0Ujz5MDIvSmZR5V5DBqNESbzwstuYxDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In reserve_module_tags(), the tag overflow check is gated on
mem_alloc_profiling_enabled():

    if (mem_alloc_profiling_enabled() && !tags_addressable())

If profiling is toggled off at runtime and a module is loaded whose
tags exceed the compressed-mode limit, shutdown_mem_profiling() is
skipped. vm_module_tags_populate() still maps memory for the tags and
the module loads successfully, but the total tag count now exceeds what
NR_UNUSED_PAGEFLAG_BITS can address.

Once profiling is re-enabled, ref_to_idx() computes each tag's index
as its position in the alloc_tag array. update_page_tag_ref() masks
it to alloc_tag_ref_mask before storing in page->flags. Indices
beyond the mask are truncated and idx_to_ref() resolves them to wrong
tags.

mem_alloc_profiling_enabled() and mem_profiling_compressed are
independent. Once compressed mode is established at boot, it stays
active regardless of runtime toggles of mem_profiling.

Remove the mem_alloc_profiling_enabled() guard. Also return an error
after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
the mapped pages would never be reused - shutdown_mem_profiling() sets
mem_profiling_support to false, so no future module load enters the
codetag path.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
Changes in v2:
- Return error after shutdown_mem_profiling() to skip unnecessary
  vm_module_tags_populate()
  v1 link: https://lore.kernel.org/all/20260804064408.105033-1-hao.ge@linux.dev/
---
 mm/alloc_tag.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 52aece27b00e..d8c36430f1c0 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -904,10 +904,11 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 		int grow_res;
 
 		module_tags.size = offset + size;
-		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
+		if (!tags_addressable()) {
 			shutdown_mem_profiling(true);
 			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
 				mod->name, NR_UNUSED_PAGEFLAG_BITS);
+			return ERR_PTR(-ENOSPC);
 		}
 
 		grow_res = vm_module_tags_populate();
-- 
2.25.1


