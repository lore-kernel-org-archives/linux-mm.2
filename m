Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 759A8F34C74
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 17:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B9B6B0088; Mon, 13 Apr 2026 13:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3056B008A; Mon, 13 Apr 2026 13:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F4C6B0092; Mon, 13 Apr 2026 13:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7406B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:20:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D30A1402A7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:20:20 +0000 (UTC)
X-FDA: 84654196200.24.C18C64C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6F66C20011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:20:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EF338F78;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776100818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xzqNTZU5rW5X/KJ7dZ0k/+iqwPV8kTHwUdRhXs2I3w=;
	b=knhJUPgKt9EWhAb1npGxeTxIbfTMPSj1789RIpW0IOvi8i+TIpR+CK3GfJLofB6j7F6ARB
	esV3rIpcc6G6bvFSOHqllkNcBxrxE8Y5bLOn12UgeZePhDFyRACERYIjXzE7+uaX8XwyXt
	uvsuz6VZ+NdQ26brHcr1QVzcRnOGWXo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EF338F78;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776100818; a=rsa-sha256;
	cv=none;
	b=k5pfu5/1sY5oCRW4JskNPa3kg/eBTGyc6+NW8nFtjV0bJ1mi22Rdb8XadEIYu8V8nbYMdG
	nB7MSXUZ+iZSnRV6w7xFvfJyIb8ZXTtPLQPuOP+/ZjktEJLBnfFKDMgAQzuLos2slk02Nz
	BRoxXKCqZ2nMJvUHAkhoPUUGmSaGvQI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 726016183B;
	Mon, 13 Apr 2026 17:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD74C2BCB0;
	Mon, 13 Apr 2026 17:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776100817;
	bh=8c7V38SjK4hMjN4VLoVwMlqjL2MnquDxEbG/Q9cUQfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EF338F78QTuHgoJy8BYFIqHIHuMOS7IvI+KpVJdIq5DJt08ZKKW5ojcKBSqziV0LO
	 7odSFMS3yPcPUZpqvCVxvWTxuKuOs8q1B+/yCUbOl+HGWkNiJEITAtyK57z+sDLxIa
	 2HS5VaBo0FO/vMGzM7ipr7diKa0CG9ei7DVD/mCwPaEBTknm0NPA3gpUe91TY02eUH
	 fet15Ow7PqmtN0VT6hQ04ed0RK8KfT+U7BikPEX9ivE8Q1QwQdGkx+Qf5cwpwi4Ng/
	 xK/1oCPstSEbYi/NOFu+HI+lMho0VU3/YQnYwzBPoal+G1JXSlEQbv+0u8Dc1JkYE7
	 S8n1mTyfgsBtA==
Date: Mon, 13 Apr 2026 20:20:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Liam R Howlett <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on
 memory hotplug error
Message-ID: <ad0lx4jI0E2OZoAX@kernel.org>
References: <9642F4D9-8F1B-47A4-90BE-C72BB8DE9A11@linux.dev>
 <48CF5603-D8E1-4C86-8554-E8BA03D195FB@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48CF5603-D8E1-4C86-8554-E8BA03D195FB@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F66C20011
