Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB748CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B657C6B0092; Thu, 15 Oct 2026 10:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CFF6B00A3; Thu, 15 Oct 2026 10:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53196B00A4; Thu, 15 Oct 2026 10:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80DD36B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:53:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 034291C3DC6
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:52:59 +0000 (UTC)
X-FDA: 85325152920.04.AFFE443
Received: from mail-qk2-f11.google.com (mail-qk2-f11.google.com [74.125.230.203])
	by imf14.hostedemail.com (Postfix) with ESMTP id 73A5D100003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:52:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PgBlZkeV;
	spf=pass (imf14.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.230.203 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=XdRcwxlD3pWCchI2KWHsVI/091IqM4MFlf7NS18N65o=;
	b=DrjwKN0ZzDbAuOV24+VkW4FDqhkddajRmVTXv35hb3W9Dpf5tBctp4Sgy6NcUfI6iNBIY9
	fuhX3XxUlK25mF9o4d0YsGcCKFAOiPJNc8/6JRnms4U5/81CLpCYFZZ82q2rcYyZzNNh3U
	DC99lj5Ed99KpP6zrmhDR70tDsKq+00=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PgBlZkeV;
	spf=pass (imf14.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.230.203 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792075978;
	b=MCBTkFXVhpkxA6Lv5ingt5aRLmKhWdOtd86w6tnY3nDPOq1YIyPBhFn4rkopbfgUGtPRk3
	1322j7rh3zFI2FORhqxkCjfml3MqGJLVSfTkSrsuyu5oD+G6Zswo+FvPjBGRqOLM1tdkFX
	vT8fyfaH2zyovE3ZY4j8k3i8CPdr9G0=
Received: by mail-qk2-f11.google.com with SMTP id d75a77b69052e-53503aceef0so28607581cf.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792075977; x=1792680777; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XdRcwxlD3pWCchI2KWHsVI/091IqM4MFlf7NS18N65o=;
        b=PgBlZkeVO1D5Bd3bIIV6fu/1+rv5bhcDNZlQv1rloHZy/ZRChQR16orrBXJVYggPeG
         ngFM2kJbXA0cew2YkGzFeadeO9rO79KmUUtacaquidn7YIfzk9fVl5xfVlnd5R/nT1QE
         C4OBMKEDU5LRhKWzOfCWkrIOXVtAEwKavZ8wLcKAo8q1cznxvidZTa6V3m2LCGgmIiwb
         5xmuxsr0bemneXMZsE8cny6NULtdVgDR/dlJKqXE6pFKblYH6+HdJ/9Ce2G3iQ8sa4Wt
         XZtP3Fk0ONKkeQFffeWs4ONlIny1hPqvHtd4z8o3WAyR54mk4gZVity7Ugic20xNXxx8
         9GFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075977; x=1792680777;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XdRcwxlD3pWCchI2KWHsVI/091IqM4MFlf7NS18N65o=;
        b=W6CZIgS4etDk7z5y+EuZthcPPhPHhAkzgJoVuAvN77GqNhtorjaGOJ5iidJCpZsjf7
         9+ncQw+2Mm5A3jqf4OguQTJ0/3ivbN5BjlUPIHNgPJyPG07gPSB1QzWYabbBKIr078u/
         KLsiotPfGquGqJHru3Zdaq8rSOmqR/C9aVkff6E6rtNSR8v+2WduH9yKIJWI3pXmB5c2
         a/pwNxvZB2WwY/u14pIOnDsfh2slYLGmrluZkt1BZ8LefYveSFF1XFvqR/Zgplxme187
         8XmOVrURMUKr4kOlMAB+K2pQ3hDBQlYV7veuWoTA4ur2uScqGgp7NSelqm3rJTCK109H
         SlSg==
X-Forwarded-Encrypted: i=1; AKwUvBy2lqJpL4x3pTeUVQuWu3g8kcFtvOje8J5GmeNFIiB3gZq+jU4cTjxw1xkFGhy2D0VIQw+aGheZeg==@kvack.org
X-Gm-Message-State: AFq9FYKZpVPOZRyF60GVG56npKvgfGyEwKwrUhdtk+hpDjn8ASRb2BJX
	tJlZouPtEhXS81KHlU7/VmExabokgq0DMeCsOrtcqR+sQt3SO7UAN5BhJ4R9ZrdcmRwEDCKC
X-Gm-Gg: AYBFou2nEsZwTfN00+v4ifRRqvugA3F/lCj/rBiIcTMYlqU+jUfJcT/KgytoeFvi2/x
	90iDSN6Hq7oaXMp4ucj44JUWJpDI9HKeKjEhx0hrL+4QLbf0BsKx62FvTTrySaNLW+9Q5Z6AWSH
	I6SGdCfXRmDY9G5zpS3Tlm0OeDga3wLIhM6dm0Dh/VhYRK7F8molcF9A1GoCAdv+ibJFMD9LIn0
	AkY/F54x0zPKAuzx5vTSGOG5RDg/HC+vi0WqcR93cQ/GB2dvQmrU0RaKbG/agt8EJ2nyWp33oU1
	4ulOg8fDKNkTlsPLjKFv4D0uBvCC6Ni7brCpDVCqie8ZluV9cxJ07qq7zqLnYz061uD2+0KHM3R
	7FCYdwoCBIXIZ2RjXXt83LcmEGknkStqIL0c7evdPr1YZTNkksOTC5wycwst93y28Z1mWEisu2U
	J2IrSBmIfUUKFFvvHTOAUc48DJdTNA/lFbwpI12o9IXPf3RgTXgfhIDBZqzpUo6GSf+5IEgZ0zY
	Oi0on0BtUyMv+E3
X-Received: by 2002:a05:622a:e19c:20b0:535:cd9e:bfc8 with SMTP id d75a77b69052e-535cda027f6mr141795071cf.77.1792075977484;
        Thu, 15 Oct 2026 07:52:57 -0700 (PDT)
Received: from [10.131.15.42] ([115.200.102.144])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536127c62d3sm27173261cf.15.2026.10.15.07.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:52:57 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/damon/stat: avoid 32-bit overflow in idle percentiles
Date: Thu, 15 Oct 2026 22:52:04 +0800
Message-ID: <179207592479.3.11595453180868898703@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 73A5D100003
X-Stat-Signature: apud66sgmksp3mrc4qpp9gjkf7sxwnkf
X-HE-Tag: 1792075978-797946
X-HE-Meta: U2FsdGVkX1+0G9LKLUZGeaJIqCjLyDyy+mQ1s2rQcPpsCqTxKaBhLpRldMsw8MlWJWMhJlELu+XUsAcwinveCmfgl/cRR+hoTa5dCW3RnnTAiFYNJx2SVFYW74oA3WX7vzmN6A8T7kbNw5rHu+ZORIkB4WuWtCzHVbBhaZAHS001LHpiYRSRTU6OtuKul9bviKeiORMxY/AgdEdLfeyaExS1iVOJFG1EFNhFa/6y/sthwWyxqLVjZOpGjm8U5d7t+sU9yLEmd9w4l4hN/a5qw2dvXu/rQCkAf5Cz3gEGAj0wmnbL96kVQfPcOeT2gCHTNNO7cY01oam4CUf8ypIsNTmAV25cdclauEYwbPdDMjxpKDAPukr79ltm+0D6cgMY52tLh/ulPNVokmsMgP0a+YyioM+70BWWXJJs4A7HxB0amP/TFPeK4Ykd2X4HC6TK9BiOW3jBedpgNAY4D7z2asgRd1at1a3+liMCaTbi2l+tVOanP3yH9Qv8qLLk/Znlap1e8R/LgZlTwGcRrReuGO9BMHco+lztsNYUnL8JeiXnpzRKvligeQYuObNeoVX7t2Y3A4Jc5gvyoYctlTMhaC58OHOe6HAEmmW1yJ3QDSpvrEU5uvsLVXjdZZ0U7eewY7mE10kRhRieNyUue25N9FJac9A/VA6AlXoSm8M8yroqp1PkchuPynTuIMZ21K1GgJFH1Rv8BS0zZN5/s8LSiNiB5nFlRPGeT+NaBx+oS7E5T9IiqaE187fasm8Tz+b3vb0urLY8LqGihvMF2/jFoHqCaLye4fPTvQSgI0G/uYafFovPYPTGj+WmmBhW4jBFrHSwGh6XXfR+l8joYX3s1xLgDP/lLP1QNgvfjJ4ou23w16x+AsjYfR3hrbicdP8taVZIUBaR/GZaWwTn9eYz+AfAvEoFezE11ft8+pBfiDk52vu6Rdldd1jFUW82Kcfq/+Me7EHkTBYr/autWbg
 RoYZYb4o
 YEDFMQinbaAD0WJmmgR1ZKKnAJwhzhGuOQMPcuiE7PlRPWeNwm79eINsJJTL84X0VEV87411OcoTwp9d1e8kxeOdukP+fk1p62dLkRTg+WCzfbwgMUinA3mbAqIAhHrgoGDaFhI6Z5ctydmhspxSLITgdasRvfsMtoKXn2a0ciLVGWGZud1mhNtLq25yr1XDnK7D5S5DkUdRsuLyBHiNnRBEN5MAWmdEgia9oTPr3KHS1S/ZsoaPWyYmiBDqG8QABqAuCi+LKKJZY23AWrGWn6ErPIFIZRD3pxQJlcs0aDNOVCPURUJxXT8gr138kzoTLd981aSzj50gPg87NJ1Ukdp+OVtsEDIUURzgl9t5z2Ele1591HAx8yIPhZxw4O0JBd/fW8LMysEHgU3RFhXi2fO6hRzJ86iuZo9+T6tmGUX73MlEOhmvewxHK3Z33CZlLCaBIQ1lIFrpdez/tHSFTH6BGlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 32-bit, accounted_bytes * 100 can wrap before division by total_sz.
Some entries in memory_idle_ms_percentiles then keep their old values
instead of being updated.

For example, a 256 MiB i386 QEMU guest reported p0=19200 ms, but p50 and
p100 were both zero.

Cast accounted_bytes to u64 before multiplying and use div64_ul() for
the division. Compute the percentage once per region.

Link: https://lore.kernel.org/r/CANOyQmHad1vamnZT12M5yPrJ69==Pt1U0+MGw6u0MuNtr-DRCw@mail.gmail.com
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
This is against mm-new ad9f2d463666. With the fix, the original test
reports p0=p50=p100=19200 ms. The i386 kernel build, x86_64 W=1 stat.o
build and external arithmetic checks passed.

I also ran 38 before/after VM tests and 20 same-image controls. Throughput
was close overall, but median kdamond CPU rose by 0.0053 and 0.0221
percentage points of one guest CPU for stream and sparse, respectively.
Some pairs had 5.91% lower throughput or 15.49% higher scan P99. So I can't
yet tell whether these differences come from the patch.


 mm/damon/stat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index b05b68f73e10..eccd372810d0 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -114,7 +114,7 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
 {
 	struct damon_region **sorted_regions, *region;
 	int nr_regions;
-	unsigned long total_sz, accounted_bytes = 0;
+	unsigned long total_sz, accounted_bytes = 0, percentile;
 	int err, i, next_percentile = 0;
 
 	err = damon_stat_sort_regions(c, &sorted_regions, &nr_regions,
@@ -124,7 +124,8 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
 	for (i = 0; i < nr_regions; i++) {
 		region = sorted_regions[i];
 		accounted_bytes += region->ar.end - region->ar.start;
-		while (next_percentile <= accounted_bytes * 100 / total_sz)
+		percentile = div64_ul((u64)accounted_bytes * 100, total_sz);
+		while (next_percentile <= percentile)
 			memory_idle_ms_percentiles[next_percentile++] =
 				damon_stat_idletime(region) *
 				(long)c->attrs.aggr_interval / USEC_PER_MSEC;

