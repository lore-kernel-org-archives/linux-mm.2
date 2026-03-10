Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC34FCC9A5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899946B0089; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 805496B0093; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632A96B0092; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 442F46B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ABF1F8B8C8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
X-FDA: 84528360882.29.ADE1AB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EFD2D100003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iXPCHjCa;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fd/Ek0ghPoPRIQ3aDng4+3xojYiazBVEHEvIxZqD7/g=;
	b=oHG+xsL+1EGJqYp6mxt+pWl1JYUEo26TOT7sg8Nnd0hjhzYM49P13HgbRPNVGqCKSKr5gs
	BYm5gXsgnHg8BekEsydF4SN/c8y9po4HVw93x8p9LPlQUOq6XK8LGmCxhoptUJB+Uo0AsG
	9wWfhxd3iyKkYHSKDHM35beLnKhxuS0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iXPCHjCa;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104740; a=rsa-sha256;
	cv=none;
	b=wgQkeeT3OTOO2SIDOYAoUBvLOiMtkauNBKP4JY3pCAFPUVWr6ycmuNXeq5aPi6z1n+nrHC
	pOYL+2A4135+WzI6XEI6fGuIVTn1eYTesKx6yogAZfjoQtLBg9uwEZb9E/pwO/fd1R9iT4
	JIyEVcjDLmc+MCW5IV09oC9NrElsCXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CCDE341A0A;
	Tue, 10 Mar 2026 01:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41162C19423;
	Tue, 10 Mar 2026 01:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104738;
	bh=fBp4nXBnDNZJmCsR8X2jOaOiWLrxo+bveGhLd1RBkFs=;
	h=From:To:Cc:Subject:Date:From;
	b=iXPCHjCa5+tLyFlskpunswITojbf48yGauAKjSbwFrj62NuwQiBkl5ab9daUrxklP
	 2X1kd/0JilV1ueLI43Cv3BNm+lGeIOKI3FsKo+hLmzRv0+rM7pXUuSFtugeRf4Y2XF
	 OfmiZaQUxNBk3V8oxq46BlDhc+ZS5pgjtIn33e2pCJvRl/+Hj4BwzQwlz2mfXL6VCl
	 PUPmYRTT1V0XWOiDVoCVpP6ochcinMteWy/bdAVjdNsjhvta4zKM9/fYSufHuldPHh
	 /q7NqJVglcvPurW43Ktog1jrUjKonybv1CsYGG+D+z+ZbI1pLVHZB9jAzmxxrmirN0
	 N6JT/TQUN7c9A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/11] mm/damon: support multiple goal-based quota tuning algorithms
Date: Mon,  9 Mar 2026 18:05:16 -0700
Message-ID: <20260310010529.91162-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EFD2D100003
X-Rspamd-Server: rspam07
X-Stat-Signature: r4rkx9w844na81jx7zq5ugjfeah1pcmk
X-Rspam-User: 
X-HE-Tag: 1773104739-840397
X-HE-Meta: U2FsdGVkX19qk6hmSAJ0VTjzyG3wblle9sgk6mCOmcOOOE3TJDj5Xi0L2UQ4u2YjHvKIRxr6NbRbsq92LbSoBIANiy/goy1tP+PZIT/aEG2uEtM2JY/CODGA6uzZ8/Jj1zzCQFUNUFlXBgZ0MLxhqKy2B9vqdh6Q3luNDOpZ7S1hl4SE9vsv7YUqHF7MvMjANbgRtjvwtohfT24adexRSiJ5PwvqksmNSkJwuwmmygT9g5mGBlZzRa/qR+st/p/p7e9wek60cZUOVB8bV9V9pegxSFIHwHgnGl9oZAqjG2MA1aSp2rlToWw3/yeh35JP/0/NJzHwJVbhYyXxaI7QadEH18I9HCSMIJTSNR9zEB5QuNJTAtt6eHplCWDg1o2A0MRmKMxWH+qpfIpqOa303MNeipPoF5imQWcXuasoZmeZFLgFtgcgv+Qn3GEWmFknSGfjBCPmSaFwZXNdyZt0UzwfMSApI/MH7aonuoXKsBkYiJnTrMnPlbUF4C64IbxTJQ1P5nVsVxJKlmKWS5Ztyv8p5NNgML6Cng6xD102wNKEvJgkII5eMwRzYX6JiirxpKUP9NZfXmLVbGW9E9Z80G+7u74xDokQaRjx8D8aBtc/ThAIOt9hEk3xxLt2qRZA6Ik3kdnPQdOY5hJKg3130RwposI9CbXrPUgQpLjHYN2LSLoNGco2NlDSHukvMj9jfLhn6lTQ4vPiSrUzCTOu2oN1rxW+MhjIvAJhpJPPIP8UERGhECFvgqJo4tWiAoLlfjCobMG7kgR9irf3uPrAqwMQb+9mCncly2QDaRMga7wU+K3j/PSivNYVyGbFLKYzTjbsXBoZXuoNq2/y3V4d9wbd1KlLN5XMjCG+mgqyT2WU9FBNC9L3T4+5dosoChXWlnA32QaawIzei0lQ41D7zzrw6q6Hy37ofF5vHX0vmpFZuVt8XkN/M+yaZdTaYEjvhUnR425ixl+2Ro25Cyu
 L+FWoJg6
 4pLNk6QA9YfXjlUP9+usp82vr1kvX6YGEAlRYS2FGHE/qruyazOkgBZ0sNHVe4awdTOQCAdFcydrG32KjA0v5BENMTiKrPMFCU58oGNXkQZpXi+jwXltyK3L1vnOs3TNxWz3TTOnTolqNBR7dpWNxF/rPVUXybHvkLV+q1kr3qXiOvaInNp2QVGgyjWmomjbufejn8uoGEpKWtBdvjzj/8Q3Y9OKBmbdR9Joln72ManMb8VRmAIX9AdETe0GThP3A4fHRoR7xYMpcfhTW8AnZsm0fg0RFCuv/LLOEPlUNvRaRqw4fNTnvJTVzuWfJ7MQrMmFq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Aim-oriented DAMOS quota auto-tuning uses a single tuning algorithm.
