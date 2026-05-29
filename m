Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61177CD6E55
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1AEB6B00C9; Fri, 29 May 2026 11:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB026B00CB; Fri, 29 May 2026 11:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9206B00CC; Fri, 29 May 2026 11:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE4F6B00C9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57D9A160C39
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:33 +0000 (UTC)
X-FDA: 84820773786.04.63918BF
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 47171180015
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IDxQFJoO;
	spf=pass (imf16.hostedemail.com: domain of 3haoZaggKCJg2J53+8AL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ardb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3haoZaggKCJg2J53+8AL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OI2PiSwVSqs1DMfWl+ZXR2POFOtjIsRCGzcVsnmPBAE=;
	b=rvUTk1U3ud1Glb1JdOD3MWRdMfcUqoq/H6ffaaKpJJ1uBG6gIMrY7bvLL9Eua0Oxug126G
	73PlHtsuPJ924IJE7JYJ563ppKFaF84VTkU/SWsYkQhMcqAlqU6vLe7EQwm+D5sVbgmbR2
	WIyXaNLhgdrX7h2/VRViVFGPcmozqjY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IDxQFJoO;
	spf=pass (imf16.hostedemail.com: domain of 3haoZaggKCJg2J53+8AL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ardb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3haoZaggKCJg2J53+8AL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066951; a=rsa-sha256;
	cv=none;
	b=doydZwuNVJ6SgEqnwFQVGEIQAdbSzIdoUR/YF51nS0gXLNdeXFIhOk+zOpHWaeoe8gD2Ga
	NTCTy35hPiZW8CF/2pwCUGSquLu2hVCZ5bV2ofATnWXMZXHhsCtyDpfddfvEadgYEke3VM
	BSZpuuQaTP59wC0QjL+oHBaRwtl8nzE=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bd9b5ebb302so212279466b.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066950; x=1780671750; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OI2PiSwVSqs1DMfWl+ZXR2POFOtjIsRCGzcVsnmPBAE=;
        b=IDxQFJoOIrcso74OVo/gd2n43pHCJHtOXYYbXiMq3YZiu8u1Z1XSLwSUVQk/tN9F2a
         j2abwOUJqikG0PbAfxSM1ME9Zwm6HktD+N+PkBTByv+47ldoLzyIxcvByDKWP4WrZKTB
         1yZnzm0o5ezGA0rch5Wd7n0Y6b+jooZ+9Ipd341espA7r8C2uTKNMSkJ7dmP/NvEbj6G
         Zo1H+YJEupr/JGHgb1RY7g/Hlj8kb9nqFew79XgDvbdK3cdiwFS2ebK2Xzo41/c/uEa0
         ISB1lseb7w89rMIbi4RPa4IYM6gQfSOoKO/w/ZH0ZL1U1bVcvfGxZGRHXyyUzN7l8fVt
         1TMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066950; x=1780671750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OI2PiSwVSqs1DMfWl+ZXR2POFOtjIsRCGzcVsnmPBAE=;
        b=a0TnTMew+3SmQISlaoYWKtmog5m474Rd7iG0AiRqC/Ei1hqh3AIP6oY9zz/EylrXcc
         sGpv60gxeL8CjfBK8FNjz2xgNZKp73NOyyjz3bfuUUIRoXzrCK88hjndkTw7HPeZlVXH
         +DtHpg1VKPvJLpIKOy4CvoJLqT4ZFOMithuFU4Y9SI0rp+Jygm4VEimUq9kdC82YdGyJ
         0ux9I2AJeDjGq89fkIu0D7CFoefD4eKUxZxTx6sFV/E2O2+90c72sATcgDSGmxN84jd3
         xnhyZrod3K61blp01E9LFQlJzx7DnOwqYxfkVNmgXV9J/tnhdFAAzsyFDIDBYeTXfIzf
         dc/g==
X-Forwarded-Encrypted: i=1; AFNElJ/NOkM4KyFSSJIMwfyQA2HaJfCxhBjq1myBPBjgsi2AT9nYUYBnHpYrvWD/dHlB6J23COu9y5RQ6Q==@kvack.org
X-Gm-Message-State: AOJu0YyL+4ToNr1yKydG8z1Qa6a7exqtD8YkM7t6mZInfoB7WekxOQ7n
	nyxGcTGPjM/ijU6kIfR94gAfTx357a0VVbTqS1YdFYIvY15aMs6YC7VXkaqF6Qq01KZm7VU9Hw=
	=
X-Received: from wrmg9.prod.google.com ([2002:adf:e409:0:b0:45e:f392:2777])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:a07:b0:bd5:2e64:aef0
 with SMTP id a640c23a62f3a-be9cbdc6f6fmr179513966b.24.1780066949175; Fri, 29
 May 2026 08:02:29 -0700 (PDT)
Date: Fri, 29 May 2026 17:02:01 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2652; i=ardb@kernel.org;
 h=from:subject; bh=LBsPwtXISC3cDlPuViRIHN1SKeCiNO3w0g/LYP90bWk=;
 b=kA0DAAoWMG4JVi59LVwByyZiAGoZqmug957hRslXLEFSHUmrg+wMpqdQu/ZaCQ6ZVNlpR/e6R
 Yh1BAAWCgAdFiEEEJv97rnLkRp9Q5odMG4JVi59LVwFAmoZqmsACgkQMG4JVi59LVw9CgD+Kz5r
 yC92Fjmy2/vY5E6VGL4/Nm1StvBfLlgn5WtMnkABAJz+h8RdmiKW2M9JyTSGnfE2SIklxmyurX5 hqMMXobkC
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-27-ardb+git@google.com>
Subject: [PATCH v7 10/15] arm64: mm: Don't abuse memblock NOMAP to check for overlaps
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 47171180015
X-Stat-Signature: t1xrfg7gmrgpky9hfeh345xxiaxiaxoz
X-HE-Tag: 1780066951-8971
X-HE-Meta: U2FsdGVkX184xRwKZI4z3eh+IyrSCtohDv/u3Pz9vyUmEYZOCsWpJnPjhMWwz8cPHcG0PhXMyHK35+2st9+2GTpU6MD0ASGI8/zsO2TwyOdg90B6FuoF5JSiVfXT0W5FVl6xQ/PrCDQnntpWOQhud19UfMOMqaLIiBuI2zg3o1Dy1Mcn1RSi0tzBqXnkY7hJpYDh7UFmo98fbwY6fTvjAyegARNWBikQlz9gZugg6bhLcdRCJtAHCiabS7a6GHV9tJ9H6Hzl+MzCcqY+hOTNYcdfrDqEY45CgQ7gLXOlft2l+YdPje7d4OLYyQI6l86DryuFOveTEIP5PfJJZe5leH6j8JFeCe4FirhginIr1Kdtt/VDQwfTq73KLAtPLuFdg+oLWil8Wtz/hEUmjamvOM6rA6rusgjNXryUgYShhHLmW/bE4TdAd5LXMNTFY+G+uRsHHi5fu8ZWMSKblU+P4t+Ri/uZC0BvqaT2RXoMTsmLpwQi3b4ub7oiHuSlCEBsPXPSAegwe9YKakbldayei/4LY5q2FvEuPCXHXB4iszr1XgSrdLZhD7LE8CWrYgL7SZbbEU9Vxm/e+6/G6VGqLj4LW+iRIYYi/dX7H6FMbLxZDddJjOMuKZSW4rTi+AClxnw89uV/2V551aKx+9YCcMwH4oFxQAYHs7Gc040gEdPI3QUI+f4ap+vA+Goom1qqkZwhdl3wiIG+PKouWYEv7hPsHH98Sj5Pw5TJuk9Fw7wprlUu6VaopaiLsifDShEW1FYQUEeYdV4ydXXn2R1KMkvX7RL6pTJZe7GHq73vEPIBQK2AEj1UAI5Whe3dXHYN17dWFRkexQ27xX92Tn7Pyi1fu//xqWW05nnO7XxdRGTmySfj7zmdWSumZqZwWCE8nwU0lc9RVpCgsDHTxsv1Sf3rHY6l0f/REd4QUwMk6YgaJgq9YWYvgy2TMIlBk+oQ430jvyK08Lt2RYIzuMb
 g5Fn2FEf
 Tr7c4fee62pCm9U5B/X9ZKlWgTuT1SMIzoBoIh+rVXvtLfuvxcsKz39gxSoYd/fUJIutApG2euG5oAFm5u2EojeCgEHJlWK7fJR7JEWD+U9+OqO4+gXb8tA1pTZRxCoxFpM7tWqhY4R3qTU3GGxfkLVfl4Pq1Z9TZRMLzWT3PU7T3E6/GirUVogoR5GghPrboLdPcXz0gcD45XIuFDGoApCt9uVc3iTk2HT/dcj0lB6UdsyGfMAGkqlVZMOiO25/DSh0ap2C/dL/6TCNh7oGNkH9r7rCb44qkm/C7n6WUuKAmWzzI2cj3AFoaHcdE3kwQLrDCyC8pEDhgrqDVmp7WaSNigVIhmqUd5gwPQiP+iE4aCMz35c2rPK7CNZep9dsAnc7CpqK+OXn3s4RP+KHdHbmA3WoVc/H6o4f0o36vGleQ2LetTywfOwKxLvXIY2BR8atntwVpqB7FMRc/b0thkCrlzUKhoMW2sxDOOGKcJow+zOEX2Vm6vTghTNOf7dag00N6p6FlRDMe6HVQO7QnCEIy4o9JmMDgZJ0boaWj0v0AYJYKWJ5zxQ33ui5lDvZaOzSk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Now that the linear region mapping routines respect existing table
mappings and contiguous block and page mappings, it is no longer needed
to fiddle with the memblock tables to set and clear the NOMAP attribute
in order to omit text and rodata when creating the linear map.

Instead, map the kernel text and rodata alias first with the desired
initial attributes and granularity, so that the loop iterating over the
memblocks will not remap it in a manner that prevents it from being
remapped with updated attributes later.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 26 ++++++++------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 971996e46fd1..dcfca5667e5c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1164,12 +1164,17 @@ static void __init map_mem(void)
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
-	 * Take care not to create a writable alias for the
-	 * read-only text and rodata sections of the kernel image.
-	 * So temporarily mark them as NOMAP to skip mappings in
-	 * the following for-loop
+	 * Map the linear alias of the [_text, __init_begin) interval first
+	 * so that its write permissions can be removed later without the need
+	 * to split any block mappings created by the loop below.
+	 *
+	 * Write permissions are needed for alternatives patching, and will be
+	 * removed later by mark_linear_text_alias_ro() above. This makes the
+	 * contents of the region accessible to subsystems such as hibernate,
+	 * but protects it from inadvertent modification or execution.
 	 */
-	memblock_mark_nomap(kernel_start, kernel_end - kernel_start);
+	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
+		       flags);
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
@@ -1181,17 +1186,6 @@ static void __init map_mem(void)
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
-
-	/*
-	 * Map the linear alias of the [_text, __init_begin) interval
-	 * as non-executable now, and remove the write permission in
-	 * mark_linear_text_alias_ro() below (which will be called after
-	 * alternative patching has completed). This makes the contents
-	 * of the region accessible to subsystems such as hibernate,
-	 * but protects it from inadvertent modification or execution.
-	 */
-	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, 0);
-	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.823.g6e5bcc1fc9-goog


