Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B7A1CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9796B0005; Fri, 12 Jun 2026 14:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1476B0088; Fri, 12 Jun 2026 14:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE556B008C; Fri, 12 Jun 2026 14:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 332AF6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:07:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94C7E1C101D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:07:57 +0000 (UTC)
X-FDA: 84872044194.08.7AB4306
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C52B3C000C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:07:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YZw0HBQT;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781287675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDAc4dbWKH4fNV2T21Pns9VB8fFCL+sCAgaQsmPOa2M=;
	b=NZ6xiMMpvHq/XJis3mmj55Rn8HPb8pNpT1TKZwwGi7YP3Ey4T6DIRwetWlc8sNIeVDqgj+
	fQRoOGA9iTG/JE1TzaYhdkteDl24B4fRLZ57ty8pRrIAan62hyn62WYPzMU6/aR5RYWCio
	LYrWiL0I/1gMe8wNvzua5ldXMkCyJsE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781287675;
	b=fvCxT5kzDEfmx/5hzuzWcYdQyG/IutTfpa4l9k0weWrbOUaIFXjpVr0Ec8YZcYpn7AMimk
	SrzR9FnZO0CeuHkvzmUgIIyyITiRKpT0GpYLBv60G+Q8GQCUbbSCoJBI0fmoBMbiYctslQ
	MJEdzczyQM0TDzPd4n4hxbJS7X7k6IY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YZw0HBQT;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 062994178F;
	Fri, 12 Jun 2026 18:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC74B1F000E9;
	Fri, 12 Jun 2026 18:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781287674;
	bh=VDAc4dbWKH4fNV2T21Pns9VB8fFCL+sCAgaQsmPOa2M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YZw0HBQTvGOG9hGwGe0OzoQDR5U9pjaZSBSoAjbUCMuyMOoKpLjNivdJWMOnAt98p
	 Tuvk755hU6wIZlhx/9NS5+i0Z9v0DR3Y9PoXp1+1LRtRS0AmvReXGxmM9rUG1uqJTw
	 RJuvNufxqrvF4R1CaPsx38hv8WW5o5S6O4G5uNTKhctGAG9HPHW2qHFuVmorPQGNPt
	 LtrZ+KxstR+3kvnXwMZrJqEtGhbw0DbjKRT9Ajtz2vqbX7AFbg4hCYKHK8zTM4PTsV
	 +Rc9scpHd9KikMq+Vhq+inNhCSvAwDFf0hIz69gqhopDxe6WvtGxYciZSwiaSjSCEk
	 mUEg/T5BvqStg==
