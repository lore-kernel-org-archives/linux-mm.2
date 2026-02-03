Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD87DE8B37E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 23:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DCE56B0005; Tue,  3 Feb 2026 18:18:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B476B0089; Tue,  3 Feb 2026 18:18:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1B76B008A; Tue,  3 Feb 2026 18:18:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D43EC6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:18:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C45F13B4B3
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:18:40 +0000 (UTC)
X-FDA: 84404712000.15.C53CA73
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 776EB180002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:18:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hExwxgt+;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770160718; a=rsa-sha256;
	cv=pass;
	b=LIOFOdXDZ+X6W2T5MdUpvr19KEB07P/33OOq5AMkTLhbsOJ4r6C/+Nstfl/7aY2IbLB7Tu
	IHvCzv7zK5siZy1iu2knNGr7u5gWLvefXpm0P7E7Cqx1VvZ5Z/TbvaIvneUaQlL2vt1cih
	SejqK2XbdYGtCJ7bP0e4bGfvNQUaMgk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hExwxgt+;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770160718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mT4jzFeYeq6Mu9rOXZqRG9pxtPX2ipQxqDBaGRWMSE=;
	b=bqYc71bso1QhyoFux8/TfSvclkztpm40zfeNTh0GplGTQ/8IMhX+ZL3TmZwtR7raK9rE1L
	+wU8hUhnidn4p12adODVQEsHYIlq0dZDMIyKmBhnChoy68fc/7Uc09KHvSydaTZGjFDOhy
	4glQ4rNsK0D94XLzodrEigoZIrHXA58=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-435a11957f6so4825830f8f.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 15:18:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770160717; cv=none;
        d=google.com; s=arc-20240605;
        b=gYW0bGy9dpY8HT1/GQWX0TNTZd9OtY8TOV7PPrAGuaISragftpDk5ezqCsANtjMo+v
         v2jPDmiuaT37LMsOF7+6n+7oCsK1ix+bDKJz3Kld8Y3hT2h17KMvY+6JigoFC67mf0+r
         VxwZRldWNmHS539IepT3gdYMLjCrSMiSMQWMkHDs0SsK0wHDDnrQn0W1uRFok30tLdHh
         L1Q9xzbr5DAffVnkyp+wqOyymlwx2dU6GVIcCFFMQU/s/FwkXwuT1wsGhhBWmQp5Mz0r
         Q1uJYhvHdZ0o0r/lzwMbZmQ90RDHDpdgFxrfNSKqhkKr4Kbgr8o4fPXmKOnV+vRgm8sg
         gnDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1mT4jzFeYeq6Mu9rOXZqRG9pxtPX2ipQxqDBaGRWMSE=;
        fh=TJRXbxKAseaFCIoOW2sb5Cldj4G6ItCErdJ3U49iaUU=;
        b=NpS2RW3riWG3qB/LH23kNvfqatVhPf1RfczXQbkOzkV+RcnOjhB9WGnQPsfzyYN6V7
         M1ScQvfRmX7TNuruFu39lmiKnQGcgzIqj4upXi/Lpxrh/xeSWU0zTV/Z+gUQXbXUhG7g
         f4+h1uXAJtBK9QuPDTEqVjMSVC4txBW/ZFhwIxvcRNc6BPT3WXJFUnAc1iVbRYXyNSmu
         u8kRCJjEdNFO4/EzioHNlLvAFilefdF++60wBthFJ1yhmgCEwz29qbOAZHZj5lofOD4V
         EPVc6qpHNEm3QZx05m3vFDWZQK+tOpHOLGqhBBP+U9/mRsvhugp5Ij8kvIc8/CXLYWxv
         DoaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770160717; x=1770765517; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1mT4jzFeYeq6Mu9rOXZqRG9pxtPX2ipQxqDBaGRWMSE=;
        b=hExwxgt+pFE7NujqVLjycM2UGn2BZaRh4hNATVIe0zwnqdec/q/DQMz/S67eVataQy
         g2vX4LcdbGAm9UZAURb0zgs6iF8iCECMUfMJ0o3EnK1UZlv6cu/eOxo/U47nwJ6ieldA
         rBGceYsJs1tbrYg8gShS7DJ+Eqg+b4Bw15p3YTVBMwAcQgKiEw1scYZ1mM9b+/n+xkyM
         qD8wFTfhBvRwxDHE2qXJjXzORN74QYhjThrJ6gArd6CDNOdb4kzxoLfaW1gG3LLWLQ0s
         uYVVNIIwGciFln3Ap33Ir+zWAo6c4vLif7BTXDnf4rUoez2dLHtgNlq4ikJ8o/+M/voV
         yMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770160717; x=1770765517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1mT4jzFeYeq6Mu9rOXZqRG9pxtPX2ipQxqDBaGRWMSE=;
        b=ZAuEcBxXnPleSxqcsfa1TPskgme/ASyk03bAf39wdfHu7vTDZOoVAxN0mLAWTBxNxs
         DPkNcqa2TPdmjGnyj52XirK/cs1bgS7csRjnAXH3A8/HpxShaPMea1hWXaOogXfbxVIw
         jrRmdH/1tcQOHH5X8TcmW8AuRrm8gz1kO6c79ghjkYUChOKyENmJNaR9ikc4kF/Bb2Xt
         41sPDB2F5FjS9m8j/ZIu4kvO4jXzpATzh3L0wzEP/HWIMcGdThbuEYGSaMcTvsRGRaUw
         AtqhDcG+SfFFKV8TxjRupelhcXCyGIMz4I7x6Om25zCR0xSzwQgPzLif3rAPp78tJrcL
         BfQw==
