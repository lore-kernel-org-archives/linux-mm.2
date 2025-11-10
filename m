Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 895FBCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 21:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BEE8E0006; Mon, 10 Nov 2025 16:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCCCD8E0002; Mon, 10 Nov 2025 16:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC7D8E0006; Mon, 10 Nov 2025 16:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90C758E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:43:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1454F140270
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:43:57 +0000 (UTC)
X-FDA: 84096025314.30.911F9F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7D557180004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:43:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VTB/W/EN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762811035; a=rsa-sha256;
	cv=none;
	b=cN+2q1dacwiaLqBoOmVxTnLv77vdTnwglCAIUqBsh7xknbvJE1iFln3HgqNHkBj8eDmHea
	zXugACbIKniD5OYao/sTFgOUYkMb3aUPwrhGf2gVzIlJEgDL9XsQez+6L923vc9vgfog0c
	w/+IUuyFJ1+0CztEMgcXm1r4kwDuH4M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VTB/W/EN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762811035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdIdV93QtZNivTpbNvC3FQ7U3j2XinAa3RaCvqPea9s=;
	b=k5wW2oXzJd4+jPRCmQrzsz2KOyS5UkUI2HftgwdIVDH2j9EGL/79QM5XLsjbux5lZm+gd6
	zYgxerge99MMWMtFynNNSM1GQY5ovue7K8gmpxn8HeqYbtn/fye//+2g89KPH8DOARcgz9
	zLH4udJUnzN6lHwcJBSSj/VjAJ9WDMc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C9335601CD;
	Mon, 10 Nov 2025 21:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC532C116B1;
	Mon, 10 Nov 2025 21:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762811034;
	bh=qLsh4xwJFcm7ZBPTELrv5HlI3dadasyJWn9EEI6vM8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VTB/W/ENaZyWqwN3+1JS39b2RHZU0mVzd+iX5zXnJ6OoHc80SN0wrgaz/WIvM6Y77
	 0dYcTeQlruQ7+v0pSvqoEsOHFlc4fXmZIMPBFmrz8H3LqzxQen+v/v8WRHWMNqmQb8
	 2LiRM0jBjhSRh584eNaIXPZRqftXWByMhTDaIH7Rk7LitC1Gy1RRsBSREWb3SQPP3c
	 YljSbH+HHxNKJvBbpjkbRilCUSwqwsOME1fxIuh3C3gwyanU/PhpkLlsuNEma24Pww
	 uMGlOkYblxl+rwD8gC0QEGBRFsfHSVzFaVMrfAoc4BgVm7yuqOKEcg6+TOoj1h9LoD
	 f85WUmDtXeziA==
Date: Mon, 10 Nov 2025 14:43:49 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftest/mm: fix pointer comparison in mremap_test
Message-ID: <20251110214349.GC302594@ax162>
References: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
 <fc051006-5cb2-49e1-bb27-7839837439cd@kernel.org>
 <aQyOZ6eYng-IjxS_@fedora>
 <6e07949b-d86f-46d8-a68c-9717cfb26084@kernel.org>
 <20251107160855.58891ac6df6854a3b608185f@linux-foundation.org>
 <aRA6lEQmmrvmj2DX@kernel.org>
 <a7034e0c-a2ab-425a-8472-ef0a87a17681@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7034e0c-a2ab-425a-8472-ef0a87a17681@suse.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D557180004
