Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECCDC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 11:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841D18E0002; Tue, 22 Jul 2025 07:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819C18E0001; Tue, 22 Jul 2025 07:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FC68E0002; Tue, 22 Jul 2025 07:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 601C48E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:57:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1127D16037A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:57:02 +0000 (UTC)
X-FDA: 83691749484.01.00DB826
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 31D5C1C000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:57:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UJjL97C0;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753185420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAu9Q3wdTUMBywT15N41N2ULwt+qnhp1KmLYaWOMhuA=;
	b=hOI+EMMhLVg1YxqlL8jbZ1JOXkEFGh21ohQ6Np3zg0MxNf5yfMrvwdXyAUqmUs1k6G10oj
	18rL6MLQIo51wm3Po3/P7vZ8MN6b/Dy5tIjUw3aAy0nxZ4I+gTHy44EcR5fqsQuAsPkHI6
	MjUa/AFBJK+tnQdOq1KNJSVsQZ7IISk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753185420; a=rsa-sha256;
	cv=none;
	b=NS48PVcqfmOvnolPyOD9aXwD4Lr1Ak6P0pa4O404e7Hcx8lJQIwrjWhZeZnRceauMwekpi
	EUrQ5hxzjJ5piYYPbCcf0LMR76XYY2m/ettLHxv2XA6XppVLKqoyzNR4iNXfKlt3nkOy7Q
	FugeH9qEU+ruYxk09MD40wjZqoHXirI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UJjL97C0;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6face367320so48865906d6.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753185419; x=1753790219; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AAu9Q3wdTUMBywT15N41N2ULwt+qnhp1KmLYaWOMhuA=;
        b=UJjL97C0iRSjGHggzowceGD3aKY88218tMoM6vj8d8YbZtMeGd39TjvpLSK89c3jjl
         QdOP7dzopSu9LlKtc4lhyRC+LlGZ3Av4s/Oss5jv9ftEOS1Yj2LTqr1GI+5ae47/OiE3
         4ddaN0K784lV39SuhKJuDK0InzdNcsGdJPltrYgZM1eDh/X1SY6+OWgWE12thG1++a5J
         Osh/rVsyYn5TOuywVWAnS8GwpH5e4hKEUrbZAhIw3OA5RCUcU9i5TSDBhDDmZ1NCAljN
         1mCSKHqgfmPjH7jse/JInSqYJ/o/B+yy6tDRMg/EdqSnvGIk5yblw3FXfJMZTRunAXdP
         04dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753185419; x=1753790219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AAu9Q3wdTUMBywT15N41N2ULwt+qnhp1KmLYaWOMhuA=;
        b=pnUgoeGsXuJgJ3rB43nAs/ba6x7UuylqBImDpwIUfzjjGv69PghBU1JHF3v13yGUa/
         ll8F3325bbDkgYbwPNP6sW/EQ8k2cVR2+ew/THwUG9RRe+ulAJm9g2iuLvtCa5mv+7vO
         A7EBg/SwBMnS/EqwcRZGKSN9mxAZ7452jjPKZQAJPjimI/dP3JkJzGwrQYxsfvPmVXy9
         OdxFphxuMXT4bjMuZHCV0ublgqWXsb6G9PxbXq5uT7OPtqGGuG0At7a9Is+jcN7roFHL
         E5yeVdcRG5bqkcki8273SQpW2pADQ78Zdl841A/pW8u/SGSxAjwh+3U27oF82Uqio9Zf
         Bixg==
X-Forwarded-Encrypted: i=1; AJvYcCVGGDRiX5Un6xLMYn11GS2gRF4FQd5NnpYWGX8J39NCekp+TmyWIs4+P4YcIJAvQAPn1BW5dtmgew==@kvack.org
X-Gm-Message-State: AOJu0YyHhtKO/Ch0FRx+wVwIcA2vystytHT/VKcLz2QHL+hXq/V752Yr
	dmb9WitStXrYXoL0WtZSi/3DQH2hdM38sy1KVVO7nrE9nH4xWbkGsSP10/WHeQM4sW/AL2oZ5pe
	DkJ7MSV8fdlDGOVGtw8IVTvzEVn4D34g=
