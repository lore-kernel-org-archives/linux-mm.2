Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6A10C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2EDB6B0088; Tue, 22 Sep 2026 22:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D064F6B008A; Tue, 22 Sep 2026 22:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1CA46B0093; Tue, 22 Sep 2026 22:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91DF96B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:46:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7FE0F40689
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:46:21 +0000 (UTC)
X-FDA: 85243488162.09.8451A4A
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8890540004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:46:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I4xtN2rX;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790131579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8uOFzpnkzf/kQZI5AxzptgiLFgV6BJGWg7vBofd0M4=;
	b=IA5oHSmgIiL1Wsl6mLzMpPkJd9o4RBZKjw+5Nm+/XaoJisSlFn4/nTESsL7ogkUe6flIWB
	qoTH1nv/Ma2i10g6lhWU7CXLRM396L99yY/mCNsw623ZssjaL49SOij0/Ojy4ItdGgALEu
	NVzT18YciiBJhDuAcvZ7b+OHc8OD6+o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790131579;
	b=sXB6/D4ACkw7s7w4qozxbOsytYZde8M0p8ZdNYB5qLXxSHIxMritFHXysdFL/HyKSnT2rt
	3NKpp09RrCyMvObGvu4aiGZdqExY58BqrzOPQsfjCQnpJDv/H3SPczrTHc1yHPGpUvP6IR
	31BxPvnHHLJJrniu0Raxn/hnDT44oac=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I4xtN2rX;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-53113d72966so83821cf.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:46:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790131579; cv=none;
        d=google.com; s=arc-20260327;
        b=oa/sl7EJu5MfozWw0kUS0zlDEleQgb0AP6iwGz1J6/c8wAugU+bTc/GzmyQYeFl7P5
         aj5CnHfm3t57YIWL1lJrtMqDctRlPaRd7GASIH3MoE0J1sUoBRn6mRViA80xX2Mudd3Z
         4mvzzAfRzAcm9pygcUxDRGUOLmAKD+oa/g/TVw9WD/CkHnXsoobf6AoxeC9LqBscZrCB
         DcMiE46g0O8bFeC6darq43q9mbdWleElc4nAxx5ZUfCr4tApPifqR4A1i2St/bgD1cJO
         LbPhdMU81g/n1AiHxgNDu2ZtCd5UIwy6u0OrUi/i1yeylBobCOVy9XxAjfEaUD2Cx8BV
         ZGtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R8uOFzpnkzf/kQZI5AxzptgiLFgV6BJGWg7vBofd0M4=;
        fh=04gaRpbTeaeeyK7cEUq5S0btGAVqv1JqlJXEtrmfZVE=;
        b=ApDVGbsLPR7A+DpE1mYCpD+W5ENlahZ3s6IhObkvbTUdnmoMz7ibxUmWO9ifnr0jyF
         /f0zemXqQdqVnR0h2mzgUuCeAPZmMNI+CdU99iwB6Sb16rzyXk2mKHwfESDJLTt7HG8E
         LzlYGj8Hv/dBYMt1EGta2o4IC95RW9vXRyX0DLzoWprdzV/tTCUFd3e/6Xgvb6ywPJem
         9pJ+fL9uTEU5MSGk4ED49TFkBhg8jThaXBKsDO1Y4tGyhqzl0Z9fy4bt98YUX84ttRsa
         XSm23rLExX25aLMk6vA0fbMSyTmK2CSbsGHNJRw4QknYuRLFfcgT6s+d5me9ZYFHfQ/w
         bvtA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790131579; x=1790736379; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R8uOFzpnkzf/kQZI5AxzptgiLFgV6BJGWg7vBofd0M4=;
        b=I4xtN2rXigGDEfQGzpxsErgvGd/5Pi1/7oiG1gSvUptK4xJPqSNi2c/33+2LtTq8I+
         8WHNL9N9v3FbD5CBHIBkttom4GUHXoS3Ck1h6VGDjE3n+4fs+SfJp1v6ViWZBTsEIDHn
         mbA2x7MDoxgfTVTigclcxhY2HpYv29o5HfTn4lyLw/M0f4HaTiKbrbroT5CJAF7y0ZS4
         VB+LjQCSz8m6qa4NfR3aT59zyXUWmU/jPXqfk7vN908rtXlWehM5BF7o4p/WJT8i4bu2
         5z/Lav9DDzFxakc6je7LzfzQICacYj2oFevG0ckH5Vj+3qVxKxkbZt3uG/q7EMtWsCAn
         1mZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790131579; x=1790736379;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R8uOFzpnkzf/kQZI5AxzptgiLFgV6BJGWg7vBofd0M4=;
        b=bKCEZBPRuO/VQDrcp5ePqXhcTxvAymrgHEQWzCBl71dazZgppwSaKdq6DeX+pquuU4
         7Qy3RHCjdV4anFgpaAs3a5fBpfZm9g5iAzAR9LLAAUfOHzbRy+HSTv/Z3Eg8n9m+ippa
         fqyYzYDWywSHP17uJCzjYVn/qZrBhSxz0pzccXuULZLn8ZOTUfseSRBYz9xP7ywOecp6
         RXvedrQlJVBB7EKSlOfrLcHcPH58yCcHGUcOxRYmG1b+KOeYOBS+qxA8EHPpldx4jhU2
         P04tTYYTfluzFPqSPCG0tUl18GgIKnUJHXCuRtapi5jhzPEanBy8ONRZREzmYfEGb0NV
         L5sQ==
