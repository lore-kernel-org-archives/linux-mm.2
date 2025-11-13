Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85AFBCD4F35
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69BB8E0002; Wed, 12 Nov 2025 20:47:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2928E0014; Wed, 12 Nov 2025 20:47:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC268E0002; Wed, 12 Nov 2025 20:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2FEC8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F828BA9FF
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:03 +0000 (UTC)
X-FDA: 84103895526.06.47C10CF
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 76DE280003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=d2J6sZKV;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf02.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998421; a=rsa-sha256;
	cv=none;
	b=60yz++ij9CwQbaaIOim1aXy2Jz5Lt5iAjRHSHT8ecievLtwSpCZtOo57dASOw5W8ta25gk
	cc4fklneADRr1fzEidLLR7L3gWyRHT9leQEG2BSjmO4HJV52AsgU2P+z3Mr5uI//A9eRyp
	TaCSIs8bV7kp3lwBPgLRF1D2WTSGjjo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=d2J6sZKV;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf02.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdtMIGVZlv4MisNDb9tnVG+/irsKPLGgILycxKzmm5k=;
	b=OCpsS62vjjptE6tsvEvDOdDcC1Vxs6GaJdT6krAhcKj2/RHzlZdpHH6p0oCdi99SnfN8Pz
	44R2MD0sR52s0vgTU11RaMoBRLHB/zlcqCDL7JJePsci+5OY8W6nlnOcxwI8X6TngKZNOf
	EmkkLZRwdV3g5FV4P5aJxZL3F3Erz7I=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ba2450aba80so158412a12.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998420; x=1763603220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YdtMIGVZlv4MisNDb9tnVG+/irsKPLGgILycxKzmm5k=;
        b=d2J6sZKVDKJ3Z7+37wUFWCE1fS47CGmbJEDtzK9Emr0RzYNh0bwioD0l7WTrMUEiSI
         ueaujnkP77SeB0krZP/sKZ2C0SK++ac+ZM9SWW15JvXh1lBx5sezcWULOhBqRKRPD2eR
         1g6AwS237sSPGxUyaUpkgBXy8lBqaRj0oSIvM7VzMwWPn+W+KT2dO2SLJDCOJkFmTAIE
         e7JD3ArSL+NOXCVBO+B43nRDgGY4WeAgEshRu+mGIXjddgpGpWphy9MRzc+JnghERo+u
         u6Mn5FaGnAvg2IibaG9OPXFBYTsEOwDsVVbNmWboyd82xJsVx7bHHHOJGJvUzRc8ml/Y
         1q5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998420; x=1763603220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YdtMIGVZlv4MisNDb9tnVG+/irsKPLGgILycxKzmm5k=;
        b=VXMkW13OD/4vuw7YIFsvJfrOoon92CZljh0qNFvH8c0GLUCgSv/AcqbcWqhnl6w0mc
         BwFeArZ9W3j/hYX0pkPfMvxwqKlHkDgm9KE1fFkxKnEbdnyFya36xH1khdfUQe+tfs5y
         /Xv1WBQbc0knHzjR5T4tXFTLwj9QfjKbGtwKT2y71DREVNDDc0CW8RgTUBXclFT8Hqlq
         vuZkIUOgE8beD2r9uy8S7AJsyAgVYGxgjgVE9fSo55Hqe3g+OsBKnRAunGxPXRQHsMTm
         rvO6V43xe85r4h5cX+IH2AdssRwmN6R1ScKTvtapOCgKa054cbMYpdi0mzVVMM/1dO+v
         ddrg==
X-Forwarded-Encrypted: i=1; AJvYcCXkbh5M1JimmpXnJHCOZAnK3OA42HtsBHSHdrhFY6jNRUtjsMnrfOsQd578xk+YRjnD/+xt+iDZCQ==@kvack.org
X-Gm-Message-State: AOJu0YzH3jnKpteJmjXF8TRenYcC7up0CkE0zIpSF3j0erU1Gq1KmHb6
	DFX9maz4NIUsd/ZeUZKCBQ02aIrk7nUvHlZSAmOmGSL7HGvHuOAEWeHnks8MwSD8ils=
X-Gm-Gg: ASbGncv8xcz+wvGizkb5bzmMGYz0BYdaaNmcyTfURRRuSo/EOmSbc6Q3l6r0KJmSdjR
	qOWOYnkyNTVU6uoIZtrBhK5NZwahWTUIpJt08tuc9AYzWOB9sjGfq9wY6VdGLTkQjE6OrCs1keN
	cp/GCWk/3RYKfl//faRrQxOOy7ho642fGD7bEY7OiEcOpmmM2B37TwTQ2jO9Zw/l2MiwBKXd1nX
	NG9Qr2ErBcq5nPpiwy6SI2tvOf0eMyLj0ydiwE5iyC55vUe6yLeOahoS9kOmQbikmjAYHAhpgGZ
	anoupA9K7Lg3rK5tjE3lo7KV0sd904IHg7j+ak+6wCiI2dOXbBOSLg9TovdCwzlLfF/AcDbsSfO
	bBWbgBHS1YuoSvT1Bju1Qu/JW/+7r8euRUu8Sppru7cbrNyvVPnsl09pHvf/kl7RJDvYEsBZKjX
	tDvVFyvYzn0xIN+Gp0rpbuEQ==
X-Google-Smtp-Source: AGHT+IFYjWF2Je2zdGG5G71XUhLWD4KFs37feNtxzRSLtVmw8LZxUlSD+Pjrpw1Q7n3dWJ2wHP2y9w==
X-Received: by 2002:a17:903:3c64:b0:295:3e80:9aa4 with SMTP id d9443c01a7336-2984ed46fcamr62445305ad.22.1762998420290;
        Wed, 12 Nov 2025 17:47:00 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:00 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 01/22] mm/ptdump: replace READ_ONCE() with standard page table accessors
