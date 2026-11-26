Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F84606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 01:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=FfrJVv9m
Received: by kanga.kvack.org (Postfix)
	id C796E6B0B44; Wed, 25 Nov 2026 20:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2A5A6B0B45; Wed, 25 Nov 2026 20:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66E36B0B46; Wed, 25 Nov 2026 20:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A80E6B0B44
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 20:19:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD8DDA8D4D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:19:07 +0000 (UTC)
X-FDA: 85475511534.26.D9BDD15
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6FF7AA000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:19:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=FfrJVv9m;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf15.hostedemail.com: domain of tongzhiwei@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=tongzhiwei@cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795655946;
	b=2I8ePSv8ioLZ6YabGhDJriVyMqoKl85+IYtCs2xT21idzA3A+p57S4WGp37WJlg5TVsFvj
	1iHVWJhlDglh2rKHZ9wndEBLUDiefq3pyIHZ9ch8gMnw+NPuQ1c4me14IDNKNzIZS4nDgP
	9aqKsGIrjhu8AcXg4mTCybtU/U5oDZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795655946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/bP0dHnKGr+2Tueqse6iudbEche5N89ZiaGs3zV4IFA=;
	b=NTHO3K3drI3yJReL2JTvtx7WEO+CXLoCRK+0XJLBuVriMfBpCtjT8UKLQHHW5J3wTyOqvt
	TJBZGBt/Er87PKDOLQxtq8Fl6oW71jPgUr0/TP6g05s7pEdZ1MFlwtE6alwzZpy+VCdAi9
	Pv+k5wVK5jDZPF2bnfbwnTqWH2w/DEo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=FfrJVv9m;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf15.hostedemail.com: domain of tongzhiwei@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=tongzhiwei@cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=FfrJVv9mTW7QVFhOgmELvlZsxM3ygecgmrFKsbWzT7hMSuXVwT/XLMPnEffO84IqI0T7W1E89m/rM
	 rEUj5+Iy0qd7s4iNKNOBcrjKpmjqIj8ksQzLGwWGDMWxHnrJheewUYGeHP7OBoehfZfg1QLEnVEekX
	 CgcH4Mpz7sLBfAoc=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16b078901502-31385;
	Thu, 26 Nov 2026 09:18:59 +0800 (CST)
X-RM-TRANSID:2ee16b078901502-31385
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee96b0789004cd-56c91;
	Thu, 26 Nov 2026 09:18:58 +0800 (CST)
