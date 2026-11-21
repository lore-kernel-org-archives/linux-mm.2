Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55489606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j4Ri2Nd8
Received: by kanga.kvack.org (Postfix)
	id 666A06B00EF; Sat, 21 Nov 2026 16:00:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617C86B05B0; Sat, 21 Nov 2026 16:00:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506576B05B1; Sat, 21 Nov 2026 16:00:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0F96B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D207160583
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:04 +0000 (UTC)
X-FDA: 85460343528.10.172DCFD
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id BEF6314000C
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=j4Ri2Nd8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of maxmuzaf@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=maxmuzaf@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294802;
	b=MvXByAOlxCo6WAmzkgdafAo5bHRdl6Go9y9MZhsYuuq3aJocp2UxX6cP7HYSWKlYKVusZN
	3sfq0U4A2wSkjIJY+oNqVQvInc/T4mCu9T3BYDcRLLCpkdTc5E3/oCWvIBKMZrJuxRXb3p
	18lZea7VUGm+TwYCgfoF7cTIl6/ffOI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URe94R238TU+IoDx/sw1PfxXVYgbhspV5wPkapxLInQ=;
	b=IqrI8Nfyfy42F1mYnaTS8r5DLV59BnYUERTGL1Ik+g7n4ka/kNgDO1R4ORiKqqMq1tHxl/
	v5brhFcvC/I75o17AHyx1JmzakdCqvbIbXeOwHbUhVqXNpoPaUWY70aRb/lFiaXow8djD1
	aMoR79mObYgTEg78JaDZwNtT6AzswYQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=j4Ri2Nd8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of maxmuzaf@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=maxmuzaf@gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so19909625e9.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795294801; x=1795899601; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=URe94R238TU+IoDx/sw1PfxXVYgbhspV5wPkapxLInQ=;
        b=j4Ri2Nd8IyCKOvsJ1uN8dxDUxB2tfQMG2siVdmUkLK7eLS53R35F3hZASLlaJbJhMT
         FQvLMiNNDxyLUwf/Hf6WXWHSfZjCNfSWmGBn07M0MG3A0oeYHovcdlBiQnLBiEOV/3BK
         A0veCaayVOCgbWzEJbXJWiMYvRslcdCNhQIkdVi1WYljo5qfO19W/oG15TOhQqf7DkDp
         0DZ65pjOa8VCPgs9duRqMUbP2GmRkp39FwX6mOEszii5AnaFMSP1AOhJEirVlOK9yAfe
         yeDl/bYyn0mJ0pFmVHfVYvLMTPAPp9SxV76t8bMJrOQK7JOmt3gN5B8QbkA554+lNCeR
         O5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795294801; x=1795899601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=URe94R238TU+IoDx/sw1PfxXVYgbhspV5wPkapxLInQ=;
        b=GHuJJNsUiH3CmN8ByfJebv7zu7oa3iG3rIJSifpy4eqjTLMfa/BshCIPYmZGHjDWHE
         E70+ztMQVt4OKOYVB8afWsxt5giSjJr84WNTmMtm4SrNIPf6gsf8qmRBMpFQMiFAbeWu
         jYNJQSH69cDqG8qIvrXHzWrIqgEXUyslXJUItIqJBhzkW05bAi3tjvhSzSfNVKPurIsn
         N0Z/1Xh1NDPcjjpV1mwbZvpZLygWuCUVl4ycvisrl+7be+l1aNYsOdV4g61KScfn+RtS
         37e5xZ+FBJy8rLVzT68A8ke6uaJD3VOMBRGMFgkWh+kG0xe7zzpXZzRa3rTPj79S+uBZ
         g4qw==
X-Gm-Message-State: APuU4Z8aR1XQ0E9yx+qy9mJEudwmbKNj5mN0vkBDT+Zl6EcdpxR6zYGc
	P0NQnnnboEmiqp8VplD4l/lO5gr63mG60yQ/d5wC0xZoQZ0BOr9yRxYqZoSzg/3/q0M=
