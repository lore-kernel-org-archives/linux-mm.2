Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94364CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D696B02E9; Mon,  1 Jun 2026 05:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035116B02EB; Mon,  1 Jun 2026 05:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CBB6B02EC; Mon,  1 Jun 2026 05:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6F7C6B02E9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:06:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 846AA1C1DE7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:06:56 +0000 (UTC)
X-FDA: 84830764032.24.8FFF67D
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4D28A1A0005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:06:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=kYxuEtUv;
	spf=pass (imf19.hostedemail.com: domain of niecheng1@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780304814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAHbdeOT8ZX8fshgJDDeCFa1dLV9zKerU9/NHqvyp+U=;
	b=Zrf35aQGpCfK+hINYcSf1AcfZFfd3ewk5/UYHsvMf6EoDJdQogwdYFStK4auva5JK37pzd
	d87ri07NrYe3QPACFAu4FWF1Q0GAA4fhbHzYZRpqNmQky9/oMOuuTg+lso+0FXggFgEZVp
	rDwd1gz64//5yorTeVYSErPjooH3pEc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=kYxuEtUv;
	spf=pass (imf19.hostedemail.com: domain of niecheng1@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780304814; a=rsa-sha256;
	cv=none;
	b=CV7XpqK+3kerT5PWEIlAHaWE4ctsCUVI6iiqDZA9FXlfaaamiQTo6A7ZvROv16JchGCwUH
	SGBEzPIW/Nk90/Tlak8uKepX+eMVWs7OHP2QR/XaUp5odGE7QbQ3OTkuo6ysRXZ/NaMa0N
	pE14r5dfkPS9v3kiO1zzC1k53qy8N/s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780304803;
	bh=lAHbdeOT8ZX8fshgJDDeCFa1dLV9zKerU9/NHqvyp+U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=kYxuEtUvBR1e2XiFQumuPUQdouL/6nCc/PGwWOTCpkUwOu6CA1uV9fJKBHYI4esWi
	 XF5wAZvksOATLNbVxOo3YVDVRBZcoK/eKJyuCCs6zPXXwlRJhPwXX79Wkl1UJXJoK2
	 m3bimuBBgtXpzUicC/YdFojCl0tz1q4w+11d81cw=
X-QQ-mid: zesmtpsz5t1780304798t67d8a19d
X-QQ-Originating-IP: Er3M68l1E0Xar1zCBj8gD6rIxkoUlUhGdvpeAZizzh8=
Received: from PEN1097 ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 17:06:36 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9912389010984352199
EX-QQ-RecipientCnt: 7
From: Cheng Nie <niecheng1@uniontech.com>
To: niecheng1@uniontech.com
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	shuah@kernel.org,
	sj@kernel.org
Subject: [PATCH v4 2/2] selftests/damon/sysfs.py: validate memcg_path staging readback
Date: Mon,  1 Jun 2026 17:06:33 +0800
Message-ID: <D2B37130D38E09AC+20260601090634.241864-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <7E6EAB7C1BE04DEA+20260601090119.238457-1-niecheng1@uniontech.com>
References: <7E6EAB7C1BE04DEA+20260601090119.238457-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OaHhCqwLoLqrN65ABrgAEgxEzVdlUgQzzuPiHJEuDMVxZ5YDH32bvBzT
	gUooTyDSkyOY5QNnuK258Ldce9bF3XLQUrEAaPnJjVPHERbG4HqBceqxo42FG1g3igMnTln
	8HecTcXT8C6+pb4TkSl18GUhgKOIt5w77fooeU36eG97f2B2lyvq5giF4sTM/laTb37jSFk
	HL2Y3z8PfeFem6XxDIAMnJ/9Pgj2n9Hnc/Bzfp15dAAo3TeJiWKQq2kxA85nqlY4c+3tghj
	DnHQ03rXe/Gra3t3sg4YpvgI2wONychFdmDTzmMpjmGZDaXDmvieJ+OV4ZiCXu5LspMAZWw
	R13YvlsJx2dq3MPNxVeNp8lqApWE6Ehqlnw1MwwMQzo0p0T6TMkGQeVd65bpJk98G33fO2N
	3m8T6tIV40guDF3pNeF/8YwDmCkCAD9LHr9IIDNx5HKY6G9uucQjirZP5+BqhyxsbIij1bW
	I0Pc4U5bA8tSdt2M+614IXbc/AWm6F8pJJdw16HV35HieFCIxK8URpRoJ99JZ9JCSf9/pYz
	oelSCrdBkF2tZAi45csm6K7jdcSblcQowZGjD30DpptIGlF2tuFEuJHvGQZ5jBr9Sx/xpEd
	odXWexTeqiYbsxxmwGqdQxwTt1yrUWlT66DGELYxEsIhOLMhGZVWiBhJZQtBib5WRm0K6fn
	xMCJ/9FLlkX21SNqs65pLlaEQraiyJXxRmvcnfcB6XveeeEPfIvyXVKZO0LztYUZ3Hm5jIZ
	qz0hrSFkmdKgf9PFSPxuC4ZMPbl6r91HF0VJES7N4oQAy3WBhotLMdtwGbZmX+e3B/ZzYUI
	GRMOwxxhgF3gsFHlK+1E3N2huyx6PzzkkdVpOnSqEvn4re4yMR8nDzAd7HjBvK1Ash4fXk4
	rN0f9SYtMhvAEtOp6hlrxvRMUv4U4yyg5q3/iLiIot68n6DpSQNeA2yCXkEbpWg9HyQdI31
	UV8+RH3fYpZ6j5p0JEUdrIEHwSMhKyWo8W6aG9yMG2foi2lMj0YA403jv4O9VSxgmlHSm2F
	/tYiyy199NmMigA31s7XgzXFQP9yxNacUQWmAhZKEuSR3Pvv2ISBjvHzvjsakuDJ+xnYzcJ
	JQg6eLYm9fAjDC1n36mvHd4pabvs6WKcUGsKLHUAi2crAR8o286KINxWxPutMhbhx/9hPaZ
	7hzWJE5P62+sZNtgF6KwJI5uSGYV5wwaIRu9
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: y78yzd1citag15dj3nrrg4bt3sxbpbae
X-Rspamd-Queue-Id: 4D28A1A0005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780304812-96861
X-HE-Meta: U2FsdGVkX19CVlzlWpy/UxjeS7H9uM464r3UxyDVK1277ROtnM7dBlfFotONotTsRop3Rwr6UT4DhWKXex0GW1ORQuzI43Su7+aLWUdwoQC/nhjyslUsqeonMPwfxX9il9tgERnTR4XwuVdF5mu5HYaF5BuCXqa0rpg2MG3TXa+JA5YeUxkftTc2eY4D9rOnOZ0TDbppOlDTfF+yGA+VP5pIsV5yneyJhP/UoKSmloo6JygOSESwZqc+RwW34J0YL4VTIJazm41XSta45S5gOn9cp67oSsrcDjwT8peimfZ6bAkzkfsG89zdMudrDe2hNJoUE7bgdRCZf6cyfGlv06cD2unWfONBkXI22I2bFrUKVJcgqwg8hSEfbIrkkn3lzWsMiWZpCoLdbVpXVB+cvX7mCUjXGH48UHULDBL4MSpYJKsGMT9L41hSJiTA1FIqCgFDNyA19yn1ymbyJT7QzBRsvXrZZEo7ZkdE+CdCk+eSxkMkaCbs8/0Z++ROQ8r7ZXg5Qt9oFWS4CCQq8xM/Ht8tuDaiH2z5DlJyYkxjbpUQyCmr61FxVxXDZOKtPi2PIzAKHIpJV7wnvBkhFtA3zN+0tVKogXuqYakqJw/o4mE7UwN85Me0eyfGmDEHwGnSpBwiGX3uPwTukpfNHda/IVozFbsSCnXWc6VysH6bZguhfYftSXXfzV5NmLk6QAnJGf1CBcNYyg+QtfSCeOFIydvxwd0d64rBbfQUF5gcAZb1fBu+ddZUDt6E7rEMMzql0H527JfMm42X6Nl+jImQdUdDFkUlH4b+zpJc6sAXBmvXa0i4hMYzH4Bwk0BFhLcb86Ukd7FGu0usNmlta9AI4Hw7U2vND2QxXoyYJC+v5w4JJ5HB3Y/pdhMvbddazpQy3MkY8fQRPn1KkLpWdFcAZkceWrYE5SwuEriKWgcP2S8V68CyXVWPgf2BJ3UGJ1Zb81uThZ0JNpjwcLDOWjZ
 4BhAF1Dh
 D5dz5y2ileR3qmLZCbtmkGK4goUQwdVrxf07ZDAdz9WQoy8gHMXHD7PDUJaqT6M5IIJVQOvBtqjohl2oADIruHR686RzNxidHHH3Z42atHZ2ASDHIyeGBDCiEB2QzMOGMC3zoibzKb+LqdHFC1FS8hupywtcRbtVEC07cP0rt/FjuXAb0a6lYrgYcDbfdAE70xDcXdgU0Wo2DTtRElUFOzpp0YyaQNWGnYXRrmBK2ncATrX8wfshtACzBvmXjktQxSG/CxI2vNMWKar0ZGETUyODhe1U0tkdM8Zi20igolMhi/anr3C+e3NFQ3x8dPsedmy1LOoFquiluEuB1P91DkqdONUYD4TtXmQarasQ5jhNioPeEr1I7RgEDWB9fUQRrtXk+uQdaot+qJGo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a dedicated test at the end of main() that stages memcg_path via
sysfs and verifies its readback.  Configure the memcg filter before
start(), do not call commit(), and ignore start() failures so the test
does not depend on CONFIG_MEMCG or cgroup layout.  Call stop() for
cleanup without checking its return value.

Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
---
 tools/testing/selftests/damon/sysfs.py | 31 ++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index aa03a1187489..35be32cf49ac 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -250,6 +250,35 @@ def assert_ctxs_committed(kdamonds):
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
+    kdamonds.stop()
+    kdamonds = None
+
 def main():
     global kdamonds
     kdamonds = _damon_sysfs.Kdamonds(
@@ -356,5 +385,7 @@ def main():
     assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
+    test_memcg_filter_memcg_path_staging()
+
 if __name__ == '__main__':
     main()
-- 
2.51.0


