Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDAFCD1118E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 19:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F01426B00A8; Wed, 26 Nov 2025 14:23:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED89A6B00AB; Wed, 26 Nov 2025 14:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15056B00AC; Wed, 26 Nov 2025 14:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D05C26B00A8
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:23:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91A4A5048C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:23:00 +0000 (UTC)
X-FDA: 84153730920.06.87A1DCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF0D620008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:22:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OI1GzbFB;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764184978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojTnbMmA3145/e/BBUO00JuCmwmbZh7RXXLZuO7EB/U=;
	b=8ZGAYSFyYxpaVAR9806ixisykcFntIslNPgW2hP4bQ/JlK/8nxXD17htJAYLQZxfhVj2nQ
	Gimiy+q9p8ywkzj4FbAMYDw6M5qcvuymSBZu57T+Uzrl4dZ+WukS3ed7N2Sq7/x3bcL86N
	8ToMN+daQaEEeBMPV1mxtW0EXVQqVOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764184978; a=rsa-sha256;
	cv=none;
	b=6w9shyGQQjGlwjKN1Ggufwwd+wC5stebthyaYW7NJwXhtlP2E2dW5ZFQXGcC/TuYW8p6JB
	EXZMcAfhZxYpvJXXbDieFdSJIRPru+vHWdW8pzB6ddcXrsVSNhzw8JVCYuIOn+lotIiGCb
	oh07b8x6gmNSkhbQsl+fcufSVggBuTY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OI1GzbFB;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C75B86020D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1A4C116C6
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764184977;
	bh=ojTnbMmA3145/e/BBUO00JuCmwmbZh7RXXLZuO7EB/U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OI1GzbFBFxAZamdDKpmvHLEOkyyz8LUG+cvokjsp9pX4Hloxo+CZPdASauIS9czlt
	 5PzmRBigeGtoIMgfdEmzX9e/HkAn+SB2U+QUaP4czpHNmDjAB6cHpVzcCYLSFnaOPF
	 6zZ/nwrKdZ/NblQW+4G2UKMw+F3uu4dKCfakay59HgQXDggz2xZncuzbznjLl429pK
	 TQQq3wg31pZxgtCYmO3Qmb2bG1ewK6vKM2U2HXCG2X3ZSgh7UXRriYAzLxANc7WyJd
	 mkZ10NZ8HRLw38Wx+29WYNiD4rSoWGI3SnHTOM9lSQY6jfqy1pf2fx24QGgXMEjJ6U
	 hCAxjD7mTA1Mg==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7866aca9ff4so1250377b3.3
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:22:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUfrfVK+vRLi+TdOWwvvGIY39uf6n55RdnykAwF3/zpXDsj2LaCLxwDGZxCc2ezki3V2R+yANCNPg==@kvack.org
X-Gm-Message-State: AOJu0YyLeJK6w2h6GvdTjiaUtVAkD4zjv2QqxDvg/JkeC09tyuipsF3R
	WiCSKQB02SlrK0BuAvabx8uF/mlCV1pex6Ze2ybjYATWMmeObWIHh/w60r9y1xpTMnMSiEktjA9
	dK8sqCF2L5FgtJPv++bMlmObiEW0+nWd2LpMG0auaUw==
X-Google-Smtp-Source: AGHT+IHvFUYRzH4eL7G6mao29j/0EQXo718AgFCCdogCU0gdwWP9Lvq4kw+n7b9bDJWWh7IbuyMw1Yo1Yj5Fvum0+Eg=
X-Received: by 2002:a05:690c:3505:b0:788:bd8:673 with SMTP id
 00721157ae682-78a8b539434mr186983547b3.44.1764184976742; Wed, 26 Nov 2025
 11:22:56 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
 <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org>