X-Forwarded-Encrypted: i=1; AJvYcCXt6U4DcDadcy+X03Pt5RhW7CEjqUhk/r4JlbvhStiUi9z/KxOltdi1yBcSpA0tzUgn1TdOh2ni0Q==@kvack.org
X-Gm-Message-State: AOJu0Yw7uwFvA1gX1i8oYWQkbom7l6FrCYGfsTVDKLCEcybaqiFpCW2y
	hEu5SmEGlKtQ2blxIU9lZhz8Q3wGw8lWRbTROg50xf/HoGGnVJOURnmW72gq+ZoLnX13KfTwFqB
	bpuFliyjaFkbRD5FngYNgQay2JyPufj0=
X-Gm-Gg: AZuq6aKH2FzoDtXQlWEbW5HgolGlfRMwO9vHnVujZvwRT7jthP9Ukq1dSAEucgTAC/h
	QfLiT0Kv83btNrXYJUSoc8dlzyfBRTrvn9rY9q/+MWdT1IBPOAtZyqb5wH8goq6ZUbdf3fbq01s
	9dueo/kdgolddFYVmaZ656bxi96QNmw45y6vI3F/k30xKzes3CuzeaaoL3JQY5XjDUQHzUgPjjE
	ennzZBLUnB3dgtQA5jufE7Vh1A/IAj4UjD8xEEBHAgarvm0f6jSAcUFpshCFh6OiVu/vUUmABMI
	tjZjmi4pw6ZM40BPtSZR2ELkRSkHRJEdoLYk5op41iI=
X-Received: by 2002:a05:6000:2912:b0:435:9653:e151 with SMTP id
 ffacd0b85a97d-43617e3459emr1469159f8f.3.1770160716971; Tue, 03 Feb 2026
 15:18:36 -0800 (PST)
