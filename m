Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB4DC982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FABE6B0093; Fri, 18 Sep 2026 06:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2266B00A2; Fri, 18 Sep 2026 06:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8C86B00A3; Fri, 18 Sep 2026 06:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F12D16B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:18:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 932691C2C55
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:18:02 +0000 (UTC)
X-FDA: 85226482404.16.5CB2A0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 929EA14000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:18:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWosGV+K;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypCsA238jQaSsrumZecpZnUkEvEZS1oyy492kHC+ewk=;
	b=FXNrekfu9zHhGpHSct6WmRFg4zX5XrH8Tx2Q7hEeZH4vr/aWk950CjvOM+pPo63d/Maf/z
	in/LGi6ccgdrmQkwYK2yIo3cfOCGWIy6cp9yHIOQpjlb0i+yXm3Ese5BTCVopxyt/f1Iho
	XI1+YHwNoAJBg9p/WlkKpxialmUSj/M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWosGV+K;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726680;
	b=JU5dJQIXrbCiRR98k80bP8hCkXHCwQzHXqUWX7o95m+poJ2zmRrK8GUPUvzWJjBKWYU+09
	La/fuxEJ+I0NAtmzZpCJK4zi4wfctvwO8/NpUE5fjqBMT6qTwbzk+58413oyf19om6o9oG
	wmzi4bakMa9jKyrJfZtxPiPWEtMHS3g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB1A640354;
	Fri, 18 Sep 2026 10:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7473F1F000FF;
	Fri, 18 Sep 2026 10:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726679;
	bh=ypCsA238jQaSsrumZecpZnUkEvEZS1oyy492kHC+ewk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OWosGV+K9hHT5uIR0KMEnKWe6R8Bt3lr3pGRR6eRznBb/Vjza5OWsWHsijP2z4Ncd
	 rE46fKQ633sPKXhd7V1/RMBh3yqzmqxM64CjlrZZ1RheG7Me0wA9ZKaxnQfi9CY2sN
	 5Hk5e3o9mvpmo3oRFYGIJgjW5Z5KdCfXPm5cZj+WKqsGYgy4Hz4h6Aoy2O3umN3ki7
	 IRIFFKD7Cl+RBMKlhlsl9JUynl5uE0KxpiSyKZYZEYOVFneju17dtiW9Qb8++NbwxI
	 ZfiX6E16jLls+WOBZEAnPyyCGPgQe4F1Ko6raiJdD/SJTy0Q7vuUBTR+kX9/iBoltl
	 pUJ6JVIyUVyEQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id A903E1980050;
	Fri, 18 Sep 2026 06:17:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 06:17:55 -0400
X-ME-Sender: <xms:zA-tank5xMVXkupold9m9PdHtzpFh7-ihnntztTn7Yc6fkdmmeBMIg>
    <xme:zA-tal0U0sLE2yKUnNwuiJ5GoWr0DHpOjGzqHTOlUgfkizGcSkB8ai9lne9-m07CN
    T38RI3K_bt0BfQ4KjWc6vn-IbJDTY9JuV2GFrUstvAD3bEVEKLhefGH>
X-ME-Received: <xmr:zA-tasrtKjAZMMqdmt4O8viPFWAKIZPdJoqKtY-IRSTyj6x4nYj_ajHKnRg>
X-ME-Proxy-Cause: dmFkZTFOJ04tLraS8Ld6DiNC03fk1U1TPxXokJj5HDUNGVOCuzuERevcrpAkfuxcfgiX8C
    PQsHD5glq2gHcWyZk3QJbD/+NzFO+t4/s+FrJRSqoqIIL9uunXdzdBOYKFPiOB4rpx65nu
    G+AIbYPCRMp4607LbXCbnze2tVSWmUT7XBOzlaE2m6cYsXs488RvxnRKmukIxwfeZKeKCf
    cfZdvKfeq99gzENIngK3Z1slqai4Uhq9Uf2ES5OypkYOMOQEMH+lGml5bFXXrhsoqG83bL
    Qe0BpFnxcfjw2CAHHyY1EUcwCqOmcMKwSQE3J/yxMJXzBxZaa4lJJgagI6vJq9i3GJjWEs
    BTjz1z43/a//Tbn3h4wrXht4u5Se3Ogk9iRhBuS85wqjuQWYl/KnVrAdP5i0srvaDsR6MY
    JxVI0cY3EUxQrjfFHnW2/M9heFSV4mCpgv4J1XKw9CcQ0C+7UEVJiEaoG/9rdYG/5pzB0j
    a3JRoxUTjd/0fW2Ph9TN8j7zRECA3vRubUjAj6LLlmnS0JiXrKT+12pZfnQayN6d8fgXm2
    ya/GwkoSI1iYZGGfzo3VHM39NclDpxhhUUpf7C+F3aq6Zsv5JQG20GheFhKNBrTVMm1ndb
    P/1Vmml24MxTaVNUyUx4wmdIhsnP1SveU59HnTqTxeRX3YUXkfbc15k0CCfA
