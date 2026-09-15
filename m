Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C54C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CE76B0093; Tue, 15 Sep 2026 11:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E47F6B0095; Tue, 15 Sep 2026 11:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB996B0096; Tue, 15 Sep 2026 11:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9936B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:55:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9EAF514047C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:55:02 +0000 (UTC)
X-FDA: 85216445244.29.42D47CE
Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	by imf07.hostedemail.com (Postfix) with ESMTP id D0E1940002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:54:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=mxaJtARW;
	spf=pass (imf07.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.58 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789487699;
	b=jkB6ru+HnL0aARy/m+UzXyjic5XIP4Th1qC5WDLyJbG6K6stZ41NOtgkQ7QcG2MPIGrvLS
	CjZ/MfmCyweHm7tC5ytL9LwsfDejH526ybX8P+NaGBE1Lzc2+HkgUEnyWlndT+0NPXm98H
	ARA8sPx8Q3+h9K8sh27pd04FMFz7hMo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=mxaJtARW;
	spf=pass (imf07.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.58 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789487699;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xsn6DqvvOV+Iyp7MPv5ignkXFskUrJdLJ8ErPAvqBm4=;
	b=1dOIZiqNlMqXIkS6tO7r6idAabqkSY7I0JSCUrHvgnkZycrcXgh+C1nqr/zmHtZLvfvIB7
	kGIM66RVaizAuCc0MT5YlSEHxU6gs+PCjRlqGE2/k5zVo23Yp790EAAfTGQ8i51bb5SEac
	W7zhhsfwKp4xl69Dg0/N6cCizz0rrVU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789487691;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Xsn6DqvvOV+Iyp7MPv5ignkXFskUrJdLJ8ErPAvqBm4=;
 b=mxaJtARWsYQVSvNqqNhi3oAd9rB3WJsE5l/OaxHp7LKWFjy7L9ajEjiVF2rhnjKrEzx29q
 TUi4XD+Fu5EZhcb1HreuSWXaGH84YvHoGMZZo3alZcGLbjPb+pDIOlwt+RQHgIDj5jlDiI
 6gDGg3FvqlvrIoiI97OklImmBOJ85ijXHOH72P5ZMum+e/ZfZXQEhYI/l7G8hocOy5YjP+
 AE4B9niNx/ulxUjQWyBIG9TPJsdXTRjcCk+cKDCVV7uAOM0z7KJG3mCnohBiWjfIRy4leF
 Ewi2mkvmrZPVbonk7cuAgyHp6mrRMVBz/eY6s1y/ZbVXchkE+EGrAdRKYGSpOQ==
From: "yu kuai" <yukuai@fygo.io>
Date: Tue, 15 Sep 2026 23:54:41 +0800
Message-Id: <52df0198-9949-4801-ac0f-c86935d1aceb@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
References: <cover.1789237876.git.yukuai@fygo.io> <326e4904402440323532168095f2eb0c6f697836.1789237877.git.yukuai@fygo.io> <f27ee89f-5a52-4cfc-a14a-e5019ae61d89@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Cc: "Christoph Hellwig" <hch@lst.de>, "Tao Cui" <cuitao@kylinos.cn>, 
	<linux-block@vger.kernel.org>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	<linux-raid@vger.kernel.org>, <gfs2@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<llvm@lists.linux.dev>
Subject: Re: [PATCH v2 3/3] blk-cgroup: move async bio punt state to blkcg
To: "Nilay Shroff" <nilay@linux.ibm.com>, "Yu Kuai" <yukuai@kernel.org>, 
	"Jens Axboe" <axboe@kernel.dk>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, 
	"Shuah Khan" <skhan@linuxfoundation.org>, 
	"Randy Dunlap" <rdunlap@infradead.org>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Kemeng Shi" <shikemeng@huaweicloud.com>, 
	"Nhat Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, 
	"Barry Song" <baohua@kernel.org>, 
	"Youngjun Park" <youngjun.park@lge.com>, 
	"Nathan Chancellor" <nathan@kernel.org>, 
	"Nick Desaulniers" <ndesaulniers@google.com>, 
	"Bill Wendling" <morbo@google.com>, 
	"Justin Stitt" <justinstitt@google.com>, "yu kuai" <yukuai@fygo.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Tue, 15 Sep 2026 15:54:50 +0000
Reply-To: yukuai@fygo.io
In-Reply-To: <f27ee89f-5a52-4cfc-a14a-e5019ae61d89@linux.ibm.com>
X-Lms-Return-Path: <lba+26aa96a4b+386bd4+kvack.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D0E1940002
X-Rspam-User: 
X-Stat-Signature: zgdxzfn5tddq6zwr6chmo5cq3zu3f165
X-HE-Tag: 1789487698-787276
X-HE-Meta: U2FsdGVkX19e5tbJgvaz2ZNItCEHnkSQR1ZH7oKhGEBjyObxBARlpxml9U+GFc1dSaCxQTeaXdToLkM8NEhoUR4JFgmTizFyTRuk7LiLfn8l5JnFIttNqinGKjXEwv4jzU2kB7ujOQxrl/R9Kr8wLEDT+uAPMYp2itGRqlBbjcVmVcJrluMj6KV/s2A2lYy9oWwjYLOHi4Obf+RGse6S56+y1qoIVjGKwOs5kSnNYJBc1gdgASpN8zucRq09r1vIJBZOAY3NHehggzX94ceu6Ct4QZ8DFkNYlwxsZyZi3N+PXFZqIT3BjGwgY2Yt9wF2wETE8Oiizuq4oAG42rp5L6SyIu03S7B/kDwK8PJ5VLdDQCZFpe3KSe8GXn5UX5k4d+JzdTO6EGVNFh6kNX2nlc0woYJfLFfAYF0Fw40L6zy8xdeKUBlWt50nE68BQz/b+XR448laxH+oyie2EMCNn0fV68Pqc5oB9DUsCWLEXmGgiSaR+gtYRD4kNoa+P43rpa/ghltFK99SKkloWwCPUuI9Sc24wK7scajIfOB+L1rYTGHWPNRpzIatSHvOVU2nahRi/y6VxD+y5+ugyT2OpHKv5DVVjkqxT5vLorX1xPUv5AHzDoPZlPTFxN3s3l/ETDekv6Y7zKhbcify2OCfgw/9KJTf9AsgXH1nD3rGfFRgya7BDLW91bQ0GK+W52yE6hIqCaZAx6/J1pbXBM91ExOVgbs6t+aipNYFFtq9pO+QHAg0faH+PhtjZbfMOtzDuMzXaV4aGRd0pDmMNauOFvBB+zQpor1tE2KP+CgcnHkFIjLW/tiprFHs6/uUuy46UGOtqlQXtatVjcES6vuwoiUfLXCaOK2qzVPGvZ65+FIysRinIftDdXgx1Q41iYIQivfJ5dxUaXM5aR8axBvb577BXaTV3K+wVuDKVuu4GlHMuNfRfCy36W7zfxL8HyRfAqMWvRvml3YAdsBIBhh
 UmZ07kvl
 uFm7USueNLB9zZm/p3e7HvmLWYVx7l++/6g3DBvYklsThzGISj78VNBUv80Bv7uuq1kO+F6VVzUfnIX9vPD2O2D+BPizxvKSXhJ1GDFBJEDdl8eBOQ3TDp6qqAoBk51CDvM7FeE24XGcwqLnHWTdhkHbEeGe2y6DclI1c2qdYfRk77msJxLJxKR1mQyShh8LTORrh5Sv9dmmq9KtauBbglQ/d42QAUs2h1cX0qi5HD8x6NAA4eUtLfb26ejGKWbS486XSS7sjXCruUCZyXQjqMSS64oIjam3Rsmh1drOjZyokClae71bxk8D3FUULCi30e3G7jMb5nHrSdKID5Qk/lYJvBR4e1jH47JgtVS2VhL6NoHP+JhTnrEE4eImSDabIMuqKEMBTvvxRdkI+ZxfU9yvdJZ9vxaSM1DoCU3spR/A7BK2Ah+/FjgmoBaC6y3hTTWug2ZzNM3tzsaMRTsGcSp74Ge6K7cGxhMiZr88V7frdihHH1Wfag1goFsCGidFdV9dhnjTbuz6FFSr+j/bmkaER8KrX9Yv8h70EuzKXfQaCcKUZIenEAG736mjouHO/A2ceCDzaljRuGPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/9/13 21:29, Nilay Shroff =E5=86=99=E9=81=93:
> On 9/13/26 12:24 PM, Yu Kuai wrote:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> blkcg_punt_bio_submit() currently queues punted bios on=20
>> blkg->async_bios,
>> so it has to call bio_blkg() to find or create a queue-local blkg.=C2=A0=
 Bios
>> now carry and pin the blkcg css, so punted bio lifetime no longer=20
>> needs to
>> be anchored by a blkg.
>>
>> Keeping the punt state in blkg can instantiate a blkg even when no blkcg
>> policy is enabled, just to bounce submission from a shared kthread.=C2=
=A0=20
>> Move
>> async_bio_lock, async_bios and async_bio_work to struct blkcg, and queue
>> punted bios on bio_blkcg() for non-root cgroups.=C2=A0 Root or=20
>> unassociated bios
>> are submitted directly.
>>
>> This preserves the priority-inversion avoidance while preventing
>> blkcg_punt_bio_submit() from creating blkgs that are not needed by any
>> policy.
>>
>> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>> ---
>> =C2=A0 block/blk-cgroup.c | 52 ++++++++++++++++++++++++++---------------=
-----
>> =C2=A0 block/blk-cgroup.h | 14 ++++++-------
>> =C2=A0 2 files changed, 35 insertions(+), 31 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 59ccfefe16a8..aa3cee107ebe 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -180,14 +180,10 @@ static void blkg_free(struct blkcg_gq *blkg)
>> =C2=A0 =C2=A0 static void __blkg_release(struct rcu_head *rcu)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct blkcg_gq *blkg =3D container_of(rc=
u, struct blkcg_gq,=20
>> rcu_head);
>> =C2=A0 -#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>> -=C2=A0=C2=A0=C2=A0 WARN_ON(!bio_list_empty(&blkg->async_bios));
>> -#endif
>> -
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkg_free(blkg);
>> =C2=A0 }
>> =C2=A0 =C2=A0 /*
>> =C2=A0=C2=A0 * A group is RCU protected, but having an rcu lock does not=
 mean=20
>> that one
>> @@ -226,23 +222,23 @@ static void blkg_release(struct percpu_ref *ref)
>> =C2=A0 }
>> =C2=A0 =C2=A0 #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>> =C2=A0 static struct workqueue_struct *blkcg_punt_bio_wq;
>> =C2=A0 -static void blkg_async_bio_workfn(struct work_struct *work)
>> +static void blkcg_async_bio_workfn(struct work_struct *work)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 struct blkcg_gq *blkg =3D container_of(work, struct =
blkcg_gq,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 async_bio_work);
>> +=C2=A0=C2=A0=C2=A0 struct blkcg *blkcg =3D container_of(work, struct bl=
kcg,=20
>> async_bio_work);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct bio_list bios =3D BIO_EMPTY_LIST;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct bio *bio;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct blk_plug plug;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool need_plug =3D false;
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 /* as long as there are pending bios, @blkg c=
an't go away */
>> -=C2=A0=C2=A0=C2=A0 spin_lock(&blkg->async_bio_lock);
>> -=C2=A0=C2=A0=C2=A0 bio_list_merge_init(&bios, &blkg->async_bios);
>> -=C2=A0=C2=A0=C2=A0 spin_unlock(&blkg->async_bio_lock);
>> +=C2=A0=C2=A0=C2=A0 /* as long as there are pending bios, @blkcg can't g=
o away */
>> +=C2=A0=C2=A0=C2=A0 {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 guard(spinlock)(&blkcg->asyn=
c_bio_lock);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio_list_merge_init(&bios, &=
blkcg->async_bios);
>> +=C2=A0=C2=A0=C2=A0 }
>>
> Instead of using guard(spinlock)(...) here, I think we could use the
> simpler spin_lock()/spin_unlock() helpers. IMO, they are easier
> to read and reason about for these short critical sections.
Ok.
>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* start plug only when bio_list contains=
 at least 2 bios */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bios.head && bios.head->bi_next) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 need_plug =3D tru=
