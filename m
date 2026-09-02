Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 740E4C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91EBE6B009B; Wed,  2 Sep 2026 11:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F64C6B009D; Wed,  2 Sep 2026 11:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CA96B009E; Wed,  2 Sep 2026 11:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62F406B009B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:33:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECD1916025C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:33:11 +0000 (UTC)
X-FDA: 85169215782.13.4682E7F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2398040011
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:33:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WS8Athyv;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788363190;
	b=UlsRM1el2y9hQRqufnpYhuE6f0Cdtxw7TOCMkY648BZWXTKSkcjhFYqrn+jDzbTGlkQiab
	0dmThKjG1Io8jzPvyMC5c5OwNY5ldujXJvRNw2dyrlL9Rdd7kIf9BKjUVPhhLkHFarXjxd
	lD3uBtnXzGRVi1jURAXrnpgncLJ3uGI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WS8Athyv;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788363190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cj/GWL2SVH2OtmO93RaBliPKQJL7NAhn9AT6xWT6GH4=;
	b=naIJ/W0liz1t+yJDP3/rl6qrj6GLsgsOiPXdr5XI2kKd0dFvkqNuNJgG5Vxwd14UvK2x7O
	IGumA91jQUEaX6gpMGlMFjtX2sQWi6DvKi5QE0VdyQPZn7pbpnvGmZqWWDlwyzRJtKFEYj
	up6T0BHxVC2GHkjbuLmKYYfTzNIf7BE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54457165C;
	Wed,  2 Sep 2026 08:33:05 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 617873F673;
	Wed,  2 Sep 2026 08:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788363189; bh=q6zM+dYnk3uLre3h3ADt28YxAVcvVSD58NOOSL5QC9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WS8AthyvSC51Gh9K86037JTsHB1psTeejY/5kultKBFvtj7oe0q+D7TIKNenFT8nc
	 eoFvY/dbmoQu0N0cwiE4XiGbyOAkj/cxXEpIKIIqfUbk4nke4IwKXcWG980TMbr2YN
	 wQ45cdapU18X9zzjx5MKX1qsQ4eFw1qfjjmpCBQI=
Date: Wed, 2 Sep 2026 16:33:04 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] kselftest: mm: prevent random failure of huge
 page split for khugepaged
Message-ID: <aphBsGKJkpSphK8h@e129823.arm.com>
References: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
 <20260902-fix_split-v4-1-85f03905f7b1@arm.com>
 <apg7FNLtFO3Ea5qC@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apg7FNLtFO3Ea5qC@gremlin>
X-Rspam-User: 
X-Stat-Signature: pkphzwpbn15k4o3m3a8r5ii31trg17g3
X-Rspamd-Queue-Id: 2398040011
X-Rspamd-Server: rspam06
X-HE-Tag: 1788363189-577494
X-HE-Meta: U2FsdGVkX19G708NKPtSLzGp7wc8iIB8S1mfEoTwmaYKHSCKIfG3v/sBY67aTB+aFXXiizFPOBwMDn7CsG3qNpbFrsJyFJ+YLwgU6iC7DEkoOYjjsFu54a4VDEgDaikQ6tBknwuVBOMW1w2DDNi9NcCw4SUdwUjUUvnYuD/gw4pvmwN7mmUo5Wn31HbgKCF/5jMjEHMOorsrG45Y7xbRHHZOJDsw9tHtHwkBqFeHUqnZktUHyzDArFmF3+IQ7qD9nAD/MJnvrHa/A9bKkvOHGD/NORhgad10w5y9HqxqstIJrmM+Dv34ITOAlg3d0hEK+E0XHKiC3haWw+tmDmNx8WmEfOc9/UbFpu8AbQELyVq5TaAt5Sq7RPKWTN87APfFnpi88vMDSTicqFLePBkjtwHC39egEw7MZeIAEGFqQQszl+CxkKOXRdaQ1RdVbVmFgDLhdszRyx98CWsJZWWuVg/+iHK9hDp7rwxNNOKNCevCf65i6ec7ZX5bxs/f98beCkWAqvAnV8njh4AjeTyGmlfIFXzY6/14PAT7D6HW8dcvBnXizDS0Lyv+EQWgE1griLIiCN1ciMgdY1OZXgsIpFzFtTtoBr+HhQGRFFbdTeNA6MCmsDdawpqbUDBX1NG4e0FjNYYtiyEP659xiY7lxJI1H+cQehPmyVcnvwl/mf0YUEff2UKYA0QrbeWhM0is3qOGJhkV0c2HZxFKQXM+B6IfQnZIhmElKHS/6wEP500IAhi1wrTJFKvhnGOw9qgg5LIzdghJBEfAr1BqfbGQ9ITZzZD4XaV39fMNjSg7biIzO3oN1e+M2Y/FwS3znFVkG4OE1lhhTeAMX0gpm1dFOj/1StoZ7dxfl6lL0/EWNPzHC6xUOjiveZbSkok+w0uxW9/MODlOK315J5VQd4Xwzq+2zlEBgD+RTtqShLTPUXe20bXEfzJ8ftpqJcF6itvGD7nInvaFAaQdcUXW9vx
 JnAQhFg4
 pc+1bsxymZgq6WPnGWr7LPl9+qNrU8q4xyxEwRg/c9RZUvetRFpzeluVUxcoZpMdSKPKB5QNdsSphiGf7F0708In2QmrCJJ6lz95hrs+ssrtD1sUq+hG3niXv+4xuWMyQx1nOSvfxu3vfunfDAxEgDjQ04+DwIzD2C+uonqn1zHVFvdnCAHcaamrFlS2KU4lmzr6fI/XWsSQs2HXr1HRJcRXqumohscYMynasj/ozVK7nnwNU9m666VxGhktEowdMiumwS6p791aUf7X0b5FWIdcj+anJGS8ByEolh5M7qvc63o33pFbZsb0FgCbi350j3SDq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 04:15:17PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 02, 2026 at 01:09:35PM +0100, Yeoreum Yun wrote:
> > There're some random failure for split_huge_page_test when khugepaged
> > collapses pages into pmd again which had split by the test.
> >
> > Prevent the khugepaged's collapses for split page by setting the
> > mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
> 
> Maybe worth saying that MADV_NOHUGEPAGE doesn't immediately split anything, just
> prevents future khugepaged collapses?
> 
> >
> > Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> > Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> 
> LGTM, thanks, with a few nits above/below (sorry! :P)
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> > ---
> >  tools/testing/selftests/mm/split_huge_page_test.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> > index 86a603692826..4bbad892bc57 100644
> > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > @@ -168,6 +168,14 @@ static char *allocate_zero_filled_hugepage(size_t len)
> >  	return result;
> >  }
> >
> > +static void madv_nohuge(void *addr, size_t len)
> 
> Maybe call it disable_khugepaged() to make it explicit that's what this is doing
> rather than eliminating any THP pages in the range?
> 
> > +{
> 
> Maybe a comment here like:
> 
> 	/*
> 	 * Disables khugepaged from collapsing THPs in range, existing THP
> 	 * pages remain.
> 	 */

Okay :) I'll modify in the next-round. Thanks!

[...]

-- 
Sincerely,
Yeoreum Yun

