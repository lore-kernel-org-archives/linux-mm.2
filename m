Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C095EA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DEEC6B0088; Wed,  4 Feb 2026 16:35:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9676B0092; Wed,  4 Feb 2026 16:35:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6716B0093; Wed,  4 Feb 2026 16:35:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55C6B6B0088
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:35:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22DFA1A02E8
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:35:55 +0000 (UTC)
X-FDA: 84408081870.22.C82B24D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3A18940012
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:35:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L/9m/IXn";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770240953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYo9Z9gm7GkJIE7DS2NeS7B/ZlRYyeNGt89dcwlK4CY=;
	b=UJb1gkouhgGc8WdKsmiuEoWCpbNgwghCbpJlvlXObx7j+LCV7YY1Q0J4dXaChotcq7+jKR
	3bUitBdh+DJjrBnMPz57rMI26m8feyygc2Ee/WTv83vHXMpgEp6ncuZcc8SVZq9yQIrb65
	RXfh+DIsMajkki4seVD955vzMbTayts=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L/9m/IXn";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770240953; a=rsa-sha256;
	cv=none;
	b=3k/nJ++PzkfcXVxHvhbSXmH/jXXJZAhUaDzuHq6BjhqNpjNrlWndpbJ4uqCgzo9jJxUDhW
	vG349HSFoT92uOyGCWsFAg8R4xXCOOG6BOL3orjVLkO5jXQgp9bneRCMmUuEJFwUF35ghd
	GE+d/1PR71NxfOrZrvCnPaRhR/IPucM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26C6D433BB;
	Wed,  4 Feb 2026 21:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB96C4CEF7;
	Wed,  4 Feb 2026 21:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770240952;
	bh=1JOH5a4nFNxuZdz4tbFuHznJYRc0xRITRKZgjfVW7Hc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L/9m/IXnWlC0c5WwHUg0ZZLXnilSkMlJlirxaxYJYkgdi7UhIfufGSdWboQwhBzax
	 yEtHGJTyY86gdLHKEVCo7nv+K4IfaAlrCsnGENt/7rPEenrvbNTtnEOMAjfufIdlLG
	 JK6DwQgveAtVYsIj2ifMZp5XLPzbNoI44nS3gaagOJjBe/7ZI6nTSByplHrPQhIvjc
	 gaj2LejLIUXVbbDkQGG/UgMiUKZulPfa9ZMwky36/cLm/PldS+E/SQCO2a2ZW9FAlE
	 ww+2qt5GXtqlMt6GDY9BErY8Hfh5XUdzasTdRVejT7IFtqLtRsd/5fVEY208/1//pw
	 k2OtV19/J85cQ==
Message-ID: <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
Date: Wed, 4 Feb 2026 22:35:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260201122554.1470071-3-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3A18940012
X-Stat-Signature: mmcezt4q31cft86xytfpbqzouokmhtbj
X-Rspam-User: 
X-HE-Tag: 1770240953-671979
X-HE-Meta: U2FsdGVkX19EtX4Ran0QRoLLoJ2TcQ4GatZqjGTvtT6AcUsdl/fpniBQj2iE0hW0iKJ12Taradq+/kV5fZeOY8CPaCREzTj4cvEydAdnYOep0vKOxICt78ZAdg4SIuSugOvTL5azVoIYSzXji7Exb6HDY7qjh6XwxMs6TdvHoNjDTMQP6JhvWlrlLm15MfsNYU1QglvAVmdz6FZziqP1rUsenRxFf2w07MIFDWwG7tPQV2Xn9PxcB0RDOZbv+vqxyJouM0pr9tOOIAkRdMrZ2+x8s3kuartF45cDXGBRbCcF9vBDuV/P1ZEsMzGavFn+/knsYE0iwH+gSOjaYIH4mlDKt8QrGh7R8oF0ZektIo5jY9FlycdHU64UeLxMLpP9ukAI5oYmjrfUZioyU5busjKhOPC+bLIzZDw3HSk2s1S0CuLbq8BPiW+p0rf0WCIslpZ2m0ePsiP/earPV0cOFWn23R/XbRHzZnB6LSkfBTnmKp5ixFtGAdneDKKQ24SmIZJoO2kU1l7uYs2NCjHVs43LZ9PtFHji+YJB3sHUTjoABHrTdVzJ0OLxYgGnKQs0aml+Cw+lRXk+n7RnjYJURSalNXY7rlLYueG36M6enHC1WKQ9rs4KWx7nJAymi4gEKPLPyjf5l0GS0IdkORrXt49e7RkBn5VKU3iDotwv6LjEYQsoODsg5RueXuFkj2jlTgIwDQFN3ZFiZ/79xaKvhWb/1HBHkZZ/lV7FgYO9Nr5Vi0mihTMa+tYXMRz9EtH9MAQ3vlbV+3UalWwUPoNTYEEZlb/CyMHC7KEBxIDJKVLSVuV4H2d1ogTuIRKgWGSgAUa2EbpImfKMVxTqB0PjM7HESgx4L+fkd3RidvzrecMOpxSkEc1CVhUK0sQfhnKCAdsYHaZXFvcrlRNgNjl1jibxMSjRwFcgOdJFWx8Uc9Yuew4ZhlJqiWd69GJmUe8oW/7xQN4Bc/40YoZfH2Z
 S+wh03/C
 zMCH6uwjvJ8o6Y7bSAlpsgoCuuA3OafHXZvZsZoUXnCMOiosOC5aaxY8ySyCu8nsFLLyvjVcOIwV/3WpFpzz8cxty5RHP8zWdJ1xZCM2/csRgEsDdG3GzsY0etzJ0LeDXa6mxvUXrfLw2dCciOP37Jop/4RSwpizkWFghPrxHfX4W9NlUnxFv8wtYDSST7RX1rIm0h2Nq3VtwvAsgF29NCvCfcI4QDX0/rae61Oajt19gtccXblN9N8jME8f3ggz24E9L0pX3HQwCQG+Pba/CY+JV6gMuKcmIA7kX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> +	if (cur_progress) {
> +		if (_pte >= pte + HPAGE_PMD_NR)
> +			*cur_progress = HPAGE_PMD_NR;
> +		else
> +			*cur_progress = _pte - pte + 1;

*cur_progress = max(_pte - pte + 1, HPAGE_PMD_NR);

?

It's still a bit nasty, though.

Can't we just add one at the beginning of the loop and let the compiler
optimize that? ;)

> +	}
>   	pte_unmap_unlock(pte, ptl);
>   	if (result == SCAN_SUCCEED) {
>   		result = collapse_huge_page(mm, start_addr, referenced,
> @@ -2286,8 +2301,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   	return result;
>   }
>   
> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> -		struct file *file, pgoff_t start, struct collapse_control *cc)
> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
> +		unsigned long addr, struct file *file, pgoff_t start,
> +		unsigned int *cur_progress, struct collapse_control *cc)
>   {
>   	struct folio *folio = NULL;
>   	struct address_space *mapping = file->f_mapping;
> @@ -2376,6 +2392,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>   			cond_resched_rcu();
>   		}
>   	}
> +	if (cur_progress)
> +		*cur_progress = max(xas.xa_index - start, 1UL);
I would really just keep it simple here and do a

*cur_progress = HPAGE_PMD_NR;

This stuff is hard to reason about, so I would just leave the file case 
essentially unchanged.

IIRC, it would not affect the numbers you report in the patch description?

-- 
Cheers,

David

