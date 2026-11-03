Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C65D606D814
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KINhXhpQ
Received: by kanga.kvack.org (Postfix)
	id 3DEA56B05CE; Tue,  3 Nov 2026 03:01:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6DC6B05CF; Tue,  3 Nov 2026 03:01:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5A26B05D0; Tue,  3 Nov 2026 03:01:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1112A6B05CE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:01:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FBF416026B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:25 +0000 (UTC)
X-FDA: 85393062930.20.387D662
Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	by imf19.hostedemail.com (Postfix) with ESMTP id 77E251A0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KINhXhpQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Dq6oOFOAZU2isTmULY88ZuxmHS/TA88BLaSmBq2/KSc=;
	b=DIR+CKTrIOugIRHF0nJK8NqMV/SjjVp/6ZRwyRPzKtZkUZ2ZLxEuMXIE4337vYuvoj4DIh
	j1M8CuA7S+jpudjXNcFaq7KgSar7dWMXkG1dekvkeUYlzVSJ4LktwuEstcw+EhTvIJNl7s
	lPT1eqN321JUopeMKLn7o7+Rx5y94QI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KINhXhpQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692884;
	b=KG2Ni26rotynTD6uJSPavyW1Auy9OEnWD6Z+BxuHb/ARPRVdL1AoyIhFqwvcqvm9fSnrNx
	j7fhzbagaLWWVQfkiwPUy61EkkPYY67U5ru52o0ZOGAKT9adLy4phPvkYCNOqLNDfGyhLZ
	Rkz9lcpqPKCu9d4ZcrQMpbIc/QViFzA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kdenmgDIdcPw1gofp+pTbFrp5V8zDpPUvs8MrZtt0Lk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793692881; v=1; x=1794297681;
 b=KINhXhpQo6Z5xPdSXPPsx0nf/J0lHWKXck8ODR7OaMUSROoCZxv7QES/dD+P99XXs8F1xWpd
 qBDt/RNG9nbpEd9Mm+WW0Ow9iSpjRcIvUkI1NwfEC0vFbRkInd48LUAYvHI5JWCbRr77sJB+cZ4
 huwf/cFgJYDAPJDvfBzTbG7Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 656623d56c083c98;
	Tue, 03 Nov 2026 08:01:21 +0000
X-Mizu-Trace-ID: 656623d56c083c98
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 0/4] mm: hugetlb: fix some CMA-related issues
Date: Tue,  3 Nov 2026 16:01:03 +0800
Message-ID: <cover.1793692578.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77E251A0002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: jabyb7p13xadznk6z4zknxsw6ryk5pgm
X-HE-Tag: 1793692883-913483
X-HE-Meta: U2FsdGVkX1+ZLj6h9T7AEU0wb2rTfWrb6w5glKLirlKCU1mldXXTsEIc7EDiGgETSnqX3mHHMQ4EH7OhiGROEa0IklK7CvpNOtiRf02VWKpdj5lLhIuDu1qPnKP51aSv+S5B5rR5OmQw5E/2fxz7DlPqM7yIXkjv+bGVwevbfzT7Ix75p+T6dRW21IMZHAbwAIcYM4CY4voC4xRhfaFUs+KbR4Kb9P8es/I5uOf5lTjQxK8nI6veMM1Jqy41+vvP/U/L7V69THYg8bVbIeCL/BM8G0XVNvlOOALPxluu00LYepd7rR/kGz9faDiqEM/JOjYxkDoHJig8Judq1y7oiA3wNPQ6cBShlIIF/pvvG9EmFSM/YAZxHNvITIXMNwDxeC6XCER6zyJN5f87TPCNXVEAQzhOnDDVPHiQPlbp1Jn9HVYgh1Nvo7GaXcyYdrFXwNIN0MnxZYU5mZwSQqf6NxqVAfS69DQ9kD4pYtYeN17DR+JOOxbXYVRNEjATC65SedE408D1LEMPZvQa8hpRbJTj+Lnt8damueO0hKa4N/j4LQWEmvKvTSiT1xmEYKt9OocLJi2i2aAlQ8BamwSlUo37yBzISJAXrjtNhzBXNYjK2fPV2I5cOhU1AyhttRl78z2biGgrTSDFFfAopMgUnx17aKPV2FEF5mSPQhl/Q2LRdrHOSfx+pFMHTtLj7KST5em9pbvn2MrlgSaBDlElY5LEIXTTcnWLzksM5kBVBJyjR4YXhYrD3X63skO5ggpVtNAqCVNks6/pwx5yyM/WdwIedxJUweONgudIZqpi5UzEHV4g15j1qPOtRREWaaqf4tiMWucU2m4CLAfT970HrQuLuXrwNRDJOL9+KmGQjDBmEWMY2W5cDnpU2BXJJIen7f8B+0fpu4THqVOuCWynm1ciIsMefzGD9dLDC77U26Ojq5dIC34HolYnQc95wNbs7/JJHqvlW78tpW2jDpP
 dBfneny8
 xvOXbOdS3gYSVJIVMYljK/4TIjWdm0ekfettVi3943ughuYHXa8QQuxvtBEnY+axIw3aQ/GZsMlYGD1XmFfv7ygebOoddd2Wg0D493l1I1f3ZD6Cwo0EX+1bgxoGCnDyeWwDaSowxggb0Rsd7UD/mRVJTfGMXqz9i8INI8IYGbyT8PPvHcO8WMPHSfhNyWZ2G2Iwjd6lQyiZcI04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

This series fixes four CMA-related issues in HugeTLB reservation and
allocation:

 - Avoid ineffective CMA reservations on 32-bit x86 kernels running on
   CPUs that advertise 1 GiB page support.
 - Honor PF_MEMALLOC_PIN to avoid allocating CMA-backed folios during
   long-term pinning.
 - Skip CMA allocation when the caller disallows direct reclaim.
 - Enforce cpuset restrictions on surplus allocations, preserving memory
   policy semantics and handling concurrent cpuset changes without
   discarding folios that remain eligible.

Thanks,
Qi

Qi Zheng (4):
  x86: hugetlb: disable default CMA reservations on 32-bit kernel
  mm: hugetlb: skip CMA allocations under PF_MEMALLOC_PIN
  mm: hugetlb: skip CMA when direct reclaim is disallowed
  mm: hugetlb: respect cpuset restrictions for surplus allocations

 arch/x86/mm/hugetlbpage.c |  2 +-
 mm/hugetlb.c              | 38 +++++++++++++++++++++++++++++++-------
 mm/hugetlb_cma.c          |  5 ++++-
 3 files changed, 36 insertions(+), 9 deletions(-)


base-commit: 2637bdec0535a2044cd830eba9a79363651d9043
-- 
2.54.0


