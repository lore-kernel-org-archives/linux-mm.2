Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0725CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A156B008A; Fri, 29 May 2026 05:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5416F6B008C; Fri, 29 May 2026 05:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458136B0092; Fri, 29 May 2026 05:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3261E6B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:09:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69941120EF3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:09:20 +0000 (UTC)
X-FDA: 84819883680.12.D5BD0CB
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 490831C0004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:09:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=XpOnvwbD;
	spf=pass (imf21.hostedemail.com: domain of niecheng1@uniontech.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780045758; a=rsa-sha256;
	cv=none;
	b=AVbmJZtwlMH3ZdHBxJy9CFncsOQnkX6mq+PxjQ/dcS50GvjDN4mlf20BLBInT4bs6qPgTW
	e7uS8S3XzLUAgWvxA8WDyPh0z0sh+TtDWYh/xdxlcatQeTq9FUqaRTh4+5zH/4rvqj1LI7
	VQleRd5nZ5fALA4LSrI/t4gSZIlbauM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=XpOnvwbD;
	spf=pass (imf21.hostedemail.com: domain of niecheng1@uniontech.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780045758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HI92CQVY4BHFkBuTuF85nDRVdo5KUcgUaAWuBzvANXU=;
	b=HB6Mszyu/e2AP4cwULWMFejx57RNmZRkmFCvJ5uomUyjf98/1KH6PsmFdNfhHotXx6q7iU
	7AasyjXeaE/E/3TNfSPgLcn6Fd45S2LGo2LtfT98MB1WLovUzc7n4K2xFZ9LeNMwTrdVFz
	AV32uxR2dcBTiS1Wo61zq2ES2J+tfjY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780045746;
	bh=HI92CQVY4BHFkBuTuF85nDRVdo5KUcgUaAWuBzvANXU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=XpOnvwbDqjaK8u8fRk0/pnoS7fdyZRDiQ/LeAt9Ym9SvLK9rweZI5q3Bn+Wbvmp2r
	 /pTbm9BbYOJD1AKfo7Qod4qMZmvTdaJuEpMWIk1SEgPW/mRYm981OvEhgOZg9MeArY
	 497r+qOT7bNLPCIAO6Q48DyRQY7FPnr1HAh4yo2k=
X-QQ-mid: esmtpsz19t1780045733t2faf9186
X-QQ-Originating-IP: ryROh8tfY0IVyLUNcxiOovSTwDyb3oq11cz15UPrYp0=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 29 May 2026 17:08:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5547347000364667958
EX-QQ-RecipientCnt: 8
From: Cheng Nie <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com,
	niecheng1@uniontech.com
Subject: [PATCH v2 0/2] selftests/damon: fix memcg_path staging handling
Date: Fri, 29 May 2026 17:08:45 +0800
Message-ID: <4CDA28DC581FDCF8+20260529090845.1696845-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: ObeNUFZ23MvRdKa/dyCJAsGBoSSBO3/M7GLGHChdQSBJHmHOQrkHkYgf
	HlxZVwCjyK8ZgpfwaN8wZ8o1J+lgtFBKydvQNFWNHmkO6jEw8vQEeRGxEz5anMa0VrWjqHH
	VtEdqUAOcw4wP1gBtf6K/dKC864h/wms7UsjuoF64TloAVseufpzhxwpAuHZIecf5GW25PM
	5ePxhpM3ehxlfYr2PwNEyE/gtW4G8xuwX8WoGJFC/f7YJePKGZtFEZKO+RKzlyxfZmv1nL8
	7re0v3bhYRvpqufr4+fwZM76fE5ZREpzfBZtYzp7dnak9PB55haxJ9fdsl1QuD+h7VUX4/g
	b5Y6UNiDgKAq6VUeopTv8Fl3KUbe3UR2zOVlOU/WAoTjb2QKEJeBTq9vdvnpnu18ILJVqNa
	6uLmzEaNlpvQV7fE1saWMT9v5pVNg9conPVVD4mvEAzxxdPzckJwhliHf4N6j7YldMHKxRF
	IEddY9ki9gwEsm0JIe4jwgVyanBJi6uhHPNmiQlfiyJud9YbU90xW/kklY/Mo1S0pk1M5O2
	Dc2rPnzInH0ojt1WkLzAu2bQbu0BW+H/M0Q3ngRCO4NM6tBe5qT5FFVdg0LAjQAhYfWIk5b
	SkuIjBoBZ6/4X/jmVn6d6+nKYI8tE6/lm+SXcFYaC6SMrd8j4RUIIWl/1pGgSZKM7CQ4UWM
	e3/VjVvLWVGUwfgIcRFSifR1kU2A65obwKNANlWSASGW9TunIbgeZidNPIu4vKGiyTwX0FO
	9x5KdJBeVomDL96O37R3/JuDZE8PvupFkiNUxUaWqQBDaAqI0eYX/ZkcvtnhUaUQU1nbHhB
	WTDn8ao+uJ3p0YTBkbhE1kJ/wTK4X/r1MjrnZToVZheqs4LcFSh9OYGIFQHQCmB+A3soBee
	vrfmssgWF85GK1lfZtlDlIIfEG2fuLGVQ2zsNt9ornqMz3KK8XcO6R24F/aGhN7Pie4iiyc
	4hK49+56fru1aekUb527oEMB8OdOdhzkyaoN/P21tGdVkZrMvq/ChieT7qwJrrKxgDW+sSJ
	U6ezKgo/KnTj60J6eO6pnvCL3sIuijsBbbilJX7EqyI9JAvTvAQpJ754waZpGcXR7AQESGW
	w==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Queue-Id: 490831C0004
X-Rspamd-Server: rspam03
X-Stat-Signature: 8n4h8zxxzpf379fnduc9tfmwmozopdje
X-HE-Tag: 1780045756-183815
X-HE-Meta: U2FsdGVkX1/DNvcOy3x9+M+wX6TH9JlpIpD1w0DkiHuhmXIuZQuPlOmaouj4gjyKQ6TbR+bHElkUb+otiiWhQmlcvjyd9U1SL6oPdvKKvt+F+Jllx3jrv+mhOIiq6AOBnILsMVcJt3BnmmTL/9NN9oAMHal2uAHelGefucnCJmhAdMgJHq4NfCb2yQSShaiL2buHREIpHNr0fecuQ0VzbRAIqRdReRCOmq1eB91/arMp6+vO174CCzJsEUn7sQgak9B+EFrxRpKRnUv27LbO7vV35kzBcKo3sYg7cgeKesA94E/DH6XUFz8Qcbw5oi6oypBvyeuZg9bb+GQx+g8rZwIAn4YTY6cwZM0C85cUY1dWWw0LwkZonD0EJ1vDp5C3pC5R9gim42jFMTZTPij6uV10bYWAYNUcB4WRdraA7wzta3Ii4dDyULnxz7wZIhCs2svgfALVRWOlJpPP+NBA0QHe/TvXSOf74YNAjmX19xa5O1smD/2bv3AGjT5pMAQf/6k6dasbMN7T0l6T4+cYk/rDc7shJVumHVJRhMYzer1r2vVgluWFR1+GUYXU8Y/WQaaI1+ZJydsqB5/6eL4vJn8ZZ7N643scG7WNTDWoxOACjbT3EPiE74HjRdLxlsQKQwouN5OAWmWQWCnPkNZYgrchnndz8ULnx7228Q0T8sQh/pQKZeV0pi42+9sdzdXhTrSLphZB8yzGo9KTcmTlqu6dWFo72nuWgKrAdvaPDgLZ+gYQZr5Z3bscBQ9tnxB7xKcI5+Rtr8/L/AAFB8kP+XdjEE+xPr0JKRbI+GY1y061d7w3oKM2DjDJgYsdSDAN5NJLOoQdgLyCc1EmJB2Ch7hU4lUZNL1za0ghmHYR9pCnZ7U55oRKEg9JLfr+PsNHECVgHG3i9RdfC6YqkxUTrv5g6f5ZVkGQQ4pLCbRXtJGuuzKNGUUsPp20MwlMZjcsdhZIVvKLS85O2PJEUQt
 Fz+GBaud
 rEOEJmEIv5ky6h1QfruMQB31GaNMjOh1T3i31yaAT/9F6xN5kRdeNBgxUmq9ziMIAWul8PiJ5TQTKjQ/0y9tFff9aCUXp6i9RKr4qx9FTNxn+P3ibIowAuX4SmNSBkenfSwKylnIpJ7Ld3QQDyqMGuOqIasjDqlLeHQJ3fUfTX2pvzMC3Q13mLxWaISQiggbo66cSDx+huyd3Oy8q9KzWeoxYX/kp3BjYkQo8XMdkfoS01jp6gH07NyORZl36EyAZMrJ4ciT60YbXY7JI0/F2mVDjq1KNKLRfJL6Deoa0W3mnJ2FKvM2ukO8WQBB2Kh7cYEWm8luNtR2A6iQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes memcg_path handling in DamosFilter and adds memcg
filter staging validation to the DAMON sysfs selftest.

Changes in v2:
- Use file-scoped commit subjects as suggested
- Move memcg_path readback check out of assert_filter_committed()
  into a dedicated test case at the end of main()

Cheng Nie (2):
  selftests/damon/_damon_sysfs.py: fix memcg_path assignment
  selftests/damon/sysfs.py: validate memcg_path staging readback

 tools/testing/selftests/damon/_damon_sysfs.py |  2 +-
 tools/testing/selftests/damon/sysfs.py        | 39 +++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

-- 
2.51.0

