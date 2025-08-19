Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AABCA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7831D8E003D; Tue, 19 Aug 2025 07:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75AE48E002D; Tue, 19 Aug 2025 07:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697C58E003D; Tue, 19 Aug 2025 07:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7488E002D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:38:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06CC51183E4
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:38:50 +0000 (UTC)
X-FDA: 83793310020.29.DFC6246
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7319120002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:38:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5KMksjk;
	spf=pass (imf13.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755603528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmknYLVSkkmQvTAgrwu7Xj06gw6T6+yw90I07oFg6nQ=;
	b=Y43EaX68ajj0N5H0vM+iaL6RCNd3JgN/lsdK0S4hzcfcEKWv3gFCEUvVROl2wmoaauWmqq
	S9d0ioHE9yfRnsRpECBmEsYxSRif/egLGW6uqT952JPvQG82Ji6R6wfH08uP0GAtJuaCDG
	5KM/0i5OEP7kJYJO6OEUhVQcuLNn15o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5KMksjk;
	spf=pass (imf13.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755603528; a=rsa-sha256;
	cv=none;
	b=sKVYLJl1FLWBmk0zLj17nKLK7T90E9QE/981sjH4OGEHJahggwJ8HA3xKjq3edhXMskSGY
	1aYrYuD7DbVJqa3DgF++niEEdEjwv++aKLtecyTYuC3+ddyInKKfdR/FNCVY3jPxLUW2X6
	RdFCff7W81NnpSVmKTMSsEATF7C2UEg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B734601F9;
	Tue, 19 Aug 2025 11:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44445C113D0;
	Tue, 19 Aug 2025 11:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755603527;
	bh=SmknYLVSkkmQvTAgrwu7Xj06gw6T6+yw90I07oFg6nQ=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=t5KMksjkKQGQvtKIXsF08vRcMOGRNJx4qAdUT19jHQJRROLuu6xu3pWPsOqm/1l05
	 C+Fixuldjsot6XFSXzcqyqkoZn7VubA6V6zdOMTlqZW3eMH0ntWhwPTZ2YG8OmCe4u
	 Pf6h/UBGE6izIBGUFeAn0CA9u7bXwH9eUSyU6IY4G8roIGcip3WMm9pi9sKlZtEGrS
	 UpMTMU4KW0kW3RaAZNYubkNAAi3v56rojwQWgkXE3EbBdpgyn4rgdQU9eR2tRFvm6E
	 1y2JMCKDTYPPs9K6h15OB6HXZQYde3cZ0jXJEyG42nV1z5lmWCGvwuq8AW9SkXj0to
	 r7BSm9tueG/Bg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 13:38:42 +0200
Message-Id: <DC6DICA9SWYI.2XF7QB1FL32YP@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Andrew Ballance"
 <andrewjballance@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary
 Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 <linux-kernel@vger.kernel.org>, <maple-tree@lists.infradead.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 4/5] rust: maple_tree: add MapleTreeAlloc
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-4-229b48657bab@google.com>
In-Reply-To: <20250819-maple-tree-v2-4-229b48657bab@google.com>
X-Stat-Signature: ffi5bbudq4hbg135nytnhrawtb9b4ttx
X-Rspam-User: 
X-Rspamd-Queue-Id: 7319120002
X-Rspamd-Server: rspam01
X-HE-Tag: 1755603528-165507
X-HE-Meta: U2FsdGVkX1++ZSewy3WSkIr8183AxsUpYlcPisZDcp1q1n12TljwBtiun24UI+yxCWGbgDpOAJYNuxG0G81wdRI9ODnwHE3a6PPAZiuMFhyQacC97/dbj/idtWGapayFhZElk0iX6O3EvrMPszgn3XUN820eT+5yI6nmtJ2j2lcHkGQeHZRyF/Ililtly5B5oRHiq3m3TDIiF5hsa0EGpxQQ/sqUp6g0HEf/qsNqEDAPrIwbBkPjf71WAIuM3JxMELgzBKMWq3beeRHGn9OBDF8rd2DBE6oiW7bh7vGhf6LOqCKsDZQOjBVnxMOiTrKPbuhXJHomYufDEFQ5dO4A2fSCSt2XiI1RXKfzjB+R+1XSgHWISdjpH+vUximX9qEcIifK3rryEZ766H8jV/P63ZUaJL3Jgj1F9uCSP6hmwdinPHm2dgHC4RB0zhFK6vdbgB2C3K1gbAAlNy2Vd5tOLohd+J0BXyNRC1Ep35vy9eG1pQ+2urG5vEmWaRyUhmZNrkTDAKuMrIFO+fDBSXkqPQx1Gxqe8fX4yKemYJWGtXAC9Y9p8vjhpdsBpdqbI67H0Nq0bDs4UzR2uhDx8BayXt8sspyUeZUn3P20Pp0MYjh6l1CDNsWk5MdbzKDp4zFS7JQnjv+aUrkhwgp0YJWvcn/WvOf2ox89nZPuSlUe/lYiiPD490z2rBIR0RUSILhAH6gNE4EhInXZrzYHR8usKLgO0FjWL7v7QHItkwEGvpBpxzGUA+bRvjiJ1ldR9OOkV/7wEbrag7/Rk0K0zaUt2I7JuarOIvx+HFfwF9n+xjPS/8cTnyMHw3rLYKY1J8r5m6BazmiTy27e+Tv6NxS3Xh6GrEIvKVMiFn8Y1/dfk6LEB1Wj+aUhjNJvD/3YDd272ulE3olnT0Sdc/ZSJ7MLxVFLhoInTjsrFYkw3g6xscddkYpq+KL0E3toCT7LUdrMu0bzu8ousv67ru2n1py
 SbzNau+8
 QI+X477ZyHtHAtckl2SnC3QqBLJ/y8HrH5TWGL3G0/zE8pxrNufD4lCgbbgPV5MwRwj5favj/bYD9us5sy5D4CFr8m0otep9HnFk37OfGtnNFtOl5OFAXBN9SO9mjqQ+VmrJxLvdzZISX4Qi1fz4KLLjhptDpV1zS0a942lXx2jL+FerFkj2kfGbWLWUcUKVU2qedxQl3QBilpg+cG805VSzNNWkGv/D9mkvChBAY2Yl8qDusjo2qQTgA58K4mPFssmihsJITS8RTY53Ntnu8s4T+xbXxQi84ldKaFZcG4gVo+v8fZ1HrRbb5bC3ngG6ZjlWKCGP4YJbMTFxDX/4wQ0rBCPD8EjsqqEfwTwx9RwcoxQhJ1l/Bb4ss/+qwDMRgvpLdUBuK2lgLDsPFd3XEbSxClw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
> To support allocation trees, we introduce a new type MapleTreeAlloc for
> the case where the tree is created using MT_FLAGS_ALLOC_RANGE. To ensure
> that you can only call mtree_alloc_range on an allocation tree, we
> restrict thta method to the new MapleTreeAlloc type. However, all
> methods on MapleTree remain accessible to MapleTreeAlloc as allocation
> trees can use the other methods without issues.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Without the unwrap() calls in the examples,

Reviewed-by: Danilo Krummrich <dakr@kernel.org>

