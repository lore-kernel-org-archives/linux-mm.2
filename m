Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3873DCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F238E003F; Tue, 19 Aug 2025 07:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF57D8E002D; Tue, 19 Aug 2025 07:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B168E003F; Tue, 19 Aug 2025 07:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 91CFA8E002D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:49:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2378C1DE01F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:49:39 +0000 (UTC)
X-FDA: 83793337278.20.11070D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 59B8840004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:49:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m0sgHGSs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755604177; a=rsa-sha256;
	cv=none;
	b=WyR5cPPyd2SRvKf3yMVpRwuyESjP1dZgF5n19hzXyHPaFtYsTWpuxQI3MxdKMs744mh6gM
	W2rr/mh1Hve+FQXwtqQbDi3eXQH5cuLQj5Y6ksjcnuPvc+tyDwnI98h0Wjn/PFr5ZFfGQh
	3fW1at7mmtHWrTSl1gS+RHzot9AHikg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m0sgHGSs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755604177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sz9YP5clCvCrTZFvA9BzDhK8rBUmc71GZDgeVt1NNEw=;
	b=S+fHIqQiyUL66v0VcWwahL+zLwAXnLfZ0fIjNMsnbr+Xt2/N6wZe2EOJz4PH/rmG4tuzhx
	C7txfLACqd2f0ZusdenEETnlKxXa75xx9xm+P9JAQp88ZPolWU+4Y7UtV+0WnYu2L22klT
	nzR5SOAh88TdJs6c+8oq4piNA6RjFac=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3204C41908;
	Tue, 19 Aug 2025 11:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC37FC4CEF1;
	Tue, 19 Aug 2025 11:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755604171;
	bh=I9+81pArqE7MexOVxf+17csPrj9JT4C0Iku6aEw9/vc=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=m0sgHGSs550VMnsNyZqMx1V/yqwEthhAqTI0c4BU9iqzQAn/yYFh37WhdrYb1R6PD
	 G6KfDbtEiUmTqbWw2XwV8B2punfA8JIVR20RsugasPvzeTR6Gnr5Cz1Vfnc7HYUxpZ
	 gqXqnu26hgcehsaYgVfz6M0eM/Jb5qeGw6RGKS+5ZVUXwUr6/5x14OC/X+G7dNyRLd
	 xAEs2x+tgxEJldw9S4+lwxXta33mfrj5VfnHi/eB3/k1CnWVsRFBECzrOyoqfq8Sw7
	 vCdGz7Wlo2s4BNSzeAcmLjHt9Rva0JCUNEmuypy3F2MCU8f0kIH9++3fvAHsEWQ2fg
	 3ut3VeET5N5pw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 13:49:27 +0200
Message-Id: <DC6DQKE6LVNQ.3BBD8WF8XGROO@kernel.org>
Subject: Re: [PATCH v2 5/5] rust: maple_tree: add MAINTAINERS entry
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
 <20250819-maple-tree-v2-5-229b48657bab@google.com>
