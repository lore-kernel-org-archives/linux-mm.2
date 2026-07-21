Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E44F6C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 11:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2CBE6B007B; Tue, 21 Jul 2026 07:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDD26B008C; Tue, 21 Jul 2026 07:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87EEA6B0095; Tue, 21 Jul 2026 07:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4615C6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:38:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96A158045E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:38:14 +0000 (UTC)
X-FDA: 85012585308.16.A187F58
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB21E140004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:38:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BDjWquY0;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of burak.emir@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=burak.emir@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784633892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9NUNCQBY2Ha0fMR5awCCKQ+FwcUtIWOZneVpKw8Ws4=;
	b=D5o/VUhxcI/nlIsTPTrpuI/024/a9eKrzN6kCJaurhh+5HheKIxLka84usope7116egWM2
	KtlKkBh5zY8whVkAIG5DlJp9vVcYIQX1hTCxy2YGFlgjZnPcwIUw8sDViVe5R4RY087pzb
	Dq+HXUn3wYMtZPoDgki28lFB92RkX3E=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BDjWquY0;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of burak.emir@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=burak.emir@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784633892;
	b=hw+pc2qL+vES/i5lYAk90nhG0VZIGJ9PxnrXGR/5rxUZyzo3AwNcT6aS0K3c/ohw58Ht+r
	PFBy8BkYWmUbe7VRpBe3ZQAcFkPsXvmv2DkVnZ6b04l+FYrYvVXVfIsCAGCtWX/0w5R5Zd
	8hSdo/xzIRTV3MpdlDBojFhKH2K3Jh4=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso12137813b3a.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:38:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784633891; cv=none;
        d=google.com; s=arc-20260327;
        b=rnmRrhJcLlMDJVoh8V2ElOGspeZQz3YkJ3eMExQgGmepudcUmrI3tugdYkm5FY5MGE
         Ql2C5Yw6/rTWMAoBTYqe6vKJT/UPk0qwtnIZKMHEIycyPta1+SnQ6LnEBGTLeSyDwEUp
         ljHYLa3JatbvmWZA8tXjY7mRU1PHk8nwlnueELXA8Z6bnAIosypgYwfEXGopy61/I/tA
         SPbwtoUSNQ6sJTHP/VLAcnPdGoxIzZX/dCiSYdYtCPeaGNa33+ccOfQ+fyuwo9Zcot5u
         RkuSPOcjEFJmtA5+DWr4IP9h6A71kpQjhOTy1KxUAcv3dElVD21Fsl3fHoYYqRh9eZEG
         +Peg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d9NUNCQBY2Ha0fMR5awCCKQ+FwcUtIWOZneVpKw8Ws4=;
        fh=r86Qf/jmvHJWKdBWcOqtPlHZXfyEGSlsak+1FMMjTxw=;
        b=bf0rutVWTrA/tdO+VDlbWOslI11Fk8jE01kV57FQHzzWED6wQj8EpdNH/OVp/b9fnf
         HkWBGkTgSqkNfguHAdUNBiHMZCJux9hge14VPJyUoMs3JaxjCtIJzqDxIIg33MuJ71SG
         sHqfXDYmip1fFMbBXC5Pwm4DXaDMJBfpYy86bBusumWaY9IPueWFayuqCGlOBQw4KVqz
         VOzfho5bz8SOEgjRa5D49LEOtCTRkBRPnJha4rIluFqiLUPqMnrrX5MOic0zVyZzf1k+
         RRf6TGB1C7fVNFSlrPia/xwl0PGODwyreMpI28+PRu2aDHAQtl+xdtnchmMOj+8EaNtn
         vbgA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784633891; x=1785238691; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d9NUNCQBY2Ha0fMR5awCCKQ+FwcUtIWOZneVpKw8Ws4=;
        b=BDjWquY02lFS3cE3lCLW6Nas7df/ev5Yg1Qn6w0eE3Ywm/TNCCxrUaZa9+kpH3dnT1
         Gg/OxXQEy9oxePNDm9ivzVnXXWeskr5c3onkJ253Iugw+uxZv/VCa4/OEli2JX4RqEDT
         LdtUL79sFRUHRnqGcr6UpXXb4CzofFWGew0XonDCDvK8Bm0lwVuBAgYHbiabb/vzpkEN
         7eJnz3FPHvJ/Cy2nXxKLwB08UrBd1C3WqaL7PWoOwVaMIEW8u54dixNVIJJ3X7xcFGR8
         XMvLsOHuT7suHD/qnRM9hXJ9x/t0MyfGuk+I+bkqSBfn2V1Lt6EBcCTL5ObJOslsd3hJ
         b0ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784633891; x=1785238691;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d9NUNCQBY2Ha0fMR5awCCKQ+FwcUtIWOZneVpKw8Ws4=;
        b=K61EKgL8TaDnh0cxzc57hkSI5+s4FTlZ+trzLPKO9B/QxPF/yPO6Hw0pSIKxTLTmHs
         npBxVJCyBuHxbUJlDzXeS+9L2jxSQxlI3yBM+BsJixSixODvvBc2/R1gKwKWuz8f2tfN
         g7YGuOXC+Nq6lYy89QwMfmOVrxkbSjLrFBrXvdWsUaSkM7gnSJZ7jqmcNCS42mHn3g8o
         axLDPtrPIvvaoZbDtFpixC1HzU1t2oJpbQuPzMxE6QJz/r6SvkOijPZz8usCDT1aMiZQ
         OvjT4Q1tIX6GipyTUlGsXYS0iRbDz5nGfJeMnMvMZagYg52tURQne6/+ZIw8keqJ/Fa/
         N5dA==
