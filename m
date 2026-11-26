Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A742606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQCyQK5O
Received: by kanga.kvack.org (Postfix)
	id 795696B05B0; Thu, 26 Nov 2026 04:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746406B05B1; Thu, 26 Nov 2026 04:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E6A6B05BB; Thu, 26 Nov 2026 04:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DAF86B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:55:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97E6DA8A08
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:55:39 +0000 (UTC)
X-FDA: 85476813198.25.12F6586
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D2188000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:55:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQCyQK5O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795686938;
	b=JKLmAP+4Nsvom38bypuI8vDRHf3DG9xyy9kgAycj9VQnp+bFkMumwFxuDCffJCYE9s+RfJ
	0YiWQaQkA84QYUVHHZqpM401I+ksosmr8GT4pEPHowGCwiOHH5qavKqJLkhP81rzeXRlor
	tD1ySmWReqj5VGd25MRpmMNU0exEUlE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795686938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zG6hcFBKaarnvsPjlDpXRoRvjH17xCtphvN+Zm9vGko=;
	b=rZy53pnNuinl2XrnPzL/HF39Tfe3cWzBQt4tfypUCeekStBQvdfHPGqanAsNLYMYD2sF3d
	fIMtUxCaq+lvQTGdj0VMgtN3Epf7H+Sg4EMrmAHdgofoVcAs4CaRmco69WVwitVQ7PRkCZ
	5xz5GU/EK8TkvnMppECu1Rk/ISfORfk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQCyQK5O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 558C462F74;
	Thu, 26 Nov 2026 09:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1558E1F000C4;
	Thu, 26 Nov 2026 09:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795686936;
	bh=zG6hcFBKaarnvsPjlDpXRoRvjH17xCtphvN+Zm9vGko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RQCyQK5Oq863s9k3aYw7AiGhCho+53i2v7J+kSej0aI/ocNQVdUq4lvFt6yS9wDZv
	 eCN9kR32v3YmlB/SCi1D7U1M3Yghd7ekpfHMVmDLJ8msrjkNmvWAaj900YHKs1hvGp
	 YnX6O6H4V9W/1pNJqxgzNl0xLKCS3U9TMe2E71AQzKN9QTE+sPrGtJJd1otT7qyw6d
	 1WR0AjIp4ETTblf/GUeArbyJo07h2JKtDDX5MXID8jJW5XoE+vZDJEI1sC1gAFkyzh
	 wzsEQxIclL9uLGe5CKnhkKSuyNpSFlgLP/eSEDgwJyAr1fkfLDBR5MgGx3D4lV2p2J
	 rl0qGXU1iXcDg==
Date: Thu, 26 Nov 2026 10:55:17 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jinmeng Zhou <jinmengzhou22@gmail.com>,
	Hongfu Li <lihongfu@kylinos.cn>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dave Airlie <airlied@redhat.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Dave McCracken <dave.mccracken@oracle.com>,
	Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Yang Shi <shy828301@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>, Gregory Price <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>,
	Wanpeng Li <liwanp@linux.vnet.ibm.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kenneth W Chen <kenneth.w.chen@intel.com>,
	Hugh Dickins <hugh@veritas.com>, Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>, Joern Engel <joern@logfs.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Sasha Levin <sasha.levin@oracle.com>,
	Guillaume Morin <guillaume@morinfr.org>,
	Wanpeng Li <liwp.linux@gmail.com>, linux-mm@kvack.org,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
	linux-doc@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 01/21] mm/hugetlb: charge the copy made at fork to the
 parent
