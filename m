Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D01C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 12:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985DB6B009A; Tue, 22 Jul 2025 08:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95DDC6B00A4; Tue, 22 Jul 2025 08:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8734D6B00A9; Tue, 22 Jul 2025 08:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 761006B009A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:02:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B0701A03D4
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:02:55 +0000 (UTC)
X-FDA: 83691764310.29.FAC603F
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1F90F1C0019
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:02:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k3RQnAFg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753185773; a=rsa-sha256;
	cv=none;
	b=qxHkkNkdfuzEmYz4wWQxstY/KI5aFMDVphId6SQe6fPZi3xDU3sSvJL0U5GBAyd7o06EPv
	scGuzMu3kWuouNWX4qpQDy0uSOW79inZdeDpfKYpUEz4H7nhai/KLvwGfKex6E/kE1boVy
	2Us77EU2+yvYAyMQzbEsT4+r4xD+lRE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k3RQnAFg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753185773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1Rbb//LGn2cX1HNOw7Ni4d+CUv/1OLBW6Hdjf2INnY=;
	b=CqA9uXVMBYJHjQbPJw/WClnqTI7K/JlzBsrYlrzG1EDnge+MWzF+X4OzkBFCSw8u6jaF3o
	xNtvZxuHq4sgI+Y4SnODihlC61e0GmO7Pv7Hi8t2vKiyA0rzM3aYnfgXafJwsvctpUocCl
	d5BHDLUdB4OjSxHNif3H/stMZLGSP7s=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-7048d8fec46so65435756d6.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753185772; x=1753790572; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O1Rbb//LGn2cX1HNOw7Ni4d+CUv/1OLBW6Hdjf2INnY=;
        b=k3RQnAFgiwyshhVvLtRXOQRsEi9PyAp5L/LeK1fjKqhCkKi4ezbCkBJkmA687el4NS
         /0acNaUw5DM8Ms3NtLO4CaryQ5a6cl213pHt4WaGzy0uUVkXEyjxcS75u5Zcmm+sWkvt
         4wBpoqkRSoEcXhuDcWBMvNWR8jiA3HAI2MGhc5GBDC9nP+kXMmhkVuAWYDUmCnzQKxK5
         Cqk+y+3ttivsJf2YbryY0Gt/LglQiQzmBp2z1cEPsqcCNjd3KDni+rvnI9XjityE8uL2
         vnjK1Q7oJZhEsKuGl9U0VoZpAaME4BYBgC88i4m+x5UQezf3uLKjMIkwOk9a/qIjS7bP
         2ZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753185772; x=1753790572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O1Rbb//LGn2cX1HNOw7Ni4d+CUv/1OLBW6Hdjf2INnY=;
        b=D7qwhFkme/NqQnkiZ7lesT8YgAMYf000O2104fNgr5TGcXFidac8rKOzdAiI7l7GLh
         SeGoS/jpuYNoFkJgbf9Sstf91wzAZR4MGxuX4D+EUV3/ozTNSUUnnPEURIbpbCiopQY0
         +CAWjDoCQ6W06E9GJGB1RMrgqiMHTEhZt2pTRZWE0sNDYyeTYclX38oGqfqSgkny5eGP
         I8/CoJkmiSILHnQGeeH4Ksg7wuN5U1ObUenlzWMZ1x0BqVQBujZxVxw3vGrxtDdNx0Bk
         kTUyUZ/pL9GNJqJucO7FqPxmuGZYcPTWc0l2j1rYwKGk1Xxs1DtEa66OB+53ocVQISx2
         8mmg==
X-Forwarded-Encrypted: i=1; AJvYcCXqK4wDemCbHmVYMXcs2QkOISdngZtvPxycGAkQue63uqS+lL3DFOp5gwQTCiMPax6IvzEj5RSdiA==@kvack.org
X-Gm-Message-State: AOJu0Yz6gBbPo/sznkiKc7T3lQ8zX6ClmqnHLokAu2QnwahacOiIDvKv
	BHO7AoOzFK3Zm1PJ5pDuJu+P+mprdyBUMzuuB8gfkedjrdikbw7whEXSJAX9XQtK0VHbMqqSqsx
	8vII6RQ5zkA4ys01ik2Gf0viH7x8ht60=
