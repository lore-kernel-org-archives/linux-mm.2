Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB62CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5356B00E6; Tue, 16 Jun 2026 17:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE1A6B00EB; Tue, 16 Jun 2026 17:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E91B6B00ED; Tue, 16 Jun 2026 17:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 475376B00E6
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:29:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9652120191
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:29:45 +0000 (UTC)
X-FDA: 84887067930.09.95E917E
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id B2C6180011
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:29:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cMOBncbA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of smostafa@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781645383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJ3fUZ+/EYmTkDXUK4ZNvux/ajtwZf6cg0AECRGmMnI=;
	b=5xIYoa0JP5HVgGx4AC9VmTCTzfqQUrBXk+oXFz9MdW45bueE3gNYCei9BdSiBkPJmItIWO
	ui998gBLSCrkCpPaaOyuPeKQ8HJVNBG2rV/DpOcfsaFXjXfyrh8Kg+H/qZx1yUN+DLQLNa
	Z1llQO3UEEWhjUhm2DAXn6c3bPpTQiE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cMOBncbA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of smostafa@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781645383;
	b=kzadhH3sRD3P2XHJ4JJSTj48y/ISQgsXV575iKDgFZ/DW1hoPeJmqTFnhx2G2RJ3BV4hu7
	tn1R52G0lY0MnGBJFZkd5H/SlENVqJ1nMevsF3aASvD+bqO/QcdPHfhXRKHW+OVzRIF6ox
	NBM7Hu8JPuRvdE3yinCtoEj2hW93ijM=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aa62bd04fbso3228e87.0
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781645382; x=1782250182; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eJ3fUZ+/EYmTkDXUK4ZNvux/ajtwZf6cg0AECRGmMnI=;
        b=cMOBncbASuYjS5q4oW7uH5reXK52lRD31Hrlfx3sm4t3r4Sdz3pck8k2ZeTILoQaZz
         DsY8e5QEGcnJyBqySlAq1dfOE9p2NdkvyPj5+loAJzCMM5bdQRm9jzDjzngTcCQ68gyL
         zYA3yC1H/nEc9xqpobT/cRQpdEM1wJQ3iVBdbNTFK0+zP7+qmFXiSTYFl14QFPZpE8rl
         4gaWWkSqf5f04EsntIZOoOCx4SqKniw+ge3qHbDjlP0ahhLmsi/RQlvmOhcO9lDDWV7A
         22CVeH4YpzeAygJD9mL3XtkgcKMb+qEpA2+yjxEgmkGhzFKILgnDJwIK9XmKI5cEkIos
         jbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781645382; x=1782250182;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eJ3fUZ+/EYmTkDXUK4ZNvux/ajtwZf6cg0AECRGmMnI=;
        b=Ck3RN3xOFbASuGCnhrYEsAQRfdW1XFYHGB7QvCcB+XzGtHtq3pmqJv4ahQn1x33nyN
         QtTUdPu4jJQuSZkrvMycMOCsV3mcj2q0pJpI/Fn7FY9C6/M7/LS71Z37lybtaZHpY7u5
         62yCzd9C/27XZUyPX758FT+uP/OsmmVbS0MttBh/PVE7Qlyk2cJUXBiiA5+s2wdJ2jbM
         CqQ//aphJChKZGr08YvUKJ2acuaqgz2GJvXYiet0B8ujvjSWWpk9uXiTCBRMOn1zTysx
         Ao06m3ksIoyv7j/qqeAjBsY+Ik9Mb6zu3CtkMcM0WiRpsFZw6uze7utp18uJkJIRPT2/
         Gb+w==
X-Forwarded-Encrypted: i=1; AFNElJ+qmRPATqJqsuyTt5+vZxv6bupRKaKy3DJEH2ZM8jHIDH93drCBaP+oMMer+iTSbfztNxsb/NJYuQ==@kvack.org
X-Gm-Message-State: AOJu0YwX2D8eKymE94kCflGYLSCHIVvfAbRZg59cggYyoIXBnVlkyHeW
	doC2ZfhOsuljYwHNwa0rvRYjYzLge0hQrB3aISjJiaStLwjgvx4mLJvQp87R+J5Vj/pDR34NdLB
	OxvfmPg==
