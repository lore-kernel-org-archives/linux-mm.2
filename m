Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B98ACA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 04:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F36C8E0008; Wed, 17 Sep 2025 00:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4508E0001; Wed, 17 Sep 2025 00:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492C58E0008; Wed, 17 Sep 2025 00:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 389DC8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:50:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7B57864C6
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:50:57 +0000 (UTC)
X-FDA: 83897517354.02.57670CD
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id DDE0A1C0008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:50:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CZaUwnQA;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758084655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXrprAAgFwNg+pFvYSf0/2T4yNRqYcxih/vGGHapvw4=;
	b=prxAzVbTX1iIlkGM1B8IBDXptWBXt4czoyd2emmby3/Xdscwgih6UDRWpypgwtUDb6Nlk4
	uNireH0/Ov6PjGEw35+q1OoEEAozsXiAH80vdtu3qo094U7/zInDmwEG0fFQmBXIueRJ4T
	l3qHdoEJJe8PjE5TieIq0Orj8Vms5B0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CZaUwnQA;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758084655; a=rsa-sha256;
	cv=none;
	b=7YuUZLTfCwVeTqrQxT7XrQLjPb1H17CRcckKCfTNlWb/6Zc0nLdbx5u5nfQanCCbbp4m8I
	emp8b3hkE17wi5ZeRyCt3eCVOQK1NmBCmT2z0cEJy7XTHmSXFBkuGTpsfD0Yv8M8piJzwE
	KNfXjFPxSrFMEzVlisJidyRskDN5dfo=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-80b7a6b2b47so593840185a.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758084655; x=1758689455; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXrprAAgFwNg+pFvYSf0/2T4yNRqYcxih/vGGHapvw4=;
        b=CZaUwnQAGA2EVOcrdB6ZQcMvrlROZVrSpgo8L9iZVEc2hsrVodKbiyc/67H1vGFhXQ
         IEH8oyF7MAbQug0Mgb1mH/0bsEBaDMiD3M1kX5fCqYFvovHpRMXHAXeTcMaIySnwGFy7
         sU7ONJHNYUYDmcQnWQaT9FOxoXbZlUGmmxMBxk2Ux2yuBMdUop7GYBiH2mqbpljMu5i6
         xNKgXovhG/eTbWr8G4hAsJqc4NnI8EXpluDq+xFU3QwslekC3CqwVKQduCQ0E+ma7lwd
         3wN9WRSfksQyBjxmW4Mk7VHwWi0lI6dJTu3jw0g6QdIt6psYbkytzI6xnWwyHpl8cRYt
         skAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758084655; x=1758689455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PXrprAAgFwNg+pFvYSf0/2T4yNRqYcxih/vGGHapvw4=;
        b=tVhsznX3fSmxABuriYUTTtRLIcjJhaPss+xs0kV/s7HY9BnRXivXJju/E9VqSpHCFt
         w79CXtWY9foLcYUMStN/kjJ6tQLZsNBa31bT3GXwlqcGEoi/80n6i1iPcF0TBJ8U029D
         CU6Aaamp+5xllyOBFyZy3OZnO5bplo5C29ViaQQ8+yAn/01fDUm3U/LTX+1lqb58gbgS
         vfqUmp6xFzPJXj8e9Ew/ThpJ9xk7Aj6S9g9tMRl2QbUYL1YaXYQTJrGbSXhqdq7iX/oZ
         J6OZxmwhvJwlKoULJXNahbPKCkdpOBdxnd1BaWVqEW9lcmIcLXUnWj8Tw1S+UiHyWQPG
         yuHA==
X-Gm-Message-State: AOJu0Yx57ESbhML5IRXxnUglAdzcCzHiEW4rLE4HkN1MpxOTAGopckmU
	2k56ha3qLinH9VDMjK0Rr8bSs29Bb6l4N04erHwwTOLSLWp2B48SgsUIo+IAhFo3yCDDs0MphCX
	FvgX0IVkNk3hTMFoD053FnrJq110HTh0=
X-Gm-Gg: ASbGncsB0oKaNuGDjbmc86yfi93ZTSPcK6/Fv9xg6B9noUpI2cdc9pOrGYGqLM15W1W
	+edta8wBxAZJBUipkwhFdppjaOm7qOBRamYMBsEO4iCzYhhz7L4+Dj5Zyh1D5idnEm9qYe/C3vB
	2NuNzKiIOziLYOkEohGkkUP3wOTVbwpigPmJfNHKTB3fAsCVeoTkOOICXyvig3zsA9lM1AYWuSE
	mvFfd/DvslfGJAg1WE4NyxtVyd3ceJq2CFztCELmQ==
X-Google-Smtp-Source: AGHT+IFKJ8xQpx4x8yXEa5+IOeW7FFAAV7YSxhGyg1VBCB4k9GdA4brglljsJuH7OXc84cuVlwYZpboh7wIUOPsKlbw=
X-Received: by 2002:a05:620a:700c:b0:80c:e95f:8a54 with SMTP id
 af79cd13be357-83108e4cd45mr76256485a.29.1758084654868; Tue, 16 Sep 2025
 21:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-16-ryncsn@gmail.com>
 <CAGsJ_4yrDFAe-3sMj1K2JeWrqNXCBvYvULY06b6B3ogSYjqasg@mail.gmail.com>
 <CAMgjq7AJ1=ji4iw03JmdN07MpY8V0CFdtUHpF58mTnSjGf=rGA@mail.gmail.com> <CAGsJ_4wH8ATOQLodxm7fEZb7Nt0oCxeyuiiUcf3ZYBpyC0kiFA@mail.gmail.com>