X-Stat-Signature: u73qeuxbqu6oudeq8ds8jgdduajzj6cf
X-HE-Tag: 1762811035-36131
X-HE-Meta: U2FsdGVkX191Si0d2ghRMdDYggMqT4wjfvo8rxs72pOYRZjB4TUyt1l4UYyVhJAwlBcBlOp1x4zpJjuQ6qPGirH+YufBrLtsJeAaijnZ29PZxvCyRiEANeyMBCeODecqja2TyJZfclze0BsXZJttZTASt8MEkgNjsZZYzyZ4V0OtzeWtsSquCg2uXbeNkI5DRhQrhYc98+sldm5hdYyJibbIsIyOJ7SQ53MBoigGwPUvWghX4ie3O53xavP5eLcrudVskfO6c3ZCy+CxWdFVE7BhtviRjXTGlQkSkmXvqJWSAbEiQKl2+Ip0+xjfHI54eRLLP45Yyw1dMN3VWpPvRvUN/ExUSR/KPPOwiL90gbTaQcnZU7PJb4zKgBfBt0PSjvJ43nsWuH+ADPmcrKAHy3P+yzwd6tjJLN9Styyoef3nYvwLnBhtwjsoPjiA5d37PlJnwDI+Li0dwA76itzszAjoVRGMaCTJYfEZGOmWuQjNreVIhregCwyL1Y310sfTK10fW9rlABRyCj0Ne4Rz8x9xWfWxhAMQvcelx8Q9KR5Df7A+IZVxc/dVdiJz92keaYmFPJrUnD7MwLy7qQJjmxZih9OUj6x+OqUEg4UecViS0oMQJBdsSJSCK0btbGm/ks/d38KEZ9bfmPr++yQEG7pkxxERQCMOj9ZIysuPQzLOy/WrTWHYaJhZLmh9SYAZA1yjQBW5XNlog/JuD3mw2gq0uIqwbnY9NFHEQHgJPMrZiprLWYzK11SLQyC6xAugsXsY9pC6H8oPlVVdketqHLJyJd6UP+s8aA2DC/kYkkIB5QiDx9IhSiUvO96AufLxVVBReH86ZEWAOLhcGYm8iMK2vq5yMxxcJog5lkHfP2TaqdGsQAXpszextV2T4CnSRTIp/faaP4k+TbwNntu4Pe+4np0WI3dJr8egzaCo5OrcZCR4qZLe+evpeFewfrCKu5INh3BPOChFypcq0lN
 Q4RhbKkq
 sAk8AgJVgLVEqfkmqe7bOMbYtVSbIz6Y2i/0PqBc3auL3mrJcmNDQ5xDEg4QMoQR6fdd7n4QGprOqClHClLhoMm8y1eYJr+t9bjVytKiCS0GlVFILL2oSyBRd+GQ+cXhsy/JS2jsf8rOc+7FSjfWArR/RMovqdi6oT9kBdm5uApNZ1GGHVK1rXloyDlUE4CXWqJBgtgMBA44fl5ktXhKIXq7/tinnX4C9lGM4q51z2QZFnJQ77WiWIUAlU/TnpOKhwepz/kB1iaafmse8HUlWQukZRYs202lLkBRRfxNoKFv+OWS7o3mL3Hlo8aX+XGngF4YmR3O6M3qc1QI6HlVvLxNpLSvBrDI9ZnF/zaPqZK2Lhe4ORQ1PSAWv0F8wmJeOFForfamZ5RkndrkEj+hsfB13YfBlQnC+pAimCGVoo2cipnskr/LDreyPoQP/nqwWAqOlZWC6P13NBbg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 09, 2025 at 08:11:09PM +0100, Vlastimil Babka wrote:
> >> > >>> Pointer arthemitic with 'void * addr' and 'unsigned long long dest_alignment'
> >> > >>> triggers following warning:
> >> > >>>
> >> > >>> mremap_test.c:1035:31: warning: pointer comparison always evaluates to
> >> > >>> false [-Wtautological-compare]
> >> > >>>    1035 |                 if (addr + c.dest_alignment < addr) {
> >> > >>>         |                                             ^
> >> > >>>
> >> > >>> typecasting 'addr' to 'unsigned long long' to fix pointer comparison.
...
> >> I must say, applying this would be an unhappy life event.
> >> 
> >> 	if (void* + ulong < void*)
> >> 
> >> makes perfect sense in a world which permits void* arithmetic (ie,
> >> ours).  So what the heck is clang doing??
> 
> My (not very informed) guess would be something about undefined behavior
> because pointer arithmetic is strictly speaking only valid within an array,
> so void* + ulong is also still in the same array, and thus can't become
> smaller by an overflow, because overflow can't happen if we're still within
> the same valid array...

It is indeed due to undefined behavior but more so that without
-fwrapv-pointer (set via -fno-strict-overflow for the kernel build), the
addition of an unsigned index and a pointer cannot wrap. This warning is
a result of the following change in clang-20:

https://github.com/llvm/llvm-project/commit/6d34cfac53b993a6cdf3d6669e017eac3a2296c8
https://godbolt.org/z/hvMoPYb17

which I made sure respected the value of -fwrapv-pointer in

https://github.com/llvm/llvm-project/commit/f0dcf3240dffe3767c7f3a2e2da5b92ae9fd1bef

But it looks like the mm selftests do not build with
-fno-strict-overflow. Maybe it should?

> But I don't know if this strictness is only applied to the warning itself or
> to the actual compilation too (does it eliminate everything as dead code then?)

Yes, it would turn that

  if (addr + c.dest_alignment < addr) {

into just

  if (false) {

based on the above Godbolt link.

> >> If we do
> >> 
> >> 	void *addr2 = addr + c.dest_alignment;
> >> 	if (addr2 < addr)
> >> 		...
> >> 
> >> then which statement warns, and why?
> 
> As the answer was that nothing warns, I'd think it just isn't able to warn
> if it's no longer part of the same statement. Whether it also means it's not
> eliminated as dead code anymore, dunno.

Based on the above Godbolt link, it appears it will be optimized the
same way, just without the warning letting you know something is up.

Cheers,
Nathan

