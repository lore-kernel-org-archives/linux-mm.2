Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C67A6C98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 12:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA096B0088; Sun, 27 Sep 2026 08:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55116B008A; Sun, 27 Sep 2026 08:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D066B008C; Sun, 27 Sep 2026 08:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68AD06B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:30:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E15941C3A30
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:30:41 +0000 (UTC)
X-FDA: 85259475882.25.4D6C973
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id B4C9F1C000B
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:30:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Qs32Yn b";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790512239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pka8Z6mvCOBJwU98rqsj3rYDII0HYG+bU+VXYYz6wio=;
	b=1z+7/4ijiKzgnWhKFs1YKJYYrRRRunV7GA0qHJlGDmEYZPX3L0g8hVIkwUkyU02IThHaBW
	dlPHhiRK/ZJKRYVMzltXsMEbgTcLGgX9FyXApZY7ysJa55JMyX+ojKX2zGbleOW1KCT7Di
	6msCa04v4D0WH3yAqV4qm5awAkj8tQc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Qs32Yn b";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790512239;
	b=H/tq6rkDZRTYEpPm3cAMN4N7sDSXwiPUi9ee7sldk44NSGc2munysjDjbU8lhSJuYDBgU3
	UvK0iO0S+XqzZk/TY9KTFmywtGZxZkM1uS3yNw1k+6HRFlRdxIV4kbNNfUq1u7pbD6cEQg
	PIohYxeIStTgEoCuC5/ZZpy4B0WDx+g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=pka8Z6mvCOBJwU98rqsj3rYDII0HYG+bU+VXYYz6wio=; b=Qs32Yn
	bA5WLO1Ej9z+B+PWd5S/mJoCk3txk9/xz2ibWRRLFoGweAEAVdN7JT4WU80e5qhYbqo9abA6LPCzh
	t+VhanqKcKh19I/5M/lg7JCQN5+ohVrjJ2v7Tsu/ALCBsBcrvP79Ce8t3k7wMTtgJ9R/aXdptQPOw
	TpQpV9cda36yKhusJrvAjreh1UsaiehX2qouYjmkjh5T+INh8XCY1EsHNR1O8Z/2INa1T22HQ26fL
	DUvGzdnxAkSLgTwxsihksJBE2+9vfLEh2kfY7jJymNHMcsxOOxgajW5cRrGCobNBYk1A9U5OkOp9+
	zEuQNmWammTBJeXPYHU3LF7/JQcg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xAo0Q-00000008CBI-2vSZ;
	Sun, 27 Sep 2026 12:29:22 +0000
Message-ID: <b792823cce613ce756227a3b60cc245b0316a800.camel@surriel.com>
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
Date: Sun, 27 Sep 2026 08:29:21 -0400
In-Reply-To: <CACePvbWdJSUDuEbR2FXczbeWwvxP86WDGHTL-eO0A8WwMDoNRQ@mail.gmail.com>
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
X-Stat-Signature: ceauxq1fkmer3tb8b6xa8thhmtbitede
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4C9F1C000B
X-HE-Tag: 1790512238-870070
X-HE-Meta: U2FsdGVkX18hI5IbVSw/BpLYTBpghGxV5cm9sUmmdJJFAasfPTVVGBnNUBqIzEQR3Z5eYhpA0x4kYRZdYric4cLP6h0tYtZn9bgIq9RUJW8OByiiDYoh78lH7Cb1mhmdXxx/2ICmaSql/S4SU/RFVoJxNkh3WFOz/RudDweX1NDmDfhKFJRIdONciFbUPWu6YabUcwC7wjI1Mii8qaBxxtKdtFdXBOCTRWUGnEQLxH1L2mdQPwYqnTNM+/ZTXC0UyQBlJ6Rs13kMUsBl8E8QpkfCCK9GMIfZp6NqNShaTRA0Ws7AWwlus1ZXv610EcuA2i8lJkDzHHHhX3ePOAmj0A+41n6jQ3NlSeB46yMW6lV1SDC3QZ7XGZ3NfyGb7C3VNEzLzKVDHYDKvGaqF4M0T1bdOZTxGSaAgqat8DnDSRw9psyoSWZOcBFSkGEFUtNNy3EuSWIRMjnxa0ww17r3fhDNdceMYpc6EeGQnhU3ERYq5JI1QRDXMlijh6DOtIhUPJmcLkdlPE7v72fT831+NrdeSI12+zzauV1gIR79vHNRmUYGBhXA2/UwhITX6hD1VW6LqoZUEMj943o/hYfYe0Gx+nOV9+FDPZj9K53cf4ucpT3nTFSe+OR/kXTWFEDM3nuDgBQo6PRIgXg+TeKooNqypg5F23AiWcyWg77KPo+UbdI56ZAR7oWqD7dm1MpGY1kZjKAefmJD6ZNTC/smcRzjm2O0gM4BOiS/nr3XBHc5bc20Sa2XxZrPUts4khBdCUAFR6n0g2wUmKNeed3P1uB5Yzs/IVOvbPgSC+XCbOfic9rR44/3cl+Egx7cjal1ldBwS30hKiPYx1W1J7Hy0b28lJ+t8GwjiFqALdQYLqf65cdE8vAJZJQbJY1uUwy/PRZ1u9n76kxCGYbyDeIFVeXKzDhUmWDMec9J8Z08F2VrVcgFtqnIqiD9Bs+XmbAvdyMzCefPf9mHg28hwXF
 qBnGIYrd
 5iRZ86/NeHzWyIQE2p88BAmGXOOYBal7fYGFizFDjxgeo4Ij9kZ1OSryZ/DX02sCoNN284NgfSvemRxU54WnFmLG2kEwewIW2N13dOD0R5icBcL+lQ1Ij/bMSRJvyoC1iK5O5oOAUTFNg/zqLvN27OUheyHKxAfqnhaGs9Chfv8jNh4xX8/E6jfrJLUz1glGmCPnoqS4lmo3sRBimFwOipaxRHhrnps5c34W6LnhTBr6fWF1XdBqs50ivUDu2fD+wPg2tHsJvd5lOlwcl7AN+wFjzS3uWvkNZMmw//F+aoTsJGLZZdIjVILkf2qxRZoBw+9Bt0zujKzhSvHRXG2FWaqc+jrsgWHPJ3Kea9vAbULaWVZoL//eB91gbCloe0AI4Sgx8wSrKpAYmH0JjafAEbMs6pRbG+6rTIppoSwtrZ26Jwjchn6jjSsnIbbvk0Q5Gw7/ER23FkynzgYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-09-26 at 20:23 -1000, Chris Li wrote:
> On Sat, Sep 26, 2026 at 2:59=E2=80=AFPM Rik van Riel <riel@surriel.com>
> wrote:
>=20
>=20
> > The fair resource use from memory.swap.max
> > is to control how much of the fixed swap file
> > (or swap partition) space each cgroup gets.
>=20
> That is the part I am not sure I understand correctly. Fair in what
> sense? Using the swap file proportional to the memory limit of the
> cgroup? Do you have an example of perfectly fair swap file usage for
> a
> cgroup with an 8G memory limit versus one with a 1G limit?
>=20
> Sorry I am a bit slow grasping what exactly the fair behavior is.

Say we have a 64GB swap file, and several
cgroups on the system, applications A & B,
and system.slice.

We might give system.slice a 10GB memory.swap.max,=C2=A0
and each application a 25GB memory.swap.max.

This way a memory leak in application B
does not result in application A being
unable to run.

The thing that leaks (if anything) ends up=C2=A0
getting killed, not the innocent bystander.=20

--=20
All Rights Reversed.

