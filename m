Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7654606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kuTshyXm
Received: by kanga.kvack.org (Postfix)
	id E777A6B060F; Tue, 24 Nov 2026 12:13:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E556B0625; Tue, 24 Nov 2026 12:13:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D1F6B0627; Tue, 24 Nov 2026 12:13:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A813D6B060F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:13:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2422FA0946
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:13:42 +0000 (UTC)
X-FDA: 85470659484.22.6C87ABA
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 30087160015
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:13:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kuTshyXm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795540420;
	b=QEKev5HDCuKofcfX7uGVGQI3kOtoTMSFh9LxY+oD9ZGP9NdzlA7wsqLleVJOTf3qtxww7m
	rKD47Y1i2JGwwzhVzrYf1YdoBTLtoYcE2rSO+9Gn3/2pp7DiViwX/aR4Rnq+QJESm35/CB
	qZFEji/BlMg+aupHA88OQWpdqMLDqfI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdBRQuRPxwEZd2+vFYBwLL5uePULho2FVfb2iukzoGg=;
	b=sKRdJYZNbpbniCOuOU535F7B/wxqV9BIyASAR+shtKxZy6MUYfcQmOyCQQjLTTHYq5qhFE
	kKN1NjkdpWgHyxij/ahOzZ05uZtLXfEwuhI6UGMMLD3mdt4Sw8iKFag9DPhCScoeyDa2E8
	CVe+eJ29tC0dr302xnd6M6XDR5nHhsI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kuTshyXm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c50ac25cdd4so634132266b.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:13:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795540419; cv=none;
        d=google.com; s=arc-20260327;
        b=K6xWXMPl3CnY3OTyLv+98Wwmr2dY3QHGZtMEb14rCA4qcNGG5XfrO4Wt8OHvClizd0
         jtne4hUbhcQkRZynFYI6mWtlmzcKhfXaB44vfHg/S5INemvgrtZ9CsXBuIibAwjWqwKc
         LJtye+RZO95tHdDORQEEVwKu+rmVVBO4XGa6roBPnAdPxB11pW5SMEgVm5LarliWwbSt
         xOsnE2WR13GtlDRGDbguhVX+8Z9k059p8/BwL7oi6YvjGZ/quw+4EDOYCwCFzGqzAr+G
         U2gkTcoe/lsHMut0lwfUqGn2msDqKqGf09CF6Mgb2XK3ZTn1B4cfr6asnuRC7cFKV1yM
         DTqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tdBRQuRPxwEZd2+vFYBwLL5uePULho2FVfb2iukzoGg=;
        fh=kKs5MgCeRh33Mbcz4GYT5GnHXGCsSLmbajjELHpTA/0=;
        b=jY6IEc2/1Qx/Di9GOWkZhnLJfZgt0a3RL0LWqGeQScYr8MjWiQHnp0QGGZxbouIrQt
         MvWmEeUhE0iJT6UHHy90TJ4THXDnleCEHW29ky6ugAA//0/cWOA6+B7NBoUoM/Gb6Vrm
         VYdPNocJFKnP+aR3H9ny/ALQxy7xdjEAB5jL/j18oNr4orJ7oWbgayOEqkjA3slD8ssq
         ODljCxG2r7OHcT6nevF+DztUaMY+WTTerB6Zmcv4S34jbT5evfryiOFnhIm7wm84YyTn
         x4QROOAKwG1GSmb5aMaENxG6CKQX/Lf0R3waC2BfHruFD0cpemOgaZ7v4yc0rMqLD2Rw
         oNYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795540419; x=1796145219; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tdBRQuRPxwEZd2+vFYBwLL5uePULho2FVfb2iukzoGg=;
        b=kuTshyXmfmMC7OQyA5OXDAunoItPEC3KDwoPg7pUkBoipphYnQ8c+C16vKhrSrnHWr
         oc4jY0sNZKt4yZdQk0/ZtlsngH+f1IVxZfHPmVoSQkVfHamLFafE1xpozYo96tvAxnmD
         qAl1cEYOXbActRRxWfVw8l44IWNzvOq13a6jK2qKdi9VmCsiGhfdMq2Cq13aUNXokexZ
         iL+a0CZnaeDZcby+6lbXTl/P0/9iSS2ChR0Px3N3eInpVyXAa57FPA5LFxjbqQNLL4iB
         tr7ix+MGzyvpqm++8yZx4bdjB87AWb5seTcUAuDHSmWYRrulcT9lodOla843VVucoN5Z
         ebMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795540419; x=1796145219;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tdBRQuRPxwEZd2+vFYBwLL5uePULho2FVfb2iukzoGg=;
        b=FQEBZOzfxp8MD/x3muJwvkVwXQOYnB6mM0yt/ieH1FARFowA21jT7pT4U4/j4Gof4H
         UHE/dQq3YX4gdk6WrQE0vUYb3NOwcuZ9cQeT2/jiKVf0wamsx0W+x61/CCQ4057yGrcs
         SCzSO14Yd8ufIl6ShNC2HFPYK7dY06+wKkMZ2k+ImWa22Pw2car3Pg1mOq23wVoqsg4Q
         QtmTMwfyZc9KJrGtvmyrZzKFmzznRsQ8xqXPJaXzYjHevAAf+DEq90Wqf+Hm30E48NxP
         BE6vzMpN4BV4ZmQmxK9Ce2qfyONatqlV7pbVqCDs9hLOiv7Dh8US8HZHZ90sKMPG/8wH
         HfQw==
X-Forwarded-Encrypted: i=1; AL+hErGYJaL3z/92POhDnQVA0GYvb3LTYcpUI3vVS4Z77TuIX92MnqJ+zO209MFACHp6WDPDVf889IDxZA==@kvack.org
X-Gm-Message-State: APuU4Z9HzJTQpRve+wKt0GL415S7LweszwTZSCOXuL/U3TafBl0TCM8M
	RL2uiT3zkyscM7NPyxWnHtypN53TjOB5Jum9ICJ46a9mCpY71xaijCQG9fg6DS5HE2f/CoRTlHd
	mw6KIWeHd/NnoFiOSDrFOmEi2DcrIXvHlxZIpVHy3
X-Gm-Gg: AZFdTZddPqCi1x/H3vnT19b9QbBO5TfMIBLHg+ohB6V9ErOJOXf04h9P6ue1xLrszJQ
	ghCeK3m1Tqb60F03qbVMNWSHeosTii5i1x1C5kmr28bAe3QU7t70mkW01R9VC7viNmMZ47/TC9f
	fW3cfAmRArzxD2M87eWm6S+Dw63tVYENTiPt3hsZI5TYT3HxsIao8FJJXDQoSYd1I9rEDXEFbQV
	yDlYvhFRzLzumSnp4d1yNIZPDBEFZ7foCk1KSj6QwcmJFeCHbR/mJlsrLBFuU6YSh51g7Ag6wU1
	tJSWjRPb/E6c0SXtWRoh4IzTshsfZHh8ROp4PtsZmc8uBfL2SU3UDnOf8kieSVPrzKpE4HXlTUs
	VC+gsZKr1O5wuHZjsjDYH115J5LFM+V2kt5GxLIaPG8VVeAmC1d4FNI5jk6H04ubu15KHAtCwcb
	T8mFojlSqoxaByBPqYxQKj3FyxSTzKTiRkOnZZxxwsV1LDCgc9ngqE1wMvSyjVte2DuHw6TYpCS
	A==
X-Received: by 2002:a17:907:6eab:b0:c29:f5d8:9c78 with SMTP id
 a640c23a62f3a-c513aab17ebmr1287834866b.39.1795540418086; Tue, 24 Nov 2026
 09:13:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-9-jthoughton@google.com> <9487E341-5F59-4245-BE0E-EFDD413E45D2@linux.dev>
