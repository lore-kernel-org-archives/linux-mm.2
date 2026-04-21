Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F0AF327B4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 07:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255556B0088; Tue, 21 Apr 2026 03:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205DB6B0089; Tue, 21 Apr 2026 03:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F44B6B008A; Tue, 21 Apr 2026 03:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFAB76B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:25:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CEC55C728
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:25:14 +0000 (UTC)
X-FDA: 84681726948.01.91A5273
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD36816000F
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:25:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I8nTJuu2;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776756312; a=rsa-sha256;
	cv=none;
	b=ZFkxVxQ9FWsLJrVsiiC/J3xdED6EyODkAG8+46qaNlGeja6ULoWhLqdof6seAa1HclRo/p
	To2TtgNWt4OPGGvO80vlrtjIKETzQsCTiIbtF1XunXzT6pClb3Z+uZDRD1z0LgUrR8waXJ
	YyHe6jppgh7eJP9bc6iFa3XmPDBao7o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I8nTJuu2;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776756312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8eHb3Hxwcg1BYtEk+yTHPCjUakXuPFeey16dZvr48U=;
	b=TR41mbkAsG+gX3vQLtg2l1pOz+x5+lGjBJCRRUWIGTT41khBUn/djzEkX3GJVDPCF2Vt+C
	06xUpABYwj/DQVuod3ohsEd905poQPG7oaXxlAblDLr/2WV/O4ugJ4gu5qtoHu2vTU+Wc9
	sOlymnlFBjo8OSUJhrnVJJQTD5qBGHU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 318CD6001A;
	Tue, 21 Apr 2026 07:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DB7C2BCB0;
	Tue, 21 Apr 2026 07:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776756311;
	bh=plEh598qh3qqk54SU3Ya8nDC15W8+JoFU/NOjYwa1eI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I8nTJuu2oMi4lJ75x9Q956MeJBePyfguSJ/RBSrTQ25Gt3s5ppxbBH80i7oy3dj3K
	 RbWTsqfs1gNdDvPBMn2uwP/dVlzTjk0Uwz3+m7kiHBEhlPkHkErE6EF5ibTyF4wLh5
	 h56UCXxavN2VNpLCYOobQw52PzrhOeaWDJEPBx2JNO+5eq3TxgJEiMr0yotCaIdqKw
	 MAsEDAYhcJjuLFE12rmP0VTrtusDg8YKcKYqQ2SKVPOjTXttTnC/bbNTEdlMvZgXuj
	 Re2OrpiS6J38RE2T/8UB1AKI+dBp2zTIz7O6t3JNAntGr80mm4P32UoSxH/MWZNvJP
	 8ZpRHsQ6eFJNA==
Date: Tue, 21 Apr 2026 10:25:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 05/53] selftests/mm: merge map_hugetlb into
 hugepage-mmap
Message-ID: <aecmTjikgWAvoYTE@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-6-rppt@kernel.org>
 <5e4fa215-224c-43cf-a0e6-0d91e09a4a3b@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e4fa215-224c-43cf-a0e6-0d91e09a4a3b@linux.ibm.com>
