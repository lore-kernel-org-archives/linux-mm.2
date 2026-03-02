Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D003AE9B37D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 13:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426706B0005; Mon,  2 Mar 2026 08:40:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDE06B0089; Mon,  2 Mar 2026 08:40:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334B56B008A; Mon,  2 Mar 2026 08:40:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 233A76B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:40:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B03C21BF64
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:40:17 +0000 (UTC)
X-FDA: 84501232074.17.62FBA91
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id A84E3180007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:40:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q5huK15E;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772458816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EallJz9xECdXZv48leuK2XpZ4lpwJqacaSIYP0recMI=;
	b=vK7is+OdSeqe8wQXYHAYPqWk9ZcRt2TMTfZoljADi9PmSEUuipKYwafVifScLop0/773Ch
	9/P0XjGpU3QGi29w9dzyR52bTnlDDAR/uNgYsydP4v5wDyBLLWjQoAw+pamDC6rcIki77m
	UEAenkyIIZ/CUxQV79122oBe+QryDig=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q5huK15E;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772458816; a=rsa-sha256;
	cv=none;
	b=f+44Bzi7t/6XcTAwoqApCMY4svfxPisYXHABZ5SsEQYGf78KW+sXwYgtW+x7o8QuA9X4db
	d8e9HVKXz/XZIqXwsIH6wau7Cs/jiEZCH+Jjp7mCWzDOv0hpNY4ASYpuAkJLC9EDYAwfB0
	TYLoLRvBP9HTF+7lL32LlvWSG89VEFc=
Date: Mon, 2 Mar 2026 21:39:58 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772458813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EallJz9xECdXZv48leuK2XpZ4lpwJqacaSIYP0recMI=;
	b=q5huK15EqTTRO+3nHPePBsbko6xZ/0GeIwD5hy4IMqxyOVCUVD3C3s49qDBmmzo/XQPQcD
	FIvJ31jWoXhgpkpUNzcrfrGPRGZZTXKXamFlkqfPYkN6eKMgOcASCdenvQQfc5cWypXMuz
	CkR6Xv198yxModDZcGRESazm5muz/nk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>, 
	Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH] MAINTAINERS: add co-maintainer and reviewer for SLAB
 ALLOCATOR
