Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8EB8C98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 12:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E936B008C; Sat, 26 Sep 2026 08:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08D86B0092; Sat, 26 Sep 2026 08:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E256B0093; Sat, 26 Sep 2026 08:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6986B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:42:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EE25120899
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:42:00 +0000 (UTC)
X-FDA: 85255875600.26.872BA87
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5BCE8120005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:41:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OGCd3kyC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790426518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxUX0NroNmM2djP5qsrTpM2pYvDo5f/LrOtTkWteY6U=;
	b=0ajzLbAcgf8jfAgJfywFUHXIskjJ/0pAb4QJiRVWy4/SNeECAVESJnXAffCI1DX7Jh1A0Y
	vE7bzTQlJ07wKcqXOLRtpJrA5hZ1BUj+NSxFK/Ps5L7440uAnoEc+o1Mp6vDYH4bckwdX6
	DVc8oNP9I2b0IKISOrFTFjDD0iTyv0Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OGCd3kyC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790426518;
	b=GaFOScQTwoPnnk2QyAMJ9yaJbFMX0+r2aYQlHBmqYW+1HcletKJdGa3TkXOUtB1OHc3pvb
	Og9uxfpFyVotGXyUnCfbtSQliRIW1oaTZUI13bfHij5jMn4LjjIrXE7Fa/HEXWAe5/cb9E
	eN3FSpn2l9FAFC9le5Txe5ip74CxmJw=
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0dc47fee0so230620a91.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790426517; x=1791031317; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YxUX0NroNmM2djP5qsrTpM2pYvDo5f/LrOtTkWteY6U=;
        b=OGCd3kyCj/xQYf8BpwNiBx6FD1lNkihNaxC7R8P37xX4AiH1+A9m6Hg6UjVVgfQlEr
         kOPI+pMVRVPH1zpyiGpvO4u/CYT6uh+3UgKxK7jVG/boLW5cgmYS3j2YWVhagK6BCnaH
         oDyAofIkAQ9kB4bS/kifgCNRZi69NMf3CS69xMn/0XUo89bDHJhM1OHKk7O8VPRbGQut
         O2wOBEg/UoOkXCq6MnVG05gqk4lnRnSaao1XdVHRvve1jK0b5mszmmbgFiRUYM4hZi+l
         Js5VPvoDZjnnOwQiyIdy9UprAEJgWDQMIpi4ynnaaxg1M003GPLIYPLo1VOJekjzarWk
         Hn+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790426517; x=1791031317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YxUX0NroNmM2djP5qsrTpM2pYvDo5f/LrOtTkWteY6U=;
        b=BletsfLd8iYXjdZAwVF7s3EjqceUTeCsL+LmVV9behhMUG7eClQ/o/qC3uVOiCfjYC
         6JUIY+lCxNQ46J2Gppm1D7QBpQqrg/O0BOdttRymi5WN9h+wRlS4W4K3jhjGGHZaKVgV
         mELRBtgYScNM88nj/W3TJNImHxLkKAjNA/1uK+jLIE5f3dQTLiek6eFL6fNDtwf5lDYL
         KkGRVI0XlVTHk7QXuL4PW0shzom59d5ik0r6K8zuDC0m93gScUEFto713wC5T0MmiuDN
         uYXPYJReaARwYkMiQ1vpZPmzc9y8/ws+z6mqHGEDiTldoA1pZsOMejxLgqCde09j3Uyg
         BIIQ==
X-Forwarded-Encrypted: i=1; AKwUvBxcgc7GCPXt0JpoeEjF8Wrj2tR9t5dOUby+cxB4AjI0twKPidowTFBwezpkD4fnjnlAitYWcrCZ8A==@kvack.org
X-Gm-Message-State: AFq9FYLb4fDwVI7wnwvOQeakn0dmxysdqz8yWIs7n5IqHWVSvDoScZzJ
	31wmEfsXQCOy4iGtcL4vL+lkwXbkrLjQC79BofhRIpVMXJKJ4nfoW/rRIu1CrEEPKA==
X-Gm-Gg: AYBFou2QGqZVEl8C64tZKIvOlAUAjnomFVESC7yI6sM3rexhP0fiaYr4GpVvAbm1olI
	tWeyncvYCf9eD8Pzp0o6Tfh3ey+6RtabsQGKZZh7nUT9DGHbnsDaJmVrTXcRb1zzZ4nqdPLjh/j
	z6kggDE2EOvjo/OsHhc5Xr3P2sFpoauQly5b3rWrTpcsjy5Bms0Um1cwsh5A9fBN509NbPZTCsh
	MAbPY0y9GFIjIoCgbYAHekmqljjpTOllfwakwyTRymC+zyjotEken3zICZycJdPnqFvt48UI/Mc
	n+1irvHEyeMdScLjJNJTxA1BBkB7X4giuMge3yfg5PSzp29V1QWDODe5NSeFu+IVx3aTenE8uyL
	f1J49ern7jXXcyhEXTvSYqgUl8Xb4EXpZbxz8P4CctocRiPqucz+tYxv/+Elf9qVo4QDzhUAvXe
	W/AZuUoPztSnpGpqEc9KvTKj8R3ngcnmRCSClxF5ubJDCfOR4qPNoelkcnxah0Ea02JJBFkDzfp
	Q2zkBxZL6Zq/CkbO3klPhkF3RqTJ7wTs4k=
X-Received: by 2002:a17:90b:1a8a:b0:3a0:cb48:df68 with SMTP id 98e67ed59e1d1-3a0cb48e2afmr3146943a91.13.1790426517221;
        Sat, 26 Sep 2026 05:41:57 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0cd1c4ec9sm5965212a91.16.2026.09.26.05.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 05:41:56 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kirill@shutemov.name,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Sat, 26 Sep 2026 21:41:44 +0900
