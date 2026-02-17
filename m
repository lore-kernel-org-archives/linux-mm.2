Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E1BE68152
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 09:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB9F6B0005; Tue, 17 Feb 2026 04:33:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A99F6B0089; Tue, 17 Feb 2026 04:33:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABFD6B008A; Tue, 17 Feb 2026 04:33:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 459406B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:33:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4A9A5E123
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:33:45 +0000 (UTC)
X-FDA: 84453436410.17.9D0D166
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2B1FF140007
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:33:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PQd0hlTE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 39jWUaQkKCAchspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=39jWUaQkKCAchspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771320824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8U/V9GGZCQ16QVrv/ncm3L2JAXBCx3yPL1lZ3d8azI=;
	b=ChKCHtMLN1/t5QIw96xPQzUarScMIVxIFx4rm6VoeoxqH2NpIpIqX5sXH86VsLrZKiHVXW
	UPRnIGh6iYwU/3MuInSvfl1CUtUPUCEqjLb+jOkqYNYYRCglC5Orn8LvsbfOOyKaZvB8ZI
	TP6eS4dP0yLargKsN4MlBTYRTtdiC0M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771320824; a=rsa-sha256;
	cv=none;
	b=l65uEeTpeMeJ6kpOTZFnRSph9GspkvltzbvFZXacjOkThPrzpjt3f8MehWQkIDzBcf9d1F
	BB0mbgylD7QUbAtRrbfaVsPOr7jHqnZ4y+XAE8/QkGjU/7R+b1njif747wYlH20U8z/XJ8
	hcs/rgULpH7QSaaK4fih4s5P3zaUmWg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PQd0hlTE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 39jWUaQkKCAchspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=39jWUaQkKCAchspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4830e7c6131so41256865e9.2
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 01:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771320822; x=1771925622; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x8U/V9GGZCQ16QVrv/ncm3L2JAXBCx3yPL1lZ3d8azI=;
        b=PQd0hlTERESUk7/Xrhn/8Luyouk4V3ykaj7itpbe8DFQLmx5pPmV2UZxNQ9XAW+mqT
         h7DqMueFdPFzq/AXCogtKBw84UHTHH0sCMaU2ugitND9L3XSwsV5X9i9sjkhcXecJhcZ
         kM/G1Oa2zLW6PPzwIX51gzUYFN4y8QwBlPETdHprgVCVQqhMFnnmrE1Pq5iLAhWMWNJk
         38OdBci3Ih1TmkubF6LnC6ANRtE1TDE4loz/SaZwGoec8ilpoZ7eXHRYxnKXsUSmP81P
         BxMWzR+oZVIhxpCIu1cV4dLHUdYtZFo8O4SmNoO4UmXi0ch4Pm1JQibCLwHel18pnpjt
         /FfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771320822; x=1771925622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x8U/V9GGZCQ16QVrv/ncm3L2JAXBCx3yPL1lZ3d8azI=;
        b=IAdu6Q24MxBjkUcZlxIJw5gOL8N+1PEpXF58qCBUcq6aSWdj+INEyvURxaSqx50ypk
         Toltte1ITR9KJK5Pooo1QreeAoCwXdkVzzfjLDFCaWmZa+pgztqxCOXpdGIp2hHxFpDo
         ryHwQRkZ1eVX1GwAWE3AcviPEgyIXJVXXhfNUDpZnvh2FL50zmGf0/9UJb3mxWkd8Rhl
         mcvkfUZlFn4Y3gZ8ktMCOnNswYgYOCwh4ad5hnJp3l47ucDWg9JmK2T6ba6tTyTH/ScD
         7RMl/DdLyvss7oyLSL4vkXTEpl0vj9ikEMVHSpWcoDHTgh4yoQgB0H+R/piOMGCj5Bd2
         ihzw==
X-Forwarded-Encrypted: i=1; AJvYcCUZzUBzevi6CyEd27WCzfyqoT/bigOodYBIMHtPRGNtfCgUU+UN3y9pqqzDQtwDzhmlL0t7AkjUTw==@kvack.org
X-Gm-Message-State: AOJu0YzcrtoSikYljRtWQQSSCt/g/NN+AD0kz+izCR3+O62/30tNK6+j
	C2mkbgAsM+pVrvzNW5jD+0TdDiTafRuHFdGexX0qwUf+dt7kycGeBU+Qs4osqJ1EmDY8LWFVtxx
	b1Ic9qvS5sqkNjDJ0FQ==
