Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8F1105D996
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32476B0095; Tue,  7 Apr 2026 22:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB786B0096; Tue,  7 Apr 2026 22:51:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8EE6B0098; Tue,  7 Apr 2026 22:51:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFFD76B0095
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:51:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 821221409E6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:51 +0000 (UTC)
X-FDA: 84633863622.20.F055261
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B4370120008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j51XMXfv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SWACzn/NB4zivog5DClhDDv8kbwG7s7bDTftmwtAbDY=;
	b=Wslpy0tHYCv8tz2K3rU5f841HlsAS3Ppt/mr1rgQNZVoci9L1RPX8Podrkv5d4scSQ0rKL
	BLj/+YcF6h+9cU3BFOjk+wPOKOlhmFWCXgB/DWU1kmxST/AS8sNUE+sTZZb4YLKhDT0Br3
	int/DN2aqVARS+pFxDsY/MO+gDvUFK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616709; a=rsa-sha256;
	cv=none;
	b=1GIAGZeMbhdgABVDiaeX45Cv0jn/Xv/F72DZ9gz5Ne31Lxlxt5yvlpdR4zfRuywJZSlZTC
	vhdNiY6HEXIn8bKAWZ8tDshkYOGxcTyQ5HU/3ugIwtgkXuMqse9l7KfYisPEBWZUcF7HMU
	bOfB1w/PMBvezQdJJbvvM2Cc1sI39uo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j51XMXfv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D816D4452C;
	Wed,  8 Apr 2026 02:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F78C2BC9E;
	Wed,  8 Apr 2026 02:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775616708;
	bh=ADjBqE0C1KfIyVTZP4SAf0I43MDC/OSOfU23K3IWy+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j51XMXfvi+Uxqq+1/UvQP3n+KERV+0p0XtWw/Uhmkna6BimHQotLAW11I6s5QRSr6
	 0crdor5UZv60wH48QovXiIHoA36Ujapw2ywR0srgEx4fVQ7Fqbt6OmZxnp6yUB6G6k
	 yyJoygwMMFIBaxuWQf3aKwv45lImLjGwWMafowo0YFHZ2LA3rHAM7XvizQqptwU20H
	 eIFEaq9hRfJZgAwFlcEzyVGomeRJMEllO2maK95kgCj7wAE8eD59Jw21DAkW1vTxgJ
	 CNFnpjcC2b94Zz11qOIM2c7yZz83pxIpgYbRw45w3/fAQZV/2ksIOpJPQ505DPR8tg
	 aTa0X/Be3f8cA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	ajd@linux.ibm.com,
	rppt@kernel.org,
	david@kernel.org,
	Xueyuan.chen21@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 5/8] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Wed,  8 Apr 2026 10:51:12 +0800