e;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blk_start_plug(&p=
lug);
>> @@ -259,19 +255,20 @@ static void blkg_async_bio_workfn(struct=20
>> work_struct *work)
>> =C2=A0=C2=A0 * cgroup.=C2=A0 Use this helper instead of submit_bio to pu=
nt the=20
>> actual issuing to
>> =C2=A0=C2=A0 * a dedicated per-blkcg work item to avoid such priority in=
versions.
>> =C2=A0=C2=A0 */
>> =C2=A0 void blkcg_punt_bio_submit(struct bio *bio)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 struct blkcg_gq *blkg =3D bio_blkg(bio);
>> +=C2=A0=C2=A0=C2=A0 struct blkcg *blkcg =3D bio_blkcg(bio);
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 if (blkg && blkg->parent) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&blkg->async_bio_l=
ock);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio_list_add(&blkg->async_bi=
os, bio);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&blkg->async_bio=
_lock);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 queue_work(blkcg_punt_bio_wq=
, &blkg->async_bio_work);
>> +=C2=A0=C2=A0=C2=A0 if (blkcg && cgroup_parent(blkcg->css.cgroup)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 guar=
d(spinlock)(&blkcg->async_bio_lock);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio_=
list_add(&blkcg->async_bios, bio);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 queue_work(blkcg_punt_bio_wq=
, &blkcg->async_bio_work);
>
> Again same here, replace guard() with spin_lock() and spin_unlock()
> helpers.
>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Never bounce if there is =
no non-root blkg to queue on. */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Never bounce if there is =
no non-root blkcg to queue on. */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 submit_bio(bio);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 }
>> =C2=A0 EXPORT_SYMBOL_GPL(blkcg_punt_bio_submit);
>> =C2=A0 @@ -350,15 +347,10 @@ static struct blkcg_gq *blkg_alloc(struct=
=20
>> blkcg *blkcg, struct gendisk *disk,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkg->q =3D disk->queue;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_LIST_HEAD(&blkg->q_node);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkg->blkcg =3D blkcg;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkg->blkcg_id =3D blkcg->css.id;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkg->iostat.blkg =3D blkg;
>> -#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>> -=C2=A0=C2=A0=C2=A0 spin_lock_init(&blkg->async_bio_lock);
>> -=C2=A0=C2=A0=C2=A0 bio_list_init(&blkg->async_bios);
>> -=C2=A0=C2=A0=C2=A0 INIT_WORK(&blkg->async_bio_work, blkg_async_bio_work=
fn);
>> -#endif
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64_stats_init(&blkg->iostat.sync)=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for_each_possible_cpu(cpu) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64_stats_init(&p=
er_cpu_ptr(blkg->iostat_cpu, cpu)->sync);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 per_cpu_ptr(blkg-=
>iostat_cpu, cpu)->blkg =3D blkg;
>> @@ -1399,10 +1391,16 @@ static void blkcg_css_free(struct=20
>> cgroup_subsys_state *css)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (blkcg->cpd[i]=
)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 blkcg_policy[i]->cpd_free_fn(blkcg->cpd[i]);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&blkcg_pol_mutex);
>> =C2=A0 +#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>> +=C2=A0=C2=A0=C2=A0 {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 guard(spinlock)(&blkcg->asyn=
c_bio_lock);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON(!bio_list_empty(&blk=
cg->async_bios));
>> +=C2=A0=C2=A0=C2=A0 }
>> +#endif
>
> This is a slightly different case. At this point blkcg_css_free() is
> freeing the blkcg object after its final reference has gone away, so
> there should be no concurrent context accessing blkcg->async_bios.
> Therefore, I don't think we need to acquire async_bio_lock here just
> to perform the WARN_ON() check.

