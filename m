Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25BEAF327CB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 09:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC4C6B008A; Tue, 21 Apr 2026 05:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8931E6B008C; Tue, 21 Apr 2026 05:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0B86B0092; Tue, 21 Apr 2026 05:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D77A6B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:10:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CB60E5C00
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:10:11 +0000 (UTC)
X-FDA: 84681991422.04.F90942D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A19218000F
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:10:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sSf9asM5;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776762609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0q1v4V6PWCZBDK94gxJCrU6RUA4mVYi8ugxGaFE27A=;
	b=mrCwUfP0PkANaWCZcbJlIuE2kpFW1HjUFnGzdcA5XIDKOGiC3nCF0kOvVYraRSNWTLc6rF
	F1L7tOSGNcw02B0K8GwX7CyUlc3fIOtQGNN/lglBjuLoDJvZUZYEerKTszcmHby0LAQcF2
	k5Coco738Ypx1kYv+kpaw3ni6JBxELY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sSf9asM5;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776762609; a=rsa-sha256;
	cv=none;
	b=kJo2Wxi6TlghNE+Dy5QR3FJKoxsqI8xGdTqfZ3BNzZTPB4kLCiKDFRCdk3va59DOOtzbMd
	yQDHMl4gcemA1q3ER8+GcWcUJQc78SlfIjDtXItv/12JEpBevD2H9DKILu5oVOuvMNA+ru
	RFyu98RM427amZYm8bUu8UWvnU8sDqE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E62A66001A;
	Tue, 21 Apr 2026 09:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0A9C2BCB0;
	Tue, 21 Apr 2026 09:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776762608;
	bh=EOuIqzkpcmELzfvgEwMB+wOPJGwzb6s9drDlHWs1PX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sSf9asM5BJy4OtU9Ler+mm48ofhrpMopAx5N2doKVLinZiIPOYFvxoZbdgE7DO+rD
	 TKuInnli9Dp4RphmUAoSN7M6sS607GgWgKTz7LiaRYVRAZjxZYN9z3Kp6DjKJCIWTM
	 EkZQYTvSldOmUNLEYPHIa5WS8eXkxeJvTPU6EjqnUQUFp1EqpFb+RwFp7WcynOuOmk
	 SoM7AezHNgMEIfojY7+RFlFgopJw/Ds4ZZoXLKiZ7B82icmpwCECV3ywPtxOwY4VE2
	 WnNhqbfV+WuqDkER2R1DWlKWSa9K6yJWR3p5ji3JkGQuAvkyc+tlTdTT7C4a/JboAB
	 jAqYPbpgSRjOw==
Date: Tue, 21 Apr 2026 10:10:02 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Ye Liu <liuye@kylinos.cn>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: handle potential NULL return from
 anon_vma_name_reuse()
Message-ID: <aec-syTrogS07Rm9@lucifer>
References: <20260421085056.26033-1-ye.liu@linux.dev>
 <2f4a1999-fbd2-4cbb-8062-5574d3c1e7ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f4a1999-fbd2-4cbb-8062-5574d3c1e7ce@kernel.org>
