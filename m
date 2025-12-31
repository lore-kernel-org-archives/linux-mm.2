Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C708EEEB565
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 17:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04FE6B0088; Wed, 31 Dec 2025 12:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2DD6B0089; Wed, 31 Dec 2025 12:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE3E6B008A; Wed, 31 Dec 2025 12:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B91D36B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:32:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 467458C518
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:32:32 +0000 (UTC)
X-FDA: 84280460544.27.F903302
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5D65840009
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:32:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NOrYELuO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767202350; a=rsa-sha256;
	cv=none;
	b=XgC4/4NExUwbS6k/UGrOMvBnUdlY2zDQTNCsQ8I4HHb4+IYmbFL7ySPTG6W3JE2MnmtBx3
	wX/1SlQ1vL9jsVnNPkq7drD75sOiZzjx+XouuerjznpYRJ78E0K82TfF/1SoeKwayD6DZd
	5eNyblYW2vHgfETAWgHwX8w/UmoPAls=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NOrYELuO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767202350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5VuiLn3dVAn40uBcT/YeDlX15d0jLQo0ZWVzvFA7PA=;
	b=jYpBB3n8Qwm/WLV/PhmKPjFcmZ9QjI9Z8smLE/wVYu9KtgNXMMY2l0ih2n3epoJPb5eAEF
	wz+fUffdD6wIl6Vqt5Sl4pvkuMxw7E2CRDGuRqGg+RX4u5qHvVXcUSqbT6axH5IW3uwMq4
	lfIlTFN59oQkI+8zy9wVeW481VBHJOo=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42fbbc3df8fso5450376f8f.2
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767202349; x=1767807149; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U5VuiLn3dVAn40uBcT/YeDlX15d0jLQo0ZWVzvFA7PA=;
        b=NOrYELuO7lkMNlXC6JG9FYTmc4wsA8W5tYbotVKm4sAS4aPPGZvWjsLMDEfqgCqfkx
         KirloJAOCbgx5EWVcHOcctopqzBYvp0TPlyvQOvZQI74/9OU+aKkuMmONiNI8my1JaKw
         R+iUFHpm6OeSC9HaxaKiLaBhLGaP0s2ufxDXbfXzypesAWm6a1ZU4XU0MlLQU1n+JixK
         Wqr2IAlJWv3dL388CE/MA2LnbjhnCXfUVKBZ/+iMkMNK8vWuQwXy9UBvtDAfT5p9Ipod
         ivwgtDkVpeFEGx2MMt1laFXUKA/SD81ZIaL2fy3wPmE1IrxqGshyDfazljp8eGBgeZrl
         0IWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767202349; x=1767807149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U5VuiLn3dVAn40uBcT/YeDlX15d0jLQo0ZWVzvFA7PA=;
        b=O0sGg10sPYzidFvMXMtzYFkJtedc0OY/Svpw2jWi++d0gwU/CNwy8MswH1BH9P0YV7
         zOXgB3OH2agfLKdtdXmcAV+aVHfVAB6Q5O21e7OpK+zKWSYj4mnofLYIHrn/dQyusx3c
         QBYmYUGf8yTS1MjA3qFIhAV7AO2evscPAzejP8xrF/16UjmZrluPRT/68gOQ7eSWGxk8
         Bd9osl+Rees/lo703YGNPD1QM0rRQ0jWbC7QLz863Pje86KrxGRR9D54i1ny7UqqKXbx
         AOUj6cYX6Lyhe+OGuDGa4OWViV9WuFPdD9ehV9Io7In1Iry4Q6TQDkE9PJnxVr8sA28G
         RQow==
X-Forwarded-Encrypted: i=1; AJvYcCXcHZGDIJ8ifgg63XaatH5mwHZiG+v3lRH57RLvhWv/lei+CPB4/7T0YkDLMJqBAXvespblp1vZ2g==@kvack.org
X-Gm-Message-State: AOJu0YyrCJDgdK0NKzykgKtsde1h9IX544RGG/HomjSk5XBSbtvN89Bd
	WteL5VN2+fOYvHr5aAdjrZHlglXV1E7jOZmQ7t759hgpvSdjjARiDHqHFbRfhpiVCyi8VxfHVF1
	HNbvoFnrqSrcsiQ+4ubmOqPoEs22gUH8=
X-Gm-Gg: AY/fxX5oxw5Wf8dzGAC5qZoQY/uUopUAnHZ5UndbDgOe7zW88dsnYXRuOD2QpmQIlq9
	B+kISHijFSkOptCyYRTvEHn54OHXKY1TE/AP/HV67aVLrT4Ubh5bc93qIjSATgG5eNUsFuwxBRN
	Cq/5HanPQTetDZJB9lnXJWiUNpLwS2EUvjujD26amKCSWJ6u5SO2WBzp244YcDtmIuL2n7JM01n
	8S9M/BzKRfLvMY/hZbg2t4uEYrWd57gUES+kaHgZXkGEdLU7OLLDMs1oFENUdeXuH9iDyxWSELH
	i14NsUFx97dfEfkyjXQz8g4YGVhJ
