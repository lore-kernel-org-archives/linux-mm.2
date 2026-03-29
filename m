Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A00F3D605
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9936B0092; Sun, 29 Mar 2026 11:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0EF6B0096; Sun, 29 Mar 2026 11:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E366B0098; Sun, 29 Mar 2026 11:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEDA26B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:54:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D2EEC1D0B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:54:07 +0000 (UTC)
X-FDA: 84599546934.29.8308A7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E84358000E
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:54:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPoyftJl;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774799645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytJv+OZlXsQh9yLe1eREVvrUR6AuU0nU+bmOTDsP1iU=;
	b=s6WxgC55uj5Fzc7lgAK9xJHpuUU6d8/6pD+z/LV5zTxkUFutv7z21NnU9IkKSTU16N8C+1
	afAFEQpa6g8atRRNfe9LQJ06jCXtJLHOu+mZE9K7tF4JtVrMzIbHdgaAuSTZdlTHXc5SjI
	K0rb5rtiGTNybG+dO+pPeLBqwVNhM7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774799645; a=rsa-sha256;
	cv=none;
	b=vLF06R0wrPsTWwRoVGejF1c1tBs5ECPpmivRXeGvMS7aOyJx1IP6j1I9wCH4n9j+ViB5b9
	9QQKX5pJBX2mQtDYsf/gYc4u9BjuNNBnx+LWE9p3x5+/CtShBcTU/8Z/3L5KBoeu5cp1D+
	fBG5Lf7EtTs0ndjHAlDbr/iU21eEl1k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPoyftJl;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53F8A60054;
	Sun, 29 Mar 2026 15:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87671C116C6;
	Sun, 29 Mar 2026 15:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774799644;
	bh=EDzwBK7rJZWYtDV8j7S0PnDhvIIk/m3ub74/HBxXJas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPoyftJlHI1QqrbHl8YzmsnvqpkqhBPv/5/8RBrLZeat2ecTEFhaXMRZDzXopLZGB
	 zinTNIhkwXqxrE0qBJF6zZgDdscvT63F8oLxuJpwWz0+kl1f0rLIURld9KQsmo39yW
	 RA7YdD7K6CozsvaZvtC0Hy5CUOiFke+ThLsb460g1G+7bgtpES/KiYPUljWOShcF50
	 7Dp2IOpweimUFJGys8ADnS3NjK21lS3jqBSr3ZZ5CE16dE3ggtiPutMimLbRpHij4v
	 jusExFkpQKiSlWWdf9t/mk7nlsNkhDyqxzwN337JO+cWs+vBrT+QVxM7xAYd4UPnjt
	 kxIbFFjcSDsmQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH 1/2] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
