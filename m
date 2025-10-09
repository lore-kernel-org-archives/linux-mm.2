Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A1FCCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF108E00AE; Thu,  9 Oct 2025 15:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6208E0002; Thu,  9 Oct 2025 15:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4098E00AE; Thu,  9 Oct 2025 15:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2288E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:29:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EA2613BF77
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:29:38 +0000 (UTC)
X-FDA: 83979565236.30.2DFB14F
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9E7D51C0016
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:29:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OYE0pIAq;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760038176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a4JVrDAekAXuIrNrwEZUDzZE6GN5LqvSaIQ8Jq5w7+s=;
	b=mgSpvNcWvLFvikOHBBd7/7UgkSSTeNNssl5pgePEuJ+BvBVoEWi9rI/txnLBVF0H5SQ71f
	4dzlr/6kshYR+1BX8LQLAH7cmTJFbEosYOPxTOu0SZ/LA/Imv+6jxiTPZDncyevUzRpZnZ
	RSrPAltZOgCjkjVxFw1JyAHUHKws+fA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OYE0pIAq;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760038176; a=rsa-sha256;
	cv=none;
	b=7uLwBSyjyc8u6/Ii1gaqNKIYNWK3OmPUjdL3W9hFRPUSEuEXCoqbsmPKPD0wr1lxyzRxAB
	62ibRyeDiUbBO1JuPAaI2p2ekUWcBYeLx6V4C8QoQnSygUtuHW+n9x7OS7tJ+fkYpi5bWc
	bffr0iLhl9LSpDINfLknAryK4pE52IU=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d71bcab6fso12583647b3.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760038175; x=1760642975; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a4JVrDAekAXuIrNrwEZUDzZE6GN5LqvSaIQ8Jq5w7+s=;
        b=OYE0pIAqf7Xhfh5R16pEYEmRmR+I5TFshIHlkxMY6r1r7dFSOLYQTFsMnU+LKy1/oj
         dg6bNQsihUCsDwzy9m783oPiT8xVgpN6e8AZENZGi4Hg1wWWzVzXNaMFdbIjR+GcocSX
         hDnDvG/A1iy/M6YfsWMtVjDAaFVQTTrMYFSYMd54elFgq9ZnngkcXZBBAh8TZR7Dcffi
         2KnZLrz4OSqJbdRdwkxrnsnPrlJWRB+nZ66RrVq6S6rtWxkXq4CU6jCa/NPH8uSKn7zM
         J+EBa+7EMepVEW8g7SQa5a+QQ8FQmogv/VRsPjIKrveda7WO83KJ/ByXPZoPAmChRK/x
         c3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760038176; x=1760642976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a4JVrDAekAXuIrNrwEZUDzZE6GN5LqvSaIQ8Jq5w7+s=;
        b=jlrwsKmvkdJFF0TMgLykpq0/zaA2Q/DJjLSjXzjhFkXykFY5uQJJETKuOxoTdNajuM
         83GxqoqSXs8460ZBU7zdbmtukn/EyqFUC9YYXbAqPjPV9qGdMKp0jOX1VzB8U9++fvLi
         Y9+Rs5JYpmjz7HdswaTzQ3cT+H7V851sGoYfsq9Gfy5rJcHy3kzwaDRKTGeXVApb8Qh0
         1rmRrUqAHRNl+Rrf0FAC+0KL+/9FYZ+aJ8jV/RhDSl72FYeLB1V7dt5nMmaTnSl+LoWc
         o77A2fMfOinnerByc1SFRBNfxMDAm8ZGBc53ndr/SmEp4WmNaFtfPJJgGK922wRt+8Sg
         iJFw==
X-Forwarded-Encrypted: i=1; AJvYcCU33zTjcsOBmqKGSZM2kIsRORhD3jh8MlSTRlbHeaRV+4yDssC32u5hxU5QvZ4rixFFLtbDEfidFA==@kvack.org
X-Gm-Message-State: AOJu0YxCD7PreLbt0KpBytvjnzE1q6g2ni2NDFgjck7xt+FTfkT0bGu7
	qq0/oTLDX9mAjVRAFsV1g2z3zFe9gMyW58D8Yac2CmJXgMtO5fOfWjOn
X-Gm-Gg: ASbGnctza4SnTWt+h85Au8o/XS/RVJbNDXsWZjOvbvE735TL4Y14xUlwG0LFMQAzej0
	Ucwqfru2XG7ecpl0yxzzKKoB2QUv6GtEbppNxYPCYz3e7qHLysPgicbmo8xQ+EJOsLBxvO4rXmz
	wm8O01aysEnQ54lVhwARtU31ZA3c7nHjVk8WPi3r6xsKTHxrtr10KUFTgVizIjER2ug93ev+6pp
	JsjFIuY8bY8nAwC5f2uZ9yPR75El3ep0nG6ha74P1etT485r9RDuj7FEuiJVHee8Qi45NJhUg6R
	7AreYkKBmy32dqXLKh3yYbIEODC/Jw5FrodWem8FJnvck5AeY84d2/RPEfKUa9HyeBqfirh1A8y
	s1a4hlzH2YRNYQ7O9Hkg8NVkSNARvvnM5W1ImLa4EsrTuPSItH+Y9aHtbMPVCi50YEQ/kiOmVLs
	+/vlQRtR0Y1Xv67g==
