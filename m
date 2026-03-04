Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92B9EDEC08
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851486B008A; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811126B0093; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8056B0092; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 519166B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A119258B79
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
X-FDA: 84507131940.12.A3CB097
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29DE8A0011
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OaYTmdTU;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9pzx5lSPg2KHq+WGxIAzG/VmKraJyc0PXOaKPgCwflU=;
	b=WDOXrJUlc38aV+kz5GmfNygabWRbGvOVUn5IWGrISLWRHmaUE3q94IwiFcNRJfmZVitirc
	BroYA26LybVvpEEyvGRtg5vggVZoTSqgIS1gc6u7UjvHJAuIpCnyyt514e8wXjGY1nuBPo
	jOKPjsfm40EwODbztKcBcAiy8a0RetY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OaYTmdTU;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599289; a=rsa-sha256;
	cv=none;
	b=7fEjiNMfJ6y84YMJ5G5CZ1O+2hkK3x2C/cf0EFG/f979gIJ3iLfc5nqZA4zO5WTmUb/OUb
	0tZOW5Tw0gvOq/iFdSzCw1TBmGzk/MgvLi9wyfiHyBEJ9RM/3bUHj61P5F/Sk0XiMdN8F7
	A6In24BK/gintCM62pVLY4qNg/QcKGU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8410E60097;
	Wed,  4 Mar 2026 04:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847B8C19423;
	Wed,  4 Mar 2026 04:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599287;
	bh=QuJFb/rFJcLkJTaWE+LU8ObndCC324KIqzke1jWKe1U=;
	h=From:To:Cc:Subject:Date:From;
	b=OaYTmdTUhz6YdoeoglHASzmk9ymccLLodxEiNkLIpitj+mI4JhGw8p9k1WO3hLMqd
	 7k1oVSXl9i1mOF2nR9DOO/2c9MlrqoL2lxqm8VHOaZ2Opos9LXLLlDZKE38RMSmdoP
	 utOPFgwzG+5wRS9ZgnzcXStwQwea1xkHyIxRS4eow2UZ5LO7sgc0nBoRZAqlXGEPL1
	 NS38O9REMTpSx1QOkh73zJ/8h/avHG2Pi6X+Am4sjOChBPIoSmV6A7T4V2GP4To//L
	 fYfgyIQWPTCeTE+VLfEKseyOoyjL5kVxlZILWhQZ0zS5i3UR+ncT64Kq81q68u4FdX
	 Du+ToqMVcQwsg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 00/10] mm/damon: support multiple goal-based quota tuning algorithms