Message-Id: <20260408025115.27368-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260408025115.27368-1-baohua@kernel.org>
References: <20260408025115.27368-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4370120008
X-Stat-Signature: fx1i3igwqfik8483rjg5m86kt6ow5bfi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775616709-560053
X-HE-Meta: U2FsdGVkX19TfZaqjIXK/8JmdvEWE6uRTlVNkGMoUbgKhlvHTzlq5kvqbBvgXht4orMoQG14o9xFytuPlpEA8/ieVwFQ52wCyxqnbqocBD3IW6y/SMEBqRII37dNuBytWFiOkFkTxCoWgPnviALPI3OHi+IMUSGCvzAVZARFWbIrE8LGnJy09+SqDc+28/5iCkEAcOvCgO9lFEMJaReJAaec16QKwp3FmQFB1skAaox/ndAlEkLT6J/oZBEx8w4ppJXS0JUMXVAniqmGiCUJlCjkdTxcpcxUrsIPm4IJyyi9GIG+KALPi/s6fx58Bf+bPzFnxaPoG74/XXuGPIxQOSp5+dLgZbtntTR2yf2HoIwK1/i9aMirJ5qWgTKV8yqDB26WQNA3ZUrd+QQCMz4dfAQQaPO6+Nn1CdILwLfhUwK9A5aL29wGCiP1aegvqZd6idIMbB32ns23qcwSOd8KSfG36qbp2zGWJxcd7uWq/cBfukk2E+o6XOockmIFai4kMFziyLDOrS2wAdDDQ+32eJoQSwN34SEGtwbcnTB5XMjVCDklxwbwVS6KPBJU/M49gmJoI1gTk1GT7IPeh0Ax3AE4dcNeP3RWSOeY880E+bpyxrj+d8XPT6LhW4yJ3jtgfTk6KrbWBhgBJ3G1FPaGeJWAfHIOAFo/vvDFDdE/xVhfiwM/P6Ozb1f4RqjDTmXSC4AKFYGvPVCbQz79nqWVNYw8O2tjVl1w11VD7HC2eEIj1Pc0AWw8R2HQ2bYma7nMyKivF6iYdrpTDsDIvS6CLMU/AnbcN/X1/m2tloDN62w6zrtJYcqVsHGXGDlQOKvmkeGry2UfHDVDNgZSCHnM4u2Wjt7Clex9rkPqtkFB17O4Pc6sQRyaePxJ25nzioH1UBQxW3WSyQ113abT0djtN+sBKlXDPsIhorKz01cE3kxFDCYOO4LyzHQvywRqzwM14p++dP23TtZJiphhUWc
 hmWSyjYo
 9W5Hc7H7/axZUkj5ZPgVwNVijMeokWOzT9AWHIa84uNnIgdluaEAxfMufGYOiE4HQgWLgJJcVfodrsucWr0ob375bi3pCof2kiOtZrQ4g0iTwHner3nDEwA6HDmzIUtJJusmY9Np0Etjpwm+rVYt8Vk4WLb5ciMvo8WGfQtJM7sn4ERjnVBB0eRMc+8G17JPqNzIOByED6CtKnsfzpMmap+Sfe/c0SdWdo5nJfGdzlSjHySB0zdACX6/V2vDbfv08H8dcX5ntXBvMc1VsUceWmlVNb53CuAxIPDuaafWHJv33yQrH6MuAnJtAsXrAtp4czssmGEdyveB4VBB3iCi1AJTPCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In many cases, the pages passed to vmap() may include high-order
pages allocated with __GFP_COMP flags. For example, the systemheap
often allocates pages in descending order: order 8, then 4, then 0.
Currently, vmap() iterates over every page individually—even pages
inside a high-order block are handled one by one.

This patch detects high-order pages and maps them as a single
contiguous block whenever possible.

An alternative would be to implement a new API, vmap_sg(), but that
change seems to be large in scope.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmalloc.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index eba436386929..e8dbfada42bc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3529,6 +3529,53 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline int get_vmap_batch_order(struct page **pages,
+		unsigned int max_steps, unsigned int idx)
+{
+	unsigned int nr_pages;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP) ||
+			ioremap_max_page_shift == PAGE_SHIFT)
+		return 0;
+
+	nr_pages = compound_nr(pages[idx]);
+	if (nr_pages == 1 || max_steps < nr_pages)
+		return 0;
+
+	if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
+		return compound_order(pages[idx]);
+	return 0;
+}
+
+static int vmap_contig_pages_range(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	unsigned int count = (end - addr) >> PAGE_SHIFT;
+	int err;
+
+	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+						PAGE_SHIFT, GFP_KERNEL);
+	if (err)
+		goto out;
+
+	for (unsigned int i = 0; i < count; ) {
+		unsigned int shift = PAGE_SHIFT +
+			get_vmap_batch_order(pages, count - i, i);
+
+		err = vmap_range_noflush(addr, addr + (1UL << shift),
+				page_to_phys(pages[i]), prot, shift);
+		if (err)
+			goto out;
+
+		addr += 1UL << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+out:
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3572,8 +3619,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_contig_pages_range(addr, addr + size, pgprot_nx(prot),
+				pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
-- 
2.39.3 (Apple Git-146)


