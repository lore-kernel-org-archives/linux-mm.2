Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7802FFCB622
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA746B0096; Fri,  6 Mar 2026 11:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488706B0098; Fri,  6 Mar 2026 11:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4AF6B0099; Fri,  6 Mar 2026 11:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 295C26B0096
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:44:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D35E51602BF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:44:12 +0000 (UTC)
X-FDA: 84516210744.13.ED5FBDD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 05EEA4000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:44:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nbpPjw4u
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772815451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQVieUAaotG/Vwy8hL1CcO19BxJghydmXC5ROajNp9s=;
	b=oPMFftBfW/KvJsP7qPGxOAPQ9TaYIrN1X4RoondWnSq7gLQ5lMh5ia+J1xMMO4BeGobUXs
	mYZY4JhBH8gXeixViscaMtb113d/DU3YWr5IzcUskJsDnm+TkZUr7x3fe9PnALaAgGh1gt
	laBxZOiqsxEOOBLP6MQ2rfZBUY0AxL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772815451; a=rsa-sha256;
	cv=none;
	b=1NPP2smu9r1sLWEgX++pHXZ6lID/BhY4WOgY+iMOyoEvqY046sTSMeDcIplyleMdqocnCX
	t5H1ZczBxfx0FgF3P+kE5pAnYR+ThviLOlvRnxPMV6Keoqi6lMGjMT8ADaZb0qj75rKO7Q
	iSN4FxoRrP/GoC3u5SH758eO/7kOTK4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nbpPjw4u;
	dmarc=none;
	spf=none (imf12.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=FQVieUAaotG/Vwy8hL1CcO19BxJghydmXC5ROajNp9s=; b=nbpPjw4uWRr0rX+68AEmJTYihB
	jDoXB56NrOxP3UyoKmBu/zDMDzPyaTY+x7vKVgOG03OS9fkIf5SJK+TTwQwfeEhTCbKUpwYfaSVcf
	3LtmAytssBjwWp+LOvKM0ZykTb84ERKP1N4Zf5o1l2ygVUffEhIeX7iX+luS29s6d0YPLw0PbWbzN
	PM8mCHVF/tnLIGkU09IHYqRkjHs96LLAJVhWzJvkxflKHIRasSDruhWNSUIx873U3NKZh8Z8UYmYh
	7fxxk0Z3+a5FQNlPHNaqLaIeKhKUU5M+18O22YN07/1URQOS8Xixal2+6Zk3qM5S/aVQ/drBl9dJG
	WkRhnjbQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyYHI-0002ZQ-6T; Fri, 06 Mar 2026 16:43:52 +0000
Date: Fri, 6 Mar 2026 08:43:45 -0800
From: Breno Leitao <leitao@debian.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/3] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Message-ID: <aasAU-7yRunywKmt@gmail.com>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <20260305-thp_logs-v2-2-96b3ad795894@debian.org>
 <68156cf9-cf97-4435-b979-c2ab0d6a97b1@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68156cf9-cf97-4435-b979-c2ab0d6a97b1@lucifer.local>
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 05EEA4000F
X-Stat-Signature: zwcakujsyqb9oybmoaf8qzhxueh9aime
X-Rspam-User: 
X-HE-Tag: 1772815450-112314
X-HE-Meta: U2FsdGVkX1+vA5hN1qSlHF4JTZJB4LxDTJ8Zsq1jR6Fljq+FMtTYSiToDoEYfrxHDLKWhhQ3LUKTperP9mK9L65hVjV0nz/U6D2bHKGw6O3wCJftWR/O9QpKftL8mU8+RfMtHDZuydcJZdf6YazEYUeB7kQl26pwfOmm0p91jm1ikxT/+lqXRp36AIytOO96Bb2jel8S7UIVK920BYiPkrAG+5gtLfIJ2dQq6772NVN18kWzLRmO4/1Sdcr+IZf1DHeQefs2ZbjptLvh/9rWj9jJ8hkfWa1uoRwQxRtTTf6NnXzOk6e1LZV7bPAByhejXRtIwTtBzqP3lsz6bT6WhC5FAtTcLpm9uAmhzgJy0eBduEVAzM1ftdEzcZscZEu1fNwCCS33zaNVN4bDbRlEZ/NnXgi+6YB3GrF7u0JYogWTwpaXEFxin+Z30ycciWd3kQc1TsI6SfmPbFXpZ6Yu6NXxU9oZN0UbZHoeDFlSf24sWEF705nSYuoieP0YgfGw4hIpdVRtpAvnayj3PsR5/LyOLWOhRohGj0lBXZPn2E6PDnUfHfVwKwXU5PxDnytXwjePL++oEbBSXNv42F3BuGBRvBnrzkC6xNy8fNEC/OunT4bW/sTL8mO6Xpa7JSylwcybWGrbcncCB+kddNxL8dQHVkuGoxRFbgV1C89bNoC3sNI75fuBio30fzrJ4BtHI9hXY7+Cbp/lkMFO30u957qefsfIfqFTB0hv7m6a5qRQ8h54ssHxCRvURWt43oABXpDSTvq2WvQBPQyQmaDuEwE2jSskRs+CzZrd8TLZ2I51EOWq55td1mW/amQiAaO79jx4gVr7JmY2mtciGat86PAq9ScaBzHZBmLineW3ic2pTweUYH1hCCNu8/HxojRDuevOfvhWCkML4dQmzShpH/Wgg8qHWlelwljhMVVfpccLZrcLsg22MzEQoxsJRwl9w7TYESeAfHJ2C6kIXBY
 T8NIUzsh
 65Wv+0AgO2tg2rSU5D+U3NL5IaFQ0alPC+n2KiGQC+yoFJM8o8qMSap57eMxL9bJFT/sAupSkGW5ee1uR5DRpjRcoiXTF+sC0nySCPpYharOrWFxYFiA79EZ8fTir6M914PpjsFcjy9ASbj+fP/RwRO+asqwWLpVqpSzqlsl01Y9Jr7xliYLzKCGaS33iVIPZtjV7SgftnmZjyXgS2vsUCgomeI4/z04oeh4s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 11:32:44AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 05, 2026 at 06:04:54AM -0800, Breno Leitao wrote:
> > Signed-off-by: Breno Leitao <leitao@debian.org>
>
> This is nice, you've improved my idea :)

Thanks! Your idea was a good starting point, and digging deeper led me to
sysfs_match_string(), which I wasn't familiar with before — it turned out to
be exactly what we needed here.

Having the modes in anon_enabled_mode_strings[] also opens the door to further
simplification. I haven't thought it through completely yet, but I suspect we
could consolidate quite a few of the _store()/_show() helpers as a follow-up.

> I know you change another instance of this in 3/3, but I wonder if there are
> other cases like this in the THP code we can fixup too?

Yes, there are several other candidates — defrag_store, the ones Baolin Wang
reported, shmem_enabled_store(), and thpsize_shmem_enabled_store() among them.

I'd prefer to address those in a separate patch series once this one lands,
if that works for everyone.

