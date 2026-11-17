Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC321606A331
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WmM7GkES
Received: by kanga.kvack.org (Postfix)
	id 167896B05B2; Tue, 17 Nov 2026 16:24:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118206B05BD; Tue, 17 Nov 2026 16:24:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006606B05BE; Tue, 17 Nov 2026 16:24:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D16AF6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:24:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5FEB11604CF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:24:11 +0000 (UTC)
X-FDA: 85445889102.14.83FA566
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6C2F9180004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:24:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WmM7GkES;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nakixii@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=nakixii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KUVSK4y9hdOD3jl6p+wHE+ISXrH307K2mWbZg23Omjc=;
	b=zbX0HfP72UkywIB1uzQ/PNtqH8m7Wt8o196I4GrghUrGokd8doM4/bRD/FgCKpzseHPHjC
	GwZgo7mxP2ze8vunkP9sfRjwb8HovwjoVWRdqTvfhCn49NsQPUKejzu+7uV9lkokBKuA2q
	+Ae32FM3oz/gN/ITAPwJKzMSiwr55WI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WmM7GkES;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nakixii@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=nakixii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950649;
	b=hg4n14xsg/KrU+r5SoefI8iQdOZU+CnW75b5b2cXDk/04NJHLav6sS2LMoyqcjGTFP9/Ce
	/y7M7f5wkurVwy4+EzbI8L8BHaeA9z8P29lLcY6RWaSVE2cXKPvAozdmwmK/JuMp1wx8K3
	kSO0ciOed5JQHrK7gsGnF7dVS8Fby8o=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8b904d10882so122973b3a.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794950648; x=1795555448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KUVSK4y9hdOD3jl6p+wHE+ISXrH307K2mWbZg23Omjc=;
        b=WmM7GkESgALy5rzFWht91u5QdwkANE/1N1e30pbuRBOx/GW8KbQNPna4l7tin7fOcT
         lgonrZKSeUIXinYJo1MdHPyyDlpBKUvLT2H8eGDyt13Tc+VrRe/RqZQvvnSdxb/y+HK+
         xZXwccUrc7z5d7dYnLdAshUnIK4SrXv6rFt+zMIaKXEUhJV2zc6d2xUMAZfQ9Qmb4o4B
         VzUu9D6P0fGFKYeILc+G2oup2aC5v2dq2p0ptRiOiY7gbX7yvTaOjgADETnGWCCmkRuE
         LSrHh+xPOxDdXtZrE5GCTijhKW7V9Zt8cXLRt6RDsIuHfWG7tM/aAS3+GfGOLwy2DFxs
         hgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794950648; x=1795555448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KUVSK4y9hdOD3jl6p+wHE+ISXrH307K2mWbZg23Omjc=;
        b=PtPCG633xPWxGrgnh/XrvdvuZPQv4YuNF8jBtXu3hDZL9x81Mis9QV7cmW7QZwrXIv
         SDnfwpjFwYIgfAigeV7EoUVibEwwxJ+NV+WmSuaUCohKslQmqUzQSFJ9k0VdzTNDdu+M
         VCXsDTUEL3xSHR6TYNoPERZWOcdxnJHtdjkFiFxfRWD/yj4gnWUEQ4QyKIhWVUC4Vq/5
         BxU9BaGEqXflwObZaguoaYpHxN0pM5YBPffMkr7ePK8lAkZeZufOrClhgPJnlqh4vDHk
         WqZpeCmbl7hExQ7qcpQ9aGQdg5mvfzXMisUEzVbJ3E3e5694iP8iY+hKqH5e6u0Jc8lq
         XdgQ==
X-Forwarded-Encrypted: i=1; AL+hErFuucfU1D9HRojFXs4DuWe2ICecC00V1xcY/qGayZWRbICzet4q6PGfMULPP3G0qXvh6bg7xwhjpg==@kvack.org
X-Gm-Message-State: APuU4Z8iPPU9ENC2e1iK6X7PjSTEtzlCVp3m+K+TM9LGq/VoYwJhaPtk
	taeue+6fizc5TzlsEyWNLhuxWqukX1Pu6ezq2EdVvOTkX2On+9Cgj4lp
