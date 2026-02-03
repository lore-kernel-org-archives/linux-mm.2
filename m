Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27639E7FDF3
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 01:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B076B0005; Mon,  2 Feb 2026 20:08:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C5E6B0088; Mon,  2 Feb 2026 20:08:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E6D6B0089; Mon,  2 Feb 2026 20:08:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF3646B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:08:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50422B7EBD
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:08:03 +0000 (UTC)
X-FDA: 84401358846.04.A1B625A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4206620007
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:08:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SfeQ7DxL;
	spf=pass (imf03.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770080881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pklA4l1gbwBdIUo+VXBOk+H640IbUsMrACe8G8jp5sQ=;
	b=FgYWT+FrX32DUl/c6BQZjNRhwyvMtFongz1/uggHfU35v1BhVv3YWmocm4iIORdcdpa+9c
	bpvFNnkKNsYOvCDQYADvQ4eBu/Bm3WZhNwz635fwmvv3yFKgFs1Xd7FAkUtoiYOgVwKDtJ
	Q4djV/WcSMhP25Zr6ko1rnuPH7vnWC0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SfeQ7DxL;
	spf=pass (imf03.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770080881; a=rsa-sha256;
	cv=none;
	b=fvFEofTf6hDwdckdFVQ85zas1bikCRBbDCJWel5Y744arzklHxQX7EnggjI0cwJVHTT8Kn
	qHRDkKH7tq8o1yiKCFoHTFl5gKkQoEPgUkFrtL7Yv0hMY6x+jXZsKITseTcF8GGV5sftf+
	iEEp4HoGzTLYWeSHXYp6SFfuZCtXthc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EACB644040;
	Tue,  3 Feb 2026 01:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532E2C19421;
	Tue,  3 Feb 2026 01:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770080879;
	bh=Lxv8UzOQzU0hdXe1SMCeEUPqA0rLHi/CHvbVzHJtmmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SfeQ7DxLGWwVh9J3Q/pdW7E5dDWg7Z0Q44LLKtN+r5gJGE4iOYrS8cxB0IgO0s2hh
	 3fC5OP/W0WQWmFqpD0v1MF6WRye6y/WPjBjJNl65a/txRw4EoWq04ZIgT9onuhB9+t
	 2CnmwCxKUXBgaExTERYYUP+VxqHHDlc5ghOPkPXxv8+ROVsuc3ortqwOvT3NzK7mv2
	 cKT/60zGCu/7P58YJXBwuoJhc70oIfaQr1McGAdZQgFHNSyGkUvFle+Jo3kknFMR8f
	 grbROcTiZ/3mStKTQ5gvM8vpz19oq3fMHzioUiS3qNbN6fQ7+fM+PejsfkLRITMaNL
	 OdZ+eeaRkP9uA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 607D1F40068;
	Mon,  2 Feb 2026 20:07:58 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 02 Feb 2026 20:07:58 -0500
X-ME-Sender: <xms:bkqBaSIIzc9CiBpspt8UhCoUtDgnoWXvTa7ZZfrw_XJmkmmBonA0vg>
    <xme:bkqBaUgXKDLua8HTwBnDAip1stjhYjirNxQvt5249q-w5ulGII7aYdBDdetBz9Uo8
    X7V83KPWtF6w_NmQuYJn4c64tYRVYL-bsZM0YMnT8lqzR3uebwJGg>
X-ME-Received: <xmr:bkqBaY05I_OKjVrTwTShSNOsIzF_nGh4NasNUJ8MvEZHazPTE-cXr-9MiHq7ANO0cg4xH3bEygsfT4S5fvg-dltKY09IDiNB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeeludeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ehkeeijeeggeehkeehtddthfdtgfejueefleeutdefjeegvefhhffgueeiteekfeenucff
    ohhmrghinhepohhpvghnqdhsthgurdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhs
    ohhnrghlihhthidqudeijedtleekgeejuddqudejjeekheehhedvqdgsohhquhhnpeepkh
    gvrhhnvghlrdhorhhgsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohepudehpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopegrrdhhihhnuggsohhrgheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepghgrrhihsehgrghrhihguhhordhnvghtpdhrtghpthht
    oheprghlihgtvghrhihhlhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhorhgvnh
    iiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrdhh
    ohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehojhgvuggrsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopegsohhquhhnrdhfvghnghesghhmrghilhdrtghomhdp
    rhgtphhtthhopegsjhhorhhnfegpghhhsehprhhothhonhhmrghilhdrtghomhdprhgtph
    htthhopehlohhsshhinheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:bkqBaShTF5tlaJntCfmXlvSAgPCe5HMcV3NnFEo81xeA2sraB0a98A>
    <xmx:bkqBaR9dr-qnQ7G2wBqCX_0bTLM8d0PInNyNB8GHRBduKlWwXYzA3w>
    <xmx:bkqBaWLzkmixNEwSeZo8yVC1ZS-sHIgckaHLhzbVMkWeLJFhVmC_xA>
    <xmx:bkqBaewcd0hqWG56bd1dFiJgAlAh7zBh7gfPvoXE9nxHG-H2xkvYDA>
    <xmx:bkqBaR0o1YbFxMuSpT12D16E_9w8l6Al8tEVaVZ31CW8odarUlu-lc_S>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 20:07:57 -0500 (EST)
Date: Mon, 2 Feb 2026 17:07:57 -0800
From: Boqun Feng <boqun@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
Message-ID: <aYFKbWfQmTInYy91@tardis.local>
References: <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <aX0lcVngRcRwqgd5@tardis.local>
 <SEV7bR_nyQNtvtgoO8X80HMkMTPLW_6roBSxJ-MpKHHNmkZQyVxSS9k1iFV7-bgAlHSLM566L8EqtRBnht65uA==@protonmail.internalid>
 <aX2tyn9nBUEKM-SN@tardis.local>
 <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set>
 <gKLHFGuJqzRyjCupif-LFYn2ZY6OmhkyYj6idYTOnN4zMmNacFLBD1G9zzsYpTJn13GGvL0i-7JA-lIlBgakgQ==@protonmail.internalid>
 <DG2WLWJD8V5W.2I24LZKS6JG6Q@garyguo.net>
 <87bji9r0cp.fsf@t14s.mail-host-address-is-not-set>
 <878qddqxjy.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878qddqxjy.fsf@t14s.mail-host-address-is-not-set>
X-Rspamd-Server: rspam11
X-Stat-Signature: xw49ac1dxsxharg6su4157jmzgsh13gj
X-Rspam-User: 
X-Rspamd-Queue-Id: 4206620007
X-HE-Tag: 1770080881-718683
X-HE-Meta: U2FsdGVkX18x98b4BMW1s5ftwKuwLkal67qJEkmevBN+XexqjoSahj1qJuXRkhHhMoEFxSzayP8uei12q6YQQ3/PI3h3y4kBdRZBinksn3Xded0S46/RhsOX5g/8cr3O05SdNlF3UiB/DxO/KdY8+CXuIkaqQBsvJQy6XUqh3IIe7LwK3L+qYzjvlE64FYeB2l6PodOzYrjZABaibbWFH2XM3uZsqcWGMsZFNL2APiwqOxszq3tw9CRNQhxcF70CNwVvVOh+ouBJpNSPWjRn+dE92pFkOSVuRKy/IU6NpJlL8tQEqELuzCT+B3H94RYB3wzUik+1dPgO2317hEBAC3Jpv6D3W20bBJ8zLubn+ZEyH8VQC7yxAvVoS0vZCQVbHriYcGUlIOyVQTHbWun5+Evbgz8F4eypEPNrzqA36WMnvkwAkGyM+4k/7HkL6rM+VEr/NzvNaFBiRoNlblwBXTT9A0QffBT/1yqL5fe/F/mRzCu16O69DEoi3bkZZWn4AYBuxcMqLZ2QegisMfbS6nG+K61yFcqFu6ZckkalCA9H3S8T+ZR0k46UcuhDY/8eDtYGh9NNG3QcAEKJig6tEqSw3Z2IGnw83/KQEPlxl/W0cq9+KFjfjdEUNaDrWyAOgyWTpJ4fXoY3qC26bMwa8trwG1fgfIxWxGtTfye/583CqafWqcUJPw5tGZuFLa627drxHFRneIJ0aO7D2lvSfckBv6+syxMwIEIZQND8Avtm1M2gw9Vwsx86dBEBNd6fTFzWA6qjjYIjmXxHC3f+C5MuLfwh/2BmW0drcmLCSBLEQ5o2eJUcXdFuxuVgIkVUy5cuo7nKwCp27OPGF5qdia1q47UbokfihZ8GHIyakkfCNF9hWNh2PETE5TfwCefZ3ZY4EvBnuTwo0gNJlV3aQ7JxDC6ephcuEWQQ4ZVKGXhlYTuxOF0e/xCasyvFOyY0lGwNcHFhpa1p/ZtruiF
 5VFzg9Is
 y4ePkUisEjVLglyy/JbNE3DsLEc3hqZaRBz5S2Eanp2rFvEONPtC2I4LtJrUYn3g9e052ghF6jIiVt9Qtg8unG3RbU8n2NLOaCcgVBWvYObmsGEEjiH9pyKEF7rBx2V2likH2cDHWX8tiyhA6fpKzwugaLHgnqMbTViwHy+Cf8qjqSfm8YCakHfskos9y7qdgZG8fTbKKDKaI0fYIsff998iUTL2wzBLbHHKC4KEecnHYDGJ9w/LVNKYAjCQrT++2Lw7M7KdMHKV8EgI5JedtsQHIICyxR/0td8mMQhY69hckpWWxnAvrU4OUTPotxaj47dwrxC/u+TzpKjhRa4ZYf6SQmlM9rqu9f6gW5LJlHF6YvK1I13ZFMkt3nGZ5Sc1bCtnu87LC70ycwG39rcMW9Sj6pdwmU+cS5CBlD/fX4ah8PPI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 31, 2026 at 10:31:13PM +0100, Andreas Hindborg wrote:
[...]
> >>>>
> >>>> For __user memory, because kernel is only given a userspace address, and
> >>>> userspace can lie or unmap the address while kernel accessing it,
> >>>> copy_{from,to}_user() is needed to handle page faults.
> >>>
> >>> Just to clarify, for my use case, the page is already mapped to kernel
> >>> space, and it is guaranteed to be mapped for the duration of the call
> >>> where I do the copy. Also, it _may_ be a user page, but it might not
> >>> always be the case.
> >>
> >> In that case you should also assume there might be other kernel-space users.
> >> Byte-wise atomic memcpy would be best tool.
> >
> > Other concurrent kernel readers/writers would be a kernel bug in my use
> > case. We could add this to the safety requirements.
> >
> 
> Actually, one case just crossed my mind. I think nothing will prevent a
> user space process from concurrently submitting multiple reads to the
> same user page. It would not make sense, but it can be done.
> 
> If the reads are issued to different null block devices, the null block
> driver might concurrently write the user page when servicing each IO
> request concurrently.
> 
> The same situation would happen in real block device drivers, except the
> writes would be done by dma engines rather than kernel threads.
> 

Then we better use byte-wise atomic memcpy, and I think for all the
architectures that Linux kernel support, memcpy() is in fact byte-wise
atomic if it's volatile. Because down the actual instructions, either a
byte-size read/write is used, or a larger-size read/write is used but
they are guaranteed to be byte-wise atomic even for unaligned read or
write. So "volatile memcpy" and "volatile byte-wise atomic memcpy" have
the same implementation.

(The C++ paper [1] also says: "In fact, we expect that existing assembly
memcpy implementations will suffice when suffixed with the required
fence.")

So to make thing move forward, do you mind to introduce a
`atomic_per_byte_memcpy()` in rust::sync::atomic based on
bindings::memcpy(), and cc linux-arch and all the archs that support
Rust for some confirmation? Thanks!

[1]: https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2020/p1478r5.html

Regards,
Boqun

> 
> Best regards,
> Andreas Hindborg
> 
> 

