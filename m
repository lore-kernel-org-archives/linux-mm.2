Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B86606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 22:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVr0n8Mm
Received: by kanga.kvack.org (Postfix)
	id A438B6B03AD; Mon, 19 Oct 2026 18:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3B06B03AE; Mon, 19 Oct 2026 18:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9091D6B03AF; Mon, 19 Oct 2026 18:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5646B03AD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:53:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F394FA07AD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:53:00 +0000 (UTC)
X-FDA: 85340877720.12.6A8A7D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61C8FA0005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:52:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVr0n8Mm;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792450379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2yzfANdr008P3OVCzU9Slqrea3vsmMtQ/W75M6H3iYI=;
	b=I2pUtGZgpjokgu2iUK1KRRpCq9+0M1/inyD+WjT3QlJx6E771GIUsp4jQ3dEdY6Ip1r7QN
	/4A5pvP+yFxzykqn+LdLJ5UK9JtnL18X45TiGGBIr1tQtAOFHAE7EjgDZboaMQ3C44m+XD
	n+7liDyNZ8HhvkZQDu1w+MtRVwReLko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792450379;
	b=wbS/5Xttkloo1a7yI1ymBBML6htHz82GXMsTvvP7W6n4m3MpGAmnJYjE6PJYqHx5QfukZZ
	8pc9KP+vFTlxrGwBX7v14FTB0C22E9LJw8nep2N2vUx7+ej6mkUmdacKmG5P2eTSa97Ezi
	pidduykwdsupRgXbPlOH3sbxA50+AQ8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVr0n8Mm;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3B44600AA;
	Mon, 19 Oct 2026 22:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E071F000C4;
	Mon, 19 Oct 2026 22:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792450378;
	bh=2yzfANdr008P3OVCzU9Slqrea3vsmMtQ/W75M6H3iYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UVr0n8Mmw41qLps0hPYUwOQVtio9j47QXYqxs5PvDuTeRUq8I01TyHbkgNTC5n0ue
	 vIRxlIzZRcVXb3AYRa4WN97A9VSZuE2s5h+mY8ZptvvAt2JycMdy+CO02xAx7UQDRq
	 Np+w9zZT14YEEwIsgN3s3wxJ6ZXoUrukHQFFl3zKcW38xPR4c2v4PKiMSZcogFkDuV
	 RPl7rypS5NsmEPNWjNQVuJEeJN6XKXrcucN3FmlaFiWxbQtwkL5oPcyxcdNKwYP664
	 pbPOf4OKHQsqQyx/fKHMm50PiFGB/7DEdWcrmEMgufbxmJ/wzrTq7UfgU9bKuvPK6C
	 GskwvCtoCt5YA==
Date: Mon, 19 Oct 2026 22:52:56 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, ljs@kernel.org, dave@stgolabs.net, 
	roman.gushchin@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <atafPDtIstZZ2byw@google.com>
References: <20261019185002.3428594-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 61C8FA0005
X-Stat-Signature: 3m8amaigfe97kgp95gyfz575jbdnpzf9
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792450379-251860
X-HE-Meta: U2FsdGVkX19FTCoeZWcNVNQgP4WyIlkj3enBOR2fUUNpWxp63a51UwNUlY74e8du4qCR5zDiDfOc2norBqmQorwZbTsdtWl1Ygb2uOmcUZYmtUSW7uWSLx4ee+CZgSAxMjEt742X69Qv7+ri7ILf4EGXIL9I8MKfIMlwDZYSa8M6VrIqCtVN+hahgIME9E9lOaMVXZlGx4ZMrek/oOTSZ3jo/ru1agHhFRk6vcybtrxqoeloH6nXHBt+CtNE98N4Ag+HaA1cVd2a6I4AFjBBnsK/cXDp7zSqHsZY0d9DL5KjkP1akavgtazTpP3LoyQiGRBy4H7SDvSBKQ9rWcVnlwTobBKIYZrROosH/0G3+IkHypSKTWCjNKqPiaVOGtLmqkK9w/dlzoZ1T8cmEZdAKv70/WdtmG2v7rU9dSkETmtaqtFa2ukcenHz4JLu1OUEkE/FZpjy81ATqCj870g6enwtkiYoV09T/9nAXbiydI1x9+Nun5SEm2I2D6H861KWHV3OKtWZQ/us9OJNXLrJ2Gml4Q6XQqw/I1JXV4zHe95On86fsqwLmjDaL7J/mXjXpKoSrbbSn+5zUJw2bG/826uNftyXmssy/mLzjk/tIGA6vs3IHxyBK9CLLQzySgyqtra7JMwZdetdmq6zWrGxoKL+6ICv9ce9F0aIJ/AW03jHvIpgV0B/bDIyG3DmH6Td+cTt65ECFGfwIjce4330zC+iat5JOCJqjooYL2RfO2X3m9y2EDBuqtUde8WSYfVuKQ4GWn2vzW02dOBJ/3co2pefmQdIPsbiZU/X0CbawTIb5h8wpASuOnthWuSUfA86PeoCOYk5qW2ec51y1rxXXjnsDoiRXFbvbxc0tvNevTMOg4FVSN2aKz6MZ4vo4yUaAr0u15hyCIVo5WD6NHi0j/RUcmXlB60UQul5dSz9C9jhyMTqPQ1W1Y/HPENMgRTXXhsdEJvin0yZBwK6bkD
 I+EqMmjA
 onxpRRBqV19ZKSX0kOJlnCw+pz6SAa/huNG73Iye2OSlsODJAvDF/8NZ2Ncj5qnAqCKi99SCROuZBDfxsyn3Ers/adsqGhaBJvAoEQhOVu6bhzKpcq2YzdfIngWBB+OQvpUDUFUYZKUnk3JhOLJEO8XnhEMXCex6ICi+hNgwA+YmrYFR4xjUIcdZB9DZDAS/cUHs0W2dSYLbTQ9/BOiqUxBpO/3/MoBu8Kl3p+V40fIuiweiEo16fGsBzaNNj9PPfk7sx3YRlwgE5D3tNdQPuHkHAt94ubK8PwvYyR8OHFhIMREZlZQsnG+c2ChsabaJDOplRv8RR9ptWx/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 02:50:02PM -0400, Gregory Price (Meta) wrote:
> user_proactive_reclaim() limits per-node reclaim to
> gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> reclaims a node's movable memory. A movable-only node, such as dax/kmem
> or hotplugged memory onlined movable, reclaims nothing and fails with
> -EAGAIN.
> 
> To reproduce, fill a movable-only node with clean page cache and write
> 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> cache stays. The same write to a ZONE_NORMAL node frees 200MB.
> 
> Scan every zone, as memory.reclaim does.
> 
> Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

