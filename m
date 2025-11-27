Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7224CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 12:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60266B0027; Thu, 27 Nov 2025 07:27:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37B66B002A; Thu, 27 Nov 2025 07:27:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75096B002B; Thu, 27 Nov 2025 07:27:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3F156B0027
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:27:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C86952501
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:27:45 +0000 (UTC)
X-FDA: 84156313290.03.9DC04BA
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 67716C000B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:27:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gAnweojt;
	spf=pass (imf28.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764246463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5RbktsfuLErXNRL2ozcCIVf4lkgY78kG3x/0KHQBTFA=;
	b=M72cKcoYDD3tOJUhzhn3BkquSJheCdNsGCGcpL0A1huYtv3gXsW4lPLRSXjQE6FEanAs59
	udUcBcSDPY1f4Rxq0aM7vSAO2PYtF8CmXdPEj0FRB/CQBUaoiBkhCYhry4RJcwrbz5/MEr
	Y/emjyhRCvoZWSyu74EcHYkS8crkfXs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764246463; a=rsa-sha256;
	cv=none;
	b=agOFHatyFe6Df6Abe1EP0WGjiO3d7+xKLHphsvodM68XtKkMANUpZ29q9DrNKjGp1ViEW+
	9xNg3dbwMoqMsTfgRgueWdwgqGE5us2jRZ+enQJBttJzw94rnVh7TYVNqXPK7jlJdmT0zX
	3D7oRZIx4spbt+1gx8SdpjBvCzXXjVk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gAnweojt;
	spf=pass (imf28.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=5R
	bktsfuLErXNRL2ozcCIVf4lkgY78kG3x/0KHQBTFA=; b=gAnweojtvdn39maxnJ
	Xbw4H1WjVl7mHX91s0G01F50JP0XedAi0gxi5ZhJe46mP8ps9OWdRUa0YyzDd98T
	aqXrM+ybex0txGqzfe/vbRutNoZW5tXnY6cJOOk2RfSQcN2wo0niV+RS3P7yzqge
	Po/Z7/pmVrPewN8nqMDyNuKgs=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAHL8qbQyhpIwGSFQ--.45778S2;
	Thu, 27 Nov 2025 20:27:09 +0800 (CST)
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
Subject: [PATCH v4] KHO: Fix boot failure due to kmemleak access to non-PRESENT pages
Date: Thu, 27 Nov 2025 12:27:00 +0000
Message-ID: <20251127122700.103927-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAHL8qbQyhpIwGSFQ--.45778S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr48CF43Jw4kJrWxtw1rCrg_yoW8Kr13pF
	yvkF1jyws8t3W3WFsrZ3WvkrySqw4kC3y3J34DZry5Z3sxJFnaywsYyryIqFyUurZ2gF43
	ZF4YqrWfWr18XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pin2-UUUUUU=
X-Originating-IP: [117.176.242.91]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbBEA0QTGkkVSOLfAABsM
X-Rspam-User: 
X-Stat-Signature: z66knpbgys9gtcqymmjzygr4btpaubdp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67716C000B
X-HE-Tag: 1764246461-275585
X-HE-Meta: U2FsdGVkX18lNpFbhbB3QgyMDQ+WjNx0Av4r22PmtDawcSbp0KxTz8uvlQ5RCiyCYyZhFbw4dDSbE5V4ARO7d0mR44PE6AJ13hmEeXvg9KYFWVwGAYWAGHzDhbo4QuCa5emLQZiVard3j561BD2wopRLTRBbfZtjTkw7Tk0nKD2cd8vZk/kueFoAIS2Edu4pRtGytvbjpmBJFc5N1MpH0HJ1XWDX4L9xinVkpEJ52zBbPnIj4HsMKpVIvngWQPhmTGOxuh4IhXsD/K4gXT9DakChKoyheT7jNsLkCU/RsKkbsxmB4XFL3VmBjCOOY7+rH6CjiGaJj460G5akKNV7MlyJHshczMn9aqK7PSiGxgm0lzRmmfFcde1IMogAx5CMJ3rI9cEKnyl2FYeLDfE7/PUYxtjIO83SmBTBz+jWDoRzJ59kB5HH913PTWM+wYCQuSfpFKEGvoY0VCkLhP/jqNFJlGL5vvXYs4NmaQtO60rXIWY3uPmMo5dJPpX+ESBsdB0ZSGO9mGPyfOTUd10/dGX4EC82yZJFKOS9nOZuEZLK+5SwJjr7qWgomTKznCt0BftCDJ6TRNdE4yz9MSBww1+2itxqp+AcZeAt/ryFwrKm36XtTpoRSn8pshxgFqeFwyRB8QBN0GA0U25HXUK6I7giVQT+Rqn/lQgZL63jWh3WT9BXYgN1UwqKdt+9e0sX2rYngtMwy1wTKwVh9a22POwT2UPjv6gEGqL1o5mHeLYkOmoO/X+u1lRay0nqf2giZa9uBso/2BqqpWQQ2tcFcAuvhqW31E2hJVveG2S1anrvEAHZGMujJ3rawRuyE3qAO2FBCCfpUKeKp5tBCO8ShhZfvexqJzivqkKRCRLZ6s3oKoxDPAApE5Qbf/a75CBoFeyVXKjYrn6f7Qqe9demeu0WxQ6+OtpOGT25gEzu2eYJF6K5LkxlVlGAwZ6Nt2Xk8IJMrVkkSFQISi2ojQP
 /zdHndmY
 OQRD8oBYRYxlQ7XDXtHxdEEcHPQ6m/sLmGWM9j40w9K4NH1NrNjCrLcCpjQEU88/MfdDORCJ0MMgQbt0FRrJajxGVe5wLloXOHX2VSYUcj1aPZmON08K0KE2OXbDrOICPqhQFpUJIi4Aeto0sIn0fHthap46dWXu6n3mlNnWCOE92yKILfSEUztDwLSTz84/LpsTDP2OfaoG1bdwv7bCpoOKa3DeUe6YazNlnAUfp6YuVZDg4X4cMhkY2WZ7i4JvXlWr3DwBKtkx+peu1pYj0N6sN13A6eCH068wjpyepoPJQKeOshn7lUEgah/Riq9K07WUfRco5nJUaGIWz7QhrJN9k3ThgyDfWxnugiBe58sQxq921PyK4vpujoPrT4G7SLJ59F3Z44NI9UhTwJzuNObHRFE0Ux5jFGXU2ld7KR2je5f0=
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
 kernel/liveupdate/kexec_handover.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 224bdf5becb6..55d66e65274f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -11,6 +11,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
+#include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -1369,6 +1370,15 @@ static __init int kho_init(void)
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
 		unsigned long pfn;
 
+		/*
+		 * When debug_pagealloc is enabled, __free_pages() clears the
+		 * corresponding PRESENT bit in the kernel page table.
+		 * Subsequent kmemleak scans of these pages cause the
+		 * non-PRESENT page faults.
+		 * Mark scratch areas with kmemleak_ignore_phys() to exclude
+		 * them from kmemleak scanning.
+		 */
+		kmemleak_ignore_phys(kho_scratch[i].addr);
 		for (pfn = base_pfn; pfn < base_pfn + count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
-- 
2.25.1



