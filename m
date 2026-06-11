Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E08DCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 19:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805176B0005; Thu, 11 Jun 2026 15:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78F416B0088; Thu, 11 Jun 2026 15:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657486B008C; Thu, 11 Jun 2026 15:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51BE26B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:37:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F9D1A07BE
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:37:53 +0000 (UTC)
X-FDA: 84868642026.28.B212978
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07B99A0012
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:37:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="n3/FtI6B";
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781206671;
	b=2ZLt3RK3MAnXwD7MOVpcojz2XmdjRivLSiNadGuDqdwaN8lLUlysMbekDjE/LfkqPXOB+M
	NOzRMEYDwOqYtlLb1WvB6VhyVXf+lVjBgKdHn/h1/kwlfpmfV9A45kvmDGuusJ3T3TAd9w
	nceSuDMzuORYWIM9THjGOnd0sm5v5PY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="n3/FtI6B";
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781206671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJitvU5xfaKwDhhPD4oSV3hFuyqY6F2GIa31aftsKS4=;
	b=7VeCGs4Za2HxWQvOWlVo4eq4OW7kLqKUkWEoalpT/Lka5F4cVNkDeSjg8Egrgqq2ZMjc1Y
	caU+WSBbx5yqSndbYzPBXneTIaYzbRq0miNEb/8dnkFOE1JrMLL3w+CfgIqDyfXGmsOnbg
	kIINwG3UI7QwrP1VHkBpU1Zu3kytRfg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NJitvU5xfaKwDhhPD4oSV3hFuyqY6F2GIa31aftsKS4=; b=n3/FtI6B9mXYdppI5R3zmw5ap7
	jvLiYCJtM9oYjMUjAOdi7kp3HOeb/++TZtR0i8Wr0Mh5j85EHp4M0GkEWsDRnK8dRrrgLAeSnV5HX
	wV7fCdImAG5OE9VLs4UAK+HLDTmuKlYCuiNR3RqDfOVu9udnajiEsvSQFZjEIESq84v39tDS07N1+
	44FzneOz80kU6DpmKtpkf06ZU5CjmhEWqHWkl7bZx2wLILo4og/M8rypZ7w1FCFCkx9o1oSR6C5A0
	i3+GprQBMByaBZxC3hOn3ap7haf9umae+iwti97Og9isscyfIilViOxiVXvEjXwoFfuZnaSXtFFpb
	di1bWy5Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXlDn-00000002TdH-3YiK;
	Thu, 11 Jun 2026 19:37:48 +0000
Date: Thu, 11 Jun 2026 20:37:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC V2 0/3] lib/vsprintf: Add support for pgtable entries
Message-ID: <aisOi1B0o5KYyaQo@casper.infradead.org>
References: <20260610043545.3725735-1-anshuman.khandual@arm.com>
 <aisJbeVVxxNuYxQ6@casper.infradead.org>
 <aisNjxHW369cbKiq@ashevche-desk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aisNjxHW369cbKiq@ashevche-desk.local>
