Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89675606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DlA/uZOO
Received: by kanga.kvack.org (Postfix)
	id 8D2926B05B0; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA4D6B05B3; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD636B05B1; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC5C6B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8431C02F8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:33:44 +0000 (UTC)
X-FDA: 85460125968.08.394354D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 39352180008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:33:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DlA/uZOO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795289623;
	b=i/YSIIyksf5VY6ZECidNgY92taEjRtNBXqaqGDOteLSLudzDL7n+fi1tXVQDj+5xSk/Dla
	po1ZdRcDqT10dfarHWIAvplyTLv0wYBf98ht01lqn4f24uyevyrLC9N6b3kU5evqHaE2WD
	zcuGCFjm/3gFtY60/+zpoh8bElZLHGI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795289623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2qZsGR/sLdn0qLTF/VW/uayeEPi0hmDXZwV0zU4xgig=;
	b=IX3eov3IEqFiYlxaZUdadfDobk0NHxGRcbzM4No9R+VlDZGkq596tDkEx4+qgXVnBUw4GO
	tcjkrxm1i3PZZrcH55Zg4CknD4oVH9HLN0FhZLKJQR3D6UBY5wa10gkr840b3vioefAFjT
	zYJj+Fr0GNRwQGXbz+MiHAlQl1gKgP8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DlA/uZOO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFE0940A99;
	Sat, 21 Nov 2026 19:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438C61F000C0;
	Sat, 21 Nov 2026 19:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795289621;
	bh=2qZsGR/sLdn0qLTF/VW/uayeEPi0hmDXZwV0zU4xgig=;
	h=From:To:Cc:Subject:Date;
	b=DlA/uZOOmMwj7/yI/xq8L5MHTwnnPePC4ZNk7K9kI5dR+rAmqBDBa6Qi4GrTbRGhp
	 b6b6Z16CZSWJSduDm9o3gEa+9WynORueGdk4d7m9cnhb5WDEvaQomnHTyOScvsn0v3
	 S5NahacjGPWEh4dhbPtF986GYgcAc6F6EVU3pTY4+78vDMQvgKqOjfKCUxmFgJN4At
	 4yM1aLJcfId44XVngK5Ux8D0dcSbNREpsrtY5npFjaLu/pyT0QfCDyz55mvyEGUG0U
	 aFuAWQK0IbZuOjcw93+8XHpsHdo1Wo+QgI0J7/8FhiqIWDJfO59/kkcran1pKRF/8H
	 tmIrDNVwEDPkg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/4] mm/damon: update documents for mm-next onboarding
Date: Sat, 21 Nov 2026 11:33:25 -0800
Message-ID: <20261121193331.108587-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n79izaqrwbwjy18p5kqsfykmseqe9kmj
X-Rspam-User:
X-Rspamd-Queue-Id: 39352180008
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795289623-584906
X-HE-Meta: U2FsdGVkX1+IFmCr3QiFdyTMxweJSXXGwykGvouXQkERIEbFIgB91cHW/jH0JWZ8moMhTidV+1vWM5dkIkOvvxnWLHR7KPV5KpRel17u6QVvKxx2ShEaZlOpSXxXLBb9Ll7FGCvoOelMFYLiO3f1ILy13cgjQLPQcA0s5utALcHTxrfAZqjw0vEysM2utODtqkvp1A1srxqoVDCuMCzIDJQFSv4BsB5zGjMtAI8axeix7WAohNLlX7qoapEhZSDV/TAjMffYfRpMNHrx/hJS8oWwVxWmtLt1LVmcFcas6kDZWWUqvTOIXV8xLOkJanUKh3B0N3ux0Xe61JmRrWA1FBHaZP9M5Cz6vlOZTOjXhIT1lTae3Foe5TIcUvfNET+GvBktk+aXw9qwlP2vJXsetzeep/StRXKwqjrF11Ibg3YAwfmHKmR959YOs/8U+VxXsBN1ZqfDjdjO8e3ZWCqprtdX+babUU3LxYxbAB4tmQRdVsTS9pLsl6btTEfDEAPXA4V2DEzU65EwuT2KBujzSU3/KVluYs5SiLrRMLFNeCrdSmngk9jdWcOTYkWjMY7qxeAm/8TIJ36xc6a4s952uz/Ofcrmbwky1U6c4a68xsjobInzCkVaSck1NInT2E3X9lK83ij+kt7XhRBOHePN/1W6/fyrOZ72ohU4RBD9hKp/aks0EtEpatiiOICyH++6Zan82PRg4z3zHtoJhgbEe//jSr2pmBQJNdD6ATwNsVF98yTtLjSUMNAt9o4FUQPmXD1Z8OXwyTvi2Q4/CjgkGks6lvHGYE+u4K12QSZs4xME16Ds8pDH+YCpZIOBoGyATTnboNw86519LFs5HAUjBRVvN3cRG3zFE1QSAYbFR+U9VN2aLa8R4Ssq40BJnnVU5AU/2+41s32IjtlnvEwXTIvt+2JME87t8NV21YuMQdiREZDcwlJ7cWJGLnrc5TiZtBVZ+WyLqwjET840q+f
 t8hnbFgA
 Rp+br+Wv5Ko0ldiTpL5FVpD3T6QObySyk7ekLCD/oFj6c4pyje9F+yEdyjq4WEIhIFlNRg3p9uyolUAzTPOHDe3x1tak5Lc9UhGfz/jkmU2YwJWWUnfkqhwKf4I0Lk9gGm5dc3ldMZsPSgR1c7ixvF03GHCeMOMXfUa9/o+0ZPK5bql5xx867E0LhJGr4LZNev40AZc8EwrAZJ7B7FG6m3j78O5vQalQhI8IMLjwOYRoP/K2i0k7i+5xmF4ZtgtUHWyaOfZCe1Lqum1POgv3LLQ5Yf+ayJda5qdkwAn90YL6v+eiECmqd0xJViju17ezjldtcxunqSoFknvMmbkFmTO31ilXC/h1rmkq9NOohC+vgCV6Naqr2vOy8Kqug3xd5KQlgFEzsVFmBeo1gbDr55sKPNOVQ4Go2kGPVigXjaa9arxf4HwpAYtCqwW5fput7mlyIAQAlvQVTrFxrZhpgvL9wLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Right after the 7.5-rc1 release, DAMON will onboard the mm-next
transition [1].  The major change is that it will use mm/damon.git [2]
and mm/linux.git [3] instead of sj/linux.git [4] and akpm/mm.git [5].

Update MAINTAINERS file to capture the change, via patch 1.  Further
update DAMON maintainer-profile document for the change, step by step,
via patches 2-4.

[1] https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mm/damon.git/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/mm/linux.git/
[4] https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git/
[4] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/

Huge thanks to Andrew for his tremendous mm.git works that raised DAMON
up to the current state.

SJ Park (4):
  MAINTAINERS: change DAMON SCM tree to mm/damon.git
  Docs/mm/damon/maintainer-profile: use damon.git for patch baselines
  Docs/mm/damon/maintainer-profile: drop 'SCM Trees' section
  Docs/mm/damon/maintainer-profile: update key cycle dates for damon.git

 Documentation/mm/damon/maintainer-profile.rst | 57 ++++++++++---------
 MAINTAINERS                                   | 36 ++++++------
 2 files changed, 46 insertions(+), 47 deletions(-)


base-commit: b0ddc1203e3d7a63e712e8988a03f98dbb179904
-- 
2.47.3

