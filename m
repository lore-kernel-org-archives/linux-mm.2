Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E44C1D58E6E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 07:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096F36B0005; Mon,  2 Mar 2026 02:19:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044766B0089; Mon,  2 Mar 2026 02:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68B26B008A; Mon,  2 Mar 2026 02:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D73236B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 02:19:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E883C2BF7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:19:06 +0000 (UTC)
X-FDA: 84500271492.17.B362915
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C0C261C0008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:19:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l9ZaeF4a;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772435944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWFUYHylqRFZaRm5r8RrLRDa3YLgSmjWVVLiN7LHGy4=;
	b=XLbD/PKDDy4EozCxMtFoKBnBnx/05Q9FP7WViDzRPT8tYQWp52N+OENXGPikemn6sB60bz
	enfnF74bOpG/MWNYxCHGJml3znSl6R7ER8D6Qx78hYHtM9zQPoI2k5jQwRejWYFgw2YRLv
	7hL4dDxcGyjXcDUbqMZMtnLcf2grzyE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l9ZaeF4a;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772435944; a=rsa-sha256;
	cv=none;
	b=qgTjHtraQmoBPg8l6Kwyk0i3GyehfjTI021mrNAR/tqHYIEsbBfYq10VhBhEz2xhKXyueW
	KnS/cLBhmnevjYRML6lEe1OLQ3QSZwZ2jSryDexjscWsY1GkBrWP1rWMjugq+5uNNr5oQ1
	91j7/RjiHmzD7ZP6lt1gEzPOtliFivk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2AA643C2B;
	Mon,  2 Mar 2026 07:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D3EC19423;
	Mon,  2 Mar 2026 07:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772435943;
	bh=IWFUYHylqRFZaRm5r8RrLRDa3YLgSmjWVVLiN7LHGy4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=l9ZaeF4aPU2R5rFFz1KzYT2AzZwYDAcXSFOWGleyGX4IJCSYh3ey9X9MFaec25Jvt
	 R41n5ogriJLHLbTnbAhRUlTENuE8zHqJZ4hmXfIoI14lQa1CZ833Zh2NufwlrmebRa
	 uRquDMiQ7euErjNofmy94n80bTQAgtr9fYExYWtiCa7u6OSqVRwgJZtiI9fbt0Id5d
	 X42If6KFdaneLbuS8GYtRtOBZ+FwIRmVTq7yyXCkl7+v+oM/ByWo3UXqtNZIjzLubr
	 CxI1q1dwT1MHjvxnZsz6xERpo7UqyUz5qw5zjzCMpgHhrhI/5JG2NlqgMLZulaFmBF
	 wrN8cEwrndjoQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Benno Lossin <lossin@kernel.org>, Gary Guo
 <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin.linux@gmail.com>,
 Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Uladzislau
 Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v16 01/10] rust: alloc: add `KBox::into_nonnull`
In-Reply-To: <DGRQNTVD3N23.33347CYLKMKEH@garyguo.net>
References: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
 <20260224-unique-ref-v16-1-c21afcb118d3@kernel.org>
 <eeDADnWQGSX9PG7jNOEyh9Z-iXlTEy6eK8CZ-KE7UWlWo-TJy15t_R1SkLj-Zway00qMRKkb0xBdxADLH766dA==@protonmail.internalid>
 <DGRHAEM7OFBD.27RUUCHCRHI6K@garyguo.net>
 <87ldgbbjal.fsf@t14s.mail-host-address-is-not-set>
 <DGROXQD756OU.T2CRAPKA2HCB@garyguo.net>
 <DGRPNLWTEQJG.27A17T7HREAF4@kernel.org>
 <p7rsBPaYxHKSMFCYVUFY5hdI1H6jxHK0s7lxLQkqH4rylM6yS03Yt52SCjiTO5qBVUmc41ZHZ7XZ0_3w_U-O0g==@protonmail.internalid>
 <DGRQNTVD3N23.33347CYLKMKEH@garyguo.net>
