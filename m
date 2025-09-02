Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1DFCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107DA8E0005; Tue,  2 Sep 2025 04:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0924B8E0001; Tue,  2 Sep 2025 04:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B598E0005; Tue,  2 Sep 2025 04:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2E268E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:51:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69590BD999
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:51:23 +0000 (UTC)
X-FDA: 83843691246.07.F19874C
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9C1CB120006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:51:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pgQH2Ptn;
	spf=pass (imf29.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756803081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iP4mX/+2DHYze7f0itBbCFIKzjrmdvMk6mmWMpcGwHA=;
	b=cv0hx1QadCZqNe6TrxnGCrYvaEmmXxlcAdt5F8d0hgxXAmG8AWLbup4MKWMJWo8FpbswlZ
	KIdQXoEx8HX3PClMq6pLgluGwpqHhVmzfI5cG7ZF4yR4CbGZgcOXKQVmHFQDVn5L78u8Ab
	ccL7ruFEY+m3OzUredFZv8by+/WNq1M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pgQH2Ptn;
	spf=pass (imf29.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756803081; a=rsa-sha256;
	cv=none;
	b=vN4uzt1U0euH0dZ3FOoPD8xUg289+KSFwYT8l805t9GAa1hVuurb+9nnTmNP/rpyX67mKT
	Q9Nbb5Z+JRya1Pci/CK0F5ir/HS/QhCagtkUiy5put02jW83/YGk/mE+dF/A9wr68oN0lX
	9CoSQIzCmuHZP8NWq6is1O2bvo5qiSU=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b30bb04ed8so458031cf.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756803081; x=1757407881; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iP4mX/+2DHYze7f0itBbCFIKzjrmdvMk6mmWMpcGwHA=;
        b=pgQH2PtnW70Fs6k9STrz7THYCZ4Ppcuqoyw0yTwHdMfvK+MFuIlo/ifzzB4F/kjfSc
         lhzE39qjIS8YQ+kPhPR2+16DrteTo8zOfSp0t/FHj5fb6nehAL9Q1BC3auKua3E0uBqW
         IWBUKtXRHdyp3WODdYCfOYGGy/cPZ36LCVV1n02XUEg+w4fhBZcNOB5MxaTgU1fs+c/9
         Uq+xr5XzShZFwPm30YsRYpFLvSZGV4wrYgQPvdrq+/fvfWX8Q8YHds2SxERa16G4BXXb
         qb7MFphDilVPXIxdrum4NQDLNIJxYG6vIqOmg8wC9WxzOB00NjcAO9/CoWWP+X1F0t7E
         ko+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756803081; x=1757407881;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iP4mX/+2DHYze7f0itBbCFIKzjrmdvMk6mmWMpcGwHA=;
        b=j5EX6QCwTp5tXv1BacxjLPDcjR9xRQB16dZWijXmoX4T7ehijM2dhZG/C/fLcYYhqL
         WH21HB+Nu/lkf5VztUe4rXAhx5y8wGD0t0mrPO2h3oD60zg8+FR2KVMCtUUjy61CNVl3
         3XseArWshn5WaAnB4Z8tvf+3RWp80+jJ7QsPvM9xKif4Wnxsa/v7L6+3H0rR8+qOCuwF
         tdYYLEMBX6XNsEewUrfi9FFLmMfApG2eVsx62BsauLjS043dF0NkJWMF16jUkCH6L/aG
         co5qs7cAwhyC+2xmAek9huuJrepM0l7PDx274/3LkoTHX8trVPcNRPRLRd+t/9YBdnAK
         NnZg==
X-Forwarded-Encrypted: i=1; AJvYcCVkq//S/NQ3D8w+CC6dYTXrl40PahCZ0HoWzWmKuGAtA9jKe7pQM2Z9GFzTpa1usvH/psc3qC6rSQ==@kvack.org
X-Gm-Message-State: AOJu0Yzpwao/lZZwp8EG7AdYHuadA3MQFKCb2d4GjPpDYfQ3VsE3WVNA
	Cqhw6b95xYgl9felbAOjXvHXbugfuuKnV7AR2Zt0Jtw5fbrkSo7qzcO2oqXyOMyIGVJZ823fELS
	9uU0s9E3G9lzvNyktCUJMI9icoBoELZlTu4B3rKB7
X-Gm-Gg: ASbGnctlZnekkcgXJxHvm4WABpqTuc9tzStURNfH7LMtY+kpZU2ieiVxaOYsJLZh4jl
	1Hrh6GdsiR4kgRkwt3XosiMNFQmfj/vIC27ikXUiTvPVDENwToomNGF7nDKnzIur7SLxGs4wXtw
	oTrOZ4WZ3/K94921KCnKGVvMCFXDGyndPLYNybsZTqAObQ2DE89Wwi2zLu+HMAPgu0gmP5a5F9e
	vOBfJ0tbabTp6a0Rx1xIF6VFg==
X-Google-Smtp-Source: AGHT+IEl9wSTHdiJwZPLw2efIYDBOrEGcJPxDblGkQXiafOiZIaocXkLc6odVx1VLSTjodsqJVOs6KtZuN8sumvistY=
X-Received: by 2002:a05:622a:a28a:b0:4b0:9c14:2fec with SMTP id
 d75a77b69052e-4b325008444mr9184701cf.8.1756803080383; Tue, 02 Sep 2025
 01:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250901135408.5965-1-roypat@amazon.co.uk> <20250901145632.28172-1-roypat@amazon.co.uk>
 <CA+EHjTxPfzDk=XmwS0uAtjwsYB829s1uZSMC6x3R6KGQ-SqjtQ@mail.gmail.com> <862475d8-5a4f-44c3-9b3f-56319f70192d@redhat.com>
In-Reply-To: <862475d8-5a4f-44c3-9b3f-56319f70192d@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 2 Sep 2025 09:50:43 +0100
X-Gm-Features: Ac12FXwr7whnN-VXo5s-ZgZo6eW3l7wyHW3APjTTLjncve_-hqyXmzJXVm4lqgs
Message-ID: <CA+EHjTxymfya75KdOrUsSUhtfmxe180DedhJpLQAGeCjsum_nw@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: David Hildenbrand <david@redhat.com>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org" <will@kernel.org>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C1CB120006
X-Stat-Signature: e3me8thyjxzs1f7xpm9yomzs6noxcazu
X-Rspam-User: 
X-HE-Tag: 1756803081-708553
X-HE-Meta: U2FsdGVkX1+ttqJQKC9LDVDX9w8jJDRRXS7ROJXlmXsmdJA1fOV1HyBPZAaEjg54ZSSgyNR1otbvogWPYg7pXX4jfYG4rcZy4yqxkEHlJ3GxmKDE01jMz/HIOtv2yYWFppoIseWWw7D44ZXLp8HMHzQ1X0AWhxsK9r1TPUOomgGJkO7BP0/v0yrKkUoUIxua1HXzfBpzfqIRg7nN6CT8p67FlnPQJJmsIScSSUqLrmleIh/2JaCkv+mKgoaF/Iw89eJ8nVH43U3apHV/MMue/RT15q4javkvx/2Ln/yw0JeQGtCfM2g9rIEbbd6fhleEhe7aMPJVNdpkLoiQYPWuQ44lRRKOX9zDMn50VcklmzqCm8v7XJl8xzDNRGSad9UuU9AugHz4c9qm/oMluIGf1rprOmmhIswOnY3lApYlqYgXM+e6xsyzUoKvKTrDAYahc/x0c1IIeaEnyEb8ulgdTaUBGvfVvfm100r2YeD20AHziiS2Wta5bdWsrh0DoQQLtic2F3izrzeBhpaNcBV3bP+qLSICLWHlFpqxgC1VRaqBoeUbtwneA5H/diXEKR9u8iDF4TD+VNT2gcf1AzoKH/pJwlnkNBWEccFAHyMDTbwUkm5jmFiC8yqAMdIfoflysApTmaaeBweulmj3fGSsJxpnMx4cGYZHjDkZ47V0xjt+9qLIHgI8xbped19YAEjcVaHCETsysv14e/pyEgqjifWA/AYD8BKQZa5r3pDzTM6Kdv+EQg2lpfjyy1qf0rU7zl0tntAAbs8fW+MVbRIe6RuMni9NE00XQrmXfuyU9CylUhThqe1WGwbbmhblbkWBUWDboq6QYpvbJHvf6m0rTuyGkpBMsaetfcQg2JHYFpyRReGhzoZvibdlE/3dnIpOyPF0/1eslzJ/V5z8ueECtDdUme1mPiQLZBfOrcJtVDp6u0jBS8whciHefeddZ2j+H7XbZRcgbv0A6G3jfud
 eRUByZYM
 tU9iu0c6yN5MdzJsHulQXR85F13kGGmebye6kaVYSgv/Z8sI5wl1gt+Ej3TQD4dss8MSoGVhu3doJ5+XhAqplbOiezU3rpPG49xA9MfrjUvQPhIGX6Hp3kOGX2H0jBE55Ekf8Ddq4V0NJtSsgla1CudP8hBTVeRL7/Dvt9sW+aQBu45JHzTu1PKlSL7U56UfoUvFkUSVGkCLP57j4U5rA+6FQ4aW/bm6dBWZU9EEQjBjVNpKxSbqRKqvfmEQcCFE/cfiWosO74xIIjek2kSCf0t2vEb91CSKLSu0DPmfoWeyK5nyUZt+/QVuUWfyXRE4X/aHbTUz3w/s9P4yNtJKguLfK6LfEBqA/HZbelgZZUzarpNrXBXf8kiSSwM5/NPRhgG+Sc02/4kC8d9H9dGNUH6BxHI3lnDMeNw6C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Sept 2025 at 09:46, David Hildenbrand <david@redhat.com> wrote:
>
> On 02.09.25 09:59, Fuad Tabba wrote:
> > Hi Patrick,
> >
> > On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>
> >> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
> >>>
> >>> Hi Fuad!
> >>>
> >>> On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
> >>>> Hi Patrick,
> >>>>
> >>>> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >>>>> index 12a12dae727d..b52b28ae4636 100644
> >>>>> --- a/include/linux/pagemap.h
> >>>>> +++ b/include/linux/pagemap.h
> >>>>> @@ -211,6 +211,7 @@ enum mapping_flags {
> >>>>>                                     folio contents */
> >>>>>          AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
> >>>>>          AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> >>>>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
> >>>>>          /* Bits 16-25 are used for FOLIO_ORDER */
> >>>>>          AS_FOLIO_ORDER_BITS = 5,
> >>>>>          AS_FOLIO_ORDER_MIN = 16,
> >>>>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
> >>>>>          return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
> >>>>>   }
> >>>>>
> >>>>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> >>>>> +{
> >>>>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>>>> +}
> >>>>> +
> >>>>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
> >>>>> +{
> >>>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>>>> +}
> >>>>> +
> >>>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> >>>>> +{
> >>>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> >>>>> +}
> >>>>> +
> >>>> Any reason vma is const whereas mapping in the function that it calls
> >>>> (defined above it) isn't?
> >>>
> >>> Ah, I cannot say that that was a conscious decision, but rather an artifact of
> >>> the code that I looked at for reference when writing these two simply did it
> >>> this way.  Are you saying both should be const, or neither (in my mind, both
> >>> could be const, but the mapping_*() family of functions further up in this file
> >>> dont take const arguments, so I'm a bit unsure now)?
> >>
> >> Hah, just saw
> >> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
> >> Guess that means "both should be const" then :D
> >
> > I don't have any strong preference regarding which way, as long as
> > it's consistent. The thing that should be avoided is having one
> > function with a parameter marked as const, pass that parameter (or
> > something derived from it), to a non-const function.
>
> I think the compiler will tell you that that is not ok (and you'd have
> to force-cast the const it away).

Not for the scenario I'm worried about. The compiler didn't complain
about this (from this patch):

+static inline bool mapping_no_direct_map(struct address_space *mapping)
+{
+       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
+}
+
+static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
+{
+       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
+}

vma_is_no_direct_map() takes a const, but mapping_no_direct_map()
doesn't. For now, mapping_no_direct_map() doesn't modify anything. But
it could, and the compiler wouldn't complain.

Cheers,
/fuad


> Agreed that we should be using const * for these simple getter/test
> functions.
>
> --
> Cheers
>
> David / dhildenb
>

