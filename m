Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF807E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 02:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E3A6B0088; Wed, 18 Feb 2026 21:48:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F926B0089; Wed, 18 Feb 2026 21:48:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E5A6B008A; Wed, 18 Feb 2026 21:48:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF166B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:48:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1199B7C79
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:48:06 +0000 (UTC)
X-FDA: 84459671772.01.138496F
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id AEF051C0008
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:48:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I5NgmTuQ;
	spf=pass (imf21.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771469284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/VlvWkL/Qm5JFLokW8hEVaN3WucDWSpLdweepHTiqc=;
	b=XkImuwkG0G5HyB3JMTWzHV6J034d2o1YuYzi159zAqWtxFpO8mp+qOZtBdCHUw1goQMLiU
	++ARyBhWHEN+FAH+8tw7TDZkZgRf82H33bTNJqEKg7onIAe8iS1F/Us968cr3U/KHOdiAn
	wrHSi4BDvDqxKNNyYEzKWxf0GN2rPvY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I5NgmTuQ;
	spf=pass (imf21.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771469284; a=rsa-sha256;
	cv=pass;
	b=kdzAvtJ04UTzbiRguWw7B40jkAf73fw4zej21+mbxTOR3pumajdEmJv/h+LBmAK2Cu5SGN
	21jty+oUDTSdTsyhlVU6NjdzBXYo6WXkl9gOFv9YT3j+9Gp53jza5/d4GXlVkvPEim8uu4
	Rvwl4TW/OwYtCebu1wk4tAgfMcbRWn4=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64a28af2f4cso705593d50.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:48:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771469284; cv=none;
        d=google.com; s=arc-20240605;
        b=aqnuApME+jxxNFoDxMuN4hBJqV1CEP301MicdrGLyONdj9ckHlcxCLB7sYFixpcfJl
         YXnqO5Da7jm2aNI9p5Achvr58ppOcL/wV89AV11AkTxIv8RJOBYkTZV1LF5wHJlHdpJf
         WcdtCo+ZTtdkQ9upc5h6HC/6ASpK+qOZC6IyiciB2SGKryT1pA5UnOVta1098tv1mYZU
         aiA49bRZyT2bt1yXzca7yVsAzY40DwAQ1+ffGkdzpP3STJ1/2LC8foC37d5ta3xUfGsa
         +r6PbpTkwSaYP6FxF01qi9RoYtq5XB67/bV1+djfd63/4fqqmxwL9i8lq+mhSTRuIsX0
         tdNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9/VlvWkL/Qm5JFLokW8hEVaN3WucDWSpLdweepHTiqc=;
        fh=vS0EfoPxFgfJtgEmQ/byZV2oJjHFJIOkC61M4BvpCec=;
        b=KWKTl51R4qsZUOo3koaMBHiErVuwqLpAcSy2J6EylsyCgeKSfHutA0D0jVGkP32BVj
         EjqALMGtlKk3InPqFCHaRvRtvTPWwcZMISlBkC5JQs/n71MvoVpmjgEknTEKpwRFRLd3
         kr337YNymnbmXFPpwL5xCDKnuuJLZEKz+y9/GdgIi0UBboeCsmkLFNW9MIDeTWqSauf6
         fcs1EPnHv18dIkrIQbd1AUXn87AECVoSmaC01lVVlv8LbeK9TWpXTzWRXKWo+belsetF
         u54MPO07R3xz1nFt4hDLJ4hv/wU3j7lnI1kywgcKH9mG9IspMSifTibn2OqY3ImzAYxF
         NgQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771469284; x=1772074084; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9/VlvWkL/Qm5JFLokW8hEVaN3WucDWSpLdweepHTiqc=;
        b=I5NgmTuQ9vYPxcIuD9ZktO9WrmhMABddRXvbJqHJJ9qofm/D9kWbEkYDoQWyLZsbXd
         2mw6X5Kg4+B7C2ahkB7KU4clX6y/JVkC+wgOxpC/y+XdEKIQr5792Z9yv/sN8zmxw//j
         dWCiCpy5cGH/H41Tz4AtlIDFJKejxf4Aojuvu/m6b9wDjQvlGtsfrUfvY9MCTydr5IIO
         vFqu6rJMKoJ3onk044Qj99JVIR8qU9Fd3bNXzw3/ExUkwfzcA6kHtFrhrKx5u0RWAgwI
         VPj3W1LIsZ2KH2TkouCGxjMDcvUeAWJ5REbWDSxMofvXZoRs5jILjWkFgzsTjwmEF90E
         tCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771469284; x=1772074084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9/VlvWkL/Qm5JFLokW8hEVaN3WucDWSpLdweepHTiqc=;
        b=j9OCA3VnnKU6tc3VUnfuWo+PxQZho6tX6Ej8kUxp4VoLh6xUhkeAi+7jUttH7QAl/X
         VqxhE8azxUF0B+uGeBf+VjsRObD0tLGzOkPdGg6w44Dd+x286u92U55yjgoMQYUWxA/A
         C90xgnqPwbffsmwWu2v4xtn6Lwdj5G27nLRokVD2GJOEW92f4au6z+sqpbABj654hUDm
         RdHiG2L/8sRGBJLsvbL2zmkKoc+oW9++zNiH2NxEWZraFA4ATSHI43o+HCebdA7uWt+u
         FMP1TENTQWAA4vtP2St2meX67kwvCdgqmS74TNRMdYeixl/R9UvxrD/+6ERkjoL+v0yA
         P4JQ==
X-Forwarded-Encrypted: i=1; AJvYcCXO8MXA+qTxBcA+kzTLM/bvIOtd1obpZnn2LnhxTxgq9g6wEst9IioVRHAj8uB1RE0NXInwwenYaQ==@kvack.org
X-Gm-Message-State: AOJu0YzY9n9+D5FaCA3lFjgvuTpHYxwUiIHmmqWbFUI9vIfI1E1bxmJh
	CR73JEVyBpIWxCW53CBYgS9Eww+ZrBTPas2EhcZJNSDodc5hcHlmgHl96wONwhtueNz5mOeDRuF
	eTcZUjAOw51ayJMAOv2mImVQSSG0XXPNwyu/f8CU=
X-Gm-Gg: AZuq6aK9rDR8B5mg6h9RjZvie7dpp5flZgsX1jhL5jBI1dflRJGTeDXWDnLqmOkENJt
	RDWAUTxncWFILGYS2VeJ3lbeSEDma+dFjqsF8A+hrc+j0smcn/3JI8CqrQb6bXHrYijdx5GTHOw
	zqyji3j0LiJB9CmOWnwB2/4Lzpx+TUmt5dkUl4uBYeSVsp+UFgXaY/ZXBZEDAKdrdoTYpDesJpq
	La2/lWHh1Zc3MnLkwk4s6arH3lnuZ0lEb8vJJ2tXJnqlP8es5JjKQ4b5jEHTqZEJnA7gOtZneVI
	9rylD5VP
X-Received: by 2002:a05:690e:13cf:b0:649:3875:9200 with SMTP id
 956f58d0204a3-64c6406779dmr225247d50.1.1771469283624; Wed, 18 Feb 2026
 18:48:03 -0800 (PST)
MIME-Version: 1.0
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <CAOptpSP1zx1akeGkZEuPBx1Fk8uz8rs4_m5c55GwPUROmCGxKg@mail.gmail.com> <aZVvoWZDyJFfBqBr@tiehlicka>
In-Reply-To: <aZVvoWZDyJFfBqBr@tiehlicka>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Thu, 19 Feb 2026 10:47:51 +0800
X-Gm-Features: AaiRm51nmgFFpfarTMFBGcY4bzTwSxjb4Ej8PVfolNRaXnSjx6JInqIUl6qHt20
Message-ID: <CAOptpSNPmOZGq5_a6AmtnBiSnf+2gL_H3JkGW8u=xwuharXnng@mail.gmail.com>
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous pages
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ijfjd3om45gteq9z3poitd9obsxuws6s
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: AEF051C0008
X-HE-Tag: 1771469284-613568
X-HE-Meta: U2FsdGVkX1/2DCqXzKL4mNTN6QZaYFzGj/TJ7M6PJ0Hzr4xUjK5wufL4XG+pRkm9JUu5yp8sD/0zVihIt1rv+Ve1awcA8GumL8HV3awyKhTjG+6CJwappfxaU3DH9Te/WQGSGXghSjgufdd5FbJxPHkASSF7gN+u2ed1YI4oz2f4G+RU6pYVNNT5b59BoBcauS57ZwzU0FNnNCzn+0E7odxvwjzvkErSmc4XDyI6Bm+ZVflGjDcGCeUzoYeFwM9EsGvsu2aCoDTnYzBX53d81W28ygmHTkLtysCxAR0hMS0u7l6TyzArh3Orft6ZCjGsJ2FyhPmRejEDkrJMpdBuLRts3NDx2rpIOxyrVI+VN7W3h6wZptRRvZ4yh5EH140EjtSQX5BI70PdrcsmF74gWW2Pb95hyWcmaZhQ37vCCwjgbXzP+19h0SjenR7VJBnH0/U+GUJH8Tx7viPglxvFocohbgYOnDRnIQP9Eyv/dzBewzUm6sZiy0s3ihfmK/29/LAZFJQM5OtE7tLyT2FxU0fHPJV0Ax8Dt4Apo9eZuO9Pxn1Nq26RqQ2pdW0Z/4r6WcxOkNdnkL6kWniw0HACwOOIokgbHCeaRg2FoCgjppSgSWwQvgfIqnLvBCaCmVmkl9L//OKvahzt28ib7deawqwbHWqZ5hRb0T1CE+6M2pCJs3msAic7cZbT6UABp9BWW+yuKSf3Nri0iORY1IimFvRhND0mt/7xMqn28SJqdDeirMl8JWNLoYxKagaogY/fQS54kToPX6kBeUh46MMngHUEKl+mlelOO7/7nlRaCGCo42QMX2Cle29ZYMW+J2RKICszz4tXaxOcwW2GqHbDzAHDGUvJsSO+A3mN6aV8xDgyNs1VijuY0dgPgjjp8fYsPMRitvLLlsrYqOy28kn3pYXU8yxfMaVUMHE6mEUQv47GdHr4rQfsVCBg6U0+9uRYby9nO+lqs6x38yczTrF
 cFl9zdOG
 X++cXmoMbnO4axLC4Si8WFYnzMBch7F6MDd355v8gdy4DfO9EN3TWkD0xCUGuqLSVGoRzGMPgSjCvQl8NuB8jW5yO0c6KZ/fUfK6cBRQA2OEuH/HpY9QXs5Br4nIgC+Bypu+FOOZcpfIj3q3j3LI5Pv/c3Idl9Gga53564g9D23t1c+3iSzge767YqvJt/+oxp7DOLPPzk2wYwF6Sd4K/jnMJayjTD56Sitsrzdg6Q1NDrPtvOPW3V9ttb2WigbDVkJa4G25oDyyQs/LWC9wF6aPAPz2DiVl+Mxqjd887qGCyklKlHASUf1q1x+BuqQHhysgcIfzXeSJWMJOEFdRRuDhg7eVxb15RKqBqcTng7gTp83KNqOS8fWTGRIPvsoDZ/xhqVKiw4U1Dsb7Q05E+dVBlraw8LypEDCiradJG6QfOuXdrKFXvBJ5h1rZ/IgBeVwhZKKq/nB7c8evKgXMI/XpziA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 3:52=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Tue 17-02-26 23:22:20, Wenchao Hao wrote:
> > On Sat, Feb 14, 2026 at 4:45=E2=80=AFPM Wenchao Hao <haowenchao22@gmail=
.com> wrote:
> > >
> > > Add kernel command line option "count_zero_page" to track anonymous p=
ages
> > > have been allocated and mapped to userspace but zero-filled.
> > >
> > > This feature is mainly used to debug large folio mechanism, which
> > > pre-allocates and map more pages than actually needed, leading to mem=
ory
> > > waste from unaccessed pages.
> > >
> > > Export the result in /proc/pid/smaps as "AnonZero" field.
> > >
> > > Link: https://lore.kernel.org/linux-mm/20260210043456.2137482-1-haowe=
nchao22@gmail.com/
> >
> > Sorry for the late reply. We are now on Chinese New Year holiday, so...
> >
> > The original goal of this patch is to measure memory waste from anonymo=
us
> > THPs - pages pre-allocated on fault but never accessed.
>
> I believe you wanted to say "but never modified". Unless you map THP
> through ptes you have simply do not have that information. Reading
> zeroes might be just what your workload needs (e.g. large sparce data
> structures).
>
Yes, my description is more focused on THP mapped via PTEs, such as 64K
huge pages. PMD-mapped THPs are rarely available on memory-constrained
devices like mobile phones because it's hard to get such continuous page.

The reason we need to scan for zero-filled pages is that the access bit
in PTEs cannot reflect the actual usage status of the PTEs.

This has been discussed earlier in the thread.
https://lore.kernel.org/linux-mm/20260210043456.2137482-1-haowenchao22@gmai=
l.com/

> > On memory-sensitive devices like mobile phones, this helps us make bett=
er
> > decisions about when and how to enable THP. I think this is useful for
> > guiding THP policies, even as a debugging feature.
> >
> > Let me summarize the discussion so far:
> > - Matthew Wilcox questioned the value and raised concerns fork but have=
n't
> >   exec path
> > - Michal Hocko criticized the inefficiency of scanning zero-filled page=
s.
>
> Let me clarify. I am not objecting the inefficiency. _If_ you need to
> recognize zero content then there are no ways around. I have merely
> mentioned that the overhead is not negligible for /proc/<pid>/smaps as
> you suggested.
>
> > - Kiryl Shutsemau prefers a system-call-based interface.
> > - David Hildenbrand acknowledged the value and suggested implementation
> >   improvements.
> > Please correct me if I missed or misrepresented anything.
> >
> > I suggest we first agree whether this functionality is useful for upstr=
eam,
> > before discussing implementation details.
>
> Completely agreed!
>
> > Reasons why this should go upstream from me:
> >
> > - Anonymous THP can introduce real memory waste, but we currently have =
no
> >   good way to measure it.
> > - With accurate metrics, we can make better THP policy: disable for
> >   low-utilization cases, or early-unmap to relieve memory pressure and =
so
> >   on. This is especially valuable for mobile/embedded devices.
>
> While I agree with your first point I am not so sure about the second.
> You can easily run the same workload with and without THP enabled and
> compare the rss to learn about a typical internal fragmentation (there
> are several layers of precision you can influence - only for process,
> madvise...). This is a very crude estimate but it gives you some
> picture. Is it convenient. Not at all but likely sufficient if you are
> debugging a reproducible workload.
>

Let me briefly describe the typical workload we are dealing with:
On Android devices, we monitor different apps and analyze the memory
overhead introduced by huge pages (such as 64K pages).
Even for the same app and same scenario, memory allocation and access
patterns can vary significantly and fluctuate widely. So the behavior is
not reproducible.

We could certainly use a controlled demo app for testing, but it cannot
reflect real-world usage.

> So I would start by explaining why this crude approach is not really
> feasible. You are talking about early-unmap. How exactly do you envision
> this to be done? I mean finding zero pages is one thing but how do you
> make any educated guess that that particular sparsely used page needs to
> be broken down and partially unmapped. What kind of interface do you
> want to use for that? MADV_FREE for all zero subranges?

This is just my early thinking, since we haven=E2=80=99t even finished the =
first
step=E2=80=94quantifying the memory waste introduced by huge pages.

My idea is to provide a mechanism, for example "MADV_SPLIT", which offer
the basic ability to split huge pages within a given range.
For example, split huge pages in a VMA whose access ratio is below a
certain threshold. The upper layer would then call "MADV_SPLIT" based on
the current system load.

Another approach would be to disable huge pages for apps with severe
memory waste to avoid unnecessary overhead.

All of these ideas are built on the first step: identifying and quantifying
the memory waste.

Thanks

> --
> Michal Hocko
> SUSE Labs

