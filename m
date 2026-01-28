Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2645D46C0B
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 22:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB156B0089; Wed, 28 Jan 2026 17:41:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3CB76B008C; Wed, 28 Jan 2026 17:41:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09BB6B0092; Wed, 28 Jan 2026 17:41:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C063F6B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:41:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E6C559AEB
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:41:11 +0000 (UTC)
X-FDA: 84382844742.24.4B6EC53
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6E44D80015
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:41:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Moizq8ft;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769640069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uohmIad6LlS79xcr3Qf35rHIJmU7IKSPi2Ix1UxzKC4=;
	b=h35tB6yqBzNle+j+TrlFneKh1WUovtlbto6JM3qnEjUjNGw5oqFwLAwLDp3md9fYDd4v6c
	KOmj+X8IPzA8boyW/vdMZeMF1TFjFkMRwZbC2va41oUG+o72mxHstNmZpwXqOanbRYzqkF
	4mZXE0vOdG7VFnrxafVLRMUbtr961yk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Moizq8ft;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769640069; a=rsa-sha256;
	cv=none;
	b=DnMVkU9Fb4EaibrHAeRyES6LuB3D/qh+YWoQceJcbmVPtRyNgc5fhlin1JRdVWzQ5Jp8VP
	9XS1osgXbosfS9o9XbglzOVvR8EqGrDprQiS5O1+8EyN/WuckFX24ufNd18PuZwhRTjx0z
	T6Bzc/CyTFRrBzaLCRe/F4NXOKJHsQ0=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2b704f08e73so240385eec.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769640068; x=1770244868; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uohmIad6LlS79xcr3Qf35rHIJmU7IKSPi2Ix1UxzKC4=;
        b=Moizq8ft46b7hWfQxfhYMVyMGVTu+ItPnevYNFjdmbpevVww5iMNN0tg25pHyVwkAb
         EkO42GS88Lrj4pl9IVfglHO3cw0oyjSxLfgNzhRXL4hz3PoNcmnbKEAVeh5yaAkmoPgM
         tUBv6Z2wLO2selOvcwqhjnVqaeaGBDC12bOs5z/4I5DvJ0ZDjstNrUbHK2yZ4TiFY7Gp
         oHj70XeqvPKXNX7DruOajs8JAjlO+sqPTgj8uH7j7l1w1pkh5Hhq69My1xX3DgjwJltJ
         g+K9p/R3uTTSbSRIWh+vWWlhCJIz8CC25sd6xJH7YwMUadeRwLtNrolfc7n2Yjp7TXsH
         yd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769640068; x=1770244868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uohmIad6LlS79xcr3Qf35rHIJmU7IKSPi2Ix1UxzKC4=;
        b=aEJ1+w4M9CWAEWnKYTtKD+aSLKaiV5DteTefRg3mlTMiur98xeraRjQAXNH8tdjDET
         IxrnARQy/GqRDEgPNupL2go2dk8CHhVMWKROLpqV7SISIuBAPFyC+f3qQ8qbXPP4QgHd
         kegiwwyWn/M8fl3M4k2gCBc20PbAh6/GGQPRIB7lXDpHKvvB12+Q92CWxRD/CUfe5hVl
         oVJWBU+jjppflHnfdk7DzeTujI2SdgSHlt7ZP8jzGmTvssLpm6t8ZDCCUKcb6AkPXSAh
         lMHH2b2TxPIgEJaEAkSFrUG97XNGAzWv58ShVAMNYCUtLOtd7/ga6b23QYuvovoJamsg
         AOJw==
X-Forwarded-Encrypted: i=1; AJvYcCU3KlPbH6lwf5qCdVOrQVU07NX7FlnXG5IN3fR0gH73HXWxX1Sfu9ggFrxHX4ZE/aWCGzoeQVNQyA==@kvack.org
X-Gm-Message-State: AOJu0YzSZYUGtEHkbHE3JjcifbTcrOzbsAmcpDmO5k/IPXdccVTjzOIx
	RhqIIDT/1U8l0q/icVwhSemG5b1E8YHd9F6yhqIgsP/KeQ1DJG7F/qI8
