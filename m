Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C66C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26416B0088; Tue, 15 Sep 2026 09:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0686B008C; Tue, 15 Sep 2026 09:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78336B0092; Tue, 15 Sep 2026 09:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3646B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:31:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7C08A03EE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:31:42 +0000 (UTC)
X-FDA: 85216084044.03.8F2091C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0B6B120003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:31:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bxgsy2BH;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789479101;
	b=Suf3h0MWMkgPHPye2rSCtsVHcLpewW8XJ8oH5jc0P18KLpjOucnS2wBhfnUR3yEL/iNcAb
	qh2PBbQ+SL3Rsi95ZxVCJXkRD3NdOLI2ajPyYE60uT9R2EkG2ynFWGBRYaMuOTZLLFkh+E
	AdKsWOrWEqwNfleYFZHmdixtLFfRvLo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bxgsy2BH;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789479101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szNMGe0DObGeR+SwRrUoeZsesJIvyvHlKuWjShKq/XM=;
	b=dZiHmZsk+pzaase+yIhQiOaDhHUyKs80IIccax4CYuzPNxSOcsgK41UB5/9sVVTU5YfvOD
	YEmJ4TndtAsdpBZFE6ka0J47GNqdz1/fjD/xoF1xFt1uM7ya7yQt35ZJNQLv5ITL19r/CR
	vZDIpN87s1PmS5HZt0avZC2FVTm60rU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27A1C43C5C;
	Tue, 15 Sep 2026 13:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE8D1F000FF;
	Tue, 15 Sep 2026 13:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789479100;
	bh=szNMGe0DObGeR+SwRrUoeZsesJIvyvHlKuWjShKq/XM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bxgsy2BH8vB1k6x/MwDXjlbNVwjyZEYkY8k9e3PdVaD+xjsGtBcSM9mJabPOrJUzz
	 kd+tHYqRrKZEq87R5a8vsjCkYvifnJ8NtGCJawmHnVkZckYqaVj42qfBwQldxWKjGN
	 lGHVDHinmGCkNbzgPmoE22Y75nwCu0vz4nOwIRCQC+CkloWdVLGFpJuKkkt6yR3sjn
	 nFZNRopmz55BHRoMcDgESNpOC07YvQkifLyL9ERd9uVTHuFnJV5FTShXlo1wH1UfV3
	 opo03/Dn1lTUHe5SWpC77GI5+3vj4S6E08Us84DlyhteMV2n/GNLKKz3llO3ZNCFst
	 ILzESzN/1go0Q==
Date: Tue, 15 Sep 2026 14:31:38 +0100
From: Harry Yoo <harry@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqlFnuIIECOyaweo@thinkstation>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
 <aqKhgPKzRf0e22s3@gmail.com>
 <aqkIdVhoG2wwVBtb@gmail.com>
 <aqkyT0Ui9h5KWuzn@thinkstation>
 <aqk4NUnq92ftuUuJ@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqk4NUnq92ftuUuJ@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B6B120003
