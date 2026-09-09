Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 957CDC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE93A6B0093; Wed,  9 Sep 2026 09:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0A46B0095; Wed,  9 Sep 2026 09:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98BB66B0096; Wed,  9 Sep 2026 09:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65CCE6B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:27:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76A7EC0205
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:27:15 +0000 (UTC)
X-FDA: 85194300030.13.F1A93BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B006218000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:27:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6GXnFu8;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960433;
	b=r/kC2qvSgw4FZPzKM2A/jCp2Hsly7xXRNX9k0LwE8DoGjFHtP+s+p5EP9PBUVJvfxy5mxx
	rMsFaK9SxMo92KcpyTwPS1yxSVCuDTwAXXdweT0lTx7SWfiBmjfKdyRcPyRf/uKUsWaTZY
	oMcKUPBhjNJsAv2/PVNZsYHMyh+nRMk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6GXnFu8;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RS94z3rEAyu0Bjc7OED+9UH7pawFKgmuE2czeP57phU=;
	b=JmXIdY+cDIVuuwJ5CvHfEoAARqs4VIQqe++kFZ7l4ZPbseA2QjCvyK00V79pp8nBAjjB0U
	GRQoY7vYtj1erLpQnFDlSJdA7sFePQkVHh+vZIk3KYkqttZRAxr/BoZ/SLeZNUbU45txRA
	giFrHuW3LXqiQSY5YSKQMq3kF0dXEKY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB9CB60216;
	Wed,  9 Sep 2026 13:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F461F00A3A;
	Wed,  9 Sep 2026 13:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960432;
	bh=RS94z3rEAyu0Bjc7OED+9UH7pawFKgmuE2czeP57phU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R6GXnFu8mwOitVsLDqixKEjX05Dbn1yn80ABydAZ+iG2csBdc8qLDLiGZms52yQeR
	 Qo+SJ0uhkIYEpcfkw04tMaGvcHiDQVghyck05icc7KQfuX9Es4+6ioM9vooN+FEKQQ
	 d+YN4rgalDXNOhmnUS5K9vdKMQe6bEnBQ4Z7n3LZifCPT9hJpV/znd3fhrBwxMAOQL
	 aPZom5TZTUdifDvkaRiU0X2HGDEnKKe49JnL8wsqRi7XQqHbewo9yN7iEUERXgPTKQ
	 FFw9nlGfN21z/sYGUGQ0m8lqNHXt7GR/TqZoVXo0il69z8Io36XBvjmmg76H0dDpy7
	 MFkQJM7oq/52A==
Message-ID: <6a465ff3-21ff-435d-963b-385e7e5174fa@kernel.org>
Date: Wed, 9 Sep 2026 15:27:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/14] erofs: use folio_attach/detach_private() instead
 of direct assignment
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-8-6ae22f9d9272@nvidia.com>
 <5b02f5de-00b6-4f8e-9e30-6d0acedafaf4@kernel.org>
 <DLA3V43TKTU8.20221CSH8UJ5T@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DLA3V43TKTU8.20221CSH8UJ5T@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B006218000D
X-Rspam-User: 
X-Stat-Signature: 4dihiueii8bgecjhdzm4gu6qi9o4ok3b
X-HE-Tag: 1788960433-471953
X-HE-Meta: U2FsdGVkX1+f5A+XXo7ABLdBD7ud5y2eQK9hAoYiVOXr+ZiAw8YoM+nG+PFwNIW1Ho6jTprAQxFdPnjTXaH6txIA1s0dyoUBdE7LmNrB/iO4Yz5a2trxfX+gC8RNEaT2Hj+GXXJB4O1rdurWAmFQtmR4vB5JpMSNjPgPEpvcLMjg+Iw6j3slYHdVt9u9HzRgVEPibsMR99os3X4LnUyQA2h5mU7nKO3A4YQwTvgrKMQ6O9eTUfRSBspV33m9vxQBU/wS2d1sPmtJx/U+hJ52+L3PFJAQDA8h+5kF+eVUZSI00Uni6GTJBIFTBLo6dAbGQ+77i6h/hs89d8qTzl7Z9FV7ONi6/m2UcRe2ozuLhG9/IkQRVW8gYDTVq3epdB9oD2oEc5mwTvcqJQ1FNw76Sya5yWceDEoTmBoRd8QL0Il+/FfzaV/buXL1eS50DFQYJgqXUsvddc7wCAohG83WNnrMeEOXGyCjAkMy1riBQtpncAo6sE4ML7crxCvpMglwksrQNiq8j+3DE8oL+/khpPU33BUgZxPNQ7C/bL5d+db2qp6jnWJysK171ILqiYLX4fvnEVZDvIzucLSZPceE1Oz/46NcQud9A3asWP2Nuvde7CLarHP2ve+NiKc7SnLWuCuRNVJbwvw16D+pUgFjwADPLNZ69U6fcX0YUzcMH/cKTB9CwaGGmg4OoQ2g4wNKNcpfiyyhqkAooLh9hf3fXdCYY2lK7r25Xk2GfIj+yzkToLoZWGeBKqkn1U1gdYxtGFf21Sx1xx0clL0M8ThjZZ9f7tnTz7NEvFeW2NJFMCPfSQS/15RG5kBdIQPQ68V5ITxokqHYMgd4bS4t141zYv/7T68GEliUbNBipRGRoQ4IxW4Fqd5On6HViWuoE1052yl9XAeVn4SIj2OOjyc8ML2Z1hsQmYwG2fx+Pf7RIbRRsGlzYfR8nv4s3sLYzx2e+TapntE0eUzCJysuA9D
 /emBzW26
 REsbGQlAt0cdGffUOcjnTUPxiq1agjFHFRo/KEvuVFX/le6tZi3XB91+jtqa3YgD5gTBWQAFaAA8lNTKPiKaabv73RXxEU4Ffl90lCoreC0uS1AKDGt/fxNZOJznYRH2WV4uPAuTtB8/yjYuZhv8TY+sHZV7DKk/kBWnTSceKlJRar81rWgSDzGtmwdoWv6HYSoVmGX865byrYjf3k2jva5kxw55LoKy8l9joV2Nxv9WY8XV0VfgkRujt33iIL8iTyj5Fs0EpyLYWQQiQr0m6OVWdfYiQLlbUnw2exh8h/cddShjBlOq/MV483Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 19:19, Zi Yan wrote:
> On Tue Sep 8, 2026 at 12:13 PM EDT, David Hildenbrand (Arm) wrote:
>> On 9/8/26 04:56, Zi Yan wrote:
>>> erofs_onlinefolio_init/split/end() use folio->private without setting
>>> PG_private or increasing folio refcount and it works. But after PG_private
>>> is replaced by checking folio->private in a future commit, it can break
>>> folio_expected_ref_count(), since the folio has private data without
>>> elevated refcount. Change them to use folio_attach/detach_private().
>>
>> Freezing the folio will properly work I assume, as we'd always freeze with that
>> refcount in mind or remove the reference (detach private) early?
> 
> Yes.
> 
>>
>> I'm thinking of folio_ref_freeze() in __folio_freeze_and_split_unmapped().
>>
>> Or is the ref only very short-lived either way such that we don't care?
> 
> The folios here are locked since they are in the process of
> readahead, which requires all folios locked. So they are not reachable
> from folio split code. In additio, the private is deatched and ref is
> decreased before the folio lock is dropped.

It would be great to summarize this interaction with core-mm (migration/split)
in the patch description.

-- 
Cheers,

David

