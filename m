Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841C1606A337
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GPX3Wl7F
Received: by kanga.kvack.org (Postfix)
	id ACDD26B05BD; Thu, 26 Nov 2026 04:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E1D6B05BE; Thu, 26 Nov 2026 04:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945BA6B05BF; Thu, 26 Nov 2026 04:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26A796B05BD
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:57:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0B484038D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:57:00 +0000 (UTC)
X-FDA: 85476816600.05.BDF3277
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 06EB620002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:56:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GPX3Wl7F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795687019;
	b=qti/KWitFF/rQtUGMO2wdD4orwZKo5FSSogWdmulKWWL8WTSZ5ei1QcFiqU8dwMhnRE62h
	5j9ev7S/awY7ycJXZhYNREuftMubf9+zhZpw9/iQa2+arzApR/4CXoz7ruq26gTP09+1Ht
	IXp6XOwcmoVtdGB+qc2b+Tb3y+MiSCc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795687019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHK7ugbX/RMzKr1pPu3mSFVGP/fH09WdJS5CXhJ99Os=;
	b=hZ1r99aQnV9Npw9XnFaIDRMpuMA9zfNtI4K5fUmfhTd2g+Zzw4aSFrHMXlGPDoWBrzwEV/
	TbhiGah2uYnMMD8IxdtW5jsacW9QcEDcFhmhJzM1g0fgjeVqA8ruxeVXqX2S3qlvkpN/a6
	Kfl+6i/oSkdNl7oiPhZuK3PMPZyyVs8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GPX3Wl7F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80B354655C;
	Thu, 26 Nov 2026 09:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7271F000CA;
	Thu, 26 Nov 2026 09:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795687017;
	bh=rHK7ugbX/RMzKr1pPu3mSFVGP/fH09WdJS5CXhJ99Os=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GPX3Wl7FbyrIagF0lBQcklbIYOAvUqR6p5Gv6f96/HnRYBZmrEtooA3U/Z5iwLVRN
	 nqqse/UGgLqHu9GagDHI2Ze48A+pQkaoRfPVxaHpoqrzOmdMbor3I5P7Z5XmyOpVqv
	 xkNO6H3QrQEv3ltZAjqFykTRczJXaZG4fshFSPKWR3og8XGF5wkNLGRx+LGW4qXLLT
	 513Y8RscNvzkHTW19JX7h7C0BAwpG5J3qzeGzYs9+9xiNFNEk1sTCBXBTbYGSQg4sk
	 /Msat1+pLGMQjnHu5/sTJOtSc22pw3hCEnkuNNgZJE+3iZLt9ZafFH0YxGcicdXgXr
	 P7Z6duZTQxNOA==
Date: Thu, 26 Nov 2026 10:56:40 +0100
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
	linux-doc@vger.kernel.org, Chris Mason <mason@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH 02/21] mm/hugetlb: fix truncated copy result in
 UFFDIO_COPY