X-Stat-Signature: w7jduoweay1cz3tpkadorurc8abhhzpu
X-Rspam-User: 
X-HE-Tag: 1789479100-286782
X-HE-Meta: U2FsdGVkX18OQQEHqmGZzcrsdC/U/cPxNqFXeeNzPtO1JWcFBRDGCeKIrSdaWJuj3yM0+sWrpZoDU5SGpX/6JkSCpdFMtyjR1vWD0IZ6Da32gmQWaSKNh03+lech8K3nOv42j23JWLLUT9gQKbrqlzXn+C3NPdDeucM+1KKRv8mCzSRAooDxuiBJtUjAAATn5BBUfJVSnF6h0CJZVrY2PXEXej7pjXLj2xElczrDyBDHMQLUQbGzrCJWWbJfj0XSeX8In73IWJMKEfwkddxhgiIkGRKVt1ICEaLT2MoVMEW+a1lWp7nfzKQKbTFuR80xVS9J3ykekzZWxuKSDGZ0RrrMFAx0KawA+lhdf9Wlas1BoFDy/JyyllaUTwvP8KFgdQBFq1zMlFrCLfkFF2uKvGF27dLYah+au54vvZtBp8PLsojPMNgZ3sq+vB6LMoF39hRnqCnJLGPpXA+KlAx2310NTkieQqyxVNXIzjy6/tvnEjKHg0xBEf8ym8FJljow5dX0oyXvW/CGBiTYu6o3beTzPkq2tGSIwjdksUx41MDEy2iT7HTRStKmSOQhIeVpv6ElmWpuczEKhk1say+KzWye37fyk/QEEeskX9yNe7/+RI0GVQZjPiGBwWA1xQNMcg0KL08+gb4GBP1UAIDcYq7K0e2uuRzrOGMJKk/OktbekMXWVu4vXXW4rOnxhB44LRbSESVTn+qVbWTPwPGKngdFkWtQFGiWvLN7Dwn/SCb3lRtaDlTBJzvLVgz/RYC1RD4QPIBW99R4VjslSD+/KhEPj+bWjy98ULHMjz6BuLDlE1LlNua0QycOmx57NP2Gz1QVHFuvFLNhPxolcc5jIJ7zce5A5DT7LXpG4+bnZ44KL1nSL5IxrUoCQYPOmReOdxOUzPu9iyL/VoJH1whEx6a4Tn6F4yIkGjvF4RK95cPEltXHbGI5cf8GQya4ogIkxf3CYUACO12nj+3rsHi
 4XsBDiqa
 xqEPNqNH2WhKikvDgZSj2AZ7gNMf9O5HF0PXYuQwtaF7B0OOnbYzP1K2LjgVdXbmPZQncNAUd/bSo2axz6GRsTxPukuBzTUC3Z0gAQTqdrIK0QIc/hcPne9xDM72nmHeVOtGa9w2GtaqSfbdKit6LehmS2AtKhjRRnmZDH9hA7Ow3sD15x+nzr3EttHX36YRPR5e2/gnJw802n9TYa3+zS15chGO4ZsFkLkkn9nWbFwm2hF8bQikOfmOxYi9i39hKVGL8OqvPyI8Fr7JGNjFmYfAQPiT6SrHdB37Bc3AoEO++qEdl/ALOhfagql5o18x+HxF5kCif87V0cMHtk0dB0yZdDiY9iem53lB/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 05:39:44AM -0700, Breno Leitao wrote:
> Hi Harry,
> 
> Thanks a lot for the feedback.

Hi Breno, no problem!

> On Tue, Sep 15, 2026 at 01:12:54PM +0100, Harry Yoo wrote:
> > On Tue, Sep 15, 2026 at 02:03:48AM -0700, Breno Leitao wrote:
> > > On Thu, Sep 10, 2026 at 06:11:53AM -0700, Breno Leitao wrote:
> > > > So I'd say we have two options:
> > > >
> > > > 1) Keep it similar to unaccepted memory, with 2M granularity.
> > > >    - Pro : Similar mental model as unnacepted memory
> > > >    - Cons: 2 MB might be a bit wasteful
> > > >
> > > > 2) Move to a linked list like the RFC, keeping it outside of the EFI
> > > >    table.
> > > >    - Pro: Reduce the memory granularities to page instead of 2M blocs.
> > > >    - Cons: Another way of passing memory information between kexec
> > > >      kernels.
> > > >
> > > > Any any other option or strong preference?
> > >
> > > Since nobody voiced a strong preference, I will stick with option (1),
> > > the bitmap, for these reasons:
> >
> > Not sure if this was discussed already, but perhaps we need to have
> > a chain of struct linux_efi_poisoned_memory rather than a single
> > bitmap, to easily add support for hot-added memory later?
> 
> Agreed, that's a good point. We could extend linux_efi_poisoned_memory
> with a ->next pointer, so that if we ever add hot-plug support later, we
> can link in another linux_efi_poisoned_memory. 
> 
> That said, I'm not sure hot-plug memory is really relevant here. Hot-plug
> is mostly used in VMs, while this feature is more host-side, so it doesn't
> seem like a great fit. Maybe it would only matter for servers where
> physical memory can be added while running (do those still exist? I
> recall IBM offered that feature at some point, but I'm not sure there are
> real customers for it).

IIRC CXL memory modules can be set up either by firmware or hot-plugged
after boot. Not sure how common the latter case is (or will be) in
practice, though.

> > Also, I wonder if some architectures have a scattered set of pfn
> > ranges so that the span from the start pfn to the end pfn being much
> > larger than the actual physical memory size.
> >
> > If so it might make more sense to have a bitmap for each pfn range.
> 
> Agreed, having a ->next in linux_efi_poisoned_memory is a good idea that
> we can lean on depending on whatever problem comes up down the road.
> 
> Very good point — let's keep this linux_efi_poisoned_memory chain idea in
> mind for whenever we need to expand it.

You mean 1) keeping the structure as-is for now (and expand later with
new EFI table version) or 2) adjusting the structure in the future
revision of this patchset?

-- 
Cheers,
Harry / Hyeonggon

