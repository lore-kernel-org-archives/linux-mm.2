Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DDB4D58CAF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 00:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3B3C6B0005; Sun, 22 Mar 2026 20:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC816B0088; Sun, 22 Mar 2026 20:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E024F6B0089; Sun, 22 Mar 2026 20:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D22366B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 20:04:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48C925B150
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 00:04:04 +0000 (UTC)
X-FDA: 84575380008.08.FB6E5DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B733220003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 00:04:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qv6Jxmle;
	spf=pass (imf13.hostedemail.com: domain of ojeda@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774224242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZ7DOx1G79zRHUhJ9o4JHYL73lqH8FzGVTpS6L90wMc=;
	b=BfoZG1aIIjHXg3Omj2qq0Kr/vRLVURBiQ1bRViTnGPAkGSNHwTqpaBBvhEWanWB6Hq4wCk
	fz9BomglrEWn0N75NgoeRXLjlaw5IwSsVKwK4yv+34hMxnfpd020DPPsKw88IwAv3TIhEc
	ROs0YR+2LRKeR4w8IdvOHVGwjN0Zn9Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qv6Jxmle;
	spf=pass (imf13.hostedemail.com: domain of ojeda@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774224242; a=rsa-sha256;
	cv=none;
	b=hVOuAxxom4QCKyKF0iUn08rAuW6rhxjyEVGnj/akpBaHTTRhitkbAR0w1GcAs31G6HjsIs
	qXyiCD5dxJ7mBUxgSvk7wspCUal1H5JCIMJkduvCU0ok6Y4H5TQrhn2TS4t2tXYj+eNyQx
	rcWpDSaHVsX1bXs1OVg6pM6FA2aQMyk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E9E3A60008;
	Mon, 23 Mar 2026 00:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BD7C19424;
	Mon, 23 Mar 2026 00:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774224241;
	bh=TIx02c+Ao/gjEr9Xh8zmMJ4cknC+KKpUO0TYsvtJrYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qv6JxmleN9/FehBcjvyaVa1MkmaXr4Sv6DcsFlJ96PsdiyVC/3pYc+m9Fwy/RrdSG
	 k5iZa7SJc1Ft+h6UZKpE7yAG8OVAeY+4bKrG5ag2HU4QV8BqxvEHeMinl3wg76IP19
	 XbngVTWCPutXEd0vLUj4yiykgEMAB738SKwiuyl2eLDpHKdp6Dn+XZO24604aijCIz
	 vMZ00TvFd1eEU9/TTw62WquUyTwe31b33w4myELOF078ren7RgnzMj7AwOEOoJK8OO
	 He1JYHC23hpTrczCRcVKZKDqpyOBK3ynq1rAxPlCOxuKwamlGfrVspQwrE3ZP8XexF
	 uqm5O+jaQqgSA==
From: Miguel Ojeda <ojeda@kernel.org>
To: ojeda@kernel.org
Cc: a.hindborg@kernel.org,
	acourbot@nvidia.com,
	akpm@linux-foundation.org,
	aliceryhl@google.com,
	anton.ivanov@cambridgegreys.com,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	dakr@kernel.org,
	david@davidgow.net,
	gary@garyguo.net,
	johannes@sipsolutions.net,
	justinstitt@google.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-um@lists.infradead.org,
	linux@armlinux.org.uk,
	llvm@lists.linux.dev,
	lossin@kernel.org,
	mark.rutland@arm.com,
	mmaurer@google.com,
	morbo@google.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev,
	nsc@kernel.org,
	peterz@infradead.org,
	richard@nod.at,
	rust-for-linux@vger.kernel.org,
	tmgross@umich.edu,
	urezki@gmail.com,
	will@kernel.org
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Date: Mon, 23 Mar 2026 01:03:27 +0100
Message-ID: <20260323000327.111235-1-ojeda@kernel.org>
In-Reply-To: <20260322192159.88138-1-ojeda@kernel.org>
References: <20260322192159.88138-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B733220003
X-Stat-Signature: 3itf4zzhx86tpdn35onqwxxib115jd73
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774224242-903587
X-HE-Meta: U2FsdGVkX19/HkTaOp5K/NgA7w9/mJDnGqbA+nZ5x6fZQL4ddCAy3mydEZtxmr5tWfySu25rjRl/Pds9Q+x1vcYOc3Gav9t08FOXfqPnGQXyY/aJ1HaEQnD38jCEspW0tONgiSfHIB2z3yOegiI8g3F4w3hvw3r4BaC7ejPLupxdGDjDv7BQLrNSLs5Wo2bdwzvsq+ZQJUvggvG+3jeVwnqBJYsxFeJJlGlHh/yXH//49VpEPbALNi0+cJp2u3+s/NnPojK2rIuTBqV+Q1yi47BJvbT+7PJ3iilZzLUEVwK7PZRDqafKqZfRDsYly0jYzT4NfTMAQjJy2jaVylKDHp9wuQ3EZYsecI4BnBO78YQW4Y2bES99IEITdwJlkMtk8Yh+3sBbLhuXf3rTvgFLyaJ0euX++kOihXYV9nZBW+Cz5DzJ/OfQjX35SAwOgba5QZkbNalOMciyhDECNdhEF5QIMJJoyqskl2eLsMYim0P1Yh2x0YaB4SRmSlbAS0iGbew9uNG02RqXPbh+nJ7QgpZqeQyExVk3j0ZxWOFr1r7vvcS42jqNpV+J5C+/U09UTrQur1aBFsaYlwSrXnEDDYUcVl9dET6NCTm+0mUMUhtWfSgsBWVa7LZrXJhYIZNFFdImuYA6x1yw2kjfDcRC9jeNlckg7f7u53GE8O4n472tYxs1Ui4LakUQcYLYGyTHxzVspvtDvvzjJlG9ZAPIZbzG3I3ru1dloZ9ROJRJbGjgTHfP6w7QdKuShdXkgH0NbRKKuuPONo2B5koO8EPNARbE6Fjb3eGkbuSZtf6xK3Wq9P9Gw9cb6VPCnXmTIg5kQJ/BqctEuR/RtgqGBhQhjqdqGnhlwWtE5XuhejAWeP1nn9xK7Eyi89Gn0biKDPyK7si528WZ4/WdoKYAXz34f8DcbpcW1OVx06ikVT3TB1abHU9Ts+OT97Xt1i2oG8YBQaDtMyllBrp6s97LIch
 iPP8OD8+
 AKBv7Q9hags7M4ECJV2mGInRhzfxd7USV4PWsITIEjFTsU0SVzHbtwSXxxpfxM2E1wwMQ/K+ARxpWFd9kzuoZIN8u4H7AztP7oo0ac9omi5/Z5LmqurZ3OYSTmL2tJ2A8hpCaKW6uoaqG3XSIAPaxNxdx0xMBHOwV+d795/GAo2N8+m68gLEefgxnTAhwYGWgVhVMXRj6tx9aVjluztRUxaJZjbFb/JVNYN7PgjxGUmoDojnxkeMuYzgmZcRLumqc9HO4cprqYaCdztKdNr8Hx+Sh7awk1YN1/4lvMgLqf2R2+uL6I1xep6UmuJcNOQUbKsJpNmlPd8WGj0MpwWp0id+jJCAW6R6Fg5yJUeA13e2O4m9Hky9faMywzht9jtbZ0GXS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 20:21:59 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
>
>     On the other hand, regardless of whether we fix this (and another
>     issue in a separate email found thanks to the UML build), we could
>     instead add `depends on` listing explicitly the architectures where
>     this is going to be actually tested. That way maintainers can decide
>     whether they want to support it when they are ready. Thoughts?

Another one for arm 32-bit:

      LD      .tmp_vmlinux1
    ld.lld: error: undefined symbol: __aeabi_read_tp
    >>> referenced by uaccess.rs:349 (rust/kernel/uaccess.rs:349)
    >>>               samples/rust/rust_misc_device.o:(<rust_misc_device::RustMiscDevice as kernel::miscdevice::MiscDevice>::ioctl) in archive vmlinux.a
    >>> referenced by uaccess.rs:543 (rust/kernel/uaccess.rs:543)
    >>>               samples/rust/rust_misc_device.o:(<rust_misc_device::RustMiscDevice as kernel::miscdevice::MiscDevice>::ioctl) in archive vmlinux.a
    >>> referenced by uaccess.rs:543 (rust/kernel/uaccess.rs:543)
    >>>               drivers/android/binder/rust_binder_main.o:(rust_binder_main::rust_binder_ioctl) in archive vmlinux.a
    >>> referenced 36 more times

I think this reinforces the case that this is something that arch folks
should think about case by case, and decide if they want to try -- we
may want to start simple with x86_64 and arm64 or similar first.

Thanks!

Cheers,
Miguel

