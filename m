Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D40C3CAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 21:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3979A8E0007; Mon, 15 Sep 2025 17:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347498E0001; Mon, 15 Sep 2025 17:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284BB8E0007; Mon, 15 Sep 2025 17:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 183D98E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:28:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C15FF11ABCF
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:28:04 +0000 (UTC)
X-FDA: 83892772488.12.D5B26A3
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id 032FB40005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:28:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LyrwiJv1;
	spf=pass (imf07.hostedemail.com: domain of 34YTIaAYKCFoKMJ6F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=34YTIaAYKCFoKMJ6F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757971683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2Hz1JL08Ae9YH9Hn+DIDbn8r5v52DDgbIHCorDchyE=;
	b=aqAtohdWA7CttBw2jSt/WtD7gYCfBIOjL5RVzWGERy1lHl/nCKT4wcmTpMY4m3q8+UBv6v
	ajmoSR+PR54ifPjxrfI88Zm6V7d7BDv5d4T+2/4AI5imnii+TErlH68DRQeM0fEgoveFAE
	/ztLOj00y7AhSEdXvZxHx3aT8rn1ZEQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LyrwiJv1;
	spf=pass (imf07.hostedemail.com: domain of 34YTIaAYKCFoKMJ6F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=34YTIaAYKCFoKMJ6F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757971683; a=rsa-sha256;
	cv=none;
	b=IxnYH1wnhlrGW6/1XId0u0Mm0wBigItL3RLuJq3s5VbB0LE3ll88txtfXJ6584w4gzo3mz
	MPtoj3MIy1ADLvumyrgrXukb6VyGW7SOj4KPizHrMHGQdXJ6tI134UskeqP4jTT8M3L0L5
	kwmKWWHulnC7+vceNghaKuPAGLiGJtw=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24458274406so90871925ad.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757971682; x=1758576482; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d2Hz1JL08Ae9YH9Hn+DIDbn8r5v52DDgbIHCorDchyE=;
        b=LyrwiJv1LYkv+8uExuKNwykjE406uaYrUFG6mcyF3qQI5JVP1BQsBo7EPgT87R38nT
         s2jcrYCLoJWkxlvhfJ/H3F/acBwlOT5TCc2ApzQ4mJ8i1E8uJn+k8ir/tX1QgFOEpQJD
         95ihAOITswWoANDqLogfokcy7S3pIFUU/DhotuxDn9OiU6c44aZLLyhPXSeWvy3kihYj
         LlEL9Nhsh/1Kt6wcU8V2mc4N24JRq/t8DY1k7ODSmqCz8NNwOdxAhaSNYLyUlFN4vABU
         vnxfHAVLWS/Z+2bH4NCW3KUDOHZ1NLAzGpOrFiSz0/yQ1S0v2PIR2dRtVNIYnUwTt8kI
         RqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757971682; x=1758576482;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d2Hz1JL08Ae9YH9Hn+DIDbn8r5v52DDgbIHCorDchyE=;
        b=HU2ijG/yJu0HHPLiXCkWA/j8UXTmzA9s5VMcyNwUnWuRhoR6/rcVTWkY0aEIhHGZ6X
         GpTSpHIJyYA326oiemecybSz/riF7JBwd5cHNeNMJrMbU2K0p1Igs3MtuY+YexMHt5aV
         JxmuP16Dy0Pu9lJ/iFDLcdpmbZf0gNbpatLiiU7RHZlmSX//VcdA6nxPJHWitnKusSGS
         NoBq8u/q47gIVBXwyfIh5fFPQhEMdiZra4UDEwR7k17gLKOcvTCAYwQKw37DKCHwsuzY
         P/UYK1UNxWII2N9vKgSJoBKrrUi4mno8X4jkzci1jniBdbYnjS/VHpDEMMJd3qTutXkm
         lQ7g==
X-Forwarded-Encrypted: i=1; AJvYcCWYz7r1Le72l6hvKSWDAz6p0KqWk5g8FhLO2rtficcbSvqy5fTPM6R8OkqnBO4cGs27iG6/ksUaZQ==@kvack.org
X-Gm-Message-State: AOJu0YzN0i2bWzJn9venUmg9XD/orlPZ2L47RKR8xcYZh1szQin9/Cbk
	NVa7k0ovUjYN64BBm/YnkN4QanQ/+k7/PhOGF2LGfl1B81aCJDfDxTjhIrzd5sMhOAAjKUzcNyu
	LXfTP4A==
X-Google-Smtp-Source: AGHT+IFXwkTqMiXydSMPHIxdCSNKA0S/hLuGJlzEf2CG2PJ0l2U3kHl7v2nc4f6XLR3nxDEpOSny0E2guYs=
X-Received: from plar21.prod.google.com ([2002:a17:902:c7d5:b0:265:9878:486c])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22ce:b0:264:4e4a:904a
 with SMTP id d9443c01a7336-2644e4a929cmr82325055ad.53.1757971681831; Mon, 15
 Sep 2025 14:28:01 -0700 (PDT)
Date: Mon, 15 Sep 2025 14:27:54 -0700
In-Reply-To: <20250915212756.3998938-1-surenb@google.com>
Mime-Version: 1.0
References: <20250915212756.3998938-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915212756.3998938-2-surenb@google.com>
Subject: [PATCH v2 1/3] alloc_tag: use release_pages() in the cleanup path
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 032FB40005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sdihdc68gh3iefs4yd6assnqfoewufqo
X-HE-Tag: 1757971682-411131
X-HE-Meta: U2FsdGVkX192nckTF9xtyQBrld53ilvsdWmHSA82/VhazSWJr0YTTVyK2hwxK5dmSiHLYDzI8+e5Klspq1De52azvtRimlCWQ+H9bD1Dx6o4/N/9bhPu6iWjDhLEAGnPfonQwvLOSP+l8prSthkAsaOcIpE+3uwkrd7CFsCtg6xTu3X7xofvRu46zgiydxuIPXCITdyymGl0ELdT4DKq1YUjj+lZbz0WfPKZym+9iJubvEcMXGFTvsPT9A6yVv2xjOtqqZyZVl7J9qG7A0JNZ8VDCVD3mUtq7ZnyVD2G4jxzkLIjcBZTwAHhIVSRlBxe94LznvEnelvJC1b7B6UsKEJgE6a1tyO2me0MGHlfiBu+veZYvuDfm3Dy007lxDWa16X3YXIvCd/abXCTBG+UlkAx9YYjS3S2uWjy9btFkHINNu4Jlcy2dW88yMhipVovbS/2fT4X6mna6GUDGyMMQLNRGHW6e+EqPwJYryg7Q125l+xgNR0VPacmRo7ySlSXTWqggRSydCJkL68vqj8VSCVNnuuzo74xQeA8RH7RNAS1JAo1aZG2cNH97iQWqlWMsVziOzctDbWxQr5ndg/MWhO+ukVQH2RuVrr+4pDy5VUFiq2rBkwk1sNFgQt0um2W17CeDDJWob7sirHL0XJhMF2wAgDyVgQFG5vvfZZta2Ukea+b4+orz9cOrQtHrfnL5bwwVtsJKpBkP66vY5OeuT7CNKo8LExiRI5UArJT1NFu6R+U88mPWc0vBCgAcTdl3OjfmfFWCPtTGm+FeblQUI31BF/iFvwo3ioWqfVU+X0kz2iqqOYWrJZdIuieMOq+1+CoEYvE8TWb3nlYveC7VkbyJtWp30id5Ypxow3rakwwHVC/XUEFuQW2H2a2JcIFk0lkyF6pFNyKA/MJIxS+FAcjsaFbu1eReuWh2KSSf86/ZrWlzV6QHsxkm+qI2GK9T0p/ngQQRm+KHCHnett
 7wqxQCPY
 Eq13pnEr8CUTSb/kUrNemDbQpBXnp9qQqSWnuvQKwQps11WeZDEz36ZpcGFjEWWSVuyfLB9KH1jTjVK9eFa3owtelrQS7hNcaOUQU+M85ANDXgr7FbTkJhdVd0tzAfkCMhNrUY0V3JFM4FsMzYrwuSoxPeqXtAntAdBfYfmijyfpu4y9or1rouNBpyYIkiJoArMvZRJd/p04YX73QFbRTP5MU5O1EMATns3JccVI4j+Du+IYsyEiknKK4QVaInkN83g1Gcr4tntwuq1I5ldjkyWsCmhbnU7nwjI9HSnYwsYT+ej8/Lrz9VvOSwb+ol4rKe98SIvdnwSEKN8wSEj5FcSLzLcX2Opo1T1b69KnMn5xIG1cdoXspHNCd4Vyd0Butj6UHNMP4KzjrIvI8xfgN4cvtWLc1wd5I0AHQbmezUyoog0jtZ0wMxqeP/I75tmpJLO62RSRibzgsTekbPsCTdZcJTn21Epf9E8fKqll9vgja0QXEjBWvIPajStW3DchFurVQ0T/iGq8UoDTWEsis3HGelU644W/97djRlgKgxNuu6gxeenVLTCE+x314eKxxJReRmTJ7DSgjxCsXDRHyDrWBKKhgkFQZLesEbwQUWXqxyec0XpvmMju/EMtiVlmrsgIhYmiKbJyHZ4n3nbw3deqTNAyXBomfKH7g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When bulk-freeing an array of pages use release_pages() instead of freeing
them page-by-page.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>
---
 lib/alloc_tag.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index e9b33848700a..715315f5d9ba 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -438,9 +438,10 @@ static int vm_module_tags_populate(void)
 		if (nr < more_pages ||
 		    vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHIFT), PAGE_KERNEL,
 				     next_page, PAGE_SHIFT) < 0) {
+			release_pages_arg arg = { .pages = next_page };
+
 			/* Clean up and error out */
-			for (int i = 0; i < nr; i++)
-				__free_page(next_page[i]);
+			release_pages(arg, nr);
 			return -ENOMEM;
 		}
 
@@ -682,11 +683,10 @@ static int __init alloc_mod_tags_mem(void)
 
 static void __init free_mod_tags_mem(void)
 {
-	int i;
+	release_pages_arg arg = { .pages = vm_module_tags->pages };
 
 	module_tags.start_addr = 0;
-	for (i = 0; i < vm_module_tags->nr_pages; i++)
-		__free_page(vm_module_tags->pages[i]);
+	release_pages(arg, vm_module_tags->nr_pages);
 	kfree(vm_module_tags->pages);
 	free_vm_area(vm_module_tags);
 }
-- 
2.51.0.384.g4c02a37b29-goog


