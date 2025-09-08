Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B37DCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7881A8E000C; Mon,  8 Sep 2025 05:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760268E0001; Mon,  8 Sep 2025 05:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6756E8E000C; Mon,  8 Sep 2025 05:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 545328E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:07:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D586CBCAF1
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:07:55 +0000 (UTC)
X-FDA: 83865505710.15.B80C1C9
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 199881C000F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:07:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757322474; a=rsa-sha256;
	cv=none;
	b=HJSxYh8IJJDJkIkLdTliqbgMRxuwol9/Lt2BdpKUL8+sqD5i+47TVSURI8iPh6/ltsvKmV
	7Q1FBZZpHxpuqjySJwN70dYTEjTrMt9FPgEX6dLq1HRgmY410ny/CThbRD2hGxoGsU0dJl
	ClndfZf1B81gZNRwemAkxvGm9E1Oq7Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757322474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=+ePUuqfJLoDiY7BpIFN/k/UJrFka4KzF3ZCmiecQuNA=;
	b=QwtFoXjfyH6jRiyYW1RyOLs1qoB6NP1zN/bAaaaEoM9nsU7vUgE03x6LpNctaUs/LOvK8r
	GIC8Lomi4tIrxGtJAOpABa9Glx/7dNFDnC1vUX/8Wn1yk1Q3yWt1dh5+Bfk+vwazZuRZKB
	QF3ZV0op3FrIh2hB7EZwYuWqhMtKd5w=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45de1e6d76fso11608355e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 02:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757322472; x=1757927272;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ePUuqfJLoDiY7BpIFN/k/UJrFka4KzF3ZCmiecQuNA=;
        b=qC9JJHl3U8VE+vFOM/jVvM94BrHmNBGw+bLaQ6YSWIaiRhjMFDaGZC8+aYM1Qjz1cV
         02BAjE+v8gLEajUsSSE5bDO5AM4Av2unFaNIOcUt6gjt2oRgu0fkiVF7HqfCrA1KXPiT
         LMEfHg4UqWASWNno49Rhsr/A3TeTwlqeiZ+2+ISCb1+nphnBtmk1lA3T+lZCr6YU1bZb
         Cft7w3MKkwWtnvHPejoB5DW/VPYaw3rD7dk+LAwoed6dNf+h0RcRrfxANhc48dq/h3t0
         L/TJlxUdVAeZnLE+lzsO7Y0EbRbNJtK7bFYxTN4BSrGWmvkSyid+tAU0kRABGOh80LQX
         Btlw==
X-Forwarded-Encrypted: i=1; AJvYcCXfkRZHFQ8N0T5wK5mFFwP2w3wlRP/vg6tcPH4AVx0aLCRKeKd32ikqNf8Z+Ez7rVA5Na3s0Icv9Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2KH4N2srK0E6w/hljKWHdVB8HVYn7SSX8y/0cwROi8GhxGtkf
	C/8DGUNB4RgaRn5SkIKt/M+rLxfrBkzaXN0AAr8sdd9iYwL19QiuVYRW
X-Gm-Gg: ASbGnctlg1qQGuNi/oqdvuZxnAR10eCDnWxzso9SYpeV4vFvz3PgWOWs1qPL5UVythi
	yIYRTPLIiOuaMizDP6Fwt/CDcfkSAqj8qxwvhwS5OnxYZBh6QZUgIdvggK2dVuH/p7DwS2AAq+V
	5fqiqY/R7ACRfVLisUKYMjroQ5RTlEGQYoRT3JUo+9XlIhfGyp2NvyD43MANT3qX6SH223GOe6y
	Pz3z28qP5ir1njUZ2jjhjjRxrqhh05ne+Pz15Zz/oTVQMKGdqfEXpH0+q53Nci7VnpjfgbOGavY
	9+MZQ5dZ6tJxwK4H67Z8lLKAz6+NkiRHOrUfrOmNbfdinNSUPZ+OJ2V7dpeq0V7acwHHYh9eXNO
	hsHZAKU121VE2d3rJTfK29XT3PGs=
X-Google-Smtp-Source: AGHT+IH0+ICOxefFaTyrK8j/rqO0fXTDvCT4zajhIOcL46RN1YgcDsvxFgZ4MmXhn4WtQbMKXhOCLA==
X-Received: by 2002:a05:600c:4711:b0:45b:4282:7b60 with SMTP id 5b1f17b1804b1-45dddf01a4fmr50850205e9.34.1757322472311;
        Mon, 08 Sep 2025 02:07:52 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a04:6f00:1::ee:b:1086])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e543e9f444sm9075487f8f.60.2025.09.08.02.07.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 08 Sep 2025 02:07:52 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: Liam.Howlett@oracle.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	usamaarif642@gmail.com,
	ziy@nvidia.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in deferred_split_scan()
