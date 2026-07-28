Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC518C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9E06B009F; Tue, 28 Jul 2026 09:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C0C6B00A0; Tue, 28 Jul 2026 09:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89E56B00A1; Tue, 28 Jul 2026 09:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0B46B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:08:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F9CB80394
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:45 +0000 (UTC)
X-FDA: 85038215010.03.417FD5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7049440002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jarQQNfZ;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785244123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sxlim6Jm3YtcLECKKEooguzj3UphetqkoUwty9M5B0=;
	b=B7XQRC4Jqjfzjd51+hSJtdhV0LhymxWu5v3fPNwKh0K9gDiWXSGBRlZX8H0uriVKK6ragX
	BLVjLT9aP5N2GFkOV/tqz2yvr2jVySg6VAbXcbKqujJ3IBbjk7rS+QDwN+lKbDqqOxH7Ld
	Cdi2PVzUd1KeCNHFWlyMzR/q1v3KuCg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785244123;
	b=m7TradyuDX2hH2F2JIlpzSCeAve9X2inarIZ+LyvpvUs67td+s4qc9R5+3xJfYhB22P7D4
	xIIa3pQc1WJNEy5DTOSINgrq+dy6f2KFlmav7v0J+TvRKLY1ZopYDDOJUjrLFKBPlOo1Qi
	Hm8xwg984bmH9vcsOEW4fMbGDi0V5/c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jarQQNfZ;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1215D60AA9;
	Tue, 28 Jul 2026 13:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B051F000E9;
	Tue, 28 Jul 2026 13:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785244122;
	bh=3sxlim6Jm3YtcLECKKEooguzj3UphetqkoUwty9M5B0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jarQQNfZ22qSDtdYLOxTo6gp1glpSKTDMwZLTumpSpou4pkARWfxuXW0DuYezdnxI
	 55l6PTEocmVCk9K6xmlrSUHC2LEsxlHfleAW0kpx5eyjBAjehHSRdwr4qAw3a8N2UW
	 up1JsYO0nEFjLX0TKB96knGccON9uyl9aMGQ+rm52v5U0Cbul/sAhSc4py+kIKozAm
	 myeiesn/+aSopbFgd2lqsMXmU00rMXpXPFzh5qU1gPmmtJ1/F+xaMy8mvMSlHXWScB
	 uV4spMcQaPfqHEYQqNvv4Lz3lbxD5/HYN0H8ZYaoAJf39wAxREkcJrXY4XFGPMWCo1
	 wp1qoELYYdhvQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 28 Jul 2026 16:07:48 +0300
Subject: [PATCH 5/5] x86/mm/pat: fix effective RW computation in
 lookup_address_in_pgd_attr()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-cpa-fixes-v1-5-2ed2352300b3@kernel.org>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