X-Gm-Gg: AYBFou2Vw7HjBxmqfgxyQqkJ+Fu8kv1EjymrqfTaaSrh/O/pJ9h8LbhajXh3Crf7dV+
	F9FvMDSMXRLBPEtjGUTIFg80Y+0v5GAF1YzZykDG/tfGeI66PwPnfW3WW/qY6oWcVXmeEPfkCbw
	C42X3pZsCrinEnmJK3o4LYGmnzMnlk443Ai0NdxEZ5YXe8sisN4f81+IBudI1RofK2DhId+W+ed
	UH6w2maq630edJRiDTjb3qgoSIHcTK4WzHR7LwycuNMfl3OjxV95tf974i3Sy5mymOPVoAFQbbg
	iMGQ75v9NWkQZlCgwcyt3rMMUriFBAn2imhbU5EsjauOXxdgzLmNStVesV6470wBiGeNQfjU2Af
	lXbYYBIJwX6HECg5JI2xVFj5hzVzIYD5lOoQn9KqsSvrcauoKaSoddu6khjl2ALV5+KMY6U3ed4
	SO2xh6YhU2nd10wuS8KWBFkEU5+KGs5L2pHQJFYV8G7oGm3r7dgDhxc8zxD3rCmh7cAHxwA0ypj
	YIN2nEqtm9crRMl5fATaABoQEnnY7VK44+XcIEJ59mgVkaMaX0rnDZ7xA6DCJVmK9+PQEfhqNee
	Hph1YPeJhAGEwMdc3/tpNmHRJvG12v4ldzEwwiJ7oIJJ/lQJaLakf0ZO1xnqLgNC+JqK
X-Received: by 2002:a05:6a20:5491:b0:3e2:168b:d317 with SMTP id adf61e73a8af0-3fe97fed6femr539981637.44.1794950647990;
        Tue, 17 Nov 2026 13:24:07 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde3bba8a50sm76865a12.14.2026.11.17.13.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 13:24:07 -0800 (PST)
From: Eric Li <nakixii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/userfaultfd: check exclusivity of the page being moved
Date: Wed, 18 Nov 2026 05:24:00 +0800
Message-ID: <20261117212400.1890820-1-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C2F9180004
X-Stat-Signature: z8yrr87upfsje6hrwfcj18wcrrt91h3w
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794950649-633602
X-HE-Meta: U2FsdGVkX19Nwve1CUgPyBnWwp/CzBRfxxFyaiD/Uzd/cUioI+ESFK1xpkc3FcQyXCH5+HRNEjAnhTHt5P/3kGa++r7YKmaBpW1Te6p9caN6SxRMGvMbShF3TEwG6MPcf0M+TXVqOFRSrlwK2WFSEeVIxVLH8vzJdZUYN7976kYMop00y1q5IcUboLD8jD822Iq89XLrIz7cexRLrzJHiC11wgfe7IoL5teIt49/+d3wvo7rzYU6F6F6XQ7Y5ptZX8QqA1RfIoAmd1UfbKueRJ1eDBcwYKbuitfwovDMcFiNNDhUchGcf7pw6DQIXLyU/5VvQvMc+OHJHRCsQSdERwfJ/rIPo9n8I9B6/ifl4Lv8XZVyYErG3bvuuLdz0JyeIOrQ8NnrbTN3pa23asYuuHtyE9Pa4v4KcoGf0CL6W9SMREKXUDnJk39HQQ7kHzBAa6kROVyWcEA2dQWXgH76f7vbqVayUPAbZZ3Qxi34HAM4y9+FKs+ll7n5sEiRyVjfFUeCMeRCP/a4/PG07xQM30LKPxcrk8Vw0j5+K2PVmnhaFTP2Aw7bLkKGHvTBTpzVe7VleBBVduyRIKNf/6id4RFNv49kKrGtVWMcUs9MhwxS7GlNPI7thpjQjiyiOxYLoDEcGZ4FS+dvQJjvWJ/rT0Rc5W2p6kMCIj7+KS+HsGSquvXREcK1fM6L6lORA47hWVpeBylDBt+77BC8k1exGFpntxyjNELmFtzwbb2BLctqdCJzIHDhb1X/sVKCFr2TSGuUh/lmvSpjGlc2AB/de3htdkvbPx0BL6xVgcGJUIQAXPL2fqLG12pUkuvOYVl5oTCrYwP4BbC3LTtcJ1K//ERiToCry3Pm1CrclARmkElFia3Sc+Six59N6GFlZGqJxAQN+YZqArX3mV951otwxN5fGe687F1fZ5Wj9zVv2GaDXZiqXcVjnNrhAtQUwak41tVBAOUrkoWqBlYfYLi
 dxtij1nl
 IRWep6R9D6xqedvFlt+N3nO1efj9piYBF0mOONUFPHx7E602f16vDAFMdbMUCYTQLWakzm7OvgmpbzwzJ03cl7zMsRblPBpb4UX6rligDw1z1se2KdC9WTxKKtw8qlBr5VRAbZvfDbtrKYZLrcaYv9KK7XMYquPN922zz8KnpaghgEnoutLUtmuxSIG/aHFdra3PlGbn2+3/hQpqJrAwLjj9XufEv9gXe2V2UseCqfyjqNhc0VbWuUcJSwwbb1ekcS/zkZczWIHr2JZBueEQUVzK8xQVxWMSbFl3UWTWUHEkXwlDa4dU+6xyHsvsiK0TuUdIrBJwNWETVgn1909zQB+gwAFDQbPz9WQB526pgRLAVqxQYsgU8Cxq3MFcVNYZRjO2cTz0NMOrYmc1wjT+kXI1Mesz1H/Fl6WNJ+/FTeGlGomxrEfuo1XokVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_pages_ptes() gets the folio of a present source PTE and then checks
