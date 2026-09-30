Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B0B2CA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 09:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980196B008C; Wed, 30 Sep 2026 05:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9095A6B0095; Wed, 30 Sep 2026 05:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7E06B0096; Wed, 30 Sep 2026 05:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56D276B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:00:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D47C2A715E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:00:45 +0000 (UTC)
X-FDA: 85269833250.16.084FA29
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf28.hostedemail.com (Postfix) with ESMTP id 28CE8C000D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:00:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=CY2NKPXl;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790758844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CyczEz5gT341e5VUYWKWi3gWeXf1xphfZZ7IhgAwPn0=;
	b=7VhZSx44TcadfCliV/tWFiofaSOWH/eNGrUSqp/q4neA9hLDAY1Nd+7nLpxNpP/6iDT1nT
	98W+jZeW25uVFQxiPS4SAfaEHNcLv5X3w/wGSa9ImufXpCdvBNNcfnHDn1DX/NhGvW/OPw
	9ms5k1hvZQlEhENSbi3rqpEv3DQN4x4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=CY2NKPXl;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790758844;
	b=IpM0qJ4Csk1Z2WdzbAWSjYmC7kdIMdY8AgNoeWSyRl9MSZAudyxz6U6lFbOet3FA6iZrC+
	B1qt3AU5COeDXUG4DBE44T7iRPQ8cxy98RuvL6n5L28jiNUuw2fLqspnIT/zZqxiqbfXQv
	4TLSrXPj9h461KtC94ENS3NjL/QGGqI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790758837; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=CyczEz5gT341e5VUYWKWi3gWeXf1xphfZZ7IhgAwPn0=;
 b=CY2NKPXlbg+98MgcaBCWbLxRszHE1vrr0olGpuIYWN3l6NIpK7w1o3cMHpU/OfICsOXFAU
 MnzusaZVRBHvQAAhPK80vgn/Wkd5L4Vb0asziJvwwgK9yzxQCDkkDQJz++kLTqvM8Xb3kU
 iPrOYOn5Kf0plJ8pPX1CZUIFwlwCmbUP2FGMtBMd8hLoUSyXyCuGnDbE8Vkxq51jyUDVHo
 q2wmFjKOpkKHvdpUuVTKdMKgttiAZj/G4t4UrMIA/A1OIkr7ZPHkaCQYbv0CNvYQ4VJKxm
 fBYDnJpkgBxWxuqbl3A1Q7E5qswbudpObbK2EXuhNK40WogHRR7/CjtxWr6pVA==
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<liam@infradead.org>, <rppt@kernel.org>, <mhocko@suse.com>, 
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <ying.huang@linux.alibaba.com>, 
	<apopple@nvidia.com>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference with MPOL_WEIGHTED_INTERLEAVE policy
