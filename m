Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49907C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D996B8E0054; Mon, 11 Aug 2025 09:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4B088E0045; Mon, 11 Aug 2025 09:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38D88E0054; Mon, 11 Aug 2025 09:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACEF78E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:29:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76F68140188
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:29:47 +0000 (UTC)
X-FDA: 83764559214.28.568472E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A49201C000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:29:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k73R8cds;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754918985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZ3wvkv63IesEvvPXCEb04QsAfvpGvn64Li4Jd/16Tw=;
	b=1k+JZA3GgpSJ4/BTFWmfbC3IQidts9cijx+YTVeMg5e1cb6522HfIocRugvgqWUgz/wNsy
	EEsOZQ1hpj9jMHhY7IXJImCFdtuu7pkHABdD9AqHh6whj45u8G/pBG5VIgTX/kvqFz2QZV
	EOegzu8k6YcMhtZ0JTcvxBrg82ZBy2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754918985; a=rsa-sha256;
	cv=none;
	b=2WfLMIPeHJ+WeOcDR86cVOQH3YorbG4ZkyCUHGO5I9HVp4g1PIHd0KE593XkmKhpIuht7f
	6EP7nz2GzwWMv4SzWw5PyctlZrl9viQpZRGYsuN213/CQlBWdppu1c61nyZyM4rKTLEDZM
	QMBYSFNrSwoMb8C9Y8wSTfHvjKr8bOQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k73R8cds;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 33CD345C2E;
	Mon, 11 Aug 2025 13:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6043CC4CEF4;
	Mon, 11 Aug 2025 13:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754918984;
	bh=IZ3wvkv63IesEvvPXCEb04QsAfvpGvn64Li4Jd/16Tw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=k73R8cds/dBvx3cph4Kg0NCZBBbnknZoxSbx2nq/NI7ojCzvIDSO7V/A/R7OAPRbo
	 SBX8CwdI96xiePyMRuuhmTKml0PmrSI7u0bNC4J0WLMuABOt8XxvGPC359qU+SgsZn
	 sufctmnONQmCr55g94CfA5HFynUCR8XKvr4/J99Cwa5W7toHYWqMlDISFlzilRWHmP
	 NgOG1uKS6PaA8sSkV5mKYHZ/vxFrupDwxAnUDE5nhTsGNJ8f2b3XmtP1h90WVEiYW0
	 l2KQDQtseCI48OoicKSnYBDYlhjeVRi9L/ALadjmc60pKCHd/gXQO2imUym4G/7qqo
	 FWCxv9vo5kgbw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Daniel Almeida
 <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@gmail.com>, Janne
 Grunau <j@jannau.net>
Subject: Re: [PATCH v2 2/3] rust: xarray: implement Default for AllocKind
In-Reply-To: <20250713-xarray-insert-reserve-v2-2-b939645808a2@gmail.com>
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
 <VsBkv88RSMICpG9KPe3i9REC7ElfySwTUyyWRfk9nGea5F7RxX7llxUd-lfFvGvw6fTVIKo8NOfWIt51BFngsA==@protonmail.internalid>
 <20250713-xarray-insert-reserve-v2-2-b939645808a2@gmail.com>
Date: Mon, 11 Aug 2025 13:07:37 +0200
Message-ID: <87sehyf75y.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 9h8x9digfya3imsbx1891tp4giawatqy
X-Rspamd-Queue-Id: A49201C000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754918985-966576
X-HE-Meta: U2FsdGVkX18GAFUj7kuu+iToZ/Vny1bgOnBG4SUwZsq1E9pHY8H19J9L0S+ytNjwst1VJx9HJulHF4rsXJSBVtBVPd97ZyoXJvJVcT8flzhPaoBN3XJivdK5C1DF+G1Q3rzQygWA18qB++ThGVS/2/CK73uhvo+lagRyhY8Pijj6iLqCYzaqfXLXM9JJyj27voT+l+pspnyWKrGTYfn9cs6xrTLwE4nXLVAbcH7FIpy7HRjJE4nvdc/TOzPEARBvcWeHZ5zaMs6JQulyKNUZFUmfkNeKr/alT9e71e0UxFS89iLUam1s/eQigTOi4i+cgqg9nSV1P65Q/reK++hYMLQWGtrvISkecAvg1SMWWx7ge+3JdaNzXqAdGxhXtix5yclV7CO6BAzDJVYkEY9HfTMFb3uub/1cT2lZLxdZ/mNjp2orzYlo+bp7Z9DmIIDkTHACImeSspTa0vANYPitQTHtgwTioY5lRxyEozk9wXY0k6qXYDd+PaP27q8L8CynTrnsgUhjKajlU22BS7Zufb+VM+oWSuKtYK61q0vyCJqoSEcO8jc3glllVviHb6h8NpgA9ryzzbVgTxYLy5+jj+J3/xVwMKav5lH2JUyLnZdaH6YUO2hqwp2TEgKpzqYXx+WOwzWWw/dwQ/aG8Rdj4QbkhYc30tG4XMpk4C9SA8L7xLDFalu/BOetEeVxoU8aj+JCPs7dWao5P40YvtE5dv1iZHXoI3Iwed/fF8F2H31KneFlg6GUDQQ809RxSExHsR/j5nBLXufbaWyky+tknA21lwMq1i7bdv2gDe/Q9C8jcvnuVbiprNmyGw2ZQbE6oef2am4g6B7I0t55AzU8YhV+BBYWf+Drg923By6NraWuF+QmZPxBdwcupPX92KYVNflg/+6GxKBhKzqfQelDff4Opasc9f1nL27MksrlNJCQvf7dZeRDyoq/WDbYeRzEe+Y+ptlrdoAbFXU5aIW
 ZS8FRKvT
 a1w/C+ZQlZK9KC2/dNpXop+cKqAt3fwHf+e8pX7i9iPkluWGmSRHbtevnRE6/f/TZgVarKW3AUAxtZkG8rRBzWm57qKlb5G6XfRhNjLKMlV26wUbjK685KiPa3vP0UUpPpIMiljcyBPxKUjimIVkKhlgRDpNuYyJpfODU53+Gw6DRtIe2IPBdqHakTCZeQElfpov0EPYIKo/gwpbvhfQL9a7a9qjNqG7aOzjZUf/TqEXlUPGkyc9B/L1ureVUlGnc6dhm1mcfzEc9Ah8nGP17NYlxFKJy+CoZE5n373QSHQC8BqSDxtC0cbZMAvbbeNUrkUTl0Kd2vWBSnxE43l61nh8nZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Tamir Duberstein" <tamird@gmail.com> writes:

> Most users are likely to want 0-indexed arrays. Clean up the
> documentation test accordingly.
>
> Tested-by: Janne Grunau <j@jannau.net>
> Reviewed-by: Janne Grunau <j@jannau.net>
> Signed-off-by: Tamir Duberstein <tamird@gmail.com>

Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>


Best regards,
Andreas Hindborg




