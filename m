Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42CE6CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 10:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 829E78E00C9; Tue, 26 Aug 2025 06:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8013C8E00A8; Tue, 26 Aug 2025 06:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73DC28E00C9; Tue, 26 Aug 2025 06:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62A4E8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:57:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7DFE14070B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:57:52 +0000 (UTC)
X-FDA: 83818608384.22.5E8ECD1
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf20.hostedemail.com (Postfix) with ESMTP id 50C661C0005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:57:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WpjsMpJj;
	spf=pass (imf20.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756205871; a=rsa-sha256;
	cv=none;
	b=eUcPmscxwEGtV0f+B3Tv3PPLD986VfB65Xfbi5uUlpFDclk83SM90xT1Vu6OFZw15BXyB9
	FM4vaYnSp8DOTUDUJBd7zuTuVvd+7G8wTEN4F4IePz+oUwKbbFh78+SL6i9rqMj4k4Eg0U
	dE+uNKLeCBBrR4qitZylL9JwLCQmi0g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WpjsMpJj;
	spf=pass (imf20.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756205871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWeSNKWQXGxqD7M9MiXoz+ZzpcsiFmiQ/zwegNHfW4U=;
	b=dZcgzLn05wILAb3Sm8V/JK/FLS55b4oMLKDKEJA1utMZXpFVIkcwR35rkQlTs0O1euUzrK
	PshuOp2Q3yjcZpukAxqleRD0+WfIDM/hDpF4FZIx5mGGKPTClMRZ1sSY1PSmnHTPZfa59q
	FLh22RRpMxmdiERp99AqMuSRWTCGYmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3BA935C5BE5;
	Tue, 26 Aug 2025 10:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC94C4CEF1;
	Tue, 26 Aug 2025 10:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756205869;
	bh=uyrxk6x5endfgPWV1unzyAKLaF962HHKgN9da8/FKKs=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To:From;
	b=WpjsMpJjsBtNATzL7Df/XfKezd9fKPIfPD55b76UExPKSjxg0UjACnw7Uw62Z5aEZ
	 LjghjDxcM8/mR3k0lI63BcIcz5IStg54rDXg1udfSR9vCLSzmJMlfE/FQVRyu3lOnt
	 ZgWbxQ6g+SupQmQFfMqSw76nITdx531IH4gxvclOk6rR26TsBedtlycUjNlYBnaHLN
	 ajQsJdTr09ROul4jZtkXySnC2U4UfRELbVyW2WjzrMR7cODqLxa7VpYHOXZwSQ1za6
	 YSDbxmb7L+yeENclwWZGHdbRUfxVq+8gWoNvXLax0tEoDoa/hAwzV6KZ1RB8au7CWP
	 6OH1eUpWzBNDw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 26 Aug 2025 12:57:44 +0200
Message-Id: <DCCB0SA6QXWD.3KAR8P6LK9BYF@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v4 1/2] rust: alloc: add from_raw method to Flags
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 "Uladzislau Rezki" <urezki@gmail.com>, "Alice Ryhl" <aliceryhl@google.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>,
 "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>, "Bjorn
 Roy Baron" <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>,
 "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor Gross"
 <tmgross@umich.edu>, "Johannes Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed"
 <yosry.ahmed@linux.dev>, "Nhat Pham" <nphamcs@gmail.com>,
 <linux-mm@kvack.org>
To: "Vitaly Wool" <vitaly.wool@konsulko.se>
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250823130508.867235-1-vitaly.wool@konsulko.se>
In-Reply-To: <20250823130508.867235-1-vitaly.wool@konsulko.se>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50C661C0005
X-Stat-Signature: ynfdey15eox6fqmnnjn6a37h5dm3ib6c
X-Rspam-User: 
X-HE-Tag: 1756205871-103583
X-HE-Meta: U2FsdGVkX18tAiYjIMvxrx4nLIV4TzII3Vk/X9eCyjdGt61hXHc5jb5h7lZBgDzABeeXs7cfLbokd5QTJNuzVvwvQ1I+D9YGv/ucL79vV7SJ5dqdqnBAbjZ17Megf63K7VhT8ZCKuzExqivyFmXCORd00waeAX26ffQq5QnYVeoWJYvzAlgltkxoRjGCEoNYP0wfMDXZ3+ApU4pCWnerUXQdYZYpZbR4u1zx0A2w+21vMc9UCMyXxAcx+LsBTlZ5cAw2cbq21XNlqsAVPmXlA+nxyFf/SCTdLXrv7/XcEkI9j5IsdAwojWaIG30n9ofpYDfEPqEXWhp8bXOtATYivzVB3pCbXSdgLVG2SCiVLXQjLPHDgaddUXNOQlkFGhjxwjgQo9bgQtsz1UD4wFNgEKeLKZ762FXTy+Vk2J0zSwx9KEwFmlR3cOT7D1LmEXXXF9rtgTJ5mgwVXyqkKRtvU60Vh1YQthYo/XnDsPKDraDu7RJ6B4pCi5dttDNwHXmqL86PxpQW2U1ijKGLWXUIFGeTNyS2HbSX5ERaCTKhpEE9oR6k7w2gK7JUEa1b0+BXedwNmYyeOIHmi3JTKD0XPMEquzKAjDYcwgWeia0yIggjBsg7oJem3Wa8z6ALAIhhaiVDTU3ecOC2qf8AL3FPxsPwXTF+WfsKlmPVnMqNfE0kZh2b+tobi9YJ/KUOV2U3v06zGs2reESBfT365WUUOMTz32KHb3hBM1NMym8eIDxMG6jvgpDoWQ3DgJD4qMXX7HOWlJSrBRrqk5n04GB83IZ2XTfmz7RY40j4LnwbKyUuIgu413NnAMjRODsFFbUdQs7XturQee5AeAicRs1FIPilrIl4znTgPMXHboLi9bIq8PM6ahcvyPriIRdmvqPppfX34cfsSbScDUbm259CtiXgQ7ZHfr9mXjLsAJwv3wnGl8oDvrM945hWrqW+eAPUbsC6gXse3Btb5IJEGod
 QYnuurN/
 BK4Ua2fZfSUMBHH6RSpb9G+a6uML9p30oFNMfyH0JY0m+ZThkqpu2rUuEsN5PcXtAM9ccn+z+4jKn7OUICSqQK/X1CBNMM/bvYchM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 23, 2025 at 3:05 PM CEST, Vitaly Wool wrote:
> diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
> index b39c279236f5..808bd4281164 100644
> --- a/rust/kernel/alloc.rs
> +++ b/rust/kernel/alloc.rs
> @@ -41,6 +41,11 @@
>  pub struct Flags(u32);
> =20
>  impl Flags {
> +    /// Create from the raw representation
> +    pub(crate) fn from_raw(f: u32) -> Self {

The argument shoould probably be of type bindings::gfp_t instead. However, =
the
alloc::Flags type itself uses u32. So, for this patch using u32 is fine. Bu=
t I
think in general we should fix this up.

> +        Self(f)
> +    }
> +

I think you forgot to document that the given value must be a valid combina=
tion
of GFP flags.

Please also write full sentences and end them with a period.

