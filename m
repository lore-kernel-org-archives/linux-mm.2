Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CB28CF259E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 08:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689596B0031; Wed, 19 Nov 2025 03:59:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612496B00A2; Wed, 19 Nov 2025 03:59:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DA866B00A4; Wed, 19 Nov 2025 03:59:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 327CA6B0031
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:59:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AAA1313AB70
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:59:43 +0000 (UTC)
X-FDA: 84126758646.02.18AB7F1
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC3EB20002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:59:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=qtHfYsxu;
	spf=pass (imf03.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763542782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzo7JFSmXtGRDmhryjldNWPUpcPs+x7N3l93RbhIXrU=;
	b=jDhcIYaCTAC9dnwl2KtCTbPOPN20a8RJBgpU1Fg1NCF9m10iePQ+2A7Y3gtX98RsAZG0F/
	HuhlIpCUXrdmI1EUcgx3Mb3aha2Dx/WQyjyJ/Dy5VWhtCJY1dF7JVzhxwwIMFvAcSQYE+Y
	WLnyw4YMrdx29VzX/iuLZjhyv1hVUgA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=qtHfYsxu;
	spf=pass (imf03.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763542782; a=rsa-sha256;
	cv=none;
	b=nrWiC+W4I1gsnMzi7vc34wHAZrL+2uo5sf/zIFuLGsqwVmjHeDQbHyvnsNq6zYyErkVsbo
	Qc2x1NCLykBi5pDPRKSxKqFW+7+9PKrCM82wGuVNRH5epfEtIq/AdLocDhj/Rh+ZW69Rc3
	h9mqKfES9yiFIG+0Fk3ua6XXj+RTM2c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763542778;
	bh=E8Mtrj+6S1Pc+EnCAlfDCRNIIkXp3AAXGB5KdLL7wzQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qtHfYsxuljOy2QzpjQ9gVt2m9B3q6jMSIEfa8stZ8krjK26dpdxvEkmd0vcZ4A5H2
	 pWvsavwzRRqTo92LpKdR0dBXvZdg09jQ4vGu1QkJkA6Th5sf14utWASO6SRsyD1W+a
	 oGnMXQk+QNq4WHLilgKXqSR3MAaQA7b/e2yEycl0teipL6DutDBA5h3qDfFm5NRv82
	 FqEeOO5QMm5yHj4WUH0kCBhwH1M7u4tOzREUKWesx56W9qQ25gusgfLd8U9Ni1GxRP
	 x/Xz7qq+J3EA5mMAtv2LbB6TiLDrqVQSdX0RLrVt09Dvxpygf95cVfBLciDTjhczPm
	 HnZV6/DWdI33g==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 280C217E005F;
	Wed, 19 Nov 2025 09:59:38 +0100 (CET)
Date: Wed, 19 Nov 2025 09:59:34 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Daniel Almeida <daniel.almeida@collabora.com>, Miguel Ojeda
 <ojeda@kernel.org>, Will Deacon <will@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, "=?UTF-8?B?QmrDtnJu?=
 Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, Robin
 Murphy <robin.murphy@arm.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
Message-ID: <20251119095934.28624652@fedora>
In-Reply-To: <aRtOfhNjlCavCTjU@google.com>
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
	<8A5C6836-992B-477A-A77C-EE0736166552@collabora.com>
	<aRtOfhNjlCavCTjU@google.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC3EB20002
X-Stat-Signature: phyjt37jd5smnismqybih4pth1rcxwok
X-Rspam-User: 
X-HE-Tag: 1763542781-392623
X-HE-Meta: U2FsdGVkX19Bpz3ky4adC4gZgK8epAa5zELOhl6RFFm+VAI1iTRSadCsKGFWOTwjzYJEstMYFRCTu5ono8p6Tar9eG0xsn070K1uRvAaiIZqHNzR5hi6Vjk2TsIqvL6breQytTQ9LAdLSdhxk7s7+eVHHE7VznBeHQ4G5VqC6mqEKP9ridm2c5uCrtW/ag2Sy8OMyq+xtKr2XuqbpDjo/JC6Zwc89Ah39mLtzLnPbhKIrsM7efOLwbulOSQid1ILGDKR1hiVE2A5GoaNOZyEV7fXiObNqkVvTRi62xpj/d+rLwtSeadFRjhlaGB6UmT4kNY3Da5zUGorY44YYQhLv168MhLo0agNNsKPJIDDE6IqSzNJGKJB8zNEaExcwTFf/O8pCfsygdQ2DdeLI4gf0tMivecsTSstgXmuGb73uUUGL+mJdvLJvy3FF/HuH6167STunufkOajGQO+JnOjP/34DO0y6GW9Ng7Fdk8FZifB4eG66TltjDBU6Xiv1lwWtDqEiikNjpCByWn0KLwGjjVrd5JdL0A9E1BHVQfBdww+5+2LQzAg+kZ1YWLYAtQxNi4iV/BBbHrNjUzT/gakZuo688Q8lwlnNn7//b7NW2rlqWxI9yzHQlytnxf/mCtJH8w79t2y8xDHeeoq3kNmhbxzALGVyy7kULwspkczSg+Bf3Sy6Y2Dd3K7FGXUqV2BGFGLG21LiS6lRVR3KPp9D75m8zcWkTgs47OWsCNcbpR5N1+P8KzGgHhxqNYxB/HV3GfYzH2xPGNoL0e9ARCfqoordH/VM5Z42VvPBlHlLy6UUMltuPNjym1f+r4PY39o7t3ydVLHi5RIgLsbx8qJuRMiNE99JnSH4h5PPn58nD/Tslr9J/sAe5RCJlcQIOWrYp4jmQEWLLf9mRDcY+RGUECzuvx9bId3AFZe/l6+HaRpf5o9AE0aKgtfYlZG6QpJdgzh5JzY14hq3zWBgjzD
 KJOOG3hl
 QZ5rMos7RSZEQz6JPDtUJZENRpFqzDGJequKwRpPY7iqXxtELZF9+g9dt9jFeYhtN90cYIwMx2hX5yoEPT08kmDEvzVlDi0FRSLYbyPjXzaejj1JAkRI5HlGZoTf8btir+Tc00QqlV9zsZivokqb3bZZD9+Mj2c2rQiBSYyUWgp+ZKIdTzjNQWHF8JuU2dqweTP/hw8j+cO7dPalZ1GnefzwBQAOWfMCye+AB9xyl7Qq3DMEhi1u3H13GeXNxGLC6gfqczkm8HNuG8Gy+VyKmk8X2vLWCSX1oJTxDQCIxv3rDIGXtl5n/rG7UXkhyoiKEV0xiZBL1r5cusyYBnHxwE8E1GIonefFck/y2tXMO2kMT3IbvjFTiQij1z/ML73tL9mUFncW7Pe1RWbYqRFcPns3/6MnDc6duSbThBqQUg+Zsrp2R/TW3MXGOhPHfxeOkDrnI6mPWcSWKUGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 16:34:06 +0000
Alice Ryhl <aliceryhl@google.com> wrote:

> On Wed, Nov 12, 2025 at 09:57:09AM -0300, Daniel Almeida wrote:
> > Hi Alice,
> >   
> > > On 12 Nov 2025, at 07:15, Alice Ryhl <aliceryhl@google.com> wrote:
> > > +    /// Map a physically contiguous range of pages of the same size.
> > > +    ///
> > > +    /// # Safety
> > > +    ///
> > > +    /// * This page table must not contain any mapping that overlaps with the mapping created by
> > > +    ///   this call.  
> > 
> > I don't think there is a restriction that forbids you from mapping a region that has already been mapped.
> > 
> > If A->B->C are adjacent regions, and you try to map A -> C when B->C is already mapped, I think this
> > call will simply return length(A->B).  
> 
> I think that such overlapping ranges are not allowed. It triggers a
> warn:
> 
>         } else if (pte) {                                                           
>                 /* We require an unmap first */                                 
>                 WARN_ON(!(cfg->quirks & IO_PGTABLE_QUIRK_NO_WARN));             
>                 return -EEXIST;

I confirm the io_pgtable framework (or at least some of its
implementations) doesn't allow you to do that (remap without an
explicit unmap coming first).

