Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA052D767EE
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6F16B0088; Fri, 19 Dec 2025 06:56:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4C36B0089; Fri, 19 Dec 2025 06:56:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D746B008A; Fri, 19 Dec 2025 06:56:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B48516B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:56:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B3A66027C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:56:39 +0000 (UTC)
X-FDA: 84236068518.25.C75E426
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 33D062000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:56:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yFvdXUCy;
	spf=pass (imf13.hostedemail.com: domain of 3cz1FaQkKCFQw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3cz1FaQkKCFQw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766145397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mkaqMA6/YRs+atfd8F6eMMGUKP5TMTio+X5wBeN5H4g=;
	b=wwzbEo0HSiZq+XzHXBRcLo7KMbzOx/kieaQ2SoRRbiTH7CKIt0fjWqrzprdcCV68agvEOA
	kx67dymIZCS5UDTWPiKKBM8Ws1cYChU3wmMfFBDOK7GkR5CKD4XB6+qXMKzpsGLH6cLC4f
	WNgyCoc2YuZRE/32RnvLiY5X83f89SU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yFvdXUCy;
	spf=pass (imf13.hostedemail.com: domain of 3cz1FaQkKCFQw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3cz1FaQkKCFQw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766145397; a=rsa-sha256;
	cv=none;
	b=Svych9LPhFZj+TpMrXe/22zbwiN4V4iJUGGbHXYIrhz0/I+TQPPsLrGZXGiu0FdeN3RiIE
	fgaJmwBRMnn7kUJ6ttGaoV9V3IKJXk/jMchYudsdcbATWVM6BT9gDUgSz0+epbRSNhMbbk
	vYE3jf03A5HZItAkaP/AtSCqd3eJkps=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4775d110fabso13287085e9.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766145395; x=1766750195; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mkaqMA6/YRs+atfd8F6eMMGUKP5TMTio+X5wBeN5H4g=;
        b=yFvdXUCyl8PQ/n+W/fPX/FinBhyGW3odnN/ynWAshBM+Mw3drYQED7SEkYP8VmtHeb
         Pop9hQMN9qOgaCAcoQsQKhkqZLv7X//EqIVfgXIvK3FenSpMLpzQrMgucuy0g5ihQrog
         uSoyt1XsUq4bW1tVJ0TV1jjLmcU9dLv6CkMGdSwKW88WO3tkyV5McWm+w3uM2CkjJ/yW
         TRgjJnked6hyP3TX0iap3iufSldvpjA+U4fid+SlkmVQhag5q/pAuQqe/A0SnmDjX2P0
         +xMNLCOdkJN3C5qotKMT/gZrI04Kh9jsTB/2PVCsytuACWfSJuRaUrUv6ZpiCHzs3O5Y
         UXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766145395; x=1766750195;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mkaqMA6/YRs+atfd8F6eMMGUKP5TMTio+X5wBeN5H4g=;
        b=a1XMwdrPsvDPpk72SOZ02czfuuNFaGbAeZ8gqZNWLUHo2fDq5houV58qgv26p9pf9/
         +hCmTXZdyR3oqCYmJPA6LiZA+a8p+Z5B0LjABC/eKN7VpPoJFfgAvxWZQE4iy9PTfhJ4
         40SH1j5f6uG6w6FYs68poTHIMH8YkTh33oPv99Up/ln08hPFgrCIGow+qiXApWcsG+nU
         NKlmaaDu9WsMo3XEAB5L8hsUqVFd2YSGustR3XDX5m/zfrqXN0T4d+VvfO6C79AOzd4U
         stikcVJgyzJZ+wyYJE1zDOEhuS8fOOBscF2Vkkzs2XucJVpVenryGuJF2dzuRCWewOnn
         FNCw==
X-Forwarded-Encrypted: i=1; AJvYcCVhVEQfNNC0MmM2cZDN6WLK8u2APC4i6OJPUiF98+cn/qoAIT2SnLqirhCRmSlBO+VOdIME5IA5Qw==@kvack.org
X-Gm-Message-State: AOJu0YwOY9l8DC99fpmUnNfuq8bmhryM8vIGQGxCk2bhhocPBde5tyU+
	SFaWaclXsdTA7FE4mo2ecI5ajeZn1bC+NHFsWpSiZ0udXCOimT9EF11+qg86y18D3yaOKL8iM6p
	mMO6FUpji/mDOXY/4Zg==
X-Google-Smtp-Source: AGHT+IETGgnrJ5JSkspuyQkXAkdOEEV7IhSt2kY/j3stwKIypAfgeI2VbpbJpaknM2AoreVAyy/bf4GSgKtwpYw=
X-Received: from wmdd4.prod.google.com ([2002:a05:600c:a204:b0:47a:9bff:595c])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:620d:b0:479:1b0f:dfff with SMTP id 5b1f17b1804b1-47d19549f5dmr25515775e9.10.1766145395625;
 Fri, 19 Dec 2025 03:56:35 -0800 (PST)
Date: Fri, 19 Dec 2025 11:56:34 +0000
In-Reply-To: <09296628-B3CB-42EE-9FF3-D18FCCE41335@collabora.com>
Mime-Version: 1.0
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
 <63063977-BA16-4F00-AFBA-8DD6409902E1@collabora.com> <aUU6SwJjch1R56t3@google.com>
 <09296628-B3CB-42EE-9FF3-D18FCCE41335@collabora.com>
Message-ID: <aUU9cnJ7R2TfDerm@google.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 33D062000B
X-Stat-Signature: bzgzt5gknq61mb1y4p7sdmq1arcw6ezm
X-HE-Tag: 1766145396-47229
X-HE-Meta: U2FsdGVkX18drG2cooidRvchya51yPx3VTgArVBnTX3x08nzyR3ODhvIHuSk1Fe8Y4J3r/fMN76fbF0mhrQrr/TY8mdtJ+HQzWlX6WtUwMmHBUUJCbXpwi5KSzLJT8JJniCiHIlMKyc26doMgpe729kpJDog/vnGxErLila4wFO3Cysy+Sgxbzs44F0bAjBImUiVJI4gIuLVs+6ZkF0xBLRO4EZjK2UP6/OvchpfWjJIG9YIPGKL5tiBQaf2ypf/3uN144N8HQWGg6Qj993Jk8xbuBNFOL8cIOQpbb3ULOvPJfb5gNgPfFX3dhYktt9HzxiI8Y+E4bNyucZPdWadKYdaYRTL2eaBtmQrUxcYIpSwE+hOO+CETwvOL4BfNvRlIkSXQ/h8/mOL59SI+ej5B9GA4q5zMiDLxyk75/5HZjgS5eutNV9vZXHf1PizzEmqtJGnG0/qE4d9bFe8x6M0MahIGMtS0P0mlHenn/oIUF2jn/5s/JiAQGaKp7UYsh2gRf0T8SQpfrF7dAQpUhXsvNZOxwM482f3hiOwb9ufxk/t/GZWmBZ35niVhlpH4/Ly4rPUna5TNSkSKuEEiD2kHFvMugExzBVxQ+G4waRK4JYqYx82PS9S9nJIEJS1Idw7F/l4JeGl3TglKJZQ7W+G/f8Mi3I5nS6lQDQr3+hO3y2nFoabS5o11vAjnioVBp1fq0LXhYzx7xZSFZd/t9hC6AQSVrSTnK+7MlXaWnB8c14/kC8OkuIsMlE7s+SHm0/R4Lk8z5XvjSqs1MX9MTIuPW6grQI38OK3Cmxpll368gePIiQOaFusRgKopYL8diSl8mE4liVkSVHbR3wBM4QAq5HmH9dlHNai1vv8vzz5wpMoLE71mqlVafVZo3iLwlFDVaIzK0d1+9EOK6dxlCmWts4pvafzlgTYaxGIrUWr1skF14/9jout6hwkyvfPswtoiR2vIcv+gOucdrSl0qN
 xjP8HmxI
 rjeESFwf3ImZ4y0HTkJuT+qHaVD0UFQZuS8BmLi7v6aEWqAMMkITf9dpW4Qted5ZmH2r0ue4gTYX4Yryiw2aX5rdAAx+wbjCHYwGuBxr2mawtGNl7rkeZT8U1qEGSQqwA2PjUsMaIo4sGIcyCUIRtbBLQXDVMTT1eIGXjlRxpgAkRJqkClWrad4JeIZErzbsyUp2QdIyubNZt4CZpUmovyqwI0gcuKlniFSswLhx9Grhx7qW7Qb6kmQ6DETKwtg8FBpMr1GxzFbyrhPlCeQSkEerHmGWpGtvMG8UIVxW5vX9ALZV5Djgg2wH1FsLMNBiyUFwC2wMKoRGtwyw3sqBRk/ut9KQh3owAmlsUVHtBO23Y37HPV2vp2fMWbsRmerpC3mv6cfbT2RBNqq77N0VMZ+DXdl03PZTFi1v6xbc77zutNLHQwh/pFEZDOOYmC+Q1ihreaFAFq1vp6jwdZmYVsjqNojWI3RdgILXwya/gIiB5xDNas8QAeWjc4wOnfj4yvPnC+71rU2pmf1T2Ms/X5BHU/ymD45AM3fgjKOmwZyoZHO7eyH9xYeKjb/3A+hUL3YRc6kKs3ddC5DBRystjDYguc8nAWXOR9QMpWxtN8TIU6LiEfO2M/QiZnXl6Tp5UvueyHmnkq9ahyn7Xm0tp8dwkDWS6WZh91le0xj+QUuiJgvypFoCl4H1FsVSZGu2DJYhieTJwiOl069OEbvzsp74fH4WPdW7Cm7mFicPNYguFgfPwnRobwmPivjvP7+i0p9fs5NfwVLmP69CyMwwo4jVv8pu8kQVbjtDl/uaQ8PCPHwWuNFcLBHr2k1aigk/Y82z0XzHkj2FHU4u082SNVl78CNbvsEarkJB5ebBFz3kocMeEooVZo/qL4ui2IUeaz9Y5Weso5/ra0JS2YkQl3lkY4nxTAX8fPy9DxRTk+Mf+j4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 08:50:06AM -0300, Daniel Almeida wrote:
>=20
>=20
> > On 19 Dec 2025, at 08:43, Alice Ryhl <aliceryhl@google.com> wrote:
> >=20
> > On Fri, Dec 19, 2025 at 08:04:17AM -0300, Daniel Almeida wrote:
> >> Hi Alice,
> >>=20
> >>> On 19 Dec 2025, at 07:50, Alice Ryhl <aliceryhl@google.com> wrote:
> >>>=20
> >>> From: Asahi Lina <lina+kernel@asahilina.net>
> >>>=20
> >>> This will be used by the Tyr driver to create and modify the page tab=
le
> >>> of each address space on the GPU. Each time a mapping gets created or
> >>> removed by userspace, Tyr will call into GPUVM, which will figure out
> >>> which calls to map_pages and unmap_pages are required to map the data=
 in
> >>> question in the page table so that the GPU may access those pages whe=
n
> >>> using that address space.
> >>>=20
> >>> The Rust type wraps the struct using a raw pointer rather than the us=
ual
> >>> Opaque+ARef approach because Opaque+ARef requires the target type to =
be
> >>> refcounted.
> >>>=20
> >>> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> >>> Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
> >>> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> >>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> >=20
> >>> +/// An io page table using a specific format.
> >>> +///
> >>> +/// # Invariants
> >>> +///
> >>> +/// The pointer references a valid io page table.
> >>> +pub struct IoPageTable<F: IoPageTableFmt> {
> >>> +    ptr: NonNull<bindings::io_pgtable_ops>,
> >>> +    _marker: PhantomData<F>,
> >>> +}
> >>> +
> >>> +// SAFETY: `struct io_pgtable_ops` is not restricted to a single thr=
ead.
> >>> +unsafe impl<F: IoPageTableFmt> Send for IoPageTable<F> {}
> >>> +// SAFETY: `struct io_pgtable_ops` may be accessed concurrently.
> >>> +unsafe impl<F: IoPageTableFmt> Sync for IoPageTable<F> {}
> >>> +
> >>> +/// The format used by this page table.
> >>> +pub trait IoPageTableFmt: 'static {
> >>> +    /// The value representing this format.
> >>> +    const FORMAT: io_pgtable_fmt;
> >>> +}
> >>> +
> >>> +impl<F: IoPageTableFmt> IoPageTable<F> {
> >>=20
> >> I don=E2=80=99t see a reason to keep struct Foo and impl Foo separate.
> >>=20
> >> IMHO, these should always be together, as the first thing one wants
> >> to read after a type declaration is its implementation.
> >=20
> > I thought it was pretty natural like this. First we describe the page
> > table, then we say it's thread safe, then we describe that a page table
> > must specify a FORMAT, then we describe that it has a constructor,
> > then we say you can map pages, etc. etc.
>=20
> Right, this is more a personal preference thing anyways. Fine with me if =
you
> want to keep it like this.
>=20
> >=20
> >>> +    /// Create a new `IoPageTable` as a device resource.
> >>> +    #[inline]
> >>> +    pub fn new(
> >>> +        dev: &Device<Bound>,
> >>> +        config: Config,
> >>> +    ) -> impl PinInit<Devres<IoPageTable<F>>, Error> + '_ {
> >>> +        // SAFETY: Devres ensures that the value is dropped during d=
evice unbind.
> >>> +        Devres::new(dev, unsafe { Self::new_raw(dev, config) })
> >>> +    }
> >>> +
> >>> +    /// Create a new `IoPageTable`.
> >>> +    ///
> >>> +    /// # Safety
> >>> +    ///
> >>> +    /// If successful, then the returned value must be dropped befor=
e the device is unbound.
> >>> +    #[inline]
> >>> +    pub unsafe fn new_raw(dev: &Device<Bound>, config: Config) -> Re=
sult<IoPageTable<F>> {
> >>> +        let mut raw_cfg =3D bindings::io_pgtable_cfg {
> >>> +            quirks: config.quirks,
> >>> +            pgsize_bitmap: config.pgsize_bitmap,
> >>> +            ias: config.ias,
> >>> +            oas: config.oas,
> >>> +            coherent_walk: config.coherent_walk,
> >>> +            tlb: &raw const NOOP_FLUSH_OPS,
> >>> +            iommu_dev: dev.as_raw(),
> >>> +            // SAFETY: All zeroes is a valid value for `struct io_pg=
table_cfg`.
> >>> +            ..unsafe { core::mem::zeroed() }
> >>> +        };
> >>> +
> >>> +        // SAFETY:
> >>> +        // * The raw_cfg pointer is valid for the duration of this c=
all.
> >>> +        // * The provided `FLUSH_OPS` contains valid function pointe=
rs that accept a null pointer
> >>> +        //   as cookie.
> >>> +        // * The caller ensures that the io pgtable does not outlive=
 the device.
> >>=20
> >> We should probably tailor the sentence above for Devres?
> >=20
> > Maybe "does not outlive device unbind" is better worded, but not sure
> > what you're looking for with Devres tailoring.
>=20
> What about =E2=80=9CDevres ensures that the io potable does not outlive d=
evice
> unbind by revoking access=E2=80=9D, or something along these lines?

The `new_raw` method does not require the caller to use `Devres` to do
that, so it's not necessarily the case that it is Devres that ensures
this. An end-user could call `new_raw` directly and use some other
mechanism if they wish.

> >>> +        let ops =3D unsafe {
> >>> +            bindings::alloc_io_pgtable_ops(F::FORMAT, &mut raw_cfg, =
core::ptr::null_mut())
> >>> +        };
> >>=20
> >> I=E2=80=99d add a blank here.
> >>=20
> >>> +impl<F: IoPageTableFmt> Drop for IoPageTable<F> {
> >>> +    fn drop(&mut self) {
> >>> +        // SAFETY: The caller of `ttbr` promised that the page table=
 is not live when this
> >>> +        // destructor runs.
> >>=20
> >>=20
> >> Not sure I understand this sentence. Perhaps we should remove the word=
 =E2=80=9Cttbr=E2=80=9D from here? ttbr is a register.
> >=20
> > ttbr is a method defined below with a safety requirement.
>=20
> Can't we link to that then? i.e.: [`ttbr`]: Self::ttbr, or whatever the r=
ight
> syntax is. Because it=E2=80=99s more natural to think about ttbr the regi=
ster vs
> ttbr the method.

This isn't a doc comment. There's no such thing as a link in normal
comments. But I can write:

	The caller of `Self::ttbr()` promised that the ...

Alice

