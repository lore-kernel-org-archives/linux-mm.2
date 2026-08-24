Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2268CC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1476F6B00A0; Mon, 24 Aug 2026 12:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA156B00A1; Mon, 24 Aug 2026 12:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28366B00A2; Mon, 24 Aug 2026 12:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1ACF6B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:06:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67304A014D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:07 +0000 (UTC)
X-FDA: 85136639574.02.5276486
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id A0296A0019
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cM4OF4zK;
	spf=pass (imf15.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787587565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HODHgPFWcmpM4OrWXnRIwysDZ/R1pibvtBSqDnsLNw=;
	b=LpmLZyfPrYmKmEfVxJnDfQxYybyrqIiskVmOtWurPz2FgVyk7YeDNZgfTAJ5WdI9oDLG7k
	dvy09lFhYCw0ZWruPBs7vKdDYz4iMbQFRcmiemPfLEruoqhG+HnddGr30YwHklVGk3Nv7t
	U6J5Q3/mJ1GTWTkTDI7ilEFthwwQc+A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787587565;
	b=i/hPGB4xaq+JmfoPe9thHnu6UR4rvAy3M/+9g4McoeELI6zNSCKYq6CnEr6su5MT+BlbMj
	sh8be2JEHXtNuFWd6bjGhuTxQ6Hzx63VWD+59x5j77Q2BAjCrQi3cT1u7McDYZKfzGTluo
	XB/F2bx4YLZO331m+VEpvqogMrE1QKg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cM4OF4zK;
	spf=pass (imf15.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2D1F16F2;
	Mon, 24 Aug 2026 09:06:00 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 846553F85F;
	Mon, 24 Aug 2026 09:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787587564; bh=nodn3/K9trBK+2wWrkLJGeFqd0INql6u2EHBqnLbWuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cM4OF4zKGJ1P/SjzDr6eXMRdqUQP3re7P3X9242MP8mexIfZldlzw0sfMcbAUSh1L
	 1a49U9Gw7XBFBsIGu7em0nv2/uib4e3xK/sCEUzr4sS4BhFi9PqpXz8JGLANNTKTay
	 tyBid6SLPtTSmY70IX5SC9k9RdCKMRCJUje9FtAk=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)),
	linux-kernel@vger.kernel.org (open list),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 4/7] maccess: Use a scoped guard to re-enable page faults
Date: Mon, 24 Aug 2026 17:04:50 +0100
Message-ID: <20260824160523.3907021-6-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260824160523.3907021-1-usama.anjum@arm.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: f4nhf691iedc7is5mkybcus845z3f73t
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A0296A0019
X-HE-Tag: 1787587565-512046
X-HE-Meta: U2FsdGVkX1+5eOlq6r09i+DUG1j75tw7lIoDzFY3XU0nVqg/SBrHvsBX/nOJGUfyA5L6mR1bAS/gsD923X0lwXZDDmDsKCBp22FFGqa4o7jiHFK5d/7T4f07NoxvC0gHKj8NlR10gSIPIdihO6QlX96ra0/RyjjBm4swOPxw6oRnEwaUmn82VP62WS6fORgDi3xq6sVZyhxkRH4puRHBfGQDB/a8ImPll+EBb8In2YqNaituSpCgn+hQvD7gjMVfKcK1AzwHkJjDxkjBigY+2Ngj90GPiYn5y33hHt4BsFdNh4D9FlynGTh6NTZx13drDt0oD/83fUBQjsBu/mMyfdpAbVyxlvdeAgLY1XMFCIVmysp1DMiFYx0vKc4PNXLDHXGL41KnPDozhcOKgMBBHy0Afd0Bx6BUIf1G6hNi7AHLTj22Y3KjMtOpReZuNfSC7L/j1G12g2tzm4vLdzsjoeDBq51KNqNdOelpeECPT8eGZW42iTmDU9eB9CqlSFmIenAww7lJXKBIbKPctEaNncrKgv9Xxxco9PZkqKWRvW1TKT++AFq1W7rrw/xaMuq1g12/tat10msHIyBUzEz6BFxQIYj8a0IR74WTfVnFGu+EMyr/9woGnbEF44YGWaNrZasz2tdD2FDtX5dhaWJCux8jnlskci2xGp8T9HwLLTIbBzsp8Au96WW6SrrkeI5Yuyr+kgnPH0Ank/MVgVba21uqCZy+dDs02jWyUa5ffYVaWwS0P5YxFVQjN0sB8YpZcaVnFmoxSKMOmMZbSH5oW5K6wpU/tYk6Yy/pjBvaBR41P+cW4sSyThijcnzSHrDn2APg/Q2v7xujF835S7bv3jmgWM13/6HLh2UFwyIY2yKT4XKOlFA+2rpT8hkCxmIdQyksAQjRbJ9nV90X8q2y4NsOpqO1mwP82xnb50+VfpbxcNrv4ZyivZtlGFqMlwdwUaPsb64bxVEMIe6Wh5X
 6tFPUu1x
 8vTLuzGkrF+NC72ZKj16fcnTR0r9eAosfcJPpBJtRfYQvtk8QdHGfUlIM2xFddkTcW8N2Vz1uhxgMGmNJiF+3eunruviI4K9DiOuYa4cYxqtXm8tvW74TU2Lb15e05U7qsVt9363FjpzBysl1t0PMVqoiufYB1DKsi8VHRhCJrijnAoyhJbabPFmoJY3PRrUpFpauln/IjH6a7ZvA6uyT/S4/JyFXzTT6Mheu5BhKTJDuKmGYLZKlA6rAg8nuqUOGVSNYslYd3m9VFmM48san7UbzlIRN92dtoOXb6Sb54eX5eHLbYOkB3qbVuV5OpWPUXzbaNcmimZUpCF/lvQWy2O+EKYmIEuaVfgU3+81H8OkWAmE4NWryD1y3umVlqJ9Q+iM0nF0TLa3cQNQm6s7uTSjaoTh5XlLQzvYCcmOLFqEPKPtfZeYBW4G8msAo9IarE0HYeDDEnsFF5W1HLR0zMd7dQGuyXYgocDsajF50YgKXJdOJJMNXGdpec1m6yo6V6NGMxj4ZJXvC0SF/1sLNZ4iG5OAgBEo6zHYrbLmI0HE1+0iDIdQCEaLOtxkoqpYY1WVOap07fWZIIM6Yza295RxFOVtypwo5dYSqCNFT32BzHUX/7C4jP/NLkQ/QtwoPIGbkfy6U6y1GKh6BRP+HH6fPAuyh2VTlaArgtrwOkMvihJfRTy6BL54mHXT5CNdPpk24iYEc9th5LcBeFun4yo5XQB8MYv1esJ6W0LkQmoC2DonZgI5R9lQzMUZ7Bx62EwJB9YA3yDZDSt99L40MeXZDb8WX5923znvKnsx6sPVzJ3IjwZdjU5ndWRT2hAkt9drNpGEz15LVR296CJub6QTasOu4e3pNts4T34VqU5QL15ocykqIdCWkW0KoJ3S2ecXOfAf7fNf3bd+qTqUovGq15nzt2ZN/wU7ZqKW1nTb6tOQv2ZtcbrGEggQFmCJOt4N/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel nofault copy and string paths open-code page-fault disable and
