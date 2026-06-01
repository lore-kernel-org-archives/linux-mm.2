Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DEB6CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B4B6B0110; Mon,  1 Jun 2026 05:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1056B02A8; Mon,  1 Jun 2026 05:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0356B0110; Mon,  1 Jun 2026 05:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB4F6B00D0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:01:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA5A31622F3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:01:47 +0000 (UTC)
X-FDA: 84830751054.30.8D390FA
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	by imf02.hostedemail.com (Postfix) with ESMTP id 60C5680006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:01:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=R8bHB7Co;
	spf=pass (imf02.hostedemail.com: domain of niecheng1@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780304505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jDNtQRi5CizyyrP7BR7riMaNsb/AxIR/vWLi1EG8Law=;
	b=AJKUF8ab0b52xgg6kY5Jg9P08Kz1j36d2VN642wx9FFF4gx4HD9R36l8l4PeAZpJ57X2Sf
	bY/GJZ0njqfcEhP2NQrJrfedTgm/PT0PVTLNI5LnSQsz9Fg99WO11N/lgvyt/roXQhps+/
	yFvnKVc+dM0NALgVM/HHs//kRrwXDo4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=R8bHB7Co;
	spf=pass (imf02.hostedemail.com: domain of niecheng1@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780304505; a=rsa-sha256;
	cv=none;
	b=Gg6RC482L+OYFQKa35srVNS4+7EUw5miL/60cpyalFxxnOCb+8d+mPSLvRmydgTEDUbpuG
	ENxBTE82XObi5sNz/n1/P+s6akMOvEvPnbWsLncIU6LmSngMwu7yOZJRkoQiE52t0kbdMb
	QMOvQy/7Hsv1yrEnQJaaSN+uChQo/5s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780304489;
	bh=jDNtQRi5CizyyrP7BR7riMaNsb/AxIR/vWLi1EG8Law=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=R8bHB7CoXwX5mvkbQzjdQUhcySjclr4TyEDKzacRDe91Deg04v73SLA44nOGQqL3D
	 TbSX6TU51wHiGuneSvG+hZYps445n7Mh4Oy70HEyIUp7N/SJ5/ySdHmQ9/4b2afEBC
	 hP+EnYLRzDDb1Z+uid7/LYNpu07UPgY9NLXv9Km0=
X-QQ-mid: esmtpgz12t1780304483t01ec96fc
X-QQ-Originating-IP: Ob9Bpy4WPKB/RxPVu23A0LtyCLwN5F8DUWPaVIAfths=
Received: from PEN1097 ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 17:01:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3002622667247154987
EX-QQ-RecipientCnt: 7
From: Cheng Nie <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	niecheng1@uniontech.com
Subject: [PATCH v4 0/2] selftests/damon: fix memcg_path staging handling
Date: Mon,  1 Jun 2026 17:01:19 +0800
Message-ID: <7E6EAB7C1BE04DEA+20260601090119.238457-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OY5SyXILbwKtE3uCPVi/0Yh3KKCebJf1yvt+cXombyJdoO4pjb44D18L
	kSoLgTfSbr93ICK/FQydsOIaKZhoGs25lhQ//fU56aXGchhUSXU/oBGzRtMGIEogoa+z6ns
	PAwKFDjGKMcHuJZDDUAeIOXjKHpEmjLr19C07kay71Q72jbqqE5TMKygGU594cI7TskyAQQ
	21bfHZBzLnlQ8rTek5PJ3FsLLTG4jYolGj/nZgxPF6lToLJWrM4htANeY3P/TEBFfkRVouH
	eQYdlKwTajupJrs99zVyF6Yiu3TkNVFl3wjZqMvB312kM6iPsOKWdnyRSqpH9E7yjk2qeSy
	FJasIpfYIvHIXqhPpWnODrd1hzz4iJ1L0BHXDgKylrxfKdFoq+WAgSrdGwGZ6gAjErtGlMx
	8AH+zUmyEAsE2twDpLTvlb7uQr/gNSPhEGZwY8C/FxpA2SRknm9nyWKqbgqALaOUVXkwZ1R
	l9/ETqDhwfM0YYLF5HlN4vHf3hMccBB6a7Kb7NiIP9NnoOJ9rtPDfUVjy0AQ3SA/peBYo8R
	0aun/RGgz1EnQcVbsq0C3i9anZcvYT7BMWNMg0Hv7Lx9Y4BhD0jHuJFhVRiotGprzZbU1LB
	fCUfZUsvc0WGDTrGcMde8qsTCJdYhoNL2OaPKnmbknyrd4zkhtICBaETtNytn4h2wylli1i
	WO0MVloxkwerer5hFiBA8FtU7VLfaTEH+eqjwyAlQdBpSfo2u+Oh4y75zHYBkUm085ZH3+R
	e41kXAMhqpX0XF0TJq1buRSzWu2frKPSuqQT95NRW58nrxGCqXTGIDRwDAfzDwW2gpyY7y5
	ZyFgq/4htWe8q9y/Gu4dc4mUhqzQxlVGl2G+Dxey1G5KLJ3KTS4XeCm7BjehCxOAVu8Ci9o
	kACKSbXjspKkJ7z2Ui0Mp1MeirRikVV6DtjShDix/GZrrDZzpX2XCXhGlw9sf7N+O67Chrl
	EqNhmrBeCusDfYuGxcrpZ57QJPvflw1MF+KFE54VuoAdceJ4XaquH2wpuHB0fVXGo6s39rm
	+qerLx6YN3BNrPU2FAM+JyV5bBUa+w6TmJkE/jAh4I2XehDgAU78oJSCKV4v/H8s99P5pbk
	HJqsvf75sBz
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: oxa8ip4ctetqg5ywpy6they8gh6qam1m
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 60C5680006
X-HE-Tag: 1780304503-952258
X-HE-Meta: U2FsdGVkX19QY/75QV6igyhFWrIK29/vygMvBgccWmQyrqUowqw23tWFpV/vMTMC8b6DQLtdHX/gxSK7mGJNNQz+FvAwLjm7F5HMWdpAfYffo/zYajbdLZLmjVdaplEacKpUPfYM2/iu4xpEeTEGXpQksnBAe3/xKO0B1V8EmBzu+rtIusLRkYoxQDWGK/zqvTnpJHm0LgsAUyPfMX553VzZqBUYxfpI6XYPQMJyB6E02dU69T9OyVcrN3LVlAPAlFcubxsE4bpGf1YKI4a7G0IHEGrbtMP0qBVqcuC+DYXgwEwtXCzhdKlXsNH6ah0XeDlw/SrlsfCw5RlfvL81djbo6u/iCXbH4/zo5Rc2ZMB5qluD29ngE9KaIO+m7d9gEs0zY0h4t0rwsiMU+HI1JQJJNsKpntp8EmUwg8+vJPmorXAlVORctumKZK/KVEtYxigjxD6z4iedPBv8oaRb9t0eNSL1HL3i42Dg2d5qxdqT++TQloH4fRo4hhdJlS2hOqjHlEKixVeuUKpNQPuBy6+ilHBsCPRIl7m85HzvcuwUVFcGFUefnUoyLZH94nwtBvHWBqYLx2veWJso+jL0y82PUMW8MAB8WXqzNY5dzD2NprX54H2MsZFCZt0R2TER5pkd8cQVAAavkmyJFBHPh0uz3AnVILLb99en1+Z6AkibuYYjY0OXdvujbv3rTIpew/bavgBPMC0Muo191r+L4cqJ669cptDEuowvgeoGd93UD/4dflCbKX1fta3OnO2Lwgz7PWCGAPB/o0VQew2THQtusE+sZEYfmW3qOmttDT4vpjJwbcSHxFs9F4rNUXJBgvxkKJZzON6EUtoRRKIuHS4l4oHePFSQm8cmmlSRPdlyoCYWPer31zqizgK5Uu4cU1vJtddRTLDPsb24+g8NnaBvPMO+zseuGGmLq6HQUYhDj7ahkz4hbWlIlqd9TzjEgJ+emQENPFMM3p6sV7E
 UP/g3pV9
 bhm/H2/6tyOkzMgdgY8mPa+F7oOXJKVqh8ROWwlCQyfqpaXPid5iqYQbgiWMyf0GPX8f1smOapULAv/P9zCM32u9CtdcqBQ4xLEp3jt+ZbLlMAQXHi3w9TKsmPNqudKGjhV7Zv65Fk/b36zy4TfJUKPvEluHqAZprSiAf5nAvTw4rWq/yfQxJ4leIgOfQTPLT9o/zK7U5pd4HaZMFWR7YeqHWsJvhwRe1JRt8RItWxfTP4cRFcBjCWIJuvOHzhRt13axI8ZmqQGGWqGCp1EGsOyTCf18HW5FK35jbvmD0NEhh3LBia2NIL6rw+BiZUY0aZuuF+BXM9lTtzcXp6/HRZjn/KeD8KdL1Qnqr1HNkhnI4pY6RjPBbVN/cN14zi8EFSBLi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes from v3:
- call stop() for cleanup without checking its return value

Changes from v2:
- configure memcg filter before start(), remove commit(), ignore
  start() failure, verify memcg_path staging readback only
- use print-style error messages as suggested

Cheng Nie (2):
  selftests/damon/_damon_sysfs.py: fix memcg_path assignment
  selftests/damon/sysfs.py: validate memcg_path staging readback

 tools/testing/selftests/damon/_damon_sysfs.py |  2 +-
 tools/testing/selftests/damon/sysfs.py        | 31 ++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

-- 
2.51.0

