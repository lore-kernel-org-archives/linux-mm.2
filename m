Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7492ECCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B698E001E; Wed, 22 Oct 2025 21:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23318E001D; Wed, 22 Oct 2025 21:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C394F8E001E; Wed, 22 Oct 2025 21:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B38558E001D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:39:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69F7D48E8B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:39:46 +0000 (UTC)
X-FDA: 84027672372.04.4D5B0CF
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 793ADC0006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:39:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b7rmU2yr;
	spf=pass (imf22.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761183584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCgsnRi7DdXq+4PeoxX5w1Bin2sJADD0GjGW6qb07u4=;
	b=Xu9BYsDdJCGhxA9rJTxbe2vTErKQwSDrkbtJdD8qMs7T/VYlXcnlrQIHhsX7TCBz/+0MUj
	sXlaX8SbvHCUNkbF7/Px6LxidWsMJcbwy/Nybos/GZftDA3ohTDfpiIIia0cy+rWgg9eUB
	gkNrj7hLFyJwWXgqDiA4+i2nxkQ4Mlk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b7rmU2yr;
	spf=pass (imf22.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761183584; a=rsa-sha256;
	cv=none;
	b=SvbpODrxVD86U/MCx7NX2BEq+knV9ShilcSlwd90BC+hlk/f+tzpqLtYotk0SUu43eoPaE
	vIg6Nl27gBvubzdzsqpgDEJgAXsb4AjLweS9vwNjhLQuku4YSv3T14CqxGK3NdeXElf921
	tYPo3VrNZ+9rorWFSYcawzWqAbYdwQE=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47117e75258so1552785e9.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761183583; x=1761788383; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aCgsnRi7DdXq+4PeoxX5w1Bin2sJADD0GjGW6qb07u4=;
        b=b7rmU2yrrIMYCpX++1LIzEahlpThifK0rzxIiQ+EGlkXqALcph72la3aocW+m5lorx
         EqsWHxW3jtPZXkx0YDYl0uTZhzcSv2eRdWtjsvP/pgaDY9NAVyrqLS2VtvV9aVZvaBb2
         f0LHygY/mAtEdryHLlKAiSm2hFbnNfjP26WzNZOJ2ynkW8esxCyWaEBjjIysve0S5eJ2
         RdcHTOIk+FI5oMQwevByMBiwN0nOZLdT/s7JVsOElFZnQETz17k1K31g5WwPxku2GVem
         A7nSUw1oxaB6ROYbB09EpeZKA1aT89sksbyW3z16TDmBmSRcky8OSPLsMev3IsT1ZSqB
         7jfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761183583; x=1761788383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aCgsnRi7DdXq+4PeoxX5w1Bin2sJADD0GjGW6qb07u4=;
        b=TSTvNvNK1Fr/cJdOuJLTUX0CEMfMae2/Gz/MCQh+we0MBkLYxoQiPvuc5dgWB5spGi
         enTXIGszk9jOOOk3F6MTT8X6RZjcdo/a3n4OcMBhSobyX7zvCRHqT9t998No/+M4cE93
         8oKnVxBE6D731/1WXoApJr11fII9chScqCqUaQYRv7JZPvKfWrcv+Th6lHevh+iqpJTT
         /G0KFpSgLINjeXwQH9So1F0ocKD0PFQpjZY76K5+9pk6qGuojuzT7yEG1URg18zUB4Ov
         6+sIpJYgFOqT4mrWspq1F59hs3TYXiLR1cH1VtfZV7wRbdUhmaqWnTpKyanBAsisYcI2
         VWlw==
X-Forwarded-Encrypted: i=1; AJvYcCVjhkD1oay8+3hqa6pK2UQH/P2klL/wP0I0a0iQUnVicApen8X9l5+oyKWeA72aIXeQej3byZnz7w==@kvack.org
X-Gm-Message-State: AOJu0YxfZ5rw6OcSeIkEBq6vscKfiJXks2ooMzOxq11y7mm3MKXSj883
	EYzs2Vj2Zrn98L/rEPqn6lrGM2lXs0a/eN4NZSjjSH3Mytqh3PejgjVgzfwiQxDeoMPWWR7rVjI
	qvAxNHki892Yy2FbLNW62SW/Ofbe3XKU=
X-Gm-Gg: ASbGncvw4RDV7MzfIk00bVKuGpo7ViNQUGL7LlQnaLfVbslF9ZPREffgIJB8M/I4NuZ
	gmn+52X3kPTZ05GqdpWToJCFi5iytxOcrEYgHY27Vu0TVSlTxiS/YYpknh1AqVngg9v0ltk+sVw
	/CDPG5WY8tv8zGoWLvvip7Na9vVdlHHgv0pCoq4KdWD/BkCXZP7mCZlYLQkNFlW1niLGVgzMrPp
	ZQEf8yfC6JN8A4OLfTi/VTeGlJmDk2+NNPo6N2OrvJpmXgE2WP/lnphEQP7o3Rq+7LOJROvKAfZ
	iNdY7np8xi1Uzim0QVlFuJC8ddn+
X-Google-Smtp-Source: AGHT+IHaoIGDfmHhdkPRo4MNsgmOBYeFnVuSgdjaRFMt6OjYkcbtKdwZsGshPjXi1FZxU1k9s1QNF+wMZKYGxIIs7as=
X-Received: by 2002:a05:600c:34d0:b0:46f:c0c9:6961 with SMTP id
 5b1f17b1804b1-475cafae8b8mr3068325e9.14.1761183582636; Wed, 22 Oct 2025
 18:39:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com>
 <20251008203111.e6ce309e9f937652856d9aa5@linux-foundation.org>
 <335827e0-0a4c-43c3-a79b-6448307573fd@linux.ibm.com> <20251022030213.GA35717@sol>
 <20251022143604.1ac1fcb18bfaf730097081ab@linux-foundation.org>
In-Reply-To: <20251022143604.1ac1fcb18bfaf730097081ab@linux-foundation.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 22 Oct 2025 18:39:31 -0700
X-Gm-Features: AS18NWCpy-eVIKqwjq3HvvI-t1t4YZx5136aumXfPGuarDyJS0x745rdekxcgMU
Message-ID: <CAADnVQ+o4kE84u05kCgDui-hdk2BK=9vvAOpktiTsRThYRK+Pw@mail.gmail.com>
Subject: Re: [PATCH] mm/kmsan: Fix kmsan kmalloc hook when no stack depots are
 allocated yet
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, 
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev <kasan-dev@googlegroups.com>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, Ilya Leoshkevich <iii@linux.ibm.com>, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 89q8bpz991rpjo8zb3ujqzm4opi5qhha
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 793ADC0006
X-HE-Tag: 1761183584-775276
X-HE-Meta: U2FsdGVkX1/2OIxRdTKUzebS1KLCPyBPPAWPeDd9IAPIRIIInn19XHxa4ImG9K7kbBbsiiRL2KAMOG0YW2ZzTRxP3q2F5Tc+adcT4rC/n4+n08i1I/dQpunFiaAUarW+wRpKEceeUZyc4MUW7YkvTL+ZGyDxFspY+sFib8no2EisX1x1D6zOuFM2pgkC89MU7M4u5iTQkFDMzhEpr0bi1ZVW+/JE759+qKc+laSjjYFjGJYs9EBQcRUJefAIZVUhTy8YWs9D8xwCO3b4ejZSnxLb3bcE0jrPHFZs6wOUCyHJ1lqPrWSL5WRHRc+ebQCRL31BHLlaGBt+LN9n487ss73OAhbvSGkcL4cFpD225m5QDpmfDRCymeIFIfWsDDU6WL4jBPRlQlEN/YsPXx0P25+c8cMymGo6ennAv8USUvDWEG0TuzsE8SPzlZ3gPbl/FV8HUidgGQ/9+CIIO7Qfsz7FVAaOZfRqYPABve6zCGaB7oPfqxZ9uTZnmst865tMXtYk0p0MKn2KTu7zl4LydNTHNP64+LgsAoh78UQXyma8I+F4W546O29cQyBU72F+ukRhPMCTCBGD6kS7Mm99ow9G0WAop3FAtzUxiOESlyDTsoM5qlFFfkrikg9G6efDYi+35qjjPh0lpS3ZwGtXKddKzn+5UEBoy7G70NQgxiT9KFyQHasL+aRqXgtOTJtsXqx1DvF675R0M9aeA2AQjtenHHJVn5kKIEkrcK0cEloEIwwFvw4/LVZPmRXCpVmC419XacFM1gy9qz0lWv4kjYqV4RyddUR90lh+v8eEmlRV3/KWDJflGiuaTXBGtebKbjEFpDmjqRPbJ/sTa9bd1buVLExQgOjicNNRVQE+LHlsWq6L82garoMGrlqUCE9RiRxvXk4IE4NDc3SCXE91j1vd7TG3DQt1oawdZH77GMMzs23cSLovj3sShfQAk/9EnMzafbGn6Mbz+4UnLHv
 QjUxBc2k
 oY2TD4ZzP1egMCXu78I2Iei/MXDDyrUbevmTn8u6rs2LtAdUx+/e/wpjuRaHIfw6zCkNKiOD8u2DtQZMhEsW65tBfVsWGJNX5Gs/hzU9nhCwlugGuWFFiEsep0Q70iQks67CAOVQdoFuCIuBenRj91pAZ70Dyyb/PX9ho8rszuwH/+/5t+xpOvUiiaBsCipNy+V5Nv7wEKatQp+2VDjcuDlmjePHmmnatZ+dPYTfH+VcDL4VAIauh5NXawd2u+sR/QTnwhsF/kaCE58qsEwaFeB52rLoMRMcHBgdyTmRcZ50OUB1Rnim1XuyYqeUxpeHmbXouiY1He7nb41sc4rdMQCBtSoHlaXKFH4r6tZA3iGXO3XNIvcdvD2pdwHeLAgq1kAtS3NwgCOoftoQpjwUiJnuTRoy2VsGnODaENZ2ejaV+fY0wOnYcyVvapcieTXylgYoSeBY8/Su9ZUhTY6vFRmKOIPwckAVHrnXu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 2:36=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 21 Oct 2025 20:02:13 -0700 Eric Biggers <ebiggers@kernel.org> wro=
te:
>
> > On Fri, Oct 10, 2025 at 10:07:04AM +0200, Aleksei Nikiforov wrote:
> > > On 10/9/25 05:31, Andrew Morton wrote:
> > > > On Tue, 30 Sep 2025 13:56:01 +0200 Aleksei Nikiforov <aleksei.nikif=
orov@linux.ibm.com> wrote:
> > > >
> > > > > If no stack depot is allocated yet,
> > > > > due to masking out __GFP_RECLAIM flags
> > > > > kmsan called from kmalloc cannot allocate stack depot.
> > > > > kmsan fails to record origin and report issues.
> > > > >
> > > > > Reusing flags from kmalloc without modifying them should be safe =
for kmsan.
> > > > > For example, such chain of calls is possible:
> > > > > test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
> > > > > slab_alloc_node -> slab_post_alloc_hook ->
> > > > > kmsan_slab_alloc -> kmsan_internal_poison_memory.
> > > > >
> > > > > Only when it is called in a context without flags present
> > > > > should __GFP_RECLAIM flags be masked.
> > > > >
> > > > > With this change all kmsan tests start working reliably.
> > > >
> > > > I'm not seeing reports of "hey, kmsan is broken", so I assume this
> > > > failure only occurs under special circumstances?
> > >
> > > Hi,
> > >
> > > kmsan might report less issues than it detects due to not allocating =
stack
> > > depots and not reporting issues without stack depots. Lack of reports=
 may go
> > > unnoticed, that's why you don't get reports of kmsan being broken.
> >
> > Yes, KMSAN seems to be at least partially broken currently.  Besides th=
e
> > fact that the kmsan KUnit test is currently failing (which I reported a=
t
> > https://lore.kernel.org/r/20250911175145.GA1376@sol), I've confirmed
> > that the poly1305 KUnit test causes a KMSAN warning with Aleksei's patc=
h
> > applied but does not cause a warning without it.  The warning did get
> > reached via syzbot somehow
> > (https://lore.kernel.org/r/751b3d80293a6f599bb07770afcef24f623c7da0.176=
1026343.git.xiaopei01@kylinos.cn/),
> > so KMSAN must still work in some cases.  But it didn't work for me.
>
> OK, thanks, I pasted the above para into the changelog to help people
> understand the impact of this.
>
> > (That particular warning in the architecture-optimized Poly1305 code is
> > actually a false positive due to memory being initialized by assembly
> > code.  But that's besides the point.  The point is that I should have
> > seen the warning earlier, but I didn't.  And Aleksei's patch seems to
> > fix KMSAN to work reliably.  It also fixes the kmsan KUnit test.)
> >
> > I don't really know this code, but I can at least give:
> >
> > Tested-by: Eric Biggers <ebiggers@kernel.org>
> >
> > If you want to add a Fixes commit I think it is either 97769a53f117e2 o=
r
> > 8c57b687e8331.  Earlier I had confirmed that reverting those commits
> > fixed the kmsan test too
> > (https://lore.kernel.org/r/20250911192953.GG1376@sol).
>
> Both commits affect the same kernel version so either should be good
> for a Fixes target.
>
> I'll add a cc:stable to this and shall stage it for 6.18-rcX.
>
> The current state is below - if people want to suggest alterations,
> please go for it.

Thanks for cc-ing and for extra context.

>
>
> From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
> Subject: mm/kmsan: fix kmsan kmalloc hook when no stack depots are alloca=
ted yet
> Date: Tue, 30 Sep 2025 13:56:01 +0200
>
> If no stack depot is allocated yet, due to masking out __GFP_RECLAIM
> flags kmsan called from kmalloc cannot allocate stack depot.  kmsan
> fails to record origin and report issues.  This may result in KMSAN
> failing to report issues.
>
> Reusing flags from kmalloc without modifying them should be safe for kmsa=
n.
> For example, such chain of calls is possible:
> test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
> slab_alloc_node -> slab_post_alloc_hook ->
> kmsan_slab_alloc -> kmsan_internal_poison_memory.
>
> Only when it is called in a context without flags present should
> __GFP_RECLAIM flags be masked.

I see. So this is a combination of gfpflags_allow_spinning()
and old kmsan code.
We hit this issue a few times already.

I feel the further we go the more a new __GFP_xxx flag could be justified,
but Michal is strongly against it.
This particular issue actually might tilt it in favor of Michal's position,
since fixing kmsan is the right thing to do.

The fix itself makes sense to me. No better ideas so far.

What's puzzling is that it took 9 month to discover it ?!
and allegedly Eric is seeing it by running kmsan selftest,
but Alexander couldn't repro it initially?
Looks like there is a gap in kmsan test coverage.
People that care about kmsan should really step up.

> With this change all kmsan tests start working reliably.
>
> Eric reported:
>
> : Yes, KMSAN seems to be at least partially broken currently.  Besides th=
e
> :_fact that the kmsan KUnit test is currently failing (which I reported a=
t
> :_https://lore.kernel.org/r/20250911175145.GA1376@sol), I've confirmed th=
at
> :_the poly1305 KUnit test causes a KMSAN warning with Aleksei's patch
> :_applied but does not cause a warning without it.  The warning did get
> :_reached via syzbot somehow
> :_(https://lore.kernel.org/r/751b3d80293a6f599bb07770afcef24f623c7da0.176=
1026343.git.xiaopei01@kylinos.cn/),
> :_so KMSAN must still work in some cases.  But it didn't work for me.
>
> Link: https://lkml.kernel.org/r/20250930115600.709776-2-aleksei.nikiforov=
@linux.ibm.com
> Link: https://lkml.kernel.org/r/20251022030213.GA35717@sol
> Fixes: 97769a53f117 ("mm, bpf: Introduce try_alloc_pages() for opportunis=
tic page allocation")
> Signed-off-by: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
> Reviewed-by: Alexander Potapenko <glider@google.com>
> Tested-by: Eric Biggers <ebiggers@kernel.org>
> Cc: Dmitriy Vyukov <dvyukov@google.com>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Marco Elver <elver@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/kmsan/core.c   |    3 ---
>  mm/kmsan/hooks.c  |    6 ++++--
>  mm/kmsan/shadow.c |    2 +-
>  3 files changed, 5 insertions(+), 6 deletions(-)
>
> --- a/mm/kmsan/core.c~mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depot=
s-are-allocated-yet
> +++ a/mm/kmsan/core.c
> @@ -72,9 +72,6 @@ depot_stack_handle_t kmsan_save_stack_wi
>
>         nr_entries =3D stack_trace_save(entries, KMSAN_STACK_DEPTH, 0);
>
> -       /* Don't sleep. */
> -       flags &=3D ~(__GFP_DIRECT_RECLAIM | __GFP_KSWAPD_RECLAIM);
> -
>         handle =3D stack_depot_save(entries, nr_entries, flags);
>         return stack_depot_set_extra_bits(handle, extra);
>  }
> --- a/mm/kmsan/hooks.c~mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-depo=
ts-are-allocated-yet
> +++ a/mm/kmsan/hooks.c
> @@ -84,7 +84,8 @@ void kmsan_slab_free(struct kmem_cache *
>         if (s->ctor)
>                 return;
>         kmsan_enter_runtime();
> -       kmsan_internal_poison_memory(object, s->object_size, GFP_KERNEL,
> +       kmsan_internal_poison_memory(object, s->object_size,
> +                                    GFP_KERNEL & ~(__GFP_RECLAIM),
>                                      KMSAN_POISON_CHECK | KMSAN_POISON_FR=
EE);
>         kmsan_leave_runtime();
>  }
> @@ -114,7 +115,8 @@ void kmsan_kfree_large(const void *ptr)
>         kmsan_enter_runtime();
>         page =3D virt_to_head_page((void *)ptr);
>         KMSAN_WARN_ON(ptr !=3D page_address(page));
> -       kmsan_internal_poison_memory((void *)ptr, page_size(page), GFP_KE=
RNEL,
> +       kmsan_internal_poison_memory((void *)ptr, page_size(page),
> +                                    GFP_KERNEL & ~(__GFP_RECLAIM),
>                                      KMSAN_POISON_CHECK | KMSAN_POISON_FR=
EE);
>         kmsan_leave_runtime();
>  }
> --- a/mm/kmsan/shadow.c~mm-kmsan-fix-kmsan-kmalloc-hook-when-no-stack-dep=
ots-are-allocated-yet
> +++ a/mm/kmsan/shadow.c
> @@ -208,7 +208,7 @@ void kmsan_free_page(struct page *page,
>                 return;
>         kmsan_enter_runtime();
>         kmsan_internal_poison_memory(page_address(page), page_size(page),
> -                                    GFP_KERNEL,
> +                                    GFP_KERNEL & ~(__GFP_RECLAIM),
>                                      KMSAN_POISON_CHECK | KMSAN_POISON_FR=
EE);
>         kmsan_leave_runtime();
>  }
> _
>