X-Forwarded-Encrypted: i=1; AKwUvBx5h3sIseJzdOv2CwKE2mj95fBY/shTy7PfNuEEj47ZMUM5llRs+Lp6588Lyv7huLFwiNViG7Gczg==@kvack.org
X-Gm-Message-State: AFuF++mIr856j2oBTHIo5J6CUueSjC7Vj+vpw+A+Z/hmK4rtvEI/AEfM
	NporE9PsTOVgJKsfy0WH1bp561m7EDeepJMnm9YuCMEw4GaSiU+wa1wc28RIaAadugO1/R32YFW
	n6m4kf6JfxITE1F5H8v+C+zZQPqbj9BXDjBPxywVOoQqgcw3iwCrbZ7Zh
X-Gm-Gg: AYBFou3p6o1VLVE2dWWdin6Sqkl8bamPiYt4TlVe3aPxxNUfPzOneD5ojCt8VPYtpNg
	u9XyWUU4E67RyH+FJdT8Yf8Fj0qmB9a1HdXHsXLDjc7kyku3WElQwmvJc3AnZ/Q14jIf307mcMD
	5uAvAucTpAK8g/bN2kFIoUvCKg6MU9giAKeDjEHUm5ggn54KtlUXIoTcePI267xD10NiwVIQvW7
	1DuPCJ4PUIN/qDu0btuRepUSO/qNHGhp0GHBJ/jrVYhsX1ciztXqJXIOKvqBiBHQ9hB0WsEhq9E
	FupaUWCQujYXcSkHROsjhJTcCpXJ40QKOKt8hf7LRrzTt/Mk4yI3Jd8=
X-Received: by 2002:a05:622a:11ca:b0:530:e00f:7768 with SMTP id
 d75a77b69052e-532eb7fee7dmr8415971cf.0.1790131577959; Tue, 22 Sep 2026
 19:46:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev> <20260915070001.113559-6-hao.ge@linux.dev>
 <CAJuCfpFKGxOy9W+ZY9KasU5YaDVG4kbGsV6AYb2NNRyW4gT0mw@mail.gmail.com> <f16c55ba-3403-4721-9ff1-061d73e17fa5@linux.dev>
