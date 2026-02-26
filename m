Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D24CFD8FDA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B186B00B1; Thu, 26 Feb 2026 13:06:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF086B0136; Thu, 26 Feb 2026 13:06:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD806B0131; Thu, 26 Feb 2026 13:06:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 446EB6B00AD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:06:58 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E9841602DF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:06:58 +0000 (UTC)
X-FDA: 84487388916.02.1F28F1F
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 24EA34001C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:06:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=TNeRh3oM;
	spf=pass (imf27.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.219.49 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772129216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UbRn1/Zoh4IIbiAkpXZr+7zJlNAh6IGPdvB7q6Yi9o=;
	b=GQrLkx9T6cc0Cklse9gJanYAAHbPP+YA99Z99lbWBYaqeeDrwfcEjuSTDjdE7n1Kfxl6HB
	37hLjId3p7qutzXMlN+paidRs6np/QGc89K5MFvscSTlPX5Xar2ZFPVxfd8UV2z/BFnIIo
	yXS+wnrU3/VCjYNVOeScbQ5T3hnUr5c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=TNeRh3oM;
	spf=pass (imf27.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.219.49 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772129216; a=rsa-sha256;
	cv=none;
	b=iLkmUyXfsfbeQrJa/RNz7o4QGzWvyfZTCabFu8BXZ4ALJ60KeZWC/OrmC9wa24pFU3XJII
	RKHXr/N3pDYAqOdDZXKWwURGUPH3O0bBK/dpLECf2r3EIwnDRYWZGM5rqBtaeTIjW9w2EX
	p8UxVUqsoFCsBAVp2fdbuxPsNz1PbFs=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8972a14e27bso14282546d6.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1772129215; x=1772734015; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4UbRn1/Zoh4IIbiAkpXZr+7zJlNAh6IGPdvB7q6Yi9o=;
        b=TNeRh3oMvpj62u85jJ3JZ0mBYBjzS11dOiAUA6S6ccQ86qiw7B7a7eSQk/eWJ1MhSd
         o/1JFoeGaWHsLRKXoSgurk8Wg6kVYrBHl6Fo2eeolTQNyj2LMcIkliQ/Q2stTu9cgEJ2
         phJAC5VljsAvD5x6tgPbFyFsJjEq3IGeiW6bWVmORvhXZ7Gi43tVFxXW4eE2PrfYUEjU
         d2vocv/UurU/bhzGsS6TDrLB6nSDbI28RvU9ziPNJbRsqyyxMxff/BAldUQTBip4qENm
         7tgN67cdcj78hBF8xZN1ivyT4JHiSalqyvHSwkVb51UwHcGmNeQ6eS/jfVKFSoIkHAe8
         Bcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772129215; x=1772734015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UbRn1/Zoh4IIbiAkpXZr+7zJlNAh6IGPdvB7q6Yi9o=;
        b=OTXuZXmJBH4Z+rpEDzz6KbsjMnp+zPCSNuqiG6aFWdk9Cti3n5/A0RObMj7RHJwrSw
         ivH4OdMihZWR0O1VmSorxvqY7TQDdMt15vyqvFuYANDEYJRVx6YDMfcS89Ggk6kYghNt
         lGoqyHKQ8pUvdpZar0PYr1r4rTnT6RHMV6+OSPN1Blejc2g0wzjkyUZdZc29/XkjF2dV
         RJRzu56XfvIRqRpsjEM49PH3l9s49cxCvgBLYgQI/Vzm+6sWrVO1FHAenFyNPnq4Y7L+
         cIHvghsjudueInqw5nOgBEQCKkPdjur5BRnt59yPDHZHjgxRs45EJ231a3f653pAd2XT
         lMjQ==
X-Gm-Message-State: AOJu0YyqLGxQB+13ydt3fjxEAgn4VdFpFrV8jCpuAKLwy1FV7IyQanKl
	Y01L0ZzDNbLnnWSdGIXbZ85xCQpxLws0PQpOE8T/e2ZDsUdkgHIrN9he7h16JC77CQ==
X-Gm-Gg: ATEYQzwtMS1eRyy+sAptIS5xjtsbJXcq/uCalaBd0V47qTKCLVBX5q/NgUbyT69WELw
	8Wt0sTlv/OpT9oSNQTOnfmA7HAOwD6OPdSTr14+89M286toVvDrOfKyVhpTHwi+7eD2nMznQv7u
	YDIho7ZxwjgRBTPzyX6oFaZvDwcEqqwwJpzZvvy65ebfDbC4wT4rFPgM0xCpmaSSWj27Z4N+uUz
	xt11nNMz51uv8HA6yJNKDUfnqJ9qAp68chYJ+MFSrcoHlvMMw9bypbzzIIw5yP9aeB3nAJB6TVk
	ZQmBpvUynfrGiWyYtVqgnil9teOqmVJ1HmDGvZKRfaAIlNVtqO/btIZNRXqTWmC7fo2NPjJI8lZ
	kqPkN7W/vejcaeBu0EXmanGt975dsNR1yYdIGDzoNb8FVMRc2IlsKMunwFUlkroycb4btiAxshz
	8F+/opUSYsGkjzoJHbUpxFgyCOtkxHWuejDwfmh/XCB6XLap21mN2Tu+jxlJ4QywphYsoonTGan
	6hPiaw829HNtC8FUu+J
X-Received: by 2002:a05:6214:c2e:b0:895:4b79:83a5 with SMTP id 6a1803df08f44-89979e1bb72mr293888636d6.5.1772129215103;
        Thu, 26 Feb 2026 10:06:55 -0800 (PST)
Received: from rowland.harvard.edu (nat-65-112-8-51.harvard-secure.wrls.harvard.edu. [65.112.8.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c6fe55cesm23138596d6.0.2026.02.26.10.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 10:06:54 -0800 (PST)
Date: Thu, 26 Feb 2026 13:06:51 -0500
From: Alan Stern <stern@rowland.harvard.edu>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, Dmitry Vyukov <dvyukov@google.com>,
	lkmm@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Daniel Lustig <dlustig@nvidia.com>,
	Akira Yokosawa <akiyks@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Luc Maranget <luc.maranget@inria.fr>,
	Jade Alglave <j.alglave@ucl.ac.uk>,
	David Howells <dhowells@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>, Boqun Feng <boqun@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Marco Elver <elver@google.com>
Subject: Re: [BUG] Memory ordering between kmalloc() and kfree()? it's
 confusing!
Message-ID: <9240040d-598e-48bd-b802-bf91cce92d0c@rowland.harvard.edu>
References: <aZ_lJAqxh_hNGr_v@hyeyoo>
 <9dcd02b9-42da-455d-aa08-165e6ff0b921@rowland.harvard.edu>
 <aaByMLSAIJM8HdbO@hyeyoo>
 <d8308828-ed28-4650-8c8f-22a7e5cfd1a0@rowland.harvard.edu>
 <aaB-1e1LoxkcYl2f@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaB-1e1LoxkcYl2f@hyeyoo>
X-Stat-Signature: xt7on1h8pcbu7kjixcd85hfkfuk36k6r
X-Rspam-User: 
X-Rspamd-Queue-Id: 24EA34001C
X-Rspamd-Server: rspam04
X-HE-Tag: 1772129216-853337
X-HE-Meta: U2FsdGVkX19zniw1X3FR5uL0I8qzBkDZHpPWk736wOz15JO00xFI7zlCIH0y5Pg5hzAChp0vc86kR6+ktlWmRV3EC8O5pnoToE6yDEHI9LgL6da5L1/TPRBMnEq9IOLb5HE8OWRWQmiZx1IxmypwSBYMakHx3cBBUwO7PyDLRrZIkvICbonvOzHMAOZTGaDL74KCV7ra5EPkfxpdhFRl9ZSUFKy31Ut5uPfSwBVJuLlp0Iv+W18DkdHcKuQSB/v39RuSA6QWiL4kMHjDjYRTA6qY9F4kfb2XtjaubZwO1DN9DT2TdN2vr+KFQWJfhwbpCwK3I0Rt+tW+q6F5CJqMu+BXILL6j/PsfMlal3MNJyBEa0kJ4HthD7jxLhxrdvTdTFvH3MahvXIWbwaGtcCPoA7zYrrzwZu3deRRHNEpW3v33NThvLZqbvr8EJweLwjjRa5+XSZQPXxHAE2LK6VtGNIIUGwPwY62nvje3qaU1EH08Xvr4zn7XvCfBzoRpGrhQnDrYXr5kPomX6E8GhoJ2mfuxopY3yk19llRz5z9oAFnGj5gaP5i7nsFQ6pH13OH3eK4fyDP8/n24KRO18Q/D/GTPV8R3GzF/wcD4dD9d8dAatEQ9Ew8TbpCk9ernfVzYViFtcvxQ0D3vU+IZbsx5FzYirmn68m0tU/rdOsMjoE+/xb/iYK3ZoPJVj8sIdv3gF/F4hitF/w8cLQi2LHnu7J76sQwKwoPUIRBixKBgHjSZIzUAH8IlXm2um6C53rMULDdqNhXUCKzgRbGxve2txYO7kkXJanDqqP6cmCswF1PtLb6JhwQyl1fqAMgXtML1kerb1LXPpNpVpOfccNt3C7avD2v/gi9LxZTE6VkK6U/Z8xcxG+TTYsu0IslazNdqmu6bffAY/wJNXg3z4XHhtFkw1rAt8zzAKjO76PzzNO5dyzl89DX5+yq2Sc/b4PXjNil8zyfeJfCs0kZpn/
 bm5bgWxs
 27KtbQ497F4uP5Gswcw1iGhAyyAKS53qGg2n1MX6nBGC2qAB/X85Hk+3fziwQS/qPpBOOFANX0OUvqKdvi5072BKuUioZ7aS2xPZzNsLkMbcUE1EHeSPivtzWbADqbxshmF4nUA/Zv9uFBkMNR/ttI+LMimOgVd5znYGwYbTKt7eaxUg1A6/XM9kQYiZq4mlJvId8u8M4B7fgtpFRp8jGSS+FRyJ0BA8mf14zcuZ5Qr5RX+pD9NeTOijCXG0BKYg1pl135ayehZ/8leTcKsabPZ1YtgUmmsB/0vgzkgdCaXKQMD9auCPRL1TYQmqTs2jj4U/eDDXr8gAhcDW/mBq21Ci6ciSLRPi16DkJ4y34uTKk8aUKb14glpyYjd9caMt5zUULHmNkeJLd4ORbF5pHE2iLIiaYVczy9oVNJVQcdtEgZFDGIiQGFnWFNyICBptp49bemDyBo34WyxohpCEztmCgbe8BshYP+nkmygfJj4TRc+gnmYiStk9NBDuR0p6yWFt9Lo9J+dFAPfTnBFCzK3kvpOFM1ugf/gzwG9Gnz0Uf4vfwx2Zq/ocDVzGjKHVdT698NF69fAg7om+tfsvUfBq68ebfYJX/DNAUvbgjvzjAU1M27QS5U/jhycJ3wDzjI4Eu7XAXk1fsTxovCZvFePLZhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 02:11:49AM +0900, Harry Yoo wrote:
> On Thu, Feb 26, 2026 at 11:42:02AM -0500, Alan Stern wrote:
> > On Fri, Feb 27, 2026 at 01:17:52AM +0900, Harry Yoo wrote:
> > > On Thu, Feb 26, 2026 at 10:45:55AM -0500, Alan Stern wrote:
> > > > On Thu, Feb 26, 2026 at 03:35:08PM +0900, Harry Yoo wrote:
> > > > > Because the slab allocator itself doesn't guarantee that such
> > > > > barriers are invoked within the allocator, it relies on users to
> > > > > do this when needed.
> > > > 
> > > > It doesn't?  Then how does the slab allocator guarantee that two 
> > > > different CPUs won't try to perform allocations or deallocations from 
> > > > the same slab at the same time, messing everything up?
> > > 
> > > Ah, alloc/free slowpaths do use cmpxchg128 or spinlock and
> > > don't mess things up.
> > > 
> > > But fastpath allocs/frees are served from percpu array that is protected
> > > by a local_lock. local_lock has a compiler barrier in it, but that's
> > > not enough.
> > 
> > If those things rely on a percpu array, how can one CPU possibly 
> > manipulate a resource (slab or something else) that was changed by a 
> > different CPU?
> 
> AFAICT that shouldn't happen within the slab allocator.
> 
> > The whole point of percpu data structures is that each 
> > CPU gets its own copy.
> 
> Exactly.
> 
> But I'm not talking about what happens within the allocator,
> but rather, about what slab expects to happen outside the allocator.

I understand.

> Something like this:
> 
> CPU X				CPU Y
> ptr = kmalloc();
> WRITE_ONCE(gp, ptr);
> 				if (p = READ_ONCE(gp))
> 					kfree(p);
> 
> Yes, it's a crazy thing to do. CPU Y isn't guaranteed to see
> up-to-date version of object content or metadata.
> 
> Instead, the code should do:
> 
> CPU X				CPU Y
> ptr = kmalloc();
> gp = smp_store_release(&gp, ptr);
> 
> 				if (p = smp_load_acquire(&gp))
> 					kfree(p);
> 
> One reason that I started this discussion was to argue that we should
> have a well-defined a contract between the slab allocator and its users.

Yes, you have made that quite clear.  But you're missing _my_ point.

Which is: The same mechanism that the slab allocator uses to ensure that 
CPU X and CPU Y won't step on each other's toes if they both run 
kmalloc/kfree at the same time should also be able to guarantee that the 
metadata changes made by CPU X will be visible to CPU Y if Y manipulates 
a slab that X just finished with.

To put it another way, ensuring non-interference during simultaneous 
accesses isn't all that different from ensuring coherence during 
sequential accesses.  Doing the first should easily allow doing the 
second.

And if it doesn't then something questionable is going on.

Alan Stern

