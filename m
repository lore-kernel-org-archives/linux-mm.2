Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D38D3B7D3
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 13:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D75D6B0005; Sat,  6 Dec 2025 08:20:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687DD6B0006; Sat,  6 Dec 2025 08:20:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5761D6B0007; Sat,  6 Dec 2025 08:20:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40F4A6B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 08:20:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D61CEB9C09
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 13:20:07 +0000 (UTC)
X-FDA: 84189104454.04.1DEFFB5
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id 02EB912000F
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 13:20:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NJN4mzG+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765027206; a=rsa-sha256;
	cv=none;
	b=qeNzvcLIp/Ry2VJzFeYi1TRevbglIzlYFHh/pvwPUXw4GwSlbSiaGSuKtgzMMzBmIul/Oe
	AbOX9Se50zYET2TENIT2udevMIVL7hZF/hr4OV2SPfCNNQAe1vh8a2uX+PpgkMq2OiJewF
	DKlvEUNiIrhba/Te/qsqaEzSd+Di0mc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NJN4mzG+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765027206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GV6EbijV0HjN+hquGcR/yvTpNUGs1FS+l/WZr5mJ+5o=;
	b=NEIUZVQb7rs2AqMcNGZaIO9iJSaExfGqT1O0R9pMs7a0UH5bcImYEGW9JkPQHHdjN/amhi
	zDIqMrRW+AoBzURDYR7PYoyv87eDVQyZlhDoU4PMFqenzbJqieX8fticb2pRo/3wuiJBYM
	mmv85vqV5wgxuT6CS21Is5zbanpANyA=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so37954115e9.2
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 05:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765027204; x=1765632004; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GV6EbijV0HjN+hquGcR/yvTpNUGs1FS+l/WZr5mJ+5o=;
        b=NJN4mzG+jjECrztTRtN9SpJyUcQJHaY71MabS383QWbOwZG9D+/GWyLJYVnLcYy9d/
         71Q1JJkNegt6yzslyZx9BM9PbvF6WD/brVrxcyc3Km8Ll3D5zuJsoBeLUA+QgeHfiGK0
         EKtMKLqKv7Lgjyu9wlHqFYpm5rppYVnbAOiR7W0O3fmtdoPHOnhtfVERpmFQRqO4vmdt
         7W/4gHlFS2rm+Frmq81AA75WRnNJ4YYVeicP267kzEr7cHT28+UYWMzi9GVGrpjDPF+0
         Z8xv/sQeVAUMMH5c4thG1lQB2ZzuAxjfBXuxUda1Sf8P0wnOy54+eZKlzTBK122GALLd
         ovBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765027204; x=1765632004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GV6EbijV0HjN+hquGcR/yvTpNUGs1FS+l/WZr5mJ+5o=;
        b=rPX3zOPenOBYEN6MzkNQXfh9I7szpPzK8uUsKOynpRjbuEBy4gTNtSx2DeAA6mJlIY
         OtignYO/65oYwK+8e0RPrR+Ng9M6+NCAWagPCFkuDLW1PFKDAh6+3O+0PowBnkOGcngu
         PwcW1YDxv6uPc8bB4yGVQZL3GLjQF1C+GHv6ZbbvDnO0NmHomu6JHpwUHPtpuuuCZrBC
         YPqVa2H4fM+niIyf92jwz2bT6zPslX7Mo1zVMxRpQwFm10fFErcAoQ+IEele6rPPxVGc
         8BmbZZqAtNy1bVDUKL17T4VkRkcKsKaXb8xOBjnOW00u8uIn8V1O57COXO7MTIq7w8MO
         M1aQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeimYem1n1reQ6kbZcTHWpFdkDELNuQvExel3uhT5rt9MplVUvF3Juw5VGcvZvLFRYOZMS7993TQ==@kvack.org
