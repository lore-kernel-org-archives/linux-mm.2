Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54AFC606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=C35Jq0pf
Received: by kanga.kvack.org (Postfix)
	id 797886B05B2; Mon, 26 Oct 2026 11:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7478B6B05B3; Mon, 26 Oct 2026 11:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2E66B05B4; Mon, 26 Oct 2026 11:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0366B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:28:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D12951207FC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:28:03 +0000 (UTC)
X-FDA: 85365158046.13.CFDD888
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0D2E218000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:27:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C35Jq0pf;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793028482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YP/4sMLmMrBNwv0rmr3CgPfxwdrbgn3B1FIYdO1TaM=;
	b=bAyYU4tIT/GxgnspjgHSeQD0WzmULevxcOzAXXX6MXhGaXQhvcjN6EHMxnwCuiBH11YVpA
	1U9qtBD59R8BEuzLqLqZXLZJwnKLvz3JgviDcGQ7T/kyi1Lp5b5R54DAbrf6Pi3R0bwWK9
	jTNRtjlQ05/Yg+MtfEAFPMXv5QPDBJI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C35Jq0pf;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793028482;
	b=dUUtlp9/VjilxBuL/+C19A3rER6RIDDO638AwrsAgxR2gX612kAfeSF/kf7cFbRB+H0yzV
	Jc2kZ2i1OEjIkcGWPkYWR3+x2DFpCr0+cq6gu/7WwbPcFM9Sa1PIAGATLnIDnnVyj+w46C
	alXQJxNikN1oE5J4MnLr7JwIuVU3Xgs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BD5GR4twj1Y0cxe10dqIpaa4/qJ/AH8RfmV9ehRX730=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793028476; v=1; x=1793633276;
 b=C35Jq0pfAi43X24zs7+pws0mYLmITR+OUzEveCg0XkZvazu8n4wJD73zrHK7x5S+fEpLQuLX
 P49c8d0YGrGpUtVW23hk8Og+UipwHF8cebaDl0rHVHYY/y46DZkmAf4UXIXMFQh48UVakZafxcK
 AZ370RiZGW/kNAJoqjyubAWo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b2b5afc969dd0a08;
	Mon, 26 Oct 2026 15:27:56 +0000
X-Mizu-Trace-ID: b2b5afc969dd0a08
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: alex@ghiti.fr,
	palmer@dabbelt.com,
	pjw@kernel.org,
	aou@eecs.berkeley.edu
Cc: akpm@linux-foundation.org,
	zhangchunyan@iscas.ac.cn,
	rppt@kernel.org,
	kas@kernel.org,
	david@kernel.org,
	andrew+kernel@donnellan.id.au,
	rmclure@linux.ibm.com,
	debug@rivosinc.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	wangruikang@iscas.ac.cn,
	namcao@linutronix.de,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	alexghiti@rivosinc.com,
	viro@zeniv.linux.org.uk,
	ajones@ventanamicro.com,
	arnd@arndb.de,
	axelrasmussen@google.com,
	brauner@kernel.org,
	conor.dooley@microchip.com,
	conor@kernel.org,
	jack@suse.cz,
	liam@infradead.org,
	ljs@kernel.org,
	mhocko@suse.com,
	paul.walmsley@sifive.com,
	peterx@redhat.com,
	robh@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	yuanchu@google.com,
	stable@vger.kernel.org,
	pasha.tatashin@soleen.com,
	linux-mm@kvack.org,
	me@ziyao.cc
