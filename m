Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45690E81A44
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 17:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6435B6B0088; Mon, 16 Feb 2026 12:02:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61B5C6B0089; Mon, 16 Feb 2026 12:02:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551AD6B008A; Mon, 16 Feb 2026 12:02:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 438446B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:02:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 058681B55BA
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:02:02 +0000 (UTC)
X-FDA: 84450937284.12.4BBFEF0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9320E1C0008
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:01:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=a2+at+jG;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771261320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XedH1nC+Gj9W+WH0M+mfk/8Vb36OqwdxoYy659oyHsE=;
	b=Ac9NdJ7J2YW90zKGzRg7YigwXlrylHk/t/rgPxL2Nl9g4LqWd+nq6T+p81AlQ9fRBkSWQg
	9SP4xbveLvAUC+HIu4Nt2EXiY0UmBLQNfx2VGTCCzM+dZGgaxluf99QyQzqeDr8mRyF8bD
	yVyKjkEcbrQe6cIHylnM8HjICT5WUgA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=a2+at+jG;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771261320; a=rsa-sha256;
	cv=none;
	b=dk940muWwzxgyyUKMwgez9k7QlDq1sUdWKjhP+3lILpRlwdbx75jxyLSVm1MsvJqi9Olj7
	Ir7Wl4hH6YBPSvFeW/qf7vpbx/Y+TsW2GTboI347jwIapw7068H0LNXBLnWeKLYIsEbWpf
	D8dmR2zKtH6VmmKce6W1WmuyCj3eung=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XedH1nC+Gj9W+WH0M+mfk/8Vb36OqwdxoYy659oyHsE=; b=a2+at+jGiBxQTJbRHNdUByoufa
	uCPBcYhq+SK/7nn5tf81k9Hxm0qmMn6FKSr/YLhQdg1PC4aNGZPjJX5gMITLiiJHqivRP8B0CdpbW
	+9kVeS0g3VfjlBJ7OzAJaTVV9TYF6DrjfP/2Dt+F1e0dIW7W1grrkFUBsUQDJrjt9+AWnfy/0wF4l
	OTPUw2OHTOXO6I/z4Wii7qCnQIiSPhRxcZmGrCoFAHYaXNiUPyRMc8rcHUsnqUjkG2Ky/Ug7bBpAe
	K6HyA0sNoNECypjHQUBPtfUAkgdzHzz8znZlfY7WAZVPq2a7zILlSzJkTVJSatGhtczpNaWw93YDU
	AkWmewvw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vs1yp-00000002jxW-3VHP;
	Mon, 16 Feb 2026 17:01:52 +0000
Date: Mon, 16 Feb 2026 17:01:51 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZNNf_OkH-4DXDR0@casper.infradead.org>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation>
 <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
 <aZMEvl7WUKyxmgIh@thinkstation>
 <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
 <aZNJZTiRt_vm7oKq@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZNJZTiRt_vm7oKq@thinkstation>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9320E1C0008
X-Rspamd-Server: rspam07
X-Stat-Signature: wnwn8rigpozss6oiyka6qf7or6bihttj
X-HE-Tag: 1771261319-71676
X-HE-Meta: U2FsdGVkX1+xlfi4RwVz9xHsvaIiH3UBn2qoaUOsC9UOx/XY79Dmk1jxOJoDhbc/QtB1Zx2pZ+xkh4xTHgQZOsRt+wGtoN8D6GtYTcMbSsB26dQ5C7l3+uF1AytDmS0TDopd1FHiUdsZjD11XedQ3IyRWFvT8NQrDTaCH55vHdPTeM+H1Vw5tBqrA9EPyA0xqPR1+FftftwMj8vITWfCFWBEfswty103lFiS81/y6fYK4jC/q0CA3u44WhrrpUWxiITiyM1wI2F1cDejj6YQQCLSAnuDofcBKQdF7MPj9hlrg2g5eLJx3llTDn5/Rpgsk9INea8I5z1/IdGiDu7gVBBvK8LCMeRyf16c397YicpzWnxw9HLEAH9urUA6nkymq7cX3uLZO1kVC2/LUHkmEkIAlhzpqAWCr/To28M6J9px+sLa7y21R8G0fXqxwV0Irx4nA1ouqM7FXc8jiglfOZnxuFf3Zu+zAjqEHfMegjggZTQMzgEDkPuvFVH01g62yUn072R992qO8N2hqT0yrlrzm/oPPWw5zt5+W7yW9uUTT/MXSZPiuYKOIzjePzyhpVMGDY2Z8EHptIiQoh/KP5kyq2N6PLBy9eQxYsQWLBbpI2pyhbpaBC3SXYuKLuJ/TS+x1bZ9Fd7LbjwuHOk+nyThbfxkg3BmpHFbpPqLXq4fTM/PthbGP44oSsYFgTmwvvA43wpRVsXn649XPh62wBW6F79NIY/eucqt1BC9RBNa8M1dOq9l7AqQBsfy7dIub9/b01ZJsjJzNUEdUFfJUWy9x9QUwRxIU6qMbLbV023iJHNf43nl2Kq79m2kV/mMYGTaCsBzEJ6XeVkkdO00oeLF6YO/il/JdLGalsh/8Cm6ELjz6oG6Gv2PiAhLhn7dbq0YtwJiJoe4ISJcsmDwf9RhImrj6y/eUmNgzWSAcUCQFsZFp2gKMx2WBNyqsB9PC95tmcgK0xBVkKSev5L
 L/tqtjkQ
 8TVbXl4nNcpx1qV/o4Tob6HY62SFL5q/TTPQYt+z7QQmWZk7pAMC6uhycyqs8MjOTvQUumCUFHh6c7J+O0BI0Xt0jD16IFvLM36GSfsa4Ve+Y/u+PjWKbOrZMS+BjLPke+enEiV+nEfM1caoA2R2XrM9unyR5lJ9TKs15OmDjav0dad5Kw8aDEP6rv/lj+c8jzsxbmf3zVZptWv8vcQsmJbTppeV3aUNVtuEzrD1KaMyNDoGAFwXvZpRDsaHMTGtnch8w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 04:54:05PM +0000, Kiryl Shutsemau wrote:
> What I would like to see in the kernel is a syscall that return the
> memory stats in binary form. Something like
> 
> size_t memstat(int pidfd, struct memstat memstatbuf[], size_t n,
> 		unsigned long flags, unsigned long start, unsigned long end);
> 
> The syscall will fill up to n memstatbufs, one per-VMA. What exactly
> filled there defined by flags. The return value is how many memstatbuf
> is populated. The caller can call it multiple times to walk address
> space it is interested in.
> 
> We also can have a flag that mirrors smaps_rollup behaviour and collect
> all the data into a single memstatbuf.

But is that what we want?  Let's say a process allocates a 2MB THP, uses
12kB of it and then forks.  A lot.  Now all children that haven't called
exec() see the wasted 2036kB.  Would we rather have something that scans
(say) the LRU list looking for zero memory?

