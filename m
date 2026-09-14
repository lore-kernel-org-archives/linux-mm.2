Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86F02C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5C46B009F; Mon, 14 Sep 2026 09:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F616B00A0; Mon, 14 Sep 2026 09:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BDCA6B00A1; Mon, 14 Sep 2026 09:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5736B009F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:52:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 006E61C03F2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:52:28 +0000 (UTC)
X-FDA: 85212507618.01.DB3844F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6073F1A0003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:52:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gHy6581v;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789393947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCD4n7rWGdeDm9sPatwiMIB+f6NruyudWkFMBNFF1nY=;
	b=TpRjfHJXOIlhaj8e3nB1HztgpNST2Uo0giMSGsfFOuhYBG7cr7e8iQFHaWg/1hKiVcGZGf
	7MhWCdde7yfpvdTV88b9g6flJilE2rgPREwvbW5AatUoeGBViDfdUYkZqx3DnSAziLKD8D
	dhhQWn7jIlLkpjHKE9eBHUim00l4cv8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789393947;
	b=a43kq6yVeCrCTYjwAwZdwisiAeKMxh9eOC7ex12AxzajfpuKZmPm+hQfFERfMwyaW0ltI5
	b4Ot/nBiLIEVD2j1ndP5YMH7BY2z9tX7DuoetTNxSYtbtNhS4TX+k7/TEtX2zevvzznfuH
	nLN1OF0G1pGy7E2Sh/hFmlfaaiIGqOY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gHy6581v;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6DC61570;
	Mon, 14 Sep 2026 06:52:22 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FC283F882;
	Mon, 14 Sep 2026 06:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393946; bh=e4ntXcUDjdHd2MfAB02Vr1Et9b59XeXUsYWhphwiZL0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gHy6581v3Osy62vEgipfLO7U9hGflqXQ1eCPuqXwQrCBqd/7/OFx2bCOuwhgz4k3E
	 ZnsOLh53E6Jlr+SeHyB3quPKCabxE0k+Qxa0dkfRIjMVgipHmzQYWXIFYq3OLPXMss
	 Mc8NOBq/1UzJG/ibmkDVamAsZWuVXbHEJOWLMyeo=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Mon, 14 Sep 2026 14:51:36 +0100
Subject: [PATCH 6/6] arm64: enable a distinct type for HW PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-pte0_arm-v1-6-bb53b663e396@arm.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6073F1A0003
X-Stat-Signature: d3wk7ii9n7yc7rmhy1pacegq9oud9xpq
X-HE-Tag: 1789393947-221626
X-HE-Meta: U2FsdGVkX19ZCt5RqAKxpX6uk6ibM9PqOV0gojfKCSiOjvUKLIyB8JXPzix+MS8yOsgWrr79wPYfZotU2ILZB1O0+cNP5omzjg8IET9Q4hnC1olQyx8oShNnX4+J0YPaiapZ/awWBftEsPnrAjyYT8BcZTU1V0cnSoueCmpZcWEX1pgucjkHvebNIZJ2n5QNU1QgscEy0xn1DSHpCCLCDppmZWo6jOdZ1+IvpAEJ1Nc8zx+UtMXej9oDSIaZUSWIhEQBwZssNqqPfsKKaMn9pjgjovNkmwgKHWc7DJAC3It35eR9o0lCLW6YgxUcrE6GfVaurXZIlA3lcAQilK2uHs/iZiO/CvfOiiJRtqrdJqqkt1YEJ0KebEa1R/2CEBoQCU0wDxolSNG/ahA0vLVQm2d2U0ommNygfOp7VdYpN7MTTieTt3t0qywle5TRwKKtD7/L2O/JRgFkGHjqhcvmS1jj/zPwTT2ST1dh1CjcUKEQvU7bmSz73I8Ba/eaFJ1Snej/mysCPYSSwprGXsO3/IISsE6LaMSrt2LcbHwpe0tifO/r/h+OdkaejfRD9bL+vsnIxvFfYsbXZQN3a+E4knxbUukAYWbn0/koV+A1PVxIGQY+wS94Q4rM7oYmwoPLs+CFLMxmZLBcXauPC7rMiIGPNr4lKfePoh4hBFs9cuVH9Js8Fgjre2s/jFv4NdsWhf7n0JiX5919BtXCij+TPC1GFdPiL+60eIKscjRFsty+FN6EFu0yIpTzKQJgazzbToTj2MgkKojvleq2RbI+NfO2K1cnmbmbNkcd1urcxSVB8OHwaB2w6lLyzVq5us7rtu+fMgBKImUdRYjlz2uAMajJqgJxyMPsvsjxbMdzZIsg6cT6h/+I8lOVMKG7GoqxYz6n3CQRFFAxhJtJamJ/NqHzn0wbhtSS6AcKyYKl1dVXLQ9/bl8ATtLwquaEDqAclGAQrr+SGVSZfBsCDkd
 QIkNX+2t
 4AQIAJcUFyMuwkqVRDGaxR9KzMl1nfW8qHYhIGDPR4k0ggxi4SEPGCJ5YKab0AV4GnhCNQuhpm6TeAaeEMLV42ZXfubh8PQ9XCHYac8sqb/zn2ydoPoAcM1wpwuaKbJCUiUd+YBx4EbXHqqvUVM7TDPEGQRDx39kcBVlq3qiQLZuAaz20tfZ1f9AMrxibcho6APy0Wnklq/I8IWPwjAA7pZn1nBiQPFOqXN8icmGHWT1bzqnykrb7muAiXtApVHhF9mklpuwCMREaHHZQw5/6KRluBzl+ywodwtTfsgkb7K0q/Lr1IjXHMccn7Ww/Jl9FdMnitCY4Xnw2j9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With HW PTE pointers and direct HW PTE accesses converted, arm64 can use
the generic hw_pte_t wrapper instead of the pte_t alias.

Select ARCH_HAS_HW_PTE_T to give HW PTEs and SW PTE values distinct C
types.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2bbeded33da0d..42841d5e2ed26 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -31,6 +31,7 @@ config ARM64
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_HW_PTE_T
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
 	select ARCH_HAS_KEEPINITRD

-- 
2.47.3


