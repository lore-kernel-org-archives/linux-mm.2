Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCDBACA0EFC
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 13:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9C18E0007; Sun, 24 Aug 2025 09:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD18E8E0001; Sun, 24 Aug 2025 09:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E218E0007; Sun, 24 Aug 2025 09:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFA1A8E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 09:05:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07006C010E
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:05:08 +0000 (UTC)
X-FDA: 83811671496.27.A5BBB75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 77E8C80003
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:05:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vL767a0O;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756040706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFb0+w3p/PU8Uh01PYLXl2lR7W2bA0wQT2K3ZDv6cVs=;
	b=gjUOkUb6aAzMG/kZeieEYianFz54Mvu5ZXqVbio9evCB+XHvoW0Ibb8LeTjD76CFCRyTqk
	CmfQ/wU490B/qRasgDbNtw9wu+uVxw4Ktni8UolNKPCzyUYjn8HHk7yAAw6dkz7DwWcTns
	fJtgpeEpbCcnBqjkXYoCv67QII8w8gY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756040706; a=rsa-sha256;
	cv=none;
	b=bclBgfhgN1BGsSLhyZtjgsgHMMXU3aTF74m0cCxjT0nkcaF5uF5m98j51weI3haKFJk8oj
	qKDlv66KgmAETUUmG03rP1F9sj/x5+bfm3rMwOnd+Vdc8ddPmNv5Q216+LtGRT4V+/uc+U
	eXvxeVXEEcF5dpVOBU8nqMrdDSRP0CQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vL767a0O;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52C05601DF;
	Sun, 24 Aug 2025 13:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F53C4CEEB;
	Sun, 24 Aug 2025 13:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756040705;
	bh=W5xOQKuMNnSf7+aFccIF+sA9AEbiG2iUEybWWHNvCk4=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=vL767a0OPT/0ICHw30ZcuWNYyRmxXsJnKrCo6leec5cPZPTC7AYgYzNhY5nAQCNGT
	 nqMR/jf0EuvJbaSeheX2vIGOY+rTAq2pyoO4D1blCxrHMmaCcubYMQEM8SX52ekfl1
	 1CdtRKw2FUlPujy92LLQe1fg3bguJRf1GvLez5LdOR4ucJkxTNLChTVY3gqHU9MKvO
	 6dqVq0XOTRinTPQQveASgmnLxmvV6RWwsm5i07QqGypsHKsaksYR1HKy/DsvYXVpvA
	 kUvbEqm7DPh12hhTXvoigsKDmlKdK9GJ9Udccc8Frss6fKQnZro2ceARBq9z+ZzEnT
	 wKiEo7rgjppFw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 24 Aug 2025 15:04:58 +0200
Message-Id: <DCAOH44U57K3.2CVDYWF8MJBWL@kernel.org>
Subject: Re: [PATCH] rust: alloc: add missing trait item MIN_ALIGN to
 Cmalloc
Cc: <lorenzo.stoakes@oracle.com>, <vbabka@suse.cz>,
 <Liam.Howlett@oracle.com>, <urezki@gmail.com>, <ojeda@kernel.org>,
 <alex.gaynor@gmail.com>, <boqun.feng@gmail.com>, <gary@garyguo.net>,
 <bjorn3_gh@protonmail.com>, <lossin@kernel.org>, <a.hindborg@kernel.org>,
 <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-mm@kvack.org>, "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250824120656.208978-1-dakr@kernel.org>
 <CAH5fLgjkqcyzoZD7PP2i4g4r2uqpdbDKVW5hLfm6c9ysbxkPuw@mail.gmail.com>
