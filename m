Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FBA4EB594B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 03:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DD526B0005; Tue, 10 Feb 2026 22:00:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881166B0089; Tue, 10 Feb 2026 22:00:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C616B008A; Tue, 10 Feb 2026 22:00:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66F716B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:00:50 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5F22B6F12
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:00:49 +0000 (UTC)
X-FDA: 84430673418.03.A08025F
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 09146100005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:00:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=mWZiqCIN;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770778848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=snQGKzM9krQ2e/nG+wxub5/+NEsJEn7FFGNgMKn8dWM=;
	b=HiCigtII8NRN1qa3IcBmaBnkmplHk11nVk1QNpn4BsAIvlBhYyO6YLo2T/tczkfYYvLawP
	wNywlcMV2MVMG0da/80nDu+FDmWiPIUpsHlwF2KB+U4yj6RGQVLbkwmGLXlNQZkwSgKg0/
	cUYQI4XRO9HgaCG9nXeKRjaL1qXiPMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770778848; a=rsa-sha256;
	cv=none;
	b=WLScmBMc+hDloUMw9umqY3MTHAVluzuLxtSwhB28CnqwXTFx19i22A8yVyy/cb6CPHqHqg
	JbPiw8mN0yTaLju5nShnIMP8W0x03JlBzWM/9Uel7wssDb5TNuJ63E2nmgv8+EeRUGyGDt
	he2L5yLuclUlsIu72gG9Qd3uaAF37YY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=mWZiqCIN;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82491fbf02cso455576b3a.1
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770778847; x=1771383647; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=snQGKzM9krQ2e/nG+wxub5/+NEsJEn7FFGNgMKn8dWM=;
        b=mWZiqCINHRTKQeZ+mVReCtKzhk04DpmPcN/OCn8gSPg2/wq0SWHyq0qQ+8bzf+Gzs1
         3mqLEH+KJ6sUrbug64p2sFf1y1i0M9oNNKN2cRNJct47smAzCorYGsPnIkEiqWWob51C
         GnJDrbpDXVqWuqNoBtMdPagg3/oruT0iR6oDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770778847; x=1771383647;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=snQGKzM9krQ2e/nG+wxub5/+NEsJEn7FFGNgMKn8dWM=;
        b=qzK+ruIwlYex/FkbEupE1seoqWj7nTGhzhjCfBAyexI+cHD61M2dxro4w5OGEKPQWj
         0/N9KpUnoEE5D2ASRYXYIhPyScidvBmwZRIAsPxrNwvhMu9mvExggxtaGezp6HFfejrp
         79Rh0zSMr6+/d//pj0MbPJd+hmNfkRvWE+iwtoQfukcZTpbFOloBcoFzAlQihGKUAlRA
         nBF7R+qEagNur0MA6/JqzlqmZunAdYI3bFv8Joj6ebyrRcsCk7AZvJ+PGGk29Dd04yRJ
         a8B67nsFAGh4gexicpYOhSRkE9iQ6gqJgLS5wVQMveb2sO418yT74cMRTt8gFkI1fLNd
         /PsA==
X-Forwarded-Encrypted: i=1; AJvYcCWJgm8gMBFk5UV2FmYpZrIh3dkHox5zDseDye1EGbqAyMkL6+r8wFbVyD5p5GxOxG8s82S5kJRqFQ==@kvack.org
X-Gm-Message-State: AOJu0YyxmgbUAJdPKMN1v3/0yBwV3fa8kvXI/WjEq1l3o5W1ymeMgBUD
	RksN/CY1fh7UydgFBPw5Y4xNyMIJtgnOxVnLdXMnguxuOzcHD/7h19dTYSHG4P8euQ==
X-Gm-Gg: AZuq6aKyZKfa5Ds9yhGArhYXiW8WzpflxkFj++ooT/I+R6ogq9C8pHOxenD+m3tJEsM
	vV9lp04xOXB4K8JzRzRwiWOfIBFUziSD8qEswA7MWgnd554fFet5BZA0gGCT5KooYUxHUi3YSSx
	fUNSb85hLgfObgMaYPadmQ7afFxD7i5bP/LhWJojgqHUqtkU3lX8+UMPn7IDr0nw1LeZWRDmjJm
	VMxPHurdU8lUXXrVROeIMBvRLPlaDWaL9qzq9SlGSqSPam2sHLsTcu0LNIZ3i//kSx+PzfJ5NLA
	FagJLt2ln5yGLT3ZxA1J3IcGqLoGi5jPVymAfEBE4gbq31o9jGi4xtO0aDzWRwPTtdxfyugtkgY
	I1VqixQbk2CsWHUZDgLJ88WE/W0n+qg3D+AqwuSYP1aBxCNCI/DBhpErvOjNmve87v/ASH3oFFM
	DvAxkqU+yApI9bOqEMrH46ogSjX+rzyYcIndohrw4qJxCD2bIHAlTfvBFQa5kKInfoBSjPtwajW
	6AvwyRciRjUlRldgDk8JSk=
X-Received: by 2002:a05:6a20:6a2c:b0:364:be7:6ffc with SMTP id adf61e73a8af0-3942e3a189dmr1362393637.18.1770778846732;
        Tue, 10 Feb 2026 19:00:46 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:ec5:3497:e96b:e7be])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e196accf9sm399528a12.13.2026.02.10.19.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 19:00:46 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] mm: khugepaged: make scan loops suspend aware
