Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C66BFD0070
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 16:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4D716B0092; Sun,  1 Mar 2026 11:34:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0DDD6B0093; Sun,  1 Mar 2026 11:34:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37566B0095; Sun,  1 Mar 2026 11:34:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B07E96B0092
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 11:34:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F8338C1EE
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 16:34:45 +0000 (UTC)
X-FDA: 84498042930.23.8C23A36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E6D6B1C000A
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 16:34:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TKgzX0hf;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772382883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Zj7aW2k2UAGma+vFfPX1im80QLZ4EW4jTCDCEQtZxA=;
	b=KdZzAY+D1e11xNN4v4JLa3bMouzuKrmKUgvmv6jr/4QxL1KQTgSuVlLL3PVa6SEj9W8jcP
	svcqi/J8X9055Q5bQ6p/GdGTzL7obC2/DfmgJnR9J4r7nLx2zzPOD+YztvjkwBRloe0CIJ
	Q/5xEZhk0bQt/AQwspishnorPoVlWsU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772382883; a=rsa-sha256;
	cv=none;
	b=MSZ4Iy+5v5gnbWSC1NvtiqosZ5x+kvNd7uMSHyXJJzC3XeraGUZpACZtOTWsiIuQT1NvRv
	iS+SnEZMcKSmCxQtaXw/CXUOWWHFx+1WQMcp3gM/jbQMrtrfwkYa+UCRrUnUHx/KvP0h/i
	TkjnefSvszb3D1ZdtU1rhXPuDQgAdqU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TKgzX0hf;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4618A600AD;
	Sun,  1 Mar 2026 16:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC44C116C6;
	Sun,  1 Mar 2026 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772382883;
	bh=je5mLoR2Jxu2IjLDAPypnbsm91i4Kuu9GRu6352moZk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TKgzX0hf3d0lhMQetjAEiiWCOKnFnzvXZWHgmPaqhbewdN3fJRosoCZCc9qBvc/po
	 evHx93y+6jGFm1MG3XNqYQsOr8ddGPjYTtni3MBr4+Wfeg0Bdp7DgyJtpeSaRoBKsq
	 /8EmI4goKRcWrT+Ty8VXffQn9jZgFIq3COzQDhZXz+v1zP/sZmvi7J3/9qpNTmJlXX
	 dvga5zyWNUWjv9DVOk3rU4gbLyOte0fKmobQCF487i0iZ6UJJpeiE7pdPHIoBrDEge
	 JZG83Fy8G1/GE+0kCzgow04ihq31SX509/egQfJwEahHcltsBfRDzs14I3kQCC0Q4D
	 NTYljGVX/IW5w==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin.linux@gmail.com>,
 Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Uladzislau
 Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v16 01/10] rust: alloc: add `KBox::into_nonnull`
In-Reply-To: <DGRHAEM7OFBD.27RUUCHCRHI6K@garyguo.net>
References: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
 <20260224-unique-ref-v16-1-c21afcb118d3@kernel.org>
 <eeDADnWQGSX9PG7jNOEyh9Z-iXlTEy6eK8CZ-KE7UWlWo-TJy15t_R1SkLj-Zway00qMRKkb0xBdxADLH766dA==@protonmail.internalid>
 <DGRHAEM7OFBD.27RUUCHCRHI6K@garyguo.net>
