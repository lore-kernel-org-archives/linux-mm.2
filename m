Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 325ECCCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602F58E0035; Wed, 15 Oct 2025 09:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3358E0020; Wed, 15 Oct 2025 09:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B4D8E0035; Wed, 15 Oct 2025 09:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 309AD8E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:28:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADC35140161
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:28:12 +0000 (UTC)
X-FDA: 84000427224.22.0C3EA24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 95E09C0011
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:28:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O3OG+fu3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760534890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ohP5bxYeHRzlyhWc5eCUSYSKjVHx/TuGy2ApTo4SlE=;
	b=WKu2CVSqp/jfSaid/IiKNY8Mjj3/mfDdd8B4xmm5aDK0KHqmOC7Xtu4tpZk8CAA4to3BTo
	9UBmy44AOkdVYrpv08m1Jm1VQDg7SqmpevDPjCJKkNUDdSMaN5KS+7i2CyV0afA8o0TTyN
	D3n7cAYqswEYxUvTNpoaBvLr5b3OX6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760534890; a=rsa-sha256;
	cv=none;
	b=ejjsERCz6yLTLqdPqPgoyVshdn5LcAyjhvEhFeCs422hH5l0R6ck8HvrA40Gr9UhtdeGat
	C5CU/iZzG/zOKcvV4b0yFVYoCBHI0XqAWSlCKmCgzBYJusp/TrKIn5qDlo2FQkNgSiH2jC
	WaFV9O1XzUr7sHofY0MnCD4qPh0N+7s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O3OG+fu3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EE5A49C8E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEC4C4CEFE
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760534889;
	bh=/ohP5bxYeHRzlyhWc5eCUSYSKjVHx/TuGy2ApTo4SlE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=O3OG+fu344A1YSKJMRPwXbMr4WQuMRcUUUtrc7QP/k0LWVa1Y6McEJf7qogHhTD/b
	 2C7M0iLpO3g/M7iVatpWWatn62RVXNo5seTtTFHLNkb0aCKqShpMLb7hLPvJht+ifG
	 IDQyB9vjw3/ItQnKDcQgANPet5Ob72jLVu4azvMOwEP/LtQYuFE5S/VIx89k6+XonP
	 2XoyzKXt7p94wjnRhHq8pHeKyzYlKr5FDVw00kHdLyhpBKqR23kP69qWzt1YZSufq4
	 stA3tcgkB7rlJijq0YPRDsJXy1AAgGUEfObDZka5dZ2eMthU0lZnZyMKOIRnOggDzJ
	 83VeIojbXrA3g==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-78113fdfd07so36672467b3.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:28:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXpov/hyb4mxZF+Pt4uzMrsGZsjPnWDAh49RqwOO/EGKAlM0rrrc7rWtsXnbPl9m6ihL8CLHH+eag==@kvack.org
X-Gm-Message-State: AOJu0YyGEjxyXlufEpQHGzirOMtMy2/Nkd6ahCjrlvrilOt4DjMNkg0H
	XD1igrOKR+Sl+ar9eyMHp5JVNj4GUwqAdTxdP6RF/lkt9Hauyxek9KWVHU3xZpu8FhX9ijFHSMl
	vUy/sYiY2ZIzcxLv4sD0pghB6wAYPlBE9NBL2XxmJFA==
X-Google-Smtp-Source: AGHT+IEKPlPdZEbJLzd7vbp7PVtYzZjCjFf368H6EX0C7/NdsbMM4sBENNv9td/WaePoav/yOUBW9EvEfDYAZIRFOaI=
X-Received: by 2002:a53:a148:0:b0:636:d286:4867 with SMTP id
 956f58d0204a3-63ccb7ea5acmr18747445d50.1.1760534888261; Wed, 15 Oct 2025
 06:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <CACePvbVDB9-r3dTTAJ8e++1swAt9=fPRK9ex_30L=FgXBe5BpQ@mail.gmail.com>
 <20251015080925.4008-1-21cnbao@gmail.com>
In-Reply-To: <20251015080925.4008-1-21cnbao@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Oct 2025 06:27:56 -0700
X-Gmail-Original-Message-ID: <CACePvbVtt3+-_uW8H1Qk_17sRWMRrdTAoX8EiE=GfpwYkUPJ+Q@mail.gmail.com>
X-Gm-Features: AS18NWCPEX4y-wbUcUWWLixvjab2ynT8JkGWEMy67JPjy7-orxQ2hk71eeyw5tk
Message-ID: <CACePvbVtt3+-_uW8H1Qk_17sRWMRrdTAoX8EiE=GfpwYkUPJ+Q@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
To: Barry Song <21cnbao@gmail.com>
Cc: aaron.lu@intel.com, akpm@linux-foundation.org, bhe@redhat.com, 
	kasong@tencent.com, linux-mm@kvack.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 95E09C0011
