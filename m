Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24FEBC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260646B009F; Tue, 22 Sep 2026 11:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F936B00A0; Tue, 22 Sep 2026 11:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7AC6B00A1; Tue, 22 Sep 2026 11:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5AEC6B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:01:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5893AC0504
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:01:04 +0000 (UTC)
X-FDA: 85241710848.23.C9F7419
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0DBB38001A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:01:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="YQoRql A";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790089262;
	b=m0uCe3BUibGUmHETZLFwGRg4VsxF6uAgE1zUoVOAj2dHmXpRTy0mS69+YU/JUivbhMcz5u
	eVaY/LMbcvpy8vj7fM4ltRKE5GpDRCK1ZLgSTUfKmNDg9S4duqH36zClboJbISkn5QD7rq
	f/DXo1uYdIkXdMmv82Lx78o3xg82hKs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="YQoRql A";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790089262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9S72RBMdjKlGss9mb9QgY9VhBDc0Yamlp03VJXCTdA=;
	b=7pQq3eDTEiIHlwP8GDsjQa9iaQP0zfK+FoHW6DSd3dSLrkKlkzMmiJQswXLIdvka+G7JxH
	JMU/CnMpHioi/lsd4nZYZlvsmQ+xuBnKgNKzqj7bvbJh5Bn2+/GBfifpeQrj47tZXJPhb6
	kvv6SxSkQIFgMVUUozu0wKOWzn/V8o0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=o9S72RBMdjKlGss9mb9QgY9VhBDc0Yamlp03VJXCTdA=; b=YQoRql
	ATNRjzSo4tfzLdp8oYsJ0SvBo1KTkLRqt607qaRNIvZ2g5JQZuzVCCEgFUjtMz2VquD3wY+AMg03s
	/pm4eJ6ErM513UHsfCnseVUbDT86OYiWIRa8h0P6NXg3+LAhEo6ylCVcwWFhzpbyIMTNRhFPWyeq0
	hWBWdEjCNUkOW5W5/W59QZP7jZzWOwgOWWY5wAzg9ZF9054eS9BwWjP5HzWwQPqZH86424rLqk1kC
	X7S97UVBAZ3mBmrQdELqnPf8Lx8zaldeifHz6Phqmos5P/hL8+biEoETKDmEMS9xUvaoV0FpR52yM
	AmqO85Udz53r5fw7ZGrY40pSaY+w==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x91xb-00000001f8a-2YPQ;
	Tue, 22 Sep 2026 14:59:07 +0000
Message-ID: <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>,
  Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Kairui
 Song <kasong@tencent.com>,  Michal Hocko <mhocko@kernel.org>, Roman
 Gushchin <roman.gushchin@linux.dev>, Shakeel Butt	
 <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, David Hildenbrand
	 <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, Kemeng Shi	
 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, YoungJun Park	
 <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen	
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu	
 <weixugc@google.com>, Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet
	 <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Kunwu Chan	 <kunwu.chan@linux.dev>, Meta
 kernel team <kernel-team@meta.com>, Linux Memory Management List	
 <linux-mm@kvack.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, 	linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Tue, 22 Sep 2026 10:59:05 -0400
In-Reply-To: <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
	 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
	 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
	 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
	 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
	 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
	 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
	 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
	 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
	 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
	 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
	 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Stat-Signature: w51o8hat8ztssr9xxhnw6tn5z37xuxw1
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DBB38001A
X-HE-Tag: 1790089260-944056
X-HE-Meta: U2FsdGVkX1/6P+s/Mp5ZaVu/9Qw3o1odMuE7Kq8Jbw/80pI9T5YBvz0s9MObXrA8j6xBMZw8hfBy6cw15DeR71Px/YWgPXZmw5MTjXF6C+9nNGyl733lvldrzZjTsvBkpFjiRDm46b0zMHgQfP240rXHogUF/nDkxbQuS7BLOoXZzcLjE0lX+iVtjrknKydJQ5QsM84RqTjgEo1h4JQxJyaZF7SeB3MeKZZjMFNl9x+JJjqoGOGyVBgBdceDKVDShJX4oZSu4VjUdRhxcE4oo9g8C2+D92lezF3vSvTHTdRn4beDD5Z06mRoDpVsalvl+2jU90+vg2CbM3QE9++bRmo2MTIrE/r2byVumYdauUJk18ifekG/hUph6chp9BpCQJTmC37i/JqpVObEjXAyR+MXbROCSU96wBBXAmeauGpMz1I4yhKt1z7nFTCugH1kw2jl+SvrXQZev1DrNTQ/5GPmBuCLFh67rFhurWtuCceLC1pd+aUPD2+vZVgSmu46DfeaGjgqUq0Ec90YBQuElmmRkGHkU9dGqJiXxouTxsdPzSLwtbK0IMrc5KNRiq4cvAdk5fq5sZO9deNCJfk1+zSHk91zOr+ZVeGVpdHQuUMowHiljO22NyLAkDS9R2EhSClaT3KCr2hCDoqghdS55sgL/NUUtZ5YsjksouoRtH+HkVkccmo57LnuAGtZbGnNcCNtaZRk/WpXVo1qO26G6WTOJlEspIRniBs/HJLSd3OysDazOIMSfQiZ4O0VpdTiULsQds0W2/ln09qCoLo48GXaftEHa/6hAzfhNixqW/A7UtpRTv6geoDYKDkbv9g4+uFS4FWORrwOaTQd6zOlfMZw//uSqIjDMQfS9t/ov+ktZLiD+BUS0JG6lQKT2xly1WoDFk2aL46d8/j6+6Uwad60EAqmGroc/shAPiKdizhpKe9COHPfEekVwCqVDQZW0He+giffhdd07xkLlTd
 Vimo7keR
 v1XLKK6FZzv2cbNtodlSsffGq8N5XWVLh5W9wb5Z2EmIVCO8FSC+BFFAZfeTo9PWyVO7lTZjlVpIZfqLus2+hluBTEpgsXAnSBddi+k/dQ0SJV1GVGgPM7iX1/Z0KMcPZDRnP11Y/VSnuimoYKBRPHgJB17aRZSKVPkOGacrp5vHYO9p3FZthxeCbBrmo5IwUU1Z08q6W8jYyGxmvzYFqSPfUnAXafzi4AATSva2zqE1F5/VBbOmDYJ3EI4D7BzTdplvcO31GtutLDgUVHCnr0LBFgUFcqiKYmRTZH7wXxmxZ6pbEKum1HRqLPH/zLZH1EG7lC23VyWRBWvSpbdIH/Q47tZG3vOq4IdXuH5HQtuDrxrF95YhZl16VGZo4Co6XPPYuiVUrhcWjdxugZ5J/0lEcPIczHLaUk+nhvR9GENDaeTjKlPBT1AM7OzFguTXSG+TMzQBceMpHOgep5EgnSlz0a2x5eUlZW1l0dIDkLvqhx+eiFEKEi19gWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-09-22 at 03:32 -1000, Chris Li wrote:
