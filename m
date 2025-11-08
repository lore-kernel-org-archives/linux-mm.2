Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB187CCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 16:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F65C8E0009; Sat,  8 Nov 2025 11:18:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDC48E0003; Sat,  8 Nov 2025 11:18:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A8B8E0009; Sat,  8 Nov 2025 11:18:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D69E8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 11:18:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C34188976E
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 16:18:47 +0000 (UTC)
X-FDA: 84087948294.03.0F27309
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0B40340015
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 16:18:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KCJvkijS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ankitkhushwaha.linux@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=ankitkhushwaha.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762618726; a=rsa-sha256;
	cv=none;
	b=Z4G1SlKUwFvV6QgTZhTOYdfQYvfX5Y1dwljAFKRhMCq+F1MAhgezSWVRzWTL8J6aQkdorO
	ijoE7ASxpjy4YSWlDSR2YjE6ZRrf2OFxyHPUM95CQc67BXRkX3f4xO2anIdXCXEaSpQ1Ic
	nv8F5VPUv0jA6+7E3XovUFIEznGltMA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KCJvkijS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ankitkhushwaha.linux@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=ankitkhushwaha.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762618726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9vBksDJnztjGyjVxw8Yb9adtDqx05xzbEcYJxzPS4MU=;
	b=0ZDCj3thhLp9NwZnCUdc6J82KmCbZUtZ+s3MhCt8NvKe9hXBlN9YX/o4qJ4YDRkzzdPXZI
	vwv+Hk7idjRiIoMRqBdUfg2Edb55GVjnPHDoZtXE5c8lylN/+HDrwnqar92qg91UUJX4HQ
	ODsOGyyucotOIO31TbMmjDvPS+0/+CI=
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-340bcc92c7dso1653998a91.0
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 08:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762618725; x=1763223525; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9vBksDJnztjGyjVxw8Yb9adtDqx05xzbEcYJxzPS4MU=;
        b=KCJvkijSsQWzaeJhwheSCsAkaPIHd8xSlT6LbXiQmfIooQZPcIgO2cLXuR/25GZb4f
         hj819jLhSALZ6lkMI/1u4pPi4gscKpLgHYbf7m2G7PzTYKMyY/1XiPgmY1sdCPRBEeyb
         2xpdefsd7zJt7RZie2BOBaGBYc6E9mdK1rG3vZswo9XCidhdllRftFhBCOO+2sPlchkR
         j6K8Q/hmRDBdcKDQJTn7kFDkqfs4N7SESVTn28iEp7pTJv9JZCUA+vUZrFqLlcVWxIrz
         1LHqOut+67eIPRcwmhlZ0JoY48t2e+7E5SBOD00QFtrGkpZkd1VWQULaL3BM8N44pOHA
         eACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762618725; x=1763223525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9vBksDJnztjGyjVxw8Yb9adtDqx05xzbEcYJxzPS4MU=;
        b=UxzFG47fsioT2rLH6n0zOI4BUku5G+1WFm6Q3V1vC9XtTMUYUpJVeG11hefNowZBmb
         4UrlNOnuF0LAJct8LzhZ9lus5+d8PZl/Mw27IxwW1Hbg5A4QfBy8sxtOjUBPi7606y6b
         5DPzTi0jy+S/6dupZzmTtVRUlh7UjDq/Cs9OeZsXhn/BtgSO57B8qzuz3enQglCSwa9e
         OmliT++zDkSAY5g5k7SMd/KcuJuuAa6gWN5fmgO3rQ6T/AuiMolQn2lJRXoxSk9PdPbB
         LyC0VATwCBW/ziVwa3unLCh5b7xAbkLEviZi8BLAAxgJSjl4Alu2m7W5V+MEU6oO/E+Y
         WXYA==
X-Forwarded-Encrypted: i=1; AJvYcCUFOr8RVrHe+X01QSZkugAnhElnq5ufebTOZm3G8JKV0UnkB6mUhWoRAxklmwsiGpMHjtsslGt+xQ==@kvack.org
X-Gm-Message-State: AOJu0YxZ6/JayrFpAAjsrVE4XIoNJWTtvIfGEZYo0YRxYlVfcOP0Sibi
	Es5xSs6azKku3ZTHFVrXIgnLflhIjfhoJ3LNlsQSZrdjMCdHfGV5RyE5
