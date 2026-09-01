Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E601BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C216B00DD; Tue,  1 Sep 2026 11:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3306B00DE; Tue,  1 Sep 2026 11:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C046B00DF; Tue,  1 Sep 2026 11:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9BE6B00DD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:18:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19D7540436
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:18:33 +0000 (UTC)
X-FDA: 85165550106.30.D635DFE
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 528B180002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:18:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kn+BF6ja;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788275911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8WFJH0ESiWBm+RbvdI7K60WSeg5h8yrXuENGkm3xh5c=;
	b=iagA1jmJSNzfqu6vtAQdNkB5yjIF41iVJ0IRkGEToffwl+CiwbdVnfTQ2IQHigOMRiXB8P
	9pJP6CGFgaceob1ftAYoEcU7kuootLjQeVURiRYCFVxeq9bsCTe8EE+Q+is0PfD3TRN6BN
	uFrdlGM6G9Os2SdLoOrYzL0bXkjyuq8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kn+BF6ja;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788275911;
	b=L1C3XhlOpmp52Clfju2ri3/iGt+3DA96JjcA+HR4DwXA19AERzXd+F6d1fDNs0MA6ubGX/
	i32et/XrLWadAcF/rK8vKk3olS8vupkgQDKPdxO1AVMlEWBNyo7Z+UlZqXE9ExXhH/MHIR
	wyGGMSvfWAngSRWjD3k2Kuz8bFvCmzY=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8552619b869so297878b3a.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788275910; x=1788880710; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8WFJH0ESiWBm+RbvdI7K60WSeg5h8yrXuENGkm3xh5c=;
        b=Kn+BF6jaFunYL66jx5u7tRIKJcd2mIqwM+B9bAr2YGX86fLNXQZgjRHSy15VG6l+Xo
         4y1+N6WtEBevtNsUkJeclU9zgEjcIBLGh0b/6WPGxXEQQIylaC3e5E9Py0oeG/9jzcZH
         p81y9lIA5YKlZKrDCnx+E+AqmL2dRzgD0xrFRSiJM1W5bQ348H9VLMCvwSiQyJCuqrLe
         qiX0w1pGkdrKwqd6jExDKUS0xT+7J+qQKvOupJV8CzYak8ACPgdr+oZOLkbXNbSD5CV2
         S4XXEySj9uZvKdchN6AacXZ4sftesAGzIuNqq1zGSpwihE79xhKC8zSalwMdZb1kCNqR
         /ZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788275910; x=1788880710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8WFJH0ESiWBm+RbvdI7K60WSeg5h8yrXuENGkm3xh5c=;
        b=WalZnXnUFljQLKU24H/zh1ctbo0BJAzEaqDcQEbJwoFA7nWCRR7FSNzlBdoC4bMZ4O
         g25FRiTkiluZq8GEIDv0bFBxnFdTfEItZ6ym2hM8HZHTITcMShwywXxi3EtAGP2W8FOb
         0CQ3ddbLnIMaLmmUk48HZch5DSDL8UMt68CEhUIAdZs0suNL/R24BJKvveVJJENqoNPN
         wybak/aSMXPU2+dEPhb3XRu7qCuAgN7wBQIBE3sgTboux05GF6fMszmv/GApIkX2vOKU
         C0MrsVbQ8Eqwvv59dp+lfrcVv2vHYgncG3YwJYfVvgWTaXJ2Sr3ZItvBrVErMJRT+8AR
         aBAA==
X-Forwarded-Encrypted: i=1; AHgh+RrcUIKN/4coEprOu2wmxiVew41NGAgUztCAYRgUreYgzVtYOoMOFSAa/e5MBUqD8wPN6MTypTXBoA==@kvack.org
X-Gm-Message-State: AFuF++lBu8OL4OGZ5oSsTUs9B2nFk2CLuiJJDvfGbRXSZ8jwVc8dIYGQ
	yiUrXaHPE3x0IKNwdRoY9DXgYn+DRi5EDMYT+dojP1k7mVKgl0Dag+mz
