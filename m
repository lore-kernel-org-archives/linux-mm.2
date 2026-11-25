Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA80D606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Q+G9a22j
Received: by kanga.kvack.org (Postfix)
	id 1643A6B0A77; Wed, 25 Nov 2026 11:26:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C616B0A79; Wed, 25 Nov 2026 11:26:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051EB6B0A7A; Wed, 25 Nov 2026 11:26:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D80CD6B0A77
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:26:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E5F9160EF8
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:26:53 +0000 (UTC)
X-FDA: 85474170306.05.06D132F
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7BA8B180007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:26:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Q+G9a22j;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795624011;
	b=ouiX+06dG85n0by94aX8x2tJzOwAisAAFyjzj+/9fu3An62tkl8LLGC8htsbYEgdHOyWzJ
	zKLP6QtzZGGqlk8WRvzSnmq7NxTutJwQzNP+4HhhfM7r3OQne9ViOylw6Tjg8H6lElQhcU
	fC+sROTY0KhgIbzpSoe15xwPcMYCGQ8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795624011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGPDDNK/Yei0sGWbDO0NMhfYUHaLt6AdHTFPFf4Fgzk=;
	b=6jL95IzcR/fqjEcyD7OlbnC1EnW06nPgT5iWt93a/Kt+7dL1zXpDaKIuflyuNilKOkx+WU
	7+y3q9eyDpe4gcg50MVLLpO6LVxyqp3qiEyAXo1g58C65QeONTtHwCTV1ql0kSIFA4/gr0
	VNdnxdc8jCG3ZI/snzhYYNlDJGGriy4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Q+G9a22j;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jthoughton@google.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c513a854320so114076066b.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:26:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795624010; cv=none;
        d=google.com; s=arc-20260327;
        b=XXHEMXZnoAFYd1YEAmRqUJ9eMHMk+Erxaeqv0W02HHYSCa2QkMUZpe0CsQDnzeW+T7
         KKEtaJSyDRJwtPAqcD0gjUki5OT8zo+Q8qbyp1T11+pb+ctJ4Njl9pzRBoKnkiDU6AfD
         j91HEQik6XbV/oMJBy60aMWTwNHC2FF/vnvuFx3kRRPxw1JVqvL987/h3uKEX++ACYBq
         pwIXf7NwROvoaAxAPAJDjiVEiW6p1H0zOa0yLcrVtjxfwYz7cfT5+SollwyNDlCaf98D
         ipYAR4vYEgmEiDHVnbW3WacnAWx5QNhy8P1b5AM2PojgwEezTJG49YtHSVyALWs7u/g3
         lJpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eGPDDNK/Yei0sGWbDO0NMhfYUHaLt6AdHTFPFf4Fgzk=;
        fh=E64bWR9iOnqnupCuBvcp2tcmi7OB5Wdb7/f4m1S86ZM=;
        b=cgZgZatip7k+XO3Wa6wQpkouaYiA+Gj3Io8PTkRznS69VhHlmkiKmOSU4uZiAJ6FTB
         yBAuHnXI4YPk0SKm3glHP/0eS48fv2cJrUeX3S7TZtFKeNh3gMg2C319LSX5b50XjF3q
         Sz3OVOLt3+bt+4a+BhHwwp7FVcAD+/TwDDQEzaGTKQ5VDpe1iJyfCqI8d4Co1nIOwRdf
         vJJUzINp+FCMAcv+AdZMGbgoavgkpzSnSPakPkUJ3aGS14gy58MvCYDLd0x0W9+pArzD
         KYbOMnKN6dbaXh1abhCuxbGz2i4DkLqtQYVA8PRQNt/CUejvTTZ3KHAWtboTzzhhnKdm
         QHfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795624010; x=1796228810; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eGPDDNK/Yei0sGWbDO0NMhfYUHaLt6AdHTFPFf4Fgzk=;
        b=Q+G9a22jHo9muG0TMhADoGOTBuTn9VoyJO+BgJ9rpS1s3G1lQmdQSuyun3tgd07reg
         RYMv6piyH7FW9QHsLiw0bC1oDcm7OGwwbA/BWi7RrkKVlIDNCw9jTqmM6xujM2jkgFC5
         6XvYfvqfB3xtBgVfOaEivkPDMcQhs2ZmdgjfCPp1CLl6zFKb1zEqjEYZcYRHvBvTnVu/
         cgHq1DpbaB0mubboXNtIEwVOXA9ZOOODr89FbmyLnqz0CirnQiaF+j0/Q4VZmmaL8Tni
         KNVpMIC3hlPK9wscDzAGTh6mMCzb9++TILK/aBlvKMg6jqEhD3pXix9n81krAMyD7rBz
         8lAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795624010; x=1796228810;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eGPDDNK/Yei0sGWbDO0NMhfYUHaLt6AdHTFPFf4Fgzk=;
        b=nhLb1hNJR081aad7ydu++NkwoZrXNVhAZ3m/nL+Uto8xEmItsKNyUXx3Pwrgo4hx5y
         5y7HzzZNBlzQCGWrVgX4wx5z0s3i4Jypoo0nDdqaz1tJp9sS21UQoddcXkkYVhmziDVM
         CZK/+bykZpT3gHAHWsb2caF+fYBkGpxUEXhDql+IGk1hQKylYSPVTKx9z5eQSraO90WK
         T1obtyV9i+74rIfT2qWF6vTYminJbk4K5f4LTRpdYVQVp/fF2Fh5RJYeVN3Mibcxza/m
         gUvsGSE1qYtH8udPjRh7i5hMbQnGm+Wm81Su5ZW7B0aG7zZ4qrNEZlawU1samTYxyKlS
         uQCA==
