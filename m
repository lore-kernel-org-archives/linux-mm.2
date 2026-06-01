Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD13CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955696B0203; Sun, 31 May 2026 23:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9063C6B0205; Sun, 31 May 2026 23:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C056B0206; Sun, 31 May 2026 23:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 707836B0203
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:24:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A9DD1A04D9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:24:17 +0000 (UTC)
X-FDA: 84829900554.20.2E546BB
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C36280004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:24:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OcBABwj2;
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780284255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=owbSZscWo6ckrHxeD2gTgVyp3+xCiVnDi/pqi0ynZbk=;
	b=4aHIFDj6KJxbhrWyad3Vw/cNhbksaW+4YHt//W1fgPuLPmrxruOcDnDudMekk7dJ4dPmxV
	+caK/QAZstFdWosBZyenRyEGlHHjAG9hIZMIOXM2xk+FDZvtVd+GntAUSHWqyqjgJtoj1y
	/cR9WydL0I23dfpn894DSV1/nfRFq4Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OcBABwj2;
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780284255; a=rsa-sha256;
	cv=none;
	b=vvqeWV91afudGR3McqiTzxrDY7zoc4C3R2HLmksHGA60w7rB+L/LMvCxZh9l8aakSr5f82
	Rof3BPj4tNuupHaMK69U/gJdOYblXVWk8i/RF0XvMYdQhbpu1qCR2uAZgLJ2qKoZHR4j5H
	sFMbfIxegC+EHOBkoHeCUgFgBsR+7AY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780284253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=owbSZscWo6ckrHxeD2gTgVyp3+xCiVnDi/pqi0ynZbk=;
	b=OcBABwj2vtNXSS2l/hQDzcSyapMyDYAs6pzuODWBCnjvpw93Q74oDel6q/XpuiZUHcJtl+
	48YpqJ3YbYDbOsIdOvl31IpuX90KM0JHdmK84PfYb8PCl2fdvvmyyMYc8QQnj1wPAjllJX
	vlntAjhWCkcZpmA2GMDLVnc4/5s8DLU=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH v2 0/3] selftests/damon: misc fixes for test bugs
Date: Mon,  1 Jun 2026 11:23:11 +0800
Message-ID: <20260601032314.424013-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C36280004
X-Stat-Signature: y4uwtq1oek9neks7rpee5e5zhqiy9xgu
X-HE-Tag: 1780284255-530107
X-HE-Meta: U2FsdGVkX1/BGoH2aOLQePEW+632P/oqux3yQijYqMa0pWdeLs8VddNHPxBWHach8NX20e/2wywWGxlqD3Hgw3K9NhwHtW2IUzA0OJqvyXJKd20MnqaI0PXS8KdbagyOtBFtFjRe5XuqO7cqjsr43nSNDmHqeiAlEbqFm+N/85vzhL5IhgcWTqQ8RXrRoCgT8MCM8jcezXF08FuJTh2zfKsU0sV/YSfsGXMhUJzv9ICib+DDuXGqexLEG1yJxURc8sLrZd4G0vVqTP1Ciwu7aXjlp+4yvLS6MpCCrMFZlcswfDayRvfKSiauw0JjlHgnacO1f+nyoqmnaxCI0vCsh0RJpbXGTrl8T79F3yHtT00gQI4jXcgkL8u7VkxJsmLYc9I8h9rPMEQDQ7ic63L5RLE7bEuq6qt/VU5BSazA8F1rzM2U1bY91znLxXyqYQmCWwlHFoJUd9KS9fMVP2sde3eiz3h7FPyNuZlCRZ+yuY4Wx8rWoL1YSb+jLhy9zKUQuHpCx4oPgkazFOGa54sCjtwUh+qcycBtggdAeJe7cWLyGabvLHYXdvfIthExihH+7c4RT11PUuCjiixuftC6ghaQ6dJAGqenRc2VU6OiYx9X1m8+bmgD2Zm83x+sVbQNYjDWerFyp1mev9xQjxtzIzJpD2ckH/kBCuwm0ZMw9AAnH+x5S9Rh8QgBgq9MhDO2y2nrgc5uyYQAojh2yhflkPY2muoCYfasia3Y9PwO0wfsJ7xzyfTXMRag+2R6dhcjAMwrycqwM2aXh0i4dV7lk/mkRapL+n0rQ8vhg4rbQkZgw6QF+Up3Mzryq8fZczM2zPPCmxUxS7iGW+o4VsL0JMApuUkuS1Wk4zeTecpAXZ4SjfQC7IoU3rhPmnPTprMnkbEzXktx82vCN5xG0L5VmLlG60hnNgvyEAQBHV+9a3JbWI84g0uMeoS5nKAqlQXoaRW6PbVBxdIsb+UxfCc
 t++XKT1N
 U7eq86PZxSpI7NKUMLF0FdzClck6Y0ZUZLNvo9B2NuWQ5Nle111Yi9hLQEcNgKKpxGM+UlstQ5B/Wo0Pk9eoQYNrSV9XijcMCv77VmWr3dvybkVEwDxhbFkmmvXfCjgvfSCpAK5x7bFwk+3ygdtv6e2C1s3Zh0AWTo9H47/EclnUJWCOuHfGHIgzeBQH8sC2ziuKJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <chentao@kylinos.cn>

This series fixes several bugs in the DAMON selftests.  Most are
trivial but cause tests to silently pass when they shouldn't, or
fail prematurely on slow machines.

Patch 1 fixes mutable default arguments in DamonCtx.__init__()
that cause state to leak between test instances.

Patch 2 fixes wrong operator precedence and join TypeError in
damos_tried_regions.py.

Patch 3 fixes several wrong strings that produce dead elif
branches, skipped file existence checks, and broken dict key
lookups.

Based on next-20260529.
base-commit: 7da7f07112610a520567421dd2ffcb51beaefbcc
---
Changes in v2:
- Fix From:/Signed-off-by mismatch.
- Add Reviewed-by tags from SeongJae Park.
- Drop the duplicate memcg_path fix.
- Drop the empty aggregation-cycle retry fix pending root-cause
  investigation.
- No code change


Kunwu Chan (3):
  selftests/damon: prevent cross-context state pollution in DamonCtx
  selftests/damon/damos_tried_regions: fix expectation output and join
    TypeError
  selftests/damon: fix dead code, skipped checks, and broken lookups

 tools/testing/selftests/damon/_damon_sysfs.py        | 12 +++++++++---
 .../testing/selftests/damon/damos_apply_interval.py  |  2 +-
 tools/testing/selftests/damon/damos_quota_goal.py    |  2 +-
 tools/testing/selftests/damon/damos_tried_regions.py |  4 ++--
 .../selftests/damon/drgn_dump_damon_status.py        |  2 +-
 tools/testing/selftests/damon/sysfs.py               |  4 ++--
 tools/testing/selftests/damon/sysfs.sh               |  6 +++---
 ...fs_update_schemes_tried_regions_wss_estimation.py |  2 +-
 8 files changed, 20 insertions(+), 14 deletions(-)

-- 
2.43.0


