Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2A0C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843B46B0098; Mon,  3 Aug 2026 10:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BE46B0099; Mon,  3 Aug 2026 10:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732486B009B; Mon,  3 Aug 2026 10:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55D606B0098
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:59:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03FDC1C10FF
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:59:48 +0000 (UTC)
X-FDA: 85060267698.21.08E04A6
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1AF29140012
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:59:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=szNhVQx8;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785769187;
	b=WG0m2OMlC/dlmL4QwcE3zSUcAvFoP8Y5VrRue+OE16vWga8IEhoUsdiV9LkKvMzyrtnW5t
	SxFmjK4QYOBsdQGtZ9LfEceBi6IsNfAX8ihUgbdfaN8Qo/KE5EvDjVWPgB86070EwWR59N
	GMNtLbf+00zgGOPZ61BiR2kE97Z1588=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=szNhVQx8;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785769187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53dYbIroP5cNJFfZLCrtYqk/aTOAkqcu4BnJ3vI5eGA=;
	b=FGbdH8/oUa/TrUve47oxj8nqwfTKnQTlDgSA6VuIHg4JgZuN8uoqDUd30x/9aybqDNG/hM
	WhM6kh8fr9uCgAIxHAGgS1wMy/Ip1KQU6/om/JGcrA4MOC/NkXAs4HIXVVspRB/z0y306e
	vYr7cxJMzvO+UNcw10v8iG7LfZ1NNtY=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e5c9211d2so220001585a.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 07:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785769186; x=1786373986; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=53dYbIroP5cNJFfZLCrtYqk/aTOAkqcu4BnJ3vI5eGA=;
        b=szNhVQx8YK60+g9/nzfRQhhjVjtH42tpX/whKfg08XuEjPhQuWKuL5ZXfJ/OW+NenW
         vysDocj+COPGmz/s9lHE+eSWWacGggg3L+mK+oBHQ2+AZ9H2GKmHWN7FGn7bxjs/Nb9z
         UVm41+zUHSOkk7mV8x6HfX3ONVxSpXaWuc0TiqeMCP6HX4i9qKJeobre7w16HAwEB0AW
         owkgfsOyZXiYRzDUM96yFyP7TW2u4x1rqXuwn0z99KeayDcepZyUXGiXKoJS29iNLSLC
         CjMcg/KmGRgRoRVE7cKbp3LIw16a7p9gJyk2SKVTJjdnshSOg05t9xrr4d7E8Rk8h7bU
         TYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785769186; x=1786373986;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=53dYbIroP5cNJFfZLCrtYqk/aTOAkqcu4BnJ3vI5eGA=;
        b=h0/EmFtbIAOCEhf5ieyJWwTfpxJd67UH+4SfrSDqABPY4ZgPk3vgba9oOtCHPmWFDU
         b++LiGxwQBFrLSCmgjIMPmNiuisXj9t1Uq8BDI+mu6ycye7tE8vnngKdijYAL7PKxFjM
         Q+yjyQcK9bXss94XrJZ1baoalzkUXfzcYokNNhXaVIFRg+2XCjqZSU+o/K64nBszzPm+
         68kgn79aC3rBGC7T14HE3TYhOtK1QVdUDBH2UUfC3jx50Agg9VNFUBPEUqj7kHr//Bqa
         ysfPlDj4mqrjiPUASzvSULZTxcGAoqO9XPxKSP+70wArqvJJAwW7B6HCtBhHkUOvdHMO
         ThxQ==
X-Forwarded-Encrypted: i=1; AHgh+RqMpXQq5cdInocfI8qfy+cqirG3MgNYPNRav70oLx6OUenE6qIKKTXlppVUwOUtRokTO3YTW982Kg==@kvack.org
X-Gm-Message-State: AOJu0Yziyec1uQFtPR/2gklz4ruj02YQwqsEI1z2+BZt65IGeGUmIYFG
	zE/gMHCu4NfYyvhJyHnHyxWL2mhgHlmc/o77PWVNBVBGWv9YO0bXX6Ys5zsrJRj9IeM=
