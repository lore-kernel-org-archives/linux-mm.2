Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411DD606A336
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 14:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BFrwIpRG
Received: by kanga.kvack.org (Postfix)
	id 64C856B05D3; Thu, 19 Nov 2026 09:02:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6E06B0636; Thu, 19 Nov 2026 09:02:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F186B0638; Thu, 19 Nov 2026 09:02:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5656B05D3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:02:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 992A9C0ACA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:02:56 +0000 (UTC)
X-FDA: 85452034752.29.AEF604A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8111340017
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:02:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BFrwIpRG;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795096974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/AGc49co9IRdKpA2VFSfedJ8sUlancWLOq8E/XkKss=;
	b=8oosXWxIcAdhkFWoPZZ/S9gnqTdhdkYFG2zh3pbtjCPQnEjKQ+OnRUt3yfY47Z2ZWDW8/D
	JRcgF8vnPN1ZrsVsuA0czJqvolyvDacOX0Ib161gaE9I9ZQzhHcP0XnL3N9gdY5deUfYe4
	gA8oIcBHhjpjFI4Sqh/j2huu4j/evGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795096974;
	b=d1xmZRyzBE5ujDof99dJl5plUdijGRpnFz0qV7HLxQaA4ro+oySZi115NnU5FHj4XlzNmp
	u4Chq+DXatmkSRfSlCi6xUMtYe1K2OtU3dWbWj9tgHjm4ZO2RKh7zjdGcpfYlB5vjqbpPy
	tFLOgPByhNEI4Ihse1l/TOg68pnEwDA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BFrwIpRG;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0845862397;
	Thu, 19 Nov 2026 14:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A3F1F000C9;
	Thu, 19 Nov 2026 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795096973;
	bh=f/AGc49co9IRdKpA2VFSfedJ8sUlancWLOq8E/XkKss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BFrwIpRGtLzoYyMsETfOISsbAGyDWgsUmZt3nbKFqhI/NZsuNqPLN3opz99iC5nSk
	 jQysfrYKrylKh+sMQbPCc+ZIVhgvJ4yZpg/gbNUg1F3cQMiElSfqp5pFCK0XNkWhrz
	 Ue8QBfmz+hU1yWq/gMxiuf2WYZSfBU/91yTqLKnWo+FjwuwHjmXp9pQRLP9KNrgZ4E
	 T34Uho3e1NHgDm9BoV/hY9H9Gz0G66tcNeojvEjRcdfD4VNJOBpJGXLUSK58DwAnvd
	 topmyP3WsHsHpCUIGrmyC3eL0Be/sAyOCFGo1yjeHmmYdrwX9cEyNaan8dA4vR6wQT
	 1EZz2em4IiyIQ==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0A4D0198004A;
	Thu, 19 Nov 2026 09:02:46 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 19 Nov 2026 09:02:51 -0500
X-ME-Sender: <xms:hgH_amOYzRd7dVr8m0X7g4dhd52vpzYJP1__3mwQAoDj21RoOUuaDg>
    <xme:hgH_ajblJ4HPIBLUWaGI1DWJQ136TS6re2StEokZsZvx-Bao24jjuPRzvVL74BJOe
    3slNYq_lo972JdrbJvulUs1XmG_fGDmmYfKnbtCo0NUPooQCSIQPpFi>
X-ME-Received: <xmr:hgH_akajH_cplzEjSWRHxBPGZ_2sXbW5vYbeMz7bc8JNOuF-kKV6XLluWto>
X-ME-Proxy-Cause: dmFkZTGFFndgKVGI0oIvIBSZPYQMK+0+oHzR5AlkCgqNSv1APO1ZQxm+uD+BvHYnVxxgIB
    vSa5Zu78mA2Z2TePm6M6ndOlVZNwLHPnGbsavVyB4WQBW4lwfnz0iuMkTDNVmdXQnJ0z9R
    GSN82/7XQuqaLWFh6FTgvfw5TxqQkzkRqm5vUsD6EckF5MHALw4sle52/BFHjuEU5DQrFj
    O3b3bbvAoOkNVtTr6U35Lw0WpGVSONOa2Xcs273V7ZNh8J0uZ8Mq5q35rHyJnRmjOAZxSu
    Kq9oEepCa16IqD6r3owF4meYch2O/Sla+Ux0SA/V7ySnd6g4D89XLPu9CdxS9eRg7wvICZ
    Dr19o2X6VOMBl6x0ulunXyQZmMptdfIt1lN5VMUsVsVPCH7KeQ6uGqqYNUw/P+kRfDfYke
    VRaaL/4HNc9Nr+naMn2EqtnGPx94HcVrlHkyYZ2xiWKaKpPAW5jbSCXidDAgh0MXhVXS+6
    6Y1uqfrF3ZGImkVwLYgZUFrND7SmXyjnxCFTgHPYuuQeqGovwuAY8reY2C1Y+jTQPOoDYy
    ebVOof5U9J0ftBfrU54j2pDTDOUB64nsIGGRFeYcUNRVYNAGv9epZ5ffK7p1xc4FDHjyeE
    ihNzPqoWaalJ+YTTb9J5ojlLAcW24SATMaufEvr6iFdrxOmL+yk3HYs4OVqw
