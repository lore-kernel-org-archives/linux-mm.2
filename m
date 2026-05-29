Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BEEBCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79536B00BE; Fri, 29 May 2026 13:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51066B00C0; Fri, 29 May 2026 13:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966F96B00C1; Fri, 29 May 2026 13:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8442A6B00BE
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:23:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 464B68C7A1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:23:54 +0000 (UTC)
X-FDA: 84821129988.01.AC4D02F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 256144000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:23:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0EN5Fp1;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIA7ICYvGFCKjBA05z3aKIhDosxqa3wRNXTiub6kjQ0=;
	b=7QK55hJryl4mmXYAYWrFKW0nlqtUqSzHELxdVeD2PUGLXN6e77gH5fc7R78X7lP45loOxU
	N5C91Aq8cU3kQ9iA1+iK7gCV0oo9AAIkvUC7S6fVDi8L2T6rU4viNSFz6XNYgt2mypw8pi
	Qi5Dv3BK3Tq2ajWVtcp4Tqo7HH8UNkc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0EN5Fp1;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075432; a=rsa-sha256;
	cv=none;
	b=lF8ClszjMMOJZg1SJIh3fTk9BgMobp6V69Y9VAFu4gpSDFcL8rU04xOf4DNzapVu15/xa3
	qvhKTgBYvep7FMxS6x2DWYZUIvHJNW/j1PcMdVLvvXrT+14qLnrdpZnm9I8LIz03X4h7ua
	TbI9JWwLi+h6u7/NUjPYzusxyge1mu0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E049C404AD;
	Fri, 29 May 2026 17:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350791F00893;
	Fri, 29 May 2026 17:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075430;
	bh=NIA7ICYvGFCKjBA05z3aKIhDosxqa3wRNXTiub6kjQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0EN5Fp1wgMMtKKVDrC6Hk80Fy4Ycw0Ru/G7OLjPkCluucgOffteXI04vIgtNpRNa
	 O4XSvqAj/V84SCyTcTtoFj9+r8RPRVSuhdPSoLHmeU36Xd6TILQRt8zA5AFOTNQvWI
	 W6FuS+Cly53kO7blhb+MSR6agxLIg40CqtxrP2t6NOhx16l7BzQDNQ8tSEcCsj/m01
	 sKdMCUcdQ4fPweWiBkMPqhcT+ZfrtKl5imLYRv0XkVUGkmuxmvyguACCAmINzK5vjM
	 Ro74tA7TYcm3jVJnekRpbm/5PTmPoffPROuivaFGwFiR2RY+J+kuiw+E7c5XG2ysZ3
	 VXeWl46mOXxJw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 91168F4006D;
	Fri, 29 May 2026 13:23:49 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 29 May 2026 13:23:49 -0400
X-ME-Sender: <xms:pcsZaiU-iIZSc6BLadX9lwODnMcMYhP6DRsbla5photh-XBZcYGARg>
    <xme:pcsZalK9mSX49H7RBv7m1btwCy7dhdO-woAGvZ_ujW8wcc2mu572kJl2x_rCqTWap
    bhTVARxwiVbemWyCC1_ZhTme7rrID5o6h7eP-WYDwEAaL4oxC49AwU>
X-ME-Received: <xmr:pcsZaoGlCNsPhs8QNWANe1lkb6XH8CEC_yy3UTTk-uLbkyBikoX5GTygxDqzIw>
X-ME-Proxy-Cause: dmFkZTEZfpMr5/eRRE28w8SXJrP2dhbWJDto6huRdd/cnfVbAAhK4j6L5mXvQtvbZW1Tgn
    qdHjS1xVDGkdt7hr1SYRochmR7yuP2KsuqbhH6HkebbwRdIZkVYqIRv2TfGI9SaQtUiic8
    G8SBlRV6/L2Xtb05bm6QmOQTKoj3b/RGprk0F6woL4YfqntUvh+0D5sL6ruauatQhdAfx4
    sxg873kOfAaKAVmot+PkxhAMe2YWyy/aSlFAam2C/bHdTY9DLsPBVhceLLRJtCvIR2Q+zM
    kaoJA5O2aRPotfcyz8zPVtzBiOjMLe5Pw3NzV/bo4OKaUt+lobJ5eojHQXZMuqCslD6AI+
    BM13zq6jVvyTjG84RmS69Gp7SlyBSnqMSsWkjT2xuM0NzyUJK9KfpZb9fp9Tb4IMDIwXk7
    CW9rEHFz3n7rqGfGkRLBuDVxWgAiEytI7zge31faM1twZ4SThN2MqD4Jq6x7NArlBmmcZ1
    1jmGcq+7qkHVGuGRgmeWzw2ya9tZ+i2vtU1PD2oGlxweR0ChEX5h0JNoIroqVDNTWlqbkW
    6Ov950KZCVmBG5Y+O/oz6+M8rCJ1tOtvD92ut1C6kj8aOcYhnOiEpacbmRsCZSAmmtOgCa
    pJ4i4UFvDKOfwsz6uUiLA9nxWUx2WzdSYxWfEtsXCpVkkYp6atlK6KqqwDPQ
