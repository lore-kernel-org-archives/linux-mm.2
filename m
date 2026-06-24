Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC3F2CDB470
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 06:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4EDF6B0088; Wed, 24 Jun 2026 02:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFFF36B008A; Wed, 24 Jun 2026 02:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15806B008C; Wed, 24 Jun 2026 02:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6F76B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 02:58:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 102361C1920
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:58:13 +0000 (UTC)
X-FDA: 84913902066.03.40A8617
Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id D2C0B1C0009
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:58:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=ko+peYdW;
	spf=pass (imf21.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.18 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782284291;
	b=c8upwimYgsF+l10wkhbvZ8H7j8nD8zm1oLxSS+fUmk1k81YpuBItFSTJ8UaWhX3jAak7L+
	LgDZoo8ELiaRrCpeskXRcS+YcdK50Pka0Sn8DQzHPRqvkZVbp2DDPVRBhHmMF5z/X5BNt4
	00MN++0l3AhM7+9vzrY0oVhLTLtlHlU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782284291;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMKsX1oqr9cJS0GXtzM8Ok+fkwH2kagCOdyTihBZHlM=;
	b=wqQES9pp+aATqKo0Q5NoIRQafQNk3sD3Q0bHRSTjcenlP5Jzc7KzZweWYnsgxng6gPMVeB
	GRyNkNLZOpXZd85NgpZHpHi/vj8XaM0ZybkcwrFBSPT8pwbrem9k1fxoqNIcnwblqaNwno
	/Ek+CRhHJaxkezzVJZSCHyJw5f61wH0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=ko+peYdW;
	spf=pass (imf21.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.18 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1782284286;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=FMKsX1oqr9cJS0GXtzM8Ok+fkwH2kagCOdyTihBZHlM=;
 b=ko+peYdWhkBC6Z2+M+DAnl+DHsw7wlKUYcGNSanD0QdqHL8kOGNHfy5JdHfFOLwBitSHLK
 EK6pLRNFI2Ud7COX476laUs/Yn9twDwM6BzwU5ay+45/RPsZvLd2zVcfwbj3e8/Oh8o6Qh
 51b1/iIv5qImhJBjy9SAtaeR3IiSjddbeFzYvyuiv9VOVVgPqb8e0c6pncmMnr8S7IziS1
 bRaHq/Eeyn+vdDxSEw1TIBPEMAo4KrGVeqjBoeJepRYhI8QA0h9N/pIA84fxdaAnw/4KBM
 RdiUXkYUQnjnDCgCUCNCg2y4JhTuJcX8KFuo5Ck1jX6/L9Z0UVAbsh/6OJ/rQw==
Cc: <akpm@linux-foundation.org>, <chrisl@kernel.org>, <kasong@tencent.com>, 
	<shikemeng@huaweicloud.com>, <nphamcs@gmail.com>, <bhe@redhat.com>, 
	<baohua@kernel.org>, <youngjun.park@lge.com>, <cgroups@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a3b7ffd+12954f+kvack.org+yukuai@fygo.io>
Message-Id: <1c739fcc-5132-4cb2-bf34-cec94de26509@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Yu Kuai" <yukuai@kernel.org>, <nilay@linux.ibm.com>, 
	<tom.leiming@gmail.com>, <bvanassche@acm.org>, <tj@kernel.org>, 
	<josef@toxicpanda.com>, <axboe@kernel.dk>
Subject: Re: [PATCH 0/8] blk-cgroup: remove queue_lock nesting from blkcg paths
Date: Wed, 24 Jun 2026 14:57:59 +0800
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Wed, 24 Jun 2026 06:58:04 +0000
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
X-Rspam-User: 
X-Stat-Signature: jw8ewgy95xs1iiquy3mrx5ns6gp6th3t
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D2C0B1C0009
X-HE-Tag: 1782284290-628332
X-HE-Meta: U2FsdGVkX1/wLJ/BxbHSsTVKDSsg3yO6Ew+gQ1+qBdLv/Pw+C1nIUE9Ke6dXzkzBiwjIgffGYrb2xX7tAQsUVfbLkTGO89oulL/kxTAAUfggMzdyB/vnibLQtB+Zw4LKB3tHR2TLsPS9qup6Xrqg8K4ZgnrDG3YNftQABi7zGV8u73dsAZ6gy6t3YMBGU+JDj/A3BRls90XUNXNhwLi3dNYi/m4XGsm8PBHp6HSSb76jkE9n+20EWKHKhazGR/OQJOaG3UxeP/uXXArS43gQ9/vQfIJu54YByqbZ/eRpRJjEJ4NJ6dY28beWeoBQpwaT73NYXKT5oBJdgQMC6TbdWHm5R4R5Gq9GPL+sdZogm33hTYi6vGLKMGbMvzsWZpTd/yO06likEm9UNjcJ5OM6MOeb3gZD5Z03ipEKhOCIayRuZrl/bQYqhomVPBrsfltAkGwZjqSlR8Gu/O4Uf/SsbIithEJgtRBtYnhtuFoGq3StM6k0/dT0rUOf3ZYfZvTRAVQdsJR31DZPa2ke+5RJB8sVW1an+nJlf8+QNarLWfvybzh0ml01WoxbY8LgirAw6BDZAVh1foK0KWToPd1NfxGbzzNmW/2lYvRLfEAubsARUprikuCEt7F5W5nihSfo9beXpy40CtlnCwd8w4DQ7HNK+KmFtlj7JMRLHEXbPUiuC7SjZC13MYtYsohJkQCzudqY/d6FpSp49pt7Fbr4SBZAVcgWqgmmruTyZnxcFCdnt5/xWe4S/r86d2Vf+P8VSiMGWfWURIeV99q0EoZJUwL9hdxWpt+QNHFuWnGvd71389W5vGgYtVFkmzxb3xHG7AiyOFFL88D/yDzMNOvvY86XgNCs6ZlTAaDKfi7PqLKeaEazYKA4k7ksiFidAOZ0NPqe+nM8qZHiAzuq5UcMbXDZah5FR/Cm4VJUeuMXyM+r1aC/nrvlsugVU9PbjjxySGpsbYi1J5b5uZJSW1i
 iiG7Zz1y
 kjQF8plug1pT8SnCh1l8t8Km4Kl/wntD0NufNr2c3FRiK+2ql+2ZgT0FG1D84gkawGuabQwgTC85fIIemEJAaKmso6eJx6G003egt8FsHWH06+Mmh5j8jmIYTBkaTfyQXyLv4ENhg4V0ghgfMOTDekE2yDa2OavBC6zRtJU/L9Cpnon7ohTUjG50Q/hhRZJNxvA44jVVCOgAKWgiTqYbCQCqEckQiAJTJKmWWdCGMYXPGaE52cori/wS0gT5YvJHwZx3DL/WJgG3wNYhG1uH0tkjyRFD64YZdKZdJBhTfhKCHX1QF2xVESnrcM7JGbw4G+xtO+ZbjaPYng28IKlnUkMKzLn8Ld/9TzP2vRuvRt6u3hfkVEuP3LiPpvQ9DONWT6cisMSyXyYa9sAelknEuHWGnW35zgiKNXU+dyIT6qdLXIH7sLzHhj8RVxPf4XG06qO41PZMsa9fhHQBxiiNtb7RKVFYo2pAVHIH/t7vrqnnxhqfr6JBKT6lFdyvW4sFNn6j0qREoYDsS08z5iOf6LNIqsyCHfVhoutt/q7EWrYuBNAxcbqqIRAuICRpALsYKAPfj/S50cT11xvIMf7+FuKTeFmUro7DySKWoPts1xETgKb2gdDqL5q2FOM1kIOPHbm+4oeNgCTcX1wJaShkE3lTL6J48aIJqE0MgVAzQzg49MdSL7ACa8uzZwYSrG0uJBSIlM36Acn9iX5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Friendly ping ...

This set can still be applied cleanly for block-7.2 branch.

=E5=9C=A8 2026/6/8 11:42, Yu Kuai =E5=86=99=E9=81=93:
> From: Yu Kuai <yukuai@fygo.io>
>
> Hi,
>
> This series is the follow-up blk-cgroup locking cleanup on top of the
> earlier blkg-list protection fixes, and prepares blk-cgroup to stop using
> q->queue_lock as the global blkg lifetime/iteration lock.
>
> The current queue_lock based protection is hard to maintain because
> queue_lock is used from hardirq and softirq completion paths, while some
> blkcg cgroup file paths also need to iterate blkgs, print policy data, or
> create blkgs from RCU-protected contexts.  This series first tightens the
> blkcg-side lifetime rules:
>
> - blkcg_print_stat() iterates blkgs under blkcg->lock with IRQs disabled.
> - policy data freeing is delayed past an RCU grace period.
> - blkcg_print_blkgs(), blkg lookup/create, bio association, page-IO
>    association, blkg destruction, and BFQ initialization stop nesting
>    queue_lock under RCU or blkcg->lock.
>
> Using blkcg->lock and RCU for blkcg-owned lists/data keeps the lock order
> local to blk-cgroup and avoids extending queue_lock into cgroup file
> iteration paths.  It also makes the subsequent conversion to q->blkcg_mut=
ex
> possible without carrying forward queue_lock's interrupt-context
> constraints.
>
> Yu Kuai (8):
>    blk-cgroup: protect iterating blkgs with blkcg->lock in
>      blkcg_print_stat()
>    blk-cgroup: delay freeing policy data after rcu grace period
>    blk-cgroup: don't nest queue_lock under rcu in blkcg_print_blkgs()
>    blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()
>    blk-cgroup: don't nest queue_lock under rcu in bio_associate_blkg()
>    blk-cgroup: don't nest queue_lock under blkcg->lock in
>      blkcg_destroy_blkgs()
>    mm/page_io: don't nest queue_lock under rcu in
>      bio_associate_blkg_from_page()
>    block, bfq: don't grab queue_lock to initialize bfq
>
>   block/bfq-cgroup.c        |  17 ++++-
>   block/bfq-iosched.c       |   5 --
>   block/blk-cgroup-rwstat.c |  15 ++--
>   block/blk-cgroup.c        | 151 ++++++++++++++++++++++----------------
>   block/blk-cgroup.h        |   8 +-
>   block/blk-iocost.c        |  22 ++++--
>   block/blk-iolatency.c     |  10 ++-
>   block/blk-throttle.c      |  13 +++-
>   mm/page_io.c              |   7 +-
>   9 files changed, 158 insertions(+), 90 deletions(-)
>
>
> base-commit: b23df513de562739af61fa61ba80ef5e8059a636

--=20
Thanks,
Kuai

