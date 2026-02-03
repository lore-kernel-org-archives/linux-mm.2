Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA9DE8304A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 03:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DD3D6B0005; Mon,  2 Feb 2026 22:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B246B0088; Mon,  2 Feb 2026 22:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D026B0089; Mon,  2 Feb 2026 22:36:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6678D6B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:36:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E30D1A030E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:36:11 +0000 (UTC)
X-FDA: 84401732142.20.5D0EF9E
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1115940006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:36:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DhVo4INP;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770089769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJxP6n3p44LkH03IkDqQsgS+GpBo2zU5MsWmp0JlB5A=;
	b=oN0T8yvuK2y/BI+FHCB+6frPVc7UMlwS22XFUeLrt/zitD4SgYXFSHwH0Hvf37Y5X8Qkfv
	hQThtbtgVG5Qx8hIE99CxZJT5uGgMLltAxujVtrEgz8bD7WShoY2Ar59CTjp0UpqxqKhcl
	tO+NvYR/4npY9adakzdprk5iL6mGAmM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DhVo4INP;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770089769; a=rsa-sha256;
	cv=none;
	b=dKun4v31zVOTiq5XS2on3Myr5LiYXJNyM7Br1ndRxCBB/MahYShMzmDFOTtFuivM8YWntL
	64RL4JLjrn4qJ8AFoGcYuMsiG38u0Q7BpTWBTk72oKuDzcq04WejF+5XUEZnWq6tbPRbE9
	pHHurgQeFtISydX/X49r0Hmqy2d4jgg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770089766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KJxP6n3p44LkH03IkDqQsgS+GpBo2zU5MsWmp0JlB5A=;
	b=DhVo4INPC4Ons8xaBCpPzhhwL+sntJgmv9IgIoulLAZYf4pzz3ZpnHm6k400LdHZDLpymV
	RE4bhGg4+b+2pq+2qsmy0OYtR5wulCSX8hs4mU+edMcJEJJyb/vV+yKryUukukDMjvejJ5
	5aEU0wJ5Ls+w6TvtZLrP2w07z99oZXw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv6 09/17] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260202155634.650837-10-kas@kernel.org>
Date: Tue, 3 Feb 2026 11:35:24 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <C310A603-DB7F-4140-B045-7F1E3CC98C05@linux.dev>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-10-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1115940006
X-Stat-Signature: 9smy9syxbjpspndz7q1io9sza9a1upeo
X-Rspam-User: 
X-HE-Tag: 1770089768-857732
X-HE-Meta: U2FsdGVkX18HJbHszi1vCa1i7AlOUBX8bclCFU8PkM8z7uSPyZGFS1MdDpQTuIfTm2DQpsgWwuinrH8gSZ9wZ4BDwRw9c3y9gHodHR2ZxTGuNe9DQnudiy+I6JqT1enn9mCLoXwoAFpkOadCCK9gUY7+FBF+tcj+Nmecj/aFt1tZjAQ1PJ756qfCBOZqqSrQUMmMe9q7Uf7wp6kYQCW6EOVxVWc8YrsPZD+cSQ4KrkSmvprUIcef16Qf7nDfnS0/+mn7lsTe1vPy1EsjmoeiJ0Ow7QdRitGewp6kN+kfutRMbyPuzrBIjLN13XtzZP0xXoaCJbLorxoSENF9+ve7kRQcPz+2M7Uz2HuKqMDX2HAcP+qtYp0Etuocgg4V1st9qvA7FCs8KYd4C7ZgZXOydJhGDpwna44AD2me1ZUfBgcm7pUneA1ZVwFPUr8EA3MhZELjBvctSVImhjmWvKdMajmOfhRspastqy9Bd/zFz83MWoSJIXjM4nDZA6t9Bci9yZPegetGjCKWC7zHWB+wfH1+hp7TTpjHdHaJrhwn4S/6j+v96O+uoxLjAQ81rfdJHKI3tAS43QU4/rkbhCeoIBgq6TjRWVir2DcwBW5JRX7KCooeRhZiwaY4Fh3EijXigXZj+rkIzhiRPttfDSq7fEy6t6TLLldA5cp29xUC17Fq0WPnbaDnh/N73ME1knRndDuurlSA9jfxc+V9PUcGMK7Lz0UYPOA6rR9NfztGIDmBmqrDnXCVrfe5EO0AvD9R9MfFmw4fAinirj5qLCENqpZokCypRz45bE51gjpd+JQMEAD7lfvudYq4Aw/s2d8ianp3o/ECVlUVa2tRrNECsNmbTcVX06v9SOpxu1NXoibEkLa8BE9AWt4c6jnK6v3B7HXiCXhQTHcohdCSbLzOjETX59wH4VaFj6xE9r2hOCFo85HqiuVM8/rbFzuegeMdxQ+DfzPBx0lDyzIksMf
 G93cBTIP
 Cf9le+DmSwlMkw1lXu1yULvoaNL7Pli5okZthxWCnXIPen6a90JHO1FyMHGHOdeRyhi8n34ZuSkT3FCzTe37v2VxGTM8vdqJP/gJbpaRvhjds8rW04iyFHTFMogujs2JvvynLWBtmOt8msbclyfYPWApemXiYk6U/tz7kOnkzNPKlHqe+Zkb2inhr0S3hLT64Ahij7fjxlos8cq5vLoFEeFqy2oCFCGCUnv+2A/zciRsU96DRy3kjqhJGI2UCkaFryLmwuK4H+sLoaHA/A4QXQan44FdP16XJDtBXMu85As3/+B36Quc3sRWyrzisOHrewLsqBeNYxBpMh5k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 2, 2026, at 23:56, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> If page->compound_info encodes a mask, it is expected that vmemmap to be
> naturally aligned to the maximum folio size.
> 
> Add a VM_BUG_ON() to check the alignment.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



