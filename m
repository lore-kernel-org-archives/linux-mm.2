Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE61CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1848C6B008A; Fri, 29 May 2026 05:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135496B008C; Fri, 29 May 2026 05:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B026B0092; Fri, 29 May 2026 05:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8C266B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:22:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91013C6DDD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:22:06 +0000 (UTC)
X-FDA: 84819915852.03.5DA2DF7
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	by imf03.hostedemail.com (Postfix) with ESMTP id 816D92000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:22:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZLt3VEXe;
	spf=pass (imf03.hostedemail.com: domain of niecheng1@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780046524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HylwJTKDEjdoNKKWZ6Eg8/02B5viIR23i6MNlY5fspM=;
	b=ded/QDoKZDazg3ROo57UQga63OsnzH9wYqFmX5+nhx3pFvZxsvmsT2ZH5ecXWngJ/49pEt
	vxBgrBlw9s5pJF4Wbq8Uq4mTsdsxbCOljqzPqQWaNBgUmfdZbRA6ky6tW96SOkFPsyRM3a
	OU91OOOByD/1zmNYDhNMlSKRkGLcYDc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780046524; a=rsa-sha256;
	cv=none;
	b=JSOnlzBaixKPVe1QD7SQQVZyqJktQwwVJYPWif6ojZ25wEfr8cYjp09ax85qWjoNB7I4xE
	QJGOcdkYsCbzwei5AkYxUKfM0ZfNNi1dRo8qhZMCZUzvKLoNS1VfXdIh1dl43ah5tevHuU
	97s+yMfriWCDBVmMVMkgeBmPFtzuYKU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZLt3VEXe;
	spf=pass (imf03.hostedemail.com: domain of niecheng1@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780046507;
	bh=HylwJTKDEjdoNKKWZ6Eg8/02B5viIR23i6MNlY5fspM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=ZLt3VEXe9hzaPs8160QBczBg7KZjf8Ju/zdWS4Mf0LsT8wUAVZiPSJ9MkFhLUdcbA
	 szQKyto/d+wtOM96/9K1E8fT1XvokuZHQNnFGRUl62EkH414gR/7/J8jnD8jc7FY8Z
	 xAdLZdEw3SSvXSe7jLceOtX0oOcMocUr5w7xuMuA=
X-QQ-mid: esmtpsz17t1780046496t9cd9bc45
X-QQ-Originating-IP: 5UBRpNotQxnNW9HKXjVMAySgKETLGGMgdHkYNKWLoeQ=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 29 May 2026 17:21:34 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8261288960962780039
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
Subject: [PATCH v2 2/2] selftests/damon/sysfs.py: validate memcg_path staging readback
Date: Fri, 29 May 2026 17:21:31 +0800
Message-ID: <FF9A1552C03B7C88+20260529092131.1703337-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <4CDA28DC581FDCF8+20260529090845.1696845-1-niecheng1@uniontech.com>
References: <4CDA28DC581FDCF8+20260529090845.1696845-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: M3Y38+foqXFqd39Vo05m7qqe1YkKOZngwhy+l2ffA7pcW6jfMqGpJjzB
	3KmYSq3A63PwrFSX+bWRH7E4IlAKxox0ib9LBwEdqzvyODozryMhPpk5MNjPfHeUuDZ6rHi
	KTB9h3s556hS+7ywgvL3Q+SUi2Z7TgzKtTHF3HZNfzhsVfjCzCskxvwkV/OQWFOsPcV/ybO
	d7NHAf8Ue2LGas9wxBKrf3iWfHbPorjwYF8gnGcgQRCBMIyGe3ap3G0sDlfsXDsZW0uI9Z8
	C/xObQMV07FjhlS7BqWNG9bHYNPuCMGkWWM2yy45SXlfuaSgwoAXjFNkWPZfRvHhBIuLKXw
	R1NC0mpRp0ur4cvmHK2gqoWCFrhcWz/G6cBAXiPevB+ICiaT/c2QNsvMuQ1ryEoN5n7Y8Ll
	QlkghK694W0gnQgG+Fz5iwE1am3Ny8C9rc/4/nyMter/gTEClCi4NHtOJUa9ppyH0Jdnh+t
	l9VaACBXcEUZ8nAWfwmS3yQeJAiZsCVlc6bV6YusJNo/1igYs4XXUAi3nwR433/1+i28AwF
	AVnMtxME1o4RyFIW7hMZI2fOJdl9o7U9xdZCQkVNUcwjVElCcEm1hBz411hVqJd33flinXL
	TimRNiFfH2fqZndp8zSkMsZ9jIV5d3z5mDuWx03dGm52WRUafQVEi/E6TubQbDHUMBDPzxc
	IBAaVYHQmZckLghhRKt+en2+yo1FrCSRFnXVrs8S+21B9BObKQ9BqDKCsXkgeGPtswVNN5G
	cXzJspMyVZ8xIpNGBgJuDWrOsPWJFV/KNvOuWd6AWRjKM3hdSyS64frQMf52DL2kKjQMzV7
	C3s4ehOn2C8ANakVyZ2qIthsibmMvePA7otnh4B0ITsdEizhWBb1eK7ifzDCcByW0oF88ga
	/Ohytup8Bv0eKcKJYPe/9wD98ktSguhgteUKUQ2Bc5myTP08PosLb3oyzIvLG7nbP1Hxfnc
	AqBFdqmbwONJwdBz0e/Sl0Eyzma9YyoLMTo2VUKlmDG5yx3ljS1ZY0tKT8PH9DwQfnE0F2G
	ITQTeZlAxfojIwPLaxq03D3J2551DlMj4PGrU3+wuMxVH//YaysUqEb60xn4oc9DSgMMLZQ
	g==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam11
X-Stat-Signature: 3esnursniefe1fysity4cminxxm6ny9y
X-Rspamd-Queue-Id: 816D92000A
X-Rspam-User: 
X-HE-Tag: 1780046523-586848
X-HE-Meta: U2FsdGVkX1+lzC8oFTww4fNVKT4FeoxP4pMDb0ogXdsJRx+rPbVW8k90O+fI7sXKpTzkLfqRwbtPAK+UBunFNrA4ucalIftVupJ7EeBaHd3JmXj7PemliXhZbwGFjBDgIBjXIs1o0l6585KWgXExilykbtIFWIEqpk/awF1yMjxSbIVLNaQHhfOCWlmlkqnGZ7hFEfBjpPueDgroiAP0jBcXOkVYdti7FZDs//0S7G0SujPT/wkUI5TUS8LVMWtzMOZgG/FZSrIPFOCNC1/D6GtQgh6ESxXxAO4LlE1SdeMj9B8w7Ql9kbgYkCWIt+rV4xYdnpsIj5sfwIdb+8DKFVSrU35kReMD+wJ2nUBCiswPzkh1P7BWTzlYa6E/n8LHYyGv5tNJYVPmhwkSjs5iYnRwDASkJRBNJzdOlsHKyYwkYNaQ0/TNWmdCEl2Q64Y3Y/0YpAL0DDfW9LdSA3yNQDHWeLnm6qJZAIwir41SikaYjsBb4XRPaJTUxk8f4TU2zebSJP0QwOiPtPnZnSRJCGw0lGVBlHhZI5MUPNDYHRL+V3n0rnC0/xqSNB0a/6FKmtlzyyROuF10bQX7HykfRsK8oLCIASRYfiijb3KMmjwTHZ97B8arj8MGAWyk8BGpHy1SkvhXEF/Pccp0tDvDbh7rx+SOYXT8dz9eMDS5jb8koMZaHgRJUnvroD5eGvG5RjpgjHpMtKkTuxf+lTKmpHBmROZ/c/gN493MtVnqYqFuMisf9Fgjn89NvR5kUFREJLUG1DnzPqCKlMbzchYodtrUQwOKNUcRCRABstrS+y++OBQkhfaUy/5qP90EMkSxunWXlkKC5BaujgH8pVxFjI1uoeIuomUaqrzK0G/qheDtEJo7BYZvPlPiSW7RdreTGJ5AIYpU25dqTdAAslZn9VrcftDbrYdb98WurpIskdfknlPOKHyLPHu17LCrSxpLo71xstvr8yowvTgmV60
 rU6WaMXH
 SPbzlBcgJpH2CqZ/p7iDujXdG7KV4vNy+r/PeaP8spH1/JnH8wlRl5BN/RniWBJI1qx10KK01XEXqINs8Uyd0MKaoYK3ODmzTo0g9p1Hj3J6hNiEQlokDY/SOg/ueoqr4DKS+dyN0Bb6kJmuuieCav/1vzBBm1mHdVnB3/QYi149VWUxSksWe409VwxqVkF43m9QXc+xWN4RY/Su0REc1ZVDkBwzSp5pnfp1StmS0xyMPYhjMBdZSiJ5pXL/douJ2vI6Mg0NHo9msrToGjfhal0nc9Sq1wHRRithbzdosE4WXG8tiaa+86oDA2B3nt22dl+SLlOOIVvtR2xB6hZlwQu/Lr71fl7eKk6ojjXLZOXk/Lp+Dpo2kDyu9BFGlIQmehukM5z24spYI/Bo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a dedicated test at the end of main() that writes memcg_path to
sysfs and checks the readback path.  Validate the readback rather than
a derived memcg_id so the test stays focused on DAMON sysfs behavior
and avoids depending on the local userspace cgroup mount layout.

Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
---
 tools/testing/selftests/damon/sysfs.py | 39 ++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index aa03a1187489..0f20bc9c46b7 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -250,6 +250,43 @@ def assert_ctxs_committed(kdamonds):
             if ctx in ctxs_paused_for_dump:
                 ctx.pause = False
 
+def test_memcg_filter_memcg_path_staging():
+    global kdamonds
+    memcg_filter = _damon_sysfs.DamosFilter(
+            type_='memcg', matching=True, allow=True, memcg_path='/')
+    kdamonds = _damon_sysfs.Kdamonds(
+            [_damon_sysfs.Kdamond(
+                contexts=[_damon_sysfs.DamonCtx(
+                    targets=[_damon_sysfs.DamonTarget(pid=-1)],
+                    schemes=[_damon_sysfs.Damos()],
+                    )])])
+    err = kdamonds.start()
+    if err is not None:
+        fail('memcg_path staging: kdamond start', {'error': err})
+
+    context = _damon_sysfs.DamonCtx(
+            targets=[_damon_sysfs.DamonTarget(pid=-1)],
+            schemes=[_damon_sysfs.Damos(ops_filters=[memcg_filter])])
+    context.idx = 0
+    context.kdamond = kdamonds.kdamonds[0]
+    kdamonds.kdamonds[0].contexts = [context]
+
+    err = kdamonds.kdamonds[0].commit()
+    if err is not None:
+        fail('memcg_path staging: kdamond commit', {'error': err})
+
+    shown, rd_err = _damon_sysfs.read_file(
+            os.path.join(memcg_filter.sysfs_dir(), 'memcg_path'))
+    if rd_err is not None:
+        fail('memcg_path staging: sysfs read', {'error': rd_err})
+    assert_true(shown.rstrip('\n') == memcg_filter.memcg_path,
+                'memcg_path readback', {'shown': shown})
+
+    err = kdamonds.stop()
+    if err is not None:
+        fail('memcg_path staging: kdamond stop', {'error': err})
+    kdamonds = None
+
 def main():
     global kdamonds
     kdamonds = _damon_sysfs.Kdamonds(
@@ -356,5 +393,7 @@ def main():
     assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
+    test_memcg_filter_memcg_path_staging()
+
 if __name__ == '__main__':
     main()
-- 
2.51.0


