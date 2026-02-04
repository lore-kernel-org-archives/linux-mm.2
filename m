Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9F1E9D416
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 17:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02626B00A3; Wed,  4 Feb 2026 12:04:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFDA6B00A5; Wed,  4 Feb 2026 12:04:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91906B00A6; Wed,  4 Feb 2026 12:04:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A97146B00A3
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:04:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4AA8914027E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:04:40 +0000 (UTC)
X-FDA: 84407398320.14.4E7F684
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 614792001C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:04:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VLj64Q2Q;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770224678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YETx0je10P+FbXNTWzqG2ArYc37jySrvhhUXV3QePE=;
	b=7Aa3KRt80Ymf1V0skBRxrm2ldyaYBHV6tj5d4BtvkTvwq9HCsz7Z/IhHsVZ/2E41vAix9b
	HNKO6utWugUBlSJff0MLfsn4Xkv1WCjv1VNDdfocYGdXIRltTo3FG0mSsQeBlYV52w0flr
	uQwlP8xLuZH0+8HY9qrsvJcHUdbeSuo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VLj64Q2Q;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770224678; a=rsa-sha256;
	cv=none;
	b=MMd3lBs1E41sl2AWz6eKfEQo8qossDPOpseZ7jIjoSIb1TLqId3rM2MBm2aMC29k6aXsan
	kh7ySik0in7gvYRmjo5btXbBPg/HZG9ZlAetlC0WHr4q94lOIr+4Jw3YbX3mtw0F5YQxPa
	Z4lAYItnTWvqsmYvAKH76YG51+OG7fw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5576E444C5;
	Wed,  4 Feb 2026 17:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5629AC4CEF7;
	Wed,  4 Feb 2026 17:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770224677;
	bh=5fpa65Hj1JoL4PViY5Ooc2n285IlZLLhX3k1Fz+0dxU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VLj64Q2QUh+JAE5pDbbKJ6rqX+Wr+uOUMOWi6gZg6MLIgZgmmMXpz/N9UIDmp7YZU
	 YiYmjCcqAgYtwZOnd3CCLfdtYQfm1AzipAyLp5Vfj0kHQmj7PHrSQ7THP40fgM+yLx
	 UmeMlJnaGG0Z56gdB/mnfTcfHhztL2HnQ194k4jdAC1O3XQqP6w9ox5HCKk1LQ/245
	 zQnAyqL9NoLQFNZSpc+uTnBH8ZHyc82vMDQlrXK/jUkcjU5sG6agoSpgsp2VBFPzR+
	 gQlZB1ZTuLUMyAWp+N+5HoEk+5kJ/AjthVJZpLW75TC2vZCXdblCVQUWTN4MppT+AB
	 rdmbUo9mkn3dg==
Message-ID: <61dec3ce-f421-4148-8191-dcc98bbed310@kernel.org>
Date: Wed, 4 Feb 2026 18:04:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_idle.c: remove redundant mmu notifier in aging
 code
