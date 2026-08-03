Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8CFC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23F76B00BB; Mon,  3 Aug 2026 08:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFBB76B00BC; Mon,  3 Aug 2026 08:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9E06B00BD; Mon,  3 Aug 2026 08:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A99B6B00BB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:59:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C8CFC012E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:39:54 +0000 (UTC)
X-FDA: 85059763908.26.2BE4063
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf18.hostedemail.com (Postfix) with ESMTP id 638B41C000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:39:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KOjAQses;
	spf=pass (imf18.hostedemail.com: domain of 3An5wagUKCBsGI11E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--praan.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3An5wagUKCBsGI11E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785757192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=93Zcj2NXzxZtscFdS8APS888IZfB2IV9unzK92NNaNs=;
	b=ZeKfBysGwGCAaP4QkRW/Q7/YGi8wWPXXHS3DE9Y2n9STw/Y7kNt6TcGZMBaGgpFrEV7dJH
	nvmNVcAXocc/XMRpZYIZn+9GU65qWeVcmxy5gjFD2dRcPbTKjXmOSJ161eOqCnY3mxYIq6
	Q33ZzDFj+ESJrHf0FMNGgEAa8JYZvNg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785757192;
	b=SoqYjQWeEj4AybhjaYVKLGxwaqtQz+pbyI0zGQtl0miFApxkVv2aSA5l4V4L+rgQs2HJGA
	l9gShIcMviYltkkWFv0FMLLTOFvepmCWXE/Kd+5Mfda+6RvPvMNaQmMbrJShoS+wamWF2j
	pzvgKSNDw5OhNutuZ7JWq08s+YXkxKY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KOjAQses;
	spf=pass (imf18.hostedemail.com: domain of 3An5wagUKCBsGI11E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--praan.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3An5wagUKCBsGI11E7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb835525b13so4142629a12.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 04:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785757191; x=1786361991; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=93Zcj2NXzxZtscFdS8APS888IZfB2IV9unzK92NNaNs=;
        b=KOjAQsespRh60zpBZcBccOyCLESpoaC9LRZYe7n7JqaGNm+M1aeSN5MfzuQv/34qrR
         cp+H1IdL2yz4Is5oJ7Z+bqpHN8VaiUDEDlBhwu4se+7eEseojJMqSEKh0Do26skQyeeq
         O7SJK2barFCwgpUBDw/YIsuhkCeFQmPIRrLscPqyXKcxvw2sZc2BpcejE7ezp/3Nwt3i
         ch9hF8pbNSlIfx2D4Nb9vAERWwKEKHCmZs+kMo4p759bIlQqiMp1Y2gyiHSx8RAWW98S
         CBcREFzL5pCGDTfTB1TyICmFHtPiqSijJz1pRNRliKPfa/Hln5EyZB6NYw0TkHCkDqhx
         Wn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785757191; x=1786361991;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=93Zcj2NXzxZtscFdS8APS888IZfB2IV9unzK92NNaNs=;
        b=KGvOZNJji3fFcnzZsMmz5jyaBPd1e/1e7enAUPBS70+hOcrkBr0qOCg6hZz1xZa7nY
         a8KTe9aQztuhZeFI6yH9lJrGgXN+eQTly8hUr+9izQYyGwKOp4Qmlt9ylYm09t4+8ThL
         cdy3y4GndNKitpuurUBTvS3Vs46lD1un6xnP1qKOD3eqar//Y2LgV0Xl+Gv6oaCtkZDI
         1/aaUeYq9gNIis/2xb9x6zpjHchMy6xL/LxNWv+RZUy0tYesD7t/4uIuR5xUV90BMjLz
         4UPmBT3mMUQHxIvvllKho/ywzD7/u7fe6cGaInmfdc7TUhsuRxSP60tjgAp/t7rrbxDK
         CSzA==
X-Forwarded-Encrypted: i=1; AHgh+Ro0Epu8iKINDYr0JqsW82NhSzLidOWvWD4E0IVn2Ao3Z0ZNBs6Tl/GEX3LMmq0EyHHC6L/nzYRcMQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8kQpsfcyzM8nwIjKBkqVvdjk2q76/2pg0QHSCb81kblSQ3EsF
	OkKTiQyldKwnBf841HEP+JUByRK0peuK578P5d6m2CFbRQHK86AfaLZ1CYJFnlonqk3gtj9w9hR
	mzg==
X-Received: from pgmn11.prod.google.com ([2002:a63:5c4b:0:b0:c8c:68c0:9240])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:114c:b0:3c9:1c8:2b60
 with SMTP id adf61e73a8af0-3c92a94eed9mr9848362637.65.1785757186070; Mon, 03
 Aug 2026 04:39:46 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:39:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803113944.3694290-1-praan@google.com>
Subject: [PATCH v4 0/2] kho: support preserving high-order non-compound pages
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 638B41C000C
X-Stat-Signature: 8mttm9j5uu91w5b4w31e5ix6x1hz47gg
X-Rspam-User: 
X-HE-Tag: 1785757192-410973
X-HE-Meta: U2FsdGVkX1+wa1EwbvXD2Wj9/UdQ0eE05v6eOb/JYcfHO15DQ7NJgUuWi3QjpORcPzEdI2QhBbAG6Z288RN4Tndr655v4yOq+x+NP/3u7/2bRo7WThw81VYLRiI/uBx31E/77Z+87BCeZceroxsEFuoWs0nTH8QqXMH/sfdsa2ZLuGlE03KLkiapHN5tM5fvSN1VQLWtn4I1A55n0Ug6fiHTbRppHktdy63jbEj85fUpjQnw3QeHdAFWxHyOrD504e5x29DKnzvMcZfUasdEKcvJivo/lUzm8yexWyf8+cPf4rt3xaffKNUnDGRjHoWbFxA4P/cL1Qbw8hskoHTpwpMV7VSRszNNphpMyX3lJObyssX8xBIcrXcbqRptgOLRmU5u7GJTGywLycj3VI//tiTFBezeTOURkA5atB2ebsUZHkCt4QcMVyNqS+L2OOKjNpSbhvNia+0Sab12laqkSmpmwDPOg7uoDwzjgQ63G9N7YAX8vXSnQvZbxQ2/+dujuWyJzBsaGSc1c+UGC0oh7ZoqJg77+HWR7a9nK2SzcbCai+0A0fgjQ/8a6ouTQNIpRp2RfX+XzXM1/tdFYBnxNq3Dz4KmQ+SP3Q1I2ATE+DSAEESASHrqoFk/iz4w0VGVTTzur9sqEU1BDvSRT1DjBVKNUOdG1PlA6eiwNmS5RoJNGxKOcCXHdeLJLlagzsaJgNobIdvA5EIshJzKuBru8xDAZag5ri6qblIUPrB8vy3a+rShdsmqqOj9Lvi83Imf1PrxWjQ2hs22npl51jsFVDsnMK/aNKy7Mny6Vn5eK/DFKPr1ZqUhLJygoiScNTlY8Nx5H+NHc59UiGSnE6JIkxu4/DHDLFILTdoECNIzbkknC1j0ZObKfLFotyBvz6DjV4N0eX6qdKp7VpZru3i8EychEPWK8i52escqgzRdfT+E25128Sp3JFLwJsjEccMIyfvbRQouqfhUNaxO/n9
 3GwUzzVm
 62XCXpti/N/zoOvPBaROdzvEcXyR9Rt/mXI/fCKUFvFx0IYt8HgCEFjHAGnZFWoxTwXPYKzTla27MM89jpMNwj/YnYNTIvIdT97X/Zd9DJdGdU/MICa5RW+CRpgfcsD91O6O1jLzHohEJG+luteVS677Wggttprf5zmJzqxGamqopNN2uqYqBua6oojeDGz+cEypDO3NPr7qTS1vBHi69L+kbGgD2X/YB0NZVrXrpTz05H/7oa848ccw8/+hAwSXBootS48J/V9IH7bqqjN45nDOCZxu3/uvqSlacNk7boQMi3oIy2wt3w1rNBQj/8qGUpAw0Fz4cu15cwN0aLXgkHlC7pwqGTrLhafnb+Qbc0IWcAEesUregwwOFNI6djJILM4s7JlRxLYUbIAAPCoaicT9Bu+W7v5SehfyubDY9RiPeW0red4uKDiDyI1zmRmKjUxRcHo63aIn+uPnml42B+1fM+YSbGvwOVMWRNvZPH6UOLv1+VHuRIonl/jnJ5q3/I3EcrF34HFxkpUPL1ZG+3kzqNqJ9/or0E8iyn/Y+w7WM+3SjBV8nMt0SN6UYoDC9U1Aq7GIWWqSIp+HgxLBKpt0bHT8Tm4f+EyscPU3VJnPQQzbqZXA+sOzz4hOW2kY5zgSI1Dv7RfjLF5HBwddLy+lzCw==
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
restore APIs. We also consolidate the common metadata validation, state
clearing, and managed page accounting into __kho_restore_page() to avoid duplication.

[v4]
 - Consolidated adjust_managed_page_count() within __kho_restore_page()

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
 kernel/liveupdate/kexec_handover.c | 127 ++++++++++++++++++++++++-----
 2 files changed, 115 insertions(+), 22 deletions(-)

base-commit: 8ba098e6b6ff0db8edf28528d1552be261af30d4
-- 
2.55.0.508.g3f0d502094-goog


