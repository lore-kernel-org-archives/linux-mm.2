Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5833EC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7396B009B; Fri, 11 Sep 2026 11:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6566B009D; Fri, 11 Sep 2026 11:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BBDA6B009E; Fri, 11 Sep 2026 11:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2776B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:34:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5261640254
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:34:20 +0000 (UTC)
X-FDA: 85201877880.12.811FDAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 947FEC000B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:34:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ks+jkqFp;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789140858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/mAvtzivA9U9X6tGPYFmDfSejRVU7lyr0+4Ivk47GE=;
	b=dhjx9B1cc+aI1lBUZkPlSHI87g5zYXbchdeVBLdI3oK/YqZWSrLNw6O+C81ZeppfXG6WX9
	yY/M1ejvXh8/3gdyrOyG/bdKLV3PWiQIcRLamKeuF3HJxd7B7DMkSK+e3WRSQHziYIxE6g
	baWqSSZ0DjLjfjh+SwcELH6rhbyDsFI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789140858;
	b=Zf9qjIDUTNVrm/1KoyVrssxhDFVFhDZgE8eoOP/pr9vHnfeWOKSn6lMYVGcbGzJrDlK/9+
	MIf5vQNqlfO0zmxwyNiQuz+AUjOLVkSu+I0WoperkQKSh93k8hMjgUOXZ2pRni/fNbhUFS
	o0bz/I/sTnGb8U1cyzy+YJlPqdexW6w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ks+jkqFp;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12A2B60234;
	Fri, 11 Sep 2026 15:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515C41F000FF;
	Fri, 11 Sep 2026 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789140857;
	bh=E/mAvtzivA9U9X6tGPYFmDfSejRVU7lyr0+4Ivk47GE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ks+jkqFpPwmWZ66/YPo1VZOvJ9HduIIKb5D/770pWEebkf7dlklTq02Y621vjUQKD
	 Tfy7zNaCHzRd1kglFb2yEjnGGp+iZqRGG0DWdQK6IO0RHZMD5ES5VbMZRYfy82/vBn
	 o/104GLutpfb9SHkCcPYXlb2KpfJOwYN0ITmFEPS1cNEeT/agBhikMjyMp9bojhpXN
	 6Kr0RKj7Qnc9x29zWRlQ7KglAzHf6IShts0QtJ5RAdKu+LdpjimrvATnMbhTq5TZyR
	 bYLQNb5FX83l1ZY29eXM9IHmUmw4tIdGKhon9DEize/OzBqbSuV+MLPf3byMohLzZ0
	 0oZoRFn5DjbLg==
