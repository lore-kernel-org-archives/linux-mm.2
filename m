Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48B8C4451C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A386B0095; Wed, 22 Jul 2026 05:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8416D6B0096; Wed, 22 Jul 2026 05:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708726B0098; Wed, 22 Jul 2026 05:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9676B0095
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:00:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8D01403A3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:00:05 +0000 (UTC)
X-FDA: 85015815570.10.46EED7E
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	by imf21.hostedemail.com (Postfix) with ESMTP id 595411C0009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:00:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b="YT36mr/c";
	spf=pass (imf21.hostedemail.com: domain of quwenruo.btrfs@gmx.com designates 212.227.17.20 as permitted sender) smtp.mailfrom=quwenruo.btrfs@gmx.com;
	dmarc=pass (policy=quarantine) header.from=gmx.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784710803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJEvk9PRc+dAOULWtuGI028x7xi2KJpmGVIk8QHLEjk=;
	b=LcHVNtHHOV5QwkmNdGwHzl8MTwDqseZu8MtmXCRzYJCml3Ic9hpXedNfPcnStjRgpqSwUb
	XfFKDXL5bWJxTFXCFd3ot6Xs23dbGZC5ilH7hCLUui/V22YEqHnW0cQ9K+B9XVgVXj8YjU
	WGrce5UIzYFL8Mk0Ux3TFRnElcubzso=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784710803;
	b=eUH11cETEZoprtohdl51RCM/Ww/bxP1Y3vzp083wocReJbxGKxwJ7HoqXJybltuQeB8+J5
	bGBbG7IHWyVn/od6cyxhcQrir/eBTVvmksiJE/Lgx1EnQpPIwxdxhpA5smgZGW4+oqK8rh
	H7uh6mrRPrGa4Pb4qXBBc+HtOm/SXbQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b="YT36mr/c";
	spf=pass (imf21.hostedemail.com: domain of quwenruo.btrfs@gmx.com designates 212.227.17.20 as permitted sender) smtp.mailfrom=quwenruo.btrfs@gmx.com;
	dmarc=pass (policy=quarantine) header.from=gmx.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784710798; x=1785315598; i=quwenruo.btrfs@gmx.com;
	bh=SJEvk9PRc+dAOULWtuGI028x7xi2KJpmGVIk8QHLEjk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=YT36mr/cWgG3iykU0sfh1OBB99RBX1REgmJsT95DOAlz4q7OD/CTpXyEE4qYOw4K
	 K3nPZT3yUDd/5AcJHA6uc4jA0/xGglR8S3r8q+KoSWbQNQPFjaWc/UCmcxqF37G/U
	 sAwumFIG8ij/8b5z0Zi1t77GaLPvK+UHx2zDcWwzbhtBWYReSXETJEU31E3qlqx2P
	 fYJ0xrqdNcZyvNNClkdZVLPh/0EEre+zqGd6fW8ooQim8CXgEj92W3OL0mu4ftWjw
	 rgkpFoFmk4T3YQAeoKn3ArEmiviSlGciVXKb2AUuOlFrODAnUJKvg/Qvgs8itbjWy
	 ePL41Zivy+qQIrCBHQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MsYqp-1x71ev0trP-00zWko; Wed, 22
 Jul 2026 10:59:58 +0200
Message-ID: <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
Date: Wed, 22 Jul 2026 18:29:52 +0930
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eiHsBYLYS5bUAoEUhm4mZbRlh0iSkrH6b56z34zqdalMVQn3zdC
 EV8WBXfxpAqGPWW1DnA4fRREpn6sRxfpsD3Vw6SQ9bazn5ph5aE5ub7p3raG7xhGn3Qv+fr
 vdHtGXCTJh7Ozb9yJ1RU4NoO+KGXlh1vPRbW27piiOUx+wDwhkBS+jxqjvg3k3Qu4IpyllV
 dQttE+3dQ3Ep/6+BNlMyA==
UI-OutboundReport: notjunk:1;M01:P0:MCPsTINb1J8=;wUvpAEnxIR6bWYCFJzvy7BroNrn
 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
 3UCLdTNfuREuW4NwxlWTi4BvjqkaCB
