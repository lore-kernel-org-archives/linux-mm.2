Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED499CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A498E00B0; Thu,  9 Oct 2025 15:29:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB0E8E0002; Thu,  9 Oct 2025 15:29:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F093C8E00B0; Thu,  9 Oct 2025 15:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D35B48E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:29:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4B2111B29C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:29:40 +0000 (UTC)
X-FDA: 83979565320.24.7DDE908
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id CB20680010
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:29:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RfIP+KXA;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760038178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qxvsBMuOQfc43PpisqPeuFF1CopwPLNmzcHAKY7Z3o=;
	b=6DG6BWIPsgmJSLXnTrA2X/SbJElN305qArHEH6vuQuSO+BcPJRzaATSmke3Qm4ZggehGza
	W0MO0RMKUhgzUNkF8QqEVHBX0MUpdRahRT3saK2mXEr/ODUeZpFCqBKnRB68+yplzAZfbL
	r7Rc5pkSdz4tUH7+DWgZJ6ruChDZn88=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RfIP+KXA;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760038178; a=rsa-sha256;
	cv=none;
	b=01D7PrlTXlNkxSo80NY24BiQ5MCHyYpKUX6+C5A+WwRUJCSWxJ8W9XmguVQt2aTfZG10/8
	xBsE43UbPb+R+OwgyyQndcKeMvttQ+GrpVZFNO3rKc8dniV1AzkrcZGYvmh9SXOLcFn/71
	Zg2LuWma6JCWYjLzVf0igdfFhM7mPKo=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d71bcab6fso12583867b3.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760038178; x=1760642978; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qxvsBMuOQfc43PpisqPeuFF1CopwPLNmzcHAKY7Z3o=;
        b=RfIP+KXApnICfLv5eF8Ps5Eji2YfeL89UudFZa9cRMtv8JBwF/Syt5kf2L7Y38rptM
         Yj/j7r8Jt2skCvGhSnhPXfRcU6sc6RqynvUyhO5FW06W1vBy7cM7QbJBptcvYtrHXg3Q
         17kHB4TPZ7wak/8cZQn9x00TkVW1uCIK/zOCKaTQqF0YHrZ6LGFvYzvGex5FOWANISAI
         5VQJkcPaQYsKjOygmj+KVy5rB54+4h6tts+HPGFxQjpn41FK4tMmnLqqw2fcB8YZxjk1
         jsUcdx0AQDAWEuXiipYUscRwfvmVJfEkvHVyk3tstIqxT4SwaNQyBj2+LJ5UjN6qH4Cm
         5drA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760038178; x=1760642978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4qxvsBMuOQfc43PpisqPeuFF1CopwPLNmzcHAKY7Z3o=;
        b=cnSEaphw1DqIam10gnCXIt2lrXTlUZV3bjrI+sNMCIVyULxtCn+GGm17wYSGddh9hI
         D3YCY4QsjQNASSFh0AWVxcxKEzy6lguVj5rggKiFOArubQ6yPyE1cOcOBIRGqRMYSrpI
         5gDmroq8lFXDroISHcYEdY7wvWHhXLPdiaYb7qjrS2OiwUj359l5yh9OsYQmMlEHWxLc
         gbcGdU/fuhTcRLXVeJJpqs/yDi0w045qyhQ3MopMgnUTtWwI54X4uGd9+56Ab1BIOBfg
         vfOYaIa03q8OFM7MkQqjjcPGkFKa1cLH28IxVtbSP2kWqSz50h/wQFDBK+aZhtLtt+Q/
         M99Q==
X-Forwarded-Encrypted: i=1; AJvYcCUgHhsBDSwsNDOz2O46Vbfjf0eI+liE3ENfB9yE554RtKk5b9nFD9cg25OP6xQy1jL09fhWKM7I4Q==@kvack.org
X-Gm-Message-State: AOJu0Yxtrsf0OSe8pVuii1n6mVXcTquU4AcbcGbUJOOe5W0wokArtmT9
	GdRKOAcf3PQJ5ZzplX3dnW+eTEcEChovEXo/EL4lA7tQSDkH4MnCxDnO