X-Forwarded-Encrypted: i=1; AHgh+RolwhF2l4x7ZL2EKNb0YE1usjS2jqZ56jJTU8TjFV6tACxGxqOLqfnMDT1vMrdeiaMVPK1ccNcrsw==@kvack.org
X-Gm-Message-State: AOJu0Yy7rn+prP3mvghpG5Q5D8MsD8fH1uHwNUnIPC5ReLpb6skM7oIF
	CObpRNzY4zTIvQKLZwIIjhIxL7FwJRNvG6tUipcUXM6XBxNzR1TKSa8gA05LwASyflJc/Wp0+/a
	MTdJt58h4fXTPF/FbxONLIO92WCcF+Wk=
X-Gm-Gg: AfdE7cnRUCUP3sjv9GO3l2kDsFzI7yYc29LCJ3enEVO5Sogw6UP2kYmYoZnGOSxw98F
	+/K2+wC9yFOsFcalaRhjeyjwP+QIyy1u+nucg6CjWjpKOeKB6W9VwUp6rF9clf4cyki8gs8DtQs
	WrJaYObFk5eUUpNOGWK4vx48SCNCwYqtpjfZvnSd5rFJAydOKei81yLt/GB5tPWjF1rkZerEHrf
	Xn40jJAjwqk6rqYG86XcSpfx+UhxFyqrO46xs7fIRmF5c0JS6+lmNL19SNuwJuzFMEUUHVpxYP7
	+ZUavP3HAXyLGTwjcg5WwJHjBPBzZ1i0MGqJ3P4kAfFUkBsX
X-Received: by 2002:a05:6a20:4c8:b0:3c4:1c9f:d90 with SMTP id
 adf61e73a8af0-3c41c9f2e30mr1087330637.39.1784633891394; Tue, 21 Jul 2026
 04:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260711-id-pool-move-bitmap-v1-1-cd5b7efc2c12@google.com>
 <alzeHwmGJsmK4z96@yury> <CANiq72mz9bvrOn14yVtEOLf9BW7R6mS+whRszmcA-WNMuftcNQ@mail.gmail.com>
In-Reply-To: <CANiq72mz9bvrOn14yVtEOLf9BW7R6mS+whRszmcA-WNMuftcNQ@mail.gmail.com>
From: Burak Emir <burak.emir@gmail.com>
Date: Tue, 21 Jul 2026 13:37:59 +0200
X-Gm-Features: AUfX_mzyvPf1pqj8L_1zI8QA_CFWBNHXej8tHPjZ4yFWLblnn5YE789ywm_Fj40
Message-ID: <CABwQupMxu+7J=NnbwaWoKQjxhU-gO53DHsvZh=g0NxpJyQnTrw@mail.gmail.com>
Subject: Re: [PATCH] rust: bitmap: encourage using xarray/maple_tree instead
 of id_pool
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Yury Norov <ynorov@nvidia.com>, Alice Ryhl <aliceryhl@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Eliot Courtney <ecourtney@nvidia.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Hubbard <jhubbard@nvidia.com>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Benno Lossin <lossin@kernel.org>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun@kernel.org>, Carlos Llamas <cmllamas@google.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Danilo Krummrich <dakr@kernel.org>, 
	Gary Guo <gary@garyguo.net>, Lorenzo Stoakes <ljs@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: AB21E140004
