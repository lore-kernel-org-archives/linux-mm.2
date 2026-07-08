Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F965C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 09:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3416B00A3; Wed,  8 Jul 2026 05:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293266B00A6; Wed,  8 Jul 2026 05:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182026B00A7; Wed,  8 Jul 2026 05:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1B8C6B00A3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:01:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68F001C81AA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:01:15 +0000 (UTC)
X-FDA: 84965015310.16.8148C98
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7534C2000E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:01:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=eKrKQxMC;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=YoL2U77N;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783501273;
	b=pSkJOwMarAPXUVII6m/QTPM8eE0E7wfw6Mms0kvsngMck8khKatAZ1YrH0MBGYkY0pJAY6
	L3YqfsvSn036M2KkgcOloNZXBmtxAkha7ywI/RuinjpddO1ilIPY53LaEKOkjq7XVS2Do/
	GMHYPw0rBLDKHqbVD/Z21XIKi9crYIk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=eKrKQxMC;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=YoL2U77N;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783501273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3EvSgYePAJnK+4qlwHYKXhCIUGXCFLK3nzDr6fryuDE=;
	b=IDAuEc9lJjbFfFk1QK7xHkoTfT9XzWjTXeCD8o0vNXky//+ywbpzJesdgRWO2XyLaqNCh4
	mRaH8B+hsqqch6g1OC7KTVjVA1FVa3kGWMMPKoGhomcQDYCnb71m247gc5ftlAqPu3P7pc
	Xb00QY8C/PNZ4C2rlUl8WanlxIA6/UQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 6CE7E1D0016E;
	Wed,  8 Jul 2026 05:01:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 08 Jul 2026 05:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1783501272; x=1783587672; bh=3EvSgYePAJ
	nK+4qlwHYKXhCIUGXCFLK3nzDr6fryuDE=; b=eKrKQxMCPWq8Jl95v/321bYSwA
	4HTvxYiDq5lnoHlR/jGkmmZ8cuSCXfTSOdRtjETPRrSDASIDfTVU7kIcF5WCkyAj
	uV3+NSEiXsVtBSNZey9EbfFl4x432UkP1cKWV0WGoANO+WBCEfgpV5ow7hn1bzH+
	+XpgcAHcKaHE20UmEZDrlLxieJRNCqqfj7re3SYYNPI3rDNPzRh3uJz43zK/fBzY
	WqFYxBijP+yPsylw41jE5nG4gbW6igPdGWhAx1+r8nfdjDmW8+la453AMV9MF3uF
	PVC9mcWsEBIGlvl5kx/ZHeP0JJHhhax09vJp8wD6prD6Sp3DrWpuafoy0XrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783501272; x=1783587672; bh=3EvSgYePAJnK+4qlwHYKXhCIUGXCFLK3nzD
	r6fryuDE=; b=YoL2U77NQpgUHAfBKjSmwkNghLl0bQgv3T9xKeklzlFG9GvGoJG
	8ZKchXzooom+CWFxFW32qnrqol1cIBe5efbk82GMlp34JavoaMq6EFyYBP6qUxh3
	SJfwSOGFSHlV7RkfPUkxh2WSIgWc4RC2d7eThIlcrsD8D+C3VV16f3GknnwXOm5z
	8kvTfAAiKWcnfkzQmgGZ+ULdzYYwULMz6fZD202ePnzlqj8v4fu2c6jMocG6JxJA
	ImtAGREHeZ6khylKWYi3JgvvTUg4xx/MSxUw6FDMj0jsMJriw24z+oL609VV25xT
	4dn1t6c6TG+MTVljikzxxBiK7UNKziUBQ3Q==
X-ME-Sender: <xms:1xFOal35iYtvPjarH-OjcEezHaQoV7a21Uuuc7-cc2copfeJ209YEQ>
    <xme:1xFOavK7-RcUAhr6p_m_ZFlBg852mxz9oFeO6uHluG555Od-JPLn1IYahcnZS44wm
    qfqbRLQ8g5a3YE1xnyR7IMlVKOJh7q8kSrlEEyVw5Bz75HitTyqkwA>
