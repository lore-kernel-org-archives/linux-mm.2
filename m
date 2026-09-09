Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3BF4C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 08:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96836B008A; Wed,  9 Sep 2026 04:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F586B008C; Wed,  9 Sep 2026 04:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8FF6B0093; Wed,  9 Sep 2026 04:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68F9B6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:27:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 752381A0125
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:27:31 +0000 (UTC)
X-FDA: 85193544702.02.5328C9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 88D8B80004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:27:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DxpQ70vV;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788942449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0Rzyh7HeitS+Cl2oZ/+e3jq2LIt/O3Me5tIP5ut5HI=;
	b=4nh30zoJlO+X+Z6UTS5FQs86lo0B4VWQZ0m1s/59IivnLCkuD90PJ2PxQVuW3nyrh7RlVV
	cQNGVNhHuQGS8kKNZLsp86Dv3Yw0TDmdXaQoo1ZbeV0w2flY6cYXtEnm6imwjpUKBlxUN2
	8BiWa/ddsSaDcOKHBz7ZCSeY4wU1GZY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788942449;
	b=FRl30modtfr1uKrKB+0DM6zsTL4eq17a3D2/fNRAHjX3FIVfX0LOjWc0QRk1DVRc843L/Y
	0+l6jGRE1g2zaYknAGWmKlfTBlY6CK9KtF2nyQlJco44y+d6QfYiKdF119Q2iTjlIeUzmh
	jZ2vKZPIURzDT6Yi+PNncbDKK+EE+Cg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DxpQ70vV;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4F86601FD;
	Wed,  9 Sep 2026 08:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DEC1F00A3D;
	Wed,  9 Sep 2026 08:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788942448;
	bh=/0Rzyh7HeitS+Cl2oZ/+e3jq2LIt/O3Me5tIP5ut5HI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DxpQ70vVfyWUmA+ZrDRsQIn34dRm5mR60+YwqLQSAkYCb76TYFdtGo2AprxlchWm9
	 lk4KRk2DR8oBxN6xpX4QSdFGHEgFl4xMUzb8ceB7yEPStNQMRNWWo8YGlAP8rO+bD9
	 3zIWMRb9fqQyFtxqls8igAEJYrUCSd16z2VeqEFaAP5xn28G8spfK8O768e3TAYEMH
	 E3EV07hrkoRZjbJ5fOHmoN3c621XPnsIx+L3i4Spj7ykysUnY1P74iLw9xTuq/yRnj
	 HjKN4L5oGHL/ldrg2sBsvPGOyYmwpVisuJ7sHFhkX387VbCXPb5nTgT30imyOnrC6w
	 wNRXvUS/SSPrg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id BBCF1198004A;
	Wed,  9 Sep 2026 04:27:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 09 Sep 2026 04:27:26 -0400
X-ME-Sender: <xms:aRihavEBcfVbhPHnpy4Dx5gxxb9BHr8UgqEX6IBNl3-L2IRg7YIuOQ>
    <xme:aRihavZkTdis2uNdY7hB8oUXr1G6KGAPuqqU8VFXH0-I1mQGRiQAaim2TnZaMwI6E
    0KplmyMLvRO457kSmdXm3ZjPg2cVOfShBNKBl_LQw_3kb5HSwQXGhiD>
X-ME-Received: <xmr:aRihavMkjftinPWAAr8-QJGp7kK73JXVTHOl17W9Mx6GT2gxyoWrj1OD6oA>
X-ME-Proxy-Cause: dmFkZTEddfZnEYmTf1C6cpbNKU4/ggsY7/87Lkko5CAZ9fe5ECTgAw7eKmfXAKGYX0kEiR
    vYXB/QXOu/xyNcJdmpPk3Mvy0n+fQO3A4k8A6sl8IhYiKMAXteKY2F252zlOOHu2+HKOxS
    N43N0Mw0CkGKM24YIScpJdp6nF5meX8cQPQpaut+nI/VfBoLK/FflQQHbgulX3B2hyRnAB
    Q8qQMNdPe4V7ayqGRX06Py82LMVtnNIv/qq0IdKRpVXfLLGvmyrodBLdSLZMXRxM4+sqxs
    GRoDLRGrAsa7rTDrQ0XWWuYHe6hXTgkkjQSX1gKp3fn+SZRxBjOHTCF0xMBFA9k/QCrtBL
    vFfNxsVduRmuPhia8db/nRWhmXFC7QdOLTKWHjFQmfEQRNTAYE+45dzC7YVMGP2X2lzCix
    n96NYDiW6j6okWm5jLOQRtmIKv+NyQgthtdtpxGkn//Ye/quFll2dv8vy2FKKRRzkvUwvm
    0yOgRG1hQDMXypzkciaXhw/oQsPjuAVWowbAwx/vxNjNBretfrYJp8dXsDp53L7h9VoX6g
    C3Fegjd8jHDhz84KKaZ3pY51edZsAWpZHGjZq5R/+mVgDouT4mioEHe7zSh3hxmBrlCOYm
    0pnNo38t14MtYUizzHhPFE/ThLbZhrkHoK2Cu++zd0AXCLWjDiaI2gRrTrYA
