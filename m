Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3040C43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8C86B012C; Fri, 26 Jun 2026 14:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A94B6B012E; Fri, 26 Jun 2026 14:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872EE6B012F; Fri, 26 Jun 2026 14:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7C26B012C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:37:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9BF71C33C6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:37:05 +0000 (UTC)
X-FDA: 84922920810.23.C4C8E73
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id EE969C0009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:37:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UxRX9Vp9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782499023;
	b=6Ufh3DREB4P9sQHT2lmWXc/uf7KA9SyYqg7E1GwXlHzO8kOKDbbWGzMIjhyea4BuL/Uzak
	CdRLvvIz4d5LZqa47HwcuYl50KSA9WMbN1rnvTgpe/kh4/I8ZUIo8neDu9QgmHzqbnEX8d
	KNPo61NS4v0t+saEH/IwZ0aKhVoC5yY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782499023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOOeJEgGJirHLvCIZDna3WzBVXhg0OXljifTzHlO340=;
	b=XuMhgyLOflunkFtaSdXFEP56dAF2Z3kJlc83gtALAik76Z8pllonrEqe9Xf6ppZba1la81
	n8R7K5IRlHrdtG56n/RJ3Ao7DpQzwpoHHiIicMyi7/+5cgAb/MbMwec6tVWdgxm8BUuL1C
	L1F5rmAFk0JdjF0vusezXjLoa5XBKQM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UxRX9Vp9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490aaeabdb4so8947005e9.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:37:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782499022; cv=none;
        d=google.com; s=arc-20260327;
        b=bJdVEe5pb988p2BWZcgbrBncQLFEH2rmZCIQzKyIC86h7jlW/ilEvuO7mEVSfdLrjM
         WIy/pjNSfYGJkoe3PaBgzO7zmroyd3WzgLMvFrfxqksICMnMrRpOnFRyBzEbyEvCRV8D
         k5NGCRfqBF4po+xmK9k0m0z9i6VWheo7HCQpnpNMNpOJ8UTCMf9fjHt+JlAqZGxzNQaH
         eRFRnpz3tTqTGzfz8IpR9Ce2onG6TM3cjm6Bu2E7+VBvhFjAEK5/MRZJeJbSbefCDrXd
         tAR/CDPMpblhR2oQGSgRpxxx9wgRSckDMSaASthJo+WpEqAv9nyhbxNrP1SxExsRRPQp
         O4KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HOOeJEgGJirHLvCIZDna3WzBVXhg0OXljifTzHlO340=;
        fh=CAGQ/m32bHQCMjer0wPOF9g0VIUX6nmoF3BA3PnLOgw=;
        b=iYb1IHmYQETqwvajouTnjDNo1CkgbVREaVJRAKLDMaRPahnQ6nJ2cwroqX7nLy362o
         zWn3zAM3rqmsQuEeAzroe5ZTkU8YkpXuypB1qgz9kkjrfGUfT81RQgh5U6BeQ3rlDZhH
         OG68qV6WgkXYbIeeZ8OjFnBvlS92kVRQi7sSg7wsKaPtZDPo7soCo/MI3BLK+j/9C1BW
         AyKo+JuYJxIo602N25KqVeZ2Nt0wJPx74GrL15rE3zRNwTWUp/jyO6092R/GgFVYWmgL
         Y5WwgkHwwg3axsbSlXmLlPQp7LPLSRyXvoPhQ4YPTn5Z8ouMkX7WlytGm/Q+24e0edXz
         Qpag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782499022; x=1783103822; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOOeJEgGJirHLvCIZDna3WzBVXhg0OXljifTzHlO340=;
        b=UxRX9Vp9w0W2Ug7deBVNLsF4+J9jU8EuaZXcnY2ySFjusemnqbj5UeWMNY8ze2OiE1
         pwi+a1BQ9vomQn8/GrPfCmgIgjrYjPVfCrBndTajUMVC925Bxoj5SFlrUT9s7SdMfdSD
         5rauH4rrHGX5nRTd9kQAQMYohe0JhQxKoP4M8jDYwIuNt/2KlY7vP8RQxOXZhqLJhcKO
         I2TwygCjkv1qvRzZZP5n5KMFD5DwBs/dAonqVExifk1sxk3SIom3ig+ZGEeqz5JNGrbp
         +UqknACUb7TnPzzNoU5kHmYcI4zGl3jyY+tQSphca03iJLDyGtthxON6qKdosCgNyy3J
         ZTHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782499022; x=1783103822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HOOeJEgGJirHLvCIZDna3WzBVXhg0OXljifTzHlO340=;
        b=EKG2NBOZMqX0uwE1ZkGe2NgkuB7me7+AB7dMVEK7QDY1JTUM65sgGbAHT81+kSl9oU
         3/T/8L0rXk0lWX1O4KdnrOQ5VGhe8B5dj/BPuKRPkuPHSFTJu1hKG1wJs4x89hvm5Nnb
         QX8LhyatAKNWzcKKweSNW6PQu9V7R6caVR9a9MEV8hfkj3LKhGGX1CFo2Ddf03jX77gr
         SaqvdjuCNDgmrdNwkHpV77O6OsbUncq1HyyqgyT7xva3tkmcJDKzm9dFJcwcRpxjkSVo
         /cXOt0sqWvYlclpwNZD7c3EeQB8qx5I/j0daqkv5mpX8Mu+ONfmVi3Sds7tJ1+hOWcQT
         PG4Q==
