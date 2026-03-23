Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 148B9EC01A0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E49A6B0089; Mon, 23 Mar 2026 03:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795576B008A; Mon, 23 Mar 2026 03:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB306B008C; Mon, 23 Mar 2026 03:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCAC6B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:49:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 093D9BC3E6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:15 +0000 (UTC)
X-FDA: 84576552270.23.6C86CEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 79206A0016
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mJkHNMOm;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zXEwAxCB27G6g1WAOCaJemzlmGEpdOhhDvBG22lnTxs=;
	b=I2UEOpalnx2+7GDJz+AfJG6dScJh+Dl+VkGNLJketrBc0QpQgiTimGzdN/wQIdSJFQGAqI
	FOgskjEchMocHSSDxZv5MqlS0+3BmHNDhrHElp/B27pLYdlxIN+2pIlEzsa75Zm9iWoVjh
	J8eWiMbAyLauxfKVwc2dQxjCOcqcpdA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252153; a=rsa-sha256;
	cv=none;
	b=pzPG2SJPm5+XIrMbve2EjKeX503LbjHz4YcLxMhf1O/4rCGgvS/0iV8o8sUcHLGf6AyhdE
	V1IsKsHa25a/+Zslm0QTQ34U6NcP1yfSiozYElVH3jpNy9zlKH1YfnZCvarpDpZ+hk+BUl
	826yhACnMsh3+7r2+/lTiW3wu91+TxU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mJkHNMOm;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06A26600C4;
	Mon, 23 Mar 2026 07:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161B9C2BC9E;
	Mon, 23 Mar 2026 07:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252152;
	bh=IEszaCrFLo/Rs8yG7tIln7RmG7s5ArmJTUt7L+grDBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJkHNMOmwoIFLTcd31YucBrDfzfANQW+xkkREf7kQp1YDYI6vfV8/hVhcG3l8g/jK
	 sQngYeWtYhv0ZkW+8RpdtrXoti30446exi6Ju2/Ux3my4Q287Qpr4iWYaKli+PF0u9
	 vL/UiFYGZsmNZ4bQKMUXEy7AH5R6vF3zaUA3sbrcBu/WMLiPFtPcKLGomrzmqCTzqi
	 PwkOo9OAQEaeopupEyTaQ/a8bAo4WgnB6AuNb75FaxwKNBNMNqccFmqdvaop/ltQA0
	 aYjKEuyW1vof5rqfOJ6PkR20WHVtA+dub6QcUQQxq3ViDq6QsOyMq2uvJPowcDC5VL
	 AoERA5+OddeHw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 2/9] powerpc: fadump: pair alloc_pages_exact() with free_pages_exact()
Date: Mon, 23 Mar 2026 09:48:29 +0200
Message-ID: <20260323074836.3653702-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79206A0016
X-Stat-Signature: p1xkzsr3cxpf1is1m5f91w4ukjpkwtgc
X-HE-Tag: 1774252153-709374
X-HE-Meta: U2FsdGVkX1+Eb1sfM7zdza02+ItdGW9xOA2M7QcOGvHibSd7FaogFlfUYvVcV14bryQxVEpF6HQTGxLWUVhrqWmvNW6cTCPBpG4DM+dZOwsd8qylMXJ/qHbvlOfct7ROslGM2+ijS2XVYIqvJuTrfKow+nHSH/wI7DwMVe8ETsYOiQSuFpI2lWgm/r6Kuj6usdM+0ciDHUfPWRP12D3J9u3QJRUK3xrDyT9jYlPg4OWlFksieobDEBmRIMfxYQnp9KGcASKmAOO7+yAMjT1Cd35YVb0TsZeNXkWgjVVayi3/HZ1xCdyf9qK1MxV1PjLsSYLLIXx3JoEiwTqVMHG35taC7e66H8Mhzx8+AVz6AhqotG91ck43oibg7pqt1CRkZSwGNmzeN+5TvrURAYJSZhLxjvsPgPr3FTOm3fnEFU8Gx/efJBNBAeTvm+0DTOKEQWO30p5pxpIZA3dW4oqh4rEBqVuJ0Q8IK51SQkYaNAdHQ49qChNt8BecENwr81Lecgka2M+ioQVysUr8oW9Anu+bC3Wpr6xukkfUHP8T7vLQjkn6Ic83us/nlyY+xLetsDKTSDXmNv3rcaW/cYlPSqhgFjpdY5iaKGf/+b6Fo3nn5WpLzZO9yS7U6OuyYCzJ3TxKvXaghVIwmheth92CjNhA4kCysnYSpCjmetr9WVmOHRFpDaAlzjrEllOi3wJyn4nbgbPlBIQ77XCGkZuy8Z8t/vwFDhjclH66Y5NGbzfawIC51mtwC9AXQgcGIthiN6oJDZgBUWz6MkZYOWkodRfXbXbD5Cno+betlF1uryaPqxGEvWclhCfY6uRqbODa/XGu8PMhlgZswFFXSAqOAXm9c20jpjufSEcK0YRjpNzqbV9UduBjjMu8ALbHkMA5QTzdyzhdy66rUHRlMO0AUheUV+4Rv6qoPS0n8tmDMcJ7oWccGizRPjVlvuCp/u6iuDGwadT/dyyzKhho7Bt
 2gZPshO/
 Pwl3AcThev9zhKc69e9Y9tBOE5xZxfHqs94sItWa7MjZWBbQhUbY7N07JWbEbsRTWDR/mop1U7biRNElhMtMPYNgCHo5zzIglgyF4cLlPM4EXxHnCMuMYrIMEH82NwWBAm0x3jisT7H0Vv7P6AtkBcoYc3AHEq3xnqZw8r/EG9IK1xMIpVUwXWiSHHxQxaduD8LKJ7WUO60fBHU8WTDeTALoNeIhlQ/U2XJ6WORDatAwX2m2VJMFC8r1XhBWNTEVR7KPpbdrykMRVInDt7WVdyhiO4TBgqAnMgCzhsK5rdBV6OiRxOyo/kUhG0EmP1JAtiV52zeSIC0TiB6nB52U9lDWNhEAb14f8d8XTu6Tlv+nroPxypH4QSQGoj2UsczKhlvt1dWpiG+VmTxP9KoWu2d/1Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

fadump allocates buffers with alloc_pages_exact(), but then marks them
as reserved and frees using free_reserved_area().

This is completely unnecessary and the pages allocated with
alloc_pages_exact() can be naturally freed with free_pages_exact().

Replace freeing of memory in fadump_free_buffer() with
free_pages_exact() and simplify allocation code so that it won't mark
allocated pages as reserved.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/powerpc/kernel/fadump.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 4ebc333dd786..501d43bf18f3 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -775,24 +775,12 @@ void __init fadump_update_elfcore_header(char *bufp)
 
 static void *__init fadump_alloc_buffer(unsigned long size)
 {
-	unsigned long count, i;
-	struct page *page;
-	void *vaddr;
-
-	vaddr = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
-	if (!vaddr)
-		return NULL;
-
-	count = PAGE_ALIGN(size) / PAGE_SIZE;
-	page = virt_to_page(vaddr);
-	for (i = 0; i < count; i++)
-		mark_page_reserved(page + i);
-	return vaddr;
+	return  alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
 }
 
 static void fadump_free_buffer(unsigned long vaddr, unsigned long size)
 {
-	free_reserved_area((void *)vaddr, (void *)(vaddr + size), -1, NULL);
+	free_pages_exact((void *)vaddr, size);
 }
 
 s32 __init fadump_setup_cpu_notes_buf(u32 num_cpus)
-- 
2.53.0


