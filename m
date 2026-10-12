Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4697ECA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA8F6B0098; Mon, 12 Oct 2026 16:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573386B0099; Mon, 12 Oct 2026 16:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0B16B009B; Mon, 12 Oct 2026 16:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06E4B6B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:55:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B47CC160A4C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:15 +0000 (UTC)
X-FDA: 85315179390.23.5B2357D
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id E6C3B100009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="NCJulo/Z";
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791838513;
	b=4e5PHC1U/R2ZIl2AdVdtlX8/YtA31ZaCG8ygnrcVDJhdSf1laJCws7B83W3yqftoELEtJk
	nq4kWk5gLfo2cgSOlISKXn61eK7tT+6Xw4Y0LJGRfjgWU0zHlZ5hXFKvlIDhxM2JYSjnSV
	O0tb3EaUvlpCGkwc2xISXOLv4gpb7uw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="NCJulo/Z";
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791838513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+9SFNU2toYET7V9kae+GOxpqVvlHel3XOqT/2H6Lgo=;
	b=tenv7Ds+5/LW92Dc+fvIBipHVZlFemghXEo7NODjHAzHdkD+A08Y/UmFEFZ4fUqk5nZbBL
	S9LxBpBQ6axnbem04Qbxzwo0TLNR+TwcRbseRFAHHYkcA9cGTAoeJ2+F6cjUnjHCWU2+Gz
	Xrguv72EaWjAqZpFsq1Jv88T1ZWWGMA=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49fbb2acc90so18487645e9.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1791838512; x=1792443312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u+9SFNU2toYET7V9kae+GOxpqVvlHel3XOqT/2H6Lgo=;
        b=NCJulo/ZyjzWLcvVyDoOpLOhu+QS3EpvFs91AURTs7BVmlwGsJ5ncxd80enWzxPn//
         FdYyvU/tBkgFdWg+oj4U2D+egVj1A57KEYVhuWmhlNUKk3fLncreBNACVdFQFmZsFj69
         1890GoxnPXMp9QdzVEfWuiyzH7EG/3QvAdK/fF1Ecfc+JJu6ItbPoHCGgY0Nz0nAeFkh
         6wTDOCt1tBxYhmIZ79xVuTCj0uN2VCDd4UliXTYSr4jZgBwiWeBw7Z5XQX9qXMe/G4HJ
         ZKgvRT4PxQViUacHiVxG5YGaE+64Vv1zwAjkVV6hD35J6x3wSs69JmTtnHFc7vNGMuRE
         xANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791838512; x=1792443312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u+9SFNU2toYET7V9kae+GOxpqVvlHel3XOqT/2H6Lgo=;
        b=BERK/1eo7mH8CD7YW7DCsOXxe7qXjky3LgBUaz5EXRUL0U21pQCl+GEqxYl7YeDTGV
         e1eJ3pm/AFO2AIGWOWMnSzO1rbnEiuuoEriVq0VI0crsCfThxMKN+uAcsKaLazsikYfY
         VtTXCk7oLutP5wURu5egBAAunQ+CQXP8eEOwpZKUBSZMi1hSkRzS+ch87yOtgT+MiXkM
         I7hkT/fvcsh6ju1ptHK/OvLtCpKVyqqXqmCSMGVz2alNmm2gZd9WmysZMFx07v3ctDOr
         //Xhb1NAqT54FN6tKeAWXYB7m9oJz1pK3wa1kqWDSeAKLan4Vw5G/yz5QlHmKxytJKif
         5dDg==
X-Forwarded-Encrypted: i=1; AKwUvBwI9P+ipfdIxpaikP4SimNBJQOVrV0d06W8lAy5F/O2xPq1YEQJkvLuGxOGF7R5/la55VGa4oYQWQ==@kvack.org
X-Gm-Message-State: AFq9FYI8VKQKfzPIuBvmH2jQm5nKheU4j0n7vglX/f/GZTJcRpetW+JX
	pslF3jZH011lVdvLaRzC6Y7AE4kFHDo/OISPx/IDq8S42/JWzS1pDkxCWqyg1DWTy0k=
X-Gm-Gg: AYBFou17/aih0XsLjB08JenuuAhqTDXBIMPkAy7zf7NpEIi2v1QVx/RoI3yVbQY16Co
	87I/PvAChUoY+Tver37thaDw+ahUYJEnHv+igM0F95exzdwUKRInPJd3T4HGJ8ngPiREh2NqcI1
	XmyZL5rVq1PxzSlX5YZiJdmj0sUmg7YUf6532YUk/HQXcj7iB2o+QZN/iLw52/xuqd6I4lzjXI5
	YSR/zPuYFhlqS2DRSGK5PPbE2kFoYPthTCQ0LEvWnyyvJgj1tIWsdJ843zRhO2ik3TehayTx637
	SB0hkOG/1GhW1VyWY0kJfyVymq9nFXC3QB/O9eEkORwRVHWsYiK2/xpCz5//SUzCP1cFYCC4qDA
	fJ5/oj8rPKHr2LYXE6ubpH/k2H1aJUAfYF2joi1f43+4ruYy5CJxeegjgm+CguZXRhiZD3fk6Zr
	xFeipryDauqPuMpUJZwHFlx/e7ooEiOFAhoNpU93/CtF/RwOPRSyIRAhJhOs9JS6l/UGa6ojSni
	3b2yucKrSKW5bsHuIVHsg1hpTV/XoKjAOZUmm1UJ7Weoj4c2/IbNHXReaFgm6vxlCkcFjMg8RA=
