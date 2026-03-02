Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1CD9EB3621
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120796B0005; Mon,  2 Mar 2026 12:12:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4D66B0088; Mon,  2 Mar 2026 12:12:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F130C6B0089; Mon,  2 Mar 2026 12:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0C056B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:12:56 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ABFFB8A6E7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:12:56 +0000 (UTC)
X-FDA: 84501767952.15.139AC8F
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C8BD1C0010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:12:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=WAB6LP5g;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772471574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NYeVLOSy11BGz8w/+PkZCxVtenIhIQDcWYxLFf6PHw=;
	b=UhtVWO490i9Oz1QyhkEnOlokht8cy/1HOlCdziIRmi128kB9VClq0xT3NawGiWljO/xxXm
	uaRztoN9YNiqWdP5MIH0O+pQSoWqQbpsFdish1hKjqqoPbobAQsKmmKsQKl8SU9jw7SB7Q
	159PnalB6RWKNwqNkhvthS0OXgaf7E0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772471574; a=rsa-sha256;
	cv=none;
	b=RA5WQMKdNqv8oqYvH0knOTDDg/mA2QsqK9n+WOapXyUgaywTzONQWsUQmdI+y85215MqbD
	BCEy6po14gmH4QjyRD6OXg2rETZGUuINmO644VDzs0olDkQ8ReyAzgP9mNITYXejTL06b1
	BG/4izY98g4N9t3kdMswrnv2fnFi/JM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=WAB6LP5g;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cb3825b0fbso451495185a.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 09:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772471573; x=1773076373; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5NYeVLOSy11BGz8w/+PkZCxVtenIhIQDcWYxLFf6PHw=;
        b=WAB6LP5gd6tRX/2BXN3uLDKhiEOxPGF7rgP4rPwqi6/O1u6fYv+ArnihUncxD1v8te
         k4JVubhFAD8P9vBEo7/vmGNGc3DgbR5SgELsX46UKaVVbp8Nvh/Lls1gWPZ2PE3PkXCr
         U7P2CXuu4eFQV6HyrLyLrdA0OD0s38Ymdz+xZzhIABtAGHFn+47qWsd0BcNLyaZt9APR
         Clk5+FnheDcGZA97uw/Wo98/l7I4fAypwd6CRn+NBuHXHbLnugA2CAVuaJnMxaqc7c3M
         hfv0an+ClQDIfxphXQ1zEFVht8HMe55FQ1j6bX8Isy25/IseKseY+75ILSdg0y18jNsX
         mAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772471573; x=1773076373;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NYeVLOSy11BGz8w/+PkZCxVtenIhIQDcWYxLFf6PHw=;
        b=D2dJudzCjm8S7p6G3cpb44TPYapsZK7HIWh2sp7FGfULnjWw1qFLOHfXS7n6EacPzU
         bWL9OFfVYf4/kiGUWSFUXjHALIqJtjkEh7VY909CDwZ6r7b5C1KS0LzjBNlVZG9MS2Mr
         tsSlHRboebGKY1nlV7UsnAVYjID5QgavYaEs9YxPRa7c2YBSdaRgVll7PQazW3/PoP2f
         CfVVXUMHG043JZdvEMKT8YmcjfCrf5hi/2i5NMVcdJV5rU3kWHHtx988jc6IFIKeleCl
         CujzWT+efa3eOalKGgyB/u8LTKQaS5eSwRE79G9mfC+WVvqLhnscShKDs8SbImZVz+ed
         wuow==
X-Forwarded-Encrypted: i=1; AJvYcCVElw3aNkQZobqkN+H96qAr4n4ctk/v4+HeLBBEq3SmXtBr5AiFrN1jl1Nr28NNRZh1HEW7+xZzWg==@kvack.org
X-Gm-Message-State: AOJu0Yz52QiTn5MUAUQBloYKARIx/VTtcF2XhG3R4vJytBstY5ORSVkh
	i7rUOjC2sZ0u7UXqDXL9y/JdBMpg20Sr8jctg7K45LCADOhBLhGq3nGz+QGy8Q40toU=
X-Gm-Gg: ATEYQzyNl9xxnfiLuD8/XLifjwVC8N2z9Aq4eKWyE4mFtZPc4zSPzAcSDR+ceBsk4I+
	8x3g3Ylmf4nen2h2l9qbPWPJqWtCCbtE1o0P+C4tq3CoOhytoxWQBn6/nhUtawHakvCgK1dT4kz
	sOFiw6Nq/LD4g/0oUVQUshdwWqGHDgvQlphUXERvuentwtqVN481XCT5jLb+nS9G9duf5jkOEzD
	n8TUr6Lpq2mpWdTa/6wi5tcMtHZdjxOCyLC4muQXq7gSpR98spRTowM5QrcteVJIzwh589g3BtS
	wx5sdcnqE1/VOuwcSt10RDKWz53C5YDs+lVnb81H1JpW8HbWgshsYflIVKlcO1bj2kX6sejrAIJ
	E1S6Y4bEYb3slevFw60HluClFdfsfi5Yr69TJAllPdN131t1a/4SIerAKOfSLnIdb84OkdqTnoS
	YDNHejixVJf3/o1ZttgYYpMgy5ZG1EubLd
X-Received: by 2002:a05:620a:7012:b0:8c6:af5b:d50a with SMTP id af79cd13be357-8cbc8de839fmr1760779885a.43.1772471573065;
        Mon, 02 Mar 2026 09:12:53 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c7374dd7sm112302256d6.32.2026.03.02.09.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:12:52 -0800 (PST)
