Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58030E9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AACA76B0088; Wed, 18 Feb 2026 03:38:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53496B0089; Wed, 18 Feb 2026 03:38:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934EF6B008A; Wed, 18 Feb 2026 03:38:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7946B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:38:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F127213AC98
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:38:04 +0000 (UTC)
X-FDA: 84456924888.12.33C5119
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1F4D40006
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:38:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="F14g/Dgp";
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771403883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8CmZLDj2c4oTROwg8zkd+DRY9MWE4RsnIDSCGPUZmA=;
	b=PosU9UHxobPUPdjYHbxd+WzBR9LNIY7/zSXiTDyAw5oFWghYdOytkL331KqlbOZ12Lto3m
	L5WFZLDFWeGhOPxSNniwmW0F46ZnJidHvUK+4GBda4ULE0FoZa3fU+D4MtfmKcvIn5MPx7
	Yq8DPxGdci8G/4Cn9M3RNXPgMMaBraU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="F14g/Dgp";
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771403883; a=rsa-sha256;
	cv=none;
	b=BrqAPm0zEsjLqSY3utpixm5sKBpFrqGaReXo/yBBeZLqhNTAyneop+vmawQon1/j7VqwK/
	DvOeIcMf1Y+oOzLi8w9xY8zyMHgIBAbsDBWVcx9J+cnZquvG4EIOyr2fISBZF6+wiCDO++
	nOo27jxCh4XVuRGUgjrk5PHG49H0oJ8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z8CmZLDj2c4oTROwg8zkd+DRY9MWE4RsnIDSCGPUZmA=; b=F14g/DgpWhhHTUrMIRAi0AfGfR
	CDePZyaBLuRkxxTUhgJyI2AXPJzQG1Iart7sHojddMLbunhcV3ftkFoLifgASVVPmQZ5CSYS816Ev
	c64sjvPL1wA9mr1kvDVDtrd0z6ZRm4Nougbih/4Q8RbyMyB2jOaSZ8fUIvAhXUUlrKwQ6wq/XgOG0
	9pu/LpAnZ4Dl2Kh8s+gRl4grIOXtkfHaF7qktSP3jPNwiwUIIrOBCTVJNzCRXj9fONsCcLCSWDMUV
	iWxeWfM7OoCS1/Q0A3wdvSgsCa5GxEBAo9RyWSWxdtA1GuCZUQs/nD+HsElCBtaHSZcyjwD3FfWvc
	fl1g+HzA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsd4G-00000005kvL-1s4w;
	Wed, 18 Feb 2026 08:37:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E2A12300B40; Wed, 18 Feb 2026 09:37:54 +0100 (CET)
Date: Wed, 18 Feb 2026 09:37:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>, Boqun Feng <boqun@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260218083754.GB2995752@noisy.programming.kicks-ass.net>
References: <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <aZRWOIPThLfIZ1Ph@google.com>
 <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
 <aZRokyTqsd_RwdkK@google.com>
 <20260217154800.GY2995752@noisy.programming.kicks-ass.net>
 <cbbea9ecb994df975109d97a7756d73e@garyguo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbbea9ecb994df975109d97a7756d73e@garyguo.net>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1F4D40006