X-Rspamd-Server: rspam01
X-Stat-Signature: ozkjwcxutqw8o73bbu6eba773ipduzom
X-HE-Tag: 1784633892-515308
X-HE-Meta: U2FsdGVkX19yrwkGGNCqodvMs/l2SRBw4C1Vwech6cTZvoFW0CiTsrW036kNCxeRGCd3eRNbncFGJ4xjXQGvd2erFFb2kE5PzvqAsBDrf0Tr5pgJ/CrwiMeIHIqhNW/ig83AG6D7FFVdY4gMXotbJylUmuidQuX8znAggeXi68qDKIiY3iePF1CIkyaDc7xtRd2lavQipLgtzbtJuraohIYykr8ptOLZduRJWH2XgVsn95UinPx4ViPaucirixLira9d3cC9KL9bHGbLUTazMaq8sxQTUVQkekj3t96NAKVD/+zJcqgfyTwPIacEabQY+WPwUYkje1pUGa7LCXuFLGO4mgXy87m/1FC1vxsVplLCsvYU3gyMf1zdfaz7B5m6l7qi24NoIF64lAVsF8pCMYOwB85Aq6DEhV1+euoJcYLazBfwFI4JIgOmqQ3yOnn6go2WCJgNZbLJTvQf3CCGuT89uQvWt8hg/MTcaJ0SpHIXoMXAn0g6KSpwIAHHyaqRg8BiSbmGCpQGQp5EUKzuzxk+/q995q05mvZVug5wVh4GIR/VcNaDIbB7dIHuje/5+R4ygo4qwnFB5JQd9yM4l25XavZdGy7RV8fvWXf4t7wQ1ijSS6F0ydeCWfFi9/Y8ruxXXe4JcK4INjdy9NDRKseodOjtIFSKRRheG4UB8bD5HHYbgs03iuXftfU78SoDSxfbQjd+t+DeqePC99PC+8h8BCoMWr6AfTh2SfbX9m6k4JJKZSby6DHJFTUVTLeEWzIF4aoEZINSUPjoUDBzTlbIr1eRVbE2Rebf1JLuUh4I9B4O1bzmcy/999THD6CP5U5TrxJviXmVRSWlEYXStSN0c6MIm+9VnXxzBLGHcTljFjwgctJFHyAaNOfrhnD62NVTUlq9iKxIP1zox1zJMKdf2V8TQQAkkVtIIK3bcMnHPticOeC31+MOsIuZdH9EuL1rumGgRhP+Pjcpv4M
 BJVLOVPv
 gBUCl62/w/gKNWLgtAmBWrXplQDubO5BZQaruGmrAIJRgxlKc70TaBrHbdUhyyHSUofNGU3vnu7du7tlEpCodgqJhshHybWel/TG8ZRPFPbo862lzCyhxcH05Y/nHchG1RVMHDfr7uJH9eiwxscMnfhplS6HwaB+oraCipWpoQV0wgbubimBqcUleoJDKelpVcIXjtXqar1x1SXXuk+cJTfhB6ejEB6Ss2UWbObZq7j+HyVFm0sO7uQQEvw7ynnZWFwgjo1TuAMUOuevfKT8vbiA3Yd7AH/YhyjIVpGODOg6MOM0h7ve36RmbfyGTJBMo7H+jz5TbdnVq+f8TBE54HpY2jvL6tztMbSzMo9qdZUUWIhcTDmv7jike+pEbepsPpExqzIRnImyNXdjz7BQnFJq2pobbXOIfoicIssv4VlZy5DXeUJ87U2p0ezEnEFnGqsEQmRpTLDzeSSJQIbExNunrlp0wV179HfGvp2fD17uDwmcsECDfw7q4syRRocjvFEqa2eawaOSH+K3OBdifj3Hgz22HkbHvMdWIZeiX9UM2+Ofq9FZAxDDMUNr9SsrZk5A2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 12:08=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sun, Jul 19, 2026 at 4:24=E2=80=AFPM Yury Norov <ynorov@nvidia.com> wr=
ote:
> >
> > ID pool is a user of bitmaps, not a part of it. If we move every
> > random user to the bitmap directory, that would be an immediate
> > maintenance burden on you, Burak and me. Not sure I'm a fan of
> > this idea.
>
> Splitting things into more independent modules is usually fine, yeah.

> I don't see why we would need a `lib/`, though.

My read of Yury's comment is that this proposes to organize Rust files
using C include file conventions.

@Yury, the Rust compiler expects files and directories to follow the
module structure. Module structure governs how stuff is accessed in
source (kind of like c++ namespaces, but done right), crates act as
top-level modules. If you create a lib directory, you would have to
have a lib module. Everyone would have to mention lib when importing
types and functions from there, which seems redundant.

My thoughts:
- there seems to be precedent for nesting modules under kernel.

- agree that ID pool is a user (depends on) bitmap, but it is not a
random user. We do not want every user of bitmap to go into the bitmap
module, but apparently there is more than use-case for the
abstraction.

- even if ID pool depends on bitmap, nothing prevents us from putting
it into bitmap module as a nested module. Everything is part of the
kernel crate and built together anyways.

- The idea of this series is to make clear that using ID pool is a
commitment to bitmap. This addresses the recurring discussion "why
isn't this IDR/IDA/xarray/maple tree etc".

> Hmm... If what we want is to avoid having `id_pool` as part of
> `bitmap`, then can we add the documentation paragraph added here
> instead?

Added where? You mean not moving it under bitmap but just adding
documentation to IdPool in its current place?

I don't have a strong opinion on module structure. I just think it is
easy to miss documentation, and it could convey that this ID pool is
intentionally strongly coupled with bitmap.

Cheers,
Burak

