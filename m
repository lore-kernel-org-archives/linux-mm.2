Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F029CFD316
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 03:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB316B0008; Sun, 23 Nov 2025 22:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BC66B000D; Sun, 23 Nov 2025 22:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D85B6B000E; Sun, 23 Nov 2025 22:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B66D6B0008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 22:00:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8872139810
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:00:26 +0000 (UTC)
X-FDA: 84143997252.16.D007C20
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5A7EA140004
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:00:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=a+u6cjdK;
	spf=pass (imf23.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763953225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ajBFle3394S63r7o3GjvBvQuiLfN/Ig0/iHFsHDKh6g=;
	b=ymMuc9JF1eQ84X4+WXjfROnp6+idDjrOgA+MJatY/gIdRm9ARys/srqTs4KsT/1j1OChyN
	EZfwBg4NZGsInffQC50byiGgwmT+27F593efqmpQ+OGMkE84O5y+0N2YFu2J/8zK6r2y5y
	7QN+H1jJHjuw0xG/19phZ1fbGe9Wz/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763953225; a=rsa-sha256;
	cv=none;
	b=be7w4bc1K4fAVnxeY5t2G7kVIIyHHToWmWi4eHoDdCdU8TQUgv7iUU5eN+zQ1aMBLYSGXl
	zWRJDiBs0Vo+dJmc8Wp12P1/RRV3ewAZsdauB5c6HUuUsnLSQfxQmQWY/ICYicVUtjWUCU
	h/9DZaotZXWEdSFGOm+hBgD0ClGCHUk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=a+u6cjdK;
	spf=pass (imf23.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=aj
	BFle3394S63r7o3GjvBvQuiLfN/Ig0/iHFsHDKh6g=; b=a+u6cjdK/vVLA4Ky44
	ucKxYdqADV1cb7Ncpa8wifHxd5Q/qhDArIeT7BMS/eIKaAJDXMRHp8AsyhKSfrBE
	ezhlTjXla/J6vhSHDI5o8T/JYCcxB+pxxtEPOjHb1TaFcswZHln3MoMl2VVrBkf3
	s50ncygxqhlBNIdTGTe7vt1Mk=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAnsIUhyiNpPbjtBw--.103S2;
	Mon, 24 Nov 2025 10:59:47 +0800 (CST)
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
Subject: [PATCH v3] KHO: Fix boot failure due to kmemleak access to non-PRESENT pages
Date: Mon, 24 Nov 2025 02:59:43 +0000
Message-ID: <20251124025943.94469-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnsIUhyiNpPbjtBw--.103S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr48CF43Jw4kJrWxtw1rCrg_yoW8ZF1UpF
	yvkF1jyw45t3W3XF9rZ3Wv9ryIqw1DGw43J34jvry5Zr9xJFnay39Yvry0qFyUurWvgF43
	ZF4YqrWfXr48XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pin2-UUUUUU=
X-Originating-IP: [117.176.242.91]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbBEBEQTGkjx-FAdQAAsU
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A7EA140004
X-Stat-Signature: 8896admgbsx7fygso7wkgfbbgtm7qcuw
X-Rspam-User: 
X-HE-Tag: 1763953223-805359
X-HE-Meta: U2FsdGVkX1/CGLCEPX1hCT+huSEAqOKnnkCBnipXfanHUnKGP8ff7/uUF2zOP2W+rfd2eGikHonxeGGBSYkHZ8xIaeC0lvVDxeQQSrOfIF087IHIekbgnLODUaePSuJobAtxrTlVpQYs+UsCn9cdRMxJ+rYGwyv27WfcnA6BIpUp7C7EQNS8N3war+ho57AW9vr8UbrUrGPuOaUKmFZJxfq9U/QV61xSkQFkQCdqhyty7JCtqisQJ9I2jx1bPJyLwKemCqANMD5y3Ewa1p9z8BN8Icd3dhZ/GPyok/hGufC7kEq4e4/0gs2C1lql/nrZupWjLRrRTRS3oCtov1y3BU23vi36uCxwkWCl/FSrCJr+muKSLe1oGcUukmkBcxOKoxbQY3hPK/DDFzglSRXiJqwdmuDbO5MIS+82w5VbpkezprGuE/Vf7KLh79Iw7myRnToFayI78xzE7J22jPdzAE7Mu8T19ZgqEHBw53dz+kRVxUmM/HJqR7o76u/dJozIelSxw8BMnSvhnrmehx/MAtelObVWZBbB2PYIPo9goRB+tooBffNvNkoXYMdXtPqhGG9HoA1J0EV9/KLLayarL5x88Pli/B/X1AGR1UVfy2v051YPgken2jQpJkkQypX3mHD3k//WbwtYAMOs/cya1nEgHkT4jHbSKwlHPYxOCtzihIfE5DGAGQBXHRGuNn87Jyp3Kr45uFvNGX6K5orAw/KO4PIylyIu+1dV5Y7LhnJlnP+PmFtg4DHwP2UAs61R741GqyObeFM9nLf2cDMF72qKR5fZFxYLbAMeDRyNuHe2A+l+hQ5pn7X9pDTVu4MFP3nl6T2jLd5T9161hIw5z0s8ryZEY/En5jOp0N8lcqkhOgq1AumN+B4DJnDDnxRVfSfKFX0v1qjGuZXac4Q2vf7XKwZKFP/Af6qRakUsQbB0uMHnG1mNbM4A2TNtXc9zLTVJpdQTLjBBlt9YI3b
 htaAP+sS
 94fZLilEnXk6NivMUGDXDN0TKBHmHJzlb/uDZaACP5Pj667zpDB9bc8ejaZIXranxd+XOh5hx3AoGrBECjlEXW9MGLwuM93Fn2nvYxzPcLagNZqtCip6I8PTF7Gop4euCyMeafTEls3tpMhXIm4bkwmGuipT/3QFgLuoCcM6mvKM5Khujv3B3oa+O1FNl9CnI6Rv7nYbg8HE/kpUovJnxmdFIqOSPm7nTe8zHJoKS6YoVafeXUDUThhVbEpk5MuzntnDyGk7Qx54lD0qqO82S1XAuYXkcof22BuYv/1oXoOiGg16FpExEBAkOvCW7yOOC7uiFTguUN+bHPJ6VjNNk3F6u0KYObmCMn6p6D8a3Ivf7HdMmhbeZ5iQEsw8ByOy5X0/9
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
KHO scratch areas are allocated from memblock and noted by kmemleak. But
these areas don't remain reserved but released later to the page allocator
using init_cma_reserved_pageblock(). This causes subsequent kmemleak scans
access non-PRESENT pages, leading to fatal page faults.

Mark scratch areas with kmemleak_ignore_phys() after they are allocated
from memblock to exclude them from kmemleak scanning before they are
released to buddy allocator to fix this.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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



