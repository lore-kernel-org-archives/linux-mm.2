Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F5C1606A327
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LnoTTF2B
Received: by kanga.kvack.org (Postfix)
	id 227176B05B0; Mon, 26 Oct 2026 17:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8BA6B05B3; Mon, 26 Oct 2026 17:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EDD86B05B5; Mon, 26 Oct 2026 17:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D642A6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:13:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EA76C0870
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:13:16 +0000 (UTC)
X-FDA: 85366027992.02.DACF0D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 40A3240002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:13:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LnoTTF2B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793049194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njk0ZQAErkLe/6hfHsUYKh/D8MGIWnBcyiLvcekjYL8=;
	b=3mv3Yeug/94957CL6UFXCR6cEfeJhpmFnQ9IS5sXCTusDEBD8qrDS1jyL6S6tRxjiXG/aP
	qh1bLqEq6KVpBc4TI9AZBhKUCLz4wzUUG2DxnrK04NTJBPFVVw481H4lqfTLQCApLaG7Cr
	Q4eHuvIZhIo79ejBWllhtwrJVgUH+Oc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LnoTTF2B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793049194;
	b=fzRomylblVQhrtqbPhdMl8veX/gkuuSEk7ve7uhmPCQtyfxAx6Vw8yDhV8KDaWcpr1UuSg
	CycLrjLHV+pWTB4YXVIRQmCMZoj8KOIAsfjRnOgGhgrknQsrK3mnq6J3WHqq6vRQRdPQAo
	kNcr+y3Plre0PRdLh/dU7MsvY0vnehU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F9EE413D5;
	Mon, 26 Oct 2026 21:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A851F01825;
	Mon, 26 Oct 2026 21:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793049193;
	bh=njk0ZQAErkLe/6hfHsUYKh/D8MGIWnBcyiLvcekjYL8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LnoTTF2B7/9xXxLtLqV0L+OKJqjRY+xjxLjysetseXblaQTktKaN7zguN5l6NPVgm
	 QZHYSfSlThR46oLYxM1Gvsr+byOBqfT+hYd9PO/NmJWBkEyOncChsseK59RXgk9l4f
	 zQe1xEWo3NbsYiEyPdWs+pQH5Lx2WQJr27KbPChsPstoFEOoYBw6XNa2cl+7JMTo9F
	 IoUO77kLM+A71s/9AkPOTtuBv443xTVaM0A+evBkMGAVT+jnWX6ET+nB10g64OBMfD
	 Fy7AFApszXdLoygxETvyRtAS4/TaVdmHmpAkQAABOPsz5EcY5AjRq6m/KbttlXXH8a
	 AHEZItBorXiMw==
Message-ID: <583728ed-dc63-4685-9ac5-5a980db55973@kernel.org>
Date: Mon, 26 Oct 2026 22:13:02 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/16] mm/shmem: avoid moving the truncation start
 backwards
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
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
 <20261026-fixes_shmem-v1-7-703206d5fa0c@kernel.org>
 <2E377C76-D62C-4A2A-94E3-ABC40C6FCDD2@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2E377C76-D62C-4A2A-94E3-ABC40C6FCDD2@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 40A3240002
