Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F62CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32EB66B0088; Thu, 28 May 2026 03:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305E46B008C; Thu, 28 May 2026 03:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B916B0092; Thu, 28 May 2026 03:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 106526B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:14:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D30FC1C1CDB
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:14:41 +0000 (UTC)
X-FDA: 84815965962.11.1C74086
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 28520180008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:14:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VCYo/kAn";
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779952480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMHRCZ/Uj48KQbmFraAMkWjb/Yi2LkWhbHoiVD5mViA=;
	b=UEdSpKNhtt29Dlr5r1aU+IfBa04uba4r4uplmsAs1VknDXQhqcZZ7un4mYMzOcMQrRhZj7
	GudNXoizVtCWfSUy3kpe2AlC6nLXRKBqITBeiqzhfc8UzIx61L6LyVVUPskqNNzEnc0cIg
	WiLgANuZlrT3OuSxfonJI/DZw+yonpM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VCYo/kAn";
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779952480; a=rsa-sha256;
	cv=none;
	b=K6T7Bo1a0RwiYE9NZ7w0LtW8sRGvauZrrs9+mK3AS4TOsqw1Q6SYkH2WSBZGOQ/zJcD7BM
	vpZsoaq2ef74DXaMiV61TvAC0nFDOXHdRTCFlYFhc1mDKgJ4REdHtgzzpr4ZFDqpJK0+m2
	yEzw1We4YbysjzBiks8isDj3I3CCMD4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A55344195;
	Thu, 28 May 2026 07:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A1F1F000E9;
	Thu, 28 May 2026 07:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779952479;
	bh=AMHRCZ/Uj48KQbmFraAMkWjb/Yi2LkWhbHoiVD5mViA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VCYo/kAnidj7WuNhU0XFKQXOcDvDd/yD85UGCv9mwdHK+JS0RAVNF7KU9fdNcSszP
	 q3DhFo9mP3UPpT4llrLK3PAdb015+g1MqHUNYBFjramxw/+NA55SpoMw2afX2FPbqA
	 dPDrYC0TszCnjWWIvp73l9RfsDBQoRQNXw9IyIBwATsuwL5A0YGnxHp3mhXGJxoKb8
	 njAZvOUs7KjOyK8q9Ej2Ts56p6Z7IYxFXEQhdRxWxhC+cVJOHy+OXR2SI/0ljM79op
	 f59S3iQd7f3v8Vxj3jOhXRLSqucGWsIY3wo0U5HwRNTi9EGGggJzE41xcSGKKM46Rq
	 o3Z/5yWTfsPZA==
Date: Thu, 28 May 2026 08:14:23 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: wangtao <tao.wangtao@honor.com>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>, 
	"xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"jparsana@google.com" <jparsana@google.com>, "dvander@google.com" <dvander@google.com>, 
	zhangji <zhangji1@honor.com>, wangzicheng <wangzicheng@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ahfqKUDyIt6fhgts@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahbSwczOpsBKby7o@pedro-suse>
 <800d894e9a54440fa1d7f7b76e50a45b@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <800d894e9a54440fa1d7f7b76e50a45b@honor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28520180008
