Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A235103E2F6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 23:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 565736B0088; Wed, 11 Mar 2026 19:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53CD46B008A; Wed, 11 Mar 2026 19:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4459F6B0088; Wed, 11 Mar 2026 19:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 327346B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:55:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6322B9A49
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:55:51 +0000 (UTC)
X-FDA: 84535442502.11.89D915A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2F936160003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:55:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sC7IXli4;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773273350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tXplmyFxUyjMbLLcv6E3wqsd04FJlq4/CPuUQIdEi4=;
	b=7Y5Vz1PeC71k9DAGajB3ydunB+5LzLC+YlwMRLf06yDpt58q9nrdE8UPJDeZJNcoz437EO
	0mPUm8jsDWVnWKgG3RN64sAlLnv+H1iR59kpHx1dssNxvEYh/8P+svqX/pfMKvn9AANTlr
	nhXTNPfjFYuCLWMhbmqehoQ9QFd5l54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773273350; a=rsa-sha256;
	cv=none;
	b=0hY8FoonTk4Hhr6kKUO64X+uzUdJP//WD1aXk9ymML1j1U+kAUteMSjzezojzZp+BJYF+m
	MzObDc1mLxUWdWi09BkYgLK0BsmO78plgD6FzeEy6v7BXGSBCxs1ouBCDEXU9S62NQ0RtY
	WfQj6PWpbwHN+pxAWBsLX9FgYqqbcM8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sC7IXli4;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C63460054;
	Wed, 11 Mar 2026 23:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2720C4CEF7;
	Wed, 11 Mar 2026 23:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773273349;
	bh=SqqZK3fLnH0EXSor/M11rWVZrSeOmcU9VgZBss3FPWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sC7IXli4fFSxodAZXvBBNWaXmlfiKo1prMfpjoR7amoYQUbIwLMi1V2H6IbEuMT/j
	 is7Xq3Q2DNhIQGnBye4+7OtSK9pnNDLkdINYa1z4EjTX8cE1iV/+ukpKLn3zs6R9z9
	 mJIFt4CW3U0BPsIdpST5zrejJsBhctsO4hZoGi9SPFBIaBJWnj2M5fsQCf76IyVUM8
	 nFohrN6vZi20t676UnSqgpEiPZbENuDmpER9rDMu/GgzsiRVwmAYooWiPpvizYEJYy
	 L2+4hKuDJzLH0Jd0anLgGPDCKBxMSbs2x0fkqLn3pfQbBVxyohT37F3Sf3c7aaH0RM
	 0lXR0jHw/9DKA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/damon: Support hot application detections
Date: Wed, 11 Mar 2026 16:55:40 -0700
Message-ID: <20260311235541.99654-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311143912.96834-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: c8uthzt7f7jhuonxkb31dbrcpfeu8684
X-Rspamd-Queue-Id: 2F936160003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773273350-660590
X-HE-Meta: U2FsdGVkX1+ZPK3zm1wC1aURncuQ6o5BLSi/X3Q/rgrcjqAyjBczCDrAQni9zrMZq6FiU4esHE64k8/1NIFUFzWX/oLFuEK9xi/1Ove1uooFfs/GByxyT3jKBBLvMpM/L/BK8I5AMYUZC0iO64Y32gFqUKycceVhuJqWPXRGp44lho8n8vDXMhnMihfZtuc7sBjVd3w4pXCS6RQtly5uSvDV9ZPQUZ+oNOX2weJsl3pCeby4W22oqYjXNG7aL1iuTTCeMLDQNMSF2MfZqSvRcdz03iIhl2f8IKe1FVAvZHb/QeBSGRLlG4fE7afBz4enMcrS7ZoHCWOc6NrlI194ocJOS+n0DNTlDjVwIskT2WZ+haxUbNVKpn8G060r89w74vxAjbfsydoxrNJXuczx1xGYRQPXK//1B2pI9WQiNyHH+3Ra8/9ipkB9hImG4Er0XkHrHHrg5UB8D5w5RPlvqouStReykhY1KlubYvUjB8F4uaUw8xCnEd3wFbGhKDlG5C0SS6aB5Yjbbchvetz7fnhBXmCpHAMlZ9VEvLZeIh1CQ1EzsJ8TZg1qJ/4ofeYCx6MB2fGhceyraTd0fJqR0QaUG/yp/L0sU5AYbdsoYvm48c6KUnGH3tX7zojiyRtJhYRBk2FFCPWpmwxJRFnj2RW9sCcG1kfb+mjcnU4Hxim6U8spObEhRJu8yxN8dcXrEevbVs6lIbze7T21I93v/XRT7RgBzBC4XhZw4h8iZXfQdiGWcGsv/ZE9Ra5kFFTEPU3TKeVeEdmDajzicaPu6EYKteiiQR9V9uPIvlEPweQMi2XXmUMEBYm3eq6bDP6ZNuOQUnidBuH0Vc+NQBCqyRJahlXj+GQ2oBOyJuh/4pD1TMaoIXZ2m5GEtOLPajPpBhY7UpCLjj5hsjUCgaMxsGvwp+l/Sp6GnY0/oLdQK3fCA87T9IZCoXOUwM5BOCWAVurK4xyUIj41mIfcn8C
 f0ed04mr
 8BdfC+x77e2Qyn+tDl7+XlLAJTLAOM3yFstnIlYrO18sEaRatYFxAuaEGfDBTAJW+e79lRksAamlgRhxnqrCUqrZQYZ9kt1bSzEpjNUxUYdn5O10QrkclVgpkvGcvQKnmevhC7NQ6+h4zFPHxrWhqUso1xpXHEdYAvsSRGn0jhwrazvlhopA3TGR9jk0JXvHfVxyC7nz5QUmVaV64LaozItueZUpNuFuRu25+8O5A8g0C5lXng2JTUu/zG3mn5RO0dRUwQ0uZQXYOjNWPhPs4T25H3gf2OlfOKwoWVecaN87sTgHCh9gClP5usN48vRvWH4u+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 07:39:12 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 11 Mar 2026 16:08:56 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
