Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80FAEE9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C90B6B0088; Wed, 18 Feb 2026 08:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CB76B0089; Wed, 18 Feb 2026 08:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F306B008A; Wed, 18 Feb 2026 08:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 429846B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:47:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E741F1C072
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:47:08 +0000 (UTC)
X-FDA: 84457703736.04.1EA4871
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 286741C0012
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:47:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c9oHy2ne;
	spf=pass (imf18.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771422427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7xLnbWUtNkSyUhaZry6Tmd7Wk+eR8gm83r0+hOi7tE=;
	b=YtvLMdlafCvvjhNFkoEs7dx8tlXdy6JDmyoklGFMNy5yIqLPPjUJvaBI5Z81e09TJRzD1t
	0Tuhz2NbuDGorQVJt3EYYujUFXXzRowluKRv3FJ2HQ2c50N7yhzGcOJBpXQpFkWyvA4pz/
	IsJgEm08mJBQwby0aB3LnSl2m1W19hQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c9oHy2ne;
	spf=pass (imf18.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771422427; a=rsa-sha256;
	cv=none;
	b=GUoBf/hmVQVWQytAPkLQRZIL2Ds+yhLv8hkBoQ15dY2h8k9ImScVEx4vgWZ0ToO4nkYlma
	GnZl2k4eqLveiStoZHIUrJDar/QyxPjoRMy/PTw4MfJBHmbAXbvOHfJG1gqcfQaUJXYFwY
	GNEr6SgfTqBT9Fwye3T6Zdk5gDsHAsM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F097943B9E;
	Wed, 18 Feb 2026 13:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985C9C19425;
	Wed, 18 Feb 2026 13:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771422425;
	bh=g7xLnbWUtNkSyUhaZry6Tmd7Wk+eR8gm83r0+hOi7tE=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=c9oHy2neizExuvudX1M7U/XiymsKKkRPxTyGQH1tkHRWaUAOr7Qk+TBq4VUY2UOqc
	 O2VQA+6znhq+PGkCC8cBTQBwvxu27JzqESUXCOOYy8DJZ+GO4ox3e95HPDoNcRx1Tt
	 ZUpU5E21uFN069r2rGSKYE0pC3TGD0V8c2n4wWqiX4dRSfCQZKF7fYyY0WDt2YOlht
	 GWjU+o3BOjBHOXIHwdKW7EYYhk0RaRW47OnYIYuGASBV3Rcify/Mqs38SSYGa9IBEF
	 et5sP/x6FgfdFaROF47WjkZmqWDUSkIWzlqEUNRVrjJyyJ5fbymPOs37r0Wbej4ics
	 4eMt/011vFtYQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Feb 2026 14:47:00 +0100
Message-Id: <DGI4U9PY3B8F.37E697MM1LQF2@kernel.org>
Subject: Re: [PATCH v2 1/2] rust_binder: check ownership before using vma
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Carlos Llamas"
 <cmllamas@google.com>, "Jann Horn" <jannh@google.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>,
 <stable@vger.kernel.org>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260218-binder-vma-check-v2-0-60f9d695a990@google.com>
 <20260218-binder-vma-check-v2-1-60f9d695a990@google.com>
In-Reply-To: <20260218-binder-vma-check-v2-1-60f9d695a990@google.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 286741C0012
X-Stat-Signature: hr49dpdro9yacqx93f71zx9emibw5gfj
X-HE-Tag: 1771422426-599435
X-HE-Meta: U2FsdGVkX18yo0yIUWlMQcgb1PBkTgvPE3ngdptz5cI3lfueX1VGCqQoaHgvfSm3Xj3lSD7MDosCccdRGu+s8OwYS8PDEB+E1q6ZdJDa/MX20xxE2rBA4f2/78av/ZsZbvDqpzNhVek3kdvsAaUgY0zWLYsZW/urBB5RSmE0thwwxPP+9Ou3gRYV53osExOg74A7w8300mirl6GFh/WrcKR6RAgcOeDHuaN1zNBQG3o0CbDJ5AhMSDjVfrFV4DVjilG6uoFD33AQXBANDkhrj/Y7cetc514u9qdrSTLOWNpI3uKjAXdSqRhslE3sWdXRZ3nWpkB729NExuoGYDQQnfohmXLw2rbbk3y94Sq+V0LHv5GxULFxKnwwOTAsUcUMExsxxgRJRYxY5LwBIpQ9DxCAGRoHLs1nvtt6fywPn3pzkDmKfDm+RTU/endTQTl7TkyA5CekM/9SMfXjHGj4sTuAG0ysPDATRoIAReHqn9VF1iWYrRwdgntt7VatBBB4CODSPaqqglRaKO3lTXo+yvMbB9szc/qTjCF7EF7+WqmUY0qxDwL8rzyJVFxtjrnJzLWaAv74DApYzipXLUCdZRTGwC1w61DiTX4TEvJNiJrAPyfPwifeFa7MT8ilj4KX5jrPNMFNs/Pzz3Bwm01RuF/xmCrbVYFxtsLHB4lZeNIo2Zz/AxNZgB/OxCjkljdbEIWYM4OZkUlfXi2aehvsbZ1UhNnw9S7H24Xwv5HiYh0iDCPifz0mrBF//df3irmtDj6PTek7PFRj+9KkH1hTK9sXz80BIPLYf5Kpz7rJKeo2WIir7bu6kJAOWWWU2zXm7TCC6Wu0YlBrKdRSRrBLNI2X7nfP52IhAztOC5enlh23+PW6b2fDUegKVrUOS5iUAO23kg0n3Y+uRn56YFHynNoI4SGdXliWNa1QY5EJYeB8wcLcxy/NgkkjJ9z+M7o/FrGrCMJYXbhXhmTdvMR
 tyUOGDxy
 Q2AzsB7ptNxeF2MoQc+RinnSo71qriZ0TakbAn0L3D3JfzMrqieBIydMrsARgDeWaUvF219GBWY6/EfIGL9tZ2OucSzz7P1LdpKc0Z10EA5eGjIdd/LxETCzj73HaFeM0ISclMsufmBpeDCj0bMlj2BS0oB4elEZyY8jymyGwXag/h/M/IFebqNNut27dn2NSB73kLE7VWsyNlCStBj341JG0PVbOWG27e3v+0tv7NJpauJDnZH/7jmsd0jRLmI2JKpIthtc9L0R51ulI6m8bsPxkO9PvyX/scvHQQ0j3HOzkN3PUEMC0qdQ6dj8ZC3k4iJMo7E/ui89/8HfjPEPf8/kb5lfg3qAfk2pv/MkeJ2y8SlMCafJSfOIQGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Feb 18, 2026 at 12:53 PM CET, Alice Ryhl wrote:
> When installing missing pages (or zapping them), Rust Binder will look
> up the vma in the mm by address, and then call vm_insert_page (or
> zap_page_range_single). However, if the vma is closed and replaced with
> a different vma at the same address, this can lead to Rust Binder
> installing pages into the wrong vma.
>
> By installing the page into a writable vma, it becomes possible to write
> to your own binder pages, which are normally read-only. Although you're
> not supposed to be able to write to those pages, the intent behind the
> design of Rust Binder is that even if you get that ability, it should not
> lead to anything bad. Unfortunately, due to another bug, that is not the
> case.
>
> To fix this, store a pointer in vm_private_data and check that the vma
> returned by vma_lookup() has the right vm_ops and vm_private_data before
> trying to use the vma. This should ensure that Rust Binder will refuse
> to interact with any other VMA. The plan is to introduce more vma
> abstractions to avoid this unsafe access to vm_ops and vm_private_data,
> but for now let's start with the simplest possible fix.
>
> C Binder performs the same check in a slightly different way: it
> provides a vm_ops->close that sets a boolean to true, then checks that
> boolean after calling vma_lookup(), but this is more fragile
> than the solution in this patch. (We probably still want to do both, but
> the vm_ops->close callback will be added later as part of the follow-up
> vma API changes.)
>
> It's still possible to remap the vma so that pages appear in the right
> vma, but at the wrong offset, but this is a separate issue and will be
> fixed when Rust Binder gets a vm_ops->close callback.
>
> Cc: stable@vger.kernel.org
> Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
> Reported-by: Jann Horn <jannh@google.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

FWIW, in terms of my drive-by feedback from v1,

Acked-by: Danilo Krummrich <dakr@kernel.org>

(I'd offer an RB, but I did not dig deep enough into binder to justify it.)

