Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52346CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6E378E0005; Tue,  2 Sep 2025 05:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A244E8E0001; Tue,  2 Sep 2025 05:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90CE18E0005; Tue,  2 Sep 2025 05:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA148E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:01:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FF17BDA4C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:01:27 +0000 (UTC)
X-FDA: 83843716614.21.0CAC1BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 918AD100015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:01:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=baUJTPlI;
	spf=pass (imf05.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756803685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMryxygkew06NlplTbkcVp3rqx9J0qMVKKT3morB4aM=;
	b=zv3M/bR5lKHVILwObK5+ugevwzrUGHHx0MIIOOBtWVykBPaekIyMN/Vra13LgOVqVbpI3G
	i86qtoIQuVCoqbkrrQ9VBug93X6IINEZca5ttGGA7JHvs0u/01SUN/Tz1I3R5w0D4/4dti
	BcRcMCqzKV2zzV+BaG1SbsH6Kxax4uw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=baUJTPlI;
	spf=pass (imf05.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756803685; a=rsa-sha256;
	cv=none;
	b=Dp3Y4kEoy5AKjDD8TeEc1atFzWK5644w+QsZBLEBEUN8tNteeZX61/Uoe2KLBylPhjymul
	pAgzyACvEa0P5ExOUOkOG3CykucOu5fg9/XZT3cm2R+V16h9ZjrEMyaeInqq7qOFUA6kvF
	qmOlOo2egraaRDjZx0fstBHD6/pGW/E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D5F4601FE;
	Tue,  2 Sep 2025 09:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471E8C4CEED;
	Tue,  2 Sep 2025 09:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756803684;
	bh=p07YiMczpEjLy1P1T4iapwfegPf/bwOQIeOyzaKjibE=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=baUJTPlIeMsuFcGtJgDaavsbxf3j0VGDSNtAa3sWQjclASyVXrz3MWb//IGV0Lm3b
	 On1aKdbjZHd+SbeT4WbkWRlVOfo7S/V8TZXiVMKOgZTgJ+WC9ij5WbbYEkcZqSfhwx
	 +APBQvKOZFLrZrgpzfA74IUtMW3q0p7quiIX+FdGh4fpJcaYAGkGEDvu3FpnfZh6f8
	 g8+0C5v06W0ytqofAZ/F2Zho4InBsDqM+m8Yy9jOKvztDwpJK7qGiXWGWhGWF0mzUR
	 y4G4ZdMRKw4c05yhGeFgJYRJowgkT3aJ1jU9XqjXojuLoVh/CaTG3fLBjn2aKU1SEW
	 xXaYjF/4DaIxw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 02 Sep 2025 11:01:19 +0200
Message-Id: <DCI6XGR65KH9.27TWYVKNZNGHV@kernel.org>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v3 1/3] rust: maple_tree: add MapleTree
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Andrew Ballance"
 <andrewjballance@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary
 Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 <linux-kernel@vger.kernel.org>, <maple-tree@lists.infradead.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>
References: <20250902-maple-tree-v3-0-fb5c8958fb1e@google.com>
 <20250902-maple-tree-v3-1-fb5c8958fb1e@google.com>
In-Reply-To: <20250902-maple-tree-v3-1-fb5c8958fb1e@google.com>
X-Rspamd-Queue-Id: 918AD100015
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jkou5shbqh5q9s9f6a9nhpgzqnqyafzk
X-HE-Tag: 1756803685-143572
X-HE-Meta: U2FsdGVkX1+RtH6woc+PNeZfe08QMSkredbjOrzLFx5TFsSz52Ywm4UYtHJJCO0VHkGA0cc2V15OLy/U/aCHr7ovUlax6IUbzM/NWB15GTgIzroDvAEElTwCh7mbkCb2zgDN9FUdyBm+dm9uOegcnzLTHvEdEhzYU+lmqnVjoSnxFoXSC4TkplTBN4Ft5XQj5iOv7MW0Pfsr/SGoDuHtM0t7PWAiDTokGen63kFIjj82Jpmrl69KRYutV7HS/D04Z+ZRZfZc79Gp3gXQKEplORUfKDsP4HHsc54LIzEkZFaAktwYOtCY3s+vBulMnMCr/tfchjCpO+atyOv9xttGXuWB+HDDcCh8OqmF8por77iUSEUzFUWJ/n7G3cgF5mGoFkCBVykSbwZ8NwSX0iPu6CnWmR03vARyh03cOe3Eas1YH/x0oySCoQjpGokjNVOYXqPWIqGgUCFRv4fN970eoIRpUfPZNtwRSM2G5q0EX5tN3V26AW5pdrwbRxCxgPGYVAOLRwvBOeL/KTVQSfF4brxuZC1OJMbeFAvsJEzN9iRWFQr8TF8y5skYoAvCaucNnftob8eid+P7fo8pWNWJHrEBRp1HhhGNSRrTqWjsSlA4QsjwOPyXV6YD0sfK7C4PpevZAfoRXbzKdCUERWXDfudVD3DJ3chzLgj5Ub57IeGKqb7h5me6HaAq69GQ5a4BPRPvs5aUqxvf0s+u6T+IjXJX0KhPJEKnKQIlxMIYO/gUJWxxmI2qAYL2nlw7tvqxTEJ3DkoeihJTrW1axiHaXvuJsNXUHpdARb2s6EukHVttgTt6vZSKPw9MhKw+THW5WrKgKhxM1NceXnuZrPAU/JJI/+pzIfQSjX44+FlBCwWduB3i8akKGmd/H9yFz41aML16yiNcIqkCh6ibBM6sKAkqb6kJi8h/LnGAZAJnoeCohYd81NIQuTlJqv05NPvj0cnEFFkv8LpNII01qgG
 pikbfOXc
 1XdZad/eUqM0qF641r9Q7lYYKMSRv6xO2Hi5ni/2niJXQkyktUHjNf3DrcD5SP9GAqIfFJSgpUkSsCghyh1Hie13qBtMLtPAVSYeQ13bZvm89sAnuHHL7bF7vbkX+3i0LIgEZoQVo+pcHuRuT73WZNbQcoaxFs/7aaVFmhgGaG8KIJQkoQ4yS4DL9SuM2bi65bTVvVGZ7H4DSi2zBCLZE49QQ32SNiTQBox3iVxZ3ydYzXjXvkH2Evy5HZ6A1WMsz/yzGz/EA1pqvdg0pfYyvb0yyaSbIq5gAZYG8lHC4QYkRNfFbCvMHOh5p4ACsF2t7E5wvxTJX4F67IgamiXaVZyBLnSmbwJfmcOLLQzVR3YRcMMD+J1t7c8nvBKbEBO3NjzUK/1GNCRzK0VdcDosK18NXqM57eQh1SVm7USd21oojAvxD7Vpb4120WigRZ266DxDoP0rwQlFr9coZNGAcqCD1HQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 2, 2025 at 10:35 AM CEST, Alice Ryhl wrote:
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

One nit below, otherwise:

	Reviewed-by: Danilo Krummrich <dakr@kernel.org>

> +    pub fn insert_range<R>(&self, range: R, value: T, gfp: Flags) -> Res=
ult<(), InsertError<T>>
> +    where
> +        R: RangeBounds<usize>,
> +    {
> +        let Some((first, last)) =3D to_maple_range(range) else {
> +            return Err(InsertError {
> +                value,
> +                cause: InsertErrorKind::InvalidRequest,
> +            });
> +        };
> +
> +        let ptr =3D T::into_foreign(value);
> +
> +        // SAFETY: The tree is valid, and we are passing a pointer to an=
 owned instance of `T`.
> +        let res =3D to_result(unsafe {
> +            bindings::mtree_insert_range(self.tree.get(), first, last, p=
tr, gfp.as_raw())
> +        });
> +
> +        if let Err(err) =3D res {
> +            // SAFETY: As `mtree_insert_range` failed, it is safe to tak=
e back ownership.
> +            let value =3D unsafe { T::from_foreign(ptr) };
> +
> +            let cause =3D if err =3D=3D ENOMEM {
> +                InsertErrorKind::AllocError(kernel::alloc::AllocError)
> +            } else if err =3D=3D EEXIST {
> +                InsertErrorKind::Occupied
> +            } else {
> +                InsertErrorKind::InvalidRequest
> +            };
> +            Err(InsertError { value, cause })
> +        } else {
> +            Ok(())
> +        }
> +    }

	// SAFETY: The tree is valid, and we are passing a pointer to an owned ins=
tance of `T`.
	to_result(unsafe {
	    bindings::mtree_insert_range(self.tree.get(), first, last, ptr, gfp.as=
_raw())
	}).map_err(|err| {
	    // SAFETY: As `mtree_insert_range` failed, it is safe to take back own=
ership.
	    let value =3D unsafe { T::from_foreign(ptr) };
=09
	    let cause =3D if err =3D=3D ENOMEM {
	        InsertErrorKind::AllocError(kernel::alloc::AllocError)
	    } else if err =3D=3D EEXIST {
	        InsertErrorKind::Occupied
	    } else {
	        InsertErrorKind::InvalidRequest
	    };
	    Err(InsertError { value, cause })
	})

I think that's a bit cleaner than the above (not compile tested).

