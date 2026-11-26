Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F9A606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FSbQknkw
Received: by kanga.kvack.org (Postfix)
	id 8150F6B05B2; Thu, 26 Nov 2026 04:59:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECE66B05B3; Thu, 26 Nov 2026 04:59:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7027C6B05BF; Thu, 26 Nov 2026 04:59:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F20E6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:59:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D25514039C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:59:56 +0000 (UTC)
X-FDA: 85476823992.13.1E58CAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3C0B640008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:59:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FSbQknkw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795687195;
	b=Q0q4d3x6/deLd4XlwOgiZBa4VczK+AeLu3vMVwQQA5j5G2xYZXYA3uyP5R/zkuUtQSKls6
	nF4SQC9qrQ9rWyvbTL4Fsafour9TTathdWVAADVRI6X3ZINY2wPn95vEVUGwwtYL5RuYxx
	oW+nvQUYN/KgJFtHVEwlZTD0Qz4ehx0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795687195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqYzO/eSRDch7jJCLzvTRvERSohL54BCcWWSz/h0074=;
	b=iidRH15J2h+Jf++3YyVqJK4m13iAFrPbPkoKarm1zyUFgz2yhtp7N9ncWM6dWMtAqarjPs
	w2GtDasdDZjofqCtbStuvkirR6ZJeqlbSDnInCd1+YJ5vEaQLJ12r2E6mHjskmg+3h2KM1
	coCk4LGk4/1vXQJZ/iC1zHX2X144caQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FSbQknkw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC31762DF7;
	Thu, 26 Nov 2026 09:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E63D1F000CA;
	Thu, 26 Nov 2026 09:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795687194;
	bh=HqYzO/eSRDch7jJCLzvTRvERSohL54BCcWWSz/h0074=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FSbQknkw38FgllhfssHvNv0MbT1LPViaDlO7msWVDVWlr2dZ+tvZyZXD8lGkrbJHH
	 NYatujlK5nSOyXTq1MoXkh0Ui/+V7dJ8bsSqbCC5hfjdzSqaLiy1W1VSJM+Ub8JZZC
	 lNor7sv13clqY8nIKxzJ22Azl6QAVaWLfd1Q5ifVI2zTt5NOl5GRASRx7HsTxWVb5k
	 MnVw07RlfYCdZaTyLQqUZz2O5dJkLKr2JUWexPW3r+RU1oQ17f+b0gGD1n/UEvUF1R
	 4qTCsiY1jEyd6gzvvS/oBdhWhfjw4dE/SZ314lf43F1Y/r0j7juM4+ZoAaYeFow7mR
	 aI+WWCfDP7aiA==
Date: Thu, 26 Nov 2026 10:59:35 +0100
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
	linux-doc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 04/21] mm/memfd: mark new hugetlb folios migratable
Message-ID: <awgDB3ocsRhKH4dw@localhost.localdomain>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-4-db27fd2f71a8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-hugetlb_fixes_2-v1-4-db27fd2f71a8@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C0B640008
X-Stat-Signature: dnedapms8y6pnkjr1d1z8pjciqrxwsc3
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795687195-815093
X-HE-Meta: U2FsdGVkX18vZCHSuN2ns2hXqfFj6QHiUKHHw1tyfH2bIo8lI2SNauz7RbnxraOmqGu3zm/0demc5Bc2NUJoWS4pNH0nmR8q7lsLxm3R3T+7oVzyAt2kgkUl21qSCg7dKpn3mla2uvyq7xnEcEk0Bo3L7oPmwogEGoON3F8RnzROWuGnst/N2EKvGG+FStFiMgA+IWfTHQPYaXQNFsUevKvDSak5jPctZ8ICMJwXaHLpZe874GV78bGsczkAxojOSciE3G27BMOw24V8jpfnm7w+SIfLX13Y60/9aVBHNrAzA2KIa6KI9dk3t/m0AyydqrecbOV5IY1i8+SnlazTCVLHfvEKmqMQ8el5XrYpbWWmsv1J50EyDp/NlgmfxDqJedGSzqmS0grHiQOmAr0VjKDFBePn0z5RK+8tYUnn79/AHH3ayMWLEI9v5C0E1ZfsIX41Tc7x1RbUb5pwHymSlOqrQjN1fIbuvxoJj8296t8/d8upD/0q52470uTOOrhGJJAQcqpV7Kd8BR2nB5j1VdE14d/1KKerENZYrPl0E3nbzhqqXF3XHBbinHci0d95rHl9g2VJKPhdWM7PD+/PtU3Cn3j6C3Lqiimm+YsJx21FWUjmPLnjrc05S3PtunGr9K9FrPWxaXlTyTgFEEireLXasZYi88ZFg6/prKLG5Ze2Bj1uk8QbEyGvO44qWYZLARiZvalDXxU4JnG/YQriKxWnIed4tJ1OiAOlbUadqrkvuRK++XkidnhsVKtjVJLU7Ezc/ksg7vlS8WKevpAhwHhtGuA7TGF4GGQdVbCxcKso3QyOg7x5BWJl36Oc5vZEtZ58FN93jtSVfOqEKKcsMwXGR7gT0uUO2kQ7S6mTRI2g6bkGmSjz09NfhKAT0cBSO8mrkAEcdx+mX2H1+HO1P9+VFJtOkPrLZT1K8zVNNj+V1iF1+Y0l5yK5mQf3/pixwbQ69qUBd5q23vxe+kk
 JViTU8dB
 Eb3P6miS8YX5MpMyVv4ErRqa7zqA3TFDMajUcxTBjpF99sxMeBpNkI1u4lbJlY3YWjg9qcGtXpLTtUFje9hPu5uL+JgLs04NJ6ONHgByRQ/Zi6SMDKXrTsEwkqNgpPSdwmon9Oui19AP88TYitwRLirCC1lPKRJjt0h7Z+1mBJdUKPsTIkMOKVspN4PLpP0NPUOWEtrF8bUR4fp1egqseOg7TdufOKg863diI8Y3xME5KNssNSoosa3dGy+O6dYlVAiUsbj54ycirKQsHLcpBmpko7yxvid1kwCQn2PNu0VWVUKwCFWm7y+xsSGVDhL+n7HKqnw8NM0RVVaXHmiFBrQHKAEJtmmaETDyj3QlAlrAjNrVEtRtI7OXp7HTe6tr9jZwCXUHrT5SUDUKlbou85MEXfGdMKaqIVj+dCT3kZxC2cN+uFAzFb6/4BZPJ5j/dIFb/xsduRUOkGmR6ArKCXQ1rLaOW0IGOvLug3Q42fvOvOQtd6agpczGUdbk66jUfdlzFjRZgWNzS+/XiNEUOy0JSLbiYHA9WxqP7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:33:02PM +0100, David Hildenbrand (Arm) wrote:
> memfd_alloc_folio() adds a new hugetlb folio to the page cache, but
> never sets it migratable, unlike hugetlb_no_page() and
> hugetlbfs_fallocate().
> 
> Later faults will find it as an existing folio and never set the
> migratable flag.
> 
> Such a folio can never be isolated for migration, even once it is no
> longer pinned, which breaks memory offlining, alloc_contig_range() and
> memory failure handling.
> 
> Let's fix it by setting the new folio migratable after adding it to the
> page cache, like hugetlbfs_fallocate() already does.
> 
> This has low urgency.
> 
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

