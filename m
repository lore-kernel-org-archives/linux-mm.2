Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D065CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47508E0007; Fri, 12 Sep 2025 04:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1EF28E0001; Fri, 12 Sep 2025 04:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B7E8E0007; Fri, 12 Sep 2025 04:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A84E28E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:07:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4524B1606E5
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:07:39 +0000 (UTC)
X-FDA: 83879869038.23.E1441FC
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6D0EF1A0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:07:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iI5jFlHN;
	spf=pass (imf19.hostedemail.com: domain of 3xtTDaAkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3xtTDaAkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757664457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tgtoriTVA3wUl1fLwqvusUWB5z4BoYTpvvOhTysEkY=;
	b=kuBOTqle5aXCNrebUXJt6/JJ6IVeeEoPXUx+DHUD9qkhXwGtolI0V6UwpK3LAPOAT4f1zM
	BLWfxnjVP0X+PTM4J/cySVhL89wN3x57IX4nJhQgyMMJVHtIG/zCrKtT67/htygCgpN2iR
	pPIy5KPi+lC9PaP4fSXH8rzgxshgdqk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iI5jFlHN;
	spf=pass (imf19.hostedemail.com: domain of 3xtTDaAkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3xtTDaAkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757664457; a=rsa-sha256;
	cv=none;
	b=JOHJxlMK5nQHUbpTF64wxdkxlc8Cyas4Cxxr3m1nYvbczGp+rn1CPXC8GXRp1OpYBfhCVH
	HV1WtLBgYHJwI1otPnnJzqz/HeDmZaE2OyL73M7U+paOM7Tv4qcDN1+KG+gGK4k2Vf6e79
	wbB5EWpK681vOmFR3uzJY/PdWBqc/mY=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3e04ea95c6cso744227f8f.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757664456; x=1758269256; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+tgtoriTVA3wUl1fLwqvusUWB5z4BoYTpvvOhTysEkY=;
        b=iI5jFlHNVP1ae41HWtfKSIMF/YWtOt25OPxseYhU9YCbTRxDCyp162kKOzdTu8UrTO
         O7JvdAybAFdo9cmWWQc0lLcSUxOL7edDJIDlIRqmhq5XRlcNMlGwKH/UTSWaSBHrsJwi
         d5I1KPWcppU6w9zM2JHIA75dHfLSqTgQUqx6ogiDU33VLvE+X793d9CpxaN945AsAuv5
         MYJmhCU19j4QK7Od0654Fq8PoZ0a38K55QhHqTBB+QtmtxzN1n1HFNvgvBuGkVc9P1YW
         JpFdjCRadtejLZKcNoX0W0LzVXebPNgb8rNgT8z+iuCe7HJiV5gacisNXB+1E4r759qM
         cQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757664456; x=1758269256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+tgtoriTVA3wUl1fLwqvusUWB5z4BoYTpvvOhTysEkY=;
        b=YQAth8X0amyVBK6mXqa8a2lmiUm1DzzfqWzGhiyC1WjOruGBbo7R3IHLtmbZu/GzcZ
         pvuo8nE1XxNOFgw3dVbBU7hhJfmTi+fcMb7Cq8WC0eoVsf83jU3dtEhFTDhuoc2r0hPh
         giotWAsBT2cokZGp5Z+feVxFJt2vxCLwuvWZ9SPmgxYbZnYJMBzKLRU6HSbruUnEK6pX
         nmhx42EyTCweqRZ+CIbjLTHWMqGsrIJDZKHimBcfd6JNf4d5RY4tgaHHChqrIQqAtbET
         e+VIWjPzhZYJr9NRFpbGOzLLjafGmCSSnrlt1/gqwhgI3KLcllBf7/a4ljuVYEeUl6yo
         g+sg==
X-Forwarded-Encrypted: i=1; AJvYcCW3l/HrnGmMngVcBrXQ1M8DBGwL/O/Ig+W02PTaCDBixk6d5ko6KDFz2saLMdgpv2hQPSULme4BpQ==@kvack.org
X-Gm-Message-State: AOJu0YxqNJG7aGJHSDagqbJlV67m7ETHnhtxMUQYk6belbGV+eH3ux6t
	b6MkHanF2G0sK2YCXL9vJJjBl2fMUHJVqxqqqsnshfuuIxpmceEmH+TDtXSTpcDZ1Ao2E5Hex+i
	GJYmGrIWQxtQvcXTY8Q==
X-Google-Smtp-Source: AGHT+IFkxsfqAcrnekL3Ice7pB/PeSHdeKiiZaFaWBiHr3Z/hX7oTQ21wuR0+bX+ocJ/wu6+RCMQdyFuzPpJpAo=
X-Received: from wmbdp7.prod.google.com ([2002:a05:600c:6487:b0:45b:9acb:6940])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2f87:b0:3e4:8163:b6f9 with SMTP id ffacd0b85a97d-3e765796c6bmr1878906f8f.14.1757664454769;
 Fri, 12 Sep 2025 01:07:34 -0700 (PDT)
Date: Fri, 12 Sep 2025 08:07:33 +0000
In-Reply-To: <20250910140212.997771-1-ojeda@kernel.org>
Mime-Version: 1.0
References: <20250910140212.997771-1-ojeda@kernel.org>
Message-ID: <aMPUxZoV9BCqDg0y@google.com>
Subject: Re: [PATCH] rust: maple_tree: fix intra-doc link
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: aoducc6msgx6awaniug7sw5wk7u4zwf8
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D0EF1A0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757664457-493494
X-HE-Meta: U2FsdGVkX19GYyoyD0OWrH24NOyc8i64JIfwk2KtisKfe9IicdFSFu/4qs8zKYb2MjcxdpDj3ssv7vYMBVxYpdIXCzcNJQgCjeoOPxh4LMpPNuyVx9uC9dSxv7po0sqvyYaTsCY+PAphD4lYnUWd/R6chWteFj05978SUjCVvR5VwkKN8fG1p0Mdo5Ze2iLpdIuW1fzfn1xKVTs5vlSN38WitTo94zZSMUhn5dCKnxlOVt4S7Rnm/5EooLHygeFJcx53bTAR5v2WaOs4pDrJRhnWLpTLZ7oxG0qV4BNVdfHhdOglFp1BaShgovF6UT/sIXemiAEJgM84Q7AfQEggitXYNdKW5/hpUcZgUanF3S6fEpo4bLAj8pvs8o2YHDnGbm+g6L32ZFzvPX8vxY0jF1VOsVgaTB/qXymQrRE9f8NJNJjRYC56kMkP/N1YkfgiwJh2uHyzYGPxW1FT8MSQUban9rw3HXAc7duP3Ovrt3TInA6m5K47Nl+Fl8TwVsm+1wUBDIcbTQIvSHniQTcug0aL7rMiMuaU7C9oqqD+QZio4ak8lQM6p9WS5GCVuA7GqFbzMFWN8a9HnbS9Hyu5N/ewNLg/JnazaHuM8gOq1Bs8DeqdIzdT9lhqF/WJ66OMZeVbEy6CRb1gYZgzsWTefpKp5EHIP6+RJuNChutmF/sHs3ABMTSsuKTOWHZ95tzUzO6az4yei72I5M97TDBOGsEyJS8eku0GdJOs8Fz0j40vqrCTpiIBYV1Mh1vq5qpAJ9+wxcQkbkEXMIAE/YGbd74cGQR4nFPEMND5/38gNgO3CsRLvpb/mePwNLZRYSEpbx1iNcNXUg3rUFZm+NzxoiYQV8JxMr2t6OMl4ATAfvly6L2h7yXUvOHBDnt9Ee0bOb+6yR6pz8Eg+Yc5N35G5VulfTEgWUAPjM1Q/LwEvkHRqivpB8lgmQrH7xLJQ2mG0Zxq1SjyLLVMXf/Xy5B
 7oT9suPu
 fhNfHWQgcJ3cW2w956rQCwdiaoVuS7Lxlx5XGosepRQbxblNX4gY0E9eQJfKsg4GvtSG5Hy1ELIW2qaFj68i4clsQ95mf0VS14UDw/vONZva4+Z+//OnZ7yOw5nPiwnieb+c3Ao9l1gSnRLgjBGNNUhtGUX/X+s1uOp+XFad28KgPvGjmwYVuk//bxppXtuj6fqMP9hpVJ9yXCkP0Yeu+BBkDLyrcrLaPXTcpTiq+PpSeSA//kfavpE3BMh2XWMsvsfJgH35LneZMtVIxnJjfTm3vsdyiM2M8r6Kf0T5L3k/+m8i0dbnRBrmAA+DtUkvNbUA2Wl6uIo3UGTAyCazZYwetdvY1mg6jiMPNM546/vr5MddiCABhEjiRICpWpIG8BGjHyS1vdxwuNYyvxU+yOUdGYSp5Nymu7LN7bxNRp9mRfNQDOp5e/KK5W6u6RYG8eCLD9xW5A1b2wKSXwwQoWbhT5dwaL9TXuu5nTe9W3XTQSiVsEKhc5rg5eM/iOChzlOJ/4izhgkHvBu3C7rqTuLgw9u1KQaV7SsNRBxVpr7nwr8oHOISKHuO25FbXlvWyndDbzNrw2w7FTMoHKFdDGXkisfiB0uQzEsTzaSOv/UOUmPOT9BfPHjLHgAa0yGLN8RoPC82mvd2dIsRShAyUVCOxS4yJkKxp7nz1j1Rlqea4RBaEQaX8FWOFIYoNo6RNOpeEzOUd+a/kJQXtJEMajamcq61rRlqfXZn5+MciYkSKE3E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 04:02:12PM +0200, Miguel Ojeda wrote:
> A couple `Occupied` intra-doc links are broken:
> 
>     error: unresolved link to `Occupied`
>       --> rust/kernel/maple_tree.rs:96:46
>        |
>     96 |     /// return an [`InsertError`] with the [`Occupied`] kind. It may also fail if memory
>        |                                              ^^^^^^^^ no item named `Occupied` in scope
>        |
>        = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`
>        = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
>        = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`
> 
>     error: unresolved link to `Occupied`
>        --> rust/kernel/maple_tree.rs:135:36
>         |
>     135 |     /// [`InsertError`] with the [`Occupied`] kind. It may also fail if memory allocation fails
>         |                                    ^^^^^^^^ no item named `Occupied` in scope
>         |
>         = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`
> 
> Thus fix them.
> 
> Fixes: 7f51d867d2ed ("rust: maple_tree: add MapleTree")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>


