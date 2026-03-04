Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71303EB7EB8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3BA6B0089; Wed,  4 Mar 2026 05:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B886B008A; Wed,  4 Mar 2026 05:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B026B008C; Wed,  4 Mar 2026 05:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6A2E6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:15:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 631D48BC66
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:15:38 +0000 (UTC)
X-FDA: 84507973956.15.025A7E0
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 37DE180014
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:15:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772619335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xbSgZXOI4az7dJJYdOLs40zpWiMA+yQZjL2Z0HmBdCA=;
	b=xWBFbEOHrWzWCzWE8xD2/YXX9kqTF4cIx74X0qYMrIGdvtfwrVZXTd6RxT2SlUMCg5oHow
	0+FCjS1KS/pedjxdMHyWBihkWXD7Xeunz7yrEHEFQcHZ8oLw2R7XX3G18guolPOK9MfJHm
	gdRKZGbNcR5f2GD2IiCeiTIwJVaDpfk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772619335; a=rsa-sha256;
	cv=none;
	b=jm6SBTLUe0m0RwJRE+pxlERPN6paWz6KSRLNaZmzIBoYQy5z74UEMdVlGcRoCDimiHV2ox
	VVlHcecsguFIgbS72LUOZtxNFVbTggNMMO9+dO2zMyS2VOdgCL3DNUP2306GQ2vIpiII/m
	ElJYLDbzpF+wIFtqBn7xuacGSSs0kjo=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fQpSC1NygzHnHK7;
	Wed,  4 Mar 2026 18:14:35 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id B08B640086;
	Wed,  4 Mar 2026 18:15:30 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Mar 2026 13:15:30 +0300
Message-ID: <3c9449c1-95c7-4770-8e06-1ee50e263db8@huawei-partners.com>
Date: Wed, 4 Mar 2026 13:15:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/10] mm/damon: support multiple goal-based quota
 tuning algorithms
To: SeongJae Park <sj@kernel.org>
CC: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko
	<mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
	<damon@lists.linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260304044122.79394-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 37DE180014
X-Stat-Signature: dbqontxm51hkd41npwrt9m4oriqqauke
X-Rspam-User: 
X-HE-Tag: 1772619333-841671
X-HE-Meta: U2FsdGVkX195H17kO+1FvAxemoPKNB8fIQgDb/72mAL8NGiqPQoSUtrpZ9ruXpotTppf5BckNWf39Y8Dumc3kyvWCle3pxPj4f+LrbfikRK8xLlxnR+fMxypLVNZhiEKVaMNNtSUoWZv0twxPGgqwrRmJBmZ0d47NDmWjOjcB1ZaeKXFS2jViI60JkkiLXcp1Yaozr3VxMI3eFPcE8+7VZjJtHuGH7+7rHWDIQB87rFkdBeLrrP8RIRFa5uLmsC6314ph/zCkrZv7z+pwuBWsb+cejaaVc7TWJhw74Zt2sdouc2mGrXrla4losz5D5N3WCiIyagboSZMqq0vGpxJbymYvsOjcoqp3E6rYlGnIrR/5sJeMOtYaiSqZlXWpP/Otvn1UuIZnJZWs7ca7381a8uZm6OhV08o+EIYyjkjECZ1bU6ghR/m73KG0faMZDwLPZx21F0SG1XOr7mMv/gv8VUmafbnDYp1zdYT4/SmJeS/9uPiw6oPwZqocJQwd0olvbDw8bXptqC65eqBdAwZFXfE/YbzJKSKnX6Hy0WfhfT5wgYv1pghBp7PtAsWcyV/exFTNqcCWjR99ODk7j5CvK8CnN66+0ON4KqP5/cRH7CwLI/pgvMg6+55zVzhJR61EDrGOoHze27JeB15/HRGja0272R3z5JI3YusMDqrEox5eFwJTEx9Su0At3dGYZrW0Ig9MDWN3DmIPKxyNX4iK+Iia2OrL39JuuWGI4vlYZdW1+sZxmz4x9QCmgM03hi+Hbk8R0i1JmX+QhdKPs7Ju4K6jXdGE/r52sLm4xCVc9mfp9/1BjUkcu1biJC9W3c44/Jn4VKJ7/M3tdS4JkDYZJPgKdnK+3fT04BOBOFAHBck850pAGBf7SDRNPORk3SaSTlEMNdwIU4P9NAiKJ5GrjYsklultUB+kNcQFBjxApwPZgAQsX/3J8Yq9v/pOWb64+reod6tCajEcGJcf8V
 d+pf8dRf
 znOOTDz9uBdqsl4vu9FnZqhj2qUAXsRbrIUacvLSYJh+VFQZ36yAm7u4XYHZpIJkfzjnMHLPxk5ZVr+WarMurQYfiDjcoNgHhlpBiiAyfUmx/HjCP8XtiMDwc4YJyD+4OGEvw7VWMx85LbXgaehebpzroCg/o3FDfdlNviL5jN/FwOUiHtPDJ/AuRb7w0E13wNaWvo5/FCxXAO8XpJqhUZC+J+ZRz7vJweiQvVZST7CxBR8kNKyTiszO0Oem4/PMDdGdHtO3yCmsBtfoLX+e8vUPKVyZtfMS/LgPSGbPo8u09LUzURDxS/GZ5Zng2qrKxKMItR9PnDFWIJ58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae!

