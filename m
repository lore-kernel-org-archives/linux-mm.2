Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34CEFC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 23:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979646B00BD; Mon, 29 Jun 2026 19:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950FC6B00C0; Mon, 29 Jun 2026 19:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867286B00C1; Mon, 29 Jun 2026 19:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55EDE6B00BD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:38:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D22578D092
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:38:00 +0000 (UTC)
X-FDA: 84934565520.28.B690FEA
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6024640007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:37:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=TvvLgjYx;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=0lqeVIb1
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782776279;
	b=vmrojhGR6LB0UuUvJzZxozanmX2BMoYorjVserJqezXl2V6MpuVDIXDhFnUmsL1lsZcF4z
	xnzZxtM5QMdHIA0GWS3ZjtpH3Mv3jhRxRCPycqaJCbGTb4VdqjaA3go6KsBjoOE7VAkj+y
	WSWAzV4rJPV2xY36c1s4OV9XiE7Qm/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782776279;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=r3N05WABUxjytKJxPmXYrytCuB8skOuiqRM79EBtGdc=;
	b=cbBkMnD3b/eFqJqtXfn+C9m4Dav93ThWezImSJfI7JbcQAZTcdOPe0hMqyWk90Pu9wiV/t
	TVOuOSoD6o+QGO3IAGhOvYdkSlw2okcvf9syFE+jJXk2x/F9+SHXbYJCgcFDGheJGFf12Z
	DQOh1aVVSTYX8Y9JCixitaYjoLLIaeQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=TvvLgjYx;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=0lqeVIb1;
	spf=none (imf01.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1782776275; x=1783381075;
	d=konsulko.se; s=rsa1;
	h=content-type:subject:reply-to:cc:from:to:message-id:mime-version:date:
	 in-reply-to:from;
	bh=r3N05WABUxjytKJxPmXYrytCuB8skOuiqRM79EBtGdc=;
	b=TvvLgjYxV/KM4AHJ6JUwzFeXxDMwz0P6qiPQGgthdjblwXhOIivTpFv/ncSeUJjvy3WP4zlSG+gB8
	 dHhyHRVqgesTMTGWYAq+29UWOtFLmDOztVvPjpVLHiZpgvuZlMLofChjOiz5GTHRDdGEhQBIE2ognw
	 bNOJrAQdTThFhihRGhPMCBXHKj3qRaqJLKxdxir3qCU3/KpzpHaSjeWjfJgZaB0bf82Bgdf3h7uytv
	 wbfslpAbZw6sYWfUNxgboC/m+SruLbiI5vNB2VLSYzHJgi5BQB9OJqVYsnsz4X8GOX/k2/O3D1LG3h
	 rWmdJGYg5RhFId1l2RJmfmgr5cjqPLg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1782776275; x=1783381075;
	d=konsulko.se; s=ed1;
	h=content-type:subject:reply-to:cc:from:to:message-id:mime-version:date:
	 in-reply-to:from;
	bh=r3N05WABUxjytKJxPmXYrytCuB8skOuiqRM79EBtGdc=;
	b=0lqeVIb17nyKGcxM+F/5+mJgKxMwXsWNhv/dPqfXerjSYJwY4RzwyihwTlYwVWJMeRK0FwQsDmY7B
	 e8yRWN1CA==
X-HalOne-ID: 8d2a945c-7413-11f1-be7e-9957f5128d50
Received: from onecom-webmail-backend-production-6b65d856d9-hh7mc (unknown [5.249.224.11])
	by mailrelay1.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 8d2a945c-7413-11f1-be7e-9957f5128d50;
	Mon, 29 Jun 2026 23:37:54 +0000 (UTC)
X-Originating-IP: 2a02:aa1:104f:8700:65d3:12a1:e776:43be
User-Agent: One.com webmail 50.14.12
In-Reply-To: <20260625131738.b7c10540e5c598cc9b60e19d@linux-foundation.org>
Date: Tue, 30 Jun 2026 01:37:53 +0200
MIME-Version: 1.0
Message-ID: <1782776273700.7.121318@webmail-backend-production-6b65d856d9-sd7qj>
To: "Andrew Morton" <akpm@linux-foundation.org>
From: "Vitaly" <vitaly.wool@konsulko.se>
Cc: "Jens Axboe" <axboe@kernel.dk>, "Damien Le Moal" <dlemoal@kernel.org>,
 "Keith Busch" <kbusch@kernel.org>, "Christoph Hellwig" <hch@lst.de>, "Sagi
 Grimberg" <sagi@grimberg.me>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Christoph Lameter"
 <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, <linux-block@vger.kernel.org>,
 <linux-nvme@lists.infradead.org>, <linux-mm@kvack.org>, "Vitaly Vul"
 <vitaly.vul@partner.samsung.com>
Reply-To: <vitaly.wool@konsulko.se>
Subject: Re: [PATCH] mempool: optimize mempool resizing
Content-Type: multipart/alternative;
 boundary="----------121316-1782776273700-1"
X-Stat-Signature: i5xako6xg7ysgswz7u8eh8fc1wde8g9n
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6024640007
X-HE-Tag: 1782776278-970462
X-HE-Meta: U2FsdGVkX18zXWWuj/h5E+dv1HYtN9kf/yXRr9XHldQPHP6l+RMqoYVdYhX+H5tKMMYLvipxPo/Gg0rYwCDb3cWxLJHUhzDe4qR1RC0IQXymJun3AOAowTFwUe7Kipf5B7PjFjl+5EMS3tkjPGKW6aI5lpOL/dJKYPxkUvTMzBpqbaNGfVyzOS09xj4L2fVZOfa+JNSzb69IiAkDVnmgUJ6JdZ6FIPi4HU3laXNWk0JxbHgr76W32F77PcQjqBeUOSIfWGkkSt5Fdeq8dfIhDt/DPhxAkABDJXmpX1XOhw7iF9xLrfF+zIx2oE0U77lqBIHB3o1Lt+oe+QcxPA6l3rJdkhCsB6fImRhQJ4myEoJZ0GJgI9sctX541ZvcRORw+vqywsCgikexUNTgOqCrUldB/vA5CKTMNvPUU0+uX/twsIxvU49BQme6O4uu0veZqUPHsO9HpF53YSulgNvEk1HwyqxM3x7fnljXKtMYAGlWQ8/KXGNRbbtIT0VEQOTvOPWDlSP1xLa/5Ak0i5PW/rPwVu2u8FjOOf71HEdXSZl4D7VpC6Suvxv0m7vI5+yD8TbURXZz0gehut7VFGp2k5v4fAaOJJzfnkvx59cXuLHt4YBcW0caLcdMf+aAu43AejMq1O8Oj2ZgmfTf1dniEjRAY8uFZ3B2ZHtMGX1xelXCt19gRcfmUJknGDU7lsCSdl+hE7ZNNSRHInHKameo0a40YREADN3O6EUSHhuz6boI6ttWhUVoj1IQyAUJy+GmAm6DQScDL3Ep/FJhcqng6f8NSAAkUw3TGBYeko1O+5XC0oEeiRPjp4FkSk1AJBUqmSN/sfWel4q/Ml3WsEFrtlEsM1rIBuy/icSYg2e6u4m4Zs2ZedWVvLle5anxfLKzh+UGgPlkb9I7u8bG7OmVrrCQeHs9ynve+MlFu5kZXVdZWAat9Cyq1RlXM0R6nfaLe8pzi07M1923qcpcF3H
 zb3AeWMc
 KqfjK53xyKdOeTxl1APD9F9jgsI5WMqP5Bs8tiCNN78N1OYDOnVMX6fiPS4xdjMSxp1ESda1myNmi+MfopYI28Vf4MdtyuID28L7QPke6ekkbzpBynCibStdnslPeXEnIje3N5cnbejvAuzZmZXsU7ggXCHaIXqbl2PNzDNiO8pbmYb6Tj54y0eLmRnEW/6/apsxCf3ETH5/+cY6SI9BMAne3/mTxm3mBvWUP9E7MQZPbIz66kqtlF+eYPrlktI5ggQj7sMyaQ28z5Em68E/UjBtooIHFdUFn0xPFEQjul2duaWO5EKN1OAsHu4rNcOrGsnpuYoRdWeUPLYtfxYbuL7Hj2j9G0Whvcurdp93RyRg92G28cPPEC/W1waR1gVRbpPk72/qZKA9GCHV6wK5nU6+MeTgGm/1rKryCPeg7liHSUNSbGZHKZngYW1xFXGAon0/KL+V30+g1jiL5wThDqwub/W8om2GZEchB/v694o+5YO1c05RA8OIzf2TZZ2+ab08L1riyfwuaGUSHh2JJMWpO6Fvikjt9TiNs3eYrbSn7ayWSinVOunyOFmX6SbT3xjf9/DgDfAkTa3wEwxywoTNM8VA1EfsmAzn3i5hxUv6U78efvUBzSp2QzlE/kCDWM2snvcSlsaGjatELyhs/lJcf9x50qhHy5npW//eZPBiD/u0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multipart message in MIME format.

------------121316-1782776273700-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hello Andrew,


On Thursday, June 25, 2026 at 10:17:38 pm +02:00, Andrew Morton <akpm@linux=
-foundation.org> wrote:
> > On Thu, 25 Jun 2026 21:49:15 +0200 Vitaly Wool <<vitaly.wool@konsulko.s=
e>> wrote:

> >> > From: Vitaly Vul <<vitaly.vul@partner.samsung.com>>

> >> > Resizing mempool to a bigger size currently requires a new allocatio=
n and a
> > data copy to a new larger elements array which doesn't go well with the=

> > idea of having a fast and deadlock free memory allocations during exrem=
e VM
> > load.

> >> > This patch introduces a new parameter max_nr for a part of the mempo=
ol API,
> > which denotes the maximum size of the pool. With it in place we can avo=
id
> > any allocations in mempool_resize() since we can either grant the resiz=
ing
> > request or reject it basing on thr maximum allowed size of the elements=

> > array. For those few users of the mempool API that actually use
> > mempool_resize() it is a clear upgrade because the maximum number of
> > elements is known upfront.

> >> > Derivative APIs (like mempool_init_kmalloc_pool()) are mostly left i=
ntact,
> > substituted by the new mempool_init_kmalloc_resizable_pool() API where =
the
> > pool is actually meant to be resizable.

>> Thanks.

>> It would be helpful to have a description of what inspired this work.
> Presumably there is some observed problem in nvme or in zone-blockdev
> use? Can you please describe the problems and also describe what
> effect the patch had upon them?

We are using mempool for a variable number of large buffers, the maximal si=
ze of the pool is always known. However, as these buffers are large, we don=
't want to waste too much memory on a saturated full sized pool.

Besides, it takes a lot of time (seconds!) to saturate such a pool and we w=
ould absolutely love to avoid that.

Basing on the above, one can conclude that we're using mempool_resize() qui=
te often. And for that to be efficient, we need to know if we can grow the =
pool without having to re-allocate the elements array and copy the data.

Since all the existing users of mempool_resize() actually know the maximum =
pool size for their respective cases, the easiest way to implement this is =
to introduce the hard maximum, and that is what this patch is doing.


<snip>> Seems strange to return -EINVAL if new_min_nr is too low, but -ENOS=
PC
> if it is too large.

>> Also, (pet peeve), ENOSPC means "No space left on device". If this
> errno ever makes it back to userspace, the operator will be running
> `df' and wondering what the heck happened.

Hmm, I see your point. Let's go with -EiNVAL in both cases.

> Also, AI review had things to say:
> <https://sashiko.dev/#/patchset/20260625194915.387663-1-vitaly.wool@konsu=
lko.se>

Sashiko is doing a great job indeed. My 2c on that:

1. mempool_create() should create pools with max_nr =3D max(min_nr*2, 1); a=
nd this will be fixed in the next version of the patch.
2. There were no forward-progress guarantees during pool growth in mempool_=
resize(), this patch just makes things simpler and more obvious.
3.=C2=A0pool->min_nr update will be fixed in the next version of the patch.=


Thanks,

Vitaly

------------121316-1782776273700-1
Content-Type: multipart/related; boundary="----------121316-1782776273700-2"

------------121316-1782776273700-2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<div>Hello Andrew,<br></div><div><br></div><div><br></div><div>On Thursday,=
 June 25, 2026 at 10:17:38 pm +02:00, Andrew Morton &lt;akpm@linux-foundati=
on.org> wrote:<br></div><div>> > On Thu, 25 Jun 2026 21:49:15 +0200 Vitaly =
Wool &lt;<a href=3D"mailto:vitaly.wool@konsulko.se">vitaly.wool@konsulko.se=
</a>> wrote:<br></div><div>> >=C2=A0</div><div>> > From: Vitaly Vul &lt;<a =
href=3D"mailto:vitaly.vul@partner.samsung.com">vitaly.vul@partner.samsung.c=
om</a>><br></div><div>> >=C2=A0</div><div>> > Resizing mempool to a bigger =
size currently requires a new allocation and a<br></div><div>> > data copy =
to a new larger elements array which doesn't go well with the<br></div><div=
>> > idea of having a fast and deadlock free memory allocations during exre=
me VM<br></div><div>> > load.<br></div><div>> ></div><div>> > This patch in=
troduces a new parameter max_nr for a part of the mempool API,<br></div><di=
v>> > which denotes the maximum size of the pool. With it in place we can a=
void<br></div><div>> > any allocations in mempool_resize() since we can eit=
her grant the resizing<br></div><div>> > request or reject it basing on thr=
 maximum allowed size of the elements<br></div><div>> > array. For those fe=
w users of the mempool API that actually use<br></div><div>> > mempool_resi=
ze() it is a clear upgrade because the maximum number of<br></div><div>> > =
elements is known upfront.<br></div><div>> ></div><div>> > Derivative APIs =
(like mempool_init_kmalloc_pool()) are mostly left intact,<br></div><div>> =
> substituted by the new mempool_init_kmalloc_resizable_pool() API where th=
e<br></div><div>> > pool is actually meant to be resizable.<br></div><div>>=
=C2=A0</div><div>> Thanks.<br></div><div>>=C2=A0</div><div>> It would be he=
lpful to have a description of what inspired this work. <br></div><div>> Pr=
esumably there is some observed problem in nvme or in zone-blockdev<br></di=
v><div>> use?  Can you please describe the problems and also describe what<=
br></div><div>> effect the patch had upon them?<br></div><div><br></div><di=
v>We are using mempool for a variable number of large buffers, the maximal =
size of the pool is always known. However, as these buffers are large, we d=
on't want to waste too much memory on a saturated full sized pool.<br></div=
><div><br></div><div>Besides, it takes a lot of time (seconds!) to saturate=
 such a pool and we would absolutely love to avoid that.<br></div><div><br>=
</div><div>Basing on the above, one can conclude that we're using mempool_r=
esize() quite often. And for that to be efficient, we need to know if we ca=
n grow the pool=C2=A0 without having to re-allocate the elements array and =
copy the data.=C2=A0<br></div><div><br></div><div>Since all the existing us=
ers of mempool_resize() actually know the maximum pool size for their respe=
ctive cases, the easiest way to implement this is to introduce the hard max=
imum, and that is what this patch is doing.<br></div><div><br></div><div>&l=
t;snip></div><div>> Seems strange to return -EINVAL if new_min_nr is too lo=
w, but -ENOSPC<br></div><div>> if it is too large.<br></div><div>>=C2=A0</d=
iv><div>> Also, (pet peeve), ENOSPC means "No space left on device".  If th=
is<br></div><div>> errno ever makes it back to userspace, the operator will=
 be running<br></div><div>> `df' and wondering what the heck happened.<br><=
/div><div><br></div><div>Hmm, I see your point. Let's go with -EiNVAL in bo=
th cases.<br></div><div><br></div><div>> Also, AI review had things to say:=
<br></div><div>>=C2=A0<a href=3D"https://sashiko.dev/#/patchset/20260625194=
915.387663-1-vitaly.wool@konsulko.se">https://sashiko.dev/#/patchset/202606=
25194915.387663-1-vitaly.wool@konsulko.se</a><br></div><div><br></div><div>=
Sashiko is doing a great job indeed. My 2c on that:<br></div><div><br></div=
><div>1. mempool_create() should create pools with max_nr =3D max(min_nr*2,=
 1); and this will be fixed in the next version of the patch.<br></div><div=
>2. There were no forward-progress guarantees during pool growth in mempool=
_resize(), this patch just makes things simpler and more obvious.<br></div>=
<div>3.=C2=A0pool->min_nr update will be fixed in the next version of the p=
atch.<br></div><div><br></div><div>Thanks,<br></div><div>Vitaly</div>

------------121316-1782776273700-2--
------------121316-1782776273700-1--


