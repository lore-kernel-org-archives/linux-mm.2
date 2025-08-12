Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEB3CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 22:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD27C8E0198; Tue, 12 Aug 2025 18:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B83268E0196; Tue, 12 Aug 2025 18:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98A68E0198; Tue, 12 Aug 2025 18:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98CF78E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:17:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 138171401AE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:17:48 +0000 (UTC)
X-FDA: 83769518616.19.1D62F8F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5F92F1C000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:17:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VZPhh9am;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755037066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5IWbpJwkegh37kivkIDabXoZKQHmlDu9jNN//8eXvQ=;
	b=ELuYB2WB/+fz0SOrk8frKDIq+bGwJpZSyXy8tZxqkTRk5kiB/WJnfGmEC8pX9OFeNMrgKd
	99m0H4KCbrEv9InYoC6XmMIOEYHtGEWeSzqyN8HGM7TeBAVYMVt1SRVYEsM8wrshY5G01G
	76lrdJR8+t+b++LB2EP+yWMTW+CA50A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VZPhh9am;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755037066; a=rsa-sha256;
	cv=none;
	b=bW3ope4Rh0aUzu1axB5TBCRPA7PUgjto+OdmEvXpqnhIroHh33NW5Ai9ootcsMVELsA3ef
	qkH06QVUnHemVnWW0LC8areJMnz9FjUkShnV/4FfedKvuIDxsYwhe5eQklC5nqyn2UBLJY
	pgpD/EhD6yHEJ1Xp4QdTf/aVcb/ep2Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 2AA675C69E6;
	Tue, 12 Aug 2025 22:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38371C4CEF0;
	Tue, 12 Aug 2025 22:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755037064;
	bh=miipKiTqF7JpECaUEluYI41x3HMUaCIGaCjb5/2xIkk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VZPhh9amNgD6bU+DfrwnuclBnrQ/9RE3gflGp5IJCrnEth70N5IVPntS17Hhn6Kj9
	 j2fTn1iK+41SHXmIYhXgI9vs985Cl3cOMjSk3n+z8wk/nYjDNifiGJLC+H2OnL9lmc
	 nNW5TFGEtCbnJtyRn4QjdVzPyT0y1+wvZadAEzRA=
Date: Tue, 12 Aug 2025 15:17:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>, honggyu.kim@sk.com,
 damon@lists.linux.dev, linux-mm@kvack.org, Alexandre Ghiti
 <alexghiti@rivosinc.com>
Subject: Re: [PATCH] selftests/damon: fix selftests by installing drgn
 related script
Message-Id: <20250812151743.570bde54f31007cf986a2f52@linux-foundation.org>
In-Reply-To: <20250812175939.57506-1-sj@kernel.org>
References: <20250812140046.660486-1-ekffu200098@gmail.com>
	<20250812175939.57506-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5F92F1C000A
X-Stat-Signature: edas5uy4srijgx1ibjhoj53t8ddgfctx
X-Rspam-User: 
X-HE-Tag: 1755037066-44428
X-HE-Meta: U2FsdGVkX1+Ea/gVaN23UsbWPcZeVLDZwSozYWXboD8qFzlD/YGV4aMxCN3CPCZaNZyGQaOlpz72ndnd60zZCYoNrEooKHgvHRqJ7D1bqgrnd6uzO3bLYYMnJDp4j++h38vF5gn7O5I+WzvowrvZA6HXB1eTJ+1yQ2E+R1njcTpXeA51MHHR5j7UymXfyjDjP/hHW6ztloKBUffl6eQ71wjl/YMrL09R1It21rIG8ekXwqb6xgIfweCQ1dKzGsChY2dXchn+LOeUbgi/XmrcxJ202yxeBD2KvnQ57BQH6Q4I+gy5QDTVgFqGXxOoZ9PwcnYe/ZPT4gtup+vFRAniMz07xJQudj8UpqivVkmLu4vdLVeS61AMpNgzFMXRg6t5UPsW/y4QOVOGCG7JbRPK3gtNTg/zajhTGhCXR0blwg5+jk5c+nhulRShGKXA3w8llLMVN90qEpxyxysC85HngtW8D8bhVC8JmerZeqsfAi8GfkSt0qDw7OYaurrNnpezA91QO9aH/4cHQYQvu3+sw0U6eRhzVjycY2cD1+kIoKC4TgL6o7RcBTHvd9bIYYjfYB82xVD6v9NGRxkQlxzymvJcAsRGFSwVxZPnlkCSAahwrboaMVPj0krGCIgTfww8bSbUexHOiSE/WP7bgL4ulMLX4h/4j2/1joa4HzrStrCo33vuddwJjQRvMunGr3+92kD6MV+/FcZvRqNtn2uhkVOmP9E2JxpKgnxMiIvt/fq6X72xeos3COro5k6bYEi9Bzv9T0UtFfayUFQjEpZXH2Fwbyy7NZbOewpJPX55eHoUkLTtj+KgT+oMWxhLHVnLlY0gPvo45ZUcyPZ4Nb5s76o4tzzAoPd+qY5d0YYEMeYo2h20DWeOmGLvEV3E0rC+XF2CHRETN9DjyBaRZPw/FlSUDF3KL+UtzBDXNSctcyENztBJvgzICRSXB/NlZEE8VWhpghUUvabdzXQ5JBc
 QukzLBnz
 3IfyOHJEZXI3ZnoynlFPtrVGOP5ECCXHEX5d9Sri84p+2cxvY7pNuDYmCDK3XGh9PkitEb4iLY0FiEk/uHuf9jNRVGux/Uu/Y170HTG34UtdZNbzJ7BlriYsXiDUmdzF8+VqEL7M1e52CxEXHpiLIvuNVwwGzhxPohBadgf1oy3PCnlA+GrX7z6UWgPnEC16LAEAtTOH6TTwu9mk0gpnYmYsCCpRD1xZ45m/eMp858b9lNZ9oAt+aY8lx0oco9tN9QkCwJ0hzkxfWvyqRqykgMMYSoQnPqNZsUOHG+iB2PJdCS0BFfe72TkRnV/7XApK0uOTA2Da11t/ezT8T3SKfKf7nWkU6osV6+VYo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 10:59:39 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 12 Aug 2025 23:00:46 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
> > drgn_dump_damon_status is not installed while kselftest setup.
> > It can breaks other tests which depend on drgn_dump_damon_status.
> > Install drgn_dump_damon_status files to fix broken test.
> 
> This patch conflicts with the similar one from Alexandre Ghiti.  Could you
> please rebase yours on top of Alexandre's one (and mention the dependency on
> the comment section under '---' line), unless Andrew resolves the conflict on
> his own?
> 
> > 
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

I'll add

Fixes: f3e8e1e51362 ("selftests/damon: add drgn script for extracting damon status")

