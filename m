Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40476D767E5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E54C6B0088; Fri, 19 Dec 2025 06:43:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879216B0089; Fri, 19 Dec 2025 06:43:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A04F6B008A; Fri, 19 Dec 2025 06:43:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 69DAE6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:43:12 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 180611A05D3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:43:12 +0000 (UTC)
X-FDA: 84236034624.30.B249BBC
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3BFA340007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:43:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W2XHonfq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3TDpFaQkKCCcDOLFHUbKOJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3TDpFaQkKCCcDOLFHUbKOJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766144590; a=rsa-sha256;
	cv=none;
	b=X2liMKSKkIukByIiANBToEnnuI9Mr4v0B4MlMDYc8M6TnK4i4Lfo2XgXhA6B0ybuxV/5Ya
	TQ07MSwRHTFZBn0Kz3+AEtbHsivk6USSTrKkbSufmE6tGjV0o04BQ9y2vdL7LrqU7YO/ss
	UQaZCf111wVJaEdan/gZeXAwzsr6DiU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W2XHonfq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3TDpFaQkKCCcDOLFHUbKOJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3TDpFaQkKCCcDOLFHUbKOJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766144590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HgOuhXFb6asuFtmyA1DS3ttJfuOKyeiapeN5mpH9fMU=;
	b=N1TBb8FAFWvnL9tCIf9ix/I3aJni8yANq+KnlT2mt70khuZ3ijYYu6IGq5glbYEnfa1rXx
	AcFA8uKNNriE75/y4OwpDv0oeoDezAPP+X2J+HkHMi8OcOUWbKBYS8m0drf9lKeRk/wSJP
	3yyj0uRWdvQsjPBV/EpWmeOUammkEzg=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4776079ada3so12859565e9.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766144589; x=1766749389; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HgOuhXFb6asuFtmyA1DS3ttJfuOKyeiapeN5mpH9fMU=;
        b=W2XHonfqR0fGUlwAS8OqNsIARAleUntyPNSqMf6FLD5FL0uZ8daA/6VRcVkuNpjIXQ
         ixClGq1Sn6lio/C1y4KnQpQz8mhH5rqzxFOvmOXh+kSbc44oOOshxJWVgi9nICj82ZSd
         DWooeUCyHaFM3K9dTn7GbzcnHVY2hvtRITrlrMmyA2IKeK2GzhoEFTkocrOrjnBtjkMY
         NfXi07y9uzKAkFuLpqKswwVgHxAOJpAhMFIGYQ+N4Jk85xt0+HJS8U3BecfbT0XRt7eh
         Jr9+jlgUpwW9LKfAzVldwE5YXErOMjYd1vHNSVIYZltk+NinX7kPoPetv4moNIp6w3os
         fN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766144589; x=1766749389;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HgOuhXFb6asuFtmyA1DS3ttJfuOKyeiapeN5mpH9fMU=;
        b=b1dyrjWCT16b/kzj5H2GSRD4naDtemM3wgkQlsoM+6EMX68CIzZanwF7YCcj9q4bN5
         X81Iv5U+c4YV3wL0eP4FPv40eCtO1Tni28g7OEDfq0jqQXoK/Prw6nMTOReas/216VVa
         GRFmm2USdGmOHmfsYWw7QnQMN9Ob8BGYRT+q1R0EebSUJw1Miwh46rQiwNiFkyYxNrCb
         uwtDXLsyVU+2oZorc/b2jFmXpAHqn/5naeWfd9F2A8QXyFNl9u38S0uaVddVS0IqMvJT
         dmGbYfzsUVN0pJ1XYBZ5FosuDqZ0UID4Ajuu23g5uKq9+7HN7JYWjA8Eml/xYSdu59sq
         x1Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUvsigPRCqMVwk717DRWwu48+Xe8BupjIXZBj6DmIoyH4EVEJPHcZE2KnWm8v4xASjiorKeKsc8/w==@kvack.org
X-Gm-Message-State: AOJu0YwthdNn/1Yjow0E/4Zx7VbW8aJ746TJJw51x20eiTHdA70x4K6q
	X4e6CTSf9YppOMFtBLEHENjwFU8mC98wqV6dqRhSq/6ZKr6iNNliajXCWRjSXFOKhoghNTF3OO9
	fpEQvcvi9gNsfY2yArw==
X-Google-Smtp-Source: AGHT+IHprtxZfJiX2ZTaI0JdAojBb71DA2tCdz167jCwg+T/Tn5dVzLQg5Aj76IcKhmIc5GQV60E6z/fc8k1Pj0=
X-Received: from wmoo20.prod.google.com ([2002:a05:600d:114:b0:47a:9f70:c329])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:524f:b0:477:b642:9dc1 with SMTP id 5b1f17b1804b1-47d19594b2emr19835145e9.20.1766144588812;
 Fri, 19 Dec 2025 03:43:08 -0800 (PST)
