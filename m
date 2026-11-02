Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19C060A260B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YdZ50qos
Received: by kanga.kvack.org (Postfix)
	id 042956B05BF; Mon,  2 Nov 2026 06:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F349C6B05C0; Mon,  2 Nov 2026 06:22:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC936B05C1; Mon,  2 Nov 2026 06:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFBA46B05BF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68FE01A0CC1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:29 +0000 (UTC)
X-FDA: 85389940818.23.E28B0A4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7C116C0003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YdZ50qos;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hJ1iPHVTbYTDAq/C1HnaYE5+XA4A6mgYVB8Pyb4aLM=;
	b=wkdOTUjnH+kHSYiSd6GBdrPoYHqwVv/1pp/O6yguX+nw1IPSxzbJayBACMdPgNYxSrRE6k
	K2VtdgWXhQP3dSlIoEd2xnaCnOH8ybmMeXs+1P8IkeZV2CX2J5c4TxhHvDnBHQjL+vZFIh
	xmT1ioCm1Y+c0wEn3zlip3argwRl4gk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YdZ50qos;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618547;
	b=dSh13CujTExAOQ3+DpGgdODBCm6GGvi3j7tLYKwG8ThCIhgwh91Pi3yOACPq53sGfRL8A4
	349TkU4OOH94M2az5wWjSOvsjWtl8/YglZACg2bQk7jr4GKZuGy3MhhtBwHF9xAirXbJac
	+GOn4xX53kLJDtg/HTbmboFmo1wdxAY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9987E1691;
	Mon,  2 Nov 2026 03:22:23 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7612A3F632;
	Mon,  2 Nov 2026 03:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618546; bh=/Ssd4kAdbyYc2WVWtdpRP5Vxi5IuwO7Iv1puKU0SNto=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YdZ50qos+A3w9ZaM+D9UJ7oLQBvwyhsBU/ruoPIHunkF9HB8/GvUZPOFwIhq0hj+b
	 XMmZmMiyF5M+zRGKttEOthHofyTIfdOb6kRAKiJfrH27FTrj7aQ3tXK4ZJ1L2PFzo+
	 h5y+NPPSkIndHx1iv7x0/IC7DPBuyoL72xdV5wCE=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:21 +0000
Subject: [PATCH RESEND v2 08/21] mm: vmscan: remove stack copy address of
 pud/pmd pass in walk_pud/pmd_range()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-8-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
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
 linux-openrisc@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1374; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=/Ssd4kAdbyYc2WVWtdpRP5Vxi5IuwO7Iv1puKU0SNto=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIyfn2gL02dSTH4U1Digx7JtPpPj8Bgyn8x9
 UoFtdHycjSJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyMgAKCRBt1cPRWsUx
 Mz/2C/42LrIml4kwQBW+YjAT4YcNn/U4Nb8+hQWZ9x0kXwPAdxvb9J43k+UVxO9ahHOIk6g6HIT
 XtZL/MTOK7/jgTNkxXqFVeYK8VyzWEiqpibgZjNpiX9XLh6Z8cmnp8G47IUvXkJP0wA+Hmakv3A
 9myK1wyAcp0SHF/i/sVsHm7iyIbMyGfGc6Z5CBiWiTjnDvafMkvBazMphB0j5dU46MUuWd+W7qy
 GwEdURQVvkAFrul/krfqIl8qyLzn4vPYYBCRYUd4SCIlcw5QjS3Qthc6ED7WMnukAn35Yx6W0oL
 oPVAV5N01l94+aU9yml7y7eXDNrR6dgu0Ocio3vbsU2eTqNw/dYDJL0PD+h2rPLcEwUkPmIQlTt
 o0ewlFkj/UUYwiFIUbO3PGph11XhYzVDb++4zdSLnOfSYG/ZBB9EGVS2GVUt55QTEBEc3tRmB+f
 YQCEfFaDjsnzZBrd0gL/KZqDv8WqDSWqrGeR2W82At20bHA5Qs1wSXjJiIn3cDFFKuyPg=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: 7C116C0003
