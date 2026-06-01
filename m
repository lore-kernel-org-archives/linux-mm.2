Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0187CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537656B0207; Sun, 31 May 2026 23:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F3D6B0209; Sun, 31 May 2026 23:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C126B020A; Sun, 31 May 2026 23:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3763B6B0207
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:24:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF40A8EB40
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:24:31 +0000 (UTC)
X-FDA: 84829901142.22.332D1CA
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B8551C000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:24:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H2xUahCb;
	spf=pass (imf21.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780284270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zaY8XSpncw1tdxqTmSy3mDhJYgUUKeHixcd29qyX1Is=;
	b=MMYcmNAgqAeG+3KP6vwlTI8edSp+lBG0r/gRA6oP2W4c2cW58iQTFZkK+5Rj4Ax9+r3O1s
	4co5BAt9nf4hqolQ8nffy4lO2/ePS/wPgKDH+K9snGH4zmJwdGykeYlilrVRFfhr0NK3pd
	y30YcDIgslQw4pG/jh6yTlirPAyLBFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780284270; a=rsa-sha256;
	cv=none;
	b=oNrlydbyrF88sawMb+E7fEzYlRPMoM/Torbf1MJ4ZccEl/Mfqh9aTd2+jIUsi4mL5gvVwX
	zCcvMtWorbYlCfWIos+tocBLIE6V6g9g06oisLsEhMNnfGhZxEJC9sDv5Dd4rLEAr0LPZh
	ooitHtDYZvHfb3WdpOZowr+WGmAeWes=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H2xUahCb;
	spf=pass (imf21.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780284268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zaY8XSpncw1tdxqTmSy3mDhJYgUUKeHixcd29qyX1Is=;
	b=H2xUahCbt1iXlMW5JNxoY9flDV8GU89RfU2uS/yDewhaLPy+mIOnA2jOK+bVt/MAzr8oL2
	JAFvuW7BZach4p1MKh9jxkcZxwCvtJGylilX4bEQSd3b74tpTw0SOVC5Nox8FJzlYN2IER
	jl16BfWBb7c9yi0NnvkjuwOBKG0G/VM=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <chentao@kylinos.cn>,
	Wang Lian <lianux.mm@gmail.com>
Subject: [PATCH v2 2/3] selftests/damon/damos_tried_regions: fix expectation output and join TypeError
Date: Mon,  1 Jun 2026 11:23:13 +0800
Message-ID: <20260601032314.424013-3-kunwu.chan@linux.dev>
In-Reply-To: <20260601032314.424013-1-kunwu.chan@linux.dev>
References: <20260601032314.424013-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B8551C000B
X-Stat-Signature: jrhuooob6psf7ghhkyf8onj4jo8p9wqh
X-Rspamd-Server: rspam06
X-HE-Tag: 1780284270-495041
X-HE-Meta: U2FsdGVkX1/wZUCdqnPPH4IhXMdS64PiIdbRq3U0XYyKqZvFu2eoJPxAyMsMH/cx2OR67kWrDDcJgM3oRg0dUZAHcIWQHuvpYJViPy0KykisvGa/A2WOD4nCDeSkbAS6Ynquu/hUXhtDScVTbqeEU3rcLFZJnur/zrTVoGG52+++D2J3TzdrMtyUQlgN7MT/XY9i4IgVCQvcH9fYS0eLtcTnQjx1Cw7j+Nu7B7gk+VftzBxMqZ+NXEGyR049w5UHo1VlTTWlBmUKliLivvYOklTF9Wq1SZUoqZo0XOrx1+TefDEgTNveXpsdSmhrKhcha+ID+mhIxym5bXLw+bORB5SVlBMrwwPRRTTmIlzrlSO5tb8lIOo14fz2mgqUPTeNc/zJCIqfXHGwgQZRVbcTzFP5CIVuEUC+i668Y7fWY7SwUvSrj16++BBL4f1VZ+TK/tKwAQPh1H3BV7q/bfJnI6C6/0n1VqqgUZJj4bBDlOrnDjpX8JxrDIxu4g2XjGRg0v4Wnu/xj0LOPh/BISe0P8waJGXayptGxqoQHCCgU3zWPSBPPYvlpmkEhfhwgrD/JWc1B7tGi0P5OHHal1Us4OC8S2n3Xal5yxY51krnuHpAOoUA3xgaL5/yyD1OKLeBGaudG6l0umjO00A2RVEBrTgI92NnficIiMjYS9C4tNoA7/9WGR8c5SX9YGyIa1QIxgGyKgDntsD5oQICgkN9jctqoiX2fBOZZb73e6MY2hzgCOSG9gBOZzr73dLi/GqIHakfG78DWJZa1Nz6gYeS0Q0R5NeoD8J4vlErDrkPageQ3Vk8ZzkZYG6AZ+aB7Rlb03WAZlOJ9n/VGgkNxyTo5DQnZ4sPoCPERz3QNHd6QHdCxvj3CNogrHU5DAPZCSkbzfDjj3yQZr7LYz0WyViyniuhDGgdYMOpnhZHEifrRowjgwW4ZbSIjIJJAGHa7tbZCVl1D/YKqDhcOtgQ02O
 1jqqg16j
 fH93whb+tUa4wOjBIEd3Ovnp/b+dqKREObFGEIku8vjhk7HxYSrS89+ZZ7vc1PqDYXq8URS7grfwMUthPyYjqrO2du5RQbSjvo0c0A9zT7y1gS0y+rmbXHitApt671Vsjmgl6m8HSkbhVzWPZizYaRghBvfc6Fp3DVRVG7uyR62S65nZzC82zNO16Tn+CyitIfHoXcNvgtZtdGKDuYd4mkUm9T4G6fs8s0Y5M+OxkbLlWDmfWk6rVjbxKkEYoPdby/xJUtM0Kpkr5uh3w0z0FnQPY545Mp7lLZLJ59EdK6lv1TduUojl4sVQGbZQmwnIP/KlAtF2CX5NykS8ZNx1NSEfFi0OXXp5PgyopD6sWYGlR4NQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <chentao@kylinos.cn>

The expectation print has wrong operator precedence: '%' binds
before the conditional expression, so the else branch prints
'not met' without the prefix 'expectation (>= 14) is'.  Add
parentheses to fix it.

Also, '\n'.join() on the list of ints raises TypeError;
convert to str in the list comprehension.

Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
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