X-Gm-Gg: ASbGnctH8qzzNrOCElMgAizZxbm2QU/P2+PXv4DVnttMTLWZ6otljaVUhYb2pTv9Nij
	ioNVjWVPQesctw+c4pWuAcyvDr8bFicEvY4cdacFT+G1X6tt1H4ABt3qfopJ7v5XP/zNSNc493p
	GFeir2p+8ogVU10MJSuKQUgF2ksV6YJ1/pcg61u4vpT4TNBKaUoC5Slfq7AX1gMP6wJYDa3EB63
	mX2GWVNIzYc+JsOdXiDTCVy+ZFPFbED8TBiMlIPyvUYsXWsKNdGVo7LNF80v/Ja981uDrcpXQaf
	fsncaXKyTSnfw7U9kNLqkB9B7pMcWh4U4ec3LiaNgQNtzXmXHNijRlHlxj9S0uz1SNvcS/zRfPg
	dullL7kzspot5lV5Cc7Q5n62V1doa7y9EIeFSDkEf84rTUZ/0b0cSmb1a7MAMPCO7kxRn/Y/5GS
	GzDdrqGEdZVaOqMw==
X-Google-Smtp-Source: AGHT+IFFrfW3ILemW4cB8ZZurRWe7VEN4uNbGMupGllsLF9Wh35T1ff7WKXL5RItyXZTP/x4xzRK+Q==
X-Received: by 2002:a05:690c:6ac4:b0:71f:ecde:87ac with SMTP id 00721157ae682-780e164aeb0mr107739457b3.16.1760038177739;
        Thu, 09 Oct 2025 12:29:37 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:43::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7810724444bsm890717b3.43.2025.10.09.12.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 12:29:37 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 2/2] mm/page_alloc: Prevent reporting pcp->batch = 0
Date: Thu,  9 Oct 2025 12:29:31 -0700
Message-ID: <20251009192933.3756712-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251009192933.3756712-1-joshua.hahnjy@gmail.com>
References: <20251009192933.3756712-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB20680010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kgph7ujr9dxeij49hfbrsfkdkjdc3cjr
X-HE-Tag: 1760038178-734801
X-HE-Meta: U2FsdGVkX1/HLxGa2xUnjr9BqM5BzHv9gk+8Suz5gsyRZJse9r8aP6pZu0C+J592XZgX6wQshNEBv3ruvt6x4RymAjLaY0+0BpR7XKXDnsVHrsHxwe3gEa4s0Kglepgu3vKbGU3PRi8V2cA/o2AQ7fHaK7Yt3j/jvm4a4iJwmgl8t8Ossk/tjhDK8TLk1d/ZJUlop3X16ChLwiGmezxlxe9DKBuJD5hCey0ezNdOLRiSwePsH07eU83qanipRwZj7YjDPakAB5sCSDjLjXHoC7y+jxjHPFElRw/MMNd3GN7qTg8xnmMMfmeT+ReXvbEFUy5jO1BsnJxAuhCM1JYkY925ryqVgUzBfHdhY/yMKYwtN48CpePcVbfl0gfXXX3RXdntybrFnf/EnEef297idOE5+d+ulbTqRMusl7qw+atIBkGUrkiVGvMIcAMV1dD/l9XAzWY/lWNJpwZ404P+WUk40etSbUPglHu81a/smx+YTY10mZLUES6dH5gGKU7+VdN9Mmahwr7AOvpwQrtnBPg8AA+yXqgHxxarpJywUdu7T4jv0VcwhpazhwtxRwLqsAfCKcxI3dpUYuwU92GMP/yNfjsKggYY642AJiQb2UhIoufMJ31zWNohIvjg7gj8Ex/AaA2MYIxHgBmhFCj+J0MjLa9CMiELEzh6Liwl7jEqCnnOpXvLQJabX9RNqqJRDpDs4lQ2ALAA01BB+FzrTBD3Rd+kHS5jORse+eJgAoUS6OXdqzl/1ghDILfGgqRD/gCLD+c4sbC5mwNa8dmVV8zgvsocOjC3zOXEf+1TL/OLyKhH8ZhYZC2/B3wzl09eBMTFSVDl/pYcwhEodfuILFrSIp1MWBjNMz+ozk51SnwXU9y2m5JtINV8q7gdNq1kZ43Au94PnVav0YMtUWLpRIdmrqbgi5RYSKzQlfVWIX7Wr7I2lyP24SOF/gMStv1L27WF/1himrWV+rDABWK
 YuYHPeHi
 lHUcg+mdYXU1aloMymZECKz8OCnXL6mVKrmrVghJL4392zFnbyAxStUWnJ88fEmRsb2lmloRDeEcD6KTiWZ6STaIupj1rp05pvzgifjP5vT8YBB6zJ0FWKiSMewQqyZUnGhInATRhHYujykpNpyyus2sT0C1EXENPHM6fRr9ybdV2TkZbFJUq1vyzDnmLVcT2jwq2sFO01oGLuR3ckucDVGb7zn3ulVayme5rAkii4uToBJ1g5afHriZTh5nRRJMtgygoVq1HmGGOUHXYcXFsDja3tfrVGXYWPUtBpafZ5G2KwmjO4sA/FqI5KHODFjGCawr/1p+KW7/2VrCofLGj68nViSqf03JjgSU6+R67PC0txzdRl1imhC3Nv53CoIRsOIxSF6y7PBxuJvaeYr9bXGPfMERWxb8CgGCtFj7adZOVEL3zGqEvt4YN0hq+WePESdcSEoOQGTaWPI1W5YJYKCdgNM4NpmsilAZXn+D8sVuVntlEulcu+l+XoWVMP9M8s5Hr4nCdju4UIYNOMGT0kKBTTR5FCb1X0RQWsP0d3I5//4c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zone_batchsize returns the appropriate value that should be used for