X-Gm-Gg: ASbGncs2qaCVpfD3GFIp2V2rZl8OxAC6ibxBKeWWILMRKyS2pOXC8QuteAkQrCLOpa+
	9DBYIlskh4R3AEL90DdaxeAo3M99NeOjSykyI4v0FmOFX+HRbeOcuYqZySyg4ZjOjT+ReEj+vZx
	2S8vsDzGT0seXMNJOH/EdCWkGoSnRE1yv7oyCWJCJtqhVMseMx5RSIi3fD+xDdwMwKFNW2PRg3O
	a+8VOjh
X-Google-Smtp-Source: AGHT+IHJkX0tXmqzM7+ePtwcoHIsUI3/e7shZ1FCZbZHP0xnvUBMfX/0AXFYcMQ8BXDM5FivUtTXdMqyf13qk+kjtHI=
X-Received: by 2002:a05:6214:3d98:b0:704:8d2e:bc63 with SMTP id
 6a1803df08f44-704f6af81e4mr398867896d6.35.1753185418981; Tue, 22 Jul 2025
 04:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250608073516.22415-1-laoar.shao@gmail.com> <b2fc85fb-1c7b-40ab-922b-9351114aa994@redhat.com>
 <CALOAHbD2-f5CRXJy6wpXuCC5P9gqqsbVbjBzgAF4e+PqWv0xNg@mail.gmail.com>
 <9bc57721-5287-416c-aa30-46932d605f63@redhat.com> <CALOAHbBoZpAartkb-HEwxJZ90Zgn+u6G4fCC0_Wq-shKqnb6iQ@mail.gmail.com>
 <87a54cdb-1e13-4f6f-9603-14fb1210ae8a@redhat.com> <CALOAHbA5NUHXPs+DbQWaKUfMeMWY3SLCxHWK_dda9K1Orqi=WA@mail.gmail.com>
 <404de270-6d00-4bb7-b84b-ae3b1be1dba8@redhat.com> <694a8b10-6082-44ac-8239-2c28b4ba8640@lucifer.local>
In-Reply-To: <694a8b10-6082-44ac-8239-2c28b4ba8640@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 22 Jul 2025 19:56:21 +0800
X-Gm-Features: Ac12FXw2969e8azvBtKqR8zs1YTd32pScqkTTtjLEbs3cKDdUPFnp1oztJog2k8
Message-ID: <CALOAHbBepZiORN2yLvDDQWbvom38HHvCyqAqvS7uKzQqy8zgjg@mail.gmail.com>
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
X-Rspamd-Queue-Id: 31D5C1C000B
X-Stat-Signature: 6n43w1bfnkk8oeae3ymncjdjnzoxpaai
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753185420-864753
X-HE-Meta: U2FsdGVkX1+hjj/KcQ8v8WJt1Uxvl2jYuD/D/M9+SDIkI79qHjyAwWqgAGPcM9BufbX3Z+89AgCTMXp8EZnz+fzf95NuFfgxgW0+ySSO5Qt4Ejm+h9G+uiOiobzsoXVE9/qcCdcTw2DWAVLEHnR7FOaL1Z0qV5nLlhUpRJjoE0v11HbhriR242ZcmXD957R0XC+jmctIlgkwC0gpNes4jyPHTY2IfsWZGKh5nnSbrxAV9nqq++0TztDRPvpAfC/e5R/GpgxkWTaxp7j0i+E0UdQHz7T7piVTGi098x1g/+t+KJ2WcHfg3H6kvdJat0nhoLsyyhZ1HbHKkmLOoHBX+Cf9HogiOASRrl6ArK3T+rRy+YLrJMuRcFb095kSPbhpcQlwIeLJS7RJuI0t3WZyPQr4UFiWkO7PpOR2upCQIiLgkuAgO5IIdZbcb2Q752hTh3+zEvXpXS+tmvpS2UQjBD0/VK/EthldqINpaqGt/3B1nAiVpkB8gGAOrIocEG+lGNg/4RplsXgS7M5ewBZgfFN/gSuZwl1SlXYoJ7JiXYkvuJJcI+ZVByhAmJ8U9pHp7fQl2pIWeWuIGUy5lrNF/LY2gJebVgzPffy3gfqVrETyI57CFKtzyWtJuWJA7rcHoFhYg0u3MFG1hEhgIKbz9CacDCQVdY9RS7j2M0nVIBHxEZy6+irnUyEtFfmK91VDvLLpWU11+iPVNeCbyYTASk+Fg8fNd8E59zMjZF/0mroPnLM4mb4kuyoxPRtkHUvkDU+9w5pai6TdL8zT11EB72XvsJ1t3gmL1JBuIJIoxgN1SjrzepkIgrfg9F2nxzxLPA+lBkfhUNZJlsJizDt0ReF9/39/NV0U+sFSpIvbu8Ck4u++x+2nm0mFUPgfNeMjOUzht8nxWF5d+kY1Qs8nEAwHQPjebdoODt8WHLliRTmOhD5B7ymHe7tmVdRBf32uix3n/YZOB5jWaag0P7u
 BaXfRYTT
 3EE7WklMSOj0iAI5yCJHPpXYVRZnOI7uvI0F9tErTWXsSdjqJR3HVQirb4ptpMgQ3RBSElGjyPTkcBzZHzho89s5LkT4ovNNS2rGL18Zkj5wv2huXyGIC51gPsH4EUUEfohPcxoJQXFbOE1b1p5MmsbVceXU0xN47ytytIRxuoVxBzOu3lQHZoL8c4xgPwqQznlI44JC800I/7MldKJbLLnoyPhlZ+oWRK+YCdFLiUvK6ZKAj5Vj57x6W4vknzEge3bvmGqbwkQuh6szhV2HBDI56+ihZOS/2dP/ypRdu1TQGfSHfeElpQ3yjcvVl/DPAM2fg/zZ8KBWtCZfH42iEAvPm5Aq+U7SFFWObFkf3eGM5mwhq4IWfeK8CRF5o2nZmQzoW67i+oSha95eiSQKDlDzmDFEETEuCEo4af0rOvfHXQ88NuQRPwau0a1NjzG60jv+RlR+O2WfRwWy7TQn4VZoiM93XoMLURywlOLyVIebKXdFnpKTOylxzfqcwlXHQpYh7FQiyHWl85ks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 6:09=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Jul 22, 2025 at 09:28:02AM +0200, David Hildenbrand wrote:
> > On 22.07.25 04:40, Yafang Shao wrote:
> > > On Sun, Jul 20, 2025 at 11:56=E2=80=AFPM David Hildenbrand <david@red=
hat.com> wrote:
> > > >
> > > > > >
> > > > > > We discussed this yesterday at a THP upstream meeting, and what=
 we
> > > > > > should look into is:
> > > > > >
> > > > > > (1) Having a callback like
> > > > > >
> > > > > > unsigned int (*get_suggested_order)(.., bool in_pagefault);
> > > > >
> > > > > This interface meets our needs precisely, enabling allocation ord=
ers
> > > > > of either 0 or 9 as required by our workloads.
>
> That's great to hear, and to be clear my views align with David on this -=
 I
> feel like having a _carefully chosen_ BPF interface could be valuable her=
e,
> especially in the short to medium term where it will allow us to more
> rapidly iterate on an automated [m]THP mechanism.
>
> I think one key question here is - do we want to retain a _permanent_ BPF
> hook here?
>
> In any cae, for the first experiments with this we absolutely _must_ be
> able to express that this is going away, NO, not based on whether it's
> widely used, it IS going away.

If this BPF kfunc provides clear user value with minimal maintenance
overhead, what would be the rationale for removing it? That said, if
you and David both agree it should be deprecated, I won't object -
though I'd suggest following the standard deprecation process.

>
> > > > >
> > > > > >
> > > > > > Where we can provide some information about the fault (vma
> > > > > > size/flags/anon_name), and whether we are in the page fault (or=
 in
> > > > > > khugepaged).
> > > > > >
> > > > > > Maybe we want a bitmap of orders to try (fallback), not sure ye=
t.
> > > > > >
> > > > > > (2) Having some way to tag these callbacks as "this is absolute=
ly
> > > > > > unstable for now and can be changed as we please.".
> > > > >
> > > > > BPF has already helped us complete this, so we don=E2=80=99t need=
 to implement
