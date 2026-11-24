Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DE8606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GFdkSvh0
Received: by kanga.kvack.org (Postfix)
	id 2BF406B05D5; Mon, 23 Nov 2026 22:35:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268F86B05D7; Mon, 23 Nov 2026 22:35:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157666B05D8; Mon, 23 Nov 2026 22:35:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D98D06B05D5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:35:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6546AA87EA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:35:57 +0000 (UTC)
X-FDA: 85468598754.10.3BF6F5B
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8B0FC40006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:35:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GFdkSvh0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795491355;
	b=lf3VhHK+31CCl7CZ2M4RKgIGjZkscA3X6FnHWBDa4umylb4X/o3QnOvnyC33yURVVp/jkv
	lKB9F4hMuozZjNwOcE47BqOHAv3TxXOwAkrRWI/1Hiv9bvWOvOkx+DjHkWvnTNitkPGofx
	teeNRmH1uxb/fBnMfTxUD9PIOsBs68Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795491355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gz8mETMe7bzy47y43VlHpH3dB3FxR9QPUjmLcoANy4w=;
	b=FvNnqHfVkNsujmG3QpXIk1vFzjDNlv2Ird4NU2x3zgdZKakg0DLYBkr5sD5+a+ZnpKK75a
	0qKYT5YNyakkelrrrRfrtk+1hyWUDMfNn7WZJFw0Z3TnSgSUVHvMbNdcGbFVifwIuZWIi/
	yDsF4qKzNmTMUn3p+vnOjeFecC+FeMA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GFdkSvh0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2f04e3bf46dso28123215ad.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795491354; x=1796096154; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gz8mETMe7bzy47y43VlHpH3dB3FxR9QPUjmLcoANy4w=;
        b=GFdkSvh0lvOGIWAyNM5Xchs3uveZDv6rI6VYRwSvpV/Ya9ktmbMoGMPCeFqm9PhT+w
         keRFgU6E/rpjxOObK3QrI4lnHWAR0BwzgIT+dHcZH04hHFSTO01dm3EixddaCNEbWmAQ
         HkVYDEYJ1T3iC2ya5dzWg/tZTW8D3aCv7qpjoW8lBwDW4bkRFWPkq1OxoDnjvuVrKYmg
         3sF1VgkVWpy9oUuC154lugOGbap+yuJ0FiBATShX7sP7UFF6KiT+okSlm5/5+i80bt9r
         5wpAjUz+7OV+z+aW7AD6mzvM86uaO/vjrCyS2kk7X/r55nXNm8BelQG5x7OBtP9xz/qT
         7q9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795491354; x=1796096154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gz8mETMe7bzy47y43VlHpH3dB3FxR9QPUjmLcoANy4w=;
        b=GjyJTrPTxajvkVpJE1PQwoB1o2zRGmVRTT47MIvR05rqQOJTjVZpMDojeP0bvcJBMx
         qvxYHHihknoWDUd2FhieDDeEcCpDl9OjGcQtkU8PoO1YcNV6kdUXRHd9b84Q8R58nqOj
         GH8idzD1txXxIafQkpAQl088u5EDRMBI1ZSqQmrxqkTXHSVuFgyqWn1y1Qt1iPY60twe
         TvHRf8pf8iYiowyJVr4cyazXn700r2VStdhO9hoYeiEQPmgusRTGfumv6ah+LE3FoX4a
         yZjq6YXtK5tuhNMsK2+TjyMbG2r48OLz5567Iqar3RFczq3gE4eI30GydMm631AjI3nH
         3YtQ==
X-Forwarded-Encrypted: i=1; AL+hErF1tmDt9Veh9CXQGtzxKvMvtIpBCygz5YSwtFpN2qaBXNBzodtBM4JoZKHpLPvDtHoqZMmvpjpIWQ==@kvack.org
X-Gm-Message-State: APuU4Z/vIFgW/CO0yhKNulYzkHIGk7PYr089fhip0+a3MjLm7dDgci/t
	scsrekLPmXqBh+DTGzAC0IW828l+MWjpsRbucKGz61UH5borASAihJLX