X-Gm-Gg: Acq92OF4xzy4VqA1UAgVZoJMla6WGCCmU5JFo3bOolq6P8YbgyX1i5RO0F4uws/kkH+
	hxfuh207QxSd9E3AeWlwoQlc1ppVZ6ti11Vz+pWHXQLsMjh6Riui/KnB7/yG3XUk50gdSIfnIH9
	GTSkAswsA0HlLLvHW01zU5UZZ2P8XqA+zP6SCOLNQoEG6EhqG9qwfrM30PrZ1VwfXM4uAuMed7X
	hn0zJ5d//2jE2c1nD85nsxkS40b59Nf25dBuaF+yT88knElXot+nZ3FdVOzTLnNBbGcN8/b3RZQ
	+/kuYkYiMyCxmeWOWWa0zBWFclqolo2xsOXUzB/rBEfjGk2m/z6PgYRVI9U3o+619lgYGTA4xMY
	TVgN6Yl2mxM2Jv0joDO83FOdYXkwSOS6pK/nV4Z2hCTXFXPO/mB0cyC/Vyb9TWTd+uu3v+yEEgA
	wpaOn1PwBlj2QgaBwWNewnt11ShP45MlogcXYBHrEmlIGGAL3QFFT1mMwQU7g+1w==
X-Received: by 2002:a05:600c:c059:10b0:48a:5aa3:ac1e with SMTP id 5b1f17b1804b1-4923088e313mr879485e9.3.1781608022038;
        Tue, 16 Jun 2026 04:07:02 -0700 (PDT)
