Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A174CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 02:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A646B0088; Sat, 17 Oct 2026 22:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21BD6B008C; Sat, 17 Oct 2026 22:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37266B0092; Sat, 17 Oct 2026 22:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3F46B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 22:04:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E8DD1A0418
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:04:31 +0000 (UTC)
X-FDA: 85334102742.17.BB968EE
Received: from mail-wr2-f7.google.com (mail-wr2-f7.google.com [74.125.225.71])
	by imf15.hostedemail.com (Postfix) with ESMTP id 55A2BA0008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:04:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HcfcWD+d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.71 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792289069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xcLGhS41qDyrPASVGx39Zak2pOFp3aGzMbLkGewPdag=;
	b=4ZtKd+Ut/ZtPLL/8sR2DIpORYK/bRIm7fCg+GTY5+0T/VPYk4MQL/tc27EGafC7sdhCIa6
	A/zBfnZITU3jYo5rQSGqZc0Rs4/y3LRkU1NbKoYAFVu1dJGSX47n+EJ/52lzlzPncJlwXO
	yrWcI0VozjKbdNnhnV5S70luOeXujX4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792289069;
	b=PB/rwk3V+RXLUFjIANjbNWY72hJjLz8PLeou1HwoWpJGns0X2ocUX1JNgcO1PNF+dZybeT
	tgdjWo9vm/pIsWyvPt2pkr6B056XLd7rH+eNh8XtaV2EE6OJnCk/+DoAjR2JUcrd1PortR
	emNSpwBmmpMY2hrNR3z42Fji452Fgqk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HcfcWD+d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.71 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com
Received: by mail-wr2-f7.google.com with SMTP id ffacd0b85a97d-48c50db3556so513568f8f.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792289068; x=1792893868; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xcLGhS41qDyrPASVGx39Zak2pOFp3aGzMbLkGewPdag=;
        b=HcfcWD+dBKNknPOnxnLoy/G4hdUU7wJ1a5BOGpQbvnCrMAKq2/P/4syAZy1hf63lW9
         /lw7AO5QSeyIkiywGaW2801h22EenRqCVsLnjKHchK2p6Udp7D1xQBT0zJWGntVWYPY7
         YcbuxytmRSwTFQ0CeFRZCrGUCZRM12dksLaab+ljzi4OlFQ80m/YaLuot594jzWQytIH
         nQHbXOixZbmN3HWDrTE24REVQQWLGR3N6vX9Qv+Z2TGOvDUXOJ0YH4B4YVqVWkjQc9AF
         vYE9L4a7On8y8QUWFDP2UQQh9Nr5ZR5L63zua8T17oEwaoMn7CkCXalFi85TVAzEp8hm
         GMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792289068; x=1792893868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xcLGhS41qDyrPASVGx39Zak2pOFp3aGzMbLkGewPdag=;
        b=cNM6Ao06rkhTiCxvESwhMwdrKMcnd/+Y5qjFgBfQj51b0/IkR4rymX9wAIQd959MVt
         QgCAElt62F9RGrSFasMuuFrU1aNUKSlRH7tokzeqEklYcXyxf+Q7EfR9ngtwpnFP9Y3f
         nvwUBrk87IlUOPrSkakX6tFXXLxRY/tgslC1C/S5zNyKbTVDCH4gtljwAgDBkwYXgExC
         eaUmO1ISM0IcNncYoY3n7JgffqeQZ1ELKFO58egPyMe3fnY/wYEN+MjdClabujRd9bF/
         x25Rk90ZGlx3rzqT5ctq5Ly8fFDNqUc9Jd5eFTROozm/R4SQOvKVIYtns2ZMoRNsmOXN
         X1pA==
