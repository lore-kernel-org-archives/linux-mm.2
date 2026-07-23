Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D79C531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 20:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E825C6B0088; Thu, 23 Jul 2026 16:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32B46B008C; Thu, 23 Jul 2026 16:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D483F6B0092; Thu, 23 Jul 2026 16:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A40686B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:42:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27A45C019C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:42:11 +0000 (UTC)
X-FDA: 85021213662.09.E34E049
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7981A40008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:42:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S1kWEsUH;
	spf=pass (imf12.hostedemail.com: domain of 3oHxiagUKCH0qsbbohpphmf.dpnmjovy-nnlwbdl.psh@flex--praan.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3oHxiagUKCH0qsbbohpphmf.dpnmjovy-nnlwbdl.psh@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784839329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4Z8MgAmeNYWGY3DpjlolA+dV2ZqjTSZSJZ8lZiZVt5k=;
	b=MtfoSWXES/SqOftXFiubPXb8V0CdIufCIWPuHanUIrBUGx804eZiAZWBx7f1dJxCTqkvb7
	S/wr/QlXUbAK64DtDAQCeOP82jdDXXIrvQ8oZj98G13Yu3CNRqGS6OoDIC2BYiiIQ0PzWi
	BCnUqduhYHCL8yD/bYlfmF1AEM3wv4E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784839329;
	b=OzSWTIpNeLphKXPlVsQWYt9zH454Ay0WPYEb/A8q6Vd1TrIhqhdhnq4fQwHWr+mVZ/s/OB
	4kcve0W3a81pnLSzV8dx76pEt998oAMzxFtNKw78Q2LDxHLHu+oDWAJNbDNHLgX8SqklW1
	V1dKprAiZGf8CKjEVt52VFvHKb6uXOQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S1kWEsUH;
	spf=pass (imf12.hostedemail.com: domain of 3oHxiagUKCH0qsbbohpphmf.dpnmjovy-nnlwbdl.psh@flex--praan.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3oHxiagUKCH0qsbbohpphmf.dpnmjovy-nnlwbdl.psh@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so1647905a91.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784839328; x=1785444128; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4Z8MgAmeNYWGY3DpjlolA+dV2ZqjTSZSJZ8lZiZVt5k=;
        b=S1kWEsUHeroF9G1HgJ3izCkqeyns2WgHNL8MIGOtwKxvG7xOqLhDHGPL2TtizYs3GC
         EtB5olOspYPcu6SlVjF7guAtCA8SerAm81IAMBhdXGTWKuOvrZV42atbf5A1/hXlV5OW
         vH+pNMTR2GOIr0/t2qJdDvCL91GpmQdOCTzapKETA/uypEYTmlQhskCTQJMzpfHIvj4V
         aM77h/7wsxaxE27Ngpm68XNluphe7YhZNiYevcepFmVEZz9uVep2qKcatyJ5Z/BvWOa6
         2dadC8pVlccvz9aJcqWsQ/L/LTRUz/JFBs+r2iayKOdpKl8QdMJIoTZdbpzePJrdyq0G
         fgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839328; x=1785444128;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Z8MgAmeNYWGY3DpjlolA+dV2ZqjTSZSJZ8lZiZVt5k=;
        b=MZxUhqofmU/gpt1aXp3bo9pwyoq6sR+/oAa2GStnN3Bc7UTCamawHyi1U1mF6Y5OT+
         7fQ7jKp6L5thzh14e0mSfR34kvRvqY+wwXMpleA1Bn+WgO3655wH0GH/Qi6maPzUhXtH
         JyaVkNmZQn7TFywLOhMt7XBTIvfyLggby8HjDXNzymZ6mHnXqcfSLoB8rGaHE4OixsZo
         tR4PlhOsV/qpHtRCmWUKT7a7w20pX2qjYMZXefdDG3AyEmL3/uTLKmZomzbLUZOpbnXs
         5BCC7ONQeo/oWLgw980wCVfhED89YhIyWwDy9ZVWaZLdSSbG0K1IdRrjBeTWnQDvRKQQ
         qOgQ==
X-Forwarded-Encrypted: i=1; AHgh+RroOMHqUK6zdWpapVC2Yn3X8VBPTdBxsX12q0VYvEyZuJLgQ/hK1HWQ++/tweP5Hn/3Xc6JSQy/FQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7Q6vueMXnVfeYDVInZEzCUmT/5mmuYWwE9M/mRH9f9r/hlGLA
	57WwpMTfdNwe4AGU7k+//xLIXz17dEQ9+PlfCVSLPL3/rO3849dBVdAHEkNppdVGLf/Bb+utAQq
	AbQ==
X-Received: from pjbcz6.prod.google.com ([2002:a17:90a:d446:b0:385:fa6c:f60e])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfd0:b0:37f:9ce3:ca97
 with SMTP id 98e67ed59e1d1-38ec6617ea4mr4536874a91.32.1784839328071; Thu, 23
 Jul 2026 13:42:08 -0700 (PDT)
Date: Thu, 23 Jul 2026 20:42:00 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723204203.2997395-1-praan@google.com>
Subject: [PATCH v3 0/2] kho: support preserving high-order non-compound pages
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7981A40008
X-Stat-Signature: 51xztgwywr5juzsegn38jcqjyminkm4n
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784839329-377816
X-HE-Meta: U2FsdGVkX1+ojzpUXBSOO0QjEFXba+9mjcMWf9GYYea8/a/hdT2QM8xNP3CTP6mtwtulKshb/TzhjTd3uQTUnn4UzzelMhZAPXeMQ5gFymBIbSC2fqO10v3R2AAOHbkcKaAwFndVH08VEgCqfQgbnrfDA7ypvKHFQpubSr9u8vaSd1nnNHqjDDoXS7+1X1Tqh1qkgFk1PPsT85eSuLmPVQcQYmxOQyyVh8x6wI1SA8K2Y7EMBEag6acbHCPWULouP48GUBRQGHz1urQ70Gk1EBn+zgpbf0M/iOPirC0Dy8R2JBL4y0HqAoDI5gDiuVEJXIdZFvBYOpR5ssgu8ds4pE0x9D/BDVRnmcX/LkFT/5SnruVuaehJC/Grq1aXNsBlsZfPfApnsc0d1tJ8QUYR00+eIuuunWFLnAeCCYbr2i+c2Fdby6nNvc59bJDBHm+uBg0yAPv4OZmFu0hml7lCbvpz3a86txVNcOjp9BZLyModKEpkONf16AyaB7FNqwD7U0yXnV9h3ltjKzytPIQqpE+2K7SEeD6n3bmbVRv5/h/d8CzGmuzNsAbzFCjBYqZuWJgk7vW2Q8kNt33Ii6nC63fT86qpiNqaaItFkmcTVRv0CfP/cMJ9lS+b7Xdfbph271hxWDkwCPeadloaETVEGQssl342YCV0BZgNNPu+2lhRO4KWJaef48wH4OgPZA2jxORWOikY5sdEdynqdWsHiPkc3u/Hj391wSiwbMDyxTG6rdET0vvfx71FyDgfY2guEQVyOHbu9WUCA8XF/a7SbZNfnhT+IoB7pnKlROED7NCH8vAXCqr+pkdTWP2uD1aWqHJsuiSxeVwTqJcHLrk2+EHGVqHrnqqTN9UOJZ+nVyg4Q1dTTyV44k6bUYy+F3ziztpWtmlhSwtGHwht9hzjURBnSubUsRooJMXsCu/Z6jNTPAMNMzXQh+5yJfon8ODNQhgEqqBnQADQj9myt+w
 Fo7O9xlv
 bB3oaJOGa8iHt1/uSCicCTuSPQjGiCFOaby1qbLW8X+lUMQL77vumK9Tpk8a+8kDGv4FA2/8/mWsYmk1QHJ/tkdDdP1EeJNhhCM0J1wJh4UycvmhQHAy+fwvwQA3NbKfntc5bKZ1stainFouojsUy2MpBRkFqqmYx0v/BuJ0oz2H7gA4sbMciPoNRgjXV4aIwrQtQNNhnOjVVBz6huqRd2RRGKeeoHi6VMV+piG2a20jAm6aQrjZ6DrKGzJyvtJrXh7Iz20RjaP9cdDhOTaolrd7j9ujCmVEhoxoAhQa1XqJfkwRRXFK4Ab+D6dsANRX4vqAmRbsZfM887leCa1wnD2JUPR83p36lCMyw5fjsrWjrW7SNnv1KWwG8R4BzaEigmmqaafkw5YyFohR/1uirLP8qD6NOPwLR4034hUDMaMerwBatPP39S+FONB+5YXYMRVe+tdb4w+DczEANDy8IZXVka1tfdalXnGgCU0hM4pYYBfGhaXbPvo/CNa5CwQ4IBkehWweAMlG49s3NgZIa3bLlL4f7/SwLawfZWeJTPciqkjS8QGrvDN8cVJnOQegMFYAushdhruTKPQBGxrcYMg9jkxMa0z14oruDjO066N4uLmgV7smMwdPo1DqH04+ycTVxrVamx2r5O5njlFGZufT7Kg==
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
In this state, only the head page carries a refcount of 1, while
all tail pages have a refcount of 0.

Consequently, when these contiguous blocks are restored by KHO in
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
high-order pages.

Callers now explicitly preserve these high-order blocks as a single unit by using
kho_preserve_page() and kho_restore_page(). These functions apply a refcount
of 1 to the head page while leaving tail pages at 0.

The existing APIs (kho_preserve_pages / kho_restore_pages) remain as is 
for ranges of independent 4KB pages, continuing to use the split refcount.

The internal initialization logic is refactored to provide a helper:
kho_init_high_order_page(), which is shared between folios and high-order page 
restore APIs. We also consolidate the common metadata validation and state
clearing into __kho_restore_page() to avoid duplication.

[v3]
 - Renamed "unsplit" terminology to "high-order".
 - Consolidated the common restoration code (magic checks, private 
   clearing etc.) into the internal __kho_restore_page() helper.

[v2]
 - https://lore.kernel.org/all/20260713204935.3069000-1-praan@google.com/
 - Dropped automatic type detection via higher bits in Radix key.
 - Introduced explicit kho_preserve_page and kho_restore_page helpers.
 - Refactored internal init logic to share code between folios & high-order pages.

[v1] https://lore.kernel.org/all/20260703020832.1731864-1-praan@google.com/

Thanks,
Praan

[1] https://lore.kernel.org/all/20260708234854.4044652-1-skhawaja@google.com/
[2] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1370
[3] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1027
[4] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1034


Pranjal Shrivastava (2):
  kho: Introduce a helper to init high order pages
  kho: Introduce preserve/restore APIs for high-order pages

 include/linux/kexec_handover.h     |  10 +++
 kernel/liveupdate/kexec_handover.c | 130 ++++++++++++++++++++++++-----
 2 files changed, 117 insertions(+), 23 deletions(-)

-- 
2.55.0.229.g6434b31f56-goog