X-ME-Proxy: <xmx:pcsZaiywOyoNUzBQVWDc7dlar2tGfgnphXcNaUpoFBcdyBGxURtkGw>
    <xmx:pcsZatjC91BYrbAz2VwYqoF0Sdqa2Ctedqud51Jd0B4kVGw2IbhTQQ>
    <xmx:pcsZanL6Chz9uBj8kLyC5UoLYfUpEnZ4FPPk-5LL6dxCdVYWi2c_aw>
    <xmx:pcsZagDmmAd3V5hD-KTyOhr0A2l6FYB68884jeE5kvfy6zsmCEyLLA>
    <xmx:pcsZaoQ2CtZ8nPGVwaRPzY36FcCxymJbsDkYZhCoWVBATOKLKc1Nvc1N>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:23:48 -0400 (EDT)
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
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/6] fs/proc/task_mmu: fix make_uffd_wp_huge_pte() prot-update race
Date: Fri, 29 May 2026 18:23:25 +0100
Message-ID: <20260529172331.356655-2-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172331.356655-1-kas@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 256144000E
X-Stat-Signature: duonstbeysdi6877d7uhm84kzqcrwska
X-HE-Tag: 1780075432-429152
X-HE-Meta: U2FsdGVkX1+EK/bus17aIsrCm09XLMPQm8V+AOsrmc0yx5bNS5IaK7ynHgCJZ1N8rMNFQZF9qsSUbIKFI5zr5rpBWZhEexnAhtT2mfWY8jMnlYjJ7pFIj2jdEi9nabylw3I3sh0tCo0WUsG3d4KuYG5z2IRa3Ha/VmWzeKkgmExytH8x8WBHy6bk1XHFm0thqNYLSO8QqbT0A7wJfZwTW212Yp7fL9tLglnPXWhAjPJU24oeWuzG8wh55qIDaOKT0UgRkhzoEUY4X2bJZuEdrJrBQG6lksRGoB5sZ2aDDEvk9qegOKMRqLhPAAS2Y9xaFudS6q2kaZqBEJkZimlyy1vPjcxpkAmQ2jxLXTLUl3SUHoNVj3OZHTtajcR/O5IbwueYAXThia9Kc8ORUGV0M22XBRR7h8RUzWSZJPbFhIU+011L+vNFu20Ps/eSqeo7H3zakjZCY+/pzVgkerFdUYeLTwsmyRjZsBS18rGU7TeC6UQI8H4N10E1IMn8NpG29/2dGqUKvpstY35v3iHYnhiHiIgKufCFFF/NX7VYpzYXHVBGJFcVfFOvdzIVAZ8mk9MFtUD9Hib4DVJyPN5DBgz1tc7xOzf2orwFasAHoGfWyRNZNTACyC2fYFR/cRtFBMDdOxE1NiuCV7Lxrs0GbSniCgvwl6lrCofjc4nfeKZSb9mbsC8XKiMTnsGkIZOUi9evKCMaCb4mVP2xBgYekUSeZLkDqbSTzK5CWHrTazJJNzmxuATwp50HDsANta+YGlDngtgSwn+v6HRx323FvxqkeYlrW/CuzCsM8dXW7PogFZfBxBYJ/BSBofd9i9QJlSTdG+auB2k5ePTC8zmngGtIpIX+F6Oi8zd8sALDtSGyAjAV5MuTjq7QTB/fulu6qpOn5UGPXEbHyW9K3l+HQQ+uMG9xW4oxLo9ERQC/wvyDfx/BDZK7xzRqXvWYPUTIcnzWnhd+farjWMSPI80
 8EX8/J5y
 lI5w7WNh3sLIEBIoOoT54Whi6zQQ1rWp8+0kACjFrFzJfPMbwP8zNXxilz5BExwvKc/lzdOeQeUX0h/Yq8pYhKbXTThyo8FqJM1kyFWwAyupl+n6a6v/k2sVcuNAwXc7lVaAxmsaiBr7oAKzlwgNrF/8oIVNrbF92At6bvl9ujMXFNqqaVULpj/4Ea1F94Pq/w7xUBoUo3iu0JdJ5XJR3jQp9wRAVU7tLi33+F6RHP91D17ESaGQPV6cObIwXrtBNONzunbMO3dbTolFbTkfQSvJhMCsYa3T7stGEfpN1MZz8JPTXqJCRULeB8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

make_uffd_wp_huge_pte() arms the UFFD_WP bit on a present HugeTLB PTE by
calling huge_ptep_modify_prot_commit() with a ptent snapshot that was
fetched without the corresponding huge_ptep_modify_prot_start(). The
start helper is what atomically clears the entry so the kernel-owned
snapshot stays consistent until the commit; without it, the hardware
may set Dirty or Accessed in the live PTE between the original read
and the commit, and huge_ptep_modify_prot_commit() (whose generic
implementation just calls set_huge_pte_at()) then writes the stale
snapshot back over the live hardware bits, losing the update.

The non-hugetlb sibling make_uffd_wp_pte() does this correctly via
ptep_modify_prot_start() / ptep_modify_prot_commit(). Mirror that
pattern for the present-PTE branch. The migration case stays as-is --
migration entries are non-present, so there's no hardware update to
race against.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 fs/proc/task_mmu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1e3a15bf46f4..e21a38ac745b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2610,12 +2610,16 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
 	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
 		return;
 
-	if (softleaf_is_migration(entry))
+	if (softleaf_is_migration(entry)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				pte_swp_mkuffd_wp(ptent), psize);
-	else
-		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
-					     huge_pte_mkuffd_wp(ptent));
+	} else {
+		pte_t old_pte, new_pte;
+
+		old_pte = huge_ptep_modify_prot_start(vma, addr, ptep);
+		new_pte = huge_pte_mkuffd_wp(old_pte);
+		huge_ptep_modify_prot_commit(vma, addr, ptep, old_pte, new_pte);
+	}
 }
 #endif /* CONFIG_HUGETLB_PAGE */
 
-- 
2.54.0


