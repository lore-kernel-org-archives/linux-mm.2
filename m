Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDEA7CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 02:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172BF6B0005; Sun, 14 Jun 2026 22:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123D86B008A; Sun, 14 Jun 2026 22:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012B56B008C; Sun, 14 Jun 2026 22:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8AAB6B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:16:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76E481C2734
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:16:16 +0000 (UTC)
X-FDA: 84880532352.29.9F3F09D
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7634680006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:16:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UtXoL8Rv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781489774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evnYbr31oq8hdGPu0I2FlzbaC2mIfZGo5ZpQXXksHAc=;
	b=qONlZJUrhNmE+FDeHB5yYxuB1eQtMyzcYvHo8YI1Qm98I4K+DRqlf3v9nrDzATmS1iqAB6
	uEbjR2M56EyqLlvuu93dIyObwZFlCfKREAVA+qZdXo4BucrzzlOOnxeOuCBUeCuUOUABAN
	8m2lxkIyleUYJ3Y3e45S6snK3sftF9k=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UtXoL8Rv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781489774;
	b=qytyPxpITBtoZgO9o3dS16kjxXiJKc+U0rdgbEj3+0jiN0vp9KvqM5m7RH9IBaFVvDct7S
	yJPGpbFnNf0nyvqKK2WfOZAbgY1ciKrTFRL0JBCJvTO9XmHwyQfTpGolH/woOUOy6Dsp1z
	C5zFsmO6rUPRH4mvUCe54HXj4m3NDXY=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8423f236418so1453844b3a.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 19:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781489773; cv=none;
        d=google.com; s=arc-20240605;
        b=ICm+N7rQg2wf1VODXEtNE4liKP5aLrAeVbQzDTKcbsq+ACfL6qN4NCsQRRhrja8zDl
         7+Jpy4+HWT6W14v0uL1YETm2t4Oz4L60V6MVWrG75vz+UgWnsuiVuOYVf+MrtwBkQKpY
         6Zr/C6zmDAX82pgKXQf53045sX7D0uS+rHY5veA8VFDrpXkL3vQkNYh1TNtb1MntTu/5
         cI9RkdTTI4JdfqxsZLfbvdQKcbCkxGFQ1bU/IU3d/tJIUuyX3ZpqP7trwluYMfjMk3nJ
         ZYL5NhAvH8QK4fAQROJsI6fUj0OrRSEzbWSwzLi4RFsdimtTJ99s0tRwlqDpkmMgj6c+
         L17w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=evnYbr31oq8hdGPu0I2FlzbaC2mIfZGo5ZpQXXksHAc=;
        fh=9f7maHROW9T5JCY1+c0Y1F8jxBTRgXHyo9u2JlcMcw8=;
        b=ct5I+YTVQLnFIbhFz99tIKj8Ei2fxY3uQ9cTK1bFeZpzqOHXvtnYU9BGETptJ8pk5Y
         makMRA+inTSuqhle0gvekCxJDUEKgP596Z3kFCL/i3KabDBLLaP7PlL1hQQgM6URojwk
         ckvVqN0vzq65iwl385qGGq8pjoNQ7H7NoMCKDCteIY1lxSAnFqTbhY2rJG4JVwKavnNQ
         n/l3DJ00NxQ6LD2OUmUPURM+5nf3cAb1GaUyol7jcBMqGqZL8+Kztd7JwMxMPvKYGXv7
         lk9XTzoUcM80U9kTksZ5zMDQ42G3RR0lGjuEJC7vj9UXUJW3kmfjTwzGirGzfUJh5wnu
         Z3hA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781489773; x=1782094573; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evnYbr31oq8hdGPu0I2FlzbaC2mIfZGo5ZpQXXksHAc=;
        b=UtXoL8Rv6YxAuuGpApCnHqh3EHBvnNX7KhV4TvegBBekGCPKBr6PxJ9/ILdqHxCIOf
         OG7QZ5qUkLC1jJGDh6pU/oiLktotlpO94Osa4bGaJqc8/G+wAa27+smJrxa3cjBAJg/1
         Suz0yBX2SfosE2NuXJ+a9jhuzWpa+2joUxWYbI7d4q4//hyLGkTfmaWnRJbK22mcBIJd
         oo4/pbIIYira/rnhxXUwWUy0hkgfRrqCaRypCrNNEaHhz38pX8wuilA3aXnn3PQNJT5t
         4wt+66jyXVlakmm7jJHkjzz8jEVM/jBF7v0o6FW81VAx/5mfZJV6Yfj+VIk0YLPV57Xj
         KGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781489773; x=1782094573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=evnYbr31oq8hdGPu0I2FlzbaC2mIfZGo5ZpQXXksHAc=;
        b=ksrHrka/QNseRwoWGRMsZmD4Nj1xsfXevGO1oRIsHXYN+i5Kojm2wJTL39/lzI9z/I
         cWzf1YJXDnH/2Dn1+wVwMs6jJMlxwpikYGSlRkLfv+fZQW+y9hzI4JBamffHbQG3RC+v
         Ksq3/d9xZ+qWCq6tbYKL8J7gX96Akp6XPM1efeft5jbgmMJip6XDECdCdyPoznH7Lgl0
         sSmHcP41yoWieB3pZnrBbLx5O5OHh77ECBlLCiy5BZo7VFiBSHPhGciHrwVa9psLi0zi
         e49a2+xzcgjw6ypZ6iRUCxipfOBUMgJIx3fQvVZtSRM60G+jTpJJXTwpuAe1R+N4Ml2A
         HNAQ==
