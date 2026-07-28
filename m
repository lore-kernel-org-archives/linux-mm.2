Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6F4AC54F56
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22526B0093; Tue, 28 Jul 2026 15:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1586B0096; Tue, 28 Jul 2026 15:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9AC36B009E; Tue, 28 Jul 2026 15:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2E86B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:26:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10A07C0453
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:26:29 +0000 (UTC)
X-FDA: 85039166898.18.31035AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 395824000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:26:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wk+Dy2Ld;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9zPErIOkKOvWU4JJG+dspgkrLmx8WSjgAIhjf1cHOk=;
	b=U5KoHu1IScXvlTX3d/CEfdS1JyDU+QH83kWyLNo1acoZZoIPJoJEMczGYFSkR7ZNU0AVtw
	omm4wsbwQ3u8cvL1WqHSElDeS+zcawr74Ci3LdkJcWM66FxFqqp1hA8/4C5apVGxXxLRP4
	fvVGuPtKVf7odPWqvb2aHUqLYBQ1NFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266787;
	b=zVHosFJFh01ccAyc1gg3nReA+RWDkCH4JezBEN7Po6RPrjskZsOFOoVH56qcRbbnE5oNMN
	DELW7Gb4HDMg3wJXrJuks+RmqZ4tlISZNvN+7UM+caFFb5CIFSJPCjjFjKdI8vjohb0DXr
	WLpcpNqmVMzQ0Lb4aIIcP1ejC+VGjms=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wk+Dy2Ld;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F73C4404A;
	Tue, 28 Jul 2026 19:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FCD1F000E9;
	Tue, 28 Jul 2026 19:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785266786;
	bh=B9zPErIOkKOvWU4JJG+dspgkrLmx8WSjgAIhjf1cHOk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Wk+Dy2LdjSS++FUG8ogDF9T7pT+EAMTNcB05WeR4hXNaXglCVPisWY+LtMICE7Ccn
	 wg89k4Kvgy+wj1Z+MYeBAhF/fpDBT5QBmapIlx+G9nPNFi+PtoCZcgFGdFDnLbAXt0
	 xB9tb7u8wQORuyWEL/5BRGQ2JQ2k9CqZ2ZVyyUj8/EZCr1Qepptpcml/7TGdY1D8nm
	 GSTIcvePc1fP69qF+FthXNV/zsYPQIg7psEdREpgXn9BbFwQhb7/ZitQjH5BdGIeL5
	 10/HbxBCKZnA9MQ0tzrL6PXNOGh1zI0y/tMqhlx3SWm/HNYuS05o09qLSvFYiNKTIz
	 dUsn/WiERIxzg==
