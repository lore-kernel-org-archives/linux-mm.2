Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E089D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 05:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33A56B0005; Mon,  8 Dec 2025 00:19:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4CA6B0007; Mon,  8 Dec 2025 00:19:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFAB06B0008; Mon,  8 Dec 2025 00:19:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BFF566B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 00:19:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C96F13464A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 05:19:55 +0000 (UTC)
X-FDA: 84195151950.21.223D044
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 89F49A0003
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 05:19:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OOnzSdlY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3-F82aQgKCOEMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3-F82aQgKCOEMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765171193; a=rsa-sha256;
	cv=none;
	b=gp1kltDPL1koRu+c5pPov1KtUUNTCVGMU3tplmg4Oa92RV/J8k5SupYynHBeVwQ8sgkDD6
	ciKEjZE0CH+u9gWCwht52HnidCqeuN52zBFwaujTk42LsMQ0kEEwgKMY+YToWZ6xM0jj6a
	H9IMyeyYzuJ7C8vehiVfiyZbcaBcqc8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OOnzSdlY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3-F82aQgKCOEMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3-F82aQgKCOEMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765171193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=O7UnlqZp5/SsOXN8+FZw5E727rrgqLolPXcKhpWhG6I=;
	b=GGidwAGLTrcYTmNkjkdVKQUDFan5tiADQAYOrQ6nYBzJHLLcA96HiD8+JkthBL5ADDUYYe
	lIwNLbRTfIAK/8cNggGOPrEj4gQMn4MBxw1kHYOqdUFQIU0Q6vLpdwg4NSWxn8GFksLqZ8
	651piJynoeC+JEAVSw/KVZEKVat4Ps0=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9208e1976so7535106b3a.1
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 21:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765171192; x=1765775992; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O7UnlqZp5/SsOXN8+FZw5E727rrgqLolPXcKhpWhG6I=;
        b=OOnzSdlYAUSEXxV7NHYiqICOvz+lHd4R1C5FABX0hncrqF6C4wjmyQ3eSmgGAgI3yz
         mQvufwk3eTfSzpdsEO/cYhV04hDsAj+ecBf7Shs2lLbdRXjFcHDvIUQHFzLks6MMIf5W
         ixw4T6y55sKS6NAYyb7AXGUzSGvIefyfGEt5rdt1rNCwwOsfoK56SDA/utClcIf7VgDJ
         ia6bf1/8MUXvFep78zsF7g1noBRFKm84aE4TBt7HUrhe5nn6BFciMrjueA3VDAg5NHor
         nYuE+/s0Kw1LTtJk8dT5v+ZBN+ODciHTReZyfYSV3zvDz3ddfoeOQ4jzJjU+sGZYG8RR
         BCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765171192; x=1765775992;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O7UnlqZp5/SsOXN8+FZw5E727rrgqLolPXcKhpWhG6I=;
        b=gdpLPyWb9C/rp7l3vx2LTjwK1W7esivsut5Q6CaODv2N35M5bhGbrgscrakkNCTGM2
         HIUaDtH195rfCOarShnqJ+hjuSMzlzme9lb815y3IR6Tjq0mRlZbbIK733d2+wBSBmHE
         zYWvOsLQ2CpyFMnxfi/JFq9n+WrdDQZFcKba37w2QyzCRJNax+j3JX5ejA0YCWlVXZyC
         paO5vllCAXnVRrgwWkxsh5s8AZ1X1GwjDVHkugAMwvylX2cunfqkqWOt/PWI0zyMMtc1
         XBcN7fCV/ic+PzueSB8MQ66XOXHct5U0gogokW/0dMBbwfMPlJtYEN2eAibjzoh0Cxyb
         LoQw==
X-Gm-Message-State: AOJu0Yx6GoXJNpasqrw6+D1N+lQInYBZ+tLLYcuKd8Ch1Mcht1M3iLLG
	uXgOko0xKp0NVldauneoegJ017oNAvMFhxyvoHqSBQexOJe72Of0ey7eeTdBeZawBPvzRNQRZ/x
	k68D3jHhnsjQBeQ==
