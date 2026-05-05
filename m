Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E357CFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B396B00EF; Tue,  5 May 2026 12:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5435B6B00F0; Tue,  5 May 2026 12:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431966B00F1; Tue,  5 May 2026 12:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FEC06B00EF
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D07AB4054C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:49 +0000 (UTC)
X-FDA: 84733849578.11.BEEB1CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 09DB58000A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=luXYCNaz;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J18iXujFK8xYYFlyu0HbKoG2KQuU7cNGKxURAHEC0GA=;
	b=hNCa0qFV7pFAdWm7mC20a69eirfLCDv+NrVzRgqO+1h4uogb7Pbab493U1oW5MZszsJ7YN
	f6cnKukusomILG7ubkCCFYKoh+7bgYuisMsMbcwT2pz6GVxNIGc9vZXGIR2Pl9kwCzWzlS
	I6rFJdEcT5FF0xPAksJvUS9PqQBLxNk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=luXYCNaz;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997328; a=rsa-sha256;
	cv=none;
	b=yHpz4QhfrzHQnmqOQlA8oTed4PPIyAU4fazKY3PbjAh03sO+3c6HupUFze+NSDbjCPVcOM
	znJPr7gXoS3Wqzx+0ZsmfTPb9R+zOMzXcPj98XUbFkGmlJ+6ejBq4qN6w2sMSZDQt2QcXf
	RIk5sIbu1iYonNIJy4YeKykC8woZjog=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E98B114BF;
	Tue,  5 May 2026 09:08:41 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E6213F763;
	Tue,  5 May 2026 09:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997327; bh=XtqotHlvxdKu6c1pkEmCr60+1y0cB/ILuH7HTvPuXjw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=luXYCNazICc3tK6Lo75rwne6t5UDBAIT/GSy+kZtqZUQSSE+SVirz/40QTelJkaZH
	 JkYWQ7dTpIHd4QSAHQkyPD4tmU4aSFtVOzU4Qw9hg5SZ3yxDqLMi12/J4NzwvaWuli
	 Q50N8srUXZ+PY0p0gwMmTpE+ZFjErQD3dNlgJVHg=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:12 +0100
Subject: [PATCH RFC v7 23/24] arm64: kpkeys: Enable
 kpkeys_hardened_pgtables support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-23-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1336;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=XtqotHlvxdKu6c1pkEmCr60+1y0cB/ILuH7HTvPuXjw=;
 b=K2Hh5ueB1qxUS4zdYcT6VsETD5dVbzMYDFrOcezoE2+rc8YHsqgE1mD0JpP0LvBzLWt4INwPH
 FdSpumdToMxA5c8hwuqM1w/44U4enD9R0cEYEWjqIAXB1BF6Z84tYVy
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 09DB58000A
X-Rspam-User: 
X-Stat-Signature: 96s5p3fwfcja9qsxhy7b5txi5x4u3xkr
X-HE-Tag: 1777997327-159592
X-HE-Meta: U2FsdGVkX18tmyxqhDyYRGCTGaj194uFq6d9qXssbDyH+KxRVz5QgO3kP73xszmqvvTraB3uOeQ8ZelmWQ+nK+cWGOYhXe2xFgAZg7KPsPsyL0ShZpdb8FPE/P9w3hqze24adoGqM9R77QiuvizeCILYBYEg3Pfu6DwVIMYSZW2txpr4btya6phIk2FzdK/iAdb7rgiT3X52cHP3AnHS0WmdHqzqIHn5tH+9b2e0wD/lxp7pBQjYhPFFvBbTRSPTjdDVn/BGgwjOMmY+pGp0a2R/qn/jXR79QHTjmAfZ+mMIXk4abI5Whacv7C/pTZTUCv88AO41gCyYM8r7sa7Fq4HyXsFibIshhVw1yIVxiWft2i5KHMFTjtiBaU7ugpMUks4OlFW1k834n/Y1+y8Hg6NVmG8IyEHBwVUIVHfmf0zIG0AD9E/LDc2n+Lgkgs/R11TxnWAHQfEvDF4DA0o2SQNlJg455I57ek/HsljCjuUSHzLrMMTBMthlC85aX2E8OyYQNgSMrfX/0X2imnmhXlClAwhKKc3WT4aIydAkbw0CsK1nWpbpPFbhnW5EahXBkc0vqQ1di8SgEgztAlo6bcLZyzg63c5ZrHMtKKxAUzHTxnjsCHPHS006CSlvfNOwFw/JuYBAG4tnwL9jMEhJdI9zXk5BZBMLhmrdvorkK3Q99206S7clfa40xkpDW9ILRQFWNBgANck+wRy9bg8T1FRZk/LFQVGUtu9v3pL3pcffXzg3EY4PBCCVfs8VLi5v5SDf16e3wBubuQHj8O5HGNKd2QpD7tsr6hHLS4fi6sMHfQl4gvElNVXNofd04EQuio1782ztwVLOIyBcmBYxmiKItaXFJvSPaEoHwVHoNQnzltc54uKFaoasZtekXw3mzry1keIQ0hs6+PQxjd3xeYqEt8E6UW0+zFrQ2ooqwwz5Mlsv448bnjU7Ce4jLYSMv1dFz9YRE4J14wAQKxN
 oK2apFe8
 g9ei119zqDUnYVlDTXH+c04wmh+G66+1+y8A+qb9kZj9pfvO5WR7MKgS3PbXqv7aQI+qBe2bcSwMAi/hTNuF/FNmkF/esIfwwDwFpKzC1GmF8fq0bSfqxwMeMH4vSy5caX2+8FhlGFQk4sXs6yaq9nPt0TLLsjEyDPT9pce/J0ltOYO8XZ8TCVRR9XO3a1PShotRRkJiZnK5Ehy+H9oFLo+nKWNc8t+hiPs08h0poO3qgAyWz6gfA0SJSMhZuV0gem25QCxvIWfNMjkRAka6U246o5pU4Rp21Fz5McfDnjSjEcbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables feature needs to be initialised as soon
as the buddy allocator becomes available. The canonical place to
handle this is mem_init().

With that done, all the bits are in place and we can advertise
support for kpkeys_hardened_pgtables by selecting
ARCH_HAS_KPKEYS_HARDENED_PGTABLES if ARM64_POE is enabled.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/Kconfig   | 1 +
 arch/arm64/mm/init.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ab06324a50ae..43d3ab744535 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2146,6 +2146,7 @@ config ARM64_POE
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
 	select ARCH_HAS_KPKEYS
+	select ARCH_HAS_KPKEYS_HARDENED_PGTABLES
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 97987f850a33..7985045875cf 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -386,6 +386,7 @@ bool page_alloc_available __ro_after_init;
 void __init mem_init(void)
 {
 	page_alloc_available = true;
+	kpkeys_hardened_pgtables_init();
 	swiotlb_update_mem_attributes();
 }
 

-- 
2.51.2


