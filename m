Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB783CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 13:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDA3C8E0002; Wed, 27 Aug 2025 09:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B088E0001; Wed, 27 Aug 2025 09:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79CB8E0002; Wed, 27 Aug 2025 09:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A38858E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:14:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C32C013981C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:07:17 +0000 (UTC)
X-FDA: 83822563314.15.5907F62
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 901B74000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:07:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=2EftuxTW;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756300035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dF5o810a7PTnN/8SbUBia77j9hgRZWPVI3vIEvBDyv8=;
	b=Io3qdzFz6mmoCGjMnPwHUb6xOQU6nk/oGUHbDBYHj02fNUsNe9QnO/WXPQN5tmH7NjNeCa
	FNVn9nbxs5ogABwxAFVlD/7NS7fqbw70RtfbZWztPQfVdKXODnI0NPFJnnaP2W5CFhW76o
	d6rYYa9KYM3ehTDyzBaLkIAFS4//Dm0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756300035; a=rsa-sha256;
	cv=none;
	b=oyjP36VdOe2ZhgurdyRvI25cKpP9KjT4DQgk63MdJUxF+XumFGziFMvkrb7OLRwIYDJQz/
	dHRzbpuO3MV1LTmeLoejezJhUOcdwMq3mPLkgzMtZ96tJSQy4Y/oSN1+Y1P9eDbH3f9U7E
	BgNNI8LH5IhNsny49H1cG47Sl5BFNOQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=2EftuxTW;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1ac7c066so5271495e9.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1756300034; x=1756904834; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dF5o810a7PTnN/8SbUBia77j9hgRZWPVI3vIEvBDyv8=;
        b=2EftuxTWYrV9SsGEhm5ASfK6H+eQi4nMH8mwc+Ao4lE6ROO/8vgCj1JTwvI8VpvGf+
         hEmFyYhnx1lg/r31QYGFd6UKQ5IR9RpfXi0UTr60lMt00upmhIDh0sebMlDwMOl/94iB
         yunzT9NnK0LGSVVfhCJG45zEF1wqrqpOHVMZydlQLf8UaU/2j7zNKZXOb9tnoLlaTCkF
         QRqfFTxtHCgq3v2c4a7iBVD2A1PpGUArFkeGyKRH4ksJWQNJ49A82uBPnl7YZFEim7F6
         /d9iPE3Sr2HIyqaRKx9PDZbMrXQvN+O/sbY1ohsuYneqq8CRRg1o9+JZ19+woXCLtMI/
         sHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756300034; x=1756904834;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dF5o810a7PTnN/8SbUBia77j9hgRZWPVI3vIEvBDyv8=;
        b=ZDsOe66cSNMN0wF2fUS0IE8L4APXT4kpoEhKjRRb/XuMLG5E+CHMzpGyRrQ5oJb5u+
         HzzAxT2zgy3zg3YtxAP79PKdqlb9+0ilmSZflOHezQluf3Shl9EMvCNg76R/Tqvno2Uc
         /DmBwAy5jVPhjUISZ4EiSIUeNNw7c0GmY1Ziw9oVP2af5zM9PKVB0gZxG1dV/BG5QOYQ
         Uj0xZ+CzHl7Gy9e6gb/NmS2xyFXoKIe6vmGff65tNsVg6hvoiW1uco7RsgbVnc2nBcBz
         iuwUweOOcuncxeefgoQwHeJ4jvmmuyZOIslj8KhwYEspuSe9Lu6RlghgGvxOCLjSbFCM
         39Cw==
X-Forwarded-Encrypted: i=1; AJvYcCU9nClJ19h3/ghmQPiX3aNORblLqi1uj9CqJy3PF6xN39BVPeKdiCteOXQv4kz/Q/sFtNTfCxaibQ==@kvack.org
X-Gm-Message-State: AOJu0YxQpd74hnEF8vNzjVxbQf8nRruIBmjTPZgWzIF52ykKQyeo6V85
	jEzRW077kR6YOvd2M1XSfoDkdOwVIGH1Yh+EzVodM5hVasmM83nVLPl6aE8tRt6LlvE=
