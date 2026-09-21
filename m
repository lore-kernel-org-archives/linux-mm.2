Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D3EC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06CA6B00A9; Mon, 21 Sep 2026 10:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8FC6B00C7; Mon, 21 Sep 2026 10:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA70A6B00C9; Mon, 21 Sep 2026 10:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C83A6B00A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:08:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE0E0801E7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:08:07 +0000 (UTC)
X-FDA: 85237948614.24.E908B2F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 344CE180002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:08:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="YfKsUv Z";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789999686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQKhyetorp3O0zMecw8HeSSyTSsG1o6Nduy8reJfJA0=;
	b=PfX4n9tRL0p6FGUHNbNVSlOLdUjyb1lHyKsSYqkKW6+liY+D9x89Y6y6HjjYXyk1hcWUIT
	+MRqMoL3rYkOk4DpcJDqAKpJYNXj9xtGQv/66IX7IXLUs5XK8FcdCo2LHNh5sz+41wt9DR
	uUtVEU8gZ7X6qs+YqCRphCDd3EDne2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789999686;
	b=djw0Hq+pfJOQ4rmFJHarTy1Qnxcm//a9nnIR7QoIrfe2wTd3EcA5cxnUKiaRtOMp95Obkj
	wGF3vE/cJNFRt1U7ARWdcgl2gEx4kxCotxVNGr1Io//eYerVyakcDF8VzKgoZBv4CNqJe0
	G/6N+eOFPKpqg+mZO8797uKIyUbCQjM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="YfKsUv Z";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=dQKhyetorp3O0zMecw8HeSSyTSsG1o6Nduy8reJfJA0=; b=YfKsUv
	Z7vQOifpSbfpVDG6WmMIRNoZUDazqcEysy5ysSFw2WzPKzd7IIL8e9EnVtfxT7wrOQ7+8pSoFvTdp
	1GWhwdGFlHRhTyr0q1n7ut3Jx+hEUpFpUOmOd3mQsyX/OSFWyJMgd7ps5SyZ/ddFmr/nF8BAxCjcP
	/6Cvc/ffdCjnl1VvJJJSjm9VBnQcOX0YFerpWPn9YI1ByLcCEm3NvsuYYdbP0IpW2Y3NcbKqIa9yG
	bDF6DaUNWWeUCQwS4Reukr2+F8+KXqbr0tOtlzuxPbznOFeIwT0FFi/zW6HBnhYA02DERg67u47g8
	/Xua+T4Tt3SZ42W2rsiXfhzsM56A==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x8efN-0000000D2M9-0cKp;
	Mon, 21 Sep 2026 14:06:45 +0000
Message-ID: <8aaf1f8101c9e45514af442aaf1969e3aafec4d0.camel@surriel.com>
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
Date: Mon, 21 Sep 2026 10:06:44 -0400
In-Reply-To: <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
	 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
	 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
	 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
	 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
	 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 344CE180002
X-Stat-Signature: m59ocf3zze7zg8o99cntoqskyzeqr3hh
X-HE-Tag: 1789999685-159094
X-HE-Meta: U2FsdGVkX18J4iJ3kBFaE8oX8i7vbJ2Txgnts4ChFICH4QkzBt6c8IfiONzxIQnpG4W/pMr7cwGc2Zu24FdfbQodcfIcpkYrL50C/jtYm8tfzq6OW5cgXKZRQ8PzMnP2TJ4+QLCOQko6AI5o+tzbC+B/RDkckqWkiYYvYSr5F5iQKrXGbYo4Q8F08VWhpjklt884779Kd2oeQM51fSKkvZ7Q1rqwk6f7ORGHoAf9Sw1XTM8+a7A+XavXIG92WCGMOsy2zdHlqyuj6ABA3OOlIvR2KFI0F9sLNTChdepoHGBNUJkelHNJ1hdL9scSCmGxbnzUxKIZwS2o2GkzC0+1bRxbsgXAstwHyg80bKnuBU5CCyQXHoGXMucQ2FpfYJeTokHw+kBM7CNZP1ggZguloPGDPuLqG8soE9wtu2Ry5bf/qQCbP9ZWHFL9NEL9qmI/IXRX3Fi0tgRAy5vOnAURLz1sJY3wxKrqDw38sfoDy3cfzra0ccEFqQtcaDHvxbWFDxayW2c6AwLv2DPmKNXt0SrHQCzEJITTMqXnIGTXTW728ccvrXfs0wsQnpRHnUVPpeYHj0zvCTRKBuNDbIGqfyWnWbFAjLXwEJLugW0+Nj3Nq3CGO8JuBcUYdGTny8Us56FxTCA2Hjoib0Xis2WlSgEnz2Kv9FKUQo9ZV7bOm8+/6TcCEppCqkV9Uy4/wuZUFBdQ7vjzl43pz3oGnYe0VfLc8paVWXKN62WvZfjdkuVqwpsDw13EGYPWvhlhys2ez5VKsMsGUi0dftGwItopuKnlNdoBGDsP66r0pPJsmPIAYEmVVuM3S12xYKWKvIOIvrTjSkKwVogV87Z4oXA90cs216VEo0V7v5VDKbHdXYqOx4pyAZ/tn4uWl+4M7V0Nmch8wc2wDPozkjo+aqdgPkLiAxY+34dgBYQCPMnjHngpt5g+NE8YeEBhEAWmRVE/LcKBWwvpyZLUEn4wfnE
 BgqF1fKa
 rqQle3t9nPoRIyYYCt91md1Y4RSwdSGJLTTdML3276vYnqdgtTchMfC6xCdG6RTHxCZAQTq0+I1HKAi/FSx0OrO7/xU626VyWCGbb0k6BhbPo2h6c1oSRHbNjHe4gLlaTIdGcu+j8UcVO2+qnK/IuL0SF8hxXEFGAnJBNMkXh3QrplmnniCJMRxv4qOm80PbHudR3y6MFyWr/jjlpFCo64hDBDhRr/Q3p+E7tgGYJbiHaOh+VgB7XfbXECnhesq4HUvCCvQBtcnAhtMrWjzjs1G6UyJvwrbaBOUah/8f868rmfVHC7OPQl5fsyaGdM7edQUAYm+dIfkapKE6UQAWZemr4KmvD5hU87p0U76aOkYvK0OfNfVSr6AwHlvNl1gjqj6yPwcVA1Kc8lrxl+HKk357GgnU7QJtPS92C6szPUYxq5SuG6cGZ19y4bIXSPyG/tH9QsD3+yWHK6NQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-09-20 at 23:43 -1000, Chris Li wrote:
> On Sat, Sep 19, 2026 at 3:53=E2=80=AFPM Gregory Price <gourry@gourry.net>
> wrote:
>=20
> >=20
> > I want:
>=20
> >=20
> > =C2=A0 1) zswap on machines with no swapfile
> >=20
> > =C2=A0 2) without being asked "how big?" - there is no number I can giv=
e
> > =C2=A0=C2=A0=C2=A0=C2=A0 that stays correct, and
>=20
> Because you can't answer a question, we have to bend over backwards
> for you? That does not make sense.

There are millions of users for who the system
should just work, without having to first answer
your questions.

Their use case is legitimate.

--=20
All Rights Reversed.

