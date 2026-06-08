Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 790ADCD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA0E6B00A3; Mon,  8 Jun 2026 07:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1636B00A5; Mon,  8 Jun 2026 07:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7646B00A6; Mon,  8 Jun 2026 07:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C05C26B00A3
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:11:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DFE8A0AAF
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:11:00 +0000 (UTC)
X-FDA: 84856478280.26.76189A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B795440004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:10:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JU14IZp/";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780917058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtOtVF8QaSt5DSHcymyO5ibaZSfXXzww0Quv4U5FVX4=;
	b=6NLaSpRZEAoXVPYQN6yj0SwJumQzZ/UqxFpdSjATVTaRm8HuORZEpbADN9EuozDwX+UQFi
	gtqx5Rl1km6N7AKrPv/f+E89CRKCMo3rN/gP3cgMfhtgCEVPtFl6QdWyDbAc9JoBuFOx2E
	zeCBBM/FQJka9+aRpOr8ZlqLl/O1fps=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JU14IZp/";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780917058;
	b=Lkw9AxHlv25AcY8q0Mwfe8mkAh8b7mhRUM+0YZUc/+4oPiAql40stiGXhDChxe57XNo6lr
	FISCF6HrWxUFHCvaaCVTTJA9UWyStOsoezR89YaK9DqPHFMd34ozp2QqA/q3QLmXZV17Uk
	616wbp8t+XpGWDJkP/UeUAEDOqlmLHU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24E52600AE;
	Mon,  8 Jun 2026 11:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5684E1F00893;
	Mon,  8 Jun 2026 11:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780917057;
	bh=QtOtVF8QaSt5DSHcymyO5ibaZSfXXzww0Quv4U5FVX4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JU14IZp/7b7IV/ZfI4w8G0IHWoMcVfNrtbTIs2nw7fd5/R9bvHXLEXmFGqLAIqtOB
	 YKHN2w9HYLsr10Tn9bB93JatGjaguIgxyOf2/0Ber0sJf6Pp7pO4+Cuq/xKUM9IKDC
	 GcgbxeRUJYFRY3ulZ4C9Tanhqhcx6W3yTJcPrw2X4FsXT9C9bpItDwCbiuUln1smos
	 y4Xc53iR+OUc8ITq8PUUmEjYfmUdyYWiC6KwNGn+8NER6rEqLXXKLW1FEntyVaxHI2
	 CFyXnTXJ/Gl1OW8p8HoY7DP8/jxUlyKLcmVGc8B+X1exl3zonBG9a8SGeO4OzLJYE6
	 cngyJX+zbEzdA==
Message-ID: <c206fc7b-9014-4ccb-8180-300a95145c83@kernel.org>
Date: Mon, 8 Jun 2026 13:10:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 36/37] mm: balloon: use put_page_zeroed for zeroed
 balloon pages
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
 <619342ca2c01c60862fe49cd4a790d171cd65ef3.1780906288.git.mst@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <619342ca2c01c60862fe49cd4a790d171cd65ef3.1780906288.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B795440004
