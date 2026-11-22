Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C875606A332
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RpmKIC0E
Received: by kanga.kvack.org (Postfix)
	id 3AB786B05BE; Sun, 22 Nov 2026 10:45:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382166B05BF; Sun, 22 Nov 2026 10:45:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BECB6B05C0; Sun, 22 Nov 2026 10:45:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF726B05BE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:34 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B9EC140709
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:33 +0000 (UTC)
X-FDA: 85463179746.13.5B3CDB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CE4F912000C
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RpmKIC0E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362332;
	b=a6EcOddDcpjFLD+KRhufE3IBoQhBJEORLwHhWci0UXZP51kgmyd23CmhB6/Jmht/O6ApwD
	aLe+NNFcLNxj0w7ts8LI9oq5/i3hQL5ITPL4KJ75696rKcPEMvfHT19KUh8b3WVtuX4VwL
	5BwER8YNZeebTxET2uTm4wAABlzMM1U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCGP8JTWzk0/2UfRI3RCZoOyl9BDZqYZnwzF6Lb014U=;
	b=NVcVF0TnsazBlk00i3V5dqyxyLEretcBLPfpMFRf/UU0qCTNgsFLOQySNljpgqjV0cbY7o
	L1k0Z+Wqr7SA5HQ5aMOYIXvsU55sJG66SWfE1PoaTAR4RxkHOlX9XOHUpKpj7n0qTW1Kvb
	cwTidOtJd4auCv2Og+3SVeDruMym468=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RpmKIC0E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29BD24442B;
	Sun, 22 Nov 2026 15:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8788E1F000EE;
	Sun, 22 Nov 2026 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362330;
	bh=RCGP8JTWzk0/2UfRI3RCZoOyl9BDZqYZnwzF6Lb014U=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=RpmKIC0EaValzjjEO3VeeYj1Xa6emxKYiq8pGa1cpyvcCbwLb5XvgCX5fyp/Sejqx
	 CSMfQrAilu620202iNsT3Hw8ORq0X2jzFY4pYnMqYfhit/sz1mYsX+Df5EzayngTwT
	 H3UDvkL4OnIwFGwP1Id71EY6GNV7F7q3BwqhFU+VvCAWzqeiKmUa776PfmOmqQHETy
	 dPXrSfH4WoLj/Qnk7rapof4sdD9xw6LCWPeA2bmGrT+p1VsbsVxbcl8Gu36V2aU5Kp
	 sK3t5jFhfkoWQtNWtwoUbtuODLioLnlzdUJliFU/lt09rMjNEpAYUZjnq5LalNoq/O
	 eUYwxcPdX8bdA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 06/11] mm/hugetlb: initialize all struct pages for
 bootmem hugepages
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120100856.16929-7-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-7-songmuchun@bytedance.com>
Date: Sun, 22 Nov 2026 17:45:01 +0200
Message-Id: <179536230137.3933282.2792134004607727535.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 5gg8igy5tpre3xtj4wz5txs6inh679ts
X-Rspam-User:
X-Rspamd-Queue-Id: CE4F912000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795362331-840132
X-HE-Meta: U2FsdGVkX1/0rWVmNTdjM3dHOSalCyJ00uQSCwvqLPuajkKPtWO3nE5uj/7/lZmNe45pLU2NrNSSfjSacq7HkP0tEq5nE/vePJ1CJ852f00ej6JluzNIz0QkhDlkZtK2REjCFjNMX+gtMyWQnqa9fRkPBfRhV8KrT+NwCNyZzfnYIyKtVaWOEGqKHiu9Wbk/4CpPOz/SE54f5iC3Bh+W/8dQBh1PULZrRWTA9HuZPieqewT5wUF7P9yG1PScJ1wbZAeT79BcjULCMvEf3RInx21+tcwUNE8oRKz85ozf/wMc/88rGN4p+MhFXX/TIDC4fhF/FF/vUqiRmuTvtcZX9Tt1XZv/cBqwMMOjxeF0roC4TVk59UYmaDEt+cwAMiLvsA0JGdW/69B/iocTUO0D8lTge3BbBpPg0vEXKE7KLhO9UdZPT6sdsPMnqm90Es6HkcRxaa4HD8VMC/mQhTXBFmgglrV0NYUFELwuzEiyKaao3EcPz5glC0YzRLi4VqnnP+zGJPWmgocEp0+370a5YmuiSCupZZmks+BxJ0AI5j9yrTXGkacYE8pESxLZOjALdlGfoWVI+S7VFLe4tKuzZC/u418CCqpIcDBnW71K9hwTGAxq+NiJ9B1SlosvVoJKI9mLWKeANXdb/kvblVj0qaG2d9kJhbUhNbtNccUrVlxbUXE3gjXplGaDm8s5dDW55wZjJrfcDOzcEIeJIDc2rnunShmoRMVeGNjtkhICM/b51H3A0+a5QgMoNygr7cU7sAfZ39mGiTQEDOMRtwqZgTNboQCB3y6y+AtpIDx00p1A88qfWesud7/H9g7VPTDeKmJwtRLjbKNbqXcZEUh8+SZG6IJwvW4/0eonDSSoB+okTxOyHZCD+x6Y/KK5SdNn9KJyGKvw2I9pURW1hSZY5FzecFKv254yWMGbiilnQD5M6YHSrDGFTyvUmymNHpWDu6LDHTv9YoL6+EMQg28
 k3zL/OWo
 +47NwlOf5mLEwB2RcEY6TzvFzsjapLY30ZlBkT7HbLF/DUOeHilOovEIvvuoj960u9MxV9C7eHGblwMwUofzZuZS8y+D9YkdTDmTJToTZazlAlDm0W0Gz843aK5mbh1CHBz9G46J7iBI9pUoXGw0qLkt9H9ISftQMthTtRBYJidLnq4//EvaqJQlN1V/3kWHrLIARHTd1meCa6yTQRNMAja/yUmz6IYZPqJUflO4gCrje/VkKX0uHqcb9xLkVGfWM8p8uSNLlnhlT4TewdVoDrqrKU3bMkBZI7xy/kCaKNIn+VE/DLw1q86kwWYxUYVvtz3vSjom0tMHYD2cWT5B54tN1yJAEkoFXU8QvJzGntA2B7zqhbrq1i7eEpgbyU1JHiBH1SYoIZtsIkFpfRZqwSnAEzLWVW9MJ4IOZQ4174s3fMXeG3wgAlbcOqVYAFEJU9taiB4SK46SH8kS4Md/Jxj5lGTO83CImk97P0JP6iJNZDUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 18:08:51 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Boot-time gigantic hugepages currently leave the head struct page to
> the generic memmap initialization path while the HugeTLB code
> initializes the remaining struct pages itself.
> 
> Mark the full hugepage noinit and initialize the head struct page in
> hugetlb_folio_init_vmemmap() as well, so the whole compound-page setup
> is handled in one place.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


