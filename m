Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF501093181
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 07:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DBBA6B0095; Fri, 20 Mar 2026 03:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2BD6B009B; Fri, 20 Mar 2026 03:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8916B009D; Fri, 20 Mar 2026 03:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD076B0095
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:24:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC2A3BB9CC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:24:45 +0000 (UTC)
X-FDA: 84565604130.04.06813A9
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1583E20003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:24:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dn8Ol/Wn";
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773991484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=j3oO0H+IHOvckZ4fHjT6ZGAeH2S4hcY0XM+PwetfF5I=;
	b=iMMyj/5CZdHzzabkDLfm3SnUPPbVQG/c/DDFFEyeIy9wyY2iVmrWuRkuNlqaeRs0QmEHeP
	3IDWxjLOauJxwLOs6cWxg/KSOqpn9d52gUpsbMsBE92db1UPvYfw0lT46rdAy82lRu8LIS
	5bxA5SvBbbU1uUTuujowl7P/BapzjEc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dn8Ol/Wn";
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773991484; a=rsa-sha256;
	cv=none;
	b=d3/HXocWjzf7WBJDGr0rZ3IEyL/JzfAuKH6DbJUZFj1AkXL//M/xoYRfdyRjE/9YVswmZ/
	/tLGS8uTFNv9+g6gIhxL1/fdzKBL2Ao7+EehIhp8W5+o8YYWlVRdOJ/93Ki0ba6jkUApJm
	X9HdLanrKWPE+U54xHdCPPG/k2KIlrE=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b0586d5bb8so11017045ad.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773991483; x=1774596283; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j3oO0H+IHOvckZ4fHjT6ZGAeH2S4hcY0XM+PwetfF5I=;
        b=dn8Ol/WnchuCLwYOHFaS3RsPX/H1VtwvneLTm+64Ti7qo2JwJ8tGiY5ckXQkXRnQ+4
         8KloX3HpHjBhMBS5zzn5CvgAaAktPFX5CbeNYsmOe3biFUefEa5Jt7C8zt9KNUG3Yv9n
         cfOe53CoZwyLvwA5YRpqwa0ttPP8TlyLwwUGsOGdAildEnqw7itws0fMs0e/97cwBgZU
         g+0UEEq9a0eYhDuzytP1FqEMgU7Q7E6B7L5sdMpRj/cUNV8JgKIRrfioU0dUNDqBJFQV
         TPclYG+DrHaAGtbXws8ev5rpAsyB4hHoLLoF9KgAG54caZCDdSQjgI0+qjdG92c2ZG3z
         JCDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773991483; x=1774596283;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3oO0H+IHOvckZ4fHjT6ZGAeH2S4hcY0XM+PwetfF5I=;
        b=P24+tV/JjaZiM51zZTi57uoV/goDFy9NxdnoAQH2h9pKfbN6rv/XT77YxM90Sh8nxs
         +I2Bp3UZ+wd9lZJzROhqPjRtBJ/Lkf4Wr/chq0DWNvDR28nIHF2Z9+671yQnb9g/PyVw
         giT685HHmvSRn7BoD3tW7uhEKDAT8Fc4UMOpql8H5Rm94+XYD62C2BSsZ4hUjO4VfofU
         D6Np94VdLW3QYt89ez7nd+TBPUexKe74lPxStY7rft6ACJ0AqWf5SAqagY5rUFUmh44y
         9gp3G4YGpEL0r8pRrwF+2y4a/aCPEC/BZFe9FqFos7DOnAjCQ5UZBTQsf/X4zVTE/N+9
         a6lg==
X-Forwarded-Encrypted: i=1; AJvYcCVk4HqkkEvW0NZX4G1AARwf66hszubILMezcATaMhf5ok92z0GShzmYC7XZfO3rv8xhtV4Xwj4C0Q==@kvack.org
X-Gm-Message-State: AOJu0YyNGwo5jIgorVN/Q+kHS1Zf8gG5SgLav6IQ5/TR5mWw8izHqd0O
	4d93JXCU6kiZM/C78jOkkFgOhNHGWtsmKbKiQ6437a2dR3XloBwZE9Da
