Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8A1606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FCQlYwRh
Received: by kanga.kvack.org (Postfix)
	id F2D396B05B0; Mon, 26 Oct 2026 13:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04896B05B1; Mon, 26 Oct 2026 13:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19F86B05B2; Mon, 26 Oct 2026 13:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B36766B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:08:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3570680788
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:08:32 +0000 (UTC)
X-FDA: 85365411264.03.E429E5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6CC35140005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:08:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FCQlYwRh;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793034510;
	b=f5iY5xC7t2NI9ywPLGdGeu0lHWPYgRx2Qpdi+AqXFPhiY+LnPG9+IF8VLnhzXM5bTvC6cG
	zwL7s1o39q51TDoCiqZX9bQPqTUMXbK6jaQrk0Z9xlMm7zrEO/v24NDL1/LeBy+HoeuCuN
	BqRlf4Bj7nI0Nqf96cmBmakl0eS9c7o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FCQlYwRh;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793034510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzWJjwBFyt0mJS6gIeLBcNf6u3PnEIP/+Vjr2fleQfw=;
	b=GpnqPOprcSKzgfoPYB+7LZTPd1GwSnb+53jHtu21iSTGaD4zorixzCbPCa/JOX7GRA3VTF
	SIfqX+0Nxuusppxxapj+viiFHR4wGAH92gwpRMyC0g3mBWCbjU4qKIK0EGwzmiIkwWGnsw
	q2kvd1EHlPdFUJNEX5n30xn+9ik/C0s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B664D601EF;
	Mon, 26 Oct 2026 17:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E9C1F01825;
	Mon, 26 Oct 2026 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793034509;
	bh=CzWJjwBFyt0mJS6gIeLBcNf6u3PnEIP/+Vjr2fleQfw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FCQlYwRhKz18x+BCUAsSnasMtbCBZauPVDLi9efN9SPT6orCxZxB/B978d6hv8ww7
	 sCimhwZKhlDsnQjLSYb8mKRjgK/wUI44P1QJiQuEViQk1gJIVvzfXsHKoWDD3yq94b
	 d2ZVPxTMkxGnkxDKrdspFNsYa44hVz4BwIjd17D0wk93sZ1VpYgFFG3msX8A3oT2hV
	 RBO8BvLERw8RefL500hIpcsNU3UbAdhM2tnVNd/F/dBbHiZRq4OCdgLo+iEvV02gt7
	 gNN/cDNpPQOenAmzpN+hCvqmJHrOOYKTX8yrRPwWdecl/pjWgdRmTx2RSFo7Mojehv
	 ZtjCYHrCmpj1A==
Message-ID: <f7d36a47-6879-40bf-8c24-dfc89d937647@kernel.org>
Date: Mon, 26 Oct 2026 18:08:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] mm/shmem: stop retrying folios that cannot be split
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-8-703206d5fa0c@kernel.org>
 <at-AmbZyqUnGAJkI@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <at-AmbZyqUnGAJkI@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g6yhoq6nyosdor1myrt9k7aeofzhohp3
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6CC35140005
X-Rspam-User: 
X-HE-Tag: 1793034510-253900
X-HE-Meta: U2FsdGVkX18fMfJi573NVo82fbdt553bm8vRqfMpJJFowh0dsKAZbLnxAfIL/4zrGBWxqphJGXj+8HIOhAR4HGs0C97ITSVeAsx7vzzDelN6bAEUVb+ES/pGoYs/fHzfzR7a+OwTu0dfV+j9WsKKwBzYnLMn18dpwbjt/OJR5M+qBBdHKIJOQfq5CGd7Z0nBvzTSeYIefMJL1nAqidD9hJ1rqB750QigeXhahNascTn0dzOhjDxCyPj04fyoKlVzyzlowyPm0ldUU6sHQOz2tfZ8IAuQ15t7JJ3wqU/u66m98oR5WORpJiQD5GptmeYusO928nduGnBCE+SoNtrUHZBaYWOYQYj1z2YplRY/oQPP7unWmXZIpCXr/6MXpLZ7G2uuZzb+NvBiL7oo2PvE4ti+Frvu/XHG84O67f966/YNyWsK1l5D8Fce5DcfAQeV4Ec6qVgp6axEwaIdKBR5gcB4v8DAKqhx+SI9L/9NOLyu9kFZVIV9+X3TMRfetASuYj3yPlU61C74Pf0f28DQ+Pik9cn5PQC1IvDUi6nzut5CS3JhvYN0ZARzB9qfvCJxtXglqwdoqpRjS/wPAZrfFEbut2JFC++sC6R+qsrMVlFzBNLZaEM+ZvzkJlAMhA5NFIJzutWYQduBdPiU+LEXlQ6GPfRFoTu9hIipi5qNPgTsIYWYUGcSp37upBaBR2MLygUqdiZdiNU70vzduIl2Q3l5sFgJRhKEqxQQq/nKhm1cNcCDXmQ4LYpJjrc56tXa+fx1Kexd0X+9smj39J8s9nnhiMQzRMkZdEOFD19cFXHzsSPyLsZUpm8/ojQ8YNeeAZj3/nH3rDQbVh++T45mEYpYA7irWpHFILd/K83Fi+msYIbSNYtsRQpicIcdOB4JsB2BkvWMciDZs91NXdPS13whVA8XIVyOhU+H7Jrls+83LlBUuT5W6mg34dCqWb8DXO6fvElWgs0hPRRKT2V
 6yyfzJVx
 nu9dpMxf3rbn+LkprnvXO0ozxixGM7eui4OzXnYg8poNMlTGS+2RkVmb+utT6AHovUGNuBY29JEBYWc08TuzkffDvg5Niooe8FbJP2qj58KVuXIm392DZLHJUFPz8ympZ4K8GuXcfe/eWhnhD8VbaZKhrkxdvAnvfHYLiTNhxu3ZEXmpd1hwWB4fNauVO0ZYX6t8LORkqhTpw0KpNvzFbwU63arctcDZpB7SUWUI9QRNtGv332RXb5d5RfzVkvw455Y9tRJzoa3VUxfpQcLQj7kgjDqSnUTvrSES10K3d13ebBFD9dD0NJjIjZni6scdSxptp/cUGoTYcfJ1CHovRI5w4NcWmUhwKHrryvEbefENLTEs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 17:36, Kiryl Shutsemau wrote:
> On Mon, Oct 26, 2026 at 10:40:41AM +0100, David Hildenbrand (Arm) wrote:
>> From: Chris Mason <mason@kernel.org>
>>
>> A fault or collapse can insert a large folio crossing EOF after
>> shmem_undo_range() has handled the boundary folios. If splitting that
>> folio fails, truncate_inode_partial_folio() retains it when it is dirty.
>> The final scan then repeatedly finds it because it restarts from an
>> unchanged start.
>>
>> Truncation keeps the inode lock and ignores fatal signals while looping.
>> A concurrent unlink() can then block other directory operations while
>> holding the directory lock and waiting for the file's lock.
>>
>> Advance start past the retained folio, whose truncated part has already
>> been zeroed. Do not move start backwards if the failed split has shrunk
>> the folio.
>>
>> Fix generated by an LLM and sent by Chris Mason in private.
>>
>> Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Chris Mason <mason@kernel.org>
>> [ david: split fixes, simplify descriptions, adjust comments ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Any reason, this should not be in the same patch as 07/16?
> It is the same failure mode in the same function.

I decided to split because it's a slightly different error mode (failing to
discard vs. endless loop) and tackles two different commits.

-- 
Cheers,

David