The algorithm is designed to find a quota value that should be
consistently kept for achieving the aimed goal for long term.  It is
useful and reliable at automatically operating systems that have dynamic
environments in the long term.

As always, however, no single algorithm fits all.  When the environment
has static characteristics or there are control towers in not only the
kernel space but also the user space, the algorithm shows some
limitations.  In such environments, users want kernel work in a more
short term deterministic way.  Actually there were at least two reports
[1,2] of such cases.

Extend DAMOS quotas goal to support multiple quota tuning algorithms
that users can select.  Keep the current algorithm as the default one,
to not break the old users.  Also give it a name, "consist", as it is
designed to "consistently" apply the DAMOS action.  And introduce a new
tuning algorithm, namely "temporal".  It is designed to apply the DAMOS
action only temporally, in a deterministic way.  In more detail, as long
as the goal is under-achieved, it uses the maximum quota available.
Once the goal is over-achieved, it sets the quota zero.

Tests
=====

I confirmed the feature is working as expected using the latest version
of DAMON user-space tool, like below.

    $ # start DAMOS for reclaiming memory aiming 30% free memory
    $ sudo ./damo/damo start --damos_action pageout \
            --damos_quota_goal_tuner temporal \
            --damos_quota_goal node_mem_free_bp 30% 0 \
            --damos_quota_interval 1s \
            --damos_quota_space 100M

Note that >=3.1.8 version of DAMON user-space tool supports this feature
(--damos_quota_goal_tuner).  As expected, DAMOS stops reclaiming memory
as soon as the goal amount of free memory is made.  When 'consist' tuner
is used, the reclamation was continued even after the goal amount of
free memory is made, resulting in more than goal amount of free memory,
as expected.

Patch Sequence
==============

First four patches implement the features.  Patch 1 extends core API to
allow multiple tuners and make the current tuner as the default and only
available tuner, namely 'consist'.  Patch 2 allows future tuners setting
zero effective quota.  Patch 3 introduces the second tuner, namely
'temporal'.  Patch 4 further extends DAMON sysfs API to let users use
that.

Three following patches (patches 5-7) update design, usage, and ABI
documents, respectively.

Final four patches (patches 8-11) are for adding tests.  The eighth
patch (patch 8) extends the kunit test for online parameters commit for
validating the goal_tuner.  The ninth and the tenth patches (patches
9-10) extend the testing-purpose DAMON sysfs control helper and DAMON
status dumping tool to support the newly added feature.  The final
eleventh one (patch 11) extends the existing online commit selftest to
cover the new feature.

References
==========

[1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
[2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com

Changelog
=========

Changes from RFC v2
(https://lore.kernel.org/20260304044122.79394-1-sj@kernel.org)
- Rename damos_quota_set() to damos_quota_is_set().
- Drop unnecessary ->goal_tuner set on damos_new_quota().
- Add kunit test.
- Add goal_tuenr kernel-doc comment.

Changes from RFC v1
(https://lore.kernel.org/20260212062314.69961-1-sj@kernel.org)
- Add selftest for goal_tuner commitment.
- Set goal tuner inside damon_new_scheme().
- Allow zero size effective size quota.
- Update the ABI document.
- Wordsmith change descriptions.

SeongJae Park (11):
  mm/damon/core: introduce damos_quota_goal_tuner
  mm/damon/core: allow quota goals set zero effective size quota
  mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
  mm/damon/sysfs-schemes: implement quotas->goal_tuner file
  Docs/mm/damon/design: document the goal-based quota tuner selections
  Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file
  Docs/ABI/damon: update for goal_tuner
  mm/damon/tests/core-kunit: test goal_tuner commit
  selftests/damon/_damon_sysfs: support goal_tuner setup
  selftests/damon/drgn_dump_damon_status: support quota goal_tuner
    dumping
  selftests/damon/sysfs.py: test goal_tuner commit

 .../ABI/testing/sysfs-kernel-mm-damon         |  6 ++
 Documentation/admin-guide/mm/damon/usage.rst  | 16 +++--
 Documentation/mm/damon/design.rst             | 12 ++++
 include/linux/damon.h                         | 12 ++++
 mm/damon/core.c                               | 61 ++++++++++++++++---
 mm/damon/sysfs-schemes.c                      | 58 ++++++++++++++++++
 mm/damon/tests/core-kunit.h                   |  3 +
 tools/testing/selftests/damon/_damon_sysfs.py | 12 +++-
 .../selftests/damon/drgn_dump_damon_status.py |  1 +
 tools/testing/selftests/damon/sysfs.py        |  7 +++
 10 files changed, 171 insertions(+), 17 deletions(-)


base-commit: 65dad07b05cbdda486d599772f908f1df45dd306
-- 
2.47.3

