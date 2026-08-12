Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E46C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67F76B00FB; Wed, 12 Aug 2026 06:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19EA6B00FD; Wed, 12 Aug 2026 06:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D074F6B00FE; Wed, 12 Aug 2026 06:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A57DA6B00FB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:04:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 354184024A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:04:45 +0000 (UTC)
X-FDA: 85092183330.05.DE4CFCD
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7A83A20007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:04:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TYwuKJ18;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786529083;
	b=Uuu4RcR4f/fmDjk/mGZ3LxnGmCClBZq2wQRBGJBMSPu8/aAyF4R0HP0k7SjGSxiUKbhFAz
	pdMiMABurTK2fEtKWZmQP68Nx2LebKAZJYG1lQIYVSvjbtzhtcdPIGPUIFWss2rmBTe/du
	ikcC22h+eIFWJFbjadhshNB8FF2obhg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TYwuKJ18;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786529083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w1Amz75UuSYEUv3v4aAO3alBAyuVKiTqpSzrEm2VkvA=;
	b=W1TX74tJYPnS10spjKC/hh+ZVc5klTL4ct6WxMdvbrgMPn2+NoNE52nkSaTdIFfKtbq6fR
	VmVxMhE7d2yYqMsHcwjwZlZN7Y4plsENp9aEbpmvr8+fhzMgoeUd7s0ccPbiYnTTO5H8iX
	QCrKIYzGMJTKQeR1AZ/nuy1e3A9/Xs8=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cbedf433a99so677071a12.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786529082; x=1787133882; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w1Amz75UuSYEUv3v4aAO3alBAyuVKiTqpSzrEm2VkvA=;
        b=TYwuKJ18EWo8MSukXoF10XBwnrOtim5OMuIhGONUp+gMGFYo2B+RNTldBSDrS1tSdD
         IYpq5bH0pJuo6Lkup0A0zVM7/5E0Yt5wAnTZ+8p5NOnkMQsS9LuYLtE/dzYbVvBV6c5y
         ekTpqjXv2pxfEGWuKWKISJwHcWcqX0vbiYnU3vFcPaYMr5E4NDCaJx6lilALZ7+TUWdZ
         7N3LLHydd24TGLCp6Y9MStFhM1OezaXzFzz6XGHlALUAUyPIPyjAS2aXznCXKF+HQbJW
         1lgiIqUbd/ckGxv9ETXBetOo8VinpxtdIUg8om3Vijz0kIVWeF9mmYmBZB/sN58m5oMZ
         +nQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786529082; x=1787133882;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w1Amz75UuSYEUv3v4aAO3alBAyuVKiTqpSzrEm2VkvA=;
        b=cr9Pl2s7+dw1VaZuZFVaUXkpdHAuMpkSheT6QQ509EyKKEzQ653VzqUA2EJyUzDiz0
         K3IK4wRl16QlCal9iPXjF9O4e10Ra7TkSKKp3mUjzG+K10u7RIiKQadsdzcnIqikk35v
         2Lot5sYJDbUUkG6YiNlr6x2s9pxukSaQHkwPnTKiIQAG1e06t0lEa/3t5erVlGGHIoNI
         47J4brk4fym/ZFoQzwjzSClBv62z0kHDMwFR4HzCcHk4q0MewLpTg85Od9/WscmGTWU6
         wzG4Nq48c7qqZjj5NZZhVqrCFsh72D9T046ZRa5poDkNiSFxvaj+9LwgidY3BpFKg869
         V/6g==
X-Forwarded-Encrypted: i=1; AHgh+RqDwQO4gZr+FNYm8q2OsaZVwB8ReWCxw8z4KfDZeNQsZhKj/HMDKciKAove5eAeXMJApUD8h/+zMA==@kvack.org
X-Gm-Message-State: AOJu0YzErOFzTIew0pBk3dtkq8H2a99N1T5sZTxqI7ioQPBmKPujgzoA
	WV3VKvFvkqjqWMzH1FfprFpx2TXZOx6jruUYbBMGwyQRgTaosX9Lymdx
X-Gm-Gg: AR+sD133EkwzOPMHJPK/4NOYr9ZjsR9CAu/msYsr6UZ8m3W9WFZ+bmO2XkqT+MXe/y0
	28NNxGH4hLOyLtstUJXzu6khnihzxsVRd6GZDt9PZLWkaEYM9lEcRUnKzowqmMe/VkBYUmixLic
	2pwjzxfoU+UBBjEqPrV/pmmLQsNoPfvXSSWXScrDhslig05hCAyDFwAB2XK0zym4mbxOGWH6QNn
	1DHn4GxmpD6/Dk1oHyQCJcKXNMnuPd2W84vAGsYrtjMTA116bdz/xk+tiSOee8u3wXhsZF+zHqQ
	wWyyJVyZgynTOzqr82b8adoFBALsOMaTJD2L+nVLQyXyzIr14gdKs/D8UcduyI12aH2JCrkFvuf
	6T4iO1eFoCPilKuDmZcnh2zuBWWfdlnzVJnollJoq11LXA7NHu9lwedNZxfyKSvn6SJP/f/BCj2
	70IG2qJiFXPbXchvLATi+GrsORpbT7NfbD7nQqcxMyM3pS0hhAYz8fltWRXo+NZqs+67XgM2j8i
	HY4lnA6vIrOaU4cLtkl3PoWAA==
