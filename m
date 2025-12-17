Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90AF4D6552C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E974C6B0005; Wed, 17 Dec 2025 07:02:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E657C6B0089; Wed, 17 Dec 2025 07:02:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D711D6B008A; Wed, 17 Dec 2025 07:02:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C40936B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:02:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5494A140A5E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:02:36 +0000 (UTC)
X-FDA: 84228825912.14.DFF696C
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 548A91C0013
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:02:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XKnAwzNO;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765972954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJt3OeOAET42H1SZeq/73bRk3HyaCcKWTnzPipXTmdU=;
	b=qdLAEIa+O9h4wjG4Io9aX3FMTi2LF9Eih7cNLheZfiFYcZVqQGhoI44s6a+nLyLYCSe4vX
	G1OHlZCujOIfbaEQO5Xc9kprlv8Fj6Ih3G+xGVQ6KptkfHXAQ+fcSMauqnKpXrPN+nOHsq
	fHBN+x+UptLW3w4c4WfQpfAgt2PKoVI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XKnAwzNO;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765972954; a=rsa-sha256;
	cv=none;
	b=u27ovuwSEX91ocb8IhINvWHa/fllni6g33BkbNTpu85euWRyAzC0EL+7AEoLYAKKEx+/N4
	/kRdXy9YgAvoggrGXhrDELs6dYYJ8bbM+g+cu9WAqvOv0ulVz3CtpWN7yL5JTu8Zh8EaFY
	YBi98YbGxfsZ7uFlY7IJK73nfW1tihU=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-596ba05aaecso6441257e87.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765972952; x=1766577752; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OJt3OeOAET42H1SZeq/73bRk3HyaCcKWTnzPipXTmdU=;
        b=XKnAwzNOO+LyOmZjLONdUcy5CLaOFIS/OH3gRRDUeyeUnP8fi6x5fOloc4v7AoCz7P
         Y7Z6S1uywclaXaMkArCrE3wAkP1SVIsl52x8kLM2I4LN5YinxwkESlH3QIiqf+nhudHH
         qs7j8CyMY34Yz6yHS9KjKi3hUik014a0yf8+6aL6vfaJARN4vhHDigCh1eJmtRJkA4Zz
         bL5TASI0dKJo3O/dC9Lh5hOsfTBeJUGxTTk6A17f4mcKIz2fwbXDp5Snpi5DrkCjEYhz
         FRYZsBtLeOJXoOYyXtN7Ltz1tlkA3uc154kMohffAeUA30ek9M32RhFFHm6suld1vInM
         O2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765972952; x=1766577752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OJt3OeOAET42H1SZeq/73bRk3HyaCcKWTnzPipXTmdU=;
        b=QRUluVvc8QFnpd8e7cfulGt2CP/L9OPPL16MPkw/oMqVd2kxcKJG+HnH2EGP4CYpaR
         OGK5IRzHQHZXQH3awwKApUDJ5P0mcqTuYN2joqZd/jIFKcRQUV1ney1jIdW7UEQc06iV
         B5s1dXr8xbE4tifujn+5miM2n+4JT8RUAo8hzZqNZfjcLpd+ZZY00ZqvH4PSAU/tfI1o
         LbA6mzwkpm60cyFZc7voBVRJyMKu8E0pkR/8pA+OLfmP9QiNgDOsvd94WQUiRbSWGb7/
         nbRkNCaErBbUNR3guH9uNkcqVuv2boQe5hnDtYdStGnOAZyfWP+ZHRMXWog4I4LhBZvW
         SRXg==
X-Forwarded-Encrypted: i=1; AJvYcCX4VAOBF4xvOEMEMmId6mKXnNJOZg5A6moY38zrSeKDw6E6vpM3NhcdHdmxoooGjIRzTlaEaLAIKQ==@kvack.org
X-Gm-Message-State: AOJu0YzrSmygouUPQL5ZaNCDSc1A0fZIm05mLNglifP8Dn2Ucza6s+DO
	YkMi7VQrJszjadtnWrxdWrRhwNHS/hnPp1k1IuzzzDWi8gcvY8qs8hvlZJ18ffUv