X-Forwarded-Encrypted: i=1; AL+hErG+OWN7loZpJlQ6F/dLMZWSYgd6p3lZogP2kSr9Z8t/ZNG/cZfbLPSqe/L9evpz8SOjoIqycCH0YQ==@kvack.org
X-Gm-Message-State: APuU4Z+ivww5x0gZqcWE/JqrjeC90tj/2H8uBxT1U6F6GlvaoHV8vALc
	o8ja9b7jAYIrOxUB73XuBgoT1YjhFnJBKk3sRQrzoh2MCRO/0GIezQaR339ow9FyiUy8/l+szgV
	esOi7t/6kRKWeOW4cUj6wmVvnov2sldaFxMChvMz4
X-Gm-Gg: AZFdTZexWRiEQ9yN8X5Ol5KAxvJduhGhiWKLEKIw08tjhfVa3TNkuBTU484TiboxXXO
	YR3F1wJyw7GG1taWsvWlxgKCMFwJdgQ+1rE0y4FqhYlsB4LQFAbofuE4wN6giQ+EbwTrGqiuwtL
	wAA2cxvhZrvggI8prxAH4AgOFshxa+17CDJ+CkrMI7QbEIHd86jB/eDpOe6uGmx2PyJfVbeOK/z
	iKtE2F0ygJfIVIULgd3mtm0cymDaKUX8ACsHdVaInk1w/6oLqzwxvK//4LGI42j9U24xzHEnEh2
	+6qETgMaSHpCdAH1KAM7VEfrKuMmVIy+aqYNTpb79IywGZwkKNzqyTemwKL6zMRT5wBb3op8tlP
	0LN2sZZ97y7+VabVobca5YYXgswZjwhAVbDLX5ZKFV6qwpCOPI7kJImEkj6UgHLWv8xR5bB5Epy
	IdqGQp6plAVY56R2w4a0cZ8Yx/EA46kZBLjwdyZaMxyzbUwqWxak0=
X-Received: by 2002:a17:906:3713:b0:c50:4d71:a85d with SMTP id
 a640c23a62f3a-c513aac5448mr1166580166b.32.1795624009440; Wed, 25 Nov 2026
 08:26:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-9-jthoughton@google.com> <9487E341-5F59-4245-BE0E-EFDD413E45D2@linux.dev>
 <CADrL8HXPKfUhRaVhVyV6CPoQ2apZx1FCpyqyPMr=p=Q_kF3HBA@mail.gmail.com> <0EFB24F3-D3F2-4B28-9684-68CCCC1E80B8@linux.dev>