X-ME-Proxy: <xmx:zA-tahTONOE_LRuJVOINMxPoiDr0FjcZPaN9FYT2Fh3FvqAODlY0qw>
    <xmx:zA-talfDq-dL0jw0-6M966q6vDtUyj_wTcUeHOxEowv9ZbqRo6VQQA>
    <xmx:zA-tajS3Vuk-zgx_kHA2Hn4uNF2A8NDOWO2mTlnUOvdbkDKfWAe4wg>
    <xmx:zA-tavCLRehoQGfgw1mpG2b6ZVl7Css4TeaI-2UONHw4IARA7xW_nw>
    <xmx:zA-talrurcJ-XoXojc9qMEEhWNNCeYrCwCJN1zLcf2SumuaISrYydCkR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 06:17:47 -0400 (EDT)
Date: Fri, 18 Sep 2026 11:17:46 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 	Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 	Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, 	Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Xu Xin <xu.xin16@zte.com.cn>, 	Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Chris Li <chrisl@kernel.org>, 	Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, 	Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>,
 	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>,
 	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 	Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, 	Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, 	Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm/vma: const-ify vma_assert_stabilised() and
 associated functions
Message-ID: <aq0Pn6EBVu1jugKB@thinkstation>
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
 <20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 1cegq7n5p8fgppijh4ihzpbuho8cxxbt
X-Rspamd-Queue-Id: 929EA14000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789726680-986015
X-HE-Meta: U2FsdGVkX18WDHoA2z9n8/4BsyDfDJwA4r4NLFCSNo1GHbAtgbs6/KdwfqQ7eZeKEa3GuvQkL62SsOdLTJmmvCwPPLjvHhnrzLQj7bUHljBTl5EZLksksnWRgdD2v8QOwhoyTXY82Yih0CDt4Mdfo3LD7i27zKUszy8urxr6H3uXZD3K84ic7C9z7FWTGzxfyLSgzhm9VJVv5pek2QCVRmMhKDJug5XLppuUkWYgUXpqwxxYacMS5yq1OWH2B5PW94N8Yo5Y33XOJjFXF+tsCddNwEGUJpsjZV+2abcG1BCkTAu7fLRFFU42Oi7K8H4RVgSbxJRFCrwrCTe+M8+o0MSbpxqSdBd6sqbnPFfQ++Z+gzuMA+WWI0vENXjZC+bcbUeyuyw8s8JbwkTwsHteRSXwsNrwFeNgQ+fWt1E5eoP8vlj1PAQLq3dUYW8F5zsy4xURpU4045UL+0vQta878DE6r4mINe7qdgSDQP8xIPL5EHbelMPkqbReFf3/t3cwouetm/1pH6LxQL6ftD7me7NPDhV8mJVEEXxtRW7fAJDrmHpIwibIddo7PGXt+9mpaNzbw7pT3vs99FaSw0QblbQy7mQYoB/bDFtsMlja8BsKlWjGJJ68Eimxy5Go/aSMcx+wS40i+1behiPomeuDRh9P7Dd43LMTlMDy+I5rIelwXSrRTG1/LhNvu81t9RebYc7IaXDyaxJKkX0kdYU03GiR0fc6TLJzuIqX2kpQKNiZEUjX5j65eRSkJvCeiuKeVYL2rqsCucvI2TZGK8tEEv2XMD2KkgD16u2jHOuSwG5tZuZWixVspcUGm0KdEAgIZuw3hLLtS/NNdxFdYQAUtUOaO+8xjUp09WH4rzH2Pq93AlPnS9VyOxO3GrHfUU8Zh3hXwEQ2KAMOW/3Sr546xParPl+QI3xa3IZRDF7mRLwL/sFzFNUvx9lxSZw58Cyal8i1Bjb1Yc8abGeZLIL
 bQirk8WL
 LME+HY49vUIrDI8CtcfDpdaEa5qP2i+hpl/pAIavenG/krzbb8D92tzH7dIogLm+l/GH4+8zCRai2tu+Mj7EmLNu2C7ZudTtRcqvSnrFL6O3s30JoCNsn1bOWzyjIubl+Mfg+0QesOhHce+HVu28q8moF6ryDwxQH/h1yQShi8cgdvaNb8F/Og0IITvXO74Vv5c6+NPbHJ6MT1lGBpqiyBEZCujbJ4tarz6Y4ioCCQgedhywLCywJaWSKQ/3z+wXA5XfIuVU2zJ5vK0r3nIHPHxCoUewEcKTo6yj9r2yceB58HYZ9unL5oyM9zaC71FP5nrdoPbTTyaFfhmw6aYheAjfuwSQ16uM9Pcct3aXA/V2Ypkt81FyOUKtupbCijIZ0DXyiz5uQ2Ywa2jKS+6Lc6r0EVdU7PW0YVqRVIMFsd/L+Hpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 08:47:41PM +0100, Lorenzo Stoakes (ARM) wrote:
> The vma pointers are not modified in any of these functions so make it
> official by const-ify them.
> 
> Propagate this throughout the call stack.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