X-Gm-Gg: ATEYQzxNi8ShLfgmFN8afXXPF81aT4gxBaiB/QVDiUUQea3oN903XlG4vlZq8me8WZB
	ByF/5GLHeLfLYbnweo1G8hMf/acugmHS3+Vtzxhbds3iFiBFKvNbaW+3e8PanQpY2RzoO7DRUGK
	cjYr/ccaqBC9oDH0SNwFh9ysu48yPl7s1T9sUp/ZPMuuix8G3dWY4k6LARapFE82KvXBWZfC59x
	KJqobTfL9Y6FY6wn4xcWuXEk49+DWHTgb/UPqcBO4x7BTchpU8jrrOvka9VCVRmXSOGH1XJRE9d
	erj5XopoZ6Ixm8HiXSyarh+bcAkB89pIJjAQE5cI+g9e/FdbxqLPn/KvxJCNEOeNEKOm0kkFG0n
	w7OD3cdNYZNCUIIjfv2zRXIJXNyPcpk+UMImtVXauQbXVp2VcOo+rxJe/usuuO14lXJhGEVhDXU
	cwiVDUTfMNgKm6wxMFj198cC6g8+E=
X-Received: by 2002:a17:902:f549:b0:2ab:230d:2d96 with SMTP id d9443c01a7336-2b0826c6909mr22728955ad.11.1773991482819;
        Fri, 20 Mar 2026 00:24:42 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516908sm17542935ad.1.2026.03.20.00.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 00:24:42 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH] mm/damon/ops-common: optimize damon_hot_score()  using fls()
Date: Fri, 20 Mar 2026 15:24:31 +0800
Message-ID: <20260320072431.248235-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1583E20003
X-Stat-Signature: pu1rrqipbk7qoewhbdids4q9qq5yjw8o
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773991483-959224
X-HE-Meta: U2FsdGVkX19A6AY4bCdUDYtB2svwA6kyb7925iS6ASfWAX7npBH0ggeQDQv48EHEi0xqpEpLRGXq5bxgJOqF1uloC552SL72yewV+t/pUDEj1bSZ8TO4fKXPTn83DdtJh5Q9oNkAbChpCUldxhCCYEgkeF02suN6t19Y2C0L8SvbrE9ls98INtYavmHBhbfyEu4t2Yjttx45i+2cE2k9NtyeRSMEQjtkh67R1VGuBQ7jUMB79twEDDP3O4ocxyvpf6Avfljdej/qmN1eb+3mONWa6OmVnbjeEJufOxPY7K3OkGgBiVWBpNMJ/HeeCQXaLTIFwtZ8W+nfqT/NwvU6tU4P2mfTayj1jhFFaU52s3d44i5tBG2KqVqdxzorxQRSFD8yuH1+8umHqBmmZ2md/7MToyA4o1BM/r00cgdkihl/rlJpR1ARj1POi7tJzxc+MCSchU7lHAnHJzxCpCEoRdS8QlWX2Gq/YyhxsqpsyvzmI8zjf7wiaswxNhjjGPMI7LOcpixyIbVUnmFGKzM0EcujXFy1u22/14StxsslCwaoawMMVcM15LFS1eYPaVrKE/w7lt6lTSh7Vtqcwis1sdokVrBrnxsypn0I5DTKf4xWsb/u1cYFGPLcRNGBHcl0HKNbatxMmEjBOFJkDUA6fHZlp8SYj5QSkK3htLvJN3U0a0fvRrbyyAedlPpCuGfp0RSEsFrDMrt6XvrDVRxzO7Hye/w0T0Jj2Gh1pN9fI0e7kafwo4CaRW4/d0fbbosahd0+ssJ2JNuKXdM7QhJqy7c3DPYKjrh+0s5fYX0DpTe6j/eT+jdjLkT+UcgMbZqqNc7vbWsbv4CAdH7lErZRl9dwRDzUqvzT1coNPAGK8hyj0IovuBkItlgZhkggt9NHBfE3a4U8ar8eVuYByUMKyiZWchJIev2W7rLd7mE3J2AH1vjJdPSV5tIHjD/zspTeVggmxl0VJb1TAIwA/r5
 JYh/KON9
 r+cYIP9mEhCH42F/GMpIjzHY5bAAR3RFgIqe5niC7YoVGMJp+n0C16cBpdX8knsor9GcuE23tcDnw2ik1+FVWUAWKMbi9cL1XEiZhaVu1dYFWog+MhYbl1lwL6RY+i9uhLECpMYETgc/i8zTi+GxrWA+GUsChNAF/KB/Gp2UihrhYYJ8ecthSJbOQW6YXiT4JIUcsceJm2QDs3CxWldC8plOMRAHncgjt86g2Oxop3uUXH/k2btC8uoljfza8f1FL0KQzTNhBh1vA8HIfiP9MXwWy5emd4iNaEgllSOMp5xbrXH5rbx15wHFNfl1wM+Or/INSdLh5jb7XLPJLEsk4MPtVhdcxe1+Azux2rE1Du/4APIHmreDqpd7xffGqu1it59RbmU+P2XbqhnZBm0vjcGrrO1UmauW8UZcEGDHQ4Yq1Ebroj/yLNxE0hqX+IUsf1BQlUdDJNNb2vZS2EHJXKryHWof+A62+oLpU78s6s7DykreO3IvSvXlaSrngPnWCMa8kVvp+bswj6rchzOhmYP3WikZjMRu5gfcHKfTlo/XPF5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current implementation of damon_hot_score() uses a manual for-loop
