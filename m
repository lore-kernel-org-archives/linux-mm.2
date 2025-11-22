Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F03BFCFC539
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 18:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB4E6B000E; Sat, 22 Nov 2025 13:30:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2756B0010; Sat, 22 Nov 2025 13:30:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEFC06B0011; Sat, 22 Nov 2025 13:30:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4A76B000E
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 13:30:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44B338A468
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 18:30:06 +0000 (UTC)
X-FDA: 84139082412.28.9304FCC
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf07.hostedemail.com (Postfix) with ESMTP id 65A3F40012
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 18:30:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mn4CZRL2;
	spf=pass (imf07.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763836204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lzi5XhSukkOja/rLxys4R+45N3tXtMtHv0ZgIb+J524=;
	b=u+b113UvB38r2re2PX3BYiHHWI6cOh1sLbWuvIAtUbVx4fP5nbCssbus0vETUlzZca5Q1K
	cl6u8MqrUqhY3ay5/XUbdMc88K4o4S5RLAmUPuLhEA4aSrb9U99LAxDwgckAm/gtPq9hUQ
	OOIE0Fd/nw2brudVu5CxCl1MmRWrL4c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mn4CZRL2;
	spf=pass (imf07.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763836204; a=rsa-sha256;
	cv=none;
	b=wxiQ/BB0cfb9IQBqQepE5uGvjiXrACmY+BY2MIXk3dLizWnGfg4F48SG/CxPaeNcQvmuTZ
	DE4vT3N726tNcIXN5PN6QNP3jBXs/XstR+NVRBPfObNzrlUjKFEU2Z8ZcQGHmNdtegCblX
	YIY52nuAX6bUlvIhb6pIf8M25bpdgHI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=lz
	i5XhSukkOja/rLxys4R+45N3tXtMtHv0ZgIb+J524=; b=mn4CZRL25YqENFPbeC
	zzmszo5bXyD5ImU4Twxaw4QauOcVVtpknuhgWv8997zhNpt/tfjWP/7+xAnSvtqJ
	FDodX9LF3oDGZd9wX8ALhdH/y6xPKiv7j3t/4fMom2tK6E3hwqWOArtOIbLzqpUD
	//96jurS2czrCIjSCqei8tM90=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDHm2QMASJpWaXTCA--.28911S2;
	Sun, 23 Nov 2025 02:29:32 +0800 (CST)
From: ranxiaokai627@163.com
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	changyuanl@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v2] KHO: Fix boot failure due to kmemleak access to non-PRESENT pages
Date: Sat, 22 Nov 2025 18:29:29 +0000
Message-ID: <20251122182929.92634-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHm2QMASJpWaXTCA--.28911S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr48CF43Jw4kJrWxtw1rCrg_yoW8Aw1fpF
	yvkF1jk3yUt3ZrXFnFv3Wv9rySqws8Cw43Ja4jvry3Zr9xJ3Z3twsYyryIvF1UWFZYgF43
	ZFWYq3yrur48XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pin2-UUUUUU=
X-Originating-IP: [117.176.242.91]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbBEBoOTGkh99DNGAAAsy
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 65A3F40012
X-Stat-Signature: w7qc597m8e6yia1ej5eaqitbu3gx45us
X-Rspam-User: 
X-HE-Tag: 1763836203-940142
X-HE-Meta: U2FsdGVkX18jmoIFC7ESPg9qFlWcpIXmq/Gy0NpMf0xt+tYMbXSzfxufOlUvdnSIDxCqxXvJLdBCB05urCAU3EUx3pKY8EXyiZYpzbmlL2BFX+wXQzxzIhn7F3EWdOAwEdsnj9EzfQwBSAAv2+rzRmLjDaRmVZRkvu2ZGh6PQ/iyrPa0LAcLGvqJ3SgN/EPL2yfmDrtxzu9n0xRpBGN8H8mmwbv3Xay/DZUODcNmZn1rXcGxl70eMVLdBx5KHewTRLH+7xQDObHBp5+1alEfo0MBPZ+aXD7tIz6VkoTbHdSyWLtCU/30UZAME89LE2Z/yIHrOcJ8R1YTAwsaG3YvKFAH/be8tLyk5uhPd1uqjq4SKTkwNcc5yviUcKOoHDTZSDOBPLR6DvGwDquUUyWYiqMS9FhaT9T2OhlNbcv+ifa8jF0XrD4NYCvJz/IWxjCO0tTz9PP9gyHCELSGJrsa/1/s6CgftpYOu9AWevNoSHzsrqRejUHmwA0SXGW9fySWxCIH9sM93A/DlDldMBi9QdSCfbCAERQtEOHsw0HLCVWZ2m3Dn17Gjquc5uTvUCUjRq6ZOybo0yPYfAboLkm54YJnWhubjm1J9nZIm8UXW7FTTjrJHzSkFn75PoJVMo4kYT55FTtw/0hz35mjtt5Y9Z4zXndYoEf3HaEHvOOKPelKq9SKv3n/OdvpPoMAPVYQPiehTC6yT/rCeBfuFpnWmUR8VU/2EcIp2wTvyKaYbgBOOb+iMsX+RQLuUTPQcWOPlqcg7hik5i5X6Tj2Qw5sIlIxLufGop8Z7i6nWNX2/B5UuqBPEJduBUdNoSkeTO/CMDk9RJ3wnvQzq5brLpOUNVMWJPtKT78XqW2WErfspJqN/uigHV/+z1Z/klsC2hn9ATg75tZ6ZE4tCiKZL32SqWqbyNHyMXVQ5FwDh+Z5BL3ZBy3biThlOMnnxf5FcBDevGn4IYHsQCdoh2eZJ9r
 lYMSuWDR
 y+zqdyYcDNeMZMp1kjVi707WfSYFbOuj2CBEZa9k/wpr/MOIAMlO/NnXD+IhlPWVBAWBKvFrUOPtV/l9zABi+MT3gViUSfLrIQNXllRpt5ATqYnvmwchuaFyL/+gECTSdJSVHc8v3FGMFb1m/snnoHSesv+k1a54Qr1TJs8cmQbeTyAtoRaJ+Py3s5HOrLBvHerpVnSRgfxf8QGegTzeIBQ4meYDQ/AZUyZLDJIEWMU+CN26rHOk0sD0ESV91DXsQ2Pavo/7zHKXHrhZysQN4LXjvRbwPWl3T4u7dUoK1pH3neFB9bXQKakdecg9BSZPMEDPxREgqryfNWBTiXlR0Qgo+AK64gMcwsXzs+WvEzaPmg2CODwVRovLPkt15thh8+9/jYkLrLZGl0QKt/JMY3SW6wSEU3aRVvGDSWwJ9yxdrmBzSC6EYT1na5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

When booting with debug_pagealloc=on while having:
CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
the system fails to boot due to page faults during kmemleak scanning.

This occurs because:
With debug_pagealloc is enabled, __free_pages() invokes
debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
freed pages in the kernel page table.
Commit 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
triggers this when releases the KHO scratch region calling
init_cma_reserved_pageblock(). Subsequent kmemleak scanning accesses
these non-PRESENT pages, leading to fatal page faults.

Call kmemleak_ignore_phys() from kho_init() to exclude
the reserved region from kmemleak scanning before
it is released to the buddy allocator to fix this.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 kernel/liveupdate/kexec_handover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 224bdf5becb6..c729d455ee7b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -11,6 +11,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
+#include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -1369,6 +1370,7 @@ static __init int kho_init(void)
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
 		unsigned long pfn;
 
+		kmemleak_ignore_phys(kho_scratch[i].addr);
 		for (pfn = base_pfn; pfn < base_pfn + count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
-- 
2.25.1



