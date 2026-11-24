Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862B5606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDQYVOj8
Received: by kanga.kvack.org (Postfix)
	id D37AF6B07A1; Tue, 24 Nov 2026 11:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBF386B07A4; Tue, 24 Nov 2026 11:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B600C6B07A5; Tue, 24 Nov 2026 11:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4186B07A1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:01:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 147A2160BA0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:01:46 +0000 (UTC)
X-FDA: 85470478212.09.32C73EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5BE451C0011
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:01:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDQYVOj8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795536104;
	b=O3XA5XaVc4ZOSivSfk+XJ4Q347oxW2vhmfDxOkF+pFpzyoJM7BNePTuNZmm1Chh9lfyerZ
	DH4tR/3WLSYuV74bJ637PwJh5Cx3bHlb9eOFA5IGxFKIlK1FhtD8xmt2H3NBJIrPG8G/NP
	KtVXwB1Qz2t9ackOWO1Z6iWQXXfkaSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795536104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Du4+njXljVHpzEo98PHsfc+3ZjNfYApucHyMGQt5m7Y=;
	b=zx2jzk4Tr1lGG6uWsGkuQFFUDvYI4DejqTmpiGaRf9yEZTmgbZ4jjn7HLJygX9FhSIRmKU
	IT8UNFJ8fFQXY1Ug0SJOJeu45X50PnnP+mCTaDpLqcqcN7870CRIf3kkPBh/Q1Y3tHTMoV
	nWG4jLFcKVl1EzwZx1KqmB46rT5s37M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDQYVOj8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E283362732;
	Tue, 24 Nov 2026 16:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF121F000C6;
	Tue, 24 Nov 2026 16:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795536103;
	bh=Du4+njXljVHpzEo98PHsfc+3ZjNfYApucHyMGQt5m7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDQYVOj8a65hn2RvWgNho+NV+f1QlKJPQDCW2sH4q/NlWxK6rf5AziCUxH3wrCw8Y
	 opR2eOGEFMSX7ZT4I8Yk/h3C2gcYCaad1dYUJjCXeXk9hkhDszjXa4Ys7n2ljfFssL
	 gh3Q2wvezr7K+/ABgzDTpzc2g1mN8TWNfyvUloV0+1oo4rucKEs3MtCxiAqBzm0MKv
	 jFsI3ml2vSXuI238Kfsp4gRJHRNuvqa46AH89J9gN+BwLJj+9vAcykgWjd5ciw4taR
	 KLJzmQPr29VzEFemqWMG2/rhM6EFFWUFV9A3Yzx+SCXKi62t5CuWYkGbppUubvKy0a
	 uX+cEh+t0ouPQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-new 4/4] Docs/mm/damon/maintainer-profile: update key cycle dates for damon.git
