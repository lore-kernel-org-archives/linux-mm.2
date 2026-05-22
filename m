Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69546CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51AD6B0099; Fri, 22 May 2026 06:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28AC6B009B; Fri, 22 May 2026 06:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66746B009D; Fri, 22 May 2026 06:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB3E46B0099
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:56:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53884A09A2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:56:40 +0000 (UTC)
X-FDA: 84794752560.08.B809272
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id AE82B180009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:56:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZDvQ+BV;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3C8AA3aBQG4zBiFmg6i/Kea2xbAGhfwlk80hRI8Pco=;
	b=fjOFc9Dwvf9H4EeKDqvFTsYcJIX8c1CTQDj+goRbk3p39SXm189/rj2UWZTJlfthMe657E
	eQiMb3TNEUWJT4WaKH/kkQ1LMr4PSiz5HHXbq93D3veNNdVrWD8X3t5bT9RlPxiB9jc/bR
	/ITCgd3H3HBLvAaHoWtGRJ81/SZbC28=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZDvQ+BV;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447398; a=rsa-sha256;
	cv=none;
	b=AE90jYqIH7C7AFGCK0k1IotkAl39qVdeTQuXqOzapF/zPfFAvwMdWYW0WK45kPXKn1TVKC
	1Q3mzneEeDBhV5oYvt+E+lSFhhvHwGL+w/enb6x5JaupnGFv8h0c/OkTSdlfIiygUuwbKJ
	SMABqLSEx9Dzd5h7tfEUBL6q6gZda2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30A4160136;
	Fri, 22 May 2026 10:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E231F000E9;
	Fri, 22 May 2026 10:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779447397;
	bh=G3C8AA3aBQG4zBiFmg6i/Kea2xbAGhfwlk80hRI8Pco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GZDvQ+BV2gIhWz1KcWNqIokkPe3+pmnvjtNIR8a7OmQ20Vp3wjz13sSaV/AwQwWcb
	 y0KZqqt1/Z1Yndl3pxfh9EYG8klpv60UUkB/iW8GNYRb5JxG1qNpiJ821hOO+QgTD7
	 ZNY/DeESqUZO9+u3THunLruifoVxeSGm2han7zPPTGgfXYoflsgEVIwAHfrW1RrCBF
	 H6TEAzLOTFWGz1Ec3DiYk3GbRu58XR8da/ccOcyODVhw4/FJQpuMZ2TPyglqIwnSWz
	 51y7TuwS/pM+vTTa/fyHQCp3s5SVSIYBUZR0gIDbM77Po6lYqc6HgYyJn/PCuuraB9
	 SElpOCmLCj22g==
Date: Fri, 22 May 2026 11:56:31 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: ranxiaokai627@163.com, hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, leitao@debian.org, ziy@nvidia.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v3 2/2] mm: shmem: refactor thpsize_shmem_enabled_show()
 with helper arrays
Message-ID: <ahA2QHD439djStXc@lucifer>
References: <20260518123238.56344-1-ranxiaokai627@163.com>
 <20260518123238.56344-3-ranxiaokai627@163.com>
 <ahAwLxwW3ki9cOjw@lucifer>
 <CAGsJ_4xCDhj97=4pFrwg1-Cfh5MMpBn=yV=VLrCf1PYcjY+EOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xCDhj97=4pFrwg1-Cfh5MMpBn=yV=VLrCf1PYcjY+EOg@mail.gmail.com>
