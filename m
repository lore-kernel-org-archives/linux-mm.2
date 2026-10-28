Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741E0606A338
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=gy8OenAF;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=H8GnFBEZ
Received: by kanga.kvack.org (Postfix)
	id 961E76B05B2; Wed, 28 Oct 2026 09:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913B06B05B3; Wed, 28 Oct 2026 09:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802276B05B4; Wed, 28 Oct 2026 09:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 556796B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:26:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C889340CB2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:26:32 +0000 (UTC)
X-FDA: 85372109424.08.5D2657E
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9E50720002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:26:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=gy8OenAF;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=H8GnFBEZ;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793193990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nGV8TGo/yLZr4o9PiqDwm5LBW5oZMSj/CX19OZeK0Do=;
	b=Ip40P+lvS9oIWUFNLEnzTAGSbVAuXoxHjP3NylJEvOw7XNZo4GKK4a24dQlUXMETPG1vIp
	pUXta4fb3gVLghw0sUXrA0A+bH8oJtB8/f0Wr+u+cvevYXhhOS4hgsXYsFiZU4rGvt4Sma
	x86qJJ7LmP2a2GGftAGvxMxrdh5PRCI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=gy8OenAF;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=H8GnFBEZ;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793193990;
	b=s8lgBiKNwpz1H5LHHHHkjWoyZiwT4Agla36WWDw9s/+1uOaAZbrkif4EcnGWYccPdx7q+l
	gvcLy/tjQO7NUk19+hUuF5+5eg0DXrI70ydCYYI4b4xZZnk1u7c6G35H9H1D7u9HiqnTzv
	W+ZPRWrsWCsBajYf3S3p/2k/Fg0Z5E8=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id BBD031301F0E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:26:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 28 Oct 2026 09:26:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1793193986; x=1793201186; bh=nGV8TGo/yL
	Zr4o9PiqDwm5LBW5oZMSj/CX19OZeK0Do=; b=gy8OenAFMLHfaZG0qmRFdJB67l
	2fdnIqzhzrXbNNxQwblZ6fJC/9T3uIZpJVPeVkYlSlSrwr2HmVyg7+nixwLiNTZy
	m+lOrTOcbrjqrXxD4J8Su0i4QF8hn56tFUJs/T/w/G9uUaqkeah42XO4glWc7aZC
	5qS2fA+F6MLR4FEE3cKDHbbgdCB4TBj/NvL0JeXjZyj6HED78UMY4bR+3lieqR4U
	yD5zrL2/WurM8KF8xvTIFukBwNilVrnqjyteq/Tac11pYShlDy0eMcb7sihS7EcY
	MllQAm5tGQuUylHSBQxU/2Bxavc4F3xM/0DXCjT6Ua/O2GwUqKrBuLhqFvcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793193986; x=1793201186; bh=nGV8TGo/yLZr4o9PiqDwm5LBW5oZMSj/CX1
	9OZeK0Do=; b=H8GnFBEZYw4ImYs4/EgX41yMD2bVchofdDp5MgKLd7TDbqo/uqp
	YYFsgRUXKR5BZTKIrQZ42ASDrpoYoffMP9yWHZV8Hf0wJKMmbfkRTX8ePRaTagsL
	ihy+vQh/aebhd70bPT2OaUBq3tOSt901l4j/ENCwyzfvmMnSaqscaYhUtIoHxNwh
	GRRB+3QaILezQc4gyBhlGi8vDhaK4FoeX2HHrO+k5EkRY6J4iCT8YTzzTqa4Nrki
	/nYmsNWQTufXvPOASD0/Vc/TVEhiV1p6TcjrZsIOAHMRLs1vHpO8PdfARTaTiKv9
	BQAQs+a11S0Jle1pzWUv14AgfUXfMqRFpWA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793193986; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:AbWeUNMV7nnrZcCexnJMrCsl785vMyC2XYXtkVjdzDU/3rV
	BfTCqyYc9Q2VSI63RFV9r9REmnqeDR1SUJyiRyLncPq1RmaZow7zp782D0wAbSJU
	CWSR2Dz8HLzzayP/+aM5UAiPSctwuu8j7wQAmSudG/bxpKCui2rsWaUZXStDMeNH
	ODcNN+DiKwAGQlYG0igNNEixBiSoNSs/zFW76a1y5v00syUdMgaO27oXtEqTvt1O
	wusIbkBBjHqFi9OY2EoMVjY2WoAcqjgCq/1zqmNcXREd7eTU+sUeioY8yspjtyVZ
	O2y0eu+j6ShL95AlcmQbiPIkM+RpuXzwbHOqyWw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:OA/Jt433qooHZMN1h1WfoAm++DE0cH2Dg90+cuGoGF0=:ry0dPA1lG7EjfUdotOKwWx/qimPuaUA0TcFFKTFqWn4=;
