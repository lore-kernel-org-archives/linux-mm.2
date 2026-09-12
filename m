Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E08DC88E59
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 14:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEEDA6B0088; Sat, 12 Sep 2026 10:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6A16B008C; Sat, 12 Sep 2026 10:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6336B0092; Sat, 12 Sep 2026 10:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6500C6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 10:21:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3B4B404CF
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 14:21:50 +0000 (UTC)
X-FDA: 85205323980.19.26F4C7E
Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9135A4000D
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 14:21:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=UGldNLs5;
	dmarc=pass (policy=quarantine) header.from=fygo.io;
	spf=pass (imf01.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.45 as permitted sender) smtp.mailfrom=yukuai@fygo.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789222909;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4/pESkF5aOOEVFDthMDfJ73cy1uGXqcU5VDQUIbEYU=;
	b=KoNXVNJ/1qlEqBuKC7aqBtx/lzdSD5PwfUi8UpI8h8AEhMLhSsPsNGuYP0r5qdpt3NrkBJ
	rB5ck5nKcPtMb/MKyyrgNUVtPN2rEfvOVg7RyKczre7P9KunsCJIDSBeRNn5pYWwGZAX7Z
	wastcAiUnV3FP7E8w9Ip4tbty9poVVI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789222909;
	b=kxTX2DYpE2Xl3oTjiheihPKOBeHkc7p2tV7oS/Wj//NFf2HeXJBT/43/NFAtrOVPdS3Nrc
	Zqh8nKQDrCHZ2e/ZF/CQ9OKXnN1m7GwysKqAfJ3sKSXgwp2FB5ncAnnTrTzO2U9s1j7Sev
	xnwX089pm8u8nR26XIcaaAzeXQamd9I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=UGldNLs5;
	dmarc=pass (policy=quarantine) header.from=fygo.io;
	spf=pass (imf01.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.45 as permitted sender) smtp.mailfrom=yukuai@fygo.io
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789222897;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=m4/pESkF5aOOEVFDthMDfJ73cy1uGXqcU5VDQUIbEYU=;
 b=UGldNLs5R+8hoPWBCmTD+McM5Lu8GHuFFxsmAmDuGrVLgTG7E9C0LBRQSirs7xt/2EJDwa
 MpkQdDwP6+tg/xRfQJz06LqsuuwEGE1G8V1M/vDR/gVJeGWeWyVYUi8CbcSAiYrs8dwL1S
 H5WrG0RhB1nnSdMfCNZEjrEgqOrXZ4rWyP4w8cUygCNxY3Sa97c10ob+L8OOlkylzKKnxQ
 /B0Ky1v9kHB/rknQECUEC8/bx/mXrCnIkoe8x/3T/U9gowiymL3x1DGXVF9dQGIqNWLTBq
 bMThFbPAPYcXsLS9ztGL8N/N5LLnQZsBtnSl3BTxJry0yWA7JeGYzv2Md+2UrQ==
Received: from [192.168.1.104] ([39.182.0.161]) by smtp.larksuite.com with ESMTPS; Sat, 12 Sep 2026 14:21:35 +0000
In-Reply-To: <a123f309-6ec7-470f-b5b0-f08cca6d2627@linux.ibm.com>
To: "Nilay Shroff" <nilay@linux.ibm.com>, "Jens Axboe" <axboe@kernel.dk>, 
	"Tejun Heo" <tj@kernel.org>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"yu kuai" <yukuai@fygo.io>
