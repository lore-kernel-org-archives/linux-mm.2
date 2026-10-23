Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2FC606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 20:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HiQGCRhA
Received: by kanga.kvack.org (Postfix)
	id 711F56B03FD; Fri, 23 Oct 2026 16:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3196B0400; Fri, 23 Oct 2026 16:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9636B0402; Fri, 23 Oct 2026 16:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FFE96B03FD
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:56:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C8EB31C271E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:56:35 +0000 (UTC)
X-FDA: 85355099550.28.3EC3DB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1051E140005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:56:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HiQGCRhA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792788994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y67gO6PRdAEfndN9srTaRF6Nt3BQB1WNhqjL17tr/jo=;
	b=a4SIlOur4YdyaZ968lkqicaTK/jVvesDJr+Q6/ap9G/j5ylpUfPj1ycAMPbU0mazsbFjJ7
	3E+lawsypBJb6HnO8w8VNlwNz4xpREoHlFzbFFXY+ytc/fAjs/0RsyFMSTT8KVLSfwluWA
	oRSL3nK1ySiqCGjProyOXChlfkZ6NdA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HiQGCRhA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792788994;
	b=oIOI10MnlyPJ4tFiuvyuh+/TA5PV69Vk69yuW72jc1NUhAlBNHWjecVONMgRGcDwqsLNh9
	VOS2XM5MpTPp3/illUIZQqN9wdqKWomEhwuEIT3a3z8HtFiGW0YWpL+SPmMrgs6ZVYLaFm
	Bw76HUUEe5QkUQLwqvnIZ3H5SrZsIM8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E50660142;
	Fri, 23 Oct 2026 20:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FF41F01825;
	Fri, 23 Oct 2026 20:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788993;
	bh=Y67gO6PRdAEfndN9srTaRF6Nt3BQB1WNhqjL17tr/jo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HiQGCRhAgTDsuuAFI1xdM4pzH4DCnuxc5f2pEQtnPLvtOTL2NyImEBAxxN1HPxJ4g
	 cCEU2gIHN0w5puIT9XCjQ2GHvqK9IH07eLfzo9k0Dcvgmn+WFkNvYdvPzq9LJz1hfJ
	 XXjFolbTTG/+5mqJQNX47lyuSV49+lSk7KMT7dwjChB8i9NWsOKUXya9tmtOMi8w23
	 Ffe5unOXSIG6mPZjg3PieJMFhWWxQAas0zj6H1jGTPMtjySVZJz/a/HidfTOG5Zn35
	 qRY4GdSRizzv89zSG2piiKDVBwjNZTlXydNiqrTgp4BccXL8+QoDc4H2C1aPFciY6j
	 6hJH4WW6ZuAzA==
Message-ID: <f0ad7069-5ff2-49fa-b11e-1ae589836980@kernel.org>
Date: Fri, 23 Oct 2026 22:56:27 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: remove unused mpol_is_preferred_many()
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
References: <20261023161003.59086-1-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261023161003.59086-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1051E140005
X-Stat-Signature: 49n9nbubr9pzpzirsj43fjmwaiawmk6t
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792788993-37638
X-HE-Meta: U2FsdGVkX18DHCocuyEqQUlFj7Wu/BlHU54e39SUOfcO2+BL2TxstR0SAkRbFz1Pjx+7pYX9VhkRwMz+Mj/YGu2+eMeUbxrhDR+DLHJJMBQeEksBI0Sl4Ea3Wo9rQQxSw4IG3SPmylPYKKYNIKbqIam8WAcXSHxuLRd/gij7/C4cQq6xY2FE9pwWxHvblV+MocJtvixEZtqAGWo/8c7jIm/qwshNZMFnieDBWtzGkB0fy3uQSiN9vJ0/kaEgMLQxHMN4lDRaRTpzP0Oo5Y0Gin+FUtGit/dCooqlRD62p5X3hlq4d5/wMIw9gl78MSIMmqN4gAYoQcdTY4VdRDcm5ZldCabKqAFMMqcKuSmQw2hkzNqkfTGoflyLtAVkQaIvnja2le8+VUs7jegB6Eann6y0SGP/LrWbAU48AvcHI8cnZY3OwWRUOAikwzNLG1nFCjURel+FwG99oWlv7S/RWATS/sFQJz+GI6LhVeGUpLozvaq7KBrOy3YJuXxyuQ6SdZlDMdmKPeICuaRiFuMrzKuY0IZSuHG2oKtJAd853a30LpOzGWgL4FmlQOmAKp1tgOuaHpdtp5Scd3xN/xRAep+NCnHYwV7rWzm4CnkBS7s0HJJTv+NpYS0U+8+xjh+DapYOUh6DS/j5VKV2meYgGNC5qgcZYVTopwbGnbwcJcobuUZAqSmJp6sPSNU2b49ORamXQFQD0RxPhmE/VeNcCcP3qsws3vk6VGU86bN+PtA7OzgbANtIwONu2rv11w/fbhAQiNB0Lmh+ZXvPeR3qj+s5MIfSS/ydYJ0OBqn2xC3iL64EhH/uF1AuLlBHxZdOT7eO9X05sn95Ynl/IesAjP9PFh1kp7RQ2N2pE598iRvbAt1UGxE5EGr/uzPqfOFY2j8x9Q3HuPKkH3FGFJyfxLwU3i3T2qVPcN8yFmEx8Jq9o4T5W6bCAmOvB6qrXqRDpsIyVqbb0RSJVlihuFe
 FBgCBW0U
 mI5GndddvITSD8M8VUSfQSlyCKnO3JXmFCo0hXCl/WFOFXJP3w/jsZAzlS8gPDNENxcpYweTfGkAsfp6MJzQ8FMFZWP+qfPV9Qu2IKTYvOlu9X5DnppkMAud11TPgjtAGBWAXSjHfAapQdsuI3G10Ltq6j3AgC++J6PWLDvG1a1QgeGjjlMyapJnsWOlYV0oo/K39pWZSSNqgzFVcqJTP4ZLTzE/mIWDKdd4tioXyKTbIqd1Xk6t76PudKNobIq1ePlWCRpXqtO8QBuXRwq47StAXmz8NYRT9m5XKeV5Uds+tNNpoJzg1B98P2rxzfMNRHKJBfDasFypgH87cVQnpL1oxmhySpK4ibDuP+6uQEu/Dd70KC/mgm/MQm+62f62svK/eDowtgVfxVXi0SUqdo//7hinPa8ecgthJ0wnjNIJr5Ms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/23/26 18:10, Sang-Heon Jeon wrote:
> Since commit a492abe28bec ("mm: hugetlb: move mpol interpretation out of
> dequeue_hugetlb_folio_vma()"), mpol_is_preferred_many() has no callers.
> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---

I'll likely pick this up for the next cycle. After the merge window ;)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