To: qinyu <qin.yuA@h3c.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org
References: <20260203102649.2486836-1-qin.yuA@h3c.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260203102649.2486836-1-qin.yuA@h3c.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 614792001C
X-Stat-Signature: gbx693o7ec8hb17xoodn18s7g9jyhge3
X-Rspam-User: 
X-HE-Tag: 1770224678-701066
X-HE-Meta: U2FsdGVkX19oaF/AvuG5Zk+8g5w92ysPbobwTxXxwTGcBr2ddeLR+V9gAFT2es16Tz9StmZyrg9fOKBiSPBj9Jeku060pjzmjVo3PZBZbQ9/wDCE72Q/HFlhY8ivUAq/wcbs7UiL+x/Oq7bPyNRLQ1I+u/thZb+b4rWaVrowiyIHiVOM2mK2lOTy19Htqjey6j1TyZcCUcYk6QmE/OgVlBpXeIOPStjSVDU4zwDO27EqyHqnoblHYJN3yTbZd7SPKy3Mqx/n2nJxCKZzIIvsNMKdgC0WgKyAeiejTrdaBrh9DePfIvfmYm9KmQnUND5iwXiwTut7O+tDIFSsI4k/XATgMJYU5iMaGZMQvZ4edd1luTpnN1mKT7tLThUJ8qTwLnYKkjOKLRlrHxHF1EluBki7pwMvdGW5PDxeDTgnGKqsWZM9SVUCD79nyk4Ysf1IiWYJOrMAC2zBNP5MHPEYeixCDL3h0d4JB8X/eY42ZR6j+uKQ68rnRczUGaESYQnfouLV+7+wBtqCjLgtLXr9CUimVflTb1YNfnco2KBb/DWwWHSkpqfzFpPMVfh6ybNSqnFcoW66HKAvDv6BXRcHFuuIQunNlBhW0jn+cWrlY30KpRCeNOKp2qmiEFFUs1198J7APX+OaUMvLYGRKgWl6mMFz7t4Gg+h504Zt7HYqHWt0Sdn1bAUlney+dhnIv9kDNZx+CMXMcb4uOnzpuFEDG1zIbO715gAKz1mQrF9r0f/XVvlVZkK3St9nJytjQenJ96JtlxlCkhVysSaw4tO3sKKZtUO/Qxd0uX5AMUVEqXCC8Di4ChkMLkhkBAjtV+hdVDpSZusSHAqUy0tM1Ip5vhq/zvvvYrOF75uLHSR6Yn6U34h9Z5VRDfKCezKaqEt6D/IhXFQyM8+0LuKGXhzgVd+NsNU//9U+reDppahRZdxCrd3XgFE4RK8XeKGVnPdEfrR9OrPHhpButwt+/v
 n9pW0fXK
 jWeESG1qeBBGKvlFq/Q7TaaPs7Jw8o0rpwgTTFWxuIAbtb1yMkudhJJKm0yuHIks0lWusVNg+cqG7ih38myi1XfDn6qURCVc/zBL4TvQcoXb+RJKKi6tzHaanTaQMKUnZHAnpfYeQw7VswXqGQWw8a8D5Lovokn94WSfT5IGXDufgbHav7N5024dLTh6ShFlI2oEK1W/z74Qzpl0iXp0qeq2PyFFPPjCULXWmoVGq39e0AmSEjzLBZE3tn3DR4Y7djDvFE+GVQDc9APpgDWhZDTvzg8S+pNeJK3WZOEHv76n2zqfevL5pJBt/uJ/S8UlKTg4udJ/b2QS1OHcsdfCI3mUjd2xTh+70TQZUyBFkWYpM44+X4n5ARcAIvH/Bh+hnAf3a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/3/26 11:26, qinyu wrote:
> now we have mmu_notifier_clear_young immediately follows
> pmdp_clear_young_notify which internally call mmu_notifier_clear_young,
> this is redundant. change it with non-notify variant and keep consistent
> with ptep aging code.
> 
> Signed-off-by: qinyu <qin.yuA@h3c.com>
> ---
>   mm/page_idle.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_idle.c b/mm/page_idle.c
> index 96bb94c7b..9c67cbac2 100644
> --- a/mm/page_idle.c
> +++ b/mm/page_idle.c
> @@ -74,7 +74,7 @@ static bool page_idle_clear_pte_refs_one(struct folio *folio,
>   			pmd_t pmdval = pmdp_get(pvmw.pmd);
>   
>   			if (likely(pmd_present(pmdval)))
> -				referenced |= pmdp_clear_young_notify(vma, addr, pvmw.pmd);
> +				referenced |= pmdp_test_and_clear_young(vma, addr, pvmw.pmd);
>   			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
>   		} else {
>   			/* unexpected pmd-mapped page? */


... and it's now consistent with the pte case.

Will you also take care of mm/damon/ops-common.c:damon_pmdp_mkold() that 
does the same thing?

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

