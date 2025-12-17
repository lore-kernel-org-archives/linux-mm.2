Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A43AD66B85
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 19:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0446B00B4; Wed, 17 Dec 2025 14:59:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E1D6B00B5; Wed, 17 Dec 2025 14:59:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89996B00B6; Wed, 17 Dec 2025 14:59:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1CBE6B00B4
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:59:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F41760CED
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:59:25 +0000 (UTC)
X-FDA: 84230027490.16.2A0C812
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com [209.85.219.65])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3A62140006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:59:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Y65/ouoo";
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.65 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766001563; a=rsa-sha256;
	cv=none;
	b=AxDuCfCVQ00BHmhz/8lriNHpDu3OHPORTcOadbX6pO5eeWoCKl1qbx3816aZjBOUyxVnC2
	Un9tKxZl36Pqpq1OKX8r08Evx4H5L5TvLdQuaGWNljFD3oDG2/4VNz4dAGgd5vjyKxd5Oa
	M44l92RJ1iYBb/npX1qqYk+UA5Kb/jI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Y65/ouoo";
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.65 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766001563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umJwQRcOcv6tN8KQ+xKY+ct7qymfOOSndzlF6qrQs+M=;
	b=SBPoVDgdCerve6u9n3B7z+mQexJyRCWMLypQ9YvmNFsQsfC9URrEQPosfcyrjGee6uBspE
	5FawtXVir0RHE67xl99+EIIEFDSNjidbkRXrkx9wq+z2e/3m3wxgIFms1tNU4xyZMK/L4C
	GF8vzXGAgIu12sbX5jt/Ua4mhHI4ydM=
Received: by mail-qv1-f65.google.com with SMTP id 6a1803df08f44-88888d80590so39042756d6.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766001562; x=1766606362; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=umJwQRcOcv6tN8KQ+xKY+ct7qymfOOSndzlF6qrQs+M=;
        b=Y65/ouoogAmCiR90hhe+dVLkYdG2UvnqGqJhCXHVyFrhlmQPWah6L+W26VSnQCmTPM
         lzRZFJ4LD8Tm8s4gRs/fhIblEfq+T9G/5bZYNxaHLOo6OCe995+uphAjMbO2bQNJxMtu
         H98dPHH3djxth9/gceykOdX//CUamBq1eW1jJTIuOBmrSLZS0gSoo1TsGY8Q6JT2F62f
         LAWjQPnoqaf5voKDg7uOHlXrvwgk3AySK0Gjhhsc7z5bJlZ9WAkkAZtJUK0SXirTZJtq
         WyLCF6xXnKDAfyLFocjYZOBiweWSdJQzL+ppeC4z8wlV+fYvVSiEkTiUa5M3jsLp/shc
         weyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766001562; x=1766606362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=umJwQRcOcv6tN8KQ+xKY+ct7qymfOOSndzlF6qrQs+M=;
        b=KLelfrzYVedPcMp8oJdMi6N90d0/mQ69UefCz4JB5Nt1Utp781nU4iFsgqkgOWxLWH
         aiF+Gpmqz8fI1qjuVds9OMCnHPZjZhJ7XBDOAeUuU82rXncq/mPAT4J77QC+NSkAx/m0
         BB+qeK6mRxaDLXDpGkgpnNE1v/D+vQ8mv24qu0KP3esXgHGF+d97kc/f8u0Y65b38203
         UFthu5Pvz5eVZ9CgG68GO2eaCt+wunw5JNrdiL+UCv2AchBwrNglRw8r5kwX+7omrxXp
         QXi/EalduSMe5CG9f0XZJmfkdtNFsng6pLuIiCHvgdQw5C7b0eUYtkLjcdjm7XdVWaT3
         h0kQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUhRFKitWaliVXSjws/Cd9D7ZD6JGlxxT8fOZ6P5m3wxsmu+QNcPU/Phn5N1SSmRhnAUEIvYu/2Q==@kvack.org
