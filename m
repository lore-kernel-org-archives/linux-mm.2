Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B12606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 14:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HrlvpdUM
Received: by kanga.kvack.org (Postfix)
	id 3E2A96B0649; Thu, 19 Nov 2026 09:25:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392546B066C; Thu, 19 Nov 2026 09:25:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281766B0676; Thu, 19 Nov 2026 09:25:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 033366B0649
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:25:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 804D780B09
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:25:23 +0000 (UTC)
X-FDA: 85452091326.29.D1BE010
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6C5DAC0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:25:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HrlvpdUM;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795098321;
	b=n9gzt5MtjtAPyP1MClr/+szz2smLePnzBudmHWBMGfFHS7W/Kqgg6gbpbNbLrYyxdBHRzN
	kBIDBmvelm2Ij6GMSY4bGZHNHzb7tnKFBridIIb/SkfS+SJtRBFICSTnrvaR5LclbTTVFm
	LXuDQJoT3fP2sGmyey/b5Sth0ljib3E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795098321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLynK9rI6KVHHV5vynGMOLFNSB/FofZaEE0s+Moc/io=;
	b=fi0GHtgaIYQoyAAY4tGxOb4wRIccf9LkeWukNkf/jmg3Xr4CggMyr3PO/YIDAtxmLQGZjn
	ps8uCK5HIBlwjD6CAdD+eZe3X3iDGuzXjKR3lFuAnwts/eBiC2AYSQq/nxOSKzodzJGO+Y
	VVzH5LV8PLEG0zVJPvMdu0NhsHn+2NE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HrlvpdUM;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A384042B23;
	Thu, 19 Nov 2026 14:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AE31F000C7;
	Thu, 19 Nov 2026 14:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795098320;
	bh=cLynK9rI6KVHHV5vynGMOLFNSB/FofZaEE0s+Moc/io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HrlvpdUMM0wY4P8JL2VBBf3CHz9vmYcbmGvBHVw54eITWpMeuYb8SEBJij+Nuo0f2
	 4czLktuNCJOSuvppzIA/sIYvJM8kCZ4zulns3Qum5q4m+f2E85xrmhilPH6VAO7jQS
	 MHpWm3fFGD7m4FQIEolOd69Lpwr6YFgjUov7cBpsNqpU0+klUEdazuMu9YF6OJLkIB
	 vvIVaDMz5Zy2WWWKXGlmAUlBxs8wnfVtL31fxPDwEl+VGfkUQc91qDLGS8omuUiOMf
	 zwAyUCWTc658B9EUg09WSy38j5PSdUfpPvYAxK77lZ0ki6wnYFrDuEwaDb+zkmc7hY
	 Tl6Ho8JEoNOAQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 1D32B198003A;
	Thu, 19 Nov 2026 09:25:13 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 19 Nov 2026 09:25:17 -0500
X-ME-Sender: <xms:yAb_ajYwa0xGmjjyiPwmlNXbfb6SCtKLEb-oiecfFag32tPac4cABA>
    <xme:yAb_ag0cLW9DbNh-N-f-DLBd08eVUHCSXj7Vbvfz5GAkUBEq4srWndqBl8WC3V7MG
    LyTucEVB2IHHZJgeX-aoZG55sg089zLao6hyxPzAw-7lIdcqGvwY8I0>
X-ME-Received: <xmr:yAb_atEm0f78LD64EwOqi6_WMpQ9JC-RMsM3szUyFuYE6PsdZ8N-brSUPxg>
X-ME-Proxy-Cause: dmFkZTEyNuBZcyS6whiZmxC1lPTPh98c0PDODIZIONg4xEZnvcdNcvLLf0dpDMgukyinEM
    s374CaO9qOQkbKT5ul4KybIbKSCs4mSlOU2vpAuqjlJBQqRr5msdLH18Cvdak2ci5SUpEM
    ojUwjagj/QtGma40bPhTC8X+i0VdnV2PGzd4p9seDzIRTajT7DvS1CV24k3z8W/9jXsf8b
    9ocM6fiphebBwyYCSQ+tdPFlsVkRvGUdu6NL8Vdm7bf4hRLKDvILvELQxCrbr4l2kLv5Yu
    MmQOPtr+/zORv/Wt1Z8vw1a+trobbn2CnVOsOWZc38cVITj2uZDA79nLjieJ1jy8HTqYZm
    iRB52e+MxokyasTTed6RpxBUR8HxCpXw5hwVJoGsIY7tgX1LRnXmQb3W9tupmY/oUrOS75
    1IzXG6PGE1nGzZ8r9xCNLd/myv1AvBjfqoWguiyAQzwky9Bgakg0En3QDuhPkcLCjBuTFk
    AMygcvDTL2p/pD1ZB0YVG99xIZPJVvs4yCZRJiHUOpGbyIEcK7oqbjzeqJX3ACWvrilpvw
    cmJ18yCygTmR8Au9BiEruO5qZHGGbPyh+yvmyaNESX0cDmXoeE5DMZCB2VhNvsBQS9aOZ2
    iDExYGMi/xXicMSC37rfNA/pIM4xIYwCPJ5w4/Q76cdg3cFrbgg4PD0nYXCA
