Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E45CCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 12:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77AEA6B008A; Thu, 15 Oct 2026 08:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B546B008C; Thu, 15 Oct 2026 08:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641386B0092; Thu, 15 Oct 2026 08:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42E766B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:54:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05E691A0A1A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:54:28 +0000 (UTC)
X-FDA: 85324854216.15.014B32D
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf09.hostedemail.com (Postfix) with ESMTP id BFA0414000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:54:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="X/k7N6 f";
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792068866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+aloW1e/2hgj0CG7zlWvi6F85K8Mxq4LgXboRC8EEw4=;
	b=xLOliZIQYmFPiRdW2/Hh7IYdrx7jI/urO3eV59Tkn0VGh0zXoL3F04OyVbLl/MTUdlkeay
	Z/ERtPetco1lJ2Ik1WLk3KI7McUFEC6YtZNq0XqdtLDNriMSsPMUIa6/u5D+nKT1pWB3LU
	ltLvwME690xwoWwvhX3pNWy0zxpqt6Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792068866;
	b=eReN3Oz4DPc0bWjxwQtuOMYTJU80sn0SmLNRdCQsReYMsffPrbI9jPFkRJaD1ch2NQUh/o
	akeaq35M8jKpQdpHDGrCnhJ478Q1n4gt9UmroVPsy5ZtXs9fIpCZPl9n0DMexh3Y4Tc/YG
	3YwMdwNAWLTRdaFlL23Keqo5bGyjP/g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="X/k7N6 f";
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=+aloW1e/2hgj0CG7zlWvi6F85K8Mxq4LgXboRC8EEw4=; b=X/k7N6
	fspp5W6e8UAk0tlBTGlLJqt/knJxaZv/HSreyt27UeqP/L+ZLYrf4L+Uf3gy7wgOBVXAiXzHY1zvH
	S5CWn586QQqCpePLdGEMgqCZ32XhhO3x3sEqWffk/P/+z+qjkHFRDScxg7b5tIb0cu6F01Ha48jYi
	L30Hi7WKktwyrERXAwwRlVBA+GCW/RMWdy3IBISq0OcHnsRMb5LTGwTIdABSgRX1O7sPD4eQKsFiR
	y5lb+J09Kz4B0swsv7QTJetgGBZgSNnKM8t8MKnCn/rH/nU5DQASnncdwnJQ4egOKPfT/drJ0aXsg
	ktn+E1H/oKdhqOf5Txf/J68dvdZg==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xHKxH-00000008Tlo-4A2G;
	Thu, 15 Oct 2026 12:53:08 +0000
Message-ID: <a9c30209e1fc024a11664f959d4c1b697ceab5a5.camel@surriel.com>
Subject: Re: [RFC PATCH 3/5] mm/page_alloc: convert any movable pageblock on
 a non-movable allocation
From: Rik van Riel <riel@surriel.com>
To: Dev Jain <dev.jain@arm.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
  Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Brendan Jackman
 <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Kairui Song
 <kasong@tencent.com>, Qi Zheng	 <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song	 <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie	 <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He	 <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Date: Thu, 15 Oct 2026 08:53:07 -0400
In-Reply-To: <087678bc-41f8-4250-bde9-e9fe9399e67b@arm.com>
References: <20261007021250.1665929-1-riel@surriel.com>
	 <20261007021250.1665929-4-riel@surriel.com>
	 <20261014204836.GI371161@cmpxchg.org>
	 <5234543d2c1b44706501d2e079b41e95a6a1d200.camel@surriel.com>
	 <087678bc-41f8-4250-bde9-e9fe9399e67b@arm.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BFA0414000C
