Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C4BCCCF9FA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 15:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FE9280009; Thu, 30 Oct 2025 11:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53835280003; Thu, 30 Oct 2025 11:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47565280009; Thu, 30 Oct 2025 11:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37B47280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:42:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B77151A018B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:42:05 +0000 (UTC)
X-FDA: 84055196610.17.2FA702B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 161AD180002
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:42:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=opFa9EB3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761838924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vFZnUDfjBA4r+qF8vmNrPb4daig7NnU9bbjhuI4X1c=;
	b=avryLoTeAwB/qFLdahM12XL9dwQkJL0VQk+VijLFaT8LYFa7AnIUPNtZ2P53CBNmV+IAuj
	VHrcdpdSFDWKp1Dpiev3Ln1ab9z/SSDKKZF1kNoUlByxRvEOIOOBhkh/ERiXkPH8eXqv0J
	LpolwrgKh+RKfD+Cie3/ji0qT/JZ89A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761838924; a=rsa-sha256;
	cv=none;
	b=h40V7BwVkE+vEvkiRYLoYiaLyPkvuSyjF6M2CJS2EvMOV/gtWCF00IqqYgmiBJRI+/TEmj
	/G2cUWZlvdGz3y00tGVXwl/TYq9sAFp6wq2PFxnZJMKJfXWlsqQE9+iBzhgA/jNtDN6rFw
	f8bSjX4BiOMYh+uxOcKMggg5Ycw1KQI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=opFa9EB3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35E3C611C5;
	Thu, 30 Oct 2025 15:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDADC4CEFF;
	Thu, 30 Oct 2025 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761838922;
	bh=eozvD8BiZTEUnA7DiffXKpGEYQxiDYuYcu96Z+MljZ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=opFa9EB3kf2HPWuKsWqldnW6T3nRIaodWxyQMElc5H5C/9w0CUkQx5fuiN+zz+GDJ
	 6oU6ojYp29KVqKQ4o9JOq7bm/wN1u8BZxnVIDxPxl05iQHAGd4LPaGxeNG6szm3zgz
	 knzQfaNarq69pObXhbLlN0bNLGU4RiYlci4gRndRcaVWrJJIp3Ub09ZftRKnRxqy2S
	 D/arenc3myE6nF65cBHYFGlOyukq9Muh69qOeXS/UhyE9C3/0Jbr87BAQSJQV1LcgU
	 2upr3k26lQtCXLCncsqm68XhP56t4O/0eNmEeAcnf27HNCUHEYbVCs9ub6ax7se+IC
	 KZ9Baf7ZU9OUg==
Message-ID: <cc28d048-5e0f-4f0e-b0f2-1b9e240f639b@kernel.org>
Date: Thu, 30 Oct 2025 16:41:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 1/4] rust: types: Add Ownable/Owned types
To: Oliver Mangold <oliver.mangold@pm.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 Asahi Lina <lina+kernel@asahilina.net>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me>
 <20251001-unique-ref-v12-1-fa5c31f0c0c4@pm.me>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <20251001-unique-ref-v12-1-fa5c31f0c0c4@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: f7uw8t4cid4wt4uqgnkgw9g7tbps3osx