X-ME-Proxy: <xmx:aRihaghOl1qkE8Kj9haobPriHF5cEtZw-ISAMzZXsJIw-MD1XIt3xg>
    <xmx:aRihareVcNNnW4zLSsEvKjpTwU-0TCY-y7HCMG_4zz6ekAYIlZiZ9g>
    <xmx:aRihalwKW_E0GT1H7mJpLZvyiDAfQ17j5LegguMpYPsxgecpuEysRg>
    <xmx:aRihagYCyVpyhFPKtFIRB1tEtt3Amo88WaF9nM8BAvog2aoP31clDg>
    <xmx:aRihappwYyjA2iBYnWlpWYvMhOHzTs26WQRi4ukgwa1BtETf0V5xWbEI>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 04:27:20 -0400 (EDT)
Date: Wed, 9 Sep 2026 09:27:19 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Shivam Kalra <shivamkalra98@zohomail.in>, 
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v4 15/17] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
Message-ID: <aqEXnraNt7Rw9db3@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-15-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-15-b532a3f20e71@tencent.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88D8B80004
X-Stat-Signature: xjnnbmkhybrgktpfgnco36pm33d1wp68
X-Rspam-User: 
X-HE-Tag: 1788942449-287326
X-HE-Meta: U2FsdGVkX19+Q3+6yKfpc4t3w83yq3LFuR8mR6RAnThdtsDVgnyohioUq56WjiIgauQTi5WNYr7pUFQS2r3AiKZM42GFf6VZm1NmQmwSUZesWHb+QikqimDuDhzUs88Drw9A4w8yF08sMdwW2/Ibojwi7eglh75bQc/LnHgPKmGzVVw0FpxU3uAlUjORXjg6X7OeV97MNCpFZSykcmrdiyj71bK1d/EwYJd+EByt6FIQ4T7ML/EQV3+Ny+QtgmOGQpeGP2m8CXlh2Z1pUUzkdB/XvckpZSXo7iuWgDpb+yMayxYoTUugB+y6ZMMZIMZcwxL3ObSw2Tj6mepAr9voixF9KgD1K1yyr0vKfFbb/z6wTIt3W7nUARTH7vdotBLL/U35Fy/gB5kvEdt1nqWvvcx1B9+cHDc1W76erO2XeNVchKccp+oVCG+IGHwdcWnCuZhiYwwmvMOnanlRBhCB9xEibO4SrnZwUM4k4GcSphr1GwSpi/Zoe9tQ39MJqqNCpolvEEj5EvwKpebXed2HT8x4kuGpLBu7yziIaEh79jlmA/r+rbVQrShAR2Dv8KD4iI03JHTI3MS15EkoiKE/jHbKhmkUIXxGIgtMz5HNdEvYMgCIY0hXJ3SmEZMHbbS4SHhtk7/XPo5OLfEzeo/aqp8q9vKaQLY53YCQdnvdXu2AnlHFiYCQppxHrh3sOEvjy8Vmw47eIlL0E1Hk2mjZ15i9SI00aK5aORX/2WvQB+rwMJltPGcgfWVGI5tWRwF3VIDTH0ep7hM7sVUD+c5O3ixcGZsF7cYOTDTQlKl9+F/4GVXXGWIBdQJy9/QXt0inVu4RAMXagh+s672SZQwR46jQG6LvLx2G6vCY9KJUA2s1fJMiKoS8PHu7zCJxr6xQc3foWdfXUcrSXn181I6aP6NSgyLIA4BFZ8KMLHhUxmxbfixCadD0AJH4MPx5Gjda2adjeYKrSM7KNdxIti2
 ftMYdFbK
 HFgddq6+JVukX0d2W8VjkTRXoVIP3GBsHKdD/xMALBGjx4O3KFfAr8sNhpt/n9BL6auDvZQmvzI1kYONVNCkJ5HCzLJDUjj5eto68jU8RtPj8tI2Tcfd3cGf7OoN/Fb9y1m3M0Sx6fxzqB981Q/NozayS5XPmu3E2+wqKK5hs/cMXeMXptzG08TeXYhtFb21CbmoDuK+zMZ/PeOZbuhOxOKZpAp1ke4pxWUmg5It5jKY8QrJ18GF7CUOQW+8JbUDxkCIQosvFEKlpKgmuGqZKBOTvYdN4ueEtxcPAIwDzfoqRBZTIBjksN55h3rWUf32uANE+K5bhLaGEVaz9veU3y6vynY9E6oajc5Q6CVpTQl5ZYaOxIAzCVw+us2th7pHJ550W5hEPkr11MAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:19AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
> and folio_put() in the after-split loop.  free_folio_and_swap_cache()
> unlocks the folio, then free_swap_cache() must trylock it again and
> re-check folio_mapped() before freeing the swap cache entries; if the
> trylock loses a race, the entries are left behind even though the folio
> reference is dropped.  The sub folios are still locked and unmapped
> here,

Are they mapped? remap_page() is above the point in function. It worth
rewording.

Code looks okay.

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

