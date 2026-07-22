Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6BA9C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 22:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97EC66B007B; Wed, 22 Jul 2026 18:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956EB6B0096; Wed, 22 Jul 2026 18:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C2F6B0098; Wed, 22 Jul 2026 18:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5894A6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:56:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFFF41A034E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:56:12 +0000 (UTC)
X-FDA: 85017922584.16.F30E88D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5246740004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:56:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZPkBpSIy;
	spf=pass (imf07.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784760971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nnwsPKVbi4DvaYV8nWWsvMkgYyamzu5KTWQUU7aAxNA=;
	b=Q53ALgwHyMb5GW0CEWacYrojYuGBbqfJLX1utYFVaa6xDBRq+JklMK5xSvifD6OGEVGCoc
	FCsDfHSeVkP3C8yS7xfejM1tLLFjYY4gV7z2Ia8HxKognczTyMySsf9JIR66s6Hkt3OnBc
	reia7hVJnPCxOBfZ/sl5Rpw0JaoDS5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784760971;
	b=bxEcdT9cd1eAmqrYulyYdM4cMLG+h7VOhReB4yie63CLv5Ra2Grdl2PiTbKNTMKNgW9ekk
	Ylz1IvIlHlsrxhEC6r1ZW37X5EIcyG0CDRuwPRd2vdgQd5gJ0wyb7r4Kpz/HSL1VMhE7B/
	U9k2UvazorFUV6+vz3lVMVH9SBcZ7uc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZPkBpSIy;
	spf=pass (imf07.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B38C2600AB;
	Wed, 22 Jul 2026 22:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5E81F000E9;
	Wed, 22 Jul 2026 22:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784760970;
	bh=nnwsPKVbi4DvaYV8nWWsvMkgYyamzu5KTWQUU7aAxNA=;
	h=Date:From:To:Cc:Subject;
	b=ZPkBpSIygpo7zwkLCFfrCkN630Q73t3unwq8Ryg3gZLQahZp2q8QHd3pusDqaWtUw
	 c1Ere6dRXFMjYAvUd4fBwfDY9764WDASWOTPEnRvIKayNXrfrzyhJV+PRdNg0XLRJa
	 yznM14j+ZswrRsLK/JeWZQR4glE9mIkh29df2kUcdv5H9qJAxRNPdyCpeiTFpXKY6k
	 cbnzAi712V0pfeO1mVq6hGA5CfBDZcH3REZ5TLkNiN/r1Jg6mnA7p8C+MsItzOuefT
	 ooMHeyX2qXK0WnmukgtbNlsbfnsKdJOmKKE5JBmOhXJGDafvFgQoVHEtRxKuOIwDJe
	 PivPabZFBIrvw==
Date: Wed, 22 Jul 2026 15:56:05 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Mark Brown <broonie@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	linux-next@vger.kernel.org
Subject: Semantic conflict between 04b177544a04 in drm-misc-fixes and
 0b6b1bb28482 in -mm
Message-ID: <20260722225605.GA1910198@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5246740004
X-Stat-Signature: ynyajy4h6zeprn83fd4qpseik5phuqhk
X-HE-Tag: 1784760971-97438
X-HE-Meta: U2FsdGVkX19gstPgGmNbkNIxDW1PB2iylAxtXLC4wnqEDTqRhK4+dmdVV9afMlKCdQGkdrv4mbq8IcV1pNLdBRlAaCZJGB2FNhIK1yiHF/MM7+/yjRQu+2/LG0r5TWzlLzkvz3pT1lw9+kB6hpv8QEajlhjmU0ZN8Eg+zLED2nyhP69wJNkVEyuVn+py7k9zz8PaktKKdwRBZmnJQrGCOx7iAafmClF6dsF/5KSmDsmJEkINU5/d33Jem/SRI/kkkFb/25OtkPwunyv9d7QqqXMd4Q0U6C0mIOOsGnxOuNXjCLr01Bl79rMz1LJVfAI0pq4HJmckDBTV0aOGzigCYzjzF5MRJgt5dF7ycMK2Mtc625/PsCye5F8F5gpOOBx1c/i5xdKpzUSq7b38adbwZuBMfi3sGA8rYdNziR6wIqxzja8vQa5PpO0OxrjHfq9fouuaGzjjiWGHZzNtYF/cWcRmNqvCjY2BKp1yMKr1/wqDza2ElCKdec2p4obVM9dkXwyj/ze40RGRCLQDvmSq5pDC+YpRR3qcTXWN0xzkaP9RZLcQNpiRhaf3QIqo5MltZc87OxZ4eJDrbTo+H8TFuWb05FHpfmGM9ICbvzQbCiwcmtZtKU3PKAweOyuky7j+QFuDd64Gn3pcyRtZccr3HXvYjyE5KtVr2QijkB8nhdHzhi09/zj147Xbqg2R8GvLePb17mN6GA72Sz8FxUBeHf7b2XpH4kpxCt67zpF/vYaADkgJR3i7HT3xIc+fZucHzTBiaK7nNae8+MSybOyrCDQG2RAXHKyaUd+wP3OlJiLyCL3I2bwV14ODRjrO7eoEsVPVPwkaEmZ6tnIBXzHMXDrluNTSfTIHt0VXDQ3uc2SZWtIZn6jOYNTdocZ4Cd4+ZITubvl82lxIMw5itjt+7u8vRtNfeiMpSSucFzSNpvxD43pKjGxh4vSTjUk4RRoLhNS/4pzM55p+bVXrE3k
 1rNYL1Nb
 iAKD4xERdduxawPWyW1WmVrboD+CsW7Pqs1mMuFtMi+PcRZKz5QiWIromXbNvzbN9wD6nGhbk4mzf4B7XMASK6QRyjCtR3Tp6MJUCTOifeZmXI5i2HLLLSoQGAQd4VRMVm00WWWL9dO5PqU+vy5pKKuufZ/mokRcRgL/n0thZnbr6BK01Pudnujec13hqSKmlB5RvdFzt/IWf4NOTfT16BPFssnhVcrD7bmMybtoC4iEU7txgsSwf0gLBADNeSb4+ErPp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mark and drm and mm folks,

There is a semantic conflict between commit 04b177544a04 ("drm/pagemap:
Guard HPAGE_PMD_ORDER use with CONFIG_ARCH_ENABLE_THP_MIGRATION") in the
drm-misc-fixes tree and commit 0b6b1bb28482 ("mm: rename
ARCH_ENABLE_THP_MIGRATION to ARCH_HAS_PMD_SOFTLEAVES"), resulting in a
lone instance of CONFIG_ARCH_ENABLE_THP_MIGRATION with no way to define
it.

  $ git grep ARCH_ENABLE_THP_MIGRATION
  Next/merge.log:Merging drm-misc-fixes/for-linux-next-fixes (04b177544a040 drm/pagemap: Guard HPAGE_PMD_ORDER use with CONFIG_ARCH_ENABLE_THP_MIGRATION)
  drivers/gpu/drm/drm_pagemap.c:#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)

This results in an objtool warning (or error with CONFIG_OBJTOOL_WERROR)
when building with clang because NR_PAGES(order) results in 1U << -1,
which causes clang to stop generating code for
drm_pagemap_migrate_to_devmem() when encountering unconditional
undefined behavior.

  drivers/gpu/drm/drm_gpusvm_helper.o: error: objtool: drm_pagemap_migrate_to_devmem() falls through to next function drm_pagemap_zdd_alloc()

Mark, could please apply the following diff to the -mm merge to avoid
this? Obviously, there will need to be further coordination for
resolving this upstream when the time comes but it is only an issue in
-next currently.

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 4a794544b7dc..f00c27edbfb9 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -12,7 +12,7 @@
 #include <drm/drm_pagemap_util.h>
 #include <drm/drm_print.h>
 
-#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+#if IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES)
 #define DRM_PAGEMAP_PMD_ORDER	HPAGE_PMD_ORDER
 #else
 #define DRM_PAGEMAP_PMD_ORDER	(-1)
-- 
Cheers,
Nathan