X-Received: from wmbz20.prod.google.com ([2002:a05:600c:c094:b0:47b:d5ad:dd7f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:820d:b0:47d:403e:4eaf with SMTP id 5b1f17b1804b1-48379b9f278mr197567615e9.10.1771320822308;
 Tue, 17 Feb 2026 01:33:42 -0800 (PST)
Date: Tue, 17 Feb 2026 09:33:40 +0000
In-Reply-To: <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <877bsgu7fb.fsf@kernel.org> <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh> <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh> <aY9HD7nH5A-DtgmR@tardis.local>
 <2026021326-stark-coastline-c5bc@gregkh> <aY9PBfx3RRV7rXZ5@tardis.local> <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
Message-ID: <aZQ19FEeGgigdwz9@google.com>
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
From: Alice Ryhl <aliceryhl@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 2B1FF140007
X-Stat-Signature: x643xkd7nsy9jumkhp4i7dwzprxqterk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771320823-952066
X-HE-Meta: U2FsdGVkX1+xlvS/aZsF538NxUTDbsuRsJTEfVAeNQcTMvbC6K4hIhevkeH6uNcMEQjD0X5qMFViLWoZ3XzTSWHO/y/sV+W5HCG0B8mcB/Com1kUgqnVpyoPepPgpkABfVYt04QY9OGYQgOFpngIZ2ISJEWpDzohHQouQ5yZfQ2+55Yx6dsSdgpd4f1vi1ptzQJvgoMBHr3QFHlHwM/6AQZsu4DSfm6e1e7CfHMWfFCeUndCWx5Yb7FK1FXOOCxUZEiF0gSy8U70+3nl3Q/Hs+fZxByHdzFpPs6YI30o2s08EbgoIp8R9nG2Uavc1zBbrqR1RAZDyQ4CxBLf87w3GICjSgi7kUy0rU5zx6ZkK7xvvePH6iIKhv7acISHWbd/BbIdEm5cGeVjBoQLut92wiofwk5LnVRwHAz3zYx0V6oMb5Udnl8XzATjQZuZFHpE4FJVqO8+xuvtoiXcv/kJTYAX/AZJdRHDvRS/4jYF2JGWTt/TIQM3nj2tF3Alx3MjrHa9FHcp3RPylH82anmqZIRQ8mKfheOdttQ3nHKfCBRE7q5jN+dJk3/TTJzXNSHH7en03UsQW4Rz17vKMeX1zJzc9v+Qi8UsuB/BMt0ALSMjIOPOjQpM6x5hENoc2vAvvEnqOlIe7kHr172wSmNlhGizUO8HHcRcFWokd0kR1foF81+TfPBFTxpPW42o/AwX2TyiCU2e4I29ENC+hF7ILcwnLwjDOSZXLkYesOvIACVXqPl8GrcJONsLeyk4SG6guMI2yGSIbGm+GXTh61jnTjVyks5rkwWSH01O4Q+mhZfh3bwcCiLQ6nP0aB2IudJRtKgUUXZL/YI92cVmkvYTday9VLJwau998lzIpuJejujHhNkNCgbyYtLIRmVziR6VwJWmIs5fWomZ7pd4QwIAmfV4U49LjHk5H+OmBe12mqMvR1vGkQcmqOBaCC2YK4TftXHPgxfcPeU6TRuEUAQ
 +pEyenFI
 EA0c9loIbJZ2Nh8Ep2REOYfyuz3AgqaTDrQeW6gSRIfFQxwVpbnaoFKkzCXlJZ0HPuMMNNujt8Iq2IkoCocUUabc8zTuVTJeQn8rNWQvyvkhSoOSLX4rdPTqo56T/JubwqvFgwIbDwG/PL2z1LpqGyJADSJnui/0OwEIdpRyx6v5l/JaKfNnUNh/eQzb00HmeNd3gWPZ/LgixOGXoiErY2O1BCdAcm1rsbsXHNat8PpRpM94aO3rZ1RnduW37bhuwdXjISFIkXDl7mIoYUNu/q9JZRqHcRqKSzfYtgBW588/O31KaLK1g8rHA8rKiEwMqetSt31PxsobGRFSSdfefittf83HwmFmeOgcpbt+SXPLfyDMkAGG/1ghBcTKBOPDTvLJM42jFjml1XijFwqRgwV0C+RRYN214fcGFvFTR/WfxcSunB62IW8Sog04U3MQZJcAGvuE09QlNY+11IjjTpD6nQp80AB7ZepRVqZ2QbPx216M24GgMTzihBIlMvigpnQg3mg4t27A4eH0+mAiifIZN8K1lNSpo++ViQVUUqeeyhfezAfnco5KlOEo+iFLrwrA7vaBJnwVtTe+bwU3a7EX/9WbdLisn/TJZITDoGBHsaL3OYI0Ld5HiB/5SCyBhg/y0BpNeIhfNjSPvHAuXhOMx0yvg8+bv7NoQpfuOdP3+PTqQp4BxRj9OyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:13:48AM +0100, Peter Zijlstra wrote:
> On Fri, Feb 13, 2026 at 08:19:17AM -0800, Boqun Feng wrote:
> > Well, in standard C, technically memcpy() has the same problem as Rust's
> > `core::ptr::copy()` and `core::ptr::copy_nonoverlapping()`, i.e. they
> > are vulnerable to data races. Our in-kernel memcpy() on the other hand
> > doesn't have this problem. Why? Because it's volatile byte-wise atomic
> > per the implementation.
> 
> Look at arch/x86/lib/memcpy_64.S, plenty of movq variants there. Not
> byte-wise.

movq is a valid implementation of 8 byte-wise copies.

> Also, not a single atomic operation in sight.

Relaxed atomics are just mov ops.

Alice

