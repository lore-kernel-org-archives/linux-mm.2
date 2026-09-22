Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FC2C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59EFC6B00B7; Tue, 22 Sep 2026 00:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575CE6B00B8; Tue, 22 Sep 2026 00:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4696B00B9; Tue, 22 Sep 2026 00:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8A36B00B7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:21:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 996F3140368
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:21:19 +0000 (UTC)
X-FDA: 85240098678.17.E1A254D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 13729120004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:21:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CEuQS0Q7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CEuQS0Q7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050878;
	b=KufAa5cSkHhA9SO85h9NngdL2uxCWEs3J2s4lffhT6Kk8giMxhE1MvyTjHYDm7b8bGoQT8
	aCNDfM/e+Zw9S72Q74jh38axWOqa/27bfgC9y3UdNOy6oDQRtb5Apoaa/hplBz87eUVP9l
	h+olqOAaou1464WXq7QVzg+rj/jHklw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050878;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1W9xFoCuwZUjrX1fXkCIP7Uhyo9jgTjhsWMFg7PkY0=;
	b=bFlfy+kEwyPW53F9giOmii+YQf/KVwrx41oL5Q2XxFPGTonSfE46Z8pEUjfMkoXb+Ceqy1
	MzrQPuPWc/fPO8wVg2LVzvFm/25NQXfa8I7B+K5Up6Ju++ke/0d06TLazBKIk8alWtYQ0F
	1dloPNCHR+be6lKsHdvSFlDKLhZQhsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82DA5600CB;
	Tue, 22 Sep 2026 04:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F10C1F000FF;
	Tue, 22 Sep 2026 04:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050877;
	bh=Q1W9xFoCuwZUjrX1fXkCIP7Uhyo9jgTjhsWMFg7PkY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CEuQS0Q7o4ut1GNVSswUL2EiY8XWOZD7AYtoTdLN6QalDPwf1r3kp+JPhzDMHV1Ca
	 +1grgSCuJ3ouBvTHSvpgQRe9kShQ8HW4agMTW8J2kQWFybDH5qhBgBGVqFFW8ZHLLJ
	 ZQIqhJcQshc/Ty+POHhm13ldPisTnzR508Evf5pCTNeCdIvlwrVO+2RPjnOp0VRrz6
	 EB/vuxDHTkLyDTLxx43k09cZltZYpYYyLjmYkjX/TbMfleM3Yky/sXsYDPhPL+Vbvm
	 LfbXEi3Cu//m2sRWOH9JkwJkKmsl/SEjRQeGxXkYdYcIBWihbFAvgUr5pERL3PzU9J
	 CtAsdd61WMFpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/4] memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
Reply-To: sashiko-reviews@lists.linux.dev
To: "H. Peter Anvin" <hpa@zytor.com>, "Saravana Kannan" <saravanak@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Arnd Bergmann" <arnd@arndb.de>, "Baoquan
 He" <baoquan.he@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Rob Herring" <robh@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Alexander Graf" <graf@amazon.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Jonathan Corbet" <corbet@lwn.net>, "Borislav
 Petkov" <bp@alien8.de>
Cc: kexec@lists.infradead.org, devicetree@vger.kernel.org, linux-arch@vger.kernel.org, conor+dt@kernel.org, linux-doc@vger.kernel.org, robh@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
In-Reply-To: <20260922041321.233986-2-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
 <20260922041321.233986-2-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 04:21:15 +0000
