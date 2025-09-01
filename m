Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD463CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E038E0017; Mon,  1 Sep 2025 06:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E808E000B; Mon,  1 Sep 2025 06:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3FB68E0017; Mon,  1 Sep 2025 06:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCCFD8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:54:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 805081407D8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:54:55 +0000 (UTC)
X-FDA: 83840373750.05.C10DE6C
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5483D1A0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:54:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=iHTXAk6K;
	spf=pass (imf19.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0cJUednc/5M4WDwpNxVBOifAr3cOm70FaB8K31QTbM=;
	b=loldfohfC3UicNZVrKPtfy3391ti2hHd7Q3B6ufRACemzMx8MCRQGg1fhbIfsSIXctOlHt
	yHOjtokCmnvJ3CPq3J8nOvx8xJjcO4sZqfuslHqR6SGiX0qEmXx8Ci5Hr+x3My5B36MBc4
	fu+c8+H5mP7Iz59RGQBdkTX5u7LcOWw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=iHTXAk6K;
	spf=pass (imf19.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724093; a=rsa-sha256;
	cv=none;
	b=LzoZ4W/3R0c2okLmMgs5pl7W3UaL6cGCc1fRSmKW9S14W0YboC2V2K9T9XV+x88wzxxOMP
	ls+JV72wOHGJEuhR6fb5Sk+yYdosDIs61WCLcDZqkSNEkrdZ+jHpZkMLPlDAiyjXah8oWa
	v4/GYmq9E5k/owY8ivKbWkiKK7htIQU=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b0431c12df3so103322766b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756724092; x=1757328892; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0cJUednc/5M4WDwpNxVBOifAr3cOm70FaB8K31QTbM=;
        b=iHTXAk6Kp/X4uyC12Fhp+zEz/I9O5n9PjUX3E2FvX6NhRZjZYO8oXxJIntlwc8dLO4
         ccwzp/2G17X+6KZuHmJukuMJHGpEFpt2uxmI6zFDgZAZudn1lBu34bTRAkHS8HQYPGVX
         1oQ41eE3NtkdbMRRjEckLcJYQaFbGzxyOQ2mS5uyvUPx5UnC2N37VB09R42hMt14VC2s
         u32iYUHNkWM+s3hy/zaAoDeaYWOqedyjDvb/+LLfjp689BhOmop1iLO2cxwSgGrZCuie
         hOYqnjCJPN0e2Y+DyWLq/lGwQgyFVy1BbfBjT210jGZd7QXSPFXjkRvJlzYKF0/RXBd/
         k9KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756724092; x=1757328892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y0cJUednc/5M4WDwpNxVBOifAr3cOm70FaB8K31QTbM=;
        b=D693BaCugYyJG1dJX3XL3/CXXleVhW6aYBK/fACXwx9ZkTHxHtAdYqOtLSXZUz/duj
         MCJ0Az/POJ7GZDsvVAGXhgA6VZQHEs2pCgKAqKq0ZPaj2K/38SvWIH5C3UBQgqZJI2xj
         4Q69uM2YaTkuBnmP5ak2A8JtvuzEIHoVS4cKkd45MfY/V0BB5p3okIxHJbXKXjGKersi
         L49Y7gW8nQeP0VPEdWJPZeRhfaXtEbML2JGHcLGTmTKgUh7Ueens7c9EqmfeRWRKjLNR
         bOziB4g77wx3vpN/x2z5cCCUfxz/JppMzgE8MBYxmxLiz19JfS+zWhhMtPL7lrZycKiA
         L6TA==
X-Forwarded-Encrypted: i=1; AJvYcCUPBIVwFTKS/kR6OxRTyE+vWAPypNQJnZJVx7t82MHhRvJe1pmly7eEQtRE6wC5ZW0g/JkEGelL6w==@kvack.org
X-Gm-Message-State: AOJu0YwGbWOTZHe0nR5NWEI/b51ScKtDUdeOWQF/xDMjrbUMiLwB9VLZ
	pfnj/JeAvQ5FyMzqvb9qeKEInaHhix/uBEzXYD50BjZ9uG/v+TgxOnl4XAgXE4as+heQAZ2Bzx4
	bzAXdjsX3L8IG76iQF7UuqHEOISPboobUWc0N8TxNgg==
X-Gm-Gg: ASbGncuWgbiU0KN1058p43LG9NYsTgZeUmX5/RhOj8f3JGI9Gii2N80YiVf6e4fsD6A
	YV+Ugqw/WqMQ0JlT69lu1no0LhFRYG0BoXJRLW9tAmv2irksY/nEL2pNiEWadalx5iSTTben5ml
	bj7rnPOBEjn+A1YcaNGq3XaVS1Zf71Sv7Wmlz9sYthL7zr64evbgtFTqz+NRVzrOekuNn7RTfj2
	F+4SF/dfQkSoCtCopT4hj/j5y6tEYjHuvVLZMGNGtjGpA==
X-Google-Smtp-Source: AGHT+IErujEHTbrp8kr8EXUBMZI1Sefo257M2ZPpsFs+QhTHhEsC5J8bRxn273glh6y2fAFm2YbZZ83e+kTpefkb8iw=
X-Received: by 2002:a17:907:3e08:b0:afe:a4a7:df95 with SMTP id
 a640c23a62f3a-b01d8a26e5amr703688566b.3.1756724091540; Mon, 01 Sep 2025
 03:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
 <f065d6ae-c7a7-4b43-9a7d-47b35adf944e@lucifer.local> <CAKPOu+9smVnEyiRo=gibtpq7opF80s5XiX=B8+fxEBV7v3-Gyw@mail.gmail.com>
 <76348dd5-3edf-46fc-a531-b577aad1c850@lucifer.local> <CAKPOu+-cWED5_KF0BecqxVGKJFWZciJFENxxBSOA+-Ki_4i9zQ@mail.gmail.com>
 <bfe1ae86-981a-4bd5-a96d-2879ef1b3af2@redhat.com>
In-Reply-To: <bfe1ae86-981a-4bd5-a96d-2879ef1b3af2@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 12:54:40 +0200
X-Gm-Features: Ac12FXxbsfem92CYCNntd3O-eNuFX0uYoorx93G08GlL_Qka4oUWgjKqGl2mAAE
Message-ID: <CAKPOu+_jpCE3MuRwKQ7bOhvtNW8XBgV-ZZVd3Qv6J+ULg4GJkw@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] mm: establish const-correctness for pointer parameters
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org, 
	hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, vishal.moola@gmail.com, linux@armlinux.org.uk, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, davem@davemloft.net, 
	andreas@gaisler.com, dave.hansen@linux.intel.com, luto@kernel.org, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, weixugc@google.com, 
	baolin.wang@linux.alibaba.com, rientjes@google.com, shakeel.butt@linux.dev, 
	thuth@redhat.com, broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com, 
	mpe@ellerman.id.au, nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, conduct@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5483D1A0008
X-Stat-Signature: ke5yzcyhb9tqqqzz7r9gg5dz3kcsy5he
X-Rspam-User: 
X-HE-Tag: 1756724093-961198
X-HE-Meta: U2FsdGVkX18FPmVLrkk+u6+hNbykLTt9PIvqCk0maUc5ch9Tu/nVzdNH9gqeR7G7TALlhGAK/Jy5qoZZx9fOaQn+lx0G3UUG+kfE+q3M51JSwCu8mutgKgHP+53gyeNtYBKDGWml0QDHZ7ggKA+7Dy7mqamU0rDXTpI6yk6JcOlLwEhJ6Mxp7e/A7TVWSfCnkkUCNybA6LiUTjmgdscr5SzBib5+WtxzuI6EBx1+hsRpl3qu076WTs8rulUx2JeJ3rRGjkxOfKn2nLedxRSu/5MNoeSSCctUS1eq8Cq9Lz4GFZwXbRQpWxMcTc96/TqS/kuOCogXYCqvwoEDKSEYRzcFZT+4s6SIlGTTUtjWkL2ll640QZRb2U5jljZFhH50EWMWw2OyL8Mw7GqyRS/05mQLB9T13Md9b0XC6LK563VkWltXZYXp1yxkuRH2kgbMZAUJZ3gkBr1Erxpc/o3dj/J08HXzXv9owfdl1SkK8vp5c8+hP2aOY02LaGOEn3S2yn9kDvZBNImpyCtGVV+mk7mQOwOLbPLqwmRnnVlJRbXi1NjRtpIL2bYn4WvGk3/gPsu4D2ipm6Wpve3bW6Zj1dzlEHBUupnmu+SjsUzeJ09+Ql/ag1FsspkZFQlIoZXU6MUzSZf8Ymg5DPrDAA2bIbsXWGly4ubwQj6VflG/P7Qre/cGZXJt33KQ01bA5005XhBXZK2xh2LJ43hKomxxbr09cHUtG7Px6mYzcPU0jS6AyDda01neeZlQBUgy5p+ItBJLGVCthTHDkQq6Lqipax3iqHMo5yio79mPr8EOOyTyoP/SpihwupLL6S0f9Rc5KWI/TdP7yLzkdkk8tGrxMVVfXYbUOQC6WcBXE2/7PKLnmWBxe/e4aEGJ45uqX62/kHCXHhqEDxq9vTRsGvNH5IJz1CgwyhdQSZjBVBURWlpZN4DAVNnqpdS/G9+gCL6ntyTrYd3gl/nce7LL+tx
 RX3UeQ95
 SO/Enqo6FAODXlENi8C62MOpPUr5kSafJcdGxLuCJZCuQeiobmsVMf+ujKUhf6cGPC6DQhS8otxZd6BGrHi7vyYiHfo4MI8HSmAk+Yk5gbwMw5CprYKECRGZxe6Nmhc7bUXUbbzwvTkrqnw0WXL+icNu/M1Zriq9x/RVb7BsmSoCfRNFYcWp0VGD/67lAXUjimHOQ7wqg4Ge5nUayH65cwF/A3qkYtasnwZpUeyktceEMpRnfLPbw7moNCdR/CkgU4tmerygBkLL+ibLp4o13ZE939Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 12:43=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
> Max, I think this series here is valuable, and you can see that from the
> engagement from reviewers (this is a *good* thing, I sometimes wish I
> would get feedback that would help me improve my submissions).
>
> So if you don't want to follow-up on this series to polish the patch
> descriptions etc,, let me now and I (or someone else around here) can
> drag it over the finishing line.

Thanks David - I do want to finish this, if there is a constructive
path ahead. I know what you want, but I'm not so sure about the
others.

I can swap all verbose patch messages with the one you suggested.
Would everybody agree that David's suggestion was enough text?