> > Hi SeongJae,
> > 
> > On 3/11/2026 8:07 AM, SeongJae Park wrote:
> > > Hello Asier,
> > > 
> > > 
> > > Thank you for continuing this work!
> > > 
> > > On Tue, 10 Mar 2026 16:24:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > > 
> > >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> > >>
> > >> Overview
> > >> ----------
> > > 
> > > Let's make the legnth of the subject and the length of the underline same.
> > > 
> > >>
> > >> This patch set introduces a new dynamic mechanism for detecting hot applications
> > >> and hot regions in those applications.
> > > 
> > > Seems now you offload the hot applications detection to the user space.  If I'm
> > > not wrong, you should remove "hot applications and" on the above sentence.
> > 
> > You're right. I was not sure whether changing the RFC subject was right or not.
> > I will change it for the next RFC version.
> 
> It's fine to change the subject.  Please feel free to do so in the next version
> :)
> 
> > 
> > >>
> > >> Motivation
> > >> -----------
> > >>
> > >> Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
> > >> hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
> > >> fragmentation and memory waste. For this reason, most application guides and
> > >> system administrators suggest to disable THP.
> > >>
> > >>
> > >> Solution
> > >> -----------
> > >>
> > >> A new Linux kernel module that uses DAMON to detect hot regions and collapse
> > >> those regions into huge pages. The user supplies a set of PIDs using a module
> > >> parameter,
> > > 
> > > This sounds reasonable to me.
> > > 
> > >> and then, the module launches a new kdamond thread to monitor each
> > >> of the tasks.
> > >>
> > >> In each kdamond, we start with a high min_access value. Our goal is to find the
> > >> "maximum" min_access value at which point the DAMON action is applied. In each
> > >> cycle, if no action is applied, we lower the min_access.
> > > 
> > > So, this patch series introduces a sort of auto-tuning of the hugepages
> > > collapse hotness threshold, that implemented in the new module.
> > > 
> > > We already have a sort of DAMOS auto-tuning feature, namely goal-based DAMOS
> > > quota auto-tuning [1].  Have you considered using that?  Of course, it might
> > > not be able to be used as is.  Some extensions, e.g., introduction of new goal
> > > metric, may be needed.
> > > 
> > > Yet another approach would be implementing the auto-tuning in the user-space.
> > > Because DAMON parameters can be updated online, updating the min_access from
> > > the user space should be doable?  Given the fact the module anyway require
> > > user-space control for feeding the list of applications to apply access-aware
> > > huge pages collapsing, I find no problem at user space driven auto-tuning.
> > > 
> > > If the goal-based DAMOS quota auto-tuning or the user-space based auto-tuning
> > > are feasible, all the controls can be done using DAMON sysfs interface.
> > > Introduction of the new kernel module might not really be needed in the case.
> > > 
> > > We have DAMON modules in addition to DAMON sysfs interface for users who want
> > > to use DAMON for a given specific use case with only minimum or near-zero
> > > user-space control.  In this case, because it is already aimed to ask the
> > > user-space to feed the list of applications to apply DAMOS-based hugepages
> > > collapsing, it seems a new module is not really needed, to me.
> > > 
> > > But I guess your use case might have some special restrictions that really
> > > require use of the module instead of offloading the auto-tuning to the
> > > user-space or DAMON core.  Is that the case?  If so, can you share more details
> > > about it?
> > 
> > I haven't figured out how I can use goal autotune to change the min_access.
> 
> Indeed, it is not a very straightforward feature.
> 
> > Your suggestion about moving this to the user space sound good.
> 
> If it works for you, maybe that is best for you :)
> 
> > 
> > The idea was to stop lowering the min_access as soon as collapses occur,
> > since we don't want to lower so much that we start collapsing regions that
> > are not very hot.
> > 
> > Maybe you can suggest a better way to do it. Maybe with autotuning.
> 
> I will add more detailed suggestion soon, by tomorrow or a day after.

