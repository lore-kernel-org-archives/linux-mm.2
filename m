Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84926C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44A66B0108; Tue, 30 Jun 2026 10:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1BEA6B010A; Tue, 30 Jun 2026 10:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0CCD6B010B; Tue, 30 Jun 2026 10:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA2F16B0108
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:58:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35D84120301
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:58:10 +0000 (UTC)
X-FDA: 84936884340.29.C240758
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 149C514000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:58:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MJ7PfuQt;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782831488;
	b=uUdhWbFY1y5p9tC3jAF/Usb9wq9FOcBDsAs6EZQ3xQ53NBNLSivonaHFOg93ePdstVAwbB
	h8iBvOvu1ALrIgb4x0XfpaC1yTYvnFUAiOSbfqyJQCRH1fkZp8WE+swAN9LrCPlfaJtyhv
	5CAs1jjZztGt+TNODptIkriNDzR9UCg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1i5m52ST6EpL9UMZssXZXzJo3HGs+EdTA7p5oeCSyuE=;
	b=xVH7KDn75D7D22Vb7fgAFD6ZYi3W6vOCd0oAkiPtFBXxyMnHYyzkGP4OW3nRd6H9VyTthw
	yXM7WIxXDDzJ5nbg7Ucsn1rnwPfj3mJKm3RfEw1IwhNDIAoAE4Azv0XdEbR3JVuvSne4y5
	AdjFuCGNVZ2slFLgXd/TgTddDQqDtFg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MJ7PfuQt;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-664d910cc75so2425380d50.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:58:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782831487; cv=none;
        d=google.com; s=arc-20260327;
        b=R/9QPUMapiqertcetKhk+lD0uv2EdiAfheM/FVDXwUt2B9lbf8dkclOecXxyANWLgI
         hXEGjrMGSIQlAVJ5gJWvmR+Tdz9YsI/yPvcfO2rBbcfiuIvenk9BHNBNUkhLYorX8LyZ
         CV/IsNhL/p3nZTorzy82c2l5cSvwUhnHhOc1HENXT8gquJFooQbkRnDHpGZJ1wSz1xBQ
         mGysBNmYLjYLDM8mXwUNA6KRTVm0U7IiscvnulfrNHdoWJojCkT+RGn2C582UvbYd3AC
         pNRnPVfwdcUVPGFsdHJocQr5GGB5Z3Eo438DHaVwJqKOhcZId4Xakw+x0F1j00/A9KH7
         0Cjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1i5m52ST6EpL9UMZssXZXzJo3HGs+EdTA7p5oeCSyuE=;
        fh=y/EFhMw8d0r25/mXxj/kU96L+rwmP/eYYHDNcPaKUZM=;
        b=pjZm6fLGia3Kx2W8cSz6uoSruc5f7hagP5iK/gzh3bcPvyqsNuxkRh33sv4en4TmnS
         wwsnP3B6bk34kzlDJ3djxdH96gmoKCtI46DbDuTzNuCd5Cyfq41KRtDTAarOB960bbRp
         tZ8YZ/LqIV9oE51HFwAo9oZQzJ68ghCWlDoeB8sUAastpIBG8cw45eSircYleZWMYEuz
         fKrF2ezRte2VQBy3XgmU/EZdKxT/suJSIRQrTViaJfUuLZ8n9fj7KN/Fb30dQ5T+IwBv
         VPP4MFE3oHrkXsvPHiopqJ6wZgGrMJof7nBzMRRNq47VBJLBKagrZ8G85JOCfX0XszF+
         2dsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782831487; x=1783436287; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1i5m52ST6EpL9UMZssXZXzJo3HGs+EdTA7p5oeCSyuE=;
        b=MJ7PfuQtnMTLzzcYFtalPllH3QDLD/ISkGHba1MXFsi29ZKrCf4PhqA54SIRYxB11v
         UWfG6ZyF3UQQHMxs9e1STil6EGZBsWKawWq7I23jTU10Br5GQK60cGjMlEsZU3LM1pF7
         q8wQrZAycBz3kTHnqZwYnTCw3pvyCqGhEhB7KkKvCJ8/QlNmnPK/fLvM0VumkgEmMhKu
         pP8mbiG7J8nGNZZM4Ky79uopvLWZv/V0Ie37yQaAIGgDpZKsrbrGFWzBhYbgQBM+DlNj
         e9epNTOJydWCjuo5u1A4/417NkpHfpcMiRdf6s2uT3soVNqq7fmhADUq4E7oiOwHac23
         c/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831487; x=1783436287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1i5m52ST6EpL9UMZssXZXzJo3HGs+EdTA7p5oeCSyuE=;
        b=aT82u2VnyteQ+RkVOJ2xU63fgj2A6uKuCPWnDPrnNakIcAEnlSZzwRqdp6u5a7KllK
         2XAPBZM4X4DY3jh/3E0NQLGhEoy6oF0OKJ9/Cu9idbcIR7abUxch1WY0kSbwlevWgALT
         lUM8XoP14XbcFLy/4ZPLn93gnbIaKwJj6jJDbk/XX9TbrUteffSPfgq05W0V7HPvrctL
         jL841QQ8foJmDsLOSw+PfQh0LUvRSTJ0q3ktHJ4RFJotX2fXkpZZrpUTPjqGMwtAYclL
         eucAAz+5DyAtEP0UZOQVwPS17Nj/u+wb4nrC8L1Dk+XrjxxFzve8iV7ihDYeGZHeSr3U
         8j2Q==