Subject: Re: [PATCH 1/1] riscv/mm: fix soft-dirty migration PMDs being treated as present
Date: Mon, 26 Oct 2026 23:27:45 +0800
Message-ID: <20261026152745.11239-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261004030312.90163-1-lance.yang@linux.dev>
References: <20261004030312.90163-1-lance.yang@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D2E218000A
X-Stat-Signature: zn1kgx4jz9wi8ju7gnakmz1tgf3awmuo
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793028479-548063
X-HE-Meta: U2FsdGVkX1+gK1sg0az6HqfdvDWXdPdzBZ1ZZbpK36u7pMZrZTL3Ukei1ag0bnq3Zl2cmrMX0hS4pJz6pB7RM8PFXzkpSfuF0Xuc3emwFPKoNYQAhipgur8EMBwB/pUu1LBrC7JItSDZLnOjGdW2C4ZwNlAAkw/vj2AveC/0CemqCKPD4iMwXImoqzXOMtuieDk5L/dzGXAwV1eLWBii4JLsQ9P1GP+GhKzPaQ9sVjYOuPkDn1+7m2P6tjPiQjR6uAEEFEKTEf2TeSJnxhYJfsuCwhLVmszx4II6IyngBf16pgXMDFRQUzNiRk7MrpR5+khJYOr66gf+hpiYBCQL4idtvF72kjqq4qkdZ2yMo3MN7SlgKC+uGgAD6MoqBrgkaKG0a95KPnpnzAigELy7smmcTlbirKpIN7lxj32ONP7LdzR3IwXSe5rsrFSw/6e3EXqPGtCm9XvVG6CiyR7iieyAm7jElxFAwh+ns+hNi/+AhVnhFpothvSA81PZZyh8y1bIui8zLgd3CDl23qYnyH2/Gm4mtQr1Eibc+X3v2z0SAbmvqfF61QIlJ2ovM4JrT2zCrpmVt39ify2TClml8+LMxKe26xyM4jsu6RP4aJlNh55aqPLxuZpHVUFQjfVVJlNwUKsRkAOU13h98+/QRkrsTUrhCFWMMW6ijBsohh9Hxdo5BKXNCRp2UJi/KWqj8Ipc93a+0ynCSFkO4FmEzgMrY3pzZkkogkM0ROX1f+2NoCNUCwh7kB+syjICrNZshKvPUUw+Vk9GDnHENDxl8gaUo2L+tcKo57AhF1Mpa9V4VW8HssXORGuM2aWvUp3mP4S/YseeuGnL/tqWpJm/asqBIfqkrkN8dAwGvHkMltxtiFHw+PgAsszaTcwaz94lYlNE62zWGUMrY0z3NxwIHpooT0sN8+VzfktfK/2i7O9I2kF+L80xiXwG8/FkJDIQtvGEOyRlCJtpMCfpWGL
 tq8bZKEY
 sm703qDuaCRi1cTA6XNfWwcbLjvVq9qv4nLxDi09C1eVWxfTC1LdNRmeMCJsmDXQsSQS0uYu5+XOaJw43+2vjl4E6+BGVYfuiquPHpgVGHmt2QaCFwvm5SVmT8Qb+USwUByFLiGuikOR7d0lLy+hehv2At5p6QkGyPz/SVUNe//pjXuIEchHMOFgipAZnpWzSUB+BoVvLBucu8gDAYJQrEzQGLlws2YJgnaKOJecg0vqiN/0PSug/3qadZ2Y9WfnCQcOUmU3rdrhmaQ96S91Yw1ZWVK8MmIXEd2w22L5+uh2AyMb9pfKmIGHay7ha+/GlLc4BolGFC5TOGE5MlXbPsPFbe7tEYG+sPy/ByyeS/0bs4/PBMeLGQGXxvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Gently ping ... Hi RISC-V folks, any thoughts on the proposed fix?

