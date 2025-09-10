Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBDACCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38BD78E0017; Wed, 10 Sep 2025 09:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B208E0012; Wed, 10 Sep 2025 09:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277D88E0017; Wed, 10 Sep 2025 09:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1709A8E0012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:46:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B95881408CC
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:46:39 +0000 (UTC)
X-FDA: 83873465718.26.F9DB1CC
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf28.hostedemail.com (Postfix) with ESMTP id DC0BBC0013
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:46:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b="triYI/5n";
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757511997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Af9b+zWkct/GsJsGHqMcZiJ29hiwuRshIos/tH0QIzs=;
	b=Q9oIQNdX4IgX11wW9SGFpE6KkdF+5fWWWZqZCDZ7uIE2QXZ0qtj2K+FcEnChQtXLnsFdk3
	m3M4rKVXvssIixYlYlI4Anx518t3NY+l/De8Clulp9nFAcuHeShcFlYTMmjBRN4ZJ6snIW
	gebO1Y8waFbIDmPm34AztZmiJoCHe6k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b="triYI/5n";
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757511997; a=rsa-sha256;
	cv=none;
	b=UxutR48e32rBUAUrAkEla1hRfchbkDwWEbh6iAhk+C1rmpYucqS3AURDMDjda2F5vwb3tp
	eFN77P0fWp3ZwxvUjyl8NAPidPEYVIFf8t7YB6uYGtLAOYegcBNsACtG7T/cjQJxZjXHjb
	3y0Hz57azpX+u6RzQNSBV7aqanR3F1k=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e872c3a0d5so610733485a.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757511997; x=1758116797; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Af9b+zWkct/GsJsGHqMcZiJ29hiwuRshIos/tH0QIzs=;
        b=triYI/5nFBpvZin5OSjX7rz/7tsSDkgskMhTDyWeSldyiL3yHp8D8LnTjeobUoJpHq
         H4BkiRIM6nl8xYg3C1TALDuhttqSkJsmxG3R+/bUqiYCVKimN7OZEt9ElkxfydQ99DcJ
         yOQ93IP1FgW3bg8KBimiO3B3rWte/gs60KeGYe+Z2/QrARh95r8xZ6CQiV4QJEu3sIEN
         hzjvPlear0gSx6ghOkD1tqRSolZx1ryRnvrieXrapeFiKymwIItnk4YacGXMTudvS/3l
         gbBFSESQaYLiPvmTzHk4zXq6O+E6OEQ9ZMIprwGmsWFEPZBBC2tkXsA5FuUroHbQRQK4
         CUJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757511997; x=1758116797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Af9b+zWkct/GsJsGHqMcZiJ29hiwuRshIos/tH0QIzs=;
        b=d2W7gSgouVThcSygW0AIxxfMVFyt+A1PEmL1a0dguxUXaJq9HFHYb+rgOeqqNe/k3D
         aI/gpy6ckg8xEIIx6NwpfMMZQ3gqYhVLJ0GIc/266hYn1Eu6mAit6TogNPHOytidPXYP
         /t91RDNqDCA1OzTCyWJL76ZqOJUkIZJyWOKtEH6oImANtcDnmgcWvWArGjlN2+tIwt6L
         rkuIjiKePnG5MU5dwE4GEw7IGZH/3b0g63iEsZMLlueElXeEJjJx4EE8uozhiaUgOKFj
         PQxxwLocKG/6eoJABU7BzMlMBLGxeJCOrmLWxwIHW/vdAMdGlkB5KSZG8O3zC+koXn4s
         hotw==
X-Forwarded-Encrypted: i=1; AJvYcCXewaMMI2a3XCgfyhKrwuuPQb1+UJ0fv+i2QN2uD4YonBcmwswoLBdNJz0lrCPoygfIeCq/3nZPrQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0kuvTF0e4ifmqItfcxUH5jvRwN/3suuP7qxp1c5lSrnfKMBed
	6Q2u5OHJrKT36/YvPstUj2X1LZVKmwyjHPQ9XdL35L2fJ+cms0FwVTNpI40cNulFs/s=
