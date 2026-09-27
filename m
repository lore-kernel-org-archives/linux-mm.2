Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A27C98328
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 01:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE426B0088; Sat, 26 Sep 2026 21:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28F1C6B008A; Sat, 26 Sep 2026 21:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E476B008C; Sat, 26 Sep 2026 21:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBA606B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:00:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CA6E40948
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 01:00:25 +0000 (UTC)
X-FDA: 85257736410.29.D6E1CF4
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8C7768000D
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 01:00:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mdL7B7 C";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790470823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtRF9MD3P2Hs0hSXn7s/JaY4f07p7uwsfCVagJl5fsA=;
	b=yWnONobHDB2/ltF6RGC+9F+4cnsDXATiAOWTbtHRtD8jjnobUPpy9DO3A7KeFNKvRZ0Wjp
	lyAjNUBzZo9kEOxbcLcWPf/MmymNNJvFWp0EMdzIifhvsjurGFt546O/jec88Z5kcvF5wb
	iLY6F0Lb2gamomkKSB0ySEXlWLRuQE8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mdL7B7 C";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790470823;
	b=pN5qylNafKbKkbKmXmlvt3aSc/TDIZlDKSLR946gF5QKm9nqnkPJQl7XjAJCL+AiWJKxoV
	r9eSkolCbr5XBPFuBGrgDOPLK77LqjKhNcmPqHBnOl2ODrU7qwG3l3iZEr0jtoS7Z6te6p
	LGy+gKbiQkx7nj4r24/C4b2TmqdQx04=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=JtRF9MD3P2Hs0hSXn7s/JaY4f07p7uwsfCVagJl5fsA=; b=mdL7B7
	C1hqqpjU58HGllGA3MLoruebFtyD5610lcHcyyTa2i1JNQxXzLqbeGvXEUSrr3/9Zp6FSXB3WvGsy
	xhgCFMdO78xx7jwTEee9N/xpFpEz69hmFt8bcNXx/AGv/0diHdfLZvaclqXxiQ2wp1O1N9Tgj0q2B
	NCYeOkwXrr1Cih8CSuAYigsLqJrwNMzxWIzdhjwOb3TM6W71xbZJ53OpdhRQfxwQhB4cuG46lCTo3
	woM4mw7c3QGPyxNlsMDyFv2CDAOXSmXvdHldYwzgc97XHbGsW0nfdjfviiSSdR474je0WdXnzlLV2
	WrQ+HGD5PdRa5D6t2QPcP/E3tObA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xAdE5-00000007UmZ-3HPN;
	Sun, 27 Sep 2026 00:58:45 +0000
