Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E06EB491B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4444F6B0005; Thu, 12 Feb 2026 07:40:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F23A6B0089; Thu, 12 Feb 2026 07:40:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6C76B008A; Thu, 12 Feb 2026 07:40:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE2E6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:40:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B806F1386DC
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:40:02 +0000 (UTC)
X-FDA: 84435761844.03.4FC3E7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0636C80007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:40:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uSzPhHwV;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770900001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOu2fzMdQIDJsFpWJwfm+4pUeYdoxKJwbpKLHpNm3RU=;
	b=etu5oey7i9xpunbSqA3xtrSn304a+qTX42S7SwVvxnrmFBgAn4rTuTSPFqAtdmZ3sCyuOg
	qidYX4WnjKl86yXAJVkhRIp8G9hyYsMg1VIH1ntru/Ar0B/TUxvZn2f1CxKc3bSTTOXR4a
	2KRtEwiYsBMWEeyZIEoKbz6SI1w0O8Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uSzPhHwV;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770900001; a=rsa-sha256;
	cv=none;
	b=D2bBomR4NKyO1rVYB5naF0oYDEnbq5EfcIaoaIQ8COtGQvX62VVqHdO9c6urUFD9kP0kES
	Ax9PkcffV7UINs8f0Cy79CybTq+Alk6CSKAoK22CuiIhwvVyomkrZopIskGW+/BPzvlA0L
	8neuLepbh4TNR4QiBVDHTpv++/DrnTQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA2664414A;
	Thu, 12 Feb 2026 12:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD41C4CEF7;
	Thu, 12 Feb 2026 12:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770899999;
	bh=dOu2fzMdQIDJsFpWJwfm+4pUeYdoxKJwbpKLHpNm3RU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uSzPhHwVgd6cPCSbgNh7HpLvqqJi+XtjTfdr9wo3/5LBhExD378orAWwFqhK+tlZ/
	 AM9eeHFy7Cg1k1WdhahQC+bQtvyAlaaRYQJCBXPvW+k+ftRv5B4i4VnVbEylBSzK+N
	 pa0BpNKky3jyzlgto1Z2KfZWfPjU9tcJGUr2r/RHREMyUk/a+6hXoCIgWBVwPg304P
	 07jim6HnX7nFlKecFTImwO3MpMkrzLJIoA5cDx80AWc+leaRwd/9q1dYmTAnJRvzKP
	 veQ7XtA/0zjl1uTHKzKPacmvrdbvzp5RjsCixbE6Y4maFhmC8zlaBXDhMh+ZrRnoYh
	 a+SwBnI0kFWVg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Tamir Duberstein
 <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, Daniel
 Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
In-Reply-To: <CAH5fLgjfSWfhUkmG6_ugue6Wp5LKtkEFJofWViJSNByq3sO2Sg@mail.gmail.com>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set>
 <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
 <87y0kytggx.fsf@kernel.org> <87v7g2tesf.fsf@kernel.org>
 <_ZaFqe4HzW4GSDQTrXKDgkSCr7L9bxUh-h5QPqVlMUHSvE0oRFuZJOPi0JItf3VJXHmaX4PA4QWAGBeG73cJYw==@protonmail.internalid>
 <CAH5fLgjfSWfhUkmG6_ugue6Wp5LKtkEFJofWViJSNByq3sO2Sg@mail.gmail.com>
