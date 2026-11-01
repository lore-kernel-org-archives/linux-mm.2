Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013A5606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2AzB7Vj
Received: by kanga.kvack.org (Postfix)
	id 2029E6B00EF; Sun,  1 Nov 2026 12:19:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA106B05C4; Sun,  1 Nov 2026 12:19:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117CE6B05C5; Sun,  1 Nov 2026 12:19:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7A7F6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:19:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88F4B160936
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:19:30 +0000 (UTC)
X-FDA: 85387211700.03.AC439B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EA65A180003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:19:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C2AzB7Vj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Q+wEfYCHzvlGOwhtX7l2Xbe7hsuW4JqJmvc2MxYRvQ=;
	b=Poy+Z3tTHxZPkAZt3wlE7BdqYGtQCrzKQ0XxU++5+OO6AU6lYeC6WfObMyrH4bR+8akZgW
	IPdwV6MsrR3Xf1eYHlMiiyZ9VyWNjFwT7U0b+8XTAUT1KHmgQNDK5Cz2A5NwFT8pz8eAsz
	GLawseu5W0ZKFO52NXZ9DiyZh7wFfrg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C2AzB7Vj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553569;
	b=OpH5TT8mQwxdBTDhUKHCgHT2XD6OxNIO7Y9kZ6GOxf7FHybmZ4rcCaFjYftfvAApJQY2bq
	5WadpLJUNq7uOVDfOmPkVhx4e5u/eGfKd9VU49+tVSc5MAvk6gitxKNDxM9XAGIuWneaSU
	BhKY9hTltUU1lVUVaqNFGXAiIygne0M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA05F40855;
	Sun,  1 Nov 2026 17:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03341F000C1;
	Sun,  1 Nov 2026 17:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553567;
	bh=9Q+wEfYCHzvlGOwhtX7l2Xbe7hsuW4JqJmvc2MxYRvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C2AzB7Vj/qJjcBXqerPM1MfhftdambYv+Bdptp+OG+AkoBpc1ouAYXNgC7EWKCxS5
	 sk4stL7ysgSeh1SwyeVChpt/U/ctbNwSwUFmrdhM2Y1ARsIStMLn990VxSiF8I2NE4
	 NdD1mv3YBYwSQon0k6RVi8qNgSh9dXFU+BkXlPW2hC80W5N9Hal+Tig2/HDXNe0TXz
	 Sh/QLKo8SjJP93Swy0Rzr1cgW3EGef0faSZbtH+pgsB0IqYEGLrbAM7PDBrUkgho9r
	 nK+GGP7IHdxRjKy5CXjm0TIHvnfgEkcDqsgBmadosvrjReZCIwvqudEfybAqWio0sd
	 lxZhPzPbvVw6A==
Date: Sun, 1 Nov 2026 17:19:25 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/7] MAINTAINERS: sort entries in MM sections
Message-ID: <aud0jqcQLSJxtYJk@minisforum>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-4-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-4-97278f8a5f54@kernel.org>
X-Rspamd-Queue-Id: EA65A180003
X-Stat-Signature: c7xwcoqsbeh7j5gqht3ph3kfzotd6xec
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793553568-350437
X-HE-Meta: U2FsdGVkX1+8F1NFswegOgIklZxx/XP0MiXwsrE+wMAfVuzO6LcEIMZ61iquItN2fJdD5YOW6jU6290RVaykD1gHIJkW7/LAV6ugrVG47dAVusSwh824xnEpThryl4lLTzevORBVFbfaaVoXu6RnSMa+vG3xjKk4AGD1hImc3n+DcDp3OjGFBk0s6bg7iMfzV8hrCRG1XxJvhwlQNS+03IdlFET/wy6KF8GPQnJuAoFwoFErU222bVV3rM5I6wBISmRCzl4KT+JVe70uL3RpK/JXeqdgHnWeVUWXip9DwjBjVs/FIrLgNOxLM0WfSPNmaityXHXn3T5BPaFfQR+JVGwZgoZhZc0wILZaS5RTSSS9f1JTexFQyyztP/F9RlCRflZEZGR+xSrff8IRDYt+Ic34tL+rIpOfSGxX5rfekPfCPKN+X8v6XqY1woGemcZkLbQ/cAO9pvYZoCybKA1ZBFBhUZmgRjpsWEGPqpL7dbXBNJPOeHP4M9zTmaGYmbnBcm87kJBWrH1FsW+SDxtWveF33pT1FZF7ylcy5C2PxRymNFmH8bVFXD+kCrqfRnNn/+ig+eEvPOw4ujuisAzMtfGZjYrkINlvOI2uNetL6EHCxy3R6GmXbpNWQNk72V0wdJNfv+B4u/jH2saUuTgQngEXCgmTdnNCPUETzXIb6Uks+VsWP3dy+utW16oILTQcIGNsIVpIuGQlHazrHKh2QNH/n2ZBy9a3W5pnjDQuVVBJtYNEWbGwTXB3tYVsajz16aGlhU0uavM8B9zg/GNOEOqLJadwLN8YQqWL1GZ5AQlwJl9CIhErs2IKEKkrFz7cfsB7UgGxViWFXI+J40lNHhfo03qCmJ4eaSWoZB+aFsVPZNRH0WKbr5vbOv8i1KO7SfveVPoTim16B1qYL1MFOhqK7X0FjiYD93XKg6gcW5PBP0CUpG4p6QuXKyxGOu7OZJjY4bkm5PzlfEr80ap
 KY6yJcp7
 6SdjnC3uBEdJP3eQaWVi0bVUDL5YtTyv2nLKL2KyKj7mT8bCgOjsZuBrfPzURaz3YG6QXb6emGFIRqbmiRhPg0mnrCQNnlg0Mr/evmyl2xQI4JCrB+gvGdubhNAEH3T+ElkK4a7eho99eJXc21f8Xh6Epihw0A6S/SeSL9PmuyA16K3Uu8d1P0ZCokCeJvjnBu8xtFx3gQHnP9Arc1Uf+sU7ZWCTnwr5UPda2sS+5sjVfo9SVXRk0HbE0klUJPLwmNOErjj+Ewb8icFDAV0y6vbCuYoVXV/xXn8Gbq2uHyKNSI+4rwZ9uFUlvfDXxBFUS2dQ8RgD+gFWZBHza/rmqMkxJydYsmkt1tWRA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:28PM +0100, David Hildenbrand (Arm) wrote:
> We try to keep these entries sorted; let's sort the MM related ones.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

