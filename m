Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C23D3E9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035676B0005; Thu, 19 Feb 2026 10:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB196B0089; Thu, 19 Feb 2026 10:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06CF6B008A; Thu, 19 Feb 2026 10:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAFCB6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:17:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AFF01A061B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:17:44 +0000 (UTC)
X-FDA: 84461560848.13.4CD4AA5
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf20.hostedemail.com (Postfix) with ESMTP id 03D311C0018
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:17:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="gslqVXS/";
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771514263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCjIAKqryddsHbFGalV/RlHhxKplrqjevsHUZi32Bao=;
	b=tUJE9dRP5sjqlTaWP5IcWXSgzev4zvbmpR8/eOuaZwBZcALW422jCRt1xrvpWuE7tc3NsU
	5qRIOTFGF7GaUwj9wjv010u4X+xUHei3JGGuiseCsvuUtb7ZLwQyfTuOMnFFkqi3eXMD2P
	f/upsEuTIrpxyw9P7Magsp0A7apgZH4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="gslqVXS/";
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771514263; a=rsa-sha256;
	cv=none;
	b=QH25bRpfN+G3ZK7xUOSTd8r32rjhvpvrTu0cEHgNyEVbc9yIo/NwSwtwJ6I5UMstxjtU1M
	lnYj6CwlA/tbqlG/W+BoR6CGGRCHwmxlVCWPvAGz5eRd0l7DOQ9g/oBi3mZ3dNUl/iOFat
	CvLYloa3RyB6moVITYM7sCOWwjhlSz0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uCjIAKqryddsHbFGalV/RlHhxKplrqjevsHUZi32Bao=; b=gslqVXS/BOf1Ra4BuCed6sP0Ff
	SiZ6o0RIHtLX4h2MAnbUnjj9q323CIKTSi3BB1M/lSGllO6ff8KRj7cI07aVVY2GXJR5N10ZAf5vu
	bNRxKJY6Ofaejsqhr+SmnIwWkR6zzfE7GBCZcdaW0d1L0VokcN2NgqqjiYkk4R1SqJMX/KltNsESm
	sbvl8E9aQQA5NcSa6biLGr63OvCqfXRWGRWgL2IxX/R1Xb9nd2CGTPRb95dFbEBEOw6tNTqP3H6hp
	6YFAFDIX7l4SD10C4xhKhfu40nZVld9FlDRNvroVQmVaWtMQPwn+zJm3nhwgXsVHDILgKDNc4azPD
	Po0/MOCQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vt5mV-00000001RgU-0FtL;
	Thu, 19 Feb 2026 15:17:31 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B29DA30075B; Thu, 19 Feb 2026 16:17:29 +0100 (CET)
Date: Thu, 19 Feb 2026 16:17:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <20260219151729.GK1282955@noisy.programming.kicks-ass.net>
References: <aZcmlIF4bmG0twkp@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZcmlIF4bmG0twkp@thinkstation>
X-Stat-Signature: 68pbn93a94zrnnfxmptc14h3p177yui1
X-Rspam-User: 
X-Rspamd-Queue-Id: 03D311C0018
X-Rspamd-Server: rspam01
X-HE-Tag: 1771514261-759484
X-HE-Meta: U2FsdGVkX1+B93rArEvWpjKXVGWDvxGeHiO6MD/BgCvRnk6zHp3UuQ6eVWKkxiTqs7xtevZc7GqfOH3xdYMKNuJccrp98c9zumDJe6VViYVETtZ3akXZYT1rYpuxYDh5DERl+WiWfjg0SpokpvJYJr5j124XnUh62Kz23GJYKQzWv1FmlrvI++6UiPuKFwu31vPnJUHhAt46df208Vc4vLIcMUUHBBOfIq49URK1zObIWormeCWdA70A++pvGPI2nMYM/l5Hq5TCP9Jw3mVht9Xxu1ItF7ph9NlDdTxr+4+k8s1tZ0RgLG6N2GPEhNN41j4xMsxN3bOx2UvxWkwPWXDugM8pSEHA17wggLXaJGE/rsjdjQOATgEHjsA0/00aPOn4ca+c8/bDapcho93qGXwy5YGI3UU0eucbnQaAi+d2w3gVPJjkx9q0M8jMDruIo455ROKWd7Psb3YWZNFi+p9n5oW3ApeljOoaUpVaSwjhym6rVxlAeIaroQrJ057hk02Xb34lF9rvXTqs4NQVv3y+vPyGS5yA8w6YARzbz5ezqEWrZMtZJgyH7kXGip2f0YHs6XlG68HS3CcfwKS5of/HjtVtzTjI36NEWE3mC5eTqCZCy0z1vFY116M0orWWrL4K9qAOXaXk6NH8ZdL7C/8g2T3FOJI0+5Y0ixodr3V10xCohkziZpkNm+g9+m76SdNS7yQk4CWjTq5u9ScO5d2GwGXbvYPEDre708n10+s2UuB/SmwOMzRklHqDspYE5MWqnOCOmzK+s8nuVrIq37cKCJ5ossFL+uswiDVWPevgn8P/GZ6KzqR8VgHCNSSf9bfj9TC8ttbkXussto5OQ1lQOS/HcmwMlFUBJt1q47Sy//ETUHX3QHM+vhafkjyH98BrJrSDEO/NkARUUYFgyBe6dG9TagnmLkyT//42PsEAqwq/6Nt5mGx7lXUleDEXPn1d7tWVfS5FRggp7Ma
 irRkMsvL
 eOaqhxuamyXrjWDvjwoGz475XxnXDBpcigTLWfGwN0Y2IKwJIaWL9QSVdN9bNoJQ9Qekw+uHJrcDF5GUZPeJMjgysEpoZXxLCYl0NgSdO+QI/IRv7EoGOOt0/KfpDSIfqG1Qzx3KL8f9eedMKAqaWjFLnMcmDC+O91FTpoH1+J/jPPaPCeszM0El8mGJys/Cmj3VSpwg7cZLBmPvn/T/96AADmpRjKUqyEWo5SWZW0Mi4kGI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> No, there's no new hardware (that I know of). I want to explore what page size
> means.
> 
> The kernel uses the same value - PAGE_SIZE - for two things:
> 
>   - the order-0 buddy allocation size;
> 
>   - the granularity of virtual address space mapping;
> 
> I think we can benefit from separating these two meanings and allowing
> order-0 allocations to be larger than the virtual address space covered by a
> PTE entry.

Didn't AA do this a decade ago or somesuch?

