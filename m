Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F576C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 08:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516806B0005; Sun, 28 Jun 2026 04:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7EC6B0088; Sun, 28 Jun 2026 04:51:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD516B008A; Sun, 28 Jun 2026 04:51:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 104096B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 04:51:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82E641C22A3
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 08:51:50 +0000 (UTC)
X-FDA: 84928703580.12.BC16D87
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9E0BC0002
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 08:51:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gQZnBz0Q;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782636708;
	b=K4Tyk6UAbw7SyI1gl5Ld7qFFc7pmaBa035UtLB2rmtztlb83dbuHcaIQhhWRdTeFwvbbWF
	gmd0ZGWXd0lYOHI5SnzT7KIJuy41VZTxCOMgeMGGB1Alb2SllKA4TDA4BU6sYGlOdN0OEg
	mOAMtR09Pvtg0Ejk5zZ4Q6ahmvMYCL4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782636708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ohO+OwbdAfufkBqI6zk4RS/rHxcAGR+JiWSi+OVMae4=;
	b=bY3/bt5fOpvRr+rWOX9glk2fYXfB1Ia/6MtvfOeHs57CUJw9bHN6Yb8edPTC5oMTfIvdwB
	P3Ln9ZqM8VSV29B5Vvc51GBtqxgKiRzZ1bkSRTi57AlfXqoxR/mcfilpQldPx5c2KKsFQf
	vRDEJYZCwxr/msjmOkT2E8h7d6Uzwso=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gQZnBz0Q;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c9e89fded0so1689655ad.2
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 01:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782636708; x=1783241508; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ohO+OwbdAfufkBqI6zk4RS/rHxcAGR+JiWSi+OVMae4=;
        b=gQZnBz0QI3mxjBPhxbbRunxlevzrJILNC9eEcsBN+n8iDsP77E5yPvfE5/MCTKKVsy
         q8FuSs3kTeNjMQnc6cvCF1+moB93JfE7WVpIjp+D50Lcwg3CFn014fK+2mV8mj1IvKKT
         PizSCpXvpPvO+phv05d8xu+26hO9+Z0lCNy0hIOVvpiYmWFjXzLjc4Om0mOlsTHOGJRl
         AiI7slv7s7Sn1MBf9lIEHtxYvvstWnVg/5qFf3fguMcxWA7PY4EetWHhHhebtaVY3/66
         hCIqsTpSv8GDcNW/Wqty+QyC7XsyxQgXalNu1iTQ+9LtE5F0c2kpCIMUfGWMVI/UviE+
         F8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782636708; x=1783241508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohO+OwbdAfufkBqI6zk4RS/rHxcAGR+JiWSi+OVMae4=;
        b=lAGJV6vZ8Puae4yUi7CkB0uzZd3aK9KUe7WzgZx5EVw0IJSgo/dlUOY5w4PIcRFM+N
         5Y1239rRc0M8fnuuwMriqi6Z/w5Up9Z7hP02MJle1fL0VOarfdgvhHJHJv+psbK3b+Vi
         tznMua/4YneS2v9k52ONjgWjb+YTnPW18ER0yCEUFNAFJgcKYiRaZRpi4rFPYp/DZk+V
         D+m3k2BjOOoGlQzvk/6X1qQynlAHFx2GxXTvTyVrtExKwIqFbXrY2/eL5fgYECpMMVMn
         UCwiiIMfXAKjj/vus4MF4UlauPiSFg0cL69R2AEFLfE4oaRPpJFQWrzsJ45s3ivHAsSj
         /nNQ==
X-Forwarded-Encrypted: i=1; AHgh+RrNDiaK8feDeNW6X9O4tlhoPiUjKfFrFDdyq1jzZ8Hnb8kIhEXTT0e8sJAjT43Ck5vg0oPoBZaGDw==@kvack.org
X-Gm-Message-State: AOJu0Yw+Tm+qny2HbJety28t6C2yoM3WuEtlXhd4zEpWxbYK/lT3hX8n
	c371FA3U3gkbC1srPlx9oQlFKihAlD/g3sAyb93VuKGLRStAmZB9uogl
