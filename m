Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E893DC624D5
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0EB96B00D1; Wed,  2 Sep 2026 07:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5CC6B00D4; Wed,  2 Sep 2026 07:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFBFD6B00D5; Wed,  2 Sep 2026 07:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B03776B00D1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:58:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CD501401C6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:39 +0000 (UTC)
X-FDA: 85168675158.20.21CA721
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 59C8640006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="VQDp4hB/";
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350317;
	b=Eo7hUYm6tnixb9GidRINvaH67q+hKjZ8okQoLmQ+kuARiv3bcLLaAAMPjRn0E/YFuzilZ6
	sxCFEeoAFT4G3QUi4VE19xv5urscYgmEKcnNh4D5zEATX78LCjKqQF/fyvGGbQhphukFCs
	kTU1snDzjulzjGGtrwHuvdOPSjofwd8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="VQDp4hB/";
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMW3eE+mLc134FX0XT/mVW0lqSe/kT/H3peA8ZV6NjY=;
	b=AtzTQfLeT6Vo1a0VKsx1/3xYMD89NCe3lgPHSNu8McOEuqA2Ptv8hFKRUe5XwSf6wmnO6Z
	6qa63Kh5JxBu8zVkrWmWL5hAL9Xwef/SG4d602B3mDl16n6tW4sW6ZBn2LYYUQCYzG/atO
	d/07wblIJiwEGLI5ZD8NurPH6e2UY0o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8A7D1E32;
	Wed,  2 Sep 2026 04:58:32 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 61C613F85F;
	Wed,  2 Sep 2026 04:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350316; bh=bvSJZEYuUzSfTp3lnl+FWsv3APh8RUXfn9Dgh5TGgK0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VQDp4hB/Qs/Re5WMKT8eqfXJiFXvWLSISYhYoKX0hMDsRtHpHjqO21RHcFTSnCFI6
	 9b+/JcPwiTaEGulcsFqpFvAx1qS0KIMrLmFTc0tWPd7LPxqmE8dpefCsYzCMnCsR6B
	 zJuttsNkz19sQCyKpC+z6xj4ZDKTo0Dv3LF3T3PE=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:18 +0100
Subject: [PATCH RFC v3 16/21] openrisc/pgtable: drop __pmd_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-16-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=881; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=4wz8+CbWxbmBm+0duGq5oUD3gG+4iNNsSmDgW/+hufM=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7pv10L56yITmkv7MZ8IOM5fh/CxySzocw7K
 IjEcsCxfDiJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO6QAKCRBt1cPRWsUx
 M5aWDADYxAtyl+y2LxVBunlEjk46XhMmo1UlcGdl5tNFIppFTuiJhVz3RKSgMUkVVjwS56w3C6T
 coZfHX4bmgmO43d/gJSuWdFh5kXUDgY3QDfBeyzp08Id41DqlxVCwLPqhJgCg9mdV4NVbgU2rZ/
 djZdFPPzSc4qfWSpf4+UrquyNsHCkCs5hq/y21rF4TFaVoWijqkePHGMpxzH+V79M7kExoU/SFB
 FWmz5Ktb5Wb/6bBN51Y9ONW/XgI2o/yHg0AX6Qu6ruJZa8qUy/820NP3j+vAEwIov4Di6GdoEUW
 aQG1oDixs8oGNV1tSkB7ssu4WZWi8YnyYkh1I1atY36mS9tFc+8MQLVUp23sR1G1fI6wFq7Vqo7
 tQV07xnn9hKFxLcHFuE5sIW6ZidPx1NmbpwiInknq1O6vZx2+kWeRvJ3YDLVOwWgriq+mUt0CZ9
 lS/JZhKiBZfe66sAP6+SVS/mcsN8zk74Y9THLHnG8h9J8pKbVkhKBC2T2rVPfu8txo4SY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 59C8640006
