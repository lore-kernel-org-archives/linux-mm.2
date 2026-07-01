Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57E97C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572626B00AB; Wed,  1 Jul 2026 05:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A256B00AC; Wed,  1 Jul 2026 05:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487606B00AD; Wed,  1 Jul 2026 05:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 283186B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:07:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DA801402A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:07:11 +0000 (UTC)
X-FDA: 84939628662.12.9433830
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf12.hostedemail.com (Postfix) with ESMTP id 904A140005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:07:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Mqb3R76d;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896829;
	b=1abW+nfMXECzUaZzyDtc+P4xn7dsgavB64fXwJhG0jtfzaGiZTeRXZ3HHLMCI6R2cWzCgA
	TyjoKPOI5eypsrtOT6vsYiAFCiCMa6kYOyox9E5gW+jza0CN/MZy7O6JGAyeyxWnNYYVrP
	+tHhBVQaJnMm08K9fg0u2Eb/yYOp45U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cw8RUZDrbGyYvSpodoREqJP0rpdEJgSnGPHDt2WkK3Q=;
	b=ZdQLBp3F92g/gCSB47vl31VussL5ryrBhGkJBW4z/lIT5AvIv0RkZEHVCGAbGCS5pxOqTn
	D6ly4f60Z5lyJIBhKjvW3hqh22Zp7unR7uznVf0/9rj+xkCSSvSMoWxLvp71ToZhe//bBN
	bFdm4wG8F5kZ28UduyBKTPSHmCyDcr4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Mqb3R76d;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782896818; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=cw8RUZDrbGyYvSpodoREqJP0rpdEJgSnGPHDt2WkK3Q=;
 b=Mqb3R76dQpFbz1sAcY3QZJQkgTUu7KG5zM0ZTQ1hHxooGdmvTc/DZZvk64vv2KlrrqQNp4
 spZT0LBo82PwaJxEOrniLFBswpHPiu0aE3f/AOJeBzfH29ocb+Vicvyl+fQzoDdWOhKAfR
 HNQP5dkOG+vDGwflGJBeaNxm2BQMtjpjFkDEMk6/JgacSYqWVLvxoToGas2QB4CDqyn/QF
 Kcz2zVI3DQ64biaqOfwedtRWp2VSqMbXPX+lk1UfrURvt9oD491spJVstfwFWwNHVP1Hxz
 Fpturb1ZmylVmu0f2VhATTLFxGTJNSTZeiERCPcX3KXmtqMsnXSF2Kd+jlVSJA==
Date: Wed,  1 Jul 2026 17:05:46 +0800
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260701090553.62691-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a44d8b0+28b1e9+kvack.org+lizhe.67@bytedance.com>
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v5 1/8] mm: fix stale ZONE_DEVICE refcount comment
Message-Id: <20260701090553.62691-2-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Stat-Signature: hhzq3t6ppnuhqxbbpu459m8fmzfpicz8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 904A140005
X-HE-Tag: 1782896828-633031
X-HE-Meta: U2FsdGVkX1+RgOmsxdkNXzson95Is/0CW0D6Vb+wggp9mNG6lLMD/5EEhcEUgKyKg9OHSyaCMheMDlb4m9mS0nKWej4KMYjqAQrq/Wl+/BjdR1LHeS57nt8zlbjKvuMet+NnO7qIFcuGYsOvEYIA9OU06uClNf5NTlGCV7vlswDsGJ4RnJIPNcub8Ao3uZsijhDWTxdgPTclSgidHj4t2tSkmweKvkfQTYUF89lGJ1G4ONpVuSrwpURGHhr0u39bhrqhdbmlWlNLyMIFVo7TTqfw4Ozo5oIXZLUJuDlNqXI4tpeyt7GqFu4eNH7l94Q5ReSB0QfFm+YNhd2RLrdTlA2oy5kn9Q2DDdstZZqbiRT1y0nMzi2ZnNBuYp5fKCwoI+MRHkYey2oZnQRkLpxI/xN5CgwPKOmNkBC5In00BWmYzn0JzNZmoNtxjiQIaKGk17Y6g5qGFdujd93QreZXRfm9JqUmKY0j6N5445rbW2VZULz+0lwOuUvtoVPPpD7UhV8djvTfiaJ6vzZoGk+Gb5V/JY3X1e6Oj+zp4SG04ZnrzNLFof61BSZljIeP81HShgz4MwGaa3jo9hhK9sjQP4dL2cBXXs48NbNBQyLa+hwIdluQELYhJ7HL5xZkvGtJzlttkBDHL9WIH5O2uXh6ugBkKnlU5GyxOFGlweMX3aL3CL/COXOA6syI2g+QoqXfywwbyCqaS3TpOMbHAUnx8TIhObjSO28ud8IlFOcUi9RiSG8RU+BiduunE/DLLo8nnaBjzBfaTgHHNmmXrLAJcodGu5Lv8NBy7gzB1WieUyS8cM+6IKTBiuWzrDrvzIZLJfndegNm/EIeoZdE7uoOc21EAeXJ4AOnyZ6mMgjtueE2S6ouDnDXMTessRZ0vZODdALSY7oMJPJglCjs94IITDNxHDpPo956VKRvdo74Ayx3yDOjqubUudo2TI1ecsN3SYbcWGSn/lADFq0P56k
 iSlmZoug
 Bb0ya9KeFLTlBZSrLnRzna/y6W7SUBPAuJIB56CmDJQRz2UgWqoJF34SxKPSitG2+dytNc8GAxo7ljhZTQh4l4/ZRYQ3FkdVheqTlHAoWkznbDheqxsN9h2LCASX79h3dufkNTGxK2Z374JS4gIDnB/DtbqOSZVjNt2Yagjlo4BFs6CD0ZHuco640rCX8oweJuKDDhHikChlHQ0YS1unzIWzCMTq4vGTORszKLHNbzzLP6CfbmdjI2NboQs0NKPGIos71/TKTc+wIGwxhHOKr6FCoaGsTFjv9lGMYyW51Lj5q3BQBbu6zCor2fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment in __init_zone_device_page() still uses the old
MEMORY_TYPE_* names and implies that FS_DAX pages regain a
refcount of 1 in the free path. That no longer matches the code.

Update the comment to describe the current policy correctly:
MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path,
while the remaining ZONE_DEVICE types start from 0 here and raise the
count again when the allocator or driver hands the page out.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..95808ab5cfdb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1030,13 +1030,9 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	page->zone_device_data = NULL;
 
 	/*
-	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
-	 * directly to the driver page allocator which will set the page count
-	 * to 1 when allocating the page.
-	 *
-	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
-	 * their refcount reset to one whenever they are freed (ie. after
-	 * their refcount drops to 0).
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
 	 */
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_FS_DAX:
-- 
2.20.1

