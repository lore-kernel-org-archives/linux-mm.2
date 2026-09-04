Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090FCC61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 02:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D306B6B0088; Thu,  3 Sep 2026 22:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D086B6B008A; Thu,  3 Sep 2026 22:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C460B6B008C; Thu,  3 Sep 2026 22:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1C506B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:51:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 814AA1406D0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:51:23 +0000 (UTC)
X-FDA: 85174553646.20.1F2D302
Received: from mta1.migadu.com (out-116.mta1.migadu.com [95.215.58.116])
	by imf13.hostedemail.com (Postfix) with ESMTP id 90DC720002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:51:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gcks6LRn;
	spf=pass (imf13.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.116 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788490282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ascp5NYA1knU/Tz2E2qXWiVQS08FjekVudivbuxitpc=;
	b=IRQCAEV0Ls8vYBmBeuw/naBdRxZXAIyzifuDuQUFV2i8URn+AjvS8ke6jPk5j0seQrXjr8
	oWwklN7aJJaBZzMqFx39NS2j/onuvGMRkmrb4j2K2Euh/yFGxxVFDpN8iPX+ORsjROBb9g
	A+j8utBTyRPHB70ylwZwpq3Yo/5YxsY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gcks6LRn;
	spf=pass (imf13.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.116 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788490282;
	b=YSLMqy4a/J5QEySKULdcOcoPGYXWV7fEsJl1clvETYGXI4UIXkFqPsAC8icUM8vLdSWKEI
	EIkhfYI1HAG+vTN20CKMi8cdBcMfjA+QOYoeKpgM13oFWHbDavTzamdRoz124+jVV0p7P9
	PuTpWbbfeokwZT+fklQSjwvD3jTMawo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R8hp6kP4f0zaqRkny35jyzu+c4C1uLJKHJHYlP03c7k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788490278; v=1; x=1789095078;
 b=Gcks6LRnqD3FVoHEn4u6xsXUFyG1bsuk3j4ANwcrU0YvSgb5U7CbaQPJonN7AcuKGeSVdnYw
 llssHOWY6i8W1aYxc8Mt3h1A61nARgfw/YDui3dN89wRIUhToNlJIYoTNNDcek8pdXfiabxf90s
 9hpWo+BlMqatfkEWXBaFO580=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0b116a6762a44da4;
	Fri, 04 Sep 2026 02:51:18 +0000
X-Mizu-Trace-ID: 0b116a6762a44da4
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: graf@amazon.com,
	changyuanl@google.com,
	akpm@linux-foundation.org,
	chenhuacai@kernel.org,
	liukexin@kylinos.cn,
	guodongtai@kylinos.cn,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] liveupdate: kho: calculate per-node scratch sizes before allocation
Date: Fri,  4 Sep 2026 10:51:01 +0800
Message-ID: <20260904025101.9959-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5k87kmpz8snqtfdaix83i1e159mfhs7h
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 90DC720002
X-Rspam-User: 
X-HE-Tag: 1788490281-148601
X-HE-Meta: U2FsdGVkX1+9hoogBM+0W+rHraQXLmE13xpZjlQ0cpeNxRxaJP/fYT8I8261B3WAow+C3J+aYYgjUf95AT2Ic0jEVUW7fjiPs01KWnl5gHX5x9+sJFB97FjctIY3oT4hCpGKMwauUIBP3qslx+YMSrUpTprx17aNw2sbPhLKjiTCZDKzKIBUZcHXdDpmCWISfHWRa8Y2JJcemn6Pc5DRuYDA0Rz3PZxThG26aYsrtFmRB8ey4Qfn1lGma02eB3NGKddTB9WmrzYEmg7nNmsFaMeHqvGz+BU0zNm2TuCaUaFrfQyhMgBBWiMcXdHUPEHKMbrRVR5luKXoKsJeye3aj9toiGfmCnoHBM0QE+c8+6bL7bj8OS0G+7KVH8vKQmJGchvnR9Gf9kWw+ez9XDqJkZJ1wWfpq0bsA3XkraiPgf9v/vxsdCrAdN2jXXhM9fq9glYVYCfWQl5Xr9Z4LzL5ikcbQutd6RM4xvN+BAGjLABW/Fwi9iOzqxzXnUfbKs3nT+jg+Zh9thEFD5rCtA59t2I+i5nZXXQbnrIeKYxJTbQHfZk6EVTX0MrcS2kcv8BDMR5lMRbi1qu9GsSRE1k+rXrquCvFaSxglsO/TURzKwBBRCDisiNl+ty2q7FC1WNMBlGhTefg0D9qaa5qi3vp9PDhrgVh0YVa35QJICRuD8yGXmuoLQiQZsTA/zO5P8rvwmrLQC0Q0KBxr0tCOmS8Eo35PCtI9Q/v7/U5X1tZElMkA20NuVWIiXIQUduXTFDoTg289INo7xEXRK6EVphB0wWjpZRw2XM0TdJGjLOqoiVbAC9NZN00aBbRExriuHS83QnaJka6Fe2DxeV06sBrjF8BA2HmeM44inCthrHDqSQq9SwVriWxs6SNKsE4droIrbSWuzOb+qWrQCvJjoZ2QdjWlnwMT74X1P4uCATh9yTWdDKxpqz6rYJUvLvqM1c5eSw+BnYcJLtsT+2bEAZ
 mHc0Jwm+
 xUY0FtP3G0eusBya69Zs05PBniV8+uCssUgiFZAqhPSfKjc1PoYknAtqykiQ3ov5T/MxVSfUZBmoytXG6Xh/OXiRUotAMvlW+Q+wDL/vH17rAgV69FuFo2xRtks4lo0xQhhrvOYvpmh5a74v+ykPIwpqLjKYA7mHUmzcCxqYWbYstLh3r11D3DDBJha687lXY3fBx2pacih/BI+FK9suLqWAvqenDZ42a1tyO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

The default percentage-based policy sizes scratch areas from the current
kernel's MEMBLOCK_RSRV_KERN footprint. This is a reasonable heuristic for
predicting the early memory demand of the next kernel.

scratch_size_update() calculates the lowmem and global sizes before either
area is allocated. However, kho_reserve_scratch() calculates each per-node
size only after allocating the lowmem and global areas. Since memblock
allocations are marked MEMBLOCK_RSRV_KERN, the per-node calculation
includes those newly allocated scratch areas and scales them again.

This feedback substantially inflates the per-node request. On a 1 GiB
LoongArch QEMU guest, the relevant reservation baseline is about
98.45 MiB. With the default 200% scale and 32 MiB alignment, the old
ordering allocates 224 MiB of lowmem scratch, then requests 672 MiB for
node 0, for a total of 896 MiB. The node allocation fails and KHO is
disabled. The same incorrect calculation is hidden on the tested 1 GiB
x86 guest because its baseline is smaller and its memory map can satisfy
the inflated request.

Calculate and save all per-node sizes in the scratch descriptors before
reserving any scratch areas, then use the saved sizes during allocation.
This keeps the percentage heuristic while preventing scratch memory from
becoming input to the sizing of more scratch memory. On the LoongArch
guest, the aligned total is reduced from 896 MiB to 448 MiB.

The KHO vmtest passes on 1 GiB LoongArch and x86 QEMU guests with this
change.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Reported-by: Kexin Liu <liukexin@kylinos.cn>
Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 kernel/liveupdate/kexec_handover.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 7c4d86daf86d..39f489a258d9 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -847,6 +847,17 @@ static void __init kho_reserve_scratch(void)
 		goto err_disable_kho;
 	}
 
+	/*
+	 * Calculate the per-node sizes before reserving any scratch areas.
+	 * memblock allocations are marked MEMBLOCK_RSRV_KERN, so calculating
+	 * them later would count the lowmem and global scratch areas as kernel
+	 * allocations and scale them again.
+	 */
+	i = 2;
+	for_each_node_state(nid, N_MEMORY)
+		kho_scratch[i++].size = scratch_size_node(nid);
+	i = 0;
+
 	/*
 	 * reserve scratch area in low memory for lowmem allocations in the
 	 * next kernel
@@ -880,7 +891,7 @@ static void __init kho_reserve_scratch(void)
 	 * memoryless nodes, as we can not allocate scratch areas there.
 	 */
 	for_each_node_state(nid, N_MEMORY) {
-		size = scratch_size_node(nid);
+		size = kho_scratch[i].size;
 		addr = memblock_alloc_range_nid(size, SCRATCH_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
 						nid, true);
-- 
2.53.0


