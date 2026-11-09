Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A02606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dz0LFd/6
Received: by kanga.kvack.org (Postfix)
	id 7B5C76B05B5; Mon,  9 Nov 2026 09:48:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78DD16B05B7; Mon,  9 Nov 2026 09:48:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2A66B05B8; Mon,  9 Nov 2026 09:48:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39B186B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:48:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D78440630
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:48:35 +0000 (UTC)
X-FDA: 85415861790.21.8FB9FC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3579E2000C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:48:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dz0LFd/6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794235713;
	b=0Am0BroNs1wmvVGjsufXERVUaAsW5CrE+kfp/nAmesEf442OUNCoKHVFCWjOTUSBqJWu+q
	rAAm81v3TyFnbhqDIIvIFWZlND+/5cF8sqJqHGk3tLYsmPhw593+fG+kWTwP127BPfAbYZ
	mMiSiFs+PGZLV+3IAoZWuD/NZLjYoKw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794235713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eigh9zARB3K5Yks6WSGw85FtpjPdjIU2WFiM1YwX0hU=;
	b=M34SfE66E2T1+6qvIF/T6k87yJ9P9Nyhr4RJp/CyHaPBncFWlN/5LSreaNh2YjPrNEMuRH
	5CGwMc8YD1O9YeVkYiNdcNpx6zUZlheQKZxreQPm09zATruBxo21bDLHI8NAvsqzkAYTMs
	pkmhx3UMrvJsD2sXaf/puJKa0zLBr4o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dz0LFd/6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 689234117F;
	Mon,  9 Nov 2026 14:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA891F008A1;
	Mon,  9 Nov 2026 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794235712;
	bh=eigh9zARB3K5Yks6WSGw85FtpjPdjIU2WFiM1YwX0hU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dz0LFd/6XIMfjXdzs+pMzB67I9Ju7xSYoda8FIjhq3hedCPya74hwuKLSmcux9hke
	 6TH+3UVTOwRz8fKDdsqMLSQDDkSZlwX6aRhNKVgCvN99mSdrpRqXTWHZiSjgZcO9jP
	 0SbjrPQpABg4zHADLcge2uFRH4PwaEvCXZsZLjK2tg2cTX868lHeT1ruywvD7t6aOT
	 FEwebnRCugED3YVOYErNDeUuKZ+HfkDBO9NVVSTZ7x8VZLeeLsxqsKcL4PiPPOMcQh
	 4O99aONWfscqmDEjOPzUaMTCQic18AEhCdX2aou0OxNuFJB1wVMz9b1zzUb0DS5Eqk
	 eQ9QZm32EzcVQ==
Message-ID: <01605605-d6a9-44c6-a5b9-024f33d8c488@kernel.org>
Date: Mon, 9 Nov 2026 15:48:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/18] mm: count the pages waiting for a grace
 period
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Harry Yoo <harry@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador
 <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Luis Chamberlain <mcgrof@kernel.org>,
 Ilya Gladyshev <ilya.gladyshev@linux.dev>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 kernel-team@meta.com
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-5-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104130118.2507513-5-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3579E2000C
X-Rspamd-Server: rspam12
X-Stat-Signature: spz3tuy5dswbhe8m7xh7n3twzyry7a7f
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794235713-243954
X-HE-Meta: U2FsdGVkX1+3L6gPI3cAc6Y9KeP1AY/vtUiyWRZmT1UrBq2Nc69K1lU5jVuvwfP6PTXfjf+NCZm3yfSH6dO1eSJ4h0aVwDuKWZCA9TWIbmELjP0meaDJDwEwPtPXfGaMjuUB1kAkp/6tmESVbtFfMJk0pC64s0pGiMnELWvw3dizMKBc92NJTZ6WDKDv24zo/ZBAFlYJyNmG1qr+ePqXdaotCLJOcbaGreoJqnaZE32VfHl54r6cpj17OlPOOOE0NMWXYdaJIssCF+HAnmFSIveCjjXklL2nQ/wFW2JTaGMaN4kvRl0Ztwj6aZoiXPGIkpd5BJPxpKxPAOEFjZqXktTR3TCBqVyVPMGsMWbHmqmZKupMKCH5I7ZZyfbGeolshutePsc/izpQQ7XfNNP+GF/2EyJQeniOHvDLj70bLuUJ4SPtVZP6dyaQUCsWAtcrevKnbgzHo9xhJD6Ddn0+BDPn0UlMj8gyhcz59TEbsrPeqbNqoTmf8gvwdsDV2/nWAld+4Y8iz38Q/7YT/T7bSR1trTmvwPLEF6j87WCbUM3kFf4JfQILMkUE6C8EZAe5IDb3QafOlw6d1xxz5CDlx5KCPrm99A9CulT9Aj9kLEibyXksIWfnxJtTvy2VHDRs85OQJKsBxWaMqhD+41kKte1jzV5I7psYj96K75dNGstYdB9M5YgZ30lYw+1yQMOHauoG29A2Xky6CwNYCqAUgmfX4Zv7RJ5jswpQ+MFd6wBWNR0Cy///a5i85mzvKb/RNbBWDFTJemMrmebOA9oG/91Aq+qiVuq7IO0f2t4iFowL9eFLCHyMvrvKX4nFCO14DG3d9JehTx+SGPCWZHd0saEDKB2c3QDwTmgJmXlX4snIMjph8/ql7F3nrsAS7NQ9CSLHXucnWu8XBjGsYJY9f9b5VYxR+N1nh6RVdCa7O/VKV5F435mn3PqhsUBIo5X7P6H67t1Wk+IFbpb3O5r
 LpMjvAof
 6Z9+1RSRd9TE79zxiN6QJYHiZgPVKEkQK/SrN3PubpuhQWsxQwnMIuK0WkD2RShp2En+MNaZn6JJN9aaQpg4P4Kr5J/+jUJ8t8VmZWsGC5DMdIjpdfuTwKPgsNiWr4+5g5A1ZfZM9GSk+qVAG+rhkREObpzNxGSIRKhwZnpK4vwRE/mY63Cgc4BS+Xp87n7j/aL9XUPf68ndxPuwc7KuPbT1MTa0nHgeduGUgP6ZIOBdc9ldN6uwwK/SiBQZLxReJ91lGi78UQViXb7AcMaNS+9DUaFI7eO0ZnaUKkNxN6JiNOE1suTWGCk9JIN6wlb4TKV7Gdl8x3npfmPzMbTodkLVH7HbbdTU26oDLT8okh8fqwilyYZo6YmXzVTG8lNVBd9lKFbQdMaKv0qbRaYwX57Tw5yjS/Rdtv3qglYGDYnqP71sAFMFU8wPms54qdzdsgEhQvjicVKcngfOD6kXT0Jc7g1G60Cxe3/4atC1VZAN3wOR98YE3D9KcUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 14:01, Kiryl Shutsemau (Meta) wrote:
> Deferred folios have refcount 0 and are not on the free lists, so no
> counter shows them.  Memory that waits for a grace period is missing
> from the free count and from every LRU count.
> 
> Count it per zone in NR_FREE_RCU_PAGES: nr_free_rcu in /proc/vmstat,
> free_rcu in show_free_areas().  Preparation for freeing the waiting
> pages sooner when they hold back memory that is needed.

Even if we switch to having this folio-specific internally, I think it will be
the right approach to expose this as NR_FREE_RCU_PAGES. (not NR_*FOLIOS, for
example, because we want the actual # pages)


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

