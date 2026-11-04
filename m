Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D62606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lY9xLFc1
Received: by kanga.kvack.org (Postfix)
	id 8CA316B05B2; Tue,  3 Nov 2026 19:43:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863ED6B05B3; Tue,  3 Nov 2026 19:43:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77BEB6B05B4; Tue,  3 Nov 2026 19:43:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 478066B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:43:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3F75405F6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:27 +0000 (UTC)
X-FDA: 85395588054.18.4AAE5D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id ADC36180005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lY9xLFc1;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793753005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BxN183u4KZBYO0Z1LYyG6Hk9J0ZY7HIldlj4rccCYNQ=;
	b=KuGRPg6oXy7MWCFA7BFRFcwmNn4UaZSNqTwBZa6mjTtZnoKBFsZtA+CmHkju4eEKt6+rdT
	/EwluUQbyewfFJ+7ZdKXZwmJvFC6aPqqSwyv4tAkJEWCo5dYefVrgs6BvEp8fk0E1f7LbA
	0EU42cpkQXnJ/B2ASl5cXagskH4Gze0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793753005;
	b=XsPB1hZzQDVbdEVPZy8zsdTxWvrvif+zL/Zz1O1KSPSTASIQ+jPK00jQva/PcIorNQAayR
	wiE7eSTdSe05NyJCTXlO8pXIaDKbwSZbKBFyv+Ioemw8DxKZ7NckuujfzwU0L1VW3/uKMe
	6Z0nILWImG/+ayJmmwR7ROterpZFqVk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lY9xLFc1;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D739543FB0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED3B1F000C1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793753004;
	bh=BxN183u4KZBYO0Z1LYyG6Hk9J0ZY7HIldlj4rccCYNQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lY9xLFc1lh28lDdpeB2+pBZzt5R9gBoe6AkIqA1oRg4A9lL88Oa08cSUW4zXtlBt1
	 OCI874pm8I8RSeP5+Il8gMjb5OxLLJTH1vmUeMTbl/4g8uKotJyNPcFbAlQn4lVsTt
	 rDCJJrHQ2swSHBhqcLyG01hUqvWLjOfBXWzaeArrONHouxtJ3pKu++tjXrf7W+qnad
	 skgk7aTbT11skVjQMGX2cV2GSf+E/4aK/LpM5yFsjKffsHwl1DC5LbtYlXyDFivGNV
	 MQC9b92cClNfMOOC/sTZ3qmWiQzwgv2QyF+iB4d6ycQ6nwWMfXXdxKay/HMIEsKKdG
	 UrPFQofWdduSg==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93e55db58cfso21639585a.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 16:43:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwialDGjFaC/4zOLSxauu0ftFIYVnQGuVv+/1B2ZFOmXH+W90lh5mLthSDoKPvruA0MqsbOkBj1pQ==@kvack.org
X-Gm-Message-State: APuU4Z8pw8pVxj6uFrBMRlDftXmRi+3h+57TBQkVa/oEyNUFqzxiIq2g
	aWrVXx4fpt44Sb6/AHKts9RHTXrwF0g6aGVwhkXOsou6tyM8uqg7JawGkW30BjbNVaFwuWknBzT
	LUlo+e+nwSae0BFv945EqqlUDKsWF2ZQ=
X-Received: by 2002:a05:620a:6402:b0:93b:d7a2:83d1 with SMTP id
 af79cd13be357-944217e5808mr2603278285a.64.1793753003736; Tue, 03 Nov 2026
 16:43:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104002420.433876-1-bingjiao@google.com>