X-Forwarded-Encrypted: i=1; AKwUvBzK8Z8a/q1AYvChQzEwcZZ8E9mlFuO0jF2aoXuSFE8i8uS2DEc/QpC9UmrOkXk3ubFyzIvYiXIzxA==@kvack.org
X-Gm-Message-State: AFq9FYLkdBMTcnC6Ee5HeBAxO3du36cJaM7ZcUUgFX4hemwm5oDkVj+u
	Yfu0tS0WFLpSBk0tvLNYqK6ZPXcI+csYU+6uAUT958Eyutj1eMdKcZ8r
X-Gm-Gg: AYBFou3yftUuxkppCjRxMYuG/6j1dsbsdSmBu6Lu2OkBgPdv2IzP5/tQ460SAt2OaTD
	kr9FRBe3HOEcGGwVvuTSWvO5lYQA18q6FY8Zi63ma2mBJUalqOB1CVzEKUZ2gOMfV5FUd9ezF/j
	oU8VsRLzI1KQV0PBDT7ipLoYZpebIvGYiyXwnHfjiyWQNBozaejRX0KYDmf5dihdCvqlGTI7DlT
	VeK8uqRE1mk0cyvHFr+t3BQuo0xjbky+iwZv00Njn8dV8Q/u72pXMM4J2IvTZPeE9K3jlWYUa5c
	Gvi6R99sVbwIebIjgZptCJoDG58Bqo79HlMC3H9jlvOI4eRxdwpiZ2wQuQwug0LFoUgqLMV821M
	WXiwdCzAYHiRqmOk+QH7TNGTEIeq4arGIk1XBHdRDp4MmgAPAYLgfZDYbW4WSshZ0e8c8L7exQR
	Kh8Vdu9LHO46Qoi1nhT6QZx4ebxEA1i7gP43m3lRtMgbLr1RGbnMfiPiXL0uO1ksibUTD/UdPmB
	gsyXqL7Il0YKrRKX8+Fa4t23+KewSwWJH43Z6J2R+t8fVrCs3FbgArI0Z4ZWHmEihGyC7F3MQYL
	tLMTXj6yXIPr5d2NOioxzG7DnwRTdci3Jw==
X-Received: by 2002:a05:6000:4381:b0:48c:6955:a603 with SMTP id ffacd0b85a97d-48e07bb5a24mr8947014f8f.13.1792289067693;
        Sat, 17 Oct 2026 19:04:27 -0700 (PDT)