Message-Id: <20260922042115.8F10C1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 13729120004
X-Stat-Signature: aiho5zocygjh8gpm48fmmxee41waaes4
X-Rspamd-Server: rspam01
X-HE-Tag: 1790050877-480512
X-HE-Meta: U2FsdGVkX18vMYSWUc8/techu6L8S4SwWQPAWgUiU/gwY7OPwmeTz5XHLHcbtfipyAEVvzWBKcHM4EtyYTSQXFxC232YTVz4w5os+GQHSU0YKB2fjzzx6JybZVi1OSotJhK4AIj11CGFW1l8gJFqZGLTf+cj1BFxlIv1Ygc7s863xOZQbL/VPRPttJd0Dv6H+P3fNUBDTOmdVvvLn2GnLVnJgmkIqpQ4ONrORMPQZzwEEUEb0U/eCbdBwo2VKCJ2DIjcq6y44MZudtZmF4Hfag8gpp1MiFmpNlcFo/3BvntRc8+n2HUm6pklyxR5fG682IIo6rYWqsJzjsv+Sx82NSAYM2bDbYw/te5KZ/mvjtU9y18jQfnqGw1B29mQPyNMWKKfiwG5AwPdd6CSsVe3fALxJ3CwpYodwIB/NKU9hY3wIAFFGMjM6qF+h7FMB1O+Up5DpXYAJp+WuQoO2NAqRjGNyFCPiB5bxWc7JNvGcho/2ox88B+y/wPYgJgCr3/zc1ePtfBj3enHv+FWq7umhA6zpgk0dqGmWvguuAdSWsuI8UNZrJnlhDlA1Jj8Kzzxre3bQsiIEspA7hpZwKiaeC0ic0D/YsZ4H8bo0+xi7kygvug+g4gwkRCu+W9+6U7jjeqKdL7pBkM3S9MYjTUbXkF6QYIiQS5+y1wSDFFQgMgpwvKiPs0ce4gnMaU/JM++AAMk5yAb5m2ceWtQFjupWZ/+MG6tOYcaAahP4uEHVXmZW4GmpK7ENhxpnkhdhvWB92i+I8hu/zvdO34jc578qsa3/jwXHPerafAQ8X+NrZTVfVHY2pJw3nwIVzNnn5hEuhaFzE0y2VsRVVtMypOYxs9x4/y9rpvQA7eyNQYILEsefL7Cx+Ra7vCgFuHMpLmMzNOhQGn3YaBwA2mtCgBnw4EO/2ndr6OOS9nntzmWgyJ5vEDgSONUso83LqTChcN3gYBDtNi8uvm3w9qWTAM
 YRnYXmKu
 6jaqp0fWtmOqRMtJ0hsF+2BQVpeIA0Zo/T2jzJgDHvk08DxztqntoVbHzM01DaVg8ZB3RuOL4f3iO1ndiHvm9Krk8As06vkl6hg/GJUS/B8B8kZTjVUdIAqdpWO0v/qdpI/40X8v4eOkCgtKUA78uFUqBYGvnhFeYcdQmBrmCI8VhQDgObONx8KOo+47wUNtw4aFrzF0/nR1e5pl1D+GYYRKB8JesXTte87xHuUJXovdyrcFK5xDXkyi0rtaYeE3qQruJja98xAwOyPGuOl4/D0/g1YW0Hn/GFulo21VvLdOJofYvHm7q7mPp2l7XlNcbMzz8ADHE19vTC7RNPNYkSCNrBaghUefOkMBw23eIondysm0nsnZWJFEg06R7Uex9tH4kZmqmlmQvkFl6CaiCNbR7U376l7f/NPnIu3NDIGswvM2Ob8uOdcmf+YqS7Jflp58o9QlxZrhp1nWk9Gyy7D0RwnCwmGOmrW1UjRU/OPicIFQBfGfyuEp13GYf+BKNElwX3uBo814Qz/NMpqIe3Cq9vZ77gmAZV832WUs+vQEO+SPvZSxc2woPutr4dLMrapSeezOXQ2bwzobQojm+GSYnTZ5iJF33hG3f4gaGoJDu21H9iZDHpkdDnmCrkNFv5vS8EnSPsMHQkLTZDWNaHLAZgAjGSm7v/b0gQazpnEx/MB6UlaoSCXFUdAR0gjAp2mN2qlbBObMjlQ/c7jx5jHgRwRIc3VIqaLLkxayUhpQfUgG/W+cAjlUKHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> This config is only a proxy for CONFIG_KEXEC_HANDOVER. It is only
> enabled by KHO. No point in the indirection. Use CONFIG_KEXEC_HANDOVER
> directly.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922041321.2339=
86-1-pratyush@kernel.org?part=3D1