X-Forwarded-Encrypted: i=1; AFNElJ/4zATNwapVhpdyjxhCpM7To3hMybKG2zccF5dDReakP7SFT1g0Ex+utJhfDugtbDN9OGH4E57Wzw==@kvack.org
X-Gm-Message-State: AOJu0YzSeE4v6d4kVOXRMH2Im9Ue4qTntQoxpSpb8MRtEFAfO6ruV8Uj
	GPcV9Fjne688SLOlBLahHHB1RAP3kiFO76tr6d7f1UFTOLD8fJOt8WE7rKilSvc5sqM+UhsOno+
	c4uWcqWAJMxN+GdkmLkj1tO/SCfTaC1k=
X-Gm-Gg: Acq92OFz0K0Xy8+EDfbDcUiaWyYdyh2EGaPOZGE2rix3RA5mteVYrLZ7lyYXqF7ryTt
	httadIW4Lmfsxexw7IhbIGpfiz6r2BlTx5ifMP9q7Iw43k/YVEimF+y734/8lOmLXsIikKFj4ay
	76FxXgvUPsl+VYaFThlHGds4GYr+ZimFsbxzFjr3NGqN4VIYmKSNB5Zb6IrFCZ4ylEqEBNAU9oI
	au4lmeNaXUDTtzpJssLgEBnTkRvkEqmaKQPS3GZ8fNXmFuVhStVaEj3ClBFMdI0XjF3OEQVvFlV
	KL2bZ7872Z48+KOKmXy+EqT3zBSxRbi6G81g0JL43S+hhkTdEfdnajpSDdPapHcrwnI+TVlrpNm
	ZLx1Ch80EOVEwIu4K6UO6Bb9j
X-Received: by 2002:a05:6a00:3908:b0:842:732c:5687 with SMTP id
 d2e1a72fcca58-8434ce3f8famr12361190b3a.22.1781489773160; Sun, 14 Jun 2026
 19:16:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org> <aiuBoDbQc0N-l7e-@fedora>
 <CAJuCfpGSHfNUvL9AzbftSg=uGRW4cJLbO6iB15keyN6A_eSWEw@mail.gmail.com>
