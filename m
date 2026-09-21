Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BBDFC982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 00:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DA466B00E2; Sun, 20 Sep 2026 20:37:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2986B00E3; Sun, 20 Sep 2026 20:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8566B00E4; Sun, 20 Sep 2026 20:37:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D356C6B00E2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:37:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4AE88C04EE
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:37:14 +0000 (UTC)
X-FDA: 85235905188.29.5EE4F8A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7B930100002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:37:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="R7ImQD 2";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789951032;
	b=GaQTebZokjeHFH0ZD7u71wbYHeXRny0pr1XSp9bpQkv/c87ZQQ44oWhHB9BchDDr6czwWf
	+WKaPD6QV3vMBBrcAx4NU/ozPVY8u8M/hPOCACwJLfnDAM835sWrlnnxBdEQbTvi2UWsxz
	Eo2cZVFxSn+e7ftSaxgY8LU9uSJyRiw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="R7ImQD 2";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789951032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jUSdsryHLUcbcflpvGA1b+Rdye8ulVCq+UtIvIPiFvY=;
	b=I9LmLgMeHkajLwHMI9VwMkGANsZk+VTCVsxqT+lw8M138g7+Y8eN0ySbJsT9NFP7doNCS4
	Kyyj2rLzchl19+JV3vrPuYnEChd/jhQzkFX+HC8aDLMGUd+VAcK5JV5O9P/ft4+yLJuvCh
	PrHSQ+La6newTHo91zpdYxDxB+t2BZE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=jUSdsryHLUcbcflpvGA1b+Rdye8ulVCq+UtIvIPiFvY=; b=R7ImQD
	2/EHjNxEdtg4pd3vjaPfRh/m/a15X13i17xBqOkSfDP9p9pneJaTIM6Xp6GaZOYqW1+V5AyST+DF+
	q/bM/BU2+dJKginoE6zAuF1w23S9m8LU9ZHn0lBYekN/qL016QZY362rW0Ka9etYntRx8mAYFINYt
	Z4NNoYQ/bCmXdnnlp27InzAXbgGoER9co/65F8Rgynhim/ysBHbW7O6s4rJcKKUh2n9e9JwAKilUY
	fQz7VdZyNIemn1Z9mhtM6PeSlGvmduF/R3Wtv3n+7nG14vNPachv2SRbdSpjb0yANRZz7vAmkP1Oo
	biL6r86xHXNitbpCJNhH1vKfEZcw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x8S0h-0000000CnAC-3ZS3;
	Mon, 21 Sep 2026 00:35:55 +0000
