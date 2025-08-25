Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D8A8CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951458E004E; Mon, 25 Aug 2025 12:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901C08E0038; Mon, 25 Aug 2025 12:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9A48E004E; Mon, 25 Aug 2025 12:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 68F5A8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:18:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2256F140455
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:18:53 +0000 (UTC)
X-FDA: 83815788546.23.732E5C4
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3D75118000C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:18:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aEMbJWWF;
	spf=pass (imf16.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756138731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vlupHTCaeWk9ty8cyG5BDMuBJjhBMKn4mUppCZ+fHyk=;
	b=wDgG61h1857XRcOb/c2vaj8wq1zmdD+SUnRANvv/RsvAVQrDa7GRifhl8uTARWNfAbHHG/
	FQPx1T7XvkzyAFm1dIyF7NnqwGVPD2PPhCGImDbMGpbJngLTKr68G9EOK8J6EQgYYFMmQR
	jy0/ZiVL1fwL0tuy6k2dQEmiChYbCLU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aEMbJWWF;
	spf=pass (imf16.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756138731; a=rsa-sha256;
	cv=none;
	b=rgilVu+1weeegZbr0SUE2hhxX1vaieiPlcDXHYIJh0yTs1z0eyhK0cC5TmMrhVU0avP5m7
	J3ARDwJ3WVtjKP6EXIZlQl+mmf9PaQbNu8HGSqgzPo2d9xvSOjAlIhVhmajIw0ear76NC0
	ms4sonWzy/k3YMiKTbcBRBdf8xXYkAQ=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b49cfd967b9so1054180a12.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756138730; x=1756743530; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vlupHTCaeWk9ty8cyG5BDMuBJjhBMKn4mUppCZ+fHyk=;
        b=aEMbJWWFcGTp7uEE3OE/8mi4VRXkMg5sFSlvZASD7WlR7R76snnPBcuC0RpRgXnaD+
         /Xdg+XngfHI7bFEeJoGhJFDJytmNyP3KgTgf2dAJhu3vusxbJC9gLDPMiphpCq7GR7hS
         rY7r8r2y8mXxI8f/k/0fGgSJZ5R+JsNc6mK2ymU0DZqrpx8H+HgCKtwVcpb/5fwlfZkS
         78Y+uDk95Ohjb9XjwPkPt+nFHsKt6PuHCqBaDc0hnCl6BO8SKYmFcxLSsbLFiO+iFBAg
         xJad7oH2KLUPgglsKZYfarQ41VLAjMgxPHXEumjctd2joh4CMxkMtFqSrtWh9/v3oaBx
         0WFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756138730; x=1756743530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vlupHTCaeWk9ty8cyG5BDMuBJjhBMKn4mUppCZ+fHyk=;
        b=qOt+To0p1iVYm+ksg1BsaFykCF9P2B+jxgjpvxSGx+Ll1kmZh+H6AZwMDKaYI8eDpK
         2P/5eSkqn6UlxNaqM/h8fRJ++Kxz+X4YAOwVIboWM4CQm9RZ2fCEvKGo+XDNzHP6UIo4
         QKr7AqlIgJrFBE1osMa0uXZ3yHGBoHO7RJFmgO0b+i9gTJWQnhItd+M0SS9RIaoIN7A7
         uFKnprgBe/caiYPhmEWrcUlQffm+cz55pX2eP3L4BpI3s5U3qHqJhMkpZgpiJHCq55vB
         6wYNJ+ptJy20Egx8Z2EpuZFDb0ZpQuOB4tGXmYIllzQwQ/53VQaBdqiIRJBZASUlMX1x
         Z4gw==
X-Forwarded-Encrypted: i=1; AJvYcCXLZuGUNeUOQAGsY7wIYS2X/kVSJ5qG6QxUqNUcZnU6kuFtc/Au0pVmzmcg0mmUUsC0dftBS9HA7g==@kvack.org
X-Gm-Message-State: AOJu0YylLyE3+wVfp0H3Q6C6o1D8jfKB8ALBfZEn1t/PDiucsAXMCK3H
	Rr7N8zDQhz8wAcDIs9FZIH2W1ymZhyrpDSpNAokN5+TGrWXHfdV1HwGs
X-Gm-Gg: ASbGncvmDyA6KL0lZr3jRGyLtJ87ZHNS+bPx+Pk8lThxYJse34mRb2Ois50qzH/8CSb
	RwNNLJ1/V5lfq0Ev1CxIjc1FPnAPnTmaVbh21h6PryFhN+W6ouM2/gOXYRQ1j+VGFK3PifCaGId
	N7ZI0BUT2/ebQWQz0sv4Xvg8tRJqat7eKO3Ii1VeeDmp3ZajEn2J7Pm7B85wLbdI8iYXV2prsKu
	UkrMFWRkIQZUdDMH0lIg5ICqeEqsalh1jUou8kiVM2yXnmBKULXy++Ces9Tt/djfCQsUSgz2n07
	qHiDzFFSilad3r2DlkE3hVIRF4BTf6BO0xr6PRqGak5cH1YQwjGG9HIlJ2vy0QPn4YkXEmwSMTh
	LcPU3wQT4X2x93LwNOxOAkT+IlLuEbh94KWBSiNV+OjXN1SPxn68uJDTR/aJk
X-Google-Smtp-Source: AGHT+IFb7x0FHZfUPJ1wZ6JfXOrSOGAtixKMgVkVGQtPT4Ho/IegHATmPfyAfPSeEwyj7QoVspRwuQ==
X-Received: by 2002:a17:902:c94d:b0:235:ed02:288b with SMTP id d9443c01a7336-2462ef40318mr156684765ad.30.1756138729750;
        Mon, 25 Aug 2025 09:18:49 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466889f13esm72701465ad.148.2025.08.25.09.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 09:18:49 -0700 (PDT)
Date: Tue, 26 Aug 2025 00:18:42 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
	glittao@gmail.com, jserv@ccns.ncku.edu.tw, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/slub: Fix cmp_loc_by_count() to return 0 when
 counts are equal
Message-ID: <aKyM4jZqy8/G2DGq@visitorckw-System-Product-Name>
References: <20250825013419.240278-2-visitorckw@gmail.com>
 <20250825144838.4081382-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825144838.4081382-1-joshua.hahnjy@gmail.com>
X-Stat-Signature: ientptfwjah1drat51dn1jbi7y7acedd
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D75118000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1756138731-228735
X-HE-Meta: U2FsdGVkX19GrLSIaR1T8cvyrSczuMle3E5Hfg/qOxhI5zqUQhCjffVYOE1zBaLUy+93xdxoZ7odEVm9azNPLhryvhn1XuKXwn+xR5vY6veHHcP3fTKzbMg3bMBJCBmBpzZjAhmN74lVYmN7bFa0+uMEht1dpy5cJe+wFEoRUE76gXEWN1Z6xr/I2910iZnfN7U3O5jV1akxjWgWNSbqPsqtJQ6h0sfvQvQ8x3w+JNk+hRqbBahzneDlRTL1UyW7UoOO48BML4NpcG+275qmPz3zJGehoxXA73b4dw68p7vl6rEGzRtApJ5q1NgcsbuOKI+0q1wVi2bABg0N1mSfS0FQdFDRHchsEto+R24MXTeCj2v8nTCHqIXbXmwNHlbVZrJpjqF8saO8E+UenYsHhcQfJoBiSdQpL4LceLMFpB4OvT5jBKMLbCwFFdUUDIxQhGMrHpCDOiQ0qFb7HsiTTU0MWatnnsKVs2cQ9xUGKamCEHsCohF878b6feZpHW2GAL/8/bJ4YoVZFWHSXUq/N2nrE9usGzXF8IUHxw+20mULKH2uz4F+A9CeVuxRKwb0iy2fqZz4WJiVbCLSoXEf80KOpCHF/fhbmexO1dl5UE6i6OPb8l35Ob/OEdRwokv1OCbcLyUJELxXer/CeOniCqytdEqp1jRVqN2QMUwndKcU5x8228+MCfnJ/lxbGz+UKe1fWzh9DHFAS+JZOsOUEmTZsUdBWl14pNmSTDgofDspDcQeoddtFWCdZVXJfPAhhCSGAqkdNN7TK7rT2ePOEhOWv5MWGQ2zuDLKjPBKhan4MP5uqJ/tPAAH9BheoORjVLXygIP96KaXKc9Tr1Q9D9fGu305mYpl6MtKvkcPIgBmxsMuCiB9bSeZzKQnyjO4se0OyuMBDCRhG4tntQVP0Oki1hjpeVNOOcK16VPEeBIHwkM6kkQdi6s5aZRusDxWFFK1GexkRnI8/vBJgBA
 5Hl3wC0P
 sRUdc4Vm4Z4AW+BwgoCC75ztqpoqxWXzHQ4WKwfsz4jHq4Ilj3qQaXQGpTZ41i3UgxFjyyjYX/UKnHl6lAuzFK2QjhYzznyAHtV1i74xBy7PtjO2A/EqaPiHkybh4xt/ibkAdhKkvAE+LFFIIijV1hAGns/hU8NF7Zl+XSuhuLFg+J9ViGi97Uyvc+t7hufCqyxOhfApgz0eHEA1o3cQln2rme3Lt8RrxWp70v/lhXuipKNYqPGT14egdyegjh+uz3FsvuZxWS4SFlSUpTJEOzsrNbGZUmbtnJWKGC/+8OMYDzIk9F/MGEQcmN1Z6nvVpeuaaoyWewNt08kk3Iv1FLPKeiNYum9nRNlg3r/VFOWL/GEkI05deriMc8iIXCWpLfXT7I5miAxfB2puwUNS8HzUJjwk6MPthhZTgFdJ6/V4iyDFc4jyV2r8t3nvRmjlDfvzi3/pfMck5/NfgRU0rNp3jD+EH91PKCtJWsWvV2nZ+6neKJcygLx3fCTgqef3D2OAMKaOf2q1mOavXhb2hh1cRnqzxTAJdLhV1KUaov1v8QE7dW52U2PPMry9WucgWW916udO8JsFARIo6oN+crXuapQg1UIzWFQqwqPYe+dt4oZhkdrAf7B6AREIir1RIFR+a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

On Mon, Aug 25, 2025 at 07:48:36AM -0700, Joshua Hahn wrote:
> On Mon, 25 Aug 2025 09:34:18 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> 
> > The comparison function cmp_loc_by_count() used for sorting stack trace
> > locations in debugfs currently returns -1 if a->count > b->count and 1
> > otherwise. This breaks the antisymmetry property required by sort(),
> > because when two counts are equal, both cmp(a, b) and cmp(b, a) return
> > 1.
> > 
> > This can lead to undefined or incorrect ordering results. Fix it by
> > explicitly returning 0 when the counts are equal, ensuring that the
> > comparison function follows the expected mathematical properties.
> > 
> > Fixes: 553c0369b3e1 ("mm/slub: sort debugfs output by frequency of stack traces")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > ---
> >  mm/slub.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 30003763d224..c91b3744adbc 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -7718,8 +7718,9 @@ static int cmp_loc_by_count(const void *a, const void *b, const void *data)
> >  
> >  	if (loc1->count > loc2->count)
> >  		return -1;
> > -	else
> > +	if (loc1->count < loc2->count)
> >  		return 1;
> > +	return 0;
> >  }
> 
> Hello Kuan-Wei,
> 
> This is a great catch! I was thinking that in addition to separating out the
> == case, we can also simplify the behavior by just opting to use the
> cmp_int macro, which is defined in the <linux/sort.h> header, which is
> already included in mm/slub.c. For the description, we have:
> 
>  * Return: 1 if the left argument is greater than the right one; 0 if the
>  * arguments are equal; -1 if the left argument is less than the right one.
> 
> So in this case, we can replace the entire code block above with:
> 
> return cmp_int(loc2->count, loc1->count);
> 
> or
> 
> return -1 * cmp_int(loc1->count, loc2->count);
> 
> if you prefer to keep the position of loc1 and loc2. I guess we do lose
> some interpretability of what -1 and 1 would refer to here, but I think
> a comment should be able to take care of that.
> 
> Please let me know what you think. I hope you have a great day!
> Joshua

Thanks for the suggestion!
If we're going with the cmp_int() macro, I personally prefer
return cmp_int(loc2->count, loc1->count);
this avoids the need to explain the extra * (-1), and I think cmp_int()
is simple enough to be easily understood by readers.
That said, both options work fine for me.

Regards,
Kuan-Wei

