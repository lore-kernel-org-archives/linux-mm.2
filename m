Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 532C6FED3C0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFD66B00AB; Fri, 24 Apr 2026 08:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6976B00AC; Fri, 24 Apr 2026 08:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC196B00AD; Fri, 24 Apr 2026 08:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 992716B00AB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:43:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5EB3214012E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:43:49 +0000 (UTC)
X-FDA: 84693416178.26.AA48B1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9771240004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:43:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I3P0LkNV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777034627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=druxK2dfx1TEdnaNvtTnQTdmqu7QkH26d/6ObxNc1W0=;
	b=tK5BtudkFbO2SEsAF46z6BwHtaI+zmyS9oSePyYmDygwwjCPAsHMb+fd7z6ZpbbmvLpmeW
	TOriD/U8KmNz7re9JuxzsV7HbjRLw5pQcphUnFHIgyuZoaIJZmp7uU04Q8yFbfUChL9RUm
	z4lFG8wLbjx7UApibHGuttbRAgim0b8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I3P0LkNV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777034627; a=rsa-sha256;
	cv=none;
	b=RTEGUtvC83DliOk3s0Iwc6xCS0QfGy9MomY1jYqrIkEnTY4hufN6jzqIrpHvZ5Z86Ajr87
	cbFKXF7iBxLkdHvTCNaL5Pf+slpYyWdj6ia+bceDKYeATwnHef8k46sZkkK2Vw1vjwszRu
	zV7kPEJdX6N+7rOx/3RnjXbis6K7rh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EFF4C6001A;
	Fri, 24 Apr 2026 12:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5254DC19425;
	Fri, 24 Apr 2026 12:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777034626;
	bh=LxPmp8iQxWz2eBbEuseV1mCBeRehEkx6aKC4TqxZp+c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I3P0LkNVz83U0Cahye4rRm93gn2CHTINURKRHKmewgLZGDlZxZaglfDH4YJTki7NL
	 85GtNEHiW8+dqmsHnT1+LLH04gANvNF5nG+51H/rEVo705TfWxR/7l0alTstw3rRIO
	 x5Y0WMgrC2h6cY60htl0N+wBPjMFGOWrqt4dBA2xhjFySbZ+Rb2YdhWodH10Y0vkDl
	 VMAQ+HiUplc6451tvIzg15Q9HL58ey8LBG6YaFFZubhCpwApvtJngBJ0XSWSYC7VUN
	 J10yHfTn/BUHc5yuLO0AB+4UmYUj3KDD1MosTe/2BLCjQx9JaMkGav5YIXZu12+Hhv
	 ShtwgiezhBKmQ==
Message-ID: <d6ba9cde-b6c3-479e-8aac-a8b3ca0405e0@kernel.org>
Date: Fri, 24 Apr 2026 14:43:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v4 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-4-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424024915.28758-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9771240004
X-Stat-Signature: qz9duqqgp5fo8bm9oqjah16o4sst7t1d
X-HE-Tag: 1777034627-497203
X-HE-Meta: U2FsdGVkX1/W6QbI6hvGefIgfV0XIr11aIBqO/2ISL3Z9AyS95B+pGf+gmqaUiWvpmM61Yqfy663coOdxJQzczXdpt3SerT8pfRGGgte42AWR1cziwJOG9r+8PodkvxqGTDDt8kNsHVwlKkOZPRoEtyKNRsXfvjjt/JLLSWrrDaFGSS1q6Y01Cm4E3iKV92h5LgtsU6AmK/yB1Mpx9FPnTl4xgYkbM3MPvqMig8L0sWQulUrmAhTdGuGOMLx5MAZY7Ej6kElTMLDrB26wmdiIrCPAYua2ueGQtBZcGeWkokBv4NjErrdq5ljYxg2E7XyER5LdbenZNnu/j1bzTHqmnQQQqe4GaYwqQnt2Tf0XRH7vtAWdzPBH7dPiFUZgCL1YpYExSigA2Sqmwj4tNBWGVM2iORQ62SxbwtacCZe69vE7qTHWRgIU06TJwgbEALcaZAC3y5FUS4Kqw0UvcSXcofY9FrdPllU3P0l0LAvcs5kNZMpMm4tcjIX0CEJCPP6ZvboJ9tDM5ZGuVHg2Ea+pnzAe7hCyhBcYKU75OolrSTa5hv7NJ1qzWbFcCUBgaXe+ZgUI3vhD1zUp3RH9Z8J6DQrrvyZtB+bEOojNRv6K5xCE8Jm21WUfsRcdeoI3HMadENns3o+SpAKsWEqKORbDfHMTrXVcPiVbBiJiL0aaM8PLYdl4c7mQcKZNUHFl4Bp/zJRxABK+cFNh4Bs7OcLuVrNikgtdO53OwFuvU4G/c3dx4F59cm+kYjcSp0UwHKB0gXuNGusJFrCJh7dojlWvQ1/fk6CPZpFxAy5vuXhF8k0Iq8D7akVwQucyhgDnshkmoHt3M03WxQl3kw1uKS9ghd//RsloCA0mpo0cFcYuSO98OY31kVT26aHozjWmZl+fm9BuvAH1oRAmC+WsXKj2KyoGAuiMsrzOFOGrifNRnlMh7IUukPsSARCvNYO6h6JiU4ccfEyvwra5OKs0HW
 BMrDLalC
 LcHvEN7U6HkM9Vk+dyXLTbY7OCj8Qzv1KUv//CcYHGTlVlsNBCUGoLHKShIO1cT2vzSrNU0egTuRmrZRRQYVfGhGJeQ3aloYseRBGPZvWvBdRVACA9/ei/uzCm53kzvXbZy/GSSaqnwaMY3cYLePkbMugsK/ImAnVyzb3xsMubEoI/8/e85+3aTALwWOsmrzVIFSv1LX7bHVD5wqYkh7PwoukkyjyNC38XKKi7rmHhn5mzikhe/Jo8YzZcscNQqNbJIlbn2LpZxqELpIGCdikYdyTHPmgYIIGRbCxyI5nrOjZ9kA0MMjeD0sv5UpoQQcoupszIRwaVAzdrwezARERWv9Kb5ZugEEYAaQeyIQzLonXqKBCEENQja/M2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 04:49, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD THP is supported. Also remove the read-only fd
> check, since collapse_file() now makes sure all to-be-collapsed folios are
> clean and the created PMD file THP can be handled by FSes properly.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

