Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D329C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B156B00CC; Wed, 15 Jul 2026 09:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4106B00CD; Wed, 15 Jul 2026 09:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E26E6B00CE; Wed, 15 Jul 2026 09:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2586A6B00CC
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:34:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EF7BA0040
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:17:24 +0000 (UTC)
X-FDA: 84991062408.20.FB5CF25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4E47B1C0012
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:17:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXj63vxV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784121442;
	b=hU9OREwMhK3cxDYogWBeMmv3Z2+4284/vgj3WepBOkMEz0UV71TIWqM5nw1O1rq7yQf5xp
	SFmGhxAoGJAG8civaTQPSObNoJ9knhKiOaCOaNybPW5tTsXaWXlRsaS0eh4+nHg7pgcT6s
	nH8nrkkOD71nJHnKmxh9q88DWywCeLo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXj63vxV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784121442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3NpSDdrD74Rmm6OzOcpLGZePIVlXYXOS4SHnZvujvI=;
	b=P9Wor54qi+py6hVRy+Q8wbm5ID9ZYjB9h+7+y2pUd7f1gGfhl9+XOVPaSLWVhHgOdsQU2v
	1DuB1LvMVMip4bUhexQ2AztuKvthFN7LdAfCTwWi8cXCMBdPsDs6y3B6T+LYyqeRTU6t5J
	RDsdEuIrTa2vQ5FOfElTpmQ8xaqc4DU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0A5D61383;
	Wed, 15 Jul 2026 13:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308011F000E9;
	Wed, 15 Jul 2026 13:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784121441;
	bh=I3NpSDdrD74Rmm6OzOcpLGZePIVlXYXOS4SHnZvujvI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kXj63vxVzVN+062x+68aHw1yv1WyA+kbN58EYIjSJ3eAWP/svJzyLPp1GpKxY6R/B
	 3Xcpv01m/f5Gr5dR8Kmj813DjgpkDm+JMQzZn0TrgiSkIwu0DQP/4DPObynawESRby
	 TEjBwwbfGdJRwXpFeMNWhWC1bdFrjrBggoS+4Zge4oWAZEsbATksRFO/nOVPqEq6KO
	 3+vYaAzs+aiuPowiEps2wcImrxF2usgxcOfUj42iF6gkkxWWKsbd8K6MjGJyWah2hd
	 ytbQgCGrNJVQshs/3sFBdVMnts+UmYd4PiCCIsxFDHwDIXdD/JFhfL73LQZgqNPXfc
	 PBiJimcYaYVrg==
Message-ID: <d466b5bf-b423-497a-bd2a-affff25feaa4@kernel.org>
Date: Wed, 15 Jul 2026 15:17:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] mm/page_alloc: fixup alloc_pages_nolock_noprof()
 comment
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 sashiko-bot@kernel.org
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-3-fc4d246f705d@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260715-spin-trylock-followup-v3-3-fc4d246f705d@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4E47B1C0012
X-Rspam-User: 
X-Stat-Signature: rtaia9ai34ojr5xoscyc6i8q67r77ume
X-Rspamd-Server: rspam03
X-HE-Tag: 1784121442-440689
X-HE-Meta: U2FsdGVkX1+4evu9m4/G45neqZPgXJZFVTtRzMe/ER8Go47zm1/3ryozxTj3vBhl+i2NhPk1pQalctxeDfZOVvNwJbsvc1IK+0akGvT6hfNxiwGKN+GP8oW/ny7EPPj4vJhMapxB52bZay1KE0R5fbsN0I75jG+ANziVbQV9g+gG9wbx0KV2flnHqO9NaSgthxRRvzBfmPqAPtJzmRbZ4EEbsbMmVVXcR/COfI+FyhRB8SONrjiqSAjNDDGskAOJHU8WKWPqUWW8ImDixB+eznV1mUsfDbFEHIOZSmBDoAb+PXxG1H8Q6pXPJVd8pgh3kAbEmiaKYDM7WqGCtyaliC9ekgglMA9QH24Qt5M4dHfcAk0VEcTDv5OHaDyuhS1nnhEw4Zy7pZvtkL392iiVAuVY8qRvRC7MLK+extl8Ru2K0O8EF0GVeTwOW13Lrq5xRuwaFWdIpKce5fI8ZXqQdOd91bOLrN2IlORPp/6M7flUkh2dBXJpbb9rNQBNWE2uVeqJr8SGh2xAUDYPmHcBlcqGuZWhEhdNCxjIMgcYgOb9STPburCc3zwEOj3sWbh7ihpnHwFkzhEdYMAAhpWL/vLyBdPnBTO+2904UGOmUDQPiyx9K0ZR+7Qa7n3LHm3+ETmPi03O0+2YoLtOei9kQJEjNZQM4Y6ZevrMamViX5bMWK9q7aKsULEsWcEGPzsqnWybkjdTipCUQg65pqV445PIED2DIiFYyPmvgUxyhgLN+6HXa/oevfszaNM+4muG5gW/7X/HaTVA7ytmVEsZitaCj8Qzt+myQIMVDdPWB5qHs4m6DAPsValR4oIR7uwl9NLpFw/gpO1CJnfzwn5rOWLxcO35jvwWsXxpGyH7EcAHVP+7WGA2GwY2Q1O7X+8loExNujcEVx7XameJPPScLLbAxKs4Mgb3cyzXoVjuQaGP5NgFbdotXVPf66V8MRh3dgx1AnZ1Qt/YAtZPEZ4
 E55wU2xB
 GwTuSsd4jc3f/DPiwSEoqGDkIap6dMIpaZMJbeoi5hgckTBLOlLfBtGzJhZxQuhmHtYXCu5ZP75tIZuPkCOStHew8OiErPLMbdHnhtPB8XsGiUXpp87ZPh8KCBb3Xq1o2SI9kWRZTBkLvVoWxBzLf9oKD8YXqw0ZTa9a0XxyA8sbB6Y21vSx0S3fl+mIfUZWpsiZpYNhy2BRCDZpzE1UnBuJ4H5aPKFLgEYECyDEkeY7ZcwljBHhkPm56HU6F7kqb8oAKYBMYJBM4XgpkLAIWxl9SXDeduoArK2Pj3N2S9fj6uGa9jPM5sD4ycQuVHxZA7AXFEvr1HejXL0whNaUyIrpwhNclBOJE8cQs5nCqM0rnG8KCjJQKxxtTaCxV8bBjViW/G5yIdhr+8GNIbqGFZmEgOMShphx8vbTbDAxDvh4JegJgaq5tu6rcPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 13:03, Brendan Jackman wrote:
> Update the comment to reflect the recent change to allow flags in
> gfp_nolock.
> 
> Reported-by: sashiko-bot@kernel.org
> Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3%40google.com?part=6
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c2da85e69a0f8..25a83a57aab66 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7983,7 +7983,8 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
>  }
>  /**
>   * alloc_pages_nolock - opportunistic reentrant allocation from any context
> - * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
> + * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, plus some flags that get set
> + *             internally regardless (see %gfp_nolock) are allowed.
>   * @nid: node to allocate from
>   * @order: allocation order size
>   *
> 


