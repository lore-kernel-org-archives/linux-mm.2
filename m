Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FBF8F94CD8
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84EAA6B0088; Wed, 22 Apr 2026 03:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826EC6B008A; Wed, 22 Apr 2026 03:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762D76B008C; Wed, 22 Apr 2026 03:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 661FD6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:18:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 105B48DF5A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:18:01 +0000 (UTC)
X-FDA: 84685337562.28.BDB32FD
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1B62540006
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:17:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GmRkZ0jp;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776842279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XNH6lrFfSGfrUbW+37AE4lo9UaFSg4Ouhd4198aVww=;
	b=6VnUZWI8WXGV5LGRQChsE1tQmDVifm0N3cpN00XR044++HtmhTJq6kMfCD9VuVjLVADOHn
	5ziOlRC2PGkb2d1APja/D2aGMTYxfLanZbIoAnV+pBakoYDEZF7SYg+B0btpjZceG4fG8l
	xRq6WLFnZHrrC0+pChcY1XyiUdrf3TE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GmRkZ0jp;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776842279; a=rsa-sha256;
	cv=none;
	b=0/7R4cV0twidXFZ139wDJR2M3vItp5IjTPeW8UiDBwcqlDlbs47cDfctaCI/65Yx1LvA/W
	JxKzXb1AcGzW8AEmW7ZHtS0dY0s6A3umxFvyID6/UX0XpSJQL2GP3q2rVwVq3UMMWssnnn
	CmP0Wp7I63umEFWLEzUTAqTQ2t7BR8U=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59e4989dacdso5602415e87.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776842277; x=1777447077; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2XNH6lrFfSGfrUbW+37AE4lo9UaFSg4Ouhd4198aVww=;
        b=GmRkZ0jpzvxyZWOmy73NuC9PQwawS7KvXs0IgsNhCUw5TLRvBcn0WFAkrO6GV8ye9d
         ZvJmz8iwjBwciJik4DfJ2/ixQ5wNm6XBl/HH7vJct9w82jCeANWo7wiRuGh5u4d+lT0n
         DjzWyaTJhzJTFEDt4fMpcK3fjkDaTInCVX81pDzUazhAjZIyCpHs5zMcfwBkiZdWJig5
         xybNYPjHB8Ia7hrX0M9Ne8Nl544k2ZAyW0C4Brdkbs3rD59OfSwHcuAzZAtHVBHdQ+Wt
         ee0FdZzZu4PEhVJ3nhv2iUoZytdPZt36k4ET41SHJRUG1T51HtPSRwTZlRj/liIW834p
         ZRxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776842277; x=1777447077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2XNH6lrFfSGfrUbW+37AE4lo9UaFSg4Ouhd4198aVww=;
        b=TzbKuZSOcod3Wj3Jy96bnpBJQgO6Bf0M6FIgniLW5LVQy8aabH+zrmfjWSagIDpEWv
         eGMPIBt11kPfc69AcejjfS44qT9vOHgtO41GKb5J5sK+NUE9+aeWebu1W1JgOv7QuOSj
         Y7R3J82lMSGRHzFOofUSUtgWWP/lsToBKaWGh6/YEblSjkpRdj82dx0xWrQhezYU1vju
         uYGswZO4GhySHCNJB0bW3fujV5xSUXL5FDBm5MbztIufFxCd5nuir99ETHN0vQqoxmBK
         MT9nBs6w2STb8oLqY8Rm7YzuYs7qyL6xrso/FCTIZwYKuStG3Wgap2zXz3T4blMsW/BO
         1bsw==
X-Forwarded-Encrypted: i=1; AFNElJ9NR8QYsD/WKBEaKPzbbfvwevJ2pug+bgd8KNV+FedeNoWqFQP65DdoCVZwMcFKXvqrv7aQkgLRQg==@kvack.org
X-Gm-Message-State: AOJu0YwQbGINclPFn/cT3OdV9EMHHorgG2NDLW00VRT7QCdWF7b7Yxop
	pKsT7ylXRRFOE3uCxDOinOH9d5dmH6eTOJ4oktFuitA1gyMzRzy5J/A3
