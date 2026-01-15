Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C105D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E956B00B6; Thu, 15 Jan 2026 14:31:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC446B00BA; Thu, 15 Jan 2026 14:31:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8436B00BD; Thu, 15 Jan 2026 14:31:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96E346B00B6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:31:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D2061AE3DB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:31:13 +0000 (UTC)
X-FDA: 84335191626.04.AB4B113
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 900731A001A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:31:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B3d9wGO5;
	spf=pass (imf19.hostedemail.com: domain of manish1588@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=39yBeV5nojqnVzbxpx7Z8tppWJP5mFOqJVw6gFBImjc=;
	b=F6LKrwpc4C6YN6kRVO8+HGl49FLTmP580RSwzfzu3jkiP/w2zo0g5UTbMS17cxnInBS849
	pT+xZHquk9iaF7hQIVnQGUQGH2Q48GDYvmPI5ZQ1Oi57CttDzTKIX42Q4k3mbZpjyZeIRo
	yFJD/ayiUirWl7fMb0cDxupQ/qg3V9s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B3d9wGO5;
	spf=pass (imf19.hostedemail.com: domain of manish1588@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768505471; a=rsa-sha256;
	cv=none;
	b=j8sW5BUXmcbCpdP2k5srFriSdkdYcY19RjCkvEkQndAXI95TCuB3Xxg9sGi04sD42rb6SH
	xJetdPCqcE09gDeZqmTBacTIMs2bZl7GI9NwVaLtnRVIvYX/VyvNeCCVep2TjtkLctqz22
	jf1urpBFAekelv2I8BOTNXtSXHKt3hk=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34cf1e31f85so640761a91.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768505470; x=1769110270; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=39yBeV5nojqnVzbxpx7Z8tppWJP5mFOqJVw6gFBImjc=;
        b=B3d9wGO5cRkKH9deRUHZ1rXzGfPHA0P1rWCU+DcM/7vT2PdaDPwAiJMEBzAZTSXnQT
         fDCnGiik6AiLOYDwNHsHTIVgE7mj4MuXqn2AXPJgTyZcV+CGfJ1KTT1opCXcbtS0qrLY
         TXlKheGemuhROXiS0AVr7l4TJLVCsF5m9MuJTjB6Tdmfv9QBQv7Kd+vs9/3Hscg2ekX5
         nPkcbi5BlyoiTIKBZe8U6bpEIwwoCPiUrs+0lh2xaZ32xnLaIu1FAWdLDdSSDFSBR+dp
         UngghERgQHio/1e/8Ze4WxRstrMiP6IdUQyw7WLp4uSz9JJCmGwpnBDbohknexBwlbCS
         KsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505470; x=1769110270;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39yBeV5nojqnVzbxpx7Z8tppWJP5mFOqJVw6gFBImjc=;
        b=bdFCfwEihdica2mWhaIEWvRYaK/+1nxBrePxfM3awe7ekaRywxUSjrBo2Zp/E9yU5G
         VeAoYT2N/bzNKvqGlbBpUjJzgTQzh7MGCWkm8ZxVwJsiJaB6VPcnkTUsFhcmwYDtVMfC
         IC3jB+1TalZYJ24VyRVMsMBG6/UVDBYACW7aaR+1cJh+IhPj00ZOAmwnBZarDDem4EkM
         tMe+SHJAuxH00nOo1LNpMIjS0j0COxX04GNIPDXdBqHnB/rL97Jmu8CWaU2QJ8SC+L+Y
         6+ZxHB+eQVcTzzbI0k0HczQ7seR4+FkTYT18laX65paIbMl7xBxTJRE5s08Ot3vPa5ge
         RWIA==
X-Gm-Message-State: AOJu0YzpO1VQtlUbr4DxkEgbL2DzssQ0UIt05z9Y+FNoM94FwGKmLacY
	DvrFPR65EHpLoRruyeBbiYjDfb18KMjHUQS7R/eE1+hkYRkvweZhgPAuIyNsFQ==
X-Gm-Gg: AY/fxX4r4+uh15x4PvYy5z3TwoqRSRdrUvaV9MJlyxb8NuzjCQwdxAYbqsdrDe9T0Pr
	Z7sE5FFi9d7uaafTzHitCEyosAeUWw2NDKIvVGo03JdGqPQy3afhHYxoF3lOiosjN55uQz4+A3g
	5Fzhhs8Y4tz5LhCnHQDMXuU3pZc+cEDPGf6Tp1z7rVhvH4DOgPsGf/igWz9kiGU6BWqtYXU+XGO
	YA/cCA0RPnAYN/I3PF1V9Mm0uBJIX6yPTb0Q2+7dpCG+hb4CUY7DIQf+XxODfiOzWoLUq6wX28T
	nN/9Nj4si0gCNrxgJTtycRMlYb85yafpTFdRzs1Q8EBcIj/EFD2qpv1jcmKaRTtLMkO/4LPxwJC
	u7nDtoLtwhOaXoF+sgkpOprPWOueqmg7bNDCdmQgAvTaeTjA7zGmoR2B8z2H/Xv2SH8lov37vhg
	aj4IBLgow=
X-Received: by 2002:a17:90b:3e45:b0:330:7ff5:2c58 with SMTP id 98e67ed59e1d1-35272ebb8ebmr421023a91.7.1768505470280;
        Thu, 15 Jan 2026 11:31:10 -0800 (PST)
Received: from muxbit.. ([122.171.16.181])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352678af465sm2670784a91.11.2026.01.15.11.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 11:31:09 -0800 (PST)
From: Manish Kumar <manish1588@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Manish Kumar <manish1588@gmail.com>
Subject: [PATCH] mm: drop filename from page_alloc.c header comment
Date: Fri, 16 Jan 2026 01:01:00 +0530
Message-ID: <20260115193100.116109-1-manish1588@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ookzocgbj68tdzejxbhayc8pxj3mjtiz
X-Rspamd-Queue-Id: 900731A001A
X-Rspamd-Server: rspam04
X-HE-Tag: 1768505471-821774
X-HE-Meta: U2FsdGVkX18/yWdBdFzGPaTY8J0loYdzBJhBUfRWS9p3SJhyF1Dyya2lfz17pxAHPt/7i9ju9SRLeTQZQYRgEdYOove30aVAeBTgV2GyADa72v3UuqYxdahXiWKc5NAHI2ypZ7SD/e5XvlzDTRSrkJBjphev2qh8mmVozY7u9nOXPgSLpAqaDoxLKz0q+QH72Cr/fd19i6wpu+/Re8XSOzoETEzJUBDQ2UlJoc2dANqbnzbK5gpmokc3Sc7mTQfpGU8J1p5CWpKDF+T2w+Cf6tAnwT5ZzzpZYIFxoyG5T0iuKladDtGHw/0rTIU6vr7OIEs4uiJX3vtnWZzqPCAS8TpOSlA0Tby3rTYOMDB9ZtC4AZPU9ktZLa0Isy4CNku1DfjYKCeba44mvLynTcbLoqAKOtApiwHuebV7mZjtFGg3e6N4ZUF33LjU+ja2ZVYra13CA2woVbUky2HbvqLN87hxjEZlEbjsK7tIm/xMMNjHSGzAT1aw5RHClwzTCgOO435ZQtMrj50dNVoMlIXzJESAdUyRpiZCrGub1L70IzS2XNhhU29X7w68fqM3s69Ut34obTrUa9YLmMkunrbrAHFJLyzpcSh5vNIoGmt2noVXGH34/v6VS8T9SsZkh8lDmezdeyamhzq+3EOYfnHxlWCsrUq+ZwhfMI2fMkeNYdJOHmAlTG5dFPjYlLiAGH9MKdaM3TctYdIp4gjQKvIsKdOxYeZmqHiLxq6cWdTrFiI8q17Gs2Z9A3sz7FwlUUnskI/3upqoctvoz/Uct3/Ey/hiuAWtFDWi5ChmzDAq6bgkH8LsoTF9TxHrUQkOe7PfYm/Ui3XFvs+V17MMpv63njb/teJ1S/EGqdNj9xzs58V3ZgrDbX+1TPBLM+315wSt7nh/58t2hm8USN7JWekDLJ9EE7KATsZc1BcsD+SmP9Y4Y+YaFwGC6GmU3D6oyd+GQ/jf7Y7J7JDht2nkeVl
 mbbMybUV
 zKAWUMif3WUcffEra6Pl+2DyRZ223OsRfhNNdRXpjYJDOHVtOY4pajqnA2e3780daQkBDxl3wfB3OQc3MXPct4lfgctPwE1yDHw1cGXoU6MvK3r9h/LceCp2eDK2sL1zpexA+GeE78tp+S5i86Q/SunHp6aAI+q2Y3D3JoRnqlQWhn3iiKHonPZlzgeYuorRWhkAHjcyqF0cFAtxDdyIBuqDGo7ru5AiysV+PfWB9bz6oeivJaqxrftuE25k06v/aFjEpLSz6xa1YvXn3PKrkyQJFOGdQp9RtFXfcHqm9HjqQIgL6y/aA9HZR2Em5ne3+nhk9jXT5C+xcVsysLt7nOcXT0CKr4Hn4LsH0yIm86quPcguQMNjcjkDRHLeKYfFApEdYZriAbGfkQyvoZVHn6J4W0Fz7+9VSKkqb1gXfC5G8ug5v+hu64Iy+qYZGwdT2p6aGELo+TaPyBo8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000004, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The file name in the header comment is redundant and not useful, as
the location is already known from the path. Remove it to align with
kernel coding style. No functional change.

Signed-off-by: Manish Kumar <manish1588@gmail.com>
---
 mm/page_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..e8db6af741b5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/mm/page_alloc.c
  *
  *  Manages the free list, the system allocates free pages here.
  *  Note that kmalloc() lives in slab.c
-- 
2.43.0


