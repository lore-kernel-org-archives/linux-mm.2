Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66968CCF9FF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4551280002; Thu, 30 Oct 2025 10:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CC78E007D; Thu, 30 Oct 2025 10:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33588E01D8; Thu, 30 Oct 2025 10:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F77B8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:57:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75754B698E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:57:51 +0000 (UTC)
X-FDA: 84055085142.07.A356CA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7D67C000C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:57:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NZ/8uG9s";
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761836270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPH444EZaU6hB0oe8fwJQJCQuWbHbzn+g5+EsUVpY/8=;
	b=M+c7YHyZ+2OhDYUEiD/vYJupYgqxyAFj6AjQKA0e9WQcxFlePKTabsbpj1u9sIq/vzNLJw
	7xdMCttpmLBgBVfXU7y/w7y9IDaO76dKb3v2U612+SUPoyRbSviaa+RbfqoYi3U6R0dQXu
	HhWUQM4LE7YXh81N0+xjsEBQvlTfBjs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NZ/8uG9s";
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761836270; a=rsa-sha256;
	cv=none;
	b=dIiiFRuo6czVem/lzjVPflRGy+m8TnTYBB+1HZjb4eiewwVOaCmcMdBMo30vIMSMtJHsjx
	g8vVHmoThjeTLHiFdTzCxTRLIRJKMq+iUo5O5Efy8R0U5HI/nc872x1yKitnXp5U6z89kl
	hlH27tFDbMEcyWIBD0B1aPdpfe1plU8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A82B943898;
	Thu, 30 Oct 2025 14:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D33C4CEF8;
	Thu, 30 Oct 2025 14:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761836268;
	bh=MPH444EZaU6hB0oe8fwJQJCQuWbHbzn+g5+EsUVpY/8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NZ/8uG9sgSxgb3j2CP8YltLWsQB47scQpxGKcbR+MrBAvSTgaYZddAH9NvQVGxgCw
	 jMpUMahh2MOfXnnLoIWYFzo/z5SUQWH6OtWirV1MskoUFnhA0Lw3LEVhTLAJ4ge2sB
	 EaW7Xt7Ts72Nt2tAEOjVuHrEoE4oiAUc53DYyXuydo3/t8rkO7kS4zaierKba829eG
	 lTVRQZtleWTO1rimqLOyp5tt4yk56zMv3caXQ/wkevBe5n0RkWPmE2h5jGuWpQ60AL
	 gx4egPU999DB+RUobTImD6plP3mbmCWsKA1FWaCseeITaGgey0cf7mVcCxCSzZaRaR
	 zCQ0turLOoXvg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Oliver Mangold <oliver.mangold@pm.me>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno
 Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar
 <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd
 <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Asahi Lina
 <lina+kernel@asahilina.net>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, Oliver Mangold
 <oliver.mangold@pm.me>
Subject: Re: [PATCH v12 2/4] `AlwaysRefCounted` is renamed to `RefCounted`.
In-Reply-To: <20251001-unique-ref-v12-2-fa5c31f0c0c4@pm.me>
References: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me>
 <20251001-unique-ref-v12-2-fa5c31f0c0c4@pm.me>
Date: Thu, 30 Oct 2025 15:57:35 +0100
Message-ID: <87sef08mjk.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D7D67C000C
X-Stat-Signature: udciceeymkpn1du3pwo9gsfu9ywmaadt
X-Rspam-User: 
X-HE-Tag: 1761836269-583008
X-HE-Meta: U2FsdGVkX1/OOrT4K12PgOtgYEbVSsHMq8Mfn8C8lllh7pa0IaT5zi5xjtTJF34r1TBuhzlEzdjVNYqQcYFvbFl3G2FU4bgewFspqRx00T5nrElJkPsDOJCBnQWle3mN6FYiibp9o4chfdVhXDpNBQ8dK8fqwt0P5yCBPfoJX02LUTeTmNB9/ZYhnhZRWgXKQy7vrIUN2q5Ku9KANd5Re8fG92S/2fWcMqWYxzEi5BVtTLHAmZlI1U6OVIcu9hXprUX55bVKC6+LTBzMW+rm0ew4vSl0T67e2NfcUgM2Aw4vKbo8SD3GA9L4t/H94TqZCJC8dLlVKUtZPJ1D3wuhfMFAYnw5pes8V4DWkH1pPY1KjgcJkWcPRkBjq5aSHp7s4ZwsmRyA4KFxotyTm+rpL2zW1/9A8QWwO9vDeOIHtGCFVHOvSSAYevnZD3yXbxEGsZhVXoQ5DP+VbllF8pTo86lBOqLOdcQW3WFBxCpVynW0DPUdWj12Fg/NO7scRAWT3Aby0Kop/LHVjGrpdj4yzUmcynsBV+xlWsY/Mf8vdND0MjdxybYRIyjktZ8AEqLcOSyrBX5xi1cwpdIol18K4MVWwtr32+Qst3+smtxm3H0V3QnASeg0n8b8+KMC6m9xLEy2Ry1oz/Bw30JROAgY+y02m8YzgSn/k9sOiwfRBpfiSSAGfcZvF6/J5ewrqXTmCo+tCwK+OMe/N4A2Eiuyq76m9UBzq/YQxsp5NbhRFLjP6Ze/cPVoqwPGaQZ6w7135U6XE3TWUIcIEkgYlmFNFX5XN0IF1NU5KBhByw1NYoFoNTR2RLRctPqGx2ITfLVe18squNprSRCx4AjgeQ0tRFadD408BY9JO7o0u5LWLD8/u3qhblBKAKB+jspX7QJhlSlDGoW2/1tF2N0msaps1HkM2CSqTszAxL8O7Cr2mKDcpdSj7B4KnnxsFWE13t3isSTO76i19k+EcW8snLV
 vig0wUqK
 pLuzgi3GHKzHad2XUBW7++yazxIa3xqFoUvM+rtp3NlM+9tB27ZXOFJujT9Dbhfjx9EJ0L/YK8y1kwxMeHMeOgPYKtK2SyHY8K29drbHKKlhc1kRWQcg2SfSqMegamNd0EQj63BJrerOb+chWVRJBl0do4Qbrij4KNASxWapXsrPr/KGpThd9dgpbWavgpNpfv2eGDapYUKAkdtte/JU9BxhgwKcDRFNYjvnxU1cQpZqSEhZ0LJs/ZIMBvk7nPW/0LhA4NbRLV7MLme7CFNTv1gLKuyGOQ9oBcRLJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oliver Mangold <oliver.mangold@pm.me> writes:

> `AlwaysRefCounted` will become a marker trait to indicate that it is
> allowed to obtain an `ARef<T>` from a `&T`, which cannot be allowed for
> types which are also Ownable.
>
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> Suggested-by: Alice Ryhl <aliceryhl@google.com>

Please update the title to

 rust: rename `AlwaysRefCounted` to `RefCounted`

No period in the summary line.

With that, you can add my review tag.

Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>

Since this patch touches so many moving parts of the rust tree, it is
going to be a cat and mouse game regarding rebasing this thing. It also
touches a lot if peoples code. I am not sure how something like this
would merge. Do we need ACK from everyone @Miguel?

Best regards,
Andreas Hindborg