X-Stat-Signature: ibz7ozz5s15mqwatyym9odcrx99me3xh
X-HE-Tag: 1779952479-366698
X-HE-Meta: U2FsdGVkX18VdY6MeqGjMWLgXDm3AMlxLd1As2ZZ19Eauec49xGHUxk3IT/f4iapI30g5jOITxcr2rr7K12thZ4vWzFz44wBeSYFpl67vdfzlp5PlAaCFsOIACkArZPhX+4GN1o68maMiAp8AKRWn2O1MDkVZSx6/nb3ftbJOa/FuCpCSf4JTAdiE5RQfNekmUJjmj+o+y1I5Qn0fsKCT3LSPBeSLPOdXoQsNUD+iycjM5mtN6or0K1sEjYpl7TNBHUr9z1nZ+U7llTsCq/kZNyDiiz/KpZ5riqAxwBe3q3dX2lDbLDVNR/dIP58z4EdAxRXUuP7NFvO98XnCdGL9+x5IqOlUvLoy1aJoMZAJ3IThcjZoHrutiILiGuYLn2CcLzbLbq2FCBHEcpBnBa0ZEqUMI40B2T7KcGgGal2iSL1LxF98/xlyGzZRQeAgntIOGaI6cG6+b78ktHZtJd8NlfSkleqB3Rm5P+4wbG9ttiC8ni0R1bkLHlhA8qiVT71zzyWwQUx5oTRHBSzBKWAzzTWUZ6rPKRH8KUmf7rLFgEw59FZesNGpLnpbdiRb00I9Jhi4P//sV/oWObM4v8bJwJiwnQdnmfLbuRuPdmIkpOw6CId6jYx7jxwsdmeP10435QvM/yT89gJX5wuDoy7isH7jafBjaf82dk3AsoGqUeY5clh3h5v9Y9hxvs6ldhFanLz+kx0qMzJU1qQPpM7R+kUn2+2NyeMRjdAUWfidzY4bJSf61LymhaQ0lHIkU5T+LRheDHDD4qJkEbMM3Xn6G9exHOZu0PrdWpL5alx/aligXgkBQgNHfG/6BmyyHDoNNV+HDGSRLMsLmivFS9I+k3h8l5wNIvYYSRyq0dWGY4TXV1eMnvxO+uw23BZHacfRKw3uEKyaJR2CP3axNaj4g9n2jtW8wjxtTjvVSAcEf6RDze7KdAFUKZufrW6S8O31gHootBbhmeJ3QVHBhP
 l1WwDHza
 qeZ/2Z4XF+EBxvExvF2TBiudf98a3RioL3TK1sGrD8vyFxgmfis0f5UQ3vQ1FeszdLDJhL7ErrUyNQaASnTV3yARErhivss7Phz9NwMwvzkfIJQX+YLdOhVoG4WGUTxgyb68JpE+H3Kyr5Hu8n62BAdOcp73jxsBgfm4cSEaVF4U2PNoLDR6VcV13L8l+M18fvWqRnd6wdKESPBtPDms0kVwCQa84hoIl5quVfGUYGLcJlCGeDMqAiEhgmOuQmfYQkk4Hp4BjJaknhpDKnNgz6ZULu2kRA+mb10hYOgDbW/2CgRPFk7t1/zGDvAHhM8rClpPMSHbigY0L9fx0bGsJaMzC3XBlC6xAFGZj18JES74/UTil+VmIA7M8TuFux7FGmtMDxs9TPqpabUcEUWNNX2yDsMXLPpWtDEatRV2rk43H0uYhwGoBJom010/yM31Ylqz1+14sm5tt3BKv69ppCj1blhcZT00QyZjxJr/neU70whW3ZmiwCS198g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 06:45:07AM +0000, wangtao wrote:
> > >
> > > Feedback and suggestions are welcome.
> >
> > I'm afraid, per previous discussions[1], that no one is really willing to maintain
> > extra complexity for the current state of anon rmap and anon vmas.
> > Sorry :/
> >
> > Also, please don't send series this large without previous discussion and _at
> > least_ an RFC tag.
> >
> > [1] https://lore.kernel.org/all/aec533b2-37a7-4f44-a279-
> > c4aa604206ac@lucifer.local/
> >
> > --
> > Pedro
>
> Thank you very much for your reply.
>
> As I am not very good at english, I haven't participated much in community discussions before and I'm still not very familiar with the usual process.
> I realize now that I should probably have started with a discussion thread first, and that this patch series would have been more appropriate with an RFC tag.
> I apologize for that.

Thanks, appreciate it.

It's also for your benefit - regardless of AI usage or not, you've spent time on
this needlessly, which a discussion could have avoided.

Also as I said, going this way has damaged trust, which also doesn't benefit
anybody.

mm is a welcoming and open community, the best approach when looking at
something like this is to engage with us :)

>
> I will read the discussion in [1] more carefully. I also noticed the related code here:
> https://git.kernel.org/pub/scm/linux/kernel/git/ljs/linux.git/log/?h=project/cow-context
>
> Many years ago I had already noticed that data structures such as vma, page_table, and anon_vma consume a significant amount of memory.
> However, since the mm subsystem is quite complex, I didn't look into it in depth at the time.
> Recently, with memory costs increasing, I revisited these structures and analyzed their memory usage again.
> Since anon_vma seems to have a relatively smaller impact compared to vma and page tables, I started by exploring possible optimizations for anon_vma first.
>
> Although anon_vma is relatively simple, there are still quite a few uncertainties.
> So I waited until the basic functionality was implemented before sending the patches for discussion.

Thanks, I am more than happy to discuss my approach. You can also see slides
from my talk on this at LSF/MM at https://ljs.io/talks

(Note that the code linked is an incomplete implementation, simply some early
code to give a sense of the approach taken!)

I would ask, however, in general that you hold off on anything code-wise before
I am able to issue my own RFC implementing this approach so we can avoid any
overlap/confusion.

>
> Thanks again for taking the time to reply.
>
> --
> Tao
>

Cheers, lorenzo

