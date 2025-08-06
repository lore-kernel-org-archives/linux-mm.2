Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FD7C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD63A8E0006; Wed,  6 Aug 2025 12:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE198E0003; Wed,  6 Aug 2025 12:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3C88E0006; Wed,  6 Aug 2025 12:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC03A8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:18:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FF1458ECE
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:18:37 +0000 (UTC)
X-FDA: 83746840674.15.4F5BFD2
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B6A040006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:18:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N2WmDTe9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754497115; a=rsa-sha256;
	cv=none;
	b=rtbTaDnSoHUBPuuuX2FunfbalWMTD3mmG4CC92m5OwdeXS0SkAqe9tF9+5/mBGt/NV5CCc
	RoM5pvrkQRjYAHRvIWGEoAKeqP+MjrmE8SzYLCOeqjh1J3Qne9pKWzkVZvHmrrSr6x5adY
	DgJoJ8iZNe5aE3INKdaQSbwDqWeM0qo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N2WmDTe9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754497115;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=m7Uvcgab86Z6ZLa6sJF+QuCkUEpCn18pclHA8j6Pkpo=;
	b=pjkXFl7B8qycUYpzU9L64zLAH5RJqYu5UmyY8w62WtPWQ51weSk8PMGK+8K/ANlKYZfiYl
	txip+1Cq/by+bWB19x1cR8h3gCxA3DLrV1BSCd3tIeDOwuKs5x64MwcOmkuezLTrQ92mGH
	x8lV8vFa/yyWvUjXWln7d+ZV7wzkPPg=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7e278d8345aso6028285a.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 09:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754497114; x=1755101914; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m7Uvcgab86Z6ZLa6sJF+QuCkUEpCn18pclHA8j6Pkpo=;
        b=N2WmDTe9WMGdvqoKISxhfaXv4vpi+JjDcnk6+Cwh/yqzdyv8jfLWRwJzuywHP5QnPE
         Rbl2rmfcwXIjvIZlJwIzXjvY2aWw1A+1oSLua85ZQzKInVIPAarPVBt8liY6IXlDlCMg
         0a+EVBPrTXNX0vlss2B+iIrOc8T+v9vN7yxBjqNTqr1MFcGkxVM/pLQRNgKu9eN+JgT4
         lm89MbPyqJpLX+SiGiEWXA647JqUSxx8t0AgZ5SC3vzpcpcIlIDfAED5aIVCbUsMVWOx
         jUG3WmyteT087NeZ9ojH/fHNn0TIDUSQ0eXyK0IVb/65Ku1ju+yVfkS5owq5wVPQCxPh
         mM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754497114; x=1755101914;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m7Uvcgab86Z6ZLa6sJF+QuCkUEpCn18pclHA8j6Pkpo=;
        b=sP+lvBu9aqOtR35g1c2P9ZpUuFCgSw8SYAY9ZUmTWflW0a3HRNY/u0L+DUm0Z7ycKR
         A8k36Go+CKc12REoPBCGa73n0nvqDuc6PbZ0kc1Uqt2MkxO8z35flXtn9UUdSBeMAJOT
         H3fbgfS5UUXhA68NeYFA67berqXXyUpyVcHt5PE0pOUMvusuOs4pTsZ+WSvQSIzvEeAb
         hT+EYK+F/9rGDbK00WScGRxbQDkddRtPvBADz5pQ4Ub1d0oHAKj+Fik1sUDC0QJa6n2j
         lqOb8gnANWWhsmX3ohnqxVyPTnnYpCF8+c+x46o4fNDUljHqTJTNAJ0balh016gSIZZL
         F0Fg==
X-Gm-Message-State: AOJu0Yw/vbaBiFBY/CRiPlEqYyp6o+ji7/GsKBo7xukMjK9wHJfzHe0e
	J9kMBS070LIJcdl/Oh2MoNxyCb2V3QwrsVJEI/rRnagxwdkjozlB8BDnIaSplnKP0+g=
