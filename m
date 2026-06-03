Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE76FCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 05:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FCB46B008C; Wed,  3 Jun 2026 01:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B50D6B0092; Wed,  3 Jun 2026 01:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3E26B0093; Wed,  3 Jun 2026 01:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C85F6B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:04:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99258C0DA4
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:04:39 +0000 (UTC)
X-FDA: 84837411078.12.507E8CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E136D14000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:04:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daeM3HzH;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780463078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xQ2puumFJ/2qiURGzPXh82LgAz5H1aStJvJVqAWBJE=;
	b=x+ZDfYnM7f/uw/9XVFMY0FuH45u53u40KhoB6FZdsOSw2NGa13NML4/gnM5HvbNmsc91yU
	XWtOf80didNYP4h0tVwkl0IbyArq75GHZI7ylqnPp8fXcL+BAUGTq+BYjlQ54p9RakJ76s
	WvPCSLZmiHWmCcBIIlyAspkVaCbfSx8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daeM3HzH;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780463078;
	b=3uXqEYR3Zu1/kIMDTO6t6sZzHqjcEflt8Z0F9Yq4PuWnburim160bv8r4DPaBF4fWQBkPC
	5qJz/ejwiEzF2P8+oLZa03z6Bsca3NPu4KWSNJ9bdYmsSYqrZSuVXPpp3g7lDbul5P2ZSm
	kq5gIYcskJzj9tJ4zbcWpe/0QmwX8RM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D92C8438DD;
	Wed,  3 Jun 2026 05:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756B41F00893;
	Wed,  3 Jun 2026 05:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780463076;
	bh=+xQ2puumFJ/2qiURGzPXh82LgAz5H1aStJvJVqAWBJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=daeM3HzHogcgvKfFDLjYf3G1ILtAH98A4F7+Inlhar4Wicp1Pbpy4AfFwVCHwFkPj
	 +qcf/Gbr3N4gbgDDIEpBEdkOXUwYR0sqhBicrHA252SfGIt2KGS5ypdhFz7JJTVQRg
	 cv3AFOvaNK6vv4iJcj4GfKC3aDERXjNDDSgMUkwRosfXrO3Vy2VZEuoWaLcEEwcBvI
	 EJ4JKmCEAzNIol3zyVHGMDiC2zNbx4henShoYE+xnDJ2g43yJRXULLeG+P74/WZIOM
	 JU60UQBgEn8pO9ndZX3zCB7dbq91swWI6vG0b7tIBV2LbnCQcJZ3Zzkvro9row33e5
	 N+IXQrJzXfmDg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Cheng Nie <niecheng1@uniontech.com>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 0/2] selftests/damon: fix memcg_path staging handling