Message-ID: <20260926124145.2878520-2-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com>
References: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zdnetnyxmcmarcb1ta4dp9srd93a5fef
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5BCE8120005
X-HE-Tag: 1790426518-439938
X-HE-Meta: U2FsdGVkX1++ROcGm4xMqKOGt4q6dhEreZKO6qCZ/GCtb9AB0bp/RRn0kmF1zsELS9LbE8X4UryQQvrxuN12WiLgW+s95yF4KlwDIL+kt2iMv0N67ST2pdGN3tDskg6wavEB67rQORogOsNE1i0MYpL/vSnbn4cRDrsb0DInjZA+lqH+Git0dhfrr8tNdz2RZkB0qzibSTZJ0oZ/VcPiaaq3gFDVD8eIJYFXabOrH10HkH0sCsPn0MzKgiyo2X4gTmTOuEIMaxYMywbAKRyaaYS3DSJpsjAGe7I0JS6npuykbBehxrQsdJdzmR0psCAB2wZ2mNpFBIRYQ9VlanTZikveUKP8UnSytpBJxt0XZLQlnhxdlXQvC+cGUbOK0nTpoONZyyCeThdkLdhlFPPPSi3m8K8OOjG2ts26JG1F7vq9TSP/NPL19RS5ZvqTuqbiZI27oySaMmVL1RtgypvrJTHo5fCyzHvTqw3ZuD7YMMETSUIkPTzAswzyq+ZHotHG58W9XwYF1bTzAhdB1khIZn7AFKw4CGPQtG/hveZjmvQ3Eaol2yRRVXc3XgXaBx9W6goF0/YlUIwmK/hwmw9kuhWmTnyBqGngi+185LivwRggtauNsB7ChW7l7lrZWekWy0ml5deufTGgLsiueBVleswZa71V51b8+QmHIppMCow6JLioI6p+8M8aIooC2h6pladVsi1WB5gFYxZvxV28aWjtfAQYvQtPAOQH7Sp6NPSGhiRG0RT6S0GpKzoEZCI56SSmz8oKLnUqYrQBWdEnQFfTR77pknnFLPPJelqNW2SN1libP39a/O2uH/gMVsaqDlvpGaHHcE4iGDq0diZM5cmo0aDRUadaMsOlC3TeTlzJjla9gg1ZhL6IzLSOTLMhXfOJcWZ0KSpTuaCrzxwxR9TPtboQWyWkPcYcn2UZBq39Sd+y2iFc+Au2XpdSSJdYsFKl+R/J9xTy55Ds5kQ
 A9a5hIdG
 ESda0R+QV69Qo6nmb8GjitlqwblfCElBHL/gaeVGE2X5qTrC5PBbxc7vPrZjmt5gXVAXJNoD+EbFXAJ2e+ePtNWko5yy5HXczxt39oattmRCzyNKVD3AHjv9xNvCeDzbe4WMZ/YBdxohRFjhDMHUKqoc10bUjfm2AFzOTtgpJjDeEWiy7D3xjO3gqH+sxRJtUs0Mi4CqaSalXk8w2Z2bYZSRCyhchLCJeo8Ttjki6u1l82M0FYFfwTgot0uHGMUKoOpBn4W6hqW7PRg+Qsr4m9YP5tM1DShGe8fFEFlrVq33vAzSb4PoPj1uwGmim92BnGQnncI66RDJuqqpOrf36aF6N9l2aTzDlWZftky7hMuGVEechOjjhJT5D+aO5QrtMZ5TVaP7C05r8B7f7dTJQ4U2ZAqKAL3e5VMyTAfWtKmw+HB0n7E8/PhI/hDQiLGRz179wZzZNAaaVMXGrWuQtBP8apg9WYsk6BBzDgPam75vNViqQ7jBp7rvyA4AwG4HSodeXjNNlac+DFULkHUe3jeAOxrtOPjLB0WNpe0rZVrRBioXGbJI0qFLJGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on a write-protected or
RWP-protected source lands in a destination VMA that was never
registered for either.  Nothing clears it there, and userspace sees:

 - /proc/<pid>/pagemap reports the page as uffd-tracked (bit 57), both
   while it is swapped out and after it is faulted back in.
 - MADV_COLLAPSE fails with EINVAL on a range containing it, because the
   collapse scan bails on a swap entry with the uffd bit set.
 - With CONFIG_PAGE_TABLE_CHECK, faulting the page in warns.
   do_swap_page() carries the bit into the present PTE and, since the
   destination isn't WP-registered, also makes it writable:

   WARNING: mm/page_table_check.c:202 at __page_table_check_ptes_set+0x185/0x1e0
   Call Trace:
    set_ptes+0x67/0xc0
    do_swap_page+0x990/0xfe0
    __handle_mm_fault+0x7d0/0xeb0
    handle_mm_fault+0x9c/0x250
    do_user_addr_fault+0x207/0x650
    exc_page_fault+0x65/0x150
    asm_exc_page_fault+0x26/0x30

Reaching it takes UFFDIO_MOVE out of a WP- or RWP-protected area into
one that isn't, on a page that is swapped out at the time.  It hasn't
been seen in practice.

A resident page doesn't carry the bit, because move_present_ptes() builds
the destination PTE from dst_vma->vm_page_prot.  Clear it on the moved
swap entry as well, then re-arm it if the destination is RWP-registered.

The WP case has been there since v6.8, where UFFDIO_MOVE was added.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
 mm/userfaultfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 74f04c323c50f..f39f109f17989 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1449,6 +1449,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 	if (pgtable_supports_soft_dirty())
 		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
+	orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
 	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
 	if (userfaultfd_rwp(dst_vma))
 		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
-- 
2.53.0


