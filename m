Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0140C79F87
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C7F76B0092; Fri,  4 Sep 2026 11:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5780D6B0095; Fri,  4 Sep 2026 11:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440226B0096; Fri,  4 Sep 2026 11:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0E66B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9673FC0117
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:34 +0000 (UTC)
X-FDA: 85176416388.26.0724F17
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9C02940008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Q uXF294";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="S/TZ0Oq8";
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3vy3fSlXRoSP/bUwTQaq1sU+R07aCpj0vZUm+2kQF8=;
	b=UrZU3MdJ7N25oJnjhgkbSqaewujehQ1OoqykH+KBJYmc5U5o9+Wzrfeyl+X7mqf01Q2Lkj
	qUTrY7jXXxabjs1eD3IsM+VgTUg1XwyHxsCGzJ8uLmbWEGyoTnN0TVpi8sHv/x/TLmIyIk
	Mcv3zRfRTrBTyS6PCts58ZA8exQZe4A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Q uXF294";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="S/TZ0Oq8";
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534632;
	b=Yq9rx+KLi+LKp7txtpEIVii3IoCZ3wXMd5nmtxEQnibxO5HjiccdeyvZpLsukKUaet0Opx
	utZcfUqzmxEdrMQJ12/cs7sUzRkYeJmoVo80xNdhy7ijYG42DTQBkcaMHVZHrwnIzZr6Vr
	sqtmhQFyYkPIREFmyetct5jX08hcUKc=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 18492EC00D1;
	Fri,  4 Sep 2026 11:10:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 04 Sep 2026 11:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788534632; x=
	1788621032; bh=C3vy3fSlXRoSP/bUwTQaq1sU+R07aCpj0vZUm+2kQF8=; b=Q
	uXF294AYI6HgdOVTi+0SXzP7FxYI8kwK/qKnYVmzqF9onqaZLKP2h+w6iVfYEjxg
	mj0Iv36T4NH/woorV3EvLIPRp0+tqL8CxizFiVr0ed+8SCmtn285eowLuS7mennZ
	avl+UMO4wS16rxUGxkDQZYaRq8fwsPhEG8OChARpkKrNNiDIi16+qQc3tAhyp2c1
	F64eqtA2S99GsbmCNGJEAyf9/GJHvJQt6FF/OUw2pf22UHjhmCkB9JCShidDNiPc
	mQQodiW9mO+zXuH+uyEsZlI4YKxL/rLCz+Jasi7wgO1q30L73C4SnB9Z07ddJvuc
	kpzJdLW5hIbgb+helDTLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788534632; x=1788621032; bh=C
	3vy3fSlXRoSP/bUwTQaq1sU+R07aCpj0vZUm+2kQF8=; b=S/TZ0Oq8tXHI29LV9
	KmdOux2c6cOZTioUS397dqp7YOKaO65dtIPmGmW6F7lI6QBOJNOwo4VlP7tq0QwX
	YRMrjTh1UrPR5s6UrTPU4lySmK8yFPKqaWWEzgxNlNt5MWZy4CoKyEnX8J+m/Hig
	ZptmSG6AX0M1QPGJXKZw1evw8lzDKy7CnjqVTT6n2IIRx/Dgq5G76Wkqs7JFeISb
	YF52Go48ysGkK7grkANFBWiiVbDFDhXida0buGv+4YCDT+spxf9kuCj61tsSl2VM
	hb9al5mtCML5QJSXAZ1TZsaeqTxRbCJjzT+JhMhOPhdXS+SQUTrSxx7L8PbzTTVk
	/hPJQ==
X-ME-Sender: <xms:Z9-aaqikfFbDQwG2M6DMdqg2B63AOZp_wdHSrXCYR-W7gSqLx5804Q>
    <xme:Z9-aam_KJZNIHq8eQ50DRYtHI0jEempFq5l-SwibfPSJv25jQJOyEVLBV04KIOHSI
    JaGjTNvmUw5E6FMD7i3uepsklECs1PPYs36pk5K0hItAPPpHM3ijErWGw>
X-ME-Received: <xmr:Z9-aaoOHLD7eyKJw2ixd9YMRNdR1zMcShV3fawTndvQsJGLAklfYJZCpd5s>
X-ME-Proxy-Cause: dmFkZTFdOocfRN4jOpcQf0AqfSai/YCGo+xlO94MLvzn7lqitof50EENUNEgJzLPt2H+RQ
    DWgrwJL5dg2BaLkWQfjz0w8mX09EzID7A24sM1R0CcrzJ0aCsxP+pgO1accdG5RnvXKoNP
    Qi2+ranCgsFBQlrx3RUM64Xgm9l9zr2TPWbzFNtan3mUwkVlJ/gBEGXolzLuuMZ3CJ6e8L
    gmzum6oDDF3av5ecJE/wINba64+XlYa/U9oL8c0Dkr16eu3wp8w8wOsHTRTsCgO4oV0meO
    0fb7rtZliPO8XPlA3k/rGcTv+01JWMnSe6fG3OACTE4UctUjoP9cM2YnBbUckeF0hhckij
    NOPFSUiZtbWGWwIaoa72i4eX2MNwTMmQMx1JJKB0oGx212Jn/3PmqqYSFnTW53IcV3p0vH
    NELpSMfP2Z6zjqkZ/tEiPBrUvz4BT4nMxYpIRTGKvlH2jencFZjJb++8kiwDeJqEUfh9Yl
    EQE2A7nt8xhteP9AZZOdyf4kp9m6aRLFjbBdIdcb2ZBxL7yuIn2fG7q6mssAIMYyV5HiSJ
    k/3VzUcClTcA/1nmaBr2Uwzq82jgLagZaIDFssmgoDl8IGnQ+pwmdJPCLoCpoUmy9OBDpM
    8u0pkgSoDulr8fg8y6EFVhqgeMChQB4PJLZO2pmG8gfRsiQnGFn/nhHensIg
