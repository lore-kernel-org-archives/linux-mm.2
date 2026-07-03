Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D3FC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 02:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9E7F6B0167; Thu,  2 Jul 2026 22:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76056B0169; Thu,  2 Jul 2026 22:08:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8746B0167; Thu,  2 Jul 2026 22:08:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E11E6B0167
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:08:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1819F1A03BE
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:08:38 +0000 (UTC)
X-FDA: 84945831516.06.E64B6C9
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 69B41160005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:08:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Z/chWxv/";
	spf=pass (imf08.hostedemail.com: domain of 3ohlHagUKCEs24nn0t11tyr.p1zyv07A-zzx8npx.14t@flex--praan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3ohlHagUKCEs24nn0t11tyr.p1zyv07A-zzx8npx.14t@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783044516;
	b=CYugcOm7qsNL6VYGiQI9B7lzlcQCsxxkXj/M62S/wEDlhatDDRaSB7ntAOTs6V/UVtrkPv
	uzdkrQYmzw7KReXtU5sN7BgS0xS0f7O6GT3c2ugEeNC2IvhWjBxlTSN7EyQLmz6Om1icWZ
	0s+bl9z/JTu5dQ0FYdC+YHwiFnpQjsQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783044516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3ssAB+EsfecVy0nswhEr9TzBhCh5UgDVB8vvd9e3u/M=;
	b=MX7kjAoJxi9qoiRMKCcETzF1cbLj6D7WbjLGu2473Kn/XEMDh3ylXiB7ZSRq0tfaUPSW/S
	NwXGGixVLckCxAPUpNy2vRLs2JzNG0+bpD9qoRT4FD31/q8j5MgW6vMIzNnQEPnD2eeZxM
	lX7FPMvchMgGhNyOIgecRMIw/PtpZDw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Z/chWxv/";
	spf=pass (imf08.hostedemail.com: domain of 3ohlHagUKCEs24nn0t11tyr.p1zyv07A-zzx8npx.14t@flex--praan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3ohlHagUKCEs24nn0t11tyr.p1zyv07A-zzx8npx.14t@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-84696ed3b24so129004b3a.1
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 19:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783044515; x=1783649315; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3ssAB+EsfecVy0nswhEr9TzBhCh5UgDVB8vvd9e3u/M=;
        b=Z/chWxv/i8xMnUvt3/LH/9/fP4jExwZQX/QTTSZ6X++pCWZyKqZNqhWUuGx39nJDxq
         YmXCt5cZXr3aA5FbOduQoWLjbisYgrc5JRyVPN6CN7+FOIjjx0F8MaPZlQGm+7NCJl1r
         3vFG3/AuCTea3OzOFaS40/kCLkOG/DXqDgG/WJ1/vUtpLmbIjh84bC6uW9MEOzlXH9X1
         DWyXMiPNxG2Z3L1wBrg0Q3OdkraGCDhWBtrzjvpNGWxAQPGPIuQBfpGRfUqXidV2AIrs
         Xlt4m5bb4NcbnEosD6ft61cy3p/bnV6bA5w4YNCDDs3vhwMXqT1Qir2i6hgyGMbq02qR
         7llA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783044515; x=1783649315;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ssAB+EsfecVy0nswhEr9TzBhCh5UgDVB8vvd9e3u/M=;
        b=nVIMpMVAYDxXlalDoehQaQSiIsvGE6AZ4F3ZnSNEcwj9hpQQfA43kgBA731/YPsLIW
         GwI1N7fxfSd76ISPg6z1a8czaFfPDCoFbQ2iDAOMpiTlB/diqWDVv+ZtsAOLk1IcZkW6
         vrNozumIBvj2KANe+ZdZxnh2wQZY9GUcIue+0bMjz57g2ZEWTLzX3c54Kk3hnwxPBqGd
         el+VEROiiMpbqDEuXV65X7pxZxFjntoYeeWMZdSlQbpe/Y7a8BYL6pDX4o+hEI9YDyqS
         NvQ9OX/JZN5a0NIwmqHYl/OIBSSR8h/0KjDzeE6Dgmak3tiq6V6P6tt8Ed7SbAIgFMyj
         lkzQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqlu48mk6vJfo6LUCZVv9SgCMcBYLOur6f2jYctF+HtkNakVERugxErwN4v9QxoVW02macZxX1pfw==@kvack.org
X-Gm-Message-State: AOJu0YxHE6I73fmRTomVdSVegViByx35pTSQGy3+2tmZVMWhwSS/y+Jp
	4soimiY6USZeO2+cYaro3G9ydubjDDo0cfqniOzmRJQ+eFOxOvvBK6yDaAx6yoHU6HzkZdWjZPY
	IXw==
X-Received: from pfblg25.prod.google.com ([2002:a05:6a00:7099:b0:847:80c0:ec04])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e08:b0:845:48be:b046
 with SMTP id d2e1a72fcca58-847c0854fcdmr8315059b3a.36.1783044514968; Thu, 02
 Jul 2026 19:08:34 -0700 (PDT)
Date: Fri,  3 Jul 2026 02:08:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260703020832.1731864-1-praan@google.com>
Subject: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 69B41160005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: do4j4iaizqrc1iscgpyu4cijobkzodqb
X-HE-Tag: 1783044516-856538
X-HE-Meta: U2FsdGVkX18eTU5C+BY6/c5z488KVXF3fsh13/EZ3dcAdOTMM5GFfHy/osIAwfEw40ap5xYr/o//Pc+3LMskyvbqCyxdoFYUd3w160K1CIsWsSfPG4+o5hUu4pmH+tyw3Le2B8ax13YrLn4lv54JEJ9v51rs11ZpUjHHnd0PNFpCJK6jV6HL2gqGwsKeiDobBl1kUYWkQxVHrRIF3Ttc2SQxBavfsMzPOm/ltRh7Eyx1ShjCatWLGNwLL2bLDe+T5nRxE9Rd+w/lp6ZiDST+MNNmjsvdb//5nn5Kx1jSPgtwNTRS64vNA8KHIXuS5voelAVc0uxWBo9IAQSeQzSnQAKajt+hgP4VRwZAux2T/GrRe5sfSRoIf2N6ES+5jorJvQ0hzn1RGRfw5iNoklvD8eWoCks5vWTaOynwTrUO58zB+MQZ5aRKZ2XCBHrtaQaOST4uH/a/FMkFIx8LI53uSBHrhe9LQutolv7R4ZAtItTokBu4XrqUDZyI7I8yHjDwWPVnPj/23gTrfG0QSurXmdOt6VzTXf5o2kQWLuPkPI5q0Xuu+kyP1TUv4exSFCgq6AhzRiFCw+3c81y5bLpFXUT9bNHeMXNFN4q0kBcbkA5p5gd5CMHw9LJXaNNoYj0TlO0qVfAynR18zULN08Jt4GzhgbOGOfjFKX+2RPeHNAd/VIOAG2glUQfH1VftzFF93ystsmzk/id5YsrECEcWi8cUGacLk8BCO+5OXKeyHqAKPbf6MHeHkOVRx0RJ2eQdk2FVcPkx8h940Z1YIyrXXyGoyBgwIokKfR2u3s5zmxYWKUeQULOePvN8Ai+lP75fcVnwhY+ogDn9oDUomMAiEu5m03Lc13SqvAWKGjsuYLW2uYAZ7dZoAuDeqN4DrUnP0nSydq6xWdLiwQ19KGiQcGhHY1uucHTGjuBRpikUKhzO1wYenmDZCkDNCoQZUnJNLjtoUhKoP3hOuYavRb5
 QKn8ieOU
 M6rO8riiVdMquYZF7uKP5qReLMw6HWrDRyY1LeT/wedK8WR7PVJl7cXqLHUkMdj/nnNKpG9x34JLx9PVCzIj3MtRn0fTBHYZn/2PhdVcuaRz/OFdFAPA8U6Dzoabe1UyrOtr6YlCtlLnixWw6ThLYhSqLgJKl6a7hVLS0IbSz4GMPxvTCNYL8asTVyNtzEmVfG48QpzCxYcdDQXwkfwXHMSDesowj1hehERhzPpshg0D6KJBZ/7+8ZBzshkZV4h/h7TZuELME1JQC72YvUUu6LGirXOt3VLfBy2h7msWrp670kUHUqLUsHr7kgnv8aiC0qA9cVQd0+2YDsaqeeDKjq+4SilD2CIjw2fX3S0rdCkAkie+PJ8wun1WjMh8XLPlfEkiJsZmn0BrvZRTQJ2s0Q+cCXlBGZU3sIwTMRQPsfKN1UG+DCNtu5bNk28HYXjH1sT4rqCNqTGXCzCddLBJmrgW17qKz/+yzzIY5x473sGXq2qZIz1rChnf9okLrZlstogTResR6m/5okrf7zGG5idhh/qn9cCn6f+d3hQUSIvs0GYUvmiRn9tBNp7wJpleW3hbtpSfDQi+9wCdVAh/F9X0uCD4zVoRkOQfbn2n8oIGhWgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is required for the ongoing effort to preserve DMA allocations
across KHO [1]. It addresses a fundamental mismatch between the current KHO
restoration logic and adds support for high-order buddy allocations.

The Problem
===========
The current KHO restore implementation treats all multi-page blocks as 
split pages during restoration, i.e. kho_restore_pages() initializes 
every 4KB page with a refcount of 1.

However, many kernel subsystems, most notably the DMA allocator (via
dma_alloc_coherent), frequently return high-order non-compound pages. 
In this unsplit state, only the head page carries a refcount of 1, 
while all tail pages have a reference count of 0.

Consequently, when these contiguous but unsplit blocks are restored by 
KHO in the new kernel, the forced refcount of 1 on tail pages causes some 
trouble with the buddy allocator. Downstream of the eventual free path
the __free_pages_prepare() [2] ends up calling page_expected_state() [3] 
when is_check_pages_enabled() returns true (only when CONFIG_DEBUG_VM or
debug_pagealloc=on).

This detects the non-zero refcounts on tail pages [4] and incorrectly
taints the kernel while leaking the pages in question.

Proposed Solution
=================
This series introduces a "Page Type" field to the KHO ABI to track the
refcount pattern of the preserved pages.

1. KHO detects the physical state (CONTIG vs SPLIT) during preservation
   by peeking at the refcount of the second page in each buddy block.

2. The type bit is preserved in the high bits of the KHO radix tree key
   (Bit 63) and stashed in page->private metadata during boot.

3. kho_restore_page() applies the correct refcount pattern based on the
   preserved metadata.

4. A new helper, kho_split_preserved_pages(), is provided for subsystems
   that may need to split memory after it has already been preserved.

Considerations
==============

1. A primary goal of this approach is to prevent driver/subsystem code
   from peeking into MM internals. Drivers should not need to understand
   the distinction between head/tail pages or compound metadata. The KHO
   core handles this internally.

2. To handle rare cases where a caller might wish to split a high-order 
   block after preservation, we provide kho_split_preserved_pages().
 
3. The callers must ensure that the split_page() doesn't race with
   kho_preserve_pages for consistency.

4. Folios are always implicitly considered of the CONTIG type

Thanks,
Praan

[1] https://lore.kernel.org/all/20260505002737.2213734-1-skhawaja@google.com/
[2] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1370
[3] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1027
[4] https://elixir.bootlin.com/linux/v7.1.1/source/mm/page_alloc.c#L1034

Pranjal Shrivastava (4):
  kho: Introduce infrastructure to track preserved page types
  kho: Detect preserved page types
  kho: Implement page-aware refcount restoration
  kho: Introduce kho_split_preserved_pages() helper

 include/linux/kexec_handover.h     |   7 ++
 include/linux/kho_radix_tree.h     |  17 +++-
 kernel/liveupdate/kexec_handover.c | 144 +++++++++++++++++++++--------
 3 files changed, 124 insertions(+), 44 deletions(-)


base-commit: 87320be9f0d24fce67631b7eef919f0b79c3e45c
-- 
2.55.0.rc0.799.gd6f94ed593-goog