X-Gm-Gg: ASbGnctvrhiP+zTlloh4R7+z2TUe9I+M2NHLht0hbB/smGKJJRXoM4zVPd++P0uR3L5
	rG39MtJhrLLQS8AxyKm+y2w2uJqhJC+QmzXR/B68k6Vh++VM3Fu3OPNjm+8j63LiqwLmEh7nvKK
	CaYQh34VLz50a6x9+QjyQcx7H7UQclABwg6Pgjsa+D5St4oLNySV2eVj40lBkmy7RMpNWHGufGg
	2dWdSj5T5v2KjqgMf1yMnNIbcA1Pgjcs60jfqzAwdkSWYiRHDr9EnxlXgMCwCfawgGLATp0Z73t
	T2lhLOEdU4KtKZTv9Jv/Ir08vsiuYoXwYxn9CTE3O1Xa9lzQBEz/mpAgGTUITWMgLPVGONYfHYZ
	SR0H4iWVlH6nPBqJDvBwe3nRRs8xHYDOUWT1QaEGFqDhFORBxHigIy9EOLO7TkwC7jRRyAPEHWs
	rCPcnFPwgN6B/jjV0JG2bgrif35nglIzXzXXHaFpMj
X-Google-Smtp-Source: AGHT+IGLxQf5Mvke/vM2EkF6/583Zl67fDA8/F7qScezPJe1ESf4y4dMVf2DpQ3IkfNkW8uyBNV79g==
X-Received: by 2002:a17:90b:2f50:b0:340:b501:7b83 with SMTP id 98e67ed59e1d1-3436aca72a6mr3619510a91.10.1762618724753;
        Sat, 08 Nov 2025 08:18:44 -0800 (PST)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3435e25e508sm4310773a91.13.2025.11.08.08.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 08:18:44 -0800 (PST)
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Subject: [PATCH v2] selftest/mm: fix pointer comparison in mremap_test
Date: Sat,  8 Nov 2025 21:48:29 +0530
Message-ID: <20251108161829.25105-1-ankitkhushwaha.linux@gmail.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0B40340015
X-Rspamd-Server: rspam07
X-Stat-Signature: ta5sp4whe8y68kgp1oodo75bjk8usdz9
X-Rspam-User: 
X-HE-Tag: 1762618725-315745
X-HE-Meta: U2FsdGVkX1/272ThqVCXnQaennARW539D2NI6VtOqk4fq7XpsrUQUYECkEuMAYZctZq+A3qCove3geTR7z6Rtmiu1+VcNGUgbLpwB3mP/iuSEcwhs/VvuXs0vCYDY3TkWE+dyi5vwU0N4Ms9l8tYaHZByZaLwsLCxt5ynhtlLRSpXRe27fikAuUucDDsS3AmwY00XXgiSU32dnuZCyCDwK83MzAjhPVuojQWozJOHVXk/zJVRiwDhRbYA8B2Ipt5+xu+6BhfNj6QTQNOELVjMjk3JjnBV2eMzulQwr4AA0NW/S61RAHV7xouUHlBZV2h3XhvZEb9EnoEAKZJDq2h51PGg0oNZMoJwStdSHbag01RH3p0kPoAJwZyfrCOcputxt+t+PJ7vY3VuclgSGgQteORaewBAMAdDyhrbQZrmr6e0YAmXhH/uneVtnlEJzv3EONvucWVtX47L2GC98NY95Hpkss+lG04TLtbxsxiawROLrMyEroSuflGQ0C+dFr7gf3wBssSHSMDOotLr+H5Etwi3IyyrK5FdFmLegRWOLcklUK9IzLzJx0EJ9mcUzbDciu5PxD0BAYv4Yqzu6ULYkyPxA+gmiTpepTu81ZHHEc+5BxajudXR8cBdGFMv9oQGzyjQWkDM2VLDHqMOLV3ewX5ycEXvEU9fQN0AvShWIubVi2ElzJgTIJS6tgLryRFTioV28qxn5Qv0ce1DGOoqAxJi+Wnnsnr0fIF6wKdPCRJg++EbWactNbWHfju8BJoURW8YZta3jM93xMWFKmg44jB8yRXPHxGq5CO5sKsgfTwvscPFqP80Rf7COkCPzPdRLzRMwKspq/WQOvFJkSTzAEVY3cSr2yyTlOlw3W97MhLIm3N9PF8Ag/M1G2oiZJdyPj03QsTHxKB1Y/oDMWEQJEpaattIJJXRag3IUMIAfZCj0VoWFJQ3MhUkVqyYr/L2Dswvm9fYIyITU5aHxH
 d/L33jGn
 jpR6akh8mzJbhFUjF93qQ+T/LAEJ0jF4pbrHHXaJnYb7qFL0H4u65bSZ5MEIXtzVJdO+KdDyI2KkH57eJTTyPCMe90gOFBWvK93x6+IDR/WdxWtuEWD0Q0wFRjquXYhVr4MxC+mOC9LxK9k+gAd6AKoYSzUeZnCdx4WWfxsSLqoEJ5RsGTt2hJQqgc/MQ58MGOzKd9Jneor3ZY1uYRzMIy4thNewqoaaQhxyM09y8klfh3nD6CnE4fpgE1l13e2MjcRwX8ml/u1hBkCC6XQZrJ1MHNlAcQldSOCvP39BaLvmrC7MyNQrI0hWm21iMoXOPQFgpuz+TiqNWSnvuUprQ+kwdilkZXt7MGFiUAYHc9qzH1ezzump7MqGbmkWAbvTggGR0dM7935KjPUaG/34PADhQp5kHV1kfTI2dqRq94HrGg5QWSGvYUe0E+Yvny0/0AJXKwfyxxWZjotJcxKeIwhg7zCBX2Sq3u6MpS5rq9CzasbZOngJEWcUZnQZZ1Lo+LrnUZh6MZwpHdyXoUjkqYjsd9eqyKEhJm2AE/IEQTIE7xy91Dq6h4mi1jnjrYjlndqzyncF18ukpEF4yE99FyY77fhrJdFIJSNQz6aBABUWkq4isfts5kwbn5TNmWdbL/5aZ+rqWV2hDfcM/98WLBj/q8KM/jnw/w8zW/zRptNwk3In0l+QLC9/NM1dAb1xDD53dKwoFN3SvT4o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pointer arthemitic with 'void * addr' and 'ulong dest_alignment'
