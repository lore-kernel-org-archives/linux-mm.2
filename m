Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A07CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 20:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060646B0005; Mon, 13 Jul 2026 16:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011546B0088; Mon, 13 Jul 2026 16:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68FE6B008A; Mon, 13 Jul 2026 16:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAF716B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:49:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DE721C0073
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:49:41 +0000 (UTC)
X-FDA: 84984944562.02.A369CF0
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id AF97C14000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:49:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DY93OFYT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3Yk9VagUKCK8egPPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--praan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Yk9VagUKCK8egPPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--praan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783975779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eBZnUR39vw6RjG/0+G3LAv2Ug55ZNjpQuLX/y4dLZaU=;
	b=RnH3513OYDGoLQLERyTHr5Viagkkf1aXKdX8/P365uabnwlpcshdsSzDMQPcj9FZb7bdhf
	GeMizfwrhhxosmRdLbQxO5Bqwr8X9kLDLhbQJhc5D4IaUiWZc7XcPb7sslOdbaTglipl1o
	GFVIxD2vrIsNL4cXTZOaIejkq5Wt3bI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DY93OFYT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3Yk9VagUKCK8egPPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--praan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Yk9VagUKCK8egPPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--praan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783975779;
	b=YZuA0l+dSEN95ANqc/hNe0NwEpeOlbY3DTBgbAvl3SOTCjof0owQeh9RmaLo2+qqsJEp/u
	Q2GDJGKjsBgcKTge1vxUaCkW7S7PWKb/Iy66OjQiG6/4/n6BrhwWEh2b2e7JWmtf3VE1Jn
	WLRHuNSvy/pZsH2kJQHnnIR4mI2VQHc=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8484b9fb055so648753b3a.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783975778; x=1784580578; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eBZnUR39vw6RjG/0+G3LAv2Ug55ZNjpQuLX/y4dLZaU=;
        b=DY93OFYTjdKYMn5NoqDucbw7mOJFmhSPwr6f3WR20XLeTKaVTceNETTNU64yzUlndy
         GTF3sk7Meo4TpwjzzziY40EBjEVvrXzqvU/ZpHMhLLbL+OWVBmhx/NwnZST9Ffj+vPNY
         iZJ/6oI4MAbYfyRU3tuMORqn8ZqiQ90BWKdLbDqXnTZ61lNr2wEbVHKibaxtLit9Aarv
         yfZF+kfwsdrEOJXnY5E0t5VS2zjmCO7AG138ksD/mi/nmReaV2J/CrSvrFiNMwBC8I+G
         cNMHEu/FcoWBd1s+452SGK2ysAcoUjNbuTiJavKo2nMS4nbvOIrl66u6PKojx6MsR7x1
         T4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783975778; x=1784580578;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eBZnUR39vw6RjG/0+G3LAv2Ug55ZNjpQuLX/y4dLZaU=;
        b=XnATTYhQ5QGithS35pIwTz34CTOAh89r/aeXpz67gzlcb1CsW8T1xQzYh0b8NjT23Z
         RKuP3w21fhL918I8SRKFBzgzkxj04olVvUeFm1MIG4kV1JoUrWW2Z/ws31fXX/RNi02E
         It5/EL9g+3PqD1FBnqnCZj3LJbTsgIZFJudhXHrdsBVA9Y9/1O46vZaVPB8Tup7il2Vc
         cKvDY7iMfR/lWahqNDgeRjjg16PX+fOc7JsiZkU7YX0SI8uymVdLEt54NGoLrJY6LLWV
         5y6Y2sY1J5XlT56TCN/VW9XXGNbW7VPtlKnjldi16Fui46thGGwbuXTd7Ju+C1M6FNXL
         qZOw==