X-Stat-Signature: tdtfejnb99khgw6qiqec1euydcm1o5ie
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 595411C0009
X-HE-Tag: 1784710803-912379
X-HE-Meta: U2FsdGVkX19T98EFvfpk5JZqs2CrKE+6iZpReNK+jvPcSNj3QZI27h6K4MHwO/D/jAfwoXD9Arw1cgpqsAvrQkIrXIGs467fSwy2s126Y2VVdcyHO3TDSjYffipwXEl8jpSw7b++Bnnwjtw8PGvJpfKjWG7m2rAtI6rWaR4EwIb5H8Sufa+nQLih4WQ5w9KJk2Gw2HOlbMxmDBm2Oqkf5IL+EEnJZLpTrTaucgD2RP0pXc/PBSXMpWS8XKs1HseXkU8aSxNjb4hsSapwrQBoSSm0o09xu9GYdUKzm+7XAbzK8qyx0g0v2Nw4wkL3ZOUt+4WnKSezsIU06K3SzsVoXeENxJNPNHNigW8X/D1RKYILGOffwraWcMcOv+Usz1rL/ByARlg6ZPj3r66mG26yEddGkxmX2MoZLlOK1gPiaE2TdvK5gYzVsf6VbSYfKLEEjvpcHNBHbeCtPOjrEHdB7XOXLn4Ql4eRUexz7KsVJMQmJx1L01nFNrPf3Lnqjid6z8+9D79WiR99jI3rd0/On5X7rcdahetRWqmq06/dsWEIprsF1/PS6MtAgZV5NUByGAWtFaHYxVRDhajodqn6trblEUCEqrqr043ktFEhUqEbRzbX9jlXcdxCPh9fLVFcCJ8e0UDyIoJJcHI1Zn6ISf6JPjf9h/7EgofSS2Wit8W90Yfzc+BBLv0FXXrFDn9Iuhd7lzkgpMKBowhWdeBhDahLG9DCjmbvMbI1BHonGUpB5egHGnAAPG1Uamc3wcSYJCbi5AugKpnmZ/QVz4oiNxSeZtN8fkM8XxpbcfHpb3R8uo4RJp00Bf1v/A9JsP9QAwd8UtnhlKVvL+ZuTmBIgW3kzepyPbKktRvWTgUzmcBHdY3B1qyWpkEUIX+4grL3FzfnVTRqNO2FTtWBZg1aPu0kkZgbUSMUoBBfEdNNd9Qe+QuA0fpOlxlH4RHhQKwCZSXNot6nKE++iFffl+A
 98IUk2C3
 DA1bgO2u/lM33KlnNH35sdrMW7VowFDrEg2dlk9G9AjGM2sUQsNuVBRiYpzZv6QGX/SdVOLNypZAS+wGN/Cuutq8W3WNGl6/hfvSytK6jZ/W0hPNkJ+amf27mnSgGRQDtBDAF8PHptqEtXLUBR9ShyDzJevobqmLwzOs5EaDCEDw6cCW6N7vf6iv5LK4PxsQDmsgWb6IIx6kR3NtxizZEIkdLWyNlFMYi598Pr++oFDKhdmEnDzD0V9SW34rqfvh0Fj6yzPesb8b2bZ0igpMGycPU35uBcxoIZOtnwMHLxx31JrIKqYZ/fC6T8s3FFefThWo4e/Pid7aO+ZBkzN+RtRykvMmdMkRHzzoGQTD3CSBHyLSn2yeQXwKujpNJgpxDIKpsMO98wH4U2u4KZYO9NCqHEZwreCejdt8XBzCLpjX7KRPhQh9hAM5m5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



=E5=9C=A8 2026/7/22 18:05, Christian Borntraeger =E5=86=99=E9=81=93:
> Am 21.07.26 um 23:07 schrieb Qu Wenruo:
>=20
> First, thank you for taking the time to look into this and trying to=20
> understand
> things and trying to explain things. this is highly appreciated.
> I am still trying to fully understand this myself. A question:
>=20
>> =E5=9C=A8 2026/7/22 04:41, Christian Borntraeger =E5=86=99=E9=81=93:
>>> A folio can carry the folio-level dirty flag while its btrfs subpage
>>> dirty bitmap is empty: btrfs data mappings use filemap_dirty_folio(),
>>> so a generic folio_mark_dirty() call sets only the folio flag and the
>>> xarray tag, without setting any subpage dirty bit and without a
>>> delalloc reservation.=C2=A0 The typical source is set_page_dirty_lock(=
) on
>>> a GUP pin,
>>
>> Shouldn't such folio got its ->page_mkwrite() callback get called first=
?
>=20
> Isnt that called implicitely at pin time?

I have to admit, I'm not an expert on the MM part, I'm mostly a simple=20
user of the existing MM interfaces.

AFAIK, the last time I brought this thing up, Christoph mentioned that=20
dirtying-folio-without-notifying-fs is a bug, and fs should not and is=20
not able to handle such situation anyway.

And that idea makes a lot of sense to me.

So adding MM list for more help.

Thanks,
Qu

> At unpin, set_page_dirty_lock() re-dirties the now-clean folio.
>  From what I can see, this is not an s390 invention but a sanctioned=20
> pattern.
>=20
> But I can certainly not exclude that this is still an s390 specific=20
> problem.
> Let me dig a bit deeper.
>=20
> Thanks again for your quick response.
>=20
> Christian
>=20


