Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B03FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 07:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EAFF6B0088; Wed, 29 Apr 2026 03:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1EB6B008A; Wed, 29 Apr 2026 03:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D71E6B008C; Wed, 29 Apr 2026 03:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 804726B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:58:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 196FC120605
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:58:42 +0000 (UTC)
X-FDA: 84710841684.04.356F32E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1DB6A40008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:58:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B/9DmbHe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777449520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTK3qGUH+aUg0IddMUS22SwIVSfAhQliFGGy5MXuCIA=;
	b=rsRhMfyNkZkhJdP9PYOX89NgUh3NGynQKK2pieVLV0Fu07NIf3eHL5pLciKJkFOUuaxxPY
	ybil5f0Tiz2yHKd6fBEEwjHaCEDusRjJyFf5af5IWSSef8SsCGLycskCpXuhvqom32Npfy
	xb8GVfjFsdSwAA51UD8XHvjt+czZyn8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777449520; a=rsa-sha256;
	cv=none;
	b=p+Osb3XVg8QzPwARTGOxz5GLiLQ970ghww7NHaea9rKBqo4yWD77yw3m5i9cQx1+1f9FJG
	VtY80YDDr+cXo0SWrVgc+Ent3CqXqK1hJhBGlVr3oHMv3zaKOxkkTQq8qaLWP9G/4Ei30v
	XY28IObtCqeFKRCydOs2tzc0CBA0GGI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B/9DmbHe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48CBB61119;
	Wed, 29 Apr 2026 07:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C462C19425;
	Wed, 29 Apr 2026 07:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777449519;
	bh=kTK3qGUH+aUg0IddMUS22SwIVSfAhQliFGGy5MXuCIA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=B/9DmbHe9Zx3tx4XoFCLnlVKMDd5o3tkJbuhE+zeQksaqLVZhAkAGI/sqJiERpslr
	 lnbMnYoUKe68v+IIY+uCqJTykHJmuRiU9c2//F/nKax1RGdwnqVSxNLJKthyDljx1M
	 +DGloNRAxTzgSaHb7C12gqPiW04yftfesGO5neQC3iCgfMOAY+eX4EAnEXUWdHTXJ0
	 QOFW45zX0nzYI5Wwc+jKwjpNqpVqPku6ACup69zrRhgkiHO/qSbr5CyNU95diMEZEw
	 FoiT9p6QeLPHjB0nykiMdfXnMyeidkoioVRDol7NOI33gqnxMOgxl524EaW/kGtNa2
	 3F717YoAZ3RWA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 90CB5F40068;
	Wed, 29 Apr 2026 03:58:37 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 29 Apr 2026 03:58:37 -0400
X-ME-Sender: <xms:LbrxaRqGdWmZ1tX1KnyB6z_EAWRwBySpqD3hiG1Lo4ytAygqDaNxsA>
    <xme:LbrxaedIDIWTyrLDlpTj5w2tFIbr_WTR4bhpVqHPO1DIj8Fa15tZsSDe2hf12-5bw
    UjwiBKB7JN4GUcSRRzXK1zE0RcZKJ59uMLNRxH6b5BLlovsKmZkd1Y0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekfeeltdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepueetieduieegkeejvdehudeiheettefgtdeugffhjefghfeftdelhedvheff
    hfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepudejpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrnhhshhhumhgrnhdrkhhhrghnughurghlsegrrhhmrdgtohhmpdhrtghpthhtoh
    eptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopehkvghv
    ihhnrdgsrhhoughskhihsegrrhhmrdgtohhmpdhrtghpthhtohepmhgrrhhkrdhruhhtlh
    grnhgusegrrhhmrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhm
    rdgtohhmpdhrtghpthhtoheprghruggsodhgihhtsehgohhoghhlvgdrtghomhdprhgtph
    htthhopehlihiiphhruhgtkhgrsehgohhoghhlvgdrtghomhdprhgtphhtthhopehsvght
    hhhjvghnkhhinhhssehgohhoghhlvgdrtghomhdprhgtphhtthhopegurghvihgusehkvg
    hrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:Lbrxafro3OLUJNn86b6FPikqswzxctD_qpKHOBFuA9DZhcKtzOUQ_w>
    <xmx:LbrxaV-YWVHHjDOZlHgCdDgRvlcSeqdJVX_MH-xN6eHuRh5wuIuzOQ>
    <xmx:Lbrxad3clLUDIPOx5_C_ayrmhCBYPJ4hIbqjYZRoneS28njVdlaMZA>
    <xmx:LbrxaQBX0Zm3uKvCFB7fkOXwyBIPWXewzXr4On1MI0BtIGYvq9iYyg>
    <xmx:LbrxaUCnLYkPVEumERG95cJ0uQUbH1yPaoNj4X0h-KiukPgc15xcscqs>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6D702700069; Wed, 29 Apr 2026 03:58:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Wed, 29 Apr 2026 09:58:17 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
Message-Id: <e0f0052b-b28c-41ad-8a82-18cebe5141e4@app.fastmail.com>
In-Reply-To: <1ba0b6ce-3e71-45f7-a3c8-cdc5aadcaf27@arm.com>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-18-ardb+git@google.com>
 <82091dd4-9d11-4054-89ec-99aadaeec7b2@arm.com>
 <6f514d91-c8ce-473f-8383-f3b9a4cc2f7a@app.fastmail.com>
 <1ba0b6ce-3e71-45f7-a3c8-cdc5aadcaf27@arm.com>
