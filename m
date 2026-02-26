Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89595FD8FD6
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B0B6B0164; Thu, 26 Feb 2026 11:42:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E206B0166; Thu, 26 Feb 2026 11:42:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D536B0167; Thu, 26 Feb 2026 11:42:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78E356B0164
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:42:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1314913A75B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:42:08 +0000 (UTC)
X-FDA: 84487175136.25.C50B1CA
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3E5C8A0011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:42:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=mPh8iBcQ;
	spf=pass (imf15.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.182 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772124126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25OvDP+ctZOpce7ovpdW5sTLVF7qvDLK1eZyECLnIqg=;
	b=4AU6AUS4zRHpSdM32vcX9lzg7haEzVJoHOTNgPnwnX7irSrCj32TrhoFHVtk2Z2IUspv+d
	mA1InGgdvbtQ9GVDNsCZWFdHKyBYMDJlhwiDiVnR89v36xvtCQR4tMCjIOe2wyDaNOk+NV
	4yX9KcNwsGx72Bc7k2DG8QDcKwLiHAU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=mPh8iBcQ;
	spf=pass (imf15.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.182 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772124126; a=rsa-sha256;
	cv=none;
	b=M6vuK3xr+QJtrTToTPpUu8I0VGSPc3A0ekX3hr87CbfEiRF10qHQtljRzNWTjAyqOUpAx1
	qS76i5tKbYsHmyB8nqCfbFyFyYk67ftyibuQFzzOJxqA47hbRp7UjIoA6Z+VQZ4sp+Sgoe
	ufaF8LQTfCiLcrZEjL6wV8HFFg6VEF4=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cb3bae8d3eso91514085a.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1772124125; x=1772728925; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=25OvDP+ctZOpce7ovpdW5sTLVF7qvDLK1eZyECLnIqg=;
        b=mPh8iBcQ+W6N7OCbbEoSI+e1tpqM8wuMY/IzXVWrW4rWnAq4K6yHKblg0/FWC9LSU9
         c4SenxIwqtSvbNeHI0M3P+JQKvYDynlwV+uCDrEufE+tuxFvSB+raqP5ZC3jH/hYj6pi
         s2h98prT10rYxkrRSdbXEHju+s9qcHWZc/xbgHNH6kBj7mkBLE5QqcBITG5zpTzVtk4Y
         QWFoDzHkleq7Sxv0vcvUMLZZac++e5dzX/CBIYmC7Dpu4M5jNT5tY86rL14XhtKsVBni
         ag3iR60jWpF3MR48+aZwLI3nPuTvJ0rYvqbJDetPheehB7cCxy8NJgOZnsx4Mrr/Anes
         0u/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772124125; x=1772728925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=25OvDP+ctZOpce7ovpdW5sTLVF7qvDLK1eZyECLnIqg=;
        b=h+V+mZ9mF9a8G2/bwNMAuq5qkgBNrO7n0gqvzSoEric5Ir9pF5qWoB7Hz46dhcsRQh
         jKjegfmUgZ2mdnH/0Kk2CxIB8mUHqE6xRm9EPoIl+ifmQG5u7T3Xyxa3BDAwwNylCPR9
         s74JYjNZfXfvaB4c4nqjGUZcAQxyZkoABhcRxKpQr4HYeJbsda4TJNeQ7tYLv9L+9v0V
         0MMrJr/OJmtZgSbKCVQGIIOTDDoqSRnHwcQr8QS7N/fKumEFsjLQEgNLZFZaKi6gr/48
         9LbHAhDvl1HxFTQkvb3FPMwtb7ItnsKPsFwUVTT1t4Ha8uJD2KvRvGYVIqHlmwIxyORS
         ZqPw==
X-Gm-Message-State: AOJu0YxGDwXU5boOo+Jze89PJCDXkIo0JRpRwGROjJtS/iwOFybG9pKi
	sNFgQRwFDiErtqPLuJa5RFKhKKgAHHntrj5VLhisWEvZJThzV+IWDUMmDw4RxfkHOA==
X-Gm-Gg: ATEYQzxGKZ63H4sr5KdADTbAABUVbHnoK6vj9dHpMiwma3klZNQCZaJPZweKqLBjZxo
	v2xzFmjPJrfp4xuHWOdN9jshzYEEd8S+JFgHMqpqrOcjyqiwBNaUuh8VfKBk2nR9kdrJ4RiSNEY
	YePjegMNDvq3G82ihO4LiQWLqpRnDTjVGwcxRJ0Y69mJEw/cXchXCSI1SrLovoQnXUYX6pTbm/Q
	uXQRODe42O+ppE5tAdPHhnL+E+5WqWrVDZapl2To34MyrlquJO/Taw9g8eAYSN6SzoOvD7PrPpD
	+CgjLXTn1RArFdI2fiKXp4TzBLSTehpUHcyS86dvLspxImQOU11xc7GXJWkgeQcL/WTAtMTYxCn
	zC2F0luKyd2vrmnlwTMl5LuWTJsgAiHsGOoZoJAUcvofmTmT44FSG3Mhsa5PdP4sSkReLejXAii
	yjcXYmdtcXZqLiB8a9es+0jtcrpL4K2Hes2Nhexc/pxpHbmmMSXx45rXtrOyRrmKIEcNJcRApoY
	6ReOIB1fw0YS1E9Le7f
X-Received: by 2002:a05:620a:4542:b0:8cb:4c29:66b3 with SMTP id af79cd13be357-8cb8c9cdf25mr2260008985a.15.1772124124932;
        Thu, 26 Feb 2026 08:42:04 -0800 (PST)
Received: from rowland.harvard.edu (nat-65-112-8-51.harvard-secure.wrls.harvard.edu. [65.112.8.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c716e09csm22299906d6.19.2026.02.26.08.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 08:42:04 -0800 (PST)
Date: Thu, 26 Feb 2026 11:42:02 -0500
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
Message-ID: <d8308828-ed28-4650-8c8f-22a7e5cfd1a0@rowland.harvard.edu>
References: <aZ_lJAqxh_hNGr_v@hyeyoo>
 <9dcd02b9-42da-455d-aa08-165e6ff0b921@rowland.harvard.edu>
 <aaByMLSAIJM8HdbO@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaByMLSAIJM8HdbO@hyeyoo>
X-Stat-Signature: pa9odztqje4zto8bzm8uafzqkxfonw93
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E5C8A0011
X-Rspamd-Server: rspam02
X-HE-Tag: 1772124126-103247
X-HE-Meta: U2FsdGVkX19wPOits2IN+bLnAFJBiUcd1XKyVHPvyipQI/CzW3ta6E0ji/JTxlfV1WDRWC+wfOKwF6mOcYQR6eaR+LX7ZpYa5cJ34jYAKMB4qfH2ZkGTKbEyp+Hx6rtgtqUwobhWxDZ1mraEK0pH+G/uVmTMBEPrDR0xRMlxmegoz5tick7uZhZAA+HU69jWqCszBZ72DjJjpqGCNHiI9VwuadUybIy/c57AmL24p3IF62CgjuyXwaghFaNGyTY/H3XLDFTyqKtJXYDkMXxe5efE1A3wP9FtrqlRmvWPHPq/IiigsworKcsw2kWNOt/uaG/GJwSs5sQNP3ZjNrJFrS1fEN3rSyF/TPr1OiydkENdLFxpXrNiiCVhs7gu6583k6lS9oSioFeCRF7H/bHlPHQmQR6vfo26Sr1JmamyYZ6Mz/OKKGoJ/1+wHNNv4vwLJJ7amippuOZT+M37C/8L7DQvbTBO1nroCPrZ2WFBubcmXMZTWA4vqv48Kb8W3mGZkNxKCh+iiDDBDjJEfcecB2AFSUnWL8zdVPBKzLuwzzZHGGMbLaBp0G7bxmEiN09g6ZlKoTgwhFpqidSoxV4sPo+yPskDkHk4y1sPZygWbNOI3qGHC9+MHMFlxzku9tbplNpCOC3biEfyRo0touO3V08KRAmqUhgaDOeoc3jWO2oTe8bRoxQhfs0xX8zd1PH1qbIMXCgY/Xh/Dgfj5fA30zJ58/3j8gxP30KdxM7+hPdNcn1KouZClbtbT5C+5mpRAJPHpuiuJkhNRtvpmDyF4myIZLz7nSk4wdIQiE+5cKKyM3HKf3LjPRjqTyy9+Hqmk+Yohhtc8JMC8H7sjGXzDhSdA2SeXeE61HsnRKx45AetR6vDRu4SmmbgmZKBFOq9lU0YrlJPh6LQ+vZ2GNDphKGG6QE3yDwYbHD9FbAnkmOO4ihjzw5sd4KZOdHh0GTYs5ukCkOqLsgK+O8oa6S
 Xtzgp31q
 9pDqY9OD9Iz9HKxM7LPIx4wH+BJRmmDBQKvc/Mnd3L8yEz1lMvnHJ0LdUFW4EGl0RCEdn3sQstSk04FDxBtspLuqC7FJggRwmTcSBrTEMN61fB8eJKKD9PRZ5/kkCyk/j1IT8/4NTFJ2cwrv6uVAQxKai0K84Q924r03FZ5APHSDZB8l4C3UfFfOdtOcLxc/gyAqzdWdC+85ckS+G9OPGxuB5GsahffX0T0hz33NtUEg1zEaMVP4bDFeM1/6xIOe6mBAXuxhq6zsKOxcRwNk3GTZd8dg6fyxm+/hUxsmgnWbeP088A5QBLBrtzaOLfQY3ylL0gIfqYPy6zb3Ih/FEzBIUGxlCZnzzsb0/oBGquTxVd+2/YtuoO7+Z5dWq1Txx2YfzTfetV/As2jwTeMZ9FAomoem0yit/MmmVrMxUITM7aurtYSlhD1eRpmRstAAgNmdOJYUdL9IUetLWfJHU2wHLQMPQsZWL6D6/JRPPsKusEjc77fc+RxJ++51ySegT8gfbfjzTseml4odMrwR3tLmhZaGr+Al6ZSPoTttXwjQlY8vddmIyY+uQKDO20Go8HnfWgA+3x16gEF2uREsZasdsfZmb+prfzmfuSURUS1sRRQdBMSlmPgaKecnay/XCcx2hJozvF1LMlGhyZsvW02FRMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 01:17:52AM +0900, Harry Yoo wrote:
> On Thu, Feb 26, 2026 at 10:45:55AM -0500, Alan Stern wrote:
> > On Thu, Feb 26, 2026 at 03:35:08PM +0900, Harry Yoo wrote:
> > > Because the slab allocator itself doesn't guarantee that such
> > > barriers are invoked within the allocator, it relies on users to
> > > do this when needed.
> > 
> > It doesn't?  Then how does the slab allocator guarantee that two 
> > different CPUs won't try to perform allocations or deallocations from 
> > the same slab at the same time, messing everything up?
> 
> Ah, alloc/free slowpaths do use cmpxchg128 or spinlock and
> don't mess things up.
> 
> But fastpath allocs/frees are served from percpu array that is protected
> by a local_lock. local_lock has a compiler barrier in it, but that's
> not enough.

If those things rely on a percpu array, how can one CPU possibly 
manipulate a resource (slab or something else) that was changed by a 
different CPU?  The whole point of percpu data structures is that each 
CPU gets its own copy.

Alan Stern

