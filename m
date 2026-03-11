Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3682C112583A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676816B0005; Wed, 11 Mar 2026 10:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6384E6B0089; Wed, 11 Mar 2026 10:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516FD6B008A; Wed, 11 Mar 2026 10:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B61E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:34:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDBC38A6EA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:34:52 +0000 (UTC)
X-FDA: 84534028824.24.80784D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1198220003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:34:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GNWc6Wrg;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773239691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ep7eWlIcS2lapV6v1+Y7G0dBnSuV9bAH7dOFu+GFS/w=;
	b=1Z5VOrgvWWGC4m1S4uwKlJQeRbSpAsEJO47lw0XRwTGc2pw+J4mglgGJPhVZRqfdjNP/vh
	TAqa3tkzRB1357SK37gBz7U9fbKfsrEb27kApfNepxJnboLNz5MwpiCDiMTKglpvDcRkFI
	jc6ORESKnxJr8ZUEkokgZS3llSLP8ck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773239691; a=rsa-sha256;
	cv=none;
	b=TcPIQlcFeW1vvGuQNHzh2uxqtPbsaDb0a8prLDb/il0Ws2QZn83qvJEYuY2+9gPctWQ6vd
	203YG5WAOr7UHs9SaNg/m07HzeAL+9YDgu8RSIOJ/8pNUEX2ylzx1nwpRc3QFxKmNSPxQm
	SkRtyLja77IcQqEOE7HaeNQnmUCTkIM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GNWc6Wrg;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F287860054;
	Wed, 11 Mar 2026 14:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42ECC4CEF7;
	Wed, 11 Mar 2026 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773239684;
	bh=X/dCrbmPdm5e4cODLX0wObZlH+sFge4PTdWAE2xQjPg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GNWc6Wrg3OnhHHsadi9qxN5UbzWGD8rfKdA8eW+7Eq2VGfjoDNsGUjSzTROXisPKo
	 +vgKdsBKq0LJsUfl/2FKeSUmkCwYtGyDBFSHEH+zCcjZVgCpjDeCX8XjQVlFYN/qo7
	 5Sk9EHmv3TnmBSaGNZx/f9viDMV9B6gd9H710sZg4pJ4I79TC9DB4V9zUxXzfizB6T
	 WPHHvh68Iusq6qpZEFTBrs+f8T87AIpAfcNIIy5GWKYXIyvTWkZrR2xR2gXPUYpyub
	 +zN9iXHJ0ChytYly9Dc0b77lHAct9+knEOjZL0Z41iwoyztAu0ZTewkr1ojtPfkPes
	 PGyXHy3mai+Eg==
Message-ID: <6db14ad6-19d9-4808-9253-d17631b81113@kernel.org>
Date: Wed, 11 Mar 2026 15:34:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: migrate: transfer large_rmappable flag in
 folio_migrate_flags()
To: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 willy@infradead.org, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260311132342.3193160-1-usama.arif@linux.dev>
 <46edc7f1-f97e-4ff3-bf11-a56feb8e33b4@kernel.org>
 <1DA53E52-795E-4057-81F5-E39B85D7CF05@nvidia.com>
 <eb83276f-60f0-47f4-b164-998a2f11e817@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <eb83276f-60f0-47f4-b164-998a2f11e817@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kn9xb3e8h39wymxht1ixtt14rjsta79t
