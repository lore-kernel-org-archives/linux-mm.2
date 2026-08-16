Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE49C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96C076B08A1; Sun, 16 Aug 2026 18:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944D06B08A3; Sun, 16 Aug 2026 18:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BA06B08A4; Sun, 16 Aug 2026 18:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6AF6B08A1
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B05E12010A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:40 +0000 (UTC)
X-FDA: 85108621080.04.919DE5C
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E6C280004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f u2iY+k";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QrkuiCXN;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsbtWGmnLS8gNA6v/OmuTl4g7B7VvEJrlwoMT5rjl2I=;
	b=W/ieXWguDeK96/Xw7WVScUXFMueJYAYyDoA2GNXj7yxK+/fYiXwCWw6wj1bcZFDP038LT1
	nA6RaCeqd0VKupgkKV3uIE+qmZqisgXSDAMoP+xQpBigvAKvQb5mNXaJGmAjUlk+M+x6r2
	5GYJNWTE6FJ3LUVgyqGNgY7965NrZOA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f u2iY+k";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QrkuiCXN;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920458;
	b=gWs0MfIyt2H6/LO448n28ftZ89qlNtrWMG3IuIOJW6KwW1I5KXK6POuU+2ET7PScnjCrtr
	SK5bYkq0ICsf3d3+gLcVrsNuKmAqJ7mXjCDetgFvn4MqC3yUdn/f36CwmLVN11w9MEYtLH
	JGgTBrwqTXC+vvKDOaueTXgr8PCFwe4=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 0A975EC0235;
	Sun, 16 Aug 2026 18:47:38 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920458; x=
	1787006858; bh=hsbtWGmnLS8gNA6v/OmuTl4g7B7VvEJrlwoMT5rjl2I=; b=f
	u2iY+kcbdqg8XZ7qkFdaWgez1i5hIWQAqWtxE4ir7o14H6QTMAJOsoArRisr8+zF
	XKgXHadiin9jdcqGoR2OnqoC40c2jyr/XvrAdX2LfRqrDWd3bLnUQTkcfD6EHDVj
	D4I7m+ZK9rL2kJWu66YtJqYb1oLcF25VQrF9+2dad/xkK71QaojHbSgoznDIOpBW
	cIkyw02O9OYt0r81b5abH4orCiBcMOCblMYhFVVN8xX2Akp1dVWilQFjS77rI1Mj
	66kS42c5eYiXYqmJvRekO+PxrO/rzkJDTG11PqQDWJIswNS0G21VmTRLAStxJZPL
	PykDV2ghQyRM18uwklarQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920458; x=1787006858; bh=h
	sbtWGmnLS8gNA6v/OmuTl4g7B7VvEJrlwoMT5rjl2I=; b=QrkuiCXNu9Ag8fKym
	7s3tQryl5qs35v3JLJkB8cW2oZM5UeI+B6Y11iiR9Zp5PloR6bNbcTcicmuTnw8J
	lVP4mCH2TikjEdOjGX1x5Zr5UhMkUfHXOFrFEDpSIO2EZveoX6nS27vjEq+Vy4Px
	k7DS7Zz/TeZ1h5JsO5TG/3bm5dQdq3v2CTlWHQ3BWl/Jg2ZnVWC+CN1FU3rFPxxq
	JWnzKxdhJWbGRXRwVewUho2MIIaXdEAY6t7E4nHBipdGWCl5uBesALz3spA3/8Bg
	vcB6C9sMvd9e7HA0J840icixCdVA0ZoFl6RbinUEjij2zfrZ4Q5cFgIMg4DZkdkC
	DasBg==
X-ME-Sender: <xms:CT6Carm9G-x2NVenuQt7DYfIn9f7yv9N_OwRV6eLcEMQXTDj_lsCcw>
    <xme:CT6CakIzQ5P8pH3sMYRDklrE0M-RYmTOCmPlnJGgVaAzoRHZCw99i8P_FGxQEND4o
    ogZMnlFnfA7UrOXqQotXvTe7H1VhTdJyYddYaR8sh9BLMA1ROtTXolU>
