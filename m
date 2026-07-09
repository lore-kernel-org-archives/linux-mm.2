Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E65BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F466B0095; Thu,  9 Jul 2026 03:49:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F171C6B0098; Thu,  9 Jul 2026 03:49:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2FA36B009D; Thu,  9 Jul 2026 03:49:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C272F6B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:49:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D3241C8624
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:49:11 +0000 (UTC)
X-FDA: 84968462502.07.DC69F5F
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5F87520003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:49:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QxdDwnTR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783583349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bz0ZIC6honVFONNe2kkGW+tQ+zqDAmMEe2v+OkKeqyU=;
	b=w8gtVTCy/YWixv5su4nBsAr8ILG2MlkpYHYWzaZ1yoTYMpRZjE9Jxp83VQMboGIvKBRWfL
	Omojs4PUVn3aa9mYACeZMknzEo7OpNKXz2OZ+MO/f5ciEs3qhMoR3ey/+/Jmjhp2/0xo6/
	W6O45MOX97KV8atLrOX6csEOroiyJdk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QxdDwnTR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783583349;
	b=oUtfwFipuaogpwKV4/R0BXW6LoRDAqKuHBHFbmwhqOM0kNbJv59uE/VrLibEYzwrBx1uSS
	Z1oB8DNX0n7qPHLxV/Qc5dJdr8ntsP7+YusLg2i36oNtuBislZKvXXMGvDSU2rLeI/AGkm
	dsrrILNud6tcAp/6P5X50iu/oDkIkx4=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783583347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bz0ZIC6honVFONNe2kkGW+tQ+zqDAmMEe2v+OkKeqyU=;
	b=QxdDwnTRWm20VGliIkKhSn+dBliUnrpDgqk1fVsnpLGkywZOxT18NohgKhFG+VAe81Oqpb
	vZaKdUdBDjHYwNPbzP5z3Pr0BIIxbex1rg7tb6d3ea96i0kT0gM7H/us5Hnt3JI8etR/pk
	s6kFktWl8bcGGK9Saz4/zUix/SFzyk0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 0/3] mm: split a couple of headers from internal.h
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ak9MO-FWjkgr22KL@kernel.org>
Date: Thu, 9 Jul 2026 15:48:19 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Alexander Graf <graf@amazon.com>,
 Alexander Potapenko <glider@google.com>,
 Brendan Jackman <jackmanb@google.com>,
 Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>,
 Dmitry Vyukov <dvyukov@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Marco Elver <elver@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Oscar Salvador <osalvador@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>,
 kasan-dev@googlegroups.com,
 kexec@lists.infradead.org,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B53B1031-B655-4526-B1AC-952BE39D96D3@linux.dev>
References: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
 <ak9MO-FWjkgr22KL@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ik91mtssnjxm1encsyk3q5kts563ap78