X-Forwarded-Encrypted: i=1; AFNElJ8rG27yr3ijcns+ok+xGREY2Mb0F9LtfKFtCyfoUW/j2BXG8TlTMJzLlVBwlKm3kKIW4WGIYPsvyQ==@kvack.org
X-Gm-Message-State: AOJu0YyQIc27zMwFqQs6z7lu8zVZsoN6rVsmaRzWvnzn675OFz5jn4X+
	kG7HrIsGnOS0eYG/eXKDERTf5Yahbp5unqa3CgamYFq43exUP8SyRSn4zIt5uPapxkTfflC1VEw
	D18wZmZU9AKYcxXjEkCuzv2YVbqvpRp0=
X-Gm-Gg: AfdE7cll/2aNsHdsrgVPbPo1cxdlDXa/LinH72s0PPTF28YHtn1707UUTKcCdki/RXM
	bsXhD7pYcJfxYYsd19zLs5woS6JFQ63BpZDDeAHwDfUQrf0V/JH+9Al3sWsKDOPOogzw1e5wxNI
	V2zcCqacQJ10bLB9VuOPrRkbfWZHm5ZFTzE2T/cQEu6KFcx7jtB0BtBEnBK58EzrGcuIw7Xiw8H
	3IgxYilUqaMPIGfKEPwr0Hftfl11714G4wGBNcp7IY2zArCCH0aWcFhhVxI0TGsZvCp+KMBAD3f
	IIbjtjBU+RAvbi6sXcfQe442bJ4x
X-Received: by 2002:a05:600c:3b19:b0:490:3c15:7146 with SMTP id
 5b1f17b1804b1-4926687e6eamr128170845e9.19.1782499021866; Fri, 26 Jun 2026
 11:37:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260626102358.1603618-10-alex@ghiti.fr> <20260626143244.3382853-1-usama.arif@linux.dev>
In-Reply-To: <20260626143244.3382853-1-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 26 Jun 2026 11:36:50 -0700
X-Gm-Features: AVVi8Ce_QPTWquN2d0lbnXchc4ZFxAYS-iAJXfFBvlstHcQ-UH4eG8289oGmnbI
Message-ID: <CAKEwX=OKsjtStcuvhQ3WCGYoTJHT6eagBq1mZqX+DdbLm_BFLQ@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] mm: zswap: per-node kmem accounting for zswap/zsmalloc
To: Usama Arif <usama.arif@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>, alexandre@ghiti.fr, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Ben Segall <bsegall@google.com>, cgroups@vger.kernel.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Hildenbrand <david@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Kairui Song <kasong@tencent.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Peter Zijlstra <peterz@infradead.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry@kernel.org>, 
	Yuanchu Xie <yuanchu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE969C0009
