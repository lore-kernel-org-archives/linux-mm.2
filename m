Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11003CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BF96B009E; Wed, 24 Jun 2026 12:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02026B009F; Wed, 24 Jun 2026 12:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBFF6B00A0; Wed, 24 Jun 2026 12:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94D4E6B009E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:24:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25DCB8DA0E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:24:43 +0000 (UTC)
X-FDA: 84915329646.25.89549C5
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1BEC3A000F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:24:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rYQ1RS3a;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782318281;
	b=2+TJVohP2WGPoAvfB1P9vGBpbBV4gEGLvHGO7dQ2NtxG81TImj0IAWQ2iCiadkNnj1P6ce
	C/Bs/cRm4sVCMe3dZLFAmXJIZ8qA96/IxGpUgx4QHY/nS4dquU3Jc/LgDv8f8i3BNKmVai
	EFKnz6UL95qdR17isSS+/7yu8cd4ano=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782318281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzwnEhqWJZImCC+tqBDdx1M1NrB2lLpdw9IVLibHq6E=;
	b=qZ4iNqUiVvyAAkve7NQIz80Bk7X4cjT4x1wcpVh+KPTL99rPEhodvwXlFspO/kwGaTN9wI
	1sSSPhgi+viswx/D6arsqCvgbIRBTVlG2Ep/JGqSaWLyi+V7KXjnJI+Y+it52EI+STHCBo
	xMQEuSQwcsdHOWyoLXl3Phz75CpD/wQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rYQ1RS3a;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-519ed52bcc6so338491cf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:24:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782318280; cv=none;
        d=google.com; s=arc-20260327;
        b=FP+ByVJwGrRXKVTwIdSwKn4r55xTT7nr5RD/PbX6do+EyWTeOHelTSt7XR7BIEuw6r
         FPTfaq7viGFO14n9RBkZZFvdXrHnMlQnNuu4rRTJodVI4drJqgLsYMfy1ZPz75MTia5R
         xlCjeZFdTcKmdDdL/YoH4hb0RlkWbKzH/z61r1peVJ1lzGwpekJMcQrIJ0dcoBnCGETF
         AwYZe+HAwwG5wKbCx+C85fn2ualdxlmJiBZHfkhxZmh+yWaSyYGbQAregvwJlqwjvE8W
         LvA06YCcOvQDNjyee4mSSdyfFH+nJx5kJSbigT/PNmWROoJjUndX5Z9kgPoGKSb56Hbe
         R4kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HzwnEhqWJZImCC+tqBDdx1M1NrB2lLpdw9IVLibHq6E=;
        fh=g5cS4vqQ1iby5JMm+3YvJQkO7mwAB8q+ursaYm91hfY=;
        b=fA8DfKMgpDeCwDd4SCS7B1T92QxGt56m+ES1xeG62oPqV/5oU3eP2ZPAZWwCEKivE0
         I+3anujXlYNckkNLF0vew2z38n+anJECGo93D5ztbS2VE6acsXwvtbWvJPbCPvgz9V8O
         nDviXpP5cXoyJdXq3xxltR6jAB9PjoX8YkQ0+07lHf/MS8NmowJf0xM62xsZX4FKrAST
         qZW83vSpnwsCEkCAxTZmTbKTNQHS0gwYMofNNxt1FNquqWxph/4LQGu321duhf96KTdK
         r3579U/R/Lhpkm3rAbIVyGZGhzDYYUmEUOKzXIlKX6QmF7KgarbBJ3BvN9ctWhX1uOoQ
         298Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782318280; x=1782923080; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HzwnEhqWJZImCC+tqBDdx1M1NrB2lLpdw9IVLibHq6E=;
        b=rYQ1RS3a4DkwFk7M30ea+Hw8P//gXk1xO89+PN/SBDEDhxAXm9IQkwSyO8s/5FM4tS
         g13ylWGGw+8qZ6mJ1MebGCrO3aLFgR5H0nxOa4NZqd2267dRlbNW89GgNQ3ODvEW+kEW
         ibo+6lxUkc7F9G4iWXFXKDUr7QDv6SX6U8+SkJFaIQDKRuxtzvD+RS7wmSMYAqi+HHcQ
         CiMbSYasZKGaU65Baog9+MNPlzKoyBUCBTrwRapJgB7NB9AEz9DAqOtFY8uI+sir8ePy
         nxojBsd6zeD6XThrX2kurhOcZ0Qhic/4u9EU9vJYNeoR0gzDeLa32ZxDMqWa5vT/amyt
         zKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782318280; x=1782923080;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HzwnEhqWJZImCC+tqBDdx1M1NrB2lLpdw9IVLibHq6E=;
        b=Vei51p5GX3WQLroThxEIvTS+uaHxVfJZs6YiTni2sBPTaAbJeiNpf/t2kz4GyoWhhg
         8evAsiXs7eNTNtLf2chX7vuaDJORRgJvzRm3GHMVqZaXeVJ10eifOfoPDL6o/FQS+uCA
         h0jzK/mlsJUOMDgLzwAPzRJEAdjE3AEdaGYxlZbR/YYpxDsHAWIfIz9wchttH8L45l5e
         2IDsUxv89M4Bau2I29NAiHtbmDxW32ZQeghWqFnlPhWXwOFv30vDRfpVYy6IBUDktP61
         Y7u043CYOH6FHyPWE1m691POxGJVs3HjtAjsWm3YBbkRUVftefS48r86joElK9fNLRKZ
         2cMg==