X-Gm-Message-State: AOJu0YzG6ZZGEyI1o6bPD3WuEN0QDbi0b/u/0CWuXHtI91230lF+C6Lf
	6Zd/UDbAgZso2UuKlHOMuClaZNhcwSjsgRy8uUywVN9yMcQopTjKheGqafyH3sHrcvQ=
X-Gm-Gg: AY/fxX5pPcYq1md1psP0ExaqW2LDx8fd4hBV3sOubyQh9mtf7kAoZfN+/vV6KWvMwBb
	NC7VcvexTMpXaVgidPTDGPHFj1uQlniY46Rx8R0TCgNbXvxiHjnaU2Y3fnEUhY715VRTL8SkVb2
	7HCG5eG7BxyCosPKhi1YipGeN243GnonfrocvqaNxK0vRd5rmXtJ4RSwfaNY1uhiwkjeR8269o2
	ipIZbnJjEEJhyM/lzfOa0CB08g1i+GusrRPfoqkJs3iLLUfuhVAYvo6GxekOh3BJZYXno0KJV5Q
	FKViUdHOQWy5jSeFuzTdfUxR2pEJslgqgANYsK3lOf+hdn63E1zt1+zonZr6k13LaAh+HXeFBlA
	gFtaL7xD7uU7FM7lWt5QWRydkgxcKtuaUTbm7B6wuJL7CuYiSxoB/a7P6eKUIhPuP/9JJWca+Yy
	DDqbAiTS+GQdrVcL3P7j5V
X-Google-Smtp-Source: AGHT+IGkgd14mqGKPn7evzONaa5NlqMwbBZNXipPmIuU2TNCHRjQ90/wuY54LLEAOA2jYshzbetrvA==
X-Received: by 2002:a05:6214:5b8a:b0:87c:1ec5:8428 with SMTP id 6a1803df08f44-8887e127b6fmr309717816d6.46.1766001562229;
        Wed, 17 Dec 2025 11:59:22 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c61674467sm2152596d6.55.2025.12.17.11.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 11:59:21 -0800 (PST)
Date: Wed, 17 Dec 2025 14:59:20 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: retiring laptop_mode? was Re: [PATCH] mm: vmscan: always allow
 writeback during memcg reclaim
Message-ID: <aUMLmJ0En24pQBX_@cmpxchg.org>
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org>
 <aT-xv1BNYabnZB_n@infradead.org>
 <20251215200838.GC905277@cmpxchg.org>
 <aUENEydFvVvxZK8r@infradead.org>
 <20251216185201.GH905277@cmpxchg.org>
 <gweo3wdh3agfavhiky5cloweu4m2hvgzk2j2euckbka5x7n47e@ezjmx7eq7ks5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gweo3wdh3agfavhiky5cloweu4m2hvgzk2j2euckbka5x7n47e@ezjmx7eq7ks5>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A62140006