In-Reply-To: <f16c55ba-3403-4721-9ff1-061d73e17fa5@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 22 Sep 2026 19:46:05 -0700
X-Gm-Features: AclHuK-77SC-AzzB_PEzWsM6m_1tPyT3YYUd84GMA5eJaxU9zbpMbRcwXBAS0q0
Message-ID: <CAJuCfpFT-DVa3W6_tNAxoSPjw5bu=eadYsCmhFX2=twQLTNcvg@mail.gmail.com>
Subject: Re: [PATCH v10 5/6] alloc_tag: skip percpu counter allocation when
 profiling is disabled
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 5ngbreagjhibxnjgpfc6zxbyufkf6f18
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8890540004
X-HE-Tag: 1790131579-619926
X-HE-Meta: U2FsdGVkX19aOve/yS+l2zndyN4+rnhOK6m7Kfjc9Uza/QZV71o9wPMs3aJJTYaXX2AnRmrDQx42Etd2JQ4uDIlnNXCe/yY9PuDbjducEQ/nTRkjHqO3KZIO5IXY53z248qn9VFg+XKOTJbkEl/9uZjClBCfSL5frrqiYlSVAQ6gUMaz7rMN0j70VuJEayDyO8/esd9AKIPnsGEmx6Mt0WXsR5F9EtftXjAWuszr6Qno0gTSi2Cj/8GoLy2LQBtYKJ/QuAs/yKGL4vFEKxNc3Jrx8wydAWrG/xMWsv2MernJTvFNkxDxh7hAHF7G+SbDQeHe6b3FVCSMh0t0nYPe4P1jCUkIoXT1stvg/mQ0AtFGZL26IFnw3QsPW68TW5cRC4vODlPr/L3qh+H9zWzIAyYygfcgpIuN3kDk3cYqMDgzkAAr/tJV36ys3HbAGqN4/b9c8fO2W1gxz91V6zb2wHMqHi2yKj2OnoesSRdk33HeM1TNqxR+9BGvt786Bu2wuGInxFOOopvzV4HEmHDCqonYFxha+ZnhS5N7w+cnpSaTPbWjz79GnPQBSiBBydQbANOONcfyf81cL1ApMZzXCsDYs49A3vLIxD3ohndLXYVPEwTArLhLlP21uIbxlDnp8kAwraD0d4E8ZxOjvjG1vxOlt7l33EEaL8XJceV9rdnsdKJKyP6MUjqY8jkVaWKVMJmV+WfvNxpJ7BmRUyHOcVrxTKFSA4GC+FDMt6iCK8d6FiPgMRi3JymbFTMJzOMa6R+S2htNtbPxIHMSiy6xxqEjz4pnXOLYe37cuuYmb+pmOQyMR4TLkk5rRQLFdv45u4yyTSSc1y6WqN5R5pDLzWJu5Vp2ANicbWpKBOZcdPbkFJx/+KLQUFyhSn0ckK51E4S1rZasWttZOEviO5gufYHZZJRkmPnUmlK+5vov+Ron0sUkfOxEyIxg3qbwBmDFGO+nnzjmat+Fc97TvkD
 niCOWWDb
 9Ghlypt/CxPEp/iXxJ/+vMIAVGgU00VJCrVq+HWnm4vCGm4jKcpXfrsF95nRtP8V8UQKG+ikAgzjHs/H1TJM4ZrRdSk7Lw2x0QG/UeusgatJ0y1ha0q+2yYJ9wt4J5RuFo94ToLaO8hOGBcx/5KJ2RTlfdq2K8+3WFE3/m8kvINmCWIRRsZ/rh4tW8+MrkZIX/TbjuumBoUhuLV5AXEaEzAF9LTGDdXzNWaSE9ARFvR/QHC42UBKvZbhYaYru1K5bp6PDT2eqlSOJ6x3PQF3bMttToQ8h+g5RVQzE0cWgrxswASXZ4l+JQ2Asce/vAqCtMkx4h7cK8g/Q8FdO8UuFAUVbHzvTep3QsZTJHfi6WyZDQXr2IN9T+j0LE1aQp/HDAku3+bTOa9TciRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 7:36=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
