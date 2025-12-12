Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 002C0D59D79
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 17:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21436B0006; Fri, 12 Dec 2025 12:27:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAAE76B0007; Fri, 12 Dec 2025 12:27:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972E16B0008; Fri, 12 Dec 2025 12:27:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 804BE6B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 12:27:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 196C657F37
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 17:27:04 +0000 (UTC)
X-FDA: 84211499568.10.42D7300
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25B07C0003
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 17:27:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TpOsIObS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765560422; a=rsa-sha256;
	cv=none;
	b=X9KHeXPDKwsKx+F75Lg39ipli+JRCgiPbdpJDjEFiYJfhPWvc4cyZvuKWf3QMa7vf6zBjO
	N54rE8pIQFKzKGVjCgok4njhFuRCrOySuM/l9daFFsu2ZzL+8WxKJ7yd6GkfpjY+8E5hv7
	/3cx0eaaupI4YLG+RflfKEGJlC/PIH0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TpOsIObS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765560422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrjGOtxF0XS4u4HkkRS7cxhaN30UWwIW9g8s2Pp07/4=;
	b=dqM3OwCpRDBi56BQPMd4vDY0loVT2b+7GNW14Sg2Hyq3N0nD5Ss2NtA17on8elIR0paZEQ
	qCsroyVdAUJ1lYv7gFVEWMjqdn3MVJ2Ih3qByLmsyrG+ng4J+pXYwMmX+rBsk/5zWKVtRW
	yWDhFQcbrTN9dXL4QvUf4NI749iPHi4=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b736d883ac4so240483666b.2
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765560420; x=1766165220; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hrjGOtxF0XS4u4HkkRS7cxhaN30UWwIW9g8s2Pp07/4=;
        b=TpOsIObSVOqKSxJnYhvT3gvCuKkM8P2c7vTr2pL00npvRv3oeLXt88BHSDSu/QNSEy
         KuQ55xcq4T7FvcxuTVipxV747EyTCyZDOEFJAD7g3coaP5VvqE7Xf/a1Zgeqe1b0H0yA
         txuBNgkRbqmg1Rs4snRy7QVm+SSLGfaLrNu1quO0qLwfg715rHkpvD+pzQoXk/HRhEDM
         HHuniL3TbNbt22wIUc9I5esFfJavmy6DSp662PTs7OBYw2FAJuPMAa+zs/CSo0C+r/JU
         et81hiZXkBDr7IG5YZMA8jz/lsez3Vg12JezOa3U1wOk/d1HHo5gATCDBEGC4TxeQpzI
         BcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765560420; x=1766165220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hrjGOtxF0XS4u4HkkRS7cxhaN30UWwIW9g8s2Pp07/4=;
        b=Lq04icRDEoYVKWPute9OuS1dze42UHOGVOhdjiFbCo12IYw4jr8ZGoEfL4sydsTd11
         fb7Ah1tAnujR+rWgkoXeD8gstCg+9qWQT9w9v9HFJcAg0gKSn3wxGT9YMLFauLGjWF2G
         /ZXz70BNJCaO9SFMSn71pvO+8oLpOIQoUKAH8FgymK8wstFCu7pBiuc+q8PMpJwbU/uy
         S6L1wRPCJgvEVV7X4hQ0xqvMrsRVb/qVfB0BOhwKVRD4b8fODNP/Z0h/iWX6vCGcWRUw
         +y7icrZKUHtmQ2uh8yKEQ9hkVwXbmyeE64AKpUlBz6CRh4PpzSDMB5tooK7fxaier3IE
         vJrw==
X-Forwarded-Encrypted: i=1; AJvYcCU3h91xbFKVPbSxMfHGP065wGJuXosEToW/lf+hTfWuV1PvLpwPaITOxtmrZDMGaEORmYt768reUg==@kvack.org
X-Gm-Message-State: AOJu0YzEvCn69WxddP1jjZ4BCpiwrg2LlOQC433bHA6hsYVtUIOz3G4l
	D9Onxu2mWrAXXPWrrvrkQYDT+VTZBhRJwdbKFhKoSDSbS2cUVK72q9IDdbnaaF1wfOMXOhm0fzE
	lOqaD3Ww7a5bRcld322/MLHfqzZOh4cw=
X-Gm-Gg: AY/fxX5qCYvYj+tjVkswNEL8eADKS3wUq3LRjaw1jae4OTadrp0dpEbuW2tT2yIf/Mj
	HnNiO6jiFbAigZ72ZtI8/9l5VnA3KkNm+jX3jUV+e81MauI0VZdUeDxKUKccv+USiTuLBp8ieRY
	BrnOGxw3ci+xFIEQZrW5AZkUMZ2nEADMpWsX5Sr9VhZtwQacJwu5abDta71Gs0Zx7Ms/Nv4MKEh
	Z7OZx/W0iPn7nbtMH/EunMfH+RibRhJtJx4kA6KFcaUmfSviyf8mM2BGUCAWT3eN9aHzjJtAFer
	Y4sU6EVHd1kYYbs042g2VaWCDYA=