Date: Fri, 19 Dec 2025 11:43:07 +0000
In-Reply-To: <63063977-BA16-4F00-AFBA-8DD6409902E1@collabora.com>
Mime-Version: 1.0
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com> <63063977-BA16-4F00-AFBA-8DD6409902E1@collabora.com>
Message-ID: <aUU6SwJjch1R56t3@google.com>
Subject: Re: [PATCH v4] io: add io_pgtable abstraction
From: Alice Ryhl <aliceryhl@google.com>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Robin Murphy <robin.murphy@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3BFA340007
X-Stat-Signature: dar8mw93pu5x5zhz3ry7qaotwcsbmhhz
X-HE-Tag: 1766144589-450413
X-HE-Meta: U2FsdGVkX19Q44AfAmuU7z2Nu02SLh5rfsRmiusDf9fPIHZjS1Y2CPM0QSGVxFjyGyS5X0wxxh+CIUwpNsVnWmUyGSZgOjfkf+M3aYJ9dkmBX8nVixD+97sbqPrmJ8RUKf8cNq2BoDs0bCciej5V3LaMf3tl4nMlF8dKjxux9e/kzkzAzvdc1AoYM/y6w2q3HbXYqMrSpl/dGpAk0P2CscOiD0m+idGun8v8Ps25iCJuRAN0ZQRkGDu3E2PuhPxHdVVLaYzR+pKmCMiOq0vgtVG/HEBrgyryknahu0Ru3us8xil0JrY7CVFgfJdELkZUiq0AQ9dhWh9a2nL7/CcNma4MOCmPh7FtcyBeZf2o8/dUrzPiDe/A9jWIVbAOhktJXKf6/E4CxJGJzR3atpVym0I6EMmCBzb31EiO1ZlGShOYhJMDQrmFtkrJ6zANvt+Qai9ZWBm04BguRBxYtUfIuvQVINud/TrvQAw4eHdF6r9XKXTkJoM/t59mPhqUPGKBz9S5UU2kcRvtdnvqmeUwG1Yhtlde5MPx/OK+68Sc0oYvuXmbvkNiVaGYdL8/ztg2KmQ4hB/9qoB1JhqgTzZACUuoPpezf+Tox+l3yQ+3s/6l9Ij9G1mbQKNTkeXm06LCozZRKEOr38DqRq1v2X51BlPRcW7N4bCGJdDoOq0G/QQfFMBg9E1fdQj2gh/jCNmXAgb/XpLpvWMhZ6rbKQXeGlH8JxDfrVbDuc58TGJirya3/rdQ5OewdWSqHO7+p/nE6YW22fdLQvS4VxtypsqvqqEdrAUARHg4DKtRmQ/rQvQgwHfk8tcluWlZeyjS1o1AC/jwMO2ACkKoCHofFGdzVuTiFWc9cvTMM/3OkmoFTIytMEfJFuzisF2J5AMzhQrIJaf9jw2LiRn/dp3e224MaKMG9tyX+h7Hfbir7QFMKPurg/wTWjHnXxuk8mZ591cDEv/KHX4D2LbHSmGGIBx
 XSLdzhFP
 xjmc7ybTOqoaamEDokhO+CU/9CjTngEhSjSKVZPqIOGIcjxcyysdPa1FGU4szWZ+Gsr8HBSroyhyW85lYSURo4Ka1p3MvNmo62FBxp+UxP6i5u/s7On2FMhszBXEnJ7GisO1/2d+qavNQNFjOEnCjPsu1WcqfmAYjj0/mcsAGAKYCWf5lc2zi6vX9jSAxKPbzPPbw5NZbZ2sNm/tCJvS7vpFAQ18RR0D5FrszkDjYUBanJrJxKrBShyk8wnBWMApMwaI3FiFwXEXCJQZYtpMxNYOn0zlKt10SXY3ST8+LGLdEgrbhh1RrBofxKq3O8WqMQg2aLexTMaiIi/u1bMTe+LxwrgAb6K7rEyFZFO/yBx02MfyGONsCLmQo3YDq60BZqJrgFCX5jscm//4eI0bKn4xvu8qeT+LY9dl1ysUM6PW6fO3pl5sYIMasm40cpfxkxxop7hr/B5W8YIyiBfwdPBaULU/PCci916NFOjfVLu+JGapkNRrxusTaAM5DTROGBEVzmQHg07xB3BQ77GYUpGCkZk61LVikrK/WfJkt3b9neyqSXpvbA6U+LXN++J18GMiTABpp9vOLNb130d2MM/RNPIWdrE9Z9Snr3NTL+ZphIck7/gtSkX+TdOUghArAsH0lQseE47xXD5Xtduw5gm8g7GLz3dTq3EQy93tMFJc84Juhv4uFc16CntrS/JR8Xt3RY0xfVa4iE8dAm7fKzq5QEa6q9T5Ti4PMqK7T8Q2iC5cbl4jqUIS3Cqfan969HRKDB3NhFBn54YWm80GmpP29kX1cmDQIf7W+PpT/9fc2GO7QBZjY/D/wvA0D4VtyET9hlbc4X/Is9HWhIG2Xk3rNOmsXtlrios5NQ7lxnTbkan4hiRxt3uSiPpt0eKvKWqbeMsYNgXpBMzL+ytxfKw8MhqpRgrTLMwideiDoUw0q3RI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 08:04:17AM -0300, Daniel Almeida wrote:
