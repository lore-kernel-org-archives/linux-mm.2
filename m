Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF4C1E92733
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 15:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399376B0098; Mon, 29 Dec 2025 10:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347456B0099; Mon, 29 Dec 2025 10:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245ED6B009B; Mon, 29 Dec 2025 10:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 133816B0098
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:00:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4B355F9A4
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:00:22 +0000 (UTC)
X-FDA: 84272819484.23.8B0943F
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id EEA5C100023
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:00:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf14.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767020421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=DI/SttekhGDiQM1tlGP5eL+usMVrVsg1suNc61YphTc=;
	b=qjTgAPfLFewmrgKO/Hd60jH72r4wDqEp19kq9UltIvB9phvu+FoaaLRFdviCR+J6gGdxKh
	Gta51tpnYXTOh03G+SaCE3ifVW25ijOZbBoROy+vG9JnlD4+jmeKvi2h7UHoZBtU9K4bVX
	7ZAiz+tQ+43D7qeUL4rzlui233Hitt8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf14.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767020421; a=rsa-sha256;
	cv=none;
	b=zcPmRwlOQDN+2oLVP7OTGloRBR5VdDb2YIl5fZ+bHDHn/+56lP16O2f2NW0+cNUSTgVq1u
	t4FBHnI6x7hu7pwYqgKcrnX6jACzB26bz3rNwS4JRlFfotgvnBdYwam6wmKgIiJ3vQ1OWt
	j8vwqW51h3U7o5cUVxt98Kz2Mh8kBQ0=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cdf7529bb2so1010663a34.2
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:00:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767020420; x=1767625220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DI/SttekhGDiQM1tlGP5eL+usMVrVsg1suNc61YphTc=;
        b=Iy66b61txM26gchR7MqfOPNRXSTiWNGbsmx1jeClmrmmnRLQQzi4r9t8GaEvTfBpaR
         8d/AWyDgoqaxdpq29xqu2hpANsUFQhFixMJUOSNHb32atJtDb9Uyww1Bm6cpyLy1dO58
         QmhdgS2p0428MeMFM+gX9cMYfTnRuVcQysE6KZPyMWRh8AjX9ld315LQ5yxqGtbfmNnq
         7HAFV9i9Jq6WIP8Nc6KRbQJCUjCZK2PJTmhUf1qNP1kuKQWWXE+GOUMKWPUK24SegEa3
         WnWR/XanxacwZpMsTPSBbT9RMcjHo7S9ydphAVTcWRdH9M3Zq9jrQFz+BtxBw9tJw9d5
         Wsvg==
X-Forwarded-Encrypted: i=1; AJvYcCU0OG8teP0co/lzjkl8/8yxj8bnr/tLIydzc95zmPzbA+uPl5hPcj+adUO88lHz2s88P18Qygrx0A==@kvack.org
X-Gm-Message-State: AOJu0YxioQVKJlsPpq3w07rh9swGoQ4hD9FiO3xNQW7HGeha+PCmMsDf
	hle5ff86fhKqiN2zuISSC3Uj5JJG/NNtBnUUvrjSFcnllFl2bx66cRIISobP8g==
X-Gm-Gg: AY/fxX4/q+UTQzUFBDyMb5CBZ8yETE1LhKCAVeVb6po6Se/vtJk1UXFKdu+j2dKzhnG
	8xv/O4E7OTYIqzUkWR7LQFXTu54yPma7CJXkOEsH4gYjvM3V8pK4mrPclojtOAztJDW5B/Atf8Y
	N7sXZTqh6O2UESRBO2FHsmJcroAKXogvS+nIwy9r6MHQxfKPhARA+pifAawjHhjAuBwiQWFs/+K
	tUqxrta+U+BVm1S0LkgpLXaW4XhVhZyke9PzYU3o32fh+OPesEN6NDbWzYRTUbUxA3eoa1kAIe+
	wFvEAmo3WVUwyj70+0HYc/8sUd/UradZuN5keR+vpoTGTd1ts+UGE68wRwFdp1qfOeTvZRWqrVP
	oCY6jROUCUrEwBAxdNnZpZcL26rruG2qhlbho2/6uz77Cn3mvemkK2tV48Ox4Y+4pwDypDlY6sT
	ePJQPf+qxdDvaVEyiYoIZO
X-Google-Smtp-Source: AGHT+IF8h2vXgJODZ7JZMxunWbJsYMMr6g5hSF24Ns6SSSKowIEhxB0xTevh9xlGxdP/5/5wrf4fPA==
X-Received: by 2002:a05:6a00:f99:b0:7e8:43f5:bd55 with SMTP id d2e1a72fcca58-7ff67759f24mr24454290b3a.65.1767018650539;
        Mon, 29 Dec 2025 06:30:50 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7dfac28fsm29705159b3a.32.2025.12.29.06.30.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:30:49 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v1 0/3] skip redundant TLB sync IPIs
