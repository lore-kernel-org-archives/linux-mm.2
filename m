Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CDDE9273E
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 16:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1BB6B0088; Mon, 29 Dec 2025 11:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8A16B0089; Mon, 29 Dec 2025 11:35:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4B46B008A; Mon, 29 Dec 2025 11:35:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE8B6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:35:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED7DE160287
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:35:22 +0000 (UTC)
X-FDA: 84273058884.11.E20B206
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 23CFC4000B
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:35:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf01.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767026121; a=rsa-sha256;
	cv=none;
	b=q/n/vFpJMz70sjAPvIwCnKZnYMzQLa8QAKhC8egD+vAi0RrdFRS7/dQml03knytd6xWfwo
	ioceMgA4+7wJmjmHDYOUL0d9+hNWTUuMWYBRyeXm/X9aut08n5UQWGRoTNt+9jp1Mi6uaC
	B2CAA9F6NL7i3QLnFzwemnNX1JPecIs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf01.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767026121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=rSXDsPw9SWpPdwz0G6LJLeCgBG0923yYOTzxWibmOZo=;
	b=vJxQll4z/g0NDDCmI/YjNNnoC4yxMfRYjadv5CVN1At5jUWTm+QwuzIsheJxQS/oKEqapk
	JJOHzk/Q739+t3M2SbnNAittqJ7vTvOybswKz0lG59z/nDj23eGGBZlIuqwS6N65vG6blX
	66WAUcwpfppsHDsgfi3lNyImPBu3xz0=
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-459ac606f0bso1933114b6e.0
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:35:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767026120; x=1767630920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSXDsPw9SWpPdwz0G6LJLeCgBG0923yYOTzxWibmOZo=;
        b=c04miE+5DrCgQjruzw3CXmYIiZulHuu/UzBLUHWkLkY52WKSy0+eXIKuF+tnYIfuFt
         /RC9y3qutkeunrTSdlB74Fojm64ibwLIjXMOUSjPa0As1qEXcAqMH5k8TSwZIYqVLGUU
         fK4/ViQdUdFtjCXf8tNjYiNP8CcE47zX/tXDx49HRh5S6BzSy00N+kXzQ4nL/fbyygoS
         J/drjjdAfDIHCtKEENrBhIV52ZK2FM1bu2m3Amy6Vmv7t5b9jZjEckkQgQojZpmy0ISM
         LnQRgvFt2grBxKfcUJ2DLQQJy0jsS6QaR27Dak7vpaie9r1vNIubE+7fJe0F/qZMmbsb
         lvJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtJ9ZgXWLIzt7XqnTD8NDOdOQzSSVwpH4nGVhwSF7tRKxWdakDfT92EuB8BKcuFux/uV58E1YfoQ==@kvack.org
X-Gm-Message-State: AOJu0Ywrzhdziqy2DGrb59WUatf+bZRKtd5zXh+a2b3NFFgo5mTtMoQi
	v3Ua6as1OgZuCj3fm9AiTvimrOTuvx6MTHxWWdOkCZUl1S/S/cpS4hPv
X-Gm-Gg: AY/fxX4dCar88CF1kw3fypFUSc2JNZKM4HMJL32rxZyhp91hD6PWzZQ4l5sERqJ8dov
	JYyEPC42NP6VgeHbO1Y9bR7PMRMN++atgLUtXBH3lvO5wwRokH43lE/8xghHcgJu8x7fARpiSto
	B9dGyzgnG1xBMfzNh558H/nKP5nOpQ8e7W3doYxgBar7dgqHdP7SHh5XP+uYS5g0hmJ6fk4WXAa
	Qpx4I9+SeinZ2atbr1h/0GTNdQ9ySb7DK8B05ZmbNox+Jj3Sguf/RBr8reX03gXMJgEYiqDQvHB
	s0/jPt7WR2IPo/xXFJSlXi7Tp1RX2GnrcNZOHLQEULEsJ3ao8iJFKnd0nlw7YdJye5FWCaMd9VA
	TRl9nM327TDwMNMY0QWxlfBTqSUG1sb3yvTjqhUiZOpdLYhSb9tqwYaOpb0jyxE3MSKpL7ly8bs
	FAi0gtxWMbPTDpvJ1c7hC6
