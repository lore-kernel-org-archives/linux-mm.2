Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4C50C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D848E001A; Thu, 28 Aug 2025 08:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECEB68E0006; Thu, 28 Aug 2025 08:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95A58E001A; Thu, 28 Aug 2025 08:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4F6A8E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:52:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F758564E4
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:52:14 +0000 (UTC)
X-FDA: 83826154188.08.EE55549
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 243D7A000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:52:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=UZ24EPJ0;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf25.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756385532; a=rsa-sha256;
	cv=none;
	b=uBmg6K+jibLYVKLNThPtzIOlQG2rFUa7IvUVGImrCY+ysW+EQ1v6h/dafICrkniqVJ7Xg/
	E8ezNRKdQz3Bha7o/DSLLBHpJxDyNrJdWi29lf4gbicIQ+tCGhdM+/OMtTa6jj1poQVryn
	hYiyeNNTQARZ0d7Do7YJ+aEMYizPTfc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=UZ24EPJ0;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf25.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756385532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ho1CxaGu4ava7iJtRknlMqWJKlv0JrGEpalyeDE76Xc=;
	b=dJif9BIRg/tLtgTLrriNki8aK2gkNo48IO2wl8LYX9Nifp4CQEZLN0ylQUmzUqFxDBkTlh
	3mSXeNyM66mkla81SEkg9P8pmuVvQFPyk/IamAAtkb+RIV4c6AL/HbYgigJqOkziK03By0
	bLlYDuTcVYoJLncQcprwIhcj8CbzEGc=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afebe21a1c0so139127566b.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756385530; x=1756990330; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ho1CxaGu4ava7iJtRknlMqWJKlv0JrGEpalyeDE76Xc=;
        b=UZ24EPJ0xQ03yjhbU5cTK9rYicQom+x783kbSkTvs+/mizG2/NHJLK91sY0tQn0+xc
         DmouQSX4t42lA/D1luD0M1u78FMW0dYZxrWeEuGe+OzWUGrlA1bSqPiNlnUlc7jnldsZ
         ZnxrfrrRnpmCspxXh2kH4Vb2BQKPvjuC/4smi3moi75fBPUIOLByVGJtLBXeBwj6ReCT
         jNToYc941lEf2WPjkzoh0nIquCePsqrkcppfgQF5pxBRxbzd3TsvRsGduClSlBeUwvmx
         qBD3Ke7ARZD1WUPxZHWr8LpBqLYOap4EXxdykdcYGejw9lMw6mWXMiXpkT40plsdd4jo
         49FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756385530; x=1756990330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ho1CxaGu4ava7iJtRknlMqWJKlv0JrGEpalyeDE76Xc=;
        b=DresTj6NcjUqbqXLGCHdK7L0Uhx30aP2m3GEItLhmAeiuDcKWIyI5UYnl5TKR3us75
         3EUvz02XB70jnpDMTUbW1qzP0Bvhq1cUEtH0dSagPhBLIo3y8S1UKziQ1WCOMSfKWp60
         sa/Nq+OSGuLmQwQsa8AX+nOfi2PY9IkiPi1rDaukdET4k9thKiL3wKmPaJxDIl1akAR9
         Bqh8yD84fajyyo4SqpXTLipAeGYQ8hSxa98tGk9LnwSl7mIQtRIfc4tgS6ZZxfpdS3M1
         D++I/BWmN3gSjSmOb8CnR9MU5oNmPqLB2NawOwz3Rmjyn/lO78LLTWkCnN9QQ0y4AW3z
         Iplw==
X-Forwarded-Encrypted: i=1; AJvYcCXhEBjnh3aKJbak470vyoPNVHWO/B5hsEUbpOCzEoBtzNSHkVp4OH24AKEcWN6dHhznlCVL+/Rm/Q==@kvack.org
X-Gm-Message-State: AOJu0Yywc17QhxpA7uijJFcnqIj0qI8EPPymiM6pR2m/Zv6ZyJcZKbiX
	z6AKM5qu9ToEt41GIkod6KIO1x1U+74xqCQLRdPy7j/ZfTgjCk4txlhzIUWJJlOhbF7rqf+mcWH
	cMNV73mUEzXrpwefR+teZMB2FucXrm6QN9oPhKOiPjg==
X-Gm-Gg: ASbGncuHwRnztwEtbmZ4k4hdbN7atiMM8VaxmucgB6CRP82yNHqrJYleNpTZjEwKdXh
	WYGkmjDRzikyFyDwQY01I5dGBR8cJcIOkd0xsUmKg5Z1pQGTmpXo0A/ShZskuqD/xLd1lJdXxcH
	3KxhxEC7a65l14p8z8aUbjoa3R8bog9RnColphDP7h1/c0UI+zq6KA8XMSKwDIz6Wie6MncO1ru
	H4VP41uqjI/d7xdLuzeLHOViIXqmKfh2ZN/XW65RSBs1A==