> Hi Alice,
>=20
> > On 19 Dec 2025, at 07:50, Alice Ryhl <aliceryhl@google.com> wrote:
> >=20
> > From: Asahi Lina <lina+kernel@asahilina.net>
> >=20
> > This will be used by the Tyr driver to create and modify the page table
> > of each address space on the GPU. Each time a mapping gets created or
> > removed by userspace, Tyr will call into GPUVM, which will figure out
> > which calls to map_pages and unmap_pages are required to map the data i=
n
> > question in the page table so that the GPU may access those pages when
> > using that address space.
> >=20
> > The Rust type wraps the struct using a raw pointer rather than the usua=
l
> > Opaque+ARef approach because Opaque+ARef requires the target type to be
> > refcounted.
> >=20
> > Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> > Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
> > Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>

> > +/// An io page table using a specific format.
> > +///
> > +/// # Invariants
> > +///
> > +/// The pointer references a valid io page table.
> > +pub struct IoPageTable<F: IoPageTableFmt> {
> > +    ptr: NonNull<bindings::io_pgtable_ops>,
> > +    _marker: PhantomData<F>,
> > +}
> > +
> > +// SAFETY: `struct io_pgtable_ops` is not restricted to a single threa=
d.
> > +unsafe impl<F: IoPageTableFmt> Send for IoPageTable<F> {}
> > +// SAFETY: `struct io_pgtable_ops` may be accessed concurrently.
> > +unsafe impl<F: IoPageTableFmt> Sync for IoPageTable<F> {}
> > +
> > +/// The format used by this page table.
> > +pub trait IoPageTableFmt: 'static {
> > +    /// The value representing this format.
> > +    const FORMAT: io_pgtable_fmt;
> > +}
> > +
> > +impl<F: IoPageTableFmt> IoPageTable<F> {
>=20
> I don=E2=80=99t see a reason to keep struct Foo and impl Foo separate.
>=20
> IMHO, these should always be together, as the first thing one wants
> to read after a type declaration is its implementation.

I thought it was pretty natural like this. First we describe the page
table, then we say it's thread safe, then we describe that a page table
must specify a FORMAT, then we describe that it has a constructor,
then we say you can map pages, etc. etc.

> > +    /// Create a new `IoPageTable` as a device resource.
> > +    #[inline]
> > +    pub fn new(
> > +        dev: &Device<Bound>,
> > +        config: Config,
> > +    ) -> impl PinInit<Devres<IoPageTable<F>>, Error> + '_ {
> > +        // SAFETY: Devres ensures that the value is dropped during dev=
ice unbind.
> > +        Devres::new(dev, unsafe { Self::new_raw(dev, config) })
> > +    }
> > +
> > +    /// Create a new `IoPageTable`.
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// If successful, then the returned value must be dropped before =
the device is unbound.
> > +    #[inline]
> > +    pub unsafe fn new_raw(dev: &Device<Bound>, config: Config) -> Resu=
lt<IoPageTable<F>> {
> > +        let mut raw_cfg =3D bindings::io_pgtable_cfg {
> > +            quirks: config.quirks,
> > +            pgsize_bitmap: config.pgsize_bitmap,
> > +            ias: config.ias,
> > +            oas: config.oas,
> > +            coherent_walk: config.coherent_walk,
> > +            tlb: &raw const NOOP_FLUSH_OPS,
> > +            iommu_dev: dev.as_raw(),
> > +            // SAFETY: All zeroes is a valid value for `struct io_pgta=
ble_cfg`.
> > +            ..unsafe { core::mem::zeroed() }
> > +        };
> > +
> > +        // SAFETY:
> > +        // * The raw_cfg pointer is valid for the duration of this cal=
l.
> > +        // * The provided `FLUSH_OPS` contains valid function pointers=
 that accept a null pointer
> > +        //   as cookie.
> > +        // * The caller ensures that the io pgtable does not outlive t=
he device.
>=20
> We should probably tailor the sentence above for Devres?

Maybe "does not outlive device unbind" is better worded, but not sure
what you're looking for with Devres tailoring.

> > +        let ops =3D unsafe {
> > +            bindings::alloc_io_pgtable_ops(F::FORMAT, &mut raw_cfg, co=
re::ptr::null_mut())
> > +        };
>=20
> I=E2=80=99d add a blank here.
>=20
> > +impl<F: IoPageTableFmt> Drop for IoPageTable<F> {
> > +    fn drop(&mut self) {
> > +        // SAFETY: The caller of `ttbr` promised that the page table i=
s not live when this
> > +        // destructor runs.
>=20
>=20
> Not sure I understand this sentence. Perhaps we should remove the word =
=E2=80=9Cttbr=E2=80=9D from here? ttbr is a register.

ttbr is a method defined below with a safety requirement.

Alice