Message-ID: <da13e0e48568da3ccccc304aeb449ababf085e14.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Yosry Ahmed	 <yosry@kernel.org>, David
 Hildenbrand <david@kernel.org>, Muchun Song	 <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He	 <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, YoungJun Park	 <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"	
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka
 (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	 <surenb@google.com>, Qi Zheng
 <qi.zheng@linux.dev>, Axel Rasmussen	 <axelrasmussen@google.com>, Yuanchu
 Xie <yuanchu@google.com>, Wei Xu	 <weixugc@google.com>, Gregory Price
 <gourry@gourry.net>, Wenchao Hao	 <haowenchao22@gmail.com>, Jonathan Corbet
 <corbet@lwn.net>, Hugh Dickins	 <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Tejun Heo	 <tj@kernel.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel
 team	 <kernel-team@meta.com>, Linux Memory Management List
 <linux-mm@kvack.org>,  Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn	 <joshua.hahnjy@gmail.com>
Date: Sun, 20 Sep 2026 20:35:55 -0400
In-Reply-To: <CACePvbXDDDHo0rwkR3Ln4==teQugYP2=5y87J+A48Lagk1X_zg@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
	 <aqBT_35E-eSoN_zj@cmpxchg.org>
	 <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
	 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
	 <aqU81l1oqGItb-0C@cmpxchg.org>
	 <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
	 <e42d8bb0bb13067609e8ff8c858a26ca056368bd.camel@surriel.com>
	 <CACePvbXDDDHo0rwkR3Ln4==teQugYP2=5y87J+A48Lagk1X_zg@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B930100002
X-Stat-Signature: pypzx4bxp7ns63qjypa4aqk31347jmcg
X-HE-Tag: 1789951031-219235
X-HE-Meta: U2FsdGVkX19FirABKi6E7deddtaGyQcfel4/FXSYzaGENb1HZxuFG7V64DXpMhXXcX7gGch2W9qEmRSrq57paXZeuARpTgdXJCmjytalmM1k5eBO+A24Ktomz2XrGw4LJ+3k2+oQUmnoSjHRUF2SHXC1vCoU26cajuGNpB3y2faxEooFYCRE7GyNSUxH8LsNFemDTIEMh05/avB+kOIKEGRYb5VEejIxSNitk+Pa5qsLlsuA5RES08tTPrphaI3LBwogYzo+4/b8fVdPYCFY9bO/DZB4TRrrWcxsCJ8SKilcygPxYNOXLzfFALRr1bceFhmtkJdm67J18EMJEcgTvmBNLRvXkgni7n6WJOkFMF2uTBTCl4H+mJaiY6ak+Fu8Icowwk2yeVXpmzBV20PNeNaE26MHG9OaDe5qUlbclHnuk9dGoOFgtM5n7AWYy317pBOrwGv9thjxaaomgA7Y3GyjAvd4ZBFjRIbDkx8BK5I6TyGGUNhFoshDAmgUbATpJ4pY4Lmq0el+k/DACBGxxAGXEgRDPOy3InuahgBQ8uTRUUohKy803tauBGGyaC59cURSk4klDG7wiJb1j8FfAqJAD8ZJLaY9r6JLhZiG//tOuwUSWHDWqbVwZaePY7zKzNu1c9lNVZK4DDBB1B0oFlbmBQuDvybqK9YCveGX43xShKMk0ciasC187Yq1lLDdfDTTxy9Llnnc/g1E1ObRp6pa1YpDep83Icn8BIFbV0IOwPvn2Kv5dRyMjvfEo0+wP0GALzMP0jQPq9HG0MEO96c3n8J+kqKsm4WqYATw+GdByVQTEh/NyWEqmbgqsZ4rzKiMDUhKc4H02XgNRv8gSNcsyYd85WIAllAlX9arH5g8r+AZ6n+QjNMokooeJM/SF8R+TuxHain8OPFPwavqF7PYBZnPWWi0Opx9gTRfxc3vSxy5rdfL5ZVsanXjiH2n2xC69BQPyIA3dCY+nzU
 G7NJjWYj
 +FZgQiVYdznGzZKLqpU05tSEh7ceT/TzZkcSE19CikMT8Hp4OkV7lIwtdO1hOIV68YTyLw4sbHt2tYoFXVGOnPoO82EU3dhfHyDQkQlHbFof/BNLraOatBulxJ1M00xkpFy9J2m+5bACsAXU9Ufss03rIZCCIGfVoAuI36hRnO/KqG3OoB76agj9bW5VR4gEJZR/A8OxIzLNJfTkuiDUWKF10rnbeNDDjqHAAewJTJbCyUCqtrFEvT51ic2XCVC/KC7yY41IVV70lYFgJnBAYVskQUrfoz8xh3BIfWLCCGcQT0ORJGviRzGJ1KF5HXOY52/V6DlVMjLR+26MInP2v22/2n9zOnLgVhVTT1xlnu16oomoKcyAwJMDQHbzRWSE8ZJj67OPIb0Ir2NpyRhxnzFmyYNwPu0josU89derbIGcr91pbyo/dWAGvjcRKBKB/2lk95fHlzKfX4oY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-09-20 at 14:18 -1000, Chris Li wrote:
> On Sat, Sep 19, 2026 at 3:07=E2=80=AFPM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > >=20
> > > For our deployment, we only compress about 7-10% of the system
> > > memory
> > > before performance starts to suffer. The feedback loop will scale
> > > it
> > > back. I am very curious do you have actual work load to swap out
> > > 100%
> > > of the RAM.
> >=20
> > One common workload is a web browser with idle tabs.
> >=20
> > Those often compress pretty well, a ratio of 4:1 is
> > not unheard of, which makes it easy to fill up
> > 1/3 of memory with 133% of memory's worth of compressed
> > memory.
>=20
> You did not answer my question. You are talking about user-space
> processes (browsers). Do you run your browser in the data center, or
> is that a laptop workload?

The browser runs on the desktop, but the same
kernel runs on both.

The things we build here cannot be optimized for
just one single workload. They have to work
everywhere.


--=20
All Rights Reversed.