> On 2026/9/18 08:53, Suren Baghdasaryan wrote:
> > On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrot=
e:
> >>
> >> After shutdown_mem_profiling() clears mem_profiling_support,
> >> needs_section_mem() returns false, so later modules have their codetag
> >> section placed as regular data and never enter the alloc_tag maple tre=
e.
> >> codetag_load_module() still called load_module(), which allocated a pe=
rcpu
> >> counter for every tag; release_module_tags() could not find these modu=
les
> >> on unload, so the counters leaked.
> >>
> >> Return -EOPNOTSUPP from load_module() when profiling is off:
> >> codetag_module_init() drops the module's cmod, no counters are allocat=
ed
> >> and the module loads without its tags. codetag_unload_module() now alw=
ays
> >> calls free_section_mem(), since a module whose module_load() returned
> >> -EOPNOTSUPP is not in the idr but may still hold a reserved section.
> >>
> >> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compr=
ession")
> >> Cc: stable@vger.kernel.org
> >> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> >> Acked-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Yeah, I guess I didn't think about alternatives...
> >
> > When mem_profiling_support=3Dfalse, why can't load_module() skip
> > allocating percpu counters, zero out the whole area between start_tag
> > and stop_tag and return 0 as success (mem_profiling_support is not
> > enabled, so we acted accordingly)?
> > Module will be added into maple tree and later codetag_unload_module()
> > will find the module, call release_module_tags() (which is a NOOP
> > because tag->counter=3D=3DNULL) and finally call free_section_mem(). Th=
is
> > seems more natural than special-casing with EOPNOTSUPP. WDYT?
> >
>
> I see, but the module would then sit in the idr with NULL-counter
> tags that become visible to readers which today never expect that state.
>
> alloc_tag_top_users calls codetag_next_ct() to find the next codetag
> and alloc_tag_read() would do per_cpu_ptr(NULL) for each cpu - plain
> pointer arithmetic onto a wild address, an oops straight out of the
> OOM report.
>
> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/alloc_tag.c#L503
>
> So if the codetag section within this codetag_type ends up meaningless,
> is there a reason we still return success? We will still maintain cttype-=
>count
> and allocate a slot for this module inside mod_idr.
>
> I'd rather keep the -EOPNOTSUPP version (your original suggestion),
> also because the comments in load_module() and codetag_module_init()
> already document this scenario.
>
> WDYT?

Ok, fair enough. I think your current fix is the simplest way to
resolve this issue, so let's keep it simple.

Acked-by: Suren Baghdasaryan <surenb@google.com>

>
> Thanks
> Best Regards
> Hao
>
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >> ---
> >>  lib/codetag.c  | 10 ++++++++--
> >>  mm/alloc_tag.c |  4 ++++
> >>  2 files changed, 12 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/lib/codetag.c b/lib/codetag.c
> >> index a9cda4c962a3..a0b600720afc 100644
> >> --- a/lib/codetag.c
> >> +++ b/lib/codetag.c
> >> @@ -240,7 +240,9 @@ static int codetag_module_init(struct codetag_type=
 *cttype, struct module *mod)
> >>
> >>         if (err < 0) {
> >>                 kfree(cmod);
> >> -               return err;
> >> +               /* -EOPNOTSUPP means we can load the module without it=
s tag. */
> >> +               if (err !=3D -EOPNOTSUPP)
> >> +                       return err;
> >>         }
> >>
> >>         return 0;
> >> @@ -388,7 +390,11 @@ void codetag_unload_module(struct module *mod)
> >>                         ++cttype->content_id;
> >>                 }
> >>                 up_write(&cttype->mod_lock);
> >> -               if (found && cttype->desc.free_section_mem)
> >> +               /*
> >> +                * A module whose module_load() returned -EOPNOTSUPP i=
s not
> >> +                * in the idr but may still hold reserved section memo=
ry.
> >> +                */
> >> +               if (cttype->desc.free_section_mem)
> >>                         cttype->desc.free_section_mem(mod, true);
> >>         }
> >>         mutex_unlock(&codetag_lock);
> >> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> >> index 5836803898ad..1ca0409b492b 100644
> >> --- a/mm/alloc_tag.c
> >> +++ b/mm/alloc_tag.c
> >> @@ -988,6 +988,10 @@ static int load_module(struct module *mod, struct=
 codetag *start, struct codetag
> >>         struct alloc_tag *stop_tag;
> >>         struct alloc_tag *tag;
> >>
> >> +       /* Profiling disabled: load the module without its tags. */
> >> +       if (!mem_profiling_support)
> >> +               return -EOPNOTSUPP;
> >> +
> >>         /* percpu counters for core allocations are already statically=
 allocated */
> >>         if (!mod)
> >>                 return 0;
> >> --
> >> 2.25.1
> >>