MIME-Version: 1.0
References: <20260121013615.2906368-1-yosry.ahmed@linux.dev> <uhugzqn3k46hchtk4srsa3uoml4ach5qpl4xm5xqdq6egesvq4@7i7phlkyzjgf>
In-Reply-To: <uhugzqn3k46hchtk4srsa3uoml4ach5qpl4xm5xqdq6egesvq4@7i7phlkyzjgf>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 3 Feb 2026 15:18:25 -0800
X-Gm-Features: AZwV_QhjmJ7lwfQSp0GC0WKcRcmNhL4VynxB6TpE4Z2wc4fHVFHXTAKUtNPjW1U
Message-ID: <CAKEwX=Mr_TRMBkDaX_qqDAWrK0H5oPQejhp9JApw7Mw_2PLYCA@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: Use SG list decompression APIs from zsmalloc
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 776EB180002
X-Stat-Signature: di5hq6ha76jwgbm4ytthcbriowx5ggeu
X-HE-Tag: 1770160718-385976
X-HE-Meta: U2FsdGVkX1+ytivufUU8PDOchNAtQPm2AGwRf8MrOQ3cQv3NSvAnEwFFiYP9lxPLtrjgN73JAEaoumUjBPwNIbLWhkzDz6+2VHNLrOhuRFbprxR5do+8lJVrxPOZn6tM2xae3DLe3ZD2sjKUwYnMQM2UL+w9FI3tBPitJIq2rfKEcdLMCt72WzhuRVHVSWqEa0jTSYfDY05uZah/PmoOpQ5Wvr+KrPbE2ITb1RBS+B3HXZmaM6u4dECOjMDah25BhtXEjntH1rwbXHBrivX3jeOVommCBZNRFvHp17r4zKabKUI0A8RN7SkJZegGAoTR1HLWFD+qcUbOx5IhmOjYqjolB/7eWZTq8PSm/1IW6cQZHMYR/hur2Za8ZwAZcTuWEE+QQaab+fgvcNP2rGLFm0VawkT1bYjvhidiybl+N7UMJQuaRcGa3EPdaMtreKpRg0eRwiqFqU093CF54GGLQYFU2e8741498Smk0FCt6Gb2O3b1WD7UQPtkrHJNkuiTlKhF8V7993XZJ/7Zr3AgjVi4usXz5wqFCai9bpavaP+hzUz9q8H1OQ77lFmxP9aHOrkDg7GZCpPgcIXDcYjN1+/XoNMGnO42u1TUDhrMxeRdlqoD5YxdCZ3HZTTCJyXmqzfS8qI2m3HXbE88lBOpdmAYJWiJf2rdG8YKgpC9+t4gwVEsqM/HF1oTouKduqYmXRU1pydMDxXWj8GpBEc7bwX66Cn5rudwxhITc3Axy9gfYG87BJCfmWkSqXHP9mniA+gcanO5qoBpDZH85bHFpepLK9g7W6dzPDHDIpeHkeQUOU80ZyEkiv5sC840QxGNY1kzDuYTOf8Lqgpr4aoCtplLw/RRppj+b3wZeaAFRu/N5em9Dll2OJ/v8dfrLREaY7eO6KOn1n/zzGE6mL+CEuYFctXAUXipI2yIJfghcAmF9j0TKGAnN6c3jUcAJOtS/JJDZs6iCwYFJLHQFxz
 H6e22UOH
 r0TinSU6DtcMENZoIyBFWHZf865cEIBtpzAImSMYLytoqxYXB+3gNsyVou0tGG7eF9eG+RUSvvwQAc6v1jPBUwRluPN6HKdjK0CzvgZsY7bAzGU54a/okfWXXR2HH57W4bp1QiUne6BsDyf9TIRpoTJJfRzTRXM4fmYsT86LCBwZbW5R/00l2RK6DRJ39BpyeFC//x+TCNdxeUsQ1bIOIayrth8W6lOMnOEc88/v2ZkUpSxC0rJcINFhHjaEnMwZmLrqni7WhKpuvkpP39JPofial836yaXp8S4xl3R2bgz0FmCShTCigNrriPJgug6sLYu3pAU9TbLHRTcL2P/eikWBC+d8qdOKP29njzbqmOsdFp5poUf1FuZILu/DRhPoCDf2U4HjUhFrcXpAVUpcy1PzvfNvBSOdc5dfRexFmFL1uJiI50gJYTB5yspXOpLrCy6Z+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 7:49=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (26/01/21 01:36), Yosry Ahmed wrote:
> > Use the new zs_obj_read_sg_*() APIs in zswap_decompress(), instead of
> > zs_obj_read_*() APIs returning a linear address. The SG list is passed
> > directly to the crypto API, simplifying the logic and dropping the
> > workaround that copies highmem addresses to a buffer. The crypto API
> > should internally linearize the SG list if needed.
> >
> > This avoids the memcpy() in zsmalloc for objects spanning multiple
> > pages, although an equivalent operation will be done internally by
> > acomp/scomp. However, in the future compression algorithms could suppor=
t
> > handling discontiguous SG lists, completely eliminating the copying for
> > spanning objects.
>

Ah for some reasons, I did not see this one - I reviewed on the other
thread. My apologies.

Anyway, just to re-iterate:

Acked-by: Nhat Pham <nphamcs@gmail.com>