X-Gm-Gg: AfdE7cmpn+ZKpBT7X42faAAelp+x2VZPQ2epNNrcH9dAPL2z4f9KXb9Vm4g00A3/MgT
	3+C2LrrSNlXzrLbQ+uaIQvF4d2/DgYzdLNJkA2Yhat9WpNioY4kblb81WWLMeiG6OkBflUiDR8A
	FIPk1fbYQjqehlsaHVQmBc0H2xRZFyee9Y52Ph3LcVrpBSZ4Qgt5FJB+fQf+HwODwwlEMMQt1zH
	bzpoFUsQY/0urcqTHuGq7YVfAr6PQ6PnhZCd33aIrBa98D0XxgkntOfj4TpJ+40vifSj+tRrQnZ
	ypN3gEbMh2GYHmbZyqaG4zNBuBD80RKDmJa0F3wwy6yW2vueJ4m12rXJuIzZzNgmo6t78Uq1es+
	L8CAU7Hpm4EOddhhK2fL7jArJ1aHzwH3KhUvbFMVCpgSSQTM7oRgxwIx+uHNEJQUoAsLKYX9+p6
	UJKP55HsQJLAfjNnCkYMgQTyqDg+BkkID+cgtgkk5h6N6QyHVvKSE=
X-Received: by 2002:a17:90b:37d0:b0:37f:9ce1:735f with SMTP id 98e67ed59e1d1-37f9ce1744bmr4556248a91.32.1782636707462;
        Sun, 28 Jun 2026 01:51:47 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9a5:e298:5467:317e:e807:794b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37fd2bd0e49sm1712595a91.0.2026.06.28.01.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 01:51:46 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC] dama: userspace DAMON_RECLAIM min_age autotuner
Date: Sun, 28 Jun 2026 16:51:55 +0800
Message-ID: <20260628085155.20828-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C9E0BC0002
X-Stat-Signature: 4otcpnon6xihp36wsp7ouzbm5bdysh7r
X-HE-Tag: 1782636708-950121
X-HE-Meta: U2FsdGVkX1/mq8lTgzyqD65sRsYjy9KD3/TrXlPSx+Sdx7HhVxAkzDydFIrV3y9zgBjsJ8/K1FmdVcwplosy20OM+24xYvVBuddDxqRAdfjolzaSRKTaptwc5+/WBlYiK1SHfQrW1JfkkbVAYW6rDTcx96zwTNK/jltaL13O/4KsiISML69qe7uzcaiJmftobn8B6DcS/PMzUb8NsWQg9ie851tPVoGJuP0e2tA5D71DdqVTlHLLtPAjdrMTBrLnxvMoD5ODT3/zgNPxfKc5OQBnGgF+1AvEBj80uRcpJBlpfl0v2sfgbFuDD3ZbtauRUClESh48ZFukMAmIkPOk94J66qPmBjbURA2MnvTdT7gisRFC/N3n67uTXoMeNXMu4TkMMZzBIlLkSN0pJThnoEw0cyrYcffvGypW+i824F52laBn9YKINPQvTHjdvG2VEktLaLJlQZ52c5cmFDXncfsav0StSre9bIb38pE/8FUNJL3pBIY/JTSWZPIN4+K6LLRVS9cwtZjSooxp6OPL3SKpvUjaH5vVmbAuc+TYl1McQZaygJuxanAeHo/F9hc61lG0qoikQUZZcsrIrPVWI+aUeBCEVVrseRE3i39p34ZyMMNdv29IgJ2Rx2uuIYniHYTqS9NoJXTMEqRTf/p9Gu/6kCksit4Z7iSihFEi171KqFVdKTHhzeNaao2D8neoJA2ni/Y/ppQzh5zq46yWifCMrnzcaeaRVwWg7AH77rvqwUQ+x7X63kUwnG+z23rQ68vyOZh/XgycgLUw2s3SHa2YBfnmICzGa1cBeW9sQaScga7pZVPq1nL3RRJNMC+hX3b4Wvbht+Ycz0S1YHmcVpT46N6oTut9MLfhps2ZnIN398Y+HDnHf0IT2d7KEB7s8HKlya6dgLBsphFcvNkIND71vajEkjY4+VMJfOHkGunV1O0w1ZoIfg3c5jbsjBlMjMBKU9thv52yiljBc91
 YELR/g3S
 ISIeLI79Y+ZNTQnmKvGnEBoV7LxM6tYp5Fe1VmiVEhFQajQGX36Ub5hR/TleHwPEl7gatDDxkz8pYEKXdziI8PwScQeWEIuX5c7perdZURB30D49h2+XRqfg2qt1p3k8Hr7TtMf1Vms4vgx/PrAmNW/hC0HUaBicaTHV+mk6teoZKQDTkF6QC3PoJbg+k7VmCE3/CDhP8HC3Id6Y1EqUo5PuMN/aOBPdh5jvlmoMps0T8GI212IvdFtLiiW+pqS65EGbgGV/TDIkqS2D4Kq9LrnB+8FjrOCMVw+b99zfqlsKYesAuttLYJDlQ6uWxIoIDTpXQsXnLVKjBfvnR8/awN33TiBPKIwNDvlYruatWoKxwb8DmqIyLeToLv15q8LfdfdhV2LRbKU1Rgj1Fg0qOxD5tS82dEJCOwNCpRRGhHfOj8j/zDDyjNUULt1+GlXjNkyQm6F7O4zGVO4uLYjLPDU5aXkRu8oMgciZera/EbESGA03n7Bgvo/kb9ASEumWW7Qhj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi DAMON Community,

