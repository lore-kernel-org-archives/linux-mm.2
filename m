Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BABBECC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716EB6B0088; Tue, 13 Oct 2026 05:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B216B008A; Tue, 13 Oct 2026 05:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A476B008C; Tue, 13 Oct 2026 05:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 191546B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:14:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F8261C44B1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:14:53 +0000 (UTC)
X-FDA: 85317043266.14.5E5A963
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id A0F7D40008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:14:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fzno84VH;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791882891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68MXMWga95CH1/6xessB7F2BXfoCEeSgQgXov6Rw+cY=;
	b=IW79vDEfnYsU5ZgVbn5gg/hHQDTaWh/6NKV9/hkBZ0QwjcuqkuXZAk+n+cWikhLdQVAPid
	M3eW1aHtB0xU9cZEqWPvugurIpv3v02j13HOo2fbuacM2wQ/eORXvdloCvL+0XF27qIYUC
	J63n2NMv75nSZgnBIbZ2I/sMapDLptc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fzno84VH;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791882891;
	b=RFPNTctcW0fzw0DHWxPT22ckpW2uEaol20XsA8eAaiYVpGoRneyx7WrLPy0sCL9wAcPHxK
	UQOBupOQo75Mqvk2DJ8csjo0u7AFhj6hG5/OkdDBw/nKc+hTHiuZI8UuCDdueniWTC7z0Z
	YzT+zFafZ+waGvjq7MhrPO369cy0Vug=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b05bf699easo18559867b3.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791882891; cv=none;
        d=google.com; s=arc-20260327;
        b=CZ139iGKqvfwGLEssVFS7SKcEKcziFA72u5aIEXcjwuNydHf+yocDwNeRYzJCnJR+D
         56Rj9n58da173xzmus3+poFJ8HF7x5MM2ppsrtz1mjBqZAF5kJdCyvXUwcG3GlJJt8Ey
         vJ7TqHv9ACBrTdhVYGcfLDQu+WVdkPnloXaC+XIi7FrKkgm5jhvaugSnU+NkU53Tnb+P
         VIdEDRqDpkMckLw7gtOpry0Dxkip1/29XbB31eCVJiJWUvknjtzyLVP6QI0u5nT94hJP
         4n8/RzhJToZrmk+pE576lUgOzmYoCpq5XBtxfeIZeIcEw9UPguS6VII0HMdNF8d7NC1Y
         nfRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=68MXMWga95CH1/6xessB7F2BXfoCEeSgQgXov6Rw+cY=;
        fh=JjQnZ6nrBekIn265fpfMxHOm1d6bax2uFTFhZpWBvaw=;
        b=en/RI5uYU6aeShPHXesDc+zJNWqNVDd8bBCRke8mkuLwKSXH4Jfp1XFAG/GIJbtyf+
         P5HrK9caqViQqfKolxpbpBDxfb2ICBiSOewYD4tzaTxWhar5KxbgJZCwW6jQfnOk62Db
         FZMuIPyEK27C3Koy42qQThcX2VCpNm7k5lfcl4fkw5227hp2VGvjFGep45Lwl5xgSqym
         gfZX49X8RzRJMKRqSixrG7znqmBQiP0nJlvAhIPqMXwCEkco6MfZuOtryhAdUukLOtww
         oHAM+a2ce+cakOF6BNLfC1gtMsKkscV3jJIu4pe/2GZguw/41ngCRbxtDTOUt1quxNSq
         QMjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791882891; x=1792487691; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=68MXMWga95CH1/6xessB7F2BXfoCEeSgQgXov6Rw+cY=;
        b=Fzno84VH+0dG9II6CzlJdYncHywc0ri8Va4loFCaNin0QnUEN8vReEsgWgy6ahDA4o
         82dAgj7b8yvWZrCzUnpv5p/LXTH/7nRpNOJzQMvLySD6g/MGAuFlDEw7P90hiQ1lftMe
         ab3BFb6Jos3NjyU0EyQH4So5A9k5KQ6fpgAmSkPvT48iWMpWKaVLt9nU7f45R1MUYtx6
         wIAuti8fewcanjI74/dqptXZVQvatmQf80qybTvdlMdFso1gYelc3xzi4tlpsjp3HSYJ
         1/Yq9ZTpJImsC6W7b04ti6hOaNzSt8w9KfTLZbxdYyyOdJ8ZYb1/Jgq3VNISaPXpn9KY
         lNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791882891; x=1792487691;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=68MXMWga95CH1/6xessB7F2BXfoCEeSgQgXov6Rw+cY=;
        b=oTT86tcNZWfmCgBdfmFMMK+MpQU9Ek9v4msEHVDJlBPfNuu95RyqNLupIHsS9dHiwo
         VkaMuT0b4PddVe47VqB1nMadWzW9sDLceBA6RZO6CDVuGkq8bgod1bV1IwAtbSmpUSuM
         QpWQDfcxUhWbFxuChuK0+mK3NmksTaB52+ZUNShwXW9fPlgcYhdoFmlDz0eKS5no76eE
         ZWxOwNWDvqvA1Zc10C0EgojJz/TA3a56HY/IQ8H26WmXrGIQu4FJ5ncfgy/5Ik5X85/k
         3nN/9bg2KjDoqPNFTzNK36Za62nQM29ZcUmrsiz8cYH1O2nyUrgvyf/wrfvpPR7KGev3
         f57w==