X-Gm-Message-State: AOJu0YzAZPFYbu/9gcONSJc2C7n/XwAvaL23a+P2C5nG0hcG16DQM41N
	SdQTmkDot9tBIooP1VNAdRV69KOzieQD3vpM5ZpArmsBHRAbsuj9HHsU
X-Gm-Gg: ASbGnctoeT3Gb/dPtNlfEkcXJXY4nIYrY6MNMRMCY+2Ee8aUbg/mhV57pTxy/opXjFz
	/AT8S7IWePu3ugGkq23l7VNODK0GaoWphenRJAvwGaFLgDHw31U0vGOhy5GT9QA5AKn8HvDnld/
	CnTsH2LPZOrj6BY74XahSu1vkr8V98NMU9fIJ6jdrvomV3OqxwvMywrXN7+PNOEr+Y/T8XYliQM
	tU8NFUaniGl0cP9J5oMitd6YM+PtoP8Kp++vXvgUHs9OttP/mx6DSarvRov1vlTb/ZP80EFlyJ1
	tERBdv+fyUD3qVegR4NMnrcTLCa7F4zt/WtASnxYGxPCqyPeKhOulDV5qDugUf3VTiQjwpggybH
	bOdffEE3hiWe/abzR0PvUj0vYOrC1d2ZDfqYKZkvB3TpruiI7PJrvHxFoTdilNpEJKTL3RGvIHS
	4RucUBEg4Lv8gGF59pXkdodGDmLKhtcGSZu13MFXQox3I8L4z8OpscNOLYbfY=
X-Google-Smtp-Source: AGHT+IEtzHd2QjOH/hxJu9cWk5GtETWkHsIS8LyXnaLojWjaBsdHQmrCjEull4s7jMKp054EN3S1Tw==
X-Received: by 2002:a05:600c:4e15:b0:475:dd89:abc with SMTP id 5b1f17b1804b1-47939df80eemr24700315e9.11.1765027204083;
        Sat, 06 Dec 2025 05:20:04 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792afd3b31sm110871215e9.0.2025.12.06.05.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 05:20:03 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: oleg@redhat.com
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v3 0/2] further damage-control lack of clone scalability
Date: Sat,  6 Dec 2025 14:19:53 +0100
Message-ID: <20251206131955.780557-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 02EB912000F
X-Rspamd-Server: rspam10
X-Stat-Signature: rmad1rjxtjui5exi9uhgodicsfrme3zy
X-HE-Tag: 1765027205-187989
X-HE-Meta: U2FsdGVkX1+P/RoQYnGMw+MXeZnAoiuTvukX8+xMSU8FY4JuVcSLzl0oduPacgLaLW5SA05f46PFO0zDEpyga6MAfAw2JldkyrIoSIE/7JJQP8xmC/nTm8H123dfCVexL/fKQ1pMMnk4AdE9U1nVNOFaomEk6mDSj7tcuUoLOQk5c72Kv/6jMxpZwo300sO3hUXr3jQb0DcdbFmD6PPb2421tyHe6LqcUZ1Pd7Tn7SQnC9M31KMrKcRDzRKp04aXXkSnkUs/Rux3uNRFMG9TwwIMelZj2vVz6yrvW24FpJ2SMpGHggIudY/Ww36C1G123Tlhkw5/wCtFpQkamnqfLNChCCFHBaDaYK/xUXBwrbnCOUhrdXlaWb4YMnl7cwB4ySnA2kGW1diLSiZ/E1PfskNBAs1cOjf26RtUuGV0W6hH3yrzNn8gvLcRnxRBhzxcee+bibJ4w2ZW3bAih/gLV3Dp1eAsYpmLvnn1VtKiCCPoWQLSHECdbCj2AZCQMCrwalygiWnixIY67QGW4XugHReuL89jU2XntgaI5pkzNXNh6y4t08GWqvADzYFtIiw6FrsQnPdKnv2PaT5wE75y3JjnEZqqvlrAaupp5YS8th06TUOxgAgdX/cVWYpnZMcjo0EGfdk7lOGXOrKm1yTvdMSVx6dCldwU1CHR/Lc+dEs9EgSPZe1e6slElZs/ImToAhw5ssBctSXLPXMCPjnhVKwFYMFSbk72xCdgmoD+YBY3V79VhoId8YRc/9ZQBdIGsJKOYzLSANQ0bPb7aE7kK2JFRyaN3AXWc7IA+6hmBBT0VMIZzNbUTIkhydew2I0uhKYldZ2XKl+P+ljNbjrhcltsyfwEXLpPA7OSMMdnbt3JezmUS2RNNpDXgwqagKspbMlYiUYTTEqxxTl31YjvQ4ju2TyVfVyYVRZU3ZD/GddByUhCeqZRMgR8Bx0bb0MUhgS5Vj70Vd6GBahMr/G
 kHa6E0vL
 AZuhMLgfAlxKSTwtu5KYYLLp1l2vPnwW+m5YvqYSnVW5BKEdnbPoNMc0f2J+zE9r4Ij5K8W81SBJdLmQSy1Xbn1yNrrmLCkyT/+Mw/JWcu204n9qDdEVWH0sxt8CHGbNGh8J34AJngDcBmtE278tcg8sfFScrqIN1prJNbx/CtUvNDO0b4CLVJkBlzCJcX6YzaFKGtIJFqKQQw93lJmqmLhIGjjwtVIammrJoou7A3nYpcfSNDqdpyaGRXQzLRyGPH19SPOmL5mon8uWJr3RG5hLgo+no2M2mEi0c9EE+uVWsKn08iItlomI4OKYfb4zMXhOWKlAby/JAMY3AWh7rWzywwBMNvXo1xrsJXv9y+i0GcZ5IgMfR81Ntly+kLGmXWarO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When spawning and killing threads in separate processes in parallel the
