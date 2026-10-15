Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22927CCA460
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC516B008C; Thu, 15 Oct 2026 09:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3BA6B0092; Thu, 15 Oct 2026 09:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DAB76B0095; Thu, 15 Oct 2026 09:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 063166B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:49:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E7F116086C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:49:46 +0000 (UTC)
X-FDA: 85324993572.12.FC68B4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B3DE380011
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:49:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d861A3BS;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792072184;
	b=7JcsZck25Y40RMpg/Pago2hIzeTWFb5zFAxkrnhfkwSFz+XN2EsZfdDpDGqAT3kcEMeuJu
	ttxuOF80mR+4FJ/kF8AWyPM8UPrzbHDVeqKnSJyBgtnxwyXCa3vNXt9lqy9cEfvDWRONUb
	cx9bCaqPTz7xUXgINIBc4mgYniYF3Qk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d861A3BS;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792072184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VP0jF5bnf0g3p1HRHBbIMSTGCx+taYCBpLmJnYYBFYM=;
	b=zQfHzCSCGdt2Jpywx69fnbPIVSHcOePMmEHgby1UV4zeoaf8YMK5/M7SFpRep5IbuHD3DF
	mCYP9xeYIg+sTKP+1wUFCHcoR77odPYu/9QKQyF2TwyuX8WygztyGa581Zx5XtrBKuNwBn
	C1LLomdJPqsoqAVZB2yl6r0yUSWg8no=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A80A84166D;
	Thu, 15 Oct 2026 13:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6444F1F000C4;
	Thu, 15 Oct 2026 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072183;
	bh=VP0jF5bnf0g3p1HRHBbIMSTGCx+taYCBpLmJnYYBFYM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d861A3BS0NNc1P1ZuaLP81CBT0yRUV/MSIHHcvdDZV+dT+6mcQz8xzHjOWGCjrKj/
	 +Su2EAXRXRa0OPgm4DdRtvGpP68bzQQeOo8SY23c/1GGvCjHgOVvQapCfnqyJjF5OQ
	 Y9YuFfH+rFf1Krh1H8iZACaIiRQhkuFM1zfag8a7UHqYOw+H8JpOjtD/RRjjHlNxgE
	 PwsuxctdlD0cIFn5F3Bt2VPCIW6kxs6mh/656KSn49syyDwLR3nmksNR3RlfxExqn8
	 4lEbI3hGXBW8JisgrkrlA/gajaSBDI/jmSMRTo9TBPj8vfkbY9eWlhYd2PEivpAckz
	 6A6+I8MG3zhNw==
Message-ID: <10932a95-28c9-4b7a-9d57-95890bdaee51@kernel.org>
Date: Thu, 15 Oct 2026 15:49:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] cgroup/cpuset: use mems_allowed_seq when checking a
 policy nodemask
Content-Language: en-US
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com,
 ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, ziy@nvidia.com, david@kernel.org,
 mgorman@techsingularity.net
References: <20261014222456.2318284-1-gourry@gourry.net>
 <20261014222456.2318284-3-gourry@gourry.net>
 <8d611a0a-4ada-4536-875d-061492773e05@kernel.org>
 <atDUMtlM9Z8CPlRo@gourry-fedora-PF4VCD3F>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <atDUMtlM9Z8CPlRo@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4auc4soquutmp4prprmibh8zajwtffgz
