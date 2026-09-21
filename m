Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E58E8C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B966B00E7; Mon, 21 Sep 2026 06:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3C436B00E8; Mon, 21 Sep 2026 06:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A726B00E9; Mon, 21 Sep 2026 06:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7766B00E7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:56:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36030140110
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:56:54 +0000 (UTC)
X-FDA: 85237466748.20.0EE8016
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 697FD40009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:56:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Olwk11hT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Olwk11hT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988212;
	b=y39EWSnathicvby2eFjY16mipOMAy1DH5++e3SgxIj3nBvQzFBKCASEZGhi5wrsbi/H8+G
	QoTva0vnqxOSMbWnN0a43fuVH+EYY35brt9NS5q4qq81+VlrkKEIIcm/tWdoUCkXcF6WT4
	M1Nqh8dZOdegKu95pDkZaoA8L5VkpU8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJr4pyTBUPDwtFxqouKNlkLHudO0sOE1ps0QHQE9jbo=;
	b=j3QvwR8caTS56Xg69h98CBppVvNQAX1aBy+pW/qWRcTf0+e7yVTE8Yg1waH+Xi9luKhb2P
	0BqIPVO1XP9RuBDc6rx2WfGS30af/G+1/c6RCGBu/keICFqKquczJQczQsFHMWP3dtly/W
	bQ0SWuor5XojTkJCYX7HBt0rjYBMyXQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08EE71DB5;
	Mon, 21 Sep 2026 03:56:48 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A0CC3F86C;
	Mon, 21 Sep 2026 03:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988211; bh=pfH49/wekZWH0tUlmAGPYfXLPMYhwWIki53rOu3JrVc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Olwk11hTmNoCQY0yieoGRI6nr2tZK+9Y8vNgJkjNBvabvI4jw3ecE117CoBDHRZcA
	 VaHf6/WYeKfqcXLlbCGFFRZ7VeZS5wzBGURhdMIHRzkGy/szUC29S0SOD5k+/st/hm
	 ZKDb93jOuQfIb93pn4lDETSPnOoAPOixVE8trrQ8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:25 +0100
Subject: [PATCH 03/21] ARM: mm: remove custom pgdp_get()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-3-cd40cf68242e@arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=794; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=yi3BzhiHjasTHpKXh1MmDEBzfM1jM8lRPSh1W8s2lTo=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1MhweskEeRkdPnGVTUHtMQosteIoTZTcWZ7
 m70DkNoOo+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENTAAKCRBt1cPRWsUx
 M1pdC/9eWcL8m/evh/5ze5hTI1UzJJ9731T8JXRUtUacBadzNoIsOzFTtZcP/L/LZXeSCg+qPJI
 GlkbXXgrRzR0Y1cTWBK5XsScCAxuXdVnmkam0g6EpCc91YkNc9mg0Xvj0hhcBeYo5b6yy4EcsGk
 Eqqr8Kdfj+dow9d1FDFwO6RPyIgwXw4NOvVhy8Ye1AtUMFp57bmqyuyzFZvHE/b3dh10GbTVvQl
 zd7uAbnS0shbhwLl6nwID4BUlrc8uNzszZy7xbLQD7VD4tzIl0LPHUN1JeJoAiLWd+i4ixBSnNc
 VKFX7FvI1lzQ6+mpKnBPOJfihjR9O8/IFykRTKwpakx9mvghn3bIAmuYr31vKk4LmF6NUC3WKiQ
 lchWJeCYXYaUqbEhxl2y760Y5hHJIi1DIDkUYCunpdebAxongZeEyzxUpcxw9e005xG4lOa9qP1
 //r/dM5ak9J8No9Oco0jmCsMc2ZGFGwv/0xNxtVsYmmZoYo8sBtsLujJukxT5yfXw1zC4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Queue-Id: 697FD40009
X-Stat-Signature: tkps89w8b51fzoz3j1rciqj9psrhqm6s
X-Rspamd-Server: rspam01
X-HE-Tag: 1789988212-659425
X-HE-Meta: U2FsdGVkX19pVFKFP4TOkx+osrhR0iHGiCr64pBVA2NTcpwgraXqLMKvxPQOKcUOYAP4c9dmyh4t9THtzLZs9IXg7CCBTaPUX+AGmBZjJDe6EA1n2uwkASeNoE+peNfJTWJWPUmVPW2u9ZjNwM5Cw8NVANzQOXJ8FhuDUKeAzZrNWsbBt9rjsz6jjAJczgYCpit48lStrStAvspVXGusn1RN0sY1AjBVlojYtkfvTmh3G21GcaubmHX4OyGCTwctQ3Pre2ZaLm1R7nQ8RAP2VLc5IanAiZCC9JKrd/j0tLFshaU5FYOXzalKU7OQpGmYxDYWlEVYgofeESYCy9xxuVdFNO6WDaPH4qk+w0FWr0QcEJnKSJ0wk754DaNnqGWK7qMmCbUwah5Q04LOHKD1UXcqRjBoVqEgp9r70j2BRUbDmAndeHMU2OQF1VU3REDc49EBTCDGt2tdjzKMQKU4mKJqg//+97ReHzIjGutneVwnNsOzXWqhFgscu4EH7pE90YgdS2yxmDkyS85NFPR5PocjkbHRRSuvrfOXz/tiO7Fmlvw2VJNNQmGbkAANtQiADGR7cICaxQuMnaA0i4lhtCyuLtw8IBrzvk9qIA5gvY0wUhEFMT2s8QNprtHbsfB+gcXKrCyQOQWmZlfaJlT829XbYrMPhs7YFv39OOPgJeHM2b9hCa1zGgLXEgmwZZvWrhZuQKi6EYhyhnhWMlemAZsqEFPYVtDBa/VVDYzpYio9/X28uoIPIZLH6MBQ8uP0Hcmnp8mNiwdt//qPkwXLuaBBuzZMrDn1v4z2WwJZ6TBno+KT5UCpOc88cgLZkgXAJOt7x6pl/YJARdK0hrtSggoFx3SrxHlMvuR9B6u35bBNsPfUD+vfyN+JryNHyj4cm0Wq4r/qkLPTxXbnWzrEUH3cJaPfRwjQvlIyyg3Mnuf4wi/Ve+FC5/H6elhhgdr+qetBf2InZwqo2HWHV12
 oWFvWxOy
 7qYXrvzzUSqXf657CgsM4ISQ9Ljuo+vFbooGe1oQUjfLp+Ke/QmXMyjFM0u+rLwsApg53/rqFDBNm/mPYgysb2e1bd0KBcf9tlJ3aHI/pstbLKptOpPDgMEgBNsqnhV0L5iNQDknx8GnehyTqSk8vhRpDoLyZltk56u4JwGFvGkK87xBfmXUClW9XMw3NYy0lKcU9B5ztoi0WzbCup50nnPkRofujoohHCPyOiJzI4gfS26j776ceTXHi5uC8a2A7r0baBY+ZthjYs8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Now that pgd_t is no longer an array and rely on the common
code pgdp_get(), which is a static inline function that returns pgd_t.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm/include/asm/pgtable.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 8dd17d20faa33..ff3868acea945 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -134,8 +134,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
-#define pgdp_get(pgpd)		READ_ONCE(*pgdp)
-
 #define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
 #define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
 

-- 
2.43.0