X-Gm-Gg: ASbGnctLetBoih/delaSPCD1qHZwaUpLkK0squR3LhKe3Ftv8FRUhPRCG9uAvORE9ND
	ky+AQlvwxq4ckOrzHt+Nh+F/QivSHKxnlBvRBNxowGBjigX8+tafwI00pcxmtCDXV1LpzKDGJ7P
	i9DOUyAMAIOvAUXhJoNp4jAgsdMJ7WTytiUl3U3s98bNuEqFXoUOy31RnQ4T7G7ludO/7uCEXgf
	vSnq9r9bdsm9auaItVOmQLuvxnFMbJlJNDrdaGD5q7YlToPcfIiWASsezpr2EUkkYfSMrMNXgYS
	2mzYTu4oDb5UhI4hZQ8pn1HkXwoJugSUQ5Pxg5kK0m9XqrEz/luqfEU2u274DQaS+hpcuEqfx7/
	CAwxc0xLp0Q3yY6N3lv+ZbrQzCwQ=
X-Google-Smtp-Source: AGHT+IEQ2Law8vL1y7Vuz+VNuoQ/RSeFNfbn3pHNy90CB+MigBUyaVvg/Ws06nsyrs4igPZnHH5M9w==
X-Received: by 2002:a05:620a:268f:b0:7e3:37b6:bec8 with SMTP id af79cd13be357-7e814eebf69mr588609885a.33.1754497113784;
        Wed, 06 Aug 2025 09:18:33 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e7fa35144esm464081885a.48.2025.08.06.09.18.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 06 Aug 2025 09:18:33 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v2 0/3] mm, swap: improve cluster scan strategy
Date: Thu,  7 Aug 2025 00:17:45 +0800
Message-ID: <20250806161748.76651-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4B6A040006
X-Stat-Signature: 1jx54gdxmhmr6dnq51mxutwgp996wx5w
X-HE-Tag: 1754497115-346714
X-HE-Meta: U2FsdGVkX18OtfE4kaMrFVOYrTPPhSsu/MD7iUw6q3OqOzN7TlgkPMFUJbpBk59wQ5kPPw9RXYPT0DrbcgDv+Zng2n398xmzo7FJWpsidmg6KsBgVGUWIvR1FbTObIuxWxptch2ZngKHm7Q+vvoN/5hdIB8oqek3TzrDhinvah+tZVSFqpYsLR5pUPvQXQh7xt62namGocywenQNtB/WEDIFWGRUHt25hDfWpt7O8Qmyk6VFvC/0+aZO9lA0GJ/TxEaCAlTwLWANkKOI10pW8iMgiZ6frm5xCUBiw9n77o0y42NSktkTGB5nQzvOFpHdz/l3wqh1xjmNKqqu0iNton6x7ti4NFP2cyhXPIguCqhOaf+IaP41MaHcIo6zsNfw/bk3PEZ2OXwJyObXGvi2+yVG2jmOKJiXUCYJIelT50hS5ZqkFWb/0RKdpGahmoNm8GeFHtDzbxsJGvuQVeVISSw/PCtCC9aiHrtd0tQ7UtnVFVRrMQ0biTdxZT9sOvJjar1NA22CGhQfAtK3OScg8ugeK9WDpUtCxCdiubMUvuFceEFquKJ9DmFOSSlNLNkjM+SUpa6QGhqVLtzr41MoJlyICPIfo1Bc14eppUW4DmhwMUsqnCxWC6cXQbE1PSagiKJKW2W6Yglx+tOR9ywh9KBqirEcwwAh7EfMaTO4aWTu+rLlqVnkDLFP3aqT4QoN9Jbxf2sbyJaIT5obJ+D2uC9mTOfB4CCRCJ1sohe/1PmsRawcFIx/vdIGVMEHIc/0ip4HubakiqMWl09HTDqED/Zd2iCtLR2y3Ow/OBtqGOO0eaNQ4+DPFcvjOXVTEIxyCh2EYYG8hhIXzyiyf2c72OEDc95ubVMsHb2BfRubYS6R1qNz+HVkoXfK3H+owACJtiKjmTrH8rrdoDTy5+PZxp6/j7MdKAra1BNncg0LpcjaU5qYYY47TxZWUhQJ5Q0/q8U41o4hkccOcCBPbrT
 RBKv80Mb
 V9WtNKiv+dCMSMBOkf2adtfayBbKOqCPygJClnxY0mLbTgI55fV4/AvS4sE/wQVdKr/AomTnRd3aMz0fv49/XWPHgYpN0wlnM1LNMZAaNbM5HQXw7f+vEXu117p2RWr09FM18XWZoE4E0Qc6x16cPFsz0QbbYaGKUlJUG+cTHfpXcZHUceiDMPPLYwVT2Ycm3j8hvb7Fgo+bqDg6vee6yv7asW/TYFFfz47e0QXqiqiRze47sVONpRP5GOhbYdypl1Pm7BeKEvarPJC2ZIF5/B7lMCldNUOOd2KIiMX7LyA1aFa+m4DmZQpwm1uzr64bJadz9FZ+dxqPVng3cLiU1Oms05ELaG3FI5ZMDdCe64xwM+8KS1V+/xPtN8yQdrgl4ur44lrOWpMUANDJyIFmKdA4fJfg3VY9Dq2HAYKajC299zecQ/ZzonxHCRnPYxD/nlUNYD2rnorzob19+sQwXb6MEHEEH8ssemaJwbsNlU3DE7JNTke87GVoeFkYpAMLiSuwY3neSGic/uZl9n/uECVX/6R3SJEienfh/jxeoy43ez7Q/QSS4hN8S4vffD5tMh0ZnJvrzq42tswd5OIKJdnFjAcU2m/DgaShPNMTQv5ebrw0i4sh/xxJYZG6DxB5DlXY0zXnf/XC5PVWBmMzYmhZ+HA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

