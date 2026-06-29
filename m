Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D75DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7B96B0093; Mon, 29 Jun 2026 04:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959356B0095; Mon, 29 Jun 2026 04:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820D96B0096; Mon, 29 Jun 2026 04:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46C2E6B0093
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:13:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA18E40591
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:13:08 +0000 (UTC)
X-FDA: 84932234856.02.1FCB8ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0AD721A0008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:13:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lMJbdi4R;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782720787;
	b=d32rQWtg6Uq/0237Ga5psc+yq80RkQmHKyHTrkbjOw6Xx9zCbXLRItr3jDAg3SW5M8QYlt
	wMzWokQleX3Q9ktfXs0X/cFRRmAGJf2Cgn7banmYukNqB5CrwD2rro9vtON/v+MjiEMDd+
	rvt8WkQ6hwPwjRxWimF/4pKbsSGzwYA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782720787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slFeSu4AqtBj1Xx91s6ZBfnTR7RAaI0yh7MOot2s+hI=;
	b=uZjlzZHEcrEraHjTrYvDvGoAigh0nHofCkfQrlqCBFtQiNPIwXR8jRyaiTWr3TdxhSWrLI
	SogJV4V974IIxeVDHrgNTFWJ9ybXrK9Q5wqsEhf0Rjft1SXXgca68gfGJSG8SA++0qIlpa
	r0DBxV8JN+1qBEppnIuK/VwPtGgxlzg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lMJbdi4R;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8267B6001D;
	Mon, 29 Jun 2026 08:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD481F000E9;
	Mon, 29 Jun 2026 08:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782720786;
	bh=slFeSu4AqtBj1Xx91s6ZBfnTR7RAaI0yh7MOot2s+hI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lMJbdi4R314M+6kLOjYuCWMzIshteAzty/tx72gb/1TyN80fRw6wmPzXyuYV1p7ua
	 LTzIubWu5rRicQaLy/tvQt+PxgF0HsYuNHqd7UwzvnO0442HLzWYTgQCKybhTyi+yp
	 Zj2P97y8CnyKZ3siBx31G/UC55aOljQXoHyy0igJGncxF3+LOODg9BfTro8R0Tattd
	 1VlYmZbKNVcy+TyjtvLnVrtuKcR4p7gcsTWk3OEh11HkCPBWXSsNiDGYmPqogqL5Ck
	 Tuzj8Jd4cqi4mmFhzAI5l4b3+nsIzmCgDnhJqrbXhBLavWvw8XVw48N2ucXuVH6lX8
	 oSvmSnIr91Iig==