X-Gm-Gg: AR+sD12g9djSMx6s9P8zwM+CzNvucWoxc3hLMWcl+43G+8ZdgP/hdUuBKBT59HZh14a
	dhnxCYgAiY+LBl1tvEcHGkLGg3bKEPEKbbSidnHr6AkG7G3O3n4PGWAHJMn+Dn79vTeH1AxYwfr
	4dAp1hlqvP1l02Gr88l5Md9NMb8RDUBl+KRG0K6I5lfnBNBLdr8rkOBUxAydtLvzk1GnEHkA4rg
	YvHSiRflBBiFrhpzCD+azvIYn6UgjuPtyrjPwrJ//jAxYA2y5l/P9kfdXJ5H2Doyz58Zq+7yub5
	oSqtXamxOQFO4oI/CadEUQeb6RVojMW8S+cSw2teB8h5ptplRdpUMQyjCubJVdTdvDYrMrW8wAN
	+oIz5QS4Xy/i43bs/OnncXF/niABCi8MsytkVKK2bvvair+UyotZMQBYgmBkkx97iG0nwinmGfs
	a0pmxEOEGwJ0NkzjrFKe1uYqbi7t4tj6lS88+fPxSlVSv//BkvbM6s1GVQozgC3YMniYIfjePnz
	VJbNubADaGNM/m9nZEJdhxrZiGtaMMGW1kgVAWM/vWy
X-Received: by 2002:a05:620a:5be3:b0:932:df7e:b31d with SMTP id af79cd13be357-934a0784031mr1438847385a.12.1785769185244;
        Mon, 03 Aug 2026 07:59:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9349c1c1cdcsm685303285a.34.2026.08.03.07.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 07:59:44 -0700 (PDT)
Date: Mon, 3 Aug 2026 10:59:42 -0400
From: Gregory Price <gourry@gourry.net>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Byungchul Park <byungchul@sk.com>, 
	David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Matthew Brost <matthew.brost@intel.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, erdemaktas@google.com, fvdl@google.com, 
	jiaqiyan@google.com, jthoughton@google.com, mhocko@kernel.org, michael.roth@amd.com, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, seanjc@google.com, 
	shakeel.butt@linux.dev, shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 3/3] mm: hugetlb: Move mpol interpretation out of
 dequeue_hugetlb_folio_vma()
Message-ID: <anCsOd6cCRtxr3jI@gourry-fedora-PF4VCD3F>
References: <20260803-hugetlb-mpol-interpretation-v5-0-af2b7089f8a9@google.com>
 <20260803-hugetlb-mpol-interpretation-v5-3-af2b7089f8a9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803-hugetlb-mpol-interpretation-v5-3-af2b7089f8a9@google.com>
