Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D470C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 12:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 824176B007B; Wed,  5 Aug 2026 08:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3C46B0088; Wed,  5 Aug 2026 08:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A446B008A; Wed,  5 Aug 2026 08:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC2A6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:26:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2C804045E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:26:29 +0000 (UTC)
X-FDA: 85067138898.27.40EBCC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 18EE8A0017
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:26:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dg6zYRc/";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785932788;
	b=rL3ckcnYRBthark1OW9r0ELZZxQE6u6y/KvZ0qo/RukxkIDnKIkaEJMrww7cznyJT/V7lR
	b1ebYu9RVia7CsLCG4bMgnrHml/ry8uGp4MwlAz2qgUppuvYLciy7o9lPTBfRSJc+XoJ4a
	+p0EvUwqdzCzlet4SjBje440o806GE4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dg6zYRc/";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785932788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IlmD8FVPU9Qx/uX6OcnYNun+6FlLqKRo+qT2MOzGSIU=;
	b=bdyN3tVXejDWbIhAiwIvDq5VOCmt76IwM9su+XdoRMC1JJzYzhA3tNw3SSuSOUqpZXw0/j
	8d83YbaA8yBiWuJl+6yhTDLlULlxSFeSKek2DntRU088sLH76VY3D1Hs5QwY7M4Z4DPPDJ
	7vm4l3MOonLDIkdtxlXatW75DsSESfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DB146011F;
	Wed,  5 Aug 2026 12:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB18C1F000E9;
	Wed,  5 Aug 2026 12:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785932787;
	bh=IlmD8FVPU9Qx/uX6OcnYNun+6FlLqKRo+qT2MOzGSIU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Dg6zYRc/F+HXAaWcCH3YDVw+oVkVy5xQ843u9Mg06P1nQWAODPPiN69tCAOSUMWFx
	 xNX8IwFsVAAuXKL/HgvcaLVCd+mb08xFxHXEBujJsfJB3GcM2/b39+TlflP1VI8wZg
	 Oun4Re1ly9m4dFRtaERiX8xfVxv2HIWSxgF/+o3h7S53fXvv3T/nMTL94ZiitMDXwP
	 mF5j3ByA3FNuZOUj3lhyYvzai1k9zQHyd0tOB+cYpXrEfbvYeumkVc4ogzE8EsI7qZ
	 qoB/R+7NdsLygrWoKlg5rInGhPPscapYMQLQfRXsCXkk7ZDBj0lXpJCtN0vyRNmSWS
	 OmNJXco9KW1qA==
Message-ID: <6bb83027-07fb-4152-8edd-f349e6fbcc42@kernel.org>
Date: Wed, 5 Aug 2026 14:26:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/ksm: avoid missing ksmd wakeups in ksm_enter
To: Longlong Xia <xialonglong2025@163.com>, akpm@linux-foundation.org
Cc: xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 hugh.dickins@tiscali.co.uk, ieidus@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
References: <20260803152115.3479919-1-xialonglong2025@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260803152115.3479919-1-xialonglong2025@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 18EE8A0017
X-Stat-Signature: e6g5t91cc6pjbrxiw4yqciofrj5sme6s
X-Rspam-User: 
X-HE-Tag: 1785932787-995503
X-HE-Meta: U2FsdGVkX1+u1fssQBQedoaVL9gmmP4ZT88MsasjEyWaDC6duUibQipO25CenZqxZV59rvc10ngzv0tY1hiL9mMgUDwBGmHbEZkKj91Pcxhc+/eTzhJTmucC8S8GomZIMZ+YooQkAgLz1QiMmGMPge+Lq63ugkku4n42K+wiTfvTiiBcJMNY5tDcQwkvP25mktOaTjrQ2WKmqJboUv99FpG4l/EhYCN+k3an4Fi0yYX8s+DqlGky14fb4LQHnbpXnO6EADBOvmxaCWw+DyOxQpaD8ujVjhXqTM1WyOCNTV+VYxJZ1xkgfpNhrJ/Yu6SMlHqmTYO3twp+ZOFT70Fi0JJdlAubJGngQj9TbTtFib1fIZ8nto8i60hT5vlQxtfmr1rd25MftmPjGPTjdHKKQKKNthf9sM0nbgK2tI3OQGidnQhHTk5SQlPd2hUx+3RNbcN9/e5aEUi9a6z59TgNAZsKeELMYxU4L3ClnlljCYQScoBL2+HP9M0WtQgpsE16iTnPTMxBEwU/dQ0cPdGFKWW/quvPnlFVzOtZOe0VqJUC5CbQm1O70dyUSMTgIZBvf9XGUBfl8hFmMIw4r1xQDvz9PU52Vk+cRs7t7rLxfml+Eofrpa/F/tL8PFwHtwrdf8MKV+NxKCJQM73y21NJRVJwFIwiAFw33V8CmKhLCoTwL5C3fTuLni3Lq1KivTl1N2b8vaS5WygXGiE6i9at8tH+TlfdSQYMcPAsiPjop7f4XnDYmCa2k5pcBXBwYnQCyLKFvo3WDQsFO8uOruPXy+MhTUyvQAeDwYxBJsrnn49SK7mEndkWP4k4/o4ErOIZDPj/avk6+cA8USSp87E3obfOJOL4FgFyr53Q1Q5TSPOp46PPBdG1TYHWvudkx/XFCjZBDbeElHRIcgonj5yU9p/bc1gAHAdElYuf8Onmc8OBphmyGFhnNbCssZcaiCHXEcP+XSX6XPLH7WkbcXY
 ELyfovHu
 FhVcvgXkepVk/QPu9F7Dlwg4IPzgNsbOUK895/V3tRre6y4ShzLt1m8qFDK9KisZKAn6vJ49sNlZMHKATPOAK8bLnk1QFsU/dK2KadFnPmQ2gSxoZBDbVkur2VkUWQX0tOElU2f+M4/TXB1iPPjm0cFUoEyKaTfSylnUGaEsicn81Mo4siwtmrKT3Ic7avdoq9yQQNqACURmMw/53xFiHaME5rF5AG3ELS/Aial7GxvrBKK9oUES4zUOuS24PT/sVLjYt5CPWlxuoZRq7355/fIvGyMvlUgH/GPt1PRNrLDMc1Xwe6ib57IhktktVSHvHARXHxTMEAdtG5bQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 17:21, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> __ksm_enter() decides whether ksmd needs a wakeup by checking if the
> mm slot list is empty before inserting the new slot.
> 
> The empty check is currently outside ksm_mmlist_lock.  Another CPU can
> remove the last slot and let ksmd go back to sleep after the unlocked
> check, while this CPU inserts a new slot and skips the wakeup based on
> the stale result.
> 
> Take ksm_mmlist_lock before checking the list so the empty-to-nonempty
> transition and the insertion are observed as one critical section.
> 
> Fixes: 6e15838425ac ("ksm: keep quiet while list empty")
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  mm/ksm.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..3f2f4707ca9e 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3019,7 +3019,7 @@ int __ksm_enter(struct mm_struct *mm)
>  {
>  	struct ksm_mm_slot *mm_slot;
>  	struct mm_slot *slot;
> -	int needs_wakeup;
> +	bool needs_wakeup;

Unrelated change that should not be included here.

>  
>  	mm_slot = mm_slot_alloc(mm_slot_cache);
>  	if (!mm_slot)
> @@ -3027,10 +3027,9 @@ int __ksm_enter(struct mm_struct *mm)
>  
>  	slot = &mm_slot->slot;
>  
> +	spin_lock(&ksm_mmlist_lock);
>  	/* Check ksm_run too?  Would need tighter locking */
>  	needs_wakeup = list_empty(&ksm_mm_head.slot.mm_node);
> -
> -	spin_lock(&ksm_mmlist_lock);
>  	mm_slot_insert(mm_slots_hash, mm, slot);
>  	/*
>  	 * When KSM_RUN_MERGE (or KSM_RUN_STOP),


Makes sense to me. With the above variable change removed:

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