X-Gm-Gg: ASbGncvwEQ8GjAtozXy9oQ/zaMKQ2zs9UE8oa8vIbdp8u3P9qxKAu3q3SU4AYHWhsX1
	9fOpz2VrK/aOhBBec3WtFuF5afSrGtBOqQSVN7S5yOXL2z5C2tEv0K89hKEUfN5HcJkhwRu2V6o
	T2Y5beEa6/tWKv1L5FW6c1DRNrU8FdFTvF/rcIi6SnVuod6f4uElyrAR/0949HH7Oli2I9U6Dc6
	t4lPNrURBgRezu9oGM/omJ/r6OB/TuHzm6+tGY3P97yN0WAsH5BmQeIGJ+OwEEzIA8sP0X37GdG
	7AyI72KiNaUjdYm8STnTogr0bsAoGbv2qkCn09I5JEeNpW8efAG2M4REwo4IV3YEe3nzBF7iLqm
	Hmvm9cT/eQ1EpyiM=
X-Google-Smtp-Source: AGHT+IHP5mFK9hwcrvF5KKKcJ/uDrEKW0UmrkI7N5sUM5zs07mDFAfytcdN1ohOxsnSGj6LjjgrjMA==
X-Received: by 2002:a05:600c:1ca6:b0:456:2139:456a with SMTP id 5b1f17b1804b1-45b697f4b48mr42946795e9.15.1756300033643;
        Wed, 27 Aug 2025 06:07:13 -0700 (PDT)
Received: from localhost ([2620:10d:c092:600::1:9e53])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c70e4ba1eesm21772390f8f.2.2025.08.27.06.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 06:07:12 -0700 (PDT)
Date: Wed, 27 Aug 2025 14:07:05 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: rust-for-linux <rust-for-linux@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/2] rust: zpool: add abstraction for zpool drivers
Message-ID: <20250827130705.GA7480@cmpxchg.org>
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250826124454.GA1502@cmpxchg.org>
 <CB3E7E9C-2192-4C60-B79A-932AD6CB005A@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CB3E7E9C-2192-4C60-B79A-932AD6CB005A@konsulko.se>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 901B74000D