I've been working on a userspace program that autotunes the 'min_age'
parameter of DAMON_RECLAIM, aiming to reduce unnecessary proactive
reclaim. I call it DAMA [1] (DAMOS Autotuner/Assistant).

Test Setup
==========

I wrote a synthetic test using Masim. The workload runs for 30 minutes
with two repeating scenarios:

Scenario 1
----------

- Full access (100% of region A) for 30s, then only 10% for 30s,
  repeating.
- Theoretical optimal min_age: > 30s.

Scenario 2
----------

- Cycle through four regions {A, B, C, D}, accessing 95% of each for 30s
  before moving to the next. A region is revisited every 90s.
- Theoretical optimal min_age: < 90s.

(Note: because DAMON default configuration does not partition regions
with high precision, the theoretical bounds are not strict in practice.)

Results
-------

I compared DAMA (starting min_age = 10s) against three configurations:

  - Default : DAMON_RECLAIM with 120s fixed min_age
  - Custom  : 60s fixed min_age
  - System  : no DAMON (kswapd + direct reclaim only)

All reclaim/refault counts are in pages. PSI values are averages. Fault
numbers are per-second rates.

    |-------------------------------------------------------------|
    |           | DEFAULT   | CUSTOM      | DAMA      | SYSTEM    |
    |-------------------------------------------------------------|
    | RECLAIMED | --------- | ----------- | --------- | --------- |
    | DAMON     | 0         | 27 648      | 669 274   | 0         |
    | KSWAPD    | 4 876 306 | 5 259 842   | 1 817 669 | 5 341 815 |
    | DIRECT    | 12 670    | 19 697      | 1 479     | 20 114    |
    | PSI       | --------- | ----------- | --------- | --------- |
    | CPU       | 0.06      | 0.06        | 0.06      | 0.06      |
    | I/O       | 0.00      | 0.00        | 0.00      | 0.00      |
    | MEM       | 0.22      | 0.23        | 0.08      | 0.23      |
    | REFAULT   | --------- | ----------- | --------- | --------- |
    | ANON      | 4 462 273 | 4 858 679   | 2 015 817 | 4 915 695 |
    | FAULT     | --------- | ----------- | --------- | --------- |
    | PGFAULT   | 1 317.48  | 1 428.33    | 575.10    | 1 443.96  |
    | MAJFAULT  | 1 239.70  | 1 349.85    | 560.25    | 1 365.70  |
    |-------------------------------------------------------------|

DAMA significantly reduces system reclaim, refaults and major faults
while keeping memory pressure low.

Masim Script
------------

In short, four regions share 8 GiB:
user_A_sysadmin (40%), user_B_student (20%), user_C_drive (20%),
user_D_bad (20%). The two access patterns above are looped to fill 30
minutes.