Perhaps is it better just to remove the check? blkcg will be pinned
by any bio inside the list, so I believe this is safe.

> The clang context annotation cannot infer this object-lifetime property
> and will therefore report an unprotected access. I think we should
> explicitly mark this access as context-unsafe.
>
> But wait, even better, we could introduce a bio_list_empty_careful()=20
> helper,
> similar to list_empty_careful(), for this purpose:
>
> static inline bool bio_list_empty_careful(const struct bio_list *bl)
> =C2=A0=C2=A0=C2=A0=C2=A0__context_unsafe(/* intentional lockless access t=
o @bl->head */)
> {
> =C2=A0=C2=A0=C2=A0=C2=A0return bl->head =3D=3D NULL;
> }
>
> Then this could simply become:
>
> WARN_ON(!bio_list_empty_careful(&blkcg->async_bios));
>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free_percpu(blkcg->lhead);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(blkcg);
>> =C2=A0 }
>> =C2=A0 =C2=A0 static struct cgroup_subsys_state *
>> @@ -1447,10 +1445,18 @@ blkcg_css_alloc(struct cgroup_subsys_state=20
>> *parent_css)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_init(&blkcg->lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refcount_set(&blkcg->online_pin, 1);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_HLIST_HEAD(&blkcg->blkg_list);
>> +#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>> +=C2=A0=C2=A0=C2=A0 spin_lock_init(&blkcg->async_bio_lock);
>> +=C2=A0=C2=A0=C2=A0 {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 guard(spinlock)(&blkcg->asyn=
c_bio_lock);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio_list_init(&blkcg->async_=
bios);
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 INIT_WORK(&blkcg->async_bio_work, blkcg_async_bio_wo=
rkfn);
>> +#endif
>
> This is interesting. As you know, while an object is being allocated
> and before it is published, it can't be accessed concurrently. So
> guarding blkcg->async_bios with blkcg->async_bio_lock is not necessary
> here. Moreover, since blkcg is zero-initialized, we could simply remove
> both the guard(...) and the bio_list_init() call above.
>
> Thanks,
> --Nilay

--=20
Thanks,
Kuai

