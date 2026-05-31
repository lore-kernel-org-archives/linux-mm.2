Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0640CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174D06B011A; Sun, 31 May 2026 05:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C236B011C; Sun, 31 May 2026 05:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A706B011D; Sun, 31 May 2026 05:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE66B6B011A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:18:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC639140364
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:18:51 +0000 (UTC)
X-FDA: 84827165262.26.BABF4C1
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7A68C180002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:18:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I85kX9iH;
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780219128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pUXlvjUSNqO6nqpsnfmoQbgmo6bJELXxqIMM5q8DZak=;
	b=FPqpl3metv7E7CuDR7DnTAMHhITL/yeK+XZ4nb++TyCJtZaQ/+I4pUUNm8Fhv/NYmgmS1b
	Y1ljJJ3QFDEIdfsqI4JPamxtVt40OrvIYxMzx6m5Zv2aHd5/ZP5byrNYqeuk+u6UhzGbt2
	65sJG6ZZUbm/49KTq910GfkD4yP3oGw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780219128; a=rsa-sha256;
	cv=none;
	b=qsuN+jzZXxqUIARCWa9azosRg1ISgAa6EwWJe/gdzUJoeO/bXZJCG4TiKYP67yE5IBcj9H
	91Xeu3V+/buSjSJgCWG+i2+yQxMrmWwIzT9EDkYVMLGGdmHxY7ePd6SuOCNO1LJBDMSiXc
	bva6tsM5mBNAZ1C/+xBqlVxSXCwLhIE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I85kX9iH;
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780219125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pUXlvjUSNqO6nqpsnfmoQbgmo6bJELXxqIMM5q8DZak=;
	b=I85kX9iHuSB4rgELtUXiTKxp4LeoVAJXY9ZiGYr1JFPIhsY68s9PiOoNM8YX9CUag5u9qs
	WOhcmabCUD/dnIWkLMCpicmBHd4yclTqlOYvf/wfm6KmJxrs9uVDwk1xmLIuxFKRdU97f6
	4C/NRfHTqAiXngV82B0AoXZTN63E6Zo=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH 3/5] selftests/damon/damos_tried_regions: fix expectation output and join TypeError
Date: Sun, 31 May 2026 17:17:22 +0800
Message-ID: <20260531091724.84381-3-kunwu.chan@linux.dev>
In-Reply-To: <20260531091724.84381-1-kunwu.chan@linux.dev>
References: <20260531085633.48626-1-kunwu.chan@linux.dev>
 <20260531091724.84381-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: qtu6676p3tnpjguddwq3d6ogsi4zb1ts
X-Rspamd-Queue-Id: 7A68C180002
X-Rspam-User: 
X-HE-Tag: 1780219128-141864
X-HE-Meta: U2FsdGVkX19WCRMC0958Pw8C50QTwo0TC2b01pmqRM5IHfRvS3CCQuBooEzLkOhRt0nrZUXqIFlt6ZRBGb5tJmnlEt0wSnJRTiImF2QO3iak6l8WwhM8MfkJW2kK6BA8HRI3uxNfRYmNtWbMZhXMOfTf/oTShe5qmht3QB5MttXOwSsG7gk2mFBczmvqv4w8GhbMyPgq16ZbbDH7dZkE9aHXzYqRDdlff7INoMlUKqHQpx4y6ibnnHi+/CznjhTq9dscFI9fV4L5oTHwVzacA0RB84Em5s9qY4ujWTC/9JlVubiBut5wxSAXCj7Qj27t6DRdh4p/89pOEa9nOMloPB9PHfu2Lq1j8eET1m1WxlSd2ZqndaiNLOT8OdWQP75krBxjRXhFrP196HxChEVv3zrNcatN6OJtZVdb+EJBdkY2gEOdlRoq9Jug2cP8IgV3I4bkfwKGhFY/8DQlVujYi5U4fprKgzUvo8DAFMyAYkXRgfYa0ZRjL/efmpp4qGuANqzs6vbCb2FygmHc1Ro8IQ7U0lpTR+suv9kDnJjqpOLhjhUlXX5OoSCqa3wHb8g4TySIkhRzcLr53pZ5AU3ubSfBk5xCjrjOzOIKOmN5ugeyENfLsBujCGQ4TeU3/qLDS0UMDYMnyPsHb4Ot1n4C4CsjsLD9fruLj1s7GUeRk8kK9mSkM2rp/iSojTM5HQg4O5AuG3EIFkbPf/IjuciiQlrd+HIPR0GLzUjHZ8SPljYjhiXQka84MKQMtVccZ2DKatfuFfxkUXOGPAQIrsNFWobHaUElBH2Cqrg4zbIRSgBQgowFefqohq1Q2nJMcPH9lN7cuEPB8vIgZrCvxqBUZTnu/Ayqw+8H7HGEy07wT8fZiA93UuJALjOr1XEtLU+omwRN95JY6+hFAmHCIqDKPIdUiYpMpSK91eNXituoZZS+0RLv7+Mkk6kkJ8WfeTycZiykHSgqNgz9ePgF7Gy
 eNOYukN8
 DMwtc3HQby+uVe6Elw8UZ76LIim424Z/bPP5UI24Ef3GbCyFGzFCYKxr3hyX33EDf8mdkkqA49rjhqi6ux4eXQ51NHM1HzB9DgylobCvz/9X+dLqVG79sKU+FC0N9CXsdXxT2jl+Ue+Thf0zV7BQx6E/w2zoxsIBXxj4nzCR3iWhpOlArNQtFIxmnf51sefhGWCL/m9ImuScSYSvCTbMh1gNoJKp6+ITgRvOyDRm67cd41K1cWWq9UluR/YzAIez5a70PSRPhb+hCdCPvlCZJj2ckdaRInob4ipn3HEtJDYk0dRqZ9uijF7AEE+az/shIHRcwR4vzLjoXJzwuaRmaBUmLBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

The expectation print has wrong operator precedence: '%' binds
before the conditional expression, so the else branch prints
'not met' without the prefix 'expectation (>= 14) is'.  Add
parentheses to fix it.

Also, '\n'.join() on the list of ints raises TypeError;
convert to str in the list comprehension.

Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 tools/testing/selftests/damon/damos_tried_regions.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/damos_tried_regions.py b/tools/testing/selftests/damon/damos_tried_regions.py
index 3b347eb28bd2..d6472e6a6e08 100755
--- a/tools/testing/selftests/damon/damos_tried_regions.py
+++ b/tools/testing/selftests/damon/damos_tried_regions.py
@@ -55,10 +55,10 @@ def main():
     collected_nr_regions.sort()
     sample = collected_nr_regions[4]
     print('50-th percentile nr_regions: %d' % sample)
-    print('expectation (>= 14) is %s' % 'met' if sample >= 14 else 'not met')
+    print('expectation (>= 14) is %s' % ('met' if sample >= 14 else 'not met'))
     if collected_nr_regions[4] < 14:
         print('full nr_regions:')
-        print('\n'.join(collected_nr_regions))
+        print('\n'.join(['%d' % x for x in collected_nr_regions]))
         exit(1)
 
 if __name__ == '__main__':
-- 
2.43.0