X-Stat-Signature: fstsfhqs7cwe8iy5maaa19eaj86nhesj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A19218000F
X-HE-Tag: 1776762609-659168
X-HE-Meta: U2FsdGVkX1+IhoZ/pMfhoiW9Lpk1iiYx13zV3f7Jo/VgzmJ8Kixr0xsLHOVr2BkL8TDrzQxm6IkwhsH3ivGEOwfVR1IhAP+pR2y8EqZgxVdU4wHMNF7vFb+ao369nwjDTMc4HaP31tWEChhe71dGv4omctYI9Iv096+/qPR28JtPtDFwUz7DCdqJ1yoOcFcG6w59VT3K13hSEvN1k1LCijj+xlHNsnbRMXeRW64Jy378MvCXC3wpxpjjZCcR0S9gov/bzDmAxEOMLS+8L/pUUs/nkUB1FEdsKcSoingpgoQsrxkYuCMsHiKcvv2pYWXuwCdf6D8oNJ5nVAndBZU2EFKg0Ovzd6VidFBYiDrMq76/xh8kB1eJVzPJyRs92OnUEFSd1djZ+Fj7EoN2kNZnViz/jYUCvjywLakTHgsgkTT+fdMY7Dv3OO66Ds2//ijAllKkHrAobXn7bSbh9gQtxc+QG//U1yBA7/xM61M2Kz4FgtoHIrFznO+OpOkcWPl7qsfMAK+OFEpgLX0Ut32eefin5KQgN84E2czx0MUxP3HNjSLq8hWasRriHdej5859NpYoELacWJ1zRD2+U1lLupz+UdMnVLcE/rq/WNlRL1xIeounqu352yLZpb4ks6l3mQq+CQN26gswicuVarHQMl3gERlQVWJN6yO077mRLai+8TbrkoOy36D1M/dlEWLpQm62A8XL8PcSXHsaB3IyuX6Gc8J7xJg0j34uwkhsAfLO0sO8VpzvtrCYT+ypRU4MN9lp6yR83+HC+LRoB1ZcwPB6r3O22ffbJwH1Ck4M9U5pnY37FlA13MabN8mVMtFlfgpYnz1VNql0dF+18fCL9yYLlPaAnA6tgTUXYu6YQu0wxX8SyUnUE7DFogNOQV7yIVjj3u23MsI/kaszuIynwP9yAFPLTD0Wx5ChkbN0RQb2bhnhzDvt4ZHebUQxjQ29eMkwG5Hq+27EgUJjO/k
 ktHA/LzQ
 k+K+avPYdLVhXOukOgLPZv1o61jY0oW82fzsBTeSM3PYIxtGCaoqxwEqRThLsi6lJLWACi4eHXskzRlT4NNdHPD4wXYOVsb+tMoluF13Ey0ToY/82i1daevWqQpaFlqwgQX/rPS4t17DRafT8WTBpBN6EpPTjOzF3IaE+mJk0sFOaGPPrZA/3XK1nZUTb3i3tZInzwnj+uP/YT4hTnTid4LP66V65lrlV/GLMbGrgB/qQ3627lNPFZNJN/yNlID0NdHTvbepkc6Z3CT/8U6vNb+F3r8KGLroVOgg6veEIBXaCWYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 10:55:16AM +0200, David Hildenbrand (Arm) wrote:
> On 4/21/26 10:50, Ye Liu wrote:
> > From: Ye Liu <liuye@kylinos.cn>
> >
> > The anon_vma_name_reuse() function may return NULL if memory allocation
> > fails in anon_vma_name_alloc(). Currently, callers dup_anon_vma_name()
> > and replace_anon_vma_name() do not check the return value, which could
> > lead to NULL pointer dereferences.
>
> When, where?
>
> If we set vma->anon_name = NULL, it just looks like there is no anon
> VMA, or what am I missing?
>
> >
> > This patch adds proper error handling:
> > - In dup_anon_vma_name(), if anon_vma_name_reuse() returns NULL, emit a
> >   warning via WARN_ON_ONCE(1) since this is an unexpected condition.
> > - In replace_anon_vma_name(), return -ENOMEM to propagate the allocation
> >   failure to the caller.
> >
> > These changes improve robustness against memory allocation failures.
> >
> > Signed-off-by: Ye Liu <liuye@kylinos.cn>
> > ---
> >  include/linux/mm_inline.h | 12 +++++++++---
> >  mm/madvise.c              |  7 ++++++-
> >  2 files changed, 15 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index a171070e15f0..9bbaf8287806 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -421,9 +421,15 @@ static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
> >  				     struct vm_area_struct *new_vma)
> >  {
> >  	struct anon_vma_name *anon_name = anon_vma_name(orig_vma);
> > -
> > -	if (anon_name)
> > -		new_vma->anon_name = anon_vma_name_reuse(anon_name);
> > +	struct anon_vma_name *new_name;
> > +
> > +	if (anon_name) {
> > +		new_name = anon_vma_name_reuse(anon_name);
> > +		if (new_name)
> > +			new_vma->anon_name = new_name;
> > +		else
> > +			WARN_ON_ONCE(1);
>
> Triggering a warning when an allocation fails? Certainly not.

It's pleasing to reply independently and see that we've reached the same
conclusions here :P

I mean, yeah agreed obviously!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

