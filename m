Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED624606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hqDHEe46
Received: by kanga.kvack.org (Postfix)
	id E317E6B05BB; Sun, 22 Nov 2026 10:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE22A6B05BC; Sun, 22 Nov 2026 10:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8326B05BD; Sun, 22 Nov 2026 10:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A846F6B05BB
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05E0F806B4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:23 +0000 (UTC)
X-FDA: 85463179326.24.4EFB346
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C73E10000B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqDHEe46;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362321;
	b=Hyd0qHNbgoM5ETnExX1HMsQTi9QD9Yb2yUx6FoYV62HY8lOWHDHdJQewE0rTHgAXWjlME0
	FJ3CO18i2WhsjD+cYxp+8ThxVQ+dOxMUsbkFcTS6ieV0Ixd6GDZ0C+Fo0lJbUHN2TXgcd/
	sLNitM826w1/eskHAkpWGEKY4IGKNcc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6HyvgrVnoNLeUBk5MVuoXgI9Ikn/Hd+Z6Svdu4Eqt4=;
	b=hIQt8yzBQ0IG+gWmrtl0LMbt69gtE9iGdCPO30ILmYk+cSMH0wiAWDK0kxS4qyhAlNCXCd
	prvkR0meX56jXxa2jbM6ZcZr6FwFjcjVuszLvdr+DfCGrf0N4gsIkJ6U06ABkRR312bbop
	xYNDJteL6ip0cDndjtVD59wjICEVdx0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqDHEe46;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EAB2861876;
	Sun, 22 Nov 2026 15:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432561F000D3;
	Sun, 22 Nov 2026 15:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362320;
	bh=n6HyvgrVnoNLeUBk5MVuoXgI9Ikn/Hd+Z6Svdu4Eqt4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=hqDHEe467lkxllXKMfbQqPDyhyP0PHHokQ3jYE12AG9DdEq7KUvz/RgsfttvAr4EI
	 wo6U5T0oq2ptRRRwTkJcTMeJIrOPaoXP5erSBcH/BbSP2cDylsg9HkksiAqVx/uG0U
	 zRdxJ6ijIuNAm+rvtKZtEfQZrX1zeG9pCfAfwZ/KZ8KgeAgOk/XFvwoWuHMmUuEcKo
	 tQUVqf7Qaw5bIojFMsvhCOoARSApRTPZWwlvlxOU3Alqdkuw6kgrJFRIqlUefprnO0
	 fWkOLC6ebRVBiYe8pHiVj29sngSNKcSToNo9PQriMaFEu0LKzZctIGGH2duEsM+BPA
	 RZEzLV6+vmwEg==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 04/11] mm/mm_init: factor out compound page
 initialization
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120100856.16929-5-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-5-songmuchun@bytedance.com>
Date: Sun, 22 Nov 2026 17:45:01 +0200
Message-Id: <179536230137.3933282.14696783498187127744.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5C73E10000B
X-Stat-Signature: rhui9xaczf9mi7yueidkhcj9yhyjn3ph
X-HE-Tag: 1795362321-981857
X-HE-Meta: U2FsdGVkX19tKfnuquJCSbaDsAP2pcyXDK4UgVhQ3Sd33MVHOqae/PnO7iNYLScU0ruGxtyfmRiYcZTcy4dwYcLy47TRIQPG0FEFbg6+X2YYk0sofh/LkNDybSZnGb5XuTofsQCTqzTEWHmfpqIb/TtMF2BxGXRrjtHPvzU3LUWINAEbkGYFd4ObAVBd0zoZ5hlC1p743R/wGB9eOm4Y1j22Aqxaoh0wiTM/R4NTA1kkY4piHG2MlEvL6p60Kne3VtGjNtDmiH4MPV0ikzjfDNqaZmI2pV/ORlH67X2a0nQPOVEGQqMAWLR3iUYaDNJJosZpBguAjrKq6V3HpTKCAh/IhhYs8COOFpqrPl3LRmNk2mWRlNcqSo3kHnNVFY/VGevVWEjhAeTZ9FCygBjFlTJV4z6fy1k7zpkhsJueuLNNMIvh9dmpn6NR6RwCSdcbIa1+qfoM+TqOkLwke9y6Q9fhvyN6TFEopRBU9GeB9QqZ2k/uhM7PpJgQ9WjnbqpxTItCL8LIY+INjBCILtjvUeh4YpaEKqNECiJ8fcpahzEiQ1Thvr08pMufky4VkWjjE8tphO/Zu6knmBHMYm306jA8JgT5RDwC2pNVNq3oA+sgMxqBWdPEDWde3AGK9vwpjOqy1ZOPTJnpHIRXE/K9SfaEEahS+C+ONaJO7P3pWHkp+NxVSGFDl3fK4i3pKscAR6DSAU8h8JGoZz2E8xOGIKfcHgijkps4L8qo6qExL2h/26cT6RjR6c22EdtfDlzNP5mjtmUwtlXfGpsSry/i2SuqPRfMn/63gngYGuBeBuwLPtgVHmb2u4uxvyGFOQpddKv3FQHifK9X+pKjbNeQe2DsCD5bWam0cWOYTCmK3GZRunCWOZ+FsL5ieJu3+5P8vckZ9dz1QgNCcXMYg4C4EwEl2IMDly/+ORFPCrU2GMguG2LhTpRVZQatrtia9tkF73EbKAJHpom8Xx9l78V
 GGqECr/3
 paVdghpvw8HbzZvlISLNFrt9NlR6Xfo50Oyx0tl6es1y093kl7O9uo9gbNJCX+hOqThkguAA1EbMBoYdMQB6POavh4H7SBe/AeuIrxzUSqn7IeVlOSrQ8WHhf9T2k3Qy7Lqrkz6ZyIXECW3erp7HRvNVbhLmNyiyQKD98V5lM216hFRlmdMpI3sx6oa6+3i1tw2bZ7a6W4XUiFKxnTHzxQR2tiyCF1uqbs9jeAZ2hTYJUmxYZ01/mP1iN1UR2bssX1gjGRH6NbGIQjJk2p2bwxZ1sdErOdig1LAZq2/M7H77vB5Hxq8ZN3H8GJH6GyL3W+T0HTH5e3ig1aoHepwADefNFXZIoIzznkELZQbu8ipzXIUT4vDRKQgkdUkLiM9k2Eb5Nl/9bXOPM1THKcx25+m+IV4zst9sgJubFuV9XFyRvHLcKUwtNqtADsr/aWxaZzGMGk4as7/g1d3xXk/hLoQwyT/Raxb9RNi2fryH3EIdWNiv8qTLjIiptPHpYTbrz71eDnDIalH1eu8DplNhE55qZCUr1eU99ZL/c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 18:08:49 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> ZONE_DEVICE initializes compound struct pages while their refcounts remain
> frozen. The setup is open-coded in memmap_init_compound(), including the
> per-page initialization and compound tail preparation.
> 
> Factor the common setup into memmap_init_compound_page(). Keep the pgmap
> association and MEMORY_DEVICE_GENERIC refcount handling in the
> ZONE_DEVICE-specific path.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