X-Gm-Gg: AeBDieuWKEPJEDGA8t/6P6wCLyuufO32Ogryy5krPACj9qLiUKBTM/TOukP1B9+7/80
	nHWCS6h/WPXaSTC97vIKP6G/hoGwEwXcpvtfNKzfj57Gz0edS3gZMvYPKFYhKjgpDJ+MEcuXQ02
	E9REyjv4USB6XZzO/kCh850+h5lIg1UhUHxMQuo+gXLEDq9z8sKJ4eQXCzgkjwpM5S941QeYMYM
	Bfmv/jTJT/fcOWTIEUgVrHPUEuq6IuNoz0wyBgPxDzh6iJrliMLPZTlrg2fD3VueMn+f9UrL3Tu
	26MpFvvkVFBbaahD+9HR4Udn3LAPQ7Sz5QehEO9pffnTpcrrktgmZSW1sr5KW/5WiC24jxh/gm7
	GhoKkjtlrdrF11MTKrjk6SHPwtUJWLe3sMLeNGTyBtpIzmkaHdHCVPa2f4+6kGq+bn7LCnSo+Xm
	ph17eUu6OrDg==
X-Received: by 2002:a05:6512:159f:b0:5a3:f0f7:7da1 with SMTP id 2adb3069b0e04-5a4172cd17amr8166452e87.17.1776842276850;
        Wed, 22 Apr 2026 00:17:56 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4187ebf2asm4221846e87.80.2026.04.22.00.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 00:17:56 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 22 Apr 2026 09:17:54 +0200
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uladzislau Rezki <urezki@gmail.com>, Thomas Graf <tgraf@suug.ch>,
	oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm]  c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Message-ID: <aeh2Ii9CxtgfsX_p@milan>
References: <202604211323.fac1b29e-lkp@intel.com>
 <aedvSnhOGM_mauYP@milan>
 <aehdcxC14ycvY481@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aehdcxC14ycvY481@gondor.apana.org.au>
