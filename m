Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C95ECE8D4B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E7C8E0002; Fri, 14 Nov 2025 10:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352958E000E; Fri, 14 Nov 2025 10:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1799E8E0002; Fri, 14 Nov 2025 10:54:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E6BAB8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B74A512E108
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:06 +0000 (UTC)
X-FDA: 84109658892.03.7BDD8F7
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id ECD89C000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EOVFdD7K;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbmkCSy3WV97Khy2XyctXrcV9Slv19pvozAVxgLjLY0=;
	b=UPLPZaravHga9zhi5Gxih3VlbB9MJ5cjsPLEdrVJi/dKEqu9475zJc5q7gJLyZn9x0Yeql
	yPK/XgrTJVScTluS+PyrUwwX46N8NXWe+1fc5D0pRwtiDwpLTh9k/3IyJVwRtdoR/RPZtC
	01xuEnNvluUZDMFSg4FgLAJoiSpX4KQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135645; a=rsa-sha256;
	cv=none;
	b=uTkryKx55OXuDUwuUPMIGKK5N86rrlHx42cF8lE7jQV83MLEzbduZlTRLBY5d+djaC15dp
	F6yk600xPmcn0t5MrZkIdMV1MGUMGPBHbdxQTRVkvwbJzxO29MvXQXfzYu6R7hztf4/pEW
	1WJ5V2TBUzMg/dshuCMJEDti1ieJAg4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EOVFdD7K;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d6014810fso17496317b3.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135644; x=1763740444; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nbmkCSy3WV97Khy2XyctXrcV9Slv19pvozAVxgLjLY0=;
        b=EOVFdD7K+5HWXXaCxDE7fp8MP1MY9bm/Sn4dMyqe8GdwxtD5GVgERGW7Uj2dxkP3q6
         dQbTdDW2ybLFWur1yDpilJrj2iO3m8xhXnHNqkxMbjkmibnEqAEqDhRjLCsppXV3Diz6
         sqDgq25JEIPKasJAKA2BXTTNeNeRxanb0VhmZ69EyGo6ffzIDKDy0SRDqIoG2NEsRqmM
         ZTqB2aPbnJ4yH4HbXHjDzK0u+AwUkRzCOWE1koeVja7tHvNgiUSIqcO4K4qjjV1WvYRl
         jnMy97pt2AaL6QW1FmB9MUrWjb4t8jEzy2uHfrEK4LoNkMpFfpuw4XnqxcHnhDr+Jj7q
         UJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135644; x=1763740444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nbmkCSy3WV97Khy2XyctXrcV9Slv19pvozAVxgLjLY0=;
        b=jhsPJvnMXceHRDjq+CCzVFSL8xv2ScyG6cBPVuqpUHj7HqVfDX4ULTgjYypT46Orb4
         NfnMMnRpTc4pOXVQqaArhqYswLOflvQwL68KvnIaYeefwBviRXmd5fFu8Q1WHfRzf35H
         zmbEKZqc9yoUR3Jl+UW3IZtc0W1DnfW8BTIoHn2kFGjkUCllLbb+j//U8MlUPpBkHq4f
         0RJNPcg+Fy6MlwP94tDGMdP/4ca8WtUS2Ls1/ZIucvwfxYGmbG/GYT68fOIJ5+cmqIx+
         RuZrsLmEo0btwXJxBHdKU3rExVsB9W8m5gbCqV06wUXkLiHeBTo7Iq4A1B3tOm4R18tT
         YNiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvfNhOKvumn2SYo3uHaJx26l4U54CpoRzH2gOkvbBZ1B2woAuUn1B6BgcsntYNLD95YXMo1uck5A==@kvack.org
X-Gm-Message-State: AOJu0YyrAT0lRhCPg6y+mp8CJzVREoRaweK8VauVyb3nETZ10DOLpEBT
	FtpKlytuo29nZjUJRFk6/TIVRCEKuAarGEuaDcVuPk2nfxOaE/Kpifua8ehVs9OoFIc=
X-Gm-Gg: ASbGnctv1/SyyVtcEZGlPvagF1P3AFJZEee5a/pm65cEoRhZ8DeabBSljapfEVct3T8
	rkuwgLP62L8AskhlpKcr+neoED0LYZv24WBfMolvKluEqvnkDyeZJ+HAZtbqOmyiBEYIQxO8/aD
	f9Pyfs2d6AF9GCjKNfYcGCiTsp3RAifcGRNess1HkYnUaCyG2wvZGmL8+IqN8oo/lIi6QcOuKLr
	oq6fOqDQT9JfQX3N9ZNAIzJSGztAXkro/N8HZd1Wh77MWKxLuwr/xB/WGiin4AIJGA0EaQe1KRS
	RxXfXKTshGiXAuhuKCrefw5/OVOVbtiEDi4EMSDrjEnC3WWsIkYcLsowE+m2mPqSqP6FyFQLsKQ
	xD5XKx9qBtj1LfiDeXw3i3s/Pkuh19BXR6OwxY417UCZQy6TArKPm1Fbzrx0ibkX6OFobhUPOHH
	mGyFIHvAM5l9ZvvIKxyfmMLSuiKTJwJ+wyF9Tn5RVkLXoxP/nucxlHMJ4UjHHAk0naJvGl