X-Rspam-User: 
X-Stat-Signature: 5uko4ddsktqexortiowhoxyhsg4i1n8c
X-HE-Tag: 1782499023-419050
X-HE-Meta: U2FsdGVkX1+OhQ5aD5PAaGgXosqDHn29wVsekzywf1kHz8/aaSb9GFYjjaXuyZwigw1XXC1Wu5GidWzQHNjvlH0anHtjQgzvzj3RWELJrj7KsflDcsQLip9KxdsERS/hkGEjlNj8I+VfhPrggi/vfwZl3mGeJBepKQ0G1SgQFkRzbZiZRn8xsBW6QDBoGKizkLE9LB8kehl7dXiSsfWaGNwai+8YI/+xozniqejXhnyI/w4ygP5XfgRC5QYelTN22qZ001N18cII2IWJOSIGSw4M7CcbdZ1JTcEzWhBId3WAdzA4yzYUew2gTnnzQcPo4SHpR2+nTTwwmoJNHhhTE39FtJYOkA/73hD6ajGFCSH1OGS2XO5GiV3qvIviWO+MqzbQzRc42JTmEdHh15IhcjXFqdgjEcaFAJ7It391DCUKzUAeKgDGynxlquRZ/LtX8CD3YYx1Ij0f8j5QROsdqcTnZyx9p3joEQbqWmkvbCtL8RwpXArJcb6owqFe6yh9xVT4fhZt4jaywVzY/tP8rJ+fhCjkDO3E3gHCdRYTmZQZfqsArCRUXS/MkaXGlhh7n6SoMnWRvv+iPz0J3xKk92yKkmjwYwPRvWgZ5c0PmKncfwfH1WXKEqLSdbEVeAmbPm420npUOeOfQTuef7Ktz1dR/+QjjXS30VVvJzFvj9JjSZXr9qiugk555wSpRBpCyoHMI2PvfyCAk6lV3x+pVqLgW3KgPXKaL7VMrcIIEd468HTPOt8V5twaaKHfvaWatjnGULS1mryUGklTOxtA1L7e/P0HHZw0wT+RwgKJPErUWp1cYShdDAXiJw7H9eMyD5tLwaDNEil12AzQntj7cjkkwVsZt3gfk8L2Z4VoU0jUBCX4MlqhRU3I4SJEYdkd6J0xm8FwMYrrysbDjwXBa0AUs7D3yAVO/0zbF9VcR/oj0W1gwWVw1XHv9n2kxKLCb29ezulf5wljlQSvlYo
 Zb/MNaD9
 QxHoY+rA7kIfyIv1WooXj0exxTrjFfKjWPlrSWOsk5rd+Z3xs8HyQaOZ+LpNspsnap52Y9AfjWvVwp+NdE8LLnTgGgZgO/zXFChkTuQZwCzJnFMp8/qcXfTeTWHymxBb6kT3xgGpNSwSNG6kpFnRdRPht9UlAm70jwkRfDYpEzIpD/zkmW7W33Kh2nUbicYTnIfaP+gYDOOpBjojgZ1a545h/I6CzJc0aIBO1I66pA5E5Ov4VvyR8GkuSXg4SgIfamx40e2oa+SuT9rfBsPcNR9QcwFyBJX56sc6kj8HlA9DZebddv40M8HNsey6MKgSHiirWNkGq4XYQeb+htcI9NKWQSifCV4dRLkLnxGyCWet9ZMppbDBKYf6E8EyosvQ0p1ZJ6AwHitygLLZrZOZbf/IvcI2K/dQlC6DKApM2VW9uV17CyxAj6OfinSk8+adP2cq+iVkBtFjAVVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 7:32=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> On Fri, 26 Jun 2026 12:20:58 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> > Update zswap and zsmalloc to use per-node obj_cgroup for kmem
> > accounting, attributing compressed page charges to the correct
> > NUMA node.
> >
> > But actually, this is incomplete because it does not correctly account
> > for entries that straddle pages, those pages being possibly on 2 differ=
ent
> > nodes.
> >
> > This will be correctly handled by Joshua in a different series [1].
> >
> > Link: https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua.=
hahnjy@gmail.com/ [1]
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> >  include/linux/zsmalloc.h |  2 ++
> >  mm/zsmalloc.c            | 11 +++++++++++
> >  mm/zswap.c               | 19 ++++++++++++++++++-
> >  3 files changed, 31 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> > index 478410c880b1..30427f3fe232 100644
> > --- a/include/linux/zsmalloc.h
> > +++ b/include/linux/zsmalloc.h
> > @@ -50,6 +50,8 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigne=
d long handle);
> >  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
> >                 void *handle_mem, size_t mem_len);
> >
> > +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle);
> > +
> >  extern const struct movable_operations zsmalloc_mops;
> >
> >  #endif
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 83f5820c45f9..17f7403ebe77 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -1380,6 +1380,17 @@ static void obj_free(int class_size, unsigned lo=
ng obj)
> >       mod_zspage_inuse(zspage, -1);
> >  }
> >
> > +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle)
> > +{
> > +     unsigned long obj;
> > +     struct zpdesc *zpdesc;
> > +
> > +     obj =3D handle_to_obj(handle);
> > +     obj_to_zpdesc(obj, &zpdesc);
> > +     return page_to_nid(zpdesc_page(zpdesc));
> > +}
> > +EXPORT_SYMBOL(zs_handle_to_nid);
>
> Does this need the same locking as the other handle-to-zspage paths?
> zs_free() takes pool->lock before handle_to_obj() because zspage migratio=
n can
> update or move the object behind the handle. This helper does the same de=
code
> without the lock, so zswap's uncharge path can race migration and charge =
or
> uncharge the wrong node, or observe transient zspage state.
>

Can we just charge it to the page's node for now? Once Joshua's patch
series is in, we can correctly charge the node owning the data :)

FWIW, this is how these zswap entries are organized in the LRU too -
following to the OG page's node.

