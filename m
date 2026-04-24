Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA00FED3CD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB636B0095; Fri, 24 Apr 2026 10:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BC86B0096; Fri, 24 Apr 2026 10:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C2A6B009F; Fri, 24 Apr 2026 10:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA0E36B0095
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:01:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25243894FF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:32 +0000 (UTC)
X-FDA: 84693612024.28.D846110
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7A19E40009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I9H0hbfM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039289; a=rsa-sha256;
	cv=none;
	b=Ypa3EzeMtqWWITDzckmH8LTCxUasojf4uUQSLkmgcZrMsDlQiawkxrpve7ARzfkIKrLHUO
	0ZkPNl6ZtWcb9lsG9XWWuSXz+nqDoBWqKYvsncD9DcRRzR+jeTYBh/X2SpLglYTGASk/ub
	Nui2qa+uD4UablQgCQr+cHZIhKPcK2I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I9H0hbfM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bXxNTX6f36IfipoZBOW83M9/wNv+uoZFYydeuJEH30=;
	b=R02sO6JzHFhkCpSWuC/XyeOpNP0DvhwzGa5Xtt5G1YjwUMCHN+WoyJ2/zIlldkXO1jvK/j
	xWqz6IHrDIe26MXAUE3vKmzZ5Sida4wOsJzEQ49MqDcsGk+PMZyF6+7WknV6lLQIDMe0W3
	B2B6rlbuJhC7klCCllp9bDROTnNUn2g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 78BD144211;
	Fri, 24 Apr 2026 14:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93534C2BCB6;
	Fri, 24 Apr 2026 14:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777039288;
	bh=ne0w3U/qb9Eq3ShDvj1y+mTm0Iqj6lSthxxEzyDc60g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9H0hbfMFtXWEg5HWINI/FHkJ9LkKBaBFKX3V7MsIYLgPac0I5xlVQGxhaQg3naj3
	 4G7bPpahxNPtNYrVS34oz8M6Mt1E/hqS5TOb8hhX7QJ0F40hOFGnWicy9BpiRNdGw9
	 9uHnRGZ0npVlu/iBL3NdQ0Vk+rR5LUa92Ms2AMVwhpuzjdcdv/diAhFHwWsUtBLC3+
	 WmpWHc0/+CeSQPFp/s2Piq1QaaAtajpXxEndvi/wEia9+Kk/cg1rYvon+mveRlHCGp
	 glaFm1BtTZ8LRj+tx5XUp10+9q48mgjIX3MbdLDlZVggK989NoBkAXb1/IkYh/n01R
	 TUcfBxG0cHyig==
From: Sasha Levin <sashal@kernel.org>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@nvidia.com>,
	Sanif Veeras <sveeras@nvidia.com>,
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: [RFC 3/7] mm: add Kconfig options for page consistency checker
Date: Fri, 24 Apr 2026 10:00:52 -0400
Message-ID: <20260424140056.2094777-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424140056.2094777-1-sashal@kernel.org>
References: <20260424140056.2094777-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A19E40009
X-Rspamd-Server: rspam12
X-Stat-Signature: xre9siuq6h4nyywxqii865jsdxdjmnic
X-Rspam-User: 
X-HE-Tag: 1777039289-624288
X-HE-Meta: U2FsdGVkX1//sCR1vjGwLsP+GyMzZpVMW0X/GV4iX6mzJ2/b4NS0Ta7MKlBAje7NBj+OTdA8HS1bxxkmGPkVdRAudJzatwAOroQr5b/LWO9mgkSuCl4q13Q/57zXpF5ZFHi6G/KxabdlLaGva7RWptgLloZ9mozVAbydeiRhvPN6w3jJLvp7TAal0H4xjYFAT83zK6lEi7UvOGu2/U5AmEU6RUhYesqHpIwCBfGmvoYEoByYP2OW17y83IZw5NJca+w5T7Dd1Saw7aneNqixFAb99oDwb4bl3vKIWeOhIqdzZwiOfv9EYtoLlvWdstVRH7V6IP7xfd+4sgajsnn8fyu3rn7U9VOjkTyxf04zF0oxO5ntWK5TgFaK5ITK2pexRZ7+CKJMJB9L9il+uRwMOHISxrrCmEI/sfvu9ErFmplwYVqiIQzmUoXBYJYqcd3mBvy077XuhIXUW+stBuKP8Cst0rolR4gb4Amit5Er2J+KszcAb/6rPYjmkiqwI4XFaDTa3Dsl+k4JletU9sEFrrYlbyWJw2kvdVDDyaTwJqo/54B3k0XKGhEvFyhEobEVC4xeV4K/4asyOmX5a1KuOJMXWQrbRAGDv3F4LyQXngjIi+nUa/FwCzIhzST2lCwiEJ5cch96s29WVMvR+9/Gz7zm5sTcqKpUbljevsYVbA86+lWLBix7ohpUGPRZpj+dwCldwRgOUf5HNo2fK4+IungjecEh2nHwj4VU/aL2mG2hC8OCyxC9bB7aCzSaTZ0Wph2UHa62LfFKD7qDFLfn95UcTutaZ2+gwIZ9WWCnEKOQ/UU7iENcr6/E/BUpU+I7XDz1APG6UAk7zIbFcWOWm6DjD7hD4mlLp5nyN/THVNisPwihRnuUSV993T4ApYw4UHpys/MaQCV/fRHp1spZLXsGgf9vr7eTxa3lolZPiFe9NDihc11J9TOPp85e7Sucf7rypNRWd31q1E8LLcu
 L3chcxzL
 K0f571s8InUWbR5JgxfTCQfgUa/6EGPGM7I4VUbjkjpDZiZXj6D96Dl+3sZNcHWtWpeGJtFJEYxCL9xDxgQg+T+QcigZXrER1yz5pdmhzueVTNvwgHkHBGqL6+I68DkA5qT4NzrXWDrPCiiIZgxXCTGPfDPn/fmnTekHiJYdFKd08DcbbVJ7jz0IUuH9aNQHIBndT+XXNvSWhzMjQ5dWXpI9tpXjWoYJwrhosYFWurenyPb7r9L/gw2h3R+pJivnmXJTSwT83cBYR+ZkdYLhKpNZKBDbfRIp9AeaL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sasha Levin <sashal@nvidia.com>