X-Google-Smtp-Source: AGHT+IGiOdw5BMKTynbrKMyeKesCVN1/w5QDieM/W6PlPmireD6c4K/lhK4RmxdY1glQnGT/XKIxJQ==
X-Received: by 2002:a05:690c:6612:b0:781:2a:93f5 with SMTP id 00721157ae682-781002a9ceemr27506087b3.33.1760038175527;
        Thu, 09 Oct 2025 12:29:35 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:42::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78107263387sm889967b3.50.2025.10.09.12.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 12:29:34 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 0/2] mm/page_alloc: pcp->batch cleanups
Date: Thu,  9 Oct 2025 12:29:29 -0700
Message-ID: <20251009192933.3756712-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3rnjyb1e15cdsmbrhcqarymdwz3966x6
X-Rspamd-Queue-Id: 9E7D51C0016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760038176-213903
X-HE-Meta: U2FsdGVkX1/uHqT3rXpFNN+MgwGEwW1Zq716E4Fsy6kDXJTDeSojduncNbF7UKXoLd9j4sW7J8bKsBS/lyiErfIyADvjyDdI9E5vn5hkVwjGQrYgbyURMHU/4BWExbY5CfP85wJXtUub1CPzmwpsVn8wHbcX4qU4N+S237wgAGFnAriUWYK4q/p6V+gqt2JZnitHnsY9McStfPeRfboTdYO2Pf3Uiqt6bNV0d+CBA3nHexR2H0M1lqgUh3OdgQyyL0sLIV/MX94nzldUZonlOUeiM1tvVjx7YSGqqS3PCOqW7k7Y2Mnw5epFdZmgwCLi/aGsEnA8MbiXiOF+Ufs8c7q8H3OjGbbJ/GqRa6oF0VBSRuqVgb+1/OJXpkx1SNeu8TdBR9wVWULYWoJtrnCC3Mnb7ByrthZaZPlfhvF79585tXrzH4H+J+bXSAjy+nzvElKGqlpivxbOczFDmLfvISL044KF1M+f+1xd8X5UYeJ3LOCauEndeiIAWf4Sn3nUKd+ziRswWzXdgkygzSF2Dd0mucpOrh0pEGndAxev2xQ7S1mfovQumA9UCiokHR7QdPrl5370AyTRy3JQEyZAksJIP5OEj6B/eCyaiVCrO+A2+15leDG/RBVNGSwe+HHkjFty8KAZ1OXdgPraSKxSxcNHFfbC45n/Up0NO9EC3Na59WeDnOBZh9GlCuA00oCU8iy4Oeq5ov6eTICX35mJhhAsQNmymVNvW+B9J06GXEhtArgK5r/SDO7yPv7N13MpT+6ndOyh2s6Xk0C7S1B1lRSlqI/6pBL+L20ECJA3B1QY5ebh8psGj5apXSHuqGyx7Ig0BcXtkEsKZiWhkRh9clF3vI8Cp5oLcARJVbvaSF7o87AikMwCmjasBlJhiMIhNnCXoB/56vOyK3tfRUhk/XxaO2J1mRlgUk71WE0KtRFqiLZsD4SPnBFz4oerUAYu3578cMkQFEUAPnFwAJu
 zkCjBDam
 r9FDtrJe9BcHQAVV3QOViHHJ3DNs/E/Dd0LB5H3jmb03ccc0BtAcsMcewWB0DGBz7wcWkwRvtqJxBweDZoDn7UsXblcE7EZcsE3HMlaLhxN3+huqQmVI1hVTTdGJX9K8ZkbM+94NNFDUHyEfYIDk9/hKMLdnQ8kT3CPsIxShoX3thFOfXqQaa+AoUiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two small cleanups for mm/page_alloc.

Patch 1 cleans up a misleading comment about how pcp->batch is calculated,
and folds in the calculation to increase clarity. No functional change
intended.

Patch 2 corrects zones from reporting that their pcp->batch is 0 when it
is actually 1. Namely, corrects ZONE_DMA from reporting that its batch
size is 0.

Joshua Hahn (2):
  mm/page_alloc: Clarify batch tuning in zone_batchsize
  mm/page_alloc: Prevent reporting pcp->batch = 0

 mm/page_alloc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)


base-commit: ec714e371f22f716a04e6ecb2a24988c92b26911
-- 
2.47.3

