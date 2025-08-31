Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA8ECA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE288E0005; Sun, 31 Aug 2025 05:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5B68E0001; Sun, 31 Aug 2025 05:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB4B8E0005; Sun, 31 Aug 2025 05:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B35008E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:18:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77393C03E6
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:18:46 +0000 (UTC)
X-FDA: 83836502652.22.F94A2B3
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id ABB0618000E
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:18:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="TJ/lMHMC";
	spf=pass (imf24.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756631924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Wrk7aQbqVPPZjpKsq8t4LHCu/svkZR7eKtEEBTzldw=;
	b=UNVDCJki+CjoQmfzkiP/ASJKF/5SriImaEuvv71UuK82bmmkkQ5h8PSj9d+I085uxIU+Od
	568n+3YIvdLlCrwZDFMAUwmfJqbAZ2/P8TYEzU4RXCoh+YEroGqf1n7XBDc1GJTmwqn0di
	ZuGBHGYAEqgk8pByNXCI84hmXCM5MUQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="TJ/lMHMC";
	spf=pass (imf24.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756631924; a=rsa-sha256;
	cv=none;
	b=aKfUKy41sRgNRy0IcM0Dzxdl/LqtG2Eofm8KkjAICsL4L1Mo6ltdJS6/VseRa+HWikQ6Jm
	0G0Rjmg6xdDZnm8zcPN7rXqO83cj6D578PGxIFXCwOXkn5cj6GXSIXinrVXju3W/pMYe3C
	co1xXTG4OZBxg71eIIwPUxXzwUlVdfI=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d603acc23so26293447b3.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756631924; x=1757236724; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Wrk7aQbqVPPZjpKsq8t4LHCu/svkZR7eKtEEBTzldw=;
        b=TJ/lMHMCzn19z3/hSyreUcNy+wGuhffwb1VpIIXnt7yMCIBKSH9fi1ZLB1gTx7kbNO
         rzXoRI9XvxNldREFeLuHfKCloMNKOaKpQbLWd0+eOWEgLhNgDvUdEIA0eRJWcpS82QJ2
         UNVZCQs8+vMYo9D9yJue+nxe1acyQqRLJHeWJJWCGLxtcb+suHIyNX+LeVb7s76ieRiS
         Rtnaa9EgWWHxNqynnXU1dNsUZeIAHw7rT1k3ra+qykAhI9yYb8QfCfwXaBJ0+tRyVRFY
         j9bLRmIrjhPI1nZB8p1TJnhsjFnMrAep77CbbbZmA8kVZnYFFR5M0/y0+cApbxIP/M07
         DZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756631924; x=1757236724;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Wrk7aQbqVPPZjpKsq8t4LHCu/svkZR7eKtEEBTzldw=;
        b=WCYcAn4m0pnwK3vtdrkPBWUMS0OFyBbdR3uwzXIC86JJ0LPfTNyOhlmFH+zvj5QGhQ
         /RJ3aSs6nNk5kN7P8ckJm5MqUq152V9Knbl9x+plRpS5U5VHoSHAthDijqEvPEGbYm3B
         EZEbDKF+EDGd2P6IhbHJ163oObxKFgjFRYQDLWaaXpypcPP/PYrV3bVIPUOkd6Wwgipt
         wGFzxu4Z957aITHquJPs3ggMruJZvVjq3ffxsPA4UYujqKx/9W5Vk1oGdEL8UWRQ2GzZ
         HrZ9gVHVAxvhrbK4P9MoANGrJ7Jlu63qip75q64M6ZQ+AeT+H8dadYXgXfCF8rNr8/fV
         pkkA==
X-Forwarded-Encrypted: i=1; AJvYcCWyvR0XMtjDKciJpRADW5m5XOwo/vFduZ5lLnWKHEuy5bWUKIX7pV8vzR2BtOAaaU0SEny+2c0zew==@kvack.org
X-Gm-Message-State: AOJu0YxnP5rVntdOGsHoCPmaQbsqDm6up/hk1dMgDfbzEyd2CSmdkeQY
	43ywsZPyRELSPDuVoSJjmHutzbNrbxmt1mcQImM7n1ra0tAA/fdNO4QoAG3Xg7hx3g==
X-Gm-Gg: ASbGncuZ2SnfV4FwdG5+dYVTBtZ/NWlNtx+Hq//dxQgnuEdIoGQqkvHHzbQtWqFDhlY
	P3NqVqG318HasPqWUT5Z808rpE0cT9JmO54JlfmUc1Rm71gHMjNc3YOOC500rvdmwyuCFgbwjIf
	EMcA9w9fcx6ZgJV9X/2PDxOWgXnq7YEvZ4bWm6JNT9xBIB/n6cZMfj3dAqR+383klgNGgm2qYwm
	+/ZQeeWzNnqfzDwKFkVEYiejhI5gw+MMsS8ykRv/5kiMVXwDHj5HopXOXfc6yrMUctI4g56Jo46
	vXXL6sc2DDQIrAns/xOgzaXBwub5f89k3jWDDS6aEFYXTrv9Oz1kf9O69PhrHmqbwpeAxzc47RT
	gGgdaaREN2WwkxUdr1i/umabLsS3W4PWrIl5D2BvdQPQdIsPnWjhyYKGkNcPqWLbBI7m155G6/L
	yQ0ax1O+j+7ZHq2A==
X-Google-Smtp-Source: AGHT+IHx6UhN3JFnLmA4ryZLPJj6CdNI7qFb0bgmOG1cBhBLd0nyN429j6qnz3FhDBHZpgqIj4sp6Q==
X-Received: by 2002:a05:690c:9a0f:b0:70e:142d:9c6e with SMTP id 00721157ae682-722764f3c47mr40781987b3.32.1756631923476;
        Sun, 31 Aug 2025 02:18:43 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7227d8cc1c0sm7065297b3.34.2025.08.31.02.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:18:42 -0700 (PDT)
Date: Sun, 31 Aug 2025 02:18:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>, 
    Shivank Garg <shivankg@amd.com>, Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: [PATCH 7/7] mm: lru_add_drain_all() do local lru_add_drain() first
In-Reply-To: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
Message-ID: <c50129a4-a07e-869e-604e-3952f8530316@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: ABB0618000E
X-Rspam-User: 
X-Stat-Signature: sok7gdjhd6wi1hd4r5suo64wnpr6rx3x
X-Rspamd-Server: rspam09
X-HE-Tag: 1756631924-895358
X-HE-Meta: U2FsdGVkX19fTcCFEasc9hUOKbkoPyTONTsoTEbsDW6tclpsioUm3kYAmW/SYy9n1rBrGxR/oPcRpLdmvfk0rkq6SPCYaZF1aOnSssaHoXzhESORIHnGGTzEC0hKwgx7veNeV3elvWqZfVwrmNqWdbPBam0DRtwqgiJ3BQey4AU7WkPZHStFZNcfzBNAAYLbDuPq29lrL6QUOT6b9f/p/WYbdBtRo3slPtss3POfOCTslQIE5D+kRxXHi3Ygfh3QKStA47GGVRXCXOPl1doupjm2LBN9EJQmTdHI5Bw5iY7wWxArY91G1ObGe60G8zqA1Njt2HM7yL7g3WLk6TrmeZSRxYyx2s4p7O+6gS6dfPKfvE7ecv5nBNOkOhrvSbW6exefvO0BJZ55wM7ZXdVTn6hlkai46HKzTztum2OgQjoo0zznSp5SO5mOMgw/ciaHHkhgRWdBtcBy1asiEZdAcAyp0TZzHGXEBlefZqRq3Ci2ySWNBuCSu6G5M6sCvDevFmpdeYeiumZ7ClcMVVqWR8W3OERglsNvlCQjdLL1ePNSHOhX7YHGYNU1MKraemQZT+kmr4leg3zf8WFas8rLxmO13ECMjO3BVqWFWKKwtIjcmYO1EgGoVn/N7QKvCfLPUx1kB2gacFWD9Ckh7luyHSpQb1GGR0fI/ApypMO3zSRv1bjnXKPFwL+s+o+F7+f/acAWtxbwEc8IzM2mJJ8P1j/Ocu9179cnV9XGeamXG6ZndcfhMLpOgiY06NrCkFXSKCsRJdodFUpAOPAzQXsPhMjRDo9RHrz7zFLDBRHK9F2XFBekphzthIwBNDNzQOlaD+rIAc6iJM8D9oSiw+XetX6nlAXmnaze/KBDRgFUf0VbF3CkS9nuVMGF/t0cb2G69l73onS0LAY5JfeuVtaouVeaYSKvsB2PX1CTxijHer12pQLkaOb5wOKWR4n9XQDMTio8Xsi9U7MnjFKDDGf
 GSk0uOk0
 sYc0AJTejBTSiFobVUizVw5WbWZ2QsOP2uA6/pcnqD7GQ4BQOQM7MgcaOMtwrHy26hPKBMAe3F1yLrSzVYaECWmvsfC+00gg9DhwJEq4N27okdJOSt9As8ryR9w7BYs6RaMjMUZ1q8DUJQ8f012zibRW4YAZ3ogSI2Xt9mjLyPqS1GH2L0QRi3Bz85+r0Ig9/oE7Owg0reUSMWablHn+bWj9HVg6Wm2Vs5Ax0KuORrZPCQgTGLHwfZUfbLSjOVClavV40Rvfg5DnVU1mJSc8BqAmamoJ6iSA3edzGhZbgGVuxx7WbdGB+NfEVgqvLX5KhBTf48lsItvyuWK0WD2g2UyGuKlT4hpCMV2RAStlDP4/zYIz9PiBRkJtVTSovanWnsfWXVaVITd3N/VA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No numbers to back this up, but it seemed obvious to me, that if there
are competing lru_add_drain_all()ers, the work will be minimized if each
flushes its own local queues before locking and doing cross-CPU drains.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/swap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/swap.c b/mm/swap.c
index 17438fd1f51a..4951f4d35e40 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -834,6 +834,9 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	 */
 	this_gen = smp_load_acquire(&lru_drain_gen);
 
+	/* It helps everyone if we do our own local drain immediately. */
+	lru_add_drain();
+
 	mutex_lock(&lock);
 
 	/*
-- 
2.51.0