X-Rspamd-Queue-Id: 07B99A0012
X-Stat-Signature: 3cghmsm97ssm1kgff5ij3q1hkpgc1k4g
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781206670-980009
X-HE-Meta: U2FsdGVkX19McfVhb3kAQ7U/sbaa1emdweItmbtEheMovYav3NDew6FLpTQxQ1OfExLliT+UwiZO9qJIBUUEAnwRryzDgJlKwkeZizB+Nw9s8VfJkA8feuJO6YzOnVXkTlw5dhK63r5GaiNzp7EdMDTiFrbB5pylwkWwdKUOZLhIRJA1qjtTjAkhOK7Q+SgB3SvAoKVYYdn3DPaiCCgAsZcWm7Bh9O56JJOZxfAHIMlLRC4KBRSD3utvY5H1ZP55dRPSQIVDYMVla5aPVxHUtAueHZQoOhYosElQ4zcrMAAfjQRAqejdgaIbKMl8zPi3gpB0TbI6yRVuTI/nxf7z39k1sk78j5n/wxnH3eplF/SBHEED0zwsMuo46sboS7XV+jUYbc7PWkNOAeSEqYBUqhdHoosI3FA8yqJWa8KHdawEdLvdUXD6RvPIdN09YNgSIiuG3eZxUKtOaaABzE6zCvKY32e6pHpJK73/Fk4SDTg1gAaUnzp2gUo7zYt1nRTnVXqO3Yad8AYslL23m5wPOuXmUc9KaazQI3+ATSOrmteNbryEJPyqMk7UTFz0NJQVYVt2CLszbC7AnA2RZlXIolpqdeBYjmmexv8bpuXuDcEg9ml9jip+0FJsSFpqnePfzDHWbZ7W10zUsCvBA894ERvkXtm/Td7sV/QgUEStpNBAnSGmmauKwN95BvJndRSJSQyKtSZGeKvbN8/5O4R5gC358eoEZ9Q/JxiPMEej6JQqOmfC53YZfX+/2tJgpIuJ3zc31VyV0I4pWdVCTRaRBUCKuq8slxqKHxzF7liQy1ixfEVx5NuAPiuyiYfA/Po0T84RzChynSr64ioxWyeHO8a7WLH9Gg3MFekJi+WRliquZSlssT9cvojkVWnsoQUzxEdKfAsWuah/6HpMhIoAUUyNawdCfr3aDJd6TWiq2e3PUtKpNovAx7LkgpuOao/mxS6NjhTWR1mM1sHrA+f
 2aH5aJSh
 ioQG2Jfmf0n6bPZnJy1Ca4gZJmr4tnqXHXvVvezQ6ZKlZ4E1L5dh9zw21abk3cEq4b8XTqcsQrE5BPDuVsBbzeCQ4AkfSTMtggsPuKLHtYyGuCtSlK3Pw/ZzfbERwSAwIKODelumT9QaPVpovvvF3L7JxQK6NYTm4oBC7rOYKd7jasLoSLLKO3uNzut8DDNyujoR1GaMfxFQhjKEjpNV5ADFW7Sd6PsdvZgtFWrHWz2/ZtzKD1A+W4xmD/V8mUR6h0LBDtbIfJsJcbHHoZdOkjVK8x6nSWk1lV4WkWtUQoi+eWjmkRN/1B110/InRUoiqMC+9mjXyGbufCaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:33:35PM +0300, Andy Shevchenko wrote:
> On Thu, Jun 11, 2026 at 08:15:57PM +0100, Matthew Wilcox wrote:
> > On Wed, Jun 10, 2026 at 05:35:42AM +0100, Anshuman Khandual wrote:
> > > Printing page table entries has been a common requirement both in generic
> > > and platform memory management for various purposes. Hence let's create a
> > > dedicated printk format for such entries which will also help standardize
> > > pgtable printing across different platforms.
> > 
> > You didn't address my objection here:
> > 
> > https://lore.kernel.org/linux-mm/aFQP8LzVMctf6XH5@casper.infradead.org/
> > 
> > ie there is now no typechecking possible.  So you've made it more
> > dangerous.  I reiterate my NACK to the concept, not to the implementation.
> 
> But this is more of a global question, how do we check the validity of
> the parameters of pointer extensions in the kernel? Does anybody go to
> commit into GCC plugin or so for this job?

I agree that it's a global question that it would be great for somebody
to answer.  But it's specifically a problem for this patchset because:

 - It's really easy to get confused about which page table level you're
   working on.  And hugetlbfs deliberately increases that confusion.
 - Different levels of the page tables actually do have different sizes
   on some architectures, so if you think you're looking at a pointer to a
   64-bit quantity when it's really a pointer to a 32-bit quantity, things
   Will Go Wrong (or vice-versa.  And some architctures are big-endian)
 - But on x86-64, Everything Is Fine because all levels of the page table
   are basically identical, so you'll never notice there's a problem.