enable around label-based loops, duplicating cleanup on success and
failure.

Use a page-fault scope guard instead. Leaving the scope now re-enables
page faults on both paths without separate cleanup at the fault label.

No functional change.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 mm/maccess.c | 53 +++++++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index c59a0e092d24a..f695ceefe6fcc 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -38,18 +38,17 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
 	if (!size)
 		return 0;
 
-	pagefault_disable();
-	if (!(align & 7))
-		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
-	if (!(align & 3))
-		copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
-	if (!(align & 1))
-		copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
-	copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
-	pagefault_enable();
+	scoped_guard(pagefault) {
+		if (!(align & 7))
+			copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
+		if (!(align & 3))
+			copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
+		if (!(align & 1))
+			copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
+		copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
+	}
 	return 0;
 Efault:
-	pagefault_enable();
 	return -EFAULT;
 }
 EXPORT_SYMBOL_GPL(copy_from_kernel_nofault);
@@ -73,18 +72,17 @@ long copy_to_kernel_nofault(void *dst, const void *src, size_t size)
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		align = (unsigned long)dst | (unsigned long)src;
 
-	pagefault_disable();
-	if (!(align & 7))
-		copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
-	if (!(align & 3))
-		copy_to_kernel_nofault_loop(dst, src, size, u32, Efault);
-	if (!(align & 1))
-		copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
-	copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
-	pagefault_enable();
+	scoped_guard(pagefault) {
+		if (!(align & 7))
+			copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
+		if (!(align & 3))
+			copy_to_kernel_nofault_loop(dst, src, size, u32, Efault);
+		if (!(align & 1))
+			copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
+		copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
+	}
 	return 0;
 Efault:
-	pagefault_enable();
 	return -EFAULT;
 }
 
@@ -97,18 +95,17 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 	if (!copy_from_kernel_nofault_allowed(unsafe_addr, count))
 		return -ERANGE;
 
-	pagefault_disable();
-	do {
-		__get_kernel_nofault(dst, src, u8, Efault);
-		dst++;
-		src++;
-	} while (dst[-1] && src - unsafe_addr < count);
-	pagefault_enable();
+	scoped_guard(pagefault) {
+		do {
+			__get_kernel_nofault(dst, src, u8, Efault);
+			dst++;
+			src++;
+		} while (dst[-1] && src - unsafe_addr < count);
+	}
 
 	dst[-1] = '\0';
 	return src - unsafe_addr;
 Efault:
-	pagefault_enable();
 	dst[0] = '\0';
 	return -EFAULT;
 }
-- 
2.47.3


