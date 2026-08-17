Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16858C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3036B05B4; Mon, 17 Aug 2026 06:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A6B6B0904; Mon, 17 Aug 2026 06:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190E06B0905; Mon, 17 Aug 2026 06:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F230A6B05B4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:05:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DB711A072C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:05:59 +0000 (UTC)
X-FDA: 85110330438.02.6D9A3DF
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC49A40005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:05:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LqTq8m4+;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786961158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dye5PQgJQveh6g84yI4yecG6KdWtAVDgLH/RuzA06Jo=;
	b=2UUPHCna1beRqDDyrU5XnZ4E46HChxWMuNIl+y7D6JLm2AS+79KTmxuyQdhD+NLcKXaj4Z
	raTbqFMpnANxD7HVZW1yGUyJwJeZ4SMQgqgkkCd9spGosVULElts+OT+nK+iVO6ILsZuNp
	Kfxp0gN9L22wPZfpFMB6IJQRgfw4BrA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LqTq8m4+;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786961158;
	b=PXeNzOQu68IfffbzDJZBUTT2Ai1sVaKwwKICsif0dc+M7EEz8IJaAniOXUp0FA4yK8hXDM
	e9oJwlkORskCAlyi7o5PjvVpjV/uiyISQFfVmtumCN+ptlyBG2AsvYJfCBuBs/0qsilVm8
	pugsVbWSLrHIBiPq880Nf5JoR6uL0dY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=Dye5PQgJQveh6g84yI4yecG6KdWtAVDgLH/RuzA06Jo=; b=LqTq8m4+1H0oWNXS7MJfBcKDLo
	0a5bvUFlqlNr/eoi9oGfRl2iDIWwJSpw20oy+ZKe3sWMju0NNtbALRHyShKeaBv69AOdot7Xlwkah
	H844ntbQgO1DocHd4Qlh2S/mgovYoSmFkqO8xPfzcEWsGYvZZJSWB/Zrz+dCqs2KbM+ymse7jOlOa
	ed1uSBr6eEs3zfXQsz+1K1k8OeM4J2HrqTdYK71cvjTEh1P3yRBBdTFGmT1N7VtxUHpozsDX1xmgO
	3XL07acgUG8gFZTvTkX6jqkSb42yD1snGZnAhtmm+nWOd0HlPKWXN4R+Fc57/34nGjMcJOoTvBPgj
	+QyiLqpw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wvuDd-0089GC-3A;
	Mon, 17 Aug 2026 10:05:26 +0000
Date: Mon, 17 Aug 2026 03:05:18 -0700
From: Breno Leitao <leitao@debian.org>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 3/3] mm: fail the fault on a malformed swap entry
 instead of retrying it
Message-ID: <aoLbSjScVhT8U8X2@gmail.com>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
 <20260813-swap-v2-3-4a625ccabdae@debian.org>
 <CAGsJ_4y7kQmZpfPQo8n5wRD2syHRj21XPvi6+OjVm_cXbfDLQQ@mail.gmail.com>
 <aoLTWeyz_GldJwe4@gmail.com>
 <CAGsJ_4y77jHiYNawJcKTS+HWL2_Fck2rDFN+AWV+8bHx42qdWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4y77jHiYNawJcKTS+HWL2_Fck2rDFN+AWV+8bHx42qdWA@mail.gmail.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: EC49A40005
