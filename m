Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0325D767EE
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC4A6B0088; Fri, 19 Dec 2025 06:50:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A176B0089; Fri, 19 Dec 2025 06:50:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4BF56B008A; Fri, 19 Dec 2025 06:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2F896B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:50:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D428160239
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:50:35 +0000 (UTC)
X-FDA: 84236053230.30.5466F29
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf09.hostedemail.com (Postfix) with ESMTP id 739A314000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:50:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=e1sCZCFQ;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf09.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766145033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bagxgs37dECR0fIYnnfs0GVR8oB2eKVNw7yBfChIglY=;
	b=jDnZIooLyhb21PYMFzkyGzPuCY3IzeqU/ZEI009pcuB4Oyvx4jxgEfsHQ3GWTxBuWLUus3
	bJ5WjDbMabeLbnrFgumZhddqr9+jM9GMGulOXICrO6zMPvYM3lfnBNTJIUMfRW1rMMgHYo
	aF5ADNqVBuvxoLESxVy+pm1GTRHUT9I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766145033; a=rsa-sha256;
	cv=pass;
	b=SmN7zvr2s5DIWvFw7FqmApwzvnFJ5pJ2YWdahXIL41qbk0ucI51FIe4YqNp9+Y8QfDHX4T
	qPNWpM7Rhfn8V+lfWAOoaEOqn2ePEmrnu6xA/D2x78SHh0y23N78DnZKYEzq2zU2b4gJXz
	NRVlcMm0fNAaEYDeoOu8uid4DNrNHxE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=e1sCZCFQ;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf09.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1766145027; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Cu8gnDuELQSMuusDRGN76qpIXkD1QOTcEld66w4TBYZ9tZyrBOzFzg0LzBHEKdbYCrqRAVaO9m9mU+4eQ931NpgUthPboz6zA7wgC25DMe9JeHeeYGjV9c0y8gbJhEoFiS3LOp0tLWvVufrU/P1dU0+tSGza2CQsGy5vjL/2WDY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766145027; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=bagxgs37dECR0fIYnnfs0GVR8oB2eKVNw7yBfChIglY=; 
	b=eOvUFWCx2879V4ntQqAAwGAIHAMypV7ve07wNyVVWOnJO9jGgkQfzMgK9C8lOgFCijFJIGltlU19SaGd06cqpbsXRFUuDOsQSdSpmIvXl3uaIp6WGV+uhP3vkbknMvnelr7+ZcN11N+CvQu4GH0ufM0FZzjaCm8xghqvfvnlM8E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766145027;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=bagxgs37dECR0fIYnnfs0GVR8oB2eKVNw7yBfChIglY=;
	b=e1sCZCFQ4C9kUdlY/EvScjUU6DZIpBnLFijl6A8sSI//Vtaq0bNtPViF6mbTwOAH
	KVEscMiutUBdxgS32sqw9qI8gVqvEPbg7cIw71gHk+trS/k0h+GHj8YOsyJdldrEt8S
	7H358bsz6ULdO/YFV8TFzavtaH+d9zd0+mXSBU8s=
Received: by mx.zohomail.com with SMTPS id 1766145024661652.388080029692;
	Fri, 19 Dec 2025 03:50:24 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v4] io: add io_pgtable abstraction
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <aUU6SwJjch1R56t3@google.com>
Date: Fri, 19 Dec 2025 08:50:06 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Will Deacon <will@kernel.org>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Joerg Roedel <joro@8bytes.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Asahi Lina <lina+kernel@asahilina.net>,
 linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org,
 iommu@lists.linux.dev,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <09296628-B3CB-42EE-9FF3-D18FCCE41335@collabora.com>
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
 <63063977-BA16-4F00-AFBA-8DD6409902E1@collabora.com>
 <aUU6SwJjch1R56t3@google.com>
