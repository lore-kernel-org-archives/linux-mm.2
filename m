Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D12CCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB66F8E0013; Tue,  2 Sep 2025 07:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8DEC8E0001; Tue,  2 Sep 2025 07:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB0C8E0013; Tue,  2 Sep 2025 07:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA4508E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:11:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CC911DF428
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:11:42 +0000 (UTC)
X-FDA: 83844044844.03.CD2D334
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 994E4180010
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:11:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rYavVE/P";
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756811500; a=rsa-sha256;
	cv=none;
	b=VydnZi/p0Dltw1alsYfvr+ybMmY44SGUfKppRsBf4bWclkirEMqVSs4x4mS4UEdd7OWSwA
	81Neuuanu627u6ZStY9uQ2pJawpzZ2Wpnq/LcBEGaj1W4WPdnBFw/uYXwHgVQ4EyOC14I4
	WS0HivyJ1cWI4Vq5guAefCFnTIv1pwQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rYavVE/P";
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756811500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIGoZgORaeGLSeKUxIGPSwSfiWj9nnM3NFcRo0n/IsU=;
	b=F5zVTmTpKdh0BtTUwP+s5imQtEYjtFrVy3ZLJ7ShAnK9rRa9EsFypvSf94QKFFBeMys9N9
	Whckt+3WwQ1Q6fTkdL0OtZogI/ZeAARSv9VykGin1mbPu5KZmWJKHMcmywULAUgBCgY2rQ
	zCW6tA3pBF3CYZv2nbHyvZJAR6SViZE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 712ED4403D;
	Tue,  2 Sep 2025 11:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E85C4CEED;
	Tue,  2 Sep 2025 11:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756811499;
	bh=A6KhCJ395Or5FmdWt/mYNJIsJqCm7U8UgQjPe9weUwo=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=rYavVE/PST1Yvw0ov1oKe28tkI5gMp3dyFBqNCSnxWZi5nky6cEnugdhye3a3lUa0
	 ZYN6rdZCfC0BpAdxFfa4Fa6zUTjTCpl8e3aEld22fJgs2dKhvkig+zgs2vs7qr2K4I
	 1I5jH/xlmbrVw0j8gTxHP2s3b0sLbDjqZXdlDfGYJWpxhCJTAQbjyXdyAXRVCYZhlj
	 3sZdLoUM03ZtCovFl5mjRBqQGyQh6a8CTDA2A6/nPbM/1RlyDkHOXeKtPpp99RzOM7
	 q3vdbWqdKYEKjillL4WzP8L6t4W03McQDWXIhArIgNaneTFt1Lft6OX5mxFztfWLPg
	 eqnM/pHDWvhRA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 02 Sep 2025 13:11:34 +0200
Message-Id: <DCI9P6V88RHN.BX0BQWFDA8DO@kernel.org>
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
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250902-maple-tree-v3-0-fb5c8958fb1e@google.com>
 <20250902-maple-tree-v3-1-fb5c8958fb1e@google.com>
 <DCI6XGR65KH9.27TWYVKNZNGHV@kernel.org> <aLa4rNojDIeShIrw@google.com>
In-Reply-To: <aLa4rNojDIeShIrw@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 994E4180010
X-Stat-Signature: k9f4yk41ocb1wmaazomze7gxyye8r6j4
X-Rspam-User: 
X-HE-Tag: 1756811500-989781
X-HE-Meta: U2FsdGVkX1+J13EHBearizTbRFyWHLZKW8swxtyY2bLd/lZ3EWIiqevBMUxq4v6zCNBeNbcXFQlyKlmOOhaAk3NNDbRbGveTrH0x40fFiWB4uWuY2HoDL2iTXJEIVtF9WM2iEUoDzd9S7JzW2dPJXEgtUVEgd3UFFimfRvAauWXZo6nfrCWoN+qV863sS3d/pht3QN6Z5nIHvKw0XRY2g8pQn0niho8qGbjG9frqbKblMA7l44EKCO7eU5vFyvbHDq3kEfpisTHF8maIRxli2xL334qLq1e3JO8wNnRX8gXy5dVBFhgkQJX/K1xJCgpWYI9AbFK/UblgCd1XLwDnKdvNztaaqBrE32xlAe7z2ib/3e9dzxpiPqYe4J0vLeqoAL5ydw5t10dK1VSPpF7hvMHakuXhhPaQMdQkYzrclCXWm59L3ZdEE/XCpzcmIYCq0jpRgEFGE3BCjkPUsCWhsafJOGZpAriZQGFecOQ4CRK2DdcvnQpSLF268Zxh7saPB3aMkaxFkCl8XiBGSA7qg6sHNXzlxFWSNVR06bwY3CRvYuXczDxD82yIPKgTXlCJYtLhUIGiJJfZwvwKRwwhNCsKL9eyV5s2WNuJgQcWXCR7kRoywSCKOXG9nhZQmKnjM33nfNrJdw02L5EzDjv7GbD+qrg3StA3Z9QyjPuXCn1qtOav+LHdo6LbIdfnM92CKEQMslYI2wbV2T28NIpTzY51EZTvoYPKs4PDcXKPuzdXTs+ztaKacM4WJpoMSO00W3vzRX3PoT7nzylpLjjiBAVQuPUW/WRIah2OorVUuiGlg6F9V6uOWNpD91EDvKVx/kXRdMWR61pv7nVdKGmcI8E7xmvwKWRDug26NoGh0CZQs7XPHapA0hlX7wW1XJo3cW5HqO5JS+JqHytOGMFNRgW+WZOe8rBsZWU3SH0bHRt6svX9KY7kEB+pnCbfeQNe+UICHNrsvrNL1aKWtZs
 7aFuQ4k8
 Zu57oEBeo9xvq9OK9Qz9KyMCB1lwm0tRcx4i8jpeVMV1YwUFrV57NQ/f8yrX9GYz4VFHHL6eu/5dV7WXLbUJkl/IB1np4dR8KH0K5uHMLV1QsJOWlr4fT/BldMA62ThGzdcIAqZgQJ9w71RtHqzUdncv8dpsUZKnuq497IbP3KX8O0wmtfIOf9j37175uR5kiS/KhcYrag7quf+lpuYkqO8SY0iLUrc1+N12reuEoxojX05pyzRiUmHZ61uh7icIYlioAEboFR+8Ju0uv28QZxbRuTbQaYQzkx2Ur+4Xxd0bCFTPaVwz8xmsy71PaiJCFdwSxVmhpSQTilyUI88AVOHnzKOat1qM9uP0Wf0t47Zx4GIVcT8sQOADmcHZ3ngIYxPL2zxi3qwoIV7QYANdb/6gsTmRksLyKfEiAMEq4Kq9IZXz65q3LGkGYWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 2, 2025 at 11:28 AM CEST, Alice Ryhl wrote:
> On Tue, Sep 02, 2025 at 11:01:19AM +0200, Danilo Krummrich wrote:
>> On Tue Sep 2, 2025 at 10:35 AM CEST, Alice Ryhl wrote:
>> > The maple tree will be used in the Tyr driver to allocate and keep tra=
ck
>> > of GPU allocations created internally (i.e. not by userspace). It will
>> > likely also be used in the Nova driver eventually.
>> >
>> > This adds the simplest methods for additional and removal that do not
>> > require any special care with respect to concurrency.
>> >
>> > This implementation is based on the RFC by Andrew but with significant
>> > changes to simplify the implementation.
>> >
>> > Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
>> > Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
>> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>>=20
>> One nit below, otherwise:
>>=20
>> 	Reviewed-by: Danilo Krummrich <dakr@kernel.org>
>
> Thanks!
>
>> > +    pub fn insert_range<R>(&self, range: R, value: T, gfp: Flags) -> =
Result<(), InsertError<T>>
>> > +    where
>> > +        R: RangeBounds<usize>,
>> > +    {
>> > +        let Some((first, last)) =3D to_maple_range(range) else {
>> > +            return Err(InsertError {
>> > +                value,
>> > +                cause: InsertErrorKind::InvalidRequest,
>> > +            });
>> > +        };
>> > +
>> > +        let ptr =3D T::into_foreign(value);
>> > +
>> > +        // SAFETY: The tree is valid, and we are passing a pointer to=
 an owned instance of `T`.
>> > +        let res =3D to_result(unsafe {
>> > +            bindings::mtree_insert_range(self.tree.get(), first, last=
, ptr, gfp.as_raw())
>> > +        });
>> > +
>> > +        if let Err(err) =3D res {
>> > +            // SAFETY: As `mtree_insert_range` failed, it is safe to =
take back ownership.
>> > +            let value =3D unsafe { T::from_foreign(ptr) };
>> > +
>> > +            let cause =3D if err =3D=3D ENOMEM {
>> > +                InsertErrorKind::AllocError(kernel::alloc::AllocError=
)
>> > +            } else if err =3D=3D EEXIST {
>> > +                InsertErrorKind::Occupied
>> > +            } else {
>> > +                InsertErrorKind::InvalidRequest
>> > +            };
>> > +            Err(InsertError { value, cause })
>> > +        } else {
>> > +            Ok(())
>> > +        }
>> > +    }
>>=20
>> 	// SAFETY: The tree is valid, and we are passing a pointer to an owned =
instance of `T`.
>> 	to_result(unsafe {
>> 	    bindings::mtree_insert_range(self.tree.get(), first, last, ptr, gfp=
.as_raw())
>> 	}).map_err(|err| {
>> 	    // SAFETY: As `mtree_insert_range` failed, it is safe to take back =
ownership.
>> 	    let value =3D unsafe { T::from_foreign(ptr) };
>> =09
>> 	    let cause =3D if err =3D=3D ENOMEM {
>> 	        InsertErrorKind::AllocError(kernel::alloc::AllocError)
>> 	    } else if err =3D=3D EEXIST {
>> 	        InsertErrorKind::Occupied
>> 	    } else {
>> 	        InsertErrorKind::InvalidRequest
>> 	    };
>> 	    Err(InsertError { value, cause })
>> 	})
>>=20
>> I think that's a bit cleaner than the above (not compile tested).
>
> I don't love it. How about a match instead of if/else?

I think if you don't like map_err(), the if/else is fine to keep as is.

Personally, I prefer map_err() over any "manual matching" in this case; it =
gets
us rid of `ref`, making to_result().map_err() a single statement returning
exactly what we expect. It makes it more self-contained.

