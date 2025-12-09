Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 722DAD1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 09:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AFFD6B0005; Tue,  9 Dec 2025 04:42:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560956B0007; Tue,  9 Dec 2025 04:42:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F6D6B0008; Tue,  9 Dec 2025 04:42:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 308D76B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:42:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB8E4C04A9
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:42:27 +0000 (UTC)
X-FDA: 84199442334.22.663C2D8
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com [209.85.210.68])
	by imf16.hostedemail.com (Postfix) with ESMTP id C589E18000D
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:42:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AUL5xQGN;
	spf=pass (imf16.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.210.68 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765273345; a=rsa-sha256;
	cv=none;
	b=7idfZso1lV6T7sxQP1HEdAnZ7kxMXJUzLj/OlnG75lBpfTZVfSn6BbPK/iBeShojrc8+p3
	fNHmDbc0FTBzdFIta9pSxp2kUgDZfrvwTXndrny1YICG4+wGRn8yO4K9XWiGAsYEFXhu/T
	2Y/lhspD2SNbq6gtBcl9ZqA4uJUmRvE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765273345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNvOv5ap80hjiFIY9x8LvAyoNUUxftLagOrd7bJRt5s=;
	b=cvcDTw1C7plcTu9IXR27dsGGu5CJmPxzPczn7P5vDetHrOd0/nrtiYxUI9w2Psp0/uNrO6
	Q9BaYKsA2kDUM8kcR+TlruXAp2Y49boGFFhWosDxt/i4r4+aeP6TxFXFKuwMQqAEmFuzN/
	F3g8C+2N7AzOwKZQgwPHgd8IIdBeMKs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AUL5xQGN;
	spf=pass (imf16.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.210.68 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f68.google.com with SMTP id 46e09a7af769-7c7613db390so3304153a34.2
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 01:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765273345; x=1765878145; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNvOv5ap80hjiFIY9x8LvAyoNUUxftLagOrd7bJRt5s=;
        b=AUL5xQGND2y9VMTFpSEhQN9Qitx9BmCwgrbEse6G+LY0aclN9+5eSOCQxiLO35kos2
         vO07msdK+/P/jnLDlNmC6erLimFb/hFnzndm3/+oXeIrtiOLnbK945MP+TmZbCUcCJTF
         yGHtYK372UlWCUR33YqnzwRWS3sSlxnNvfZr1F5uOK4RlpEunA2Ym2tmI5Owb1gOep2C
         n4Vr1/9zpHE/jyozi6w5qzBe0fVVILCI13bSGTg6vmbZG0jRBkcW+Wp7HyIM/oA/UB0s
         u+tHRYV9dhPCu5Hjr9SJS/ti0g6rCIlJoB8lLFt6mn/aE6oSZIgdmNZkMxwAMRE2YWEk
         jjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765273345; x=1765878145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SNvOv5ap80hjiFIY9x8LvAyoNUUxftLagOrd7bJRt5s=;
        b=lYuffjBqJushYfNG+wS/a1SuGDviffgTPedRBfwBuUvucoiqCrhqyrqOz1hl7pk1SX
         yabmOHs+6SMQzTDz3f9Etw8LyVZNrHZeKh1Nz2RykQdpUDq2fauW7hrEOar1OaIW3CDI
         cupB5iY9/cKzc0dtRVuSjCeNwhzJK1FKI6EnoYXUNlAys86ZAAVOiIS3qUN/HxBW0FN0
         uG73FZZS9O6xR3OYDXNIWDvlp8jgev9Wm6WqP263o6mnmnaXffnnlSs8G0ylGVEZ1Y8e
         /8BCUV6txovnUwBKPAt4AnPvqzYgVcVbyY5N9yAcWO2CsQbgaolGxMCsvbMcjczaVIOT
         laCw==
X-Forwarded-Encrypted: i=1; AJvYcCX6kMrBddccRzzT8R9jQTEfoSQTDQntMwBhVbJOWFDKwB9JOOiGKxL3cZ5OxRc5vIvEePnAJGcnAQ==@kvack.org
X-Gm-Message-State: AOJu0YzkDtm9VpYATwT5AOCFXzsEeF2e+Fn8NjP2Y3ZG/7sr5bQ0pZ8M
	fhIAaqrZokZ7zczyXn9500pQ5tupAvQLtYSOFi/9JRLRaDhDypnE1zUnShQn50vQ5JphZsgz0PT
	MbX6ExEiMU9IpVdWUBZZ2A5fDD3GaLh0=
X-Gm-Gg: ASbGncvd1nzWb/n/w9SrMk0xxcLz4gusDntnGHVQwLRLGAyFR/Jl2Qc+J5eTaI3kv8B
	9+yxTPv4fKkATPxkwJigrk98adXUVHgT6H5o/34DR8SKtAYZ2UQ0ErOT2zaW4hEyKpsGx5XhsCW
	Ka002npJV9IWK8NZEgvl8Kk1bQ48Imgqoryai31PJyvvBM7rxJZSXeYnOpgWU5DREfqteaQfTG4
	uOaQvNfOw6h7w5RMDYTdGo2xMRSI+/m74Is7aNfBtO1HP3stB9eAj4Z+aQwNrIv5n9TN83lQ+GU
	a5wEOOY3
X-Google-Smtp-Source: AGHT+IEvCNY9PoRZ/psQQR1euYnWnbiylmc1HqAFRj4AQQ4xrjBDyK/srqeNWQZArH075I2Rabspr4sS1Upvcmqv3z0=
X-Received: by 2002:a05:6830:254b:b0:7c9:5b7c:8a33 with SMTP id
 46e09a7af769-7c97080bf92mr6489192a34.19.1765273344774; Tue, 09 Dec 2025
 01:42:24 -0800 (PST)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz> <lvagftdnxgpyafafl2ish6x6phno6xstd6r3zxffs652lyxzyc@2pbngufu7wro>
 <aS_OrvHmgyhQzQIj@hyeyoo> <dq67tbm6bbvm7opvuq5vwtjjrcnrponmhfv7xwnvpv6vp3u2lv@bkruq4dtx3rd>
 <aTWIQ0s3EbOa0azX@hyeyoo> <8bbbaa65-2783-4006-97b4-a1628525e7c7@suse.cz>
In-Reply-To: <8bbbaa65-2783-4006-97b4-a1628525e7c7@suse.cz>
From: Hao Li <haoli.tcs@gmail.com>
Date: Tue, 9 Dec 2025 17:42:13 +0800
X-Gm-Features: AQt7F2qROshHCUshL1SmwTV9DvzVb0fD3hVLZ0SdtNuAnPqw8T4UFnSqzZ_WVn8
Message-ID: <CAAXMevrc0Xmza_Zo_zjwgqGSqMFw66cMw_uysX7GWDO2Y4VrMw@mail.gmail.com>
Subject: Re: slub: add barn_get_full_sheaf() and refine empty-main sheaf replacement
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C589E18000D
X-Stat-Signature: 49k68rc6ki9cfxme1f4ea6m5s5p5poom
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765273345-174726
X-HE-Meta: U2FsdGVkX1+RwAnV9DXUv7DcDoun6xGe1nHLxgE2SdL5Hcbox82IBLq5X1a3GelqPXwmuqgnedu7nz4GbrbjI2EDf8YEXXOyyfDq/r1ZClfakzXmDvlhLKSgLlhV81BjamioYfYHe0rvaxX4BNxFNS4NNr+rQKe8ZIB0I2aynVXIptPMdPbh3B1LnrHuT7HbXbyFYAoyeH+z2p+AvoPOk7TqOS9bCq5k8PW2qSDk7uIbUAevFPAaqJX5nPXSV3COaJxI5OyC5G0F2ZIZ/isNUX/+cSU87vJ4x1dR9CYVU73qxZNsaAU89Hmx4n5L2V8ow3518Uo0QHKHot8JahVcpeBi9E7H2WKKe0Yn6JdGXu785inv8oYwbLCR2TcbQ6qREEDR8hykXYXUeuHVeLlEkHUHCvVp1dNILMeCb3Om40mlupaXVI/CAW/YV/bHsSZBETnhTRnv8DrRRm10E7iy3Auwb5tsLBx6qtD5RtI1AMFBbmMwytCCmxZyTCN8DKBTS5rUW1rj7JGW9IfgmFzuSwu7lS3XOC2l4pZ5CDnCtXqbucsxVU5dlzOFYnE/8sCpZlQy7cd7q5CTEzIyQfLcAJWjUTLyxiEH28aTn7nr7mc+ZPrrxR1Fc4VD1k0gT1m9vVcwy2wddKjLTdW80xxM1iMWGM8Ma14JvPJYYNLLX3WrUT4r1Hp30/aJ9daq1xq2OTVL/0hTDC0S2sf7T4ThFdhfJ/62wfabyHfafWu2wbwOZtNmdbSQv+KpwJGmDZrI17MANEdPIA0lZ/JXolNFhjwhoDCdXyGvupwhWyDSPxIALGrfGKERieRQKwOD30k+zmUyDCLGet82N3XpqBmrkCt3AOY+7/Al6XwfOsASYpBFutBh02LyPcf9STgCCOc34xVObBhtXcGVArytXRLlX0fg8N3d3EfppQuAJ2FfX6ENgPw0u2LiLDtDAU2PSGVtkGacZfrYgKrTdY3yLpc
 xrWABK5x
 vQZ/uX3ZaJG22Xc+yNT/3u/Xd3TAGpjvqsjphYR1tMpmPbcqOfvt16CMEoghH1Dx1D1dNrWUClDxTWLEYTRV9Pk6E8dYkjlbb+AATAU3yN/au+H91j/loC+ov4+27IH9OgOoyW0zTUlUQL0nX1tyrdqdrEaaVBExTs0Ik8h3m0de6ZqHS0RHjXZmaWw+24aXdxcY0hXf7ymdyNsLHTtdoLkiRPNP2/jyi9ykqRhu0FpDh6X3xVX0+IQ6lLYGOXYnkEuVbEAGQ1dKeBtv7fWkgNfcVPMMiyV8kFUjVNqLlLB7/DIeKgQ2k5/ib/m32+8NPgwW85nJ21hoEHa5doh1TO+oDDR2n5lQCSj7+pojOkdv3IvcrVrts2GXH42kOc146RM7NLZcwKQghv10K1lLSOnSTTFyjPr4xAYeb6o7C4L6txKbXKIXt98BbbG/MqHjDhhiHaVejOB/ROig4CDzRNUd4126F/4y6bm89L0vExdzHOvFDm+XC4vUDGHQ12hXUTmF23KwaHAg38ZI6DdofLTX9fG8AmbJnzcm0A2sGVEoFj+MiTMkmYELztedrsyc07JlM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 9, 2025 at 2:51=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 12/7/25 14:59, Harry Yoo wrote:
> > On Wed, Dec 03, 2025 at 07:15:12PM +0800, Hao Li wrote:
> >> On Wed, Dec 03, 2025 at 02:46:22PM +0900, Harry Yoo wrote:
> >> > On Tue, Dec 02, 2025 at 05:00:08PM +0800, Hao Li wrote:
> >> > > Introduce barn_get_full_sheaf(), a helper that detaches a full she=
af from
> >> > > the per-node barn without requiring an empty sheaf in exchange.
> >> > >
> >> > > Use this helper in __pcs_replace_empty_main() to change how an emp=
ty main
> >> > > per-CPU sheaf is handled:
> >> > >
> >> > >   - If pcs->spare is NULL and pcs->main is empty, first try to obt=
ain a
> >> > >     full sheaf from the barn via barn_get_full_sheaf(). On success=
, park
> >> > >     the empty main sheaf in pcs->spare and install the full sheaf =
as the
> >> > >     new pcs->main.
> >> > >
> >> > >   - If pcs->spare already exists and has objects, keep the existin=
g
> >> > >     behavior of simply swapping pcs->main and pcs->spare.
> >> > >
> >> > >   - Only when both pcs->main and pcs->spare are empty do we fall b=
ack to
> >> > >     barn_replace_empty_sheaf() and trade the empty main sheaf into=
 the
> >> > >     barn in exchange for a full one.
> >> >
> >> > Hi Hao,
> >> >
> >> > Yeah this is a very subtle difference between __pcs_replace_full_mai=
n()
> >> > and __pcs_replace_empty_main(), that the former installs the full ma=
in
> >> > sheaf in pcs->spare, while the latter replaces the empty main sheaf =
with
> >> > a full sheaf from the barn without populating pcs->spare.
> >>
> >> Exactly.
> >>
> >> > Is it intentional, Vlastimil?
> >
> > Let's first see if Vlastimil had an intention, and...
>
> Hm I don't think I aimed to make this difference on purpose, but I didn't
> also aim to make the alloc/free paths completely symmetric.

Got it.

> Rather the goal
> was just to do what seemed the best option in each situation. And probabl=
y
> getting a full sheaf and populating spare never seemed to be an important
> case to warrant the extra code for a situation that's only transient afte=
r
> boot (see below).
>
> >> > > This makes the empty-main path more symmetric with __pcs_replace_f=
ull_main(),
> >> > > which for a full main sheaf parks the full sheaf in pcs->spare and=
 pulls an
> >> > > empty sheaf from the barn. It also matches the documented design m=
ore closely:
> >> > >
> >> > >   "When both percpu sheaves are found empty during an allocation, =
an empty
> >> > >    sheaf may be replaced with a full one from the per-node barn."
> >> >
> >> > I'm not convinced that this change is worthwhile by adding more code=
;
> >> > you probably need to make a stronger argument for why it should be d=
one.
> >>
> >> Hi Harry,
> >>
> >> Let me explain my intuition in more detail.
> >>
> >> Previously, when pcs->main was empty and pcs->spare was NULL, we used
> >> barn_replace_empty_sheaf() to trade the empty main sheaf into the barn
> >> in exchange for a full one. As a result, pcs->main became full, but
> >> pcs->spare remained NULL. Later, when frees filled pcs->main again,
> >> __pcs_replace_full_main() had to call into the barn to obtain an empty
> >> sheaf, because there was still no local spare to use.
>
> As Harry suggests, that assumes a specific pattern where we exhaust main
> sheaf first and then we fill it fully back. But even then this can only
> happen once per cpu and then we have populated the spare and are very
> unlikely to run into this situation again.

I agree that my original patch was trying to optimize a rare pattern and
added more code than is justified.

>
> Also it's unlikely that full sheaves even exist in the barn during this
> early stage when we would request them. That assumes cpus behave differen=
tly
> and some have returned full sheaves to the barn before other cpus have
> consumed their first full sheaf and request another.
>
> More likely both barn_replace_empty_sheaf() and barn_get_empty_sheaf() wi=
ll
> fail and we do alloc_full_sheaf(). And then... I think I can see an issue=
 in
> __pcs_replace_empty_main() that's more likely to be suboptimal than the l=
ack
> of symmetry you point out. When we reach the last part below "we can reac=
h
> here only when gfpflags_allow_blocking..." and we have empty pcs->main, a
> full sheaf from alloc_full_sheaf() and no spare, we should be doing
> "pcs->spare =3D pcs->main" and not barn_put_empty_sheaf(). Right? This is=
 what
> can delay populating the spare more likely I think.

Thanks, this suboptimal case makes sense to me.

>
> >> With this patch, when pcs->main is empty and pcs->spare is NULL,
> >> __pcs_replace_empty_main() instead uses barn_get_full_sheaf() to pull =
a
> >> full sheaf from the barn while keeping the now=E2=80=91empty main shea=
f locally
> >> as pcs->spare. The next time pcs->main becomes full,
> >> __pcs_replace_full_main() can simply swap main and spare, with no barn
> >> operations and no need to allocate a new empty sheaf.
> >
> > I'm not still sure that either way is superior, as it really depends on
> > the alloc/free pattern. If the CPU keeps allocating more objects, keepi=
ng
> > the empty sheaf is unnecessary, but we don't know what the alloc/free
> > pattern will be.
>
> Yeah.
>
> > So strong opinion from me, but I think it'd be better make
> > __pcs_replace_{full,empty}_main() handle it consistently,
> > if there is no special intention.
>
> I'd rather see some numbers. But the suboptimality pointed out above is m=
ore
> obvious to me. Do you agree and want to send a patch? :)

Sure! I=E2=80=99ve prepared a smaller patch and will send it as v2.

>
> >> In other words, although we still need one barn operation when main
> >> first becomes empty in __pcs_replace_empty_main(), we avoid a future
> >> barn operation on the subsequent =E2=80=9Cmain full=E2=80=9D path in
> >> __pcs_replace_full_main.
> >>
> >> Thanks.
> >>
> >> >
> >> > > Signed-off-by: Hao Li <haoli.tcs@gmail.com>
> >
>