X-Google-Smtp-Source: AGHT+IGXdgJBU9rOthXQn3qIN5f0W9bnIxb8QN9M+K/3J2nID5vEHLVPpJIeqX35ivPrktOa6aleug==
X-Received: by 2002:a05:690c:380e:b0:787:b5ac:68e4 with SMTP id 00721157ae682-78929ef765amr35233197b3.48.1763135643981;
        Fri, 14 Nov 2025 07:54:03 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:03 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 01/13] kho: Fix misleading log message in kho_populate()
Date: Fri, 14 Nov 2025 10:53:46 -0500
Message-ID: <20251114155358.2884014-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: ECD89C000A
X-Stat-Signature: pko1sd3fym46ru1a7kejnx8pnjqr8w7p
X-HE-Tag: 1763135644-572579
X-HE-Meta: U2FsdGVkX19yYakRGy2YG0J/u0IF98G5+ORbTFa4ckTN3afbX5auuOhZyaEeydbj04MBKaA7E9yKxHAnbItSd6wv0EvQ2rBBJP+DQuJ6KOMmaJLzb+ntZ4VH17P//OvmiyYmKErwH5E2v6yZtBZyF7hU0L6pg5HL6YgXNkjlOzAfmi3eu2Xstb4GBTlft1820/Sgn8cfPiNuE5RBs5axvJDBlNXPNZptwIWI5TfzLjpqwMPa3+idFKAz9ybAw+q8kmYqUIz/5dNRy940fc4EtGkxvNSRrZeqcF6VOne1RwVR2viQ0odDH+uuuMGJL82dEiLMsaTnT9XQD8PA8awSK0o/Q/rGeNRb17n+W3i8HliRWG69YEbNo8G3JX0nL6v1Rky5U51fAl4xhoy81q2KNl479g4ep+66c2M6YnvgAyPLVo/2v+nlqqbszsxgqN+IA6hCxLL90/11y7CirY+LWNVZuMbe0vslxnMtuTFBxSg5oD55h2h3CuyzrHtyV8X/Ue0zGjSCs/CPSIz1o9jbnbgybvVTnkANe3PUNQR/w1AO5U9fPSLMwSX+blW3ZJQm7tC79j87GvVhnsqY2JowX8qeV+uCp5QGd63uHcJtj+joCN9dVadKvdspXycqhvFu4+j4MOXEYpfB2PC7OGx2rw4jTouqjwGxZo4PVNmxqXnCDPdWa3OVHtxE5IhjgLMJhh/EjnmauH2d3W0Y+OQacG/C1pGF1ABDHyHikPTXcw7CHKDqoMXRavyqmzaFBCmxL79nQUu2igOJ0aChxoXMGVGDjp/DAQocosElLs7yNN3ccgMhn6JIYzk3GOlbGhjyZf3fDn7tlSf7kK4N/WGMDgKNDzSTfHtDksos3nCDXL6xJXOZJw7eGU9T5POmN7jGtEw2/0T5twcZQ+XJb1Oh0fSnwtaH+LByQB6QoxHzOaNNTu+p/DAI3Xk9izLFFqwgtAUeYaZUItgNu34yfXd
 YgOOvUg1
 PlCsvcU4d65cPKajVckADst8x6W95e30AcpDxtzmtY8osrBpEgtKveMmFKwli2ihYgwLVThbd/pw9mCcR9kRS/QxwoxLe5lzIyh9D2b7LlJJIUOLqeCpDUj4lV/eOm9FefpZhBQoX0Z4X7k7KKdWuTp2LcKYqytazt2FrAm+N3fIEjAjAraPy5K/s6G9UpykrEF8Q3NlBtw7LmyIbjJ6Tmhsp1/dNAjCHfoyMvVJNAFgjbog95+WDd9/+KP8v3UQMhIGyTdYPGPak1hbbDL5ugYYMLOWG6NKlbPFWTansV3reqH3qoKYiL094b2OCt+fNR4q/V2waHTbT48zU/t0nSGGCZxITmG0FEO4Y11htVAC4VCunDw9zeb1LQ91GxVLm3V+3oElqbt7sjPojgb/5nr1DxmQx4KZezOk9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The log message in kho_populate() currently states "Will skip init for
some devices". This implies that Kexec Handover always involves
skipping device initialization.

However, KHO is a generic mechanism used to preserve kernel memory across
reboot for various purposes, such as memfd, telemetry, or reserve_mem.
Skipping device initialization is a specific property of live update
drivers using KHO, not a property of the mechanism itself.

Remove the misleading suffix to accurately reflect the generic nature of
KHO discovery.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9f0913e101be..6ad45e12f53b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1470,7 +1470,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
 	kho_scratch_cnt = scratch_cnt;
-	pr_info("found kexec handover data. Will skip init for some devices\n");
+	pr_info("found kexec handover data.\n");
 
 out:
 	if (fdt)
-- 
2.52.0.rc1.455.g30608eb744-goog


