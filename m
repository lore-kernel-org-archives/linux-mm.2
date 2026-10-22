Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB95B606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 12:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BdopsFQp
Received: by kanga.kvack.org (Postfix)
	id D04B06B063A; Thu, 22 Oct 2026 08:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E996B0926; Thu, 22 Oct 2026 08:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36026B0927; Thu, 22 Oct 2026 08:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7105D6B063A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:18:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB27CA8512
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:18:44 +0000 (UTC)
X-FDA: 85350165768.17.C5A5ABB
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2EE631A000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:18:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BdopsFQp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of danishkhateeb03@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=danishkhateeb03@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792671523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DZU48ffXnuc37LAObRV7DmUJm85ZVuXLv374YtKlykA=;
	b=35o3AnsG/31nA9CuG3qCf+/YwEpVT9oaoj0VAKG7LysUrW3fOOYyup3bng064W9uvot6h9
	8OX8/7o6O6QkK5M132xkvFYxCb6eeeRYM2Wg4yG+C0630NgLEmMQXU3a0TV6geLpLSdEP5
	CHJ8hmWILYP0YAWL3Y6SqzPcryBJoMs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BdopsFQp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of danishkhateeb03@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=danishkhateeb03@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792671523;
	b=hl2OJebFWtYzwvgYq96Rfvh0/xgWCIGpqwWgBwkiHWx7q3r1MDEH3bVELESKfhi2ZPU55b
	VfpZnvk1QyYXHZQRBInRq+qyuckFiZcJuXcgatZm4G3BLvne7aPlpDtJwbjfyDTVQgv+wR
	7LKFCeRrsEZIny2FfHPnIBI1r4UF0Qk=
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-4ed6d69bdfaso971057b6e.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792671522; x=1793276322; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DZU48ffXnuc37LAObRV7DmUJm85ZVuXLv374YtKlykA=;
        b=BdopsFQp7FMnmeeDcNVQfJgPaFJdKbHgZgOr9rPoMbI16qltilFwDlXOoioDiAqp4v
         RmRdBACBluSeWAhJySfwpkA6igeancjb71TyzRIxAzQAnq5KZanryD7h/pzOISn6+DKJ
         fcrcbRrVYkMLANMLVfpcE4O5rSA3ck8mEWx8NCR5fLGiXzkYemB5RNFWtRvfYNdIHZ07
         dmG3uJzuFlgsdRxiOJzVCw5jxxDYX/Jna2Hz5XR75K3nJ4MwStj/lf+7APGcsGf+AUzQ
         jHiIcyjlSxk/W+HmCYoFwqGQ/781yECQ1ft1rkecyePV8wCFtTYc3KEzkdEBFYkyvak0
         dIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792671522; x=1793276322;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DZU48ffXnuc37LAObRV7DmUJm85ZVuXLv374YtKlykA=;
        b=yACPMb3D1Qz8CwluV84eqCC++jC/Rn3TnfxYEQmmMWKJAb3B5p7lAN91adE0+DB4ug
         HOFELCmbEoPkGL19zUjyADSRBKnFsvxuYpU3M1xX9QrCmFfM3oFMzHrZ16PK2HIfe1GT
         8W8CM9bzcvyuoyiJSJuhPZmQOCYl/igXZ5f84qn9XvyiVYL8m0Xjny3cuMOL8ty+NptZ
         YQrJo6I3R48sXzWpUNg/ZcfFYgtfw/7fiQ15287Da/YMNc2jxS9uo2vhZ+LUK9MoA4hf
         LUlLNW5cOkdpssJ0lbWrsnAHCdg65bVuXPw3d6QzLU5jL9vCa0WMbyHS+KEA6leFW+KJ
         GRiw==
X-Forwarded-Encrypted: i=1; AKwUvBxmN/67GQYZLGKqhAPc7NO4zcjg/LKj3UxlIS+LNIoxXhkWg47L6x6rTPhV/czs0fIA6sdmr09pxg==@kvack.org
X-Gm-Message-State: AFq9FYLGE4yhsKW9N8Wjhem+WiL+U0b25tmo/LxyPC2vk6tQTCfyXKhc
	wIwMLZ3G51MSC1KN0ztatA3/zJQEsH1jkn9v52UpNN3kd2F2qSvpGjnb
