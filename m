Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A689FE92734
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 16:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000A56B0089; Mon, 29 Dec 2025 11:13:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9B16B008A; Mon, 29 Dec 2025 11:13:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26D46B008C; Mon, 29 Dec 2025 11:13:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D1EB56B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:13:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B84856C07
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:13:51 +0000 (UTC)
X-FDA: 84273004662.09.687D388
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0D3BA80018
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:13:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf30.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767024830; a=rsa-sha256;
	cv=none;
	b=yeyfeOsqp1xr7mrZsOiUadnuHNtk5RkvkqVfS9r+xX9n2ipR7RgSZek2Wlebss2mxZ1YTj
	/8jaiUXw9tGqEbkASigpU5G+e8KnjHZtADrDjDssjebBIm74XBzjBQvd6fdlRWaHK/zOaz
	rKw8rqgcv6TK9olGEHoPSRiCNL6doxU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf30.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767024830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=6lnYMzB+dCUz+mkORGwbpkYC+kll7m3t+mAqWOhKrD8=;
	b=zQrn3n+q3/3YEFlIfS2YIO6fjfsA7csH0VZI5rlSpTEO6TF6MdurBPD3mGAEWVJh7BfKGJ
	9YqHVz5QVh0sqXCzAC/ybMrv89pVN2GIwQ44JycKDDlNs/OXMUHJCLdBHPaq1htBQv4fkd
	SkT9/uDSzkWNJmXNAmSDjxRgqzDftv0=
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-3ed15120e55so6542351fac.2
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:13:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767024829; x=1767629629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6lnYMzB+dCUz+mkORGwbpkYC+kll7m3t+mAqWOhKrD8=;
        b=t14bvgnooh+2ZAMGfgcODqagN0g8qvrH+kvDvCekXd/6UqaXzFCmL/Vzl7HORTSgXx
         t50gmuxdgLbpTkwgtwWoPsYRD+TzPEaI6591459VGHExu6GyOnxud+DwIzTtl+bPXdh+
         SP/dlWmpl7uK4X77sYxZ+domRIwTub4eON4EP8WogALA0TWe3n2LVRv2kr3OE5UY2A3f
         NyUOytin2ZahMDO1eJ6Dn/8iXTkhwWYrs65FzCKRuzGGAmr0dnbkPMjtlImdsZbBEs3l
         Jnba7Yu5unTvW1HPeJ0ITf8zIEOz+M4EeKdHy/Abn/iukScfC3bObOs/wXNRW5DiVo+Q
         ggHA==
X-Forwarded-Encrypted: i=1; AJvYcCVo6gidLBLqBBiJLyPV3s/Own8cZAKYHmgt05PKIvrDm5sqJD2nA4+WvZ3eVqotV3FWkjOWslrcVw==@kvack.org
X-Gm-Message-State: AOJu0Yz41LMQVyEH2tc4SsVMUDtW+rK1UlKIj5/ceUE5kswmUYnktA9+
	Q3gQKEO72HYzDz6HSp51/erqOXbAJFg7JQIzdTwodqX8nIXh/5G8n51cvEbgVkYLc78=
X-Gm-Gg: AY/fxX7ATaBls8yKDk18KZ9GO372GoqihgMieq97fk+Op81gu8QyLpyw54XtnT7F1+s
	JAZPx/O0xa6Z8mlzX0/odNPu4V7knMVsrB9F2+li6EvuIbpgkAdN0kZPtHbsNC9KmGG/GwTJvbu
	7kpdfeDVacMqv7FesYsvoRlbX5VMwYUXahaufvM9ieYemR6G77apyZhvf2beJeF6DSs9aZm6HLU
	HcivRmoc6UWh8hQvNqQLhEGz9JG5R+5WQPkz38h0cJWnMcZJ1JEnrcX9kjCJnzmHIC0YPeI6Y7E
	gu+7AV00DbQTkVpU0p9wKMsEhUhgW9BK7J1386MmU+TAWKYAfx10vfE5MfXnqpOhHagBu0vdvDT
	4bpT7pZS4G5C3ZA5HhZ9jRM4lFsOIwG92+JwK/VNSe49Tt1qy0RIcY4PhFmOltgBW+NFPJqpbkv
	DXorcn58rLTCE+hQ6b0188