X-ME-Proxy: <xmx:yAb_atMB1CACTuD4wZI6yL3uPxsszht7Fysx6ApWKlr_flkZs1FpTg>
    <xmx:yAb_aiB1UD5eVFRTOEYV-ml2SpEf2HrFAyQyZwMnpK7ExEa6cWkomA>
    <xmx:yAb_asxTnlX8gppwV5xutOLak29N1oZCEGV-DQGQOGP4Ic8PU3zVhw>
    <xmx:yAb_aueo8VXHYGqGILL2A2II1O4BgK_eRPfMsibsWq9ZLNbM-hgG4g>
    <xmx:yAb_akpZBu_B3tRIscAQuqOOnAtl9C25ApLOLoLngvvtG1X3gA8ASRVq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 09:25:11 -0500 (EST)
Date: Thu, 19 Nov 2026 14:25:10 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/3] mm: page_alloc: make the high-order watermark
 check honour ALLOC_NOFRAGMENT
Message-ID: <av8GvDahjRIKXUIa@shutemov.name>
References: <20261116125103.2894162-1-kas@kernel.org>
 <20261116125103.2894162-3-kas@kernel.org>
 <sashiko-outbox-218808@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-218808@kernel.org>
X-Stat-Signature: tmh1ui3tdsgt7rhcichgoen6ie7cwu65
X-Rspamd-Queue-Id: 6C5DAC0003
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795098321-254574
X-HE-Meta: U2FsdGVkX18daSavpLPA5TJIxOXza8jzov7ZwrhkNuR7tp3BX4ycYii5BqLKq/ESNVFuhJpJsvh5dRhH6fMKitXdRJO74jp4hsEcHbxr6Wo8uhYGBE70scL3ehX8Q/Cx1rcSXc7ulu/UxAMpJgUve0Y72tE/STeGdkvw80AHYSSkh3aTwDYqTaSl7ChJ5VkXlb2TSylOGosma/wr3YD8V3rQq54rRTeOhnHocB2vEGdxFgTrGcLr7gCgnmli6UkqFmQY7Qx5YnKuk8dhU3bXcjZhd2U8OTlCB//kTyKD0wDz92gG3FgEjc/kLn6wHxLVwTxKmxGC9R9Ko5a4xLbl+QJXTwXOySksQza3jRY+0hfS9/nnpJFWs+9bw0/sbIHzsmC9Y/Mey+mbPzvo7J+i6Fvjlz24fnX8c9HV4CpySjf15xfXl+h8TX7uxaRKT4fd3gvtxJDC0gu4w4K/ZXTrDika2H6D9dma7g3mn8S0HKVcfn1HfPWLw7qa+pRC1tZQj0VPHRd3YSmhBpEbpxZVmS95l8AeVtSEWhztUSmNtJEMo7mPim1qdFXlBMm5KDTAIj3it7UMzqMPrm7ijtWZ9Sdek7YvuLLr+vFALRU6SEySgA0qP9cYQWWOfWZSl/kBrV4NT2PKQqOHBfzMIFr1CXTyINOmyq2BJf3cpS7ABjebfIiqDVcE66CwlJpHszt6Ql5ChQEcduJZO1R8KNjePYvZQ0+23eS8Rtd4UZwyNOaatUYQ+aXT+nJ+NOmzarGjcT6e5gfNvtS9ArwsMOqjF0u6dG3jVkL1j4fj++GSFG5KsxcmUbAOz5gKofSbgOZjK8OqM7/dVqhT/ECDPo+mEqgElGGVHX++VhNmBgsDTIHaM6IF25Hfa8YMMtPXVubJ6O3AOfdmZb5fFroNAwBg5XYgPIrOsTDW4DILRrn5uYb9U5QURubAj5y2dgDDFROnf/QRHlW3M9J3XXH7qOm
 XSaLiNVr
 xltGAipg1kJ8y+MiNXQ6xW5gwj15HQANTWd8V91VfqjlLsOtJbS/9Y+uCKHrR865FFj+7Mg29oPz55/OpkzAxhFEJiSl8WmA3YyOq45CLdleT+FNMXPoepjSUCQNhKSl323jgIJUihliB7PCxDyQ6ZbBmAL4IUxEZYyK4vnFwushDWDWEpf6HeULyo61eXZ/xFpCoijFFiOkYdDz/nolB4IuISC9pwJFXRufDUIJUF99EZb4XDxmcAImTDfeNfM7JUXXeqjdmHgoDpNazkj8sB88jqYOR+v+ki39fRBxbCj60LIunvC3sEFZcxUJQrINO34RihlXIcpeHfAA04ExsdJ8nhajpA2ZnwTSx6hBLmB+gFFgbgVYJ3/ARAGKZXTvd5wcTek6o7w52ZdEKBFftI56jbVaT+VgaVSzQKUAVSlPp2C4RoZNC0O98ltAnQ/EblgrRM6IhSf6ykzq+1BRMRmPm/BXkcaAyuBcaz3I4oAylsWhp6fAqWQ0rj7DQw6FxbcGhfyPM39bKpLMC3MpjGCx5Nfyx9uZnel6eYF42ifH/YQMr3d3BmtMPAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 12:51:34PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm: page_alloc: should_reclaim_retry() counts unusable
>   migratetype pages

Not a regression. should_reclaim_retry() never filtered by migratetype.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