X-Forwarded-Encrypted: i=1; AHgh+RoiBDSFAHcwc5J6MK4QRNG7B9eiB67mXu8YStTOC1vfkELcYam1JoMC8s/YU9ooy1QpNwNbc1x4wA==@kvack.org
X-Gm-Message-State: AOJu0YzLEt8qZLHmGyf+pxO60HooZyQHwtLHuKEp9eaxBTdljEo+YJnX
	LoFhIGNi+IN5c7F+GaHwkdpHhj99wGr8t+OSXP0avZA0xGEh8MpI6jvlOHKC/74lSQIaA7JeErt
	P6A==
X-Received: from pfbha14.prod.google.com ([2002:a05:6a00:850e:b0:847:9540:3064])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:22ce:b0:847:8f0d:cc09
 with SMTP id d2e1a72fcca58-8488970ab05mr9541989b3a.44.1783975778163; Mon, 13
 Jul 2026 13:49:38 -0700 (PDT)
Date: Mon, 13 Jul 2026 20:49:33 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260713204935.3069000-1-praan@google.com>
Subject: [RFC PATCH v2 0/2] kho: support preserving unsplit high-order pages
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: AF97C14000C
X-Stat-Signature: 7hq1gmrpdesnwwgt15zi455p65prwk6h
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783975779-163696
X-HE-Meta: U2FsdGVkX18YlqF+1D2MbECIeAO/4COnutrH0i/QG2dD1p5Efi5wZDOWKk9kQfGuh0kKuTLFYxWKfPFCNiyn4jfKp3b4etY+ThRcIgOmmWBA+0p4HBCINXs+EYsv90sMqESMH4zlkdFPVdukH0eSjacL6vkPIa9zEib7DaAGEpRK9E/F/Qr6I77VyHgTl9JAIo2c65XuVXO4YIwABxm2xc2CpNwhjsIinVCn9zfzjwBRLy+XFG35OI43VUPIFVW/0CEELv3LAb5iYZRqLh8qUFsWpncqitTjVSd39CADTDDq+4fg/OfDvRu4becBRb5MuWImbTwGgifCeoA8EI3oDIqhHSpmYQ6wC3K0Smua5KwxAEakelIpcyM7wj60UzslOpklDhhFGlBlQw/FXl4v2JOtEKVhkaAUq1znLbEw6Y+3JiHR//SV2fq6WvUkQnlN4tLq6qpxIFrDHLXCf7ye1hv8pVNSoVpmq4rCtBE4dmZnVP4R4zxkf9TsVxoF5s/yv+bcXN2rDCcA7ptoSLk5i4tTC2yuAEgQf8pcCA7IGNar+QFx1faIBpTY5xv7wyz9xVJRWecyWqcYQghOcc0HfSrIcRagZMsJlpRlLT6A/cxGpcjFw21ffxKNSyWqTWBnrRMBmiTyyUyPA6SaeK5m3oFC062PkbhAPGIuqvCCFeu8jzAVk0YycH/gWC/tU/4IK4novW8w5i7AE43dEaaZLGFFf/t/8JetZ/KQ6cTlNbQya3hJB1bKtQhqQvqwpsZ17hJRHwstbbRu5SLSJ1qSljv2f8eVrTGDpTxeFgneMmtzGLdiZLgoEfsU+gm4/SlupyQ23+5vyhSgCGvWJw9RKDee7g0cXzKBQwZIaZYSKRsu2v1JaeyvjhbX/BPh7CIpyRF9rNvlsFz/e5MiCxCmlRMZyycTRg8ypOwAlokTwjSTGn2ehd07bnzU5RY/a/8sfld93MvDc4sesYPRiAL
 MzBrzo1N
 Nh6oFZ16iIXr5/4FeURuw6JNZ7i7nzbe6E8+IEONESul4Y2vmRouRyfUfnTbbcnsmHIeBr2B3CY//zPW35esR46Ctpl+xB3D3Ztps09TiArYf9TlWG0pDR6RyJEBEsoTJX3v0GgfgOGB7TewIgOExN8z75tjOlo9PPzzQLnRdkbTE1Was8w2G3dQeNoqVlMeRazWSjvJfztlEZR7u7vSvssgN34d3wPYlg5lWB0msSK/iljxAGG6gcrim3Ai2EfHaZ5Yk3Ko+7GKnsBT/SMEuILCcc+ncF3vVeWLh2+rsu2B25pSZXmCf8t9N5AhlmUijL8lex8pkZNxRS5pROwYxKKbYT1Qw+mySJaydl47WL7oLBuhO7HDcJXl4IkafjACRqC85W5THyohfyfiVii11R4fe6q2CJp4bhY7DxfAX+SWwaFQVp1XooW/ZL1Jham5YpNh2M6mS9F9lD1CucdfgeM5Ir0FYl9dPk8GRIKh3L3jRHNHZDj1O4u8J5ogbryLd+feSAfoTa9VZJxC0W5I29eOFuHxLhXUOanKOm0oKwJ8sdRU9BIKZv1g/CHQYe8nVSzMugVh4lmSrM1f2k3GO5+ZWKUpl3tcwOu3xXIPmAnctDhn3u7DOQqyRCbmHbujAqT1JAHPSxP60aU+0frhm1h1mCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduction
