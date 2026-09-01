Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 768C4C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971936B0133; Tue,  1 Sep 2026 07:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949166B0134; Tue,  1 Sep 2026 07:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839806B0135; Tue,  1 Sep 2026 07:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6152A6B0133
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:06:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE3C1C03BA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:05:59 +0000 (UTC)
X-FDA: 85164913638.11.255FA9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4CF4014000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:05:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eoW+Vg+q;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260758;
	b=liAP5JtqA7KajWrzopR5L2LLmMA+UB0Dm1rIrEWomneLt0SjCmqKlt4LrdXzDWST0YzVPj
	85pxhSRywM9XRFx3vZRppW+KDkNdvJ47o+I6+kB38SJ0Yj5h9jcDbu9CpMLMMud1sN/6zb
	M56WxvAEYX/d1mNmIzRk3NFtPovqG40=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MMfaleDm2ce+ucIbxA7OEsrjCLcZrtuUhG+cgJq5Q4=;
	b=skZid+Zl9my0a0YGc5fP4zxHzx0oLpocA35qZEhqPVKh0+B5+pZeXjL5GjvVXwfD9HXtzi
	39Aya+VTxQcv0zAib0F1h0mhiid6bja8wCUILb3U0Fmy3Iqki89z+/+NrvVw2RpEq4d+xp
	KGwNJlcQFweeQO8sH9oJB+MNayn4yR4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eoW+Vg+q;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9B5A601DB;
	Tue,  1 Sep 2026 11:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8662C1F00A3F;
	Tue,  1 Sep 2026 11:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260757;
	bh=+MMfaleDm2ce+ucIbxA7OEsrjCLcZrtuUhG+cgJq5Q4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eoW+Vg+qz0TYTuS8zmuLmeUVjLD9WlshmY+ZenPXLM12mbhI0Hz+5CrJFrOV2T9L2
	 DfnwpLRVXPJIJ5xaVjBq5RrsmTcN5BVQ+4BxNS3PRVo6vCXz2hTT7eoedZk9XGRGQ1
	 /Hkasly2r7zC5IrTB2wqqw1uFHDxP3VbX2vsjVwcbFzeA3v77TJUj0jUSwZmvH037w
	 jo6A6EKvKBWWSb6p1boQBBN0eCIMaDEglu0JysxZO8jL0TOkjZDk8qLhnPrFePf9QW
	 ZIEhpZKTn+4p45kDejAkDB20sutoUd3Rvy2sOql5HOjF+6fSnPjp3wrlW5fxVmRFG7
	 lIqFWgBbg/hiA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 01 Sep 2026 12:01:23 +0100
