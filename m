Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8CC9FDEE4A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFD66B0098; Thu, 23 Apr 2026 16:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A15E6B0099; Thu, 23 Apr 2026 16:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168E96B009B; Thu, 23 Apr 2026 16:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0518D6B0098
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:35:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2C30A0511
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:35:00 +0000 (UTC)
X-FDA: 84690974760.03.BEAF9A7
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 06233C000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ifPWdl5u;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976499; a=rsa-sha256;
	cv=none;
	b=QWkh0+mTYGQcbBGDdkgrzFTAO1jUtt9bTpBCXKcWtDclksuE5fsIuIeons4rqwubkt0V55
	3G/grPCMJnBIUjZbsleinOQw8Da3R2Ld8lPjuABwY9BynNdQBirUuS+COm7KDBaMo05Xbc
	mSnN1BLHmI1Oq6KGHECK8kuJ9UAfyMs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ifPWdl5u;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gL+yOOTEXjRtHcz4KSAUpDgaXmbkTootS4bc3SQomf4=;
	b=vgG2QMNuWTja+PCCir7Jn/hnKIVUoNqGH0ropsbROxv2Ap/om/6RES+c8BqBHZkNZSsQl+
	WhWMlyZmXs2lXk+FnsSQWwYcZJCQIXwgan9nO/yN5ghtYD0J/sfK4BMb5jcM+5WFIthDgq
	v1jskdgiBdwUUu9+VkN0hA2pjORis3w=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d1872504cbso6022021a34.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776976498; x=1777581298; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gL+yOOTEXjRtHcz4KSAUpDgaXmbkTootS4bc3SQomf4=;
        b=ifPWdl5uhvVjgugFqXOBv+t5oK1U81KD+zUYjsqyaxiOKkLkQAH9wpXbtDRVEhouJL
         UBNNervuMYia/d7gCDi9rndDZ0mZ5FjxFDXipJonODJ3gFHPZRmhzb+UhWjbuJJbwMF0
         MC1AXkkCdmTpsWcXbu0QbQl2i4F7KkwiSYwTn+C11f9k93AafMswqLGc5ZvF7HtFYoNY
         h+auTzFL0prXjPGSr4aHKpg6BbugMAxDO8WGZHCRLOJ0fja82GcKhlEvVw+U7gE7+6oJ
         OCzNnZMbJt5rVB1Ga9pJ8m/dlp8QnmegcwLmTVyj7NqysTTA3FIstaUQUKGIy2GA4GXP
         r8DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776976498; x=1777581298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gL+yOOTEXjRtHcz4KSAUpDgaXmbkTootS4bc3SQomf4=;
        b=rD+rPsH23bAiwf7FEc09sjnxI3c3Ak1SYNs+bA34MUGz1Uydw1Auxsmhjuh0pIptZr
         qigRLIV+jHNLLSxJJROcIKRFp3TnPAB8qwOoQRK3f3v+py9NoZhA4zEn0vcKXLtn7yEM
         6N2OuPzkKkFyX+A1LNwBCkl2friPIaGk/O4V+HdyagkTb5EZ9Okek085N4d54fJ4zFOS
         n3giTTaJ7ZTPZe73heHZFzGpRuGv5iOq7pNyJmpR2FKGcOPewD9X/RHBHrK6ln22U1hB
         Hn+yTwPMuOZHDZf6JRjLLLK3YpDKwkPVcJoTWpIYQdfsWZWc9O181F3+xhK1WWrDa9VU
         umyA==
X-Gm-Message-State: AOJu0YwpbDmuX1LfTWUwGdCjPssyjvpW1m68k8pjnTWTfU1ZCVhJbjiZ
	1cNfmeyEmrU5sM8Zc/wpe5Vu39+Vhi/F4QutBXfzGWkDUgvrRpli0SvyD5JuRw==
X-Gm-Gg: AeBDieur/tTOU4a8HrhzazRgF1BlbZ7UUiIlRTrCZALHCWBAfrFRV506vDCE8nfaaEb
	LQ8R6kNE+2OdaMxWuaM1qrMbIkdf5F7ZQ/5APhPnKb7aCxkP0qR1x3qqtEuTQ6DbsbKftBMzGUD
	SOZRFuQnxL2ZKxtpE9jKt4IOP2vMOX+tH1iMqkN6x+pQ08tl1Z/TO/ieDwBpD9p10BYj6Qe9jsO
	oWZv6iYyVAJG7NwZMejHc57/4AtLF1zpTHYd0XKXz5AJ7+17LWUIHJXEZqDq0PhB3iS3i/JRL7O
	YhawonSM1wFtQOBCxlrSvTugu2O6rWCdc/kxN1Zwf+2foT5dzjPh6PBkAnsot1GKoE7BkKAy3Xv
	Dov0PUSZSUSF77VHgWFBVLXbpz9ggKT1496KcGlD/0sFl+nRbM6G0dC3mLRqIybrVz/iizMwBgB
	bwaVSRw2tjlqC+M08ahPYC5dn6kERGlR0=
X-Received: by 2002:a05:6830:82e3:b0:7dc:d7e5:8d43 with SMTP id 46e09a7af769-7dcd7e5a2e6mr8038210a34.2.1776976497705;
        Thu, 23 Apr 2026 13:34:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcc953e39asm10485258a34.15.2026.04.23.13.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:34:57 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 7/9 v2] mm/memcontrol: Make memory.low and memory.min tier-aware
