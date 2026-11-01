Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD12606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 06:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ko/MkeP/
Received: by kanga.kvack.org (Postfix)
	id C5D856B05B2; Sun,  1 Nov 2026 01:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E286B05B3; Sun,  1 Nov 2026 01:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFCE76B05B4; Sun,  1 Nov 2026 01:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1C76B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 01:51:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DA28A85D2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:51:56 +0000 (UTC)
X-FDA: 85385630232.08.1EBC52F
Received: from mta1.migadu.com (out-211.mta1.migadu.com [95.215.58.211])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9D236140004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:51:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ko/MkeP/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793515914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuwGBOzAiVCP+vrlW5UwmQsu01V4i5/BJRy78zItdGE=;
	b=C0EJnFYKh0ZF3SCqtEMu4FKp7sMOBeFua8Q2SUAu8lYE7CEDS4IPide05+o9AJcDU1NfK2
	EgWHph5OGP1ZUt1wu3j9iVGISr7xkaiFiuh4kYC0NMX8FSpAyu3IB44oodGIk5ht5Fq/Dv
	MvLZ6AEFgqNV4S9KipsUYDzbP/+BYw4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ko/MkeP/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793515914;
	b=l9fxiwg0HyA5osgqd9s0WvsJKQey9mjxMPuPoGI3W/IZaEC9SHR2XP7pPOA8wkLjhCK/hx
	p9qv3DNi5hLz6DhyC1C6BZC/k5hRE1I+/mwRkXJB+RacGqhtgPWNu5Mj/3ji6t+5UcbO3A
	6yXERhmvJknrVqiaKb2RoJ7wHgwDG24=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VLeE2/rDXpLDVi9e5DrH1IIJumuqSoLutYfcLgv+pXA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793515913; v=1; x=1794120713;
 b=Ko/MkeP/JuNRQcANUqPeEjZdTGUFRZxfe0Z8Sv05EKfQJ87wbcFQnbfn3Xwgno6gb88NaTEX
 Mdfqr8dIuqvo2Q2KNGq22CqfsBd/gtugHlAWAebky3j5j4iT0t7KmpZgwuBUHoj5E/VNcIIiJBS
 MjIhgDLZ4eEhHtK3xHUcDhwY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 43a291ed986079d8;
	Sun, 01 Nov 2026 06:51:53 +0000
X-Mizu-Trace-ID: 43a291ed986079d8
X-Migadu-Flow: FLOW_OUT
Message-ID: <2fb322ca-d54f-465e-b342-cb4e3ce55621@linux.dev>
Date: Sun, 1 Nov 2026 14:51:47 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/12] mm: hugetlb_vmemmap: unify writable vmemmap page
 preparation
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-4-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9D236140004
X-Stat-Signature: gosx13kz99hsnxncbsxz845jeuf6dd9g
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793515914-285394
X-HE-Meta: U2FsdGVkX189z56aIiZsDfHMMzcCmm/AFDF4GtASUMhXgdMMiNKOS+/geVbKMcKuaO2c5Q490tbVaAiBKQGZ32R7lgUX4Gh+LZsSTotuppG3OylYbfxjDJ5c7OfyEiqonAiMS1jmfGzTRcWh/4vjwD9mt28W1JsD9ehemm+fREFxTqnuYOm8u/dX/Bl1ZRh0y+8RzEgrBsyZJBmVXgLEjkSCWjN+Vyl55aDXWtld4nzJkvZzS+L5Bsvw/R0/8tx/j7nlbqvZRTNiEuL6U8xUPEySBOhDkm34tIv3owjJ633zMPwQy0HwLgfACQavPvSLm+1849hdDWBeJJjRK9/+ND9NdSmiaq6LeRei7llWHAec5ZWQdQZrz08fzrsllBBgTt0/Xpv488giId0KQbdx8LayHv/gNHRalQX8ERmtJ8tsnaFCTZcibHGn11Bx5eLdOS1h4aylLJ8Tu1pEeGFlIieXZQ8edkbuRLVnaQnhSaGOKIGqyeriOt7AfVTTVXeyipBFiCPVfA3wmsB3XpXOcIVwtiBFkoL7ILXLd9IzqI1GIT88JZkjtZZRg3sysiyjb6IdmrBLWNtQYgloNMp/uKVtOPyz76HYJKfpZX5RFuECSpRL9sX4o7/nz0OTkA/k960A6KgVAktBzmBCNsFOffNrVFd/elLXOqtWhbpVK+c+Rix6tUX1w6zbulANw/TpA3okJ+jG4d2VwStcmcRjzc7t4aWTC46OJt52J33Yet0y4rE/pcio71hZHYr5CHxuK3l1UvQmUk7zevi2CUIuMMyL1DxKXbNV1PUC4ALz2+NUB4+G2VtKmdII2pYXjPq5cxCHbCRXDvPj9svMsvCp32QkmW4J6fjaVyu9asZt9iOZAh4rGc/XliwX8fahcM+eC+2cmua/3Eck2ktwYj1wq7Ky7Ouk2hiOByrHY5crmf0dEGVLjyxhWVfjuy61d1Z/M1bxtms59vM7xiPEqx4
 pvFRQqWo
 L2m9uu0jRLIYYYtGkTj2e06Yapv5n5BK5rItdCRL3ymsh5odX2FbXTwcccePkTXfmu8ByG7EfrtwA3ipbpXNQGplOQEXtI0hWxWBbDMzugTiwbHyUV0U2NUmH8Yx26Z/qLa3dI3SdIL2eRr175+zG6UCwIIV6G9uB/Jxo9M+LuTYEY4wCJ/KPQw+72Mn4jn0nm9a737+kWDSvzUeeuwq1ledjx+0FrKFNc9OaCFwg8GhB797rZhBy/4rfrS8BkP/VXw+UidsWSo4qC/2CCj9NSwKJnr3yX9viObs+mp6XAA8toDVlzzz8C5+hHMfhNI3US8Me0xhkIpUcnSjzfbPxegc8KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> Installing a writable vmemmap page requires consuming a replacement page,
> copying the current contents into it and making the copy visible before
> publishing the new mapping.  HVO currently splits this sequence between
> the page-table walker and its caller depending on the remap path.
> 
> Centralize the sequence in the walker so all writable replacements follow
> the same copy-and-publish protocol.  This keeps page preparation with the

This makes the copy-and-publish protocol much more solid and easier to
reason about. Nice cleanup!

> mapping update and removes path-specific handling from higher-level HVO
> code.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb_vmemmap.c | 40 +++++++++++++++++-----------------------
>   1 file changed, 17 insertions(+), 23 deletions(-)
> 

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


