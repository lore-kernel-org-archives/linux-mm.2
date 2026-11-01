Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94765606A331
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZEPDPrbw
Received: by kanga.kvack.org (Postfix)
	id 75CCE6B00EF; Sun,  1 Nov 2026 12:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734746B05B1; Sun,  1 Nov 2026 12:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64A446B05B2; Sun,  1 Nov 2026 12:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA946B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:01:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF423160A67
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:01:06 +0000 (UTC)
X-FDA: 85387165332.08.EECB093
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0E0F9160014
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:01:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZEPDPrbw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of zhangxp1998@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=zhangxp1998@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793552465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ROsDDi/peHhOy6BynZJX3N2nHlHF3d+geUaRBvCkIfc=;
	b=aI2yuYkrFYXvkaEYpmHbMjEIhTtdNwlpMchsC3GOVyotTQSZH8yALTb6gNicBVMyRllG7U
	57omSAPoEM0Kytiija6LcqQSD/l16qL3Y5wNKpEVT9lJAu+vIAzqfNimZ1VqBeYMChZGWw
	qEHi8gxDlBSGuR33UDbCNBxrnkrfywA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZEPDPrbw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of zhangxp1998@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=zhangxp1998@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793552465;
	b=GwAwhdk1iFyxCrKWnwuu/OFMMW7HQR647u6B6urMeZyAE4eKXvKWGGWKhKMbDTGyG+ewzr
	lResvRuiuAs6n01Ga+xIYgIfKHII12LD756RQgcgz7QK14ll5GdN8v1pRpWYUvrggwJahb
	TQojCz+6OM24a+g17zgsOJFUpF2Y4mk=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-369f33df08eso4585199eec.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 09:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793552464; x=1794157264; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ROsDDi/peHhOy6BynZJX3N2nHlHF3d+geUaRBvCkIfc=;
        b=ZEPDPrbwASwo9d8I1tAhyyXJ5oUhR3z6PSgEsKK54FUSbFqFsqqcND19YUwCJJywPC
         btYU0yOWT7cgBJmHVO7IYN2ygojYV48TFZ+i/I+xCawIwkSgaGl3HaBmezaxr2J5vK2w
         aXAaaNtLW3TpDNo7ENXqxRND9TA7f97ZzGYUdRyZTZlPsGIg3rXmkaOj1eGA7y0xL8mV
         HzxecNCKwE9g7UXFgOVELaWEknRw4igCT2HbFwRrAKGE/cRvU50EVucj0PL+XAmYtCj7
         iVT8Wt+nWY1kJITEx0AzrtkbwIzpCVY9Rqww763Zp9m3NTU8YWWiFTedFeqmOltP7Ok4
         D5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793552464; x=1794157264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ROsDDi/peHhOy6BynZJX3N2nHlHF3d+geUaRBvCkIfc=;
        b=g8kJ8H5VZA60Uw+OxaeSI8+E8wAjR0g4Blhzw7cd86gwzsWcAn6LRf4CBXJHaNNM/T
         xOZPO0wJ4YytAkdAUjMfC9QCFOuI9mC4V53N8zzh6mBQ3B2MG07qgaCp1Y91QfQ0CAqM
         Z7+gSKzPuZZw2+OQuVI21LumctPByx96C/+p3BqfJH4edtJGqzUDTfaGDMmPd5PHfuze
         Frihhzxk5z1H6aCzmnWDnAeaZy2Ewogz2qjbZZzsT1oT49xZsTFVvuXPyjfY+1soz6/a
         Lv7tgNeKWGnlvg+KnPv8USK4p4oNSwcjg4C0jHCqL+Evy4U0tEzV+m58LNzIO+u7ze+q
         J+5g==
X-Forwarded-Encrypted: i=1; AKwUvBy4k2ivPxHm+WPNWD0CQc75S8ijmbCV/pDUnhD7GSSNQnliJi6i5LZbmLX6e2kF0J0HbaikmxrCow==@kvack.org
X-Gm-Message-State: AFq9FYJK5RdstJRqaP+m5IRZvpTz9HHa4Hzu4O/vQL9bRa13rZWDuw17
	0hCUYQxRrr+dMgxH7P5x0GaFXU8SxNDb2M6RjiBzVlfoprUD/0ISaD7b
