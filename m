Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6293C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A206B00D4; Mon, 20 Jul 2026 15:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B366B00D5; Mon, 20 Jul 2026 15:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D39C6B00D7; Mon, 20 Jul 2026 15:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CFC26B00D4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:58:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91BD7A02C4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:58:48 +0000 (UTC)
X-FDA: 85010217936.06.B123DC3
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id BF9214000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:58:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=osandov-com.20251104.gappssmtp.com header.s=20251104 header.b=jF4Fbkza
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784577526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcwVCKMCsgSSFOSFUSeqAhsycxUaPnb4s9hCiCZnUoQ=;
	b=figopr+yVlo0lLy0nh6jORTOwmLttnz325T1xkUSoxYUMvKFdN+aJXkJ20QQ8OPMjPpxL/
	IXW2KsKuan2fBEuHp/0I6U2r+tNoRI3qo+lXIE5vGIfouGhgyj031JWdfZZrsuWg3mlQ91
	F7UlTcpMDjui1QGOnQjOdREs4UBeqdc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=osandov-com.20251104.gappssmtp.com header.s=20251104 header.b=jF4Fbkza;
	dmarc=none;
	spf=none (imf07.hostedemail.com: domain of osandov@osandov.com has no SPF policy when checking 209.85.214.175) smtp.mailfrom=osandov@osandov.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784577526;
	b=Yq7DPN0CrOzj8LUkWsJpiC4+TbGEgzy6g4PMj8cJUCj/X8nElPh2xvuhmUEmIRyh2YJQjP
	YHddGO+l7lla5A/mr4I0/cywfMJQN9SME0ok1GQNyMwTqDDVdAuoZcrqGeSnkxPW2RVrhw
	Dcd3wwlQIgO49LcHfMEN5xDKpBHN2P4=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ceeee8c46bso18850375ad.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20251104.gappssmtp.com; s=20251104; t=1784577525; x=1785182325; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HcwVCKMCsgSSFOSFUSeqAhsycxUaPnb4s9hCiCZnUoQ=;
        b=jF4FbkzaPEKpAh/aZ+5LcosnfB9HUDNNzlgBpdGOJled6YfhaMWEYZBBoqZvMIEB43
         UfGu3IBqBr913qV8cWNUjsdRMh4b4wXXzkJvXmznp9I6Iqui1Pl1PBxRGS6hlmA+4/ww
         mqbGLPL1YaK7BCVlit7kXaOzi+Pb7CNiJHPk+3u/X5m5LPLQTSU+dCpVJtvLtQEXyr8H
         wPpvwb2+GLJ6gMAepg+gNza3l1aBph30t3hXi6S9EwFtTHzdbzaPh/ItT9h8BWGExy4r
         0HRBmrUjf6TU/JvGKEz8aFgdJsQUcx6zmrHsDACe8j7qgUeBIU4I9fwQxqD4uATX9Ufg
         z7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784577525; x=1785182325;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HcwVCKMCsgSSFOSFUSeqAhsycxUaPnb4s9hCiCZnUoQ=;
        b=aJf6dbyHoSvFef1qZr7AiA5FYmQTEvLPw7al8gEe50hU8L49zUNdKMStEUYH4NCsPB
         E8w1oP/vlmMls2yb1TS1ZQl+mloFWWpWT79NCzeD2NbOnqnDNTJNvLN1VGW0mcRnqgAC
         3iTTd29VChQcodY7k0qBGXZN3O0eWnQ1g1yvHcuCgk9gAOe0ftK6Y1IZuiRXZGNbf86I
         XD4x/rq04w+0KJC/pT6JbiqzWVachJ4TKhKoOFfq4Ry71TwIVBBvxJJe59kLtHJl/E3l
         koW1RGM4Q2QDHlOOeAKxPDN7tH8lNz6P2n+dA891S6RNiVT6Gyf5xCP9GSpdUwFIYLzE
         KxdQ==
