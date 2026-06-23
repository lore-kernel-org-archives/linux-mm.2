Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 211BDCD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 17:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78C76B0088; Tue, 23 Jun 2026 13:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A036B008A; Tue, 23 Jun 2026 13:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18E56B008C; Tue, 23 Jun 2026 13:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A80856B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:53:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E661140599
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:53:09 +0000 (UTC)
X-FDA: 84911923698.28.7B9E759
Received: from mail-106111.protonmail.ch (mail-106111.protonmail.ch [79.135.106.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id A48FC180010
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:52:59 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782237180;
	b=ueQipK106ZedkRDVSzWbpk3qpwPc9HtrfCvIT22TH5L6YKL6qmW3ylOMNw2n0fS1a+5SPx
	JIZr5sOzBfJpm7mTakGjc8/y6mVAkMjDzfFuQVbArVL4rgdOeFIhrZoRw71V3Xk4Oo2aLR
	FNqDYgZcXrSsiN6I1L/nWAvU9hy0SgU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782237180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4Is0q7DP6LQ80r/3dZ+cvP75TsKFlNwA4YLWr0Cmjo=;
	b=X6fPOpRlBaY1xBwNsZwNLOGtNIO0EXliR4R4X/H6kufJcedcaLhhe6L/rcCnvCEhfNmuVy
	pUq5VZu3LvzSR/kfYklG9NkgPP4KlTExLODuiExbWXTvz2dth49gu4C00aaIFT0TBuvuAl
	5zQNHhxhggF73zHeEL3FtWbRIZkhApE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=protonmail header.b=IUwcPBUm;
	spf=pass (imf06.hostedemail.com: domain of work@onurozkan.dev designates 79.135.106.111 as permitted sender) smtp.mailfrom=work@onurozkan.dev;
	dmarc=pass (policy=quarantine) header.from=onurozkan.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=protonmail; t=1782237176; x=1782496376;
	bh=s4Is0q7DP6LQ80r/3dZ+cvP75TsKFlNwA4YLWr0Cmjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=IUwcPBUmckP5rXwZanc2iqSVRvyw2KiD/T2Pka87Rr9k4JwUwaQxuj1ie3YNYlWKu
	 5SUso8FzI/8S2nwliVNmKyy5T6vNtzQOOJYflWqR4gKYe/zJeoLkX1HssX7w0KrrYT
	 z5a8Xo2nG83wDO9cxhI9ynMlCnHSVndW/Ik3uZsGUjQPd27/DkqV1pdBnZ3kjyDvuw
	 hdo6xjK3+Bn32c5Rbvy9noKj25u2gjwfNJsOcGOE2Qoat1hu7dE7fElB44u+harnIi
	 XQ9bAQvtPyKSzo8iph+srCyfCU2kULocTMHVEXB5Lq44IPfTpcHPWSVdV2JadFB+qu
	 nf58a6hspOA8w==
X-Pm-Submission-Id: 4glCMd2JVcz1DDKr
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dave Ertman <david.m.ertman@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Viresh Kumar <vireshk@kernel.org>,
	Nishanth Menon <nm@ti.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Igor Korotin <igor.korotin@linux.dev>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-pci@vger.kernel.org,
	driver-core@lists.linux.dev,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: Re: [PATCH v17 10/10] rust: page: add `from_raw()`
Date: Tue, 23 Jun 2026 20:52:41 +0300
Message-ID: <20260623175243.83672-1-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260604-unique-ref-v17-10-7b4c3d2930b9@kernel.org>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org> <20260604-unique-ref-v17-10-7b4c3d2930b9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1782237179-762369
X-HE-Meta: U2FsdGVkX19vP4GHjEyt5aOcKJiwMysBWG+NJ68qpCZl0OdIVbzu/HQBRJSVToF1YWpk9j3fDI7yA7NnSbKr2RA4yE/Nx26YwhD44NY1vI20UO1ePlcFmPnHBwMoiYxOw09i5zE0Z0i8r+xAA/Kd640c9aaEEc14isHC+TsL2f1P3V/VyB7ANJv6QduhzXPEzbT+L5skrumc2mMm6C/PsMKUvurqEuZMCLRTvu3eJqudE2aZya1N9qnE6V/aZsB05VaqJsuI/1TPMLY1P+8xL/BdAV0Cy7dFnn70qftrB+0HycWPaxNssNCnsKRIe9xauFDUJ2/frOUXIWn0j/MNtYnkTDyrEGqL/lsYtCBz032QmjFKxmKsKNulqfKdq7pBA4pxacbCjjW4zTv61lHHHrfrErG5tXjO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 04 Jun 2026 22:11:22 +0200=0D
Andreas Hindborg <a.hindborg@kernel.org> wrote:=0D
=0D
> From: Andreas Hindborg <a.hindborg@samsung.com>=0D
> =0D
> Add a method to `Page` that allows construction of an instance from `stru=
ct=0D
> page` pointer.=0D
> =0D
> Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>=0D
> ---=0D
>  rust/kernel/page.rs | 12 ++++++++++++=0D
>  1 file changed, 12 insertions(+)=0D
> =0D
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs=0D
> index 844c75e54134..d56ae597f692 100644=0D
> --- a/rust/kernel/page.rs=0D
> +++ b/rust/kernel/page.rs=0D
> @@ -214,6 +214,18 @@ pub fn nid(&self) -> i32 {=0D
>          unsafe { bindings::page_to_nid(self.as_ptr()) }=0D
>      }=0D
>  =0D
> +    /// Create a `&Page` from a raw `struct page` pointer.=0D
> +    ///=0D
> +    /// # Safety=0D
> +    ///=0D
> +    /// `ptr` must be convertible to a shared reference with a lifetime =
of `'a`.=0D
> +    #[inline]=0D
> +    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {=
=0D
> +        // SAFETY: By function safety requirements, `ptr` is not null an=
d is convertible to a shared=0D
> +        // reference.=0D
> +        unsafe { &*ptr.cast() }=0D
> +    }=0D
> +=0D
>      /// Runs a piece of code with this page mapped to an address.=0D
>      ///=0D
>      /// The page is unmapped when this call returns.=0D
> =0D
> -- =0D
> 2.51.2=0D
> =0D
> =0D
=0D
Reviewed-by: Onur =C3=96zkan <work@onurozkan.dev>=0D