This series improves the large allocation performance and reduces
the failure rate. Some design of the cluster alloactor was later
found to be improvable after thorough testing.

The allocator spent too much effort scanning the fragment list, which
is not helpful in most setups, but causes serious contention of the
list lock (si->lock). Besides, the allocator prefers free clusters
when searching for a new cluster due to historical reasons, which
causes fragmentation issues.

So make the allocator only scan one cluster for high order allocation,
and prefer nonfull cluster. This both improves the performance and
reduces fragmentation.

For example, build kernel test with make -j96 and 10G ZRAM with 64kB
mTHP enabled shows better performance and a lower failure rate:

Before: sys time: 11609.69s  64kB/swpout: 1787051  64kB/swpout_fallback: 20917
After:  sys time: 5587.53s   64kB/swpout: 1811598  64kB/swpout_fallback: 0

System time is cut in half, and the failure rate drops to zero. Larger
allocations in a hybrid workload also showed a major improvement:

512kB swap failure rate:
Before: swpout:11663  swpout_fallback:1767
After:  swpout:14480  swpout_fallback:6

2M swap failure rate:
Before: swpout:24     swpout_fallback:1442
After:  swpout:1329   swpout_fallback:7

Kairui Song (3):
  mm, swap: only scan one cluster in fragment list
  mm, swap: remove fragment clusters counter
  mm, swap: prefer nonfull over free clusters

 include/linux/swap.h |  1 -
 mm/swapfile.c        | 68 +++++++++++++++++++++++---------------------
 2 files changed, 36 insertions(+), 33 deletions(-)

---

V1: https://lore.kernel.org/linux-mm/20250804172439.2331-1-ryncsn@gmail.com/
Changelog:
- Split into 3 patches, no code change [ Chris Li ]
- Rebase and rerun the test to see if removing the fragment cluster counter
  helps to improve the performance, as expected, it's marginal.
- Collect Ack/Review-by [ Nhat Pham, Chris Li ]

-- 
2.50.1


