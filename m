Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2233CC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 11:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2986F6B080B; Sun, 16 Aug 2026 07:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2488E6B080D; Sun, 16 Aug 2026 07:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110A46B080E; Sun, 16 Aug 2026 07:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4CB16B080B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:00:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51D1A1604F5
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:00:19 +0000 (UTC)
X-FDA: 85106838558.27.DAD9704
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7EFA114000B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:00:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wn2tZkv2;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786878017;
	b=YDAXLe5021W3VkGhFV1wRE6DgMZ2FbVn3QZY+z5SIUdP3Tu4EGOnAE6c4Dbpici18pYGRu
	LfLFbWESyKV6opQ82YMamctLUw5CphHw7PkP9iPdoNRRPaxYKkFjiluRvmdmvw2OlCMye7
	LyDpHAaKzECEmNWkU5/zpRF2DNwIwjc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wn2tZkv2;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786878017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVPiYTx5xsmZOnMUcbrtteXSXwIvJir7dW3VRw6OI/o=;
	b=5zqf7BmFy40YReRHLz70J30NIZJSAiAfTi216fNgAaB5riFryoxb4lBknLJHsf9ycH9jNo
	il2iwqanZAwfhGPnHhD1YR/OixTTkRT4zB+eW7E6+JpQb6+r/zXG3u8cdGqrGr84WuaFlR
	e22iPXxN3b8gC29PKjAOY7a0Iamw5t8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 571CD40461;
	Sun, 16 Aug 2026 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC81B1F000E9;
	Sun, 16 Aug 2026 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786878016;
	bh=pVPiYTx5xsmZOnMUcbrtteXSXwIvJir7dW3VRw6OI/o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Wn2tZkv2GmmvVvChb74RK7g+ieOJXoK9nRUtAwcKG1NxkbRbiQnwxuFtGfZc934GF
	 ojnGXmG2CmOzyYd4WRDvKp74bLte24Nxofl5tovKCDjJt8Klp3pt15WXlZF0xsKWd/
	 VAZrWr9rmwXSRxftpWSw5h1IkcUwmiJS2YwRKrOxgPSde0/kgHE18LZwznsC9zVKob
	 RkLvq8BCC+Cb38ljwdvLoIU5DXXQkdqpAZkhq6nlU183ZRgqoCY/nK3PbTrZgcsh+x
	 gKDjsg7+EFabNEvmBTKl2HgmFZfhiaPb85PFS+49KLaXDpFuB/mB1UDggWiTDWKvSb
	 sgZxxI00zoBMg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 16 Aug 2026 13:59:27 +0300
Subject: [PATCH 4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP
 friendly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260816-execmem-set-vm-perms-v0-2-v1-4-90944a3ad43f@kernel.org>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
In-Reply-To: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
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
X-Rspamd-Queue-Id: 7EFA114000B
X-Rspam-User: 
X-Stat-Signature: 93hs516yrgydcak43wefn31rd4h8bhwn
X-Rspamd-Server: rspam06
X-HE-Tag: 1786878017-600548
X-HE-Meta: U2FsdGVkX18PS1mxadvpkUunQExxn8g8bxj1gUnJnPc+8xEfTk6e+LSV6NYZ44xaF10+qnFlVRqfpwI/uWHF16KPmM9lfJGUUndF1d0nkP9py/Pytyfm7VYd1RhOCAGME95sSBEPtdQvaySnmp/mt45VO3MtGPe9ddQfjoRV/ChZMGSoLX2L9vZSpmpUpWke51+rvAUH78Sw82VewQwJsinVVw5HO9oirB6YQULeGI/2NMtyCjVmd0t426pYL8twaSc+xlLSEth28k9dfl6N0KrAOkLMJczgwg+df18jo/2zLPleQccYSmk90n/Kkv9/FNNAuC9ZkeJO14D7g4iJiJFswb1A4VIHjFM1bGllaqzc8VY80gGk+P5Ar4fHF4x5RBI0bjXGZUlCY3FbSge+2AzmXfth064LQXAc3owmlSm5gl43nhl2UiDWb9MPjAmMmvKoYx3IbD1S3ejcZe9aU8meMWplOWj5F28mXOWPLY2z1TLaYYhvj/mfnmYTZHM7oQBGl0fFsSOxcka9PTDNhHGt4Jj9EM2a2SL2u7Gz09FFgK+SU0PySfKUeezzgZrZIktoAqrB9p6NVlmDaVr43ZQ2PveIMJGVmXV2Q2nyLuMCN1ZKb4Gp3rTnXsabsn3ssZPtz9Jo4OsaKV6sTipDL9ldQVb6oBeOugjjc6q2lUg6o5amVaFvXXz9f/tFz0wpkOxajKl/oHTd8l3p2dEiS5ze/h4uFinNPI+4+xQJS/6eQWbclHZT8MbSIgvbZXQjzVS59rHKJ2khDZgNXeKdsn9x/o7Ae1s2tXS7JNTRH7albIHX9YFPUNeNwapwyObHV8kehTss9FGJmVpcJFKwEJjromJqo5OrmZ6LpeTCXtafdBoE7yIOxH9062ZheovpHjASuxkvA8SLpfZmqAPE5HjHRGJYqMDToGAHkgrGbR0owMR6oGzXFrImwHz24Mjlm+MYfJN18IURKdHRnHg
 dbDKjQwj
 RxTsDMjU0IFS+iTy+QGDCPgHvxbkfn8HmVnVeTdpoo6w4jBNdtKDNqh9hzQ1koXxzOoUl89fzYnicXwYJZKiuaFUiOv4+he3mGtC/kJ/bSSIK14kkeK17W4Q0aJLR2d5Ex3Lr0e5pNNKpPHa0nKa/1eUhOnECxuQJ7pwgNs3Ms7gBelekcJRg6FZA2963UZYVYBHR1+++CddeMbLa7XnEffWRlA+UVk8EHt1NbpO6bNH81O4JFAbaJXIPjqFbNo0lnjWYtI8ksln8YL5qYs7Jg+TUcc6xSDbDI4pE
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
index fc7993db4152..11170d1ee5be 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3361,12 +3361,15 @@ static inline void set_area_direct_map(const struct vm_struct *area,
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


