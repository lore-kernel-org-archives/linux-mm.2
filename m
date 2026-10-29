Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7EB606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 12:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IVEKkSl3
Received: by kanga.kvack.org (Postfix)
	id ADA186B00EF; Thu, 29 Oct 2026 08:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B646B05B1; Thu, 29 Oct 2026 08:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A11C6B05B2; Thu, 29 Oct 2026 08:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7946B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:40:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 052591C3A71
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:40:31 +0000 (UTC)
X-FDA: 85375622304.10.AC3C6C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E93480008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:40:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IVEKkSl3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793277630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t67BBHCIL7EUtyLOu8dUfk5JQITxnHbOVp7o6sR49Lo=;
	b=mzRBlKDjVu1EAiN31UoxJj0TEuKejD/b7agps/sxLRLiBPQ8hWqyQybTHeJYFUx50ir7T1
	7P5Tw5TiUEG9gr117fPM/JFSng1odehAQQxnjDB+xPa3qlNUPskdCRX0R5z4pNPbDI1Ype
	DXGUiRn4l1w9goVBfmsBD7lP/VgvY2c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IVEKkSl3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793277630;
	b=FHn75UVUxyWux9ABVnbprqY6SmeGPrucPWC/7LceCBY0Dn/Co9nyVgyYMQWv2lD7uc87X2
	gV1S5CSYKFm0O7/BpAHZe80RHNJdEf3BjadP6O8M9RH7Rwp5pvzR4nkYLGiH2A1UYl6kEp
	3XdTmiukBQobZ6w4DUqPZxZD3770aiM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60E7340489;
	Thu, 29 Oct 2026 12:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855EF1F01825;
	Thu, 29 Oct 2026 12:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793277629;
	bh=t67BBHCIL7EUtyLOu8dUfk5JQITxnHbOVp7o6sR49Lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IVEKkSl3j5tFHHYE1LKR+DuBf1Oxx/j+z6NfrUWDYJAL0JfElidf9BkjOJyB6mVPo
	 pFhk1a/YMfxEAg6KV3sj3kKPJKcM9uSy/gdruoltaTJbYwYE5C8pi4E1oTn3NkWrLQ
	 Fqb1maQM2o8bsLge4vXKBwXTQk7DPPku3VcnYBJ1jR+JB39ACIEnOVnHoHdFeVnPrl
	 5p8TcKiBosyi5szeSBGV9s9LbAz6v2dmpQmXw2ibwd3mIjzqWKc3GK8SCgSUTV62TU
	 MdRPXoFeUsvqXnzMziwFlDTeRylZ8401H10h1d2H9VU8iISb/QDDsUzxHR4/9Jldiz
	 cM1hbX3q9rzFQ==
Date: Thu, 29 Oct 2026 14:40:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/cma: accept memory of CMA areas reserved with
 memblock_reserve()
Message-ID: <auM-tYrdV4TJgJ6K@kernel.org>
References: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
 <auM6lKGAeUI26jCj@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auM6lKGAeUI26jCj@thinkstation>
X-Rspamd-Queue-Id: 5E93480008
X-Stat-Signature: pz4dyg8o6zczpocwfjys7tm13rjokhq3
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793277630-656015
X-HE-Meta: U2FsdGVkX1823389Nkfhh+kSPzdT6DLJXDCM0dtVd8HFxUPy0KaC2TPl/Kob1txxRQF0L4kIaZCU1sswD9q2DHWySxojPQQnWMRfJXEI+Viyc28QX4Q8FqucDIOWZIkxRFaYliNaFnjs2gAHZt0FOE7Bz4AFKYk4nShpYSHSoQE97VdFNCdFxGkFjqKaR6Mg1uzg15hRhXSre1zOZJyqtR9zl6MqYhNKTAzx+aPyldELhhq77yPV1/ldMaLcLT+/KR9yYf6zTzGG32q4jNQ5v9UPtqTc6DyXVxqmR2reNLtBehE7XfFRceynH9/Y+7fwZunDxMOXiAG+iAzkv3vSnCH3sGEVEY783z121aG6bk0NH/Wzs0UXFtuF2y8KxQ/Xal4xR6I21jTo2jVgN3KcD2Xi1Ie1ijLMLfyuBcflsvuiS+nXKZoFh7LCRwE3wZ/PaK8mxbxDfgIpKbS6fTD2D4iXDh+L3Sz0XqMU8TdT+W9qfNOaO+3SZMzMkedsGzMpzCfvJbBvz7XIaMN1ziyh58PYCh+9BDVP7sB8OFcVPFMCKznxEQZ3dAhqAqRxNdxlgmH0plUELXWMTamb6pSReyy/OGOX7K+GIS+bKTMP0j/nBol187MH+sFm13qPO0uwl5w/Ah1Iokmods8PqGjPVy9rJbauIue9GyeT+9/yLkwqkr7WBGK6z2HLtjZ87BaKgFZk+P537n5IJYOsZmISaSHsbCxb78LL6eqjs9uuY5xVhH63XEzsWQgJr+k66eu8wtcKbQl443ZCV0IvLr3Nu/RApiSTmhjTc0DosytpAPgijxZljNdMRPOcsfCbAIJVEUPm43yKnIYV/rQeexT7IiMa4FD8IZJ3nbBzEUssYz7tSUYFi5OBSjqOLuHhRxA0/B/vivihMsnGZBNoJGlwS8YYjgclmIVE+/GeqfJ329+66+xKpbSRI/UOUc6Foqdt/QlYDVpKotV9sf+RY/s
 hBoqcBZG
 hFCHo1m/HrxkMFYE3jHSHZwAxX/Gs6UoFxytfre+XG3GvC6UcC1sb5Mqj6SUU2lQdCE1ifHRfnYHJpRjQPi5fl7RwJ7n84VfrZo0CAUJ/3ZL3VZO2V/VAFqThjfkCkclHxRgMJ/9AJn0IAeDFn9YlhQGRl6nkjXyAVUGt8CH2PGYDnTU7WS76QWURBdmJtK7W9e8avxVMajqoK3KM5zKNmZ8TcH/slY/6OEpcID0Xx2jhyR5YRpl+BlrnI5KVxHLHM1d7glrrWgDM6O6cR6NWGKm8zNLmL4g+txGopyTbPErHfpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 12:27:23PM +0000, Kiryl Shutsemau wrote:
> On Thu, Oct 29, 2026 at 12:18:36PM +0200, Mike Rapoport (Microsoft) wrote:
> > Pages of allocated CMA areas are released to the buddy allocator with
> > __free_pages(), which does not check for unaccepted memory.
> > 
> > This usually works because memblock accepts the memory it allocates.
> > 
> > However, multi-range CMA areas, used by hugetlb_cma, and fixed CMA areas
> > requested with cma=<size>@<base> are reserved with memblock_reserve() and
> > their memory is never accepted.
> 
> It feels like memblock_reserve() abuse, no?
> 
> crashkernel=size@base already uses memblock_phys_alloc_range() for this.
> Should the fixed and multi-range CMA paths go through the allocation API
> as well.

Fixed path already has the range, why would it use allocation APIs?

The multi-range could, but it will be several times slower and I believe
the intention was to avoid allocation APIs exactly because of that.

> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

-- 
Sincerely yours,
Mike.