X-Stat-Signature: apjmern5tcfne63murxpcjckwpuedb5j
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780917058-290023
X-HE-Meta: U2FsdGVkX184ZOEQtcXb1VgXMHFZAP0zWC9sUM6DvglE5aoxgxxG3QRPU5vV8f51JiuAXnVxGUK2ywjS2FfjYv1nozZl591JGi9insOJbxjLsuu4g5/7upoqmZu1/6yeyARC/UolhMnkBocoZ49aG/3Ei0YjAzvTxthYj2Fnam+YOuxe9sa8VYhyeZSdEQ3hLJEkWPoGKUUXAXlAaVVSPuTfN2svDitjxWLurIhWo78ouA6TXQ8q/E6goHKNwDDLUs9zoGSn4AZjuXQjWNQVJuC0yXeGUKlncHguFno1AxKmv3cr8Eg1/sJHC6gzSoAXHxR3PTWfywsfR5ja5YwOZmYZRRnty4LLdwD9H/O2vClviil8BNZMZa56hzH3GWucKAJ9JPsaoYz5cWYA3zBINKDKEjEgJoTTmsuT2P4LVP5mIsj3rd3DhcDn4QMli7lG/mG7d8lgX+5Tfp36MK5SaF3Z3rTCn5yXD5U2N66ezBiW8+1DvqHgfmN9uotB+R33MDtSUyraMVSJzrbX5gIPnY8PWhG7HkOaITSNam92h1PoKD7cCn6Zb7FzV0wR/WVjDjhBfo9mX0SgtBeUCLaEOZXH3KDb+eQaROircJScIP9eHYaB3KJolvvGIanF2QFRk65f7z2B+1gL5BSS2RfSzx0hJC+8wGWJRqdsb04LLkG2EKGfzYTWM+1QBhaCYUSaXUsAteeUfOHNkTC+iiV8+P1zxwugll8p4+I+lPUzD9gNoyK0vBJjUwDpNKbBxtxCGZAeHatycc43Juriw+qS3mJ0u1IoCfgWsML2/C140naZN1GFLb0i3zRpUdxHliPqzlIboBN14hXC6Es6dVsYBy5kMm4nps8Q6tu9gQgKWXqFxxd8gahLZrRqvp9W8/XzVl/8JJ36TOkemefjOptpjGQBHKM0NXtHcdOGeSydysIGwnLojvCm2n2ACBfDYD5peWbSOL4713RR0u75D4k
 BFCIRysA
 9AGh30jWUyxiPVKz1VgjvUkXrjs8awzsKQzS5QahEaYMAyuDg4i3qxgmElHKbYAIEtt8x1WQujKZ5LOkVVMtuB+dkQ8J5UqRIZXW3aQ0hk2JCaHVEKdE9k6N3QiDvKKL2YAbQ9otcoHvPjahRxDPAl42vdQKgIHf6WM6Yr9hqxPA1RahWajHec98jFjf5A3+FmkgJScXHIXjCLFsZhlK8+Y8UG2p9OnsA+xPsvQit1dphOkwCRu0A8TMcAGkew9WqZn80/rw84M+1Xx9P/zETebWdQ7+qaMUh54HQnvACvV03djp5npE+Lzq86/9YfFpBJhHY7ef/DUmBBDYg42ZsudzP6Oa1+SOz73iVTMJfd6drvjDYc55ivUNA6OaeJm7QHSRWSP3dWVbO1GU+AMWc6f7joQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 10:40, Michael S. Tsirkin wrote:
> When a balloon page marked PageZeroed is freed during migration,
> use put_page_zeroed() to propagate the zeroed hint to the buddy
> allocator. Previously the hint was silently lost via plain put_page().
> 
> No page has PageZeroed set yet; the next patch
> (VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE) will set it on
> pages the host has zeroed during inflate.
> Note: during balloon migration, the migration core holds an
> extra reference, so put_page_zeroed() will not be the final
> put. The zeroed hint is lost in that case, which is
> acceptable: it is a best-effort optimization.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  mm/balloon.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/balloon.c b/mm/balloon.c
> index 96a8f1e20bc6..6c9dd8ab0c5d 100644
> --- a/mm/balloon.c
> +++ b/mm/balloon.c
> @@ -324,7 +324,15 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
>  	balloon_page_finalize(page);
>  	spin_unlock_irqrestore(&balloon_pages_lock, flags);
>  
> -	put_page(page);
> +	if (PageZeroed(page)) {
> +		/* Atomic to serialize with memory_failure's
> +		 * TestSetPageHWPoison; not under zone->lock here.
> +		 */
> +		ClearPageZeroed(page);
> +		put_page_zeroed(page);
> +	} else {
> +		put_page(page);
> +	}
>  
>  	return 0;
>  }

I think I raised previously that this is best done later.

This patch set is currently trying to do too many things, and is on the larger
side. I think we should try to reduce it to the bare minimum and get some
agreement between maintainers on the core design.

-- 
Cheers,

David

