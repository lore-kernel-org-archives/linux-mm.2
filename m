Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79663FD707C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6C16B0005; Tue, 17 Mar 2026 07:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9E576B0088; Tue, 17 Mar 2026 07:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB136B0089; Tue, 17 Mar 2026 07:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AA796B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:10:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 226E41A0694
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:10:49 +0000 (UTC)
X-FDA: 84555287418.30.B02F380
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5432B40014
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:10:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s6pNrlBc;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773745847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iS7Db72BckJr5I0bq9acKGtWsDCOwZ0W1HIRbbkvfk=;
	b=LiBzVYGfXgTnFR4tog3RUKEDYT2gpOYz/4b08T9fOhqsrzrAAdJDdp4n8OPvDpLKuozEmU
	mGIoSHa6pgJkrJYMn6f65SevlH6IgdfsG09UtmDPVdcISpymPFjuz574i0xwepLVSZIV75
	ZZiHuxS3GfNGd3y4wSQ5FJNZUUOWIMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773745847; a=rsa-sha256;
	cv=none;
	b=DPme1fduSh4QQSp2+p9TTIci8gGZuYYd6Ubg9d4VrR69jp+578YTjMu4sQ0/djiyLX97BT
	wizIf9OSsgpFBGn9dCxDDiU0Bgbxg0EkcZfuG7QZIc3Z7UY6NGSjx+dHeRmrO7bdbu/eDH
	HsUDc4rxjKqZZdXw1mWrrKg5TlpgJ6E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s6pNrlBc;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F3E843814;
	Tue, 17 Mar 2026 11:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086A6C19425;
	Tue, 17 Mar 2026 11:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745846;
	bh=h+iIk4sKTg71YTACb73pQNi/1+OjRYcdvjHoMwjgIaY=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=s6pNrlBct8GJbRVqxmGYx17KCxR0NHWfkJJWindVrjfCwJE1vpER1+XNeY9qgu8W/
	 6QCuUvoCkST7h2tb1pn93TlZNhZuM2BCOdpcXIXRWopGwcJZ6ZeWQrS1FqyX1ABljP
	 oxp2LuSVjUOE/P/St3jv3qXXAGgOu7dQlaTSicNG1J7LTAIqvB6gFDw+/GRCNoesbS
	 zW/QyvYYbbjB05GlcSDOjAJK30QJILKDoP9QDBF8VUOZfxdC9qUJ7sxs7XutOV9oVQ
	 13aZwnoWCaG+8XsMbNG8r2ykyqmePvMWePzAUvwWlMPy2K59aUEiWGWdN/35eyOTC9
	 WQjgj7oorP6FA==
Message-ID: <48ad9d08-157b-426f-86f4-69793f3537fc@kernel.org>
Date: Tue, 17 Mar 2026 12:10:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Content-Language: en-US
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
 cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
 gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
 <343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
 <874imkpba1.fsf@DESKTOP-5N7EMDA>
 <cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
 <60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
 <c4e5cc3c-5daa-404e-8c55-cface8aa969d@linux.dev>
 <87sea0o55p.fsf@DESKTOP-5N7EMDA>
 <0d66401f-9874-4047-971b-632723b0b7ee@linux.dev>
 <87a4w7x8d0.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <87a4w7x8d0.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5432B40014