X-Forwarded-Encrypted: i=1; AKwUvBwa9TVepro40dJmE9/j7m42atCLuQ+AWoRdI7mtFubR8bwRZbom1ED9htDMD8xdH7onqLLvUhTllQ==@kvack.org
X-Gm-Message-State: AFq9FYLqiav91f88jIaBJTED1aUJQNUc75P+3w54U4BnQWuSZdntDf8y
	b6xNF5D4Jk8BAuxeZBbS8tvjmPt3vHPsuHb8fkWvAKFMYxsqRdpNQ4AFxz8hIEDMa8b0ljaH8nn
	2deCCp9Nj5MG3rK3mEwom2PhcQx2zfhQ=
X-Gm-Gg: AYBFou03boK1sfsDQR8GpuYDOjOKq7sBA8ktkJxNml9Qr8ttKj3lr9xlGyW3Yw6p2nj
	CCM3bHT2H4IH4suhZYR6qZvTrObjqiMGKpvXkpXMiDZmkYWHEP7YAMeOdHU1kaS/8zNE1K0T34j
	m9ichdCCMp3Rmv/ejFxS/qpzrmmcE1+VUEIQZSvguWzdA6JIR0SwiUN4KG9c59VGWh/T3Yf0HuB
	0dH3bWFuoJtvA/M35lPEB6Skan5/TAdWYdlWNLibLSwj8sPWeCRAG+Ic6msDXypLkkYFk8Q3KLG
	I31+zvV2we8NfBysuTNqdzknAP7BzbbKH4X2DiKkjGok11Xmvtb53LQTqVwV7XS8MTgBxnqLxxX
	GuD9S9kaoyw==
X-Received: by 2002:a05:690e:43c6:b0:675:3d40:3c2c with SMTP id
 956f58d0204a3-679362ba7e0mr2295954d50.81.1791882890519; Tue, 13 Oct 2026
 02:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20261012120438.52849-1-laoar.shao@gmail.com> <20261012120438.52849-2-laoar.shao@gmail.com>
 <96324eec-d307-4bbf-975e-3c9b3dd5e190@kernel.org>
In-Reply-To: <96324eec-d307-4bbf-975e-3c9b3dd5e190@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 13 Oct 2026 17:14:12 +0800
X-Gm-Features: AclHuK93g_25NJAT6wXES6RLREaNoHaav4Z0uWW89g_0G4Uh0XP2UqZ1IpTsXuI
Message-ID: <CALOAHbCOZdYe6E-_atuyT3UvOQt+j01Ru0ErknVutF8kR=L1Fg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] sched: add helpers for numa balancing
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	gourry@gourry.net, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7siqkc6fo7ahq1hgd5c755r4yh3pj3fh
X-Rspam-User: 
X-Rspamd-Queue-Id: A0F7D40008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791882891-684031
X-HE-Meta: U2FsdGVkX1+IDZxHQy8WP1y5vai6s3hN4+tbUzJbw7vkF9idybFw41EnJCZhTOAPoFKQgxoSpLW5j6hMwOUPq98DbR1zXBmETeXA75Ya/MWIxtCZ3XQwql0Po9lj0jcGIxpeASHxactBK93hcxFbppQjWoxqJ/2/oiOjNZzBBF8FU6d5lC61U/F0Jd1wBWMwk8bMh9dlWlDTURjzsuk4+nIZnmt+hh+KWKXR0oZlK7X6Ppt1NMqXnd8ajrBuIU/jgUvfYdKmWQxbH2y9nuhAMAdOPvBuh8Z5yvy7aqdkRDQRp0teYJzjjGnnqC8jRYvkwInBKgVTYjnN6CZKDrc/eF43kj3Tua9Mb3miFGGcE1PkwbFIUvPq9HO+MkcaEh2kWAE43pH+UpnDAGsXpdRtotfg9HswxL29hzC11eD3Hw5aAdrwpqa/5BORjJhrF6RDrhAJx4ZkREg/FxqxKtSHSGUckXwXCMcLII5LsZhposCcRxil3FDdP9h90JMmm5QphfU5ZELQYpMS1rVnIfEteIPTTZ+u6PdWG+XaLFw0zTwUFzAy/luMZZBK8gq0PFwHwpH5CxsMxtzy9tbBp8wGta7tco9a3TqHKDCktBxsIBIPWg2zKu5Ebk1DlttzvfSJ5OdXsYnZfxjETZ2r0KQ17Kntk3s2JzqcESYcwnhdoC1Jo6u3lcYzcEzbztAtcUeSiXsT5/zWqSHgD7Y93Q1IYAKJ2IGv77Vdd7XkmljKsBQflYI6aPmRBRK9ctc04XgFihXclrsgEzj3s3+7lxQuIkGuNo5y0/2ZKnJietqj+xm/NONjOKeGM71PbyK/vpI9OywUbpvRNpyUyEoVmpdxQDS0xrYdgoNEGezin+ncVr+q379wN8eohRoNhsVAsFuj0+tCiaMOs235HbPWNYyDlKg76Qj48SRb9lC/ED1apB+aPLlWCpCnlQIe/kiK064HVBaLdsOelZ5KSi8nhxz
 HdCruQ3k
 ShM8JpK7i07J5M6AyBKTq96sl8D707PoPEWqFkuhvgq8P2psguwR69QlsvGzoyVX5AGFt7VB5MivGLgy9AqIlr5uNDcrywpg/BwELgzEhh7Ld3F5O6Z3y4ycayqOuL0+Xk0hCtcvkqjxw31xpPaMfFafVXBN4UYWL/GMnh/noPelqbYvXoqc7+EOSz79ast1HEKA8dx1K5FzGVebWcor3oD3AG1cF1Kzqs5CcsD9gsgsJ+3297lZxwbBa8XPOfphAu3U5BquR56wJv5G4t4b2n4TNtXssuknzBNOyMmxwJttwn83SFa5ucNijyxin79vben4+S9M7/160MQ9q79EOQXjYHNlnE6IOyBCCr7hIM2Ck7lJEJd77eBcbwKIqwtNQ0f+3qJvek4jWLjv8iBz9BzV80sgtNvgZghkPzLtZv9EmW2amKUq+jVK+oizXf0uHAdfSSD6rBZEdXwk5x8DxXrq6eH7gL/4FxLQaRQUI7ixZcbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 3:38=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/12/26 14:04, Yafang Shao wrote:
