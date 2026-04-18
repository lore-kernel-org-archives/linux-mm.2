Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E25BFF99C7D
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 09:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520286B01F2; Sat, 18 Apr 2026 05:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D16E6B01F3; Sat, 18 Apr 2026 05:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7946B01F4; Sat, 18 Apr 2026 05:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3ED6B01F2
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:39:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C473D160430
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:39:03 +0000 (UTC)
X-FDA: 84671177766.26.8A438F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0F0FFA0006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:39:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pvw9b8ab;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776505142; a=rsa-sha256;
	cv=none;
	b=2AACZW9pVNXQ0+WBypismunKTShg2dDxjgkrpmWxFM63JnZtFIdAUEPN3uv4PKoGm7HYWk
	WPmXrZmELC05G1Jp8YhXC661l3qS4KczO+uKBCYdH0Xxqt7+HyHsm8lR194Zs7bnWy2tEJ
	NVM2zQn+SvHUp3i91Br8vWE5i8KKuS8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pvw9b8ab;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776505142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnVHhaOHYFh+nAYCmX8OhDD1hiWPYQaRDH/msj1i3Go=;
	b=ZxVhAJalec9vAb7RS6e6s1atYnYxf71fvD6MTrwZD1y4mBL+3Nte1ONZt6gdR0V3OAh3V4
	w2EmZ/65f8pnQ2bd1UBKSyhTe3QZoyhcHQ69QKCOVDuJQc04tuXwmP6WOt82BzBGTxaXuo
	Y+Qjl34W/lsgb16Vo8X02HUKOWM5WG8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE59E43B3A;
	Sat, 18 Apr 2026 09:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F08DC19424;
	Sat, 18 Apr 2026 09:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776505140;
	bh=OiHw+xaRzqDQPMVp8PWdrbPrq4CXv8i6VOioXMCbP0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pvw9b8ab5Z+V9ULudbbwhFHG/3PQXakntReoDaqHoiVMow4mW+PxaBLNUBUQQJUMs
	 fpu/1dr2OYEKiV1Cu0BxLxUFvSoJX3FVKLRWDMvi5arSO4zKYdFTURMaTm9AOeXtd0
	 LVEv1trR7gMyDgutonaPHkST4ufI7DAmiD46jKMSHgxsZ0NKnAwZesjscUMp+Tnfqr
	 reE25bDfM7VrQH03rwRF5//V/EvQTeQjjifj21ajkDfg35J+SAw24LVrv7oH05J544
	 WkfBq1Jd5kDhlbKygqYwYOba0HEgMPm23NdEAZovwzdEWj0oBtYCvWmKFXXlF2wAz0
	 rcUcEx8P6w/qw==
Date: Sat, 18 Apr 2026 10:38:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org, 
	david@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
