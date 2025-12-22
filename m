Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D18EE66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 00:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866CA6B0088; Sun, 21 Dec 2025 19:49:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3CE6B0089; Sun, 21 Dec 2025 19:49:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3146B008A; Sun, 21 Dec 2025 19:49:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 584E36B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:49:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9C091A09AB
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:49:18 +0000 (UTC)
X-FDA: 84245273196.06.8902A12
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 45AF11A0003
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:49:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CDcw2ltD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766364557; a=rsa-sha256;
	cv=none;
	b=w+jRH29zvOKx1tONNCEpQBwln218UENdrDKivb/FVgFBaktJOvWV4dIAdf4SMjgtUM+0Am
	43k48Q857Ggko5ziIF8ZEgzomi3/a2pmPKyUDQdOkF5ZMk9OOUb2O1a4Yu3b3ixn0J7vLc
	ozYcwXF6E+LVrahkR6SMiKci0bHxF70=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CDcw2ltD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766364557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/vB6kAvgJ/UHgjs8UorfX5aUFI87Lf5p0yAYqtg4bPI=;
	b=36D3Gpd5vGutZbYi1mnn9f8cKi19XurdwYIdAXLcVV4JNQdJci9o86wK8pG4B1Cop223qc
	+EPH7XZ02je8Us3A0FuS1TMJZtnQm9bY6lTkczVGgDTtp/tfd5TZ8M1467YY64pSacCUML
	4LyHtLLcNTTROAGIysY5DiMtuHpLUKo=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34b75f7a134so2599607a91.0
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 16:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766364556; x=1766969356; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/vB6kAvgJ/UHgjs8UorfX5aUFI87Lf5p0yAYqtg4bPI=;
        b=CDcw2ltD5HgIqqL8GBNnrQa4PexrFLkzOmOdXZk3ij4NDgJDCwrZPY9WOuhUIkDFvg
         El8fB3w+lEDGY2jIKTjeYtbcMwBaDmIfb01WKlwkrhcEVnI1El2IyFOjkCXRGt7egD2v
         r4c66eltDn/WcbVUeIFVyckExK3BVMtremqRDAhc5O63yNZUn7Nze1QQU+kARDk6/6Vq
         w7R/UAvT9IU2J8PnSq1nxR+3PtlyN9tdQymBkJiyI4vz0lmI5gdI+qb9Bn6NS6iewmgd
         hCwrRkx7YXgAxY9iPqhNpJo7TuC19gCLsaH7k5odio8aS8cprdcH57L5ExIUecR9gPDL
         BaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766364556; x=1766969356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vB6kAvgJ/UHgjs8UorfX5aUFI87Lf5p0yAYqtg4bPI=;
        b=Ywue9koUPCFzayFfFnH9L3bm5rCD8pElHDv7oJX8HNfBdwxux0eXmPaDJ6cJY+wDtP
         o2pryQlVJImH52z1VLYQ+JyMoYl4zLC0jnULuq/zPbFJRJ/qE0KRK6m6y13uMQKMeg4M
         A08gr2IsJzcIsW8tyM8lVBPbHa6FKcnodja3VIynhmS/W+LLeloIkniYE029nalDGhke
         av0JmurUPQSW3yXSh4ee5hl96KkOwFHBrDgkt4Srr9JqRoiu5sZ+Aw4YTGpdSMcHcjop
         5FvcXFrZ9DADRSbFES3PjuJVgsZLXMHQceTcKjZIA/v6560Z0zdAZnBO6VT20MQuYLkF
         hfEg==
X-Forwarded-Encrypted: i=1; AJvYcCXnB15/OxiSvxq2AM01KbRtPbwHMDfHgJnrmHnXCpF0IZSpR+nYM6iiCot/o81Xf3cE0Ex9mKy63Q==@kvack.org
X-Gm-Message-State: AOJu0YzIDKaii9l3jMfp/ohQwSlNKwu/Lww3sI+qo2wdXVhZc/YxUkPV
	8udSHHM7WI+9p1R8zE+VRgz6KIVnzMh3JbmZEZvLp6guiN/jRW9oq/LM
X-Gm-Gg: AY/fxX7owbTiZJprVTWsuVkqWlrR81BSDVxEqLtKseCZpxVK8jVZI40KB1xgNFCAUMd
	KhmjBo2fdXsLCq30S2OZRUmKUzyKEd3mOri2aZdKIOy13aHmIzlQrcOWQi9330mB1QL/FVMK2q2
	45WEDdRvLaoKqweb+DUethZt/kvTuqszo1ZB+Ew9e3dSMV1JFw+FfYZlLbEPqOk2H0WTxu3oPRV
	8PjPLsT4n5VoAKkbx27iwCxnKjKC4QmOPTezg4pQtm6c71kRO8xNW8tr7hZR65yYAIAg9Bqb1hM
	peMmrmfa6xG4UYKgQYQoz2J8GIdnD8pUjlpUUvafLn/yNEX5aK/8WqxnseOGR+xYWBJRdBGN0ph
	KoSLD1a7lx57DQVKJL+oTL0ccGxMH8ZCB3nJZMJHm492NPaQ/X2848BY6JIBDMciNIbcoTzFnh+
	y9X6PA/GBsRsuxrKog+tLHm8zYng==