To: Alice Ryhl <aliceryhl@google.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Stat-Signature: tmejue1frjuh9sq3zg93fyi9zyxjdmth
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 739A314000A
X-Rspam-User: 
X-HE-Tag: 1766145033-515933
X-HE-Meta: U2FsdGVkX1/YA8ZS7bUqdAg2oOwfeFoYOcwcMN54rZdgMd/ew70Zl+sG9dCtYJRHbtBWDaDMfBnXFLaHDmcPOSDTTaXsqL22bkgUdHiFWR7Gudy64PBt3ZTGbyPDywZbs5sNpAXGsjTBUl3hStDbNYNWe65q8T4jNaNE71rJvk7ZDpo5TiW3LtxUx6yNmCk55x9wJHB619nH0We4ob9jonXsw3VXwvxsSkLZTqPASQfIdQv8VM+2OQo+2XvBkq6va238/X3rB88DCbB5lFauT7rIbo6PLPyLm1Y9TKiDoo0kgt8sIVknQdUa5Vtbzat73CrHKPoz8A4NUzKu6krbeeka+ec/JX+YgkWqFe67yuAiaW0x348AkCayUyJWgtdyIn9NisBvLoU3DIhxSSY02Ghw+N6CcBnNMsTImmEdJ9rUD0eBGiiloVZyuaxuZAxN6ePOd2ZHWnIr/9fW0hWbdisRYpmfPhXu1NKhxaV17jg8OFXP6fbF01g3qpOjeIP2imq0VXJM9o5vVo8lgSe0CgnVAO1sc4S7aTFrl1NEHMdnEP4JkQ0UDnj+RqxCLiVn2R3m8o5jn3ug7DZ3P8TEykAWMz6vSUtIp3Hrd3h2w+QPIt5hpGm00HJBwBIA2T0eQXB3zqoiyF6MRm/32NR6ZFP3ofUVz8HIN9wTxJbHTJo5C/xLhfH8fQ2S6jjm1kjvEu91C+18z9Ocq8/IpZbRCEFrTGUsVcrp0dLs+gXQqBPfAq8VJeicU8xF6tV9GnCYk9SNf1qh6YxDOD1m3iOfoh+N127QGvuaVF+F33uTz3v3XuyiEkrc5uynogvmpYGvj/brQnAAxZftbkb357ctPSJpeJn424LwhGf0qknDN23BRS54JcFWslodPkDBXWarR5zRi7kHfzJcfDRZpzjICDWXJ8nKsU5jToT5sU9r+V7GAqk3n/PStj0t5hxszbTtZQhprc4cJBOmDTcvM4f
 CR9z2P7k
 I2z31KdE4G63/oDOtueMJ/zmvlxE+5U8vF5aD4B/3q5mgbJ7W2glk3gfZKGnSeZbZOpVBk2efILOMHZvFFGD3Ixk2p77saAE/TdTVKTY3buFi+0p8NsJERYQbWIp2znPbA2HRnST5q1T3EvTMK4qoajGuBFlsywYBZKUWCIvLzAptJ7pL2SC/W65LTIs73+yIS1mgsZMUj0DscE0vQQIX6V+Od7d/aiH0i9TIpPnJJb58BxlhLRkI7PJh+MIpiQsUDHRODhYzMRwBOdZKEyO1HtTXGJi9U241gkMAOAaXZMl0SZJpOE6ulErj3DJ79sLUCP7D+Igc5lDXDI6+iWtm82dc4E/nGem7caDBSll2kMtXV2S3lddFZh14FZWSwYiVlY6fUu1zbPlPnigaXrYRncpxM2P6jSVYeWGPKzHEXoWnGFqE6zSiOhqF8FQdJ6B/zYuZm2F0rZgxw5Y3nly3lKACfXzYDuuOKCKGQ6cRSAp28PI5yN+DmDoTUmDVsImRhxkX+qV7qgFj5Hu5V797SAGhQ7HW4ujAR/a1BOK3fq94C90n86JpIfvXj4NTnlmBSA3gp++N3N61T/9xiF+vS1apb1oeJeJGixGnaozaJLcRR+8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 19 Dec 2025, at 08:43, Alice Ryhl <aliceryhl@google.com> wrote:
