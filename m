Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2E2606A337
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DeaXaX2E
Received: by kanga.kvack.org (Postfix)
	id 9E8616B05B1; Wed, 28 Oct 2026 14:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972696B05B2; Wed, 28 Oct 2026 14:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C786B05B3; Wed, 28 Oct 2026 14:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55BE96B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:50:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1B021401E4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:39 +0000 (UTC)
X-FDA: 85372926198.25.E3EF164
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3E1AF18000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DeaXaX2E;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3_EPiagYKCGsTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3_EPiagYKCGsTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793213438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oIMB3N52PjEiZOXgBhouwuUAXoicMhfnhRe1LhEdpEU=;
	b=53PGEgL10LXemtQ6govbpWphRQWqYFYfLw7WkIdrvOpXgBXs6neWjrfwmEHyXJPODVaOrG
	uyRHu+ouFuk4p3mEytTe+tY6+rg91ZVVOKx0QrhHmCC5siY2Fcd35VakFsVY5HxNtwOa3l
	trqLZF6aO/h8O8JRyx74n4wqBkSs7Rc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DeaXaX2E;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3_EPiagYKCGsTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3_EPiagYKCGsTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793213438;
	b=FpWOXduXNMKDd1VGAncQx8V5arp+AgqPoJod+HOQrwMB84Tkt1s24nsymWxgE94Z6waT22
	poY0M7p5nvhAdAGCBm+tuhnFG5FSsbogZ1orqmUhLqZGUkiPqCqep3Nd9PQnCX/dUg8J7P
	7EdNfcbM05UOpCzBdGNWa0+PwKjpRVA=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e9d52f684fso11803845ad.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213437; x=1793818237; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oIMB3N52PjEiZOXgBhouwuUAXoicMhfnhRe1LhEdpEU=;
        b=DeaXaX2E8gpt5pDYJVFmN/g/hrelw6zymiGIPrNnshAqTY938n6g4BdopEIxbIwGlh
         QXVmkKSoo7egdiP4FpkBx+UpjLVMqwNDrbqMRUUer51E8ZizokcdDI/TBiGznerV0ppI
         e0ot6H84K5jDA3kW0GFL/iZ359/gXglzP88Ewud6LAkHlcDmfXWQCNN/lz9en6VTt3uW
         N2fv+DY3Hku+g16u/HvK4Pjl78870WdmzNVa3Z8RTX1QimAN7uQek7MuwCyKbCJq2x07
         qswUo3Qyt7G8V3/qZKmouFSSpOMJrvAQHFPykezoglcf+ghQ+LWZitLgIJDbt8mIXNzg
         Dcsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213437; x=1793818237;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oIMB3N52PjEiZOXgBhouwuUAXoicMhfnhRe1LhEdpEU=;
        b=Uiw3wCwNJI6IvMOgx9UEi0LxeKC7FgwZi+caukoVaqizyiv/+NtfQ6JP40JTqB7/8I
         /MVfAU04W7sOH3Y2l8h2pfnouuTFZJEAnoCoOcmo2r/gTvOlPQXeBH+odL/qkKkpCOsa
         2nWqjC1SH5jyMrm2EDRx3el/2uZMKXAnk3vGyDPonE8GJRrlFMCOrafD68RRqgNgTDSN
         TOnZMw79LFKQt2I3PGMKlN5C2p+lQ1l9spUu+KR72fvaX6Vq61qz8xvmP+FcAEtsHcwF
         PmPGIQYjle5sc9EaOeiaGvnjjXIoTL6ij8jlzcxXKAPxQLhbhpcoukKvk053DUW2Txtn
         iMeg==
X-Forwarded-Encrypted: i=1; AKwUvBw5N3nckA1sbg4Pa0mx6mnI0Lw1VOnA1MN1IMz9pCSN86GiGDTFRB41R6+2xuA3VWONqCz9i3GfLw==@kvack.org
X-Gm-Message-State: AFq9FYILnB2Lr0tHUUbU+YeCTdbbGbuHAxtSmDA0/bdVqNc5vdfYztwD
	2QWoo0iYtENnPctVcsUwYgQTKU7lmQZ3X0jiA+PPz1JuspaUUTmZDArZ/PMpeYhkOfLxHA9fvos
	5IrYBtQ==
X-Received: from plad19.prod.google.com ([2002:a17:902:e153:b0:2e8:486b:aed])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:120c:b0:2d8:d4d0:7930
 with SMTP id d9443c01a7336-2eb004f3928mr28395135ad.20.1793213436894; Wed, 28
 Oct 2026 11:50:36 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:12 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-1-kuniyu@google.com>
