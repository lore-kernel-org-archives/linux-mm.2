Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE75BE8537A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 17:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B256B0005; Fri,  3 Apr 2026 13:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB746B0088; Fri,  3 Apr 2026 13:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA7E6B008A; Fri,  3 Apr 2026 13:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3D016B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 13:24:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B98651604F7
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:24:50 +0000 (UTC)
X-FDA: 84617919540.26.DE9733D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B528D140005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:24:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ri162ENa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775237088; a=rsa-sha256;
	cv=none;
	b=OZvIm1a/zS6Gu3AGygty0DIkmDNKosTM7KhS2+bMYDzczwPbEmzqrA7KtuCoc8/ibzzWME
	kNwm3Bcy9z0Ib7gR3oHtyR7sIcuR8IXlefI67TzrDMoNdrN2Cej0jWL3wqlkgOgqeHXJV7
	3IWBZTNWgABsUASUrq/I7zpcOxFT/gU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ri162ENa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775237088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxfxN2zWBmikOMpbTxf4ZqLUBV1Y22o7mjg0HGhygTw=;
	b=aQvEtncLm6kyu5RtBg4rNqyJRf/MaxW6bT8R5RsLfHqhdqotTZv993jVz50n6Kplzo8pqt
	vNoNv+m4leFhZrcYnTj6l9nBX2z1J2lpEn81jIIOUAkfvx5uhT7zqq8PYyvkjwytixD/jh
	D2N8sMNrkcpEpMCQ7FVhBJKkl7tj/GM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66DB24456C
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A06C2BCB7
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775237087;
	bh=E1bzUypaVS7w28CbARApxGc+uxb6NjOyzaisp3si/6g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ri162ENaaXiSRPqBTShI8ahm36fA0yxapnpusRTreYOdDDMZ+niMHjj7xqXvZwXxR
	 W4688wQ9cGxnGe+4MGiHfTAaMtuD2Con4gYFbAMxcYjgjIt93lCPasclWTi7ojO9Zc
	 cazVdgRwAtkk89yPiJTWnIHMEFFN8LHV8glDBn0X8QcC5UvdP0JZaLMOMJXUx/iVXU
	 J6GWfBEZdlJkOBVUvtov+m1djxfdByrpUr0rmKXjb+/NqCjkj+Qy2GYzHPm2Fr+5nb
	 8/vPh720vR6+uCmdKhX7HYao8p87jfXTXfxJbR1k47IxMwREqsFF2kj0iRdD6uwC5X
	 E/5FWDXI51lcQ==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-649278a69c5so1648220d50.3
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 10:24:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXRGWKCjSj8mVcowpccq+xOqrvrAXppAHJBNV67Abo/QWExe1aiLxv093Cwfql+ACNObU2Uqxcxyw==@kvack.org
X-Gm-Message-State: AOJu0Yy/lpbph2gQ27AMo2f6mTf2RL5YH8iAAetOzXu/bRElCj8xiEKY
	8YGm3k+gW91W7QlXYkrtfPkQb6NW2AwK2d4pU+dU4TDB0GZOs8etDnJ92ikN0uTRWObV/pHIUG9
	z2jevqFkD+a/OWPQB3gAGKyAuSu+yz//DBrWaYYfHFA==
X-Received: by 2002:a05:690e:d41:b0:64e:a765:ef82 with SMTP id
 956f58d0204a3-6504870ea48mr3180067d50.24.1775237086162; Fri, 03 Apr 2026
 10:24:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com> <20260323235817.1960573-3-dmatlack@google.com>
 <e3fe7085-1297-47b8-bb17-a48196e8f37f@linux.dev>
In-Reply-To: <e3fe7085-1297-47b8-bb17-a48196e8f37f@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 3 Apr 2026 10:24:35 -0700
X-Gmail-Original-Message-ID: <CACePvbWrHCSzYmiKz0EuXE48MNk26+4j0njSP+1Vy83RMvvVrQ@mail.gmail.com>
X-Gm-Features: AQROBzDLi9Fnv8_mDDwmklVKEby5KKVysrnsYTweXxYMFegWZQjyvtyGp9AI6Cw
Message-ID: <CACePvbWrHCSzYmiKz0EuXE48MNk26+4j0njSP+1Vy83RMvvVrQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/24] PCI: Add API to track PCI devices preserved
 across Live Update
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Rientjes <rientjes@google.com>, Feng Tang <feng.tang@linux.alibaba.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Li RongQing <lirongqing@baidu.com>, 
	Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B528D140005
