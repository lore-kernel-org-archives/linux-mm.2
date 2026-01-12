Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED3CCC9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498D76B008C; Mon, 12 Jan 2026 09:59:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446C66B0092; Mon, 12 Jan 2026 09:59:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3455C6B0093; Mon, 12 Jan 2026 09:59:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22F846B008C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:59:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E854558EB7
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:59:02 +0000 (UTC)
X-FDA: 84323619324.27.565C125
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 00C3B1C0010
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:59:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fqm0aVoO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of smostafa@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768229941; a=rsa-sha256;
	cv=pass;
	b=kIL0HiVmxWt7QMq+tAdZTLQHWOLFUGpg+E+r7u+US1eDtvEGwIMY6o1xioZnfBXKL3jUu7
	bM7OgaBEWaUvRnzf/sPyD4nQNFmxehaJo/mewGUF4Jzv2BvAN/BpK990v/rkVI6ylCMomC
	C2m+rIkWqJ5tGHn1Xk5ZKiLIDI19zKY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fqm0aVoO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of smostafa@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768229941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0BwYHjTUF+pt60n8KoAD4GQEYtMlx4yMjCYbWj7SaI=;
	b=OycmSj8xd5MAB5plniFItxAh0N1ZTGveyLPLXELIx7l3pi9bV23WOdWWk4ide6v4bNuJ41
	yfRsKQjMUQKov6sGM0TOpfdcr3W8v1T+FUW9zs+kBRhY7KvjRMyVhP/NPfhn4B8m+pmMsd
	1uBML6YmdLGH7iOxy/BsroaVSPs4UC4=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee243b98caso918981cf.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:59:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768229940; cv=none;
        d=google.com; s=arc-20240605;
        b=idc05U9YDqRoPB5385kCdamMKiOt1ji6t1jsz6WhZvbSrqKj86acEDwGxlfL0LHVUi
         50bs991cyG+iQ/PEVZ5t6xoU6mzYr6MV8skhaQMfwfP/bREeotFyWY992A8U70NBA31J
         i/61RIFol+iEVrlEefNJJ9cvsbZu169noe8WqIJ6M1Ryo3lZVcA3bjukuEaono3JOFNY
         iD4OZ9sPHTuyMUwRGE2qb5k7cqYs+iSrXQ49F6AQN77U+156WCIGm70wIGJVEgLc71pI
         NnqrRWZZiNb/69JfbDQ1EaSyEJKQm43iqFXT4M3/o0yYjch6z/KtPmwRA/w8VXHr+5t2
         kmAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s0BwYHjTUF+pt60n8KoAD4GQEYtMlx4yMjCYbWj7SaI=;
        fh=gmy3vim+lyLQAZHW0CtXh7r3TBmX5Emig2GMVX6Hyb8=;
        b=QDhN8KSksac3Akbccfezdq/DifUkcvijnfEfE0HJHBfGn3pqhWMUdSvpdpEe/sG2WH
         ZQNazoAyhIGUCswv+6Qp+BjLFSn46rOcGTN9jRB1rnoD5sDJ3zPHWt8oK52JHGU1QDQs
         SzDMb3QM9EqDdB0Xdilo6YkW8DPrAg4OKHCUeQnyrEVgQlw4tgqmQnmkqgfWhRmRf0Dj
         7go7ZIkMpTcqnkHW1HTDkyFth5Lf97AJHi5NggifAt3hux8fWG6AOjDtdSV+EKs15Hs8
         X5iQDVWnC2bZOO4l1qqBR4/JJ1soiabNWcNYc/TnkrtqP0xyl4Dqz4AUKq6LUp2wC99E
         4gqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768229940; x=1768834740; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s0BwYHjTUF+pt60n8KoAD4GQEYtMlx4yMjCYbWj7SaI=;
        b=Fqm0aVoOOXG4/iYvfZCOo8Vw2YmzWMjCgAo90l0wJquq9dqijRptcRBxgRX8E1lc79
         hs2pqLWy8tSaogGZc6OPbUfzBmcpPxs661AqXwfSDPvBPN746CejirGJAHEZ690aAM+F
         0dyQsVmwIr1iiVr1PvuuFw5UJV+40eGKUCpeZe50JwDjoYtOKIJeFKYuaRAZmevxsKE2
         ZHrtCsQeriNDWSuu1ouWmNR2JZ9UpE0R9J0jU0GWwaOJy4w5FnVaFvgz3vN7BZV+68yE
         n7sNycTCydY4TRUijlADfWUX0hU7rHPZX4TnQKfsJGUXY//zS4qXl1W28xurcAlpV9Or
         AjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229940; x=1768834740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s0BwYHjTUF+pt60n8KoAD4GQEYtMlx4yMjCYbWj7SaI=;
        b=R6FW8+LxA7TvXcOdm+it3furc+vLjZNRceN05KcvlDZrGq7NKs7qhE3dJTULKAg88m
         54EQBc5eDoezo18/0krdwg/U4aBvqfeWRjN/K2QCrUn6c5MgrpxhlH2bdPV0xtdbkaXu
         c31VgDJJ9hqIb1nd/VyWGMHiuD3F0wabOdPHURhVg+to7lL5wCIhhrE7VRakCkQdCc3G
         925AcEFr72er8UrsRsGTZKAhetufv5yp4jICWNk4TwGe8OMLdYI3cLkNHQ/uyL9uh8H1
         hu5bzPuj2ZSu5dVySRA5/+//YAIsfbpNGKBa7AhhVQDkURPzMuk45w1utJmm0JCI4lU0
         pJjg==
