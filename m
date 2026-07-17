Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08381C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B23D6B00C0; Fri, 17 Jul 2026 13:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662A66B00C2; Fri, 17 Jul 2026 13:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52ABB6B00C3; Fri, 17 Jul 2026 13:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 219676B00C0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:02:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F3D61C007B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:57 +0000 (UTC)
X-FDA: 84998515434.03.3F07357
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E4535C0010
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Npu9wM/T";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784298896;
	b=F3okYHb7rmmNeryOMTXUvsscZDmEZRbfS2DBN13IRh/+1sxRsY0PefEf0O0Lgk3rCjG+TC
	5b1tqYESyP32AYH8fvzeqR0kAYnKiiZob5b5Sz4MSs75W8/iX8fioaBSDIVc3eqX/0SA8M
	qaHlzV15848+m5screkmsdRPIbyuhdM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Npu9wM/T";
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784298896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuPFx8TTNBzLXDK2qKBdCiBzn3J3hO3HBSaJVXSFOsw=;
	b=1Rf/ntxHiUJ4J2m60P4LDDUuLPc2qpk5usXDkh54WeMCEJPsrtonrHWCVbhS4KPaUw92Ka
	KmXqNUJE2dGRNWomsqRxsTaRAgqDxy7eM2PGBbPTWBbE/NC4Ll2cANhOQEATtH1twthdVw
	utCc+0dAYsh2SQ74PMZG4kGVmzlWRgY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 34C164356A;
	Fri, 17 Jul 2026 14:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27521F00A3D;
	Fri, 17 Jul 2026 14:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784298895;
	bh=VuPFx8TTNBzLXDK2qKBdCiBzn3J3hO3HBSaJVXSFOsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Npu9wM/TLqqMdaAfSdeHwemKOKxjfT9xquH/SBQ26zMAMOE0gMCtf5t0szwG8Esb6
	 poykFcwsr++2y3b61XYNM4ZtqCTntwWmry6eL45jnAM9cacxRqDddpe0DtP1L6h2kb
	 Ox90FQzu37+vqQYUTEkt3oD2W3I5KlGsPqsrtPnrmuSuxEkXB81yTLuCTKo4joNX5G
	 UrsHYdslhn9ry++WIowcwhKq0o1DjvQfjyW9i3nB08avw4UmYX4a72eqUcS8NJuKE+
	 Wnek6HrXSIIdsWTYk+j1sAgQSrI8KKEgmzsM3TwgdXi6VSoS8Si4LFTC8tf1v9DHlj
	 ni1I80XOT1qTQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 5/7] mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()
Date: Fri, 17 Jul 2026 07:34:42 -0700
Message-ID: <20260717143445.91207-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717143445.91207-1-sj@kernel.org>
References: <20260717143445.91207-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4535C0010
X-Stat-Signature: o8ii6f88sqx3up46ez9a8huem99kazrn
X-HE-Tag: 1784298895-696168
X-HE-Meta: U2FsdGVkX1+t0YNQ+C1KtRiKe91XqqLXd/2CrHd+T74gPRpcddS402P/Ntr2DYpgrAxenzArrduSSyZiHfj4TWi1FwtifX8KVceIulNqeJwSBVkqsH6MMOJw/j3Y8+aNY4CWue7Qyi42m7dDDjZ9xEHL2ytpDdTL63x2xDgcQMsmnxEHPI+CJuYLWFBEfEpCI7ED6QGmXUIxXwXgqfO+kwrPRejpZVHQ7qEEboaClGgF6DJUPRDvryw63aHxW1eYje7Jz9VdBmWF+wQjWMbfXf3tcj3tzJwSEIwOWm+yvaIoNN7KcB1I01FmNyYxuuCdGnRpozpws70bxwb2jDYV5oeDbhTuVivo7+bdMpnALUaIS6+sydL7KQqWN3wKKL4fflt3lZtrRKFa5nxoVcAzI+y68xQXh/hYsJx21n8pKeLWOkhjKZFwNWAUZ0URYd0DEw3Y7DEavp84ZfqUt7sJE/ikDrxuIZ8RV1kgg0h8yEeM9If9sKn3DwFEQUZkKsSyxZyLPmnFgMdOofe4hcNg/MS87GSa0eYnI+CejEo34zzoS13k4RSSmBfGhAuTUAYmzMbfcQRq8lzKXHNX4AW4Toutu6OBJgk184H0v9RsUQ1mBOE1bbxnoHZHmfylczFkMIBHgeVyFZR6FJ9kCgGRNSFW8gQsAnuTd3wZr+bIsBGLb/8d6oMQb2G0KnIa6ssPZYTlKUO8L11tfI0Y9A+539Xuxrewby7TQZfM52VjZs0gZLX5exfuB35cqNZz5T1q7hb9WOFiNlytkP5qi4vahD2i1x+79H7e6ZrOxTv39Wb2fUQawMAdSiGxG/dspIeipBMutTha7fwkCHbBSqMPAyUvtaTyIBTownnYoA8t02HnRmfP+5EIt0OFA9umQZXa4+x0VEoUylVhYTR632Bf7r28O4pk79y6vGoatZnht2E2YyV2Tx2npBkqZvuBsr0juaE/hVAj56y4KjRLPz8
 GP2aex69
 1g6GCBMd/4H5jUqIjpdvR1px50ZWL5doPd+Knowp/potSVDUVX19AIVvmPgt7Vgwrtu95VUbg0rz1/h5mhTWGU/3Kpgy3WSeyRLfx26IJ2VUg43EAXkATKxT/kWD2ShzGXpbAVsJzvq3BkG5H08c4nXl18kNzF+jBW1tKXVaTpo4FFgIgogOKbzHvPNn2Eb5m2Mjn9s4Ck0yDWIkwO2rGOOPUBRY0JOVU0qwycguXAS3zoGvVPTG/jz7iu2mHTbGGfYBzJmY++IIW0RziGYaEZVTaQWbo1kpS7zh1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_test_commit_dests_for() traverse damos action destinations after
damos_commit_dests().  It assumes damos_commit_dests() made expected
numbers of destinations for source and destination structures.  It might
not.  Because the traversal is made based on destination struct length,
it could do out of bounds access for source value expectation.

The consequent user impact (out-of-bound access ) is quite bad.  The
realistic user impact would be limited, though.  It would affect only
test run setups.

Fix it by exiting early for the number of regions test failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org

Fixes: eec573b8dd65 ("mm/damon/tests/core-kunit: add damos_commit_dests() test")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index eddf3a0484583..9b8c20a50ad53 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1008,6 +1008,8 @@ static void damos_test_commit_dests_for(struct kunit *test,
 	skip = false;
 
 	KUNIT_EXPECT_EQ(test, dst.nr_dests, src_nr_dests);
+	if (dst.nr_dests != src_nr_dests)
+		goto out;
 	for (i = 0; i < dst.nr_dests; i++) {
 		KUNIT_EXPECT_EQ(test, dst.node_id_arr[i], src_node_id_arr[i]);
 		KUNIT_EXPECT_EQ(test, dst.weight_arr[i], src_weight_arr[i]);
-- 
2.47.3

