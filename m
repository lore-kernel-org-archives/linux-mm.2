Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAFE0D29DF3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5546B0005; Tue, 13 Jan 2026 04:25:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CE96B0089; Tue, 13 Jan 2026 04:25:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292BC6B008A; Tue, 13 Jan 2026 04:25:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1884C6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:25:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1514C08F9
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:25:13 +0000 (UTC)
X-FDA: 84326406906.29.EE5BF98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1C6F3C0008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:25:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qzw+nhTW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768296312; a=rsa-sha256;
	cv=none;
	b=lxJ18pyB+JyggaanugbWDvz3rA4DixPvWHNYzpIQMjlGinNYbQSOk1MafmhXbJk7B82mij
	Cd7Q5O6TP6zeeeV1QFsfePNFqEKCp0AsvAS9UZfbLBmRupa2YIhW43rskCwPT9AGEhdt4Q
	oUaYzl5X7Qh6Tm0L4FgF9MtaTEb4+Go=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qzw+nhTW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768296312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L97MRU3zXSX4+a/JpGKE1wwpnWvOBhMojukWJyafDmQ=;
	b=J9QDQ/yhqqGV+9jA0YPnlZ6LbBmSZSeplI7c6u3XPfIifmMPYlG6wIWoHf6OsyTEx/df47
	pS+b13g15pulrvmPfKp+w/vEld57eb5YImuViKOgl8NidunCpTok7xEuIHGhFfQza6+nXV
	4MnTUIDsIRVkC+g8l6QNKZB3O0+UUpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E840043CD8;
	Tue, 13 Jan 2026 09:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1994C116C6;
	Tue, 13 Jan 2026 09:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768296310;
	bh=5WcDfOtEjk2CZ85KBhVtVus8q8w9KHZIwPMUEvSME1s=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=Qzw+nhTWNXpxN2P2pyNSziV4x3a65LBSG9ra/AjxaG+vmZC3LvrsdgYFjilsd0PWq
	 78OK65dQW/pLg5ROTawBuuLxwF/mSd8/Ii82NWpXFhREbPoYBrppXv0ZdgWxra4Bxl
	 7t70BTER+DRhEuO81b3GlTLiOrVn/rual86e4f/T3IJQXCXWywXeKiHlIY7+pPe5u2
	 ZV7iV8/vAQsKB6h1Uj5Uzip2/jKuLPPUr7WUW/sfF8EC73PRg5IAHk99jU3of1B0LI
	 oGZ/2knzQTdGaQ7KF/Y7oJseWpH8ITEJcD59UJvy5UttNWZ8Ropg2aAu5zt8kykGFN
	 IVNZJHiN0NH0w==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 13 Jan 2026 10:25:05 +0100
Message-Id: <DFNCQ48YFMOM.3MX8XIT2I7UET@kernel.org>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v5] io: add io_pgtable abstraction
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Will Deacon" <will@kernel.org>,
 "Daniel Almeida" <daniel.almeida@collabora.com>, "Boris Brezillon"
 <boris.brezillon@collabora.com>, "Robin Murphy" <robin.murphy@arm.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Joerg Roedel" <joro@8bytes.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Asahi Lina" <lina+kernel@asahilina.net>, <linux-kernel@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <iommu@lists.linux.dev>,
 <linux-mm@kvack.org>