Nice idea for dynamic environments.

On 3/4/2026 7:41 AM, SeongJae Park wrote:
> Aim-oriented DAMOS quota auto-tuning uses a single tuning algorithm.
> The algorithm is designed to find a quota value that should be
> consistently kept for achieving the aimed goal for long term.  It is
> useful and reliable at automatically operating systems that have dynamic
> environments in the long term.
> 
> As always, however, no single algorithm fits all.  When the environment
> has static characteristics or there are control towers in not only the
> kernel space but also the user space, the algorithm shows some
> limitations.  In such environments, users want kernel work in a more
> short term deterministic way.  Actually there were at least two reports
> [1,2] of such cases.
> 
> Extend DAMOS quotas goal to support multiple quota tuning algorithms
> that users can select.  Keep the current algorithm as the default one,
> to not break the old users.  Also give it a name, "consist", as it is
> designed to "consistently" apply the DAMOS action.  And introduce a new
> tuning algorithm, namely "temporal".  It is designed to apply the DAMOS
> action only temporally, in a deterministic way.  In more detail, as long
> as the goal is under-achieved, it uses the maximum quota available.
> Once the goal is over-achieved, it sets the quota zero.

I'm not sure "temporal" is the best name for this type of behaviour.

How about "by_score?". For example, "damos_goal_tune_esz_bp_by_score" and
DAMOS_QUOTA_GOAL_TUNER_BY_SCORE.

> Tests
> =====
> 
> I confirmed the feature is working as expected using the latest version
> of DAMON user-space tool, like below.
> 
>     $ # start DAMOS for reclaiming memory aiming 30% free memory
>     $ sudo ./damo/damo start --damos_action pageout \
>             --damos_quota_goal_tuner temporal \
>             --damos_quota_goal node_mem_free_bp 30% 0 \
>             --damos_quota_interval 1s \
>             --damos_quota_space 100M
> 
> Note that >=3.1.8 version of DAMON user-space tool supports this feature
> (--damos_quota_goal_tuner).  As expected, DAMOS stops reclaiming memory
> as soon as the goal amount of free memory is made.  When 'consist' tuner
> is used, the reclamation was continued even after the goal amount of
> free memory is made, resulting in more than goal amount of free memory,
> as expected.
> 
> Patch Sequence
> ==============
> 
> First four patches implement the features.  Patch 1 extends core API to
> allow multiple tuners and make the current tuner as the default and only
> available tuner, namely 'consist'.  Patch 2 allows future tuners setting
> zero effective quota.  Patch 3 introduces the second tuner, namely
> 'temporal'.  Patch 4 further extends DAMON sysfs API to let users use
> that.
> 
> Three following patches (patches 5-7) update design, usage, and ABI
> documents, respectively.
> 
> Final three patches (patches 8-10) are for adding selftests.  The eighth
> and the ninth patches extend the testing-purpose DAMON sysfs control
> helper and DAMON status dumping tool to support the newly added feature.
> The tenth patch extends the existing online commit test to cover the new
> feature.
> 
> References
> ==========
> 
> [1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
> [2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com
> 
> Changelog
> =========
> 
> Changes from RFC v1
> (https://lore.kernel.org/20260212062314.69961-1-sj@kernel.org)
> - Add selftest for goal_tuner commitment.
> - Set goal tuner inside damon_new_scheme().
> - Allow zero size effective size quota.
> - Update the ABI document.
> - Wordsmith change descriptions.
> 
> SeongJae Park (10):
>   mm/damon/core: introduce damos_quota_goal_tuner
>   mm/damon/core: allow quota goals set zero effective size quota
>   mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
>   mm/damon/sysfs-schemes: implement quotas->goal_tuner file
>   Docs/mm/damon/design: document the goal-based quota tuner selections
>   Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file
>   Docs/ABI/damon: update for goal_tuner
>   selftests/damon/_damon_sysfs: support goal_tuner setup
>   selftests/damon/drgn_dump_damon_status: support quota goal_tuner
>     dumping
>   selftests/damon/sysfs.py: test goal_tuner commit
> 
>  .../ABI/testing/sysfs-kernel-mm-damon         |  6 ++
>  Documentation/admin-guide/mm/damon/usage.rst  | 16 +++--
>  Documentation/mm/damon/design.rst             | 12 ++++
>  include/linux/damon.h                         | 11 ++++
>  mm/damon/core.c                               | 60 +++++++++++++++----
>  mm/damon/sysfs-schemes.c                      | 58 ++++++++++++++++++
>  tools/testing/selftests/damon/_damon_sysfs.py | 12 +++-
>  .../selftests/damon/drgn_dump_damon_status.py |  1 +
>  tools/testing/selftests/damon/sysfs.py        |  7 +++
>  9 files changed, 166 insertions(+), 17 deletions(-)
> 
> 
> base-commit: bbba4ca6322dd5c4f66fe31b1b374f77a8d2b2e5

-- 
Asier Gutierrez
Huawei


