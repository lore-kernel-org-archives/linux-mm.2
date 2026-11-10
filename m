Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D309606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WP2CyVeP
Received: by kanga.kvack.org (Postfix)
	id 8A80E6B05B4; Tue, 10 Nov 2026 18:12:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F036B05B3; Tue, 10 Nov 2026 18:12:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79AC16B05B6; Tue, 10 Nov 2026 18:12:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE5B6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:12:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADE3DA01B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:08 +0000 (UTC)
X-FDA: 85420759536.27.7A733A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 058EDC0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:12:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WP2CyVeP;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794352327;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dmwM9ZNMZCevKin42EoLUkke5hF2+c7hxqZAa8FFmHI=;
	b=Lo8K0JP/mbMdXv3nKLyEnqAtfCB/uQOPm1oa2sOeQvYnZpn5VBX032QQNI2m/M0RISjKP4
	Sb/qWef52GArgvR/RQvAvinxuoLInVBw6ccCWfvJNx0Qqw0lN3OjFtfOcs1bdp/btUaB/H
	FbVONTzwA5KNn4IY1LJxPFPRF1dVCqM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794352327;
	b=S9OxyzBD+AMVsQ46N60j0XkVFSuJEBgn9mi3tsOSuc2JpmFBOtd0aIwUsjpjylmYx7am6g
	vH40ynrP9bXoN2WKBM2kxvqRC/9Q2YjxH0VPFJ2iBjRlicJXA/6qCxB+CRAYoph1INZ7MA
	tQSsR0cJew0iM47O1OYojLEhxR992QA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WP2CyVeP;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DF3540286;
	Tue, 10 Nov 2026 23:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175171F0093C;
	Tue, 10 Nov 2026 23:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794352325;
	bh=dmwM9ZNMZCevKin42EoLUkke5hF2+c7hxqZAa8FFmHI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WP2CyVePZejoyDt+aaiwdKF1IRW45jPwaNBNMr4NUgEhxESG3gDfp+1X5T8fvoKtb
	 i0cllM/T9G3YoR98QixbcQH2oPUeEU69vCMtkhvP98lgRKOF1bkp93sQfHbAOgyXlB
	 FGumoPm4/gID3ZS4F3/lCYJqZ/iiZbzk/ehEUODX1nWVaIbwq3xEt3L42J7Nmr30DY
	 zIlNeplnG9lr37pkEpb8LoYHvSxTnHvoUEbT3J4LJowBV2PkHb27Vsu/uiQZvy27wk
	 zol5GTFB/y+oMKjtuTa1CvsIFkujPDxPkNN+s0j93IuOyS1oHTX0oSoEEPMcQx+3hj
	 CjFUnek7y13wA==
Message-ID: <sashiko-outbox-207856@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 01/25] iommu/dma: Introduce CONFIG_PISA and
 metadata table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Christoph
 Hellwig" <hch@lst.de>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "David S .
 Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Matthew
 Wilcox" <willy@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Willem
 de Bruijn" <willemb@google.com>, "Kuniyuki Iwashima" <kuniyu@google.com>, "Joshua
 Washington" <joshwash@google.com>, "Harshitha Ramamurthy" <hramamurthy@google.com>, "Alexander
 Lobakin" <aleksander.lobakin@intel.com>, linux-mm@kvack.org
