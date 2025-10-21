Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098D2CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1568E000F; Tue, 21 Oct 2025 12:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491358E0002; Tue, 21 Oct 2025 12:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380578E000F; Tue, 21 Oct 2025 12:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 264A28E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:03:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E79551A062D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:03:44 +0000 (UTC)
X-FDA: 84022591968.04.B9DDD91
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id D113F40012
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:03:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LHGRfNLr;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761062622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKnbdWGyzTwBQCjdg/pEGTdIkZhea5mKIOTouuBLY+Q=;
	b=xBF5pXvPzf2isF9aG6Ww+Jfwf5wKYE+ZHhJtvhB2ZoTCzoFymh+V9ktYfZDY2pT982eCx7
	Z/DW++9GCnHRhrjl9Bb/qoNRGmfbZ4Z9+zeCsAlymLq+3gG0ELyfZ/Jom2G6agThNzFHSs
	srujODmsPSmczI4baUtwUEt+S9QJ0BA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LHGRfNLr;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761062623; a=rsa-sha256;
	cv=none;
	b=t5cNiT5zC9dphCetJw+tH99sjSoyE00zEIEg1xTe3Px644nXBuCXpkvTbFNUQV5TcHfzlR
	MHqd2tQ3CDuNlGpG4RBgAfznYKN57lF5D/LK2L09hZ1Mqk1EH9315kkl2Fn4ExH6pwqR5l
	pwnG0vHl0nmGLtKUilThL2UocrLMv9w=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-78ed682e9d3so78135976d6.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761062622; x=1761667422; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rKnbdWGyzTwBQCjdg/pEGTdIkZhea5mKIOTouuBLY+Q=;
        b=LHGRfNLrb6guEDlubMtA1E8lfYoOpw5mI+394d9RERbODMAynZ0uVUz2qLicd3AsWE
         jGGxEcpEVRXLinEaAFI3gkhI7EYp2yurURJfLzYCxTKe6wOsr07rNkfj2ntDCmo11ftM
         FyTKnoYUs/+QpiMHWpIkF0HX8Ow8FUtYpSszACzZcEvtH4S1pmCMsTouTaZnzBwjKmJc
         VSD8JgVUkW87VUGl1JcuvCUMDiL8t/cMTsZACAQUQyGNzqfkGUOcBbsofBGNfP1X/rgM
         ratwB1TDJqbDi3Zgr61jWzNQ7BEEYd8My8a8YDO8tA/KmEbUgRp24KsnNxBbeyyTtLvU
         eFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761062622; x=1761667422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKnbdWGyzTwBQCjdg/pEGTdIkZhea5mKIOTouuBLY+Q=;
        b=BozfUAa1bI/GKwXR0q5tAiJ6hMsRriucbzTrpKKZd1c1DehX7m4oRfI5jD3jNQrUav
         8kT+haTrje7mjBwNxiXM+FBVNFKq+dlfpg7i+cTDP+JghZIWo4ZdLmCLR4LMdivtkWzw
         LKZ6rSUTmlsbUF5701T6Rg2GY8rjnSU/7dlUN+AbPnXVrYp+hCXpq7eGagsp0IobUFPY
         vS2bx+3RI4MkHEcTr3XpC7omWSoctjhhrWsVLWhK1Yo0sL8+Zag7GWCeDGXxwB+9pWMt
         Y005602ztEzUeMFJ2j71vfa4yjI3hwnOVxktxybcd68j9oFVdRUDhecCQl6WvJ4zZlcD
         ZS+w==
X-Forwarded-Encrypted: i=1; AJvYcCXze1qoonjX7FOXa5wGgEnOTME+wIah5cmEscPEIjMlkpw2HhVlhr4NkPogaxV+8YXCI4nxvk9WFg==@kvack.org
X-Gm-Message-State: AOJu0Yx/WZ6Q3K86TotxC3Ob/eV93Or8GeXzHPybnPH0Fg0TLLz/V3SX
	xXM6oG83bzXjfUV/ynSXcc8C5ETaZ+cIjzJmn3/qh2rTov/Ej0Ew41yU7XqKzuAe9Fc=
X-Gm-Gg: ASbGncvZPh7DDd7MMJ3V9hdnQWnobovU8//O6sOYPDtcmBnL9OXgxfRv8wqBTXgDD+y
	xD/cgiUTC5Heg1PsHWDex8icNdBTxl6eb4xIoiogo4gsQYZdi6XCOBJcY3Xlox5C2VYkfz+/G5L
	oM0zuP9I7dv23mN8hbqzfPkwQ4vsZMMr1p9xQm3XNANOVBe7lGUbyqEzAMZOEdKmHRSJ8tngMOV
	hHjf3hgchh3qbqvRsBIa+d1LCgTRZmF2rzxDzxVcg+CJU492NWF+0gGA5v+wcfsi02pLVFPzBJ/
	9xGD5rXoy3wiwKiRQD0gFWPUQE5GLADPBD/cFx/PPHsdvOw0iiKqhc91Zgsm66UinQo8IdY843q
	JPOASCpEqD5LkHTwz0DyE9pXGSjrmIy7CQ7lnu1V1Y4zSDxOSfTF4aLVzGiY2on+37clhTElblw
	CqYuqe9dbJennSoyfUmlvGjxFL9yTkQJmo6Bdx5aUQhIJd3mW+zbHQV6FiGsZYzbWob3+xkA==