X-Forwarded-Encrypted: i=1; AHgh+RrL7mMKB16wBwYIvYIaz3MW3LpNSXA4lXJdRCdtxVG4GdFODw7gfbob38G7W7tHamXaj1xk5kGVaQ==@kvack.org
X-Gm-Message-State: AOJu0YzjpFdy0wr03TjyncUAin7b8zb2YYr9nh4PZ6CcKYJIW8bPoUz6
	afUNmZ7sjYerHHaekujEw3cSQGvw5e+6/OFu5d+m8YU94qXgCeuFwM+aaLHhaOKw/h0=
X-Gm-Gg: AR+sD133sO/IMDFoLa/jD1ENL135u7dJsaE7I5m/rv6qJ+cFou+Lg8JzjxtqxyU6xSq
	/S8Os34oNn9B/gDLMX2VA/7LIe0VMBmIeLFtpbCOx5RUKY2w2JjHiBMknrX6X+2rz4dsIrW3+KD
	TRBlC6WR+BpzMK1aLKos1wsoNF5XFizOoyqFab0EqdtkyWySWAJ3TlUlKl1l2O5KC7a47+BWB5J
	KIUbowY2jpmcHDF4wk/v0Sf55vpUwGqwIBenkV8AQZlHaVWEa8ZK9+YjIzULWXMhqlt7Eh+JRJb
	dUqKErB5RAjgE0fK7fOkub0rri8Ky2EYFsxKTdnEWpZAhpPv3TVylGmKXJXttwX5JieMadccks9
	ERFy8yzW5V5BkdGET/AsaeizhkyisaTMAtMoEDEd4CmqtP0Dm3+N/ayuvIIb4170x1Z7SOmix7a
	f7c4q25sPdCXqZDk4m
X-Received: by 2002:a17:903:1905:b0:2c4:397:dd7a with SMTP id d9443c01a7336-2cf80472f4amr2950035ad.4.1784577525668;
        Mon, 20 Jul 2026 12:58:45 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::5ee8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1e348bsm41134232eec.25.2026.07.20.12.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:58:44 -0700 (PDT)
Date: Mon, 20 Jul 2026 12:58:42 -0700
From: Omar Sandoval <osandov@osandov.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ye Liu <liuye@kylinos.cn>, Hao Li <hao.li@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
Message-ID: <al598nIY_tliPubo@telecaster>
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
 <976e4d7b-24d6-4047-a405-e86c2feb45d3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <976e4d7b-24d6-4047-a405-e86c2feb45d3@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF9214000D
