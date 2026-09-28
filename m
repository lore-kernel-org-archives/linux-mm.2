Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27353C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FF06B0088; Mon, 28 Sep 2026 05:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D091B6B008A; Mon, 28 Sep 2026 05:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0856B008C; Mon, 28 Sep 2026 05:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 927ED6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:33:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20D79140163
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:33:53 +0000 (UTC)
X-FDA: 85262659146.23.90AA617
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A615D1A0007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:33:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+LRJZP7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kqde+SayCEen5dyr2tikRuBWG+4Rk7ag/e7VecDgxZw=;
	b=OhQ7Lhq1ob+RLYKJpIcMzOSXIK6hRO3mNHrGC8sx1sN/CVAJmuet/edqgeseiKs+PPLOAU
	tfG0z7HtJ5KG5elZ36rg6we8TKiz3fSH8sQH0MoamPfFe49IEN3I+vRqoHkXJtAh4hWPA2
	Si4vvqhfhia5/ppWJmmSh7JvGNLUs3A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+LRJZP7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790588031;
	b=Gxg5crsp0QVk0ACw2o8cfrKbphwobmev+Ot787aCNHVJlbVfeLHVJNKKehqfHAL3KFdqDS
	j7EpbjwfMs5unFl6GYateiUW0EFDuVAooxyhhTNSFMZGRLe0A4JLveyPM0W97rjlOjWxmY
	+bEAIzu1/4r3ebSYLqCkjkWSUGAUVVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2251460052;
	Mon, 28 Sep 2026 09:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6041F000FF;
	Mon, 28 Sep 2026 09:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790588030;
	bh=kqde+SayCEen5dyr2tikRuBWG+4Rk7ag/e7VecDgxZw=;
	h=From:To:Cc:Subject:Date;
	b=H+LRJZP7Bg8LClA3wWWTTlRIge8qXwjEuwm7B/62S1fXiuDlpeRCLe8xbSeaq3EfY
	 W02mK1JI+pR/6ormB2T/+FnZarrvYR2GNbixlWzx0kjqto8gz5dxMGEnVxnfxWiMzT
	 ZUKw1TmBkbQ4EeswrA0VcMxUMaaqetiupgD25Oh1FEhL6y5jypK8LsIFYS7kjD8QL5
	 yJ5b4QOtHnvRs2cLbw7oNGwDu21UK0pG4g2v32Ma5L0r3f5/o+xIQiDJiYKtN+FXg+
	 vvfJIW6faRsmM1AxgnNEzo8gTAzWTGjqjUoZllI3c4Eob/Gohn/LWruyr5N4Oo1xmt
	 xWkv3ZT8Qt2jQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [RFC PATCH v5 0/8] mm/damon: introduce damos quota goal target metric complement flag
