Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC99D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436866B0096; Mon,  1 Dec 2025 04:59:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7706B009E; Mon,  1 Dec 2025 04:59:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5EB6B009F; Mon,  1 Dec 2025 04:59:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 196D66B0096
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:59:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFACF132DC8
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:59:00 +0000 (UTC)
X-FDA: 84170453640.25.4D762B8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id DF307C0002
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:58:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TLkbfyJC;
	spf=pass (imf10.hostedemail.com: domain of 34WYtaQkKCLQUfcWYlsbfaiiafY.Wigfchor-ggepUWe.ila@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=34WYtaQkKCLQUfcWYlsbfaiiafY.Wigfchor-ggepUWe.ila@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764583139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8n92NxyNaQcFOv77Y1KGrTuD03BcJ0jos8t6qKohZE=;
	b=uEJ0/9RqCDTWLsrJoP/wZGHtES1WlCpPy3Ae1G+qlmBU1V5DED4l9jSxjVNLWcYLlzDOWo
	Avpuv8ZUWpLIh6LSQKic1/vw0O9n4AaJ7uyfheLF3IYAH4pcaPKiiBZrBdFc80Agg//TaO
	6Ct/UhIVbOaehNsuJvTr7fGvObgMlPA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TLkbfyJC;
	spf=pass (imf10.hostedemail.com: domain of 34WYtaQkKCLQUfcWYlsbfaiiafY.Wigfchor-ggepUWe.ila@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=34WYtaQkKCLQUfcWYlsbfaiiafY.Wigfchor-ggepUWe.ila@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764583139; a=rsa-sha256;
	cv=none;
	b=qH13ooT4pAtddB0Alto7veIoqKPvVFyei7zSITlHCi5PZ5oVzQqxL8mmmmdUSY0o6qzh/M
	gCdqHjIR5xdNvxVl9tgCWWpTHNuXIErsJBSYqm0ClCTHb8FfeYfrRTAn+fJLXHB4x/4AJ4
	CYxIUEjQxKmCKb/3xErk5CzXtg1bmys=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47799717212so29323235e9.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764583137; x=1765187937; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a8n92NxyNaQcFOv77Y1KGrTuD03BcJ0jos8t6qKohZE=;
        b=TLkbfyJCm8jHdrrIk054foBnkFONMlxqZcgBhrh5HeDboQMCLFddz2lsZrq43legAB
         qaQQ3KFXOIC6GeN1BigFZOX87W9S/yj52+WdnICuQ+mCXgXT4RAKCSj8EAEbWluAaJQ8
         k4Ai61rfvNktFjmZdodb6W6X/DpA9kjV2qREq+X4D4phz2F9BFD2rll3HpZTluLp5cB1
         zbEA4Z+veGTCZ1FZ7OwCFBZkpxTZyDN5ez0cq8nx2cgmfhn46gwLw3E9wqPJbVGd+A3x
         UOwGGzsjwOvlhSJ1lL9UUW6L0YLPuUxJji4mUQqrXiVwZzq0EG7FA1F+3WZZ26fNbtsq
         +UAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764583137; x=1765187937;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a8n92NxyNaQcFOv77Y1KGrTuD03BcJ0jos8t6qKohZE=;
        b=GPeZZSdCahas22bpPdSvrnSUjd9Jbr+ZSglMLiC8A6iOT9hS6Un9I8CuJesDVnxJUl
         f17/wOTrqBwOhXJP+7Q5G+4V5QhVh7jqDKXEGRRG12peTTLgpwB03Bh38dYQOzEM4mtF
         IeIXIFhjegHVEehLhR+KQM4C2jBBnm0YWGBjhEZjCxJPmgELuSu0uSkOAS/i8NuOSmae
         Tt/BsxUktsHmNVJ5U5LxjUFET1QxFJQKJQgeJFTQj+8IYhS4+bWkUEz2bbN0ppzYXfwg
         +guwy9iDctjzG0bXbgArUvqbH4eFcYOZxSmxivTVKeJqboOVb8O4knsiq2l7fB9l+70S
         pprw==
X-Forwarded-Encrypted: i=1; AJvYcCVRpM9lgULK9VwXc4U/dOhagVi36UWjVllRbjKLLn7I1Ej9lfPQACjKxqXp6bZDkkh4CLI8dj6y/Q==@kvack.org
X-Gm-Message-State: AOJu0Yyd3yHykacDtyB9w/6UJ50Cn6r9yUjqhs0U59FusFwMM+yWszME
	6nWDVxIGPBmJ67WvYV+5HQ/l0Z7jANqgwjS+dIGxxqxqu7I7gX1YIxGRXSKoh2x72RIFbXcBBvn
	A2ozjUYRbUaTnq9u6TA==
X-Google-Smtp-Source: AGHT+IE30ug28B+UD0DWj7O+zjLWxPTqpE2raQjUVcci0EVV14naheaFBpit1w3aaTTXqjlC41pTF7QjzuYwcvg=
X-Received: from wmcn10.prod.google.com ([2002:a05:600c:c0ca:b0:477:afa:d217])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f14:b0:477:7b16:5f77 with SMTP id 5b1f17b1804b1-477c10c802bmr381654045e9.3.1764583137353;
 Mon, 01 Dec 2025 01:58:57 -0800 (PST)
Date: Mon, 1 Dec 2025 09:58:56 +0000
In-Reply-To: <c8229530-ab87-4b51-8f2b-6199a01095b3@arm.com>
Mime-Version: 1.0
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
 <12d99a54-e111-4877-b8cd-cb1e58cd6d30@arm.com> <aSmVQDMXqwc8ctDf@google.com> <c8229530-ab87-4b51-8f2b-6199a01095b3@arm.com>
Message-ID: <aS1m4DawouC1utSj@google.com>
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
From: Alice Ryhl <aliceryhl@google.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: DF307C0002
X-Rspamd-Server: rspam02
X-Stat-Signature: wwn5jygxbgsssqn6oa6shwuo84wxezqt
X-Rspam-User: 
X-HE-Tag: 1764583138-459328
X-HE-Meta: U2FsdGVkX18Kwo5Y4fQicTQZyCHtSiHljdYtRLedEkKUrOyeTgIaaWOtPO98lTNohTk71fWrXmTaFIp2nw1oaaPrUWY4CIxl/5dC/MyUyui5QEgmrumBWPlbMnC/pRaY3y80M+ue7ngMOK00O4Z9rLXydPf4YsEWfJ9Z4b1aa41eUD/zSY2BMTPkTSOyVf3v66O1hEFahH+HmPgBBYFn/EzCyTl2+T/qWeeavqd/IfhxnzlSYJCnBiqiB+8Nc8NrJs1TAVT1EKKcyB3aMaPf8KIwA2Tr6lfGpcjvYJg12VRU9MDzaOHHyP3pjvTOL+W02iZixDI8pgIat6T4j11pIYVTKA1mAk+Lwfcw/jjYpRcYYuD7PRIGPDgmSqW+XMgLGDj/7uX9MA/fqgaQ4QsAJg7iXlzCoD2DhvGxRD8V+xAA2ArmIQtG5oZlZBwVXuNv6p5ccJQjBF31ysnCEfOHWsrl7pxBa9axbyLE+i++6FMvX84m9yh0Ih9hsTxnfr1nIffi2bXk5nFJzh6h+VTgSsgdlv7/Sp0F6ZixWlmDrkp5WXfsLBi9FxLhw35EmAlF5REEFGSc6+MXb9vqc76gXyMPIdorBFc1h/dBJAKSXZTlCB51nBERJrmyUPbQ3+CafM74DDsrtgfhO4t+K/NuxtThhIty1GNqMygNKxBLcgUqNwy9pJMd00oHvUY9jrqxA2bH+hn00SJkjfHuk/E+r4o7XB2cBPtMpRmXhP3FyIZ+fDHPb7IwhDLxGr5J5+feKqkqQhtZ5DWSh3PktJSzWVEmyXh/tV7u3wnMz0UkZpNOLsDmNTV1S2+L+bQmPHmBJkYDXOXUMJc3bnZXkwjD46fk+1iMvSxyDe3JZVw22usk3DyTxTB3m7RcSVeOwkn7j0FP83dDrJZVTXyWG23dbx+Xzz83+Mkc6Kcb76cGy8hrLqbiKZ9kg+g2AjsJ8W5uXaa4RoJYiSVaxjUauJv
 aB5ssiNm
 2boe91dt40jap0mDQRl72G/yljBaD5NNRLxkzwuv/n28BJCYvs8WYI2SQCkJuEJp/88Rik+wb5bbmU8tKBLKQYdCk14lROgAcdC+eDRQNy367UWVdcpvqiRpDpAqLWkkvyYIV0v+TbhT2sLIQXuaGj2Niaij6FT5OamW8ti/n14hT7Lh+UZ5BvtwlgvQP5bZTzOJmCV9WCvSe+VPHhuS8ZhmARd5Gu8sVPxF7oOrNoCeYwUtsZuzV91K0BN0L8wzwTxjxQBq5gZzbBhzQSxNkMDQNugdbdd6B7K3F4cGLu5l95AhM3RvGEb9RLOh7PT+lFc6+haoSeWaO0UGQihV2C04PBVKtxQHV0eQnlR3TFZl884uSXN+XKJqb6xR61CaF7jxHTty8s9WsiF1u/ocLl48FI5g1hhTzTHmnNqYoNk9GABYZE3I2d+3G0zXn6hvOOIY5D93xxTz1votQv7RW2vesBmad/+SHe2Gw3N4nYbCZXsOQdUab4AeOGiEhh3XEREa/dFZscuxDxhibe0BahyYO8c67r6xYIq7AYG0Socr9WV3l57XwjVbCQXic+5WqC/XkbuPVAAQqW+gLFEwjfMMSjup/hE/jWbX4lGCkci/poV9dA1SCdLaU1759PiHR1AOffHfzIDpyl9yoIexCcddcRPg6tZWSnUuz9Nj92R+xvIj88/elS4UwVGPZe1cSTgL/Ko7tGlQxzdmrtEMxzqj7E7onbXM/4RkiZtNUrl9dqUQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 04:47:52PM +0000, Robin Murphy wrote:
> On 2025-11-28 12:27 pm, Alice Ryhl wrote:
> [...]
> > > > +    /// Map a physically contiguous range of pages of the same size.
> > > > +    ///
> > > > +    /// # Safety
> > > > +    ///
> > > > +    /// * This page table must not contain any mapping that overlaps with the mapping created by
> > > > +    ///   this call.
> > > 
> > > As mentioned this isn't necessarily true of io-pgtable itself, but since
> > > you've not included QUIRK_NO_WARN in the abstraction then it's fair if this
> > > layer wants to be a little stricter toward Rust users.
> > 
> > Assuming that we don't allow QUICK_NO_WARN, would you say that it's
> > precise as-is?
> 
> As an assumption of use for the Rust API, like I say it's fine - it's still
> not really "unsafe" if a caller did try an overlapping mapping; the call
> will still fail gracefully and accurately, it's just it will also fire a
> WARN_ON() since ARM_64_LPAE_S1 without IO_PGTABLE_QUIRK_NO_WARN considers
> this indicative of a usage error or race in the caller.
> 
> If we do end up wanting to support more opportunistic and/or
> userspace-controlled mappings by Rust drivers in future then we can relax
> this expectation as appropriate.

Yeah, let's just say that it's an unsupported use-case. These bindings
can be expanded in the future if anyone needs QUICK_NO_WARN.

> > > > +    /// * If this page table is live, then the caller must ensure that it's okay to access the
> > > > +    ///   physical address being mapped for the duration in which it is mapped.
> > > > +    #[inline]
> > > > +    pub unsafe fn map_pages(
> > > > +        &self,
> > > > +        iova: usize,
> > > > +        paddr: PhysAddr,
> > > > +        pgsize: usize,
> > > > +        pgcount: usize,
> > > > +        prot: u32,
> > > > +        flags: alloc::Flags,
> > > > +    ) -> Result<usize> {
> > > > +        let mut mapped: usize = 0;
> > > > +
> > > > +        // SAFETY: The `map_pages` function in `io_pgtable_ops` is never null.
> > > > +        let map_pages = unsafe { (*self.raw_ops()).map_pages.unwrap_unchecked() };
> > > > +
> > > > +        // SAFETY: The safety requirements of this method are sufficient to call `map_pages`.
> > > > +        to_result(unsafe {
> > > > +            (map_pages)(
> > > > +                self.raw_ops(),
> > > > +                iova,
> > > > +                paddr,
> > > > +                pgsize,
> > > > +                pgcount,
> > > > +                prot as i32,
> > > > +                flags.as_raw(),
> > > > +                &mut mapped,
> > > > +            )
> > > > +        })?;
> > > > +
> > > > +        Ok(mapped)
> > > 
> > > Just to double-check since I'm a bit unclear on the Rust semantics, this can
> > > correctly reflect all 4 outcomes back to the caller, right? I.e.:
> > > 
> > > - no error, mapped == pgcount * pgsize (success)
> > > - no error, mapped < pgcount * pgsize (call again with the remainder)
> > > - error, mapped > 0 (probably unmap that bit, unless clever trickery where
> > > an error was expected)
> > > - error, mapped == 0 (nothing was done, straightforward failure)
> > > 
> > > (the only case not permitted is "no error, mapped == 0" - failure to make
> > > any progress must always be an error)
> > > 
> > > Alternatively you might want to consider encapsulating the partial-mapping
> > > handling in this layer as well - in the C code that's done at the level of
> > > the IOMMU API calls that io-pgtable-using IOMMU drivers are merely passing
> > > through, hence why panfrost/panthor have to open-code their own equivalents,
> > > but there's no particular reason to follow the *exact* same pattern here.
> > 
> > Ah, no this signature does not reflect all of those cases. The return
> > type is Result<usize>, which corresponds to:
> > 
> > struct my_return_type {
> >      bool success;
> >      union {
> >          size_t ok;
> >          int err; // an errno
> >      }
> > };
> > 
> > We need a different signature if it's possible to have mapped != 0 when
> > returning an error.
> 
> Aha, thanks for clarifying - indeed this is not the common "value or error"
> case, it is two (almost) orthogonal return values. However if we're not
> permitting callers to try to do anything clever with -EEXIST then it might
> make sense to just embed the inevitable cleanup-on-failure boilerplate here
> anyway (even if we still leave retry-on-partial-success to the caller).

Is the only possible error -EEXIST? I could encode that in the API if
that is the case.

> Note that it does appear to be the case that io-pgtable-arm in its current
> state won't actually do this, since it happens to handle all its error
> return cases before any leaf PTEs are touched and "mapped" is updated, but
> the abstraction layer shouldn't assume that in general since other
> implementations like io-pgtable-arm-v7s definitely *can* fail with a partial
> mapping.

Agreed, I will update the API accordingly.

> > > > +    }
> > > > +
> > > > +    /// Unmap a range of virtually contiguous pages of the same size.
> > > > +    ///
> > > > +    /// # Safety
> > > > +    ///
> > > > +    /// This page table must contain a mapping at `iova` that consists of exactly `pgcount` pages
> > > > +    /// of size `pgsize`.
> > > 
> > > Again, the underlying requirement here is only that pgsize * pgcount
> > > represents the IOVA range of one or more consecutive ranges previously
> > > mapped, i.e.:
> > > 
> > > map(0, 4KB * 256);
> > > map(1MB, 4KB * 256);
> > > unmap(0, 2MB * 1);
> > > 
> > > is legal, since it's generally impractical for callers to know and keep
> > > track of the *exact* structure of a given pagetable. In this case there
> > > isn't really any good reason to try to be stricter.
> > 
> > How about this wording?
> > 
> > This page table must contain one or more consecutive mappings starting
> > at `iova` whose total size is `pgcount*pgsize`.
> 
> Yes, that's a nice way to put it.

Perfect thanks.

Alice