Message-ID: <6fc3240e-8c4c-4178-a1a6-c7c876b92ee3@kernel.org>
Date: Fri, 11 Sep 2026 17:34:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-5-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260910234737.1340642-5-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 947FEC000B
X-Stat-Signature: mcqai1w4iki7r36cnkogps83faafr7ss
X-Rspam-User: 
X-HE-Tag: 1789140858-849543
X-HE-Meta: U2FsdGVkX19UmYRiaZ02zG792vpeq2RQBA4UbGBIYK2dvI7SRJtLCZrIdhccw/jy8cCyigdr3CrmVEy2R94WUmpruLUVXvfYVEbM+xL49YfjP9p8p4VXe5mDdrRewCwQYo89VHVdwv++q46Chq0mRgPWLrTiyEkQ6LUMPS6hsCvt64L8b4H9eSGlPben0hmxI/m/Jl6SQQfo5lEZJ6veWjWyl0q0DVdD1PHm5/yXkmm+5LFiWsSnuDm5VbNXotJ42h4RqrOuoAyug1Crg1TXbQrlQEgEEiD9tZEZpfehcfx4GzwXIo62VBaVIY/FbLgD+fpxS4GmFyoWEtgx7lAMJodGtuUMHjFNYbesSnSsEruemMJEvIxfxg+yVPV4hmeIHndqH3lgSL3E2UsGRdYWAq1bX0goTDgg9bJdzWJ3GycejUmRitaJOlQRhoTuwbwYaiiL58SpVx3uOBRAEZslVtWD9ceaP4sAGB9bl4YavuN2Xfb8TxYrKIOiW/4dh77sYEVGkmAhItj/wzli6Dm0Wvo54JfQMtI3XxEitM5rUEUJRjuC8nLauNb2Un2ZRv3Pks8h8SGJB6DMH1VMYVJGmAROSPeWtk8oc4wPk82esgpIsf5m9JMm7TLEcXgfzqJnePRBO0lqUIY5eLRPo1d0Rvp7W84zdhmJ7H+CCJBT8YqTwip3sI1mLdmI/GGqyVtIbMGzyBn+IhPM8rufJIkG2dZRw5J5pYSx/slkhOsgvYYFyl0bqyc6yyGI/ikWFRXVvvv8rrajUx7IRwrFexj7rpDsKAfiWktJ7p7p7PM24LOINEREsZbTWU+jgEC4LqjUE8SGJJsh0D+vz6SiMBXt/dus9/r0OfHvQtHbVGnenuLzJpAi+DUyzwuJo1nCPpVtPpmGWfFrY7Nwyagtln+My8wiQVRWikju56VVxWgQKUBOcpSAyJkBuvhlRg4Q1kk18nwo0HeJMNTxb1zh+CL
 qxFz7sp2
 yi9zSIH40ThJzQ0bCAf1qL18bw0gI1/2x674Jz73aVESTXrjJclsHxL+Udz3WFVSX90hBjD6MHdNmw7KKKRNmBtebFjUVa4hWskzN/Z6ouhlQKhjTrgQtXVoNxhE55AwUaLd8gxW0lzqA7elh4Lc9vMJ+tb15Q3/9myWws1cjU2vMHzvNS/lQnV+NbtnxlZ1QFTz/2vdHHcjXYi4W+lTLSHP7Om4NqPKi7B3f5ZArPx3p07riI0e2G8uzc89JPW+0XeQYkwQJsJbZPdpqvUljgrfOT6JevLNEDcDn5UyMaNKM/uLCu3T9jFkPSFxnKS2TVypk2l7noHqkvlF6cQrA8tDYcqk57isICZ6LjI6jaObo8btVN9wrlziEl5Ik0PblpNITec7eH83kqxM5BiXRX7L8qInuUCvyY4oxM7yQNBwF+kCafG0+P5wpKKfWMf3WFnitdW/fxDUspoBw3BQl+tqTWU5OTbzG2UyptMwdx8tGYYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 01:47, Suren Baghdasaryan wrote:
> smap_gather_stats() interprets its start parameter to mean vma->vm_start
> when it's set to 0. Eliminate this special interpretation and pass
> vma->vm_start explicitly when needed.
> 
> Since smap_gather_stats() operates within a single VMA, we can replace
> walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> which is simpler and also can be called while holding per-VMA lock.
> 
> No functional change intended.
> 
> Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> ---
>  fs/proc/task_mmu.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 3c40c9cbb9c9..ecce7ce116cb 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1246,21 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
>  	return &smaps_shmem_walk_vma_lock_ops;
>  }
>  
> -/*
> - * Gather mem stats from @vma with the indicated beginning
> - * address @start, and keep them in @mss.
> +/**
> + * smap_gather_stats() - Gather mem stats from @vma.
> + * @priv: proc maps private state.
> + * @vma: The VMA to gather stats for.
> + * @mss: The accumulated stats.
> + * @start: The address from which to start.
>   *
> - * Use vm_start of @vma as the beginning address if @start is 0.
> + * This gathers stats for the whole of the VMA unless the lock was dropped
> + * and VMA grew or got merged and we found it again, in which case we only
> + * gather stats for the remainder of the VMA range.
>   */
>  static void smap_gather_stats(struct proc_maps_private *priv,
>  			      struct vm_area_struct *vma,
> -			      struct mem_size_stats *mss, unsigned long start)
> +			      struct mem_size_stats *mss,
> +			      unsigned long start)

Two tabs while at it :P

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