X-Google-Smtp-Source: AGHT+IGDy0F0hCcTVsfUtCd+kqecHOi5mrw1F91V32LsdX9zuCN2gfaWAybvzvKN4dhj/r0YzJIK9+W01VQYTwPINoI=
X-Received: by 2002:a17:907:9444:b0:b79:d24b:474d with SMTP id
 a640c23a62f3a-b7d23694eccmr265606866b.16.1765560420235; Fri, 12 Dec 2025
 09:27:00 -0800 (PST)
MIME-Version: 1.0
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin> <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205213449.12bf4819@pumpkin> <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
 <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local> <7006fa60-f4d3-4e7d-8c2b-974e9e4a1224@suse.cz>
 <ek7v5vxht56g77kbojo35eqdcqdmxjvguf3tp5wnfydopbthb2@xie6b7r53ote>
 <CAGudoHHFeuEQ0kBYfrYuUPxNQdw4YHNG81JiHPFHq0evUcEczw@mail.gmail.com> <9cd62896-f259-45ce-9165-63b74f7c1f6a@lucifer.local>
In-Reply-To: <9cd62896-f259-45ce-9165-63b74f7c1f6a@lucifer.local>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 12 Dec 2025 18:26:47 +0100
X-Gm-Features: AQt7F2rfOf4NJ7siF9Q1PeA5NLYcbgeqBzYqGbQF7MW0xuG9bi7oJVURj2SKGl4
Message-ID: <CAGudoHHMbyjO7uFGhpuYWmqTOk4oYwKt_qWoEfvNgsFtC0L3_g@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Laight <david.laight.linux@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25B07C0003
X-Stat-Signature: 7umd4tc4xphmhwcqi51acw4mtbprh3t9
X-HE-Tag: 1765560421-34899
X-HE-Meta: U2FsdGVkX1/y0k6X5XkUJ1V7jQF6zF9KBfu6NiDBj6ahyW+coxM3QLgatzvWJAJxpe1TtVLfxaUXqPAcS6VJNleGy4KpRBfDSvAgaM7vhG7LdcW54IUVuvvAMYp37t2fn9O4rOeqLA40sZPYuhQrOCZvD/o77tkymUCnydLOfqcwQCO8bUgmrWbtUjjQA6WfEKgrx6VkV3GISsQwHtVmZmAYSjXUWvJwe427b/hJNrSrEVsaKUTtTwUyfWKIA9g2OBgw8nk6E+sirl24/AgsKFE5FTqhUtEy9K5rBOaFTtqlZIDgDjHamxGZk270uM/HHah0LZz0MeEE2nKdxjVNB+13S240/cRzX0AWNtPMG3iguGY2ygmaRoDGeRV/uSKG54VAy9ubUtvqe+CuEBhasdsM05eMJxuCsuEfexPVDP0AdlRheusk1YNUtVij3Dj9Q/2sJFoaOLDUh1HGTAgIua9Jx2hY/HD6eHTESG1tKrBH6DhOZwjA/6NdTVVSfsu40UN2nkyViu7/tzuyWrzvnn/Qu0AKlGZ3my0yKrgpvM32gIeCCjOe+u2kLknEyyUhsEfLyy/uvCfZ0jAy4ReuiuR4K5KFqVJQxnBmC73Akt/jZJB32U54UpqubtIt1ykWrkobTUDIZJZPumc8gS3NO2kg8ZCUvt42+ytv0gsqN2j6OCvLZZYvBnlwc7tB5FuXBPrlfuGmh7ODIhTPvYVy3uGY8faTlNR56GddbXGvhV/0EFbKONPndXC/lbGoAJvv2POvyV2osGO0p1suHWRn+SIY2cbXEnTooOV6OCFwqusgSH2WSismp7/I7UfO9x2jC0WsXOd2HZW8FmfTnQlI2uxqB86xLQrUKgQLiYX3DVu50UDCF0nRCgAmibY37ramWuRnh9xyrei6d9vVdBXx1jIOeHf7v+EvqaSrFIpakURUP0rwpnHK3Ra5rb6qELswT0t4iaBhMf1eyOONzlx
 4yqZJkA6
 unYxMwbfGZdIV7ZR2E6XKMpJzShE1AAEiILpOoYw1hktHc2RzkZZp8R8T28MtMvLY5SNjx4+n1h0GE7TLbuwU221aEtK4Jrup7JBgYCOuOtzUbaQIk1ZYTaGxuyFM79UCN/Pl7gFzoTIEfVyX8N+Y4HGtriqFIA93NCScA0ENktuik4NO9abK2PdNGtcTud3S2lZ6xox9O3yQLsFWrn4nP4kRIrZtHqw2AKabvXR7tFoaCi0IbsdWNuDoeM4R1HIBsGSWeZmYiAv2TGOvx0nWMFL2dHmJEjvP8+IjSaOondVOSSfhu0xXxTd81nCaKlGxukS1Ak4yi1UTqqzWZVSLQb0iKt/UNZrt7BfVNp3SOL2tGsmrfNg42oTBRffRBwCAPSCjuRCZosNOxRl1joQ9Qk1OHHqAbSuBGhX/o2jwdhBMq/rwypinljiSsxMdYq9Zufo9RQTqIirRctVrIv4eifLzWwNKrDl9dzPaL7STQnFBsz9FG0dg7279+As9Y2B7YuUfEwki45t0/eBlcvAFcDhuauj6/j663uF+RSWxEaKB7ELCub0RNaoif/fxk9EXOo1ImRx68PCCPVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 4:03=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Dec 12, 2025 at 01:24:57PM +0100, Mateusz Guzik wrote:
