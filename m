Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 059E3CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B176F6B00A2; Fri, 19 Jun 2026 15:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53646B00A3; Fri, 19 Jun 2026 15:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9416B6B00A4; Fri, 19 Jun 2026 15:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69D256B00A2
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F154540534
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:44 +0000 (UTC)
X-FDA: 84897664488.26.63D4FCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6BB3B4000B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ny9+Kznl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBlT7kxUiLnizW5xmXI1w/7C7n4H7InmdeB786HKy9s=;
	b=UT6lUzde0Mt7okh6/vS7JaRquvuRTb4s2VNUSwutjY1483VtzV2akLdztSdxsdtgK/E+fn
	iVFov8XKWcYe/duf0ljpcrN4SRGZZVF1CJaacV/X1O6nQGeySG2s06qnKHWZ4B5CE1bC4t
	eqMjSsWMCFM6eTotXJbDbEqwzPkZgms=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897683;
	b=uiQ+UgZAxNkM3CcO1odXqsfm7zHOcpBqaHcpS8wzQHUffxsP0pa8wXAsnxi02ZXaBcAEu4
	pShjBgHiYch3BeSrR6Fi514v6we1IQ5mqS80jrrE3EBqtuj+W/r4YPobC/OB/gUKyQNRkW
	DUw9Br4fqkXtNSxRbYIfo5P8xHcVJl4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ny9+Kznl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B73B9441A7
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224321F000E9;
	Fri, 19 Jun 2026 19:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897682;
	bh=XBlT7kxUiLnizW5xmXI1w/7C7n4H7InmdeB786HKy9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ny9+KznlYEP6SchJflaCoUtX0tHqTw8X59gRCxW29e3y2GXD3eajvaPWBqRqmKnQH
	 UcV4l/LfDwxJ1qA4Ay5mqsiSzwdMr6IeZmKPsNMOMVbjtwl9+rsOVPojvSaHVIRTzk
	 J5fsWDLwZnC6MpCudVoFauMxnjPQXAAONS3moSabddLfuJxiOQHZnScWrrXtLI5QmT
	 OUn+ypavd7XqEILXFF0wHOCPiAzjv9pB7xdvzoD8NyFMcvIZRfy5alevPKlntSxL7X
	 lGsQsQic01lUfwSDwQDF0prZBZ4vekvoQZhsKdOZ/26a9ntu2zzqaQI8Bjck1HCl5w
	 fR34e1mBtc3XA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/13] selftests/damon/drgn_dump_damon_status: do not dump nr_accesses_bp
Date: Fri, 19 Jun 2026 12:33:55 -0700
Message-ID: <20260619193415.73833-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6BB3B4000B
X-Stat-Signature: 943dam8cc8mq5316b4mjh3hk6838xpa6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781897683-544974
X-HE-Meta: U2FsdGVkX18fXP7SGNbOb/d8UBE2j9ed0MJ4RiXsHn0GgklCKzCRNoCIpyiEsqSfn6AmebodhAPTDfIdNuH+VhXkL5/V0Y1ys645hBBOz3y+8/Ew03d81kR2K6MslT28aZ+Z6Os4qCJiCDqu8haoewQnTeALkIqNfczIpbA+6iikTDOEg9JPAThKV0bShO5Ho46EkZc3W9/diaH2Q1XBJSVLyC0Y5eu7+MFluWZYIwhO0RUm1u+cmGy8z2CrNGVp2THazfCcolZx28ci40z3Ld+snEHbmOVI0SZ+wKhi9rJMAy/m4dB4fa/AelFwvGsQlyWV/ffeVaqBk6W9RR7le8aClmWBt8bEuzjAkglhxpBhsZcte+hjbiiLRuhRY9rsI6Mh4fFi6FMqEIisZZ9xpKukixyoKyXdofIQbThM7sUg5nOWWNCdKuW0ZBYxT5758z8DxGJLTFegWqgW0DeXkyMxmHzyxS91InlaJjaoMepYAn/liwRIm0xFCR6S3M5S5AQIMttBp66bssXBgwqKKdO93BTCF05iPn8NrNlhC/bwBbNJIxJ6KpYv4sr3Py1DJLGBgwQLSQteAN3RK6vjwz/BhayPkTYsciiJ3hS/plcqs/w+xVAqnDJ9uIjNqrmzS/T6CrrgVqAbKkYW+MASEDOh8hXEYZep0h1JS9RjUXlWaAZcySdghfRUxVeSFchq75Uk6F7z8gBu0403SkD95cC6lgB8ljJIVTUM6a1W1mk6SUMuUPaOjLTlS7837YuGIxZoIV+nY6TurgpWU5QqQTEIM9mB0N+mYaNm4RxVlQ884pm+UW4bTz0Ka3fKa4H7fwvVzAyfMoWTuiKTSd1QKcuEbcbU5JEfJ8sdjOpYZnw0Rs/9yMPTBjfcE6FWteQx3ePNYsqsLGC67OQzw7pdLkAbAp/4QeRIhqLi5g7ar6wIMJJsvTfCxldPTz+pxoSZal82Yh8F+PERpK4cOnF
 +DBwXs89
 zs+Aituo+rgeLk0bBQAI33f0N61kjsZC7EseaxMJ9bwfdgpYI7dbh2P2ulqX8iKgpDA+KeRnmU8xwGY2/s0VkUxNUF92q9AdSsVe9Fw+6k5iZc14Ga54hKJqAeL9OMFPVq8uA6knEJr/qtXCoIRo8SJU47M/4GURmI3LO34F6hbI+eY3Lh9o1c1E+JG5P7OvO13gPB13lrvxFPqDfGnWsM6/7MgnSWeabdWzDkREdxu1pHdLxjf4WnBIFEp3PdEGpTkYywzTTK9I3Ft5vJdNRIZauTQ9tOQ4ryRsUs7S7GbKNHPxKd4lWQAcjkSDSN0GNojelexvhjdDRZyVayVypdGhtAY/JiMJbHPOA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drgn_dump_damon_status is dumping nr_accesses_bp field for future use
case.  nr_accesses_bp is not being used for a real purpose, though.
Hence there will be no future test for it.  Do not dump it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 26b207e44268d..09552e91bc782 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -59,7 +59,6 @@ def region_to_dict(region):
         ['ar', addr_range_to_dict],
         ['sampling_addr', int],
         ['nr_accesses', int],
-        ['nr_accesses_bp', int],
         ['age', int],
         ])
 
-- 
2.47.3

