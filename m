Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95AA1CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A57C6B0088; Thu, 15 Oct 2026 09:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D196B008A; Thu, 15 Oct 2026 09:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB006B008C; Thu, 15 Oct 2026 09:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB6086B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:30:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F82D1209ED
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:30:20 +0000 (UTC)
X-FDA: 85324944600.09.3CB548E
Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	by imf03.hostedemail.com (Postfix) with ESMTP id E4B8420013
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:30:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HLlbXrol;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792071017;
	b=o5+sWj5cvziSdsBLg3plvJAt+ppQS7mDBd7mSd18vLuFewnbaF2963NYG5Vje+HSKTa3vL
	LziQVfovhIUSaZNSAXPigcNbW9sQY/KJNvlYoZgktSkNFyk2udpaMU2chMlQGjaDs5g3eW
	jw1b98t685FdbqqSniXWRWG+D4OTsN4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HLlbXrol;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792071017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ueY7yYWbFuhVSwHsIiCD9Lxfvsz2FCfLlGpqo+l61lE=;
	b=dYRxccpmNjvqhp9Fh9uEDjbF0u7Abgz6u2hnn0RIVdUZPZd+pvu5GqfgmDRMZJQvn6IlYe
	4nbbn3J3X6PBWwAY8Uek/VPgeFfs06tUZai/w2PNQ0oQwlzUdJCWdvIU+fwCc4OG0q6gdR
	p/8lk5BQ1MZN9OSIDlo5oLKhWYNl6XY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IoGIAHnaQYST5KBMu9mjyBm9EH/F3O3WcIGndcQBSbg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792071012; v=1; x=1792675812;
 b=HLlbXrolhzSGq6VTDnJEVL7uridJQRkT8icRjHU8BTGs/g2SEmFCg7MSPl5jdNBv7+nG6w9G
 n41zbw9IcEUlzQ7uYs9+iCfBtyPONW6UeRaStBvlyxk3fINtt/UKo1OS5mFjlNJyR0GufXTqNmW
 6SjO9wBXwSo7Dwwee+nkkMk0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f4361a04069a03d7;
	Thu, 15 Oct 2026 13:30:10 +0000