Date: Thu, 23 Apr 2026 13:34:41 -0700
Message-ID: <20260423203445.2914963-8-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 06233C000D
X-Stat-Signature: 8ytatgq5t5wfdybg5ut6w5yjs1k7cozz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776976498-495226
X-HE-Meta: U2FsdGVkX19c1OusOiY2JmkPvQmyYyVcr/uOUJMnYp7nShwzROehSpA+hukDda+uns+4jv9iiwLGLUDjRpAFx5jsQNB5vyglHRzdyiG1KZpYen/T1g3+Cfh2X0s5/SBk4uyk6aZi1RwH8PlEuJeQnyY7VohFJLUSAM+Y3nczcM8K7H326U0yC8E7hIN3cCHIvle6pEXiEoGRd4eVov15SPUkSfLL9SpQMUKMwi7D+2B67u/0jkNRefguuyMfz3ZPE+oWeKY8C3IzQAnS4uzkjL5ArlSxL0tZatlhIDRnvf49RLJFs89bMq2sLmMriKxR/asi3im8G+0DLdvn6LIxeTSlat32A336aX66ClCKbdCerJRJ4hbFd8KR+TYJoRlZGeRZ00tEGmmbqFGBAkHje3rPgMRxuJkA4GeuTJb0PqEPB7ES8/eMpRj502GKgrr+2nhk44r5n0BgR1NPv27fJUpKKLQZMTU7kP4nJOs4oCUUMzw/deYxEssTu1/kuxbFb9ehWJ67p6JwY1806gOaGIk/CNd3dv5mpttXJOhTq18u9pgxebvGBKAl5qGFjlu8ueJ8Ct3WN+PDFhG3QV59oQOw7yuYescM6NHS2F9AU3pBXf7CGVs2d2mL0S5poQ6WW7b9q5msto6lhYkC0PwVeof7NXreYXpwBNDn75t140l+bdXaDkgclcbqKmMDJSyT3W1h1W3mLYahWmwBZyx8C17H5Oe54FYYyCIeypEdn1GzYqaAos5SPZguz98Ojy/obfdq5+rRqMLZj0JEbhRD93nx+5rfgKbPGunyPpS783/k6jiEtsgaNxvy1KtHExeoSpcYq5hEBd2dxLDbrtAjRtMZ0Ijg3dMSSB6o+pDAbFnQHti9DcswN6gqqsqfS34Y9/kwGgaY+3NU9Y3dl+7Qiu1AlkLGy3Q2fMyYdB8Fnt2slITyFdzpqG7vFNTkKw33aQ3ibzgrWWQLgcdO3ds
 kEBn5Htt
 M5TuRxnewX8HZ4TiA78qVLI9aJOa1eiQSZxP6w5dn8sEGPUPcCYq02x/z/bo8ZTJfPEdl/nFxjTOrPWjQeR4Aay+bLPCZbcdjg/Kfta5hK8Jasc1bl40PereBTbA02uC3cnOnOsfKuX/usWRV4SnMQkKGO1k5ZUugMrIPtAj/WDrFTP814m0ZRvnq7wOOX8r3YCW52SU6fktpldCkKUEKwBlAoWUVMElbv0oC4ByoK/+4Y2VqHF1UKpqCjd+3f7sES10QKyGZsAcyXt/hj1cZGBNxYhES+Bo/rx0VXEaLFGUOzxBqSdEGUQrmLrxbnl+GYRYpk0ncnqay4iIh2qXPEsDrfnPYRscPcoO4NWB9pMXGqk4Cf7IbA9y3zXOA6QDu/1Xh9KAK368oZOcerX1Ev2s7zPvDFzWDinRJ/2qyX2qEYC/Y5G1OkJEjz/mxY57/pR3ShjnnJANz0+GBcsT1DF+1YmxrZGj1pXyWcvfevNjIiEkG3MRblWPnCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On machines serving multiple workloads whose memory is isolated via
the memory cgroup controller, it is currently impossible to enforce a
fair distribution of toptier memory among the workloads, as the only
enforceable limits have to do with total memory footprint, but not where
that memory resides.

This makes ensuring a consistent and baseline performance difficult, as
each workload's performance is heavily impacted by workload-external
factors such as which other workloads are co-located in the same host,
and the order at which different workloads are started.

Extend the existing memory.{low, min} protection to be tier-aware in
order to enforce proportional best-effort and guaranteed memory
protection of toptier memory.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h | 8 ++++++++
 mm/memcontrol.c            | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6bcb866440075..2222b390ebf10 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -624,6 +624,10 @@ static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
+	if (mem_cgroup_tiered_limits() && READ_ONCE(memcg->toptier.elow) >=
+					  page_counter_read(&memcg->toptier))
+		return true;
+
 	return READ_ONCE(memcg->memory.elow) >=
 		page_counter_read(&memcg->memory);
 }
@@ -634,6 +638,10 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
+	if (mem_cgroup_tiered_limits() && READ_ONCE(memcg->toptier.emin) >=
+					  page_counter_read(&memcg->toptier))
+		return true;
+
 	return READ_ONCE(memcg->memory.emin) >=
 		page_counter_read(&memcg->memory);
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3fb1ee1d18603..b115ff40e268d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4933,6 +4933,9 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 		root = root_mem_cgroup;
 
 	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
+	if (mem_cgroup_tiered_limits())
+		page_counter_calculate_protection(&root->toptier,
+				&memcg->toptier, recursive_protection);
 }
 
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
-- 
2.52.0