X-ME-Proxy: <xmx:hgH_aqQd7I9EvoDTH1ZlmphDB8mtkMBxYQSXM-eoRAVfgIW7SKZmjg>
    <xmx:hgH_ah0TPhcqs1kMRujzA2hnzOvByiCmTAAUYkMCvq8DzVo3SvrTIQ>
    <xmx:hgH_aoXm9znKxPe_jWJaaeRYKzd_okbM5eepRY4ZyEFPGvH0fG3Xkw>
    <xmx:hgH_aqxXc7oNOWhbttdfR8sTObCmoFjtZdGOjn6snZsn4p5TVJ7pcA>
    <xmx:hgH_aivB3jDIaRSZ8NA7AapUST-bjmtZLRskw0QzGjBZauwhIcW8eVGB>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 09:02:45 -0500 (EST)
Date: Thu, 19 Nov 2026 14:02:44 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/3] mm: page_alloc: make the high-order watermark
 check honour ALLOC_NOFRAGMENT
Message-ID: <av7_n5llADUbJI-r@shutemov.name>
References: <20261116125103.2894162-1-kas@kernel.org>
 <20261116125103.2894162-3-kas@kernel.org>
 <a066d403-1608-4c0b-b06b-0b786e71b12d@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a066d403-1608-4c0b-b06b-0b786e71b12d@arm.com>
X-Stat-Signature: jmnuuq6e8ccpwnr1p8u5s41b3i7t4oa4
X-Rspam-User: 
X-Rspamd-Queue-Id: 8111340017
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795096974-351484
X-HE-Meta: U2FsdGVkX1/YNGK2ieHPM6gN/V0ix1SMPGR3CHyoCaJ6UCM+aF43nnfIS4Q0HIzwiZehAxrpg3hkZz0HM0PNMGvklqD0xhx5YaHMkX+Bph9+Omsfwm9scCqOo36dsbF6bm4FeZEjGVIKhApMhCxu0ySC27jpgJ5GzRur2W8rAuM/UvOVTkU3K8prP7i0CtwaLTl1AyUaIrf0bcY07iiuFMVSznZy55AZuzplmVn6hJGgr3bNvzYH9g72h8zt0wAmhb5htYWk2Kt8bSRDxxxfD6SJ82GaNMFoENThTbRayCpPdxirKmQ+B+06V3mHmsN+N8hT1xmWFvJybj3Q5BjH/mnLynBSUPMMtF6k9hAJMIJU5t9m9sGaR/PKr0SVWxkCBoGevvDtix476A2KtxjRv8H8PXZtxnLP2dju3fHi3n3mlT3MeuTCSb+ZXJEB0qdYyR9sOkgYnQJ1AVK7qhnLhCgniQrVJf3U8kS4qHJjqfc2rWod0Ob9ZhjY9xwH7ffcYTE5hO8AsibGMI+QIYmVecGOLokuXISN12rpqXm2lLiBKHzyHraqgVKFHOvpTwIQN+YGfLj//6bl0hHK10tAg4c9gVv48kOWWeVjs2BjdecUOo8B8VvljSW+R0NxKyt+3PrtZ3LUlRNE+rbAglZ0JhwxCI9Blc0UI7flMHLTfv1lsu/vngLxil86MZFxQW3edw2H2A3yLcesOb2qvVwoym58Bfnusr4a0Plzzuy8a4gJARaBXa5o+F03HMWhviA4lZxknm5zFk+SrLA3Gx+setgDZqW0EaE7VGNRK+zG+gR5M3hK0r7XwIfz0Emxa0LG+93sLrKjkkBBmc+lJ8orzf1rcW2P+2YMmjB9/0w8nJz3EVhwEqA2OBJdw1tGA4Rg3j5BWoqqBTT1JUuwXYXvBZtDytlPQvimDEc9xXSFwH0OiV6FBorGQJ9t7iSRx090bteY7BQl1eI7jnTQm4B
 Xr/nFJxM
 VzvWKSh9h9mM+oGkeU33r5VohohTvv8J/nWbForO8etiWrdr0pnW5cHz9Tw2zOFg35sEFd/Ib5TqutHsq1CF5xK9sEtlNjEJha6aNf08Hfl6gEVs/BcjO0gKJdPziDW4t9MuVSRgqelMttxdoZMCWhDiIFsB2VofqebrNyNNzze8RdTg3yw8+G6auYZT/SWYD+QVQq7/wvc2/TeAxQZxlcYrNv8CbnuJK/ZYHl2Nrw82bh4/1bBkgK/RgKlz+7FxwcdkPao67p+woj6A+9XAQqszdplfgG5U8JhmVYfMHcQWEO8vdIb3o26rdQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 01:40:17PM +0530, Dev Jain wrote:
> So let us do something like: we have zone_watermark_ok_for_alloc. It will call
> zone_watermark_ok, which will only handle the watermark computation (so this is a
> refactor for the code ending at if (!order) line in current zone_watermark_ok).
> Then it will also scan the freelists for the correct order, correct migratetype etc.

A count-only zone_watermark_ok() does not work for three callers that
pass a high order: kswapd's pgdat_balanced(), kcompactd's
__compact_finished() under defrag_mode, and should_reclaim_retry(). They
ask whether the zone has a free page of that order regardless of
migratetype. They need the free list scan without the migratetype
filter, so neither of your two helpers fits them.

So the split is not count vs scan. It is the zone as a whole vs one
request, as the comment above __zone_watermark_ok() says. The _mt variant
is the one that takes the request's migratetype. Callers that only want
the count already pass order 0.

I am not particularly tied to the _mt() name, but _for_alloc() is a
mouthful.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

