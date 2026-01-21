Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D17F9C44521
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2DE76B0005; Wed, 21 Jan 2026 07:28:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1156B0088; Wed, 21 Jan 2026 07:28:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B937F6B0089; Wed, 21 Jan 2026 07:28:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A48686B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:28:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45CD51B03A7
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:28:55 +0000 (UTC)
X-FDA: 84355900230.16.CDCDA37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 819F6C0007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:28:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Van3gsou;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768998533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfolizuRiupadxkLVyaUdghY1K85KsuAKyP/VH2krjY=;
	b=I9oCL7BwdCaH6G61PnoU63ppDCTIHk+RxjYQ27MaT5NXuwtfgMdHDZtcpA2/nU0IZ0DZdV
	ms8saUoMD8YVsOClMXauOH/ovszHG+01RdA8F00PV1cLNbeVIt50IRvw+Wq/zvAZ5ZRYUL
	5a4HW6DmZKSH1qG+WnJ8yn55dXd28ao=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Van3gsou;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768998533; a=rsa-sha256;
	cv=none;
	b=O4ozbQpFvzwS2mKIG99isGpGKUAwKQqAcNxZpWXg26ftHoFV3fTGYDg2WHLemn7Mx0KWq6
	/SVnePJRwHBE05U19J+ZeEtU6RUFcyRwLLiVvJ56lrMgEDX8Z7ngENf4tObFvgNcYh/s3Z
	F+FZtQzcdqVBIyy10c7Y7qgzhhFurtw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94352600AD;
	Wed, 21 Jan 2026 12:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710C7C19425;
	Wed, 21 Jan 2026 12:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998532;
	bh=rD/oyKTE7w7JyTws5uUSUhNwYTZKRqc+wudLFAsBZm0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Van3gsou9ts4cyfsepozn5LKKuQo2aUwO3UBchz0wUFhx/dkpRKOy+573A3NvmjZh
	 jGezuSTzzTppkqwP0rE4dfyxIgbuAKwyYU1qtUzhXduKYP1SsozyvQ5eLK3M7wW5m9
	 qLTzpFTuW8sg/028g70fznhb8P5OIF+1scPNLLyJWIDS6wHW5Y/Js2/qQ8SCQ6oHp0
	 aLXUQgcMUuHKFmiaVgNPJnqApm1XY8plrpbYH61emhS3w9du8UpV4iMMqtMdfrXyXH
	 4KuBepeH/tHjeMC4+fBWSh8GNJhjEz/44W4kSTIU6tOgfhxIAMz989uYoR9TF5lKHH
	 Ge3oqL3EOMQSw==
Message-ID: <f9bfaa03-bc02-4379-b542-457015053e5e@kernel.org>
Date: Wed, 21 Jan 2026 13:28:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: Fix iterator variable usage after swap()
To: Lance Yang <lance.yang@linux.dev>, zenghongling
 <zenghongling@kylinos.cn>, Qi Zheng <qi.zheng@linux.dev>,
 Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org, dev.jain@arm.com, akpm@linux-foundation.org,
 ryan.roberts@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 linux-kernel@vger.kernel.org, baohua@kernel.org, Liam.Howlett@oracle.com,
 zhongling0719@126.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com
References: <20260121081343.713715-1-zenghongling@kylinos.cn>
 <ada6d430-fe18-4db7-aa1b-96a03f7af37b@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <ada6d430-fe18-4db7-aa1b-96a03f7af37b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 819F6C0007
