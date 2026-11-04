Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9151D606A33E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a2+bCu0E
Received: by kanga.kvack.org (Postfix)
	id B9D866B05BA; Wed,  4 Nov 2026 04:15:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76D06B05BB; Wed,  4 Nov 2026 04:15:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4AC6B05BC; Wed,  4 Nov 2026 04:15:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 897986B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:15:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B0AC160674
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:15:49 +0000 (UTC)
X-FDA: 85396879218.27.BB0CDE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 83B721C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:15:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2+bCu0E;
	spf=pass (imf20.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783747;
	b=0j5jC8HIL/U1kFCExlBK/tyIhyQolaKPtKn4lD8/tTYCGT3S7298l/MkNZ3VY1OJ5R42DM
	OR7sVwhhL2xOMM05z3EdyqrrYuacC0MKERWNhOO0/W9ljasAfyiei/6scF5urUDEYASF8I
	C4dnPE0G1ubnNHLmFX3xHd5N6T5G/VY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2+bCu0E;
	spf=pass (imf20.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6nd2a1srhpplQhjW+m8iYpRcQ9IInw/BXmwf3MtK4M=;
	b=UWPl6tGhWMEO3gfo266JmrK2xTzIAfFgavbnZ0gMpaQ5cTt8kR9u0cItFCd005zJ15p+nK
	3/zJ/IdDammVhWXCRiEV1p2sH460RwqVf8UJNHOeJjjKg3FciUzf/D1Fg2HVHWLVOqKxGE
	oFGTEq5NTGI6XcYmtdvt2tz0okV6eaE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5DD141687;
	Wed,  4 Nov 2026 09:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0953D1F00A02;
	Wed,  4 Nov 2026 09:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783746;
	bh=R6nd2a1srhpplQhjW+m8iYpRcQ9IInw/BXmwf3MtK4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a2+bCu0E3dVreX+haMDi/ZewO8sUAUoyk9PY7Y8/kbjxsI51VBMLyQgICDlHW0uGY
	 eyXBkOGWDa0HVEf13W+vQGrBHgIDiYBRLAoxWunTWxNdQGReeR1HGocTVjWklapusa
	 CfyxA+WHtGQSp5EfsMOgglQpSDxez2Nmh5Sxgj6pdV5pR6uwi367hlmAWg40I5kszC
	 ngLrHN1uqE7AM5Vh7opmHNrBRO+VuYCk6q90B8G7D07R2hbuuj7uf4AT6NDATzX3Wy
	 LVZdGnXfqG2Kc24QxBDTveEL6EXuT+wT8pE23PzbsfShpY4Wc23c7dO3md8sTEUSOz
	 7Hmvlk6cje9Ow==
Date: Wed, 4 Nov 2026 10:15:41 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/12] mm: hugetlb_vmemmap: remove HugeTLB-specific
 vmemmap optimization macros
Message-ID: <aur3vUvlWCTAxA4F@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-2-songmuchun@bytedance.com>
X-Stat-Signature: pdabcbta155i7qjcmaf1zmn83bsbui8r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83B721C0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793783747-249338
X-HE-Meta: U2FsdGVkX1/WDTzj69JPJ5/jbyz/dglc5C80vckrsi7NvdNX70YUIcBNwFCl/BqZ6peZhogOLnkelXabOMmHktv+xaw2p5fgXo0ffYkrPtF06CMEiDfmriDHvT/nQKoaYEEbA/RWdpCHIpvSvv/+yFKfC4vYOEtHjPhKxEG9AcoxDFGIgjA4geMnhKzWC5PXYN9rBE4WZdIcgxJ1kCvi7vq/bRRRLL/EGIMoBv0xlRAb2nvWCahMe7U6zcgSelWDy7hM92KteiZYe07NRiae1D4pPRZzm0nVall/Ajv+1AkTg1ADiqwRcOp71UodBGc/nd2J2qzh4Ro7irkjoLAIazSmp1jjs+kIVug9vDMBRyPNvdzyEtem0NtXm7+weUN0MfR9VWfyUhveyaXfToLb1j3vNy7D/SMvdaxF1lXZp5SI/+NbVq2zTyjtpH8xYXglM3Ok3wZMLsJBRdTXcUHD4Mtx83DlKag9UKGtPmvF/iLnMMiYDprpyLXWWgaG8vjHnoDDtdjvksUdIyeRxw+NtnQnfrXoM8TJ2G2fDGLU21Uv5v9JIcG78/RXCsk9dct431p+M/H7+e9ffBH6lfgZzsC4W+TKNwpNzp1cHjQY0UY0Zb4QpG13L+lnZajX2zBedS8J6MkoglAh3+/t9QKc1eHWXeeNJtIAmcafILBMlYI4Mdq5kxXcteKKOLB+ta3g5yqovvtbZhkMavWEQaz8d0PBxfbOx9xiucd6hnLfhg1NW72MZBLpiCGDgSdFY3rffgZA7FEjOH4RG6YM2YTeodHxSqkaGq+Py9BrD6m83qutcZKQeekUKfo2Sf1oA90Ovmdr2zapQgZHwFiylJCMdWwOyy+vv8TacjYKvan9OdkTKpKuLxpzIE+8rE1V0FGfL4YDPzoZT1oYt4U2qgbgH+jDfdpcWb9G/is1WG1MOLSi1EpoGAGRiqyf8RrUg0St6891OwfwOaXx+82X0QK
 hKhmKPcU
 fCt/5uAl+ToQzvGf+aO21XBkYqynrZ7qh7pQisTWPsWmG3sRrH32BJ4Th3ApI5RTTyTMH5yyE/zvvT2Zj0oZoI3KsgfmMz6MMxs3YvhOOxIW3LBE1n5ySFz3zM7E03TcpFaha4DQn9FkUgSxFuX9uBzI/VKsKhv+AnNPvSR7M5WRS7oRMjfZPdOeDQI65A7MwQXKEdEZPQAq+wumccAE6W5XxmZUO39jMMawLmeWtBjmLW4wWxdWZ9tz0Q05WH3kNQ/vPBnsMT4uYwsZFAWxGQDRV4V0JlZ9MIrXs80V3ndR96K5O4CU1seR9/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:34:59AM +0800, Muchun Song wrote:
> Vmemmap optimization is no longer HugeTLB-specific, so the remaining
> HugeTLB-local reserve macros are redundant.
> 
> Replace them with the generic definitions to remove duplication and keep
> the HugeTLB vmemmap code aligned with the common optimization macros.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