Date: Tue, 24 Nov 2026 08:01:22 -0800
Message-ID: <20261124160124.93482-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124160124.93482-1-sj@kernel.org>
References: <20261124160124.93482-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 5BE451C0011
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tstg4ytjhwfc74pdgm53ujgxicxw711b
X-HE-Tag: 1795536104-964061
X-HE-Meta: U2FsdGVkX1/eObBm6Q/zgKcGgX9Mn40pb8kna6drwy9hZjcKC0uglshjhpiPvCbQ9mpZ3MYpkyHpEgw9Sp+SkAapBVZDhmFLwvy9ktRnwOst4RpRpRzrMUim6Bn8EyJ0AfDeGaTCuFeSUUgxqPHaLzvTXjYv6J7jyfMr59XCvvNumzFYFDBT+MskcWbce6V9E5sITtzVDGZ3igpe8gJsAlFGOpdC/mGdDf3Kz/7dhBBkn74yS7iJQxhJbzPYZ1nIaa1BGrFmXwT+OhxO8VLjcC5zcF4aGYA2/6P9h05ltpBrucsmdeQP38NZsr1akXYC74nPwIfIAhSLUtviBAzWP+iNFJtVmV+Phjm1SiZF3hktvuj+QKYKpuhIdIPQAZvkJ7M7GYToKXpCw8lsjdyJbPJKDvn9B6qFuKetQAR78K4sL2p/Sc20maZiIjS2849SHTyw7imQHZeZ0HMltGlS7wwekXBYFjA9KZtdlxHXRu/zxCKzQYg0DHWFSMU+Zk3IZAfaj3Rl4Xa97HU8lx2SkaN1X0Nzp8OVzTpxrZPzt22qHNscY5PX1EZUHoCRN0n2B3u1P1J782gJDlMDXGVpTR2BsvCy/5XGTv0ryPpxb15+Y+BFf85GnIlTIFFlhg84A4C4pbvT7poxsEu5QBlrofpicKINKmSOsuUIIW0p57mkreB8YRonaRA6MqyF1glDauubcO4zdIMWHZvRupgSagW6qg7dzIoUY+VfM6aW9bsB2dm3zAySWvJKkD/W71ElCwpk/ZoGQbJocL4davBoJ1Nv06wtmeww2a97zwz6Q7Amezfm1eus2iVQVfLR2IOvWiR8qoOfOO2HGn3AvnqQ+atEiDcRDCjSW0yPebNFGSrIEwCW2iXijR1J6Wnj9xZ9OqkUsIUS638HkfUOk0rzfGJSSJyi3MYiRLrOyfEBZvFoQxyY9+aZks5MsNHnPhdL4pXEDmCGQqAZBYEHZn+
 36htck5t
 mEX0q+dj//N3i5edvh5BBalnp7mD0qUGXpeFnBbcANGw+NjioNK4fX6XljHdwnOPE+tXFpOTvK5VdFgMX/zz96PpsoHj/MSzgIZ0gUhARRjkMMp5Y4Y/G6yJSgWuHHnmB5cdY/BID8SyMDADBYTmKtQ3Zx6FO9Ib+7/04/bNRYChXRee8Y8EN1PW+rFnzI5DyjikG0zVZRGcZuVyG/ew1MjGanVghvjc9uBsa+5VBphfSQly7cnAn6sch6YoubeEe/vYraY7b1JJHupxjQq8DTBlOL5ZyX9rn82U2qiMtLfJpYP3w6RFeYD4dFTiO5XJtD+mokkOpvRD+F0I3v0mWUNjrKqGA7E03lYC4htKjv0VJ0rqppLo+y8wlbSM0XH597QbAlDpuNhdQyHCsWGGbAyXdrA6/XNo3n7DrKjmU8s3nSqQ6G4tR77nvavy4rSO9iFuQnX+ennJO3UZktxlj/mkp0PDyInt1Mrk4xfNW12bObXM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Right after 7.5-rc1, DAMON will onboard the mm-next transition [1].  It
will make a few changes to the expected timeline for patches.  Update
'key cycle dates' to align with the changes.

[1] https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 24 +++++++++++++++----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index f9a8df2b11e73..75ad74b5b6e93 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -41,11 +41,25 @@ Further doing below and putting the results will be helpful.
 Key cycle dates
 ---------------
 
-Patches can be sent anytime.  Key cycle dates of the `mm-new
-<https://git.kernel.org/akpm/mm/h/mm-new>`_, `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and `mm-stable
-<https://git.kernel.org/akpm/mm/h/mm-stable>`_ trees depend on the memory
-management subsystem maintainer.
+Patches can be sent to and reviewed on the mailing lists anytime.
+
+Patches that are sufficiently reviewed will be merged into damon.git
+``for-next`` or ``for-next-fixes`` trees.  The destination tree is decided
+based on the urgency of the patches.  Non-urgent patches are merged into
+``for-next``.  Urgent patches are merged into ``for-next-fixes``.  Being merged
+into damon.git is only for additional review and testing.  All patches in
+damon.git can be reviewed, modified and dropped at any time.
+
+Patches in ``for-next-fixes`` tree stay there for at least one week, for
+additional review and testing.  After that, those would be pull-requested to
+the mainline.
+
+Patches in ``for-next`` tree stay there at least two weeks, for additional
+review and testing.  After that, those would be pull-requested to the mainline,
+in the next merge window.
+
+``for-next`` tree is closed for new patches from -rc6 release to next -rc1
+release.
 
 Review cadence
 --------------
-- 
2.47.3

