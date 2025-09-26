Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857DBCAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 19:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DE18E0003; Fri, 26 Sep 2025 15:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F52E8E0001; Fri, 26 Sep 2025 15:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731EF8E0003; Fri, 26 Sep 2025 15:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62A778E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:01:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06CC111AC26
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:01:11 +0000 (UTC)
X-FDA: 83932319142.09.9138318
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6A4B3140017
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:01:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IyKPOXGg;
	spf=pass (imf23.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758913269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4rfPYVBSuJlFFzEr4OCEKQss3vgw3o4JIy7YvbOK0E=;
	b=8eLQgTwlyj+RKYr8WjRtb1MG7wiDFq/Ru2uwCFoBnpaI/6VBL++isNhQKkJoIGMQSjGLcf
	0w5NKFFvDjVAspt8apoML7yq3BnXK6frGJSJNjrl53mci0rQPhRh0X5VtyQA/uwRLrTwmg
	2yOIH8/UtdMoT9LuBGsBisM0y9/2ir0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IyKPOXGg;
	spf=pass (imf23.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758913269; a=rsa-sha256;
	cv=none;
	b=ypv6XouXnwzgPl5dxQWo/SOaRQ0JXOce+0vPLPl/fPSk+bDOEghMxW3rJtUE+tG/hX6EJU
	Q4UW0yiqS22EMNIZyvexQwjdxOwXd6D28IdF0pO32i7CQQ1SonDEU1PF2nOOP05JB8kgSX
	PFU9YylfDchsaUcaU7/NIOaookdU6A0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 164D140BD1;
	Fri, 26 Sep 2025 19:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C21C4CEF4;
	Fri, 26 Sep 2025 19:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758913267;
	bh=E4rfPYVBSuJlFFzEr4OCEKQss3vgw3o4JIy7YvbOK0E=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=IyKPOXGgQmHBwfgnZgG+IY1ENE+o5qSwKicZbwt3OzyUr6pM8MKgo+lpt2ltR4MhK
	 x2vmCQC8qJQy7uX0g4pLPrC6pnMXgJsIxA6xW9EtSJ1hNkSmCf3jmjrFGqY3r1vHaS
	 NZ9OLfvEG7wPa72y8JsDJNmX1Fs36cPdwIX1bm5bhmUcYo2TBH0e+uyhkCH6bQ04rn
	 ljmhSRdPsh4DW47pRsdkOy4PARpzVou3y0Q2jhJAoqwzvVX+O6k2cYkQDrkVg8Ulwl
	 PmVj7RQjhxEJITZtGe9jr4wcap7U3uImOcz5uBR232g6RoVMZsO0ej+x2H5rLxfuu4
	 /CUx4cU1NXPuQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Sep 2025 21:01:02 +0200
Message-Id: <DD2YPPZ08RMC.2FCYC3HPWY3IC@kernel.org>
To: "Vlastimil Babka" <vbabka@suse.cz>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH] rust: slab: add basic slab module
Cc: "Elijah Wright" <git@elijahs.space>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Uladzislau Rezki" <urezki@gmail.com>, <linux-mm@kvack.org>
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <5f09b7f5-e7de-4333-8de5-322eb6d93aa9@suse.cz>
 <DD2UB5P01XW7.1GW33112S22Y@kernel.org>
 <DD2URCNO2P88.168J48GHSJRRL@kernel.org>
 <1f5ae3bd-db21-4042-b177-55464644ce2e@suse.cz>
 <DD2W3LCC7FWA.2X90YAPLI1FGC@kernel.org>
 <57b01f59-f4b1-4f5f-bb63-fd8eea19b7ba@suse.cz>
In-Reply-To: <57b01f59-f4b1-4f5f-bb63-fd8eea19b7ba@suse.cz>
X-Rspamd-Queue-Id: 6A4B3140017
X-Stat-Signature: 65manwdreihoxg8t1ds9u4izzxykhny6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758913269-353731
X-HE-Meta: U2FsdGVkX1+qButXpu2WUmQA9vISR9sqSQcuI6h4NP6OZqsLdZH728H+qDU8OVC2sAgU9Q6EWf2VsG5NPVjhFM8GP4WSTIKOJq+VjG554oO19MzEiiIp45mjNi7yiLxK7nDKNb+qt7IOYxrO9RQxh3ubbbmqnnjGgZetEWzV+dQH5/js9IO83/gfisbRGZD8hL2Mr0UCLXUptSgXelWqZnCuMtys00UKg132WK/qB0Qkq0Daga3O7kU3BvWblkW7BhuKp4cwXO2IbU4ECtJ/YIGYr599PDLu4XEE29LRzJtd1OiLqaDOq8ljci2CEnLSU6jkLkb9zV05YuS0FJO9PD5cJtwy2ybRGB5I+N4cC23huGPjwAWmDiGH5CfevAwKw9fni6zzZJUhHIvKURKpAAf6BZp33FcMThuSd0AyA747Hla/5U0IYUfK/gTjsQP593QUE7KnRIPkkOXkvZJpUJvYhasGgCETDzwohzzI80IFnfl2tgPnpKrGrq5WaFjx+aXa0kkeQOaEoeK4ngw4fy7J1Pt9U7GS1XDLA25ywGa9kYZSkSEubhHMmiz0uVYcuf0Kr6Uxg5r98tgpdG9Pet+iZxhU1WSwO+627w16ToSDXABZ4/tRhZlBY2UELo9d+zVIE7LN5wioLJ76xm40DsexkEuD9QgkCpauC2Snhth1/nl5r9RUOpttGCoPLg+niM2sdgsjC1v+58nx9laUQLUQMt/wWnGo3H+GlpSg/k3ayywlndrFKzN2RrSuvLAkoKx7ZKj3DqxP3txh7VuhzmfegYZlMNh7TGWEcCrkwta+e8M4c2pEmL2nsaLbWMv5f2SWdDwqyOuXnVv+3k8qfdvM+RGrvPx4hmHkG6//t97tJPV7TtaL0j2N9lkxDI+46SShd4Wfl1wbhX2D4rnEPRXiGcKKRCjE9klJq+iY1PwlB0JxM7HVD6KQ0tN0boTPXJEqDo4wtKIQC/OtNlO
 q2giTagh
 GWwFjcHbQ0Ea865Tbk2wK9EjHVsHjkBNmrKmBRuZSLv+rV4/nH35J7hLdsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 26, 2025 at 7:11 PM CEST, Vlastimil Babka wrote:
> The rust wrapper side could do that so we don't have to add that check in
> all kmem_cache_free() calls, maybe?
> Also either way it could perhaps be difficult/expensive (memory barriers
> etc) to properly handle a racing kmem_cache_free() and kmem_cache_destroy=
()
> in a way that ensures the cache is always being destroyed, and not have t=
he
> kmem_cache_destroy() observe the destroy was premature, while the racing
> kmem_cache_free() doesn't yet observe that destroy was attempted, and not
> try to remove it.

Yeah, it's probably not much better than just using a reference count, but =
more
error prone.