X-Stat-Signature: orznbjmsjkq44kungajebbe5q53xyxjr
X-Rspam-User: 
X-HE-Tag: 1756300035-893746
X-HE-Meta: U2FsdGVkX18ARbEolONYD+kgclyx8/BUlOC5ngXHbLPRE8VjwZIPy4pG4tcnu7F9OXDCOkGA3KfMmnR/Z3pgi2nwBJDzpiDSKoKzAPDEwMqeUXhYS5Y9bC6PlDFJe8AeDNE2x1eWLwhpFw1ry35D0H9hV2M6CbeRsIM1CLFJtcM+WmBcAm3J7678iDRe2ONsR9GKT16+tBPXHIaC/MBetYTbHPAO5kg+1OpTi3LpaUw1pTDR4krMliX4PpMIt7r/x97QL82os0VHvf0i42OFNK/5ztvMtjukzjhVsGE6xPjFRPcSgOGffrDtN/0u48ziOJSX3SX3dx6GEvwTC795qtWgQpGB1hedgl/YYCVR80x+qOyetRDGIVtGNpyKk+2VF386qthIUFjKEhOvb2ylLAcFQDqvwsVofW/EyWmTu11bddedhtda50YO5f3eM9cI9/GbkWSHuSu7CVBEKSuYlN0OSPreoo1Z96YbD4D/B3GruhBupfm50Wz4EzV1muJ/zjL9hDDLxlAsqUjkIUa9u3tLSDr1xekuKY5ZSrDN+lynFJyhfKTXpynrFzE1vvAhFs8BR+wdqW8xKcjxw1xTM1v5fao0wszTqwg8hj0M08Q3MydoGkQmR2vQCt6OaiU2pr1r08trRgyZWEq8zhTeQdEqbnc+H82DrNQSOHeo/t4udG8GHboiuogBdcrIAkg8yEX3tTGgorF8YY5SJMijwhPL4lr1qIfdvz1ytFjuJRLcOK3WLOOvgpG62ozQ+KSPfN6d08/1YNsEmqaxilB/SPMw6W9Ur3T56JMy3atrQAVusqP9BlHnyjOalz3vIXWfn2hqJGoZ38x8NlEWrk2PEO+3pDg3TxB5X0ndApb5Ap7PLMZLDAGkpqa22J+jYMI2hJRPLZQHPhlevZReRT8t80mH4O0XNVVR0bT0uklXlEYRomwjbECWJdiT+oEkctQwoBkr9ng4dlU0C6Gpem7
 93TRElwe
 4luY4IQTrmUaEUYIZTdDLInERXGCj8hS9zN6m96tsfpi1J5e2VgH/0JRRev2/rXAU/1voyfZLfi6g0nK5JTUIly0N1bqpCzPFvZaaLTq3Ycd0Saws41+3w4/YnlRuzJTsn7EQE2LdKhDGlva+jNx/EVU/8UZHmVFUHds0YfMZc9Dz6lQxTfbdroicSEg+IQk5pYzmRp/zwRBWgPWDm5cxAUxhF8jj+3veYfVKMEfvvejm1vlWF8AiPCW8RBtjafiukZnrv7Bammax0f8c7bcZ+n5jbzlgG/hVNHIMK7fl3MzFYeFvxf8ek7kzJGRg4yJf+qhQDlscu+MKmh02kz1aXMKfyd7QsLW7KOd6ebBwBhfo810+0iTC8eOPoUEfG+DKKsjcgPqBHOgTJQIV40y/vXOOIM0mA139SVA2XF6El9duE1QagZUtbPNqkoNepPCVe9xY2WuHi3JJYQe2Ec5CoYMMj1vu9V9zr4/IaDi1AD3aHcLy6J/MGiMtT6aYQ43dmOedTT9ECkpDoO/exi/Rkm7UDmOj/GXZ1/CIiHFchHmMKXJ+feaYYWC0NqrevrzZzs0HeH4oE3y8Nlmh5qhq3bZOo/68wC3enFbN164yElCBW8eNKAyYRGqk2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 04:56:46PM +0200, Vitaly Wool wrote:
> 
> 
> > On Aug 26, 2025, at 2:44 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > On Sat, Aug 23, 2025 at 03:04:19PM +0200, Vitaly Wool wrote:
> >> Zpool is a common frontend for memory storage pool implementations.
> >> These pools are typically used to store compressed memory objects,
> >> e. g. for Zswap, the lightweight compressed cache for swap pages.
> >> 
> >> This patch provides the interface to use Zpool in Rust kernel code,
> >> thus enabling Rust implementations of Zpool allocators for Zswap.
> > 
> > The zpool indirection is on its way out.
> > 
> > When you submitted an alternate allocator backend recently, the
> > resounding feedback from the zswap maintainers was that improvements
> > should happen to zsmalloc incrementally. It is a lot of code and has a
> > lot of features that go beyond allocation strategy. We do not want to
> > fork it and fragment this space again with niche, incomplete backends.
> > 
> > It's frustrating that you not only ignored this, but then went ahead
> > and made other people invest their time and effort into this as well.
> > 
> 
> I don’t think we have a consensus on that.
> 
> And zblock is, after some additional improvements, just better than
> zsmalloc in all meaningful aspects, let alone the simplicity. It is
> fas easier to implement in Rust than zsmalloc, too. Besides, zram is
> a good candidate to be rewritten in Rust as well and after that is
> done, zblock will be even safer and faster. So while not being
> “incomplete", it’s zsmalloc that is becoming a niche backend moving
> forward, and I would argue that it could make more sense to
> eventually obsolete *it* rather than the zpool API.

That's your opinion, and I disagree with all of these claims. I would
also be surprised if you found much alignment on this with the other
folks who develop and use these features on a daily basis.

That being said, by all means, you can propose alternate
allocators. But you don't need the zpool API for that. Just provide
alternate implementations of the "zs_*" API and make it compile-time
selectable.

As it stands, it's hard to justify the almost 700 lines of code to
support *runtime-switching* of zswap backends when there is only one
backend in-tree (and even you suggest there should only be one, albeit
a different one).