X-ME-Proxy: <xmx:Z9-aapo9HyRIt7fN9Sr0pbcL2znDgHp3vdnrXCnWXrwUImMo7z8AHA>
    <xmx:Z9-aal5JXdVMugAItbVcciHAZ_DFz_DQP7ritmiLwFKeXQYFDL_3aw>
    <xmx:Z9-aarpMc2x07vzSoHlA6uKFMJ2tGL1yiBiyTLAEmjRPt1tFF0zQdw>
    <xmx:Z9-aarLmHRYc1BXMcBYAV2chcrIn_xeOo4pYHoYiXl-q7S9zrGPdXQ>
    <xmx:aN-aatm7hVSX3M86MfEmnHisHdkZ5Dnfg-ou2_e389edxB0UNEvrefU7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:31 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 01/12] mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
Date: Fri,  4 Sep 2026 16:10:15 +0100
Message-ID: <1ff754df1d57154e01356f35d72b1cb06c0f8664.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wfhoh5shxfdw1a838rgjs5muw4qiaua9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C02940008
X-Rspam-User: 
X-HE-Tag: 1788534632-10415
X-HE-Meta: U2FsdGVkX19LuU0hLBlPaw+nZVIzUgTQWjdlzEy2Hl3siZQ/ngva9rEHS75N4UlRybvVvuJuN+y3dsEHgTKRSzq0ZWgalSRZdoIHW+Iet/PAOL05hml9FymLHQdMHePL5GXs6hQQ98mjMLSds0gfeMw3sLhGOjNakuvmFopp11/YAZBgbw80a2wBF+yJ6Vj0ht+rODiykM+C6PlR0YnBeXp/p0srENq3eAlrhLNdAx/Mn3MwZ3h0lWUT3pnSf8LPqwyfp6D5h5nPBR/QZANaEuMsjU56CmtUFmJhSWB+VnyBRojCB6u83AW3PmI68r5c7ge9+Ct6Eb5fQhOzHiVpCgbrUS5OxYSv+P8zoYnjd71RRx86yhUq/RlIw6JklDGA4oitxPPntAMJm4llbCLtNQKBogtqedJJs8CwI6Fb0bw7qhsn9Y0OnhwgcQHVvU8EYZoNTzBcrQ2fZMm+X69cU6pDKQ0ij0znqJnILpDX01RmtkP0LXw2qyLLnkWYXFoOru37YIrELk/AaUQzc5LaSlsk9aRHA9AESOjyjw6joFBPqMu3b987FQJB1MM5XMjz+JNMSoVC+rNbcEPO1Jk4LXHBX3PoQRxTssGgLGIBXmvP/SoWfnzsegab4h93VIXFcG83O72H84WXhnUGrwfUhD1tW4B/n89HaSf1T/HvDQI6SjhJSfI60zkxP64RcVzPulYPsxZzBopFmkeq2fxO22x7tL8wpCAism6RObKM9PS36CqSWylq8S0PJPHvLWBqxgQ2tBVT87xeqh/Bw6W7bFrwveGPay41BekrqmoI4na97NWgkDyKHMKK/REqY/hcifL+uznE0E7nKTtJSMx5qWdCefraUuzfxL0QqHV/3sp1ouUdj+fOvZNpnm6eZbPaB2ka4d/0Fm8ZZVXUXmaTUx0z6TjvZiey5BMMD2Or0NaQ6J0SbVWfsKpBM9Kf1rBlCAv7jIvqKEjra++snmR
 tVCleSmv
 fr42CFwWMlpc1u9gqL3oHhELwf8+iF2qDy6Kq+EdOym0YxPZv0CZthAfOQAOCr7cguTivRn3Zr0uzGW/J3OPEIyvP4OAmaU6yWKmRdDlH2xCxNEbL3QogH8VeTzr/DgU++CT2PHnOxYaRelDO3SR5uysea1HotSiRexMmIobyBqD0KA8PpQM3CYNI1ZJO/wZzTfsARdg3O+y8dbrZSL/QxfjA92EuJENAyejCzxqDlG12lrof5iYwEAyNStiooexubNfc3+BPKoDfrjxvukvpHLqCrt3MoGEt2ueqaIaeI3wEiyqxIMkyRSKVoupzyCBIAlHJ1EImQ6G9L6FgpMAw0R8qOeMgLJl2G6Ax9mX1ISQGFGqYOXEU7yAxQEyZ8oNDOdVrCg4MztcOPOCd34IN/yOdCDy5IVbctxC4k059nV/A5Avgqcav6SuBcG8VxRKuqrHeNn2JVqp5OI8Of43l7YFCYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

madvise_collapse() holds an mmgrab() reference across its work. It is
redundant. Every caller already holds mm_users:

 - madvise(2) works on current->mm, which lives as long as the task is in
   the syscall;
 - process_madvise(2) reaches a remote mm through mm_access(), which takes
   an mm_users reference and holds it until the syscall returns;
 - io_uring passes current->mm;
 - DAMON takes one with get_task_mm() and drops it after the call.

Drop the mmgrab()/mmdrop() pair.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f49a6710933b..f1f8d4375e96 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3236,7 +3236,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc->is_khugepaged = false;
 	cc->progress = 0;
 
-	mmgrab(mm);
 	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
@@ -3292,7 +3291,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	}
 out_nolock:
 	mmap_assert_locked(mm);
-	mmdrop(mm);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-- 
2.54.0