Message-ID: <2c19247e-bee6-45f4-a353-2fcc60db26e6@kernel.org>
Date: Tue, 28 Jul 2026 21:26:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] mm: distinguish PTE table storage from PTE
 values
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260727164715.2866609-1-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 395824000D
X-Stat-Signature: 5jsgug8j4d1e4o1jifaeo5rs1768io6a
X-HE-Tag: 1785266787-331398
X-HE-Meta: U2FsdGVkX1+AtY6zV/W1L/98ZPHk+61pMw+WZgqqHes/0SqeiHiC28LV6PoZlFxU70uG0Y7tP36xdeNemnuPyiVEIthIoXeJaBaGm8cAc3KO6W3VZ6pE5cxYhupspsn1QJmq/Dn/Uz32+dsFn5+Fkk5yrvbKXfodO79JiRyKbnfagbJxpOZAxqcUrgBNcUHjzDd2Ebq+PLYWvKpj6atPq+tR6IyczKbWHtyHTGJHa1DPU2JZOTGe3W0T0JwAaBmHiolm1PcrSj8zmqA1bRTx1Vuas2UIVZckghCA6Po0UD4i6+sFGRZ1v4a0jbgzOCD7lmeF1rSn+Q1j9kOedEIg+jsBfQhCB/LgfiIbrmpfz6oxJlZG74F5cxmTxG34U4d1/o3HcnbwdvRf+npVbJnGCjTmKWBfBgaG49ohL7tBLw+BTNuSDtsdJoFNWqnypZh1ItlZ123wGIEuoC6MzHyw6j15v3CsHNy0eVF9nEQ3ZxcRCO1IEiidnl1pAZDdBUgM/+9uJYXdfzyfpf3DOGgadjwZjjaBpkqfvjgjf3FGFHNSjeNnGsu+YpQJ7Mvc4kH53xAdSO9ePc/o7LTg5iSgjl9fIlIPW4lDp3DIacAvcM4OjApDhL0chsuySJy0MvhfK++aLEpiuJnYJDZVHkrbSoWPvOo9Aca+w74MHZYiwtE0g9FnUcfQ0NiVIXNYJypqjPxQq4f3gZnAiY9gUw+yGe2E62ZoUbFTxNa391UobixIKJ4gcpW8C8tI550bJS71OMzTc2Dr797SaKyqYPPI0UsY5uZVCqH4xS1gx1765y7vVqck5LkCb1i3L0XVyy1n3RjuJSR0qKndKRzqQm5nndFs39lGpT/0FdBIbh9Th/MHjELYVBrBugXP3AH/ixzjPg9zEBo55GoDITyt5GsqVzsWvCrFR7d3rZfsLvZTN7rjCfKbU5O8pyOiDd6Vx5LzNPBsJkILPp1IM1IZDy0
 s5pnzsjf
 M6paDq3Z/HgsbOoxffhe9zsxBlmjWkJpzX6GaIbITmslycHH/Xmkb4rtLZmo++fWYkLC1U4rRE0X2nA2eZeBh1SKcAXIE2qd95dQRQYtrbldu1afVy1snHab797KuNR+4OoeuKX7o1SsvNnuyYUu8xCOl/kB7lFej+XpRxUnImIR2ZA+ZrfDX7V+UkOfmRadNBg89mzTJJQgvkZ4l3a8Gh/zTMPxfDRVNOdmg+dff5fEjns6p7qa57ybSPFAhFMOnJFHH8kwmYAquSKqoy2HJ+PJPrhWKJJJX/b0RglkNG7nRfCEquU6yYJpz5xJwHWPzvSbKVh1olEr/0fI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 18:46, Muhammad Usama Anjum wrote:
> Hi,
> 
> pte_t currently describes both a logical PTE value and an element stored in
> a PTE table. Consequently, pte_t * can point either to a standalone value,
> often a stack copy, or to a PTE-table slot. The compiler cannot distinguish
> these cases. A value pointer can therefore be passed to an interface that
> expects table storage, while table storage can be read by direct
> dereference instead of the architecture accessor.
> 
> This series begins a staged conversion at the PTE level. It introduces
> hw_pte_t as the element type for PTE-table storage and converts generic MM
> to use hw_pte_t *. Logical PTE values remain pte_t. Interfaces that
> intentionally return a value through pte_t *, such as install_pte, remain
> value interfaces; the relevant parameters are named ptentp to make that
> distinction explicit.
> 
> The generic definition aliases hw_pte_t to pte_t, so this series preserves
> the representation and behaviour of every architecture. ptep_get() keeps
> its existing READ_ONCE() semantics and converts the stored element through
> __pte_from_hw(). An architecture can later define a distinct hw_pte_t and
> convert its PTE interfaces to make the distinction compiler-enforced.
> Architecture PTE implementations and most architecture code are
> deliberately left for those later opt-in conversions.
> 
> Here, hw_pte_t identifies PTE-table storage rather than table lifetime:
> complete PTE tables use hw_pte_t whether or not they are currently linked
> into a page-table hierarchy, while standalone copied values use pte_t. The
> distinction between complete but unlinked tables and hardware-reachable
> tables was raised during discussion and remains an important point for
> review.
> 
> PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
> converted in later series after the PTE boundary is agreed, avoiding the
> PMD-specific cases that made an all-level conversion difficult to review.
> 
> Most mechanical pointer conversions were generated with the Coccinelle
> script included below, then audited and fixed by hand.
> 
> This series does not add a second ptep_get_once() accessor and does not
> remove or replace STRICT_MM_TYPECHECKS.

Do you have a pointer at the arm64 part, so people can get a feeling for how an
actual hw_pte_t implementation can look like.

-- 
Cheers,

David

