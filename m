Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85ADACD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 02:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26E26B0005; Sun, 14 Jun 2026 22:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8036B008A; Sun, 14 Jun 2026 22:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6E36B008C; Sun, 14 Jun 2026 22:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 980C16B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:20:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45E831A087C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:20:25 +0000 (UTC)
X-FDA: 84880542810.30.10714F8
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 56891160004
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:20:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b7juz1f7;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781490023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xgw4qL6lxzNspQ+9vtQJ2vaV86VdpfEsnqnAlklgXA8=;
	b=U8J9gUbUV57dcGBTzpH8JHNHmEytd/LFxg/y8vE3251jI3ZrO2v6M55O2KTvUAZJ7QjjsV
	pJS4JMUGxU9vB0h3V9Fqr4VC6mhyMlJyYdFrvTHzIWaDO8gIYIcfGQOTI0I1LmeF1GOezx
	E7VyzA4bYouvORlW0Ar6riHCKBqRJIo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b7juz1f7;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781490023;
	b=jHLQHekq/WY4Ea2/K8ylmwhMh3cA+CjfhGU0zDhaVcJIV0nZmOcmu4F2ojJZx/JsG4zMVO
	19sqogWDN9W8lON0lE71r/DoJcWgL31SSmbM+yfSXysZXqz4verYWTCWMpgnV2Fjo9fAY1
	KQu9oxYrT0Q3+A3G6REN5VuDXKuEIfg=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5177d1ff061so672751cf.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 19:20:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781490022; cv=none;
        d=google.com; s=arc-20240605;
        b=cN4XHqwF8x98hjgLj3ioTw459iiych7Vu/mfGJv9Hoovi48Y5cz1RmwrDrYmUZh16k
         auizSBkuc/z7noQKnc4eohzD+SqeeXvYqeYnUVb8XtE/GRDZkIfs5hlrVQAbM3WGY5Zj
         hsfc5v74oTgUxzOq+YMxX1Z3G39G1luZNapETP/CNQxgkZg4vS0e6aDO4kwwh/qR5GFS
         7euBWsUStPLc/ZnLAkbx7GvvokUSrCUOQkzHr06LHJTrFBPDhC7H9zy7q03v5Frn54bG
         WoYA/LQMpynkARJk4bN0EZO2jqkQiQxkBiU71k2kfvOqNemXdwTBT29UoC7JtIKA3pha
         BIuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xgw4qL6lxzNspQ+9vtQJ2vaV86VdpfEsnqnAlklgXA8=;
        fh=xQMUMKevUmaBPlsyzwkLj1SLCLkBreePKkyddm310I4=;
        b=GV8g7sv6NlxSjMrSkNdF8+8A4VtshOeZjRX33b50tjoGZADrHSqPcl/d1kRAxU8VKT
         LooMzJN5WFsZQJf8JBWf+tukFaOr9tHY8QtOIOG0C6/nBZKDae6Id8sLlLnKvh7d4AuP
         WKjhfrPXDr1KkNTYVTJ3+NcAWJisOEB45jH4wjw8ndBORAL98kmS22bfXf3EKAFc2rwF
         WCxFBxpqjn540Y9R5yB6GpKtd8B+cs66ncQsi6Ii7kchZLIsz4dWo35kChurYPlHBaMd
         8AOZ7QrIxhIPiNWrtZdS2rVuAZKlHYiyHCuKhRxcJA94mkKA+av8bFU9MQMYucI4sTis
         4hyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781490022; x=1782094822; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xgw4qL6lxzNspQ+9vtQJ2vaV86VdpfEsnqnAlklgXA8=;
        b=b7juz1f730D1UfTI75CVJZ5WwscmYCFJjtyD2yFzPE4o4+o9Tz8Z69DFxE1Vl3bw4w
         NL4u+mQ0sMSYtXdbVJyIV/uMZSreKXme0rRCXO2aCDor38EvWp9afcz0Zd++LoxhdMLj
         VkioeSgNjxazwreVjYHu+km93QFPzcP4gdnk1VD+azf40jijd/0lhaWFqs1sYBvkzR4f
         4utl6iwqJ5dTw8LSS18zlBQb+24lhXT49gXsmuqjBIS0sDUNMvkbiPTwauqFL4wS2Uv/
         Z51QuDw7Ia9OM6KsVIpKjicwby1FIyUgnLSwOtaEe0kDMsssJwVg7PYH0NVFW1aRi836
         yWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781490022; x=1782094822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xgw4qL6lxzNspQ+9vtQJ2vaV86VdpfEsnqnAlklgXA8=;
        b=DM3eT+GugWASkjxs5O8d6obdGq7Nybs0gYcW30W7XI2f9RzBBUnlKhU/T9v8BBLeeV
         01uxaRTyRjzZS+C85s8Cwl04qTKnKjz6MIZ2GNviJFyudCZuPCS9CMCGMcRk3fTgz0AB
         0lnojBLMX47di+h58wuxeUOxGHa9cuYUFHHuNuL0RVFmrKaVzp8z3sfS+lM1bL8RfdFm
         HxNEuKfls7GITf03y4FwD7Pir1VnUpeKsj/FhGtp611OMB7jIvY3PNmYU8zA6sYMxTkh
         M59OZxekdzcJyRg110f0IGs/Vz0ILD4s5oKKymxDWTBZAEqIJlwTbLV8BdtLHozxAL0f
         k13w==
