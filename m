Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 897B8CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 14:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1E78E0003; Wed, 27 Aug 2025 10:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2988E0001; Wed, 27 Aug 2025 10:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69EC8E0003; Wed, 27 Aug 2025 10:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 900D38E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:24:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59C5E140239
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:24:14 +0000 (UTC)
X-FDA: 83822757228.06.4BF0F16
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf22.hostedemail.com (Postfix) with ESMTP id E4F73C0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:24:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=Bjjks59P;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="PCt/7WLb"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756304652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HosDHf8ILmXNfs+W1FVKb7QZ7kgKb/fbwrTqstAIoQU=;
	b=L44IOJ3V2+gc0V95KJ7cZYywd7SkJZSCoUTXLPmcPoU+8SRcTnwi3ElZx/jxUxGnTX0TEt
	od878CEFZ+esSPr2GwSauxeb4LcjoH4O6lTWL5rVfAbzi+KzEdXak1Ddo/ucyxc6qAH2gr
	jwaeQN6Z1+HlqJHCJSH4B+vw5pNiVj8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=Bjjks59P;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="PCt/7WLb";
	dmarc=none;
	spf=none (imf22.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756304652; a=rsa-sha256;
	cv=none;
	b=DmuGABdfUE8zOk9TwlIHG8A7EHNbpLu/Y3POFeneCju4mxnQkOzr2VdEodZWwsX7/Gwg9r
	t58spF+oIftP+W0imgCw/60fkd19IFZTPl9rS0khos35DjY++CbVIK0m8keksRAIMeJOJh
	GZMEdOHj91X8yXbl+4/QYdBtaqUDHNw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756304650; x=1756909450;
	d=konsulko.se; s=rsa2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=HosDHf8ILmXNfs+W1FVKb7QZ7kgKb/fbwrTqstAIoQU=;
	b=Bjjks59P4Lnkx/2SgdlsQI76U/z52m6ysXbLdjo/76EkNzvoQ3vxKERqeENiVSFPeol/bCCmMePN/
	 m3hv3tCMoihZd95Hjo8pNY6es1WjPkiVVkSy5eGePj1kaHL8ngZCAfMCmQnNzW5/ygvVo1uq6dk6yT
	 qKglOGWd/YH0h+jNw6zeCZbNqi8QbykQUAqLNC5XGHLTPZ+g462rJsRAhW3kraq1PQ3PSTMjRR+n76
	 usqzcsOBFcj83zfRE/cBY9kHZn3TmYk+4+CjBCM8SIYAT4T1HlSCEgizwb6W8JKXg2WjhX2n9ktRfp
	 3vVJaNi47+jaNcqPSE6b6lzUaMLswxQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756304650; x=1756909450;
	d=konsulko.se; s=ed2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=HosDHf8ILmXNfs+W1FVKb7QZ7kgKb/fbwrTqstAIoQU=;
	b=PCt/7WLbEKLNF3KfvCOQ0X2J0hnpEs467gn30VHNhtEL8vLiSS0OhSK7mu1D3Ug07cRroR8cfWSgx
	 P6JO96NCw==
X-HalOne-ID: 7e22e996-8351-11f0-aecb-632fe8569f3f
Received: from smtpclient.apple (host-90-233-222-89.mobileonline.telia.com [90.233.222.89])
	by mailrelay2.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 7e22e996-8351-11f0-aecb-632fe8569f3f;
	Wed, 27 Aug 2025 14:24:09 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v4 2/2] rust: zpool: add abstraction for zpool drivers
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <DCCIRTHGQFNX.1M8GXO4TYA7DF@kernel.org>
Date: Wed, 27 Aug 2025 16:24:08 +0200
Cc: rust-for-linux <rust-for-linux@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Danilo Krummrich <dakr@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DFA3B588-3650-42DA-8875-7AB7D20A2BCA@konsulko.se>
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250823130522.867263-1-vitaly.wool@konsulko.se>
 <DCCIRTHGQFNX.1M8GXO4TYA7DF@kernel.org>
