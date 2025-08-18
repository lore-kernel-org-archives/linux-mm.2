Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 955A3CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238AC8E0012; Mon, 18 Aug 2025 08:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FF38E0003; Mon, 18 Aug 2025 08:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D888E0012; Mon, 18 Aug 2025 08:03:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 04E6D8E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:03:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A06CBC08CC
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:03:13 +0000 (UTC)
X-FDA: 83789742666.24.46DE1EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id DED1B1A0010
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:03:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M2i//Nwr";
	spf=pass (imf19.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755518592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBNCX6vpnoJyq43vEYOurR5ZztTp066ARnQrar3Q5Lg=;
	b=OITunTBzmtwDt21A8JrSHuChJ8xDWNqni+6e6HRGfVdyNQd4y4OhldvAscm8K1rHWlQSIf
	+/re6bWnQgsrwZG/zEWu612ImajskD1aPeirc2C019fKjaFnIUr7q7spE3ogKcSwOKSTNj
	1C/yzqkIqpfFto4UTdxxsEJfSkYzvOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755518592; a=rsa-sha256;
	cv=none;
	b=NSijB/Q9HB6l4iSH8KTOgWIop3Stle+EWOEpCakp6G6hMhbBH3rrF2vi6oTinu/dh5Qvu1
	8s7SIoB016y6bWVdOp85YkL060hVqo6hqw7mMAhk26f7q+0MBcQYgi867UbJF26osoAlRU
	oWAPRc7C0bF+kxAqLq+8Y6fF1kQvsVw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M2i//Nwr";
	spf=pass (imf19.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E1BA45DFF;
	Mon, 18 Aug 2025 12:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA215C4CEEB;
	Mon, 18 Aug 2025 12:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755518590;
	bh=XUJOys1V5JSAwLbQ+pbzrv6OniPyIsaE6/aIrkHotsU=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=M2i//Nwr0MQypaY5HSo8V6GCctpILdUsuP/NbH+3/aqLxFUmRxb5jOsv4eop/2Wbf
	 KwoJGggrOTbFUZijWl5XBZZqpWFPj1e840X6wwU5U6ZMFpHgqtAuMMiSJ4Ygpl7KfN
	 P98bE3LNU8eYH5Ax3jzHaPMIuQwIVWqw4Ln5V3QMQttbg6TYyrzr77yEpXyBWn0poc
	 aMzeR5V4h2ZWERmWlENyaQRtrvdINMCLONyjPISCI4aPqMu7sqcIVh/aJdT9GxFdWq
	 YT2GqLFh4u4+w04QaYp9jFbzE6EvddDvWlSuZfW7IBN855HGRuGqwAR3+B0u0DJu1g
	 mp6UUhpmx33Cg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 18 Aug 2025 14:03:05 +0200
Message-Id: <DC5JEGJSBBCP.38DNGTBOVH9OB@kernel.org>
To: "Thorsten Leemhuis" <linux@leemhuis.info>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 0/2] Take ARCH_KMALLOC_MINALIGN into account for
 build-time XArray check
Cc: "Alice Ryhl" <aliceryhl@google.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Matthew Wilcox" <willy@infradead.org>, "Tamir Duberstein"
 <tamird@gmail.com>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, <linux-mm@kvack.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Stephen
 Rothwell" <sfr@canb.auug.org.au>, "Linux Next Mailing List"
 <linux-next@vger.kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
 <DC38NDRET9NB.31UDI8FHB7WAY@kernel.org>
 <8aa05f08-ef6e-4dfe-9453-beaab7b3cb98@leemhuis.info>
In-Reply-To: <8aa05f08-ef6e-4dfe-9453-beaab7b3cb98@leemhuis.info>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DED1B1A0010
X-Stat-Signature: gfggmqa57kkryf4u756qnoywoied5ueb
X-Rspam-User: 
X-HE-Tag: 1755518591-311315
X-HE-Meta: U2FsdGVkX1+6SbZtqiQvpkv+ee16iJHYNg0kC+DGmTBLYf94Q4USzhc3FeNlJ2tF5Bw78qU2TEg6vRGmmyi8W7oI5SXr3zMoct70vkGVdgllH4/HuVogTvCJQVVHonFIcmmVuw5aTwCifuwNgMONEpqRsbO0WdlY7+pwI8qPgE6nvamD1sCXckiLBi80SYQ6t7UL+yO5FIVW8K6kFvtPGEBmHOGCrPM6yqEQ6FMr3NdjTVEZCCqL4IY7W+nHaTAW2vj3y15fJ7uky7VvWzhITlmt9k+327aC3u3QBhNNs5kkU9h+W319zG0zSAjZQP5ywJ4md8oGx1vmVIc5S7+uCJsk8F7rAx7xj8apJp0B2wTu5EcHmcyIKWpOXp/w42mydI1noQLsfSqJ5rbtHsyjCARuOIjSqEc8i9j4yhXPP3iJRgmUGXImPFFpF2BxUhcZOzWFE5Hf86NfOfOY0qiNo7LDAWku8+TRk2sMJqRwoQCySFRq/kNIEmBdvyBftL4JtqfRLS8QPR3YgEiyI2vHTrZ5on6OFPB7nM1CZPduMgNugdOh6TVLVPADfLRLJZqkHV+u7OZRz6x2qAvsYuk7UiCQXDuiBLiFgUc/kLA7Vzai1XJc1PWOYkMjmqTVbPfV04KcXs+ncsiF62trDRk5TGMBtiO1MiOPgB86RVOuPcLGjQzzgkoa5fR+LHI7n3MZfVU3zPu3QGeB7P/7Hy21dL25yaiZnyZ++eUBqe6Ss7A9uLhjENJuC0M7R7CNi9gnGEm35OPVwXCMWd+6SzkfXUdVCeHgirYKLgWxWTcVGqXQXeOz9S4h7a9CqEfC54ipQ5GZGdWcM1ND6YnXwMK5L3jMwsAvA0T84G0b/j5VR547Rees6UcPszFN+zp+1ieLQy5K8/3G8oMadFU8aCviOQsstplhIFmpBHFEn0LZWvsC6kzf9/H9NWOh5PmoSbx1N1X/x635UqHDxAGmge3
 5vEy9vdf
 6zR1xvi8gPYbNDOeozdBKp0JDNgFLK3+0QWQWkW8tCfJKyWXH8QWEqD9oJu4zbOOHHWs5bRMA1B1yx4Wl2kL+c1wi8kDbXAOpjCehLEA2aWdoyxNIKiOs9JNqrl+LQ4S/IBYWawL6/lgm0L1S6onscYvm7qb5JmCRE/KlbvglDvrZwl55iMZVVdiesnCxeY4oSOyrvg8KMB36KWnP5D8N03LQwL+JV6zyws6nVjEk9rOM3OiSunhp/X0rm+7cv1L6EfkTqzvY0X3dCvJm1WvfKT8EDGjIPol2knEAZVaf5873XBt9oUjWLDJK1IbuaVVSEzH5dCtxejcw7j9+oZSmjRtyzsqzl9f+tVWuH6SGsY91mkeZKeVw1EsaJ9tuIxvNRtaMRAXr4822lL5s+/iLzmkB5/cS+1c6dfPOM3yQVdBv5th/oB+R7psNmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 18, 2025 at 1:09 PM CEST, Thorsten Leemhuis wrote:
> error[E0428]: the name `ARCH_KMALLOC_MINALIGN` is defined multiple times
>       --> /builddir/build/BUILD/kernel-6.17.0-build/kernel-next-20250818/=
linux-6.17.0-0.0.next.20250818.423.vanilla.fc44.aarch64/rust/bindings/bindi=
ngs_generated.rs:134545:1
>        |
> 9622   | pub const ARCH_KMALLOC_MINALIGN: u32 =3D 8;
>        | ----------------------------------------- previous definition of=
 the value `ARCH_KMALLOC_MINALIGN` here
> ...
> 134545 | pub const ARCH_KMALLOC_MINALIGN: usize =3D 8;
>        | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `ARCH_KMALLOC_MINALI=
GN` redefined here
>        |
>        =3D note: `ARCH_KMALLOC_MINALIGN` must be defined only once in the=
 value namespace of this module
>
> error: aborting due to 1 previous error

Thanks for reporting, the diff below should fix it, I'll send a patch soon.

diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
index 0f96af8b9a7f..02b371b98b39 100644
--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -34,3 +34,4 @@
 # We use const helpers to aid bindgen, to avoid conflicts when constants a=
re
 # recognized, block generation of the non-helper constants.
 --blocklist-item ARCH_SLAB_MINALIGN
+--blocklist-item ARCH_KMALLOC_MINALIGN

