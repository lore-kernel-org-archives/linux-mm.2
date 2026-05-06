Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 466BCCD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 19:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1456B0088; Wed,  6 May 2026 15:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772906B008A; Wed,  6 May 2026 15:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661716B008C; Wed,  6 May 2026 15:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55EF86B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:10:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 091F2A030B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 19:10:19 +0000 (UTC)
X-FDA: 84737935758.13.369A11F
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id E26468000E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 19:10:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XCDnnGd8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778094617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxYj1aTW1njQRk2RovdD3TWz0pf2a+0TwFEDmS1XeZA=;
	b=jdccq1u8hpQQRFl3ZQNoglp6NuL1YQFQEf23uQfv0VF2EOl7SIL0p00o4T6arhFNSX19wh
	icRqOlB6sGej0qazs5CDFA75KDpXNAbgFQ0X1TjSUV1uv4mCV9yyIXkRXSmTh5lSRV4fES
	w2e2HUuzWg2xg6G46NrveymyMqcWUdQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778094617; a=rsa-sha256;
	cv=pass;
	b=DCZgcPVlk/eQmazjeE/gLHl/P41YjW73zUhteTKAuvXffL+RqfYgNzxfdroDT/SvoIUB+M
	ArZZgxEcK9Tlf5pQ/HWFa5J7WzS5wf+V1CmHh1MmEIi9ANEygVFrC7041PVAPCeVQDWpl3
	B9TnGjdg79KIEjsg/D3v++9UAh2KpdY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XCDnnGd8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-672645dbfeaso7580600a12.0
        for <linux-mm@kvack.org>; Wed, 06 May 2026 12:10:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778094615; cv=none;
        d=google.com; s=arc-20240605;
        b=IqgB/5VcRO1h4mc40oO/odippRAZA90F+OS5E1hkM1ZmIW+bo9bcK1SDXfiaMpCNFL
         ky+ANJHn9zLk7GvkXl9uZgQTlytZEmIb5AUjyj/o4Vj+GX79nLHwI4H1Ee0y88fp4PfE
         xYfSrtd/gixX2t7/Z24kwV/uKcvql5N+/mBGfInkcVYDxHAkBjikpFmeel38WWYziPsV
         I7MLkFCZ3kW1W6nCJ2t8f9ih+oaeAYFUCGUZDJL7nQkEnB6rBdbAab6v4VK+r3gK7cGE
         hDK/QraecJPWWpUxNkQ9+r3YYso6iFQCbNF27J2UH/K3JiW5z7M2t4h31Ez+s+jYV5p2
         diag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cxYj1aTW1njQRk2RovdD3TWz0pf2a+0TwFEDmS1XeZA=;
        fh=dfO5FrG/+NHcN9BWTLXc8cDOYj/xX+H5+D1a8qeNJRc=;
        b=LRPbKqTwWrGrXeyidJOAsuAzPkRTsw2RM6U4pmPFMiDi5EJS+HWMirTqoYkPwo4HeS
         dvswo3m68fFCF2YL/4Xdt1UrZ4HsHbaMDM753FkrPGeynRHV0akJs2nwe/neAonpFgrU
         Xrj67iimSNt9MkxCPh3zKHx4VsSVi0jZEIrcE4zsVkQI+6S4kP+ggT1kuHU1eCjwiIni
         ty35e52zoEafrbuN5Di8PTphCrh15cpNrFKIE3jm9SUoFEfJPgUAOymd+MORc4+gpH3j
         XHM5IH2iFMv9XwJvZWhXfaKK7sf4pN3i05nEAaz0DYl9QQXbxaG708XICcA1amfj5sZ7
         JTIA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778094615; x=1778699415; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cxYj1aTW1njQRk2RovdD3TWz0pf2a+0TwFEDmS1XeZA=;
        b=XCDnnGd89+s3G0oOC3b8ieixOvN8bi4ob6+HNA75zvVS6TSZpa24oGzWBkgPFtkUhD
         WSIsnB353xYX+JDIGIWYcnkfTWcuWchVonOyPJn10BC+2OooscyPRISEL3UVXplBxhrE
         2hVLOOqXpkduNx3QWLii9DdS5DSm34nhABdwtXAbwrr2YaM0ptKH5QXq4sw49lpq0RN4
         gwhKwa9NUBt8IRCtp5UOsSbL/txtqrnGnLxfKMS+v5ZMYUxkxBC01tfiAVe7eZPI9D3j
         kwEGhhleQbMIVXDkTWUKLBH8o3ctsybaYi27kTL6HKridriqdIrLA4VSYGuwqX+g2mk/
         RV+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778094615; x=1778699415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cxYj1aTW1njQRk2RovdD3TWz0pf2a+0TwFEDmS1XeZA=;
        b=n0m6mwtZ68xx/lSDevgolBgyPpZd42O5FVzQz7fW6ZA6eq+0z+Il3zQ6YMR8wJOkVI
         WnDaI9WKIH5hrS7uLVn6l8KBFbmoojgiVLNKnkATm1N+H2cYK4lQSaOgbQleHx/qesA1
         DyW3cr+zVHph6s8Kw1vof65UMCZ8rQvP94Ue5a1mjUmGtvKu6rHE5Cb4qLoQ8VQqNqO1
         IX6+GQrSzd2dMDiQHVgoVbgWmSPOFuCso/U9gmbiHPn4lJIOX50LvOisWTdGcqKCWa2t
         z+o+FvNqiKCFC4YQu/DxprpR69L6fq1BVqWoV9hFn/sFpB7bHNca1g5SjhCWzoAGFm7n
         QCjg==
