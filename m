Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36845CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 16:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3FF8E0046; Wed,  8 Oct 2025 12:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4BE8E0002; Wed,  8 Oct 2025 12:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1478E0046; Wed,  8 Oct 2025 12:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60ECB8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:28:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BF8E140674
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:28:06 +0000 (UTC)
X-FDA: 83975478972.26.7DFA873
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 08E201A0015
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:28:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=aG6Gl1qD;
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759940884; a=rsa-sha256;
	cv=none;
	b=a+u1NZGOHw3PXCGxmHEKtHmNSXRVdUvWMsvu3kQ/vfcVHOCY7GJA2Gmbv6Rxb8UsH9Xy7w
	AQ1S0KdrxUmDeCq/HGDw+2Uf75haJH63OkS3zGp4cwUKbl4Cu5orMW/btiXfPtJgiJr2Zx
	nUCKzs3VVxOtUi6C5aMd9pMtayYvhGU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=aG6Gl1qD;
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759940884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ig2GLHE8hlKLEgmzJH4+emiSgZo32NUB86/I21OU+Y0=;
	b=PvGVQuEUDTq9uFI9cppAN0h+ShlA1+Ykboxyump4hcKyR8+t36XMbzRi1vlES3/3LtLg5F
	XIP41OgNps4oTsrvygdWECF7ZjkumUoYE+Ib40tQi+b6ZQx1ZzrZ7zR2xF1eM5ZEP1b5pB
	puCRhrtmLEodamDxPML4sWnt4FnTXus=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b48d8deafaeso51081466b.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 09:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759940882; x=1760545682; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ig2GLHE8hlKLEgmzJH4+emiSgZo32NUB86/I21OU+Y0=;
        b=aG6Gl1qDwV3uOj6iAn1Iz9dnaKHOqwYJK1IG80tibxQOzrWW9ngn68lzArUYNUOW9/
         YW1eN8E+2/gXqRTfHZ9CMVA63EWiDPNz3YUYKVYSXQNFLPN/7DpZC/4ovT7S7/SAd5cV
         7MPUQrAwfsah1lOZJvKda1ivMkghP28OlgqRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759940882; x=1760545682;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ig2GLHE8hlKLEgmzJH4+emiSgZo32NUB86/I21OU+Y0=;
        b=bk4SYNmTJGR1NDW48Uy4KH2JFsqP4PmpbEexZoJ+rKHr/hB00qg7LUISm7RF1tjc11
         MeHo0pM5o+EzTtxG+E8WomLfCKe9OPmzRlM3xmkYMeD93IgsExaRqQEY6sA219hgc45O
         e4ED8i6R24NtoYg8JZIqGXJMAzea/hlKmT4ItBpiD+UWO4MK4wFD1itWFZlh2/iO44uE
         Gqs3g6zQxurs4h0THWAE9VB6tshrgBHFXKjAaeNkydbTN4K7VrDLVQuAhFY2K/jD4vUO
         78QXeg989zQD30HFdMqktmcIFEDXHDrwJrFDT4V0K/5NNnOCr9aXy1EpW5g1rLw/o7BF
         8ApA==
X-Forwarded-Encrypted: i=1; AJvYcCV+qBE5R6jfIsYp9gv8sZ4Ubd94E+Utdmx+8nc03AFfozNJcWoGFlpmtctyx1FLTLSo/nx2yOrTgw==@kvack.org
X-Gm-Message-State: AOJu0Yz2NMaJ4aEfV1zsAvTC0ZOzNdwd3VBXHTSY7qc7IPnGoE2Zi4/5
	IMJnY7i4pxrTasYWZ7GOH5xseM0O9Y3QJvUZKuQHVdj1hOFIvI9wGkgAqqmPGlBs1g8qgL/JFSO
	Yt2/F74c=
X-Gm-Gg: ASbGnct5Z1wUhlsJQjabYSAQyy2OMR22DatvzFTFSaghpxnhPdTZeHynlZW59mXSajn
	8hsmMGQEfWqo66bbDJ1kYOst1uGoEioYTQxlypg17XdhLgqrrI9S9wup425D2T1w2qtrbamub3B
	jDq6napR6t8Hz3Xp73+nTHGWETrmq3LNSjAX+xdIiS2zG6kYnacPabOqXUNaj1LX8Lh33WoFMbu
	7cj5CoBZ0rzZN+gR/PstmDs2b6ZJ8W56hYOiiRoeXFyfQBefLDZ6WsmpwFCuFKhU1NF8C3G/hr4
	9zP3j87nKKaV2kxByweFJMN+OBi9YKX4glpXfSlwwbaukXSLIrDI9wjdkj3JPlp+mgb9tPy5idJ
	Ze9F/Q9NiGvj8aeCcYB5abQ/fq3A/GmB4aaIoNoCxTJqwXlFB0d1+n+E/ZplDxmRknT+k/ampkp
	wddcyTpDfEYdFgN7Jf1Dl2IIsIAq0hvn4=
X-Google-Smtp-Source: AGHT+IHJQD6W3JOGmP38k05RpgpfnOihmynd/HN5zvxeYSm1LOOnB+tgYROjo1wox7+dtkxIXXNSIg==
X-Received: by 2002:a17:906:c104:b0:b47:de64:df34 with SMTP id a640c23a62f3a-b50ac5d08c5mr451506366b.51.1759940882226;
        Wed, 08 Oct 2025 09:28:02 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4869c4e5d8sm1673683766b.82.2025.10.08.09.27.54
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 09:27:55 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-634a3327ff7so12931a12.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 09:27:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXmnf5pLx7KxBt+q85bEkZErlP6rF8T2+8H37rdLANOfZ6NNImhT+z70CEzjfSxp+aQCbh2nQUL4Q==@kvack.org
X-Received: by 2002:a05:6402:1d52:b0:633:59dd:3566 with SMTP id
 4fb4d7f45d1cf-639d5b5d47emr4199002a12.6.1759940874133; Wed, 08 Oct 2025
 09:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
 <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
 <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
 <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
 <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
 <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com> <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
