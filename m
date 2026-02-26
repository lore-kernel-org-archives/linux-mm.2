Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2257BFD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488D26B0088; Wed, 25 Feb 2026 19:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472DB6B0089; Wed, 25 Feb 2026 19:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1066B008A; Wed, 25 Feb 2026 19:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 294746B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:00:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF4751B730F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:00:07 +0000 (UTC)
X-FDA: 84484650054.02.943C7CE
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C5111A0011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:00:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AGlwvQuQ;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772064006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wawHLyOTJp2IXUoV4PemjW87N7htBQucAPkl0+HuDtA=;
	b=ixmk1AEVaDBbZKzQJ74JDaMa7LcTFCreIPkJKYL0rxWJpK2R4aq7d6tLoTdaWI8cVswTEW
	YGFlOSQ96Hpaf5UTc2jx0qbKs8DOFGvIynOleclEfOcMJIMPxBnmdOxGI4hojIhIm6HT6D
	31BLojQw/5tl0DguOaW60V9pR76bpYo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AGlwvQuQ;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772064006; a=rsa-sha256;
	cv=none;
	b=kM0V5H2NqW4r7TooVAC7RN+Q33+xxhzD51En+gh0r9lLhidRk6XyacyLpILxZJe6J3f48B
	PD5stLfRqDUzZ3oeFcrlxMo4M58jU1DndPz14kOR2rQMFpHh2NLtefvcUbcdJBD/Ui91PC
	MCfsKsFQeo0lpCzMrXt4DyHu7eF9+M4=
Date: Wed, 25 Feb 2026 16:00:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772064004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wawHLyOTJp2IXUoV4PemjW87N7htBQucAPkl0+HuDtA=;
	b=AGlwvQuQN+0uaJ8qH6Ehe4SZQoqfoPvzfxZUrv6EIeE/o3WNCyvlzFuer5C/vTA6AgaKZ0
	PuynYss88Gi3ryI5Pyf/F0CDNjP1kRYJXCa498rcUE3Akd9vRJF7u3uSJLc2hAyQkRsCeY
	IVNZnkFwZxooMU9CqbvAUuui1X6shK0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH 3/3] ptdesc: Account page tables to memcgs again
Message-ID: <aZ-Innu9a3ND6Pdq@linux.dev>
References: <20260225162319.315281-1-willy@infradead.org>
 <20260225162319.315281-4-willy@infradead.org>
 <aZ8oT-n4a8VDY2AH@linux.dev>
 <aZ9jHvd-kpnQzMgC@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ9jHvd-kpnQzMgC@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C5111A0011
X-Stat-Signature: 9akrogbag9cfdkhshp6cnkdxadegc8h5
X-HE-Tag: 1772064005-815068
X-HE-Meta: U2FsdGVkX18ISizcI2ta/lnQ444bA2AlYqtsyTRNFrVwMGHh3W+rVzq+XpUdnGSpMXb9ImpNB1o4GhzQC3dVuzyVd3muJDXOn6Zp4E8o0GegS67TLKY6d9H3Xybx6gsjjSv4PgFS/bjJVrKJTGrOY6U6w0p4L+OAWlS7lculnPU2SPDs9qtw9byM7EjPXRzxAkUv21lHxQvyYD4Ko6S4kRHqpAb/lHw5Yl2JYv7NtU7HFqYyF19cd1h3luVa/c+B9OKtqN1LDXNsP2p7K8wDG9r7f1Tb5EJY41bZ1NZW4bxoitNQAjV3otLZQdW/mDzVPW0cu1q3zMcv47lycQlC3b+OODTEq9qMXEzUP5c6e1NNUclsckANDfa7U91K8cNyBYYQRZ1sXMcbn95esa8HHZma2rWA8Ewdzo16MKoxqEeSnHvs81NY63qcI4OCG1gqoKjvRmGxrSMlo5IW06YoPMI0xXB+2DPTIpULEMYGvHH6nN7saYj24LUP5PQo0qXcHvYG8Vtwk/Unk2PQXrfX+u1lRN+VEBG33QV5eQQ+pbpnRUA/Smf79z6e47OUsB+FKb/5XcFRxpqTvRyxXRx0oiWzut+cRB80PUZE8pyuGpQTVofR3FWnCBf7SydqnH4L4RpgMbkcfVGN8TG5ctaiyAR4/+Fn2WLJlO6IH3ekfORc+ElOyenAWGUKyr6oftcfqXSFv5sMYef9Sntr50co0nk5/8UCW2ucAWvnu4i8KNQsCK1iZ1oV2SPLNeXCjVAlEW5Q85zDkLjbLYoI4CAqch88Vzk03j1FfrV7delSaul7DluSpdirsCJOWnc3JKfYDtFIcVvyBCI7kQhSq7L3RDcYUpLrE0JuvSr+7FlfSnyR4zG7UsJDeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 09:01:18PM +0000, Matthew Wilcox wrote:
> On Wed, Feb 25, 2026 at 08:55:54AM -0800, Shakeel Butt wrote:
> > >  #ifdef CONFIG_MEMCG
> > > -	unsigned long pt_memcg_data;
> > > +	struct mem_cgroup *pt_memcg;
> > 
> > This is kernel memory, so this would be struct obj_cgroup * instead of struct
> > mem_cgroup pointer. We will need something similar to __folio_objcg(), maybe
> > __ptdesc_objcg() and then call obj_cgroup_memcg() on it. Basically how
> > folio_memcg() handles the kernel memory.
> 
> Why would we want to do that instead of just stashing a pointer to the
> memcg in the ptdesc?

Not the memcg pointer but the objcg pointer, a bit background first though.

Underlying we are using alloc_pages_noprof(__GFP_ACCOUNT) and __free_pages() for
ptdesc, so allocation path looks like the following:

	alloc_pages_noprof(__GFP_ACCOUNT)
	...
		-> __alloc_frozen_pages_noprof(__GFP_ACCOUNT)
			-> __memcg_kmem_charge_page()
				-> page_set_objcg(page, objcg)

and page_set_objcg() is defined as 

static void page_set_objcg(struct page *page, const struct obj_cgroup *objcg)
{
	page->memcg_data = (unsigned long)objcg | MEMCG_DATA_KMEM;
}

page->memcg_data overlaps with ptdesc->pt_memcg_data, so we need remove
MEMCG_DATA_KMEM to get the objcg pointer.

If we want to store a pointer in struct ptdesc then we can't use the raw page
allocator/free functions. We have to allocate without __GFP_ACCOUNT and then do
the charging in __pagetable_ctor and uncharging in pagetable_dtor explicitly.

BTW we are trying to migrate from memcg pointers to objcg pointers in most of
the places due to zombie issue.

> I feel very stupid about the differences between
> all of these things and would dearly love to read some documentation to
> learn.

Unfortunetely we don't have a good documentation, just code.