X-Gm-Gg: AYBFou0MJxptHamhQkUv/m1X4+I8IrnFrl8aN3/iGJ+zEmcB0L6xaudMhL05lfhlLPd
	abQVE9SzHZQtnCKCvP+3kt1bkLdo7AQ4zTRQJwDBtunCjgyFxbCfjw580VvngZ8eD1L1OfRt2hY
	QCN3CDXSFkhBMqvhGpRI/QpVBf+11Uwj6pKbTrFcDTy3NVmshvbS/X8Fra3u66gPoFNBikWMxWY
	nwBzMDe8R92fih8iNjdcFUy5/rQwHCQBeIJZ5X6t6Q4tGPgjDOHG8Fr0RkbEfuZxaIFiXwwmDC+
	9JyxqmBgtXuFZGL2pqXPcaJ/7emiKXwrnEozzqIHV2NlTwf6YyOeJRy9bh8vQdFR0+oxNN1JzHp
	B+HaKntdiyttV4DZHWKG4ohz97EE2canxVyNL5dO44NXFThg6eQZXY627qF7eLueZaD2acsaeP1
	VXNk3DroqwlR59BapN2CQ77aH6kobKa+6MP7UrG0E+owkEE0Qsclwcwf3bBtKKJkmteK10LuXBT
	jXn170jDK7KVC9p9xArcP8jHjtpEb/o59yJFqOfNOEOsQsWJJpN7gWGEY72nm1pTZ3sdWnkEyAZ
	cqxg1mPvNu1RTGa/d3mK/Dsi9T3daTIpIHa4UmcuOdexHIAQ0QNK/i7e
X-Received: by 2002:a05:7022:f50a:b0:144:eb46:be0 with SMTP id a92af1059eb24-1ac5cb19684mr9393895c88.13.1793552463413;
        Sun, 01 Nov 2026 09:01:03 -0800 (PST)
Received: from [127.0.1.1] ([2601:647:4184:b3f0:b5a0:ac44:5583:ef02])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm25456350c88.8.2026.11.01.09.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 09:01:02 -0800 (PST)
From: Kelvin Zhang <zhangxp1998@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Kelvin Zhang <zhangxp1998@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Kalesh Singh <kaleshsingh@google.com>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] fs/proc/task_mmu: check THP exclusivity for each subpage
Date: Sun,  1 Nov 2026 09:01:00 -0800
Message-ID: <4c1b393a4b04bd94e4f1c7879ae04e1793eb0931.1793552446.git.zhangxp1998@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E0F9160014
X-Stat-Signature: 9iqgn9dc8xiik5iwdz8zjrmrqor4bs4t
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793552464-244909
X-HE-Meta: U2FsdGVkX1/MUebIhTw4ik7ODCcimqarQYfgThD66MKCh0/UEF7mt1fuHKHyM7KAB6HpFXu8KaTetBjYsa0v0HDwsFzZ9ZPb7ZT19WZaUMH7mgFZNHj5Msd/JQXDhXkiuGG5P0cdwBVvUTDCQ0C4xophPhGct+Uy9kaTtnkrJhruxkITjdOye+0v9NXaqz0iZBJ+/td0ncfvVHwNDrxXEJd1Wnr0EdiYbzhqeB4PXJh9c3W7AvwJ2qp+IlFsEYrKAISaebCoS2qHWoLyQerNct5yB0XjQv6Gy3fxKRoWxuQEB0lUoJoKyXIPSlmzQ8yK1F+S9IW3J6u6oAG256zW+eGpLfNos6wRFv2ZuvKHlcgzLn1kY3Ly2xL8dspg7x+e+xkD//tkBPhVNkcu7qIQcwjpHtAAc3RK8fIpbBDATHHDsPJtbBUIWZ675HKBjl9GqQK2gwaFTlaWnKhT0/9GaR6ihdj2+ccV1joMWES71YRAvyx6NNPMIQwPR2BhpHYFTnE9Y6h9Ywuic/1uEMHr4HsLAtMuwvQlMXGz80rW0qyC/ueslFnXuPNXLBTFYO2crvJGXw+pQ8ZcGJQC03gVawyKMj7YW0QB4cfMFP86Y7VWsHfNqCTCkDtTLiPgPY01SbgVpbJD/BlPPZZzyNydjUNpd2eo5VvduLZh3vZerw+iY/hn/d9Cw7I+GbwuNBgEY57mdmWun/l9IMIIYyJBvWg2i9CrcjgbDzKXkROkBaa9rGPHHogH9Ncv/3k0x3M7lEw1CK5JQF1JOdvfIwnesxONeYHsh/J8I0wy/3iavePdjEn8JpQMkC2qOJnwrVoe/JeFC3Ul2bqcR8InRJrB6tQjrtK51TRk1YG+A6tk7dqIzlttEWF+7qiPqFpZCjv1RVkTRkcDMBbW6KADiyWpi93YrJEcGsfidvnnCB6Kvd8UN7bhJ/SwqNwcuXJlt62j6sJ0v/27pIc0fswoGqf
 Zu8HdzRV
 F/Ou4jMaffacB5Pc8CDsStTeIQjXo7WfZKWzxjfl3CE+jiBnvt6qeBUgT73UmDECAjIiWD42VYWt4WYCEA1xlB4PJLpIVlArLfB/YoE1x1pbdfvy1xGnveB4qOJ5C4UY1kLbbklnss9s+/aAYT5pFvwvSiLbeA/+rF1DID3u+OXou8iqGN3kgyywRhs1pKIliiHDUkvg8ligrgHV0OhPN8wMVTEzwqsQHgBITLp5tnKhayL2BBrfjHdRveKn81Yb/6LKpE/aXTKWoEDu1tstyZfOnQMpoT4iIZrSsSrdf8O+Jh3p7NqnpENCAJc8Jb8zKwpj5ZlH8G8owTvyYQ+GCzij+NM1eF8QZ1skwAkKACOFCazF99bL/Kt7jTwunYjxdez50pbYq8UzRSACRtOY8VEVOpaI8DXtTrlMdBuBJL49ZunB70iqn2eXy8F9lndKiMjnxrCyvi3ESv8mH8mL2sW36O1XMzVc2efAk8CQf5fQubl4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A PMD-mapped THP can contain subpages with different mapcounts. For