In-Reply-To: <CAGsJ_4wH8ATOQLodxm7fEZb7Nt0oCxeyuiiUcf3ZYBpyC0kiFA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 17 Sep 2025 12:50:42 +0800
X-Gm-Features: AS18NWCiSnRJzKpUj8fDfFvjwQx63dGbAKROP5LujvWrwk9OWlY3tSO08qEUO-A
Message-ID: <CAGsJ_4xuV3SsJo0qN6HZxcJMAb2KX8UzZmrYkduLyKn46BrGQw@mail.gmail.com>
Subject: Re: [PATCH v4 15/15] mm, swap: use a single page for swap table when
 the size fits
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DDE0A1C0008
X-Stat-Signature: 9jzdunqxobzd3n86cz7i4b8z5gf9gckf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758084655-726851
X-HE-Meta: U2FsdGVkX1/4vZ5FCDqa0wjxaN5HwXnpa+i5mNHiWmZXPAgUs/7XNyVpTelxMkKgx3TTMTxaAibQnNd+vANgsmlsrI85WgoZA42b2rfy80dHZ7r2gdsAgThgkxkDW3u+fNCSnhqUPZU9H06x7Wf39Z0xItj3eqkhtJa4c+HxL+WblWgvIX/Crjkc73j/b84mEvsWree+yeRL/waom/luYn3+Pzn6yQIeLUoQXZpZunzJCDJV+H10D2Tj5lYijdU27Q0mSQQA6r+qAKojomf/Y6v+Yh71NcM5xo6ShjuP4ws5tEQCuLVBBRdZ/eFYu5zbC6O06zWREnp4BEjp3zUgni0v4g2514VPIKq6I9OIJs8lwgWomUYA/ijQhA27+ce8xHYtQBmFYU8kOLGI2n6gLghK0njXcW6OhRHdmUJTXRN7yAXBAx4pDLegcfw9ET1eLw3wL2GbCSZGIgR+9+WaGIDvawfLS3YtIDfvHFGcqemme3QjPuiDlfZT98Z/NpQI1LCNdgP/5PaSEoxw315c0LsT4eX68IFICxhVSL812qQV+xhu8PRB0knusX8mHa7rfKwmrbIjlvbT5rc2T6vznd6oBX/PTZqJTo2wgqar+riMbCyljhmZJ9cHu5C/1e8wk1Kgz+c+dADRpfHZbGdQTuKYQu4ZUGjLkvUbuaTWUlfI34GowyY1AvzO85Q6xMiiN9R0trD91/gcxl4MN1hKjzSn9aWlzqf20mc6E8V5TvzqkxQNO0M433Y7y1hqoeNvc6XSYsyHyit19GqzH9Fc8cLgjxn7SjPAAevb3pO7yN283Ss5FGiqNKJUpApjSl5esRPA+usDeHfa81ueLl+j2DxUVfvW0/gH9oe+r7JPkdYaw6nCwxBEk9Lni6AxUPH9SuQmGWRKppLjzi53qJMnlavR6KNzrQNKEXAshw5vEeXxrEJZScK3cix6vtN3ecz6BQERkCgvyzSVhI8hl0/
 EJsbh0d6
 MfT+Pay0rFHnmHhk62i1PTikFh5PmyiFbEdK1DGFPyj8aKCT5Nt/iX7GE4jZsHaA38UFyXvTSQIIoHgaCSXeA8thXnNQHbaMlXzZgcZgwj4fzobhAglPOAWKjko+0N2PAX6ucZLKgm7TQlndC9BR3heDhQ2d+0ma4oYgnHVfZOFZebvu1Ahfqh2UHR3fbZQeUipnUyIgSvY0fFusOqZbdNyD1CAnChWjQuBs0zcmouElORZ6DY2YFc48hcrlZKK/gEVnrz8A8ABjv6mCbkRoGBefz8FuZ0nbsfSxqAhM0zouPnmCIcOhiJfiD4/mcNfsY/m0taAtIUqz7uR2A8/gsVVs+RRDby3/34YLW8O+MJOZGlEhWj2Gq9XuhWID7pvsnkU4MM+T8KbVC19+8wYlseuQfl2LcE9ik1UkPMcpq+NF0O4GayA9GFh7wpnaHCp9Z8ZK1h0C6tYbjhe858pZ3tlD6aqqndhN8iK+4PBSKLCygoRY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:41=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
>
> > >
> > > > ---
> > > > +static void swap_table_free(struct swap_table *table)
> > > > +{
> > > > +       if (!SWP_TABLE_USE_PAGE) {
> > > > +               kmem_cache_free(swap_table_cachep, table);
> > > > +               return;
> > > > +       }
> > > > +
> > > > +       call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
> > > > +                swap_table_free_folio_rcu_cb);
> > > > +}
> > >
> > > Can=E2=80=99t it simply be:
> > > virt_to_page(table)->rcu_head ?
> >
> > I'm not sure if we prefer folios when possible?
>
> Not sure either, but even Mathew still sometimes suggests using PAGE:
>
> https://lore.kernel.org/lkml/aLrrQDCBzaMwwmA-@casper.infradead.org/
>
> BTW, "(folio_page(folio), 0)" looks quite strange. I mean, why is it 0
> instead of 1?
> Although we know it=E2=80=99s always one PAGE, 0 still seems strange.

I mean, we should always free an entire folio, right?
It=E2=80=99s impossible to free just one page from a folio unless we split =
a THP, etc.

So it seems more correct that rcu_head should also be promoted to the folio=
.

/** @rcu_head: You can use this to free a folio by RCU. */
struct rcu_head rcu_head;

Definitely outside the scope of this patchset, so not a blocker :-)

>
> >
> > Either way is fine, they are identical for this use case.
> >
>

Thanks
Barry