> > > > > this restriction.
> > > > > Note that all BPF kfuncs (including struct_ops) are currently uns=
table
> > > > > and may change in the future.
> > > >   > > Alexei, could you confirm this understanding?
> > > >
> > > > Every MM person I talked to about this was like "as soon as it's
> > > > actively used out there (e.g., a distro supports it), there is no w=
ay
> > > > you can easily change these callbacks ever again - it will just sil=
ently
> > > > become stable."
> > > >
> > > > That is actually the biggest concern from the MM side: being stuck =
with
> > > > an interface that was promised to be "unstable" but suddenly it's
> > > > not-so-unstable anymore, and we have to support something that is v=
ery
> > > > likely to be changed in the future.
> > > >
> > > > Which guarantees do we have in the regard?
> > > >
> > > > How can we make it clear to anybody using this specific interface t=
hat
> > > > "if you depend on this being stable, you should learn how to read a=
nd
> > > > you are to blame, not the MM people" ?
> > >
> > > As explained in the kernel document [0]:
> > >
> > > kfuncs provide a kernel <-> kernel API, and thus are not bound by any
> > > of the strict stability restrictions associated with kernel <-> user
> > > UAPIs. This means they can be thought of as similar to
> > > EXPORT_SYMBOL_GPL, and can therefore be modified or removed by a
> > > maintainer of the subsystem they=E2=80=99re defined in when it=E2=80=
=99s deemed
> > > necessary.
>
> I find this documentation super contradictory. I'm sorry but you can't
> have:
>
> "...can therefore be modified or removed by a maintainer of the subsystem
>  they=E2=80=99re defined in when it=E2=80=99s deemed necessary."
>
> And:
>
> "kfuncs that are widely used or have been in the kernel for a long time
> will be more difficult to justify being changed or removed by a
> maintainer."
>
> At the same time. Let alone:
>
> "A kfunc will never have any hard stability guarantees. BPF APIs cannot a=
nd
> will not ever hard-block a change in the kernel purely for stability
> reasons"
>
> Make your mind up!!
>
> I mean the EXPORT_SYMBOL_GPL() example isn't accurate AT ALL - we can
> _absolutely_ change or remove those _at will_ as we don't care about
> external modules.
>
> Really this seems to be saying, in not so many words, that this is
> basically a kAPI and you can't change it.
>
> So this strictly violates what we need here.

The maintainers have the authority to make the final determination ;-)
>
>
> > >
> > > [0] https://docs.kernel.org/bpf/kfuncs.html#bpf-kfunc-lifecycle-expec=
tations
> > >
> > > That said, users of BPF kfuncs should treat them as inherently
> > > unstable and take responsibility for verifying their compatibility
> > > when switching kernel versions. However, this does not imply that BPF
> > > kfuncs can be modified arbitrarily.
> > >
> > > For widely adopted kfuncs that deliver substantial value, changes
> > > should be made cautiously=E2=80=94preferably through backward-compati=
ble
> > > extensions to ensure continued functionality across new kernel
> > > versions. Removal should only be considered in exceptional cases, suc=
h
> > > as:
> > > - Severe, unfixable issues within the kernel
> > > - Maintenance burdens that block new features or critical improvement=
s.
> >
> > And that is exactly what we are worried about.
> >
> > You don't know beforehand whether something will be "widely adopted".
> >
> > Even if there is the "A kfunc will never have any hard stability
> > guarantees." in there.
> >
> > The concerning bit is:
> >
> > "kfuncs that are widely used or have been in the kernel for a long time=
 will
> > be more difficult to justify being changed or removed by a maintainer. =
"
> >
> > Just no. Not going to happen for the kfuncs we know upfront (like here)=
 will
> > stand in our way in the future at some point and *will* be changed one =
way
> > or another.
>
> Yes, and the EXPORT*() example is plain wrong in that document.
>
> >
> >
> > So for these kfuncs I want a clear way of expressing "whatever the kfun=
cs
> > doc says, this here is completely unstable even if widely used"
>
> I wonder if we can use a CONFIG_xxx and put this behind that, which
> specifically says 'WE WILL REMOVE THIS'
> CONFIG_EXPERIMENTAL_DO_NOT_USE_THP_THINGY :P

That's a reasonable suggestion. We could implement this function under
CONFIG_EXPERIMENTAL to mark it as experimental infrastructure.

--=20
Regards
Yafang