X-Stat-Signature: 1iuq9nuj6mt3isp8tw53otma4j6pftni
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793049194-424300
X-HE-Meta: U2FsdGVkX19I4tTICb/Fl62ZcYcPqux4GO6irFWVo8KVcbULk8bWXDcwCSjV+i7yaL/E53m951QF8gSixMsYDaYDomlDBo8IygyICuU+AEXxTQK36hj4SMttDRW7Dtc7ExibryDmg/kbufn92vQegLiZacslQNM1BJBos4uoZZmAo8YNcPfF8KzvLw5aOk1v4ceKjg2ElWgLs8cboEaR6bHBzlJPVWAjkEMy4HNpGlAk8l46Dd8uXBy0YqJVePvBH6tbNR2ot1ClgAIU6H/SoUDMc1yyOqfCHfdmA9uhUBo6LXxrbpbYTjMB7HY2+fOKfsB5cyGZ8VFMqDngVJuYX2nEWCxB+M8fmFcifq5faNT1BPhoLPHW0KIJQE4i80m4hpVqCO3ccbd26t2GljvzOvzTXcqG6C2+jxVME65vdw69JHttAFiTqxmsUKF15ZsCECGphdVus34ZpfQq0swFk9ZSCREG11jrhYlgsVrr+ONUtw+k+6usN2F5UdQvnjnDlgWpNkc0qyP9+/T8Mcz33jylO87l2lnPj0mNT/EHwEYXSVga4gEDHDftC4vrszKIjwSMb+OnnzFNQtzsnywVtY2iZfJq5GgA3w4dPogn/YchDGc+DdKd5metbyEekyjjgs1SpRQNaSqpaSscvmNYaJYvJ9yeS5uTcuOx4WX95GTsQ3NWA6fHEvJEPbrHgdrkAkXGURY5HfDHMzxecpSyrAbj01LCGiGJHamYHJAB97tyitAn8Ej9DCO8NmaxsNE60hfNR7tZ75A2G2XmSuZ0MuIN5a4v/eK8XJV8L4I1wCxOoE5Sh0uCDNxlAQ5s0eKG4SKiBNcSmARIZt86Hsy3iqrigU021lxjoF+gxwZL7vGqdlAdsTOxf/fJLzclTOZBLAlWIS+WJ1n8JCBk1Ld955qg4kewGktW1aF4qpNUE1mibLiMMAMYh2bDg1Y9bIL0kZdih50bv9ad/EzcaYL
 ZimkR/9E
 E4FaoQxyBxaVdb/brxN5fehayUdh7ZRV4jMIi3CS1ZU3ELc3QTzZ7EPGOpoVNT+awuLGFA3kjM18xRw9a/gd6tmEx/oRquSyHKAyVZmLO15v2Oruungx8scElxKzXTh6kXxXfuk2JYy6b18L7If+r59PLkNdBGDdB6KzfFq6rfgRTvIAdplCT0eswvrOm+4JAD/yoYMS9vTCEvc7/vDZ9Iz5XYzL00W9UL65jwiq+O/ErwQyqhcOvZjJWoWT12d5QFyKgjgf0I5AUGeX75qw7/aF3tazK0qht8sOOfgUbPKJEFMP7Z97XNo1ZtIYybfvjejb3rDEoaxEYhLYG2I+CC2gpu/9KMBlJKH8PAbIIjUbE6dNXTtUjwmXpJ/ZQGqcWMQkl5oP98VAOfqsHkFRSbXQ41g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 20:21, Zi Yan wrote:
> On 26 Oct 2026, at 5:40, David Hildenbrand (Arm) wrote:
> 
>> From: Chris Mason <mason@kernel.org>
>>
>> A nonuniform folio split can fail with -ENOMEM after splitting off some
>> smaller folios. shmem_undo_range() then sets start to the end of the
>> original folio, which may now lie before the truncation boundary.
>>
>> The final scan can consequently discard data below the new EOF, or
>> keep retrying a large folio whose split point lies outside it.
>>
>> Keep start at least at its original value when skipping a folio after
>> a failed split. The part in the truncated range has already been zeroed.
>>
>> Fix generated by an LLM and sent by Chris Mason in private.
>>
>> Fixes: 7460b470a131f ("mm/truncate: use folio_split() in truncate operation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Chris Mason <mason@kernel.org>
>> [ david: split fixes, simplify descriptions, adjust comments ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/shmem.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
> 
> This is fixed by Zhang Yi’s truncate_inode_partial_folio() fix[1].
> I think the commit is ad27479793682 ("mm/truncate: fix data loss
> when splitting straddling large folios fails") in mm-stable but
> not upstream yet.
> 
> [1] https://lore.kernel.org/all/20260928120833.3440834-4-yi.zhang@huaweicloud.com/

How confident are we that it fixes the same issue?

Does it also cover #8?

-- 
Cheers,

David

