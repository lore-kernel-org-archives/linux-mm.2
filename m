Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 836FDD30CC2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 21:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14566B0005; Tue, 13 Jan 2026 16:50:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1316B0088; Tue, 13 Jan 2026 16:50:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA33C6B0089; Tue, 13 Jan 2026 16:50:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4AED6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:50:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E14F1A02CA
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:50:44 +0000 (UTC)
X-FDA: 84328285608.19.FC9A52D
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5FFD3C0006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:50:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=IbYU7DmI;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf22.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768341042; a=rsa-sha256;
	cv=pass;
	b=6SNph/703BwP+YKfdrLcNqjm7oJL4MIx39YuHC6u6N0GxTwy9JxDVQQ8KdMjXr44ySmk7W
	9PlA7m2BgHhM056jtu2NcCMZC6CeDWRkSqvy+fl0fWdvWejiSJvg69GgBy+gw8fLmtipSG
	Pst0GykfA5x6Qi1N3MUfMHTdERPZkvQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=IbYU7DmI;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf22.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768341042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPLmlARrAcdXGkqRjXYNOZR541qNKastiV4OAPsNBiI=;
	b=wCjlPOl0t7xsgrJvJg+R5GkJuBe1fKiewD5FBSrVgeh4rXT7+PcYh6HQcBoYWxwHckyf7j
	HZ68+93DTC/08ecKWataWfGvB5GBYjlz+yO2igoHve4jfd+y/FE/BHykakkqVgRJVz1jXz
	Silps3BRwLjFPiN8S1LDTi5ysHRXqe4=
ARC-Seal: i=1; a=rsa-sha256; t=1768341035; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=hVhzh7AUHTdxJu6JvU4kLmFazeYoDzKotMzv/D0+4u5XOphxRjl7dZTbxQS4N5Mkz3d/eIx3IvpTS931MdBemgUkwZATmz3d1Ag1d/KfBBEFCXSBOzAQteKzUS97haUtC+K3Yy4IKG078ZDvzWmTWcDVJfiJQXhFJCr6MYk2V+8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1768341035; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=DPLmlARrAcdXGkqRjXYNOZR541qNKastiV4OAPsNBiI=; 
	b=EZj3yMH0q9j4X6ixHTZ3mt+M3ALvq0gNqc/kJlCT0VrQ1bkUJakxrFuUkyq0bfXRm0HedxzFGlGbfWhmUmmrQEfzXdtzULlZGQyzhNAN5eTtKTJlsIQMu1PLT0lJk258gPp7GviAR61IDWtfUXBAJFf5FuTibTMiQ6H/IjvQHzs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1768341035;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=DPLmlARrAcdXGkqRjXYNOZR541qNKastiV4OAPsNBiI=;
	b=IbYU7DmIuRb+kX+hMyLBkx3DFwew+5h+AoOpYREVU3b0zeTRpjIkL+MS1wX0zerY
	v+XtqpaEwvaanAklDZfQVtzj6ZSmfxod8CenGAi8MzmDUF9SUmZGBREfF+kkkP2/kby
	bX2qewW7GYMa40KjmoW4SN+/T0+lwxaZgfBkpE7E=
Received: by mx.zohomail.com with SMTPS id 1768341034234779.9306294454532;
	Tue, 13 Jan 2026 13:50:34 -0800 (PST)
