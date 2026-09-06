Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C771EC79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 11:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70EC6B0088; Sun,  6 Sep 2026 07:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A211E6B008A; Sun,  6 Sep 2026 07:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910336B008C; Sun,  6 Sep 2026 07:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6906D6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:40:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC689C04EA
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 11:40:12 +0000 (UTC)
X-FDA: 85183143864.27.BE241F6
Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	by imf30.hostedemail.com (Postfix) with ESMTP id 603E580004
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 11:40:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=bFgMvn7H;
	spf=pass (imf30.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.57 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788694811;
	b=HbQtdjjsib0bqYD1ItoZvRWEVkunBhZt/gwjxBTdf3SZi7Xq+MtCiGnJ4OCpGSstbvYQMe
	XK1frb2TOu97FXcc4AIikRkqTIHJrhLdBhZejZ7UOl8GsiKgaVOh84jI6MO8SUydfy/myD
	D1WSofNPEwakGPyE3Ppa8EEg7kOzt6o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788694811;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEktsWXso/ZQaq8+Orw8lH87J9Mavxs+DZ2u0i4gb6U=;
	b=LHvGCju3czEH4S/EZRqSalBoQK8kUaSRx5TUpFk3LCPgR+vWFFlllQ9M+jIJJhlC1dKwPu
	9UjX96EeWEELYqqf+zFvCGpJ7c8Wn1n2EY88QDQ0b/QODA5fT6zBvbYhGISYNQinAQv9DQ
	sbOtqM3KfePGJVkg4VG5W8kBoga3BeU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=bFgMvn7H;
	spf=pass (imf30.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.57 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788694802;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=eEktsWXso/ZQaq8+Orw8lH87J9Mavxs+DZ2u0i4gb6U=;
 b=bFgMvn7HS/3GeTGxiu9DPfrVkogWI7kPIhbufXYYGS6NBHIrnSJTG4n6eNN4C1yVb0LuT4
 yd5MtxWDrOpyMjGcUJ2lX6vEbuG77nt84WuK1duy/hb1t7+vmZf9XZT1g42DJnmbZ2KT7s
 yKnuBI9p0DEvyRIfrvPTt9FjM0K3ZzpnPU12G/6SP7kdOpt4dTpXLSjKvco8JwCWTEIbIk
 rD5Wk+hCsLA0wJo2yhYjf1Wi6FeRntdtDwQ0skqEqsSCLsbJLygfige3pa8vHyQimz9nat
 XIQTJ+LF0pW75DLAqf+IAEZB3QbC1Vnec6RuIPmNBpoJWx2gCzkVeGGE2nwmgQ==
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
Subject: Re: [PATCH 2/3] blk-cgroup: store blkcg in bio instead of blkg
X-Lms-Return-Path: <lba+26a9d5111+349686+kvack.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Nilay Shroff" <nilay@linux.ibm.com>, "Yu Kuai" <yukuai@kernel.org>, 
	"Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Content-Type: text/plain; charset=UTF-8
From: "yu kuai" <yukuai@fygo.io>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Date: Sun, 6 Sep 2026 19:39:52 +0800
Message-Id: <befbc177-f7f5-4c44-b02e-20a99fc64c0c@fygo.io>
In-Reply-To: <49d724b8-57c6-48fc-8099-69cd1b072351@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
References: <20260823133045.970199-1-yukuai@kernel.org> <20260823133045.970199-3-yukuai@kernel.org> <49d724b8-57c6-48fc-8099-69cd1b072351@linux.ibm.com>
Received: from [192.168.1.104] ([39.182.0.178]) by smtp.larksuite.com with ESMTPS; Sun, 06 Sep 2026 11:40:00 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 603E580004
X-Stat-Signature: rsha5m4fchow66h3msu1pickbrs6z8qg
X-HE-Tag: 1788694810-665315
X-HE-Meta: U2FsdGVkX1/MbeqWKmBl5750VqGt0YOtLrWVxKj2bBh6kybi7GJOSE5Bhw4XMMztTeW+MxO66eW6NwENkAQoq1bE+v1JQNUjSKFnK3rgtzvqVmI0HB3o3K35gNANahkWlVggjFy8LXkG6pim4scE38JsxDUrqt3QNCFqmYl46djHVTf3dfGB+hv5QPTcWhSxHMAC2hfKZbUwJGsHw6om9WxocCiMWKX3VTweIQ4ZjZZt4RaAIiQOvQ9cErS/GZ37c36nvDCLNi94rRW4DCejx1H5LOxuE5ZNIDehSTXPYZxSLAzrKayBY99CQcLwJod9ocUymKzlZYV4RDHv3ILYBoQZ4ofS8CxKVx6ciHahqQXyJXuMo5ka70Q0MXSnK9JicFOdNHS8rMa3DpepkAKs3jSmBH/fTX1jEOIFKr0q3zsYN955G+jhJM3kjrUuBwcuidSEY8oSnNO8DQGAI7EikbMMjTbrY42oXOWgDQQsYcUmjie2E6IBiP71jghqT6CpgViTnNC/vfv0ErantidzJhVmZrTroibWFU3qhXIgmgsqr7DxmVpbYvtDMuB5KIsVYEQgp2PPEGu7YxajlnFrLq28MwLqugm+VCG1vY2DcVoDXkFCFKsN8aoSluuecqI70xgE3ln56eRWoFXo60KqI8mm8/p7cIS01VwRXmQTJBmNtOwj4yLyMsJuiU4d2Xjb3VkQmPeW1lCrkKJ7sOgUfYEeojjsQKgrFgIVDduL6EpqHYA9J1ozokjIS7QTo2Z7cu9GDRCENv1IxSsr4VzVL5VFXrgFz0j1JC6KcWYp3LwKO9xrNQD96fdCj+cuVFer8kWE45HVhqkRGJepxYyLK4G2c8LglYmb6K/mhunjxuX1fGnyUxouJwzetXtYkkjRkUcQG7NOMchiAENq0DL+U9Vf9626FRJ05f+WU+vJ21mDWoyruHWNOiWqnUbXPgKeve4U/zDFCgrwL0UpKpU
 9eAfzuus
 b37M8jS2yn/rG6W+oPf6VHlH65M9Gk6hkfI3i5BXFmdkCV2qf+GUxfnOa4kZL+MlRSJuk6eHjqlZtf76rivJpE+fKRksRBlqRlNI80ZGlgZBYWa7h1PgLjyrh8jlT8CMkKcE4nICe6KKdE+wD4J6KWoxDwvihDtmQdqVicmdQhSMNb/g9nKDSlqDzbT22AxKZGbc/X8uUzDmJHXWyJctmPSW9QJK0l3aq8HsfuS9oLJeq6kqdmpQpAbFTxn7kxI2E6RZIznPXJRZLE+y7XZe1PB6ODUilT3+/hVkR40bvB0twL1+D+xjs2NDAuKkbD7jUVTAExEyggetR7+fLFuzMI9mMsh9UWG47A2m9FggucJnyH9UFfEa+u8WAvsncOiyvuuj+8SOOr4ukNQ0E1DOasasw6U64RJ92oD6LbE2+tholAXv4MXGqAtUnqBTPybMq/4CRowrEHxHXAtBhXV/SBvomPNyzGKrQjPMVzQ7/IA+Jtcx7X75d26nBI6hAHoBL6qiwvqElkkR/Q/WnT9B4DBtfL/GuKQmwjLFpwLDRs3jmOpV6j0vGC2frAB+acg9LI2jVx8fNT4J7S3RgYM80p7mTF+8XgIUXP0/S+ZHE+ap9GDiY2nh1Yv8MrPEjnowyGlJkRbYnt8b59EMtHlRrtgVMIOBRYHz5TzjzZdOV7aVLR9L12mltiH8B7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/9/6 18:56, Nilay Shroff =E5=86=99=E9=81=93:
> On 8/23/26 7:00 PM, Yu Kuai wrote:
>> @@ -257,20 +262,21 @@ static inline bool=20
>> bio_issue_as_root_blkg(struct bio *bio)
>> =C2=A0=C2=A0 * @blkcg: blkcg of interest
>> =C2=A0=C2=A0 * @q: request_queue of interest
>> =C2=A0=C2=A0 *
>> =C2=A0=C2=A0 * Lookup a blkg for the @blkcg - @q pair, whether it is onl=
ine or=20
>> dying.
>> =C2=A0=C2=A0 *
>> - * Must be called in a RCU critical section.
>> + * Must be called with either RCU read lock or queue_lock held.
>> =C2=A0=C2=A0 *
>> =C2=A0=C2=A0 * This does not acquire a reference.=C2=A0 The caller must =
already hold=20
>> one, or
>> =C2=A0=C2=A0 * have the blkg pinned by I/O.
>> =C2=A0=C2=A0 */
>> =C2=A0 static inline struct blkcg_gq *blkg_lookup_any(struct blkcg *blkc=
g,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 struct request_queue *q)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 "blkg_lookup_any() requires an RCU read lock");
>> +=C2=A0=C2=A0=C2=A0 RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 !lockdep_is_held(&q->queue_lock),
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 "blkg_lookup_any() requires an RCU read lock or=20
>> queue_lock");
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return rhashtable_lookup(&q->blkg_=
hash, &blkcg->css.id,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkg_hash_params);
>> =C2=A0 }
>
> The changes look good to me. However, rhashtable_lookup() is annotated
> with __must_hold_shared(RCU). Since we now officially support Clang
> context annotations in the block layer, compiling with the latest
> Clang/LLVM generates a number of context warnings, for example:
>
> block/blk-cgroup.h:277:9: warning: calling function 'rhashtable_lookup'
> requires holding __ctx_lock_RCU 'RCU' [-Wthread-safety-analysis]
> =C2=A0 277 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return rhash=
table_lookup(&q->blkg_hash, &blkcg->css.id,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>
> The same warning is reported from several other block layer source
> files that include blk-cgroup.h.
>
> This indicates that rhashtable_lookup() requires the RCU read lock
> from Clang's context-analysis perspective. Looking at the call paths of
> blkg_lookup_any(), it appears that not all callers hold
> rcu_read_lock() when invoking it.

I was not aware of the above clang warning, this should not be a real probl=
em
because queue_lock should have the same protection as rcu, and I was trying
not to make this patch too complex.

I add the rcu_read_lock() in the following patch to covert queue_lock to bl=
kcg_mutex:

[RFC PATCH v3 3/6] blk-cgroup: protect blkgs with blkcg_mutex - Yu Kuai <ht=
tps://lore.kernel.org/all/20260823152926.1043863-4-yukuai@kernel.org/>

Since this is related to compile warning, I'll move the rcu protection to t=
his
patch.

>
> I think we should fix those call paths to acquire rcu reader lock
> before calling blkg_lookup_any(), rather than weakening or bypassing
> the context annotation in blkg_lookup_any().
>
> Thanks,
> --Nilay

--=20
Thanks,
Kuai

