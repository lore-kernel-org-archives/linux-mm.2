Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB8AAEE57D3
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 07:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15C06B0089; Wed, 31 Dec 2025 02:00:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA1F6B008A; Wed, 31 Dec 2025 02:00:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17276B008C; Wed, 31 Dec 2025 02:00:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B33366B0089
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:00:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72A1BB9E6A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:00:35 +0000 (UTC)
X-FDA: 84278868030.13.9ABF341
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C1C5140009
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:00:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h9aWocLP;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767164433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wVM57awAwWRB+/66TwPMmKCevmMRfaBgEiC/p7DALE=;
	b=V+JfKK84JwPDs5WufclPNdJKO6BcvxFbDoVtpLbjtzZ/YENMj6JftcZZQRB+2zDcMU3lBv
	Ggyqix8WNkBo3D5WL8TzAWVKKtcu+4om+hG9OpUB7JAb7nZVZndeBMLyrQVnrrEYzwzXVw
	IAGKaGGkdjNNdZ5cVRmW7VaaJ8MvwmU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h9aWocLP;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767164433; a=rsa-sha256;
	cv=none;
	b=H5ARtVWWG6/9sWEdCy5fd5bkZpHgku3xwRaohnElhEuUOShhFpzJSE/Fx79dwgttfOT6o1
	peRbbozPNnDZ2QFidht0Rod3FOnPPhZOB6Y0ciE1663+Z9VvJyHnY+fHb4OCqlSjNdNklw
	itGVmK/gOsEO5XNiMZWTjd+Ec3mFroA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92368409DD;
	Wed, 31 Dec 2025 07:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5995AC113D0;
	Wed, 31 Dec 2025 07:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767164432;
	bh=GRl8HN9W9HzovY12xOzZB+f3LxGN0RkT8HznAkWFPpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9aWocLP+0z9gvjhjUEv0sQJbAiGUI+QAynX/EHARB2EQSbaAdco1FtEREO59jn3I
	 HjUlfXhL6GlpW4iaXvavWU8cQcidhrCWrMUmViUp6e/ur8jDvtoRHyk7p7d6zqEVCy
	 OyoGkF4xISpoF7NpL+KHQLJglJ/9057krvQ2nkB1GGrm+6JL5csEBEJ9rwT0wiNE6x
	 o2hKcgIyXKd6Sv9k+uqhc5rJkXkY4NiWeQmGe+FMZ2TRZEiSV8aYglSw1Tj3Ck1WHs
	 aBlIQuVXxm6sseVNa/dKimyRudnoIIvjs94XrF3qG62qEzxHmPK26JKvt6WSAMAvDT
	 /8B8lQppy6kcg==
