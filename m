Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5404CD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 00:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0ED6B0005; Wed, 10 Jun 2026 20:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391F46B0088; Wed, 10 Jun 2026 20:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7EC6B008C; Wed, 10 Jun 2026 20:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1496B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:27:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97990120411
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:27:03 +0000 (UTC)
X-FDA: 84865741926.07.F0D4C70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E9D6620003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:27:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2pAqV9z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781137622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWl60uBMj2xbDWQfoHVwCjMYGBGOuR1rbjq8PkUIT3g=;
	b=qgiSwCjeyy8+0EQD9N6Cx61kIdiypAjjY085eiwug53SfBcm4hKIKe38Mojzaw+MCIGeQv
	zPvfzi1FGJY2St6s9aCDed4w2tMdoMLQ3ukVxDdOy6OwG/J23762xZ/9/tDgwPr3CG3XaX
	J1RUQ3pFEDUkbFML+WkQliHL1YEShUk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2pAqV9z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781137622;
	b=zoJH9sWNUuYxoDitOVEBevtDXt1J4qsRht8lvFxAQshyyEEvRyDN3pU+fO3bhflTD58j/5
	8FzOIVHwt3t9+f+iuf0/dOZ904mMXrjc3pnhDcnG8WtBnCjcajosbrIUAAafXg0zJo7P2o
	njyQDYgWoYVJbSmyLvhY0hj4bryIMjc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA23741844;
	Thu, 11 Jun 2026 00:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469051F00898;
	Thu, 11 Jun 2026 00:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781137620;
	bh=sWl60uBMj2xbDWQfoHVwCjMYGBGOuR1rbjq8PkUIT3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2pAqV9zNsybjktSvwbLvyRzqDcg64Whh6aePSx2mVgbHQscgHImYvCPhQUwvV9L9
	 jHffcv+bzo2ODhAbTKUXJJemL5ZepdW0ViWlAK2Cw/bazdz4P+GBz/9zWpF67vFr6S
	 YHjTC6xuz6j474PcFeHwSo9v5ITmlej+z3MYz+KsHBaTfSKp08Sv/jjSQTb7zAYC7p
	 NSSZNXZMn88nz25aNc454UX8QnvyTF9CS1h3VHdGRCVRw0YjhxRt7DXxGhLxeOdvcD
	 hgKacUH+e6i1aboK6FOLu4DVGGfaPjAvMeiNmQFpY9Zmy6pQxJgibd0uG4ijlU3HxC
	 bbZHkWG1e0BMA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in shrinker_debugfs_count_show()
Date: Wed, 10 Jun 2026 17:26:47 -0700
Message-ID: <20260611002651.69383-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260611002236.69207-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: a4d1n5uijz1mjk3krc9z8ddsbbqt1w57
X-Rspamd-Queue-Id: E9D6620003
X-HE-Tag: 1781137621-373798
X-HE-Meta: U2FsdGVkX19mVvexAu4XSV53i0Jd1g3626nhFyL6efSNcT9HudlGF0aCQTNoWBcJK0ytMaQdjE5INXR+Rc3TLysoPAgmjd8HlrYmsIi5WAG5Yjpj0gW7x70+luDMKg5w4dH+OzSoJsu/xOABKEDqjJ4j6giz0hTq73TlgLW/cf5Nb+4P6U1uhQWYO2B2V8kf+OZVI4Wn8l3sIBkEOZIKhE/2KU+0OzbZmrQTJvtFwu6IQFpVq0Hy8w8swtqdrBdFJFTrsEgDQTFxbImdKYbyJJQ8BsHnBPe0JLhSKo3lQ5/2gvax/JR0HZ0/hetatLEufKYsyyDcxi0SydASAX5vZoin6iBvjPBsf7vyXzmrO++uxlX5neu+jE+kn9RIAn6w1Ipfy0lcOgVQaNZFoTX1YecUH4E0Ru3fC+mMyggGbfmgLasPOzuREu7Thst7V8JFBC+/LOCvoCz+SSnOUIzLb3/LShXkBpu8SB+MTb7Mn9DONexx4Rr92D0HVrH9YLkuCJ2T0HzRdpFv2JBCKh2aVHprpjBQcuvKAJXeF1X6idBKdvyTsMMfRY+d90Q7ieqAeaFVNDtmrjl8+iBAv4i5tgm4vetoubQIsCO5HPD4tGn7JSdA9yXdX0Dzd56pjD3OJu91hNgvgGWERQ6V3zN+PU3kSaC03ZqJgef3VWSffyt8VKsS1S51UOxfV8nndzoVySr56zyOvEimdgd6AvmiWMssgLLzRbiII5UAU9WrIQS3GTxVWud1HgMoU4fGcjZOM5Cf3pdm6+cdTVxJ5MI0XcbeKKJ1Te76HrD9qVmarXQlLoxkUKD/lLaM9NPOxqh8tgTaa0KhQNfkT0Se9OD9zghqR/jWlRo3ugBNtC1rlMTtM4STcYKsSEB3JJd4U/iq/RjyPoMiT77PtJbeEQHgWXOVv1TOz6sUmiYrn5/Yi9If84z0+LQfmOMVZrlOB2moyZaWcQiUTQNR7F+x9rn
 N5Rtm6Ce
 YySXDrVdzMULgZ3HLabah10851/o4IuE9hhHlkCKcnuu/P00fdoWBboy0DupB/dnucb1wZOnekVHRX8XkceE+DE3mLOXJ/noebYkSGYjp8S5D/t6EB7js9jzxEEufoF/ley6epB6Ooswng6ZoT841IOtMYPVWb4qxygLyrDUEVJ/Tbyhl12iuopKC8YFFPawy6Q9iJ48cF95+FtvWK7QmzxT+nAY3VBFPfgOgt29SnZgifjOD23I4+s67PS5DDSjL7dGdfo7eTbfYSl8akaSmoOIakC5Z11cqqLLEEgOmCK1bw6wnj5IQoEArTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Jun 2026 17:22:51 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 10 Jun 2026 16:20:48 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> > inside an RCU read-side critical section:
> > 
> >   BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
> >   RCU nest depth: 1, expected: 0
> >    css_rstat_flush
> >    mem_cgroup_flush_stats
> >    zswap_shrinker_count
> >    shrinker_debugfs_count_show
> > 
> > shrinker_debugfs_count_show() invokes the ->count_objects() callback
> > under rcu_read_lock(). The zswap callback flushes memcg stats via
> > css_rstat_flush(), which may sleep, so it must not run under RCU.
> > 
> > The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
> > and returns a memcg holding a css reference (dropped on the next
> > iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> > without it. The shrinker is kept alive by the open debugfs file:
> > shrinker_free() removes the debugfs entries via
> > debugfs_remove_recursive(), which waits for in-flight readers to drain,
> > before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
> > already invokes the sleeping ->scan_objects() callback with no RCU
> > section.
> > 
> > Drop the rcu_read_lock()/rcu_read_unlock().
> 
> All make sense to me, thank you for the nice description and the fix!
> 
> > 
> > Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")

Forgot asking this, sorry.  Are you intentionally not adding Cc: stable@ here?
I think the user impact is arguably minor enough to not Cc-ing stable@, but
just thought it would be good to make the intention clear.

> > Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> > Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

