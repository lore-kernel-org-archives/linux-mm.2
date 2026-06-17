Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93EF2CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6226B008C; Wed, 17 Jun 2026 13:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E336B0092; Wed, 17 Jun 2026 13:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494456B0093; Wed, 17 Jun 2026 13:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 125F86B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:14:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CFD41A0562
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:14:42 +0000 (UTC)
X-FDA: 84890054004.12.EA65131
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41B84140005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:14:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=URPUI+Kx;
	spf=pass (imf09.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781716480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5SZXXiFJ8ueBXhlsGQFJZi5a2AW4j8ADP8QWnx4K3E=;
	b=r2RdKJvnJFvYfXVg/83fEUktx4R13ECzPbFw/30Eip+DIwlbyXpWG5+IS6yS1CVA8AM69x
	HSkCRiSlK/WtnvDSx88oW72q8Ba/m7Zrqf6BxeewkUakzUAlihV6GlkuvMtT2EYPyD8JNh
	qQm+eZSQ0CDZVEhUtFfzYlREyGBvBbM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=URPUI+Kx;
	spf=pass (imf09.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781716480;
	b=ZokPssK1tx2ttCiN68Gz/cyKM2o48AmfQcRscmMUhik88ueQ2ltGKR9TtHSSVaCSJfUpzw
	Av85xbzRpggIiUYiUxkiOGeSgJdsHpjV+soWUixJNK2xCpNXZOCA5+Y1Q/LfIYd7pGOaXu
	3Aw0rTeFSuLjjzOlJ+zKeVKE9a68Vts=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781716477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y5SZXXiFJ8ueBXhlsGQFJZi5a2AW4j8ADP8QWnx4K3E=;
	b=URPUI+KxX5k2L3dXRV6rad5ag+FPQQaxDxIUK7ydK6ENuc2D6h+cIasadvkr9vZSYWnBoB
	gzeq9d5VdvLRYjMeOEE4YFmBzQPOgS1Wb2XFmG/AhqYDEwxEpT43tx40GKKgRY54XN7e+t
	WtLX3QXOtLqSfo09anHRSIUsBplrdXs=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jun 2026 17:14:23 +0000
Message-Id: <DJBHRVM65A11.1OL2M9MXN56H@linux.dev>
Cc: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Michal Hocko" <mhocko@suse.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Alexei Starovoitov" <ast@kernel.org>,
 "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, "Hao Ge" <hao.ge@linux.dev>
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
 <2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org>
 <CAJuCfpG48TmvaiaRvnL-NXKU6nn55D3bks2DgzAc0URsZhAxqA@mail.gmail.com>
In-Reply-To: <CAJuCfpG48TmvaiaRvnL-NXKU6nn55D3bks2DgzAc0URsZhAxqA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 41B84140005
X-Stat-Signature: noie9sft6b4cwwc4g6ddt4fyuoan19iq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781716480-823140
X-HE-Meta: U2FsdGVkX18dOZntgOZgEZOLlyO7qxVzwg3aClVXd1J1boEdpGdsmFUXKZW/ryO2HgMTREeB8Xadh2iSAUcw+IilYT3312Jp2JJyWZTPPsxygwql9g9YoT9sjXULfkcqYa380XIMsUoFmFXQfIt/bM/oUn1aeoAkt25d0KK3BdWjAXCw1XNKBiYJU7cr2Myor+F7GI4D3jWY9v/PJJY/LY6aorZVva7piomJfrSSxTxyDfbhKGwxE1uRrv/v9Z20qwSdx5wNPJ7phkrxjfApY1fNQ/85jGM40DBNAF6VdRZzFvLdDZwTM6txdp8sIwqlJwpRBjQ2KYJ8PzGst7DSnMTXV5LbgvaaCqFScbGcvNZFBzwtJTpWqrDwbXvjSYmZzJHlxJlreeCrs9s40fW+Dc/IHl40DYB5b1OD3S9D5kckymLHkKOxVVwTUX3RGMkgofUbfaAxGPStNC92m+OExnUFj1+Iy/jkEvWhYaQ5CBK7KndygSG6iNgCjrcpZN2XNvYvIZnZLpBvfNgnjbRC3gj/CALZ1xutzDv3tRWbEhseNKzOBdIISFitE3mGNDIa5G7Bt200dresPPV5mckAlFO+4MX1mvRwncKXzl6Kg0ni0t+JNEJF8sGJkio5pjPu10ma70TDnhAMCWNRdq9NHU1reBqQqYba3cmg5fCnTpfzu7tkcO9sCLXN8FFBYC6IdB1fvJYwXOjnbgTEPtqdYSRM6RikZHy5kSFfAG73tAnpSaF9pOblLyMS9iBNmkX3jI6Par1RO7JP9g/usKy27PaG3KajHM5Y7G9juopdFBkaxvGJoRHS/vv3CYiOc1QDhlO8p1bXu2+2lK5sWEQJMKVBP3bNgDfma7SO300WHxYq5PLBfZKA9NCxhwa5k2036RoKCpaqDv0edcrM/oh9SVPJg296t84ZHUyx5f3aaGt4PUXfQaszfWg+e+2vEieSUvKk3RfP7Smriubr2XK
 fSZp3isi
 0FUc1tvvhCv0toiH28d67CgOSPKwXrSWa6SwgL4/MGAEEBfrbkGURFkffxV08jEgmZLVpZXCebmayYeDNwy49D4boEJwQsGOB3E1s3Dh4IVSSRjQo/Pag4QV8uGYa1CKane8p1KUYEyjDE+OrQzXoFthxWpqesx4tde2fdOys+I8AJjlrS2wjSLwJt2T4DFlqmvK39HVPE3LeHDC5Dw/fkglkpXuqpyNv2eLM20XegugFydu53AWS2YgEpQlxk5ULYlLb6NBa6Eo/4Eqb/mfvlZb2SBWNE+3y7I0T9kvc/SDOqHUOWebGobHlOeV1jFhh6eQGHgwBAZrCThUERHO19oskkXvs4dCVqbrdgzm/uNBcoqj65lUSsAsIaP92bx9n5ml3FQv1e9TtQEEQnuF5y6a7gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 17, 2026 at 4:49 PM UTC, Suren Baghdasaryan wrote:
> On Wed, Jun 17, 2026 at 9:39=E2=80=AFAM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>>
>> +Cc Alexei
>>
>> On 6/17/26 17:29, Brendan Jackman wrote:
>> > Currently the core allocator code is controlled by ALLOC_NOLOCK, but t=
he
>>
>> It's not, it's ALLOC_TRYLOCK! Thanks for proving that we need to rename =
it
>> to ALLOC_NOLOCK:
>>
>> https://lore.kernel.org/all/DJ9QPTO2WXNB.10E88ZHWRDHB0@gmail.com/
>>
>> So you just won the job to do the rename :) I think it should be done be=
fore
>> this patch, so that the new usages and other _trylock names introduced h=
ere
>> can be done as _nolock outright.

Ack. I'll aim to send that tomorrow once Sashiko has caught up.

>> > main entry point function is significantly different from the normal
>> > __alloc_frozen_pages_nolock(), this is tiring when reading the code.
>> >
>> > Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
>> > an alloc_flags argument to __alloc_frozen_pages_nolock() (which is onl=
y
>> > exposed to mm/) and then turn the nolock variant into a thin wrapper
>> > that just sets that flag (as well as handling NUMA_NO_NODE, similar to
>> > how some of the wrappers in gfp.h do).
>> >
>> > Rationale that this doesn't change anything:
>> >
>> > 1. Simple bits: A bunch of the nolock-specific handling is just moved =
to
>> >    the new alloc_order_allowed(), alloc_trylock_allowed() and
>> >    gfp_trylock.
>> >
>> > 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>> >    previously in the nolock variant:
>> >
>> >    a. Application of gfp_allowed_mask; this only affects early boot, a=
nd
>> >       only flags that affect the slowpath get changed here.
>> >
>> >    b. Application of current_gfp_context() - also only affects the
>> >       slowpath
>> >
>> > 3. The slowpath itself: this is now just explicitly skipped under
>> >    !ALLOC_TRYLOCK.
>>
>> I'll have to ponder it more closely.
>>
>> > Ulterior motive: adding an alloc_flags arg to the allocator's
>> > mm-internal entrypoint can later be used to do more allocation
>> > customisation without needing to create new GFP flags.
>>
>> Ack.
>
> I think this change might also help us in removing __GFP_NO_CODETAG

Nice, this actually looks trivial? I can probably just tack it onto the
v2 for this patch/series.

> introduced in [1] and being the only user of __GFP_NO_OBJ_EXT once
> Vlastimil's patchset removing other __GFP_NO_OBJ_EXT users lands.
> CC'ing Hao as he is brainstorming ways to remove __GFP_NO_CODETAG, and
> this might be the answer.
>>
>> Besides the need to ponder unintended effects, mostly LGTM. Just not a f=
an
>> of the hardcoded '0' passed at various places. In the slab variant of th=
is
>> (the thread I've linked above) I went with SLAB_ALLOC_DEFAULT, so you ca=
n do
>> e.g. ALLOC_DEFAULT here?

Yup ALLOC_DEFAULT sounds fine to me.

Thanks for the reviews as always.