X-Google-Smtp-Source: AGHT+IGweoLET5YnyZ2EKzJERfarS6dgnQ6cYugjO07yPKpn2IvtkOU/1jaFMgk4W8d4nO0djWxJzA==
X-Received: by 2002:a17:90b:51c8:b0:340:bb64:c5e with SMTP id 98e67ed59e1d1-34e9212a206mr8487470a91.14.1766364555876;
        Sun, 21 Dec 2025 16:49:15 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:df7d:b611:ffaf:6d45])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e79620bd3sm7461832a12.4.2025.12.21.16.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 16:49:15 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Subject: [PATCH v2 0/3] mm: fix oom-killer not being invoked when demotion is enabled
Date: Mon, 22 Dec 2025 09:48:31 +0900
Message-ID: <20251222004834.10539-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 45AF11A0003
X-Rspamd-Server: rspam03
X-Stat-Signature: 17zzz7sn851w7bnajx6d8wfa7my95ipm
X-Rspam-User: 
X-HE-Tag: 1766364557-836204
X-HE-Meta: U2FsdGVkX1++bHkOKpeuiQ7EU8e7Kv38mGfgT8f+knFgtYkg/3aYZf/5iAT/Q7N6f1krpQ5MCt8i1TxkttmAgmjlWH5d7jqE0ECL79c2k1hLpeGjjxJ/L12fb0HVKbnDviyvVvPBv2saJ6lCB0VvHcQe4LDM1/KCfsj0BOcgttuo2KFVINCSV/FrbL6EGVnG9UIO4nw8hh6zW94Mu96gGAw6vkK0cUWqSUFviF53vJyGp6B1h4Tzwe+l3LfKN2jCVhuKX+6AQOA2I35OyWccqkiVp8CBFlRMLA5EcrvrtwKMCQ9SEGzxfvu7TUmJWfFzH7EwAMWBwa0ZivpvyMmnRQ/K1611r6YGvtmB3R7If5z7iP1BXA+5X8lnP8AkOUYXYeYjgldL0CLRzk37r8GoPvZDeUS7Lu55dTR8ZHP6c6JmLbS+7HDFz9Mzu/l1fjopmk9zB6QwB+mqJ/W1Qo6dUihfdb4Er5iKD9ZY0SjEn80lLMpJaTJnebSgVq9CNlshKYmWzezQLNkoH1w5JKOh9L2tQEBmu5AfF0EVCyvGt5mY1c+xeRp+4gSxy0vDU9G1pMYcaoRtEoWOBwzLU91t0tvVU3x1FEgfmXFgB9FFWUWpYMowZKPUUEpZ9eiCBtt/dwIvKJCETaMJpGMV/SYFQybBEDwLdfzhMGjkoO76HnF5BFGjOv3V+YP0Q1zzRC5Ew+rP/ALYIixtjIVeBFHd8n+v2HItEvJhbsdNT8rbbms0Rg9DB9S0YPLAm+EEvQTvfViD0Ilq6hHv79eIrjkp8MYLxMJN081H4ybAyuI6wW30UfBowQtmejN2KT5PlJQnaE1L/nyZcI2ODKlMmyJ24/rz+331mWrl5Dik1Asb3lgitgnZIKsuyfKV5IzwXYusy5KmLgFyN98e5Bu9eom1Wxm9vJvnRe7UYcqtrDeNfLo85bKkv5e4atD6eNLqMY3zP9hcIQG0/q3qndKoSSy
 lkjfpRZt
 JXz3IEBP5vqLSuTW9H3FGAGS+RVy/d7HXNzNZgZxqJtOXkxJSCgPpjGmJG7N5hIa9Db9MgotCaR5eacHwDZFXYOhlPxveG6sAm/jwzVaA9zs4bx6tFVlvtWfzSRrh8UUKdgElnaPj8QGLIq0lDNxvxGnPdzou+URyyqNF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems with multiple memory-tiers consisting of DRAM and CXL memory,
the OOM killer is not invoked properly.

This patchset includes a fix for the issue and an enhancement that makes
the issue reproducible with numa emulation.

v2:
- fix the explanation about cmdline parameter in the commit log
- add document for NUMA emulation
- describe reproducibility with !mglru in the commit log
- removed unnecessary consideration for scan control when checking demotion_nid watermarks

v1:
- https://lore.kernel.org/linux-mm/20251208094028.214949-1-akinobu.mita@gmail.com/T/

original report:
- https://lore.kernel.org/lkml/20251022135735.246203-1-akinobu.mita@gmail.com/T

Akinobu Mita (3):
  mm: memory-tiers, numa_emu: enable to create memory tiers using fake
    numa nodes
  mm: numa_emu: add document for NUMA emulation
  mm/vmscan: don't demote if there is not enough free memory in the
    lower memory tier

 Documentation/mm/index.rst          |  1 +
 Documentation/mm/numa_emulation.rst | 30 +++++++++++++++++++++++++++++
 mm/numa_emulation.c                 | 26 +++++++++++++++++++++++++
 mm/vmscan.c                         | 13 ++++++++++++-
 4 files changed, 69 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/mm/numa_emulation.rst

-- 
2.43.0


