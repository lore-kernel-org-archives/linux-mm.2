Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D382C98309
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350786B0088; Wed, 23 Sep 2026 05:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326A16B0093; Wed, 23 Sep 2026 05:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FCD6B0098; Wed, 23 Sep 2026 05:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F299A6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:26:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C57880732
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:26:58 +0000 (UTC)
X-FDA: 85244497716.21.1140A73
Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id CF5D540006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:26:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=dgu-ac-kr.20251104.gappssmtp.com header.s=20251104 header.b=ZflPxVVg;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of ts930@dgu.ac.kr designates 74.125.227.133 as permitted sender) smtp.mailfrom=ts930@dgu.ac.kr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790155616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kbAvaMWrcoRy0leTu4ezLZwt2MJV9tZljW/jEJUkEkc=;
	b=tGcISlR25zDLBZE4OL1Np+yQt74yG+T4kjGg8z1auGAFrJF91w8sly4jwhNfcgVAP18LYQ
	ITggEREswDHHOzXik8b90BUo9p+zP2IYrYxItnKgBI1n47fd/hJ+ZOoO0jKxiPmoXhw+Fr
	7q87pH8A5u3Mx0yfQvp8LuraX06RyOY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=dgu-ac-kr.20251104.gappssmtp.com header.s=20251104 header.b=ZflPxVVg;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of ts930@dgu.ac.kr designates 74.125.227.133 as permitted sender) smtp.mailfrom=ts930@dgu.ac.kr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790155616;
	b=sWIXP84zVLMRQauikiuuWdhtgCbManUsM7RAaQQb9JLIs84oidSwLpXM4V6SGWUX5oIMqn
	odvQpAjJAmeiJ0GhLvtN5oxTpaPtEE+vdROpe8DyDZ5TElR/7bOXUaCqF5Q5ZqX/TOjLUw
	WpHKbkB2nayt51jvRlB2EfAMhTsmYO0=
Received: by mail-pj2-f5.google.com with SMTP id d9443c01a7336-2d6fbdc8772so2723545ad.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dgu-ac-kr.20251104.gappssmtp.com; s=20251104; t=1790155612; x=1790760412; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kbAvaMWrcoRy0leTu4ezLZwt2MJV9tZljW/jEJUkEkc=;
        b=ZflPxVVgr2yPLr81i0oJ1D52YPPq3nqLcCu737Ko5oucXbPhZjd3D2KFg31YdaX0BS
         Cx/DZvoFrLS+MR6PLiQ94n0UUZtM754ZTAAlaxdJYqZ+J1WQESUaL+Br96j864SMkLpQ
         c/uYLHN2N0SplC5fALWoRYo9+Pjnfv65GymNK2y90SXhQ57Nyyq5DQTu9ISmxy9X6KUS
         u+BrLsk8DBvrLMOuBgX9Bw9M1aV5OMm5jlbHzziSdsVPlruWouWdPaOL1S6coGfc94qn
         Af1qwzrHcPtA/V8LX2lvnEUHOpcofLANk36dzNFr3gPqWb6ljtBCO18vRTgICQJ88MzO
         kzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790155612; x=1790760412;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kbAvaMWrcoRy0leTu4ezLZwt2MJV9tZljW/jEJUkEkc=;
        b=VtYBzZQL36irSg5c9uETg3OYquRBN6Utk7ZrsUVEtMJkEGKuNd5r/IzM68W/UVufdI
         n+8hokYou9x/SsC+o0zhqUhdjNr5SPMP9elhUnrX1P3HWG51ZsbDLkyvthSGoF3QlLgM
         yWlXaSs7vQ74CnV+2wwA/5uypN3qX4cKHYgcU5sC5u+AL19DkC3FQzWcwvynxkZRrjDa
         iD2S2RdNOS/2ifh4gjuk+Ex+T0MU8mwIWTd0bvHtI2XZoCdnhcevpxdgP9oiCSmN21B9
         mHHd+HEg5RLmYBDwuhYwWokKCB++c6HbxyQQbI6woXvi9P+ZBuuZrKqg1bwVDeb72Pkk
         XuQQ==
X-Gm-Message-State: AFuF++lW1Hgx/zHR5BLQBL0OUvgVAKsEA35umuiaSURhqJNPJM3eovlg
	Q9u7O2ptiF5m/Jz5XbpXT6GT+DRa8Pqzk93OMPZ6xzI0Z0nnr7iTmOXmkL0q+4IO5pE=