In-Reply-To: <9487E341-5F59-4245-BE0E-EFDD413E45D2@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 12:13:00 -0500
X-Gm-Features: Aa3M54p8XNdyqhw8NgJKcdhzlhzDFTnyhToFP0C3oUsuY3ie39XtBoe2DJRFnVg
Message-ID: <CADrL8HXPKfUhRaVhVyV6CPoQ2apZx1FCpyqyPMr=p=Q_kF3HBA@mail.gmail.com>
Subject: Re: [PATCH v3 08/19] hugetlb_vmemmap: Expose whether HVO is enabled
 to architecture code
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: nnjdepaip5ue6h9oaumbnd8p5tqc5oxx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 30087160015
X-Rspam-User:
X-HE-Tag: 1795540420-95261
X-HE-Meta: U2FsdGVkX1+7sOzhGU+hBX0XLavyM9aojdTn9sgXgF9HY2OkBqJjCdw73o31BITGtOPw5lK9/iYTgB+6BSpApF13Yi2hRxDpAlky55S+pcHdCIA0bK+YdYqJGjXZ+v05OzW1FEzyuVJSTgx4kOZdDJxp2zaQVxT6XAmwMYUDNl6DqOgHphKiGP8hihOmOTd+oiddPV+tB70NbFRaezjIEvggLa4Xxg79MRPUn49VUQiMfguniCYsWo7YxNm88Yqch/JRCFmAj0YzHBpo/PBl+7+SuCDuA6PdeE75QVPDOmp+u+ADL6jd8jkShFmVgsdx7UJicitSn6TuD4DSFkXQPi3oRRvu6XTf9nE1AoWnFbD8mwWBYFDB7ZjiyfpiV71gNgEyhu41vAX8BJUvRmdPMzeSmmDTIrV546Ypb5ZB/cIf+TiMbsXX8ihm7/jQiW5UJA17ff7mfUe0oFEUUO4Up8ZKfQb19L/JzgDSSqdoZd3lmqkfGwfaxEaxCbCNC+WTKOgz8gZE/x7gQkWMHW/x7i5DUXAtb9KZirHOtrWHycZbH3NsCVfVHTqVO2n02ceeSHbnMr2XnUK6TD4czdsfQSJ1euEbhsOje9kemFtRDZo/NxSO/6mBmI8UD8wd0kOZYMaiXFc1teN6Um8VGs/za0MsTP3aAbzNDCTjiZi0r/kT/aSM2i88oHCeX51TFuU1/Z0v4ql8VCPb/OV21Hfq09ShGKjmG1fYy3kRSq/FOfLUSB+kPQOj7weAcYvb9YL6jouFMG0WFbWkb/efoZ1v41f6No2226chMC9V8UCj/ZJzdtLlR1Y0UtZ/F8nJNUnfSb2DHorXzk5phdKvLUq34bXTGYvuhQudP7FVEdg9wT2hz9Hwd7PlTgzX+FVud6yIc46GhNCANTeMLDITlHvRYOGWcI9fBe+CLtMifBk8OYbFBKY5U60RiOIJB0NfI5B0IoPhJS5qwufKMdVijPO
 n3JBRUsw
 uCqUDu10ofmqOr0ni105QdTLSiVQrTCOnHbEP2P+PWqr89Bv3qDEFLcQBIS8MePsfmXqYK4P4xP+ORAGa9xHeBpBvnPVHHbrCid+9YuWYLTsAYD6oVQdklFZTJwnCQfQ4P5MDhFKbzKwTJ/OdodX8MAbYnCs/QdxbMMykm6MMJv0GD5O3V1CS3daTP0R5/ReVRwQBVDzjYb+nUyfWkm3MtQvFtXJu2p3YeMUsZsbex7eJe62bMFW6rbb3N7Ct7zoVnLpg1LLuUH1qxnSc9RebtfMjRQ2xT3vr2h2qqmFIUa8KTbsymaBeQRTkS/gzW3oI3Oqu+KRt3V7aCO8viNartGGxLNsB8173K3/BycpDm3R/AQ57qsF1Pmg4PuSvG2aGA+m/a4TDNS+8RDTQnQ7KvAq2Khpn+oVNgambWA3dUpyb5XG7fA28rt/qlECcIMid5OjnXty8xCbnl4zHmqNFozqp9p8IC2a9/KJwV99A+bJMKYgERPXzylw5rFMUlQ4mEp2BI8NbQsRCeM9aFuUkUygANZ9ouqvKL0Ae2ijj2xBz9diAPEFXcn65+tPFxys30VgIiSSGqmr6Dkk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 3:50=E2=80=AFAM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
