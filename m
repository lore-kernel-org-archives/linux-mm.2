Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09071FCA197
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 22:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7AA6B0088; Mon,  9 Mar 2026 18:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28EA56B0089; Mon,  9 Mar 2026 18:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167136B008A; Mon,  9 Mar 2026 18:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 02CCD6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 18:00:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F59B8A179
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 22:00:44 +0000 (UTC)
X-FDA: 84527894808.01.E36341A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC8BD20019
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 22:00:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJXKl2sv;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773093642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lllmMgdMMxWbxUW6ksaZtslhd9o5Mst7TF72V2LsyQk=;
	b=M/M8kf2ZUiV8p7RnKNxsF3e4R4Sw4fznUO+jqOK6rM9i3d6q10SslAocCmEuH0Hv8B1NKB
	uxmvd+unAfUjAvZ+TKz/mRw1nzkdyG0oXLO/ooqJV3T9WMI4Koh6BTtyQuCGuTFdyGDXlI
	7limN0Zka5QKR/SOSRzRh82bGyb50Qs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773093642; a=rsa-sha256;
	cv=none;
	b=v3yRW+uP3FjRS2M6o3cmapCnTqjS8lrcJLmG2KJ3ijPG9p+922g/E5vFDM9QQiubXQrI5q
	B/SvPuw/MbdXuwuUAqdzJtbCKD1987zFtZvpG5gX7G+SukAOJ6X9kcKC3SldY4FTRZgkYJ
	j6OJFpUS0BsaMvjZpR0Uc54rCceYtGE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJXKl2sv;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AEDD60103;
	Mon,  9 Mar 2026 22:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095E2C2BC87;
	Mon,  9 Mar 2026 22:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773093641;
	bh=puMrjprJ+ivfCrD943G6b01a4qftMclPc3Q+OGJykfQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oJXKl2svOLUDhtBKsHZtOlCviRAoJzYkTYfxOHmirlaQu47y3rzTVhCFXBs/Q4yJH
	 UgYlVKaz7zL0FyHV31QoO2GceLTO2fO/N3dpxb6QG0qX8n+xeUZFfekhhKNC31wmyP
	 RfWl9xi/kdbnetynthznxRTw6VqmNeYRQ2jR8gtur64EEoHULSVf9k1f4p6/zXWroR
	 l9pu9odzmuvYbJcpY6IVw73ORSgeJEybArCZBO9woXFzQ+nWeLdtrgnl3hDiFuUNCy
	 MzC+xg/QN3TjhDLmH6UaIBYAMT5iE3pnrZi7KF69GLIqi4tCBvTId+bfYxP/wdBy3O
	 TM7eo9CW5PoIA==
Message-ID: <3b62ce89-2b58-48d3-9c19-c742f211c88f@kernel.org>
Date: Mon, 9 Mar 2026 23:00:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: document folio_get requirement
 before frozen PMD split
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, linux-mm@kvack.org
Cc: matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260309212502.3922825-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309212502.3922825-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC8BD20019
X-Stat-Signature: be6kdwuzofifm87qabbtfyp576t91bri
X-Rspam-User: 
X-HE-Tag: 1773093642-838185
X-HE-Meta: U2FsdGVkX18wJcNyJv7ty5T43Uw2bxI2RyHupce6aV9GanQRhPU7chakxAah/R9WjXt3/YCwEOAOJcux3KjVd6HfYYiHNAopBvzai0ntUBZg5oecHoIGXXOBvtA17MVjHNjvXFeoBie6uVH1KONE4m23ZKo4kCpS37UFuFmF3h8HkMl7kYgHwsTc7NROg2/t2nPrTuxbdAZh93m0wzQicsdEX2YaftGmFSsgo26700VKQtOTFJG5sQRYgUMZF1R9mchnmlc/AYxUzbwkL2h+vPF6v3SI3WKRMGcsv7t/SQ2TXQWAVI9AYGGdfEWj2b7dgsMsx3IwYTwzay0lhfnzr77GZFvif/WQmzxG7VBi9FerJPIe1cMjAuESpLrtgJMYFincM7KK/Nvsw6W6rwbg4Xeh3wKCfPSDqBreTNgDwjgrn+59ZekY4vo8sCBI9q0Uff4tGlZ2Uo8OOvfi4wI6MbtsEPr6O5xQwmdWFDVaFx0yd6YfO8IIlv9UBoqC2FUnQrSw5wsEZvXH99L/ThSqQPgj41+lPHTSq73rtlDqe2km9Mgz+Vj4X0Ta93LX/LI12FQ6SRdSx15rQZOWCOzDOoryCz0HkEyBnKVQfVTP886kLY43B5hBR5ro3uNCYiCaOpiotWI6ibTZ2bZvG8lxON6vLVrmUnmEaf2pKuxYC/pPOM4hw5OON4jV2AKE9axqUtCSOQkbaTeUB9LVMbtcFiecmxO5X5d/PSPee4Ys5UMV2UB0rsG5TX070AsAETZOoy1lon+edhJoU4HK39QkaxsCgenUiolZTbbHEMxoPhEqS/Cn90RfEutKD+JJ1a+bi0tQKGJqtOL04boGIqORchw2NtStg5y5h1eA7CQxxuWgZc/2agk+nsBZaTb0yZpGddit01VxE0qYwpJFsNQiBi1uPm9aamhbd+OKfDS7WxnO8Kj4I5v2yh8/AMj4I2bSs0TP+7dwFyvLH8Jv4sm
 gJvjYBHs
 uWVsDDeiO/qY5mkSZwlVdfgNf2n57Ie87KgKp9CGMKUIGyUAYQuEAXlHJKyqXLoEl5yZ7teffvdCYVXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 22:25, Usama Arif wrote:
> split_huge_pmd_address() with freeze=true splits a PMD migration entry
> into PTE migration entries, consuming one folio reference in the
> process.  The folio_get() before it provides this reference.
> 
> Add a comment explaining this relationship. The expected folio refcount
> at the start of migrate_vma_split_unmapped_folio() is 1.
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> v1 -> v2:
> - Remove warning if folio refcount !=1 at the start of
>   migrate_vma_split_unmapped_folio() (David)
> ---
>  mm/migrate_device.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 78c7acf02461..fbfe5715f635 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -908,6 +908,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>  	unsigned long flags;
>  	int ret = 0;
>  
> +	/*
> +	 * take a reference, since split_huge_pmd_address() with freeze = true
> +	 * drops a reference at the end.
> +	 */
>  	folio_get(folio);
>  	split_huge_pmd_address(migrate->vma, addr, true);
>  	ret = folio_split_unmapped(folio, 0);

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

