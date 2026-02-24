Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7475FE9B265
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 13:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C1C6B0088; Tue, 24 Feb 2026 08:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA386B0089; Tue, 24 Feb 2026 08:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805D16B008A; Tue, 24 Feb 2026 08:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 693246B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:53:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCD5AC02A5
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:53:37 +0000 (UTC)
X-FDA: 84479492874.15.E18EE53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA0F214000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:53:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f4V/mmed";
	spf=pass (imf09.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771941215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lo0YVxtwprKCO+MnaksFDjiprBOpofZ2Ot8QFS6XBR8=;
	b=wan6jcxHc1sPZUOHIUeWtG3NY+/6BxC1t2asqYgncmM2NFm52CGJ5nW0YQ1kq82HtkjvpU
	eBJtXOIllmu90o9KpNGiUZKelfpbnAAiodMt+Q/BgaHLqlP8m1EiNc6R7WvUrsecKndHjC
	s/txZt4/SDF+KN6LnzudpPR3o5q4mSk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f4V/mmed";
	spf=pass (imf09.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771941215; a=rsa-sha256;
	cv=none;
	b=Xtm6Ok4XLPWw7AvfOq/Ke+ib+2dJCp7h0B3ieXxqHrNYxbtuAndKgSB6yCXXAa+nKp4gyW
	mqwBBNCp/+G7Qjex1KUxZIZ6W+jc9XKXxz00uYSfBB7AW2w0009icmG8Ij+G758jGMP/hF
	eAoLVFyKWw5w0vN+3ez0g4cuQTkDXHs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 61D3461119
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1582FC2BC86
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771941215;
	bh=mnNXV620h0OKRr8Zj1ngtQ6TG6CiqwVdzW1hGrqlM1o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=f4V/mmed9e0YDLLfKFUI3gTfxXB+JpN3LMoEqFnAC7hyVjTHQrCGunNiHXub4D6ij
	 sqo6cmx5ENyWIptgpIEDkDumf6RZI6ZpznLpBppwlfWIsXF701XkUacB3hS5YBLjJH
	 uiGS0hn9qFDnBqZNfb12me35OHPWH2AuvWNKbx4bKPrwsx8yrDmt88Rke6ysw3cqrL
	 2TAoNGiSIQtknqHBm+plM8WaPMd3Y4+J33fLDFotZhb3iOVtYmTTevVYBf/GS5wfPg
	 ZJKkRT5vZZgaMF5xeH2t2VQa6T7nTa1l0sHOqZ36JilBgzEvXvw5Gj5NEbhcb7bj2t
	 eIC1YI88wpZNQ==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-64aedd812baso5084913d50.3
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:53:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVYjwKfXxHDgf2FGZ7T00nnfMRRijHRwA13D5PaNZ5FNLfIcHdscheP+pCJpPzEywEL062uQu85zg==@kvack.org
X-Gm-Message-State: AOJu0YxROHHSffDxknAeAZsbnhW2DwOrCFFYVKGztVYYt41n3C3mt0mI
	3Bk6KYdpCE5cg2H5AeoD17QhRsmT9KZkeszdUjm7kJr/NgeCRLUzTYOOqnvklmDAHSaJW8ueQAg
	BNuuvMnU1kje4ffqIdvW2wGoeU5E6eVY=
X-Received: by 2002:a05:690e:d5a:b0:64c:973e:874a with SMTP id
 956f58d0204a3-64c974dca95mr3429415d50.42.1771941214411; Tue, 24 Feb 2026
 05:53:34 -0800 (PST)
MIME-Version: 1.0
References: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org> <2553a75a-6dc8-4295-96b3-58367879751c@kernel.org>
In-Reply-To: <2553a75a-6dc8-4295-96b3-58367879751c@kernel.org>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 24 Feb 2026 14:53:23 +0100
X-Gmail-Original-Message-ID: <CAD++jLm6iyeFuGoC2zfHDOu6gYdb2L1gsjQhT5a4qS-CBWia9Q@mail.gmail.com>
X-Gm-Features: AaiRm53tb2rvqaot7mvXTxtm6mGGNPobUyruddK7Z4F9nhs9QdcbYdTorcT5uzM
Message-ID: <CAD++jLm6iyeFuGoC2zfHDOu6gYdb2L1gsjQhT5a4qS-CBWia9Q@mail.gmail.com>
Subject: Re: [PATCH] fork: zero vmap stack using clear_pages() instead of memset()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, Mateusz Guzik <mjguzik@gmail.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DA0F214000C
X-Stat-Signature: qqk5wdqeggy84i8wd3oed7zci7ysg54k
X-HE-Tag: 1771941215-841089
X-HE-Meta: U2FsdGVkX1/cO/N2Hz5+12D7sjU7O1g9Vf3qMEwXL4NaArqm0b+aqFQKRs0TWoMATHTWvuT0Q7fCskjWEz6p19P6rD1eUlQRbqWRICKWi/NpEoVGqHLzFqJELGJpVDA2pNULgOEu9AgYUaUBtQyDOrbHnKuqlP4uOghF8E3gsFgpMin56IZbyGg/XLPJ1T4xjZJjr/cjn0zxoN6mf9+b8Ay6Ml4+xya8zMGYJrnmkJinAeGSmu0vmlYRAr4d2mPRjfC68+T+MXIn1Gl2G9Ox61/SaASGZyW0MFJyly3t5RUXiqfIBZMS11Mtj0Lk2gByzEJkW4azyRPywEuHlUKPQbn83eu0IaBo+4ri8zO5a7xdrv0bDpW4HqJ/rZ9rGYr5r5SCkS8+LzhHBjLH9YZwK6OjYPGJDi66MdG0v+eJM8j6UXj7sZspBxJ2u51UezEr/pFMDjjg1yp90J7AAl2sM7ykf+DjpkE48KX+tRQPkBwAOngvNlM3qZywNp0gNSjHy+jP7KaskIC0lYVRl6LTK0QRiINsE8J2wANOFTnZLNriE5KJJry2gUoCPvBwSWes1xRIstjrgvTyISI9h2ykSBX4YnnjgLC05MF4ELH/EepD4pMJc50l5M2u0P1ju0cB4BPK6tRCSieu7BI8ZS7rM7F87jLmFg016RZ0ySAgu88H9Ix7NyOP6rVM8h3oweL9qZqIsNCYY1cDOpSnhCj/H1ge5lOo2C7Yr6X2S2Y1J+K+WJO9vPLW+KV38Zz7/kIyzCTie4qp6g3/Mo7rMjTSAgVQ1CF6k9z/Gxehp4jfKJplkz59bEEqFLySKO/UaIXUeBRRWPMexAsoqFXuA8tCtZ04tBs5mLVlUxwHK0LTAV+mlqJsaY5H0jgpJhi4hJTt9I9vHjXj6S9/vw90skRVStJlah2FuQEUIQxCgBPBLatRXNF6mGVJ3c/VxerZC5xyf0+HOMQaVKYGnmntPm3
 VAF83/dN
 vM9EplNXBLAzSISPzUiiSChgFaLb9cSTrmg2uPaXYIeETD01jRTCzwe00sr+HTvwd7GbwvIZZ/1JfC/teSsqdKr1UW8ZGk28WBh5GbJuYfn7rQO9++RMgYKRNsY7gDl6qY4wHjp6aIP3IvxbN4osRtXFGktqu9fptlwAcwlD/13x8pw9cVO+Q8UuRQAB6gxomDpcfwSw+cOY9fSAeNMwE0ifwrYXQMZQ+FeGh62U1oi9R0l+7t4XhiQwSSBak10p+IPttPzMEuPa91fK7ML2+TK0vGLKVOi/v/EMBp/+4vctBy0lRk640016FW5PM9OhvQWBrk4gHLivWRIerVS7VV1LuUL6b7XNwzpi5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 2:21=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
> On 2/24/26 11:26, Linus Walleij wrote:

> > After the introduction of clear_pages() we exploit the
> > fact that the process vm_area is allocated in contiguous
> > pages to just clear them all in one swift operation.
>
> The pages are virtually contiguous (vmalloc IIUC), not necessarily
> physically contiguous. For clear_pages() that should work.

Yeah that's what I meant with contiguous, sorry.

> >               /* Clear stale pointers from reused stack. */
> > -             memset(stack, 0, THREAD_SIZE);
> > +             clear_pages(vm_area->addr, vm_area->nr_pages);
>
> LGTM.
>
> Do we have any idea about performance impact etc?

I have a pending patch for implementing clear_pages() for arm64,
https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-integrator.git=
/log/?h=3Db4/aarch64-clear-pages
which is in a performance test loop, once I get baseline data from that
I can test something fork-intensive (hackbench, I guess) with this patch on=
 top.

So making that patch made me remember this one code site...

If someone has a good fork performance test running on x86
and can give this a spin, it'd be great!

Yours,
Linus Walleij