In-Reply-To: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
 Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
 Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, x86@kernel.org, syzbot@syzkaller.appspotmail.com
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: 7049440002
X-Stat-Signature: xpgx8qgy1h1oznkbotubyat34ha4m9in
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785244123-341501
X-HE-Meta: U2FsdGVkX18JmDv2Dmgl0zSQAg5ci8TIATx3hlyUnKfrbGmQidLAT4YwQAwo2Sst+RqCI9HkkE0dP4viJyVXtuGi2YnvtzJRQHB4imi739xVBQqsvpmDS1ARuRYb2b/ro+Xczfs+uWidBU+9rXLUA9EQX+R8aJg+kUFYfgAl3izlpu/ubk/ID9wfm/71oNasyNwYiP6NmvaRGrgulgHr7iLAz6NxRBmvumLVaimZpzV8lsnYhR8HIdHkGq7rFZwRytHsfgXvFyf3pcSxbiumwJMfe1mIoiB7TW05cov76N3M6oUZs78Et77C5KI/PICzk5BrFuJ949BU/wFg8GX3oLocdQ/ppaDniJ5OIMuMzyjrrw9kXBUwIcHxEaG5iZPRrNo5J4zr2KvKLd6+TJlRBL4MiMYBc+H/+CRxRJJ64EbIwAtz6T5h0wv+puRTmDhJlXdXDAaCXCNCwBfUZP8/a1aw5OIQBBjsQfuDF9SpEjx+ufQQeDJczKtpsPJofwDzgLBz0nQ0CmLfgLs8+zFVRNvrePifz+BWIvj/tW1c3LWCLE+GgUgSt92Y7Mc1r/Jn+ukNOKYnZpZ82TkOnWGJnP33JQK1Z4rmxcNyehGB+a1hgP2CObzh8snNDzWahtI/8cRUXA9/VDIPz5omYlH/YE1LRkm6JF8ga8P8Uo/RPspTJ5j/ShuzciT3EZO0AnRs1i36mwOkEpKip4Km3wFAev5+dAmnEbAw6iugddbieSKHB5xIONYg4l6bl66VbkK3/QflDW6Z2HK1akKgCNtmOT9JeeFrH62XErjD+W7iwohnF2dSTG5Vh2V+tob4P/Dpu8Co2iO8z3G8Rb6zjq5BcQaXReu+Hd6ijflOAoqF8Exj/b+9sVeXL2xOd6Fnz0/x/tUKSh5y1eYDAFZSgCShJ5OFF42nSq1QCVeFRY/ef5Ybpo/0/NNXtHZ9CXR52VYtSJL38onoFkP5d/WV2XV
 9DuYYOer
 IMDPysZ6Mb/3SrVHxC4bcgUpjDMQq9N8RB8kC1VK/MzdpRdIbQSOLVpPaUsUBaYTnSsxq6pTfJ6Vs6yDnr+n+ZpeCDs5sX4NvliCrGObtt7kdMoL2P8zhL9bJjhWergl0/mau4do5wQ5khrdPLgnzZlocKLeo9m03tJnsudqZgEZYG9n/4IfHyl0/+d3pspxsb5L6enAjplZwnvaepsFaQsujJ1D1SZJESNsayjOc8umiWWUK39oWU7BCj60I3k9o8p57dKIt6q79zh2DzhswFKY2GiuwOo8Apo/rL0L0QZv8yQ6NqTOkn7gXs4DeVO69JN3AF2fQfLa3uR3IY9kCraDwH3FPEI9TzNaRF0ihr15oY2DFvBGO3I0iM0d43NZKc1C5dROjawzEq68fitrtc1ozQlNrMh5n+879id4ELUnOu/EapXeQ20TPUb/8Ln5iHVSL2YAJeAkPvlE/e10G4jL5xqiepw0JJ7ai9/YZQbB7LP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lookup_address_in_pgd_attr() accumulates the effective NX and RW bits of
the walked page table levels so that verify_rwx() can detect mappings that
are both writable and executable.

The RW bits are folded into a bool with

	rw &= pXd_flags(*pXd) & _PAGE_RW;

but _PAGE_RW is 0x2. So consider the accumulation line:

        rw &= pXd_flags(*pXd) & _PAGE_RW;

where rw=0x1 and the right side evaluates down to 0x2. It'll end up doing:

        rw = 0x1 & 0x2

and rw always ends up 0.

This way rw becomes false at the first level walked, regardless of the
actual permissions, and verify_rwx() treats every mapping as non-writable
and never reports a W^X violation.

Add double negation to the right side to normalize the _PAGE_RW flag to
0 or 1.

Fixes: ceb647b4b529 ("x86/pat: Introduce lookup_address_in_pgd_attr()")
Cc: stable@vger.kernel.org
Assisted-by: Copilot:claude-opus-4.8
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 1b63d4caba20..7d656520887c 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -769,7 +769,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_512G;
 	*nx |= pgd_flags(*pgd) & _PAGE_NX;
-	*rw &= pgd_flags(*pgd) & _PAGE_RW;
+	*rw &= !!(pgd_flags(*pgd) & _PAGE_RW);
 
 	p4d = p4d_offset(pgd, address);
 	if (p4d_none(*p4d))
@@ -780,7 +780,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_1G;
 	*nx |= p4d_flags(*p4d) & _PAGE_NX;
-	*rw &= p4d_flags(*p4d) & _PAGE_RW;
+	*rw &= !!(p4d_flags(*p4d) & _PAGE_RW);
 
 	pud = pud_offset(p4d, address);
 	if (pud_none(*pud))
@@ -791,7 +791,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_2M;
 	*nx |= pud_flags(*pud) & _PAGE_NX;
-	*rw &= pud_flags(*pud) & _PAGE_RW;
+	*rw &= !!(pud_flags(*pud) & _PAGE_RW);
 
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
@@ -802,7 +802,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_4K;
 	*nx |= pmd_flags(*pmd) & _PAGE_NX;
-	*rw &= pmd_flags(*pmd) & _PAGE_RW;
+	*rw &= !!(pmd_flags(*pmd) & _PAGE_RW);
 
 	return pte_offset_kernel(pmd, address);
 }

-- 
2.53.0


