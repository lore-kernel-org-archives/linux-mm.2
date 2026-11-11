Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3A0606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S8273CJF
Received: by kanga.kvack.org (Postfix)
	id 227AE6B05B9; Wed, 11 Nov 2026 03:19:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF5E6B05BB; Wed, 11 Nov 2026 03:19:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A116B05B9; Wed, 11 Nov 2026 03:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB6CE6B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:19:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BBFCC0245
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:12:29 +0000 (UTC)
X-FDA: 85422121218.18.7B9F4A6
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1FE63C0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:12:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S8273CJF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of lin2530632123@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lin2530632123@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDQqFMFsaggT4dI5ccBsPoJYKVRVo9nP+0XBMBBOzpw=;
	b=yu6Cl7HCDxdR9fL9UkKiPRcT7cMCbviutSlaP9HwmU58pB9C4ahNTdSUK10eC7HjA3FfIe
	tbRU4GIqrGsbf1YJ3jEPK07YIHbE3n73KtfWl+gI664j1tZhoOiyZvuZ01ShwhWLuJxkwX
	waxmo3SEIuaovBxVOm9ksIAhmUXGiuw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384747;
	b=VHYNsbfs3ChBS2UEkkHFi0R9jjeexGNYEqfWQ10Pj/sblnWn7ULq06Lc7+LFPcBxc5HU2K
	SHAWkQ4vsIGBs2IqBtfeREgScvaJqw/U0CdY52d85O9FB6P/9TjjTVnjrmoD51wJ+RvjC+
	tS6VA4BxwGn4aywXfYgrz9GbCPyo89c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S8273CJF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of lin2530632123@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lin2530632123@gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e96502e447so24255705ad.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794384746; x=1794989546; darn=kvack.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fDQqFMFsaggT4dI5ccBsPoJYKVRVo9nP+0XBMBBOzpw=;
        b=S8273CJF0Uzs93nj7sAWfHWeTo7zkDNcBdBgy5mj7uVQlOwlJ5axnIoqxURLfh8514
         sgtb8EFF7N2YSC5qFEPngkpbu7xEpSrd4EQ/uUXNcMK5b6uDVxL0hPzv7LZ8q4c+TqzE
         +FytA6M360BrhkJiOOW+tGlWl+gZngOhNszrqZGetixIx4p9sCCMjLY9QXDOJVVbUBqm
         Thi6o7XL/VSvSL0J3xrA4ARdPRLHUN5FzTRGMapW1X96HDb4WYWUjTY9YY/XjE6jyAHD
         DBGRtwFk3H3eeYUaJ4LzhQf8Ur2jhcfUeJp+OxxB0MZXtPN8ZpYMRWg+Ci4SEKbB8v6T
         qu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794384746; x=1794989546;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fDQqFMFsaggT4dI5ccBsPoJYKVRVo9nP+0XBMBBOzpw=;
        b=sRQzjmt70QiQH+zsS+KZ7MBNA4hM/eYuMW9kbeth9YEaJSlzV68hZlDyWktFuqYHjJ
         mY+uqbpOVRGo0/ntQMmU8uH+udvpjxsTY5OxfNZtq8FeNzSLBV8SmygZHPgLwNarrmXf
         tpmri6ONmauWNaDYqnTYm0spwN06vHAUPyQCBeDzNrqZrgZLmGEOxysi0DR8Q7QPPYWR
         eKRyhSr7s9C+/zoFDauR+wACtarGMoXxvsrGa072OVutYhZO3u5LVTvdS0o9Pr7ysi9E
         3Dx2ooj76mZ8BVP+iGa6SdICx18BP6bkLPLlUB1a65/RKBK161OAgEONRF618oew0G5g
         CFZA==
X-Forwarded-Encrypted: i=1; AL+hErELpj8niNzsZKaMGFGE/hhkie+DME4nO857/7MSo+y8qTEaSgkH8tHj6YlW5T5+j3xQxW6t8p0XFA==@kvack.org
X-Gm-Message-State: APuU4Z8Y9XLqusuaJEH/OQgufrQ9FKhz+UOjfXrbdDcaWoShmvuiW4O8
	DRBxiZObU4GxuQvVK4l8GoKqp7RpNukHB08SmVVvafmn09+x/1OGtTwW