X-Forwarded-Encrypted: i=1; AFNElJ9A3DRUxkKyrwKj8QGVgdWu0f2KMoCTS5/JF8hSxpYJMseRY18R8XlLBxZtdq2xUi/vOsO7j7/TPw==@kvack.org
X-Gm-Message-State: AOJu0YwpYELLJ1/zU5gYBfzecj63PAf2CvkBYc1M1sx9s851bkthK2u9
	Ngmi4zOonTVzmt119O2hz9pv8n+JvJE+pZ2o674U70u+fNcGwCTGcScqJW+8fq5lPt/gkuX05WN
	Qat9ZSEIx6jYiFoGyTI9Q2PgjXIbfERYQ0GPvaOHmPTl7QC5tZ4xCs+I3iHA=
X-Gm-Gg: Acq92OFJXgNKZqHoY/ro9wlyDWKV6+3CiBMlET6oXPktgDadgkFd6Z8Std/YWzSOB/I
	C45tNYfCAUoE73/QVlHDSd9zhG7hfdOIgPpq1yLg/zAXv2qX05lrmPsHUkq+PAuYvxV5pvvz41v
	D3vyJ+rhHCu3VR7lvl0IphGe+WX5N0fYpqNZAOnDcI9ddUUcXFoEjEd9/v579i4e2Twhd/ceVnZ
	ORbnsCPUAyi5Jjevtwd1fGDElLuKPF1uJOWSHg6LNmn4MZKEymHZdntj6LI1V3JExf5eWRH/KmK
	CtVkQA==
X-Received: by 2002:a05:622a:2448:b0:517:99ea:ab79 with SMTP id
 d75a77b69052e-51955ee0c18mr14089111cf.25.1781490021868; Sun, 14 Jun 2026
 19:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-6-7190909db118@kernel.org> <aiuB47Lj0vFGyuFA@fedora>
