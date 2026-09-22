Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4066C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3E66B009F; Tue, 22 Sep 2026 11:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC0C6B00B4; Tue, 22 Sep 2026 11:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2086B00B5; Tue, 22 Sep 2026 11:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88FD96B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:50:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C5121C2948
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:50:06 +0000 (UTC)
X-FDA: 85241834412.10.5858F48
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0A67040008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:50:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="JAbyvQ X";
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790092204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6K3Ud4EKI3engeNS8qIUkp6OAKXd2y5YW5HabWOrebM=;
	b=b2xIrOPTHKHqFdQB2Nc/MnT2xqaN/puXyp3yptLWmxgkogc+JSXblq90plgkGhdKKB4g+Z
	s0nPbdIMOaMBjUOnvr2s7fDyUP3YZgQIKvVsBtMcjTIMSbF/3JYEvAm1oQWQCSXmiZxfT/
	0yAiXhuxY98L7PkSJZG/Nd8xadkrCFM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="JAbyvQ X";
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790092204;
	b=UEt4f8qBFYFw+VheIUNGh7+UgtZXbdLykxZDicjvI/GoLHmzRLkY2tH9IWmH0m3btui/Oe
	yyL21INyGe+qsVGqZjaB85ebrgdYHuRQmsGsfdOlalnyL/obBLP034NuBkWwf/Bgcg2Ssi
	g5rY/Bi5Uj+K+KP8drdeBsgg8kTB94Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=6K3Ud4EKI3engeNS8qIUkp6OAKXd2y5YW5HabWOrebM=; b=JAbyvQ
	XSsMgjn0TEho6JwbjAC+6MlhZm3WuAyVwsdbjj/BiRvbJSHeQjI3bYRbF+LZjdLLYapYp2Tm6yzfg
	1Yr6nkIUwU3z4mpwAts4tEMORWUQF9JrNLKy160v6+9xBb83yzqa9/Yh/TtiYyLjAT5ZDRYOXzWpt
	jpHhuA8UWbUXZ72zGeitYDGHuVD4jja4A/B2ZimNojNkNPgZl18cXb5SCt34DZsO8pC1W3ZLdvyIR
	cQXBWRZ7u2ALckyB/ahi1boUpuRHzHH9Jt238N4XCnoFResgML5BRwDrLBuaYjb8Yo0LCLf9m9nDv
	iUzFg5dH3p2uZo8/Bm5s4nz3m9MQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x92jp-00000001ofN-0kte;
	Tue, 22 Sep 2026 15:48:57 +0000
Message-ID: <02616d611c9e862afc6c8c3118b6be096756b3bb.camel@surriel.com>
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
Date: Tue, 22 Sep 2026 11:48:56 -0400
In-Reply-To: <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
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
	 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
	 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A67040008
X-Rspam-User: 
X-Stat-Signature: ftceh7why4qopiw4ubbw56nn4w6wfdk7
X-HE-Tag: 1790092203-462354
X-HE-Meta: U2FsdGVkX19IWr9KG0RrcpYBSB0X1F3DAVMYndxad7gsDqilhmA70Bth0QzSXDACLjVJ26cm08enwa6DhiP3fT4GxFUJuMy1j0M98UIgta6kYbxGF8o4c2MV9BMEyVt4YgrI4n7aKYa3jLqdZ1X7dNQ03lkaAZEAX7We0XyJmnIXuObfzLp7qZTO+8BaIoswFFtRj6GDE7QeU+oAXWMkI6xQXonuiBaN1fdXzQWO6/KDbXp8saAXZn2bLiTtINMLmsHyuuhUr3g/tI6rBv7Et7g6wn0PtxSFF7HVdnh+mVtub+dE42g8Ic9Rz4LQ6/amdDIgK8Et2YCN49iw4wKx+Z0w7EpYnWN+y0MHdIkzp5RbRCCDIX2/HqdizagKGdObW7cTB5pgUlS1/pvNjtPG0uXUsBlKhcHbYleqsQQpzxeOH6OryR0b4JNti59hCyqf8hPXrxCRifAQ2XGRc7U25gAvYWRhzLjzMUMu4mSgkFIamFTBKEmgqpT6N5HoNxxQSdhbwRrpoSEuiTuGT4uN81MrLYmimUIjYlNIc9SAbA045zt57Wk2Obe5/yBoKeyk5nPB7EJ+ItZiOI6VepSY3V6JnUNzs7E9R7HRpTYlpPRLadpuv+AezTnNtwnGSzqqrtTzWluPR/VMSqywxpI2/sQqPLCtzxULvNPfZ4+JiQ0NzBJOzeTYLZf5gNpPjfiktvZBstH6U4cTtF7y/iOwELk7SEQWdhLq84XWW0eUOfvJZWJ9McOLs7VXCZ7Y0RTW1l/3Ey0LGO+exiji26CA1oe8HHwseSsyYpO8ljd3m+M7Wrn6siMWsKXLEDQnE+sARp6VlJ4eC6damruG2trSdRPbjH/U2F/p7BLPm+LCvD1pIQ5+49KQelvUAwIrEJI7okedgMCcPLkLnjOP6Rwo7dFTTs//KlKVz82dOy7mSvH4/4Kb8YY3pmFxWcyrRvVS7ihFW4AZ6x2l+6jRAde
 8NeNwfOE
 ZagP/rWpEzWqyTxFk2YQgNSEffoERo+XWQ/+OrekPvul2cq6pMq4Gu9kVcy7DWdqOfcwYOGo2mVDoEON9St1FTBIv539CFe/GrQeDQxm5Hpj4eiqed92p3nAEDapTR/hq05ra8ZwCFsAK4T2J+zAUgQjPAjwvcFRotDjUyyDox8huJr+mPRksSqZu6NhBWGg6I6OFxOxM0CyFenBuGswc6RSn+y2VxBDfnT9UQ7uCx2ypHYDWJFreO2YOADDjfZYN3LrQrHI0w/Unjgev+1AT8OJdN4VFyW11u51qb35mfxghjQ6baK164BPdXVHknKT0ONXBn39B4qc6R7F4d2SG4UJ9nAUWyYtVemyH7LAcfjS5kdf2+jrGXHKnFxDiuY7kh7oN3htKbTlwmw28Y31PLIzBsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-09-22 at 05:23 -1000, Chris Li wrote:
>=20
> > > > > > Zswap:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 8812236 kB
> > > > > > Zswapped:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 24927876 kB
>=20

> My original request was for the whole system: what percentage of the
> total system RAM size has been swapped out to zswap.
>=20
24.9 GB out of 64 GB is 28%

That is how much application memory was swapped out to zswap.

12% is how much system memory is used by zswap.

Those are two very different things, and it really is not
clear to me which of the two you are talking about at what
point in time.


>  My observation is that, even with zswap, when 100% of
> system RAM is swapped out, the application suffers greatly. There is
> a
> reason why we only have 7-10% system RAM swapped out.

You mean for your specific workload, you do not
want more than 5-8 GB out of 64GB to be swapped
out?

That is perfectly acceptable. You should be able
to configure that.

However, your configuration values are not a good
default for my setup.

I believe we need to set the default to something
that accommodates a diverse range of desktop and
mobile users.=C2=A0

Most of those users do not know what they will need,=C2=A0
but they will know to close a few browser tabs when=C2=A0
things get slow.

The companies running thousands of servers that
are carefully managed, and which overwhelmingly
have the same configuration values deployed to
them are more than capable of setting the dozen
or so config values their entire fleet might
need.

--=20
All Rights Reversed.

