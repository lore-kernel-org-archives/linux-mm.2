Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41ADAFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690696B0092; Mon, 27 Apr 2026 11:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641036B0095; Mon, 27 Apr 2026 11:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557366B0096; Mon, 27 Apr 2026 11:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 45DCF6B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:34:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE7CC413E4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:45 +0000 (UTC)
X-FDA: 84704677932.30.793E1EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 124C5C0009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uCWPs2TM;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJistnFWnDMgPen+vzENlGukE6NrPtXcqWX8OD67mjA=;
	b=dIqMKcfmW9KNHy/YdGox/dP2nTNFMT56kdBdCLs/WsR9BJQ5hQBf00TyzaywT91NaxKWaC
	gfNFskX8JS/tyqhm4AcNODVP/ih7ZKxv/Pb1es8Gxf0/q471wzacylQqwBqpn0wBmjHlwU
	YLrICIfSu8GrI0otITdJDMHOboN8scI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302764; a=rsa-sha256;
	cv=none;
	b=ei8K3jsGsuDLm2n1hdw5ZJLp8pQgkO/bTYy6AAQoIlWvMONGdolsIl/dbZFxzB/POuudUP
	ZO076Ep99Ip288DJWeo7f0hTj6Dr9biDt1pr9LMVeyxKYef0Ji8v+2qBFeATivyNaVfdub
	KQkrTuewQogM5XBGXJKWOCbIjFVm1ck=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uCWPs2TM;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E6BD60154;
	Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ABBC2BCB5;
	Mon, 27 Apr 2026 15:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302763;
	bh=K+t0IBDIG7HXVVaXmRTS++wFYmoNTkKzAJmGYrkNPTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCWPs2TM/QVNIYTw3lP/RHTzg9Yz1/1Cw+itnweALv+X3+zIaJmnxAIV3CfP0ylGr
	 svSJBCH8uK0Rfec9YrmuFCfVNHPzMol7N8ZXJP6Op3aMBy4vOp6vtb1o90yy7m0niQ
	 Altnn9BQKqlSSArXo3TKY7TuTdTNzXo4chdh5jXCGQGIWTq/lIoum56JO33rbOn/2k
	 GsNUvZUoBmwpPoM/+8QFz1G6GA7HgIK93xeLTNFGFSjA4cXUznXdALQrFnfuwN7T0Q
	 cm4eQ9yaDgxEq43NC05eahxFbXliBobfzw1mcZby+epevwhB1Ax+ZsGLMXruVsSnQy
	 008KXxX35ngMA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 06/10] mm/damon/tests/core-kunit: test pause commitment
Date: Mon, 27 Apr 2026 08:12:25 -0700
Message-ID: <20260427151231.113429-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427151231.113429-1-sj@kernel.org>
References: <20260427151231.113429-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 124C5C0009
X-Rspam-User: 
X-Stat-Signature: ojg71iw5hxuknjzohaw991u46qyu8uyw
X-HE-Tag: 1777302763-491984
X-HE-Meta: U2FsdGVkX18jGdY70vRrLRleVaCHmPZd/yW9IuPgFdWNmJZUOaOa+ACwjBa+nSv1c9Lhn6nUtz/vB1lrVNQB3rlSwqgDPLCM+QUmgp1bBqsZ7/gNbk29+FVKJVIBrVRSggIII3SkMneQ6tofypz5NHtZTmhVrqXHyRoZLMP4ejfFNZRL2WKUJud1r7pF4PT29qz7bWsZHEo3LpMrgybDBBe6/evKQIFqt3ba06dcfBzJb1/YWGhAzknKwrK4rQsVtcYXC97y0Rn2S+MynhcrU6UEdRSezYmcH9KjYxlTpQW6RQdnKRvwp+xCjuWzNFjvyn0yU1eVlQUegxUqvjL9UdHAFTO9BZpdq2QEgtCAXnEanzlUJDfir0lKFVJjmvr/8FA8+ZiQMlF2lJZfMa0LkLWyJw3FxkukC/Hjd6n0H4oQlLSh6ByM7XHIB0gkddpcLcWFz2H+n/L2tAg8Nifm9ctypKvu1aC5FcVzH4bWlw+LWTwkxgSHmmB5i88HpVSycFiSO8UEdvWeVE7Wv8vesGxUtitjGBJlgYetqmbql4VUwC7xJPt+HDH2Os1gBsH+IXe/FKNjXZWVZz8+TAfMB6rZUFFz82GoSeqbAkMURyYpCiuv0JZhdiSzdBLMOscaEyAiUZ9zUoUII0c8w+MYVTam+edGIp1JNGCrRVdUE3Jq3hVOdPIA/XzS4rpZCu2JJ6FzhvZiIa59LDhUJ6wXw+7rcRrTR2oEGbpBMdcxglL2ZkYCSEXClIVc0jTGmEYUm5wNp3BJp/9RYsRwy/1ulbP6sRn0CFn0VmjyhvQ08zLU0hYxVucn1g6wmIPBMGbeqKUxbbEfxwqvKEjmKaL7pVQUaZ7pNzJbije8RSB36bIVIs7hliGi7ONSXRk5bfQIBWXzDqURuiFjZfOdlfYmX9/mNyZ3itlnuP+w9EnGVGpx1r9lDUJDcVN95XHEGXONdD8qWLvLzZlJ6hAcWTA
 Ikm6qXc2
 qHNFwUokik6wSSzL40+5CMuPCVGIP7AUkcdP5+gXuca4B1zc0ugPDdGeMx49zTsVVgUj4GsFJwSEpFTEZT87XyFOj7gQkQwZrRcubyFJlo4kuqw5imGLdrC46frSq1wAhLLQc1fhTIQpmMyW7qKnw5zqAhC6IQNQSlr95yfTMDRu0hzKQTkolKfimjcXhv87MsQbmQtXZgBsWJshw4AMC5gazfTsBb/5KD51vEqDprPaDz1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kunit test for commitment of damon_ctx->pause parameter that can
be done using damon_commit_ctx().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 9e5904c2beeb2..0030f682b23b7 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1077,6 +1077,10 @@ static void damon_test_commit_ctx(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
 	src->min_region_sz = 4095;
 	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), -EINVAL);
+	src->min_region_sz = 4096;
+	src->pause = true;
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
+	KUNIT_EXPECT_TRUE(test, dst->pause);
 	damon_destroy_ctx(src);
 	damon_destroy_ctx(dst);
 }
-- 
2.47.3