Date: Tue, 13 Jan 2026 13:50:33 -0800
From: Deborah Brouwer <deborah.brouwer@collabora.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v5] io: add io_pgtable abstraction
Message-ID: <aWa-KVC8CVvn8GGs@um790>
References: <20260113-io-pgtable-v5-1-7ed771bc3d8d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113-io-pgtable-v5-1-7ed771bc3d8d@google.com>
X-Rspam-User: 
X-Stat-Signature: gf11yisnh7nntqo6mjknrpramftz9yro
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5FFD3C0006
X-HE-Tag: 1768341042-127009
X-HE-Meta: U2FsdGVkX18oWZa7nlxnyMcjbFPFzxrShgUoySExRQmqpQIMG46cGYv5NxjC5rfFs4hc7UQVnQooxIee+B+qJtPfyR6bi39br9LVcBo+EboJ+KawNv0+N5UWhCKbCf2cnqSte7szWOzwy9CpkDZ5aQhWMe8MeABRrykh6l+kfuFmjCpbeCjK+R+4EiYCEybozbIIo4Iltia02JpJzG4re8Czr0s1vp8ATiPWICM9CjnjwZ8G+kznB2H46qd5gk53SwO9JDydMfVFgkP0h594Y2GMwGuBoxtGl+VaFgLfJmlU4jmeZ3x4JJYSSeGrDEZznznMyr/J1lS5WWcxVDhlriCX+E5iih9kX1lCwcFAx3Cg4ZDqkKNI4jyVw2r+55Y08Fh1fu4MBnfARLaRKnyXFfazASRKseBrRcLtdhGLI4ouYhVqmgZhFIKtF/9QkdPaUJR99Kz69AMGZh+GD5vi1Slo197y35BjIsimSqVVRoHSRjs6+jrsjkP0B7szJGIQWpE5SmKpgbdaPEkEYyIEg2JxoNftRSZSZYystTDcSiRIzm5v9Z+9F32Yu+C1/IlN+fYFBdhTWyvblQCc/rsXXQzrDEyGOiyNfEWnrkIVAoRfNqzUQKsFK9pgjQrN7V1O6wr8A/j7gBy5geBpI0POfH88Zb3satPopNOt32fBeO28TpZ7dI7C0YkLY/97112LXS1MC1QN9mDUhRK+eIHNtA4KK59RPJgwi64OuagakP4a7a4duMZ59Q/JrSd7fr6gAc8YsBDnba22UC4AJVTC0V/TXds6URHxVfbUF61HA4b2nKwNB2UDDe0artreQG5JG7P7dIhVNQWrGJ9TIGgkBxcw5+E10+Wbi3R0UD6CclFdKenxgsgtN2OCVGCcg5YObZKL4LbskIjX8Bb5LMQU6ixJJDMR2RKJJm2lvX3WanORMtpwPgXxStMbsa6wa2/ZbSa4wvxUfSfL9VtLRln
 V8UHZGeq
 ngmgqGuGdUJwfPjW8lH8KDrA381NnHNQLPks6awI70MzXU4KfexRacIRc1mdGIBvTHxcXYvQ9bdNaHtGrvkAPyMhCyTO+LnBk3XwwFGIbu3VmKPGUC68dusrPTL8R/vgNFgRFeTpVXNvs9ql0lTLv505Z4cdE664fOpiTCUSSybv45g72zcgeb8TNWW66xX43aJ0W1Ng/Y+So5oXoV/zK73UDAycsrnlX9b2zGZygftFcUykJwGImwx5yJcicCmN2SLUWM3fbyUocMa/adHn3PTDvSwADKgBPTFZ3ZIPxizHs0/t2pzOkxiy76LAutRHJvB99uPiq4Xqu0MHT3THRpue85VaI0/405P+I96G1olk2N8BoMoAdAyv/tcPwqfn6CjT+9BMhMe+IbEmOpINONc5AN1ZYa0VMBTimIMLH78JLka9In/HpuF9EJSzz0k2lzPvnSdkJVoQN+kYP4GBFyiyDpknJDgBsS4lXH/0J9vN3Y+qY/Ey6vHe8EvOWsFKH18assa1aFGz9T1w4G4GzEYYZ6oHP6qYwRTdFJrf/DrE/VoDn/Cv0mNrPCdK4d0FSNH/6fA0SSvc5ozrMWD8Uj48dVLdUw4rcgn0F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 08:49:27AM +0000, Alice Ryhl wrote:
> From: Asahi Lina <lina+kernel@asahilina.net>
> 
> This will be used by the Tyr driver to create and modify the page table
> of each address space on the GPU. Each time a mapping gets created or
> removed by userspace, Tyr will call into GPUVM, which will figure out
> which calls to map_pages and unmap_pages are required to map the data in
> question in the page table so that the GPU may access those pages when
> using that address space.
> 
> The Rust type wraps the struct using a raw pointer rather than the usual
> Opaque+ARef approach because Opaque+ARef requires the target type to be
> refcounted.
> 
> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>

As part of the wip for booting Tyr firmware, I have been using this
io_pgtable abstraction including v5.

Built and tested on arm64 with rustc 1.91.0 and bindgen 0.72.1.

Tested-by: Deborah Brouwer <deborah.brouwer@collabora.com>