X-Gm-Gg: AZFdTZc1dHh499/n8YBBeuVVsrH9IZr3k6Ay7QRWViPg3baQD3pDOdMR4P7we9nfLkt
	aZZLfOdlByQ9UZCugKy3+990gkyiqTnviQKo0ZNscAd5bLg1w+N7WOtCTCkTvBUC7D5yEPWrsQ2
	JJkeHwPuEBXHn5JO0op3eB4h56JrqEWFpFM48UZ1cacLVymneT6sWGTKy0uxUEM+ctB7ybmk6HI
	hgL3l5oA2LNxyVyY1F6cO46Fuuznk0FF+mc1mjtNkIJLKVieX9RSwH/hDSP2EjA9oFN2lhjtcms
	Y6zwws9EBmPbzepJZwTSmwfOBv26ymPrZJoLER6fiBFkNjNErrVOc5lhZ1WIK2Z6QQGczYrydT/
	oMKZFTwSXEq6fGC4VAXUFs0GGQlDJLPB7+r7FGjlS/kN/IWyKIlcirXmtlrYCVAkTIRsMc186TE
	xieOCp7NwOaxwxFxyuU7bZnwTzlt/yLPbQsTOLFIk9ipw1EJhEZXdsWXaV4ZZBMo6K00+TCvnGK
	ce//PvIyzjOq5bno4cYQbOVQK8dQhFzdBhF6inaOsh0xDqDzd8JM4G0v1/FJSdOfFQ/3smsNwh9
	+BOKq9pc92mdrY6EM1ab5wbRwZTk5GE4o5wuM0gdOcLMag==
X-Received: by 2002:a17:90b:2c84:b0:3b4:1220:36fe with SMTP id 98e67ed59e1d1-3b41c7d0ddfmr11532752a91.9.1795491354119;
        Mon, 23 Nov 2026 19:35:54 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm23397939a91.16.2026.11.23.19.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 19:35:53 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: tj@kernel.org
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	kolyshkin@gmail.com,
	chris@chrisdown.name,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH 0/2] cgroup: list processes whose leader has exited where their threads are
Date: Tue, 24 Nov 2026 11:35:45 +0800
Message-ID: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 8B0FC40006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: s8a9z1r1w998oq5b4uy6gs8d4c9yya6z
X-HE-Tag: 1795491355-620975
X-HE-Meta: U2FsdGVkX1/xD/v0JVzh0H3SoULeZFZxfLmqmeflZrmkWJX/bBgu//gBPWUnF7PNMBMbeufbn+XHzlAoknZhOvQ4GtQtZ0SJX8dvyajSc7MQ52iTXuH9PLwUaPrdk6oheCvm1XLiHm9OP2szESgjUE/Mbv6PJoDyEYnR4L/dMcC3oX3uTHVevv/4pQ1aQ2+rAL52pjJl6AhtH+YeAGP2FGYDP3EGJogO2Xa6h4NksWBd1fdcAaTvszcMGWVAzcNxA9bFpCr0br5wfib/iP8uqWPj9hP5zFREb+lRxlIhohgMZB0teZ4r9YwevuF27B7wAHpx/vy/8jU38Hot9me90N5Osbcw6G/j8k4lKKLjgsTxB0hYH1L9/SGegDG18W79ptePtH3Pchn5gaeT47k5ABklouXvZM4/lXA07zF5AMf+tdf7bQpFe0A9uQKOX6Ct8uxdlLgPNi4uOqAoavAL5BKJw7iER11FBB9uBlKtcZPEQSAtPKdOcG3zyNnTx0aDqBG/S1ncTmO/ejRwGX5b6VCYplbtJ9mOtuSwS6X+qTcZJnm/uW9pWN/eGczhlxSSXnMh7ShEsq0jHJ/geGIs6fkZBj8HXqLEPEbIj3DeMCQwdvxQDhQ+2waa0blh7/prn6bvq1l8cPqfCiQamItP/Xqm91W4c54XElNdaBDjqNnRvzoX5wGmnaKeNi33QLFKr50ym1v/hEyyB0eDyojphAWgBbXmemJMU27LnVxM+Fm77YAurInhFn2BNKJLTSHPjrYQHMqNPpfAV6EC7lX70BSGke9+K7ZLm9cvjfrQgPj7U0OzEi+1ptyg3jM8j3WzfpU/42C3nMg7N0KkS2yls1TvfobtEluHrZIaLofpALNThw3/B9OuHhhABfh310qG1MoqLImD/dIWoF08g1lYg8KwFVWg3Yam3FHCtg+3BLSfh5tO8hOTYkSycocf7/XQVo1Fj2P4GHtOKwB50X3
 SHCL4piB
 aQzvu/oUrp8q4LsZfeKdOJXLLP7h6bkwhQJPJX3ro3HSZxAhw0FND4qQ2LyZT/LPmW7l+n4LsREwpda5NcUyjB0Gk+7+XUnAgg+lRmXFB1/Lsf6cu+PTE4ADcOCs/KKR0d09QCZkyt2JJ9cqDcVWPnkiAg+cSKUasoGRW20nCXiWXJOzpNpBowM4twK/PTZBvvWcl9ECWfp/ifGZuD3IXGzREaCdjuBQT5txCOHftq6MYmTyW59zqXjMtMdfyzKFissp2xtNRdqhKewyGLX9n5L6dSL0wN+ch3g7KvPq0fPXFKKWB9yGAh28tzIXqFq4VsAbV487S6mnzG+/CEU93fxfS38ebu32519aHaPvR5SzeSeyaA082R7lfC/xSiXSHWMhgwm5JiQIB7mMwhAWy6V+aYrl5zo3W0DCRFNSzhpcyjgsdNWLdRxR35kz6rJWtm/hsaQ1m1na8f07QgFikyGdgsdFEAC3nlkTWi1fNw9j8JmHBLi8ukwZW8IcN9/ILAfrnTSPsADgyBWTsQ9k0Atvc2rppiJj9seSevWSmdsHZ+GkkPdnb8JyHcTnDV1085Hch9dZrpolqV4qTnb23KNS3nbAxE0nPGzua6sdBOoHkjYlZ+Uuu3zmWRcbZaP5m8IYDDA53AD4bC/lHWwLSXmytKxXrLfCfH5q3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

