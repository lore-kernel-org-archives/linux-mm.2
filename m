Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDFCD606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XcnbEhAI
Received: by kanga.kvack.org (Postfix)
	id 080CB6B061A; Tue, 27 Oct 2026 04:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B1B6B061B; Tue, 27 Oct 2026 04:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14A36B061C; Tue, 27 Oct 2026 04:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB32B6B061A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F9AB40902
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:22:19 +0000 (UTC)
X-FDA: 85367713998.30.0599BE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A6F7020009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:22:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcnbEhAI;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793089337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F88x0w6RcEa+c5taIt0Fmt+oPbV+qXUJjPjIECkCifM=;
	b=3xr9/2kdXRaqFvTP/8vMq3lQQ/3n1y1RQO/v7oKWxDlblj1Obe5D6tYTSDuPF5u3Lo7sbK
	LpIBLQ7rkA0V+3lC8WZssEiL8TFX8N3OuaAgRAzxCb9GUkim48hM7a1IBR92SLE8CidHpp
	Cmjf/f9ZKx3EB1dexwWd2y4Gd2I39+8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcnbEhAI;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793089337;
	b=gb0IyIRI7KbJlNeFBSwiUHGw2T2mDhSmShJT/AO+ZDdKAGgrdnG+4c11EwKnNckw9ItZWg
	kkJQXQ1Zixm096QqHmeyZJ1YT8ygt+71hxHmNo0+IIX9W7c2t5T3X+3B9DqSQpXZUzjwMC
	gPc+zGl7wK9BYFu5jxUQp76fXBv2lts=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FB0860052;
	Tue, 27 Oct 2026 08:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132EB1F01825;
	Tue, 27 Oct 2026 08:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793089336;
	bh=F88x0w6RcEa+c5taIt0Fmt+oPbV+qXUJjPjIECkCifM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XcnbEhAIT53D3Hun+lr/E6g8U6iRmEJKDft/fCMNmTrAnwk0hAOsyjOokbVPvXEp4
	 /DPpT5Su9B/w3gWyP9HIp6tCbM8SpfFZQEHmk9xZRAFv8vtovKBHP6oMqM2laor/ar
	 P09hpU7MLdF9KtuqzyyOT3LFejOV+LPLAbIgOliERfOsJ89eZuESqQurxPzGdarj2T
	 8EyrmmZ5UZbvTI7dzlnWbVesHv53x07RfUr1UgzVZx1w/Da9SXe+VMmXlfYIiXPrGF
	 gCrBiBDheLyK5D4iKWh7VKsJm6UWGTipezUjwklfkuNFfwKK/QHJ4IhVCDB+Sy/wHO
	 TpCkfYmmCp5fQ==
Date: Tue, 27 Oct 2026 10:21:54 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Alistair Popple <apopple@nvidia.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 25/46] mm/userfaultfd: wake waiters when registration
 modes are removed
Message-ID: <auBfIuDnoICBXoGj@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-25-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-25-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A6F7020009
X-Stat-Signature: fmbcmzncm7r5eu55pn8c7ku5kdayycp1
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793089337-265433
X-HE-Meta: U2FsdGVkX1/8qXM8gmmd3e0HE6yzQ3JYQ5tSbKKAwiMn4GkAD/0T+J19LGQAY02UZoeuUIJrScOft4sLVGkhNDocvDsnuLI3LAa1nl3I90EjBbgurH6Mnm9j8lDyS4qyR8YONcCZD9ylKRAF5Wyxp2g/SMzzSnmX3YcpdC1sZfRjoOpjQmlzer9w4xYaZrJyYwQe0CZP3WzaITXe+XFPcfp6leImnn5NdVXSG/LFuz3a0rwuonM12o9Hy1Cz6//eSHWGcQDsYvuA98YL0KdzqQBYAAKCftlX1tHOeJqeSPGqS+TeEqjZwSLsGeH0WysAlf+XTMl2OJf+ISGrr2MQ7m3GKIkEz8Wc2n/A+W+pmVIRFhPUuRl58YI3jG7voE8jd3Y4XvdKbBBfhZlSyBMXjx23cNGW/V5z2OuKwKPJPTAFvvZ1hFfcU5zDXmJ7II8CeEXc0VSxx0F1LZjUCPylhetwyuN0tlGP5fjghp5FuesH+xKyogvla2Nm0n5mmdLMLI0xWRyy0UJO8ILTCqNRKHX02oQYdTJSp75usVZhPWvK5ZOkVw10Q7Juysugexld/uT5JQ1v4ly6QmBU/4/jz9hoBkBNJBdrIRhXqTIXo8Qi6vJstDFv0DUQj7RkCylXsbF4jnNfU9wsL2PTq1dvOrKwhGeZkdm0j+qdAqLVWIJmcd/ngBtY4SjYMOcvpm9bLfg0bZIdwgD3rgg48tzuznyjgqzVlJ73rYWlujeelZkg8iRFxyfsGOPsegky47RZ4YfIYcdZIrwOOk2JXPwH2AczkISBKgYkOZ+GUdS4VKOnrR/cB5wFAXEPTTnft1TLoo0h2VYOhZTpDJMz+arflbOoPcgK/13HQoAPG1ihvLqx5iKHX3lbGIuqiV1bqHukSYDaxO3x7m/8FqObrwC0YPkLhPLW5td0FijtG6Ot0KXFnxlMNEJWtSff0REF9MjEExYTPj4GaEVS13NjAX4
 nR2kitH/
 XzPytAPFZco9tY6+LhltCzgd1TmV0nHG9yhfvSkK5sMAXoXCIc9ixuEoKVc/zMXufC0S6e+tQgkiJcFw2mo9se5P73wfafWkaOOt8aWU+y2bCZaivxY4s2Kr0Sap28obiUJ81OtGFbe6WXPdK6L7nPdaz1gpMmi7gaoVqo9ae8kzlk7UacWXBmL2QbKb1zPLRy9eHv7bmoMqZhsbBIZg1n9qbjmQBcXClsTlIr0QjSZXnnsiY/KoIGAeaUlZ67PhUzl7Ea+jmTNnnyhm+kklJmdIMFZ2CV6rSv73KDADrr5H+l9tF/uEFIkrwIyO8KPMwCftbTyYh5XdB2TkMMW6oFYfNmvaQRMoHeUVv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:45AM +0100, David Hildenbrand (Arm) wrote:
> UFFDIO_REGISTER can replace MISSING or MINOR tracking without waking
> faults that are already queued. For example, switching an anonymous
> range from MISSING to WP leaves a missing-fault waiter asleep until
> userspace explicitly wakes it.
> 
> When a registration change removes a UFFD mode, wake waiters in the
> affected interval after updating the VMA. The VMA is write-locked at
> this point, so no new faults can queue under the old modes and woken
> threads cannot retry until mmap_write_unlock(). Waiters for retained
> modes in the same interval may also wake and refault.
> 
> The hang reproduces for MISSING-to-WP and MINOR-to-MISSING transitions,
> with both read and unread fault events.
> 
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

-- 
Sincerely yours,
Mike.

