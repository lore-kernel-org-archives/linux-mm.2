Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B90109449D
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 00:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00E16B00AB; Sat, 21 Mar 2026 20:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB16F6B00AF; Sat, 21 Mar 2026 20:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6F16B00B0; Sat, 21 Mar 2026 20:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 987AB6B00AB
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:08:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A6EA16068E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 00:08:45 +0000 (UTC)
X-FDA: 84571763010.05.18FAF45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5E211140004
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 00:08:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HoAhORBv;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774138123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvJJXGIbMSMOti/SPIxc6WWTM1+pEoJwvSe0TSFWt9Y=;
	b=G54jQqjsmIHWtbdgj80tNy5mez1agibbUex2KC/Rz618nK60tE3/YDfMoGiGNFD7ofC8Xo
	mcvVDdbIvOGNOiz97+rG4yQXslyui43ibR1gJHYf+tfMKJ6YnhcNpl1qMXe/Zp8yy8xOFv
	xNDNCwVp2YA/ZtvQOTQ08tMO2RDECe8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HoAhORBv;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774138123; a=rsa-sha256;
	cv=none;
	b=nxcU0FdrCpPXr+S6j523+BC2wwLeIMbPbsdz1DxdW9/7VML4JytCDf63VdcNh2WM3foc/g
	r2nPKUun+ojVf2Zo7TvwMYwKeP+rOt2eI31PKdZkLW3oyvM+tx8+VfayF2DDiF70oju0lm
	3OfcYgrd6AKgihf3kP+CW1hzvoREars=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 20EA942AB8;
	Sun, 22 Mar 2026 00:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30A5C19421;
	Sun, 22 Mar 2026 00:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774138122;
	bh=NHN1+nUIOnHVMGQTNHaHd8fw2B29TR+WiIsn3gMNKC4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HoAhORBvzI5/+QYS4SrI+EC+ImuqBKlq4+oE9Fw7dsa/je0trTKKGf+DLx9AKdxyK
	 I3EvvDs24Lp8CV+fS+g03wMSahZUHHNcS9FrIuKJMHbfzOTlaBQT1GMhD735H+Gw21
	 kvIHX+WsKT3UaTS88fl1J4pkkIxkd8dzq5ZhuN5c=
Date: Sat, 21 Mar 2026 17:08:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: bp@alien8.de, tglx@kernel.org, mingo@redhat.com, x86@kernel.org,
 linux-kernel@vger.kernel.org, dvyukov@google.com,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/kexec: Disable KCOV instrumentation after
 load_segments()
Message-Id: <20260321170841.179ceada68dc55bb22064fda@linux-foundation.org>
In-Reply-To: <20260317220319.788561-1-nogikh@google.com>
References: <20260317220319.788561-1-nogikh@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5E211140004
X-Stat-Signature: rqzdyfsr9dnwhbq9dk1qwzbaxcqtob4s
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774138122-601644
X-HE-Meta: U2FsdGVkX1+XhRxSv2XWr6DhxyjJM84ueI92GVvEEoxJ3QLFZ0TBuew32F1Dp/oQgsSIIV9Gm4uVcKAOwV9kUuGtbt+Ub+cJYkfVbO+YgDgDO9It8MT6Ddl8T0WClHgWYKMsjRp+CZeVx/BuAsR/J4R2fWKgK6Cz+rM47hylpuDLI1JdLVy0L6cnnD/rYIv1bAlYAuftlkwP+zf2sct9BQVe5Lp1s+aL92D2qWNNYpkCAOSEkH4e/CH3bn43lUHK6uAStg5+U9Ca8NQI2nwjRdiPgNhVGJRvD0eoNKSPltQXYb8xHxOVzWo5/GMoilsxw1d7tlBlKYGGJSBtIzsohvIo0MBHdLCh7OtR4YQ223+43uG931YDbVxQPPDTaeze6fTWxafsGftWT8jDpmyvc0PfaH3LGxqOiMa6KxJ2TRXt9dRbJrp1uLMxfsVHHSGaxvEZ2vfdYrmcssrynaNAipAZ3jMl5dMWNUsYja56qm53VKzSDOIi9QpmXPbB72BTASfO927qiJd/4IcymAwzQsAY64pt4R1RSCB2h3/XoNi0Kw1alrrzT4v3kmOVMRfP/q4knccPcOWpbFk8nQaTFgz9mNslKQlLQYCF3OhAkGyrgfMxKzV6P7uQakb1rBb07sLeaQwR1bumTBTYt4Owm1L8oXU37qLKEHTPfgVZjlIpaftxHTZe39O+Jis8mxkjNs5GnjQ8bx5fd6b4KFEo/k3L7MQkdsIZcUTDVBGbCl/2kevWQbyq6wtdXGR8OjDQaWBvbcxO3bW626HPLdryHDCMFw37+n8pyt1EgeC5gSTHrZ/4mpOZF1a8Mk10pw3TovT04m4YlusJn1QZikFKrSDUo38sbQaOswetjU5Myn6T898wPVR8Y/pApmo3ufyQ6FCcFYasX6au2lweGYROWDevGfey0bsmQRH5BZZjYeu/CVSUOG57zlr8CzEx5jz5RFbRIe9qAw/j+pVcQKD
 O5Nm9Ifv
 o5DEBuYWYV4MFRFRCCem0N6Ln8vNQT286MRQ9FZe0lT6Boov++6I26e1bU0MkAvBpmeppFuYwEZsd2qBO/fRBTFSp36pIQH2sTLyiIfCJAx5Reexfvihy78OdZeLAZFUrnCQ3Fm29IIKIRby6MkC7PaqummNFd26qEEb4lsCjuTkcZLuELLKqcNoyqPzEMKstJNV4ZqJqh9XeVhiF9LBoOZpATK+BrI8M3Fi7Nbu+k+CmsvZyoRtEdbSbqXZhCwP/ube72ovPqXL31uO97nXN5+TwEVN8emvXNNG89iqBfBBh8NIeRVAMYt03lYUyPqpQ5v17HMJeX3oSrowLgwQ6j0KQeTDqLE/aVSVJdS6qjKV6yMGv0sxOHHSMlXUPuCqB32w9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 23:03:19 +0100 Aleksandr Nogikh <nogikh@google.com> wrote:

> The load_segments() function changes segment registers, invalidating
> GS base (which KCOV relies on for per-cpu data). When CONFIG_KCOV is
> enabled, any subsequent instrumented C code call (e.g.
> native_gdt_invalidate()) begins crashing the kernel in an endless
> loop.
> 
> ...
> 
> Disabling instrumentation for the individual functions would be too
> fragile, so let's fix the bug by disabling KCOV instrumentation for
> the entire machine_kexec_64.c and physaddr.c. If coverage-guided
> fuzzing ever needs these components in the future, we should consider
> other approaches.
> 

AI review has questions:
	https://sashiko.dev/#/patchset/20260317220319.788561-1-nogikh@google.com

