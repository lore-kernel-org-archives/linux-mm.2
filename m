Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FB40CE7B12
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2B28E0007; Fri, 14 Nov 2025 09:31:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA3E8E0002; Fri, 14 Nov 2025 09:31:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0238E0007; Fri, 14 Nov 2025 09:31:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3678E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:31:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42D8958CC3
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:31:34 +0000 (UTC)
X-FDA: 84109450908.11.5656466
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id BC68C4001A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:31:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eu5r2vcV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763130692; a=rsa-sha256;
	cv=none;
	b=qv5adGe5y5RASvQWHwPUSLMslNLckkFaarRdpbWrIZWgPSqrJ65IOMB01tRNvkEvOnREN3
	QQeW3F4FvXaXQEsu6D9UdAaIdpe1YT1NFSPoxruNCJH8xDBL8I3v5pXeVpcEp/EqeFzSJ6
	5O4wAJHk13yGhAi+kMDegEDWp34su7U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eu5r2vcV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763130692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5VFwUmXfKdGpDMZrLo3TB4jp+aDIRrQNoJVoJJAd4w=;
	b=1PtoQi3R4S+6U1aQUe1X70AG1cIu0veoqF1w8qjsUxvnwDUYjC+92jRykf3snatKrktW3t
	udSpdsdzjxv5hHRj9f+6JIhIrKt8goDsMwsm0yNIuGOcMDmIDFrhPWZ00wYIoD4+LumVNK
	njz7WIjWoOW8/0H4zidixDNhJLin7i4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE819435DD;
	Fri, 14 Nov 2025 14:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747E1C116B1;
	Fri, 14 Nov 2025 14:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763130691;
	bh=+Sfw3CpC4KtuH2n86YPu3VBz9xerwngc2Muu3y5dcRc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eu5r2vcVjei7aEdI0n/wE/3+6SQCB2AibHQQGCyK+TLwGVwcQcIDQ3IHd0vICEUqQ
	 097+u2d0826Hddrb+qL3QZcpp34xh4Se33RYCJd9lpV/u4lndhcurnMxMUYVl04Fpq
	 C9eoLHwzUsZZxg9Au+4v6YUUpGj+M4L0uJdw+SOa7JwNwn8MTz+4oo/s9zVuDxNEay
	 mtuSnRi3CUxlo7URyim4L1nrREqqCYzMWAfaO+Dg+AQSwq0CMiym722tNzi/xZ8MIU
	 2AsCfIZigstyMMQ0GnkByNsReYrDFe4MKetNp8vieqDsPAcpcmngywY74p/YjC7nx+
	 wjzIwgkQixPEg==
Date: Fri, 14 Nov 2025 14:31:27 +0000
From: Will Deacon <will@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: Use frozen pages for page tables
Message-ID: <aRc9P7VVYP6cLMRY@willie-the-truck>
References: <20251113140448.1814860-1-willy@infradead.org>
 <20251113140448.1814860-2-willy@infradead.org>
 <aRYiW91uAGH02UGL@fedora>
 <aRYuHl4zKwcwWN7t@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRYuHl4zKwcwWN7t@fedora>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BC68C4001A
X-Stat-Signature: 8sk6hhgkp5s9rxudsxetstpynbnhwimy
X-Rspam-User: 
X-HE-Tag: 1763130692-201623
X-HE-Meta: U2FsdGVkX19iU8Vaw3U0uANTNUMye6ILx4Gp0tsWMI30yKDJnfsqOclWcB4OYu4Go4Q8MZakNWjamre+AhMov5iyTyp+UEV/JFE72UKCML1fTBOyB3TvrFuWc4G7jep3pjKeJl9nAQxlIEEsx/ZhH36m3Slw3t8OW7Gr9LYu9UHwbYbIQFQuyI+iUCj89CaIkNx8sE7+ohtiQZwMUiXrBNJkRjJxJMfXWN6MXWCBDWMVjUul+oNvDiQC4xlfJh5x7SoYO0Ezvo6lPhvvZll0XvjWzO5o8bLWlOgK8S94xBDWkapkgrOz7ig3LGIWzr5h5V+DaRoiRMZ0sqZ0KcukdTEQYXkbG8lPseiRB5w1bmU5LJdhB1x8on/zsbec4KkvW1Ld9tBM0eWOBe+rT0WDVp1Sg99kY48Jr2UAeTs/v/zP8sVnnb+hlfAWS0G2BTBtcuxenBuWeorG6ydNUVo+toQITFlgvqs95eB74VzcAD7udh1ZxWTjP2AvOZz7lYMEUicNF8kEaxpKCsDG7YxqBQE4C4bGesvv8UhNspBtZNqzXmxINVHI9IAnGg8pvOzGjk+sZ2J6PPpgFWBnLXXhO97lPK6V9pnG21+I0xilsIeM3Czzu4+2tPOj3HnrIj5utqheuTXa3S4cSrmSuY4CGh7JkYERprYJbPcjftOEGNBGQ/rKdj3/rKc0c2d7BNiboMEaQF+pQ21pPS1SYlyuBnfTrc+q0Ws2hdeKuXMmr7LkqgiZ0KV5YxlcNDX7jyXvhL7mO8PYKIwR+AAwijvfJo1fnATAIzjda3JfEx4DG5GUm0pbDVe7c/Jtj6c7lAiqojYPo14Tubmo6QXnmMAaoWJm8nuKhEBFCXkbXuvag6O8sv8HiKmoyv1CQDKemb6jcL8aOPbtKWvQUqiisyJ7MNjvUZE3507VOSP+JoLYnKcT2Ve+GdTavCukFdCO5ThEPKtWI0qjzwszTHVP6+a
 u45rcRQw
 jkWPLbEyiTpjIh3zRKXvzkTnszQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:14:38AM -0800, Vishal Moola (Oracle) wrote:
> On Thu, Nov 13, 2025 at 10:24:27AM -0800, Vishal Moola (Oracle) wrote:
> > On Thu, Nov 13, 2025 at 02:04:43PM +0000, Matthew Wilcox (Oracle) wrote:
> > > Page tables do not use the reference count.  That means we can avoid
> 
> While looking into the second patch, I came across this one instance in
> sparc32. Commit 1996d47a0db ("sparc32: mm: Only call ctor()/dtor()
> functions for first and last user") decided to start using the refcount
> for something.
> 
> I'm not certain this code should even be using ptdescs, but theres a
> page_ptdesc() call in there for now :(.
> 
> As far as I can tell, this is only a thing for sparc32. Cc-ing Will as
> the author of those commits.

I'm afraid I've forgotten most of this as the only reason I found myself
hacking on sparc32 back in 2020 was because I was reworking READ_ONCE()
to operate only on scalar types and the srmmu code needed some surgery
to make that work.

However, from what I can tell/recall, pte_alloc_one() ends up calling
srmmu_get_nocache() which uses a custom allocator backed by a memblock
allocation from memblock_alloc_or_panic(). See srmmu_nocache_init().

Will

