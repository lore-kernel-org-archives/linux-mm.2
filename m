Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C7EACD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CA26B0098; Thu, 21 May 2026 03:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254146B0099; Thu, 21 May 2026 03:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1909C6B009B; Thu, 21 May 2026 03:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0971C6B0098
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:28:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A98940549
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:28:08 +0000 (UTC)
X-FDA: 84790598256.11.C0C3F8D
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0C7EB1C0004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:28:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=NuYmaioJ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779348487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbyMl+Arkun9SbcO90HXYgu4HO67jHkSgeXx2LBS3m8=;
	b=T+87QEdlqAmbRCr8P7eIF9c+TZXqw/Q8XHGQdUxBKdwdz0V6iyBFtDomnvRfU3YfThF6nM
	uLd4Ufh56HwxiLTezqOSvaJ7DuAKC16IxCLbJ+bMCELpXfuAe4Gvs8lgch3u70jpnOYphj
	F3QadtoQs01iVPQxubjt0uQXvZ8NSew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779348487; a=rsa-sha256;
	cv=none;
	b=GNVrN/5s0XsyrxQdzFx57XMuwxaTIcldv6EvsuX6PbPjP5AUTAp89eVp38WmRDpd8lFAEe
	N48hHoUpU8G6/5W27x7PnFGiH9qsxv0bkTWBUrTo0agTOk7JGqTzHDhelN07vbr9FO7PZV
	x8EnfZNn9M9XvS4XzwKTCBC63n1dKKY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=NuYmaioJ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vbyMl+Arkun9SbcO90HXYgu4HO67jHkSgeXx2LBS3m8=; b=NuYmaioJKno6vrD57wWAFGzu97
	Xpm7PhVYjLakc5/UmsHEMtvegZDmh5IuEbrd2aZWRGQ6zfv01YLNjzWtpbXGbmc2lw5uUh/KgEZfw
	jsWTz3KyJsaRVoL8fdb03VrEb2mDJNQqTZCa6rF5DgaOfjILiaLmq7FOSUOjMaTdud+k2uX5PWgwU
	9MYrVHHuihZI32a7nlDTmEGqFc2fZrVybmeTIZ3NBUXKNLeUqRtXUI97HSuDd7VciapoBadUrGKOO
	HTawXdDsylVaXmsw/+IIPYQ/63Vte5zuwFl1P1h1pdyBbnL9wk1K+ZZZq+XNLrUQHJ+7DRSQceILp
	CHV3rAtw==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPxoy-000000015I7-0W0W;
	Thu, 21 May 2026 07:27:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BD703300446; Thu, 21 May 2026 09:27:54 +0200 (CEST)
Date: Thu, 21 May 2026 09:27:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	bpf@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] sched_ext: Sub-allocator over kernel-claimed BPF
 arena pages
Message-ID: <20260521072754.GF3126523@noisy.programming.kicks-ass.net>
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-8-tj@kernel.org>
 <20260518072042.GP3102624@noisy.programming.kicks-ass.net>
 <agtt2dEjS4Qg7a_P@slm.duckdns.org>
 <DIM6W7GRZK2N.14AH43S1XTFCG@gmail.com>
 <eaeb316b7a45956ed5f335050e6e9538@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaeb316b7a45956ed5f335050e6e9538@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C7EB1C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: 5xmyxoiuzx3pi3crk93dy35qmayw1ce9
X-HE-Tag: 1779348486-100766
X-HE-Meta: U2FsdGVkX1+IsUMIZMV8eGJ4LWMmslBDU/uEF8j4z8g9VScuKJUjKklIqjlAL4l2XttEESeu+aaN+iBr/FpBTIS/PSDQmZhGY1ZFHSWFDLVNYw2CQ6Kcju7oM9V4oVnv1TH31hBfT5b0hghuVKzQ8mSuAXKnkLAO8NjpNgPoPH70r4azKVS9R2pYF5qC5dLbAsp0+yJ/yVcdIn7+jNv0p/NpSIFTarUqWMUAMPieq/rRusBOHqfbZAUBlbHMqAVkvYI3Z2NdYfUPGCjUIW8rPSC6mhr54UCd71d7kGzjLL6UDY1Sj26OAkZ5BrKiPySoYvwnFNKXyL95/pKa9suIqyTLpVzqIsMLm2OlvORXnYsJ0Yym58fU98XzdYz0KmnxjCNEpYinuHa3Q/dCXNue7HvUi3EfVtjpwb7fsy/JGid+WLQWiMgLo3FEy91zGCtPJtQwN6JKAFxyDm6JUcmlMYNg6DcSXM+2B5vDpphq+pgR4Bz5EmHVhAwIfxHMKA0yodQGBqvPNuEA2vr7va2YjgInnD4XbCZM4DHnvcxwg8ghWNM3aJ9TPl67q/7A7MQzFvs/rzZe+7dQB8oHQkGhx2SKNwVHLLnU6wSSC6FHxy6Apdqs4l8vIaMtrG9j0ZI58vGuy+ShGK+aqFWZLJ/6zNJHDuIAulYkjPsRU3QDsk4qoge8koHxneVvg+jKVfVUxFbWs0c60tRGjbea3bvppP8CVrPzcduXbXnNWwAVMOsaDOC9Dqy3nExecwr4Te58yqhWlwwdHqeEToaIJBsZXlZSZzZcHYkPKKU9sUR1yZE4EempenfSlGo8UhwzlhB/GC1oF4TGPBSib7vFxyWnPVqAa+/0dZT+iBdEh0pEJj2lZB1Q8o0Gn4SKVN0yDEGwV6iJU5c1gh9k4y0CLhIdqK9iWrzg2ShBHyYazu+44FBE/MmvivcQXDTpvjf7AKFSMdbkNj896vjP3bwkl/a
 vtzJPgvO
 chxv9Tn8anqDMswrEdC8JQaWGAYpJznpBZRZf4u/CbOwy1Mu7iNimY4olgn1qyF9RPw5c/ffrshsKRa/SZb/JxiAri+iwRvi6hjOvND3hZkyD5hoUMS5Lkp7S2QgW0PvZsNcqtal4p6rvBj/TJ/B67+wRTOuVVIIrYAJAmP4E/VDdB4Fv4vNFzLtR8odj9Zho5AUbfBbhup4to0VXmt9Hu9Ii98P7p4484E24P4WBFttc6MTdsJw8J6mvkF542Fynyk3NtAQw6k3frZzxOCxuG5Q36gfEXzBiKc01WyZWIsPSC808IfWCLnTE3IuoDI+u1Qo3A5b5iprb5fJdyygtCkSkVhIrxMypq/lTVzevCL1NicU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 01:47:32PM -1000, Tejun Heo wrote:
> Hello,
> 
> On Mon, May 18, 2026 at 04:26:11PM -0700, Alexei Starovoitov wrote:
> > Well, this gen_pool based allocator of arena memory is a temporary hack.
> > It's ok for rare allocation like in this at scx init time, but not suitable
> > for active arena management. We don't need to expose it beyond scx.
> 
> I see. Peter, as Alexei is already prototyping a slab-based arena
> allocator, how about keeping the gen_pool layer scx-local for now? Once
> the proper allocator lands, scx can switch to it and the custom piece
> goes away.

OK.

