Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68B7AC44527
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D38F6B00C8; Mon, 20 Jul 2026 05:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AADA6B00CE; Mon, 20 Jul 2026 05:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4738D6B00D0; Mon, 20 Jul 2026 05:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABE46B00C8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:43:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1B521C0884
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:43:52 +0000 (UTC)
X-FDA: 85008668304.13.0238F95
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id D2BFD180002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:43:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m5+uKxnt;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540630;
	b=pfGlVGvISuIC+F7zbManxwZGGEE1KKDXwL4EKrMVr46uI60I29l0ZkfIDctyz1ufiiZIJy
	IYZTPcAmEG+fp/0r0q94vY3zBc4py8OSk8K+2GaGLXUuFOxmjbkpTYXAGg8OU4WM4wMmGH
	AaCwZigZp7R8o7rUWux419UqobppxGE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m5+uKxnt;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kAmuH3TrSH/JKaELSX3UxD4gJHLMVKkSvtSAo6OO6Tg=;
	b=o0QcB7nvwsyVrkk/P4bTzATGIuGsDk60e4WlzCDFvRwILyizxJCkSXgAt3U4lnyG1mfmQ5
	U1JYlo0t7Wvfewgwwu8YTCha2+wd3VW48EsRKQ/CYG1+pKsPJYsxb5v0nY87WbqPEtC1Kn
	CZQytjVWgPvPbt4u2vtOXBXEdj8mC8k=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8485b358552so10626364b3a.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784540630; x=1785145430; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kAmuH3TrSH/JKaELSX3UxD4gJHLMVKkSvtSAo6OO6Tg=;
        b=m5+uKxntMmyeaLn6GQXzOq+Fgk47nixeKwRraMds2Ec7E1treMe5hviLYXcDLpky+5
         zhPkAg6ZTaJivpL/azhTKTQt9xPofuaRxz8Jyf7BvOZqA+gkCQki/L3YyiNoKzIojUmD
         a3wTMTN2BwTHmrSIlJA84UELscWMDAqBY2trKm/KE79yPI9BLN31p1+SYCPkUR+qwG3d
         AXaIS6sbwGjy/5DExi6ZdSQJ/a81HWvBL+o6OejnDc96bvmwxJHpFKPZXV2XSzd6D+Qm
         +VwHKURO7PIrpfkh0C40zkOPbiCQWut98507/WZ6FGhpz1+KDQDLWaNKZ+b4w41SqVM/
         WIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784540630; x=1785145430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kAmuH3TrSH/JKaELSX3UxD4gJHLMVKkSvtSAo6OO6Tg=;
        b=mB0xSR8fF2uJdFtsPDrftHXwQWGsc7nJXXSrtllSjXs4i8sGeoAPz0UMmytzTADrdM
         JJ5CmbULUPrfhNHWt8ga4CiNdbVXYsCETEPHraNvoGNwDPspXpSzEBOTOESTS3OQtufZ
         eTHP+Sg1kSbpewvP2SBwcp1L7FO38st8QlvdTgyh/YE/p/XaidgkXrdeC+eGrttBiesj
         rCBVyClOF1wed+Y5nDeVp6xsUGK7v3PI2Ph4Htqtfhiehgi6Py+9SMQm20yLY9eNbURq
         3J95zLAH3/JHePymcjnlCoLr6flZ4xtB/eqIRrN6Q6tI7u0VEmLif0EsK41HvFST9quf
         esag==
X-Forwarded-Encrypted: i=1; AHgh+RpatXAn7ksl77aUDz8x2DHJdEUBH3/4rDuce1SlBvtXYAx6Li7ASMEpFtCm2kJ8tIXqc3ZuxADBTA==@kvack.org
X-Gm-Message-State: AOJu0YwtllFdm79FDBJYbPAxmPzUKxO0jQ5XPEs7YTkdCfM+NwOkxhb0
	orzSC+3LNcgD+F9f3f05P20grLhKRBmiD6qJRIiMfvZ3lajnU/N0aPB4
X-Gm-Gg: AfdE7cn7oR9DvP9rBGaFob4DvhwLb4HGlXomA9zyhiA1TwacYTM9yORFcg7+Wv7v6iR
	wK19waKRYju8jkQTxbOkp/vSdb27dME+41110p2u7uABifD3OOj4ew2LLDOZ5WUXVW1s8DC53zp
	rIKpS10TkeSfi4GPtcN0RZBkhWbjqbQRYLat1I5T9eGGrKLLe81lHn8d42o37t7AiD1qb0//OIa
	ZjhNn9wW0Ynl5MCfMpCD8AF/5yErPq38FLKxl7PJfdcPjXdvcuXH/hyraZrLFahcfdIRMaNTZRo
	KSwFApi3a95AaYCyNwae/bIXYbR8wjFHVDqlW4HdN6SS4MMtG9g1wma6QE5Pfdpf9tKvLxPhcW7
	04uaT0EvqRGzzi2pXv2/za32oSi6ty+os0pMwn6PIbkLNT7Yxw8UfEPbDZBDB1YjZGQJ3mOBBdC
	BEiey2ZQ9cxfYPHAhyppucpRHXuVU=
X-Received: by 2002:a05:6a00:2ea4:b0:848:5010:ad39 with SMTP id d2e1a72fcca58-84c2948a214mr13304609b3a.46.1784540629544;
        Mon, 20 Jul 2026 02:43:49 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2ad89d0csm5369285b3a.6.2026.07.20.02.43.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Jul 2026 02:43:49 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: gutierrez.asier@huawei-partners.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	daichaobing@sangfor.com.cn,
	wangkefeng.wang@huawei.com,
	zengheng4@huawei.com,
	kasong@tencent.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	lianux.mm@gmail.com,
	lianux.wang@processmission.com,
	kunwu.chan@linux.dev
