Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2974112583A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B5C6B0089; Wed, 11 Mar 2026 10:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948B46B008A; Wed, 11 Mar 2026 10:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854996B008C; Wed, 11 Mar 2026 10:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64AC56B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:39:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAB91140252
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:39:24 +0000 (UTC)
X-FDA: 84534040248.29.343D0C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16C7A140013
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:39:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LT2IU5HN;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773239963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLaRO9HrLdWWHPt+r6T/FIB8Wh+F9CShB8UYXFZt6pQ=;
	b=yRxB4cGZEqKmI3hW+kGUI1EsYVihao4AMnar2GNn5wjLUmBmDlMwUqSalHTOqa4/ZnxOGW
	E/T7h12xWD8M0hv9PPhEyuxVGqaS9S7jH0K50b9VpL5H9+eY9JXxeUOssbAN+ICc19v7wa
	ociwDm/svuEjV31lEdO1IRNo9bKCnbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773239963; a=rsa-sha256;
	cv=none;
	b=VRETR5XDoNyigW6X6fV3SKFwalCCRByj+b4HUpBYVxAKusJGsYO5EJ7rHUTlndlydtEjqL
	Kl4AypSJ0sLhMYTY0MgJFG13URtNpLkCwqvDbX6MGxG5B8d0XrtDzMtCxGEj/WN4Yj01fF
	HUH0kWDT28VFlQ2zxddLZJxJ5Ee9IPk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LT2IU5HN;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CD154404D;
	Wed, 11 Mar 2026 14:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26ABC4CEF7;
	Wed, 11 Mar 2026 14:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773239962;
	bh=NJ10AZXdscg+DvMqnyYzr0It1WL0JuhQV8FD7xqijPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LT2IU5HNWxB0iJ9LuNGYfyn0SEQ15nR4YpdC9Swgnko7sYltMJyqQ00h5IO0OnX3w
	 httHIieCaSHUABplizTeBVYaHellks5Rqr0UrYpFiMAgvWA5sQUIovsx1bEsKUuCFc
	 zepKlIOgdIPkU+S0gO64kMVMzNLTavCytAnoqpeye8ANKiclih2r8wIF7XHvb/pE5L
	 20Z1s0unzplcxO5ABRZH5WyjR93reDTgeIpd9l6kHQXZQSvNgFQw0teErwsKaTHSep
	 0i0mZKTHeRpoTka4EQQ8pNUdofPmuInPebfnmcd02gmrKku+fCdzsTCjfD4YsnNJFX
	 v4ZzV6uQrObLQ==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
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
Date: Wed, 11 Mar 2026 07:39:12 -0700
Message-ID: <20260311143912.96834-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <577a2b92-3507-400c-acbd-32c914d374b7@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 16C7A140013
X-Stat-Signature: xkjhhizdsksf3jmynfsb8cwufr4anuin
X-Rspam-User: 
X-HE-Tag: 1773239962-442326
X-HE-Meta: U2FsdGVkX19cnH73+AkNMTIPfC0PDPjI8Mm4mNYYxzZV9QYC2bjGBLFoywtIG3K5tSENSZVswpeDNIKCYXEAlSYCcdtMIE9SsfsUz2a2i6WmDuUUjrYgOdZNbVZn9v72BFbqednJ2egh4s1cJaFWlWdhj07VLVFtc7oY1Jg94N848ecMwEz4YbvlhQjODW9HzMcizTYrFJb69WZxCWbpoIVL25n0+WQA+ERigSVTluDHWMh1vXCt4Pz/5tCSZlKL4ZsiZG7nUBvZZq24z6QmVvhrn8pde+FKDin7rmUsdb9WLi4w9asZIXh8kE4v4PZYcSISu7nDBusbP8TLcdsmttrckdXXctiunMD2OlxA40Cl1DH/ckDvcyvDbDs8Pp8tukM4PxTJMTwaQpVeBaBzCqMjYYHYhUy5yEbR7J4MuJ2VEOznD8Eoy8toUUgX8I/0+KjCA3qDvX7V0Lwt2O6npyv/Ay4EkkvF18cqIFibB2b5rVW+syGqmfw1XWeJV7vGsvc30BYu7GjQH1DMVxhoKZmrk2xJhXUmqbYyz+UcDuLgJL8fneBsNqLQ7gdaPR2hUna11lCwSBVTjiE0bzJ0LtlK7Ds0i/3SZ59pcK0PQjgm9CKTwTQq7vkG3kKn2TnhqrHOZboXi72fezWBl/uiVDwB71u+Y0QWTJFWUsU4KkNb4vF1zgVEX7oE0cY/1WyAG66X05Aws8XQxdCLi6+jDW8Yvm/narQxV8u7G+YBo0buq6rZoi8V2wzgNVHdTJ246iLa2Y/wSFHkF+0CFgFvj/lHTN5A3oeDDFMk7VqZD/c+fPa5h0MFkLZqIf73LUrb3ByVpCAB9//b5BA7WvhaC6InM/F4adT1wqN8sz5HsXJdRv/spsRoZovuMThOhlxa9ZT9hWR5uw8L3HlsivbZ+24ym/f+NZSRsTR1M0gPaQfsS/7z1/lPFbz2BLZzIcaXqJ2cNMFe2eeylcjvAUJ
 p8yYSEd4
 rXMKsKgzXrWzPe1AjMCTbSounIxNjyYSI/zVKeer+H3iXnM+cbxQKZhQQ4XFxEyvaLXkx5nrKO9fkcNTUZIaUeocWggIosd6Sws5CHeNZFe+0yORN9ffeT183NstggKvNzV+FLm4a8YXaNI3mGE/hid6LOhpYs/8/9/e0PykJL3sVezl/FhUm6V/v+CPQv3Q0qv32U8b42EKL82IOGZbIEsmo0GuJMDZMSgnmxw0lfX9al8CTtNyZc2Bw8y3HpwvwjEbORBdUZU8Zl+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 16:08:56 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SeongJae,