Message-ID: <9499bc084e30df4d10bc069ed26d576e4dd3de80.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan
 He	 <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kairui
 Song	 <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, David
 Hildenbrand	 <david@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi	 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>,
 YoungJun Park	 <youngjun.park@lge.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
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
Date: Sat, 26 Sep 2026 20:58:44 -0400
In-Reply-To: <CACePvbV0Z3OhxkEn-MiMrxpSmtbt1YwCt2N2_ZW3jbdh87jgFA@mail.gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C7768000D
X-Stat-Signature: akzc3kn9fumagzaztej3sfe1sqmtpuk1
X-Rspam-User: 
X-HE-Tag: 1790470822-880713
X-HE-Meta: U2FsdGVkX19e3aBS4wBOHb5XaYhifgGhWGe+nvFuV7ZyZkDv99DGbBHPia3GXCm7EpdBFkm6X0FwuYQw1xUEGv+ElTiyD6oaw85etT0ckqPWYE4uCbUJm7owb1Qj7MNbi0HnquulbSf+riTGLhFTShITXxXdrK7DEAivwSe1ZYO0FSsx/0EF18falfd/ze1Mdzyx3fD+CxLe7EoAuK9jQ/FCQKD0qfxOJN2H5HhrbBVBlPEPAx/FW44XM0ZNHpZLkErjVCh27XTpVNjnPDIQEEO0Rau5QVZvoTouwTJ6/fUJ3QLQsdq8nl9YPQjxqyaQVQ2wqNg9UPcx7xBLPyrR1EHgoUXZOshuJPQO0YbIGQvuAszcyz3Q97lewPahCPkmBPZS5b0fjC7HXNLg5ZwcfQXuz02AZwcWOECTbvWTmr5unFWa3lr7dttY0dk9cIJ5K3Jt0sC/B97GwrtOIm4giFwRT6PWt95xsjwgOnOUhJOnAs9Rg9A+O4Jp0bCAoDtsDBzkrGpHPk3Wo9hD/oPWtLFMCH4Db3yjdLc3Aluz3i6D6BEA9rlMve5f6TN+OF8jdn3Pcd5PprXelxpsmAjsIMvfKXt2MH4dHrDXWMtO3OU4rrhCSW77C2aHlBLNOTQWIZXAD6R7n2y8rHHblq4Lkeyf2pwusAdBYnbURNGOPTtMnNYOSMraQc4eHXOvEk8NZrcPRnLPwqIT0gK+hknvL8YPwueoNqL+EFX1P+Ar9BMtl1QmGCUd4APk9ytGXLBBJEqJGXO5lpn5RchfU3B2Rlqf9TUJgzA1/l4dBuNg4AFzG4pES1x76oRx2L/Ki/lsAZEAUtqdlfIUDCXgaWtc8dtzveAOSVIDBXC79ysYj9eGvbv+dK9B1+fNsBNgCoGbR8EWJTii5aYdOdVW3FNd2hj/F4S2FbOxctodZSz2ig3blTCAFonRumvBAS1f9jZLAhZpc8mWrVzRAYrulpZ
 ZUHqFexv
 zfgUXcpHTQHP7+6dsh1ELTiRgch0sAZ+8/xQu1gIxBV5s0n4cwf3ybSoyEFZKf6Xiw2fu6jEbjFMn2yJP7jeiGdLvoiV4SY+EZ2W9EamwckT3IO8pFSNrkSvEAIDoiGvEaPMN1nVDQwsmTJhr1jtWMB7lir/tSedKaw0shJE19Osf2lgrrxGPyk2iBrBWfXlX9YY7E6HWvtcxw+AJEeWORb/y94PMaPpl8jTOeG1jRuYzuM2+4QjSUtl3z5znS710vWoBZHyDdtB8lYlWztoqI4Hpe/rySzMzkQEqVCHTo6LWoZdxQHUnDpMvdtDy9F4Bex9LCqjwhls9OSRS+HC39/uV8ulsA+/MPutwhdeGliydVfP7GQi7ek5Wpx4oK2OsP/bnz8SP7An7SszOZT3bJAhBaLy/DtNOvLmGABv1t28d3PzsA0W009em9iY6yT9WPeU0i7a6JYkmoGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-09-26 at 11:27 -1000, Chris Li wrote:
> On Fri, Sep 25, 2026 at 5:41=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.o=
rg>
> wrote:
>=20
> >=20
> > (2) The use case we have. Use memory.swap.max to divide a finite
> > space
> > in storage. We only have so much space on disk, and we need to
> > manage
> > fair access. Note that this isn't about speed. We have a mix of
> > containers where some use writeback and others do not. The ones who
> > write back to the swapfile need to be able to get their fair share
> > -
> > not more, not less. Including something that doesn't actually
> > consume
>=20
> Just want to make sure I understand correctly. Do you mean the fair
> share of compressed memory used in the zswap case?
>=20
Compressed zswap memory is already accounted for
under cgroup.memory.max.

Compressed zswap memory sits under memory.max
together with anonymous, file, and slab cache
memory.

We do not need or want another limit there,=C2=A0
though I understand other people do.

The fair resource use from memory.swap.max
is to control how much of the fixed swap file
(or swap partition) space each cgroup gets.

--=20
All Rights Reversed.