X-Forwarded-Encrypted: i=1; AFNElJ/+4hqZdUITVEA67x2Y3+XDvjhZxbX1xO3fQ6krPFIJFmcpkTM/WP5s4OVOSJ9ff992VK50CkpGKQ==@kvack.org
X-Gm-Message-State: AOJu0Yysnpd4WgdCwVhNvGHl30sBnxfCYx61dce1WzpWmGqYg38aLqnD
	fzCgO5WQG3e4ygm+uyfbZ/dm2DJgisYoQtyhMY6yzqdwd0EnfvfndtP+5pnZaE1D0PgBQGAgjRT
	sgja/itcTfIIYmC2lrv6P7DNENOuHFXEVJ+oHh2N2
X-Gm-Gg: AfdE7cl3AJTJ0bM1jtSn/OGrR35qd+K8+Rkt8XGUhojbbyxAZiq4BXl+HL/8HeN7RE9
	QXfzE+gR8ZJOOK+qlk91EHJZYep/84ld5zhseDJEUJGii9pRoQDLjf3IQt28b5zuRjTFZ0Venx0
	TqTSL7qP4PEKkUuIL5ajdxgzVQkUyTvTUxzN1wIPqui2z5f+fM6ww5yB6wBU9KkPRtKQ2IHoroS
	qSKsNG9SdOvLbw1vDhILqIBpSNRHme5VGOT8X9R4d5qqHJcGGAVAopjXMKqhVA/26gBsUYOw3QQ
	QwOlxPxXzSGZhjWgzHh18nnBGhU=
X-Received: by 2002:a05:622a:1b16:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-51a627e946emr9157051cf.1.1782318279473; Wed, 24 Jun 2026
 09:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com> <20260622-alloc-trylock-v2-10-31f31367d420@google.com>