References: <20260113-io-pgtable-v5-1-7ed771bc3d8d@google.com>
In-Reply-To: <20260113-io-pgtable-v5-1-7ed771bc3d8d@google.com>
X-Rspam-User: 
X-Stat-Signature: 59nuued71e7w5rw5w1e9rp99hhcefp4a
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1C6F3C0008
X-HE-Tag: 1768296311-128452
X-HE-Meta: U2FsdGVkX19tQDioJzSXVpwgN2EkWYU5fnIwLf7eA3jRNtFRiURKasRG5EuFyU4FsDZBzghhd91cC4q2NF7lMxeF2i6wY3oTRaArqty99Ufj/Ze590IGrlwUk2v3rnPRx9xY2IyL0O9AYB64P392guZH6WsEr8ifL9w08MN5iIp3l3HGv+kCyA4tuwaxhO0T702hlS2q5o0hFHfBtvgqbDsKVw5e+bkWPexZgCTxU6VAT/vevprm3boEOSAzMJbW6lGLgZFKcmitkDp8U0ICibSLSUlpO/ucZbM76vQ6GslnpbYizX6xpE68+riFZHfjmIe1zvm0wSgRtVLFEUNoAJHCftVk40GacNvAzK6KtZybg9yQXBTwkBnpxIxepYzMD9ZmZPrpeY8EjdBxbiJTyqDxJEWgnfHz+AONIehkBC+dcj4+r8LdKZQRBqJQ7Nx0nw3hasSorxYWfkqUnJRe/Sk0Aoe3izFSfya1z67566lUWVWwDoI9v123xT9y81lv89FDTUPXQRnEcFUHs9axEqTu9dsoOM1JImsx8nPEihntISQPIkZI9UxyQ1/PBSfEqS4JOTlBuOcgiFcP3gZiubcHuFZoZhchvHb0rFRZAxKM7b8JzhMZ9TxAXEYqNnNT834RUXbW8QkO+V/ltLSkEKkrCqBa7zvJPHgmVphQe4aCVuwY42ROI3tvp6axDMpQ6go2UcWHdS4wKj2yNLDPnkwcf4iCGxxxbaLjipDu58HftH1XNoYC+gfWru+n6Mh7kK5xsjzMYEIWX29uud7BtuNRt608LD8ZO47zH+Y1HkRBuKZp10lEYnK8S03o1KIow1O2mLmJwDZnESUKHFmT94D3TqAAWtMIvDdUS8uOyAUoy91nQkN+VeUVl6tlsI3q3YC4vP+cZzYbY4syI12uYU+ndAvr/3S1vPWZT142qQy/LXHmD7gIJjmagdTCiiHTTFLDSPr2dkSkpdAdhW8
 5YNVNCcq
 X7vLJAXmYe+FoKwDZUvmOZjDZrkuCNVQhOtJyE8S+wRktyN6aW3LmfUzxfhvuANmBkww1vs7/vnux93dyYRksCtMNki0hNW452TzEUZxsT3/xDxYJf9eQfGZE6En60xjtkv/YRPzCWy0h0ModfKHCuEGgbtvwuGsRpSHkzeD3rSa56EwbZg8QqMlBfzGBABPmhGiqM1xM9RsE0PuNe0XPV6jHuSVJiY2ccpl3Ju6Bs7RJ+6YvnxX1H/VYIhBKOx4TaGhqacY8r238BlXHfqhAldAlGgYEl+hLKflbN13xtDPKLG5aNBnqjb4Pv3ibTASBdE8ScK8Qe9KhXKPfRvtGnCiuO/yxEJMpKMdcRPDskfQBp5djR8QT5y/bhxRt/d1XnuuDew6RJUfg0thtRm5+m04BllGVNUnlPrVzS+CmLUHP8fWP3RfeL9ghQtBd1oDeEV4J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jan 13, 2026 at 9:49 AM CET, Alice Ryhl wrote:
> We did not discuss where this should go in the MAINTAINERS file yet. As
> an initial suggestion I added it under IOMMU SUBSYSTEM, but please let
> me know what you prefer. There is also a DEVICE I/O & IRQ [RUST]
> subsystem that it could fall under.

Either sounds good to me.

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5b11839cba9de1e9e43f63787578edd8c429ca39..eccdb937762a7545fcd5db019=
4ab7c1b6dfdfde6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13241,6 +13241,7 @@ F:	drivers/iommu/
>  F:	include/linux/iommu.h
>  F:	include/linux/iova.h
>  F:	include/linux/of_iommu.h
> +F:	rust/kernel/io/pgtable.rs

If it's going to be IOMMU, let's move the file to rust/kernel/iommu/, other=
wise
it gets picked up by both entries.