X-Rspam-User: 
X-Rspamd-Queue-Id: 1198220003
X-Rspamd-Server: rspam12
X-HE-Tag: 1773239690-684166
X-HE-Meta: U2FsdGVkX1/FC2p28s8Os6opkUH7ixCmg6Kp7BariDYOgFAO5MciOKNA+1PwiJsVJu5AWQATNgDdjzdD4w4SQABzcL7YHKL1MnVHEgvKnoq0LiIpd+ltuRmuHOX+fVHa1+ZfPuBv8HNPQxjbdIfbr255+XgK2zZgC0xjuCgcNfATQGZlZ6Auuyo3/EH7H15cCNT8ktA1ZB4DaDFaFxPWykT8/kcb3hmGzywLHhO0a7Y1WZCGrWbKnpmtY/Ty3+vZ+ePQ9LO2PprkfkPWDUwGSbsxCt9coLpUDuhsutL6pUk7PBkccdiWyK5WecegPkaqnZJKlHFNhRtqrike/B9cSQ0VzJEDFanhocRgCkJ0Oda/kzEvipjwOADAqRywTEKm/O4hgUHn/6f0GgkwWG6ddO5TY4mBs0G5E6SuNG5BGa8rrWuv7bIg8+SkTImdvjuLPgjqifZf24VQ8OIsxtaAKa+X0V3y3JIdB78WP6IpG0zRAJC2RFODtpFXjVY12z4w8EurD3iGSGSouaH42CQCHn3E7B6wzLhyIUy9AWWx4LBWPIaLW/V7XnNE+fXd2ecViGPo3T3b+Ihl6jYWTmiGlF9M7NrLzhBD1tcs8bZtM/qWKo22lEMpQA0I8kiYQUiul19ceEs0dDH+pFbzOV6F211s+FpSQwwDvVsGETAwIhE0x6ujTlrHsET7SBMR3D1Wa4MGxO1eQg2mqqowSROHzcu2cuICZWHp2pTqAEypwPmxH6bmV8pOshPMuUu0IR8jtCsLbGEK/7Dp9IIWNq0ck7F1xHbr28HmILMFbPhNvHIHptdnvTXgmGWp7Y1/6KdmbVlzTG30xmnZHb8fOzyOYFELnynApKdbQfMx91wV2EdLo3bYFZXBtCYzvtKcrotyAnhKbfr7p/7f+NSBgLV2slRXjMcum8hLKRSJw6JvTsiWNopfwe5LwNwFHuv3CEk6pP1aWf3IvQSPZKSDDcR
 HR95wyIH
 uYNOvMf8f7+fJRvLTEtPMtPIBBMpauBolmLDf9n49Q3GqrHEryNi/bN3DIYjoEOph+W3bQbFp9VaDiRlfbZP41xDzJwcTktRiWGRTpmPRYRzfMl8v6JoTe3QK9Cy2incS7Sxecl0h6YCTtM/gMmw0i+Sylm8DnqFqZbHr6eaDimJYll/6sXQJYJXjboNMvyRepr7eRwy5wMoFOXZYURc82icw7bdU1AK08j2X0pflR4vJ1gGHdNGznmBLcEKDNGXpfNaNjaQR96UdGDGQLztQhOEgtzB1gIAfOlMF4LF2CgL0r816WTRvtFgq4kgJURPDTTPuyK6S5xlTzDXYmJG/GFvu1IMZNHSmq85PY39O3B+0kXcsZYbotUsGgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 15:24, Usama Arif wrote:
> 
> 
> On 11/03/2026 16:38, Zi Yan wrote:
>> On 11 Mar 2026, at 9:33, David Hildenbrand (Arm) wrote:
>>
>>>
>>> compaction_alloc_noprof() does the page_rmappable_folio() at the end.
>>>
>>> I'd assume that all migration allocation functions must take care of that.
>>>
>>> It's a responsibility of the folio allocation code, not folio migration
>>> code.
>>
>> I agree. The migration allocation function needs to give a folio or other
>> types of page matching the original one. Do we want to turn this into
>> a WARN to make sure newfolio matches folio's large_rmappable state?
>>
> 
> hmm its done in compaction_alloc() and alloc_migration_target_by_mpol() but I
> dont see this being done in alloc_migration_target() and alloc_misplaced_dst_folio().

__folio_alloc_node() and friends should be calling
page_rmappable_folio(). See __folio_alloc_noprof().

> I think alloc_misplaced_dst_folio() is used by NUMA balancing and alloc_migration_target()
> by hotplug and memory failure?
> 
> I am not very familiar with migration code, so maybe I am missing where its being done
> in these paths?

Please double check. If a call is missing, we should fix it there.

-- 
Cheers,

David

