Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1331C54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C6E6B009D; Tue, 28 Jul 2026 15:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE206B009F; Tue, 28 Jul 2026 15:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2766B00A0; Tue, 28 Jul 2026 15:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB4E56B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:47:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 75B7C1A050A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:47:31 +0000 (UTC)
X-FDA: 85039219902.08.C10BC92
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id B989480004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:47:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Gi5FKf2h;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785268049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFasOBUZoPmfk9ObuRJF8YRYjBN1D6LiYKjqRhex4gk=;
	b=idH2J/AK+xxlG/Q241u/paGTWU16qK+imFxdeVgm74H4F39Q34XwgCSqgERrHFaGqwq5K6
	cMDTMjxPd7Arq/jYxZogKT2cbivy7XCFBPOo4uTNtFIFV/osaLwsTzZ/aCw4/Oo/6zsKT+
	VV55Y3uwUet1ffkHWboNyhqWQmHEfZk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785268049;
	b=z6XyvBujevoAhOf+PIuL1q+2VItKLr5B0Ht6IXNhd8Ph5ecj66RhytPG5m/fGkl/4Gd5O6
	aPSb6iuXmokbI3Dlx9j/41habCGDCPW75ITZKRKPzrzwDTsoUyl4o+OeSioff/9gv9zl+7
	RwTHYYN2PiEqexY1BNsScqYqu/3i2gI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Gi5FKf2h;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-9034b6b7674so1537536d6.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785268049; x=1785872849; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lFasOBUZoPmfk9ObuRJF8YRYjBN1D6LiYKjqRhex4gk=;
        b=Gi5FKf2hTcFYexWECiG8aDsl9L6oMKPTD58sEeMwdHd/+5QXC26GfFSM9MW63TFdJN
         y973nuAt+kjO5E3j8iwsaUMk6xc93/lkop92cYFtK77G4+6TYtpgJDgjjWSE4sKjKC0C
         DqCXVOKMcL+bSie8DuN9sXnL4dtzE7hx7ccd+SUtSwP6gdIAaacWyb0SE1xiYm9cfKiQ
         xk5aAPMd1ZVNcOQaHzFVCxW/f0EONKKfLE4ewspoUbOyV0rdfWs1gvgYiiCaAxj8VZFP
         bTjzPd1OqSxFYKXOojTSxSDxbyccQOglRc3AACwRx9TZuT/m63h6yyvuTs/N7Cyq/htE
         I0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785268049; x=1785872849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lFasOBUZoPmfk9ObuRJF8YRYjBN1D6LiYKjqRhex4gk=;
        b=CuAIW3aC3tKCrK+5mlw6OVm16UXCDRgae/k/m+xk3H7qs4qzkxrSqZDUqvx2dVOTlM
         OxyXSYFaeADBcVe1likY1l2+qheY1SZjnOa+w+SRW/orzf/MRygzAsxDGgqb1ugkVdnT
         Xq7pLmU96KP2a5ikn3TRbZEVjpGQMwJ9WiCwhp1dNfcgnl+5ZvEBLGMdaQ5R+/X+MB8/
         MiS2aWYE4yiMnmcPB2RMjlts1v+9bxS4yC6yvhIAXzVSa8Q7/cWHEgYy3uHFhM0mSZjT
         vhTJOWlyohOBAW1sbOQzkm3TBZIS1VHwyVo2YjzyLtsQkYukfwraIqeFnQm/PkrdRWmj
         DBRQ==
X-Gm-Message-State: AOJu0YzCA+Hc67WLsLybvi9YBre6jtgoNw943WG705OwyvsOvhJKTa+a
	b04rUVkXJlWTXf2xxXFPYzX7VFTHp/+cTHGS27aVWmvMP1MqOUvET2gNsMP6d84X3KQEJ2V+xV5
	idX7T
X-Gm-Gg: AR+sD115yOp+OdbVoyE6Juooh6y5ilIEe/mnM8WMs2v+tHxVKUjn1L6EMvM1WokO+aJ
	eh9vP+CgqTJ6opsTx5uZe5d15HDY+a5x4HnIMszt8rWy41DBEYlsgSLwEXbETjSEIDAAmbDVyGH
	r3/Jgrxbl6lQUrSIFktUirrEo251mytyxu9Q/fSsfdyEIphZG57oU5PoTJ2WmciPMI/PFSbWws1
	CoJhIO9kJdOmrcK/eyBGa+9nulrWSgL6fqvNJf4p82SQ4aGycwyRN+b2NTsbEmcarGqgv9gqsoW
	dhU52EDTrs0UfribV7Y3bgqbbVlvE4wAbzw+T9ZMALD7jp8dTU1rDd44ItQCi7hG1EPnb+1chJ9
	vFWod8xKV6B4PamogWpwzF90OgypA2WgNih6aiPV8JlBJNmWDHNIvynu7C6vcJitxJ6rkkLcx7b
	0k5ydylVDAay5cyXAyiRiB3V0IJk+frRkygzKHtcnWRtkncfdF2rjI/SAMbkvV++d02suodOC4w
	wJuHUYoud0EDVhdyQSzdIzYX7xRYouCzHeElxzd6I9ncjS8PQ==
X-Received: by 2002:a05:6214:4847:b0:908:1bd5:9c38 with SMTP id 6a1803df08f44-9081bd59cc7mr30163246d6.14.1785268047908;
        Tue, 28 Jul 2026 12:47:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dd6b539sm6700176d6.41.2026.07.28.12.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 12:47:27 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH 4/4] mm/mempolicy: skip zone device folios when queueing folios
