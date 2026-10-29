Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB10606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 12:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SFIIHyzx
Received: by kanga.kvack.org (Postfix)
	id AC27F6B00EF; Thu, 29 Oct 2026 08:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9AAB6B05B2; Thu, 29 Oct 2026 08:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B10F6B05B3; Thu, 29 Oct 2026 08:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD576B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:27:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09CC4C0354
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:27:33 +0000 (UTC)
X-FDA: 85375589586.10.2F09A5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0A9AF140003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:27:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SFIIHyzx;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793276851;
	b=2WKlhXaSBCJ5HjqG6T09XERwcAVGc42GuWHZnc7KZ1gbYMb9N4amW+ZahUfYmkIBopbu1P
	DpnlHBrSG66eGAih70NfvhWrMAdF+7r/61JMyWV29GkfJCabp3oADSqlERBTrBDWUwFRNv
	ttqeW2a+cVA+2njycbG92Mx4FkE7M8c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SFIIHyzx;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793276851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAi38oDFP76CAkZTKfTnMRaPWxkhX57roj58CzJcb5w=;
	b=1/D04nEieq7lW+VxeBb0k1174EA40DUcsQvQBGQ9GMpEpcS4pzJiVUHERmwQwn/zQS5JEx
	nOOr/vMhsn+aAXz3IHClq0EF4G21mw0YA3s04zqa8rMv9NpvjCF4pN/2tV3fjT6eCLj6Tt
	CotETblWfVwW3Jy/hFJ2H9+2sdeNs1M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AA764351C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823AA1F01829;
	Thu, 29 Oct 2026 12:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793276850;
	bh=nAi38oDFP76CAkZTKfTnMRaPWxkhX57roj58CzJcb5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SFIIHyzxcPwhs42rWmTPn4ykZNkWEkrCoddjCAjOFxs5zLHSidCZgvaP9L4ZngdpQ
	 GFu2Yd2ZZNq78VHkABoHyg2y7Mq5cQTqtPW1cD+1kubEQN5dHEP+RwWCUqe8Q9S7o3
	 sFNwaas2hXTCIzQ/3hmjVZGIK/Yh5P/veJ8q8nN3BcWoaveEu9D6M8qULInT3IE3p/
	 ZzMkdhx6AkLazxKGWBvNz1hWdAwHpspA69LZJeHIgTLWYUpBcxjEfLsPlh08/ic6mA
	 mDXMSZSmNwWtC2/ko+9JvPAhlA7yBfwpup2nXcHxxTN47KiBfcwTMIzpZEecSrcVfj
	 HUZWX5uXr50+w==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 13580198003A;
	Thu, 29 Oct 2026 08:27:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 29 Oct 2026 08:27:27 -0400
X-ME-Sender: <xms:rTvjarzwywjEjar7Mt_OyMWq6UW3-vjrV-PTwOnk-DHqc7KzFu_6Pg>
    <xme:rTvjajsv2wlC9eqWjv70wTcXnB743VNGDp9L2F6rQ04jOq6l1oe1uUoKqxAKvlbnb
    tCT4lZDnF-5dAX8TnsGCsutkPpXhc_aicyLdobpP4pJmEpm-2GproLI>
X-ME-Received: <xmr:rTvjaqxh5Kc1tu7o5vaw3wgfgB2JBtg5JTCiBU2E1bDWEMdzraQhf9JQgak>
X-ME-Proxy-Cause: dmFkZTE5B5/2wy/nW1OFB+CZ7Y+pP/zumq35zbaEYOek3IM3be5kjPml9FiEI9wEM1jNQn
    66RdhojvUW55Dx2BnSMHL3H4cTTa2ZgY3CMeKe9qVIUt96GpJ5DS39An2tyb5y1ezFCMWO
    C3cIeaP2mUrQT+dMOwdjAJqmarhyTJNtcAWXTZ8q1eZIzwkbX3axu2Dpi3dr+0vbzTJ4KN
    M9mNGSlVSWIpojb7gtvoOfwvQT/ZVd+omkWUadmGcD349l0GKA3Z8DA+TkTZ8FEuV7xbCO
    pCC7eJ5pF3UCYpWwrgGCFRh+RcwnRaLmeeWGla4wJozIhGeDLgbdlz5SBorQQr24uYSDa+
    B9Tm1/m/AT54fyJzVbw193d0xYAPrAsxjWVOuSnXmpvuwcChvrWFcWnIwqPzkyN5DkyWjv
    4ICYY9JeLOAM98WEMUESsP/OmGilWUW1bILaBYrFN3oBw7J/yopenCGgQLt+dlMK2AFU/E
    eVbamYEgO1eW62+yllod0lsPs1rKiLcqAZWaaflztHmzgT2TH1Kv5ogg7UCf722w4s2bzS
    ViAzt1ykhJivLBChtRX47gCkNjaJfEPR6phq2/k0gEI/tUv7k44L6gVKHoGEYYlrsD1eEQ
    +LCk3lIy1eaYj+nleQIYd+vUmdhJDLkLLgSPeoK+u09Rc9NGUPtiJzsfsENg