X-Gm-Gg: AY/fxX5Vlq7SYavuiemEEqlxutmpyQHQbgfk7XbihdClCLMYTDbdeRxcOH9wgdctbew
	w+NNgVGclTvWvRW6Lpaiux+ancATp7uGOgZzKM/q0fGqLH9EMEohK/mckk+ARrgK3y74kMsvW+h
	KxsHlogkAdTQS6f7CzGd0HByHK8GDhzpU3VurXkcdRPOWsJBS3SjQXnvC6ECEdjoO/x+ENSK6QK
	lDHvT6x3g0g23Thr3txuuy9S8lXBkGpcTOVhvoGu4NOAl02Ur+LKkMAinwXjfIyRU3q2Vr7+UiA
	n/LHsBSQO+nh46VDrI10Nn0nE5/AE6rkKwtYMSlsu+i/WP9/Et7h8/d5zpGqq8OS9WjcpGnPDMJ
	N/ApdyAlwPSEb6imDI4Af7FATB1Hf7z4GpYOJjy855226fIaNDqzzNZZ/Ijw1U9s=
X-Google-Smtp-Source: AGHT+IEvC8B8oWcr0SIWQAYhh3wI3svFk5jPcenoh+vUpS22lTjVeH41fkW0PDI4QJj3OoDOzFAiww==
X-Received: by 2002:a05:6512:3f2a:b0:595:8311:dc80 with SMTP id 2adb3069b0e04-598faa27bd9mr5964892e87.20.1765972952322;
        Wed, 17 Dec 2025 04:02:32 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5990da5dcdcsm2312647e87.73.2025.12.17.04.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 04:02:31 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 17 Dec 2025 13:02:29 +0100
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vishal Moola <vishal.moola@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Message-ID: <aUKb1bL7CUcCWi8V@milan>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 548A91C0013
X-Stat-Signature: 94jjkz5oif83ikgnwdtdzqfypak85bc9
X-Rspam-User: 
X-HE-Tag: 1765972954-773640
X-HE-Meta: U2FsdGVkX1+e209PJLLuMxsEIbZb/cqk8NbkxPsP1r7bBdAyy2emoTRDz5WFrF4i40LN5gmjx6QHK7CfZf4WYleBbex2AohUrLSHiCqyt/QNaNk89I52iCAerBC3UWax76UtwpcmRkSS8+d7833URaLrjumRYeEdInRKThZHPzdpkvLOw2ph4Ot9IvJXTk1qRDcVaO0CeXTe2pFMRBFpAPw/VmuYmp+4R3dit86fxYzd5AVhZNZc/Ud4Vrk9zCjlu/h2uV+M2RAYKN/Ze7h+T3s779j2nc2+Qul/Znyxm1Ldy6dJ8jbe509GSR5XDaTglNDp3bN+Irn9LBZRYd3ACF6jNCNXV9C2VL9W8kzckuID8Mw225QWOyOvU2ZT4oRNaGn7Uh+PwUbeFWK5wUKLyhH8e+0DYgJL+GYfhRkisPSh1N5pVLPVpP7eCnhmJqD2j7OAWRjf6t17hne3yk0N5D9J+1KhG57nGt09ELYOqGbtdm5ieQv9mOo7vpKuUMqCvjEio+0K2smGFq1xnvsbv8uswAxdNJtmWma539F187X9IOt1BQCEFjP48eBZylb+eMaBxYzVtnJ9B+cmm5B9JtQLcipT+rlBztxtNxGWpEx2ZuudGfGZ3T6H+hLOYUuQfbjqL3fvu4gzXlKSRoZeOpinZlbMFa6zzey1hs+XMZV0ReugCh+dLf8jPUgNBSb4h2ACJ726OsvudnmSb/20XaKzpzDX9gf2HvAYYxkjDCWDEo/DcPKS1yFMHrj3KlMBbudmzz+ib0YhIa3E0NuI9I3Y6Q3bO8Vn95PzVA+wYjm5Tz7FINvWO8TtIFEWYv+oCcZuOUQw9Vszi8Ga556JwQKBnnlZdj0MaJ24StHaS7qGhyCeTp3bIrp6RoCKOQ5/ysjPHIcyucM6bn7TrN44nRK92OBtm9h8njxYKMhPhXiK/avtgEVVjBXxQ9JNFp0Fk6uZ+cukXam4Msam+Ul
 LMEn0FyC
 67ucxoKooP7C0pEJG1qb3Wl1DG3IQi6sWmnwUePqQuYvu+qD0auGtz6b3nqq7GR9XkxU32gLIMRh0JOWUJXYeNxSxZf0drMS/kuCCBGSmDrSTDQTCHVEdP4WOb4SD0lgBYkRKay7IhTvCgrvnw2PCubpd3XNhyC5uA/0lr1FrM5Ffkvv4qfwjDoJiKdvYZchoRP2DSypM6hrOI2j2RmCbpW7zKoxV3qEL4W29kux0nMiARjJKijWgzhiwVbv5LiWTY8UZC82/qiDUgVF4VGqk93K5hMFgKYJXRscuGto6B+l7i9mZ2fAvqb99wWMABHBMDNkw2wFnASey1LzlCIYVmU0qor6GiOqOEwDvX4U1AEnzbXvTu/GdVo9PgFikkhjR4sDeEOcyQ52F5ITUkbYqMOKYtSZdAGTvuUG9ojgP7keoISZsgItGIobypFWpnlM30P77fvuk1jEUZQCNfgLNki68yAbkscPYP8YEiRknlt9lVTghdaBRce3gM2ypqbiRltaOkh/F1KX5wCi05EBsliCP/c8/XPkJIhxYLU5QGbY/avBHUJ6+6cfPCU6BEdihQ6Sm+5Yv2Skf+f1si0erR79xnMkfBXWtZaX13WP2KEDyLxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 16/12/2025 21:19, Uladzislau Rezki (Sony) wrote:
> > Introduce a module parameter to enable or disable the large-order
> > allocation path in vmalloc. High-order allocations are disabled by
> > default so far, but users may explicitly enable them at runtime if
> > desired.
> > 
> > High-order pages allocated for vmalloc are immediately split into
> > order-0 pages and later freed as order-0, which means they do not
> > feed the per-CPU page caches. As a result, high-order attempts tend
> > to bypass the PCP fastpath and fall back to the buddy allocator that
> > can affect performance.
> > 
> > However, when the PCP caches are empty, high-order allocations may
> > show better performance characteristics especially for larger
> > allocation requests.
> 
> I wonder if a better solution would be "allocate order-0 if available in pcp,
> else try large order, else fallback to order-0" Could that provide the best of
> all worlds without needing a configuration knob?
> 
I am not sure, to me it looks like a bit odd. Ideally it would be
good just free it as high-order page and not order-0 peaces.

> > 
> > Since the best strategy is workload-dependent, this patch adds a
> > parameter letting users to choose whether vmalloc should try
> > high-order allocations or stay strictly on the order-0 fastpath.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > ---
> >  mm/vmalloc.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index d3a4725e15ca..f66543896b16 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -43,6 +43,7 @@
> >  #include <asm/tlbflush.h>
> >  #include <asm/shmparam.h>
> >  #include <linux/page_owner.h>
> > +#include <linux/moduleparam.h>
> >  
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/vmalloc.h>
> > @@ -3671,6 +3672,9 @@ vm_area_alloc_pages_large_order(gfp_t gfp, int nid, unsigned int order,
> >  	return nr_allocated;
> >  }
> >  
> > +static int attempt_larger_order_alloc;
> > +module_param(attempt_larger_order_alloc, int, 0644);
> 
> Would this be better as a bool? Docs say that you can then specify 0/1, y/n or
> Y/N as the value; that's probably more intuitive?
> 
> nit: I'd favour a shorter name. Perhaps large_order_alloc?
> 
Thanks! We can switch to bool and use shorter name for sure.

--
Uladzislau Rezki

