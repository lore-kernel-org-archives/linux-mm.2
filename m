Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 685ABC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 04:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377C16B0088; Sat, 25 Jul 2026 00:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3285F6B008A; Sat, 25 Jul 2026 00:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217526B008C; Sat, 25 Jul 2026 00:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA34E6B0088
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 00:35:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 557E0120266
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:35:17 +0000 (UTC)
X-FDA: 85026034674.19.677E959
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 76B8880008
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:35:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a0xrF3mv;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784954115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsaTBfu55V+jF7MXDxgG5KXQHT7/Yb7ASTy7J8iGFfs=;
	b=UQzdurLEyvTCJqrWuqC513YEDpGkLBYfl3u/t3LOOtjC+0hBOVIjESakNGDKhIq7xJax59
	9NQIEorqU2HlH55Up0wBq7UWz3JOgBtK9urQKsavooKU3mshTNQNVU9rgakZrgyLIG50SI
	H+vQJS+qeYPq90iUUKYgATqFlTJWrPs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a0xrF3mv;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784954115;
	b=ggFHRufC1FmjWhFka6iWP/WIM+FLl90OYwYT4H+sQoSC0I6BWKUb4afbz5LsFR0ZmZ/QBZ
	n7WNhhvwrQ9yvDFnJbHwrUj2idibEiD6kEw0M2atl6iTMyzkeAC6Qc/EhVAl7p61XP7g6y
	JKBZwivslXYr+VWCY3F4jXQ9JhifAZQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6AC560A80
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5CA1F00ACF
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784954114;
	bh=qsaTBfu55V+jF7MXDxgG5KXQHT7/Yb7ASTy7J8iGFfs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a0xrF3mv/imeEoVSUdmboKqQhnNB2wyG4079JOyafxrY4aMaYcqcnPYJZH0+MyjAj
	 oI8P/wVzDh9wUgLIfo1PKsOPxwxIHLKyoqnVS2HU/G2k/VT1ErGm2sFy9Gruoe6RRw
	 VIBLaDNSzrIKdHzBAMA70yEZuMGQcWyIImnu66WF+QTGzqVe0tlJMeRaRHlhu2C92v
	 h7u0E2V/KmqpmwyIshiv5p+AWIEOuq/PYgyqh/IJaSQWZsYy9X1S93KRoy1kg/CwGx
	 ahRg563fze2jMUUDXMCO7FKIUXii/9wY6LcrYIYydhsbbmo3nNiT+qBnH1DU7ctUVj
	 iagBSx7C9129w==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9309d4ea213so102741585a.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:35:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqaismUiXz4xu/8BYUh6RFV8eId+n173RH8/OZ0YNyEOswOLsIE9sacIB8objbnhdL7FWTneaSlOA==@kvack.org
X-Gm-Message-State: AOJu0YyfXu4j/1aoPDku7xajIGmhwz+t4XDZ9V0TKUoxeL/QqJg+gX1o
	KomFo2cJsDR4IOgmTFrOren6vNICSYt/4viEzv8K0TF4K89biFOBvjTZ+bTNDk4xjfBWZN2C7J3
	eqnBjD+8rBYVsHT/gcP68BW5ADAk6XtM=
X-Received: by 2002:a05:620a:2806:b0:930:a212:2712 with SMTP id
 af79cd13be357-932df68a7e3mr81582385a.54.1784954113581; Fri, 24 Jul 2026
 21:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260723070905.3422276-1-dev.jain@arm.com> <20260723070905.3422276-2-dev.jain@arm.com>
