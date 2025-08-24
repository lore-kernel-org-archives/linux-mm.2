Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14B25CA0EFC
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 14:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480188E000D; Sun, 24 Aug 2025 10:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457E68E0001; Sun, 24 Aug 2025 10:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398068E000D; Sun, 24 Aug 2025 10:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 289A68E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 10:41:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C27C11A0143
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 14:41:16 +0000 (UTC)
X-FDA: 83811913752.14.158DE5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 393B34000A
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 14:41:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Muzr9Hae;
	spf=pass (imf07.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756046475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owSm49TeC5mzqgkZby36h3+WNAUl4LBe3qXcknyIcXI=;
	b=AgbGlttFTWU/V5RlK/WBtYwD+VFC08/r5/JEdhcJ9DeuCZ+O7/Zb2Q3MFoKw5KcCL8XbDX
	mZwzDGEKOCt3gE1sATxeSJOXhdJdFCJA4fdQXDhFVuDFGvYy53y8xzGZgrYPPh1L/hdz+j
	704OyJkssJSCuKFf9l0mSdmqg3s3K+8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Muzr9Hae;
	spf=pass (imf07.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756046475; a=rsa-sha256;
	cv=none;
	b=evtNTFAgiN9e2t4vkCDg907NMtGoIAKNuYN3cYfyEF2Xmd8zEmxTzttk9KpPqZW3JKOmHE
	3qLhHi/2wIBToWtWxRZxSfjm5ZlfYVTbB8vhlXQVzqGEQljTw2cb0r8PenVl+5A3SPQiKS
	os2RCiLVsEy6YQL3r58BaB2xk4Ya6Hs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E910601DF;
	Sun, 24 Aug 2025 14:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464A9C4CEEB;
	Sun, 24 Aug 2025 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756046467;
	bh=owSm49TeC5mzqgkZby36h3+WNAUl4LBe3qXcknyIcXI=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=Muzr9Hae+TODCvU0qdHFU2z1+151Zf07za5TgVHmnxNO3qDjp427SN/S+uf6bmAjq
	 TIUSDTNXYCE7Oo9cW0GhN1PER96XXwLq0ymbFe+vADiSCOM485jAZMBjLWPGNqNxLM
	 I2bFBnYweYfjrI4AbyYij/8cBCdkKdtnmmWEpJ0vVYdeeypEJ22mR0lfm/PNqYsg6C
	 IgOeVa3DLOCrGcjSRd/qvrSZBW5Dl1J644hQ2mocwEJIo5nnTB4Ye4Y1/mpRtNGmhE
	 cH55ZRa9OtCVmskG6FwxcjvDxi69WaNKVNYl69lolOhaICkWcGaCSjlzL+74FPOEiy
	 V11ILETVlIstg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 24 Aug 2025 16:41:00 +0200
Message-Id: <DCAQIN9545EF.3JSBD6IQI1PXW@kernel.org>
Subject: Re: [PATCH] rust: alloc: add missing trait item MIN_ALIGN to
 Cmalloc
Cc: "David Gow" <davidgow@google.com>, "Alice Ryhl" <aliceryhl@google.com>,
 <lorenzo.stoakes@oracle.com>, <vbabka@suse.cz>, <Liam.Howlett@oracle.com>,
 <urezki@gmail.com>, <ojeda@kernel.org>, <alex.gaynor@gmail.com>,
 <boqun.feng@gmail.com>, <gary@garyguo.net>, <bjorn3_gh@protonmail.com>,
 <lossin@kernel.org>, <a.hindborg@kernel.org>, <tmgross@umich.edu>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>
To: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250824120656.208978-1-dakr@kernel.org>
 <CAH5fLgjkqcyzoZD7PP2i4g4r2uqpdbDKVW5hLfm6c9ysbxkPuw@mail.gmail.com>
 <DCAOH44U57K3.2CVDYWF8MJBWL@kernel.org>
 <DCAOREAIJOR9.2N5JW0SC9YT93@kernel.org>
 <DCAOZLKAFK8Y.43MJ1XPUJ1OG@kernel.org>
 <CANiq72=Xp-u16fboZJvdRZCveRtAJLSTsiJMMDXsd2saKCU26w@mail.gmail.com>
In-Reply-To: <CANiq72=Xp-u16fboZJvdRZCveRtAJLSTsiJMMDXsd2saKCU26w@mail.gmail.com>
X-Rspamd-Queue-Id: 393B34000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: enu68m3muiuczzk3xsxwydqdrsii93eh
X-HE-Tag: 1756046475-133489
X-HE-Meta: U2FsdGVkX18BQ7ZuXV3sptcvOmzQzmtBXBbTQz//VeuqTCoQoDK1D3OPWA34qvYeCz23kp7ggj8tfoGuS/mjgpcaa4kisvwQQvAWqcSXbb5zHwcCX9EmkELqJuAP7L6SnIIjggRqSaaT1z4aTy7kCPv2XeJYxt0DY41tcUB73RCKyZh1YJ2Ji9bIsXn4dmkpdlHP1IqHnQZMnjL5mIWDQTH9XEUliKHNlY195o3yoQnU15f96OCtQSmbawEISrCQW4PJjxO8ZufmN/Kgi269ePrzzAUY3uQWJmPQQ0/v6LYccM+F5SAfqrCy/MinBXU89bWs4WW+6sXM09BaW9Z8oHOtJBEvR9XG9y01Umh6W/MKN1+fIzn5bT0mdKzSx0VRiUYZND46+feC2J2VKJnKTvfyBsfZWCbVyZqvnOJ/oRMWpgZw7flYT2aesz6NyrwM5PJaExhqQ3Fw7EtvpOxPqu81o4kDGQiwrIki1zr57qHlrCFa2Gnaub76upObpdjDo12lNmWkTy3+V1PlotYOv1leG+S880CeklGBcyX47uaEVpgIImSkGr+H9vRQu3r8CiU77uS6qKsHcqOzdAKR3jKwyu6wELFuaQx2Dfk7bndS5iBu0kRY3mQQChYs0Uei/1QN3jyloPVQfbtDeoRnE4HmI2l//KCkjyU43xjkn4iXNu4GyXaANO8IfzuMd+hY6Y4YoIoR1WLSkNIeGpCvBU2ZUKnRUiZmqnMJufSAEPfex3PvVtHNbv8UaqqZaZvYKSp/4NpWe6qQSCmWJQ/RWhriZlC5GtLMcMtgjcLGXifKCqWpKM6CNgGEBoVdIfWpCgtaaO56mawATviB/VYu3Rlyx5SUNgCU+6qoaswNc5HxmYeLfpin7cb9750GyxRu+xgMaSLGUxwFEPHL/3DxzXkk9HiG0WrG+iNYOIon8k/rFyAaGA0W9GWiBzQ/SlFyxoKNJVD+8D3P64LoNxc
 kRZYARJi
 l9MhUQOXGsCtJMvBITjt1azoxNSA1UauH0eAB8Q76Dt1SzJWees3A2lqwf4QJTG/Jx0ntymfdMklJAsvFvQV06lJ1AXsL2iqelhmg3/mB6KOQaVSpDMB/WameVg99aUO6hXtq0SzWiH7gcrmF5BuVwo5fl4yZVsIBEt6hp0upGX5f6QSBdLtsMWP1gKMur7j68LyLxdHC5nrJvLcI2cbBW9zAjdu0iCML5ZxpSp1s/lmg7TDHlDBjHAiIKXT40YEv1PHfAEnNxzsyy2d8JNyFL5L0w1vTbWykR3FHdWf0J8Xa10iKpid5X1UVyJ+I05kZX6OdrtCLU+HCa0TatMKqVHH1sp2LYOhlCd2LqcQil17oiYfrO2gWiFusPy2xAEBOvCdfv3RNC0XGnvkPp/Q3YCttcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 24, 2025 at 4:07 PM CEST, Miguel Ojeda wrote:
> Yeah, since 1b1a946dc2b5 is in the same branch, and David already
> reviewed the main patch too, I think it is easier for you than trying
> to deal with all this otherwise.

Yeah, I also think there's nothing to backport.

I.e. the fact that Cmalloc does not provide the same minimum alignment
guarantees as Kmalloc and Vmalloc is not an issue for existing upstream cod=
e.

And fixing it for potential additions to the rusttest target in downstream =
code
doesn't seem worth the effort.

> For the other fix I sent that you already applied through DRM, I think
> we did the right thing, because it was not `alloc-next` and it was
> fairly trivial, so it made sense.

Yes, that one is correct.

