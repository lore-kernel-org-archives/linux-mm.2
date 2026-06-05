Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90AC4CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03D606B0095; Fri,  5 Jun 2026 13:49:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014636B0098; Fri,  5 Jun 2026 13:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6DC46B0099; Fri,  5 Jun 2026 13:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D41956B0095
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:49:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9267B120245
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:49:10 +0000 (UTC)
X-FDA: 84846595260.25.5FB0C1D
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8CC25120003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:49:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J1WFsuJs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780681748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bL0mt9L5qkKL7DK4POAj2zg+N7KQbr99Bzyd3BUci7Q=;
	b=lGOZxZo89ejKE4z2uQCmUKlJGmTpppqBlPcoZFWxnZzFLhrLA1+IW8X1STCjQZ/t0Nvz69
	SgyevJHlo2QMObzSA8toGbeyVgAXzl9fvN9EqqOq/jzDuo57Os+aDMzhk+fvg5fVWVD3Sg
	F9aTjYPybMZtML4xHRTZg+xaLrfYuPE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J1WFsuJs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780681748;
	b=AlbAsHnuQg1Xhqky0YW1BaEW6EJelCpM2I53/LCcddsH9bo21pu0wf3NjknQJ/ekLjbVCm
	W0d4eG3i9Mu5v5FIFnotpw+XaMiIIOj6167w+/C56IAKxuono+JGgyb8T4xpJy6HlEhYNF
	xmxNHmIMxT7jB57Cn6NFUePXs/lTvAo=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49068493267so16829265e9.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:49:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780681747; cv=none;
        d=google.com; s=arc-20240605;
        b=J6dzseCsLiY1D/zjraP/C/+duFwdwfUNExwetOu+pdbgrSng7X1BpRUkXeRa64Ez1F
         qPMampfckHJJGy2qWpz00e0T/eqbEwmORb2WoLoqh0lR5Q/jW0Ljipy1UL0E+EbsJNrd
         fdQ2cpLnDRnESDqAR7sZpG/jM1RwnTQy6k7BVXexNMyZctRFlVJ65nY1C05YUR3HsH3v
         3Pi9W9DVQi6zhV7HwjbwzKOW3WFc0v455NGpCQx2YQ/PfIH/G7ZIVZpYIxRLMjpNYDDm
         D06YkdHexJw4Ed6dWLfMEcgOOeQbK4Xtd0lpAdiz7b4LrVUo/Ab1VCUgFKXURUcUdVXP
         wFhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bL0mt9L5qkKL7DK4POAj2zg+N7KQbr99Bzyd3BUci7Q=;
        fh=jTcuOEqXmH7xl0dYa+kKUtoEkXM9u2z5MRzDTXx0Qqs=;
        b=AsuuKgHkKPEpSUmgGT8XvwhO/t6BRfdcT5TihVsdjuP606i7Wh3//Wam6Pjz3OUNUS
         DNM7v9ePnjshybzsG8U3TjSKXjCZzERNxnrXpFzcqR8Lm09w7VWz4kfAAbE1sl6od81L
         Up9y2fVdgvawE9SH0WdMPxpPIxoGCoU6U/jX//J8g/7zkQGDBDtlIDNgXbH5sMVY38HH
         uoqa8wJyuRThoMLQlRpyh+Ants0ujwhHhrBMnkhFT1igXEdGEMPLZkr9F+qdWULG2py1
         aUQHenha0Vx3wj9UbT9+/9N/PcSpDCzO2SgM/FU/TusxdyEi/Pn6uUXqOLAESEQlxfkI
         rzgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681747; x=1781286547; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bL0mt9L5qkKL7DK4POAj2zg+N7KQbr99Bzyd3BUci7Q=;
        b=J1WFsuJsKJ5jLro+6bB2sNmuSpcxXbB4NkHc49y8PckZlf6gFICDOCLaCPQtK5Vrme
         3rV9mTSfboBIi0jOb3ACMk9Rw5HILi23qQUGQve2NUJS0OvAq8aBPaVm48hymgWqPwNX
         cuPQgDNUg4VAVep3nzaxIx/1iS34eVRRGVaToTkAkcs+H7o3SqZRKetQUBNy50tFeP34
         2TjZtPCEOMTN+UUeXkGvDsjtP0CL85h91LAjVBKtw/daghESizA0QKrt34UCP5wS2sMD
         eULDkUqxGCPCpYkwj2rQE+oM9jg6ElWvyhlmN47euEU/KN9ivFnAyhLvoaWopihk5Uhq
         O1vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681747; x=1781286547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bL0mt9L5qkKL7DK4POAj2zg+N7KQbr99Bzyd3BUci7Q=;
        b=se1Qkgs8/HU5qgT+sv5l7qZZIB5OYg73xbhY1ZYLdVvHnse02jUrWkco5eeeL1GHw1
         xMC+rU6nMLHs82Rzhkg1DHcICpI0va9UWqoVsn6XZ1lOt+nHNzFAfUK4DJMhOJ9pf2QV
         70edQIk7HM6i6kkYk6HGl0Fs5W8DEaYeQA5WXvdVLSBHPbN23YjSol+IOkOkGUIdhGrh
         hU9VH/t4iCNp29U1tr/X8ua4Q8m34mlqfMG692/Up60ZNEtqbNOLS1QiP+Bnr9WVmD81
         +EjVLDakpMafHtXSjMadLxFK58lUDLXGThAh0GYJtAlzbwOszg7yxq3AKoJvmCTsShet
         t3tw==