X-Gm-Gg: AYBFou1vU7Key+UKfQZGGn7Rc8F35ybwVFOmwKljpX7/ySJd8k4Bh6jQTYKcdf2qPgn
	433rb2LLGv/AsWFQHnN//CmWgBYtVi9o5NIZvxtU1FeMHIlhPV1lSohqX30bLy2WhxR+Y6+zHW1
	YNA6nwWCnGS3z3M4FGxXcDW+yRiFZnbfCl0CgRWbEqOSmK/EGe7RPvo83cw24ijdCra8GzcjiGV
	wMEXpZHaZ2Q/c5SlSvQx7blS2tS+ce8I1XWQ3LSQmIjQEY1mTRno275B6dOd/oRRMiuQ9WNHcbN
	aGiYXwgFub/zEGiLkx8pfnYeHy+fjl63PQPETI7mb/gGTdnYpCez3GWNBmvVYMyOMkfDZWj7axO
	Ie0mih7vmqhKb4S25RHDdp7RyrX/iH0o24fhw+FOugB/SO9nUtci7MymxPwuWnEHgnFM5tHPiXV
	xg5rnQILzh50NWFeEAPkphc8P3fOdRwQM5r0qKHm1RTQ0R440HhLkTp+v8/GEqhtKDTL+Zmd1eO
	MLFdK0inZgU4v/RYnltcsOwYlXOsf3/aUsfJrZrB/iqR1OS/CPhRHZd6fblEivA/zVQ3L4tPTou
	xspnDOrK+w53PYZ+JZPgTSSo15/4W4kM1f6FoYRrquc=
X-Received: by 2002:a05:6808:1301:b0:537:3bdb:2d7b with SMTP id 5614622812f47-5535d4e1eb9mr4210437b6e.11.1792671521547;
        Thu, 22 Oct 2026 05:18:41 -0700 (PDT)
Received: from archlinux.lan ([136.34.156.120])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-552b4104048sm4469598b6e.5.2026.10.22.05.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 05:18:39 -0700 (PDT)
From: Danish Khateeb <danishkhateeb03@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory Price <gourry@gourry.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Danish Khateeb <danishkhateeb03@gmail.com>
Subject: [PATCH v3] selftests/mm: merge: keep the far mremap() targets in the carveout
Date: Thu, 22 Oct 2026 07:18:37 -0500
Message-ID: <20261022121837.28723-1-danishkhateeb03@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2EE631A000A
X-Rspam-User: 
X-Stat-Signature: dnq3npauhqzorwz1p5kmpgwq666emqrx
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792671523-933962
X-HE-Meta: U2FsdGVkX1/ERme/sMrecVO5g3sHXAq+DAOHlL9oNRds050t+z4+96iKQveTh/dpt92xmxgcK6QhlKPslpkJL3fGAvHPdhrkO8lQKOaRkOOEA+ujEbANqYD2W1/lkiHfLYyJkyX8M1MA2p1v44F26FtQDYzl7q+mH7SAJV/4eKXSeeskTL9Nq9vL37v3hc8r+vFkXHIFLTxvq/ZdkbERjqhg/45Y++iCuiIPJfD1L8I3lsSsE52/TwQCAdj3nDEKLbz+w/p5YQu2tkXwZEWQi8+NV6/YQlEpm5kCxO8xD8vrPoQv0HQWlExywyRilcmJabja7mrYZDDQabOpvv5fwU8Ljp4eBmJyYPGH75Nqc2E6usPuyjLJ1cZO8twge2HTJVPMedxsh0UHh7nLcdo1w3RXqzYCouFNkZpiwmztcXvXghIFzvxuaGQ7gljZcvYCncCcUCya0CSdMYV1GXPaU8RzYxrBfrBYes1f7w5z59k41bc44smOT3Xn0T2ayeiqz26x+n2I26rJBg90Gl2vs+QJPsvWW5Lx0QoG7T+fUB78VYiHKleT1we/h9nRObO5bH67TD1v25Eq9zzvlH66HMYDsmUR9y7G/D4JzpVmqtRPv9jG8YL7nZHZd3KsomTZL5WYkas8urHBduJTITv3OC+LFtNI0NHq4ScQ6uxbNqgF8GozotMzndPCP8/weQn3ZChd3mKZx9IP0nhObu0ea+bg/bFLC1U6K076eauAyqgAwbR/VnWEbvv1qJSFrXkty0irx1jiqC7gcrWB4Zt0+calt4e8XJVC0bdooSD1ytlg9dAxng0eKb24VA94VycaVR0JYPHC0fzF/Ws/LwH+Ou3xDEkEVxA2RrSyeItdVmeJ58wpzmRMjQkDTiKnUFzniJhT6KRGHcIGH024qfVfrO6hw+OEpAT+yIGIBxYHZnkQ2xCnOobKP8eAKC9iJFvpVxqruyrl6ZsWOPhVgYX
 zNNZkw1B
 z311PPgXazGKyLgH1Gi5sQW6mzJ07MBKODG/uNFYXZOPKPPotbrzHIQp3m3ulQaBm8F4fgzsd1DjLQuy6MjWcS/l0dApX4v1N0uB7ZFVCidQXMxeR757CPRSoOP7kvMgar4Fasb4RLZ/Kff1+GdnApryUCCD0yZ5eK/8bPat8QUdviWs/JcL1kt61OLO6oYltbw131S/TV1hMx03wQVobTPGTXit2p3v5TrnMI7tCjUHl8pbISCjX/biF9WkPtKa6TiSAk2M3rbcE6j6zkrEmBySlTodHEoAqBuwmhFnF5bo9v2jJNAW/G89ragNIDQFQsZTA9f+0oQs8FsDgSqMJJFWIkUGHuIJSPRHRQ8M3tkZmRgCZ8F0eikez323i0vhqoAGvUVE50kPKq21uNFLPn0MeWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The merge tests map their areas at fixed addresses within a 30-page