X-Stat-Signature: 53i7kx55efcsmccmbiqryiufhy85pmax
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1B62540006
X-HE-Tag: 1776842278-28149
X-HE-Meta: U2FsdGVkX1+Wl/WRrixNN0x3sHwTz4LjMgIBdEAuREewqOuw88RxOJo0zprVDzwM28fjkIt91bmizFfHlHOc2rHH/aNEfx+bdF3bh0zgukyIpBACEfGypyCzvwscoLKQxSbem/8GdIbu9BWZHl1dZWAFR3XbStOgdFeeBdwoohWhQfmhaD4xas7G3bGK25A8ZyCAkr9oHtjby5tgf3mg5lW1poCC4hsWsN19d7ZfDSwTZU+J4iRljm5J1GfStKid4djSLXQsUNNZJTk9NL97STf8ukX/psMAe1JaDZOKDXckzEIuSpTsgLmnPZL9YDXtDWw8eKgOzTdDTKcIMB01eLutO2cnAouP/RQMkbHb6GAM0iYmFh5wOcBEurPX0rxG86BFKg1Fil/GyyLsHdVzj2Ix2N8M04xy+/1Fh6PLxnwTArbS5An9F+g2J0s/CthzLTHZTv+cq6acUeWF7uNevyP77nDPUcaPvMYUKdxNsD6bEyRBsjiVhu7Eu6CQ/eywFTqMvaIj67icz7JgNHdXIFTGwDzVWHUqqqi6aIkw0znv81fpTUf5iA0EF+pAHWqxHqlvRCkNZdVTW6UgG25ffswEHzD6vwG8JrHEv/oiL6foUT4doYeQ47aHsQBjVHZKA6svek4QNnPDfKUGIgDpovJys0GR6K7vnU/Vu4/UOV8K2uLSUqnMEzdeiZEw47QL65LCHT+sukHawRyTWbnNvNqzx6MVTc0mFrmseJ8tXpaid/jwAQUWKf6sVpSdOnx8WU9n2vxC0L/9673Cly+zzws5uHU5Ntv+xufGlTRUnjSwuZ+P1RdNyQeso0iqwV8qlWK4B+XQ8ojwvxso+JGi05l+KU90p5bSukhTjqrN01ko/SBO7zeckTokXYtdC+k7mcsY817vQ6e9kAhUJRaiYfeA04xhL3+SbmCuuW9g/hTJRBy3U1ajbFX0w9XGlLb1eI+1bgy8fqsw3v66WoZ
 Hu9z2hME
 o1HGXcNOsP8TfoflzwCVZDnr6LJjUTQgeMm1lbqiiTYyS1IbjOjKvAmnWx3G2oIb1vBWcJpahH+6/byAbya9tCSz3rj9M2gsys9gAT1mX25Ojqd5LzmGGa2V5+F4EaaojVxaQ9EscplRSgIWEiLs6vaIUnjcUszwHCb0zvQ+mABE5pT3WYtJv+oIfNX0pfNLvXcoV3Y3pud/c+1XZXrW7AtF4gP9jRAgRBbcnQbqC2jCGwOxP/mseXD0Iu5pA4j6/6Oem5uLmU0I4wuXxridctuSPZl012i3E1BqX6GGqX7f+yUC+f9PwLdL612VuTW3NjoDJhdEA1gzNiuolE24tY0Ml10+QZ/dVenhPFBNvVDVDSVUUI9vq5zA1LtAkqe5AzRtJrhiFtjAlUPRHt/lzZPaLeoVn9pGUyuKZNJ/FfBl/C59KhvlfG3yggPDSJMh3uVD3ZvpLhn01VMrIvpXW3pIJ5aY3ho9wtTsaTEcHKZi6FYKn+TJ9B1CEB4ikN0XoMVBX7gnTpsMLjbKu9axDI9TLRL7fCnEe3Eb6y1YjW7+WctMNyEglvEXho2LVJ5HtpQ61TWVzoGrGVRkGYOJnfYlzEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 01:32:35PM +0800, Herbert Xu wrote:
> On Tue, Apr 21, 2026 at 02:36:26PM +0200, Uladzislau Rezki wrote:
> >
> > <snip>
> > diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> > index 6074ed5f66f3..a892766dcedd 100644
> > --- a/lib/rhashtable.c
> > +++ b/lib/rhashtable.c
> > @@ -473,7 +473,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
> >  
> >  	err = rhashtable_rehash_attach(ht, tbl, new_tbl);
> >  	if (err) {
> > -		bucket_table_free(new_tbl);
> > +		call_rcu(&new_tbl->rcu, bucket_table_free_rcu);
> >  		if (err == -EEXIST)
> >  			err = 0;
> >  	} else
> > <snip>
> > 
> > Could you please check? The problem here is
> > 
> > rcu_read_lock()
> >     rhashtable_insert_rehash()
> >         vfree();
> > rcu_read_unlokc();
> > 
> > we can just defer freeing via call_rcu().
> 
> I think we should fix that warning instead.  The memory
> that's being freed here was just allocated in exactly the
> same context through kvmalloc with GFP_ATOMIC.  I can't
> see why you're allowed to call kvmalloc but not kvfree.
> 
> That makes no sense.
> 
There is vfree_atomic() implementation. Regular vfree(), historically
is not supposed to be called from non-sleeping contexts:

<snip>
 * Context:
 * May sleep if called *not* from interrupt context.
 * Must not be called in NMI context (strictly speaking, it could be
 * if we have CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG, but making the calling
 * conventions for vfree() arch-dependent would be a really bad idea).
 */
void vfree(const void *addr)
{
	struct vm_struct *vm;
	int i;

	if (unlikely(in_interrupt())) {
		vfree_atomic(addr);
		return;
	}

	BUG_ON(in_nmi());
	kmemleak_free(addr);
	might_sleep();
<snip>

since your GFP_ATOMIC context allocated chunk of memory using vmalloc()
sense kvfree() uses vfree(). The simplest fix to free via RCU.

--
Uladzislau Rezki

