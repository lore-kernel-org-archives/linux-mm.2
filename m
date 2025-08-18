Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D426CA0EC6
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 11:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A876B00A7; Mon, 18 Aug 2025 07:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72D06B00AC; Mon, 18 Aug 2025 07:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88226B00AD; Mon, 18 Aug 2025 07:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5EF86B00A7
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:09:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1459283D67
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:09:42 +0000 (UTC)
X-FDA: 83789607804.30.CAC6995
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E2EC1C0010
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:09:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=he214686 header.b=BqccUWui;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of linux@leemhuis.info designates 80.237.130.52 as permitted sender) smtp.mailfrom=linux@leemhuis.info
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755515380; a=rsa-sha256;
	cv=none;
	b=QlKZBRWv9RXNkJM2aPbllgxZtXXIRakCL3SPbIS8hIpm03AapysxxzRX32XHwsNv2BsSjK
	bu07xDABy7gT8IONYIH8Kwzoj9JN3vqOAmamSasAYM2ZjW/GKh5bFfWJsJ5+m5YHPxwINR
	Y2+kefOpG9kq0g04XfUK+7s9ch02E7Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=he214686 header.b=BqccUWui;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of linux@leemhuis.info designates 80.237.130.52 as permitted sender) smtp.mailfrom=linux@leemhuis.info
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755515380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPFZYYIEmOz63qGUOuLkE8hJrm4tJL5wiFLVGzeYuqQ=;
	b=JvbCx0K1Uu3Sw1LmtubzsxWGkXJu7JfRQxDY0OUzhJtkoiXMYRn9QLj7aXoM+5rkKpKsKJ
	sJyqlEFfdIS+rJn6exPAXlig68H5tQbr4DHhPIe0uihRFBl/+1yVZ5ms2+2LzGAOYneLSW
	PxlHDbOvpun68RmzRizUZHHNSb1Fdbk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=SPFZYYIEmOz63qGUOuLkE8hJrm4tJL5wiFLVGzeYuqQ=; t=1755515380;
	x=1755947380; b=BqccUWuiuHx2owCeOMbYKbqCXADF3KHW+Du9tA4i58pxK+rEhH11ORqhUtKA7
	un6qzL8nsCZO+z6KahPZeNTkKG96FGuEm6WwkvKivH+z/WMD7yS4/4y68Zim2GLJJ7+C+3lBCM+t2
	x7s4eVlt+scbl/alAy4Jk9lQ4NJjhYb4ANiCa10xaRurF5yelpcpSQNyMffnCzQD1k6vr018zt3By
	JF5zn50T3j+EpqsraAvcNGjQ/bZjzsqHKemmNRhrdbh3bgDwFu0vToc2c1cGquPXwDK03ioQ7AOg2
	py1CV4mCkDnGP886eMKTLF8WA8lFE+fpW3qdZSSEcuHNBl6Icw==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1unxjz-00BrQm-21;
	Mon, 18 Aug 2025 13:09:27 +0200
Message-ID: <8aa05f08-ef6e-4dfe-9453-beaab7b3cb98@leemhuis.info>
Date: Mon, 18 Aug 2025 13:09:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] Take ARCH_KMALLOC_MINALIGN into account for
 build-time XArray check
To: Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
 <DC38NDRET9NB.31UDI8FHB7WAY@kernel.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <DC38NDRET9NB.31UDI8FHB7WAY@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1755515380;be6c13cf;
