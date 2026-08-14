Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AD40C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 09:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E4E6B02F8; Fri, 14 Aug 2026 05:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0A36B02F9; Fri, 14 Aug 2026 05:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5E46B02FA; Fri, 14 Aug 2026 05:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 931A36B02F8
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:10:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33C3DA2A9F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:10:06 +0000 (UTC)
X-FDA: 85099303212.24.4D9CFBC
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2BBDA1C0002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:10:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786698604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Jqj4JqO9BabMyvxuodPurcPg4/V882ZcQOZjyroQic=;
	b=3TOo+UGQHqAFQE432Qjj7K+tK68GsHTYhxLe3rfsIsLLpfRB4TLbaw0iKRSL+PZ4JtzXRe
	Nl7IwY/JfPwrCRl3Qy3zzCgzPxZQrqAjkarStECLfiEXqG0JrEAI2aXFU6HxyaK9rbSgIz
	jv3SDrvqGlHbdNEfKE3nWYErm0kB87U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786698604;
	b=oI9jxvJ2BJfe8YCiwdATXpqgoFFOWcpRIbZKpjtFw1IglWnbzSPV5Ov9qKfCTbv21xDSYU
	qxTfwEwoU1kxSQF4FM1Mowa2fi+av/wNkfEowjPIUAk7JT8ijdJkDYZ2JWurgfUZGJUNm6
	mYaOdxurMOKVr7ciUjDHOAau9v6VBWo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5bfb3347dc4so511188e0c.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786698603; x=1787303403;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6Jqj4JqO9BabMyvxuodPurcPg4/V882ZcQOZjyroQic=;
        b=oRve6cLybkHLtxBH9Nnt51V+gtGg0WM9MKXqpeIX+kpN4z2KhvqKCqMWZHQKXmbuCP
         I3FFw81a3YAhjFDaYgfl9AB5HxPwsxMkYHcF4TzBLmP5drrwLD/3y2x2QaXhRpDkkryX
         lhZMOcuNoIW9SXSh986Gd6Bpx98QJaNMssDvBzRDsYUoD5GNlRh2WfeikjvTAQaOcHA2
         GNIcjQzl1RHV4Jbym4HKN9NEWqKOqxz8FZ9iNcPhe8csMSJFt40HO10crPbQGEZfhgJL
         6aNC3BMjsbEmB7kb/9aDkOeBAZa6Rxa4p6qpTiNeFwgr/yZYUUhaQalNat1VgrG5lf0H
         4W7A==
X-Forwarded-Encrypted: i=1; AHgh+RotHJ/uDRxb9boO01luPO7LyILbtSZ+mMkFoUzG7xFRLTtC/7lQAG00BE4fvvVz3cU095yf/GuNBA==@kvack.org
X-Gm-Message-State: AOJu0Yy5Ir0/14aghD9Qm5A1FTQvpaNaXNRZ5EjGAkX++78ugvC2GEeQ
	th8GAiPGp0n9NsopVCSzQ1T9RctNLV1cu1rC8zqTojuyUnVaSg5KaPqUMFNiSM4WyCs=
X-Gm-Gg: AR+sD11Tc1llkOMwD+MidFLnLJwFl0iVdeV4aNe7VROjH7rMq9JS0hpYCcJwlesPo+e
	eLmHWWX+yUtyxMzddpwx6UFuu0mWkJlPAynQgKayEvyWW015OfCLF+ZLWWHgaDjABsKGbsmBJSG
	lXg/9tUWWTBp8afMjaXzzMdKj16WrXW10CYLc9h/EyphMtHTgIGZrAixlxgr/TxD42bdWKcA289
	QLmaorJIlPDW6SNkArXfrRqtXNBb23qYNUUoFUfFkkIxUUwlJz65ZSRv7lvIM/VMqIVGVOKhb1S
	BCoQlGLEP+/25NmL4x+FFrNzuGlfeFUHthRF/VJxGk2Zaz5KP2wFPLL5idXM91ZrQ3gf3IiCx0E
	WV1TYoDRIA5Sd/17sRRsJCKRt0ms5FwiF6NHAsBSYOBx0gBRkJgzlQnn7pAQBulM13KFAhOp+sw
	aCgpuSc8COfouXHgPBKZ56FkO5nBxE1qGL4crtx7J+UdRK+jMjKWl1wMDuGj8YWpGlY50dCgp/8
	eLEBU5uf1/5vejfJSi/qF3jNQ==
