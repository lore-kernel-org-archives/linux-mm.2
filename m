Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8291FCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA5E8E0015; Mon,  1 Sep 2025 06:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43C18E000F; Mon,  1 Sep 2025 06:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B858E0015; Mon,  1 Sep 2025 06:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8AA38E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:20:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C1DE1407A9
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:20:22 +0000 (UTC)
X-FDA: 83840286684.19.A410398
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id F264CC0004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:20:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RChKPN91;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756722020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YyqGpmFOP1CozESKRlIhwf69hgCDF5ny5+BECrJEMtA=;
	b=GSH1xfyxT2g2gzXFsCmCsUy0FI8DaR9dA6t8FOVmKTbbGGhdEP1iyWC62KMZjIKJxZX7gQ
	/7AjYEEl/PXxQtbUmWHan+ZsufuBopiffXVh96JN7akY8jajaPVIPourVDccBbv9Gk9A4A
	MwZVD+rMG7bU6K4JBLdwe1x2tHcq0oI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RChKPN91;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756722020; a=rsa-sha256;
	cv=none;
	b=mwRxHHw5h1DhDgYkSYVBvE6m7RO3G0Cn0zev/30Ses8ZI+sHQ3nxZgmo+Wb1I6oDy+Jz35
	9uZbqqxYdSHsFYefCQtrcGlE8VxMTm12BDZfF3kSgYJmXgTh13JdmINeKJ5iTXpHi0CkxO
	Fqxh97WAsEmFBln65aOcuNwCqmDDXMo=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b042cc397dcso96206166b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756722018; x=1757326818; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YyqGpmFOP1CozESKRlIhwf69hgCDF5ny5+BECrJEMtA=;
        b=RChKPN91OqrtnQyH0RyL9vETsh3S1Xj+Dx7VsKLZEOXMg8ZpfYUglb0hFJUCf2AFbl
         KQecbJpjdpBSMx3f3ltXAMKXXRD0X9GhFkgVoMAsU/gq9zvENeUeRguU1DJmplIekfd0
         jW0iSg1aUjDt50b0lZugPOu18P6u81l6Qbu+IdUqB7KhlHdusDnf5zTljgEa+nTUvTmN
         A04jsCu9yNEgsStsUlyoPB/IJWOXJnnZvERstK3vrgsfZecwTMofOL8EIuHzk5a7xYSD
         ikp9Tw3EJWXd8TEvgrEqbLppMj9JLb19q3nLBoF0H8iQWilCDt5+2UD6lgoVMQL+L+mb
         Yj7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756722018; x=1757326818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YyqGpmFOP1CozESKRlIhwf69hgCDF5ny5+BECrJEMtA=;
        b=rPQI3GrXno9GfqoM580m/BE+ELaZ+hUsO8AeTyYmozuQFEBt1X9Ua2yjUBmIQLvxWV
         uBKFDI2bxpVUMhyIcIiDphIii0RtPH1VBisHG4K630iw49f7YuYcleZ3LE+cM0je36N9
         ZZMf3bWV9sFizqJbakRE3uaNvZKLg4M2YRI1xWpYSuGxJx8F9zkuMET2jHb8tS4qJHlG
         vrxdf3IDFkVg8IMnY1anVI7a4ebX1Etqx6w7KlI6Snmn7HpF6XPSxSugBCFBbaSLKdcn
         m3UaScrMcm0hpeAl2c80ba87RV6GfOnZqShPGZ+qfp7DVuJOncTEHA3vm7SlhKwYNtfK
         2qzA==
X-Forwarded-Encrypted: i=1; AJvYcCVWZxPaL0GzjrDcXlhK9wcxSQtd4rfEb1q3kkBlM+vzVySGUiR4n+hKydn8KImDPzFSAnyxxw5Glg==@kvack.org
X-Gm-Message-State: AOJu0YwZkB5vkPJxIIj9gdvpxM0IsdoGRLvN44iJ1+J0GjuzI3fLsS6J
	YcIQtv9KgnnVogK+qsBAdX6wCaaCX3nHm8T/W6gqLbbm52PvyC35ZJxA62ioKou15hpTLgUbFTt
	cy8BgRQ+ucd+ws+FItqebHNV2jWZmHPwc2v1HMinyhA==
