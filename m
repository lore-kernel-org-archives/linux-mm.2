Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5440FEDF045
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59926B008C; Thu, 12 Feb 2026 01:23:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB91C6B0095; Thu, 12 Feb 2026 01:23:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05976B0096; Thu, 12 Feb 2026 01:23:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0DB6B008C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:23:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 485491A06B3
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:32 +0000 (UTC)
X-FDA: 84434813064.08.E0E2461
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C838AC000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7KEiN4F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770877408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VZSDVKROBak53cHPC+pISSCIzEpxxnORJvPOwfer/N0=;
	b=5prLjQBf2f0fmxxpEtj8z2W917ksFanNGnjLIne8je7BRiQBhcArP6/5t1s4kfb85IWoYM
	32dV3TR54+V2JZayumM+oWoIx7NYpF+97AlkT/SY3vEouPSKNlwaX6Qu3D4PSBixe492tf
	Giur1E5ebyIQmiGcNwHMpBV+qD/qCIU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770877408; a=rsa-sha256;
	cv=none;
	b=tzxepKtSrxJZPUsIBWeUvp/NcT6Xk0vJFTznNLR3QCgwLY+3xfc56Tsimk5nS5ppNawK6R
	9TBi/Nr10mq5Cq544PSRMsXA9ginU/DUwqTGgDrh3TPlYZh63eEgUien08yizq8GZoAowC
	YdMTKiYCsfxiLUrUHKVuQjMU0CtaEFo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7KEiN4F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B99C341672;
	Thu, 12 Feb 2026 06:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566EFC4CEF7;
	Thu, 12 Feb 2026 06:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770877407;
	bh=Fndn/P+WltNHntvZCHkOzGWVSalmqo/mkzDW9TH8/Fk=;
	h=From:To:Cc:Subject:Date:From;
	b=c7KEiN4Fwf2qDSAj8/fkkzO/duD7GFGT7ShRVJ6wQ5222tTS12HWIOo4J4P64g8KQ
	 X5ZIv0uTO7iA9m0wJWTdUJQt8ZapzWLPJJT5QYymjJCKzUVTjhgLNCCBMAzDZgddCt
	 LtdLKAHRo4Xr7yoGuQ5m74YS2gE47oi2xVVKiqJJW0FkGWE+2wJ0M8hLehFDJBmBtm
	 UmrNanLPZhAXKfhiPI6FM5T93y+ci6HVziDm+dbUgE35yoC/SWdxClFlgtdGe0bvkm
	 TTUSk9lKjJGQlocyV0GSQ0UMRQK+zJMZZMHGkCfZnqCNIieWPBevALZ2HajdhrgidH
	 0NeWnQ4+EZUOg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/5] mm/damon: support multiple goal-based quota tuning algorithms
