Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E841FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3526B00E4; Mon, 29 Jun 2026 14:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA7C6B00E7; Mon, 29 Jun 2026 14:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB186B00E8; Mon, 29 Jun 2026 14:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95B9E6B00E4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:58:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BB3F120250
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:58:59 +0000 (UTC)
X-FDA: 84933862398.19.B8EB66E
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3617AA0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:58:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m8Uc7rNw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759537;
	b=T26SNqnPHK6GPro9wlCQn58HZIN5sqU6ahemBJ7Ss6idfg473GOg8X4gkatFXvPl8i34Qb
	FCJfVvp8wK2hgi7FcZZi3JWoAtgD5LSHagLeMELLippxETFi8Jt+caH424XX/aiTYqdZ+a
	y4J1VL/TSBP6J78Vs42mKJ1zR88khQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxPWJHTw3pT5c3azMOI7S+84d384F4LI3DJDkaDNu6Y=;
	b=V24PTeLHiNaSd8RxMxMb5Qksxm4qPpHEX+dkXysdXXudfStvwouBIGBzLh9DVYhDEvKwco
	T6LxijMo2z0BmP4UXI92FwFyHysFggWomH4tWvGqKYLoXJklPH963e3I+1hteIBmljWA0V
	O+jV2jVkmvWPdwcFtfo9gQF50eZ/qVs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m8Uc7rNw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-845369f60faso2158867b3a.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759536; x=1783364336; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KxPWJHTw3pT5c3azMOI7S+84d384F4LI3DJDkaDNu6Y=;
        b=m8Uc7rNw/u+SqaLlj3LyVL+aRh43SddDE4du7gfRVJptb1BFduGd6PRoW/nu06uWTq
         jEv+wA9iMoCiT3L29wm0Yw14Ax8YaMTmppyGAfdm6PDVG7xO+YyVTGDePuTbyJTCkhXU
         Wx1sp46zccrV/w85IJwKLVHGan5AvhN5IXUOY3rBJ28FaidiNbIvYc3Lxy5FGmxK5iCT
         3twqMepjANz0UKkMUmiftRfFAobBDfZjmQRYIUQ/QuTrIR899nEicojlbxjg4Volz9ht
         t0STs4JVad+jt2kXZA1tXk30+nhUznYDiIYqKL4jI5DfjOGAah2LA7kN8nMN2+0ZOKfB
         VY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759536; x=1783364336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KxPWJHTw3pT5c3azMOI7S+84d384F4LI3DJDkaDNu6Y=;
        b=s0RJFY9dJX8Xub0cpAw0mu0/8lbMJjxvSaLqBPgoTukbTeqveUQg0Ela0CuWQBs28U
         5UqTucCEWTn3PEN3oy+fbS+WFelj3ali7jHWga3scZe/voLrYs4e+gWBbu1kSgd4sN1r
         DeZ3iO44q4OSgevdRQLdoWsEkqobdQd9PFfUMO3s7PdVOCMvSjXFb91Ihh8vuT/jUxVb
         PuCW1QSQiOKzyirrwXbX9mTJaysI53LjgJTBsnIIXTRVNr3IH0xF8YqVfFoASIxHolB1
         a1EcxsFNcN+Ut5sNL3wiySC/dZn57Y9zaXptk2sC9vgJ8OHUNi/Yr5EOGlnc5icsdoA4
         MHKQ==
X-Forwarded-Encrypted: i=1; AHgh+RphE5+QwS8w1TwCIfBk60CRHFUIcmmilICXkoOztu8J5qrcsyBJtCNZXKB1Y9Ti8JImdf60Dz7KJQ==@kvack.org
X-Gm-Message-State: AOJu0YwSe7Yc1OfehNKMm4qSS6HM5/KIsdXHmPaTFDqmv9Rx1spQo8O2
	FmZcLGzyO4OUiGyTzpa2WtcJDPlODTcgf4stD3j5n6voNDjRLkgnPByM
X-Gm-Gg: AfdE7ck1/Vmg0zDGYb8hiAbh6SM/Q1lF1MX+xezxTigUlbm06nyzOec7hMqZB7mYYGn
	dJF0GOYG7syDmbUUrnogBfg7LYiYtSJmX/uNDit3vKS/tPRi4gvS/MjyP0lilWjL3D4Swxgo7St
	x4FVSvYyj5nbFecbgdkm0AbJs2tRI54nxdwp8+0FdElEJUYqAWqkjbUbWEIx3qzelTMC5Zfp/We
	y1bKoC7EeNRxog/+JwwLzIGgpjMob8Lmlq6aGAPRnES6yFGWWONtaX1CRD2PtPFtGcZHczhNMuI
	M7T4xodAlKoTAd2TDwRxluJXH3RKSjaXWFfcbMhQTp/RYaYVsB2clUJedAJ+Yo4NUf8BsZZhsWr
	YMeLptoC2xsyir4lDr0Wqx5yaDpcznzBSUFtGswLLSW73e3GylU8PuK2glFG+HQ1QeMr75KsJdP
	OBi+m+ZC6ztNlDgP+oPKS31UZaTZ/Cu2epV4a+yfxvnN9o3QNIdJpW+pu+YuQ3PPcWOVthnXU=
