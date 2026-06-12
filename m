Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E99CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9296B0005; Fri, 12 Jun 2026 06:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A4A6B0088; Fri, 12 Jun 2026 06:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FE26B008C; Fri, 12 Jun 2026 06:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96E8E6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:39:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D9DC1C3B02
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:39:39 +0000 (UTC)
X-FDA: 84870914478.21.085228C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id A607CC0009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:39:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fnIsnV3y;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781260777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqiV790zEvyRLcm0gWc4S1J3hXlHamb1bPXX4CuLsi0=;
	b=xtno1RO8OnyO+YwzT4lCVFgzjbA0rfg/FPG2lffnqV1pK8MH5jniRBKBViJKvI6l4lDX5S
	X48Ng0+oAzPtrWIgUPfNN1+aZbKRMYXhfNzAnvz7JZIvwncvDb0MBbdJc1KffICahHHyzi
	F9JDi36CVSn8F37/MI0C6OC/I7t4kTY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fnIsnV3y;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781260777;
	b=GdwUsJTQsxm7uBZpoBAR+Xws75KZI0LihzaI5DUD35uzvyztiwMCUYK6CN/0QtQt9spu4W
	m7G8CNNT/B5tB8DhOgFWD3ryZ0lWYqRi6ctVWUtDgJPA+XqApdzqf0VFGMlKztjqtyBiNk
	Wq5pPj9QLf5Ijb/VmWpGFRwBOwqDp0I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NqiV790zEvyRLcm0gWc4S1J3hXlHamb1bPXX4CuLsi0=; b=fnIsnV3ykoZi4mVYkoDyye/INV
	69lBYsqLq4UvFK/wovjBpHDMpmShA07v4bUpP/6v5MsdeIURTcSEqlszMi2nFvIY+mhh9b3gGwa9V
	ZAqMizSnfSFpceDt7iP64/fqx760xE57JK8SqanRX6YUopv/kM5izoaXQpf2YUZSGnMPYkGvT8N88
	svc62gzydJuJCmdbot+kGqCIHaWwY0ckWAUhcyhTWyE0B1H4lXR7E1XVaeDDJ0kDFEqrkGFfT7g9p
	pL1oPL88zgydPiJH/txPJlE6WlUyEld6mGM3sqhFsIeDGEgMVMrbB7ea7uSLXutVvFjci0vrAuJ/q
	nQcma7eQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXzIQ-00Ag0Y-1W;
	Fri, 12 Jun 2026 10:39:30 +0000
Date: Fri, 12 Jun 2026 03:39:26 -0700
From: Breno Leitao <leitao@debian.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, sj@kernel.org
Subject: Re: [PATCH RFC] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Message-ID: <aivhX7RtLVwBkNj6@gmail.com>
References: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
 <20260612031605.58235-1-lance.yang@linux.dev>
 <aivJ5Dv0hAQ1sJu1@gmail.com>
 <6bc446b7-8e25-4add-9d72-a3c9e9191533@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bc446b7-8e25-4add-9d72-a3c9e9191533@linux.dev>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: x3ppt5s44con5mq3h8pj9sgm4k5gxyjc
X-Rspamd-Queue-Id: A607CC0009
X-HE-Tag: 1781260777-193149
X-HE-Meta: U2FsdGVkX1+o6hyfbIhHttbITO2KOhNbJ1kt+y47/PCSxbPFh5xWToZB/3+5RHgFYs3wawgRhgHuyD5xl2OobpPw1oEqYK39eX/iESLae9CQwrrwYQXs7ko8ZwPUEye2zfgURHQthVRI4PTwqrTK3q9Pi6e1WpGGEsqJgtK/3wgZYBE47AoFxbytZM/hLoDTgplgvDZrfgjSomy8f6s8iDx/1SAwh+xTNPQkIxGYBcFxi+2D1MhUIVC5WuQX4tM9dWI5X+cBAnpKEeAslCSyxA7XUBUSVCsODRYqh03R2vRXkzcxhDVf2E8Q3HkZlOO21usEG7ZRRU1LpVEx2cBoBBjuUC0XnjT7HpWB3xULh2yYWtvcDwb8/XJmjBOT9IcKYIzJ3E4AQbCZW+JJIdoRoJVHqnNJIpGcyqq+KB3snqrRY/U47PchrBAXaXVDCSrU1+yfLENaV7alq2ybMwKv3pw6xhA1xf/V1bV0A8rAv7rkVG8u8WUrY/2MrD+okP0V/yqBfQliS+h7APBDKqQEtWf4ZfUZTZu/Ufnv6Lt4eS19tGF0Qpb4VF99+mgT2iPd9u18jy2VtW1UOcSl9n0b7Q1hmhBA7jxqYKvKcK+6akUfEfynpRx7SUZNk5HMvK+Xow8EXoOS2wn7sF3mN4HP/gSuP3edcrrIoU/NvsDJgELxOQ0Dkh1I6T40je5qV8dWTDQ1J7Y6rWW0MorlAddOhG2PxZ69nGpO8xXLuh5yK1UO7DDXcxdS0nQ5qKJ2Kg04Thrki7G/40RBBqDO2JISOIn56+dVnmefyyfvChI5HyOj6PUoHeHbGEAY3Zzgfas6KTut07rWpkjZWOCxxqefkk7EObcQ7Mxnacpxs/wFdbKcD+wOEuRN0b/1Q9uG8Y4+Fc0EoaH8SvvxixrS25a4ZQqVOgMEvWNaRC9jNTUVC6E1zc5flIzfL/8+f93O1GipD0N7M3fQpI5q4Maa4aM
 pU4yOZGB
 YHWjUTH4x3Ep5kWNmSW9Rx+rAjCBJJyocaon0EAu6Wxt9+PEYK4ZaED/d+fpfoxEDLpSeb93QDQmfZNVuK8jSO0riHr16HrnuyBrOCfCe7RzlKwmZx/XMMv1z3mJtyMJdBN2kk6ox/nSyjUXMItgdQzlQHsC+NvajcHqq7E1FEIgQo4tijomhnN2uFS9Vi02D3OAQOshqZa3bR0VXIvACx1LmlOz0OOZMVZgtrjCVQ4GUnFEx2sOCd5OcLxkxnsy7U8Tv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 05:57:12PM +0800, Lance Yang wrote:

> > If we go this route, the aborted round has to suppress reporting, reusing
> > kmemleak's existing "scan was interrupted -> don't report" path:
> >
> >        if (need_resched() && !kmemleak_stack_scan_break(g, p)) {
> >                aborted = true;
> >                goto unlock;
> >        }
>
> I'd expect the normal case to just drop RCU, cond_resched(), take RCU
> again, see both cursors still alive, and keep walking :)
>
> >        ...
> >        if (scan_should_stop() || aborted)
> >                return;
>
> And yeah, you're right. If we do lost a cursor, bailing out and
> skipping reporting fot that incomplete root scan should be the
> right thing, I guess :D

Thanks! Under what circumstances would the cursor actually be lost?

