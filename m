Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBA5C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 18:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714986B0088; Sun, 27 Sep 2026 14:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5376B008A; Sun, 27 Sep 2026 14:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7D96B008C; Sun, 27 Sep 2026 14:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5926B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 14:13:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88BD8140A65
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:13:38 +0000 (UTC)
X-FDA: 85260340116.15.3CDD58E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5143040004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:13:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="PdcFTX w";
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790532816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0P7tqyZTwzBwbJvaiPJZX0pDFmwUCv9lhS7oxqr+H94=;
	b=mgjL9egmCXG70FVgfVaYP5h1qYtInXecBpu5eGpij/PbsypQuOVgrKvrHqFHtCWAJbj7y0
	4hxcIQwYXgdRcRVAohJMgyPFFQehj6N2GOF77zUaah6719xuemBXcQ30vWAnfMebCqv6X4
	KmD6JgiLrbyRFHjIsFEI+aSdhmPsdGA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="PdcFTX w";
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790532816;
	b=jOiEcx9BJXLZDtc+Gvzlyk5x+ZhyIGqOqEVigL4GU9wNDWXtlMIdl8CkeS5Lx3LrQKNSxC
	kzFHHViZ4S5KUME6ELLtJdPHx2OoahjkDfxZGXHxk2XSPUO5DtyxcpQNUef/5Kg9vZxlx6
	PhPNSxD1DHX4505jqNcmkkZeVxmbUQM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=0P7tqyZTwzBwbJvaiPJZX0pDFmwUCv9lhS7oxqr+H94=; b=PdcFTX
	wtM8Csj5/XVIZsrFPtA4zd1u+xYyJHfmIQC/uIRk6E0k0jIBe6GvUDGczEER32hmLzbPxNu3jnzgh
	lET5XamdnQ2iNW1x32dwQKM3W1G419i/YjEy17UQ7/VhUmRlxn3mGUUQu5MrvQM1mJzyo0EewUfFo
	AvzDic+FDT22YdHnN2iy7rhbE7TeSJ2x0DilMe9DDOSrEEqISYiuje9ZgS8MmXwJ9dWpayLgIP/qb
	nd17GKQbn2xQVNwLFhmmtPY6L+gUh94Qe654vFjeBreAnefoqaC+8r+2UeLDsYLbBukf/Y016IQHP
	f1jBwy1IlQVgGqzs+OMu1vr4pBmQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xAtMD-00000009nLA-2XiP;
	Sun, 27 Sep 2026 18:12:13 +0000
Message-ID: <1739d52dcdebdc589826990ef2938b58b1055e18.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>,  Kairui Song <kasong@tencent.com>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin	 <roman.gushchin@linux.dev>,
 Yosry Ahmed <yosry@kernel.org>, David Hildenbrand	 <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi	
 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, YoungJun Park	
 <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen	
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu	
 <weixugc@google.com>, Gregory Price <gourry@gourry.net>, Wenchao Hao	
 <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins	
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo	
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Shuah
 Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, Meta
 kernel team	 <kernel-team@meta.com>, Linux Memory Management List
 <linux-mm@kvack.org>,  Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn	 <joshua.hahnjy@gmail.com>
Date: Sun, 27 Sep 2026 14:12:13 -0400
In-Reply-To: <CACePvbWf8ocrfTpEpQ6==cr1=KTzo4Ar+-Zxt89=sxt02Z8uBg@mail.gmail.com>
References: <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
	 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
	 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
	 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
	 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
	 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
	 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
	 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
	 <arUcil9kxUPiymXI@KASONG-MC4> <araWKyJ5MENBwXCL@cmpxchg.org>
	 <CACePvbV0Z3OhxkEn-MiMrxpSmtbt1YwCt2N2_ZW3jbdh87jgFA@mail.gmail.com>
	 <9499bc084e30df4d10bc069ed26d576e4dd3de80.camel@surriel.com>
	 <CACePvbWdJSUDuEbR2FXczbeWwvxP86WDGHTL-eO0A8WwMDoNRQ@mail.gmail.com>
	 <b792823cce613ce756227a3b60cc245b0316a800.camel@surriel.com>
	 <CACePvbWf8ocrfTpEpQ6==cr1=KTzo4Ar+-Zxt89=sxt02Z8uBg@mail.gmail.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5143040004
