Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0DCC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7DC6B00B0; Wed,  1 Jul 2026 04:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4884B6B00B1; Wed,  1 Jul 2026 04:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351A76B00B2; Wed,  1 Jul 2026 04:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 049F76B00B0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:51:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8238AA0230
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:51:54 +0000 (UTC)
X-FDA: 84939590148.27.5847199
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A82D100010
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:51:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/WxM8iZ";
	spf=pass (imf14.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782895912;
	b=yuPQtF6ENG5lXfWkx+Efx3J/EiwDiO0SB0CAfyQ89dOEHi2bnMs0YvyS1CWXe4AH99n6R/
	W74cMQDrjyYoSJp7Kyd1Q2BZJgHSKXBB3zY2IUxIXwTVBbbH0rF5OEP28m07uSaJ4t2DFk
	sFDqC69v8x988d8um4Pvig2BbLWv/Jo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782895912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WptujkoueVK4W82l5uzWeP4VkNxIbJRQVDPy957bR6Q=;
	b=4gMWXVH4xEavbEBkdhN9x9uVtxsXG5zMMd3bWYW0FvCM5JZ3ou5k9Lqeswy5pTWa5keZmv
	zek01XycPWOXemfb7y+uvcMVnqI3Lox8E/UfWsfUwvcUWwyo/GFfJhIz3yJWvhquksLZUT
	A18ocRE2z5kWvRfibuju7G9XnN9s9/o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/WxM8iZ";
	spf=pass (imf14.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782895910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WptujkoueVK4W82l5uzWeP4VkNxIbJRQVDPy957bR6Q=;
	b=i/WxM8iZ8GrjPdcPjCSi7qVYMN91pIv2LCUly1UdXPGZvcP95zU4rXHRHK5WnPPTSebNnc
	6qZBGxw0mYI7xo35etZQoa2mnGtUwk12wTdfnlcjHI3pv77RMq3IOl2zKGS4SRa3rEExMR
	FNnBiqLcyKqQYGm/Bg5c8q8Eb12BWE8=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 01 Jul 2026 08:51:32 +0000
Message-Id: <DJN3UHUICJX4.3GN1396CO525O@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, "Robin Holt" <robinmholt@gmail.com>,
 "Steve Wahl" <steve.wahl@hpe.com>, "Arnd Bergmann" <arnd@arndb.de>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 11/16] sgi-xp: Use higher-level allocator API
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-11-57bef0eadbc2@google.com>
 <d7bee578-7f0d-48c3-9eb3-65999476b7f8@kernel.org>
In-Reply-To: <d7bee578-7f0d-48c3-9eb3-65999476b7f8@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A82D100010
X-Rspam-User: 
X-Stat-Signature: 69kk7pw3ogny59xmho71tksmpcusdc9w
X-HE-Tag: 1782895912-436147
X-HE-Meta: U2FsdGVkX18D02NzzjGOlfOVoNIzAYNHO1BwHw9XlTGV/XVHCpXRWujs8KkaDIlELqjSBs2RxCOPsXre5S20lk7DzDTdl3slTY+at9qV7qkgBU021Mo+pBbLVKQrunmFNP8uPeNbprihoKc/npuhM+o+UfRKwAIGeWH9vr+pVVmnUUmdxN0n7sOt1XOjueO3SatLdwx7TzMVJkIgzKt0kaxLRIxMstBhTnxXN9Nr9Qs/fbK/virgFcN3ZYTk0n0C30LI0MJjbm2xggclfzY4pL6UELZuK5GW8fUHUY7qwbnMKXVpDWNc9GBA8uv2kGzqR3MjOPmt/frMIkrZZoDuumd9Sm1NB3+o/gWXTj5ftN3kkQoqXgbuPxksQNJEg8HifZiNqbgvzKwvsgJnAaCJZA+bQ9o7K6maIHiAWMwYvIUgFVryc/9gUztbldQTDwgKhl0PAOuEhxW4kEMgSEq7z1PdpTUR/qreZhgwjCSB5AgWl4jezd/kzGd5wH5mgBOLAV1xLuGx2Oeg4KBxh9y459+3/2MdMmH8aRFse9/uHo2OkFryU6FR3clLXe4bXLroWrIsOveJ59KCafm1jS5pPz5GIuPT7o13tzQKb67qu8DD7FMAAgPOcgUx02LSYx7yjbZjHaCqH6MEgLuuPTZq/65jl4+kH4TLwc1iJ8XaF3ez6kr2e0Tf4fLhuh3hLU3imLfvFA5TAnwEv6Xno2nsTGRaPyLIg/b8J0pr97ZOpgmTF/xnG0YveNsilbZpHBF8fjmYe092FgxxWUsR6ri40p+sfiXP6c3wSanORmVRDxENnYNDTxEyd7XxDqFaeWDFLhHYIrXmJRF9/5GEdF8rT1jANyrHDAfnRGUsnnaAcCxluZWyG1tb8aKdCPSxIPrbEAVd3sDdhuhog8M6+H7P983RYowNQrXLX2dF2hbYzqcdN/kmx+dBTmjBD4vDD0sdb4qbz2EqLVF+bvtXeB+
 VJHIEWw1
 jVGS3/cN3cnxsHhwGEmuEiOw6xGXEhFnJFPmWr/S3VeFFA17G2KXSGop6HUq72Pk/2VfEuYn1ntMTAtHMbIOBdUmXXcHgTL5adQvs+zrlsZcRwRzTkTFOMJkQfqpXHKkCFFMkA/cRx+tAOP2FCKpNIrQFbjyKpHCujRFX2hbl+fMudwsRkP0zDIx9zWzNz30BEzdpblsOIuwMZRvNqkq46SwoHlwESnxvNdYk3/t4mA0LDX5LYyO+fhayaQDshN6mTZOEF8ynTDZDvOIK3j6z5IOj5CL/IRBk67+DqGxMzXAv3yrWNGyMVDLE4Fw5ycyM2va3hu8c3QwVDJleSC3a2FFFGC6g/LcJy9bNFb/1FckzMRm3mVxUJjXEX1IwWDC1WYmj+rVDMxnv9zXO/v8T2lDX5jWaQ+LD73exdqeogxBobHuAYuTt7QayhGvBHbobCwM1DrglrC4sJaESocs6nOsiDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 1, 2026 at 7:52 AM UTC, Vlastimil Babka (SUSE) wrote:
> On 6/29/26 15:12, Brendan Jackman wrote:
>> The difference between __alloc_pages_node() and alloc_pages_node() is
>> that the latter allows you to pass NUMA_NO_NODE.
>>=20
>> The former is going away and the latter works fine here so switch over.
>>=20
>> No functional change intended.
>>=20
>> Cc: Robin Holt <robinmholt@gmail.com>
>> Cc: Steve Wahl <steve.wahl@hpe.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Assisted-by: Gemini:unknown-model
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Nit:
>
>> ---
>>  drivers/misc/sgi-xp/xpc_uv.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
>> index 772c787268932..aacff70204241 100644
>> --- a/drivers/misc/sgi-xp/xpc_uv.c
>> +++ b/drivers/misc/sgi-xp/xpc_uv.c
>> @@ -170,7 +170,7 @@ xpc_create_gru_mq_uv(unsigned int mq_size, int cpu, =
char *irq_name,
>>  	mq->mmr_blade =3D uv_cpu_to_blade_id(cpu);
>> =20
>>  	nid =3D cpu_to_node(cpu);
>> -	page =3D __alloc_pages_node(nid,
>> +	page =3D alloc_pages_node(nid,
>>  				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
>>  				      pg_order);
>
> gfp flags can now fit on the line above?

Ack.