From: SeongJae Park <sj@kernel.org>
To: Aaron Yang <yangqixiao@inspur.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v1] mm/damon/pa: initialize 'folio' to NULL to prevent use of uninitialized value
Date: Tue, 30 Dec 2025 23:00:22 -0800
Message-ID: <20251231070029.79682-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251231055737.73325-1-yangqixiao@inspur.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: dgakgcgn7yh6u189wz5g8r8tg345k5sn
X-Rspam-User: 
X-Rspamd-Queue-Id: C1C5140009
X-HE-Tag: 1767164433-670034
X-HE-Meta: U2FsdGVkX19KQNlCZTDn1+blSyIXP3GYgo2bkxYETn9DGkSGPo+rToS5n851KX4247Lv+Y41AmfpSlIejjVrEcK6co3zOMrclo09hYz+2ZKHZnQ8MJTPhJoPSIkgcC4XfugZ8fOczjv5wm8yVDzkqCryERNdZyh8SI5e+OsNfnsAEKtpkVdMN15dplgserARiwkpTpbkcm0nH0kpdS3m0xdFriOaDVJVLNXrOxCE0pJWiBg3AL/hCb8P0bxEUrjheCJG0wbXelSFHhbxJl7R6V+FBmHQLfv8V6lQgwXZ0VdRowx2SCU2lEkWL1ARysV+nTpusVU2XI9+c6CmK+o8o3QWMkmpxBl8/wpOVo6xcgu9ciANtDHfbXcxltZlCKWDTb0AgVZ0qIV3G0bX80NQiViUGcaQFLQREKKiugFXF6gWiIi7JonAC/FurO4WONdaeC8KRtpqAekIgH9eNPn87KlMDM0ieJavERZ423h2E6cIQuSV5+rxkOjFVbHwUpQs50GF1yzVWmaUD0ouBRbi4Sd0PBPzoYING5LJzS5RqlQFNcPdolZFd0t3Psd1cQEexgo2nv00tZ9aonHp/DMuq4OnUFtMN8zGQHedH6u0tZGvQgy0vB2TBE4nMNkxcxnNnNFdWGzCdPfEvPN5Y6TwW9PiWWtNHpaFw/J2zakkh05HI2GrJ3Cecae1N4RWR92VgRZPol0waBvORadWEMdjvRe3IX3+vfRcaK44lm/i7/T6UA0zIv4tmK8mToL21/M4pAcfbd788AivDiV7Yt6fO8jiIIcDezbkaRB1E9ZFz7N4KENFOKRyS14rEzH/Hdhjr1BW3IL28hqdGLItTRMIjMou8MemTSZqThlTsg305Zciovh4ueC5YfDwdccvCXDoh1Zhr1IYdE61gyGvRX0a18laxtovg0q2ZAh8Gv6PFRWjnzBSqH7/hVNFLtLCjRls0s0eKjupBJ9LfqHUZ4G
 dt/OZJv5
 xayWd6IHZZg/ATtUu/2E73OYKJ5EqcWmH+clqUSdDiPJblanWjsUluPAaSlReZXnve1dmTXyPDR20IQXrWlh3qpwdA0mwvrGgjAhDEkv5G8Ymqt2K+OM1SXTOP5cZtK/vFcHJTjTKBiuwRDiNj5aOu4kADdmHD4ZlIiVsiia+ZBIKycDIbFSsJine+LtuOD2JKWjdko7NgZmKiYCzUaFfOCmECgFE1ZmVR0KKCmwIudJu3vGTNUyY6LAGu+5PiX52yaz/t0yNnCqSEOBHc/cVY8kThmZBnBFZ6xW67RMnHhFeAyE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Aaron,


Thank you for sending this patch!

For the patch subject, let's use 'mm/damon/paddr:' as the prefix of the
subject, for making it consistent with other past commits for the paddr.c file.

On Wed, 31 Dec 2025 13:57:37 +0800 Aaron Yang <yangqixiao@inspur.com> wrote:

> In damon_pa_mark_accessed_or_deactivate(), the local variable 'folio'
> is declared but not initialized. If the region [r->ar.start, r->ar.end)
> is empty or invalid such that the while-loop body is never entered,
> 'folio' retains an indeterminate (garbage) value. The function then
> unconditionally assigns this uninitialized pointer to s->last_applied
> (line 239), resulting in undefined behavior. Subsequent dereference or
> folio_put() on s->last_applied may cause crashes or memory corruption.

Nice finding!

> 
> Although DAMON regions are typically non-empty, zero-length regions
> can arise during region merging/splitting or due to address unit
> alignment — making this path reachable in practice.

But, can zero-length regions be made in real?  damon_ctx->min_sz_region
disallows DAMON having regions of size less that it, and all DAMON API callers
set it at least 1.  That is, DAMON code is at least intentionally designed to
prohibit zero-length regions.  And many parts of DAMON including
damon_pa_mark_accessed_or_deactivate() are written under the assumption that
there is no zero-length regions.  If there is a case that allows zero-length
regions, all such parts could trigger problems.

> 
> Fix by initializing 'folio' to NULL. Assigning NULL to s->last_applied
> is safe and semantically correct: it cleanly indicates "no folio was
> processed in this invocation", and callers are expected to check for
> NULL before use (as per common kernel practice).

For the above mentioned reason, I'd like to fix the code that allows
zero-length regions, rather than making only this single function safe from the
bug.

So, if you found a case that allows zero-length DAMON regions, could you please
share the reproduction steps of it, or fix of it?

If you didn't find a real case that allows zero-length DAMON regions but was
thinking it might be theoretically possible, maybe the poor documentation of
DAMON has confused you to believe so.  If that's the case, how about making it
clear on the documentation?  Specifically, I think damon_region kernel-doc
comment in include/linux/damon.h could be a good place to make this explicitly
explained.


Thanks,
SJ

[...]

