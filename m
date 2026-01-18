Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18F4D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F6A6B0005; Sun, 18 Jan 2026 09:43:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26536B0089; Sun, 18 Jan 2026 09:43:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52E66B008A; Sun, 18 Jan 2026 09:43:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C531E6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:43:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70140C1FD0
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:43:20 +0000 (UTC)
X-FDA: 84345352560.03.621AE2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BD09340006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:43:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZImTKomO;
	spf=pass (imf04.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768747398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+tncgn5SXVakfmTiHr0n/tArw8Yi0q9q//phUhrhEs=;
	b=jEkUhXVpInnSzuUQoIy+1saoFQ8GgYEo0QhI6fYyrSTlBR8knHFGB3BLyeb7zQjsrZxVKE
	kAa+wCLbdoodRCOWI3eavzkdUXIfpd6BbF6dFxKEJYbQREJufmljrPhHNlVHBc8HZrIIwm
	70KOhCYRqZYxQBuEd8A81zZA56b30dM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZImTKomO;
	spf=pass (imf04.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768747398; a=rsa-sha256;
	cv=none;
	b=IowixiMrTgqfG1EH/FNosGtVhLlLV4vZ3/HApZt1GjwMSED3P727CQrbNZ8USBg0trw21C
	/W95rvludCzrHmS39C3mpoBYBCHWeDGkrEeQKlLMTMQzw9qaO+dOc22xxlM+cPIYeTbc4x
	Z5103QF8zQ2ACRaLBwKwxVolhUkWFe4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B3D144047;
	Sun, 18 Jan 2026 14:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D0FC116D0;
	Sun, 18 Jan 2026 14:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768747397;
	bh=yX8tHO55GG/mldRK8FReFu4hUyBgKBvnvLpvUpXR4vw=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=ZImTKomOzrrVe1xZacVnD5Fr4WMFOuE6565q6gXiTLQyJHqIs2HF1PlT60wA2ndgI
	 Vrz9qnvkebtJSZ047onnK2zosQX2ov6uDnLLz1xf1WA3LuXbfeT+Wif6sUAPdCsAW0
	 WG70u6acSzHKeZ5MRxrX7H7hK8gYXtI3DEWEHowfggfzqbmRLjKt0NBl6eV/8YUxr9
	 474KgqLIsd3SRusA0xvnm/s2jImxQOoD5FPUPr1sB3GflI0DkYoN7Kjz1Z5OTZPb8P
	 FaLS4y7z4W8TScormZyX2cq178xI/yEESoBFG3qUYvnL8ZQxtL0LRjcU5GXLYf+m/m
	 rjlxBo+AdmfYQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 18 Jan 2026 15:43:11 +0100
Message-Id: <DFRSME7WFXY0.2XQSN0VXMI9MD@kernel.org>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v6] rust: iommu: add io_pgtable abstraction
Cc: "Joerg Roedel" <joro@8bytes.org>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Will Deacon" <will@kernel.org>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Boris Brezillon"
 <boris.brezillon@collabora.com>, "Robin Murphy" <robin.murphy@arm.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Asahi Lina" <lina+kernel@asahilina.net>,
 <linux-kernel@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-mm@kvack.org>, "Deborah Brouwer"
 <deborah.brouwer@collabora.com>
References: <20260118-io-pgtable-v6-1-423846996883@google.com>
In-Reply-To: <20260118-io-pgtable-v6-1-423846996883@google.com>
X-Rspamd-Queue-Id: BD09340006
X-Stat-Signature: 6ehg3fn16h311yfwakftjb338oiejct4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768747398-351885
X-HE-Meta: U2FsdGVkX18rbQRoJ/O6mqQsDaF04m1r8foPXt/OpoG9Uu4oAU6YmyW6j/hLIhQOl0xy+qqr/Sb4cOcJYMX6ggKSB82/5x7XN1G2PBWhOKTNI3akwOHD96rHIY0tPWjornxsAJlv8/C68IfuR6Q49cAIW68tkfv9LUXWfTf7i/CISLfLUgTg9BgoXGX1T/MR7aoABVhuvCUnuOa1Zj2gHF+GpveeP5sma7Dc2lNpvsQcHdx24JjRUZxQWK/X4qFJZ/TzT/Zr9EO7h29HEkjebwxOHvF9LHTctfxewddwAy6P8bT314RSaazQ5vIZ+2vDWFr+tyxqjkGgcnWSvLDTmSPvo6l1sLOWA2YxcLSqCHDRVM8VFRHeWSXzY0gJhgFH2VrETfacEbgrkQp2JUK6EpnvR/3+QrayZ9KLTVo5Jc5FX9/zDNB1SZqDiOLwidxK0OW1F4SJFBKa5QGEQelwAFKw+g+KrUFzkDyScJpSTYSDWZIhT7JdajRilpuww5+sQlEpUjvjNO7HKZiRORSVHqyWRzw5Q/35hL52mhldQMCj8Q0Fk0u1042mvJuSlpzz3EspajxoKrqR/rKap5mBXmaASvbWBZM68tHoZtSgZZdwDWgY8bNHS/P12aU9kgpMCQRf4Q+V1SDPmZqgVirlLKufsB8TKQ706hscZWQEF71Yd9KI0c2UA1cG+V0rIMgpbkDKr6slGBIpaqxCNxpjPIZ4Hlpv8meFD5f14iMGIlowIOf02kRo13VR9CE9eGzNhZz5a/DCnZThnGyYNpeatSpEcqH50PZOEaJglfY/WmPYNRAzgDYTGjDIPN/PsnN69JLN2aM89gH4KSa74MwPiAeSJl4siPQF+PjeeOm5ymhrAC0A+Q13u8TUybJKFFHLQpgyzqcavwkB76SgVwGbcKL/jXqka7fCIJZ6l9ka/Kdeq8WKfV/jOltHwocpMjpLGrCu9EmoS7HIuGf5Iuv
 E+TMaRB6
 pL1o+P+dtw1wNE+0TH9CbWSo2qFIsu/qbIbZXnfYnMnpiNrOhwjeYd0OrFlzKb59dJ1UFocrUi0WteAdBW4Lgzh2sI0LzcKh4Ir2Y1LZ13tmfFgsbSkj4h8mjdVkho0QYc08Kt+wGM0+BGfRZb3NC85+5jfQHalIxXOXTx/vE00I8t+NKsdGCscHkFUkeFXQFUirrrp3OSb8WKm0STamLVDD2/+SnqCpmYTFdYRvkEVtJ0fF6xLvsPpusw2uPj9QndL2buIGLlIuaBezkBAb/fdZ9+aWFssvxofZbeQABYbO5g9n4iC9FOBW4JetXzadyQBTSVoBwtPxuTrvFspX7Kzzka0SYT9TpUFji5yfgJun/S7lTaWlAwyTEHWYs43RqHuJ7M4TOuokthtXX5Y26IfeZzkvmcX8Wppqr0YpsOxBihmjLW6H5fbTAFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Jan 18, 2026 at 11:08 AM CET, Alice Ryhl wrote:
> +use crate::{
> +    alloc,
> +    bindings,
> +    device::{Bound, Device},

NIT: Wrong style.

@Joerg: Maybe you can fix it up when applying the patch, it should look lik=
e
this:

	use crate::{
	    alloc,
	    bindings,
	    device::{
	        Bound,
	        Device, //
	    },
	    devres::Devres,
	    error::to_result,
	    io::PhysAddr,
	    prelude::*, //
	};

Otherwise, looks good to me,

Reviewed-by: Danilo Krummrich <dakr@kernel.org>