> > So I had a look where the timing difference is coming from and I think
> > I have the answer: init_ipc_ns does not have a guaranteed cacheline
> > placement and things get moved around with the patch.
> >
> > On my kernels (nm vmlinux-newbits | sort -nk 1 | less)
> >
> > before:
> > ffffffff839ffb60 T init_ipc_ns
> > ffffffff83a00020 t event_exit__msgrcv
> >
> > after:
> > ffffffff839ffbc0 T init_ipc_ns
> > ffffffff83a00080 t event_exit__msgrcv
> >
> > This is the pervasive problem of vars from all .o files placed
> > adjacent to each other, meaning changes in one .o file result in
> > offsets changing in other files and then you get performance
> > fluctuations as not-explicitly-padded variables share (or no longer
> > share) cachelines.
> >
> > I brought this up a year ago elsewhere:
> > https://gcc.gnu.org/pipermail/gcc/2024-October/245004.html
> >
> > maybe i should pick it up again and see it through
> >
> > as for the thing at hand, someone(tm) will want to make sure the
> > namespace is cacheline aligned and possibly pad its own internals
> > afterwards. Personally I can't be bothered.
>
> Thanks! Looking it seems we accumulate a bunch of offsets in:
>
>         print_fmt_dax_pte_fault_class
>         print_fmt_dax_pmd_load_hole_class
>         print_fmt_dax_pmd_fault_class
>
> (entries that the bloat-o-meter confirms changed in size)
>
> That continue on to eventually offset init_ipc_ns.
>
> It actually looked in my testing like performance _improved_ with the cha=
nge,
> and I notice locally I end up aligned on the struct:
>
> ffffffff82be16a0 T init_ipc_ns
>
> ->
>
> ffffffff82be1700 T init_ipc_ns
>
> Examining stress-ng before 2b6a3f061f11:
>
> Command is:
> $ stress-ng --timeout 60 --times --verify --metrics --no-rand-seed --msg =
$(nproc)
>
> Results:
>
> stress-ng: metrc: [1662] stressor       bogo ops real time  usr time  sys=
 time   bogo ops/s     bogo ops/s CPU used per       RSS Max
>
> stress-ng: metrc: [776] msg           964459758     60.00    154.63    63=
2.77  16073484.12     1224879.38        21.17          2132
>
> After 2b6a3f061f11:
>
> stress-ng: metrc: [782] msg           1326214608     60.00    194.19    7=
13.34  22102974.72     1461348.11        24.40          2140
>
> And if I simply do:
>
>  ipc/msgutil.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/ipc/msgutil.c b/ipc/msgutil.c
> index 7a03f6d03de3..df0d7a067bcf 100644
> --- a/ipc/msgutil.c
> +++ b/ipc/msgutil.c
> @@ -26,7 +26,7 @@ DEFINE_SPINLOCK(mq_lock);
>   * compiled when either CONFIG_SYSVIPC and CONFIG_POSIX_MQUEUE
>   * and not CONFIG_IPC_NS.
>   */
> -struct ipc_namespace init_ipc_ns =3D {
> +struct ipc_namespace init_ipc_ns ____cacheline_aligned_in_smp =3D {
>         .ns.__ns_ref =3D REFCOUNT_INIT(1),
>         .user_ns =3D &init_user_ns,
>         .ns.inum =3D ns_init_inum(&init_ipc_ns),
> --
> 2.52.0
>
> We observe:
>
> stress-ng: metrc: [764] msg           1321700290     60.00    196.73    7=
23.82  22028700.93     1435779.72        24.75          2116 aligned
>
> So this really _does_ look like an alignment issue.
>
> So I think I should just submit the above patch right? Can you see how it=
 behaves for you?

It is my recommendation to drop the matter now that we know the vm
bits patch is a victim of circumstance.

While slapping an alignment requirement on the var is the usual fix
and is a part of a full solution, the situation here is of the fucky
sort and stopping at precisely that might happen to be the bad call.

I state again there is contention on a spin lock and contention on a
rwsem separately, and most importantly that there is a level of load
on the rwsem which triggers pessimal behavior during which it abandons
spinning.

If the cacheline bouncing affects areas used by either of these locks,
you don't know if you got a win because you in fact *slowed it down*
and avoided the pessimal rwsem condition. Then if someone(tm) fixed up
rwsems, the ipc code would be leaving performance on the table with an
annotation specifically putting it in that spot.

So I would refrain from adding it as is.

If I was to work on this (which I wont), the first step would be to
stabilize the rwsem problem. Afterwards annotate the init_ipc_ns var
to stabilize the placement, afterwards rearrange the fields + add
padding as needed to reduce the bouncing. But this can't be done with
rwsem behavior at play.

