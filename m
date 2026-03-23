Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D743BEC01DF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492616B0088; Mon, 23 Mar 2026 08:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469A76B0089; Mon, 23 Mar 2026 08:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37FC46B008A; Mon, 23 Mar 2026 08:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 26D726B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:17:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB2421A0B53
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:17:00 +0000 (UTC)
X-FDA: 84577227000.01.A8EBFAC
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id D744C160004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:16:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=mXxACTiL;
	spf=pass (imf08.hostedemail.com: domain of ilias.apalodimas@linaro.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=ilias.apalodimas@linaro.org;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774268218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWkmFbrIVsjT8V/hemxMRS0whR7xwhOiVNLmrbQRIkQ=;
	b=Gu0if9Ed5n52IKuJxdiInYw6Tz57TpoT6pbYPmK92beSt0h2AJIvaxnUSPit+ej18eihQb
	C9M8SQSuQ6WWA/lpnEEZwPnuTiQGcLioQY7Ih8pk9fL3tVndT9e2udphmxhPT3Ip5L3CWq
	FwKy45gi0CcRzxljJxggPl/P27UHGeU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774268218; a=rsa-sha256;
	cv=pass;
	b=nYOCh5X/YuAdwdSRbh3t06tU9mjRppV+UbM9OkP4ESlnWMR4dgTk+jxuBBczL3oLIoEMoW
	Y25D7WriNTTjgcWtSpJgo3b+/My3L0vaIkR9Kp9OscBAemocHwTa2D44zHChbLv4uN07h4
	zoLktFGSNtCsdR65vZM72AKQ+WqYqdo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=mXxACTiL;
	spf=pass (imf08.hostedemail.com: domain of ilias.apalodimas@linaro.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=ilias.apalodimas@linaro.org;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-797ab169454so26748867b3.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:16:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774268218; cv=none;
        d=google.com; s=arc-20240605;
        b=DVrXXO3fbrXM+LpBMTUjVdnhYbDYbFzWGDQcJY9HXYVZIgCpoexOGeAaiU/7mUVevl
         LgYyR+AwZT0uK1j/O4CmVuaUSlt520yrktHFSsB/DOPmgzX7V2WXv4XiDsSmnHigYvqB
         WW+ya9LN2FM9+L4YpAsls4jQxyCsOBF6w2R4+6H6p70yrHP7CNTg1mSDY6MlNOJiE81N
         PK1CVewhNWVQW9saD03K6GWNWK0TKFFQsVRt2+GA2aKep+gbtYm8yOuP9/hBiAsCVCt6
         7DqBT8Q+9Kt0TlqqKjJ4cw5zn4EZmuMt1XXLFcPe3wO7E6d5KkhO887hkWmgBdWcAhWf
         rt7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MWkmFbrIVsjT8V/hemxMRS0whR7xwhOiVNLmrbQRIkQ=;
        fh=QUkV+4WyI8ylD4wt+snS23DIyhm/Y4dMHpoUaGYOqVA=;
        b=Nr+K5WmdI+bA6xlRqtwdLNumtphM2O5DU7xQ1CysucY1ESZvmFgIk5mHBeneJVotaW
         n+2uyDxH3lF4dzQy2ln5SWoEt2wbQCsvYTdHzBk01SOb/cHgO9gOqeGXQx2F8IHxR7pV
         eXrzmUwnyrjxboFLUf6vAGHHZHbJVlDhMGMZp4ZYoUurWVhSQk6yXodL2fMCKBKbPPKr
         YP5W1JHy6XdbhKLwDnsSjDQ7yoEvuEK/34t6LH4onQmiWhqT89ORsgg8suPNrp04wBTB
         DS5N8ZATVur1NRUd8zs6r/fl2q37a+wBBBQKtj04MQDy//hTGlYIP2/Ma/RikbWvOfRj
         vItA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1774268218; x=1774873018; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MWkmFbrIVsjT8V/hemxMRS0whR7xwhOiVNLmrbQRIkQ=;
        b=mXxACTiLvpujrfHP/SQDMxCvM/SwPxOnd4DO1hsgXIdbMRIRn9LhNDtUMWU3ovIXXo
         AMYoKACtdaF3WzHizFrSA50/rEFY5fYQh0dBfVJVi8i3CbD0z0RddXxCBkqLq9X5fyFr
         OE38w84UtMA/kzaRbRe4082Gjcp2yGr1Fboh0APdKV3viT2f0w2e/mLqRlgJLBqtvTFk
         u12gMBmJRipE7gCf5Q/DAIgI3AkVjE1DRXvrObmaF5FG7Gmwu8AraQ/n6xBVo/52tcQ/
         AMU7c0vspH/GIKF6r2phcpTZv5UtAW3tFTVOR/dQRE8CvNkS2eXsZelzLNysMH7wJkc5
         yjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774268218; x=1774873018;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MWkmFbrIVsjT8V/hemxMRS0whR7xwhOiVNLmrbQRIkQ=;
        b=Bu4EIiM8MGkgvMCltdBcrkXmCPR4T3Fg/l+D5Z1RLkCujI5sw648aukv+vuPVEP7/r
         Ex+ZLk2Zht3uPQuz8b30prKK468yEYGMN1oChf+Dk4MJ/wiOKifw4N1Nz2/d2Aay6kg/
         YNWxS1vmN0Qs07qBJ52cKZITgOJAs7ouTvNPPWMSRQ7ZtaXOcy+fI+gLMAWvrk1s0m4h
         GCpmeAgRGcJTXMykB8LIriY4/oFIgHEXD1bzBXeH6Y7PBWWWtzslpT/t/f4kJBZ7qIMZ
         Q6fx5/oC57A3lpcYDzAbZWv5tb+4CJx5s+PGl0DQ9MZwSc0TOLmmxvQvTGLL41aDsIn5
         UBPw==
X-Forwarded-Encrypted: i=1; AJvYcCWnfL9CJhk0L6FhLdFEz2tqWi7nTfjjlqBKvE8ULR2YlB3HQMpMzISDCL+r0XsL1RotuMpVvib6rg==@kvack.org
X-Gm-Message-State: AOJu0YwlldQJ38rXNslYmV843H7hQc99TsSgZwdellv39Y1V1mVPHwWf
	lnRX8HSQyL1lx17ygqBy2B9iEnVgpH4alfQJ++JtIcy6JlhgXg0TswwOM5qKzQxBDHOKeIVLnPs
	vJFUOMzweiX6A4HQbde91lBeRCPf8gp65h6QjTS+oNg==
X-Gm-Gg: ATEYQzzIzHJF1yo/QCsQtkKQ/J31K9sShI7nfMwljH56bpRTlDMu5LCDYStWekp4nF4
	+ltaW3ZDGfier6Mh20ckye3KQW0t8kf6Z7mj6gGQaYw6L9diPYHdscV05Gl++WnPL9Y4U01XKCM
	w7vEI4eIYBNDxxJtfZQMqGmBECbULiRXQJ/D4ehyhS5DSybG67zYMT3vt4DPckhFEoo1UgoEHbu
	5HH/OFtofgABsNSsNKai4Tiq9U0Bb5jxZaL0YYML/r2wQRU7E8ujBLow1kIILmuuzRmVZRsh34B
	/DxrfshoxXtO/YRQ1+poRitdK8IT4IffmOvdPD3zZMwMe6eny5Psh21lfzDYrUmTGdq1fIYxZFq
	7vosFWrKoMLQE6Ydw0/0n7CEmvb1CFEnhXtMCTK7niJ9VFhOmOFhxyEj2x5CmbhfWDjVFsAZDr5
	chArbt019LuN5UNvljIfcw2U7dS2y4GKY6Owjh5bxoAygSSU4r+M38Ei1NKNR6W4bVd8l9uFRje
	5ZsvD4QWAMBSPhJLSJyhdxwkMh5LtkAsjYq6086mCm/NY+eBHQo05bXfrJO7QAZQOaxjEoCe8oN
	kaDpGhWMuRp1nCHE4ZYIGbBFRjNy7eYM3ZBpLVJYxAakwbB90U3fw+4=
X-Received: by 2002:a05:690c:1b:b0:79a:bb8b:e9d8 with SMTP id
 00721157ae682-79abb8c0ddcmr16991927b3.50.1774268217399; Mon, 23 Mar 2026
 05:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260316222901.GA59948@system.software.com> <20260316223113.20097-1-byungchul@sk.com>
 <ebd00055-d4aa-4612-8bf3-ef0a308512f8@kernel.org> <20260318020223.GA69943@system.software.com>
 <b48275da-a3cb-4621-82fa-c2a83f1e24b5@kernel.org>
In-Reply-To: <b48275da-a3cb-4621-82fa-c2a83f1e24b5@kernel.org>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Mon, 23 Mar 2026 14:16:20 +0200
X-Gm-Features: AaiRm50BWIH2-tUvBrhcp6LVf1TFjq6A8vCDpCMci7VezVPJXkSVFBGlyHvsvAw
Message-ID: <CAC_iWjL4RhuK16pDM7bQhrkOgHa54R_6S0zGgwSdc_n+yKCcUg@mail.gmail.com>
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
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com, 
	Daniel Dao <dqminh@cloudflare.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D744C160004
X-Stat-Signature: xjx64ubrs57zjgox59ig9q6rse1ag8xd
X-HE-Tag: 1774268218-975084
X-HE-Meta: U2FsdGVkX19lR8JTiplGLeHxeKGmYynfeMQAEgnch4Uy9Kpvdl/45tr8IW7MfDx+ZFUvEWOexPiNdGUtSuIEx50atZOowrLna4E8PY9Elq5jBGu2CQSBAE6AfB2vtCclziOXW35IE5f+h2bLGNJhh9wMFZHdN/fu+6jRBxw6U+Z20Ao4tiFfRYrhvmgJmkFrrwG6nGuXrj4TmcBZN0Kc40bh8of3ZZ8N2DKwjCorw4OQs0CW14Mq7pN++fabCBawB1+EIcWPz7rDqqhDNr9MWEYlvk8Dy+ZdCAb9H6K12LkZyAY9lPMKXD4dBPYm4gLyH8olJTuqdgkoBX6yVXB+TPdE0hiwnGGyYy+/Ch3ErvNb0UnsW1s3y34N+IIHsIPw6mzGCpOSnGvfTmC0vpsnFjxkgUiP5Dau1Qa7pq+bpiR136MTUq5VYJ4qk7C5P4CpVOyu5p4aYCMEf1sRJ+KHWVEsT4iC0+ObYlKXnN3/jn9g2B+Ew49hmhIqhaf6KQQryGwgqEHRHGa+BxvhnBPiLifl86L4YAt+BVudlqnyt/IE6TVvmXFFjHPSWRCY5P4QwQDT1oP58zh3DED5pnKYnXY531YPtNcCEfN1I/fdsDRcQCnsLORn0uZJrtXWghdjbzgSCA4TMLC4tFCP7qqt134lpTV+oJSDZF7YiAotA3XiwH3IyuHsuUOQpaC/oRbi5/eiRCt7nVoo/q8JCAcuQFGgwAQxIwjk9J70d9EdSaln81hT0f50picCKXAR+RALRLv6et13h7bI1ebElBgodCFrxY37/S7S3LBdlp1EBpVGwxI+B1WykQfaTh+3IPIrrMWxJpxx5fjs0zpQNoHwkx42odNQ3AzbOvBKjMwuYgMLcwiqmR6HY0QsLje6/IgE9bk23DCTCYExnuP1FcC0P8dBhNrhUqEbIWwaujBJMC7OQIaUCxS6rXnDYg5zyXESD1dq1nuxWQUM/APrkHQ
 7VCwiEqs
 DnWpN8kYbuV6QNUJO5b+ttBBae0XQ9xEe3Mq9A4LxB4loUTBIhd64pd7DT/b/2Q8tlXLVsY+Wtuv9B3GKgi0LvdfS/bJC7ajGB6Z9aHzcfUh1IBt37qmZdqRKhWYnxrphDdF1xF0RYHcpfHcf1WCYFymEFmqWGh490hbw8WarNafNQqiob92tcvKxM4AhWVlcJt1BgOJ0pzKeiLSrT4J9kXiOn3Xp2Nsngeec1/yf94n29oPeBYdTAdwV5WwnZvrhPRw5oYKgFKbUQgIHWHhmh3qhYoB3qw2nCeGuG95MjvQbjl13aQ/vN2KHuL7ImsM4j/EIugTbNZ0pUaO4gueImkivZePStBaKjlt8LMC6OtxWzG14StNcmfB22LWW+iq0UlMohViTPxG/7sPJt2sf7f/xihqc1hhhwKmi2usirSPtoUHPx4ncpgxHd93+iDhegAKe85/a4th0mQDnZHXfYAlbdN2S7HNNVDg0eIT+2N7HOGK8NpK5USkvyEMJuaMI9tJH44mlF4kD5bjNs7sgbfDT91Fg1llq+IWN7soZ3jQ8zARTJwKeLAviBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 at 13:44, Jesper Dangaard Brouer <hawk@kernel.org> wrote:
>
>
>
> On 18/03/2026 03.02, Byungchul Park wrote:
> > On Tue, Mar 17, 2026 at 10:20:08AM +0100, Jesper Dangaard Brouer wrote:
> >> On 16/03/2026 23.31, Byungchul Park wrote:
> >>> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> >>> determine if a page belongs to a page pool.  However, with the planned
> >>> removal of @pp_magic, we should instead leverage the page_type in struct
> >>> page, such as PGTY_netpp, for this purpose.
> >>>
> >>> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> >>> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> >>> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> >>> netmem_clear_pp_magic().
> >>>
> >>> Plus, add @page_type to struct net_iov at the same offset as struct page
> >>> so as to use the page_type APIs for struct net_iov as well.  While at it,
> >>> reorder @type and @owner in struct net_iov to avoid a hole and
> >>> increasing the struct size.
> >>>
> >>> This work was inspired by the following link:
> >>>
> >>>     https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> >>>
> >>> While at it, move the sanity check for page pool to on the free path.
> >>>
> >> [...]
> >> see below
> >>
> >>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>> index 9f2fe46ff69a1..ee81f5c67c18f 100644
> >>> --- a/mm/page_alloc.c
> >>> +++ b/mm/page_alloc.c
> >>> @@ -1044,7 +1044,6 @@ static inline bool page_expected_state(struct page *page,
> >>>    #ifdef CONFIG_MEMCG
> >>>                        page->memcg_data |
> >>>    #endif
> >>> -                     page_pool_page_is_pp(page) |
> >>>                        (page->flags.f & check_flags)))
> >>>                return false;
> >>>
> >>> @@ -1071,8 +1070,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
> >>>        if (unlikely(page->memcg_data))
> >>>                bad_reason = "page still charged to cgroup";
> >>>    #endif
> >>> -     if (unlikely(page_pool_page_is_pp(page)))
> >>> -             bad_reason = "page_pool leak";
> >>>        return bad_reason;
> >>>    }
> >>>
> >>> @@ -1381,9 +1378,17 @@ __always_inline bool __free_pages_prepare(struct page *page,
> >>>                mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
> >>>                folio->mapping = NULL;
> >>>        }
> >>> -     if (unlikely(page_has_type(page)))
> >>> +     if (unlikely(page_has_type(page))) {
> >>> +             /* networking expects to clear its page type before releasing */
> >>> +             if (is_check_pages_enabled()) {
> >>> +                     if (unlikely(PageNetpp(page))) {
> >>> +                             bad_page(page, "page_pool leak");
> >>> +                             return false;
> >>> +                     }
> >>> +             }
> >>>                /* Reset the page_type (which overlays _mapcount) */
> >>>                page->page_type = UINT_MAX;
> >>> +     }
> >>
> >> I need some opinions here.  When CONFIG_DEBUG_VM is enabled we get help
> >> finding (hard to find) page_pool leaks and mark the page as bad.
> >>
> >> When CONFIG_DEBUG_VM is disabled we silently "allow" leaking.
> >> Should we handle this more gracefully here? (release pp resources)
> >>
> >> Allowing the page to be reused at this point, when a page_pool instance
> >> is known to track life-time and (likely) have the page DMA mapped, seems
> >> problematic to me.  Code only clears page->page_type, but IIRC Toke
> >> added DMA tracking in other fields (plus xarray internally).
> >>
> >> I was going to suggest to simply re-export page_pool_release_page() that
> >> was hidden by 535b9c61bdef ("net: page_pool: hide
> >> page_pool_release_page()"), but that functionality was lost in
> >> 07e0c7d3179d ("net: page_pool: merge page_pool_release_page() with
> >> page_pool_return_page()"). (Cc Jakub/Kuba for that choice).
> >> Simply page_pool_release_page(page->pp, page).
> >>
> >> Opinions?
> >
> > This is not an issue related to this patch but it's worth discussing. :)
> >
>
> Yes, looking at existing code, you are actually keeping the same
> problematic semantics of freeing a page that is still tracked by a
> page_pool (DMA-mapped and life-time tracked), unless CONFIG_DEBUG_VM is
> enabled.  You code change just makes this more clear that this is the case.
>
> In that sense this patch is correct and can be applied.
> Let me clearly ACK this patch.
>
> Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

>
>
> > Not only page pool state but any bad states checks are also skipped with
> > is_check_pages_enabled() off, which means they are going to be
> > suppressed with the off.
> >
>
> Sadly yes. I'm mostly familiar with the page_pool, and I can say that
> this isn't a good situation.  Like Dragos said [1] it would be better to
> just leak to it.  Dragos gave a talk[2] on how to find these leaked
> pages, if we let them stay leaked.
>
>
>   [1] https://lore.kernel.org/all/20260319163109.58511b70@kernel.org/
>   [2]
> https://netdevconf.info/0x19/sessions/tutorial/diagnosing-page-pool-leaks.html
>
>
> > It is necessary to first clarify whether the action was intentional or
> > not.  According to the answer, we can discuss what to do better. :)
> >
> Acking this patch, as this discussion is a problem for "us" (netdev
> people) to figure out.  Lets land this patch and then we can followup.
>
> --Jesper
>
>
>
>