X-Gm-Gg: ASbGncu49Nk61hZAagVXur3UL4EUQbU6hnn54OZbj/GSqcP2LnsiQ1hcAbqrz9aEfc2
	rz9ydmmGDJF4W5H3dzuIzQLBYC0nJxamWTNStEEJC5raGtc+EZ9VpGin3T22CbIgdcVVNnbbwe3
	NHmDZu4cYe/vBKujnJBuLCg7+HIY7/8ErQWupB88yUAAGTKrR2LSdzeJ48cd8GBoLUBsvE4IclD
	RPEYduZaEW0XlCcomLerd3K647IVnIDwq/2IMw7UO5G0Q==
X-Google-Smtp-Source: AGHT+IHRKz+wtDfHjdv0i5A+vm9diAzSXKsWI+GdPRTMwnCU9IQk+aGQJmcC+iBCuiF2MB/L2hTHURmHYAPvlQUwTmg=
X-Received: by 2002:a17:907:1c9f:b0:afd:d62f:aa4a with SMTP id
 a640c23a62f3a-b010817fdf5mr709865766b.9.1756722018168; Mon, 01 Sep 2025
 03:20:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
 <f065d6ae-c7a7-4b43-9a7d-47b35adf944e@lucifer.local> <CAKPOu+9smVnEyiRo=gibtpq7opF80s5XiX=B8+fxEBV7v3-Gyw@mail.gmail.com>
 <76348dd5-3edf-46fc-a531-b577aad1c850@lucifer.local>
In-Reply-To: <76348dd5-3edf-46fc-a531-b577aad1c850@lucifer.local>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 12:20:06 +0200
X-Gm-Features: Ac12FXxSSqkbs-4UPdELMOg7slq5QVAQH_82ZObPwU_IOehvXv6qgw0xhHiTSTM
Message-ID: <CAKPOu+-cWED5_KF0BecqxVGKJFWZciJFENxxBSOA+-Ki_4i9zQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] mm: establish const-correctness for pointer parameters
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com, 
	linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, deller@gmx.de, 
	agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, 
	davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com, 
	luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net, 
	jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	weixugc@google.com, baolin.wang@linux.alibaba.com, rientjes@google.com, 
	shakeel.butt@linux.dev, thuth@redhat.com, broonie@kernel.org, 
	osalvador@suse.de, jfalempe@redhat.com, mpe@ellerman.id.au, 
	nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, conduct@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F264CC0004
