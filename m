Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B49CC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4856B00AF; Mon, 29 Jun 2026 10:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CD16B00B4; Mon, 29 Jun 2026 10:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9B56B00AF; Mon, 29 Jun 2026 10:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 260B76B00AF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:46:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9ACDBC0397
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:46:57 +0000 (UTC)
X-FDA: 84933227274.16.3D09B7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0BCAE14000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:46:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QOwTuXTP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744416;
	b=rx2wsuBKPOr/EXdXrKctGDdrJNYmhaKMmJncZp41fRqZrl3aiZdlTtS5PpQWUq00SRSAQ4
	5vHg7JbrYbz0uj/6/o/x0rCwSFeaREOnjXJNxYqNdLFSl/SQ5znb6MiQhn5raWgCke1Aez
	QpnN5/dBouFlZctYn0sm2mi9Xd8fw64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHqxec4PhlDUhWE2hLe0q51Y6lQPE2jO7NI1DXylRHE=;
	b=pNiNrsT7hpcUcSLYrR+CSc1od5s6fygxEf3G7+f9DMYkdVI6ENktWPkIkrZ1cWNI7Nt7Uf
	eiTcnvTKX4rON/WTgChbPn9seogNfxqfcuWe36rfm0g5hT472EVC4vzUYmvMPxSM5wuaAg
	CJ6kVrRbEBUvpqXUgg3lLALwIWu0kIw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QOwTuXTP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FFBB600AB;
	Mon, 29 Jun 2026 14:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F081F00A3D;
	Mon, 29 Jun 2026 14:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744415;
	bh=SHqxec4PhlDUhWE2hLe0q51Y6lQPE2jO7NI1DXylRHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOwTuXTPpTxb5syY7JY+vsfPfzUsyGM86BJofrBwkokGpq5FI+hTC8foLRNfxcwgV
	 Z9RZH91thQZTFrjaWBQ6t7PnVPhElSuARxW9HQwesSuM7G9y/azD7Iei5hY1OuN+sa
	 EYH9tYOrP1sr1bHW0eEN6JYiOvtVGjVWaZfq37mvV/5Sef1jDPETtl/k45HscxdD8G
	 J05gLP/HYHdZ6yqQysboyd2Wm8h601wvyNb9voDuH9pCLnQ0bULvqO9SD3rY5THSiy
	 jm+XmhGQnT0s481/D1SYFyc824A5UGXnSTv/Agj6MRS0w01adjSdXbPrmXpOcSOlQS
	 lLIEFdhdIQE6Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kunwu Chan <chentao@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Wang Lian <lianux.mm@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/3] selftests/damon/damos_tried_regions: fix expectation output and join TypeError
Date: Mon, 29 Jun 2026 07:46:45 -0700
Message-ID: <20260629144648.134092-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144648.134092-1-sj@kernel.org>
References: <20260629144648.134092-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0BCAE14000C
X-Rspam-User: 
X-Stat-Signature: ton8jhx6ih5wjziyro7o77ajnc3se4zt
X-HE-Tag: 1782744415-574084
X-HE-Meta: U2FsdGVkX18RQZDAFvy0eOJZO5i+2rc+t4BbK+Z5WvZsDc8s76XQaeG9rnoaio52ngMaQPrxIOA2YLoywdpho+KFmrNR0WYiWTkvkSaW9idF1bjktVFLeM1a2l3x6t3jXReZT798IndQjcAUnb9u6SacJw89+t+1SG6+L3ska2EkhR7/m0xUw2gQaKWNflg3q9azjfL2bkAuteJ9EPFZTP17ZhQLuNFNAK+NSuwTsz+Vu39+obPj7NQ3Gcie8jRIEU77+GjGWRpdEjyatNFJ6wXA+d+YlzR4pE+UJmJ9U/+vvFVTPvai0I103Sn8y4dXe4SLRWnS+rIY0MQ0pvuM2X7iV2C9rWaCOxSg2ow9AiDLQodCFgBItWaAp9h9mgJq89+S1b0Db2GD6KKGekMjs42YjTtjzohl6LG3vLoOm5qV4Y5w5o6PeYjhZ+PZcVp/haj8gi8cVktme9D6zjrN1E2bC+JoqmLZoxT1YzaoV2o6+Ezu4WnpYfMCV24XDTGM6DpK5LFuEtQGl77t+LcSsx5v9QhOUhZamCZHXKwVOqrDsslmVb7Hf356Yk44ylRZWmK2kd0GtQzBcbmozWpBi9Y6Fi+jYBjB7YmlHthAVt4hqKpSOKZPy9IanNB+V5C5TnMRowy63cVmXJPLbsKs2ZWSRSkGAd3CmoGEGkXPxKsUsxZhqA4r1rm844SJbCEzt0fiqoUDHAza24RD0W6+eW9wx6bND0LVwdesHJNocC1CPkpND29nPoaUSQCgHkVO6Ph0ySKYmFjSQKWVPmqxwlT6KEW/rmfm0zkUX0S/MfnTYoDVi8i1lnzYGVuLTs2XnmjZFDh+0QMtB2pTyta9nszHWg4NnsEKlgrVW5WOZldKtTA1nXUL04vCD0I3+VmVPWOYc8P67+JT43PgECyvDK8BiXjxE+PBqYYWCMHowlPuBHspngP4yqGmGiW4wRiDGK8jG3PXuFPsjXgF5em
 S/bkl7Pr
 hwVdg+VCN6S/GQFC4D9ePlXAwuK/PfN/0UMg86UM+0V3h0DjXMzi8AeuYqxRJpVgCx24ITmYmzGe6qmaPGgmVuvp4E/10v9mlnHfoAoLxiTZ5lLUqW4w4Jwi+UHWdIe+gT4BVmG14iMuw2sY16qWjF35JBL0XHrFk2GgOMJ4J1NbAbmb1YGIju/V+C1JrypFOOV8Pwoh5Cxj0hub8gQ0JvYJjTYvJvtCcOXC6RpvWcszcighL8Tg2S02S4H6w6f6YcvgFiH5rQAh++/Gi14dJHXE1REbFfqn4s7LzuvU5ASuZqVpg0/jJIwHai2DJkL4uopDoigGBf4ntTmuHWqeY7I+Nwx/hqVyT7rip8+IUob7mOSnK58dzoLom8A==
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

Link: https://lore.kernel.org/20260601032314.424013-3-kunwu.chan@linux.dev
Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <chentao@kylinos.cn>
Cc: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/damos_tried_regions.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/damos_tried_regions.py b/tools/testing/selftests/damon/damos_tried_regions.py
index 3b347eb28bd28..d6472e6a6e082 100755
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
2.47.3

