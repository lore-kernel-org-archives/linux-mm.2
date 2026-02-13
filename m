Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23310EDF166
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 14:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC896B0005; Fri, 13 Feb 2026 09:13:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59636B0089; Fri, 13 Feb 2026 09:13:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65816B008A; Fri, 13 Feb 2026 09:13:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B22056B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:13:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F1798BF6B
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:13:13 +0000 (UTC)
X-FDA: 84439625466.17.1CB84D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D7C0920007
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:13:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eLm3Urb1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770991991; a=rsa-sha256;
	cv=none;
	b=CAwG5k1bHnGfm0W9gIxZzcSfM8EI3/o240E6qtA00RpyBSm74AT1NV9EqffmvoVhuTI7Qp
	QgdKn7xpS8h7jGTfPMTQpDq2Fr0wESeGGbeapSi1JyPL2Rdh/e81e9tNNBjJ0Bn26M0Mtq
	S5YHC685kwf8XFymLly31hU92tKLupY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eLm3Urb1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770991991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbQTqYmi0/HuhZOHAgeAnQnnRtWEUmeUL2q6+ROPMs4=;
	b=J5gZ/fmSAakEzeS8sflT2DSbjLEBhixKVBmgY5m6TXSRntLsGDhL7dkO0psj/SF6vNID1+
	cd7MvSFGuAa00qoq2DNC0aweevPV53f/Q4k3J22DJL1idniik1qM5gatJmK1Wq46YL4SN1
	5Oha9/HPJCRA9a2+0X99f3QyPzZW484=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A1456001A;
	Fri, 13 Feb 2026 14:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5EEC116C6;
	Fri, 13 Feb 2026 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770991991;
	bh=E2kq+60ChwvA0zSTCHAMAR4HYqeBWEU/apZzY6Mpj6U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eLm3Urb12yOsS637vvtPG/rLob73yke/aXkvuirZswy29Crhao8l3lE0m397Vu7vr
	 phoHU/BcmGYw1aZsmYKqJJ3OEe5R5EnAuWHHEMx1LEdDjWlezP+STMuLzZMoOyzvdF
	 33MXlveULyXP379dkkbakrTmRRP0XaChX7LRuqz6ciiJGFFcWcUurvbMyyWMJFJjmk
	 VZb+XQVnDJ4hPJQPclnKkpBLaPw8M8MGV4GHR4T+jmAIpzwjNABcEHZWGjaShfi+0l
	 SJ0ELaH7+yI1Dd8DwLzszHlt4xNnXOLGgppx1qMA4RWUBObXzMTAv9Dwq46P1OrUpY
	 fW4SnPXwTzwBg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Alice Ryhl
 <aliceryhl@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
In-Reply-To: <2026021313-embody-deprive-9da5@gregkh>
References: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
 <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
 <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh> <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