X-Stat-Signature: fcpq5rm7acrn15d87xjrwwyp3frafyn3
X-Rspam-User: 
X-HE-Tag: 1788350317-479818
X-HE-Meta: U2FsdGVkX1/lqM9nm5IfvTgKfZ6eT+1VjaJ7eCqy39ixn5rhUfJ9Yq/xcuQx0kGdbwSJqShNG4xY2W4St63IVzHVv+pUyicecZXcJzf5eyjbCDV2szskvSsFKc0dcpPig/RUu0F0xFICNk6fch50D0o7lzsvOCUUXfxeGgX51JilqLghxFPThn4tz01E3D09FwN77Fwf1yXcejkC7uHaBiEaTZyzQ/x1MDcxkrXY+Gx7nuFDWH4QUaRkmSE/IYG82cU8rNfdUXNknKrsNdtqcjN1Al5do0w/L171sKgl/Dz5ZyXreWaYzoiG1o1mAFLlAzLs9Kh0gEqQMNPwLlVa/q5NxetUey12aI52eSDJ2+HpR5UN5QaKvwWFKaa3Ua63vO46KwyV9idEVe2avbZEUGuCCXo9qxSdw7MUKebXc1JS4hxQhxV/VoHZjFQ0IeoJ3JBLFRnoZ+HDW3Q5TG8kCKRQ7nwT4J+GtEEAKVFeD3Ix0ulr61CI1NIm81ATqCp0gQGByT0qLM8P6YoXJwJkEqECTZq/4xBteiYWkvBBOhLMZUHNXtlvXkOZBADykusxzrbfuEtm1b0/+FHbZhtP4ZlmGmy0FGIxiegwAYQe24TEF+zMefQlZOk++qDNOpcHG/QPsn1t9q2k+qkvKgD8kaKayEGfnnaSQ55DIqqg4zfbtSmhC+6wYYzMIBQNljHWEzNXT98OoTyWejVVn8i+A+UVQ419S/2lv1wPEUkWwPwZl2aWUCzJrfZ4r27UhYmKfJ92CMk+UrZXboxKvDS1egrFBgGk8lUrinAYzgZjboPiX1r/UlTwKwn1X24Yc3A0Sn9v8LPArdWJUsNi3Jh/6VEEDyyyiy5cPRGgaWMpBLl0Dt0zoMF9DewThYe45Qrci33/OrBbvVYnDge0YX+xPXRUCgRVDTxM24lnZ1Rp2MZn4W1IQ3NTn095ibPTqra2VIc2gYMgoAtsd3ugM9V
 9MBbqFHD
 MYhqC30MmuxB13LoJA7G9+F8Ed0uACb6wLNJ9GfJ8i6shVBynNvf8AX8kkD+MgnLTujYsF66QL0DM5B7TZ3V6P0GKve+l08fHmGB05X587kGiUgWXoUe+1WrHn/byEdOX/OO37xRVvmsVHqyKIn5xdSxzgVfmxt7cD5qu3lt5gWBQwMgJ3nYAwCfhet9+mxUpqhZNZtNtViUBCtcu1bmk3FPmBLFDNL7CfDYr94CPx+vCOzjpvSgONXNTx2zitY6kSHFmXkQub3wvhyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

The macro is unused, and will collide with a folded page table helper.
Let's just remove it.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/openrisc/include/asm/pgtable.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/openrisc/include/asm/pgtable.h b/arch/openrisc/include/asm/pgtable.h
index 13afcc0bd863..7fceed641610 100644
--- a/arch/openrisc/include/asm/pgtable.h
+++ b/arch/openrisc/include/asm/pgtable.h
@@ -331,9 +331,6 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 	return ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK));
 }
 
-#define __pmd_offset(address) \
-	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
 #define PFN_PTE_SHIFT		PAGE_SHIFT
 #define pte_pfn(x)		((unsigned long)(((x).pte)) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)  __pte((((pfn) << PAGE_SHIFT)) | pgprot_val(prot))

-- 
2.43.0