Date: Mon, 28 Sep 2026 02:33:32 -0700
Message-ID: <20260928093342.16584-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A615D1A0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5oj96jbp4fewoww8fus9n8k69rizkdtq
X-HE-Tag: 1790588031-94082
X-HE-Meta: U2FsdGVkX1+ZlIqO4sExMkkqf7V8gSnEWI4AA6ybGCX5L0dy3GeIaFpExAo/lnl+LA5RTmWZB53FoXeZQP+VE9WzuAHfaH77mUy5U+2lvfYNrA191rkw3uKGkxCUDRsogeK2f6bkdpAhAAeQYjHmPy84O9XiWKjnXNuZItwJLYKSc8cVNbqQVxH9JqQg0cbn7kN1Mc3N+INYJGbBrkGbyjxusaDW5FHg7+o06Oe1t3rHHn8WY9EMwvCdCvCguf4IplTkFHzm5bm6NUy6drdSHkIha6cExzlN+DubxoKv9nhQ3TTpKHE0aGu0p5Il1kcJO7HzHzPSjoDD6rKFEbaojq36bZvQbhUNObFhigUhapD1IhGMFeEha07ucd0ZsnWWzE3EXWem95KsyGOqv9ogBuQh3e1LgyPxVESug25Oh+9EKDep/lusAJWnALq3vxcvJujXH4Va1nHlwHVo/luzZ9FqHUZk/otycG3r25/WFdsAPoI+/5iSFdF9SVmhPWuxjAzP/TUu9RM/1QW5ayffGZSCRDKalb6ot9TpF3CYzdpWvXfmR5FqWmjdQmbCevplvWhPvl1ZQ91cCUqON8+XsZMp9rSb7tnmgHGgCuVkdH84KwVruI6nitGqqM0XO5t+eNbBXP/ZJVr6ClR6g6xCJu+WKCqJh6Gmd48jTc7z9yZbXDcIEd3e1m1tTRbbGYisx5zxB71C5i7WuwHzZuvS/OcMNxdEDbvuS9dRJ+88Jn8Imp9/OSW4UUw26VDuUdY6fN9mK+3S9d4e0+NO7l18ZcrbMBuHKnJTLGVA6PjgLwbNVpT/VGpeNKO1cOY+GTXaBqcv9oZj1vjJD4rlatVBWM3ZFoq7KRFZUvXGWAyrlPzo2Su9nCK4UY3MCrVaMramBviw4buDEvKT4Bt+Yu1cGewYwdFCNaQriFktqvE80fPUz5kzL0CjcA73a/Fl4oXdzPv/r4xvWKvKl+VI+oT
 Rq3qcY/Q
 5DWRBlcfZrcMwkgKWOCP4Sx1FJq62srGBHfpyWD7M7lipYwNGicNCA6kV2HJGeT7isN7D/mUu/nKqG3wMnCqeFEMp4TP0PLZoJvBzUaYaa1sDVxAkUmPufpRA/g+yIljSWw6U0MGVvf/rmvWbBd78b369KBb2psYbBBaAy+Hpq04l8BJhD4CetYy5BHArJMnWjlBPFXlnO0/D3C9RoG30Aa/2NVtIbwGBaJWxD6pM2G9G9cjDMRqQSmbedWVGT3cGgtus
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Aim-oriented DAMOS quota auto-tuning assumes the aggressiveness of the
scheme (quota) and the quota goal metric are directly proportional.
Depending on the scheme setup and usage, keeping the relationship can be
challenging.

For example, let's suppose a memory tiering approach for higher upper
tier utilization.  One common idea for that (TPP) is utilizing two
schemes, one for promotion and the other one for demotion.  The
promotion scheme migrates hot pages from lower tier to upper tier,
aiming for high utilization of the upper tier.  The demotion scheme
migrates cold pages from upper tier to lower tier, aiming for head room
free memory of the upper tier.  Both schemes and their goals are in
direct proportion.  However, for this kind of use case, we need to
implement two different goal metrics (per-node memory utilization and
free memory ratio) while essentially the free memory ratio is just a
complemented value of the utilization.

To avoid adding too many new metrics, we are adding metrics that turn
out to be really needed for each found use case.  For example,
some_mem_psi_us, node_eligible_mem_bp and hugepage_mem_bp don't have
their complemented value version.  But it is not really difficult to
expect use cases that their complemented version can be useful.  For
example, hugepage_mem_bp use case may need a way to reduce the hugepage
ratio.  That would require a complemented version of hugepage_mem_bp.
Adding a new metric for each of such use cases could make the number of
metrics unnecessarily high, and discourage flexible usages of DAMOS.

Add a new flag, quota goal complement, to allow flexible tuning goal
setup without unnecessarily increasing the number of metrics.  The flag
specifies whether to use the complemented value of the given goal metric
for the tuning.  For example, if the complement flag is set, the upper
tier memory utilization ratio metric works the same as the free memory
ratio metric for the tier.

Patches Sequence
================

Patch 1 introduces the quota goal complement flag API and implements its
behavior.  Patch 2 updates damos_new_quota_goal() to receive the flag.
Patch 3 update DAMON sysfs interface to support the complement flag.
Patches 4 and 5 extend existing kunit and kselftest to cover the new
flag.  Patches 6-8 update design, usage and ABI documents for the new
feature.