X-ME-Received: <xmr:CT6CatsWUO3qF_nAyhGWZBJf6gij0BNLc_sovt8HRRdHOxDqIu1pjHdapmM>
X-ME-Proxy-Cause: dmFkZTFxktHaoHQCGyR7uz2gXQdTgUX0nZzUatWYXQdVxBJb4A/qMuEZ/RMKYvGIBz31Rt
    TR5Nu17EPBqNyeZSjkVnK7sHElwU57b8x3/cyZ9PHHSfAaSWNWLOdeLuZVBbf5zubb18Bw
    fy/mf5jpQtxpZDPvMPXwjw+an+TW+7k/Tw/n4sb2tNNa7d9nLnQnX6Rw+vp6wioFQOuuev
    fpJbCZJSwa4xWiqXHUsCfuVr3o0xcsLHyTasHEYEkAGMtBoAwl7gOHcd9Yu3HcCvuVHzqL
    dMVburb2rGaTCsZcGe3UWITClIJ34iPVxiKzwGBtfazzXdWK1ezlWroYFXdEl+xlvbcPMN
    vZtr4rHndVJB562/WoDkew1Y03j21tKV2cnjL43Ck1uOBZ8NRyVlM3puHQQJb8vttWvbCT
    Vub/4J6dev06TTYjDujIcAGui6NrZT7E0xqFxmiu9BmjvwUAj0YhVXNi3R3McxnqEuozCs
    Cg+X7m9F7uqX2U6p6Xyjjpfd5s6+mLEaC2r7NYfvnpAv6qt2q0FyIdVJus0Zu4lfXxl41X
    Ho6g80JFqnXt8OaS01tjl26CBO9wiBFx/ns5VSZG0hA3WGnD4j3/8rFwsQ9O4oX5Shk/Hx
    K0jzuV1jZV8vH/x8VLuU4iFg4PHzM1/90qd2/8TgEM/6D9aaOPm8UyuE0hvA
X-ME-Proxy: <xmx:CT6CagJgE9kztDHM6-XPR-SR2o5kgXZiK-cTFL0qeJrQ0PJIGX2zWw>
    <xmx:CT6CagHuuhIwq4SvG_N8P-BS727mhFVkXru6E338dz6KBc-yOG_Zqw>
    <xmx:CT6CasRaWUKuFDiO-XbCdO5DsWgyRoJFmwJ9bmKQhsi2ya_TBfoZ9g>
    <xmx:CT6CaiUSEIlXqgUmW2LI0PYUkJLmULf_ujIyHBt6813C8Y_mqtirfw>
    <xmx:Cj6CatnmcMoHwRQv7955E4KTzPM8XXoCsZRMvv22Hw0hDLnz-yaR-8Db>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:37 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 43/57] mm/khugepaged: check the scan budget before the work, not after
Date: Sun, 16 Aug 2026 23:45:55 +0100
Message-ID: <20260816224609.308019-44-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ccxdh6ptmg5bhfm3511nnf9n599n6ura
X-Rspamd-Queue-Id: 7E6C280004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786920458-331258
X-HE-Meta: U2FsdGVkX1+Hf8nsJk4X4MjzC2sV6v6g514Ue4MXuBKH7BJcOamPDvboEJJ24fB44HA4nm7gNpK4Ks6vYomeqny0FLUS2Csik3BmkSKKZ5ONFtQwRqv4e+fXWJPxeBtdSS4wrImKRjNiBpGNqBwffSWlZo94hn8Gm0IhZs/5ZwfzANfTVIOHzxwcTaFf3R38I8EtolnD5UqIpFhoVUAgx19GiDe0z1CG5/kL6dYsTRPfO5ITonprUeDzgrr38z1afvbPbm9ZVQBe6NfjLcTsF+f0Bb1LQWCgY0rId4DDOU+Hb509Y2Gm71jgvdUiYFQWQem64kCmmR3za50ixMSzpzZe7PlhyUyZ+ESDtReAR8ytl3NpVqYjTnVXdwnMEke5V9a3OJSDV6W1SAhzks/hGyMZEJVvIZSAyBZBJTlISVTVAzdn+BQLAas05+3FtF6XgBsBnxbjuAiHsfzRUTgEps4uhNCSYiq8tgqMmHznoBqV0rE2Ro5h5sA5CfhCAQvr0u1G4aowtZ1K/VeDwYRDzym3tcRD9VXu89Gg0FFKO8rI6VEA/9TmdzksibIQ7f/D/jWQi2eYLuCpfhMpvuVPuS+4uniRjtCSzyHu7vNbXiCBltTjEvNN8S9AZnSstqyGlGLrcJTUGQnlpKtxLgxi31ITlVvJAffZRhCu89gsJoPuYMEUevrgcgXiKK2g9t/e9N0oHKrvUW2OI89agLs3fH7U3lXNk+B1EUwK7mKGXDTZ60QjKWvtl/2MMUxx2hGiI1oiEU02sCnVSOaHa6NSmOezJhplMjN0tOj6JM9J2lt5bsSeXpTQ18xCdrwyko4P/C1O6rATGbgflJpZesybkjCtutpktveXEBZMpqfWlOWHoEWU6Jsr1eKUlu3sYkTLL6+QsLpXWYnI+pFMYeThwWJHR5xXti5LkqCPMQheevBxQYNnGvivDgi6vZaqeEfC/Xo9yTGOHpwsFBI54Nq
 hjNoimGS
 HYJR7iUytxgNzCd0xSggIYiSyiAlokjyJZ6tBHvhT0AmClbBAaEQqpAvncRo0F/yzek/aSrDRjGK22puh0px26QOhc7FkO3G3Zbg8uxUkHPB2YulLCkLJj/RXlBnqDet4xJ5zotOZMo5AkrLrUL2EbQonlCzjAhLqnCRnq0x8wuTMgmFiRrop/ZxjBHGlAkkQFwYhzo2WXaskZF/Aw9jZa/2Khs/uRYvmHijUD11So/AdnkJwGpU2AzLg6/kM6yFYrBDYmNv54nCsON3UZaFMs7PEyuyLeet6+ghiw8L8ro6o4LdqC/byjBayV7m3W1svf1KlAxI5+9lNo7XbDGy9/Q09MsdG84sBnMT9qiEUaxRtmVOKgbft3chkJhGb8sJB20FvAdN0jr+fAmE27sjts9+oT36F4lV3mtDf0M0XwgkwRukD9fybMSNG1Z5AiuBr9MB8bTyIiBLPpJD8I3UqDQ8WnpoHzN0+LAHKg5d6uyu103Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