X-Gm-Gg: ASbGncvz9GoDNAMFcOb/HTWAumh+4s4sSGP9m8+A4mVCBYAg+XL25sqUkq7CsZpV8Pd
	0C/dXHMshqIjpSvxVQ4yJj12yITnduXg74WQA0kdpfXsLUjTSu38u252GVULQiIXv9BLgZsLev8
	mO1hgN1jEI23ADx3mvr44ijQ7+4ZwQrsJ6Lz9P8zM+UxVSm/C3cfUrXvZNwvCddWVJ40deGokQ1
	iezdhFKN3hvnX2SCcsQof+glaWOlNR1u+a46Kfix2iZIE0EwrYYB62KOGvmUxlnt2rHvIqxmnIi
	sPPhx2iyP0udH92xkcIgzh1HjPJ206/01Q4hVZ6hU7pg8yfe7AsjBtCfwlIViD/4BXQ3VvmBgad
	IRjPYdEpKl2L+99wiRxs5GHQ=
X-Google-Smtp-Source: AGHT+IFH+xY6zcLHZp1R7dQuxNyCBZBMpa63uJHwAlgVMDzPHOhi+hDTCg2JXA9cZiRHOYknWC0uzg==
X-Received: by 2002:a0c:f096:0:20b0:743:5b18:caa with SMTP id 6a1803df08f44-7435b180f23mr114883876d6.56.1757511996502;
        Wed, 10 Sep 2025 06:46:36 -0700 (PDT)
Received: from localhost ([2620:10d:c091:600::cb89])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-728a860bdebsm121998106d6.69.2025.09.10.06.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 06:46:35 -0700 (PDT)
Date: Wed, 10 Sep 2025 09:46:35 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: remove unused zpool layer
Message-ID: <20250910134635.GB1111@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-3-hannes@cmpxchg.org>
 <rcxmemdxbxuvtag2qv4sjxoh7ho4z3bz3od6i76rc5yholx2rc@vncn6iuuee7b>
 <20250909151639.GF1474@cmpxchg.org>
 <pmpmejmw4swnconhf3u5uzzhwtki2fdnwvt73vf7lzkigrhwmb@sarxlksng7nb>
 <3dmy2gxowbmq5wmpjtsb26d25k5fjev2geykik3du2ltmhrj7z@nfkwjjhndet5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dmy2gxowbmq5wmpjtsb26d25k5fjev2geykik3du2ltmhrj7z@nfkwjjhndet5>
X-Rspamd-Queue-Id: DC0BBC0013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9wnkgth1yor3ixr4dcmkwp7zi5sxafjr
X-HE-Tag: 1757511997-119758
X-HE-Meta: U2FsdGVkX1/tJh86bmnAGwsYCStZzaKR+x3qcbjV6sm0yMsqRn81vd5gYCirhSKGQkZxe2UZyR/Lyqe4IkUbsEz/SVVfizWjqiXkWeLucLP2KI+Pwu+Ze9TqFr2jMyWz6auG+8u5TbODsS8ChjkyiWQKHfFffmF3+or4J98BmHCfooWP8+2/hQAaOwnzBW9lktzy0UAaGygfBh64ZPqVlfWFfl3agB3uGJp+3L4KPetAGG/P+IGxKEotQ7gyzcjmT7VJkFM5+FTtBcbpQ7WVsOcqOaZnMNikRtEwNv1EAN11ePEDjJDRDjB0ziZ37GzsdLjDNNGTmsakfacGscPBREt5FVn4hDVhc1hG+L+RQFV7fSHYrsI1ZMKTrBcQ628I53PIZesYc7pFdpN/hrqq6VR/O9tGuA7DekyNRlCvrtLuFhGO815vMdik6uh0M4Kjp7DCtQnLCosqFd4i41JOfCc0CMJ73Rn68wKqNOyL9L8H4dBCBtOxc9/q0O0MlXg3ICIfiDhNo1HFTGIAhv/QLr8yKwH7giTXqqeps7//Nbdwus3BqwuUAQPafn7mAloqMR/X9VFviaBcdOGWGDAXl33/lb8b4fgYcPLU/2Gf1iM2ZQMlqnq3B6USQ8XZZ7sB74Bqxz6X6QENe6wZTdV9l4jeMRjZWZr4vVN5f+iXsKnJpSvVdWzRM7Rvk9ZjDHBxmdgJz6Ef2KfXZYxIzeptJknOjusLxmg/E3+DvtDFvsRZlIRC2dELTa2IEtefd1ATeMEuwv8CqIAIR3ZCXXPdSxvehuL9b249rE1snKnsrEUO/Rf7yvNCnN4DowoqRnjOjQFAYfuMsVFnSfTUnSxX8qgj2vqoe3B4CAGlYrzQaFNu3H4tOm1vN/5fxxjMkvw6aIX5BJoFtTxPYIULJ+Vq0QwfjKesq+2RM3+3g6bfAeu3IF+iip9hkFtkv1zc2FhLD0a8MG81mwtj+xchLFO
 W+4rGpxG
 Ic46XwNMNUr1Bf15IZ/gJ4Y6f6LtvK2/ErNXTqkT7iJpLr0XyeQwHGRLIeK5Dx/ojdQTmXFfQRMlz56ly2q9qGkldRs8kpr9Gi5dRxYU46F6VT5SP8KBaJCRnuFyU1QTHrrNEQe+vy+E8mCuEYHODOhgyGTKoYdrc7fv4IK+Ngopt5ESdPKe5gmsckT9zspqUiJPIxQ2hte9X4KhQP1q1qPlGsSYe39xu900zNiDsybFg/zdb5aQffYcs+B9T36/9U+XeTgSJoOZ/BT3JVdxAnv5OEiZVT14SNzS0soEsOuDLnH5sJaamArnAC+k5Eb4YCeXbCQAzKl/PL+aOqobu0+2AGhNhg/H9nSLtQes6NorUueLdK64tuw3Ch/FFxY5BJhQvrAAyRxzcR971su3GQDFheDK3HXobS9IQuS8C71JLEtT7819yfS9SPZdK0U7f9CxrGEmE5xaG5DQtttaSY4xdCxzGynG6WWLC0QKDnT6CXweaXjXFLFqjbfpIjy2L6Q9vQFigmEZj8e0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 08:09:22PM +0000, Yosry Ahmed wrote:
> On Tue, Sep 09, 2025 at 08:08:12PM +0000, Yosry Ahmed wrote:
> > On Tue, Sep 09, 2025 at 04:16:39PM +0100, Johannes Weiner wrote:
> > > On Fri, Sep 05, 2025 at 06:58:47PM +0000, Yosry Ahmed wrote:
> > > > On Fri, Aug 29, 2025 at 05:15:27PM +0100, Johannes Weiner wrote:
> > > > > With zswap using zsmalloc directly, there are no more in-tree users of
> > > > > this code. Remove it.
> > > > > 
> > > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > > > ---
> > > > [..]
> > > > > @@ -125,45 +122,18 @@ config ZSWAP_COMPRESSOR_DEFAULT
> > > > >         default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
> > > > >         default ""
> > > > >  
> > > > > -choice
> > > > > -	prompt "Default allocator"
> > > > > -	depends on ZSWAP
> > > > > -	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
> > > > > -	help
> > > > > -	  Selects the default allocator for the compressed cache for
> > > > > -	  swap pages.
> > > > > -	  The default is 'zbud' for compatibility, however please do
> > > > > -	  read the description of each of the allocators below before
> > > > > -	  making a right choice.
> > > > > -
> > > > > -	  The selection made here can be overridden by using the kernel
> > > > > -	  command line 'zswap.zpool=' option.
> > > > > +config ZSMALLOC
> > > > > +	tristate
> > > > >  
> > > > > -config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
> > > > > -	bool "zsmalloc"
> > > > > -	select ZSMALLOC
> > > > > -	help
> > > > > -	  Use the zsmalloc allocator as the default allocator.
> > > > > -endchoice
> > > > > +if ZSMALLOC
> > > > >  
> > > > > -config ZSWAP_ZPOOL_DEFAULT
> > > > > -       string
> > > > > -       depends on ZSWAP
> > > > > -       default "zsmalloc" if ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
> > > > > -       default ""
> > > > > +menu "Zsmalloc allocator options"
> > > > > +	depends on ZSMALLOC
> > > > >  
> > > > > -config ZSMALLOC
> > > > > -	tristate
> > > > > -	prompt "N:1 compression allocator (zsmalloc)" if (ZSWAP || ZRAM)
> > > > > -	depends on MMU
> > > > > -	help
> > > > > -	  zsmalloc is a slab-based memory allocator designed to store
> > > > > -	  pages of various compression levels efficiently. It achieves
> > > > > -	  the highest storage density with the least amount of fragmentation.
> > > > 
> > > > Why remove the prompt and help text here?
> > > 
> > > We shouldn't ask users unnecessary questions. Zswap and zram are the
> > > user-visible kernel options; if one of them is selected, they should
> > > just quietly pull in the zsmalloc code.
> > 
> > That's fair, although ideally we should call it out in the commit log :P
> 
> With the commit log amended:
> 
> Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev> 

Thanks!

Andrew, could you add this to the changelog?

---

With zpool gone, zsmalloc is now always a simple dependency and no
longer something the user needs to configure. Hide CONFIG_ZSMALLOC
from the user and have zswap and zram pull it in as needed.

---