X-Rspam-User: 
X-Stat-Signature: kz8zpjgjgh7mzn6snh7sipb6t1hxztmb
X-HE-Tag: 1784577526-248471
X-HE-Meta: U2FsdGVkX18w9g7kv5WsWHn8e0YRkeuiDn1S76FuJin75jUpvdFHoN2KcVz2SYSvjDQ7aAClPffTGeFYPGeRqQXGX4Y1WLPXK9LR7N1ZtTKQb3nBRDUL6pOgeWE0dGVza+hrRsqcLk0Bdy/9jA0GfpdIRpP2CdLUEQP22oOTEd0WwDt7S5iTPRdQgAn0dFbrOZ9J5XbuIDKeAZggaZYEnhhre0xFeueH7bjKHASPnxq/6SnfLeGl7wkBxnH/EF5LCb13KvQgZtbrPxewb3cJ4UjeMhWe0plj5MaWj2Ig2c+8o6nvQ9m6dr/bxIeoxsbaijgegKwYGvhmPlcwoh6w/OcsLviSyMtO+tQ5sQNx2Jy90CV67F7+HRLeVpa671FWcBSI5fwN8OwvYBXsd3pZz0pR8vD0mgv+DtUuA1Ep9lDw5g8Xhx3wLocfJhae08BOzWnQ2XEiOALq80eBwXx/gtJ9dMFObUmu+mq90aPNaexPylk3pCEymAkvofBgfUmZmtZVU+v6zJfNrZOzTeIWgGjkTZfvuqhQOJgKHJct6XcKGAxE/jUXn3Cx8eZHY7uGLyvU/4XMvHg9WwW5cpNzWUCTIxx1+Zv1ot0SsbOF0N7oAVnH2rK6Sw0CQvl5tVPJEJlaXqgkSqh+3LlNsLClwCvv62EKH4F2WFR6ec8dv06+WLye/ETuxlEmVYoLgerELP8VEJXGTuw+veDGm0JWwmQCKFCKrlZWQgyDcQn1UwZUHjDI3OZoUsnPvzITozZFO4g3XPlpMb6pKP7t/KpwNYQzJmzozWhUAKj8gqSRmVa0PVbISsgGY+ms185s1T4I9USazZxUzRDp3EY6H289/2/90/a3TMqJiUm529f9AhHdR9oXMtyAd6+nHpVqHPFDX9oyfgi9/iG8tf5mAxKfYjuUSl3WyE+nQiGgrT4ev3cobWq1RkUb1Tk9no3tvc0llQtqDtfmDHq6Zke1hIY
 iao7lEz1
 XHBhzJIFTR2OFuuUC0D11FKb9fsc4tYA0gu7K98M8q8BcUXpqEG3kA1m13BUYALl/k5wbMPnOY4iR2gv9cR+GAkS4vZ/p3CSM1E8BG8ddn2KTEgjOVSrxBQjGYi3dxHBCgBG3YZ9u7lNTB4hLHcUg3VQuBLoXxRiGBMEu/6H5BKoKTg2/tJU79VRv27z19H88nMFTvRCIiTm3NAF2qoj4NaYeY4sV/q/amjYhWCBwPFCzpM6g4+4acQz88WASfqBI+RWhBqlA9UpakWwE3wNt8dqFmd5yu1bVgY4VToyWLY2+S9lH0MJ6rk/LryKgZGDRnxoV48eQN8BI/CcogfOMRdB2eC+l3D3+4kEphaM0WA5MN3zFJ7akUT0zd6OvGYGi1CkOfwlNQ43lyqog3wHNxmVAwM40uwRFeNz3pd3WIJd9ZtCGKKvBRkV90GUZXxVKVOGJI/pKHRVHRCT+sazLQTBwgKYceQqxH4wK6DNoggaUVAcrVZcteR0QH69ob3bkDU1/LUxch6Nqfslix03UDjIAkQATgMhtDaHN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 12:00:29PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/15/26 12:10, Vlastimil Babka (SUSE) wrote:
> > In preparation for changes to the structure, abstract access to the
> > objcg field with a slab_obj_ext_objcgp() function.
> > Rename the field to _objcg to make an unexpected direct access a compile
> > error.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Hm sashiko finds [1] that this is breaks tools/mm/show_page_info.py
> 
> But I think it was already buggy. get_memcg_info() is supposed to return
> memcg info for a page but in case of MEMCG_DATA_OBJEXTS there's no such info
> for the whole page, there is only for individual slab objects and it doesn't
> know which object so it effectively gets the first one. I think it should
> just stop handling MEMCG_DATA_OBJEXTS, but that's a fix that should be sent
> unrelated to this series.
> 
> There's also tools/cgroup/memcg_slabinfo.py and that I think has been
> already broken with memalloc profiling as it assuems slab.memcg_data is
> still a raw struct obj_cgroup * and not struct slabobj_ext.
> 
> I think it will be easier to fix it at once to handle the layout after this
> series than trying to fix it first to handle the pre-series layout and then
> update it with every relevant change.
> 
> [1]
> https://sashiko.dev/#/patchset/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org?part=5

FWIW, if these scripts were in the drgn repo with test cases, these
breakages would be caught by our CI and someone (usually me) would fix
them up promptly :)

