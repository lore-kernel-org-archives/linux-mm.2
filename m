Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89AFCAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D478E0014; Fri, 26 Sep 2025 11:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D748E0001; Fri, 26 Sep 2025 11:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CD18E0014; Fri, 26 Sep 2025 11:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EAED8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:55:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA5F043E28
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:55:13 +0000 (UTC)
X-FDA: 83931850506.09.937E5AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3E57720010
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:55:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UfdGyz2L;
	spf=pass (imf03.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758902112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWGkgJC1posmk65qeTSIz0WcZDqoy8tisz1bqW29YjU=;
	b=qxHdjj65Bn0lffF8BkbEJ9OQAumBYwaw6tRW2BXJXPC/+rbSuMCf4sXwqbCMg8JSmNza5q
	nmW2gPc4agHsu6cFKSWIp6FLXFab9tOgJjPFmSpNPKANgSQDS18SY34vEcEdplkpDSuBrr
	l/c8SwYa6gvTjcEnCAMWNbg1YrZohhg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758902112; a=rsa-sha256;
	cv=none;
	b=rI9YQ0u81/Hk+Mp45Kkiphpo4wSViEY4CAjEPUFzldOZ7jzx9cmOSd6nHDy6/w5p7+V4q1
	X5RIJx6KQQ8c570Tz25/bqRwp3SvLU9ubA2f/T7kTgTc61kxvDs0R56kn93skyX0v4i+cz
	6uuPtGHuZexdqMvzRV2TuUNgk/Z4sP0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UfdGyz2L;
	spf=pass (imf03.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 79D0B61E1B;
	Fri, 26 Sep 2025 15:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB885C4CEF4;
	Fri, 26 Sep 2025 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758902111;
	bh=OzxqoyTtf+EuffsezjoPsxJ6HfLEB0LUL8fkAFz4zrE=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=UfdGyz2LRLgLbrl9QdQ87SmP54QKRNkbEBjZH62cdbLcY0wKjDZYSqBpcrMIpVck7
	 OjRe+wFP0taQ627IV+S0nc2WG1kBNk81EnH+WdHqtIglLeRiN0IdppdxbRPFPtosGH
	 fvdc9vibD+iWzkv+PE0dyVuahncKOE/GFQV4QzKlip3/r/0XEuJcd6qlc4aU2wOwBW
	 P0KDG42crpJB7EQTwXezuZzuk7AC6RA4LMZPKFdq5OZQF31fA3/goO2CunOPMxwvdP
	 1vsiZI68jWTFV7AT1bxBwXXmnlAc+w/d7vHrL2zSrER/MZS3CVK2MVqQfkYs1O8Ufr
	 9JkA2dmTw7Z+Q==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Sep 2025 17:55:06 +0200
Message-Id: <DD2URCNO2P88.168J48GHSJRRL@kernel.org>
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
To: "Vlastimil Babka" <vbabka@suse.cz>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <5f09b7f5-e7de-4333-8de5-322eb6d93aa9@suse.cz>
 <DD2UB5P01XW7.1GW33112S22Y@kernel.org>
In-Reply-To: <DD2UB5P01XW7.1GW33112S22Y@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E57720010
X-Stat-Signature: woezjut8f9nfuu36x9hhmja9tcc5xdeu
X-Rspam-User: 
X-HE-Tag: 1758902112-9345
X-HE-Meta: U2FsdGVkX1++adeNQAel7WjnUpPqNmw8/JabpS/C1FMtp1wgD4IyKqyR8p8JFl8RZ4grEXQTfqx6qHEoDowXWyLuwELk9ajWfXc/znGWdq2wkHDyfDs5K1v8MEUVXqYuGz6I/DBeLAEcA8h8Sh0UKxZnBCAEg2CV5m6EntZmDjtz8WCZU+zKe882v8hkpbgxaJ4aamLbmhgNPC7h6RPelKI1jjEK40f5s4tmttUTe2S1a8qLuIrpJodSfm1e52kqhypKSPzq5i2UddNBB+rMYRa1oT17aRcE8RWl/H1eiXrcUZbCfU2JMV0DcLeG+/QBcWnwZs194788yIp433TUHXXO50zXIuQSaFJW8hqDvbbCUoSuACF8ZcO5UEHvv71mYZwBhZ/KqSmCm53v+dXqFJbpToJP4Kwk/WqQqwZEfFRBxhXcVIbjQK5psx6ULiilD/OlbkGxKAp0Q1Dipyoe/UqmoyKBCw7HwIwghXIbSwxYQiuUraWi3OVYuBhA6ZGds3KLxzV5+3k+ICxa8NybpnRmiTkmh0u7uveE1lWvQtHdApfUZ1u6eWsRIaqMBde4gdp7bB0+QVoUinkzwoLu1RbRUA6R2+DpISZulsyzSeC6MBK6eLwK1EGp/VhRdibH8KO1sjrOK7pgaJJtRNz8pLw1j+ujO/dYXu8Mf3E6wNCME3d17AJ3qVdKAHPEDH2Wh0SG4hr4EFDqtBjV5aLi6JXZRdoghe8fRMvoSNDBT/E2V6xe5KLuAwbAglnC49uUWRjEpFOLpLY79QyvCOmsVAdmQ5fnFBix4smFoeSl5wTx7hf2q0tWu8vtCE+lf5/JxL81DVfQXSVElVmgPsO5rvxIV9+g+xCNJ0jMYx9ItkLttkxqX0nxkgNO0FiHJylKJWu7/kzlObC4UNVn/zlWVYjmX6bEufLOEu2ynyql15mGWbVjwN94+OD6BJTb7pOF6rxh3HPeW2zOhPhNqul
 vCHtXo/c
 Dk4/2rGzB0ZzSOck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 26, 2025 at 5:33 PM CEST, Danilo Krummrich wrote:
> The only thing we need on the Rust side is that existing allocations rema=
in
> valid even if the cache is destroyed. Or the other way around the cache i=
s
> silently kept alive internally.

Or to express it in C code:

	struct kmem_cache *cache =3D kmem_cache_create();
	struct Foo *foo =3D kmem_cache_alloc();

	// After this call cache will never be accessed; leaves a zombie cache,
	// since foo is still alive.
	kmem_cache_destroy(cache);

	// This must still be valid.
	foo->bar =3D 42;

	// Frees foo and causes the "zombie" cache to actually be destroyed.
	kmem_cache_free(foo);

