Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70A9FFEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49186B0005; Wed, 25 Mar 2026 04:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1FE56B008C; Wed, 25 Mar 2026 04:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35A56B0092; Wed, 25 Mar 2026 04:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 916256B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:57:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 221A15AF53
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:57:13 +0000 (UTC)
X-FDA: 84583981146.16.5897793
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 36787160004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:57:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KXDyYN3p;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429031; a=rsa-sha256;
	cv=none;
	b=yQOZH+MHAJ8AtFLxa0JCFLOvYZLgc4Bx+LNRVuRb+MQlVjVz4XIKLYecQU8BvdS04lUeex
	zu3P85qKF8jdXNhrqwgW3WCJY4ErL8+msPVMzzLKorzaBk02SHkr5erpNgZhG2KmUVownI
	NKgOnzTD6a/J18gJwZd+dupSvWjZU98=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oij+XXlb/Tr/sPOlPCK26Dc65wcjajSXXqZ7LAdmif0=;
	b=gmWdzxtLsJ4hOKv5YzcDWXUzX6tAcjUs+qN2zh5A8VghBVmsiVw2PCmpMQ7SQMdqMOHNun
	G3nfGOb/V3IUzKeeoQW3UZ08mCS3QkmOwtmNPGsLjlsewKP6QnVubqIMj3dEm5PBYCQxcl
	Zod0zZZsShw7ZCXkx4tkg+ikI3nqPss=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KXDyYN3p;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E57A41B34;
	Wed, 25 Mar 2026 08:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D373C4CEF7;
	Wed, 25 Mar 2026 08:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774429030;
	bh=7vDxJ8MG7mUqrlnn0Beg2W0f8gpdnvHJFq8srgJ6mTs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KXDyYN3p2DdREB/1DGWOaFLPHn+6WbO/NKIUxK1A0Eh8MsKEbNMie38TAewHH6oD7
	 vgNTEOvm3PKiIS/HzAgTLdIN6fxVZWO9wNPSudoQvSBGt7k5oo4plzZUQcJbvXuwRY
	 7szNlWWwzu6bwY962dl7YmKrL6AJohpF0AALi657Xox2hy/KN8qVkW+dp9qA57O2x2
	 7doCFTeYdxBl4e/IsovH9lPR0hsfe/L5Ov5G1wn8ES731smlwRqYtSY1kTbjVKwDts
	 Ny7agcmMi0gB6+TyNqJDYs+/bXs5me7J/QfIj/ftcqfR9+/4iP+rGl832eOn58KXf1
	 3h35PsFQLLICw==
Message-ID: <0367ec37-11a9-4ee2-ab4b-9bde1db122b4@kernel.org>
Date: Wed, 25 Mar 2026 09:56:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
 ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36787160004
X-Stat-Signature: dwe6adnjx6rbh86aybooq4u56j1dqcbn
X-HE-Tag: 1774429031-462589
X-HE-Meta: U2FsdGVkX1/RgydYvJjHOuYyxzkHM/0YmoAW6vXhcYSH3/kPUVt3uAaJjecn64drjC+kiz0w3lgUfSXOdrifublzlIViDovoRyIl3bZiDGVmeTHuuE0zBEAkl40MBpLt/SeBbDVlmnnZl2/fhWH9JZp7S17fVXE4zgiXu+b9XG+oiLK/4A7ApCZxCM7m4+4mliuGMx8HHOJ79R5VNIJFpncWiEvxtRVEOYLzp1FGQIIIvuXyS+FgnRB89l6wqJXcRJnAsr+2sTlJqtZXqYGt0Q/B7AAw2f+3ajEdwAKAkQ/bWcAdAOcLVTGEsR1xvsaeCoRNN0UL7yCr8GIGMhVeecU0xgOUq9kIhUAtRknWznacVk1m3+IWvRQnvE0pf2WVKMC37N1f/gShIJELqbVYSoPOqNsmHJksxmo0bmOv5gsp3dLRiBoYrFML3z4FepfWWby+7bE2Fyg3izCQvidCB/Hf/H6piHHd60mvJnKqK9RfaLtzDrvQ3ftCoddfVbyyxp43oU8Q/12o4MFWAnQ2CAMiiq1xfqUSuNJ45U92xZWJYJHWlgPcymIYZQ1CsvhGSdqvf8oPHtsjDCxfz30DQTyBV8vTwWJN5PvYQP4/whK0RVaoJca1T7iygBq3XzCJTIbbF0SP732+P+u+0d9f06cCoy/s0qfRcBhJy/Bgvm5/WcmxZQiRnicFa1JDwQMojbkJcua6kSL7v1SwTUGI09KoIr9AtfhbFjgx0RxREd3QJ1ZVfuKzeAoY1EBDi4nIHEqz73j5YMLr4c+KkIajurYgHZs2DhJGP73oQiaHxlpzRNMHa0skUw6bEoXSjJDPEz+7bGWjjA8hqUovqs9NN0sei7J/X3Q3g/Mvbmkxdb6OuAX6vN9uf53ezoLPtT7NcSAz10iYZ49Fn8l8eq78VDA6EfXKmU5lBLO5x5wg1yXeCfgWp1U7J7FonsBZIs0aCS0X9SxqQ40ctYLbhaq
 OHpKgmSF
 G4Y6qaYIb3pTttQ/z1DeHL9YboFUpQzEldKz96lkUqTYmNfSbjwldfJyssFYx2tTjZKWTzFDsOCbCL7gBVz76iWLL4VlZKb781fR0nblxWYlvrJ4mx++FV/O/p/3MMiNnMWB15i336y2fSaEJrg1McnfH5LdsVcGw4sWC/c//eCPV35w9VaDN3haCoUrXVlUhs5TsYMnI0S0q0gyCjZu/QLJFhreSfmTtbqpr0SRqvfGgW4lQ2IMteVk9bMU9NJpnQPtcJzqVFos1pWNFRypDFqsOrKqSuXgKtKC9lGrBnLjpKLCuaxtfaG4s6pQqxsY00DPe3XGlouk5vD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
> erofs and zonefs are using vma_desc_test_any() twice to check whether all
> of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> vma_desc_test_all() to test all flags and update erofs and zonefs to use
> it.
> 
> While we're here, update the helper function comments to be more
> consistent.
> 
> Also add the same to the VMA test headers.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Nothing jumped at me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