Subject: Re: [RFC PATCH v3 0/3] mm/damon: introduce DAMOS_SPLIT action
Date: Mon, 20 Jul 2026 17:43:40 +0800
Message-ID: <20260720094340.31733-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <a168a9f2-953b-4ecb-98ee-ec6b27f4d963@huawei-partners.com>
References: <a168a9f2-953b-4ecb-98ee-ec6b27f4d963@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2BFD180002
X-Stat-Signature: 357s3fdez7sx3tje8tunk1fnp4h3nhwh
X-HE-Tag: 1784540630-620562
X-HE-Meta: U2FsdGVkX1+Em7+F90HURjoAcYieGaaGZDJ2bA+0Qq7MIsQOSJTjgZlvONFcLLQ6wSRbBlqyi29IFsPFcdUOCfvCZpq0LiLdajR0OabiPdCAy6NslNPl4++Fu5ygGPveftR3Dz3iZ/kfLhpGFyaUU2GG8qNcUHZpk3S/ELfqGsmgxFKV6Gan9N8Ouq0M8bitse5aEaG/41avNcrn0AI/2As1e/XBi/E7AD5kQy5CqgRvAZv41WF4fR23GOK5jGBsKFOfZHSzNAbBD+coy6LL4y0F5pmusBuVlFuEu3KiJ/1Hc5pr8Bkg3sFpvzbhiFkr6i+5/Z41xocx/K+6T91BHprV1M7l3wR9li0GMdrlnQPSKXDSW9KqOSZt7ZVH/unH76uPwrEVU1/+PGsg04tYed3mH4SclsOgglSme1i9KevjTVYAEoAgracLI4BySsDfrAev0/oVx2rkF0n+1Czvcerb4VGAbB0db73EEMKlm1FLf1mYMxQZ0l9ttMsLjpTgJdE3GejkGyLrVtAsqPQH401Pa/oIjJdcDDkELwFyqU433h5oUt80Jiw8W99MDYI2Gb6F8yg0ziXvJYBUQARGcJaN4ySpn5Q/lnpsjAGUXnJ8l+tjOURpVmtkQR18+CD2JYip5j37sF+94v+6AO9J5tLqKBEp4V70t216zRUkIDCbeni8IxXhIVm5EOtLq1Hw9qWwVFOXfGkSC7HZTCFdfeHWjj9o3SFjvbJfbqab09MXsmwneYNrAIJqdyYoJTqXX5p2zIjCHAnAlurogAbLhOBH37YCcqjR8E8EIi0E5SgT64F4eT7GWz5IToujogk7Gzo/OO/SwwucCNBsV3sNj+rYw32KDdVpr8omPad+ZJonygs4M3OnUYsH+KABLPIL3iYaJn5M6wchI20pI/r5sGgvOE+2+j420S2ytd75fSNrOT7HBIKHhMfgtGChSD6IYnqnqmH0VtuSl/2riNZ
 +Qxqt5Be
 CANLazGHH4DsbrV9qK44NiwMpNrPIU5/p9znqPdCci5tf7v9eBG4IqFpwd9E6didexd9wZeDEewwelraeUJ53NeZeT/i9VmaXCV3Tx//TAR4Le9AD38rnepOZwG/jIZexwTtQ/RJhilwIjueGP+ssgzCfwTayWox6CejrbJZx6W6u86eRqeH0zWYCdMJlcmCLQrmB78CrKJSIQsSm3ujIeNmSKus+FBVswqvglxbaJ+XcEG7m4Eva+lG6NkUnt8uQZREnH2SVMC/bAtoql9dk66MdVLv6ypMHvxDs6a4/+sOblTeOiiEUW8etdGrEmN+i2gTU98mL3yM0NrPaRplpNVf91ZzaO7sY4/dAmfSw2pW3zAxBvQTS1A/iYAk3MRRiM/k8UHi/y7/zh/2ccQnupqWpJzYSfyUEmU1I6Eh15SyaJOq/THaNusjzGtTZSWMQgNfgCtyQN3GpngswQ5H+YomAX4TkZvV0bLE8C8QoqBzYijZ4gyfbeBuaxBUV9fgnoEytZTCAwSUrbNs9ajABW68oawsYejByTXAG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Asier,

Thanks for the quick feedback.

On 7/20/2026 12:28 PM, Gutierrez Asier wrote:
> You should mention why page split is be needed. The fact that page
> collapsing exist doesn't necessarily mean that split should exist.

Fair point.  The underlying problem I'm trying to address is that
DAMON's vaddr monitoring loses accuracy under PMD-mapped THP:
multiple sampled addresses share a single Accessed bit, so the
observed hot set is coarser than the true working set.  Split is one
way to restore fine-grain monitoring -- by dismantling the PMD
mapping, each base page gets its own PTE Accessed bit and DAMON can
see the real access distribution again.

Split is not the only possible approach, and it is certainly not
intended to be "the opposite of collapse".  It is just one concrete
proposal to start the discussion.  What I really care about is
whether the community agrees that this monitoring granularity problem
is worth solving.  If there are better ways to address it, I'm very
open to that direction.

The RFC is as much about the problem as it is about the mechanism.
Feedback on real workloads that suffer from this coarsening, and on
alternative approaches, is exactly what I'm hoping for.

> Could you add v1 as well?

Good catch, will add in the next revision.

[1] https://lore.kernel.org/20260620203915.82947-1-sj@kernel.org/

Thanks,
Lian Wang

