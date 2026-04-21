Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A72D5F327C2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 09:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E212F6B0088; Tue, 21 Apr 2026 05:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8936B0089; Tue, 21 Apr 2026 05:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36576B008A; Tue, 21 Apr 2026 05:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7A936B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:20:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A86713C1F5
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:20:00 +0000 (UTC)
X-FDA: 84682016160.10.672C2A7
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6031540004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:19:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AzwoozG0;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776763197; a=rsa-sha256;
	cv=none;
	b=UW5cE6q8K8tO5W0FQUUwQ+Y9YYXlaG/TT+go5umuD7jHFxVnpPobSJSrw1uhn+KspoBJ7M
	CdfLuEc7i1W0UN6BlN2aHSyzXabYsmHiVsNKlnZe3B4O2q7Q89HJn2YsCRfqAJ+pL0w7Kk
	bvYszbsAau4DR6rzS2reuv9IPkJ9f00=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AzwoozG0;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776763197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DsPOPl9WLRD+9guVWfxhRP62svhcatI0unY0NjcWUA=;
	b=w4jeaTftA3pi7v/hrs3eL/6DOHgwLwjLANyjviSp1FOVH2I5Z2Dl6BBHNOVSRS9cy5O57p
	ZuTD63+z//SxcpzOXvxH4UxDH8xNmyIrdUakuQvOEguylPXhcWHxXgkKygZnam+ssfy+2B
	CVh3O4KQhlrkWPm/6O+Kr2QOxe0/amU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776763193; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=0DsPOPl9WLRD+9guVWfxhRP62svhcatI0unY0NjcWUA=;
	b=AzwoozG01x7nFwmPnQVV1x+3wA91OCxwm9AFUHuDZ7ctw+GNJWVj5P5E/CW3UrSI61Puz84ct78pI9MmxJVFWB+yNqzNL0z5XXaNOhogaTVEOv3mCbjHRLg+2A+Iv5Vr+sORAtb5XGEBpCjmhHwdeBEh0klKx32mQl3owfUgSto=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1SYQHf_1776763179;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X1SYQHf_1776763179 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Apr 2026 17:19:52 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R . Howlett"
 <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@kernel.org>,  Mike
 Rapoport <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,
  Michal Hocko <mhocko@suse.com>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,  Axel
 Rasmussen <axelrasmussen@google.com>,  Yuanchu Xie <yuanchu@google.com>,
  Wei Xu <weixugc@google.com>,  Chris Li <chrisl@kernel.org>,  Kairui Song
 <kasong@tencent.com>,  Kemeng Shi <shikemeng@huaweicloud.com>,  Nhat Pham
 <nphamcs@gmail.com>,  Baoquan He <bhe@redhat.com>,  Barry Song
 <baohua@kernel.org>,  LKML <linux-kernel@vger.kernel.org>,
  linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/2] mm/migrate: wait for folio refcount during
 longterm pin migration
In-Reply-To: <20260410032333.400406-1-jhubbard@nvidia.com> (John Hubbard's
	message of "Thu, 9 Apr 2026 20:23:31 -0700")
