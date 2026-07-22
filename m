Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B3DC4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042FA6B009F; Wed, 22 Jul 2026 11:31:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B6A6B00C8; Wed, 22 Jul 2026 11:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F176B00CB; Wed, 22 Jul 2026 11:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C048B6B009F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:31:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33F37A09E3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:40 +0000 (UTC)
X-FDA: 85016802360.08.5612916
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5FF58A0012
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YB+ECKku;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ODZjNW5l7yKFa1B0NzzrZ8PQJl3rZRbQVYrjldpYps=;
	b=GEYUCyO6d+B5MAraNDRDvf5vIU+cHJ8pbqDBKvHSxotqbaRsrX2NskPzvamVQs/gYc/aWS
	wXyOmfHEKL1qDgT++MtbfhX9k+nPQX2UkTBv6WSSfO8g5Y9CuZYfb5ENFJ7D6UZa+xSg8Q
	CIw6P+ZUbCKVv2Jdnw8iH9dXaI11urw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YB+ECKku;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734298;
	b=M5rhLdr684YNXDwpAkA9azxrButTGienIbBuK3eGeolrcLUOaDFQ/JzKIZNeB7t48GuDyr
	bvvyEVufLVzUzbl6oBUL64PAuERB9NrQEQOR2gEydeii6RKLwEqFL2MIDhdoTICJsdcQGP
	tGbYrNmabaJWDySFBy5vLvBRwbCjL0A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55A83168F;
	Wed, 22 Jul 2026 08:31:33 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EEAE3F66F;
	Wed, 22 Jul 2026 08:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734297; bh=YcD0jzoOahG6x/x7befgYnktlqrNhCa1TVm2jqZpY/w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YB+ECKku/PoYq2WT0AjK5FWjpwHm5WhvpyBL9iss6rJkCx9EWxGy5Xj4MUWQUp/nc
	 bB/WO9swVClnAHd0CCdiTAWlLHW6My7AKAaZCl2lFEqQMRkMNS2H2HjRUcp/qutLrl
	 XMv+zI5+luxlx6Hkz3AiZYLUrcxHFci+B5d421/c=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:16 +0100
Subject: [PATCH RFC v2 08/20] mm: vmscan: remove stack copy address of pud
 pass in wallk_pud_range()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-8-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
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
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=931; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=YcD0jzoOahG6x/x7befgYnktlqrNhCa1TVm2jqZpY/w=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOITGIRilBrCRHcB2LdtqoEOmFgxIF6Hd+Vnk
 IFCao2dq7WJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiEwAKCRBt1cPRWsUx
 M9rNDACPX1gvLIbSeFSgpsXYw5fiwtsaAo8fF9fow2EFQfuqsIXmDvvDuGvc+tGU4BaWuGH0mzM
 eklxLiUek0JNBF0GJ2x3A4Kq/ui/Kd9sAqMqxOPWurPgfQayM/59RN2xzFcJzTZhoDSZjVcP8Ru
 FK3kg4Bd/FVwqL91rO7uKn8nVD/occoSK5fX2tc1M7dm/Z484Oq0dzF8MCB+CDCrvRkASH5o8fR
 7OBG17OYADT6CJpJ30NG3tnWw/z18SHM2Ho6dtWlczbf93oHjLBn9TtaJJ6TvsI6HevcytP/R4s
 mPt0zU94Gtx1B3c6i5b/GMxplXDdm1GNMjqlqgeIzBVATylzMaefHkFdkR/Ep2mCZJRH0hgBYvX
 M/U0vigKgKdlCN76Y4jnDC3QQ+LXNhIy8HWUDZKioYXWffW32R7/0W3xLPN4De5MFGGNUwfftWV
 WcWIiT/h7TzBoZGus/gSVNMHtcSBu9NwtPvLEQDo4Q8vWWR7vsw4ZNL4ki05RrlcOBNyM=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5FF58A0012
X-Stat-Signature: 9j4iycwuqnip3kxx7zn85i1kqkwqy43d
X-HE-Tag: 1784734298-392509
X-HE-Meta: U2FsdGVkX18Ckt6y+YsiCJI+2CsRMEwMIlorpPyA6zYczCj4xn4jpz8a9ZySPrIx8s7TkUHDAoc/fchRPef58K+4Ftk1DDHcN6eCgNll3u2xiyEpHEhe5Y+jHvqSSW/Ol0WDIETcnREMm3wzyIOMy/a3S0z79xMtjuAdw7z3yq7Bd9ON0JT4gRsmbx56gWR5+nka/coook/uKKVt/UuLfSVtb/p39+N2cjyW/Hak3lACbS5e/G5M4FNGOAaRTahng15K+4qK+t06uXNIqXZOkR2CZ0mB/y7OfufRSIcLMxZjSTHoqxbTEZVirGL6Auh28W4OKX60CVbI0K5j0KuEVdimf0EL1vK7PQ0RWVlPbqOpBh5eoC0Q5Z5+EHgXsIQVu9Koju2aaI/genq2Gl2pOavNZzAkvJSZwJ6ZBaChnaUWKhYm/9BCd77xvKAyQyz6UckMbqYURaztmd4jFaLJ1zHUWBr7mdwxPoXnrraKtIrqZM+blNSwnjBZV9YLCAPQ6DoUa7Iyqks38h+zkji700twos4L45Zg5x6ISKUozAtJ3ZTLECn8OF63Q83K4ssASp+qnKzxvPsTb6Hg3D7cULc5zr2yTuU1EBXcqmV22c5W3T6mNbR67BoyiqAwgxIN7T2hVrw6AuLQ8flPPy44QsFs6GxcCc5OFBaqGHp8vejsmznJxIOtAG0garaR56qW6c7PupxJL6IGq5ZcimT18O0IOfYZSVEM2m5GumnN1f40RPQVYerVkoTa1prKIK5bByHjNj0eSMJ/va2LytCf+amWruGPlN33c+8f+wKnrNCGlreNXNr7sfHfu6RlNKBcWdtkaRgHFNSQ1Nh1nJIZjFUnePT/qyybIEl3ZgUy1HuGGmS4z+ZSPzKtSeff3viuY8e3xf3IsbrjjEjswAtZfr4zAepxg4CTNcRLyud1NgDxWfTavUvo7QTNs0U2IWTtGQzMAZPXmlrSZumRoNJ
 SHxRJNRl
 EeyRDUNDbn3cTbu7Gbf5Ngvw/Sotd9tmGi+T5RviB91LdweEHXQGSgghuS0ZmJMAE6dvf17/X+1gjrL9kIj4XV6CofP5NJXDDQZ6FS2HJIRYImNW0rz8dHN0NXIoMuyo4DmvpBaZaEKhD5DeYlg0mT7wZcDUfEiWilPWAH7hbDQ6JmZSJLm+jCg5DaDZMadEdKoFgYGrLWofiBa/+MGzpXaTvr+npYYpD1b4BdyY1hJiEzM1VWvx3JPG7xQ7hwzb5tNeEbCDFyVbRf1h+a0FZpJUv6G9WZ3iWWEFcBO9mvcsA/bw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that, replace passing the address of a stack
copy of a pXd to walk_pmd_range() with passing the pud pointer directly,
allowing folded entries to be ignored.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 06e103f9781e..0c9c4ac89e09 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3727,7 +3727,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		walk_pmd_range(pud + i, addr, next, args);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;

-- 
2.43.0


