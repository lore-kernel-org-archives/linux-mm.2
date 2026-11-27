Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00598606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 13:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDdSKGXy
Received: by kanga.kvack.org (Postfix)
	id D689F6B05B1; Fri, 27 Nov 2026 08:31:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40516B05B2; Fri, 27 Nov 2026 08:31:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57686B05B3; Fri, 27 Nov 2026 08:31:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60F986B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:31:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6F89A0354
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:31:27 +0000 (UTC)
X-FDA: 85480985814.05.580EBBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C46961C0015
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:31:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDdSKGXy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795786285;
	b=nOdlZbgdUnIfgMmKxV3oZJ3FhArVhSJMkJeMltgBbQOExxoRvBHHXca4L7WEiWe4sEBYzz
	QYJ1DBNs0bJZBFlHY1mfmi58L3j+raWBBM+o/Yr70DFW+ZcPs+3EQJDkmJuO1XDzcXF3R6
	QuGjRbWjbtNSglM5FbqEcnQWnVAfb0k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795786285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0z6sSTU/TdAcuzF7iA/kyixYbv3IzU2XlDp1SQnjzNQ=;
	b=drTQCvt3GQxy/9wEiGP+J6UUEiEIESu3IDamo8OJLfKyuVex8/hBICPuPAYNcBSPzhwMsR
	d7HPEyWR/RIdx+ASMW4tiG9Fsu49Aaw5zTZY3ujLDWnvfbhZ5W6HaKt6Qs9dr1HYJKE5tA
	LAXr0CuANycFiHr8ML+nRy0sMQA9dMs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDdSKGXy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 358A4618FB;
	Fri, 27 Nov 2026 13:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0D51F00897;
	Fri, 27 Nov 2026 13:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795786284;
	bh=0z6sSTU/TdAcuzF7iA/kyixYbv3IzU2XlDp1SQnjzNQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WDdSKGXyUuZx9rzbH1QdVdWzt3KPhTCJSal9jfcn0PGNUuL0RA9MFTOTtlpbfx0Vd
	 O500zjSpXoEgIjneIZ9K/JtzQ7ubAb8b/7eXV8+v42Qko3luodLBoLEA/xw00NIWnl
	 KUFWRnHVScvRlE5I2CPlYlEWgjt0ZSddF+16jkLamDkim/nV1S+yODiKNU8P8cjFc+
	 lbvXUQIi9umJd23ENeH4KYdp1eUsGOkMUvBGFeVeYKHIsQ3pzHHhCIgaKBAwsnRwiW
	 /ue+A8m7rgdEGTxGJ9t9Y8DHPz+PLpiSE6FlK7JQ60EI3FVxuFLjWYuKsJzSNt5fYK
	 9qMe+gWP1o6Bw==
Message-ID: <9c524f3b-d27a-4360-aa56-d6ca4ac1a6ed@kernel.org>
Date: Fri, 27 Nov 2026 14:31:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
To: Pedro Falcato <pfalcato@suse.de>, Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi
 <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
 John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org,
 linux-nfs@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
 <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
 <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org>
 <away88BuU8ibcTA5@infradead.org>
 <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
 <20261126022418.3620783-1-tz2294@columbia.edu>
 <50045fa1-0b46-402f-baf0-a08d05282410@kernel.org>
 <awmE8VSlF2VTHLGu@pedro-suse.tail5790ac.ts.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <awmE8VSlF2VTHLGu@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y5miaqqitq3str6zbqaqx8a7ccdu3brj
