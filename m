Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A922606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 05:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PNnFpKTJ
Received: by kanga.kvack.org (Postfix)
	id 6B44C6B00EF; Sat, 31 Oct 2026 01:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635626B05B1; Sat, 31 Oct 2026 01:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC606B05B2; Sat, 31 Oct 2026 01:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24C106B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 01:11:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81082160180
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:11:58 +0000 (UTC)
X-FDA: 85381749516.01.A4F2836
Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id C7B0040003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:11:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PNnFpKTJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793423516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/Im04bCfxuC5NnQopVhNmYOL00IemUlIAdwN2EaZ0DE=;
	b=EZ3kieu7V1+idYqmagINU9n2MqdFnHpZ7iz/KEQzvAO+VG/wv7/zfhk0UglxoGj5FlTGL8
	3OcTLL9htFl1Nt5JracVkuQHWpQVVwyZFlHVEkt7NT0MI1MeNzWRp7VCaHkcinME0jfTbM
	Ks+YGi//0/vxD1qRmG4W/gjc4nPO0Bk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PNnFpKTJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793423516;
	b=ixLnWSLy/4DE7HhQ6zoqhqVkOVE8UfSkq3I/klWSZrj7FVxztbnu+VqsAIYQFngq4CN7NP
	TNuV7pA6m0nPBafBTZ9IFdpZYI3hLdyJK+bC89otuZ/7o8UVPxOe4tRE5z/Tsd0Q25wDN4
	mks+t2O0mSBIrvx66Xixjk3u9fRo7Pc=
Received: by mail-pj2-f5.google.com with SMTP id d9443c01a7336-2eb0c699769so4178055ad.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793423515; x=1794028315; darn=kvack.org;
        h=mime-version:content-transfer-encoding:content-type:subject
         :message-id:date:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/Im04bCfxuC5NnQopVhNmYOL00IemUlIAdwN2EaZ0DE=;
        b=PNnFpKTJ/gBvAYkqvtNMyrYxrP8KPikB6/mGSBKklgUt18acbeNat3AcDA6toHWa63
         YKq9t96g2hsnqRykp+iSkxaVGXQ50q9lQivBr8Qic00ryY1Fn1M/JaV9o4pWHQed8g54
         OY+SkTKu38SUPR0Lp8MPUD1wSVmDh+ig3hzarxkYbkvf7q9c1Eut9C3gEYgJGYiHbSZ5
         YP1nHgAfnsjt7bGrPPTilvdNY0OIwrfo6bH0LP12y6E+0/XcfJx+B+lDKB8KID8mp9DD
         zaPMoZk5V3KfX+nnI+UyYM/ErtRlG6+25jQ6CCLHr6/RjMIdwX9NKhwn34XVYAln3uHo
         2++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793423515; x=1794028315;
        h=mime-version:content-transfer-encoding:content-type:subject
         :message-id:date:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/Im04bCfxuC5NnQopVhNmYOL00IemUlIAdwN2EaZ0DE=;
        b=yLduVpFz9hnBwpdsZPg6EIclc9hBLxCtkC39MKG/fV/5Rd6LW6TibKvQbGJ34e6sK2
         CoFr3gXTUpijgzjMGQR4m/H6PeHHqsSQRSS7yIz1zjN8slyadUQhTQAbo4o02V6xNFbb
         bLz1uhIQfOj/pJHthVwq42OUYuIfkkrceHzgejgVOC9fmWonUdbagslRshCUNQh9jHAB
         6dYzqJ1tTlSR/a4LT+7M+UW52eSyHarq0QlOSZv0j9yEgN2B7IZegclDHX1XAIBbI9iZ
         Pwq+Zi+o0bX9D+BX8gpi/lqgHx5XAJLcsLnwkMk2lahTCEazU6HWXAsHgflZIXjmD91X
         19ww==