X-Rspamd-Queue-Id: 5F87520003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783583349-445465
X-HE-Meta: U2FsdGVkX1+9YkblEB8p9Icqt3BLW2INZsniBvoGiyaVLHKH8CkcVLrDhnidz/X+JekM1R4rY/tr0phJCJ5QZtMvZA2JYOuiDr3Etq6HFdRMq55HBR/6Y/gdm5nDOPkvgwT430tzU8OFcmBAERwCopQHLTr+J8i/v+sJcrHIJ6Iv829qBRJG48XxYmGsNfrySYt+n5u0pSESNfKln/cHyoT4TEQ7AePxpFvquZwzSP7CZ3neP3CcqJvBOtXmompzZIJOK9b0eyrJea2KOz8SVKqAAx2kwYVqtkLZAjeN9+SeQNiu/gjON6JDNLMxoIt1tJyRlxPayod/CGjRUF6jDTaozpez4mMoU9jXI6DD5/6k8wX7YT1FFUwuD00YmQsETIe4NDbDr8J2oqvxejIaMNotpZQM354FRU20tz/rH+Sl9N3ZbyA/hg9VLqyGshNeX5pnWwsVdWS/oyg97d4Hnmjfz7P1BdiQU6NYTWLeEyQZ1iNEMqUot6IuuFs7x0q0X/i3/P3wSaMMLEq1b4xX1eGBXXFj4sjOoQz5nMeXe81hGt6a5rQ7+qTvBxINEMTNETmPwgICS2zs45q40+SROUiz26Qs0uRxde2/5/yNBOwgEeZn1N9QYBMIn6TJQ+fS7nqowwDk5KJiZvrSkQvbJNLUNB+AitcogKnWwJu76Uv9CwZBXMWFYXjgwf6QAwD9LbX3jiNs96yQOPgGxPI6ODfwQi1S61gPgvumNb1la6+VIsxKqklLdj8RgpwTnH4JikrFFnIxrIv0rpYHkHm3qQ8UFfxwEpFoAkcitKsFOVodNuvynyxxaZxpVc0Q81WgiZlpS6OPBWmCP1jjMO0a6v9Od0HkwPh/9EYC2AaHeASogjZHOHvO3PbTvy7PCJ4k/Zer7kiU0gp3TLBGxc0ezIwjD4WzEdYenM/1e0tzr5N9GQXiJYhVtBI5DYuK8vLRY1FoXO4Fr/XII4xGGd4
 CMRtj1KC
 YOr0QCf77Ne+t+TY+2/kuJ/jvuoMdjrZqp8yJQXHoXWRTxUriVH55CLQgOvDIxFIidNyP+Enfa1dyiOGFk+WVz5Y664NNXKj8hLQfdvG4WwQ+vXZhVSb+DiDcaq3sEIxpXek5SpHMR0uqUTFo6bXzUokIoyEunUfPRAphpTnqvwnxIiuGk3op3l8THMaH5kXinD97bkwq2PIarbtYqEognUNRVbNL5XvD3UP0abw5ZdaufwF44kXkVAiZ4mwpRR0fqed4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 9, 2026, at 15:22, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Thu, Jul 09, 2026 at 09:41:46AM +0300, Mike Rapoport (Microsoft) =
wrote:
>> mm/internal.h becomes more and more bloated.
>>=20
>> Split declarations related to mm_init, memblock, vmalloc and sparse =
into
>> new headers.
>=20
> Sashiko rightfully pointed to some issues, will send v2 later.

Hi Mike,

I recall that this work was mentioned during the last review in my =
series.
However, I didn't have time to address it then because I was still =
working
on the HVO refactoring. I really appreciate you taking this on. Thanks =
for
your work.

I've reviewed Sashiko's comments as well, and it doesn't look like there =
are
any major issues. Therefore, feel free to add my ack for this whole =
series
in your v2 version with the proper fix.

Acked-by: Muchun Song <muchun.song@linux.dev>

Muchun,
Thanks

>=20
>> ---
>> Mike Rapoport (Microsoft) (3):
>>      mm: split out mm_init and memblock declarations from internal.h
>>      mm: split out sparse declarations from internal.h
>>      mm: split out vmalloc declarations from internal.h
>>=20
>> MAINTAINERS                        |   3 +
>> kernel/liveupdate/kexec_handover.c |   3 +-
>> mm/cma.c                           |   1 +
>> mm/execmem.c                       |   1 +
>> mm/hugetlb.c                       |   1 +
>> mm/internal.h                      | 183 =
-------------------------------------
>> mm/kmsan/hooks.c                   |   1 +
>> mm/kmsan/shadow.c                  |   1 +
>> mm/memblock.c                      |   1 +
>> mm/memory_hotplug.c                |   1 +
>> mm/mm_init.c                       |   3 +
>> mm/mm_init.h                       | 120 ++++++++++++++++++++++++
>> mm/page_alloc.c                    |   1 +
>> mm/percpu-vm.c                     |   1 +
>> mm/sparse-vmemmap.c                |   2 +
>> mm/sparse.c                        |   2 +
>> mm/sparse.h                        |  63 +++++++++++++
>> mm/vmalloc.c                       |   1 +
>> mm/vmalloc.h                       |  46 ++++++++++
>> 19 files changed, 251 insertions(+), 184 deletions(-)
>> ---
>> base-commit: 820d5dfede0cd55dcbc89ce96fcfbb11b7c457ba
>> change-id: 20260707-internal-h-2efef660381d
>>=20
>> --
>> Sincerely yours,
>> Mike.
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.