In-Reply-To: <0EFB24F3-D3F2-4B28-9684-68CCCC1E80B8@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Wed, 25 Nov 2026 11:26:12 -0500
X-Gm-Features: Aa3M54qAHiURLXighOGPx7-HKZ5MkmT19-dDBj6zUM_QZzKzc5QW8DO7KfwSRns
Message-ID: <CADrL8HXM6Or4_7LM+D0XP9++4eENFt0J4ssShuXQxcmX8mAkoA@mail.gmail.com>
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
X-Stat-Signature: j7tbxq5fz67j7wq179rjfotchpszcou3
X-Rspamd-Queue-Id: 7BA8B180007
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795624011-798586
X-HE-Meta: U2FsdGVkX19EmlaXcWU2P0gRV9i6aHGnKUJd/pwJPz0TWkit14UyfgwpYq8T+FoP+XQlcyFxx5IIquvvUUu6VQvlR/gf+D2KSEH9KQYTxw0UKQMKYbnPZNimYTr1k2g3V1jTCE3yyeAFxwrqGo12N3MNyS4VmlRfmyo2SAWtrziFM13KUnVe8BZ4g1qvg9rCeontOvttqNbZ6PqxjsbPsC583F+sV7evx1iFFJot7N+ozVO+VbsCqvbkhXwoHlaSajutsZ6CXWZEdIzRE5iS+bX8/JQ713dmjfsNvDOaGMnct4t0div1jtpDhptUMiKLw1oSfoJNvrbpRA9xcGRWAAEPdOQADCGVd6DPpleqEa4Fkj8HczH/1OHs+zn/AGSPDk4CbwxVRGORQLfU/kmZAQeURlW7v1OqHspHNEy8FeusqZOoR4L3nuFYdPmBoVsS8kXhHLYwKvOZK/v0svx9iFFww0CXvty2547y+xHMVUQ66iYxrVoEU/Lz8Dg/E/nGkakqHU+4hEUNDe7gJUWFoGuecaioCWAr/6k1l0Ke2vprcLIswdHwveW1cHHsBPCkIk9HFLKdBfV2haFPoz3FRuCM0FgTBT/z5nHd+rEdL4iC7ir4uYjYYdsobM6fGfGSPfwZQKsY1LayDRa5ghNg0QYM7ry+azG8hv8olS5q4rLNsmt1OeyhGbJ2aquElA81WhK+MSWsjdEmrYVw3wsZGqLu8TOm+GpgyEkhUHYjTNqVCvLO0T/jgaVOInpenPga4YcTJSecL3wnSpW7Yt1JptL0vWiwd31ba8WEg8cKcQ4OdfdskBbw5aGm3ZKJ5QrOdQS3eQzsZcXrLmcH40hwVeBgRBRwYoZAbJlFzkQGQspQhvrw7mi66V7Pn4TsbRiSRz5Yyy8Zw30dArqlusis7cLL8Iy1r1e1TqA17MsqjIXuIK10welK0JEFdr94x6xq8qIYBA5gG6gSkc/Fmqf
 IOzxgtdS
 hLYH5gjAVpeINn6wkSpVXOwgXlhdAGCcfD7WA6ZnHvhtKJ3MXRq1pt1em9RYxmvfyWUeM2IBQVvf4m9T5k5VHG/nLi61Hgqk4jAJfWpsqgT2LDUuQTTuIcp/KTkpfn28M5Woa/1Ay/tFcmpkGW2tEL8XJZ4JB5sT+44XKYIc06D70WNcbGIlJLYSoYNmNq/szlkRk6HhmoZwkH4t+L4l/wWmiT3uKIr1qwLzIuVC18kXRN0uhkhM9wVNTsAoxiUYljNtotILzxDDceu06zofIuQsE9qQcTJX0ScKGOCH8yRvXow6Dv1Nz2+2V/G9xxyW9QBbYtk8LUA6ggwovWCj5sGwGqYiM5KW+5gCoKGqkBGkALLhtyaMb0z6mbrohNJcoAqMf9RT742HtIl95p1/R1uXK+Hpl1CW/QFuv7+GVhit9umoq+hRlb16hZluWJBRVl7jIxEchCGQbn9QJ2aofnLqeKI9GYB8DkD9AXwZTpqGsj1DuBz1UO8B3KI/kptfFBXGqx93bYGuA4p3K+x1RHGMCu9PCk27bGr44K48Kzo3ctU5nhpxz8Lh2lFoMa2tty/4YeJUxgo2HrRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 6:24=E2=80=AFAM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Nov 25, 2026, at 01:13, James Houghton <jthoughton@google.com> wrote=