X-Stat-Signature: 3ubycsf4hioday3echexy1mctu1sqy3r
X-Rspam-User: 
X-HE-Tag: 1756722019-5494
X-HE-Meta: U2FsdGVkX1+XzS+JTHIKj2ZF0lYcZzANZtlRoH7zvB//llDapdoSIhPo0nHyudzt1dqDKhK2bKh8ayAaJTTdVFH77fSLYfN6hJQZ9CZ0amxJjbPEz2dR/vZyFk5Wps6mu5d0uTp6V0GaTEzCy6blmeTnIyhL1/QBgHnAep7ULnBVfPCUgC64pf5lodvvWCbFWvy2h9fSWyJHZ3BwztY435Ao7u2ceQFoGYbyAm+xOCvfdqNr05CuvGBSVHZ29CV/gteunIlg4HfNhLZbWDFnRElcMzCdgQjZ3c9wwTjteIUkoJOCAaI0ZgbvAUUwMXF1LCIpURJFk51aluCR7FIFn1Eb6VqvNHjb1axpFeZCQAvyS7Cw0cFxmumc9OtDjkw9uS5cNrVOnumX4AU7T4KG+KvGHHKZnr+BTtm0MqMhbyGKNnZ39ujdeS1meHpclGWXLkM091KAqOrk/SPGog90ncxir/3Ir/XyqP34XzlP1YMjO4CcHtk4dXLG9rcELcevYmW+/ABq9R9ockA0u3tgiaw/ztDqOYKhjL1G8FMUn/HwH3eIWO+5Wo1S4EzDpAbOdmEbTQBugiTW2L7u/v2oVRJmc/cBG+Erj0OS6nVLDO8OwZdErOJFFb1rvlOiNYe9D7paY/FWLwVf2EOEaygHLjboAcjbAfJEr32OQZx3+l5zLmWSv3rm3M+ze6Iar0VNzcTRVu6NjgpldkjB6L1hyBGCw4dlRff7SgrsBXwa7iOY/iE3a6XygoMlNmyxBO9Ki8UInw/tiWC2sIyXkGFbMiKf1YyyBlTnsMl9qB1Gp6MPYR06H+gvcMt2CcIm4S1Z1UIlTaGCXWwTEZi2/+42PfAB16yOK4Aqqud1k9kZPcNpYl6oobl22CRdr0hIgyIXVnNUym/yRPACbxzcBkqgXkx6Aw2ybaRElnpC9tUS5l8dXttW2AMLMnqfd417h/feRppWY6Q6m47lfXlv8rV
 Gx2s5ubz
 cQ0xMOn7TO5t3PiQ2nDo/q84xUoltW0mhhxQ33wPEzNOxhomLl3lpBcdga5LTuDVzJc1nrXLTooMoA7G8DBhjnsYf5Z13Kz8phMEKvbo2WMNSvhJB1DVPeMKvtqm/3P61zluWIM3/NoPw5gy449kDBNIPOBwPa5rSMxRYi0GQ0gbC0vJycgixeru8aEMLGw7l1TSGck8wu6CXrTwGFvQCIpBuC5Rd5/bDM/G1j+w9GI4FJawl1Zq1lNvpRIRlJtWF5zWHD2ldgyPjZiZbV8npGiyY5So+JKFglnfDWA3g/JjQNAagqLZHzKzSQzNpCHeSusxNTVI976yW4Kw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 12:04=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> +cc CoC.
>
> On Mon, Sep 01, 2025 at 11:54:18AM +0200, Max Kellermann wrote:
> > On Mon, Sep 1, 2025 at 11:44=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > You are purposefully engaging in malicious compliance here, this isn'=
t how
> > > things work.
> >
> > This accusation of yours is NOT:
> > - Using welcoming and inclusive language
> > - Being respectful of differing viewpoints and experiences
> > - Showing empathy towards other community members
> >
> > This is also not constructive criticism. It's just a personal attack.
>
> It is absolutely none of these things, you admitted yourself you thought =
the
> review was stupid and you used an LLM to adhere to it, clearly with bad f=
aith
> itnent.

There must be a huge misunderstanding somewhere. I and you guys must
be talking in a completely different language. None of that is true
from my perspective.

I never called any review stupid, nor did I admit that. I disagreed,
but that's not the same thing. Remember when I told you "Let's agree
to disagree"? It's perfectly fine to have different opinions. Please
don't mix that up.

> >
> > (I'm also still waiting for your reply to
> > https://lore.kernel.org/lkml/CAKPOu+8esz_C=3D-m1+-Uip3ynbLm1geutJc7ip56=
mNJTOpm0BPA@mail.gmail.com/
> > )
>
> Your behaviour there was appalling and clearly a personal attack.

It was not. Maybe you felt that way, but I did not intend you to feel
that way. I would like to find out why you felt that way (because I
don't have the slightest clue), that's why I asked, and why I'm
waiting for your reply. If you would reply, maybe we could clear
things up and resolve the misunderstanding.

It sounds like I won't ever have the chance to do that, so... farewell.