example, after fork(), the child can unmap only part of the THP. The
parent retains its PMD mapping, while the remaining child mappings
are PTE mappings.

pagemap_pmd_range_thp() passes the same initial page to
__folio_page_mapped_exclusively() for every pagemap entry. With
CONFIG_PAGE_MAPCOUNT=y, this applies the first subpage's exclusivity
to all entries, falsely setting or clearing PM_MMAP_EXCLUSIVE for
subpages with different sharing.

Pass page + idx to check the subpage corresponding to each entry, as
was done before converting to __folio_page_mapped_exclusively(). The
index already accounts for reads starting partway through the PMD.
The conservative whole-folio check without CONFIG_PAGE_MAPCOUNT is
unchanged.

Fixes: eb16876971ea ("fs/proc/task_mmu: remove per-page mapcount dependency for PM_MMAP_EXCLUSIVE (CONFIG_NO_PAGE_MAPCOUNT)")
Cc: stable@vger.kernel.org # 6.15+
Signed-off-by: Kelvin Zhang <zhangxp1998@gmail.com>
---
Tested on x86-64 under QEMU/KVM with CONFIG_TRANSPARENT_HUGEPAGE=y
and CONFIG_PAGE_MAPCOUNT=y, using the same test binary before and after
this change. After fork(), the child unmaps the first, second, middle,
or last 4 KiB subpage, while the parent retains a PMD mapping. Both
bulk pagemap reads and reads starting inside the PMD are checked.

Across three repetitions (12 cases), the unmodified kernel fails 24 of
84 assertions; with this change all 84 pass. Fully private and fully
shared PMD controls pass before and after the fix.

 fs/proc/task_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index b87d3e86442d..da4319d972e4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2038,7 +2038,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 		pagemap_entry_t pme;
 
 		if (folio && (flags & PM_PRESENT) &&
-		    __folio_page_mapped_exclusively(folio, page))
+		    __folio_page_mapped_exclusively(folio, page + idx))
 			cur_flags |= PM_MMAP_EXCLUSIVE;
 
 		pme = make_pme(frame, cur_flags);

base-commit: 64703f0fee7421f0ddfcbd8ee1bfa53b25ffc4ca
-- 
2.53.0