Date: Mon, 02 Mar 2026 08:18:47 +0100
Message-ID: <87ikbebsx4.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: C0C261C0008
X-Stat-Signature: 84k68ouztt4z8mmh8nq88qq3yu7xmy59
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772435944-848488
X-HE-Meta: U2FsdGVkX19tyPHylxYhwmNLLu7uHFEp3NymY3s7H9gVZXcTDHplMTuDVYUGW3jUGXnt29gqfuvalkvNino0Un3QJTyaFSun5vfMVxyoT+OdmgzpUHb8iGg5nZtfRoK4XPpabc5fuAaCEcO8SI0hn5eKoMBseEi49Gvz+AF3wZ3zizx4gCgKvkpV/XvXeJfgIQxBxTXKCWOSk7DVAV25lGOXOE/8dksxpy5RELQ5Au+Wf0KQBjtBnQlk89y+7KHykwCyEz4lhx9cepUfekuqZrKI17frWk4Uq5vG6vFIsIWwnKi9Jjq0odGkOg3MV4zZqds94zC9ujY7ptnQfzNGzN11OQ/NSXQWAXkGYwzMSpQbc6yIRpC+cU3JjNzm5WpOiBvx7JTNadGAh/IqOMxBTf9rjkt+nLr/c0yv14ayDse1ohdUczaESYHZqnLJOv098x5iegvhDAv5mbQlBXHtLXTInK+nmY59zGcKUFBn6kknnfmjcEbCqlkBVmKvPFloYaP+pKhdrcW3ZtZOfsC0cZzYNUkqzM9BCNT6O2r75cV9SYApXio+H02VVOBX9l+16GM49XORDiHHr9t7jR4hs9jdniDuBtxt3iJ3Bb/rGhRcb7mTu6H2MZP4IxuhwwIN96DdghxBjsTEH0MGOV7uvu54xZZTEcC1UdOpjVYlMhvGOB5wFmqTqpWI2bNQuekteRG86RC4lPsX2Nxx5D2y7jPL5WnqHqoxUDwBHpyi3EP1G13xqI2z0zGZYcGQml4Q4+D8NrhQBEAA4bbevG8unHPDL/bYod3DWXM/MeGIHWzPfZAnbvLDEjaZukuDPr1hSSvzSP1CBiOroDkl/YiNrH4bEFOVqkddgiqZMt9ciDV6Cl5giPKC7ObC76bTAR9Pi3B8u61X1rb1+LrcF6FFy5km1oqkgZsO+XJxQXz67AknYY7Xc4wDg7ORX1Rf+xwoxKnLpf2I0iUGOwFTP10
 s0Tb2vzA
 rVGclnixakIOWdZLVOiJvScu/DmheKilVRHb+r5me5y+r9JZFKxaWf2IaNvNPKNHdIWKI24EEz1IsVAjLu3mWHtma8vX/K4We/6K8yLV3Fn8kXjyrZ8gkIIGbBUWhDLsKwEYLv2PHsMQshl+WWZrKBfySmWvQdf044LP9cjj+sd3Bg99GMGl1eUbJ+6YMS9u36MFmvvgTNyqhL+TZDHFlh8imyieRGoxDRnfTZfquq1Jog5xPLPgfCMzEUOFGC/e8FjRFkB3IB1774wIKkf1GivFkxWH6WCFT4DqUXjrtrtAAVL0QKTE0xEErSFrbqdeRSa6CpVNqGofIQM3T7KqSoppPlodXNq4cGxAceRuOFyBIzGkgM8jJ6/fXYyFkNU5KKL1Wqy7OoKPCxPDoHufYOPx0ni+YTqiX2iqXIvjkB9lLHxQgV1fNpITiNu3ol5iVqVbH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Sun Mar 1, 2026 at 7:59 PM GMT, Benno Lossin wrote:
>> On Sun Mar 1, 2026 at 8:25 PM CET, Gary Guo wrote:
>>> `#[inline]` is a hint to make it more likely for compilers to inline. Without
>>> them, you're relying on compiler heurstics only. There're cases (especially with
>>> abstractions) where the function may look complex as it contains lots of
>>> function calls (so compiler heurstics avoid inlining them), but they're all
>>> zero-cost abstractions so eventually things get optimized away.
>>>
>>> For non-generic functions, there is additional issue where only very small
>>> functions get automatically inlined, otherwise a single copy is generated at the
>>> defining crate and compiler run on a dependant crate has no chance to even peek
>>> what's in the function.
>>>
>>> If you know a function should be inlined, it's better to just mark them as such,
>>> so there're no surprises.
>>
>> Should we set clippy::missing_inline_in_public_items [1] to "warn"?
>>
>> [1]: https://rust-lang.github.io/rust-clippy/master/index.html?search=missing_inline_in_public_items
>
> That requires *all* public items to be `#[inline]` regardless the size, which is
> excessive.

I was thinking something similar, in clippy or checkpatch.pl. If we
should always have this attribute for small functions, we need to have a
check.


Best regards,
Andreas Hindborg




