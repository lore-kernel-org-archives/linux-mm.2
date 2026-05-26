Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EA5CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 08:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299FA6B008A; Tue, 26 May 2026 04:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B2F6B008C; Tue, 26 May 2026 04:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8136B0093; Tue, 26 May 2026 04:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 09A7A6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:00:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAD8D40324
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:00:13 +0000 (UTC)
X-FDA: 84808823106.01.325C63B
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 736F2100011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:00:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7n2d7Ha;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779782412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/mtLfTIcNnxuEgv7Gd34gqR3ftMO6U9fViw/IxnXBU=;
	b=Z0f0h2YaYAdw7lJarWFE/QIOHVTt3ipsiDXaBaoHHT7T5nFmnidjJavtpyEt5u4/FIMADf
	14gFrehWGso5K4bxIZDgXf8TST6WEN8tUUPXjOdsZ66CqQtB5pICLBQ4LSvpM3wDrvXnc3
	a4M46keQZqveEpdkF1bE5Vz4X2/1tww=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7n2d7Ha;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779782412; a=rsa-sha256;
	cv=none;
	b=dcD4k16bGfMqtsaOa+XyzlMkF1mROzgwKERwkjLzoA6A7PSEcpwV0xcT0c28O+kbvhsZO2
	beLSY25Bc9LbFM4W4rUgfuAQzXEBrTmPIrMVTvXUF2XQJGBvz0PDdsxZxkurcyceUF1K3o
	uxOx/6OLoZZzlUEnlXakwi4Fxuwb1ag=
Date: Tue, 26 May 2026 15:59:58 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779782406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G/mtLfTIcNnxuEgv7Gd34gqR3ftMO6U9fViw/IxnXBU=;
	b=U7n2d7Ha5IkwiSljUMk70AHc8aKAP9J4DmvYIhSGaRSXeLtU4l2PvgjTL89zVMJm6goU7O
	vRW1759Ie/s0RJz2OArTiW5JyGnSLGsj+XZK73Lx7GC9ys05xoZpsUJeAhp1LQPaNovsxS
	Y7mWH4vtNQWbyPtm4rdTFFLFbpDQNt0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: allocate sheaves on local memory nodes
Message-ID: <ahVRviGfYjPglJKB@fedora>
References: <20260525082312.16012-1-hao.li@linux.dev>
 <15f22716-0065-4814-8be3-7730ff34cf34@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15f22716-0065-4814-8be3-7730ff34cf34@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: osijdb3tadbmnrhhyiex13fymnp4ot1n
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 736F2100011
X-Rspam-User: 
X-HE-Tag: 1779782411-283017
X-HE-Meta: U2FsdGVkX18vtCtcmF/3aHHJe4Ciyt6Mig5a9naUz7OPgPlRqTV6XuNYmFIosN5KjwRgPxmTanyBFjygnkWDjVoMfENu1HoNtAtlUGxJXlIhLr+HkkPbuts7Xbc73THLlzLFQrfa0XkLhRepxjeLR744smFFeNHhrRVrkthIo+SFGq/lt/Z9tQgwSx3QGR5hVT6c1TpRLCtRi3f9UrbFvFY9h7alBwm74Ng8RPq+JcuJf+XtDfh4Y+fsH+fJe43EfkG1Z2OS/vW3uybGCQSLA+qjdBh698pYyr2vm3AJOzl6y1FU9uNa6dzUugL/B0Cu6jMiZrMo9HcokjBLCvBf6PkJG+4ytp+A/obzMxRyrYMDHtPuIUYn723WZA2WtbKsnZeocFJR++GRXlTbTObmkdy6t9qySX9JHHMs9a6dnfsvWd0Hkdz/5RoQB4X2XyomAFWejT3QKYq0PR9mPc+qbtG0bq2K8z8qAYdxy2ZiqhjRKE+2Sq4w4e5/SQs+iaz9rToimZ0ChqdyrbfdhKQ6H+4YqlFrBdk8JNLddkqj5yzcBdCePelXh6fH3sebIke5o8ownzNTKqzuBbqzFUbdehnyfFJVGFsMayAPGqVoIx3Ab27Inn3Y7oLxmSnA5czleAxXAUjBNDosyctHMPM6r0FVjJvWA52Ajf7AjKISwVaKmRqDzi8yWd+Tl2Rq4L5esDP6R4HjZK39CVcVQ3c2QNJA7tOfJSIU5kJJfgarnwCrNJqG522hQ0hPozYCl8fivEiKJIMdt+cbk8hG3OEVmUwLkoidl2JQUR7cH25um4JjrGz6NvFY+hHagOlMe+cls+bWXGRgHFb2R/u1gdqhxgb7ZPG+Tn+Fu7hkxqz/5GdUDYWr5985P7Y3Q63ZiQPkmXBtuGdrsehrkbVuPtVsxi4PJ1JuVoIbWcfwQM5iPV1+yaUBFnuHCzHLRjYuPymjgypsXgIUJgKma1Dh0S6
 qBHD6Epk
 7fVgZ7mKJxT+qGJEaTIDhTTaaHhdRARkkd1nvGMPb02PxGmA/2YGYtKvtiOXwZ9t2xd8lyd2mu1D7ZJ4146qmv+00fgPYeIO/AZaKhOSOfy4afGuxC70KIrXcvgjvv/9byO/Ws80VxEfXDOp6mj5kzbCWUQpw/0QF3LYQrYHQqAaNgpk6mM64vl2YZgtU0ndfpkSsIDdtDYhjadw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 03:56:58PM +0900, Harry Yoo wrote:
> 
> 
> On 5/25/26 5:13 PM, Hao Li wrote:
> > Sheaves are per-CPU allocator metadata and their object arrays are accessed
> > from the local fast paths. Allocate them with a NUMA node hint instead of
> > using plain kzalloc(). While no measurable performance improvement was
> > observed, this approach is theoretically correct.
> > 
> > During bootstrap we allocate sheaves for all possible CPUs before every
> > possible CPU has an initialized cpu_to_mem() value, so compute the
> > memory node from local_memory_node(cpu_to_node(cpu)) just like
> > what __build_all_zonelists does.
> 
> 
> What about sheaves for non-kmalloc-normal caches that are allocated &
> initialized by init_percpu_sheaves()?

Ah, good catch! Thanks for the reminder! I completely overlooked this, which
unfortunately means most non-kmalloc caches have been missing out on the
benefits of this patch.

init_percpu_sheaves() also contain for_each_possible_cpu loops. It should also
retrieve the node id from the cpu idx, rather than relying on numa_mem_id()
inside alloc_empty_sheaf().

> 
> Would addressing above change "no measurable performance impact was
> observed"?

It looks like we should get some performance gains now. (Hope so:))

-- 
Thanks,
Hao

