Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F24C606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 16:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=JuAIutRo
Received: by kanga.kvack.org (Postfix)
	id AB8F46B05BD; Mon, 26 Oct 2026 12:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90856B05C3; Mon, 26 Oct 2026 12:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6546B05C4; Mon, 26 Oct 2026 12:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA326B05BD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:00:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1D1314079E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:00:15 +0000 (UTC)
X-FDA: 85365239190.02.36BAA28
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0540A4000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:00:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="JuAIut R";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793030414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IYnJWIdmisQFzrKQUkCcuczzZRiHZa2yg/KvW4ePcc=;
	b=TlQhsGYEpF218m1UonUhIthcReuW5ni4l2jAAjJaHVowH1vYfx1KJb16RYLxzZm0OgQKCh
	8ENSYu9JZbXmX5dGL9O1WW3BHKxFUeiuX12YVagjYcZxilxZHWK5pm68dIY7t84Q4y0iFS
	M4iRgwwdaoo/9kohUPwVtGygkO9t30s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="JuAIut R";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793030414;
	b=XVkhUvay1RGEKjse/miXM8KKpUTns/P5+mHl19LZTnuJjDEYRHSCvXoTF6MNZLMRqQqIYW
	betB2hPbFG9YVhXCm88KHYRvYCYOw0iaA2UV/KkWO+WefuaEvzgVzODR7Wy/ZfAI52MzCo
	FJU+u2FZdp76csoXlkD9opeUkEvh9Rw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=2IYnJWIdmisQFzrKQUkCcuczzZRiHZa2yg/KvW4ePcc=; b=JuAIut
	RoC4Cq2nPGXCBH+jTxgWy49Lbxu4jcgzQofxjI77DLR9MvN30SnoY5HYeRK6Z94ySxpYQrgieDz2/
	XIU9TzritE2mhW3qByP+jxwpHfp92h8gx3Af+UcJdQHQFmgN5Gobyd6Zh5EzvmfI6t271k/VWkANG
	hKrMe8WRsR5U5Y6GBfE6KXPmUhrAgC35ccFVR/CYlr/zNESwaI0r2xxVYhrGdhgoB/EmqdbfGnBbR
	CPjDB4SolTrO9Vqf6+pVjBvxHyBAYuGZ3CQBWIAI7+UCzsytes6hYSmtNsZP+PV5cqal7qzy6Eoh3
	GOoJyVMS8lYzJZshdOJM5iCpwfYw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xLN6A-0000000A1Pf-20ZE;
	Mon, 26 Oct 2026 15:58:58 +0000
Message-ID: <340025b7e3bdc6d905da2cd052ccbbda63a58ac0.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>, Chris Li
 <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Michal Hocko	
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt	 <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, Muchun Song
	 <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, Barry
 Song	 <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, Chengming
 Zhou	 <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>,  "Liam R. Howlett"	 <liam@infradead.org>, "Vlastimil
 Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?= <surenb@google.com>, Qi Zheng	
 <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu
 Xie	 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Gregory Price	
 <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet	
 <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Kunwu Chan	 <kunwu.chan@linux.dev>, Meta
 kernel team <kernel-team@meta.com>, Linux Memory Management List	
 <linux-mm@kvack.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, 	linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn	 <joshua.hahnjy@gmail.com>