Date: Fri, 13 Feb 2026 15:13:01 +0100
Message-ID: <873434u3yq.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D7C0920007
X-Stat-Signature: 8646t5fpkpn7n39nru9sqghymjhbqedc
X-HE-Tag: 1770991991-521279
X-HE-Meta: U2FsdGVkX1+vc9uI7qplYtS45lQ+gfl7qfNWSAypPjVleawLhYUnwjWJDEIYfs60a7qqP6tBL21FKcIA2qPkTJCp1OtX1R6S4VG1FfOqtYV9JIU6GUbDSxHEp3vepC68xKHMrSyz/eGsnSPQuBaOoTTfiFSzDC5yMY4CQOvRM6lyd3rBR9FIv07VjivY3pHt0wF0P7eZjXt8+PO8jd4CVhAj5/96qNhh5xuHn2ZPoFs+bxRJKXJ7V+2sVNBz8cSVw4Xywc8VGWbv109THBnVu598yKViFCOoTPfDVps7PRTKJcWsatKKl8Q56/O1ShYE+taHoQ8swt1ZHZ4wGShK4pwWkXmcb4QJ1uW5yMKwRwuI7I/7F8BJR2QtadvWULlBvZZzAUmm6xRr5GxRKNbM+WSsyNlNELYpL0TPYXkSAZ/QBWhpSUilB+pv/DDuCQIAlb56TQtXnQnOWJna3jkNgNwM/LNcOxqvMvabkjkAdFfyVEMwAx+0ucvC4Rexj7bQ45ZlRpwVmOTmDH3inQjcZE+BTTA9e2o1lcZ/DMWEY2TNzN5GVUw4kwiJ+BxjMEnLKWHgULB0ORf6aDL6NQMy60Ho2IXFfuzUfyTJvw7I/wqNZEdVmbIETeTQcsNKKlDQBQMqfqTzhxliCmFHIgeuU/os7XzmbsOnVYt0XJ84RCOW/4N363IpJo6MG2i+t//7YOXeDnYr2f34Z8WJkfR27LUqcIbP/ZBxBmbWP6yW/qZqr+s3WGeXDAyTHCRSU5U8GbSzc4icP8z675vfIUhJKJtTsmi3z0W40hk7NfBG5quW1ih1knZRpqqtbPfZdrV/Fz5qgK4byBsJ1dQFwBUoAScxL7fDcV6N5DxZsChzeuR6BP1vkXvi03E7okX268g+OdjQjQALB/JQ9TUTv/I1c3wes1b6/K/4bYMBAiLZ62FHdhBH3IReoHWzDiF5o2C2ylbLW5r8AyWwFgfbTkK
 bgGQpiW4
 fl+q+kdqVysSbQG79qik9Q9Cddh/fjEOKTBIMj2HwZ+b5xJ6jPEpXcLWwwE5wK/ok3pL00Eu7lwgQpQO6JlwDNC1hyx0vFtZ1m/ARu1ATk6z1EdpkkTV83bWKY0SOsbzeSPCu5hEDmADwJ7NUTPf310jmij/suhIDl+bMWJmhefgiH00x/5WSYwQbEB67nTZRgGfV7fRJXiXRstXfDQILSf0b/GBNAnMYvPOW+LTShHbcySFj/rGaCBDrshHWgJsXMg+W53MDs/DIxQYaYl5qq88oC6l+S0zeXYmHyRjhvJNrmTiU7gmkvZ4pcSHHLAtfswm9qlhUSxhXt1ekz8fOT3hRRm4d8NoPj/OylpSDwHSuqKE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Greg KH" <gregkh@linuxfoundation.org> writes:

> On Fri, Feb 13, 2026 at 01:58:16PM +0100, Andreas Hindborg wrote:
>> "Greg KH" <gregkh@linuxfoundation.org> writes:
>>
>> > On Fri, Feb 13, 2026 at 10:55:57AM +0100, Peter Zijlstra wrote:
>> >> On Thu, Feb 12, 2026 at 03:51:24PM +0100, Andreas Hindborg wrote:
>> >> > When copying data from buffers that are mapped to user space, it is
>> >> > impossible to guarantee absence of concurrent memory operations on those
>> >> > buffers. Copying data to/from `Page` from/to these buffers would be
>> >> > undefined behavior if no special considerations are made.
>> >> >
>> >> > Add methods on `Page` to read and write the contents using byte-wise atomic
>> >> > operations.
>> >>
>> >> I'm completely failing to understand. What!?
>> >>
>> >> There is no such thing as an 'atomic' byte load, nor does it help one
>> >> whit against concurrent modification of the memory you're copying.
>> >
>> > I too am totally confused when reading this patch, and the previous
>> > ones.  Shouldn't the "normal" copy_from_user() stuff be used here
>> > correctly?  Why is anything new needed?
>>
>> One use for this is copying data out of a `struct bio_vec`. As far as I
>> know, there is no way to know where the pages backing a bio_vec are
>> mapped. They could be mapped to user space.
>
> And how does C code do this today?  Surely there's a function that is
> used there that we should also be using here, right?  Why do we need
> something different?

C uses memcpy as seen in `bio_copy_data_iter` [1] and in the null_blk
driver [2].

Rust has `core::ptr::copy` and `core::ptr::copy_nonoverlapping`. I was
informed these are not safe to use if source or destination may incur
data races, and that we need an operation that is volatile or byte-wise
atomic [3].

Thus, we build an abstraction relying on byte-wise atomicity that does
not race under LKMM.

Best regards,
Andreas Hindborg

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/block/bio.c?h=v6.19#n1458
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/block/null_blk/main.c?h=v6.19#n1162
[3] https://lore.kernel.org/r/aYFKbWfQmTInYy91@tardis.local


