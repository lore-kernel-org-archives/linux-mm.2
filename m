Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EFF0FCD0CC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3FC6B0115; Wed, 18 Mar 2026 03:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5952D6B0117; Wed, 18 Mar 2026 03:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA566B0118; Wed, 18 Mar 2026 03:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38EC16B0115
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:58:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA9AD140612
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:58:47 +0000 (UTC)
X-FDA: 84558432294.08.4FBA373
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3D2A718000D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:58:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g4UgzqYJ;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773820726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wC7UO73KH72YNre22MCS31L2BBAxLoXqRKQRwydJYVY=;
	b=td6pGOqgn9iXDEF+7WZ5KmjGBKyeYHejCTyn3gjNLr6D3Umdnx5TePPZS4ANdRspPRyEgx
	PhecJEG6lcd5lIn5jr/Nw+lMzZ9Rh+4GTKtR8D1FTCqGNOYwsAxFJc9kqVKT23QBVlB+EG
	xy/qJJpQO9I6WSMJv+ASet2o/I7sriM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g4UgzqYJ;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773820726; a=rsa-sha256;
	cv=none;
	b=4q48fnCehmBXxud1fQrgTO5KsikWIZFprn8zRj5gzDazu6pKKEpR5YJkhmrnN8q/7NuQis
	U26QByONKM2QcOLm8SfN3y9m+9YqzzczKPAWYPoRM6qgWLc48UN5XxmApImzMHLfVP238I
	sxqRdGoSWFB1seCsVtwsewjMe0+mhwM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E30560131;
	Wed, 18 Mar 2026 07:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5681C19421;
	Wed, 18 Mar 2026 07:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773820725;
	bh=TSz9o5tvOTZ2cq3b3ru2k7TcaEErBWRbUWWJKKC2YWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g4UgzqYJCE+HF+LMkXzFA+nazQ678pnyMe9kot/PdZix3yF54zqQdRYZYbdnCHxHP
	 iC54hPjuOjwVn8q5/7EPGqd49/GeYZJB3GaKW9KFjaK1sCYLesYMhla+cRMOUUMZqt
	 9LxzG7uG/i67y9x6zfzs8TCWu+g2YfxD3A79sTQGlO54yGSDa7YwwiL5udcvdggDLq
	 wFZRJlGmlKZNArvHlQoxb5dX/AY6JES+5QN3y/Wns35IV9uGc3oI+1wkqdnuWVowkl
	 E3Fsi8iaEWNVeIk1SloYX05eWi0cM5B4Oe4lPytbtcZzhD0/Vtn9EZDdQjWv71jR8B
	 NcBWkAG56+P0g==
Date: Wed, 18 Mar 2026 09:58:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 05/14] mm/sparse: remove !CONFIG_SPARSEMEM_VMEMMAP
 leftovers for CONFIG_MEMORY_HOTPLUG
Message-ID: <abpbLRegIPqAuvJU@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-6-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-6-david@kernel.org>
X-Stat-Signature: catm7x7h5cnrpi6fhf6xwfcikeapu6bn
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D2A718000D
X-HE-Tag: 1773820725-733272
X-HE-Meta: U2FsdGVkX19UfxTxmzKe5NbB0/KldMZiVeFku0LFvCG7GvTX1sguc0b3yjSVulRTSCzy0jfQ2yA+HbmM+EwH4j3S+wrBuCVH+kYZa8093/aP0U33wzNU8nCBjA8u38mLSHkCND4sFSpL65CyDf8bRtCdDwosBzFerI4Z4zPHRyFuH5VRKXKJICsfgXoAQZe6ODJ7pQcyKglVbtOHwygxU1DVt/Z9ypjZZy4Q6alEoniy1BPm2G1qx/OfRcL51fjFCoNNjDMFyawLtOb/tC2AfXM9vJxv4SK/z3J5Xv89civHirK4G1taufTEhmZprCHItDaBu/9TZITlAjAh26jU1Rsi8pAjZaMTHRd9JTwfLnoBbQpRC7jVHuiyr1ktVZzGaZRg6CFxRSKOrVhmA18owrJ3hrYsSOCFh9fXqHIDY2TWpPKhAmFGLzwrKJsO+RlxkiYpsGT7AFJsYqT+hc41ShgIZt4knN2X/IP+U8zoHiu5TjRk/PRPr3ws+yO0dX9B3ol7IPGnjNtZ+snEtb1pr3LoJ/bAR0kplMxCC9IH6l9kBo7hoNqHqJCm0c60kaHYU43Pn/TQzRr0GIbgw/CV6n61hNDMdiPNgBLjRIh0tYGIpKTHvBZnBN+8q4Q/j8TnXfTqDdmKe3xBfn4FvmiPjCeiPNxaFNq0so5SQir03xEOMUao0IzeVZ7cLAU1gI8eOee47DF+9NDICC+7bfDWHanCPJNZXoqE+JM8AFWKD5ffSTSNMzJac7VFhKY5ZvXgYHWpYAeCwcgy2gOID6vrASp16D6KrwsICEA4vEsftZNj0l59EftwIYAhlQ89AXdbupAAVq9gyFvp6aOfHH1oTMT7oadyCgJ4ypyaRqm7LZA9H7jwUIHFEwAJApljz5jmX8BbKY0cEFy8sxfckc/ksuEkD1g20y/jDmyWeCHNyZwem2oEKBmWPQdrQHGc/CDOU+LFf8+WvAZPDVSoGmy
 Ub4dsM6K
 IkK4sV+WBzPs4fNUlHvqPw54Sy1fcOl4V/+lWlHrwGYN8D+T9C862cQIHVZS91hdMT1/F2WMehNvSC4xMCJXkbOk4OldVpKf2PuE/aJMvc654r93tPOqcN5UwZLIMswSZPBtLq/1xlKtc77NO0F3TPc4614HnuRYU9wEpuuTlGqHShexlLvq/M4o+kK+c8R/G1i2GtVNL0RDAuKpB+8NULex0GKsGQSTMUd/f/35BRoSSUh94gSWzIJxEuh6u+1WINqVkw8vRkg4tC+6RdSyGabK32kqIgNGeb+r+BMSf3k6f6h9hYGZeScwxkZTiTetZTMJ6p8dgpeKTClgESBPpDUeSEphv1j6/tG9eNoTtQUPVdoFEFBpfZOtjwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:43PM +0100, David Hildenbrand (Arm) wrote:
> CONFIG_MEMORY_HOTPLUG now depends on CONFIG_SPARSEMEM_SPARSEMEM. So

                                      ^ typo: CONFIG_SPARSEMEM_VMEMMAP

> let's remove the !CONFIG_SPARSEMEM_VMEMMAP leftovers.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/sparse.c | 61 -----------------------------------------------------
>  1 file changed, 61 deletions(-)

Nice :)

-- 
Sincerely yours,
Mike.

