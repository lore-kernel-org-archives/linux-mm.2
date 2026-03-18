Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A05F1088E4A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723276B0367; Wed, 18 Mar 2026 18:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684B86B0368; Wed, 18 Mar 2026 18:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C086B0369; Wed, 18 Mar 2026 18:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5416B0367
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0415B1C2F7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:22 +0000 (UTC)
X-FDA: 84560628684.28.936D7DD
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 352C8160003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i0fisHRh;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNNnmWHnRUZm7wwtDTGZLy0ujBXuugSXcNtRiTK4tAk=;
	b=ZuahIVMAmmDyn+DdieyRPTa57w59/riXCpC9LbfJX4m81Bh8sXPdsCiwx+Uw4pIaPaRysM
	12zWcKDuq8xnD3/seGdV3CY/dcIWEY0DtMX+3vcn8j+PAlm2DQmwYsmFdOi/U05SWZ7gU4
	mNZM5kzRyNFtaCxLHpQ+wHt7GPQqb1M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i0fisHRh;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873020; a=rsa-sha256;
	cv=none;
	b=RpJcxMnQnoDJYYIjko+8wiLmtOtt/zWsrN2r/qt/12kprqPNh9iUoS3I8tS7mvlwoh3BRq
	6GMeZLNH6vMG9CCek3M9dzyKsNroqyADrOpTQPr3UjneC/T80tpICNLG7jZzHBFlhIdyof
	ISbDV0JhebkaL/lo1LdYgJdB0dCgXq0=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d74c1157a4so46795a34.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873019; x=1774477819; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNNnmWHnRUZm7wwtDTGZLy0ujBXuugSXcNtRiTK4tAk=;
        b=i0fisHRhnitlvIduu29t3vqdDz6P91hPzPSQhBMZ60UAnAJoRChRRf0vgcn5hSkYjB
         YGBdC9hResT5XEmwT5LiqfIgs3M0yMYedkNqdkHqL++JFugDErCqdhqKQOITaHUFArmX
         PEWeBlTMy5ArUwiw5HpGLn06ZKlwty/0axrrNRtV7tw7bNA3Qwy062kz0OyzYVTm4g7k
         H1KRjumJ53OKP3bjMSmBDwDwzwbnyyVP/LQg5RsvO20RWTyqD0lPi91pznGTDcD85d/a
         YCJEx5tgMiT2yNAzsEI44FrVumRpCTS/qjEwDXS2k8G64fLteVQW4LEArCBg+3fDBH98
         ukXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873019; x=1774477819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XNNnmWHnRUZm7wwtDTGZLy0ujBXuugSXcNtRiTK4tAk=;
        b=YTauNQ9iK5ZVxGMVAaJsEY61yEBRoI5Qq72zT80ePbehlF7l3FEnxbpHWcNSdAUXpz
         xUaoJJGY1uiFSFMTc2GEj2mF/IknU3/caWokBsDK86q4EyNrwhh69QxUcoHhDSGn+UAJ
         EoQxyKv2F+ai+QN4uh/rRP7ynmtH+en1JdMYk0SQp5KYIr+SsbPZErpDskzqSertdXph
         yFKGA8MoHuIJNMqwjO2a6sQfV+o9JcPHS3f119k+4MG4cMI0oDlSc20FytOAhIolZqWg
         VvG4V13TVkJ3Kgg4z5GIyZKM+eneq7bmQVDDslLVa1/4PZJ7Urx2Kw5QLUBVXP6SZXRT
         HpTw==
X-Forwarded-Encrypted: i=1; AJvYcCW7qBHOciGSf7F0Velovw8etnpLK3koDZvxFPJLv+smfgzuuUbUa6ajtoe8qmNkOuY8InIBpT3wOA==@kvack.org
X-Gm-Message-State: AOJu0YyfJzgL3VkEhz+AGkb5ynMU8zWztbc+BxK9k63TVVu7flISHU+F
	N635aFcTFOCJv5Hf8eoO+JUNpi7+L3hBZwre79r2RSA2NtzfkuctSeuG
X-Gm-Gg: ATEYQzwic4RKoG/5JZXY6vWTwd6J31M068NW48HoqPgtdYg6B6xH2T8AN4LvXiRaADd
	16e3XSPtwuukUZZY58JJYpfsX0u3WwF/AChdLnjb7X+GlVXxa8sy6pRYGWZyXbz74+EusCwGhx/
	ZgOQv7axf1sN1Lia4lIgA3F6E//Phsac2KJgdZ3nSsO9Gb23YqP9y5SZC8mnCSA3lQ/n35dtWVm
	kVrQ/Jz5l9Rjrvp/Hh85o+hyyX8Ru6MkD3VCnY6aAXH5HeY66KbHDGZ+T3nu70pRSC8oh3YaXJF
	2nwoCHbegmDzg08WDvuDCBX3MZVyqbDQyXU3tpsMHE00TfutpI4z3isVJeG7Uv9fiRJqIBV2/Ic
	KqgNMLj6piucVHStoY9wYbYk7iCGdVUgz3Pzj6tVx9253+RN3+mbTQR0VMWeOGjbauNOePIm4IM
	84oRDOtB8pYskH4dNNJkfb2cilD1BDGELXUP/ErGidOur/KQtmHA7vbW3u