Date: Wed, 11 Feb 2026 11:59:55 +0900
Message-ID: <20260211030024.232964-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 09146100005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: d4ouaz3eftarda8upk4g11m4t1wjhg75
X-HE-Tag: 1770778847-831010
X-HE-Meta: U2FsdGVkX1/IJByw3oCLiGHPtoOtJRD0CP8aKdTPTOqYljlQv7pOttyUYSS9Z8+x5zTXFJ9D65kjodvoP4Alqwt7VNj4fhtz5TXxUUB28+XDF8B4dQv7Z+y5RD/jE5lF0uT8/lupCif400NIGxtDUhr8eRfzyt2Ij2fB+FOPmCAFg7Sd1VKmcgWRO2GnVbekB5pij2Sh6yCnB+WAEnVE81fDKeoPP02W1jjNLjYUQQcLfXVoGbhLB62v0BtYHTsAo2CJ6gi2197mI6bdzRud3ZWCiQchr3GW7duaxz46FzFxlvKuEgkfA/WCK7fMi/74ff1vvHm5TZucoKArbYQU1hUH7ZACKo66Mo1m6WrOrK35qPz0WuvOHqgaDd9vQJveQIB8/ROxHe2r76FbVT4PKEnRqyAHYHCfIb+U2j8R7J8P7hxvs0HWvrq1fbiti1UOnlJvWBrSc2bDPVDaW8ZatLAcpV6Ilrlt8E92iCTen5mwtU+atMk3aA+z496e40UQOExNX0JBh4DtFmcEI6oo9wM8FsgKjiAJEANQaZ2CGT4pEUj2ytrniDKduaYWL4mvH1BYVRTb/pdXrKQNznysISFsYxhC6h+Fv/QHTDYQh1jaGDMD5KcLVnNwmvBT9cy/ecwy5IFEu6OGsJy1IENSi/jseyWCotnLxEyCZ08ES7FcvbtRXZQ22Pi2PHMH0bz8ukHqCVFiVblDLcQOLOJ1VnjQe07VDozUd3XozlPv2J/bIlX+/7nYMNnxvLo74LoaUy89GxHg9z7hACcKZrjZI3iPuTPv70wA3V1ZR7vYp5qnAQNFLIzdebejfeZP/KciIKznEjzFoA79mjxgaHjWyOEB9SmFghm96lxc3Wc1Rubi88hi52OeV6t5HOkonO9Epca3LsOPBolIUiWZJ6BgvN75zTbqNJ7P0S+1RuCO4XYOH8IP9NtW1npJUVKA+eRJVa+0/rVAUBHmPfgCODB
 0cDvDyDw
 VliUQNGeXPgm8kh+Za9UgVICIIj9Fnp0S4YT6Spi/dy5fUtmgrcTga5YuYupZMrnnBwz297pY5MJHuemPZ/KBVRbTUJ2Y4SBNsid9kWGiuCPfVud+3BhUytgmak8EEpfGavXtGwrWJhYPf+EwclhuUIw/IJdvZ3zUbyizlVNbNeEratehGSYgawkvRLxBI7dT6ZcHXaUHby/vApCDY2TsM168/rIN8gWQzTzUqqiL84MK7vnCDm0pgfaJ1afs/d0SdbEPBwTFkDvReiGzqdg6y3G2Mtsh6uySMlJH+/PS9GpPEB4cbExxZYKQMzejfAjnUZQBcFT9j+lvv2HMAeFUFahPgJWR77k8McrDhcIVcJ63lys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A number of khugepaaged's loops, e.g. khugepaged_scan_mm_slot(),
are time unbound, which can become problematic during system
suspend:

PM: suspend entry (s2idle)
Filesystems sync: 0.003 seconds
Freezing user space processes
Freezing user space processes completed (elapsed 0.003 seconds)
OOM killer disabled.
Freezing remaining freezable tasks
Freezing remaining freezable tasks failed after 20.004 seconds (1 tasks refusing to freeze, wq_busy=0):
task:khugepaged      state:D stack:0     pid:1345  ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 schedule+0x523/0x16a0
 schedule_timeout+0x23b/0x6e0
 io_schedule_timeout+0x3f/0x80
 wait_for_completion_io_timeout+0xe4/0x170
 submit_bio_wait+0x79/0xc0
 swap_readpage+0x150/0x2d0
 swap_cluster_readahead+0x3be/0x750
 shmem_swapin+0xa7/0x100
 shmem_swapin_folio+0xcd/0x2e0
 shmem_get_folio+0x237/0x580
 collapse_file+0x247/0x1280
 hpage_collapse_scan_file+0x26e/0x380
 khugepaged+0x43b/0x810
 kthread+0xfb/0x120
 </TASK>

Make hpage_collapse_test_exit_or_disable() suspend aware so
that khugepaaged's scan loops can terminate in a timely manner
and let system enter the sleep state.

Co-developed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/khugepaged.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index eff9e3061925..9b3201fb6840 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -392,10 +392,18 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
+static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
+						struct collapse_control *cc)
 {
+	bool was_frozen = false;
+
+	if (cc->is_khugepaged &&
+	    unlikely(kthread_freezable_should_stop(&was_frozen)))
+		return 1;
+
 	return hpage_collapse_test_exit(mm) ||
-		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
+		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
+		was_frozen;
 }
 
 static bool hugepage_pmd_enabled(void)
-- 
2.53.0.239.g8d8fc8a987-goog