X-Google-Smtp-Source: AGHT+IELTW1f0I8nau1FRdD8kDyAYgeeHou3baqoPeRrgIvEnjXylw0MJkmOP3DRvYb3odQ78YmLmw==
X-Received: by 2002:a17:90b:1e51:b0:341:8ac7:24d3 with SMTP id 98e67ed59e1d1-34e921f6c8cmr23662117a91.34.1767019978519;
        Mon, 29 Dec 2025 06:52:58 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70dbcb6esm31557603a91.9.2025.12.29.06.52.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:52:58 -0800 (PST)
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
Subject: [PATCH v2 0/3] skip redundant TLB sync IPIs
Date: Mon, 29 Dec 2025 22:52:42 +0800
Message-ID: <20251229145245.85452-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 23CFC4000B
X-Stat-Signature: qsyo4hssy1ffjcdipb7imq3yaym3bwqs
X-HE-Tag: 1767026120-502641
X-HE-Meta: U2FsdGVkX1+Rbn4Eo5OzvWRr1cKAeTs2nZ1Afz41DnS+rqMfU67HMZx9Y50xepKGHXKW0XBhP0/CvEcHM66oVtVTzKVniXGmcrdR4NxJf/HKgE9Z36dB08zNKJ6vtKSTNnCDUj3DcWYnHyGm71WLF1YMRRySWUJdiBL8pEsYpOE8j1i52EbJiJpOaYriiz+UE7VObuyvJBHEmsmXzZm8QmQKePnvN8kkmbAcYg1xUJKCZWZJoRRa4642eDvZjt1yQLaG+KCr1l8NFobBbnby7BvkoizDwGA718HMXT6OKsaOzP5bbZYBL6IIMSN9rTiGWdS7PbISPQp+AJGWnXKdHvIgXR7ENG+LxUYXfHoAUsUFI0j9Dnbd50Ol+8OhBhsU28AIRE5oloC9MocKGidrQNM4ysxUh1SzuANYIdyKyAiHFzj1A88+16Bh04a5HAprSADNhAW7RjLapet1AWzZo6b1+ugyG1s6Mprlb+Huz5S0fSNPerEpuKCqU5Vb4tnISBpyppNkR83VlUUQaQPBUrDuv+M8Wa0wsh1NOh5fjV/EXHZY28Y7pDNG9CNY84lCKSpcHKbJRAmQDcmK5ZE51o9/uBebYItqSb7e/Hi0q+P1TzBCKVFZZkBnmzQZEX+CvjrTfab4UMGwWA5wqnnRq27LFFCC82Qy+nWCrs98gvlNfeArSNK5ivNU+Ow1GaaxY3gEOaIkkIco7lfObJ0LfdL4z7eD/rkDUvP7mwlVdFsePfh+k1Tres9qPcz4NyvF0b80WRIJRoLYfzd18QcMF+B1cVo6HNmumpyy38z/1wbL9HqV6z6uu/fkggB7D9+z4l+c7gd2SIljOvvFpCci+wI6B0HvB7UWyIouhz2gEsLt/UQh02muUxXDxCRnL/WQQkqHYR/llAjYURrqW5yUoX7LaXSRC+XJOs4RmjjLYmnFVfk4hqtYskz86PWGhmFGQMANcWdk/7DdzNiWTx5
 oY8LNFV3
 cGD/zIqmuxZlGklUkcWtDfUATSKUqFv/MCuekGdJmF56k3YxnXnEcki1uw7sxwUOtQP4aDJooQs5iY831/hObCr+/MRnjAooBk9rSDtoYe1d+KbeFwVP8LJ+Tp/VraD5X21cALZ4ISB/qBGYBYUNdbw/neFjIv842WfbjjvcYTIVA5G210Ki4G0LQZ9h6c5kTY8ivo+XnuzhukCOUNcSUGtzbMS8CRgk5rltjdqn1UHH9Rz14M0xIqXR89Yf3LwowVv5OcUQAJqhj80og2KNv/fUhFfhjNBZ7cdxN+R9zJ2b0jC0Uf4y8WPP44XW6Yr05Zg+pJyK5yLA385N9Rn86nDD+SSlgB2JCQgXAEHvEWme/bgfYhw4PVzI1AJnD0TGU/SXo9mA6vjks/JV4HoY7cXh1udU9V0HnkFlNjS36eCyuoZOg2JmnfT+J5FvoWaZ3ORpLR/mqYEksl6E=
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
relied on off-list discussions to push it further - thanks a lot David!

v1 -> v2:
- Fix cover letter encoding to resolve send-email issues. Apologies for
  any email flood caused by the failed send attempts :(

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