X-Rspamd-Queue-Id: C46961C0015
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795786285-843853
X-HE-Meta: U2FsdGVkX1+0rD0GKCf4aQ7CvWt/Buw14jwBykD9Bwc2q+oKLlblmAKCVD0Flybe6/MidQ/lYJwqs9h3GjO5fg66A8n2lrdz9FORLm6n3rFMtaR0O4yqFmRtd7NGbK55l+WjVM+OpLAuhl+ZPZKUWx3aVTTHSi+Uh5H07g78pEJej+wVUxLjY5JH1uMTAQ/elR1jZB5CLvUFBZcs8vxgaofTGhG79Om40haYPu+GRazhUJO2v6/P3W6y+mWXWz0F90XzGDTybxKMZbwsUp+sndQhTxHKF3TtwB1PdfL1gp3CrOgmKINuycxAvEDEpUuNbGbv+0yM+Md67WYZW9W15AgGVdT1NN11cwwJ/mTEXTlCqZKlculHqaWe3mdUBa4tk63iICC8ZA5XlDipQvgszBMfRh3p5d9IuLl/872W2kVCwlCk1/T7ZyPwe3p0GKzcjpfAVke6/3KzAODQOuoH4XFC7NwVms8P7U9tyEebolvmAjdgr+0NXSR65i0mKBdrDZ9KJtsO7Mi8u9XxF3DSW50Hwdb0fKADSuutLKH903wPDuBHovzYzZ2NRE0lx1DYkyRnzahSSrSqIZGYwDpTKz72UkLjTSEru+vpQn3EFKizhqK+NEwLQgx5/L3A0ELwQYMYysHip8M5+FOXSdfivAuWt0kPBelQkxdQSTVEbF7/nHzmkL6tSn/+Br2t5hNaWmoNAWOHOqAfZh6p7es/YIqiCgIC+/SH9kEYNlaaBRLwn0WheeU3dqVnLSR0NmaixrmpQTxj/Lz7eY+el5HiwkXsaCV2r0T9RSb0Ggx7/jzp4SzfLyTxF3fOyBBuyPuqO6D5yfR8PHzKLGJ1KRjPpp/S1ukfty8qDeQk0I5Xe7vO7iL0d4Znn/kfyffHN1vEfOGY+gO2ax9CZzCWX0AkFFcSB76vCgq7SivZQrD3dhemm91WZ1a/Gigkgn98vaYYp+3WiDbr0X0iSiPmF4R
 k7J8ru6I
 +zVD4qnMNtIdZZWZ5mzb4mxFNTN5yfTwHpLOESjcIVKzthNq5zCog/nz5rBOi10goyRvjF+ju1lux3Jq/WMZqYzfVqxCWVN09Ibog+uc7hzP3bVCCrsGmFLARqxX1irwF8xFo4m3taJR2qJl6FRFUkUrrzuV7VM0oRrvBqu4jtLQtNNbNOSWhX4C9kM5jRrosFz9KAzbq70EO6uy8fY5pOxYrYmM/taUTYCNyzLm42of5X8VY3DXeGn7o257bwlT/TTn/Gdob0a3kDTAL0A6lEDJbUdfGGmE2YLNb48YVzGlsc808gWq2WoBUWVTP0PM4+jd/2qTcrOCj2lfYFO3ap/JoTEWIQ3WOp5jrxFe2ynS3XAOyq9MyHAQFQIZI/4wLItrsOr6fGDlbO/5DVRccCnYbN6AnsDuA55CnMoLpwmrgr30HMUYKM9TphqdABmIfbs6lBCw+Km9ZM5ZRJTrLyiaLaJl8a5/ywDB6+z1bNLdq9ixDURifzufEAkMMEPShJg1/C5VK8DKZyqylUeqhlQjE939hoNCIDnd8iUMHCH6GrtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/27/26 14:30, Pedro Falcato wrote:
> On Thu, Nov 26, 2026 at 07:43:37AM +0100, David Hildenbrand (Arm) wrote:
>> On 11/26/26 03:24, Tal Zussman wrote:
>>> +CC Miklos
>>>
>>>
>>> Coincidentally, I sent out a patch to convert fuse_copy_fill() to use
>>> iov_iter_extract_pages() a few days ago in order to remove its usage of
>>> set_page_dirty_lock() and address a different race. I think it should
>>> address the fuse side of this issue as well.
>>>
>>> https://lore.kernel.org/all/20261120-fuse-copy-fill-pin-v1-1-72a0d888f140@columbia.edu/
> 
> Awesome!
> 
>>
>> Oh, nice! I was assuming the usual "we use put_page() on some random hidden path
>> or core code" would make that harder.
> 
> Right.
> 
>> I recall that's the reason why vmsplice
>> still uses FOLL_GET years after we discussed that it should be using
>> FOLL_PIN|FOLL_LONGTERM.
> 
> You almost gave me a heart attack, before I remembered these vmspliced pages
> aren't writable :) That's a battle for another day!

Haha, sorry :)

-- 
Cheers,

David

