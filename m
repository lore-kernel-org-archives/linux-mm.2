Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E02C4C98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D3E6B009B; Wed, 23 Sep 2026 07:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3EAE6B009D; Wed, 23 Sep 2026 07:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54BA6B009E; Wed, 23 Sep 2026 07:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4D86B009B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:56:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AB5014077A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:56:42 +0000 (UTC)
X-FDA: 85244875044.14.FFB2099
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 54EF5180004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:56:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETF1ISNk;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790164600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTz+E07TzqHeAqnACQmu7RNQTLYVCyexbot+9YlUnhI=;
	b=zSVXo9JaYbTB5UvritSZeSqsXUA+La34X9JYF7BFIVSPksrdbkV31f7RgLEbAiFK0OXq7m
	XSc5eVuFWfcWzJa79REHQJEK7d6a1WUhXBfjICFw8by3UjXA5vkKLQHcPq8CG9dS77sAHJ
	j/vfRFi8FB4vZqGACtUIHKErV0AI4bg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETF1ISNk;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790164600;
	b=wWaRHc+MSYwx3rrCcj2+QR6Oo9HCl9h2EXS/Jar9PjbcyUFmTstkhsfExhm8vIZRO6UQp7
	fEUTqaAJJmPJAHI+mYeqRvOdOtiubrFJ1c3K+ek+MuhWTIsSpUymAcMLhcCWQmtVvURaW4
	OleRFuu3c68D3zNMhCeWCQRLnvfKKM8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 886C341B4A;
	Wed, 23 Sep 2026 11:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4331F00893;
	Wed, 23 Sep 2026 11:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790164599;
	bh=PTz+E07TzqHeAqnACQmu7RNQTLYVCyexbot+9YlUnhI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ETF1ISNkd+WN1Vj3Q4fE2Qc/T7On3xxZi5dYugH6mPcf5CY4Wk38bnGutRM9Fg8jn
	 +LClWCgt+w0vFDYUK9weRzP7oBK3LlaZ0mXWXYOiiS+Xe+pj/Cd6vI67zKnuquBF5W
	 TQFIDWRYawjK11gwt2mdcOE4MUiY8sgi96ot/N6iC9g6onCmMvwJRkPIXvyZ4JOM+c
	 pHgrL0jY52HR8cJmfCTTGv1Uf8Ts890hgd7Mzcq6S3Wfskbcay2yYPqU+WKfFs+f/u
	 0keA8sqw9WZjmJdGpqveztmRIvuMZ1GLL91+Dl2+WcIojWlENld/mKMXNC/nXrjHOl
	 f6kEEqETrJQZA==
Message-ID: <2a2c7c17-82bd-44eb-a3d6-cad263c01b62@kernel.org>
Date: Wed, 23 Sep 2026 13:56:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/12] mm/collapse: add collapse.h for the collapse
 interface
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-5-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916093145.4022188-5-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54EF5180004
X-Stat-Signature: ffgx7d8zc1pohzp76n7bku51wjr6iips
X-Rspam-User: 
X-HE-Tag: 1790164600-36248
X-HE-Meta: U2FsdGVkX1/nyi7uyuqTX8kNAT/weZm2Wp+uhM6dG3xyF4zdCY0a/L3AAmsmf/USVvOahZcojUxlULFU0muGsEDDhjOAgnLKxjIoG7ykWjS2PN+8Tgg6gePXK49w2GwqQe7CTm12BYMVLMGkpjz1NgMwr8Yif6zhbIzkUytnXBrOc70s9c1V40h59ELXBy0NKjbBNx3L0ntapABje3f/7BvVdJBTy1Hd5pwceUkyYuwsUtyd17GEjoGlqAR95GlQFHRgvrxYngaUHX2BKn2mbEIy/OmtS2rbbZLp2GZvyLMwlzOci8IPd/FXMgJn6IA+s3jugLnX0fAa1m/VMm3uZHeJ0nkUl7szkf4zuOfrGHxM+N80b6HZWuGXqWKkTEmgAULX1esEL8tZS9NA7PDIv3YM7xCld027rzROJoY9aP3PEvS1Hwn0tG9ihWrIIYuRKsVhRYWboDHYdWGX+zOJUm7x5vSPZDvIBZit2PzgsHc30x9TwKXxWINTzv6+wobaozA49Bh/55LdOv/U4V9mgir7aUCwM1JiZJEM1NqqWcOzIjhRfCTzceRkebVjzq2gr1w9HOEcX73V+KjOgnH/vb5eTKDV8evR+5UYebQjqG/Jy80Fl9XAjfn/2InBhLBqcC7XbCu5bBypVDQ6RV1etWtImqR/5sXGarMI6rHuRN0eJUlTxFFjhvGGNlZYEddMjL+WuLHz2E/pu+LQvjjaw9EZf4tMEBINzrQfN33ojN9g9VwLYr0yuM46oMNa2dzJnDOe7fO1lA4xYjKrmf9sSg0LyA8Qv002w8IkqCiLrhp0SocbOiDQ589Vk4Wi2ZGWklzYS6kuxwkatwoLAPBcTk64e8iWU4qiBkjng1ZnfbWmf4eKNydzvh5p4Io/yPtPWABcAGAIpb/fLeVvEygZkkum8EhV+Y6xJsP8OBpGl4FAi1vgd4bPJZwqMNbpuRAo+FoDLKPtyxBjvmWgPsC
 rGYNsZCd
 V+4qnDAiGYyoBXD/TJ/RkbE+X6b8lmeGdnmO11QPsj17LZd7c12pxi4BZbMS2PV2RlvsZWdlNg6DBElTYvieeDuCJr5SDZo4thjpYhYUERuZ8RSYnhLlGOI4Dru0Zs7ambK6MfDkOAZuKcfqAwhTt89AB8LLsEZfxJqsVQYoyZFHrEKVE/TXND0i3fhIoUQ1qtw5zw5GNbSULQW3xcNz2RB/BEpW9uPAzYwsKnx8teF2XOXAMpSckfQri2t+FteZtmGwxooEjv9JNKoYoy+gPKhztMTmm8hlMSxTU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:31, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> khugepaged.c holds both the users of collapse and the machinery that
> performs it.  The daemon's scan loop, the sysfs tunables, MADV_COLLAPSE's
> entry point and the collapse itself all sit in one file and reach into
> each other freely.  Nothing marks where a user ends and the engine
> begins.
> 
> Start drawing that line.
> 
> Add mm/collapse.h for what the two sides have to agree on:
> 
>   - enum scan_result - what the engine hands back;
>   - struct collapse_control - the state a request carries.
> 
> And two constants move with them:
> 
>   - KHUGEPAGED_MAX_PTES_LIMIT -> COLLAPSE_MAX_PTES_LIMIT;
>   - KHUGEPAGED_MIN_MTHP_ORDER -> COLLAPSE_MIN_MTHP_ORDER.
> 

These look a bit odd when thinking about the "user" aspect. These are rather
collapse internals?

> Neither is a fact about the daemon, so both lose the KHUGEPAGED_ prefix.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