References: <20260410032333.400406-1-jhubbard@nvidia.com>
Date: Tue, 21 Apr 2026 17:19:36 +0800
Message-ID: <87h5p4isbb.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 6031540004
X-Rspamd-Server: rspam12
X-Stat-Signature: 9b6q1m51w8b8ziw3eeek9r5ucuk1oe5s
X-Rspam-User: 
X-HE-Tag: 1776763195-116814
X-HE-Meta: U2FsdGVkX1+s7dviKxuKZDAxY2PksPkm2TZfaltY6aRejmSB9bgOatY82WNG3ffZJWY6/6resFlDWE0Gly1mcpZN1L2ouJTCrCzEI8p6pitp3ovozs01VFlFBgp0fBgnKtkPr/q3GcIBgEfz4E7+JLwoE+B4+a9eeVGAs0dActjEX/cq4uM6A8/NRpqIK0OclmGKj9zGDhpThomuf6N0aWpbosmmhIXY1iiYMhaucrDBvNWU14P2y3idn/GeeDyP1g5qLa8LKufEbPuDE9uYIHHE0ks76t66LDJ2sjVWCLYlcpUCyRGEnmM7pmw6rUmtV4wtPY/7d4oV23ktAku/hC4Ei7jCcsSrpFmG5waWVPpTaKU1CuefZrc9BNHhOTlGVRfDJwL83cYnyFTgjEVHYKVCRMTh3X019HauLM8w3br/Ic3fuYOBHFGMd1nDqn1ef0f4vpmPJOrUtDaPZGMDkxknEl0yRim4YYwcS5Y+/qm8+HC6IZQsFtZvH/CYAq/RHtn06SENe1obEnIsVjQ3FzcrcRdTuiIiJsbRS5uMu38iX4H6LvbwtCH5jLwnVQfG6Gp+Tp73uG1OCHKsdXDwKOVEavPt2TjZDfpo4NglMDqvb52QT4rmjrQpnVOUczSwjoYBEvw7H6eZhuvIw2TE/VqKoGSUJ33azO1cIZePBwPd+Zec4h8Nv5hI4foszXWvR3gGgF5HbTp/gYjz4evykQXyOK3KF7WM2qFEyKYuogchzxNiHfCoZHWm8pKXNCXOArkP+bbh+Ygloi9MartnE+5YsI1PtBUBbJjBI2/WX0MjZWwV+xjwi16/uS8U7qeSvyNmjztbIs/Lhkrb4LzGnXaX0GXLjZsFNBve++FCQE0l6LRC7sOF2ofBZQ/pE+8+d+IHPI9Y4fZfMlYHMQ+3cmb6T2GGqBnwdbJ8zfZ0ITyMOtSQhwBPqNiHqK5fgQYL1CewgnsHJ7lvNrIeIz8
 zmuLCeLh
 lzOHaUD2CQVc/y1RkQXsksBqpcmzvhswQy/Dj/qsCQtd7iPGKoEGqIOuEWiwfX+Du6s7iwum2C2oN/ddla9dMasI1Wfg6OeY6G7gZke1akzTYFovQurmHJVNpTuEs6PQTzH068j2JNJO/yptzxVzDMc5KWjsq6gAIwQqgjbnVPU3iCeBzRR84srMvCFQEQpIwxsMvfIUFCCmJZ0RN+0oePp+LDx79Ibt/UxjfLHvjxl1zSQYGo+1VJambqeDp0wRrHWSO1CZDjQnzmqV2CmxkXEJwlstgmu1f5jP20G+OMZo6lkfbZqca1afBt6js7E6/rLh+uwCw5lQO5JBmqGEjEgORA2RBm1jdNUD62kHa/5Dyw0SbBgwf1klWsyLNdJX5jhSt2GVonkwZfZr5kPJwgTE2vPBhGn5mHwd8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, John,

John Hubbard <jhubbard@nvidia.com> writes:

> Hi,
>
> This adds a bounded sleep to migration so that FOLL_LONGTERM pinning can
> wait for transient folio references to drain, instead of failing after a
> fixed number of retries. The wait uses a one-second timeout. An

Is the one-second timeout appropriate for all users?  Do some users
prefer fail-fast behavior instead?  If so, should we add another FOLL
flag to support a timed wait?

> alternative approach would be to call wait_var_event_killable() with no
> timeout, but that doesn't match as well with migration's "this will
> probably work" API. In other words, a short sleeping wait is more
> appropriate here.
>
> When migrating pages for FOLL_LONGTERM pinning, migration can fail with
> -EAGAIN if a folio has unexpected references. These references are often
> transient, but the current retry loop gives up too quickly. This series
> adds wait_var_event_timeout() at the retry points, paired with
> wake_up_var() in folio_put() to wake the sleeper as soon as the refcount
> drops.
>
> The wake_up_var() calls in folio_put() are gated behind a static key,
> disabled by default, so non-migration workloads pay zero cost.
> migrate_pages() enables the key on entry when the reason is
> MR_LONGTERM_PIN, and disables it on exit.
>
> Toggling the key is not free. folio_put() is static inline, so every
> compilation unit that calls it gets its own patch site (roughly 500 in
> vmlinux, plus modules). On x86, jump label patching is batched (256
> sites per batch, 3 IPI rounds per batch), so enabling the key costs
> 6-9 IPI broadcasts, a few hundred microseconds on a large machine.
> That cost is paid twice per migrate_pages() call. Migration itself
> spends several milliseconds per batch on LRU isolation, TLB flushes,
> and page copies. Concurrent longterm-pin migrations after the first
> just do an atomic_inc (no patching).
>
> Matthew Brost offered to performance-test this series [1], as Intel has
> tests that stress migration and good metrics to catch regressions.
>
> [1] https://lore.kernel.org/all/aX+oUorOWPt1xbgw@lstrano-desk.jf.intel.com/
>
> John Hubbard (2):
>   mm: wake up folio refcount waiters on folio_put()
>   mm/migrate: wait for folio refcount during longterm pin migration
>
>  include/linux/mm.h |  8 ++++++++
>  mm/migrate.c       | 30 ++++++++++++++++++++++++++++++
>  mm/swap.c          | 10 +++++++++-
>  3 files changed, 47 insertions(+), 1 deletion(-)
>
>
> base-commit: 9a9c8ce300cd3859cc87b408ef552cd697cc2ab7

---
Best Regards,
Huang, Ying