Date: Wed, 11 Feb 2026 22:23:07 -0800
Message-ID: <20260212062314.69961-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C838AC000B
X-Stat-Signature: 93do4ozbm669teh8iqhz9ragefumkfji
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770877408-247911
X-HE-Meta: U2FsdGVkX1+Aikv6XHtVKzfy3yoKMXZrZfNF3Rg0xRU5lKUspZHBl0FuA5HPx4zOib/4IfjXI1TwXIF6uHpf1oyEJOkGsrS33AFfqCaaYmF56gP29q+n83abwFiN4KYR75shCVevuQLLnlHSaKIUlfAhTORaxn6tkpnTxBvEUPelVIYQTlxooO5jjH07c4cbt5b7NlSn52GWVsrQ4cAAOvFAxqKPJM1MTzUAGm3wOp6o+noecRfOK1UW0JWr/tyQWjT8Mqz9PVHjRCTmAM4xyIGjKGDhb2nb3ztMNTRuNBlUcYTsMtugDPTFaDLtsnRYUt7gursH55FclXyn/8WLz5a5YReZlGEAlZvbQQrqV1/InH8i+cgsl5qaV0925XsAKG/A0dEqyKuys6LwWtBKTvo7pEH1QCvQHxWyo1/vBXYt9epUbOZxsJqFbr1AUwAE0OiTCEKd8LyTsyBJobpJbkB8VjqnhMAWbuAorKOgcqhbCTaFsKd02jmwiXpGVH9ZtUhYT5pjHSrXjnVshLbdI+CzXWBRU4IOuiSeXwrBp4tYL/VVeTwiH/ZPuu+NWkRBy2p6oFKLi1KjQZ9EOzpwmCBS2vE6NSfROBMvNP+udj6zs9e9Qa+FwCPUx8n4YwUOx97hwMeSVgEkbPob6V4m2FZfRyk8SjaJnlfIOLpfu/UqC4dxE05eCvlCpiJhe5gqGh764WaJ3uEkNMjtg9KVB9uow/tXauKvFYCATnqpK3fdxhj8fpbMozHvkhm707zgUwnk16AMkRELFd3qaYU8yEt5tahqVvJOnd+A2Vj2jYFEmmaFK0ex2mkEEIu+4MhkrFfqpuHwiFiMEiwK3aQGPRbBctF/7pYuldtQMMNjwL5RrOeMpZHLueIzNvFJCbDDfXQfTJdsSv0BKmd0/vTrgOVvIHesFuGVcBukWHiR6apzElEZD5Ol7LSW5tPyRqRWY62MCyJJaDRdh7GZL77
 I7RTyDJl
 BTGBe0VSFKa+U8vnW6zJ28035Vab0WFRFRktG1m081KgBpcX0vvFG/160ubnhLxnE8Flwie13zhQLhj7EM4cLprRXe1R7mvtA0kfOgY3OAF/VDqzFAZfGZM/icHUtNDxtkmvFw9QmQTmDMc5zUKBS1+xizk+zFo6zHxkXXAyYydJd1wyX1lEmmnE3hLfFuC7wBjpKETdr5zCQFPMLh5Q5Qd4twXxShFdOKvdwK3gxOSTvSJjNJqLXBfJMhS6XgKD73XusI/QIzHX5Xk3QQ7syAIREVBOu16yL0kK5ZyQG0IEyqvwCup9T2LxBEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Aim-oriented DAMOS quota atuo-tuning uses a single tuning algorithm.
The algorithm is designed to find a non-zero quota that should be
consistently kept for achieving the aimed goal for long term.  In other
words, the algorithm assumes the goal will be under-achieved once the
DAMOS scheme is completely deactivated.  Memory pressure level is one
good example of such an assumed goal metric.

It is particularly useful for long term automated kernel-only operations
on dynamic environments.  As always, however, no single algorithm fits
all.  When the environment has static characteristics and the goal
metric has no factor to move without additional intervention, the
algorithm is difficult to control and accurately achieve the goal.
Systems running by not only the kernel but with some user space controls
can be examples.  Actually there were reports [1,2] of such cases.

Extend DAMOS quotas goal core API and sysfs ABI to support multiple
quota tuning algorithms that the API callers and/or ABI users can
select.  Keep the current algorithm as the default one, to keep the
default behavior unchanged.  Also give it a name, "consist", as it is
designed to "consistently" apply the DAMOS action.  And introduce a new
tuning algorithm, namely "temporal".  It is designed to apply the DAMOS
action only temporally until the goal is achieved, in a deterministic
way.  In more detail, as long as the goal is under-achieved, it uses the
maximum quota available.  Once the goal is over-achieved, it sets the
quota zero.

[1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
[2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com

SeongJae Park (5):
  mm/damon/core: introduce damos_quota_goal_tuner
  mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
  mm/damon/sysfs-schemes: implement quotas->goal_tuner file
  Docs/mm/damon/design: document the goal-based quota tuner selections
  Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file

 Documentation/admin-guide/mm/damon/usage.rst | 16 ++++--
 Documentation/mm/damon/design.rst            | 12 ++++
 include/linux/damon.h                        | 11 ++++
 mm/damon/core.c                              | 33 +++++++++--
 mm/damon/sysfs-schemes.c                     | 58 ++++++++++++++++++++
 5 files changed, 120 insertions(+), 10 deletions(-)


base-commit: 3c44a1294328e58fcf8708f8d1c2ddcb03178966
-- 
2.47.3

