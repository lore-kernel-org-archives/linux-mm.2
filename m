Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E58C9831E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 03:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C686B0088; Fri, 25 Sep 2026 23:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC6D6B008A; Fri, 25 Sep 2026 23:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DBAA6B008C; Fri, 25 Sep 2026 23:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0515F6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:49:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4E3614080C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:49:30 +0000 (UTC)
X-FDA: 85254533700.13.954899A
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf05.hostedemail.com (Postfix) with ESMTP id 385A7100003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:49:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JfPckEvX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790394569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mH8RpPDrFr6HJQvoLRU0PIhxtXNYo241XhZA1klSUjY=;
	b=sZJYFsDJMGin2D5nQbylV+Uc8xOR0osSwZTXkrSOndUTPdBLnRY/Sy0g/CkVUEy5gfXfvG
	9DKDOtqSO2fiziVl3TQDm6uBHpgF/CsetY+ciKEA8D0jgkpzcYMGwztoVPZIAT9K0QtMH8
	MT04jD/3X7iG+64DmRaX9nuwWmAcxqQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JfPckEvX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790394569;
	b=iJ9AW2dOpiEa3flfCVQD+K5sFFymZnIoOgmYCgSI+pIKIb3YoHGTKdprud04H8J/36bctN
	tBprmtAzfY54aGQOUHPeSyq3vljm4a0msVFPSMo5YaLb5bwZE6x/6yYy50xEiZFf3w2Ui0
	tXKpjrf/0vFppWhbx/TYXCqhvuCui9E=
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48884b0219bso296514f8f.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790394567; x=1790999367; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mH8RpPDrFr6HJQvoLRU0PIhxtXNYo241XhZA1klSUjY=;
        b=JfPckEvX+lAFNl9C72G7+Z4VKB6N6JgnBBEuyZxOLPQ1kX1BYh5I4WBxqNOFI9d1e9
         1oGZ28kUhuH5TvH/96jVXbGLj5ejKedr5pPxV+PyJRoQFVbV1YALX4gGQLMuQyJWutGR
         SZjm5JvqEhrd3FeyBqPOarO5kb5HfCRX9B8AkG6iUOvoB5U8j184UG1eWHxdRj5H7xPu
         fh1eVDUXYTPMa+gxveYnmlbC5K3ClriSPLHyLes2jHKthIO3l4V6Qv5NbLDoICBY9hhb
         tJMB+mwOQM2hbyg6ZFtosG9TBRrw4q1f7SveOM1A5s58FktdsRRlbxw+2LdTAYqBl4f2
         kuZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790394567; x=1790999367;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mH8RpPDrFr6HJQvoLRU0PIhxtXNYo241XhZA1klSUjY=;
        b=mvXRGMf7HK8/A9KXigzU7aiFze72l/FCVZGtRaxEMNOb+hYhoLgD62EtxF09nwK65r
         FheIvTqH+Ak7ub5u5aEW63iJvBpy0uY+/395xvJs4muIHsIQz6/PSthq52v4powo7q1B
         OPsulNfXJuigcBddix+HT8bykE+wCgxrKrcWC82B9Ycx/0GIrFz0j4wccH9ttoT9gCCa
         EEQ1Wo83h0e4Dni140kpGkpvVNnKL5HiSO2vb+PYqAUdDOHoY0f2cTw0g7eh3f/tgYZS
         wN8/0KGIXiZjjHut2wHDATKGxifTxBg2Ht/n/S53SLSseoLJ8aq3DtZPqW1EbRr7y/BQ
         dHDA==
X-Forwarded-Encrypted: i=1; AKwUvBwqkID8Wwc5ZBLVF/xe0E7EJ/orGiTAh869+mltPBxxZ3VAAZMkkl2d9iQf459+GA/4Z/7ajHtyNA==@kvack.org
X-Gm-Message-State: AFuF++mRjVjpH4/AWLNVr1doGWA0Loa5r53JJUPlalFPHgpjiIK3aiUF
	EN1od9Jy+Xw0zW8YJv3DPGWbS82STl+z4+FiNKtDQLKVdVWefmMlwFqU