X-Rspamd-Server: rspam11
X-Stat-Signature: i9hhmuoph9uqmhyry3d9arzgahugjb7b
X-HE-Tag: 1768998533-52939
X-HE-Meta: U2FsdGVkX1+iIaKsNYLSs8fDGOaj4oeNR/zKAJzO/xoXgKvi5HxHNgP/eyMKb1SZh+DUPLsScyjT00YN8ozluOtoXLBbrJ6pM4M4lz+Ce9VIY2VCfS6blyLitUiWAVV/uOs60dhSrkLMuDjAAFL9wnwZz9dzIbE+8Lo6MUXT0pA5ADa/OjsY+c6dwaTdPbm4hSdM2XmDAnc61zNMgv3I9RrUiVzM20t9IeGiEOcQyrcWKU1CckEdpyNav2qQbhiWNIfe5rYlX2InXuVME+1cmZ7soUSC6cxNElCb7RG5fh0f/I3GUYFUH98+UYloQM7K6WNsS06XkXZlHf6gIvg7x/dnMdVK/7KKJ2G0ruLLCH4eHzppI37pWr1eW5Nowtn+jEABW9+wH/hpVWj+6jPctNSGbxX+NqFOL63u/iwZHPniCRU+LzdcizsxDq+BesdXM+RRBQREp9av0Crjg4B//mS7VyMuZ2M/I0JLFaKMqeMlE3o6lpXyYDjtjsYB1XSxYkBrlumcd6xJUbQhNU5nBEvFOuDbjdeVtkjHiogqP1jtiOeJO5lCDRvpHtMDsJ55OWJiMfLbErVmjDkELJZVNNTRoJm+B3SFELj35KKW8rHgKJ1qEuMKcSAATT/8DumHdiip65djsscxCi0DrsRqu9kU3LUm/rWUa+qRp9DUwAsEO7OBTm2Ai1rB+oTgvRPJi/3KzhSvUFSGs0T63boeloQPsiZiTTCNUinJUnq/O208KM8UCs+8q0VcRYf456dLkIsHaNiQ73XaeAHa6eZdQEDHp2oU0UQkQ2g4bzX6ai0L+9aIifQUlwOXQon0XK8ZIs0rbphWTzUF5k5HslbRsJZfF9TiIDJrWbQOCOYiA9QR1Z2SdyH3LmsfPSgd0FyvAN3KAf6NrIRLfZifTBLL+Q/HIph3ah0fvpma/K36P/mF/R+/+QeVY5ORZWGwufWJLIeC+5JcW9MshCw6Fdl
 JL0RzC/9
 AFShkSndUBSIYDgVbqd8dfNVmXlx4ZzG9tKp27IboD2cbLNnVUU/GRv+jgzWsenaw5LYBCTcI102zkWE8UjtUgW5zx3E1lc0mW0T3pXyB7FwW/pEqqOJek7Ca8Cc8bOw6t8X6i4xgNh58d2/QpQ/SWCsnZ5g3QVhxILuINN4RGbHCoZo3PH1QV0dML4zLs35GkWWVMzQW7RyQIoFARE4lZ/bNMMLo87yxPearVZMktwHU3JRk8nR9zu8eRKRdliqsrBLIws49aKc2Pe+0LosItzwE8a77q3bwQYSylOuBHpZ9qH7w7pTWS0FGLI2hwF/2NvOOeyYZ9HUkrpOyw27QArYmH3tEs0UaXjDd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/21/26 10:25, Lance Yang wrote:
> 
> 
> On 2026/1/21 16:13, zenghongling wrote:
>> The iterator variable 'folio' is swapped with 'prev' in the else
>> branch. Using 'folio' after swap() checks the potentially NULL
>> 'prev' value, not the original iterator value.
>>
>> Fix by moving folio_put() call before the swap operation in the
>> path where swap() occurs.
>>
>> Found by:
>> ./huge_memory.c:4225:6-11: ERROR: iterator variable bound on line 4178 cannot be NULL
> 

Which tool did find that? A compiler?

> Good catch!
> 
> But which tree is your patch based on?
> 
> Seems like that was already fixed in commit 776bde7caf80[1]. The
> whole thing deferred_split_scan() was refactored using folio_batch,
> so the buggy code with swap(folio, prev) is gone ...
> 
> Ccing Muchun and Qi who fixed that.
> 
> [1]
> https://lore.kernel.org/all/59cb6b6fb5ffcff9d23b81890b252960139ad8e7.1762762324.git.zhengqi.arch@bytedance.com/

Right, in

commit 776bde7caf80f6af72b087cafe7d9f607b14716d
Author: Muchun Song <muchun.song@linux.dev>
Date:   Mon Nov 10 16:17:57 2025 +0800

     mm: thp: use folio_batch to handle THP splitting in deferred_split_scan()


Which raises the question whether we would want to backport that patch to stable kernels
if there was indeed a problem?


But: I don't immediately see the problem.

If pref is NULL (and folio obviously !+NULL), we'll end up with
	* pref != NULL
	* folio == NULL

	The "if (folio)" check will do nothing, because we defer the freeing to the

		if (prev)
			folio_put(prev);

	later

If pref is != NULL (and folio obviously !+NULL), we'll end up with
	* pref = NULL
	* folio = NULL

	The if (folio) and if (prev) handling will care of it all.


So ... this pretty much looks like working as expected?

-- 
Cheers

David

