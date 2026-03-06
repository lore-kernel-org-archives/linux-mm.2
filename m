Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D781F0182C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159786B0005; Fri,  6 Mar 2026 06:48:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137846B0089; Fri,  6 Mar 2026 06:48:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043A16B008A; Fri,  6 Mar 2026 06:48:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA8736B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:48:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9539E1A052B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:48:03 +0000 (UTC)
X-FDA: 84515464446.11.1BAB4A2
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id D46541C0008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:48:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=EoYBbDmK
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772797682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Q1sENRTqUjIhGZLXP/WQo59Q+Ah+AXrTPRNuwNNsmU=;
	b=oGpafD0NJ2NqzwyZihFZFdhgby0xqYfWpAO6aiNA4Xgp+z6QTotN5bqTAQstChstsMS0RM
	2M6Lntl1nH+yiK+6E6LQuSYedPR1EnHC7OgqJ2DDQyOVnTFOJ4XoCrDhe5uZ34tih14FMi
	995LpmnQ+6X2moXNKs1mpWkd33GTqkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772797682; a=rsa-sha256;
	cv=none;
	b=in8B9JuiPWpH5lN1WnvxrIRdsaSF31GMGPehPK6BW7x141UZnmvee5DBo6XgWV5mOeTJXX
	Pu4yaUKLkvdhAAr4Xnoi13RM5t6lVzDsK6cKbdyWqyRPZOjfcmC+ElRokjs3TzMCMkdHHn
	OjGR2vcmGTW3nU6Y6cwM4aO/gvDVOEI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=EoYBbDmK;
	spf=none (imf21.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=9Q1sENRTqUjIhGZLXP/WQo59Q+Ah+AXrTPRNuwNNsmU=; b=EoYBbDmKpVh+CjgoUIt8Rpho2l
	4sGdjLo/aGg1MHTH6/SmjJhxkRewYGq3Dl3/cXpGpkNZD1YxLOCaYEIxHahM1P9urnzKFJf+exqkr
	bhBl2USUdXusi2Bd9XCwwskxouubnUxoNBPAJcsaNY9AEIXt4f5oYF83K0aSrabU5Yf1/7pP4wmCI
	I9L8YyrdxfCpJny4znGpkhhJtkMdAiuSN9gCQ+djogo/jEEp64NXyL7fpVj4Qs1BzE8PyELP1tvBy
	FDh3F6te+9zVOVPep/sP5jlrDusNYXT1U1PXh1nAuxVsktDssOLT0ZZw8kwhu7Uh+RWAZ+uWuQ0qX
	wO2OkXDA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyTen-00HTjc-2w; Fri, 06 Mar 2026 11:47:49 +0000
Date: Fri, 6 Mar 2026 03:47:43 -0800
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
	riel@surriel.com, SeongJae Park <sj@kernel.org>, kernel-team@meta.com
Subject: Re: [PATCH v6 1/4] kho: add size parameter to kho_add_subtree()
Message-ID: <aaq9J_rJXNiWzlXY@gmail.com>
References: <20260127-kho-v6-0-56f9396681c2@debian.org>
 <20260127-kho-v6-1-56f9396681c2@debian.org>
 <2vxzjywszk9w.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2vxzjywszk9w.fsf@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: 7qziu84gyiwrumnk4ysk3h5ay6341xk5
X-Rspam-User: 
X-Rspamd-Queue-Id: D46541C0008
X-Rspamd-Server: rspam12
X-HE-Tag: 1772797681-908261
X-HE-Meta: U2FsdGVkX18uumdo5cXwkXxGKFEHPi5D5FSr1j3n4JNXPkXRbVsmjj+o/9hgmre+xAVCU7ozBtnYx97C9ZhroBKtTCHN05wNKbMvMxWgihrkEKfG3fOQsdEblCNg8OCcodNYrI+eUwxC7cp+c6oc1I5+BWPifnA5bHVHtEZZCgMfthZaniu4imigW5iA0CTD1X06O9nUZsvKUsztOrGE0DW/dRxAIJuTmThdnnHlWLw97yipd5Tq8LjYuX1k9FIRaXCDvSIKpbE5h+FwqXmHPl/rpH0KsaSeqZ9kkcf5XzFdlB/8JZ+c8b52Mz0OtRioBTOF4PwDbJ2F2YUOTGW8lug16qydHH11PnqMcyoC02p8tp/bOnBnpQck9D3kG1bSV7uYGzQxLzEMIK7WtppSMEzun6ceMbzD1MU3ir2rgvC/u/dsuGydPeGHZ/1hYVef16SqGR2Ck+IA8n5dRHmmI7rQyRFoRAiH8KsERXQuub9xxIP2N+bDPNWrVK7MLSnOq2rIBUsx2HXo5DKzGgDefu9uz7e1Rhj2U7IDxyxOleYgCDBZBfFjEbfDVEIX10gVsR7TSCC/+e0uTCSNoCj5iQsEUKXbjaWnacYc1UJLNmaKaEmyVTrlM/BYd58PRqZVixMVuhxGxONtW1c4yDANuUyu59V2sYz2FZb/taP2ZDz5NKEsAVMRaHAmgJAbHdEEYXrCied+ThzJ0fAm3zwJVZ8IQI2ugVPOLriehe/RIqDxBq8JTPdKoiZqjrbwEKjlqSHjraz4s66VKTUdWO5QcPvTZ5/UkFEUCcf8Sj8Anfx/HuG5XeIWcgRWbAum8Vi5Wh3uQioV6yr3sNkjO1DOnSUtrXI+imUk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pratyush,

Apologies for the delayed response — I was on vacation and just got back.

On Wed, Feb 04, 2026 at 02:54:35PM +0100, Pratyush Yadav wrote:
> Hi Breno,
>
> On Tue, Jan 27 2026, Breno Leitao wrote:
>
> > kho_add_subtree() assumes the fdt argument is always an FDT and calls
> > fdt_totalsize() on it in the debugfs code path. This assumption will
> > break if a caller passes arbitrary data instead of an FDT.
> >
> > When CONFIG_KEXEC_HANDOVER_DEBUGFS is enabled, kho_debugfs_fdt_add()
> > calls __kho_debugfs_fdt_add(), which executes:
> >
> >     f->wrapper.size = fdt_totalsize(fdt);
> >
> > Fix this by adding an explicit size parameter to kho_add_subtree() so
> > callers specify the blob size. This allows subtrees to contain
> > arbitrary data formats, not just FDTs. Update all callers:
> >
> >   - memblock.c: use fdt_totalsize(fdt)
> >   - luo_core.c: use fdt_totalsize(fdt_out)
> >   - test_kho.c: use fdt_totalsize()
> >   - kexec_handover.c (root fdt): use fdt_totalsize(kho_out.fdt)
> >
> > Also update kho_in_debugfs_init() to compute sizes using fdt_totalsize()
> > for the root and sub-FDTs it processes, since these are known to be
> > actual FDT blobs.
>
> No, this doesn't seem right. The "fdt" field that kho_in_debugfs_init()
> uses is the same "fdt" field where we put our non-FDT blobs. So I don't
> see how these can be known to be actual FDTs. All this happened to work
> because so far all users were FDT, but I bet it will break if you use
> your blob here. Perhaps give it a try and see if I am understanding this
> correctly?
>
> To be honest, I didn't think of this when I suggested you use the size
> parameter. We have lost the size information, and it is hard for
> kho_in_debugfs_init() to find out since it has no idea what the
> underlying format is.
>
> One option is to have it in the KHO FDT, but I am not sure that is a
> good idea. Adding to ABI for debug feature sounds odd (not that I am
> completely against it, it just feels off).
>
> Another would be to give users a hook to populate the blobs when they
> call kho_retrieve_subtree(), so they can figure out how large the blob
> needs to be. This has another benefit: once we move away from FDT, it
> makes little sense to dump the blob since userspace won't have a way to
> parse it. Even with FDT, userspace still can't parse everything. For
> example, say the FDT has a reference to a struct kho_vmalloc. You'd get
> a pointer to the head of the list, but you would have no way of knowing
> what is inside the vmalloc buffer. This has the downside of not being
> able to show anything if the subsystem never calls
> kho_retrieve_subtree().
>
> Unfortunately I don't have much time this week to dive deeper into this.
> These are only things off the top of my head and I haven't thought too
> deeply, so please don't take them as strong suggestions. It would be
> great if you can think a bit more about the problem and come up with a
> recommendation?
>
> I will try to get back to this series in the next 1-2 weeks and
> hopefully find some way to make progress.
>
> I skimmed the rest of the patches and they all LGTM at a high level.

I went with storing the size in the KHO FDT. The addition is small — a
"blob-size" u64 property per subnode — and I think it's warranted: this is
intrinsic metadata about the blob rather than a purely debug-specific artifact.

It also rounds out the API nicely. I extended kho_retrieve_subtree() with an
optional size_t *size output parameter so callers can retrieve the blob size
without needing to understand the underlying format.

I'll send a new version soon. That said, the patchset has been growing
considerably, so if necessary I can defer reworking this infrastructure to
follow-up patches and get the kexec-metadata patches later.

Thanks for the review,
--breno

