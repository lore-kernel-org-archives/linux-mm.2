Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E077C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 16:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EB86B00B6; Fri,  3 Jul 2026 12:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425D36B00B7; Fri,  3 Jul 2026 12:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3146E6B00B8; Fri,  3 Jul 2026 12:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E357D6B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:18:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BD7240169
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:18:38 +0000 (UTC)
X-FDA: 84947973516.23.FC08380
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf26.hostedemail.com (Postfix) with ESMTP id 56F5B140007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:18:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Jf/ZvnV+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=igCegrbz;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783095516;
	b=593iOJ4W7r/cl58N0cCtETQuaQ0CbsfXYj8huLM7zaFIyOxzQWsCelqQaaHuGWYfts6r+/
	6k34Zz6bsBEOwTp94GIdwJhMQWz0wcFZV3nTTTV6L90D5aFHEhqNMVrXrqjOg33euzmQ3G
	fGKhvn/vlxZwCjMpOBlb2cbL4JD1Hds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783095516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=clDPqx1ziC3wm+v9Reh6feCWpBIrASQPY1r+hqGZOcE=;
	b=pML02rpIV9IbqIunFod7b/uHaWTUAvd7Rhgo1Oouo9rhZyH2jD4RQAEEC7m6HvgF8SB9l4
	0MAGUYNZQwV/M/sCV2UwAW93Su2N/+B1PEzjsxtOeTwAkeE6MGjiLQWhr6CNicXPT+xlGN
	4MP+/5CK3Xo0anr0ym3c67ltplgny4Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Jf/ZvnV+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=igCegrbz;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 610717A00BE;
	Fri,  3 Jul 2026 12:18:35 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 03 Jul 2026 12:18:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1783095515; x=1783181915; bh=clDPqx1ziC
	3wm+v9Reh6feCWpBIrASQPY1r+hqGZOcE=; b=Jf/ZvnV+nDA3Srl7AyF1SzZNMs
	4S/urVtNATffjSPYpXuDPqEgq0lg6hmqrhuz0LjY1NWhPCf//eNIPWid2OUdrj60
	1usfIL+oPcAIMdGpN9fhOeEpXtbx2BGxX8UXccshfqQ+EIVoAwKFwIsB18NVfT9U
	Hp4vmiA84za/RBtkh/z8fXt6+cKTxCHdqS6nbRrUgn5ragQQGczkcUSPVbnU/gMw
	+7rxNyP1ZzaVAWvQdHInNv1TWNT+7rujr8DIrsDG4P8iO+e50JWwf20Ay8nbKMNF
	Vc7vsGwgpnMuiYVHjzJad5gen/KtH8zOl1neNRQI9TTgUUlWlc7P+IlFQ7Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783095515; x=1783181915; bh=clDPqx1ziC3wm+v9Reh6feCWpBIrASQPY1r
	+hqGZOcE=; b=igCegrbz/DgX372KAGDXNRJjlJ2kcBQSlRKTrsB8lspD0Xu2B2w
	+ilfvLJdSw5Ke+h+YONoXQijn9jYSIkC+HqfKOBNj1xTcuMmHpyGccrMj+Q3l3bO
	dIlZZf1OZGAK0KSveZ077jBvxiJ6MTcVXGTpIK5VBtohgqw7HoTPvSDRWjZPtWz8
	lquF588jhUG6hJQzmoo1w+7ECT4OLxqdmTY/HwRLMOwgDNwiOuAYGHxr8DIln7Ht
	UP+54NFhGLOlPIiqVMidZ4tASHPQZTvFsJ3v55yHGKRx7mi/C/jo301A9dyMUDmX
	cSTq2vqFNodqeK1FCYb6V4wB8HOsDvZBHbA==
X-ME-Sender: <xms:2uBHakaC9LCPmok1hi76C1pQ55oENwgw4_xnpcIDtJXL65VioDH4cg>
    <xme:2uBHaiddIwLPL7c9lcnHVtKg-jNTw45ehGT6cM3fgn47yQCQkGe6vDxUBw9zGpUc6
    GoLfVSUaXBfg1ZpzWizyxruZCtQUSiOivuzELdBBlhgFt2lx5uPVfA>