Message-ID: <96c919ca-9b35-426f-a142-4d8450a54953@kernel.org>
Date: Mon, 29 Jun 2026 10:13:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] mm/page_owner: move free_ts_nsec output to free
 section in __dump_page_owner()
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-6-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260626024550.25677-6-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0AD721A0008
X-Stat-Signature: ctmm7q9jqhzrci7s61z1nmgmmjad983y
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782720786-819818
X-HE-Meta: U2FsdGVkX18Jn6iv5yPuHBR2oeAipC0UcPewVGGBKr/Uv9qFnb6ZKeP3WZYCfQwRysNoVIAxehEtaOEizzxOUgFTf3jpZwdh3rfDmSniirNveyFclNvYxCnvtoWM36+GRjarVRyE9jUpSfHoIwWgiT4bZPRcsKKfLy5B3Bft6h7CEFkUK98JLGk80hXEofvOXHK0fCCAFPNP7Rfm8abEd1uqlt0IBWu7K3xFeIuLZEPzCkKMuA9weU4nHWk/kj0C6hJIVn2yH1MzmOzwAJQNhQQMekondAzPf7Af+f2pkxHtETmqwJA5UIqCreY9gOIg+cjIG21MwjxFms+BYEuSXwJMWeOr9VdjXhwlQsu8bs5ZwpXDQBKQYmkagfujQaISTjzjHrlAisIxGqKIFLIOTlxMFmYsp5ayK8PqCQOk7OM8rvG/DxHMNPfX6kCoPeL2Xsc9qcU7tPVkWZTikMGpe976NAYLCr0PHTDbwsyJnL1Q6CCiM7/6VzCXAgRQUXlOoUo+l6Fwpq0gtCgQKbxviAOto31V7NkE9UDpdrkiRQ4CN3Mj/6VdeZnV12+Ft19ZvzBEf8akGJ+sInNzAwjFkea8SIBl3crW4oaeLJvA2PnDL98GT6Y8i1qVslsEKRMqs/STLsHEa9uqQGxjSi5SNuvzMRdbuDyGKSsDLHinvhPHWSo61VF4NgINKA/8ZLuV/AhfNNM3xBqN3Tqc0Jn4kJsNSiqsJf93noa0bywDkP9YYuAjaVpW8hkfw9uFtj4sjTXSGyyejottvLUj0gqnLnC4MBJB14jqzmPLAtk8uaAXeWv5Zbg/yHa4q4EZslS9zc1j4bj2yYgoaTjcUilvORFqGvbVp3q/n1Crsdb0vr4EWBLidQnpvl7SPnkYwT1kLL/zs/0vGO9mc3fzmbGB/9fffUSmnypLRIwONKWWGnjur0mC4wSV1YXUvZxXbopwmeTCfmLbu/1iw7MPxpT
 xaNN8T+7
 bsNQzLbN/DtsFD7q4hg/b9dM3ksXwkBril9UjNZagakEekTRkj7ex/ZATjPx+sQ/jii3RB2Cmje0u4Vkw1R9KmvCY7jx/KQ5BMEaSllclfBfHXS0OSLbr3pFBDrIZVGdcveiUY+k1Edkmlq3DSQb+ytZxMwNa6w7ADHNtDkpwVLaJOaGcp8blaco/8lAnmtNFxjXFqO5HuQPMtK67Aa92HFJo3wPcAH/ZuSkdQmmv4kTVqj5Xo2LoW4HgVxMUkS6z1nVLmx1sZvSjoso/IOeC1ul9ddwptH2/8sxMxTmNZKOspnvneAOS8WD4VM8j2j7vbOBJHgp8H3Jz1yw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 04:45, Ye Liu wrote:
> The free_ts_nsec field is a free-event timestamp, but it was printed
> in the allocation summary line alongside ts_nsec (allocation time).
> Move it to the free section where it logically belongs, together with
> free_pid and free_tgid.  This also makes __dump_page_owner() consistent
> with print_page_owner(), which only prints ts_nsec in the allocation
> summary.
> 
> The output now groups all free-related information (pid, tgid,
> timestamp, stack trace) in one place.
> 
> No functional change except output formatting.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

If it breaks anything and they complain, we'll deal with that, but the risk
is low in this case so it shouldn't stop us from trying.

> ---
>  mm/page_owner.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 958151ccb587..eaccff355cb4 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -660,10 +660,10 @@ void __dump_page_owner(const struct page *page)
>  	else
>  		pr_alert("page_owner tracks the page as freed\n");
>  
> -	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
> +	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu\n",
>  		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
>  		 page_owner->pid, page_owner->tgid, page_owner->comm,
> -		 page_owner->ts_nsec, page_owner->free_ts_nsec);
> +		 page_owner->ts_nsec);
>  
>  	handle = READ_ONCE(page_owner->handle);
>  	if (!handle)
> @@ -675,8 +675,9 @@ void __dump_page_owner(const struct page *page)
>  	if (!handle) {
>  		pr_alert("page_owner free stack trace missing\n");
>  	} else {
> -		pr_alert("page last free pid %d tgid %d stack trace:\n",
> -			  page_owner->free_pid, page_owner->free_tgid);
> +		pr_alert("page last free pid %d tgid %d ts %llu stack trace:\n",
> +			  page_owner->free_pid, page_owner->free_tgid,
> +			  page_owner->free_ts_nsec);
>  		stack_depot_print(handle);
>  	}
>  