In-Reply-To: <20261104002420.433876-1-bingjiao@google.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 4 Nov 2026 08:43:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z5M1KiFJbC3ed_572Z22qadmgnJdO3jKnEJbvpPEykZA@mail.gmail.com>
X-Gm-Features: AclHuK9QTXGS6QfVjUVofxOTNtsuXKl-ipR_9YuybED-4phC26SwGpv3dsR-WW8
Message-ID: <CAGsJ_4z5M1KiFJbC3ed_572Z22qadmgnJdO3jKnEJbvpPEykZA@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: skip lazyfree folios when demoting in shrink_folio_list()
To: Bing Jiao <bingjiao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Oscar Salvador <osalvador@suse.de>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Yang Shi <shy828301@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ADC36180005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: stu3gnwbc3y1dda8z4x45qz17hpqyawt
X-Rspam-User: 
X-HE-Tag: 1793753005-763032
X-HE-Meta: U2FsdGVkX18Ywk0Q4ynB2frYoGUmynTlOqKdXq3DAgBqiyFBwL6S0WLOrXs+RASyL3fcewu1DU1OuSwT6Wk43q53MR+GdhGHmIxwh1KD1oEVdnhcftZWeV8BZ+oajgEbeAjG5avJduuEHHlNdXPTVQeABsShQAg/oTXKC3bRrZxppWr8xNWLADGFLdtOqX96P3wHQOBdW512vFeoCcAnGsibvyz2CUAhLeVvmIAZQn8JV6Kid0h5F3lUXBWKJeTJKjOlvYpcJFCh6cVcYwma36KKnd1PO+NRguSDStVZp3W9jltayzxVkww3en4T37TaVFe7ZKmd+vFqcQddCBL8PEYXXLpRsuc2A7e7tlrMxVFLRD36On3Asig3j3QBQtItpsJPttxgZp46TMt0wuPKXPCFyp53I1MU08WBfZAAHzE4ux4CIlC470EnNr4gc+hlQleD7v23cnmDNugQhLl2bWua49HlpPFg1Iv+/IU9zq0S+s2cTqNNhShreXfVfF/eNp7zfSLkZD851YPXUCFLb+1mx9kgOlbuunmzfliRoQAhsUOXAZ6e2bCHSS0rmp5WQUE4w+CANOE/ugY8VUToxfGs97eK55a1LP4XOF4UK9GkkdkbBiGuDq5CjV+RqqTw11hGjup3Dlr0E5wrWKLR9dqyetRZ1B3Sg3bQ8sBj+jG0KPhkpF4kX0oIJiucAjM2hmq6oZSu4kZEkbs6pxYB6YZ7g9BlQrCqZaY/CVSuNlbOqd5/pilRPYOm4P8/IhKhtC5RAarIEToPdvnMCTq3M/6GuAKNxH4KlQG+LrquVJoemcNugtQ3rUVE3SDGfr7plb9aVTtaBmu09+95m6Y4cbgLHn2CYHJy84kW9Be8ZFyZNi1yAuY3n7USON88mO43aLwsRXoMp1e3bNuTH15/8RlUDQq2AeNUdE6cIVjD0fOWHG6ZUNXlVulg3RRMTNu8kDPl3igaWgNNUB0Cg3Q
 pSuUXChW
 Eag0GWmqUU2bsN1dcYmhHiuc8712FWLadtK9GuoWsyfZam7s1Pvmp8XHqeHRPt1UB3YWNL2uRwO9fstD++1O9dwQrPiTZaIuTG1qbdqRB7aWPBkmly9OYahiSgYJKUmq7Vi11bTPrQjyw8foRYFRRAfsewzUbIBVFGRbvNm37v3QbhGEZv/o5nguyE79sMqW7dItcLzNzoDFtWzWKZh2wbY79KHV7prRzIOpO/3ffYgYT6nKBV4JN9DVPtC/mpfLIZx9YQYz6+jTCphnI5PtXz5LkJsxmbqOuYEySzejOiRfQgpO6zxwuLK/iJzPuEo8qkt7P/y/nQXz+5EA9W1Ct5QcHW3l7ob0A16hKIKeeSnjKc22gmoKfVVLHelEqRIaXOzz+8n+z0d7DE9yxDRrR1nC3aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 8:24=E2=80=AFAM Bing Jiao <bingjiao@google.com> wrot=
e:
>
> shrink_folio_list() currently demotes lazyfree (MADV_FREE) folios to
> lower-tier memory instead of discarding them. In the earlier patch
> series [1] that commit 26aa2d199d6f ("mm/migrate: demote pages during
> reclaim") was based on, demotion was inside the PageAnon(page) &&
> PageSwapBacked(page) block with a comment to skip MADV_FREE pages. When
> that commit moved do_demote_pass above the block to also demote file
> pages, the PageSwapBacked check excluding lazyfree pages was dropped.
>
> Demoting lazyfree folios during reclaim does not make sense. Userspace
> already marked the contents as discardable under memory pressure. Even
> if MADV_FREE is treated as a cache to avoid page allocation and zeroing,
> folios in shrink_folio_list() have already aged to the tail of the
> inactive LRU, and demoting them still allocates a new page on the lower
> tier, copies stale data, and unmaps the PTE.
>
> Skip folio_test_lazyfree(folio) in the do_demote_pass check so lazyfree
> folios proceed to the normal reclaim path in shrink_folio_list().
>
> Link: https://lore.kernel.org/r/1560468577-101178-6-git-send-email-yang.s=
hi@linux.alibaba.com [1]
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---

This makes sense to me. Lazyfree folios can be freed
directly, and we're already in the reclaim path. Allocating
and copying them seems wasteful.

It would be even better to have some real-world workload data
to back this up?

Best,
Barry