Received: from lima-kernel.telekom.ip (84-115-220-212.cable.dynamic.surfer.at. [84.115.220.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4e7ff1sm15001449f8f.25.2026.10.17.19.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 19:04:26 -0700 (PDT)
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
To: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/damon/sysfs.py: stop obsolete_target shells hanging the test
Date: Sun, 18 Oct 2026 04:04:15 +0200
Message-ID: <20261018020415.35567-1-jaeyeon.lee.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 55A2BA0008
X-Stat-Signature: 4h68jirhbtssydrn75hiqbfrjbtse3ux
X-Rspam-User: 
X-HE-Tag: 1792289069-649989
X-HE-Meta: U2FsdGVkX1874zefdfhRB6TDPM8vkiD8WP+AZSRYDKctPORhzw/RW3sFivF+PQ4hizKYr1o/JV/+K4XOPfyyYvbBSru0+n4RliaXeCutF0LLolb1vvTGeP3ORCFBV1tDsxjiHwYsNaF2O52tNPeiMovab0XJbUnPsIErafPzhregBtEGdtpHAfFHqXQMJT84VhVNKv/dq3XdT87j2tW9jdTZB+pPr89Dasw3Yih+edN1m5fincH2tcw1vN8AAtM8JAATpGfnAVgRJf57+0prUgaHob/VmpXvjB7nx707ZDScOubOcBLXqiFHUBgpNUoAoA/YCK3fMc1e0zxhu3GBpHWcedmXMrW+fCr9OeJ7BJKLgACmdFhjYT7J5l2t/9OAtIcBSu75ybq9OF6Q8byhEHrRv7oVf6Gn9wGJmmVMoxpBvuQ1nmMLpaOhtOnxrmfaV1c9bn63r/+7WLOyHoXTSWdK9cTh4D3HQfPYh40dc4th87umFYXpPg6E5n1GkRBl/GBSi06rLWW7Z60HEFZXnfJjQleaW3Hqxp+OhhJkzHxJu0ioNNEpiTRsiO5al/5zO0KUtDP7fMNhUgmwF9YPlpCBcQU6E5S6Fs4WXamaRuCAsP8kO/RAwpOCq5deQPQhzpc9NIqaHowYV2JufnxtKOmQK8Kj4suYwrRXmovADe1i7skEQcC7GvGui81XBP0rQV1ZEwf4zpiv+bQ6lJNT/6BCphr8eGv/Kv5Uwo+UfUxR/xXD5I/7LH2NGMtkZVVk8+WoonDmFi5Vz5TbYWR/e14aTu4gmnMAFOpqdhbVW5Yrkr/qm/AVC+UGtNnnV/mpwZ66rQVSt000QKXr7HSIotSwXmoaKI20w/axVcZkBKKTridCQwzqFi9dCMu4y1XrvRGrTKjOX4w4GLBwKHVe6MqUD+NNrFsjRQalIUBfSisDM3rgvVO+6aqOfN8MuuKSTGlp91hjJQm4UgbNGMn
 ea+Qy2Jx
 UdQKzAw0LiPVp1sxMBV+bRXvqoBT6SfitV4mT8zY0sDAbW1/sfbfmzQfuazyLV09PX/wCqFY0uq/3haTzbd9r74AjXyIrVskZLR7GLcwTr8QZIOtbpP5TSjXBqC+sHlzvruGUA2ylNOAaqU4kzbiCUraMQnzQ+pZcOY5ebq4fx0pHf6EsJazV97CEQtVtoTOrW300zKBD9RWwILndcvBVybfihnXqcOe/lEHVSz/s9pNswWuERxql6+ZgMFjTrrHdX1AEWCkSTNGj6EsP1p/cBjHrR9TRYB4dBuUFGmHUM3i8ZqDDXOmt1+LdycPVa8TTsQKtmPAR4WH6RzMiLcMc6HlRU/f7NVBX9BJbfibKFNxS7ta/pt6sZDMpqVHGhEXdr7kpteA0VYRe+2WbC3ymIGXxw3nMImFB5mFadSA5c5f2XnAlKYH0bdn0T9Yflvt+JetFMAEORnm0JmfRi/xZKHRnGghIOf+d5LGtVQKmutoJrI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The obsolete_target test spawns three 'sh' processes as monitoring
targets.  The processes inherit stdin from the test.  When the test is
run via 'make run_tests' from an interactive terminal, the kselftest
runner executes it under 'timeout', which puts it in a background
process group.  The 'sh' processes then try to read the terminal, so
the kernel sends SIGTTIN to the whole process group.  This stops the
'sh' processes, and also the child the test has just forked to spawn
the next 'sh', before it can run 'sh'.  The test then waits on that
child forever, until the kselftest runner kills it after 45 seconds.
The test passes when run directly.

Fix this by passing stdin=subprocess.PIPE when spawning the processes.
The processes then read from a pipe that never receives input, so they
stay alive and idle as the test expects.

Assisted-by: LLM
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
---
 tools/testing/selftests/damon/sysfs.py | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 66c826189320..ce54fa21c09f 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -390,12 +390,12 @@ def main():
     kdamonds.stop()
 
     # test obsolete_target.
-    proc1 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
-                             stderr=subprocess.PIPE)
-    proc2 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
-                             stderr=subprocess.PIPE)
-    proc3 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
-                             stderr=subprocess.PIPE)
+    proc1 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
+    proc2 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
+    proc3 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
                 contexts=[_damon_sysfs.DamonCtx(
-- 
2.43.0


