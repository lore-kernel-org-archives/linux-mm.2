Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F8EDC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9E26B00B0; Fri, 18 Sep 2026 05:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BA36B00B1; Fri, 18 Sep 2026 05:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798B86B00B2; Fri, 18 Sep 2026 05:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC446B00B0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:20:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E03AA1C2CA9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:20:15 +0000 (UTC)
X-FDA: 85226336790.18.B3429FB
Received: from va-2-53.ptr.blmpb.com (va-2-53.ptr.blmpb.com [209.127.231.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20F22140004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:20:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=bwBSdZ1I;
	spf=pass (imf09.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.53 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723214;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/HoGHos08YYVCDf+erQy3ROLdbEA8DrOr1npGBRCuw=;
	b=T3qBBTVLJNGJWaUfsCfTCaJIe5VZIK2rDJIBORp1pgC0yzmk1EvOZ/ba/vNIEfBlIYZJwr
	LJvRKYm+/5MI1t9LpeOXzdslrn7KqKFQHsyy2MpAwpQpg5ZjRJsl/POAcDwjfHpiFbkUQZ
	NbO3Kb29iL/xpNjS3F3+xGXiUApEmQU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723214;
	b=CwkiRO4pOdsoq5InXvDVBuEc5Czr9E6gOUxgRJMG/NFECTcEcFO9X9+AyOySKZyKoONNjU
	hZDtyiCEUvxAM/1MQ0SI8Pww5nylVIkZv1ZZdBgufXiNYx5rL3sfPwhQVvy9g88/eec//w
	NcTpH5oSwwVoRuG9HCuG7v16haVF9k4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=bwBSdZ1I;
	spf=pass (imf09.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.53 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789723203;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=c/HoGHos08YYVCDf+erQy3ROLdbEA8DrOr1npGBRCuw=;
 b=bwBSdZ1IC2vZJtJQ/GMrgZtFKRuuaPwCdBnsVuBZK6OAE/8KLo1qyhHqMMucszqIQ+NkQ2
 HU22scbIi4juP7uDQoN2yJO1G9pAH/o3M11JKl8GQa+S1r5Y8BMJwBwEJhOfbqphjVZxdn
 4yJH4AnELbXL5Ej/uTa6zIxHk/LQAYt4GP5OAuLG1IzbfNdiAQ/oxgQ4h14NALYiEW2F81
 ZWkWZwb9JqbvgqODZjDQttxI64Lhn4YXAABcOdUvpIV5upKvcA6VJysv/TxG7WPbSXtXFa
 VdB7sBO5K3nkoNbXDSVcHsd3NaAQP4MUtRi2ofcw3DZ/hzlSesbtohAXVw9SsA==
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
Subject: Re: dm review needed, was: Re: [PATCH v3 2/3] blk-cgroup: store blkcg in bio instead of blkg
Message-Id: <daf4ba77-4c25-4993-900d-ee1fe713d9b6@fygo.io>
In-Reply-To: <20260918071634.GA10884@lst.de>
X-Lms-Return-Path: <lba+26aad0242+e159fd+kvack.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Date: Fri, 18 Sep 2026 17:19:53 +0800
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Cc: "Jens Axboe" <axboe@kernel.dk>, "Josef Bacik" <josef@toxicpanda.com>, 
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
	"Justin Stitt" <justinstitt@google.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, "Tao Cui" <cuitao@kylinos.cn>, 
	<linux-block@vger.kernel.org>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	<linux-raid@vger.kernel.org>, <gfs2@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<llvm@lists.linux.dev>
From: "yu kuai" <yukuai@fygo.io>
References: <20260918041744.1526924-1-yukuai@kernel.org> <20260918041744.1526924-3-yukuai@kernel.org> <20260918071634.GA10884@lst.de>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Fri, 18 Sep 2026 09:20:01 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20F22140004
X-Stat-Signature: xfftcpjmb73qjnoege4xbz3jph59q4bd
X-Rspam-User: 
X-HE-Tag: 1789723212-493239
X-HE-Meta: U2FsdGVkX1/hBEMgNy/J1+NiDTPas2F7m2IMiFIfdNkbGTjbL+lLAeobZuZhURUY4nYzzDBK1bdaKUM3lfKT0S+yku8jj6xDNZkmeM9aFy6VFD/bKV8LaQZOYQodTTBklM+fg7sa0l0cx3J/qT4nu2Wg1PL85kM4VAoemgsPruPDHIG6++Po8UPsJEHP3bSklULMyy2gl4HqWJYdFY8wo4mjKIGPz10lPOuWaYjgnCFD4aBMDXUwSXGDNdXvBeq232ehECyVpP7c0Odt8c1taJH1G9g7+jYDC3753EXlteRrN156zatsVckgcGa8r1XEfy5vjWFYscdfLC+agI0Laq1MxM/s/3REyI9T21q0ch6z+4Kszyqv/xo9Y23ETrs4XkKC1UhOD7CJw5Coc95KBEBpMcuHmVZ2z6HwV/dqhLTMpAYE3dG+sNdddeYP6aAGsJsNf/zXzzNr6ALuDrbUdTaDOzCLUwoExuv8NuqiWxpf569Zj4s2knm3O7eN9o/CyxvYGlLH5JNaKXvTq9foMuXk4UPe+sTvFbcriawdm2qbytb4S0U+c2SlEFzoZ9xq/RRABFAymjcLikBYvIdUCEQLrJa9znMiHG+6ohrON79NmZrsiyjU2qZlqlnUIQIEk2WcojQEZk++PzfVgKxX9y6CB1MBjH45b+to6ECEKN9RDw5rOaYIP5St2De2tteCk/I4ZpySbPpXN6J0ThCtRP2Gc3wpqalGYLeKV30OuOM52UDHPgR6JqpM2AOU8B6Qax9aPL/2KUg+5itUgQ90HtrrhUFGse7yE4I4sGs+JGhUZLFno0sco+TyalXfOaqcfP+GKSYzOAIwXrYMiPsTZP7C4vs7DKTcW6Rg+I7pVzpO0lSX8KxsF+9HuUdwDtbn/VOULMwkqh/c0DkG2Ptu8h2fFM5mEzLlwpW0tJ2Id1UXvKEfBnAPoYJHVjywcxg09navOaTvhB1LCoYCsbL
 VsYUwse3
 XrWvZS/47qgFnjfUQsk7WGRDXmeDvghrV188xJWwc/1ARpyxuiZLNVvURsxaxmSwWEVaowecaiRtV9h7dk/3IyjR6YdTjT3XKL4d5wZJVBmYH1AGg0NaN0t5RxuEXs/+zDCytCtLDzIQKoCDCbIoyETFOwCxbeSXvEw+GzmZjc6Z3QNmXteFbVHZ1QX9hrq2bvPGKolRR0h048hjC4+6N7QN44z3O7IkkqiVdqmIg91GhL/m5NYMn52sYnNsHarqd+fwMAyKN24ejbFLIVjg6zOctnypgBrZjYhROM5rjvt8/c+KbOlkrGaVEYgySbsW4+6YodD+AabwAXlR/LyrB8c48PISY4ePlZ6Kd7daf6OoNbjl2eTy7t/fLC5ZIUAhid1WUBTGHyq+VdrhRhzl9hEU35eHZHwqY3ulxrsAw3g4NbOxUlefap9po52rCfIgspM3md4gIaJVwLn1rYyfuXtYY4HblGbX3FSdRcu38cXKRxc2U7mg5BW9ew1JOMY7lkExFUVNSTwwkSXb3W6BfWQC2Ly2Ue+IRb/C5sJkINw1bgos3FQ61WeFuSJqqetTBpSodytCiev6HFVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/9/18 15:16, Christoph Hellwig =E5=86=99=E9=81=93:
> On Fri, Sep 18, 2026 at 12:17:43PM +0800, Yu Kuai wrote:
>>   static inline void dm_bio_record(struct dm_bio_details *bd, struct bio=
 *bio)
>>   {
>>   	bd->bi_bdev =3D bio->bi_bdev;
>> -	bd->bi_flags =3D bio->bi_flags;
>> +	/*
>> +	 * Restoring BIO_BLKG_REF would not recreate its associated reference.
>> +	 */
>> +	bd->bi_flags =3D bio->bi_flags & ~(1U << BIO_BLKG_REF);
> But do we need to restore the reference?  I have to admit that
> this surrounding code is very confusing and I would really like
> to have the dm maintainers look over it.

dm_bio_record() will store the bi_flags for current bio, later the flag is =
restored
by dm_bio_restore(). For example like dm-raid1 read error path:

issue path, if blk-throttle is enabled, flag can be set before bio issuing =
to dm-raid1

mirror_map
  dm_bio_record
   bd->bi_flags =3D bio->bi_flags
   // contain the new flag

bio_endio
  bio_clear_blkcg
  // new flag is cleared
  clone_endio
   mirror_end_io
   // if this IO failed and there is another mirror to read
    dm_bio_restore
     bio->bi_flags =3D bd->bi_flags
     // new flag is set without get a blkg reference

So I think we don't need to restore the reference, BTW, there is another ap=
proach to
avoid such problem in blk-throttle I don't take for now:

For bio entering blk-throttle, we can clear the new flag and blkg reference=
 directly
after the bio is throttled and before this bio is issuing to disk, because =
bio will
not enter blk-throttle in the completion path. And since blk-throttle is th=
e only rq_qos
policy that can be enabled for bio-based disk, then dm_bio_record() will ne=
ver see a
bio with the new flag set.

--=20
Thanks,
Kuai