X-Gm-Gg: AZuq6aKtSekkoXayj1uLUfaXF++he9bOiL5OtVu9CdJbLRa0dLKWHgVNdLgG67dG35p
	GTnJvWcCAntR6uiiPtxkltKcbRgT34MAG87GN+lGKEwJI3Vs1QnIe42RUxUaxT2e9PIg3u9OoN4
	/zNQNt4UfgCoL7LQZs+LARM6pNzmg+5TkrBB4zGXKo/YPWlO08qxT8VTGJ2jbqOJKT3OzYV/V6e
	uftbIdIRjjZIs52ADuY+wbuPaE3/zCa1Z3jcdF1g5fa2EWsoT6RUcbef9DRIdCMXGrBwrrsdPCp
	Hbg++0N0CzxFT/7JhmXL6r56wYXMd9J6zCJch6gc21CWV+tpvwXekWfSEPIpzKs6JvdrsnUY5g3
	l9WOMI/uotQQOGm6oaNPb/y7VkRUckzaS/DmFKdYC7bZNAKWbudPjwBVV476iIN7bF/zB9+Qd3W
	huyoJPTET16gNKpfpSY5UciYY4w5NuiwYJG94tqkTJIlc=
X-Received: by 2002:a05:7300:72d1:b0:2b4:5618:be67 with SMTP id 5a478bee46e88-2b7b17a46camr541066eec.5.1769640068128;
        Wed, 28 Jan 2026 14:41:08 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2b7a1abe57csm5439115eec.22.2026.01.28.14.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 14:41:05 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 2/3] x86/mm/pat: Convert pmd code to use ptdescs
Date: Wed, 28 Jan 2026 14:40:48 -0800
Message-ID: <20260128224049.385013-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128224049.385013-1-vishal.moola@gmail.com>
References: <20260128224049.385013-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6E44D80015
X-Stat-Signature: 7jhbegx4mze8w5u59qfr46dwx6wwjcpp
X-Rspam-User: 
X-HE-Tag: 1769640069-6865
X-HE-Meta: U2FsdGVkX1/GgpA2N/A2ujCq5N/XR8wrQP0xSCWG/jgWgk8Kbuk3S6h9BriLASS5pBenmpxwsymscaQ5Q7Jrgx5VsARF+Tynv+1WHwXn+pvdqTVNZtDXPPK58VR67lbf8QKsS65wSliYrenLhURHMv1kTinxUzij1bu/1oe+HmPaaTOc4ns0w5MPtj6TNko+p+NZOiMxS/Um53566R+GcTQTtPnXMvn0/wbnM+wmv3hzZf8YpyH7AdGK2uX2Cnmq6585Fo42PozynY1eOUCaOgg8J4GVjsvSWpZ0cvgiUyyR6Uoie1/oEPfa0jWO+PSnJ8wtoyiVwRd27esT/WHvXVbRDYOlYiezigjGQbXmQqZGNSGebVE1p3dwm4I1vgCFYP+XuGQvmXs578MtnMo/dZpsifC87J6m0S5D28rWJGoTjgeSDFJmQGNJufdosxO7PkGIBGjUacbY7/zdGwZtumxAO0pyIK5hK2EYwadzgHEdrHz/B/q5Bc1wV8yly6Eci/hw1sA9MUNQsU7c+WU/DWNxDvc2Ms/ookwpFK1LVdwDgu6FrAtCj4b/CnrezByOzQJZkvtGHr9a527BThmXiLh6O8pohQoWEqCBVNdCze2mv+L4u4FpYdbIpyW7edTK+6srS/Q11nQtoVqwMyALQ4VqCeovgd+UzFXqLA3rm9k0sY3E5l45Ldhzo2XFS63/nmOgFRu84/oXsyKEp6hhGQ0ddmfdpKNKaCZ329QYOPn4mQlUMJxWxEUF+Kl+KPWbxvL2C/i3iLuNfChsYIuN6WEFE51G2XgTz9JvU0BZ9xK621NAFoADHnV8Z/Pa1Fzfqdnpf4oakfh7LQ+Ag/geNUcHUIfxAOhgtKHG+q+en2FjpXAjnE3ReeMz69wPJ1UKE19AQOZmbpB/0+he/JEeLz/ybIj5rhCCZlCiAUP9fPScXle/6ebk8NrbG1vZKCW+N5bnpdswvGisf5p6MaH
 Gd0fYV73
 cxMP5th3KJ/kZXfjNI98g4R1qCIWl18svwJpQK95Y90mIVrjL6S64DKekglIHCJuqhfaQX5D4Q2taeIVADPlH7CaRS6k76fYvAFWwfW1DvRWo4h9/wmWen3dbGthmtI3WMhvO8nHDSsFZ8NvBizy2yOtRM4g71uQWKQTNZAIAl3GnBpiYkETPJHRomaECJQwIQmajsxzmOfgD/+79IQjSB6fzaVIoSy06j7NQa5h87WvYqUIoEOg3dv9id7iWgsntx0aiDlIAFWtS/DbQ38cfuV0c+uC1dl0FSV7Ojw6B71aOhxjXTTp+e4j680nGvRCg0Gg5fUJO+yt1JD+pY3GPhEfaobeEcDdGfcgk4//o1SNMjYHXejCM1GQZ44xSHl4/lIfuNag96XX7YihDKWV6J4rxCaYZEzzqSKILlYHtXMz1kqJjBoFGszi1ymHqSdyINtunDaVCexvk+9d9QZYJCuepb6dhp4VJ1I7GXF3hb9NCURkULCL48kgg6xLxY7ZWj6GB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separately allocate ptdescs from pages, we need all allocation