X-Google-Smtp-Source: AGHT+IF7HyxxRbtC84cXSMOHnJT4OH6Sl+m5edZ7DMni0hLzLRwsRYANm/mz1DDpTK4ecNOoY4W/98DOOm3T/bFVH4o=
X-Received: by 2002:a05:6000:3104:b0:431:9d7:5c2e with SMTP id
 ffacd0b85a97d-4324e501694mr44836005f8f.35.1767202348661; Wed, 31 Dec 2025
 09:32:28 -0800 (PST)
MIME-Version: 1.0
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
 <20251223044156.208250-4-roman.gushchin@linux.dev> <aVQ1zvBE9csQYffT@google.com>
 <7ia4ms2zwuqb.fsf@castle.c.googlers.com> <aVTTxjwgNgWMF-9Q@google.com>
In-Reply-To: <aVTTxjwgNgWMF-9Q@google.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 31 Dec 2025 09:32:17 -0800
X-Gm-Features: AQt7F2oadTXea_Sik1GVA2Fk1q8JBbDHb41lLkyeYrVxdpyCyv7zsIwArp1KPOg
Message-ID: <CAADnVQLNiMTG5=BCMHQZcPC-+=owFvRW+DDNdSKFdF8RPHGrqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
To: Matt Bobrowski <mattbobrowski@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5D65840009
X-Stat-Signature: cq4hp44yuy3ehu4za8dkk3czk5ys5x6j
X-HE-Tag: 1767202350-369332
X-HE-Meta: U2FsdGVkX19coXFtI9w4DAn+ujWovSQ3BLDH88MjRmkHzD5fBscnDjEnC68FFLHc/acazSc0eTN4PSI1KZlhQ8is88KHURSXXE11Lg05WDrSpYWzHx+CBuSfSwlW3zS1TqkA8iDe1owzPm45HbEBuYOzf3anX7RJTlwpKU6RKvzLJx3cT38KtfQ8AKWxOs30r0Rmb9sW8LvIEjO3CIXbZlaH6Hx/wW49IbcemGPeaDnpNpbdnThqHr7OOPA4ugz0z598HT7grsZryM5UZe/jMsra6PA3IzC2CJMHIJb9A2JxLMInJ5cDSeZ7QZOwxT26cuIveSznDdaYGSk0jUQnkKlfq+7OrtqAHgI9uM34hfk5aMUxLFLF2SRrXu7h/Qf8uTtIGqXWorZDNr6cZPv02B3N7I1tm4Frhyj7yi8VtsczFJU50TpySfIjjRKuIHqh/nsONoBTryYy50cip+RsNtUI/xfd4EGaR7N60TrxpoUyRynkwCZb86k1w5y+gl2/MB1ZB/GVtXe2LIVfKgvrV1lkeUKOoTORrLmtnVByQ6+dABg80Khhli80Jwom7OpZ0yUA6IzFu52EWzh+5ZNsEQlrqB9NWH+FyaVe5dTjYjqizBBaA/C+mQ7wqAVPmkrLaG5SEQwgH7rsCaWChyFoFa4EYk8h3CnzyFJhs2DZv0LwT5g03PP6UtVZtKewheDa08CNFuq5/cLiM0UKt2R2VFwFLpjsp+agzF7ylvn/vVbl4MsW74yeN5SDxAMlUIesIpFLOY+qkyAWpkZ0YlTF4HpfJBk/Ukgn70wZtlY6GWyj1R8SZP0jyi58h80swln/DBMnU+kYXi4zTYdTGVhCwyiUpLL3SboSmltojnU/KluKFYBeG2zpdM5sa9MJSparJislAHJaAFTNGs2CBi3vRea2TDQ2b0aSgx9qST0YpvDPezMYl1wYUeFlqMJ4AHLrn5OhOO/F/eOfqTfeMlk
 bFHTf3ZI
 k4GYd8P2ar9KVBg0tdAx9VgsP2QMDXTdpXMKGnlOVrgn6cO3vohyXxcnwkv2tMIin6ikTcmHXRQQV/j7KFK07pAptrRWHAjGS0zDm83ZlPAy++erIvaYe0gcNbmRIbwL/kzgTB3lMRZJboSYTTSN6H6oaUXBF8Yr+RbRbSUeXOAMs+kqtYaFplSKyGXYF+Gd4KM5fyvK03FyoiPyiVPyC283KmcZOSTmqPcgMoaNrI8jgV0MiPJ6Gk49R20Uz7AXHkiU9+fY9lpSZgbIT/vIHNmoV0PtQAPAEaybnQHLicDqyRQHiyVZntIcIQQ6QcLC69XRoRrtvn/T3zIwFb87ePb/kA/7+3oG4DQNZsH8RxcglGevG3yETEnW3CWkQusOQ3Rjix7e/5GhWDL+9/CklZxu5YSTp2mEgFIF8SnEBSg8X4aB7wn5Bm/0mq9EljjEiQRzOP1wLc3ETMu4gBWbi6FXfkx8pVvHoH0uAQtkEwYToenU0C5QOvkCFdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:42=E2=80=AFPM Matt Bobrowski
