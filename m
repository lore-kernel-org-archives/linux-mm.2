Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EFDEE73152
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 10:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01656B0088; Mon,  2 Feb 2026 05:06:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9946B0089; Mon,  2 Feb 2026 05:06:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F4B6B008A; Mon,  2 Feb 2026 05:06:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2066B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:06:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF70B160B14
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:06:40 +0000 (UTC)
X-FDA: 84399087360.05.6E9F6A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 313B218000B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:06:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F3Zk2JPt;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770026799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/Z7YVWadwj7ffGhgEHuTJspdhrwMfBhAM4DoZB31HY=;
	b=JfFOA8uqqlB8Bede01KtMYMr6nHOO2X5avF/kT+2ZfV92RtQADOq7rJeOG3APQrJzgIADp
	EaCuQ0a54m9/d1XQ6cAz2ZDyLhdAAmdqp8xw7SKFt5bYAoad9aRVvMat3GpyF7E9TPlVSK
	ZE1mmVS/7mfWn0wGgPtWAkUVTCVNvac=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F3Zk2JPt;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770026799; a=rsa-sha256;
	cv=none;
	b=vaQp1rG8WEFn2tTBUq6S360kY1GId1XsVbhKtVirMjTLc1KWKhoqXGX1aTAas+j3TN2dYT
	FDroZICGvqfAZ5oUo0qJqmqVGT9tEjm1FD+MQFCUVG8tADscm2yrGa8r/JvQlR6V8NVHI1
	Mmi34ihXl9mk5TooEQgMKNMZdqWmI3E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB1F1401FB;
	Mon,  2 Feb 2026 10:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4988CC116C6;
	Mon,  2 Feb 2026 10:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770026797;
	bh=AR8WJZlCheylxeYBIiVxCcxzyOcuAsM0oQ9x69QBGeM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=F3Zk2JPtX9BKsOfGhozTjtxp24jGgOGKlChNCS+jg88F1hIocpFuLVSYIR18rCyVU
	 Moue0o90AkrrRNWLZsD3Ivul0Ujd6NRdOLRfS4mbYhd+jIgh3WaUTu37sqLhjoVDDM
	 ZgNKC4CQQbziV9McP8h+/UTn9ywlHI2QkvLZ2ar9yc3YlJ8hR3SruAEiAa6yi0It27
	 BEnKNuFE3HNDel0CDsOIk6P757sPTcTgYwWOtVRxtchr0rBPAWQmmqwkgUZckaznQa
	 zih68OgLAg6wb4fCu8Re3XEGr9fp/N7elqd9Vgxj/bLH1xzTBTaowCfXgw4AOXcm0E
	 o6qWmBVO6NSqg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Oliver Mangold <oliver.mangold@pm.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno Lossin
 <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira
 Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth
 Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, Paul
 Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Asahi Lina
 <lina+kernel@asahilina.net>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH v13 2/4] rust: `AlwaysRefCounted` is renamed to
 `RefCounted`.
In-Reply-To: <20251201160030.6956a834.gary@garyguo.net>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
 <20251117-unique-ref-v13-2-b5b243df1250@pm.me>
 <20251201160030.6956a834.gary@garyguo.net>
Date: Mon, 02 Feb 2026 10:48:39 +0100
Message-ID: <87wm0vpjbc.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 313B218000B
X-Stat-Signature: enx1w3713fujtuerjpncuah87z1qxw6f
X-Rspam-User: 
X-HE-Tag: 1770026798-697957
X-HE-Meta: U2FsdGVkX19k/DRDYsRSjdrVqEBAEGxirUthKdM+fOTpN8ryzEqIVjP4OoRwbTANvhIzazCWJbCgIGfCjQ1miFvKvkXx/w+yxZ+6vev90sY9aJdBEGVydVQAAIDRJuJgENKXLp4icoDQ/oiadEljE2IH3b32DPimec534O2dKGJ+lk977/V7hkHp1UR0vByGUJNQLZ6l8VsBqCLnG7j7Pin4wDUkiZq/nOYF2kz/Hew3T9lbnot3dKJYHHsmh5Nkl5J52WR/eOrzdda8Fz25Xj6/e5Btqzczz767mkPDcDJE/SHf+qFy7g/XSxa/DiE2hyWTxji1Xv0h0eiR09lFTEZ1/Dr8nucvg+l2SezBtqB/VkmIpy9H5NCGK35yYyn6cR5ED5JE6B4ycXvI3YZabqeEHZNcHWc16IauvJJuOgCY3/xnp9e9pnQJfsoHFykyRqMPby6w7S7Qje3ql09ehz+aZzFWcbED4J8/KtuXvMuEpsPydrqcq49YPqRTAHdMBdUkn4hIibSne0snuZIS980TRJfjEooDYFHX7ic0nTfy432L0YXzxh57iLBLBsx+HbRvt7+hyM/bFR18IpzN8LT1Nfn2hlChNgeT7zNt5WHi3EZNVg17EF+wQomY06BjdZnz5Krn68Vg4dCMGfDIyFtA+TVo90WBPMMR73cNVm2JBESJ66va8CmIzJwIeUOJtvq5OHg7SD4gk5eUUgVPt3dF955N37DaOiXDrKp5Dez4tRYNhndjfq96LZCGFD8d3OUhMy1RxjNDs6cESaeudHGjmM19Qob3BDtCxylQmaWBlZKbC/UIqnnj12knbPVRFvrqIkSl1d8BHhWgErCRZtG6ZLC8vpDGuuUtWatVnnwAsNZa1imWKLsB1kbv+dDabvMDuB4+qBxJvXEMd1XqJpitXcmOgLANYg9IA1diH0g4ES5dd8YooQTx+KwCSgobeEepGPbE5rDoA7772Sr
 BKHJjmDf
 f1L2fgYmHWShdgXUfJDgJY8M3k4oyZYS5fwEtiY28w6vW1WLWpZhE0ZSc/ukk9YEgHJZ52uZF5e5KQfIH8An7R/iLFa+XKFNlBlyNUDCnSMI2eBeYDrL8Eul2H6D+ZjC7SFvGqhEqFdfSZ60tD69PxnUwULlXsPTLOEP+g8mU+rUXnbAUT2dVyWehU2LZG+ck57SRp05eGQT/K7oivL8EZw0FDlEpUXi8xJnOR/oHJmy+Dt0fZ3bgezO32C9Ticso1cZud6kN4tu+zBrDG4oSdAWVAqQpaVR9o3UJTYRfmQkfM+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gary Guo <gary@garyguo.net> writes:

> On Mon, 17 Nov 2025 10:07:57 +0000
> Oliver Mangold <oliver.mangold@pm.me> wrote:
>
>> `AlwaysRefCounted` will become a marker trait to indicate that it is
>> allowed to obtain an `ARef<T>` from a `&T`, which cannot be allowed for
>> types which are also Ownable.
>
> The message needs a rationale for making the change rather than relying
> on the reader to deduce so.
>
> For example:
>
> 	There are types where it may both be referenced counted in some
> 	cases and owned in other. In such cases, obtaining `ARef<T>`
> 	from `&T` would be unsound as it allows creation of `ARef<T>`
> 	copy from `&Owned<T>`.
>
> 	Therefore, we split `AlwaysRefCounted` into `RefCounted` (which
> 	`ARef<T>` would require) and a marker trait to indicate that
> 	the type is always reference counted (and not `Ownable`) so the
> 	`&T` -> `ARef<T>` conversion is possible.

Thanks, I'll mix this in with the one I sent to Daniel.


Best regards,
Andreas Hindborg




