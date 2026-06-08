Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFE00CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FC036B0088; Mon,  8 Jun 2026 11:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABFB6B0092; Mon,  8 Jun 2026 11:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19AC66B0098; Mon,  8 Jun 2026 11:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0ACE46B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:38:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F59EA0176
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:38:34 +0000 (UTC)
X-FDA: 84857152548.08.48B0D3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B2191C000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:38:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bQxyOqT/";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780933112;
	b=k2Kqcce31nw4l4NiGWy0aZ0SQBgACvVSdAKlKZF6FHVdJoW15Swa/SBY4cRZ98ofwCMGO6
	A7FVeAMoZNwcUxYJ0t6RfpQJyixCB3djF513GbQcLgeFlDf/BSmVpe8bNAECWwU2TUdWNY
	5cxpPktMEy1qxXbdspjMjWyKteFfLPc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bQxyOqT/";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780933112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+8PnYD0gabW4Oe0rUJLesGb3GBzLwEDsBFUW101snk=;
	b=2csGEQIIGtLQunGnVsGfy8kIF7lkn9luZmg/J2fpJmDG8yKEaV5D/63kdi7gTl1vGt2Ndc
	/hRuISDR6+7Mc47wGae2ww/sSCf5MrV+v8co4MCY5grpWYyPXZ4MUZvNgfZ+KBdyowZoYb
	3W/UDNxZzUo0I8x5euWmdjqdvwd0MGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BED71601D8;
	Mon,  8 Jun 2026 15:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503EB1F00893;
	Mon,  8 Jun 2026 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780933111;
	bh=i+8PnYD0gabW4Oe0rUJLesGb3GBzLwEDsBFUW101snk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bQxyOqT/AdkFJIeW2HC/zmb923F9BBOds3pOH3xHRMAOhodoJ6Nnhhru3TkjrN2dl
	 VVIQzX/3Ausm/7OzU/HtweZ/x2+xUeysI3CwSHsCAwwzHxxEAL1LIb2/3uvgXfwIYd
	 ZV/buSnjOWk3q43iF0Vn2mQg93Ew38J0RWKcBocDx7H1RhJ9yfnnjNe+TXPZgNZksW
	 yrFZZpt7HO3X0exOPgiw7vpoBqLkNIXXwt86JAz4fkE/TfriTih+IDMBujPkwuhc2T
	 HT24REevPf4eBpBeE1DmvJHbTMuY/facWnQtn6n7cnrOokvXBCFTk7YsJtecJVhVzC
	 +5I0y1tM/OtTQ==
