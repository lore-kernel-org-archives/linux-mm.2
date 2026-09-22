Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AC2C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499FB6B00AD; Tue, 22 Sep 2026 13:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470CA6B00AE; Tue, 22 Sep 2026 13:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387446B00AF; Tue, 22 Sep 2026 13:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 022826B00AD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:15:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80D554056D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:15:35 +0000 (UTC)
X-FDA: 85242049830.20.5210293
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id C868B2000D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:15:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="hqU0CB y";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIvSiXa3+TYx7bi3V5dw42Ue3KZMD0siULIfE/dvEQI=;
	b=Dvn9FByi6tHMBFSONkCFNNvv7VBRwm0lr35O0j+XoxGyTgQX7HhnICotiSAOC+dEgCKuHm
	BJ2OOxvyYXeEISuNPbXixOBJbAJcjKh5YWNFNYRScnPLUiKsjmp6lYv53ohf+GroheLfkB
	XdJzUBvaeE0rhqSQeWma3vPzBm6l5/o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="hqU0CB y";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097333;
	b=MGt9ck7EiveHGKOxm7UH22QwFhqWVqXUj8alBvToR2ZMElsWf95blNbm7xFuiijIiYS+Fg
	TJUCAFEjUcA9gcIZ5cBobrZt7/8qo3AOTxnNcrFz40Rp/gRt4ifdy/64vIvodo47VEvQt/
	q6r7MUSE7ljkPjRuqSCCihZ2lUEpsO4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=aIvSiXa3+TYx7bi3V5dw42Ue3KZMD0siULIfE/dvEQI=; b=hqU0CB
	ySEEvdprfEWb4xkQGlSn5w5HAV/81c1nWMKXoCFV55o1L37ZqwMu/yLZKBSdEWulJow0fgW1ASBzY
	akE5fpIwK2d3Cm5JM6y0v9JOjic5dzKmjiu8B2tTMnwD+ANo53TYLzNHPueeDA2khb7BSrcIZNizZ
	tVYFnVzuAMxjRvQKEl0PTqx8IsS8zAlRlk0pEishPQZnfVlkn3R3bYE8gAE2x7H1uZQBnpAzAj32o
	sAQPZjjvtrjXzWcXej3uU34edcyi+cS1G5MWFUQmCnjZHQyMd2ZAcTrReEFqoovKkqMq68UMJdJ9z
	aSPmsCJSow5ChZrzopeDLdjz5ITQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x944f-00000001udR-0YDT;
	Tue, 22 Sep 2026 17:14:33 +0000
Message-ID: <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>,
  Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, Michal
 Hocko <mhocko@kernel.org>,  Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 David Hildenbrand	 <david@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi	 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>,
 YoungJun Park	 <youngjun.park@lge.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	 <surenb@google.com>, Qi Zheng
 <qi.zheng@linux.dev>, Axel Rasmussen	 <axelrasmussen@google.com>, Yuanchu
 Xie <yuanchu@google.com>, Wei Xu	 <weixugc@google.com>, Wenchao Hao
 <haowenchao22@gmail.com>, Jonathan Corbet	 <corbet@lwn.net>, Hugh Dickins
 <hughd@google.com>, Baolin Wang	 <baolin.wang@linux.alibaba.com>, Tejun Heo
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan	 <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, Linux Memory Management List	
 <linux-mm@kvack.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, 	linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Tue, 22 Sep 2026 13:14:31 -0400
