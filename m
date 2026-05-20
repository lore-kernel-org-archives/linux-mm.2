Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7236CCD4F5B
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 03:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AEC66B0005; Tue, 19 May 2026 23:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F6E6B0088; Tue, 19 May 2026 23:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675176B008A; Tue, 19 May 2026 23:16:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52AF16B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:16:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0E5F4014B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:16:16 +0000 (UTC)
X-FDA: 84786334752.22.2A954CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3A4E54000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:16:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YkbVnLYP;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779246975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8M808h6POUPjBABuK+39vGP5JIHi2QH7gbVYftWgWEg=;
	b=xoNtqFwaXFphnreJa7YK5+PspXHv2tXloeWgfEkEG8gwbw4D3Ch2UYa7awVxwcz0PEG2If
	AycZYC7eAyH+SoNss/HbOVQCHZavydbYshbHslaLPKlm3HwiITwuau2NGjq+eh1zp77Ixp
	3jSgPGOMeDsmUwqwnDQ+tI2DiiY4OK8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YkbVnLYP;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779246975; a=rsa-sha256;
	cv=none;
	b=c1CMk9OEu+W4pZFXlf1CgFgbZepqCdS6XSb+/SPd3V1RnDM23fJm2M+IuU/aktAGXanDz/
	aLquNHoeTIOYovbyGoX2YkBVQ/wby27XMMGkBeOkEgx77rFPDr3NbpRG5OQi0ZM7KTzkth
	55yOidSEJ1WvjCA52AhxZy9mLjlzbCk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8712D6022A;
	Wed, 20 May 2026 03:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383121F000E9;
	Wed, 20 May 2026 03:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779246974;
	bh=8M808h6POUPjBABuK+39vGP5JIHi2QH7gbVYftWgWEg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YkbVnLYPif2yCNMuLe+yYMLGdMHNQfRE5Q1tawbNRYYjve0pCPvdRikC2Qg93FY0Q
	 lkuVVMyvWpL0kvj3U61HPJwtOTQl13LwQHaQDoMuqGOH1uFXAoOrAycOCF5Nr3oUtJ
	 1OaqbJXhcIlKKIdlf+Xm6Y+eb3EApmYWZSPLwdcroSf8EZgQTKSgILdle+LA7aYJJi
	 BCYIfN39W8BMjS/n84Px346eBY+xy/tDIo+ZcZJPeilA7ZKgL91X+ykIV/bj1S92wi
	 xE3Tz/quErHzJonjQhcZyPXytEKpLrExyVMTGh5ZV04lVDnGRoVvpRN1L04lp5I9TL
	 IVUua0JvdcxcQ==
Message-ID: <6c089de3-34d9-4dd9-9646-f51328c77497@kernel.org>
Date: Wed, 20 May 2026 12:16:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: document that alloc_pages_nolock() uses
 RCU
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260519-nolock-rcu-comment-v1-1-4a630c8794e5@google.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260519-nolock-rcu-comment-v1-1-4a630c8794e5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xbikgrsjztfwmj5ppq3yf75yag975n3x
X-Rspamd-Queue-Id: 3A4E54000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779246975-376091
X-HE-Meta: U2FsdGVkX19GLDu/037EL4Dup2RWpx+HpiCF2+TCKrFJka+pv20JyqFWLeZryfIiBFC5tceqGlYLLlHwoQE5NbWZm9Z3URd9xa0YMqqF3/G10Dn7vqid0kbF19JE6gogs3WTO7hPVMKxWz+8GX22bNIwlL0FaFePZtRpbc1dOUDSKvZvZXEIBSle9lF9DOWk2XviFNODRnvvEcS1Bqe6PQ3QkjUJfaUvhs9Ji/NNzU/yRsv80LfYFdPONXXJjTFH9+fRB8nRVbWxt0Boq/QK/bgcXns5Dd2t1BRKiY4QQnvVoCg7DdMtHJ6nZTbK5zZOBfwkLcEQ/Url/HipSQMYjLCa8+mnmbjlXYnn/3YYzAjTEnUzuwXirFkDd8iehfLKq3iV+FTbOsrwagfXExSRKTILtAylYIcyIT77uOmVaijJCy5ykdIWWZEOPeIg+tQ+giyktheYIibEbveZP4Uz98NAXse0hEcfyJwEG28/Emk38TLW04N+7WfBDWUtTLjAr8J8M/6RSNGwqJFbpydjhF3LWejpGUwT90byWrdbNnU+mTTqCRPed70dlSPSVSnppJ86XaEpdfNIMbmQGTSfSWcS17isx5P6sAvzgdaCS4oYTfRG9yxdtJjUBxxkwrfagaeUXrKkq1ahQaDk+1KfvreQkGt5yccX3tpDoQLEp5UmPHUYazM3IRM6wcJHcWqJ9uwtuyRelitWFoXu0MVcpFJGfE819fIqMMibozrapx3hD7dO4qeZkR9eRJTgDgGF/D9vSU9TPOS8FUskQ0D/QhUJ3v6Cpw/UPb7z72yA9CBYoDLk8XBVXCE2RkwWCbi1/rwqRF/Akx2DtWfmkJAyKDoeDg1kWYhJ+o8ea++INJuUubonoMVA0JWoNMyvXSLx2RN6Gl1/95aIcgIYYcstOfdkOw3+fswCGjsym0E3IDPOIwCrnEXiLB+wQFBVSFJA1rHZm9R88ZVPxDHPqOh
 EwY+FVAB
 gNG+9A6H9luEkoELGRPaPf8ueOzAINCTpMPNUYoacuLFx4s/14gss4wPIFTchhyX+YlySPp1jLZdZ4pqTk1mVtLu18vKB6dQUs3ryPK5FqfUOEeQJxyizebtqSxkoOyMXtzUgYut0/Xw71Qqu5o4rbbLLZb5LLmPIMZUMOO/kpe396Ojym+r6heNkGOUllm8gRtKq6i0olHNYgr25EinAUNRbKGqfpGYocbrtkoX6uvMRUTSNDaQ3tNEEN6iSqu+0mkeJDwDuvc9wFK3Kk3QUb0FXAZk9MFtE43/luyv25aM4lRpoxh/npu+mT9eEwyqweIZnzMinIsh4r8Xxgf/XaYt5uG2ZHs2t15gd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/19/26 11:17 PM, Brendan Jackman wrote:
> The allocator interacts with cgroups which rely on RCU. RCU does not
> work everywhere, so the "any context" claim is slightly overstated here.
> 
> This should already be enforced by objtool, since this function is not
> marked noinstr the x86 build should fail if you call it from a place
> where RCU is not watching.

What prevents an NMI from triggering when RCU isn't watching?
Oh, wait. an NMI causes RCU to start watching!

> But, expecting readers to make that
> connection for themselves seems a bit cruel

Agreed.

 > (I don't think there is even> any documentation of what noinstr means 
at all, let alone the connection
> with RCU).

*flips through the documentation*
Oh, perhaps Documentation/core-api/entry.rst?

> Note this is not claiming that any cgroup code called from the allocator
> would actually break if this restriction was violated, it could very
> well be that there's no real way for the allocator to act on a cgroup
> that can disappear concurrently. But, since it's likely nobody has
> verified this one way or another, better to just be safe and declare
> that RCU is required. Allocating from an RCU-unsafe context seems a bit
> crazy anyway.
> 
> Suggested-by: Junaid Shahid <jackmanb@google.com>

The email should be junaids@google.com, not jackmanb@google.com? ;)

> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

Otherwise LGTM!

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