X-Received: by 2002:a05:600c:3488:b0:4a1:7690:d878 with SMTP id 5b1f17b1804b1-4a18e4b8028mr210808095e9.17.1791838512348;
        Mon, 12 Oct 2026 13:55:12 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0514ab1sm1895744f8f.0.2026.10.12.13.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 13:55:11 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 5/5] mm/mglru: reschedule between memcg reclaim attempts
Date: Mon, 12 Oct 2026 22:54:47 +0200
Message-ID: <20261012205447.2717801-6-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261012205447.2717801-1-max.kellermann@ionos.com>
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E6C3B100009
X-Rspam-User: 
X-Stat-Signature: fzr3gqbutz8cequ7gikzom83htb67p3d
X-HE-Tag: 1791838513-387648
X-HE-Meta: U2FsdGVkX18SdL1bKMAA8e+NGK6y6uWt66lcKES2vRZba5bcbdQ2ks6LFZe9WbN9TQJ2DuQGXIxDVEGntg2aBddufnthEaNV+PqyWqv2SZbqMmSDH7vaa2++Y5+wePPH8jhlDwVDK7QBz96EqwOzaGwJ5ykbijw85vePTu9brcVrj142FeS2CqvwLzyODRyB9aI75+e6ta26ASnuw2sxwJMZaky7kKr5/FhaL7r7oT4HTO408hDsEu0FL3rDuznMde4GT24R/6Xf3OB6UNdOQRvbA4Pi1WWNR28gNaFIrK3VHNFOlPz73QrPAuDRCV04yfsRjgQtEPsD4PwwzbmdOOZXO1GW0Z0Qg4L1EQ8wkm7HK0/iC16fKP6owesFr7t9GtqM9aen7WFzGK0GJdcsOoByjCVg9UjuaocrEZ4Pw5S41ilKkScSVer31/JXeX/xJ+wgQGVz96DGDfyKGdToGsvVRyGHihNE709FviWE2D292wAFjBrXPi890AIW+5MclT403aN4oVpAKSq7TkXMgm5CUreOQU0D2v1sh4QSppj/0ojMx12yr/IgSmuLt9nUCNn8rFNFKh1YOcz67u8tzL5p7HM+3eIe/GEAhYpdmXbFdn7a2RHb4je6jpVi+zVok68YF2r3uU2fLxf4Bhto0tfPvzE+HmzaF3N4V5A2sFYCIddO7EY/rODz1hhbgnebdWcjFECSotBugHj+pdWpOno0POTmiDkiFUrNipfuXgYUm44PfBxMZfOyHxQHu04Fws1s82pC0ARgD/uljHqjK8X/X/twh9DcHDXXqJzSVsBia0oR3vwoF+VRoCfQU+2c8Qaf9u4NYIBDoOhxGkVVxrURpMRr6wc9jnnFdWhvUbZLKGTcDNktda9N52lsHH1yjWcuFRQcK0Apcq6TC7OJ//nPm2xMUJspKRkkUEyuRYJ+hcQKDjJtA4hmv0sNUt8QRY6hrxWHPxjm+fHFPnl
 LV/t6baM
 GcO/W9XCtv0vxDT/JcB3nqXbHm/OfAruTErO8klC3tO55RSBcNkVFrjqQTpB17VSpjWVQhFuhb9QI0MwJDBpfLi0hiEYuemNkbdGCjkRALFQT/F9LjkCmqDtM0JncYH+2sEUdgGpYfqJsVxMtvkbhRiT+ZEnFUxtt6HLH5gDxkD4+jezZUq0Pb3r4nPmGV08qkxWDIvUd81r/Rr+f/i1UcvR1ipQmqxdACsINIrwBjV3XYRz8FbDACZYpfzFaz7NrEwwqqv4Qs8g6KTKwn7nonDCXIZmUPDirmEomVpyjMW1HPDQ+HSjWRZ7If7O8lFsOUAtnCqszYTcKqS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shrink_one() can return immediately for empty or protected memcgs, and
try_to_shrink_lruvec() can break out before reaching its
cond_resched().  A scan through many memcgs can repeatedly rotate
entries without giving other runnable tasks a scheduling opportunity.

Call cond_resched_tasks_rcu_qs() (as the existing shrink_lruvec() loop
does) after shrink_one(), while the memcg reference still pins the
cursor and before reacquiring the RCU read lock.  Also call it between
bins and nulls-marker retries, covering scans that skip every entry.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 mm/vmscan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 922c59eb9629..c9d53546dc10 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5194,6 +5194,9 @@ static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 	gen = get_memcg_gen(READ_ONCE(pgdat->memcg_lru.seq));
 	bin = first_bin = get_random_u32_below(MEMCG_NR_BINS);
 restart:
+	/* Yield between bins/retries that contain only skipped entries. */
+	cond_resched_tasks_rcu_qs();
+
 	op = 0;
 	memcg = NULL;
 
@@ -5224,6 +5227,14 @@ static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 
 		op = shrink_one(lruvec, sc);
 
+		/*
+		 * Empty or protected memcgs can bypass the
+		 * rescheduling points in page reclaim.  The memcg
+		 * reference pins our cursor while we yield outside
+		 * the RCU read-side critical section.
+		 */
+		cond_resched_tasks_rcu_qs();
+
 		rcu_read_lock();
 
 		if (should_abort_scan(lruvec, sc))
-- 
2.47.3