Date: Sun, 29 Mar 2026 08:54:02 -0700
Message-ID: <20260329155403.48037-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329154937.47706-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E84358000E
X-Stat-Signature: pztk9m1whhped46bhnxbt5u3qbmiswft
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774799645-828490
X-HE-Meta: U2FsdGVkX1+ycqzxWmIVovX8Hc+JIKJ6dQ6a71dgkDaqY/npixOxCwK2+MwUHsMbzA/2g0/dDCsyr7KhZMOW096Xm9eaGhD4v185BOReslkVU6p/57xDC1qJdMC5e6euO2A/lvqfdkeXC0DqX7D9gv6Ng2vv2vOkbTHsk9zt/s1R7EI8cpZluwdWCstz/c9lFN8hyvYXlqbcgIfvWzwt2dqWfJnfG8MQ/hpwC/+HjqJ+OeRjMQB8jjZFx6bn4vXFy4GFCld+kVJW44/KEI8yL8hk5uH9HCBqVanzSvWtbt9sJpJfgeOGre9yn3fZ/feNuoA0AdolzZn56mUr6jyuT8n7aQgJZnuyK95wxzzDZqQRQwrBGudaSD7RshahfGJ+FOD/gRwqx/Zc3op9plxmU3dHyJJaiuheORVkfTBrV40gHlTnnXabEZP4eAWfM3D/vk+NL4Y4AMI+AyYvUIlQKYKPq2rQcpfJbFssyk5y/92tWuH4e7WsbK+wNOjmh8PCaFe1613VTXC/lIb7ntcjD3tSLyPjsudNksSpR+hpUdOKUFngdfIXnZ45N+nEpxkgAGB6RQ2QtcXo5uXHR+4iZjOYCkXqYcrtG2cEMSYsQXMqpElzaM8KvU9Au1lMR23qW6FOfPUKnaue3tEwJ/UpyNE8n4LKxIV2dfRqdrJgO/04L/MuMAGSx01c9OWHLohd2oQkv5quN2/oeMctZ23OEHeazkR0ZCZJxOphVxj6lB2RwmXAhVSAhqGYyc/3LVztGZyPwV4FHK1Zdul3nrpLb29Dzx7nfp2ChYWBfVGoBUPVken0dcu+59qKxYq++S3qQkQW9NDwL/84frg6cac9g4+vLyYmQZm8OvQUS0/S8KEnM8LKjWnBHw3pElIs1ZkYv3qMBFwFJcP9Pts6tzK5RsTdi8C4h3g9nOnxQQ3eAPrP9vQhqZ1VDYt/n0r5XTqdSRDIYjyphiW1b99MVuJ
 lttvInw7
 nUbXc9vWUDD5/Gkjb79PPyBiboz/QusGtah3chOhBiDMIx5ebzachwMdU84M2q1htnoXYiJlrXkPnk/hDGVWcfM/X+FQXdOmfXGUUKNpNzbf89N1FKSwDIi/L3CqlHbM1/U9DlVT1L/BYHZQDIEP4rRzgFck+QcICyFC1POQmH9uQfJOZzCUECxCMuo0NeSeBVfqRH+7BGAFLSs7vdnIiHteIpC/Gcxv3NCYC2I0B4Nw1HrccchN+p/6XRyf8/xykz3gzW8vIEG5QOm+09bJUGcdKmzwbZt3+y/P3LgtGptUxdoOT+AXHp37doqii9DYSvyPVdxJjmAif/VQqP3ZxlDRS5Th81IqsuTY/JI0G3pU681AyT77tTlunoN82MCGFfq1O/vuGz7EBJnw4tULu6PpsDKfQtAjQRHdlaT9+k/0YXPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 08:49:36 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260329153052.46657-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 140a828ed89f6ed59d7b68f9bb0f1ec9b051eec7
> Author: SeongJae Park <sj@kernel.org>
> 
> Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
> 
> This commit adds documentation warning users not to update DAMON reclaim
> module parameters while a commit_inputs request is in progress. It notes
> that doing so can cause undefined behavior due to races with the kdamond
> thread reading those parameters.
> 
> Link: https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org
> 
> > diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> > index 47854c461706..d7a0225b4950 100644
> > --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> > +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> [ ... ]
> > @@ -71,6 +71,10 @@ of parametrs except ``enabled`` again.  Once the re-reading is done, this
> >  parameter is set as ``N``.  If invalid parameters are found while the
> >  re-reading, DAMON_RECLAIM will be disabled.
> >  
> > +Once ``Y`` is written to this parameter, the user must not write to any
> > +parameters until reading ``commit_inputs`` again returns ``N``.  If users
> > +violate this rule, the kernel may exhibit undefined behavior.
> 
> Is it acceptable to rely on documentation to prevent undefined behavior
> triggered by userspace?
> 
> If users write to sysfs parameters concurrently, can it still crash the
> kernel? For example, in damon_reclaim_apply_parameters(), the code verifies
> if (!damon_reclaim_mon_attrs.aggr_interval) to prevent division by zero. If
> a user concurrently writes 0 to the parameter via sysfs immediately after
> this check but before damon_reclaim_new_scheme() executes, wouldn't the
> subsequent .min_age_region = min_age / damon_reclaim_mon_attrs.aggr_interval
> calculation result in a divide-by-zero kernel panic?
> 
> Should this race be fixed in the code using synchronization primitives
> rather than adding a documentation warning?

I answered the questions on the previous version.  In short, I believe this is
ok for stable kernels.  For mainline, Liew's patch [1] that can also fix this
issue is on the way.

[1] https://lore.kernel.org/20260329075415.36775-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