X-Rspamd-Queue-Id: B3DE380011
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792072184-56279
X-HE-Meta: U2FsdGVkX1/zdlC85XlLlYNJeY7krhoF318KoSG/8LkARXW1wmtsO3t17ZR9Xqg2yoUHlRM2LDxH0pof80M3nESTKzjJC7vFSGd2dxgNBTJqm50UY3C8UCA03CY/aLpcMc84TAsSbEqNxaXExG0VBnuFRVl3jvarhHBgnRAAjKMqMi18hSgHBEKGLGxJUxGYwFX5HG/LqMgemb8G047nSuN90kKxBU/0lURVWLPXqkh17xh29DyFVIIq6N4mbf6jSipTpsryyrgjqOLtjgm8tTtzKQ0vlHbvLe9BSKcMc7JQgruroPSqc9zgADW/EVoQ5OmYUoxjZsh5yXweAUdEaznb3YY6ZCpH6sByeSA3Y9m7tYlQazb4fx513XfplqoBqrHNUxCANTiwu1R6ZssqAq5pjaeATSs39XVfnvrHIPWFXJFGmBMBEhhHUjDXL5556Tevfim6cZ/kaaPRV5ABSZbCbFrtwFgH1LpKveIkJJGhJw8cLflKAbsk9seXHpOwch6mp5TidCD6AMdm73Zco1jgEuVo2The3qljbV/BCSw372Ck1XJwnrh9tg37ah0mOsvkztaz1Nh3kTqj6d0Komh9zcHtRahKVCT/Wyf09TEtR6tHH1LV+K9HGInCTAYFfnBaIe8jXxJ1NHyTlfkXWotxJjWaUXPx6mvMoXIb8ykCJIJGVqtpOLihq++ZRfTNlchhM7LFun5+5cJ8RLj2PLYBWPWZQgHNJr32rDDFm2pn4V3Z2HhaJjwcNyxV+SEA1VoIRHQIi6n4RTvaqzdFJRbiWAQFyjTnwqOD/OHXWTRWgHkGeZSPhEnwOXP4hzx0eDQ6rkjzieIxw8NMo7f0hvaFxDvOoMZexqkFBS2mqZD6KyDzc5Rc3bw8Q+cEy+/yNA9yGVBboYqBd/X1hHZsdIrM1iD+c1Hw8fTFHbaFqPDpqfSGT20EE8/n/Sm3ij8XL+a9sQY9agPFOeRbSBd
 RqOsfRoc
 W6yP7sNDGT1IGKDSUADmYMjG6DkpJ4k5eQfMkAX91fL5P48+/MheI3HxED3REhZZecTf6k4pewgCyADedfFotfkYFXR5nANzm1CLusMTOb7eGOEzwkunO7y6cRW64DWZkiwJaF+CJIe81fHzzSuSAWuxfsi88Y+klg8gfK7Q2z9rfwAe4B8FfBqpyC3/nq3saCbW531f98faJ9HWFriTH9nHASgh1cEo5ygXTjrPb5FSsRsh47tU9daXYPIKXl9RL6KLbbJ4L5Lc0XHQL2jKfK7RINsyvw0GWoLPOKVnk9ck2I+kFX8kFMHRAGCL+uEOIj5R75vBTtzNugHEwJfk2er9z7izJFb0spZG57yDE21mQAfkbRlPomVhwdtW/ckMhqkhkmcyW2+r0dtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/26 15:38, Gregory Price wrote:
> On Thu, Oct 15, 2026 at 09:59:31AM +0200, Vlastimil Babka (SUSE) wrote:
>> On 10/15/26 00:24, Gregory Price (Meta) wrote:
>> > A cpuset update changes the task's mems_allowed and rebinds its
>> > mempolicy in separate steps under mems_allowed_seq, but the check
>> > reads both without it.  This can cause a spurious numa placement
>> > miss under some cpuset/mempolicy combinations.
>> > 
>> > A reader that loads one mask before the update and the other after
>> > it can see a spurious empty intersection and drop the nodemask.
>> > 
>> > For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the 
>> > cpuset moves to mems={1,2}, the policy is rebound to {1}.
>> > 
>> > The allocator can race and compare the old mems_allowed {0} against
>> > the new policy {1} - which will result in a dropped nodemask and a
>> > misplaced allocation on node 2.
>> 
>> > Simply retry the intersection until mems_allowed_seq is stable.
>> > 
>> > This covers the task policy, which is rebound under mems_allowed_seq.
>> > VMA policies are rebound afterwards by mpol_rebind_mm(), outside
>> > mems_allowed_seq, and are not covered by this change.
>> > 
>> > Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
>> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
>> 
>> Should the comment and/or code in check_retry_cpuset() be updated as well?
>> 
> 
> No I don't think so. We're checking different things.
> 
> The loop here makes sure nodemask and mems_allowed are stable when
> compared so we don't erroneously drop the nodemask on a race.
> 
> The cookie-check in check_retry_cpuset() determines whether the entire
> allocation should restart.  It runs after the nodemask would already
> have been dropped, so it can't catch this race.

Ah, right.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ~Gregory


