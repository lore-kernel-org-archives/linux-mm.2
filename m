Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADA2CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 22:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D546B0012; Thu, 28 Aug 2025 18:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74256B0022; Thu, 28 Aug 2025 18:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89616B0023; Thu, 28 Aug 2025 18:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 940A36B0012
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:10:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F6A3160421
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:10:10 +0000 (UTC)
X-FDA: 83827560180.27.CE7FA74
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2E4E4140004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:10:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BrNuyo3O;
	spf=pass (imf09.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756419008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skVMf4Y64VvWuVdkg790UsFu5YpWQWWVSI/rnXUaOE8=;
	b=gwFYg2Z0NeoQ0cRdFhHVfKZ1BbSJ1qIA+0BBQa1jJdAEb4iubXilTEonBiX+uThr5iSKMK
	lQOqwdzbbbECR1wuu1B6mKFhzu/X3GU/o0re+JrnEBWOeSsSURtRgAnoICctGUCRmazsKu
	53ChKh9Lbbc+jzVp2uA4ujWFzg+u9lE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BrNuyo3O;
	spf=pass (imf09.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756419008; a=rsa-sha256;
	cv=none;
	b=H0saoLKufmMzT1R+rDS23b1/waHV5i8qHIa1IEPJ3jJ2HkaxT5vHyOfqyJlzow+Lm1qXS0
	UBeMY9Huic4nYUG4ppPTGxcpdnvr7+ykAL/lq4SFCjql5acSZ+ZxLYD9Rj/BvXiqTupjfm
	JKYHVEGkI7DGDGK2Q8LdjCaBcV78Fbs=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3c7ba0f6983so910112f8f.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756419007; x=1757023807; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=skVMf4Y64VvWuVdkg790UsFu5YpWQWWVSI/rnXUaOE8=;
        b=BrNuyo3Om3ob0rQpORSO5MgasjzA4N+D+KhjOp7TBShpLwpljDsBCCj7cHRKW4+YDJ
         UBBgbjdO7yDat6YxiCDfQtw5QhUgZuwhR8kPdtomrobSgoWUXDga+CwecMJIrmaTllvu
         4iGPQ0CEknVFrEv8T8fV0kvj0/XxuWIDLvf6wVWFnk1hqxZ4FZQfIJPeEcuSuttQAZCe
         PR+m2ZqxdJtndwC2DCPUnPfbTdOSQ+YxslHO9D1po1xYz8MU6dkMPA5909dtH4h4TJey
         psZia5sl1+PCpOhw5LvI7p2KZvjTZXUONrTkVISFG32iTLO4wTzs+SgY6/6I4VP/A9cg
         1MYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756419007; x=1757023807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=skVMf4Y64VvWuVdkg790UsFu5YpWQWWVSI/rnXUaOE8=;
        b=dlx4gr5Wt8Za+pjVBtMtnVes3HeFrzv9NGrpmP3BcQBOIfDfSZUb3sz18EytCaUvYS
         3yG8TuD+SJd52CKAQ/72+BI0JvCREcp56F0gM710Kl+OpT5RNNoIT5IICgp4AeNFz4uc
         5CYhuRaBkQ0QIqUNqwvBD5YQiGdGb70M/QssLIZfNcEXNF7W+dgQNd4kzTmc9JEJQLVM
         av83hWzonDgm2vAlAET/XlqyaZbbN4j2z9ZpvdtmQv2jjbS/4dDQ7jV6rDtZoKKiJDIs
         ZEZ96aCaSQ4aiV2Ro/kHnrrHS3PE65hpxDXSdWvEKe52liZTihNAx1nSt8FkVQ95oSAi
         4JDg==
X-Forwarded-Encrypted: i=1; AJvYcCWk4Xpg5Popzzzv/LBBDUI2ZKxl7eG8+O14rqdNZ8MCaLngCHrSxwe/LjWteOITkU7Hp4evk3r4rA==@kvack.org
X-Gm-Message-State: AOJu0YwDIIFv6+mcAyWv3Yh3l5HgXyJVMbvJA5JG1053qNEidq6IXeWL
	9WX+uvxLDt0hdc1CBmLux5ffJN2epKS1905qgOLjzxDGMkLnhu2+FHxV
X-Gm-Gg: ASbGncsL8wayqdkP1B16+kD5ynAz6bSjeuKevkJwL15fQPdKgTyp3MRQUnWHuJyY6Gw
	0e7SZ1JcfIYrHBzzPV7WgcTYTKnqpTeFC7z54Bc8bVPFXTI0IOQv4LYamJ5BF1orPrExznWXoRU
	1QSKVTYYdXTok3oMybV8h+TxFwRmI/bAsbqkoog1DlTj4h1Zics7Q6ETq6GhlzQZV3bAgANUAZ9
	MAsx/FBS0UQh6SitQH0pyvnHicZkT6CZEC/2cCxDI27GOpYfib5/Ulz1+IeElk5W4XioTjyOq6W
	N0BoFCGAz97MsGUpkhFKS5h9wElWiJEJqwdnbUxXo+licjTrlTsTch7Q20bbDg2pRBE6TdcFajB
	rQjXrKnwEo6Ey6LbtZGlm2T8SB4gudayP0C3+EvsyqpMmwf08B0upJZw/Rwje
X-Google-Smtp-Source: AGHT+IHiZ3WBoyZu/FzweeVRjC7PvnRoZSigUpwU+uJ3IFJU1fWXfFsuIEdijQh0lzqXSdjRkIa2fA==
X-Received: by 2002:a05:6000:2485:b0:3b7:9703:d99f with SMTP id ffacd0b85a97d-3cbb15ca058mr9165575f8f.27.1756419006524;
        Thu, 28 Aug 2025 15:10:06 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:4a::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fbb238sm765573f8f.53.2025.08.28.15.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 15:10:06 -0700 (PDT)
Date: Thu, 28 Aug 2025 15:10:03 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Message-ID: <aLDTu3GrvLd9jMhr@devbig569.cln6.facebook.com>
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
 <aLAUhXeRVWzLCNNd@devbig569.cln6.facebook.com>
 <c8db3486-4f13-4922-a270-1fbf61e2d782@suse.cz>
 <aLAXsptN4cw05IoZ@devbig569.cln6.facebook.com>
 <2182c715-aaf1-46d1-809e-e4142bc083af@suse.cz>
 <aLAmp4oayTfkPJ3o@devbig569.cln6.facebook.com>
 <92a3320e-2433-4ee8-8ed5-d5db6098b43e@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92a3320e-2433-4ee8-8ed5-d5db6098b43e@suse.cz>
X-Rspamd-Queue-Id: 2E4E4140004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ujemxzq1t7a793e8zqexy3hmtccotd5y
X-HE-Tag: 1756419007-805347
X-HE-Meta: U2FsdGVkX1/TDmI66B+yjW4231qODuIGDZuSeFrMoK4+SKO3fykHVcbQXpnLexwV9mI8kNGqiqali0mHStN3i8bnGek7D7JduIsR2Kl7B++gNa5a9ZbiopbtZez1doh7URPBLabDyEBAtRGECENuB1FjMFUlbdP8QsZ6vI6ORjRZZvlaN5g9fxGUGn/AF44/7hy1dI4lUQz11Au3CKKrszNS0v+Y1kjT06i4Ddmd3WHEGjCBdh9vfB41YWPiBb3emCXOgNY9ty40o3eHzUMKlzj7pzc87IPldxIzsxLi+0j7Qauk7xCe2UtKwnZglih1g3f4X7wN+Ndn/Tr+VY6WWXsDuTMGp7djTHiyB78EtHnaiG9mgLyHlnEi61ONmojKj20ZeE1jTx0vEMDU6y5c/G5DDUNF9TR3GWoA/qwq3C9wfSW7d39z3G/04qiam5pzbwY3pMMoNE4v0zKukpmpHSE4yBaBsoFFbx/TGd8gKVS38qUNXrAuhfjlBgDncSBO0kogovz4yxwqgRPdmNdAr4JG6jftgrpyTqyOGAqfFx7ig8J83jX6xDgUPba/oVu0JbFiFfKAWbSWfU/BCajiCKceIe0Hk/hMI0nHh2oN6qMPWvm1Nm/hEvxpLlJObhjWJB3L5Zty89lxDqTOeXEUw2q53elEyOppYN7+jl5/YsLSOuRu4bgNGQ4bQUDfhq5T6JOxZPWxSRHh+2GFgH17exXl3kNyX8BJeTpKjYrQXxCiEDUYabznrpDUSy8MFLfW7MREM73TOwDFrNDQQt/G7ALhGdR+EdAXNwYiPTGPZ/ltwC6EIIsBjUDh3g0aD/ggcg9pENIrhuV4kWf4kphqT3kiwBCyTOvhEJ1TMn1CBEwjb8qew/QReiuKbvYLmvIY5DojlJatbV+ipCkxPo29pJzxLfcZbnb17ar/dt5a1p5oHLaV1YjCo/txDIViIj2FSqdSvCQ5onlJ8Zjdjbo
 B/RuNV2e
 5FSg1jtZa8ZBWO+/YYhFoy3Cl0UYXJZGHlB7MpyhtqdidBOcRLqZrbgIU4gVrbeYo4bB/SVAwBrJhEkphIuVRp9RxCEO3oDKt6s09TiYFtywpfWuAcjba4Qj5JR3YaH0vMKyqUKibbKSNJ6q7O5eYTV0wLZ7yZkGcD38yDDkQyo+PUjEEAKZpiL0TY6zcAU1hAehA+XeoLqvYA2mqCImaZx6KfAhW93Il0SUSZM0vgo6Sj1A6khEaQdHONtUbEAVPmUEPYG2F7voQBqSaaxxmzvjBtQuiRQ7bYpRU/XOcR9rs4jVTF3UPbVRWR/5NlPJHNOOnpVAV9RfE6HIO0RWDYfM8S67Ivr4zviebpXqKPbQTNKuA0VLzH97bK9YM104kB2a7CTc6CS0FEWSvpM84vM6QV92+6d5HpWZUJc1Jt+RR7mvnnGwIJ+ia7xFhBRIKgaZBlpjr4jbAUehYSanq3KwtolJXyrCAhCkoGgrkfbx8BIpY6mVy8KL1E/FMUTOF9h8W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 11:54:58AM +0200, Vlastimil Babka wrote:
> On 8/28/25 11:51, Yueyang Pan wrote:
> > On Thu, Aug 28, 2025 at 10:53:01AM +0200, Vlastimil Babka wrote:
> >> On 8/28/25 10:47, Yueyang Pan wrote:
> >> > On Thu, Aug 28, 2025 at 10:41:23AM +0200, Vlastimil Babka wrote:
> >> >> On 8/28/25 10:34, Yueyang Pan wrote:
> >> >> > On Wed, Aug 27, 2025 at 03:06:19PM -0700, Andrew Morton wrote:
> >> >> >> On Wed, 27 Aug 2025 11:34:23 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
> >> >> >> 
> >> >> >> > In production, show_mem() can be called concurrently from two
> >> >> >> > different entities, for example one from oom_kill_process()
> >> >> >> > another from __alloc_pages_slowpath from another kthread. This
> >> >> >> > patch adds a mutex and invokes trylock before printing out the
> >> >> >> > kernel alloc info in show_mem(). This way two alloc info won't
> >> >> >> > interleave with each other, which then makes parsing easier.
> >> >> 
> >> >> What about the rest of the information printed by show_mem() being interleaved?
> >> > 
> >> > Thanks for your feedback, Vlastimil. We cannot use trylock for the rest 
> >> > part as node filter can be different.
> >> 
> >> Right.
> >> 
> >> > Do you think we need a lock to prevent the whole show_mem() from being 
> >> > interleaved and to acquire it at the very beginning? Will it be too 
> >> > heavy?
> >> 
> >> It might be risky so perhaps let's not. Guess we can disentangle by dmesg
> >> showing the thread id prefix.
> > 
> > I have thought about this. Since each line can interleave with another, we 
> > would end up adding tid to each line. Not sure if this is acceptable.
> 
> I meant that printk/dmesg already does that so it's fine.

Cool. Then I will do this for the previous part before memory allocation info.

> 
> > Thanks
> > Pan
> 

