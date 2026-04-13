Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C113F531CB
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147AA6B00C4; Mon, 13 Apr 2026 15:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8EF6B00C6; Mon, 13 Apr 2026 15:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00ED96B00C8; Mon, 13 Apr 2026 15:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E41BE6B00C4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:38:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B3308AF92
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:38:55 +0000 (UTC)
X-FDA: 84654545430.30.9CA60F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 997ED10000B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:38:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VQMuTTPo;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776109133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVO2Rv7/ifg72H/Nr7NpF03qmSr6b7R5vF/PKCUAp48=;
	b=BnSzSVvyiB11azFq2dQpp+zcl+cBAMGd9aaRx30gwps9jlPU35xYZGKAlLCQn50JipGDWF
	1+cdOUz+QRj83As0+kX7e/X6wQEPQ849xh12Kd++0MT5AMzlo3/+y72AdeJZdAtTMCSKPb
	Q6YemgtKH7SgnBWnkEsijE9HejuaA2o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VQMuTTPo;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776109133; a=rsa-sha256;
	cv=none;
	b=ZzC5ZbTgRYjNphiNs7Q9Rd//2zKHTaNkc05P3zpVzVmEx+e1Hnz998KlsBNeJxIhtAx0Qv
	HDEeEBLlGIZqgA6wllAb6ZBjeDegGZk0+9KiPfgZtQDkR6/aj8K+nYa1Bg6fiq3mJQc9RM
	h0WQmPxZcHy10+wFOKqIcrVgY/o8fOc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BC7A414FB;
	Mon, 13 Apr 2026 19:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7727CC2BCAF;
	Mon, 13 Apr 2026 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776109132;
	bh=o8g/L+0xgEdrskzM96LvzxyWU1Rf3MN0LrlDrQWLx78=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VQMuTTPohxSVmuhRCi/EeaBlKZFhvEgU9EwF7GPknIN12kh0nnhwbe31DL8mQ7XNq
	 cYFirXhN4UDxP8VTLRIc6fu/a7iJ4ujgHkpVEm/1mKBK0lY99iKQXI8zeqL8Ku5Jy4
	 3x7NC7EulcNPYYcl+h2XMxa6RGSFkjgP0Rd0H+uktSmvtD8y8hzgy4M7fo7Kq7IYt8
	 UR4EDTfBvWHYrgSYKwc5bFVmyADSJi70x73ABc5gJFRtK3skDPfCkPQMn002GucMz9
	 1SbX2rmm8+P0sbfsslONspReAMy4WdwwswOZQK9FEtq7IOxEU3jZ5hlOLSSUYTNb8w
	 3ovkuRIRmOrEg==
