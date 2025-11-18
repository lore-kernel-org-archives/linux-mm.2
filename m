Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4171CEE358
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 21:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83866B000A; Tue, 18 Nov 2025 16:15:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C506B00A1; Tue, 18 Nov 2025 16:15:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70B26B00A5; Tue, 18 Nov 2025 16:15:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C63366B000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:15:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D80D139D7D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:15:23 +0000 (UTC)
X-FDA: 84124983726.10.1222745
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1BF7640003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:15:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=npDzrzir;
	spf=pass (imf11.hostedemail.com: domain of linus.walleij@linaro.org designates 74.125.224.49 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763500520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6GZkDCjP3W8zioZBIyS8aoWcCj0wfwoomLL31Tc25U=;
	b=8B1OnenbAsLolpXp3uprgeX9IFn2pkxF/m3Vt+FVE18gICsJSkgpHm6SyHeuPU8HcTG5Ij
	cALY/15Kb+2GpSC1EOd25dAW8r1JM2lcSsE3cOJD0DW/5M+vK6xgruUbKWQLvSqupaRfVx
	fqmOZA9Eq7dNq3ud0t8WV+wgxUL0yCg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=npDzrzir;
	spf=pass (imf11.hostedemail.com: domain of linus.walleij@linaro.org designates 74.125.224.49 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763500520; a=rsa-sha256;
	cv=none;
	b=Cj5NeGIUNd2jkfZz77I3d8mcQN6Y6Zt1dB+FPl8lPAncL5WIPpZVQOg9HV4jEJgIgGwvt1
	i/Mfkhz0mfa9K/Oie/i3a4eAW9uwaZ2TaNsG3m+iv+cswh9gaJXpdVzC4z9MecgPxTaJUS
	uazlf9D7XPDDp9O8WweLekL6cdSnNw4=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-640daf41b19so370895d50.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763500519; x=1764105319; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6GZkDCjP3W8zioZBIyS8aoWcCj0wfwoomLL31Tc25U=;
        b=npDzrzir7HlmVoObhX98ht1QP2LpNNxaVhOGyQR+3nUknFVc1jhJnms0U2stcY0IKO
         4vt0Ad0CX7wyoqsTvZNGnXLR74gP8qJn44fYBZhZ5YIBXNQitvIAEU6BKozTFxY8dJuZ
         PM/xkwfb3itMblEhWUsO6MVk/pabONirS0wRL9p7Su5heVxD6Gdddl1jdxRI0yJygboR
         i0f/CEfmYsO6ht1ENcWTZQBY0ZfMuFMXXEgFscr7wWq8Y+nS6rWItFw+d3kQ7030f9XG
         5VO8ROm4XU40Hea8I1xnWKRSz+LwdiavsucbVKRPnK/bp63yAWc0S1VpJ7RW01el70zm
         BG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763500519; x=1764105319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y6GZkDCjP3W8zioZBIyS8aoWcCj0wfwoomLL31Tc25U=;
        b=HE3+7/XHCB3QoyYHeDtgJRgwEKpkeDvo0kvLbLr7nNGfotkG3H59/tcnsk8ZUNpCb0
         UmsdPg/sOLUIdhZ7d+70SMplr1FCtaRJrCmmkpqo2qMkTmHbMcP2/6XMeM4BuSDcsleb
         Jwi1xPB08JAFyIcp+4bPHkfWy9FjCTRw9KnBRAfmsHYiVkKGG9W7TGZEwTE4WWQ8gv0O
         k4YubW+yimyCZeAE3bvnzcSPoMmbkx3qy6UXeWITqNtiV4J60UBfkPznlL4zijSsM49n
         Y1PHJbFrI3bRN53PEf/v6URAa8yypxzkMIGn04mVtvE6NJ1TlNOAXSvo7CbhvDxgl4SZ
         RxvA==
X-Forwarded-Encrypted: i=1; AJvYcCUUrysv9wj8Sp8rKEV9iPbnDPzNegvroSpZozGvfmefbOGd3Hc9A2A6sWc9h8P992g6q+MO/n81PA==@kvack.org
X-Gm-Message-State: AOJu0YwKnAs853Tvhpwce7V+2ulj2xAqtRUyehqYJWFArb+OEEv6nxIQ
	ZFTHQ/BK45M4t2JMqPNfBJXM1ekSmYY0mhNp1xG6fjxWzEquEjQMR5OdSOJmYDK+8FUJ1HAQ9y6
	uIUs7p2U8kN5ZT9nJb7hxGlQDy6ghncvF5Xr9W+A6Dw==
X-Gm-Gg: ASbGncsJipYp9QdoWKYdSXODbh+yqzB8XWVvrxoyRs8dvwSEZHkXw+wMpuY7ag7GECi
	XkNt65gNrx7q5nnPlzkGptDHIRX60LwKV/98pwdpUvcc9bDSGcff1asHuOqWF4v23+Q+aTEi4xb
	0xITKIMelL0wG7JnJckGxr8+aOuZMYqZ7BO7ASYX8W9HT70xAxaYLCbO5c4v/kqLHeS3amhPC3J
	7nOkN2XD++0QfMO+FgGuoiQziKoKbFSsr13MvTtzq9CHDGpyMKTEppBXiSpVLcQ+JxrLTA=
X-Google-Smtp-Source: AGHT+IE90KurxD/Pwc/+yBJA5Jq+fcUc8EhKJm3TFl71u/xOwfHv99j9S3F52qAKnQVoN9e00CQK+dEYGWQNAYaGo/Q=
X-Received: by 2002:a05:690e:1909:b0:63f:ae23:b5e6 with SMTP id
 956f58d0204a3-642ed4af35bmr103566d50.26.1763500518791; Tue, 18 Nov 2025
 13:15:18 -0800 (PST)
MIME-Version: 1.0
References: <20251117140747.2566239-1-mjguzik@gmail.com>
In-Reply-To: <20251117140747.2566239-1-mjguzik@gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 18 Nov 2025 22:15:04 +0100
X-Gm-Features: AWmQ_bl0-W0N1ePUMUFgtL6_GedOjLr7SxyGXuLzUYeTEgJOTb-Q8mMdQPja8TA
Message-ID: <CACRpkdbNxKh7ySjffhzCncgBroOOeOQP689k7dgBKgV9annLpg@mail.gmail.com>
Subject: Re: [PATCH] fork: stop ignoring NUMA while handling cached thread stacks
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1BF7640003
X-Stat-Signature: ew9w6yywiquee33sebt73w4o4u6hhrjj
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763500519-261946
X-HE-Meta: U2FsdGVkX1/VicgE5pMehx6DFGziFr6dXFH/a2w28eR1jGMTjBhxNoGrHcBSOIL3mFbQYOYG69Oabq0UWz2f8BRNoXP7yp1RUR8oWVpObsq29oqQeeAa/YOblDENSPe5EYZIk7Ao2nckNAJIqJoh4oZfd4srsrhWyLU4D6SXIOS0ca96E98W/gveYQM3Oc515VRVo7v8zN/5Y8PSBfi9pL4rjFI+SW9lXo1eqFOLM1gTStTnRfDPSz5oNXM4KGyglQA8eqbpfxp5d4Mpa7nORToA3mHQRVHPcuUmdvC2hVtMrnuWH2dga0XoJm9FPt3/VQT4JxZ24TEcpALft8UrLxHDSJgUGUA9lvfb3Gddikuwp/AEX95jnAgIghWsTRLHd5clZDg5ILBYuzGHjv4PHUql9olqvPflVP3DHYutT1DweTwxd/JT4198e5XgDDszO2W/Ne+vhw2/RvE3dz9uGU/+EUs329SpERAaYlMx4TS5ovXxfn8hXCZ8dpumyuEGRjmu/wwhj9T5fKAb2FkxQ6ps6Y/SyWg7D4rB9A/Cpgj0zbl0ELzV9qSnIPhry6nN8xLu4kXP2Ex94BvV4yujIWaDqb7e+PfZRUMw4Z0teLeaxBqIj0GVNvNJcXk/kKgHsVI89ZUF0r4pzZf1emhMcnTtYIURd3rl8ujqsvz54s3n1CE2oNxUeEBxptOf05U4oxEh6AQBlDJX2H0zjJ+OWwwSba4+Yrfb+YFhS3r7HN3Y5IRM1PECf98wzdQlEMxiPWTwooq3750IOv2ProvmPY1jQnmjUIXVrSJzr0kAvhZffebUyXqPIlXqcAAvNRvK2se4uvn3qF/frQkaU9pTiFmL3b/3DHJ1ZV3kRhyp2E0g+eYswSWdobp+40Gk650sY8xXxydjpg4k8DSsl3zx7ZwUBHjhN+9dBjsJEENFAfygQpUzx0GC2ClAZKyVsVK2SQXVxL/D/ppuxaeor0N
 pG9H7F/5
 IOntXA/OG/oZO6jz6tkQ0kwIbjeZuvRFn4jt2a5yjycDi3zw6KdAN8kSHrtgd2D5nw/c1oypL0EJ2dFXOa8eTCdC0msVVeJjbc84dX7NwPKHQx9YYUVs1foDB8KdiPJ9/RXLue51i93cJ/9CsmzzB4EMNFOPpMoHavpxEgAf9lQ6tR/u9MDXeXxFwnOpyw5izpptEgjdu6iBhVR5C0MzwdzNVVOc8KKX5CB35KiturSKrtAQU0bWtRHfyDh3uf3LIvGiUbwKbXwZivGI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mateusz,

excellent initiative!

I had this on some TODO-list, really nice to see that you
picked it up.

The patch looks solid just some questions:

On Mon, Nov 17, 2025 at 3:08=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> w=
rote:

> Note the current caching is already bad as the cache keeps overflowing
> and a different solution is needed for the long run, to be worked
> out(tm).

That isn't very strange since we just have 2 stacks in the cache.

The best I can think of is to scale the number of cached stacks to
a function of free physical memory and process fork rate, if we have
much memory (for some definition of) and we are forking a lot we
should keep some more stacks around, if the forkrate goes down
or we are low on memory compared to the stack size we should
dynamically scale down the stack cache size. (OTOMH)

> +static struct vm_struct *alloc_thread_stack_node_from_cache(struct task_=
struct *tsk, int node)
> +{
> +       struct vm_struct *vm_area;
> +       unsigned int i;
> +
> +       /*
> +        * If the node has memory, we are guaranteed the stacks are backe=
d by local pages.
> +        * Otherwise the pages are arbitrary.
> +        *
> +        * Note that depending on cpuset it is possible we will get migra=
ted to a different
> +        * node immediately after allocating here, so this does *not* gua=
rantee locality for
> +        * arbitrary callers.
> +        */
> +       scoped_guard(preempt) {
> +               if (node !=3D NUMA_NO_NODE && numa_node_id() !=3D node)
> +                       return NULL;
> +
> +               for (i =3D 0; i < NR_CACHED_STACKS; i++) {
> +                       vm_area =3D this_cpu_xchg(cached_stacks[i], NULL)=
;
> +                       if (vm_area)
> +                               return vm_area;

So we check each stack slot in order to see if we can find one which isn't
NULL, and we can use this_cpu_xchg() because nothing can contest
this here as we are under the preempt guard, so we will get a !NULL
vm_area then we know we are good, right?

>  static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
>  {
>         unsigned int i;
> +       int nid;
> +
> +       scoped_guard(preempt) {
> +               nid =3D numa_node_id();
> +               if (node_state(nid, N_MEMORY)) {
> +                       for (i =3D 0; i < vm_area->nr_pages; i++) {
> +                               struct page *page =3D vm_area->pages[i];
> +                               if (page_to_nid(page) !=3D nid)
> +                                       return false;
> +                       }
> +               }

I would maybe add a comment saying:

"if we have node-local memory, don't even bother to cache a stack
if any page of it isn't on the same node, we only want clean local
node stacks"

(I guess that is the semantic you wanted.)

>
> -       for (i =3D 0; i < NR_CACHED_STACKS; i++) {
> -               struct vm_struct *tmp =3D NULL;
> +               for (i =3D 0; i < NR_CACHED_STACKS; i++) {
> +                       struct vm_struct *tmp =3D NULL;
>
> -               if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area)=
)
> -                       return true;
> +                       if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, =
vm_area))
> +                               return true;

So since this now is under the preemption guard, this will always
succeed, right? I understand that using this_cpu_try_cmpxchg() is
the idiom, but just asking so I don't miss something else
possibly contesting the stacks here.

If the code should have the same style as alloc_thread_stack_node_from_cach=
e()
I suppose it should be:

for (i =3D 0; i < NR_CACHED_STACKS; i++) {
        struct vm_struct *tmp =3D NULL;
        if (!this_cpu_cmpxchg(cached_stacks[i], &tmp, vm_area))
                return true;

Since if it managed to exchange the old value NULL for
the value of vm_area then it is returning NULL on success.

If I understood correctly +/- the above code style change:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

