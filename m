Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A347C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 11:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C126B008C; Sun,  6 Sep 2026 07:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5806B0092; Sun,  6 Sep 2026 07:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40DD56B0095; Sun,  6 Sep 2026 07:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7B46B008C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:41:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD3601C237C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 11:41:40 +0000 (UTC)
X-FDA: 85183147560.05.6612E57
Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id A885C80002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 11:41:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=gsMGNOoB;
	spf=pass (imf30.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.45 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788694898;
	b=CRiTzw7tgr+9R7gvfhWZymZvzA07HKX+TjNVLnhYI4b9SrHY+N6toxWGeyl+LYlM+j6ZXB
	YZ5Oo/6ZJLgZsSMOVqp6R9sPaGiSfusfg402DIewWMODkPdcZysjxTt54dIy85EelF4wCW
	kW6qCZYZZEjtmjz+2Zk+hzpzU+aASwI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=gsMGNOoB;
	spf=pass (imf30.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.45 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788694898;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Txjb4A2ru0WHH8ExTeA1+aRZilQ6U0tRJ24xs4Setuk=;
	b=E0LLHNjKMJT3EAX4uaHp+YFV9hkR8GX3dAamwB2Z2PjrSOTZuXJA3TmpWVZrgfOGX3I+yu
	eBVw4IUgK9W1/ukqVqamP9TWq9s8FllaQwob1UsaOViofDtelFoUv7wi4wSx+ZSPAtlMga
	w1IUn6PXgPoiLNl1OYu+V1Od3KZaTjA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788694893;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Txjb4A2ru0WHH8ExTeA1+aRZilQ6U0tRJ24xs4Setuk=;
 b=gsMGNOoBKWnuzNae+zqKdZqMscRCD1AiEZYEY6htIlRk6+gNoKGaQmKYsKYNBjNXUm1bg6
 xGaAOEqOARkImszoU6UA/pFzyCd7LSfk32qvYJElb/bqw7GJgVgWGZ/PG3teeTMVKxDjz2
 0+sL2e/vQDFiT2KHBN7ctjFgp5CUS+dexxkSZWJwgupilHVZmfc9Qu+tcyc4J2ZBybJEYE
 3O7lCgnI+/VOUxbbNaHQn/Cwet4hIu6rLmTVNizTAhAmTzubMJhfIq3DvQpPSPhj27EBwQ
 19siYfKDSN/tMAK0s7/7xhbUyXGLHqWKoqogA1tdzyeiqm81vko7cmrmvzJ4AQ==
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] blk-cgroup: move async bio punt state to blkcg
Message-Id: <4706f5fa-3a09-4c48-aa4b-c56521166618@fygo.io>
In-Reply-To: <d88a132d-177b-4d54-9927-3d16065c7b60@linux.ibm.com>
X-Lms-Return-Path: <lba+26a9d516d+fa48ff+kvack.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
To: "Nilay Shroff" <nilay@linux.ibm.com>, "Yu Kuai" <yukuai@kernel.org>, 
	"Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
References: <20260823133045.970199-1-yukuai@kernel.org> <20260823133045.970199-4-yukuai@kernel.org> <d88a132d-177b-4d54-9927-3d16065c7b60@linux.ibm.com>
Received: from [192.168.1.104] ([39.182.0.178]) by smtp.larksuite.com with ESMTPS; Sun, 06 Sep 2026 11:41:32 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: "Christoph Hellwig" <hch@lst.de>, "Tao Cui" <cui.tao@linux.dev>, 
	"Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, 
	"Shuah Khan" <skhan@linuxfoundation.org>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Pankaj Gupta" <pankaj.gupta.linux@gmail.com>, 
	"Dan Williams" <djbw@kernel.org>, 
	"Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dave Jiang" <dave.jiang@intel.com>, 
	"Alison Schofield" <alison.schofield@intel.com>, 
	"Ira Weiny" <iweiny@kernel.org>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Kemeng Shi" <shikemeng@huaweicloud.com>, 
	"Nhat Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, 
	"Barry Song" <baohua@kernel.org>, 
	"Youngjun Park" <youngjun.park@lge.com>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>, 
	<dm-devel@lists.linux.dev>, <linux-raid@vger.kernel.org>, 
	<nvdimm@lists.linux.dev>, <virtualization@lists.linux.dev>, 
	<gfs2@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Date: Sun, 6 Sep 2026 19:41:24 +0800
Mime-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A885C80002
X-Stat-Signature: dks446hsgnzw6wpcbr33rw3srtncbagx
X-HE-Tag: 1788694898-538062
X-HE-Meta: U2FsdGVkX1+d/0ClVwCEQuCGf1NacV6JjPySGlSqRAosY3h9CHmFuCf1xQyWo/FBjiGx3imlFSCX6b/sRhZUazspTq+2I6EJeV+5KMyHmw2+ZWXFke2eyqQ14dqeP5IGvQcrOMHWT9LeY0BZ1xcjkyLk098eYK7x3BpJ2zSoaQLHN3hAaA90pd0lU0kX6a5ee6FeWiTHxSl6x3egb2h86G84Okl0nxP2LBmXyULaDWHfDbThIk+SknlH7yMNsiBha5kJLT21dDokCTeTiUULUmDTtl16QFWVsOlC22jZHPz84caQrd+64mq4wO7P0jMZbONYUVTinxs9g3hm0zmTDy4beXwQ9lqPx36wP0OvG4Pg7Br6rc3GhrVK2qQ+kyZINbzc9aLbh05F/IP0KGXxxyhCxcuMKQgDLrXPiRGcgc6HaLd3nQwt5jTYOonTd8dLRk1RV2lEA7KdAvBiO4xATg0HUKZcbjDnCW35PvXKFDfvIDjRG4o0P4f7hbset8+ajO38Ero44U+uUFo1qGzPZ+Vpk3m4gnOELXMBqRclY5xgg7Jl8V3Z8s/dDQma6qZ/mrKiH7pq8Z8H/x5c1MaVF9tF6tbuRl4CBO6c6d6BeRVJb5TSmazzrdXFFZ4xTTx4J6m0XajNHn8/UonGylmiPSNXhy+xyfWnjobkrAGMtNwViRbwefbltecZz/52n1lDYBoPuLdEqNWK9PbWGnRaEe9EkiXwe4sPJwa2aJZ5WNysr7okv8JoQzmxY+uK6O8XfskUdfFfvbKVyaeaVklWRDyOy17WSfSH/cO5m4cmhxF56z3SG+2tsur7R7ba3IJbSR4j6OQ4vKqkyTWINOiCOQm3VY6XyPhUrPC9OFzi4Sv3pcrAod9Miv3MnEeYubjuVtpWpWx+31JXTJNqFnmpR/LXdfH2JdLbK32Ts/OpIzV4yeFV9fGlBsuHqQX0zt0uW3TxemUsx7VYdW5W0Ub
 WwNoxYgY
 vKLh414byXw+ve97lCPWcn+uKb5aTz8CKiRhB1K52xmxwUToAPCZ4F6xhiuEduJM/cQ1i/OFIpiPL6ElV64e0JiTSTeSIo1wabNT7TWtkB/fIzNBM63MMvn6pSSIFbZHT3FUH+iu7xLMtBrU+tLH+FkkDxBXeFvZUmv49VGEYFHAjpAmFZuqQz3uKoVzZhb9kkAq2ktwKOsPoIM+29AaR10jAMmSh5asVCOsTbpKnPvgg89lWfesYKlItgtIvHNy1vxd9dtgfT0ZhcnfVBw84ghCex4ZVAvcTeNyM6Ld4vOfmAwryEIbQOiupCQ/MZyXMQuRbzgcwGEGTCZ0xb7+aNkoOEWh+G6FcvsP9j92ckkUKLgDBugxPsFa0lXyulCQYx/VmH2CdvvDv8ETlHcV8Et5pc91A/uK+xznx4lsJ1liHfyHsGf/wmhxUq8yiafpxHBwlWUXAARiWohlIjaPobDftbYvqdcSrlb6DFz8NinAzMTh36nGBiwqAHkkDf5MrXJ78r+kNVh0mRNZuQB4/uzSd1mNJRHBBvGs2HIYIsDL3HxUFEjx58ZeF+MyGOdjOjrjuDpAgBGSjJdUpE3TgnXS5qC+w7mt452UIKXjM9ow90JbL76A0C1qzL3+T+ThzZL0QGxjhJNCjsDkefs22fREORQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/9/6 19:01, Nilay Shroff =E5=86=99=E9=81=93:
> On 8/23/26 7:00 PM, Yu Kuai wrote:
>> @@ -111,10 +104,15 @@ struct blkcg {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * List of updated percpu blkg_iosta=
t_set's since the last flush.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct llist_head __percpu=C2=A0=C2=A0=C2=
=A0 *lhead;
>> =C2=A0 +#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>> +=C2=A0=C2=A0=C2=A0 spinlock_t=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 async_bio_lock; /* protects async_bios */
>> +=C2=A0=C2=A0=C2=A0 struct bio_list=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 async_bios;
>> +=C2=A0=C2=A0=C2=A0 struct work_struct=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 async_bio_work;
>> +#endif
>> =C2=A0 #ifdef CONFIG_BLK_CGROUP_FC_APPID
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fc_app_id[FC_APPID_LEN]=
;
>> =C2=A0 #endif
>> =C2=A0 #ifdef CONFIG_CGROUP_WRITEBACK
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 cgwb_list;
>
> As I mentioned, Clang context annotations are now officially supported
> in the block layer. Since you're touching this code, I suggest annotating
> async_bios with __guarded_by(&async_bio_lock) as well.
>
> This would allow the Clang thread-safety analyzer to verify that every
> access to async_bios is properly protected by async_bio_lock.
Sounds reasonable, will do this in the next version.
>
> Thanks,
> --Nilay

--=20
Thanks,
Kuai