Date: Tue,  2 Jun 2026 22:04:26 -0700
Message-ID: <20260603050427.91866-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601145501.116884-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E136D14000D
X-Stat-Signature: gcppc9jzkgr5ffsz4fjyg7rbifuo5395
X-Rspam-User: 
X-HE-Tag: 1780463077-530060
X-HE-Meta: U2FsdGVkX18OzCWiP8iKmc69fwok/RR9cze96zJoB0s31hmcYJA3BozCqEALDCwZlt/cLGLmp+jyxcKUDv5NBmoVRF0lGLgBd9rLtulumwhCa0EQn6F1Jj6cP9+4IQR/gN1ChQkjYMsPYAkQaefWKW+MpAowB/59fcUK9+XHRlDNYAKDJHXoLo3x+/NlwHYyh3lRWRROKbPkbxY553lTjH4y4zCWqnK8K+Od4+Ijeht+pTK3/a+QGIFu9e0Z/3/0wdEF80eJZsAVroF2aLXWRkmMIQqM2oTWwQKISR70l8ZNMf3pogRYgUJK4uZRT9V7UVOAm1O5eP88kepj83WYUEH3BGeQp+L6ILjPYphtNmCWnl+RxqG+sISX9yQvqeahFXogHoSWosJ4RL9bbcFn/h9tQULLYEWrUqwU6n0K+bJvMqGfw2tKTCvVMrDg8xLKwZT4TzDXbLuBYKkKoXIby9QnCz6Qwz9tIWZxqugw+25zpKcvFKAMWKWo29LZio+rPB2VGQkvBA9JKs4//bEBcJW7sumRCP4zDt2ORT5vOTQD/Vh+53uVFbFF2WUYMmGChbKzowSH9PZrbBA66/aTW/6G+7F4DjfDzrAQ/RHDeDDDX6Irabswkz6dLR2I3JzkVGzATCN2gfA1bwLQUizBDI+d7FoeQaDXvXwZ7pg3qGWrlJSSyi3fgyixIA0JQ/zGT7OHEXuk/a/6+97jJ+lYboRUsyYizbG56oOSZ56LV84jixNJYv/kIaLWY4Og9sw0oYwnXFNUaRqnlEAWrrVSS+TU4A8Kt//OvMAFyaodPqSYsZwI/32R9SIU4l8lj2ty/zO2QtwfUhtJvC5OOah4IbRwjksa5rP1YMbljLBZyBRs04Nl1npv5yRcE/r08ftCy1RgF2N6FPKOcPLE/uHj61DPuz7+reoR8gXHgiE/UMWIfTrjWkAHzfMheRJZnndns4WnPF3OO2CmKmOpvrv
 Nc3/Pw3p
 1+lBtQ4raLNpd7rkc7zY7wsbHX1jD2+xMXPwG+vH1T3rvTgpKPy+aFYVjxVehu6SC4dTDT9CgzZpDwxJ8tadh5l589YMJvONpb99j7/e+V9NCAmDk8YGWphr2hNQeurTRZZrW+Z50TumcxipFObrXhQoQXJPCzV9lQY4ynGbPCbL4Fo8582tn6wsL+A5TTNNVV2j7mgU1ODOLEs5bjPGzXg/l/ZLKcb/TbOxad9IqmReUzBnYCA/ZdzOF9/15vkV8miOZ9UWOV4dakRyyYnak72TLJO6sTcHNSmEpM6QbIu+tqrS/rOScRWAjkBCXKeOGdsV0MrUxJCoINC+QkcTUCMaPMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 07:55:00 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Mon,  1 Jun 2026 17:01:19 +0800 Cheng Nie <niecheng1@uniontech.com> wrote:
> 
> Having a sentence for the cover letter would be nice.  E.g.,
> 
> '''
> Fix a bug in _damon_sysfs.py for damos_filter memcg_path setup, and add a test
> case of it in sysfs.py.
> '''
> 
> > Changes from v3:
> > - call stop() for cleanup without checking its return value
> > 
> > Changes from v2:
> > - configure memcg filter before start(), remove commit(), ignore
> >   start() failure, verify memcg_path staging readback only
> > - use print-style error messages as suggested
> > 
> > Cheng Nie (2):
> >   selftests/damon/_damon_sysfs.py: fix memcg_path assignment
> >   selftests/damon/sysfs.py: validate memcg_path staging readback
> 
> From the next time, please add links to the previous revisions [1].
> 
> For other readers,
> v3: https://lore.kernel.org/E4B88E7D4879D1B1+20260601074250.203583-1-niecheng1@uniontech.com
> v2: https://lore.kernel.org/4CDA28DC581FDCF8+20260529090845.1696845-1-niecheng1@uniontech.com
> v1: https://lore.kernel.org/406BD1BA0F6AE326+20260528081039.1192194-3-niecheng1@uniontech.com
> 
> I applied this series with the cover letter sentence change to damon/next [2]
> tree.  If this patch is not added to mm.git in short term (~1 week?), I will
> ask mm.git maintainer (Andrew Morton) to pick this.
> 
> Andrew might want us to repost this series after next rc1, though, as we are
> apparently wanting to make mm.git more stabilized at this point.  Andrew, pleae
> let me know if so.

Apparently that's the case.  That is, we are now quite close to next merge
window.  We want to focus on making mm.git more stabilized and therefore ready
for the next merge window, rather than adding more changes that no really
urgent.  I understand this series is not really urgent.  Hence, I will request
adding this to mm.git after next -rc1 release.  Let me know if you think this
is really  urgent.


Thanks,
SJ

[...]

