Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3EFBCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14BA78E0006; Wed, 12 Nov 2025 06:37:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5F38E0003; Wed, 12 Nov 2025 06:37:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDFC38E0006; Wed, 12 Nov 2025 06:37:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D864B8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:37:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C8F1C0489
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:37:57 +0000 (UTC)
X-FDA: 84101755794.26.0998438
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B3A6F80017
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:37:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEwD8B7g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762947475; a=rsa-sha256;
	cv=none;
	b=SYN96fIyvd4imGImOaPntHQdJmq1t1a0B8Ft3y0QXNYbV7eYiWgTwsxHsYWNLhYVLsXfDb
	3tTtC+aVvCky1/8fhVZRzwemgBfFnnVeY0AVljxe3AKYwLWKFlpsqoO3go1CHccPv8m3UC
	cah+KwTjZmAXPWbonIYmo8xTnvklcnM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEwD8B7g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762947475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNO2AMfpZ8hTnoZSNXJZ7FUy+kbulmdNEa4pWS/bubg=;
	b=wWH7l1aUrinultIUJg907a2WD7YobTK+UeEoYjG/58qohSV2S7GTdwyX6JpDDm5rk4CgHL
	3nkw1YHgpmqcSSu9HUATtGzEeNGi/FXPNF+ceX3WvOH1sQNgsmF27KeD99x0D1b2cCHovZ
	yPK3tK85racK7GLZrU2z7BKl2rTlU4M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 85FC844018;
	Wed, 12 Nov 2025 11:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8312C4CEF5;
	Wed, 12 Nov 2025 11:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762947474;
	bh=9eyje3n8F9JrQInIWg9SjS5SLlOCIS9dvxtClXH/S58=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uEwD8B7glVH6j11jaKszi38avvOs2oESpjLRTBSIDErI9HiggDfkmqXocjiUnGIjV
	 d2W2FQ5cWoocJsjekXCNKL2CgOE9M3IxlHKC9b2UQxRbFX0F9jcWVk7Sy8riPT1j9d
	 WpQBHfiPHB6Z/gTGkAEhjPuSq5xM1ZE1mtQs/axU+eE+pjjwaMj9sBQUYxg7JLHm8O
	 1jtHqHxYgfRbAnTIGgEogHwHTQ028SRmGO45rRcK9o+pctC4Xg+PoRaOEGVTPlo0sP
	 fiMO8CtVZLmDNaGLGaNgJjaizA+Um/q48vsx7226cuJ/EmEWEKQhKf42x5xVyT/ZuM
	 a6hRoxm1Mz55w==
Message-ID: <4e6286a6-721d-45cd-a4ea-e79e90e14fc7@kernel.org>
Date: Wed, 12 Nov 2025 12:37:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: softleaf device private fixes in
 remove_migration_pmd()
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <20251112044634.963360-2-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251112044634.963360-2-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3A6F80017
X-Stat-Signature: kqerpupuqcmeuaedd4juuumi54trzzdz
X-HE-Tag: 1762947475-50081
X-HE-Meta: U2FsdGVkX18uBUgdlM7VXVwTPuv+cvoURE7GQkLleeDrVx5PZa8YD9qAsGTaSKFXMnvyd6yys1onEtZJciUACau/g88sdEmJF23y3Wei5Tqui5jWvXC0sMNEUeelwzdUCoc7f+tYhVlGkQHGO7oEj9LmITIWsWKwCyA/Ojm06Cd9qd9B9Ovhen1wodH1BMy7TIj2QCPdzXPRwPMnxczOy76BeJp1AJ0YuAZ10/9bG2nzSZIXYFcK57XnOQa+k9nkvCugJv/yVhPj+ZBI6VfjYaKJ7DJZkxDdEjtef/hmXGGGZJvmvpaGWE1SCKN4sWjPxsRJuDFgvo9c87lNQSVHvvkq7jFg15srhyRNRvTIrI5h3J4yNGVp7iRKZguwTUjOXbQoAI6uQih6+tf+kzXMJr3A1EwZjLvIh5Wu3W0RpOqWehgaf31goa8CHjhfnAPfvfwus8qWu6dVN+tYEvGMKRsm9FooqG94q6WRM9xA4TDSmQ7tI4nhGO/qlduyycO5pSw2/FjiLprxzVz1w6g4vnklUrbxTUxQmVfEBHZsILCOHgAxyuXjb1f+yyJmqIjw+gcokLOLF5FaIiqMdcSepYmsBzNvAhoYbBc7Z9Ss3elPqlK1b6uY0FSAi1CapANF2QLnxpR8xaDSqTn8x4pp3Na0UvsVIyz5MkJKvWZTJzVSJopaztiojFGmduB/dFf4uvZvTZ79qtAwPSaAusiZa0E/hrEbWILufz0G3fgR2ue3TAaFFotglvjopvJqWBDjQiFDs8+qTqxVUf3OO2Ng3s8snbRnoHaP2AczkkAo/TEKzHNffRpxywCwQGXIb9mgPYFtqfEuRT7vVcWCHuqJUn6OJCsN8zJgJhtMuJlyrV6/3AlvTiLmqAh95VCf2Lwk7gXbm4jx6C1tjRcKNDhugfPMId716WXlbdBulOaeX5Q4ZWHOAlxEmDlfVab/qtvcVJ4ud+fu0v+0G8Jq6GF
 Vu3TtMRY
 w36BWJAwdAyO6UmmLXZ8ST+uwbHIgo9LEUFdwZo8jCIZMz5/VZfkXvlV7+S4UqJXz+85w5ulyBZ58b814DM0gCWhpYoR6Q128VBxvi8/2UtpNWTONxl0hLqN4y3E212XtA+EElQ8UnN6FsEtzzfZTQhmNTkGvkRI77V2qVeshEn5HNiL+axXjYgXZWgHXv6HRSgQaXRqA7iOW3k8Iemnp+T2f/FQj25501xcdjpyO32HQ899B9AIL5nPvI2XzF4Ed1NbGFVfjQuEbGH8H60yXb0c20RvdhCgSmQDqQjzNs2AXhQcBKZHFZZIf/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 05:46, Balbir Singh wrote:
> commit a6ca2ba46390 ("mm: replace pmd_to_swp_entry() with softleaf_from_pmd()")

So should this be squashed into Lorenzo patch, or incorporated in his 
series in case he has to resend?

> does not work with device private THP entries. softleaf_is_migration_young()
> asserts that the entry be a migration entry, but in the current code, the
> entry might already be replaced by a device private entry by the time the
> check is made. The issue exists with commit
> 7385dbdbf841 ("mm/rmap: extend rmap and migration support device-private entries")
> 

Because this confuses me. If it's already a problem in the 
commit-to-go-upstream-first, it should be fixed in that commit?

-- 
Cheers

David