Date: Sat, 12 Sep 2026 22:21:28 +0800
Mime-Version: 1.0
References: <20260823133045.970199-1-yukuai@kernel.org> <20260823133045.970199-3-yukuai@kernel.org> <49d724b8-57c6-48fc-8099-69cd1b072351@linux.ibm.com> <befbc177-f7f5-4c44-b02e-20a99fc64c0c@fygo.io> <a123f309-6ec7-470f-b5b0-f08cca6d2627@linux.ibm.com>
X-Lms-Return-Path: <lba+26aa55ff0+0cc3a3+kvack.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
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
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <4701cbcb-b877-4902-a5b6-59836c345ae1@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/3] blk-cgroup: store blkcg in bio instead of blkg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9135A4000D
X-Stat-Signature: opkyiswrkhzxuoo1rx1ckoo7we8htrwi
X-HE-Tag: 1789222908-290788
X-HE-Meta: U2FsdGVkX19LmDYwZOoW2C6p2JP0auINgVScNGEY+P821N7mT/RZXoE/b72n98HbfivcVXZF3RqPaYZFssJfipNi/3RPjGBP4Ns8uHXpO6NTYWxhTpv8Rrdws9+We9mCVxsDdkFyjVmwyN5YHY0YLYE7tyxmXOlCSs6a7FbtaFvWWZGU+zXktpISYsN6nTEIvnRElB03LqONbz1bS8QBC+2yIFQ9ZhyUPRWEr3btzyypIBQjL/2pyxkowI0MSJmDHzBSYN597KyK8FxsIuawtfQ/CEoWvBUpwTA0MFkxbQ9KPZHM2nWHVSTgG/T4Vf6TfovOgZ94q8yKc/bg5jVEJGhGaM45QueuFLLstVwY4Qss4FigsomTGZxrQ76H4prYCsGvQQmhtRIR+g0ZIDSg576MhjV8sVn0aUrAUY4ZKoQVMvwU1Ko0thYQdiQ6vsZSbPuE/K1CezX27cnXwdRjGga5GWyTxBldbFiORIX+Bv57LASapVBrRXRTPfJo1BcTXdTYAhmG8UD2L5zmGEateVzcIAPp8UKlG3cqbFKza8pzRRA9pg/TDvfC2s+uJBb45mGo2qayynHUDnfiYCyZGJje41OxX/6Mig4oSp1+xwTjVMyV75+DAsVQrHfB6UThezOJsEti8JWyKHpV12Bbg1hy++ghD0SiSQX40xunSxdzFY9TfolnAOtDaZvPPt5IHhf6kWEuKsZo2pRwUpF+b1B7aRJE+1swfl2BQWdDvv1G/YW0EkXT/+roX8Ozxn91yDbGhcgyqJpbHaU1jm+MVnhjaR+TL+Z3xnYnDEHm/eY2XWhrsHhiWTQPCngMzYNfroA0py6Ea4K6StAoC/VqbyfQG+sl+2PUBULDzhklnx7cY3E7za3Z37iQgIdL9SDnmJiWcaPExB4YNrf12nuJy4R2Xyhz8hSqcTNxcdL/2y1uhG2X4HAOeoXEXqWtNZ6Dg/4ZtVWjIuyXzUZjYMn
 6LpQjfRj
 fGqYI8jwBIy5ihSUNeQBUf+FrCujE5CMQHknTIGhPo6a2fsFTiKa2GEJHn7pR4OOu4V4CgV4s85uPE6FxVcl+GujDCL3dFVbFrZrq6T5VxMpo/xc6jDSBlvXZvKOHjQzy6wFNdk4cMlv0EbGW7Qgwohwr61GacEmfBv+v4L8WMy0mjF7Se9B31gNiA1pfOWOFugs7QtBnrwdlFLdE9cgo+9+qXH9t+3FlWtBIZ4nU2aevnmKNmHTqspt0ZxnkQPd9ojoktv/MSCuNd2levEbIUvXIIPerOvFZSDEiFVssfba0sUQ9ktEtK3qqeihXNfX12N1ePPiGIBeUNxuVMGGeNwhxsLDDeHFr2DCmLW35AxngR2VwfRgEtlEvH8UTg8Y3kaLORB2fkI0zjzKhufU7hHPD+qz97oaAg5rvRAG2iEcZscfzs5xZRP9KPTZszriR/4cEFYIjGpnsxNs4FzVNYeZDYWCZLp0Cmy3cehl39suOOVoT95pFqpFbCCZZ6pwfHnMpSD9LxhhClz4Ya5yu6XPJq3cQvZXR3xXd9dWL3tAu8pnUUfuKySErBurESlK7PF3mWs2djZd0EoYHMrE8BSxA2gPRDdTN597tRkWVDLarN0VcByxAauB/l5O3miuCDADUMOZIJInyL1uRDWHsX3HPPAPV176IWRrnUwCqatYQ4lwUqVoeHx8yiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/9/7 14:02, Nilay Shroff =E5=86=99=E9=81=93:
