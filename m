Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7B98CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 22:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FAC98E0002; Tue,  7 Oct 2025 18:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2EA8E0005; Tue,  7 Oct 2025 18:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F305A8E0002; Tue,  7 Oct 2025 18:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0ED28E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:35:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99B811A02DD
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:35:49 +0000 (UTC)
X-FDA: 83972776818.13.11DAD62
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 70A17100010
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:35:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=e2xG13c+;
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759876547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUJQD6TMxQr8aborn51643M6Hiyk2CEy3VwfT2illBo=;
	b=GtlxCCe478V49/DLBdDXtCs8Nfr9N69UQLTzj0oCIX2TUZg6TNXkYX7hOUCywL90684Ial
	Yt7UhpPYjkXAOeYTxPLsPkX4/sq2E2wftDme9GJondQUNGbp8sCWAmD+lX3YEsvd9NCkfz
	lTmx5mdX75PV7WHW0At/mewDFgUnul0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759876547; a=rsa-sha256;
	cv=none;
	b=nlauGnmC3PAW41ibVYrf/7ANgpKesq+YYAWPatqzFJvcOuxps+q4mdHy39nUS3pASy2oMg
	sWgmS/l3b+r0xgYjOIRymNVv8kfkp06WniOMUJrqaWPjEjIATPiUsNY7EaAIRZG7Iv2fx2
	nnLeMeIYtnaBTnRC9uQK3FwcVY5URAM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=e2xG13c+;
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b472842981fso887280666b.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 15:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759876546; x=1760481346; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SUJQD6TMxQr8aborn51643M6Hiyk2CEy3VwfT2illBo=;
        b=e2xG13c+tm/8CcA4XeJ72kMivF9tfacs1ytrvyn5ahyuKdi+aKfbZy+y1oFgZrEIXw
         CfwUp5jRUvSBol5kIlf2sSebJCEpW6AKWiGLqbSFkZ5kUov1WonEW4DeA1pMwBbGHkA7
         xxeRYa8Fz0oqK4eSZnjn2TPsTwrSjVFUbJNkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759876546; x=1760481346;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SUJQD6TMxQr8aborn51643M6Hiyk2CEy3VwfT2illBo=;
        b=hFlhUXYC/PozNHuIRhYTMua6W8SZ+QTXzINHTyaQ9oi9LZsNurw5wXXVLF4GumNHXS
         Rgi34T/du+zAvzYzOaO4nglbVqEIoNorZqwMLyv4MmAI5O2zKCd1HribwPXUT2ocWZoR
         NV/lBTOcjfAqnS+n1ysd4exkwZq/TSMIe8yCS2X9qWPUEkAO6lGWGCZV/1D8Pyspz9I5
         pNoKFwpB8MmB7vXACKNESLYNFAMVkNYqlO9O3GByAagwVDY5gU35mT7MHMwOTcR9DMkM
         io4rWueMVRkKTCoZC29GkycVl14/AjhRS3U2M2HkJqh18mJ8fRxue4UAwFG8dRwoM4fi
         1iWw==
X-Forwarded-Encrypted: i=1; AJvYcCVK23+gsvkShvGCGZ99vwgadnCImggANhJpTTfic296hd/g6j/qxn6YZ4NcuagYQEP1pxy/vE/wgw==@kvack.org
X-Gm-Message-State: AOJu0YytIQjj56teuocnCNKCnWWsuRSuUVhIE8rM3qHKKtyZbR0ZWwsC
	lUr5PrZxKbLhyJYDq2f4KoATYbaad6oZIU9/eO6RBaBSgLJ7FnpHQKC6xvfMMlS43GQuy7uNRq8
	nAKgyLnA=
X-Gm-Gg: ASbGncvkZb1MEbLR2n1xSb+t9I5NLNq4/ALD0gznfxLDa8Sxss6rhOlb5hzq1mEzH3n
	qLWOKnbhMBmTT8Ws505wL4TIAF6Pw91AhUkfm/JMSaeqgPNDbzaU5YOWHwsvFgQGEM0BCm6lfxw
	6x5O370rV4JPWBxf6W2GYZumceaQA+ccpU6rHx8jcYVCALUHtOlX6L+VSkkGfXzQBaY0l3wlSfZ
	7RUHITTXgDdy8bwjs6Mb//Y/5fidS1Gy9FtYWpFV/0H66fPl3ziwpKf2zUwdz5srHGxCzwHMo1V
	9wVIBKqybmnh9DOtUxMsH91jlv9vYb5orJblzLolJH1+8birkzDRGQf2tKlyzbvO+tuV3QswknS
	dtiPkuDvINhY8raUo/8ug3fQoMGgDhKvu0fErtCe7h5qBXzVllzihOg6NUHvijUPt6CXP9C+IKE
	zUxls0ixg0elG11Bi113Q6
