Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 451A8CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA07B6B00C0; Fri, 29 May 2026 13:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50F96B00C2; Fri, 29 May 2026 13:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966E46B00C4; Fri, 29 May 2026 13:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 833546B00C0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:24:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48D058634C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:24:00 +0000 (UTC)
X-FDA: 84821130240.23.A03D0BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 54854100009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:23:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWeRzBIZ;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aQovhm+rAVLhPNqkReF29glHPCC8PiSoid5QftmxW8=;
	b=BrNzf7lPJVGlzi9oq4/SjdaqWeKzEnCpvXEP9IyLadDtxuZuEl+UdMJTKS2ATLRYxlLvlp
	kw1mGqk8MUhr6wuWhYmDBxKW9UPGKt+Eii+utv4pKoeokfmn0vkOBKdeHPqUC6iAhcfd8u
	gkdWa/vZXDWF2NyoaSoldiWc1EJq9Qk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075438; a=rsa-sha256;
	cv=none;
	b=t8lHRNr5ribv/X9NBW4M/0/x5che5M/8I6T8vJKbOH+tVCKLmQN1QXvRFvH3OUi+D7NlSv
	Z46R/QO2BqD7tmVi9fJGwJIha2LAV6jkklWned4TQK5VeEwNWMpg3i/CRrlwK3pwnTBzGV
	nXHL5oVEP5zqoFWJbzugT/gx6UO6qgI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWeRzBIZ;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0730605D9;
	Fri, 29 May 2026 17:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B34F1F00898;
	Fri, 29 May 2026 17:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075437;
	bh=9aQovhm+rAVLhPNqkReF29glHPCC8PiSoid5QftmxW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWeRzBIZzSr4LzJXWgtJgNAGF/7YupqxAqkBmWbnMkzVMV3dSy7GDJ8YriLuOoeG4
	 67szeU0c8RcYEEvSwIc4nJdUpCYgnqWqxI6+d6a2+lQmg//LXZX7a5fb3W8zExUmFF
	 oDrGqIsm66TRKqAaY2WyvN/vYRv76JaGMjlb+s2z3adiwXQlnktUPdc05Cq1YdBCGo
	 EIhjmFiVeiTf8+xrslPvU7NOKxAHbVWUdHUaakqhZfEAeEbJNoMXSdfRyL2ce4Lscq
	 tUyxwgKhvUIrVZH4CVXuPg6Zuy+NWZCSrfLeGtwELpchHKUOB0OJyyojVeyGnUPSxa
	 +FLLxXOkGr97A==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8DF7DF4006D;
	Fri, 29 May 2026 13:23:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 29 May 2026 13:23:56 -0400
X-ME-Sender: <xms:rMsZaq7nsYd1CmD3e8coP_1a-5ve-IU5vN6k58vGFX6pYuyWCzBHFA>
    <xme:rMsZasqUdrKpxoB1b6wdHOuZtJxkllRyewuySjWnxBOO75-L_dWjHsF5Hs-OnkrcR
    4wmbGC1f8mXaGkHf65ClFqGDsFz3jwtaw8am1ZWV0SlA_OLh9ODP8E>
X-ME-Received: <xmr:rMsZaoL1ASf72hiiSY2sUztr2NKeQpY3lvNWDuE7N7EnQYFUnQ118reAu08xHA>
X-ME-Proxy-Cause: dmFkZTEZfpMr5/eRRE28w8SXJrP2dhbWJDto6huRdd/cnfVbAAhK4j6L5mXvQtvbZW1Tgn
    qdHjS1xVDGkdt7hr1SYRochmR7yuP2KsuqbhH6HkebbwRdIZkVYqIRv2TfGI9SaQtUiic8
    G8SBlRV6/L2Xtb05bm6QmOQTKoj3b/RGprk0F6woL4YfqntUvh+0D5sL6ruauatQhdAfx4
    sxg873kOfAaKAVmot+PkxhAMe2YWyy/aSlFAam2C/bHdTY9DLsPBVhceLLRJtCvIR2Q+zM
    kaoJA5O2aRPotfcyz8zPVtzBiOjMLe5Pw3NzV/bo4OKaUt+lobJ5eojHQXZMuqCslD6ATr
    oxy1zzjt2em+zJsRq8POPUsy4CV7PoZHrsAai4kRVafuktEUWzwlzoahhiUOPOMqVMULxU
    OoqIdoLTAo5WAAqArSXoEXRD/SkEHUTjv/Yu5n5CM1khoLP/Zj8mVWMYbGav2f4ELOap51
    nyHTSXHFliTGg10ueqLZO/lhBP77GXxnum5X6OeJxQqeRKO2shHkz87JQ/rk7Rn5rKHBRa
    JzC28BFu5dhwdGTo/2Cd5xWskrDBHDkUH6cTFcJZCSe2jSZeG16EWNT/whd9WMvw6wbbQ8
    BPKfQrAB/lp/adhD0u/Nww3O04VYhY8zwOvVM5i4c504T4ICiektIhpy1pKQ