Date: Mon, 2 Mar 2026 12:12:48 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Matthew Wilcox <willy@infradead.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/3] mm/page_alloc: effectively disable pcp with
 CONFIG_SMP=n
Message-ID: <aaXFEDw2jrBGZNm7@cmpxchg.org>
References: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
 <20260227-b4-pcp-locking-cleanup-v1-1-f7e22e603447@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227-b4-pcp-locking-cleanup-v1-1-f7e22e603447@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C8BD1C0010
X-Stat-Signature: ey3jzek1ppt7o9juws86pedukboir1qd
X-HE-Tag: 1772471574-462673
X-HE-Meta: U2FsdGVkX1812GVQpQMSA95AivG/x3mykN2c23vBj1moDJvy0FgtgmP72sEEhxmfV0F7RVK3LaczdLbRsrD6oLRFZImm+kuAMpSUtusCKK4EuXmXrTpVPiTFBwXxw7jHH5kQb5ZlnMuVPe8xIM1eoahlp0oAyHHbes2dyZJ6s83JbqLXFqB8KrxRhUh+o+vUhohhQxn2MIhh5wJ0I2p8rGV5ty7nIbE3zMcWAkQVgfte+0lTHeL3jo1Ij5BFhx/emrlcucGIxseWTzSGG8jb5CKL3Oxyauqar0Wa/Q2H+6iyOyYmTXQp7L4Pa36czqpX1fTa1nJRPQVVLVo/pQEuC8f8SsvSMj/DNhM39O44BAApTYu4sy9ZITSjii5gvralPjGWDnm4llSAtrCmc0+drFF+l6HfID6xniihvIM7kUZsl9G/fgRVXhVmtMGa33EMussDcVjvTqQAf3NdjpexqgzIeQVGdth4opSMBlVKXnTusn/3OdRNZbspQ8VPKD2+t7scS9sn0XyxSV4xp6ivZCiRdZiTkPEh0tU0cfjDxJr9LqU60yA+9R6hsgkN6z0X+f1yNTJTl7GCpif+8GHHrnUEBvDh+EpcLMpc/OTRNG8J9cFmr5EMUcxFWIdRCIQYdAPeulIda//lF73Jh5Do4HbVPEcQOHZAQ9BeS/FDKFU5pSuItGOTf87okdt9lcA7kNDiiOTeCEdyGSSfVFUNJ+kY6aGmRThshc92Nd8Cj74M/lgufcSQgc9sSt8LNJ5WZxdXJ0rYD8CMMgf6QTydkdYkEDnpCzRvErarPyiZR0ZrinG0+73o9NU9IqTjEqb9/umcxPjMSr2mTo+tIiWjldBQMPQY6/Ie7ebCU0ASsJu8KgaFRk1JhhmbHa4PQZj+TI52c9KqdRhaIl2nyNdgvJ/SaqqI6v4lhY0WJoISIjpZHmISWqJoYZ5jG/0wbGgI6bxC/IVB+CHJkE4YKl/
 H4NPtIr+
 bGlLYIpb7JkXQ6ZQfFu8xtuWYSC1DAP1RFrN3P23qIbCAfDBm6xsSgquOtK8Q1xZ2e/tXicSJymjxRW4VSLyc1Rkih6At7NoBVZsZlUZCkkBTXDSL5tCk3m1//YIeHokF7phc+vhgilfoE+T2v4Ndhwd0pYI4SP64FuwNtYPBycr8mjbaa3MN2r1DyV+It3n9ml6wdgdAwOhBc6CPs5ZUlqrQu8gv9BEUsLEptpEHWQrB4mtUJzywbKX2aX/G2ZFyWNcwD5V3RLXJ3fXQngKiyylrStBo1Cd/tSnJdnf/Zk407cA9ifOP+vHzJ6KPpzzK6FdGAV5mYU1H6MeFY37ScggpNAsArsZbmTOCq0O/TpHKJ5FoycaLCRzWTa1n7ig2+AZImHkZNIsH7EZ6mf7mCh6WvDu6Wz44p0aMHyhx8CauCRUgur9XgYWVqRWeba2+5IngApEf/3fJ9m193j+p7lj0sgiFpYEXFe3w3oV6P+NJ2sAFS8IbLGABIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 06:07:58PM +0100, Vlastimil Babka wrote:
> The page allocator has been using a locking scheme for its percpu page
> caches (pcp) based on spin_trylock() with no _irqsave() part. The trick
> is that if we interrupt the locked section, we fail the trylock and just
> fallback to the slowpath taking the zone lock. That's more expensive,
> but rare, so we don't need to pay the irqsave/restore cost all the time
> in the fastpaths.
> 
> It's similar to but not exactly local_trylock_t (which is also newer anyway)
> because in some cases we do lock the pcp of a non-local cpu to drain it, in
> a way that's cheaper than using IPI or queue_work_on().
> 
> The complication of this scheme has been UP non-debug spinlock
> implementation which assumes spin_trylock() can't fail on UP and has no
> state to track whether it's locked. It just doesn't anticipate this
> usage scenario. So to work around that we disable IRQs only on UP,
> complicating the implementation. Also recently we found years old bug in
> where we didn't disable IRQs in related paths - see 038a102535eb
> ("mm/page_alloc: prevent pcp corruption with SMP=n").
> 
> We can avoid this UP complication by realizing that we do not need the
> pcp caching for scalability on UP in the first place. Removing it
> completely with #ifdefs is not worth the trouble either. Just make
> pcp_spin_trylock() return NULL unconditionally on CONFIG_SMP=n. This
> makes the slowpaths unconditional, and we can remove the IRQ
> save/restore handling in pcp_spin_trylock()/unlock() completely.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