Date: Sun, 01 Mar 2026 17:34:26 +0100
Message-ID: <87ldgbbjal.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E6D6B1C000A
X-Stat-Signature: 4qj9ktgj4jpzfqymcb19axxciuytscnp
X-HE-Tag: 1772382883-213637
X-HE-Meta: U2FsdGVkX18BS5h8oLJf+F9Oni8TJuCBsaaCxsF+LGheEjWpHu4C1nkp+KQ7NbWkEgx45feciD6pD4poOO8pi46MYqrnI2S94W1KTQ607fr5vC2t2bFEgRr2gLcvZxg24V50zTfA+6DkKnaA9LolZivX7jcjPMcR6UecU3QxA0ldpvplsxIWMDW9Nv3Ipny9E6fooDDAagmaBNjFX7n1x0buwCx7wM4bW/QxgH8aCpvtCVfc0E0wPoQqs8E5xlYWBdhfeLjbi0PMzLntmR1jr68ykpMWzOowNtSjpmpxsQcIy45xqhGv1hqqLXOOn85uEtLxQLR0l31jG8SnV4voivKyWU71zpNuLlpteXoI8kkO3MyopHpCYG7s0UZqznRdzb8SsI8zsJAzD4N7nNusHbzuYBUHL5XlUjNL7C34jsWB2mkH3EF2Fq8Cc6jHU3yhojs19Wt+5gSdRIamj7q3JK/BRyEQlVtJPoN55n5jaDgTfzYCc++cOI1KdgUpwPy387rXmlwxLvLG4qtKKFfJJ3eYVxZLiJgElaQHqKUkwzo8qhzZapWd4b/ZXC8O5NnVPeWC39Z4G9Pqkm2lvTe7IEBLW9X6s/dBiDzXrIBhFI1BhoChn0m4htXCKzPMiFDQIIe8VuWE4QBVOh2R1hJ22WHVHNvQ31kZIA/LwCcv38evNQWhAOdnpw+frwgaydMCZwRqLa10uhRxHB0XVNJKbh1e9KB0lnHYt1u7VEcyE/TPlMAslFgXcCilHLwJtB17ZWCfOcRaBw+Q1o34noItORp/KOJ8wm7njeWEQIl9mR0xS5sfu8bibRHQlIa2391WYaLU1AUFi280Tcy4/JdmKI0kgNe90FCnl165B60d6AJyHBy4Kg2q3z3ROGkQFzoDI2v7qSUF0nC0jiV0CiL+0nTM7Wr7amYCqshtQRnXDQGxZNtREfLKb5VlZtFqPDgIHAu3P5rF+yBla9/22wP
 7IGvRiTr
 9ymzYqnrSgc96aTPa5wWzfjmpKFG1e1AMFnCOHAHajBSXHlBlKxyHfDjXTjcm9CHBrE97jmkcjkgvPbCw5NCBzk5Af/VPoXp09vaKWGe8Lrvf7GQCs5E51vpCVNs1JnqZJmZky0bU+8fOa/lIHNg5pluDttaQIcNhnAHe8LHuScso5TYXScs8023vQIm3Lpvbr+ZUEhjoOlwV9vL3FFm9TEYCjFchmhEYhhHJ7gHDROuFYXyCxdKb5kIdkJVlavKsTgzaqW4tgbUG3KHuenqmOkrAHGrzVtTnMTeXAffQonxOkl3gziVwJpqMdoxRYaj5Tm5TYVPEpgqLFO/4mtV7LI9e+42km8D0N8faTcErV5a7+rg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Tue Feb 24, 2026 at 11:17 AM GMT, Andreas Hindborg wrote:
>> Add a method to consume a `Box<T, A>` and return a `NonNull<T>`. This
>> is a convenience wrapper around `Self::into_raw` for callers that need
>> a `NonNull` pointer rather than a raw pointer.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/kernel/alloc/kbox.rs | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/rust/kernel/alloc/kbox.rs b/rust/kernel/alloc/kbox.rs
>> index 622b3529edfcb..e6efdd572aeea 100644
>> --- a/rust/kernel/alloc/kbox.rs
>> +++ b/rust/kernel/alloc/kbox.rs
>> @@ -213,6 +213,14 @@ pub fn leak<'a>(b: Self) -> &'a mut T {
>>          // which points to an initialized instance of `T`.
>>          unsafe { &mut *Box::into_raw(b) }
>>      }
>> +
>> +    /// Consumes the `Box<T,A>` and returns a `NonNull<T>`.
>> +    ///
>> +    /// Like [`Self::into_raw`], but returns a `NonNull`.
>> +    pub fn into_nonnull(b: Self) -> NonNull<T> {
>> +        // SAFETY: `KBox::into_raw` returns a valid pointer.
>> +        unsafe { NonNull::new_unchecked(Self::into_raw(b)) }
>> +    }
>
> Hi Andreas,
>
> It looks like this patch and many others in the series are missing `#[inline]`
> for quite a few very simple functions. Could you go through the series and mark
> small functions as such?

Sure.

Could you remind me why we need this directive? Would the compiler not
be able to decide?

I know we have an issue when we have call to C function in short
functions, but not in the general case?


Best regards,
Andreas Hindborg




