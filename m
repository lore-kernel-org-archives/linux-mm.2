Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B35FCB61D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B086A6B0005; Fri,  6 Mar 2026 11:10:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6316B0089; Fri,  6 Mar 2026 11:10:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8116B0095; Fri,  6 Mar 2026 11:10:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 88C4E6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:10:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2861F1B82BC
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:10:08 +0000 (UTC)
X-FDA: 84516124896.11.9617FBB
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 16B361C0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:10:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=25Gf75qx;
	spf=pass (imf21.hostedemail.com: domain of stevensd@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=stevensd@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OviD/OI4D95bQB75mTtrv3mqGUkDVmB6ZVUb3tNHB8s=;
	b=KcgI/Z3aeRdCM14ueDE0aJTfK75a1preGgO5c2cjVHoAUeIe6U1KplpG6y6po6bPymFpDs
	ms1deAeLNbqrZu5wsMzwrGeQeS2ZXJ6B+h2f6sbT8aayeEx/1WawCSIvCQLhI8wT3p90DB
	mFr2x0OSrAudHV+QaSG3uu9a1pXJpf8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772813406; a=rsa-sha256;
	cv=pass;
	b=YBxSK28L7wQQv4zZS8Q/x/hTyQ7ZZEpS7HNnFx7OqnMrjHy7/IooqnFJbV3UiSnAbg1d96
	fp7KWidpVEg1EXdAdnrVyzFTLh375XAjBcHIlip9Ws855Y577/GM32t9bSVOqsZCDwD4OW
	8BSkulv3UcGWqmnd2o2iLoypPVdbfxg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=25Gf75qx;
	spf=pass (imf21.hostedemail.com: domain of stevensd@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=stevensd@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6614615fde6so10823a12.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 08:10:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772813404; cv=none;
        d=google.com; s=arc-20240605;
        b=fyriOf9nJ5PohGpYpv1jOlvsS+ZX0OKEWuJnaqFfR9Ismw5DmGcYIniD7fatqX7ON1
         XsE1mFkdjbA2Bnq8gtZD9xMxcUKeCtBhY19ixGccJjC5GfWtpVhXsHn8DC7PzBzp41FU
         +hF34BT4tRh77ZOUnNxa08uEOjuGca5pzCNQI0tT1BvpmKSG/UAc8CYD9Z9lt2vMnFU7
         qAdRQISvyMi17b6v3cAEyl6q6vTD+4X08iIoRV6IxpgyQ5T7pJ2w3pMRl4Pk1sBGC3UL
         IFESjcSPfOxDOEJNpBdhIYkO9PgSRHR0E4OzEulcaUVHpg89P2yYorPeb5/sEVJQy5pA
         YLgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OviD/OI4D95bQB75mTtrv3mqGUkDVmB6ZVUb3tNHB8s=;
        fh=rMve0PNWS+NomEY/Z/C4rVLOmXrrhvSgqKMYR9L1cRQ=;
        b=VhFuE8fkwHjei9SvMynuCS++03i4BgJ7QqrLocSKJZta+V9A4rOEB7qX0LsJCviQrQ
         Gajz9xeHLZ8GEnlUhUs/WFRxqZ1cYBBWR6zO22L/nR6pbj8GP1rd2ypPSzC8zD2SNN9W
         1KuXHpgFBlrDeo02qrGpEE83cCfTb0o6YkcUfw7i3nGVvihxq84Oq9Btch3SKvBBOVnc
         POnMTH/QkhIq8A+JKY3iqtGwvulHZYBLMddBQ8kqzUYDldZvGkU4XhcpeUmpLxcFz1T5
         BlVRXaCkKSIwacuTeQh8W8jqmeAYTdAOaO1FLCQVBaIJIpjR+zKUDIGiIQSZTavGBx9P
         44WA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772813404; x=1773418204; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OviD/OI4D95bQB75mTtrv3mqGUkDVmB6ZVUb3tNHB8s=;
        b=25Gf75qx4NHjESTdlDWzWRdOBgW/NrOedw8SkiHt04p5obSK2c6LAJlMWmlGAfESoD
         H0U/2XHH7qhsi6lFlup8ddUO3SARx+tzgbgGuO4K6ugImXxV2tv0xtMO6th/IFkqcfNA
         /BwLofJcb4HsVKLkJQ/eV6MyH2qYvC4qLb6IYUNyRsECfwrmqzEmz4It9jftEO6lXDa6
         1w1M/2SEFJA1D+P06prco1qfUPxVadd6vHybNQX7ddWDP50nmYJaJwTLjkxHDcNMWcXO
         hdGLtApEmoFVhI1a6M3EV83ksAGyrJj3Fvj5ndsfjYkKFS8m7CQ90Mol2+V/xjcoF6dA
         OsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772813404; x=1773418204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OviD/OI4D95bQB75mTtrv3mqGUkDVmB6ZVUb3tNHB8s=;
        b=ohICnASazvjc5mWbGEugBHRiFcReVM8AjZlaM3APwGyWUV8yDqMXPRX1u4YIGG2J/I
         MXYiCiouuSO/VePaMJsu4p/nxQcR02l0VBqM+7kbtQOVw7bVDUT640Oh3OWiLP8elSRt
         HorlgkjJpNld0mY6oIubPVpSgof1hu7G4lIN59EIVkT7rbVw2IYTTMqkD/GZs6dzohpz
         mt7TnPu/wQXRfLdj3cYiaMt60Q3E/X2uUQMMepOLUdCP1IzVvC/1fi7B0xqLI/p+/Glf
         22weDT9eiKg7EdEoBBGXh2z2759MWM8k8JNpqsc9u7jFKG0RLePH1I0SEdleo+xlBy5A
         dn2g==
X-Forwarded-Encrypted: i=1; AJvYcCVXqsWL9JMm22o4AUTeMjio1nVdTzm+Fo3zamqHQhvZCJMKpjwAr0/2C1efrNn6UhDeSVtn+MFhgg==@kvack.org
X-Gm-Message-State: AOJu0YzR8qfy90GeBNr5h14UNL8IvX8VEXKWoWTfKsiCzsWpP0evMaiR
	YYBlymxRBfRP1hdXXemOtUotyiZlmP6oUA/gifE+88Uda2aIqI4PU7Wu+/zbV3SFuB62lXo3/5i
	SvTmOygH0+G7xykqbcTze9D5A1alOksxDghxvcaAQ
X-Gm-Gg: ATEYQzza+8pBlJvvslsOrFoCxP/pEdYnBDcvL2T7B2dOvzhmlxmLK31oapVprg9UmUI
	o+cVQSXd7Z6pX5F3FxRrm7eGp7A0DkAXISrqKWyiWjtgXh0k2pOh2kVBu+K5jJgGJOJcGO9Y3UX
	XkKUaKR0smN7sE0oyq44H+u9kFcCn1pseJelYexleI6U5qK0+joW4/NpVhwltGGSovuhrDriMtc
	hN+Ie1tPce9NbxiY/nnzHRhs7Dw4sBjHmz69AcsFhxYgTaXF6spzPoQ+pLoUOgqMwo/9XsDXrGA
	Q4o1YvjL/qJP8udG1G80s8e2/5Rr6aneCLQSsA==
X-Received: by 2002:a05:6402:26c3:b0:65f:76c8:b92f with SMTP id
 4fb4d7f45d1cf-6618d6c3a4cmr24305a12.0.1772813403800; Fri, 06 Mar 2026
 08:10:03 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <20260227033013.94901-1-21cnbao@gmail.com> <CAMgjq7CDgap5pe_xVemow+SbaRW+ERXZBZvkymhFWZQZdDM2Kw@mail.gmail.com>
 <CAGsJ_4ypfGxp5vbNaOt2i2qDmy9tCJuemDjMjwWr6hSv2RtYVA@mail.gmail.com>
 <aam5nOyXs1sNdjTe@google.com> <CAGsJ_4zLippMEwD0q3YwDVsBV6_5dvX56mXRGa90ujzi5WQMbQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zLippMEwD0q3YwDVsBV6_5dvX56mXRGa90ujzi5WQMbQ@mail.gmail.com>
From: David Stevens <stevensd@google.com>
Date: Fri, 6 Mar 2026 08:09:52 -0800
X-Gm-Features: AaiRm51AYoJTbeA6L-c81cAl_g8g7bIAziXYgZ8mENkJ50GuFCiXgE1DuhCypHs
Message-ID: <CAOiLmNEz7sNPEeGgrk1WYN-9EeWq5n2PSCuv+ZscdJ0CpA5SrQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF] Improving MGLRU
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, David Rientjes <rientjes@google.com>, axelrasmussen@google.com, 
	linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16B361C0005
X-Stat-Signature: j4fdgb534316joh6zmeoj9j8s33dgzi3
X-HE-Tag: 1772813405-517234
X-HE-Meta: U2FsdGVkX1/f+8nbtzueeToTSHGOWqZrIxf/7JIcVFCsMmHzpKp/M3c9ZhOaUXA+Na837DmvwekQkYog9FiR6VuWcK+Pv+pNbmQKeZST72tPw2+B1AdA8796lVCZ/wz4gWd8TX6msBaMs/ZvZHc6kMSoA1UbKee/2Ep8lxsx+uRP9e75KLALCHrFoTjwHI0FljVqlvUkk/AiesXmQTt35StliVdrWUAlV15Ns6/V162HYqQHPpNBu9EwMyau7F38+kjpLVO0LKWG8xLIvfRFpr5rBOJbAR79dJXlJQ35g9HsrYilf7BxVIdwOkE/zvPbcvPez4yEXHUOL6/MsMgwZ8+e6H8Whk6bMa8lk4OwHFLAdTEGtkYYjKiVgEHYCnR0NiA91B/KlyyQ84yYvDzzPZdHq3OUrBoR5M3wxwalShaabo++kN5oj8isttzPSfqii9nLHrw2XSPBj2NknFI+eNcxu4CikjnuWgk0WJEU5JFg3/1gcNv07ZR35PwB4Yf//tQdmlyGR9/McixJoptEfwNKhmgqLV/S2C+IIVG8LXOUyxNFsM7dvTp1KJftzZp0oxvBRaQxNgAa2GMJkT04YQhjiteoQ9+zxTCKP5isarMsRc2Nc2qjrBKns0Cxq7BxMXL+QoYreQq7e7LIoUcP22+JRv75wHkvtMsyXe1Pk5T6friO+KPFm1Qa6wkQ3QZYazkdqt4gik/F7UzSkEOUVJf88ygvxyQJwXJ+lZdqRyZf6kOYggXoLLvuIWhvnDfZOAmaMZ2aIdgZPiwx8bT6uHibW6PtAarFNFQxH+TW1stt73WqRwbrw68gnMRQIS3F1EKPRadA5MHCKdb302PavolZ1gHiriL+xq4P7h/xpoawpf9IghDulEizgZSAXESmKBKKStRIL4vD0S6YCmusmyn181o+Mns4Q/kq3Z29kWHx8PWPwhj4gmjvtHmXouEtxHdVPihCi9TCYNq6+P1
 jGpFWTae
 CKMOTBa6eaYfHZYyvwPreF98ONzoiuMRS71Qu6QPbdgzfV9l/Uhdaa/iKMI1EsRZw04ToWKfLLb90XsLE/Pa4VC8Arbx4Hoxa0z33aOd4Jz/AlejYaEesGkqR3nV/FEtTy31VTKeqXhk5U4yuGSSWJfZGBBlrq0w9bdGxzDXpTFDMEezq2LNQwKRO4o7TUH9wRpfWEJ2/xC4nxA4emAXjhlQxNT+F+LSRBwBzEi46qNjz/Gsm9V8fozi93IYlgiMDQo4cHyNFiEI+U4/wXS6o2pCNPgsa+frfJEJQ+q3JhAGvR2HImkyKlGudy7ACnZw7aeNByfHQwdkgStudUoPkeSO7kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 5, 2026 at 3:41=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Fri, Mar 6, 2026 at 1:13=E2=80=AFAM David Stevens <stevensd@google.com=
> wrote:
> >
> > On Tue, Mar 03, 2026 at 12:06:20PM +0800, Barry Song wrote:
> > > On Mon, Mar 2, 2026 at 7:10=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > > > On Fri, Feb 27, 2026 at 11:30=E2=80=AFAM Barry Song <21cnbao@gmail.=
com> wrote:
> > > > We have an internal workaround for forces aging, and waits for sync
> > > > aging if one type of folios are not reclaimable (without the wait, =
we
> > > > still hit the MIN_NR_GEN protect again since aging is not finished)=
.
> > > > And without the MIN_NR_GEN protection we might end up over reclaimi=
ng
> > > > without aging.
> > >
> > > I see your point=E2=80=94I did exactly the same thing in Android.
> > > However, there=E2=80=99s a significant problem. If anon has two
> > > generations and files have four, they end up sharing
> > > generations. To age anon, we would also need to move file
> > > folios between generations; otherwise, the hottest and
> > > oldest generations would overlap, causing cold/hot
> > > inversion. Furthermore, in inc_min_seq(), moving folios
> > > means the oldest generation gets pushed into the second-
> > > oldest generation:
> > >
> > > new_gen =3D folio_inc_gen(lruvec, folio, false);
> > > list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> > >
> > > This is far from ideal, as it still mixes cold and hot pages
> > > to some extent. Could we keep anon and file generations
> > > separate instead? I feel this is a strong requirement and
> > > likely the first step toward making swappiness work properly.
> >
> > I did some experiments with splitting anon and file generations on
> > ChromeOS a bit over a year ago and got fairly positive results. Althoug=
h
> > shifting personal and team priorities unfortunately prevented me from
> > finishing the project. It didn't get to the point where I was confident
> > enough in it to send it upstream, but I think it's still worthwhile to
> > mention here.
> >
> > For a bit of background, due to a combination of low-spec hardware and =
a
> > complicated file system structure, many Chromebooks have poor file I/O
> > performance. We found that a fairly significant contributor to jank was
> > important threads being blocked on .text faults. We tried adjusting
> > swappiness but found that MGLRU was unresponsive to such tuning.
> > Splitting anon and file into seperate generations and then setting a
> > fairly high swappiness value resulted in meaningful jank reductions,
> > especially under very high memory pressure. However, there were
> > regressions to some workloads that I did not get a chance to try to
> > address.
> >
> > If anyone is interested in seeing the code, it is here [1] in ChromeOS'=
s
> > 6.1 kernel. I also have a WIP series posted to Android's 6.12 GKI kerne=
l
> > [2], but it hasn't been merged there. This version fixes some issues in
> > my original series that were exposed by runing on a very different
> > system, in particular around memcgs. However, it hasn't been tested as
> > extensively.
>
> Nice! Thanks! Do you still plan to continue working on this and
> submit it upstream?

I would like to get back to it sometime this year, but I'm not sure
when/if I'll have time. I've moved from ChromeOS to Android, where
file I/O seems less problematic for various reasons. So while I think
we could still benefit from the changes to some degree, I have other
priorities at the moment. Sorry for the lack of clarity.

-David

> > [1] https://chromium.googlesource.com/chromiumos/third_party/kernel/+lo=
g/929932351492d01f0aee37a0ac3be8c7bd88f80d
> > [2] https://android.googlesource.com/kernel/common/+log/49cd20cfb0da236=
1be064f7fd70b36867065277a