X-Forwarded-Encrypted: i=1; AKwUvBzzhVtddPMWSB1B1MZcA5t9HcWpTJfeKw1DDWNwg68U6kpc4ZhGoPuG3XTVxf093DKvWAi2f6LHVA==@kvack.org
X-Gm-Message-State: AFq9FYKMZwbsYJSsys2yPRB/dTn/NUwXO0dOvHTYm41O8KZL5DKXTxNc
	6frI2bGxZgt8kTmv267Vwymb7V63JCuMUyKwTowCv/e8+3hOROp2WYNg
X-Gm-Gg: AYBFou1IBQYzv9TxMeNVuSUJMfIW/s6PhwL240Rb+r07LvE7ExDtq09TLiEfc/gPTsm
	IzhlG5MVp4n/wDw15TDME8P5Iy6TzGFQBBg7ng80OWiY30WOoRao9bGUuZpQ3k1QBFmfIAIzOqa
	lEtBo3+kwnvXp8b4FexnU+Ecl+cShHfMc7ICEAb90pdXb/WuqTCc5qfbGqIsmtOgbi4R645mcvs
	aqtvF5VM5itDo5LPTozHHASivGnaYqf4weoDr+4YucBFu2GAnKgb4599g04H33rmaTykG9udw2X
	YP0d9476JgAERndA4q6PhnQ0Ij6Kpd01Q7gBdUoKbusKcyJIrVlS6jInX72DACO6pkQUd2uBGIa
	AvXI3coAjBCol+I0XMRN4ZZgnmJv0pi8sWkPvvV70m9EjxqLChZxVBEjMggPcwvCH4JJhDuNeBJ
	SrLej+oE9jQ3/IoWaKMtDs7YQ9L4zwT4a0Gr/r2eG3yf84dx7VqPGqLX/Y3S9j/E7prKbBPGhZg
	aMelMyrmpADgt9vPYeVrPG75F0QCemjJ7mbaIkrIQaxuSJTrT3FIwXXuZfWN64dPGQwjm7L8fQO
	X8bZEeLAdwbKCWnE3PJ0aOZgDfiqX5hgygOkIJJ2A040zhG3bcuQIemsjuJ3HJEaho/2rGb/0XV
	GPW54Q08c728+M0XRLVwgc8/rnalHoAqD
X-Received: by 2002:a17:903:1ae8:b0:2e9:7e90:8a3 with SMTP id d9443c01a7336-2eb364de7c6mr42312675ad.39.1793423515453;
        Fri, 30 Oct 2026 22:11:55 -0700 (PDT)
Received: from [10.208.43.86] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb39052bcbsm12905375ad.10.2026.10.30.22.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 22:11:55 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: jgg@nvidia.com, leonro@nvidia.com, akpm@linux-foundation.org
Cc: airlied@gmail.com, apopple@nvidia.com, balbirs@nvidia.com,
 christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org,
 mpenttil@redhat.com, Patchwork <patchwork@emeril.freedesktop.org>,
 SeongJae Park <sj@kernel.org>, thomas.hellstrom@linux.intel.com,
 Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com
