Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9EDC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038B76B00A0; Mon, 28 Sep 2026 05:12:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04176B00A1; Mon, 28 Sep 2026 05:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4CD6B00A2; Mon, 28 Sep 2026 05:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC6336B00A0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:12:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 458A5C014C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:12:08 +0000 (UTC)
X-FDA: 85262604336.28.9D53AE6
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf17.hostedemail.com (Postfix) with ESMTP id 929114000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:12:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EOf3Odjf;
	spf=pass (imf17.hostedemail.com: domain of liuxiang.277@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=liuxiang.277@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790586726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFKIfEpZiWdUmftWTQZ+UXe0u3N9BTu1HIzjt4MGous=;
	b=MM6nDTgWs2MoPOBK4FyR84muXNMF3Sn+PIYokx3E/KKLtMwTl85/ybDrC+coUT50v3m3Lj
	ph5qwwizRQvnnsrOb8JQgdfelYqHKmE/zDkcGrp17qBIGCUe6SBHYpm8TtxMoBZDYxdpGm
	RU+1L8eMsYSEXAqYYO5JTUgyergrllk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790586726;
	b=m15ks8e8JBEtpThMJ3kOXv8IaD/nEJ5r6RdnpJlr6Z5tLn9YylQ65TK2kNass71pSQj4g2
	xggFUZj6N3SWpIgLqgzBkC/ojr/n1fOjuk7JGE5ebKxKUlICKp4gYgZu/UQJh8ufezLsh6
	0inUwf5qcMNile68+XFXCuFhS+t0LLE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EOf3Odjf;
	spf=pass (imf17.hostedemail.com: domain of liuxiang.277@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=liuxiang.277@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790586720; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=oFKIfEpZiWdUmftWTQZ+UXe0u3N9BTu1HIzjt4MGous=;
 b=EOf3Odjf6PROF5Fd4TlCjszG4GktRLcuRCBxAPvQLvDCncu7kMz58sCiI8q5MV6uGFbQAy
 SHcjzXa98hBWsWCpF9ZjsPVkWXlUE10VvHheNTYSW9OKgX7OariVFlnsncQ2BfOFlkzwp0
 EZCE59OqpDzrQCN+VFA5Lv0iNO3aU1zbucLGJfQa2fvcy4qvsXh3DQRPs7OO3FWPGCA1Kh
 k3U92fGmIVFA7lqaee6oLiBpo3FIX0jAwdhn8tka5tGKkRK7oQtTIMF7s2vYqkrXmWBs6P
 PontegMv4+pgi6X/eF4Lf3TCRbsUYOHeB7/s0skyKRrdupVoNiKH2JV+oHtUcg==
Subject: Re: [PATCH RFC v2 00/15] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
Message-Id: <20260928091144.818739-1-liuxiang.277@bytedance.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26aba2f5e+b413f5+kvack.org+liuxiang.277@bytedance.com>
X-Mailer: git-send-email 2.20.1
To: "Kairui Song" <kasong@tencent.com>
X-Original-From: Xiang Liu <liuxiang.277@bytedance.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
From: "Xiang Liu" <liuxiang.277@bytedance.com>
Date: Mon, 28 Sep 2026 17:11:44 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: "Kairui Song" <ryncsn@gmail.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, "Yu Zhao" <yuzhao@google.com>, 
	"Barry Song" <baohua@kernel.org>, "Baoquan He" <baoquan.he@linux.dev>, 
	"zhaozhengzhuo" <zhaozhengzhuo@uniontech.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 929114000C
X-Stat-Signature: xfdui6hh54uazcjutopdxeajisjtp6ed
X-Rspam-User: 
X-HE-Tag: 1790586725-680284
X-HE-Meta: U2FsdGVkX1/m2pyhp20b34pAddNh2OzjflDjZLYxY0WDZzb497iHuYn0zZtcmS+yRlLQQCTnWRV/4KoIrRB7ngnwvnYKYq8TeBaT3lKGK++2mUzxJwVciyeeM+lOtXBR8L/W4EMtpRMEPOCi1A9KZwVYFNkUD/gICIxJx7JzR1o7EzvM7t+5K6lKxhY4zXOOqOFRsvK86lq2CmW8bYCxsRo2r3jNl/LIDhwaflNWDvwUbGaVtcWrE0FgLMqujSdoOp0+ZRjXyatSs12iVaqXwHDQ82nanFJyeDRPWrTSbXfa6Otno/AYXRDzimARXCDhkyfEyKXiSc1j5xaAXdSlWU0OmvExyIYiJbPt7HjzfvEHqZg5gg1+WLZ5o8KjPg4T0eAANACVVWv0OHG+ecTpnDnPVUiQAcJhAeOIdBp9aExKgZuKmR/1KPUJq7aMVOfYYqyID3XnmiiVnQimhUmspWAGCy9TgvxiYcrFWwHDFo1sdH/Pc0nJdqfakmdhFXoNrlcRehFKxK0Sq1rjMSExNsJME+N5fKLqZ5nVRo4XPZpTfoe7m/RetFikEAIddKqP8QzSiJPg4vQQcNGA1Tecnxk3ZnUNx8aopYYWiucvIigj1iK24oCuKe4qEF33131Wd3wLTQ4kbGg1I+oMhUFaatLbDRHfbaz+ukcc0tOc2RE7zVJxVUcWViJ0pdh+VbS9oU8vxjhxot6A/Qog9wc466bFDaJn+/rAj0pinuaJtYb9c/VdQx7JWwT++9dwLsDwONWzWxMtaiHTJbMtq+GISmkjuM7vtAe/lUSyCT6jnvrtmSirDzwe0lRXHwHXX6ktfuy0qsSZU9ODdDkGWV2VK9eLj6WgfI/qRZnAizsBLn0PAGOccVzRjYrrjx0CW4j36e7t8RvGyAky/uInOBTv8ZZ4OLlSiJRnH/pNXDm6/3uETILNX7RIIpvpk91tCLQwHXQBlvAgrPf3k1Q0I3u
 X6SQzcLV
 nuje/W1M0MIwLNnEygvAmxbPEnjHcqmV2FZ0WOTwyOlwDBiTcGSsmg8jQQz9YdlNVNFvzBe0YALW7XAf1dlQBiaxDQhVI4JiEIeYHmXhlrxcFDsiYvIbrO4BC+1buFU6CogtC38ubMgnEkMzxeoiRArjX65GzyGpSFc3CIYrfktree9Qyj0659QzJwkQekkOmKHpXOcsKrlexwNW4jD85j3ZHCjhhn81+FEJTVzxpmh2OMWjC9cwcu8lkCGQsqkEInE6s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

I tested the complete MGLRU-FG RFC v2 series on an x86_64 machine with
a SATA SSD. I found that the LevelDB Scan/Get result changes with the
relative intensity of GET and SCAN.

Setup: base commit 9958290885035431e2494159f555e332c3c14906, about
28 GiB LevelDB, 2.5 GiB memcg, swap off, Zipf 0.99, SCAN length 10000,
240 seconds warm-up plus 240 seconds measurement. Each untraced ABBA
sample used a fresh database copy, page-cache drop, reboot and cooldown.

Untraced ABBA results
=====================

Workload                  GET/SCAN   Baseline       FG     Delta
1 SCAN + 3 GET                92.5    4688.62  4425.82    -5.61%
4 mixed workers, 99.5/0.5    195.2    6200.60  6385.57    +2.98%
1 SCAN + 7 GET               237.2    9574.97  9831.70    +2.68%

The first workload is the original four-thread layout: one continuous
SCAN thread and three GET threads. The second is a custom workload in
which every worker chooses 99.5% GET or 0.5% SCAN per request. The third
keeps one continuous SCAN thread and increases GET threads to seven.

In the original workload, FG changed GET throughput by -5.74% and SCAN
throughput by +6.91%. The two ABBA position pairs were -6.21% and
-5.00%. A separate 5 GiB memcg repeat was also negative: -9.07% and
-7.67%.

Traced results
==============

I ran one fresh-boot baseline/FG pair for each workload. To limit probe
overhead, I selected about 1/1024 of file offsets using a stable hash of
inode and page index.

Initial placement of newly loaded GET folios
--------------------------------------------

We tracked new file pages loaded by GET requests and recorded where
MGLRU initially placed each page: the oldest generation or the
second-oldest generation.

Workload / kernel       Sampled   Oldest        Second-oldest
1S+3G / baseline           1452    186 (12.8%)   1266 (87.2%)
1S+3G / FG                 1371   1052 (76.7%)    319 (23.3%)
Mixed / baseline           1782    199 (11.2%)   1583 (88.8%)
Mixed / FG                 1662   1312 (78.9%)    350 (21.1%)
1S+7G / baseline           2719    469 (17.2%)   2250 (82.8%)
1S+7G / FG                 2677   2107 (78.7%)    570 (21.3%)

For example, the original 1-SCAN/3-GET baseline run sampled 1452 newly
loaded GET folios. Of these, 1266 entered the second-oldest generation
and 186 entered the oldest. With FG, 1052 of 1371 sampled folios entered
the oldest generation.

The same change appears in all three workloads: mainline places most
new GET folios in the second-oldest generation, whereas FG places most
of them in the oldest generation.

FG promotion was active in all three workloads:

Workload              Later GET       Moved to the promoted generation
                      changed gen     during reclaim scan
1 SCAN + 3 GET              38              548
4 mixed workers             32              558
1 SCAN + 7 GET              70              936

However, FG also removed more sampled GET folios before another GET
reused the same in-memory folio:

                         Removed after one GET      Later reloaded
1 SCAN + 3 GET            81.5% -> 88.4%           44.7% -> 48.6%
4 mixed workers           73.4% -> 90.2%           48.3% -> 52.7%
1 SCAN + 7 GET            84.5% -> 88.2%           56.2% -> 61.1%

The arrows show baseline -> FG. "Later reloaded" means a later GET
demanded the same file offset after it had been removed from page cache.

The request-level counters explain why the final results differ:

FG change per request       GET cache miss   GET I/O wait   SCAN cache miss
1 SCAN + 3 GET                    +2.29%          +6.87%           -15.97%
4 mixed workers                   -5.68%          -4.19%            -6.93%
1 SCAN + 7 GET                    -2.89%          -0.32%            -8.26%

FG improved the SCAN side in every workload. In the original workload,
the GET miss and I/O increases were larger than the SCAN gain, producing
the 5.61% total regression. When GET was denser relative to SCAN, GET
misses also decreased and FG became a net win.

My interpretation is that FG introduces a cold-start window for a new
GET folio:

  first GET -> oldest generation
            -> a later GET promotes it, if it is still present
            -> otherwise reclaim removes it first

The outcome depends on whether GET reuse arrives before the continuous
SCAN stream consumes the oldest generation. The trace shows that both
promotion and early removal occur in practice.

This machine uses SATA, while the positive results in the cover letter
used NVMe. Storage latency may also change the timing among page-cache
insertion, LRU drain, the next GET and reclaim.

Is this cold-start window an expected trade-off of the current design?
Would limited initial protection for refs=1 folios, or a decision based
on observed refault/reuse distance, be worth testing?

I have preserved the workload source, ABBA results, kernel configs,
probe programs and raw traces and can share them if useful.

Thanks,
Xiang Liu
liuxiang.277@bytedance.com