X-ME-Received: <xmr:2uBHapmL0bzeXio6Y7gMFJa8KhSvqG1DoWwG4rQ-YMS54XUaYbQ7oJovn07yyw>
X-ME-Proxy-Cause: dmFkZTFL9LKWT3Pov42M5rreNfDWiU0qs2150JDK0uhZc10GatYqJPGQglxOG7FLomA4Me
    6k34nS4NY7D+pvE4GthDq7JjRqsePaV2htcCoMUoEXhih9wWhvcJcXxjk+sh9C4jNhmoGL
    kXREkrbh4aTuyzXWpNnrcBWKNL5yiszUS1i4cLtlKtaFWD8+1nPdnFrrgjm0J9I1mXTU8x
    56QRwz7Rl/xI+MEhU+IJctiKOMbCFnOYXOKr5baYmfhwllP2hQxGVcknrBb7vyK54C8Kz1
    csAwift0xNOIeJU7THcR50bGKKeunjxUuJXYmWTtxuCDEqB4edMDoZ9YvN/S4c1c07olFj
    f31RNS/f40UIpUGzioKVFs4/cwWUfR3quZEZVMJ/fV0Cor5w/ygW00m9s1xmRmEvmLtn1i
    jUMEgNjNdz+kq7qTGHSFU7OtDKIZU44fC7/7qP4JLjMlRHBRQjdIZc5TT+W26wFA9XJBkQ
    aJ91jEu1cl7WvQTXpKlkqBiXcgUp6rmJm41uWJCD23qKLfKfkYWs/05GJL5QaSH1bAWOmA
    jnpGMGQLvmH0jJw/ltsGB7RKcGHgwfj1qc9xGnyM6+h2nUonJsgjy8cKfnk5gXMxXt7PpX
    4v/yjZb7xg/Xn8hGeth8LDAUSMB0ul/WnACcEHes8ztTGtz1KrT6c4g6/sHw
X-ME-Proxy: <xmx:2uBHaq1dsuAnQsE-el1HKw3JTC_Pw7Pd7DOiRRAGE2f8yztXTlnC7g>
    <xmx:2uBHaqe5V-EKInJ9HU-HqlgGP_gGmpxC6JTrFB3REDPlgKxcNms7cg>
    <xmx:2uBHasYmjH2wVv5ZgCvXiJyNAf8qP418FdYwASDqu8dWzJLivRep4w>
    <xmx:2uBHanEohVulFmLAas5dh05y1TSTuY7yd9w61URDJGX8fvm3udNkUA>
    <xmx:2-BHav1z9scnlxI8iFy7VDkV3dAvMj0GuYxWKPvW0m6XpDn7YHw215vQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 12:18:33 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH] mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