PROT_NONE carveout. Several mremap() tests move an area 1000 or 2000
pages away to separate it from the others, but those targets are outside
the carveout, and MREMAP_FIXED unmaps whatever is mapped there.

Under virtme-ng, the shared libraries are packed right above the
carveout and the dynamic linker starts about 4 MiB above it. The moves
then replace part of its text with an anonymous mapping, and the test
crashes in its next lazily bound call:

  merge[6980]: segfault at 7f7ebb3c1e60 ip 00007f7ebb3c1e60 sp 00007ffd35fbaec8 error 14

Two to four of the mremap() tests then fail with "Test terminated
unexpectedly by signal 11", depending on the exact layout. On a host
where libc is mapped at a 2 MiB aligned address, the targets happen to
land above the dynamic linker and the tests pass.

Since the areas are all within the first 30 pages, moving one by 30
pages is enough to keep it apart from the others. Add FAR_PAGES for
that distance, move areas by FAR_PAGES or 2 * FAR_PAGES pages, and make
the carveout 3 * FAR_PAGES pages so that it covers every target.

Fixes: 4e25f85b9f85 ("tools/testing/selftests: add mremap() unfaulted/faulted test cases")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
---

Notes:
    v3:
    - Drop the comment above FAR_PAGES (Lorenzo Stoakes).
    - Add Lorenzo's Reviewed-by.
    v2: https://lore.kernel.org/all/20261021164810.45846-1-danishkhateeb03@gmail.com/
    - Replace the 1000 and 2000 page offsets in the tests with FAR_PAGES
      and 2 * FAR_PAGES, and derive the carveout size from FAR_PAGES,
      instead of only enlarging the carveout (Gregory Price).
    v1: https://lore.kernel.org/all/20261021011929.89150-1-danishkhateeb03@gmail.com/
    
    Tested under virtme-ng (9p root, glibc 2.44) on next-20261020 with a
    KASAN/lockdep kernel, three runs of each binary:
    
      merge before:  pass:22 fail:4 skip:1 (SIGSEGV in ld-linux-x86-64.so.2)
      merge after:   pass:26 fail:0 skip:1
    
    On the host (glibc 2.44, libc mapped 2 MiB aligned) the results are the
    same with and without the patch.
    
    An LLM was used to help with this patch.

 tools/testing/selftests/mm/merge.c | 33 ++++++++++++++++--------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 7dd2933417c1..6def490186a9 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -22,9 +22,12 @@ FIXTURE(merge)
 	struct procmap_fd procmap;
 };
 
+#define FAR_PAGES	30
+#define CARVEOUT_PAGES	(3 * FAR_PAGES)
+
 static char *map_carveout(unsigned int page_size)
 {
-	return mmap(NULL, 30 * page_size, PROT_NONE,
+	return mmap(NULL, CARVEOUT_PAGES * page_size, PROT_NONE,
 		    MAP_ANON | MAP_PRIVATE, -1, 0);
 }
 
@@ -73,7 +76,7 @@ FIXTURE_SETUP(merge)
 
 FIXTURE_TEARDOWN(merge)
 {
-	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(munmap(self->carveout, CARVEOUT_PAGES * self->page_size), 0);
 	/* May fail for parent of forked process. */
 	close_procmap(&self->procmap);
 	/*
@@ -115,7 +118,7 @@ FIXTURE_SETUP(merge_with_fork)
 
 FIXTURE_TEARDOWN(merge_with_fork)
 {
-	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(munmap(self->carveout, CARVEOUT_PAGES * self->page_size), 0);
 	ASSERT_EQ(close_procmap(&self->procmap), 0);
 	/* See above. */
 	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
@@ -660,7 +663,7 @@ TEST_F(merge, mremap_unfaulted_to_faulted)
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -721,7 +724,7 @@ TEST_F(merge, mremap_unfaulted_behind_faulted)
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -785,12 +788,12 @@ TEST_F(merge, mremap_unfaulted_between_faulted)
 
 	/* Offset ptr3 further away. */
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -870,13 +873,13 @@ TEST_F(merge, mremap_unfaulted_between_faulted_unfaulted)
 
 	/* Offset ptr3 further away. */
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -1035,11 +1038,11 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 */
 	ptr3 = &ptr[10 * page_size];
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 	ptr2 = &ptr[5 * page_size];
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -1075,7 +1078,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *                  ptr2      \       ptr       \       ptr3
 	 */
 	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
-			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + page_size * 1000);
+			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + FAR_PAGES * page_size);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/*
@@ -1110,7 +1113,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *                  ptr2      \       ptr       \       ptr3
 	 */
 	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
-			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + page_size * 1000);
+			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + FAR_PAGES * page_size);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/*
@@ -1168,7 +1171,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *      ptr                     ptr3      \       ptr2
 	 */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -1203,7 +1206,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *            ptr                         \       ptr3
 	 */
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
 	/*

base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
-- 
2.56.0