X-ME-Sender: <xms:AfjhatVj2es6gkQDMYQSgr9nxnbON-bIYFOsUIt37tagNRyuhwXm9Q>
    <xme:AfjhaoGHWCR8fomC0IqSeRFAEWFbBKJnCKrOAfDp7VV62yKXdXHI6Th7JE8cDZCyb
    HNvoQyqIPqVQkeARlQ_2a6odwsaiNCfaip38ojLX4wTk4NYEMtzARg>
X-ME-Received: <xmr:AfjhamU1gRIgp1j7PumnllJnE-T69J7QMo2nhORsgGaGgqrJRxqUWrfyq3I>
X-ME-Proxy-Cause: dmFkZTEBob7BBdDUpiR/GngnoqTsMBf2/lBIU/4HIblrHHKKO1LG8nWmV+7kthh8R/a2+K
    vcfJ3uMRW+8EZo1Is4k2ufyPCCwrsPei6dHydg9OvN+DJ9ptNt4hF/42xgm86G3vfDFHFj
    rdodipbfc74DZ5B354ocfR6zFiENC1woBoZk1x/ZFax9UASuUX/LRAr4Qoo7LtIuZAV8VH
    OztBs+qrN3d8zQvSyiTswcoP/a8mprmxxZ/Wzc/DE2pxN1fA2dga3xnGCDSCF7IiQoJS3C
    B9pIX8YIbUTKmafQ4a6iV/l7Ku/n4maIj2OlC3uit0Ir3lO1BxAO7Hfq2OD9EQ9EOO0ljG
    B4Q3IRTbmCFH2ma40rgv4JCOmdm+r8iEJ6icf2+NG2H6lOA/Ax4QrzuN2phS+JzcCTn9E/
    kLVAnQI4wjHgFI2u7cS3K+U76cFQfnfRsJEtk4k5nLoK+xaEVpCg8x9dxO3DXiIQTABV/r
    XiBZGg41Qbn9j23Fk4tRQviTsR+xLuH+RiCgV60VFsQ5URba42Yhm7FI9epUrEYXDKYdO/
    nDkGBnLdaj2XXiW4bsemjDHZlRNY5u2M7ZyIE8HioffVyz8YblTM4a1CyIMMTrYtNIEUEI
    cTQ9jIRCDK8BNbXYM1vpt7b5C62QKRUgZGqyoOOYaMHzf6rPuK+xZN2MmRSw
X-ME-Proxy: <xmx:AfjhajBBheFrS7CaCUtr6xJEUuZdFR4f0RoSMw1N3bD-YtO15xUe4A>
    <xmx:Afjhav0kTEtLGRfMbaAhFlI8SghYxSexJbZJf_j1gEOAR1c0M89G2A>
    <xmx:AfjharRkGw49QdBD_N4SdpyevUijtPGNurC0nUexAALVMuotUFlC2w>
    <xmx:AfjhakYRy4M27O9Is9nnt_U7V-j5DomIw2ZtZr2732YsXq13Fp1Fxw>
    <xmx:Avjhag5tmHV-eZkrvxuU6XGq8oClFUrtxYsrXKOXtWHKbZUb5YanxnFJ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 09:26:25 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Frank van der Linden <fvdl@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/hugetlb_vmemmap: map the shared tail page writable