to calculate the value of 'age_in_log'. This can be efficiently replaced
by the fls().

In a simulated performance test with 10,000,000 iterations, this
optimization showed a significant reduction in latency:
- Average Latency: Reduced from ~9ns to ~1ns.
- P99 Latency: Reduced from ~60ns to ~41ns.
- Throughput: The loop-based version mostly fell into the 40-50ns range,
  while the fls-based version shifted significantly towards the 20-39ns
  range in the test environment.

Although these results are based on a simulated kernel module test
environment [1], they indicate a clear instruction-level optimization.

[1] https://github.com/aethernet65535/damon-hot-score-fls-optimize/blob/master/test-kernel-module/fls.c

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
Note on testing methodology:
I attempted to measure the performance directly within the kernel using
bpftrace, perf, and ktime inside damon_hot_score(). However, the results
were highly unstable (ktime), and in some cases (perf/bpftrace) the
function was difficult to trace reliably (likely due to my own tracing
limitations).

Despite the instability of in-kernel ktime measurements, one thing
remained consistent: the fls-based version significantly improves the
"long tail" latency compared to the for-loop.

Test results from the simulated module:
- fls-based:
    DAMON Perf Test: Starting 10000000 iterations
    =============================================
     Total Iterations : 10000000
     Average Latency  : 1 ns
     P95 Latency      : 40 ns
     P99 Latency      : 41 ns
    ---------------------------------------------
     Range (ns)      | Count    | Percent
    ---------------------------------------------
     20-39           | 3522000  |   35%
     40-59           | 6478000  |   64%
     60-79           | 0        |    0%
    =============================================

- for-loop:
    DAMON Perf Test: Starting 10000000 iterations
    =============================================
     Total Iterations : 10000000
     Average Latency  : 9 ns
     P95 Latency      : 51 ns
     P99 Latency      : 60 ns
    ---------------------------------------------
     Range (ns)      | Count    | Percent
    ---------------------------------------------
     20-39           | 0        |    0%
     40-59           | 9894000  |   98%
     60-79           | 98000    |    0%
    =============================================

Full raw benchmark results can be found at [2].

If anyone could suggest a more robust way to profile this specific
function within live DAMON context, I would greatly appreciate the
guidance.

[2] https://github.com/aethernet65535/damon-hot-score-fls-optimize/tree/master/result-raw

 mm/damon/ops-common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 8c6d613425c1..0294de61a23a 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -117,9 +117,7 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 		damon_max_nr_accesses(&c->attrs);
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
-	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
-			age_in_log++, age_in_sec >>= 1)
-		;
+	age_in_log = min_t(int, fls(age_in_sec), DAMON_MAX_AGE_IN_LOG);
 
 	/* If frequency is 0, higher age means it's colder */
 	if (freq_subscore == 0)
-- 
2.53.0


