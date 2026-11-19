Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A34606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nsjvME0P
Received: by kanga.kvack.org (Postfix)
	id 9B8C86B05E1; Thu, 19 Nov 2026 04:21:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9699B6B05E2; Thu, 19 Nov 2026 04:21:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87FB96B05EA; Thu, 19 Nov 2026 04:21:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6871B6B05E1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:21:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3531140867
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:21:53 +0000 (UTC)
X-FDA: 85451326506.14.093EFC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 51815180009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:21:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsjvME0P;
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795080112;
	b=mnGMuklTxDgzzkozG2dhDLc9HLAYZaoWX/0Ota8DBDMUUglrkV/xqsGhrAgm3+905XKdH3
	Cm4XoeGJgWl4Z1AQdmqpqi39IITW332LcUOtu280fwUDtuX2RS/W6mRMJ8lvhKaOx33s+1
	ktVzSmiDqD1NaIIppwwyFsEqUQx0IBM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795080112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Wr5mBmCRIZACCxxVm/06jDLVb0/ss7nm5ggZMozLNA=;
	b=aX+GUy7tvXDsVLP6161VAJcO6eEJBubid82RYX9KNShpvz37o2AuseF9KS2ILqZ8BC2LaY
	l+0d6xwGHPFvBNKn9RXgD9nHI69DYWXWVOKle9vFrnHLpCH0EiY1/Ec4Z2Ts3vUesYHr30
	3pZmYGtQ2ESFIuVB3CmNPmsoQlU18oU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsjvME0P;
	spf=pass (imf16.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7300C4607F;
	Thu, 19 Nov 2026 09:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CEF1F000C5;
	Thu, 19 Nov 2026 09:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795080111;
	bh=5Wr5mBmCRIZACCxxVm/06jDLVb0/ss7nm5ggZMozLNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nsjvME0Pz0scMadhgpwHZPUo0otG94zFoSunBqCc/ZSA51ayJFG8XqUgDzzVs9Kfq
	 3P+ziEEQQJWx3OysvzemIRFFeoie9jwxaDw22jftfAxZgwFDyhMCvLx5A4P3f8620s
	 1eWHtIXTDL1mhK8xJXXRt4XlGQI/HnGU3ZC/PIv/tfgU6XMBYyWP+YwFXlhGUaJCg4
	 ZOdBHhg+WiQFjUzLs9J5RL8/A/ACyTs7vPnDwfbaENEsz0bqTu2Jtq8PFV1wXKxqIC
	 lEi+uM3OYdUCpyTUH1K3L12s49gJNUVKHPYKHuEktEtvpC35sURPiFFyWMN6vajWEG
	 E2Ax/gq4PoIng==
Date: Thu, 19 Nov 2026 10:21:39 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@canonical.com>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
	Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	Chris Mason <mason@kernel.org>, stable@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v2 12/15] mm/hugetlb: keep surplus folios that are
 reserved