X-RM-TRANSID:2ee96b0789004cd-56c91
From: tongzhiwei <tongzhiwei@cmss.chinamobile.com>
To: Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shuah Khan <shuah@kernel.org>
Cc: tongzhiwei@cmss.chinamobile.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/cachestat: clean up the mmap test scratch file
Date: Thu, 26 Nov 2026 09:18:15 +0800
Message-ID: <20261126011818.417-1-tongzhiwei@cmss.chinamobile.com>
X-Mailer: git-send-email 2.45.0.windows.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b594wnpcxtgd54pc3yuttusjtne5ud9i
X-Rspamd-Queue-Id: 6FF7AA000C
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795655944-904613
X-HE-Meta: U2FsdGVkX19UHYs7JknjJbA3+g5uJcpuT69gWZLxg4ZS2ppTohAhRhz21SXkEu40yejeTqJc288f0Llkhvzg6qTrT31aDN80Z8GdWvBCr6kzI/P7+Mwd5P5xO2hgmgHruc/Y2xFXmpR0plCoo362W5x/EEiCW2C5Rvh/DBt89XLwz7MDnwlNMAyhWtImENnCd5yfe8H9f6pwGa/gkokxhHP04OEzgbCoYi1HrOtjgajrFzxYW88LAZgvHyxBzlU2ddWrRgXiFVyd2BydYkEg+FcUqnkksMUkl+evOA2FYBsJkoATDF+WC97osQ9e7hd1SZ5rgVqeKEkCnzkprxF44a8LM7hHEn5CI5HEIvx781OoJl7S7sqtn1vhnKgkbNnkIJIgg/qQSYcLKizMlPAFZLWGP3h+o+PrNC61ytf3/unqwkIIgsHp9cZwbKNi+zOSz29XP7ZHEjAyoLpxAQdXylx266v4LAk9reeXLUS/mmnGkNGvlcf35Bk5uc/F3BIFVaC2SSplq+JsnaaaL/5ae1VJYOI6HlwEpNENgzlixJoSJqG69KZ+S5kgu6zfCtPYQzOV+W7saTJ/J0dYbhYMetWm//03GYZCQhht5DFCjDR/s4K2upRbbY/7b757ypTWKPfjqu1R7BqFcNJFLk4xA1MSUNaOc+E+vrp+eO7eDp2Lc0Wt1v1fo0nVF/hXAeS1ZAz/YD4Ox8zHrQxNsowreCSS+LNtXDeJFV6iXEUFzYa/Lq2It/wEOsg2ozPzubdn7idp98DT/4072AKcbjoQPogn14xG+Y+iWN3gqeGsxh7v20NBz5di8Vt/nKHB1cdMKkw0acTul5kcQVFGPXGAf2sQyJBnTV+3dYFpFoYh3fnB3h3vwA9urLlTLmKyVdD6HoowF01dreSV+FhRejU6LZ93Oo68ENraDUZLlCzjnujP9x/dcCHW1w4Tnwkvm2KoE4fqqfxECygDVSeKtvZ
 lDzCVmCa
 Z4PLwmgE6XoQ9boaa3jHPWT2PcLE70HHJFnsKUY0Cq57sF96m1YTB8s7US33nz0PrLxWeR91d68YgYKD/rvuKxBUamlAMzCpa53MEnOP3YGvIcVoIAVEN6CyfF65gBmuFNxVSGnOfFndzU1636ogiefG8ERwzRDT0+nes
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NOTE: This fix is found and coded by llm, but it has been
reviewed by human.

run_cachestat_test() creates its FILE_MMAP scratch file with open() but
cleans it up with shm_unlink(), which only removes a POSIX shared-memory
object under /dev/shm.  The regular file "tmpshmcstat" is therefore left
behind in the working directory after every run.

The leftover file was previously worked around by adding its name to
.gitignore in commit b90cafb43887 ("selftests/cachestat: add
tmpshmcstat file to .gitignore"); the entry remains as a safety net
for runs interrupted mid-test, but the test itself should not leave
the file behind in the first place.

Use remove() for the mmap case and keep shm_unlink() for the FILE_SHMEM
case only, matching the cleanup the sibling test_cachestat() helper
already does for its own temp file.

Remove the file unconditionally, by design: the name "tmpshmcstat" is
test-specific so a real collision is implausible, and gating removal on
whether this run created the file would preserve stale files left by a
crashed previous run instead of cleaning them up.

Assisted-by: LLM
Signed-off-by: tongzhiwei <tongzhiwei@cmss.chinamobile.com>
---
For context: the same leftover file was previously discussed in a
related but different proposal from Madhur Kumar, which took the
EXTRA_CLEAN approach (removing the file in "make kselftest-clean")
and has not been applied so far:
https://lore.kernel.org/r/20250927161141.778631-1-madhurkumar004@gmail.com/
This patch instead removes the leftover inside the test itself, so
the file is cleaned up whether or not the test builds/runs via make.

 tools/testing/selftests/cachestat/test_cachestat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
index 542cd09..5e62c49 100644
--- a/tools/testing/selftests/cachestat/test_cachestat.c
+++ b/tools/testing/selftests/cachestat/test_cachestat.c
@@ -289,7 +289,10 @@ bool run_cachestat_test(enum file_type type)
 	}
 
 close_fd:
-	shm_unlink(filename);
+	if (type == FILE_SHMEM)
+		shm_unlink(filename);
+	else
+		remove(filename);
 out:
 	return ret;
 }
-- 
2.33.0