X-Received: by 2002:a05:6122:f05:b0:5bf:8469:c7a0 with SMTP id 71dfb90a1353d-5c591cbdc96mr1090666e0c.3.1786698603155;
        Fri, 14 Aug 2026 02:10:03 -0700 (PDT)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-97bfbd7abe5sm534901241.9.2026.08.14.02.09.54
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 02:10:00 -0700 (PDT)
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-97bf9028c10so310386241.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:09:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqlfdwtQApxe8YayX0JhB8Wxv5sLgZplJk3w8v9pECwM6qSec6qmvqDmTuhc09C3REd+/gmnW4xwQ==@kvack.org
X-Received: by 2002:a05:6122:6610:b0:5c2:bb83:462d with SMTP id
 71dfb90a1353d-5c591d5fe7dmr1060680e0c.6.1786698594102; Fri, 14 Aug 2026
 02:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260813063401.1786548-1-thehajime@gmail.com> <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh> <CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
 <2026081308-amigo-paragraph-3afd@gregkh> <an3O9QHUZSSGIiZD@lucifer>
In-Reply-To: <an3O9QHUZSSGIiZD@lucifer>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 14 Aug 2026 11:09:42 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUNjbiseh9r7bBDwq_Q_Zhuqg5a95W4+B4KxkKYoJ8vxA@mail.gmail.com>
X-Gm-Features: AcwNN1XXyog3dVT-YfvVdAkP7WMNLCRVBkdrVnLyIesZwezC06Glgvjmz4OA9nM
Message-ID: <CAMuHMdUNjbiseh9r7bBDwq_Q_Zhuqg5a95W4+B4KxkKYoJ8vxA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to /dev/zero
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Palmer <daniel@thingy.jp>, 
	Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	"D. Jeff Dionne" <jeff@coresemi.io>, "D. Jeff Dionne" <djeffdionne@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: dotrijjk48gx3m5ngydoifnqdyw7nz3m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2BBDA1C0002
