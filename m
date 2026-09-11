Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553BCC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1826B0098; Fri, 11 Sep 2026 11:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270F16B0099; Fri, 11 Sep 2026 11:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A616B009B; Fri, 11 Sep 2026 11:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7C546B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:33:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E56934025C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:33:41 +0000 (UTC)
X-FDA: 85201876242.26.FDE6FCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1FEF8140007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:33:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=StSZwZPs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=StSZwZPs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789140820;
	b=JYJz8LEkKLS6rPvoS6zeg2r5nzFORUkqf38Q2ow8mWQTz9ll0uR5mFiyzJQpDcVDJudG6L
	OgkawWXb/9RpRwQKH7TqCMTtMowe3dq/C7NWW2U4ebxTmrsTjq5tA5IDsmi5Pg5z5CFTBs
	6utWOgjpazQmkEB1w6HEUQlOTqCinLs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789140820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aF7Nxwvxz+Lpi7RwrS2E2i/AXxZY4vMNQyRAn9DKm5M=;
	b=qu2p+DtA7Y+K0ntBSvaAV28lKxF0jlDkfrwRGiivU46AffsdWIgGH7VOelut2Y44qqqqZK
	t9nuXF3QFFGXSFuMNJ+kxZWOzTznhwhbD+nf0ZJyEsUESRqpoIL0/yLbzJj4LzeV6PFcYJ
	KQRCP6pdGRgTCko+Ao356LujyaAS10Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4779F43439;
	Fri, 11 Sep 2026 15:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89931F000FF;
	Fri, 11 Sep 2026 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789140819;
	bh=aF7Nxwvxz+Lpi7RwrS2E2i/AXxZY4vMNQyRAn9DKm5M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=StSZwZPsx9Eq1nxx/2p/O0vcQVU7Ig0LZHAbQ9v6d9oXTZQ1hO9ThN0Mcggm9hA1h
	 HhjmjAkjpT3kyuyB1dRU1kXW8NUma3pAL79hDWDVs2y4i45Rq40PDAPvSpBcM8NsDb
	 X/xTHb4HbBqMdgBc52URyYRb5fZBTnvq02Vv0fk7elUQkKTuq/8zhPCJ2uXtr6vFSF
	 qwmLnu4CG/fqq8EeboQsqDiwOfvrQdR3rhawM2T7hpbnftWjU219TeVPpV4fjYj77C
	 JWnFwpeYJA9d89Pcrpi3wj1vBJewgngY0LLVBFwVviisrPlxxhOdjhxDQMlyNIyLd5
	 QYwmet90Vkzpw==
Message-ID: <db06ebd6-8538-4154-9267-9e818cf8113e@kernel.org>
Date: Fri, 11 Sep 2026 17:33:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] proc/task_mmu: clarify shmem mapping walk
 conditions in smap_gather_stats()
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-4-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260910234737.1340642-4-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FEF8140007
X-Stat-Signature: fnkjjrc46cufryqxnnyxoriwwej6q1zn
X-Rspamd-Server: rspam01
X-HE-Tag: 1789140819-827942
X-HE-Meta: U2FsdGVkX18I4o+8rLowYLjrVk4FXbfHREQ8SfM5fTupe9jPwv3o1X/fXQoGOSGIH+NRkm5oUg3XCU1Bt9juShqdJqczilq9+xl6ICsxLssLobkG6BLA7OLmS2/0UB4X10EPW/130fBgYUurWGPviPgQBgC/OGRxtaJlg2LNIaBmdVCYpTeoxpm83nMqo/SFEyjTWGyDvJxdhit1VmvQpQpk4M6/0mITb144JkkSJXuFTeUL091LxxEsg9E7ho+gf9sz7X/CGypC9jr3RV3RggkNpjRcBtCWQF6BMANSO8RLIJHFFX9G29auW/BjkidxWV04+vFg03dgoLkMMU9UqbESdbDv5K31j/dH6zcLGKkQdP/Kf9gWjJWi13v8BCG+QtmtJLruSWqUfzQhJHhkwLWdDIRsKKXDt6vd76oOfMRCfv+xPSzTSE5ZWU5cOz6+sPAocoagPouJ/tDjzwEAjgZYujldLfvFMobrlJbx+Y/zY3QKvEkhcnRcw4DCW+xMdKxo1GM2bruxJfRcE3q2KyBmq/bArXhK01uiN89BjHp4Ziu4lTiOImYBTSVWOF5UgVA9mIpiO97MegwceeqXGXSdUdJpsZy+hReFiv1elV0fbVOLT16MY59RCF5+FkoTutd5ExLWtY9ICIRG3rioaRZJ497pwQbWJVVSYsNxR6+mbLk5oBCq+ZK3pKpCukW0HKYLRSMDeVQ37/+obxrOxSZUy7sHXS9MONJkeYj6qcIhpXaKlQvzdrN/7KiEXfOHgLdSXjuc16qAqUcLhnIZhvool+1xTpjB0FhSm8rmX7FkXSdPwdlR2zYzDpchwDYz1RBPN0I/kubwQP0O4PU7UKzjB5kpRfSuMjtW4ROArv/J/apy2RK2y4RPVkxjowjdMlB4nWSa82ZsHuRgcpL8r60VX9Ff9MOx8S8DUoUBboAou9/PZ370VD3d+aznLyFF/8qIa1dvbRuf+4KUbMq
 fkjpQuSi
 fU/UOSKU63pwLOOQ3SzYlLXL7RbepTRHhtAPWsBRxzg3IQLhl5W8p3kjvgtMVL9zBbgYkUGLejF594ySCC8sSE8aJTHRp1Y6/diVJ/O/YodTTR418xQ2Xc7GwVRa4aXy+/ihYC5cVky3TWN9g0ejszfJSWSbMhzQ8zd6Xeuazy/clDk9JhvgHx+6PeYefjlAp+IAE0UwaSfOrj6lxa9SgyNgsvu+0rVzoLmnM2zoU7W9dEgUtlXjUpQVt7EZkSuCziC33DoTh+m3lAVC5CYpgZ1MtVgHaxSeywPSOa4/BjTMgvm6ccD3ooEzeQFxLCPenQzdp8JVr1dAAlvjy1mHwhyjdl7tfdRURI9yKPJelqe6ANP4iM18bTBGAkRdRnQOaFIcJ20Kxnuxp8iQO/QZ1PmhBXNJ7boJ/00gAYRoxatDBCGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 01:47, Suren Baghdasaryan wrote:
> smap_gather_stats() optimizes stats gathering by skipping the walk for
> shmem mappings in certain conditions. Update the comment to clarify
> these conditions and use vma_is_cow_mapping() for COW identification
> instead of open-coding it.
> Instead of using (start != 0) condition to identify partial walks, use
> more semantically correct (start > vma->vm_start) check.
> 
> No functional change intended.
> 
> Suggested by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