pages_to_scan is meant to bound what one khugepaged pass does, but
collapse_scan_mm_slot() tested it in only one place: after a table had
been scanned and turned out to hold nothing.

Neither of the other two ways of spending the budget reached that test.  A
VMA the pass skips is charged for and walked past without asking -- one no
order can be collapsed at, or one the cursor is already past the end of.
A table that does hold a candidate leaves through the collapse.

So a pass over an address space of thousands of VMAs khugepaged cannot use
walks every one of them, however low pages_to_scan is set.

Ask at the top of both loops instead, where the other reasons to stop a
pass are already asked.  The outer loop asks before it judges a VMA, the
inner one before it scans a table.

Stopping the outer loop only works if the cursor moves, and it did not for
a skipped VMA.  Advance khugepaged_scan.address past one, so a pass that
runs out of budget resumes after the VMAs it has already judged.  Without
that, an address space with more skippable VMAs than the budget would be
walked from the same place every pass and never scanned at all.

pages_to_scan now bounds a pass that finds nothing to collapse, where
before it did not.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f3a7aad5e8f2..cc5ff429d811 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -553,9 +553,19 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
+
+		/*
+		 * Before the VMA is judged, so that a pass over an address space
+		 * of VMAs it skips is bounded by the budget too: each one is
+		 * charged for, and none of them was being asked to be scanned.
+		 */
+		if (cc->progress >= progress_max)
+			break;
+
 		orders = collapse_possible_orders(vma, vma->vm_flags,
 						  TVA_KHUGEPAGED);
 		if (!orders) {
+			khugepaged_scan.address = vma->vm_end;
 			cc->progress++;
 			continue;
 		}
@@ -570,6 +580,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		hstart = ALIGN(vma->vm_start, window);
 		hend = ALIGN_DOWN(vma->vm_end, window);
 		if (khugepaged_scan.address > hend) {
+			khugepaged_scan.address = vma->vm_end;
 			cc->progress++;
 			continue;
 		}
@@ -584,7 +595,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			range_end = min(hend, pmd_addr + HPAGE_PMD_SIZE);
 
 			cond_resched();
-			if (unlikely(collapse_test_exit_or_disable(mm)))
+			if (unlikely(collapse_test_exit_or_disable(mm)) ||
+			    cc->progress >= progress_max)
 				goto breakouterloop;
 
 			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart);
@@ -596,8 +608,6 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			/* If nothing to collapse, the lock is still ours */
 			if (!collapse_scan_pmd(vma, start, range_end, cc, orders)) {
 				*result = cc->scan_refusal;
-				if (cc->progress >= progress_max)
-					goto breakouterloop;
 				continue;
 			}
 
-- 
2.54.0