In-Reply-To: <20261109182533.3594984-2-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-2-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:12:03 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: gyuf5bk38z8kweb5ys4i4ecpr3xsj4q6
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 058EDC0009
X-Rspam-User: 
X-HE-Tag: 1794352326-537429
X-HE-Meta: U2FsdGVkX1/32mdFqz1AyBAppV0a8KvIcyDvNJlwRoiKSuKQrPyNE3jGb/+BUndRvTnZwIGmF+AssrYKTElRkIgATwdSck4VyE+DgqvoZ/kIIq9rRXgFYooV7S5Mcw4uRSXCCsnUwDJfvNJ0mPVQPp8khF6EdjSegDjrG3ACd0dnoeSyXNA80ESgwQFLYhXI3a+ACu42DsVRNlSxxJ6h+A6ayMvYtfhEAtB5Y8a8HB2kasiOj73UgD3WXGEkHpUdSlT9poUbVQKQVYGt6l0Lol5OqFhq+EGqebn7CeI4KBObfkYw2OK9dqZTQCS6av5MhZk2WpFUHuGaPB5iqRnfBsK7TqyVllP+5vLTOwKMVDnIRAxu3WKan12rLZTBKUMDSfEGJfQ5uf4QY9Y3hnYaIQrJ5yQ74j6CuVYP+p5L/ptDKTqqi9xqTEFH58XLifnC44Rn4qk2w1an49Y5p6VvZBStuLk/YOvU2LgNBCRPgEoWMwcDmu+o87GCKXtZfEAt3XhQ4BCZOq4iu8LHluJL8NY/MNxKcasGX0Fb9JJIK7jMiBUxslNU643SaNay9Yo1foKJSFGMqE/dGuqz7wcUc9ESEFVIxGoTtj0N5y+Qd1r26x4DV3g0pjBMmMJVbkmcRE0AzZfsjoE9M1qb/VDwQ6P2SWIRucPq+2xCIvPaVURqi40KtWVDsNs+nTDbC+kpg0R5R2BuzOyY13+0M1AD4K+2WF4fTBUwpLBKnfKgq5P8yIVgFpPAAO9Vu4NmumY0fw+b3IslqWe+Hrd7aICsOb03/nxWSAgrX8pzI2znI/d6z13S8FLouRxIUcoPdlK2pzvd7Hg51O92VLvMuNi5x7r2f97LzppgdU8lOfSaE2fXQ5iEHZR4yEf4WHA8LYUnIlD70T+rxLvLXYqNWpRqtMsTAEEihV6hrTjRoG3DkpFVpWcCGvF3JPNmmwfc0GfYUJtmcYlQVpTxy71UKkJ
 fUL5HXfN
 jNdu/HYFZ7gP8FurXwdJKuJtb++z6SUeP4bqEVTLXFWsuDG5kpJ2D8O7wux16SlIppToBih5yjNlPSrZJ8Cqn7OE4Ool1ovrmR7FVeWsqh88knKe37HQ+pjHAl1pCk7GIRPNJjWtzldoBt0C/wAtjVrT9Ka1vy3Ljfu6SXFHlAjawy+4kgX6qKgd/aDxxNfbbDHmq57RFbm75vt1fXhIX9/oZHSu1lCngvam1RgUdDrsseDyD+CipQtlNULG5xBhcGqGKQKnev33c4t58I53FQiUQDZy+XihX97uRHLq4Aoo/WtflumfW6mAHTuRyGrc8LJooG8sJtEVDi8YTa+MS7OfePMIAs9LSdVrljs47V8AUQcHa9cSsADPj+7I24KnRYq6kJ+UO49EMD/O6pUuw/ImdzwuubiCYRZNPeXAPv05kLLzs6GfzB1bVSfH5sEGLxBDiQaQ0nyptnOLb99Z1He5w1twF+K0XD32gwNMq58HnysxIvcwOjRBza14/DU5r0v3OhpgRihpcUSjKhv15sqCS+yjLQc3JBmKCL0ejGkA2jbVsyEOZ8qGbKLU6cr05V3BVU8P20balaWS+E6HnwvxQU+HpME8inqxGxYLUbOlxPS9x28BUW69qDFa26AGHyMpyHTSFWco+Ujl7sPH9TcQZ0ZZcLY+opCREpPaUxMLhzH53jm/PbgDBT5eMLT52D2rSlraIDudxvt8iDzyWPZddaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] iommu/dma: CONFIG_PISA breaks builds on 64-bit UML and
  !SPARSEMEM
- [Medium] iommu/dma: pisa_meta_memory_cb() ignores pisa_meta_prealloc()
  error
--

commit 4571e9a5a4e068f2cb559f5c16306bf2b33d6515
Author: Luigi Rizzo <lrizzo@google.com>

iommu/dma: Introduce CONFIG_PISA and metadata table

This commit introduces the CONFIG_PISA build option, a sparse per-2MB-frame
metadata table in drivers/iommu/pisa-meta.c, and KUnit tests for metadata
table operations.

> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 85a8d7fdfa30b..15e06eaed0924 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -423,4 +423,37 @@ config IOMMU_DEBUG_PAGEALLOC
>  	  If unsure, say N.
>  endif # IOMMU_SUPPORT
> =20
> +# Pre-mapped IOVA Superpage Allocator
> +config PISA
> +	bool "Pre-mapped IOVA Superpage Allocator"
> +	depends on X86_64 || ARM64
> +	depends on !PREEMPT_RT
> +	default y

[Severity: Medium]
Can enabling CONFIG_PISA by default break builds on 64-bit UML (ARCH=3Dum on
x86_64) or configurations without CONFIG_SPARSEMEM?

PISA is placed outside the IOMMU_SUPPORT block, and drivers/Makefile enters
drivers/iommu/ unconditionally.  In drivers/iommu/pisa-meta.c,
static_assert(PISA_SHIFT <=3D SUBSECTION_SHIFT) and pisa_meta_init()'s use =
of
MAX_PHYSMEM_BITS both rely on symbols that are only defined when
CONFIG_SPARSEMEM is enabled, whereas 64-bit UML sets CONFIG_X86_64=3Dy with
CONFIG_FLATMEM=3Dy.

> diff --git a/drivers/iommu/pisa-meta.c b/drivers/iommu/pisa-meta.c
> new file mode 100644
> index 0000000000000..5ceea91e4d5e8
> --- /dev/null
> +++ b/drivers/iommu/pisa-meta.c
[ ... ]
> +/* Page tables for memory about to go online; failure keeps it out of th=
e allocators. */
> +static int pisa_meta_memory_cb(struct notifier_block *nb, unsigned long =
action, void *arg)
> +{
> +	struct memory_notify *mn =3D arg;
> +
> +	if (action !=3D MEM_GOING_ONLINE)
> +		return NOTIFY_OK;
> +
> +	mutex_lock(&pisa_meta_mutex);
> +	if (pisa_meta_array)
> +		pisa_meta_prealloc(pisa_meta_array, pisa_meta_nframes, mn->start_pfn,
> +				   mn->start_pfn + mn->nr_pages);
> +	mutex_unlock(&pisa_meta_mutex);
> +	return NOTIFY_OK;
> +}

[Severity: Medium]
Should pisa_meta_memory_cb() propagate errors from pisa_meta_prealloc() via
notifier_from_errno()?

Returning NOTIFY_OK unconditionally allows online_pages() to bring hotplugg=
ed
memory online even when page-table preallocation fails.  Any subsequent
non-blocking pisa_meta_ensure_pfn(pfn, false) call on a page from that range
cannot allocate the missing page table and fails with -EINVAL in
pisa_meta_back().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D1

