Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2B2606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AFH7tUh1
Received: by kanga.kvack.org (Postfix)
	id E54D56B05B4; Mon,  2 Nov 2026 05:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C996B05B5; Mon,  2 Nov 2026 05:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4DA6B05B6; Mon,  2 Nov 2026 05:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A47666B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:02:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F6FD120C6D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:48 +0000 (UTC)
X-FDA: 85389740016.23.7DDB5A7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 67842100003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AFH7tUh1;
	spf=pass (imf14.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4Em7Py7g4q0VGn8W2HCRonK/evyicnat7HWkjVfGeQ=;
	b=xeiUR1o5p/v33sggQESFwp5cFQZjdJH9G4eeG4ci72pUuawoq2CFaq484X/dOzpvqFhNlY
	2j+AhR2SuMnjOAfDfPHY/GGP2AEYwag3gdxNa39QqqAJp1kGQjzS6r/6bGyQXB7aGM8wEA
	FZFMokKAhw02+2Xt4cn/Dqz1bHF/8i4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AFH7tUh1;
	spf=pass (imf14.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613766;
	b=6ZDRu9z3zoKM0x0dFwtvbXG17wRd4YXtXWzkDcmOQAVoiUYgULeELHTHduubW1iN3UcgCV
	TUY/FXMpngcjWatAT+4pRRBfmrHhOdv62Y8jbY23e5vl7Hug03zzvOUvGc6YQIx6oQZGHw
	cr5oZQOXLYWhd043KCCpXlBwEiDpn7U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FBFB1595;
	Mon,  2 Nov 2026 02:02:42 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 32D743F59E;
	Mon,  2 Nov 2026 02:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613765; bh=4thU010nDUqthwP71EjUPPcaPA4vWd28xw0e1Se/q+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFH7tUh17/igJI+PU3NpCguj2gqLFnslktS0xnrfE8IGjqLMMK7IercLlwfXxs9pR
	 Ce25TkwLPR7wn7Sje93s/IXgJH8o1Er83jVJ4xZGbGSqjljynF8nXEZzTSlNDpI7PS
	 r/NDt4VY5A8VqdlUAYrftBfXbfBX+nwwfw5ytzlg=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND v2 02/12] selftests/mm: mremap_test: drop munmap() checks from cleanup paths
Date: Mon,  2 Nov 2026 15:32:01 +0530
Message-ID: <20261102100211.141831-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 67842100003
X-Stat-Signature: 1e67fc73ipait3rk11nkbcnnqb117b8w
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793613766-63373
X-HE-Meta: U2FsdGVkX1+7+icln8bOy9bJ4zsipUbuCr5hJ7NCzCDyZXRCO/L8qQEfSghW0vyJSVHCKjoIsxTq6RDRNWqLCyQiJEqMbVIwPWeZB6o9eLwwIlLnfKeURZYdmKzy7p9g2gZg11mDNJyErDXBxEUoodJIwOEsbYspPSrUlnXKPoNC+S8vdXdDPRakA5KB6BpsunXt0DXAb7//DF3kH4goofS7TJK0QFBfjEOMUdcoZLsUXSkRfoLYe1Csk8PX/hedMyZKZTx6Lnve/8QqvFBTv2sRiYEyvnFD/lqBI0X2K19IODK9TexOpAPFsQYL4er7pOIulrH9Lf6FlZYB117I0ZdOdcDjQTRRISb1cpt9wjmSnrrVRMOuypiAMChbYG3xLeOz2wg90/8CGlSYq4yaZcQGpi6phLPYRZRlKPHs7qmNDAKuvqSUr5fVT5LKRWeelrzINig1VzbaGBxriktSUNNsU6tzOkghu4oW9W3BAiNE8j8aXnWtYg/3NtTEAkBcrYh5Pi3KnmAleJLe5i4VBLK0rzUGu5yBUUgJb+gDIn9tm0LOJzGMiAOoyJ1fpUjJCWcY4IIaLsUs8La8bkbYfMl6gX9HuGVAhxa8hT5SxqPDU1Ybwtm+tXhhlOwy9J8UeDMb7KKSHDCgf3rBWsOrqZF+l9LGLjlbuGszEetC9fHwA2JC/itpSg9ODbF11a7QCYIF1qQUa9SocRMh7tZhiIwayNUmf9LHGgC8kN8ufaMR9gs+FpD8B3Jzoq9EEZspW88XtIB5lgcYtWMnZthTHD1g0lmdnhbACZlRA9c0hVIa93pj6iwJReAoDZWVdEDUN6y4GONB82+tR4QD4KrbWBEQZNFTHv60Z4rZ7Q2NMpNs2xvcPvb0InSEZIuCPj1kidqPuf411fxWTosP1hlS6dGf6C9/nzalQqDVmmRmjv4P2lXDGKmISD6DvOWTpvZKnBnX1Lf6hQzzeMA9KIf
 bpq5P9vC
 pFUUi+Jgu4YtZfKWr82aJMCOSS1tJ04uPN9UCI1fOl1B+Isuy5lCz/MalGoD9TJw8m5H/bt5zRNFVZQ/XAGix/c09KwksThya/gWH8Kjuypz/knx8Txa1Z79JYZJVzDTs3zDLvwbgSwY+T31s40if4pWa1vSSfzJgMg8hr2IlQuIGuACmTMOU02xjVWtrrGHzbDK9ZRbKS8sMalkDp//kflaLWKz6+Wlo+x5xePSUfaRXWFJNNHi/eTTgAV7HaNGJWL5vITnl9vl8T6rkEq2oPqwDrZ012XAf5Pdu7vMgX/I0ACA/06k7q7jcgfe3iY/Eux1Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 15d8f7458251..ea1348a9532e 100644
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
@@ -1146,11 +1137,11 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
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


