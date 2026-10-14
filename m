Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEB2DCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 16:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29F66B0088; Wed, 14 Oct 2026 12:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADA636B008A; Wed, 14 Oct 2026 12:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9916B008C; Wed, 14 Oct 2026 12:26:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD306B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:26:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1FC2140601
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:26:07 +0000 (UTC)
X-FDA: 85321758774.09.6D82375
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id C94DDA0011
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:26:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ACvljAGx;
	spf=pass (imf15.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791995166;
	b=7DMgqBtQNpdoOa9m61Y1Ma6A59BzqYO3gCQgNE4COXjH5xNOnQfu5rI8njojZoZVL4OZKg
	UUnpYMhxv4M+CicQc89PuvJowaELFhDqvQza2H8z1pZU4b875BCeN/8ABvxZMWFULyqhCw
	Z94hSWBZOO5Dk8+45s7vWia+17aGlyc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=ACvljAGx;
	spf=pass (imf15.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791995166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCdj5PANVocN1j51viXw7MkFpoeK7XeNk1w2hTLnH5E=;
	b=ZRc1XmR2p81oJ5gudZos0gNqQp9UMGgvVXMRT8U6HYJYN76D+sZGbAHUO9hoMhBKRqD8Px
	1X4MgTYTEI6LOdt7QeOEE0CQNXURZcRy6wEQ3GrgUBi4+ZHppsf1kbf2CktUzMaLCfBUaI
	3op2lJUb+pGTBYlww2gRijOdjj/WTpU=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso113504a12.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1791995164; x=1792599964; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PCdj5PANVocN1j51viXw7MkFpoeK7XeNk1w2hTLnH5E=;
        b=ACvljAGxls8nn3Wk8VimzXabCm7KFgvkpU7opjGOhHnSJBW17J5qHRJ65pgUFWhEk5
         pdBIFCcrMpEZLGkwAk6uJhY5E2s0GQK3f+qYjGk5EVXzHuDEEFRubNRgHzhH7biXcSn6
         kzO/dFnDaGngQvT+qeS2M/82GipCIoZBCaR0I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791995164; x=1792599964;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PCdj5PANVocN1j51viXw7MkFpoeK7XeNk1w2hTLnH5E=;
        b=pdpVgKonZXJp8aN1FCzNEwRqYPMYmyefcan43ylbooVPk3pedsKRS2C+In5ADklq8z
         jyL+cs0h52tDh3jnelPMi4SquSg91s0ZVfR2us9PvwHUMJjOx5aZe4yStZ+iI8R0S+s3
         h84MFimGKb1E+WwiFjps08RZbVeNhxA0WDLKTBrrfcny/E1tkVBIJ3bx+cqHspoi9zGr
         XCxX7OeG/hruczj1PrU1ipyPURYxirUKWQ84+S/IOlZXRB48uUVsYN4N2rw+bsBICENn
         zC9VFXgeaRFFqpoVIXIhSHQso3nGPsjdKqcqAcI4cK7ME20zAxSlE/5PxkKWATrWvFV/
         5eQA==
X-Forwarded-Encrypted: i=1; AKwUvBzows1mi0+aAtWf55PtmTdaeJBMQc0bMKBKqMgc+351oy3no1aCYtPFje5HYLugpde2pLJXMzYh8A==@kvack.org
X-Gm-Message-State: AFq9FYINsMafWcu25quxpJCcAsLJpQIp9XWkzWD2dUhI6MYMsggRaxfM
	L2kVoSakSne/1WDt0clyMHEx1HiTU6YSTw7DrmzEkUW6SgtLbR/ymOGUblGl04MXUn8N5Im2BZY
	ZGMGxw3k=
X-Gm-Gg: AYBFou1FNOMdauZI2WVBWfagtoAqPvn03QQes3y6DA/NmUf8u4R9NnCSRDqI5+gXCrY
	d+AGAHBsKxpT5HL8A47w7sXe9CtRNAGdh7CTywZ/4y2RDXelEKybsLtqGm3Odh0awowNgHVr9MX
	FwbU66/jGcc1F7Kx+k30nVgCQvc2bHGpd7ZVoz7ZWAcQSH0j3aNcDBa2TaLZCxpffzm9uAvQ9tq
	eyyjVsgn1g8iQY5amNeKKpRAq7KlFz0/0HGtmJFMow7bvZvknhvQzS7eoA9gFJbJoyvjLhq9Vuw
	cNx5efy7QJejLgwx7ED5ldDF2yWvfjo5BMrXUSroU7d84fcpHf/bR+2BE/ETJ7XUvbxCMgZiNd+
	C151mn8VWY37PRIy6RkVJQP0y5GJ+7VXawWCc635VUYfTmro87knDfnrb6ppFETB4fPQE9GrNUL
	js6qIVUgxAh54Gu5tuGSt1PKKFkAE1ppHgXdvQHRF1hJel9mTiu4LIgwT3p5yKb+1NziNie/YXJ
	EGJ6OJDDbu3otgVjJLrYZTcavXM07tl6DhGG3540moCJcOV
X-Received: by 2002:a05:6402:44c9:b0:6b1:cc39:28ec with SMTP id 4fb4d7f45d1cf-6b1cc392d02mr5585393a12.42.1791995164017;
        Wed, 14 Oct 2026 09:26:04 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b203839a04sm1378048a12.10.2026.10.14.09.26.00
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 09:26:00 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c3156e7705cso212612066b.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:26:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxDz4KoOYAUeMGa1i31mfG2ek8RoLSci/lNb16J1MmRTe+Tz4gR93cXhZKYR/sz9YowXIkuXZnaFg==@kvack.org
X-Received: by 2002:a17:907:3f12:b0:c2b:ca9c:1379 with SMTP id
 a640c23a62f3a-c31aa04ac69mr1609899266b.28.1791995160582; Wed, 14 Oct 2026
 09:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as690Xcu7FxIDYjf@thinkpad> <CAHk-=wiak+h+d2tZ5W_MwRzatUP=hJKn7cpGjDxArG-gwgHLXg@mail.gmail.com>
 <as9-2cIuGuXwE2Oa@pedro-suse.tail5790ac.ts.net>
In-Reply-To: <as9-2cIuGuXwE2Oa@pedro-suse.tail5790ac.ts.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Oct 2026 09:25:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgkoAuxNXga29nQ8w7GxdqR+4vPAUhPsbfp+gzKrb9EgA@mail.gmail.com>
X-Gm-Features: AclHuK_pD_yiJ_EL5fvXHW6fwc0LStnp8MOP0VvBwqqfrNX1h2hGyUqQEybsEuE
Message-ID: <CAHk-=wgkoAuxNXga29nQ8w7GxdqR+4vPAUhPsbfp+gzKrb9EgA@mail.gmail.com>
Subject: Re: Improve page refcount scalability
To: Pedro Falcato <pfalcato@suse.de>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Harry Yoo <harry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C94DDA0011
X-Stat-Signature: xskcokbmkr9e5ex7fbx7rgqego8krzzy
X-HE-Tag: 1791995165-293685
X-HE-Meta: U2FsdGVkX1/GOhWib09RHysE142gde7+7blTzWrjn2AH+u/vAEZpnHFu+MS9bhqNWKQPpejVROGLI1n0uGFax+AT2q7Sc5la9n9CQFSRYPeSH89A8vy8ugwc588fkEa2uTy+Mn5VyJZDBSC5fH/ZOS0dnfopryHiCH17pAzyqH/hyOJSO0dz0E9DPBG0tnot8vDioWuswEuR9rhY5uaWusVPqVrhj3736P93FbbeLzX063Ax7roTFf/xQ+yF2KTLx7wSfBupfQq9yZ5d8vA7O+/9i1xVm234HjbOYq8Wzfk/uO6HjW9+kfN2d+rJBWcuOGTXzp4iLxtcay0J3ZnrDd+F+Ub0zQpsPGYHrAIIDaZ1C4wOmPYWeUr00Q6do6rW+wQC7NSgI0gKsWEekNBK8wcBo7jQLslM5Y74+IL2FAUtcRHu02xRvFV7Vu8JsPjmk+/1qEQuo/LwYw+ruDfQYUnlfbQT7m3Ha8HRO8gx/nJ+2Fr2ydLFb3gL4Acx2wXOBGO3duKmTVkgbwhCVPvXMZQ1xvp81sY3O5V4D18cGllFM6p/821krmwIpvVsTKxMS6fqx4IeFU1CYuhblFnQCy8fWeKVtQ8EVN6xdD1VFUJgz965oqBH7WVSbdhXlf0UiIt5GWhwKb1FQrsklDNyvp26Rfyhi0M92R7LuajJsFOSbbAAJbiRx6L3553fy8X5byUp2PSFRRZdk5MFAFjE2qPSeNvNShomNnEKUEl51WUSXZ0RT1u4w8tUzAICapTqrFNSaRKXGvsRsDcG6xxyoNxZU99V60z1ORZL5ysLiCLVmX99i7HrXYl8TxzQ1PSKjelvh/zAP4cITdcY2/6CGgx9IaYOAH4orOfxlhkGQiHqRozKQLa+J8JPvhF4UCjaWpMyTLjlprbiYB6wjFQTLP/Cr/rovG9FpCBIXR7e+2a+aMjXWlSVZE1RHS3uvLdHZT1CAd/K5bqAmmB7STz
 4HGq2CSe
 o4xmzw60WI53EB82UnGfY8JZkt/monKpjw2rxFNlHwzYUHqctMeSe+EzUOCYDGoJy5shxPUvXlRtcHc49hfMdroiGbmbncMmeTSsWeqPKzuzQbAkp+sE+AYXv+kzwHdSQi7cVYuqN18hE7A9FvW2fsWItQ5QhDijJW28SHp6OzYM1/PVegTPL7ZMqXkTxK797ZyWK1QdmRMUU6mqFS95yKHdynVXgpE0VH6CTBGPKJqvTCObbUExIBM6HEDq8o4XvspQgX2ZxF0jk/Bu362l3QjVFLb2PMw+MmuYmc4EuJ6cMsy9PEFHwAgSOoIzg1hGHyXN3v2CtNQ6ls9UYVAiwLpm3mu/F5axg1dMOEWqDoIYdIeHI4u+68xRNvhG26q/xVzYTYLsZCtRMh4P/6u73HWeZhspCHhhPHsjtxfirJsKfWQDKBs/SbEy8wbXzzDB6mJ7eJPL1dO0Dpr2YBqoA6gxyopkC0iX3tYe/5bj2zJzQDqRJgEfH0QTdEsV6Vo3NTZx3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 at 06:59, Pedro Falcato <pfalcato@suse.de> wrote:
>
> On Tue, Oct 13, 2026 at 06:01:15PM -0700, Linus Torvalds wrote:
> >
> > So there's effectively three different things working together:
> >
> >  - mark a folio PG_rcu_free only when it's hot and keeps being accessed
> >
> >    (See commits dabc522cee5b: "mm: have folio_mark_accessed() return
> > whether the folio is hot" and  bb5908b733a1: "mm/filemap: set
> > PG_rcu_free on the folios that reads keep coming back to" for details
> > - both are pretty tiny and not really all that complicated)
>
> I'm not sure this is a good criteria for checking whether a folio should
> be RCU-ified.

So my argument really is that there is almost no downside to marking a
page for RCU freeing.

Yes, it delays the freeing, but it really doesn't make it very
expensive - and it does make reading it noticeably cheaper.

I'll argue that PG_rcu_free is cheaper than just marking a page
accessed, much less having a dirty page. A page that got marked
accessed is *also* going to make freeing it more expensive: it makes
it go through the LRU lists one more round, and you're effectively
delaying the freeing of that page. On an average machine these days,
it means that that page will be delayed to happen after many other
gigabytes of pages. But nobody even blinks an eye at *that*, do they?

And it's not even *remotely* the problem that a dirty page is, because
while it requires that "wait for RCU", it won't cause the kinds of
fundamental problems that IO causes with writeback.

So marking pages PG_rcu_free isn't "no cost", but it's a real upside
if it keeps getting read, and the cost isn't actually that bad
compared to things people don't even give a second thought to.

> - you don't need that many accesses to get an active, referenced folio. LRU
> batching makes it a little harder, but not by much.

I thing it needs  six accesses with the current mglru and default
settings as it goes from "not referenced at all" through the lru
generations and then finally hits the "no more generations => it is
hot".

Sure, if you don't do mglru you hit that final stage already on the
fourth access as it walks through "referenced", "active / ref
cleared", "active / ref set" and "no more stages => it is hot hot".

But if you read the same page six (or even just four) times, it's
clearly somethign that keeps getting accessed. So "mark it for RCU and
fast accesses in the future" doesn't sound at all aggressive,
considering how low the cost is.

> - rewinding along a folio doesn't tell you much other than the reader
> went back, for some reason. It's also natively racy so funny things like
> multiple pread()'s to the same fd can easily confuse this mechanism into
> marking this as hot.

Multiple poread()s to the same folio is exactly the case we want to trigger.

Can you make a load that marks pages active without those pages being
useful? Absolutely. But if somebody does that intentionally, they only
have themselves to blame if the end result doesn't perform well.

And if you don't do it intentionally, you have to *work* at it. The
read() logic already treats "continue from the same spot" as not being
a new access. So you really have to *actively* do silly things to
cause a page to be marked accessed six times.

Or - and hear me out - that page really was accessed several times and
should be marked for fast accesses. No?

> How many pages (as a %) are you seeing as marked PG_rcu_free across a boot/
> realistic workload?

I haven't actually checked outside of "a normal boot doesn't cause
even a single accelerated RCU period". But I'll go reboot into a clean
kernel and see what a kernel compile does.

               Linus