X-HE-SMSGID: 1unxjz-00BrQm-21
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E2EC1C0010
X-Stat-Signature: zcdige57ynbo8ennisnyrrou787d8bbx
X-HE-Tag: 1755515379-248874
X-HE-Meta: U2FsdGVkX1/WbHjb+fAB5xH7Gf/sN6IHgQY1zeVTDfE/n3HkaD6C/SMPgHyosX4WIvHBi6NDAZaJPOqg3ZWw+PiHJB0F13FfdCSQWJjqI9fZryhlo3Sz+gs3I3bexZVA8VoFFUzw63RtSfLNBwAdN/Dn0imiUVFYPPnl7e/JdLLUhzNFfyl9rWVoPrIwQ9MBU/UMbtV/fLYr12udtSSr7Y9hxgMMlpf9PjVT4KZuoNqtfrOEgHklWQcL9n+TKHHJvw4+KW/AXn9OpNql5vFrxm9YkJTY0fJJH9lVSIbtYT0RQ6ymEbwoZ045f0coZSCaZE8JUPSitFTjnYh4f1bH/Tiy/iEN5v/tleyXXzvUSMwMlBwuGwtUVXLCo233z6UO8CKpcIxXazgbcACnCSYUoIlWN8lOV90Ln6r99gAvKeWsSw9WGCdcuievrJ5XLXAzw8HC+ctZDizZUZfC8YIbAX0KNGRWvVhWpUDCN99zdYOVWAghlU2fO9IUr4wFcoAXzmDB5O+fKC5E9HrsdmplWQyJJXUALKbNb9l7O1RFWgcX3s+4mUw+yqJrzJK4p5Q+adrVJCFGQp4FtOHDcNH41TFPvMhEjxBKGMOQ7XgufpvTptrl+blQbqXxZiVbsVhXYrqlirEvfcpFDuy2sFokJU8Zy0kJY34Q1ruq+CzYYObWF/UpauF+lt/vPY2sNG0rzKWczgFQ+GkTZVi8QWG/PfEMSqe8qqCWBTsTtF+e/OpHSCPV3ZVj8bpRsxZI95vo99KHraGXSc/EN8dRtOOqb2cc24pOhLaaV230OEwd/iJowEySS9fzXn5lFsPW6w40Z5DAnskh+MKANU/K8FmenUKJ1v51L6QUehmAj0UCPPgunsRx0iJ1ask72MfM9x5VnCVcu7Smfb4UC0kjelv9dHvBDRknBV3QNK483Qylk0HIk/MQUQy9ileKv0PEjbUkPrcpg+XhYW8EYhb/XU8
 CddyXdSP
 1S8wcaZs0LqkdoMLPxvhls1b4/vMcsKikfrc6LLhtB+HqbY77snIv7iotAjpyVeZ/hVGZiS8KPxexLgyu8YrSj/0y2vWxPAn/u29tiQ7qI8S315ZQM91Lh0Y1c5ROEWm+8ohPQlxyHSGSaYhUaFm958l+vWZijgQWiOkntEPlF5vPGWZdTVBQFngoYt3/oCjtKrc6n5pgeWttFtkP5qHF5oZHJ/HAfCPeyxDDP/yBepb4/VgG0yTaFPKgShQPbTBY/b0Zk62co+bN5XcN+mS/XmvqQPgpkTjV5ba8DKJonYe/na3WE+MwSTagtduC53xMsltGYqyF3GIsYY8qUzrfqjNuiBjlu+/sJyA9zvbdqWhgFcQIb5R8EfJR3rQrEoEyBDiif8V/oIAx7YqKRZSoiW9EXTMpahpfi+SBqYygWGukPfvhEliahxVUVMRSg3V0BkyX/6ktvawwJbB1xgf/39sorPL03J+mWyGbqHAPeLGpgdvC5jpsKt7AUUHoHG+rw9IF44yD5bYN798=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 21:12, Danilo Krummrich wrote:
> On Mon Aug 11, 2025 at 2:31 PM CEST, Alice Ryhl wrote:
>> Alice Ryhl (2):
>>       rust: alloc: specify the minimum alignment of each allocator
> 
>     [ Add helper for ARCH_KMALLOC_MINALIGN; remove cast to usize. - Danilo ]
> 
>>       rust: alloc: take the allocator into account for FOREIGN_ALIGN
> 
> Applied to alloc-next, thanks!

I had a build error with my daily linux-next builds for Fedora (using
the Fedora rawhide config) on arm64 (ppc64le and x86_64 worked fine).
From a quick look it seems it might be due to this series, which 
turned up in -next today:

"""
error[E0428]: the name `ARCH_KMALLOC_MINALIGN` is defined multiple times
      --> /builddir/build/BUILD/kernel-6.17.0-build/kernel-next-20250818/linux-6.17.0-0.0.next.20250818.423.vanilla.fc44.aarch64/rust/bindings/bindings_generated.rs:134545:1
       |
9622   | pub const ARCH_KMALLOC_MINALIGN: u32 = 8;
       | ----------------------------------------- previous definition of the value `ARCH_KMALLOC_MINALIGN` here
...
134545 | pub const ARCH_KMALLOC_MINALIGN: usize = 8;
       | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `ARCH_KMALLOC_MINALIGN` redefined here
       |
       = note: `ARCH_KMALLOC_MINALIGN` must be defined only once in the value namespace of this module

error: aborting due to 1 previous error

For more information about this error, try `rustc --explain E0428`.
make[2]: *** [rust/Makefile:539: rust/bindings.o] Error 1
make[1]: *** [/builddir/build/BUILD/kernel-6.17.0-build/kernel-next-20250818/linux-6.17.0-0.0.next.20250818.423.vanilla.fc44.aarch64/Makefile:1294: prepare] Error 2
make: *** [Makefile:256: __sub-make] Error 2
"""

Full log:
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/next/fedora-rawhide-aarch64/09439461-next-next-all/builder-live.log.gz

Ciao, Thorsten

