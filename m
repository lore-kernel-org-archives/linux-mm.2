Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7799DCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528F36B0088; Tue, 23 Jun 2026 05:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9B36B008A; Tue, 23 Jun 2026 05:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A99B6B0093; Tue, 23 Jun 2026 05:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EEA316B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:31:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BAE01A045A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:31:41 +0000 (UTC)
X-FDA: 84910660002.22.BD53AF9
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf09.hostedemail.com (Postfix) with ESMTP id 48BC3140004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:31:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T6lIdTHi;
	spf=pass (imf09.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782207099;
	b=1+h89NQpL1y8ImgKO+M/KF+inPbzhwcyaq9Dyn2So8mQ8eCzW2KFrRDJpoBx/31xImZrqe
	xtzvY5S2NgeWO2GYRRyTqgYH/o6KPQ3a5jk96dycUCs45C53HhXHIukXsU57e519X+4KJ9
	dwzvLg50P++8AzQoiTBWAXrk8Cbgtz4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782207099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlYKkmH2+/Rx3UAOeXIoxhHEVrRwDnGqfKhquFOHazM=;
	b=dQ0/W30SSIbI71G+z2fBCtg3gm6C0WmpF+eL4/SV7hYZoJXT4ruuf/JIRcUOvteakUx7kZ
	W1OBVb/lKIkn2ug2Cfb4T+TsaqAPah8qRLRJv8naX8GfOXfR5hUpVXhLQC+FuAF9TSA0HW
	QnNvOrgZY8tJ5V96Q+plOOfCm4psGQs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T6lIdTHi;
	spf=pass (imf09.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782207096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WlYKkmH2+/Rx3UAOeXIoxhHEVrRwDnGqfKhquFOHazM=;
	b=T6lIdTHi0Rw450pvnrbxiKrURLhGKrhbo2SKEUGzxFi6FggL0IOWqc7iH6b1dGba6B5SJA
	h1lU6z/OiyYWXXR41iC4yOa1e88mpxvbAL57BHsUNY2aoji2cwUzP9N0oB5UwF+fcyZk7R
	c2p1zDGq3NtqlJLuyHGvSNAfZCQczeM=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 23 Jun 2026 09:31:30 +0000
Message-Id: <DJGBOQRQD5N4.1AH0U7LYOAEQK@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>, "Michal
 Hocko" <mhocko@suse.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Alistair Popple" <apopple@nvidia.com>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Suren Baghdasaryan" <surenb@google.com>
Subject: Re: [PATCH v2 13/13] mm: remove __GFP_NO_CODETAG
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Hao Ge" <hao.ge@linux.dev>, "Brendan Jackman" <jackmanb@google.com>,
 "Vlastimil Babka" <vbabka@kernel.org>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-13-31f31367d420@google.com>
 <6e312b15-d2b5-4137-aa3f-720ec214c7ab@linux.dev>
In-Reply-To: <6e312b15-d2b5-4137-aa3f-720ec214c7ab@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 48BC3140004
X-Stat-Signature: q6mndgb1chuowtfd77p1xqfwhp9pic4s
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782207099-310980
X-HE-Meta: U2FsdGVkX1/QB9732QJb2Q9BpAWqw+fWwjyFiPBe6RQCYWmhAGRtkQxTeuShufbbu5GzrFZ/bMtigOrru+063GujfHuhTpqYdwnhCS2LfMA9IS+TNal9byhkqFVyzuvPQcSX4bAGaBvt4MDI56NA+xwkzTtH2jK2dlnHjv5BcLUX310+fdi8Z6ZYMmI+Cvi7Aahk4on9JpY+QOOe+Frh4gTqI9HLdFlboDLdP1x8Idc25qSaKHtS47sENEuD2DPMBN/RytLsagoNQo1rGt6Id3BDAOXuG7Dpo6Fg7gqdN1kI0oq220j6ANxbDkHiMkRL8Hj4DkLPssDDTdBLgqoGLg9YJwukKh8lMdhWIrIwkhRSZ5NSwYmm6QJhqfZK5U5L/rvbdQzm8phtJIC18CaLAGoUfY2IDISqeWJVHZXbPvDAUIJXYRhlndrY/ilUSoUCzBLr6hyVCkh++SRenpxYD5/lYc2kZtOnGH5nBiJXFQR1MOoWZkAvnok6oDKSiFnCOCNAT8MVqVy9t6nJ5UWWNRe1m5saGeOTjbqMIeqJGi2pc+6UpCrrVbM59qIFHq0XgdJbqydr3Ddo4Dig8uFGVBeTrGvoiuCNrtxHxncx+on/4se1oM+rXm4d7u3ZerBrHrOWEJ8qgfSVQ5ffH2n3WeruyrAb9jM4dbKHk0IpTyVOpobDiW8HH9IBEfoeJ/EAeiaCdz8UuXRf+anXWXJoAR/KX7oVpBbr7cwKVzMz/sdV7YyAuRqkSgWyTIfRBHmW9jTq+9fmI5Ri5ZRH6BOPHUfmJsy1/DBTxMiP5+hvCdY5+i33I3Oq6w8utwdhp04Tm51BwQS2rQVYAJ2YlT2XaTFfiIYqw2KSMyYAqyzSuQ3E32VDKEEK+kZSsAUrBsOp2RnyEMMsSIDdKSs/2C90VsFMpTO9negPTRdA55xaps+3AN/XRKe5TgTHFiy1XA3CwABEcX0uOb6d7PQK5+o
 V+2Jl2p3
 +2uU2dx2ioQdFmdExo/0YfOGiHjU4h7ebI3a9oJhAqQtUhgu3yHZKcEPhiY5LuLRu3uFedXYXSTKBoWzBop2ZIIKHC303IO+fY6S0rMStdaDFkcNL5ENo/2mz0MRn5p8TYKMjYVDwo5mRcgC0r3CxYxgrAtZxrtP50OT1zHonSRoILGzkfL3uvW5gx0HjO3f423els3oX+HyzKrapX3//WraFIrkw/+1odevYsx9qcD4bfrsTVsk4a9/dvtHVb2FqqkKzUWVhVFdtPiEzYSkoq9vqk7t629M9ezd50FVQDus8EW6cUrcbf/7QhTvTAXjJInZuUkG9kxXZ3Hxc6ijGntUW++RgN2uVZO12ui47x07/H70h2zrrI/5keP6t7GoPsLVXTfT4ImoYCmSvgI9I3AEqaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 23, 2026 at 7:56 AM UTC, Hao Ge wrote:
> Hi Brendan
>
>
> On 2026/6/22 18:01, Brendan Jackman wrote:
>> Now that alloc_pages has an entrypoint that allows passing alloc_flags,
>> we can take advantage of this to start removing GFP flags that are only
>> used for mm-internal stuff.
>>
>> This requires also plumbing the alloc_flags into some more of the
>> allocator code, in particular __alloc_pages[_noprof]() gets an
>> alloc_flags arg to go along with its callees, and we now need to pass
>> those flags deeper into the allocator so they can reach the alloc_tag
>> code.
>>
>> To try and keep the new ALLOC_NO_CODETAG's scope nice and narrow, don't
>> define it in mm/internal.h, instead just define a "reserved bit" and
>> then use that in places that don't care about what it means.
>>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
>
> Nit: The title says "remove __GFP_NO_CODETAG" but the flag isn't really=
=20
> removed =E2=80=94 it's migrated from gfp_t to alloc_flags as
>
> ALLOC_NO_CODETAG. Something like "mm: replace __GFP_NO_CODETAG with an=20
> alloc_flag" would be more accurate.

Good point, will reword this.

> Additionally, as Lorenzo pointed out in another thread, you will likely=
=20
> need to rebase this series later.
>
> I noticed Vlastimil has already landed the slab changes removing=20
> __GFP_NO_OBJ_EXT into mainline:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?=
id=3D335c347686e76df9d2c7d7f61b5ea627a4c5cb4c
>
> For v3, it might make sense to fold in Vlastimil's patch so the full=20
> removal of __GFP_NO_OBJ_EXT can be completed end-to-end
>
> https://lore.kernel.org/all/20260609-slab_alloc_flags-v1-15-2bf4a4b9b526@=
kernel.org/

Ack, thanks for the links and review!