and free sites to use the appropriate functions. Convert these pmd
allocation/free sites to use ptdescs.

populate_pgd() also allocates pagetables that may later be freed by
try_to_free_pmd_page(), so allocate ptdescs there as well.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 2dcb565d8f9b..ee3d0067aeea 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1420,7 +1420,7 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 		if (!pmd_none(pmd[i]))
 			return false;
 
-	free_page((unsigned long)pmd);
+	pagetable_free(virt_to_ptdesc((void *)pmd));
 	return true;
 }
 
@@ -1548,9 +1548,10 @@ static int alloc_pte_ptdesc(pmd_t *pmd)
 	return 0;
 }
 
-static int alloc_pmd_page(pud_t *pud)
+static int alloc_pmd_ptdesc(pud_t *pud)
 {
-	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	pmd_t *pmd = (pmd_t *) ptdesc_address(
+			pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0));
 	if (!pmd)
 		return -1;
 
@@ -1623,7 +1624,7 @@ static long populate_pmd(struct cpa_data *cpa,
 		 * We cannot use a 1G page so allocate a PMD page if needed.
 		 */
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd_ptdesc(pud))
 				return -1;
 
 		pmd = pmd_offset(pud, start);
@@ -1679,7 +1680,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 		 * Need a PMD page?
 		 */
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd_ptdesc(pud))
 				return -1;
 
 		cur_pages = populate_pmd(cpa, start, pre_end, cur_pages,
@@ -1716,7 +1717,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 
 		pud = pud_offset(p4d, start);
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd_ptdesc(pud))
 				return -1;
 
 		tmp = populate_pmd(cpa, start, end, cpa->numpages - cur_pages,
@@ -1744,7 +1745,8 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	pgd_entry = cpa->pgd + pgd_index(addr);
 
 	if (pgd_none(*pgd_entry)) {
-		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL);
+		p4d = (p4d_t *) ptdesc_address(
+				pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0));
 		if (!p4d)
 			return -1;
 
@@ -1756,7 +1758,8 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	 */
 	p4d = p4d_offset(pgd_entry, addr);
 	if (p4d_none(*p4d)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+		pud = (pud_t *) ptdesc_address(
+				pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0));
 		if (!pud)
 			return -1;
 
-- 
2.52.0