X-Gm-Message-State: AOJu0YwJIcNIS94x/aD3AMHETQwXmamsjsH+eX1UgOENmhV8T9h24nzo
	ONOo9cwLbAdaQqcBXKgsFfLVTrE4tiuSfixW9VRtVbSYvKb1aKNzbRQKgMMC/T055e5y4U1vZ4N
	M+nUe5TdjseXNYqs42yyeeisnLOgXm9rLq3bk9jHZ
X-Gm-Gg: AY/fxX7t3OzqczpNyd5f4GdxA3qqZwUJKoYqVfytLl3xDDoAcku/fTJlrs3OaBlbyIr
	fTzvVP0a67B2rI8h4743umVl98bpkqz6IqHbyZsnwQU6Qu1PN7AHidRK6pUbDBWW0tX9RJ4Xyzc
	r0IQVMZ5pYlQCKNmqtt8xUkLk+m/p4Jgcp3RAHCIsk+38IqvCt3sgZbmrtR7kGOvLs5/LMsAXXP
	c9oeLr2UX7SPLeobk1h/0HxzaYGXmHq/kQSHe5uAFsJ1tIuzg2eJ0WJFreMYE42ekSjdmwCrmYI
	W656L/yzOlox8BO3k+S9EGN2tw==
X-Received: by 2002:a05:622a:116:b0:4f3:7b37:81b with SMTP id
 d75a77b69052e-50118442404mr18246381cf.18.1768229939603; Mon, 12 Jan 2026
 06:58:59 -0800 (PST)
MIME-Version: 1.0
References: <20260109171805.901995-1-smostafa@google.com> <20260109171805.901995-4-smostafa@google.com>
 <20260109195111.GQ545276@ziepe.ca> <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca> <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
 <20260112135208.GD745888@ziepe.ca>
In-Reply-To: <20260112135208.GD745888@ziepe.ca>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 12 Jan 2026 14:58:47 +0000
X-Gm-Features: AZwV_QiyFZSwbL5cJf8KcRzTIahuLDTegQ5hQUyCMCo1pYEgY2Ev98c53IqKZ28
Message-ID: <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com, 
	baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: m6ukkiepw1cix9boz7hgntjj7eux8jb9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 00C3B1C0010