X-Gm-Gg: AYBFou0P29B9CXZjwZ/azcQcIjjTQvhfUMwgwNg/cl4vKViPD/AtxoFz9EdZeMqcbA5
	uPSZ8Nds+wQeI/i+dWW/G1R+MIHFmQTVQ7zUGQ/pI/aFSE3gjm0PLWPt6rgbvgQ4957C1q87bsv
	qyJ4DBftiWf5WjhAsJbrE8a/czI9oeShzTqES+GHaVgL/K3icmSqcNwxYNs/jSadISrd1rnCQpF
	WJbE7xWwgeSiiPlLyHWkk44xm8GQ4MYgPtfncvdH6vADQ3k1RtbK3wBrbIVJkRHn/H3iddthJou
	dqm17L2D1gL/7Xg/tJeuVuumNrVjgRfa9KYzqfa6Y4zw055/0DV9ZPeievEtt1ggYMCY606dhub
	hmw/tFUND5liW9CeelOw+ChczsNmA0RsMChqGjryLIzsFlzenYKv8hqXe0xbl/x9oKc0zUaebRO
	H+GuMTdVJMBlGH8ASAEME8dceAixl9jiREP17CQrqFTeKL2CWU6GOl8+LLotc7pNYOiYEl4DJ5G
	vPeBUgba5+XpMNlXnmkhSOpH09Xh5AI7aEYRggAF0ve1KUu1sPB6SPudEfk/VnUzl7ffNwLs80K
	lbU8YMq5b2VtAYUVsZHtWBwU/Yz1tf6smCrH87Cx7UgzyC2TnUX5ASa+pZYuUATBPXl8nRZb/+0
	gbUZQwyuW/A==
X-Received: by 2002:a17:903:3bd0:b0:2ea:e24:3eaa with SMTP id d9443c01a7336-2edd745486dmr18667185ad.2.1794384745370;
        Wed, 11 Nov 2026 00:12:25 -0800 (PST)
Received: from reply-rstat.eml ([117.28.251.181])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d9afa2sm17326745ad.43.2026.11.11.00.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 00:12:24 -0800 (PST)
From: Chengfeng Lin <lin2530632123@gmail.com>
To: Joanne Koong <joannelkoong@gmail.com>, Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 yunzhao@cloudflare.com
Subject:
 Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
In-Reply-To:
 <CAO9r8zPqJncFKQbF3tGe1d4sg-4dLQ3dQRGze_vab26wWrXTqA@mail.gmail.com>
References: <20260817131843.45121-1-husong@kylinos.cn>
 <CAO9r8zPqJncFKQbF3tGe1d4sg-4dLQ3dQRGze_vab26wWrXTqA@mail.gmail.com>
Date: Wed, 11 Nov 2026 16:09:08 +0800
Message-ID:
 <179438454803.6.16655549133383619919.zswap-rstat-counters@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0836176935274178407=="