Message-ID: <awgCBU9wSBa_mh1D@localhost.localdomain>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-1-db27fd2f71a8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-hugetlb_fixes_2-v1-1-db27fd2f71a8@kernel.org>
X-Rspamd-Queue-Id: 0D2188000A
X-Stat-Signature: qe3b41omt3ceeh8qq3fiw9n99idrhg9n
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795686937-739439
X-HE-Meta: U2FsdGVkX19mUOKdYaY9MvcmiOTh5lgcjdjmyl9LacuJTwbEbv3s7VwDUvMWI7nQ6gOT4xLEUQS8ywhB1jTaU/OSoY+SqbEy3LG/dCxHYlOKYnVXxtwhUDs0PFh/5HLehE6+rTsLIrKPHdYvWC4nP2QeaFQz+ysQJVlHNqXIoogMITnBoKnNLSmhUB6UHBXeH0/iGHzKsyEFq7hA8fhzSKZ7LqtfxHuiK5IC3AhICW3ScEDN/zMFsKkJxZkLDZx9XzUULjMysLGg46jQQ03bU0bioMJ080g9Il8J9fJmsBijySN7v3kIWBUhEZwTZFf2F+U6c1ZrFsBGjz/cDUc6F+mT7V1JTdq12vzNbLRrESiXa1zSikLEZ0rEq0tnT0GOWn6Z44G/yfXBfs0T0TxXsghbGLfDee9iDqkWWpqPwmVtdyXOO/fDAXDjRMdXwGwXcbPOPGCutBhhUMFUDVAuup0N3oTWOwtneNOYI0VVeO+qqLaUcHRZGClOpb0Pu/LfW5emd4LSzrwN/kC0btGcwa52RIfLEc+PIZ3uMKDTNoPUBZ7a1oM8DeKAZziTxg60s5i2tHFVE7jZBlG5X6nMciOssgjuYb+eqsy1bbDk5ohw9syziSiEFkaOQ7M5taWbNgxbU3FkzZUHq/QesNgp23h7tXfyq+Qw3bmoF65wkafFcnHw/HtbXPjmpm92hYowMTKnizAkHOM+WdJJndzUItL+e8gJ7bJy02mae8JmhsQDnUsPZ0GtHJlsOvdIQiXCXL67zgZC4Mm123e1dxjn2YhbT/ffutk0xHtGEyZWDL8n3R88PmryRLyTRM28kKqqHVpqqc3CjtobfEuE00mXub+LY4tJR+o88EiZ3lV1t5mFxMEaYxxSHYBi6E/ivHEay0DP7dquCncA7gcKJwetcFHxgKvLQWXVBAktZlZ4DcZiXhiDXB6t8kccfC5AZ0TU2G1KdHkC77f0iRUszVU
 N+ZTSEVz
 CejnftU3VnsbZK6OJGDXbfDoSjMXyk1P2hGlE/c35Mqy/dyfi+y9XeEfPI/kR2IqijyDHp1hGhHpzk/ZLRRgWlblhAgMsiAylToEVUoeiqFIvwFlnApsuuW7kLkdC34dwWL2xcnsNHv9iJEZG2oSLGi/8/XCTrcznpv8DFwnIkItBH4DRlykMrlczAT+iyvgvOGoe5bESk9aWPJ2mm38jrbGmeKdqpb2iQT4I2sC/ML6JK0FQPiJ7Gnxeg059mc/mQVrzIh6dzWhQ6Y1xGyjNUZ3Yt4YCup/B50Yp8kGh57ZeWn6fWgvUSmLWwi/IlMx439PSbwKkm+SMtr1Uj0tkbGLoh0HLvFT0mV5WJI4W746nhmgYtgeP9afOm3Eo8L9Ezfi2HpNeLlPRXnJRh0PIaspg5r7W1eTVU1lf9nknzHx7AA4xoaqpY0kuTKWKPvyvY4/T1lrQM1NLvRSf/hmA1scWJ2Z96p5yLRgsPWmsiQPLTmZ02SbxbNYp+U+P0d5N4B3bsBQDYCctJHHvvjWa1vubgUsf8iG2z1GKAcsLLTO+OZOG33zBZHHor65kPY4tlWcgJd4gZp/+fo33fl14UtP0ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:32:59PM +0100, David Hildenbrand (Arm) wrote:
> When copying page tables during fork(), the child is not yet assigned to
> the right memcg. When copying possibly pinned anon hugetlb folios, we
> must charge them to the parent's memcg, otherwise we can end up
> allocating more hugetlb folios than allowed.
> 
> Let's fix it by charging the copy to the parent's mm, like we do when
> copying small folios in copy_present_page(), introducing a new helper
> function alloc_hugetlb_folio_for_fork().
> 
> This is a hotfix for v7.4.
> 
> Fixes: c2deb1356d82 ("mm/hugetlb: charge folios to the target mm's memcg")
> Reported-by: Chris Mason <mason@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