X-HE-Tag: 1786698604-400860
X-HE-Meta: U2FsdGVkX18QJo1PT+x5cDWGSPnHGW1p3q3S9KDTR14UNkUGBDJy6KVe6K4fMuD6mYeLgkgdZ1/vvs1K9Zq8OCTgTdf7lMEAf+k3xH2OCib5Jh1wmsyQmhlVF+EMd8jNxt3SN7EQOmlUrlNL9p8cQ7hyKTXVYldQitjkdPTzOB5TYJ5fo4xQQvzDUmARcCBYnMpGVfFCKw/imAiHfHEvQHza+sZmldZfkZckzyUg3ae26SieS8hPvYRJnnN9dUkNF4sLh2xDtxgyluaxvMq0sQ7GhXA5KtEU4/61wXEV4iPPDHCXu+Qu0ziv35VZHA3oYkF0MnuGKpLctWEdaMXCDyjxi6Stmj/IRNxgHc/GFvUAqvi/5Q+iw5I3xntTgQyLMkHT96w3qH1KCZUq2/HlWjCZF4Wq43x3ZZQ7wIIGZw87NaUyWBa51mUtQab1G9sHRSA6GOL/HTIqWfmKJPPH5lTtsYjvooXPwFgyDw1R4Buh8J5I24uJbXjo8VqPVIAA4OEW3IUlzPDv9IAOYHXLXTsqdW40vXIBBuTZL3zWqQVldGXWQrdoUaF/AK2WG2x3/mvyBUij8cxG0OCUfnAAvfKF62tJu0YFqYvg/hiON05CGWfixNHZ/xEb5atBIJqClq797vZsqfW4/Vu+Ta3jT3yk97cH3gPpSnVsLcEHhNNLpxcPsJBm0tPhf0IXPIj9xspMBYcDqXyku+sVs+kdeG2Mvcyq/zeOmRauZHto3fbA+TGua0KY9AMKkr3iG0Lo+BILvw0k+uGoiVZaxCu0fpTOkFPFnlaK4fI5C5FFHZOIB7Gb6OX4zo9r7KiSwv9xYqY7jy/dREJLrNzWnU/DvzOYLZVYDiHtYbcby1U0ZpHN7FZIEV0u9YTuOab5Fu+JYFmApkuTu9XOpzquVvOd0EfNNY8/fqa1gsCp+DoEC94BntLT5vnMo7e/BeWOifQP4BALAAO5olqg5XhoeBG
 r+BxWo80
 m4BSJaXyhhIfT/QL4F0udXcourRn0VNjUOX1ZWKlfClddOJt7myORIFOIlCY+eLaanWdMXe02y4HYPz/CRjkc0H20kJT7TAuzCjL4czqfQIK9sdLGnW9CLlNfgDftFnfSgmPMi26pbXP4tQKiaetmjMk74QwlrpEplQhwSbbVdqHJcLQL/TBYQ1i+wwiQhIB2iy0ql2WtrQHbDRMV1vZYvRi8ZKtp7uUWumiS96OK4yM58U/CzFfqksFLOj/SB8J68hE9NNTKDPRAALNUVz95qHBl/vnCm4SD0WMCf/16FChXDQq39j7lfb2G9ymTtgglYc8FjolwQA2H5pp0oVptK4gk7sWrZY1N+y/4jrrIoemkcSsxFstY5iY6PFdMhlZp3KQGPWjTpLFx6hmRjJaaXRCiRQnQMwI4/iqlvxTsaqBqtnM03um5PA4nbYGsrYTvowLD3NjeTv6c6GQ49ZCp9ojrNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC Jeff

On Thu, 13 Aug 2026 at 16:11, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> +cc Christoph
>
> On Thu, Aug 13, 2026 at 11:02:18PM +0900, Greg Kroah-Hartman wrote:
> > On Thu, Aug 13, 2026 at 09:43:37PM +0900, Daniel Palmer wrote:
> > > Hi Greg,
> > >
> > > On Thu, 13 Aug 2026 at 21:26, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > >
> > > > Given the age of this issue, I don't think anyone uses no-mmu systems
> > > > anymore :(
> > >
> > > There are a few of us using it for hobby stuff[0][1] and there are
> > > apparently people using it for actual commercial stuff.
> > > There was a session about this at LPC 2025...
> >
> > This patch is fixing a very obvious issue that showed up in the 5.10
> > kernel, which was released in December 2020.
> >
> > So I think the fact that no one has reported it before now means that no
> > one is actually using it :)
>
> Maybe Christoph has a view on this?
>
> I brought this up a couple years ago and he claimed there are commerical
> products which use the latest long-term stable kernel (6.18 at the time of
> writing).
>
> See https://lore.kernel.org/linux-mm/20241122123833.GA26432@lst.de/
>
> Christoph - can you explain why none of these vendors encountered any of these
> bugs or breakages?
>
> If they are doing fixes that are downstream only, then that argues against
> upstream nommu.
>
> If they are not, in fact, using long term stable kernels, that argues against
> upstream nommu.
>
> The fact they seem to be assigning zero resource to upstream also argues against
> upstream nommu.
>
> nommu continues to be a ongoing burden for core mm that interferes with work on
> real architectures on a fairly regularly basis, which argues against upstream
> nommu.
>
> I'm curious to learn what the arguments _for_ upstream nommu are?
>
> >
> > thanks,
> >
> > greg k-h
>
> --
> Cheers, Lorenzo