X-Stat-Signature: 3a54seedn9ri64u7w17j6kgfzrd4ffj1
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FE63C0006
X-HE-Tag: 1794384746-9112
X-HE-Meta: U2FsdGVkX19AWQtZeXNcl5sVfdI3knmd6q74JM4OqC0kHPHgzc3BHdETJZo4B9bC5uN8HhSBRY/FlpMQXYfXCosX0+ZWaHq6W+mo5lb7w1u6RQLSKIiFvoclHDScvXkvxj4nLEGZOfXmnHT3s7+Ja9fXNXjhslqwmExMo5K4zjcwtE2BPKEH8lRUfqLss1ltf1A/hML5AS9smLLZZEPFGjFtnuR8jPxQ31xDWmDBqZmKhhE7BX1EXwxt8J7phvoZpw4VYctFQsguV1RU31oM1tkcRfEv7/eAiP1ivZfsiYDWrxYGQvQefXsrESM4dXrYSCyf51UmHBPPwqHCAwLHe5VXABk4pmFNDxpdnxVpUqlUXbCwRFydAMWebY9MTE2uUSpuTtAfah+JslNVoaSVX9kE96JfQ5354e24iQAKscja/k7CW40McR8q/DC4wQX5zHjJlTa989F8bkxxzOmZb0MYeTzl8lIng2t9e53+AMRQyAVvzaiTNPKtL45T1m2rZOWFU4ACbZiCwWkty7LtU59Ll9fmsFSN5MzHKDHcrTLJ0ktxe1kr0EX4m2hTAtRM4PdG8Rj2IWTgs33+V1XKHFcsaw6Pz2SV9MRuqlHcI5QW0TCA17gHihO+Qy6ZMOchwdUI5oEmpE6qHpw78RNbsBDHQXcddXcvTPAa1+eK2Un11p6Iey4JieNsCSRW+JocOLgXY127por86oavcm6583NdfpK1RUNp/hKLzWVLw7LytyREGfRHZn1PLAILpCVwwjfRMvbt7BV35unnQCh45B3Z1of9e8eyCn2eMw38Oig4ITh7MaeJa0VJiV6g7wd7HSYHA9Sjq7tqZ7aNMyHXwF8IgOZbBtH/gTAxG4banLzA3egAwm7yLYoSacpOjaqXpNI5kswdTLAInh8qxKDBLyNGePY9ZITSG5v66GiUf/RSwzM7M4OfEm+xgOkUVh1vcGjD8ZmhdQeZAQH6zt7
 x77jtdAb
 Lr+H38POTMEBCjNHSI+1/hfwF7pPlMZ1TdFTG0HtpATiWaivHbUvpiNyaq/e6jJAN+3tlEOGpivkIcoC2juGeKR57dppKfmhmEG75szctppA5MW4CvzTUgC0k7vc02fcqHjxAbR38GR+wej/rZq5B5ji1rNNaHmusoX4XJmP3uqSjIOgX6kBzYctFZqGB7pt9cKQsTTdNDSk7qbmmvI+eq5DNYyn50UBHGpCzB2gRwvYcTyu0Lytvz4+eDntFCxXOPZ1Jze0TDxAYcZVLhCpCcwxcP6fxtXXI13TH1SSCAZU4LwE1TFnwltEDRvXysSCCtGG5IEerz/Y6qV83IUDHrJ4Zk79blsEt8PTwz8I86W7M28jvjvt34d+WNrp1VIJHRh5PY+dN3wV6cbiovXShBCitlfJUJTkEsa5FEc3ISwdvSbP0KXh+/0uluSBFbtKoKs9uYlOd9fnlIPcoW5UjgVj4DaU56UvYQhcJnZh11fhkxedLq3YwDnX+TJEAY/315x/ZpL9ilMUWmctHt53KVHydMRzXc8YhCjop7Ala3w+qhJ/X7cB0Tdk0mKyBGTp2mBY6/JKaNi2I3DuT0sWqwv8kbKIf1CUjFIg3bWFkghrj6Xetzw0gKNo9ixljkdJBjws5qZkidQYlnM8Sq2z4FDr05uwX2zEdTg0eeAjLI7VldWLGlr2Vn/3NWvfZM9WttgfC8ZncVV3EKO1eLwJhVy23stgeofyh097FR5CLIuwRrxYTHU1PEiednWzUxjQZnrKrxnyg7NOLSuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0836176935274178407==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Joanne, Yosry, and all,

With existing rstat updates retained, hierarchical per-CPU counters reduced
single-worker PAGEOUT CPU by 44.69% and whole-program CPU by 21.78% in this
bare-metal test.

One worker uses MADV_PAGEOUT on 32 MiB of compressible anonymous memory in
a private cgroup, with THP disabled and memory.zswap.max=64 MiB. The limit
is not reached. The host is an i7-12700KF with 20 online logical CPUs,
full preemption, LZO and zsmalloc. Unlimited controls change only the
zswap limit to max.

A matched parent/commit/parent test of 0efc297a3c49
("cgroup/rstat: avoid disabling irqs for O(num_cpu)") showed:

  CPU time, ms / 32 MiB         Parent A   Commit    Parent B
  PAGEOUT                       17.180     24.464    17.316
  Whole test program            46.215     53.419    46.235