In-Reply-To: <20251125213126.GB135004@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 26 Nov 2025 23:22:45 +0400
X-Gmail-Original-Message-ID: <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
X-Gm-Features: AWmQ_bmf28KerIy3cleTNQdEF6pSW-3PHcOlAyEmcrSwatTscR16b_hXvjsSrhk
Message-ID: <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AF0D620008
X-Stat-Signature: yr3ench8x3wr5pdn39pwyh7xcmtizaqe
X-HE-Tag: 1764184978-547820
X-HE-Meta: U2FsdGVkX18aMV1OeGAJvbfzVrJnC5DKQBRpxfzgBdQVNjvQcsJflV1lA4ZJGed0ZdFHOd+04rzFibmLlXcJKwbCLkRhkK3BLrExSsBoaykTUCLxGGvZYLe0Emc+rrRy2VvkRCY9nCyr5TbIzYXjSdQuEdzx2p7Qc6p1DaGqloWDO0AEWT+JZt8FqcBf3ztYTSsVIPLp2r/1Eamy8W7s3gmiUfMjpJeTr5WkGaccvtuCcY2NmtVGiqgPtRONKbLlX6CdkGsuanfHl9KXhnB0/5G7XgqEJ7h49WByhV4UpqKZTMd0AQetOB9mXv5+qbQL6MNLZJ/n5Ccj25bjOoAs4Z5Wa+omv2rE5P3bPgIAupZ2dBoz12VjmBZMYbxIRr3jNy3MZwIcZPm+p1XMdzNxVVdcNIQseOCTQxN/zSWNzPIqepuWt3viV/MA/pPJZhYC0RNQJgMsZNunKlH7x02PbaRalIbCjVMVz5M+HOl3qohGpaFNjt4siTS4x1cDsm/ZhMIIkJUwnbQDJlXJiiDfvqbW27L1VLLDmfw/4RFVzQqeFchSmqBjrriXo92hJh8noKTvfP1CRazfwNw+99iRhjR9Bs6W8AThTirt7tnNL22sB/w6B/xPPSJ6GJm0STYaPFhRohzsgErIkIA5/fEQ7RGsSDAoq2TNPAnHtagxD2a/PlnHM0MUj3kCgy+rpFqKA0XzizWheGWXnI51haOiL1bc/p3sruBcFdJM9HvCPoIzZ1/ZP5/Hzh/we26LnIklTKi2WjjQAvf/KpcpB5eY87TB5AIMiRpCy/gzMVXtVTLf1ZGtKF7qvD2jU3fFvpJq3FcT/4jY5/ePNq223RJySjuYCR8RTJtP1GHmhgAvuIzM9brfNdrGp+lbb8jS4FS4fl0LjdpXyF5EYNnUuB9eGDnVQWeBJhEhynT5oNkLcqm1m0OAWVIyPrH5aULcm3eE0ZpwJi9TlURbDBFfRHq
 /VjMdHwO
 AAKfqF/IyXXOLW8kIGA6LvmH6j1gpK/KC1ENGrFEfyEmBNVKHdnwzS3aaLh5dNZ72hGuEQbK1Rqoc0262hSMEeNjpnOHJ9ddn4WV8B5SSc/gRuHWOWU19E1WjIR7sEGoEcvwdr7JhDv40TBOxfvDTRHuh9rn1f1kcY6Q08rIaz0Bu8PIwHRYMIJV6bKYCMJVkUhbEDrg80QtPHrWhrADyPC6g+VaFhTXeewKqUJ2OyIYLQ1i58xFAoZ6eTsjvnS8C3mxsTeICDlo/zULSdZNF/w5j1St9e96YqP510/cQYTtASQmdbQtb1Ci1m4pe5sUwB1vinlxs23Xn8IFH+dFAHd84+3F2GTcViRYlYE4H8mqrp19k1uenmkR6/ulietSUe7XrUaTs/8oMd9s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 1:31=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Tue, Nov 25, 2025 at 11:27:04PM +0400, Chris Li wrote:
> > On Mon, Nov 24, 2025 at 11:33=E2=80=AFPM Johannes Weiner <hannes@cmpxch=
g.org> wrote:
> > > > > Do you have a link to that proposal?
> > > >
> > > > My 2024 LSF swap pony talk already has a mechanism to redirect page
> > > > cache swap entries to different physical locations.
> > > > That can also work for redirecting swap entries in different swapfi=
les.
> > > >
> > > > https://lore.kernel.org/linux-mm/CANeU7QnPsTouKxdK2QO8Opho6dh1qMGTo=
x2e5kFOV8jKoEJwig@mail.gmail.com/
> > >
> > > I looked through your slides and the LWN article, but it's very hard
> > > for me to find answers to my questions in there.
> >
> > Naturally, the slide is only intended to cover what is in the current
> > swap table may be phase VII.
> > But it does have the physical location pointer consideration.
> >
> > > In your proposal, let's say you have a swp_entry_t in the page
> > > table. What does it describe, and what are the data structures to get
> > > from this key to user data in the following scenarios:
> >
> > Please keep in mind that I don't have every detail design laid out. I
> > follow the first principles that redirect a swap entry page should
> > only take an additional 4 byte per swap entry. VS blow up the swap
> > entry size by something like 24 bytes?
>
> Nhat can lay this out in more detail, but there isn't much new stuff

Please make sure Nhat do. It shouldn't be complicated question.

> in the virtual swap descriptor. It's mostly just a consolidation of
> state we currently track elsewhere - swap count, swapcache pointer,
> cgroup ownership etc.

All those will fold into swap table values at later phases. So in this
regard, swap table is not satisfying the status quotes, it is more
aggressive in conserving memory. If I recall correctly, VS uses atomic
for the counters? It will blow up the 1 byte counter to 4 bytes.

> The actual indirection is just a word for the backend type,offset.

Sure.

>
> That indirection is the tradeoff for swapped pages. In turn you're
> getting back all that other stuff for swap slots that *aren't*
> currently used. This is a win for the vast majority of users.

Swap table does those as well, in the later phases.

>
> Since you mentioned first principles - the dynamically sized swap
> space is also much more suitable for compressed pools, which are the
> dominant form of swap setups nowadays. Again a win for the majority.

Sure, the swap table does that, especially after the swap cgroup and
swap count fold into the swap table.

> And the worst-case is reasonable. I don't see the giant gulf you seem
> to see there. I don't know where it's supposed to be coming from.

Let Nhat conform the per swap entry overhead and let's compare it with
the swap table fully final form.
Another easy way is just run some benchmark to see how much overhead
the VS introduces.

That being said, I think I have answered enough technical questions of
my approach, to let you re-consider my proposal. You should be able to
realize by now my approach is more optimal compared to VS. Do you
agree or not? We are just arguing how big the gap that is.

Chris

