Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EE7D1266C
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 19:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1967F6B0010; Tue,  2 Dec 2025 14:58:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16D996B0012; Tue,  2 Dec 2025 14:58:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA796B0024; Tue,  2 Dec 2025 14:58:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE7F16B0010
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:58:22 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B8B213221F
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:58:22 +0000 (UTC)
X-FDA: 84175592844.24.ABD8754
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 40551C0007
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:58:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mR5PH5xX;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764705500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5DkEw3bk3dbYkt15yiZ/SNI5M1pdPgDRmo8S45rWYg=;
	b=JbuSZSf8C5dxQknnMgDenOyUcNwJAq2xu6YuzTfF4ZqMX8T6K81jcfBHPbfqw+QJ2Kr4BI
	yWOoN1KHJbEEKI7HuvBqJFjQcWOLmbSul90P1Jn1qta6yqgCXIciDtUpOeg3tcYU7EadIk
	OzT4iojBKoA1Wz9RQbvb6zAnrcksH4M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764705500; a=rsa-sha256;
	cv=none;
	b=SMsipIUVAylQ5z0vKS60PHpbl9LQ58L6VGJsCWcGZfSwotnATSxHo2vT4zBtPze/5K0m1e
	do3AjswuCbE5dXyk+Hoi0fg13sEGTvGV0ZCsj8GCOcNzBhobGDGfS72P/Ra+Ar0bgX2w6Z
	vgljUKTtS9alIucUT710ycsCQy8+n9U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mR5PH5xX;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 147D4443FC
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9E7C2BCB0
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764705499;
	bh=lchuppkd6M0udzAoLvi4/rKJIcI5yYBbqsX4qQoPzEY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mR5PH5xXrxenC0CvnVlAQfHh+PxufG3CcOXXcmA1otYtmFXGayJ9dESIGuthVfOH2
	 GD8tl7EP0BgvK+EA/UQFf5wFGTcbc3LG5X7u+ikz6Xs3FSLTsXlkaWBizFaTIqXI7U
	 ZPI3inzEgp+5dIpmSoJIgQRD2uhZjNm72LJzrZwNVirmEcYjCF6A07Kza17LR0ukmE
	 FxO+PiL5LyeLZHUdbltDS6VdIhQA4t+9QQJGB0VpX3HxGkzmZklBjoKPBcXGjeMIVC
	 lkTPwFkgLhy0HpyL5/ZftlcE7gGzpGCP+PVXr+VBZIujzK+XzEIC91E7ft6GEyqsAZ
	 CqDDa4Vgpi4IQ==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-642fcb38f35so4585219d50.1
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 11:58:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV6RtHDT/kivCMPyG2lla2K9hb1/ZCvo9TfJUm+gBUNXvY/zjyjnePQCJ0znWMOlhUoUWnD09w0Ug==@kvack.org
X-Gm-Message-State: AOJu0YwoFCtRSssQdBFmPjcKpZq7PRTSmLNrMfzs7W5sBtwPM8s5nkJJ
	L1P9Wkfc88g60BfM5yP39o2DGAx+18PbLo9BbiK3eUoMvs1h1zY+tSmDCpX9kwqVIf/1qcndqd9
	eoj6duBbIqIsLMrFaqy2t3IXOTnxfqIdwajfFFZB/bw==
X-Google-Smtp-Source: AGHT+IFayZ9XlylMzc4ybsfjZD993cxxdiQlx+xp4z734pH+GQsxY3ZIGv1qiAoVWe23Mc8b3Sy4GB3axiH+slcKARA=
X-Received: by 2002:a53:acd8:0:20b0:63f:a89c:46f9 with SMTP id
 956f58d0204a3-64302ab7bdbmr25049979d50.40.1764705498072; Tue, 02 Dec 2025
 11:58:18 -0800 (PST)
MIME-Version: 1.0
References: <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org> <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
 <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
 <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
 <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com>
 <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com> <20251201164338.GA430226@cmpxchg.org>
