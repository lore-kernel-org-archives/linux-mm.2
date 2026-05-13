Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC7CCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 00:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AACC96B0005; Tue, 12 May 2026 20:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DD66B008A; Tue, 12 May 2026 20:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973E66B008C; Tue, 12 May 2026 20:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8782C6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:56:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 189CEA05F6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:56:50 +0000 (UTC)
X-FDA: 84760581780.13.C36B012
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf23.hostedemail.com (Postfix) with ESMTP id C9E03140005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:56:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=omqfniWS;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778633808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mM0vO/AvK2Bp1hK4zVKQ38RPnN+CVga1M/wtwQNY/64=;
	b=IbrWr+QNBrWs1U2E8J6s1HnLSP9G1RTdLyNAd6dYq6Z/tFk8yZGrLIJK9dRs3TGlbVmrpo
	+e4c2tVJIZtCxAIWTk22KgWNfG4aKNNHyfRrmqsu0UJlTGaymRZGHgrhr+k6iidoMvJ4l0
	9xRQj1AC7NfG+waL0DQBlGJtEtSzT7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778633808; a=rsa-sha256;
	cv=none;
	b=g8MARBpMPSSPpe/LxFabIHiSuzJnc1lpB+U85v/583HaordpGdnkc+yozgAzKBVr1XjnAH
	0cd2FK7MKt/mZZQX/FWC+SP5ELASpro/uA37hXz67Fm3+MHUo92czvZ3FCzEx8knaY/dDL
	4gUbe+7ns3tPbYqm3V3wK1maPq3l9Jo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=omqfniWS;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778633803; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mM0vO/AvK2Bp1hK4zVKQ38RPnN+CVga1M/wtwQNY/64=;
	b=omqfniWS/xg/KkVZSr4XyUrQytAk7jD8JLI+EuqD4qWtwbckB+njzUNBIPppP9ktulU89biRT5K2WduUVzFazISh9HD6NLTiKzYiNjt9QybJsJEVm/ypN/2XEqA1D1YaMoM3opQsWnGdhrFp8iO02p+yUgo7zA1VdcSCxikl/X8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X2rsF.1_1778633801;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2rsF.1_1778633801 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 13 May 2026 08:56:41 +0800
Message-ID: <a65ae193-06ac-4526-ae9f-770fc3de3dca@linux.alibaba.com>
Date: Wed, 13 May 2026 08:56:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag
 due to allocation failure order
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Xin Hao <xhao@linux.alibaba.com>
Cc: Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Andrew Morton <akpm@linux-foudation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260511025408.54035-1-ye.liu@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260511025408.54035-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C9E03140005
X-Stat-Signature: gpija4myuuf7ap8i4mizzq9p35grim8i
X-Rspam-User: 
X-HE-Tag: 1778633806-292306
X-HE-Meta: U2FsdGVkX185c+vcbTP2LNrHqhNrhoP1pHrxj/xnzP1nyHjZVRhOffERQVjSpjxPnZDQJzccnfkYDaWOlW6BMINZDaajvh0WQsH5DruSnKaedMTocorb5yv0Ji6N2qiXSD72gTSWEpPzp4vJAoT8bWhuzFCu075aO3oIXq4tOpEvMwUp8mpuP3YqgvQfPxp73TaxpzWN9dOF2gT8toS0O+fXDdlO32OfUulXudLA2nDlSJ/hHrjYCb86vj2aRfhoWJEakpaV4gpJVttWOs3miU1fVlL6AxzB8zNqoQ8VzYo90QlYDKTme20Jn7DbLjDiJx8Hmq8zTYdd8u/fEL8TpmnwNxOx0AzhLZFNW0ZIDE1qboxa461pkER+t/fUsk9tlAA8+A5OE/GcfccvygygAH5ggyhe3mMkwPjq7fZEnop1Km+dHFl9zUSfpyW4oQhqhBwlt203OMp7N4ABcm1P1qt/VyH//J6u6gfFDame5ezX2xffer7YTQivb1wg4zuw0KX82UrwhaeX+sKVa841ogkEos9G//3GmePRfcklxmOgWsFScJ1wEmg0zdej44F8Qbn0tHiq87cwhr1ziW8KO3i0xGO6Qk3rYkHorkty/p7w5Oa0hmd0XXNPlILvHsMGLAMSNfKotRdEki8Ty9zDc+2vw+1GpO5+mv+XmH3c19zy0Crx0qh2DrvS0kZZVtr6B9QW5hq81uJM8o5OUZOgIXs1LEthljOGGYmDiGNRsWSq8tpi5qvG4x3f3yh6mOPYKwqhKQvY7Ud2Gj2Ey4+XISispMQBp0kWNVnBNBozq5g8fKU8sOGFAdJXv8Q7KDaG1z0t1/SXZz+swPlKi0Z/dQHYYdHSmAk16VPQRiEXeGi0/Tx2+Cp9Hbj1CfK0pBLee/ZpWXSdfvKrFyrZmh3P3rBbsEYqELr4yDRm6LLRXeL+oLfQFje1ad7AmOjLeHV3Ddt8pTmRFnBhfe+2fOa
 o6p2A8PA
 7xBlnd4B3IPQIcL8vHwFnOX0czl1xKaWcJ4TA7vPPXQmdAvIJFFLmwGh9XyBXoqlbi8ozjURcgGd0mbzwEMI9lDVHrWBRT5C2dzM7q7nkQ6GakzVxs3lJF3axr6rYfoJoB1h0f3MAkbNw5waFFYWP3ibM7wWUlwFH9Hbt06JulYkuh5F7pJDUOHONo+ge3H5vMpcvSlrGo9/TEd07xEr18lzLtlpBhAEwv/G2emoa3+AZ3NsnXY+VjPM0SAMd6jHpfZ2rjFq5AloQXAO7tC0OS70X0RACUv0cesMVoohA18XF6XM5aKKhm9J0UF6UB4OExjBB7oiV8Ldvjrzpip2P3wo/S/BbGc8d7S+gDqMPEanQmLHwEz17Z0mWFGE0OS8cszJtqzGdDLZkbE8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/11/26 10:54 AM, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
> corresponding mm_slot.  If mm_slot_alloc() fails, the function
> returns with the flag set but without inserting the mm into the
> khugepaged tracking structures, leaving the mm in an inconsistent
> state where future registration attempts are skipped.
> 
> Fix this by reordering: allocate the mm_slot first, then check and
> set the flag.  If the flag is already set, free the allocated slot
> and return.  This ensures the flag is only set when the mm is
> successfully registered in the khugepaged tracking structures.
> 
> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for "struct mm_slot"")
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