X-Gm-Gg: AYBFou3bJ7gODTIjZew0ALkKp4K4+KMgUibQmls86ecdfq8p9WNN7Z4xxf/uBIxQQDh
	ipxn+Hq1hwGFrKkta1kexOt0OicVbaAb+sOr9hUw8tQzPCrcD+tl9j2N7hrxj08GiSqFRjn8co1
	myQRRKRTGLd8p9HTBU5RHhprALMYqU/xnwh4Oz50yprdjSdg5mQkoUbNyOsSnesOEon1t4jSFPy
	xVjtyxJbOpTBXFoTOU5fzoB1mglZvRTURafod/kuasfW80+MDgaZiC2sGR4IeQUXs9jtDBzlhTA
	2uL/eHkcfn2f0pKYK/GvSe+vfdElfT4k318HRNwdWqhGecIB1kmQKj5yXoO1n1E9bF/BnVnjy6g
	u3Q+e8RucpgEqjBX9sulQnqz1Qk3DhAuTqlC1Xy3s/2zJlTscrX1O7fZyIJFOQYvKZhbeiqQ+6/
	GLvo4HcT/j9To11DCnGaBIaJQAChp75Vh8RHPC9iy/ulVnlQ1abeAzOfBsOwwinFF6cZGCXgECK
	Zf+7RgAvWbQSQ6OjlUSAt/OZCS3C9FrkqFESUdtD2Ow
X-Received: by 2002:a05:600c:1907:b0:49e:63cd:31fb with SMTP id 5b1f17b1804b1-49ff06bcd54mr73179155e9.9.1790394567317;
        Fri, 25 Sep 2026 20:49:27 -0700 (PDT)