X-Gm-Gg: ASbGncs/dEKA9h70SjNiQLSk41HGv2W4kyUSd6ChHKEbMbPoyLilFkKosh2nKJeBhD2
	B+qxYOT/tmGrRV7hVYItOieVe0Dd9B2IeYMy3/TD13oZuS6Qc/VbSBEnfDFXpMfce+rpGK90qS2
	ZikdJaKoYyW28snJ4GyzxWdIlGR1WMQuZAmj0qBZMXhW03YI0ek8BD7HJleUr9L3xDbloYoVzWt
	9t2LCX59NjWQZ+bztE=
X-Google-Smtp-Source: AGHT+IELaEEUYF8vstdB4TA+iN1z2ZG+kTtjGdNOa7umJ/+UeqcV9yaPQ0nvlDd0by7NCY+z8+9pZoO2w5qFPmAcYms=
X-Received: by 2002:a05:6214:4ecf:b0:706:f190:f2ec with SMTP id
 6a1803df08f44-706f1910739mr21320536d6.19.1753185771886; Tue, 22 Jul 2025
 05:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250608073516.22415-1-laoar.shao@gmail.com> <b2fc85fb-1c7b-40ab-922b-9351114aa994@redhat.com>
 <CALOAHbD2-f5CRXJy6wpXuCC5P9gqqsbVbjBzgAF4e+PqWv0xNg@mail.gmail.com>
 <9bc57721-5287-416c-aa30-46932d605f63@redhat.com> <CALOAHbBoZpAartkb-HEwxJZ90Zgn+u6G4fCC0_Wq-shKqnb6iQ@mail.gmail.com>
 <87a54cdb-1e13-4f6f-9603-14fb1210ae8a@redhat.com> <CALOAHbA5NUHXPs+DbQWaKUfMeMWY3SLCxHWK_dda9K1Orqi=WA@mail.gmail.com>
 <404de270-6d00-4bb7-b84b-ae3b1be1dba8@redhat.com> <CALOAHbDMxVe6Q1iadqDnxrXaMbh8OG7rFTg0G7R8nP+BKZ9v6g@mail.gmail.com>
 <fa81148d-75ac-490d-bca3-8b441f2afe1c@lucifer.local>