Date: Mon, 29 Dec 2025 22:30:30 +0800
Message-ID: <20251229143038.73315-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EEA5C100023
X-Stat-Signature: pbzt6tjkc8p86u3ri3pz5sfu6xtr9hpj
X-HE-Tag: 1767020420-504218
X-HE-Meta: U2FsdGVkX1/p+MKzpDai+CIboxoa4f5Pe3n+tk8vr2oglFm+8FpdwckMQ8zqsxrp8PDTfdeKA8LA40ShGRSriio/Oc52IUVnWAXsdvkUfzAIKfstD1/Y5S2LH+0CHu9x0C0xGjeZtoG7J75cQNtyzompSgyEVJF54y4V/mbkPuJrL+S4QhcBmWDodJLy4r9J1bs0ziKUHXnewlXGlRjTTzS4zL+4WQ+5qOK9+QBXg8dn8fTGa3vlAM8A+5aWN6yXsBRRcDZv8oXNmTDt7BbtYAWSs0XHBM+yD7b7gzAf5PfRqUjIQctbnCiTIrY0ilkLL/rJ4ZGJqJCeemua6/5AUMnajD7B1JjQKJqUSlHV8w4Bl2FYW5SyIYnVbt6sHBr0ioAv8ejp4f7LdgFQ/jb33zy7QQWMSawN/rwHJs82pheq0itO/60puSDK6rxFg8/P03Tck9p9G11lZh0/zJn+EUpgZP1D08cLzsgxWy5dwpn40SJUNwzATYCjasGNBWRnf2ZyMawjbhCg5ie0rsoAFm7h29gk6h2l1258p4qU0C/DCm7Z59wMOcW/08Y1TWSHGI5MjYCzCO5fRE05b8lEzQGN9wwVFMFKCsbmvBPL/QWy7Tl9LWAyFFe8qxR0PKwKH0BdcWPIZEBawYnvjT3c2nIrSK62i5BjXBPQQ7uCiLQvQP0wg5DO+jPBAxMGs06vLVvz4DyyRcZpMP7mTlEsrOVvpllLD2rQ0YtBfOqF2KKSwZqcwJ26Yuw2nGQwtm+fvG6Bb5kOb+C3pQmhes0QzZjrKIBQhDZjx8oekWSueuSDopa0H43WRmx3dp9BZAQlWl2PiKdVcQdC18DD8OBkXwqVvFVRkiXDS6Gqd++9H4HeaZgx5vgGXuhOgDi2F3fykmdMaQdXl1AzBRDzbxQ6NeouFh59bJRxgiEK6CxsVt5fB7i5Ne43E3rvyZQjypP7zJBLhMSAGJFlNVvzEbb
 IbI2EJbF
 teonIAd02aHoenx51b8rPob/zEKFFndTST6VWEpyUQJreVG3gcQ8bkRjrk4KHUisqr4ZUAl3bEjillINF3khrzP8UppR+TYvb7GTWQxiwm8A5lOtOh5UVQZYWt/ygX8tbhIncMVFr7daK8+I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Hi all,

When unsharing hugetlb PMD page tables or collapsing pages in khugepaged,
we send two IPIs: one for TLB invalidation, and another to synchronize
with concurrent GUP-fast walkers. However, if the TLB flush already
reaches all CPUs, the second IPI is redundant. GUP-fast runs with IRQs
disabled, so when the TLB flush IPI completes, any concurrent GUP-fast
must have finished.

This series introduces a way for architectures to indicate their TLB flush
already provides full synchronization, allowing the redundant IPI to be
skipped. For now, the optimization is implemented for x86 first and applied
to all page table operations that free or unshare tables.

David Hildenbrand did the initial implementation. I built on his work and
relied on off-list discussions to push it further — thanks a lot David!

RFC -> v1:
- Use a callback function in pv_mmu_ops instead of comparing function
  pointers (per David)
- Embed the check directly in tlb_remove_table_sync_one() instead of
  requiring every caller to check explicitly (per David)
- Move tlb_table_flush_implies_ipi_broadcast() outside of
  CONFIG_MMU_GATHER_RCU_TABLE_FREE to fix build error on architectures
  that don't enable this config.
  https://lore.kernel.org/oe-kbuild-all/202512142156.cShiu6PU-lkp@intel.com/
- https://lore.kernel.org/linux-mm/20251213080038.10917-1-lance.yang@linux.dev/

Lance Yang (3):
  mm/tlb: allow architectures to skip redundant TLB sync IPIs
  x86/mm: implement redundant IPI elimination for page table operations
  mm: embed TLB flush IPI check in tlb_remove_table_sync_one()

 arch/x86/include/asm/paravirt_types.h |  6 ++++++
 arch/x86/include/asm/tlb.h            | 19 ++++++++++++++++++-
 arch/x86/kernel/paravirt.c            | 10 ++++++++++
 include/asm-generic/tlb.h             | 14 ++++++++++++++
 mm/mmu_gather.c                       |  4 ++++
 5 files changed, 52 insertions(+), 1 deletion(-)

-- 
2.49.0