Received: from localhost.suse.org ([37.109.167.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ff43ad975sm116657205e9.13.2026.09.25.20.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 20:49:26 -0700 (PDT)
From: Sebastian Chlad <sebastianchlad@gmail.com>
X-Google-Original-From: Sebastian Chlad <sebastian.chlad@suse.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Sebastian Chlad <sebastian.chlad@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] selftests: cgroup: Report failed checks in test_memcontrol
Date: Sat, 26 Sep 2026 05:49:19 +0200
Message-ID: <20260926034923.31718-1-sebastian.chlad@suse.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9mcera57r5x1bw9axa1kityaziq54cqw
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 385A7100003
X-HE-Tag: 1790394569-966030
X-HE-Meta: U2FsdGVkX1/pWqD51I/laCrC6v9XFaolRTZhQj2AVJx5/kZRSHjWE0KthbiIF83eNVDV4v7PIJbhlX4/SO1gtM6TUFCps+bYkJKKs/2YOQLT93FsR6g0viiLfWpuS0u8/U7pGZt+aDeIFlSPScZ7KTvuoXLlVOULeXNeyZ0TJqzffTM37OqnKZhRE1XujAg2DrsgiMhdixW/C7MNNutCpZCkK0xQ8+ZNgyZ2vAHXav1X04hDV+s/qRtIfzixtl/WF4WIbj/wsBbF1mG1z5sLXXWnwT2ddBtDWL6rVebeSCs7lUCiua/TQQFMaF1BA11tZ+vNhfJZ7HhDQ+KQFmOQfAxElntOibEiCURtg8TVAWwNzCTn9/L0WNbVeRvRPYZtisuo+Zvcs+udUAdxPYb39ZAtxuiL6SzllRJpJ8ONB68jFhQyVk+ZButHeMGLj2x+6Cuqyunkp5m+CYyEJtuDcy6NrnHNqxfgwpZEPafj6MMjiuqmv4VKxkUgEilFsAf3u4LWEjzqQlpcFDUZHPOP+4kmSwtC0P+Yu1RUypDlG+NonQzZQ1r1/Om8BusdweBBH64w192soq9ZdTndig60KfEH3B5IyJSzUp7lbjADmTavnNBJTxrTMr03Pdk2pazzpi3LFz5KDhIvhTgPlwEZlonWt0umdgDmQYpWDwXHr9Wi55QgZMiQYC79dMScAVBmMlLjRC0ufC3IloRgbw4IR1bhBB+YmcNaZVRFjstysCU1O+94qDMiYgzmbTe0anTQ4iohGglqyt8UELTXbUX/4ovtf06MXSVSD4fwHf9iKNpOeg1gWrHMv/Gq9WtFEdCgyHwFv4Y761QNtRj/buyhPmSXCg3LKGyuPNUqS3oeZW1NS1eW6zJhzNO8Yx7j62fIuv7TJtHNUaPE3+K78tptR0fScBKabV3U752m+4nv0LeCf5nZ3M9gJ/PzwZeh+b5X66HQeAERsdVmZVM66sA
 KPlu9rRp
 jlZBeAF41OsO8zaFuIoP4L3Y8IqdqgM0dj4/eteMzXnLTxUH97HkfDXY1d6p1QBTmJoUTV1GIl+9Vq06OgDc90x6XUvTP7WYLFZwryqa2EE/CGBeG2DXmFXKNRSy/jZH83pX4pPGq+b7J1uj8ccVp6iXmdno52BU5IpBtz0xmNm2TzkEH+f71ZSP6Z4Htgi2q+RxBig+1YbtFgELCmfI5Avfjl7LmSfRU1dinKc7Zt5F7Scu2R9Ss8VWfoJlwGzVVNHNHmW4dZpjYK7BKg/3ub5euItrG0Ji7rIRSrCqcANYqf4RDtl/NiV+jPCoVhLMIqNWdA9KLUIpxQtJ6MvbpVaSj+xeRNSoH7rfylXvQ1aZ/1vHu9dNWgyx9XvSe2+FeSmDZa1d4JYfnxYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_memcontrol fails intermittently, but most of its checks fail
silently, so a "not ok" line gives no indication of how far off the
measured value was. This series makes those failures print the observed
and expected values. It does not change any threshold or pass/fail
behaviour.

Patch 1 converts the terminal tolerance checks to values_close_report(),
as was done for test_cpu in commit 4cdde87d723a ("selftests: cgroup: Use
values_close_report in test_cpu"). values_close() is kept where it is a
loop or retry condition, where a mismatch is expected.

Patch 2 reports the "memory.current < 50M" check in
alloc_pagecache_50M_check(). Because test_memcg_high() calls the same
helper expecting it to fail, it gets a quiet variant. An alternative
would be to pass the flag through the currently unused void *arg of
the cg_run() callback; I am happy to switch to that if preferred.

With patch 1 applied, we observe at times failures like these:

  not ok 3 test_memcg_min
  [FAIL] actual=18722816 expected=30408704 | diff=11685888 | limit=7369725 | tolerance=15% | actual_error=23.78%

  not ok 4 test_memcg_low
  [FAIL] actual=20852736 expected=30408704 | diff=9555968 | limit=7689210 | tolerance=15% | actual_error=18.64%

  not ok 4 test_memcg_low
  [FAIL] actual=14364672 expected=22020096 | diff=7655424 | limit=7276940 | tolerance=20% | actual_error=21.04%

These are the child memory.current checks in test_memcg_protection()
(expected ~29M and ~21M). Their tolerances were already raised in commit
d2def68ae06a ("selftests: memcg: increase error tolerance of child
memory.current check in test_memcg_protection()"), and the values above
still fall outside them. In the first case the child is about 38% below
the expected 29M. This series only makes such failures visible; whether
the expectations or the tolerances should change is left for a separate
discussion.

Sebastian Chlad (2):
  selftests: cgroup: Use values_close_report in test_memcontrol
  selftests: cgroup: Report memory.current shortfall in
    alloc_pagecache_50M_check

 .../selftests/cgroup/test_memcontrol.c        | 50 +++++++++++++------
 1 file changed, 36 insertions(+), 14 deletions(-)

-- 
2.51.0


