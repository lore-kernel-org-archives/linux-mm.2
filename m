Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791CCCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 00:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9816B0088; Tue, 23 Jun 2026 20:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381086B008A; Tue, 23 Jun 2026 20:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C00F6B008C; Tue, 23 Jun 2026 20:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03A4D6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:14:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68E74120161
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:14:38 +0000 (UTC)
X-FDA: 84912885036.28.71D99C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CFDEE40004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:14:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZxhPaFGJ;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782260076;
	b=QIYzfJONiLPoAFXn/6guhqBJ9kBP2nc06XdQSg+Fr1ud+/ZJeukCEGY9tK4vdk+JuIDZkb
	ZKozgjxwpcOJWAeemJSgKfJit3n/U7QUPQAJhoUSkoLsVXDjdGUmOVuTFP3VR5UKvSlvub
	Dbp+ziphVn0y9vW9xO5JqEaKCVxM3dk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782260076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyDHUTRzyhbl3JgW6awlF0LENI6MedUpPmmBH2AA+70=;
	b=VA0hBYGz/R3VT55ZGb8KWwO9Oj81GgoZm66pNWNCDTY7bKwSlr+N2JWJARSOuesiYcovoc
	cyiHknkeMSMGE6EgE3JyunUuW11icl7guJe8q7E9/nrl1iWPMD8dtk2M2BhR3gL/4U7YYO
	QZkW1lyHufOrsdwNsM6ZQPK6Hw+hNWE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZxhPaFGJ;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AD6260008;
	Wed, 24 Jun 2026 00:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5781F000E9;
	Wed, 24 Jun 2026 00:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782260075;
	bh=SyDHUTRzyhbl3JgW6awlF0LENI6MedUpPmmBH2AA+70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxhPaFGJIvneCPSiKZAgnT6ebQb/mknuS7UoMs6VbJICjq8f1AxNWrOJlibbvSrYA
	 1txgK1l+ul2qd3VTGjtuUlzJsDX3v9jlHwJS3ESgWtHsfyc0lWwN/2K4lJ7Gb0G2mT
	 rIeKVR/4ZoCS0UvmbWnocKEtxbYnpqumAJkUPJe5RMV6i1vvFQuCLzG1/9Mv++cp4q
	 geivMOH8PA7BkP4NkkEg/yFeLYxe/5x1aRJvz+rz83wvMdagGdx5jypSOUQlF8SRyS
	 RTQ2RGfiBvoP9m9fWNHAFyR6uGW7eBbBLbXET8GhvpI5ZnZtcQQ6hbXIhXHaO3vNEj
	 uOIf5MWU0QkRQ==
From: SeongJae Park <sj@kernel.org>
To: Zeng Heng <zengheng4@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
Date: Tue, 23 Jun 2026 17:14:24 -0700
Message-ID: <20260624001425.77489-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <7d46a48c-8805-09e1-4818-807953898fb4@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h5hdbbotm3ewguozfza3jgkbwq6zkdbf
X-Rspamd-Queue-Id: CFDEE40004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782260076-342835
X-HE-Meta: U2FsdGVkX1+mHmGWFjjkERbgGiMak+1l2dVsE0ry36gPpNb8GDn/HtOQLMgyfhEdSulCJWVgiMlvCXxD995a0QR6qvQeO33YbAzrUdMRIGwC8huOVp429jJSx3uL+GTVOkUz0pt0AGH/NyaMwoB03HO1NLy7OBDaSRis0ozYBpIdNXJEQASCUnhjNdksz2VG4a6fcshXhzMjrJFziJPNGwxe968KGS7G/m1BHevC2unxyriNX7UFcqDhIaokEHzBycwBBYsvuZpgLAH9Y4JV6UVi1/bkwbZR5ED/4UAq54wnTUMMJZhhQ5IGfI9w+RzrfwdoFACY211ibLGBYhEYXqA6rcLv9/gdQ0NG3vvhaJJyMyIKLVHdUnHIzmk714j3rLbvExwfNcAGkOw0pW39MtQUuftRUSRs5mnQlN8FxySuWcjU01jsf9rElOggn5dKMNvfUchRLMQozEatahx0bePs4105x6/zhHbz/ch1zhNYfOaYO0Epd0HyJAD8aNKg6aFWiuUb3WVNdTKcBmJGjhm1B34JxkJ8hUmdvCXQxtAmBeawJAYz6N38ip7f20w/HGwhvNkqK2OKYn171PGUYD+WokliaDruwKQ09Q6AnB2Lyy1puUAPlJi7XKJBm+7V8oId/eULoc3ZsQEvSAtrQHrGf4plKIOeED981NNJETfZpYg+tMEjT08FJQJTG1e7P/okNpsatsAoEcikd+DeZ8HjkwZFpw6btMCK4wwSvvN/6BLH2cvmNyVITWTBXQXydIsa7ZEJXtglKgUmk0gjAQINEzJc1ainFfgUWe7I/joyBuZF8axA+t82gW6Q1lIpRSJC3i/bfUAXmJjxUTojGW1F5kjrkJjpDSk4ZoLMTU6GYmLBr8Zh2JlQUtZzCxVlm3NjXSn6Ajuw2l4NTF5MhQt47YLXLcWoWfz+F2qrF8A+WAJ5mD2Mk/JccoC087sNEEyc2xXJVP45Xc98buF
 Fh58BhQm
 5Racb0XgntqFQBbOGOL4Ab8GbvMfL+xD3QTxdEX5mOnaPavXEFMVHcZnOCORzjfPMAXAaeqVAh/gHpVxAYrIn4mG56MTZA619qbV6qYN9K82Gre70nRd4R96cBgl6QYeEypvgvxCQQQfvkrP/Ojye+ID/tDQFZffquZG8Bjqu1AHlSq/Lc7Bh+DyXCVN3Z6GJirzwoJM/E8CgkMWgY7YGXQymTczCmmYLMWhjmaRgJ+Lm/ved5NhtgFCe2OAuVHiqJBl5EHlkxPVW6CcrxcFjl/j/YnhgAD3+NDLkCb8Pk5gZXuaZlmgqwoCte2jUd3ZO1TCyRHZZopiIdP9bVjV/QwLJX7VG3aI5i+8OcmA+r1wrSr6I2xHEbWlojunB7vf/ZaHC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Zeng,