X-Mizu-Trace-ID: f4361a04069a03d7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units cheaper
Date: Thu, 15 Oct 2026 21:29:37 +0800
Message-Id: <25784AE4-EE4B-4B15-A436-17F98354C10A@linux.dev>
References: <84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
In-Reply-To: <84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: iPhone Mail (24A446)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4B8420013
X-Rspam-User: 
X-Stat-Signature: wep7krpnq9645d437ctu35oke88o3ift
X-HE-Tag: 1792071016-735696
X-HE-Meta: U2FsdGVkX1+rxdy+ZfTd6Rc0Ny/VmjTxrxCPfeFj5iTtD5F0T/iiMgJeQp/1E8uKTkERQzM4gG9SnuTn1x0kXxAlC+3znz4iaZCoKxQEonxjU+6CstuQXJfhq5+hdXwYrR3DRaVUgXNolAmymzEQ4JxWZhefvw7vMi/yCcbQgE9XjL13N6/sj2Mb3oDflOKS7em/shwfbddhEmut1jaxz38SEJqhh9tqnd97LCFFPTQ2JgKKBkjrOBRmUELxPV/gVNAaCQtoEEpHMMRhYQ2rIEM6WVCN4DOlEMez0/XXz2bx9SkN8ghshsMpUD1a/058g+lNcz8kqZjDBpqjJttfXU1QyK7KDX7RLYwvvt/FK//pT9+UJuNsi+UPm9bGWku9IU/8mEfVb/wMHHPRHAzi18uuw7m0SOBh33XKVpDJj+qvGPBAUh0a2dZGRkZ5gnxh29MOacwBN3cC1aOoHHvGpqFDoe/okuD6Ao6Fqg30a9MsuagCcsMQD8dsXBrR70yHWQ2lzT+eoCa/G/9ffxeM2TeOC/GcoVoBT7VtpVkIjZONSsW1vcfOpiOk1m1rBOY2GDr1/L39oARzwHQJje162Zj+wBe54nlboE3GmM9eJVhdbVvzdRbCZ8TDgW7lBbLtOcMfYXXlGjHkCpEk8LxpqlzJyJVkgGm9ABxow/odXlD7yTi6oELezibaw/DzO7ToDCDkkl1cTorhsXMrT7LlmgVkA4rwSZMGya+nT1bK5wXe7nFWmLBBieAXOsMZ6Xgigh0jDR3W7P9+Rzosz/uNnK4953h3b5wJ+o7zIKtvlB+FgrkncGX9h2xLc4lH2Mpmfbxv+goj/tk82NrCJoxR3gceirToRDtiE968y5soi1X24Z+ek1fMYgJP8oxaZetmw8yP+RtutNNSvc+EZz5EcgZCcAWZvOZf4bBoNWWXi66gS3HbUB/IjPP4aXqrOHG0xY84gejc1mlwUdJl1YM
 tk20ryxV
 9fvZrzthx5Y1qDIvF06CYfjav4IcmSZFztQ8zcVBnAhLhx+Fj+syD4t2GfnJSGsjQcYkvw86yyDGiFapUzy8tpDzOynjC/FTWgb8tB13Wb2BBL5qOyjjPNP/MvM70OIRh3lRcBe9KPwTdTh8IZ5UrdHAJ3yxny1s0y7LGmmck46+fM4RMTmi/HZMdYsBcwJe6VBQkNJQpmhm0gtjxifk1v+4HKSxdihrJ1zMX25lpEp80ZFb7LWVP+SZ1T21Ji0wMw/UJsJiYvpt7iVioD/Ie0dBjp9PCFjFA8Ru5SbxU4HIowQBFgWk9mj/7NPca1bcwi9V99c1fUwvYjxylQmORQHjKyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 15, 2026, at 19:42, Konstantin Khorenko <khorenko@virtuozzo.com> wr=
ote:
>=20
> =EF=BB=BFOn 10/14/26 22:50, Andrew Morton wrote:
>>> On Wed, 14 Oct 2026 16:54:36 +0200 Konstantin Khorenko <khorenko@virtuoz=
zo.com> wrote:
>>>=20
>>> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
>>> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not it=

>>> ever charges an object to those shrinkers. Every superblock registers
>>> such a shrinker, so the cost is
>>>=20
>>>  memory cgroups x NUMA nodes x shrinker_nr_max / 64 x 1 KiB
>>>=20
>>> because the unit is 520 bytes and comes from kmalloc-1k.
>>=20
>> So we could almost halve this just by using a dedicated kmem_cache?
>=20
> Yeap, a dedicated cache gets approximately the same cost per shrinker id.
> On a 48-CPU box SLUB puts 31 units in an order-2 slab, about 528 bytes eac=
h:
>=20
>                                      ids/unit  bytes/unit  bytes/id
>    today, kmalloc-1k                    64        1024        16
>    patch 1, kmalloc-512                 63         512       ~8.1
>    dedicated cache                      64        ~528       ~8.3
>    dedicated cache, HWCACHE_ALIGN       64         576        9
>=20
> So the two are ~equal on memory, and the choice is about the code.
>=20
> I went with 63 ids per unit because the unit then simply fills the
> kmalloc slot it already comes from.
>=20
> The price is an odd SHRINKER_UNIT_BITS and roundup() instead of round_up()=
,
> plus the static_assert.
>=20
> If you prefer the cache, I'm happy to redo patch 1 that way.
> Patch 2 does not care about the unit size.

Please use a dedicated cache, more straightforward for me. But also give som=
e time to maintainers for reviewing the patch 2 before your update.

Thanks.

>=20
> --
> Best regards,
> Konstantin
>=20

