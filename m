Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 807D0C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366AA6B009D; Mon, 14 Sep 2026 09:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316B86B009E; Mon, 14 Sep 2026 09:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E266B009F; Mon, 14 Sep 2026 09:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE1A46B009D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:52:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FD6680156
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:52:22 +0000 (UTC)
X-FDA: 85212507324.13.56636D7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5933520008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:52:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VxM1nVkm;
	spf=pass (imf31.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789393940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uBN0ZQwvtsGp1jKgpj+hxjeJ464MZfPKqor1IPMdG4=;
	b=HfjH/MjAmtjdbOjI5q5ql2+izKVZrxlZrlX/Q2jFocXrhdY9ZXvzglLupHUY8PDBuzjL4j
	MMpfGMkg36aZtjjqvZan0Tuo2zmE4lvOzU4LAI/mTEL6nYiF6ECItHaOcmnHc564XNxdOd
	dch+qjCN32sxYm123QBKMtwIkheIWjg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789393940;
	b=ZG0vjrXuIJidvYdXE5gxo/we2fRRZObim6ihZb4TQGJqJ7rtkkCRgBcDR6ga4fOQ/4z3rv
	rBZa07gG6oA8xebeh3kRkO0SfAjo8pCqkCiI6z24jkUR7ESnsixVrYjPZoPst4TnPNgSXE
	HlAWhp2J9GGOYqBRhJOrRLAUmQrOva0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VxM1nVkm;
	spf=pass (imf31.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D668A1570;
	Mon, 14 Sep 2026 06:52:15 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FF1A3F882;
	Mon, 14 Sep 2026 06:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393939; bh=shLHKCHn3ZdXre7hsjCS5Jwr6cqRreukZfraeH8Cy3s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VxM1nVkmYNPpjHBF/3TyegZsi3gXy2y2TPeff4ji5cA2NOgdRBg5Ne4BamFW32epl
	 YgRiY41HrMSGBYlXBxqXq02UzbkG0f0IOxJzTyytmQEgFIuWVkudJF3DN5r+KpdL8C
	 9EM6umX4vRSY4FuskG1d6abnjmKoyuwOeT6yCXww=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Mon, 14 Sep 2026 14:51:34 +0100
Subject: [PATCH 4/6] arm64: use hw_pte_t for fixmap HW PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-pte0_arm-v1-4-bb53b663e396@arm.com>
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
In-Reply-To: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5933520008
X-Stat-Signature: 1hp5ikidcc53bjk3gd3nrqor9u8r4pwo
X-Rspam-User: 
X-HE-Tag: 1789393940-427766
X-HE-Meta: U2FsdGVkX1/+9kCznQKtr4TcxkLYEjlZTx+dHjhHsoiCTpjXAq0PAUi0Y51j9WiEXa+bn+DooyeGw5IrjksQDDAbVaNN1O0JAGr7FVE/p5BQlmnUMJm+m+rJ8fFmQI5w0myHplBr66QabUX7eIZny6nBglKUQPOf+3WjZ/akw8oJORplwuA3BuccnISt2CkLFNMFA9s7GWVsecu9OKtqkqgB9B7Io0SgPxTW/WWO65aIUsEbDpr3wt8v51xTakavU//wPJk4JY9QSC0VtSzWeK1o1Q6BoNUZq5HdgwZ/lJjjXYwKDeK31kmv2UEclREGEx4udaZTuJFM8w02ToeRsLeRzptjVTvEO0WaGp2uHTxUgHKCd8PEeNrI2nOyTiPHrIm35tWriuzwudMg491oIj1JOIwwi+XhgcjWo+OFgWNkvaS7fVmuU4qbs78LBuexCZ3cbFOj03svyLreq4ROU9WkJVHBHnggTkD5tnQREpAhDgngdy+2L6uYnmRKvYIoa9tJ+hpo573+02zGdG3Xt1if4u6WNePyc8FO0mB3M/gLFqUoiDzysi2G/MZDp4/qFp8OSEcOJc/ZasgWA69GqDdiqMCbAetkMFo1goKZXUJpoubzx5nUIEKv4mQW9I6qCOtZTNgvsBTcUK0fSwuTHGph1UVvEjnZjculEahmRbWWf61ZntepCEr+Hc2lsbS7p24BkWztbNys7eurJ+oSXy5MbozXDKNwzuSEvyfZqejHUxgL5j3YG8HaCQUtvo1pNlcry4J08OZbbPp1tYavTz3Fg5IopHfGIB4E3EGtKAlMNSE+YyXWhWcQmtcKFkpHO0a+EuKh1FQ9rYkIe+m+tu9Mt9ZolotbTjxo5gUf+le/jvKMY84jA/9S4z2utrZW685wyMkhjSBspMDZUUbeCok8xISoJtBtgf6j8/LHxsa7LqmLYrfOSJDsGue4NKZRpvJJBUngx7X9tVcqll3
 3VAonUpE
 4PGAk1CenAKfvs4sMTgXTfzx/+R2Yp8pMnXAwgYgy+MS7iO7q+Vbn8+BbCUtwdJxvl1fIGmKF4Cw7sres7px8r11621d3q94iWCpQZjmyX/aZMWB95aImKgK5IxxNcJkInXCTBAD2jh0n4r8t5X1/CUle/JittuYk8Jpokr0hGtqwKftCzYzADu1FhJshqpz7tUaKxJHF6pELg/mqBdJJV0v+N3QX8cEqcUoSsgs+O+Xv4jmcqMgeWwMU7RX4QHe/OlQHN0UUnYaTd/6NOWEny/syV1KuGEhqbdSv65PIJ6HHWigRmLoJvcXHr6r+Q9w/x3La1NYiEGIB6eloi8WMUDGR6aoncf9ip4Tr/WY4ZA7R5aU6QaEmZP99mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fixmap_pte() returns a pointer into bm_pte, and early_fixmap_init_pte()
installs those arrays as page tables. Their elements are therefore
HW PTEs.

Change the element type of bm_pte to hw_pte_t so it matches the HW PTE
pointers returned and passed to the accessors. This is needed before
ARCH_HAS_HW_PTE_T makes HW PTEs and SW PTE values distinct types; the
array dimensions and placement are unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/mm/fixmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index 237a9136bc73b..709a97fe327d8 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -31,7 +31,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
 
 #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
 
-static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
+static hw_pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
 static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
 static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
 

-- 
2.47.3