Here's the full Python script to generate Masim script:

    from masim_config import Region, AccessPattern, Phase, pr_config

    KiB = 1 * 1024
    MiB = 1024 * KiB
    GiB = 1024 * MiB

    SEC_MS = 1000
    MIN_MS = 60 * SEC_MS

    total_mem = 8 * GiB

    regions = [
        Region('user_A_sysadmin', int(total_mem * 0.4), 'none'),
        Region('user_B_student', int(total_mem * 0.2), 'none'),
        Region('user_C_drive', int(total_mem * 0.2), 'none'),
        Region('user_D_bad', int(total_mem * 0.2), 'none'),
    ]

    phases = []
    
    # Scenario 1
    # ==========
    #
    # Loop 30s full access + 30s partial access.
    #
    # Total time: 30mins ((30s + 30s) * 30 loops)
    #
    # The 'min_age' should not be too small, otherwise it will cause many
    # unnecessary proactive reclaim.
    #
    # Ideal 'min_age': > 30s

    for i in range(30):
        phases.append(Phase(f'scene1_high_{i}', 30 * SEC_MS, [
            AccessPattern('user_A_sysadmin', False, 1024, 100, 'rw'),
        ]))
        phases.append(Phase(f'scene1_low_{i}', 30 * SEC_MS, [
            AccessPattern('user_A_sysadmin', False, 1024, 10, 'rw'),
        ]))
    
    # Scenario 2
    # ==========
    #
    # Looping {A, B, C, D} with alternating 95% access.
    # Each region is re-access every 90s.
    #
    # Total time: 30mins ((30s * 4 times) *  15 loops)
    #
    # The 'min_age' should not be too large, otherwise it will cause many
    # system memory reclaim (kswapd/direct).
    #
    # Ideal 'min_age': < 90s

    region_names = ['user_A_sysadmin', 'user_B_student', 'user_C_drive', 'user_D_bad']
    for i in range(15):
        for r_name in region_names:
            phases.append(Phase(f'scene2_{r_name}_{i}', 30 * SEC_MS, [
                AccessPattern(r_name, True, 0, 95, 'rw'),
            ]))

    pr_config(regions, phases)

Algorithm
=========

DAMA's "DAMON_RECLAIM's min_age" algorithm is a periodic feedback
controller (core.c:reclaim_min_age_calc()) that balances DAMON_RECLAIM
and system reclaim to keep refaults low.

1. Accumulation & Decay
   Each cycle, DAMA reads the delta of DAMON-reclaimed pages, system
   reclaim (kswapd + direct), and refaults (anon + file). These deltas
   are added to two independent "remaining" counters:
   - damon_remaining  (for DAMON reclaim)
   - pgsteal_remaining (for kswapd + direct reclaim)

   Simultaneously, the same deltas are accumulated into long-lived
   metrics and continuously decayed by a fixed factor to smooth out
   short-term spikes.

2. Threshold Gating & Hysteresis
   An adjustment is only allowed when one of the remaining counters has
   built up enough "credit":
   - If damon_remaining >= DAMON_THRESHOLD and DAMON reclaimed pages in
     the current cycle, the controller considers _increasing_ min_age.
   - If pgsteal_remaining >= PGSTEAL_THRESHOLD and system reclaim is
     non-zero, it considers _decreasing_ min_age.

   Once a threshold is met, the _opposite_ remaining counter is rapidly
   decayed (multiplied by NOT_WORKING_FACTOR) to prevent the controller
   from oscillating between the two directions.

3. Decision
   - Increase min_age: compute (weighted_refault * 100) /
     damon_reclaimed. If this percentage exceeds INCREASE_THRESHOLD,
     DAMA assumes DAMON is evicting active pages and raises min_age
     proportionally.
   - Decrease min_age: compute (weighted_refault * 100) / (kswapd +
     direct reclaimed). If the percentage is below DECREASE_THRESHOLD,
     DAMA assumes system reclaim is missing cold pages and lowers
     min_age proportionally.

   After every adjustment, the refault counters are zeroed and the
   metrics continue to age, so the next decision is based on fresh,
   representative data.
   
Question
========

Synthetic tests have clear boundaries, so I'd appreciate your thoughts
on how to make the benchmark more representative of real production
workloads. What memory access patterns or workloads do you usually
consider when evaluating DAMOS self-adaptive capabilities?

I'd also love any feedback on this userspace autotuning approach or
suggestions for real-world testing.

[1] https://github.com/aethernet65535/dama

Best regards,
Rui Yan