Note: Below is additional information that is not intended to be added
to the final commit message.

Test
====

I tested this feature using the latest version of DAMON user-space tool,
damo [1], as below.

On an idle system having 10 GiB single node memory (node id 0), fill up
80% of memory with page cache.

    $ dd if=/dev/zero of=foo bs=1M count=$((1024*8))

Run DAMOS with pageout action for 80% of free memory, but using
node_mem_used_bp metric like below.

    $ sudo ./damo start --damos_action pageout \
            --damos_quota_space 100M --damos_quota_interval 1s \
            --damos_quota_fail_charge_ratio 1 4096 \
            --damos_quota_goal_tuner temporal \
            --damos_quota_goal node_mem_used_bp 20% 0

Because the system has more than 20% node 0 memory utilization, DAMOS
does nothing, as expected.

Run DAMOS with pageout action for 80% of free memory, using
node_mem_used_bp metrics with complement flag like below.

    $ sudo ./damo start --damos_action pageout \
            --damos_quota_space 100M --damos_quota_interval 1s \
            --damos_quota_fail_charge_ratio 1 4096 \
            --damos_quota_goal_tuner temporal \
            --damos_quota_goal node_mem_used_bp 80% complement 0

Because the complement flag is given, it is effectively the same as
node_mem_freepbp metrics with a target of 80%.  DAMOS reclaims the page
cache ~100 MiB per second, until the free memory ratio (complemented
memory utilization ratio) reaches the goal, 80%.

Changes from RFC v4
- RFC v4: https://lore.kernel.org/20260927120533.50484-1-sj@kernel.org
- Fix a typo in test code (s/complementfalse/complement/).
- Extend sysfs.sh DAMON selftest for complement flag sysfs file.
Changes from RFC v3
- RFC v3: https://lore.kernel.org/20260923101454.5748-1-sj@kernel.org
- Rebase to the latest mm-new.
- Add tests done to the cover letter.
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260919011359.88921-1-sj@kernel.org
- Avoid quota goal value underflow for some_mem_psi.
- Handle complement flag for psi goal with unset last_psi_total.
- Pass complement argument to damos_new_quota_goal() from core and
  core-kunit.
- Explicitly document no-op complement behavior for user_input.
Changes from RFC
- RFC: https://lore.kernel.org/20260918142827.85303-1-sj@kernel.org
- Avoid quota goal value underflow.
- Fix usage doc for number of files in each goal directory.
- Rebase to the latest mm-new.

[1] https://github.com/damonitor/damo

SJ Park (8):
  mm/damon/core: introduce damos_quota_goal->complement
  mm/damon/core: add complement argument to damos_new_quota_goal()
  mm/damon/sysfs-schemes: support quota goal complement flag
  mm/damon/tests/core-kunit: test quota_goal->complement commit
  selftests/damon/sysfs.sh: test quota goal complement flag file
  Docs/mm/damon/design: document damos quota goal complement flag
  Docs/admin-guide/mm/damon/usage: update for quota goal complement file
  Docs/ABI/damon: update for quota goal metric complement sysfs file

 .../ABI/testing/sysfs-kernel-mm-damon         |  6 ++++
 Documentation/admin-guide/mm/damon/usage.rst  | 15 +++++----
 Documentation/mm/damon/design.rst             | 15 ++++++---
 include/linux/damon.h                         |  4 ++-
 mm/damon/core.c                               | 33 ++++++++++++++++---
 mm/damon/lru_sort.c                           |  5 +--
 mm/damon/reclaim.c                            |  5 +--
 mm/damon/sysfs-schemes.c                      | 30 +++++++++++++++++
 mm/damon/tests/core-kunit.h                   |  3 ++
 samples/damon/mtier.c                         |  2 +-
 tools/testing/selftests/damon/sysfs.sh        |  3 ++
 11 files changed, 100 insertions(+), 21 deletions(-)


base-commit: f3528689602b1d578d582cb060e89fa25516fd67
-- 
2.47.3

