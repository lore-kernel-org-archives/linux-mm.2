Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6D3606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=YdMLbpas
Received: by kanga.kvack.org (Postfix)
	id 7471B6B05B0; Wed, 28 Oct 2026 05:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7FA6B05B2; Wed, 28 Oct 2026 05:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0036B05B4; Wed, 28 Oct 2026 05:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF206B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:01:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C33E1140BF7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:01:46 +0000 (UTC)
X-FDA: 85371442212.11.5AA26FD
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 172F4A0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:01:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YdMLbpas;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793178105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYnXMvqp3PIi51in2UAAZDRvat3uyQD9A+wkRBDoEh8=;
	b=5FW+RROX+WHvZqQhfblPOpoVroNo52TBNhP9BVEnEvMjktsOXuGvXWY1EQrYayLux4xGeF
	HyXYmtRxxxR0isPiXgTUvWUg9a+OhM3EobGHvNM3Zw5oIPZcEfZgqS95nBpBa6DjruGHBH
	5qCfNsQzjRaJLoIro0xy6k0KkwLgsfQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YdMLbpas;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793178105;
	b=NqLFthzMr0u9jQ98UNEA0kDBuxiF+Dxc0NyBPAV9Yo3d3pLakcvTrTfXePT3ORJyaWBS9p
	F8fWDpWz95lSBmdAbROzU0+lRAW/B3I238vs1KQK4NrIMxbzKdgV171YijLWJ4+Uu0fXDb
	yAb5Np1wWl29gh93pPbJKyHpnRH5uUY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793178100; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DYnXMvqp3PIi51in2UAAZDRvat3uyQD9A+wkRBDoEh8=;
	b=YdMLbpaskQL2fiv6GAV4R23AYVz9/8H2R1+Ww7+NjMg3vEmZEIO2prq/YYbAxhgNURMT5ht62e/cAEnn5yMMxm7UIci9uUxUOcH96L7c478qYdzGLZFBn1lcVwxEbVp9WuZI6gIHlm5qBw+KELEOF/lN76Kdlh2hMAH15iY7g+k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0XDgFIpV_1793178096;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDgFIpV_1793178096 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 17:01:38 +0800
Message-ID: <7f4155ef-9f5c-4567-a84d-dddf640cb844@linux.alibaba.com>
Date: Wed, 28 Oct 2026 17:01:36 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/14] mm/shmem: fix truncate loop after boundary
 swapin failure
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
 <20261027-fixes_shmem-v2-12-86a00952acb9@kernel.org>
 <2d111275-e7a8-4ac5-8618-f068e87145f2@linux.alibaba.com>
 <10ae2533-cc4b-4c30-95d7-705815ba7830@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <10ae2533-cc4b-4c30-95d7-705815ba7830@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 172F4A0002
X-Stat-Signature: 6it3dneud1dja7caoobybmbihn83h11p
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793178102-967050
X-HE-Meta: U2FsdGVkX1+pK235ZibgaX+8gs94NoxkmKqU5siAgA4c64IyTL7PxzI+hMZeeOOSX2V8jKQGAgBjNjEFYnT5LQq58LHZe+XIz64OKMHjl0Jw0OvmYGXrW4QD8Tb3g/FAASt90i8H25BRD8f8bklwUTQL7QO4yKEOGCGTMr6fVpvfG+vdByTetT3GAPicQIekSIjtFmRpCwHjSih1ATz/GcqylAgstjVLDGfvpH2QIeOP3tsQDdNYRyFQAtIzps5WIMX5qI3e8rz1nXxaswqoRSjB4DidOxi6FdSy3i6sh1RBtd0eAe7Bb54sqQVWYbBubA0/HItE3YHKIH1gPW1P64J7r/Ky5yW2eQG2mAzJiRogt+cByGCa7J+sRBRJfqM37rMXljjauPCAJjX+V+yLbJfOBAZDnYuFlmdmZBlhEM+HnJPrfgpcM8t5beYyDV3wlio9Jh7Js+RCk7Sl42i0+wCFc/Br7V9JiA1FiJo8TrbsNmqNWBsT0ZCsOB+RCWaDDG/CHPy8g3CX3tNN7V+llAgpGGHExUqO3MVW1NrbFSkdnWxT1rwSqsPKM46gfy9nmd+KFXfv8/cuT5/QBfi5Xm5jiituh6Wg/boEC6ul0lsHtJ3syR5GAlzYr1YQ5sii1RRFgOpzhR6bmZsjoonRk5EKUMPiz3KKZ7fAYbIFZrzBwbxg2t5U1esESEKFHRa2tc/StMMAEpvrh36XDjt18TIalAAsKtwyAEP84e4voQXMrqeQLn9/TZIXzxyLsm2iuVMsplgt5w9xkf7XllYZ+RHdsVgxRoXH4eeRA42eItzE/DAd9OjlLyUj3NGS9FL4PWbiN0i8RoP3U1lGntYKtUPsEwWDJDe7aq3XiTx9r3sXeQpFKO/9gR7Mg2y/Dt5LOEN8z5gZtnr+ptTEhVeuJbJv/IbHA/AChBQlpkyluLfwIlEmjvHdotcoME9W3Or9irM4yKc9YMuzl7aMFu2
 T+sykRH3
 GEwMEaH1XgtYkk9flMVUv6tAsIW0cpdCnDU24Tagu8BnUNJ2Q/5xwh5McDWETdPxKUO3kAbasR7/wQ2Hjk28lp1heZByfcXADDHEInKCBnyLi0j7LFZ1sahUO7mj2gSQicDfKSTy4BfvaAQ2IVDtcMA2PYijVWwVeEVtoKHm/F7pCE/oZ84Hnp2H7FG7DfUbeqMf5MCd1xmE2X1lKrEmk4Cyns9cIg6fYVcEBur4TVOri7r7d8H5FNOmIJoWGzqmC2wqLjSoZjZipRbaRoOsDzzNB1Rpzp9j65ITdmlRZ6Q8POHub2fVzWHqerOHH5/QYdIuSF8GE7LvF9k27FdYPWHNUUvSxMaiU4/VY7TE2415KnfaVM6u6sgLf/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/28/26 4:21 PM, David Hildenbrand (Arm) wrote:
> On 10/28/26 02:30, Baolin Wang wrote:
>>
>>
>> On 10/27/26 9:03 PM, David Hildenbrand (Arm) wrote:
>>> If swapping in a large entry at the new EOF fails, shmem_undo_range()
>>> leaves the entry in place. Its final scan skips the entry, then restarts
>>> from the same start index and finds it again. Truncation can loop forever
>>> while holding i_rwsem.
>>
>> Right. But ...
>>
>>> Advance start past the skipped entry so that a restarted scan can finish,
>>> as we already do for folios that cannot be split.
>>
>> IIRC, we originally avoided advancing start because a concurrent swapin fault
>> could split the boundary large swap entry via shmem_split_large_entry(), leaving
>> small swap entries below the new start.
>>
>> Sigh.
>>
>> There doesn't seem to be a simple fix. We may need to swap in the large entry as
>> shmem_get_partial_folio() does, and then split the large folio. I'll work on
>> this as a follow-up.
> 
> Thanks!
> 
> So you are fine with the patch as is to fix the endless loop?

Yes, let's get this fixed first.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