X-Forwarded-Encrypted: i=1; AFNElJ/NYCLxOD8g5Ric6cZhgMnVa1NIgmWPrqwWhxP+2SxRleiUeOWDOaTPcmhWMg3/2eLe21BkPT8jKw==@kvack.org
X-Gm-Message-State: AOJu0YzY6DonUnyR10wLQlDuqy5uKtuQEiBSK2rT3rinmryuDnNojWxZ
	lGE70zAu//gNovpaAdu6ptU/juoPXoXGl64DSgmZ50jDHPyJcnU7OWeaeESyAEWLDuAvig+MvHf
	HkAK4yBiQU5XWALKBn7SUDD2z9xnfx6o=
X-Gm-Gg: Acq92OFR2juIBHuYamYnvWhmnmPE8cs7iXJr5/lUXiBxBJzTStAFltp9SrIXE/DXAqe
	Peuf2ckCa+gz0gM8vs7nkoirftVk16qdYG6tgRSDCGdGYhb4HzVyMYrcrWyRisHE6enZuMmO/Ti
	86MlYUJLgvoCyqmuDNtIBozofwJhjp3jezELfG6GZHj+EyOyDSbjLgfAu58XBBLIc0q54Ad6tlO
	yGvFthF66QmMz1cn849/x/Wx3YM09B26ztk6S0antrBdm9rFlcd05TTYjtObOI7ysF+n7Rie3kE
	GVEkl/xLQB/f6PIclEXooXwjSaHk6ZnYvCr0wcDOw6NITTJsTA==
X-Received: by 2002:a05:600c:46d2:b0:490:b645:3213 with SMTP id
 5b1f17b1804b1-490c25f17ecmr77898145e9.19.1780681746944; Fri, 05 Jun 2026
 10:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-9-hch@lst.de>