Received: from google.com (140.240.76.34.bc.googleusercontent.com. [34.76.240.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26393asm46289637f8f.5.2026.06.16.04.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 04:07:01 -0700 (PDT)
Date: Tue, 16 Jun 2026 11:06:57 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Luigi Rizzo <lrizzo@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, rizzo.unipi@gmail.com,
	m.szyprowski@samsung.com, robin.murphy@arm.com, willemb@google.com,
	kuniyu@google.com, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	akpm@linux-foundation.org, david@kernel.org, netdev@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swiotlb: avoid double copy with swiotlb on tx socket
Message-ID: <ajEuUZMgS_NRmDcp@google.com>
References: <20260615234220.3946885-1-lrizzo@google.com>
 <20260615172535.080cf94f@kernel.org>
 <CAMOZA0KAHKsvA9yRcdrjG13S+=rJhw-Cvnw2WdLjGGY0azG0kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMOZA0KAHKsvA9yRcdrjG13S+=rJhw-Cvnw2WdLjGGY0azG0kw@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: dqsmrqc64y3hpz71qh595ctk8gjyw6af
X-Rspamd-Queue-Id: B2C6180011
X-HE-Tag: 1781645383-500786
X-HE-Meta: U2FsdGVkX18cLd4ZX14NsDylkswxCaEFLX8VbID6CkOuFFfF4U5FUx15SkbV/aHeQYre4+ZFqEs/D2kNjuj7uvpHVsCB59fSk02JyXiNoijqcbL4Ib0oPydeTTMU4xqAwTFLoci0JCeqjbHbG0Fvy89cWonQQs91RJ4f27pwn4cu9wmoUxc918T6DtPHWUIzQebATPt8jISZjnl0rKcyLeWaST0h+jUPO0pvp8hXsI1+uocH0VXaOZ33aIYJ0NmuXsjlijsqgxuM+rkkKqodh55y5bYTTqFmGIHc9tfgKrOiglEMVMh8BNTniV/OYg5h8gKiqMDjsoy9HDAPI3+VKYxHTQywKqgw52quQEYKo+IFENboxDzbCwSbBIG5gF5t7V6PQP5jgueT4rJaHZvuy5z6aJ8J5BSOeMXGWFADKxgEQ2PIQouMKqXJCusmM1ptjxETo+O0qCsznfwbvM7dXj90QSNg6cx7CvJCvsh2tGaczxD4jdAwYmQ5LDsFL6SfIw/dC097SI0pCmGD8RjcKzVsgCfdtVTZgeaTYYMVQDbTywEHgaqTlA0Xhp6e3gf/KLQCwRYMlrXW0W+QSE3ji895reoiq/BcTMTR/Q/Iu9Ao6p/bwJbhUO49d/hHgL13DdQXfwpoTBNmtJ75Ru9CzYAb35LVmZEvdUc94J+SQYLSDujmW3BX6m6wAF+qonJOgp4J4QMYd9dntp6nl8lYI+6S/2fYMKkh5xmUc5kOHSDzrVkN6TIsQViFTYpz0KwpuGB2sDUJlQhYBwn2LquKtLisP1hmtfj0zLDEe1kAQGRLuNZqi+nu/m7Urq02IsUG0sTcLRxGtDSEElbPX+G0NS9EhncWH5XLxLNiuLcQmQINaIl/2oQMEc3W0O/8hYdCtMM+TDYQVbvN9mw4JJIPqLuE4ZuwUyzNE6G00nP5VuIqeHnzq/Bvr9lKX3umfQBBtLPfmKL9JeJiXLXaT0S
 2jrmSOan
 jePGuLB3xfhHmTLa0yVqOKLIQ0QXSxCjqI0S8ALa+uyv66oBxIKCaZHQYtQafgBnEQonFc9dtgpbYexPqCJ41E1g3xfvusaJh1A57h+Cjh/hN11PnfGEfdbb6nFmcj+Az+uJOWdhPX+ixT/aJzMfihfcJtstNuDIhHJOGrJ6r/j1n7UHMsvAdex3oAb3lKqmT6QpzSiOeenmYklGnthrq3X8+Sq24IXqtozJqtUxL8wTVqlHQahzZqFCJmbvgdN6MnzBCAT5Iydym1JQ3NApaMN5GeYA5fjnl4LTbcw/J/hC2HSy2/RTxqebB6CQsuVB7j+8YxT4GJslyaGIs3x8KCZOaeK2x1PX1VVxcY0oh055yz+kRmCJvw8xqJmwJUdOIiOekjoT2Ie3C0YygckM9Lrg1/WQcOqyq55CJ8w7GA5gduXLLXAUEaxp16na81OqXCAAYO7Pu2cjeCc+VCyce7ei7R7yDDTjbUGUc2sdeoIn1Ijc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 02:33:52AM +0200, Luigi Rizzo wrote:
> On Tue, Jun 16, 2026 at 2:25 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 15 Jun 2026 23:42:20 +0000 Luigi Rizzo wrote:
> > > The use of swiotlb causes an extra data copy on I/O.  For tx sockets,
> > > especially with greedy senders, this has a high chance of happening in
> > > the softirq handler for tx network interrupts, creating a significant
> > > performance bottleneck.
> >
> > What's the use case? I associate swiotlb with debug / testing mostly,
> > so it'd be useful for people like me to explain why you care.
> 
> Ah sorry, I forgot to mention.
> swiotlb is used in guest kernels for confidential computing VMs.
> Ordinary memory pages are encrypted and the host or devices
> have no way to decrypt them, so the kernel must use
> unencrypted bounce buffers to exchange data with I/O devices.

I started looking into the same problem recently, to reduce the
bouncing in protected KVM (pKVM) confidential guests.
My first attempt was to update dma_direct_map_phys() to skip
bouncing and do inline memory decryption (for pKVM that is a hypercall
which updates the stage-2 page tables), however, that was really slow
compared to the memcpy in bouncing even for massive pages.
My conclusion was similar that we need to solve this at construction
by making this memory allocated from a pre-decrypted pool (which
does not have to be part of the SWIOTLB)
My initial idea was to teach some of the kernel subsystems (SKB,
BLK, SLAB) about "CoCo allocators" that allocate decrypted memory,
as this is not a net specific problem.

I am still looking into this, I was planning to bring this up in the
upcoming LPC.
I will give this patch a try. However, I believe that we need a more
generalised concept for CoCo pre-decrypted allocators in the kernel.

Thanks,
Mostafa

> 
> cheers
> luigi
> 