X-Gm-Gg: AR+sD11c7HCPjdUhgHNaTB28wlR+FoEn90LCqhq+2L8H4DNmX55uIkZf4JMN8C9hQDk
	eLkt1PoFjK7JdO6HwfqMFGZjWOO2JJa8FwC25XGt6lrzAW+U/rPt1Gb28bH0u2qvpy6GcqX08LZ
	eeLIw7XLGYTq+j1zseV8/ARs3k66jYwu74PENYTp0DPBSDCgQJzv07LbuWk/Xo4nKgu08fjNdrQ
	CGvArRAUGazeqaN9LZYSXb/k8em3f4DD5Hurct5Pb5Ttu4pRi/TaaN0P9uw8eazy1bTk+MXVCGi
	LRpS/bt8M0K51ZQIEXbR0G59+IKxOrJxQPnlBRN+xRWwJJ4tzAnRiWpinUXy3Ucq3J7+XWJYHrr
	o0IfMfqlM/TJZJdnj8wwJ+DcvcPGssEz8fQo4HHGOaDQY9zJS3LAjrmSCKnpRaogLrGHlJJ9Irk
	m5BVWgR65Yzkol95N+VZoilmczJVMDi+btynHy61ikmqi7XBgYtvDaeuBIL3+yxBZeFUTR0Aop7
	WkMhei6/VviSKTVdDi3N+wRbg==
X-Received: by 2002:a05:6a00:4a07:b0:850:a86b:6ce1 with SMTP id d2e1a72fcca58-85625c2c844mr22271937b3a.0.1788275909909;
        Tue, 01 Sep 2026 08:18:29 -0700 (PDT)
