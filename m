Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775BACFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 12:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 765FD6B0006; Fri, 28 Nov 2025 07:27:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D6F6B0008; Fri, 28 Nov 2025 07:27:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67A446B0031; Fri, 28 Nov 2025 07:27:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 574126B0006
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:27:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D72CD5097C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:27:48 +0000 (UTC)
X-FDA: 84159942216.20.7AA1446
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1994C4000D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:27:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JqalkmVz;
	spf=pass (imf07.hostedemail.com: domain of 3QZUpaQkKCGIALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3QZUpaQkKCGIALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764332867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GrxI73IH1zb/tqoEbLnFEuvsfEsSAbtldPLm3aL+m8=;
	b=GGtF/DLxeALceScn0Kje/4REbxN4LlLvuP1mJ9Ho4iqUGq8fc2UdNtKP0C61I0PaJnModF
	Y11ZmQ6cFyZOt1XAo6RLEEgxbpq64vPDAeP2iaAxS67ju58gk0T2i/gkaUtu+c1KprXBSQ
	twASeaFKIy0ACfuiX5W6l+njfH+9JmU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JqalkmVz;
	spf=pass (imf07.hostedemail.com: domain of 3QZUpaQkKCGIALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3QZUpaQkKCGIALICERYHLGOOGLE.COMLINUX-MMKVACK.ORG@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764332867; a=rsa-sha256;
	cv=none;
	b=14rMX9Bk/n4XvPQ3muEUpJrfVyvcPp9wM4iKOzbhos6VrxezcJJpoeDI7N1eMxQG7C8hPW
	kHLrG1gSq9uA8YVb1DQ2OyN6cA8Q414vK7ENxn4wK0yIghRsoQUVgavtIuGvXhzujKvXz3
	YfWm6GEEMWKvSdkPpN8HmkzUfivtKys=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2ffe9335so1269825f8f.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764332865; x=1764937665; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2GrxI73IH1zb/tqoEbLnFEuvsfEsSAbtldPLm3aL+m8=;
        b=JqalkmVzQ9TMh1lwa9kfBcoH0ftT+GFzskAST5VVMdH9WgwinWkJ5xJPuCW8lJ0824
         Ynu24AsrszSk8F/mJIY7BIwDz79DmctU1LIHs+Kmak7TeEXt+1JCeCIX4hjzkN5vj1fE
         purINmYDCpeL6mLKbGS0xWxUNz9kCo7bTarmgIt8VkRxlebumZGSfL0iNcsmR83iUDin
         lqjSfNjaGS5mf7yDRE4r3gT+yb7p5FWtzuAHztG4P/sXGbpKJcVHq/EJOIoowAmoLaSw
         PKCTN4Cp37WZOMdKfSnu2+a8scRu6a3EUt7B0AlNTS4TLLOEuwz8k4gM0Du60JwPGhzz
         Mdqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764332865; x=1764937665;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2GrxI73IH1zb/tqoEbLnFEuvsfEsSAbtldPLm3aL+m8=;
        b=UudQUyDCO58kb14VqMATTH5Z8ZngpbqKVbccxSmfI22vdnM0ooRlO4OIy+11vjvCfc
         nnwVLl6x300r1xGNFb4LflUauu9jg3yEHF1ulhYbALX30p448/iNQBiMnlqTt84i/bHj
         37lWieG9RfrcmILeU4dcZWjmjidRmAf7nddboH33V4aiuPfL9CR4lc/UKw58ETa/QKmY
         eqLCrgJhQo9LYWoJpO+kL+VBvx2mCKtBIqHo3w1TnovbjIMwMQokX2Ew9Y4Qd+JkDP1l
         9y69yqEgEXDZTD9bSXxFM3WcVEGJ2fUhI/GFJuAB7llYaRHsNyj52norH8DLMcTBb8k2
         tXWw==
X-Forwarded-Encrypted: i=1; AJvYcCWThYwwH1ys8YAK/9o5fUXho7iqbsn57XKQvl1zgE2s1B90ty8acNBI91qqpzyq0tX/7yGSJ4ok5Q==@kvack.org
X-Gm-Message-State: AOJu0YyMGN79OM9Cjqz6G/2iYfoBq5AxtO2XlhVWF8r12FRMuOTAYqqo
	mPd8BoBAzVzQD7fgXS2qM5Fzxx0gTTRx7CHwC6G3BL6jTHrLnRtpADig6SulGCDrwTbjcJgV0pj
	NF9oAZQYY50bHkZs/eA==
X-Google-Smtp-Source: AGHT+IFrzQE9ShhEH+O/A+uGYvOpMCgB1tV6y31i20Qgk7dHyiQa17sa62hxuRWbws3zq/cXPMCUdX8VRnAvG8o=
X-Received: from wrqj16.prod.google.com ([2002:a5d:4490:0:b0:42b:b28a:6747])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2410:b0:42b:396e:2817 with SMTP id ffacd0b85a97d-42cc1d199cdmr28747644f8f.40.1764332865299;
 Fri, 28 Nov 2025 04:27:45 -0800 (PST)
Date: Fri, 28 Nov 2025 12:27:44 +0000
In-Reply-To: <12d99a54-e111-4877-b8cd-cb1e58cd6d30@arm.com>
Mime-Version: 1.0
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com> <12d99a54-e111-4877-b8cd-cb1e58cd6d30@arm.com>
Message-ID: <aSmVQDMXqwc8ctDf@google.com>
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
X-Stat-Signature: p3gobrzzqpkxwjhqaipomyihyg7xkiw5
X-Rspam-User: 
X-Rspamd-Queue-Id: 1994C4000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1764332866-575452
X-HE-Meta: U2FsdGVkX1/bZtrT3cIHL3O368xPLydJDI/Cc9qVX9wd3gGFGJ+4YLYpKbphGpqwD6DiMP51RBbobgIc9IfP7PqJO9mGHaCuF/tjsbybnzSQGVY+e9yrNPfLJhXUpmP2KcAPx3y5GwoLGya4TUzM20QGsrk0vDM3osHj1j/X/Af8mcM/ca6462rzOOJUgvC69qYvMuDOAWc5GmdK871W9XMAyrq+RZh1UpPzj0Y9KZT27BwRcXCNqa0eFve+MKNxbZhIc5Y0BHd2bKGHvs2Qvw80D4VpWnm8901mvN2VcSG2Tz3Hz+QCcOQEGELMZ0FgN1HnYOt/MAfRwiKEbmiimjifK3vGHxVYiLaukw8vT7kdl9u/TtZaTEvxy4U9JeX/vq+6W6N0uuN9LUJ4xGDqEd28YcQjcVDDLqfnc9EWicZ3ye300FF4KXLDNXDp/98Pa7onIWjAY0OkvlKpaj7EHV5jUzKd2j3Try/S1hPfrjrUVepcSZaejZTbsjhpwhoWP+DFtHKPjo1TBaOvhE+yaRahTAbehVGqdMCf5M5zG1IMjJLnV5g6qEGduOHzWlIbZAFsuq8eRRsKmvcZC8wPRrgLC7iSrNb2K4IRa8NUO8zOliDHoS250DIlQ08ckqn61asLC6O70ipTyewBqaagZtcTIaNEBeMy679Et/D1HQPOCyMIPe7tu4mteU7VRmCAjGpIhFEcg++xhjKPa3tzJeLlllj5uxpC4jTn1mrFD60Fv6+Cm9YR+DF8I8ZS0YDDw0NUrBmKxab6VFiB6eTfanczOM0cbh7w2Ia2rR1UfJ8CIx4YQ9Zz+BPqR0L8KHIF4Q+7KBrPxH74kxd4z35ozk/OkyPhUPSL/nQWOSMHzIosWsf813WQ1xRDzwKyVuaGcIzHQNlSp0LKohAH+mzrzfomQVxC7tJv1vo7SEj336WiUuUaRahl/oVg6Ydls91oQHzHL5S5zGfF2XDSlnI
 j3KtlaAl
 QrEmgYB2t2wup92NBtykQBtZTy5i1ZzzPpufn1npFO16KKXb/0I+A3+GPmNcpMHRIFy2qRhJvrObaCqYAac/BGi88oaEsEl4g7ev4ZezUDshNag2WPrIgOIv8XmT3oWQlrMjBXHcTXwW8HRJU4fhUdRB/VkEM2fxsEwOokg9ASj7W2I/SEI/qIUdt2JVBD2oT4M15Aq3FRLteChwoxzM8K0aKzxcvtaCrbWqyIPq0l9W9Tia/wJ4P1/F01zfL7cr9gRudYzEkkPK0vpIOaZP+jWnMmYZxj1zbVF7Wd3RgSAK4/ugt8EFRyuxkQs06DU/oCpuRNzSyId+SJQohHrqQExF/m5CDELVqhQccS6hmJYS9PpPOxfmdQt9UV0ywCW32L6DK1q4t7dfZ/1mLT+oS7tH/VEHN+B9oI0Dz1KiJ2IeuC3Wk4WGj2Q8TeqWDOR9T3/Q4XkQwvtPed1tUAhxQ1yeWq6yyTxMC5LaiLKrqYybAxxaEXO8y85yesgrTVvcSNM1MEaUOWqKSRX2lAkR730dDLPzOulX7f9eL3rx0HNAzJC3Wdi+rqeXrQ2nZKd4oQODMBmULv7KppSC44KU4AdmqyaBLLpfzM6DN4kLMXBjRri4H5YIotZhpXxu81toVsXEVGoH8cTRDAcGpIEi1XX5268qnr0lF4hqJ1MmfDfHtGClSHB5J4MbnfARwLzceeA2+OaIKhTPQpPKeqo1bykYomSiaihp10fDLYjIC1jF2CeCGHBv67wJIgYa5luPRPN6FkvT0AGJtyLM9ClW+7Zadzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 11:56:17AM +0000, Robin Murphy wrote:
> On 2025-11-12 10:15 am, Alice Ryhl wrote:
> > From: Asahi Lina <lina+kernel@asahilina.net>
> > 
> > This will be used by the Tyr driver to create and modify the page table
> > of each address space on the GPU. Each time a mapping gets created or
> > removed by userspace, Tyr will call into GPUVM, which will figure out
> > which calls to map_pages and unmap_pages are required to map the data in
> > question in the page table so that the GPU may access those pages when
> > using that address space.
> > 
> > The Rust type wraps the struct using a raw pointer rather than the usual
> > Opaque+ARef approach because Opaque+ARef requires the target type to be
> > refcounted.
> > 
> > Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> > Co-Developed-by: Alice Ryhl <aliceryhl@google.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>

> > +/// Protection flags used with IOMMU mappings.
> > +pub mod prot {
> > +    /// Read access.
> > +    pub const READ: u32 = bindings::IOMMU_READ;
> > +    /// Write access.
> > +    pub const WRITE: u32 = bindings::IOMMU_WRITE;
> > +    /// Request cache coherency.
> > +    pub const CACHE: u32 = bindings::IOMMU_CACHE;
> > +    /// Request no-execute permission.
> > +    pub const NOEXEC: u32 = bindings::IOMMU_NOEXEC;
> > +    /// MMIO peripheral mapping.
> > +    pub const MMIO: u32 = bindings::IOMMU_MMIO;
> > +    /// Privileged mapping.
> > +    pub const PRIV: u32 = bindings::IOMMU_PRIV;
> 
> Nit: probably best to call this PRIVILEGED from day 1 for clarity - some day
> we may eventually get round to renaming the C symbol too, especially if we
> revisit the notion of "private" mappings (that's still on my ideas list...)

Sure, will rename.

> > +    /// Map a physically contiguous range of pages of the same size.
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// * This page table must not contain any mapping that overlaps with the mapping created by
> > +    ///   this call.
> 
> As mentioned this isn't necessarily true of io-pgtable itself, but since
> you've not included QUIRK_NO_WARN in the abstraction then it's fair if this
> layer wants to be a little stricter toward Rust users.

Assuming that we don't allow QUICK_NO_WARN, would you say that it's
precise as-is?

> > +    /// * If this page table is live, then the caller must ensure that it's okay to access the
> > +    ///   physical address being mapped for the duration in which it is mapped.
> > +    #[inline]
> > +    pub unsafe fn map_pages(
> > +        &self,
> > +        iova: usize,
> > +        paddr: PhysAddr,
> > +        pgsize: usize,
> > +        pgcount: usize,
> > +        prot: u32,
> > +        flags: alloc::Flags,
> > +    ) -> Result<usize> {
> > +        let mut mapped: usize = 0;
> > +
> > +        // SAFETY: The `map_pages` function in `io_pgtable_ops` is never null.
> > +        let map_pages = unsafe { (*self.raw_ops()).map_pages.unwrap_unchecked() };
> > +
> > +        // SAFETY: The safety requirements of this method are sufficient to call `map_pages`.
> > +        to_result(unsafe {
> > +            (map_pages)(
> > +                self.raw_ops(),
> > +                iova,
> > +                paddr,
> > +                pgsize,
> > +                pgcount,
> > +                prot as i32,
> > +                flags.as_raw(),
> > +                &mut mapped,
> > +            )
> > +        })?;
> > +
> > +        Ok(mapped)
> 
> Just to double-check since I'm a bit unclear on the Rust semantics, this can
> correctly reflect all 4 outcomes back to the caller, right? I.e.:
> 
> - no error, mapped == pgcount * pgsize (success)
> - no error, mapped < pgcount * pgsize (call again with the remainder)
> - error, mapped > 0 (probably unmap that bit, unless clever trickery where
> an error was expected)
> - error, mapped == 0 (nothing was done, straightforward failure)
> 
> (the only case not permitted is "no error, mapped == 0" - failure to make
> any progress must always be an error)
> 
> Alternatively you might want to consider encapsulating the partial-mapping
> handling in this layer as well - in the C code that's done at the level of
> the IOMMU API calls that io-pgtable-using IOMMU drivers are merely passing
> through, hence why panfrost/panthor have to open-code their own equivalents,
> but there's no particular reason to follow the *exact* same pattern here.

Ah, no this signature does not reflect all of those cases. The return
type is Result<usize>, which corresponds to:

struct my_return_type {
    bool success;
    union {
        size_t ok;
	int err; // an errno
    }
};

We need a different signature if it's possible to have mapped != 0 when
returning an error.

> > +    }
> > +
> > +    /// Unmap a range of virtually contiguous pages of the same size.
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// This page table must contain a mapping at `iova` that consists of exactly `pgcount` pages
> > +    /// of size `pgsize`.
> 
> Again, the underlying requirement here is only that pgsize * pgcount
> represents the IOVA range of one or more consecutive ranges previously
> mapped, i.e.:
> 
> map(0, 4KB * 256);
> map(1MB, 4KB * 256);
> unmap(0, 2MB * 1);
> 
> is legal, since it's generally impractical for callers to know and keep
> track of the *exact* structure of a given pagetable. In this case there
> isn't really any good reason to try to be stricter.

How about this wording?

This page table must contain one or more consecutive mappings starting
at `iova` whose total size is `pgcount*pgsize`.

Alice