Date: Wed, 12 Nov 2025 17:45:14 -0800
Message-ID: <20251113014656.2605447-2-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 76DE280003
X-Stat-Signature: 5icmqud65jzynm5amkiw7k8gn6rt5fxf
X-HE-Tag: 1762998421-56813
X-HE-Meta: U2FsdGVkX1/EgZU1oDRV5ADUcVMY5z7w659Ejl1s4wMkCzw8vWwXOWs0jNbvlqWGUCRtvjYun8NHedHDWTIVHqcIKKNW6GwbPaZwiePpB6o+cSwGrHG5tQJ1KEwANkcOVkmSXOSy9OMje8fGGNwFLbKDX++0kOZHc4GUmgiJfOVY+bMDGqhGGcPeU2CB1K7UBgla6YZLX6gfbx1WBAG5tieuwaSeafA7iCP1DmKawSO6hXwxI0AtHfd4dAefApzLjRrXsfaEnr54SVNEZGXiSXZphpY7q7RSElEd7xAdSp6fKFCdsryvOT8CvMCU1R9sbL1KIbUnXU523BwihO5eOOwtaarF5t3bNuKDZdxREk+OibIqiSu+2ANq+7Nbono1DFvJmZAf7sGqPRrOi7Etg0iYqvd4Ev99lQBmUzseF5Pic8uaVlVkR/GpRJSsBgRpdXlojo+oVB4kHzT/y+ORB7i7MeXVfzmjYZuLgTwlZfJ2IhXCpSBVZ+bmQM2Qg2/GiEDQAcdCvXCeVBeppMxw4XpVDnFVyxvTk3XQzEvTOXMld+Rn4IwBDGu35QzAqMm3/DxXomS8A9r0gC42iXa6Xfkge8TlOg3ub33nX5/KzkESRknSAMJ5HUBh4vU5+kp94C2rY1NVLbu06I2ljwPEzAJl6U66BNNmqV7w+py492GRKkka+m58DOM5i1fb+yk/mY9UdATi2XTX8d/gfA0/sV2gCTP9qBypQqeKz0ogPdEZNMfTQTQJx6rkMSAh+Lrdg4t6Gl5DZuQWHi7xKiCFa+qU5tfcDKNLlplp4z5go2IpjXtBOYVbFa7tdwQh8Tp/hW5zCcRALoyiZ9IXJuDsv4UAbQifsbe5HNDxiNGCAT2inVfPBz361BMYBUMja3LDCd7VCvr1z+TgDrKXGmNnTEt3R/7dRz72BZWMd1na47ppim83GzHI6dKtae45aQ9HKrH8Mko4sqobTAHuZOZ
 ITCCnkZM
 Tjn5rguWzkopEpfpCTu3/9o6iia4oxrK+uFUVNrl33ade5cCIEqeTcujscsq8rd3Y6FxtC6vVVB7Krp93iY85vTr90fFnVbta6AMlllGimNaFyf0Ki8LNtYThyTvMxVjmLNjGVMZxhu+TSrBcNw/+wJTbjS+sOa4e1tTHavrkUThSGggHM8JI4DJZEbkjPWtsF2Y6Qzg1v+MlIGijP3h2kpo7Og7d/OPy34OkULyd9L6YNZuabF7oyffB4myI2g4+6GeCU9vFAntRG5zSEnwMHJrJsn6c6rOkar4j07GeroX88Ole8X3aOD/aDU/1Wv7Mdi4bfng31ZFSYqBeNDBbmVuDlUQV7wL6ooyJ5inPsXlCdoTmhX17yWEtBcTqSFdevfitAJ84zddArVozA/MS7kJkHyrTIHbPLhoFrfcvO40/Fsgp6ZtHXcjQgdiSCID8TVu8Fy+hiowmOvGEhAOOAjLDXlhW+2ziqVjcDMyfJroGRLJMxxXDwxKKFg+ztkJRca3GxD5kqF0VxwzUVVNcRxGUv0jdmIW/IlF4N6arniobFAF3aPl+qHe7KhyF56WMQbkY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Anshuman Khandual <anshuman.khandual@arm.com>

Replace READ_ONCE() with standard page table accessors i.e pxdp_get()
which anyways default into READ_ONCE() in cases where platform does not
override.  Also convert ptep_get_lockless() into ptep_get() as well.

Link: https://lkml.kernel.org/r/20251001042502.1400726-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v3:
 - Replace patch with cherry-pick from linux-next

Changes in v2:
 - New patch for v2 (taken from LKML)

 mm/ptdump.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/ptdump.c b/mm/ptdump.c
index b600c7f864b8..973020000096 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pgd_t val = READ_ONCE(*pgd);
+	pgd_t val = pgdp_get(pgd);
 
 #if CONFIG_PGTABLE_LEVELS > 4 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	p4d_t val = READ_ONCE(*p4d);
+	p4d_t val = p4dp_get(p4d);
 
 #if CONFIG_PGTABLE_LEVELS > 3 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pud_t val = READ_ONCE(*pud);
+	pud_t val = pudp_get(pud);
 
 #if CONFIG_PGTABLE_LEVELS > 2 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pmd_t val = READ_ONCE(*pmd);
+	pmd_t val = pmdp_get(pmd);
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 	if (pmd_page(val) == virt_to_page(lm_alias(kasan_early_shadow_pte)))
@@ -121,7 +121,7 @@ static int ptdump_pte_entry(pte_t *pte, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pte_t val = ptep_get_lockless(pte);
+	pte_t val = ptep_get(pte);
 
 	if (st->effective_prot_pte)
 		st->effective_prot_pte(st, val);
-- 
2.47.2