In-Reply-To: <aiuB47Lj0vFGyuFA@fedora>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 19:20:09 -0700
X-Gm-Features: AVVi8Ce9rsblLKml24B6QvenRpvfycL6dO5Bte5pwQ9MMVQHmEMX9EC9SyIiJOY
Message-ID: <CAJuCfpFBM8wHPH8f1ekzoTVaxuSLkent64f+2xbb=3DGkp6fAQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/16] mm/slab: add alloc_flags to slab_alloc_context
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 56891160004
X-Stat-Signature: 6e1okridmagfeneis3m9ywr3uasggyux
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781490023-113511
X-HE-Meta: U2FsdGVkX19QS9lREBbiPOGL/FNKRc6LyGv2hFa8+rGildP+oqY0BaEOsoyTQz4AZIi/+YM9joPHSlEIWPEKzVrtipzWgcgvvdnd7bkXMrFq8fbmrNeauW0giEHkRzYSWafUNZ4QE0tMgg6rJv/k6uufkmGavI55+YytT45+HVQxz747f0qzgtY7izPsdzrtK/vyAorjEVLQoWsrgj8mJC6FyB4iJloprldooCEb+a7VsnCmML383aUjKTq/OQWt8fkmF0T3kcBpbTF4FUCH8Ddozo6XZ+NiJZHFrgwCUhJxFbcccF+Wpzu6jUtNqsyvlsQJcnC7Z/px745XOBbzZk+hTso5UW0c9O65W5U1cDEDtnpYPDjRC2TaQM1/5bet7y7OvRht4eMt+V/CbypUwvIDnd55XXSZA+nNYW36oOBRymDI1eflXd1gxRl7PEwh5ZTTFbfjwt5bvfPvsBZOyIKSVMFHdBt8o8R38QYtsukqgksylcTF/3mVd+YKnmNsdpRyMl2cFx13r4gblSr1ir+n3Hu05U5iI3Ab6mK8U7sQhD+fBwknpH905KDRTqdg4RD6mIint6Pry1Agn3ph1w//yCgne3xLOOWiYR8Q78Qtkh8hoWNBUqJEkn/Heu31zG0ExbdpfJyzYC0FWDRgAb5bbBnsaWmV0XHD6Wy1ZwS+t04w9osebBhJxiW/Slb+w/alwRa3fQAWaW4YzzHVkn+yuvtUgtPC7oUZgzaD7x50c+af/WmTMKaAAL/phg6nmarNrp8nhjSCsYEWYWt1LkJHTSeYerdVfyY691r9RtEixhN5R5aZGjNSZoKSKwSiOHq/5EdKMtQ1IQaob/lNSQPKGSby3JzKtXlZMnDsDXwtRqOT2fYMOYht4OqdghErU0oRsbwwWIMPabylN+fsiBTA3hChL0UYxwU6QCh2GjivDvMpGeQvVEQtykL87GhC3tsPMjGBkhg5k7Hr/Ou
 TApAjJ+i
 HzADTBg/ElmGMeKpR4cR+7284hC/bjT08frrMdpB/Quol5ZclkQ8ct6eKOWLylhjOp8Yto8AtvwYJ52UZOUrAEgNBPNzBaEQ8vDPNwTOswVvl7hcMrEOE2bpqZVgX/kPqtMwsyjqqLuGkWGM/AAhSOU6TvTh08cGJTs1qGu0fpNCRmiHrN+JFsahxDeYqULBLdVNjJU8tQ42ozzkQSY7tf83x0+49S5IDYe7djcKemQzt046+AAjplxsKMjcL0P1PEKCYvskm0lWsV8+d0avwZS+3mHwYHpCNnQ3G18+Q5rmcIuu245bgWmwsoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 8:51=E2=80=AFPM Hao Li <hao.li@linux.dev> wrote:
>
> On Wed, Jun 10, 2026 at 05:40:08PM +0200, Vlastimil Babka (SUSE) wrote:
> > Add alloc_flags as a new field to the slab_alloc_context helper struct,
> > so we can pass it to more functions in the slab implementation without
> > adding another function parameter.
> >
> > Start checking them via alloc_flags_allow_spinning() in
> > alloc_single_from_new_slab() (where we can drop the allow_spin
> > parameter) and ___slab_alloc(). This further reduces false-positive
> > spinning-not-allowed from allocations that are not kmalloc_nolock() but
> > lack __GFP_RECLAIM flags.

___slab_alloc() is now using alloc_flags_allow_spinning(alloc_flags)
while function it uses (get_from_partial()->get_from_any_partial()) is
still using gfpflags_allow_spinning(gfpflags). I'm guessing
get_from_any_partial() will be converted later on but I wonder if that
conversion would better be done in the same patch to avoid
inconsistent behavior during possible bisection.

> >
> > _kmalloc_nolock_noprof() initializes ac.alloc_flags using its flags tha=
t
> > are SLAB_ALLOC_TRYLOCK. slab_alloc_node() and __kmem_cache_alloc_bulk()
> > are not reachable from kmalloc_nolock() and all their callers expect
> > spinning to be allowed, so they can use SLAB_ALLOC_DEFAULT. This is
> > temporary as the scope of slab_alloc_context will further move to the
> > callers, making the alloc_flags usage more obvious.
> >
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
>
> Reviewed-by: Hao Li <hao.li@linux.dev>
>
> --
> Thanks,
> Hao