> > Two new helpers task_numab_enabled() and numab_mode_tiering() are
> > introduced to replace the scattered direct accesses to the
> > sched_numa_balancing static key and the sysctl_numa_balancing_mode
> > bitmask.
> >
>
> I'll only comment on the new exposed helpers. Some of these might make se=
nse
> even without the bigger series.
>
> (obviously, minus the task change)
>
> > No functional change.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/sched/numa_balancing.h | 31 ++++++++++++++++++++++++++++
> >  kernel/sched/fair.c                  | 16 +++++++-------
> >  kernel/sched/sched.h                 |  1 -
> >  mm/memory-tiers.c                    |  3 ++-
> >  mm/migrate.c                         |  7 ++++---
> >  mm/vmscan.c                          |  6 +++---
> >  6 files changed, 48 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched=
/numa_balancing.h
> > index 52b22c5c396d..353772b49c5f 100644
> > --- a/include/linux/sched/numa_balancing.h
> > +++ b/include/linux/sched/numa_balancing.h
> > @@ -8,6 +8,7 @@
> >   */
> >
> >  #include <linux/sched.h>
> > +#include <linux/sched/sysctl.h>
> >
> >  #define TNF_MIGRATED 0x01
> >  #define TNF_NO_GROUP 0x02
> > @@ -32,6 +33,28 @@ extern void set_numabalancing_state(bool enabled);
> >  extern void task_numa_free(struct task_struct *p, bool final);
> >  bool should_numa_migrate_memory(struct task_struct *p, struct folio *f=
olio,
> >                               int src_nid, int dst_cpu);
> > +
> > +extern struct static_key_false sched_numa_balancing;
> > +
> > +/*
> > + * Whether NUMA balancing applies to @p.  The @p argument is unused fo=
r
> > + * now: a later patch will consult a per-cgroup BPF policy with it.
>
> Talking about later patches in a function doc is ... wrong.

Thanks for your guidance.
I will update it.

>
> > + */
> > +static inline bool task_numab_enabled(struct task_struct *p)
> > +{
> > +     return static_branch_unlikely(&sched_numa_balancing);
> > +}
> > +
> > +/*
> > + * The global sysctl state, for the system-wide tiering machinery: thi=
s
> > + * reflects kernel.numa_balancing_mode only and takes no task.
>
> The latter part doesn't make a lot of sense in this documentation.

I will update it.

>
> > + */
> > +static inline bool numab_mode_tiering(void)
>
> The function name isn't really intuitive. Should this be
>
>         numab_in_tiering_mode
>
>
>         numab_tiering_enabled
>
> or something like this.

Agreed, thanks.  I will rename it to numab_in_tiering_mode().

>
> > +{
> > +     if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> > +             return true;
> > +     return false;
>
>
> return sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING;
>
> ?

Agreed, will simplify as suggested.

>
> Both functions could directly have proper kerneldoc if we are already
> documenting these.

Sure. I will update it.

--=20
Regards
Yafang

