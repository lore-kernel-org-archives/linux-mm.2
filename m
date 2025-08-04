Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08471C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 18:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B79D8E0005; Mon,  4 Aug 2025 14:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868778E0001; Mon,  4 Aug 2025 14:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E2C8E0005; Mon,  4 Aug 2025 14:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61F818E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:20:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E75F511570A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:20:16 +0000 (UTC)
X-FDA: 83739889632.02.323097E
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3AD88C0005
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:20:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="V2gjwRe/";
	spf=pass (imf28.hostedemail.com: domain of jyescas@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754331615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2ZVlhV6ndThCFd4+zGJNIWInZ4a60Ev1vYWmuIdzmJ4=;
	b=n7vxCDNCwPD1N++D05PHLTfC8pXWaDJztNwY6oDjWRYy5VALmb08b2jryRrswy3LwwAed7
	E5jrllsZBe6fkpYjhe9/aKl9qxFbSljYMX7HQI0Mujsmp9P/kDZuWkppOvfIm058pyf28S
	cacm8sEMIgQeocs3tIRyV+sXAE312fo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754331615; a=rsa-sha256;
	cv=none;
	b=fTX7Wto2fbgurBBkE15BOOFajFBBfgvlgaR6zAxYKsjwSqnXVS7Cw1nsE097/h3Jyaqo8J
	nIue1P5Icqnrafc32R77xiIJDBHwyGbYlOOcXiQ7B6YPkIi7BkpnZ8ASShfAU23lbHXFVJ
	r+JJEulJF0Kq1+4bYM5wTE6g+xfrf5U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="V2gjwRe/";
	spf=pass (imf28.hostedemail.com: domain of jyescas@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-240718d5920so27835ad.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 11:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754331614; x=1754936414; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2ZVlhV6ndThCFd4+zGJNIWInZ4a60Ev1vYWmuIdzmJ4=;
        b=V2gjwRe/LrI0sVWlp0rt00B56uPFWg0omP6KmW8wHy97ZbBxyNJ9q5n6CkWvrOQLow
         ZJzouZIdXyYAU47iHcqzEnC5KvNy2wLxNR3FBayrDerDe4wGsXTVdQLE4v/duI1cwS6z
         s1+fRhWM883aS6r35YzdE5XZ2Q2tX3MBLifWE98N5FttbkL31Ctcq2XsUOOCQERtqeod
         ve6mlELWKTIatBy95+6T26OSo0e87zjjiMTXukf1hvX41mVhj/2CsjfN0yyEzTjIw3Cz
         /4aMe31YKpuqPpDHDBnkr8v2/wP76/i764eZhJ5CeMHcluutsCcTEFW5BPZtXtWadALv
         nQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754331614; x=1754936414;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ZVlhV6ndThCFd4+zGJNIWInZ4a60Ev1vYWmuIdzmJ4=;
        b=tbLXv/eVKZnCVlerc2RJy1+aZz+IlVBOUfZs0XOeTJApQvCuW3GI/xOh/3JJSQ1HtG
         SzmEL7t7O4CG7MJxW/YxfpaMQz1TiiaJ39ozLoREVf1znpF3ZwClesDCZ9+l1X8ZNmNs
         U5Wvc1Pm/Sbl9pFXuMYbybQ0Uun+/7QQ6/NqxAcjqsQJh4Nf5GJf41sgncV3bX0qbrWg
         pA5HPXf1v7cfECRwUGllNt+TRpI9vlI0faLoGipyO90vk6xfZT4UyltyjrM6+p2OSTcX
         r9t1OfdxdAgIcpQp09naBAihHpFNKO0Z5EDPM71TiNANeB3o4B/pNDL4/pSSxqxXeo18
         CU9g==
X-Forwarded-Encrypted: i=1; AJvYcCXU7Gx5NnkvUimlIxFWHbsOdpup4Iys57tQMqHvYjA8+N0CETY4m1JONdpzcx5AOpdCEP4QmBfKsg==@kvack.org
X-Gm-Message-State: AOJu0Yz268I6ipb5meLvvVKd66H3YoqrYdv1cPXvdYUDIf0xvtz5DnGX
	0fiaewwHH2BEgP2yUi2L/F9RcI/CMAt2qPgBBY57vLq7i2hWzfDB0dXbCyhESm4onZ5p+r2UqpF
	xOL5tbl20mRZtmlg72uoJPr8x3xkCJH+hnST+tJUl
X-Gm-Gg: ASbGncse8AfnU7yr/qaDtVnykoGlFTTn1RD92c3sOHwqC+CSxAXvMt/BwRN/8avev61
	7Nvza/gjNq7SF0k7r01t8hBxoYgn65cDh19L/WNFCBogHuJRHG4gsrboTdImTyBt/9k/JPhKSBe
	d/zelHB14vrkwcCrQlb5dXGNTUdp2h5BWoEAyVfTKSn3MMZdauCTd5dZbvhFK2waZHg4BL2yUqr
	tGoneErWgcC/qNrBdIWILXV58YP8aEbdhWGZomhcB9RuBfWPYs=
X-Google-Smtp-Source: AGHT+IHJ3G+xP08obdX5jcc6GtOvxbQiCdbE6cUflcwsxBlSF4DjeWJy9y+0NJsLPYUHbsN86ka8wS8EBaMWAaxaFo4=
X-Received: by 2002:a17:902:f606:b0:231:ddc9:7b82 with SMTP id
 d9443c01a7336-24289f4137fmr145425ad.13.1754331613677; Mon, 04 Aug 2025
 11:20:13 -0700 (PDT)
MIME-Version: 1.0
From: Juan Yescas <jyescas@google.com>
Date: Mon, 4 Aug 2025 11:20:00 -0700
X-Gm-Features: Ac12FXzbGKN5jlyd2IPApq6ZL8_tui4fcRP6MtCL-WgGFvEuHfb0FzO73d8vRXE
Message-ID: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: David Hildenbrand <david@redhat.com>
Cc: akash.tyagi@mediatek.com, Andrew Morton <akpm@linux-foundation.org>, 
	angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org, 
	Brendan Jackman <jackmanb@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, wsd_upstream@mediatek.com, 
	Zi Yan <ziy@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	Juan Yescas <jyescas@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3AD88C0005
X-Stat-Signature: 7kn4ypwrcxnp3kjkcksexjq5ikz6g3ka
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754331615-647765
X-HE-Meta: U2FsdGVkX1+PU+cu+EaEBARkwOeMw5O/jvdZzYoqM7AlcYI4FPYWouWCbzvQWvlwZIwsgZMh+bZFejy4pcwVZdyRUwDFOIEkqUZuurRJhs843bKSfXT+DLxYvVJE5u6F3iMSSEtYEaj/w0HCfSPxwOecXv6447SobCCK0Uek8eYgALkFuYKUjZtHImIFA5q3EyLf3uor3hPAmlxDAiKpdGi6at3YgleTE4sGAFW6vDyxbl5/yOmB3H0hObEcUh4HjWnQFT0MTtc1R5Ba3qS3AuhDs2atId2I8VLp++t4HfRp/9oTQdfh6jNoaRmcSgviLuw8APnjY85zVmCnIP9ycxp1CWrMlYp+0c3DhVcTjSdGpXap+bTX/hmR9EKcL8F2GfxnoOFETjlUiVYq9SoruYi/hcR2z74IEvA8xQFo22OFXoxJGeXFnLFQr3A6BqCfMu8tYvUMZ/Pvh82+LKoqgRsBzdJvJ5siWp/mGrXryDBuWFA9Q1tPl+KBtvZEE3cYa8PLNYjt4EsDreBEJFVq4ZxjEfCrTPLdT1M7IRqII9xhci+qNYhdtGyLvSBvb2OMb8bVrwmjeWs0QdwXw3V2s8sq+Mo/XXHdIQmRgzRAKRiux0mjxQXyRy3d7iR7kiBIqClCew2o3Iotg8QuFRVmgQ8YVLFWPjrgwYmqfZ4t5w17ZfGze1Ho5+k4vdcGda9tbFLOOf7DDe3ZwZLEiTlIR56lqIcGmaOhJLRV2+8NW7E6+SQa+nASSTdIhTheHTy/kJLWYG1Y5csRSxabQn00Ly1UU8U+fVONyLKHvff6X1N/fr4h0mHYtNRx81A+Jz1u3m2onjPkFDzqccWti1iqcVG68kVZEvwcf5Psb9J/GEfFSPJpGY60vKFVF+5B/uhDaHuLRme/I8jHa8UCeqGHWZzyPJiwETITwPOtMw/jc+vzJH8FjDLASK5oTjkjaVYngbQ4FT+T4CYKbHh+TLX
 VBzRDgRL
 ILEhuePtfgfZxLM9JPmY8GSrjXPs44Y4AXr5stR0pC307/yHirEZ8TfLaaquq9/sJaBBWLhFuJHPvxRH0GioNYvUkRM6LfpTFMKR/dTQa5QAfNAB0tJi3OYsazaDNeYgnBk+c2WW4kEXpontaDgsCtlj02bbfniwVYbwMnwRHBNQvAlvrG4FQefDwhwAxPiPVDYwNBICH34MDLeTOHfDUSyHMuHhHLSMq9NQYg1VL8mrJ3nW0CALrk/Ll2oAusRar/jcNMLJgJkgK5dp3tR3OCZiAn/BVTvWvyjmajCkk8dVEDWbV4yTyOBJM/dMuybb6M4p5LpiCr0VafsZpAq2LmmzaYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David/Zi,

Is there any reason why the MIGRATE_CMA pages are not in the PCP lists?

There are many devices that need fast allocation of MIGRATE_CMA pages,
and they have to get them from the buddy allocator, which is a bit
slower in comparison to the PCP lists.

We also have cases where the MIGRATE_CMA memory requirements are big.
For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 500MiBs.
These cases would benefit if we have THPs for CMAs.

Could we add the support for MIGRATE_CMA pages on the PCP and THP lists?

Thanks

