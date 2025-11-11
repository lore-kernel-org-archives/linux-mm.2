Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C6DCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 23:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDA78E000C; Tue, 11 Nov 2025 18:48:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98ED28E0002; Tue, 11 Nov 2025 18:48:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CBF18E000C; Tue, 11 Nov 2025 18:48:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 757288E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:48:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28933B74CE
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:48:42 +0000 (UTC)
X-FDA: 84099968484.10.E0840FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A66D080008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:48:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M2vt0uH+;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762904920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVDlArf+0TEhas/Dcd4YjunEOiT4L5F1x3vTLDPGEJM=;
	b=lBkfFqAot5RJkoh/M8vao4AilOEHrjhEuHuGCYzo5cFWjEWvYk+K51cyQXj4mdFi32iG6a
	9XnnfyGLQxe+fX2h/B3zg9UYJF3UFzU7pByMl9TzqPAYquf4TwiD35YU+97bUOgUzXKuZn
	cbgqsoeCemGmJBtxOSHB2L7OrLwf5P8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762904920; a=rsa-sha256;
	cv=none;
	b=AiNQUBUQ5bsggO1YLU9aFLe0a0KsDHRptiCrIfR/mk8Xq8BtwK0DxRhQABCAFVlAezQSAv
	MtqQS/nFaoeBjInERUE96zTxU+59N1V+UXU1glNL2bxqsLNWMM+AD32CCaWlqm0k3Wu4/B
	P+50338+4+VTXrvE1Ji+LQMX9/nDhOM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M2vt0uH+;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D876E600AD;
	Tue, 11 Nov 2025 23:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34607C19423;
	Tue, 11 Nov 2025 23:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762904919;
	bh=FXS2195HdvuacL8cAJSqhNLqJ6/8m8aNe7EdqbioGIs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M2vt0uH+VTB3VZGUYDyR3hgkhk1P4pSTj7Pji7bDh4pVQh51O2hSCkzKfpgiM3la8
	 Y+fj6dDgnmVYfkvX3p9ktrrnnuRDI06k2r4ahXk33xQtkdyc4sdk2pyncrFjHoW+hl
	 +VXuFQzx63uh/ep81BfqmkFyWIM0Ev+mnjUN3RqQ=
Date: Tue, 11 Nov 2025 15:48:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Manish Kumar <manish1588@gmail.com>, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_isolation: clarify FIXME around shrink_slab()
 in memory hotplug
Message-Id: <20251111154838.0951555906fa923ec642cfd4@linux-foundation.org>
In-Reply-To: <7e43294a-03d5-42e5-bec2-5fbcfab97b69@redhat.com>
References: <20251015175041.40408-1-manish1588@gmail.com>
	<7e43294a-03d5-42e5-bec2-5fbcfab97b69@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A66D080008
X-Stat-Signature: sfj5fy9n45mz7ffkxhxadhmpb85ecax6
X-HE-Tag: 1762904920-953561
X-HE-Meta: U2FsdGVkX1+sQfMgMOr/SSJS0hiZ1qst7VMaMRmW9T96MyPmP5TByWlYs75cZ0dkRd1C7pHX7w5w4BAQUEmXBMvd3hPRcxAb/T6/MWNeI2MHYYz4y1kC8glaFLnJMZKL6QBswJz0qHfUKREZEiSHy468J8TdK1pjKsufKOJZi5rJu1vzdQrEjdBVM6KYUDt8tCaJe5lgyPYhUxH9rGsGtHex24SeEjEQv09/Wq2m/4Bu/zbGcVLksSYjCq3sTSMZkdLUM8mtDN+JMdfAjgbyKFGvw+bL1hp/zyOmA6FMlfPfRtAMJABn9OxwQo1MHDQVQN6J7Y8yblv+oGU0NzBx2JNZ2a3Vre3HtB4URTJkdl8MgAhiZC6017e4RE5BtJgfDy/HclALCl/Lt1FHKqeltPFd07XyurQskfxov90u1FqwGw4Izzls/PNZY13w7VLhK90XE+ySEQYtCPOAKTvLc1rs3ATdpHTfJI5sWSZvgnoWkVgkba8UxnqkMscJG1ajY3XD+qoA+F1lcN1jzLdX34ZU0wpfUHasTwcDoaafqy8HCvmZNh+pwCGe0EEfzH9TM1QgKsQCcw5DOBKy3Z1fnP3FqaQix66BsrtetPiN3N48PGl5OQzdubkVT8uP9JjMf1r1DpB4c+A2SA/namPM6EwjAhi7ClgOBrvwy7KketgrHxzIkYV9aoyGOVkfAgIQRnHkZE941on8giizdc+LyDYSPw6ByFyxvBRTJK4+S9W9Ej5M+ETd02sVbfdU0tNZ0xFN7FmLF3D0qOMeLiA5xdhrOua8QYu+ZWZYioLr7L+usx6i9yKVcoHGxeaU/JPRA8lwCWPZUDpFDYIc7KsOOQWIYR2NWle8hLtBDlE/Eh/qZTB53I+aP/vrc8X50L4imiU5miAw08stVD3LStiWmpsYJNG1mONP0U/imiF6tJ0zKtZToTKdV7rBJJ+wAGQGGRvp08IpHvSZ5yOiuyn
 NnQaiDjG
 BVYdt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Oct 2025 21:26:42 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 15.10.25 19:50, Manish Kumar wrote:
> > The existing FIXME comment notes that memory hotplug doesn't invoke
> > shrink_slab() directly. This patch adds context explaining that this is
> > an intentional design choice to avoid recursion or deadlocks in the
> > memory reclaim path, as slab shrinking is handled by vmscan.
> > 
> > Signed-off-by: Manish Kumar <manish1588@gmail.com>
> > ---
> >   mm/page_isolation.c | 10 ++++++++--
> >   1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> > index b2fc5266e3d2..2ca20c3f0a97 100644
> > --- a/mm/page_isolation.c
> > +++ b/mm/page_isolation.c
> > @@ -176,10 +176,16 @@ static int set_migratetype_isolate(struct page *page, int migratetype, int isol_
> >   
> >   	/*
> >   	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
> > -	 * We just check MOVABLE pages.
> > +	 *
> > +	 * This is an intentional limitation: invoking shrink_slab() from a
> > +	 * hotplug path can cause reclaim recursion or deadlock if the normal
> > +	 * memory reclaim (vmscan) path is already active. Slab shrinking is
> > +	 * handled by the vmscan reclaim code under normal operation, so hotplug
> > +	 * avoids direct calls into shrink_slab() to prevent reentrancy issues.
> 
> This is the first time I hear about this reentrance issue.
> 
> How did you come up with this explanation?
> 

-ETIMEDOUT, I'll drop this patch.