PAGEOUT increased by 7.216 ms (41.84%) and whole-program CPU by 7.193 ms
(15.56%). Both versions stored 8192 pages and performed 8192 limit-check
flushes: a finite zswap limit forces a stats flush before each store.

To limit interrupt-disabled time, the commit
releases and reacquires the rstat lock after processing each possible CPU,
with cond_resched() in between and cpu_relax() if it does not reschedule.
Previously this was conditional on rescheduling or lock contention.
Per-page flushing repeats these extra operations.

On MM baseline 2967f3ccdb5f, I adapted Joanne's hierarchical per-CPU option
[1]. The limit pre-check uses dedicated counters, retaining MEMCG_ZSWAP_B
rstat updates and the IRQ-latency protection. Extra updates are included:

  CPU time, ms / 32 MiB         Base A     Counter   Base B
  PAGEOUT                       23.903     13.113    23.514
  Whole test program            49.247     38.569    49.363

PAGEOUT CPU fell by 10.595 ms (44.69%) and whole-program CPU by 10.737 ms
(21.78%). Stores were unchanged; forced flushes fell from 8192 to zero.
These two comparisons use different baselines.

Both comparisons used fresh A/B/A boots, two warmups and nine clean
samples per condition per boot. PAGEOUT return drift was 0.80%/-1.63%,
with maximum within-boot CV of 2.82%/3.55%. PAGEOUT measures worker CPU;
whole-program CPU includes preparation, re-access, verification
and cleanup, but not external cgroup setup or host-wide background work.

A single-worker unlimited control changed PAGEOUT/whole-program CPU by
+0.41%/+0.86%, with PAGEOUT CV up to 4.74%; there was no clear difference.

A supplementary A/B/A test compared the MM baseline with the counter
derivative, with eight workers pinned to different P cores, each processing
32 MiB (256 MiB total). Their shared cgroup had memory.max=2 GiB and
memory.swap.max=1 GiB.
The zswap limit remained 64 MiB; compressed usage was about 18.75 MiB,
below the limit. Counter-kernel means follow, with baseline-relative changes:

  Eight-worker metric, per 256 MiB   Finite limit          Unlimited
  Summed PAGEOUT CPU                199.238 ms (-84.04%)  196.272 ms (+1.17%)
  Summed re-access/verify CPU        215.365 ms ( -1.36%)  214.950 ms (+0.09%)
  Whole-program CPU                 663.404 ms (-61.39%)  660.535 ms (+0.24%)
  Whole-program elapsed time         94.618 ms (-58.26%)   95.183 ms (+0.99%)

Both kernels stored 65,536 pages. Finite-limit forced flushes fell from
65,536 to zero; unlimited controls performed none. Counter-kernel PAGEOUT
CVs were 4.51%/4.91%, with baseline return drift of +5.10%/+0.97%.
All nine finite-limit counter samples were below both baseline groups,
but baseline drift limits the precision of the gain estimate.
The small unlimited increase does not
establish a regression. Re-access and elapsed-time CVs were at most 2.81%.

Elapsed time includes preparation and cleanup; it is not summed CPU time.
The re-access metric includes reading and verifying the data; zswap
decompression was not timed separately.

Both kernels passed bounded leaf/ancestor-limit, dynamic-limit,
cross-CPU-freeing and cgroup-offlining checks. Deep cgroup hierarchies, CPU
hotplug, and 32-bit systems were not tested.

I hope these results help assess the benefit and update cost of dedicated
counters while retaining the existing statistics. The reproducer sources and
the measured counter patch are attached.

[1] https://github.com/joannekoong/linux/commit/9092e0057f038ffca43ae3f35faf58c33b1d7c9b

Thanks,
Chengfeng

--===============0836176935274178407==
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="zswap-reproducer.tar.gz"
MIME-Version: 1.0

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

--===============0836176935274178407==
Content-Type: text/x-patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="hierarchical-with-rstat.patch"
MIME-Version: 1.0