Message-ID: <7579105a-1261-45db-90ba-5e660d202b80@kernel.org>
Date: Mon, 13 Apr 2026 21:38:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix double unlock and remove dead code
To: Sunny Patel <nueralspacetech@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Balbir Singh <balbirs@nvidia.com>
References: <20260413130927.13263-1-nueralspacetech@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413130927.13263-1-nueralspacetech@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 997ED10000B
X-Stat-Signature: cj44e8tfxgozjt7i8sdaspayh1auz9dm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776109133-580377
X-HE-Meta: U2FsdGVkX180bP8D6NpGu2MBPn+EpmUVnPK56nBirxmpItLpJFH5U1lWOdCZOABnZzY+Gj2UXc/yJYnh+h9b/E4uUPvM6/QN39LMot7jH0dsd9UvEo78w6imhE9DcH6XpFueQVMEhkjmteu332BE+lKxgvUTSnF135r9YkvGSoJzLanW9Nu5RCQcI4g7sLpc222buwtU9LSgICW8xF6YptB9DAOqxzWaEecc4Q6tlWLuZ9UpdbxuoGsuy7Ewj/gEp3Jrpw8wcBVPpGHD2xcTy4w77WJshTdBAJVWfR8GPkWaF9A3j1BW0BWfGnCcZQEaYBaus+3x4/JHtWP5Z++qvH/4q1GsSMH11GZ83dn8xdEbJ1YJHt4uACk3WUitNBXU5nVzejZT4uG/QEbZGDa8EYwaNfQKucB7j0Zum7M1l5PHOOjAlgKfeYN3p6kdCoupFTZdFZ27t1j0qLpk5CdowjsQKch2vDXWE4chzz90BLiplclmHobNUuFo3JfcicXnsqr8WyqBYWiWBQXWMAWroI0DskSv/7KB79yDCqANqY9Bzf3SXgdlKXm3Eu1T9nsugBcv0Q000IkFvvj6ENQpla6qW8MR3ealMhgbko82J6jX6bqcGMt5G1Hey+PB6Hdom1OteJv2TAwJ2OqGKhMH2GPhmUzJtvr9/6v5aEsvptqrxTeX2m3cnKoQ3nlO5aABGF7dsxs+AJXhpR/6d7cLHxFd8JWFArieZqb3A/Vr2JzoYD7l46B9/SRO4oqGUV59hU7sjY1ElBI6xxEJWG+o18NrN/+2eozUllOVbpVm2G7J4KX0qE6hjG9bCdY6qBJ6GQZ79Q5990Dkm37cNiNcBf/BwbKr0NU6sG0DDtAC8nR/cteZsFRMZInBsYDhii6g9dQKH8xcshgaH1cx8gTxyMBxXOJc69DK22U3kGebS9ZS96LsxO11ITwnN2eTswWAwaIeKZdv7hchsBEK3wn
 BRMyiDx1
 oD1dvQdne36PB7K/YQFp0+lB/HGh8RW71uDoSBqbJAteQnIGW5V+pfglCi0KEAohvGZao+BUbbbd6/8v9iYMI4/gUKqYW3mPMzJKG8bOgk5z0sh5vjuEhcsUKQ5BIYLx7FjvDlr+aS/rhN/m5EIC6lcbuK8GCxto4p0UCPqf8OJgoaRli76HPFQnKHF3lly/Twbew5Aan2PkNIacu6aa2UIj9irKD7wWeN7NnUHRK2JhzcZpTWspAtnayw/fTFwipDS2qfXWamf1SsQunkeQZ97BWutSPy8nYMG9T30Md2GzaqwYOAGyYsos5bdFtNgPW0ZYK9iyxXBlp87QltdkTSyJKH7Xpkg+KVKUkqdkMBLsdN4KLUvy8/KKYEViN6cuVAdYFhh9j9JM5HXzQFOd7ZvyyiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 15:09, Sunny Patel wrote:
> Fix two bugs in device migration paths:
> 
> 1) migrate_vma_collect_huge_pmd() calls spin_unlock after
>    softleaf_entry_wait_on_locked(), which already releases the ptl.
> 
> 2) migrate_vma_insert_huge_pmd_page() has a dead else-if branch and this
>    branch is always unreachable.
> 

Can you move 1) into a separate patch, add a Fixes: tag an CC stable?

I think it is

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone
device pages")

2) will then be a pure cleanup patch.

Thanks!

> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>  mm/migrate_device.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 8079676c8f1f..0e005c26ee88 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  
>  		if (softleaf_is_migration(entry)) {
>  			softleaf_entry_wait_on_locked(entry, ptl);
> -			spin_unlock(ptl);


Yes, that looks correct to me.

>  			return -EAGAIN;
>  		}
>  
> @@ -869,8 +868,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  		if (!is_huge_zero_pmd(*pmdp))
>  			goto unlock_abort;
>  		flush = true;
> -	} else if (!pmd_none(*pmdp))
> -		goto unlock_abort;
> +	}

Huh, how did that happen. I hope that it's not a typo and we wanted to
check for something else.

-- 
Cheers,

David