Date: Tue, 28 Jul 2026 15:47:14 -0400
Message-ID: <20260728194714.3713735-5-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728194714.3713735-1-gourry@gourry.net>
References: <20260728194714.3713735-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B989480004
X-Stat-Signature: f8ke63t3aubcikric7oywmg471kcsbfi
X-HE-Tag: 1785268049-456847
X-HE-Meta: U2FsdGVkX1/ZO7IS1y20f4PCZCAm8imCugg7LqOkTq25YcZBaSOax/yNL8TBZL5ECLLOempg0yX4xXfr1S6kUO27ViVuzvbXxO1hUG8Iu3vzgAWtv5BJs7WrNwMTEzVHCtygher0kd6AMbrZ8cBiJo6zpNPaVlGXPBPittygGKhzo3aZ8/N5GZHRwIQVNuJDhLsCVW19Qt4awuwbrOq3rCmGg6+FylBNKlFGCZNgJArP6PYIXatQXDr2Yb+uNa1xRvm7ZSCeqHEU9DPm2dcef8wQx2oW5kYYBHAFywoSLk4SCtalYDzGBNuQnEBbS29babUuvrS3oIBIKFRW+He4GQ3JltG+trK2Gr/r53I8qnxeM4tixoOlQOi/iwk19Fdcbm01IqWM+DSWujfHJl42RUTVKDd6kIDj8PuAsE1IkwkUddbCL9LFjzveiG12e1geXap4scaH9LlBQqCDCTXeiXMo//2iEOD9Mi3S7R9xmtlBHZM1APmQQcimQyHtWEzNTYlReT0/AFvGCKDDYllkE32NyScHZMTyvwBftE9GanJ39vFZr4Eu+NN2bnyJ4V8L51oWPHwBmhSUihEvwaa7TF5p4YYiPTyW/hadocMtNLntwXABdcqJY/nVbadhNhT3Bwz/IMZHKN//LyNikV/kFwXNvMXUYSlkQtz0L117idXCVtp6B5WV4YOJYz6wO5XjOerREKsT7+i4fXarEbjTK6SsP1yMSQHMWfaapTb0A1+tVr0z1RJek56uTLDOkdKscWSyEVJj8qJmMhsnj2WP9uBNZwm0CcYD0gvKoifBGk8NoFej1GmoqebBbU6EeCxsecom06f2ErBeJVX2N9BXOlE9xnZ+g1UytxVk8b6zZc/KjZZJB6InY9gkdMsuG2yV2TJE28YJ/ZTGxiVOCfd1lv3TXk3YoBzkq7FBh7SjI1DGIPYNm43ydgiOVEmPHJguoonyOMzPs1QkhUCwgmr
 Vjo4cm6f
 UKz8NT+Sd4GXAqRw7qPyuKhy2//EHFGQsm9fwIGbiDqrzEPppVugw6sYWRitZPD75BcSzNwHP+B0addgGPjPrhJ+4KALDqXCqxnhb4GsmUUKLhYRuksWFrc55L8tFqZxW5Oks8EoFtZrvKJaZyQ977PtuTjzvs4etBxtHVUpKO3niOO1DfBGzvpbc5+cTt3eCo57mniNCYKi9UymPoe7gYXUNdXYnrUJos7Mp2CHxzBNu6xgYtt/7WiPArJPO4cyo2ohJtJQb//VWS+pxcWe5A0/iR438i4/bTWswYAT9iOSvDes1C/mGB0v89CEDNG9CNninGd/VmaoVGSf5lsX0SbVZ8CF9ILdeMoYqVJeolEB8EeNRVrkasHTvlzxQ+KDHWOpo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

queue_folios_pte_range() already pairs vm_normal_folio() with an
explicit folio_is_zone_device() check before adding folios to the
migration pagelist.

vm_normal_folio() alone does not reject zone device memory (a present
device-coherent page in a normal VMA is returned as "normal").

Mirror the explicit check in the two other walkers.

queue_folios_pmd() uses pmd_folio() directly and can encounter a present
zone device PMD - e.g. a device-coherent THP.

This is not filtered by existing checks:
  !pmd_present()   - only rejects non-present device-private and
                     migration entries

  vma_migratable() - excludes DAX and VM_PFNMAP.

The early return also means such a folio is no longer counted in
qp->nr_failed under MPOL_MF_STRICT.  This is the same pattern used
by queue_folios_pte_range() (skipping zone device without failing).

queue_folios_hugetlb() cannot see zone device memory - hugetlb folios
are never ZONE_DEVICE - so the check there is purely defensive and keeps
all three walkers consistent.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5720f7f54d94..bd79e61a40d1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -668,6 +668,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 	}
 	if (!queue_folio_required(folio, qp))
 		return;
+	if (folio_is_zone_device(folio))
+		return;
 	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
 	    !vma_migratable(walk->vma) ||
 	    !migrate_folio_add(folio, qp->pagelist, qp->flags))
@@ -797,6 +799,8 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
 	folio = pfn_folio(pte_pfn(ptep));
 	if (!queue_folio_required(folio, qp))
 		goto unlock;
+	if (folio_is_zone_device(folio))
+		goto unlock;
 	if (!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
 	    !vma_migratable(walk->vma)) {
 		qp->nr_failed++;
-- 
2.55.0