X-Stat-Signature: og7c87wthotuhdkkrbd1mtkurhoqafbh
X-HE-Tag: 1773745847-376357
X-HE-Meta: U2FsdGVkX1804hSmbHw6Sh73wJ7SENXW8jT9DVSBn1hUXB8YpYpT1T/qG2OmLMskL0OXJkviZtuEnhcLkD637Naaw46RdBVXdlSts1aoKnUU/Ci8kq0KCdB6jTCiby2A7F9rLg9albvsQIBlplW+2OW5KuZk/rOryhGi8089OH5rPRoliUmniLHU3VSmz4uBs5uOIIMmX2RCMCKLz2D3deHnh7OgCFYsP4gF9FZVSkM5q+AQn+yW5yJRSXHDKWaPvSXm0GrvrbqzmEo7ip81byL+Tlzs9INEI9qGokBsYfswypIQNVeaHLHfGNSe0MD0MXwxfy5EjW24rkqLhNusPB8YEM5UXAJA0sgpKenPr/3HSLTuzyeFF7fM0tCMO+H3ZUohnAUysw024I8JWAY+ErBXftVdunHY28E1dnYCFbGw5JImODBIw5cOP0efFNydUcA+7xZb0oFsVYPwZHTpEtJh34Pg4rEGSf91hpR+BlKZTXXuL6xL5vnpedSMHlkLvg5eivbqhDtV6CfwGchy7jGugwGGuLP/oXjxVNJYVhvovEM3yU/D5/EhudCBMuo8slDihl8oTUUoSV3G11AF1zdSZibk7Jys7HBPc3snw68NnVRw6JqWSqAk4GLm1ZzCkksolW84zmGMCG/+WRuvwVyjEc0OHPBZYsT0a6paeMLx0D0Brv2rG6rZZxATwV9OWE/Q/gKj6GkQou+5qeIC30xj4v6S3aF5QC8l9spQwkg78cy0ArP9eOlYlocQ6dptHOX/4sSa2COXeQba+0TFvC9QU9gh1XprYV+vh7OY+fTZg3khZs3UWj/yKeNe46ab/V8/w6XllzGLQlSIiR2gH5ruhQ4UtR+k5hx74Uw8OnGCWYj2N+riQIUWlHyGz4kLSEPx8Za0fl+lAeKhJWHSHZJEpI4XMigwdqn4Cr27vI8ZRc3O4VECZeij72Dj5GvIPy0FJG4Em39W1y5tkuf
 Nb2oCiuA
 zUjn9oezufuzlrw5ovC1+tixTjC/kwZX2JnAm2gzwWnZpZb1CxZyMmek1H6wQNLCtHjWXM1zWs8HHEGYZgTO036t4wlqD9BuE8xA/+ECKQatyv5FHEu+moI9Ly7NF7dkYpht2VVAzUGe1zouKI/GyNCVPY/3Ix+yHeZSxtLrdC1yRCD3NBJfn4DWSsPjDQDq3ASfcGkSph7OnX/kmOYNdeqf1luD3U0iyewSfWvEnkqrzFr8SPGcJ5xg/U497T77AUYuKqRmoJPvNPzcPAMqbnMCFjFZ10Lfkl/zBid4uRLgCYpG+sy5WfHcfUaIuIv09oH8f8Dlx7DwAGSlt2/vEAOiPMQo18Q7XsOAo0gdMlenZd9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 07:44, Huang, Ying wrote:
> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
> 
>>>>
>>>> It's an interesting thought. Looking into these existing counters more,
>>>> the in-kernel direct node allocations, which don't fall under any
>>>> mempolicy, are also included in these stats. One good example might be
>>>> include/linux/skbuff.h, where __dev_alloc_pages() calls
>>>> alloc_pages_node_noprof(NUMA_NO_NODE, ...) which eventually reaches
>>>> zone_statistics() and increments the stats.
>>> IIUC, the default memory policy is used here, that is, MPOL_LOCAL.
>>
>> I'm not seeing that. zone_statistics() is eventually reached.
>> alloc_pages_mpol() is not.
> 
> Yes.  The page isn't allocated through alloc_pages_mpol().  For example,
> if we want to allocate pages for the kernel instead of user space
> applications.  However, IMHO, the equivalent memory policy is
> MPOL_LOCAL, that is, allocate from local node firstly, then fallback to
> other nodes.  I don't think that alloc_pages_mpol() is so special.

Agree, it's equivalent to MPOL_LOCAL.

> ---
> Best Regards,
> Huang, Ying


