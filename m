Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 344BDCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 10:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0202A6B0088; Fri,  1 May 2026 06:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12EF6B008A; Fri,  1 May 2026 06:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28FC6B008C; Fri,  1 May 2026 06:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD5626B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:41:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68BBC140140
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:41:09 +0000 (UTC)
X-FDA: 84718508658.05.949554E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3D88E40007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:41:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dK8huKGP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777632067; a=rsa-sha256;
	cv=none;
	b=cdUy7ufbwZgxEOFofSTjvxFyVgaYteUdKoMERSGI5y5hKbAtcuzUJ/PzGglAZi9CXSbt5/
	3ER/jQFL0eKBG0Q+9TQqkmHb86uu8XLi5+m0B39wig94sRIavzIYjmh5SNkfhQmP0o/9GQ
	r1PMAd6hR3NdokqBDxUzXcMDDKbTIp4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dK8huKGP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777632067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4pfY9DOeEY/yBkrpnmK8GySWUKGYW9ST9zdGoT4uws=;
	b=Jlh9Rm2EV7JBW/n/kO6F9YqvwYw7gbtXrlC+ld2Ak+ejz7Nt/IQDjDOQO3ezKmmHb9bNbw
	06xBZXcebTpaHgaPmAGP7XBAdQJToOj+0G+pNOA0nfQ0tN3BWdH+mDP5VPMUcH7fgJkJ8u
	bkqJrFfGOGCvUaWb3/Ys4LwgG7TrM04=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A06AF176B;
	Fri,  1 May 2026 03:41:00 -0700 (PDT)
Received: from [10.164.11.2] (unknown [10.164.11.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D86783F7B4;
	Fri,  1 May 2026 03:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777632066; bh=/l5iTo71MJBR+aBi3Ju86nzZYKybU7sUXPkvn6urlYA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dK8huKGPMBqdQfhZpl3EVu3JypzYlWsSoY2FRosjQ+8l2RCK5BbdsqBgJeCNSut6C
	 oEE00PbrwzvN+wQ/+SdSrGYhVDqJZTnsVgr4rcuZnQ8lrWXA4uvFf+yyShS2sRpCKD
	 x1VwsJ7WgomrM0Si/wbkHNPW9nFL5C55EomYnZqQ=
Message-ID: <aed7c1d5-2189-4ee2-b0f3-ce5a3e3c2118@arm.com>
Date: Fri, 1 May 2026 16:10:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: clear MMF_VM_HUGEPAGE on mm_slot_alloc()
 failure
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260501075708.327217-1-ye.liu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260501075708.327217-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: frzb7dmn3jrmpcijpgom8rtrjif8f5sb
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D88E40007
X-Rspamd-Server: rspam07
X-HE-Tag: 1777632067-63462
X-HE-Meta: U2FsdGVkX1/ixWrcNjCOitq6dy7JlwJXZgAJfsK3GmpyuDYbbi8DKmta9JmbDjNS+K8F4NopI+TH2DifPWwuA20MT+ySQZMgCwXT+mbnSiySa4Lfh6q36uEgFKH3lsHS+RVVHMfe8gnTHfP0y0YSIRFt6psFGTwJSJ+xLYsO46sUt7HF78MKLxxkzg8TaBUour18PGmqSf7E4Jv7bF9VW55wy3HUIenUPGPIep69bZM+7Lr+A/guiHSnVbfFlkLvlKHbxWMRZhdh93faXTTLvnscDnBHIMPSGS4MRceUpVvF3Jf6yRHsiJhs28P8xK9IOERRk4+ewDj+uboqhPSha2TXPddr7A+WQrz/FQiFMpgRiKL/9vYcXP9518VfsPBocV4dV7W1OxUJrTNoJa0RdDg6gSsKTAg8tk3L3R5h9jDxtrk7D87wtUBTHqRRmjKLZj/SVnPG7odZZCbajuhUbK5cW8o5JGyq6G8MlmBfs0x2ryw0GGGNAtx3awASMDV/sOg5iWBoKID+p3mTU30vAaNuuguNZz3+fp2T0lz+zabgalOQi1iNJP7AxW0+N/LKCa5jWVr3IG+yHlP44sUjw00bdKvi2D2HG3Rz7+IBHXy7EBClAuxtwWQFBalT0pemzYsyQTcnAOkanGc6XA+3EIjLouTVipwxM6bbeFQjWL/pMp66DMH6g1Xenprp+tKsvzQEsaHP0kbN0/4OtZ74j9dYwgx5RSMoZsJzkUygShTQZJF3yo8qVfquGPaSe1qMz9Op8CwEUupaf1cZ0/oxFjcsJaijHWbGuiar18Yy44O4nqZJCbnzOhRBuFU2hXBQN1yxs3y8RHAMhO7PdRlWslW2PXm9FKoTj4+NXw+ignInTSTSxuPERpQhXeaItATn0D/hKKxooDGR+MyG7eJsOx7SYuc+G568cJlfNToiwTwnEyZkX0Ut9owt131IlfppdW/piKLm8za3cEQjtP1
 Xs6dtZnP
 9whLwgiC1QvZbES3JRAkrI6+sIM4ljbqlQZjILHuTZjcszz8dbABGKQ/zrzb8v7Q134iQhnFpAr0ZmHP6eox2PiYq6SqKwx1zxdyW696uwoO1TTNnlRdwYAVhz8ARIagTrbSGTSJrgRHIQjKjGu9SvuSipcu4Tfh86mHfcgqX2ojuENBnDbbbxIX52ZZTAE1qlRFzabnaH2AQQWmO7oucUnWoNr0h7pmhdFU3NePFlzwUJWoOOdLk+63NZXu1CeACF1Iq3SRo7YB2HEAw3/RQaccfi9GOakYRWPzP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/05/26 1:27 pm, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
> corresponding mm_slot.  If mm_slot_alloc() fails, the function
> returns with the flag set but without inserting the mm into the
> khugepaged tracking structures.
> 
> This leaves the mm in an inconsistent state: it is marked as
> registered (MMF_VM_HUGEPAGE set), but will never be scanned by
> khugepaged.  Future attempts to register the mm are skipped since
> khugepaged_enter_vma() checks the flag and returns early.
> 
> Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
> restoring the ability to retry registration later.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/khugepaged.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7d48d4fbd5f3..60ab7c1b61dd 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -559,8 +559,10 @@ void __khugepaged_enter(struct mm_struct *mm)
>  		return;
>  
>  	slot = mm_slot_alloc(mm_slot_cache);
> -	if (!slot)
> +	if (!slot) {
> +		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>  		return;
> +	}

You could just move the test_and_set() after this no?
So if slot allocation fails then MMF_VM_HUGEPAGE is never set.

Fixes tag is probably required but not sure about Ccing stable.
>  
>  	spin_lock(&khugepaged_mm_lock);
>  	mm_slot_insert(mm_slots_hash, mm, slot);