X-Gm-Gg: AYBFou33O+7k8g4habA1qvIKZywsNQl05GUBdesz2xZf2nOp5e2lC9l7cOT7hwM7eaA
	bBja+HSEG5wmGWZ7ZTnJih8YdB2avTGHnz5FUK/knQ/YtlhnIqWkkYz2t7jshXXdvMIwzslYMjd
	92VNu5AcYtTBJX9Pp8Gjs2g5gKgiQSxTE8W/Vc53J4fxg8obOnXxSpFOEMPwQ5iYNofYXNK6fIW
	fWeIAFmIUVuk4UbXJPw+Jij5fjXLwFVYKf34whOJ9606ZbXso9JyiE5+r6vhZAmnhogn2D+vfQH
	QJSHsuNNRyuls08Ub4JvlRz5rxZOFXMC9s5+aVVHk40ZtIm2QY6yBmX2TayHiMlkiQV5zDVZr0t
	ZvNgbF/jzxvwstq1ZFopx6KjQo4cFPiQkWkfJcAID9AfQFvR6L977zDO6r8y9CKAWThNL7DaSF+
	lI8KXWq+oaBqEgM2FZ4Bkf19NkrswsmfTJBrw4SZPL5WO0eaXVxxfb9VE=
X-Received: by 2002:a17:903:1b04:b0:2dd:ad74:ac32 with SMTP id d9443c01a7336-2df69d664c1mr17892785ad.27.1790155612220;
        Wed, 23 Sep 2026 02:26:52 -0700 (PDT)
Received: from PC2. ([175.193.106.181])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a60c741sm7677995ad.80.2026.09.23.02.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 02:26:51 -0700 (PDT)
From: Park Tae-sun <ts930@dgu.ac.kr>
Date: Wed, 23 Sep 2026 18:26:48 +0900
Subject: [PATCH] selftests/mm: fix mlock2 errno handling and false PASS on
 ENOSYS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-selftests-mm-mlock2-fix-v1-1-750b627854c6@dgu.ac.kr>
X-B4-Tracking: v=1; b=H4sIAFebs2oC/x2MzQqDMBAGX0X27IJZtWBfpXjw54tdarRkQymI7
 27wOAMzBxmiwuhZHBTxU9N9y+DKgqb3sC1gnTOTVPKoOqnZsPoES8YhcFj36SPs9c8eaLu5dqO
 ThnL9jcj6Pr/687wATq34PWkAAAA=
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Park Tae-sun <ts930@dgu.ac.kr>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: gerhpxwjgzzpg4jfs9bbthhwo8mcf686
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF5D540006
X-HE-Tag: 1790155613-853851
X-HE-Meta: U2FsdGVkX19lDTK9sSsFpuChXefAelbVHWkVfeg9wOvpUilhjdQLU75SWJHVveMIlpUIRDv5DRs3psQteHMbgqI6fQ+REkC6m/OxIr4P8fYABLH6WODu0xz+nzfMgru3MNk1SYjIJ29Fu7R2yLZfgtsSQ7SmN3LVOH1ogoJUv1GoEytuK+3KJdwVVpTxV1uSFut9Dhp6HVM1g9xos+muYVYHHX9cPZhkzWutzCa3YhKwx+QmxaN8G+pRD1lV89/vnbUsglmpv/+uVmw4seAwPrPSE8OeZsztXDkspUP6cOXSaa28RUEfJsOVVqJoV72Lqd98iYtVbTMzwoXs7xc7qE2o2tO1wfy0ndtDjx8jJxK33hU0mwyBtYSd4c2X0Ir+rXr2t7cDw4lkhreFK/mdjiCqz4EkOZZSQsatwCAij35kUVfQqJ/WDRoL23u9DFG5HP+p7F6LRKgLTh5ps7ntIYCsZMN98Y2OhKPeodvHlyNH6HFTGaHD3FNS1UpqbuIdKQWEwouNzu563Sb9iZfYxOj1baKT0Yf0jFNgm8EBji/anP+aUIT+QCAA2+04dmIUr0QHv2g/m0LZd6zB7DtnnC7Yjo6w8XXAAzLQoxj716CP5AZ2u2H9B60Mb1FUl1lT9UHKIn0FIlL8w1jsyOoC+qfSdsA98WnrpQQK7r/qHZUWdusDNmzrOntCmY1j7PJutyeDFdveoYAKtyCnAJv06HxN1NW0OwRLYGshSQ9Cq0M32ar5y/ixOkXa4nRLI8X+0c8CFeq935BntVHUXgrF324cjWOhgCfou0OxdgccWnin7oIe0fDJKQohRR5fN1YPUZTRhbbbZ71mJbKg7c+yP+HvQI+Z7mMTq1muRspuG+QnAHca/u5XhAk0EdZPuij1yhkM+m7fILLOnPlRnO4yHZQEEtnvR5QMA6CTf+VTwUQtGBLmT/7MCVDjh+2UHEYuAPRvq02nbqK6k2vP9Ne
 tW4zDZ51
 CDVhWhgiS7x6QYsaUXJB6sNFkKkTme0XW0rJw9/+mvA0DVw9l2Dy5uIkHIeBVi0ycDqhQ+JD2tnm764PJQFpRkcIC7B/qDSOJt7w6AVad342zhGB/sRQesAq3NYBFuJ8awPic5kauedrbEx9HPklkmaC4XMtr/KbEqnNV1LLDNTekQ9LbnJzzl51GNcgr/OTQJo/QQ9oUV1aosNIpK9WL/sNrayghrbKiBfZaKpbay7RaYJRXs6Z4pWcky6t5wZTAWfxEF+A0bb6n6bb1rjlGJWSiAU1XmmXpttl5EAlqlEjyzfAYLvXyZO/l5BZppYajbLQyWHKUnEty8EN/J1obotmew7b1wGu1SMbfb46OZlTGet6TaCQLs8OBeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While inspecting selftests/mm syscall wrappers, I noticed that mlock2_()
