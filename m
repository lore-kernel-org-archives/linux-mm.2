Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 858C2CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 15:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57F4440147; Fri, 22 Aug 2025 11:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06F78E009D; Fri, 22 Aug 2025 11:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4E8440147; Fri, 22 Aug 2025 11:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 859E88E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:44:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47F0116023C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:44:01 +0000 (UTC)
X-FDA: 83804814282.01.A384C77
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf07.hostedemail.com (Postfix) with ESMTP id 276054000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:43:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=YMa17ozj;
	spf=pass (imf07.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755877439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqUCUnihyJxvxzkXqOwwRycVnt4eGXHpARTB8PXlkd4=;
	b=ZVtjh4s2g3joqn8tTF1nEEOAZYpJedHNO9gDfIEdmNdac3XC7YV0NKwyonfsN9LMf8D56+
	OjlHFwS+5yVbS+UDQnA/8MTPuz7O96k4YA7rEDO7vVb4oL9V/9pciCaZ/M8syh8yQ0H9ra
	aWWaWEo8K9+LWcCqULQ+ueab+xbUx24=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=YMa17ozj;
	spf=pass (imf07.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755877439; a=rsa-sha256;
	cv=pass;
	b=DK8EBPAouG5x5uDvL9VrpknaXCuS2E9QRJCzT5ghq447O1Gq/i09m9VjvksJ81KcygaTFu
	DPbxpJqqV/x4vtZnPERirHDZYmc3Kyaash9ZzR5/SvBOl2jVhLoO4RLFBn9rSFtq/174w5
	bxHqEX/NzsWve7WtPSZP1ThSrDKnyYA=
ARC-Seal: i=1; a=rsa-sha256; t=1755877419; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ZLj7PhIDrAAGOK1HcqBj9174GgMM/NrCu6pQaUWEjDkYCAZp695q5c8s1daNnGtmuURLWDDhWlDI4av0pMsHSHjbKyM6fOHLKVAU55ZZPvuX5EKAjqn2NJ5GzWq00vJ3lElwJaP2MyNxe8BBBkDmBAKZj62D9uAmDzCTvmZupZo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755877419; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=PqUCUnihyJxvxzkXqOwwRycVnt4eGXHpARTB8PXlkd4=; 
	b=mAMf1ce8SjIPMNcV5WrE8n0Ibe3VOjJ/uZQPwKKQHqlZ7Fx7pe/GY4z3Euvyko5RJwQ4lGM8YVNBg8w/W7fwzioLwFxzjd2ToXYc2tiVxTTlYNzwDsScnvjqCNZidh4iYwFApWn6pr6bSsBhlrrvSGY3BeLliCSIrTSFxUYStSY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755877419;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=PqUCUnihyJxvxzkXqOwwRycVnt4eGXHpARTB8PXlkd4=;
	b=YMa17ozjFiGBqdgmByRQBEdRvbipYETo7tl/7XaV71HtPJuo8CaITtsujNXWGT5M
	H3GTjeeKeRO0LsrtSTXp8UM6dNUbV8JEo4dyzbYqMCfkGhPtQxtn+DZ/88xRGcmueax
	6yOhHWhelQ067nk++opz3l5/UeeYYB6lRxlkSrdI=
Received: by mx.zohomail.com with SMTPS id 175587741672544.27711383068004;
	Fri, 22 Aug 2025 08:43:36 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v2 3/5] rust: maple_tree: add MapleTree::lock() and load()
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <mrc7a7s7g4ylxvxfezwx3rf7ry7sng4adn64i443aikpjfz5ik@jq4co7zq7ryq>
Date: Fri, 22 Aug 2025 12:43:20 -0300
Cc: Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Andrew Ballance <andrewjballance@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org,
 rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FD22178C-8BCE-478B-8A2A-12FEFFA8DFC3@collabora.com>
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-3-229b48657bab@google.com>
 <38B2DEA2-774D-45B5-8923-C5330B975FB9@collabora.com>
 <mrc7a7s7g4ylxvxfezwx3rf7ry7sng4adn64i443aikpjfz5ik@jq4co7zq7ryq>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Stat-Signature: 3wodhf6nh11b36jkjsieywqhzwxnk5aq
X-Rspam-User: 
X-Rspamd-Queue-Id: 276054000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755877438-764323
X-HE-Meta: U2FsdGVkX1+g6Z/Op6t2vhT1BNAFlehGPNWYuNJsW33vEGjJQKfgZOFMABrPw95j+F+qxG7HwVJFK0nuu6ZYiwhJUPRDke2INK1oY68BvrkFU9Vy4jIsfjgBZf2TjhXUBnW/yeduHRkzy2XtYaYsxc5J1oDDFJTDezC2NCbZWvPU+kDCpLogU/ayzHZFqQfW1gfhGp/fkUPrnxs1RyKHEdToF/9tMF7hqNBNGnfqKI1Hk8x/QbtmTOF3sG7e50AERlqYcttICaBYSTW8pxLAkDmVG8BxhKEuOrui8fVXCeYeLv2abdxJzoYrfncSOQD2xzlneTJJYcujrWVelQN5SoGsTYjqXUKX3vK+7tQzj6jtRHrb2FMJyeg8WwkycMbXsn28WGarE879gJ1sRufbd204u713JWh/OcduWefn2X3O0iKoFKPD7VOYPbtY+1v/QPD2Q8JAERv5bkny1KNcmHQMK60CAt6ipF+guj4aHTRKZUDuUXGYbj5dd8kU6Sc7YkSZLdKBePnvRkm43rbBlStm7RgUm4Ew0SBDIVjfpScgbzB3RFAiYqVbH5ArMdSFLRqhMZNU9kWghmp9SUUrOgBddQQixu2szrIkHbooCHeWG9xY3aQ0utdApgBTIjcb1vvkBJdRlSZ6Zw1Sf6YPrCiLFcohKXRNZVm0cEzjtsufpmVukG03zpwMnBtZR8l5nKdLVVV3rgJfy6lWCMw69IWR170UjZ7po7EQnUZHYQ5vpQ5XM5mQtjKgtOlI2mecg6PFVpeMawNRbnmd+3IYcyXWO2yKjDvXMzFf9n040Fg413skWP3MQc9fImnDZSbne9e9PilTE9xVSYiuSnzPoRQTw6E/DfnMEkw3qOHIBE8pXTT4Iqi+3kjR+7O68SASA4AEM1WmlERQUP2UsOQVTivlnuIngZEmJOxbb/+oK2MLi+YHkV6EVGKDZPNpR1OokYvpFHlnalUUZOcNnmq
 3lZRkFTM
 rk9UDt+mTWv/T/Ud4km4LZpt8PM+uSWxRqMOZw3n37jheXJgCVmFT6GfxkQUqrW4txVRu4xt6mlZn2BF8rAJhkI8uhxS7yBAgM7p7v+Ld/tarOsnitwtqxRlb0LY2IAgt0NNfVPDT6wAI2NEanTzgwrwdzQdo3RahbYNoKZ4xuvsFaxm/OLLPORKWUsM8Zo/1un9LlrWez/67RvK/cIkzlhF2aszs7ygP0c3Ktvn7Zyf91Zijtp7GPJHo6JLfd4Z/+uUnW1ZkO8D48wZjhGuL5gzAwZy1P8+W+k60mJDDdVIuuel6mmstJzB74nIYVFmxuvMX4iMeymVry5qE/XpIIFdZU3Ktnlye6ws0GJO7E6jnsoQsOLJWYPjL/YroPJmYvLdDvbBHIWCF6pvnDApfFzrf08skZ6lUi0AaexoRxHjQBcULOCnDYfVFgX3RtKP4bMfEQjAgVvUePwFhHpDYyF/zYt0bvJd+PEdqnz7L/z5gULAYOTX/v/fc/L+8yOwpjxFBpjIGcq8yFygP7YBw4WOQBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam,

[=E2=80=A6]

>>=20
>>> +    ///
>>> +    /// # Examples
>>> +    ///
>>> +    /// Iterate the maple tree.
>>> +    ///
>>> +    /// ```
>>> +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
>>> +    /// use kernel::sync::Arc;
>>> +    ///
>>> +    /// let tree =3D KBox::pin_init(MapleTree::<Arc<i32>>::new(), =
GFP_KERNEL)?;
>>> +    ///
>>> +    /// let ten =3D Arc::new(10, GFP_KERNEL)?;
>>> +    /// let twenty =3D Arc::new(20, GFP_KERNEL)?;
>>> +    /// tree.insert(100, ten, GFP_KERNEL)?;
>>> +    /// tree.insert(200, twenty, GFP_KERNEL)?;
>>> +    ///
>>> +    /// let mut ma_lock =3D tree.lock();
>>> +    /// let mut iter =3D ma_lock.ma_state(0, usize::MAX);
>>> +    ///
>>> +    /// assert_eq!(*iter.mas_find(usize::MAX).unwrap(), 10);
>>> +    /// assert_eq!(*iter.mas_find(usize::MAX).unwrap(), 20);
>>> +    /// assert!(iter.mas_find(usize::MAX).is_none());
>>> +    /// # Ok::<_, Error>(())
>>> +    /// ```
>>> +    #[inline]
>>> +    pub fn mas_find(&mut self, max: usize) -> =
Option<T::BorrowedMut<'_>> {
>>=20
>> Should we drop the =E2=80=9Cmas=E2=80=9D prefix here? I think that =
=E2=80=9Cfind()=E2=80=9D is fine.
>=20
> The maple tree has two interfaces, the advanced one which starts with
> mas_ and the simple on that uses mt_.  This is probably why the mas_ =
is
> here?
>=20

Yeah but we should probably not expose this nomenclature directly in =
Rust, or
at least not in the function name itself. Perhaps we can implement the =
mt_* API
as a separate type, with its own find() function?

=E2=80=94 Daniel