X-Rspamd-Server: rspam04
X-Stat-Signature: z6pdfpuzybwzkstcqtdbs1e7bkk37efq
X-HE-Tag: 1766001563-443460
X-HE-Meta: U2FsdGVkX1+DG0KE++SoErbL6gH69KytvLJnLo48PkBEm2P4ex2Ig/f/KyJorePH5W0CeqcDU1Mo15ZeaMRgpvUKILrLafZgwju/5EdxRJDh/C3llu7L6HKCg0QqjoDTd5iHPN0FqEfZrySdR4G5ydXqUhM8ulYvKNx8hT0rypQScYrRZzGO/dhaLUqRx20J8X2drMjB9mIKzGTCP4yfaO1w86bFPchuH3eAiqVIJAafyFnLjQaGKWSHfEYv1K+BL0H6siCJf689HM5VA+WJGMhv0RiZ21hQJQXZgM8/eDosDs/P97Jk/ueWT67O2XQppaHz/emoZDdfY9XE/jJfIi6MWNH+gJ2qOL2AEoHLjwvreqitjplHkwgPz+IWIX41Defa+CzXLvwmSXFqwxrElumEznb7LG9pvZ0ELXOWKSbIb/bkT5Q/WAGPpUL+EJ3CyUowyl7oaNZX94qeI4xCSFkl9etRlOu89ggACfZ2i0ETTcF795sVFY9XbvEB1TJktl53rRzk45asGCs/Scxacr0+7itzT6d185wlaa9KNOqLry3ZcdFDm7/lxKkBjNQb797c3LsjNdw15YPNBKz7iHDGmompZROXbdayh1fDHsyyzcTA/CW5sa4JU4YeLq7OOu9jrj/k++kHd7o+gmsHhFkl857P5DUH1yj4DlHWZsuZR7c46SkZVmr2JKdp69kifseqPmXI0Tm9OlhY66l715b8waFRCOOkzF+b2a46j57QA42eZYwMHXYOY1oSiIZy8Rj+6oSH6ACwztBuPWP9JYrlr5GopX2/IiLPJkrcfNFr8GdL+tl/GB8DDs6G1TduFXhT/Se83TC/EFXPpMEZ+3mZrJAXNMCFrqIFcKgdrEn5IyjQDQOHvZx5B15mT4GMgtSaZwF2q02E7+KHKD8ybu1HoNtd/p40aTO5HH9n2av7nN3rn4QEUIJNJPSwcK0bVGHriUAw6Xr2l5fLkaO
 k0anQSW/
 tBuEj9CcXWwvOTUs2agoYhWi7RDHeHHB32hrelgZisgyrBy9HGh9ytqLGtdVIcd7MzlqOJcGbpgfBBbJRURWyqr7tQjqT5KVt78/hRoPgA8QeRVC7cbVc3s+2D0x3U1BEMVKTb7MFDAsk4j8PZxWny+kSjEb6VOmQtAkOzZy7hbV8Qpjog1KZfXHsrLSzmFye429M9tL4LiCxsS7FTdDvP2Rt/JnX0Diw3Ns7S6xR6Rn+0MkAq1DL1wNt4HLCxOZh2Kel+kzwnaLtBEgn7M5zxJan0DPKXxiqUUrgLWBRiNeWq3dPPrBdjQv2jVb5xcF/7R4aBLzyr01dIhL1rs+ElQvTkzLcwXv8DqA8Q6OV3HUZ5N+ClY1qWMtgqo/REfO3bBjIuah6zoiAXshvyjrStLCNeUxI7+yBfJFdr3eoVgP2KpMa/OXfcGuQnBXVdSmmxgIzYmOPv7ei4P4zBtKI+2x3WZojp6RxqXju/gI6iCyrEm446STQGeEmmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 03:23:53PM -0800, Shakeel Butt wrote:
> On Tue, Dec 16, 2025 at 01:52:01PM -0500, Johannes Weiner wrote:

> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!

> > --- a/include/uapi/linux/sysctl.h
> > +++ b/include/uapi/linux/sysctl.h
> > @@ -183,7 +183,7 @@ enum
> >  	VM_LOWMEM_RESERVE_RATIO=20,/* reservation ratio for lower memory zones */
> >  	VM_MIN_FREE_KBYTES=21,	/* Minimum free kilobytes to maintain */
> >  	VM_MAX_MAP_COUNT=22,	/* int: Maximum number of mmaps/address-space */
> > -	VM_LAPTOP_MODE=23,	/* vm laptop mode */
> > +
> 
> There are 8 earlier enums here with names like VM_UNUSED* along with
> the information on what were they. Should we have something similar for
> this one? Something like:
> 
> 	VM_UNUSED10=23, /* was vm laptop mode */

The other enums in that file leave holes, the VM ones have a mix of
VM_UNUSED and holes. I don't think it matters either way since the
sysctl syscall has been removed and nothing new should be compiled
against the definitions in this file, right?

