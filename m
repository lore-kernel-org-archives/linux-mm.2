Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA827CD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E166B008C; Sat, 20 Jun 2026 13:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43DFE6B00A0; Sat, 20 Jun 2026 13:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37AF26B00A1; Sat, 20 Jun 2026 13:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03E286B008C
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C615165B66
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:09 +0000 (UTC)
X-FDA: 84900961698.25.9102B67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 010EA160008
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bY0EmP9k;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBlT7kxUiLnizW5xmXI1w/7C7n4H7InmdeB786HKy9s=;
	b=hElfTcAWVfM9WDafU/HEq7cvnUIMQqOJabw0HquAp6fmgzcJjJ0GSHVyGp3R7QbTPAg7t8
	Bma5lWWHqwGBdWdHQCuy+NmmWdecz7yOc1jXdDd2yTTdfFKg9hKVfLXWIg00p9rSF7mtap
	o+r+sp27d2CZ9NgRRyYIWPryQ3PM+aw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bY0EmP9k;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976188;
	b=dq+IRGOUplvF+ctBhismJ/gQINPMOUz+PcHqteNr0/y657UZHLPngFcqtKmLuYpBd+8UDQ
	Qmc4eTzAt7FPgz2FTXVM0kFWizgsRfxmiJb7nYXCx3SDFlzoSihQ/Je8z+KoVkuNGCZqzP
	5exbaTZRUrpvKxeVOw6zxdzRCs7vGQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3097940823
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C37F1F00A3A;
	Sat, 20 Jun 2026 17:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976187;
	bh=XBlT7kxUiLnizW5xmXI1w/7C7n4H7InmdeB786HKy9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bY0EmP9kHKILCZpDoJ/3Zyoj2+PSjbj6oiY+gylfLmpCGMnhNESxUQbEWw56XJFXP
	 MOREufxvvgg2cL+WghgGR821aPum2ROYWCpD3VRxnDQEkCdNkg5r9Y2i7V2MD/hXCc
	 vvoowu/lh9mzLGCKrrUujNNDkpctYFTvaxiFJdy+Epx9S7UnPAiNu7ypkPjbydKi2i
	 FHKWR4qVbEN8hn6jRlDJD0s5DeSD4luNBZ6iyZDwFBtCUPTNjOkflI/p5Xr3DysFIB
	 ak0RgUS7CXULgbONJIFljrCY0yyZ5ZGSn1RU7IQSLuixM8mkT8mNL1/LcKIX+ycdSM
	 6qk7Ur93QGkzQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 10/13] selftests/damon/drgn_dump_damon_status: do not dump nr_accesses_bp
Date: Sat, 20 Jun 2026 10:22:40 -0700
Message-ID: <20260620172244.90953-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 010EA160008
X-Rspam-User: 
X-Stat-Signature: zmfs1grb84rmsh3soyduwrn4wt87xgq9
X-HE-Tag: 1781976187-200457
X-HE-Meta: U2FsdGVkX19tnCMswQJxoiBUWuf2hGBH6GBuDyRPKNujJA9IjYP8SfmvmgiUtcmzt8mGbLI3Tntu00CHT9haeglktEj7eA0hTz2z4m7mhHBB33nk6fG5SD+lLloQQCqijSHnRYcPL0VjaXJA3zZxDyJFXJ4saqrz2g3KMql0vkBPfKZE3wMMERAyl49kb6c6T0BxBaNmEEhaWn1J1pHQLix04kz8saSEYLiVwBlRQwg7lxtx4LcgxmJQqqRDVZfGzCYQdjtYK7gy3lIGMbuabEKyerLgHQleJl0zQeePJ89roB49p4LcnoZ5v/r4s41Y8QU4UOGYXhP03lEWI6ZDJjlmXfJPpsSfWwYXlDXsW3GZ3KRMUvHKPcvW0f6nKscpgHZv2gES8PpfFVVOpljlAP0U6H0oPATh69CqguQmygWxaE+KEL4VeNLwOjslBJdxGSJ485b9n5qmMMPTOUYME/Bfk4tUiwq0PqX+FfS81Pkv70Kmck6S/e07OMrEzGbehv/niYcbuuqzr7gYMwUcoNJ+0d5w+5jUYDv542T9OOr6HKnwVqTWaW7cOG0hEaohmLwVYSY+DUkWqmh3lHbmo1bALR+VfyJj92MDKFbevDcH21+tEzoYd7x5ofUXkmEK5lIqIsM1AvQHsucisyayrPPoZdaPteKCjSaiprAUftZM18gYAhSfK+Hbh5XbcCNoQ5p7uaa/l+QzvUG5/sZIFGHgmiQco2Fzs4M8d+/+r1VkeKL+u9JLGAZYsUIYYOlEbrl9gSU3FiWDRa/ejs2RYTvm2zL8Zc2O7tFt/zqsRAerEUQFKEw0vPQy3FQamcF4IGdj26RudaM8yzRzpQnTnLf0c9X9vh++teCh9X0/OXtNxk8TQUL2qLIw0ZeBjLMKSavqmJx4CInoyz6j1f90SxM9I6XQlXMlt2Hv/74oZVwLDQSP/wXUKD5Bkz2ATERIDz5NkJdf/URQglu6ufv
 H1e/d4fv
 yBxAUZX4ANYX+fgWcg3FXmatvmNNCtI3spHLvzDi6TocI926p18UZx51dzkD92IcaMbAxp8xhw6N9hQBw244aTBxWwDffFrE3lpkLru8zqpV9qUxAFXP+Vrq3+Ygrg9/TH9wFny9sjzNWdqVJGXEV1wLNgO+Cs5I5BGMuckZmALGdncp8OupkQZVzANYUl++80PDGxUfp3uNk+K97pBzwnYHZ/j+NOXwcNyvpIsad8hIgIYJSs+fg/YhIUL4GQP2KKCzYRiqB6UZi2Efu3fj0wLONPMQI33AniB2Uyp5tDgzpssTv7CeuQ/YRyr8J78ZTD+zv9I8caRkTKvjU2twwiIjbaHcikCzPvXro
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