X-ME-Proxy: <xmx:rMsZapjrWtBnqMfUA6_o-KgFgwqjosrNJxnEOx8DBh42PyVuxplxHw>
    <xmx:rMsZah-fNwK9HhtSZ8yBZBqFfLdTUdxjuzzCUqtfEvNDtY9kG8p9Kg>
    <xmx:rMsZatpQL4F9lYtEqAi2jiV_3ob8HRTUW8H2Mk4rpnKY6OZcrQ78KQ>
    <xmx:rMsZamNSZy4t7I9jqvceOHnqaSbaEBjFcRl5sOHR7B6PNCjhyhe0uw>
    <xmx:rMsZar5jKnhjXEE7Q8iae3ep3jcUgzKRS7BNbuwxXpHqK_CfETLJT0Ju>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:23:55 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrei Vagin <avagin@gmail.com>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/6] fs/proc/task_mmu: use huge_page_size() in pagemap_scan_hugetlb_entry()
Date: Fri, 29 May 2026 18:23:26 +0100
Message-ID: <20260529172331.356655-3-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172331.356655-1-kas@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 54854100009
X-Stat-Signature: ert775oatbqtp43bftr48i6nukmr6rxu
X-Rspamd-Server: rspam06
X-HE-Tag: 1780075438-751116
X-HE-Meta: U2FsdGVkX1+nO8gOl4HML1vRpMRReFtBq/rjq6B6qTi4dEBdgbEvJw+bR+GDGz7/DgCPBnBmfEp93v/Ma1SzWRSX7AEToFbaWjqbBc2g9E3SJxCqBBYb3ULmeCCMrjjTXZQb8oFDPBORBefE9OU8BHLyf/depFw66Vg9DEXBrv7MXM18+DoBWYQVjStE/sDXL1eVKDRhPmAZW9R7XQgIXljZHYGiKm5pei6Xi/7Ju0qSjX+Q9/Yc2st3UpnFtnAYdKAfSeIrHQlWUAuyl9uBc4pulunbbvpvTCZxlGZdGAUUBMI3VxIlbEq17sXLb5AwPP/tkfd1dAy3W+tjRsLj+WG2dyOLKIJhy2HF21kkjAMu2IfYnlrPoX7erpxU4EgesrOvWAnZDz1uDrVqrKQPSNBPQqF7C3vvbEhc7ot2cZURj48Pl8wbyvdc3YuFmL2cyBU0G+/vFIboQk9E+ZBH1JtmkcYWOMFcrYtVqKVmWmdLngkZekYsLGm9HzqBAuSn33sifPgbER8lDsPHVzF9x3N8qRf0KMi7JKiT7mu+DW17GPkuuW+xdCFJ+UeLrcvPWiRWBmuADsc/bzdJVZltDWV3StocSJoPLyRy28UyVCIyFFv2iSeFIi6zkmhb8MakU4m8Z4C2mzWbHjloxac+vHdscrWiiiU4vgJl6XUHFXqIgLjBYxd4Rt4wfTzDlNwe3rrVW1eX36R10dCW63j18SfOpj+bRBzQDZiibtNF3Wb/w/xydPUFrG2sYe03av08UteHatQXNymE+ePzq/ap7Mc4QvaXfkix+Smu/PcqNIzh7srHKqF67K+opMXKHubJx9t+loajOHDeF5FzvePKto4IiwvN8nFd4jS8lwf6cV69Pww7LCNWBL8llHawrmJx63tj2lirSGs0qEfwmtM2yzLGmoN5oDjFm6dAyUn1+4pQmg8cfdkZnbEXmslT6L3VUEQcRm3f5tsIPuHdvAB
 FCn3fL3d
 lf5iTDCHGCXOUKNDvNi2Fy/yDbYLnDNIlLT8yjTqwDNE7jhoNKyk13bFakt8Z/R7FBrr7b/Ss2oTLd1FsxaoiQrErigF8yV1yJ/UdkUq9+xg1dZxJJRJHE1CRQNwddooqyZml0INu2/k2VC1B8zk/VlPIwEHJ3gSvsGen6ZNOgXJ2VgrOnmBHb6exTL/jpfCDOOWHguUnfAw03YW8TcH3K2afORJQxlwji3ZH0AwHy1NByqVSOU6ZbZZ6eMsYfDJIIr0qP40HMSH0Skg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The partial-page check compares against HPAGE_SIZE (PMD_SIZE), which
is wrong for gigantic hugetlb hstates (e.g. 1G). The walker hands the
callback a huge_page_size()-sized range, never start + HPAGE_SIZE, so
the comparison always declares it partial and aborts the WP. Compare
against the actual hstate's page size.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 fs/proc/task_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e21a38ac745b..1489c67e88f7 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2960,7 +2960,7 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
 	if (~categories & PAGE_IS_WRITTEN)
 		goto out_unlock;
 
-	if (end != start + HPAGE_SIZE) {
+	if (end != start + huge_page_size(hstate_vma(vma))) {
 		/* Partial HugeTLB page WP isn't possible. */
 		pagemap_scan_backout_range(p, start, end);
 		p->arg.walk_end = start;
-- 
2.54.0