Subject: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3E1AF18000C
X-Rspam-User: 
X-Stat-Signature: r6ij6knkm8yyamfg1uexihem19wbnf8e
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793213438-73581
X-HE-Meta: U2FsdGVkX196L01ixhMtbmyE/cnkp3NIvvReVCuAQcKkrEPoVLDPPwOAQfS35xjqlTH3tZf2cXXUt/wm6mls1D9exUejMuXpQSia9C4lW4O3Mar0Al1lRxOBLofal9onncn1Sg4cPiEY0wPUuN2jyXVa5ZZKegyH9NGnFGqhp4H64ogmjL/FaAPyp6dXLV7/7zU2XhZSvZgSrUowqcKN/L5ef5ZzVGBJmeTSeSDN654yONKKkudqzV95hFE50YYtV3zKd+rbleS5Lh0EDKVgPve/KfIjbOnn4Y6hbVWsBrU/JWmQzgkc8PDdRZ0ElmOw12fcyI1tMcPT810Hx5soAfIiZeMwQQ/SvqKAe3QVhYFjsNKxQVAHONsjiJk1NhizqIW+JnPpIeWtFOk03AUHe1jabc9mxpAt9irlB94bVELcoE0oVin9DJgyVBbKYVEyaV6h3KwoTgLqyC0f0ATWE7kxwZIOXFcza8MhZArcU6utNNLIuPnguVpEZH+SY1RENWOG3SvH9/co7WOY7RQUNOf3i9C0i2AY1H+qyFHLnTBbTICCE2CZvFVbVnoDDKmF9r6saCSMDqACZRMChma6KD0Bvp0rChK+KZh8+yGBgXnLYag1tbKUyDZoWSAc6H+wMzj7QbNhVwKAFHlrKoyfg0emgng49H9bLX7Xw2QpBHKkeQuYMt0/QjVmv8HA5cIM7vdlrOSQ4a1ib65r+VrC6YxvGeGgN24o2roy8ZuoPQE0sqvevoLMOdqoYf6YR9bfIgb+V6w9l/Z2gQeEo9ZUsujX82yb69YvhkuPORkwFUttnxA1hRK3knQOlbyFQp8QmSzMC1BEXL4BuLQr3SVFMOEkCpgD7ZSTAE6fib250h5mBLoyaEgO2JoEjtPoIpwae6m5dAUhBFhnMDMS6TMO0k6lxbpngQkyNleSqgrOK+HmWYZcmEa8oxRoMj4LuzUoC44rbQU2yY63PrUqbm1
 4wr/1tQn
 TQ7G3H9hehv66b71bTU91dLkK6HrIE4wy8m6Zs0fs5Su4Ou5Dz0EhIGmiVXPJDiYeXHPgsKGvtvgTpCDH5T1P6jBRuayn3oXxUHe0FlXePhrs1r4Ay1ooN42bN79zRRilxb1CaD+bklcGa7CGQ7uN92R5hKBwrpSNQE7//vTRB7T/jyuo6kqUg1croRHBNc+6RIsdtpotqFeODEl30cOnFXgLglZvHXcXykZcrHUnkt7JW4MXN1ix58Y30068DnMwRcYCw6eU6D7TlogzbQv3Svsj3M7P72kMfiXYh/nuLsD0mQaV225Vx7Yxdy8aA+m1mTgjuja8dPNQV/eyEikvKZwH3bocMbjSRNMxAOaQUBvV7Q/2jhqwalTlaBcTfe2jri8jw49EmVCtS/NToaoSV+U2oSk78BwTI2cX+R/H20KkXn52VAdvrspj8PIW9D8Ry84XDPv9v1evsAjsChgXbsEN+xmThKCherHikxCQXWbBPk2z2ZaHpNCpddO9h4c9Mq8yfukVMRqjSLhFSCtPLGPrG2MunBFUIsm2c0viHvugMQTHjPtn5fs+BUGqhxm126AcGwzzWlQ4tQh/ZD8cLKl5Mp0hAqyNQ8Ee5tuaJO9tsp+dgAwx5x7KA1BmpjIRXQA+xEOIFcxvw5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On our production fleet, we saw mem_cgroup_sk_charge() spent over
3x the cycles of try_charge_memcg() although the former should be
a thin wrapper of the latter.

Looking at perf during tcp_rr, most of the cycles were spent in
mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
due to cache line misses. (see patch 4)

Also, tcp_rr w/ 20000 flows throughput often degrades by ~50% on
many core machine. (see patch 5)

This series adds nr_sock[] to struct memcg_stock_pcp to batch
mod_memcg_state() for MEMCG_SOCK and move heavy operations to
out of local_lock(&memcg_stock.lock).

With this series, tcp_rr w/ 10000 flows achieves 31% more
throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
Processor (Zen 2 Rome, 2 sockets, 256 vCPU)

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |        Patched |    Diff
  ---------------------------+----------------+----------------+--------
  Throughput (RPS)           |     20,884,499 |     27,466,490 | +31.52%
  Latency Mean (us)          |         478.46 |         363.71 | -23.98%
  Latency p50 (us)           |         453.96 |         356.68 | -21.43%
  Latency p90 (us)           |         669.00 |         479.56 | -28.32%
  Latency p99 (us)           |         969.38 |         617.80 | -36.27%


Changes:
  v2:
    * Rebased on mm.git/mm-new
    * Add patch 5 for flaky throughput issue
    * Patch 4:
      * Benchmark again after rebase and update numbers
      * Check in_nmi() in __refill_stock()

  v1: https://lore.kernel.org/linux-mm/20261016052811.3085635-1-kuniyu@google.com/


Kuniyuki Iwashima (6):
  memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
  memcg: Reduce nesting in consume_stock() and refill_stock().
  memcg: Annotate slow paths in consume_stock() and refill_stock().
  memcg: Batch mod_memcg_state() for MEMCG_SOCK.
  memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
  selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.

 mm/memcontrol.c                               | 178 +++++++++++++-----
 .../selftests/cgroup/test_memcontrol.c        |   8 +
 2 files changed, 139 insertions(+), 47 deletions(-)

-- 
2.56.0.313.g2479322e68-goog


