Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C9B606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 16:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=csWSJoEs
Received: by kanga.kvack.org (Postfix)
	id 3BD846B05B7; Thu, 26 Nov 2026 11:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394D76B05B8; Thu, 26 Nov 2026 11:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2316B05B9; Thu, 26 Nov 2026 11:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06A6A6B05B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:32:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8461E120507
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:32:31 +0000 (UTC)
X-FDA: 85477813302.28.CBA52F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 188E320051
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:32:13 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9666562527
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085CC1F000D8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795710733;
	bh=yWELNjBi8fRHqO8McS7d6ElBX905qlw81apnZMTYqHM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=csWSJoEsx0ftuDT3T0VtXF8mpeIX3E9mdWEXd32YBSIGfEAAObLj+/tdG/0geZM+j
	 sKD+mtuTQdGPHnhgKOAnk2Gf9D/VbKJjwBmPrwONkxL0JCwIltFxdsmkkOaur5as7X
	 N/wgHhB5Zqgef1uKQsBmjItPhMxcTzlv8EsinDdTtd96zPEIs5cwc7BA0d6rCwwRbt
	 GAZApm7GOcjWU4YcZFtg2/hEHcduJsQq1GsJ0CEcpQ/vT3Q4sC1yle+Qit8GSqTHMb
	 cad2ruQi09poWBSd8TWvT35/s+05m/aZdUp4Dq2JGGAF7gjLdYpmXnVFXXRri0aM4F
	 SirmRYqFZis9Q==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4d28f75d62so1179971566b.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:32:12 -0800 (PST)
X-Gm-Message-State: APuU4Z/DSTXt38ICm/akN8FpFCW4rZp5bGzVnU7O0SgW52dLDn5P5t7k
	D04mPmZs+b6NTNkSBS2dRdIBAprnVORForRzopRNys7dZsz/eZIYkoNz0rEKnW9w38XQXs4JWJV
	u/iI24Nstz+eFN7Y0jz3MTCXBQOYmWUsqA/uG03Pixg==
X-Received: by 2002:a17:906:b758:b0:c2d:bd87:7fa7 with SMTP id
 a640c23a62f3a-c513ab0c35fmr1245547966b.24.1795710731802; Thu, 26 Nov 2026
 08:32:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <3e8d55101602d5ec982ae636eaf5eb4dcaad3ba8.1795439990.git.lianux.mm@gmail.com>
 <CACePvbWzE6AvbLzNFe=J5Vid8iy6FFQh0RBgr+V_jJJ4p=OEVw@mail.gmail.com> <179569520640.49764.510050912247709774@gmail.com>
In-Reply-To: <179569520640.49764.510050912247709774@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 26 Nov 2026 08:31:59 -0800
X-Gmail-Original-Message-ID: <CACePvbUYpze2_nLGAPCohXtkk+=3owoaZSk4qu-EOOm1Z0doTQ@mail.gmail.com>
X-Gm-Features: Aa3M54rUcN0v8lXSRmI54HK_pacToG9AbpguWY-LEOeAOOQtuw7uYO3f90lN5Cc
Message-ID: <CACePvbUYpze2_nLGAPCohXtkk+=3owoaZSk4qu-EOOm1Z0doTQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/19] mm/swap: clean up hibernation error handling
To: Lian Wang <lianux.mm@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Jihan LIN <linjh22s@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Thomas Gleixner <tglx@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1795710733-762576
X-HE-Meta: U2FsdGVkX1+IqEQVrTPNEiUi1Uq7kBRNFFTSmKb6RMA6JfuxWz3S0GDHjvSRhig48SkkERTDstxMYkVEl1j6T/ppYNU8u+NA5kpmRsB1iBK+MNTS9qVGTA/l9li7+Fw8POtJyfQbaJtS3nGhiCWfFbN7ZbXaeeRXAmgZRPkqy8k0UY2QI+e544PVb13Z53MXeB6kOahhyDZRiVBG1cWDF8j/aR0ydfGCHNwhM8ocTC7JLukNEA7GfBkW17DEw7eFc2IOR5Noo0uofxBykoocSLUwRUQWWkdBIU0QV5KOmhxdSex3JGz7TDt9n2wxnSrNK/piKn8mMb12QpT2P8vRfUpk31N31zdkiVQ8BX4/jTBf/7J4A4GGJ2tsiVFwDN5FTCDQYnXt+7p0WdVYqeqoixOUgfdzwHz5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 4:15=E2=80=AFAM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> Hi Chris,
>
> Thanks for the careful review.
>
> > Nitpick: Here "ret" only carries error code. Maybe we can call it "err"=
.
>
> I'd keep "ret" here since it holds the swap type on success and a
> negative errno on failure.

Ah, thanks for pointing that out. I missed that part. It doesn't only
hold the error code. We can keep it as "ret".

Chris

