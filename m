Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3A7C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 16:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E90756B0088; Mon, 28 Jul 2025 12:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41BE6B0089; Mon, 28 Jul 2025 12:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2FF66B008A; Mon, 28 Jul 2025 12:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3BF36B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:04:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7151A5886F
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:04:17 +0000 (UTC)
X-FDA: 83714145354.28.DAA9AF3
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2D225C0015
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:04:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ewv7sFcN;
	spf=pass (imf28.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753718655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HgVIowzMLl/c31IEtlhtiNAMDBO1tT9OzRoFR/KHf0s=;
	b=WZe0t5SQVBOMLF+/3SEIIzDB18LTke6W8kxY59H85HCKA+kSCAXtvSCofyEqBUxXMpRG8X
	ef9khjNATFHR6dqSAsErUirSrkEU7cu+jvpsfP9VKvmElIE8uiCIRW6zSmkZEnOGvH72j0
	fQq0Mfjn4rVa5JOwe6be7vuV8VTrmco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753718655; a=rsa-sha256;
	cv=none;
	b=Py1NHpiKxh5OqWU0xXg1gs4Ocgem9LKWUhW3v2lPekgFo8mxLO+eeeyfElFaP3FP585Hwx
	wx36/Z/0BDtof+GrwTCFuMSf36UNHeCxu4zJz5+PwF/spgM7WBWOuGZ7bQ6bfLPLA99Qzz
	NGugbZGQ8vaLbjKtFxUxn6l+pUuA2u0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ewv7sFcN;
	spf=pass (imf28.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7df981428abso701297285a.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753718654; x=1754323454; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HgVIowzMLl/c31IEtlhtiNAMDBO1tT9OzRoFR/KHf0s=;
        b=ewv7sFcNgUxWbTFC3+dCctWvAdb0kveZIj4S/Jq288kEx1iRMPUeWtRieMLA3VO+8Z
         Vx6r/389loeuFV01J+hT2fmKug9zMOH6OXpBRsYK6MhDhH39jdYFfAVTndJZLTYd7AZL
         9hvXd6n5Nflb+CmUijs6iTC5g8fb7lioDc/oxsoq2nQ7Lb1+yrNOQsayfdcVF6Q1NLYm
         VREsiK7BX5RvDH3kkM7WBjD7PNUBWbqplLyfjvbI8PKxTDIdEuioifDKJFvDuHpGxLhE
         WJ1vF1d5iKSj5UYTY9BSHaIQugvHuN2TP8P5v/dJXinJOoE4JQ+EiMCpRYHxuZbXPyna
         C34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753718654; x=1754323454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HgVIowzMLl/c31IEtlhtiNAMDBO1tT9OzRoFR/KHf0s=;
        b=o1WniHAhnNOknsctiS+uiyDEz3sXWotAGaYz6aKoNzjETZL0psLGIt5h4tHzzbYDND
         CJ3zbL8WDzEAR27ohhAw99j1/16bRS3guCIq45sZWZmDjs6yc1hiFfBnvKPot5xNKuFp
         vBlPk7Mk/DKAvAXfxd8ypzI3dHAFEWNC9QOMqOk0htxNQ2eGhkLVzQahl6woaUYSytg0
         YajKHLlHmMZdb6u/aAkRj1+zb9ZRgXmPvi+mrOjU+D/L1egVWpz45YE5YrEVofQERY91
         /HNZWFHsIUcs55j+UiM+uG7iXBsuwwtR690Cupfxx+RpkUVtVAA2/TPLUuYVCXWZo1FP
         h6+A==
X-Forwarded-Encrypted: i=1; AJvYcCU8Jh7zEo+SIZs/Pa5oC/h10B3elcVBmKSixHY4sJVPETRmcPPJ2k3t5R/rcBm+xPZZG8UIbtcjCQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8Ps2QwGE19YmtJSSWAaWJa9LDq13dICzFD4boyvEj+2mDX9dv
	p67lgae2Nj/+DjfomgG6YnIFVJaJg5kVSH22Dd37UQQVimz7OcUwa9vy
X-Gm-Gg: ASbGncuEtvRWKLUdqXpjgQEwje6rK+HMtTevn1uSJfmg1xGvHMN8lyNLF95UgDRm1x7
	tIAXBfdEdihhAhYj+Y84Pm+hWCkR3ClnvaT3cbaOBR0BJZZTnxzgeZXmaXUfuYq3Ef7bNhNG4CA
	CdqZZOeljsz/Q2BTuJtr8PFDVl0ihFwbakcjK4RzL2fWLMiYJsNPIuW0tF8t+vcZeAvHqSHtyAY
	5xs0wSRC+h4tVtdXkRSXuj5T8actowhEgfkeLDo9DJ7bxf6fiwnjStXzT9cgo2fxoo/gLdZ6NuV
	h2p9qe479Qh7n/h2tDolrEDEkHWW0KJa33tA18xo7Jn1XFSEGYrV8Zcjc0UPW/kvYjo1iUE1CoI
	cLI/ShIgOnAlTuEKkiOmXuwEBXC2Fw+qsCCjKlgaY/KOJfScjB4sxe1xfRoJb1lJ0CQfIZu2ypa
	5oi5dheqsw+y/JpY7Gd+wJyEA=
X-Google-Smtp-Source: AGHT+IEmoTOimrTi2PNwl6GvbwncBwk/yYnnS0+QBiPbPf62rdY0sZGQQYXhaQaKI8ltuQpaCRWGkw==
X-Received: by 2002:a05:620a:563c:b0:7e3:35dd:4829 with SMTP id af79cd13be357-7e63c1b69d0mr1382664085a.46.1753718653785;
        Mon, 28 Jul 2025 09:04:13 -0700 (PDT)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e64327a9f8sm310642085a.11.2025.07.28.09.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 09:04:13 -0700 (PDT)
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id C91B1F40068;
	Mon, 28 Jul 2025 12:04:12 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Mon, 28 Jul 2025 12:04:12 -0400
X-ME-Sender: <xms:fJ-HaJVwNHByxbizTaFL_NER2N37NTwgoKEb0jMl_OQ3uuyT1UGY6g>
    <xme:fJ-HaETTgsEhTJJspf20pgVrxrirrLIuAUkbGpWuk_MnzyG8y31p7gVlOvYMUbARZ
    w-OUHSWcJfW_OyAmQ>
X-ME-Received: <xmr:fJ-HaOHVtFYOz-xyAP51tE2ZT7cGGndoVjmgWD9UoGjNqfN1scySsbEpqZ8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdelvdeitdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveeiudffiedv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqh
    hunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqddu
    jeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvg
    drnhgrmhgvpdhnsggprhgtphhtthhopedujedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghlihgtvghrhihhlhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprghkph
    hmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihgrmhdr
    hhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrsh
    htohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepohhjvggurgeskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheprghnughrvgifjhgsrghllhgrnhgtvgesghhmrghilh
    drtghomhdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnhgvthdprhgtphhtthho
    pegsjhhorhhnfegpghhhsehprhhothhonhhmrghilhdrtghomhdprhgtphhtthhopehloh
    hsshhinheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:fJ-HaDfZiGYJ_3Y_Tv78lK9koMKzRMQkbu7rYDJsdsrEbSNIOqdc-Q>
    <xmx:fJ-HaFKlZNUj93B0NFuErw-NffZVTfT6I5JbtLUsxxYl9m3pfbB50A>
    <xmx:fJ-HaCqs2447yRAv2B1Ykj6aWSNTyAolHdv0LNj7tNbnUbzNyX5fOg>
    <xmx:fJ-HaLXik3XNSFJN8ohWVPRYXN1vi75UQF_g-Y_c0dyVx1NzL7qszw>
    <xmx:fJ-HaN3XQe-MWz8vmkHtMpvdV3nVjiKoFXbQb-7JmpYAAkaNBgRNAID6>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Jul 2025 12:04:12 -0400 (EDT)
Date: Mon, 28 Jul 2025 09:04:11 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/3] rust: maple_tree: add MapleTree
Message-ID: <aIefe_MEPd_yicde@tardis-2.local>
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com>
X-Rspamd-Queue-Id: 2D225C0015
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: skbwtzqs8dnm5mbosaqns5rbr8pgdhbo
X-HE-Tag: 1753718654-784370
X-HE-Meta: U2FsdGVkX1/en1EeVN+FR8e/sh1IgvNPu3SXu9eD294rnDNTe9qnrVZxKRYSy6/pa0ekBoMlk3/ctjFSxMPpOy4yHSxjh62bIIAI5Gn7moZKQRN66mMEgR0/Ylu2xz4mnUMfF04bwO6XsiLlo5905Cb3u94EaY3vA0DvVjXW/TtK1kQzfkrdQgFqD+4QJmrgD6Yb8NrU6isgQ+cB0usFB60cxD7Fnd3bzHaFr87Jbt/dYtTqEEmV6Bd3Gzxp+v0GYvyQDnHhPAYd1EErADy6lm7eR0f2JamIi5udqTwjRgpJcxqL2A27ZAMbneqihFW7LBlNJ9VVvIBe50d+S3QIMGn6YUMxufWYoMMaor81DRRr4rmTcWgEhtinT5oO0GydvvRX6pxwgUtrXux2GWxcF5VTpFYjpc5n6AHt9dZ4cmHyV/t4KkA/6d1N1D4DJ4YEA04xRTeaUXnSjNFARTo0/zh98JkJqDBlVJDVhFEjkfS1f2iTOJfvRGtVR/ZV8U7BkFtpZVTZUKpl/eGXJM82IsVSP+O/8dt8ukNj5GkgObaLqFzXOYvCsvoMAfFvOMyzvMjX9ZXrfjXvuNXly23WG4V/vXf3zKDQxfeWMp4Ui7eCfdMioEuQoG1AOB1u+xyJ1S+efv34h+gWlzdN6zGOCD2lFdV15adtG1/jmdirA/sUqKwUOiSsWHTMPtlcw3XCvKe+LVR44a7c/d6w8fuLUqOczhexnTUQlfvDtSzZQS5ndINpEaq5q4DkLSh+F0o8V0f3vktMiYtmI1LUNPygkyD+tdPJUF2VJtJD+gF1s7zch3akuID5L+cM8IBjmKzLuMADo52DduxDEA3F+y/CZqYlsoCzF215yzG3b0cA7Pmvh0KdmkWfTVHHeJJSLw2FVTvhDHaVOcIqLTTcSRrBO4WxSWE16M+4wW4U4/ZNIEohdI8xhfK/038Y/Z/399XwTBv0XOc/qKmFtRXveVM
 nCM5I7ov
 4ZYy3L8qWAqH69c+u07GLLzanxOnXgA7Rw4u1Pi56ZA9iKZ+QrCrRSttB/NDDVwSz/mqO9dfqKzPqmfttORP1iPLfEytz21ViTH9uC96EF+CmsMHfSedjY9FtyKU8j4c68HYI5ggj2hd7DKyfpB1ScH6F/c6PPP9y+CNFjm/barAcucEQrVDYWiYtD1WeZY4t54VFZZCHMipsnF/Q18dXyq5/CWJD8JoFGV+IsMc9pwG0v/kjMJo5V7hltmli0OlFRPmGWnukCUHPACXEsrVh/fXti4wLdFz6YqRFL7z1sjNASYeUz/aCwiK04/0Wp58CwlTRDPkQ4qh+mcUVeUAALHLhl0UGrVqWxWtA1HpYFqIZwJhRxkICb43ofPiZtD6m4Jnq96aXqpeV3oeRE4Ub3JpElF2j0YMcD8inyDyeoJk+ubzM8+uqTywWEUFZW1qlJw0xZRh+bubTZ3VQd6Lak2Fg5C9wPJa8G98+qfG3yodLJOfIZCGGDd9Kkn1kN/xV5Isr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 01:23:22PM +0000, Alice Ryhl wrote:
> The maple tree will be used in the Tyr driver to allocate and keep track
> of GPU allocations created internally (i.e. not by userspace). It will
> likely also be used in the Nova driver eventually.
> 
> This adds the simplest methods for additional and removal that do not
> require any special care with respect to concurrency.
> 
> This implementation is based on the RFC by Andrew but with significant
> changes to simplify the implementation.
> 
> Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
[...]
> +    /// Free all `T` instances in this tree.
> +    ///
> +    /// # Safety
> +    ///
> +    /// This frees Rust data referenced by the maple tree without removing it from the maple tree.
> +    /// The caller must ensure that no reference that remains in the maple tree is used incorrectly
> +    /// after this call.
> +    unsafe fn free_all_entries(self: Pin<&mut Self>) {
> +        // SAFETY: The pointer references a valid maple tree.
> +        let ma_state = unsafe { Opaque::new(bindings::MA_STATE(self.tree.get(), 0, usize::MAX)) };
> +

A meta comment here for the future direction: I think it really makes a
lot of sense if we could have the Rust abstraction for struct ma_state,
that'll allow us to have flexible locking strategy and Iterator-like
interface. Maybe it's something Andrew can take a deeper look when
MapleTree binding is in-tree (no word play intented ;-))?

For example, with a ma_state binding, we can do:

    let mas = MAState::new(self, 0..);

    while let Some(v) = mas.next() {
    	drop(v)
    }

Regards,
Boqun

> +        loop {
> +            // SAFETY: The maple tree is valid. This call to `free_all_entries` has exclusive
> +            // access to the maple tree, so no further synchronization is required.
> +            let ptr = unsafe { bindings::mas_find(ma_state.get(), usize::MAX) };
> +            if ptr.is_null() {
> +                break;
> +            }
> +            // SAFETY: By the type invariants, this pointer references a valid value of type `T`.
> +            // By the safety requirements, it is okay to free it without removing it from the maple
> +            // tree.
> +            unsafe { drop(T::from_foreign(ptr)) };
> +        }
> +    }
> +}
> +
[...]