primary bottleneck on the stock kernel is pidmap_lock, largely because
of a back-to-back acquire in the common case.

Benchmark code at the end.

With this patchset alloc_pid() only takes the lock once and consequently
alleviates the problem. While scalability improves, the lock remains the
primary bottleneck by a large margin.

I believe idr is a poor choice for the task at hand to begin with, but
sorting out that out beyond the scope of this patchset. At the same time
any replacement would be best evaluated against a state where the
above relock problem is fixed.

Performance improvement varies between reboots. When benchmarking with
20 processes creating and killing threads in a loop, the unpatched
baseline hovers around 465k ops/s, while patched is anything between
~510k ops/s and ~560k depending on false-sharing (which I only minimally
sanitized). So this is at least 10% if you are unlucky.

bench from will-it-scale:

#include <assert.h>
#include <pthread.h>

char *testcase_description = "Thread creation and teardown";

static void *worker(void *arg)
{
        return (NULL);
}

void testcase(unsigned long long *iterations, unsigned long nr)
{
        pthread_t thread[1];
        int error;

        while (1) {
                for (int i = 0; i < 1; i++) {
                        error = pthread_create(&thread[i], NULL, worker, NULL);
                        assert(error == 0);
                }
                for (int i = 0; i < 1; i++) {
                        error = pthread_join(thread[i], NULL);
                        assert(error == 0);
                }
                (*iterations)++;
        }
}

v3:
- fix some whitespace and one typo
- slightly reword the ENOMEM comment
- move i-- in the first loop towards the end for consistency with the
  other loop
- 2 extra unlikely for initial error conditions

I retained Oleg's r-b as the changes don't affect behavior

v2:
- cosmetic fixes from Oleg
- drop idr_preload_many, relock pidmap + call idr_preload again instead
- write a commit message 

Mateusz Guzik (2):
  ns: pad refcount
  pid: only take pidmap_lock once on alloc

 include/linux/ns/ns_common_types.h |   4 +-
 kernel/pid.c                       | 134 ++++++++++++++++++-----------
 2 files changed, 89 insertions(+), 49 deletions(-)

-- 
2.48.1