:
> >
> > On Mon, Nov 23, 2026 at 3:50=E2=80=AFAM Muchun Song <muchun.song@linux.=
dev> wrote:
> >>
> >>> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> wro=
te:
> >>> +/**
> >>> + * hugetlb_vmemmap_optimize_enabled - whether HVO is enabled
> >>> + *
> >>> + * This only reflects the hugetlb_free_vmemmap=3D kernel command lin=
e parameter
> >>> + * and the vm.hugetlb_optimize_vmemmap sysctl, not whether the archi=
tecture
> >>> + * supports HVO (see arch_support_vmemmap_remap()).
> >>> + *
> >>> + * The value is final once early parameters have been parsed only if=
 the
> >>> + * architecture selects CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYS=
CTL_RO;
> >>> + * otherwise it may change at any time through the sysctl.
> >>> + *
> >>> + * Return: true if HVO is enabled.
> >>> + */
> >>
> >> I don't think hugetlb_vmemmap_optimize_enabled() has clear semantics.
> >>
> >> Its name suggests that it reports whether HVO is actually enabled and
> >> usable, but it only returns the policy bit set by Kconfig, the command
> >> line, or the sysctl. It may return true even when
> >> arch_support_vmemmap_remap() is false. This is particularly confusing
> >> because arm64 calls it while determining the capability on which
> >> arch_support_vmemmap_remap() itself depends. Therefore, the helper
> >> really reports whether HVO was requested, rather than whether it is
> >> enabled.
> >
> > I agree, the name is misleading.
> >
> >> Could we keep vmemmap_optimize_enabled private and let arm64 retain
> >> the boot-time setting locally instead? For example, arm64 can use a
> >> private hvo_enabled_at_boot variable with a
> >> core_param(hugetlb_free_vmemmap, ...) registration. The system
> >> capability is evaluated after core parameters have been parsed, and
> >> arm64 makes the HVO sysctl read-only, so the value remains stable for
> >> system capability and late CPU verification.
> >>
> >> What do you think?
> >>
> >> +static bool hvo_enabled_at_boot __ro_after_init =3D
> >> +       IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
> >> +core_param(hugetlb_free_vmemmap, hvo_enabled_at_boot, bool, 0);
> >> +
> >> static bool has_bbm_through_af(const struct arm64_cpu_capabilities *ca=
ps, int scope)
> >> {
> >>        /* The kernel only enables HW AF updates with CONFIG_ARM64_HW_A=
FDBM. */
> >> @@ -2055,7 +2059,8 @@ static bool has_bbm_through_af(const struct arm6=
4_cpu_capabilities *caps, int sc
> >>         * BBM-through-AF is only needed for HVO. If HVO is not in use,=
 don't
> >>         * penalize systems with mismatched support.
> >>         */
> >> -       if (!hugetlb_vmemmap_optimize_enabled()) {
> >> +       if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) ||
> >> +           !hvo_enabled_at_boot) {
> >>                /* Only valid if HVO cannot be enabled later via the sy=
sctl. */
> >>                BUILD_BUG_ON(!IS_ENABLED(CONFIG_ARCH_HUGETLB_VMEMMAP_OP=
TIMIZATION_SYSCTL_RO));
> >>                return false;
> >>
> >
> > This is a good suggestion, but let me explain why I don't think we
> > should do this:
> >
> > First of all, I'm changing the bbm_through_af capability from a
> > SYSTEM_FEATURE to an EARLY_LOCAL_CPU_FEATURE, which means that
> > has_bbm_through_af() will be evaluated before core_param()s are
> > parsed. I could change it back to a SYSTEM_FEATURE, but I would rather
> > not do that. (See [1]).
>
> Actually you can use early_param.

You're right that they won't conflict (today I learned).

> >
> > I also don't like duplicate parsing of the same command line argument.
> > I'm not sure if there is precedent for this, but I feel like it will
> > lead to confusion. (It is news to me that duplicate parsing like this
> > is valid, as long as they are not both core_param()? or
> > early_param()s, I think?)
>
> I checked the command-line parsing paths, and having more than one
> handler observe the same command-line option is supported. In
> particular, it is not restricted to handlers of different types.
>
> do_early_param() walks the entire .init.setup table and invokes every
> matching early_param() entry; it does not stop after the first match.
> There are several existing examples:
>
> - "kfence.sample_interval=3D" is parsed early by the arm64 and powerpc
>   MM code and is parsed again by the generic KFENCE module_param_cb().
>
> - "pci=3D" is registered with early_param() in both
>   arch/x86/kernel/acpi/boot.c and drivers/pci/pci.c.
>
> - "console=3D" is handled by an early_param() in
>   drivers/tty/serial/earlycon.c and by __setup() in
>   kernel/printk/printk.c.
>
> I agree that duplicate parsing should be used carefully, but these
> handlers would not be competing to own the same state. The generic HVO
> code does not need to expose its internal policy state solely for arm64
> capability detection. Arm64 only needs a local snapshot of whether HVO
> was requested at boot in order to decide whether the BBM-through-AF CPU
> capability is needed.

How HVO is requested could change in the future, right? Like if a new
command line option is added, for example. I (strongly) feel like it's
better to provide arm64 a way to properly determine if HVO has been
requested, rather than parsing the "hugetlb_free_vmemmap" option
itself and trying to keep mm and arm64's parsing logic in sync. Even
today, although the parsing logic is simple, duplicating is really not
ideal.

I feel like Will and Catalin will be opposed to having
`early_param(hugetlb_free_vmemmap)` in arm64 code, too.

Also, doing it this way, if an invalid value is set, we would see
"Malformed early option" twice instead of just once.

So let's just add that helper to expose whether or not HVO was
requested; I don't see anything wrong with that. Do you agree with
that?


>
>
> >
> > It would be much easier just to rename
> > hugetlb_vmemmap_optimize_enabled() to
> > hugetlb_vmemmap_optimize_requested() and properly document what it
> > returns. Does that sound good to you?
> >
> > [1] https://lore.kernel.org/linux-mm/CADrL8HUgo0zAHe7_eF1+hfTR6jBbZ=3DU=
KB1qPpMWpksvqbNHsyw@mail.gmail.com/
>
>