To: Benno Lossin <lossin@kernel.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E4F73C0006
X-Stat-Signature: 8nmsubuq79akpg7kfkgcox49xdggb65p
X-Rspam-User: 
X-HE-Tag: 1756304651-575072
X-HE-Meta: U2FsdGVkX1/p7/G3x3455cehOL8+ckZLufq+v+wuuPPH4S08hQJpemkD3B+5UgYcfkGhxOoh9Rf76xQtaZNW9yU7u1MR1Scn5oLP1SKihSo+GHMsNVblFcfzEgtlGlQQgMJRTwHOGrY8i5nfOhuXvYbCy7d5tv59jD/8Pu2uMFqwMbOMIvkOmD9m6Bt8SKZLOBwK/CJSvK+ScVCfIE0UCmxyYk+8hknyivEQJ1o+clbfhW+xxl8X/03WhwFrAmIxhiU93fqpk53gEfP3x2UcGou0/7yjWCSxPYMrIZvovkLt6M29FT8M/qYUtrjQmU4gsc1lIlwNueZ7dT6xk3rJPoi8GJZB25UYEjc4mcjM5m6CPK54NKC+Ar1ElZGQgO2ieLXR9osLBTH3CMByjzE2tbdbh/e04JT3CMCdVIjwMBXeYvYt31o3f30iajj78ui8BryTSoOP7J35qoDEm+gskoMEF//hryHB6/zyBzoALr5zv4Pvs5KOsVwnRRZgwB9Ozhaya0yFJFxzrK+ID6Y4kB4xQ3R+eri9BQV+iIutP28kPf/BY5ArsQoMDHpF+bPYjGlVn40GIFlMdQ6dB55+T/GjYINQkt0//YQJOcrPMq6rpiLsVXM3llBADWtQ7pHYAROQAgxFHkBAllyTMj5gb1gSCUEMDSIstdHWBOAUcK3YgEPUZLlMWt+TH0jEUXNSjRwx3b/LL18f9u0Ij8KLobnOSVC5NLFgt2iLHFESIghsFyiGj9kmzJjYl4ats5UNL9FLR5PSXPV94mVjMqUAkdyRjStgvNIWNUMNBhbjBl13t9/kX//SLfDwrw+0zJmr+3B6mQ6JVO+bM6Qrrm359m9pop8tlmME/sQxfRaI6XgEF8AteweeH+/YYpsWm6SSyUq4jnHsw3J868zhxYurLHL2uzbEd2Xp81DZ/L7E97nWc287wTxox6MSbiEuRvS74Ak1x4YM2maHB5D64uH
 zwqMpRT+
 zdUm4SNsKDeI9yyJ5Io8Ek9d7HRScVb6uP05YydONXhsNLIhP+dj7J3l+uEpVuNJJU1JyAfBv/C5LYHd7xXOb/1v1QczgnFqbFJH5lGgtIw59vC4pgL9pH/1QH07AqAYx4roYFHod0qIYXaZsYC+orPwK7oxjQWwPfY0zPUmQJMSBTyPnmRgwqN4nT1Jwg0Rd8i6g8FeS2LsWJqLuO5x+UTV9/W+jfHffMqkNK+dDY5CqDAFUtkI2hkJyXVt8lGVfb3vNfJT/MmHdRTfvuaBg2Ipg8fNuPIWLMg0sRb01/kLyiObjLcknF2VDiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 26, 2025, at 7:02 PM, Benno Lossin <lossin@kernel.org> wrote:
>=20
> On Sat Aug 23, 2025 at 3:05 PM CEST, Vitaly Wool wrote:
>> +pub trait ZpoolDriver {
>> +    /// Opaque Rust representation of `struct zpool`.
>> +    type Pool: ForeignOwnable;
>=20
> I think this is the same question that Danilo asked a few versions =
ago,
> but why do we need this? Why can't we just use `Self` instead?

It=E2=80=99s convenient to use it in the backend implementation, like in =
the toy example supplied in the documentation part:

+/// struct MyZpool {
+///     name: &'static CStr,
+///     bytes_used: AtomicU64,
+/// }
=E2=80=A6
+/// impl ZpoolDriver for MyZpoolDriver {
+///     type Pool =3D KBox<MyZpool>;

Does that make sense?
=20
>=20
>> +
>> +    /// Create a pool.
>> +    fn create(name: &'static CStr, gfp: Flags) -> =
Result<Self::Pool>;
>> +
>> +    /// Destroy the pool.
>> +    fn destroy(pool: Self::Pool);
>=20
> This should just be done via the normal `Drop` trait?

Let me check if I=E2=80=99m getting you right here. I take what you are =
suggesting is that we require that Pool implements Drop trait and then =
just do something like:

    extern "C" fn destroy_(pool: *mut c_void) {
        // SAFETY: The pointer originates from an `into_foreign` call.
        unsafe { drop(T::Pool::from_foreign(pool)) }
    }

Is that understanding correct?

~Vitaly


>=20
> ---
> Cheers,
> Benno
>=20
>> +
>> +    /// Allocate an object of size `size` bytes from `pool`, with =
the allocation flags `gfp` and
>> +    /// preferred NUMA node `nid`. If the allocation is successful, =
an opaque handle is returned.
>> +    fn malloc(
>> +        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
>> +        size: usize,
>> +        gfp: Flags,
>> +        nid: NumaNode,
>> +    ) -> Result<usize>;
>=20


