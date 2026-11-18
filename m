Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A076606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GxLWD3N7
Received: by kanga.kvack.org (Postfix)
	id 52FDE6B05B1; Wed, 18 Nov 2026 04:04:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507476B05B5; Wed, 18 Nov 2026 04:04:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444756B05B6; Wed, 18 Nov 2026 04:04:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14A676B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:04:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68BC5A832A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:04:10 +0000 (UTC)
X-FDA: 85447653060.27.D8CC2A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2AC1C0006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:04:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GxLWD3N7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794992648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ILw4EFux7bTkf5RNu3Ik+2UTxpkbYziGgraDHdKyo4=;
	b=r5wPLlxe+D+BY0vGpvyY4VnA1W61D72TRRQeQ0+v+SyXn0+keOR64bu2gFDQhB3ach9qAY
	ovh4g+iuYEuLvcT2Csq4i1iDFw2gSRM5TC7D5ft1GifkB/aar4rlgEeoZ8fKhmf79ZQQVn
	y60rcdlI116DtunmA5YxB/gJw5/qOjA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GxLWD3N7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794992648;
	b=Q0xC/ndNyJ8lJaumbZvSgOUOuy/5Cn8yUxMtGUlC07y1NSbfzQiSIuhAj6gaRSl6A1GG3n
	euoWM4cBwpRoMEqU8GTs9ylkkqLNrplGv0NSFxHFoqXG2kcjIQKzFg0Z2/FuV8opw+QoXM
	/Q/fflKPIMpvL/+BLV6f9qCeIp9uBLQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 253C361FAD;
	Wed, 18 Nov 2026 09:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C9E1F000CE;
	Wed, 18 Nov 2026 09:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992647;
	bh=/ILw4EFux7bTkf5RNu3Ik+2UTxpkbYziGgraDHdKyo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GxLWD3N73udbUDoNblg7Ifu79ktDf2tMPQZBPZqOeRhnEGWEZm7cUXVyjJ1dnGv5i
	 l3BIwO3wcRqh/opIRo3nC8VYsRjIQHTV2Z4Wp8Fk3nsEgpEC9o77OtjcDP3eGFN7Fb
	 n0MZW/am2GOXPaqhqQa+rFDYtnX3TblWDpKMk25PbbLNOINBG12hHwFhiI9ihwCobM
	 VY5YhSvOPK+r9knEQz2YZCvaUHzkAa7KgIXsQ7UnIahtmy9PqzvnfJTtC767GGKR4j
	 o18rv44b5AyfSff3CIXYD7OvaDKnLyI1Tg9wwp9KU2+/ayRnE1vvZxgnUG/oEapTsr
	 jDapuh74AaHyA==
Date: Wed, 18 Nov 2026 10:03:52 +0100
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
	Josef Bacik <josef@toxicpanda.com>, stable@kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH v2 07/15] hugetlbfs: fix unmapping folios from private
 VMAs
Message-ID: <av1p-MN1hMfZDuBL@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-7-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-7-4dd9e94ea9ac@kernel.org>
X-Rspamd-Queue-Id: D2AC1C0006
X-Rspam-User: 
X-Stat-Signature: bpkc7tbbtz1ac8jegrsi1srcidpcj5du
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794992648-998023
X-HE-Meta: U2FsdGVkX19XzT8qJ17xtfcNeyoiqTh/Bxn7wC8wMcKpfbrh3tCTGcMWAh7TPK7DfxCjEWMwTWGgLaowydzyWR0QlJDoPDKZD8Pdorm57xPOzvSRkiuWM/HenY4N6SbrjPrb0C01CScC/HP9Vy6+ZtO8Odpbz04e6ViSfAEfRlAhrlhcT7MZ49o6Z1QHY6nhVNIyv/CVpM7RDmP4QvX0maRw662+S3wj92gzFyQlOG8lYVttWdmP26EhwFr2QfA3GaOSlDxN5KlKdj1wYKZlr+IxaqrnjNXmy/NO18TBpkfvo8u9TVkApXJTAqT4osd30GCpyK+kzOW9f0PeIEV0v0coHUcY3+mxtXRvq3EDgEZWuNMURJBUJZAV/sz4d0TO1m4vaVm2hcnPCIuW6hqv5KALVx6901h1gx6h2+KiJPdpdinOpFo/y0eL3wtUleTKFTKec6uOmP1gKGOG3oM5G86glzeTCFI+jlHDeGeFQbmutxydYDxTLvVFHoYkdXfh0S7oZT5rw2jh5OYuSVKc/vRwptRcJcNtZ4SbK5jEWBmQPVqJY4THrva7T+yRFCOxwqCjuaF8JQ10h4gLag3VlXTPNwjoElVFOpJFTFOGezWhgJZcfDHUi20Qf7kSCihdTPXZcTHFVOVR2iuHjkiNLlwpIExQmSGXpbw1K54uEflgIV3azXmYtx3uYLV4FtA8KlrMik7znVZEHrfe3zEg+BlhI2F4ldIwInVDyOrooxIldM4x5tH5+S7DdMZ0wK36XDs6bQULS67QuSpyNI2tEyrg+DXNfX8MciZwFrNd89jRLk2Z+mGQYo8uQM6oijjn5wCMy9kh0QQW3YX35qz+NbXNZyAfnlqhFxX9lBvakgXKJWwE5LkDCsVbdm+E0ouFQwdXi0zAdilGWcxssotqeC2Bfij6LfHtscvv5Kg5ggerxbRRBCJ01+mcd1tmcp9phht71owcfyRZht7rkjb
 pfXHeJVM
 w4PdC7KLXyqiLwI/Q3kcFYsK8xWmDnarJsqA0jtinrQh4ut4jI9PDVSLQgbT9YD/ZcyZ7JXJZvaTC7nQHro2EgPV/vLjj67rspJ0NBeanMSAuf7o9DWp9wSw+GEGE2aEM+BdanLcMrryPQSVdLcF71nMDMHWQ6GY2gWVT++JduxtDse4B4GLvbtlxiYeN0V5cPkOPHbEt3MVo0QtnGdKSAoSsUXbY1m9majk6AsVhg8urq4gfLNlg40js3Ie/sYxwTGArgt/h+gdc0032C6v1cjhyGiGxLwete6sEQD23SoihYfiD8Bt2CAHBNrffVtDrCJ2Z7dVJGAm9gcLwaFkTDNNtvDlLfWsHMGr1wT0xRsJYacTu01zSbW7TI5hKbX1xkoox4UYTJTowymc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:28PM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> hugetlb_unmap_file_folio() assumes vm_private_data points to a struct
> hugetlb_vma_lock when hugetlb_vma_trylock_write() fails. Since hugetlb VMA
> locking was extended to private VMAs, this can also happen when
> vm_private_data contains a resv_map pointer; treating it as a
> hugetlb_vma_lock corrupts memory and can cause crashes or hangs.
> 
> Only take the VMA lock when a shareable lock exists, as additional locking
> is only needed for PMD table sharing. The fault mutex and i_mmap_rwsem
> already provide the required protection for private VMAs.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
> Cc: stable@kernel.org
> Tested-by: Daehyeon Ko <4ncienth@gmail.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: simplify description and comment ]
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