X-Rspamd-Queue-Id: DD36816000F
X-Stat-Signature: hnyjsjdrqbzwoxgt9haop97g7d6axko5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776756312-887505
X-HE-Meta: U2FsdGVkX1+27OwJUb6V4NcuRwrT1gQXxKRJwCoZ/cg4GrMBMkW51p8hIaLjIFRwtco90Yilxa/fbAqLi9PHNzv3dj5vAt4mQHGq/UNvSgpVtCUitbxcimkz+6s/urJ0RNeTxIRkoIFw/XTVGzhCT70KIK+jaZgHi+Dv5wH7UowUWlypWnEkGNVSPqKpJemISzNogkJqLz2gXo5pQQ7zWbuVbhGxUJcleU/mrL1nWBoPscjt+8ifj9hMx2VqcXO431umfncan4zJ8s5ylDS/Y+YeCAmRs1/vK1Sql3aaVEEsNQgdMB2i5JIR7wexTVQN7swb6st0XKa1KydIsDYcxLs1ambHrYBWTM9fvALAkHL+k+irvmQ2wMPjtiw2B1Yz8Ti+b+hS3h9ZeKUhHAKfzte5EfiuBMryeTwoqO5nxb/Pib0F0/V+7VQAhHGD/5idI9yuV+9y0ZJ0wNNLL9nWvjlTY3tL3rfch4PJGrcVJiKeiU7zKJ3bFHveJEFfPQ76zdYqfYtbTJ3+PBBF064ZpKDMPJECtkQB7dE3Vz8pjeechvyxsAPCw4EiTb+Yxrg9yv2io2lhzyWkzi0270wDu8M4p8Vt0WTfVF/N11x4DNB1xEf5MiAq5+wR1PnZFgEDoLH+k8Oj7cETH1inafhxmafWggfPynG51w4LZUH9OfwKsTv3jEz0DaYwI9uY8klaexVeVzSNOdY1qxqDTfwQ+3S0HLzGJV6QkaJJ4DDX2fE8R8dk/S59hPSHkFT0zJFfIp9Eaf1gCgDk+Yle4wbyZK0Nfk4NJl6Ul4RWLEqZvzqkBZ3G7tAT8E8yLPf6PJYSdoyHvGJq4UcoOj46FDvPqI+oDjHmVELoLJ+meBnt3q3PVHqQJCxsryyCUAN9kEvR+gm7v7Bjv2cTf0O1m1BXzdWMLUY2zXRJwwQs2osBrhJNAn8tHg5vw6itmAXhkzS/Z0mK4v+HWZzC/TqT1sw
 yz4f6aAc
 66cHsEWjCGDOZut3wx294tsQZx+Zqgb3Vaon/dhc3aryM7x1wY0GqpKMrn418C2QNvocIIqG7GW48IAX9yRL1hJ/dTRhDHlTdQTza07ecJRUQpAVOeDxiIbxD5zixuq38KaHPKTpFbaUUs94Q53pJGuMkWd1CBImT2UJoUxiC34fPBjZyyTn/uHVJR0f/NPDr5kkYybx2Vo+oWw+TyB6Dki+Y1WLgh0QAEbt/hEIZdM2K6erxiyxfsgmA8UiT65ZtbZl9SVpp+KsPE0sddoh8YsWlpUU80MfbBESzwSujdYD/gY5X30rNsMXdZc319TpZsMrsY26uHzbqow8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Donet,

On Mon, Apr 20, 2026 at 02:50:49PM +0530, Donet Tom wrote:
> On 4/18/26 4:24 PM, Mike Rapoport wrote:
> >
> > +static void test_file_mmap(size_t length, int shift)
> > +{
> > +	const char *test_name = "hugetlb file mmap";
> > +	int mmap_flags = MAP_SHARED;
> > +	bool passed;
> > +	int fd;
> > +
> > +	if (shift)
> > +		mmap_flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
> 
> From what I understand, selecting an alternative huge page size using mmap
> flags is typically used along with MAP_HUGETLB. Since we are not using
> MAP_HUGETLB, would this code still be necessary? please let me know if I
> might be missing something.
> 
> 
> 
> > -	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
> > +	fd = memfd_create("hugetlb-mmap", MFD_HUGETLB);
> > 
> In my test, the default huge page size is 2MB. I passed a shift value of 30
> (for 1GB huge pages), but the mmap call failed — To support 1GB huge page
> sizes on a system with a 2MB default huge page size, I used MFD_HUGETLB |
> MFD_HUGE_1GB. With this change, file-backed mmap using 1GB huge pages
> started working. Do you think this change would be needed?

Yes, I'll update the test to use proper MFD_ flags. Then mmap_flags change
won't be needed.

Thanks for spotting this!
 
> -Donet
> 

-- 
Sincerely yours,
Mike.