X-Stat-Signature: 1drn448q87i488qew7kyi491emd39b18
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1AF29140012
X-Rspam-User: 
X-HE-Tag: 1785769186-78146
X-HE-Meta: U2FsdGVkX19Pss90tUn+9vKZFwwdqxM9XNtmOy+zFCZ18yYhbP1hc2WMHjyyywbhYEecvyGVNXCO3riLPe8D8jq4mcrcrXt8BVLTC9SiNN5N5oiL8+BeRuJGYgSGlfGSi4thBTlovp+rfnFvA3Bdfz0/hG7j452Uz0LSDZ/PcQyL1FGVy10aVsCeuG35qTvPIJpMHZ1XSVcsCtCULftAJDCpSCZTtveo+W12maN7i3Sv1QIsV9Lc054xYTzzsUaKXJHDALjVO4q6vwaBPdstnStUe5rMeMhqH2Y2aFDBs0KDYPRDHQXg1hGOYPbnNw2G/s+Wl6W5AWhNzkIKvR8S/FO5wurZ1DG/G2PQuRiqU40yh2Ojfp5wQE8yLaXgsdEij/XZBaj3WeeKoi1ZJ6S3x/Adrzp2Y2ZW+/NPtSvA+NO34oCgeyWt0SMlx6ry1otuEEqfLUpz5PfU/LsZYOpgB55kHJK46RZD6J1dEPEy54WqQaaBJ44oko5/MAvJxM3JZJzqXYSnfukePJxAnveMpchZZyzW+a6QoPoIFb5oTlvmCpPR/WueNQAbr8nwpXZSzX04g9q+f5TTVePULvo3moHEVR0mT8eggOrb6kQFC7H4V35InAw0Wt8ZTVJ43RF0C3At9E1nzBOxY4PfbuxFdcQaeUFaISOBSMaHXN/Joa9CMcVwdOLAqK1BA2b5+FS9SK64X3oBX6/V1IEPjvoutgaM49mZbtY1Y9ZDNfMlE7sCVhv+4V1eGpUDn0waQU2vKW5ezfmgz2gPXl+4PoF3gSPg8gdzr31VpeMvueuvg8BijLmADbElXPnHrX7UHadWOGfeA5ZQ6zIFnZoZMb5R0Wsj1FigkEK0xybvGvq4jKFvOUjKEH+WLxUpAc5ucp4Nl2xGu1qGJkge71MjbWrou8uUa+RhQJstHeWEzxsINAn8Dw+TccWOkEfbXXBWQXvcPpSEj+mrJYxnu/dJR2J
 xxi9SMg5
 o4yJOccOURzJ6AvwCRnHfW9ntchu4enTwkWkA7780kEORE5uv2FnJVLWmknGYngJR+6SknWs7OutHGbmtIEmom35VLRLxOVCRChcWdi83mTHF0QEWa9SMkES4R2GiPxnz7lwt5/GyF3dnSm2MctQbMDrhQtjoCEw5DiQyrVFXJtat4qHlXdLGkYf8eA0ll9pITLx4gNmRvGGV7D7ZTyMFHwLK7HLIpcWdjD2pJFZ/lQcXTK56c+mAIPpznZee/oxScoEy7fNvMa7reWgfQRlHtipIfju9+bWrGJWAQK52GhbPN5ZG1ndtGXqaCw5DTNcgJFN5Hg3knwQx2+y0YByczHm0U+2PTPSHuGpc32buPTR36eqqrLfnqOSsPVvVnn805SGt11cKoR4sDqrjW9o78ROHn+0aYHUnJiXxDhfeFn7Tdcas5g0pMdoZdZ4xET0LfUJ40qsQNFqieDCYoxxbaejze2GpCYT5BF0Ly+tCWTV7QEeLV395dqRZHaQvQZkLbfaj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 06:38:00AM -0700, Ackerley Tng wrote:
... snip ...
> @@ -2925,35 +2935,23 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	 */
>  	folio = NULL;
>  	if (!gbl_chg || available_huge_pages(h))
> -		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
> +		folio = dequeue_hugetlb_folio(h, gfp, &mpoli);
>  
>  	if (!folio) {
> -		struct mempolicy_interpreted mpoli;
> -		struct mempolicy *mpol;
> -		nodemask_t *nodemask;
> -		int nid;
> -
>  		spin_unlock_irq(&hugetlb_lock);
> -		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
> -		mpoli = (struct mempolicy_interpreted){
> -			.nid = nid,
> -#ifdef CONFIG_NUMA
> -			.mode = mpol ? mpol->mode : MPOL_DEFAULT,
> -#else
> -			.mode = MPOL_DEFAULT,
> -#endif
> -			.nodemask = nodemask,
> -		};

Bah, mea culpa on prior comment, i did not notice this was a prexisting
patterns.  This is frustrating to say the least.

It does seem like there should be a better way to do this, but i think
we should be ok with this for now.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