Date: Mon,  8 Sep 2025 17:07:41 +0800
Message-ID: <20250908090741.61519-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 199881C000F
X-Stat-Signature: bzm1pqaufrwrxt57ko6bbo3sokew51st
X-Rspam-User: 
X-HE-Tag: 1757322473-542301
X-HE-Meta: U2FsdGVkX1/YIL01JWyegLvt5ObuIPY2HWZphTJOpiplVASMfl8Qr4nZ+rD62LeYdj4hDtPuWYRXdQExeVcG+gl7/W3eCyvzVZDPiBG39NvRLaZzjcXkyY18+qfWpL8meK+/MZzpVZc8CTUGXfylrc7vbvxC8D79gLJXwyy6lc2/fplyKT6aK5PCkXuqbOPvHimXBQYyR6VV233Ky4rrJnq8c2UgaXd3iMH6c4Rko/TPk1FTE35MX0PJmCZNHjwU33Xj5XqQTdl5qX5mYIaOd2nwo67vsGu57S3xO4uWMPYOriBMTRtmMBtlAi+eMtH+EHrAd2Eyi9wTwHu2Ewi0A3oSOD9IgVjyXhchmb61l8kL6pIMTrP0Fouvny2H/5JXRh37adARymht3miCf7U0uD+gc9h984UPUVDejD1b6osDHNdqQy9wytid1VqzS+gKaUQDcfX/jJiLe4e2OSeVitL1gZNlHhPIknxK6Sxwacc2cMv7R+B+KVS2NffSN74BPkcRNie9OVCfQMyhFfbcnQgEKdeul0EN3zMRPFY7U3nAk9cAB/iaEdyPB2LHRHT45R7eOgyT6q48CdUkaiqFPnmriKNVmXU7W2kVkZdChYUPKwMNRrLYGcI1Z/Jg6QgMq0xXEWc0lQkVTUuU3RDDtQM8c8xL/0ApZvNHZTum0dGKUgmRs2JN5pw9JXxNMf5hHRp8iecNrZmKqiIMrTQDYBTDuvgOKuCBCSvkOBVsH/rWN9zvv41ipswSNvbevx+BquaTmyH/du6nxxdHF88BuBT+3eoR7m4ZIiarmpMKUiA+vzS8mhJZvEF6FiIyTlrR3EtXOd97O9TbaJjDRttiD6KkkGzQ7ufDhcwK0KaO6rI4U0zuxXFYko3hMwtf2UTFpb3fEsU10BvW9KyunIRAG1X0kW+sWcL3NVtJ1oZK5Q2u0u8rCmtwCnm44C9X5Lmy9VUUB8Pf0Ekv66ff93K
 9w8mxufL
 3qbFa4Js+1CAodOj/DTdVM42Fe0YPkjvscT30VB/4j/AOJIwPWdIuImb/g6yVt98SCUiTFh+2R+zQ5hzVfMLivaOK8HPIl5fO6YqRWzy5QPtRPlU8D8jy7N7vNz6mihIohswJN05yUkmbaQbVNpXEH62rAVJDZ0S9A+LahTdgFqwtEDziHJGhZYuNHNgK8MaufMI0AUfrpWxZFUx3jW3i6Wgc+MJy+9onjYwrLmwGOXO/fPKMTv4XzLlnVowKzN5UBDvPHWuoOW2XBF0g/iJ96do1Vaeji/d9Oxnzif5Wde9K08Wr/77PSwvaaQVX1W0M9raLJaDLM9LW1azMSF9O9EqAWTEe1YGSRmKmtzQkV7yp6Ly8ovVe+s7QDvTZ7i0qw8nm0RuAkTm3mWMlEI4QK4yYN3nHBahhiW+jUWWGe4oiATWpNsROMjhFpegVi9RYiNnhHGEG7rTFRK2lFSv+pRODD4GWocuxTLDePx1vzlAmHYiityav1VnjhxQL3KZe8Y+Bv9D2tvWwqJUNRK9UpaE31/iJvRud2t0T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
it does not make sense to try to detect whether it is underused, because
try_to_map_unused_to_zeropage(), called while splitting the folio, will not
actually replace any zeroed pages by the shared zeropage.

Splitting the folio in that case does not make any sense, so let's not even
scan to check if the folio is underused.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v1 -> v2:
 - Update subject and changelog (per David, thanks!)
 - https://lore.kernel.org/linux-mm/20250908040713.42960-1-lance.yang@linux.dev

 mm/huge_memory.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 77f0c3417973..6d99893c18e8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4183,6 +4183,13 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		bool underused = false;
 
 		if (!folio_test_partially_mapped(folio)) {
+			/*
+			 * See try_to_map_unused_to_zeropage(): we cannot
+			 * optimize zero-filled pages after splitting an
+			 * mlocked folio.
+			 */
+			if (folio_test_mlocked(folio))
+				goto next;
 			underused = thp_underused(folio);
 			if (!underused)
 				goto next;
-- 
2.49.0


