Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B08C3F357DB
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69436B0088; Wed, 25 Feb 2026 02:19:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D179F6B008A; Wed, 25 Feb 2026 02:19:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8B56B008C; Wed, 25 Feb 2026 02:19:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC6326B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:19:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63B41C1BD7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:19:41 +0000 (UTC)
X-FDA: 84482128962.23.41F3346
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A62F3180002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:19:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z24wLhm5;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772003979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xl7Z7gUruNNpW+fHQvc+E/kFpNYCV0ypKGzs8ld2fko=;
	b=pOhU3cEIM8swPO5mZKAZOLNrS9B/R39ut7HJz3/nGkQwBR1wJTIkfnjDNS5zoNHmSybHzc
	Rrh5IwfP0OetuIrP4Cj9T9Trv0hz51z1JChCw7+ntjdzQjRhhFW7ox/XxoDbASGpYnPSW/
	xMEZ2TmGNiEbQD1t48duJmxDAsbnvzI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z24wLhm5;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772003979; a=rsa-sha256;
	cv=none;
	b=jINQvkbdGvkqTnWXw2K/EZ4x/oSY5EJD1GqskEjkDjLWe92Z/wvS7P4uzD9THmh4QTZE3h
	ptyCfeiZvm+2e+OxaYAatG3253ETutDRDeXMQRqL+7HGbTnxAzidy7MWAWiw2ZePPNWoBF
	2Oz0anD1LwNbIS/WqhTfgdLcwvoWgRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7F334040D;
	Wed, 25 Feb 2026 07:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C22C19425;
	Wed, 25 Feb 2026 07:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772003978;
	bh=A7lRttC43wF7lpKdY61+Fq1GW0SYqkp06OO3jF4y3oM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z24wLhm5/hlhU0gkoIm6x9z2KjkAIaHXIYJV4uUyDIR+3hmm2Bl1Ycmw6+TIfLpcL
	 bdzlprkx0zhWuNM6KdsT2ER383xrUWorB+MYjjkLrUhH8WPSfmMZv5ai9+Dr62Nuqk
	 yEvyIlsaervGrjeETEBQg8ogKCxZ+bH7A+mCTe+Wwu4h4wbMH4u23XDfo/Mfhun2jA
	 hdJleBHr2kYeLtdzt7VMWUxAjImTT4y134nJTkge4cKYuTcAYRY93H5gmbl5yzfICn
	 IlOcLpRZB71TR98tr5eHZ+mjbXIc8ocAa6yULW9aAt+hOsjlchEgDrR+oCf4sdLm6A
	 6n2iLJ74d0RJw==
Date: Wed, 25 Feb 2026 09:19:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
	willy@infradead.org, brauner@kernel.org, kas@kernel.org,
	yuzhao@google.com, usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com, almasrymina@google.com,
	toke@redhat.com, asml.silence@gmail.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
Message-ID: <aZ6ieTRCPs3IKWpp@kernel.org>
References: <20260224051347.19621-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260224051347.19621-1-byungchul@sk.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A62F3180002
X-Rspamd-Server: rspam02
X-Stat-Signature: ddsnem5gfojtgrgru69jbodeneh81n1q
X-HE-Tag: 1772003979-931158
X-HE-Meta: U2FsdGVkX18t+8M0082oaUPqWCrhscQ0xvyAfZXAZ8W7dmkPgRBHcBix6lRnlcrtmI+IbMKvlqD2cRUXAzBsx6ua/U/z6J81bIN8iYedHCOOeuJgRaBqXD0YtC0H+Ew436tDoVppnTPU11jfJCIgRGnuXPqhlz59fDimwirskhBJxJlXgrJIamjF0Y33Xpwh0ETOI5kRDsfVPjtDTR/b84svmnVD9xENBX2YvdRGrmRkkeg1IXJc8cvkor5nhxvLOUByffQ3RMMZODEMB6bW4t0BYgwTUg6TyGMuM6Hqb3sLlh0pHIxbF3k5RTKZcXzWlciiMbqj8dsmMRFCsNs8QA6DPAZmn18zTiFf49gKekeazAWGMoYYk0frdb/fNC0De+VUd+mPvHfB7M3zlfzMdB7To414yr40ADv/lWisj+B2104L6v9oN5W4n2IsSeTypJYprRE7s1E0ng4sxZC8LxaxSREkdrJa29vSILoMMzp3wytith+hEvKKNxa+25jswm4hZefMaL7HrG7Df5UFbPol+s4UYQkKCxku5zaCxZVRcoDCwus9/9LTeiUaoOiKTPL+yJ1bx8jqcAjgLHyN1EcTe2tszsLMcxl+l86G4O9O759lA5PQelQYYH/t6I6SFgheUlhKAB2jtuHWz46fWLKy/R5cw5Sr8aFaRK282exvyOiodhQsKNtJubx474LjuJDfV/1GIiT99T3FNTsZ8muKoRkg+i7tzCKQBUDSWmCmEEL0SLQERcpU+vK5oWQY/rvmkt+455nkwMhhPHk5bLj3iyD9z4EjUpcBovAHQUuZV3BOJmBxRsig6GYsIKQHv/D0KLzwIGAuWnfkp06TqyXfO5EKUR7Y3RhQDuUlGmdpWDrdQIWMHjW/YQVruOpi6P7RoYrdg2dqKkxq0yo6uq21FBEG+3jiBvQFa/AhVbmeD3isjG2809VU9cCNSq8+i/0UwkhN5GlLfDyLeKC
 l4PVf/jp
 mow76KGmJSmQHeilCaIbEzNN/yUatRJkPjXTv7BeJ/DX0lj/SVpCNxKCo/BxZLFa66ZbFhEkXhitSpmyBZZI2I8dBSQNP3QTtxv5afjmQtIW/MyzLKFuKao1+MPTI+8lTSnTKokAmhLLXkEZuCcpRVl/DbLCpoLzWRycr/S8BnsV5ibVFUS88Lwf13bkX8Q3lln3dmwGjBPjaelJnKfTiP5EcLinra0JoUKgmr2rXX0qrNIPnOHsYAqEPyo870RgtlyiZxmsOKeSocDibah59Ht2OJzE09l2V/Zx2stxi1hzL9NM8UvlQ2y/ubY25QWbfAaNFpnsxWlDufsjFKB+y5cA2zG/yV7j9sA1CemWs+PpDMX+sR3TW66CXaaIEtuiHT+w5kUr4N6abCGQJa28EDDCWq60/387pMUfY+z6pAHOXGJSCp0N8hnLeqvyBKw4Bb1GhSDp0nxVLmzkzG0n1FSiBARLR+vQE3fdU0n05BX885QDGH1GjPUawJXqzsW5BzQo2CP+xEIWi7qFFg32isnyvmkpX0ry//GuL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 02:13:47PM +0900, Byungchul Park wrote:
> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of @pp_magic, we should instead leverage the page_type in struct
> page, such as PGTY_netpp, for this purpose.
> 
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
> 
> Plus, add @page_type to struct net_iov at the same offset as struct page
> so as to use the page_type APIs for struct net_iov as well.  While at it,
> reorder @type and @owner in struct net_iov to avoid a hole and
> increasing the struct size.
> 
> This work was inspired by the following link:
> 
>   https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> 
> While at it, move the sanity check for page pool to on the free path.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