X-Google-Smtp-Source: AGHT+IHg6byxM/xkxubE4jTDVkQ4ULmMFOY4QfJYQWgFM4sIg4d8O/EzQKPsy5ALE1+u/Z3o6zsA5w==
X-Received: by 2002:a05:6a00:9089:b0:781:be:277e with SMTP id d2e1a72fcca58-7ff64401115mr28062284b3a.4.1767017579562;
        Mon, 29 Dec 2025 06:12:59 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a93ab3csm29472636b3a.7.2025.12.29.06.12.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:12:59 -0800 (PST)
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
Subject: [PATCH v1 0/3] skip redundant TLB sync IPIs
Date: Mon, 29 Dec 2025 22:12:42 +0800
Message-ID: <20251229141246.63435-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0D3BA80018
X-Stat-Signature: dyaqaukapp66w8ukieydhyj3ozzi6a71
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767024829-887733
X-HE-Meta: U2FsdGVkX18O/0j+H7uPsSDoUDKeWtt0w+I0cb9bJdtuHYsofd15VlZNXOvCb053o+FoZBcx3luazBLt7ElK119lTt/PPZHFVy0GJi6Reb3DTGZ6pAdF8ii4Dk7SCYx9a4spGwT3C5TJI0/cSfG2cWpQiMWGOmiHBkCmKW7/nQoxgznhos55yv1nYCYN8NM7bir5aJgu2+qw/dcBSyBohxfHXMqw9bhfaWCpN8LEUfnHYmsurh0RW1aJJ8nJraZcqVgDrcAnnyOz74XnnoSZKVusN4uClr+3cBKla8vUFSs/yN2JfkaajahIOzk5WT/Ta+eJKf47gNAqtKv07hTq1A5k2YchrPP86XQoSO84BiIRQeT/PMgj7OeW17/RxNoa2fiyZtmO4JeYQt51cgqoqJ8SHZT5iU7nNKkDboIjb4EFLhBr5GXH1NfNq6y3dH8S6NJT28kFG3xhqXgU+poMmQ+6xYOYxYFnycikgRtTEwpMkbl37ribUzUe80I78OfncVbHQRXoVKwbVRcejCnQVh/6vpnnjxU93D7WNSfGN/fEUY4J6V/719eL5eijjnYIW1rTmBLYAfCLw04AyD0asQI6bYhjUSp0ovljD5nrWUf9F5L8aQbS5TqXAsy8aujlGPG9brt2qKIEnKhVsKOO0i0NxnJbjnUkXTGqYYoSvL2V6te0js263tE93nULm9wt+96ZTG/OnhZ8vukul+SG5yRzqRUJOYI0bjLxsfg3igCILxLO70mi0YzSeLrPnH6d6xA66VFD1cq5FS6dm+7YxHn0TfRSvsLzn/Z7cglb/KHts+rnfh+t9EKBEVEHjQQw+2XcdUxl0TFpRYvh+Cd4FkaQxB8ctWkTynvwsVbWpfzPK27m8gWPW744DO2+TpWMXNmi63m+qEDLyPRy7pMQ7LZY1xeVEZh9fz64ZCnrogPj4q0YGbZk+BZdSiXjhRkUH9ZsUJJN1zMCO6tU17x
 ZJL3efv+
 4CFM18lV5NEWz57XP6vSJtuWDn+y1+8gJQqUuR8ExwR/HIn+Rrd1UUn4fGcJgDR6kUlUiYGhuTPlNr/ri0vdWfrrLFaAc6sib1H/1W6uKf+5SBh1jDAJHLWHh6V2b3S5LjaBh2SO8uTzZRe8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


