Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0DD9EC01B8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3CF86B0089; Mon, 23 Mar 2026 06:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED8D6B008A; Mon, 23 Mar 2026 06:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCA16B0096; Mon, 23 Mar 2026 06:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB9FE6B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:03:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DD011A0AF1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:03:55 +0000 (UTC)
X-FDA: 84576891630.14.19BB889
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2846D140010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:03:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=0YF0Xiuw;
	spf=none (imf09.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774260233;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cz+j7B7EZWXqL1NEdjNkb8+tqvgFwGtEmQlc0a4uF/I=;
	b=2DNExFn8hN3Dm7yc/YUr/2nBTGNqWe8SvEN9x6Dy3LvFVmvUBu9lj+gUEB8ZXX3pC4riYK
	JONUkKHsaK1t94Sso+ntEFKoMH7XDCEz6Kb3F+W704oO6vBh6tn6P9A97meEip41Ptu27E
	BToRA8do1vFIoNm7qiS9NOORtbuz6Ng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774260233; a=rsa-sha256;
	cv=none;
	b=sKUEisMg+SsaY87bW55o0dXpq0tVivSnL0AGLUMFmX28EsfMio6ALZMinjxggcRscvZoGm
	dMUJwvFn8IJTGombvDt2R/TAyXXlNJkg1W5aqHXfYz60TDAZpxL2SZiIWig+qfFN5lQjf1
	txUgPIjo4/MggpIrAMN9kx8STOkxC6U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=0YF0Xiuw;
	spf=none (imf09.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Cz+j7B7EZWXqL1NEdjNkb8+tqvgFwGtEmQlc0a4uF/I=; b=0YF0XiuwT3u8tR4oPMYWEV/KFK
	H9fwrg4T/+n+RJ03PpS/Fav/FeJLLU7KVNxg/rC1jqK+w+LeTgzBtMY5uSRpKHO0wDv+X6cxP7NiC
	m75SRUqkIW5e3TcIYnU2V/9uxpyA8Sc/j0NWipcGGGzkIgVZX5Q+p4QRq+XPer8SHbcl8QxCKLAjM
	+YmYDZJz5gc2FBjWWOLytVpK4pbu5cpv+VXUz3RUGr/wvAMjrH6Zo5aYlwvQ2q7xNgwDr/8QYZiUW
	W9lgLx+4dBjuEbKoTDvDCm6znHsF6AcsyhR8Ua14v4nYL8zIAC5TUrwz1CHT9EOJzgzdxIrCwHslC
	8tWM9ivQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45792)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1w4c8C-000000000IN-2POJ;
	Mon, 23 Mar 2026 10:03:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1w4c86-000000003wH-1o0a;
	Mon, 23 Mar 2026 10:03:26 +0000
Date: Mon, 23 Mar 2026 10:03:26 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: a.hindborg@kernel.org, acourbot@nvidia.com, akpm@linux-foundation.org,
	aliceryhl@google.com, anton.ivanov@cambridgegreys.com,
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org,
	david@davidgow.net, gary@garyguo.net, johannes@sipsolutions.net,
	justinstitt@google.com, linux-arm-kernel@lists.infradead.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-um@lists.infradead.org,
	llvm@lists.linux.dev, lossin@kernel.org, mark.rutland@arm.com,
	mmaurer@google.com, morbo@google.com, nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev,
	nsc@kernel.org, peterz@infradead.org, richard@nod.at,
	rust-for-linux@vger.kernel.org, tmgross@umich.edu, urezki@gmail.com,
	will@kernel.org
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Message-ID: <acEP7tl8pqFA3tK8@shell.armlinux.org.uk>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323000327.111235-1-ojeda@kernel.org>
X-Rspam-User: 
X-Stat-Signature: o4gb73hsd58g1ta5ej3id3sdfscp9zwn
X-Rspamd-Queue-Id: 2846D140010
X-Rspamd-Server: rspam03
X-HE-Tag: 1774260232-85594
X-HE-Meta: U2FsdGVkX18rRlrmcPVmf+fFYejB1jOnDZ8xq8/oAWwsmgoyKHBFxCNzHAiqOQEyxkwLkw/BzSRVARtXFLCXPGdPaRPDeU/qRyruq8qbDKzW1a5+w3vah9jv0j6AUOWKFb2iU3/zfDpZxH3Jyf5j/qJd90dGi0rxgq6QhqFjEB9FGpPkh6fqzSC8owsbt6Ru4EGrgVYEaY48jh2baC8IU1faamd0quVkGRVwgqLlmV3s/3l4dKd9fDqhuc03GxkUOqtgY3kPiteqDihBlkVbfyipht3reoUEyEXes4GC67mFixY9IqLFQzPYqcXGgDdwsIYFExa8Y2vUzLGFee6RtdhXEyamvdQUrAxiLzBxQMYw05POWp7bMhgDuLDji9ZpcdeNXsLJyPrbSA6px3N0IDguEIPK1rjG+3pVnWB0V2hdpTdfXs+4sXMiNpjmaiGfpGh7fB/AEWHWMPvrME5hWaKZVcSQqw4ELLuG8BlOvclk/suRfdTJ7zZY2C2dmlhjD92A+TXn2ld7iBtmbTbx27mOvFV03EZRmhCfcnv8Ps9bQVam53cYLeqWuhuovTTxjmZViP+SMH4kFcheiQoTpoAq5y/zF5gqKOcFKH8ACAHZ0iwGjwQabJSklVxaWgrOpFWtwq/1jF2UUF+cLL/pbu5eownBRqPv4oYa9WggtBy2hSMwwQAwjaiqgUxgqK/aebgV+ucciOWZum3L3AGC2DkDTy3G+OA8C7Z6Gw1DqMFMwwBWmXg9KQ+wLxK5uMGZkhGNR8DtDyvCSTTJfuND5ljZ3DIp3w+yh6+XBSrwvZ2YJDA+mmBbggaYY8qm/GL6e6xE//WeNrPP2nCUcRftIycQIeaCVMoPT3MefzJxO2RDtx77IO0XWU2KIbP27IhGYZWLou+IZ6EpNAI64MqOmZvhwoc6GVKz+RyWIE/KWH7SEZum/VdAklKfXXSR437XT6Jinsd1kRz6IJRcFnm
 BQv2k/dp
 5RDgcK+3Du8mNahX8/yIWP7mPhRRZsbhxLp9nqL3VKAeJK+WjLr1JKhShZRMNOm15c8q5Z3Gq0b9/X2E/Ywr5ujZDD62BXwTr5rh4bJ7CbTuSzsT5rsF3BatMYBtt9C+/+QL5tDrmun0vLV7759FXktCSW0F6820MRXhVMggyMSrJZKTUr2580PTXtHLppZ4/qQ4MJkHSSa5Te0wQXbq/kuHSwHCa5h1D/KhjgycxnG5/lU/SZKXzkVflfFn+LclS0Xehb/+kHHcwwhqjUSuLycFSElxhP/0mpp0TM1cZkKbR4zPv8y7y4z8YkZv4mTfVRmiLIPKaAyF8ioM2occ+8htBMd+jUPpumJE+h8CjtN4PSRJJKeDYjcKiwQOiMs6bTtMW57ftRyUlQ/jaHxAYySv3JQ2plwUWffHk4yJBTQ7EW5qIFKB50axu08ckLH0Veq5WQYRXospdH+vwB+RJ7TDTu3D3euzbSHN0qfBfaJvD7IbqxqHV8inVm/Us6ZzXme74zOOoRTQpvHdR/aMlE1bFpg4Mrwyj8KvRwRWM+gRAUH/IoE+v0nKDYeQ5N0BC5O4ts4xY51MnrtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 01:03:27AM +0100, Miguel Ojeda wrote:
> On Sun, 22 Mar 2026 20:21:59 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> >     On the other hand, regardless of whether we fix this (and another
> >     issue in a separate email found thanks to the UML build), we could
> >     instead add `depends on` listing explicitly the architectures where
> >     this is going to be actually tested. That way maintainers can decide
> >     whether they want to support it when they are ready. Thoughts?
> 
> Another one for arm 32-bit:
> 
>       LD      .tmp_vmlinux1
>     ld.lld: error: undefined symbol: __aeabi_read_tp
>     >>> referenced by uaccess.rs:349 (rust/kernel/uaccess.rs:349)
>     >>>               samples/rust/rust_misc_device.o:(<rust_misc_device::RustMiscDevice as kernel::miscdevice::MiscDevice>::ioctl) in archive vmlinux.a
>     >>> referenced by uaccess.rs:543 (rust/kernel/uaccess.rs:543)
>     >>>               samples/rust/rust_misc_device.o:(<rust_misc_device::RustMiscDevice as kernel::miscdevice::MiscDevice>::ioctl) in archive vmlinux.a
>     >>> referenced by uaccess.rs:543 (rust/kernel/uaccess.rs:543)
>     >>>               drivers/android/binder/rust_binder_main.o:(rust_binder_main::rust_binder_ioctl) in archive vmlinux.a
>     >>> referenced 36 more times

Why is Rust generating code for userspace thread accessors for kernel
space, where userspace threads are meaningless. This is totally wrong.
The kernel must not reference __aeabi_read_tp().

Note: I know nothing about Rust, but I know enough to say the above is
pointing to a fundamental issue in Rust for 32-bit ARM.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