Message-ID: <aeNQ_g-kL1qHr7EN@lucifer>
References: <20260417011606.1089985-1-gality369@gmail.com>
 <aeGxBwfWFlimkm-V@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeGxBwfWFlimkm-V@casper.infradead.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: c583ykr9bdi4c4ayz7noiia17yykwdoa
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F0FFA0006
X-HE-Tag: 1776505141-603759
X-HE-Meta: U2FsdGVkX19IMmQ/NNGWMoUU+cNbvI7IqkI4w1H82Yzwecedr5ihjYtl5m8PSJ0gHNAUoEyfrovmdf5H7uR9RcpKMRYpAC1sdsmOzXh44uID8rus0dyIGZX6xVbtEYz2/j7YFpaO/WLF0oYOP7vxBxNPYIEfaQluW+kgpwBk/DehgVqcKRssDzK4PR1fATM8fvpZug5cRceRn7WOovxsM7bUCYTaak48/mSfNGEuoM6Zf8RPXN01QR2myChE4CiGkL+GsmdvAitRgEQIc85UbdNx24crS2KRn4rYOjFs4zy0tmNtTGHWG35njAJv+oclqaiUki7SmNG866izc8tThrmg/fZf/E/QFKNlQNfSdjPM8nwaKdcqGvUxVygijqEOalYKOa3ksdDJoJedP8j/UCyXJySzAA/cJDEgdcMcdhhTNEWH0z+U1ulAWkoQN+5GzroEPHe9/3LzGK/Au45JT/a8NB3YMjyyQ5w8SgNzRF1n4AQg8Ve0IzgjiZj8wnOShJDoXeT2Iy2s5mlVxQmhqZLfZS1Eby389FRYsVZZoviY2sogsrtKIdD3reC/wTNkvQ3yKCQfuKdGoFpisiXGhxiCLVK52S1bJwZQ5gAEVKdFffT2qNrWniAdMVTszRy9NIzhPh24mfpyW4YKX/7DUYHGADxjdSxO/zgd2Fywk/p/JRrxBRquO0waEwlu5SXnOivRTRzrklJBDsi1JncQmBmAMV4/ZrMpwlym4l+GGCWVrFIpktdUmNJwlz+YjiA0afu+Bh/y7opyI9t8/xBqQYMSWNPIJNk8lZNlBJhupxDFRnCLS+0MgygdsUJeCvHv3d77NiPc9BGccYoHlrkAnQSGyXC/G+xYuyS/eg9jl6NPiz+nMHJr9SvIvgPFts0A8vMrOUWTM67eteNqiZ68E8+61ocWytSMLuqjWR13xuvbKCdIFn9nKeZbTSuWlH59g/1I2ZHX2fQmzHlnPAK
 HRp8GESv
 WmpyN4gX4DD4n62ObykRcjWoH9NF/tEcEXvFDJ89VwAeryNaJ7ijBcUlfcrOcXtWluCQ/k/JPI8icFaJWi4YJOrreRB7T7BujPgEtDpiucUhmY3Tx04uqxM/xm9/2lJ3inYAcCR5uLUS+s+O8WLhnVOJvsSh7rkTpYcYtIqXblxLdnRTB9btHGa/Xd0/AeV8r0ctjISNglXoqnqCGJZAj79XQfavMRp6u+rhNZ2ybcZQiIdeohZQC759R+6AXbfbb+clpS1btq4lLFID2eP2V3dviWlK44T7ZqyVMEkr+s9eg5EM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 05:03:19AM +0100, Matthew Wilcox wrote:
> On Fri, Apr 17, 2026 at 09:16:06AM +0800, ZhengYuan Huang wrote:
> > Commit a373baed5a9d ("mm: delay the check for a NULL anon_vma") moved
> > anon_vma preparation out of the generic fault path and into the fault
> > handlers that actually need to install anonymous rmap state.
> >
> > do_swap_page() was left behind. It can still restore anonymous mappings
> > via folio_add_new_anon_rmap() or folio_add_anon_rmap_ptes(), but it does
> > not call vmf_anon_prepare() first. On a VMA-lock fault this can leave
> > vma->anon_vma NULL all the way down to __folio_set_anon(), which BUG_ONs
> > on that violated invariant.
>
> Huh.  Can you share your reproducer?  I wonder if there's an equivalent
> problem with do_numa_fault().  And maybe the right solution might be
> to put the call to vmf_anon_prepare() in handle_pte_fault() instead.
>
> I'm asking because I don't quite understand how we get to this point
> without an anon_vma being assigned to this VMA.  We should allocate one on
> the first fault ... so we cannot have ever faulted, but if we've never
> faulted, how does madvise() manage to swap out a page if none has been
> allocated?

Yeah there really isn't any way this should be possible unless something
else is causing a bug here.

My recent anon_vma changes are too new for them to be the culprit I think
:))

>
> (also if you share your reproducer, perhaps someone will add it to the
> self-tests and maybe it'll prevent another bug in the future)

Yes, if this is a real bug we really need to see how this is happening.

Thanks, Lorenzo