X-Forwarded-Encrypted: i=1; AHgh+RpMmj0Fsgpc3YqAxJkH1HZLZ3EEle0DVm/dYKo6FLw381jNb7gtb3YK9DJU7cXRT6GAvDWcQuzxpA==@kvack.org
X-Gm-Message-State: AOJu0YzTCwDNYQw85x0Y5NKbDAhjN60yI+0G/zp/wsvOz8dUvtiTgLNi
	5fIWzekJtNIEsowMoIdswvqv+GkHkauZ/soTdPczf4wid43A3AVG1LHGHOV2BXkEjhFroDXBIr/
	RKRp+v5fsQy0ki91EKpzfW/STAV3L8BQ=
X-Gm-Gg: AfdE7cmcWy1a+XjFw1Z/pOolZnX6Qm1yN7+VmbJgLDiNwoTwXE0Iu+kdM6RYgX4ZDBG
	3vqVoP5YVXnqHrM7tEkbFuVQ4LTQrgqVyJLhCv/cwpiTeJeAo7n7AHjLO5OmLCDKjrFNgGYsTtD
	FZoBRVZ08eC5cjteixH0x28F9D6l36mFpxChrvtwuJX1VKdVW+IaErJZ4t2DD2OsSxCHWpQa1bh
	Vf96d72r4rVHZ4/3vXUYg0VWMuc7oRzBcPRsFsnzj4tihLAHamikohgPmxICRjYxFbxMQ==
X-Received: by 2002:a05:690e:4890:10b0:664:ae6a:eff with SMTP id
 956f58d0204a3-664f9a88416mr3053923d50.73.1782831486835; Tue, 30 Jun 2026
 07:58:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260629163736.1606688-1-ekffu200098@gmail.com>
 <20260629163736.1606688-9-ekffu200098@gmail.com> <178280792630.625070.17772458635324199462.b4-review@b4>
In-Reply-To: <178280792630.625070.17772458635324199462.b4-review@b4>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 30 Jun 2026 23:57:55 +0900
X-Gm-Features: AVVi8Cc5dxVF44L4pjP8GggRehKWweoSNEguGvU5A2LICtQ33URIWMVKjlZvjTw
Message-ID: <CABFDxMHOM+n4-YS_H9j-m8Bp87FEQuH3SOukZJqPBC8mSTdUTA@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] mm/hugetlb: remove unnecessary empty range check
 in hugetlb_bootmem_set_nodes()