Date: Wed, 28 Oct 2026 13:26:21 +0000
Message-ID: <20261028132623.2560146-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E50720002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bnrbq5k9p8fn8tuxbofmz39npopdncfo
X-HE-Tag: 1793193990-261781
X-HE-Meta: U2FsdGVkX1/ULXoX8fX5+jBWAhVcK6uMM+8Euvd5uWEK2MgBFXC1IbKFlcJaq0UT7+LA4VgpEbRzKSmK2LU5+s+uCl+Tm/EqOk8XI29zfiS8ANMFW6/pmh/SmX7EKwvrW5uOoW/rF2qm2mFyTMawIXMk66QeSQt9FglvMHyyPAtQydlP1TCzTGfugY1vSU71CrtNoot2MUmm7YMMds57OYSs1WRx+QrRx7QLt3rYFf7ZLbD/5S/S315hVRs2Jd/JFvXJpI4yXbkcZGpv9o3aJmxo7/iiROVPxUaFvCI5IE+FQqPE33zQ/1fMNn15BY2GqdOLNtrfTm9EdHM5hEAjawPIrl556vLd36s5P6AsIe1q1QgLObXakQambtzbU7AV+LDXh4cT69rBM/r+6vb1laA7xYFoQ8zmiCvVxnbKuh7795g8pCNEYq24ktOjAp0vIYdnEo+I6S9lRTWCuaAK6R1dC2fn+0jNdkRWT4dm7KQ+Utr5ZMEe3VKPYW47gY5bEsTpej2datPOdzTmBQKqSYAM06T75fZzY1FNN7ZFqWjgYaHC6KylLFB8QbxlBFtF1MyPULbNjOQOlc6pz4Yl5xeeZ7uhLNjjDrQfOU0IDoBO9Rh7AutUYXqleBHCpOuAgQFbvp6iS6T95owbpLkrRi8axxxVL8ooXTNfhD3AwoyV1MHWIjVfKPvx7oDIjfRq/0CjgqfycE/FVxx/QSzvP3Ec5GcwMND1pzCkWdpCVgxx+J4eqsJUhAZeJGYPO6pPlbnaPwkRMpmZr29478iPsTbWWhbrLpQLIRuFYF7X0w3tNGIZPVXclKJ8bPOUXybb6GJdmX2XexYngg7i8lm2x1qZU+Qwba7xco3BflX0nSQZHh+IHFZ6wyLn/o2IJiTSscRg/J8uVu7ijIV9KM2811Uj68g6IEjveNQQeHEFk4eELWZB0nj8/mEx/o9g7GD251dKukYL1VgZTi8Mrnj
 PFpqDhqy
 x0RsNmChmMlNOSjKLxeKrloM45z/nrFqfu+c2RC+j3qgEDD4aRVR/kzahUdkwvSoQeL5ydHXUu6XMuhVkDY67WDaYYiN6hVGwS8NFHvlgUcymWDR4QuTJfjjEz9+PV8RLsirQw0lyH8euJfhfH0U+c+YD1gMxJkuJeBIzIgpGkEtse8J7AuA/ZkYzppmwPh/2LMLonHp4on7SYb3OUS7D+hUYvt62Gf5oPzDkzIedM/S5WoDqgV0KV5yrgbzatd8H3i4P8lKCKlqtTQc/FQ85vVCzDUvWGUG/WNFPjVnoBnexpBMLjDkPMw6VHmgQ7/j8g4Qs4F4Knh88gYpKI7phI/Y1GWUZk0diJZvJVy5L43/XMF2OB64gQ4vOiLj6wlbHdK1H2PdOJOO2b2AtPogqCwoS7g05pj17mneI89FBEsQOEqq64+dm1iZ5BwasL2MC6VYKmdqflRJS0fLJn9jyCiujyvZClgLtKPcW3WnzsS6kNbQ9YO+SSPoq8JEdZgare8LQcuUdIXI3hG49TsQOlnvkSiTgN5X2MHNKt/b1F97LZ2QhFBJlXwQZIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

