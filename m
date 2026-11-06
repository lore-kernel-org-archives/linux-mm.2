Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75FC6606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QYzRZBdU
Received: by kanga.kvack.org (Postfix)
	id 8275B6B05B5; Thu,  5 Nov 2026 21:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF986B05B6; Thu,  5 Nov 2026 21:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE0B6B05B7; Thu,  5 Nov 2026 21:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52F656B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:49:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8EB4A8B83
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:49:17 +0000 (UTC)
X-FDA: 85403162754.10.898F37B
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf30.hostedemail.com (Postfix) with ESMTP id B5FB180004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:49:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QYzRZBdU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793933356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhQ3c2PQxxIs273fLfDsJaAlMJ7k+j2UNp/PTN7YehA=;
	b=Q1IEv9rf9v0fGRyB1pIn68y72TA5CWOPIyWSQeHFMTcakNypRX0YkL3yvxW2VdfnQwZhwN
	xNaKBiGA4BsToQQ+yq2VF6vQAuLzF5HSmZPpiodPkdQnUDMusaQtR+J4vmp3XjJVkY/4px
	NjHYi2o68b2OVpniAUB2+G/T6yRB0Qk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QYzRZBdU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793933356;
	b=DCEihsE721y0jkwkF1EG4x63WWaMX+4V/pQJdQM8FgLf8kUmQJ4rO3XVXgCsHFiPziFHpt
	l1YxTVWQH3Q43VHV/OKUvnAA3QPzn7sbkgLkleYKT1IRQskHWQnI5MXmoevrUNed+IaoHR
	qsEkeXQjrA78XbnOjXe3xU5dct38Piw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793933351; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MhQ3c2PQxxIs273fLfDsJaAlMJ7k+j2UNp/PTN7YehA=;
	b=QYzRZBdUo4vmbD7D7WIAm31Q9xSnwQWALKdD0Gd9MBP9iKxK8o4/etn4td7zq3R70RZ5Y4+VBvgKiC6NEsEtCMceEyAgBY4+KybTf/GySPmCje2gJQUxhGoUFvEJ7xzgPvhqWKDCDA5Dk7vlxtKX6D5F5rFdxD2OJbtLQjeyhLk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XEAEjFl_1793933349;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEAEjFl_1793933349 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 10:49:10 +0800
Message-ID: <b3035814-fa08-4e85-b3fd-a254e5b0a825@linux.alibaba.com>
Date: Fri, 6 Nov 2026 10:49:09 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in
 MADV_COLLAPSE
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Hugh Dickins <hughd@google.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Zach O'Keefe <zokeefe@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B5FB180004
X-Stat-Signature: 97rs4z9fb7jibrj4r64reujqnrr8dg6d
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793933354-457786
X-HE-Meta: U2FsdGVkX18tZeFLEr90gHfSFTnY3HYr27WqZ6qZda6TgsYiKH69zLLeNx5jNcRqF6IK6jhOpzPGrK+nV8pliMxiSek1zXRnsOGzjAYZdHIE5yH00yfWok+0DexhMwlsRX3vqY9sV6mkyMpm7L3V2fkmSVPXLx+1GIK0jUYz/OV12iIUmD2J0WQeq+iSPMhzU+0p2jM8rH2GtSgOuMN+luZo5wpa6Rh5377Oyv5IeL3Yxdf8SCfNPpFed3ly42haP33VSiQwQdslIGjIot5hk3i0JSf1BEFp5rNwNWbiF5+XjkrDaVQxAaDLdiAyORPkR4n/FLZAtvYEGeGfbEcswkpy5Z4p6ltTZBDfifkFTMZmozfG4BpVDbguUn5BS5SXFOnyEA/dkSTJjMy/cWv4isoDSg6lAyAx4jcfDfpPsl+oi19kNCNBXpzB9EThzl9EmSkmlOcnyFNtjofVpDDPp+Xs197Xo3cQHL6wyC0PkZ26DnrjhePAKEfqxnhQcKD+MEFgALwD75IZMGtDU/ejS7ywg1cJFdazoNJLwqfUbhOgObTFGj9L7aiC2EAr+UusHNa4cUemaWELwbQvoT69E4uuNKqeqo2elOU2pntUZjeYpn52+3QfCOfTQ1c28B9ICw+Hk7USwymx8StPGeLqBT4jgCDF4h2z0XqoRPM2zHzGD51WRB23XzpKmjzxmiyc4qrC/b7404g42UMr4fKqV43JrqmgSgvVHjQBXvWsHLPhgVy0p1XL3iN0AgWrtCY7szjj2t0sqvyJm7lZUFLXVtO7vDzSANCBWpQiRBL4fHfsaxAoArcQSbPcdhNZz7/HKZyn1Lu5docpbwzgOF5UkNw64z/KlO8tFvm3D0vhpa1hoiV55bED3z0DsxfzDSWr9/uhvGPsKLwH4IxELI3pN+qYNpktyCF5yKJOJnh4wkKeDLo1bs/OjQ5GlwChGa1d5UocSRKjc12m1FZ/8Q0
 Uu2n6BVN
 CBVlBzbMi0vZtOjp3M58lQRVy3Y/QxPQJ+06whCuwwfdTgw4Xn7wbuuBGW3qavB60eMZwgbW217thuEMkJRo7y/V4sJNOqyJ7LvvNmJYJx7gU5tBfcYFoJBvdfbt5Na+p4NvKzizAaO2CAZzF/jnxCreHcXNxeVf7pn0c7bQxQQeTObPrVYyWBdMXjfDtjRNLA2kuzALSwHwJEkppPPlcc+teKiEGDSNC9dk0H/cc2L2nXLnU5LqkuwOhEtmqCJu5bK9vo9He0eFzHzgP2k2OOdcLTK4TLzyQlzVjJW4zU9BRHhfwCQXkwpKwaKwrkzd02SDZ6htVDeAywsAODyczXJPpBXMnLauKemTsSYhl21tA5qhyobKaJQRedA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 2:16 AM, David Hildenbrand (Arm) wrote:
> madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
> uptodate. For example, shmem fallocate() can put such folios into the
> page cache.
> 
> collapse_file() already refuses to proceed with folios that are not
> uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
> such folios, leaving handling to the page faults.
> 
> Note that collapse_file() effectively clears shmem folios through
> shmem_get_folio(); let's keep this fix simple and simply let the page
> fault path deal with that.
> 
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Reported-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