>=20
> On Fri, Dec 19, 2025 at 08:04:17AM -0300, Daniel Almeida wrote:
>> Hi Alice,
>>=20
>>> On 19 Dec 2025, at 07:50, Alice Ryhl <aliceryhl@google.com> wrote:
>>>=20
>>> From: Asahi Lina <lina+kernel@asahilina.net>
>>>=20
>>> This will be used by the Tyr driver to create and modify the page =
table
>>> of each address space on the GPU. Each time a mapping gets created =
or
>>> removed by userspace, Tyr will call into GPUVM, which will figure =
out
>>> which calls to map_pages and unmap_pages are required to map the =
data in
>>> question in the page table so that the GPU may access those pages =
when
>>> using that address space.
>>>=20
>>> The Rust type wraps the struct using a raw pointer rather than the =
usual
>>> Opaque+ARef approach because Opaque+ARef requires the target type to =
be
>>> refcounted.
>>>=20
>>> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
>>> Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
>>> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
>>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>=20
>>> +/// An io page table using a specific format.
>>> +///
>>> +/// # Invariants
>>> +///
>>> +/// The pointer references a valid io page table.
>>> +pub struct IoPageTable<F: IoPageTableFmt> {
>>> +    ptr: NonNull<bindings::io_pgtable_ops>,
>>> +    _marker: PhantomData<F>,
>>> +}
>>> +
>>> +// SAFETY: `struct io_pgtable_ops` is not restricted to a single =
thread.
>>> +unsafe impl<F: IoPageTableFmt> Send for IoPageTable<F> {}
>>> +// SAFETY: `struct io_pgtable_ops` may be accessed concurrently.
>>> +unsafe impl<F: IoPageTableFmt> Sync for IoPageTable<F> {}
>>> +
>>> +/// The format used by this page table.
>>> +pub trait IoPageTableFmt: 'static {
>>> +    /// The value representing this format.
>>> +    const FORMAT: io_pgtable_fmt;
>>> +}
>>> +
>>> +impl<F: IoPageTableFmt> IoPageTable<F> {
>>=20
>> I don=E2=80=99t see a reason to keep struct Foo and impl Foo =
separate.
>>=20
>> IMHO, these should always be together, as the first thing one wants
>> to read after a type declaration is its implementation.
>=20
> I thought it was pretty natural like this. First we describe the page
> table, then we say it's thread safe, then we describe that a page =
table
> must specify a FORMAT, then we describe that it has a constructor,
> then we say you can map pages, etc. etc.

Right, this is more a personal preference thing anyways. Fine with me if =
you
want to keep it like this.

>=20
>>> +    /// Create a new `IoPageTable` as a device resource.
>>> +    #[inline]
>>> +    pub fn new(
>>> +        dev: &Device<Bound>,
>>> +        config: Config,
>>> +    ) -> impl PinInit<Devres<IoPageTable<F>>, Error> + '_ {
>>> +        // SAFETY: Devres ensures that the value is dropped during =
device unbind.
>>> +        Devres::new(dev, unsafe { Self::new_raw(dev, config) })
>>> +    }
>>> +
>>> +    /// Create a new `IoPageTable`.
>>> +    ///
>>> +    /// # Safety
>>> +    ///
>>> +    /// If successful, then the returned value must be dropped =
before the device is unbound.
>>> +    #[inline]
>>> +    pub unsafe fn new_raw(dev: &Device<Bound>, config: Config) -> =
Result<IoPageTable<F>> {
>>> +        let mut raw_cfg =3D bindings::io_pgtable_cfg {
>>> +            quirks: config.quirks,
>>> +            pgsize_bitmap: config.pgsize_bitmap,
>>> +            ias: config.ias,
>>> +            oas: config.oas,
>>> +            coherent_walk: config.coherent_walk,
>>> +            tlb: &raw const NOOP_FLUSH_OPS,
>>> +            iommu_dev: dev.as_raw(),
>>> +            // SAFETY: All zeroes is a valid value for `struct =
io_pgtable_cfg`.
>>> +            ..unsafe { core::mem::zeroed() }
>>> +        };
>>> +
>>> +        // SAFETY:
>>> +        // * The raw_cfg pointer is valid for the duration of this =
call.
>>> +        // * The provided `FLUSH_OPS` contains valid function =
pointers that accept a null pointer
>>> +        //   as cookie.
>>> +        // * The caller ensures that the io pgtable does not =
outlive the device.
>>=20
>> We should probably tailor the sentence above for Devres?
>=20
> Maybe "does not outlive device unbind" is better worded, but not sure
> what you're looking for with Devres tailoring.

What about =E2=80=9CDevres ensures that the io potable does not outlive =
device
unbind by revoking access=E2=80=9D, or something along these lines?

>=20
>>> +        let ops =3D unsafe {
>>> +            bindings::alloc_io_pgtable_ops(F::FORMAT, &mut raw_cfg, =
core::ptr::null_mut())
>>> +        };
>>=20
>> I=E2=80=99d add a blank here.
>>=20
>>> +impl<F: IoPageTableFmt> Drop for IoPageTable<F> {
>>> +    fn drop(&mut self) {
>>> +        // SAFETY: The caller of `ttbr` promised that the page =
table is not live when this
>>> +        // destructor runs.
>>=20
>>=20
>> Not sure I understand this sentence. Perhaps we should remove the =
word =E2=80=9Cttbr=E2=80=9D from here? ttbr is a register.
>=20
> ttbr is a method defined below with a safety requirement.

Can't we link to that then? i.e.: [`ttbr`]: Self::ttbr, or whatever the =
right
syntax is. Because it=E2=80=99s more natural to think about ttbr the =
register vs
ttbr the method.

>=20
> Alice