X-Stat-Signature: 3ctjdjekqenngo396azrnfzxxtztqscc
X-Rspam-User: 
X-HE-Tag: 1771403881-393848
X-HE-Meta: U2FsdGVkX1+TYOGU7SlFz8tcKUxnI2fr9OV+1VMVztHbWdWvU6pSc5c1eI3+b+kB2QC67jPAVxZEikR9rJoBdjDZlQR7AjQXpXFVmKv9pw7tz8M3VkU8F+3pf7lKEe/BhCBRlyA44HPCi607gBwpXW5ILOWO9+6/CCV+HcrlYMhwoDAFlYicwQfFrtDOoHIFz6UkTPgXYKzY5f8aJRMI0lFSX1jrju5OLfkb6sQ73A9klVZK+TaW/WFMlTwizrrGyKL7K2Gn+HjONcaMUw/k7+KxK9FMvm7fSB0XZEokBhd2p0L8ERpViXMo5/RzlMi+DfQUpzSkaBl9pyWaW06GO0EDwKbu31HGESDfSYXZMaqSicSSSs/QZTcGhexWWaVVr2Vatt9vKfHc50r4Fycc5TVe0THZYrHgNItZDIqVdrzOPgNYy3mfHVeuLXXWb3SYFa1ToEA/FFP4zpvuTJns8etzow+Uvs9aX65XO9ywMLvjHRfmp/rQCGTzcuao0qEu84puQqQdJ48yjQKEjskR/azJ3nYDybpoKfpqXiHhCMvQstIAJROTORoPmqlaeR8E1CdFkggjOHQnzsVaVDE15U7phfUxCTbfMflD0cGCJwASQbY4nv01fQl0Tp9ZmmFGxVoLent4/Gi46UtH8RkIq0K3f3O6Bw9OEbJcofO75EvopMINShUrYM/5M5yoE0urKeydy/e4pJXLSTidzZiz0JEV8AD4xAYEK78m1G9OUx0BVbidAa9ZRcaKnPmgrJuy+jwRqchwKtqmdgVJW9wGuJAlROspyApLy5p+48KzgUOkDwTxFaezNxmd6yA/BcKyySDSmfW7PovSqcZ6cTjgksuzR6C7tSiYsVIvyHr/G+hxgnCZgLln2V9yKXoDXJGPXGdJYNwtPRjz9g9Q3UR4IyZFDaCk7L/hOJYJhNQwUc4K8Ao3UKkVkg7iu3Xv2saG9lgRzKvzHGUND4Lvloh
 aU6seeB9
 ecJX8hy7oizuqUjJtemf+t2AKSk3cXccQHlnDWfckHSd5BSHhohusfSqB8AXxDiweZ4H7wzfHNOyUMwpwXrygERcjYOSpJDvD27f+uYqM2K8bSoAHsS4fy4c9VOHi0v1+Vlu6ffD50C2dRkL0fauvdPHwlD2LE8KkcuTACMhfRnjs2I2U6omk+T3GN37w4wW4mpaNczUapuyf3S5V7iBxZKrxvVNugQjZ712+88cC3G1uMvj387dNdLSYnJ04cFkK7eIqaj893PJrlAz/ku2KJroq9hhdk4BhTG55
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 11:39:18PM +0000, Gary Guo wrote:

> >> Are we really good? Consider this code:
> >> 
> >> 	bool is_valid(struct foo *val)
> >> 	{
> >> 		// for the sake of example
> >> 		return val->my_field != 0;
> >> 	}
> >> 
> >> 	struct foo val;
> >> 
> >> 	void *ptr = kmap_local_page(p1);
> >> 	memcpy(ptr, val, sizeof(struct foo));
> >> 	kunmap_local(p);
> >> 	barrier();
> >> 	if (is_valid(&val)) {
> >> 	    // use val
> >> 	}
> >> 
> >> optimize it into this first:
> >> 
> >> 	struct foo val;
> >> 	int my_field_copy;
> >> 
> >> 	void *ptr = kmap_local_page(p1);
> >> 	memcpy(ptr, val, sizeof(struct foo));
> >> 	my_field_copy = val->my_field;
> >> 	kunmap_local(p);
> >> 	barrier();
> >> 	if (my_field_copy != 0) {
> >> 	    // use val
> >> 	}
> >> 
> >> then optimize it into:
> >> 
> >> 	struct foo val;
> >> 	int my_field_copy;
> >> 
> >> 	void *ptr = kmap_local_page(p1);
> >> 	memcpy(ptr, val, sizeof(struct foo));
> >> 	my_field_copy = ((struct foo *) ptr)->my_field;
> >> 	kunmap_local(p);
> >> 	barrier();
> >> 	if (my_field_copy != 0) {
> >> 	    // use val
> >> 	}
> > 
> > I don;t think this is allowed. You're lifting the load over the
> > barrier(), that is invalid.
> 
> This is allowed. Compilers perform escape analysis and find out that
> "val" does not escape the function and therefore nothing can change "val".
> 
> A simple example to demonstrate this effect is that
> 
>     int x = 0;
>     x = 1;
>     barrier();
>     do_something(x);
> 
> is happily optimized into
> 
>     barrier();
>     do_something(1);
> 
> by both GCC and Clang. The fact that the local variable here is a struct and
> memcpy is used to assign the value here does not make a fundamental difference.
> 
> barrier() does nothing to local variables if pointers to them do not escape the
> local function.

So how do we stop the compiler from doing this? Because I'm thinking
there's quite a bit of code that would be broken if this were done.

Must we really go write things like:

	struct foo val, *ptr;

	ptr = kmap_local_page(page);
	memcpy(ptr, val, sizeof(val));
	kunmap_local(ptr);

	ptr = RELOC_HIDE(&val, 0);

	if (ptr->field) {
		...
	}

That seems 'unfortunate'. It basically means we must never use local
stack for copies or somesuch.