Message-ID: <awgCWBs4rkuTTxBn@localhost.localdomain>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-2-db27fd2f71a8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-hugetlb_fixes_2-v1-2-db27fd2f71a8@kernel.org>
X-Rspamd-Queue-Id: 06EB620002
X-Stat-Signature: 1inbqyagab1kfn4zgwns1hoqw8gozusf
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795687018-656244
X-HE-Meta: U2FsdGVkX18LbQU3ySSnkQrjrwqa8kKPz7lNNhsTsT4qoi6AEk4XIVO6RLrcRddHmoh0Et8kFQINAuzUzsTrz9HUaYhKrH4sJIxm6hKomsO06TPTygLS4GusMLyVaCv2rX/G6eO/D5PHiqYG7PRTc4TOWwHeHvJhjsHk9rHP3ax8aXFQbLw7QSccsNkQ7DS4jsxF1tWUJCstSkWOo/JXolu2y9R8MJwB+Gita0qMeRBHTxmqBOBkZyswDTQbZ/e31Rr3m0W3tMQ8sb5h/0mE4YGQl3SzuWdDl3JFrA4qijiUGrCU8iF5+AeHTxdbP0y7oJvI2oKWSFDcG4DcEzWhKANJRcyvmxVsgEjMxeQmZG8gA+RyGHW9uneO4tkNUGOS703yBwflGCDiKOeeNyH03cbAaYXPZtqee08yHqnm1yyrmTKkSGVpRsnb7VzybuZQDAb4EVyhlupKGiBApEo4WZd03PSdvVvDxniEjcCY/uuYKWPQ1NeBUO89piNbn79iMvmZyN2RRSwU3tp8nOmw5O2r7bhuT4zx+54Nqujunyj1NlUmzmjzdk2okb6awCw8xnpmP8QHFjcCB05PQXAfJNOnkRxaMD2tietRpoKWufy39I9O1R8vI1U8qeYVTgd4+dGjhoGHKmrG5ENHajos/0d41rHfyWsaxL8Zt1PYpKDFoe9GewxKu6FGnHPqHSbyKpsxuPxKdy55MfZr62Y/sn7Oy283gHouCMK6QaBw7jwGh1n+M5UdaV3jzIeHnRszsLbcWkur8bdjvBiKeQmqkpMle+soW4vdI04xk5ZCYiG+xpRtUMAwqow3gOxxtuSmsuwSaruirpI1IsavBxHMi9pN7+GRT1nor9tfef0Ma5FTwYWhcGsSr7OZzgInta5mr2o1y1/TVHYsOgQep03S7nNT+3WKk7m/Fl8a3Cf1IAv5bquS6bKvj1qN6jBOC07oDslrkJ0tnr4FXegjuFT
 2GCw/HCr
 QgW+gm9wMY5Dnz2Rvqw0Y5t0gQ8o7JqiHVaPmtKAPFvSxlvUC3n7MrtPv0GsSkXQNTHJrC4HgkQo2jgMOcXTJyA8vgeKZ0T3uAjapqbksdqKdQ9CpuHchoxIAHoNPmuxr9LA8vcT/SQmqEsI2N4AcNKPSJYCamfNWYaqzzJtL71Ns+ef2CFBpgmrLor15IuNgc6V5qmaBT74OeVZfxGMbD20gDkrCH64O+Qv5VcnWuOq7y7K5e3KT4Sp1XsjEmHn6WLEf1ynGOoWesnbVEEp4MDr5HbbwvfxKJPZPMWX8Tjap0dYl0AlwX4kVPd/OCFgFRRuS/URdW70msts8GLJI5RDTiwALKwCK917soMJEVSW6PJBL45WIWzVyhHMJSu2BZuAdwSPUMaWkqKVk/6MvgfbSLj1Dk43JHJEAw62GAnsFQ44dydn6eBI9hja/ZEqLTxknAFAqn9W16RqBylPcz1O/lhEG+Xo4pmhLExIXEN4ASGbymY7C0V6RcxFGcSaZurTbRHeLPkKSGi/f2YvBqWqFqv4Ncs8MnO02ycY/Oke/NzjDf3XaUfjBxW2vG6YZqR/QFwHwMsLgxm2u2fXzXyEe2EQA1lurRchsK/xv3Lzphwb8bXjwbrJU9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:33:00PM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Folios that span more bytes than can fit into an unsigned integer (e.g.,
> 16 GiB folios on arm64) are problematic with UFFDIO_COPY: the result
> from copy_folio_from_user() can be truncated, possibly indicating
> success instead of an error.
> 
> We will then continue with the folio that has stale data, and make it
> accessible to user space.
> 
> For example, if copy_folio_from_user() fails such that the number of
> bytes not copied is a multiple of 4 GiB, we'll get an effective ret ==
> 0.
> 
> Let's fix it by simply testing the return value directly.
> 
> This has medium urgency, as it's an information leak.
> 
> Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: cleanup code and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

