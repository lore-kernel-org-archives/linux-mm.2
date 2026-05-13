Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13073CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B4F6B0005; Wed, 13 May 2026 03:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C416B008A; Wed, 13 May 2026 03:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B3F6B008C; Wed, 13 May 2026 03:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E28496B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:36:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96E86407B5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:36:23 +0000 (UTC)
X-FDA: 84761588646.09.9D272B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 978B340002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:36:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L8zG3dE+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778657781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XugxigCjCqUDBKKoyrINMo5VGJW2Ci7qQY3REJmjX7c=;
	b=e3jmvqXie/WHREP+cC52MsyTAVN4r70XSMVGrqUdS5YNSbfxbnNR408OhI8Xa1JDDrvgu6
	NoT0W3NaSf36MBO6H+HUQbxW8aFXI/vbL/ehZF0WCduUASkeGMwbQEhiNtysb5+i1KLJS8
	72S1Zm04iJLbo2yYO+n/qIG9t6g+DgU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778657781; a=rsa-sha256;
	cv=none;
	b=zqtX0g9I7E/66yRa0If7YOIYXZFsGUSs997BJywWavQfQYaEkmMeAGMNSsiNazK7r13Opa
	VNkio5jZUjOQMiXSCDJCvwsvUyflPhwQGT6RVbILsd3OLSVqROOvpiP2CeeXPEcbOdL9K7
	L39dB4HnEeBsteD+prhaToL6fqwOMrg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L8zG3dE+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E26F43DA1;
	Wed, 13 May 2026 07:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94552C2BCB7;
	Wed, 13 May 2026 07:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778657780;
	bh=vLsbboLlHeO2mJITfXZX206T+M8KqwAaBTQYO+UyOug=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L8zG3dE+OeUEavwTv6BTWbVjH9YUqVwyLQTIasOjFV1ekneg/AsXWUg2znRC4HZBm
	 /9ab8RVKzuGgZFNnQTi1PT3Blkni5X7AcZqulqJcBTSS/+NmNt5sz7xbIGRCIF3RZo
	 b9JWF/ehMlFwCJA4B655aVRATWZCByPxFWZ9gmk+AGDYi2OeZgNAwZVapoPRR3RBWL
	 vWSL8mnyV1UxFY7BgpokNf4qhuOrXOQVIZRNbNBe2XNevxMbNdF2F5M2EypZhEYKbI
	 A7J2HyleSWdX/KlAM5ysvtQQ0pLEBF8QGDUNGrl5oaV+Z+dfakMeL1rOhFqmhZEwWX
	 s6jSLesNY1EhA==
Message-ID: <e7e9b30f-ee5c-44c4-b377-d70156be41e9@kernel.org>
Date: Wed, 13 May 2026 09:36:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/31] mm/virtio: skip redundant zeroing of host-zeroed
 pages
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 978B340002
X-Stat-Signature: e5ar65keggo5rm4cpj7r14xsejum4t98
X-Rspam-User: 
X-HE-Tag: 1778657781-473377
X-HE-Meta: U2FsdGVkX1/+sBcFqwnPC6xZiKUMKuvQKGxtk1v1N5qCp+EWoi+GWL5ujXkjWu8mkdaA7VXH+X+P/8z3z9BQE++2I1D0q/mQKwJkaRWQDeSdMSPzKxlshjv2AMAFbIRRd0nRvUJWKGCfZb8INnlBvGCCkShQjAo8vmp5o3cYrO3AQxc0f+PD8uxQ5ZyA+fQcbafIayQL7IJ9B5/33dQ0VYVor83FGLZ8z/wUJVdMWieFocGQcZ1N8AS2Y7dqSl5nTPEZtgK249BGtqz07elZ0aReEpo4LHEqejpp5H8frXFFjerz9QlQmX28ZYsb/tx1ZKBbXHgX29iibYi+jgRPHNO7IF3xCpngcSgnRkSzmp2GpaRSQQRZnfQBqxZllkqq1zIp8Q/BtTNig7VbV6aNgqUDcC3NHVjvtlIl+U+HQAaMdb4CsukryGM8ZKwXpUtphsB8gUGFF/LLf+eCZlsCMEoEIW92puEVZluVg4tIkrTWNG0uRyCiH55fxUAP1j810cgBWcj1NoJNJr7yicjxN6E6PNrAvIkmkBH17NwKFg6WVt1kM1oNRoCnAO362dB1/uQTFvz+DRWwaJMNuu1JTJZcNGtZn/QQMKgM2vuLf73HOx1noy8504A/mR2uLHvdSCFYCkZxfe58XpJ8LkqXgJ9ct/vg5/FjVne7CLO+XgJG6qMaRX8m4nMrF78l33mxseOohBNO8bRzvI5Y9DQyX0J510izxXD7rPpJ1fQlpH8I4ubGovrKxY9Cot2c8P7FJn6d2YmZ7a1nQu0OaUix+YfrwCsLtMVR+c3vnG/zu3T6eFvOSBiR93gTHlVEqspS6SZxa1h6LYpXTakRB2DwfzQ+gRotLQJNO+PuwQteU/asu78vvhJYyvUT+khe5PUby/TD0FSQAjHo0suIMkppcanqMxdxmm4E5o+dYyAutfg2fQP/yIfDaNR3UvhA9wDvuHdOz6LM3LMnOTaqJ2E
 vbq7sXfp
 f74cj/1d8y03KV5IXXgs0JKuI85KLnBLhaVY2WbDBuEb23uEJnfgbw1p1HnONHTIO1r820wNAz01ff12BZxZoiRmsPpnW/3VEay2Xg2JkDx6rBHu/2t/GfQOYzCV5547Iuoix4EZoc1dXXCZZXARMOvi5X6ItE1pt6n0hnutq5lF4SFBfOcv46sTao8eL0G1nabUb5W5wDOFNWx543wNG92vt0Wgx2IVdG8lM0V8QQpsrzDdE0jPvoo96NTn+6ihiue8UNGUXu1wSr46u5CG2INUTuO/nYTjcuK2O95ODN4VgMZhJLoDGTC3020zYmjplLBENgYlpLWtBlVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Changes since v6 (address review by Gregory Price):
> - Rework hugetlb: use gfp_t parameter instead of bool zero /
>   bool *zeroed.  Sink zeroing inside alloc_hugetlb_folio().
>   Pass raw fault address (user_addr) for cache-friendly zeroing
>   on both pool-page and fresh allocation
>   paths.  (Suggested by Gregory Price)
> - Reorder compaction_alloc_noprof() to call prep_compound_page
>   before post_alloc_hook for consistency.
>   (Suggested by Gregory Price)
> - Reorder: interleave fix first, PageReported propagation and
>   capacity fix moved to front as dependencies.
> - Add USER_ADDR_NONE comments in mmap.c and internal.h explaining why -1 is
>   never a valid userspace address.
> - Fix err uninitialized warning in virtballoon_free_page_report().
> - Lots of commit log tweaks.
> 
> Also in v7:
> - Fix hugetlb pool page zeroing to use vmf->real_address
>   (the actual faulting subpage) instead of vmf->address
>   (hugepage-aligned), preserving cache-friendly zeroing
>   locality that upstream had at the callsite.
> - Remove dead/broken alloc_hugetlb_folio !CONFIG_HUGETLB_PAGE
>   stub (returned NULL but callers check IS_ERR).

Please wait at least a week before sending out new versions of this size.

It's just a lot of noise in people's inbox, and as raised, a lot of people won't
manage to review this before next month.

-- 
Cheers,

David

