Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C027CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F5D6B008A; Thu, 28 May 2026 04:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24BBB6B008C; Thu, 28 May 2026 04:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED846B0092; Thu, 28 May 2026 04:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2AD66B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:11:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6D7B90C49
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:11:22 +0000 (UTC)
X-FDA: 84816108804.13.E70447A
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf10.hostedemail.com (Postfix) with ESMTP id BC160C0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:11:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=jtCpSd8y;
	spf=pass (imf10.hostedemail.com: domain of niecheng1@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779955880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtizzlCEw0/53zw8NLPj1j97omDIHUW4gZwvkbZ+ZR0=;
	b=GEXn3gHrhhDf0o18Dd1LE8QEIi9JQoXUFtw31qpdzZJwm2VDte5nYxkN1FVonpnQ2p9ZuB
	uWb5Ri8e15MG99GITLpjYvuEsV6TkxtIRLb7Qabyqki9WqnFVP4zmnIjsoJRToYeISfBoQ
	gHGMLgxTGs2b28FWaDLNo4nZu9SUrqY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=jtCpSd8y;
	spf=pass (imf10.hostedemail.com: domain of niecheng1@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779955880; a=rsa-sha256;
	cv=none;
	b=wfXAduWX/EWgcP0+IoYXLZgJSc0GUwq+A5FsmpCgwI9sA5xbs54pKznw+vbN/CVboF20fC
	XWDIupyBfar4GKLwA7M5tiQbKH7edq53L0D9pRwk2nb6ijF5h6gLwLjbkkEX4gc8z2mDNW
	yVL5h++oCGs4fMBoS4QOncuQLIBmoHM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779955865;
	bh=OtizzlCEw0/53zw8NLPj1j97omDIHUW4gZwvkbZ+ZR0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=jtCpSd8yUgtgkbrH0WGkEe6oirzTbSwJ+bBxQBRJJRbApOVBJa7XX9xS6Vqqoq6Qk
	 UVptZBVP5nHCpkef8cF3IqeLGL3mSGiob5hET6EZUhO7MVlngX3j9MXxWuHXz+fYHm
	 k9Q05D7/iE5ljTaCtJkmpga9hmJI4m94CLnHDm0I=
X-QQ-mid: esmtpsz17t1779955854t571d6731
X-QQ-Originating-IP: w+8TIl4HFrhrX5MF7IR7jCKdH1MZYRedCQ+TRDM3QPg=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 28 May 2026 16:10:52 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4212579660610101544
EX-QQ-RecipientCnt: 8
From: niecheng <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com,
	niecheng1@uniontech.com
Subject: [PATCH 2/2] selftests/damon: validate memcg filter sysfs readback
Date: Thu, 28 May 2026 16:10:39 +0800
Message-ID: <406BD1BA0F6AE326+20260528081039.1192194-3-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260528081039.1192194-1-niecheng1@uniontech.com>
References: <20260528081039.1192194-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NlwPN3mHkzpj3UwhfU1CKWFXrqw1yA5fsK21L0/+1bkHnvM2JJsAa7da
	EFRAMPDq/Yj4tIVVqjhE6ioWY8hthQp50Gx81VCmhkkw0h7q8LbwbtBg/uc+EtIHh2Xwjsm
	nIhalH5WZswNzPZtYfyfh7dG5IHaC5Amc9A3fjcWDBJFeu7FH/pOyq+FoimS7OH0jraLJ8+
	iGLHF6zqMyxQllPRSm+WiwGMgG3tdpfuC4LlJd6hCp51ILSYZLhvsuOFLAKP9s/ICr2XTJn
	ULGHxQzVF//uLjaORVV0bIHE6Qw66EjkwvETzvQgWhSqF9feVe5HaLL5vLlSO+ElQLrln9D
	30Z01Pmz90vnvJmywZaIK0XJlPh/stMzVAZ39gR4t/4yrw7ATgC9v4Pekl1JFypv8utkx1A
	I5CUjN7R+gI4bF/kOn+gUs/LU4orvacNg5XkwwnuBwNiI0Qv6snw9Xnyz4xszIoQoFXSobZ
	90Zd1fgv/KCJPv2aMGjlro0vlYty+g/u0hWlvSb1GnbvMt+64nd1AxQvnr61rbqBrQVkGlP
	9oscdbJvtWO5bJbLm1QI3kEB1YYLnHziVtPIZb91Mns1bO/+5oBeQZaHc7U3gBVe+KjqepN
	slNcwV6jftnup7OPXvwiHAEKwrwvirz/lYwNo+yPdALYqpYXu2MJP4qqPxDJMMBDGsmCXxS
	/FQLMMg5WYfTJN2qbFUV8ANEKUGyArVCR0+MMb0t/yPR5pC1UU4u2eGCcE9AzlHcA8MVBIN
	75sHkYjJvCqS+KsUOiaro7Jm5MPOptjEG5tG288qN/R/xCdlhfWJskQFuj9P7OW1WwYPKjc
	Zouc3IzDQpapraYpfZP8Uku/+AVGKZ0MVD379Qms+okL8CJ6AvhvqjH7TcTyzLpCRqmZHXR
	srAIU6SzeXukTPtGMlQinv/sKg9xOWiBBTwCWRWO86zM3iX+ONIcZmYP/oYqAW8ke6rpY7P
	c6TDP4iZrdTVTcBJyo8S+vhmda9XVq6uz+TKcTZ5Fob6rtEhx9eKXiQ0sUw78EkUqP+Wzcq
	2y07OEIx9cHujaDcJd+r/27uBMrOG+YCaWF84AJcpVu3oq+POPB1YJDVhnBF/6sY2j4Dsnj
	MCOXhkcpuIBe7exHx5LkRhib4AkZp11WM1FTDo/uxUQ0t0lIFdTHx7ajJujb88FItmn6KPi
	YJ/vWh0f88V5Ygo=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam12
X-Stat-Signature: zy38fixas3qdbamc9th9yyayuo5649xu
X-Rspam-User: 
X-Rspamd-Queue-Id: BC160C0002
X-HE-Tag: 1779955879-157487
X-HE-Meta: U2FsdGVkX1/I7Uu+OmOFU2U5TEWO3GwILzeyfcY8HVPWg0HT02Iz3KfbzRYjnVar0ms99C546jm/fAAqbp4TuB1CufR9RLlH9Mbz9ajZ8rKtpvm/JC1r9Rt0vrBLcpAmavNeo0wH3pE+vSI3U776+6tkxVKIFdNebCPps52+dLDreiK9ovvkI31Wp9iTPjj0Wx9PJ+16Ymny8WL6Fk/y7PWLn3xzIjDomZ013BR7nLGcaM3+gUbsk5rNhLylfkAWmQaGtfgkg+3roJOSzU/A/iLjQy5RM8m3G3/T9Upd7m3lViQEncFBd4d6fFgmQJBxGykS1Z4EkTn1KgU/z3z40fKhv0UhxDNgzV/r90NHg09FOR4u30sv8cDdnYJXRsO3+9PIFmxE8RDiqiRtfqrwrmWNWMm/wApRGs7QYwN3s69isPnve+aXklrdmBDMKWOTmOioDywlYjY5EfvJsHTzxYqEThSdcknKrzBjm2ddfG8myZ4dEigK+H34UC24RrBfYPonDXnw260nFfxAHSuemkEFauECDUWhHoZ7W35L4Uqc+aF9kw6Fr2ZgYgAyE8eXSJ97u2hRHTFQaiRr4jqTVwNSa6zYV/zZpP3ag1aIMUj472Bolyy53UtBoNLyfTrAYczrhdTl83Rcc0u9TE5OxO7ZOrrSsF0NW0HzYvk2RclcL8DNzG1TceDv5/hggwg0HsD1qakLutpQXpz+3f933HvulEppvZH38OkA2435KLX/om4ijovDbKsEuyaEOcwsOhj9dC6p4KjXwQNcdX2JEH3uRygNnW2eGCTVuqhLuCGdpc8WFDcf2ftoRXDqwzp7mTJCe6JmZbt/7c3iq66lYECmHBvv1fn3PwKsOhmNeQJTKBlcfZ6on0k4XELVK2eWPndePlg0/y+Kcyw3RIE2sIJ7nEW2KNmGCZxS0kBkweErcwY111gsojkxYUyHjoCwwtN9bSHADPuDv8pSSFm
 wb0qETP+
 6+vCLZPx4Ns6irZuZ1ceNX+yiic/C9823OdfZIZ8kFAXs2EU9FMul8mSwL7L32jTgHn0idcWiAwrVw1EuiBylRHcky74KyqCQFi+Foq4uX4tcBRIs30BauWmNTUvxz4/2XxIw5F/m9pluH6GB0s/TgRU0ZbpepaoyblehlUAwr8Ls4T3TQJOkS/AIe3uzF2W5Y8fkeKu9AxZ/if0uO37jUVDCyXaFBGsIectnW53Oatt7qkJR0U7evnqRtVzXl7dqQ7oq5913lZo+nMt5SzHIjQ5XsgDs50iRu3rueeIciPR+7kJ0vdYukW3JIBJs34rkK3od9iGJ4Ur4/2LVobFHh3pbNSIQ0K282lv5NxGB8ITdwnfbXW7WmvNjjeYNIXhzdBW3L5cgIWuKgCU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add memcg filter validation to the DAMON sysfs selftest by checking the
memcg_path sysfs readback.

Validate the readback path rather than a derived memcg_id so that the
test stays focused on DAMON sysfs behavior and avoids depending on the
local userspace cgroup mount layout.

Also compare the readback path while stripping only the trailing
newline.

Signed-off-by: niecheng <niecheng1@uniontech.com>
---
 tools/testing/selftests/damon/sysfs.py | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 3aa5c91548a5..b595da24f698 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -33,6 +33,7 @@ def assert_true(condition, expectation, status):
     if condition is not True:
         fail(expectation, status)
 
+
 def assert_watermarks_committed(watermarks, dump):
     wmark_metric_val = {
             'none': 0,
@@ -90,8 +91,14 @@ def assert_filter_committed(filter_, dump):
     assert_true(filter_.type_ == dump['type'], 'type', dump)
     assert_true(filter_.matching == dump['matching'], 'matching', dump)
     assert_true(filter_.allow == dump['allow'], 'allow', dump)
-    # TODO: check memcg_path and memcg_id if type is memcg
-    if filter_.type_ == 'addr':
+    if filter_.type_ == 'memcg':
+        shown, rd_err = _damon_sysfs.read_file(
+                os.path.join(filter_.sysfs_dir(), 'memcg_path'))
+        if rd_err is not None:
+            fail('memcg_path sysfs read', {'error': rd_err})
+        assert_true(shown.rstrip('\n') == ('%s' % filter_.memcg_path),
+                    'memcg_path_sysfs', dump)
+    elif filter_.type_ == 'addr':
         assert_true([filter_.addr_start, filter_.addr_end] ==
                     dump['addr_range'], 'addr_range', dump)
     elif filter_.type_ == 'target':
@@ -258,6 +265,8 @@ def main():
                 ops_filters=[
                     _damon_sysfs.DamosFilter(type_='anon', matching=True,
                                              allow=True),
+                    _damon_sysfs.DamosFilter(type_='memcg', matching=True,
+                                             allow=True, memcg_path='/'),
                     ],
                 )])
     context.idx = 0
-- 
2.51.0