In-Reply-To: <20260601113449.3464734-9-hch@lst.de>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Jun 2026 10:48:53 -0700
X-Gm-Features: AVVi8CcdvRejK0vNcHkKvPAnPjUsBdxLLoTzRZ0n8MpztmgU3mVTQgLl1GlTRQ4
Message-ID: <CAKEwX=ONzZhEwsW5TG44FnAA7OZRm-RGwbij-CUx16O5M2FeEg@mail.gmail.com>
Subject: Re: [PATCH 8/8] mm/vmstat: add NRSWP{IN,OUT} counters
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, kasong@tencent.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8CC25120003
X-Stat-Signature: bmrfeeeqonmnhgs8pynbex3kkswno36p
X-Rspam-User: 
X-HE-Tag: 1780681748-637137
X-HE-Meta: U2FsdGVkX19DkFrk8eMVHQFTUIO6/D/f79aIhnl5S1at9m5TzCU/SPDn1u52eYqQdZQKZbk3zUxZd2gb5XysH1aNKf4W5ov7dSBO7gUclvj164jRqjl6+ccLjN+9nrRodogNu7KCj6q4OotgPpA2iz8axuG52zK6PXZtzFXOiLvxnPTHwUOtHA7eq/CF8OQzNc/0eslqTdhrRtsKEFMs+XpjZpOaFTkVTLY7Ez3z/ThBT3lfNblsPKbSDldF3xMtUn9onRiRbWIEiOJ795MCo92POgzRii56KCRQm0RtwWBscvqqmsiuK/HJopQGla6I1KGceb2Y54rNzg4RonqA50vRSQ8zxjlJYItDrfW0JNz9RPS+OPTAVAi/TP3IsXlvgll/HiKp/T1bZNeO73ajRX7YDoy1jnMUeQnWSjgL71rZA1FlmBzdpW3pKhRQxIRXyto0jMhGQlVK9AEq1LuGvGVE7BmcbWjcSqlwzlYyjpzFuhT6nO46atvs+SZ21BdRRlNXoX0Alf/2ZZhjmHP2Lgfp2h2W88G5/eqkN+K39ASUeTQlPtozAe0qfXP/6Q45VPhW06K6FXLpeg0TBWWgu28bozfHRGk7hOxyhFOjbbXm9BQu+uPy/k2SqRwCkglNuzSKRWMjTBBtTjWdSc35160wCFW/qw0P6k9pu41j4k96s1uShnuy/lVvoycDYZ6wWUrp1wFms56IRomZvIE1mDPdUhKZwKO2QcnWQGD6I6ChgQFDsoo3Y49Wyz7vWJEGUJ2l9MfB0rNy5SLLjFhzjIw393sjo23DvLv4PPfxvC8Sno64V69IWlyMcyhb//kQfqvqdzwurMg1/oeu/m8TFXis593CZk+ci6ChOvZddalEnGqGrAAdEAyhfSQcoeaGjslKidUyGOLRqqNP8HrGASOIHKYk/Co2hjUunB1dxPu7J8qcX08mT1HqnhW5P/8HNveZLb4nEEMzn5oY57X
 /w+OkXXx
 YkeUyLJFVPwQzJfNqWrjLgZBM1HMeMgNpyRP0OuQeA2sm6lFEuuqZjHAQHVa7bAdk7IS8YsIvyokvkDWvK2fkG9JS+0c/Izr9EHxbmd0CtgL6mdvhuVSgCZuZ7ZMhGoCAeUROljD5BMUBqoogb3Z92HKwB6jVjSvK28PfOWQ0McaVyiyI8lPDFMZM0y/94T/U1JrTLGYt1AoWUzj3cZ/Hkk3iGVX7oXRI4UPWvgyKJsm2ku0BnT+E7UTt+M8qvjPeYQpTm+Mp/yGHDpcSRytW49QgozKxZU2FXpAiRb+GMGqUPyXOdhmKCZ73qTymBjeKwMnW8jx3K77myGup2Ezvz3PrYJpXN5fZsVl6FIAa1RQGbu/wFAFwON8aPFvpaPG1ikTJyA3OO7Se6hn6EAqdYmNwduNdIKs/Fl5k/mA+VR61Usc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:35=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> Count how many swap I/Os we cause.  Due to batching this can be
> different than the currently counter number of pages written/read,
> and tracking this information is useful to see how efficient the
> batching is.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/vm_event_item.h | 4 ++++
>  mm/page_io.c                  | 2 ++
>  mm/vmstat.c                   | 6 +++++-
>  3 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.=
h
> index 03fe95f5a020..2628ccda076a 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -175,6 +175,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOU=
T,
>                 KSTACK_REST,
>  #endif
>  #endif /* CONFIG_DEBUG_STACK_USAGE */
> +#ifdef CONFIG_SWAP
> +               NRSWPIN,
> +               NRSWPOUT,
> +#endif /* CONFIG_SWAP */

Same question as Baoquan regarding merging this with the other
CONFIG_SWAP section, but otherwise:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

(Was also going to suggest documentation of these stats, but then I
can't find any documentation for these vmstats at all. Oh well.)