X-Received: by 2002:a05:6a00:3d10:b0:845:e60b:b5de with SMTP id d2e1a72fcca58-8479f2d3dd2mr559982b3a.59.1782759536056;
        Mon, 29 Jun 2026 11:58:56 -0700 (PDT)
Received: from fedora.hsd1.ca.comcast.net ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8479ff8f959sm223955b3a.3.2026.06.29.11.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:58:55 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	William Kucharski <william.kucharski@linux.dev>
Subject: [PATCH v2 1/9] x86/mm/pat: Use IS_ENABLED() instead of ifdef
Date: Mon, 29 Jun 2026 11:57:34 -0700
Message-ID: <20260629185742.126987-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629185742.126987-1-vishal.moola@gmail.com>
References: <20260629185742.126987-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3617AA0005
X-Stat-Signature: x6cizmut7bs4wgeqx56oxkk4a61r1ing
X-HE-Tag: 1782759537-601016
X-HE-Meta: U2FsdGVkX19OZldjTrqsISxBNNbZf95zDTwL+dyk7n5Awk1xFLCzH2MWTrJTSXdzbhAUtAgOMvaUEA81XDCcK9tXonoZsokYWPqvDTiCgQMd7b7q0xVxVi4jqGkZ2FhxwCIqp1xDKkETxxwLovg1yS1x8k1IGTKTkZwgxkZNpnb78qFKGiUJLuBCGYqObQj+4bKEiUy6jZ7/B9p7kH+kbF1flG7i4Khyx5HIMKCNRAV4nwA8ohEyaK0jEILpB7pPm8vAk4sJhWdICJtzuZPkJ+GBppElnG0j+GaSUeJuNbAWMo+lipYjOZhLtvT0o8ZNqqcK36Txxs16SB60g8biGkGv6Hhde1JthnF51a3yVi3h6xQ9emnm5g48lsf0yXZZjdeI4N51Zbry1cNbdzejk55+XW9dvHSFQiz4FIqCi5iZ3tlxHdFlyWlJblJ1/cNJ99qCBYA22N33y1WIoxMWft7/uihhP/uhcPtU9uEPeiPT+0DK9W3HMWfK9c8TfA9rFn253XoHzD3X5ZChK4Ek9OTmexwVN4fBiAYEh8Fkh81oLkZLe9m3fFboAqitpYZeqbH8YWpRtSlMxKMvyDWFFBVcvgOnD+gID6xl8wPxWZ0qSyki+0MRK2EJr9+7dhhyMPhUK7TTB0v7D1NQ3oNj5gYAgsOTQu45gMZ0VLtPgLNs8UswhfN9OfGsOAbhofcaq1F0VJIALm4C7OL1c5CUsaeuaUlKPrwwruNLs6ygvTl06nQVdn9goRhnLpFO+Nyxs4+n0jQgT+zLhQpuP5aQ+1S7P/voKqKEImo/gMEj37h4terfbv06aEh03AR+juuIqEHjqppReM4BQ9Q16ubAB4n4J/mO8zv+wkrCGA07jvVbJEbp6g8oMsWVhKhl9DQvTFbOsMZy9gB29KQrw8tFwgFrDcafAX+IFqv7Hp2QWGcUmueO/ZK3FjX34B+6/Ln8HonYa4O0O8JWb3W+q3m
 ZgayHQRd
 VcH0LjvAhhRPTHnIgZIfWVFTMYb+8UI6CvJ9OOyMNPpd+fWcSPU39sBMM1R0bw8E1k+tCY7tcm5CLOa/wCHtv8TFDTnUwxEy7a64FRE4PfaZGgo/NA3kreNHyjDBGmb3IJ2AlJyoNlW/84fqKEua+RTWfTTT7+HTLAYkzs2+JkvGXMWXT8M0avHRW63ZqhOSP/+t+lugnmH9PhzEfHjrxuwjYXJHZh54KZqwbhQGYH/2Q47R9adM6Ge68bVyKP2oSZ7fylVXoaD1C/f0sFZKOv8n/6T4tKK53RW6y5aLXxxFqIUufiPmYEkr9Hc9fkBSBg3qbpQkKZz+2dbubG+HeWNym/3sWA5GHg5tJhb1Sv2nIteA9ChMyLPo0HhF9Hh/ZjKqX6xyqFmNmrO9x2ci7O5Jkj45NgF2jO16TORZl7NQkeZzUEHdNAOiMS+kPjxIqaC1iapJ2Yn80FrPnnLfffpUUqaDRxW2Fh3ghsZ0BEd/jfxzbWjWN5U2kO0ruxncnW8luY5R3YoC4GtvQVUypzQiF2HsY/TWepruf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IS_ENABLED() to check if we are on 32 bit. This standardizes this
check with the other 32 bit check in the file. No functional changes.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: William Kucharski <william.kucharski@linux.dev>
Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..3b9032a3f315 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -888,8 +888,8 @@ static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
 {
 	/* change init_mm */
 	set_pte_atomic(kpte, pte);
-#ifdef CONFIG_X86_32
-	{
+
+	if (IS_ENABLED(CONFIG_X86_32)) {
 		struct page *page;
 
 		list_for_each_entry(page, &pgd_list, lru) {
@@ -905,7 +905,6 @@ static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
 			set_pte_atomic((pte_t *)pmd, pte);
 		}
 	}
-#endif
 }
 
 static pgprot_t pgprot_clear_protnone_bits(pgprot_t prot)
-- 
2.54.0