X-Google-Smtp-Source: AGHT+IEUruiZnTPAQ2kjE5R1Bq8XvMTsAfpPl72mQjQ/ziygxxvim0xmPbmYHgr42t/epiUOqsMoo++HpvTafksgVXo=
X-Received: by 2002:a17:907:3f9a:b0:afe:d21f:7af0 with SMTP id
 a640c23a62f3a-afed21f7e3cmr416615066b.14.1756385530015; Thu, 28 Aug 2025
 05:52:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250827192233.447920-1-max.kellermann@ionos.com>
 <c688a2f6-375e-4a00-8d44-6a833e3d30ef@lucifer.local> <27a21510-e9e8-4eb2-9e26-618c103d49c6@redhat.com>
 <CAKPOu+8DbXY6wT_8gcqLDpyZEg0=En6wOYtHX_VkUvZ_oOLHSg@mail.gmail.com> <372a00c8-86e5-4a73-a1e0-ffb8502ccee0@lucifer.local>
In-Reply-To: <372a00c8-86e5-4a73-a1e0-ffb8502ccee0@lucifer.local>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 28 Aug 2025 14:51:58 +0200
X-Gm-Features: Ac12FXwHbjxQ1bdGFj6fLXNtPwEhHCOjsF1A3h1FX5zol4wRdGxbToDVPzAOT4A
Message-ID: <CAKPOu+8esz_C=-m1+-Uip3ynbLm1geutJc7ip56mNJTOpm0BPA@mail.gmail.com>
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 243D7A000E
X-Stat-Signature: hpigebfartn7o4xc8jq17nj8bt65j78h
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756385531-268871
X-HE-Meta: U2FsdGVkX19b9A0JUM7BYLKTcJUSNd16sOw0XRyYUkC0ADQmXmGMhtA0QiWCbwpOA30guBKHa7breBgXq48Auk+MRvXfYr76XHOb58DwqGiJm1XSAGxo47cZvCgiNJ1yjZmtOuIMeYE/h/zmjy34iNOt2wq+DPS/FGGSx1S3QdtOGzXwKGJDe5WRfQnxoLfpdSXEO22hjL1xNZCCx5p/iV4rLXFVUZEdofQevzkSJBepIV0PlGsPwrr22+CPJrY/khz5h9fD275M8R0ccntnDpfifn2KIG99apEl0kQto+PF1g5GOdgyTNS+NkMkcxWt50bwA9/9Rpd01B+VtcLEV5XxW38euRVLGlmR3pPVCKzOuWL2SA/t/qp/k+UYNuNIEkWJjO4rEnWKjJwaaMGGucXDK3mkYDIkJnUtGOmv8pQDEqaLDUPODNqHObyPzaPK+gple4XORAgOaejC88K10Ae3zK36XRZIgYHUmOz/pVigzSV19984HZH54rwIHT0UAfMiZQ2MHxcnHJXdtfRKJ9Ue/RGtyT14UjHLSv4cbn/Dic4a2MT3+Dmv4mSukCjb8E3yYjepUP2XUDv/dsFyu6bLuzWANGXnClYPzN0SAJf1Fh6eQYyTAg/mjfaPgtgeIg1I+WOqjOOrI6DyoGpz3oPZVDkBVJ+CUUZ3z+5Df2BwYEZAioNc/kCW62pHL4yMkmXcFfFsbFvREEOMpo6yJDEE8u9dANUKMp7OjnGZBIQnb/ov4+10qjcxLPU6E/JGilGpsqJfZvNo/HmHYrKBNEJDcp2EAlzoxGAN3uy9q6UMTzmmoHj2q+15ttTi0I8ygvbfF72/v6Pk4yR6sPR8JYGFLx5H1bmzGV7e0v+eUlx4fsgSzNLG8ZISaAUoZkiR5IaR6wpzOmLH+p6FfiqYBGKtmGpuG98QptkQnk/g4qUCTXJ+Sb5Uln2j9Oxy6Mcv4JMHOjzLHQDVBn3WWE3
 fTzRy/f0
 IUKHaUY8CdILNTBSGbHo4zhBxn9uiE+6RxXfKxYNleXAdF0VS5TbAjpE8r2Zy8d3P42iOZ2g+BYst4i8NPaEmSYnejNEHIc1ZUaLSmEpbhb7AeZ+hm7Qu2eIGhV3JJdrvGAZYJWTJ7Qcw2MuStRMdfFkPrTpnv2fxvOV7kJd2/9NualA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 2:43=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Aug 28, 2025 at 02:40:29PM +0200, Max Kellermann wrote:
> > > On 28.08.25 14:24, Lorenzo Stoakes wrote:
> > > > On Wed, Aug 27, 2025 at 09:22:33PM +0200, Max Kellermann wrote:
> > > >> For improved const-correctness.
> > > >
> > > > 'const-correctness' in C is extremely weak.
> >
> > "const correctness" is a commonly used term for this concept, and I
> > find your arguments against const-correctness "extremely weak". I
>
> Max, don't speak to me like this, it's disrespectful and unnecessary.
>
> > So you suggest splitting the patch into many? I can do that, but will
> > it be merged then, or will Lorenzo be able block it? Will further
> > const-correctness changes from others (e.g. Willy) be rejected, too?
>
> Also this is totally unacceptable. Speak to people with respect on the
> mailing list. This is not how to interact here.

I don't get it. What exactly bothers you?