page_ref_add_unless_zero() reads the refcount and then updates it with
a cmpxchg.  A lockless get, such as a page cache lookup or a PFN
scanner, can read a non-zero refcount from a page that is then freed
and reused as a hugetlb tail page.  If HVO remaps its struct page to
the shared tail page in between, the cmpxchg writes to read-only
vmemmap:

    CPU0 (lockless get)               CPU1
    c = atomic_read(&page->_refcount)
                                      page freed
                                      page allocated as a hugetlb tail
                                      HVO remaps the struct page RO
    try_cmpxchg(&page->_refcount, &c, c + 1)
      -> write fault on read-only vmemmap

The refcount is zero by then and the compare fails, but a
compare-and-swap instruction needs write access whether or not it
succeeds.  The kernel oopses when hugetlb pages are allocated at
runtime with HVO enabled while a lockless get races with it.

Commit bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN
walkers") closed the window with RCU on both sides.  The RCU was removed
together with fake heads, on the wrong belief that it was only needed
for them.

Map the shared tail page writable instead of restoring the RCU.  Every
struct page on it is a tail with a zero refcount, so a late cmpxchg
fails and leaves the page unchanged.  RCU would put rcu_read_lock()
back around every get and synchronize_rcu() back into hugetlb
allocation and freeing.

The cost is the protection against stray writes to tail struct pages.
The shared page is shared by all hugetlb folios of the same order in
the zone, so such a write now corrupts all of them instead of oopsing.

Bootmem folios optimized when the memmap is set up keep their tails
read-only.  Nothing does a lockless get on them before hugetlb takes
them over.

Fixes: 32c440d67e6c ("mm: drop fake head checks")
Fixes: 01b1d0ffb6f7 ("hugetlb: remove VMEMMAP_SYNCHRONIZE_RCU")
Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Closes: https://lore.kernel.org/r/ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
Changes since the draft posted inline in the report thread [1]:
 - keep the pre-HVO write-protect for bootmem folios (Muchun);
 - describe the fault in arch-agnostic terms (Muchun).

[1] https://lore.kernel.org/r/auDkbDlgSZxqlk2G@thinkstation

 Documentation/mm/vmemmap_dedup.rst | 15 +++++++++++++--
 mm/hugetlb_vmemmap.c               |  8 +++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 9fa8642ded48..66d58fbea5b1 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -131,8 +131,19 @@ pages of ``struct page`` (page 1 to page 7) are tail pages.
 The optimization is only applied when the size of the struct page is a power
 of 2. In this case, all tail pages of the same order are identical. See
 compound_head(). This allows us to remap the tail pages of the vmemmap to a
-shared, read-only page. The head page is also remapped to a new page. This
-allows the original vmemmap pages to be freed.
+shared page. The head page is also remapped to a new page. This allows the
+original vmemmap pages to be freed.
+
+The shared page is mapped writable. A lockless get of a page reference can
+read a non-zero refcount before the remap and attempt its atomic update
+after it. The refcount of a tail page is zero, so the update fails without
+changing the page. Nothing else may write to the shared page: it is shared
+by all HugeTLB pages of the same size in the zone, and a stray write would
+corrupt all of them.
+
+HugeTLB pages whose vmemmap is optimized when the memmap is first set up at
+boot keep a read-only mapping of the shared page. Nothing can do a lockless
+get on them before they are handed to HugeTLB.
 
 Here is how things look after remapping::
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 917db0984143..8e5981888937 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -222,10 +222,12 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
 
 		/*
-		 * Remap the tail pages as read-only to catch illegal write
-		 * operation to the tail pages.
+		 * Map the shared tail page writable. A lockless get that read
+		 * a non-zero refcount before the remap can still do its
+		 * cmpxchg after it. The refcount is zero, so the cmpxchg
+		 * fails and leaves the page unchanged.
 		 */
-		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
+		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL);
 	}
 
 	list_add(&page->lru, walk->vmemmap_pages);

base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
2.54.0


