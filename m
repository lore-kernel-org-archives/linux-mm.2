Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2A1FC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D276B0092; Thu, 27 Aug 2026 03:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE67D6B0095; Thu, 27 Aug 2026 03:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89F36B0096; Thu, 27 Aug 2026 03:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 486A36B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:28:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB8FD1C1B14
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:28:20 +0000 (UTC)
X-FDA: 85146221160.23.3DB0ED6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2CD1D160009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:28:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fGDHCk/2";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787815699;
	b=gdLduRDgKN2jIuzfl0pqo8aAASheICD4uoloQQI06jbxeta+kC6vkJsFw6eaks8wsOnY1v
	E2j0mobW516lOBr88SjmQNHKXD3KYoDa0ZKPhc/LlLXxnmGX419cWipY350AiV4W1nDisv
	nq3xkc+qxEoFvPIBnzkyVCMW4BE/8rE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787815699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSUKy48mNgpLBoXIJGRi8A2gloyeWZwIEX3wuZOXoug=;
	b=vkj6fQbat3WdwqOIIn0zO4vcHkVzweeuD+iOz8TKf2cZ8y9O3hnR0zR+7DT+y+RCNy46ap
	uCVP2sKg/WRwborDRwvJybDMEE0H5eek7s9mTDd4qGat4v7Qf06b+RyJI95GmRz4X7xJq/
	cZSzEoOlLw97RdbK+3LGyzVxFx3763o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fGDHCk/2";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1645F40D8F;
	Thu, 27 Aug 2026 07:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1831F000E9;
	Thu, 27 Aug 2026 07:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787815698;
	bh=oSUKy48mNgpLBoXIJGRi8A2gloyeWZwIEX3wuZOXoug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fGDHCk/2ttc15Uikv9PZ0OuE0So53Q4Ti1z5mVazsUWVAdxHVdpVrjwW4J6pRdV2y
	 uToNFjpl1nUKe2rZ0QmyWnJwHgUDk4dejr/tcHJTSfQiQSFx6XRX4VN7TAuysOXqEJ
	 Q7vZ2ojdtqgDbn2/1VCQFna82aGizM6f1mjPP5Vx/+WSriVZs77AbDQQ42fI4JEl3S
	 6WscetxVXbo54vhK7uxzZj4FpcgdIzgYRYjTGgPRCb8TBwbGOl6U3D2hRnBQKy0Efs
	 bJWwO8QXfHWLuV4eg+FDyb/W68yYErGxQ1BsxVmgzCavDPUj55Fo4i44bbhGMTu2PC
	 jlCk5MgkJivfQ==
Date: Thu, 27 Aug 2026 08:28:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove unused anon_vma_trylock_write()
Message-ID: <ao_nBIAFLvtqbQU8@gremlin>
References: <20260827071845.17636-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827071845.17636-1-hao.li@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2CD1D160009
X-Stat-Signature: mfnpgacubck7odqy56h1iy53jgewr86c
X-HE-Tag: 1787815699-494355
X-HE-Meta: U2FsdGVkX18jTlBUwscl0ZAwXfZIne/vhLNvoackORtrX96jSwGOOaHqKlK8Tib0E+G36w+fGeegVqsWUIpsI7zWXguC4zCtr4sBogdBZd8mhRKsKcU3SZcAl6Sdnrv7lXw2UWgQX5I7mVpoSJFE+Wu/aVrkLdEW955IIUmfg7Ug4C5BhdHFpCk5+37fBvQc6LyBd7rCMSzuCpLCxl9Sp7w+spZV1mYjcEzRzGQ04vWxxyLGLITPkh+8t2cDjNrWv1zRhzfr0UtjvJ7KwcKrCcn9BeUH3q32uOgrOHROqoiA9mVcLVNvT72XSn4l5a0J1Yf/aEE0cux2vQWkDcWBtgTbhk35wgP51K7Jq2aymL0HJlgtV2xsBxTHRlhvBuwJ8LOhQJkrHOjV+DPvUghucN6kPWCT4YndIc8nE0tbseeOAtnA4Vu8z4dmyYaqeUxWOP9/6KQrWHtq2THJFHrS7NvxU0v9VnuTLgvjd7mW7wq3KVT1p7diGw94OL8JkJP1GZc0pGq2m5TSr9uBVk/3CDjCkTF/x6s/lX1n8m+Ueqv1wiIh5pPFCGjbMy03D8U4YiyVW+gKaxcde9Qo+/TE30yIrKuZcBxh1u3xaXAIE1L9GGY/rEFa1l55i2xGMvLdiyIqHgUHAHF9FcAAMLXm11uJ90i5BZ4nIuqzEaTii1eGeySlsG29q/1346c+5lJodOXFi1tvPvDbKAp67p/H8fsyLrNXKjslqDTN5VuKjRuZGsKESnFlZXrLTjBd3EQi1GJTceL+YVjn+fRDBguplAPm2cqR5d3AZsRlqu9w/8Zpvt5qI/3Cyr5wkiqGCTM7eqQcb1UAnhg/jLX2EEjngq7lqvovQNbzWcnDGDfAiKhY8jaFbIVGUDl8hPAyrOZ4kKMsapiqMdINQ4SzjyEeWBt68HLhIZVY88GrS4Te8gmUgitf98ctmlJym14/kreiNA9GjyeY86XFS8gCIPA
 ZbtiZ/ZY
 egf1Y8bp12hX1X74xb7QJBG8mKyGSWhBZgSXQSeLH7XH2RKApMATjS8zjmzfNhIfnZ0Wzswl0CzBNqyLaeDQ1odKo9uisI28Q2hfLSe++teoz6vMX5xl3GuRoxRnYO4q9LJATdkTMd2QG2DIxgs91/FbYhxQJRped3dUKdQz62CICME+4Fhps7LTizSiSoJyGMyC455FydTIbyYnApD8xN8by7eP6jY6ZkxIJkGyb0uyUaUNrQh7GAaykTZVwJ/ekwX/JQ2F6tvnF1XQBpsW3Yqfnt77sz7mrigbL5Tv/WzOPndI+krhyyQCljcCU47XVZoCv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 03:18:06PM +0800, Hao Li wrote:
> The last user of anon_vma_trylock_write() was removed by cc22b9978509,
> leaving the helper unused. Remove it.
>
> Signed-off-by: Hao Li <hao.li@linux.dev>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/internal.h | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 68db5abd0a4c..9069013d191f 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -298,11 +298,6 @@ static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
>  	down_write(&anon_vma->root->rwsem);
>  }
>
> -static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
> -{
> -	return down_write_trylock(&anon_vma->root->rwsem);
> -}
> -
>  static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
>  {
>  	up_write(&anon_vma->root->rwsem);
> --
> 2.54.0
>

--
Cheers, Lorenzo

