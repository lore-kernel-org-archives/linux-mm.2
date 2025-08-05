Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F148C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 01:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7226B00A1; Mon,  4 Aug 2025 21:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF4F6B00A2; Mon,  4 Aug 2025 21:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D51C6B00A3; Mon,  4 Aug 2025 21:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8A86B00A1
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 21:25:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11F781A0A8B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:25:07 +0000 (UTC)
X-FDA: 83740960254.05.75242B0
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5B93280002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:25:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZVTldOA0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of jyescas@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754357105; a=rsa-sha256;
	cv=none;
	b=3g4a4SV4gWaMm4s7RSwgVkXQk9tXwyMpw57Xke4umU0P5ilm0Cp5qszUWgUYnTHxAV1pLM
	/0Viz98jmAvRE1UcsLrbsVFJIcFdEqaLUL8DSgQjJhOYywZNvgwPaqE+T5Lj1Ts0lzI2Wz
	wxWch0vbj1pRm1smsmdTXmFhp21wWAY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZVTldOA0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of jyescas@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754357105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOxJd4NbFHO3LlR4MpOBylEfyAcyuSwlZhpBODqzhsU=;
	b=K5/+9ce0aoe6RwJeDhs9U34d4JQNTSgAGvBLGDYW8GiRNSkIyVXJ5spiuPjU6eu20PwVjl
	NW4T31zp6OrO98sc0BK0E9I0Eu5Bpbe2YQ0FtXep8zGDVtvudaBVXpf2P6a+OUe0eY/HIv
	PY3rWsKxBKUWaqyJndCgt2DGA1ZQoOY=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-24070dd87e4so77065ad.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 18:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754357104; x=1754961904; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOxJd4NbFHO3LlR4MpOBylEfyAcyuSwlZhpBODqzhsU=;
        b=ZVTldOA0nHW9DYf68fRs9TODLUlCzSxRUd9Amz0P08bWq0zJ1peES1+Wu6Vw33S2ln
         NssUSjhAGcaR2KOAAC6ThWy2EjbBFtQjvudyDPhgZFIYLyMvfSm6s9VUiLNzMJYYrlfp
         W5MkaEDz9qNg0pIEEMU57imvL1sEzaqhcxUTajnaqtsyjsm8kn+gdQRmLq1FiFbfPneY
         Qt05yTfI7cllggiP2zdECG0JVooqBw8NyLilLLHS7BaHa1E/+yg/xUKQKa88D6ei2pPq
         qtyQZMDah6krM+QNWOOkPWb3s0Gb2OBYIeAxcWCVoGL2E8aGDm+6D0Zk+0WUJrwtKheb
         WJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754357104; x=1754961904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WOxJd4NbFHO3LlR4MpOBylEfyAcyuSwlZhpBODqzhsU=;
        b=Gn9PpYo5bWEy+Ypxfj/iqCtooet27qJuTNXqMBbvMclpQsFjpQh+lMS/o77X2j4GT+
         rfsXPGkq1DXcNnCjU6RiNGUNBW8SPgr0VL6eDpsk1GLr18h1jZCy/k/5HyfRNOMp814d
         carxkN9dxgJBQ5PcOoQfbwpF1JE6JFpkMOP8yzp4bTZNCcYHyoomknPx208RaQ+DiN7L
         Zzh6KaDA0Bnfafxl/xyZshwCef3eRwwuHCiU62zuwdwSpBI5IPpBeiGKMdlrMgU4fdDa
         MrnPMM9/52GIDZKPrnJTsKqW0wFP/M2xbF5r8W2GUrsqIz5kA6ZFUnxfekhFpveujd79
         0oKA==
X-Forwarded-Encrypted: i=1; AJvYcCXhixWlb5tStGirN0O+K/k3YLxZnMJNJJ4A7ZEq0xRDryaQegqLz3oeOtlRzKJHzts5GeGc7lf/2Q==@kvack.org
X-Gm-Message-State: AOJu0YzP7XksxVeyQ6vgUQ5ZKOrZRJFdLNmPj14cFp2WOs+Q2GfpkExw
	3F1erY4kcuwnhUbpBF/BDzBlcmbrkgGaXpSS/l4VaXeqWSrdUoWF0ysMz2jkGWMiMtGtq6MM6KC
	7iJ4N397i+DTBswIwi4n6sAAM/LZxVGQIJBpYvmEn
X-Gm-Gg: ASbGncsenvfFoi/ezd2YzKlo8itmzWIr3G8ED4DCigzMHNKZLiJx/Olt/2XbpIcvX3u
	m2zzvzLjxFufB7K+EDJJ92J+47Bzo0/rPApCU0B6R9WrG+Paeq9w61pPYvavP5jCMrILNw7niOU
	GlHpG0vJAA4zyfDgfpMYZ4MSBd20cD2GhstCwwGOIujhcWPx7hmgcxwI3MwUUKFeydue8+ssr6R
	nHpol7Lt6yus9MWI0N6ysrZWN5cRVbaNyjwW2iS
X-Google-Smtp-Source: AGHT+IGlJmNfwi/BL4sdNg3IcRsYuofmOwv7pzZKDekvC/MlCzimr5ljrnxQNNuBlGzWZKaEvJBcyRJkdCx796VG3hA=
X-Received: by 2002:a17:903:3bc3:b0:240:22af:91c1 with SMTP id
 d9443c01a7336-2428eaf97ddmr262835ad.22.1754357103774; Mon, 04 Aug 2025
 18:25:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com> <8A3D2D44-DCE9-48FC-A684-C43006B3912F@nvidia.com>
