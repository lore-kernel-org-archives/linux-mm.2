Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A20C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 05:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BDA46B007B; Wed,  5 Aug 2026 01:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66DF46B0088; Wed,  5 Aug 2026 01:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CE26B008A; Wed,  5 Aug 2026 01:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EFF56B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:21:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9B721C07E5
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:21:12 +0000 (UTC)
X-FDA: 85066067184.16.6BF6848
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id D7FD680002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:21:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=h2RJyECH;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785907271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Sv2AxrWwmEwL5gdZKZwxZZ9XYDolhlrE00l6kbyHas=;
	b=p+57lm9VbWr5SDRagNYxY8qig/IAON4GBYXjGDtmigRtGMIb4muJlTw+lOu9pgASPx+5Tm
	T9y4bXPodmVccZBx/rZw9fEtLgdV+E5WRxS5Vh6lfsKjgPYjcUTxAWcDm4PE9T8JDHBOHc
	WAI3aXZEx4R9fW9Er26LULtRdyKgWno=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=h2RJyECH;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785907271;
	b=csDOvv394AS2uVniUVcXFZc6aBrr7LPzpnS01aWr0gjgF4fBDQafROTN6xWza+Eb9ouKu1
	U25pmqYKblh1Zc0Q+/kFgJAwKvMHJ2klRSh6dn+cdcj/DM3HziS2eWFQYXyX3jG69fLxDK
	pNrCpoXOHYCsbo3+GGe9ffqh40Tl42M=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cf27856f9cso6770535ad.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 22:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785907269; x=1786512069; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+Sv2AxrWwmEwL5gdZKZwxZZ9XYDolhlrE00l6kbyHas=;
        b=h2RJyECHZnu9wst9nbZvtMehtLgwsZVW2lfCO8/qt00wWvBSiDQtaUfqwGNMJ+rmgc
         8lVLUFGhjXol97vVT+J3v4Y0c5jCn/7tj3M5a8AnF5CHIoFHq7iGZ6FV4a39OiLRjiEw
         l9gIwpbDD8GrH8QfGDE/DIIzDur5YDCRMGynQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785907269; x=1786512069;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Sv2AxrWwmEwL5gdZKZwxZZ9XYDolhlrE00l6kbyHas=;
        b=TaZ2OPDUnCCwlrBFN49VA3rdF/bf7F4OpCTwi9B37RKmU+2zz/GXbfqTal8xYNvYgk
         Ajq0imTRwK6Dq3uCYsE0Idd8nY8m4mI334etTuMKyZYxXHY4rYkfzlLxrxK4lVV9GMjQ
         T6pS85463rgouljHIRTk1Fxke3eLbhMY7gdCr6UIRyUR7cu1frJqlGdJGmv8VTEDjG+1
         HRFpu/mks1l9tayGX6P3Y7U5p0qpyQxsudLDLlmN3Cf8qE0RXKfJi2I3OFyNjBIIQsKy
         v/+Lk6ZNzaAkrmjx06XQe4aR3Zf0PAxfCBDdx7jvwqQMjfoIPDWTHO6R7DIYAkXfWQJ7
         9bLg==
X-Forwarded-Encrypted: i=1; AHgh+Ro7naqalJ0oYFNO7AU42X7K3ZvwuRsLi6xk60kZd5scpwiw9A7vqEcf0I9vPIO0rVMA+eYyzTUKYA==@kvack.org
X-Gm-Message-State: AOJu0YyXZ5jbH3IdLySWfVc4/OjRvW6u3vyyb84ickBKWPng/pBdH7NN
	tV//l0h4zKvGqXFuEKbSYRFagpBGDC0ow3QciNNMqYQx0sx1f3s7bsbDSv9JoW1tAQ==
X-Gm-Gg: AR+sD12+zhabAd5F7dBQnFitTO0rxEfAtzDCBxkxeLKLhzZrCOmaNQJ/dXesYInL0Fy
	GSfEwpuztJdbDyVi5wZoo8vqfhhDrIvdqfgwgl0dGxovLlbyDGFeGd6E0180vYYt+o2rhWena4b
	h/3ZNGPDRNxAQwrfl8YDJ35MbPsjjYIw9fP35AzUYp/xrZye6rdl6WNF/7CbkPVYYMOfe4t8ifR
	foz8+EVtGfFhTSUC50eQlc+xl9pHNnmT0Th05w5I/2LAlkfJr8fu4Tcl5cBk3iXzs5sDu3WPHNA
	3hHX3PhrAqhC5LYHGyGeAtYviZoN2LGj916tkBBiuWm3n5aDeUGPHygmrMrO5tBg94HlwcClgTx
	T0nMGQFGy8hfTprd8jlSWm4Dc7dMlIitH4p/2yY+Wpe11DR6rW+SKRcvxDq1niWTRdusbOwQTuJ
	xcoaYpmwBX2mo/m56a4EnL9T8uUIChHU/+aw2UUl7qJDNf3J+F/Q9t5lQwNWWmXK18AhQRYT7A3
	nOV0h2CfV4ofbtSz59ky1JYflfrp4mkds/iYB6x
X-Received: by 2002:a17:903:1746:b0:2cf:afe8:b722 with SMTP id d9443c01a7336-2d0ca761e0amr45277575ad.11.1785907269509;
        Tue, 04 Aug 2026 22:21:09 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:32eb:b46b:e9eb:65c5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4f35d5sm13841875ad.82.2026.08.04.22.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 22:21:08 -0700 (PDT)