pcp->batch. If it finds a zone with less than 4096 pages or PAGE_SIZE >
1M, however, it leads to some incorrect math.

In the above case, we will get an intermediary value of 1, which is then
rounded down to the nearest power of two, and 1 is subtracted from it.
Since 1 is already a power of two, we will get batch = 1-1 = 0:

	batch = rounddown_pow_of_two(batch + batch/2) - 1;

A pcp->batch value of 0 is nonsensical. If this were actually set, then
functions like drain_zone_pages would become no-ops, since they could
only free 0 pages at a time.

Of the two callers of zone_batchsize, the one that is actually used to
set pcp->batch works around this by setting pcp->batch to the maximum
of 1 and zone_batchsize. However, the other caller, zone_pcp_init,
incorrectly prints out the batch size of the zone to be 0.

This is probably rare in a typical zone, but the DMA zone can often have
less than 4096 pages, which means it will print out "LIFO batch:0".

Before: [    0.001216]   DMA zone: 3998 pages, LIFO batch:0
After:  [    0.001210]   DMA zone: 3998 pages, LIFO batch:1

Instead of dealing with the error handling and the mismatch between the
reported and actual zone batchsize, just return 1 if the zone_batchsize
is 1 page or less before the rounding.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 39368cdc953d..10a908793b4c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5866,8 +5866,8 @@ static int zone_batchsize(struct zone *zone)
 	 * and zone lock contention.
 	 */
 	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
-	if (batch < 1)
-		batch = 1;
+	if (batch <= 1)
+		return 1;
 
 	/*
 	 * Clamp the batch to a 2^n - 1 value. Having a power
@@ -6018,7 +6018,7 @@ static void zone_set_pageset_high_and_batch(struct zone *zone, int cpu_online)
 {
 	int new_high_min, new_high_max, new_batch;
 
-	new_batch = max(1, zone_batchsize(zone));
+	new_batch = zone_batchsize(zone);
 	if (percpu_pagelist_high_fraction) {
 		new_high_min = zone_highsize(zone, new_batch, cpu_online,
 					     percpu_pagelist_high_fraction);
-- 
2.47.3