In-Reply-To: <8A3D2D44-DCE9-48FC-A684-C43006B3912F@nvidia.com>
From: Juan Yescas <jyescas@google.com>
Date: Mon, 4 Aug 2025 18:24:51 -0700
X-Gm-Features: Ac12FXywo_FBvKfn816eFQhOWDa_XVeaC7qAl3HAB468md2l2Uuye3UZxdQHZ5c
Message-ID: <CAJDx_ri28-_SqPoYgm2DHEwkA8Y8PU9+YjbRZqMdGpy_k0DKuA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, akash.tyagi@mediatek.com, 
	Andrew Morton <akpm@linux-foundation.org>, angelogioacchino.delregno@collabora.com, 
	hannes@cmpxchg.org, Brendan Jackman <jackmanb@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, 
	Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, wsd_upstream@mediatek.com, 
	Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Isaac Manjarres <isaacmanjarres@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5B93280002
X-Stat-Signature: 7t8ktyn1g7xwfe87edxc5wtz3d51kpmc
X-HE-Tag: 1754357105-674820
X-HE-Meta: U2FsdGVkX186MwWhzKbU9NHLLF/NMrZiwL5BWJsXuwCJ1c0UNbvoqIrHB6y9L8+bfCLUzV+wAXP1NoFB6PHaawq+ypEykyLAhVQl29e+Z/0fPyIb7ZVzfNKvvv/IEC5bepjGibikEUbuWL8+xtxjdVj/RfzjWR4Z2xCu1Z/GDncJHg6F9CZSlf4PQO9T1ewFUL6acs4PZ3QX/u62pvI+tjtWY/hF2NyGVl0GJ8oc9XJL+37MJxnC9Gz+xnNiwr+liteGfo1yGtzzF8+MH2JXF4zLmI7zXboNzpXKLgS3rIRKrPcjsTl5EdcUCW69FEgsukEFut+Xa43AwNzzR7YIOWAL28fibn19IFt6C81MYxq8gEIlwDli52bJhMwRTn1j8mG+evnXpuU6AYQUi0Jy+WBuQhfJ+XsECC7dygPgCWCLHNT1SSpYrsApSDJ/BDgP91iH5L1MsMxVxdjnvF0mkJF3+nkTG/z5TK58BfmHwKoUoa4u7srH6ca4J5I+pI/NFemch5kheJV+GGq8eG+IbrLi2L/rE1RLhhBb2FS9ptqAYXpaZe/ea+1ZkFyzNaLHgzeij6qodliTgAbJ9cmFztSIhCcIoMtE5AHkXhapVOemdWWXS2KpksksqEcVGfDRNXgWelJnE9gbtKfT8uINubKBtKYqRHEKD7WCJGR8HZ5RLc9k2cRDPEzlu3fkuMVmd6uSAKcIfv0zULFOGBUPBft2Oq4Z6A5ZPc6LMPFGTeb555Cax0fqZVKcTyiO1Xogx91uGat7XOCOsTV9+r8y95bkseG4pFYY+7Gxi1lmCvA7vUP/m3H51DcxtO3yYyVVNe9KKEZnAXuxjyrtoN67ViJogHA10BtAqfrnVaQwmg0ShIM1Rh+DmUQAFrLFm0E1hx2qycxqGVregz3NQk7+wWoJOy4WC+9yL+hPihEMEKmXw/cpV/dU9fw82iIOWPu2GTZY1d3ktEhEeZCsHbW
 OZjFD83y
 4/5oVO3bUHPUF90rwxlq60jks7SBMxjXOVbHAcqsFHmh0+hEArrAUeQl7zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 12:00=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 4 Aug 2025, at 14:49, David Hildenbrand wrote:
>
> > On 04.08.25 20:20, Juan Yescas wrote:
> >> Hi David/Zi,
> >>
> >> Is there any reason why the MIGRATE_CMA pages are not in the PCP lists=
?
> >>
> >> There are many devices that need fast allocation of MIGRATE_CMA pages,
> >> and they have to get them from the buddy allocator, which is a bit
> >> slower in comparison to the PCP lists.
> >>
> >> We also have cases where the MIGRATE_CMA memory requirements are big.
> >> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 50=
0MiBs.
> >> These cases would benefit if we have THPs for CMAs.
> >>
> >> Could we add the support for MIGRATE_CMA pages on the PCP and THP list=
s?
> >
> > Remember how CMA memory is used:
> >
> > The owner allocates it through cma_alloc() and friends, where the CMA a=
llocator will try allocating *specific physical memory regions* using alloc=
_contig_range(). It doesn't just go ahead and pick a random CMA page from t=
he buddy (or PCP) lists. Doesn't work (just imagine having different CMA ar=
eas etc).
>
> Yeah, unless some code is relying on gfp_to_alloc_flags_cma() to get ALLO=
C_CMA
> to try to get CMA pages from buddy.
>
> >
> > Anybody else is free to use CMA pages for MOVABLE allocations. So we tr=
eat them as being MOVABLE on the PCP.
> >
> > Having a separate CMA PCP list doesn't solve or speedup anything, reall=
y.
>
> It can be slower when small CMA pages are on PCP lists and large CMA page=
s
> cannot be allocated, one needs to drain PCP lists. This assumes the code =
is
> trying to get CMA pages from buddy, which is not how CMA memory is design=
ed
> to be used like David mentioned above.
>

Thanks Zi for confirming!

> >
> > I still have no clue what this patch here tried to solve: it doesn't ma=
ke any sense.
>
>
> Best Regards,
> Yan, Zi

