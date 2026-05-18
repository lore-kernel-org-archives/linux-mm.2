Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 230D3CD4F48
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 07:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820486B0093; Mon, 18 May 2026 03:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0766B0096; Mon, 18 May 2026 03:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF8B6B0098; Mon, 18 May 2026 03:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 566B36B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:20:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 062DA1C1C72
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:20:55 +0000 (UTC)
X-FDA: 84779693670.09.73F7340
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf14.hostedemail.com (Postfix) with ESMTP id 73986100009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:20:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=bcr6ZW+6;
	spf=none (imf14.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779088853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oymZOlMj6aZm2jiVzI4Upf5k8ifuN/pveVWUu4TydLQ=;
	b=GEbp9S8H9Y/cvwdLijuyAMi7Q5/OgFoC4mIYN7OtmnBt5uKS4HE0YC41Cu2m+bHUfxVl13
	ufPJCQ2K2ZXphUnLde7h/HHu1C/peLvIsa4oaX5v+4gzSKCSxvg+K3fuvPDp3iX0zYM2Jg
	j7kqmz+d7llefsJScKQctE9wBHQtvSE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=bcr6ZW+6;
	spf=none (imf14.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779088853; a=rsa-sha256;
	cv=none;
	b=R8sQHT0a9nMEGBPaKnULe6GgI5szpNwJoscrK25s5ZOhfrMBdNHhw+Q6PV89SJOqtPWbuB
	wdKBq6bQoTZN8NGBjbTTs0tCIkvXFNWKBPr8oCJRfh/7VG81RRBr2PbWxiW2TCdHwUbnGh
	+jmw8mTaggm+Ghb+aD8JvOmM640W1wI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oymZOlMj6aZm2jiVzI4Upf5k8ifuN/pveVWUu4TydLQ=; b=bcr6ZW+6uMYVPPdYnu1n5lZvLE
	SGn2E8l0rK+cjQ+R6Sj5HL59towTXB6p12v2CEvZTRYmeGs2QkOf4gLowmIrvuI3JiuVpU2DOQQiu
	ndfkYABp9AVnYFrMPoKMGIujfaB+EX05Vg83yfMS2mbf0dy0/Ghhaty6xMyz/eRsGISxsZdQitFOR
	kBmGZPmASGz9S7TSlR7rOPtuNlSAhUKb6vCKWR0NYuqbdYs6gBQeYkthJrz5ORo1qBuec7q+BFWEp
	Y0NW5xhU2pyfHfK2jwpm1QeszCSqZfOkFSFOnoR0fhrifOkzGQX8T7FNYmekXVm65m4u8QGeakwRx
	sx+RmmBA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOsHL-0000000A9JE-24Bl;
	Mon, 18 May 2026 07:20:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BBF7B300329; Mon, 18 May 2026 09:20:42 +0200 (CEST)
Date: Mon, 18 May 2026 09:20:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
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
Message-ID: <20260518072042.GP3102624@noisy.programming.kicks-ass.net>
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-8-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517211232.1670594-8-tj@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 73986100009
X-Rspam-User: 
X-Stat-Signature: f3cdth6qdjiay3578n18rukw789udzci
X-HE-Tag: 1779088852-238745
X-HE-Meta: U2FsdGVkX1/x6OSNPgPHQ9JW+uTo63G3mDzyPUV3MVoJf+Fq/U6i0V9Qq1F/Nhc/I+vBQhYojkxMe5leP9/Ybm9IbQV4+QcDXYN3fOiw/LrzkX7LmbykNbpD7y5QfNNF1GgFYjJUhtaiB2n/1hXKTHghmaHoBM473h8QDqrtY4F75MJOvrTg4HoQuLIyataOyx6REwyvu64xakVKRXwxQQwfUrJyFkd2nCXTkPFIFozFRqMWdk22TZo4bcZej860atRzRgHvcAfEcjKbtdh35njFtdHmMwMKahEYBqsp2JAqUqEJZVeKFvzY0rJjaaWEA4324zzPaffIF8fVKuwNB02LNuTMvh1Msez3NvQJkR6Zk4b2kgyGJlNMuVBEGP5lkp2T38cwDQ9yFXt9whCBuCmQdo7HxoxPGAC8Iijn0qquEhI7QgJXeh7W2shF3trXhojVLEDygdS5tblRwbpACnkj5E+n7fihRVb3gFvlEciemvTtCboqOiDd4l8ciORk32MFqFGlvXvmc3Vqa7DuQcTV0k0JDlPMwJmZno6zEoZHoZ0JByA0uiKgmwfdUlbYtcbQRV/AbKZSpFwfmz/UuLwJRzJdVoBYo7M3ktCIVL3gZ3KvJt3OLvs8QcTkFU4yddrVjoUPrI8lPfL+cm/WCyOCOVhmwCg1X1wfHcgm/K2LefFvuIi/kMeetbPlS6KzqgU961tRP2KPeZWs6oph6lbJ3NzHxqjxIOpUrBir2G63fNNlXtHFT0qyxBqO6MOvHWWlIkhyAtg3Xtk/4fT7JjTBDjPgwGCUHf9230wDqxpwQ05RuIyPB10/JPT2OrWKtrnAPtnnycMafDv2C2v2Q17DUSGoEMOdnax/ZAoPnmPWBwL/CgqJGWrjgylt6d1JkVLXgJxNlKhO54TRXJxlCz9vzz4vopU/4VUpkJIuLEElJZQcWBQsiqgOf2MgnrcoTmPPrH/zzWUsD9isqDp
 jvZWf72+
 PmODkPzmULrKYLNBcDFOjmd4rBUhSLHzqTzGhH4+R4u2knvDxzQ7cdyBJHnmQoOhFlC9CQakqu1DZgTxm/PJ6SLAlLQfOkLF0yWpBSZkTJOTBZGAVc+/AWhbPhmKTGwja6v22l77utWzzPvN3+egjZLx1irLa/Xz08iXI4WptDuvNxW2lERDLHlJQdwqIo+5JD+R98s/65kL0zWXpRVw9bKVaH5gAdleq6TPRFUuOJK6z+ISdfQlvGvD+kD96bjn0ydP7IKs80SXM5TM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 11:12:31AM -1000, Tejun Heo wrote:
> Build a per-scheduler sub-allocator on top of pages claimed from the BPF
> arena registered in the previous patch. Subsequent kernel-managed
> arena-resident structures (e.g. per-CPU set_cmask cmask) carve their storage
> from this pool.
> 
> scx_arena_pool_init() creates a gen_pool. scx_arena_alloc() returns the
> kernel VA. On exhaustion, the pool grows by claiming more pages via
> bpf_arena_alloc_pages_sleepable(). Chunks are added at the kernel-side
> mapping address; callers translate to the BPF-arena form themselves if
> needed.
> 
> Allocations sleep (GFP_KERNEL) - they may grow the pool through vzalloc and
> arena page allocation. All current consumers run from the enable path (after
> ops.init() and the kernel-side arena auto-discovery, before validate_ops()),
> where sleeping is fine.
> 
> scx_arena_pool_destroy() walks each chunk, returns outstanding ranges to the
> gen_pool with gen_pool_free() and then calls gen_pool_destroy(). The
> underlying arena pages are released when the arena map itself is torn down,
> so the pool destroy doesn't free them explicitly.

Should this really be part of scx rather than be part of the bpf-arena
thing proper?