in mlock2.h handles the syscall return value differently from other
wrappers:

    int ret = syscall(__NR_mlock2, start, len, flags);
    if (ret) {
        errno = ret;
        return -1;
    }

Commit 1ddae9d67ee1 ("selftests/mm/mlock: print error on failure")
introduced this intending to make mlock2_() behave like libc by setting
errno and returning -1. However, glibc syscall(2) already returns -1 on
failure and sets positive errno. Assigning "errno = ret;" overwrites
errno with -1.

To verify this, mlock2 was disabled in the kernel (via sys_ni_syscall) to
return -ENOSYS. Testing revealed two interrelated defects:

1. In the unmodified test, mlock2_() clobbered errno to -1. The check
   "if (ret && errno == ENOSYS)" in main() was bypassed, resulting in an
   immediate crash in the first test:

       ~ # ./mlock2-tests
       TAP version 13
       1..15
       Bail out! mlock2(0): Unknown error -1
       # Planned tests != run tests (15 != 0)
       # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
       (exit code: 1 - FAIL)

2. After restoring mlock2_() to directly return syscall(), errno correctly
   retained ENOSYS (38), entering the ENOSYS check in main(). However, it
   then called ksft_finished():

       ~ # ./mlock2-tests
       TAP version 13
       # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
       ~ # echo $?
       0

   Because ksft_set_plan() had not been called yet (ksft_plan == 0) and
   zero tests ran (ksft_pass == 0), ksft_finished() evaluated 0 == 0 as
   success and exited with KSFT_PASS (code 0) without any TAP skip header.

Fix both issues by:
1. Returning the syscall() result directly in mlock2_() so that errno is
   preserved.
2. Calling ksft_exit_skip() on ENOSYS so unsupported kernels report a TAP
   skip ("1..0 # SKIP ...") and exit with KSFT_SKIP (code 4).

Verification on the mlock2-disabled kernel:

    ~ # ./mlock2-tests
    TAP version 13
    1..0 # SKIP mlock2() syscall is not supported
    ~ # echo $?
    4

Re-enabling mlock2 in the kernel confirmed all 15 tests pass cleanly:

    ~ # ./mlock2-tests
    TAP version 13
    1..15
    ok 1 test_mlock_lock: Locked
    ...
    ok 15 test_mlockall_future_droppable: droppable memory not locked
    # Totals: pass:15 fail:0 xfail:0 xpass:0 skip:0 error:0
    ~ # echo $?
    0

Fixes: 1ddae9d67ee1 ("selftests/mm/mlock: print error on failure")
Fixes: 65c89684896d ("selftests/mm: mlock2-tests: conform test to TAP format output")
Signed-off-by: Park Tae-sun <ts930@dgu.ac.kr>
---
 tools/testing/selftests/mm/mlock2-tests.c | 2 +-
 tools/testing/selftests/mm/mlock2.h       | 8 +-------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index e16e288cc7c1..144b550813a6 100644
--- a/tools/testing/selftests/mm/mlock2-tests.c
+++ b/tools/testing/selftests/mm/mlock2-tests.c
@@ -502,7 +502,7 @@ int main(int argc, char **argv)
 
 	ret = mlock2_(map, size, MLOCK_ONFAULT);
 	if (ret && errno == ENOSYS)
-		ksft_finished();
+		ksft_exit_skip("mlock2() syscall is not supported\n");
 
 	munmap(map, size);
 
diff --git a/tools/testing/selftests/mm/mlock2.h b/tools/testing/selftests/mm/mlock2.h
index 81e77fa41901..4417eaa5cfb7 100644
--- a/tools/testing/selftests/mm/mlock2.h
+++ b/tools/testing/selftests/mm/mlock2.h
@@ -6,13 +6,7 @@
 
 static int mlock2_(void *start, size_t len, int flags)
 {
-	int ret = syscall(__NR_mlock2, start, len, flags);
-
-	if (ret) {
-		errno = ret;
-		return -1;
-	}
-	return 0;
+	return syscall(__NR_mlock2, start, len, flags);
 }
 
 static FILE *seek_to_smaps_entry(unsigned long addr)

---
base-commit: 518e5b794c06c0f0eb40df3e202274a66202c137
change-id: 20260923-selftests-mm-mlock2-fix-fee59d31b124

Best regards,
-- 
Park Tae-sun <ts930@dgu.ac.kr>