> 
> On 3/11/2026 8:07 AM, SeongJae Park wrote:
> > Hello Asier,
> > 
> > 
> > Thank you for continuing this work!
> > 
> > On Tue, 10 Mar 2026 16:24:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> Overview
> >> ----------
> > 
> > Let's make the legnth of the subject and the length of the underline same.
> > 
> >>
> >> This patch set introduces a new dynamic mechanism for detecting hot applications
> >> and hot regions in those applications.
> > 
> > Seems now you offload the hot applications detection to the user space.  If I'm
> > not wrong, you should remove "hot applications and" on the above sentence.
> 
> You're right. I was not sure whether changing the RFC subject was right or not.
> I will change it for the next RFC version.

It's fine to change the subject.  Please feel free to do so in the next version
:)

> 
> >>
> >> Motivation
> >> -----------
> >>
> >> Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
> >> hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
> >> fragmentation and memory waste. For this reason, most application guides and
> >> system administrators suggest to disable THP.
> >>
> >>
> >> Solution
> >> -----------
> >>
> >> A new Linux kernel module that uses DAMON to detect hot regions and collapse
> >> those regions into huge pages. The user supplies a set of PIDs using a module
> >> parameter,
> > 
> > This sounds reasonable to me.
> > 
> >> and then, the module launches a new kdamond thread to monitor each
> >> of the tasks.
> >>
> >> In each kdamond, we start with a high min_access value. Our goal is to find the
> >> "maximum" min_access value at which point the DAMON action is applied. In each
> >> cycle, if no action is applied, we lower the min_access.
> > 
> > So, this patch series introduces a sort of auto-tuning of the hugepages
> > collapse hotness threshold, that implemented in the new module.
> > 
> > We already have a sort of DAMOS auto-tuning feature, namely goal-based DAMOS
> > quota auto-tuning [1].  Have you considered using that?  Of course, it might
> > not be able to be used as is.  Some extensions, e.g., introduction of new goal
> > metric, may be needed.
> > 
> > Yet another approach would be implementing the auto-tuning in the user-space.
> > Because DAMON parameters can be updated online, updating the min_access from
> > the user space should be doable?  Given the fact the module anyway require
> > user-space control for feeding the list of applications to apply access-aware
> > huge pages collapsing, I find no problem at user space driven auto-tuning.
> > 
> > If the goal-based DAMOS quota auto-tuning or the user-space based auto-tuning
> > are feasible, all the controls can be done using DAMON sysfs interface.
> > Introduction of the new kernel module might not really be needed in the case.
> > 
> > We have DAMON modules in addition to DAMON sysfs interface for users who want
> > to use DAMON for a given specific use case with only minimum or near-zero
> > user-space control.  In this case, because it is already aimed to ask the
> > user-space to feed the list of applications to apply DAMOS-based hugepages
> > collapsing, it seems a new module is not really needed, to me.
> > 
> > But I guess your use case might have some special restrictions that really
> > require use of the module instead of offloading the auto-tuning to the
> > user-space or DAMON core.  Is that the case?  If so, can you share more details
> > about it?
> 
> I haven't figured out how I can use goal autotune to change the min_access.

Indeed, it is not a very straightforward feature.

> Your suggestion about moving this to the user space sound good.

If it works for you, maybe that is best for you :)

> 
> The idea was to stop lowering the min_access as soon as collapses occur,
> since we don't want to lower so much that we start collapsing regions that
> are not very hot.
> 
> Maybe you can suggest a better way to do it. Maybe with autotuning.

I will add more detailed suggestion soon, by tomorrow or a day after.

> 
> > 
> >>
> >> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
> >> collapse synchronously and avoid polluting khugepaged and other parts of the MM
> >> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
> >> which needs the correct vm_flags_t set.
> > 
> > This makes sense to me.  I expect DAMOS_COLLAPSE to have some advantages over
> > DAMOS_HUGEPAGE for some use cases, similar to MADV_COLLAPSE vs MADV_HUGEPAGE.
> > 
> > From my perspective, this patch series is introducing three things.
> > 1) hugepage collapsing hotness threshold auto-tuning, 2) the module for running
> > the auto-tuning, and 3) DAMOS_COLLAPSE.  To me, it is unclear if the first two
> > changes are really needed.  I will wait your answer.

Please answer the above questions when you get a chance.

> > 
> > Meanwhile, the third change seems reasonable and not necessarily need to be
> > blocked for the other two changes.  I think separating the third change from
> > this patch series and upstreaming it first could also be a path forward.
> > Because the change is simple and sound, convincing me would be easy.  I'd be
> > convinced if at least some reasonable test results can be shown.  I'm not
> > saying we should drop the other two changes.  We can keep discussing those in
> > parallel.  Rather, upstreaming the third change first could help finding real
> > benefits of the other two changes, since the testing will be easier.  The
> > decision is up to Asier, of course.  I'm just sharing my two cents.

I'm also curious what you think about this.


Thanks,
SJ

[...]

