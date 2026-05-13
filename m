Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B70CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345246B0005; Wed, 13 May 2026 13:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F56C6B0088; Wed, 13 May 2026 13:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B106B0092; Wed, 13 May 2026 13:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 130446B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:38:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B87A91C0EB1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:38:10 +0000 (UTC)
X-FDA: 84763105140.20.42B9382
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id F2FE640017
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:38:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KXclouBc;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778693889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSR8Ee/AWnC0FCWd3oz+gFFNOdQE3fMUj7hqirwbauY=;
	b=rzV57yoPo82bB3CAobLBUJjrdIS73nn4NPu+RvkO7kh+mqK/bDviFkMhokL5i4gwqEFzsb
	zSG1GbWPm+M/rbQ6Fs+tEcAWPxh8euQOm/R7uFRRI6oJKUxMDsslUuV5F45sLqcHpEH3+K
	uAbXpFMYcSx4Ux9u07z+FNG7X5hV1PI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778693889; a=rsa-sha256;
	cv=none;
	b=sA52YVkfHbYdtwM77BiOK3dLdG/6PP7R4tcgLQKwDS9JVGMAk4wG56LP2f8MByjwJn0qPj
	viNfMwY64/a9UM6X+rpnsg58PpVzkDzHtTN8qVlC2YiaV43JprGuZuI88AWi+6BVrT1dA3
	4sihT47DYajjmDQE87m6iQRweRW90ds=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KXclouBc;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9FE04304A;
	Wed, 13 May 2026 17:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D582DC2BCC6;
	Wed, 13 May 2026 17:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778693887;
	bh=rsip1DDwsdG360XbgIRx/1LGp5r5fvNgF7AYUVqhpUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KXclouBcy6lsmCAD7LiLS3b7oxlVP+aM73apIEFrcE5S3iKo7JnqCjMDBr2TmyTuB
	 0XRaHz72RuzZ2Etk8SqeJ+4U67npQxvclZfuuO+jXB9xWGDXnh/VUGwlUqcBvtRqN2
	 vOlGLJAPX5B7iTHY8H2crKbOXve+/xsU2nA2HESu+l4/e0VWAJ+wmMTxhJ0EH9MwK0
	 qUgxYGhpos0o1p10guBMecfQz/WVzIKmNmdp5MFcKu14TQzz9/RSXWD3KPQQKrhQTU
	 dNIyuM4XIejkVYeWJz6ARV9P204yAzfrFoDokAms3OTMgF9l8BVi6AS++03BPqIPC6
	 W9GUIiNAmDgtA==
Message-ID: <dbbee174-aeaf-40e9-8942-425580a8ef3b@kernel.org>
Date: Wed, 13 May 2026 19:38:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/22] mm: Add __GFP_UNMAPPED
Content-Language: en-US
To: Gregory Price <gourry@gourry.net>, Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, rppt@kernel.org,
 Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com,
 reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski
 <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <agSkMV26nhYukbnK@gourry-fedora-PF4VCD3F>
 <DIHPURUMTESI.1LP37OYJN1N31@google.com>
 <agS0tVCwESC0rC9E@gourry-fedora-PF4VCD3F>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <agS0tVCwESC0rC9E@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F2FE640017
X-Stat-Signature: gjkagschkbd4qqppfuzwxym5kbfwa4wy
X-Rspam-User: 
X-HE-Tag: 1778693888-500367
X-HE-Meta: U2FsdGVkX1/9mSRS9rKDiC+tpFAGw+xAxJrjMuP8We0NhgZHs2ykEk4qR05j5CyVuEyAf6KV9wTsk5+5zg1pCjJrBM9CjqZvZ0q7BmJP8NXOoHtaI6MLUrRAYplMfNuL6rdFXgDHkeFI8Ic4Ps/l+3XaiVvErio4a/GGdZemkH4yiArThQFBbZvZndl5+RiHztzA1C2jV4cUNMJPcJldd7he3wC2+uonYcvIyvTUlcz/jBMtQujXkbk39F9pB2OhHbNaZs0Fm3ai2TLgZv1uiNHzQJzPyI7bOTJy2rbRpDfP6RTt+g9UbSwCFT4Bb2FSvPIEx2JvkHYV0Kp9Lq5RgEj6r3+eOH14J38qdIkFE1/zRRhiOFFo+zQpfl8KR/O5Fu0Lr4edJ/lAgU1cmbbYvPlUzrEmVxGP5pwE9Rg+xFIp7v0tiZILfeO3zHbRkKeCpIYKhcjYj8qXgURJNYIa7nkSs/1kvg3lYkfvrcTEIahfEJ8qF5x9fmpQ29Vk0Aq6cFcLWjKHjGVADtw+eEiaTvnc1FAOfurs4HxTCKBVX94H4eYA0u5sgPws0Eu97/BcfG5Hepdy/4glFViGoQuSxr94XXOT3D03vOfX2tPZX7Yij+1KFPmxUWj45JLwt2rB8TWeduS21GXWCGpkZNUzoE0zT5v3Xl+XFgnFlQkZQ4p7GoXTfwJ3lDxb4Ga9bvxyIl84k55O6T5PP5iNHkb2P+bBIQNliZwytFqmGtP4Znm+JjQyFgFfXrWmqfvXxx7a4dxI2BRpvi4tQ/C/RiP2fu1n39delvkEXG8Kec39kiLOcqMbCSrSBKjEcHn6ubmIEHotTp06hmETkg20aIbGXh552T5q7oCAkJPYPad9/QI7j9abL523Tx/AEkZBOnPcxc7vbUqxGoChfhTkPDesHsE4f92kMK1dNhMB/Xqjlm0e06KWTfFaxJURzdczDb8iAZrpPwQ3tHUiaEYn7YV
 3wHWEI82
 igCvgjKlxJO6Ur5bV7ai1q97gXGIE1RJF8tv3fDRvj2cpb8kSJjMttE67e49wU2XfyznpyM1rVxOVDRa01dEaE77fAVxlk/GrJLqnjNN0gEk2/KiKn/9mIFUD1UphbT48+DLqCEtCADt8C4MYhuQMNxLPNq2OSbbDMuN9WcX8/WsiKatwLClY/euCRxBwTgPTwvY0/Nxc+baJPXuMmG4yFhM+h7dknFRfiV/Fow34V9VktJVB4ZQfuGIooIgrJjX2hYxD1d3BNUnCjYnWGYvGqYUua5Bu62os5/D8G5jKhPIFLvaQAFkgd38CxbafoSnDB6NtyFD4njnvGPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 19:28, Gregory Price wrote:
> 
> Hm.  I'm not quite wrapping my head around the TLB issue fully.
> 
> If there's no kernel direct mapping, and there's no userland mapping,
> the stale TLB entry comes from... the page formerly being present in the
> page tables and a stale TLB entry lying about after the page is freed?

It's the direct mapping, we assume it's always there and unchanged, and only
kernel can access the contents through it. So nobody flushes it when freeing
any pages. Userspace processes can't exploit anything stale there, in
absence of kernel's UAF bugs (or e.g. Meltdown like cpu bugs).

> If that's the case, that sounds more like someone isn't flushing the TLB
> entry correctly when the page is freed or unmapped (for a transient
> mermap situation), rather than an issue to be handled by the allocator.
> 
> I think I just need to spend a little more time understanding the TLB
> issue.
> 