On Tue, 23 Jun 2026 22:08:03 +0800 Zeng Heng <zengheng4@huawei.com> wrote:

> Hi Ravi,
> 
> On 2026/5/30 0:56, Ravi Jonnalagadda wrote:
> > This series introduces a vendor and PMU-agnostic substrate inside DAMON
> > that consumes hardware-sampled access reports through the standard
> > perf-event interface.  Userspace selects the PMU through sysfs (raw
> > type/config knobs), driving either Intel PEBS L3-miss sampling or AMD
> > IBS Op sampling.
> > 
> 
> [...]
> 
> > 
> > Ravi Jonnalagadda (6):
> >    mm/damon: add struct damon_perf_event{,_attr} and per-ctx perf_events
> >      list
> >    mm/damon/sysfs-sample: expose perf_events configuration via sysfs
> >    mm/damon/sysfs: install perf_events on apply
> >    mm/damon/core: per-CPU SPSC ring drain and damon_perf_event lifecycle
> >    mm/damon/vaddr: implement perf-event access check
> >    mm/damon: add damos_node_eligible_mem_bp tracepoint
> > 
> >   include/linux/damon.h        |  80 +++++
> >   include/trace/events/damon.h |  49 +++
> >   mm/damon/core.c              | 403 ++++++++++++++++++++----
> >   mm/damon/ops-common.h        |  39 +++
> >   mm/damon/sysfs-common.h      |   6 +
> >   mm/damon/sysfs-sample.c      | 579 +++++++++++++++++++++++++++++++++++
> >   mm/damon/sysfs.c             |   3 +
> >   mm/damon/vaddr.c             | 267 ++++++++++++++++
> >   8 files changed, 1370 insertions(+), 56 deletions(-)
> > 
> > 
> > base-commit: 4c8ad15abf15eb480d3ad85f902001e35465ef18
> 
> I wasn't able to apply this patch series to the linux (and linux-next)
> mainline branch, and also had trouble identifying the source of the base
> commit.
> 
> Would you mind sharing where this baseline is from?

TLDR: I pushed [1] a tree having this series applied on top of the baseline to
GitHub.  Please feel free to use it.

I think the baseline was a commit on damon/next tree [2].  Because damon/next
is continuously rebased, we cannot get the commit in a simple way.  Fortunately
the commit is still available on my local tree.  So I applied this patch series
on top of the commit and pushed [1] to a branch of DAMON kernel tree at GitHub.

Note that the branch is not guaranteed to exist there for long term.  But
hopefully this series will be merged into the mainline before that.

[1] https://github.com/damonitor/linux/tree/ravi_hw_sampled_access_reports_rfc_v1
[2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