In-Reply-To: <20251201164338.GA430226@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 2 Dec 2025 23:58:06 +0400
X-Gmail-Original-Message-ID: <CACePvbU1cO0S1jPP7D+62HyittSx9nAzw9wbg3LWGZ4NMCkTjg@mail.gmail.com>
X-Gm-Features: AWmQ_blugA6E25KymK9865644OS3kBAAQcBpBzPXN-o8pmzDNqkd43uPpP9BMtQ
Message-ID: <CACePvbU1cO0S1jPP7D+62HyittSx9nAzw9wbg3LWGZ4NMCkTjg@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40551C0007
X-Stat-Signature: 13qyeuesfgsf1r9ryhjy6ow3y88spp85
X-Rspam-User: 
X-HE-Tag: 1764705500-214154
X-HE-Meta: U2FsdGVkX1+B5ZWzbKtGzEpeAdTBw+HpHpaHnmaNFapMC7+asm3Jcn3mvvfK4K3a8BhdxiYXKqeeR2eRnDxvxvnUDxNkmHj7SqqoocgfUTHKTz5MtgMpR7TazIF9/fOQlRl9JRRKR0ARBMd1MPL7tdg8Ed+hXICpsq49tDsnPoj+zwdiwROp+arrJRT15/i4Y6TqXH8oy52y6Buv101P9MDf2X2+i2UYJKrqvTdK4yqlqPntSSwPJ/sxkwgsUnFWMPkGTS2LrbTjp67mP2uWXGXrKWl5tFQGD4jenTP7WwAjqpswLJ7M5S3ZGgR1IiROyBrCAGSxxHpMqvWp+wzLVHsjSok12u/rv0p9zCghHmgjYGgybtHJyUMAKVnZPeCQQjYkn/TQIz6GeLgREp1kr0RKh2dbG0V34dfyXPodf+KlZ+SsWsRFRuXfDJ81aAOyDsp5u+SBozgQrumfgQ1ghqUYQwnT9hSKumylPg099pSAz97Bezs4Pc7od0wr/kJZHK+8IS9IakSUtFgWY914t3WTn6sTHh00Juf3O9IhV9aZqUjejNtybwOniMaanY2qHpjLKrhaesvXZWkdMRmBzEg3/1TV8DeBBUUUxfO2lALusibqTrUBmO5ScfGY9zydfYmv9aUij+GCglxca/g0YHRDBIz/mMpJ4d3qi6qdtaGXyowPeuO+CO9EMk8V7PsopzA8fl0dZ1zXdbqD3bmPOGOp6pufFHMCiS6Gs+fyx3fZLu4nwTRXHvz1PQ1wss3/lD+ZMT3mlPFgdJ8V7CbWerA3UCOujEMeOpdASjsKbLsXurrdZQobZteS+NPs1uknJtVaGyedMcgv+1+/hrIwyEviFLiuKBbnZz91Z2HNfiSyFYASnzN92lRNAwFDtKHU0kWhFu+AL/yxzEv1B/oLgjpeSkjuAtXksE3gkLVyFY0pm8qpAMuKzC0nvshNnFyfUuaKjFggWKUsaXs56Ix
 wzG3K8wv
 v2Oqbd3pcTwPqyyRTHYpNUvkn+U1/QzmmTIWaxJYeffDthHsb+0StEpYY0otU3lWkS0JFH4PAY9s4XyYSdnRoGjKhQ49EFTAU6ozuoS5RfUxPvPlXet8AGRCYO0vpxkYzKS2eD3OJ/mV97cJsmZW1plF8hVZDlByzxg9zR3RW9t5qgLx/Lx0jkVQiaT4oSTyKJ7N8i2Av3nCoJ+HBabwJ6AwUSQOfU3Iio8TaVFma8k6JHzdRtE/su1dp7+0zO5nQ4H3Cnk7vSX2zicPCH4fCUrt08Knxnkc/8DwVxNycY/TL6nzmjpncvnoWA47M+ptiFk5baQWqVdOfAk4qa7I9+mqt8qPAHw0w40FG7fK3kpCRo9gTWDeJznF6JcfWsPF3HjbdY2kqYBFAB0x5FyhGhxqnUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 8:43=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
> For the benefit of anybody following this from the sidelines, the
> third zswap maintainer also expressed concerns about Chris's proposal
> upthread. He works for the same company as Chris.

Yes, I don't know who's interest Yosry's represent. We have a
disagreement on the swap abstraction 2023 that is why I have an
alternative proposal. The community back then strongly favored my
proposal. I guess Yosry just hasn't graduated from that yet.

>
> The reality is that Chris is failing to convince others of his design
> direction, and is now obviously resorting to manipulation and hominem
> attacks.

Now we can't even talk about technical and  move to personal attacks,
is that all you have left in you?

> During the course of this thread, Chris has asked for "a little faith"
> that his idea will work for all stated requirements, without deeming
> it necessary to explain how.

More FUD please.

> When probed on technical details, he stated that he doesn't like to
> plan that far ahead, and prefers having somebody else iron out the
> implementation details. He also referred to high-level slides from his
> LSFMM '24 session - which was received thusly[1]:
>
>   Matthew Wilcox agreed, warning Li that he was setting himself up for "a=
 world of pain".

Yes, we deal with that pain. Swap table is the outcome so we don't
further impose pain to maintain file cache vs swap cache where a lot
of swap specific optimization will be painful for the file cache side.
As far as I am concerned, the most painful part, swap table as the new
swap cache has already landed. We did not cause Matthew pain in the
process.

>   Jan Kara said that existing filesystem designs are not suited to this t=
ask
>
>   Hildenbrand said that this plan was introducing too much complexity
>

More personal attacks please.

> His first response to criticism was to invoke his <4 week status of
> swap maintainer.

I take that back and apologize for what I say and you accept it as "no
hard feelings".
Do you mean you don't mean what you say?

> Meanwhile, the design direction that Chris is construing as a single
> company conspiracy is anything but. The collaborative origins of these
> patches are well documented. Chris was CC'd on those RFCs. He notably

I feel the 48 bytes overhead is a joke, I already provide my feedback
against it in the 2023 LSF swap abstraction. I don't like to keep
beating the dead horse.

> did not engage in them. He is now lying about the narrative and
> choosing to attack these patches in bad faith and out of context.

More FUD and personal attack, is that all you can output now?

>
> This pattern of behavior gives me low confidence that Chris is able to
> collaborate and compromise on a design that works for all users.
>
> And while Chris has been quite vocal and opinionated in mailing list
> discussions, his actual code contributions to the kernel do not
> instill confidence that he can solve this problem by himself, either.
>
> [1] https://lwn.net/Articles/974587/

You obviously haven't graduated from the fact that most of the swap
core is my design now, in the current kernel. There will be more.
More personal attacks please, I am ignoring the attack in the order I
received. It seems that is what is left of you, personal attacks to
dominate a technical discussion when the technical is losing.

Sign, this is an example case study of upstream bullying and that is
why sometimes upstream submission is very unfriendly for the less
established person. I personally know people who were  bullied by you
and give up upstream contributions completely. Go ahead and try to add
me to the list. That will win you more followers. More people will
enjoy working with you.

I agree I am not a native English speaker. I will lose to you in a
bullying shout out flight, you win in.

Let's compete in code and benchmarks and see what happens.

Chris

