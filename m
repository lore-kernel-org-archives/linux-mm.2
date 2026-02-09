Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17BE1E81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438506B00A2; Mon,  9 Feb 2026 09:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5D26B00A3; Mon,  9 Feb 2026 09:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD686B00A6; Mon,  9 Feb 2026 09:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7E76B00A2
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:56:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCA62138162
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:56:29 +0000 (UTC)
X-FDA: 84425219298.13.F0191F5
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 049A140004
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:56:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6IA2mT7;
	spf=pass (imf11.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770648988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hWcBvSDIuanvdGG8hK0w4PUAsRvRha3/h7urmdr6y1E=;
	b=td+FeuCDJgWLoLsN7WMNAVFQMLDgXNtCrhwTAwsU+MsJQoz8A6ZjE6XIiHV0BSkPRGgwTg
	U8r8DuVFYjo0/HL6CBW5t75dMTuPCZqcohvlhrszE94pOoydewNiAWIiQ1rqk9mXp43B1J
	CfRJMRNUA/f8JrZ9VhyyxGCwtj6Ju2U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6IA2mT7;
	spf=pass (imf11.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770648988; a=rsa-sha256;
	cv=none;
	b=pkuhlvztUQHpVzBkOwDyqPpprrZ40SmnMJjGJam+6aJHWYFEqlk6WfF7CiQ7tTvBd5y4OP
	p09a7LbbymjcD8U7yHusVOd5oomjFehNZeDNbVD7XoCOs0K8wiCWGIoquypAy9tpmpmHRe
	KJtzCyOww2kc5CSuRX1CA/rr5qG0K6A=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-823210d1d8eso1769308b3a.1
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 06:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770648987; x=1771253787; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hWcBvSDIuanvdGG8hK0w4PUAsRvRha3/h7urmdr6y1E=;
        b=K6IA2mT7d9v12uIGgLrW651wDWCzsbInkYXezEkQZV5EZuZtwJK1qHR486ey7cDMs2
         RTcQYbV56tr2xIRG9KYHkRCQpiuKpV/1ODNYikqlGfzYeKziK2u8VVdlinCD086Z44SK
         UfR5kVXe3x8wMujHXWyEx9akDPYqE1FYyziNupmEX2ApYVKRkzJJsU2BP3fh4sie5XoN
         wqBPRqu95Ei/TiV8MA28KZwlsvxp/yTjocdIjTkHhKVBZK1wHbiv9l5r+imeHB9GrUF5
         I0psKq+d0Oku/tze7uCi4mTBszlbztk3HjJkV0VHAh/tJQNcb02CU9XmbA7zlCJU67C9
         +0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770648987; x=1771253787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hWcBvSDIuanvdGG8hK0w4PUAsRvRha3/h7urmdr6y1E=;
        b=f82f9N7SfeS2FycDw8nyPvPvQJEID2SqlYZ/4eTpmli2+mB5BH80fusAF4t5cMIAIl
         W2seUBAB4MgehMl1IPDC5AoFcJ3wY44lkmbQTxXHYa5sj0SHjDzNMKxN1GMof871ecok
         kVxO4ycxHMfmvB8wcmSQxmxb5uj3ceFN3rAlLHeQYIi/zj3k+qg9EQSj7P5QzD501Yzi
         JqQdqa8QlZkka79EfHwl9Idvw8wHsrIW4IKFRhapsoSYKhJCBVvMP6OC9IIIFm9QQKjI
         UvcD8vMRoub0BVvqNN6kg8sfQh85/FEfhFEVIILQ2jAsSLwxBY6yCLlvhEjs5ld1INsH
         sztw==
X-Forwarded-Encrypted: i=1; AJvYcCW1IXM2yJ9DhrLaWscwPebv1rMEZh5rDfwMf0m64XYNiigdl/R30ki6GPSe2glq0uDmZBN/WqH+Ew==@kvack.org
X-Gm-Message-State: AOJu0YwlujJ7+DqwhY3LbvLVxwIrj6UkzvX5wHI0qEuKAy5Sx8w/ta5L
	+XPZFHK212qr8bs12pz0JZDvd+gpwJSkc+UhjN1UYsIQbJwbe6ta4NuP
X-Gm-Gg: AZuq6aIelbzIL16n9kzbf0qv5VnyXTtUaHtkrohMu6HzQv0PE1QvqDjRRyg55xYgTTL
	xk1kNGtA9E56CjpINo1F4i0o9owPYu3HKx8q2KhH1iVyvf2Sdd9cTw4wk9Yowvmui0DefMhZm/U
	FzobtQl6/zTVeQQVeHFQrnwkphucGNNuqVm4jEeDlUHChQWZz1N/rPWYRXv/r0Nv3v/qukMreno
	ZBn9RFcV9elF4MVrmbupvqMsv6QAeGDAEIoFTKYbLrXEOQ1XBbHCf7/T8EZoG6RCnlWnehoKt69
	sA7zf45VsVi5uuyjNwLJGdccpe1MceiLKNN9TBJaTmfff+huoKxsXR0bbiWDXpyOpULk+lLibKz
	UBwG0r/BKYaazfdGXI2YeJTtK4uDAl5/sfJAerNkSv+noIAAKZb1u/a0bLHBJDBZ4958/04nePs
	oukp1T4K8lS0r10Gni+HrV1B5UMx8nj/oEzftlfAfmoUaXzV68/AeyvyBJ9QvKXenW1vY+i4j9h
	A==
X-Received: by 2002:a05:6a20:7f8c:b0:35d:e4b2:b389 with SMTP id adf61e73a8af0-393ad366d00mr9773794637.58.1770648986687;
        Mon, 09 Feb 2026 06:56:26 -0800 (PST)
Received: from localhost.localdomain (123-194-188-82.dynamic.kbronet.com.tw. [123.194.188.82])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb61e4a1sm9193974a12.27.2026.02.09.06.56.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Feb 2026 06:56:26 -0800 (PST)
From: Min-Hsun Chang <chmh0624@gmail.com>
To: corbet@lwn.net,
	akpm@linux-foundation.org
Cc: linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Min-Hsun Chang <chmh0624@gmail.com>
Subject: [PATCH v2] Docs/mm: fix typos and grammar in page_tables.rst
Date: Mon,  9 Feb 2026 22:56:03 +0800
Message-ID: <20260209145603.96664-1-chmh0624@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 4s4pgoudizcherickh76fsd75xfcinps
X-Rspam-User: 
X-Rspamd-Queue-Id: 049A140004
X-HE-Tag: 1770648987-542698
X-HE-Meta: U2FsdGVkX1+wKqHkXaUpPmkX5aT3TsN+bvWUoTN0+a1LzapTL8MtwZiOX7Vn9/hJVn4T1BEycL+UFJszr5llK+KsJeYXb2/9vDh5QfqkU2FArOEyztn5L9k4S+0J2GfT4BPAajVTdQ2XQQfNBy5V9Ns/ZRoW1EIs8CDf8TYzj5NeqPvjVBC2O1dGU7VVQbPvtMtMGQ1HALULyDywlFAE8cfNAHzy9SHmDU9u1R+UiAGj/j5RamzLsIFPLhAm4CYW7ZzAslUN2YtEChI66VIaF8Goa/fd/gCbjFidyMQApQ3J71J1DoD2oeWhUFSr0zo+K03Hu3S0bG6k+uqGhOnq3g6fC+rxlblHS2P35NTFCQ4N4F2e9jmtPiw+dFqmvSf7ZNJpbUsP8o9Pl9/7L3NXwzBvoS9RvXmsrBVrrqIodkmur8tdQde68wHgpOlJl4UZrmMCjt9pDBvKsaqnIomcefGTxFcym3jtuIf6WwYXmBxXUuVHmxSuaYHUubbVWpZWV4lsHp4sICzNiUj3EHn1JPMbd8N/o44JMdP+JVXgL/RGAuT/S7d4FLtL04lOzT304rIOXK/qvqDtdxXBht9V6DmYDTeOhS7ZnUYy3jwqJN3IMLZURsaKYfNNI5P46JwYkI5rNZsoZi2s1/iWDfCBxpFxYST+659B7zkkem0QLwK7zIn/hz+ByMIYivpNJRrgKNwgDY6QcwRIV2vecXydxICo6WxoVTDzvHtMNSDuVR67FL5mRuhA5+KEnM2JrykdppFHvVgCkl1qjIy96tyKn3IDaIETMTPGJ8kVthP1pic5wsduwrIxEuZtwehAO0o8X92tBRfa2mPqSZ506bti+SwHZDb2VbOsU2i2nRsk1bGxT1S+Zh3eIWLvmdRp3vYE0EeaRxbWWsguN5eb2+dTjm8Ihpt9j/sbFq+Gm7beroEUr/nA8F2fJ1Pc7VoqOwbB1WXFIGa0bOr84zURN/D
 xcVVgW4b
 fg8dw0LeMdxExn9/Llddd41jBvgXIfNyyvDfd1Hk9aCpuol4YP3n5v29nVz50zDLuOhHkh3XnHZb6JkLS5ixQeZpbRl0+y7oLo7PbFP5y4Y30KoNSG8J1D8x2CQhuMvDU9JoN56J8Mfua39aUmPy6MGAcqOqcAW058VYvfNg/v1E2ISnUtvx3toTGzLXREUuClj0JbFygRwgCyzbliUDRPn86FLeVDZp2pHG5LqLF1bAe8vJPG0z/e6ZYxILGP93aqNv6oL9AB8vTmO4IlMC+HDm2VuBYkCuYoH1NAZt6oKnJM5VRDn3jJ2zsJzVCaVCD9h/8SH2lAQCk3KMqdLRbxkaI9P2IBwUj1ayOFU8mKBhVXNfPrsCTsByX3bD8jzYHzr1gh3IdKhQ5fX/b+Hskl+x4O+shCfkPHwd1vP9RlejSM6hIrbBX0txy38O0DYAm03wq/qgO9FHgief9iFY4cJyOcoPr3ovzSBfnMtCMiYlGELc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct several spelling and grammatical errors in the page tables
documentation. This includes:
- Fixing "a address" to "an address"
- Fixing "pfs" to "pfns"
- Correcting the possessive "Torvald's" to "Torvalds's"
- Fixing "instruction that want" to "instruction that wants"
- Fixing "code path" to "code paths"

Signed-off-by: Min-Hsun Chang <chmh0624@gmail.com>
---
 Documentation/mm/page_tables.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/mm/page_tables.rst b/Documentation/mm/page_tables.rst
index e7c69cc32493..126c87628250 100644
--- a/Documentation/mm/page_tables.rst
+++ b/Documentation/mm/page_tables.rst
@@ -26,9 +26,9 @@ Physical memory address 0 will be *pfn 0* and the highest pfn will be
 the last page of physical memory the external address bus of the CPU can
 address.
 
-With a page granularity of 4KB and a address range of 32 bits, pfn 0 is at
+With a page granularity of 4KB and an address range of 32 bits, pfn 0 is at
 address 0x00000000, pfn 1 is at address 0x00001000, pfn 2 is at 0x00002000
-and so on until we reach pfn 0xfffff at 0xfffff000. With 16KB pages pfs are
+and so on until we reach pfn 0xfffff at 0xfffff000. With 16KB pages pfns are
 at 0x00004000, 0x00008000 ... 0xffffc000 and pfn goes from 0 to 0x3ffff.
 
 As you can see, with 4KB pages the page base address uses bits 12-31 of the
@@ -38,8 +38,8 @@ address, and this is why `PAGE_SHIFT` in this case is defined as 12 and
 Over time a deeper hierarchy has been developed in response to increasing memory
 sizes. When Linux was created, 4KB pages and a single page table called
 `swapper_pg_dir` with 1024 entries was used, covering 4MB which coincided with
-the fact that Torvald's first computer had 4MB of physical memory. Entries in
-this single table were referred to as *PTE*:s - page table entries.
+the fact that Torvalds's first computer had 4MB of physical memory. Entries in
+this single table were referred to as *PTEs* - page table entries.
 
 The software page table hierarchy reflects the fact that page table hardware has
 become hierarchical and that in turn is done to save page table memory and
@@ -212,7 +212,7 @@ threshold.
 Additionally, page faults may be also caused by code bugs or by maliciously
 crafted addresses that the CPU is instructed to access. A thread of a process
 could use instructions to address (non-shared) memory which does not belong to
-its own address space, or could try to execute an instruction that want to write
+its own address space, or could try to execute an instruction that wants to write
 to a read-only location.
 
 If the above-mentioned conditions happen in user-space, the kernel sends a
@@ -277,5 +277,5 @@ To conclude this high altitude view of how Linux handles page faults, let's
 add that the page faults handler can be disabled and enabled respectively with
 `pagefault_disable()` and `pagefault_enable()`.
 
-Several code path make use of the latter two functions because they need to
+Several code paths make use of the latter two functions because they need to
 disable traps into the page faults handler, mostly to prevent deadlocks.
-- 
2.50.1