Date: Fri,  3 Jul 2026 17:18:33 +0100
Message-ID: <20260703161833.57416-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 56F5B140007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 17xidygfp717594tss6sgyhtgmbx8xgh
X-HE-Tag: 1783095516-810041
X-HE-Meta: U2FsdGVkX1+kV/JPvPEP8Y0IbqU5BZOJC75/I1qfNcrYnoeLsbYsyfLecPMH06DO2sTlBDoNYXw1DDLgKnbQ3JiUFYF6/Ix4pwWuzCPeGUGY92tfmwWTb/0l58NEee9nblvMLHcEjrcrAkLM9p8A6nCIc9E4Sa9jOAsuSQpL3LfhN3upTwp9O8NbbwrrJ7tT4qYBc4GVGn064qMfzTvJsxNnfuqCwB552f+gAoKBeQVli3KCysC/KJg9dTqg9ie9m6GD3SGBBBfxMBjugT/vfnanJNdUNfQz+mJLxHvxaryXCYdeAW9BCEYBx9oBIyaTnl7CwhHzZKHMQ5pfo0wYpVthkvQZ/tzENQXNcBMg8iYkXqtmKHroOmfqymGtIvhHKtoOPxtu3eHVOF9ST5sIkZuoCMV6pqCE6uKy8aBIi5Dy2NpwpHkPSmaRIIl3wZNm8D5xDCClheYPW+P+lzoZ5cQl4CHl0Ge9+Ip8IGi/AQafSPqz0kmI1mgEq6I0ZbWGU/PePw+Z3Of73tGVkYW0iQKC4+z8jOJx7xd7pVo1AmZ/l+e7t81toyXGh9aM97voBkG0FsZgr6frUWaoDcSE+fFMyVgy1fHw5NkKdHyn0u2Y+NynbLJxPY3ShuWjTXn4VCJW05biuBGesmKXHROwUbaUrjyAqV3Le7CdSmGD0uqC+pxk0+yC8zbupCHHxwsFFMrGNWv2CUH9O6QZMBL8a/4fG9sPhXiHa2nfDq2IYH5lDvtNcy1gKIAP/hZIXAHGnGG6jqViMj1+e+QrCgJ1SW8hDb8ZDl2x+6ZyKkgltdMO+y1//N3kSLFyNwgivkJAvaxzsn1LSVklYO0/amLmDk1cVpD6dtKuOpX9BcadeyvgtJgR48W8x11AeDbO7e/G2Tg/u8dFpLAHIwcFeIDeRmdRIJCXLS7l5tfnuyYzcLazu2yJuoiYDVHsrnq6PjBNXAo4WUuZqHAryzxKCaX
 JHf/ISiC
 VQfaTWJYy921fuMfH3+nNCJ75kWJpd5iUkQNv6SSAoR70CfP1Ptkw0UUq8BSRdKJ7S8tyk8pPauYD8xD+2lvbk6/6Fesb5QWWn9iukN0NZji5HBZ5a1x18mQnvJtYvLiLO0xsE9ISCFvTO8VQTP3safQ6/okeJqeVCgh8y7Sx4+07ud6+Q8LZgcTznyI5S68ikQJ1+Wqevab+LLV0oBIqP/rVar4nCQT2pKzX6XCEu1snpmeZhwVTHj6oe+Cki8ce7sBdNZobYLcjtqJPdDkqmwbWnJbemvPfI9zrP+i8hp4o2EGJzcwcAp1qq2jZzH00Pa/fYQZt8P5YDJ9K8nqKZSZ2UgkDqNpqcOq7fngYgwLl+f1u6JEINLOkYxmHjZ3YQh7T1U+pnT05Mc0QM3OynaLzKAlUwU6trLV/Ih1hATVYU7Y/D89AeU/eqCIt6uzx4bMJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

copy_hugetlb_page_range() clears the uffd-wp bit of hwpoison and
migration entries with huge_pte_clear_uffd_wp(), which operates on the
present-PTE bit position. Swap entries keep the uffd-wp state elsewhere
-- the same branches read and set it with pte_swp_uffd_wp() and
pte_swp_mkuffd_wp() -- and the present-PTE position falls into the swap
payload. On x86-64 it lands in the inverted swap offset, where a
naturally-aligned hugetlb PFN always has the affected bit set, so the
clear advances the encoded PFN by two pages.

No userfaultfd needs to be involved: the clear is guarded only by the
child VMA not being uffd-wp registered, so a plain fork() with an
in-flight hugetlb migration entry (or a poisoned hugetlb page) corrupts
the entry copied into the child. Instrumenting the hwpoison branch and
forking after MADV_HWPOISON on a 2MB anon hugetlb page shows:

  offset before=120e00
  offset after =120e02

The fallout is mostly latent: rmap walks match migration entries by
folio range and remove_migration_pte() rebuilds the PTE from the folio,
so a within-folio PFN skew heals once migration completes. But any path
that re-encodes the corrupted offset -- e.g. hugetlb_change_protection()
rewriting a writable migration entry via
make_readable_migration_entry(swp_offset(entry)) -- propagates it, and
an hwpoison entry misidentifies which page is poisoned.

Use pte_swp_clear_uffd_wp(), matching copy_nonpresent_pte() and
move_huge_pte().

Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260703140011.99E601F000E9@smtp.kernel.org/
Fixes: bc70fbf269fd ("mm/hugetlb: handle uffd-wp during fork()")
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-fable-5
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..a4e6dd3a82f4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4918,7 +4918,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 		softleaf = softleaf_from_pte(entry);
 		if (unlikely(softleaf_is_hwpoison(softleaf))) {
 			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+				entry = pte_swp_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(softleaf_is_migration(softleaf))) {
 			bool uffd_wp = pte_swp_uffd_wp(entry);
@@ -4936,7 +4936,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				set_huge_pte_at(src, addr, src_pte, entry, sz);
 			}
 			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+				entry = pte_swp_clear_uffd_wp(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(pte_is_marker(entry))) {
 			const pte_marker marker = copy_pte_marker(softleaf, dst_vma);

base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.54.0


