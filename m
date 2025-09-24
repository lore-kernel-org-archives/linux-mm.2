Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E33B6CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D1C8E0008; Wed, 24 Sep 2025 07:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DAA8E0001; Wed, 24 Sep 2025 07:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333E08E0008; Wed, 24 Sep 2025 07:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BEA28E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:03:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB5C91A07E0
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:03:45 +0000 (UTC)
X-FDA: 83923858410.15.1F8FA15
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf22.hostedemail.com (Postfix) with ESMTP id A8353C000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:03:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="sg2/n1Gk";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="N dn8VqG";
	spf=pass (imf22.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758711823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jb3EmJHOwAdkojmIjPqDHZa58n3wYX161nLGH6EK/8=;
	b=L6UQjo4ee1KpR/N4Pz/6OotlaS4boTCzZKeIP66yOPPSngeyCnBza6X/pniGkywW5FixB6
	LYgpwo4lSuOe6i6AtchaN4Wq/iBo1lmXmTnox3z/V65HiTvXkMi6s70liO/lVkAj+qF1Bi
	6ai8E010p9y06lCyXbmcvyQ80RybiB8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="sg2/n1Gk";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="N dn8VqG";
	spf=pass (imf22.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758711823; a=rsa-sha256;
	cv=none;
	b=P0GDg4pBsjAVOam/YlKsgDy0C5NWrLoqZQaBplQhChMG3NODJT/ZcUswMO13KLZvSVv3aM
	0J8B2xyxhwQwQ6fd8YeV2wn7RYBYMzt9ASOQ4yLyTUVhDWgKCf2vDFgowsHcYHgC2npGQs
	l+dTuxN37+i95eb8HSsyx8baZ6E3pAo=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id A47251D00107;
	Wed, 24 Sep 2025 07:03:42 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Wed, 24 Sep 2025 07:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1758711822;
	 x=1758798222; bh=8jb3EmJHOwAdkojmIjPqDHZa58n3wYX161nLGH6EK/8=; b=
	sg2/n1GkkHAkkymHZC5B0VViG7BHavGb3EmtPTalauCQWPxofJycgm+KBd6MDWw8
	49TzjE17Wa4MiTnTO4eRcshDmlFiLBJDWsvoYsXVaH0UP3Zyz+vcA4GtHqsa0gdo
	orKO9bDvqwnxg3dIzC4Vi/1e3twwmsqv7UtJXX9P1Ex2NO0BvATpGNQrpWmC8jlS
	w5RuSD7863WRmsWbaM+ABJMssdH0AoU5FuJkL6WMB2ZDC6nFWq8c+SmL4DHRvNW1
	FSns91GeSL3j4T53TriQOrRcB9liM0rDZ+DqvJVkrzBhglHkKVpa/yMDnDzWU4He
	dep/1J7sWbi/8bb6AnJg6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758711822; x=
	1758798222; bh=8jb3EmJHOwAdkojmIjPqDHZa58n3wYX161nLGH6EK/8=; b=N
	dn8VqGRkYx3Pma/EBu4KfrVZoWdlmkcLohs9LC2/txSdJN5fZpd7KAi5+/pwsGiQ
	su6Zm+x9dgsqD1zj+Z/YgAY5SIsfLSG+befkTZPZyGRmx0ne3o4d7nR2OeEU2XGh
	UB5mDvFm0nU38i3aNHJYSp6UJ342S5reuLOwByXFXuo3emLy4Rk6/byTtsJ/XMdQ
	T8mq4tH2IpaErLNJqb0Vs8n4jVNJ0IgmDPc4hlkBzlm2GLbntxdKu7NIc5Gsnkvl
	RMmMVE5jTjNPDROgZ2JxP0xe0dx3K5jjZ0Q6lu28lSoJYYvnPQMN1uZWKMhp9PEu
	KJi//MsGwDU4cRw4vbHRw==
X-ME-Sender: <xms:DdDTaC8_t3mjd1ca1yrhG3a88IGSSUW6YfuLIGnl9OvBOi8znjcQ6A>
    <xme:DdDTaNj0rFLDLhblP0TWEcOM29qHy9tymCdOwfE2nFIsyskIzjfyZ1InwmVZRsINN
    M3zSKx8BrnlYyFpRLot2d4lHvTl4i35mLMv76DQC128T4ZGsa1fNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeifeeggecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpedvffeiffeuteevgfdtffduiedvgfegleeiteduueekgfffteefvdegffevieduueen
    ucffohhmrghinhepudeiqdhrtgdurdgrshenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphht
    thhopeekpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehthhgvhhgrjhhimhgvse
    hgmhgrihhlrdgtohhmpdhrtghpthhtoheprhhitggrrhhkohhlsehgohhoghhlvgdrtgho
    mhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhope
    hgvggvrhhtsehlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhu
    mheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlihgrmhdrhh
    hofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepjhhohhgrnhhnvghssehs
    ihhpshholhhuthhiohhnshdrnhgvthdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlh
    esvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:DdDTaMewBAftm_7vrZZzklPk0qvmueZA-aZhBjCCWvPF78s2EKK0pQ>
    <xmx:DdDTaKMM_p2RjZZvKvfEf5gNmHZ2U9xd3F5j_ukPvckU7sHUSQ2MaA>
    <xmx:DdDTaPsjjQfWEGLsA8uozdijZ5fZ_BN9tDWqy5Nu1EMkViBxVkW7BA>
    <xmx:DdDTaDC0gw2E_ePuyejYTiqd7ajQtTjBCJZYWfGsvBgzTszCNGNeuA>
    <xmx:DtDTaF2wN4VQRU1YIljIVLV3F9nuxA7GzuTpNaJLjDDanKik0gNrPHUs>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 79228700065; Wed, 24 Sep 2025 07:03:41 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AxP-iOAFlspw
Date: Wed, 24 Sep 2025 13:03:11 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Hajime Tazaki" <thehajime@gmail.com>,
 "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>, linux-um@lists.infradead.org,
 "Ricardo Koller" <ricarkol@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Message-Id: <b55251bf-625e-48c3-8c60-eb4f8358f397@app.fastmail.com>
In-Reply-To: <m2zfak7mnd.wl-thehajime@gmail.com>
References: <cover.1758181109.git.thehajime@gmail.com>
 <4a9dde10c586883d20a8201ca7d76e6d7d52eaf4.1758181109.git.thehajime@gmail.com>
 <a58620ecefa207e141a435c36492647c3d5bd3df.camel@sipsolutions.net>
 <m28qib8g1r.wl-thehajime@gmail.com>
 <6b1abe384237c8129e8043ecdfdad77758d2fd2f.camel@sipsolutions.net>
 <m27bxu949d.wl-thehajime@gmail.com>
 <CAMuHMdWAdhiY=MiG5JtboffSo_=D7TD5vFM6Ui5E8eS_VJiJ=g@mail.gmail.com>
 <23adb61e95275251e459513a03ab7d2bcf1f2e07.camel@sipsolutions.net>
 <m2zfak7mnd.wl-thehajime@gmail.com>
Subject: Re: [PATCH RESEND v11 10/13] um: nommu: a work around for MMU dependency to
 PCI driver
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8353C000B
X-Stat-Signature: qq3mcg5jen688wtk5mkxjenmyuit3xao
X-HE-Tag: 1758711823-339914
X-HE-Meta: U2FsdGVkX19P7mRLkw5TFJYLHmebr7TfPdCGsBQQZD4zY56qVdXo36pHntkLZf0q9DaWbrdZq+RKqCGhZZR0xNX3UV16aG+z1aEGZls5rEYmNbsi7StOXOEpIRTh8Cd5vsDlQDSKMlEVLUsgtWFlsuf76BoV+tefa4DmSysmGLoDloO7ob/NBM9ge1Vm1dzkEGJzChY657w6D2awfx3YAlEKMF7GTCt20PzfUPZaKBp5ry34b97DqTqrgkqFe/PJcHSzziQKnhPg2I96I/RNuDbHJ1wwvPeOfJNnOlFK7PVJQoNFWDaPtAoaL7JYZOqs6i6Txo749SBp3/9TnZs39TyQXcrnc3L46JrLbX0KpD31p4n/TqoD+WuKtuYijF+8He5iQCss9iVWGpfujyQB0fIanip6qNPojgWgfFjOXtKssmF38jt0RxAphtE9U9HVuVGu8HBfvSOVc7GVq0e0Ju+E4l7EoDqt1p+uhuoqFQ4ncVqZRO6hG2Abq6LeCcmL3qc/NbV8P1xPwQic02lXhLR5y8LtW3s//gX6e/PE3s4Vg3RbQw15YlHkXdJpTiWKFJncOuSjDpoFj5deblV/EBzmdZDpZUszx27+5zEtH0/lZLlK5B4817u9LP7g/jBka6VEZ+peeW2sBqNSzgGo9jZTKjq2g/m557lEeka0ysW7Xp1yLerSW0K/RkJ9S7FK9TwOCDWQP1Up1l5ak/0y5JQN5YfmSeIJ/JEcbT2IHyblf0mEqv3a6TOEcHn100m1YvOiIR5GjslAkRninN1y2X/EVUVJ4StEpbxPUnpatfCT1UtThvbf5dD2ecPd+KlDBo+jtDaKee3y7A3BwFnBiDjT1Kq+EGG3yr7RJKKfVJtxdGG28BXpV8eet4XEiZT6bCzBQNoYJri5fMf0h4r8GkeO1rv8OvGc4jG7Eb4gL89sIzwqo64+Upe1hefMzYJNmBmXCDqDsE7Jk2qBu1R
 GVmO6rpt
 7LdZzfgu+hnil2JZSKyWyMeuafhG1HGeKPmgFwLpXR9UHSJgbngb13bysrtGKbQVqQavxTvBUzkLaMa4OsveUf0g4GoQLbT8dCa8ymQa3CeAFZ32kUcJQmR/KVu7rULjOIA/QayD653mbvogvo11gPWKVDW+rNrk2QbwBr1XVa9yU4MbIhplQdaqmEZ+UvORIZk9qn6/6/2KKMglRenl599XEHIbApiB4uAZm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025, at 01:51, Hajime Tazaki wrote:
> On Wed, 24 Sep 2025 02:13:47 +0900, Johannes Berg wrote:
>> On Tue, 2025-09-23 at 17:42 +0200, Geert Uytterhoeven wrote:
>> > > 
>> > > currently, drivers/pci/Kconfig (CONFIG_PCI) marks as depends on MMU,
>> > > so we cannot select it when CONFIG_MMU=n.
>> > 
>> > That is a fairly recent change, see commit 8fe743b5eba0abfb ("PCI:
>> > Add CONFIG_MMU dependency") in v6.16-rc1.  As this is not a "hard"
>> > dependency, perhaps it should be reverted, iff you are willing to take
>> > care of the casual breakage?
>> 
>> Why though? UML with PCI can't really be a functional thing, only a
>> testing thing, and testing PCI on !MMU when that is actually impossible
>> in non-simulation is pointless?
>
> currently nommu UML doesn't come with using PCI except building under
> kunit (ARCH=um), but I have in my mind to use it under !MMU
> environment, so would be an option in the future.
>
> and this series doesn't include PCI w/ !MMU.
>
> so, I would propose the modification to revert the MMU dependency when
> time has come.

The reason why it's currently disabled is that it was causing extra
work to fix build failures in random PCI drivers that individually
have a CONFIG_MMU dependency. Since we know that none of the NOMMU
boards we support uses PCI, this was an easy way to avoid work.

While there are still developers that care about NOMMU Linux
and test it on the platforms they use, the NOMMU build failures
usually end up in code that are irrelevant for their use cases,
so neither the platform owners nor the driver authors care deeply
about fixing that combination.

If you want to be able to use PCI drivers on UML-NOMMU,
you can probably use

config PCI
       depends on MMU || UML

so it will be ignored by the build bots on other architectures.
You'll still have to decide whether to fix driver code when
regressions in PCI drivers happen, add 'depends on !UML'
to individual drivers, or just live with randconfig failures.

      Arnd