Subject: Re: [PATCH v4 01/15] arm64: mm: Map the linear alias of text/rodata as tagged
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1DB6A40008
X-Stat-Signature: g9nymfy4uhp81t1tbrshzq984kckmx7n
X-Rspam-User: 
X-HE-Tag: 1777449519-310853
X-HE-Meta: U2FsdGVkX19ApbntaKfmiRUhdbp1bgpzc/erE5vKjoWYaZ6VFEyXzEeROVEDI5EgO1wd7LPp8k97M1dxdltsK3157E4v+aUW10dARZ42hMtTjUr6AxQpiWfPTWdVTYQGobBN3VGBjslvt6puQg0kCvPQOS6tAL/Bh5EsuWSHQ62FB8EIh9YrYEpih9hIyJ2Ho+1p73WWMhSrYRN3RhiXXo1VC+JPWOBvGCn6qTNuw/qtZiHL3L4ZLUtlupRrKqvwn74Moye1gTIQW4Cj5mwYMDIBsEf0PfxdqMJSvmLungUJpyD5YaqYwdkr9AMs81Ay/vk8zKhDkE4PjJBUVRhaAsAVcmgZQyA05RlsRHwt0Jw6L2tCExnsK30ZGS3ExsmETOxsrt8N6jwr0s7FwqJBDQTY/KELFwvIVsxphJq6HiT7Bzm8FRGBQsIAKw+pL3jrlqn6iY5US18yQ5z9mNIZBk2BVZpOnIhouEliI1ndBoLLV1Z1I/rYwL+A66WqXptdDaBteGtUSxsjHzUDZ4mu0DJa58JKqrcxQpqOLmUfqQuLeibKqvnpfq/37wjiVPwqQ5b03uwmM6d0s3BeUrsXY5NBjARSTOPtLqXklXSInFdvQCikNOOtaigWiX4uxUA6IFuekJ2sFddxj0pUOQ59qZJQgmHIq6H64SiJ/2UYfYofUkboZMKbXyfa70GaUnXej8yex7qGH936TFKpV9F81OJSpJLO82RMojz4T8u5gXz3qw+xBfCnEwwImlq2XxU7P/jD3Rh5VPg2KKj+/TRmUqomXhI7JXDSmdnBIe33SmAkVH3dQJ+ruGsJ/0Ew3WA5Uyugs6LVLV26hHFp+MEUVuOhnKq5f3Kwi86czsyMeYGWvCOORmPTkkWY/AsVPWKo+kI+FZnPIshM2Lts6/Mk/Ycamp/gv6YjiTgIekLSivijXyfahW8m73LueuUoJbrf9Q7Mirigf2iUaYU3t1n
 1t3Q7LZD
 Jkf+TvCpPsOXyn3UUKUYAgmtq0bNCSs2W20ijZhN+6/MQil2pDv0c4tshN1n3zJqVkwcY2GQ/hYiwnizEeRnFBtBhUILzsmCQZF2zHcjRKI/aw25MN/55LGZSK5Tir7w/BEKbgSn//vwnSq0w943jowOBtwaXM/u5C541KR2iF8UYYpDwfzaQTFe/XH6YTxg8YZm+Lv5XwW1O5UEtA7HA5dG9sKvPMHpJFT6hAzxmzMH9y/P7yC1Oj3sCjVcedwFkjD/qMxQiacqUsQqnPfl793aiuu8MtBSx1CzGuHjLYr4voW4SVJOwQXQCcs8/NlmdSgvS+Qitro6n26Uyk0Uu5P30+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, 29 Apr 2026, at 09:57, Kevin Brodsky wrote:
> On 28/04/2026 18:23, Ard Biesheuvel wrote:
>> Hi Kevin,
>>
>> On Tue, 28 Apr 2026, at 16:16, Kevin Brodsky wrote:
>>> On 27/04/2026 17:34, Ard Biesheuvel wrote:
>>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>>
>>>> Before moving the empty_zero_page into the __ro_after_init section,=
 make
>>>> sure it has the memory-tagged type. This is needed to ensure that
>>>> cpu_enable_mte() will be able to initialize the tags correctly.
>>> mark_linear_text_alias_ro() is called after all features have been
>>> detected and enabled, so do we actually need this?
>>>
>>> AFAICT the lines that matter for cpu_enable_mte() are those, in map_=
mem():
>>>
>>> =C2=A0 =C2=A0 __map_memblock(pgdp, kernel_start, kernel_end,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PAGE_KERNEL, =
NO_CONT_MAPPINGS);
>>>
>>> It is probably this call that needs to be changed to use
>>> pgprot_tagged(PAGE_KERNEL).
>>>
>> I see. I guess we should probably update both, no?
>
> We could, but would we ever access the tags in data mapped read-only?
> cpu_enable_mte() needs tag access to zero them, but AFAIU it's really a
> special case that is only relevant to the situation where the data is =
RW.
>

Right, that makes sense.