X-Google-Smtp-Source: AGHT+IE3B6J+Wq82UFh/42q6+31S1KINour0ySMHlNy0qmD9ZYNBZ50Abo/dn/ay09WLwzMBgPDaaQ==
X-Received: by 2002:a17:906:c14c:b0:b30:431d:27ed with SMTP id a640c23a62f3a-b50aab9c5afmr136031066b.14.1759876545550;
        Tue, 07 Oct 2025 15:35:45 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b48652aa62csm1455262666b.19.2025.10.07.15.35.44
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 15:35:45 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6394938e0ecso9134951a12.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 15:35:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWxoYgkYyzgKGF9+mr1x/TsV25cRoRtCmAC4zRWRsU9Bo9pGnrc/5ARcBH30S1wmw3Gurkvqopo3w==@kvack.org
X-Received: by 2002:a05:6402:26c7:b0:639:dab5:d610 with SMTP id
 4fb4d7f45d1cf-639dab5dab3mr251304a12.15.1759876544657; Tue, 07 Oct 2025
 15:35:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
 <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
 <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka> <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
In-Reply-To: <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Oct 2025 15:35:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
X-Gm-Features: AS18NWD-EYOWOuMnn_EcBjH4dRmdOnLeMLRD6pujUfuQrjY9wz8yiIq4-85QYEU
Message-ID: <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: wcqaz5kfcstkz6yhjqjnxm5bks6c9ebf
X-Rspam-User: 
X-Rspamd-Queue-Id: 70A17100010
X-HE-Tag: 1759876547-136317
X-HE-Meta: U2FsdGVkX1/zjTdCOb1z/Grst45U9UQVGQwGIcYncWgdMGcxKtiPabsoDkKhTmN53rQ418IdLSDRAe+nyn7jBxs+xeOLZFEr2pRvWqWAuCQ01vWMfI6BvQCjk1F4X9FWdL9QxbV5yFr8Q94KKlmaNcT+RoxLuD3RuXHwlZkcGekVfAlUqo3XwYK7YZTwuhxDjvOVYd/TnAMO9sCwiJaZkUPap2dVg+Z0jMapOkyzkgwMz2sZnR19ee0mWGhbH1yUocNKr8p5ed9uiwAgTewhjvmg/CZS3dQr+R/J6LRMRd1WNYq0pzNQ9ak3svD2i/bmmg0F+9zKwVPe5jFEXdIoOiZK4D5ETDiGW0/yL3RxJAQXsWJ5nqYCFqAFH03zRxIOTCyrA1ncSLGRZzqlLHNYKTDtOVk2tcTZR6W5VJp03bdF/CThAs3vHVkVIwy60S/SGKz5NG1uwqjHabKh6o+jUIBN08eFAQ88moAeTtXaqKsZpcsZ+Wyp9VTsAPrS86RpuNVtsJXCtK8TTnajnogR1LT+JMesrWr3G/qitgvGhKVOOmHp3aOwg24kCtvhEdB0DE2DnbyGAB2fYlvaZudReoDmLMSy45HWI9VGc0aUPKNzVc/EO8r2/iNJSB1LlFFQF/gG9lDdGIDUjVvijEjn6PrqmId8f3IYYFBRuUpf7YEb/Fb9JaThSH5eENELpxpsFQJMVy0k+KvYSf46OkHsb+d6OB4HQJ4/W2vQw/xnl4itRUqCpVtMKMnXKCLoX90YlbuInJAwdjWqBYf93kwWkCyQMSfh5uu7BiCpHfV145zRzg1/fKPLNHy6aZQatKyCcR/ujedd0jW4fvMgUAZC2NC0SMeeJd1ak+DrmvcSN3ksHqz20WiC8EOO9hd70uFiYrdydrGdwof2MRBfTqk5eXhGL3aaVAIcARBdLsVTtT112/KupvBi0XD3md7JEOXi/ncdkEDbU3+DT2t/OPG
 2YpE/v5F
 wUdXmsbE2OoBBPHCqaf1y+8Yr3Ei0TbWcYpBCoP9t4meAbibd25M66yLyCUh4t7msu1wGu6ZzYo6dXiEaNU3nHfHPAbHPYGDnhKw3FJit0+Cikvx+dkZJe+Dc/B0o260V/MhHY07DpkBvFP2WSGIjaYbdn30MbpAJDuCxsOcP+V0ZIWRLxdGszb4GIl4NilE1bD1YwZZ0q2bZK9440z1C55DiplKJP9lpuMZU+1AwVTvAeM3bu6/wHDkPX1WK+XzXpCgXWoFFL5uShe2+HVNGfVcCEyM7UVKoYNN6e047fDCZsEM+S8VDfPmhl+FMIUoSH7VDCozsiCLm4oD7a85O2J9KoXBk6YORYOicHdW6DLfb2QpiSsDZWD3y3jMie/8ws5kWCObizNULEGTCJtuFJAKtqu8ld+y5k1yuR//wpK+qrPZbmYbMFfqOZ5n3W0iRnNhRhkbvhuGA2UAynBnF5OjD/xVPAfDfZAEnIIysjBsq0SCnDYPfPSjsek0smRnjZaaIsj6HCcgozZ6brlEBav2Djw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Oct 2025 at 14:47, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Note: this also ends up doing it all with pagefaults disabled, becasue
> that way we can do the looping without dropping and re-taking the RCU
> lock. I'm not sure that is sensible, but whatever. Considering that I
> didn't test this AT ALL, please just consider this a "wild handwaving"
> patch.

It might be worth noting that the real reason for disabling page
faults is that I think the whole loop should be moved into
filemap_fast_read(), and then the sequence count read - with the
memory barrier - would be done only once.

Plus at that point the code can do the page lookup only once too.

So that patch is not only untested, it's also just a "step one".

But I think I'll try to boot it next. Wish me luck.

               Linus

