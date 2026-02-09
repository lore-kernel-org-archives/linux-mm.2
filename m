Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 661C0EE20BD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 08:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02996B0005; Mon,  9 Feb 2026 03:13:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0A66B0088; Mon,  9 Feb 2026 03:13:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD046B0089; Mon,  9 Feb 2026 03:13:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA43F6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:13:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DCF41A06F0
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:13:33 +0000 (UTC)
X-FDA: 84424203906.01.0442EF6
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9A8941C000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:13:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WYmHIj2E;
	spf=pass (imf18.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770624811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u7ECsemPt0+8hrEaXFS0vyfUJpZDXufVX7a966wW9n4=;
	b=ubqRDUnMo8drr629AMUy1Gh7LjQsDdewz2IOO7O+SC5X7oTSwiVszX0HmHaPD+AENHdNxQ
	6is9e0VR7N8Yg7xejXo3r+RpQXEZcZDkb5K8Ege/OgNuQAaeRmWdA1uQbc6jeuFOyqW6H9
	yViU23dm+I0MVMQce4qQWPcPd859LIU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WYmHIj2E;
	spf=pass (imf18.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770624811; a=rsa-sha256;
	cv=none;
	b=3SW7PeUXUevwbxDxVm4yfsb1dcMZkKPbAGeTrgwUfKlf3dQbX868+NzvbVWomzsORvBnWb
	FrVZi+0zkRH1+YrY4P9qu94tpFtoGnu5pv5TqWiXU269/6MJ7rcU1ZhmiTUgNx1s6+Nofw
	0kbBgcAAlkV4IWDCixQhAdd0iWkqC0w=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a7b23dd036so12443005ad.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 00:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770624810; x=1771229610; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u7ECsemPt0+8hrEaXFS0vyfUJpZDXufVX7a966wW9n4=;
        b=WYmHIj2ENIVVV0qcswjftwnd7jw6+1MrZUBsopUJtO5Un9gPdvk6tbhng1X7s6qWrq
         dBeC98Cqf5AWAwOzYE7Z1c3rwi2ni7TKEqduGB+93iOAMPLvOFQREUbfo1RYuPMKC1E2
         MBJoeyWOQElF9mix96jYRG+i28ppiwtXqlZytsMUt3jHk2QOsKh7v8+4mkzMq7Brk/YW
         SKpLgLCl9eFgrsHMM/lpZulvHE1CQOVbSHcXwRpIfJsjh0cb6k8uo+ZV1swaJqQQOgvl
         cq5AEjEbyxYMfUKpiUXbJ42Cp8h3QDehL6M4ANZZkW7L7Hiy39BNnER8Rud0jI0FLcF9
         2wWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770624810; x=1771229610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u7ECsemPt0+8hrEaXFS0vyfUJpZDXufVX7a966wW9n4=;
        b=aa6NuEB3lMqZWEncDtEXWqFxN8AxTiu1P94Bhpou3JfgDedn8kHFqjrn6oLFuDxHyi
         qaZNhProieyRrQPX+DOZTaf7GOFuKa7JzLZVE0xhDZAyFfm57I4Ff4kXLSYe4FSlVfco
         qvlv82Mpwa64My+RsxO7G9woUfq5rUHxAkreO9o/HvGziHyaAOsLkUxgHc5yAFqDC6bh
         ApefQhZV+GjOM5hsjxvYlsalksuEc+SnlmxmdYm24h0/bZd6QekrVmVb/tbRymrdKBYL
         X2U/qtJ0BgcZLp5lnI28FGCtqWFODu8P6esJi1rizIRbd53MLUM3MRZDo0G94eqzzyBP
         /u2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXBbrROf2iZh8VDG5ZsgofQ38AkVfh58XeHCTbY/2Oy34IE1X+suve/tRe4QztFc1cy4YwwsQYzMA==@kvack.org
X-Gm-Message-State: AOJu0YzpzlZUHTZxEVO/VTPftUKjR6MKtKvqd0YuayYRQ2OOdX9BrV26
	cKZXHeotHgicQkviIp2rrXbuCfR0UU1PsQbYF0d80tuwR2ql/k18U3el
X-Gm-Gg: AZuq6aKcxrrnieOD0W7WE5kqHwoeu75JOqhK+qPMzc51RZ/QEbrTSm61ySDyhWWFAi2
	/F6s/jtuRbACwslL2JAfOiYS/xNIe75HM5wqVY707U1sVFZbfH0MErEXZml2LtCDVMu2J1gPpSU
	ImlbSa9M77Dxg3ekQuImnGL4vU1rplndIesvsJAsTyDcw6xFXob0tO1BN7iRB/XQU2CsrEtxG/m
	MdaawWC/XQSCXGs7int36NBRmh6wSVW5BBl5oWmEEb703xrZ0RGvDJzBaW/XwGLsqoeI7IQw0bA
	PVcwVYKRWxRI0Jr3bdNgHUQAulREyXKB93Zi8KrhAo2mAYdh2JaQh3ZGMcS/FTPWxswhC6803a9
	sM1whldyVjDetcQSdzIsjWgV31QfOqYOpQT6/sH5rg1IVFb4OEe1L02Fdf/pKZ9k22b2IUVld1b
	EHcWq63WroTXO3vUMaTQczqjbN/MKXD97vkqfDaxaMjBsoxP+C/rney5Rbdbfmju0RcAs9mykhg
	w==
X-Received: by 2002:a17:902:f681:b0:2a7:80ac:85b0 with SMTP id d9443c01a7336-2a9516089bfmr97678645ad.2.1770624810288;
        Mon, 09 Feb 2026 00:13:30 -0800 (PST)
Received: from localhost.localdomain (123-194-188-82.dynamic.kbronet.com.tw. [123.194.188.82])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521f8cb6sm101205775ad.79.2026.02.09.00.13.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Feb 2026 00:13:29 -0800 (PST)
From: Min-Hsun Chang <chmh0624@gmail.com>
To: corbet@lwn.net,
	akpm@linux-foundation.org
Cc: linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Min-Hsun Chang <chmh0624@gmail.com>
Subject: [PATCH] Docs/mm: fix typos and grammar in page_tables.rst
Date: Mon,  9 Feb 2026 16:13:23 +0800
Message-ID: <20260209081323.68339-1-chmh0624@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9A8941C000D
X-Stat-Signature: y7483ya6ahgpzjmucxw7q1qnbgwpkb4c
X-Rspam-User: 
X-HE-Tag: 1770624811-816514
X-HE-Meta: U2FsdGVkX18nEX8J0+ZAKpnu7If0sJCHxx986JLC6o1PkJ+U73qwYduuG3E09h/ALYJvPzrD7cJ9xfzR5HDQkmpAjrbaLG4gnndQZK519ykhY0wdcc+x3arJei5rkSjwXeT+bhIdDdiuKVoGamu2u7J3kDhy02sI/KvU+6sTc40njsHdb7jCIzvXlE8QuB3fe9AxosIDddNa/RjmvEvWYJWxVYIhV3E+hirfeQLVulOORPRy9vtkC5EitZZZ2WKOIAedw3f/uBaKw9xZCrxOjzWVA5AXhUMPkc9pu/jPXFh6Erv2FwgpyCNnkmw9TEnq5JjCHtPcG40Ntl6WkUnjVHdzHlVBPUZwQ1sCs9iN53LDHo8kjWkgTx2cLz3eEti1xNAIkkAFugF3TBxwSR1KoMkhRdYuYqMJmFBnGF0+Qk+y52cQcSHKVkAtazxfHbeqnCho4LGQwB1Y6sLO5v2BL3hG3xo6SLcYcUQBKi/geFIbbbs+ze3CNmVRPSl5DmSADBcQTxTpFkh3Qpg1vebUNklpsEC2SYoHssLidiK9UxXQbHVRnl9iI2CuzDz2sV/8plSh73qu512Hr4egOID+Zqc19RFVs/O0EM+c9KXn8jBrx4d+v64HwLv+sJSUhAU6VmYP3bczbXMvM9AEVlUpUaGXE8yc8iVnbuk554uWAH1xHWiBA0FLkWO/W1xjUdkHxMq/hGFciYW6HNE9QYw+WW7gQfUPOjXj3XAT5QSpIHtaYBDl0BXQ6ju3ifzy77w9O+oVVZ8RpaVNipXwTSsPJ+M9W1k8qTbeRGVyRHudste4Uj3TpJKowAzWC7FigNReWBFQ3JhgF9PtAKYIljmzOBTl9rdC5YA/hhJpGndqCCmQcpftoE6wrYVPab0FaXE5uww70EHhUdy/4u3KMJM0Sm5L6VaWK2hEu+xVepGIgrEafnglfA+rn2m8nrLo9OJTOwftp+IfPOta/XDQ+J3
 T7fXHKt6
 Yap3zqnltCgN4l+4XguUf6k1pRhIoersQRp2q+dcFnSYJ7a8drySCUyqtWgFGrFITLPXuSoAn/co02KSxzq5m1XUjbO7rR7ZJoIuDR2AQxUCUXV4wNi5OyUs2JszRpeG523A87ZdDA0/bUl/Lxd08so23LrbcHhGTFlw5c9q4/T4T786Kk+k0gbcQ9KnSS17NuoE64FOUHwKMbFbVEmJRuckCpjmheAN4vZUSQBP29EODS3itFaYg4FOMfqUxs/t5Tf78J1MaX/c/y7VyPd4wi20sjE40JjY6wbiY/m50J7kHEsweGzL58BFBXZLsj0JzUcz18PS5Tywi5KzLXRrh99kByIlFXE6r2MuaL7npsJ4RUOWNG1vEBSKBgeIRELtS/fkEC/BuHl5N5GxjaEloatVF8GDtXjv0qtEEIJ+QtAz5jRGHWyggHfiqAtx4itRzLkXVueIYVONsJsWFFd+/Lg4f9inNADOZpUX1XKaJNOYhxoY=
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
- Correcting the possessive "Torvald's" to "Torvalds'"
- Fixing "instruction that want" to "instruction that wants"
- Fixing "code path" to "code paths"

Signed-off-by: Min-Hsun Chang <chmh0624@gmail.com>
---
 Documentation/mm/page_tables.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/mm/page_tables.rst b/Documentation/mm/page_tables.rst
index e7c69cc32493..d5a2c37b05e4 100644
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
+the fact that Torvalds' first computer had 4MB of physical memory. Entries in
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