Message-ID: <av6_o6kr6Thpc0ds@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-12-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-12-4dd9e94ea9ac@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51815180009
X-Rspam-User:
X-Stat-Signature: pwxjwtpp7ua1qux8no684ckoyct4exh4
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795080112-626779
X-HE-Meta: U2FsdGVkX1+9cZxm4CtyV1fmZKoFq4UPNBQKWk7/2dn0tnvPJxoRn13wBSC7rmRZrhfQNrrFJbjCMPfkYOViYhrjeANlkIRaOEMq4hz3DsJqr/6KO4dJ49JaSfEFOMQr3wh/6QW0wVVgZt2PqWrfI+DhOefYNBd+y8VaXowjuz6CxCT94oy7iiQ5q+67+G/Ci04whF6ylb77hgeLRIM1MoBTRIdRocDCG5UQb/HH+QErYeEmdBrG8wX27MMAC558/L5UfjCedz5pz/vBCMmAwkByicKuPgFP/LtPmpxFsPiUISLWkt9UnRicgrhc8QBQyDdfQhX9fNSAI6zpiydG1uU/D/y9p6iUMF62ktku865u+x2zoe5n4R9iH2gbBYrkDtSRSJTYPWLB1IPdCqDj64xkyDzWToK8tuIvtaHnHw4J/X+iI5EXqpzr1NuICa0AfBDmsF5FCPgDpST4xQhSN8wJPjatPl8tyh9h9gzoN13kNOnnNHxHt7qqhnPR6d9llQxQjRqQc7ZD065nuj1VP3Zfmow1W4e658LybfzZhMhHkgHVVyor695ZRBJTjd1fvVpl4Q8IIxlARaQm5+Y/GHMyHmslBzdO58MZcpObGGme3e9GeyVNgJ8ThfALmUIRLa2MonPO+pGSpJzOwpeOKUVWtHULIwvPoKQlts8KMT0ha2ytbkskVrrw2k0lgO2/vsSmNViSJS6W2+tm3Mf7aiObEl+B1AqYlSky1dNtcNJcBqtZYjbquxsY77qVxf7+J+5SL4k1d82+IKNalJGSdSfXP1TFZd7gj12M+G0QvYTxr3do+7q9B/pfnXvu1kqMgMwLPyxuh1dNBSndd0DNa5aKW1ZSD9dpZ6rQHccF+B+QxADeHUKRQtbOqFTjmEq0rIrGVBnaectkGjziAZnDrpweuOqy3bdSay44CtKoERAqzCutpt4qblvpHHcBsejPAEiKGD6jTQFyvLnfjZp
 WEECH2/K
 6itDyOXVD7Q7vQsSgo2QdHbl9V9ExG4NstGcPy89waTO9hKYBnTkbAfcAPDU8a/AB5sH3pM8pY/kFLU2UslIlS3EP/M93Hi7JTEm+yRL4+iWmkDvvD4vvLdnLSeIZgbw6iEvVjdS4xzZjYVl6p3beJyyjknogbdekCX6Nsh7mAm30kp4mrcjQK2e56LLznrLDKK9ggPD+AyqfTQsZt/U1TOdegNn4KD8GQs+NRqxl94DHcOGYCmT1LulL571O565Y6gHKv3Y9FY2z/XGPRgRDg8zMIzV0g5iGo1nUXPDgW5V99QjZ+ZCqU89V/S0fqInPd95FVjq5b3Q4V5g+AbXULRMe8wAE6/Pr3ALzY2Uu/M2JTX8fWQMt0ecLnO1WlwCIddQaVPQPg0TwTm+HE+SeAWtEABolG2D31B2rKQ7wlNJt/QYBralTSm3WgNGW1vHaxH5evtEsAsj7uRudczdnsfS+bRsN+0D0ZHuAELNnfnOF5nFOJp5j316fkT4ZNMeyarYebscmtL2Gqfvu8fRObWBVlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:33PM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> free_huge_folio() may restore a reservation, but still returns the folio
> to the page allocator if its node has surplus huge pages.
> 
> For example, start with no hugetlb folios and allow one surplus 2 MiB
> folio:
> 
>   1. Mount hugetlbfs with pagesize=2M,min_size=2M. This allocates and
>      reserves one surplus folio: free=1, reserved=1.
>   2. Create a 2 MiB file and write to a shared mapping of it. The fault
>      consumes the folio and its reservation: free=0, reserved=0.
>   3. Unmap the file and truncate it to zero. The mount's reservation is
>      restored, but the surplus folio is freed: free=0, reserved=1.
> 
> Besides losing a hugetlb folio that is required for a reservation, this
> can also make available_huge_pages() underflow and cause other issues.
> 
> Keep the folio in the pool if it is needed to cover reservations,
> including any reservation we just restored.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 07443a85ad90 ("mm, hugetlb: return a reserved page to a reserved pool if failed")
> Cc: stable@kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify comment and description ]
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