X-Google-Smtp-Source: AGHT+IGFL2y2uE0l1gR2kksUADBN/WD1xSApgUUsBRkgzcvvHK9GFS9UzGKDu1JX0VVjnQvvR6P2iD/uyZ96xg==
X-Received: from pgbfq17.prod.google.com ([2002:a05:6a02:2991:b0:bd9:a349:94b8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:2444:b0:366:14af:9bc2 with SMTP id adf61e73a8af0-366181421b6mr6673453637.76.1765171192210;
 Sun, 07 Dec 2025 21:19:52 -0800 (PST)
Date: Mon, 08 Dec 2025 05:19:49 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAPRfNmkC/yWMWwqAIBAArxL7naBi9LhKRFhtulAaGhFId0/qb
 +ZjJkHEQBihKxIEvCiSd1lEWcBstTPIaMkOkstKSN6wSbFr19vmZ7aTsef4c10pXbcCFQoOOT4 CrnR/4354nhdDPVPfaAAAAA==
X-Change-Id: 20251208-b4-vmalloc-might_alloc-754a791e4e10
X-Mailer: b4 0.14.2
Message-ID: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com>
Subject: [PATCH] mm/vmalloc: clarify why vmap_range_noflush() might sleep
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 89F49A0003
X-Rspamd-Server: rspam10
X-Stat-Signature: ebuimo9x6ceyr73ddye56mfym8so9i37
X-HE-Tag: 1765171193-624742
X-HE-Meta: U2FsdGVkX19w9/6zq7/ge+HtLzNtwc+PfB3DrG5/GRnzj/aBoPCwRbzb6Gz1KmCDayDAReVKoDiWRiMCdzXpQeFptwR22dqt1WP+wjkGlXU9aMi3731+UJJFTZUrBikFLBXIAc2+7VeYL7xF98r8qKpdALgBtdilcHMBMn8PduSdnT9wHYzgeZJE7s0NGODLmqgwQQxmFvXAqBml5x66wX1IdPKXiYzYSwa3VwR/NtMu8qMw/H09eSEHV16nPQTXfoRiTQB5+Wo+YO63z2IUKwhluH7qWyNNefU3mae37WpX40c6mHh4FFRuEA19bEiDc2xqbU7wynyOXiQq+y06PcHtAmotG47bhKEPzDe+CRKtZmu3WYPYw+dIwzbhpIFskEKACsd8KKHyKHlrwkD2Z5kIjSJjDJy9A4Rh1+mi340crBot62dHTW6nYOd8TB6bqsix7lDlOOQ9/BPJZ66p6ZIfgX2Qh0Ik1gjxyhJn6am9HKfLRkwaFAwzbGV48VORgxcKYRHeFZPXwgEKrJ6nrL5qvs1dI6gZzhu/IWgSrQUV1Rg+P9ZdMq0z89z1YIk0l8ocfbBNGGLnEd5Hb/gUG2Vsa2/QINVVUMTbHQrYLmQdCZMmjgGmthsSj0usApTuAzASaqJbpp3ZUnjScBrsHHTDgnNx++DxuyMj4DXU5MssB+VJUEmAWHO1stcfxXf7YJl5yjT4BL7UGrVIRvV0EvVUQBYbE/uZYtemaRpbxbxE4w0YzRhJZ0CSZ0Y1ZTnEVnzubiSfPoRQTQQVG/KLSODilg1fUAUfesxVVj0A6UEsIp3AfhQaJMOidYFFy21cEOJdctvDsYEQYZpntKFHIU8hsT1h42YIl09dl58St0mwLOWtipZRWyf/99nNkUbdiQ8/g9mkRM/NaAR/kfwVr8BO5HvW2p7A5hKgMcWQ3atUm3i/sRV6MO6jho9Duhn6oJvosJvml1haYkHJPcy
 v4CxuMj2
 MkGligJ0VnHbtwxxU4fhw06uA7fOENjRXzJtbqK3LZkU0WYJdZecrbrFc5S+JvCCFD7K8JVFE6m+GJrVE09JPk57D4Ym5Lw0RcPqFEBq2c971bLIWRCy/4aOK3zXuuV3T3CjT/XGtDVIKJV+PiXoyMyQghZ+AhDWtOm1m/YHiYgaXJd8CzDJEBPtRu9L6EX43qKSS6Ph/qnr6xOmr6cXffHVEuXG1qbMZ46suT1nlKp3NdMvXyzMfQMqR/N6cNei2dQz9/XkyKYCghNTouHgRHTBddSa7Mj6XdGJR9R+6m2yI7RIaQ5FICKfaFT0qXKcvWyHOshCmn37PwGEnvSpXDQLT3VuPAudDhYUKA3bPbMawvQBqSls1UZtFrWq7uMJ/Da+u2u55hL3Cht6kUqCqNn5tvZ619f+cliLcKfYWXkLdb0BlG8KtEJuxFOLV9Hd6p8YZs2MyVDq/lt2RQ7TmJqZB6Cj/pVYlyLwlEveEDAqpzUw2QuFdmOYZ080cOUkpWbBVrSgLZYtiMiK0aMMJLiR4/Kr/54NRebf5jii+70KegNEZGNxzqQqdEG8aF4PH7+2RAji4F0j5BcRYQVE4edhaWuhSPOoH8ejBAzjH8liyZgKljSYdvO/IAmBJlrw8kp3u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only reason vmap_range_noflush() can sleep is because of pagetable
allocations. This might_sleep() is accurate, but we have a more
precise way to express this particular case, so help readers out by
using that.

Note that the actual GFP flags used to allocate here are arch-specific.
But as long as GFP_PGTABLE_KERNEL includes blockable flags, it should
serve as a reasonable common-denominator here.

This also ensures there is an fs_reclaim_acquire() even no pagetables
are actually allocated, which could potentially do a better job at
catching filesystem bugs.

---
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a53c7462671bdd896f95712af71398ffbe22fb80..ff1876588b94ec69168324e93399dbd117a6959a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -305,7 +305,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	int err;
 	pgtbl_mod_mask mask = 0;
 
-	might_sleep();
+	might_alloc(GFP_PGTABLE_KERNEL);
 	BUG_ON(addr >= end);
 
 	start = addr;

---
base-commit: ecc46e02e0abe025a6e840cba2d647f23fd1d721
change-id: 20251208-b4-vmalloc-might_alloc-754a791e4e10

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


