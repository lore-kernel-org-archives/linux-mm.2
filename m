Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040AC60A2609
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c5Uw7UOq
Received: by kanga.kvack.org (Postfix)
	id 2EC0D6B05B0; Wed, 18 Nov 2026 12:49:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3156B05B1; Wed, 18 Nov 2026 12:49:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201E86B05B2; Wed, 18 Nov 2026 12:49:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F23976B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:49:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6696EA852D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:49:03 +0000 (UTC)
X-FDA: 85448975766.10.18D0C44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C6A1D2000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:49:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c5Uw7UOq;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795024141;
	b=ATk+CcPfePrWex2EC8gJCs8J59iR+emb11b+QoEKXQFIQV24VukCmPgCTOjtaunGlLh7tc
	wCHMAdmf4DRRleeXDe3whc29NNB7r2nzKB0j0MvoA3fBGhQq6ropnu9NvFZqRnmUMphRIg
	d+e4RFnXrSDcVX8qgLJCGf4kHJdjcw8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c5Uw7UOq;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795024141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OL0L40zm4SMuhzGqBwPguFh5DWeS1olwjZ4nxjwgMB4=;
	b=XsctPXn21slKLXJv9iwC04IjUgBgyh9GFNMkcsB7mBg64VhIynKwpCNoEUTHaqJiK101cB
	kD4K6BD5KIS18vLroushnC3tYLSubfrwAPdfqZ3KzSnyEUNBFPPO5b1a01VOIGUTxyyi+E
	xAa9P/xjZJVxqqrjrjqdxjSVBz77cCw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC11B625BE;
	Wed, 18 Nov 2026 17:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EB21F000C5;
	Wed, 18 Nov 2026 17:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795024140;
	bh=OL0L40zm4SMuhzGqBwPguFh5DWeS1olwjZ4nxjwgMB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c5Uw7UOqDiJrKgghaqHu/ylzVTKxzy7JFrgooUKRv6bQbm3bpKqfd/qZ0ieT+/HXr
	 PT/3VNrIj4AsN7TrYWzrP1Q4+0quEbN2MJpT012BjPSoTOrWlwmffpyXIqkSNyORR9
	 7cnEKEu8aKxKEXXN7uM5RtavC8MfSd+N4ZoiT17PEUX0Ly0QiGLL8wK5WNXoScJ4U9
	 bGgqiuV4Wpv8ALSv840EEhUY6OK+fvQs7wwYvtWqAt2aWISNQCcElkm5fImDFiZ6kG
	 A2oz3nS21uKXnoYjNPCd9PqEW4sr0mXUNqvYM5uRhi6kgflRpg8T4VmHd+s5F2+gRr
	 aB2KF3mHEJRUw==
Date: Wed, 18 Nov 2026 17:49:00 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 02/10] kasan, kunit: pin test slabs by an extra
 allocation
Message-ID: <av3kECMDujfI8DnR@thinkpad>
References: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
 <20261116-slub_tiny_rework-v4-2-227a4b3636a5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-slub_tiny_rework-v4-2-227a4b3636a5@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: C6A1D2000B
X-Stat-Signature: esx974yj4z4y7qxcedkwwub4c4898run
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795024141-370217
X-HE-Meta: U2FsdGVkX1/d7M4ESDeCEwWbMipoxSI31t9H2Ds2dzzDo8QNJNikqdqfWx4YVOVJO0js3yqmXFjcA7dcGBl8dTdAoJ9webdQRunt7Gqznq8oc+kSrDE0TbwOu1jK9E+pxr0DMxJYYA9KVsIlR67hXaNmWUSeZWayEYI2IgLGrgYv2XP8qF1PDoBN5It5ilqgEhTped7PWyPVCH25qWxs8YFdAi0dhzEtH25kLMPDmG5jKe4iCa8yG5uregKca/LxAI9Qzm9u+VdUWAUJtrebt4ObiSkq5zzNdB01hBpi4BTIBq93nma6SEWPk5KvWQfyKNRlHKnyU6B9jk7j5E+Xlg0+sml7LvqxH9rLDb5aYFtKFvYFOeh53rKAwhX9XnPlFaO7dkM5vh7PKUXIVGI2Ox5YDjg6ULtaPl4NwjDuHsnnMbGHr0hXBTtql8l/YepNhxabqG+sD1XAtrxO5Fsy6DiIXY/KJM58qjRi9unjjuiI8J4px/9yyt0bZZ6gmqoRWWO3iCHXzk3iUq8+uetRIJjABTWcwWH+F0NvDdXq7o2ecf/a/AQpiIdR0bOQtCuC5llLyp7d8nuhSXV7Mx++7s4J67cfOi8Sot00Nx0WXdRS+bSHrqMqYWyXNTMEJvSozWLJB0gxXRMCju33zDyUQs6eRnPZ7f4HAliUQVzHt3wnFLujF+7RrsvjD3W5mwB+HVkiTKVMZdteH9alkE6CV5BuSBVn6RRGH/W1txqkbdwLNdLAtTxpGf1Lr7Aly+133WSrCP0iCxychKFo4pMwLkheVAY2wratAiK4vvcCFrHrQCcrfyvASAQyZU4YP4lGDeIVUQ1UPzkspNT0Y3DWahsBFK4ovLsth6jlb5YMVDXc2CLIkeNFqxfffyEBzrK54XwRpATKUfp98w0EL7kDL4vaM+GLB+fvtXHGw4QHB+PkRRULlrJtjSEjFw9jvc8LQIH1u8aCMiwo8ZpeDun
 stWBMZYb
 vrjOm4btoGAGv7so+3ydPN5A7DpQ7aPHHrHCMQ+WgVknXEZV3iychBEG5FGRSPjDqlE/SiH/ApuXSxSQ/qvb+wdWgfJazM/8ydPTskJ0QIxWlkppNU5xvqy0JzgHdPPizDMN557iyMXaTr0xww11xNuiRO7Q9RpjrAGMl7bFff6baFNLSkJx4sw5wN/H5JVJjOCFp7XzwUccTiWM7ijKTK61gFFf+OK/5PSH5dn9r3aqvlpuCouG0grieZRzGPqZv0VsV/MnyOeTI+1Az2aJDRHhLGX/3RuFG/yCBXP9YWl1IdLksNHIfopQNjqAKXpLx7Fz/Z7ZCxmUGPrdiU3izcdV8xx9jQq/onb5vyMM8rpEri8jKWvJ9QIskyv638pVQ7XMILDZQK2Z4hBRIHvJsnEBnCZFgKAu+sqGc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:47:10AM +0100, Vlastimil Babka (SUSE) wrote:
> The tests kmem_cache_double_free() and kmem_cache_rcu_reuse() create a
> scenario where a slab becomes empty, but rely on the implementation not
> immediately freeing it.
> 
> This subtly relies on non-zero s->min_partial. It currently compile-time
> defaults to a non-zero value, but in theory a sysfs write racing with
> the kunit test could change it. More importantly, the upcoming
> CONFIG_SLUB_TINY changes will make it possible to run the kunit tests
> with s->min_partial being a compile-time zero, which means the tests can
> cause a NULL pointer dereference, or fail, respectively, as flagged by
> sashiko [1].
> 
> To prevent this in a robust way, add an extra object allocation to the
> tests, that will prevent the slab being freed. Use migrate_disable() to
> prevent migration to a different NUMA node, which would place the
> allocation to a different slab. kmem_cache_rcu_reuse() already uses
> that.
> 
> [1] https://sashiko.dev/#/patchset/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org?part=8
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Acked-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