<mattbobrowski@google.com> wrote:
>
> On Tue, Dec 30, 2025 at 09:00:28PM +0000, Roman Gushchin wrote:
> > Matt Bobrowski <mattbobrowski@google.com> writes:
> >
> > > On Mon, Dec 22, 2025 at 08:41:53PM -0800, Roman Gushchin wrote:
> > >> Introduce a BPF kfunc to get a trusted pointer to the root memory
> > >> cgroup. It's very handy to traverse the full memcg tree, e.g.
> > >> for handling a system-wide OOM.
> > >>
> > >> It's possible to obtain this pointer by traversing the memcg tree
> > >> up from any known memcg, but it's sub-optimal and makes BPF programs
> > >> more complex and less efficient.
> > >>
> > >> bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
> > >> however in reality it's not necessary to bump the corresponding
> > >> reference counter - root memory cgroup is immortal, reference counti=
ng
> > >> is skipped, see css_get(). Once set, root_mem_cgroup is always a val=
id
> > >> memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointe=
r
> > >> obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.
> > >>
> > >> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> > >> ---
> > >>  mm/bpf_memcontrol.c | 20 ++++++++++++++++++++
> > >>  1 file changed, 20 insertions(+)
> > >>
> > >> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> > >> index 82eb95de77b7..187919eb2fe2 100644
> > >> --- a/mm/bpf_memcontrol.c
> > >> +++ b/mm/bpf_memcontrol.c
> > >> @@ -10,6 +10,25 @@
> > >>
> > >>  __bpf_kfunc_start_defs();
> > >>
> > >> +/**
> > >> + * bpf_get_root_mem_cgroup - Returns a pointer to the root memory c=
group
> > >> + *
> > >> + * The function has KF_ACQUIRE semantics, even though the root memo=
ry
> > >> + * cgroup is never destroyed after being created and doesn't requir=
e
> > >> + * reference counting. And it's perfectly safe to pass it to
> > >> + * bpf_put_mem_cgroup()
> > >> + *
> > >> + * Return: A pointer to the root memory cgroup.
> > >> + */
> > >> +__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
> > >> +{
> > >> +  if (mem_cgroup_disabled())
> > >> +          return NULL;
> > >> +
> > >> +  /* css_get() is not needed */
> > >> +  return root_mem_cgroup;
> > >> +}
> > >> +
> > >>  /**
> > >>   * bpf_get_mem_cgroup - Get a reference to a memory cgroup
> > >>   * @css: pointer to the css structure
> > >> @@ -64,6 +83,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgr=
oup *memcg)
> > >>  __bpf_kfunc_end_defs();
> > >>
> > >>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> > >> +BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NUL=
L)
> > >
> > > I feel as though relying on KF_ACQUIRE semantics here is somewhat
> > > odd. Users of this BPF kfunc will now be forced to call
> > > bpf_put_mem_cgroup() on the returned root_mem_cgroup, despite it bein=
g
> > > completely unnecessary.
> >
> > A agree that it's annoying, but I doubt this extra call makes any
> > difference in the real world.
>
> Sure, that certainly holds true.
>
> > Also, the corresponding kernel code designed to hide the special
> > handling of the root cgroup. css_get()/css_put() are simple no-ops for
> > the root cgroup, but are totally valid.
>
> Yes, I do see that.
>
> > So in most places the root cgroup is handled as any other, which
> > simplifies the code. I guess the same will be true for many bpf
> > programs.
>
> I see, however the same might not necessarily hold for all other
> global pointers which end up being handed out by a BPF kfunc (not
> necessarily bpf_get_root_mem_cgroup()). This is why I was wondering
> whether there's some sense to introducing another KF flag (or
> something similar) which allows returned values from BPF kfuncs to be
> implicitly treated as trusted.

No need for a new KF flag. Any struct returned by kfunc should be
trusted or trusted_or_null if KF_RET_NULL was specified.
I don't remember off the top of my head, but this behavior
is already implemented or we discussed making it this way.