Date: Tue,  3 Mar 2026 20:41:09 -0800
Message-ID: <20260304044122.79394-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 29DE8A0011
X-Stat-Signature: fur894aq4owufphc841tu8ydksjqoh4t
X-Rspam-User: 
X-HE-Tag: 1772599289-211610
X-HE-Meta: U2FsdGVkX19YrcRPCF52q7Hc6HGdm+x13RlwAe0EbnkOvpJXDm8RZ0bHHlm+NG7V0wXNj4f5mqACzr5o7OwLH5Q4KZwfg186RpjNU+AiEedl3UtGuXfd4ZhMCHrYZ/PJXKLRsN9dm5ktTY4GAF5KSO5Z254VLt7mmrrU//GqgOo4bBAOO/Q5qoWJOLzxlWK2NYgZMgzXVtorRNOVIBlPWzhuLrKdRv4yEuToW/vjCZZXXsqctrC+GdiDP6ixxONN+8cc80wq5uQ/wLkdsEzzqXZWbGPLXBgGCDSo5sJpTgHcEXuP+yhL59HoYt86hAZ28zla1f8kcsAw54ZCMWnJnRsN2dWp09pDohPyHf/S14Uxm4kEvdIQyXxF6f5fKfx4rpJoTsBur7d+wuXfBujItMO6yEBfhGUNwjIkirfOYhvoT+G+okJzZvaZB9XZn3YhZrHrnZKYFZpEp2SwC9P6yp/laQxkdeAjDTZA/WlE4/4xcqK1JAcQBFxhX2Ose3vw4jMM6yJIn+RFz5iaKtJghbw3G9MWW+wETJIeobN/Phh1ZaC2YEtbZ6zCXqOP9xPXS4OJVgF9CpBa3NxUKTZeInnSdlOItEtbzUz74wyUH1X2/fd10OkRrXcD3UKia4v2KzCw5ERi0X5mhDUGCrWqq7P+/8x4aVbODWnWmwlM4rFlxcWb3+G+xigiiYP6CCq/x88UEYSOfcO27Cjc6+bjWllPNY+tDGhKH3o1IeyLNPUAkpHOWN9ioFvVGP+bSUWT4xhYqlei/KSrcKG84Pd0Ry3Wu5To7AkEah5ybwdi4pthYr+Em55xaHEsgNruRseNNl5YkAR99obhx9LEojRI4ZuL4OglRyqPI1RaAFuXucpNT+sW6kjvJzsH0DlRsLXa6hwqkLEcFJAH/I5mDPYASrch+ADxMp6WjrNO6HZMGZv0rQbpOJEtcXqceDmuvgUoh0jX5mxtVCv11sB1H2b
 yaZbLvEf
 5ONn5u4/a3O/AlyJNQVQQwF0tPS7V6AiBNaiA/s0jDOfQXuU6Q1u/9m7vNN2rNq2VO3dP0V5w2rvp75bAsiUTjrbkFRZkybwv0mMmKU5up0zqTd7QwHjHlssggEmt2946q/1YIo9Jv1RqqOPc/hKFpBx8La69BmzlCp4qVhUYIhTOmdzwB+QLELjVI8uoBE1BLMiCCDwGWiGln0aIfDDmxCkg+1sIuJzeTwKebZ6tBqLASGKIBnGvEgXEy3aMN6zI5BsIs7/wSLloSYUxqoZ/Mz6PkAnWQJuT0Xcc9Pf6EYLPDJ5EzlUV0pBWsw==
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

Final three patches (patches 8-10) are for adding selftests.  The eighth
and the ninth patches extend the testing-purpose DAMON sysfs control
helper and DAMON status dumping tool to support the newly added feature.
The tenth patch extends the existing online commit test to cover the new
feature.

References
==========

[1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
[2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com

Changelog
=========

Changes from RFC v1
(https://lore.kernel.org/20260212062314.69961-1-sj@kernel.org)
- Add selftest for goal_tuner commitment.
- Set goal tuner inside damon_new_scheme().
- Allow zero size effective size quota.
- Update the ABI document.
- Wordsmith change descriptions.

SeongJae Park (10):
  mm/damon/core: introduce damos_quota_goal_tuner
  mm/damon/core: allow quota goals set zero effective size quota
  mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
  mm/damon/sysfs-schemes: implement quotas->goal_tuner file
  Docs/mm/damon/design: document the goal-based quota tuner selections
  Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file
  Docs/ABI/damon: update for goal_tuner
  selftests/damon/_damon_sysfs: support goal_tuner setup
  selftests/damon/drgn_dump_damon_status: support quota goal_tuner
    dumping
  selftests/damon/sysfs.py: test goal_tuner commit

 .../ABI/testing/sysfs-kernel-mm-damon         |  6 ++
 Documentation/admin-guide/mm/damon/usage.rst  | 16 +++--
 Documentation/mm/damon/design.rst             | 12 ++++
 include/linux/damon.h                         | 11 ++++
 mm/damon/core.c                               | 60 +++++++++++++++----
 mm/damon/sysfs-schemes.c                      | 58 ++++++++++++++++++
 tools/testing/selftests/damon/_damon_sysfs.py | 12 +++-
 .../selftests/damon/drgn_dump_damon_status.py |  1 +
 tools/testing/selftests/damon/sysfs.py        |  7 +++
 9 files changed, 166 insertions(+), 17 deletions(-)


base-commit: bbba4ca6322dd5c4f66fe31b1b374f77a8d2b2e5
-- 
2.47.3