X-Forwarded-Encrypted: i=1; AFNElJ+bep64gcFR9NeVfuSavkGTQmhO9PugZLJ2uKxl2nnRkIcdHCFnWehGtpJ77g283HGhDwOv5Es+2Q==@kvack.org
X-Gm-Message-State: AOJu0Yxa1RJyrrQ1UdZl96tzTE2WjsLpH6oDJjUkQ5A2W4B/AeRccZJI
	CZFXAoy/uPe8S923WdtjvNEuXemF2k7DhZ+LMifz65wDjycPmNHA2CI2nhFdD+a31Q2qlzKg2Pb
	H1MkGdaC+0BBTJY6V1MevC5dE4U8eNI6qaA==
X-Gm-Gg: AeBDies93Vs+LEVI+gkQceMtDRCwxUzIlNRPXVDFPai6vbHY1f1mcJEY+qOXkFBo9fw
	zHunKESai4oW+a1TBGth/SPb2M5LEotq13dIaMCHIvWKebSSCZYSJtEwDQbZOIFDmZ/zgs61tKt
	H333+mP69BnONL1/NY9znlCsQXGhHouFwuDpPguVJOb2eEWsHPpHdv4DeXgy7YnuwT2f+EbxPgP
	SMKeEOsYpe0/aFiiB7Jo6whWiePkN4EBS4FFViwBF/WewvuS1uhp3El7EibMj3GLBvxPTDp05bG
	RTy+WDIvpp+TVg3ivwA1x0Zr/vd3V6BjiYqDUdSa5F3nEas=
X-Received: by 2002:a05:6402:534a:b0:670:8d21:dab with SMTP id
 4fb4d7f45d1cf-67d648a980bmr1835425a12.24.1778094615023; Wed, 06 May 2026
 12:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <aZ-DhWZbTnTnBh-D@fedora> <CAOzc2pxpGLe4JXNS4kgXQGFLaLO_k1PRfpiJrciO6xO8L7A8dA@mail.gmail.com>
