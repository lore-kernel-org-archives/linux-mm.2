Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CCD6EC110E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885706B0005; Mon, 23 Feb 2026 12:15:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D646B0089; Mon, 23 Feb 2026 12:15:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1706B008A; Mon, 23 Feb 2026 12:15:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68DC96B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:15:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 252F21C187
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:15:52 +0000 (UTC)
X-FDA: 84476373744.06.7255D96
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4861F180008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:15:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=G4AnjSCv;
	spf=pass (imf16.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771866950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEmmWiaUSN6agFOfmjMt3TuPh72lriTqjOKcZSmRRGA=;
	b=6nNw1aqe48b7Mvc9cCGSVT5eUmDupL5NedmA2ki0iVolMg9ca0X8RU/Sct8A/y5nImIrhL
	xI4QxxM0MgFBYDxMYvMzEpxHgc0tNe8zqnC20m6puuYNhycPNNmbBbLpBreUridvt8Fl+3
	wyHcjbHaX+fjhr5dGYznSjbxMMaO+NU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=G4AnjSCv;
	spf=pass (imf16.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771866950; a=rsa-sha256;
	cv=none;
	b=c20chWoyFm3OnFitKV1cDIJH6V/SeK/omF/EHti8vZ3XaVfPRJU1XOHoswHHXiBWBEI25E
	hhu2tELVDfA8ukuw6glm8MfcJAWgstT672N0AjQDGuVU0wB7XLxKm0Ea5mbCe/p7qmm3q5
	TYjulRrIIGnwXGMnA9B20L69AIb7G5I=
Received: from LAPTOP-U3CCR7C6.lan (unknown [20.236.11.185])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5B10220B6F00;
	Mon, 23 Feb 2026 09:15:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5B10220B6F00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1771866948;
	bh=TEmmWiaUSN6agFOfmjMt3TuPh72lriTqjOKcZSmRRGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4AnjSCvhK+QilqO6lHm9BE5gW327yQdZFGR5MnNZjx88Ctx3k9JhpRvpgWk+kSSN
	 8+WgBm1+sioqh+0+poPZunyr0xgOIDDuvPGs4/rbYleoqdBzXwa9QfcfG1X3bV6nSy
	 zxSGxUJJHdGB5V03MsBlEzqVMtdrfD8WXgb0wl0I=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhiramat@kernel.org,
	mhocko@kernel.org,
	rostedt@goodmis.org,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: [PATCH v7 0/3] mm: vmscan: add PID and cgroup ID to vmscan tracepoints
Date: Mon, 23 Feb 2026 09:15:41 -0800
Message-Id: <20260223171544.4750-1-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260213181537.54350-1-tballasi@linux.microsoft.com>
References: <20260213181537.54350-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gk7xbfyr118ywbphf9zudydfd5azo4ns
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 4861F180008
X-HE-Tag: 1771866950-666079
X-HE-Meta: U2FsdGVkX18dXWsvce1XVVS/WuI6QIlG+D7zh39dNoQb+DqBMGK8BEQQPRLGHJDRB2KcgxnhSfmz0B77tbs/HtJdabmFZWvdqWwrv1femjR7MfGwRwEpG+WN9P6A/kdunCmgyzbIWDlhvjHeo5qx2qOy/p+oPHewKVPm5NRa+W39lHbR2yIwLp/FustwhZ+Xslv9yUGUM+AcMOWNZt2lOmAyaHLA0bHXWalpZfZdvY9XrmCI9em89D6jZdu5BPydN5DXxF5eyYcZ1U/HE2IeqM4i63WGAQuQbk7uudncsxQP/hvQhSGAw17cjKR6dY66rlKQLazYf8vEGBsuGBWqaKTypwOqM4Kt5TV5oMt7kH/cNBTxt0qO+9VEgMNHRGCIpuz5hbnjlTjk8u0gbqot8uOHz9AroGwszdVmAbc3miUyiLBiN82t78/50JrQBtEcA6VdNXmcpr6rOyXBogrAvYW92x7XCNvX19vldvjlRSyjmILS3fXodnP9rSkUYAjSFuABDElYlVI139GpOoBPrlffD5ngn/QtIVkIMkxnFTS3oHe1cDvSoCD93pwKMYHCaX82D0kHpFrmj+2RiBxSS0UJb9jDepejZCdYoQ97aptpS5J8va0BpG1F/WOcGoi/EqMR9uWzjJft8SUgMYN+FwXTXrYyRE18r9lHWWjgxjXu6QLDU7UZAjpSzB/t0Z/HZrEWA++nhkDE74Ol154RKT5roOfmyfl0MabfkVC7sFevHELCEB7napytK0YvVuTb8bfLePMmWmawGRspKXMZQPdnXGwt4xUY6GKOg1fcnNta/jKVZ/9zIgsPsk8RQNM/OyolnC5qyk+w1226uT0juoeRuLZEkLJpfYfwCQzuTVmFBeCH4K7eL3fBDluCOLDC0zb03qJRc0k2BD2Y0JrgtCkWID/3TPDmsl39CH1jmiIiuRE8joZxPJjqBUGeKMlc9djbsynG20ks/Z74yeG
 phi39d2c
 t8oFYDyBTk6mIE7bvqS7TAwhKiDNQ4/RBk0J2mfD4DnWj0K5Qm8Civ3RQJlZ0I/JGGhkMZnN/Px3XYr+rTiUOrTQznTrmZilzVxF0H7CuRheo9Shj17NHzvTONI2E6H0ZJm1cOl0sMH9bsAaQ3DQSVEzH8aPbYM/IFisVTu20PYGt65D80tUux6uKfopOnHIWppYtrjlS1VlN02d0NFCiPzvdbKG22NWCgkJOAkZjN/DDIb+QR/grmJQGfv8pacxNzVT0Y40EQ8ydQWFREpJ+LgdRt+lYL1o4vS7usif3XqmvOxiTLn/LZYXD3Ya8MfF/ZB5o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v6:
- Edited __entry_in_irq() to __event_in_irq() in corresponding commit
  message
- Restore an entry that was removed inadvertently

Link to v6:
https://lore.kernel.org/linux-trace-kernel/20260213181537.54350-1-tballasi@linux.microsoft.com/

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Steven Rostedt (1):
  tracing: Add __event_in_*irq() helpers

Thomas Ballasi (2):
  mm: vmscan: add cgroup IDs to vmscan tracepoints
  mm: vmscan: add PIDs to vmscan tracepoints

 include/trace/events/vmscan.h              | 103 +++++++++++++--------
 include/trace/stages/stage3_trace_output.h |   8 ++
 include/trace/stages/stage7_class_define.h |  19 ++++
 mm/shrinker.c                              |   6 +-
 mm/vmscan.c                                |  17 ++--
 5 files changed, 106 insertions(+), 47 deletions(-)

-- 
2.33.8


