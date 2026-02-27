Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A629D1039894
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7C96B00E8; Fri, 27 Feb 2026 15:12:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5476B00E9; Fri, 27 Feb 2026 15:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED66B6B00EA; Fri, 27 Feb 2026 15:12:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DABA36B00E8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:12:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DEDA1A0943
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:12:14 +0000 (UTC)
X-FDA: 84491333388.25.C33DDCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A436D1A0011
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:12:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ngaOty6e;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fCPmvc1vvorzRSL+A9RsibKTn2zoH1ERt88khz0mWY=;
	b=B8AScB+DrUsU24gx3il5Mrj+oaOSLCy3Jj1Te+Sdt/Uo+PVpAypsYIFrTbjuApV75jMgkz
	9WODxnjZNq9ipJzkdVhSAgYcqMxt83PnNDKPftFeN10VDjoGBRDUc2buGADsIOwpNNLKcb
	lxAZBIHN4fRV/dqPP/XPtIGEDdxFH/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223131; a=rsa-sha256;
	cv=none;
	b=JmfEvwJ00mkj5Lz/be3v9Q1sMbgTfbuvgeGmC6uNcznUzohydHiNAxx7OnWA7L2sPMECp+
	KB8SjPKPeQ1KzjNMFCMkltJ8OIgm9MvwCH1+h9fCYYhx5cNdcsEWFlm/cR8ePFaAMKJHEz
	wogbDq4lTEFYkR8r+HVzWwEeGrH+mGY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ngaOty6e;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 952F141843;
	Fri, 27 Feb 2026 20:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39E4C116C6;
	Fri, 27 Feb 2026 20:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223130;
	bh=clYyWttfcaFGSXdSI+NFUKwc/GgjopvB2fmwPUXTrio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngaOty6eXM5j7is+WGyPTLemdZsPBcNe61ojNKAJgZwE71n14yO064jdNtdsbX/Ee
	 RlnqA3sETb9Sy0WtFg1UK1UEcaoO+Lw/1O2wov2lG6O/6NijoRCZZU6GJofxg0KeVi
	 odWoGYGuMoHkVNOTEmUkygOdILEoNupmNcfh6X2yUbKxw8hqRUN3XAIuwmUTHbl0uv
	 Wl5I/FU4hI2dyfaSjJKbwQzwLAdwBQdMN+UbkJt1AStL/fzXkytyB/+eDsgIyfI8n/
	 b9L2nmNB1P0iCf65mL/2gwS2RTtD6WGlw6k+T+OihQnVUd6MdiJbH5WiiAYE79FL+a
	 YRQ32YLZxixOw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v1 11/16] mm/memory: inline unmap_page_range() into __zap_vma_range()
Date: Fri, 27 Feb 2026 21:08:42 +0100
Message-ID: <20260227200848.114019-12-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A436D1A0011
X-Stat-Signature: nn9fuqtwfxa3ieafzdingraiwh5q7c91
X-HE-Tag: 1772223131-282937
X-HE-Meta: U2FsdGVkX1/NeUAtjaUEQaPMBKUSQIKrg2cvW1KVj0+Z8zVi+2wE7KtyLcKlAryVzCg0W2XglPC91itJQ522ftrFrk0JvwGSusVHPUmVelBFYEkoL6H5KU29lWkza0Almk4rXLh9eAB26RB8/XeqqtQb9sU+lpIchTBu/FxVc7PNSZGCmkiqCinhc8OmEf3GgWahrHq3I2yCHRgxce9pI1EHrEuh7/1pqReyz4uS2X6ND66bCtm/5/puMdOIovOOqcOiYTKgzLjztcxdmoZVdGaaw8M5dC+pqCi5GAHq3MX34Ia0ejapaCoSd4crE/+N88Eyx15EbMY7jSb8oNajToagVjui4knGdj46JwKvO8Opeyf840GZ4NDsNEU4/wh4q5Lia9MpJ2U/M2bx4x/1NeZ75Bfe2Qv34H4PajgXK4KHp6O1yExNCD4cjGb8TPVcDMfTbU0+NcbCl/19klJQ18Kcq1nWF+j1ZYEhD6gdmbttU0QhjYhqmJqE1K+qL0DR7GvfuezPPyHDZyDUjGdPsZ0pSCTtq2N9ZEMLuRvppyxHfsBjjoOSUGErn8Gty0vx96FOaj4BANdkHBoZsihtSkjQFa8tglQEbthMge9Lawtxbcssu2PQ8x7rGI1Hs5QGMba10C+VmQDj7Y0fxpoC2LqQmqObSj+kn4sJQ4oGpcszkVgpYMK2YY8cEWAUjcK5czcXZ6+7duZTmNLgiCclaW5vjtB81Z2GhWR7rcej4sae+yCGmPSlGAkl1Cfedw8spBOkZqhn5uO/rCZdbYEm31S5S0bYI+aWqtDLn9jufBWYrVMle4IaZ1IQqb2AMLVaZydDY9S1ExMchnUXavrxONEWnSbSKiQEAh8ertfTLFYtb8QpH+06nQtBWvr06AzqWyHpC+VxS8LO8VJJulNFT0ORDUKPQaXbVUNcvB+HcM+wL8Tbv0gUkdI8Q0nK2Uq7KAezzusi3UlqPbWSZbl
 hCx87xOC
 Ll+thX7WRAaK7mY3aIAVIq8OlPitmgSeX7BH6zllT4QjY2YWddlV9Mr1tFjr5kqJCnoGqlqn4oqQyjey5CbLCZFrWRe9v0xhwd1wnwP/HByWs58lFfbY1Gsh7lRBACQF5UH0RkNS/6pL58E5xqPUjBOGRVg1p2TbvWivGQd6woy2iOK69X1HEch86XTNfkGfdZW8xUPfvMZLrLWYhWhu8NdT5FBj7JohgA+4wyFeJX/jwP/Snzq4QWJoeSLu5+oyA+vMIetGCrWGWVJ6GPSR2dwttfrdzsEyOwpf0QLhm2MBnayfgOty05Y+YxRvu+R2ufsbh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's inline it into the single caller to reduce the number of confusing
unmap/zap helpers.

Get rid of the unnecessary BUG_ON().

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 394b2e931974..1c0bcdfc73b7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2056,25 +2056,6 @@ static inline unsigned long zap_p4d_range(struct mmu_gather *tlb,
 	return addr;
 }
 
-static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-		unsigned long addr, unsigned long end,
-		struct zap_details *details)
-{
-	pgd_t *pgd;
-	unsigned long next;
-
-	BUG_ON(addr >= end);
-	tlb_start_vma(tlb, vma);
-	pgd = pgd_offset(vma->vm_mm, addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		next = zap_p4d_range(tlb, vma, pgd, addr, next, details);
-	} while (pgd++, addr = next, addr != end);
-	tlb_end_vma(tlb, vma);
-}
-
 static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
 		struct zap_details *details)
@@ -2100,7 +2081,18 @@ static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			return;
 		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
 	} else {
-		unmap_page_range(tlb, vma, start, end, details);
+		unsigned long next, cur = start;
+		pgd_t *pgd;
+
+		tlb_start_vma(tlb, vma);
+		pgd = pgd_offset(vma->vm_mm, cur);
+		do {
+			next = pgd_addr_end(cur, end);
+			if (pgd_none_or_clear_bad(pgd))
+				continue;
+			next = zap_p4d_range(tlb, vma, pgd, cur, next, details);
+		} while (pgd++, cur = next, cur != end);
+		tlb_end_vma(tlb, vma);
 	}
 }
 
-- 
2.43.0