Message-ID: <81c24adb-c0b9-4db5-80cb-e30dfdd5e83a@kernel.org>
Date: Fri, 12 Jun 2026 20:07:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] binder: Remove mmap_lock fallback
Content-Language: en-US
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?=
 =?UTF-8?Q?g?= <arve@android.com>, Carlos Llamas <cmllamas@google.com>,
 Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Todd Kjos <tkjos@android.com>
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230417.77D64DBB@davehans-spike.ostc.intel.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260610230417.77D64DBB@davehans-spike.ostc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C52B3C000C
X-Stat-Signature: qz4xeiojo6edkhu1nxd6t5u7c4qcnok3
X-HE-Tag: 1781287675-899511
X-HE-Meta: U2FsdGVkX1+FSv03yMMHkFy2i92EW6wxuR3LjrIeYBLW2jDMileaIHs63GMgaBUsDUS88iv8caYdV5fCBY+mgQr/HbwL/zt1SfHGo4oEFp7pvpvg30s5prOeNK7VdGVq4jGfm2XUTyP9QXxpEeju0Sa6L657+2SDhQpzgTbjCYPfUpYikSEH30lknq2eETe+cM8XnF8PjmuHUxn89E/7QmQXP5fyhAl/a0Gh0m/KKUuGzyQ6NDoSGKa3Ggb9+vsSHFPMlSnZpzr0Wp4XNey70QUkzaUna5TfavNDDT0Iuw8ySTlvwu1OTet2PB5dX9LmOuzf8q6J182vC5Rcb3DYseCINGaBTAUDoIkswapscxjvBk7VfEvVZ5IQt6DS5tobnAy932Ax1u39GRR7nH6syf/Lsnlm9QWB/yeQOMyHIISUDjqftywYUth47rIjf2tlFT3dlOWHQpOfQomt6hSJ/h4kqq9ib7CBCm2Nfb628oW9Ko5wnoPaBEiKjn17xWUWL3v+0brloi2MG0Z6apg28vnmywNJ8L3iQ1cF8xGe6LvBQEjfEHwbQCslyhqYfSoonkOodg/HWvh3tHGmzopTYXYzoBBY26eYsengh/97pnV9XQwA4Iq/iWm18H1MbrYLaCEENUw1Pd8BwWQF8oxxzr11Xz2gZIRsi8Ny2WZAZMoF1St3IKncaMYaRk4rrPCWEY+tiduCh70wkKd/epSAmvbpfpftqIfc+DQUWXVmRh6wGo9c2qi+Br1rn72KEi39jOW3YUFKSAC3E9L0wDDyv84g+0Q0FD+2JguKAstf3tUQtwi9xQA2hu88WdfT/nDo6srge0tS3fwrzx0ZAGUXG3Y0gy+KljDVBBCeBTlm/RArj8ed1bBnsaKqzyE0T3WV6srBatWi00+288oBKcM9ESio2zLaN7VXq0hqTm+un/5XzmhCEL7GdOtpVeKcA32tVUXr56Tl8w3bxYufdTH
 wSwHLCIX
 goiRr63iZ+SK2R2q9j/KFdWnYS9WqjlRGe8f+irAcq/kLvROwagqeJq4929y4xycRkeJPQu8T3A0jrOPZqZV9TG2prai+UOuTun/h3UlyJ3Oo1n6WZ8UCnI4EaKYt5JS5dVDjwmOVjQRyxzB9q0RkNJhwu65MIq+tQFR53DR1CgPTacW+FFZRmBKJ4nTHmdI9Qsw2cdQYWho/i1NlhqWluIi3iPg5RYBIv+MghJDocnAESgFMJ8efBpEUBo0LyqDy8kZycyJP7gvtXAeLmRGBBwovSF3KpbrLFRS/M8HMnNW7UvJDt0OWVe9b1fKGW8xKmkrl5kUw3EO5CdFm2TKvkqJcKXVPykVnJYkCc4e4VEXnWScTu32Fbl21VTNgvDQTFVjYDZdsnKNHXn1F1uqttEpZf6Z0BYmGcQWONVaMT/r2VXxoqsX4XDSqmD7Ji0g958TDbafElT+05iD4jM9dH3PYQMIn05DazfkFqZIxjJfVhXgfLtwVjfmRFKYcvEWqX0k4M0evQtiLf2LmEooKWs0ciURhJCrFMBQm1GVY4nnYeuFxVlW4deB8BstsAHf5DofPB7paTCXZE3NAzZSo7vTH7SCpwuJ/1ENxo8YxTyQOAdxGMY4InQlUZaxmYm7sX/pGLudT7VxkSBGWaTo1jKZz3Oe7D9ySH2FfTspW7R3LLuRjlQO1bd72PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 01:04, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Previously, the per-VMA locking could fail in the face of writers
> which necessitate a fallback to mmap_lock. The new
> vma_start_read_unlocked() will wait for writers instead of failing.
> 
> Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

The usage seems fine to me. But since it handles cases where vma is NULL, it
seems to support my point for patch 3 that vma_start_read_unlocked() should
also allow for and handle vma_lookup() returning NULL.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> 
> ---
> 
>  b/drivers/android/binder_alloc.c |   17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff -puN drivers/android/binder_alloc.c~binder-vma-waiter drivers/android/binder_alloc.c
> --- a/drivers/android/binder_alloc.c~binder-vma-waiter	2026-06-10 15:57:56.419452721 -0700
> +++ b/drivers/android/binder_alloc.c	2026-06-10 15:57:56.423452863 -0700
> @@ -259,21 +259,14 @@ static int binder_page_insert(struct bin
>  	struct vm_area_struct *vma;
>  	int ret = -ESRCH;
>  
> -	/* attempt per-vma lock first */
> -	vma = lock_vma_under_rcu(mm, addr);
> -	if (vma) {
> -		if (binder_alloc_is_mapped(alloc))
> -			ret = vm_insert_page(vma, addr, page);
> -		vma_end_read(vma);
> +	vma = vma_start_read_unlocked(mm, addr);
> +	if (!vma)
>  		return ret;
> -	}
>  
> -	/* fall back to mmap_lock */
> -	mmap_read_lock(mm);
> -	vma = vma_lookup(mm, addr);
> -	if (vma && binder_alloc_is_mapped(alloc))
> +	if (binder_alloc_is_mapped(alloc))
>  		ret = vm_insert_page(vma, addr, page);
> -	mmap_read_unlock(mm);
> +
> +	vma_end_read(vma);
>  
>  	return ret;
>  }
> _