ZGlmZiAtLWdpdCBhL21tL21lbWNvbnRyb2wuYyBiL21tL21lbWNvbnRyb2wuYwppbmRleCA0ZDAw
NzQ4Li4xM2U3MDViIDEwMDY0NAotLS0gYS9tbS9tZW1jb250cm9sLmMKKysrIGIvbW0vbWVtY29u
dHJvbC5jCkBAIC02NzQsNiArNjc0LDExIEBAIHN0cnVjdCBtZW1jZ192bXN0YXRzX3BlcmNwdSB7
CiAJc3RydWN0IG1lbWNnX3Ztc3RhdHNfcGVyY3B1IF9fcGVyY3B1CSpwYXJlbnRfcGNwdTsKIAlz
dHJ1Y3QgbWVtY2dfdm1zdGF0cwkJCSp2bXN0YXRzOwogCisjaWZkZWYgQ09ORklHX1pTV0FQCisJ
LyogSGllcmFyY2hpY2FsIGNvbXByZXNzZWQgYnl0ZXMsIHVwZGF0ZWQgZWFnZXJseSBhbmQgc3Vt
bWVkIG9uIHJlYWQuICovCisJbG9uZwkJCXpzd2FwX2hpZXI7CisjZW5kaWYKKwogCS8qIFRoZSBh
Ym92ZSBzaG91bGQgZml0IGEgc2luZ2xlIGNhY2hlbGluZSBmb3IgbWVtY2dfcnN0YXRfdXBkYXRl
ZCgpICovCiAKIAkvKiBMb2NhbCAoQ1BVIGFuZCBjZ3JvdXApIHBhZ2Ugc3RhdGUgJiBldmVudHMg
Ki8KQEAgLTYyMTIsNiArNjIxNywzNSBAQCBzdGF0aWMgc3RydWN0IGNmdHlwZSBzd2FwX2ZpbGVz
W10gPSB7CiB9OwogCiAjaWZkZWYgQ09ORklHX1pTV0FQCisvKgorICogRXZhbHVhdGlvbiBvZiBK
b2FubmUgS29vbmcncyBoaWVyYXJjaGljYWwgcGVyLUNQVSBleHBlcmltZW50ICg5MDkyZTAwNTdm
MDMpLgorICogS2VlcCB0aGUgZXhpc3RpbmcgcnN0YXQgdXBkYXRlczogcHVibGljIHVzYWdlIGFu
ZCBzaHJpbmtlciBhY2NvdW50aW5nIHN0aWxsCisgKiBjb25zdW1lIHRoZW0uIE9ubHkgdGhlIGxp
bWl0IHByZS1jaGVjayB1c2VzIHRoaXMgYWRkaXRpb25hbCBjb3VudGVyLgorICogQ2FsbGVycyBo
b2xkIHJjdV9yZWFkX2xvY2soKSBhbmQgdXNlIHRoZSBzYW1lIG1lbWNnIGFzIHRoZWlyIHJzdGF0
IHVwZGF0ZS4KKyAqLworc3RhdGljIHZvaWQgbWVtY2dfenN3YXBfaGllcl9hZGQoc3RydWN0IG1l
bV9jZ3JvdXAgKm1lbWNnLCBsb25nIHZhbCkKK3sKKwlzdHJ1Y3QgbWVtY2dfdm1zdGF0c19wZXJj
cHUgX19wZXJjcHUgKnN0YXRjX3BjcHU7CisJc3RydWN0IG1lbWNnX3Ztc3RhdHNfcGVyY3B1ICpz
dGF0YzsKKworCXN0YXRjX3BjcHUgPSBtZW1jZy0+dm1zdGF0c19wZXJjcHU7CisJZm9yICg7IHN0
YXRjX3BjcHU7IHN0YXRjX3BjcHUgPSBzdGF0Yy0+cGFyZW50X3BjcHUpIHsKKwkJc3RhdGMgPSB0
aGlzX2NwdV9wdHIoc3RhdGNfcGNwdSk7CisJCXRoaXNfY3B1X2FkZChzdGF0Y19wY3B1LT56c3dh
cF9oaWVyLCB2YWwpOworCX0KK30KKworc3RhdGljIHVuc2lnbmVkIGxvbmcgbWVtY2dfenN3YXBf
aGllcl9zdW0oc3RydWN0IG1lbV9jZ3JvdXAgKm1lbWNnKQoreworCWxvbmcgc3VtID0gMDsKKwlp
bnQgY3B1OworCisJZm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkKKwkJc3VtICs9IFJFQURfT05D
RShwZXJfY3B1X3B0cihtZW1jZy0+dm1zdGF0c19wZXJjcHUsCisJCQkJCSAgICAgY3B1KS0+enN3
YXBfaGllcik7CisJcmV0dXJuIG1heChzdW0sIDBMKTsKK30KKwogLyoqCiAgKiBvYmpfY2dyb3Vw
X21heV96c3dhcCAtIGNoZWNrIGlmIHRoaXMgY2dyb3VwIGNhbiB6c3dhcAogICogQG9iamNnOiB0
aGUgb2JqZWN0IGNncm91cApAQCAtNjI0NSw5ICs2Mjc5LDcgQEAgYm9vbCBvYmpfY2dyb3VwX21h
eV96c3dhcChzdHJ1Y3Qgb2JqX2Nncm91cCAqb2JqY2cpCiAJCQlicmVhazsKIAkJfQogCi0JCS8q
IEZvcmNlIGZsdXNoIHRvIGdldCBhY2N1cmF0ZSBzdGF0cyBmb3IgY2hhcmdpbmcgKi8KLQkJX19t
ZW1fY2dyb3VwX2ZsdXNoX3N0YXRzKG1lbWNnLCB0cnVlKTsKLQkJcGFnZXMgPSBtZW1jZ19wYWdl
X3N0YXRlKG1lbWNnLCBNRU1DR19aU1dBUF9CKSAvIFBBR0VfU0laRTsKKwkJcGFnZXMgPSBtZW1j
Z196c3dhcF9oaWVyX3N1bShtZW1jZykgLyBQQUdFX1NJWkU7CiAJCWlmIChwYWdlcyA8IG1heCkK
IAkJCWNvbnRpbnVlOwogCQlyZXQgPSBmYWxzZTsKQEAgLTYyODMsNiArNjMxNSw3IEBAIHZvaWQg
b2JqX2Nncm91cF9jaGFyZ2VfenN3YXAoc3RydWN0IG9ial9jZ3JvdXAgKm9iamNnLCBzaXplX3Qg
c2l6ZSkKIAogCXJjdV9yZWFkX2xvY2soKTsKIAltZW1jZyA9IG9ial9jZ3JvdXBfbWVtY2cob2Jq
Y2cpOworCW1lbWNnX3pzd2FwX2hpZXJfYWRkKG1lbWNnLCBzaXplKTsKIAltb2RfbWVtY2dfc3Rh
dGUobWVtY2csIE1FTUNHX1pTV0FQX0IsIHNpemUpOwogCW1vZF9tZW1jZ19zdGF0ZShtZW1jZywg
TUVNQ0dfWlNXQVBQRUQsIDEpOwogCWlmIChzaXplID09IFBBR0VfU0laRSkKQEAgLTYzMTEsNiAr
NjM0NCw3IEBAIHZvaWQgb2JqX2Nncm91cF91bmNoYXJnZV96c3dhcChzdHJ1Y3Qgb2JqX2Nncm91
cCAqb2JqY2csIHNpemVfdCBzaXplKQogCiAJcmN1X3JlYWRfbG9jaygpOwogCW1lbWNnID0gb2Jq
X2Nncm91cF9tZW1jZyhvYmpjZyk7CisJbWVtY2dfenN3YXBfaGllcl9hZGQobWVtY2csIC0obG9u
ZylzaXplKTsKIAltb2RfbWVtY2dfc3RhdGUobWVtY2csIE1FTUNHX1pTV0FQX0IsIC1zaXplKTsK
IAltb2RfbWVtY2dfc3RhdGUobWVtY2csIE1FTUNHX1pTV0FQUEVELCAtMSk7CiAJaWYgKHNpemUg
PT0gUEFHRV9TSVpFKQo=

--===============0836176935274178407==--