In-Reply-To: <20260622-alloc-trylock-v2-10-31f31367d420@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 24 Jun 2026 09:24:28 -0700
X-Gm-Features: AVVi8CdYUDI7odKsPpvoYQFWpGl84aGN92XZlpKXNN_3eXgP7NaHVsZe3wDvsVI
Message-ID: <CAJuCfpHqYWAKjMSdhngvCaAp5htkEhd_RVj1OJf8+HUbWRNNjg@mail.gmail.com>
Subject: Re: [PATCH v2 10/13] mm: Remove __alloc_pages_node()
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8er8ekdc4qadrodqm51ujd33gn68jppn
X-Rspamd-Queue-Id: 1BEC3A000F
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782318280-187928
X-HE-Meta: U2FsdGVkX1/RizoUi8wB8dEId5aV6UfsciiCY8EV+0xtoQmKuAMyQFthOfKu8BBRD/D20cFnaIXIw9EDK+x7xs1m/TvZgs5ARJ/Dc3GoRX0+mIQQF/jzorTeeZ/BcvetYHyVQYxBuDp5yvTQ37lWVmStGVJkbPk5dltNvmXKGt7UD6+r2KfzrVJYOgg7rPyXKjOVPZbRlNkpjR/d+tyPL3cO6MJzsl0VOLmDBSVQr7ObrrJW+7EmQLb/+jacUjfMmWpusRRWBtsofQz9nxUMg9FuYwhYHKxrietS6aCo9OkGUYbRUCdGH9IZSNhYH6C50skXFo4j/GDMIETOdkpgmhnU4kf6FIfBndoqShhtjIrajIJSZ+v2dCWvlCSMR4iweJbG9xyFFQmby0/Dc6HzvwY+f0Z1rbQc8pfgqdUvy3G7a5RigAH/jAUIXzzVSTBi7ZkM9VJ9BSOwwqMh9C1W+YQxmVIa3RrnrvRCbwOF6zQm1d399Q35MatWlUdmYq+djgEotL+qeY0hbwLZGLrVFenzl4kC+yN23hb2TphGjCISjG52ta3ajw4srWFNL9gWmSS6HQtVIEtThTdiEMr6Vod3GLLYlkuykgVmsQ28Z4JStJlRHb75PyceWWIUa3UK9hEZ4ziP/nJaC2IkPcMqxoRT9tdlwArxdpTfIpt/5Ount8tg7pZq9rQm7uqR/07L4mr0x2C7VLvORXCvEf5+J1jMCLavQi6bngOoHmwYkLfidLYcaYI91pDIO5LuX9lLVIIqZ8mptnt+R3SaAEp0YM1jvsvKRK+GfvwWLUo7D+U1lbVhn+sFr5Uey0Djp+d0HieOs/kHu+Iz0oszRiOLTqClBFvWIIaSmsBgvgHJOZjocUiAwVSy1iB0Mf6sGgc7llW8UJ0xiBejr2A0WCd0CkxHw3qI1vhxpUaahHRYkXzGOfSOCsbHpLuzi9PcjY4oy5C3NZnzrt6pR3QkmUw
 bbAjYUAZ
 fvYTPbsK/0XiYP5il/vJqzpw/+UkQhP9hjKCp9OsSG+SoY+vd+BXjZC1w2SFvS/gLPbB4nvSpDBpqfXFpaf8aRw/NFqP8w4WSXRDq1qQYnBe4mhyD+jq93LyU4tH5YYvxw5lGk8t6lWlbJjkemAz5Avz/K6eLUgO4wh+wfs5J255uy8wEVsRdJsoBnoOAX1RcYf9jWJiz1Fr/B2vKZYns5b0+sk2iud3dhh/U+sacGHQ1djM399COzXS0SnJklI3Hn+/flcBUeFVVVB7iliTmld5f1byplwU/KwXLhrclSJCcklfWhDJuf1g+w+MKypZFZ52QiZ+80kRzllrzTGhjK15DF/XJYdtEnq2yvlwmu56VNd/YIzxHC9hdT/t7o80XyJ90mSfzxHaCkXlubAflHskEQlgcuIbuSMGMyWgUO22HvKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 3:01=E2=80=AFAM Brendan Jackman <jackmanb@google.co=
m> wrote:
>
> There were only a few users, which have been removed. The only advantage
> of this API over alloc_pages_node() is avoiding a single conditional
> branch. The disadvantages are:
>
> 1. More API surface, more sources of confusion, more maintenance.
>
> 2. Worse impact of CPU hotplug bugs: most users of __alloc_pages_node()
>    were using the result of cpu_to_node(); if the CPU gets hotplugged
>    out this will return NUMA_NO_NODE. If one of these paths fails to
>    protect against a concurrent hotplug then page_alloc.c will use
>    NUMA_NO_NODE as an index into NODE_DATA() and cause some horrible
>    memory corruption or other. With alloc_pages_node(), the code might
>    just work fine.
>
> Ulterior motive: this frees up the __* variants of the allocator APIs to
> serve specifically for use as mm-internal API.

Ah, that's what motivated all that churn! :)

>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/gfp.h | 20 ++++----------------
>  1 file changed, 4 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index cdf95a9f0b87c..7edcc2e0be9ce 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -278,21 +278,6 @@ static inline void warn_if_node_offline(int this_nod=
e, gfp_t gfp_mask)
>         dump_stack();
>  }
>
> -/*
> - * Allocate pages, preferring the node given as nid. The node must be va=
lid and
> - * online. For more general interface, see alloc_pages_node().
> - */
> -static inline struct page *
> -__alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
> -{
> -       VM_BUG_ON(nid < 0 || nid >=3D MAX_NUMNODES);
> -       warn_if_node_offline(nid, gfp_mask);
> -
> -       return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
> -}
> -
> -#define  __alloc_pages_node(...)               alloc_hooks(__alloc_pages=
_node_noprof(__VA_ARGS__))
> -
>  static inline
>  struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, i=
nt nid)
>  {
> @@ -315,7 +300,10 @@ static inline struct page *alloc_pages_node_noprof(i=
nt nid, gfp_t gfp_mask,
>         if (nid =3D=3D NUMA_NO_NODE)
>                 nid =3D numa_mem_id();
>
> -       return __alloc_pages_node_noprof(nid, gfp_mask, order);
> +       VM_BUG_ON(nid < 0 || nid >=3D MAX_NUMNODES);
> +       warn_if_node_offline(nid, gfp_mask);
> +
> +       return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
>  }
>
>  #define  alloc_pages_node(...)                 alloc_hooks(alloc_pages_n=
ode_noprof(__VA_ARGS__))
>
> --
> 2.54.0
>

