Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A99CCD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F245D6B02A7; Mon,  1 Jun 2026 03:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB756B02A9; Mon,  1 Jun 2026 03:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E113F6B02AA; Mon,  1 Jun 2026 03:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D08326B02A7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:46:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66989C1F9F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:46:04 +0000 (UTC)
X-FDA: 84830560248.11.A0E1E59
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4A2751C0009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:46:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Phy+ESHY;
	spf=pass (imf18.hostedemail.com: domain of niecheng1@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780299962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKyEwkDOqalQswQ1rmvg6AgbJ6uvYlJ03lXFXs4SB1M=;
	b=68FdE8yJ6NBy1UTUVXFZ2U7I92E4loEmwIeVyxecwIVbGQyQwb0GyFNZCoWCd2nUFFWaCV
	poroLFB+rvTDbJKLSS316cctcJu0Xfyt+ODKDcMeC9Gt2+xoAFbpoRUWhUtnQfX+bfLI5T
	rr/0CkdFSKHPxqoKmW4YDw0whISuyB0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Phy+ESHY;
	spf=pass (imf18.hostedemail.com: domain of niecheng1@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780299962; a=rsa-sha256;
	cv=none;
	b=H8XJlnugUNRJt+8nYIZ8vuIbTRekLiGaZ+3L5S+unCTzd433FoVKa2Uqq/bVOOtzH5l+Xv
	kmboJpjtgPSYc+Wr8Wr4ODUN4Kf8QsMPjPgr9JDactz5iFasu67Cun1ZS1zm81M9Sqvhya
	H0jlEnh6W7HZRVDZ08xlk5Zpf4mvPAE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780299954;
	bh=iKyEwkDOqalQswQ1rmvg6AgbJ6uvYlJ03lXFXs4SB1M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Phy+ESHYTnTiP5xB0SyzTmSkCe8vVFWugME9ZnndAI1ARiNN2sN35+AIYryudEbxK
	 9dBCa145Q818TokHFm1Om/Vd3d7MOK1BJRNjPPHmjRH/xkgwLoEMUbAkg86KuU+f+W
	 YbqHJlMEq8KvZzeKBDMKmlQrr9RyPuuDxZO1OJE4=
X-QQ-mid: zesmtpsz6t1780299943t5ed19dd0
X-QQ-Originating-IP: ExqSHFqpbSAZiOqWYUgRQlClVGT7Rdp2BnFYmqkl5ww=
Received: from PEN1097 ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 15:45:41 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14208097749711545290
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
Subject: [PATCH v3 2/2] selftests/damon/sysfs.py: validate memcg_path staging readback
Date: Mon,  1 Jun 2026 15:45:33 +0800
Message-ID: <87B39E0F19A29319+20260601074533.205616-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260601073635.200015-1-niecheng1@uniontech.com>
References: <20260601073635.200015-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NqpYruwlneiLd4+90csc0Uz7O5BhcCk49C2h/IwNVRqp34joGqK9uw8p
	+VBxHP9kIJ+o5AjlN707vFeljzZv65zCWyOeHP67+kQRYEr4xmoPySRYOhWIPZpRDA2ZjHp
	wv1I3u7gIkkrBYQK8JjpJ7ulu3gM6tOYCUgzLT1VqfX4YRdforMYhxIF5/d2/7liPsSfqMW
	/edYJz06UvRgmGaxptY6yiZFEG+EYGixWVR5JsDC+XhZ4vu2dszDtCNew45hrJE8v+e8d40
	5nripfeBA891NMJ/SJX7G1RLffiEPRctBRVaca3WX+34eM7I66Nixp8Qozm+fYKR6On1B/A
	inlpDpEwQVU2IGhQuHlyGbFoagZtkiU/jX/V+0mbBU8U83tTRdylMx/V5MKBIYOagne3Mtj
	GdrK47CK5taO14T4i+qHZFokDHIsK6nxZd4xqP4+E0yJ9PZIMZVGV0qUJFDlTR3eJHyosQF
	7G33bbz4WcHWPpZykBUkaoN5QKfAdRVfRC0xI8u9w1lZqN4iaORYTXCk0WeqRbXjDHkhqZW
	7A0/BMZ+h02H32XV9e7J1c4eQKwKpzuzysvI6TYTHy5mjG5hNBKWLISpuEV/vSFuXoSPEOT
	DJmJyYOcsT0pIhJSjzR5HZ7T4DzSIP7trmi478d+JGuDawZUdFGBZ757BioHHLJV3PKlc/o
	W8uuj5fBrjCuADh8BFeb+XW6oArSfxhp6k6Vm0aDGbycw3uOMOpGWyygJ91ONSKH30bmTpu
	XXHQAkyZVfNmJa0BhjlrGBR9lLGv7hz2xEEJUkAz+4bM9ThX+qytj/7fW+c5gyc7alhHbMi
	GHaUoKNlu2y3SnnCyeX0NH/51sulHne+txsb2zMV8mMvKNtyG0Zqvx+E8W3kCzcaW1gdMlh
	XohVA+ZUBY9h8vzPvc6ghsqso5lSCNLOStXo0IJwsZVEVPM1d7jhfgql4g3p7H24eOgaHW/
	vKThboxVmSTADB/XIxgB96zZBbVlWAztvk2z4lhDy8waXtTAlH5fDxzWwPJaE9kYtn5jqup
	EQjxMCCiA5hwKtNZxr4rJ1oyInJXSsfNRy2XUK4czu1j3P4gNe439RaIYMRmTwnCFQTbe4I
	kYKqeUDAN5Uiulia0o7d+n6F+0+f+o5vtVfUXrDfFabXBzDtYEZg2k=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: 74x9z5kji9z8imzqyn89mohk4qa6ykjm
X-Rspamd-Queue-Id: 4A2751C0009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780299960-136155
X-HE-Meta: U2FsdGVkX1/1EDJ8KwzuskLHXLjMP6cM8wAWrqDRXxJ07irRyp7Bu9dIO7MVKiuveNJ1QMR51aOZgitN90Ra8SRfPr23pxt34nWyxP6MN14J7PSSVqrfaeNxckhLGyzvRaxzUVWn8OltNdS61x7B2snczCroIAShVvMbI426TiGy5kKKLeA2IRpefr2YkIgdwHSUi8Zh4RMgl7O0ogBdgrm6ABfhZ9GSz5ZMIHrV3UVEreRBm9i1K4YXe3vt4tnOuRX4VZKw1wW12gYMMFad5+VpCcvym31yD2gDnYxhgyfG7Isn7oxfqGrSWgcinw0DKN3nbCqtofUN+8tchImeFSoWHRQCD5P+GrlSw9uPWnQIj7NPX2nxGbMItpW4qGtxTW1ecxyto5MEhI5JrGk0Up96ZdU/bmG6F2vJ069fyZJ3Bjpj0Lf2xp8EhY6jDoN8m+dBNopJTzMK0GUx5Pj2K8LvGQAxXhWfHKGLB+qmtL4v8+dJaMaPn9jVopyZtHtLodPo/L3zGng4FZOaiGUlXeE29/FVFvRj1HhoBBWzBRdBqa/LIe+sPXi02YW7/TlTEzLqrGC5ivCu87RzVBhoXN/9tR+bQanFPY/gLAVUqnPffgmDWL0CYEo6Az/XtYX4vI6ANU/6LvNHbBxuDoFPWGsVW5lQRClW2dpL3j8p6jq0H01qNnys19TElwsbsgtZQSqyxW9ZrEpl/J+HiecQyBP0rhuGX8q5ZokFbACNBtFbSYkogvqW4sc7Gwtyzy3TqkbrRJ/J3D7Q13ctcvDNlxfbwtzWcbu4zIdizF4R/bC9IhU28wlicILuBnyChz1np/fRdQ+u+gTHwrf5s1zYY0JcfJWC2Rpozy+Ik3OjidusaAAByulUVRGPDbwHSmAaCn6SGD/hLabRwUhmww6bSNemr7LIUaJky4KzwpkNIBq5j+nhpEfGWMxo0AY+803NWHMylH0LK+wj4gWvjTR
 AvQ009P8
 0k4EfNQPXaGzRBvJDljGaDNe8KUA8CSTlBWkiJXlcr7uIravOF9zBP9v8v0CH3EOsGRRTg/UpOY9FxHdaqC89X+IqtAKbR29kyLXDVgopTCuRuneg7Wm9YwWyCq1rD8M96eEA/6vwk5tyQtZsqz5WKacRjQk3XKBy99CvAhi4LnmwzLox7eRwutc/ArWDwfoVDv/usAx8FRhV/x9yYjU0h4PACy+ANfz1eOI5BnD2oTgX34HIfEQXlAf22UV40oTc1Xb/shISwC5uZ6WtFzyUfHv0z25la6ogcl67TRb37VKPCZAF19NL+/nPfIqySzEqIkdydqrErzL9qrYSqQqh4VItu+k40V055+CKtVW6GWOsH83ng17cDiVupt1B9IVfM59YWiChW5FPkgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a dedicated test at the end of main() that writes memcg_path to
sysfs and checks the readback path.  Configure the memcg filter before
start(), verify staging readback without commit(), and ignore start()
failures so the test does not depend on CONFIG_MEMCG or cgroup layout.

Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
---
 tools/testing/selftests/damon/sysfs.py | 34 ++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index aa03a1187489..7a17ab88361b 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -250,6 +250,38 @@ def assert_ctxs_committed(kdamonds):
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
+                    schemes=[_damon_sysfs.Damos(
+                        ops_filters=[memcg_filter])],
+                    )])])
+    kdamonds.start()
+
+    shown, rd_err = _damon_sysfs.read_file(
+            os.path.join(memcg_filter.sysfs_dir(), 'memcg_path'))
+    if rd_err is not None:
+        print('memcg_path staging: sysfs read (%s)' % rd_err)
+        kdamonds.stop()
+        exit(1)
+    if shown.rstrip('\n') != memcg_filter.memcg_path:
+        print('memcg_path staging: memcg_path readback '
+              '(shown=%s, expected=%s)' %
+              (shown.rstrip('\n'), memcg_filter.memcg_path))
+        kdamonds.stop()
+        exit(1)
+
+    err = kdamonds.stop()
+    if err is not None:
+        print('memcg_path staging: kdamond stop (%s)' % err)
+        exit(1)
+    kdamonds = None
+
 def main():
     global kdamonds
     kdamonds = _damon_sysfs.Kdamonds(
@@ -356,5 +388,7 @@ def main():
     assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
+    test_memcg_filter_memcg_path_staging()
+
 if __name__ == '__main__':
     main()
-- 
2.51.0