In-Reply-To: <20260723070905.3422276-2-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 25 Jul 2026 12:35:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wCh8igrhiygETBOKc-2AXkG+DYjmAwm_3n5dm6FLgduw@mail.gmail.com>
X-Gm-Features: AUfX_mzaWCVWY6soSKp7-78egYXC6lSmKeaUt7S4hiXiUxoPMgD7c_LYDqwxpYM
Message-ID: <CAGsJ_4wCh8igrhiygETBOKc-2AXkG+DYjmAwm_3n5dm6FLgduw@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm/swapfile: add batched version of folio_dup_swap
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 76B8880008
X-Rspamd-Server: rspam01
X-Stat-Signature: 6ykzro5dkuw38gpzjae73suo81ceijjf
X-HE-Tag: 1784954115-566648
X-HE-Meta: U2FsdGVkX1+cq68Vi2ZVT9XOmBEqT8bd9H7+DoKnSCM0uF27hD6tEMLPAwP7c3pvjHoyZ2/dwkOnbd+zIABkJ0CEcMe95liwYT9WwX4hVoYppy3FKWPJMtOsDxqrzBcd2z567t2OT383QELliMCr3jNQxJYR6NkMeLLx0UyUlr3PiZ05Kfs6LDRP0uJfBQbrKhfz2Ewnnwb2GvEhr5Kt2XSBu9ax8jO+icfBhTTxLa9/omNVCosZpd4mVLM+fsmK2SRERc7mwoJ1yo/AKQY2Rb2tG/Lq1hdYCaxVOhL2VhZKjGBX4URlBlrY+uEmC5JqK1vX1P7vIvlBp02kqTFap/sJQ3OEHuEjIvvBpJjUkK0kkLQIH25dKjEOoR/K0DlqbB2FXblgQ2jV9m93Eik/nLxoY+d7V+DgrzggYFYnxNR4L8wmaofZAKYH5vApB9bgA4o0wmDhiyTvyHyWivve67dLbrwsCYpG0i/xgJSIDOStPiN+WJgKvPAO63LCyNI7lbPsILKwNIds47yxqJMA9Lnx26wkGXIoU91n40CD1uJYdlLCCAHMf++bwQJCh1ZYIMj9ec2aaptHXbw8PcICc8Tqa/k0jGD7mgz45fHaKTICzrVL/+1lu2Qvt0gblM0P/AW595zCswondVZoYjVS1a4bMGQOnVvrxBQwOg5YSHxk8f5Bi6C7qd4mBD+l0co/nmkHlIsWNinHx44rQndA5wiZbDohzplkFZ/OZKZajA3ZJZeWBhWdTfiR0A6uOcZFr4OJcBS08zAOs6AcRoqdQ0QhkCTadHvQ5CmF+n762ERNuSAR1opqx0vUyXc4Mu3dVcLenoDIeNQV74cddjNPxVRo++vREBrImVZJw3JT+Z18+dc48BV+XOvydNMupFDRGio7USe49aS7zFliiPCC3GIvCIqCLe3p5TDZx5t96EAI9hM9glc8mkNZS27Z7Juc8Gb3/9MYquYG1XjceDt
 /OVXbOm9
 Y8bJZK2F3/BjOBpHfpu1I4SN5XFt5yy8ZhlECg53MCH3z/xLWzFo8S3iAIb8QZr3C0IkjoLuGD0CK3XbEIW+r2msw/pVYddtFzYejGmVE+CmgfK5W9gxjmA+wZtnbJLOlj+jPZw6z0q9qqwbPS2AHPyxrjhBTQOOBOuh7dJ2e88xacZpGtBqMtLRUUoQyJx78dNIipPPYKfvSHntoqR3i/iAuaBd8kWg/xaMGsVsvbUHd2WZFlDTfhrQCYiQEVbZpgJqOgssrBMYrbCIUUQPgY5urjRfitz7r0Mz1VEnWjrBDPDaYDLVp9ze5oDFEEfIDIeoPlevOP/evOgLWJJGmykCEZXJ3XJpAmQgSilR3Vc0J02Xxqif4U2/CwogrxnR5q1We/Tf7BYkSryPqiyd7Ng5Izh0bXHKrk9pT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 3:09=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
> that folio_dup_swap already can handle a subset of this: nr_pages =3D=3D =
1 and
> nr_pages =3D=3D folio_nr_pages(folio). Generalize this to any nr_pages.
>
> Currently we have a not-so-nice logic of passing in subpage =3D=3D NULL i=
f
> we mean to exercise the logic on the entire folio, and subpage !=3D NULL =
if
> we want to exercise the logic on only that subpage. Remove this
> indirection: the caller invokes folio_dup_swap_pages() if it wants to
> operate on a range of pages in the folio (i.e nr_pages may be anything
> between 1 and folio_nr_pages()), and invokes folio_dup_swap() if it
> wants to operate on the entire folio.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Yep, also I like that the page =3D=3D NULL case is no longer needed in shme=
m.c.

Reviewed-by: Barry Song <baohua@kernel.org>