X-Stat-Signature: iwcywjwp6mm1iwyo8r14mi71dyx4ag35
X-Rspam-User: 
X-HE-Tag: 1776100818-162547
X-HE-Meta: U2FsdGVkX18+lHtkgv2yQIC2karZamExYXEQi+VTMmPFmEJH0KKErJbhRNzKVL1hK/eqpJen6ovVSR71w8h3TpOUeZ6j8vJm7rm+fy2TrD7mF9Azx1+cGp9OcsH2tRjArGpyAMpfdsAbDSl3DYQajxAblPAJ7aPcxyZNvYQVorKdhkH//Qzk4L6DF0DpbEo0Ge9aRVJMaln3APYjjFr7nuzlIWrozxLAU/C8M3XisOGzgKHWtHJX4pYd9FVd2foALZ5EEdCsFHBujaf/j9foWVnY3a2xcoWH5nUzgWVX6J3V8TbMhFtyZP+klXZ/NHzzp5yNUClJNKKnsaWVx/heX1r4KcaZ9X9QiDphm7PP2Sd6CGH0IWSIiBP1f4+9x4ZstolagvIkEhnks0YGpZarJrUMCRsPIMS4Dj+L+vR889pWbKCkSzY08RfDk8R1MiPX74FaSoapIUis7gfrh8dadtqsZ4IECC0aOsHfIoCulhmY3Pc3ZdRCTAUD+MOeyzw9hJxGyvLSU/bJ5bqhFCOplkNU9GeexqdQvZmjLlRY7HMJr/nZ990sX532egfxB7koizEAJE0fg6IHfi5X+WEqQ/psCic+itBHfoDh/oa3tMryXSUKosCGBuTLbDSIkUvqT7eQ0wKdmIV3jzZzJ2sEEc3NMDMiYI//c9kyj8Z56hKNjit2op0lqwG7teKZd/2OEpzUu4nfOw+Q2UdAgx8Rtq4010cAa2EhaT/MDtjlfZFd9uz0ndfMei+LqN2IzZ7j7RGoiY4C20BgdCvwxkQJ0JDlH6ynpsSCfbvXQJZVu74YS2zPy34wWDrY/CPsEfydz2geBNqmE+uTRLKsM7NsxLCbhHLGQC7yu69fd8m/KJyVADhop1LEUtLgKI//5Y1dSyh+1KHLYljhTwylaImyrdA/EtXK3FkiyLbtOMBoflc1BYkvlTLraB9dMrem8WA6dhwjRgSTqWi4Tjzgfvn
 r7eNZx9s
 jQL+91mWiVi8ea/9j0V8vTScIgEW5SvxjrvSFZ97Ao6skwYDhiPnT6bY3q6jDoMZzUI9IO0C59L1f25eQMFaNKEVPD4A4fi1GJl/XrxLm4XHZfsWRqY9AhvFwGQxE534tlT+e7zLl3X2CgQ6LyRkFhnlTRLdO3rqhFJ1TJTxmzlXMurX850EC3VvTNIbpBr8ppAtiWxog0sRWp2cP8e9Esj+8JcL2tgk//spiNbgfhv6eKyg8k617jwi1S8EuSZfltQ/Z32OpzW6VJhyzlgLtZtgmog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 10:16:20PM +0800, Muchun Song wrote:
> >> +++ b/mm/sparse-vmemmap.c
> >> @@ -656,7 +656,13 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
> >>       unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> >>       struct dev_pagemap *pgmap)
> >> {
> >> -    return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> >> +    struct page *p = __populate_section_memmap(pfn, nr_pages, nid, altmap,
> >> +                           pgmap);
> >> +
> >> +    if (p)
> >> +        memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> > 
> > We don’t increase the counter on failure, then
> > 
> >> +
> >> +    return p;
> >> }
> >> 
> >> static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
> >> @@ -826,7 +832,6 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
> >>       section_deactivate(pfn, nr_pages, altmap);
> > 
> > here section_deactivate() is called, which decrease the counter unconditionally,
> > the issue still exists. We didn't fix anything.

You are right, I missed it :/

> >>       return ERR_PTR(-ENOMEM);
> >>   }
> >> -    memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> >> 
> >>   return memmap;
> >> }
> >> 
> >> 
> >> Then we'll better follow "all or nothing" principle and won't have
> >> exceptional cases in section_deactivate().
> 
> To follow  "all or nothing" principle here, I think we should not call
> section_deactivate() to do the cleanup in section_activate().
> 
> After all, if section_activate() didn't succeed, how can we use
> section_deactivate() to release the resources? What do you think?

Yeah, if we could pull "upopulate" from section_deactivate() that would be
great.
 
> Thanks.

-- 
Sincerely yours,
Mike.

