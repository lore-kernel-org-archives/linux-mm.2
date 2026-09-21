Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0163C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9EFF6B00D9; Mon, 21 Sep 2026 03:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75E56B00E1; Mon, 21 Sep 2026 03:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8CA56B00E2; Mon, 21 Sep 2026 03:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E66C6B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:39:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEA13160594
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:39:20 +0000 (UTC)
X-FDA: 85236968880.06.6692123
Received: from mta1.migadu.com (out-253.mta1.migadu.com [95.215.58.253])
	by imf06.hostedemail.com (Postfix) with ESMTP id C536F18000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:39:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MOHCbkyB;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789976359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5w3ycCGa4RFXPrE/mVtI/6EI9P8fpVebaaYmqzh6+Ws=;
	b=DgboMJ3M6CCYk4wkXUzrDMYIcaBOoNQpLpbFZxXxWUBnNTZ2XaGxshopOTgqXyxEvXg91l
	tXysc3nsMIOKaFfgWVlDXr57M0W2u7AYNz+jsL6ywEPZp01MpEQM3sAYZawvQbMAaE5J3N
	Ex7KJibGWY5Aj2VVV891fAUzC+MC5qc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789976359;
	b=kKGPBzN5Fp08ODIRBGV3X0T+XwrOTrL/WRdWSZJA9TreCjno8dyKx+D64Ag24c2y7YEw+O
	hNXA6/KT8JoZQUvv/HArtyzi6EijqeBarMDh6TW9+lkyOQ8OwZ/f9SFsoS7j2/zLu/ymql
	Ga4//HlsVIUqiiyakgko5Gf3UoFTJ9I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MOHCbkyB;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QASj6Z6chGBEQBYT8Fc20eY9OhWz9aaUtq7xvhcRKKw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789976357; v=1; x=1790581157;
 b=MOHCbkyBVQm4tJ9DsrkkobQByRHrE03xCq8KQR+8P5TLGQdvpA2xiw0OsToI6SmT3OzfUNhX
 YUV98ukDxnv+7lT/oLUAhR6Isgqc6ZcLsMsVdHz/vkDAC+jwA5IyymPGOPbhwE797N4owb37Dky
 9z0gJsjcNnH0jPxfd2YE9QHs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 57f2f9324be8538a;
	Mon, 21 Sep 2026 07:39:17 +0000
X-Mizu-Trace-ID: 57f2f9324be8538a
X-Migadu-Flow: FLOW_OUT
Message-ID: <b71094a8-d5b3-4d24-8423-18882fbe0cb8@linux.dev>
Date: Mon, 21 Sep 2026 15:39:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/17] f2fs: convert the ->private flag helpers to
 folio-only
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kairui Song <kasong@tencent.com>, Tal Zussman <tz2294@columbia.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Nico Pache <nico.pache@linux.dev>,
 Dev Jain <dev.jain@arm.com>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, Shakeel Butt
 <shakeel.butt@linux.dev>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-7-bb68b6a21869@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-7-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5rwpm9rr3fmiuss74psce7haqjufk31i
X-Rspam-User: 
X-Rspamd-Queue-Id: C536F18000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1789976358-538528
X-HE-Meta: U2FsdGVkX18B+evS86InwL0oExUGuPzQzDv+a40Hi7fQo4cy/JpSbQbK6G1wfMjcYzEL4KQilSJ3xUt3SRm+0ZVdHQ3OMEUhbJAylBDDs+7ya394LQDJuVpcaoG9inpkSYsztzqJsZrLnmxF7UjEDb9WazlAbcjHU93lbJ/NckElk6X7foi2SvxigDbxLyxmAopgYEMiasuAJ4njryHzs5DPhN0WBzSyo9VlhIvf6ZNljtzExJ9uiHIgA7A1szDzBDCBPopyqaf8OwBodtqbE2suCUVkmYxAQaYn+7Deni133v5Rs7UDO+NDbwkD84vXsSR+MaDPpnq7ptmqagPpHj0xZJ9frcObiqsMJmIYP57ZFzChqwV9BqtPYzVpesy6bS9Q3sAVq3StQHDXs+sXiwUbmxPvUNbxNsH38BXPQHK39rA18fEYhYG8z0JtcNB6K8L1E0sZVJYRa6CxJY781MDyKhB0BAZLu46dL/8t7rKTo1ZTZshzT8GBqn+iiiD/d5nB8zuMjXN36O3wyAOx90Tq3xaI9SG/NVhz+2xZxnAwibD3TZM5UL9qSrtRGbYqaN+8HX71mcdaFN/tdLPGxMbu6EZwprwxF1nmVz6hCiSWsCf8Iovxk66jSib6skTwE1vg+fttDUap6GVYeis1y/Lk1+yhEa7DfcEbv6wRjkLpRaGI/FgjK7p8pL45Hu45iStc7voK6c2bMwWDQvdfP7IcG7ainkxDy8ib8HCULfE3IeGau9OCYreU2YMLqmXjNsbkAH2ewiwL/HDc4LkYXDj7leS9VQ8SxgJM17pgWaHqyf6Ubw6NN6qnAb3adc7CbG9gVEb1jI1/GjFZnm2zp3WUmM1Qj9mTAJh9hKxwYlyfZl4tsh87ChK1uZi+2/Tzzic4YQKFT5Fq34Uy+43cVntTwXgKbmlTvJ3XUdKRWCfEdifsibX4m1gOjURNF2I+QXK3dRerhrP1PibQS1N
 xLRJ3iLJ
 +OmPCXtKeD3JwlOh/2eVSCJswA3DcM6U6Aix55btoObXPfaHC7GxLt7K0yoiN9cRmQBnUG149k8Poh6Ml1ft3sfSW5kesYDqToq9yEBOnCwfleYjkeYksAzgW5fazvTVGUsR5MdDDGNqiXuwVqGNFbDax03mhVZhMajRWLBB1sooZjSVNCMj6wBIU7cm0V7+43uarEwOgs4/4e9ik6xV/hWQFON/fSMYa+wtsY7DlEFniLDQpROz6zQCIuq8X9plXU19+wzlbTwA2sr/DoS1oQmu/0gj7ooZ8xUB3jausFYWhROEDpacdEguX9GV43JemJwmeA4WWJIBA6WhFZTj3QoTffoo//o8f/Ve7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/21 10:28, Zi Yan wrote:
> page-based ->private flag helpers are used in the compression path, where
> large folios are not enabled. They can use folio versions with
> page_folio(). The two remaining users in data.c and segment.c can use
> fio->folio instead of fio->page (two are in a union).
> 
> Drop page-based helpers after the conversion and rename
> PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC() and the PAGE_PRIVATE_* flags to
> F2FS_FOLIO_PRIVATE_* to match. Convert the folio/page union from
> f2fs_io_info union to folio only, since no page user is left.
> 
> The folio helpers do a plain read-modify-write where the page ones used
> set_bit()/clear_bit(). It is fine because the converted code either holds
> folio lock or, in f2fs_compress_write_end_io(), matches what the
> non-compressed code does in f2fs_write_end_bio().
> 
> Assisted-by: LLM
> Suggested-by: Tal Zussman <tz2294@columbia.edu>
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Nice work! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