triggers following warning:

mremap_test.c:1035:31: warning: pointer comparison always evaluates to
false [-Wtautological-compare]
 1035 |                 if (addr + c.dest_alignment < addr) {
      |                                             ^

this warning is raised from clang version 20.1.8 (Fedora 20.1.8-4.fc42).

use 'void *tmp_addr' to do the pointer arthemitic.

Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
---
Changelog:
v2:
- use 'void *tmp_addr' for pointer arthemitic instead of typecasting
'addr' to 'unsigned long long' as suggested by Andrew.

v1: https://lore.kernel.org/linux-kselftest/20251106104917.39890-1-ankitkhushwaha.linux@gmail.com/
---
 tools/testing/selftests/mm/mremap_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index a95c0663a011..308576437228 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -994,7 +994,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_siz
 static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char *rand_addr)
 {
-	void *addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
+	void *addr, *tmp_addr, *src_addr, *dest_addr, *dest_preamble_addr = NULL;
 	unsigned long long t, d;
 	struct timespec t_start = {0, 0}, t_end = {0, 0};
 	long long  start_ns, end_ns, align_mask, ret, offset;
@@ -1032,7 +1032,8 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 	/* Don't destroy existing mappings unless expected to overlap */
 	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
 		/* Check for unsigned overflow */
-		if (addr + c.dest_alignment < addr) {
+		tmp_addr = addr + c.dest_alignment;
+		if (tmp_addr < addr) {
 			ksft_print_msg("Couldn't find a valid region to remap to\n");
 			ret = -1;
 			goto clean_up_src;
--
2.51.1