X-HE-Tag: 1768229940-484496
X-HE-Meta: U2FsdGVkX18QT31Asc/N1J1g2Cl0YU6s08r8UH10KbhqCeavMSr6sFpqLFqkGHW+5S7AcRWS/1eTJF2BhZlx917pBOK79N1cjaxT0T+s8FEvkY4vV0hwYJdu0jQ1Rg8Z9Pcph3eOYkdiOpepyTeV34p0Mx6vCF6kczrrz7+EtmnTEf5fPJmGAA/0YpWhGtANdTc+NhR72p+wEn9uC63fQM5vmTa1+dKnp7tnYXXFwgGkn0E5D6UbsDoD+pf6rMkSM2xYndtFUAowPoIXnpvjK2/P9ifgNfMxE3QZ2nTR5E1pmEgwusUTw/P0XP9Xq19E632Btgw6tOyA1K1uAHips237x6B52z0NPRSMKz5rnmkkfZ8q/pAgSKWU8NDI24bcPVWyh/hNY/vf2d3FG8xAn4IenR00nfQ+F2nyjIwes+goPVEU2JmY89kqgV8rnusvv8t3XV+q5OwMPhd4i1u9FPERcQW8Ww1O8RZzHK0yrUTOmsyBuh/e3+wjEgUrRqqP4rd8BQO6FTje9HSfEW0nQ6al6PKl6TyRUWmdm5TcN5YB1n2D6j2W8u0fUs3FFGX61kUFrjmUNPgHWRmYdwcZ+jVnkv1/A0ZkXqDvPwr6KrKK4WoDnPPNkN54iJUI42vHsznzXZmwgl7XneBKAB0n/io32ALncwQKih2ofhVQmRaMdkSjyOT+LpGDMujojz1txSpWS5C1/O3IV2qTfmEL6w2+YfJayw32ZhOHT0NLs6NKIu9RHQBntmXKflTtNlP7BjBLXJzD1vNE2tDwqha0H2FQaYgl195x7FslBNkR6vJZ5nxLQkFDeNtxO1L0aX6P2R9I6MJKObXHbAEPn/BSwj2OTioDiGdvyUYHZC49W2iYmGt9GxkaBUVMUqQI9BkdOF4HzqC2t3HQ9n8BCXVcgphK7AhFMd3VpmihIOP89I7A6YpSp+qTzGvSEhw2koMZRCrRECsxu44qwYiP56g
 vDMw47l5
 VXzpEJr1luOBQcO0dwcZsd5X63/DSNL0OlkA7OAmGGlQy9yqSlwcA05CI9dqT/o76Y/XxjecHfQ5sEPtBE2F+aPSiprYUxd9+pwN20gJqaz3/PDV+wuvlt6qA7tHaa0NyZLwlv0r9q3nW23plCCibKluLGjEYGGDeX6MKQKRAtRD+aigGyMp4xkb5ALN3cG/+zTmKAnWYUySBAy3gmFGKDYtS8u/wr+vmGHtRE5QrTKr3ZpaiWtdmoH9tha9+su2kbK0XgBBJnUPsC8CgTytgLrXXCyLJOfev6lMf957Mar1lI08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 1:52=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Mon, Jan 12, 2026 at 01:43:41PM +0000, Mostafa Saleh wrote:
> > But I don=E2=80=99t see why not. from the documentation:
> > /**
> >  * pfn_valid - check if there is a valid memory map entry for a PFN
> >  * @pfn: the page frame number to check
> >  *
> >  * Check if there is a valid memory map entry aka struct page for the @=
pfn.
> >  * Note, that availability of the memory map entry does not imply that
> >  * there is actual usable memory at that @pfn. The struct page may
> >  * represent a hole or an unusable page frame.
> > =E2=80=A6
> >
> > That means that struct page exists, which is all what we need here.
>
> A struct page that has never been initialize shouldn't ever be read. I
> don't know how that relates to page_ext, but are you really sure that
> is all you need?
>

AFAIU, if pfn_valid() returns true, it means the struct page is valid,
and lookup_page_ext() will check that a valid page_ext exists for this
entry.
So, what is missing is the NULL check for the page_ext returned, as it
can be NULL even if pfn_valid() was true.

But I can't see why we shouldn't use pfn_valid() at all in that path.
I don't like the approach of using the prot to check that, as the
driver can be buggy which is what the santizer is defending against.
If we find some CONFIGs conflicting with it, we can just express that
in Kconfig and disable the santaizer in that case.

> > I can see many places have the same pattern in the kernel already, for =
example:
> > - vfio_iommu_type1.c, is_invalid_reserved_pfn() which does the same
> > check which can include MMIO and then get the page struct.
>
> This whole flow is nonsensical and wrong though, I wouldn't point to
> it as something reliable.
>
> > - kvm_main.c: in __kvm_vcpu_map(), it distinguishes MMIO from memory
> > and then accesses the page struct.
>
> That's sure looks sketchy to me.. Eg if CONFIG_WANT_PAGE_VIRTUAL is
> set and you try to feed a MMIO through through that kmap() it will
> explode.
>
> KVM can argue that it doesn't work with CONFIG_WANT_PAGE_VIRTUAL but
> iommu cannot.
>

WANT_PAGE_VIRTUAL seems possible in loongarch which supports KVM.

Thanks,
Mostafa

> So, again, IDK, we are trying not to use pfn_valid() in the DMA code.
>
> Jason

