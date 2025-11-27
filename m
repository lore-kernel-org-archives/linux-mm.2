Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A60CD11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0356B0028; Thu, 27 Nov 2025 06:39:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7766B002A; Thu, 27 Nov 2025 06:39:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DDE36B002B; Thu, 27 Nov 2025 06:39:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B38D6B0028
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:39:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B204131D20
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:39:25 +0000 (UTC)
X-FDA: 84156191490.16.F2095F6
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 524D6C000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:39:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XZwmLwQM;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764243563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTgQXrnGbp8yRV1ffH5aOGb73MnxpAvx9lMPfkiZ/pE=;
	b=mnvxmxPD2WCpQaRLr1HV0kJU34bSIWczoc31w1NCdsfgm1qehe2J3Dh7ngAVjYKugGqs5K
	U8fQlS0PUR146BzDLNXspzst7aT4Iupu+mNRdtUetshrZ1qlX26Va4JuCodoCFOaTgxIdO
	YxGyx64TyEjYXVV6MqQu1bl+7OUEFf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764243563; a=rsa-sha256;
	cv=none;
	b=k7xFSklfJUSlMEFCvbhD9UrFXhHaNob/yJDVkC+a/jrMoNePkFUsw3a681kGpssI25EzH5
	CZVJijxH1zulR00OWjrOC0zQnuEzM0hW5xYPcElh2X0tRHctlYZMazMHYnA3CsLTW8Mwxo
	Pp2l61Z8XmKtCl5EA8qji9qaMBXXlII=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XZwmLwQM;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2f0f9e4cbso66201285a.0
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764243562; x=1764848362; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTgQXrnGbp8yRV1ffH5aOGb73MnxpAvx9lMPfkiZ/pE=;
        b=XZwmLwQMf55UfdXp6A+FP2/+4JxFiifDu9Ahk3pmhtY9dWO3Y6Ece9GALPBZa6pshU
         x1FBNsPUvIAAuS3zb+sRjvSeb+Ax0DUESGhsCF90Hu1QlBNJSlDID1uGdMjsaSbYtp5X
         IR2BZM5BYRG/1Jk0mx7HV+1a/tNT4492eVED5qFxkUKa7Lii49/ocJnC7xNEPl33m3ul
         angQk19R/aOp/LjE7Zm46A5tIcSCsuNbF0m5cV8a1RXReuDFcLE2hB2Nq8NJXSulAUK1
         pZsY4+NifEkkRfX+OQ5z2bd6zO7PQVHbBuuXkhiFHcvosQVjtjsgc+a8+G8FP03CGO6e
         Ohkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764243562; x=1764848362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lTgQXrnGbp8yRV1ffH5aOGb73MnxpAvx9lMPfkiZ/pE=;
        b=dNr44qZ8YHZ82InAMwmDYxzTEqm5VhawwBX78SYurnnuNNuzmCTqsmxQLuycBWZrnM
         2mmqQv49k9Nz5muz31naRmFOk7DAQsQ4VnJSVL3yMKdljFZ+8v5BQkHf2F2BENVA/P6H
         aNAa1dDQCddp/rtQg+iB6kRl/SwdbN4f8t+VZXI0QHU6OHjHEuAhZ6vcyN615WEwGszi
         sgub11IeNHNpf/jkqIMxuL9qExM5yRtn3JrnhM2qecZ4Z2n21WhGGv1rV5PR+TVYhyRI
         2sa2XTNH0KXo1gswTdjqvl/18XpkLgDpKfrdj4wzmfoAZBFhz7+s4bCdpV+AWaAmB2Ss
         1JAw==
X-Forwarded-Encrypted: i=1; AJvYcCVtCBl/hhsmKUh+tjJ6a9NRIOLbqUzr4XFQxCq+QGveEvQdethWHxy1x53cw8lihpost4IC5nLkHw==@kvack.org
X-Gm-Message-State: AOJu0Yx6+wpapmDOMHDcJXfHtsnbzLU3iihwrgTbw0AwtQQKZouYCNjO
	t2IpwQVvFFyGAZ5UmT0C9MVvIjutBZQ7iA9HXkAiRgb00LzlL7QnGOeZPywLptvrfBq5JiP83lc
	jwlwgCTnjA3OcFQb0S4tSfMO8ob1zruc=
X-Gm-Gg: ASbGncuJ0GjDncEx79LztyDlazyVG+kIvC26cpfYJAbtUJSDerilfjd7NKvP1Yg7dbr
	8GWeoscziFazHhZIPHofz4C7dOSiG8G5mxDKuLqCLFMpPaDVcj4mbHFmOUzs9VsLYdif5WGDHVN
	lgFyqpnqu3DZnK4vCViplCi9MjwCGpUb6qW2dlIipRQ+I4hz5N4bQz/ZFPUFM1SukueNFmNwiO0
	0Ely7aXkN75ko3yorR0GZ6OdTgnWstu2uz/dZwYIbnFLTyRb2E/mogoPcJWtqY1erMJsg==
