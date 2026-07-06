Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 904ADC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 01:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2333E6B009E; Sun,  5 Jul 2026 21:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B4B6B009F; Sun,  5 Jul 2026 21:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1486A6B00A0; Sun,  5 Jul 2026 21:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFF6F6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:42:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4673EA0243
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:42:53 +0000 (UTC)
X-FDA: 84956653026.02.90256B8
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 11AB440008
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:42:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X6HU2VVf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783302171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fs3PDk+ICzT5JmREAjpkl1+i96EjXK1gwBqdT/2GxVA=;
	b=6GkXpTe7DL+iMvGbAdWYQT2BPfe55OZfG82/ywqdzeJxaJ9XLUeQs+AQVca4sqYTCh9FhH
	oEHm5Vc7yvoxavd0WTupbVHsMMLq9U72S8ZYnO2Qkh4pCngilUo/JHWFVh7m/IplGEgoJA
	T+/hMEs7bCr4tMQ/VVuVGiUmxpLRfew=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X6HU2VVf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783302171;
	b=wFpInmExHXHIWo8gIb49aEG5sUFVagfm+6Jn+ahPUHsJoqZ1vQhYXcuDM0NCa03ujcXzpO
	Mq0cpk3vEAGJ8WNyV8QGMi4ZAj3ugW0eL34aD61MnDcNQJGdJJ4TKyaIcw6iKx/E/ESfpk
	Yy4NG1nyIQP0DYso6n8mW6tVfO3m+Pg=
Message-ID: <b10aeafe-3263-4683-b318-2afd498c927d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783302168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fs3PDk+ICzT5JmREAjpkl1+i96EjXK1gwBqdT/2GxVA=;
	b=X6HU2VVf9Rmd+xYkCimrMRYONFxHlj1FLzMdWaDQIJ4CIisKe6O4ebHBhIO8xFtEpzsw1V
	if9clW5afwlt64H2wgInX7C2clZrNM4KB9RbhlwJBI4/bl5XISTBr2BGjRLv8fXIxd6+qZ
	HNfDAc3wBC6KybvkkcQAmn7/fpWtHpI=
Date: Mon, 6 Jul 2026 09:42:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Alice Ryhl <aliceryhl@google.com>, Douglas Anderson <dianders@chromium.org>,
 Gary Guo <gary@garyguo.net>, Anand Moon <linux.amoon@gmail.com>,
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20260703022507.187457-1-leon.hwang@linux.dev>
 <akhWKJSZLfDusVcL@casper.infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <akhWKJSZLfDusVcL@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fc6deeadycr6hqpg5nfdemp4kys7de7n
X-Rspamd-Queue-Id: 11AB440008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783302170-449685
X-HE-Meta: U2FsdGVkX1/OHj2ZmTAFhb900IZFlmj1uly8EbInzzFGsR+ad96HE2cCfCCFpp44LANJScybhBMeRinCEBpGUfDtXbe6xhWVkyBXC7wDqeQKR976LYg4KrC75TxHhdciv6C95mPRPnVmv/+YUzdvBD4C/yvU+VaB4z4ypry0Fi6eMPgOlJBBy+K0G/su4AAmvem/WfPTt+42QtZ9MuyiDp8njWN9DRXUtizMIx7QAWlb8yLZHhReA/yIvSYKv9SvpRDcYry7jmdOFcrXNQHmLQfFcYLapnBEuc8yAV/MVSvQ+1+oIV41Y0+EoQxGkgmACFTtUbCP2eKKsqzqBYfBgh0/mYbXGudG0NM8KudC/ZgKtXujtqP0nI9Jhdi61WUAGY264RVGWRStHkIfd9mceFYGbn4Xa/AmyMb5aXCwJ6LJLFrhg34hu1zxWWrRnft8lt/kbG6WAY74cZ4Tc/HZIsDnweFYpOW644q3r+sSWY/bqcFoqfLT26xwG+4SGQ8U1pAC04VduyClDuuiG+/uHnFIjiO9f++Aq6VOJVsSaXfF2dk1XvYOWaNsgGZ4ROzKIy7lkaNQ9DZCYZS9vcLRwjoTGDLqbJZLqrJfj1dj2RODx83acJ04CcedqC8u6FoIOWVSt3AuLfZ4poSsvouXBwfJjS/p49mKls+Dg+l0nDmS58yH+GamUropcikx0tlK4ldCaNwTBxUYQyD4fny5emNwaZfZ/R86edoGgktv2arLiJlIvXB8aG4AlSFKA1mmLgEiVVSwjWOXJop1YtaEIPf8wPIZ5Ygf0eXLOV78HbcWjf/29uW7hRQ6yj8/fY5GiakJhDNpac+xW+Z3w6vB8iePfnbXnDV7yoBqY6ZGxvUefPMV4dHNSo/LfuwKWidaxB7D5KMkGFzA/kZ0yy2Dwc9BFuDK1UFBh8xqv8UVG80ShLsfS0+55XR5vAVgSIgbUII741zbTL+m6mQnW+j
 EIQ6SWRi
 22CJu2DmypRaAAF+pBuolUPZcjnkW7y65sbDwJcbEh+1/WELiYJH6JZOZgve4SZl+Qm3KONaWrNVJlwDyc2l5llrbpKpuKqUTp/BlQrun4sfTBeGMXXbunho+5MDhraC4m+kusNbTcz/fY882uBa7IZ39ysTPx3YTDmb3w6Why/ufYn6DGU/NdD33Pg4tby18jFIhozbWtOopO0OgMM0IKte9vDXa9kbtyIoJh9FIU4slQLEbzwB7VtmQ0VAJL4Ey8SXd2oj3KGtDkXXoboLwba5vUAPE7mKp79bZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 08:39, Matthew Wilcox wrote:
> On Fri, Jul 03, 2026 at 10:25:07AM +0800, Leon Hwang wrote:
>> Document the -EINTR return from mmap_write_lock_killable(), fix the
> 
> No, you don't understand the whole concept of "killable".  If a
> task receives a fatal signal, it dies before it returns to userspace.
> So userspace never gets to see the -EINTR.  It's fine to document inside
> the kernel that function foo() can return -EINTR, but it's pointless to
> document it for userspace.
> 
> This is how "killable" differs from "interruptible".  Interruptible allows
> non-fatal signals to wake a task, and then the task can see the -EINTR.
> But many processes do not check the error code, and so read() and write()
> (despite being documented as being able to return EINTR!)  do not do so
> in practise.


Thanks for your explanation.

Will drop the -EINTR documentation change from mseal.rst.

Thanks,
Leon


