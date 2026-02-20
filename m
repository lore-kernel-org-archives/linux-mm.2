Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FDEC5AD69
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 19:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7116B0088; Fri, 20 Feb 2026 14:33:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E547D6B0089; Fri, 20 Feb 2026 14:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35936B008A; Fri, 20 Feb 2026 14:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAD7A6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:33:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B2895820D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:33:34 +0000 (UTC)
X-FDA: 84465834348.04.88034FC
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18E38180014
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:33:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OV3E9vK+;
	spf=pass (imf16.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771616012; a=rsa-sha256;
	cv=pass;
	b=QK9LsqEoQaNHyqJ2EfVmyXSoEkasAv9PB6MOUe4eU2iSTHuwf6sUIo/ZO5C8FjN9m5k6Na
	ohEB1Xj7+Fa893bykRwQ+s2OAJ4zDSqsPkqZ+USU9f3JSf9SXqOzfAZgIEgsaTP1jWbGKo
	HAkSkrppJciVf5yt/0ebRGt3q72wYDo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OV3E9vK+;
	spf=pass (imf16.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771616012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPNU3Iqc/8CEt2YTyreNZ9j40AP0Tzd+qCCvU1fbH94=;
	b=3E5PjWuIXgVdwN81fwGOnOEGbShvOmvvorSPyG5+D9nx+/JnyVCLD+lxK4BTs7bzIuCTH8
	2B1bVbBJ2HgKzV1M25X+TApg6fUb9/S+3Yc+zbo5u0xO8kSWxwyKggTi88tx/U4uMifB9N
	1E4e1vGMBZ19fxwPrtJunYEAF0sgD2g=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a885af8ee7so8165ad.1
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:33:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771616011; cv=none;
        d=google.com; s=arc-20240605;
        b=K7825Rsrti8E6G8xFniyllirtSdjgBci2HTh11YBQOM5nY/EpKZuOguPYXmy9Q5XjW
         TWYvo85Icr1qVcJScLsaV6/uMY3kNwjXGBMdNOpWflczL3zJo3dbRfKKxOp5f6dJ87nf
         LrCtjqQGItB+ZKDZBKfqw9Uh3DQjlu0CNoFJrFcOePs/D2ge7/7DJ4z2H9D2HPzho66E
         e2dQeM1aK0LTvROn0SqRiruqoNyAOIufXugXkbqVN077CODaWJ/xt8FdBddkDDY8Cw3j
         ipvGG+TDIeu7D1tALsWX3EXx877nuRjom14OyJ4+fq96w5V4aTj+vsUSqNK61MZyO9yr
         VEiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fPNU3Iqc/8CEt2YTyreNZ9j40AP0Tzd+qCCvU1fbH94=;
        fh=VJqSMAO9mySFtwmACjhp9SlG+XH4EcwnzfcrvVop7EA=;
        b=H5iCAx8x9UFPj1qmMk2DQaBMi2wDWxr8eXHhEh2B6XI5VWJv+6fSPtnXPMwXTFfll2
         wGtyFOLCPqS/S7ILAf3Yr98OXTtV7Paa0A3pJsU160WjAgq9P/ZKjnCqNrVh/nsGjetQ
         +2sHGAgBDPkzmJisoOMREHMmX+FS3aaXzjSYL6jhlXEqlsPN30F9uTvltta+7jGjdXtD
         obTHocr41RHodeYcITmeDuayawMRC/y9M0KPCfcldpqv6Vt+PAG84L8SaG1ejqapl+sB
         7KMutBxZyMLlEzz+FZe7zMuBHTnC3gT1zmkePA67fenM/oyZYjiLX0vlJ84EVJ4Yn51a
         tBAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771616011; x=1772220811; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPNU3Iqc/8CEt2YTyreNZ9j40AP0Tzd+qCCvU1fbH94=;
        b=OV3E9vK+FiTGErA6y1u10tfpFoPyOuuVuXvFA71yBjuS1rhD1/vvXoSt/PfbEjJ1LP
         H1wRFDE7wXf4tOxe5jr0bV8J1dnRi4kJMRdXDlt+SeaynpyDoGn/MVWB0LKaSuVkzJNi
         obrA+7YzFH1enBbzDej6GkxjaMX5VFe0p3DuM33n5bwJlK9m8RwK9yip9/+X/L89cwKM
         I7SjSF/hrbu5RMCdtcLbsItMf4TVrZfm14tlP1X5qzn1LDRtnahbOWIMGx/dWGLtAObu
         5+P0M0A560FrdH9WI1uAP+XXDJN+8gW0GlpMcPzrSE4D9/yarSrsDpNqzYSdEpGIvoaW
         B9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771616011; x=1772220811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fPNU3Iqc/8CEt2YTyreNZ9j40AP0Tzd+qCCvU1fbH94=;
        b=cJ0Y6h24zvchG+Qb+YNdmUhpGkO1LU2JSLHUXz+tD67F0ML7MZahJGSENDfzMeyifA
         cczCn5+226/kCdA9ZBehcw3YxxfQDZggkVf/gGwPnsdn04T2M2h0yxGdGyfC8b/XL+Lr
         9T2fXi9p/6hFP4HWrq7lJUrHzL981/I6zpbrE/i4tlasIQLpas7jwbpZuKxnOZEE0Ukj
         7gVQMvcE0AImlAnr9AyOATp3FKcj97bwZAv/jF1h2un94prwwd2GWYkf2k0udoezeSM+
         DSrS2sYVvhffTYKaFuT2fias0hCyDLoODHPSxIcx+oAHsWzDwzLrXbamXyjuwTB4y3y1
         GxiQ==
X-Forwarded-Encrypted: i=1; AJvYcCV41sjqazSjSOg3Ufy12ijimlVVqletaltTmU3oQGVTPRBroQx5qx0FxodSbZ7ECI/jPWsOBSJwMw==@kvack.org
X-Gm-Message-State: AOJu0Yz+grRllLiRwi95LGosLIi09mFEK89eNUKsVI6NS4kb94oYRh8E
	HMyQ7NrDgjz1xr6O6dUxKhR5YcSjq3e5vGEcE2lTPZElIhKPwrbVu4NUKG3363+GAOwHboR1GSj
	CXIp+21lvcuBcec+6uf5qj7li6t4wFZ8wpw+WS/ZG
X-Gm-Gg: AZuq6aJaD3Og5NqTXJtOcTgnGHkw/GcmsLDJmBHPjAy0yYnhbsnb0HG3NXVA8Yr/7CE
	jIfq0lzX/wAN/aoM2OGGT4C1JFEM86nFWjo6pRmdiBeeR/qZnPEMIbeMRPIMX8dwxzDOP0rsNc9
	zd2StUIwxhZ+Fjs8bxXtv3+0oNYaUh8tajnK7TK4nqG0r4/5R6fL/yrpOylauK2EJ3Gip/L8mW2
	WY3aU/PVN7/hG9a5KACU26nj/yoPNsCKQZGvVUvNZsZoGtfgOKaMLryjRwvHGDHRzDvsiIsNuBe
	fONSokn5QeFSXZB4sPdEsGvqf/d322QSEHQ/NIy5babqpBIyCmo=
X-Received: by 2002:a17:903:3c47:b0:2a7:640c:834b with SMTP id
 d9443c01a7336-2ad75001831mr236155ad.0.1771616010499; Fri, 20 Feb 2026
 11:33:30 -0800 (PST)
MIME-Version: 1.0
References: <aZcmlIF4bmG0twkp@thinkstation> <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation> <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation> <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
In-Reply-To: <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Fri, 20 Feb 2026 11:33:16 -0800
X-Gm-Features: AaiRm50WJcSLH2NNCImK5PDnOYNWacr6Dhyx2jE0urcnByKvMWFxfpdAqCZGFzE
Message-ID: <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 18E38180014
X-Stat-Signature: ieecnfjxc1agbd98nwfb1da31wtdo5cp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771616011-722262
X-HE-Meta: U2FsdGVkX19BM+/JZqDPku+/Ao5il0++ly6CDadT2KXZ/RLWtFBZCllpc6SWY073MxPpoPYtEOk2Q/g43gzXVdWuiHousGPeHz7uX9DYhq8Od6HjUqyw0CdhHbkMPQ+oQXJcQ5dZLlgX7rhdQ1hXhsvPjAae3NL+IikGnJr/QibAKOBOIq89w1P+XiV2q4QAl/3LwJBh3zLpjE3SLWlFHmTt/QqDAh8BxbJige4ICk+rRPUIHZk+jru4Ue750XiJDn7MORADej1lmcyIKwPEeAS6iEbJhgp7VcN02UBtW3wUnujMpTAohhJMix6IQbMQJ3Ql5s6evmi+ijCbw062CxVWR5zp2zN+udXZzU9jrQi0oRU+Y8nfvRWBoHB7/60PLYnyVflJHohkfLwoQ28dNH+clB7dJWO4JNtEcio8eKl6ycFNISQwbRNnhzXvmbZp/5QnkUxbprvBdVEOzaW4Agh/85FtXgfPdaAqBo3QqIVAJywfSG+zrh3jOS8QDBYQgUwD+p/pgquy8s6oMd5M76yQOftli2kdNt+oELbsQVBrQpMpipmoiJcV639emT/GDA3s0+XMA7qVqIHOlcd70tzRsrsgCLMJNcMhi1yJjaGOu76VP/KIVTmetSnqaeWFDqls1RDuEiqR4MuYA5NVeJ0H/rCJFdSkaYAEd6b3IAPZaedN9QyyCC7BL5VNOnOU0lmir3DancYTZlk8Z5dO6ivknGWPqMM6FWSDcw4AXHvYtoiDq1IHXIHD96AFuUXf2hdJr7BjvnoDyA7bdux54U1ASNDSz29PIedCI0DaD9V7MSru2AUKYU43oodW/VP1SAqz8nkvddBDecqLe/NxulQwXKs5ZNqzTbaLwNq6QyJiFQObbduZhzbLjCyl7NJptDSRHaMW5jaCJeet1a78m2BXdIUJbRD3uWUqNsk1GWXPmDhmMl2eJYeP+k89Ou2ExjgkIPaEXDvdnJWVUiv
 enJm/Z09
 tfomvDnMWc61FnlCW6r0rXdHVMpE8bnez1CSIz06M6e9Xe2WbWfxIPUiBNfFDlHfnBMhPC0gh+wbV/PYm47rPCNaYdghFag682BO2q4ByJQE0uFHWts+GCFdn0bqNA4KWEborW5EpdReq8Kan60a/nZIw14E6hUsdDCAgya7J+h/8I1lN4tVMEZ6Eh0j7Uy+G+/b/0fc7OikKv86JDF0nZfmr+cNl7mSNAzOKGISRzgK14ykMAzNz2oDU4ThjCwDBBVcObRUhl+vEplg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 8:30=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/20/26 13:07, Kiryl Shutsemau wrote:
> > On Fri, Feb 20, 2026 at 11:24:37AM +0100, David Hildenbrand (Arm) wrote=
:
> >>>
> >>> Just to clarify, do you want it to be enforced on userspace ABI.
> >>> Like, all mappings are 64k aligned?
> >>
> >> Right, see the proposal from Dev on the list.
> >>
> >>  From user-space POV, the pagesize would be 64K for these emulated pro=
cesses.
> >> That is, VMAs must be suitable aligned etc.
> >
> > Well, it will drastically limit the adoption. We have too much legacy
> > stuff on x86.
>
> I'd assume that many applications nowadays can deal with differing page
> sizes (thanks to some other architectures paving the way).
>
> But yes, some real legacy stuff, or stuff that ever only cared about
> intel still hardcodes pagesize=3D4k.

I think most issues will stem from linkers setting the default ELF
segment alignment (max-page-size) for x86 to 4096. So those ELFs will
not load correctly or at all on the larger emulated granularity.

-- Kalesh

>
> In Meta's fleet, I'd be quite interesting how much conversion there
> would have to be done.
>
> For legacy apps, you could still run them as 4k pagesize on the same
> system, of course.
>
> >
> >>>
> >>> Waste of memory for page table is solvable and pretty straight forwar=
d.
> >>> Most of such cases can be solve mechanically by switching to slab.
> >>
> >> Well, yes, like Willy says, there are already similar custom solutions=
 for
> >> s390x and ppc.
> >>
> >> Pasha talked recently about the memory waste of 16k kernel stacks and =
how we
> >> would want to reduce that to 4k. In your proposal, it would be 64k, un=
less
> >> you somehow manage to allocate multiple kernel stacks from the same 64=
k
> >> page. My head hurts thinking about whether that could work, maybe it c=
ould
> >> (no idea about guard pages in there, though).
> >
> > Kernel stack is allocated from vmalloc. I think mapping them with
> > sub-page granularity should be doable.
>
> I still have to wrap my head around the sub-page mapping here as well.
> It's scary.
>
> Re mapcount: I think if any part of the page is mapped, it would be
> considered mapped -> mapcount +=3D 1.
>
> >
> > BTW, do you see any reason why slab-allocated stack wouldn't work for
> > large base page sizes? There's no requirement for it be aligned to page
> > or PTE, right?
>
> I'd assume that would work. Devil is in the detail with these things
> before we have memdescs.
>
> E.g., page table have a dedicated type (PGTY_table) and store separate
> metadata in the ptdesc. For kernel stack there was once a proposal to
> have a type but it is not upstream.
>
> >
> >> Let's take a look at the history of page size usage on Arm (people can=
 feel
> >> free to correct me):
> >>
> >> (1) Most distros were using 64k on Arm.
> >>
> >> (2) People realized that 64k was suboptimal many use cases (memory
> >>      waste for stacks, pagecache, etc) and started to switch to 4k. I
> >>      remember that mostly HPC-centric users sticked to 64k, but there =
was
> >>      also demand from others to be able to stay on 64k.
> >>
> >> (3) Arm improved performance on a 4k kernel by adding cont-pte support=
,
> >>      trying to get closer to 64k native performance.
> >>
> >> (4) Achieving 64k native performance is hard, which is why per-process
> >>      page sizes are being explored to get the best out of both worlds
> >>      (use 64k page size only where it really matters for performance).
> >>
> >> Arm clearly has the added benefit of actually benefiting from hardware
> >> support for 64k.
> >>
> >> IIUC, what you are proposing feels a bit like traveling back in time w=
hen it
> >> comes to the memory waste problem that Arm users encountered.
> >>
> >> Where do you see the big difference to 64k on Arm in your proposal? Wo=
uld
> >> you currently also be running 64k Arm in production and the memory was=
te etc
> >> is acceptable?
> >
> > That's the point. I don't see a big difference to 64k Arm. I want to
> > bring this option to x86: at some machine size it makes sense trade
> > memory consumption for scalability. I am targeting it to machines with
> > over 2TiB of RAM.
> >
> > BTW, we do run 64k Arm in our fleet. There's some growing pains, but it
> > looks good in general We have no plans to switch to 4k (or 16k) at the
> > moment. 512M THPs also look good on some workloads.
>
> Okay, that's valuable information, thanks!
>
> Being able to remove the sub-page mapping part (or being able to just
> hide it somewhere deep down in arch code) would make this a lot easier
> to digest.
>
> --
> Cheers,
>
> David
>

