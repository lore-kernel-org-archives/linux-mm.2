Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FA4606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=rb7TBDLe
Received: by kanga.kvack.org (Postfix)
	id B4D9A6B05B0; Fri,  6 Nov 2026 17:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE746B05B7; Fri,  6 Nov 2026 17:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED116B05B8; Fri,  6 Nov 2026 17:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C14F6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:07:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4F1A160235
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:07:31 +0000 (UTC)
X-FDA: 85406081502.07.469BC63
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC61DC0004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:07:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=rb7TBDLe;
	spf=pass (imf28.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mN7K5Prc5wWoa2lY0PF8BjYfBWGH+sxODSpxNzbIWhI=;
	b=nyHNqQRVFDw/db6oTgdxjNk49uznhHXcsmcopCbRkk2ZwWnjLgD5p3M5aVUwDgI1bHrakM
	BgSO2IwHaPnNOJmVOf3Osu3FnPBKqsbM8ErVRhQijhBV3uPtTi62UDZ7Zi+lVkGcP6pjnm
	mDddag8p7h0jPCGqvRc6h8HsCY/0Wzs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002850;
	b=KP2iegzZsFuq8JhrT4rlTCUXbvNfinaIdLpxjuyahA66Nq5F1p3tZ1DFiZl+4+XXKO972v
	CGtValjcBHhjsvLg5OUZViBBtqW+CZD+vifc/2eD/uDz3toXm7dIV79gZVYPmF92uJLn9z
	sueMkTtxyG9PPgBH5GZIuaG+st14QEk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=rb7TBDLe;
	spf=pass (imf28.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002849; x=1825538849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mN7K5Prc5wWoa2lY0PF8BjYfBWGH+sxODSpxNzbIWhI=;
  b=rb7TBDLe6LJYZJQWfoCxmEvsKyRN5py6neRvPmn/MTMJuTg6bUFaEP3x
   HOmiuPkrvM/Ce0OZl/vLBQBnzz09mFrfMh+oSKf/RennTrV2Py6TKs+PS
   8iMIvjj0dFrtnQCWfxHyw4C7PSJOQlTiVDSit3P7mYAOFUKkFR1oKzWDl
   pjlLu9qXrJZNNZINHK4gQOOUbbYMFQ8iy7y2bw+95tXLfOEx+vPR3wEx5
   Oi/lHNigKkvMHuoMf9Eoi1mQtPZMUui0YdIiRlqoSkP20S1CtoX4m5s1p
   Do+InNeu5ah+O4nazyQiPMLtRMKopZvLTqqoERgVy0kOoNVRR46xqlEqG
   w==;
X-CSE-ConnectionGUID: usc/bu4uT7erD7RmTOQhhQ==
X-CSE-MsgGUID: 4zRfsaKcQN2Iyt11fIdwKA==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33359475"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:07:28 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:16837]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.238:2525] with esmtp (Farcaster)
 id 8848600a-6d00-4643-8068-229fe4efb9ea; Fri, 6 Nov 2026 22:07:28 +0000 (UTC)
X-Farcaster-Flow-ID: 8848600a-6d00-4643-8068-229fe4efb9ea
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:07:27 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:07:27 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, "Mark
 Bundschuh" <mkbund@amazon.com>
Subject: [PATCH v2 6.1 0/2] mm: replace free hugepage folios after migration
Date: Fri, 6 Nov 2026 22:07:13 +0000
Message-ID: <20261106220715.2869940-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261105070346.3099207-1-mkbund@amazon.com>
References: <20261105070346.3099207-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: oyfd5mhqxg3u65ymr8jhzgegej96pwy3
X-Rspamd-Queue-Id: BC61DC0004
X-Rspam-User: 
X-HE-Tag: 1794002849-972969
X-HE-Meta: U2FsdGVkX18Q09DwMU4CMaAd81x9A99czF+WE4mu65kn8ftJoXOOSvvFB5Hb1YMvCkQDlSuRDGHWObbY3Vu9eRJaEuqJa1eM4gX15XksBRgZVlut4ul/8XO88DzBzhWmhJxG2rb+Hnf+T08f24lppAA7fW0/V7yZjG3apohFevQyae5n+yebX0AacFWTL7aVihRLPvZ5cyfPR/+h7lIPgLtIki4QbcIZAlc+zoqIClpsJtjzcOQfqU4KhJfYvGoBowBCx/E0Pzba9VJCnZ8dUrAwSYL3uqvxylfr7uqK3hD8sr/lAvXBw1ZT2ajzLok//u7rUG3or7i/UWcSlEyWjqGMcaQ6i+TVzGpqitJb50tdM2eJD/g+lyRPX9u8coOgrc8SFImqEDWw3+IFFbZp7PwyycQaDW4uroUo+A2k5rAh2YnyOAdf3dF2WKWpq6G9FGyCV6ki+ZOzwlTfFXo4wLewiJ5PNxKFKTJYbHstjr+IE26SuvAfrR4StKic8zNdEamlBEPlUd4lBIz6f3VAdkZtv2p8NfhxSzzyqD8M20HiSH7aOXNY5kWIJeRE0E7TMzh1XxpLgpxN7LKO3k9lsTJQ1zws37hXMIq6VxomnZ+S9jhtO5wl4ijnHdr59qecHlz9DSxzesUAFrgLRN+hDjN8deY7JXatkrHNcdDZFy/Qd6HYj3U00TsTuIyEI5avr5P85SYeWMTy15S3ApRw/2Dx3OJfZZDEvCqwaL1GPMgnzEvin6liIJYWtWcMtviyaEOglHbokhUkQfHpIszzzC7iHkGLUEZpwXNks3+8ykh0fKKM2qrfjTwpopXdYig+bwq566Tz8A86qOuXbhIhGvsSZHLlUveZHBTent8g9ut/NCpHZp4TtCUUlAimv9QJhXNte9TXslcq8m3DaMYzRCstysgCHpqC7bST8aZmfmZqL0i8pJqOCkoxosi8PJVsTVFWkN3d9Sor3hBm99a
 ybmtRk+k
 8ocqqeZG8dV7GM6Q4BE9HqHKJRzxAG5MVa4NL6tpsfyNgbiVynkPhtgukFYinDy2tWpyp7EMxUo7gd26ibh3Cl2dhp5i52x/vhSsOqJ3bzaQX068X5k9o3+pw5glJv96t8y/MGfcUPBxDpRxj4ET7cQM0BhJ9vfFbX8KRiXF+/Y5ZaVPtI3AHs2hSjJPk9JUmZr5m+FkVt+sm3IsUqiLmU7x9PjibyGY0UerixhMaP2LIaUBHXn7ibfcR/9HxdZJ2KHq3SESVDYevNOKYm3adVH2TwJlxNbw1N/7f9A7/grbO41n6E0f0XUuZTqPsKHcVl9xlehBkeBL0PdB5xntiyjfPmEkNpFX7Q14Gi69eO367BoQXaJmS4DNFyk79N0UPewPxAc5BuY3HtQCHaSfUE3j02JDGQOMx3a9wrPfLZC2fC6QNes98/9RKksZLj948fQ4VUjHqspuiN2yQdrI2/36dNmeRJYLfmdLdqyPFzx5tTamGJKHh2P7YAIApGzgHVul9z4Hcx6DpjH+rqJV481QKT8/M/sx8qkqLE5svsDj96L0Gf3rxJlRbcHrVyoPnRajEHOifosEZ5YTq2yv3PNTV0pLa8cUbnYuGMqGX4yPIGIONr62yumrRHwQBXOdF8Z52L6FZHf+AWo3u/0goGUk6Wljz0GPylYaa2dH440ahMmzbm65elYM91IxFpqL/Yap7Dkd+EdnNxGYEY6NnDrx2Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Full backport of 04f13d241b8b ("mm: replace free hugepage folios after
migration") with its fix 113ed54ad276.

Tested in a VM on 6.1.191: memory offline of a block with mapped huge
pages no longer livelocks, and cma_alloc() over mapped huge pages now
succeeds (it failed on 6.1.191 and with v1).

v1: https://lore.kernel.org/all/20261105070346.3099207-1-mkbund@amazon.com/

Ge Yang (1):
  mm/hugetlb: fix kernel NULL pointer dereference when replacing free
    hugetlb folios

yangge (1):
  mm: replace free hugepage folios after migration

 include/linux/hugetlb.h |  7 ++++++
 mm/hugetlb.c            | 50 +++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         | 12 +++++++++-
 3 files changed, 68 insertions(+), 1 deletion(-)

-- 
2.50.1