> > On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> wrote=
:
> >
> > Architectures that select
> > CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO may configure the
> > system at boot depending on whether HVO is enabled, e.g. arm64 may
> > require all CPUs to support hardware access flag updates only if HVO is
> > enabled.
> >
> > Add hugetlb_vmemmap_optimize_enabled() so that they can check. It is
> > declared before <asm/hugetlb.h> is included, so that it can also be use=
d
> > from inline helpers there.
> >
> > It only reflects the hugetlb_free_vmemmap=3D kernel command line parame=
ter
> > (and the sysctl, when writable), not whether the architecture supports
> > HVO.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > include/linux/hugetlb.h |  9 +++++++++
> > mm/hugetlb_vmemmap.c    | 18 ++++++++++++++++++
> > 2 files changed, 27 insertions(+)
> >
> > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > index 0d5414392d87..b2a6441bcd84 100644
> > --- a/include/linux/hugetlb.h
> > +++ b/include/linux/hugetlb.h
> > @@ -22,6 +22,15 @@ struct node;
> >
> > void free_huge_folio(struct folio *folio);
> >
> > +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> > +bool hugetlb_vmemmap_optimize_enabled(void);
> > +#else
> > +static inline bool hugetlb_vmemmap_optimize_enabled(void)
> > +{
> > +     return false;
> > +}
> > +#endif
> > +
> > #ifdef CONFIG_HUGETLB_PAGE
> >
> > #include <linux/pagemap.h>
> > diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> > index 142f2975846b..fb6da64bd80d 100644
> > --- a/mm/hugetlb_vmemmap.c
> > +++ b/mm/hugetlb_vmemmap.c
> > @@ -452,6 +452,24 @@ static int __init hugetlb_vmemmap_optimize_param(c=
har *buf)
> > }
> > early_param("hugetlb_free_vmemmap", hugetlb_vmemmap_optimize_param);
> >
> > +/**
> > + * hugetlb_vmemmap_optimize_enabled - whether HVO is enabled
> > + *
> > + * This only reflects the hugetlb_free_vmemmap=3D kernel command line =
parameter
> > + * and the vm.hugetlb_optimize_vmemmap sysctl, not whether the archite=
cture
> > + * supports HVO (see arch_support_vmemmap_remap()).
> > + *
> > + * The value is final once early parameters have been parsed only if t=
he
> > + * architecture selects CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCT=
L_RO;
> > + * otherwise it may change at any time through the sysctl.
> > + *
> > + * Return: true if HVO is enabled.
> > + */
>
> I don't think hugetlb_vmemmap_optimize_enabled() has clear semantics.
>
> Its name suggests that it reports whether HVO is actually enabled and
> usable, but it only returns the policy bit set by Kconfig, the command
> line, or the sysctl. It may return true even when
> arch_support_vmemmap_remap() is false. This is particularly confusing
> because arm64 calls it while determining the capability on which
> arch_support_vmemmap_remap() itself depends. Therefore, the helper
> really reports whether HVO was requested, rather than whether it is
> enabled.

I agree, the name is misleading.

> Could we keep vmemmap_optimize_enabled private and let arm64 retain
> the boot-time setting locally instead? For example, arm64 can use a
> private hvo_enabled_at_boot variable with a
> core_param(hugetlb_free_vmemmap, ...) registration. The system
> capability is evaluated after core parameters have been parsed, and
> arm64 makes the HVO sysctl read-only, so the value remains stable for
> system capability and late CPU verification.
>
> What do you think?
>
> +static bool hvo_enabled_at_boot __ro_after_init =3D
> +       IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
> +core_param(hugetlb_free_vmemmap, hvo_enabled_at_boot, bool, 0);
> +
>  static bool has_bbm_through_af(const struct arm64_cpu_capabilities *caps=
, int scope)
>  {
>         /* The kernel only enables HW AF updates with CONFIG_ARM64_HW_AFD=
BM. */
> @@ -2055,7 +2059,8 @@ static bool has_bbm_through_af(const struct arm64_c=
pu_capabilities *caps, int sc
>          * BBM-through-AF is only needed for HVO. If HVO is not in use, d=
on't
>          * penalize systems with mismatched support.
>          */
> -       if (!hugetlb_vmemmap_optimize_enabled()) {
> +       if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) ||
> +           !hvo_enabled_at_boot) {
>                 /* Only valid if HVO cannot be enabled later via the sysc=
tl. */
>                 BUILD_BUG_ON(!IS_ENABLED(CONFIG_ARCH_HUGETLB_VMEMMAP_OPTI=
MIZATION_SYSCTL_RO));
>                 return false;
>

This is a good suggestion, but let me explain why I don't think we
should do this:

First of all, I'm changing the bbm_through_af capability from a
SYSTEM_FEATURE to an EARLY_LOCAL_CPU_FEATURE, which means that
has_bbm_through_af() will be evaluated before core_param()s are
parsed. I could change it back to a SYSTEM_FEATURE, but I would rather
not do that. (See [1]).

I also don't like duplicate parsing of the same command line argument.
I'm not sure if there is precedent for this, but I feel like it will
lead to confusion. (It is news to me that duplicate parsing like this
is valid, as long as they are not both core_param()? or
early_param()s, I think?)

It would be much easier just to rename
hugetlb_vmemmap_optimize_enabled() to
hugetlb_vmemmap_optimize_requested() and properly document what it
returns. Does that sound good to you?

[1] https://lore.kernel.org/linux-mm/CADrL8HUgo0zAHe7_eF1+hfTR6jBbZ=3DUKB1q=
PpMWpksvqbNHsyw@mail.gmail.com/