Received: from o6.lan ([240e:391:ed0:47d0::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f33a0sm89911b3a.9.2026.09.01.08.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 08:18:27 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	usama.arif@linux.dev,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	kas@kernel.org,
	rppt@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/3] mm: make persistent huge zero folio read-only
Date: Tue,  1 Sep 2026 23:18:15 +0800
Message-ID: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 17x7j9rogsaa4yaayg47b8kge14ydzt1
X-Rspamd-Queue-Id: 528B180002
X-HE-Tag: 1788275911-616295
X-HE-Meta: U2FsdGVkX1+NbQc9w6IVQxokepk41ez0xk8b329NY1v9E7gsxuCsKivFXWvt1Ha2pVd1opljBSIA4u2Yhd/gbnKbA6cAlFkW3htYWwvjdwxmZNYMKuM95TaM61dqfeEAwsXOkKU0rFIRiOLsN2CYlLlkwAbb6RYUch4X/sRXFQQvCg9o64cbpQf7IAHJ1odzhb+MQ7+sZqi2ZvOEKEOlLelnJm8g74hya+ym7Rldp8Ghw3/W+msq3JkuPXXnSY6H1OD7CC8UfdMuIfohlkLdzcCxXXM/ZPSAMuqhVCxhsjH/YS5OBQsvwkg/8TBfJRhJ7hc8H8q3oQvt1l739oEgcOfFLWwYWg+FyrS5e0aW7CpIsVuspbbT6c/pT8Cwn++20Em3p55m77wBVJbNOTK2sgA7NyujuXMc+HsIE9MNkt4I6q6v+vOTI3JCP90znpBd8Xwkg/JXXOeK07uabKTLlt83fVf/57CK7blszDlpmDglaVZPfZiDtaqJ+bXiixZMLWcVYnoSOB+iO/GXix9xmJwgZEdEAg5uVSuYs1v8C+mPR84gcACD1GZf10sp+i+CkOK3sgaM8UdcuWRv/KXcLvi5BI5ncq/8kyA/buI7EAKL9s0Tfz6vi7q3oQE6sOuDb9qcdUipP3vXu21PdS5zXAxd/SDbsoX9Yppu8ior09CBMh96UMPDnWwZg8iUhdl1AN4CKp5h8j3XoKLu/z9zjkOAkC5m1PuAHv8yEl/wrLKdxHPm88SpmMuas7MeywToTaABl2axFy0o9ZAbDyC7lS8SUJ/xJpy5JmdbWZT99zJjPqf/iKdmS4pQ2Fn5f+UY8vGl38wrj2Tq1V/gZ18EmdwZX55+YsQD1ea9SY8716M8Ko2WLHdWLU2+veft4HhhvjYr4KN6XmJSz9YpcJgXhNNS27+b1lqGY4vQueseJv9YQBVZuToflwninKH608Klh3GzH0AnKbv4jzPA17r
 nPx581Qu
 hYvxw68g/tPFGF/6a5jLrY9kfYgBlDkgrNHpZXoWfEa8zlQkN+DiC0S+/xIM0My1uTXOOR+B0DZsqrG9kgM1zY+qH4ylj6HayKvt9DnWX7hs2+iSnnXLAkTei+CHVf0JYpB6ZCjmz/r3beePsxEoa4NYGFifm7CIxcoV/oILrjrKzYifkxlbe4sZNf0W+RfW3w4FCza3UVhHr+0FjJUzPnV/zvovX402Z2DAXV5FzgXbwxyRp56AUKepMn1NXodreI/JDBs3W2Zl6lgjdLqi4v7hbmpBffVhPqzUdzVkHONTtXYIxY/OHgVZGVNXzvxu09yWsa/zu7kYcNxdXIubOte4CfEATbeG32nrecMCgwC6laQCl11oawDGK8TJtEeHWwfR1nzLvvh8ae8+F7NMuFQN7hANXd4vqVNDzgxNS2aRISVzXib8p8CXndfIgGMDi54JQb6qgTBogOcDFlfqTviR81g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The persistent huge zero folio is shared globally and must remain zero
after initialization. As Jann Horn pointed out [1], kernel bugs can write
to pages that are intended to be read-only, including in security-sensitive
paths. Protecting the folio's direct-map mapping turns such writes into
faults instead of silently corrupting the shared zero page.

This series makes that protection available to MM code and applies it to
the persistent huge zero folio. It is best-effort: arm64 and x86 protect
the permanent direct-map mapping, while highmem folios and architectures
without support retain the existing behavior.

The interface remains page-based to match the existing direct-map helpers.
The wider address-based conversion discussed in [2] can be handled
separately. Permission changes and TLB invalidation stay together in the
architecture code, avoiding a noflush interface that is easy to misuse.

Patches 2 and 3 add arm64 and x86 support. The approach follows the
huge-zero-folio discussion in [3].

Link: https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/ [1]
Link: https://lore.kernel.org/linux-mm/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org/ [2]
Link: https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/ [3]

v6 -> v7:
- Rebase onto the latest mm-unstable and adapt to huge_zero_init()
  (per David).
- Switch to a page-based interface and move TLB flushing into the
  architecture implementations (per Will, Dave and David).
- https://lore.kernel.org/r/20260730090647.2401252-1-xueyuan.chen21@gmail.com/

v5 -> v6:
- Patch #01: Skip the direct-map permission change and TLB flush for
  highmem folios, which have no permanent direct-map mapping.
- https://lore.kernel.org/all/20260727143426.1077133-1-xueyuan.chen21@gmail.com/

RFC v4 -> v5:
- Drop the RFC tag.
- No code changes.
- https://lore.kernel.org/all/20260718095647.182592-1-xueyuan.chen21@gmail.com/

RFC v3 -> RFC v4:
- Patch #01: Flush the direct-map range after changing it read-only, since
  the folio was cleared through writable mappings after SMP initialization
  (per Usama, thanks!).
- Patch #01: Keep the flush in the caller to preserve the
  set_direct_map_ro_noflush() contract and make the flushed range explicit.
- Patch #01: Clarify the noflush API contract and the reason stale writable
  translations must be invalidated.
- https://lore.kernel.org/linux-mm/20260706130440.9295-1-xueyuan.chen21@gmail.com/

RFC v2 -> RFC v3:
- Patch #01: Replace arch_make_pages_readonly() with
  set_direct_map_ro_noflush() in the existing set_direct_map* family
  (per Mike and David, thanks!).
- Patch #01: Use a direct-map address and number of pages, and document the
  direct-map-only and no-TLB-flush semantics (per David, thanks!).
- Patch #02 and #03: Update the arm64 and x86 implementations for
  set_direct_map_ro_noflush().
- https://lore.kernel.org/linux-mm/20260609143801.7917-1-xueyuan.chen21@gmail.com/

RFC v1 -> RFC v2:
- Patch #01: Drop the READONLY_HUGE_ZERO_FOLIO Kconfig option
  (per Dave, thanks!).
- Patch #01: Replace the huge-zero-folio-specific hook with a generic
  page-range hook (per David, thanks!).
- Patch #02 and #03: Update the arm64 and x86 implementations for the new
  hook.
- https://lore.kernel.org/linux-mm/20260527035607.14919-1-xueyuan.chen21@gmail.com/

Xueyuan Chen (3):
  mm: make persistent huge zero folio read-only
  arm64/mm: add set_direct_map_ro()
  x86/mm: add set_direct_map_ro()

 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 12 ++++++++++++
 arch/x86/include/asm/set_memory.h   |  2 ++
 arch/x86/mm/pat/set_memory.c        | 10 ++++++++++
 include/linux/set_memory.h          | 17 +++++++++++++++++
 mm/huge_memory.c                    | 13 ++++++++++---
 6 files changed, 53 insertions(+), 3 deletions(-)


base-commit: 88297631d4d42f6004cb39c0ba3da7d2d10a616f
-- 
2.47.3