This implements Tejun's suggestion in [1].  Patch 1 makes PROCS walks
visit an exited leader left behind by a cgroup.procs migration at the
first live thread of its process.  Patch 2 makes the memcg OOM group
lookup do the same.

Unlike [1], the leader does not record the destination css_set at
migration time.  The walk looks up the css_set of the first live thread
instead, because a recorded css_set goes stale when the threads move
without a cgroup.procs write.  With a version that recorded it, writing
"+pids" to the parent's cgroup.subtree_control moved the threads to a
new css_set, and dst's cgroup.procs was empty again.

/proc/$PID/cgroup still shows the leader's cgroup, so for such a
process it now differs from the cgroup whose cgroup.procs lists it.
/proc/$PID/task/$TID/cgroup of a live thread shows the new cgroup, as
before.

Tested in a 2-CPU QEMU guest with KASAN and lockdep on for-7.4-fixes
acec9637e03c.  The process has an exited leader and two live threads,
and one thread ID is written to dst/cgroup.procs:

                                   base        1/2         1/2+2/2
  dst/cgroup.procs                 empty       pid         pid
  OOM in dst                       no kill     killed      killed
  OOM in src                       moved       not killed  not killed
                                   process
                                   killed
  OOM in dst with oom.group and    other       moved       both
  another process in dst           process     process     killed
                                   killed      killed
  test_kill, 5 runs                5 failures  pass        pass

test_core, test_freezer, test_pids and test_memcontrol give the same
results as base.  Patch 2 also applies to mm-hotfixes-unstable and
mm-new.

[1] https://lore.kernel.org/all/305c5803b904a57c188b505d6ed9e1e4@kernel.org/

Zhan Xusheng (2):
  cgroup: list a process whose leader has exited where its threads are
  mm: memcontrol: find the OOM group of a process where its threads are

 include/linux/cgroup.h                     | 18 ++++++
 include/linux/sched.h                      |  2 +
 kernel/cgroup/cgroup.c                     | 66 +++++++++++++++++++++-
 mm/memcontrol.c                            |  2 +-
 tools/testing/selftests/cgroup/test_kill.c | 16 ++++--
 5 files changed, 96 insertions(+), 8 deletions(-)


base-commit: acec9637e03ca54bd3c3a0c1a6ad5c6dfa07c0df
-- 
2.43.0