In-Reply-To: <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
	 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
	 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
	 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
	 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
	 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
	 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F>
	 <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
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
X-Rspamd-Queue-Id: C868B2000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tzi47uzf8ytfwkee6rxhqww74o1mcxh8
X-HE-Tag: 1790097333-497448
X-HE-Meta: U2FsdGVkX1/ZKdaAKML0xsQ9eK4FbJX9qf894UiTcX5bbxqK8CFAIAxxvHJLiRZ7L02jJa4CJMMuaH04zSSqyBDJe/eojVE95Z7nGjUuWfNzkOs1d8vLwtw11Dwv2pSkVOWVPIpHKQrgNPS3tHI7ilJxoGmONDmgEAFhqmcpIGLCwAfY7tklfRjvJnpRzrIwl1sl3ujFbG7GqAX42pBAPMvXCfQPsRce3pH9Cwr0QG9rwq2knGLxDJDeG0vqEH0hAyabPj3o2zhsGtqsfsMA8ChvsJWt2gXZJnhj6brmJINuaOJXIowALUQg2dqQweE6NLp/KcEH6XCwkjFOpWpG3hj5hiVGIukqjl5bAJl25/+vpARYS5bc99PclGzIIU5XR/h5U5iOp83cy6/EtixkmOR6DIBn5FdHMujsIQ5tobORT3nyDAqfXC9q49CHtSnWOnAa38QX26QG0sNvR+xyNtcMufZRHJE+qH9lMbrHqe0lC9+0WQnjEg64GblTV1NfdYrIXqIoOkDEK41H0S98ZdhJ1plohlyxHTNy6WMzQN5W5K+KjOg9oSJYiOQxyBct9Qop5LMJjh2u/5vRKYtdBvOPjiiegkT2z9xnVc5QlgbN2GC6KY08k5jmlc63VnzCGKcfFllqWgS6/NRu8jPNaSN7sspK2OmdLZtX7AIC/TcM3MW4qkK9KoA3lPPUuCGsIhJI6iuhxkdGG7dttwbDQJX11cP9aAeQSiw9BmSj0DqgkzfTRGeECe16b512s7JlgeLeDSZx47c+eXNhjcs0TyjiOxh5Fd1YgqiN6FCh3zB3LIDeIMbYsMEcMRo4Uz2fPRf5kRZYkNNs0paI7G1J6Z73BF2YE7aOiHPr1KZ1jq+C47skTnVUVNVk1126lUuuNOgP6KmjaWuBLYvtLGBJQBNw2WMn5h9Wpei3TIgi3lulpAwv6/KSbQ53wlwdjxAeK78CIooPicKwSE+zMXu
 mMYuaXys
 xjWYry+0l9kEJ8gT2lkN3b9H+AtHmXQ20jsuAO6FpqaKFtjAP1aLBrxOpwBm96KP5ev379qxBwmdIc+U3WF73wIJ1OI+O7HqInLbtBJ67q8VYz54XAPqEJuaNhLF/BO+E9NeDsBOpUerfDqKYZdqAg5SwfH0nZhU4Z6EBzSGh1hzV6tsKUqwjckvxDcGIv4XDjio+J7B7nVlww3md87oMA9o8aF4zQwLuiwIeTtehtmOxWtlmtDjGu5gfB+kwCMEq8T7xntVCukZcZNaZV1iFIkLabWhuG8jqXxYmb7seFuRcgQnJRuGb3HwUetY2EM46/tYZ0ovDKTpHC406nTYUmcSXBAg0AkI9Zj/jsNG3ydX8dsc5JJYlJTnsE267TDKDKiMTFrcD/sj96A1vO/75ivAQ2Ku6T9gBwvriyLUQpbNcsPhk9AU7RrT394scQO8zmkRqJdTlXJdfbuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-09-21 at 06:11 -1000, Chris Li wrote:
> On Mon, Sep 21, 2026 at 2:53=E2=80=AFAM Gregory Price <gourry@gourry.net>
> wrote:
>=20
> >=20
> > You can't know the compressibility of memory until after you
> > compress
> > it, and requiring a user to predict the future by forcing them to
> > limit
> > the total amount of workload compressibility does not scale with
> > the
> > number of workloads of variable compressibility of data.
>=20
> You likely just need to pull a SQL query on your fleet to get that
> number.

This feature is not being developed for just one
user. It has to work for everybody.

>=20
> > That should tell you that your model of reasoning about this issue
> > is
> > ill-suited to address the problem.
>=20
> That is what I'm suspecting. Nobody in a sane mind would want to
> zswap
> 100% of the RAM and maintain reasonable SLO.
>=20
It could make a lot of sense to have some default
limit upstream, that says the zswap pool is not
allowed to take more than half of memory, because
at that point the compressed content will be
crowding other things out of memory.

That seems like the kind of limit that is large
enough that very few people will run into it,=C2=A0
while also being small enough to prevent actual
corner case trouble.

--=20
All Rights Reversed.