First of all, as I mentioned on the above reply, if the approach of this patch
series (starting from high min_access and lowering down until some pages really
be collapsed) works for your use case, and you are ok at doing it in user space
approach, I think that should be the best for you, and I'd recommend going on
the direction.

But if you want to use the aim-oriented DAMOS quota goal auto-tuning, maybe I
can suggest following options.

Let me start from the basic background.  Using aim-oriented auto-tuning, the
user can set the aimed goal of a given DAMOS scheme.  Then, DAMOS automatically
increases the quota if the goal is under-achieved.  If the goal is
over-achieved, DAMOS decreases the quota.  More details are available on the
documentation [1].

So what you need is finding a proper goal.  In the hugepage use case, I expect
the goal is an amount of hugepages for the application.  Say, the goal can be
"making X% of the application memory hugepage".  DAMOS quota goal feature
supports multiple types of goals.  Unfortunately, there is no one for exactly
this example goal type.  There can be two options.

First, using 'user_input' goal type.  It allows users to directly feed the
current goal achievement to DAMON.  You can measure how much of the
applicastion's memory is hugepage and feed that inofrmation with 'user_input'
goal type.  If user-space approach is ok for you, this should also work.

Second, implementing yet another goal type for the use case.  No single quota
goal fits all, and therefore we are adding new quota goal whenever it is
needed.

But, again, if the approach of this patch series is proven to work for your use
case, and it is ok to implement it in user space, that should be the best and
fastest option for you.

Also I don't know your real use case.  Hence my quota goal based approach
suggestion might make no sense at all for your use case.  If you want, I will
be happy to learn more about your use case and suggest another option.
Nonetheless, I'm also only struggling at finding the best way for utilizing
DAMON for hugepages, and therefore trying to get some community feedback in
LSF/MM/BPF [2].

[1] https://docs.kernel.org/mm/damon/design.html#aim-oriented-feedback-driven-auto-tuning
[2] https://lore.kernel.org/all/20260211050729.69719-1-sj@kernel.org/


Thanks,
SJ

> 
> > 
> > > 
> > >>
> > >> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
> > >> collapse synchronously and avoid polluting khugepaged and other parts of the MM
> > >> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
> > >> which needs the correct vm_flags_t set.
> > > 
> > > This makes sense to me.  I expect DAMOS_COLLAPSE to have some advantages over
> > > DAMOS_HUGEPAGE for some use cases, similar to MADV_COLLAPSE vs MADV_HUGEPAGE.
> > > 
> > > From my perspective, this patch series is introducing three things.
> > > 1) hugepage collapsing hotness threshold auto-tuning, 2) the module for running
> > > the auto-tuning, and 3) DAMOS_COLLAPSE.  To me, it is unclear if the first two
> > > changes are really needed.  I will wait your answer.
> 
> Please answer the above questions when you get a chance.
> 
> > > 
> > > Meanwhile, the third change seems reasonable and not necessarily need to be
> > > blocked for the other two changes.  I think separating the third change from
> > > this patch series and upstreaming it first could also be a path forward.
> > > Because the change is simple and sound, convincing me would be easy.  I'd be
> > > convinced if at least some reasonable test results can be shown.  I'm not
> > > saying we should drop the other two changes.  We can keep discussing those in
> > > parallel.  Rather, upstreaming the third change first could help finding real
> > > benefits of the other two changes, since the testing will be easier.  The
> > > decision is up to Asier, of course.  I'm just sharing my two cents.
> 
> I'm also curious what you think about this.
> 
> 
> Thanks,
> SJ
> 
> [...]

