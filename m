Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98B43F33833
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 10:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7FC66B0005; Tue, 17 Mar 2026 06:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30826B0088; Tue, 17 Mar 2026 06:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D46936B0089; Tue, 17 Mar 2026 06:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C08006B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:04:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7837F8C020
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:04:26 +0000 (UTC)
X-FDA: 84555120132.27.DB8A17B
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5927A1C000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:04:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=tRYdDDcQ;
	spf=pass (imf20.hostedemail.com: domain of ilias.apalodimas@linaro.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=ilias.apalodimas@linaro.org;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773741864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJ1Pc/1QKu2lLSHomCR6iKHtySw3Kp4fd1PA2wd2pgs=;
	b=qbazpBBjHgmGfTgROQmlEnHrJUTcEBvOVLQPJ8I4LqkZOkLo4Q/kPkKA1Y76TgFlwX6CqJ
	qO5rTbaH+FxSGmLsgSUsBTQMdUxT7MJuweoTrJOHILrAP2D4LQfiaEMm0t6HTj7CuAVgVm
	p9N4byWwyNjRQyUsF4WYcaZgYR4Pa+A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773741864; a=rsa-sha256;
	cv=pass;
	b=oi4G/L5Aq2hQ4CarjpbOQO2UUqsm/0TKhp+YTy/Mfih0QnOxy9vHtPUiUxdLtL0pLgVVCB
	p48icO6jcabBxhFJbNAJniXMhJu53xxFmafGyGtV7FUDYZBrtMCYFD0IeSf4Vn+7SPOcwg
	iJLs/z0RdOixNRF45woerr2ubvFqIoA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=tRYdDDcQ;
	spf=pass (imf20.hostedemail.com: domain of ilias.apalodimas@linaro.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=ilias.apalodimas@linaro.org;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64ca09f2056so4194461d50.2
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:04:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773741863; cv=none;
        d=google.com; s=arc-20240605;
        b=ITLLYabT6XOfDUGUFjGQGt2V5+8hbkxnIK6jzTDPM1RLykqTw0NPF3dNUO3Vq1DG8g
         jBO6+xEGPfF2Tgd9wB6Z0hrVyE2O7LSYzI3aszCL6ghnMHhTVnjBQb2fzkNf0SsRGHX1
         tC7Dl6YPFE+LDLj8D8jSxXFMyilSGwPdOcvxc8r2vvQq3R65Lmn0Zyz6TNW4a81phzAX
         PhsVdXfTfKOC3V7i6jGy0feOCViVBXOiVle8VKaF+JuuMeE61O1Ej6XO6pvbu7hkW6Fu
         Tk3CZ/DjOOAWu+dLHf8M1AeKyYHjsaqGdpSh4203v4qonNDg5S3NFjdg9mCdWHuP2QWR
         uZIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=sJ1Pc/1QKu2lLSHomCR6iKHtySw3Kp4fd1PA2wd2pgs=;
        fh=ebfaUuYQ/iqIjNYylifqoPEXKa4yqfumFVpUSTEVNO0=;
        b=Dr7cJUMlypNfe8HYZNA4UwCJset8FIAl/zCKk8xnWBI7rIPAr38fK33qKBHVWeuUc0
         lyl3xDae8ALqmPU9q/h15XkzeBddagWndwZTfWG8TOci1w+Ny6gLXaWsbQhuTsUrFOPf
         KUr/j99w6iJPdg1BepNMKIUOb6gp+f14rMRFGYos1NdKeNC+hKezcykEUDvyAme0zv9U
         o4ctonGKlN4hfgMyXctig76nsJg31O3OjfBTr+vnRJJjDqPOr7cVocZ0RVwim03Zum2B
         WgioAt9gYl9wDkRsiVKuXq0wLAnn3F7StL2qeZFWNBJGX20UDmCdk+BXM/pzDqkx0mx+
         QW1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773741863; x=1774346663; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sJ1Pc/1QKu2lLSHomCR6iKHtySw3Kp4fd1PA2wd2pgs=;
        b=tRYdDDcQMzPHy2yC4Rn9jgPsEp4a4WWm9/dfLQuQ3tWSXRuyuVtf/mRKCtqWjqqp+3
         tMM2kWMfwuim3mcQmxMZAVlD6C6DTKkgYqsuIsXGaAbNikKIScSGQGuLcMZndUOR1VxX
         eMxzFuoaac5I/F4YtQFwRvAeyZ+6YDUPttMtw7pEu1l3yWp+tccjEQyQqW8eRuq/bo2P
         D3lu0x8rJvL2+NAilyMjA3IEk9nf7FEiJ8sAEM31FYNykyOXXVxcdfdWb8HZ1ykRngm+
         1nn6PnFGSxY5DhzOhG4tlGnW7B9wfTLLRGiMDHsqoio438JYI36GNTWxjh0qLqn2o4dl
         L7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773741863; x=1774346663;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJ1Pc/1QKu2lLSHomCR6iKHtySw3Kp4fd1PA2wd2pgs=;
        b=eIFUSEatBsy1tBaL/+Af5Q/PbS5mgNh1mVwGkBUlQCF8/5bKsrKvAm/nNZ0QW3QVI1
         +R7yrhc462Kr2wlvEzoWErKSh7bxt5kJ4ri7vYAGx7UE20EKufUBUve4kEl3cxpgzQfv
         7CLjMqu/ZGZVlrv/xiZzKVoCl7g89TWpyj27+NFYAcfUtOSCOiZHl6VIEWkuvl/TgnL+
         2g4t/BKs3vTUw78HaO007rPWAkP3jdgExa2KuKea/ianeRdPzGnu42wcYW74XNGjrMp2
         jkv79JsfOmONRhBinT+QpkgjxtE86g+VyXzYa8PXs26+kULA8umBuYhY18jnoFL9D5jh
         3sOQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9MVYZKCU6rG4eARiDxn3tJyZY2AHIgP2hbFR36zniCl3I8+2c66lroF2aYjwALFrNzCb2aqUIZQ==@kvack.org
X-Gm-Message-State: AOJu0YwXkXt8FFczRG+NhQ2WnzCBUYLcpEbHXyg5QtSEa/5FdQYtA3jV
	fzV8RZMDSqS0BKer5otno8Oe/tcv0yTKbUCyoRGgyOTa9qObq+E6RcjsICbvUuVwz345nMkFe/q
	CJr4zTM1jgzI/8weNLV++yx8obe+TlZpiSUNhWWzKnw==
X-Gm-Gg: ATEYQzyP3EnjkJFm3bLUbMKRIirMb2/bGKMlo4FIo6aoMda71roKDOgmuvWt0bbckox
	Gz0LvbZP0lNa24JBJ+YLi8TCqZ00FbBIPUZIW8boEjCuGMOsS1ImR6bwGUI604QhOnOcB7AFRdU
	weK9xS8fJK9jhxE0taNEDAogtkHpJm3IV3jGyIJpsP74JbzCBSnvm6HBDSHouBBFvG8567ny99Z
	XLHh1llWd2m18GwMLJu7uYBg/K3bcXzvTOVKXft0EVOkKTRKMNuG858zt2jjLtFuDedgYI8kYuT
	GdQXL6vI1KFmQRF9/oilUigEVDI4MeUjcC6kTIqSuxF0/m89UqYEyZrfV69itpMrLmIVbg8K8Rf
	lOPMWUu4FCGy0u0ppzIl7u5VxS/HIteI8el1LLB9q8HovRBtEKlnAorMDBfjQ5yZU07sFMqCSuT
	cfQFq7XzhSQ9mFpx7IHGz89nx0twemxiObEEs5CkbPA7tyNmEXAN5vfk0H5GR+TcolNGiGNrb6L
	03t+XKjdIZI3rJLcBa0KOwFwJbKxTAdmOfxQA5DKamH7ynOJ7lhhH0pFYr57dHFhANOisR+FJY6
	XaiLNTbx2xvu24ZNmL5KEBflfPA12hkwhgDj5IgPrWgy
X-Received: by 2002:a53:df4f:0:b0:64c:ea3d:a895 with SMTP id
 956f58d0204a3-64e6306d33fmr11868511d50.61.1773741863199; Tue, 17 Mar 2026
 03:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260316222901.GA59948@system.software.com> <20260316223113.20097-1-byungchul@sk.com>
 <ebd00055-d4aa-4612-8bf3-ef0a308512f8@kernel.org>
In-Reply-To: <ebd00055-d4aa-4612-8bf3-ef0a308512f8@kernel.org>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Tue, 17 Mar 2026 12:03:47 +0200
X-Gm-Features: AaiRm50_gMBZxX2vRtFxvpOCPSPD6sNew1gAwSuCX31B_IpupUaMwz2w2jjcEa0
Message-ID: <CAC_iWjKXvfJuVn_uGgj4SsPsZnvMMepd7BesZcXgRYDPm9yUhg@mail.gmail.com>
Subject: Re: [PATCH v5] mm: introduce a new page type for page pool in page type
To: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	Mina Almasry <almasrymina@google.com>, Toke Hoiland Jorgensen <toke@redhat.com>, linux-kernel@vger.kernel.org, 
	kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, john.fastabend@gmail.com, 
	sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, 
	mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com, 
	pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, willy@infradead.org, brauner@kernel.org, kas@kernel.org, 
	yuzhao@google.com, usamaarif642@gmail.com, baolin.wang@linux.alibaba.com, 
	asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, 
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5927A1C000E
X-Stat-Signature: hh9eqmjufj9ztp4wbnk1cpssx8j1jd1d
X-HE-Tag: 1773741864-520588
X-HE-Meta: U2FsdGVkX1+d/myDu7RnrqYFnk0w5QQT0pS7sR02zafofow440lwexQqdXzlGPviUgRlvemWOvBjXqq2Kyt8zxhSPxWJeN9dQl/gkrbVU3XJisFJWKQS8Tufif4s8Dlqyc8aAfZN8qQ73dlV4n9ln2HhZ4oWalkz9Qtd2Iw07vx3VPj32pgXBJk0L+GrrzZi3farTtAJC5mZulDzlCKPbNvagC1HkfiyF4NHKzJJJSQGqPt8hi7/sybalMkkKkENJ9OAykauuPcrSHqIyRR/ThHSe2EtKkrIrIicVcg49zfJe3GDq5W6QWRda7XO5Q6Yia7z6peVLBxTHurvFIJjMZ5XZLrsvNIJwbVI0k+ULP/e7g2XHLWQHRvT32SAjja/Mbo9BJn7AFzAY1AmpiY6+mvI7Gq6VDcy74rJOn8ka49TRawz05KKNxb6gZJPI2jLBNaLqrRicrknuv0oAAWDB5TlhEC5RZ4pQ/fuVDFoLOxc/CC74X+QScXXf1w9Psl8su9IK3wDOQWRNobM9n8IEBqdYjx9xN1XmXX4TESMjzg7Brv5A6h2VZd0JgCXjefCHQtvnzn1htR2FppOrR8AaVHCFtq6EcjKSqgIpXdZolfb57P92W087ghTdxKELbLh2jOWql5kplXT9/Vkjw5kR3XT5IAMYWUYZ9inoP7BBEif1obpYpjn8PWjtleeo41evdbvzgsgEzTNVN11JM3NHyVp9aL0EooHts7OfDwPofFvcSZiz8Kddr8uR2BGD9t5o7dXA7/29itDHhLFfjSw8p+h9QkEhPXrjUsdIHLE14inwVj/as868LVmKvrn5wKWiq4B7N4+FBDS/vTUIp9Vctta8o9xD9FLpa/iKzLE8bd6EYzCoKMEROHAjRMl1bzir3Eq6VNUzAr8XZaRTbzbb3nPo10lC8w2N0ZthuSwbK5yuO27MEJk2fuD0YYpPYi/D5ladSzW1mXpGjqG4yb
 qAySDaAF
 xgArkC5Dgciib8luDTkyFcSV8Ag59FjaOcU7my4tUdjRZHtpTo2Ls9px9nKKFJZMLLAr+DJKAD2TwZWYKjtcLs4OX14Hgd+teXz1qH49UxHjOW6haFtBUzVBQ/6x2va1lFgWIQ4alqRQImouotrb+QAVPQPTqbucv1QULUiZsfSpGUP+a+c4grqcMYZzH9QX8LzZCqRoMQ+LHV1QtdhZJt06zGcAkvwO5o2WHM4kLeU6UQC66FsxEIInHfYCT1JmnNt9AWj6Y/HTR7tOmF0Vit7HxtF4lYwXNGF1P2HKwrtZ+0hGCQDIwidb2QgGAeD+z9OuMk2uZfCfOy93IMvR4Vy6oBnN/1phfdBI8WrzjIR3p8pSgaIfwygCh8T5twNEZAnk9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jesper,

On Tue, 17 Mar 2026 at 11:20, Jesper Dangaard Brouer <hawk@kernel.org> wrote:
>
>
>
>
> On 16/03/2026 23.31, Byungchul Park wrote:
> > Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> > determine if a page belongs to a page pool.  However, with the planned
> > removal of @pp_magic, we should instead leverage the page_type in struct
> > page, such as PGTY_netpp, for this purpose.
> >
> > Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> > and __ClearPageNetpp() instead, and remove the existing APIs accessing
> > @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> > netmem_clear_pp_magic().
> >
> > Plus, add @page_type to struct net_iov at the same offset as struct page
> > so as to use the page_type APIs for struct net_iov as well.  While at it,
> > reorder @type and @owner in struct net_iov to avoid a hole and
> > increasing the struct size.
> >
> > This work was inspired by the following link:
> >
> >    https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> >
> > While at it, move the sanity check for page pool to on the free path.
> >
> [...]
> see below
>
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 9f2fe46ff69a1..ee81f5c67c18f 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1044,7 +1044,6 @@ static inline bool page_expected_state(struct page *page,
> >   #ifdef CONFIG_MEMCG
> >                       page->memcg_data |
> >   #endif
> > -                     page_pool_page_is_pp(page) |
> >                       (page->flags.f & check_flags)))
> >               return false;
> >
> > @@ -1071,8 +1070,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
> >       if (unlikely(page->memcg_data))
> >               bad_reason = "page still charged to cgroup";
> >   #endif
> > -     if (unlikely(page_pool_page_is_pp(page)))
> > -             bad_reason = "page_pool leak";
> >       return bad_reason;
> >   }
> >
> > @@ -1381,9 +1378,17 @@ __always_inline bool __free_pages_prepare(struct page *page,
> >               mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
> >               folio->mapping = NULL;
> >       }
> > -     if (unlikely(page_has_type(page)))
> > +     if (unlikely(page_has_type(page))) {
> > +             /* networking expects to clear its page type before releasing */
> > +             if (is_check_pages_enabled()) {
> > +                     if (unlikely(PageNetpp(page))) {
> > +                             bad_page(page, "page_pool leak");
> > +                             return false;
> > +                     }
> > +             }
> >               /* Reset the page_type (which overlays _mapcount) */
> >               page->page_type = UINT_MAX;
> > +     }
>
> I need some opinions here.  When CONFIG_DEBUG_VM is enabled we get help
> finding (hard to find) page_pool leaks and mark the page as bad.
>

You mean we get debug messages about the leak right? Nothing is
silently freed with that config enabled.

> When CONFIG_DEBUG_VM is disabled we silently "allow" leaking.
> Should we handle this more gracefully here? (release pp resources)
>
> Allowing the page to be reused at this point, when a page_pool instance
> is known to track life-time and (likely) have the page DMA mapped, seems
> problematic to me.  Code only clears page->page_type, but IIRC Toke
> added DMA tracking in other fields (plus xarray internally).

If we can reliably track and release the pages, I think we should do
this regardless of CONFIG_DEBUG_VM being enabled or not. But the
question is how did that leak happen? Is it a misuse of the API from
the driver?

Thanks
/Ilias
>
> I was going to suggest to simply re-export page_pool_release_page() that
> was hidden by 535b9c61bdef ("net: page_pool: hide
> page_pool_release_page()"), but that functionality was lost in
> 07e0c7d3179d ("net: page_pool: merge page_pool_release_page() with
> page_pool_return_page()"). (Cc Jakub/Kuba for that choice).
> Simply page_pool_release_page(page->pp, page).
>
> Opinions?
>
> --Jesper

