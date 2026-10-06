Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B4E5CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1B56B00A7; Tue,  6 Oct 2026 05:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9396B00A9; Tue,  6 Oct 2026 05:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780DB6B00AA; Tue,  6 Oct 2026 05:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6DB6B00A7
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:25:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF90BA677A
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:37 +0000 (UTC)
X-FDA: 85291668714.27.00BE016
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id EE65E140003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=o4rRTIz8;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278736;
	b=e5vColm+DvIQcznh5ik1+FwHqI909odR2MZabvqGC3h7Id7k4e1z8UAoh3hRbCMjpXHI3P
	AXn1Us950Y+h7/WJI9j7XCPNkmcG+MDKcxJsJsjyukhadv+xowUSmqb3Y3bZfPr5WprrHU
	8l9a0mcmay4Dp1o82TD+eU8g6xstq78=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=o4rRTIz8;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=589cm4yQ6b0/8L56dWN8dWjDdEX4eYE2CfXImIeDuxA=;
	b=pTH0g+sPI00VCMXOGFua0wrqBwHd24hdTGGKLjjF9YMboEdBrPAADuozNlaMlYz6NeDNCH
	5ox/j4KgIexnS6gdGhPKTA8SP8mtpvKDp4kJfeubRs+P+wa9gB8XIjH8ynbTRkuPruOlLg
	DusNmVh9WPwfQq7Z/tTJsx3r2P/Cstw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2B761516;
	Tue,  6 Oct 2026 02:25:31 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DC12E3F763;
	Tue,  6 Oct 2026 02:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278735; bh=IF3lUGPWMJzNvOuGwTaC/WBQpUsleXIykIvYsx0nECU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4rRTIz8i02AH/FtWQAVblnib4ItIIMS9KkATZu3f+BZI4kar62g5m07E45mleaGM
	 n/ZRG9gvU7bAhNRpT/TYnoyze9p/ULxXN5IaR+dBiazUP7bw6Vk1NoKbw1Un6RJyTB
	 5OMWfGRhFdeLWBrLq6CJS56vyyus6UrbnxPGvln4=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	jhubbard@nvidia.com,
	kaleshsingh@google.com,
	anshuman.khandual@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 02/12] selftests/mm: mremap_test: drop munmap() checks from cleanup paths
Date: Tue,  6 Oct 2026 14:55:01 +0530
Message-ID: <20261006092511.145776-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE65E140003
X-Stat-Signature: ykhdoimww7c54o944hfsdauqa4zzsp5w
X-HE-Tag: 1791278735-736679
X-HE-Meta: U2FsdGVkX18LiiyZX+04vVmxWQTTj7PMhhk340Am2xsQroGJ5UoiQKorwenDQtZUDXMQ+A4SsFgPSRy/5Sjeu1ZVrq/+ysOFn3dyBoKl3PZOLTj+oX7VugHZ8qG28EJ+Jnw+WGwYvQsSe6S/NziWP8yzs3Pk7oESWf1TJK80JWTS8fTWYud5nGREKMgeaFgVq+wQ9+93Gta5ul2p2WOJB0EduUxjKbKlEELEq1kiARhbm4KWu4z3ugnMeXh28cwhnqt4D2SgJ25vcx6okcWQWjqpbEl7IkoRobGAJiYsbCX6Pd0Zdi8yScKfQX8fZs6EYeAlx4x0+4e6RYxZZ1JrM16HdV7SIMrU4z4gdpDZhElrEuA6uJcAtFT8jq8+AjZ3tyya91w+jCl0u0QLzy50qPYfY0Vcn1JrVuZTsjyfaHnCKX/45J6PqKkhcI8RGQZzUrIw7lC6Z/ZvDXMw72EVaOUJc11SlEZMU8SjQEvvh07wfAMHx7sLjXsjA1ph29JgPz9pt17ArLLDgaZLwtPu80sp5iqI1grsf8Igjfc9e3L4JCrcwrn+X815/l93Q9QxLLDT8cJTFqpOXWmVHDL5CWbDFndMDkh/QgfSsy0Z+2iA36GfA2guhEqxSqqXi+xmDdVAtV72xDymfx+hE4LV0tGOJ5COTVrtqsu6PULQdZxdIFCzib6H05mGT6eAdMilXTGdm2IVEQQy3AF9lleA6f6xE3GOE7sTP4MmtIxjYWxJzd3kd6OBH2XUShHvfvRSQAyHI5NBWDsGVTSRKajubwVdhzTQr6M+Y/x047s4Nk+Ny8At/l/YT/7SL/lmpH6JFS5B64RZHwSlnL8fWuBhwEhuq6eAbolW3gvtdvopI4VJ63vRn7Iu7KPx+rKq2wY5U036JBUhvOegrjl++ZbRub2TP2GxkpPCTV9+wg1qaZQqqdk0ucNXOjF5cAHjJKeP/KipPy07OzDpU6m+fHN
 PscKkQo1
 abBOusYz70wD8FRAjru2GN4LmJSxklrUUzn38UvzlArBIidN42Uw93+bRBwsMe9VGEPQwtObYY4ys53rqOiBiSlv/R9vQ87mCuHP8ORlaHmBp34WF+u6Qf5roNH2UE2/NuB9aaGC+V9G6tFcqiW4ZxZ+jz62s01K4uVrqWKZNaBetgNEFh/fxU8aezxhkeOjPZGpXxnIOiXlZ7lLxq19WOSNxFsNXwksL51a0MveD5cWyyx8EVkVNRkTDiW4B8g3jgLOwHz+tJkVqhH7Hlqwfgz1AvzVKVZRNwOea8P0YmZguQr/+d8670UxFMhMdRAU7mjPu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mremap_test checks the return value of munmap() on some cleanup