In-Reply-To: <CAJuCfpGSHfNUvL9AzbftSg=uGRW4cJLbO6iB15keyN6A_eSWEw@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sun, 14 Jun 2026 19:16:02 -0700
X-Gm-Features: AVVi8Cd0IZA3UYw1GOqh858BtHcrz52-nGsn6-ywXz-Dz05xnWvs8Qh5w7kHwt4
Message-ID: <CAADnVQJPETYAOd9R9Bg2JuuF1q7grg8VtEnvdvr0fDFhxb9O6A@mail.gmail.com>
Subject: Re: [PATCH v2 05/16] mm/slab: introduce alloc_flags and SLAB_ALLOC_TRYLOCK
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev <kasan-dev@googlegroups.com>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7634680006
X-Stat-Signature: 67fdfpmid4icadiidbdf6zncwua3e5tr
X-Rspam-User: 
X-HE-Tag: 1781489774-847021
X-HE-Meta: U2FsdGVkX182+X0dE47HvHdtykBRHNKFh3Habc6m2x6d/L7D1LY6JtB863AxeA0bmC89MEdCoMsQ5txI+cTxgPpZSyKxsuzaHPqnolkq4PKyTA83mf1oTAekRKMsuR00X1Haw3dEBT8BnJybOO74V/NyD/JuQiXuEjwJgj9INFwoeAqzaP0M1DEsQAvySooiwLt1dY8HeihWR7rv4ufFb9NDNIjL9w/Lb7bJj9nxGMrrt7kfafj66vN8eo19Nd0MI9GTXDjuQR+e8QAAfSjvn3rcX2d0noyFt6AXF5EULMGNl/jjmVx/3vhwzNdbq5IeKx64zQJTwRvd2MJue61uUO/9bLdFM4wx1fDsA7sePqAiEeCxBDFOQMbKVbC0WSYj9yFYCqBIVGprgia4KNof6IOC3ORCp+cUqfVpYFRS9l0oMHt/Q3c20YOcjYfWyRuMaHoE5lNesBjA+iyckJ/J691Pr4a2HrQ72nKVF/7l0k1dtv5+M5IBbqGGDVhyrvbn+j4A65NnYTaM6x4Krbym36qgGf1rD1Wo9zQNdU1ihq4si63CZ3wy52CQx1Yk9sCLDUPI0WHG+miv5sbqqapU/Kt39+SwxHo/yGUk1Nw/iexfPNhjCZxWf7YNmSrzDFC7FL40hYiqrogmGp7FBB//Yiql0yCisw2af6VXIbL8Gq6yP1JHu48Q7bh5sayjqMMZCNNvwdJWGsQB8QnF2dZvswElJv8emRcMyK03bjJcRXYnqAPEJcOYcelCeyc1RvDxxZyLm1oEcdGjkcUWxQ/RFm3Bx13l625Ccz6zP+KheiUjcb6QpJ7AqfpTjTj6+nxaWEqJZBoHO9FdtIWK7+SGhM8V8VCjYp13BqMVFeAQL6/GKGjvOWVJYHQob9elI7/RRM51fO5WcCJ6kSg9oCwJJIqSffi8WOCQ1uN1sAV7r/pCRuQ7V/Bn12q9TRxaAxstdk5xNJvKlxBzMKchoZM
 I2QillpL
 k/9/+L32XHNmV5gRflmSeQTc9ODRzvCI2GiZPEHzF6BcrA0PPnJbceVrB2oxZtAvGJtvXLGMyTlkvYw68nznqlXAwQf5tUcddDRBWzd3hsBcC+Nd/BmbQvE1GbKx5ri9WVfF+rOTrIAJgiavofsyALrx9vJOCNKO6aopds6sxBRThAlTqsuzH2oLPpvXgdRaiIyXtLh2FI4UjDMB/bW/8kgtExk+nVZYD4E9188rvwo+pxJG7GMitSwA4Xucionr/wQSdvT/WpHRQ8f7W67nr3Ur+ws/krqEQWePcrAqsDq9XMdpDMmCQW3b/0iHyvYWZMVZ2mC6y36m9D6F8pgCZEuDPPN2JRxYSqoFs34Ih4esfujZ7qLLAlM5W/l3MLPxIaFqj7AatgTrT5ZZoBRZAfCnseltaXO9UI9viypg9BuYVrFMbxZd5ww1+VQ8CNsczcShBsenXlBgGxmjpq87G64/p9yfy5E4snVZJFrFsog1S3fYkyyYSmKD2CxD7t7G7flXy3IOfD1K0G7EzvaTVXVBkyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 14, 2026 at 7:01=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Jun 11, 2026 at 8:50=E2=80=AFPM Hao Li <hao.li@linux.dev> wrote:
> >
> > On Wed, Jun 10, 2026 at 05:40:07PM +0200, Vlastimil Babka (SUSE) wrote:
> > > Similarly to the page allocators, introduce slab-allocator specific
> > > alloc flags that internally control allocation behavior in addition t=
o
> > > gfp_flags, without occupying the limited gfp flags space.
> > >
> > > Introduce the first flag SLAB_ALLOC_TRYLOCK that behaves similarly to
> > > page allocator's ALLOC_TRYLOCK and will be used to reimplement
> > > kmalloc_nolock()'s "!allow_spin" behavior. That currently relies on
> > > gfpflags_allow_spinning() and thus the lack of both __GFP_RECLAIM fla=
gs,
> > > importantly __GFP_KSWAPD_RECLAIM. This can give false-positive result=
s
> > > e.g. in early boot with a restricted gfp_allowed_mask.
> > >
> > > Also introduce alloc_flags_allow_spinning() to replace the usage of
> > > gfpflags_allow_spinning().
> > >
> > > Start using alloc_flags and the new check first in alloc_from_pcs() a=
nd
> > > __pcs_replace_empty_main(). This means some slab allocations that wer=
e
> > > falsely treated as kmalloc_nolock() due to their gfp flags will now h=
ave
> > > higher chances of succeed, and this will further increase with follow=
up
>
> nit: I think it should be either "higher chances of succeess" or
> "higher chances to succeed".
>
> > > changes.
> > >
> > > Remove a WARN_ON_ONCE() from refill_objects() as it's now legitimate =
to
> > > reach it from a slab allocation that's not _nolock() and yet lacks
> > > __GFP_KSWAPD_RECLAIM for other reasons.
> > >
> > > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > > ---
> >
> > Reviewed-by: Hao Li <hao.li@linux.dev>
>
> I would call SLAB_ALLOC_TRYLOCK something like SLAB_ALLOC_NOSPIN or
> SLAB_ALLOC_NOLOCK but naming is hard and I don't claim myself to be
> good at it. So, feel free to adopt my suggestion if you like it or
> ignore it otherwise.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Just noticed "trylock" in the #define SLAB_ALLOC_TRYLOCK

Please call it SLAB_ALLOC_NOLOCK.

Initial api was using 'trylock' name and it was a mistake,
since people assumed normal spin_trylock() like semantics.
"trylock" implies that it fails under contention
and retry is a normal next step. It's not the case.
No one should be retrying. That's why the final api was kmalloc_nolock().
So please keep this important distinction in the name.
SLAB_ALLOC_NOLOCK should mean that spinning locks
should not be taken. It should not mean "just go to trylock everywhere".