On Sun, Oct 04, 2026 at 11:03:12AM +0800, Lance Yang wrote:
>RISC-V uses _PAGE_EXEC for swap soft-dirty tracking when
>CONFIG_MEM_SOFT_DIRTY is enabled and Svrsw60t59b is available. That's
>a problem for PMD migration entries, since pmd_present() also checks
>_PAGE_LEAF (R/W/X) to recognize THPs with _PAGE_PRESENT temporarily
>cleared during splitting.
>
>When a soft-dirty THP is migrated, set_pmd_migration_entry() preserves
>soft-dirty with pmd_swp_mksoft_dirty(), setting the X bit in the
>migration PMD. Even with _PAGE_PRESENT clear, we end up treating a
>migration PMD as a present THP! The fault handler skips
>pmd_migration_entry_wait(), and a write fault can end up in
>do_huge_pmd_wp_page(), where pmd_page() decodes the migration entry
>as a mapped PFN.
>
>Move the swap soft-dirty bit to bit 12 and start the swap offset at
>bit 13 when CONFIG_MEM_SOFT_DIRTY is enabled. This keeps R/W/X clear
>in migration PMDs and lets us keep the existing pmd_present() check
>for invalidated THPs. Leave the offset at bit 12 when soft-dirty
>tracking is disabled.
>
>Fixes: 2a3ebad4db63 ("riscv: mm: add soft-dirty page tracking support")
>Cc: stable@vger.kernel.org
>Signed-off-by: Lance Yang <lance.yang@linux.dev>
>---
>I found this while reviewing Usama's PMD-level swap entries series [1]
>and comparing the swap flag bits with the PMD presence checks across
>architectures.
>
>[1] https://lore.kernel.org/all/20261002095503.3585565-1-usama.arif@linux.dev/
>
> arch/riscv/include/asm/pgtable-bits.h |  6 +++---
> arch/riscv/include/asm/pgtable.h      | 10 ++++++----
> 2 files changed, 9 insertions(+), 7 deletions(-)
>
>diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
>index d5a86b4df3ce6..d84b459e010c1 100644
>--- a/arch/riscv/include/asm/pgtable-bits.h
>+++ b/arch/riscv/include/asm/pgtable-bits.h
>@@ -27,12 +27,12 @@
> 	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
> 	 (1UL << 59) : 0)
> /*
>- * Bit 3 is always zero for swap entry computation, so we
>- * can borrow it for swap page soft-dirty tracking.
>+ * Bit 12 is reserved for swap soft-dirty tracking. The swap offset
>+ * starts at bit 13 when CONFIG_MEM_SOFT_DIRTY is enabled.
>  */
> #define _PAGE_SWP_SOFT_DIRTY						\
> 	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
>-	 _PAGE_EXEC : 0)
>+	 (1UL << 12) : 0)
> #else
> #define _PAGE_SOFT_DIRTY	0
> #define _PAGE_SWP_SOFT_DIRTY	0
>diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
>index b644db16bda94..acaf6d3b54d04 100644
>--- a/arch/riscv/include/asm/pgtable.h
>+++ b/arch/riscv/include/asm/pgtable.h
>@@ -1178,18 +1178,20 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
>  *
>  * Format of swap PTE:
>  *	bit            0:	_PAGE_PRESENT (zero)
>- *	bit       1 to 2:	(zero)
>- *	bit            3:	_PAGE_SWP_SOFT_DIRTY
>+ *	bit       1 to 3:	_PAGE_LEAF (zero)
>  *	bit            4:	_PAGE_SWP_UFFD
>  *	bit            5:	_PAGE_PROT_NONE (zero)
>  *	bit            6:	exclusive marker
>  *	bits      7 to 11:	swap type
>- *	bits 12 to XLEN-1:	swap offset
>+ *	bit           12:	_PAGE_SWP_SOFT_DIRTY (CONFIG_MEM_SOFT_DIRTY)
>+ *	bits 12/13 to XLEN-1:	swap offset (without/with CONFIG_MEM_SOFT_DIRTY)
>  */
> #define __SWP_TYPE_SHIFT	7
> #define __SWP_TYPE_BITS		5
> #define __SWP_TYPE_MASK		((1UL << __SWP_TYPE_BITS) - 1)
>-#define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
>+#define __SWP_OFFSET_SHIFT \
>+	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT + \
>+	 IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
> 
> #define MAX_SWAPFILES_CHECK()	\
> 	BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > __SWP_TYPE_BITS)
>-- 
>2.49.0
>
>

