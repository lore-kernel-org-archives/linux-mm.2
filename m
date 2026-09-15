Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D554C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C2D6B0088; Tue, 15 Sep 2026 11:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D856B008C; Tue, 15 Sep 2026 11:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FDFB6B0092; Tue, 15 Sep 2026 11:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA2806B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:43:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79D6C40486
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:43:54 +0000 (UTC)
X-FDA: 85216417188.29.B45B961
Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	by imf30.hostedemail.com (Postfix) with ESMTP id 79D8780004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:43:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=B6MVj59H;
	spf=pass (imf30.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.60 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789487032;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0n1MM6xxPsL/QERF+JcaetyUJsQd2U/h4AXxBLwz/w=;
	b=JLkTt9SVRMz0wnflu2i1S1IGUU9+PwzfNFWr8aa3IZsBbkdBLJasJV+RszEgFQV+JMcvCL
	SRpmQfGuUoJbrCmF/6Q3RTPvq+f66leGzRHh86psF0oz2ht2BRpmAE9G/OnVsIOCcBrRsh
	o/8zMOw9hj331dJM6vALx/G/Tn7V5Xg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789487032;
	b=8CPsBifYbGKrF6oEds9MzVAm2KMAi7jxSJwag80UzqzyYtnzRShh63B6FgSVFjIXv00PyM
	DuXTAUcQFFHm7TZhRJjUQkEU2EBLGbs/JKy0i5By+0AV4bdJhi5XdoHegEEds7gduzntux
	Gn5qCv44TLYyytck+BOaYNHiSlB5Jjk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=B6MVj59H;
	spf=pass (imf30.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.60 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789487021;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=d0n1MM6xxPsL/QERF+JcaetyUJsQd2U/h4AXxBLwz/w=;
 b=B6MVj59HlXMtOl9z0UjxaykEi6EDlwYrZpg3+azeNsjmlpkldNvo5mobKCZZv1eXwr4mtv
 9A/Y4ZX3nMUA4AYjNaZVH/8Pnb14vPpnCo2BzLFHD7Cxcc70Za102PyiI4r8dbT3K3tpnS
 aVdq9L21zpwR5njcl2hcfzQMed0pXoPyXHN5De7q+YIlOHcFB9KScaL9M4JfXfqooGxEuU
 GBCRAKKS7IFjJcGpkXh58DsVFdz77mf3WnJF9pP3pEXR+16DL40JlhwyTzZ1wkrPT8a30D
 7NMFvR+/dPVMVkI0zF0rHfhZSi6maqm2jnlsqQosfannu5FM7qlEz/nT3+EPlg==
Reply-To: yukuai@fygo.io
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26aa967ad+ff1781+kvack.org+yukuai@fygo.io>
In-Reply-To: <20260915064950.GA13417@lst.de>
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Tue, 15 Sep 2026 15:43:40 +0000
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
Message-Id: <06e3c977-461c-4469-80ec-b9f54aa51eea@fygo.io>
References: <cover.1789237876.git.yukuai@fygo.io> <ef547fdb7a6c8e39a25a1b9473c444f24a0f03be.1789237876.git.yukuai@fygo.io> <20260915064950.GA13417@lst.de>
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Christoph Hellwig" <hch@lst.de>, "Yu Kuai" <yukuai@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2 2/3] blk-cgroup: store blkcg in bio instead of blkg
Date: Tue, 15 Sep 2026 23:43:32 +0800
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79D8780004
X-Stat-Signature: 7hzujqphzroqqcaiqg64nit8rwj1xmzu
X-Rspam-User: 
X-HE-Tag: 1789487031-483286
X-HE-Meta: U2FsdGVkX183ZrkqsJt+IMPMeqtCPlvE7bpf5PmePJSCIzRP/SMB+FMxd1ENcWXM5KjroNKf6f1lMSn18I/nh9/NGitq3cUTEJaGbwOsOM/ivk7cOjiLbaizP0ap+VP8BdsLX+Wlv4gqvwTE8Ea0HNamEHPnnsElydFgZAAgaSPfh6nRaIBUVpbkaqw1c+s6JPNt5syyEo6wsr0UdkzIcCjGT0wNgmUcpPVhOzuGarD3pCnL1pAx7/4ExE47rk3w9jywok3IOkCRvg80XB1J3JokAz+G1P8OjA2HSKAdyKIDgGSdBkr3CPgpPnTuo9diBqBVh8btXoYZuw/WRW4FHMdHY2d+lBfLoJE3sRnPfLENkpmz/YdbV24GVMNZG+N/TpCskUTcs+lnyGnaxZtjfEa/kOYJU4by/7rJ42DbufaaUtDPkoIoFR6QbXCqlmL34h9ivxwpTPjy6I3PTm6C/wjala8TewLfN/irgZ5kc4wf2s0asMJqYKR1Th4uNcLwssFNFTAuFgaZDG9vpzLm/WjulQ1RFR/Aa66D/cQ9YILEmuA5RhfCpbNBPmZRJ2B+40ModRQLKV6pcOsIB3uwIYRv7trZQiOd+4i/O6/oGRW+dBpUwYey+vV5UGmjLeIU35qq+ieCnJlm9XHEwEv8aYT+9n+/NcBtZVa36fPXolJQy5amLBK7tdemri4GR/dbRygqLmEJPN9pp9Fys3imj9wch8Q95WtUnOq54I1ojmgJitEbguu58/2kP9F0UaB18rTAkrhkZteNckxR9wjDIqq+g3kf+glkwcJnj+fGAQpQAXKIaQl+ezq/wS3GH5bMd8JKmjaHBa2M8cnYLeS7tDy8/sskls7y4DFZI+uMO16iELtZh0kcDozVTunPkbGtCZfZ48U2NrnqNVxf7rXBI6mAxiossWjZNHs3k7O/HI1JbW+//9bkVm9BfE4i3lHrts2uYH2NVX3K4245apo
 oT77ZzQM
 +Gj0Dyuc6LqxooUmtS0NsSsxIGEVIvrJU/VrWXRRuSB/sLwM96qKwRKGNmmgJdykNCx39XDNYbDBp3Bc379R7aO38PPvcuECa/12e1Kt6p18h4dp1UyBGuZLls6J/xUfDLTVBQtaz2ISSJ+E1NKhbX4eDTvB6lm9spcLfhJqLzlQAhUt97zQtINbYb4ZyI9kVsHzRT8CmiHmxVGy+dbYUFgL3aTvzgmtrvjSJDX52Nv8Na4HpMSgJbYZWps18TiY5OHbsb7Vca8TavwoMTdmYqbK1dFy26d0wmF30cgH88W824zFizPsq9e5bet4JIKUoeKzXi4K1ruJ9DQkroubdYG/E6MdRROZy+wISBSxf5dgd4bskye+NCD6CnyLVkt5cu4H7kkxTfDRzE1a/XfKLMQ5dx4reLqJpBZUGuJfC3vFmwsWPn+ty4ipyPxqojc15D/zdstq0NNx0HBWuLG8EST0O8TJK1E1lc0raodt2/f2TRU+qlcCp6rBso0aWmmVUdPyIsFvKS/vwJOpfov7ENFHe+slRrAO3a6c1eeO1WqEeLMcXOKx0KnJSTBlG1i7JA9moM1PvX+MSVNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/9/15 14:49, Christoph Hellwig =E5=86=99=E9=81=93:
> On Sun, Sep 13, 2026 at 02:54:39PM +0800, Yu Kuai wrote:
>> @@ -6243,10 +6245,17 @@ static void bfq_insert_request(struct blk_mq_hw_=
ctx *hctx, struct request *rq,
>>   	bool idle_timer_disabled =3D false;
>>   	blk_opf_t cmd_flags;
>>   	LIST_HEAD(free);
>>  =20
>>   #ifdef CONFIG_BFQ_GROUP_IOSCHED
>> +	/*
>> +	 * Pin the blkg used to look up bfqg.  If this is the first IO for
>> +	 * the blkcg on this queue, create the bfqg before holding bfqd->lock.
>> +	 */
>> +	if (rq->bio && !bio_flagged(rq->bio, BIO_BLKG_REF))
>> +		bio_blkg(rq->bio);
> Can rq->bio be NULL here?  flush or empty passthrough request should
> never enter the scheuler.
Yes, rq->bio should never be NULL.
>
>>   	if (!cgroup_subsys_on_dfl(io_cgrp_subsys) && rq->bio)
>>   		bfqg_stats_update_legacy_io(q, rq);
> But I guess given that the code below checks it, we should at least
> be consistent, so I guess it is better to keep it for now.
>
>>  =20
>>   static inline void dm_bio_record(struct dm_bio_details *bd, struct bio=
 *bio)
>>   {
>>   	bd->bi_bdev =3D bio->bi_bdev;
>> -	bd->bi_flags =3D bio->bi_flags;
>> +	/* Restoring an ownership bit cannot recreate the associated reference=
. */
>> +	bd->bi_flags =3D bio->bi_flags & ~(1U << BIO_BLKG_REF);
> I have a bit of a hard time parsing this, the line also is overly
> long.

This is an issue found by AI, if the new flag is recorded to bi_flags, and =
the flag can be
restored to new bio by dm_bio_restore() without actually acquire a blkg ref=
erence. And I
checked this is the only place to read/write bi_flags directly in driver.

--=20
Thanks,
Kuai