Add two configuration options for the dual-bitmap page consistency
checker.

DEBUG_PAGE_CONSISTENCY enables the feature itself. It depends on
DEBUG_KERNEL since this is a debugging tool, and selects DEBUG_FS to
provide the statistics interface. Memory overhead is two bits per
physical page frame across two bitmaps, so about 1 MB for a 16 GB
system. The bitmaps are statically sized at boot from memblock, so
memory hotplug is not supported and the option depends on
!MEMORY_HOTPLUG.

DEBUG_PAGE_CONSISTENCY_PANIC controls the response to a detected
violation. When enabled (the default) the kernel panics on
double-alloc, double-free, or bitmap corruption; when disabled it
logs a warning and continues.

Based-on-patch-by: Sanif Veeras <sveeras@nvidia.com>
Assisted-by: Claude:claude-opus-4-7 <noreply@anthropic.com>
Signed-off-by: Sasha Levin <sashal@nvidia.com>
---
 mm/Kconfig.debug | 59 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 7638d75b27db..a005c904677c 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -144,6 +144,65 @@ config PAGE_TABLE_CHECK_ENFORCED
 
 	  If unsure say "n".
 
+config DEBUG_PAGE_CONSISTENCY
+	bool "Debug page allocator with dual-bitmap consistency checking"
+	depends on DEBUG_KERNEL
+	depends on !MEMORY_HOTPLUG
+	select DEBUG_FS
+	help
+	  Enable dual-bitmap tracking of page allocations for corruption
+	  detection. Uses two complementary bitmaps where the invariant
+	  (primary == ~secondary) must hold. Any bit flip in either bitmap
+	  will be detected.
+
+	  This is useful for safety-critical systems requiring Freedom From
+	  Interference (FFI) guarantees per ISO 26262 (ASIL-D) and IEC 61508
+	  (SIL-3).
+
+	  When disabled, the hooks compile away. When enabled, a static key
+	  gates tracking until initialization succeeds. The bitmaps are flat,
+	  covering the entire PFN range from memblock_start_of_DRAM() to
+	  memblock_end_of_DRAM() including any holes. This is deliberate:
+	  simple (pfn - min_pfn) indexing is trivially auditable and avoids
+	  auxiliary data structures that could themselves be subject to
+	  corruption. Memory overhead is two bits per PFN in the spanned
+	  range, e.g. ~4 MB total for a 64 GB system. Waste from holes is
+	  typically under 2%.
+
+	  Based on NVIDIA safety research.
+
+	  If unsure, say N.
+
+config DEBUG_PAGE_CONSISTENCY_PANIC
+	bool "Panic on page consistency failure"
+	depends on DEBUG_PAGE_CONSISTENCY
+	default y
+	help
+	  If enabled, the kernel will panic when a page consistency
+	  violation is detected, such as double-alloc or double-free.
+
+	  If disabled, a WARN with a stack trace is emitted and execution
+	  continues.
+
+	  For safety-critical systems, say Y.
+	  For debugging/development, say N.
+
+config DEBUG_PAGE_CONSISTENCY_KUNIT_TEST
+	tristate "KUnit tests for dual-bitmap consistency primitives" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable KUnit tests for the dual-bitmap primitives defined in
+	  <linux/dual_bitmap.h>. These tests verify the core algorithm:
+	  setting and clearing bits in complementary bitmaps, detecting
+	  double-set and double-clear conditions, and detecting simulated
+	  corruption.
+
+	  The tests exercise only the header-only dual_bitmap library and
+	  do not require CONFIG_DEBUG_PAGE_CONSISTENCY.
+
+	  If unsure, say N.
+
 config PAGE_POISONING
 	bool "Poison pages after freeing"
 	help
-- 
2.53.0