X-Stat-Signature: 6ym85e4bcisowf9chp1mejozpgek7gki
X-Rspamd-Queue-Id: AE82B180009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779447398-45638
X-HE-Meta: U2FsdGVkX18Li9OZPp5wLfUtsSFU+y8YFcTtNzXRRGegGzUW246EpGd6Ke4xPPBAUcJbVoY8fv0MzCO4v+wJBLotkB5lROFNtl36jNr2n1M7xawS7mzGeno5maaaochFT4jOmvo+6nyJ4g8lBMJXs1yFdBNLFA8BhcGoblKe03DFTK3J8W2DLjckYhQFYdPtceJA3ul+IooHc+0r2V30lMMe0Sb5izjXv+r4xFFkY9XGefy7z2MfeqUQJjgRBbrNO1z0KS5jBaWi1H5NJFaBGPSQ5vd6DVPnT0P6rb+vsENP34AalaVg/K8ZnlmciJuPf9kz8eRwgRUbTv7TfV0q7E/4+eY2oKZ+qeRCjXhT/qsYZfedxnXfc3GmNZ9r/EUOjuoYce/6/3x8yk8ja2hd11jH2D0wRnX5saA1XbvGkvH4ffK/epPocHPkPjaGt+O4nNCCl9kYLfLBRHhhYpicu9qqAbmRNnKly4Cwbde++OUZd5zU6b/tKMq2VvY85hHbDyr3wid09kJMbm/K99jNeTyB7SkfuoQye67jCKVaQJYvMwp7Isj5mhUtZFZ1QlOW2AEgrPR/kjZyGJWtPOxzMZWXCjmvs+zPCkrH1FV244wDoGoBJ7u+NHQ6dbJAezdqim774wcvlGONFIQ4lK8kkPz6j/1PAnGbfQ21Fq2N+UnEDnDlwuihWDTFfSAhgzIqSiyubJ7YBJrAQE/rexx7H4V7OyHxX/AcNWQ72sHTmeusis4TuZLOgtMJ8XLcXqi2VD1m5+lHBK2JbmEHs9UL60HrQm1oo7qDdUt57oWmrjlDEWMBipPgjoiNIe+5oA8MNDkA/PCzDUv5IkbjVxtIw/NAR5LA1CP/e46GZFuRhX5ytVa9XJxS5RMFl9IJ0uFUUDQa4ZErrrObrWKSWG+5UX++fp/ojfW+qdOAoD41KITYg0NxnC/Nb76UWXMi9ZzlkmZevgE2OZTZmjuLtk0
 ty7mkRVG
 GbYBCqOnFxZB/jhEupomMNcbEUh+p4E8+UesDaAGdW2xN4wgxkSCLs2+wQVh/v4w7XZf2gfNO1dd+sZ3jhKyxDJHYIPYXhqdU+WIlCsR2AIk+d3gWF23DCa35xMoJ8Ss44idH66yhPhkF7EnN3hKqxrlX1QaCMM2DqxrmGZ74g6U00Fvqbpe2gAFue7ct4dzvUXdmxPWZ+XRo4wjTl5fwy9+muw28rMYGOx0Z7yfoQs/ZZaKmDmGndBRKUGu29sREK+F82tGqkoNJpC8AsvA6ixoAElDi6CES4lVNUdyiSXEdLkXimEubQUu2oA8tcZNBqI1t7AGTe8zKNwJi+TYm3GIrOvX+oaRaI2/84qsqJYqm9s0xH08TOZcPWLQP1RNAImtW1sPDXn5qP1mnnjPeeHlTxxqafN1IaiQg+Ac4tyjN+4pPiibjynC8IjnC7ZzWUWFvvCsrmhpFTBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 06:44:18PM +0800, Barry Song wrote:
> On Fri, May 22, 2026 at 6:35 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Mon, May 18, 2026 at 12:32:38PM +0000, ranxiaokai627@163.com wrote:
> > > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > >
> > > Replace the hardcoded if/else chain of test_bit() calls and string
> > > literals in thpsize_shmem_enabled_show() with a loop over
> > > huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
> > >
> > > This makes thpsize_shmem_enabled_show() consistent with
> > > thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.
> > >
> > > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > From: ranxiaokai627@163.com
> >
> > This does not match the From: field of the email.
> >
> > This is violating kernel process. See
> > https://docs.kernel.org/process/submitting-patches.html
>
> I’m not aware of this rule, since I usually see From matching
> Signed-off-by. Do we really have such a rule? Sorry, I might be a
> bit ignorant about this 🙂

We do yes.

But I was wrong here, as the From: field was provided inline (doing that and
including the From: field in the To/Cc I think suffices).

>
> >
> > Please either update this to your 163 email account or resend from your
> > zte.com.cn address, otherwise we can't take this.
> >
> > Cheers, Lorenzo
> >

Cheers, Lorenzo

