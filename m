Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9016CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 22:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868776B00D1; Tue, 16 Jun 2026 18:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8194E6B00D2; Tue, 16 Jun 2026 18:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F3C6B00D3; Tue, 16 Jun 2026 18:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F73E6B00D1
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 18:30:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7D9A140289
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:30:14 +0000 (UTC)
X-FDA: 84887220348.03.9A14B0F
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id A87DB20011
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:30:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NzDS0xkf;
	spf=pass (imf13.hostedemail.com: domain of mattias.nissler@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=mattias.nissler@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781649012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAxc2c4PIJ8k2PHNKfIagVddicGP/HM+RH1DFcf9/Sk=;
	b=FJBC40vAbTm2A4l5k7/IEeWxYmhz2SUvRnJ2m0a8EIivVTZIdxMyVIzmYiA2vlrwd2aJuk
	5bEqGM9MDnYfDnqJme1TzNaFcWhNhzzd8FhSZpwNezrgd/ETQmFPQy9IqF0gWO7V2rKzxV
	7rHCBnXZtQs7aYn/Fcen+qhS+E/4Uew=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781649012;
	b=KtHoGtOTDDZu+YxtmBHK8u8D1Ft3wGvu6wPOIyRbDY8FucZnJwsaw2ZDHHtqBSGx1guyOL
	YfNZPTAoCuC5xmoMgESFx11WWDY0KdJLpgvt5PtHqhQWbwAkZBdYAvTUkbJm/sgkUu7F8R
	Bu5aG4jRcAyYQkINjb3DMjgGINunzRE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NzDS0xkf;
	spf=pass (imf13.hostedemail.com: domain of mattias.nissler@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=mattias.nissler@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e6fa36a1b6so4392479a34.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:30:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781649011; cv=none;
        d=google.com; s=arc-20240605;
        b=fu8a4ivvEGzOLbIZnp9s4uherx+OQ5osQlO9jkkswXlFG2kegvmf08QpRpH6VyRPGZ
         Ap956CRQMU74EsXWemwpvdxGRS7mVyc0gHq5wMMdEZ28BrFaB1kqSpD/2vzAczMc0Zar
         v+GZStU8lS/i0WTdgoJv9vobDa+/qSd8ILYLLBQjRu3ZXg6sGi8MWLsVrgM2V5g8ODa0
         jijiMhiZJmr3WKmCAcJaA9J1cPfCGBdY2aTUjtJGyJekgfVdZ0nibPdcWinvfJdZm9KD
         OOIqn1S56xmc3g8nV85rmUzKf/t8GAP9hg/ibg2h72IC30mIwMgJzocr+o2y1DQ2a793
         C+Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EAxc2c4PIJ8k2PHNKfIagVddicGP/HM+RH1DFcf9/Sk=;
        fh=fLtFm5KoYN64nTvD9FAC46zbM3pMb+auTJl5117qIY0=;
        b=LvYVqAtCUnCTWlPj0MA4Q/e7QJeVzE+MihToQh9rDhOnbLplpg6Z/gkbWDPy14mm9L
         mLV3sRx+dpj5wxiujjjnnRA7rVJDyHOBuTUFTmvhsqZ+sLOYJNLQqTuHkJvMrwJKSNOU
         GnoVE7HMJP/mESQbpqnfCafOdWCVvqYwNjUXjRiMyhjY1KX89mHuDGDy85rIOqoyEg1o
         pGelKbrEz/t2CY3xJuInlQFc1ogQtH1mtMcitqj7pHWX6n4kxmcVnef8YxvfDPTGeAMu
         0qTyrhwU3zexk3r40tZQMMWeR8x4HRhp/iFIr6P56qMcXKrN7rvZVv+rQ7SViwlhMk+I
         PE0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781649011; x=1782253811; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EAxc2c4PIJ8k2PHNKfIagVddicGP/HM+RH1DFcf9/Sk=;
        b=NzDS0xkfd+5UxlLdXncw+pTIVvUmn/Er83AEQVr+i+lNfkKuz74YRYXLNkTqPibPod
         GdKMzZdm8v3iD3wTDsCQZi1hpZny+3sz70EKFAd6kFNGC8qPRF5gireNX8pCvXogHX9U
         RfbVP6aFBh9Uj968RVOXX+KBviA/XUwcLhdxHJlEUCVSJGt5CNZDscbU16wgW+2+7b0r
         bhasHCaEA7ESL4nBa3VSO/xGEwy7tAV4BxNpb4GHFcCilSx63Nk4U4O3JjMY9UMXPyiJ
         R1bMNDsERl4fRNIG+0I3oQDRUaZEgOj48rU7SQGxVptkJiHu0u9TAMUJGRrptLAeV6DI
         X+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781649011; x=1782253811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EAxc2c4PIJ8k2PHNKfIagVddicGP/HM+RH1DFcf9/Sk=;
        b=sJJToJ9yhGtGX7kxueWPtVNPbGE/zRyKyGkJu+AEFGCwQnwBTneTDqFM30MyT+WXbb
         E+D2VDXUZ0aJQRKfM9XFxIX6O0Rpzrwb1QnL/tayaJu8ZPyrVxl9M87UmBOEoe6gFzcr
         eazcAcHPmNQYSgWByfH4xzBFiHVPEhesP8bz4XXK1uw53119+8foxcIlikJZViSEDiFr
         9at3vwnVqjAUJh5svTuMFfpX8u1vz15c4RINqQGtGNAE11ACAoDq6moaE+ZSyrQyuF/v
         YfOtyd9Eu+kh2nGEijmvLdYdEd9GDc/deArO/TUmBSzVOvjC16jagAaUW3uPixBRn7Ec
         9RXg==
X-Forwarded-Encrypted: i=1; AFNElJ836SvkLxWblxqNFLHRzwXAKSlw00pQGMDvjIrKCy62j9h/ypN2IQwDUzrfSb19Qi2Cd9BYifH1Uw==@kvack.org
X-Gm-Message-State: AOJu0YyAxwK9sjGG/2CA4qjZNUOJzWwny421ooUarEMw55B1ywrJCQun
	MNb55BUI6yFZ3m87gen3zKcleKXzSNRSayzoEUBFi7pqHEZSrjjcoY/m9sfIDzvr6+I1yePbs1T
	44R9vnYmheHxgLKlLXrloyFQcZeoaYL496PGRHwI=
X-Gm-Gg: Acq92OHNPzXAy6m9Lfc1fKlUN2Q3NpGMazm7RMnVNS7t7XhE1MPINFhZ6HWuvqupmYM
	c7WHI0rOoot0Qp4Ks0b5oJGBui5eGG3RNPY/Wo0eLdJAouhgGHN79SznMwiZVHwY2XY+TD0nswa
	+FDbZUWUg7i5SBQJ7nwVFpC3cbvNcoHRMhg7lGFZo32Hphavg9VliVeNGWM51kWzW6ehNfFR2Rw
	NCJBboADZs8i22UmnQvcCPmc7Ie/AiyRluc8bjrtnBF9lsz/OB1KDzRwHmtRszkjshrhj/8mcsy
	LvoIINsXmglDwBYbs6gCcbhocGBPTygbNU5DXTY=
X-Received: by 2002:a05:690e:418f:b0:658:e645:7736 with SMTP id
 956f58d0204a3-662b61908a5mr2399546d50.39.1781609573882; Tue, 16 Jun 2026
 04:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260603125521.1468362-1-mnissler@meta.com> <7b05bd27-2152-40c7-a777-390ded5defd9@linux.alibaba.com>
 <40381f8a-47e3-4f97-a9ad-f6f868fe0392@kernel.org> <CAERLvmQyOAvCN971uUx1PDqTXExOv-BHbNgo-oByaHavUmLgfw@mail.gmail.com>
 <ee858321-7407-423a-adca-caab5ad9e2b8@kernel.org>
In-Reply-To: <ee858321-7407-423a-adca-caab5ad9e2b8@kernel.org>
From: Mattias Nissler <mattias.nissler@gmail.com>
Date: Tue, 16 Jun 2026 13:32:42 +0200
X-Gm-Features: AVVi8CezbHUn-eRnCcHJ7tO9cjFN-369E4QqhmAGOIpPC-JpezH7YNJ2Hbp7NBQ
Message-ID: <CAERLvmSc6Z9JN-Ufc6_NJvuk4S8oLD-HfDdWS2k1JNo90vhjQQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: memfd with write notifications
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, Mattias Nissler <mnissler@meta.com>, linux-mm@kvack.org, 
	Hugh Dickins <hughd@google.com>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A87DB20011
X-Rspam-User: 
X-Stat-Signature: ayntjwxxwffp86cs6mdscc3cizfhmrt9
X-Rspamd-Server: rspam08
X-HE-Tag: 1781649012-14751
X-HE-Meta: U2FsdGVkX1/233m8IGBjCOUmZEhZnUwjRo2YmufU772KqCHQ2cUcdzKwggQjBDA1YXHtYVUC1/s3LvZ8RWCHLxiLglgERjJXPQPOMyFE+eZvSpWo474VHqk4srOifzpKrNRB11er5GqepwS4R6p/9J5dXzXeo/DZjVmcHF5y5GwArbualajdD7E1PIHtUSlXarPN1Q6cro6poEDZQQYM1WwTXzGuJSUu5xMUTCPMvHimI1U6CIBdjW9ts/ZJptSIc2G8WARJ6HyGruQXmfKozyoWHQLDN6OLqX6GaQ69vlD7FsS5Q/3Blrap4zDwwzz3MRbOylpEVP3s8RECEXjOGrLUcL5pcsmUh/wM+28VeUb3gjt7OQoxhOvsvCFZS59nv7ZWOizT3VmuuGSYWtv6Ywu2q8hjvk9/gWIrAo3GxTIBAYaEtZ3POpUgYnpMD3gxU/K2PwL0N0GS1SFgNOkScsrPd0F4J0jTiklDzsB6jBzvf8+ndxdxV+6gMXXxTrjJDjCtk2SB/ZisbeRHASLul8hO53r4xWFnNZ/tXBSIloRETcuYmhBRZZ25QIhCd265Mk5WUrVNW/78pQXGErl5dfunxCdESan7/hPHjhGw4SEQrtg2aZltamAO1m9d8YQKOsme7OS3XBezfIKBxXoTEhXJii6/Qez6+/WPN2+29rssxrGOnuMgU4tmZgjDQnd9rBOyiFfppvmr8eEBqbdDlvQ9ArRuuOF5fxZVWwhwYNKEO3a9Tmtk1n6b9Jcn8bAUTfCqos2IgtT+Qs+KLBRwi3S5issQsLq/2BWpVfTY/PIKtrmsDZPhMkM/a7DxutjdNLlozEOxBn3zB6KzTe0pBY5T5RndhcPGByg7lnTlUPJ3LMfZwLEnlj3WTGiXSxzKmNdsANRBUJ62h0pcJPQ6rskuLheo8hCsoEshfc7yinuT/Da35qqgotTRQQwPZ6EhTLUlmSDAaPZ3f4x+IdU
 H3A7LuPa
 l6aI1CXNGZrwyE0dS0aBSLu+WVjLQCdQqhNvzVvwFsOTAjRdCs7POR21no8y04Uq5tnQzHVU5MIKxIsuEYzcEE3ltttxCyvOiHRky7gY1y2XRzi/kmArFqGtnWSsM7JegG5HfEtvzzGQlq8Pi8uy+277f9B8xbnqxaLbGCpmfplnu0cD99BxGF3bV1gTK5z5Q+ubXVlQJWg5bqtak/YEpXQAK545YqQNZbFWTrh8dvHIqw1xDo9CcSFmFKqUwv/Pd4plUYOccQZWhKSEaJ4YdXEvVtDjVoeakzlRWRUAjymMov33Qk01SzOfDUKkXKknLSDF4Sh9v0hbFYLHKClX3+IfANl+8HkQX6Vxw/LguASHSHEFjKaAY2iIsw22jrdsP0k9LXkvAi5pAF1RN3W/ywqK9WJetC9nwVJCPVS0V6xg4Jx47dTNXsvAE8gEgwNC0NedCsSg4DXTlxt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 10:20=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/16/26 10:02, Mattias Nissler wrote:
> > On Mon, Jun 15, 2026 at 7:43=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 6/11/26 03:36, Baolin Wang wrote:
> >>> Add more MM core maintainers.
> >>>
> >>
> >> FWIW, I was raising a couple of times that a userfaultfd-like mechanis=
m on files
> >> would likely be helpful. I think we also discussed that in the context=
 of
> >> guest_memfd.
> >>
> >> For example, for VM live-migration in QEMU with vhost-user processes, =
we have to
> >> play some weird games to protect the shared memory in each and every p=
rocess,
> >> such that we get proper missing-faults.
> >>
> >> Background snapshots that uses uffd-wp in QEMU is not supported on sha=
red
> >> memory, because the communication with the other processes would be a =
nightmare.
> >
> > Thanks for bringing up that context. So this is mostly dirty page
> > tracking? I reckon you'll need a way to learn which pages have been
> > written, rather than just a notification if any page in the region
> > gets hit?
>
> Yes, for QEMU to use it as replacement for uffd targeted at multi-process=
 setups
> (i.e., vhost-user), I think you'd need something similar like uffd, but o=
n the
> file level, and less uffd-like :)

This was probably a bit tongue-in-cheek, but if I may ask, what
aspects of uffd are problematic? Obviously it being process-scoped is
a major mismatch for your use case, but are there any other challenges
you have in mind?

>
> But in general, protecting/unprotecting file ranges (read-only, read-writ=
e),
> notifications on access, notifications when filling holes etc.

Do you need notifications to be synchronous (stopping the faulting
process) or is asynchronous (firing a notification and
write-unprotecting automatically) sufficient?

>
> uffd gives you that of course, but at the cost of the kernel
> > having to perform more bookkeeping. Trying to wrap my head around what
> > a good trade-off for complexity / user space API could be.
>
> Yes. For a simple doorbell mechanism (IIUC your proposal correctly), it f=
eels
> rather odd to embed it like that in memfd.

So what you have in mind would operate at the file level, but work for
any kind of file?

Btw. thanks for bringing a different perspective to this conversation
to help explore the design space, this is exactly what I was hoping
for.

>
> I might be missing something important, though.
>
> --
> Cheers,
>
> David