In-Reply-To: <fa81148d-75ac-490d-bca3-8b441f2afe1c@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 22 Jul 2025 20:02:15 +0800
X-Gm-Features: Ac12FXwCTK8hUlqlY1CJV3ls2pACth6o10Ozmv4Oz4rZ3NeP-gCWHkv0sd3AtHo
Message-ID: <CALOAHbAkR_A48r6Y_vikAgcifnK9cBhgAc5t=jdi0jTN695m-A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] mm, bpf: BPF based THP adjustment
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F90F1C0019
X-Stat-Signature: nheoxbq6594twzwqyh34jjahuxotm9cj
X-HE-Tag: 1753185772-516913
X-HE-Meta: U2FsdGVkX18pK3Pc4iH+hnH6X/OOpLzWRc1/Dj0+krHWrVVhbdAwV6NhWCrDffo7opWLvkBZit/LkU06Hfxrv2nPAE3aOSBHMQcuQN/avn1q5Z8k+IXFZfG9TsvrLJI88Kqwn86zgrQtw0t37z1GUE3Xr1PomTlFmFnQ6dSFC8gUPr23xJ5Sgw1dNhNAqxwPj0mZ6ZaOqaGUksbA3fMoqp2e2FVsUbPz7SIX0YWGS/eaCTJ6P4OHY+1Bo1acm0wn+CLwiLLTBASJh7jnyPQPDoC1AgkYd8d2GOQ1ZmQI9d7YOMhU5P31LnHir8l13CwugkRyE2gFKYkb+wYWtOgoy+Fyi8z8v7O2Smlkhnx1+YFIul6Br29oCm1AneFrhYFF58d2gK19q52A+fnsCs95EP96i2Fs4TsxLOzG0RqA0f69wVobuIYpuC7ekJofopbPavVHkzO1fvxOIVQHa1cdqXUe6cVXEZnYwIflqEXOMySVIdxVqJf5FpDLAJPLKKKaJ3PDQ9l5bP3qLCL3AGEsjysZITMXJ+SUzQo6q1eEsusCoHf28rp8cFr5xgjnSScTfFazMmg0HmFIn9pXWvqDdq61vUgYtaxgztBEPjg8jDpKSqHO/Fb7+qf5hPxTRQ4MLlM6igLAMx4XT7hVBasG19v4ptCmGOhdjTJHpVQks8iPF2cWxZTr11R/fY8dm42QwpBDq83nMfS9X+ewp/ywLE50Slw4vaVEJe5FgEytTZyvzmYS06a/7NXUJaFXGnE8AmtJlKxaOlyF6nEmQXAklXH3Hj+OnSJeOjgi3FsqI9Ij6wtowyxr6Qsj9bpoBmRvGW6a4oXmejdImqqR5Li0l9hVsyEoQ8SHuxeZuD0yGHe2BRlEiBRxW7uSkG8KOnjXSI8N3MgAHXgBn4bhDubyaqDeCSOfH9dqOe6QJWIY3egzYMcnQPdXLALeMnWkFN7vm/z+p+C8rsCzHJ1uZ9d
 on7+vZo6
 SThWRKXB20g4Tk/i7fYGwEKXF3Bv1KKgOlC+enKeoA2EADAp6h75QVpttoBh4ikiyXDOmUNKp9a3t3lLIwqRAhaWzOqTwSLvVh0bKyFhEHDZ+xFoqGdFKDA3/wPj5bABuuQvKNnagUKathzbYJYZeSHXAoR/C05WPpwDgRv2eoC/C/bjFhE4WeLPADla7hvvT3Co/5knm9JI06u48jMKowti1f/Ngdl71fRpVAAolQXVzqlUBfsDphrTFmdXTkiDXtnhRKp03VcvuXKRwzg17SuAg0ENNzUouJr8gdkPYLhGsSfQqI3x1jvFPui6KfJ/iqM7hf7Dw10HoSCHOY4eW3AoZHntO+tOikCWehqlf/1NuHwqgx/9i5q4ZDrO8iuZsrjo/eWXHVlXbDwvK9nrxnj5FFXcOAEjCtwH4XyjVMX8medXo7dOL7PkDrNyPDFEftCt+C3HqdmPlMRVTs5rehRJXavZecLx7RQDZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 7:55=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Jul 22, 2025 at 07:46:57PM +0800, Yafang Shao wrote:
> > > So for these kfuncs I want a clear way of expressing "whatever the
> > > kfuncs doc says, this here is completely unstable even if widely used=
"
> >
> > This statement does not conflict with the BPF kfuncs documentation, as
> > it explicitly states:
> > "This means they can be thought of as similar to EXPORT_SYMBOL_GPL,
> > and can therefore be modified or removed by a maintainer of the
> > subsystem they're defined in when deemed necessary."
>
> Except that's not how EXPORT_SYMBOL_GPL() works at all, we can remove at
> will and are only required to update in-kernel users.
>
> So that comparison is simply bogus.
>
> >
> > There is no question that subsystem maintainers have the authority to
> > remove kfuncs. However, the reason I raised the issue of removing
>
> Except the documentation that seems to very strongly suggest otherwise?
>
> > widely used kfuncs is to highlight the recommended practice:
> > - First mark the kfunc as KF_DEPRECATED.
> > - Remove it in the next development cycle.
>
> This seems reasonable, but I'm not in the slightest confident in us just
> relying on this.
>
> >
> > While this is not a strict requirement=E2=80=94maintainers can remove k=
funcs
> > immediately without deprecation=E2=80=94following this guideline helps =
avoid
> > unnecessary disruptions for users.
>
> The documentation doesn't state this, you are surely just inferring it?

As noted in the other thread, the maintainers ultimately have final
say on this matter. I'm simply sharing my perspective here.

>
> >
> > --
> > Regards
> > Yafang
>
> Overall I think we need a different mechanism in addition to this, such a=
s
> a very clearly described CONFIG_ option that makes it ABUNDANTLY clear th=
at
> the config and thus the related BPF hook may be removed at any time.
>
> Ideally with 'experimental' or such in the name, or perhaps even tainting
> the kernel.

Agreed.

>
> We definitely need something better than what this documentation is sayin=
g,
> sorry. I am not in any way confident in relying no what this document
> states.

The documentation has always been difficult to understand ;-)

--=20
Regards
Yafang