> On Mon, Sep 21, 2026 at 8:53=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > On Mon, 2026-09-21 at 08:10 -1000, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 6:40=E2=80=AFAM Rik van Riel <riel@surriel.co=
m>
> > > wrote:
> > > >=20
> > > > On Mon, 2026-09-21 at 06:31 -1000, Chris Li wrote:
> > > > >=20
> > > > > Give me some real-world examples of people hitting this kind
> > > > > of
> > > > > limit.
> > > > > e.g. MAX(%)=C2=A0 > 100% and still have a usesable system. I
> > > > > suspect
> > > > > that
> > > > > with 100% zswap usage, the system becomes unusable. Please
> > > > > show
> > > > > me a
> > > > > real world case that proves me wrong.
> > > > >=20
> > > >=20
> > > > Here's my desktop system right now. The amount
> > > > of Zswapped is more than twice AnonPages, and
> > > > the system stays perfectly usable.
> > > >=20
> > > > $ grep -E '(Anon|Zswap|GPU|Swap)' /proc/meminfo
> > > > SwapCached:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 252340 kB
> > > > SwapTotal:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 41523604 kB
> > > > SwapFree:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 9802088 kB
> > > > Zswap:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
8812236 kB
> > > > Zswapped:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 24927876 kB
> > > > AnonPages:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 11615760 kB
> > > > AnonHugePages:=C2=A0=C2=A0 1402880 kB
> > > > GPUActive:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 13112428 kB
> > > > GPUReclaim:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 95980 kB
> > > >=20
> > > > This is also an example where I cannot really
> > > > predict how much zswap space I need, because
> > > > that depends on what AI model is loaded,
> > > > which drives the GPUActive number, as well
> > > > as the number of browser tabs.
> > > >=20
> > > > The system is perfectly responsive.
> > >=20
> > > Great, that is getting somewhere. We are talking about actual
> > > usage.
> > > I
> > > really appreciate that.
> > >=20
> > > May I ask what the total amount of memory (RAM) in your system
> > > is?
> > >=20
> > > I am not asking zswap compare to ANA memory. I want to get the %
> > > of
> > > the total RAM.
> > > I assume your desktop has more than 8G of RAM, right?
> >=20
> > Right now it has 64GB of memory.
>=20
> That is exactly my point. You are running 1/8 =3D 12.5% system ram.
>=20

> My point is that, I haven't seen a case where the application is
> still
> usable with a reasonable SLO when 100% of RAM is zswapped out.

In my numbers above, the applications have 11.6GB
AnonPages, and 25GB Zswap.

That is about 68% of anon memory stored in zswap. Not 8%.

Out of (anon + zswap), zswap takes up 43%

Can we at least agree on the observed numbers?
> >=20

> > hen the amount needed to fit a workload
> > does not have a positive correlation with
> > the amount of system memory?
>=20
> It absolutely has a positive correlation with % of the system memory
> based on my experience. The % of memory swap out has a very positive
> correlation with the thrashing on the application.

The applications thrash much harder once zswap flows
over onto disk! Out of all the swap options available,
zswap is the fastest, lowest latency one.

Forcing things out to disk "because too much zswap
is slow" could just slow things down further.

Now, there is probably some upper bound where
the zswap pool itself starts to hurt performance
because it's crowding the applications out of
memory, but that could be quite large.

--=20
All Rights Reversed.