X-Rspam-User: 
X-Stat-Signature: cz9ozrtxmztr6pofnmxafodxcw1b4q1y
X-HE-Tag: 1792068864-126526
X-HE-Meta: U2FsdGVkX1/9ubz7OpVOJ7OIjbg0tiIZGvNxggvLuPD1Uaw9fbch3slmmS4sojHT7lb1WbWmoiXLDCms4ZrpTBaOLvNXCY1VTS8b8Z36kq0SsAprvweAvMx7sNpnFO5Ae5WjZQL37P3XREAHoFpYUcp75fjhSEkExXTWw757RePK+keLOjluV/mdKLfQ1PtMqv8OqJGYhsU59jDW4mpcsALg11GueId1XnuIDJ8uEg79q1fdtEo31FxVMbplKELO2LGHiBOkUCo7hokFDzKAqLfsA3DRpB0tGAwZHwV3PvZVkO9JrttjFsBuPYo6Grirv5MvYsp501hXE1PFc+nJa/9bffvBy7O4aLZc7WIP+FSFC/fAb7+pcRpFCrHvYLISYfF6LrFQbGptqBOzkHfZzI27bk85GaxPaGMIx7AbSoSIFMSVhC8Y9VbCoWZH35O7BdE0wrfYdHaS4rE9S5fOQJQPMizGMQqV5j1Ee1+u7lXksUxsKWq+QBmRUURroXwcC3F2MADbcZ53f/+W+gBo7uLSOSory1tHUEyvQNgED56ePlMUGQfnSrJ7QJ9r8l8QPz83/OLaAUZ46DJnWa68HoUdmD5TKk8oXotUNCEA+qOwKtiREyr690cUHTOMcy1gjqDWU9NjgWdOF26QBvthMgBdVopRV4oBHkxtCWjlY/7l0c6wUK81Hk191NncozuFzQO763E35jXTUsd7bADzHvWbNL7YAlLEwF8rdeIlL8hxsVDJYWcjARLgwWdVh+HpUhTY4OKbPxSEEUouxaqgrfMIEqADNu0TRmpQYNvRm3LXETcWt9vTm2E+Rpsjc4OBUE3Ofed/7BDLUKa2Xf+UIRwu2DBMbnOnyQyHeJPhjkbnpUIfIx4rurlg9pbAvqMzucGfNox6k557oBPGuMUc2aSo0PA5GvZaWHzlfnCiilb6dGENP84Jc73WEBjQTcoTvuyk8lORSGid/lkPRcK
 AL9QMx0/
 XgCI0A2V4WI2ThPvtZMjHcqypMrlS3EmM2BwE6N6ZP0XFjPDJu2ndOxb99JKuLwyJP7ADbZQCnyfR0aviEGb9+EOb73rxdNW1tGsf+XQ2Dy3XG/UyEYNci5pWNXc/xOXl9UT0hRiUsgSEC6ZThbc2Q3hlu3LQmjL0bBvziz6ebN7FtbirFlPGTw2LRveAxKWmpebYcPvw7jn7qnZRO0ad+/tY3ejthAyAaAHi8HeEzpgqqbML7w9KKF58FDWKU3KMrutbL5FxIc7oJbnOmocYjKuZZV/J/+j7lFEBVtnTOGzWmbhdTbfg7K5civswo+ILc2tp2M33+pnMMmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-10-15 at 13:50 +0530, Dev Jain wrote:
>=20
> >=20
> > I have code for that, too, but it seems like
> > it's a lot easier to get things reviewed in
> > small portions.
> >=20
> > If you want I can resend this as a larger
> > series, with:
> > 1) the pageblock claiming
> > 2) per migrate type free lists
> > 3) evacuation of movable pages from unmovable=C2=A0
> > =C2=A0=C2=A0 pageblocks, when the kernel free lists fall=C2=A0
> > =C2=A0=C2=A0 below a watermark
> >=20
> > That would be the full extent of the 2MB granularity
> > fragmentation avoidance stuff I have here.
>=20
> I think your patch series applied as-is would regress stuff:
> we may have lots of UNMOVABLE pageblocks with lots of
> movable allocations, unable to be rescued, hurting mTHP
> allocations.

How should we move forward with this?

Do do guys want to review this series first,
and then I post an update with the other
stuff, before any gets merged?

Or do you want me to post a larger series
all at once?

Before I move on, do the combined policy
changes from patches 3, 4, and 5 make sense
to you (with or without evacuation) ?

Patch 1 from this series can be merged all
by itself as a separate thing.

--=20
All Rights Reversed.