X-ME-Received: <xmr:1xFOaghKZg_ya0wAroDEjqdeazzMckpe75BjZpHzRh3vQ5nRskTpA8OEzTJ0Nw>
X-ME-Proxy-Cause: dmFkZTFC0PHmAvXUdlZfYzz6cW71H2m7i9+krYVZQo388FxfEPciPyUfJ6xbOuVTbqrZt6
    unpquqm4bgD31w7QYeNnsOp2ZNFClpIvVbxp9QErPwFGa7zl1ciPYqQkt5nXltGb7RHRVs
    Hjah+0Z8QDDzeMIF8cYW6HVb10krpmI/KKw/dgaOKn5iC9zXv4BG8Uz3IZIb35Hw/od0nO
    aIyVPjOZ+OmvNKTENB11ZmWMC5kzjR1HfzoOeSv/HR8Si0rOpUgOHdXqn4q/a5s4iLCEIo
    IZwSc/fczKDniwH2HnxcdBRf/GRQNi138GRgd5JXWn+XpgmOqcCsI1Hx9lRD6iCrLM81Zi
    7F8xGRyRA5E6IaakjbAeAWrZRQOOF+qR6LkNMD02FDRbipPe0Wlzk4llZLUonBaT39Keva
    TloSo0sQQsIuVvYhRXnbEdca+Nqt6sXw20N2m4AjZQanMC3lOKoLwhOuz5bb4hWU/VHZ8o
    XfP8OnINse2+MggziHGxiLTafZabMvEAMkYBpz5FB/DXGHwSa/nChyqJGZM4EmiIddyLz6
    P4ez3IRoMctdIjMJaAbcSd294NaGGrV2EkjuXAp3gfCU14s/wvkQu54JTMukIkGkZcUIQA
    qpfA8GfMz+T7MDQ84u0e6JyULhoYOI5R8e0peMRe+sWIBh41I/UkrjUp16cQ
X-ME-Proxy: <xmx:1xFOavAsc33qBqZa3hn6u1knk32LbUPGTWK1ADqPGEpBLgSNMQkO-A>
    <xmx:1xFOai4ragVMXbm7m1tPWm8R2BIQdOZTTRgJ79YYhocHaC90khxWTQ>
    <xmx:1xFOakHH2SUnvZZKaLcWrzy--PfmpuYiSLgdhMhZvSkRVHjJz2ucew>
    <xmx:1xFOatD-JF5nHbkVeKbtWvGtm7aIVzpP5iaxM53rRQBTIsFigsJsNg>
    <xmx:2BFOavySkKoyMOWTS7YMdxd90RKbaGTuMSD2xflwgTJwOhzLYk5r0KLx>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 05:01:11 -0400 (EDT)
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
Subject: [PATCH v2] mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()
Date: Wed,  8 Jul 2026 10:01:10 +0100
Message-ID: <20260708090110.136162-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7534C2000E
X-Rspam-User: 
X-Stat-Signature: d7p3wotkrg6gpoaouxa8kzex7z3bnae9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783501273-410375
X-HE-Meta: U2FsdGVkX18Sa7iZg6Ylob8NZSciws3cobS3aAAQxlpVm5DRrJE48Q2Elq2E0msJZN6VVegXIW9VEacJ/CT+cQiEOyVDZvSiqkx9cxEXJAWc8TtH8hh7WmMz45IvDm0hW4LBOF1bKF3HluV+ZssusPugZffLf2ABt47kugK2MinPtDS0s0XxxiZuTC+G1p5pdSDAnj+xy7JEpq7BVWMpaTtHZVjJZHfclAk0lX01X7WDMXrj5DuN0fsz7pAdG2lANTLmUCVsjXSRupxh9wVPpGDSYlwjXqxtVzkx3BDoxHJy663H9yrhemS76Pye25eLdwTDYjSkzX5rwc3nEVoUhW5w8CXVFAl7fj8E0jTGOVNREWa2swjAu/9OXN0OUuli4cjeiEeGou8AVIlTNkHAHZgZBAo+LDPD7DkbAZF6qN93lRETsmR21LJ0Yj5Gd+brMGYUcYgUg7d4+KsSvwKQn0JJPtUT1SWZDXzlNESEFnQd9dLb2HEFWUKi4ZmUS0zeE+L8kZdtn22U2t7KpHPpHlbZ52klOhAyQLJevmT1Xsp13D1L2Z3UgVrcs/RYpaNsI/1R80PLh4cTgz+a/3mjaT4x+ki3kKliTI7Uiokgc5ye4C3hwbxWDAeeB0WTx3W3hN3oq/M9+zjHikxRR5+XI8vyaGtkWZOMeLc7DaQtHoTXk4AxdpJ7uIBtI9Tdq9nLg2EYtEe1vq5Y8ZMgThS+++96Vd50cPfpxCjemBph6b4YSMNZ/Sl3GMBrlZ4l92+qaCCZeaUxXhxeQ0d7n+Ymj53m/0kUm72VE9p+vDx7Jdpfr4PTHJlfCRT5HEvSLsZvhvYaW1iWXPGdt5UUHgZXLgK7JdiXqTWAXVtEKscbB2x4VXkDjnm2dHqJTJ37wOUvJWQlA5QRJTvlKGHuIAcKfM6i1azS9LWZrKqqtzpz24VoSFCRrP2Ry9z5q5ra+5cHpr+4QvJG+98B//a/rFa
 rPD+cjeL
 aWF/gGz0XiQIL+w8Dw7sypPgMHtWRsRgvCBFeRCwRj/eBDYHw8Dv7iUxqRzQ1m5TifVqDUIZWGAEaF8/fWna3W31AvwagerprDT2sGppbcUlw7+4zJSgbL5SMQ3tB+fExTGpOK0eOIexZaI8earKnakRhKb1mW4/XgFzRtOSLnWbyX0wf89j7r9TecqWFOP8T0jMGrgMibh/jrOf4nSUpaz8DIxn8GrqNXG/eN68iaKlZNa5+u6Py5e1seq4NF4yB2X8777cGdoYUmv9ywFme1BsdpV2+FZrid1tgVV20uI/lmwRxRGW7hs2M+xs1QNPoV0Siobq+mCsXST7KPd3SCtV1afxutC7TNRdSaETViRxHxgOQwY5b4SSQfw9aPrOJhT2nb+73wfCxJTdSXRd5CdWS2lVBmwsQLLZ8PAVC/7+FKHduEh+YrbU/KeX5S7Fsnw/+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