PageAnonExclusive() on the first page of that folio.  PG_anon_exclusive
is per page, so for a PTE-mapped large folio this can give the wrong
answer for the page that is actually being moved.

This happens after fork().  fork() clears the flag on every page of the
folio.  Once the child exits, a write fault in the parent can reuse the
large folio, and do_wp_page() sets the flag again only on the faulting
page.  This case only exists since commit 1da190f4d0a6 ("mm:
Copy-on-Write (COW) reuse support for PTE-mapped THP").  Before that,
the same state could already come from fork() after MADV_DONTFORK on
part of the folio, or from reclaim when try_to_unmap() replaces the
earlier pages with swap entries and then fails on a later one.

Moving that page with UFFDIO_MOVE then fails with -EBUSY, even though
the folio could be split and the page moved.  Callers that fall back to
UFFDIO_COPY on -EBUSY end up copying instead.  It also goes wrong the
other way: if the first page is exclusive and the page being moved is
not, the folio is split for nothing before the retry sees the shared
page and returns -EBUSY.

Check the flag on the page mapped by the source PTE and get the folio
from that page.  Locking, refcounting and the split-and-retry path stay
the same.  The batched path only handles small folios and the PMD path
already checks the page the PMD maps, so they don't need this.

Tested in an x86_64 KVM guest on mm-unstable with only 64K anonymous
mTHP enabled: map a 64K-aligned region backed by one large folio, fork,
let the child exit, write to the sixth page and move it.  Without this
patch all 20 moves failed with -EBUSY.  With it all 20 worked and the
data was correct.  Moving the first page right after fork() still fails
with -EBUSY, as it should.  Writing to the first page instead and moving
the sixth fails with -EBUSY either way, but without this patch the folio
was also split all 20 times.  The move tests in uffd-unit-tests pass
with and without the patch (the two swap tests were skipped, there is
no swap in the guest).  I didn't reproduce the MADV_DONTFORK or reclaim
cases and didn't test arm64.

I found this with Claude Code while debugging an out-of-tree swap
backend, and it wrote the first version of the fix.  This version, the
changelog and the reproducer were also done with AI help.  I've reviewed
all of it.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Link: https://lore.kernel.org/all/20261116110122.309748-1-nakixii@gmail.com/
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Eric Li <nakixii@gmail.com>
---

Notes:
    v2:
    - Say in the changelog that the fork() case only exists since
      1da190f4d0a6, and describe the needless split when only the first
      page is exclusive (Mike)
    - Mention fork() after MADV_DONTFORK on part of the folio as an older
      way to get there (David)
    - Check the page before taking its folio (Mike)
    - Sign off with my real name (Mike)
    - Add Mike's Acked-by
    
    v1: https://lore.kernel.org/all/20261117191853.1314834-1-nakixii@gmail.com/

 mm/userfaultfd.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d65184d9a..e270b5722 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1557,6 +1557,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 		 */
 		if (!src_folio) {
 			struct folio *folio;
+			struct page *page;
 			bool locked;
 
 			/*
@@ -1570,13 +1571,20 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 				goto out;
 			}
 
-			folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
-			if (!folio || !PageAnonExclusive(&folio->page)) {
+			/*
+			 * PG_anon_exclusive is per page. The first page of a
+			 * large folio can be shared while the page mapped here
+			 * is still exclusive, so check the page being moved.
+			 */
+			page = vm_normal_page(src_vma, src_addr, orig_src_pte);
+			if (!page || !PageAnonExclusive(page)) {
 				spin_unlock(src_ptl);
 				ret = -EBUSY;
 				goto out;
 			}
 
+			folio = page_folio(page);
+
 			locked = folio_trylock(folio);
 			/*
 			 * We avoid waiting for folio lock with a raised

base-commit: 81188836663676f8503f3603cfe56e88264c4d50
-- 
2.43.0