X-Stat-Signature: zw3se5qu8cbdp4bfky9na8bds1spuax1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786961157-551845
X-HE-Meta: U2FsdGVkX18OfI72NWtn33/OXC6JYLg+InQZWuk6U4kKn40N/iUrJqcmvZQBaw0EbB9MDzTN1NBdS8zn9ppHgS9xsh8dWW+5KmlgtjSUp3T9DJgYgDD+ZPnR4WR7umFhdDnpKyjolCzMHhN1JDivBKsrsM0lDj/2kLCfJz9gpmme4b3mweFDAw2/blosodZyCaQ3MFWo4LSYN2ujYxOFYLS/rUNPwr0N7XzhrNw//FqL8aZLdJOHnJn5gQR7/CjtJc3GJtxUhe6qYUNBtlbvgGDOKWcs7GgkTaq3hd/j4oy3cYtq3GxV1pdJHc0xdqGw0YbJthEzCTIZ+7gcI0h+mBUjmY09TWcUicdeeTXWBsbFdem6V0wjZGSVveY2qMEyZ2kv8k4iK+vZioEu3dsjDmsZpXx5cZDGHUsgGyopZ3Vd7ACNS2duG7Jr46xCp4fOodjgOfS/HouudpHJO/ZdRsAKcH4/Gn8j5KKde2N7M4Tlc8MBGHeLIXWRt8o+c/fKvUgBwnWU1DwunFS2O+V71zNMAqQXgjjv8KLTAX4Rwwl04HoQUo+AbAEf7D+F+EUaa9t98nVahvMb8BzIRR+X+WsDV/BgZSqWVLFOPHP4oSitzKILIa8F2ycWY+Nqtp9axO2ZS4FXSeBHr9sGoWhVAjl1lIFIrjpu9AnEPI0hcFLH8JuZYPZsIZwoLU6fqU2ZfhVm+63YNT5/Lale9EqETkSCrUbDJWO06b5s7BmzcMyo0GAPN5g5Tg6lcVUhsf20kz64CYrKLj9i1upU6JUIRVgeF1CNP0Qh+ebtKlNbUNOCDln0kmuCHCyBY6n+r5YRhKj7eutXPTwVvKEPJcDCs+xYYG8jTobVUUyV/PWTlEaQ1pSebleMsPJKT2izHF6VLEE1g9JHDCcoYO4dpa6Vu4PKp11qlmaVmtc+yCYUYokHioMYw8RzmUEVhz7nAMo3+KTkEtdpPm/X/x/4YNd
 EOT3bv2c
 7iCF2fqsNxEd4uGKovm6bgHXeuSWwXWY//cBtot6DmjpPR0O4FbT9z2tFOpCKNjNdo5maaElP4VCRPYGzVuJ1pnmRJMhPF5VdM3KVnW7sRUzEIT8tJ8dydbTqkgH68/0/ziy83A4slbQ9pDofexGwq0m85IL362+Y5wiBofNfLTm06iCX2ZXiDhpyrnY3RrBsLz4morTMSIpjRZ5EaE2aL1OZs/SrCuI68TFVPdpT57D3l/briOZbEl9yhXabaE+TwD3uxXE+0zkxjVQzsnxDZ+qFIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 05:40:59PM +0800, Barry Song wrote:
> > > Since you now return VM_FAULT_SIGBUS, the page fault should no
> > > longer retry repeatedly. Do we still need patch 1/3, which adds the
> > > rate-limited printk?
> >
> > Yes, I still think we need it, for a few reasons:
> >
> > 1) A different bug could just as easily trigger the same message
> >    flood again.
> > 2) I don't see a case where flooding the log with this message
> >    would help. If it keeps firing, something else is already
> >    broken, and the repeated message itself adds nothing useful.
> > 3) From a monitoring perspective, I'd guess 95% of our log
> >    messages should be rate limited anyway, and this one would fall into
> >    this category.
> >
> > You think this one shouldn't be ratelimited?
> 
> I’m fine with rate limiting. I’m just curious: now that you return
> `SIGBUS`, the PF won’t retry, so you shouldn’t get flooded with
> printk messages, right?

Oh, do_swap_page() is only one of the get_swap_device() call sites, and
I am only returning SIGBUS from do_swap_page(). The other callers are
unchanged, and whether any of them can loop on the same entry and flood
needs a closer look.

> Or are there still cases where returning SIGBUS won’t prevent the
> printk flooding?

For the path I hit, do_swap_page(), SIGBUS does prevent the flood.
I cannot say the same for the other callers yet.

That is also why I would like to keep patch 1 standing on its own: it is
a cheap backstop no matter which caller is spinning, and it can go to
stable independently of patches 2 and 3.

Thanks for the solid questions,
--breno