X-Google-Smtp-Source: AGHT+IGgeylxOlDNs0Nyv0EXfOepOKkvbjU8Nk3X+ci7ChYcRQpmyM7uU0DKfyt/R0deuXN0pKprPQ==
X-Received: by 2002:a05:6214:19cc:b0:87c:2967:fd52 with SMTP id 6a1803df08f44-87c296800c8mr190050176d6.17.1761062621646;
        Tue, 21 Oct 2025 09:03:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d890ffsm71384816d6.54.2025.10.21.09.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 09:03:41 -0700 (PDT)
Date: Tue, 21 Oct 2025 12:03:39 -0400
From: Gregory Price <gourry@gourry.net>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aPeu29qbxdn7dmjD@gourry-fedora-PF4VCD3F>
References: <20251020210816.1089910-1-gourry@gourry.net>
 <20251021012533.56rdl6v76plkw4nl@master>
 <E787AD03-DC67-4B5C-8BF6-C79F3C583D00@nvidia.com>
 <20251021091443.5ggfmvl5jwyknjnv@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021091443.5ggfmvl5jwyknjnv@master>
X-Stat-Signature: 1ukmohjs7ek4dmy516yfcjnsh6843yho
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D113F40012
X-HE-Tag: 1761062622-287579
X-HE-Meta: U2FsdGVkX18RamOmXh5mi8QB06a4mJ/rrMrR//rgGazST2WkAAmyl6mhXKro9zOKkgYIO0d01kH9ZLcmonRKiZttxSUJz/fjW+ogi+HYUawP7FFTe5WvakcMbnQNJvqj1gD8quDBeYmFigy5xNIIqpEkNpHRvlogRCw7Rj9Fmv1Y4o+9mJAzGGTH2s3H5uNUr9kvKITiQ72bMRIM2Mx9L8xsrfd48LWkQRM4f2K93v9anLn2kO8TqqrPdqGGrCL11+fE8sYgfBN04sRL4uiGkqff5AQT9F8RudJHvM/+u/oEUglaWbrZF4+//yGqJyrfa43NiE+FQyKLvnL1MRMS93ZGVGGqqNEilFqz9dP16KupD89xnuKTpDCHakoa7kMSllBfsDSO9HGWx2NoHAd/Tg25zCzXnqBqIPjRIiZzhFdXXnkTKmNkEMWO424GnpQYDSfvVEhVIYmy2n3uJXblRCU+gITvT+0h1vSK6kbVi3264qf/MhfZpuf5K0fuqZ+WkofhP4+f4lYfi+6lbomU1fVRtk5zoi3/Ren6OKk/c08VD1xBuI/WnR1lky/I6RpziEU0xDYFRGIF9BkLvsvR2I7Zc0yLXX7GQynGBcReDB5SggAzRrPYOZbe4/BTaRA140d4ftUb/ixUd41eIsLK8JOnurxJIMUksqNoTeEYqRw/SJFWQwSR9joe92FvK6vUe+dxu8xw5sUOVK4bQFgeQdzKKlpTbTaEB/zTAXrrjshcObkBlMhg2NvpY3ZBEKhD3if6HW8bfU/jfjwwSzLcFLlC6qXlfvvviq+XSdMR9iw6ZulSCdhkCHQpJjcSLF0U6tjKCg1bVf51beX/NNEuSRe7FwVKCol8SQLeVhk2MtEX6qx5Z6O2Ot+7ypluWKM4NEf9nQsMJN5/6M7IHatVk05DRb2Qj8Mlul6pUSwxaclMITpHN9y0UPXLMptxB2g+ReBZXPQim3YAqCagQOz
 krQc4H0W
 yaglizo5vkpYknTMCGWHjHQHgfkKGJDjVxvkjygHBD5RmaGy/GlezLJOQdNOcbXbz3TrH1nYH4Ax2xeoPsTzPqtbn3/cwdjYpEWd1WK9KSCgl4a7pLiPOaZKKQroze44cz8gg/StzxRwRfSR4FpzG3n62Rx06s1u8BdG/E93YCUdIs2hCvx/gDvggGgBhkKhQoKHERSdp5xirmh3pGeSewihze6eiiW47+/dcl14zP/IpinnX/eehFCPXLC29BL8WKvR52cwAq+zVX97mrpFkzhTVsx/RojSbmHCi9apKdpst2AXKjY2NcIaASUPI5qL6S2GD3vxH3ipe0us7D7lJKM/Qg7jpthtzAQnIriXznO4f/xaS4OfRxqyruGfv8zk3tT/JVLH+/IfsZv5zaAixFTROpJpi9GBGZGxqxVJbY70yjem71pWoLbQ1pNUz7ZNv2H+E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:14:43AM +0000, Wei Yang wrote:
> 
> The above code is expanded to:
> 
>   page = _compound_head(page);
>   order = compound_order(page);
>       folio = page;
>       test_bit(PG_head, &folio->flags.f);
>       return folio_large_order(folio);
> 
> If we use
> 
>   order = folio_order(page_folio(page))
> 
> It is expanded to:
> 
>   folio = _compound_head(page);
>   folio_test_large(folio)
>       folio_test_head(folio)
>           test_bit(PG_head, &folio->flags.f)
>   return folio_large_order(folio);
> 
> These two seems expanded to the same code.
> 

folio_test_large drops into const_folio_flags which does
a VM_BUG_ON_PGFLAGS, so not the same logic here.

> Maybe we can use folio_order() here?
> 