Date: Sat, 31 Oct 2026 15:07:58 +1100
Message-ID: <179342234355.4.16705453209886955762@gmail.com>
Subject: [PATCH] mm/hmm: account for subpage offsets in device-private PMDs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: C7B0040003
X-Stat-Signature: 6nurj84155wsfhoxybsmnke6gxmzutqm
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793423516-735082
X-HE-Meta: U2FsdGVkX1+PgLReBtBA8/oaCF+sIwkcR9nzsKzUTMWdb+GEVMh2DokktFgLcVaiiRYz+3xTrin/0Kec6jfzM4h+yvs5VVIM0cVMQaCHr0T9rh2sxJQ0xAu12bYHk35R71KpU5njZkVu2Cp5diLxPy4CoWeBq2vc9qhLeLNnQOwo27t6UTbuihKncO9TPulveoIPYf2sXj2W+JDq5vytoO5DHK0brs/JXsow4gUmEHwIAG2d8tdwyvE3Mw7xjbTcCcx82LndgkCs/vIy3n+hCmu21N1fm7kqBkdWJtZ1dPCfWgJr0vaC/j3120vJ/Dg7P0nZvSsAiDCxkgltdsFgglYQ2eHk43m0CvSoAyOTw6PebJLeZWINN34W4XNlWT4CNdjQ1dOtYclDijVTJL3zfLme2RRwhbWgAdsWljXVsCzuoRs7DNu4fUEizXu26qiNJoK8pvpTlwHIwVKZh+U6VjQ2lzXXz+zsthzCagj5wEcau2rrGEKsSloUmZOmyVEeBPVfkqxygQ0t4InWzrb36yqOUuWDyOMAF5Fw+duWBgAl3dBh3yoEasG8lEL7mb58vZXmO3rVum9ql8DYtPqtAqW01YUWzlly4dE6qim4JRi3VQPk6oGdEDBaz0/aAtBwzwltuLvV5/VK45uEffyK9bK/vdWAQQhwHcp70dEtyr6eyRLNGLXtQGTITtlqMf7MHzSLlWpY6WufVczMwnonBhJ+s1kjO2VSAkJ6SRMH5uDywbImiLSpWFb+lW6zYCVEZfEq7EvFTMrD9Le5zPHrSBqiBpNU07Xp27LOpShZSiyLboTYLaPlKa7mcYxt2RrMginYzzyTJY6CZkZqL7/+w6A1RHjAl7bWoiUw5bGblGnVtI6YWTS/225BuN4H0xlHdz2JMTc403iQ7tV8gIltYP2Zvn+4atbn3ncl4iJaq+nB/Vq9NBmb46AN0vtgrP8aAugmYrzX+pr5s47b4TV
 woTWl4op
 FGDayl/fbygQFgnaNJVTkpu/bvTn2D3Smm5+EATJe8qVXn+toS4iFYj8C7sYU75CSjtEiu7s8c9l4AZnjHLTgq6sIfQp+NiRa9+dyxnaaOos1+HHtnnQEMy+ZDLiV7RSDgSue3EEevbc6d+SswPqCDtAParkN4I6S+XdHa+9RoE+yEiBQDF5V4ZQFNuDNIZfBq9NAW9OroFthVqTjx4oY2/copZXxr+iPC5izaFjnT+dtFQ7Xv6lDQ7IueA8/07zYsZTe+f3elelTEQactImDsoHDFof4GKlA+QyxA7fWVOT57Pg4nP1hLQThuptn6+k3rJ6iex0dyCei3kXztryQUEBP4fDrnjq5kjILulNMutiq1kIepo80IQsLYS1MlONPD8h/GBy82hBRq5oLRD8lKueZoA4mMGijbKQH/D6eTmKLRgxPbSrnCPrJ18FK4Bo9y2n23rJzicHEK6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a query starts inside a device-private PMD owned by
range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
array from the folio's first page. The returned PFNs therefore refer to
earlier pages rather than the requested subrange.

Add the query's PMD-relative page offset to the initial PFN, as the
present PMD path already does.

Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>

---
Found during a synthetic test_hmm check of device-private THP handling.
Tested PMD-aligned and non-aligned subranges, PMD boundaries, split
PTEs and fake-device data accesses with test_hmm in QEMU TCG; all
executed tests passed with the fix. No real GPU testing was performed.
---
 mm/hmm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b644..e89f140d3e5c 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -355,7 +355,8 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	    range->dev_private_owner) {
 		unsigned long cpu_flags = HMM_PFN_VALID |
 			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
-		unsigned long pfn = softleaf_to_pfn(entry);
+		unsigned long pfn = softleaf_to_pfn(entry) +
+			((start & ~PMD_MASK) >> PAGE_SHIFT);
 		unsigned long i;
 
 		if (softleaf_is_device_private_write(entry))

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
-- 
2.56.0


