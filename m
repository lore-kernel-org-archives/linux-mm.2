Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085CFC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 20:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A57B6B007B; Fri, 25 Jul 2025 16:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F546B0089; Fri, 25 Jul 2025 16:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71DBF6B008A; Fri, 25 Jul 2025 16:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB416B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:22:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D979C1A0965
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 20:22:35 +0000 (UTC)
X-FDA: 83703909870.27.AFB9E00
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf15.hostedemail.com (Postfix) with ESMTP id 36D1CA0002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 20:22:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xn3xpQKN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753474954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdJJPCCVuWfhmg0jZ6n6BOcZs1/5WZjszPFRvpiSdjk=;
	b=D4hAk7d9EolXxL2sZO0C09s6d58v7O/EAqQnQ8faCaG6N8R8E/IV7JH6N8G8u+3qKXPz2b
	Skw4rGJhzEcix8hRHQ+pIN3f+3IlAl+/Fj3T55X90Sua/Zj1AlWQMQvWEXlFBqGY4FcDiu
	qoYhIruJ+kASShAiNTp+yfw1OTk7F1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753474954; a=rsa-sha256;
	cv=none;
	b=wTw9ftRzJkPKHcTcysdGXwWRdepSH9cP5D/1Eay3CtXS4XNiFSNFXBRkw+khKLsHpCrC0p
	GQbWFgpN2Fo6k2in3QexToTOMAjWrQ5UEvkTZciiq2tndRsFbkeqC1rwyuLyZH5M03MJqH
	0GLASd8fmMKmoRqZVqIxuEOcTTF9cQ4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xn3xpQKN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 36D1EA56710;
	Fri, 25 Jul 2025 20:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7431BC4CEE7;
	Fri, 25 Jul 2025 20:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753474952;
	bh=VQH99R6mUOjHSDPCGQ/ViR+7iWAEIcbC1txnGPFZ6/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xn3xpQKNtMQWwdNsTNuwnldzsyk6Cg6Io1WAhFbdDLx4l3vevNAC1PJEqz7sIPdEK
	 MJJah0xBI0a6LTP/LXoGzCId2Tba/QeRa8mmHTioJCAOKesx93dWnmoWfT930omNhc
	 nde22gF9Pga5Qs2XTl4FFcCXQNp5BHlrCeRGzYbCGspeVF+Kr8sguo5PJMsQxT1fWY
	 8QdIcR+Xt1BsWoLLo1Vo7nbRJ3giTcb8GAIuZXnbQ7XtosUVIAfVEIewEf81/u1xLu
	 ailRyi0u9QJWp6HFxcOmUYj6qEH3PS/vPEg9wGq6Px94H6wSaLBCbfWri9anFGvdTR
	 V0guoV8IlfdYA==