In-Reply-To: <CAH5fLgjkqcyzoZD7PP2i4g4r2uqpdbDKVW5hLfm6c9ysbxkPuw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77E8C80003
X-Stat-Signature: 636d1fgmrdzzx7z1rw6bdxjtshynmgo7
X-HE-Tag: 1756040706-682724
X-HE-Meta: U2FsdGVkX1/bEsXW4qvv7MXRhfFeTEWjezsKjc7QHUOpJHsZYdc8VhhHkGJVozevBBUIOVTj98BTeT8S5aZ1CqwVjwXojINV2x72loT6L0evkZshBhmAM9vrxVt3x4uSW/zlXB4cTeAP9VYht1Nsoqm4Tcb1Dt5BdMrTRnlBynuThbjuv8K1udpsq8EFLnIJpP3RxrZI39lBRhh8bQ+vvaCw+OuwTQxQvuXY36pggUy4duzi0N5ysY3wNodGzEJu7ppciy8kc/XOTwMnq8o33S/lCknffVYnK1o9mv1Jp8KQCUiA1NQzziankDBTpf/45xG25mnNsGFtb33Ll81/Nd5jc3CMi5BGy/ycGexON2xESxw+L2aqGL8wM/4HoohTMu2+Ap+9O548oRYYLCVFVXBLklZ504YcCPEdOYlqiGsyP3En3zUqXGIhzfb00ZNgvaj3rSPi4HeDS+SUZqcPWK4fdZj9qXux0rh4lACe46Tj6Hc6AWiQFOk9gzRpFVn6OvdZYMN8WHIPChZ34ZDpkM5hOHAGfBivEgdSKjUJmYK9A21Dvy5tEODdY4/GBah4FAkCTY7LlWUS9VdNJKTEhldlzr2nNuFI+tT2TU+w9hJHAby1Fhniz9Q/4yNDTPT+IUxqO85jtrGE3LThwhL4nxoKCji9dttNzl3BR9F57xOx22ouL/J4OVLb/H9caJehtxVzlYt6a7a9sjABSi9LKYA6Kq6pSDHTcysovhgzexAm2LAV5oAvmMs4aMeT7ZM8qJGsrYhPGKe4mPn/uZTv4g9kxagWN9zVdBJeQ4sEuy//vzeciPPSKbGahOMQQONoPLY+f7by8GOM9O7pbXyWQdbUmbfynEh1LUKFukCWmdk/bajoRtl62RuFlGqwbJhl7x+0j4VpOdbaIbluD+c6Cmo6TD1U6o6iEbenY26txZiOaaeEFjIppjh3h5nUbXl7BmQ4kW1//S9aHb24CP/
 7WfotMFk
 5shKt8YMq5LLdEiapZydr7OvZmgHdrj6AS4GPtBykG98A6wXoPw4rIh6tXTlRRU3Ea4eFQXj6Zags4EwBT7BlmGzmkItz1JnFEoBd+DYTNl+PoWDI2nG4Vxom5k09F6UUHwCzP54G2ye3V253dyqQTu3AxwkZZ87aiiO9NvSqt4l4c+Wg5vcoqt8xMZ7J7q18aFTmjuXN8Nw29haPvyT82yzMYTPhwm3K619aut315IUHhCEqx/GdvuQDtG1ECTS8NVfM7c6yY9ythImEYwcBQChVUdXbt9cJZtxi4jBNHXFKnjF/01ExJ9G/wd2QYRk9UpdEYRtLswf2rf3AnJEqSPyUfWZVltgp3zuYYxWYwhEaYtit991+B8UHl/czjT8Rr529FNXyD3c8rhmhUQ2QlUJeB8eRGQSxDcN3guhN4IfaupTykiOT/8HuU2daLhra4urj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 24, 2025 at 2:36 PM CEST, Alice Ryhl wrote:
> On Sun, Aug 24, 2025 at 2:07=E2=80=AFPM Danilo Krummrich <dakr@kernel.org=
> wrote:
>> +    const MIN_ALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIGN;
>
> Is this the right value for normal malloc?

Heh! ARCH_KMALLOC_MINALIGN should be correct, because the Cmalloc implement=
ation
should (ideally) enforce a minimum alignment of ARCH_KMALLOC_MINALIGN for
compatibility reasons.

However, double checking the existing code, it doesn't. Hence, the correct =
value
must either be

	const MIN_ALIGN: usize =3D align_of::<crate::ffi::c_ulonglong>();

instead. Or, we have to actually enforce ARCH_KMALLOC_MINALIGN.

Given that this fix is only for within the -rc cycles, i.e. we will remove
allocator_test.rs before the MIN_ALIGN stuff ever hits an actual release, j=
ust
using align_of::<crate::ffi::c_ulonglong>() should be fine.