X-Received: by 2002:a05:6a21:9104:b0:3c3:859b:9178 with SMTP id adf61e73a8af0-3cc3f7fecf9mr4939767637.34.1786529082230;
        Wed, 12 Aug 2026 03:04:42 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14124454d3csm8821247c88.2.2026.08.12.03.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:04:41 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 0/3] docs/mm/damon/design: add explanation of nr_snapshots
Date: Wed, 12 Aug 2026 18:04:30 +0800
Message-ID: <20260812100433.6288-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A83A20007
X-Rspam-User: 
X-Stat-Signature: wjq75r1sgzhw6817ins9i1zmpzfohfp7
X-Rspamd-Server: rspam06
X-HE-Tag: 1786529083-92540
X-HE-Meta: U2FsdGVkX18Auk471HzChWKibWDSPwFfyKkIXqURVWFCmC1JR2DgI6vKVE276cEYG+9ItXzl/4S9d9bvRFp8ncXo3LT3s4dROOV3MW1ktjpCbTXiJV1R5ooiaDSDmsfc9vV6OgQnIQ2VAOVYeHG0298qd1pZqDpEdNacuDG6hbODmrELxbvvCwOJp240Oq8UgllchVNS9Zqhb7D2VNWTss+aYaqZDI7lu5FYj7+s7Ls3g0fUjV4UOzZLVT8KgzrBGB8DdwtM+bgwIpJyDpc1o1tB13Q2d4WWOfZFaZEWabNLE/v97ttHvaVv6CUZ5TH50dYjL7gKJcXt7FstgfaAeu5l8UApaVJFx5MXgJCJsPwyPyrxWnUStK2auswOyG2n0fwYr+0GSr2jG3qzV3zjpDmbT9Z8v4b0ZMLcWg7N2dx70fPlarnOURaurHwBzC39WYUVXzxg4BZQhfgh5XSSqIFqNjNRYAO4qb6H+UdCkiwakMsvTc0ZtPa4Liy7yJRuEYN8ifiGTUn4531ThV/9z/1pX+53GSB9BumZCnyhZr46jCOlIhlGyH5c+0k5JInFdMLNC/IFut6yqQpP0ucltWfxfCP5p8Nqfdkgj9pi4o9rtc6IT9p7pMNqt/OOxE+HtFDVWHGwamnK2zxuBqYXcb8B/yRfDXgma943keKMWDv20rXeS69opGrdctF3uZnkBt+5DCZRNk1WQUuoMviZbxtozAspxzb0OliUjmxL130Ha8yKwZC9afmqVurtHh8e0z0B2TRQdQD36U7ImEDAiYksPDMSM7zDwgubwXoOU80aL09MHh5vh9mqCNlpa685TeaNKHUrkw34RU0XOxnilLqn7/nPP5RN4mVldyQOIGmIBDuoe7A+oSDQ+Mw3d2tX0cMDkpMRY81oglXUuftoFTwk6PJ5jj+PU7rGckdqq3MCabMlzgogQBRs43WcA3zpd1f7P5pgLkOfTUSYbMP
 eVtv/xAU
 UtR1jb4r/OqCARZWuRyCwLzAfbs20Qk5fbfzivyz5UYngiB5tz20dRReg5S2u5iE8W7V2xdCLZU9391EjBJl42Z31DrWHfiPZpE5Ds0so+lFLLC3YKHqrBa6m7dewvEc+VHrrULl0cR93emXXi0Nwy99HWFnrWTb8Rxz8o4Zk8vWhBQnMz0/XCPU6Lgq73X2ms6SB1K0hXRKx1Vmbv0csFulWMpQwvVGCraUnW3NmWlad1H4ob45V+WImQCl0FCYRxD049vsR6jJ7a1L/xEUdOZrNObvHFE38kPVuuktv/HKF+v18HgZq93ZjI0RL4axaGgJnZuFmwYPai6AEWJvytCZd9W2tG5qwc1uLJzNTwLPixcdreyg6EwicKBueX/VQbHzIPEEacXEDzQNKkCAL4+0bOzGi/7zBOxRBNYQ5PvoKBOEa8QIQn7ts60EFumMNzURdmXRjAB5vc2YGqgfOArYaye4z+MMIgNklS4pHhbSbuhy84rf7SmZJLWyRL3GBb4S3sEaA6nm+bJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an explanation of nr_snapshots to avoid misunderstandings.

Changes from v1:
- v1: https://lore.kernel.org/damon/20260811101841.804596-1-aethernet65535@gmail.com
- Patch 1 word order adjustment: Repositioned "completely" ("tried to be
  completely applied" -> "completely tried to be applied").
- Patch 2: Use two spaces between sentences.
- Patch 3: Add the "Reviewed-by:" of SJ, because he added this in v1.

Liew Rui Yan (3):
  docs/mm/damon/design: accurate semantics of nr_snapshots
  docs/mm/damon/design: difference between watermarks and nr_snapshots
  docs/mm/damon/design: fix typo of max_nr_snapshots

 Documentation/mm/damon/design.rst | 7 ++++---
 include/linux/damon.h             | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.55.0