X-Gm-Gg: AZFdTZcJfFggu51iul4k3sZRcFaRi7KM30mQ3kmfNPgeYiezATkRbrHbCgWWmMXJbUr
	D8kXaRst1EVvY71j1qovP+p1JeelKMFDDNsgQ5ShdFDY9eUCxxMehpcEMoV2HQ5p9NxbZsegCNJ
	EiZlZNOZHORKKqoEoAPi+iLABUpX+U7etBW5LG8bmDQ6mFj/MYXOuB9l3067LcMHd8f+P9ePaDJ
	4nQWdAx2Pw0Nzpwk1NNnnMG2sT/m4m2AAbzJ3TL5SfmccweeavpF4GVDFhAB/iBj9nelkQKWtLG
	9xEfQLkKNo/djHJTBSqvOzZApmvJ0VWY6BO6WTvfcCFZPyRNSwpRuDRZrdl5akaNBdyeo82u77w
	H2h4NZUUavYo//Llums1oJeR0KxliOMO86wLg5cntQqc/rf94FsWXBloCRFS2KuBv23r7zSOlPk
	cHrN9R3L3VCnWKa1q54kiEw7Bb04pp/SahPjLsfpxDn+oOGhGyFSreNe1barqMevHSu5e+W2SkF
	XCNSwKPhL/l3Sj5J4uvegRlaY8cI7udTESquZW9Q+1auawo3YzSi7hSbgKG5ed4vyrL0owjYgB8
	JaAXVQgx1pNrj0iTuH/VcFnBfpuOFD4cmgEbzmmIwGuc2a6vOIxvptDPbdfeueOjJ0ruHmwVOj9
	vmY69q8b74Fu/vXGAqDaVsOrFtu5WmILQE5c+0f46RcYcEhmbISS8oi3MSw==
X-Received: by 2002:a05:600c:1c1b:b0:4a7:a5db:a93e with SMTP id 5b1f17b1804b1-4bb887e2677mr177415985e9.4.1795294800892;
        Sat, 21 Nov 2026 13:00:00 -0800 (PST)
