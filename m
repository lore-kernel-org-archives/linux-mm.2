Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD3DC531F4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 00:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001F76B0005; Thu, 19 Feb 2026 19:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05906B0089; Thu, 19 Feb 2026 19:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28966B008C; Thu, 19 Feb 2026 19:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D01346B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:00:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 815281CC44
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:00:24 +0000 (UTC)
X-FDA: 84462877968.14.EB3F000
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 683A840002
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:00:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=EuNLwNes;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf17.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771545622; a=rsa-sha256;
	cv=pass;
	b=dXaQVmRKD5a49JIk3pfA/QKZXeIErUE6u+IHtz7j4g86yGJk12PZIY9HVG7vwKEUdCUh+H
	urrcoVtmYUoQ3seKWqLs6Z9Z6JMRP55iO/TRRniOlN0EwDJVUx8eT1Q9XblZ3KXyi68kS3
	yWFDYxh2BUBUjGBghE34wJlcx9sILtY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=EuNLwNes;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf17.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771545622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o36/diJ36lG8KI3DZxLKNWURpWjbyhgAwYq0XhyOvXQ=;
	b=2Cr9R269b5vwUBfFd7Is/wYoRinxrEsV3HPNznv6FqEoK/X2QDb/yaiGWBt+6l73rfVy9G
	I2TtokeMOUQ73xI1IUsxnKv6yqsYM89VoF5nUmWw8/etwI/3q8966FiryvS1MEZVZZeCNb
	rvf777voUQs7JcyvO777R1WKMMBZGvQ=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-352dda4a34eso630481a91.1
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:00:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771545621; cv=none;
        d=google.com; s=arc-20240605;
        b=UiNkUqkfCwzL4nIRgdK/5wvUhXNftUnRWDRnvAQujBRRA2E/1sYx1JjHhpb0aiRDPU
         nd/thkOP79mO8MW2SE08iwGz9WDZt/cu9WugbK9VxULYe5QEMP3RmEC2BwueMpgcBkSn
         Jvnh21AH9fw6kqMVjEjFwEe4ptwBfK40UmUnq1s/7Sm2okSlMpyItmnerOYTUOzYpBPL
         u5wDbMkaprklK63uXXXn1/XyJ9w2EeUuh8qYMcG/qfzpwmyDMtS22MBLoEKM9eYmz59W
         iOj+D/+psxEHfbrsSa91iXghbZU4cnIyduyBrhKr075biYPG4BNh4cvXC3gARsqozlCz
         sZZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o36/diJ36lG8KI3DZxLKNWURpWjbyhgAwYq0XhyOvXQ=;
        fh=RLHdB8iMYOJg0WzI+mto0GJhZt0g0QaDYiBzll1lxh8=;
        b=bs5sJflQ/TcIc985/eSdXPpVZfORUJjnMavtEbtEcCY4AXVMnpSAnRy+DMTqIBzzla
         funzWMT489pyizixhE3l322TCAntxNN2nJvxqk5fXOEuUmP0sU5RnWzmLaqm48PVtOXd
         grUmICjeUCQ5c7YXc9wi8qMW7hdohkRpHh6iO+i5F4dW40gI4hq22IIW5muU+BD5K4RE
         Dt0f8Pu7hWaIe3qoOp0YVKtxb7o9HN7PNTDE5gr7LkXKxSneBh+uCdilmUMlZ8g/rqqM
         x4zxD7/uwqZ74y4CyGVo1rwsCB/dx7nGgWiWz+FS3w6ZmwFsNRxw/Rx7O0OSYCO7jIj+
         ah5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1771545621; x=1772150421; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o36/diJ36lG8KI3DZxLKNWURpWjbyhgAwYq0XhyOvXQ=;
        b=EuNLwNeseITL2Z/B0bTYmx5cmTzH4JENmXam+KQL1BflyDcm41mqG2JCwJkuw/z+Y8
         toEcddqKpDAi01/0VYvwqX+SVz+DDEfuoIkBZ4a0LeV/RO438y/nj9YoWMcSPWMTjXM0
         jIfM1tiV+RE+7dz1ZeJZFgdsEwSXCjkIsupdJaFsU6eKoiXgGnWFYp3euG2KWPl2Wwng
         OrPz2qnLusA8ni0+z53jrqbBB/SNz2+trkyHs/rb/qNxo8N8AnaMAntu7KSlY0goqFP1
         JkP80mbnl6gHOKWwWmIOUyksnuiSxeVIFsgUtanpzOd6Rai+bheA5UWCQzKlI+n7URjz
         awJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771545621; x=1772150421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o36/diJ36lG8KI3DZxLKNWURpWjbyhgAwYq0XhyOvXQ=;
        b=t8WKCKU0kfcg+YJ8tOutqEgS0/PcdFnotwFtLoxLOuObFLByqTUQaNylsB2YZfbRMY
         eLMMW2FwgEmN8ItV09wsF36H7+ItRpY4ggWG7q1YdMsOWsUNdftRYNoPdDjZNCsW1l/S
         Rj0gbIynT7F6XSXeoeOUHWEY6wHY/r1vIHpTEcUgseMy6oEXbzyxTiNn81UTBVLai4FS
         O1QFC4baZ+4xR4XY4CDQDO7mBQza+eKfofFyurXxjgnrhvOY+iTBaEzncNXDwlS3mpSt
         McNxPRTQOYyqvU7pfcAOnbdPf/OQMccXSt5GIb99oU1raqXTqDvmzJGx8AP/grEWnpSc
         8g9w==