copy_hugetlb_page_range() clears the uffd-wp bit of migration and
hwpoison entries with huge_pte_clear_uffd_wp(), which operates on the
present-PTE bit position. Swap entries keep the uffd-wp state elsewhere
-- the migration branch reads and sets it with pte_swp_uffd_wp() and
pte_swp_mkuffd_wp() -- and the present-PTE position falls into the swap
payload. On x86-64 it lands in the inverted swap offset, where a
naturally-aligned hugetlb PFN always has the affected bit set, so the
clear advances the encoded PFN by two pages.

No userfaultfd needs to be involved: the clear is guarded only by the
child VMA not being uffd-wp registered, so a plain fork() with an
in-flight hugetlb migration entry (or a poisoned hugetlb page) corrupts
the entry copied into the child. Instrumenting the clear and forking
after MADV_HWPOISON on a 2MB anon hugetlb page shows:

  offset before=120e00
  offset after =120e02

The fallout is mostly latent: rmap walks match migration entries by
folio range and remove_migration_pte() rebuilds the PTE from the folio,
so a within-folio PFN skew heals once migration completes. But any path
that re-encodes the corrupted offset -- e.g. hugetlb_change_protection()
rewriting a writable migration entry via
make_readable_migration_entry(swp_offset(entry)) -- propagates it.

Migration entries legitimately carry uffd-wp, so clear it with
pte_swp_clear_uffd_wp(), matching copy_nonpresent_pte() and
move_huge_pte().

A hwpoison entry, on the other hand, never carries the uffd-wp bit: it
is installed fresh by make_hwpoison_entry() (try_to_unmap_one() does not
preserve uffd-wp on the hwpoison path) and hugetlb_change_protection()
leaves hwpoison entries untouched. There was nothing to clear there,
only the corruption, so drop the clear entirely.

Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260703140011.99E601F000E9@smtp.kernel.org/
Suggested-by: David Hildenbrand <david@kernel.org>
Fixes: bc70fbf269fd ("mm/hugetlb: handle uffd-wp during fork()")
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-fable-5
---

Changes since v1 [1]:
  - Drop the clear on the hwpoison branch entirely rather than
    switching it to pte_swp_clear_uffd_wp(): a hugetlb hwpoison entry
    never carries the uffd-wp bit, so there is nothing to clear.
    (David Hildenbrand)

[1] https://lore.kernel.org/all/20260703161833.57416-1-kirill@shutemov.name/
 mm/hugetlb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..bca2707d02e3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4917,8 +4917,12 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 
 		softleaf = softleaf_from_pte(entry);
 		if (unlikely(softleaf_is_hwpoison(softleaf))) {
-			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd_wp(entry);
+			/*
+			 * A hwpoison entry never carries the uffd-wp bit: it is
+			 * installed fresh by make_hwpoison_entry() and
+			 * hugetlb_change_protection() leaves it untouched, so
+			 * there is nothing to clear for the child.
+			 */
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(softleaf_is_migration(softleaf))) {
 			bool uffd_wp = pte_swp_uffd_wp(entry);
@@ -4936,7 +4940,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
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