X-Google-Smtp-Source: AGHT+IF8AX3QuwU8PWoyMHubrE0YEf7OwwbSbZImelOgI0KoQ85t34HoENkNaCeescbBRgk60ctOqyrcZAkFR1pI8MI=
X-Received: by 2002:a05:620a:4094:b0:8b2:3484:8e22 with SMTP id
 af79cd13be357-8b32a8d7accmr3051143885a.0.1764243562227; Thu, 27 Nov 2025
 03:39:22 -0800 (PST)
MIME-Version: 1.0
References: <20251127011438.6918-1-21cnbao@gmail.com> <20251127011438.6918-2-21cnbao@gmail.com>
 <5by7tko4v3kqvvpu4fdsgpw42yl5ed5qisbaz3la4an52hq4j2@v75fagey6gva>
In-Reply-To: <5by7tko4v3kqvvpu4fdsgpw42yl5ed5qisbaz3la4an52hq4j2@v75fagey6gva>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 27 Nov 2025 19:39:11 +0800
X-Gm-Features: AWmQ_bmMHpk-p6E2I_jCY1Xqg4XmWm0x9ikXHEjIDdMSrcjAo4PIsH4k_44adgY
Message-ID: <CAGsJ_4xQKARuEuhrVuV+WmBC7+NCNd==Zi9nGmze5mfSjF1kdw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm/filemap: Retry fault by VMA lock if the lock
 was released for I/O
To: Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	Oven Liyang <liyangouwen1@oppo.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Mark Rutland <mark.rutland@arm.com>, 
	Ada Couprie Diaz <ada.coupriediaz@arm.com>, Robin Murphy <robin.murphy@arm.com>, 
	=?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	Wentao Guan <guanwentao@uniontech.com>, Thorsten Blum <thorsten.blum@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Yunhui Cui <cuiyunhui@bytedance.com>, 
	Nam Cao <namcao@linutronix.de>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <v-songbaohua@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 524D6C000E
X-Stat-Signature: u8uqp6qzbeeb3mpxmf4cqqzyht57qhew
X-HE-Tag: 1764243563-228816
X-HE-Meta: U2FsdGVkX1+9qqw9T1GYc18VP67G0ZhHYyEKM+WpR0wp0qDrZZtLN85xhFDAjI7iKl5ilDGVUnFhm6ux/vDOXU/KwXs6nBmeTLvvmPj2CN50hQpOXw7O0V8jrQyJHzth3yJp7HwtwXyYvVBFhcZyvktxAh5Nr4EXbIWIqSrIqmMcGVhhvtdxPIs0g233oFE83LRWTWlZkjPsfzDwYgWBM1g9Y+uw3MxjYRSVje0tNpaIzlmeEE4nplC2XErgEy5QqRMolBXTX7vVW0XzzKMC/Q66Yorg6rumO63IQsgYEw+Z/2Z+0YZvYCL0/2ZTCxIqDKLZ3P18FwO+HnPWrkhbzuYpOwhgHQBmmIrJn4sv2sbWA0Yv5B4uu5ZsW49dToOKdw4AetkT+GgiotwlQGeB6lAwSfoDze3nQD7lq6ZZfv+UkuY28SpOMSI9IxZVEPuwLHMjwSTwsq1mKOq+KSuzxKCYIZWp6lARqO1/q1nYozZ4a72HoxIAkusAnAF8sz+wF5YeoBLtS0tTa3zp/QSJSeMenuVEI38O0nuPscZWzpQeUKdUybWe9V5h77Zia7ZxCWcqnYlQ7lJY0BtgYNA86J0zV33IbdceO1IDxCZk5OxLVYZdtdlGOVWi1lSbQMD/SpUy4y6TCFUM/UZFp1RV8Q7Dg01x7E8RpaqcuX0RHopG2AIZiEcgKeZaUqVpMdyojzUPkbYlefWoeyHt3UVyhxS9ci0v8uGIPp6VJm0U/QUa9Om0XoPLkxjxZEZm8sf4gBNzK04JWnaw35eIs7tuHSU+BBhrEzysyQ4EHgxhicF7UqMNF2a8LLOnNhTxyloqisWBsMubA9Gbp2E57w5FdEynrMq01DEigDht52G17rqejWGzBA6whDAhjQJeC/JLjcxUifZNlpVuj7kuv/Tg7DXq8DnTmZ1vTYU09XG7QW8LpMMrIqC3/Nlkl9ssoBbYXZeNrIGH3501inU1PwU
 WCEVa5Tf
 PEGjLhgvtZkW/MuusZgYZMWIVZ+LEAgju+uVDnaMqrmAAG9hvNLfob0RKKNK3mjc2rKN6HOvtdMPEa4WBU3K7MDJ9l3B+KBeZupMl7BDVqn5X1SUCy83UVceHenhbt5PxlciP++rdGoertPcdUvlCC+H7cnx16yFMsV3netfVHzmzECsISXrEuraixByUN70EXVnzk6FF2mpo84UhyKv8oVl9Y0rOzeEcK38E+Z/DDhHnUJlH9dQl+SGxu9KnqDyggwFKwTJtBAQUx++UMaOkwOnW+MbicH0WD+TculSUb++JgeiF0fPjVO6H/jyC5xRF6G6Y92iLzOD1Xcoz3T0yridc26YkUGKzXOoEwrFV/n+qqWlMG7NKY7sus26OHKxKGrb656yLjF7uaDDvevSain1ChOY9NWCdxZoc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 6:52=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Thu, Nov 27, 2025 at 09:14:37AM +0800, Barry Song wrote:
> > From: Oven Liyang <liyangouwen1@oppo.com>
> >
> > If the current page fault is using the per-VMA lock, and we only releas=
ed
> > the lock to wait for I/O completion (e.g., using folio_lock()), then wh=
en
> > the fault is retried after the I/O completes, it should still qualify f=
or
> > the per-VMA-lock path.
> >
> <snip>
> > Signed-off-by: Oven Liyang <liyangouwen1@oppo.com>
> > Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> > ---
> >  arch/arm/mm/fault.c       | 5 +++++
> >  arch/arm64/mm/fault.c     | 5 +++++
> >  arch/loongarch/mm/fault.c | 4 ++++
> >  arch/powerpc/mm/fault.c   | 5 ++++-
> >  arch/riscv/mm/fault.c     | 4 ++++
> >  arch/s390/mm/fault.c      | 4 ++++
> >  arch/x86/mm/fault.c       | 4 ++++
>
> If only we could unify all these paths :(

Right, it=E2=80=99s a pain, but we do have bots for that?
And it=E2=80=99s basically just copy-and-paste across different architectur=
es.

>
> >  include/linux/mm_types.h  | 9 +++++----
> >  mm/filemap.c              | 5 ++++-
> >  9 files changed, 39 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index b71625378ce3..12b2d65ef1b9 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -1670,10 +1670,11 @@ enum vm_fault_reason {
> >       VM_FAULT_NOPAGE         =3D (__force vm_fault_t)0x000100,
> >       VM_FAULT_LOCKED         =3D (__force vm_fault_t)0x000200,
> >       VM_FAULT_RETRY          =3D (__force vm_fault_t)0x000400,
> > -     VM_FAULT_FALLBACK       =3D (__force vm_fault_t)0x000800,
> > -     VM_FAULT_DONE_COW       =3D (__force vm_fault_t)0x001000,
> > -     VM_FAULT_NEEDDSYNC      =3D (__force vm_fault_t)0x002000,
> > -     VM_FAULT_COMPLETED      =3D (__force vm_fault_t)0x004000,
> > +     VM_FAULT_RETRY_VMA      =3D (__force vm_fault_t)0x000800,
>
> So, what I am wondering here is why we need one more fault flag versus
> just blindly doing this on a plain-old RETRY. Is there any particular
> reason why? I can't think of one.

Because in some cases we retry simply due to needing to take mmap_lock.
For example:

/**
 * __vmf_anon_prepare - Prepare to handle an anonymous fault.
 * @vmf: The vm_fault descriptor passed from the fault handler.
 *
 * When preparing to insert an anonymous page into a VMA from a
 * fault handler, call this function rather than anon_vma_prepare().
 * If this vma does not already have an associated anon_vma and we are
 * only protected by the per-VMA lock, the caller must retry with the
 * mmap_lock held.  __anon_vma_prepare() will look at adjacent VMAs to
 * determine if this VMA can share its anon_vma, and that's not safe to
 * do with only the per-VMA lock held for this VMA.
 *
 * Return: 0 if fault handling can proceed.  Any other value should be
 * returned to the caller.
 */
vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
{
...
}

Thus, we have to check each branch one by one, but I/O wait is the most
frequent path, so we handle it first.

>
> I would also like to see performance numbers.

Yes. From what I understand, this patchset should improve performance in a
fairly straightforward way.
But yes, I can certainly include some data in v2.

>
> The rest of the patch looks OK to me.

Thanks
Barry