In-Reply-To: <CAOzc2pxpGLe4JXNS4kgXQGFLaLO_k1PRfpiJrciO6xO8L7A8dA@mail.gmail.com>
From: Vishal Moola <vishal.moola@gmail.com>
Date: Wed, 6 May 2026 20:10:01 +0100
X-Gm-Features: AVHnY4LjMEnT4EK3V2eS2hT3FZoc-APjFZfbDYoxzeQvirLX2rmFCiJ4YyL5c2A
Message-ID: <CAOzc2pxOuqhiTKvgt_7tgRWqxWSSfoTSMWa+USbkoUsA6dkeag@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Separately allocating memdescs from struct page
To: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E26468000E
X-Stat-Signature: o517rpuc4r7ajjm6gn83tutkpu4z9wue
X-Rspam-User: 
X-HE-Tag: 1778094616-569497
X-HE-Meta: U2FsdGVkX18q+fSXrbNwXdVWOZFFlX7+3+L7gR0c4HgF7S+E66YNFmB6kky/28cQcHkfJ1On2KreWC1+LRbVe3Iwk5Mdg+iSZ6FyYnEXkapCBJl5ksSpNTwxSj2YxpUNKz/cziH1tVCsnYWgosd5rCyWzeWW99O4oC08ySbx0uw57xyimHIyx9mY7UWBIdkz7aJCb9sfowhkpxMgYtbsSB9XnGsObflvpCBfVb8CpxrXz0W/ISperIUXnCjb36MjWeh+XBRDebuul76ebz4Ay44rGh8EJ+pCJA4o1I8EcFmbP8gO8WFdmuj6feDX5RdQ4Wiik0L/fbho8oOhLkNgTuqKNHRI1Vb/PCxwF/l1KWPg0G5VohC3YBVHooz+z13zP1pUJGyXxuEksI6rlI4jTyDNASFAqzyN8p13fWiDHsV1zuUk7F5or8toqMF9Q5j5/gpZZ1HglOSCVUnKdDGbrzJMNZQOwG4PB3EhLoFhQsB8tb9JDGoup9BmX3F8nZbBs8FY7bmQ4sLxLpk1oqNUzRD9zjuJeMEJ5UyYfxkh/9Rqb74KCCIkKeB3WrVwvntI8Wuu7b0ZEYLBEg2f5PeYussv5tue2zDT3RFVmSnY1JFlo64IeO6vp5pUiCah+HnAV4mcf7hgp9bEETFv1O6N/am8xhiRt+49T3ejWJTkYnUP56SluR07jcNkfZoKmenoCnG+7gyfsaglejBgs+0+6fVr00fWO1JiB0VUo66s0RvQlKXh/1vGF+t3JeFOozZQ4a2W4lGOu1f9CIeQXpKU6FT97qFlPWmQvKyvQ69ATMXMzZ03eS6WZ+MeLMKIwIvHeyY+z/AuiAEh0IRy8M2n2CSb9wrxNIL3S388++LqRQ4tNWjRj4tdLahZHRuWA5ZmXbfPZ9IPERJDknA7md2Box1eyZ3Jc2tpZ81+z0CqYkDMZR8FaeM43h+1MoK49nHwYEGiw7B/NkhGSZrkD5N
 yBgGG5dj
 LvomiMwb7eGP5aGEGyjhV3RYw3fZqjQ2sB8U3VSUYDcCAS2ZTNOllC3MUpc6AKu+B7dfQfv55cziXo2MSBzjf2gn7e3VjnwNEnOc3stPrqABhwZ2j43/tfawk/UurckMy90t/seo8tBwvqi7yV8gdC46U14PXRkeifbsgYQZeYrtWooJeb6Sijh5xvf/lopwLhGVcOE9dkebLpRSpQ2Gjz3th0jAkUuaZ4l+G+3AGdrtgT7JEfn+ri8aXRykoA22HHrkE0M33wF7hU5lMvA+T95ZnqlQr0id1k3VXOPF5qRnyjWZVejqh2qPlyzuW9TXlqB5DpUdeFBCUB17tqUBcSriMiR8hWmZ34GvrlzGVkhg4hOHAHVzu+9ARAgruDLXe3x8WsexsTjfZOdmxZoYQuH8iJBNdq8DMNnIYGVuyjdmmsy/qm4LlDb0SSYJRl5NG4hykwwQJ1PDe1kiZcX35DGTXxAHi8oHhybfDGSobp1encKN1Ou3CXUdr7zU53MsUH7DzAQaGV2tlJtSgdR6QfWqtz8xJhuNVh7pW+FmHPggUWCTlvrFOzdPTZFsAbUk9x/gBcHfvYsDlYbj09fbQRgH2+cWsNCMuEMDiZ+vpO4CwI+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 6, 2026 at 8:03=E2=80=AFPM Vishal Moola <vishal.moola@gmail.com=
> wrote:
>
> On Wed, Feb 25, 2026 at 11:19=E2=80=AFPM Vishal Moola (Oracle)
> <vishal.moola@gmail.com> wrote:
> >
> > As part of the overarching project to shrink struct page, we've been
> > creating memdescs that currently function as wrappers around it[1].
> > Until we separately allocate memdescs, we won't be able to shrink the
> > page.
> >
> > We're getting close to being able to allocate memdescs separately from
> > struct page, and I'd like to propose the topic to discuss how we want
> > to go about it. We already have Matthew's PoC for ptdescs[2]. I've take=
n
> > that on, but we're still running into issues for now...
> >
> > Heres a non-exhaustive list of things I'd like to discuss:
> > - What memdescs to separate allocate for shrinking the page right now
> > - What are the implications of separate allocations
> > - Should we separately allocate one at a time, or all at once
> > - How the APIs would look
> > - Are there other generic fields to be cautious about (i.e. memcg)
> >
> > I imagine Matthew might have a broader State of the Page talk too, so
> > this would be more in-depth. Possibly focused on ptdesc & slab (as the
> > two we're actively looking at right now).
> >
> > [1] https://kernelnewbies.org/MatthewWilcox/Memdescs
> > [2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@inf=
radead.org/
>
> I've linked the slides to the presentation [1].
>
> Theres a mistake in slide 4, the correct labelling of the words (to the
> current page) should be as follows:
>
> struct folio {
>         memdesc_flags_t flags;          //word 1
>         struct list_head lru;           //words 2+3
>         struct address_space *mapping;  //word 4
>         pgoff_t index;                  //word 5
>         void *private;                  //word 6
>         unsigned int _refcount;         //word 7 (first half)
>         unsigned int _mapcount;         //word 7 (2nd half)

I keep messing up minor things in my haste :/. Refcount actually
is below mapcount, woops.
The slides have that part right xD[1].

>         struct mem_cgroup *memcg;       //word 8
>
>         /* Below are for order-0 folios */
>         unsigned int pincount;
>         unsigned char order;
>         unsigned long pfn;
>         /* Large folios will store more information here */
> };
>

[1] https://drive.google.com/drive/folders/1KGlxnmg-nQ64uAK8KBp8DyNYiaVbTWG=
F?usp=3Ddrive_link

