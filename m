Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C50C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82AF6B00E8; Mon, 21 Sep 2026 03:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32446B00EA; Mon, 21 Sep 2026 03:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00036B00E8; Mon, 21 Sep 2026 03:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 828EE6B00E8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:03:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C17E805A2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:03:44 +0000 (UTC)
X-FDA: 85236879168.27.B84DE2E
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16A3F14000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:03:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F7s8Zsc+;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789974222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ja+BJZQYgGq+9xn0THd13T2tBlkDWCqho6ZTyVA+sTQ=;
	b=0V5418GYMGgXTBJLEos8avJkE0m8dX0EdBvDhRHr0V8NWPTNpNWwbYPMef0MPsaqpchFf7
	VIz6DnAobWQ9Y0mP/rABKe2Qh602E3prW0KPLg0EtxBvEmkrR5SneUR0Yh2FWW/sMwgy5W
	UJQD8VOvjqyVSVOveDs+P729FiEy5ik=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F7s8Zsc+;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789974222;
	b=A3BTtSblyV0dmYVdgMvCfm4VF0ipcTQIDDhEMLkQLfQTIqpb0qca+pg/TZ9mDnKnT8+IDC
	Kxvl6EZ6cJ5d2Gt1uAjNIkzBZ0t+8iRJVEYuuT6UJrsSCv2FsiRsbi9tW9nNESwXEPzZL3
	zS5CYk55wiqU32HqCCHO/ioGNmEAd4E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WmDc0N1baiP/8WMRHDil/n3WL/xh4aCmEkI/IFkGwhA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789974220; v=1; x=1790579020;
 b=F7s8Zsc+INX0m5yAUWTb7oLir5C5P+2JRBYIOQsffQHjDhXtp4WpzbmESuY4ndfYvaI6JtlZ
 OtLVefN2yT/B9XtQA06/hkgBhUSm51qKAnuI/mAm8PtfCWIo1aRmmUjsWJtqEzWU1GbyA5NnR+9
 GtV4savXtVGJIgwMBsAiF8sI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9f90210b135d8c77;
	Mon, 21 Sep 2026 07:03:39 +0000
X-Mizu-Trace-ID: 9f90210b135d8c77
X-Migadu-Flow: FLOW_OUT
Message-ID: <a44de8c6-a095-481b-80c5-5c61fad3151f@linux.dev>
Date: Mon, 21 Sep 2026 15:03:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/17] fscrypt: stop setting PG_private on bounce page
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>, Usama Arif <usama.arif@linux.dev>,
 Alistair Popple <apopple@nvidia.com>, "Liam R. Howlett"
 <liam@infradead.org>, Muchun Song <muchun.song@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Nico Pache <nico.pache@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Dev Jain
 <dev.jain@arm.com>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Barry Song <baohua@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Gregory Price <gourry@gourry.net>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <kasong@tencent.com>, linux-fscrypt@vger.kernel.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-4-bb68b6a21869@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-4-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ri7h1ecya5ymkctx7qkei5k1mgkshxsy
X-Rspamd-Queue-Id: 16A3F14000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789974221-981406
X-HE-Meta: U2FsdGVkX1+O/+tFOhRtL+7kaIrvfq9dvRdTMWUU+F+KilFcG+Pi4o4uhP9gvPcoN1xyvrhiGWshcBZ6qpXIjrq8IiUdBGDts1LdTRENChRyuII5D08MMDJRgE/RpeLUbdjaZqNAXqaSKDg1x9OmAW/jg4reG9meq44W+MzHoH1rETqYR1gHmwm+o5JgHz0bvOqZf9V8mSoza4IWCgEa975qjExA6F3eM0nUAwGejlJldU5UHcEBGGUsi3OcCSBYFXzhTofPCLyxS6fSnGhGsF8I52oCJ/iiH7ns6melQK/rmUEyALhhSb17J5KJHBSez+9rWyzGk1R8vsYrWG4S3Ph/AMLeiZosykb+hl9daWCTw/xM6c116RwXBgmXtJrFXhOEiKyr2iAC2iTXsFHL7mIvrnsUF+XoHQmBWTADRvs7rxxVVsTDpdqPIkOvNlptMesStfx+ug7UBY8cTarM4sT+9Toyzk2U40ix2bltS+Phb9ZCcaz0IK1+aWp9yw78DfmCNAdKadHhpD1hT/qnFKVi6FSA0XxdVUUO5epXOjZM4c30n8C5pbhhCKJR3qnBixYs9con88VLYO0hEMbnYv9NQho3Z18bKnXLVFBhQsWVWVLz5a8vLszs3iLQBkkXKWXslKThu1A6fXn7TItXULaHwSGSaVxy3wz/IXZMGN6fvcZK/CWysFeGsqm7TCyt6pBV4cGaoq+NWI/NNLOM5v/Oxd/3hzGe/NPjjCYAwxIT5iKyCOvNaJ2lbXrF+X096DKLGgc1aiIDD49NDQTaBAvKRAYu0zG6yKKcihae/mMFkMdweBTpdTXiR31rEILoPDFS4jl0VIiDXGM/TmJmu9rro5vbYGWWWy4TN2z4pTyBTFuaXEZPtJxgec+arHTcsLgYxmhitEThhEI2bCgQvBw0ClQXbqWNFNOkZ29T5+CMnStFcNFUJXTOCHSEXRfI8+Czetfu9S/sMyR9cL5
 wXm/7jHM
 n5ngvc9Jg+9vXcyy5pj1tTK6mVShfXiIW7YvBR3pjEJOiw/rAsVvs5XVGuzY+KV3OSoiSQKi++/5jy9FNgwDwRy9dbvae8zfQNGmv5moKyLQrZKsWbOM5tPyojlJVabyqMMU0fyux99d8HKutxM/sl88LqYz5keawagLGrKlQ4dj2nfmnggLBroDcabgsc+RRIzjLopvFJCQ8DjL9c4bmiR1kVIQv0NnA0B2kgXaSW6WWS4yuP/NFXhQ+aJjekdZmPoISNMJyihxYjIsWYCkOdS4Vycba8JTCySRLrvTNfKj3ER1QQW9O3lZbtZflimMG4I10LCbFHQofkBMQhs1Hm/xpERJaPTMjf5CQRR1PBnMmvDHww+TslS9sjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/21 10:28, Zi Yan wrote:
> The pointer to a plain text folio is stored in bound_page->private and
> cannot be NULL until the bounce_page is freed, making PG_private redundant.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: LLM
> To: Eric Biggers <ebiggers@kernel.org>
> To: "Theodore Y. Ts'o" <tytso@mit.edu>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: linux-fscrypt@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