X-Rspamd-Server: rspam02
X-Stat-Signature: s5w8nc7kbg7s7sq3of9st6dzfmshk8ri
X-HE-Tag: 1760534890-421345
X-HE-Meta: U2FsdGVkX18WsUE05cGHxhvPXGfwH7ABA1ERTOCGzMJb/p3ftbTM26I8mWSQRbr9n0bUPwW37Y/dwqeoYd/KO5YnwpG0zQKhtBJgSfDFrbCRFQ7TcVh6g75y2wYvnxYHQ6J2f6GcYVGVwl0xx0AptE/p7I++Hl0XBc8+Znhz5Pq/HeB+jAcV4kOSPmK/EAXMvhEL8pFxDidVKHNXaiMKk5B6bioPaHdICWyEG+3WUCOy/o4l1BYgLOvs42KWZdyytyojIx8/Q520oFMtdeIH+nxcsCCncdHVxU9ACcTyAHFrgXHZdKZQza9CuX4GIMklyTe3+GmqsgxR6l6JSFiurZWEGdzIMyHeb2RfmLoWnnURQpm6qOoIx+wH4IcXJ3bJvwVfEwps62I6FMYSwJOm4TIEqxgZPS7loQFgDOt974VIpYUBO1HnogaFS6F1dgEGe58jVFwA/e1M9L++acBixehNSaAQoU67mNp0Hl3Fvxp1ZL775cwYNqnLdroHTOAzNsvLHJAAWw9YwJzqnjfsyv+86jJo92PTMx47Ogit2LJMdZJK/cx5FIYm2J+6wMpO7WnoXpWiRKsB4pNrrDolB3XtITO9oEJtbCnF7OF2soGBSzSJxOGLpvwbowuPI+dw3z9t3gEPrW8n1Bo+Km6OLRhih1x5vuaGsp2IVVrJANcUazQjw4gTxwlU2ZatcCi6AMQhEAoSmSUnsj8clsrvTRXBeckyJSBQh5IvVcCT6O0gevQTE/18+0X3XphqKilrqLV+JncXiNIRBCnz2ri7PBZxCrlczU2g6TSm6R4v+t+VQZqMeBkGvRT/oNIbAE6lxjsNbxb2MxiXSeF/ufhAKhoz3ax7SGtcmPy3byqSJkTem9WUdDqs9ESWOGv6oSFtrDaLgi7vPUKl3IEINIFiECDxGcEcfBdD1+TKgKpO6M34c8SwaLwzYLbIdxwV0bjbzX03wBCOrG1iLQpevF2
 4ay/ElBj
 r1AZ7VnfJSAIbm8/ELM27BqeOADNNuWmh3avLo6hj1UUzMqoHp8yJoREu9Y9fXzSsnqyImrU241B4x9A5bCLs3wHiiX/1uhyTfmDIFRK8e32SjZNcSLIviuXo+uPB9o3agQ31SZxqT8B78Sf0EyDg6vVHRyU5BvfiLsotb7rWjyqt+WZMweGVZwO4fpAcC28emFivnMrL4zzvvmC8FdNQVmJQapTV9P06uHJ3hgFvT4ujxQHkaYIGVkXm41pbVjMHK/DiZU+8wwINjo/wx0uu9ORe6OG0RfPf3hMKR6mNiqdU/gPySn0UEfI9yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 1:09=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
> >
> > Optane was not even supported in Skylake. Commit a2468cc9bfdf has
> > nothing to do with Optane. The Op]tane talk in a2468cc9bfdf is just a
> > red herring. I fail to see why reverting a2468cc9bfdf needs to mention
> > Optane is obsolete.
>
> Thanks for the clarification. The Optane discussion turned out to be a go=
of :-)
>
> Just for the record, this paper [1] also mentions that accessing remote S=
SDs
> can significantly decrease performance. However, it is rare to find any N=
UMA

Ack. I am not saying NUMA is aware SSD does not matter. I am sure it
does. The question is does the benefit in real world usage cases
justify the extra complexity.

> machine using SSDs directly as swap files without a RAM compression front=
end,
> so I don=E2=80=99t think the performance penalty of remote access would b=
e a problem
> when choosing a direct swapfile.

The per NUMA aware SSD swap setup is so hard to come by, very few
users are actually benefiting from it in real life. You need to have
each NUMA node a SSD attached to that node. Also each SSD on the node
needs to set up the swap partition, preferably the same size. If you
have only one SSD setup the swap partition, it does not matter if it
is local or remote, that is the only SSD swap can write to anyway.

Both Android and data center usage I am aware of do not satisfy this
per NUMA node swapfile requirement. If anyone has a counterexample, I
would like to hear about it. My conguesture is that this setup is so
rare, it does not justify the complexity it adds to the swap core.
Especially considering it has conflict with the swap.tiers down the
road.

Agree that nowadays the zswap or zram is the more common swap usage
case by far, the SSD swap is just an overflow secondary swap. The
local vs remote SSD speed difference there matters much less.

Chris

