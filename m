Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B106D5E370
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99B46B0092; Tue, 16 Dec 2025 09:26:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA016B0093; Tue, 16 Dec 2025 09:26:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0076B0095; Tue, 16 Dec 2025 09:26:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7531F6B0092
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:26:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2779359EA7
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:50 +0000 (UTC)
X-FDA: 84225560580.22.A4549AF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 814D6180012
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765895208; a=rsa-sha256;
	cv=none;
	b=jwp6HbyeFWvxTk00MTRTBVdKQYEBmoyVPKu/opfPICq5cyiOpKwAAE6Y7ihbtfFsjQbu91
	aVd9IEghykDry1CmY9beNeb6/89NHEX3IvAe8jj/OlGhCYnqywPG+drMAjkbCdp5SNMjG1
	kP8NUqk5qSPDOVC7YSYfdO9vY5WvdrE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765895208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xxmU15c29PSUHfcyR/ihhAO96r/soQv8PLUHzY/qmEk=;
	b=Th5xQ901VhFFJ8ydJa0sY6VGW4MBtf01/vZi1+nlCSqBSqEhOA7Wbob5FalN0KqiQNnSE6
	knXF/x//5lvrNABfNXVBox1zI5FJ+jZ1WdQ1C+dwAqk0sl17g2IhG/0LNWOv1Hun5IWgSA
	9LzPAn30FtsZzIi10yv9x5fHBTmPnyY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F1771655;
	Tue, 16 Dec 2025 06:26:40 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9A833F694;
	Tue, 16 Dec 2025 06:26:45 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Usama Anjum <Usama.Anjum@arm.com>
Subject: [PATCH 3/4] selftests/mm: fix faulting-in code in pagemap_ioctl test
Date: Tue, 16 Dec 2025 14:26:32 +0000
Message-ID: <20251216142633.2401447-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216142633.2401447-1-kevin.brodsky@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 814D6180012
X-Rspamd-Server: rspam04
X-Stat-Signature: ornh5iijzzeeo5rzini4z14c8fmr9w5y
X-HE-Tag: 1765895208-95677
X-HE-Meta: U2FsdGVkX18FBx9Rv1YqweghIRKhEYzlO2BErmSDxKx1DVYgIbnekx/FN84/fBUvU5R9vCQ0cYcMyH9f0wOX3W/TzFuXOfXXGnvpLiZcQnZcpZLPJkwI7UCKHfAZethI6lXoFOvpkyp6l9fgyJ7PBJfBQAwyZKA34396e18ct1xBgDdTkf3og5RTiKgRQPC+90kLpO/6FjM02FE1izUO5qItTTDGum1TMFdH6n82pvmU0Ng4KgcfaotxXOmJdsO9xewaO31OM7k91MG7m5uq6ET2o5K6YRpsehavIdKghPmyaOv7Lz66SV+DgXYlGu9MTBMlcGPOOaujsQ55ltJNvFDqOPPmZ3OxeD6y/iTgVkU/IKxo7zktvawMaXPW8KZimSqAd7tV7pLBuBGP1ujSb85M34uM1pw6z2+vsgVtDN0TKNhi6nFFJ7jKQIwd8gZxIhU3L2K2eb83aENTJEz0sMN/gRuYxXn07WawcgZmbssQ0w1DPt+qrGkNI2ZuTVSC4/o87AysyEolEVUdYRHZ7+0YzQcEk4ZgxdOE9QFLKSrsk5xh8oGCha+nwnFomCUgYr5creGnDxwowzU5SjdEmgTALwzf1z1r914hzhzd+H7QSC9LY+YEq8oJFSM0x0w3AXKlQXaOmWJBgGTMln7wI5d2fya10gd+uqmtwYS4bmLfYQH6QIcm/DfNB+uEbdh8W0ogT9GM1yNdrtNtPjexGMyQhWVblVsZJLHn8XiPsC9U0+CkEG+K3THUq68T6DVOVF9xQ25s5a/MXyoAeIKcXAOxndPZYdS7I9JQXUSf6SNuJj2TYqLNrxb4ruOlvGPR0OXFYKhlPe1HaNVkJsFw5N9pTlQXeeu1nRu3303vQ0qZ3ZLko53Lg6igTKsx4yWCOCZalODKods=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One of the pagemap_ioctl tests attempts to fault in pages by
memcpy()'ing them to an unused buffer. This probably worked
originally, but since commit 46036188ea1f ("selftests/mm: build with
-O2") the compiler is free to optimise away that unused buffer and
the memcpy() with it. As a result there might not be any resident
page in the mapping and the test may fail.

We don't need to copy all that memory anyway. Just fault in every
page by forcing the compiler to read the first byte.

Cc: Usama Anjum <Usama.Anjum@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 2cb5441f29c7..67a7a3705604 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1056,7 +1056,6 @@ int sanity_tests(void)
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
-	char *tmp_buf;
 
 	/* 1. wrong operation */
 	mem_size = 10 * page_size;
@@ -1167,8 +1166,9 @@ int sanity_tests(void)
 	if (fmem == MAP_FAILED)
 		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
-	tmp_buf = malloc(sbuf.st_size);
-	memcpy(tmp_buf, fmem, sbuf.st_size);
+	/* Fault in every page by reading the first byte */
+	for (i = 0; i < sbuf.st_size; i += page_size)
+		(void)*(volatile char *)(fmem + i);
 
 	ret = pagemap_ioctl(fmem, sbuf.st_size, vec, vec_size, 0, 0,
 			    0, PAGEMAP_NON_WRITTEN_BITS, 0, PAGEMAP_NON_WRITTEN_BITS);
-- 
2.51.2