From: SeongJae Park <sj@kernel.org>
To: zuoze <zuoze1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com
Subject: Re: [RFC PATCH] mm/damon: add full LPAE support for memory monitoring above 4GB
Date: Fri, 25 Jul 2025 13:22:30 -0700
Message-Id: <20250725202230.49995-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <a5c871c8-dc52-4245-8513-94ccc2b46c94@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dbns5iko47rr6u4fyyre1693wjbtkbmz
X-Rspamd-Queue-Id: 36D1CA0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753474954-843448
X-HE-Meta: U2FsdGVkX1/hQSPlfZXP9HHfQaODsDjcxdNF3p64A7sbWGjG6d3d7TpFnEuRWf+UkRowFU0Zu57Z/bRTYxawCEKbAuuZWfiFZRbd4xRPLrDz27DQgxMy+uxkQ95xDkEVvdjIov9ES0/SYKmEopvhof1uOSy/MJs8rGlSTADytDzT7U5lHvSIv74F2EqLvay6CtWCfZ/DRzyNXlUjzxBImM03dkwX+5hCNqtMYju3dWRUgb+WdT6QyPc08tLWe5usAoou8yOyZvQFnYxpQgxqeAlCqcTuBMZV4lUN4R9SLgHTlqkCQIQyt3dVbrxBq12txj68TfGnORFoGI8UUzPXtSnuT90wm2RxVBJ8+6d4kKlXsbV8ubhQjFxmLUvqhzJ/opR5D+xjumAocnQ4Qljat/lJiszvKl9QfLz2rg0436VEnx0sPqLzQlZS/aIAxaYTwCgzd5UgeSBK00FHxgqlVgoM6B1oaQGQgQkpOQCRKr+Lg1cJPCpqN/lFaAvr4inq0D1uerno6hzknWWgXXpRxcSO7403tsjtCehE0kVaZmH9FcSq/AXdAj4uRHM/80RRu7RU8jFY+v+HH8qng6+rYPqzvOw3+NR0Upb6oWQswNGk1Ofy2BYI9nnbC3p6LZ6mOCPWj56it6gR1QwDEmfT19L+M14t5J9aUNxQZcRRF3dAQHicr6MTZkj6nC+NRHPJ9M2nQiliDacCZKrz63d0lBwKJC8bRqGrjMgm7tngK0b/xCg8qnf8ICXRL+tX2sUXz8HY8nlevaqXo+mVgcvK5X318lmtsDnYZ0PhKapWeZQHGGZ5XwcCYPFwQd0ZG1j3MRhLkUlttQU1GQp04G0wm800n5NTxTCWiARWyPW9/K24BkLZ5UOSxlH1LAq9Dy5CZMRPh8v9ObyWIzxpLyqbGfu1uU4pgjsSaoRdcaUh1euGnga64GF+boZdOEd1Us88NC4wTC6b2EPKEjMKyXH
 8IX9Az74
 I4x4VFrvuxIzZLwpvCSzcPoFS+rWishdGo1TwjGsrwEExjivfxqbJZAhIRgaSFmSq6xxpBqRtjpkGnGb7tQ2QeJX9nynBaEW+Ku2Z72wJcPyhCQaUTHRd8ARaaSI+SSySpQjyTZof/nGSBHVA000rrkKIYnqM/724aF4XvHmuO63Id6Yynvax6xmNN0cSLaX7jHR1Ckd7NKRygK+irsb9XJOqszMGJSLcGOUtx0au3G+qynkV+pozIDMLYB21waThgfSomTmfj/yEEdE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025 11:15:22 +0800 zuoze <zuoze1@huawei.com> wrote:

> 
> 
> 在 2025/4/23 1:43, SeongJae Park 写道:
> > On Tue, 22 Apr 2025 19:50:11 +0800 zuoze <zuoze1@huawei.com> wrote:
> > 
> > [...]
> >> Thanks for the patches - I’ve noted the RFC series and user-space
> >> updates. Apologies for the delay; I’ll prioritize reviewing these soon
> >> to verify they meet the intended tracking goals. Appreciate your
> >> patience.
> > 
> > No worry.  Please take your time and let me know if there is anything I can
> > help.
> > 
> > I think we can improve the user-space tool support better for usability.  For
> > example, it could find LPAE case, set addr_unit parameter, and convert
> > user-input and output address ranges on its own.  But hopefully the current
> > support allows simple tests of the kernel side change, and we could do such
> > improvement after the kernel side change is made.
> > 
> > 
> 
> Hi SJ,
> 
> Apologies for the delayed response. We've verified your patch in our
> environment and confirmed it supports LPAE address monitoring.

No worry, thank you for testing that :)

> However,
> we observed some anomalies in the reclaim functionality. During code
> review, we identified a few issues:
> 
> The semantic meaning of damon_region changed after addr_unit was
> introduced. The units in damon_addr_range may no longer represent bytes
> directly.

You're right, and this is an intended change.

> 
> The size returned by damon_sz_region() now requires multiplication by
> addr_unit to get the actual byte count.

Again, this is an intended change.  damon_sz_region() callers should aware this
semantic and updated accordingly, if it could make a real problem otherwise.
If you found such changes required cases that this patch series is missing,
could you please list up?

> 
> Heavy usage of damon_sz_region() and DAMON_MIN_REGION likely requires
> addr_unit-aware adjustments throughout the codebase. While this approach
> works, it would involve considerable changes.

It has been a while since I wrote this patch series, but at least while writing
it, I didn't find such required changes.  Of course I should missed something,
though.  As I mentioned above, could you please list such changes required
parts that makes problem?  That would be helpful at finding the path forward.

> What's your perspective on
> how we should proceed?

Let's see the list of required additional changes with why those are required
(what problems can happen if such chadnges are not made), and discuss.


Thanks,
SJ

[...]