Message-ID: <qjsfacsbh2lkzhng77zl4xyknsjybxvsuqulbfegy5moac4za3@i5gg57ddh27n>
References: <20260302101345.36713-2-vbabka@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302101345.36713-2-vbabka@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A84E3180007
X-Stat-Signature: ed978n37andsjjys4hmh1mk9emmsfbzf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772458815-811170
X-HE-Meta: U2FsdGVkX19U3DNZYtKpPR3nOF5XsG7MnLAKfesnN9tsaewpDuaNSzPGb+2Q7AV/WPQhYOYH0DWugXE4ngiDS5Jxw0Hh/XEQ5dEUpuF4U00AEK3b5VKxPRho1UVCO2uSUHb5M8ebax/qI4dfBFn6esjZyNwdj1e9Yq4m4PT73HGfqAoIKRAbpQ6SYH3PYNpF5+XvS8d5/d1+Svl4zaYtFNMkdYrFtMj4SmjjGSVpM0S36Ukg5n0WxigdugUTjA3wHD40jhQJr5ubZgFCLgYfvFBH5U+bAVS5tYZASbrU4aJt6fyCMgRkz4ff2pJaJx2/Rffmfsdh07u2AmWWOLUk1W5X12QabOAQkVVOtnVe9PJw/S4PEhJdBTEGrENRtXm1gLWhMVQxaPHWs33g4j17c5HC4m0uzHL07ESrh7FJm4gFpJxuFaqs2PmyfJ+vnSE3Uq0EY0oAyGQcrkQKfd0my00jfWXm12X0y9OlWVb/q0HggVexg22ZjtWJj/O4/tzsHwOmYFTfXWZU86cFH3d6RcOV1duCjjzM4dndKIjmZCEOsyFYbjmvAK3jA/2TX8AzWdyvhbGasXHiX1vW9TJVIJoHOI1rvUmEFDBGS1ijYg9bsFDJ+Rpx2gcmvhhOGAj3iczRatf7WzjVqe1GCR5b+tOGGQ9Uj62zGixSMwCK0SgIMeoepgmZ1uzk5ekPiwBVGM7SuRPud0fzhoOb6G76cIf+Owv0MZKj5QtE8mmqJ7b/0RdoXug4ZKLWFxCEaN//JuPzfzDsQET0daeQfaYLbGvyReStjoTGNomHzZzG/xGnejIuvMZKd4SUR8mMrDryYn/h6/bWYabj1xCSvHttFVDcyr8jY8Ftib/UmBMMn5AQorrmKahdXJsDuRIS589NTHu/BjUZDkJUYzyLbRtBw3PkDoFThMbGa5kVnaBYGQPzTKmR/RTJkm9EhvIVcAYDg+eOLKQcd35v31d6RTV
 9XOcwnDk
 8KZ3sDlJySTcsj1Krz0SEWCT3+Vf1anQ8OeV6VfB9WEwDlJHeeo88PWLzylzDT/GViX0LIwqjOCZ5DsTNcmaK/NxAvKXdrF/Dj1yLaGgM6DkS0aEACoadPEjgJeJLPoRDi/8frDOXOrIchINaoYtMJdKFEujmAA2cjiuIpmPVpBykfK4v7k3+h3wNu0FYJmHusUpMT+bme8cjY4/vlW9mjI13p8iOIWPSDPFmWjKsds0RkOx/Pe6R3jNX+FC62IDlB3Cw1Gv9Qw7A183uQCqJM3XLTyRlKUtNtiU/TdBx6gZKey/sXRhTuG1Ef50UXcg0arYgzbG3g06XF/NmLhR6uAwy9vB1S1y+9g9xopg0hIL/8840k5WFawltlClmYeO+gEfqJ1ijDu6VSgnFgY3FG2uELbutDcSURaPBoZzdpa4H58bJ1sLigD+PjLmWdxeeLNvCNpwIA65n7ik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 11:13:46AM +0100, Vlastimil Babka (SUSE) wrote:
> Promote Harry Yoo from reviewer to maintainer. Harry's been involved in
> slab development for multiple years now and doing a great job.

Congrats, Harry! Well deserved. Looking forward to working with you in the new
role!

> 
> Add Hao Li as a new reviewer. Hao has been doing very useful reviews for
> a while now, so make it official and ensure the Cc's.

Thanks, Vlastimil. I really appreciate the trust!

Also, thank you for the patient and constructive feedback and for taking the
time to engage with newer contributors like me on-list. I especially
appreciate you proactively Cc'ing me on relevant slab threads (even when I
wasn't on the original Cc). It helped me stay in the loop and get involved
more deeply. Happy to help with slab reviews going forward.

And thanks, Harry, for the kind words. I really appreciate the encouragement.
You were the first to Cc me on your slab patches and actively invite my input,
which really helped me feel involved and start contributing more. I've learned
a lot from our collaboration and look forward to continuing to work together.

Thanks also to Lorenzo for the congratulations.

Acked-by: Hao Li <hao.li@linux.dev>

> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 61bf550fd37c..5f3cc4193a8e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24350,11 +24350,12 @@ F:	drivers/nvmem/layouts/sl28vpd.c
>  
>  SLAB ALLOCATOR
>  M:	Vlastimil Babka <vbabka@kernel.org>
> +M:	Harry Yoo <harry.yoo@oracle.com>
>  M:	Andrew Morton <akpm@linux-foundation.org>
> +R:	Hao Li <hao.li@linux.dev>
>  R:	Christoph Lameter <cl@gentwo.org>
>  R:	David Rientjes <rientjes@google.com>
>  R:	Roman Gushchin <roman.gushchin@linux.dev>
> -R:	Harry Yoo <harry.yoo@oracle.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
> -- 
> 2.53.0
> 

