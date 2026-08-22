Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 450A4C5DF8C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54CC16B00A3; Sat, 22 Aug 2026 09:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5066B00A5; Sat, 22 Aug 2026 09:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366056B00A4; Sat, 22 Aug 2026 09:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A44A6B00A2
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:54:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87A0D8014A
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:13 +0000 (UTC)
X-FDA: 85129049586.06.22C9D4A
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id BA016140005
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=B+qUYCW2;
	spf=pass (imf26.hostedemail.com: domain of 3AqqJaggKCNc3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3AqqJaggKCNc3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787406851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcGHYE7YHIQuleStFkafOmsPgUJAwjDqEsHvPsytY4A=;
	b=cF+1Ra4X2IM7QRbix65P2e415gocFsi+4ytPNOn7D3iPNVwvJkumVE3dy1tQCNu73y4cJw
	P8fZc+rhwQhQ56IQrBHpnrHBtTxnUVI0PY1b/TZy45h3/Hm3pwaiOVWgHv0UPqTJ/Lnem+
	onDcqMRC0ID112/Zwb9McUsjaL9xbOU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=B+qUYCW2;
	spf=pass (imf26.hostedemail.com: domain of 3AqqJaggKCNc3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3AqqJaggKCNc3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787406851;
	b=FvmT2B6zTb+SK3lePlXDA6s8KXRifMgThmia1GLhHBPEQD9fbxUcYQ7lSIAaHwGbbaQxEL
	GrDa41W0jSAc2Q3BtIioICg7grIsg5Q+14wg5Ry6GnkDG31yt0Jdlx0wtMYzUS8QlRPRNJ
	aJ+BNpuiKavDt0V3Zv5NqDF/NCYpkyM=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4954dcd6131so17149705e9.3
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787406850; x=1788011650; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NcGHYE7YHIQuleStFkafOmsPgUJAwjDqEsHvPsytY4A=;
        b=B+qUYCW24giu4FlFIc9/EbgUyJKF8BRWH/BLd1HCZQdqNm2pANiUtRmVECdnSJFthN
         St7DGB8Ahse9wwM4t+NyQxf7sUl4fLcTHtvqvxUk1i5giYiQkn2pZe/Wk9TRnNsacbcX
         aOnZKfFCzNVm31s/2G+PO1TRpW3gw15K8RdRNJjW+s6ZhA4nNBezO/cD+ANfH3RPI/pZ
         UQQchyA9MkVHvTfzlwr2EXc6BDq5ELRd///u1ywVLZJjYR0RGjEEuAK0k6DrKfKq1L2a
         j9dPLhP4GjCFDGCEplzIy5Xd7D4K31jdH/0fZGoLFqAEB/Xiyxp4IvyZt9A4Ibl4ne8j
         dA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787406850; x=1788011650;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NcGHYE7YHIQuleStFkafOmsPgUJAwjDqEsHvPsytY4A=;
        b=kUBmjwW8Tc7dbgJ281yvNo9BJ4FgknSx5LwSZzxm9+WwqKlEOQzbDGYk3+3dyRw393
         QZIYmAgg+iFI0empsiLnbeghvaysZYz8NgT6uNtI9bKZpuijaTUqavTr5hLFp7JtNwTQ
         NJMl6/fD3e5wdeeju04yZW2z6PPxBMxku2WZJwMHiAePktlZsTne7EVYr6lOQVRkhMLi
         e6gM52PZ1WdCT3oM3fRzXLScEMspwaPEU9ZxSr0c/YQZwlbzLaaf1NhPWuh14v9/Vaqg
         vUKqP5zyVm4yJJDf0R8JORoaiCUSEOlh4Cl2dr/ZKDNKzBT3Q3CnVL2Q9Jys7N2fHRLu
         tIxw==
X-Forwarded-Encrypted: i=1; AHgh+RoAyfC6K5sx6eEGd3KXlaJCm3jOTMsfLbNWkYjJS5f1KxijWmCjKxQRDt0l5G/d25eZlGGLOD3YPA==@kvack.org
X-Gm-Message-State: AFuF++lHh52rfB+SHrFSSccQ93P2flf17jO3NDSTFPVWZjhm1TkVDhli
	unkNJY+HBiJsZF5u1NUtPrP2v6wG5xHG4vVfucV6CMZ5wa0CjIeUDt9hlng91eprqCpY+IGnSA=
	=
X-Received: from wmbeq6.prod.google.com ([2002:a05:600c:8486:b0:496:c04d:501e])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b77:b0:499:48bb:417e
 with SMTP id 5b1f17b1804b1-499b82f4163mr187121695e9.2.1787406850393; Sat, 22
 Aug 2026 06:54:10 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:53:28 +0200
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
Mime-Version: 1.0
References: <20260822135323.795946-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2053; i=ardb@kernel.org;
 h=from:subject; bh=ZgfBeS04NmMym7tXXunDIhp6k1y9y951qTGwH0jNq+o=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIatz5R0+ffGnRqHZvHKiZ171Tuq2SUp6rLQk556gl5X1W
 i/DWes6SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwERETjH8M/j158SWE9PaK6yK
 v2ytKl+pf26qsfCdLZf/86WJtv8K2sjwP73gZ/33YNcPt9OyeQsCeNaV807jMt4k6LzywRmh2Rv W8gAA
X-Mailer: git-send-email 2.55.0.860.g4b6b3295ed-goog
Message-ID: <20260822135323.795946-17-ardb+git@google.com>
Subject: [RFC PATCH 6/9] arm64: Enable the execmem ROX cache for module text
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA016140005
X-Stat-Signature: 3rhoxink1dxstimxx7e3335a3c7ynxck
X-Rspam-User: 
X-HE-Tag: 1787406851-251991
X-HE-Meta: U2FsdGVkX1/XUwvlNhENELB9SDFm/FLHBvoFK1geMP0nhbDjzRjAhsBBSkveu6K8vLJZMt4KtyYGZI0/lPgNIY1MIivdOrOQ073Xr4Jy/0Lx5AKnJVK0sFsViT7IvStbnvW15jFv9+tGr7c1GotIH/S/hoFtk8IT4EGW/regELp0hTN5ZZXTJpq2auPbW1OgC9LqwcsT8BMF4N+RVTFES7i+ebYP7vljS5Zysl0ixOZhP3k2JnbkVWVVupSa7iBXELGRiRjtC3PepYFZZI+84X6RAM4UW2C4M4y5skZBve5DtGUHfu22fK8HmHQv13KBGjapGXLk98UIqdHDjDq5Wx32vQpQ3HAAR1vRtosEAsJ7Gvm+Vcd9DRiFi6iP36GmM0ZGvkPurCvYYTlkh1ASPWTuhwt0kozwfexTLuKaYT+uEXKQfEFKK5ZFk78fMjZpJl4sWn05ykxc2DJc21VUfUnyCsuea3baIAjAp5QCkunCOrcJem7f62QUDdRm1o6DytyEGdWr3NHfEykN7a5759TwlCw77zkjqA7TlH8vpcPr000LrnywVRdxPHsl4eZgcqT8zRQHsZETjjSbaCgXAtYuzXTVNzQ+3mNCPYAmrPKOdrZjug6KlGlRzd8H/JaWfx7rh+M+t+FiMXEWp9UxN1nZg3KtRbGx4XJSV6rUE7M5Bvo6EufIP1byzukZjO+UFmJHdHPjAG4UxFZoPfYkQLshoQMdaGq3QcIkuUw/R6W1jKsJnVJXqcXZrSwuLpZIur1NA2EbaDODxsrCYV8WGa1Kz3YHDS7nsZhWGIAqLK1l60T1KGhTJSNmsdE5nAUOU5K39FQ/lR7v2QHXBo+sMKwML3i7Sgqnvc2Agfgt+x/gaiCS75oRhgSTy0BLvRmK+cnvAkqP5/qxiL1lNkZnSAOvjR1Ge6CH4zqi3fs5yPo164bLlyDEAH/E6Jxw2ITbNBfwSAhF748rubtIE0u
 Sejc/mhW
 GbC7oTUjrluZ4y+6pc8eNfVff+gkY6+plmTGszZZuDxnceu24zl2Aaoa+ASsknu9aSxhEl61iRdmV5/TVel4e96W+mkSSjIcpkYXmkd8rD5q1NYB41f4iFQi/pw4vMxUSqbfv6gzWpbc42JTUHszVTJqcU33OoWiGXlHrMElMR4B1nNRI7CV96Xfjie/QS2JMOJTNrAhBdgcwhmYeIOEMLJXpleOxaouz/CZsZiTJDOAzKvIZog2jcuMH4Byibg1RbhGsa0WlORg6rUHFLIk1b4VXUu1sZGryqXeXT7myRLfqnmhPCYq0t0Zo2m0Q6/XATFbMjQfLHE8N98A4WeeV1tMqWEuzgmLXLCSkvTc8KkOqb01S8xPZ6r5VBsfo8R/7q04cx6JPVq4JCaT6MkljbvVvP4JI2Ume/qCbTgL/OmoyCIv4HJOSPcMJqfYq+eDEfu/tDWDgSxeFoqarwRmbBxw3Jlh4eRzU4VBcPxahlJuugXnwi+pGw42bm+WYL3XJpFRROjYgbwlGLC3gvx1SpYM0q1xlOD6jRwkphYug8zAC5qdzcp6xR7lKmEKNYm63Cfs6f9BCXTM1NTZcRB3ZKh82Q6Z4MMED/00Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Wire up the existing support for the execmem ROX cache on arm64, so that
it will be used for module .text and .init.text regions. This will be
relied upon by a subsequent patch in order to allocate those regions
from a single chunk of memory.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/Kconfig   |  1 +
 arch/arm64/mm/init.c | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919..080b97b0bbd5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -27,6 +27,7 @@ config ARM64
 	select ARCH_HAS_DMA_OPS if XEN
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_ACPI_TABLE_UPGRADE if ACPI
+	select ARCH_HAS_EXECMEM_ROX
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 97987f850a33..e6c98045046e 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -531,7 +531,8 @@ struct execmem_info __init *execmem_arch_setup(void)
 			[EXECMEM_DEFAULT] = {
 				.start	= start,
 				.end	= end,
-				.pgprot	= PAGE_KERNEL,
+				.pgprot	= PAGE_KERNEL_ROX,
+				.flags	= EXECMEM_ROX_CACHE,
 				.alignment = 1,
 				.fallback_start	= fallback_start,
 				.fallback_end	= fallback_end,
@@ -548,9 +549,25 @@ struct execmem_info __init *execmem_arch_setup(void)
 				.pgprot	= PAGE_KERNEL,
 				.alignment = 1,
 			},
+			[EXECMEM_MODULE_DATA] = {
+				.start	= start,
+				.end	= end,
+				.pgprot	= PAGE_KERNEL,
+				.alignment = 1,
+				.fallback_start	= fallback_start,
+				.fallback_end	= fallback_end,
+			},
 		},
 	};
 
+	if (!system_supports_bbml2_noabort())
+		execmem_info.ranges[EXECMEM_DEFAULT].flags |= EXECMEM_NO_HUGE_VMAP;
+
 	return &execmem_info;
 }
+
+void execmem_fill_trapping_insns(void *ptr, size_t size)
+{
+	memset32(ptr, AARCH64_BREAK_FAULT, size / sizeof(__le32));
+}
 #endif /* CONFIG_EXECMEM */
-- 
2.55.0.860.g4b6b3295ed-goog


