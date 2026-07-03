Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A248FC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D936B00D6; Fri,  3 Jul 2026 08:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD006B00D8; Fri,  3 Jul 2026 08:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBFA6B00D9; Fri,  3 Jul 2026 08:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09CD06B00D6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:47:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74ECE120111
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:47:07 +0000 (UTC)
X-FDA: 84947440494.10.5299C12
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id A542F120005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:47:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sI5FiR8C;
	spf=pass (imf29.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783082825;
	b=gtODifRd9sNnMQOssm3rFDi4yFOj6bIWqFFm95GJwhsc4davO9aqCSMOpBlvV2aOZR9JxU
	uQU0P6bEgji7jCoXtKYUQbNW7ybe4Q0XOQBMZjdrMv9SiNpm0kJJIenjKZHT8T1mBlUZJd
	2s5XdZeOqEpJqYli3a1sSg+omvkLFQY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783082825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4FlisNClq+WLU9VmGBotriJLcRO/uQKg32SCiTN5SY=;
	b=wHMFoIIT3WQtfEW+4hZFXyLa1e4HFtu3emxq2oxAgxKG8zKDNdSucKrQBAFsaAFfJCraW9
	GxEB51RynmF5kNOgbM/7Dgz2oBkRGVjF4S+rCWo4tE01g/bCVTBJluVgZVnSrphTCe+oB8
	yFUY//lGQxTX0zDSNYZ7z0olVhZZkWg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sI5FiR8C;
	spf=pass (imf29.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cab97c86bdso203815ad.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783082824; x=1783687624; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I4FlisNClq+WLU9VmGBotriJLcRO/uQKg32SCiTN5SY=;
        b=sI5FiR8CqjZYK5AREuZAAuwEm+fZzEepxQ1U9yY3gF45PoXG8JAVgTqbf9roN8DfeE
         eWwJGJfJXBw6bPm25b0RcPbAvymJ35JVgY2qM9eATROVdOpaXqEYmAb8kJGcq+Js7VeJ
         Tx/bGGb/3+IbCiyJ32C9ji97fGtyVZvm3Y5akDONaHTGNOSDPp6yKksX9Mf4bCHD60Sj
         wB0GZgxSh3Gm5p+CEEOzxYzarZs7q4JE49h3YZb6u4+bxVP+kGGdjHvGUxSChtGUXT0X
         23jqkZVIy4FD2xUn16d8Xso36Hsyv3cFm1i1p70NuR0ORoK37dnUOSGSMdFfmn1Jjdsz
         1r1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783082824; x=1783687624;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I4FlisNClq+WLU9VmGBotriJLcRO/uQKg32SCiTN5SY=;
        b=AK6mbBedZBgsWlgXMMoTkLf5l0KV0H4xA1tmf1EGyATxtwCNA/v9Q6dMJtke8T6i61
         byU9JRHAaONHbUcqa1PW6YtNmmsKXgxSo4Wkl624hybiziHHYP3C7Y/1lfE5+sZ01x4j
         LfdIcpFM7PEATKtbGTgpGYaw9LV+/dLDa/oL+SOCRDXbn7Qp4yaG4ey6j+3CwdZ7E+mj
         qaFSYfoWo3VRhcNCg2vNOqDwed3aYm02GSF7QQV13b7FF/EKLOHZkUaR3Wbd7qluPqn2
         Ierp5D3ZkhSgRGTHvKLZfQgvRCe0uichwdfp+Y5Jf6WH+5RZQHoVF/egWLTqIP2DxG5O
         QN/Q==
X-Forwarded-Encrypted: i=1; AHgh+RofYEOMylGAy8+VqU5WPshfds2CoXRFCGBVz52p96z1LxloFoXCN9wyR75dx5NWvY+pW7tbeLFuBw==@kvack.org
X-Gm-Message-State: AOJu0YxNbJwqWGa2Tim+9OtIXwRR7obhhviD+Pc2ot79KrhtG4LgS/hR
	TZec9Sm92WXwmwntHISw1RBcuhnFIWGzDdtqVi+NLx5rX2at2rel6o+mASjppGP8+Q==
X-Gm-Gg: AfdE7cnHh8dww6xjACbH5MTBfWHaIr9/nF0AQm67LkBfo/V/9YL41cTt5OVeyEhHDUj
	0y+ydaCWboqczFux5+2LEOsJHn6wiu8OtHrujAI1B4KlFgwTvyZ5//Yo/Axb/qfE5hB3FDJaxD0
	4wntp/44LJr2fO7MsVuVLSliF+HFHgN7jvoh7vsnqi443Z32Lq1W10ijqgw8KxxQ+fgCOcmS3Ss
	B6tzgwy6EGCCVnZsCt64HoHtCjbBEE437P/Rp88YAo2Jt/iRZWciXNMUrY1Izj/AaQ06qTXq5S3
	hAJARmNuGlPKgBt3e94vaXJGhO4OujS3RnBixPx3vdOeBrPBc9P//QhhpRI+naMyqDWw06J9iis
	wAFo7jTt8K+kkEl/PwxwilMbvUsONJK/I8wtNh7hWsMXWJtk5nPXccTmLIm5otBMARvu71oD4tB
	+vnbPGI7DN42BX9wL1+3FCKQORZQGwE+wFSy/rbCIvdB1TtK8=
X-Received: by 2002:a17:902:d581:b0:2ba:73c3:49b0 with SMTP id d9443c01a7336-2caa3942d30mr5410005ad.14.1783082824027;
        Fri, 03 Jul 2026 05:47:04 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8f3d74ccsm2728907a12.9.2026.07.03.05.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 05:47:03 -0700 (PDT)
Date: Fri, 3 Jul 2026 12:46:58 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <akevQfFVteCOD6LM@google.com>
References: <20260616134000.2733403-1-praan@google.com>
 <20260616134000.2733403-7-praan@google.com>
 <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
 <ajQ21kH1ZVajS2Y7@casper.infradead.org>
 <aj4iiD5C_yyLeb3U@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aj4iiD5C_yyLeb3U@infradead.org>
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: ithfaiicma3xs13ue5e5xtistfma5tuk
X-Rspamd-Queue-Id: A542F120005
X-HE-Tag: 1783082825-133571
X-HE-Meta: U2FsdGVkX1/7D7fy3gHBcWPhLpCSVJ2eAbEgjsXzUoik9FMZ1aVfGkosrWCEsiMHe9eeLxAazL8zgVR9wUtW3yvn6bj12wUZGOlo35/akxidGTZ1eCdIiV/Trv3Sc1FWGlusd56U4mgZrd5OtCmyCJIjvGL2wAM99wC9Jw5kNKGI0qN1dMJPdgm1wtf4a20/3jBf27Pg9tYStvmgHSzDgkXQat7Z3fLs4wpw9NY3+QSkaEJdtz4a8FTiYFVpGMBBTst6SfC++3REK9DwmEmyBYM4t5F0jPSJGypY+yLqmjfqESHL30Jy6rSFr4+DYuwx+xN76Xibcaud5/cP9RH7xi+NBaBDF1Cdt5DbjaafUhRYgOi51vHjdOmRfBeEUNU3Hfs2uwAFFMTyHWcm6a4ygio0pVztYzXmM5F7PhYjs8NIOtmAvCGkk2/hWNzoPawa+mGOGrz/izOGOfmuqhppcPHzBsu/cRr7k6ftK4HIU5eh/8jJ+yYdPHBaLm+Y9UPYgVsUxbIMXBtbJtf0/TI64sMBNA6N/unQnOXtuVVkYDzixn9rekIbk4DBTQ98tus5nmQLUq+3xm1NBY/2+/01bhb1nkh1S6HANcIz+n0jhqGsko3zMU9DJZAc5FayrNNKfyPtyOixaia7e014P0sky0/8lS5HKGVLP+zDB/WRRWsSlVNvR9P3XOQrg+WXCLaLRibjz+VscrHPxT0mdJusIFW8wvLcguYURGuI6TgooL7vlvLo+0D23DVta2kWUY8XS9cQVNZTD4wCdeMe7nXnP9ZFlwW7hlTEnnDwnKizeMH2Hm//b2Lj3wfzo0Z+IpUSopCD1zzAGZwgrtZa9m8HeU8CO6OgN9eHuYvTbyA61EiISpWz33Ql1Zr1IASumJYYLBRfmhgVzT92aIvCf5HoH0tuT+FbknzAFBLUPnWxrXqCdtMwE+ao1FZBnQXvDAuEZlIJZf037/DIdH1RqVi
 DFXxrxwt
 tJiM5PQs43RgRrciK7ZG/pqELedZ0Hjx87QLSpvYO64qhc8XizzOjsgfBY3FvNBH+UI53QnjnKv3lr/liBC/AQfb/4FTnEpVCe8t1TXyGkAiNYizkRozRL0idMKBXoGtRJ7dS74y+v1OPof/+zqt9Hdt4pxLYPYejk1zS2pg4fnWO6bZVZn+zgmZ7P4DWnWmbLpacnVDGl0ihZo3JlHJ4WKNkQ8orzt/JOT/PCvYZ22nkk2ipUcPZbd8ynJuRBeolgac1Oh2Vek5cRdcRzuO7gq02aHzNus+gr9uGaesDeeoV/jylxVE7AF2qj81NdzEHykebIUbUyU4ZgwUVb/eKr6Dd/Qx6d2RgR8KEmP/dYPcMhrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 11:56:08PM -0700, Christoph Hellwig wrote:
> [sorry, dropped the ball a bit on this due to overload]
> 
> On Thu, Jun 18, 2026 at 07:20:06PM +0100, Matthew Wilcox wrote:
> > On Thu, Jun 18, 2026 at 07:10:45AM -0700, Christoph Hellwig wrote:
> > > On Tue, Jun 16, 2026 at 05:23:48PM +0000, Pranjal Shrivastava wrote:
> > > > AFAIU, the MM subsystem explicitly ensures that every valid struct page
> > > > is part of a folio.
> > > 
> > > It is definitively not what the vision for the folio is, although if
> > > I'm not mistaken it actually is still true right now.
> > 
> > It's not true, eg, for slab.  While there's still a struct page there
> > for slab, there's no refcount and flags like PG_locked have different
> > meanings.  You'll get into a lot of trouble trying to treat slabs as
> > folios (and that will include assertions tripping).
> 
> True.  But also not relevant for direct I/O user pinning.  If we stopped
> having valid folios for anything mapped into userspace,
> iov_iter_extract_bvecs would run into problems, and we had the discussion
> before that at least right now it would be hard to fix.
> 

+1. I see that extract_bvecs also rely on user memory to have valid
folios even if we were to re-use parts of it (get_contig_folio_len) it
still relies on page_folio() as detailed in the other reply.

> Also if iov_iter_extract_bvecs was used on kvec or bvec iters we could
> run into the slab problem.  The block usage currently makes sure bvec
> iters are not handed to iov_iter_extract_bvecs, but there is no such
> thing for kvec vectors, although no one is using them for direct I/O
> right now.  Not that I'd want to rely on that in the long run.
> 

Do we have use-cases for a kernel user for direct I/O ? (Just curious to
know if there's something on the horizon).

Thanks,
Praan

