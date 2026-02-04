Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07498E83F05
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4F56B0089; Wed,  4 Feb 2026 13:10:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292DA6B0092; Wed,  4 Feb 2026 13:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC8A6B0093; Wed,  4 Feb 2026 13:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5836B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:10:34 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83A1BC114C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:10:33 +0000 (UTC)
X-FDA: 84407564346.22.0C69662
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2BBE6180004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:10:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ts6WVzg5;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770228631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+9Ex6m35FJGBhaP+VFOv6lmRGp/pb8Fu0SpZi9M1j4=;
	b=gY8QRHvT9Z5JJqYRwMl2/JGsg85tUVy9a3wK4nlX+9phy4Fj0VYdPbxDI/vNUSOeQUNCmd
	HEbZsDOE0CF/J6NOqza79iKjtpV+BlcL24B/D7a+f5PM5VEsjxPTvq7/1NlgppRbAnEUaS
	GC9m2GELKmNmZo7IMZN6KQxVG1p9EVM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ts6WVzg5;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770228631; a=rsa-sha256;
	cv=none;
	b=wfF4npWdNK2Dm6yulc37EfCLQXjPqK3mD5pGI0TgcC2Ij7XbZKPtXqyCawx68k0/a0M60b
	HtRpTghubjbBSwSh8EVUY8i/EG0Q3qJUBnwguQ6aMKzTv9bTrlWyglUGsxRr0Jm8bPhpYE
	MJ/eaP8qirHbS/RD/VguXAgkXixXtPM=
Date: Wed, 4 Feb 2026 18:10:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770228626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s+9Ex6m35FJGBhaP+VFOv6lmRGp/pb8Fu0SpZi9M1j4=;
	b=Ts6WVzg5dL7EdUrUvy14pppIoCPBnKPIGZ5LzbHrUdbmdChWkgnNc/axaomSUN5fPCWuP6
	iqPNF10sW+x4RqcHmBHdyDgPOCvmBYN8cnu+E8hV84klRiYxxEXCtu2ZN9ZDQ56xjUc/xO
	ptlQ8CCqC/ocdNrwr/TjpE9L9E7IzYs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com, 
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org, senozhatsky@chromium.org, 
	sj@kernel.org, kasong@tencent.com, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
Message-ID: <lfb3wm5mmxyjbsiw4i2mgyoot7o64645unmoufloyyeuk3qkqv@rkerijymxnaw>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
 <CAKEwX=ONeMBRwr+4mJt76+zWZ4dXL+LCEAMELYeT6Nx-hej2-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=ONeMBRwr+4mJt76+zWZ4dXL+LCEAMELYeT6Nx-hej2-g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: 9o59tyxq44637w8qcd5pjwpmyakp88qf
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BBE6180004
X-HE-Tag: 1770228629-156237
X-HE-Meta: U2FsdGVkX18LMk3VIDhEAMXeYlKo4ibJ35sHajGLJR4+PqheQIgZAa7pXU4HdwxajUQeVFTHr2U72Mdv+yrr9RV1FCVHZt+Avjzeoc6LiriDst2KfzMQx0Vy8dpyzI6BLaeuT+bfTxacyZq+gHNhxVirlswXuwzWx3HIjz223tle7GelkjMvuGFfqlphEkKQNH2/XUtqNKtJqDh2yp82VGGDERp8OwZvsme3vxkDJ8giOexfjYoUHkVmvKBuBUDQfPAZcw8tcckH7mTN90c1rSSVJBe8FtBsRz25v3ifpKlIkePN9xYw9BexBzJ6ddZNAmpJVByWLpLUEQW1jr9bYKOoALEkDWAcgraMDte59nHJmWyrW5uULdWFLDAm3KhV3IQFoPQoV1VemV0+xrikImq35McAI0vLndIaJNwgFGYsL6pz9mHUV8jJxHbCrri40Z1aW/C8aGr7J+fYJIfRZHYJh3LynxNa4qAoxTNvES+VOFq14EU7ADU4xt7cjWsMwGvlG16eF326GzZ+3zxEXlAHURIVSn/9O1bxXgZJVO5toaj9EaBDa+Fxbipb2fdOw5FS+Ces0egmpdNf7nLRv9HSXFtkXuP5yjAbkjZeJmxC4DuCwOpuInOVd/yV/iNEHKIAAkxv3VQumU24HJg9KHwOc9SCREbO4K9VxLhadYCLGMcgRb8bDHJmZGtlxMhG1eyi43tIE+7rTDpKhnqHZmXETfimooz4vK722ODOBYbaMC8jyAn1knrRrGVedvyy4lUPzI5DjskvZLtXhmKhBx3oczd07ICg7p2CVntIaCMg9JpjHSPn+/nvzm9zydEcIEh7MSmUM/DCHOL4Ok6HZJEn/bWOtRK4zQYsV6YLspbBwsWG3bDS5RubUwdHrjsC6Tyn2VkKSsyVJUutv7yGcsEBHR4S/84Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 04:30:48PM -0800, Nhat Pham wrote:
[..]
 > @@ -900,84 +923,177 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> >         return ret;
> >  }
> >
> > -static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> > -                          struct zswap_pool *pool, bool wb_enabled)
> > +/*
> > + * zswap_compress() batching implementation for sequential and batching
> > + * compressors.
> > + *
> > + * Description:
> > + * ============
> > + *
> > + * Compress multiple @nr_pages in @folio starting from the @folio_start index in
> > + * batches of @nr_batch_pages.
> > + *
> > + * It is assumed that @nr_pages <= ZSWAP_MAX_BATCH_SIZE. zswap_store() makes
> > + * sure of this by design and zswap_store_pages() warns if this is not true.
> > + *
> > + * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor does not
> > + * support batching.
> > + *
> > + * If @nr_batch_pages is 1, each page is processed sequentially.
> > + *
> > + * If @nr_batch_pages is > 1, compression batching is invoked within
> > + * the algorithm's driver, except if @nr_pages is 1: if so, the driver can
> > + * choose to call it's sequential/non-batching compress routine.
> 
> Hmm, I'm a bit confused by this documentation.
> 
> Why is there extra explanation about nr_batch_pages > 1 and nr_pages
> == 1? That cannot happen, no?
> 
> nr_batch_pages is already determined by the time we enter
> zswap_compress() (the computation is done at its callsite, and already
> takes into account nr_pages, since it is the min of nr_pages, and the
> compressor batch size).
> 
> I find this batching (for store), then sub-batching (for compression),
> confusing, even if I understand it's to maintain/improve performance
> for the software compressors... It makes indices in zswap_compress()
> very convoluted.
> 
> Yosry and Johannes - any thoughts on this?

Yeah, not a big fan either. I am really wondering if the perf hit is
real enough to justify this. I would much rather we use the same batch
size for both.

IIUC the problem is that we cannot use the crypto batching interface for
SW compressors as it requires compressor support, and we cannot avoid
batching altogether for SW compressors because they regress.

I wonder if we can add support in the crypto layer to handle batching
for SW compressors without compressor support (just loop on the batch
and compress one-by-one)?

Alternatively, I did suggest we at least introduce an intermediate
function to do the sub-batching to simplify zswap_compress() (e.g.
zswap_compress() and __zswap_compress()).  I think this also caused
regressions but I wonder if we can force inline it or sth.

The current design is really confusing.