Received: from localhost.localdomain (dynamic-078-054-132-179.78.54.pool.telefonica.de. [78.54.132.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b39b6sm181291265e9.12.2026.11.21.12.59.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 21 Nov 2026 13:00:00 -0800 (PST)
From: Maxim Muzafarov <maxmuzaf@gmail.com>
To: linux-mm@kvack.org,
	Kairui Song <ryncsn@gmail.com>,
	Tianyi Chen <hi@tychen.cc>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>,
	Kairui Song <kasong@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yu Zhao <yuzhao@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] mm/mglru: MADV_RANDOM page cache never ages and thrashes the oldest generation
Date: Sat, 21 Nov 2026 21:59:52 +0100
Message-ID: <20261121205953.30737-1-maxmuzaf@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119082441.196139-1-hi@tychen.cc>
References: <20261101160427.85701-1-maxmuzaf@gmail.com> <179502478384.194898.8139869410612997037.streamfolio@tychen.cc> <av3vMMhFbiaop7zA@KASONG-MC4> <20261119082441.196139-1-hi@tychen.cc>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oehciqxcjnc8cxfmy6k3f5g93g8zzirg
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BEF6314000C
X-HE-Tag: 1795294802-348695
X-HE-Meta: U2FsdGVkX18DQ3wlpP7WMmS41dEsOlNYZMVOpzynVn0kRW7pyfpFkRkvnFHClmcWi5CCLM05WzgubYi07Bra17bMC9PZAM7LH9x4EH9rmFnzgMGgQ0fsoRcTnLzpR82Dx4KwrCn5tQv/noePpPMTVWtqRz06Lc7V5nHsbkv7jnhsN7WOHosOPMTQRM3gvmITyP13zlEZ2KP2HCRgX80NU2Lyxyj3413wy1YSc/3aIjRUwy7eFGdzvBpTiLZGOWtCAu4r8LL0UqE3Ov77COXk5QwcpLA6qTKXUJdg32kecQdtrN/osXuf3S15dpjMj//Ydz5TauHtWtOf1L/I1GuvqCf4NuCWcjyazIfuERj5ZVgH/3kbOIm+py8Roi14OGyFVqaYId3JzwgHKRvWwCdyQi1axrN2X0iXwXGDwMFWxyq6nRvOX6ZZHbtRvxny9t3p4zikzrHnLPnwAhdzRAd+hTxoW4MjsiZ8729+fSxuS/wtTIlrOGZB31uWhI86KA6P0NXKwWuXYwf+5MW2754kb8ZpDNH+wfcs5yB7NWsSZa1lCpaqqzYyYtY1eTHzHXL6q/4QO1ju2vEvf+r3XJeJDqfnIEagzsZkbJdJF3y49ZBqw1uuZ0oxLUf2pbdfhD9WZitL2AF8PmtAictanJyGR5nNdwHx1xrV7CKOB2MFEBYH+5rnyDd2810udgXLTMGxD45TrDlafyA65+23uFtTeQ9sKPopn18CjqFEh+BvmggtRsg+K4wxrQ4S6LqNSA0w1qGW3gx+5T4PbXJIc6gmpMccvbNHTiH0kWKVBftU4P6KA5YfjUtgNPV67rWUCmNAav4OZ/Vcwc0u/fvgsQnk7AzIZDNpmt6pjrrpD7uidhcevsS7NDcaRm7v1CB2q9QOtSQMvSljRdQTaLsEHcuJLcSC0s9qGekjydLUIDo9PRWNgrSyh5UAk+yRwSYglb2k2+vEcFiybYzWuPbpErF
 m6fh1O2v
 4lyY4fnEufQnfxc8rLB+ANlGPwkFbg4NuwUzzF528HTzg1C0dGzZ1Ysg7vkTQtVTrjtfYlSou9W8XTnOEANbqtrOyPTq1nlsS2EYDx1gyFi76eB1wKuw0drYzDjv0gQnUfwOaOe4l0/h4cdCNm0sfbqnYlaYG6aQnm6VneSfBIOP3CRTVhreHV7Ue5Q9LVksBiWfdq40ifle3C4E/wYbvs1UnANAFvdDNqyiNzSq2tDcpXKvP2vwGBqUluPS/1TqdEh1Ld7k/l3VkZF3NBubj5jH3cREmMS+WvAaWJIHOHs0r//i91c9GiUMfANCZviivCck9N5zCdzyY8IMe+0HZOm/mwvBJZXsQ2K5GUL6tEkrX+5ZdpsUAlbDdCuWa3+bZwldZhasJEsd4pNrVk0LVp8xyUz+DyDnQbF3N4eVC2z0LgzjO7wFQSCqjA6a3b8qcvNncaXRTKQS9F0rWY4o7nEjbk9ayfhaDl+gC+szTNHdIoNXkDoU3Ii+pPuBY4CuYWQHexvaYFeZo/Q1RMZAPfNcoPYpRoJ8kDb5QP1vrlYbNsSf5qwP6dbP1nL11L2dgpLrL74q30Qe9yJsBTSlof6wUihUTKAiwNELyJb7IxNFkdBqXVFJzD6SiPBEdS5/UgLUTZ8UzFZCnlBH5sTkQ+IizfqQQ3qj8O8ot2XJ92Evgqhr0ZdAeQyyRa2ZY3d0+7/r2kvsCN1OxJmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Tianyi, Kairui,

Sorry for the late reply. There was a lot of new information for me
to digest.

I've checked the reproducer you provided. It tests a slightly
different scenario from the one I mentioned in my first email.
However, I managed to adapt it [1] to my case and tested everything
with the same setup (x86-64 VM), and I also reproduced your results.

The key difference [1] is that I added two new knobs:
- SCAN_PASSES (default 1, your value), how many times each scan page
  is touched
- SCAN_MB (default 96, your value), the cold scan size in MiB

This is important because 300 MiB scan forces reclaim to reach the
pages during the first pass, which clears their accessed bits and
evicts some of them. The second pass then gives the scan pages a
second visible access. The reproducer from my first email also reads
the cold data twice (--loops=2).

So the idea is to get the cold data promoted to newer generations
and watch whether the workload recovers while the oldest generation
is thrashing.

With a 300 MiB scan and 2 passes, neither MGLRU nor MGLRU-FG5 can
recover. FG5 handles the 96 MiB scans and the 300 MiB single pass
scan.

The Patch
---------

Kairui,

On Mon, Nov 02, 2026 at 02:02:33AM +0800, Kairui Song wrote:
> This code snip:
> + /* Set refault as active. */
> + if (distance < total / 2) {
> + folio_set_active(folio);
[...]
> That way, even a random folio will be put to the head directly instead
> of keep thrasing on tail. And placing on head or newer gen will
> trigger aging.

As I understand it, the refault distance series will break this loop
on tail. However, will the loop survive when the hot random set
is much bigger than half of memory? E.g. when its refault
distances exceed total / 2 and refaults land in the oldest
generation again? Should we in this case use the aging logic from
this patch as a fallback?

Anyway I'd be happy to test the refault distance implementation as
part of this work when it's ready.

I also rebased the patch onto mm-new (25fee5b1762b) [2] and on top
of the MGLRU-FG5 branch [3]. The patch applies unchanged to both.

Please, let me know if I need to send v2 of the patch to this thread.

Setup
-----

The same .config, and a fresh 4 vCPU x86-64 KVM guest per kernel.
OpenSearch and a cold mmap scan (96/300 MiB, one/two passes)
share a 1 GiB memcg with no swap. Median of 5 seeds,
lru_gen enabled=7 vs 0.

mmbase   7.4.0-rc1-mmbase+, mm-new (25fee5b1762b)
fg5      7.4.0-rc1-fg5+, 25fee5b1762b with 17 MGLRU-FG5 patches [4]
age2     7.4.0-rc1-age2+, mmbase with the patch on top
fg5age   7.4.0-rc1-fg5age+, fg5 with the patch on top

Results
-------

First, the good news. I can confirm that FG5 keeps .vec in memory
with a 96 MiB scan and MGLRU doesn't. With passes=2 it also
looks fine.

My guess is that at 96 MiB reclaim never reaches the scan pages
between the two passes, so their accessed bits stay set and the
second pass is not seen as a new access? I haven't confirmed this.

96 MiB scan:

kernel passes LRU       p50   p99 refaults .vec scan .vec late
fg5         1 MGLRU     1.1   2.6        2     117.2     117.2
fg5         1 classic   1.1   2.4        7     117.2     117.2
fg5         2 MGLRU     1.0   2.1        1     117.2     117.2
fg5         2 classic   1.0   2.0        0     117.2     117.2
mmbase      1 MGLRU    15.4  69.0   510691      75.3     102.2
mmbase      1 classic   1.0   2.2        3     117.2     117.2
mmbase      2 MGLRU    16.6  73.4   558370      70.1     100.0
mmbase      2 classic   1.1   2.6        3     117.2     117.2

With a 300 MiB scan, .vec is fully evicted during the scan on every
kernel, so these runs show whether it comes back. With passes=2,
MGLRU-FG5 is NOT able to recover, and this is where the refault
distance implementation should help?

300 MiB scan:

kernel passes LRU       p50   p99 refaults .vec scan .vec late scan late
fg5         1 MGLRU     1.0   2.2      413       0.0     117.2     115.8
fg5         1 classic   1.1   2.4      409       0.0     117.2     104.5
fg5         2 MGLRU   156.1 248.5 12548335       0.0       4.7     292.0
fg5         2 classic   1.1   2.4      686       0.0     117.2     157.5
mmbase      1 MGLRU   146.3 227.4 11247224       0.0      15.0     293.5
mmbase      1 classic   1.0   2.3      409       0.0     117.2     102.0
mmbase      2 MGLRU   150.2 248.9 11643192       0.0      11.3     295.0
mmbase      2 classic   1.1   2.5      547       0.0     117.2     157.2

The patch runs aging when the oldest generation is thrashing, so
min_seq moves again, and both MGLRU and MGLRU-FG5 recover.

300 MiB scan, with the patch:

kernel passes LRU       p50   p99 refaults .vec scan .vec late scan late
age         1 MGLRU     1.1   2.4      571       0.0     117.2     152.8
age         1 classic   1.1   2.3      410       0.0     117.2     106.5
age         2 MGLRU     1.1   2.3      565       0.0     117.2     150.8
age         2 classic   1.1   2.5      866       0.0     117.2     153.8
fg5age      1 MGLRU     1.1   2.3      410       0.0     117.2     112.1
fg5age      1 classic   1.1   2.3      407       0.0     117.2     102.2
fg5age      2 MGLRU     1.1   2.3      430       0.0     117.2     143.0
fg5age      2 classic   1.1   2.6      955       0.0     117.2     154.5

The full results are in the gist [5].

Links
-----

[1] https://gist.github.com/Mmuzaf/263806a5bfae85e75c3331467f85353e/030e6f11096e1980303aa153da0a35b220b4eecc
[2] https://github.com/Mmuzaf/linux/commit/cbd48001580bf1ad8a8767b1afd8e4ad969b3432
[3] https://github.com/Mmuzaf/linux/commit/1e889df5c555e99d437c608e25c22ccb5286ff8f
[4] https://lore.kernel.org/linux-mm/20261120103250.1241429-1-hi@tychen.cc/
[5] https://gist.github.com/Mmuzaf/e87acbefc15acc2cac40c2181de984dd

Thanks,
Maxim Muzafarov

