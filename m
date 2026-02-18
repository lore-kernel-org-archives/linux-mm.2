Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4D3E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E266B0088; Wed, 18 Feb 2026 06:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EBD36B0089; Wed, 18 Feb 2026 06:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EAC56B008A; Wed, 18 Feb 2026 06:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1FC6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:27:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B08B6160553
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:27:58 +0000 (UTC)
X-FDA: 84457353036.12.B56B705
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8BC781C0003
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:27:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s1MysdmD;
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771414077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsFxEV4P+LKXmedhnkVP2MzBuTaUdQtYYTNJtDkuMow=;
	b=HJ4eCwm7b7j+j9BPAKJB+aUQg0lO611slgY5uTJYYSJ6AI+jabWZyIEGQVbYyebAs3FBs+
	+kH/iBEvMbXGVFt9jY239Dg+3hP3a+7H/Tjg7f0to/NUj6dTL48089R85xK5Vwfe1vJ6+m
	KMbI1Ww63SdMbf19un61KBxURuqO080=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s1MysdmD;
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771414077; a=rsa-sha256;
	cv=none;
	b=Mwl25C1ehTwfl5PwELrvIzwiCeNJCabGP1U8x7Mqeej09xiY2t5HTOV6AEYvM6UnwvzlfT
	DcrmhkaqvtAUXOGdKeWDsbZ131yhr5xNLp9gsjsYBCpj+Y9VFVgiWgnppkMFci+io4Fqbg
	dCMq+T19OYUqGYasiNKlg2pjd6RE5yU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gsFxEV4P+LKXmedhnkVP2MzBuTaUdQtYYTNJtDkuMow=; b=s1MysdmDVjKqzTMoQ2H4afrHR1
	zXG+OjemQB6clLoA4PHhXIUSsqNjNh5RsVYaEd7MCjGPainW53GN3XF695S44EHPJUlAenGxzVdzX
	ke0DT3BZmDCfh9Xt+RBLbwUj6tXhVRenW8/HXfnds8+RfbxN0zmbN++W2pB7N34Lai4tqZMX3x0/y
	r59jwRIWiBwfie1k45UgbRMi0p9ixFCvg1bF8+SjP+yNl+Mh+KBehWuWeOYTvRjxLXS21YVPnjGYN
	Be0/4duHxUUweKGFQg6KV6AhYWNJ32BPxmOevw2rBqX36r0Yv41sUmNE6+mIE6hDfS8HwXU9fH7cb
	jlovR90w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsfih-00000005wph-3SbA;
	Wed, 18 Feb 2026 11:27:52 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6DCEF3004AB; Wed, 18 Feb 2026 12:20:30 +0100 (CET)
Date: Wed, 18 Feb 2026 12:20:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Will Deacon <will@kernel.org>, Gary Guo <gary@garyguo.net>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260218112030.GE1282955@noisy.programming.kicks-ass.net>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <aY9i8rbvnxdOA9DV@tardis.local>
 <20260217085541.GS1395266@noisy.programming.kicks-ass.net>
 <102c86dd6fb1a907b7138a437dee00dc@garyguo.net>
 <aZRHJ22UtG1YeBMj@willie-the-truck>
 <aZShEW2b9-71r18I@tardis.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZShEW2b9-71r18I@tardis.local>
X-Stat-Signature: yncscn4ja1cck1rpyb4pt6npn3ow6tbo
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BC781C0003
X-HE-Tag: 1771414076-490749
X-HE-Meta: U2FsdGVkX1/iX5Sm2X/nAwaAY9A3gS4TBGhI+Po869TU+iRZOUfan1b9rL/cWWGypa4t90R3NLY8PRblbz0D5vOR3Y4JYukFaJ/lkbyciv6uvzDLCwl012gxzPeYd3vEkQ4t6K6Savjwvtk0u9N309zq9ML8eHLkzs6C7amA1//y0sKnnvCDHIAi9HZqbToDxDGYL2RXftw5wwNX7dZ8hRfQOIpNk2BB3nIzV7z3+81H7HfJdWL97oFctSIv6ECHN/3me+Esvu7SGROc9/1WFVcXbseOijsVYBbae5jFHmTLLwMhzyonIWvExHM5l4FbpJszC5L4bz8V3723P7/jhGh1tLNzrKQoQTZytqRbWHYVwQWD7VaARpJm7BZcH0jymSBs6KIignp6XhRh+7EYYT4RQ6pLPI7zPMJGSRAl92rgXpVY/vTE+72f8JWml2PVn33S5KVFf7mIr+pVreDsh2a+LmP5DdnEkR3nET8WA0ZlsyK4qZPTt+oedzoZZPSahotoNSwpXCliXy8QnCOdG65rIwZEvJ8nA/jf6s0LLD+WVfw2I2oit2lXiCKsNPo21YbPwVMJDM8E/O8LIcErSDl4qNdg94xd/iv72chr+U5p+CwgMQC0rfYt2jJtnWTqsAL7kPuPoHgfptykSY4JXVBdwiwXs9gafnYZqPDJgP+tajHu04CiNHNQfjwzK/u99eIO6BTGsFMmWNzRmTZP6u/7GkI6Zb4C6ciVm4ftY3NVkBmsOSI56PWE9EI3OUDVph7O3mZxbmJKwNaMdVA55uIuy4AFG0YgGHUr6djPP2QXzaIk5YboW8Wkp7FJBYMbNJ3sZhaCiG/JSSNHL/MbZq+tzFAvGbxb1yO7hM6rraDEYxUOgLGS3wGP88J9GT9BjmF0t/Jo5qH6V9Ncsf8dig9cKGB2bJwxoEZ1mAlIne3jihXqA6AGZOtdtUsX0Vumy8omewQSxjM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 09:10:42AM -0800, Boqun Feng wrote:

> To me, having a atomic_bytewise_memcpy() at least clear things out about
> what is actually needed (at the very minimal) to have a concurrent-safe
> memcpy(). Moving forward, since the concept has been already somehow
> proposed to C/C++, it's likely to be standardized (we can push it from
> the kernel end as well) so we don't need to implement a concurrent-safe
> memcpy() for all architectures on our own.
> 
> Hope this makes some sense ;-)

So all of this is about compilers being silly, not about there being a
problem with memcpy().

memcpy() as implemented by all architectures is *FINE*.

The proposal you refer to is:

  https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2022/p1478r7.html

(as shared by Will on IRC) and right from the start it goes sideways:

  "But fences only order atomic accesses,"

This is of course complete and utter bollocks. 

No actual hardware works that way, so for the C virtual machine to be
specified that way is complete insanity. This insanity then leads to all
sorts of problems, and then these imaginary problems need solutions and
we're up a creek that smells real bad.

Can we please just 'fix' things by stating that *all* loads and stores
are properly affected by the relevant barriers. Then things like:

  https://lkml.kernel.org/r/cbbea9ecb994df975109d97a7756d73e@garyguo.net

also instantly resolve themselves, because the compiler just isn't
allowed to be *that* stupid^Wclever.