X-Stat-Signature: d4k635j3f8cf7d538iokx7xzronizs9x
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793618547-475654
X-HE-Meta: U2FsdGVkX1/Qn5uyFrkmJ3zYOpSxLiNKqQ1eV1o7uxHSXJSZZ+1uMNVdnHzJLEgLIrGkHRwACBiUiQxY4NzXjhw5tXrNxmRUG1pF+PkKXSO5HtG/d03pCyxQELDRYGeUtf32qt5LTfCJAAVuU3LsOzf3/6c87FTiCF40gp1SESInabwe4Xg6VVaVFqd8CI5vlOiW960Lg4vgGy3/FJHNexZX7zB6OaDnJ3HU5VACfZGy4lmO5PyPPSCQuu95tdjaDKsw18qS4HtoS2QstHY+KTkQ4YC/S385p0ctjBIQZbq6LjK7P2wHufOPh5PAoFHnRvcoirkA8Tp4bxG9Tvs8S4ovNXIJGQsmIqzCtupLTrieItgy+4lCj2S4GJSJXdjmVOpKXN8PDAeqkh8WSNTaFwSJiV4vQgY4i6IVUNdeTgtRAo1vtSEMYWTUoYzxMAkZ0PkCbA1P6M7QeKG49N+q2/bNhSlaSCAw6F/L7/+Sz2oGQ0Z66G4XMa5ucFYEXA7QDDg0BogdszbO9H3V3KvEBXTdRdMUfJf3Wv4wE9/0wC/Xs2Ne38rZfMAaVu3GDHaIkyHEZcZC2l4G7nc7wchLJBbL8DHpTmA00Me7TtcwOZuydR+VDVDkjwoxH1KLV++W3LbTBgHNlNGo5wc2VFDTQJVwPwDq7fRq/AfdfW4uBt9Hoif4eMJij16KBJbu4Ry5S0lHZ30VbL0uyRvoWxRXYV4hWHJJk9qGHW3EOY65mallMZ9FqRIHsJqp4p90SZMXVJynDDvy0oNv+JPpukGGvlYiW3VJ2NI3bR4jLSMDTrYYf6eNn8BYpoAM5M9SiSVD8K5Uu5NkWlX2bTHAh5Rj5tvs6vx+It6XttexWT8FPPj2TAgSNnLemTh6ws4kdrRLyZYK2sYx8AkMrnrmChh4y1jQDLIuBJzFvCVvMM2ky9WgP9kKjuU/ucV2i2+ZpfJqPm6NNxqN18plJnLBKD9
 CxyY0WGd
 aa18tVJjA+iX0c5adohOQ6OT76iExPEiiygaXWOoxj3mDFPtXzMV7YBSOHOFORmFfMqhFSMDXlQEmvLglmhqQCuIjpOfPIO1bVLFqK0Sv8EPWXqTI4ufdymHiQUHWnI1WL6RflwnZFE6EQORqO/hl/pYqESmoDp8ni2aQSPe7tOGr59pPSON+yUh3vde26D1k7LiOIufS2EISvPrZv0IijF792d8syAG9MJM4jchMs5e5giS/66MGx1bOxtetzOY7v96JJ6ArTw2979wUz/oLCiQ2SkBK5inBvfYSZR8pXr/PGkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that, replace passing the address of a stack
copy of a pud/pmd to walk_pmd/pte_range() with passing the pud/pmd pointer
directly so that makes allowing folded entries to be ignored and
check the concurrent access proeprly otherwise pXd_same() would return
always true.

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce83..6a1af9b92349f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3911,7 +3911,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
+		if (!walk_pte_range(pmd + i, addr, next, args))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
@@ -3947,7 +3947,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		walk_pmd_range(pud + i, addr, next, args);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;

-- 
2.43.0