> On 9/6/26 5:09 PM, yu kuai wrote:
>> Hi,
>>
>> =E5=9C=A8 2026/9/6 18:56, Nilay Shroff =E5=86=99=E9=81=93:
>>> On 8/23/26 7:00 PM, Yu Kuai wrote:
>>>> @@ -257,20 +262,21 @@ static inline bool
>>>> bio_issue_as_root_blkg(struct bio *bio)
>>>> =C2=A0=C2=A0=C2=A0 * @blkcg: blkcg of interest
>>>> =C2=A0=C2=A0=C2=A0 * @q: request_queue of interest
>>>> =C2=A0=C2=A0=C2=A0 *
>>>> =C2=A0=C2=A0=C2=A0 * Lookup a blkg for the @blkcg - @q pair, whether i=
t is online or
>>>> dying.
>>>> =C2=A0=C2=A0=C2=A0 *
>>>> - * Must be called in a RCU critical section.
>>>> + * Must be called with either RCU read lock or queue_lock held.
>>>> =C2=A0=C2=A0=C2=A0 *
>>>> =C2=A0=C2=A0=C2=A0 * This does not acquire a reference.=C2=A0 The call=
er must already hold
>>>> one, or
>>>> =C2=A0=C2=A0=C2=A0 * have the blkg pinned by I/O.
>>>> =C2=A0=C2=A0=C2=A0 */
>>>> =C2=A0=C2=A0 static inline struct blkcg_gq *blkg_lookup_any(struct blk=
cg *blkcg,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct request_queue *q)
>>>> =C2=A0=C2=A0 {
>>>> -=C2=A0=C2=A0=C2=A0 RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 "blkg_lookup_any() requires an RCU read lock");
>>>> +=C2=A0=C2=A0=C2=A0 RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 !lockdep_is_held(&q->queue_lock),
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 "blkg_lookup_any() requires an RCU read lock or
>>>> queue_lock");
>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return rhashtable_lookup(&=
q->blkg_hash, &blkcg->css.id,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkg_hash_params);
>>>> =C2=A0=C2=A0 }
>>>
>>> The changes look good to me. However, rhashtable_lookup() is annotated
>>> with __must_hold_shared(RCU). Since we now officially support Clang
>>> context annotations in the block layer, compiling with the latest
>>> Clang/LLVM generates a number of context warnings, for example:
>>>
>>> block/blk-cgroup.h:277:9: warning: calling function 'rhashtable_lookup'
>>> requires holding __ctx_lock_RCU 'RCU' [-Wthread-safety-analysis]
>>> =C2=A0=C2=A0 277 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retu=
rn rhashtable_lookup(&q->blkg_hash,=20
>>> &blkcg->css.id,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>>>
>>> The same warning is reported from several other block layer source
>>> files that include blk-cgroup.h.
>>>
>>> This indicates that rhashtable_lookup() requires the RCU read lock
>>> from Clang's context-analysis perspective. Looking at the call paths of
>>> blkg_lookup_any(), it appears that not all callers hold
>>> rcu_read_lock() when invoking it.
>>
>> I was not aware of the above clang warning, this should not be a real=20
>> problem
>> because queue_lock should have the same protection as rcu, and I was=20
>> trying
>> not to make this patch too complex.
>>
> I agree that this is not a runtime correctness issue when the lookup=20
> is already
> protected by q->queue_lock.
>
>> I add the rcu_read_lock() in the following patch to covert queue_lock=20
>> to blkcg_mutex:
>>
>> [RFC PATCH v3 3/6] blk-cgroup: protect blkgs with blkcg_mutex - Yu=20
>> Kuai=20
>> <https://lore.kernel.org/all/20260823152926.1043863-4-yukuai@kernel.org/=
>
>>
>> Since this is related to compile warning, I'll move the rcu=20
>> protection to this
>> patch.
>>
> Since rhashtable_lookup() is annotated with __must_hold_shared(RCU),=20
> Clang's
> context analysis still reports warnings for these call paths. While this
> doesn't cause a build failure (and only generates warning) when=20
> CONFIG_WERROR
> is not enabled, it could do so for configurations that enable=20
> CONFIG_WERROR=3Dy.
>
> So IMO, moving the rcu_read_lock() protection into this patch makes=20
> sense.
> This would avoid introducing the Clang warnings/errors in this patch,=20
> and then
> you may accordingly adjust your subsequent series where the=20
> q->queue_lock protection
> is removed and the blkg lookup paths are protected by RCU.
>
> I also noticed that some paths already take q->queue_lock followed by=20
> rcu_read_lock(),
> so adding the RCU protection here should be consistent with those=20
> existing paths.

Turns out Clang will still warn after adding rcu_read_lock(). I'm not famil=
iar how this
works, but AI told me this is related to inline helpers, And I'll have to a=
dd the same
__must_hold_shared(RCU) in rhashtable_lookup() for following inline callers=
 to kill the
warning:

   static inline struct blkcg_gq *blkg_lookup_any(...)
         __must_hold_shared(RCU);

   static inline struct blkcg_gq *blkg_lookup(...)
         __must_hold_shared(RCU);

>
> Thanks,
> --Nilay

--=20
Thanks,
Kuai

