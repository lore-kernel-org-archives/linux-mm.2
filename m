Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A6BCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667A66B0005; Wed, 20 May 2026 06:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618756B0088; Wed, 20 May 2026 06:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E14D6B008A; Wed, 20 May 2026 06:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39FC66B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:56:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEFA51A0288
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:56:37 +0000 (UTC)
X-FDA: 84787494834.27.2B0C6A6
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id E1B29C0007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:56:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NdBxGnFo;
	spf=pass (imf22.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779274596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmlqINBz2Q+ZrcrpkgMZGpbGEYV3/LLrzXOGi8nt9xo=;
	b=dNefJehE9wuHC+QIjEWf9mqAUhKbCQsUctVPw8I1TGo0MfiCMT4ulHwvY1uSEA5JF9nOVm
	57sXuVj6IvAia16i6HqU+DD5hncVWrligjCNM/3A45WX9JCg4Bb+jHMUftygeoX1c1m4hj
	g7uIFKdmqYslvNdenGLqUATn3tSxhrk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NdBxGnFo;
	spf=pass (imf22.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779274596; a=rsa-sha256;
	cv=pass;
	b=sIVFyqdboiitkaW0rt9a5PXN64/YOGFwBEIXULrMNUhJSVIpkJ0rD+xNuuDbTorq+81IZK
	urZv+lyQ+927ROxFkfz5SWE/RkpOs8N77cyImGNXA6c+ZWJFx4pyu8lkYXyLpjX9L06J+3
	eTBUM5ptCYZGvuXyiNzUPjGBSrtOuWc=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-44985f4ab0fso2478379f8f.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 03:56:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779274594; cv=none;
        d=google.com; s=arc-20240605;
        b=dU6VmX240fEPLWn4BUE+XKMsaelToidga1PzLB30ztdZjFM/GiAMDdgWRZv369W/L1
         37kARUvMXxEzsYTWRyaEnXn+pY/zMNfYkx3chK7/p7RRPXtcFyvV799lUxlkMxh8TO+b
         G+zwFqBc2VbjvzITCMJeeLZ08dZHpTSYhQ7SqmFL1nOt8jFWB2e7dAl0tKrQuSTo4QkN
         aHjw3Zzd1YFEhXCUP1QzLFQlnRyZSTAvftuiU4jI4Rfz5+VaxDoYwD9hm1zG5+zieUZW
         rWaZWp48DRnPfr4zOU4iQb4UXD4G9TUG1wEOhFbbJrSp8MZKL+jqvGsL/IecQDhdpOlQ
         DzZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EmlqINBz2Q+ZrcrpkgMZGpbGEYV3/LLrzXOGi8nt9xo=;
        fh=wM9TG3PWZkrWI80b0JgZ7b2rjM2jB1MRkVbzCAOiSMc=;
        b=QGfhZLO/aMt0Poi4aOOhSzV6OiSNUH3y9pMF6i09BnsqV1dOc2dF9ENUDmuhP1rFXa
         AjNWGZnCGNHmYCrWgagxZkFw2Z/kolOst8wzCPJlE63vFV2akDFSOhTIh2ekaa/py+aT
         BWkEHkQQPzIWAwNPHs8H5FPaOo7IEiT9/HjqIXKOX7WIF4YJ16yF9XccOD88ONb5b+DJ
         q1zDmbvS2Ni5oyFUjdW8x6K+B6zRJoOzDZIhtiys/1AHap50XXRBqCHuI82clK6RJanh
         w+jml4WjjYwPLoH7WysPdK4ntCxAcKwzxEK+MSvqtfD9fOPsOiRiL7cpAHwWyCvAd/fX
         rbBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779274594; x=1779879394; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EmlqINBz2Q+ZrcrpkgMZGpbGEYV3/LLrzXOGi8nt9xo=;
        b=NdBxGnFoH7bYu+ssumhf6hDDb2swmS+slIhG0kexqyAQjzup8eErjhlMdu6A5Weaf+
         cxPDLLIxaJVl7B+TW42f7m+yTpCwYBctmoFIwL+gRz/Zx143acefmKT6jDCcR+ifAiml
         v3IA09Pry5xmoHRg1LQKo8lbR3eB4qXQ5p8b02li93TX+0uHODR0vD7sJvZ3FzS4H4Zp
         cqEX9c0fpi9oUNqGL+nvqUnWnjXEoW3X0hK1fkTDSYbFg6bPARO7RozLhC5XfLAqjprt
         ZUwFGvWU2blh9PkJwvJgrInrHHAZkru81cJT444EqUr0RBe4wAdaIRtX+NyhANkBZ9Kg
         Z7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779274594; x=1779879394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EmlqINBz2Q+ZrcrpkgMZGpbGEYV3/LLrzXOGi8nt9xo=;
        b=EmT4jKFOhGMhK0WITTv81xkbn+49hHxJaR+wSAmn7i/9rwcD0R501vEkBIv8YRjCnb
         pDVC4kkKU9qsZhAb4Z/zZTP8JQ3nbiRcRn2Pg+QOkHODQ5RZoVxM26Ow91cH9AhP69Yd
         iZSiiB99k6DjRXnoHTgE77gtT6UbMpHddryEATNaQXCK9ULhQX/QrlHaewOiViI+2AD+
         90Kyy2X7+Efx+Cpa7Ra6+2VN5Wg1Z7S3rAmIiya8UGgwXu4v4CGEe3TeI7cO3Rw0WYmi
         zX3AWQtNJ4I7OM1r/7d+nkEsvI+hYyliQiKVcV1/JVK1ZPauPqmKXe6x/hTR7njfDeOl
         Hv3w==
X-Gm-Message-State: AOJu0Yw8ePV7X0waQsfrZKOGy3Xtaws9guV2fWDpplSr4T5QfxW6gdxy
	LIYePDSswyf7ntyzVfrU6nrgMxHHAXiRfFWsXv5ebjQHhpIiJf7GolxahdQtrSqlS36Od9sE+F5
	mq9QL4BW14r1UOKc8uNHdIRtLjD3RZxQ=
X-Gm-Gg: Acq92OFxWMhQCz1bh33kJUjgXbp9IlgqWgdQlPwRGuGCFROB/6WbVhBFAvFPB2u/6b1
	O1mux1HAYU+VIPQtVWp+rrNEmZJOBcVTV7dOdB7tOeY7ZGEh74+An0tPuIsz0MqVA+ZkwtjlrEe
	pEQtQpm/7/eQGD4cY+V7cYdyLBEtE4lPgXFLEl5yaVDgV4WDPVU05uxyffzzhQvl39HOwOMOko2
	gJWZXeeS1JqUaLGZDVrezTH5MzMKvXMuOP/g5CNLTMr/ZZT4UueWKF8tI8XHUxqq7PPsCrBy1lP
	s46oLt2i
X-Received: by 2002:a05:6000:240b:b0:451:2157:6291 with SMTP id
 ffacd0b85a97d-45e5c5a5eb0mr38367387f8f.41.1779274594138; Wed, 20 May 2026
 03:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260514094108.2016201-8-jiangwen6@xiaomi.com> <ag2CeHWDLLglCF7t@milan>
In-Reply-To: <ag2CeHWDLLglCF7t@milan>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Wed, 20 May 2026 18:56:22 +0800
X-Gm-Features: AVHnY4IoL99tDi7mKfIv1wB4vUPhlXOzK32-aiChnWRxAqCCSOXz9iauKTOd2JY
Message-ID: <CAHKocdEKjbuKjpBLCdz6ryohvQfZ0ucOjxb36wKziTs-ybaCnw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] mm/vmalloc: Stop scanning for compound pages after
 encountering small pages in vmap
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	baohua@kernel.org, Xueyuan.chen21@gmail.com, dev.jain@arm.com, 
	rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1B29C0007
X-Stat-Signature: xcmh936w1g9q6a465bowf6oncdzsxdqt
X-HE-Tag: 1779274595-939583
X-HE-Meta: U2FsdGVkX1/fe5sc3lPwBLlX4VNiyC9+PHGAg9A+LB57k90v2+JC4UYV14AZfX6vJqAqKNnU14sjhGmwjVYdZZLvbLtgsu5Qb84Rz8/gWwLoW6dazz2LL2obgnAliGp5QdCBNqVK26sc1OVuQi3c2FU33NKB+T4QAvfLdw0eat+xfHHK/t+jjB0N6B0OKcjsW77DkrPiYVnIczLndylcx7kx4SonVgbt6sOrR42hjSXnAZgHoNZTzvbhdc1tI+Xr9axyhxBcYEDJ/5YSmJVRthq5kYoWlV7VFjcoGCQjvJoFE9Wvb3k/JFLeCr7Xs7A2C+OeidZuifsHOc5IkapH7/dEXDmAkBUZwKg2op2QuvGV4rM9BtTMt973dJfowi1YU64QTPWtFaFW2jIZwTEDnahC7j3t3QVCYNrr5swhT7d306epAE+VsMHCN7zfH996EDlIuyN1yibOQty+U4lx+s+aL6MRJ95pKrjZhJkqqEoM+m0y+yVahKUulN6In4cMGfwa9oZ4ph5wxkf+WBHT6KBPmJgyyBUZ9t7gb0Va8xJ5qgO8G7MdnNz63tLRYV3pzl1XN7KDKpJgGLd+TxccLhzyhCp52utysTh3Y08bbJFcOdGmwEqRSrIJjebV8p2d/dtxfJ1VuN6UcRhkwXoBwlg0PthGlnObtgsf0N1Ab/FXYYc7ASi84oAQ8G0d6gFSFFmmSGKhi8bbm6eleycH4adOE8TT9umt1HFCl40PiURa6WmFs53xQ0CJgJXXuA2d7TBdpuom3Wu3Wg7x9uLaMmiW3muNKqaNrRXrSCc82YAc0JF4cji0NLZWWivlOY/+1ijq02nyZSUQwNTxH12rnriaiyVsjAUjzgg7LTtMxX2sjF7xJa3OUGNMrH/1FbxQoyx5gAK5wEMU0DMf7YtzbrOiiwBzqpvPX/5iglxOdkXUBZti8pGcIlIFQVt+tGArFLpBfUj1Vm1xUr+H4/X
 rlBm9G5F
 2IjOhHzCAuxPysyImFPMVgw2VVtaesORHd4DZKyVBAFQIHt2fMVECH1s28Rk3xjwmRF02BMnREno6gBsRy0tu4IIDMINbVmPkUwH+Ql0WupyNUYxPaQ4o4V1UuUHkZkgFV+SUlxM/HPTU5USCoKIBe8gutDln2OR6Dt1XtKPcupm/FcsZxtvh/SOy9O1vxBmxOq5Oj9U9+sPxlmmOsNtF+WhZED87cdHDq+VyQSPrgT10uueAFvT0A3ffLYlAKT5gmtGWFziW0nBn8+TCBxKwtEGjzYupvupfGf4tM4AMu1X3vdDk1QdOm/8Wmtus2p/CuqxcoJEqAGpnfGXpYjo2zS4WqPh+PTUaFc93U7bnrr1LBg1GpdUL9nkdv8nxt7M+5VZra3eFBft3Jasxp77c+qkt8B/7yIu+L0mjgDfn4jQBDy5hr7Ikho2KRHRAV4CWQr6t8EAlhvAa7Am2ZVMZktJf8ROBwgiUuR3AMHq6uJmoUBgf/vdATCrSgIdPzvXrTHI/CbhmU+laku7F0792UziRulkjCFXdQQsI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sure, will do.

Thanks,
Wen Jiang

On Wed, 20 May 2026 at 17:44, Uladzislau Rezki <urezki@gmail.com> wrote:
>
> On Thu, May 14, 2026 at 05:41:08PM +0800, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > Users typically allocate memory in descending orders, e.g.
> > 8 =E2=86=92 4 =E2=86=92 0. Once an order-0 page is encountered, subsequ=
ent
> > pages are likely to also be order-0, so we stop scanning
> > for compound pages at that point.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  mm/vmalloc.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index b3389c8f1..60579bfbf 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3576,6 +3576,12 @@ static int __vmap_huge(unsigned long addr, unsig=
ned long end,
> >                       map_addr =3D addr;
> >                       idx =3D i;
> >               }
> > +             /*
> > +              * Once small pages are encountered, the remaining pages
> > +              * are likely small as well
> > +              */
> > +             if (shift =3D=3D PAGE_SHIFT)
> > +                     break;
> >
> >               addr +=3D 1UL << shift;
> >               i +=3D 1U << (shift - PAGE_SHIFT);
> > --
> > 2.34.1
> >
> Can we squash this patch with
> "mm/vmalloc: map contiguous pages in batches for vmap() if possible"?
>
> --
> Uladzislau Rezki

