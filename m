Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E5AEC1EAC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2E76B0005; Thu,  5 Feb 2026 07:19:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0908E6B0093; Thu,  5 Feb 2026 07:19:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBFC6B0096; Thu,  5 Feb 2026 07:19:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDCD46B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:19:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 998791C37A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:19:27 +0000 (UTC)
X-FDA: 84410308374.24.5F72CEF
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id F19D04000E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:19:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KsA3daQi;
	spf=pass (imf01.hostedemail.com: domain of 3y4qEaQkKCEYitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3y4qEaQkKCEYitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8VHEdoXvHCSSaRGXtsdIdrKYHnRM+3rTei5HgbDzfs=;
	b=i7c+zpuwNbH10t9JX1o38DjWTP9WdLBfTPr/Vfh8ablobJXAXXj+uergJWthwPYRS0nMr4
	hEf0xRV5HKT0IdwxYZ7spxQK9mr9cPae1Ydpq7zj47IUzzSppki6HYkziKuG3j8AcTi3MV
	NYNvugRkNFlfHncuC6IXgjRI+6Edf4s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KsA3daQi;
	spf=pass (imf01.hostedemail.com: domain of 3y4qEaQkKCEYitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3y4qEaQkKCEYitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770293965; a=rsa-sha256;
	cv=none;
	b=uq7V1PAEqltOJ7tGIFwHEpFAFO1ZO42TULBXl4CnURXvCEYQSCGH9F8lxk8CoTBPRZK1wQ
	4lk1M52W3vY63Lvar3l4alFC1O9240DhLuQg2502ASajekQm02PXva9ArdEidi4cmXN4yS
	twhFjPBvQzkxMw342DtobcrBK9o/weM=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4801bceb317so13826935e9.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 04:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770293963; x=1770898763; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8VHEdoXvHCSSaRGXtsdIdrKYHnRM+3rTei5HgbDzfs=;
        b=KsA3daQiq9t96pD6YoXte9XJvkZWzA6TPx9ViFz8AQK5uwt0Lz/e+z4ZhZjt0QS456
         GWh0033vsHRjdBrsC22yVvXrSWvaigcYxBmd8fQ4B3vqj2iqCiXjnnOahEvhTRNDR8R9
         6a7Xi6wIgKSU+oRpfzVQnu+3khhnT+3CvI6zwq7NCVxZ6AlWPfQV6bEcJo4sPzhPjn5s
         KbOINKqc4cUOFlPZBvlziA7h/omk4xuxIjQZ2FZlQhUw5AV1BTt5WGtKcBoOaIwwrnv/
         Gn3dBkNt35iz16t1kdmHNbmypxLjCQ4sthnVWBFaT5dmbKx8vOpf6n71UU4idO26/5+4
         yQ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770293963; x=1770898763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P8VHEdoXvHCSSaRGXtsdIdrKYHnRM+3rTei5HgbDzfs=;
        b=mSL8/ssF44MACTKTMda72JzN3/eWA9iqAtmM4RCSXIFYuzWuyEe9WwRkAnm4L5n7pN
         GNA9tW3MRStdl6NEgfPYDxfFtnuQF1xwUPN+rZDdG7crqp7P57nBy4aVBgPsT54EEYN2
         Kz4fFV4l+F1YYr1aPif1xh2akaoFDMho4sW/zba5ep/Oj1e4Hr4mibrI0o1bTYMzYOR8
         HiwFQ90Vqc3yKNK/aMLR7B35MvEouCrE9f0Y1ZGaMKlhLR67emGjXbN3DOEvgaE8HqTt
         63qi4ImrFul4m++IAgK9g0XWWUUy1PtdowzBkj6jcEPGcgxJjIfSTkTuH79p5Q7rIK/a
         CPDw==
X-Forwarded-Encrypted: i=1; AJvYcCXt+6ID8TvUtkukMRiFxPyb+t+KQbfnwTgXc2VNw5M2IXgR9i+t9OZ7M7brDdBYO0ayQQ+wF10Rxw==@kvack.org
X-Gm-Message-State: AOJu0YwVlpYqVnxNGhvPV33Vn2kQfbgxXuYxDg/iYYozj6zLNBiObT2l
	ZP95BIP9BSvYRyZvOzmknkPRb5dFwVfl2wN3BVOUpYQzLO1+sN3Kgh/LypsTN3YZq08T9cCp0wP
	j6UWL1/rGyeBbZXoQHA==
X-Received: from wmbgy21.prod.google.com ([2002:a05:600c:8815:b0:480:4a03:7b5a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4513:b0:47d:18b0:bb9a with SMTP id 5b1f17b1804b1-4830e97a05bmr85132145e9.33.1770293963417;
 Thu, 05 Feb 2026 04:19:23 -0800 (PST)
Date: Thu, 5 Feb 2026 12:19:22 +0000
In-Reply-To: <8856c839-1a94-4e4d-9ded-d3b1627cd2cc@kernel.org>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com> <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org> <aYSFyH-1kkW92M2N@google.com>
 <e7247f3e-8a88-4b46-91ba-cb73cce1346a@lucifer.local> <8856c839-1a94-4e4d-9ded-d3b1627cd2cc@kernel.org>
Message-ID: <aYSKyr7StGpGKNqW@google.com>
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: urza8exi7toki7t9bode3za3c59i4m3z
X-Rspam-User: 
X-Rspamd-Queue-Id: F19D04000E
X-HE-Tag: 1770293964-36388
X-HE-Meta: U2FsdGVkX1+wVKhawHoeOfPSzYWmpMX/+Xrx3QB+MRcHoQ+XahIPjoVp9alpFd0aSu544vwK5NhdccVPGYDptlzsY3sxt5SsxWUx8OvnMlrJ1zICntSGRoLvp/djzTsKHgISt62J6Ri79EHSr/y8GroWdAf4HqYq40FDJPFhDwSmAqKlVWb/K2WFQKnU2p0YpzCC9Dx+BmaMPqyZuKsqO/8KzjHSVNyJucJg5IfINGpHgM3NyRRN6XxC4oD1VtAHp8tVxqrf9U7/bitH9e9kYui2T2QvXAHOF1JEcsn809PFU8t/wBRxtKtz1UBY/5djNi3mZ3sAfrKkT4romgohbAhdMyt3SKSswFNBXRaQH5KmEHtyNS3Cu9mALA/4iOXKp5kDqNCFmIiI86U4SLRe1BDoO/DfxkURXW4IlLD797w022m7l7Mq6CI06Q6S+jAmooA9N2GAsOBC7JusrpV2WzgFtpio0ypKh5vYfdxQuR8uIsTSMJ2vPBGwZHDEuCGdp3p7gNFyvFDDtLqCQruZV5FH4YKk9hEHwebHb4wuxz5IxS0G8pyv7LaozMcZodtcWwIvbF8+3M22yFyu+0w+zV1J0Kzo3mnepAH9YN048GhfgAjhEKJJq5wF5AAufxMQ6y6OOOIsTbqQv1FnHyVljGRa3R2mWOovAnOvVNt1dg/5vC/2DwctNnHC+ALX2rxRnTtVXzGpMacYLWYQn2gFT2rKzF1iFOgDlb0791bQmc3TNcZ2GaiqMhPp+3cnJ///jaBK17dj+fB1E6s+MaTyqWoRXPpilfY1OVGR2yX++xGPbi8TI9w11fn3pXRcuoKwk6aurMMNXxrSWxR8loohyHWZd4gfQsHUVy1FYyiYSJnc8JAoxXuhqBzKaXX9prPdbAy8iusbNZ6PaV/xKR6M1LiO7YcnhgvKXUjnb6AFhc1UV9HEqvMwDfvudfcIW8/O3+6xHD0dymHup0orkft
 x7KlfAfm
 Tph8DkMHpWFVvLUlttEln/8TpDXbuQyvslfb3bs8HhbFKIOwP4Ce6G65Muna7h5KM7Nnu9W8whwnYC5Z7y+ZIov+NaTkVCf2x9RpxC9e9+kZi/wCF89QIynLE0tqz8ivxooqiBMwbl9JIO5mxXq31Cv+DFPAjOTLoKo3rFcMEu4y8NLxZW+UwYA68RJQuyE97OwdcBKhaRKE94NT7/S0cYUhEVBq0zWUgwqhss2JMiVRHUkshPh78w3c5wRic2eL+QB22LNEtleWl2A3oNa+kH46ElzT7SG/SWH7iLgVAt9nJ2I3hW+X5NToHpuUh0zG2Z13Nmr4w29aZjMKTC9h9sT6gcBCYVe8KnA3oQveTeJj1HQkNXTGX/mc6UBlRq6Mof1IFyrupe+f5nMK50ZFGNfPsCYRGDOAzWuXMF/HTimku1tpWQ9sBrIE6sA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 01:13:57PM +0100, David Hildenbrand (arm) wrote:
> On 2/5/26 13:10, Lorenzo Stoakes wrote:
> > On Thu, Feb 05, 2026 at 11:58:00AM +0000, Alice Ryhl wrote:
> > > On Thu, Feb 05, 2026 at 12:43:03PM +0100, David Hildenbrand (arm) wrote:
> > > > 
> > > > I don't expect anybody to set zap_details, but yeah, it could be abused.
> > > > It could be abused right now from anywhere else in the kernel
> > > > where we don't build as a module :)
> > > > 
> > > > Apparently we export a similar function in rust where we just removed the last parameter.
> > > 
> > > To clarify, said Rust function gets inlined into Rust Binder, so Rust
> > > Binder calls the zap_page_range_single() symbol directly.
> > 
> > Presumably only for things compiled into the kernel right?
> 
> Could Rust just use zap_vma_ptes() or does it want to zap things in VMAs
> that are not VM_PFNMAP?

The VMA is VM_MIXEDMAP, not VM_PFNMAP.

Alice