To: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 149C514000C
X-Rspam-User: 
X-Stat-Signature: r56dfapnpwijinftyd4k4ot5yte8zk6i
X-HE-Tag: 1782831487-816481
X-HE-Meta: U2FsdGVkX19KslmHXKAeOqA5teJn7QRrR8m8ayaz9FUQuP4cNNJNVBwcIbvNOjeh0Sj6JMEthLxLxBEQ0peOUgAbBw2ILQ4mcyNHxGbW/GeItkGklK/dz+pB2MB2lNS/j52/o+dz86qI6cs4kEXBO7eNa9I0LE6JgVsdsDeZtNL9trnxd/pxuTyz8ZhlwKNbRpFlypI/PIrrDJQY+TKvChozqEGGmSbxVaQiR5r87rFlHl65MoZxjdyBje7wmVPX6gTbfIUPtQZ+R5qxQjvvjx+izaKn5nwU3Q36W/WYnSnIm59pmq4Vj/afBkYkL3rFoOBJhEXvFYP4hK5dL3C0V6bt8TG1dQeMDIAVKf61fyp5kuiTbZIrtKXHdjUYnABGjHTa1NINwS9HmdpLKQJtvCoRGj8heNVmAYIazInUZP+TQcea7vs0Qra7ooN+F+JxiGDdYn6fbgYyYnFP7+E00sTsu8L3vqa8KSQFSBflFgMQNx4u4SXgmqpZHzYrQVlGSM0pcLzcJqAnIW7f+jyn2UknvvdYIHcUiTd9PtULY1188IgLIVvk2qvolYZEjZABGXdW/3mGByZQrVe+XD4nkLwk6Jw4BSZLlH4cICOvbQtAeY5c6hbENlMdXQaXmj1V29n9zsBubjZi7aLOS0Rm31zqDGLfonod549tPtbNR/OGjgRpLPylzJRwoBCIYDcbY4ZlAeFammrTVYpPuy92427qHNoCB34TE6Vdx6beiaNsk0qcfllF/bGe7PeLb2COb1j3TPXd6kKDKWGRptchCF/BDEVyzorVJXm0MZYPVsB36X53EnXWRtel+7SaRuh+CqLLHS22LOKKIK4OebgfRutyOZAMBy3ZwwXov0umenOAKmMKEVtqWRTt0ewwrffBGY7MyTxM8TE+Ju4Y6izaGcqbwf/IzJdtum6Bbynao7TvEGvxHxbyOWINHpHcZS33fr6gNEK7o3H3Vkh/1ch
 XP4HRRuA
 xNMRXIq6PdSn0Tusct4CqF9rpepjaZvwz059aBLzfti7Kxt1pAoJcnL+1AfSadufMeqApJwXj5zGTs9i1PTOW7qQC+Fvm1lNmo5I83fqwwVD09LK0V2A6c75R/CXmbr3PVNF/qO6Ra7wGzFZAuFwi7bkCYm+0nv/T4QO/TCodkYzW5Op51292kQS6TIrZQyxJaQNtlzGFgoXQZIVflw1oN8bixgYkN9vsu6xyoVUGflT3AnvIh+aWguop9bfjFNCUZLkuu/Dw4mJEMdJ6I/90LUn3A80uVhjWG+Tb+KBU1B9fig5adiZlt8bdHA3FxTsZmvdZ4UkwpTpTUQh6kK476AMuCeVneCZuc27a/gb/PY5ASmkaZ3BrjA569bw1iaq/0egeNqRuPMEjPMiW7UKPeQBP8FiuXyp55rNWd1LM2Q2qXM458eB9ZYCJRJVYg3P99ans4XUH+TgYfC9U/q0hmiu5r3YFX807h3kmYtlOXTnxXoLUyN2ZESR/3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 5:25=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, 30 Jun 2026 01:37:36 +0900, Sang-Heon Jeon <ekffu200098@gmail.com=
> wrote:
>
> Hi,
>
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 571212b80835..d4d4c9df5f51 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -4450,8 +4450,7 @@ void __init hugetlb_bootmem_set_nodes(void)
> >               return;
> >
> >       for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &ni=
d) {
> > -             if (end_pfn > start_pfn)
> > -                     node_set(nid, hugetlb_bootmem_nodes);
> > +             node_set(nid, hugetlb_bootmem_nodes);
>
> Sashiko says:
>
>   Since the check was removed, are start_pfn and end_pfn now unused dead
>   stores?
>
>   Looking at hugetlb_bootmem_set_nodes(), it appears these variables are
>   populated by reference in the macro but never read in the loop body
>   anymore. The underlying iterator function __next_mem_pfn_range()
>   supports passing NULL for out_start_pfn and out_end_pfn.
>
>   Would it be better to remove the local variables entirely and pass
>   NULL to the iterator instead?
>
> and I agree :)

Thanks for pointing this out. I agree as well. I'll address it v3.

> --
> Sincerely yours,
> Mike.
>

Best Regards,
Sang-Heon Jeon

