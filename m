Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FBDDC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129CA6B00DB; Mon, 21 Sep 2026 03:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA4C6B00DD; Mon, 21 Sep 2026 03:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B386B00E1; Mon, 21 Sep 2026 03:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8AEE6B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:28:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FC9CA057E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:28:30 +0000 (UTC)
X-FDA: 85236941580.19.0A301E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 75E0D1C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:28:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXvYRLNm;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789975708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9IeZ8YzYkEbqGx4JiJQgQ/74f9cdXZJykURU1L8RUeE=;
	b=NAV54oe28ot8wLVA3ixPjpxXPrwloUnnK77SUNXMmSYE2gAHO1qM0UfQBrtC4YGB106sSH
	1vPAq52lz/kyZqkeyyXY9KYfr51+6OQAUVlrqRObNk7C8163VZUEAIRZ2kPjoQmcGjdDuI
	UllBee/7rUV1BAl0o73jyes+mZEAm+g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXvYRLNm;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789975708;
	b=52Jmgqt6u/bKsZ8mkc5nu3ABoN5L8K1uQcSplTtbJEpgvNi3ibxRHzjfnvsIPEcd7BeA1W
	5WdzjhhqlT6IKC9UWtI/himwFjRg+81jNOItbom2p6wRVmvqb0iHsPMhLy9MWuPfsrb942
	myLwyCYVcOBai1U/I6WA0l5lc2qHTZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94FBC600C8;
	Mon, 21 Sep 2026 07:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2420B1F000FF;
	Mon, 21 Sep 2026 07:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789975707;
	bh=9IeZ8YzYkEbqGx4JiJQgQ/74f9cdXZJykURU1L8RUeE=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=CXvYRLNmRVX3qFBuglutTKJhv2OiJs+5sxXaUEVLENXNjA2NzHSFEPfJpdiIkavhM
	 gLP8nILXYxhZPjoWePoxZXQOw49GsB6euRP0lLxOhjk5wjkQxmiL9BII6tGHjZnobn
	 6iMQ/+Vnbo9ApGYARGNzC0onzYFYvZyJuvZ0+1EimMT5qct7n0s7ClJxG8L3q8MWT7
	 a6OrFc2z/lue81BbSlvzbjvJHEvdIfzRrT+eUuT3hgymENompzim8f7YQWeWXC3aUj
	 TiQhqCRgoZLdnx3u061WpTgsN6fpukNN+JVxoz31MA3CCdmx50hey0d7uTLhecS1f7
	 dCf3MRv1v/FZw==
Message-ID: <3e9ce58a-1316-48a0-9bab-715c70d117f6@kernel.org>
Date: Mon, 21 Sep 2026 09:28:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] MAINTAINERS: rework MEMORY MANAGEMENT - MEMORY POLICY
 AND MIGRATION
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Rakie Kim <rakie.kim@sk.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 75E0D1C0002
X-Stat-Signature: 4kysmg19igwm4rmaeqnaasf9em57t5hq
X-Rspam-User: 
X-HE-Tag: 1789975708-965181
X-HE-Meta: U2FsdGVkX19qCh1TEMk8QZXbSn0l1qD48aTN6Sg/dUOQO7EZDYvLCkmFTogsScb0OdJwMbBakje7nIE4s0gDFAqPGG9aSG5pP/EDZ1tjKXXtwfV6YPKckZhfBn1OtzRFNCbC/8DEhhFxOo06DU1RNXn8pnDqaCaC7+Gokjr1c4kNgfwXXzu0Pq2ELaSe1DX1tJCeY3LBp4aKQf5lQX6dhjcCAJtIDln+hkZB0jC+JzKTdtG6hYW4hB/x7mxNIdDE9+4VZQqHlCB8cB8HWTLkWOSDvmXMamryzA2J/omr6TyRwHVb0+l2VFcBlI9twEai0OtD1o2pnG/+7sRWwL17JvqFX6vDfg8a+A4RL318QtntFhYbMOYQ5VsOeo85VBsk41knQ4w2zHj5WsC9kjXByj5y8KBWF2aCdIFbtsYl0vGeqGm7wgWMDNAf8ydJIekUBifyt8Hd+nfIg00PQAdG1iiPUW+8jfTUgqcNX5csrckRaaspcSK46nZRZhbNg+Cuzy24GMp/34+gV8E2r6C5avF1oXNkKG54iQ1wBNlofjGC0oQLmcHykKUw2dcjbBSsDl8j9OepcXPOGA8wEzBZ0KalvNoJr1R+UV8sMUmTRrVkfkGKgh4pVBh8vUFKskRUhjr5HDqEyl2pOkx6lCYzmAUzPhJ8lyR5TbxygWdehv6TXoB38B+mVmLGFJVEmp0MVN130IWMKOXovsg2oiE2TJdsUje70fcYyP0hZQH3an7+AV0nvBSql6+M/MipICeD9vAWpTt555slrhViNL8frnHgsOhWI76xrunA4hZTUqIDb2zfe3ALjluhj6NSu1IkZbNudnAm+1iAj/843DooeVrwq09A3l0iKduBTwnslcUN1UxRPe0SSeCIFccXd0Iegp0Kb3HVUj+cSoiKfzKGxcLJ50v9XRWK6YJF0m2e08yHTUvoORMTE6lEOTMJWv2nBXoc7ejr+aSArHO/3As
 cak3LbKS
 znFSmRaf1weCfXS4TlBKBAkDMj+hkwvUvbXsV8/nu7M0bxUd9A5GZDDabmq6HEHJfU+UWDRGSrIEwzT3UltfLN0Vk8Dpy7rwc2jehw7oxjSg8Yj3vgc1omtcaT0R3TEEdY3y4PcwTpEW1hnI8H2mkES8RMoXrVABHRK8Sq+heZnk8muAQEMhl+r3tyMu2tUTECIijR8MKffbn/jj4TZxyk636nTnNAQuafZOowXdHAvUXi6UvARxAYckVQePp7nTmdI6E5LWXK8KC1AQCgi7JC1L2bqyBFYo8Jvc907YWyFuBpTGzJzJ71XXAkoHgE2PRij3jOY9DsT8kOxEFqN5j1eJR2FE3vb4UreR2Bhfi1/uqXzA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 18:34, David Hildenbrand (Arm) wrote:
> Let's rework MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION.
> 
> As I can use some maintenance help in that area, add Gregory as
> a new co-maintainer for the split out MEMORY MANAGEMENT - NUMA PLACEMENT
> section.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> David Hildenbrand (Arm) (3):
>       MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
>       MAINTAINERS: move memory tiering under MEMORY MANAGEMENT - NUMA PLACEMENT
>       MAINTAINERS: make Gregory a co-maintainer of MEMORY MANAGEMENT - NUMA PLACEMENT

Great, thanks David and Gregory!

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> 
>  MAINTAINERS | 68 ++++++++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 40 insertions(+), 28 deletions(-)
> 
> ---
> 
> base-commit: 5dd1818b15d98d4a20806cd00b1b40320b06004f
> 
> change-id: 20260918-maintainers-mempolicy-06bf34b59ec3
> 
> --
> 
> Cheers,
> 
> David
> 