X-Rspam-User: 
X-Rspamd-Queue-Id: 161AD180002
X-HE-Tag: 1761838923-811006
X-HE-Meta: U2FsdGVkX18ntq4HSfsk1m1h9ojYoukELvRLAbHVZGn6c7q285j6j4QbazGgAl9wZl8K9L4oZZXh+tICH39zAU3726JfIjR4afEq/3iUMoGiABOZ+wBSG/fij28NChs3wDQfXtGRNhZYpyI8p4N3NQ6tHSJ8hk+qt1GAmRuYJkIlwZzFu+Qgk5Sm7GnVoZPMKKqsjWkLPPomLFv2thGreFbk0Qu0JSPHxFGSarRYk1O3V5chT7PAf3Tmq64l37yRCjtSantLMOjfrTrZ8TH4Kah/QvTzCDkv9L38EQ3qMGDF0IF65iWbda9FVisX8fp9y21nQ7rV8S7zba2vKnVKGSQMNsv6ADNJFIDVnGr5mPkrsPNqmARNuImiZ9eVDSsk47oS0zIbELeFP/4ymq7LR4ShctajXlheHbyyNuD8y44+jVHt81nlo9C2L/Us1SBDLTRDFCSqN9YhB6uR3GKppJBVxFIeeEJ/qZjSDdy0tmR9ugEgXns7k0vBhyziQgf/u559xxLI7JHMboSVbidf7JzblcwoM1R7J5+Ro5s4JtseuD7MGaYXsyY+SbBiPaXIk9mwir1McrQ0fanYJ7AptObVAEus22XEIgg9AOZiMePPXCplxf5V3NFHYWvc/VJH9elIN/EF6gje8kJb3KbiNvJoImsXtP92xUf6fDoNnUIhQBPENttZH0I3Nwb9rg6fUfnR9bY/TiJ5PyZuLql+VWTPZHH4hJJv3qrgMJsm7BAv7Q6tsL4x8/sgdS99ZYpqFxfk2/hxRWcRZ5pNFx5ZT4kXXEAsey0WHstldr9wOzRotRD5+GdGe0Z1NZOO8BiY2HRgG3t1iyZlqpqTFGmTbNV7n8jdE1lNImYeF+YjfpoLaGjGIsa+dTU64viGBQhh772hLy+l2ZFfpBR3rk0gO1Ns5NPmfth2qp5tWt1VIgkih+zsD1rPy5x5MWOiOvzgvPHgPVo55W6WjoBwxOx
 j+AmPc+o
 bBBpYoY/DA9KittMc+6eE28waLpqdi+SDmbIo9vT/aVRnbnnomOmz3t1BPlQtqlbtA7g9/1XU1kDvtf8L6zelbIVpw3Qw4yPjwQ8FHkaYyFaRcRTJK58RJjdFHblftGmw1w5uYpvHYxIC3laExHfT4gRRV59zer83mDhLWr6gf3cUvI0BmxhrZ7ZX2H2Qeg5+5IIrRO3QijXQjxax00DgtvqlU8JftxKrB+yfQmXIxgckxTWkxghMH38j1iFw+zQSGtpHqOJOMLK0DfHkL19il601G4arTs1vz/F5DxvBbNOXyd6zRQRMshCAMls3XQbOKJIlYMooqYtGuv6lWWW14QZsM02IA+0OKVlMywCBUKnJ16thwN/Ob0FIa3xW5xJekazJqfKy9Au7mfBKOLGRbDiqIGjILeDY54xg2VFclomKCyz0dRKAxQRdc2FWD4JBbhuG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/25 11:03 AM, Oliver Mangold wrote:
> From: Asahi Lina <lina+kernel@asahilina.net>
> 
> By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
> (typically C FFI) type that *may* be owned by Rust, but need not be. Unlike
> `AlwaysRefCounted`, this mechanism expects the reference to be unique
> within Rust, and does not allow cloning.
> 
> Conceptually, this is similar to a `KBox<T>`, except that it delegates
> resource management to the `T` instead of using a generic allocator.
> 
> [ om:
>   - Split code into separate file and `pub use` it from types.rs.
>   - Make from_raw() and into_raw() public.
>   - Remove OwnableMut, and make DerefMut dependent on Unpin instead.
>   - Usage example/doctest for Ownable/Owned.
>   - Fixes to documentation and commit message.
> ]
> 
> Link: https://lore.kernel.org/all/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/
> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> Co-developed-by: Oliver Mangold <oliver.mangold@pm.me>
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
I think this patch was originally sent by Abdiel and Boqun [1]; we should
probably take this into account. :)

[1]
https://lore.kernel.org/rust-for-linux/20241022224832.1505432-2-abdiel.janulgue@gmail.com/

