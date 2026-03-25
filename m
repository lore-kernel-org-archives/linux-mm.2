Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68B16109C059
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2E406B0089; Wed, 25 Mar 2026 15:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05826B008A; Wed, 25 Mar 2026 15:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4896B0092; Wed, 25 Mar 2026 15:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF4FB6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:11:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5BC80E0CD1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:11:50 +0000 (UTC)
X-FDA: 84585529980.08.B37CE9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 90A9C40015
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:11:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n+B7jA29;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774465908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=po04g+LbVixcaFTdbtAzejVAtFF7E6B6fHxWMAEB7DQ=;
	b=ljELuG9JLwSjfdGdwQcdicFZ+wkMoKYc6TIXeWCvBsq40r9mbGVBspoGRR0yJCN2KXcyZL
	M8/fY6bNzoSZsgwruNDja3XcVDSWtKjg87Los59B+LwdlZf3JE2haeXVrgllRfw5l8ivEK
	JH5dWi9sxOvLWDvwwn+InknjrMw/APY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n+B7jA29;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774465908; a=rsa-sha256;
	cv=none;
	b=vFuKmbN21sjM8iEfk8Am/r0EGtFVb6aGQNEZ3isAVZRwb6zjS9GSGdYFV+dM1kVmd4EJDb
	H4YRexkdyvRmczQ4auvzcJPPLsqr5DC0X4m/HeT6h3Ia7fZjuDkucHlyHI52qOTv8bfB1b
	pYUANGH8yc4Y8WZ+Pn6ClhnyeznbsRQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91BEB4052A;
	Wed, 25 Mar 2026 19:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F077C19423;
	Wed, 25 Mar 2026 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774465907;
	bh=R8trGOgutAbT9TZyCLIzQHNIqzASbQS+83BkcRfxwPk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n+B7jA29HYBmodMSUv0jabYWqYQkkzI25KIVUfzjjK3zF1RxFmsERQAksEeZZEv1h
	 iDMFChCVfnLLUa7gKSv1HXmC8QYOQ2DoFFNevqSjWHHy7buMTrhvRcmzF6+Bru4h1/
	 SBYFb48e+BEYOYgHK10JdqzPoTkS++h4SrH0RokU=
Date: Wed, 25 Mar 2026 12:11:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, Jeffle Xu
 <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, Hongbo
 Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-Id: <20260325121145.24f51861d9933f8577b7d6c7@linux-foundation.org>
In-Reply-To: <1ae3915e-19ef-4be0-aa5f-fd66a2e18179@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
	<241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
	<ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
	<d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
	<20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
	<959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
	<20260325112755.e62cd89508224f703239f03a@linux-foundation.org>
	<1ae3915e-19ef-4be0-aa5f-fd66a2e18179@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 90A9C40015
X-Stat-Signature: 1gqn7gma7m3ydgnw87ahnbwz6rnut9u8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774465908-307826
X-HE-Meta: U2FsdGVkX190PANUl+8E7Zr7/UzRYDLNA9CQmLL1qPCLAATEyAMYpeM+qJz+8l8TeJbzBej8TGgwjl0WuyZouVxTg22+vmxiHwXEYrnHpdjsdo9NenMk5bmITdfkqvXIObNnMVa7PxWEL3tFD7/8yx5BI1vuY6AHNcqRkKcKWrJdCNJ4NTD0gsfubwSH9gGzFOgdOAaxdcmP0gcsJjMJUnsLmkDDK6yV1SCBPVfN4fe3pQ3Vfq37s3/fHAseKRMvOhMDMdOZo7eomnCiRj7lCAho0ML4MUmbx9lwjnuOKk94idspps8V5U7CD8upUvHCxb2cTaXkq5CAiXH2tlIRTvRCxADAoDMGndBqFlL6Tzco0PhAKSXVf4pcRZCtvXrRgjIASPazFEJAwEf9MEV5ZC7ECVG2D6U+Ue/fzFE6icDd/TPxolk8qF32U+XC4P+S2r6tKSet5zsIiHyGex6BaVX4KOA4NY96i4uIjw5VmU7O8Me0jDLd0k8HJ2zNPSYzf/bz/v+OA3rh6IMAXPFXSNfgJTFpcoQNZQx5FpSv8gNWJEbK5OTCx90TheoP/bhh9L01G9/RtoTI2HyL/B1xLgjTAYfksvgxkkRClPc99L5OjXiXkAGmsegYq2Thax5vYDYzHzuGPhtFjZ4op+aGoYvdnJjHJ7KCUdQACy4PxfnWGpNjNQgQnQqMipKh5hAN9Xc8n2vkDMUc4KxG1of8CkNdIjtkOoCejm74LVLud656dqjBuG4PDY209p0xowzrnLtjX+V3N+tS/G6O8RUDZYpgm/9lSlsAb3UmPOU1zodLj9Q6hi9u26EFrEWwTtp/CYMVELyFulxBN3Py6b+O+6IJ++DyLpNOw2TUyvsSLtviYY2ag2+e2I2KNnNokM1DayaNX8Ijkq5UfiyNCdoiVtQnFjdOV2IeWC/6ul6C4gJMLW2DG75IxaZXDqzMyC9eLCXxVk5eLrBOZo7yYme
 Vt3n7UQk
 EU/RCe58xF7/K+6UqA5/3IWxyD4zSc0FhgF7e/vXtx63WYOldoWG8cQxwvc+t7cDYTN+WWlw1BvpP830f/05tZuXiSGZKNilPKWo7JjWABZQ6noy10iUiIXzezSxzNr/BWoNemoAjKdGh+S7zincM7n971BOf6rZfKLqdrXj/sa1BhmZlKnIWGSpCZAjqtaNoi97uFWoEzEdz3CFXIxa4sU9WbEj/+XN07uKkmYHYKVxI6637OrLBNuxJu3amY263Lt4/MfB0/acWvhQm9RRaGPpKP1QGbzB4ysW9im4sbdh9nHbK0E+SZ25pdrFtxtlgQetp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 18:44:13 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> > : Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > : macro) always being inline, as we rely on the compiler turning all
> > : constants into compile-time ones.
> >
> 
> Well I think that loses the meaning a bit.
> 
> Something like:
> 
> Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> -macro) always being inline, as we rely on the compiler converting this
> -function into meaningful.
> +macro) always being inline, as we rely on the compiler to evaluate the
> +loop in this function and determine that it can replace the code with the
> +an equivalent constant value, e.g. that:
> +
> +__mk_vma_flags(2, (const vma_flag_t []){ VMA_WRITE_BIT, VMA_EXEC_BIT });
> +
> +Can be replaced with:
> +
> +(1UL << VMA_WRITE_BIT) | (1UL << VMA_EXEC_BIT)
> +
> += (1UL << 1) | (1UL << 2) = 6
> +
> +Most likely an 'inline' will suffice for this, but be explicit as we can
> +be.
> 
> Should verbosely cover that off.

ok ;)