Date: Thu, 12 Feb 2026 13:39:48 +0100
Message-ID: <87seb6t9t7.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: myjn9xot3hm3sks75cztjm9wpx8txwce
X-Rspam-User: 
X-Rspamd-Queue-Id: 0636C80007
X-HE-Tag: 1770900000-418441
X-HE-Meta: U2FsdGVkX1+Q/ixZUHZf1UY0r8wlFVTn6ikMSTqPU2Cs5JUe45Wves2PihSA5ISjiSCqeic8IlrwY/PDznIBzHPbLxw0oPDv5peyGZNBuVvKl6rbHV+xdX8a2edfcO9LnywIuB9zkJUERElwccdkaQEFEbDuLAs8syHr7rAkq2wE2x7EelMgjMZUhd9L30o5mM+fD/+03fbtM+dR7iWLDpEu26oUuqxhrA06wm4o2NJhPFZFKRz5dng0dKuEo/nyWzoxJc1yvBaWumNDtXanuxbgFVK3nSLGjw8Zm9TpmdFFFEfKugvY70aTwFm66HL8+aSkJ8xrMaKEsoarhUxzDuakd29GwDnswv8HiDavEwYqmOXG2OTJuSv1iyXojjSvZqzhauIR4On0S9NAleMnJdxKjtqA7fxa7CUHSGQqKxTn+ZI8xR6dIzmFbWGHSLhj//rjWAyz8MKNYlpS8ciI4eOkV4Dyq+VLzSzaX8QNPQYSHIzbzawQk9WXregmka02zi/VOThKJAdlhPK+yMtjtEroSY6A5RmHMACFEGVgbqecJyNznchMbYkN2ygXz+g496zT2AzJYmEiUe1s2Qvau68uH1gl+W2Ai3x2ypKxUvMukiEBMPR1FAllnP4pZHDaKA4fle2mNefvjs7Wuwl9+JhnT4o0fZSLMnibb9SA6YBQ5G+XW8v06/ygHbDpciNN2lPoKCJUKzqw2OTwDxkrHjK8PurkTi8fAqgyaSYZ4qZBI1zBCUJCp47Tpa5JrXLBL5keyBCtHoTnUlRVACkJxxKrVgNLTlJFqD19e6myDOqr51ZbI0/OYTNBCr8hsekhXSOOsOns6k+rhvfbXi5H/3q84q1c6pSBY56YDaWD/LwoMMq05U9CBmmAGVXCJZJDNEnqiNxpEhBL3bv58NJQdQusyW7xgSGA16LVg+PwdeZKBhI5YYZXT6F4If0u60iDUi+ZmPvD2Sqr1YuPMbg
 fZSuWabQ
 7X8VNekItor3nM1gtmrjYpzUGKz4h2fuKil1B86HsfRbMwNUBICyGIzOq5Y23rZd9Vcq8hNrb2JDHwnPfhK6AwBYVr5tPAhcQpgm25kevMQa+7nnCuc2vjJui0d2C2dskgpmBVo02FWyAekqhyq7N9kLxRtI0S7Wtd+pcG3xJAnEkYK8xC/wbk/zeXNkXt50PJ6raoSfiSMBJ+eicWN2NZF309OME6xSVL4w/W5d/G3gGQfHCrSSt2vJF7pdTQgtrKKD6UGff/to0JnTnFf7x6Inusg0F8Urt0Yx6u2rbaNJLZ6GDjPMsW3N0dXZ7/6Y/UwnzgXrlIKLbkqyLgu8GwRlOPLXf7rEGKk2YWEbYs6qO9VUAxwG3nwA8ndFP97TlvjKy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Alice Ryhl" <aliceryhl@google.com> writes:

> On Thu, Feb 12, 2026 at 11:52=E2=80=AFAM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
>>
>> Andreas Hindborg <a.hindborg@kernel.org> writes:
>>
>> > As far as I understand, this is a borrow checker limitation. It is easy
>> > for us to look at this code and decide that the borrow on line 51 will
>> > never alias with the borrow on line 49.
>>
>> I did a bit of googling, and this seems to be a well known issue with
>> the current implementation of lifetime analysis in the rust compiler.
>> Apparently this kind of code used to be OK [1] but the Rust devs decided
>> to remove the code that allowed this, because it was causing excessive
>> compilation times [2]. The upside is that this is solved by the new
>> lifetime analysis implementation called "Polonius" and it is the
>> intention to replace the existing implementation with Polonius at some
>> point [3].
>
> I believe the standard fix for this issue is to provide an entry api
> similar to HashMap::entry(). See the rbtree for an example, as it
> already provides such API.

The example above [1] is using the BTreeMap entry API to produce the
issue. Are the BTreeMap and HashMap entry APIs significantly different,
or is there something else I missed?

Best regards,
Andreas Hindborg

[1] https://lore.kernel.org/r/87y0kytggx.fsf@kernel.org


