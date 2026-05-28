Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B49CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C776B0005; Thu, 28 May 2026 05:05:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CE26B0088; Thu, 28 May 2026 05:05:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471246B008A; Thu, 28 May 2026 05:05:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38A166B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:05:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAE0F140769
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:05:14 +0000 (UTC)
X-FDA: 84816244548.26.6F67163
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf04.hostedemail.com (Postfix) with ESMTP id 30CEE4000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:05:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf04.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779959113; a=rsa-sha256;
	cv=none;
	b=M0pCBWkv8pEb6kQvdVCgaeGj+SV9D1wqMfRoN8nl9bmskTZtxySYXR0MJ7CgOQZGA2WolV
	RwDXThetBDtBtBUEqy+o+V1t4J6G/OqbdeTHCBVF7AnYhjOKtky9jAqRXu+6YpIUfZYXK8
	kxWUfd+xe7NUqBxJ7WKE8JZef4UfPYc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf04.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779959113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zbKw4fve+YTHq4Xx3/EyIgv1vFEvs4cJROllo/YH5yM=;
	b=yw7BkVxmOE7Es8ZgtQqE8am6oZ9btKzBDAgrneyxClrieXkrLIkA3xrGT2kPo0PB5s4pG0
	+SXZc1pvJsvFBp8EkVHl2R6Nn6jxy+mqlg0xZX3UGB5PZ23EM6szug8BlqiFfqtR5T3qgN
	BjJAiUibv+XUGtdtFhwz/tatjerrnaA=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 454E468B05; Thu, 28 May 2026 11:05:09 +0200 (CEST)
Date: Thu, 28 May 2026 11:05:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com, bpf@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: improve the kmem_cache_alloc_bulk API
Message-ID: <20260528090508.GB8376@lst.de>
References: <20260527070239.2252948-1-hch@lst.de> <ee817070-cc7a-40d5-92a4-2bd8e9e65fbe@kernel.org> <20260527122148.GA6838@lst.de> <482ee03a-c5b3-4873-a550-cc5743068616@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482ee03a-c5b3-4873-a550-cc5743068616@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 30CEE4000C
X-Stat-Signature: orfjxok8pind9kdxxi8ckk5e9jap8aid
X-HE-Tag: 1779959113-759862
X-HE-Meta: U2FsdGVkX18mV/vgGD3B14nrdKvQ1nC0kGnJGYWsmLTfYZdCc+8Clqf3dDiJBLgdc7fkF2wDpJsFQxVj9LfvS1mpoamvHo1WSqdarYy+67PJxslYYv64R3g5PExBTWGXZNDVu7jxD0gTRzA9IlH+py/dtlF8e7+6f+jTLpRO36QsIG98o+LZ2euKTPAm1xStT6pN5V7/JBMAdKTcbt5HOUbyLNcccfU03yZGu/U65A6TtWEesdwdmFdRCtsTAjSEtbOCIPWmwF8PO5jU1lk17oBZXLUKS3rahx0lWiW1zVYGNi0WhQ/mbQUlYc8IA00Qci7gOn7iEPR6NMIzMc/ih9mRRgZH3LzrodiJPKK6iUvNxL+m7QyZTb4OEp7RjPeMXhI5gPxDx15NsIR/DB4107wVq2Ie+uePyyS37jW0/CD+KpARs02riMIKzR3x+RB0KxRpCKz4JSwzu28+VG6X4rJPhu8rQDhYFDmfXtPV4V+cvuOuR6C19WBNv8NrAA56RuHAlBcKHq66tSoMgHrDTFgcUMgqrpIL32Ek/0qHNO1xVPGZ7Tge5xmUYXwtSPoYyxgvBNgThVmUZqPy/O7RZPCd/ElvHJ2C3rqva4DSmUS792EzpyNUpRY2XHDFWPzUPOubuNWsihgIs2YzY4pD5F3fKnQdbAkCfJwQxJy3U0BSa9BqP1wYEOjnvERVqMIZXGOqZRGXvP6n2yyCABVd1EFP6sNWvnsqO3+I8g6Yxg+Yfl1pDbo4byw/XRthivFiBYi1zCEjyPGaBAXWqR8fePgti9NsM/EUmoviU2v1eNA8sgG+ieE5NejD8dgO0g5qlxfYLptdLzcREPEcGzGs8MukXHa8rsyMcCz9bAZpAyzju4a4Q8kHCxT6WwVomq/kaI/mjS/TLiblFKvfPpbbjFGn3BMLURmrs5LMfLdfjBoytuqT3/TfMKUN6JR24x/HFT1Q+Z2DGt6JsiirxY2
 f2GwXj64
 mPGlZMz2aDHAMk5CdFZTwnMNoQh/CmpdMDtUy0L1USdPnm4XWcJUu4aS59RgS8dkHw0razUYLIVC3CyFA5TckJDbRq4JHuHoRJkssTpAj50RifLZ4QB23A3S8g52JRSoWEgQku/WjJ4E0P3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 04:07:12PM +0200, Vlastimil Babka (SUSE) wrote:
> commit 46dea1744498 ("slab: refill sheaves from all nodes") from this January.
> Previously it was just interrupts enabled.
> 
> > but by requiring separate functions so I somehow doubt that was meant.
> 
> Yeah, it's expressed by the _nolock variants. But slab propagates it internally
> by the gfp flags, and since 46dea1744498 it affects kmem_cache_alloc_bulk().

So what are the GFP flags that affect spinning?  I can't find anything
related to that in either Documentation/core-api/memory-allocation.rst or
include/linux/gfp_types.h.


