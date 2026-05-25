Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A83CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2B1B6B0005; Mon, 25 May 2026 13:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02556B0088; Mon, 25 May 2026 13:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93ED76B008A; Mon, 25 May 2026 13:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84C376B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:29:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2ADDD140195
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:29:36 +0000 (UTC)
X-FDA: 84806629152.19.49B0BDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 789C71C000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:29:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NX74LKJq;
	spf=pass (imf20.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779730174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3paURfHuzbm+zxGp4fe8y83ocd0xA8H387UcFSHOVuc=;
	b=V3Nap1nddeqsVx5YHPrHDj57z8RgUFBiCb3J3sOPqNyawkgthyaF+sgPNxBeEbfDrzg2/p
	hRliXzgv67K8QEBCCLEsAgZ7kb0UGXQT1i+lRvoiV0dMsx+XWB429+zQT5D2Z3dbO+3aga
	o/1ZL+Ivedhkl++8/dA5uAe0mELK3eU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NX74LKJq;
	spf=pass (imf20.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779730174; a=rsa-sha256;
	cv=none;
	b=AWhFIZUUS/q96ekg9tkTDyo9AxDd1L/QAoFB2qngvnKm0MMGYzeUgC8/+ww00yFMK3Zwaa
	5KBobgrlGmGRk/og/vPIIhoKb/8VSOe7vy5Ttz0pBNiOE6Zd9JdgX45Ww6ZFeJGhDDWhg2
	bcYE+DLG5oYesXZQ9PAxgBoH4lfGCa0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90A9543FA9;
	Mon, 25 May 2026 17:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6A81F000E9;
	Mon, 25 May 2026 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779730173;
	bh=3paURfHuzbm+zxGp4fe8y83ocd0xA8H387UcFSHOVuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NX74LKJq/IjUDVEmxYUJwJ1ISe2v0ECqFGIT4e4f0KgSYNfV9C+7CKD3fGy0nHuhL
	 WdruTXRaEshe6RqKjS8eJHUizxDyH/k4gZNZTaDZFsOXbLU+eMlDyetEF+fTQ1a/qL
	 /Z/IADSkxqwxWyS8KVGTZniyyEmo5vymXF7R79K/tiJUHjo4pzOo4R6qKSMJWJPSYV
	 WpS5bOzZdSU9sqZWkqk5Rst73jagSk3nko+eO5vZedPM+zNwFfElsSOK05eODEyY60
	 QsHkPsWTVXzxgf5UJWiQzqZJZokKKSSKUGsKtIJ42D6iKCk43AdPItdTfFWJpWlgWs
	 V6IkYsZnlXaxg==
Date: Mon, 25 May 2026 19:29:25 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH] mm/cma: fix reserved page leak on activation failure
Message-ID: <ahSG9Wl7PVIz_Ugt@localhost.localdomain>
References: <20260522062658.4095405-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522062658.4095405-1-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 789C71C000A
X-Stat-Signature: kopwy7qzbw5o3hbhaurdyciwmrq3zka4
X-HE-Tag: 1779730174-773302
X-HE-Meta: U2FsdGVkX1/TiY39RJBl2i2ACZ1F++PETBKJMss5WHMuhPSfVgcUQnqfU0wiZXZzDfPpwC0/1/fe/vXKSx1cfukgfjUsPKjd5n7esy0g3cbmkLNs5Gjg7or056/SnJQwHXQ3VCci/zJjKkJojrPYEgWs+xc58HZ6RPvclm+rZ4pAWyapwyKReEjfehXfnQBW6q3lnnSztvyWRYJlyy1Eb6jWk3MOx61r0Y4MWziY2LAdpFEzXd4PmYcjI9G3Pwi+5eEcnTas4kPcoomN0mF9gQdUW3pnS2sPuG2NHw99U0wEWO7kS6aWlXoCx3hfPTUuuzVw871xTMwgg1H8sRnMp24s7jTPMedfFIjoaPFkxj2UqBSLmvDWxpFvFHTRxegkaJpoe231tHJMkx4Dki42TeollhZJSSrDTAVu4N3npYlckAurkgAuoDJDR/HD3z+iacrt1/7WRQYa3TF00R+isTJjGCIBc4Ys1Hd3Dw3tErr2sH5IOuWWmyjD7jmInrEb6+hkRm+vnM1IuFECN5rvRCJO14bh13P8As6kxMlQLLSSeSfZMn6yZlcylb8ePazFlZWlP6XYYirSRx+IlFUdsW3r3BVEthd1kgymRGCqolt3WnJ9wo7zQE+HtVpvE56qkQZP9Qk+KuKOyOTY5JOdVCdbJtJmFmXhekTW9+CVwl89daMZiCvrI1nHyZBl6ScP7JqmhEiBo5HWZmw0p1m/OS80kXdrB9yEHrcWIfpc3bEw+RlMP24aSnYu2SDBNBCPTFrGYZjRrfrz+dn3vzvUYxGky7BFDU87a0pCKDGt7g9aR7RrS8eoGeF8ooL+cVmulVM1wfB2abr8d3Nni8X6hLdZPr/+m/BqrqqrcGdCjJl7M8sOFOJjOflDGUw/ThCy/TYMUoXK1LVyMF9o/SIvyVTdkhploD2dNFHI/M4iNe7PSB3G4jYPpgXnQlbS402ol5WDs56NeeXYpIQdZwR
 qeD96oLM
 LamuklVRvGFlnPLE30ceJYlDHcAxiJ3BdHNq4Oo/aaDW2hNJDYa5MDOUfDcX3wVV7C/qaIBblGG//VeLhpc7eUTl82nsPPBbgHR3ugz3iCkY6DwLHTbF+tuQbHLdNgZj1UTp8iz0jp3+HGhAm59sogW3DjMpjifJDE069r49D3rYeb1KECJkXFXMPR1J2UN3B30VzZvs1lcaLUFHKHjfqqOArEFh+lNSLX09tTT9kWSliQCHMZQWIrzoIc875742DP4Ck
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 02:26:58PM +0800, Muchun Song wrote:
> If cma_activate_area() fails after allocating only part of the range
> bitmaps, its cleanup path frees the bitmaps for the ranges below
> allocrange and then releases reserved pages using the same bound.
> 
> That bound is only correct for bitmap freeing. Pages in ranges that did
> not reach bitmap allocation are still reserved and should also be
> returned to the buddy when CMA_RESERVE_PAGES_ON_ERROR is clear. As a
> result, a partial bitmap allocation failure can permanently leak the
> reserved pages from the failed range and all later ranges.
> 
> Fix this by releasing reserved pages for all ranges. For ranges whose
> bitmap allocation succeeded, use the early_pfn[] snapshot saved before
> the bitmap pointer overwrote the union field. For later ranges, continue
> to use cmr->early_pfn directly.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>


-- 
Oscar Salvador
SUSE Labs