Message-Id: <7df34f77-2c52-47a3-a495-d782009ab543@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <arzLw18RiTN6Hmey@fedora>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: "Gregory Price" <gourry@gourry.net>
References: <20260930072617.64665-1-lizhe.67@bytedance.com> <arzLw18RiTN6Hmey@fedora>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 30 Sep 2026 16:59:50 +0800
X-Lms-Return-Path: <lba+26abccf9f+0e73a2+kvack.org+lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Stat-Signature: fjken855htfpnns4t4bda7bc8tfz41cn
X-Rspamd-Queue-Id: 28CE8C000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790758841-243831
X-HE-Meta: U2FsdGVkX1+Nz6cDt0rpqqGsMRFKlWaS+IDJGlV7W8Q0zMzHaJNjCttqqLaPQmeXSDb9a1gYu0ZGbRlYydzB6eIQSZCvnJc7PJ/+erhlDAzrf/yt909+QFWxnUwx7TVeDFr8zo6n2SsxbTMwxhtS2yxOUqfL3TLOpgv8/Ol+LlRFSj/7csO8vpNJCICc8B3P9PJPAbkB40RaboJwh5KH5Qonwz11wmbdFX0CnfzfwAlgq19PEPO1MBq++9sGrMkGwMtjq8Lv4KyxDFs2HyS0aKQr+kqpFbKVKq7dixTDPLfqUEXruSfM3gC2kkj4GAdSJCu8yS6DQ0snvBkF+LJMm48mgg4v5l8Y40Konltn5ju5MfulHAOg6XTkpZ4R5R/EpvZing91TchbF2GQOkMl7FB90P7XAFIM94yUzrqThcdnJbUw53cYIdEzfkgp/ODNIeR6OVm1viGEsuyLI864zox2dqqGAsAJvXoB7ipvIqON8QC/jebmVpflFMUGXrycvGcGeHuSEWJ9EAnjNmu5gf6j8DdD8kvvU9MT1/jzqWG9VtsFovSJdR8LDnprSR2hGZkPTkVdrDOoMgjCG3wYZ5tKHl0CwSFBFBZiAMSLX8DNU81sDKVJPJcyFM+zNyPHmAgbu8QiCLaeWVRuIJBVOebSPptRWet2onZiWXL42qdrVAZKZHSry5tdBDqWBioZW5vsWkeaXBdDvUhdOG3Nx+s4Ho9x+tQLIdmokz6pHlZ8XDAQFa2o7tWoqgwTsU2HsR2Lh/MRgX73Ci+YIwoPEeXT8BsM0HGCRJlxHfNsMZ+AcZDXxri1dI5H3GL3bgyo4JHTRyAsj3TQhv/zD0bf58hS5TAlhh95z6mOoHCyuNBixdxJe4EelBYHISU4a0LMniLCInohHoW7kGtFmGqwQfXq9VdALDf7O/WqwKsBWcvaPV2CKHz1HyqM03HKFLjDQnYP7htK2MkUxwWyT94
 Zx2X5jEP
 HMISNtjz9H7PBPw6eNcM4T1Z3UEKLI2RXPKAPeqdp8Majv4arbVNA0V3FT523v33RtycEf6SZKHRVp8Ru60XqL+Rs0N8F/ggxZA4HtmYNjTYJ+OQ3K6439hJsw0r19QRWQRz2RjjucFHAzbHs/J8Tf5S79Cf2aF3VanmdnhSjDNTR5Em0/3ZMI0t08FPb6s5Do8QnjvQM8ilN1eUpSKvAojoABDfje6BwkWqlTR1y3Px1kZEgxkGPBvaIJJqJDcxKpKNflTOi0opHPqHrizNwqCMxuk1JzxmRR7OWukDlDkvGPXBXzjiSWPlTXm9EajD6GmppPHmhxY5paYe99Rm/kbEwOoJHd38CbgV22jEhWxXqlLhUiHiAT7fx1vBtdkZz00/GI/TMyYP9bvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 4:43 PM, Gregory Price wrote:
> On Wed, Sep 30, 2026 at 03:26:17PM +0800, Li Zhe wrote:
>> Allow MPOL_F_NUMA_BALANCING for MPOL_WEIGHTED_INTERLEAVE.  As with
>> MPOL_BIND and MPOL_PREFERRED_MANY, keep migration constrained by the
>> policy nodemask: if the CPU's node is outside the nodemask, do not
>> migrate the folio there.
>>
> Why for WEIGHTED_INTERLEAVE and not INTERLEAVE as well?


Thanks for pointing this out.

I focused on MPOL_WEIGHTED_INTERLEAVE in v1 because the motivating use
case is to seed memory across tiers with a configurable ratio at
allocation time, and then let NUMA balancing/memory tiering adjust the
placement based on access patterns. With equal weights,
MPOL_WEIGHTED_INTERLEAVE can also cover the regular interleave
allocation pattern.

That said, I agree that MPOL_INTERLEAVE can be handled consistently as
well. Since this is still an explicit opt-in via MPOL_F_NUMA_BALANCING,
unless others see a reason to keep MPOL_INTERLEAVE out, I will extend
this in v2 to cover both MPOL_INTERLEAVE and MPOL_WEIGHTED_INTERLEAVE
with the same nodemask constraint.

Thanks,
Zhe

>
> Otherwise this seems reasonable.
>
> ~Gregory