In-Reply-To: <20250819-maple-tree-v2-5-229b48657bab@google.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 59B8840004
X-Stat-Signature: ja9moqe4tzsmhhktpfficpyaksjk9uoh
X-HE-Tag: 1755604177-475873
X-HE-Meta: U2FsdGVkX1/uLF8DctURgh8akHPu7IVUimhjJTxcJKMsYEQcCcoyD/JGRSbir7u5P2AtWOH2LFHlmElzoPKSswewprUJMFLTm6fyOQruc/lyFbWo80tlv3zXm6LgXjIROVeG/aOM7hQQqLGKafqj/Nb4fF2vyVc3rvWKwODVGDcN4eOR1ZcnnbwMHgOR5Uo4PLGYK6+PO5Qr+NTHDwK0rY/LayGR2DXpd5kRf4rrw6Z9KE/VC0T5bolYLu8gtPSq56mW3pVcRTDptP9xQLyp40m0twyn3iekN0giPUwSotE/6NVdiYMoQhEBvdxB7w9mveHFEUrikTQXgTZSf5uT9sfbcH9hp5TgCa4RVSSjriFJOraT8t0RvyKcspE3HLr03Vx7AT6KclznkWqQMTvX2qDdjldArq30J5D7DHwYhvu87M/hhFQ3HR+oXc6gYFK1qsCNGvgYi2lofe0GBIOaXZNrqyBa6vDkJ0Z9M+F8eT+i42+v913oG52gs05jZEhGAO2tSy3mIdVDC7uj6utUtsMXAiGio3pl2ZA1VFFtycjl6AttwfrTGpenuzMS7zmL/cQTzP9Z194t3zAxZdWF+bSeKR8ffVE3St1Cm1pyNDZ/kGkyuOfwi8DJHhZG3D3jYxds99qD3XcjWxFbhjtBbzyhdr1+DS5bVYj6J/mi6Bll8mxKj1kV9f6m+M4jfEqvuppzFrUjO1o7HyL/bfwMephE1oY7sinjP/jsb5mkcPcs4ei0APQMiw+2GExB+ykC6Z9Go+GlpOL0dVI7NS7XiZW/j+cIsJhOlNU2wbuzpvBuQupjgU8Af5nim3tnX5XlG3JE7mbhb9yb0M7jc/VzZ+Q42grS8ijMF0Esm3KqXSZ6yHBHz65PghZj7Fm0scvxiElmiPtPKgWGx9aVaCKVMXPd6KRf7Hk84MVKbp9mM8NBt5B46mZHKjc5nbMJvSE7X3YHevN1d8y1woZYUFb
 C3okLi1D
 u84bEM+qvANQ5Jl7rP7ohKROKz50Y5L3hRTmIxiLEzGdDsOF2De3hi5S0G/Q164twRS1ApCbnwEy/MxZzjMV8SITqVDMHqm++/hleC8O//eE44LpoL73GFECix1lBEKRJWPD3MXavVRScihh4ysIcVcTcaK2NNL7MN7MZkCgtfF6d8lrUMzfZuozoiaIIVhXhmT91wFd9nBknoNrzFNym8ZyZLzXQwywPmR/kKICBouHlOyqzeJydXNj5bU83M/K/eZU469K4lfsiESSQCZfXToQMBfd2/nGg9lMPYtfttPit6nuRps9Z6XsRs5H7ELqgMByukdIC+y2wpPROXwnIRGz1wJpglVK7VO9fnZiE7DuVhJSIc77ftXNsSFlQ72lU+Va6T1WXZrckq1KjoYFOn1j5hCMIlWuVLyThxVgEqV5GIrhV3T++8b9KzFs2DTd1pwbspCYm1QQVPnEfcg4Hg6IPcVOzL1fzNvWYxTiPbnEYPAzGqgra9NuqiO+8Y6J1FyvrIRBxbIBE715/FJerpwut8dHD54KYiGfa937CMB3AxfaSCpDKYzSj8eYSdDAZj2C0QXPNslgpv6mcHgs5vqQVXsYUPlj/P0bBAokXTDiatWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
> Similar to and just below the existing MAPLE TREE entry.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Liam: I'm not sure what you prefer for the MAINTAINERS entry, so let me
> know if you want anything changed. There are also a few other options,
> for example, I could just add the files under the existing MAPLE TREE
> entry? The get_maintainers script should still send any relevant patches
> my way because they also match the RUST entry that has a wildcard on the
> rust/ directory.

From v1 [1]:

	>> We should have another section for the maple tree, since it's not just
	>> used for mm.  Your stated plan is to use it for GPU allocations and the
	>> code doesn't live in mm/, wdyt?
=09
	> Sure, I can add a new section if you prefer that.

Maple tree is already used outside of mm, e.g. for regmap stuff and I also =
use
it in nouveau. Hence, I read this as moving maple tree to e.g. lib/ adjusti=
ng
the existing entry.

I personally think that - of course unless the affected people prefer other=
wise
- it is usually best to keep a single maintainers entry for the C and the R=
ust
code. Maybe Alice can simply be added to the existing maintainers entry?

What do you think?

[1] https://lore.kernel.org/all/aJW3L3SEVUl_AVvN@google.com/

> Which tree does maple tree patches usually land through?
>
> Andrew Ballance: You mentioned being interested in being listed here as
> well?
> ---
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 26053163fe5aed2fc4b4e39d47062c93b873ac13..4a52d884e36eafe1c81922720=
7123c51caf02ee5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14674,6 +14674,16 @@ F:	lib/test_maple_tree.c
>  F:	tools/testing/radix-tree/maple.c
>  F:	tools/testing/shared/linux/maple_tree.h
> =20
> +MAPLE TREE [RUST]
> +M:	Liam R. Howlett <Liam.Howlett@oracle.com>
> +M:	Alice Ryhl <aliceryhl@google.com>
> +L:	maple-tree@lists.infradead.org
> +L:	linux-mm@kvack.org
> +L:	rust-for-linux@vger.kernel.org
> +S:	Supported
> +F:	rust/helpers/maple_tree.c
> +F:	rust/kernel/maple_tree.rs
> +
>  MARDUK (CREATOR CI40) DEVICE TREE SUPPORT
>  M:	Rahul Bedarkar <rahulbedarkar89@gmail.com>
>  L:	linux-mips@vger.kernel.org
>
> --=20
> 2.51.0.rc1.167.g924127e9c0-goog