X-ME-Proxy: <xmx:rTvjajd1xvSaopur4XQIHDw42kxaMUcEZlm7-uOZGDSAle0uXEqMnw>
    <xmx:rTvjag3LOj5FGpB0XKfhVBrffrTwd_fVfU6T8njGy2xnGvdKe08gIQ>
    <xmx:rTvjasspO909yfCDAsKVYm9rvbGu0aBSJQUUjVsfD0Ub88u_TrWcYQ>
    <xmx:rTvjas8So1Fg21YsmrhpvnR9l2CfUsleJmX2kPUnNv5C-wZ2Df3XnA>
    <xmx:rTvjagSjOuRSqet80xz00EZT4UMabbgR1eKzwCGUonWupFdLj3QV6gPA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 08:27:24 -0400 (EDT)
Date: Thu, 29 Oct 2026 12:27:23 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/cma: accept memory of CMA areas reserved with
 memblock_reserve()
Message-ID: <auM6lKGAeUI26jCj@thinkstation>
References: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
X-Stat-Signature: rbamjfpkof359dtcq1dzzmsg534yhkmx
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0A9AF140003
X-Rspam-User: 
X-HE-Tag: 1793276850-848134
X-HE-Meta: U2FsdGVkX1/94zbOKcdb+ReoRn90rWve9gJobzS8gqhocrT581ZcfR458uJxrysy2uuTNADn64B65HTcc2AEEDhTn1wZWb6XZvokA8kTXKljvE8s5q+pG+lRayDsJ1UXelqm0uNE2nXf09qvUtl1dlLbHCjKmkRt96zKtrW9kPb2IdLNRjWYq2KdtauD2kFdlqn4+NerIUY95srYAkaD753nWrzuQuTRfDj5l0Vut/35inMlit3ZrOaHGbeLoKKiCu9z3Nc4Q7DpxUisvlGw7foTBiiemRd8hglxweJNo1N5BAORcrTyxjdSXviMH+IZu+XJDPrIk5C7TohCQR3eXSNY24tPfakSAvrBZWUGD0bbm63OFqMhTf7TWr2izMVzWy7FKaewyzEpVbhyqXCRAGt0aDvyuvo5+4ZzY6oJiovRi5VDAtfZYi5AApejcBF5Od5lMEcub5RsYpNQJlkph7S3cKz/QHak0Elspl3MPVcA5yuZFbt50InJM66Hxyfa6Moht71evVipjDsX1gMLVKkaKgJUtGt6DHAYOY7SFKAQacZN8sXPbAnEyjqHbxqBjuQtaHVLQRwUPMN+UDU0I5zwVhnh5ZGCvEH6AqzVs7Vxv/jL8NJn5EK6Vqta5/TSsq6MA79etumFI3Wt2ozdPwK1sknYOIDYrsuQwpZXf4NeEhRLhiF11gzrEzZSBKowEk4URWusYXY8r5OyL1bTHCxlF+Swu6mfP7UcE5stkRVovxpejUv+4fgO78BlhttHYzC+XUXZ8CHEnIqbjfgOZtgq3SLpr/5qm0OWlSfkBOUbgW3GBHayOkeKREKx2m7TgWUQC1IAZF4sRZ1dUbRRKHtgEwa80OvHemzH0OfPVaniBvURNdWHejvcIJAvFO8OC67uQwRNoIxhJUIRTHqsv0E1JAkQSrF2hwEwfO9303v8KDnnID3J5RQLZH7EiEVjbJKTKuxTui51YwtJ0dx
 FinSU8uJ
 2B2xbs84X1i3rJ7217Gy4JSkNO+AjXwMPxj+/lx+5v2sKaL30Q0/6Ce6fDgq8Imue57P1eT68mVb4H5AIEYroGSEWbZg/Nv5UPSMbXKY4U5eOgNoNGlzL4ELsPa2tC1A16z4HaKHEd2zxaXq/05BulLySY89cHttxVBs339eL3Q3/hDpRaia6gTmvmUVJClTLqisHsSXO+EWM263+sGYKZ0Dav7UtNhID2q7T+isNUi0Mo/f8oabKlDHUKq3GthXUQmmdD+qSt2eV6GUwcGvmZYFp8nTyoNrBq4g3E3tbQNknDE5uIdp3n5fl5fC89CHMiLDoqUOUs+JLD7IA8xoqxMEwB29TRV/0j8SHtUE98RhDfalPe5NlTVh9LkineZ+Vt2nPyadyrLJbA200G1UcPCh/W1IZ+9GsOQbE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 12:18:36PM +0200, Mike Rapoport (Microsoft) wrote:
> Pages of allocated CMA areas are released to the buddy allocator with
> __free_pages(), which does not check for unaccepted memory.
> 
> This usually works because memblock accepts the memory it allocates.
> 
> However, multi-range CMA areas, used by hugetlb_cma, and fixed CMA areas
> requested with cma=<size>@<base> are reserved with memblock_reserve() and
> their memory is never accepted.

It feels like memblock_reserve() abuse, no?

crashkernel=size@base already uses memblock_phys_alloc_range() for this.
Should the fixed and multi-range CMA paths go through the allocation API
as well.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