X-Forwarded-Encrypted: i=1; AJvYcCX/NN+uOOQ9QdFbad2kvVZ4ARCGP3vECYF2mjcNiM1+Kec0i1XUKUCApUUQ/k5L3LTvKtoDdGhejg==@kvack.org
X-Gm-Message-State: AOJu0Yx85EDyNiznRbTjtL+7dnJ/4X0U0kzADZ+KJSM1mDz4IaQNk4m4
	AyiygvkIRY8GEjTn/hcrwR+Dlrl3eHm6i4DGYmpIXvH1+rrbZOBnnZCzzr+ZOxH4UE907KXx9Ck
	FWSfKoYEHF+zHlSKx69XJD8u2bGJueuYCUc2W5+pY
X-Gm-Gg: AZuq6aL6jYxc1W085cKC9/ovG79tSJJVF/YWkNp2EXMbfVcHr3AL1FKWCdOrlmiBCek
	ym3JlAHa+fUlUjtpvi9Ez+0FTZPpD53KpLskyoeqyj4g1Y43bK0dWhWehgA8iCfCqohmARPhyvl
	lWowmaOFaI9fiJOwdmQgTsUmvpPHq5ixiOkgYHCrftLLlNpLIsYeoNdg+W7mcoEE6mAy8JnO2Vw
	MZ25Buo5nqjDL9eoNPbTLTfbPYmg+pd/enCOFn209UDiUgTITTLrFVg+zvNa90irBCKM91YeTZk
	y4pLxBU=
X-Received: by 2002:a17:90a:d890:b0:340:be44:dd11 with SMTP id
 98e67ed59e1d1-3588916c4d3mr5800139a91.27.1771545616313; Thu, 19 Feb 2026
 16:00:16 -0800 (PST)