Subject: [PATCH 03/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-rcu-pagetable-freeing-v1-3-5456a81c8212@kernel.org>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
In-Reply-To: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Richard Henderson <richard.henderson@linaro.org>, 
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, 
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
 Qi Zheng <qi.zheng@linux.dev>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1550; i=ljs@kernel.org;
 h=from:subject:message-id; bh=mgr1uJE8DIP+D2hAcn/4VQ8oaO28pfdyIohSciDSfkU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKmbXSXiAr54Z2+e3/IyQLbrwq3pEWNe54fXRhv7c9z+
 eHq5ZPvd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAi810YGZ473c5+lTTPzG3p
 jyPOr7IEs8NnOJ08pckTV658qObJoxkM/ywtf19cV6htlbYgf/Gc6bMXCRs1LRUv98tOtcrY+Va
 nnAEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4CF4014000E
X-Stat-Signature: jbbi8oxjxqy86d69mkwwb6sguanrghyk
X-HE-Tag: 1788260758-296946
X-HE-Meta: U2FsdGVkX1+iHCUINLmg5kzciv6Z6BNKXz3ljHn8kI6JDKVw/dRb16/1zmR9b4bg69rUJ+dG71k1wmBVFrocdIqoB2GhS6nRwk+8LSuUHktX2Nu0B4w+NVLduDfxo0WnU4EXZ6OyySI2MqG3gOkRBg6YnFW/orwAEVVF1jzUxvTQfaA6uHbdfkCqRB4VJqsmXn0QpdxfVrvBgzvrXPp43Qk/JB4StzBDIY90D35n9dcUX3OAJgh09pY2eyKKKsBcQf8vEGpqQOjZaN02UIkXajP4bo5dee9iM3p+pW+5LVENEcTeIXz8/tpirR1VVn9dnRCxPO27jkL3Kclidcz/2eUpcdF/lSTasEfxrqySR2iJXSgdtd+K4PRExDOcgFJ7lUhzoHpQjt8/HUXataUPqOQUI8O1dUreNrH4GvsNVTVBDavUSL9o5tGJyCvia5V1t6ojyy7wDYJuUwYjOUIlvn92cA8R6zsoIwqhK7nqo5oC5S0Oh4bdmosWjX7Z9I7ZmWnxrMswMXJobPSAYrMr0SBKAoWrDrQSNuHESQb8QnDGK0t3lSG4ml150baOIHKujpmRWX9OiAe+2vAi3DKSLUIvjUpmBT9VgAHUrPpSj5Ou4INwg3723xkQRMYpYSlNytROinwgHihdSTkU8+AzGg5+4kwNAEWwWEaBB+EZsQ7p2OMWWHZ3PLY62IX23lS6nKajCBYeJaQ8zSpjoJ2LEB1MjgeC0cPRXN1loHrPlpMbS06ekfiGd/zpAYAKkh7EZUiX/jMN6aVYz93N8796FA373CJH1/+jG3JuHrWSB0iGu8au8zezgeu6X8bUZ8qr1PkAhYj+GFypYY2tuBCDUqvqhRnwgaYy/In2Q+AsK7cvGz6l+cnlIYzyb56H6BIiD7yKrnRTuekygnSXrnxllE1juKeYbbBwvPHtVKey9ZC+7Oh6a612KBiYKlRV2Byk1VnuyDfUZfWkWXe8Hl5
 zj7utNX9
 E4u50XPIp1d0Fxg2oeM3p3+GA8cQ5El69KHPbp2ncHsGBWeE9pHHb5NtiH3IDXMZQ/2qVred9riWb6vd/gtEG5iFoHw7FoUmF3hn4kbdu2Jsbx075btJjsPTp+4rAWLSvcCXrGUhnb0QEQG1q1GNhl7glcbTKgZsRPjui617ifWOs0wlLnWmj4dB7kb13Rr8+3yxszNaHwSz/+rxIhi5Hz20s/ud9XutBk1PJt0TXZG2YvCjPf5j16JqKGBn0HVnvcj/HQvthEK9gthX2gMSS8Yo7h1iB6l8Bo/0J10rt4R4slo7bXwgZaXeJoUU+u1WYu/nVMevcB6HSgUFuyT3qmm9grhqM37Aoi6TJHd4pUNW1fMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently riscv gates MMU_GATHER_RCU_TABLE_FREE on CONFIG_SMP and
CONFIG_MMU.

Commit 69be3fb111e7 ("riscv: enable MMU_GATHER_RCU_TABLE_FREE for SMP &&
MMU") enabled CONFIG_MMU_GATHER_RCU_TABLE_FREE for CONFIG_SMP, CONFIG_MMU
riscv builds.

This is expressly for the safety of GUP-fast walkers (CONFIG_HAVE_GUP_FAST
is enabled if CONFIG_MMU is enabled).

Naturally a single core system does not encounter issues with software page
table walkers being correctly synchronised across cores, as there is only a
single core.

However, CONFIG_PREEMPT_RCU is still available on a riscv UP system, so for
a future RCU-only page table walker, this guarantee is required to prevent
concurrent page table teardown.

All page table freeing is already done via tlb_remove_ptdesc() so the
conditions of CONFIG_MMU_GATHER_RCU_TABLE_FREE are already met.

This forms part of an overall effort to switch every architecture to this
mode.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 505eed4af932..3529ed1861ce 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -208,7 +208,7 @@ config RISCV
 	select IRQ_FORCED_THREADING
 	select KASAN_VMALLOC if KASAN
 	select LOCK_MM_AND_FIND_VMA
-	select MMU_GATHER_RCU_TABLE_FREE if SMP && MMU
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select MODULES_USE_ELF_RELA if MODULES
 	select OF
 	select OF_EARLY_FLATTREE

-- 
2.55.0


