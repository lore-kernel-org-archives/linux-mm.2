Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1AA5CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 00:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B526B0088; Mon,  5 Oct 2026 20:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B8C6B008C; Mon,  5 Oct 2026 20:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94026B0092; Mon,  5 Oct 2026 20:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C33436B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:52:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C026160512
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 00:52:46 +0000 (UTC)
X-FDA: 85290376332.20.52F2D42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 87A851C0004
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 00:52:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLnHL2gb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791247964;
	b=40S94Csdi1qW4WO/SYYO1ZFp6UGhf0JUhdQ2gQOhgsOVs6FLEn4VVCUTyFaXsI6S9BXAGN
	zLSWF1YNNo21eov5wg7wjb54uN6x/MHyZLayqwJYBD8IVy1yE3Op3UkZSUO1BwxaWwLYxY
	751dE1LcFG1eN8I8HXcmconW1mSFVeE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLnHL2gb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791247964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6yHyvxgSFAtHWCFCMd4s/EWnCMi2wyyPVO4ODcFr4k=;
	b=fEymgqqexAfVJuMcnEQt5MDdJbZ3NXp8XXhF4Hze7Jh5jy1VHre1cMGeQnLqfl+EvtiOiN
	YXhQJzwyNiqtD8m1TGX0zbw98EunhUBdN2QNwhWNu7wB9w9WZEjQw5p4GFezBIeGGrWuFn
	iGmA8uUAZkq/Y94Eo6WjyzAIGHpfOYc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0988744038;
	Tue,  6 Oct 2026 00:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6BB1F000FF;
	Tue,  6 Oct 2026 00:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791247962;
	bh=a6yHyvxgSFAtHWCFCMd4s/EWnCMi2wyyPVO4ODcFr4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bLnHL2gbeCWNkbpH9td+jOYWcisFag1WKNYRonRKZsQjeSs/vv73vLl7fIEhngC/u
	 kr8+q7aBapijn3MEgS1UCicKD1luURaAL5imAaRwbllzE3JS9B9HWzk0YhB8Cx9XIf
	 /7dv1YJE4Ig+4eASQDDy90UFaMx1grxitiainL0BkT8jrvLdsz8/DUz2kGSepbrxfN
	 tZPdsKNC8QDKq8VC5rw4vOUtsltue1ZzpehpSm5P5kGNKlWBlQGa2/Hb3IpG6qKb4Z
	 CIj2dkgElxLscz2EgeZFK1HMxMkVca6J+MexZZRIaVh6zwuSz4BNxh1D6h7I29HyPK
	 +Pc8utcOPJqHA==
Date: Mon, 5 Oct 2026 17:52:42 -0700
From: Kees Cook <kees@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	driver-core@lists.linux.dev, linux-hardening@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for
 devm_kmalloc
Message-ID: <202610051752.4516E8CF4@keescook>
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-2-kees@kernel.org>
 <2026100532-stench-enrage-0b81@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026100532-stench-enrage-0b81@gregkh>
X-Stat-Signature: 4cc9kyp9kw7qu3uyrz3pcc8ic4bjbt77
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87A851C0004
X-HE-Tag: 1791247964-508638
X-HE-Meta: U2FsdGVkX18ghdBpUWeZ6BEMDPPByLuKaMeBrv2LTEpmUMWghTdADwT+4kP2MPRDsFBr+Rw3p1MaswTTnxyAfQmG+qIYiKKMzccN1Ni/PFUH/3kpaOdevNXK3mbnt83mv0Nbp2RhC52jTu5cVDv6I2SUtEWm8rQWreiEi0pUJqXFhuoZcU7rUFE+GvdzjMYgY5lAie82xDTquWO6dEmfhaT8Rwc/UhFYIBkQI9/LkRxvm7OvI6NYgZUXT8DBgJXOsLFIkVB6t0N/nEe5075nty+rbu38v3/+LqRocVz7dvldpXOmihEu6J0iTbFeSLVd9bbTsdx1zeogJzmz6PwezIrJStsEdtMKHVR2LWeo07SDBCin8vPuQ6QhmzD0kckrsiLw1YWo5HTvXZnNebbgYJrTCxUlhqWfzBW/mSV787dmZgyGUiaGxSSuL4OPdpUJAMa/9OFGXFCZbG+P7UuGiBVHQXCo5gDuhAj/XC/taG97OLms9Gm4xG/iwVsvxDSBei/A6FVxM5T2GL/PsXE1p2JIxOt8zyhRsk/RTh+1tQDrrr2w5WG2Wk3H0ZHJXQgTTllSvTzmglPLfo9WQrxY/2qomfGsiN5OeqkfX9lZwl3hSWpYPBJWC+SxoZXUCnFDWml39s4JJsGwhPORs3SNqxKOf0lHmGejw3NxGGnphpvctk791LbKruzytvqey8nJn+vP8/E5MTQbvGYAwCay/i8WOXw8U4PkYi6QjkQOcaC7bkcN2SrRUu4fZbE3Oxc5f3J9bZh1wu7Y2faJ2VRMP6w3L905Z7YDWW5Y2LbExE88urOQ6PvuaHz1KBMJn1uBiauRJawOulxnLo6GkTRFOh4P7jPMAzPDd+gpu0OcoeFbjDY8DO9HLcLBnmItzlZrxS5nwNBP+vpE6asGvtQcVkgZHe9B+cH87uEPLKHT1wTC1xj8TaXK1rjIleYf5n6TpD+mcGagN+eyu49cbsb
 0s6zJ978
 Up+d4FJPnzADeqDA5LUd6bLB7dd7SGD1juXRLQONuq6KRJnXhXXoEh7Nk1LeE4Qnp0NMyzf4to9ne/V7d490BZ15XyARf2vPXnhMoUY/3gw7eJ3bpJOYv8JGHC5gIYaixlt/sdlpJBJqnF1IfPtFT9fXiccm0k5vzt+87c6OGpCNcDdrpXL2/Dg/EvugBtolYpd9V+3KktrWOMZGd9tl1E8JaIRST/RpfO1IOhYU+aS+8WcA5WYSEwqdlsSG5dWVjpSiR5SdJH7b9uyH8PloaNHi56UdOowqI30BtD8CaFrggk8c3XWAQlLKa7dBXLTTmtja77xFPti5vULUrrSDvB8cxFkgVF3faHhtqHtS/7yCIr3XbgtfP8PkKFuVPr62caQoF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 11:35:16PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Sep 14, 2026 at 03:32:17PM -0700, Kees Cook wrote:
> > Mirroring the type-based allocation now in use for the kmalloc family of
> > APIs, provide the same for the devm_kmalloc family of APIs. This will
> > allow for future plumbing of type information (e.g. alignment) into the
> > underlying allocations. This immediately gains type check on return
> > values (instead of the prior "void *" return type).
> > 
> > Signed-off-by: Kees Cook <kees@kernel.org>
> > ---
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: Danilo Krummrich <dakr@kernel.org>
> > Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> > Cc: <driver-core@lists.linux.dev>
> > Cc: <linux-hardening@vger.kernel.org>
> > ---
> >  include/linux/device/devres.h | 102 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 102 insertions(+)
> 
> 
> I'm guessing you want this to go through your tree?  If so, that's
> great:
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Awesome; thank you! I'll get it into -next via the hardening tree.

-- 
Kees Cook