MIME-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com> <20260205-binder-tristate-v1-2-dfc947c35d35@google.com>
In-Reply-To: <20260205-binder-tristate-v1-2-dfc947c35d35@google.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 19 Feb 2026 19:00:05 -0500
X-Gm-Features: AaiRm506Y2kfbsAw5yuSy39Cc7BbQ8GnxyExl_UwkT36VTmOrXmenuVrilx1Qck
Message-ID: <CAHC9VhQP3jz-RbdZczp=FVHphu55ddojEmjkh+U5m02AdPiDJw@mail.gmail.com>
Subject: Re: [PATCH 2/5] security: export binder symbols
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 683A840002
X-Stat-Signature: yn7rw1offbw494iauj44dwayyq7sc8ug
X-HE-Tag: 1771545622-979855
X-HE-Meta: U2FsdGVkX1/Ou5NZk5w4cL/bsxV0NGrVXtcVH7p+pOhIfzY/AMUH27ZkZhlru/gw414f2sZG6iytt7YPWNKczr6lX1EnM+eyJbxttGKIgunaStfyrVWY5JuHborEfehJMq5fsOk4q1u/9hszuUeHkCPtjGO5PhDFQLbQ6rZgCyuHx24S3/D91ASW8BquCCLakm4whr5tG2AmCaDv/8B9GbeWaO+hDff8UcY/RxbNkrHKAeodz3P+Ev09cATvuh3ASaHKuWDaWoQREywJtFEPziheDH2SGvSTYwLiwbeBmzQhHfLBA5LF/tkt1kv+niRFhOl/jr/mTc0s3YGr0vT4l5lOW/EFIOcHRVKeDcmtiwnJA3H/k/d6SvVemnOOrl7yhHiYmv9wcmMXSVINcUe3LP3umPtyHKk2TQt892PCRzzwM99KWhlvdYorjjEUUXhtMiZ8qPLm3/sAqoPJ64aQxp+6/v/IoTmCVe7UAeMWIUFln5MAsT8noI1LdVfL9rXbtml7GgL/oS2ZWRkpTw+0It+W424s1BCXK5Ov2vMtwPIRt3S8YV9eDSkUCQAQrIr1KfWvTlEEYEvKw2YeVlhP0xc8dWf/IhEO0fDDK+r0fmeea9FmnvRXsMX+xB9sgtXfxGso3xNbuvxV3M95773Hh2WtxayMddwsBK4QnJKfqEr+a+cudYUxF7xXPcxR0QUo/lVBdHN2rDVHDPo7vMfAnylywbuyCYz3cWGqlVfIOE38jnL/09prKqHY0Vu90cwUAEReJuOL32Tkkza5r9PiqFXJVH1tdpqksNzcws+TR5zubjenFKkJ8mGtj5JH729IQBgjG9MhbN6qSFFW93dF0XiLdya7R49z4eMBEVkoy6E2w00cVSYhQCQCIYG+XuN7jZbc+Uy0rZxARmTls4pib4aQqLhpNcHuwVvW9IFrr99oMXrJaR4AAR540cqDUzWch9e6UcoJD9YgTB4nCeo
 1moRGuji
 RBskl43SS8e/y2QRXG67ahNMlCSA9Vy/Vk0hG+/QfRyW4I4PNmJ525nvKC3BQPxXNsC2GfIbK+G3t2mk33nuTuYxHl7AiBhZV+/55JAta6DrT/3xM1i/crb3LUgJGAPAuRq8RQTmJGHXklVTFxjksi6Monj37vibroJ9zkXX8SgQcT308jkylSi1IkjCkdIZbKp1nWaUWoIC5orzCKQZaD4EKWg5TA7Vziuxs/x4qCZkutN40JwNJAGxU3UsqubpP3gP806Sg3wdDeYmLYaiyzxTf7qZ6jk4rcE+2a7/hjIEv5R5dzNVOhpeBvb+MSSQ0R2kf+CQRYBavbJJMSwFTsPpZzLzmHrKMwUIDsWAIXyE0BRSepd6tUaoD4c5Ztj4Pe31hteeS4laxOYWporSgPR2L8XMD7bXYjKE9XWMXou8DNlU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 5:51=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> To enable building Binder as a module, export these symbols.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  security/security.c | 4 ++++
>  1 file changed, 4 insertions(+)

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