Message-ID: <fb25c5c3-c3b4-44df-acd6-46040ff1027b@kernel.org>
Date: Mon, 8 Jun 2026 17:38:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] fs/proc/task_mmu: change lock_vma_range() to return
 error code
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260606015729.1837935-1-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260606015729.1837935-1-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4B2191C000C
X-Stat-Signature: jq3kmu9s9fa1jyszmm6qswfg919fno58
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780933112-259739
X-HE-Meta: U2FsdGVkX1+S5hpgG0OZ8q9Zgr1VDJZJr0YdY07F5aPD439tUJYapgaDd+Z0O59rObfj0AL4YtOpr5RFsqgAaSoyfwLRCo2WhTJldFz4CCBcw2QBrSD6aaZTUPr2aNISoYDup9+Kui1Bu7MrnOJHxomfJThg3qGu8JqrxRN26NbO9WbB7EZruyUDryIERojthhzcv+/i4j+1PHE4hrD/fGz1xPdCLNFQndndBLjb1hlQGPMN5wSWTYRMAF2wbu02IwrTEW8UPYM7K6iZ6bQn9oQqO6FGsyDrI5igOZ1/bb5DGX/qVrC0tomPXLAfK1yXiVizs2KqRr+0xqlT9u+zcrVf6Si53l9sicj5xxmZ9SnF3IkYyJOx8EObSbcKHuDeWhRe4Uua5+hbSjBAKzF++blKZ7g9I9fRsRBFjVtfBepWRsN24MvH6yXrkTe+PVgE2rPCv5Ge29jduY8XNKyv3rKlzvoY9ICn247J0CkEwDkpuuZKSrsaHKPd4GK+NACgHMxJAm62mhtnogtjHnkNl0IQhtePmkIgAQtPT2u2Y2ersrlqQPJ9BK6Bd6GBObRfxPki/pXImQPvdIRLXesWnogEKC31X2KSCHRCtUrG0b60mZO142DAMjqS5tRrVJb97AnPGamGtAriyiyO3vmSh1uh5lthieJFFEqWd7Rqi6cpTPoofnfG1PrxO2OrJRiwrXwGppHensZzYyhvMnfTND0vkl1N5wf9TxR+NGZq98VbKuaD2qxaVTDUakif8f/KhkvNtxfdygHT/p3+VDsfxyJJ5GBiGfgZVhyfeMWMiWM1jROyC42MRlNHnkF7SEt8xZr1tEAZonax3fI2oH8CdJ5+A2B6dA3wqHUyGesw2UFl8imJYL6hLUuu82qQOxuKQcfhX0CrGBlqF1qGnFOQA2KJmFQlP/9P5uuTp+ec4LIzjfV6c77+Oi3NmQMNo9x2nh3D37cXzs79nyyOFEC
 7GpcyZni
 IpNk6/HlKb1YKludru+C96yAarCMW0LDlor5EiAYLUBaSIVYvoh+rQd/02wROOsP3O3QFedYY1jM+S9rkLQyvxYH5+w7AradKGwu/QjA6KY8Yzltra179rBApgtlTl70ZixAZJMCGejLcOoxOe8D8Jjrglp7bquWy87RDEzGbxGBz7rJGhphJxdsvaqkBjl+FR0BpiO8IsGUvu/5QYCooSHx+lnlRXcUCPXIQSE3uHy6F9+LptYUHJzr3Teusp1264qEY9MoHxdrBNe2qh8pkDGEipcD80t2FhyFm7Zo1vj7BeWo/Jm9lktWEzvoQwyXgdyLMWRjSp1204BR5IOmwnQUahQQvRbEIbv+P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/6/26 03:57, Suren Baghdasaryan wrote:
> To correctly propagate error code from lock_vma_range(), change it to
> return the error code instead of the boolean. This simplifies error
> propagation code.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index d32408f7cd5e..023422fcee12 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -162,13 +162,13 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
>  	}
>  }
>  
> -static inline bool lock_vma_range(struct seq_file *m,
> -				  struct proc_maps_locking_ctx *lock_ctx)
> +static inline int lock_vma_range(struct seq_file *m,
> +				 struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	rcu_read_lock();
>  	reset_lock_ctx(lock_ctx);
>  
> -	return true;
> +	return 0;
>  }
>  
>  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
> @@ -245,10 +245,10 @@ static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  	mmap_read_unlock(lock_ctx->mm);
>  }
>  
> -static inline bool lock_vma_range(struct seq_file *m,
> +static inline int lock_vma_range(struct seq_file *m,
>  				  struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	return lock_ctx_mm(lock_ctx) == 0;
> +	return lock_ctx_mm(lock_ctx);
>  }
>  
>  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
> @@ -311,6 +311,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  	struct proc_maps_locking_ctx *lock_ctx;
>  	loff_t last_addr = *ppos;
>  	struct mm_struct *mm;
> +	int err;
>  
>  	/* See m_next(). Zero at the start or after lseek. */
>  	if (last_addr == SENTINEL_VMA_END)
> @@ -328,11 +329,12 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  		return NULL;
>  	}
>  
> -	if (!lock_vma_range(m, lock_ctx)) {
> +	err = lock_vma_range(m, lock_ctx);
> +	if (err) {
>  		mmput(mm);
>  		put_task_struct(priv->task);
>  		priv->task = NULL;
> -		return ERR_PTR(-EINTR);
> +		return ERR_PTR(err);

Looks good: down_read_killable() would also have returned -EINTR.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