X-Stat-Signature: w6uqejz7ibunfcwisczie7e94o3g6hj3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775237088-895693
X-HE-Meta: U2FsdGVkX1/cBdlC4ld729FIws8JfJkGfGn6w3ZVI6sVIruUAPP+3aM0iCIahWUE/ud995SD+Vm8TiuqdLGH4LsivE4pDv3HHkxJnqOg5ShVgGctVRwcfwPtvxuFsS8vcGVaeZUFCFVyrIn5cEQ4t1R9DoP0hfSbNjAlGGlj+h/BKORm7SP4t3wCmFIJl1b9I7Hn3ChzLgqn4R7Wvbi/oOkCZYHh2p4esFPRKPJa8m7QpatYIo9KtphaVe3x740DKm280KpK1oPtK/dlW0w1saU40O5mCOyqVFAKll8y6hF71m5AFv/rpBsw7omWh2xpT7C6vI0DUJsGtMAl82okE3l5BuDwQsQ0JETX35HShfYdeIaFHi6kQLH29bDQo/ZXOOdsGjyp+CQ7yXgcB1n/pR5tBmZl2+JvOse8WLROyYTJ0n3sg0Sd5ZLVmilWyp1jOZ7Dr+DNcdFTBJaK3T6gae8azg5IHatwlC0cyvei7i9KruKWGlIewodekh0g5W1vKjqdU8etajclOs/+oIdHRKv3PvVoI1bxaG1kPLEVWYW1OTcHUyxS9FuxM6wmZtZ2ncrQAdAm2Qm36rr7tA39VIN2+BQ/WPhZ1CCSfvRsPoeop2nbIjBUOt9Lb9yNWMhUWWjPpJMZ+s/QTguF4fSGjg6sTqNgijqO/aZvrR8//xb8bZ6tf6Afw+IH7QWsKay/5ipj4m8cxEZI5/RaJw3GoTqHf0bbiTXPx3kP1RbhRFqwlCxKLyXFbeAB4Ms9sbsDdyJ24f86kyLZJGuZb01yEEzRmNLXaiNLsu20dmsT23BNa56jvOv+3RtwwNOcEsyRAfcmZQlSmupX6CYPN503ecXBTd/oMYkxT6EQwaJee+Q0NsSyfqoBj6Vh25djfWXZyLxBY9izUrn4GbNLNm0o5ami6x5A4WNKsqW4ls/bwd58PxYL8MXqxHipwZCpIf794v6skVC+IAG02p9D56m
 6S9ESHCX
 CCZ4RXuJkm1i6ydVgUPK/4QEpdoJje0KxZ3GMnN5AlWq0M/1Hl2Cb3KT+AiPIcJHk/6Vco56tsB6Qi2qfbHZdZ1G78TMEMNpfCC43mNNFbsVXZsLodJLDE/CJ8JDe7qsuPEYcTTuA889SDuyC4XPGlmfkqaSsrgE2UlJguJ6DkZAqH+KwbM5iGrF/AEmLpYNBnOmybvua60dtbmvXl04if9sAq6cELME/q3j3SFoyPJF8ol57D3bwOGhlRC/xKMqaG5SojLin4ZMmLCGPTGB/RV8/oY9kfZNEmN8F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 2, 2026 at 2:29=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.dev> wr=
ote:
> > +config PCI_LIVEUPDATE
> > +     bool "PCI Live Update Support (EXPERIMENTAL)"
> > +     depends on PCI && LIVEUPDATE
> > +     help
> > +       Support for preserving PCI devices across a Live Update. This o=
ption
> > +       should only be enabled by developers working on implementing th=
is
> > +       support. Once enough support as landed in the kernel, this opti=
on
> > +       will no longer be marked EXPERIMENTAL.
> > +
> > +       If unsure, say N.
>
> Currently, it only supports 'n' or 'y'. Is it possible to add 'm'
> (modular support)?
>
> This would allow the feature to be built as a kernel module. For
> development
>
> purposes, modularization means we only need to recompile a single module
>
> for testing, rather than rebuilding the entire kernel. Compiling a
> module should
>
> be significantly faster than a full kernel build.

Building as a module has extra complexity to handle, e.g. the callback
can happen when the module hasn't been loaded. Then the user space can
take an arbitrarily long time to load the module.

It needs more infrastructure to support the liveupdate as a module.

Chris