Date: Mon, 26 Oct 2026 11:58:58 -0400
In-Reply-To: <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com>
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
	 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
	 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
	 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
	 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
	 <aqgMCIOFi0dKx_6L@fedora>
	 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
	 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
	 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
	 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
	 <20261014195354.GA371161@cmpxchg.org>
	 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
	 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
	 <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
	 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
	 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
	 <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
	 <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
	 <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com>
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
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 0540A4000A
X-Rspam-User: 
X-Stat-Signature: mrpj7dqa68ihp4p748nhyf87cg9asakg
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793030413-739897
X-HE-Meta: U2FsdGVkX1/iBE8g6fJJzu1XaBz2hiiZTc/ywMQIiiC3qCNTT7wXSYLGYfvsF4Uf5PO9aiO6xfjSjVw98xLn61qtKzIVdyFEW8ORMeRJIGReGm95NagOUJAiJ0BrpKqvzwcrpzebkROieYaEOC/xw4IboJXFLxSjp8KJwALzXgXJZSf4xvV9kiEv2lhFy4S1PET0q1/pPlgRtbAUi4CLPChxUaarE4+Jyk1vY3o7InJADkIpC+OD4fT8y/AjJrHlYBj6gYkunsiD6rf+rPRAHTelZL2m1wRsAd9GgoXPGlI/8ci/E+a3Nb9Lycxug3GIF4rVmGsg2Q0DdZGNird3rdeTw9+AOYe9T+QXS+a7XpJIpi7NTM+nARJ6cugN5WOJrpkj6lEzuk71Pdg+hlsEgCqlKGQPVSDm2UT/ZYfJVJwFMV8qRTF6qtM8+MtzGuwsoF4Ue1BgaThef3m5XOH2C195v0dWiMXHGWdpW7IAvNcflpkmK3QP5S3uNcWeu+BqWSs/YhCEIkdCPCFvkXruAS/j2F/TMZrOnUonJZw2Cjaz+tcOPuXcsDNR5EHsSxOOIwJcxu4unupPFmna0ufKzT76Aub2PQOO7qUqVx7Jq5LhYPf8JXt/vQaViSKWmhApAVFfWUAtY3/ep/fE+P61sqDQKOEGm0h4Jzaw6N0MMlCLa+S72MLzUC2F8A9qn+1IU0N88gft3YfBeRN1SsVYw84/2aomfTOeyGbSyoBKfU3EUMY6k4z8FrhbPEm88hhY1F2zC5jJ8NgizKqIZce9fcmnRfrfS7EaTHEZ0T4EQoHhT+BWUxZRSIiMLZyQq6gcZf+24duKuj2BFAvhaqnih9MinfZrLiQ7AHn+Wt0PxjM86OxIhdlaNv6rW4I9/vTI7Y8mdbsPn6ucN5e6xG0onlTE30imE/tbtQBmpqr2xfLgLUkQ1XIrqq40MwNDRkEtb3KXCgsClF11LlHjjRW
 hG/tLy3u
 FB5B14kvJJnwx3g5KvA5h4QyXukM5nz1ENLuP1IosiG8YHX5e1LqqTVl2L5UYsL0mKR9jfMdT5AqP2Ea+IvuGXDtpzV/JtloRRbs8yrhs/bXDx+dQc9S6C9jWZhs32aNqQg/UOKxOF6t7J5uX6bg5VEbF7p+oPp6/SAQLuxNFbMMppmNTpAuiNdNe6fBpG+TrXSB6A4Q1u3HXrdHYYqJHaGL0Bjy1zZX5mI4rTrZDKCF2X1IumMlB/eIqUh6xHe6X7X9vdCPWHrsapZEbgC0gaQ/+s8f30sk3a4vhSmcp/Xjrc4qzzN8dD1evc9BNE8PQI9xOcGbZ6dObUThot4dArpQjd5uVpFRPc2a0MlW0sr9ccJlT2vaIHC2GL47qD069sHfu3NvFiF1PLBuGXLEOllFm38pq7+Edv4MWCeVsmNG2aDdJi4mZiMrMcF4R3KJ3PRw3nbhYecujMPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 2026-10-25 at 12:21 +0800, Kairui Song wrote:
> Rik van Riel <riel@surriel.com> =E4=BA=8E 2026=E5=B9=B410=E6=9C=8825=E6=
=97=A5=E5=91=A8=E6=97=A5 02:16=E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> > > On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.co=
m>
> > > wrote:
> > > >=20
> > > > In my mind, we have vswap sitting as kind
> > > > of a swap VFS between the rest of the system
> > > > and the swap devices:
> > > >=20
> > > > +-------+=C2=A0=C2=A0=C2=A0=C2=A0 +------------+
> > > > > vswap |-----| swap cache |
> > > > +---+---+=C2=A0=C2=A0=C2=A0=C2=A0 +------------+
> > > > =C2=A0=C2=A0=C2=A0 |
> > > > =C2=A0=C2=A0=C2=A0 +----------+-----------+
> > > > =C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> > > > +---+---+=C2=A0 +---+---+=C2=A0=C2=A0 +---+---+
> > > > > swap=C2=A0 |=C2=A0 | zswap |=C2=A0=C2=A0 | zram=C2=A0 |
> > > > > file=C2=A0 |=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> > > > +-------+=C2=A0 +-------+=C2=A0=C2=A0 +-------+
> > > >=20
>=20
> > However, having swapoff remove all data from the swap
> > cache, after mapping the memory back into userspace
> > page tables, seems like it would be fairly easy to do.
> >=20
> > Does that meet the needs of your use case?
>=20
> Right, it's nothing hard, as long as we don't add mandatory new
> layers. For very high bandwidth swap devices, a mandatory indirection
> layer is pure overhead.=20

Don't we need a swap cache lookup regardless, to
make sure the data we want to swap into the
process is not already present in memory?

At that point, it shouldn't matter whether we
get the backing swap location from the swap
cache lookup data structure, or from the
page tables?

We have the page table lookup, and the swap
cache lookup. That is two lookups, regardless
of whether there is indirection, or not.

Am I missing something?

--=20
All Rights Reversed.

