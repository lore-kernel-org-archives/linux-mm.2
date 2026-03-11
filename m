Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7103FD88F4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 04:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116296B008C; Wed, 11 Mar 2026 00:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACC86B0092; Wed, 11 Mar 2026 00:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA9E6B0093; Wed, 11 Mar 2026 00:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C59CD6B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:54:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FA2BBA201
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:54:37 +0000 (UTC)
X-FDA: 84532566594.07.5B74B91
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED557180005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:54:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773204876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98XDsUoxbj1YEatno69EYjiM79GmvtjL+fl6JGijuSo=;
	b=2x3TKWEIUj30l2GtVaIjTgvPSnv3k/gNyBvh3QB58Tiu0VB4W5NKHjMKS0/FTT7md94QtY
	KAhx1rUq8zvDfgkmaVUuZB0fMK+pTLvI5ABcow/5SZB4fLvvGveYQ0qMOfMx0/Q3SaG16J
	p5BzLrhWBobMX3maXl9pngRDjX1F3NQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773204876; a=rsa-sha256;
	cv=none;
	b=aOeesS+KJuurLG822vITOkg8Ae22PwYwxBHTtx70lUSuU5yiud78FVePho/NIFYLbm3Cuq
	tF4Jpsh57Uw910p9ao9qfXh0DN04SEgiTSFvuaGNu4dMSXScs4tzzVZCVznB9SnbRBzsc+
	pnNClCJZtLG9BlEs/B5R5WnOUZIyzSc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 012A5165C;
	Tue, 10 Mar 2026 21:54:29 -0700 (PDT)
Received: from [10.164.148.48] (unknown [10.164.148.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEF5D3F73B;
	Tue, 10 Mar 2026 21:54:25 -0700 (PDT)
Message-ID: <5de784bd-d9f9-4331-9e20-6e50f6510e3d@arm.com>
Date: Wed, 11 Mar 2026 10:24:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mm/rmap: make nr_pages signed in try_to_unmap_one
To: Matthew Wilcox <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, hughd@google.com,
 chrisl@kernel.org, kasong@tencent.com, weixugc@google.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com,
 jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org,
 yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-2-dev.jain@arm.com>
 <21801fb7-0f42-4ad3-8b85-2ac6013b8aa5@lucifer.local>
 <31f93292-3de6-475c-b7fe-82ef41a3a7de@kernel.org>
 <04a7465b-ee69-479f-aaa4-ccdf3ae16805@arm.com>
 <abARQsqJ0vjg2VTw@casper.infradead.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <abARQsqJ0vjg2VTw@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED557180005
X-Stat-Signature: 1677emig4b9coap7cyhfemetis765sjd
X-Rspam-User: 
X-HE-Tag: 1773204875-727525
X-HE-Meta: U2FsdGVkX185NIsoYeZ6/ycTL7zgAK+TIH0qqOVU1hVfjlq/O+2QHga7rKaVO6b/dpUPdBjb6peZ53LCb+Lz/Fe9mO/s2qOAMdukj2QIeMeLrZ/o9R530cd86D9Q8X7R+lRDWpGfepIsuEEUeHLjmwo0SZtScuTFI8s83KbqI2Rvl6tCdqPzYkFd2ptPpaIYp3a5IylFjByd8sUIMWB+1V2a5B8gmmTpGvxQb0k+lVaR149qYQm+Ad4od8fP9J6mCofwHFgObjQ7kjzvedTpBdxsT8FvNGWqNAGpKCRfCkxE3Xh5NVrFGPGYKjRsLnbGIgSMYMnF5LqDM5K/dc+mj3g5AuFmvkEoHnayFbMCI6H26DMv23pjx/fUhy89BdCbNuDoTiPQf1cd5B7Og5GVKL7iuTmEvzrCk4yFtdLZIQF3govzlrzz4+RKok9/DtWZ4c0bcQF7rFSWbJMOE01nTFtftTSKYrIZGETYDc5nmBsaOyJZwU54GUPEnjGuQwrGAIIBCSQs6GyGXQltXr6GWbN0Ll12Ba38I9YW5an85OT8tk8HvQprLV67tM8E/PJszXd+fM9yDg7xKFCGBYUAd4UGKw2gqmSsWAMneZNn+M74lIEICo9x4p8IbLHMfweNhoy156fo7CAYV/B6wwe6nAsQGFf90rUvifl5HBUR4eVXhhTz3ctgUvkXgmliseynESmbYL399PVFkXpiMsSZ8NlPUYH8NoTzzgaw/2PkMJfGdd82sq2koMxiHpzIbeF25Htny8QmC/Dqs4qQbBlMwv7WNXSz53zOZcNKRkYiVQKl8Dw9nUkridEihnNVNCQbBmGgV1U86k0fGpATUkMPtl/hC2nB0lq4F22MEE+doj7vp0sldzqXfEyXstdOtlBUZcoaFpqjN/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 6:10 pm, Matthew Wilcox wrote:
> On Tue, Mar 10, 2026 at 01:53:21PM +0530, Dev Jain wrote:
>> So when I was playing around with the code, I noticed that passing
>> unsigned int nr_pages to add_mm_counter(-nr_pages) messes up things. Then
> 
> Using int (whether signed or unsigned) to store nr_pages is a bad idea.
> Look how many people are asking about supporting PUD-sized folios.
> On an ARM 64k PAGE_SIZE machine, that's 2^26 pages which is uncomfortably
> close to 2^32.  It'll only take one more level to exceed that, so, what,
> five to ten more years?
> 
> Just use unsigned long everywhere now and save ourselves the grief later.

Thanks, let us do this.