Date: Wed, 5 Aug 2026 14:21:03 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <baohua@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	akpm@linux-foundation.org, bigeasy@linutronix.de, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, ryncsn@gmail.com, 
	yosry.ahmed@linux.dev, surenb@google.com, Dongdong Zhang <zhangdongdong5@xiaomi.com>, 
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <anLGxk3iShEfCB30@google.com>
References: <20260805005545.66112-1-baohua@kernel.org>
 <anKQ_qZ1-Q6FchZ9@google.com>
 <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
 <anKaU6VStrW8zaQo@google.com>
 <CAGsJ_4wQ=mDXuxxTdAZkicN5pJK3SsNTOxHt5oNYrq7CgCVObw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4wQ=mDXuxxTdAZkicN5pJK3SsNTOxHt5oNYrq7CgCVObw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: yiu834krpn5zf64ni9z45mkitdq664dq
X-Rspamd-Queue-Id: D7FD680002
X-HE-Tag: 1785907270-314566
X-HE-Meta: U2FsdGVkX1+WpYNLGCVq3i3+vYGuNnfhl/c2rod3XRJplfN0ceSNfwgDrX4BwKPfvnQGUcMfbFqxavwPyUyyFOEZgjGAxxgDxxngUtdnaltGEE0Bn+2J4X4JYVmcXOA/XQqPJll06vuXxfSKD8ohi+P4KFm8E35nATDjay/VQibMGzh54TzyEsmMzALJ101uPQCykTUIRLBmqTlo4dZPUeexnFoww9xhFh3hNAzFK4X6BNrEbMe3pWgueljdBw4ZFMg40CyTDtUKH7LjOw+bbnCw61GyOeSZ5RvuGjfpCJM3SdpbCkzEFFK7qt+wMATo0COP4QEbWiv/OxwXGF7W2bX1DQNf1WF9XY8Fn7giHbl2EX/HPq+S+ra1ZtvzM5GeBEbGK/cqy6rWlUfOGeGahplrlxvBUXi8EJc0idOFQzX2Vkc6FYm7RbmSFW/pHviG2C3s73sXG0LaVvRIswT52m5ud38/vrx16wKksthQSA6P20uY1R7zCkLLousE7sPbCUVXJQq8uvP/54dJv9rePGmoriDiYWzILeWQY6nDsA65mU0H0WCnNYdFdWvoMYMCS5lDB8CUg7o+f3VAT0+4wi90rk2aM4WpT7jrJmiTq7xZDCP9kgmuGDkdoPIiWsH07SMU1x0MIcLDUvUu13JKuxNazkP1zBLQ/OHRlrv2TdCTy5+y7dtABil3J0y1ClNasPykq1yk1BNytQAdCzmHeR3Y+53h881ToXnrbO0/CDOuOgNCd6WJC28lMdwBcvz9plA6TwPmUBQ4ep+XahyFD7DI7RTkCD5npbcHNFfdOCD/f13YCl0T+VHSXDWbD0GWBB9Ct4HNP3PRAIvfHe0+WbUnuQMfxbTlcLUAsc0Dga6gNk3NxU4sXiz3LDkn4NYJDh6AOPaIXTnjzIeeywuytb17oew7h6/4fQ2OkLl+kUNVPAUAm/fYchKPFKVAs/hjM9CAwsh0J7mG3WVGfmL
 YnnbPrCb
 JR9r+GLfbphoP0KtM49Vx2dgfs11OWyNv2g14PgApMsbr0OVq6iwKoMLPnp/nsmMkdyJNpeR0SP9palm+Kjb9Or96RRl6cHPqubN291h6UWvhplVFSjWkeGow2CF/pHO1a38qpwwDyCPu2ir64P4WR4Vp1z1qtp70zmg/YBVyUrmb2V2NI+sWSrE9m4SXaodNq1O71HgFjbFyyC724AKs/mRWTiKOmpKXpjfB68jFKuEbUTV7HYp47r+OJlLNEe8PYwTUU9U8CR80/nVgdy+EPkkbziWiTFVfuCTWw3vPhDH0W790FyFe9xDnp87c8VeDlS2F2ZTudVIxPhqOJwn9n/5UVj8tOwPJ9XKzQS1s8299f2tBiT+mN8KbHGAk/9sMW2Si
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On (26/08/05 17:09), Barry Song wrote:
> > > This report shows that the zram mutex has become the top lock
> > > contributing to UI frame drops, even surpassing mmap_lock, which we
> > > are also addressing in multiple threads. :-)
> >
> > Any chance you can share more details?  Are there perhaps RT tasks
> > in the mix, priority inversion, starvations and so on?  Can proxy
> > execution address any of those (if it has relevance to the report
> > you are looking at)?
> 
> Hi Sergey,
> 
> talked with our engineers reporting the issue. i believe it is all
> about priority inversion.
> proxy execution wont resolve it as we have a sleepable zs-malloc
> within the mutex.
>  i believe i need v2 to release the mutex before doing the 2nd stage
> zs_malloc with
> direct reclaim.

Well, we cannot just drop the stream mutex and do sleepable zsmalloc
allocation, because this will invalidate compression buffer.  So we
then will need to do re-compression.  Something that I was really
happy to drop [1].

Is there any we can do apart from making zram and zsmalloc atomic
again?  It's hard to believe that this priority inversion hits
only zram and no other locks in the system.

I really really really don't want to return back to atomic
zram/zsmalloc.

Is the report you are talking about some test or is it a real
world scenario?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/block/zram/zram_drv.c?h=v6.1.180#n1376

