Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C29EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05A9E6B00F2; Tue, 30 Jun 2026 08:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0320E6B00F4; Tue, 30 Jun 2026 08:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1606B00F5; Tue, 30 Jun 2026 08:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C167B6B00F2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:01:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E497C2569
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:01:55 +0000 (UTC)
X-FDA: 84936440190.27.70A5D3F
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 05A8A4000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:01:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d/HMIBfc";
	spf=pass (imf27.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782820913;
	b=dt3qTm3b5U4XN8unnyokj0NJP+2jWxjJF9ydDv+wZe7vPuJ2Qef9P3NeVeg7gVWOpEWR6V
	j2dRhRA1e8lnWT5o4CYsd1bIbIPpY5MgKCU40NDLRus5YUSdh9vGLdjoEwP3UdO5fp3oNU
	wCd+D9dldv+26reQOW6zdVJ5Rfnp658=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782820913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nPODt4gTf0vvhWgCFfGUzQ9veN5BNMQcI7/OEbq+Vo=;
	b=ked50Yf5RJPx4oyXk//IBGRcSYtSRcCHRCJhHtBYD8H2ETgN+de8U934de29RoC93lQhex
	knW+oAPC46WDFDPMpuMR3ZeawXO4KwLchsq649N4E+/BokUmR8TIxwx93n3rn+4E3pdeO9
	xdnlWs7/wqf1yd0zJOWKLVLC5fz6Di8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d/HMIBfc";
	spf=pass (imf27.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782820910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5nPODt4gTf0vvhWgCFfGUzQ9veN5BNMQcI7/OEbq+Vo=;
	b=d/HMIBfckQ/xUy/p4Ui9WnefAf9EcK14IoRJ8lJkSyf6CftDv4WIt1LK+uKzpR/oz1uBao
	kSpCOLzYNW3L4+AwuJoC/Ekt3JmfEldNFDXWB5bsGBHsnQW3AvQmlMyPpK21b0BwlosqNM
	IkeTyZvmHHehLNn/frvAmWaWqlZzOfM=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 12:01:37 +0000
Message-Id: <DJMD9HIQHO0T.JBREVOE4VDEU@linux.dev>
To: "Hao Ge" <hao.ge@linux.dev>, "Brendan Jackman" <jackmanb@google.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Zi Yan" <ziy@nvidia.com>, "Muchun Song" <muchun.song@linux.dev>, "David
 Hildenbrand" <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Matthew Brost"
 <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Byungchul Park" <byungchul@sk.com>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH v3 15/16] mm: replace __GFP_NO_CODETAG with
 ALLOC_NO_CODETAG
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-15-57bef0eadbc2@google.com>
 <b4916118-3537-4e19-8bc8-1d103dd0d225@linux.dev>
In-Reply-To: <b4916118-3537-4e19-8bc8-1d103dd0d225@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7o5no7wrgzdxygckhqr9nwexw3h4jpn1
X-Rspam-User: 
X-Rspamd-Queue-Id: 05A8A4000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1782820912-494882
X-HE-Meta: U2FsdGVkX1/ONDAOECWoS/QaMoe9NhianyrF5u04X/mLgPovVFb1Qk3uCJNWCQ6BjBriLWlv5iQo+NqOyWyIWIRITDCPw91lbiKgMr1m7hd0yyAEZgUt/2KAblJqUVOyY4Etg8gO24vgaA+TbMCJsUPIHRdMN9SlmQhEw/UTk408RgThMHHU0xayb7y2/L3hV1VtKVb7CoITykK+Td88+q/3G13K2J44puI88IxVgt0QQePMZKitZoIgzS5K86p5OHPvJmJklE8owqPxYCdPM5SMKjAfKlY9Sl27qmMm4BFtXahon4TEMe0bj7J8UkAFdR1OFwKlxekTWdWEynGbmlI5iaVfwJOGUBti1IsW0zAGtCRNHEVSoHQmdapdeA/iHo0/TzddgMMDBC9O7HQzFoCupSDLLt2VI2V57b19uTslgkdM5QmJir7YzIhix7jEk61Yq6irwjklkKPIjeQ/od/Jqk4I96fGmRTS7Dnj8fh6Q2jB18k1F94+EsoYMLw5fnKSJf35wZpMpdJcLxpg4yA0AGtNBoxd7JyeAtHfp6nI5EB0x2nn2FWv86/SO7BC0shpWGCWXymdlrZnrPiHXgf7opKsgPrPGkbmEKMMk+qeVOKcEAUoBhSTeNW8GKfVWpktSM44Guyp6xqLp85uD+WqYM/iXlRSq4VAO9rkIvyqK+qknsTLVdR8xr+M566Y09Rc0oR04918jAiS55QGCzXzaYqzDzhK0CupkyrxJQ/7b72MVecw/sRzqrioHWmxTVhFthbXPpis7kNPKcD/lyEYMYZVJOYZyH2YHwwLO4YvFcQn+IlqOqInJohzfHYjgOch4xRuw+f4rnDhVlKPva3X8WXxfheXhANJhDV/50osIqoJiz3RFThXVjzmKrpAJc0OjgVX+zR0l4WqhpE8og+DbxsRW5mA3KK/AOLBkCyL1rFQs+iXzJFVC9uerGQCCKvE7HxrjjorZgKERJL
 TGrd1ogO
 gw98skxP4dYgnyMOOEmZCzGe789oRQGdNYpgDNH9Uid4uTuOwxZxBm6c/uvIvKwrZT3qiKCrD9OYdW0XyMkgu8S4FO8lZYZhdWzWdOw5GLdpbQvwL0rFFqBySvOs8aXq3AtC7BEidNeevg53IE5O6mKqVvS0tuI0EbNVzoWfO309c9u3c8xHB5E3wEAPCTOAwvZytLbaGjfod8Fb35I/KhYwRvF3fENwcG4gsJqfbf5vwYb6wu/LyPa4E7BpB8eHT6dSl99H0CLI5EJYZQr8RaN2gt7sgUkCzPZkr0dWrmB0mR0/OkWxd1KuaePbNwf0+nWTdfdkR2RWVWHaug7QEXikI9WkG5kCebBZhDBcRSNE7q4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 30, 2026 at 1:55 AM UTC, Hao Ge wrote:
>> +/*
>> + * Skip early PFN recording for a page allocation.  Used by
>> + * __alloc_tag_add_early_pfn() to avoid recursion when allocating pages=
 for the
>> + * early PFN tracking list itself.
>> + *
>> + * Codetags of the pages allocated with __GFP_NO_CODETAG should be
>> + * cleared (via clear_page_tag_ref()) before freeing the pages to preve=
nt
>> + * alloc_tag_sub_check() from triggering a warning.
>> + */
>
>
> I originally wrote this lengthy comment because the logic lives inside=20
> alloc_tag.c.
>
> I wanted to document all the context to avoid confusion when revisiting=
=20
> this code later on.
>
> We've since replaced __GFP_NO_CODETAG with ALLOC_NO_CODETAG, a generic=20
> alloc_flags bit defined in page_alloc.h.
>
> The original long comment is no longer accurate:
>
> Given that, I suggest updating it to the following:
>
> /*
>
>  =C2=A0* Avoid alloc_tag recursion for internal allocations.
>
>  =C2=A0* Callers must clear_page_tag_ref() before
>  =C2=A0* freeing to avoid warnings from alloc_tag_sub_check().
>
>  =C2=A0*/

Thanks for the context, pasting this in for v4!