X-Received: by 2002:a05:6820:c89:b0:67b:ad6a:ac10 with SMTP id 006d021491bc7-67c0db1a703mr3715865eaf.50.1773873019226;
        Wed, 18 Mar 2026 15:30:19 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67c0d88c5bbsm2544446eaf.10.2026.03.18.15.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:18 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v4 15/21] zswap: do not start zswap shrinker if there is no physical swap slots
Date: Wed, 18 Mar 2026 15:29:46 -0700
Message-ID: <20260318222953.441758-16-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oydbjodrfg3qobme7rq4w9qxpyobfka6
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 352C8160003
X-HE-Tag: 1773873020-560992
X-HE-Meta: U2FsdGVkX18tAtv4kKfc/3EJcNk9OK6W2I3TQq77gj/vFe9VNfgQ8GcGzl2/YntnhQ79Yi5PNL6L69SOW1Ge5o77c6ZadTjhhSX4phelkAtkfG11f77eO60fnSFvlcqCo/LEzxmO84ySO9o6UUzHhqe9G0h6fsy8jvOjDCB49H4BZ3fnq2OGr9NJebUipV9riGtgnZNyzmnApH1MZZm4cVb2kooc1X7pWuu3BUlDYQvsm4YMQs2WU/vbVqTsgNyythyr9Up/4DKUrI/lk6ImisZrZ7K/1MsK1sA0uVQoYy/jpDKxE18awCUzYdPL47GjA18fwDQqF7Lnju4TaNNqdXebxpHdPGKMndXGNhF/v/RMEShvPZZpXCD1c9HYHygZdp5xRwmkUCl2+zHzfNM3/qaMpL3RVBiz9h7zkFpDt7zcC+pXDqdU5ZWYIuGXmrz4XxbOgxL3WZVZyiZvDO4G3Zo9q+WPlwajYm3dUcPcR4tLud8iqUmlUdu/gsMEn/xYj5myvfgiLQ5V+v5Ozan77sTtBh7XaM3sc62KlvQzgPQKKVrIVyRQ1ohq/9Rj0Q4j8rbtjab2FPrA/yRXC9uGrOJoTImkIw8kZ6EiCINirIXQ93UfAgOpTM1q4FRA2FF7b8radJ39B/HuJ1Rrf/VpTKSERAUwp+OLZdSikFiyajUtD/HqPxhVz8B1cqCI9IwF3H8xRV4OAhYupZ4mS1dxTnpmelxOltijWGna1CS9yHM2WdMyYtXu1Rj+jmlVs+C0sH2CbYhtbYCp6X8R2a4WQrEczjf2zx18Y/r3k0Q5812bhGPS2r6Mw3xuEPlgw5qHptRmWxuFOI82HA05Nu3eymeXlRW/DycCoqMPNZEQvNEZnrOzWWut8pGTSQbwGe7Uj+/Vw4nphIEPAHiuLHfnvqEm+RrWriXxBYPIOWLAkqWQacVSav0O6Np6Q0iGNB2/FZiUvFNxzdsZKlDVoxM
 2J6mim4e
 X18K5gb8jbAUWK5qLJiFl+pNURKOgDrDfgU/Dm7U1JYRcmsgPwLzf7G1omNtlJH5k9xwDGb3X0bKOMsTC8mRY5Vzchhv9oWuR3bH3ZCuzoYDVJn7g945GxUqQzDQUCRb24hxWkigmMXKSgoVynIRd71yz3v9DnH+m6+yXQm3KV/2G9g3pCp9RQC46ixcvHTiDJ66zy2efjr0Xvd96I1cEPHgGFlMa8Vl6zPH0p+5r68MnOvXJ5R+neFLDRbuciyFQybHfk0bdQaLJyZPUxC7FWct3uAhTW5cIO7mfjYwvpelFz9sD3N3KdGmzVaWXuH2PQS1XMvHz/W/IYUjZKagAqG0LbL/FXPqDmrnSiA8+/iSgdWjPnSB8L2EZTsipN1tDBveGEITgc9H1xSAlcP8g7yeR8GhBux7GlKkIOLFsndSeJBQxgD3hr0A2Shxg2own5NoQ9RfPOdqcTyyYotNMSvDcoFeig7pQZJgKzhyW+iOkOZYBPixxRGA7J1QuBGSxeZBD9eINfe2UWFO3SHnOf4UNgaMWShLEjxQJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When swap is virtualized, we no longer pre-allocate a slot on swapfile
for each zswap entry. Do not start the zswap shrinker if there is no
physical swap slots available.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index c5e1d252cb463..9d1822753d321 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1211,6 +1211,14 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
+	/*
+	 * When swap is virtualized, we do not have any swap slots on swapfile
+	 * preallocated for zswap objects. If there is no slot available, we
+	 * cannot writeback and should just bail out here.
+	 */
+	if (!get_nr_swap_pages())
+		return 0;
+
 	/*
 	 * The shrinker resumes swap writeback, which will enter block
 	 * and may enter fs. XXX: Harmonize with vmscan.c __GFP_FS
-- 
2.52.0