In-Reply-To: <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Oct 2025 09:27:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
X-Gm-Features: AS18NWDe0QCBO_xfFFVdd4_0oRQnca8OG-hxRX2CoFLKyQS13SPatIyxuAJL3zo
Message-ID: <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 6sadc3dfqdyytzf4ueoroajggtjst5g5
X-Rspamd-Queue-Id: 08E201A0015
X-Rspamd-Server: rspam09
X-HE-Tag: 1759940883-677149
X-HE-Meta: U2FsdGVkX1/825kL/tuu7wXXRAEdgVMM5i8PHkQMKN/OAVIPwH133psfmUXpqXCFjBlXNbtiPikvo2dUV6xZP5oeV4aLUNvaMD7j1WLQFMkxgialjbhxUxRThc7ROnuHr0yqAQ8DgouUz3XdomIdzq55FkFgMJAZ6MY7W2wJr3mwCvtDNWj1nToX+dF3+/wYKxY3NxayRGdVtPOEdugfJ+OOoz8tugtzl04S4ZA7T9KykSMzCcQebmkoY9ZmOpV8OQXvv5qPk/Nc/VWKPi76ppQrpJgNPAK6Bd2MPiAAZr+2X/oLmB+sbqLdbEy5cP+cK/O65AcQrWT4oJFVfj7++/aM1evct2w2k/fFrASUqz2pl3UMvKD1YmIfuK6Ss9FZFEdyd8SXURW3DzsEReUfrpsIriWQA+DOauJMs3UoNYCCNZ+Y9A1F2AmedZVNaejxhXArAnlVIH3iQ+Hy1eaAvxlbSfMpDpEYN/95el3iFuFHtlhK+rKy35z2MruCihGxPBbNCaCW4HT9aYRLh8AyjqH8/yXzodW1G0IWmWkim+O1BbGB21Tjg1A5o0sIb4/bFQsz84ADUpDYuPSoKZiz8rBl8mLpFngs0AeU3eKDv9OGh8iNKqsSKMgbOICRLhNu4fPzIQv+dQA4AN74gPg2Z+m4IuU4ehaeCaDpEiFuR7B0Dv0IUz6NcfqhkHm6bivC5AnEhsjV61zrjX2g+WzrtEpq4Ofpee/qWaVnimsorZZXanQM2zAyE1XxlAiuzwYfVhc5gQSXq6oKkApAQk242QyWpqogIEmvi2+hFwRw3WI0/RpwgS9pGzk5E2wpP0M9TSrT09TUKWPVy8IloXRX7nZVBDu8S6h84NAfEq48kdzMITRXjiElvN41w2Uxt7Uyn/gF6nAW1zQTU7zdqXkMEyQW98I7IlzBDYEeBPGhBrDhkccg9PeglWkbqEKHvwvx2rG2G1PFXbqbrNSeNaM
 keHNEHJM
 hM6aop0MEVqLPHwZ9+v5ldKy02Y7JP5B+n8FaoXkNdtvBL0uMzMSlKdHJlu64jDhFbtYbKVR7NRjJMn7eB14LLE9SV/kLIh15e+OvgD6d5UgsRj2CvgVQ8bD8D6D4uazSEBuobfB8Spsb4bA/7tETw43x3iiGpTtchIMhhEguQUWanVZDXVI/o4/ud2MRxopsxGU4lN/sa/uLbEpBRwXmf1+N5uu8d+n3MdF5ivgpQoh9eHfGUf2nSgrDUMLvVP+PrM3bCpov/mXclx/e/hax7UMSO6ViX/Pg867R528wkHMMH+WwSsF+bHQd3gcQyywCS2/2UKrKFXNxOMzjPIrlOpIykmfcM2qvzQSrHjibNwwcq9W4cAGj5Ffbba26V/NA53ZmHpMF/n8LcJc3l7AvviEwa1xh/WQrTawB2YP3IoRRSYx5mL1qWXO24T+lBaJOUmHRbLjnI+uzcVKAygOyUqCjhWoeVUJYGQGm4K73kOwgxk79WJJzs/XcMlpOtwrLDPbY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Oct 2025 at 07:54, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> The best case scenario looks great. 16 threads hammering the same 4k
> with 256 bytes read:
>
> Baseline:       2892MiB/s
> Kiryl:          7751MiB/s
> Linus:          7787MiB/s

Yeah, that certainly fixes the performance problem people saw with
contention on the page count.

> But when I tried something outside of the best case, it doesn't look
> good. 16 threads read from 512k file with 4k:
>
> Baseline:       99.4GiB/s
> Kiryl:          40.0GiB/s
> Linus:          44.0GiB/s
>
> I have not profiled it yet.
>
> Disabling SMAP (clearcpuid=smap) makes it 45.7GiB/s for mine patch and
> 50.9GiB/s for yours. So it cannot be fully attributed to SMAP.

It's not just smap. It's the iov iterator overheads I mentioned.

Those iov iterators are *slow*. Well, compared to a small memcpy they
are. They are out-of-line, but they also do a lot of tests for the
different cases.

So the baseline obviously still uses the iov_iter code, but it does it
on full pages, so the overhead is much less noticeable.

This is why I said that I think the next step is to just do the
user-space case, so that the loop can not only avoid the SMAP overhead
by using the user_access_begin() model, but so that it also avoids all
the iov iter costs.

                    Linus