paths and prints an error when it fails. These failures do not
affect the test result and there is nothing useful we can do
about them during cleanup.

Stop checking munmap() return value on cleanup paths.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 35 +++++++++---------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 41f211c39c83..95ce6563289c 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -364,8 +364,7 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 	}
 
 out:
-	if (munmap(ptr, size) == -1)
-		perror("munmap");
+	munmap(ptr, size);
 
 	if (success)
 		ksft_test_result_pass("%s\n", test_name);
@@ -510,10 +509,8 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 	}
 
 out_unmap:
-	if (munmap(tgt_ptr, 2 * size))
-		perror("munmap tgt");
-	if (munmap(ptr, size))
-		perror("munmap src");
+	munmap(tgt_ptr, 2 * size);
+	munmap(ptr, size);
 
 out:
 	if (success)
@@ -590,10 +587,8 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	}
 
 out_unmap:
-	if (munmap(tgt_ptr, size))
-		perror("munmap tgt");
-	if (munmap(ptr, size))
-		perror("munmap src");
+	munmap(tgt_ptr, size);
+	munmap(ptr, size);
 out:
 	if (success)
 		ksft_test_result_pass("%s%s\n", test_name,
@@ -713,10 +708,8 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 	}
 
 out_unmap:
-	if (munmap(tgt_ptr, size))
-		perror("munmap tgt");
-	if (munmap(ptr, size))
-		perror("munmap src");
+	munmap(tgt_ptr, size);
+	munmap(ptr, size);
 out:
 	if (success)
 		ksft_test_result_pass("%s%s\n", test_name,
@@ -948,10 +941,8 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	}
 
 out_unmap:
-	if (munmap(tgt_ptr, size))
-		perror("munmap tgt");
-	if (munmap(ptr, size))
-		perror("munmap src");
+	munmap(tgt_ptr, size);
+	munmap(ptr, size);
 out_close_uffd:
 	close(uffd);
 out:
@@ -1144,11 +1135,11 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
 	}
 
 out:
-	if (src && munmap(src, c.region_size) == -1)
-		perror("munmap src");
+	if (src)
+		munmap(src, c.region_size);
 
-	if (dest && munmap(dest, c.region_size) == -1)
-		perror("munmap dest");
+	if (dest)
+		munmap(dest, c.region_size);
 
 	if (success)
 		ksft_test_result_pass("%s\n", test_name);
-- 
2.53.0


