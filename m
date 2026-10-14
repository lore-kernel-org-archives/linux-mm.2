Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545F1CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39AC76B0098; Wed, 14 Oct 2026 10:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3248F6B0099; Wed, 14 Oct 2026 10:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213896B009B; Wed, 14 Oct 2026 10:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2D056B0098
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:51:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B971405A4
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:51:31 +0000 (UTC)
X-FDA: 85321520382.17.4838453
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C4B1940007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:51:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SXhY6GQm;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791989489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sbwm0kYIICcSUmwlborhldmup0bfDzLGUcDOPU7O94I=;
	b=Ewf8n88wpBLMX74dVetPps/t62UL+C58YQcdYTDa14b92YGX/sJc+eqza1Crrz7Qer1xho
	+tq+gIyW5P6LoDmze8QzgLCiTqYxLuNE8sm5ACnx+q4keSnKV4YJE3OCm7/uHikIGQAbNW
	fStWiGbcWoG61diO6LgngP0TFqoKEkA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791989489;
	b=JDFQDGv0uQd54xcuI2f9gqhehM8XT2/cxl0wEp4RC2Sl5Px9tO0/79ducYwrs/43of9Vtf
	jnvAiElRAMAlNDja7eyTEI2AfsO/Gr98CfF3bDPMAPuI+tMsz5OmzDYoMhIh8hqAE0EPqp
	PGfeEogqPb78pL4a1HeEpw/HG+fASik=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SXhY6GQm;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E18360229;
	Wed, 14 Oct 2026 14:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B66B1F000C4;
	Wed, 14 Oct 2026 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791989488;
	bh=Sbwm0kYIICcSUmwlborhldmup0bfDzLGUcDOPU7O94I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SXhY6GQmLweh7DjlvPMxA2dTktV5lkYnXiUk3tMnz8oSC987FLw4a0aDlv8ibbI+O
	 LmKs/zZJ0VLMz5v2QwPJZ6nsrtDLkcaa1VRnPLCw9VqY8XwbPAe419chlY6LwJzV+w
	 X8VkiclUEYqMiUKu/9gvrUuYqnhzKQzy1Bxf7cyL1I0PzA4CPooT1Lc3T7RRLnPJah
	 VnnOYE8uQwe7shBI2ztZRizfWah0o8mz2o999ScqgnkciSfyjlLEe06WZJ23v8WmjD
	 EPvpL/ik+KgpdOZ3uPm7GFOnsej2jA7xLYtCx29gDZNlfO0RzoO//6ruH2jdbyyaPK
	 kxoeAqOLA7pYQ==
Date: Wed, 14 Oct 2026 15:51:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Lokesh Gidra <lokeshgidra@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: only allocate anon_vma in CoW mappings
Message-ID: <as99gyi-NUprRK6e@gremlin>
References: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
X-Rspamd-Queue-Id: C4B1940007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xzk7qkt5f5ggosure79sqoii1gctaaow
X-HE-Tag: 1791989489-807384
X-HE-Meta: U2FsdGVkX1+MdDO26Pc6XRpGDsEJF8TzqTYu5ZivtjLPcYA1eBZiqysrzQoaqiaBSS2vheCVXd3eOViLYPWSFScxnfHBvUxXvLS5CyQ5f9WOhDo2ie8sexuU9aVX1kiTWBSZ7a3T2OznPyp8xNMET7ZA8oyJUNwhYNOxCwjH/wMei42DMbSUGc1qXDiFUkspjx9Q5KJHnYbeGRgATap5u4npOyupcfzrq8mJiBUiu/WiJtvDOfKQNhh0CvaToJht4N2o3YicKHZHuBVl3tk+BWO/QeodU/Ofy4z6EHioKpLfiiYIBHRHtneRI+TgXdIe81YoKja1R1OgSnXkHNJMnKbNYudHYyhf3Z41OROCo9p21Z5KJ6F8L0JOmZLy9sOmtXcoPxIxEqZdcia6ddlxcHDDVNbcj6lhu7hBspmZFAriIgmAymKGcs2dQiVwHSlb547nnkJKKH3fGE9XBms7myCKY1vTuwAsadRwK9LXYgRAmrpoNB93ji9sSu3U00gBdjERZeKMsKpTEEmlP2oDOQcsTIlfL2Xf1pvreRROepaguh7QjxOWbz0iibOz/01RlQvqGbnPR4B1AFwYPd2oSUoOE5yFFkhRLTkPrJJlrG6eEXVuwoTfXos729xdXEE+8jJInNyXzqv0Lssj4vlP85SqFNCS5VWDYRHCFfJ7Pyq9abJRzn0KYgAEjsI0vJEBbTYkgP0FbjKgvYiXdU9iaT8xAtX43PI4cpqjWi6zpEUtdHHf9tdUBS66H3fSKGCU1FeXurZmfE6pTuz9GBeb9dEKuze7+jFZYlZsOQT/axgiHU21FgFxwqxVrkZgc7V6PNtKAKmkokGipr0Cp+T11Xsgyd+Q/MqskOBUHV+k1aVAfmJIGk7PxwX0WwujWXGmst/EuUM6t5becxRzKYrhd8beYE4MI7Uuqle6Ph6eU1aNn7aFqaRiQzdjo/eQd96KDYE3yJrAqZQ/5o/1H94
 AXEF7SCj
 DzafhdOBAmM9xxTPsFbsYNYd7rBiETp1AVMD3BFrTGRn6QlFzOxJ32UHYBs5BavcuWghQHOvsjRAG1BU4L4QKVTg0lsuGYqy+YQrnTa8BxNJ+9vD1N3d1MITVmyfn6jVKOOO5pY/j1FFnk+GzmxYqVz2WN6Ha8kwevnVzo2UsJUWx4l5yrjI6TCRww+QXc4hhli0/DxPnB5owjl8jzi+Oa226jzyWAchOfpgxxXQRIOelkgYA1nFzZpZlayx85fT2FTxcyb1S1dgpTksjQpg9L7uClFO7ycCz1gwRl7CWaxFUyGZ1bT1XWXXwp6kUNNBN6k8NNOOlm03EdlkbjenAnEb9Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:53:11PM +0200, David Hildenbrand (Arm) wrote:
> As uffd_lock_vma() is part of the same lookup machinery and
> also contains a misleading VM_SHARED check, change that one as well
> directly for consistency.

OK, I think that one isn't _strictly necessary_, but while we're there,
worth doing too, clearly.

We should also go through and convert the remaining !VM_SHARED checks ->
vma_is_cow_mapping() too if possible, but that's a follow up, obviously!

>
> A follow-up cleanup will stop taking the hugetlb_vma_lock_read(src_vma)
> lock in copy_hugetlb_page_range() entirely. Further, the usage of

Hmm really? Is it possible to do that without the hugetlb lock?

It'd be good in general if we could get rid of that lock as a whole :) but maybe
dreaming.

> VM_SHARED in userfaultfd code should be cleaned up later to focus on
> CoW vs. non-CoW mappings.

I think also anywhere else in the kernel where this is done. An audit on that in
general would be useful!

>
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Fixes: 867a43a34ff8a ("userfaultfd: use per-vma locks in userfaultfd operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

This LGTM, thanks for handling this!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo

