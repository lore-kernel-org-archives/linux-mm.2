Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0882D58E5C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 05:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305166B00A5; Mon,  2 Mar 2026 00:26:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1946B00A7; Mon,  2 Mar 2026 00:26:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B16C6B00A8; Mon,  2 Mar 2026 00:26:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 046DB6B00A5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 00:26:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8781013BBF1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:26:20 +0000 (UTC)
X-FDA: 84499987320.24.C488141
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C84F180008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:26:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CeIQ56BH;
	spf=pass (imf06.hostedemail.com: domain of airlied@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=airlied@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772429178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNpLqQXBYOorAHCllRmNXHlMvCZoey1fxBa1rcoB5e8=;
	b=IzvV2eT9gUqPwmueRIjOWTZpzjDEBXzX+5NVuguuA8bOixRseFUptAbnko8JRiXIkqcftJ
	XdXnbksmzZIN9gyr+0GDzZxuIeEf3RCK+6pWnZixpiEouuUuXaOvQEY9PAwGX4vcfUM+JS
	CXYI6T+js1autQBe7EJDlHNzk50XxO0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CeIQ56BH;
	spf=pass (imf06.hostedemail.com: domain of airlied@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=airlied@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772429178; a=rsa-sha256;
	cv=pass;
	b=NeXHOrnrR67Hjlq8GQXnJo+2xX4CdWCRs5npI+U+VI0c+ME8GznbC/2hhaaHVpomoVRW91
	TAXd5pBnFSjUlTd+iNX7uzJ3EotAwnjgdKmqOSHAk4pZKymBXHQ2VOKmVzRG0Hz469u626
	lz3GZs8DlHbABm4y+69UR4Ect94a0CM=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-899d6b7b073so33108066d6.2
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 21:26:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772429177; cv=none;
        d=google.com; s=arc-20240605;
        b=WArOeRD2Tbx46XCK5wKsC151Izto4CiKASUi/JvgIhfMl1LYvjRqspz6u/qa4IlCAF
         qqdvTuoJk5Ba1Ch9hk5v5SDLmwQXOBoB+4+Jay2r4AnvoZDLoIbu180/hl/DzcsleFVM
         yQ1yFPaUgfOPPYQD4iQPsDk+nz6nzMG38LV7UV6zxeZRue4m2SpBKWokvmwlzKhTv9og
         OYeLdffKqTZ9Rs7ZtWeRvLPMtcmoS4ajSXh6HMYQ34gjxVVeOJc25HuajTW4FPXSpRK8
         UmmeOoOqUEn6itmGirOZ6CqQwjG7rhW1tpr0ukG4spd554MXSyn1nLXbehtNnLv4qMD8
         5vvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rNpLqQXBYOorAHCllRmNXHlMvCZoey1fxBa1rcoB5e8=;
        fh=pVnaYNKxYAj/1hAfNqqOVrHM66EudFt1CfopEWj3pp8=;
        b=Xyu1FmnEyiruPqHWsxYM+AY0gUxcqb0CzFwNfnq7wrrZMnP2UR0sEBSiRJVOk0KpzY
         uKAgXq30FYNbNUxJwcSnmtuzphPcWAl/CeaOxBiRblQyTzXnVTCopHty5ZiaGeCIaSCQ
         xNXyzyQS1nUOgMu9wSvlbqBr4buwCkCqonmD4ntk2Xhw3aCNOrER6ld6bf95UYGuizzK
         PfWa/ZSkkfDVPUIFtC0Am0fGFHtm/eWHqubgrNGMDvv6k3t/lPcK+auDRnvLx7uXUHPH
         nU9ZF6PKesMvway6K3cqU4CU7HFp4JvN5/wvG1MXJSWd6ZnIbU8OkmheIEcraetYrj7D
         CSqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772429177; x=1773033977; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNpLqQXBYOorAHCllRmNXHlMvCZoey1fxBa1rcoB5e8=;
        b=CeIQ56BHjNinaKJ/E9R6awAGDo5rDsBJkozotcq5+rjojQtF6zufpCFpo/pd2U5deu
         BajXfRHZ8wpldFlEqweuDZfqSkU6mmT1+/yWkk+9JctYPKH5rBm7tLqslyWcJkF2egbr
         ln+SftpPqCrgjMl5TxDvjklZs9HEWBG9LdSIad8Qv6N2Kyfy2bcd9VaJIRGpxSi150GN
         1hJcrJ+kntKB2YmWyMYIbuSLXPbXYdltpPgdj9fzQCxBE2YZZw1bkcPi2peXcN+hsDjc
         nu8yeBVqS1h0jlZZy3yYN/E8goaLwfjyqMqyY+EPsd78dc8ME58GcSo2bgb30b3mU4ax
         Ta5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772429177; x=1773033977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rNpLqQXBYOorAHCllRmNXHlMvCZoey1fxBa1rcoB5e8=;
        b=OpaLXs+DkavXBUEjVh8gEUcuvxGPv6CX7iN6PPpIQzNzdS+GFVS/r0hk74+ZqWBWIP
         TWaxX60waqK56uC9/zvlehKkOjajiZs7EULTORUZGqHsA+3znccFdgOXkd2RvyrrOqmM
         Y3S9Kr/1TEg/UrbZFI+rOs8iiJfTiJQdFKVUifhBA+Sk6DDG4XBrCF+xMivs7u5dhl8t
         aRayGZ+XmBvQY9JqbHUQ69uGA4j+3sXu9vC+wAfEtgjmnM1Vsm+Z0W8h2Qf4s8T0ymIb
         qWLD+R2oO/aTFnSdUBcLLod/XfzwVFvRBStGTdylj0w4ug32/HIIk+9lUD4JH80tnPPJ
         TocQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxrJn6VX2a5pfh13cj7KapjbZ/HEOPJ8g2w3ks6abkPqb9YF2p5VI8TA5bzSpBs56zmniAzZwbrg==@kvack.org
X-Gm-Message-State: AOJu0YwLsdZb1BloNVYiD2CcZFbMNT07fM+nC0q2hTzaQYRxeb6m86k0
	vVrzuNgi5/b0nd6ZJ0SoYx8/UTFK364aGqv+q4b+bsyFp+ZqThuDv7PdIdf8dpOGng6Un8TL3wK
	VINSzRYj0+TSzk5uknxwmIEfQrontE20=
X-Gm-Gg: ATEYQzyZBxctrInvGOr2/gu1wTo0qvzhwdzZRmSDYRku4ljSyfnpYoTMSLf7bZm9LnJ
	kohYIZ3Ayl8zu6BBVjZ+yIVyNcmT5jerINQtv0GPei3wkcGErN+FrhzQteU8yQrg1DIrLx1dE60
	8lcuFiRKJEBiKKsyTuJTCOCEzLwiKg5qUGA2KvWIrfiaVDrnQbtfO3WB+1WtvVt21csLtwAg1n5
	1SzyUCJCs3Xtydaa3P86MzMwUmJvTiy+9dlzdCqkSwzjSj7s1UyhLigxIO5qXbVa1dwydDgipsR
	PrV+8kBWqs0HOTrFW8fMdjs+b68yqMq5dogXRXFnUtQ1URpBUqQrmaCdHNyrM2SYm8s=
X-Received: by 2002:ac8:7fd5:0:b0:506:9fd8:f65e with SMTP id
 d75a77b69052e-507528a59bdmr151673531cf.60.1772429177369; Sun, 01 Mar 2026
 21:26:17 -0800 (PST)
MIME-Version: 1.0
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
 <a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com> <20260224-solemn-spider-of-serendipity-0d8b94@houat>
 <56400505-8a13-4cb2-864c-cb785e4b38d4@amd.com> <CAPM=9ty5mbMAVHPO4mRy1jKGnpChr7gK6uMtco2=j7MMJGpZdg@mail.gmail.com>
 <d1b287c9-46ff-4345-a410-7e1cfefb5c66@amd.com>
In-Reply-To: <d1b287c9-46ff-4345-a410-7e1cfefb5c66@amd.com>
From: Dave Airlie <airlied@gmail.com>
Date: Mon, 2 Mar 2026 15:26:05 +1000
X-Gm-Features: AaiRm50W0fvfAVhf0ruGga4uliXFXx9vNuU5MHSLrll0LdDEQpXsLFepA1L85R8
Message-ID: <CAPM=9twnKZYOGchQ0cziSt5yUQxCXNWoKyBiQib2XWvkMiN=GA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Maxime Ripard <mripard@redhat.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Eric Chanudet <echanude@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	Albert Esteve <aesteve@redhat.com>, linux-mm@kvack.org, 
	Yosry Ahmed <yosryahmed@google.com>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7C84F180008
X-Stat-Signature: in8ccsfpwasbfhs11k1r83o6rmwng8uw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772429178-715973
X-HE-Meta: U2FsdGVkX1+mMvWoWXUniDutLlOOzCKpZgGt41dSKR7ojua79i5wHBNYhiiSf73Ru8cALItpTmvfPtO2qNZgW+Qf6tw643RcIyO5uFeTxDFbqD3Cay2Lk3Ol9+0pNQElYO16achbOAW3ZSXJkHsDIINaMZGAq1uRBtX7eM8VHCcSyK0NzZVxPX2SuC9/i/aHKmSfzBI6/1hJkFiiQR5JuR6Z2ORRa0o7/30ufTNwQ2fcGKHF9gN/dl5kAjvR6vSYRaBBqHaiB7f3SCaoF0K8dWulw5eTGIwgQSoyldLt+iRzE4Leni0eArXwV4J7nVfBauSPPimjutEg4F29deUnjk8FbeurCmMdVDrWHimnj7mQW8FKFftjCp4C1QcZ/I8+gZD1YTlS4qIpepGp7+PUFHTn1fy37tP13SQPprZ3AUweJbFpH2+PruiTfFmAri/isG5ZrVLtr2Smcp7pncGloxR78TwRZUwfkzF3l5HujtAdzso+suXb35/VF5l8vRx1zi2UZWc5+tnc3HHgG6P5Z5n2e+13mtOYfPJ5WZOJk230H5tknufBzcF4cvpKzGXRRBy++1VLcmwcxuCv2YGQE2YrMXKfNKIzxN0vwT+deR1sbRau8BXzK5aIJLhQ8H/fARJM0jX+7TV2OiDd0n7E+PhTDjkpmmGEHG7rV9/+5bJpdWYozlWedb6BWn1Eum3Wo8ZQYEva/5KFhxsU+WVIa/aK1AUvTVc2SbxrWkHtLyR1k0zStXax7tjkOVOH9ri01YObNwir9f3Y9SK5YEwk/FGW9BzxEyO43HjXGHnOdDsaLA7392fUSGVDingqhkF5nhWtHM+9oJpzdxGHslemUtxg9Mmt9LfEbkcR00FfWt7/REoSQ/zlbUfFN/sXxqWoCLl43F62FclaMCyWcRc6wLTsvK83PfXYUg4b1B0qlihAwqNGgWhbRb0/MnGHbeKc1brrd1YfYnQZgcAOHXK
 IRWJzZLn
 SXIlJGGKzU48dYVOc1M2EfTWITTQlyvOL+wem2CGcTmRPhI1uMvINwnZh+YNFz7aiNvzNFvl15JjBZUBEStzgmDm8N6tUob3Z+KTnKl6M6XYYLN2xOjyznVw6iMUpEOvEjOwJdiZx8SnUnxwfPPirGUj6oE6ZJVwe4RE2Za0T0KCauCsAMMvvY3U93H6TEBYbAs6Jgx/HZDo8hh79DoxFVdgUCPhMMgQ6uh+8ZuObUkgrlRFutr9ph363XiI/7brK2w7b8s1LqAPZVXi26Ey7eA+t8Xzqkpsr7+nl4RVhgOom26QnsUqSVqkyYlR8qBjUk/hHmuIllypp5EBFkPwJe30RzrJ9QCOP6VHI5egEfjVCwtOLDQmmt5a7RRa5xiLDyfvkP+dtOdalxloJU63RDdPiAY57dFxmtZFssifHn9JfnL8wcnlPBd5kFPEAeBa8gJRwHj85aog9+6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 at 21:32, Christian K=C3=B6nig <christian.koenig@amd.co=
m> wrote:
>
> On 2/26/26 00:43, Dave Airlie wrote:
> >>>>
> >>>> Using module parameters to enable/disable it globally is just a
> >>>> workaround as far as I can see.
> >>>
> >>> That's a pretty good idea! It would indeed be a solution that could
> >>> satisfy everyone (I assume?).
> >>
> >> I think so yeah.
> >>
> >> From what I have seen we have three different use cases:
> >>
> >> 1. local device memory (VRAM), GTT/CMA and memcg are completely separa=
te domains and you want to have completely separate values as limit for the=
m.
> >>
> >> 2. local device memory (VRAM) is separate. GTT/CMA are accounted to me=
mcg, you can still have separate values as limit so that nobody over alloca=
tes CMA (for example).
> >>
> >> 3. All three are accounted to memcg because system memory is actually =
used as fallback if applications over allocate device local memory.
> >>
> >> It's debatable what should be the default, but we clearly need to hand=
le all three use cases. Potentially even on the same system.
> >
> >
> > Give me cases where 1 or 3 actually make sense in the real world.
> >
> > I can maybe take 1 if CMA is just old school CMA carved out preboot so
> > it's not in the main memory pool, but in that case it's just equiv to
> > device memory really
>
> Well I think #1 is pretty much the default for dGPUs on a desktop. That's=
 why I mentioned it first.

But I don't think it's what we would want, if someone allocate a
system memory object then we should memcg account it. But in this
scenario it's where we really have to face eviction, and maybe in this
scenarios it makes sense to state that we need to reserve memcg space
for swapping objects, both out of VRAM and into swap itself.

I'm starting to think there isn't another good way to deal with
dynamic power and suspend/resume if we don't have some accounting for
moving objects out of VRAM into system memory, it's just whether we
can do something special to account for it, but not destroy the
process on behalf of another process doing the wrong thing.

>
> > If something is in the main memory pool, it should be accounted for
> > using memcg. You cannot remove memory from the main memory pool
> > without accounting for it.
>
> That's what I'm strongly disagreeing on. See the page cache is not accoun=
ted to memcg either, so when you open a file and the kernel caches the back=
ing pages that doesn't reduce the amount you can allocate through malloc, d=
oesn't it?

So the page cache is accounted according to Shakeel, so can we find
some other example. I really think this is a bad idea, partitioning a
single resource into two competing pools isn't going to work that
well.

>
> In other words system memory becomes the swap of device local memory. Jus=
t think about why memcg doesn't limits swap but only how much is swapped ou=
t.

But we still need swap for system memory as well, but there are
systems with no swap configured, and on those I think we need to be
integrated with memcg anyways to make it work.

> For those use cases you want to have a hard static limit on how much syst=
em memory can be used as swap. That's why we originally used to have the pe=
r driver gttsize, the global TTM page limit etc...
>
> The problem is that we weakened those limitations because of the APU use =
case and that in turn resulted in all those problems with browsers over all=
ocating system memory etc....
>
> Now cgroups should provide an alternative and I still think that this is =
the right approach to solve this, but in this alternative I think we want t=
o preserve the original idea of separate domains for dGPUs.
>
> > Now we can add gpu limits to memcg, that
> > was going to me a next step in my series.
> >
> > Whether we have that as a percentage or a hard limit, we would just
> > say GPU can consume 95% of the configured max for this cgroup.
>
> That is only useful on APUs which don't have local memory because those m=
ake all of their allocations through system memory.
>
> dGPUs should be much more limited in that regard.

So you think we should limit the system memory allocations on dGPU.
I'm worried about GTT|VRAM allocations which once evicted, there might
be no reason to push back into VRAM and that ending up as a backdoor
to allocating a lot of system memory and bypassing memcg. I don't
really like the idea of bypassing memcg at all.

>
> > 3 to me just sounds like we haven't figured out fallback or
> > suspend/resume accounting yet, which is true, but I'm not sure there
> > is a reason for 3 to exist outside of the we don't know how to account
> > for temporary storage of swapped out VRAM objects.
>
> Mario has fixed or is at least working on the suspend/resume problems. So=
 I don't consider that an issue any more.
>
> The use case 3 happens on HPC systems where device local memory is basica=
lly just a cache. For example this one here: https://en.wikipedia.org/wiki/=
Frontier_(supercomputer)
>
> In this use case you don't care if a buffer is in device local memory or =
system memory, what you care about is that things are reliable and for that=
 your task at hand shouldn't exceeds a certain limit.
>
> E.g. you run computation A which can use 100GB of resources and when comp=
utation B starts concurrently you don't want A to suddenly fail because it =
now fights with B for resources.
>
> > Like it might be we need to have it so we have a limited transfer pool
> > of system memory for VRAM objects to "live in" but we move them to
> > swap as soon as possible once we get to the limit on that. Now what we
> > do on systems where no swap is available, that gets into I've no idea
> > space.
> >
> > Static partitioning memcg up into a dmem and memcg isn't going to
> > solve this, we should solve it inside memcg.
>
> Well it's certainly possible to solve all of this in memcg, but I don't t=
hink it's very elegant.
>
> Static partitioning between memcg and dmeme for the dGPU case and merged =
accounting for the APU case by default and then giving the system administr=
ator to eventually switch to use case 3 sounds much more flexible to me.
>
> At least the obvious advantage is that you don't start to add module para=
meters to TTM, DMA-buf heaps and drivers if they should or should not accou=
nt to memcg, but rather keep all the logic inside cgroups.

I don't think we should have to static partition at all here, it's
just asking for problems later, and it without proper accounting will
cause a bunch of reclaim unnecessarily.

Dave.

