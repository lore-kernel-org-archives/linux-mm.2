Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19AF2E98DF5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432F96B0088; Mon, 23 Feb 2026 02:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DFF46B0089; Mon, 23 Feb 2026 02:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB6D6B008A; Mon, 23 Feb 2026 02:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18CE46B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:25:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9552B13BB62
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:25:34 +0000 (UTC)
X-FDA: 84474886188.17.D0C0061
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id ED5FD1C0004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:25:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4iX6WDjB;
	spf=pass (imf21.hostedemail.com: domain of 36wCcaQsKCLAQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=36wCcaQsKCLAQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771831533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qPGaF4mjxi/fFntScorjXmFNHsOVxo5tJME7XiGxi7M=;
	b=Fn7PB1FewATRplFwENOPnI2gX+4gwNVjVbtybao3KHPOJZrYCnx5upWldsDzqIOyuT3qXw
	EGvtyZvpJDnyKlQ4sT7BTLRnqyl23ESD47tUciPrw9Lc9oHMxF7zH5ifc0BEPsOh0NF/ZK
	O0fJn+WifKV5KCBGwjkw68saAdEaB3I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4iX6WDjB;
	spf=pass (imf21.hostedemail.com: domain of 36wCcaQsKCLAQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=36wCcaQsKCLAQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771831533; a=rsa-sha256;
	cv=none;
	b=Lfxvli2uA3N8qW9EljzD33/oJyAjtORixqhDTx/griHvxvgpYcGOn95cxNKxaSQWZwAnpi
	rO5KRdvtML9xIptls1YdosmSC8P/15Z4pkOxQBchwKGPKofyz1vEEIFLayuK9VwtID6LY2
	6YPaVtZBqQMtCA0XV7K04HK+iKLU2XA=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35621cea097so2554181a91.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771831532; x=1772436332; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qPGaF4mjxi/fFntScorjXmFNHsOVxo5tJME7XiGxi7M=;
        b=4iX6WDjB/EI/m39QCUrqDUqwDd7BAcMYDiIpDRRsfYA5KnqQHLyaGMVPJ4a8K2jrsk
         +urM/e9zKVCWN8oNoXwjz0WGsOOd2jEG3porm7ocMgPtQct0zt8n4Vy0a8o3zWP+Sl/7
         xlA3GDLWbrzu26DBGvfSunzInaqKnKAn586fKIwQgZ2sJkbYRvxGPQgB0xyPCITXG1kO
         E6WVt+Ps4wF8APjcrRioHzzDVSKLzek64JSFoWZkd4oycCaX/G3MkVxzSpYzXG7lrm3K
         sGvQiqNMXKjqQlTEiWmrKi+Vpr8V9QidFecY1RR89lDvICo/NE1W9oHzsRjlQM2kQzdS
         FYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771831532; x=1772436332;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qPGaF4mjxi/fFntScorjXmFNHsOVxo5tJME7XiGxi7M=;
        b=pHkoWIx1c50Q1xE9dZpXo0J8TWdz/mivZYpUmdnR+9B43b8UP7kZjXtVOW/qIAwKZJ
         E95ogbS/pWw7AscMy9c7kG0kkmxHRC+GWE4siG7RZ6ZCGHo637k5I7FT34by9MDMToet
         +ZEAZyumm8Ap6ZKzlTyAN7O92IHexI1sHfnD9RsXxc32+EXn36/T1cU2P251LSSej+u2
         bMx2qYgQszKQXcVycrrE0qG+ui6q5ftCH6MMCJWPuosXd4qdLwpymy+xtSi7QAzwe+UV
         wRhKwmw5zAglbudBWWLTJf1m2zUMsacVmG/LM3iHvKDghqlFOo603xuMhTHBM/U0CgW1
         K4xg==
X-Forwarded-Encrypted: i=1; AJvYcCXS9wwYA9v9zmGVn5NczSZOYM3gyt4jQp9esKLMVawWljXaKX+QdQ/Qiaino70PmcppLh0Xe15vJA==@kvack.org
X-Gm-Message-State: AOJu0YzomgPWS8RllDhXQwXW8tLBF34mV9TUedMQCGYpIOLAcfO0LAbi
	CKsKLfs+3GhT1TcFBUKWYgNgeseWtPDhQj5WuHh2Zr56pdttZ3i5csQHVkecK13t3ykrMicoxtg
	ixqk7kCwI2FtRRPvlWG26uT78YQ==
X-Received: from pjbmt17.prod.google.com ([2002:a17:90b:2311:b0:353:28:3531])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d40e:b0:34a:8e4b:5b52 with SMTP id 98e67ed59e1d1-358ae7fd277mr5726192a91.8.1771831531726;
 Sun, 22 Feb 2026 23:25:31 -0800 (PST)
Date: Mon, 23 Feb 2026 07:25:26 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <cover.1771831180.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 0/2] Fix storing in XArray check_split tests
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@kernel.org, michael.roth@amd.com, dev.jain@arm.com, 
	vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: ED5FD1C0004
X-Rspamd-Server: rspam02
X-Stat-Signature: d5e8mo89eope7gkwc9eb9t4s65rf6a3m
X-HE-Tag: 1771831532-223750
X-HE-Meta: U2FsdGVkX1+QmD3NaRQStCc38U100AncSGjSvZ2Id26P0ukCj8Me/z2oEkLXQS5yR3OzC5PIwV2w0OKtnn7KRL/fJTAVnn9HHUBRl6Fa2YGOJqjMd4L4I90Hb266TwzGt7XeiDB9oJGF6BVKNszLZnhmkAmXIazF0cgCd/+2h5aYU4Sg4+tDZ/x3pzlXZZuG3FTB7gRvo5LCBdh8DCpKcqm/8LNbgF9zrYxXQdmAMC0aq35g9olH2XIEVmlM5ugQ9dnpwzEKrYGX2NGGCyufLB8AEImR4TasHiTqDx5CCnBy27rf0X9NRsPleLUjzmGFaUHXrXQQO/Nebgt6MdU3sB4jsBGE293wzVCEefpqZt3v/kLfliehxPtZRGKQqte9QrJ5OCzf0dgqZoJYAMhtKSfcpupyGbsjN0D2D1FRs7mtwzIGgVtTmSjYOhjHwg+f0QkC20oGrQ5yKeRNRv6S5yb2JMKxISQTz7bKHuLDMOp3k5nMzmXtFlF+PKood14lWsEKaNCk6KXO59mtHpeR7sFAiLSDMo9Tq8q3a2BwQxlD9CL8VSI7AneTnCwhXZjPg4Gr+WU8DDjyU6dRl4ff9ge1nGrzn9opwKd9PYcr7ZvrwKQEkzRka/mRyhYjifaDUAmUuW5FA6pnZLvWkEHgPf4gk0U0kl9ymYITNq2VZGKhsHkLz0QJbkLDeU51jdR4M5fYCFvYJHt7U21aSqEr1BsgwfHSKCtwxWeez6PU3GxjMj5TTQnv0oOAv39N5f8F2jcvoOTU9k7eSvJHYmJdjcL1fHGyns1reYtMoDTDiy38mTAmeLpvO8LMAbsAXQvVJwG0vw+AfkxUCXYC9UF237fg6HVN3edphFAHMjCoriAWBC7qcAG9Vwb5CQzkVezFt8ZO/hdzjlK1ruBOh2C7YcTbl4oBY6VrNFiid5utmeyD6TVJ1WL6rzd5UFu2K3217SoPswWBiNZ7K35Spkd
 a8aAgHE+
 gKKciEcL/rZM2wfrP+Kd0/pUVhX2+Mk/4wuQw6krlzIg0DSKfmDMhwcxeiT5hURn489Rb9tuHcXWbe+U/zJC44iZ2iDfhD5vlb2eiEgMoMWm4EuXAR+zbuDLQ6UHLWkLWGrk18pq2RC33KwQO5qCvbIeX03fweKglDYj+nMf/RzkQOzk5whRHezMTE/BtrdfvOPeSWBPBlC54MxGoqW6zrkpy6vu8RqR31bekrlk8SR7CRBk4hJ9wN4tDyilvFRnvCnU7CzrwV0EYaSWVAtNeOeQpIHAOFOkCSsedNJAPdkQEF4ky2ferpROw/MbkOyZimJYvRE2NssqErn0xVNKFMe35IWmZoVoN9rCpURPnCFbwhzf9L2XVNi/z04sXiMSptqs8+6aA9bVStdkIdRpy1AdHqvLd4e6M4aDpWmwj3r+3X3ujYSLoR+E9jBgHS/TmOK6cO3zSEBos/MzRZo45RLMCu45iNAnSLkkPV4Bt8ftNIIuThG/EuPelJfE8NeCJC6BesOBWdJIsXhBrB62pWcMcnUBFU8IBVleE59UXbhPkzvPIFr33TKLiQ002LcvpaUD4q6esC4TvdiBRYkGn69bXz2yKNW3Z5Cun1cEl0J6SEHk1zzHJZZ4L2BgeacU8Qpg7rYikzwKMl/k+RtFMAshPA5dAWs4235XPPfx0DX4vJXbktou4pGJGEFc3ZU+n5+5ZcuNiUmIBb22EBfY887bXg0I8680oh36zg0/W5yvF6Pk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I hit an assertion while making some modifications to
lib/test_xarray.c [1] and I believe this is the fix.

In check_split, the tests split the XArray node and then store values
after the split to verify that splitting worked. While storing and
retrieval works as expected, the node's metadata, specifically
node->nr_values, is not updated correctly.

This led to the assertion being hit in [1], since the storing process
did not increment node->nr_values sufficiently, while the erasing
process assumed the fully-incremented node->nr_values state.

Would like to check my understanding on these:

1. In the multi-index xarray world, is node->nr_values definitely the
   total number of values *and siblings* in the node?

2. IIUC xas_store() has significantly different behavior when entry is
   NULL vs non-NULL: when entry is NULL, xas_store() does not make
   assumptions on the number of siblings and erases all the way till
   the next non-sibling entry. This sounds fair to me, but it's also
   kind of surprising that it is differently handled when entry is
   non-NULL, where xas_store() respects xas->xa_sibs.

3. If xas_store() is dependent on its caller to set up xas correctly
   (also sounds fair), then there are places where xas_store() is
   used, like replace_page_cache_folio() or
   migrate_huge_page_move_mapping(), where xas is set up assuming 0
   order pages. Are those buggy?

Changes in RFC v2:

+ Rebased on Linux 7.0-rc1

[1] https://lore.kernel.org/all/20251028223414.299268-1-ackerleytng@google.com/
[2] RFC v1: https://lore.kernel.org/all/720e32d8e185d5c82659bbdede05e87b3318c413.1769818406.git.ackerleytng@google.com/

Ackerley Tng (2):
  XArray tests: Fix check_split tests to store correctly
  XArray tests: Verify xa_erase behavior in check_split

 lib/test_xarray.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
--
2.53.0.345.g96ddfc5eaa-goog