X-Stat-Signature: o74xt4zputycpb8dkdos9auxsyh47art
X-HE-Tag: 1790532815-516276
X-HE-Meta: U2FsdGVkX1+mep/HmMaSUYIvngrdHJN7FniGE4QCC05rgX/gXmV60+8JuDhEjCtyMxZZhmwyAPiQ596buoXghY7L88MfFbklAAzXLjwbgneQ4W4+11JRJokj4FLf+MhONU7wlFKxh/edRqaAY5HaKwAyg6KGWzL/BGqvnGOU1FnSPTM0VsZdsjiRqAxhp2fQBKQlE0AizxeyGA6YPQWD7ou+otz2r+G7DwL6IQAe7O3pSrFtN1SFtBiK/4CXD9mOLL8G6NIW7IzuZUr9tIRbAXDS68IvJH8LPEn83air3s7w54fhkO82NoCvdyXIC00hSzQcuTTaeUSFU9NZU0Ge2PTlhe/WDM46rnC91CfoMSDRzyA6OnSRlTkugsq80nADknNRAMZN/LLtDsTyCxFTstF+GC3qaH0IoIt6uYWkjsNCBUg0nRll2dOnpaNPPTtKiEvgYkxjvaofkrgQDCaSgfs0Sd/d8MYXBdPUWK3gNf625Z1qyo+onzEjO26sOX+OZgJhkkL0KiEdHHxgw85w8nabxFOuXVjM4OWAjwRhp+nRpSz1e4bKrtMd+jm0P74+bvj7blsDpmmPAIcXNUs3++5mbC86bzjQBI/3kcH9fQ9BAjXHKgfIYq/Gw5ecLukxAmfnAwNLQ14HXh655dUuTkU1MdVjoTiSDx5JxGPBMfMEOIsC1O5XZfqMOfCxbPURpEcc7l7PCWwl6W/8qcy6UmAbWvjRbj3NVAbLpWYyO8UyHSQcezbzstB/4X7uy8E5BbcnvilUi8J8pf31xe0tUL9zAExunxoqR57ghrX+FkMN2tR8v/0PjMWqpYyzQgzaIIliwtv4naKejFagbLHOQAcmg0V6aVxGZ7XOuDkuM3UAJd5mJf4smhoNjlxKJpykmfUcDd0NcnjmyCXLDh1aSDNHzxiavigr8sIOuT7IhP9LDqNPn/shKZjYXY1TeiUBYFWj/UqMKsEdTP9xv1j
 mfXslBlF
 /6o9XZMLfzt04Rn6oWTV0XSv+57VqoysPwM2VLxSxfFq5+Jn3cZLRho/uuTnL1Inq1cYgQR5/678Jqh0e09oWz+F4KeHMEJZ/oWrhmuep5b9MuU3e3aQz19eE/BPlA8p8Mtdzj6UXDAIezWuUJVD+Zfm4H0JyoBvmB8rBhMa7zY2rzlD+oYVuQVSqoQaY5ijOeV5uw7WXjdCv1OPPTzv5S5KyeXl/jqaFGJfvz1RXm8u18uFfEDiCGId08RdxxsLYsxu/YodBfUDnLIMOxhdLjfAluteb1ZZ+4rZRgBMSNqpRYQuzct65Aiva8VgeetOOa7fmZMq6/PzLM0oGr16lau48ugjWN8n3QMQfpgb58UY5WIbZm1Ch6VU8f9fBmZ6dCwx7kc9/xhZ1szuwR531VOHXcDTdnVlR1G3Qoylv4OlkntAV9qkixBtDA+e0U7wJ/tveROPqTRu342o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-09-27 at 06:17 -1000, Chris Li wrote:
> On Sun, Sep 27, 2026 at 2:29=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > On Sat, 2026-09-26 at 20:23 -1000, Chris Li wrote:
> > >=20
> > > That is the part I am not sure I understand correctly. Fair in
> > > what
> > > sense? Using the swap file proportional to the memory limit of
> > > the
> > > cgroup? Do you have an example of perfectly fair swap file usage
> > > for
> > > a
> > > cgroup with an 8G memory limit versus one with a 1G limit?
> > >=20
> > > Sorry I am a bit slow grasping what exactly the fair behavior is.
> >=20
> > Say we have a 64GB swap file, and several
> > cgroups on the system, applications A & B,
> > and system.slice.
> >=20
> > We might give system.slice a 10GB memory.swap.max,
> > and each application a 25GB memory.swap.max.
> >=20
> > This way a memory leak in application B
> > does not result in application A being
> > unable to run.
>=20
> Thanks for the explanation. To me, this is just standard
> memory.swap.max limit behavior. I was thinking there was some new
> concept of the fairness I haven't grasp..Thanks for the=C2=A0
> clarification
> anyway.
>=20
The only real change we are looking for is
that once zswap no longer automatically takes
up real swap space, the zswap use is no longer
counted under memory.swap.max

Only the data written out from zswap to
physical swap would count toward memory.swap.max.

That way both of the fixed size resources are
counted according to their own limits:
- memory.swap.max limits physical swap use
- memory.max limits anon + file + slab + zswap

--=20
All Rights Reversed.

