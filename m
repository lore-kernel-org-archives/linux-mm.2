Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9379CCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274C88E003C; Tue, 19 Aug 2025 07:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D0A8E002D; Tue, 19 Aug 2025 07:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189B48E003C; Tue, 19 Aug 2025 07:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 06E878E002D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:36:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26324116A45
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:36:35 +0000 (UTC)
X-FDA: 83793304350.05.5714661
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id 83EE2180005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:36:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/SnfIKX";
	spf=pass (imf16.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755603393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gq15a1KyR2usNE5P/FqGOXri8nl83V2RQdCy/awNuG4=;
	b=vWLoO8R21UhzAdDkJyilhKz9CyKxvmi2UjUOGvkC+CNH1YOjBXbd9g8dTqoItkVa9QDWel
	urHi1M1P734akhxlv0TFkzpOMLNqTp7zGL6XPATufNLwSSXa1C3865Fc6RWEUTHQWMtE/l
	DXkXwX6Tu7xcmQaWwlYW4uM+WE3GMfg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/SnfIKX";
	spf=pass (imf16.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755603393; a=rsa-sha256;
	cv=none;
	b=KcC+h4Lmim3KlUa616whAQIFBTG4EdkMWH1DlEA3li/YUc0KPAr6MRTjfmdPVkWlZIeAgE
	sDk+dA47vu5l7g1yIMYV6/BZg223yWcMTGmxLvI3UI2rT4rqwF/Nw9MsDMPkBhsUEGP34E
	k6cE88lZ9HRQ0GtY0ijnsUb2GV/EDnE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 598E45C5603;
	Tue, 19 Aug 2025 11:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB6AC113D0;
	Tue, 19 Aug 2025 11:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755603392;
	bh=gq15a1KyR2usNE5P/FqGOXri8nl83V2RQdCy/awNuG4=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=Z/SnfIKXBq+C1lpj76Ja2GJGykvaxpekFx/OzepNZgSlbwqq0mcmraTWD2dHctzDd
	 yknCbUfF11LgEzF1JJt+WeJ4BkqBA8cTXKlxc7uK49QurnBMC9DcC/wibGkypdgO4y
	 WvnBJlUY8QsX5EFH4givhy0NAl+FBAFHzgSfoKipybjPQDt3W0bUc0JihHx88q6yb5
	 XewjUWK+7Fp3STtrfZP6vn+TbJ/3tP3tJLuW+1TkbqEaOq4WpQWDI1uTo86LnVEih5
	 X9p149XOj9EE5C4DsQ1HKhXR5YVSdvzyceUeze2wcftEzih16Itw9l48G4IXPeimHc
	 iN7mVjJgx4jOA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 13:36:27 +0200
Message-Id: <DC6DGM7E728G.3KM1EOLVJNR24@kernel.org>
Subject: Re: [PATCH v2 3/5] rust: maple_tree: add MapleTree::lock() and
 load()
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
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-3-229b48657bab@google.com>
In-Reply-To: <20250819-maple-tree-v2-3-229b48657bab@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 83EE2180005
X-Stat-Signature: p43i3znmaert76me5y5upcrn4nwokfnp
X-Rspam-User: 
X-HE-Tag: 1755603393-632002
X-HE-Meta: U2FsdGVkX1/TIzA57Pib8CYCvDv4v8/A4A4S7Aedf9E8P4kaPJF1g6spS1tWHc/Vg+SLA5K+SWDGQgdsoDPEWnrS0KtiM+OfXxPz6qsqF0WBddj0NSUsqS06ge1TCN9X8z091BKjAOBGQVBoQ+v3mwEmpFN5lf1hnv/5Phd2toVKppHay/9Aeif6txfuzwcfnkCmVjMIDzpGTOUYdxQbkpPEoCucUIxPfSklBxvkTpYIZG/4KceQzi0aOW59JqzQYhqN+Q4DLXtznmhbxYhD2KNQVGVAXwvUWPALqrKkyhdE+XCi/Ln6uNKZZilVEkt4jyDgZ5s/+S2BmFL1LuQy8N3R37w0fSlrt3VKaByoaXUeJtwaLeHf0ydPVuEbDjZiskD/yR6XaKwzq0ZJQoxYQu/ewYIlyh1TnxTTgQySKz/P6J9+59TFGoqttJWnYd3/CLT9tfoaKfl7vPp+w34Zh8qD+41nHw7+AaJMXRaS0XFsPQvs4OIuNT7X2EOp3yLo16vTllmBhpJmhAr4CtPBVSCiVGPpE47/18Z8ftNTDAWqQ9ThtuTJdFXkiE6pTgcj1AStCrBU39SA7sjOLwd0VmPbLo4D3OAlkR9m7qcFsNdP1IZNvXV9fHuJcGoN76xxoOGe43yQ5tetDrYBpbEo5TPlk8VM0fO9JKyPowuv4W/QxZ7rJu0RAJSCSXbh0KulH64wGdb8ONgpQFgWzTl0idd+s5E33tWT3EPyIVWZvn5U7EipQF6oyacWTiHHAkJwruGRmZ2UTwEvRn8HJ5lUAYGnIA7M32roPi/Hn90MRDmU//cx74LNPjL0AS5urMmtSvs6Ynry04bREyxQ9N6uyL9L4zlUv/Uo8Z6jH4XI/2G0glSwLCGMjudh64kmBl+D+vEpSpBERPRvxg3Q6qVWhFlUePJxi/c/KWHkBsqL8O931VqMsn8LlikL2Pu+y8wf1Vum4DUWXiajR27DVKG
 qGNOT+o9
 oTlGw2Y+F0zA3keYPhIHMjbmK3Im2o+ewI6S5ZVtY1mgEBWCwIR+A6tkZg4wlgHxYGBmTc2qCfs8TI/dVgvg1k+3EJyD5AnGAY2ohW4l5ZqqGpnDyWWxKg3Rf63Rf1PZYnLRScnFHeOBGoRIkJV2tDHJph6ZFW2+vtZevzwkObztRZ75NeNWECSYifcSYRfQaMvjNbDp60hqxu+FZQW9gCw/tbZGgXY3GGtzuCDDmmi4Isk7hv7EDIXF5KjPVtiTVAEfd/vit9LS46jBRNGFYntveqK8nXYcNue8mf8kFGvByFiyBN66mmxJvf8JKTbQwSHlBa82b+jLrdR3fhMyakNmloWKsX1jVm6AKjkBNqTRA1wQy/D+/sHrlMmaFNPcmq/gANAT3//4FeDQlGcIpcllyPsdrxSLd2RwdMKIDdITbUMttizhJoq7ESFAHptPAJp/mlvNw6bKUQDc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
> To load a value, one must be careful to hold the lock while accessing
> it. To enable this, we add a lock() method so that you can perform
> operations on the value before the spinlock is released.
>
> This adds a MapleGuard type without using the existing SpinLock type.
> This ensures that the MapleGuard type is not unnecessarily large, and
> that it is easy to swap out the type of lock in case the C maple tree is
> changed to use a different kind of lock.
>
> Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> Reviewed-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Without the unwrap() calls in the examples,

Reviewed-by: Danilo Krummrich <dakr@kernel.org>

