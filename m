Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48AC7CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6668E0009; Tue,  2 Sep 2025 05:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BDE88E0003; Tue,  2 Sep 2025 05:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FABE8E0009; Tue,  2 Sep 2025 05:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3E88E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:28:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 384A6C0BC3
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:28:16 +0000 (UTC)
X-FDA: 83843784192.20.9322123
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6DD19A000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:28:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zXjeI2gI;
	spf=pass (imf15.hostedemail.com: domain of 3rLi2aAkKCEUhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3rLi2aAkKCEUhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756805294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCJ5Pd5hSyUTTNVQBWxsmI+HwwsqepTaJK7vsUpGjOQ=;
	b=pM4gRW4Sm72I5BdDGlghb6Ka3j9KtUlXR9+89lMzH5yNozzCce9+afEo8Rm0SBXkLP4E5m
	iZDUY6bSsTrSE7UB7z9Y3E1OCvw5+fvk5za6jEfG05f4NXTL2U2YcKZjNnU2PkseGxjnyG
	0m9h7aJmabW8FUD7LnKlrO3BkgmHuco=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zXjeI2gI;
	spf=pass (imf15.hostedemail.com: domain of 3rLi2aAkKCEUhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3rLi2aAkKCEUhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756805294; a=rsa-sha256;
	cv=none;
	b=13iqACiILTmwkCoiSJcLKqbx3JrMWcjWTsr6uff5eIzUTmjgV1/+Cb5QG+3lNOs5kZti89
	PeIaSCkzUBTIUmz2DSL8SpizumSb2KAmVrJDVXDJzUQuuFb5HWry/Xh7GOd1cpzvU9ffBE
	HuzXxChiu5tbLfW/QGzvjxTHgolSIxk=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45b7f0d1449so19635205e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 02:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756805293; x=1757410093; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WCJ5Pd5hSyUTTNVQBWxsmI+HwwsqepTaJK7vsUpGjOQ=;
        b=zXjeI2gI3lzRhJAp1iSMHby1I09X1Eezdv4m67j/ovTxQAWZ2FEtDSG+DL7xN3/liM
         Ej4JXj+GR0E3WyzGnX4VbWkqh/OXTPXjqM/Oa9XLGiVrFMqV1JO0Z/8ieNfxv75/ipil
         V11zVNf7WKfk/GNihxauDWFF++diJ4RcKdjylWuswnCDpcDjFOm1V7mHJUVbQsmKvrze
         CtIt6cTLObnQTHMKMqWeuU4JmrXjDGfMX7grlAjDFtLfaABV09Kw5W2OY90OeTWR62QG
         1azhuqY0UNu4Sgi28cCe/MXoZ86YPVL06gp72G/i4p71Q4cLSYsMKvxSB423RQ8bhhj5
         DA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756805293; x=1757410093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WCJ5Pd5hSyUTTNVQBWxsmI+HwwsqepTaJK7vsUpGjOQ=;
        b=dd5CCHLyf8SoNwA97ePaZMxW6wjY3OTEVBk8I916vY/iFOEY3tKvxOXoFnqoonVokz
         +iCqIKarEt7+0rn1uAYzgfLG0jeX6AlW29sT9f12A/1hvPdreCj3/ETMTO9l9/grVmWq
         VEH1/r8zjPSA2e/gKxlTXaj9hGuwaayIQweKbtWFcM/ZNH4M3NX+GjXOo+enq/nPUUyH
         8BaYToDxeOHDRoNkLHSpjX+kx06rQaG9BXlMvvZRe0kRhPESmk5kSu4aON4TH+QVQdSS
         cS0UjTlexZmCtLEJSiXnCFCGRE0Jz0bvrkpRHDe0exdl1Oq/sRLiLZxLD9XSNHVop26d
         jPSg==
X-Forwarded-Encrypted: i=1; AJvYcCUJpYYvpRvfNbIVSgJxAGPFM3YkH91h0cmlAaAOdrMOZTZ87kPNX1gntSG1ladNnhS+RwvVEmqcDw==@kvack.org
X-Gm-Message-State: AOJu0YwU7/VuMj5cqElresUsn2tKd09NPa5/sQEXJRTGELxPuhcKJNq9
	5raAVbytBBLFFq3a7qkaP8c7Gm2eTzky1iMJjWso+63ZcKexQA60/D0+0t6oN3tXwWQgQC06TxX
	h84u9mbjvMWzclnENDQ==
X-Google-Smtp-Source: AGHT+IEHQOyKU6+Ue9693mOKlMNG23uPJov9FA9k1toBo6GMI9ziGkGJK7zza0Cq4est0sUsZ8sgEdWMBaBwbSI=
X-Received: from wmbji5.prod.google.com ([2002:a05:600c:a345:b0:45b:6337:ab6b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b22:b0:45b:4a98:91cf with SMTP id 5b1f17b1804b1-45b8554fa14mr103519015e9.15.1756805292964;
 Tue, 02 Sep 2025 02:28:12 -0700 (PDT)
Date: Tue, 2 Sep 2025 09:28:12 +0000
In-Reply-To: <DCI6XGR65KH9.27TWYVKNZNGHV@kernel.org>
Mime-Version: 1.0
References: <20250902-maple-tree-v3-0-fb5c8958fb1e@google.com>
 <20250902-maple-tree-v3-1-fb5c8958fb1e@google.com> <DCI6XGR65KH9.27TWYVKNZNGHV@kernel.org>
Message-ID: <aLa4rNojDIeShIrw@google.com>
Subject: Re: [PATCH v3 1/3] rust: maple_tree: add MapleTree
From: Alice Ryhl <aliceryhl@google.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: d8zpi4puwxcp7rjtrta8gkwjnkxrscix
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DD19A000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1756805294-481344
X-HE-Meta: U2FsdGVkX18I0wPubw9rbez383rUWl0X2LV6D8SVIOP6YT/jgviDpo1N76m4bt9YUoZyTpMuSLzNQ018yBLjvj+MU5/6l1a0wl/tJ/O6Fyi42LvFVueDfHUH9JjnWKeSw/mZFokr8b0sLc29+9BifA46e14frSSN8p7nYzd3MLGhdA7HC6l4Nj87T9OSv4P/7lyh3b81pdI11JDol8UgQ8KOde5/HLnHM9/OGDtOOvq1Ag5IhGZUMPjxN9NNiG66nGhTAf1rZ5OB4e1k29WzA7Hz+n9lNIH+UrVgwv3I7Yo+55MHLTY+vr11rMwWb8X59p5qTeGe06y6BFteBceoYct+ktc0g7ULuvgLJLV26POemJFa7W39lBNa2krmkFAk6MD4eD1/cx/y38JRzDKCnhRpoXjRv7bSEygBBj7UB+WFBmyA6h41lfSB/i9d1QTJpm8Cbpmb4k3WlC4nmQ9Ln/3qin3/7Ie3hn//tbDrGey2+7G0wtu2GwuZwrEpL4KJ+WVTPV8UteOv5JSpba0VSnRXanxoYZHIGIGHnFdQonRmk/T4clV+RvYDjUcxg+9Q3Mp/CWiAeIr0VTqD+09a9pVt1+PLS1I/Sc/a42ocAbLuUqdzsYp7+o7LYR3WLsrAVSLGuJ4aHbj8R7Ue9PjDM4XBCik/BR/5glz0KW0egU7nkC2ewHtAUuLtsHRqT3RC+gwijgL8mMmFoPOiR8JJqZnfXsFNAF8UvLuXqZsqP2iIA/Z/cJuIgR4T2GJHN8qcIX5ca9S01JKSJRLoQZuVwINPcxhPT90q0ZKZO7J6t60bnaJuXixn8pwWfTwq7GOh6urHWkEAIRYlEir5oNdGpuOiSD4/fXWggvcNpj91NRQP3Zf+F+gWV5jVpDYJpnKviTqnjN+3eagCIOJEfN6aJgdvceor8Y8FSVcAT/4bN74HH+Sf1oivd0+mtcD0GdN9nlL7RUtWB1Kpiq5qMPQ
 9L1T9cle
 hGBJ9B82Enlnz2eBdTWZlxljP8GGti7NP0LdKzXRFYVaInr3kg4cj873K5NaMw50a0d/R+8QVhyxKi24V/vnvMnF0PaLMEbHiAEw7wFaW0vZ1qnJlW9qxUOwHlNQ0SzLncv0lYHTa8S8kmZbji4Lo9N2QpdYYz5XLnz4uV2vtwk8mZ/YBksSio4rpOu10I/QwIPmBwZDPTjyRna91IwXzA6Soshu5L4xey/X7Rf9X7UKZ9oMszliuEe+AnBgsISrUtUvDuUW2vkYVTQO3MtC45rakSZ+OlXKn/XWaETxILuKUZqxGG7dX2QTMbM5wP7Okwb0Srzi4ezfbDG85cmnt7VWos7Adf6F6x12d/dBpqcqD0YEHtFMN3JCbHizIbWXJL5rp5qlDhmF08K3ozkm6SbHLAK0VfPgzlamsuJrYgrSSWRXBsVkYFbwhrlg7d0rSlJjISty3W8OE3hKBTloJiYvrPdWzeB4JY0ftXPcHNz3nUC1am2EGkFjGga/1HJN+jzXSeUWN33jQaZHFfRIgNY8VHvjuRkCPrXQ32owl4kDjE2Atao7PmUgtooP6SlL7Fr4wN9uT3gtXHd1rzqZ2U8bvWZVNeSJxFOF4eHjcqhcEBhguDvUdhwmE21l9UPE7Rd5nXNCYI2e4p4mGZkgxRk+LYEy7+duva5wfkHjE/xy3Do+SwwRcMGVNENzzBqN1bNJW/ybuyRYeKKtuOxPI1P8qcz+skmscRwViwfjIdXChJDfW/uwtuMr/5J0lSqxcD8+S7b8pTPqXdhM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 11:01:19AM +0200, Danilo Krummrich wrote:
> On Tue Sep 2, 2025 at 10:35 AM CEST, Alice Ryhl wrote:
> > The maple tree will be used in the Tyr driver to allocate and keep track
> > of GPU allocations created internally (i.e. not by userspace). It will
> > likely also be used in the Nova driver eventually.
> >
> > This adds the simplest methods for additional and removal that do not
> > require any special care with respect to concurrency.
> >
> > This implementation is based on the RFC by Andrew but with significant
> > changes to simplify the implementation.
> >
> > Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> 
> One nit below, otherwise:
> 
> 	Reviewed-by: Danilo Krummrich <dakr@kernel.org>

Thanks!

> > +    pub fn insert_range<R>(&self, range: R, value: T, gfp: Flags) -> Result<(), InsertError<T>>
> > +    where
> > +        R: RangeBounds<usize>,
> > +    {
> > +        let Some((first, last)) = to_maple_range(range) else {
> > +            return Err(InsertError {
> > +                value,
> > +                cause: InsertErrorKind::InvalidRequest,
> > +            });
> > +        };
> > +
> > +        let ptr = T::into_foreign(value);
> > +
> > +        // SAFETY: The tree is valid, and we are passing a pointer to an owned instance of `T`.
> > +        let res = to_result(unsafe {
> > +            bindings::mtree_insert_range(self.tree.get(), first, last, ptr, gfp.as_raw())
> > +        });
> > +
> > +        if let Err(err) = res {
> > +            // SAFETY: As `mtree_insert_range` failed, it is safe to take back ownership.
> > +            let value = unsafe { T::from_foreign(ptr) };
> > +
> > +            let cause = if err == ENOMEM {
> > +                InsertErrorKind::AllocError(kernel::alloc::AllocError)
> > +            } else if err == EEXIST {
> > +                InsertErrorKind::Occupied
> > +            } else {
> > +                InsertErrorKind::InvalidRequest
> > +            };
> > +            Err(InsertError { value, cause })
> > +        } else {
> > +            Ok(())
> > +        }
> > +    }
> 
> 	// SAFETY: The tree is valid, and we are passing a pointer to an owned instance of `T`.
> 	to_result(unsafe {
> 	    bindings::mtree_insert_range(self.tree.get(), first, last, ptr, gfp.as_raw())
> 	}).map_err(|err| {
> 	    // SAFETY: As `mtree_insert_range` failed, it is safe to take back ownership.
> 	    let value = unsafe { T::from_foreign(ptr) };
> 	
> 	    let cause = if err == ENOMEM {
> 	        InsertErrorKind::AllocError(kernel::alloc::AllocError)
> 	    } else if err == EEXIST {
> 	        InsertErrorKind::Occupied
> 	    } else {
> 	        InsertErrorKind::InvalidRequest
> 	    };
> 	    Err(InsertError { value, cause })
> 	})
> 
> I think that's a bit cleaner than the above (not compile tested).

I don't love it. How about a match instead of if/else?

Alice

