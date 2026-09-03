Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 868CEC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932A36B00B9; Thu,  3 Sep 2026 05:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B036B00CF; Thu,  3 Sep 2026 05:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9756B00D0; Thu,  3 Sep 2026 05:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 603A46B00B9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:29:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C52BB803A4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:20 +0000 (UTC)
X-FDA: 85171927680.21.4D63037
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2612E140006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dc6BWw33;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vh6C9475l7fwGbJW046+hBcY6H+bSMsG/gNT4fxLjjs=;
	b=NPCmdCrNn2Q1d6YQG3/2xzbIzHyt7OGJ+JR/031zd2XdpFoAiO9yZ8oAdJJCUxR1FkuFIi
	LHG0UiT7YYcmxTLYL4JUyoi5mgM/IvkHlLCA2hLqMI+aHqC5Z5ExNfWivEJiZljJCN7/x4
	JsW0kQIQLa3phlOIe1qhcDs4gWANopc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427759;
	b=cs87JXnCGN2q9MO6ZM5UBRNZ2JMxiEAP+sg1ar4xFRRrdWYoiCokK5lv2wc1CjICxKJ1Wy
	cdvkWHgDRJLC4G0xyVYFeMT1eerl/AQ0JfzpC6uHPg1MoyFX6pCq2/KSaBJKrkzaJkvlJX
	h3laeD+6C0q8gwvoPGl5iywF88bCxwg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dc6BWw33;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76D51402B1;
	Thu,  3 Sep 2026 09:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CC71F00A3A;
	Thu,  3 Sep 2026 09:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788427758;
	bh=Vh6C9475l7fwGbJW046+hBcY6H+bSMsG/gNT4fxLjjs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Dc6BWw33eFqwAnKvbc/2ePznb+TuDl0/311Ux4UcmLpxp+Q7abEWleHxCmOOjQISw
	 oxCvkgwUnvtbnN1PkSRcDoVvsxlVhC+tVD0ujqYa0LKTnJBa1Lxkpx/clqx1AifPrg
	 89KPF1umm9Vn3HD8boxt8mlCJEBKSPLFszutpFOFbMTY0woer4WLnp/ulHkGjUvo65
	 byO2lSGgdZd2gn6wbRjX2cmc6YakGRyG6RGGlMcDzz4zQ3AjxSuDeNrUrFMYvkfXow
	 Ssj5NCfXrndepmRJnJTTmdkwbXvvAPcREhb15+xSkqIijaAybqP3yKMoF8SGTPEpxF
	 QgQ0M0o4xuRvg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 03 Sep 2026 12:28:30 +0300
Subject: [PATCH v3 4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP
 friendly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-execmem-set-vm-perms-v0-2-v3-4-949b64a9f755@kernel.org>
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, 
 Will Deacon <will@kernel.org>, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 loongarch@lists.linux.dev
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2612E140006
X-Stat-Signature: 7o6h8cpsiwbkciz94hxd3wzooqhbj56j
X-HE-Tag: 1788427759-509803
X-HE-Meta: U2FsdGVkX19xIwiW/kcv0Cexmk+ypKOIEoAV+vnGgvLmQWQk0eiDJf45HJ7c/mGldxa+k4TGvf4sZru2XiuoNzmHxx4u14mZGyv4zCc3uZnTdErvFfti8CbVJfPjQIhEgdBiIZfAUkOWybXrJ+LK+CsMrc08CZpYShU0GI/XI8S2Nm1VEqe0a0OG7+7qTsy8hYpzES3b7jclWFnrU6MTZV0UkxE7ScDV93KLhavUqU9OU7mEvXif6mkPN1P11ykEmCUjJMnMwnuFPLO8hIKXTFmEPvePFFwCx86cGcvYRHfOY7OAuJ7SX99sJeAqGHhADGv8wYM1fs6e6K3Yw69N1t9tQmV1MFVHMjTdTX1rLe9UGNhdzELVAr6pzeQQZM2wnw+xxQFX0xZBH6YUPYZsG/BnwHXKovdzR4fldQaLltYK+czRCNCT6a09G+KrhX+Lk75ybnN2FD1CAJW076AEs1/CX+GJohtmVjfyeeutOHZi8j5DyVLmnpifQhZUzl+AFCwnzbQHu0uzxcV2eC5UEd0Mtims8tO6IG/EazrWSJfa9TTOkx5ByRplA4pitkd5ylOYK5UiDhPeB+qbjrzy8jlN7p0f3TOZvEgFt5hDfxdK2Rod2wOnGXtJdoyX67XwSTU6dM9JXHDP7xXM9TPw55S16m3PQjz8iJFIH45J/E8FmlDOwBfuPToBXOTEVys1n/aAVMiTHqkN1vrEx2HxDYJYPM1NRXJftfynrJqjzGmmIg4qN7mdmceqrVU5JNe/kZncqdjkSFhi+/9rm5caay+WjZ0RVgFcBAiKxbAPf7fllAtTEhTFu/9KcZDLe2CA3BHiLZBg+ghmIUCq6jk+LUTcPhOhQjxXdg3xmxdyuBtLWc6N+yh8MQJB97OH8IYTLybLpneewyexzENQ5uB23rNOgqDsdwbck1CTwe96u9DVTXHtc3Wld32IfKFYTj5m0FdbnDtc+teXFidYQMK
 fLZ60nre
 rpj6vwhQuZUEMkCEJHhADUFwe5QECdlm+uX9Q+P/DTPtqxwvingA4nrAW6aULEXrouz8rbANwwFtQIV33lPjHC7IJ+/Az03GYrhIR5bI7WaD7kE7uAHKuYCWnnEd4qpWhfCN9T25oTe8EV50+aF2tBsda4UpDdPkylHSVXhCyjC/wDemHQfOuci+rKNB0DNuuVX5Xoya7X/V4S3MQTItavL0CcWmKV71feNLdqUtQQa0d23BSp8SC1wBebCZ/NVj67SmWZhKvKbnNvqOm/jnjagJjgmZxtpWZeV6U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

set_area_direct_map() always updates direct map alias permissions in
single page increments.

For HUGE_VMAP areas it's suboptimal. Not only the loop in
set_area_direct_map() needlessly has more iterations (e.g times 512 on
x86), but it also causes fragmentation of the direct map that could be
avoided for the HUGE_VMAP areas populated with large pages.

All pages in an area are always of the same order: either same-order
large pages when VM_ALLOW_HUGE_VMAP is set and all huge pages were
successfully allocated, or order-0 page when VM_ALLOW_HUGE_VMAP is
cleared or when huge pages allocation fails and fallback path is taken.

Instead of updating the direct map permissions for every order-0 page in
an area, use the area's page_order as the loop increment and update the
large pages in one call to set_direct_map_{invalid,default}_noflush().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/vmalloc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5506b180f5c27..6ed6c160abed7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3367,12 +3367,15 @@ static inline void set_area_direct_map(const struct vm_struct *area,
 				       int (*set_direct_map)(struct page *page,
 							     unsigned int nr))
 {
-	unsigned long i;
+	unsigned int nr = (1U << vm_area_page_order(area));
+
+	for (unsigned long i = 0; i < area->nr_pages; i += nr) {
+		if (page_address(area->pages[i])) {
+			int err = set_direct_map(area->pages[i], nr);
 
-	/* HUGE_VMALLOC passes small pages to set_direct_map */
-	for (i = 0; i < area->nr_pages; i++)
-		if (page_address(area->pages[i]))
-			set_direct_map(area->pages[i], 1);
+			WARN_ON_ONCE(err);
+		}
+	}
 }
 
 /*

-- 
2.53.0