============
This series is required for the ongoing effort to preserve DMA allocations
across KHO [1]. It addresses a fundamental mismatch between the current KHO
restoration logic and the physical reality of high-order buddy allocations.

The Problem
===========
The current KHO restore implementation treats all multi-page blocks as
split pages during restoration. Specifically, kho_restore_pages()
initializes every 4KB sub-page with a refcount of 1.

However, many kernel subsystems, most notably the DMA allocator (via
dma_alloc_coherent), frequently return high-order non-compound pages.
In this unsplit state, only the head page carries a refcount of 1, while
all tail pages have a refcount of 0.

Consequently, when these contiguous but unsplit blocks are restored by KHO in
the new kernel, the forced reference count of 1 on tail pages causes some 
trouble with the buddy allocator. Downstream of the eventual free path,
__free_pages_prepare() [2] ends up calling page_expected_state() [3]
when is_check_pages_enabled() returns true (triggered when CONFIG_DEBUG_VM
is enabled or debug_pagealloc=on).

This detects the unexpected non-zero reference counts on tail pages [4] and
incorrectly taints the kernel while leaking the physical pages in question.

Proposed Solution
=================
Following feedback on the v1 RFC, this series moves away from auto type 
detection and instead introduces explicit preserve / restore APIs for 
high-order unsplit pages.

Callers are now explicitly specify if a block is unsplit & preserve it by using
kho_preserve_page() and kho_restore_page(). These functions apply a refcount
of 1 to the head page while leaving tail pages at 0.

The existing APIs (kho_preserve_pages / kho_restore_pages) remain as is 
for ranges of independent 4KB pages, continuing to use the split refcount.

The internal initialization logic is refactored to provide a helper:
kho_init_unsplit_pages(), which is shared between folios and unsplit page 
restore APIs.

[v2]
 - Dropped automatic type detection via higher bits in Radix key.
 - Introduced explicit kho_preserve_page and kho_restore_page helpers.
 - Refactored internal init logic to share code between folios & unsplit pages.

[v1] https://lore.kernel.org/all/20260703020832.1731864-1-praan@google.com/

Thanks,
Praan

[1] https://lore.kernel.org/all/20260708234854.4044652-1-skhawaja@google.com/
[2] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1370
[3] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1027
[4] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1034


Pranjal Shrivastava (2):
  kho: Introduce a helper to init unsplit pages
  kho: Introduce preserve/restore APIs for unsplit pages

 include/linux/kexec_handover.h     |  10 +++
 kernel/liveupdate/kexec_handover.c | 115 +++++++++++++++++++++++++----
 2 files changed, 111 insertions(+), 14 deletions(-)


base-commit: 0f26556c5eeea62cc934fa8938b148aa5844a6b6
-- 
2.55.0.141.g00534a21ce-goog


